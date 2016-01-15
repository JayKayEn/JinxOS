#ifndef _SWITCHFRAME_H_
#define _SWITCHFRAME_H_

#include <lib.h>
#include <int.h>
#include <thread.h>

void
switchframe_init(struct thread* thread,
                 int (*entrypoint)(void* data1, unsigned long data2),
                 void* data1, unsigned long data2);

void
switchframe_switch(struct regs* regs);

#endif // _SWITCHFRAME_H_
