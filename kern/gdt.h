#ifndef _GDT_H_
#define _GDT_H_

#include <cpu.h>

enum {
    GDT_NULL,
    GDT_KCODE,
    GDT_KDATA,
    GDT_UCODE,
    GDT_UDATA,
    GDT_TSS
};

#define GDT_ENTRIES (GDT_TSS + NCPU)

struct gdt_entry {
    uint16_t limit_lo;          // Low bits of segment limit
    uint16_t base_lo;           // Low bits of segment base address
    uint8_t  base_md;           // Middle bits of segment base address
    uint8_t  type : 4;          // Segment type (see STS_ constants)
    uint8_t  app : 1;           // 0 = system, 1 = application
    uint8_t  dpl : 2;           // Descriptor Privilege Level
    uint8_t  present : 1;       // Present
    uint8_t  sd_lim_19_16 : 4;  // High bits of segment limit
    uint8_t  available : 1;     // Available for software use (set to 0)
    uint8_t  zero : 1;          // Reserved (set to 0)
    uint8_t  operand_size : 1;  // 0 = 16-bit segment, 1 = 32-bit segment
    uint8_t  granularity : 1;   // Granularity: limit scaled by 4K when set
    uint8_t  base_hi;           // High bits of segment base address
} PACKED;

struct gdt_ptr {
    uint16_t limit;
    uint32_t base;
} PACKED;

struct gdt_entry gdt[GDT_ENTRIES];
extern struct gdt_ptr gdt_addr;

#define GD_KT      (GDT_KCODE << 3)
#define GD_KD      (GDT_KDATA << 3)
#define GD_UT      (GDT_UCODE << 3)
#define GD_UD      (GDT_UDATA << 3)
#define GD_TSS     (GDT_TSS << 3)

// Application segment type bits
#define STA_A       0x1     // Accessed
#define STA_R       0x2     // Readable (executable segments)
#define STA_W       0x2     // Writeable (non-executable segments)
#define STA_C       0x4     // Conforming code segment (executable only)
#define STA_E       0x4     // Expand down (non-executable segments)
#define STA_X       0x8     // Executable segment

// System segment type bits
#define STS_T16A    0x1     // Available 16-bit TSS
#define STS_LDT     0x2     // Local Descriptor Table
#define STS_T16B    0x3     // Busy 16-bit TSS
#define STS_CG16    0x4     // 16-bit Call Gate
#define STS_TG      0x5     // Task Gate / Coum Transmitions
#define STS_IG16    0x6     // 16-bit Interrupt Gate
#define STS_TG16    0x7     // 16-bit Trap Gate
#define STS_T32A    0x9     // Available 32-bit TSS
#define STS_T32B    0xB     // Busy 32-bit TSS
#define STS_CG32    0xC     // 32-bit Call Gate
#define STS_IG32    0xE     // 32-bit Interrupt Gate
#define STS_TG32    0xF     // 32-bit Trap Gate

#define DPL_KERN    0x0
#define DPL_USER    0x3

void gdt_set_gate(uint8_t num, uint32_t base, uint32_t lim, uint8_t dpl, uint8_t type);
void gdt_set_gate16(uint8_t num, uint32_t base, uint32_t lim, uint8_t dpl, uint8_t type);

#endif // _GDT_H_
