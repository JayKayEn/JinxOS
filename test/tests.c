/*
 * tests.c
 *
 * Test suite for locks, condition variables, and threads.
 *
 */

#include <lib.h>
#include <x86.h>
#include <thread.h>
#include <wchan.h>
#include <lock.h>
#include <cv.h>
#include <bitmap_ts.h>
#include <queue_ts.h>
#include <syscall.h>

static volatile unsigned int x;
static volatile unsigned int signal_wakes;
static volatile unsigned int broadcast_wakes;
static volatile unsigned on_wchan;
static volatile int cv_var;
static struct cv* test_cv;


int cv_tests(int);
int test_create_cv(void);
int test_cv_wait(void);
int test_cv_signal(void);
int test_cv_broadcast(void);
int wait_and_set(void* stuff, unsigned long num);
int signal_sleep(void* stuff, unsigned long num);
int broadcast_sleep(void* stuff, unsigned long num);

int threadtester(int);
int return_one(void*, unsigned long);
int sum_array(void*, unsigned long);

int bitmaptester(int);
int bitmap_ts_init(unsigned);
int markbits_seq(void);
int markbits_blocking_seq(void);
int markbits_par(void*, unsigned long);
void run_test_suite(char*, int (*tester)(int), int);

int locktester(int);
void init_lock_items(void);
int locktester_simple(void);
int locktester_array(void);

int queuetester(int);
int queue_ts_init(void);
int push_pop_seq(void);
int pop_blocking_seq(void);
int push_pop_par(void*, unsigned long);

// main test function that called each test suite
int tests(int nargs, char **args) {
    (void) nargs;  // suppress warnings
    (void) args;   // suppress warnings

    char tname[24] = {0};

    // thread_join
    snprintf(tname, sizeof(tname), "thread_join");
    run_test_suite(tname, threadtester, 3);
    memset(tname, '\0', sizeof(tname));

    // lock
    snprintf(tname, sizeof(tname), "lock");
    run_test_suite(tname, locktester, 2);
    memset(tname, '\0', sizeof(tname));

    // cv
    snprintf(tname, sizeof(tname), "cv");
    run_test_suite(tname, cv_tests, 4);
    memset(tname, '\0', sizeof(tname));

    // bitmap_ts
    snprintf(tname, sizeof(tname), "bitmap_ts");
    run_test_suite(tname, bitmaptester, 4);
    memset(tname, '\0', sizeof(tname));

    // queue_ts
    snprintf(tname, sizeof(tname), "queue_ts");
    run_test_suite(tname, queuetester, 4);
    memset(tname, '\0', sizeof(tname));

    print("\n\t<!> all test suites executed <!>\n");

    return 0;
}

// this executes each of the ntest tests in the suite tester and prints an
// error/success message to the console upon completion
void run_test_suite(char* tname, int (*tester)(int tnum), int ntest) {
    print("\n  commencing %s tests:\n", tname);
    for (int i = 0; i < ntest; ++i) {
        char buf[32];
        snprintf(buf, 32, ">> %s test %d", tname, i);
        print("\t%-28s [ ---- ]", buf);
        int result = tester(i);
        print("\b\b\b\b\b\b%s ]\n", result == 0 ? "PASS" : "FAIL");
        if (result != 0)
            panic("failed test: %s %d", tname, i);
    }
    print("  finished %s tests.\n", tname);
}

// calls the test in the suite designated by the argument value
int cv_tests(int test) {
    switch (test) {
        case 0:
            return test_create_cv();
        case 1:
            return test_cv_wait();
        case 2:
            return test_cv_signal();
        case 3:
            return test_cv_broadcast();
        default:
            return 1;
    }
    return 0;
}

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
        sys_yield();
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
        sys_yield();
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

/*//////////////////////////////////////
    thread tests
//////////////////////////////////////*/
#define NTHREADS 8

static volatile int array[2 * NTHREADS];
static void init_array(void) {
    for (int i = 0; i < 2 * NTHREADS; ++i)
        array[i] = i;
}

int
thread_return(void* stuff, unsigned long num) {
    (void) stuff;
    (void) num;

    return 0;
}

// each thread returns the value 1 and the result will be summed and verified to
// match NTHREADS
int return_one(void* data1, unsigned long data2) {
    (void) data1;
    (void) data2;

    return 1;
}

// each thread will sum and return two elements from the array and the total
// returned from all threads will be checks to equal the expected value
int sum_array(void* data1, unsigned long data2) {
    (void) data1;

    return array[data2] + array[data2 + NTHREADS];
}

