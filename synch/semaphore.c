#include <lib.h>
#include <kmm.h>
#include <semaphore.h>
#include <spinlock.h>
#include <wchan.h>
#include <thread.h>

struct semaphore*
semaphore_create(const char* name, unsigned initial_count) {
    struct semaphore* sem;

    sem = kmalloc(sizeof(struct semaphore));
    if (sem == NULL)
        return NULL;

    sem->sem_name = strdup(name);
    if (sem->sem_name == NULL) {
        kfree(sem);
        return NULL;
    }

    sem->sem_wchan = wchan_create(sem->sem_name);
    if (sem->sem_wchan == NULL) {
        kfree(sem->sem_name);
        kfree(sem);
        return NULL;
    }

    spinlock_init(&sem->sem_lock);
    sem->sem_count = initial_count;

    return sem;
}

void
semaphore_destroy(struct semaphore* sem) {
    assert(sem != NULL);

    /* wchan_cleanup will assert if anyone's waiting on it */
    spinlock_cleanup(&sem->sem_lock);
    wchan_destroy(sem->sem_wchan);
    kfree(sem->sem_name);
    kfree(sem);
}

void
P(struct semaphore* sem) {
    assert(sem != NULL);

    /*
     * May not block in an interrupt handler.
     *
     * For robustness, always check, even if we can actually
     * complete the P without blocking.
     */
    assert(thisthread->in_interrupt == false);

    /* Use the semaphore spinlock to protect the wchan as well. */
    spinlock_acquire(&sem->sem_lock);
    while (sem->sem_count == 0) {
        /*
         *
         * Note that we don't maintain strict FIFO ordering of
         * threads going through the semaphore; that is, we
         * might "get" it on the first try even if other
         * threads are waiting. Apparently according to some
         * textbooks semaphores must for some reason have
         * strict ordering. Too bad. :-)
         *
         * Exercise: how would you implement strict FIFO
         * ordering?
         */
        wchan_sleep(sem->sem_wchan, &sem->sem_lock);
    }
    assert(sem->sem_count > 0);
    sem->sem_count--;
    spinlock_release(&sem->sem_lock);
}

void
V(struct semaphore* sem) {
    assert(sem != NULL);

    spinlock_acquire(&sem->sem_lock);

    sem->sem_count++;
    assert(sem->sem_count > 0);
    wchan_wakeone(sem->sem_wchan, &sem->sem_lock);

    spinlock_release(&sem->sem_lock);
}
