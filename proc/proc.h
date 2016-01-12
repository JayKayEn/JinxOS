#ifndef _PROC_H_
#define _PROC_H_

#include <queue_ts.h>
#include <spinlock.h>
#include <lock.h>
#include <cv.h>
#include <thread.h>

/*
 * Process structure.
 */
struct proc {
    char* name;           /* Name of this process */
    struct spinlock lock;     /* Lock for this structure */
    struct threadarray threads;   /* Threads in this process */

    /* VM */
    struct pde* page_directory;

    /* pid */
    int pid;                    /* the process ID of the current process */

    /* add more material here as needed */
    /* ASST2 */
    struct list* childlist; /* list with all child processes */
    struct lock* childlist_lock; /* lock for child process list */
    struct proc* parent;      /* parent process if not exists NULL */
    int returnvalue;      /* in case of waitpid to store return value */

    /* we need two structs for the files. A hashtable to find the file descriptor and a list with file descriptors to copy them when forking */
    struct fd_table* fd_table;

    struct semaphore* exit_sem_child;
    struct semaphore* exit_sem_parent;
};

#define thisproc (thisthread->proc)

/* This is the process structure for the kernel and for kernel-only threads. */
extern struct proc* kproc;

/* Call once during system startup to allocate data structures. */
void init_proc(void);

struct proc* proc_create(const char* name);

/* Create a fresh process for use by runprogram(). */
struct proc* proc_create_runprogram(const char* name);

/* Destroy a process. */
void proc_destroy(struct proc* proc);

/* Attach a thread to a process. Must not already have a process. */
int proc_addthread(struct proc* proc, struct thread* t);

/* Detach a thread from its process. */
void proc_remthread(struct thread* t);

// get the waitpid status
int status(void);

#endif /* _PROC_H_ */
