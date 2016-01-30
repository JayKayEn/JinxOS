#include <syscall.h>
#include <types.h>

#define ISR_SYSCALL  0x30     // System Call

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5) {
    int32_t ret;

    // Generic system call: pass system call number in AX,
    // up to five parameters in DX, CX, BX, DI, SI.
    // Interrupt kernel with ISR_SYSCALL.
    //
    // The "volatile" tells the assembler not to optimize
    // this instruction away just because we don't use the
    // return value.
    //
    // The last clause tells the assembler that this can
    // potentially change the condition codes and arbitrary
    // memory locations.

    asm volatile("int %1\n"
                 : "=a" (ret)
                 : "i" (ISR_SYSCALL),
                 "a" (num),
                 "d" (a1),
                 "c" (a2),
                 "b" (a3),
                 "D" (a4),
                 "S" (a5)
                 : "cc", "memory");

    (void) check;
    // if(check && ret > 0)
    //     panic("syscall %d returned %d (> 0)", num, ret);

    return ret;
}

void
putc(char c) {
    syscall(syscall_putc, 0, (uint32_t) c, 0, 0, 0, 0);
}

void
exit(int code) {
    syscall(syscall_exit, 0, (uint32_t) code, 0, 0, 0, 0);
}
