#include <lib.h>
#include <thread.h>
#include <threadlist.h>
#include <wchan.h>
#include <kmm.h>
#include <spinlock.h>
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
static struct spinlock allwchans_lock;
static struct wchanarray allwchans;


////////////////////////////////////////////////////////////

/*
 * Wait channel functions
 */

void
init_wchan(void) {
    spinlock_init(&allwchans_lock);
    wchanarray_init(&allwchans);
}


/*
 * Create a wait channel. NAME is a symbolic string name for it.
 * This is what's displayed by ps -alx in Unix.
 *
 * NAME should generally be a string constant. If it isn't, alternate
 * arrangements should be made to free it after the wait channel is
 * destroyed.
 */
struct wchan*
wchan_create(const char* name) {
    int result;

    struct wchan* wc = kmalloc(sizeof(struct wchan));
    if (wc == NULL)
        return NULL;
    threadlist_init(&wc->wc_threads);
    wc->wc_name = name;

    /* add to allwchans[] */
    spinlock_acquire(&allwchans_lock);
    result = wchanarray_add(&allwchans, wc, &wc->wc_index);
    spinlock_release(&allwchans_lock);
    if (result) {
        assert(result == ENOMEM);
        threadlist_cleanup(&wc->wc_threads);
        kfree(wc);
        return NULL;
    }

    return wc;
}

/*
 * Destroy a wait channel. Must be empty and unlocked.
 * (The corresponding cleanup functions require this.)
 */
void
wchan_destroy(struct wchan* wc) {
    unsigned num;
    struct wchan* wc2;

    /* remove from allwchans[] */
    spinlock_acquire(&allwchans_lock);
    num = wchanarray_num(&allwchans);
    assert(wchanarray_get(&allwchans, wc->wc_index) == wc);
    if (wc->wc_index < num - 1) {
        /* move the last entry into our slot */
        wc2 = wchanarray_get(&allwchans, num - 1);
        wchanarray_set(&allwchans, wc->wc_index, wc2);
        wc2->wc_index = wc->wc_index;
    }
    wchanarray_setsize(&allwchans, num - 1);
    spinlock_release(&allwchans_lock);

    threadlist_cleanup(&wc->wc_threads);
    kfree(wc);
}

/*
 * Yield the cpu to another process, and go to sleep, on the specified
 * wait channel WC, whose associated spinlock is LK. Calling wakeup on
 * the channel will make the thread runnable again. The spinlock must
 * be locked. The call to thread_switch unlocks it; we relock it
 * before returning.
 */
void
wchan_sleep(struct wchan* wc, struct spinlock* lk) {
    asm volatile ("mfence" ::: "memory");
    /* may not sleep in an interrupt handler */
    assert(!thisthread->in_interrupt);

    /* must hold the spinlock */
    assert(spinlock_held(lk));

    /* must not hold other spinlocks */
    assert(thiscpu->spinlocks == 1);

    // thread_switch(S_SLEEP, wc, lk);
    sys_sleep(wc, lk);

    spinlock_acquire(lk);
}

/*
 * Wake up one thread sleeping on a wait channel.
 */
void
wchan_wakeone(struct wchan* wc, struct spinlock* lk) {
    struct thread* target;

    assert(spinlock_held(lk));

    /* Grab a thread from the channel */
    target = threadlist_remhead(&wc->wc_threads);

    if (target == NULL) {
        /* Nobody was sleeping. */
        return;
    }

    /*
     * Note that thread_make_runnable acquires a runqueue lock
     * while we're holding LK. This is ok; all spinlocks
     * associated with wchans must come before the runqueue locks,
     * as we also bridge from the wchan lock to the runqueue lock
     * in thread_sleep.
     */

    thread_make_runnable(target, false);
}

/*
 * Wake up all threads sleeping on a wait channel.
 */
void
wchan_wakeall(struct wchan* wc, struct spinlock* lk) {
    assert(spinlock_held(lk));

    struct threadlist list = {0};
    threadlist_init(&list);

    /*
     * Grab all the threads from the channel, moving them to a
     * private list.
     */
    struct thread* target = NULL;
    while ((target = threadlist_remhead(&wc->wc_threads)) != NULL)
        threadlist_addtail(&list, target);

    /*
     * We could conceivably sort by cpu first to cause fewer lock
     * ops and fewer IPIs, but for now at least don't bother. Just
     * make each thread runnable.
     */
    while ((target = threadlist_remhead(&list)) != NULL)
        thread_make_runnable(target, false);

    threadlist_cleanup(&list);
}

/*
 * Return nonzero if there are no threads sleeping on the channel.
 * This is meant to be used only for diagnostic purposes.
 */
bool
wchan_isempty(struct wchan* wc, struct spinlock* lk) {
    bool ret;

    assert(spinlock_held(lk));
    ret = threadlist_isempty(&wc->wc_threads);

    return ret;
}
