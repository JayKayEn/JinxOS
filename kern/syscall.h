#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include <lib.h>
#include <wchan.h>
#include <spinlock.h>

enum {
    syscall_putc,
    syscall_exit,
    syscall_thread_yield,
    syscall_thread_wait,
    NSYSCALL
};

int syscall(uint32_t num, uint32_t a1, uint32_t a2, uint32_t a3);

#endif // _SYSCALL_H_
