#ifndef _SWITCHFRAME_H_
#define _SWITCHFRAME_H_

#include <lib.h>
#include <int.h>
#include <thread.h>

// struct switchframe {
//     uint32_t edi;
//     uint32_t esi;
//     uint32_t ebp;
//     uint32_t esp;
//     uint32_t ebx;
//     uint32_t edx;
//     uint32_t ecx;
//     uint32_t eax;
// };

void
switchframe_init(struct thread* thread,
        int (*entrypoint)(void* data1, unsigned long data2),
        void* data1, unsigned long data2);

void
switchframe_switch(struct regs* regs);

#endif // _SWITCHFRAME_H_
