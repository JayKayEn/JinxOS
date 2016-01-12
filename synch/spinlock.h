#ifndef _SPINLOCK_H_
#define _SPINLOCK_H_

struct spinlock {
    volatile unsigned locked;
    struct cpu* cpu;
};

void spinlock_init(struct spinlock* lk);
void spinlock_cleanup(struct spinlock* lk);

void spinlock_acquire(struct spinlock* lk);
void spinlock_release(struct spinlock* lk);

bool spinlock_held(struct spinlock* lk);

extern struct spinlock kernel_spinlock;

static inline void
lock_kernel(void) {
    spinlock_acquire(&kernel_spinlock);
}

static inline void
unlock_kernel(void) {
    spinlock_release(&kernel_spinlock);
    asm volatile("pause");
}

#endif // _SPINLOCK_H_
