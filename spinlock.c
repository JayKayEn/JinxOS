#include <lib.h>
#include <spinlock.h>
#include <x86.h>

struct spinlock kernel_spinlock = {0};

static bool
spinlock_held(struct spinlock* lk) {
    assert(lk != NULL);
    return lk->locked != 0;
}

void
spinlock_init(struct spinlock* lk) {
    assert(lk != NULL);

    lk->locked = 0;
    lk->cpu = NULL;
}

void
spinlock_term(struct spinlock* lk) {
    assert(lk != NULL);
    assert(!spinlock_held(lk));

    lk->locked = 0;
    lk->cpu = NULL;
}

void
spinlock_acq(struct spinlock* lk) {
    assert(lk != NULL);
    assert(!spinlock_held(lk));

    // xchg is atomic and serializes instructions so reads do not get reordered
    // after writes.
    while (xchg(&lk->locked, 1) != 0)
        asm volatile ("pause");
}

void
spinlock_rel(struct spinlock* lk) {
    assert(lk != NULL);
    assert(spinlock_held(lk));

    lk->cpu = NULL;

    xchg(&lk->locked, 0);
}
