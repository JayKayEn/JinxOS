#include <lib.h>
#include <gcc.h>
#include <gdt.h>

#define GDT_ENTRIES 5

struct gdt_entry {
    uint16_t limit_lo;
    uint16_t base_lo;
    uint8_t  base_md;
    uint8_t  access;
    uint8_t  granularity;
    uint8_t  base_hi;
} PACKED;

struct gdt_ptr {
    uint16_t limit;
    uint32_t base;
} PACKED;

struct gdt_entry gdt[GDT_ENTRIES];

/*
 * This is in start.asm. We use this to properly reload
 * the new segment registers
 */
extern void gdt_flush();

/*
 * Setup a descriptor in the Global Descriptor Table.
 *
 *  access
 *  +----------------------+    P    - Present (1 = Yes)
 *  | 7 | 6-5 | 4  | 3 - 0 |    DPL  - Data Protection Level (0 to 3)
 *  +----------------------+    DT   - Descriptor Type
 *  | P | DPL | DT | Type  |    Type - Which type?
 *  +----------------------+
 *
 *  gran
 *  +------------------------+  G      - Granularitty (1 = 4KB, 0 = 1B)
 *  | 7 | 6 | 5 | 4 | 3 - 0  |  D      - Operand Size (0 = 16-bit, 1 = 32-bit)
 *  +------------------------+  A      - Available for System (Always set to 0)
 *  | G | D | 0 | A | SegLen |  SegLen - 0xF
 *  +------------------------+
 *
 */
void gdt_set_gate(uint8_t num, uint32_t base, uint32_t limit, uint8_t access,
                  uint8_t gran) {
    /* Setup the descriptor base address */
    gdt[num].base_lo = (base & 0xFFFF);
    gdt[num].base_md = (base >> 16) & 0xFF;
    gdt[num].base_hi = (base >> 24) & 0xFF;

    /* Setup the descriptor limits */
    gdt[num].limit_lo = (limit & 0xFFFF);
    gdt[num].granularity = ((limit >> 16) & 0x0F);

    /* Finally, set up the granularity and access flags */
    gdt[num].granularity |= (gran & 0xF0);
    gdt[num].access = access;
}

enum {
    GDT_NULL,
    GDT_KCODE,
    GDT_KDATA,
    GDT_UCODE,
    GDT_UDATA,
};

struct gdt_ptr gp;

void init_gdt(void) {
    gp.limit = (sizeof(struct gdt_entry) * GDT_ENTRIES) - 1;
    gp.base = (uint32_t) &gdt;

    gdt_set_gate(GDT_NULL,  0, 0x00000000, 0x00, 0x00);
    gdt_set_gate(GDT_KCODE, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    gdt_set_gate(GDT_KDATA, 0, 0xFFFFFFFF, 0x92, 0xCF);
    gdt_set_gate(GDT_UCODE, 0, 0xBFFFFFFF, 0xFA, 0xCF);
    gdt_set_gate(GDT_UDATA, 0, 0xBFFFFFFF, 0xF2, 0xCF);

    gdt_flush();    // asm.c
}
