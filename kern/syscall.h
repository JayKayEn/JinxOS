#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include <lib.h>
#include <wchan.h>
#include <spinlock.h>

enum {
    syscall_yield,
    syscall_sleep,
    NSYSCALL
};

int syscall(uint32_t num, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5);

void sys_yield(void);
void sys_sleep(struct wchan* wc, struct spinlock* lk);

#endif // _SYSCALL_H_
