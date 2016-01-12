#ifndef _LOCK_H_
#define _LOCK_H_

#include <spinlock.h>
#include <thread.h>
#include <wchan.h>

struct lock {
    char* lk_name;

    // name of my owner (use curthread->t_name to set/compare)
    struct thread* lk_owner;

    // # of times my owner has acquired me
    // keep track of this so that # of releases is symmetrical
    int lk_count;

    // queue of threads waiting for lock
    struct wchan* lk_wchan;
    struct spinlock lk_lock;
};

struct lock* lock_create(const char*);
void lock_acquire(struct lock*);

void lock_release(struct lock*);
bool lock_holding(struct lock*);
void lock_destroy(struct lock*);

#endif // _LOCK_H_
