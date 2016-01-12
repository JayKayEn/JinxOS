#include <lib.h>
#include <x86.h>
#include <kmm.h>
#include <vmm.h>
#include <proc.h>
#include <pidreg.h>
#include <list.h>
#include <semaphore.h>

struct proc* kproc;

/*
 * Create the process structure for the kernel.
 */
void
proc_bootstrap(void) {
    assert(thisproc == NULL);

    kproc = proc_create("[kproc]");
    if (kproc == NULL)
        panic("proc_create for kproc failed\n");
    kproc->page_directory = kpd;

    int result = proc_addthread(kproc, bootcpu->thread);
    if (result)
        panic("proc_addthread\n");

    assert(thisproc != NULL);
}

void init_proc(void) {
    proc_bootstrap();
}

struct proc*
proc_create(const char* name) {
    struct proc* proc;

    proc = kmalloc(sizeof(*proc));
    if (proc == NULL)
        return NULL;
    proc->name = strdup(name);
    if (proc->name == NULL) {
        kfree(proc);
        return NULL;
    }


    // /* File Descriptor Table */
    // proc->fd_table = fd_table_create(proc);
    // if (proc->fd_table == NULL){
    //     kfree(proc->name);
    //     kfree(proc);
    //     return NULL;
    // }

    // // add file descriptors for stdin, stdoud, stderr
    // // we can not do this for the kernel process since VFS is not yet bootstrapped

    // if (kproc!=NULL) {
    //     int fdi_0, fdi_1, fdi_2;
    //     int temp_res = 0;

    //     char* console_0 = strdup("con:");
    //     char* console_1 = strdup("con:");
    //     char* console_2 = strdup("con:");

    //     temp_res = fd_open(proc->fd_table, console_0, O_RDONLY, &fdi_0);
    //     assert(temp_res == 0);
    //     temp_res = fd_open(proc->fd_table, console_1, O_WRONLY, &fdi_1);
    //     assert(temp_res == 0);
    //     temp_res = fd_open(proc->fd_table, console_2, O_WRONLY, &fdi_2);
    //     assert(temp_res == 0);

    //     assert(fdi_2 ==2);
    // }

    threadarray_init(&proc->threads);
    spinlock_init(&proc->lock);

    /* Process ID */
    proc->pid = pidreg_getpid();

    /* Child list */
    proc->childlist = list_create();

    proc->parent = NULL;
    proc->returnvalue = 0;
    proc->childlist_lock = lock_create(name);
    proc->childlist_lock = lock_create(name);
    proc->exit_sem_child = semaphore_create("wait_sem_child", 0);
    proc->exit_sem_parent = semaphore_create("wait_sem_parent", 0);
    return proc;
}

/*
 * Destroy a proc structure.
 *
 * Note: nothing currently calls this. Your wait/exit code will
 * probably want to do so.
 */
