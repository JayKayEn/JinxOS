#ifndef _CPU_H_
#define _CPU_H_

#include <lib.h>

#define NCPU  8

enum {
    CPU_UNUSED = 0,
    CPU_STARTED,
    CPU_HALTED,
};

struct cpu {
    uint8_t id;                 //
    uint8_t apic;               // Local APIC ID supplied by the hardware
    volatile uint8_t status;
};

#endif // _CPU_H_
