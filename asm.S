#include <memlayout.h>
#include <mmu.h>

.text

.code32
.global gdt_flush
.extern gp
gdt_flush:
    lgdt    (gp)
    movw    $0x10, %ax
    movw    %ax ,%ds
    movw    %ax ,%es
    movw    %ax ,%fs
    movw    %ax ,%gs
    movw    %ax ,%ss
    ljmp    $0x08, $flush
flush:
    ret

// Loads the IDT defined in '_idtp' into the processor.
// This is declared in C as 'extern void idt_load();'
.global idt_load
.extern idtp
idt_load:
    lidt (idtp)
    ret

// Interrupt Service Routines (ISRs)

//  0: Divide By Zero Exception
.global isr0
.type isr0, @function
.align 2
isr0:
    cli
    pushl $0x0
    pushl $0x0
    jmp isr_common_stub

//  1: Debug Exception
.global isr1
.type isr1, @function
.align 2
isr1:
    cli
    pushl $0x0
    pushl $0x1
    jmp isr_common_stub

//  2: Non Maskable Interrupt Exception
.global isr2
.type isr2, @function
.align 2
isr2:
    cli
    pushl $0x0
    pushl $0x2
    jmp isr_common_stub

//  3: Int 3 Exception
.global isr3
.type isr3, @function
.align 2
isr3:
    cli
    pushl $0x0
    pushl $0x3
    jmp isr_common_stub

//  4: INTO Exception
.global isr4
.type isr4, @function
.align 2
isr4:
    cli
    pushl $0x0
    pushl $0x4
    jmp isr_common_stub

//  5: Out of Bounds Exception
.global isr5
.type isr5, @function
.align 2
isr5:
    cli
    pushl $0x0
    pushl $0x5
    jmp isr_common_stub

//  6: Invalid Opcode Exception
.global isr6
.type isr6, @function
.align 2
isr6:
    cli
    pushl $0x0
    pushl $0x6
    jmp isr_common_stub

//  7: Coprocessor Not Available Exception
.global isr7
.type isr7, @function
.align 2
isr7:
    cli
    pushl $0x0
    pushl $0x7
    jmp isr_common_stub

//  8: Double Fault Exception (With Error Code!)
.global isr8
.type isr8, @function
.align 2
isr8:
    cli
    pushl $0x8
    jmp isr_common_stub

// //  9: Coprocessor Segment Overrun Exception
// .global isr9
// .type isr9, @function
// .align 2
// isr9:
//     cli
//     pushl $0x0
//     pushl $0x9
//     jmp isr_common_stub

// 10: Bad TSS Exception (With Error Code!)
.global isr10
.type isr10, @function
.align 2
isr10:
    cli
    pushl $0xA
    jmp isr_common_stub

// 11: Segment Not Present Exception (With Error Code!)
.global isr11
.type isr11, @function
.align 2
isr11:
    cli
    pushl $0xB
    jmp isr_common_stub

// 12: Stack Fault Exception (With Error Code!)
.global isr12
.type isr12, @function
.align 2
isr12:
    cli
    pushl $0xC
    jmp isr_common_stub

// 13: General Protection Fault Exception (With Error Code!)
.global isr13
.type isr13, @function
.align 2
isr13:
    cli
    pushl $0xD
    jmp isr_common_stub

// 14: Page Fault Exception (With Error Code!)
.global isr14
.type isr14, @function
.align 2
isr14:
    cli
    pushl $0xE
    jmp isr_common_stub

// // 15: Reserved Exception
// .global isr15
// .type isr15, @function
// .align 2
// isr15:
//     cli
//     pushl $0x0
//     pushl $0xF
//     jmp isr_common_stub

// 16: Floating Point Exception
.global isr16
.type isr16, @function
.align 2
isr16:
    cli
    pushl $0x0
    pushl $0x10
    jmp isr_common_stub

// 17: Alignment Check Exception
.global isr17
.type isr17, @function
.align 2
isr17:
    cli
    pushl $0x0
    pushl $0x11
    jmp isr_common_stub

// 18: Machine Check Exception
.global isr18
.type isr18, @function
.align 2
isr18:
    cli
    pushl $0x0
    pushl $0x12
    jmp isr_common_stub

// 19: Reserved
.global isr19
.type isr19, @function
.align 2
isr19:
    cli
    pushl $0x0
    pushl $0x13
    jmp isr_common_stub

// // 20: Reserved
// .global isr20
// .type isr20, @function
// .align 2
// isr20:
//     cli
//     pushl $0x0
//     pushl $0x14
//     jmp isr_common_stub

// // 21: Reserved
// .global isr21
// .type isr21, @function
// .align 2
// isr21:
//     cli
//     pushl $0x0
//     pushl $0x15
//     jmp isr_common_stub

// // 22: Reserved
// .global isr22
// .type isr22, @function
// .align 2
// isr22:
//     cli
//     pushl $0x0
//     pushl $0x16
//     jmp isr_common_stub

