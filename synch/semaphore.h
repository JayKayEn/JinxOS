#ifndef _SEMAPHORE_H_
#define _SEMAPHORE_H_

#include <spinlock.h>

struct semaphore {
    char* sem_name;
    struct wchan* sem_wchan;
    struct spinlock sem_lock;
    volatile unsigned sem_count;
};

struct semaphore* semaphore_create(const char*, unsigned);
void semaphore_destroy(struct semaphore*);

/*
 * Operations (both atomic):
 *     P (proberen): decrement count. If the count is 0, block until
 *                   the count is 1 again before decrementing.
 *     V (verhogen): increment count.
 */
void P(struct semaphore*);
void V(struct semaphore*);

#endif // _SEMAPHORE_H_
