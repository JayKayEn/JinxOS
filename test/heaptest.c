#include <lib.h>
#include <test.h>
#include <heap.h>
#include <kmm.h>

#define TESTSIZE 133

/* less comparator for int */
static int int_lessthan(const void* left, const void* right) {
    int l = *(int*)left;
    int r = *(int*)right;
    return (l < r);
}

int
heaptest(int nargs, char** args) {
    (void)nargs;
    (void)args;

    print("Beginning heap test...\n");

    struct heap* newheap;
    newheap = heap_create(&int_lessthan);
    assert(newheap != NULL);
    assert(heap_getsize(newheap) == 0);
    assert(heap_isempty(newheap));

    int i;
    int* elem;
    /* push TESTSIZE number of elements */
    for (i = TESTSIZE - 1; i >= 0; --i) {
        elem = (int*)kmalloc(sizeof(int));
        assert(elem != NULL);
        *elem = i;
        /* check for ENOMEM */
        assert(heap_push(newheap, (void*)elem) == 0);
    }
    assert(heap_getsize(newheap) == TESTSIZE);
    assert(!heap_isempty(newheap));

    /* pop TESTSIZE number of elements; expect numbers in increasing order */
    for (i = 0; i < TESTSIZE; ++i) {
        assert(*(int*)heap_top(newheap) == i);
        elem = (int*)heap_pop(newheap);
        assert(*elem == i);
        /* REMEMBER to kfree elements we allocated in the beginning */
        kfree(elem);
    }
    assert(heap_getsize(newheap) == 0);
    assert(heap_isempty(newheap));

    /* REPEAT to test if the heap is reusable */

    /* push TESTSIZE number of elements */
    for (i = TESTSIZE - 1; i >= 0; --i) {
        elem = (int*)kmalloc(sizeof(int));
        assert(elem != NULL);
        *elem = i;
        /* check for ENOMEM */
        assert(heap_push(newheap, (void*)elem) == 0);
    }
    assert(heap_getsize(newheap) == TESTSIZE);
    assert(!heap_isempty(newheap));

    /* pop TESTSIZE number of elements; expect numbers in increasing order */
    for (i = 0; i < TESTSIZE; ++i) {
        assert(*(int*)heap_top(newheap) == i);
        elem = (int*)heap_pop(newheap);
        assert(*elem == i);
        /* REMEMBER to kfree elements we allocated in the beginning */
        kfree(elem);
    }
    assert(heap_getsize(newheap) == 0);
    assert(heap_isempty(newheap));

    heap_destroy(newheap);

    print("heap test complete\n");

    return 0;
}
