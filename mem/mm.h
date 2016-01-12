#ifndef _MM_H_
#define _MM_H_

#include <lib.h>

void init_mm(void);
void* kmalloc(size_t size);
void* krealloc(void* ptr, size_t size);
void kfree(void* ptr);

#endif // _MM_H_