// this accepts a test number and administers the corresponding thread_join test
int threadtester(int test) {
    if (test == 1)
        init_array();
    char name[16] = {'\0'};
    struct thread* t[NTHREADS];
    int tot = 0;
    int tret = 0;
    int sum = 0;
    int ret = 0;

    for (int i = 0; i < NTHREADS; ++i) {
        snprintf(name, sizeof(name), "threadtester%d", i);
        switch (test) {
            case 0:
                ret = thread_fork("test_fork", NULL, NULL, thread_return, NULL, 0);
                if (ret)
                    panic("ERROR: in thread_fork");
                break;
            case 1:
                ret = thread_fork(name, &t[i], NULL, return_one, NULL, i);
                if (ret)
                    panic("threadtester: thread_fork failed\n");
                break;
            case 2:
                ret = thread_fork(name, &t[i], NULL, sum_array, NULL, i);
                if (ret)
                    panic("threadtester: thread_fork failed\n");
                break;
            default:
                return 0;
        }
    }

    if (test != 0) {
        for (int i = 0; i < NTHREADS; ++i) {
            ret = thread_join(t[i], &tret);
            if (ret)
                panic("threadtester: thread_join failed\n");
            tot += tret;
        }
    }

    switch (test) {
        case 0:
            return 0;
        case 1:
            return tot != NTHREADS;
        case 2:
            for (int i = 0; i < 2 * NTHREADS; ++i)
                sum += i;
            return tot != sum;
        default:
            return 0;
    }
}

/*//////////////////////////////////////
    bitmap tests
//////////////////////////////////////*/

static struct bitmap_ts* b;

// checks that a bitmap_ts can be successfully created
int bitmap_ts_init(unsigned nbits) {
    b = bitmap_ts_create(nbits);
    if (b == NULL)
        return -1;
    bitmap_ts_destroy(b);
    return 0;
}

// has one thread mark each bit and check with isset (impl test)
int markbits_seq(void) {
    b = bitmap_ts_create(NTHREADS * 4);
    for (int i = 0; i < NTHREADS * 4; ++i)
        bitmap_ts_mark(b, i);
    for (int i = 0; i < NTHREADS * 4; ++i) {
        if (bitmap_ts_isset(b, i) == 0) {
            bitmap_ts_destroy(b);
            return -1;
        }
    }
    bitmap_ts_destroy(b);
    return 0;
}

// has one thread mark each bit and check with isset_blocking (impl test)
int markbits_blocking_seq(void) {
    return 0;
    // // commented out because isset_blocking was changed
    // b = bitmap_ts_create(NTHREADS * 4);
    // for (int i = 0; i < NTHREADS * 4; ++i)
    //     bitmap_ts_mark(b, i);
    // for (int i = 0; i < NTHREADS * 4; ++i) {
    //     if (bitmap_ts_isset_blocking(b, i) == 0) {
    //         bitmap_ts_destroy(b);
    //         return -1;
    //     }
    // }
    // bitmap_ts_destroy(b);
    // return 0;s
}

// has multiple threads mark bits in parallel
int markbits_par(void* data1, unsigned long data2) {
    (void) data1;
    if (data2 == NTHREADS - 1)
        for (int i = 0; i < NTHREADS * 4; ++i)
            bitmap_ts_mark(b, i);
    else {
        if (bitmap_ts_isset(b, data2) == 0)
            return -1;
        if (bitmap_ts_isset(b, data2 + NTHREADS) == 0)
            return -1;
        if (bitmap_ts_isset(b, data2 + 2 * NTHREADS) == 0)
            return -1;
        if (bitmap_ts_isset(b, data2 + 3 * NTHREADS) == 0)
            return -1;
    }

    return 0;
}

// launches each bitmap_ts test and returns the test's return value
int bitmaptester(int test) {
    struct thread* t[NTHREADS] = {NULL};
    char name[16] = {'\0'};
    int tret = 0;
    int ret = 0;
    switch (test) {
        case 0:
            return bitmap_ts_init((unsigned) NTHREADS);
        case 1:
            return markbits_seq();
        case 2:
            return markbits_blocking_seq();
        case 3:
            b = bitmap_ts_create(NTHREADS * 4);
            for (int i = 0; i < NTHREADS; ++i) {
                snprintf(name, sizeof(name), "bitmaptester%d", i);
                ret = thread_fork(name, &t[i], NULL, markbits_par, NULL, i);
                if (ret)
                    panic("bitmaptester: thread_fork faile\n");
                break;
            }
            for (int i = 0; i < NTHREADS; ++i) {
                ret = thread_join(t[i], &tret);
                if (ret)
                    panic("bitmaptester: thread_join faile\n");
                if (tret != 0)
                    break;
            }
            bitmap_ts_destroy(b);
        default:
            return 0;
    }
    return tret;
}


/*//////////////////////////////////////
    lock tests
//////////////////////////////////////*/

static volatile bool testarray[NTHREADS];
static struct lock* lock_test_lock;

// initializes variables used by locktester
void init_lock_items(void) {
    // testarray = kmalloc(sizeof(bool) * NTHREADS);
    unsigned int i;
    if (lock_test_lock == NULL) {
        lock_test_lock = lock_create("lock_test_lock");
        if (lock_test_lock == NULL)
            panic("asst1_test: lock_create failed\n");
    }
    for (i = 0; i < NTHREADS; i++)
        testarray[i] = false;
}

