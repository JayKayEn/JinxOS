#include <lib.h>
#include <test.h>
#include <lock.h>
#include <thread.h>

#define NTHREADS 8

static volatile bool testarray[NTHREADS];
static struct lock* lock_test_lock;

// tests basic lock functionality: create, acquire, release
// with just one thread
int locktester_simple(void) {
    struct lock* l1 = lock_create("l1");
    assert(!lock_holding(l1));

    lock_acquire(l1);
    assert(lock_holding(l1));

    lock_release(l1);
    assert(!lock_holding(l1));

    /*
     * acquire lock twice
     * makes sure lk_count works properly
     * should require 2 releases before I don't hold
     */
    lock_acquire(l1);
    lock_acquire(l1);
    assert(lock_holding(l1));

    lock_release(l1);
    assert(lock_holding(l1));

    lock_release(l1);
    assert(!lock_holding(l1));

    struct lock* l2 = lock_create("l2");

    /*
     * make sure acquiring l1 doesn't somehow make this
     * thread think that it holds all locks
     */
    lock_acquire(l1);
    assert(lock_holding(l1));
    assert(!lock_holding(l2));

    lock_destroy(l2);
    lock_release(l1);
    lock_destroy(l1);

    return 0;
}

// entry point function for threads in locktester_array
static int locktester_array_thread(void* junk, unsigned long num) {
    (void) junk;
    lock_acquire(lock_test_lock);
    testarray[num] = true;
    lock_release(lock_test_lock);
    return 0;
}

// tests multiple threads trying to acquire a single lock
// makes sure each thread gets the lock eventually and that
// data structure has expected post state
int locktester_array(void) {
    unsigned int i;
    int err;
    struct thread* threads[NTHREADS];

    for (i = 0; i < NTHREADS; i++) {
        err = thread_fork("locktest_array_thread", &threads[i], NULL,
                          locktester_array_thread, NULL, i);
        if (err)
            panic("locktest: thread_fork failed\n");
    }

    int ret;
    for (i = 0; i < NTHREADS; i++)
        thread_join(threads[i], &ret);

    for (i = 0; i < NTHREADS; i++)
        assert(testarray[i]);

    return 0;
}

// launches each lock test and returns the test's return value
int
locktest(int argc, char** argv) {
    (void) argc;
    (void) argv;

    print("Beginning lock test...\n");

    lock_test_lock = lock_create("lock_test_lock");
    if (lock_test_lock == NULL)
        panic("asst1_test: lock_create failed\n");

    for (int i = 0; i < NTHREADS; i++)
        testarray[i] = false;
    assert(locktester_simple() == 0);

    for (int i = 0; i < NTHREADS; i++)
        testarray[i] = false;
    assert(locktester_array() == 0);

    lock_destroy(lock_test_lock);

    print("Lock test complete\n");

    return 0;
}
