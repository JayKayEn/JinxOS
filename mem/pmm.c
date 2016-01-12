#include <lib.h>
#include <pmm.h>
#include <e820.h>
#include <bitmap.h>
#include <err.h>
#include <vmm.h>

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
