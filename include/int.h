#ifndef _INT_H_
#define _INT_H_

#include <lib.h>

struct regs {
    uint32_t es;
    uint32_t ds;
    uint32_t edi;
    uint32_t esi;
    uint32_t ebp;
    uint32_t esp;
    uint32_t ebx;
    uint32_t edx;
    uint32_t ecx;
    uint32_t eax;
    uint32_t int_no;
    uint32_t err_code;
    uint32_t eip;
    uint32_t cs;
    uint32_t eflags;
    uint32_t useresp;
    uint32_t ss;
};

extern void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags);
extern void irq_install_handler(int, void (*)(struct regs*));

#define ISR_DIVIDE   0x00     // Divide Error
#define ISR_DEBUG    0x01     // Debug Exception
#define ISR_NMI      0x02     // Non-Maskable Interrupt
#define ISR_BRKPT    0x03     // Breakpoint
#define ISR_OFLOW    0x04     // Overflow
#define ISR_BOUND    0x05     // Bounds Check
#define ISR_ILLOP    0x06     // Illegal Opcode
#define ISR_DEVICE   0x07     // Device Not Available
#define ISR_DBLFLT   0x08     // Double Fault
#define ISR_COPROC   0x09     // Coprocessor Segment Overrun
#define ISR_TSS      0x0A     // Invalid Task State Segment
#define ISR_SEGNP    0x0B     // Segment Not Present
#define ISR_STACK    0x0C     // Stack Exception
#define ISR_GPFLT    0x0D     // General Protection Fault
#define ISR_PGFLT    0x0E     // Page fault
#define ISR_RES      0x0F     // Reserved
#define ISR_FPERR    0x10     // Floating Point Error
#define ISR_ALIGN    0x11     // Aligment Check
#define ISR_MCHK     0x12     // Machine Check
#define ISR_SIMDERR  0x13     // SIMD Floating-Point Error

#define ISR_SYSCALL  0x30     // System Call

#define IRQ_OFFSET 0x20     // IRQ 0 corresponds to int IRQ_OFFSET

#define IRQ_TIMER  0x00     // System Timer
#define IRQ_KBD    0x01     // Keyboard Controller
#define IRQ_SLAVE  0x02     // Slave PIC Request
#define IRQ_SER2   0x03     // Serial Port (COM2) Controller
#define IRQ_SER1   0x04     // Serial Port (COM1) Controller
#define IRQ_SOUND  0x05     // Sound Card
#define IRQ_FLOPPY 0x06     // Floppy Disk Controller
#define IRQ_SPUR   0x07     // 8259 Spurious Interrupt

#define IRQ_RTC    0x08     // Real-Time Clock
#define IRQ_ACPI   0x09     // Advanced Configuration and Power Interface
#define IRQ_SCSI   0x0A     //
#define IRQ_NIC    0x0B     // Network Interface Controller
#define IRQ_MOUSE  0x0C     // PS/2 Mouse
#define IRQ_FPU    0x0D     // Floating-Point Unit or CPU Coprocessor
#define IRQ_IDE    0x0E     // Primary IDE Controller
#define IRQ_IPI    0x0F     // Inter-Processor Interrupt

#define IRQ_ERROR  0x31     // Request Error
#define IRQ_EOI    0x20     // End of Interrupt

#endif /* _INTERRUPT_H_ */
