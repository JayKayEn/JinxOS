#include <int.h>
#include <lib.h>
#include <x86.h>
#include <gdt.h>

#define IDT_ENTRIES 256

/* Defines an IDT entry */
// struct idt_entry {
//     uint16_t base_lo;
//     uint16_t sel;
//     uint8_t zero;           // 5 bits = (args == 0), 3 bits = reserved
//     uint8_t flags;
//     uint16_t base_hi;
// };

struct idt_entry {
    uint16_t gd_off_15_0;   // low 16 bits of offset in segment
    uint16_t gd_sel;        // segment selector
    uint8_t  gd_zero;
    uint8_t  gd_type : 4;        // type(STS_{TG,IG32,TG32})
    uint8_t  gd_s : 1;           // must be 0 (system)
    uint8_t  gd_dpl : 2;         // descriptor(meaning new) privilege level
    uint8_t  gd_p : 1;           // Present
    uint16_t gd_off_31_16;      // high bits of offset in segment
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

void
idt_set_gate(uint8_t num, bool istrap, uint16_t sel, uint32_t off, uint8_t dpl) {
    idt[num].gd_off_15_0  = (uint32_t) (off) & 0xffff;
    idt[num].gd_sel       = (sel);
    idt[num].gd_zero      = 0;
    idt[num].gd_type      = (istrap) ? STS_TG32 : STS_IG32;
    idt[num].gd_s         = 0;
    idt[num].gd_dpl       = (dpl);
    idt[num].gd_p         = 1;
    idt[num].gd_off_31_16 = (uint32_t) (off) >> 16;
}

void
idt_set_gate2(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
    /* The interrupt routine's base address */
    idt[num].gd_off_15_0 = (base & 0xFFFF);
    idt[num].gd_off_31_16 = (base >> 16);

    /* The segment or 'selector' that this IDT entry will use
    *  is set here, along with any access flags */
    idt[num].gd_sel = sel;
    idt[num].gd_zero = 0;

    idt[num].gd_type      = (flags & 0xF) ? STS_TG32 : STS_IG32;
    idt[num].gd_s         = 0;
    idt[num].gd_dpl       = (flags >> 5) & 3;
    idt[num].gd_p         = (flags >> 7) & 1;
}

/* Installs the IDT */
void init_idt(void) {
    /* Sets the special IDT pointer up, just like in 'gdt.c' */
    idtp.limit = (sizeof(struct idt_entry) * IDT_ENTRIES) - 1;
    idtp.base = (uint32_t) &idt;

    /* Clear out the entire IDT, initializing it to zeros */
    memset(&idt, 0, sizeof(struct idt_entry) * IDT_ENTRIES);
}
