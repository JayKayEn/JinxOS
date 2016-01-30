#include <lib.h>
#include <x86.h>
#include <kmm.h>
#include <vmm.h>
#include <proc.h>
#include <pidreg.h>
#include <list.h>
#include <semaphore.h>
#include <elf.h>
#include <errno.h>
#include <gdt.h>

struct proc* procs[NPROC];
struct proc* kproc;

void init_proc(void) {
    assert(thisproc == NULL);

    struct proc* proc = proc_create("[kproc]");
    if (proc == NULL)
        panic("proc_create for kproc failed\n");
    proc->page_directory = kpd;

    int result = proc_addthread(proc, bootcpu->thread);
    if (result)
        panic("proc_addthread\n");

    assert(thisproc != NULL);

    proc->pid = 0;
    procs[proc->pid] = proc;

    kproc = proc;
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

    spinlock_init(&proc->lock);
    threadarray_init(&proc->threads);

    proc->pid = pidreg_getpid();

    proc->child_procs = list_create();
    proc->child_lock = lock_create(name);

    proc->parent = NULL;
    proc->rval = 0;
    proc->psem = semaphore_create("waitpid_psem", 0);
    proc->csem = semaphore_create("waitpid_csem", 0);

    return proc;
}

void
proc_destroy(struct proc* proc) {
    assert(proc != NULL);
    assert(proc != kproc);

    // page directory!

    threadarray_cleanup(&proc->threads);
    spinlock_cleanup(&proc->lock);

    pidreg_returnpid(proc->pid);

    list_destroy(proc->child_procs);
    lock_destroy(proc->child_lock);

    semaphore_destroy(proc->psem);
    semaphore_destroy(proc->csem);

    kfree(proc->name);
    kfree(proc);
}

static void
region_alloc(struct proc* proc, void* va, size_t len) {
    assert(proc != NULL);
    assert(va != NULL);
    assert(va < va + len);

    void* beg = ROUNDDOWN(va, PG_SIZE);
    void* end = ROUNDUP(va + len, PG_SIZE);

    assert(beg < end);

    for (void* i = beg; i < end; i += PG_SIZE) {
        size_t pno = pp_alloc();

        if (page_insert(proc->page_directory, pno, i, true, true) == ENOMEM)
            panic("allocation attempt failed");
    }
}

static void
load_icode(struct proc* proc, uint8_t* binary, const char* name) {
    assert(proc != NULL);
    assert(binary != NULL);

    struct elf* elf = (struct elf*) binary;
    assert(elf->magic == ELF_MAGIC);

    lcr3(PADDR(proc->page_directory));

    struct prog* ph = (struct prog*) ((uint8_t*) elf + elf->phoff);
    struct prog* eph = ph + elf->phnum;
    for (; ph < eph; ++ph) {
        if (ph->type != PT_LOAD)
            continue;

        assert(ph->filesz <= ph->memsz);

        region_alloc(proc, (void*) ph->vaddr, ph->memsz);
        memcpy((void*) ph->vaddr, binary + ph->offset, ph->filesz);
        memset((void*) ph->vaddr + ph->filesz, 0, ph->memsz - ph->filesz);
    }

    lcr3(PADDR(kpd));

    struct thread* thread;
    thread_fork(name, &thread, proc, (int (*)(void*, unsigned long)) elf->entry, NULL, 0);

    thread->context->cs = GD_UT | DPL_USER;
    thread->context->ds = GD_UD | DPL_USER;
    thread->context->es = GD_UD | DPL_USER;
    thread->context->ss = GD_UD | DPL_USER;
    thread->context->esp = (uint32_t) USTACKTOP;
    thread->context->ebp = 0;
    // thread->context->eflags = FL_IF;

    thread->context->eip = (uint32_t) elf->entry;

    region_alloc(proc, (void*) (USTACKTOP - PG_SIZE), PG_SIZE);
}

struct proc *
proc_program(const char* name, uint8_t* binary) {
    assert(name != NULL);
    assert(binary != NULL);

    struct proc *proc = proc_create(name);
    if (proc == NULL)
        return NULL;

    if((proc->page_directory = pgdir_create()) == NULL) {
        proc_destroy(proc);
        return NULL;
    }

    proc->pid = pidreg_getpid();

    load_icode(proc, binary, name);

    return proc;
}

int
proc_addthread(struct proc* proc, struct thread* t) {
    int result;

    assert(t->proc == NULL);

    spinlock_acquire(&proc->lock);
    result = threadarray_add(&proc->threads, t, NULL);
    spinlock_release(&proc->lock);
    if (result)
        return result;
    bool on = cli();
    t->proc = proc;
    ifx(on);
    return 0;
}

void
proc_remthread(struct thread* t) {
    assert(t != NULL);

    struct proc* proc = t->proc;
    assert(proc != NULL);

    spinlock_acquire(&proc->lock);

    unsigned num = threadarray_num(&proc->threads);
    for (unsigned i = 0; i < num; i++) {
        if (threadarray_get(&proc->threads, i) == t) {
            threadarray_remove(&proc->threads, i);
            spinlock_release(&proc->lock);
            bool on = cli();
            t->proc = NULL;
            ifx(on);
            return;
        }
    }

    spinlock_release(&proc->lock);
    panic("Thread (%p) has escaped from its process (%p)\n", t, proc);
}
