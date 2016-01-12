#include <lib.h>
#include <x86.h>
#include <int.h>
#include <thread.h>

#define NIRQ 16

static void (*irq_routines[NIRQ])(struct regs*);

extern void  irq0(void);
extern void  irq1(void);
extern void  irq2(void);
extern void  irq3(void);
extern void  irq4(void);
extern void  irq5(void);
extern void  irq6(void);
extern void  irq7(void);
extern void  irq8(void);
extern void  irq9(void);
extern void irq10(void);
extern void irq11(void);
extern void irq12(void);
extern void irq13(void);
extern void irq14(void);
extern void irq15(void);

void irq_install_handler(int irq, void (*handler)(struct regs* r)) {
    assert(irq < NIRQ);
    irq_routines[irq] = handler;
}

void irq_uninstall_handler(int irq) {
    assert(irq < NIRQ);
    irq_routines[irq] = NULL;
}

void irq_remap(void) {
    outb(0x20, 0x11);
    outb(0x21, 0x20);
    outb(0x21, 0x04);
    outb(0x21, 0x01);

    outb(0xA0, 0x11);
    outb(0xA1, 0x28);
    outb(0xA1, 0x02);
    outb(0xA1, 0x01);

    outb(0x21, 0x00);
    outb(0xA1, 0x00);
}

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

void irq_handler(struct regs* r) {
    // thisthread->context = r;

    void (*handler)(struct regs * r) = irq_routines[r->int_no - IRQ_OFFSET];
    if (handler)
        handler(r);

    if (r->int_no >= 0x28)
        outb(0xA0, 0x20);

    outb(0x20, 0x20);
}
