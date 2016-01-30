#include <lib.h>
#include <pmm.h>
#include <e820.h>
#include <bitmap.h>
#include <errno.h>
#include <vmm.h>
#include <kmm.h>
#include <lock.h>
#include <queue.h>

struct bitmap* physmap;

void
init_pmm(void) {
    size_t ram = 0;

    struct e820_e* e;
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e)
        ram = MAX(ram, (size_t)(e->addr + e->len));
    npages = ram >> PG_NBITS;
    physmap = bitmap_create(npages);
    for (size_t i = 0; i < npages; ++i) {
        assert(!bitmap_isset(physmap, i));
        bitmap_mark(physmap, i);
    }

    extern size_t _kbrk;
    // Mark any pages with an E820_AVAILABLE entry in the e820 map as free
    // note: assumes that the e820 map references non-overlapping regions
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e) {
        if (e->type == E820_AVAILABLE) {
            size_t min_page = MAX(PA2PM(e->addr), 1U);
            if (min_page >= npages)
                continue;
            size_t max_page = MIN(PA2PM(e->addr + e->len) + 1, npages);
            for (size_t i = min_page; i < max_page; ++i) {
                if (i >= PA2PM(PADDR(KADDR)) && i < PA2PM(PADDR(_kbrk)))
                    continue;
                bitmap_unmark(physmap, i);
            }
        }
    }
}

size_t
pp_alloc(void) {
    size_t idx = 0;
    if (bitmap_alloc(physmap, &idx) == ENOSPC)
        panic("out of physical memory npages");

    memset(PM2VA(idx), 0, PG_SIZE);

    return idx;
}

void
pp_free(void* pa) {
    size_t idx = (size_t) pa >> PG_NBITS;

    assert(idx < npages);
    assert(bitmap_isset(physmap, idx));

    bitmap_unmark(physmap, idx);
}

void
pa_alloc(size_t pa) {
    size_t idx = pa >> PG_NBITS;

    assert(idx < npages);
    assert(bitmap_isset(physmap, idx - 1));
    assert(!bitmap_isset(physmap, idx));

    memset(PM2VA(idx), 0, PG_SIZE);

    bitmap_mark(physmap, idx);
}

#define NPAGES 2048

struct page_registrar {
    struct lock* lk;                // for concurrency control w/o _ts struct
    struct queue* page_reuse;   // store stacks no longer in use
    int page_count;                   // total number of stacks
};

struct page_registrar* kpagereg;

/*
 * Create a page_registrar structure for the system
 */
static void
pagereg_create(void) {
    struct page_registrar* pagereg = kmalloc(sizeof(struct page_registrar));
    if (pagereg == NULL)
        panic("kmalloc failed");


    pagereg->lk = lock_create("pagereg_lock");
    if (pagereg->lk == NULL) {
        kfree(pagereg);
        panic("lock_create failed");
    }

    // queue for reusing stack_addrs
    pagereg->page_reuse = queue_create();
    if (pagereg->page_reuse == NULL) {
        lock_destroy(pagereg->lk);
        kfree(pagereg);
        panic("queue_create failed");
    }

    pagereg->page_count = 0;

    kpagereg = pagereg;
}

// // To be used in the shutdown procedure.
// static void
// pagereg_delete(void) {
//     assert(kpagereg != NULL);

//     lock_acquire(kpagereg->lk);
//     queue_destroy(kpagereg->page_reuse);
//     lock_release(kpagereg->lk);

//     lock_destroy(kpagereg->lk);
//     kfree(kpagereg);
// }

static bool
page_available(void) {
    assert(kpagereg != NULL);

    lock_acquire(kpagereg->lk);
    bool res = kpagereg->page_count < NPAGES || !queue_isempty(kpagereg->page_reuse);
    lock_release(kpagereg->lk);

    return res;
}

void* page_get(void) {
    if (kpagereg == NULL)
        pagereg_create();

    lock_acquire(kpagereg->lk);

    if (!page_available())
        panic("OOM: no more pages available");

    void* page_addr = NULL;
    if (!queue_isempty(kpagereg->page_reuse)) {
        page_addr = (void*) queue_front(kpagereg->page_reuse);
        queue_pop(kpagereg->page_reuse);
        memset(page_addr, 0, STACK_SIZE);
    } else {
        page_addr = kpalloc();
        kpagereg->page_count++;
    }

    lock_release(kpagereg->lk);

    return page_addr;
}

void
page_return(void* page_addr) {
    assert(kpagereg != NULL);

    lock_acquire(kpagereg->lk);

    queue_push(kpagereg->page_reuse, (void*) page_addr);

    lock_release(kpagereg->lk);
}