void
proc_destroy(struct proc* proc) {
    /*
     * You probably want to destroy and null out much of the
     * process (particularly the address space) at exit time if
     * your wait/exit design calls for the process structure to
     * hang around beyond process exit. Some wait/exit designs
     * do, some don't.
     */

    assert(proc != NULL);
    assert(proc != kproc);

    /*
     * We don't take p_lock in here because we must have the only
     * reference to this structure. (Otherwise it would be
     * incorrect to destroy it.)
     */

    // /* VM fields */
    // if (proc->page_directory) {
    // if (proc->addrspace) {
    //     /*
    //      * If p is the current process, remove it safely from
    //      * p_addrspace before destroying it. This makes sure
    //      * we don't try to activate the address space while
    //      * it's being destroyed.
    //      *
    //      * Also explicitly deactivate, because setting the
    //      * address space to NULL won't necessarily do that.
    //      *
    //      * (When the address space is NULL, it means the
    //      * process is kernel-only; in that case it is normally
    //      * ok if the MMU and MMU- related data structures
    //      * still refer to the address space of the last
    //      * process that had one. Then you save work if that
    //      * process is the next one to run, which isn't
    //      * uncommon. However, here we're going to destroy the
    //      * address space, so we need to make sure that nothing
    //      * in VM system still refers to it.)
    //      *
    //      * The call to as_deactivate() must come after we
    //      * clear the address space, or a timer interrupt might
    //      * reactivate the old address space again behind our
    //      * back.
    //      *
    //      * If p is not the current process, still remove it
    //      * from p_addrspace before destroying it as a
    //      * precaution. Note that if p is not the current
    //      * process, in order to be here p must either have
    //      * never run (e.g. cleaning up after fork failed) or
    //      * have finished running and exited. It is quite
    //      * incorrect to destroy the proc structure of some
    //      * random other process while it's still running...
    //      */
    //     struct addrspace *as;

    //     if (proc == curproc) {
    //         as = proc_setas(NULL);
    //         as_deactivate();
    //     }
    //     else {
    //         as = proc->addrspace;
    //         proc->addrspace = NULL;
    //     }
    //     as_destroy(as);
    // }

    threadarray_cleanup(&proc->threads);
    spinlock_cleanup(&proc->lock);

    pidreg_returnpid(proc->pid);

    /* Child list */
    list_destroy(proc->childlist);
    lock_destroy(proc->childlist_lock);
    // fd_table_destroy(proc->fd_table);

    kfree(proc->name);
    kfree(proc);
}

// /*
//  * Create a fresh proc for use by runprogram.
//  *
//  * It will have no address space and will inherit the current
//  * process's (that is, the kernel menu's) current directory.
//  */
// struct proc *
// proc_create_runprogram(const char *name)
// {
//     struct proc *proc;

//     proc = proc_create(name);
//     if (proc == NULL) {
//         return NULL;
//     }

//     /* VM fields */

//     proc->addrspace = NULL;

//     /* VFS fields */

//     spinlock_acquire(&curproc->lock);
//     /* we don't need to lock proc->lock as we have the only reference */
//     if (curproc->cwd != NULL) {
//         VOP_INCREF(curproc->cwd);
//         proc->cwd = curproc->cwd;
//     }
//     spinlock_release(&curproc->lock);

//     /* Process ID */
//     //proc->pid = pidreg_getpid();

//     return proc;
// }

/*
 * Add a thread to a process. Either the thread or the process might
 * or might not be current.
 *
 * Turn off interrupts on the local cpu while changing t_proc, in
 * case it's current, to protect against the as_activate call in
 * the timer interrupt context switch, and any other implicit uses
 * of "curproc".
 */
int
proc_addthread(struct proc* proc, struct thread* t) {
    int result;

    assert(t->proc == NULL);

    spinlock_acquire(&proc->lock);
    result = threadarray_add(&proc->threads, t, NULL);
    spinlock_release(&proc->lock);
    if (result)
        return result;
    t->proc = proc;
    return 0;
}

/*
 * Remove a thread from its process. Either the thread or the process
 * might or might not be current.
 *
 * Turn off interrupts on the local cpu while changing t_proc, in
 * case it's current, to protect against the as_activate call in
 * the timer interrupt context switch, and any other implicit uses
 * of "curproc".
 */
void
proc_remthread(struct thread* t) {
    assert(t != NULL);

    struct proc* proc = t->proc;
    assert(proc != NULL);

    spinlock_acquire(&proc->lock);
    /* ugh: find the thread in the array */
    unsigned num = threadarray_num(&proc->threads);
    for (unsigned i = 0; i < num; i++) {
        if (threadarray_get(&proc->threads, i) == t) {
            threadarray_remove(&proc->threads, i);
            spinlock_release(&proc->lock);
            t->proc = NULL;
            return;
        }
    }
    /* Did not find it. */
    spinlock_release(&proc->lock);
    panic("Thread (%p) has escaped from its process (%p)\n", t, proc);
}
