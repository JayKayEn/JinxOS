#ifndef _OS_H_
#define _OS_H_

#include <lib.h>

#define thiscpu (&cpus[cpunum()])

void* kmalloc (size_t size);
void kfree (void* ptr);

#endif // _OS_H_
