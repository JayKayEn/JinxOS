#include <lib.h>
#include <thread.h>
#include <semaphore.h>
#include <test.h>

#define NTHREADS 32

static struct semaphore *tsem = NULL;

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
loudthread(void *junk, unsigned long num) {
    int ch = '0' + num;
    int i;

    (void)junk;

    for (i=0; i<120; i++) {
        putc(ch);
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
quietthread(void *junk, unsigned long num) {
    int ch = '0' + num;
    volatile int i;

    (void)junk;

    putc(ch);
    for (i = 0; i < 200000; i++);
    putc(ch);

    V(tsem);
    return 0;
}

static
void
runthreads(int doloud) {
    char name[16];
    int i, result;

    for (i=0; i<NTHREADS; i++) {
        snprintf(name, sizeof(name), "threadtest%d", i);
        result = thread_fork(name, NULL, NULL,
                             doloud ? loudthread : quietthread,
                             NULL, i);
        if (result)
            panic("threadtest: thread_fork failed)\n");
    }

    for (i=0; i<NTHREADS; i++) {
        P(tsem);
    }
}


int
threadtest(int nargs, char **args) {
    (void)nargs;
    (void)args;

    init_sem();
    print("Starting thread test...\n");
    runthreads(0);
    print("\nThread test done.\n");
    term_sem();

    return 0;
}

int
threadtest2(int nargs, char **args) {
    (void)nargs;
    (void)args;

    init_sem();
    print("Starting thread test 2...\n");
    runthreads(1);
    print("\nThread test 2 done.\n");
    term_sem();

    return 0;
}
