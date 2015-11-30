#ifndef _KMM_H_
#define _KMM_H_

#include <lib.h>

void init_kmm(void);

void* kalloc(size_t nbytes);
int kfree(void* kptr);

#endif // _KMM_H_
