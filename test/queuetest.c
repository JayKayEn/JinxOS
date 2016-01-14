#include <lib.h>
#include <test.h>
#include <queue.h>
#include <kmm.h>

#define TESTSIZE 133

int
queuetest(int nargs, char** args) {
    (void)nargs;
    (void)args;

    print("Beginning queue test...\n");

    struct queue* newqueue;
    newqueue = queue_create();
    assert(newqueue != NULL);
    assert(queue_getsize(newqueue) == 0);
    assert(queue_isempty(newqueue));
    queue_assertvalid(newqueue);

    int i;
    int* elem;
    /* push back TESTSIZE number of elements */
    for (i = 0; i < TESTSIZE; ++i) {
        elem = (int*)kmalloc(sizeof(int));
        assert(elem != NULL);
        *elem = i;
        /* check for ENOMEM */
        assert(queue_push(newqueue, (void*) elem) == 0);
    }
    assert(queue_getsize(newqueue) == TESTSIZE);
    assert(!queue_isempty(newqueue));
    queue_assertvalid(newqueue);

    /* pop front TESTSIZE number of elements */
    for (i = 0; i < TESTSIZE; ++i) {
        elem = (int*)queue_front(newqueue);
        assert(*elem == i);
        queue_pop(newqueue);
        kfree(elem);
    }
    assert(queue_getsize(newqueue) == 0);
    assert(queue_isempty(newqueue));
    queue_assertvalid(newqueue);

    /* REPEAT to test if the queue is reusable */

    /* push back TESTSIZE number of elements */
    for (i = 0; i < TESTSIZE; ++i) {
        elem = (int*)kmalloc(sizeof(int));
        assert(elem != NULL);
        *elem = i;
        /* check for ENOMEM */
        assert(queue_push(newqueue, (void*) elem) == 0);
    }
    assert(queue_getsize(newqueue) == TESTSIZE);
    assert(!queue_isempty(newqueue));
    queue_assertvalid(newqueue);

    /* pop front TESTSIZE number of elements */
    for (i = 0; i < TESTSIZE; ++i) {
        elem = (int*)queue_front(newqueue);
        assert(*elem == i);
        queue_pop(newqueue);
        kfree(elem);
    }
    assert(queue_getsize(newqueue) == 0);
    assert(queue_isempty(newqueue));
    queue_assertvalid(newqueue);

    queue_destroy(newqueue);

    print("queue test complete\n");

    return 0;
}