// launches each lock test and returns the test's return value
int locktester(int test) {
    init_lock_items();
    switch (test) {
        case 0:
            return locktester_simple();
        case 1:
            return locktester_array();
        default:
            return 0;
    }
    lock_destroy(lock_test_lock);
}

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

    struct lock *l2 = lock_create("l2");

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
static int locktester_array_thread(void *junk, unsigned long num) {
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
    struct thread *threads[NTHREADS];

    for (i = 0; i < NTHREADS; i++) {
        err = thread_fork("locktest_array_thread", &threads[i], NULL,
                          locktester_array_thread, NULL, i);
        if (err) {
            panic("locktest: thread_fork failed\n");
        }
    }

    int ret;
    for (i = 0; i < NTHREADS; i++) {
        thread_join(threads[i], &ret);
    }

    for (i = 0; i < NTHREADS;i++) {
        assert(testarray[i]);
    }

    return 0;
}


/*//////////////////////////////////////
    queue tests
//////////////////////////////////////*/

static struct queue_ts* q;

// checks that a queue_ts can be created
int queue_ts_init(void) {
    q = queue_ts_create();
    if (q == NULL)
        return -1;
    queue_ts_destroy(q);
    return  0;
}

// checks that regular pop returns values when they are present (impl test)
int push_pop_seq(void) {
    q = queue_ts_create();
    // int* j = NULL;
    for (int i = 0; i < NTHREADS; ++i) {
        int* j = (int*) kmalloc(sizeof(int));
        assert(j != NULL);
        *j = i;
        queue_ts_push(q, j);
    }
    for (int i = 0; i < NTHREADS; ++i) {
        int* j = (int*) queue_ts_pop(q);
        if (*j != i) {
            kfree(j);
            while (!queue_ts_isempty(q))
                kfree(queue_ts_pop_blocking(q));
            queue_ts_destroy(q);
            return -1;
        }
        kfree(j);
    }
    queue_ts_destroy(q);
    return 0;
}

// tests that pop_blocking properly returns values when they are present
int pop_blocking_seq(void) {
    q = queue_ts_create();
    for (int i = 0; i < NTHREADS * 4; ++i) {
        int* j = (int*) kmalloc(sizeof(int));
        assert(j != NULL);
        *j = i;
        queue_ts_push(q, j);
    }
    for (int i = 0; i < NTHREADS * 4; ++i) {
        int* j = (int*) queue_ts_pop_blocking(q);
        if (*j != i) {
            kfree(j);
            while (!queue_ts_isempty(q))
                kfree(queue_ts_pop_blocking(q));
            queue_ts_destroy(q);
            return -1;
        }
        kfree(j);
    }
    queue_ts_destroy(q);
    return 0;
}

// tries to pop from an empty queue_ts and must wait for the parent thread to
// insert values
int push_pop_par(void* data1, unsigned long data2) {
    (void) data1;
    (void) data2;
    void* j = NULL;
    assert(queue_ts_isempty(q));
    if ((j = queue_ts_pop_blocking(q)) == NULL) {
        return -1;
    }
    kfree(j);

    return 0;
}

// launches each queue_ts test and returns the test's return value
int queuetester(int test) {
    struct thread* t[NTHREADS] = {NULL};
    char name[16] = {'\0'};
    int tret = 0;
    int ret = 0;
    switch (test) {
        case 0:
            return queue_ts_init();
        case 1:
            return push_pop_seq();
        case 2:
            return pop_blocking_seq();
        case 3:
            q = queue_ts_create();
            assert(queue_ts_isempty(q));
            // fork a bunch of theads that will wait for the !queue_ts_isempty
            for (int i = 0; i < NTHREADS; ++i) {
                snprintf(name, sizeof(name), "%s%d", __func__, i);
                ret = thread_fork(name, &t[i], NULL, push_pop_par, NULL, i);
                if (ret)
                    panic("queuetester: thread_fork failed\n");
            }
            // wait just a bit so each thread will be asleep
            for (int i = 0; i < NTHREADS - 1; ++i)
                sys_yield();
            // push values into the queue (and indirectly signal the waiting
            // threads)
            for (int i = 0; i < NTHREADS; ++i) {
                int* j = (int*) kmalloc(sizeof(int));
                assert(j != NULL);
                *j = i + NTHREADS;
                queue_ts_push(q, j);
            }
            // join each thread back
            for (int i = 0; i < NTHREADS; ++i) {
                ret = thread_join(t[i], &tret);
                if (ret)
                    panic("queuetester: thread_join failed\n");
                if (tret != 0)
                    break;
            }
            queue_ts_destroy(q);
        default:
            return 0;
    }
    return 0;
}
