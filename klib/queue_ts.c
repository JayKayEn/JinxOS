#include <lib.h>
#include <kmm.h>
#include <list.h>
#include <queue.h>
#include <queue_ts.h>
#include <lock.h>
#include <cv.h>

struct queue_ts {
    struct queue* qu;
    struct lock* lk;
    struct cv* cv;
};

struct queue_ts* queue_ts_create(void) {
    struct queue_ts* q = (struct queue_ts*) kmalloc(sizeof(struct queue_ts));
    if (q == NULL)
        return NULL;
    q->qu = queue_create();
    if (q->qu == NULL) {
        kfree(q);
        return NULL;
    }
    q->lk = lock_create("queue_ts.lk");
    if (q->lk == NULL) {
        kfree(q->qu);
        kfree(q);
        return NULL;
    }
    q->cv = cv_create("queue_ts.cv");
    if (q->cv == NULL) {
        kfree(q->lk);
        kfree(q->qu);
        kfree(q);
        return NULL;
    }
    return q;
}

int queue_ts_push(struct queue_ts* q, void* newval) {
    assert(q != NULL);

    int ret;
    lock_acquire(q->lk);
    ret = queue_push(q->qu, newval);
    cv_signal(q->cv, q->lk);
    lock_release(q->lk);
    return ret;
}

void* queue_ts_pop(struct queue_ts* q) {
    assert(q != NULL);

    void* ret = NULL;
    lock_acquire(q->lk);
    if (!queue_isempty(q->qu)) {
        ret = queue_front(q->qu);
        queue_pop(q->qu);
    }
    lock_release(q->lk);
    return ret;
}

void* queue_ts_pop_blocking(struct queue_ts* q) {
    assert(q != NULL);

    void* ret = NULL;
    lock_acquire(q->lk);
    while (queue_isempty(q->qu))
        cv_wait(q->cv, q->lk);
    ret = queue_front(q->qu);
    if (ret != NULL)
        queue_pop(q->qu);
    lock_release(q->lk);
    return ret;
}

int queue_ts_isempty(struct queue_ts* q) {
    assert(q != NULL);

    int ret;
    lock_acquire(q->lk);
    ret = queue_isempty(q->qu);
    lock_release(q->lk);
    return ret;
}

unsigned queue_ts_getsize(struct queue_ts* q) {
    assert(q != NULL);

    int ret;
    lock_acquire(q->lk);
    ret = queue_getsize(q->qu);
    lock_release(q->lk);
    return ret;
}

void queue_ts_destroy(struct queue_ts* q) {
    assert(q != NULL);

    lock_acquire(q->lk);
    queue_destroy(q->qu);
    cv_destroy(q->cv);
    lock_release(q->lk);
    lock_destroy(q->lk);
    kfree(q);
}

void
queue_ts_assertvalid(struct queue_ts* q) {
    assert(q != NULL);

    lock_acquire(q->lk);
    queue_assertvalid(q->qu);
    lock_release(q->lk);
}
