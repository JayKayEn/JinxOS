#include <lib.h>
#include <test.h>
#include <thread.h>

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

int
threadtest4(int argc, char **argv) {
    (void) argc;
    (void) argv;

    print("Beginning thread test 4...\n");

    assert(threadtester(0) == 0);
    assert(threadtester(1) == 0);
    assert(threadtester(2) == 0);

    print("Thread test 4 complete\n");

    return 0;
}
