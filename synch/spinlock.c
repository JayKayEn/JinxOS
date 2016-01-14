#include <lib.h>
#include <spinlock.h>
#include <x86.h>
#include <cpu.h>
#include <thread.h>

struct spinlock kernel_spinlock = {0};

bool
spinlock_held(struct spinlock* lk) {
    assert(lk != NULL);
    asm volatile ("mfence" ::: "memory");
    return lk->locked && lk->cpu == thiscpu;
}

void
spinlock_init(struct spinlock* lk) {
    assert(lk != NULL);

    lk->locked = 0;
    lk->cpu = NULL;
}

static bool iflag;

void
spinlock_acquire(struct spinlock* lk) {
    assert(lk != NULL);
    assert(!spinlock_held(lk));

    iflag = cli();

    while (xchg(&lk->locked, 1) != 0)
        asm volatile ("pause");

    if (thiscpu != NULL) {
        lk->cpu = thiscpu;
        lk->cpu->spinlocks++;
    }

    // memory_barrier();       // No re-orderings around xchg
}

void
spinlock_release(struct spinlock* lk) {
    assert(lk != NULL);
    assert(spinlock_held(lk));

    if (thiscpu != NULL) {
        lk->cpu->spinlocks--;
        lk->cpu = NULL;
    }

    xchg(&lk->locked, 0);

    // memory_barrier();       // No re-orderings around xchg

    ifx(iflag);

}


void
spinlock_cleanup(struct spinlock* lk) {
    assert(lk != NULL);
    assert(!spinlock_held(lk));

    lk->locked = 0;
    lk->cpu = NULL;
}
