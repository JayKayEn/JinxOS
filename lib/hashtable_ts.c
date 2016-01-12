#include <lib.h>
#include <kmm.h>
#include <err.h>
#include <hashtable.h>
#include <hashtable_ts.h>
#include <list.h>
#include <lock.h>

struct hashtable_ts {
    struct hashtable* ht;
    struct lock* lock;
};

struct hashtable_ts* hashtable_ts_create() {

    struct hashtable_ts* ht;
    ht = kmalloc(sizeof(struct hashtable_ts));

    if(ht == NULL)
        return NULL;

    // create the internal hashtable
    ht->ht = hashtable_create();
    if(ht->ht == NULL) {
        kfree(ht);
        return NULL;
    }

    //create the lock
    ht->lock = lock_create("hashtable lock");
    if(ht->lock == NULL) {
        hashtable_destroy(ht->ht);
        kfree(ht);
        return NULL;
    }

    return ht;
};

void hashtable_ts_destroy(struct hashtable_ts* ht) {

    hashtable_destroy(ht->ht);
    lock_destroy(ht->lock);

    kfree(ht);
}



int hashtable_ts_add(struct hashtable_ts* h, char* key, unsigned int keylen, void* val) {

    int ret;

    lock_acquire(h->lock);

    ret = hashtable_add(h->ht, key, keylen, val);

    lock_release(h->lock);

    return ret;
}



void* hashtable_ts_find(struct hashtable_ts* h, char* key, unsigned int keylen) {

    void* ret;

    lock_acquire(h->lock);
    ret = hashtable_find(h->ht, key, keylen);
    lock_release(h->lock);

    return ret;
}


void* hashtable_ts_remove(struct hashtable_ts* h, char* key, unsigned int keylen) {
    void* ret;

    lock_acquire(h->lock);
    ret = hashtable_remove(h->ht, key, keylen);
    lock_release(h->lock);

    return ret;
}


int hashtable_ts_isempty(struct hashtable_ts* h) {

    int ret;

    lock_acquire(h->lock);

    ret = hashtable_isempty(h->ht);

    lock_release(h->lock);

    return ret;
}


unsigned int hashtable_ts_getsize(struct hashtable_ts* h) {

    unsigned int ret;

    lock_acquire(h->lock);
    ret = hashtable_getsize(h->ht);
    lock_release(h->lock);

    return ret;
}


void hashtable_ts_assertvalid(struct hashtable_ts* h) {
    lock_acquire(h->lock);
    hashtable_assertvalid(h->ht);
    lock_release(h->lock);
}




