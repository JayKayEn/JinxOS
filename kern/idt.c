#include <int.h>
#include <lib.h>

#define IDT_ENTRIES 256

/* Defines an IDT entry */
struct idt_entry {
    uint16_t base_lo;
    uint16_t sel;
    uint8_t zero;           // 5 bits = (args == 0), 3 bits = reserved
    uint8_t flags;
    uint16_t base_hi;
};

struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

/* Declare an IDT of 256 entries. Although we will only use the
*  first 32 entries in this tutorial, the rest exists as a bit
*  of a trap. If any undefined IDT entry is hit, it normally
*  will cause an "Unhandled Interrupt" exception. Any descriptor
*  for which the 'presence' bit is cleared (0) will generate an
*  "Unhandled Interrupt" exception */
struct idt_entry idt[IDT_ENTRIES] = {{0}};
struct idt_ptr idtp;

/* This exists in 'start.asm', and is used to load our IDT */
extern void lidt(void);

/* Use this function to set an entry in the IDT. Alot simpler
*  than twiddling with the GDT ;) */
void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
    /* The interrupt routine's base address */
    idt[num].base_lo = (base & 0xFFFF);
    idt[num].base_hi = (base >> 16);

    /* The segment or 'selector' that this IDT entry will use
    *  is set here, along with any access flags */
    idt[num].sel = sel;
    idt[num].zero = 0;
    idt[num].flags = flags;
}

/* Installs the IDT */
void init_idt(void) {
    /* Sets the special IDT pointer up, just like in 'gdt.c' */
    idtp.limit = (sizeof(struct idt_entry) * IDT_ENTRIES) - 1;
    idtp.base = (uint32_t) &idt;

    /* Clear out the entire IDT, initializing it to zeros */
    memset(&idt, 0, sizeof(struct idt_entry) * IDT_ENTRIES);
    lidt();
}
