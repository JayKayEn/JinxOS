#include <lib.h>
#include <kmm.h>
#include <err.h>
#include <queue.h>
#include <lock.h>
#include <proc.h>
#include <stackreg.h>
#include <pmm.h>
#include <thread.h>

#define NSTACK 1024

struct stack_registrar {
    struct lock* lk;                // for concurrency control w/o _ts struct
    struct queue* stack_reuse;   // store stacks no longer in use
    int scounter;                   // total number of stacks
};

struct stack_registrar* kstackreg;

static
void
stack_init(void* stack_addr) {
    ((uint32_t*) stack_addr)[0] = THREAD_STACK_MAGIC;
    ((uint32_t*) stack_addr)[1] = THREAD_STACK_MAGIC;
    ((uint32_t*) stack_addr)[2] = THREAD_STACK_MAGIC;
    ((uint32_t*) stack_addr)[3] = THREAD_STACK_MAGIC;
}

/*
 * Create a stack_registrar structure for the system
 */
void stackreg_create(void) {
    struct stack_registrar* stackreg = kmalloc(sizeof(struct stack_registrar));
    if (stackreg == NULL)
        panic("kmalloc failed");


    stackreg->lk = lock_create("stackreg_lock");
    if (stackreg->lk == NULL) {
        kfree(stackreg);
        panic("lock_create failed");
    }

    // queue for reusing stack_addrs
    stackreg->stack_reuse = queue_create();
    if (stackreg->stack_reuse == NULL) {
        lock_destroy(stackreg->lk);
        kfree(stackreg);
        panic("create stackreg->stack_reuse failed");
    }

    stackreg->scounter = 0;

    kstackreg = stackreg;
}


/*
 * Destroy the stack_registrar.
 */
void stackreg_destroy(void) {
    assert(kstackreg != NULL);

    lock_acquire(kstackreg->lk);
    queue_destroy(kstackreg->stack_reuse);
    lock_release(kstackreg->lk);

    lock_destroy(kstackreg->lk);
    kfree(kstackreg);
}

// this checks if a stack_addr is available for use
bool
stack_available(void) {
    assert(kstackreg != NULL);

    lock_acquire(kstackreg->lk);
    bool res = kstackreg->scounter < NSTACK || !queue_isempty(kstackreg->stack_reuse);
    lock_release(kstackreg->lk);

    return res;
}

/*
 * Marks next avaialble stack_addr in registrar's bitmap as in use.
 * Returns this stack_addr.
 */
void* stackreg_get(void) {
    if (kstackreg == NULL)
        stackreg_create();

    lock_acquire(kstackreg->lk);

    if (!stack_available())
        panic("OOM: no more stacks available");

    void* stack_addr = NULL;
    if (!queue_isempty(kstackreg->stack_reuse)) {
        stack_addr = (void*) queue_front(kstackreg->stack_reuse);
        queue_pop(kstackreg->stack_reuse);
        memset(stack_addr, 0, STACK_SIZE);
    } else {
        stack_addr = kalign(STACK_SIZE);
        kstackreg->scounter++;
    }
    stack_init(stack_addr);

    lock_release(kstackreg->lk);

    return stack_addr;
}

// this makes a stack_addr available again to the system
void
stackreg_return(void* stack_addr) {
    assert(kstackreg != NULL);

    lock_acquire(kstackreg->lk);

    queue_push(kstackreg->stack_reuse, (void*) stack_addr);

    lock_release(kstackreg->lk);
}


