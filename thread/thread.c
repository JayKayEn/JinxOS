#include <lib.h>
#include <x86.h>
#include <kmm.h>
#include <pmm.h>
#include <vmm.h>
#include <thread.h>
#include <threadlist.h>
#include <cpu.h>
#include <proc.h>
#include <wchan.h>
#include <array.h>
#include <semaphore.h>
#include <stackreg.h>
#include <err.h>
#include <switchframe.h>
#include <debug.h>

DEFARRAY(thread, );

static
void
thread_checkstack(struct thread *thread) {
    assert(thread->stack != NULL);
    assert(((uint32_t*) thread->stack)[0] = THREAD_STACK_MAGIC);
    assert(((uint32_t*) thread->stack)[1] = THREAD_STACK_MAGIC);
    assert(((uint32_t*) thread->stack)[2] = THREAD_STACK_MAGIC);
    assert(((uint32_t*) thread->stack)[3] = THREAD_STACK_MAGIC);
}

struct thread*
thread_create(const char* name) {
    struct thread* thread = kmalloc(sizeof(struct thread));
    if (thread == NULL)
        return NULL;

    assert(name != NULL);
    thread->name = strdup(name);
    if (thread->name == NULL) {
        kfree(thread);
        return NULL;
    }

    thread->wchan_name = "NEW";
    thread->state = S_READY;

    threadlistnode_init(&thread->listnode, thread);

    thread->cpu = NULL;
    thread->proc = NULL;

    thread->page_directory = NULL;
    thread->stack = NULL;

    thread->in_interrupt = false;

    thread->rval = -1;
    thread->parent = NULL;
    thread->psem = NULL;
    thread->csem = NULL;

    return thread;
}

int
thread_fork(const char* name, struct thread** thread_out,
        struct proc* proc, int (*entrypoint)(void*, unsigned long),
        void* data1, unsigned long data2) {

    struct thread* newthread = thread_create(name);
    if (newthread == NULL)
        return ENOMEM;

    newthread->stack = stackreg_get();
    if (newthread->stack == NULL) {
        thread_destroy(newthread);
        return ENOMEM;
    }
    thread_checkstack(newthread);

    newthread->cpu = thiscpu;
    newthread->page_directory = thisthread->page_directory;

    if (thread_out != NULL) {
        *thread_out = newthread;
        newthread->parent = thisthread;

        newthread->csem = semaphore_create(name, 0);
        if (newthread->csem == NULL) {
            thread_destroy(newthread);
            return ENOMEM;
        }

        newthread->psem = semaphore_create(name, 0);
        if (newthread->psem == NULL) {
            semaphore_destroy(newthread->csem);
            thread_destroy(newthread);
            return ENOMEM;
        }
    }

    int result = proc_addthread(proc ? proc : thisthread->proc, newthread);
    if (result) {
        if (thread_out != NULL) {
            semaphore_destroy(newthread->psem);
            semaphore_destroy(newthread->csem);
        }
        thread_destroy(newthread);
        return result;
    }

    switchframe_init(newthread, entrypoint, data1, data2);

    thread_make_runnable(newthread, false);

    return 0;
}

void
thread_switch(threadstate_t newstate, struct wchan* wc, struct spinlock* lk) {
    assert(thiscpu->thread == thisthread);
    assert(thisthread->cpu == thiscpu->self);

    // we may already have stackreg's spinlock and we can't reacquire it so skip
    // exorcising if going to sleep
    if (newstate != S_SLEEP)
        thread_exorcise();

    /*
     * If we're idle, return without doing anything. this happens
     * when the timer interrupt interrupts the idle loop.
     */
    if (thiscpu->status == CPU_IDLE)
        return;

    thread_checkstack(thisthread);

    // asm volatile ("mfence" ::: "memory");  // uncomment?

    spinlock_acquire(&thiscpu->active_threads_lock);

    switch (newstate) {
        case S_RUN:
            panic("Illegal S_RUN in thread_switch\n");
        case S_READY: {
            // if thisthread is the only thread, just return
            if (threadlist_isempty(&thiscpu->active_threads)) {
                spinlock_release(&thiscpu->active_threads_lock);
                return;
            }
            thread_make_runnable(thisthread, true /* holding_lock */);
            break;
        }
        case S_SLEEP:
            thisthread->wchan_name = wc->wc_name;
            threadlist_addtail(&wc->wc_threads, thisthread);
            spinlock_release(lk);
            break;
        case S_ZOMBIE:
            thisthread->wchan_name = "ZOMBIE";
            threadlist_addtail(&thiscpu->zombie_threads, thisthread);
            break;
    }
    thisthread->state = newstate;

    thiscpu->status = CPU_IDLE;
    struct thread* next = NULL;
    do {
        next = threadlist_remhead(&thiscpu->active_threads);
        if (next == NULL) {
            spinlock_release(&thiscpu->active_threads_lock);
            cpu_idle();
            spinlock_acquire(&thiscpu->active_threads_lock);
        }
    } while (next == NULL);

    thiscpu->status = CPU_STARTED;
    next->wchan_name = NULL;
    next->state = S_RUN;
    thisthread = next;

    // lcr3(PADDR(thisthread->page_directory));

    spinlock_release(&thiscpu->active_threads_lock);

    switchframe_switch(next->context);

    panic("switchframe_switch returned");
}

