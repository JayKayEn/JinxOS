#ifndef _BITMAP_TS_H_
#define _BITMAP_TS_H_

struct bitmap_ts;

struct bitmap_ts* bitmap_ts_create(unsigned nbits);
void* bitmap_ts_getdata(struct bitmap_ts*);
int bitmap_ts_alloc(struct bitmap_ts*, unsigned* index);
void bitmap_ts_mark(struct bitmap_ts*, unsigned index);
void bitmap_ts_unmark(struct bitmap_ts*, unsigned index);
int bitmap_ts_isset(struct bitmap_ts*, unsigned index);
int bitmap_ts_isset_blocking(struct bitmap_ts*, unsigned index);
void bitmap_ts_destroy(struct bitmap_ts*);

#endif // _BITMAP_TS_H_
