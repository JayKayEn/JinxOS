#ifndef _E820_H_
#define _E820_H_

#include <lib.h>

#define E820_MAX_SIZE 64

// ACPI 15, Table 15-312, Address Range Types
enum {
    E820_AVAILABLE   = 1,
    E820_RESERVED    = 2,
    E820_RECLAIMABLE = 3,
    E820_ACPI_NVS    = 4,
    E820_UNUSABLE    = 5,
};

// ACPI 15.1, INT 15H, E820H
// Ignore extended attributes.
struct e820_e {
    uint64_t addr;
    uint64_t len;
    uint32_t type;
} __attribute__((packed));

struct e820_map {
    struct e820_e entries[E820_MAX_SIZE];
    uint32_t size;
};

extern struct e820_map e820_map;

// void init_e820(size_t mbi_addr);
void print_e820_mmap(void);

#endif // _E820_H_
