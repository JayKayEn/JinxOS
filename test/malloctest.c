#include <lib.h>
#include <test.h>
#include <kmm.h>
#include <err.h>
#include <thread.h>
#include <semaphore.h>
#include <pmm.h>
#include <x86.h>

#define DIVROUNDUP(a,b) (((a)+(b)-1)/(b))

/*
 * Test kmalloc; allocate ITEMSIZE bytes NTRIES times, freeing
 * somewhat later.
 *
 * The total of ITEMSIZE * NTRIES is intended to exceed the size of
 * available memory.
 *
 * mallocstress does the same thing, but from NTHREADS different
 * threads at once.
 */

#define NTRIES   1200
#define ITEMSIZE  997
#define NTHREADS  64

static
int
mallocthread(void* sm, unsigned long num) {
    struct semaphore* sem = sm;
    void* ptr;
    void* oldptr = NULL;
    void* oldptr2 = NULL;
    int i;

    for (i = 0; i < NTRIES; i++) {
        ptr = kmalloc(ITEMSIZE);
        if (ptr == NULL) {
            if (sem) {
                print("thread %lu: kmalloc returned NULL\n",
                      num);
                V(sem);
                return -1;
            }
            print("kmalloc returned null; test failed.\n");
            return -1;
        }
        if (oldptr2)
            kfree(oldptr2);
        oldptr2 = oldptr;
        oldptr = ptr;
    }

    if (oldptr2)
        kfree(oldptr2);
    if (oldptr)
        kfree(oldptr);
    if (sem)
        V(sem);

    return 0;
}

int
malloctest(int argc, char** argv) {
    (void)argc;
    (void)argv;

    print("Starting kmalloc test...\n");
    mallocthread(NULL, 0);
    print("kmalloc test done\n");

    return 0;
}

int
mallocstress(int argc, char** argv) {
    struct semaphore* sem;
    int i, result;

    (void)argc;
    (void)argv;

    sem = semaphore_create("mallocstress", 0);
    if (sem == NULL)
        panic("mallocstress: semaphore_create failed\n");

    print("Starting kmalloc stress test...\n");

    for (i = 0; i < NTHREADS; i++) {
        result = thread_fork("mallocstress", NULL, NULL,
                             mallocthread, sem, i);
        if (result)
            panic("mallocstress: thread_fork failed\n");
    }

    for (i = 0; i < NTHREADS; i++)
        P(sem);

    semaphore_destroy(sem);
    print("kmalloc stress test done\n");

    sti();

    return 0;
}

static
int
malloctester(unsigned numptrs) {
    static const unsigned sizes[5] = { 32, 41, 109, 86, 9 };
    size_t ptrspace;
    size_t blocksize;
    unsigned numptrblocks;
    void** *ptrblocks;
    unsigned curblock, curpos, cursizeindex, cursize;
    size_t totalsize;
    unsigned i, j;
    unsigned char* ptr;

    ptrspace = numptrs * sizeof(void*);

    /* Use the subpage allocator for the pointer blocks too. */
    blocksize = PG_SIZE / 4;
    numptrblocks = DIVROUNDUP(ptrspace, blocksize);

    print("malloctest2: %u objects, %u pointer blocks\n",
          numptrs, numptrblocks);

    ptrblocks = kmalloc(numptrblocks * sizeof(ptrblocks[0]));
    if (ptrblocks == NULL)
        panic("malloctest2: failed on pointer block array\n");
    for (i = 0; i < numptrblocks; i++) {
        ptrblocks[i] = kmalloc(blocksize);
        if (ptrblocks[i] == NULL)
            panic("malloctest2: failed on pointer block %u\n", i);
    }

    curblock = 0;
    curpos = 0;
    cursizeindex = 0;
    totalsize = 0;
    for (i = 0; i < numptrs; i++) {
        cursize = sizes[cursizeindex];
        ptr = kmalloc(cursize);
        if (ptr == NULL) {
            print("malloctest2: failed on object %u size %u\n",
                  i, cursize);
            print("malloctest2: pos %u in pointer block %u\n",
                  curpos, curblock);
            print("malloctest2: total so far %u\n", totalsize);
            panic("malloctest2: failed.\n");
        }
        for (j = 0; j < cursize; j++)
            ptr[j] = (unsigned char) i;
        ptrblocks[curblock][curpos] = ptr;
        curpos++;
        if (curpos >= blocksize / sizeof(void*)) {
            curblock++;
            curpos = 0;
        }
        totalsize += cursize;
    }

    print("malloctest2: %u bytes allocated\n", totalsize);

    curblock = 0;
    curpos = 0;
    cursizeindex = 0;
    for (i = 0; i < numptrs; i++) {
        cursize = sizes[cursizeindex];
        ptr = ptrblocks[curblock][curpos];
        assert(ptr != NULL);
        for (j = 0; j < cursize; j++) {
            if (ptr[j] == (unsigned char) i)
                continue;
            print("malloctest2: failed on object %u size %u\n",
                  i, cursize);
            print("malloctest2: pos %u in pointer block %u\n",
                  curpos, curblock);
            print("malloctest2: at object offset %u\n", j);
            print("malloctest2: expected 0x%x, found 0x%x\n",
                  ptr[j], (unsigned char) i);
            panic("malloctest2: failed.\n");
        }
        kfree(ptr);
        curpos++;
        if (curpos >= blocksize / sizeof(void*)) {
            curblock++;
            curpos = 0;
        }
        assert(totalsize > 0);
        totalsize -= cursize;
    }
    assert(totalsize == 0);

    for (i = 0; i < numptrblocks; i++) {
        assert(ptrblocks[i] != NULL);
        kfree(ptrblocks[i]);
    }
    kfree(ptrblocks);

    print("malloctest2: passed\n");
    return 0;
}

int
malloctest2(int argc, char** argv) {
    (void) argc;
    (void) argv;

    for (int i = 0; i < 32; ++i)
        malloctester(random() % 8192 + 8192);

    return 0;
}
