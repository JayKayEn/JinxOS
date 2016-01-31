#ifndef _HASHTABLE_TS_H_
#define _HASHTABLE_TS_H_

struct hashtable_ts;

struct hashtable_ts* hashtable_ts_create(void);
int hashtable_ts_add(struct hashtable_ts* h, char* key, unsigned int keylen, void* val);
void* hashtable_ts_find(struct hashtable_ts* h, char* key, unsigned int keylen);
void* hashtable_ts_remove(struct hashtable_ts* h, char* key, unsigned int keylen);
int hashtable_ts_isempty(struct hashtable_ts* h);
unsigned int hashtable_ts_getsize(struct hashtable_ts* h);
void hashtable_ts_destroy(struct hashtable_ts* h);
void hashtable_ts_assertvalid(struct hashtable_ts* h);

#endif // _HASHTABLE_TS_H_
