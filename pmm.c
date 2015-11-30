#include <lib.h>
#include <pmm.h>
#include <e820.h>
#include <kadt.h>
#include <err.h>

static struct kbitmap* physmap;
static const size_t pages;

void init_pmm(void) {
    size_t mem = 0;

    size_t i;
    struct e820_e* e;
    for (i = 0, e = e820_map.entries; i != e820_map.size; ++i, ++e)
        mem = MAX(mem, (size_t)(e->addr + e->len));

    size_t pages = mem >> PG_NBITS;
    physmap = kbitmap_create(pages);

    extern char _end[];
    size_t endpg = (size_t) _end >> 12;
    for (i = 0; i < endpg; ++i)
        kbitmap_mark(physmap, i);
}

void* pg_alloc(void) {
    size_t idx = 0;
    if (kbitmap_alloc(physmap, &idx) == ENOSPC)
        panic("out of physical memory pages");

    return (void*) (idx << PG_NBITS);
}

void pg_free(void* pa) {
    size_t idx = (size_t) pa >> PG_NBITS;

    assert(idx < pages);
    assert(kbitmap_isset(physmap, idx));

    kbitmap_unmark(physmap, idx);
}
