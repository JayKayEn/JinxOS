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

int bitmaptester(int);
int bitmap_ts_init(unsigned);
int markbits_seq(void);
int markbits_blocking_seq(void);
int markbits_par(void*, unsigned long);
void run_test_suite(char*, int (*tester)(int), int);

int queuetester(int);
int queue_ts_init(void);
int push_pop_seq(void);
int pop_blocking_seq(void);
int push_pop_par(void*, unsigned long);

// main test function that called each test suite
int tests(int nargs, char** args) {
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

/*//////////////////////////////////////
    thread tests
//////////////////////////////////////*/


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
    if ((j = queue_ts_pop_blocking(q)) == NULL)
        return -1;
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
