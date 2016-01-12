#include <lib.h>
#include <pmm.h>
#include <memlib.h>

extern char _end[];
#define KHEAP ((size_t) _end)

size_t kbrk_min;
size_t kbrk;
size_t kbrk_max;

void
init_mem(void) {
    kbrk_min = ROUNDUP(KHEAP, PG_SIZE);
    kbrk_max = kbrk_min + ROUNDDOWN(MAX_HEAP, PG_SIZE);
    kbrk = kbrk_min;
}

void
term_mem(void) {
    print("term_mem()");
}

void
mem_reset_brk() {
    kbrk = kbrk_min;
}

void*
mem_sbrk(size_t incr) {
    size_t old_brk = kbrk;

    incr = ROUNDUP(incr, PG_SIZE);
    if (kbrk + incr > kbrk_max)
        panic("ERROR: mem_sbrk failed. Ran out of memory...\n");
    kbrk += incr;

    return (void*) old_brk;
}

void*
mem_heap_lo() {
    return (void*) kbrk_min;
}

void*
mem_heap_hi() {
    return (void*) (kbrk - 1);
}

size_t
mem_heapsize() {
    return (size_t) (kbrk - kbrk_min);
}

size_t
mem_pagesize() {
    return (size_t) PG_SIZE;
}
