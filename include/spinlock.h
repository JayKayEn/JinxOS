#ifndef _SPINLOCK_H_
#define _SPINLOCK_H_

#include <cpu.h>

struct spinlock {
    volatile unsigned locked;
    struct cpu* cpu;
};

void spinlock_init(struct spinlock *lk);
void spinlock_term(struct spinlock *lk);

void spinlock_acq(struct spinlock *lk);
void spinlock_rel(struct spinlock *lk);

extern struct spinlock kernel_spinlock;

static inline void
lock_kernel(void) {
    spinlock_acq(&kernel_spinlock);
}

static inline void
unlock_kernel(void) {
    spinlock_rel(&kernel_spinlock);

    // Normally we wouldn't need to do this, but QEMU only runs
    // one CPU at a time and has a long time-slice.  Without the
    // pause, this CPU is likely to reacquire the lock before
    // another CPU has even been given a chance to acquire it.
    asm volatile("pause");
}

#endif // _SPINLOCK_H_
