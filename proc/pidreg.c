#include <lib.h>
#include <kmm.h>
#include <err.h>
#include <bitmap_ts.h>
#include <queue_ts.h>
#include <lock.h>
#include <proc.h>
#include <pidreg.h>

#define NPID    ((int) BIT(15))
#define PID_MIN 0

struct pid_registrar {
    struct lock* lk;                // for concurrency control w/o _ts struct
    struct bitmap_ts* pmap;         // mark which pids are in use
    struct queue_ts* pid_reuse;     // store pids no longer in use
    int pcounter;                   // determines next new pid
};

struct pid_registrar* kpidreg;

/*
 * Create a pid_registrar structure for the system
 */
void pidreg_create(void) {
    struct pid_registrar* pidreg = kmalloc(sizeof(struct pid_registrar));
    if (pidreg == NULL)
        panic("kmalloc failed");


    pidreg->lk = lock_create("pidreg_lock");
    if (pidreg->lk == NULL) {
        kfree(pidreg);
        panic("lock_create failed");
    }

    // marks which pids are in use
    pidreg->pmap = bitmap_ts_create(NPID);
    if (pidreg->pmap == NULL) {
        lock_destroy(pidreg->lk);
        kfree(pidreg);
        panic("create pidreg->pmap failed");
    }

    // queue for reusing pids
    pidreg->pid_reuse = queue_ts_create();
    if (pidreg->pid_reuse == NULL) {
        bitmap_ts_destroy(pidreg->pmap);
        lock_destroy(pidreg->lk);
        kfree(pidreg);
        panic("create pidreg->pid_reuse failed");
    }

    pidreg->pcounter = PID_MIN;

    kpidreg = pidreg;
}


/*
 * Destroy the pid_registrar.
 */
void pidreg_destroy(void) {
    assert(kpidreg != NULL);

    lock_acquire(kpidreg->lk);

    bitmap_ts_destroy(kpidreg->pmap);
    queue_ts_destroy(kpidreg->pid_reuse);

    lock_release(kpidreg->lk);

    lock_destroy(kpidreg->lk);
    kfree(kpidreg);
}

// this checks if a pid is available for use
static bool
pid_available(void) {
    assert(kpidreg != NULL);

    lock_acquire(kpidreg->lk);
    bool res = kpidreg->pcounter < NPID || !queue_ts_isempty(kpidreg->pid_reuse);
    lock_release(kpidreg->lk);

    return res;
}

/*
 * Marks next avaialble pid in registrar's bitmap as in use.
 * Returns this pid.
 */
int pidreg_getpid(void) {
    if (kpidreg == NULL)
        pidreg_create();

    lock_acquire(kpidreg->lk);

    if (!pid_available())
        return EMPROC;

    int pid = !queue_ts_isempty(kpidreg->pid_reuse)
              ? (int) queue_ts_pop(kpidreg->pid_reuse)
              : kpidreg->pcounter++;
    assert(!bitmap_ts_isset(kpidreg->pmap, pid));
    bitmap_ts_mark(kpidreg->pmap, pid);

    lock_release(kpidreg->lk);

    return pid;
}

// this checks that a pid is in bounds and is in use
bool
pid_used(int pid) {
    assert(kpidreg != NULL);
    assert(pid < NPID);

    lock_acquire(kpidreg->lk);
    // int res = fd >= PID_MIN && fd < NPID && bitmap_ts_isset(kpidreg->pmap, pid);
    // changed the above line to the below line... pid instead of fd... is that right? :)
    bool res = pid < kpidreg->pcounter && bitmap_ts_isset(kpidreg->pmap, pid);

    lock_release(kpidreg->lk);

    return res;
}

// this makes a pid available again to the system
void pidreg_returnpid(int pid) {
    assert(kpidreg != NULL);
    assert(pid_used(pid));

    lock_acquire(kpidreg->lk);

    bitmap_ts_unmark(kpidreg->pmap, pid);
    queue_ts_push(kpidreg->pid_reuse, (void*) pid);

    lock_release(kpidreg->lk);
}


