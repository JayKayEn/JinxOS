#ifndef _KADT_H_
#define _KADT_H_

struct kbitmap;

struct kbitmap* kbitmap_create(unsigned nbits);
int  kbitmap_alloc(struct kbitmap*, unsigned* index);
void kbitmap_mark(struct kbitmap*, unsigned index);
void kbitmap_unmark(struct kbitmap*, unsigned index);
bool kbitmap_isset(struct kbitmap*, unsigned index);
void kbitmap_destroy(struct kbitmap*);

#endif // _KADT_H_
