#include <lib.h>
#include <x86.h>
#include <int.h>

#define IRQ_MAX_NUM 16

/* These are own ISRs that point to our special IRQ handler
*  instead of the regular 'fault_handler' function */
extern void irq0(void);
extern void irq1(void);
extern void irq2(void);
extern void irq3(void);
extern void irq4(void);
extern void irq5(void);
extern void irq6(void);
extern void irq7(void);
extern void irq8(void);
extern void irq9(void);
extern void irq10(void);
extern void irq11(void);
extern void irq12(void);
extern void irq13(void);
extern void irq14(void);
extern void irq15(void);

/* This array is actually an array of function pointers. We use
*  this to handle custom IRQ handlers for a given IRQ */
static void (*irq_routines[IRQ_MAX_NUM])(struct regs*) = {0};

/* This installs a custom IRQ handler for the given IRQ */
void irq_install_handler(int irq, void (*handler)(struct regs* r)) {
    assert(irq < IRQ_MAX_NUM);
    irq_routines[irq] = handler;
}

/* This clears the handler for a given IRQ */
void irq_uninstall_handler(int irq) {
    assert(irq < IRQ_MAX_NUM);
    irq_routines[irq] = 0;
}

/* Normally, IRQs 0 to 7 are mapped to entries 8 to 15. This
*  is a problem in protected mode, because IDT entry 8 is a
*  Double Fault! Without remapping, every time IRQ0 fires,
*  you get a Double Fault Exception, which is NOT actually
*  what's happening. We send commands to the Programmable
*  Interrupt Controller (PICs - also called the 8259's) in
*  order to make IRQ0 to 15 be remapped to IDT entries 32 to
*  47 */
void irq_remap(void) {
    outb(0x20, 0x11);
    outb(0xA0, 0x11);
    outb(0x21, 0x20);
    outb(0xA1, 0x28);
    outb(0x21, 0x04);
    outb(0xA1, 0x02);
    outb(0x21, 0x01);
    outb(0xA1, 0x01);
    outb(0x21, 0x0);
    outb(0xA1, 0x0);
}

/* We first remap the interrupt controllers, and then we install
*  the appropriate ISRs to the correct entries in the IDT. This
*  is just like installing the exception handlers */
void init_irq(void) {
    irq_remap();

    idt_set_gate(IRQ_OFFSET + IRQ_TIMER,  (unsigned) irq0,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_KBD,    (unsigned) irq1,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_SLAVE,  (unsigned) irq2,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_SER2,   (unsigned) irq3,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_SER1,   (unsigned) irq4,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_SOUND,  (unsigned) irq5,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_FLOPPY, (unsigned) irq6,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_SPUR,   (unsigned) irq7,  0x08, 0x8E);

    idt_set_gate(IRQ_OFFSET + IRQ_RTC,    (unsigned) irq8,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_ACPI,   (unsigned) irq9,  0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_SCSI,   (unsigned) irq10, 0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_NIC,    (unsigned) irq11, 0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_MOUSE,  (unsigned) irq12, 0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_FPU,    (unsigned) irq13, 0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_IDE,    (unsigned) irq14, 0x08, 0x8E);
    idt_set_gate(IRQ_OFFSET + IRQ_IPI,    (unsigned) irq15, 0x08, 0x8E);
}

/* Each of the IRQ ISRs point to this function, rather than
*  the 'fault_handler' in 'isr.c'. The IRQ Controllers need
*  to be told when you are done servicing them, so you need
*  to send them an "End of Interrupt" command (0x20). There
*  are two 8259 chips: The first exists at 0x20, the second
*  exists at 0xA0. If the second controller (an IRQ from 8 to
*  15) gets an interrupt, you need to acknowledge the
*  interrupt at BOTH controllers, otherwise, you only send
*  an EOI command to the first controller. If you don't send
*  an EOI, you won't raise any more IRQs */
void irq_handler(struct regs* r) {
    /* Find out if we have a custom handler to run for this
    *  IRQ, and then finally, run it */
    void (*handler)(struct regs* r) = irq_routines[r->int_no - IRQ_OFFSET];
    if (handler)
        handler(r);

    /* If the IDT entry that was invoked was greater than 40
    *  (meaning IRQ8 - 15), then we need to send an EOI to
    *  the slave controller */
    if (r->int_no >= 40)
        outb(0xA0, 0x20);

    /* In either case, we need to send an EOI to the master
    *  interrupt controller too */
    outb(0x20, 0x20);
}
