#ifndef _MULTIBOOT_H_
#define _MULTIBOOT_H_

#define MB_HEADER_MAGIC     0x1BADB002
#define MB_MEM_INFO         0x00000002
#define MB_EAX_MAGIC        0x2BADB002
#define MB_MEM_MAP          0x00000040

#ifndef __ASSEMBLER__

#include <e820.h>

struct multiboot_info {
    uint32_t flags;
    uint32_t ignore_0[10];
    uint32_t mmap_length;
    uint32_t mmap_addr;
    uint32_t ignore_1[9];
} __attribute__((packed));

struct multiboot_mmap_entry {
    uint32_t size;
    struct e820_e e820;
} __attribute__((packed));

extern struct multiboot_info* mbi;

#endif // __ASSEMBLER__

#endif // _MULTIBOOT_H_
