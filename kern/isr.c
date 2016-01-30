#include <lib.h>
#include <debug.h>
#include <int.h>
#include <syscall.h>
#include <thread.h>
#include <cpu.h>
#include <gdt.h>

#define NISR 32

static void (*isr_routines[NISR])(struct trapframe*);

extern void isr0(void);
extern void isr1(void);
extern void isr2(void);
extern void isr3(void);
extern void isr4(void);
extern void isr5(void);
extern void isr6(void);
extern void isr7(void);
extern void isr8(void);
// extern void isr9(void);
extern void isr10(void);
extern void isr11(void);
extern void isr12(void);
extern void isr13(void);
extern void isr14(void);
// extern void isr15(void);
extern void isr16(void);
extern void isr17(void);
extern void isr18(void);
extern void isr19(void);
// extern void isr20(void);
// extern void isr21(void);
// extern void isr22(void);
// extern void isr23(void);
// extern void isr24(void);
// extern void isr25(void);
// extern void isr26(void);
// extern void isr27(void);
// extern void isr28(void);
// extern void isr29(void);
// extern void isr30(void);
// extern void isr31(void);

extern void isr48(void);

/* This is a very repetitive function... it's not hard, it's
*  just annoying. As you can see, we set the first 32 entries
*  in the IDT to the first 32 ISRs. We can't use a for loop
*  for this, because there is no way to get the function names
*  that correspond to that given entry. We set the access
*  flags to 0x8E. This means that the entry is present, is
*  running in ring 0 (kernel level), and has the lower 5 bits
*  set to the required '14', which is represented by 'E' in
*  hex. */
void init_isr(void) {
    idt_set_gate( 0, 1, GD_KT, (uint32_t)  isr0, DPL_KERN);
    idt_set_gate( 1, 1, GD_KT, (uint32_t)  isr1, DPL_KERN);
    idt_set_gate( 2, 1, GD_KT, (uint32_t)  isr2, DPL_KERN);
    idt_set_gate( 3, 1, GD_KT, (uint32_t)  isr3, DPL_USER);
    idt_set_gate( 4, 1, GD_KT, (uint32_t)  isr4, DPL_KERN);
    idt_set_gate( 5, 1, GD_KT, (uint32_t)  isr5, DPL_KERN);
    idt_set_gate( 6, 1, GD_KT, (uint32_t)  isr6, DPL_KERN);
    idt_set_gate( 7, 1, GD_KT, (uint32_t)  isr7, DPL_KERN);
    idt_set_gate( 8, 1, GD_KT, (uint32_t)  isr8, DPL_KERN);

    idt_set_gate(10, 1, GD_KT, (uint32_t) isr10, DPL_KERN);
    idt_set_gate(11, 1, GD_KT, (uint32_t) isr11, DPL_KERN);
    idt_set_gate(12, 1, GD_KT, (uint32_t) isr12, DPL_KERN);
    idt_set_gate(13, 1, GD_KT, (uint32_t) isr13, DPL_KERN);
    idt_set_gate(14, 1, GD_KT, (uint32_t) isr14, DPL_KERN);

    idt_set_gate(16, 1, GD_KT, (uint32_t) isr16, DPL_KERN);
    idt_set_gate(17, 1, GD_KT, (uint32_t) isr17, DPL_KERN);
    idt_set_gate(18, 1, GD_KT, (uint32_t) isr18, DPL_KERN);
    idt_set_gate(19, 1, GD_KT, (uint32_t) isr19, DPL_KERN);

    idt_set_gate(48, 0, GD_KT, (uint32_t) isr48, DPL_USER);
}

/* This is a simple string array. It contains the message that
 *  corresponds to each and every exception. We get the correct
 *  message by accessing like:
 *  exception_message[interrupt_number]
 */
static const char* const exception_messages[] = {
    "Division By Zero",
    "Debug",
    "Non Maskable Interrupt",
    "Breakpoint",
    "Into Detected Overflow",
    "Out of Bounds",
    "Invalid Opcode",
    "No Coprocessor",

    "Double Fault",
    "Coprocessor Segment Overrun",
    "Bad TSS",
    "Segment Not Present",
    "Stack Fault",
    "General Protection Fault",
    "Page Fault",
    "Unknown Interrupt",

    "Coprocessor Fault",
    "Alignment Check",
    "Machine Check",
    "SIMD Floating-Point Error",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",

    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved"
};

void isr_handler(struct trapframe* r) {
    assert(r != NULL);

    switch (r->int_no) {
        case ISR_SYSCALL: {
            thisthread->context = r;
            uint32_t syscallno = r->eax;
            uint32_t arg1 = r->edx;
            uint32_t arg2 = r->ecx;
            uint32_t arg3 = r->ebx;
            r->eax = syscall(syscallno, arg1, arg2, arg3);
            break;
        }
        default: {
            print("\n\t>>> ");
            if (r->int_no < 32) {
                print("Exception: ");
                print(exception_messages[r->int_no]);
            } else if(r->int_no < 48)
                print("Interrupt Request");
            else if (r->int_no == 48)
                print("System Call");
            else
                print("Unanticipated exception");
            print(" (%u).  System halted.\n\n", r->int_no);

            if (r->int_no == 13) {
                print_regs(thisthread->context);
                print("\n");
            }
            print_regs(r);
            print("\n");

            if (isr_routines[r->int_no] != NULL)
                isr_routines[r->int_no](r);

            static volatile bool backtraced;

            if (!backtraced) {
                backtraced = true;
                backtrace_regs(r);
            }

            for (;;);
        }
    }
}

void isr_install_handler(int isr, void (*handler)(struct trapframe* r)) {
    assert(isr < NISR);
    isr_routines[isr] = handler;
}

void isr_uninstall_handler(int isr) {
    assert(isr < NISR);
    isr_routines[isr] = NULL;
}