void
thread_yield(void) {
    thread_switch(S_READY, NULL, NULL);
}

void
thread_startup(int (*entrypoint)(void *data1, unsigned long data2),
               void *data1, unsigned long data2) {
    assert(thisthread != NULL);

    /* Clear the wait channel and set the thread state. */
    thisthread->wchan_name = NULL;
    thisthread->state = S_RUN;

    thread_exorcise();

    /* Activate our address space in the MMU. */
    // lcr3(PADDR(thisthread->page_directory));

    /* Enable interrupts. */
    // sti();

    int ret = entrypoint(data1, data2);

    thread_exit(ret);
}

void
thread_exit(int ret) {
    thisthread->rval = ret;

    if(thisthread->parent != NULL) {
        V(thisthread->psem);
        P(thisthread->csem);

        semaphore_destroy(thisthread->psem);
        semaphore_destroy(thisthread->csem);

        thisthread->psem = NULL;
        thisthread->csem = NULL;

        thisthread->parent = NULL;
    }

    proc_remthread(thisthread);
    assert(thisthread->proc == NULL);

    /* Interrupts off on thisthread processor */
    cli();
    thread_switch(S_ZOMBIE, NULL, NULL);

    panic("thread_switch returned\n");
}

void
thread_destroy(struct thread* thread) {
    assert(thread != thisthread);
    assert(thread->state != S_RUN);
    assert(thread->proc == NULL);

    // if (thread->page_directory != NULL)
    //     kfree(thread->page_directory);      // not correct

    stackreg_return(thread->stack);

    threadlistnode_cleanup(&thread->listnode);

    thread->wchan_name = "DESTROYED";

    kfree(thread->name);
    kfree(thread);
}

void
thread_exorcise(void) {
    struct thread* thread;

    while ((thread = threadlist_remhead(&thiscpu->zombie_threads)) != NULL) {
        assert(thread != NULL);
        // if (thread == thisthread)
        //     continue;
        assert(thread != thisthread);
        assert(thread->state == S_ZOMBIE);
        thread_destroy(thread);
    }
}

int thread_join(struct thread* thread, int* ret_out) {
    assert(thread != NULL);
    assert(ret_out != NULL);
    assert(thread->parent != NULL);

    if (thread == thisthread)
        return EDEADLK;

    assert(thread->parent == thisthread);

    P(thread->psem);
    V(thread->csem);

    *ret_out = thread->rval;
    thread->parent = NULL;

    return 0;
}

void thread_start_cpus(void) {

}

void thread_panic(void) {

}

void thread_shutdown(void) {

}

void
thread_make_runnable(struct thread* thread, bool holding_lock) {
    struct cpu* cpu = thread->cpu;

    thread->state = S_READY;

    if (holding_lock)
        assert(spinlock_held(&cpu->active_threads_lock));
    else
        spinlock_acquire(&cpu->active_threads_lock);

    threadlist_addtail(&cpu->active_threads, thread);

    /*
     * Other processor is idle; send interrupt to make
     * sure it unidles.
     */
    if (cpu->status == CPU_IDLE) {
        // ipi_send(cpu, IPI_UNIDLE);
        panic("CPU_IDLE");
    }

    if (!holding_lock)
        spinlock_release(&cpu->active_threads_lock);
}
