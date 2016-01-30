#include <lib.h>
#include <kmm.h>
#include <pmm.h>
#include <errno.h>
#include <mm.h>
#include <spinlock.h>
#include <memlib.h>

extern size_t kbrk_max;
size_t _kbrk;

void
init_kmm(void) {
    init_mm();
    _kbrk = kbrk_max;
    kbrk_max = ROUNDDOWN(kbrk_max, PG_SIZE);

    spinlock_init(&mem_lock);
}

void*
kpalloc(void) {
    spinlock_acquire(&mem_lock);

    size_t kptr = ROUNDDOWN(kbrk_max - PG_SIZE, PG_SIZE);
    kbrk_max = kptr;
    memset((void*) kptr, 0, PG_SIZE);

    spinlock_release(&mem_lock);

    return (void*) (kptr);
}
