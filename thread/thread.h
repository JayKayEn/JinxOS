#ifndef _THREAD_H_
#define _THREAD_H_

#include <lib.h>
#include <spinlock.h>
#include <threadlist.h>
#include <wchan.h>
#include <cpu.h>
#include <array.h>
#include <int.h>

#define STACK_SIZE PG_SIZE

#define NTHREAD 64

typedef enum {      // running, ready, waiting, start, done
    S_RUN,
    S_READY,
    S_SLEEP,
    S_ZOMBIE,
} threadstate_t;

struct thread {
    struct regs* context;      /* Saved register context (on stack) */
    struct threadlistnode listnode;

    char* name;
    const char* wchan_name;
    threadstate_t state;

    struct cpu* cpu;                  /* CPU thread runs on */
    struct proc* proc;                /* Process thread belongs to */

    struct pde* page_directory;
    void* stack;

    /*
     * Interrupt state fields.
     *
     * in_interrupt is true if current execution is in an
     * interrupt handler, which means the thread's normal context
     * of execution is stopped somewhere in the middle of doing
     * something else. This makes assorted operations unsafe.
     *
     * See notes in spinlock.c regarding curspl and iplhigh_count.
     *
     * Exercise for the student: why is this material per-thread
     * rather than per-cpu or global?
     */
    bool in_interrupt;            /* Are we in an interrupt? */

    int rval;                       /* thread return value */

    // we can use a reference to the parent thread to keep track of whether a
    // thread must join with its parent before trying to join
    struct thread* parent;

    /*
     * page 210 of OSPP says that initializing semaphores to 0 allow them to act
     * as a conditional variable. P() and V() are then similar to Cond::signal()
     * and Cond::wait(), respectively. One sem will be used for waiting on the
     * parent and signaling the child, while the other will be used for the
     * opposite tasks.
     */
    struct semaphore* psem;         /* for joining */
    struct semaphore* csem;         /* for joining */

};

DECLARRAY(thread);

#define thisthread (thiscpu->thread)

// Call once during system startup to allocate data structures.
void thread_bootstrap(void);
// Call late in system startup to get secondary CPUs running.
void thread_start_cpus(void);
// Call during panic to stop other threads in their tracks
void thread_panic(void);
// Call during system shutdown to offline other CPUs.
void thread_shutdown(void);

/*
 * Make a new thread, which will start executing at "entrypoint". The
 * thread will belong to the process "proc", or to the current thread's
 * process if "proc" is null. The "data" arguments (one pointer, one
 * number) are passed to the function. The current thread is used as a
 * prototype for creating the new one. Returns an error code. If
 * thread_out is not NULL, the thread is joinable and the thread
 * structure for the new thread is returned through thread_out as an
 * output parameter. If thread_out is NULL, the thread is not joinable
 * and may exit and disappear at any time without notice.
 */
int thread_fork(const char* name, struct thread** thread_out,
                struct proc* proc, int (*entrypoint)(void*, unsigned long),
                void* data1, unsigned long data2);

struct thread* thread_create(const char* name);

/*
 * Cause the current thread to exit.
 * Interrupts need not be disabled.
 */
void thread_exit(int ret);
void thread_destroy(struct thread* thread);
void thread_exorcise(void);

/*
 * Wait for the specified thread to finish if it hasn't already
 * completed; pass back the value it returned through ret_out.
 * Returns an error code.
 */
int thread_join(struct thread* thread, int* ret_out);
void thread_switch(threadstate_t newstate, struct wchan* wc, struct spinlock* lk);
void thread_make_runnable(struct thread* target, bool holding_lock);

/*
 * Cause the current thread to yield to the next runnable thread, but
 * itself stay runnable.
 * Interrupts need not be disabled.
 */
void thread_yield(void);

/*
 * Reshuffle the run queue. Called from the timer interrupt.
 */
void thread_schedule(void);

#endif // _THREAD_H_
