#ifndef _PROC_H_
#define _PROC_H_

#include <queue_ts.h>
#include <spinlock.h>
#include <lock.h>
#include <cv.h>
#include <thread.h>

enum {
    P_AVAILABLE,
    P_STARTED,
    P_SLEEPING,
    P_RUNNABLE,
    P_RUNNING,
    P_ZOMBIE
};

#define NPROC 1024

/*
 * Process structure.
 */
struct proc {
    char* name;                     // Name of this process
    struct spinlock lock;           // Lock for this structure
    struct threadarray threads;     // Threads in this process

    struct pde* page_directory;

    int pid;                        // the process ID of the current process

    struct list* child_procs;         // list with all child processes
    struct lock* child_lock;    // lock for child process list
    struct proc* parent;            // parent process if not exists NULL
    int rval;                       // in case of waitpid to store return value

    struct semaphore* psem;
    struct semaphore* csem;
};

#define thisproc (thisthread->proc)

extern struct proc* kproc;
extern struct proc* procs[NPROC];

void init_proc(void);

struct proc* proc_create(const char* name);
void proc_destroy(struct proc* proc);

struct proc* proc_program(const char* name, uint8_t* binary);

int proc_addthread(struct proc* proc, struct thread* t);
void proc_remthread(struct thread* t);

#define proc_binary(program)                                       \
    do {                                                           \
        extern uint8_t (_binary_obj_ ## program ## _start)[];         \
        proc_program("program", _binary_obj_ ## program ## _start); \
    } while (0)

#endif // _PROC_H_
