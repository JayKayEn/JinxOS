#ifndef _STDLIB_H_
#define _STDLIB_H_

#include <lib.h>

int itoa(int n, char* buf);

void* malloc(size_t size);
void* calloc(size_t size);
void* realloc(void* ptr, size_t size);
void free(void* ptr);

#endif // _STDLIB_H_
