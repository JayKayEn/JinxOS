#ifndef _CPU_H_
#define _CPU_H_

#include <lib.h>
#include <thread.h>
#include <threadlist.h>
#include <spinlock.h>
#include <tss.h>
#include <gcc.h>
#include <vmm.h>

enum {
    CPU_OFF = 0,
    CPU_STARTED,
    CPU_HALTED,
    CPU_IDLE
};

struct cpu {
    struct cpu* self;
    // uint8_t id;                 //
    uint8_t apicid;               // Local APIC ID supplied by the hardware
    volatile uint8_t status;

    struct thread* thread; /* Current thread on cpu */
    uint32_t spinlocks;       /* Counter of spinlocks held */

    struct threadlist zombie_threads;    /* List of exited threads */
    struct threadlist active_threads;   /* Run queue for this cpu */
    struct spinlock active_threads_lock;

    uint32_t ipi_pending;     /* One bit for each IPI number */
    // struct tlbshootdown shootdown[TLBSHOOTDOWN_MAX];
    int numshootdown;
    struct spinlock ipi_lock;

    struct taskstate ts;
};

#define NCPU 8
struct cpu* cpus[NCPU];
uint8_t ncpu;

int cpunum(void);
#define thiscpu (cpus[cpunum()])
#define bootcpu (cpus[0])          // The boot-strap processor (BSP)

void init_cpu(void);
struct cpu* cpu_create(uint8_t id);

void cpu_idle(void);

void cpu_start_secondary(void);
void cpu_hatch(unsigned software_number);

#endif // _CPU_H_
