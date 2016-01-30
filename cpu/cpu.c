#include <lib.h>
#include <x86.h>
#include <acpi.h>
#include <cpu.h>
#include <x86.h>
#include <threadlist.h>
#include <vmm.h>
#include <kmm.h>
#include <proc.h>
#include <cpuid.h>
#include <mp.h>

struct cpu*
cpu_create(uint8_t id) {
    struct cpu* cpu = kmalloc(sizeof(struct cpu));
    if (cpu == NULL)
        panic("kmalloc returned NULL\n");

    cpu->self = cpu;
    cpu->apicid = id;

    cpu->thread = NULL;
    threadlist_init(&cpu->zombie_threads);

    cpu->status = CPU_STARTED;
    threadlist_init(&cpu->active_threads);
    spinlock_init(&cpu->active_threads_lock);

    // cpu->ipi_pending = 0;
    // cpu->numshootdown = 0;
    // spinlock_init(&cpu->ipi_lock);

    char namebuf[24] = {0};
    snprintf(namebuf, sizeof(namebuf), "boot thread %d", cpu->apicid);
    cpu->thread = thread_create(namebuf);
    if (cpu->thread == NULL)
        panic("thread_create failed\n");

    if (id != 0) {
        int result = proc_addthread(kproc, cpu->thread);
        if (result)
            panic("proc_addthread\n");
    }

    return cpu;
}

uint8_t apicids[NCPU] = {0};

void
init_smp(void) {
    extern size_t lapic_addr;
    extern size_t ioapic_addr;

    assert(ncpu == 0);

    // 5.2.12.1 MADT Processor Local APIC / SAPIC Structure Entry Order
    // * initialize processors in the order that they appear in MADT;
    // * the boot processor is the first processor entry.
    struct acpi_table_madt* madt = acpi_get_table(ACPI_SIG_MADT);
    if (!madt)
        panic("ACPI: No MADT found");

    lapic_addr = madt->address;

    struct acpi_subtable_header* hdr = (void*) madt + sizeof(*madt);
    struct acpi_subtable_header* end = (void*) madt + madt->header.length;
    for (; hdr < end; hdr = (void*) hdr + hdr->length) {
        switch (hdr->type) {
            case ACPI_MADT_TYPE_LOCAL_APIC: {
                struct acpi_madt_local_apic* p = (void*) hdr;
                bool enabled = p->lapic_flags & BIT(0);
                if (ncpu < NCPU && enabled)
                    apicids[ncpu++] = p->id;
                break;
            }
            case ACPI_MADT_TYPE_IO_APIC: {
                struct acpi_madt_io_apic* p = (void*) hdr;
                if (p->global_irq_base == 0)
                    ioapic_addr = p->address;
                break;
            }
            default:
                break;
        }
    }

    // print("SMP: %d CPU(s)\n", ncpu);
}

void
cpu_idle(void) {
    print("thisthread: %08p\n", thisthread);
    panic("cpu_idle on cpunum %u", cpunum());
    thisproc = NULL;

    lcr3(PADDR(kpd));

    // Mark that this CPU is in the HALT state, so that when
    // timer interupts come in, we know we should re-acquire the
    // big kernel lock
    xchg((uint32_t*) &thiscpu->status, CPU_IDLE);

    // Release the big kernel lock as if we were "leaving" the kernel
    unlock_kernel();

    panic("cpu_idle not implemented");

    // Reset stack pointer, enable interrupts and then halt.
    // asm volatile (
    //     "movl $0, %%ebp\n"
    //     "movl %0, %%esp\n"
    //     "pushl $0\n"
    //     "pushl $0\n"
    //     "sti\n"
    //     "1:\n"
    //     "hlt\n"
    //     "jmp 1b\n"
    //     : : "a" (ebstack)
    // );
}

void
init_cpu(void) {
    cpuid_info();

    assert(ncpu > 0);

    bootcpu = cpu_create(apicids[0]);
    assert(cpus[0] != NULL);

    thisthread = bootthread = bootcpu->thread;

    thisthread->cpu = bootcpu;
    // thisthread->page_directory = kpd;
    // thisthread->stack = stackreg_get();

    mp_lgdt();
    mp_ltr();
    mp_lidt();
}
