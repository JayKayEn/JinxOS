#include <lib.h>
#include <wchan.h>
#include <thread.h>
#include <semaphore.h>
#include <test.h>
#include <spinlock.h>
#include <kmm.h>
#include <syscall.h>
#include <x86.h>

// #include "opt-synchprobs.h"

// // dimension of matrices (cannot be too large or will overflow stack)

// #if OPT_SYNCHPROBS
#define DIM 10
// #else
// #define DIM 70
// #endif

/* number of iterations for sleepalot threads */
#define SLEEPALOT_PRINTS      20    /* number of printouts */
#define SLEEPALOT_ITERS       4     /* iterations per printout */
/* polling frequency of waker thread */
#define WAKER_WAKES          100
/* number of iterations per compute thread */
#define COMPUTE_ITERS         10

/* N distinct wait channels */
#define NWAITCHANS 12
static struct spinlock spinlocks[NWAITCHANS];
static struct wchan* waitchans[NWAITCHANS];

static volatile int wakerdone;
static struct semaphore* wakersem;
static struct semaphore* donesem;

static
void
setup(void) {
    char tmp[16];
    int ii;

    if (wakersem == NULL) {
        wakersem = semaphore_create("wakersem", 1);
        donesem = semaphore_create("donesem", 0);
        for (ii = 0; ii < NWAITCHANS; ii++) {
            spinlock_init(&spinlocks[ii]);
            snprintf(tmp, sizeof(tmp), "wc%d", ii);
            waitchans[ii] = wchan_create(strdup(tmp));
        }
    }
    wakerdone = 0;
}

static
int
sleepalot_thread(void* junk, unsigned long num) {
    int ii, j;

    (void)junk;

    for (ii = 0; ii < SLEEPALOT_PRINTS; ii++) {
        for (j = 0; j < SLEEPALOT_ITERS; j++) {
            unsigned n;
            struct spinlock* lk;
            struct wchan* wc;

            n = random() % NWAITCHANS;
            lk = &spinlocks[n];
            wc = waitchans[n];
            spinlock_acquire(lk);
            wchan_sleep(wc, lk);
            spinlock_release(lk);
        }
        print("[%lu]", num);
    }
    V(donesem);
    return 0;
}

static
int
waker_thread(void* junk1, unsigned long junk2) {
    int ii, done;

    (void)junk1;
    (void)junk2;

    while (1) {
        P(wakersem);
        done = wakerdone;
        V(wakersem);
        if (done)
            break;

        for (ii = 0; ii < WAKER_WAKES; ii++) {
            unsigned n;
            struct spinlock* lk;
            struct wchan* wc;

            n = random() % NWAITCHANS;
            lk = &spinlocks[n];
            wc = waitchans[n];
            spinlock_acquire(lk);
            wchan_wakeall(wc, lk);
            spinlock_release(lk);

            thread_yield();
        }
    }
    V(donesem);
    return 0;
}

static
void
make_sleepalots(int howmany) {
    char name[16];
    int ii, result;

    for (ii = 0; ii < howmany; ii++) {
        snprintf(name, sizeof(name), "sleepalot%d", ii);
        result = thread_fork(name, NULL, NULL, sleepalot_thread, NULL, ii);
        if (result)
            panic("thread_fork failed\n");
    }
    result = thread_fork("waker", NULL, NULL, waker_thread, NULL, 0);
    if (result)
        panic("thread_fork failed\n");
}

static
int
compute_thread(void* junk1, unsigned long num) {
    struct matrix {
        char m[DIM][DIM];
    };
    struct matrix* m1, *m2, *m3;
    unsigned char tot;
    int ii, j, k, m;
    uint32_t rand;

    (void)junk1;

    m1 = kmalloc(sizeof(struct matrix));
    assert(m1 != NULL);
    m2 = kmalloc(sizeof(struct matrix));
    assert(m2 != NULL);
    m3 = kmalloc(sizeof(struct matrix));
    assert(m3 != NULL);

    for (m = 0; m < COMPUTE_ITERS; m++) {

        for (ii = 0; ii < DIM; ii++) {
            for (j = 0; j < DIM; j++) {
                rand = random();
                m1->m[ii][j] = rand >> 16;
                m2->m[ii][j] = rand & 0xffff;
            }
        }

        for (ii = 0; ii < DIM; ii++) {
            for (j = 0; j < DIM; j++) {
                tot = 0;
                for (k = 0; k < DIM; k++)
                    tot += m1->m[ii][k] * m2->m[k][j];
                m3->m[ii][j] = tot;
            }
        }

        tot = 0;
        for (ii = 0; ii < DIM; ii++)
            tot += m3->m[ii][ii];

        print("{%lu: %u}", num, (unsigned) tot);
        thread_yield();
    }

    kfree(m1);
    kfree(m2);
    kfree(m3);

    V(donesem);
    return 0;
}

static
void
make_computes(int howmany) {
    char name[16];
    int ii, result;

    for (ii = 0; ii < howmany; ii++) {
        snprintf(name, sizeof(name), "compute%d", ii);
        result = thread_fork(name, NULL, NULL, compute_thread, NULL, ii);
        if (result)
            panic("thread_fork failed\n");
    }
}

static
void
finish(int howmanytotal) {
    int ii;
    for (ii = 0; ii < howmanytotal; ii++)
        P(donesem);
    P(wakersem);
    wakerdone = 1;
    V(wakersem);
    P(donesem);
}

static
void
runtest4(int nsleeps, int ncomputes) {
    setup();
    print("Starting thread test 4 (%d [sleepalots], %d {computes}, 1 waker)\n",
          nsleeps, ncomputes);
    make_sleepalots(nsleeps);
    make_computes(ncomputes);
    finish(nsleeps + ncomputes);
}

int
threadtest4(int argc, char** argv) {
    (void) argc;
    (void) argv;
    runtest4(random() % 32 + 1, random() % 32 + 1);
    print("\nThread test 4 done\n");
    sti();
    return 0;
}
