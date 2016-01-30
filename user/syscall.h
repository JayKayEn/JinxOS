#ifndef _SYSCALL_H_
#define _SYSCALL_H_

enum {
    syscall_putc,
    syscall_exit,
    syscall_thread_yield,
    syscall_thread_wait,
    NSYSCALL
};

void putc(char c);

void exit(int code);

#endif // _SYSCALL_H_