// // 23: Reserved
// .global isr23
// .type isr23, @function
// .align 2
// isr23:
//     cli
//     pushl $0x0
//     pushl $0x17
//     jmp isr_common_stub

// // 24: Reserved
// .global isr24
// .type isr24, @function
// .align 2
// isr24:
//     cli
//     pushl $0x0
//     pushl $0x18
//     jmp isr_common_stub

// // 25: Reserved
// .global isr25
// .type isr25, @function
// .align 2
// isr25:
//     cli
//     pushl $0x0
//     pushl $0x19
//     jmp isr_common_stub

// // 26: Reserved
// .global isr26
// .type isr26, @function
// .align 2
// isr26:
//     cli
//     pushl $0x0
//     pushl $0x1A
//     jmp isr_common_stub

// // 27: Reserved
// .global isr27
// .type isr27, @function
// .align 2
// isr27:
//     cli
//     pushl $0x0
//     pushl $0x1B
//     jmp isr_common_stub

// // 28: Reserved
// .global isr28
// .type isr28, @function
// .align 2
// isr28:
//     cli
//     pushl $0x0
//     pushl $0x1C
//     jmp isr_common_stub

// // 29: Reserved
// .global isr29
// .type isr29, @function
// .align 2
// isr29:
//     cli
//     pushl $0x0
//     pushl $0x1D
//     jmp isr_common_stub

// // 30: Reserved
// .global isr30
// .type isr30, @function
// .align 2
// isr30:
//     cli
//     pushl $0x0
//     pushl $0x1E
//     jmp isr_common_stub

// // 31: Reserved
// .global isr31
// .type isr31, @function
// .align 2
// isr31:
//     cli
//     pushl $0x0
//     pushl $0x1F
//     jmp isr_common_stub

// 48: System Call
.global isr48
.type isr48, @function
.align 2
isr48:
    cli
    pushl $0x0
    pushl $0x30
    jmp isr_common_stub

// We call a C function in here. We need to let the assembler know
// that 'isr_handler' exists in another file
.extern isr_handler

// This is our common ISR stub. It saves the processor state, sets
// up for kernel mode segments, calls the C-level fault handler,
// and finally restores the stack frame.
isr_common_stub:
    pushal
    pushl   %ds
    pushl   %es

    movw    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es

    pushl   %esp
    call    isr_handler
    popl    %esp

    popl    %es
    popl    %ds
    popal

    addl     $0x8, %esp
    iret

// 32: IRQ0
.global irq0
irq0:
    cli
    pushl $0x0
    pushl $0x20
    jmp irq_common_stub

// 33: IRQ1
.global irq1
irq1:
    cli
    pushl $0x0
    pushl $0x21
    jmp irq_common_stub

// 34: IRQ2
.global irq2
irq2:
    cli
    pushl $0x0
    pushl $0x22
    jmp irq_common_stub

// 35: IRQ3
.global irq3
irq3:
    cli
    pushl $0x0
    pushl $0x23
    jmp irq_common_stub

// 36: IRQ4
.global irq4
irq4:
    cli
    pushl $0x0
    pushl $0x24
    jmp irq_common_stub

// 37: IRQ5
.global irq5
irq5:
    cli
    pushl $0x0
    pushl $0x25
    jmp irq_common_stub

// 38: IRQ6
.global irq6
irq6:
    cli
    pushl $0x0
    pushl $0x26
    jmp irq_common_stub

// 39: IRQ7
.global irq7
irq7:
    cli
    pushl $0x0
    pushl $0x27
    jmp irq_common_stub

// 40: IRQ8
.global irq8
irq8:
    cli
    pushl $0x0
    pushl $0x28
    jmp irq_common_stub

// 41: IRQ9
.global irq9
irq9:
    cli
    pushl $0x0
    pushl $0x29
    jmp irq_common_stub

// 42: IRQ10
.global irq10
irq10:
    cli
    pushl $0x0
    pushl $0x2A
    jmp irq_common_stub

// 43: IRQ11
.global irq11
irq11:
    cli
    pushl $0x0
    pushl $0x2B
    jmp irq_common_stub

// 44: IRQ12
.global irq12
irq12:
    cli
    pushl $0x0
    pushl $0x2C
    jmp irq_common_stub

// 45: IRQ13
.global irq13
irq13:
    cli
    pushl $0x0
    pushl $0x2D
    jmp irq_common_stub

// 46: IRQ14
.global irq14
irq14:
    cli
    pushl $0x0
    pushl $0x2E
    jmp irq_common_stub

// 47: IRQ15
.global irq15
irq15:
    cli
    pushl $0x0
    pushl $0x2F
    jmp irq_common_stub

.extern irq_handler

irq_common_stub:
    pushal
    pushl   %ds
    pushl   %es

    movw    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es

    pushl   %esp
    call    irq_handler
    popl    %esp

    popl    %es
    popl    %ds
    popal

    addl     $0x8, %esp
    iret
