#include <lib.h>
#include <gcc.h>
#include <gdt.h>
#include <cpu.h>

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
void
gdt_set_gate(uint8_t num, uint32_t base, uint32_t lim, uint8_t dpl, uint8_t type) {
    gdt[num].limit_lo     = ((lim) >> 12) & 0xffff;
    gdt[num].base_lo      = (base) & 0xffff;
    gdt[num].base_md      = ((base) >> 16) & 0xff;
    gdt[num].type         = type;
    gdt[num].app          = 1;
    gdt[num].dpl          = dpl;
    gdt[num].present      = 1;
    gdt[num].sd_lim_19_16 = (lim) >> 28;
    gdt[num].available    = 0;
    gdt[num].zero         = 0;
    gdt[num].operand_size = 1;
    gdt[num].granularity  = 1;
    gdt[num].base_hi      = (base) >> 24;
}

void
gdt_set_gate16(uint8_t num, uint32_t base, uint32_t lim, uint8_t dpl, uint8_t type) {
    gdt[num].limit_lo     = (lim) & 0xffff;
    gdt[num].base_lo      = (base) & 0xffff;
    gdt[num].base_md      = ((base) >> 16) & 0xff;
    gdt[num].type         = type;
    gdt[num].app          = 1;
    gdt[num].dpl          = dpl;
    gdt[num].present      = 1;
    gdt[num].sd_lim_19_16 = (lim) >> 16;
    gdt[num].available    = 0;
    gdt[num].zero         = 0;
    gdt[num].operand_size = 1;
    gdt[num].granularity  = 0;
    gdt[num].base_hi      = (base) >> 24;
}

struct gdt_ptr gdt_addr;

void init_gdt(void) {
    gdt_addr.limit = sizeof(struct gdt_entry) * GDT_ENTRIES - 1;
    gdt_addr.base = (uint32_t) &gdt;

    gdt_set_gate(GDT_NULL,  0x0, 0x00000000, 0x00, 0x00);
    gdt_set_gate(GDT_KCODE, 0x0, 0xFFFFFFFF, DPL_KERN, STA_R | STA_X);
    gdt_set_gate(GDT_KDATA, 0x0, 0xFFFFFFFF, DPL_KERN, STA_W);
    gdt_set_gate(GDT_UCODE, 0x0, 0xBFFFFFFF, DPL_USER, STA_R | STA_X);
    gdt_set_gate(GDT_UDATA, 0x0, 0xBFFFFFFF, DPL_USER, STA_W);

    extern void gdt_flush();    // in asm.S
    gdt_flush();
}
