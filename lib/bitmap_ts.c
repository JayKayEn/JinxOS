#include <lib.h>
#include <kmm.h>
#include <err.h>
#include <bitmap.h>
#include <bitmap_ts.h>
#include <lock.h>
#include <cv.h>

struct bitmap_ts {
    struct bitmap* bm;
    struct lock* lk;
    struct cv* cv;
};

struct bitmap_ts* bitmap_ts_create(unsigned nbits) {
    struct bitmap_ts* b = (struct bitmap_ts*) kmalloc(sizeof(struct bitmap_ts));
    if (b == NULL)
        return NULL;
    b->bm = bitmap_create(nbits);
    if (b->bm == NULL) {
        kfree(b);
        return NULL;
    }
    b->lk = lock_create("bitmap_ts.lk");
    if (b->lk == NULL) {
        kfree(b->bm);
        kfree(b);
        return NULL;
    }
    b->cv = cv_create("bitmap_ts.cv");
    if (b->cv == NULL) {
        kfree(b->lk);
        kfree(b->bm);
        kfree(b);
        return NULL;
    }
    return b;
}

void* bitmap_ts_getdata(struct bitmap_ts* b) {
    assert(b != NULL);

    lock_acquire(b->lk);
    void* ret = bitmap_getdata(b->bm);
    lock_release(b->lk);
    return ret;
}

int bitmap_ts_alloc(struct bitmap_ts* b, unsigned* index) {
    assert(b != NULL);
    assert(index != NULL);

    lock_acquire(b->lk);
    int ret = bitmap_alloc(b->bm, index);
    lock_release(b->lk);
    // may return ENOMEM
    return ret;
}

void bitmap_ts_mark(struct bitmap_ts* b, unsigned index) {
    assert(b != NULL);

    lock_acquire(b->lk);
    bitmap_mark(b->bm, index);
    cv_signal(b->cv, b->lk);
    lock_release(b->lk);
}

void bitmap_ts_unmark(struct bitmap_ts* b, unsigned index) {
    assert(b != NULL);

    lock_acquire(b->lk);
    bitmap_unmark(b->bm, index);
    lock_release(b->lk);
}

int bitmap_ts_isset(struct bitmap_ts* b, unsigned index) {
    assert(b != NULL);

    lock_acquire(b->lk);
    int ret = bitmap_isset(b->bm, index);
    lock_release(b->lk);
    return ret;
}

int bitmap_ts_isset_blocking(struct bitmap_ts* b, unsigned index) {
    assert(b != NULL);

    lock_acquire(b->lk);
    while (bitmap_isset(b->bm, index) == 1)
        cv_wait(b->cv, b->lk);
    lock_release(b->lk);
    return 0;
}

void bitmap_ts_destroy(struct bitmap_ts* b) {
    assert(b != NULL);

    lock_acquire(b->lk);
    bitmap_destroy(b->bm);
    cv_destroy(b->cv);
    lock_release(b->lk);
    lock_destroy(b->lk);
    kfree(b);
}
