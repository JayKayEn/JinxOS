#include <lib.h>
#include <kmm.h>
#include <err.h>

#define KHEAP_MIN 0x10000
#define KHEAP_MAX 0x80000

static size_t kbrk;

void
init_kmm(void) {
    assert(kbrk == 0);

    memset((void*) KHEAP_MIN, 0, KHEAP_MAX - KHEAP_MIN);
    kbrk = KHEAP_MIN;
}

void*
kalloc(size_t nbytes) {
    if (kbrk + nbytes >= KHEAP_MAX)
        panic("out of kernel heap memory");

    size_t kptr = kbrk;
    kbrk += ROUNDUP(nbytes, sizeof(size_t));

    return (void*) kptr;
}

// Does nothing besides check for a valid pointer address
int
kfree(void* kptr) {
    size_t pa = (size_t) kptr;

    if (pa < KHEAP_MIN || pa >= KHEAP_MAX)
        return EBOUND;

    return 0;
}
