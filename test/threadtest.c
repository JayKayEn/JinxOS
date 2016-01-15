#include <lib.h>
#include <thread.h>
#include <semaphore.h>
#include <test.h>
#include <syscall.h>

#define NTHREADS 32

static struct semaphore* tsem = NULL;

static
void
init_sem(void) {
    assert(tsem == NULL);
    tsem = semaphore_create("tsem", 0);
    if (tsem == NULL)
        panic("threadtest: semaphore_create failed\n");
}

static
void
term_sem(void) {
    assert(tsem != NULL);
    semaphore_destroy(tsem);
    tsem = NULL;
}

static
int
loudthread(void* junk, unsigned long num) {
    int ch = '0' + num;
    int i;

    (void)junk;

    for (i = 0; i < 40; i++) {
        putc(ch);
        for (int j = 0; j < 1000000; ++j);
        if ((random() % NTHREADS) % 5 == 0)
            sys_yield();
        for (int j = 0; j < 1000000; ++j);
        if (random() % (num + 1) % 5 == 0)
            sys_yield();
    }
    V(tsem);
    return 0;
}

/*
 * The idea with this is that you should see
 *
 *   01234567 <pause> 01234567
 *
 * (possibly with the numbers in different orders)
 *
 * The delay loop is supposed to be long enough that it should be clear
 * if either timeslicing or the scheduler is not working right.
 */
static
int
quietthread(void* junk, unsigned long num) {
    int ch = '0' + num;
    volatile int i;

    (void)junk;

    putc(ch);
    for (i = 0; i < 2000000; i++);
    putc(ch);

    V(tsem);
    return 0;
}

static
int
mixthread(void* junk, unsigned long num) {
    int ch = '0' + num;
    volatile int i;

    (void)junk;

    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2500000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2000000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2000000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2000000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2000000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2000000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');
    for (i = 0; i < 2000000; i++);
    putc(ch);
    if (num == NTHREADS - 1)
        putc('\n');



    V(tsem);
    return 0;
}

static
void
runthreads(int testnum) {
    char name[16];
    int i, result;

    for (i = 0; i < NTHREADS; i++) {
        snprintf(name, sizeof(name), "threadtest%d", i);
        result = thread_fork(name, NULL, NULL,
                testnum == 0 ? quietthread
                : testnum == 1 ? mixthread : loudthread, NULL, i);
        if (result)
            panic("threadtest: thread_fork failed)\n");
    }

    for (i = 0; i < NTHREADS; i++)
        P(tsem);
}

int
threadtest(int nargs, char** args) {
    (void)nargs;
    (void)args;

    init_sem();
    print("Starting thread test 1...\n");
    runthreads(0);
    print("\nThread test 1 done.\n");
    term_sem();

    return 0;
}

int
threadtest2(int nargs, char** args) {
    (void)nargs;
    (void)args;

    init_sem();
    print("Starting thread test 2...\n");
    runthreads(1);
    print("\nThread test 2 done.\n");
    term_sem();

    return 0;
}

int
threadtest3(int nargs, char** args) {
    (void)nargs;
    (void)args;

    init_sem();
    print("Starting thread test 3...\n");
    runthreads(2);
    print("\nThread test 3 done.\n");
    term_sem();

    return 0;
}
