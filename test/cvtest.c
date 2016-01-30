#include <lib.h>
#include <test.h>
#include <cv.h>
#include <wchan.h>
#include <syscall.h>

static struct cv* test_cv;
static volatile int cv_var;
static volatile unsigned int signal_wakes;
static volatile unsigned int broadcast_wakes;

/*
 * Simply makes sure cv_create succeeds and returns a non-null value
 */
int test_create_cv() {
    test_cv = cv_create("test_cv");
    int ret = test_cv == NULL ? -1 : 0;
    cv_destroy(test_cv);
    return ret;
}


/*
 * Helper function that does nothing for a while,
 * then updates cv_var to 1
 */
int wait_and_set(void* stuff, unsigned long num) {
    (void) stuff;
    (void) num;

    cv_var = 1;
    return 0;
}

/*
 * Sets a global variable to 0 and forks a new thread which waits a significant
 * amount of time (necessary so we know the original thread calls cv_wait before
 * the global var is updated), then sets the global variable to 1. The original
 * thread waits until the forked thread updates the global variable and then
 * finishes. This tests the basic functionality of cv_wait: give up control
 * until a condition is met.
 */
int test_cv_wait() {
    int tret;
    struct thread* t;
    struct lock* cv_lock = lock_create("test_cv_wait_lk");
    test_cv = cv_create("test_cv");
    cv_var = 0;
    thread_fork("waitandset", &t, NULL, wait_and_set, NULL, 0);
    thread_join(t, &tret);
    lock_acquire(cv_lock);
    while (cv_var == 0)
        cv_wait(test_cv, cv_lock);
    lock_release(cv_lock);

    cv_destroy(test_cv);
    lock_destroy(cv_lock);

    return 0;
}

/*
 * Helper function that puts a thread to sleep on test_cv's
 * wait channel and once awoken, increments signal_wakes by 1
 */
int signal_sleep(void* stuff, unsigned long num) {
    (void) stuff;
    (void) num;

    // Put the thread on testcv's wait channel
    spinlock_acquire(&test_cv->cv_splock);
    wchan_sleep(test_cv->cv_wchan, &test_cv->cv_splock);
    signal_wakes++;
    spinlock_release(&test_cv->cv_splock);

    return 0;
}

/*
 * Forks a new thread, which is put to sleep on the cv's wait channel. Once the
 * forked thread is added to the wait channel, the original thread calls signal
 * on the wait channel. The forked thread then updates a global variable and the
 * test only passes if this global variable has been updated, ie. the sleeping
 * thread was signaled and awoken. This tests the basic functionality of cv_signal:
 * wake something that is waiting on the cv's wait channel.
 */
int test_cv_signal() {
    struct lock* cv_lock = lock_create("test_cv_signal_lk");
    int tret;
    struct thread* t;
    test_cv = cv_create("test_cv");
    signal_wakes = 0;

    thread_fork("sleep", &t, NULL, signal_sleep, NULL, 0);

    // the spinlock must be help prior to calling wchan_isempty due to KASSERTs
    spinlock_acquire(&test_cv->cv_splock);
    while (wchan_isempty(test_cv->cv_wchan, &test_cv->cv_splock)) {
        // don't don't don't sleep while holding the spinlock
        spinlock_release(&test_cv->cv_splock);
        thread_yield();
        // must re-acquire before going round the loop
        spinlock_acquire(&test_cv->cv_splock);
    }
    spinlock_release(&test_cv->cv_splock);

    // must hold the lock prior to calling cv_signal due to KASSERTs
    lock_acquire(cv_lock);
    cv_signal(test_cv, cv_lock);
    lock_release(cv_lock);

    thread_join(t, &tret);

    cv_destroy(test_cv);
    lock_destroy(cv_lock);

    return signal_wakes == 1 ? 0 : -1;
}

/*
 * Helper function that decrements broadcast_wakes, puts a thread to sleep
 * on test_cv's wait channel and once awoken, increments broadcast_wakes
 */
int broadcast_sleep(void* stuff, unsigned long num) {
    (void) stuff;
    (void) num;
    spinlock_acquire(&test_cv->cv_splock);
    broadcast_wakes--;
    // Put the thread on testcv's wait channel
    wchan_sleep(test_cv->cv_wchan, &test_cv->cv_splock);
    // Should only get here if awoken by the broadcast
    broadcast_wakes++;
    spinlock_release(&test_cv->cv_splock);

    return 0;
}

/*
 * Peforms the same test as test_cv_signal, but puts 5 threads to sleep and makes
 * a call to cv_broadcast after all the threads have been put to sleep on the cv's
 * wait channel. Passes if all 5 threads were awoken and incremented the global
 * variable. Tests the basic functionality of cv_broadcast: Awaking all threads
 * on a cv's wait channel.
 */
int test_cv_broadcast() {
    struct lock* cv_lock = lock_create("test_cv_broadcast_lk");
    int n, tret;
    struct thread* t[5];
    test_cv = cv_create("test_cv");
    broadcast_wakes = 5;

    // Put multiple threads on the wait channel
    for (n = 0; n < 5; n++)
        thread_fork("sleep", &t[n], NULL, broadcast_sleep, NULL, 0);

    spinlock_acquire(&test_cv->cv_splock);
    while (broadcast_wakes > 0) {
        // don't don't don't sleep while holding the spinlock
        spinlock_release(&test_cv->cv_splock);
        thread_yield();
        // must re-acquire before going round the loop
        spinlock_acquire(&test_cv->cv_splock);
    }
    spinlock_release(&test_cv->cv_splock);
    // Need to wait here for a while?
    // must hold the lock prior to calling cv_signal due to KASSERTs
    lock_acquire(cv_lock);
    cv_broadcast(test_cv, cv_lock);
    lock_release(cv_lock);

    for (n = 0; n < 5; n++)
        thread_join(t[n], &tret);

    cv_destroy(test_cv);
    lock_destroy(cv_lock);

    return broadcast_wakes == 5 ? 0 : -1;
}

int
cvtest(int argc, char** argv) {
    (void) argc;
    (void) argv;

    print("Beginning cv test...\n");

    assert(test_create_cv() == 0);
    assert(test_cv_wait() == 0);
    assert(test_cv_signal() == 0);
    assert(test_cv_broadcast() == 0);

    print("CV test complete\n");

    return 0;
}
