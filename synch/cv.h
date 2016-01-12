#ifndef _CV_H_
#define _CV_H_

#include <spinlock.h>
#include <lock.h>

struct cv {
    char* cv_name;
    struct wchan* cv_wchan;
    struct spinlock cv_splock;
};

struct cv* cv_create(const char*);
void cv_destroy(struct cv*);

/*
 * Operations:
 *    cv_wait      - Release the supplied lock, go to sleep, and, after
 *                   waking up again, re-acquire the lock.
 *    cv_signal    - Wake up one thread that's sleeping on this CV.
 *    cv_broadcast - Wake up all threads sleeping on this CV.
 *
 * For all three operations, the current thread must hold the lock passed
 * in. Note that under normal circumstances the same lock should be used
 * on all operations with any particular CV.
 *
 * These operations must be atomic. You get to write them.
 */
void cv_wait(struct cv*, struct lock*);
void cv_signal(struct cv*, struct lock*);
void cv_broadcast(struct cv*, struct lock*);

#endif // _CV_H_
