#ifndef _BITMAP_H_
#define _BITMAP_H_

struct bitmap;

struct bitmap* bitmap_create(unsigned nbits);
void* bitmap_getdata(struct bitmap*);
int  bitmap_alloc(struct bitmap*, unsigned* index);
void bitmap_mark(struct bitmap*, unsigned index);
void bitmap_unmark(struct bitmap*, unsigned index);
bool bitmap_isset(struct bitmap*, unsigned index);
void bitmap_destroy(struct bitmap*);

#endif // _BITMAP_H_
