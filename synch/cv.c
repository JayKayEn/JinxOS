#include <lib.h>
#include <kmm.h>
#include <cv.h>
#include <spinlock.h>
#include <wchan.h>

struct cv*
cv_create(const char* name) {
    struct cv* cv;

    cv = kmalloc(sizeof(struct cv));
    if (cv == NULL)
        return NULL;

    cv->cv_name = strdup(name);
    if (cv->cv_name == NULL) {
        kfree(cv);
        return NULL;
    }

    // Initialize cv fields
    cv->cv_wchan = wchan_create(cv->cv_name);
    spinlock_init(&cv->cv_splock);

    return cv;
}

void
cv_destroy(struct cv* cv) {
    assert(cv != NULL);

    // wchan_cleanup will assert if anyone's waiting on it
    spinlock_cleanup(&cv->cv_splock);
    wchan_destroy(cv->cv_wchan);

    // provided code
    kfree(cv->cv_name);
    kfree(cv);
}

void
cv_wait(struct cv* cv, struct lock* lock) {
    // Acquire spinlock
    spinlock_acquire(&cv->cv_splock);

    // release the passed in lock so it can be acquired by other
    // threads while this thread is down for the count.
    //
    // this is ok since we still hold the spinlock.
    lock_release(lock);

    // let other threads have their turns while this is put on the
    // waiting queue.
    //
    // spinlock will be released, so other threads can acquire it,
    // and reacquired before this returns.
    wchan_sleep(cv->cv_wchan, &cv->cv_splock);

    // release the spinlock.
    spinlock_release(&cv->cv_splock);

    // acquire the lock again
    lock_acquire(lock);
}

void
cv_signal(struct cv* cv, struct lock* lock) {
    // acquire spinlock for atomicity
    spinlock_acquire(&cv->cv_splock);

    // release lock so other thread can use it
    lock_release(lock);

    // move one TCB in the waiting queue from waiting to ready
    wchan_wakeone(cv->cv_wchan, &cv->cv_splock);

    // release spinlock
    spinlock_release(&cv->cv_splock);

    // reacquire lock while we have control again
    lock_acquire(lock);
}

void
cv_broadcast(struct cv* cv, struct lock* lock) {
    // acquire spinlock
    spinlock_acquire(&cv->cv_splock);

    // release lock so other thread can use it
    lock_release(lock);

    // move all TCBs in cv's waiting queue from waiting to ready
    wchan_wakeall(cv->cv_wchan, &cv->cv_splock);

    // release spinlock
    spinlock_release(&cv->cv_splock);

    // reacquire lock while we have control again
    lock_acquire(lock);
}
