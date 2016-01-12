#include <lib.h>
#include <x86.h>
#include <gcc.h>
#include <acpi.h>
#include <cpu.h>
#include <x86.h>
#include <threadlist.h>
#include <vmm.h>
#include <kmm.h>
#include <proc.h>
#include <stackreg.h>

uint8_t percpu_kstacks[NCPU][KSTKSIZE] PAGE_ALIGNED;

#define CPUID_BIT(base, off)    (((base) << 5) + (off))

enum {
    CPUID_1_EDX = 0,
    CPUID_1_ECX,
    CPUID_7_EBX,
    CPUID_80000001_EDX,
    CPUID_80000001_ECX,
    CPUID_NFLAGS,
};

// CPUID(1): EDX
enum {
    CPUID_FPU           = CPUID_BIT(CPUID_1_EDX, 0),
    CPUID_VME           = CPUID_BIT(CPUID_1_EDX, 1),
    CPUID_DE            = CPUID_BIT(CPUID_1_EDX, 2),
    CPUID_PSE           = CPUID_BIT(CPUID_1_EDX, 3),
    CPUID_TSC           = CPUID_BIT(CPUID_1_EDX, 4),
    CPUID_MSR           = CPUID_BIT(CPUID_1_EDX, 5),
    CPUID_PAE           = CPUID_BIT(CPUID_1_EDX, 6),
    CPUID_MCE           = CPUID_BIT(CPUID_1_EDX, 7),
    CPUID_CX8           = CPUID_BIT(CPUID_1_EDX, 8),
    CPUID_APIC          = CPUID_BIT(CPUID_1_EDX, 9),
    // reserved         = CPUID_BIT(CPUID_1_EDX, 10),
    CPUID_SEP           = CPUID_BIT(CPUID_1_EDX, 11),
    CPUID_MTRR          = CPUID_BIT(CPUID_1_EDX, 12),
    CPUID_PGE           = CPUID_BIT(CPUID_1_EDX, 13),
    CPUID_MCA           = CPUID_BIT(CPUID_1_EDX, 14),
    CPUID_CMOV          = CPUID_BIT(CPUID_1_EDX, 15),
    CPUID_PAT           = CPUID_BIT(CPUID_1_EDX, 16),
    CPUID_PSE36         = CPUID_BIT(CPUID_1_EDX, 17),
    CPUID_PN            = CPUID_BIT(CPUID_1_EDX, 18),
    CPUID_CLFLUSH       = CPUID_BIT(CPUID_1_EDX, 19),
    // reserved         = CPUID_BIT(CPUID_1_EDX, 20),
    CPUID_DS            = CPUID_BIT(CPUID_1_EDX, 21),
    CPUID_ACPI          = CPUID_BIT(CPUID_1_EDX, 22),
    CPUID_MMX           = CPUID_BIT(CPUID_1_EDX, 23),
    CPUID_FXSR          = CPUID_BIT(CPUID_1_EDX, 24),
    CPUID_SSE           = CPUID_BIT(CPUID_1_EDX, 25),
    CPUID_SSE2          = CPUID_BIT(CPUID_1_EDX, 26),
    CPUID_SS            = CPUID_BIT(CPUID_1_EDX, 27),
    CPUID_HT            = CPUID_BIT(CPUID_1_EDX, 28),
    CPUID_TM            = CPUID_BIT(CPUID_1_EDX, 29),
    CPUID_IA64          = CPUID_BIT(CPUID_1_EDX, 30),
    CPUID_PBE           = CPUID_BIT(CPUID_1_EDX, 31),
};

// CPUID(1): ECX
enum {
    CPUID_SSE3          = CPUID_BIT(CPUID_1_ECX, 0),
    CPUID_PCLMULQDQ     = CPUID_BIT(CPUID_1_ECX, 1),
    CPUID_DTES64        = CPUID_BIT(CPUID_1_ECX, 2),
    CPUID_MONITOR       = CPUID_BIT(CPUID_1_ECX, 3),
    CPUID_DSCPL         = CPUID_BIT(CPUID_1_ECX, 4),
    CPUID_VMX           = CPUID_BIT(CPUID_1_ECX, 5),
    CPUID_SMX           = CPUID_BIT(CPUID_1_ECX, 6),
    CPUID_EST           = CPUID_BIT(CPUID_1_ECX, 7),
    CPUID_TM2           = CPUID_BIT(CPUID_1_ECX, 8),
    CPUID_SSSE3         = CPUID_BIT(CPUID_1_ECX, 9),
    CPUID_CID           = CPUID_BIT(CPUID_1_ECX, 10),
    CPUID_SDBG          = CPUID_BIT(CPUID_1_ECX, 11),
    CPUID_FMA           = CPUID_BIT(CPUID_1_ECX, 12),
    CPUID_CX16          = CPUID_BIT(CPUID_1_ECX, 13),
    CPUID_XTPR          = CPUID_BIT(CPUID_1_ECX, 14),
    CPUID_PDCM          = CPUID_BIT(CPUID_1_ECX, 15),
    // reserved         = CPUID_BIT(CPUID_1_ECX, 16),
    CPUID_PCID          = CPUID_BIT(CPUID_1_ECX, 17),
    CPUID_DCA           = CPUID_BIT(CPUID_1_ECX, 18),
    CPUID_SSE41         = CPUID_BIT(CPUID_1_ECX, 19),
    CPUID_SSE42         = CPUID_BIT(CPUID_1_ECX, 20),
    CPUID_X2APIC        = CPUID_BIT(CPUID_1_ECX, 21),
    CPUID_MOVBE         = CPUID_BIT(CPUID_1_ECX, 22),
    CPUID_POPCNT        = CPUID_BIT(CPUID_1_ECX, 23),
    CPUID_TSC_DEADLINE  = CPUID_BIT(CPUID_1_ECX, 24),
    CPUID_AES           = CPUID_BIT(CPUID_1_ECX, 25),
    CPUID_XSAVE         = CPUID_BIT(CPUID_1_ECX, 26),
    CPUID_OSXSAVE       = CPUID_BIT(CPUID_1_ECX, 27),
    CPUID_AVX           = CPUID_BIT(CPUID_1_ECX, 28),
    CPUID_F16C          = CPUID_BIT(CPUID_1_ECX, 29),
    CPUID_RDRAND        = CPUID_BIT(CPUID_1_ECX, 30),
    CPUID_HYPERVISOR    = CPUID_BIT(CPUID_1_ECX, 31),
};

// CPUID(0x80000001): EDX
enum {
    CPUID_SYSCALL       = CPUID_BIT(CPUID_80000001_EDX, 11),
    CPUID_MP            = CPUID_BIT(CPUID_80000001_EDX, 19),
    CPUID_NX            = CPUID_BIT(CPUID_80000001_EDX, 20),
    CPUID_MMXEXT        = CPUID_BIT(CPUID_80000001_EDX, 22),
    CPUID_FXSR_OPT      = CPUID_BIT(CPUID_80000001_EDX, 25),
    CPUID_PDPE1GB       = CPUID_BIT(CPUID_80000001_EDX, 26),
    CPUID_RDTSCP        = CPUID_BIT(CPUID_80000001_EDX, 27),
    CPUID_LM            = CPUID_BIT(CPUID_80000001_EDX, 29),
    CPUID_3DNOWEXT      = CPUID_BIT(CPUID_80000001_EDX, 30),
    CPUID_3DNOW         = CPUID_BIT(CPUID_80000001_EDX, 31),
};

// CPUID(0x80000001): ECX
enum {
    CPUID_LAHF_LM       = CPUID_BIT(CPUID_80000001_ECX, 0),
    CPUID_CMP_LEGACY    = CPUID_BIT(CPUID_80000001_ECX, 1),
    CPUID_SVM           = CPUID_BIT(CPUID_80000001_ECX, 2),
    CPUID_EXTAPIC       = CPUID_BIT(CPUID_80000001_ECX, 3),
    CPUID_CR8LEGACY     = CPUID_BIT(CPUID_80000001_ECX, 4),
    CPUID_ABM           = CPUID_BIT(CPUID_80000001_ECX, 5),
    CPUID_SSE4A         = CPUID_BIT(CPUID_80000001_ECX, 6),
    CPUID_MISALIGNSSE   = CPUID_BIT(CPUID_80000001_ECX, 7),
    CPUID_3DNOWPREFETCH = CPUID_BIT(CPUID_80000001_ECX, 8),
    CPUID_OSVW          = CPUID_BIT(CPUID_80000001_ECX, 9),
    CPUID_IBS           = CPUID_BIT(CPUID_80000001_ECX, 10),
    CPUID_XOP           = CPUID_BIT(CPUID_80000001_ECX, 11),
    CPUID_SKINIT        = CPUID_BIT(CPUID_80000001_ECX, 12),
    CPUID_WDT           = CPUID_BIT(CPUID_80000001_ECX, 13),

    CPUID_LWP           = CPUID_BIT(CPUID_80000001_ECX, 15),
    CPUID_FMA4          = CPUID_BIT(CPUID_80000001_ECX, 16),
    CPUID_TCE           = CPUID_BIT(CPUID_80000001_ECX, 17),

    CPUID_NODEID_MSR    = CPUID_BIT(CPUID_80000001_ECX, 19),

    CPUID_TBM           = CPUID_BIT(CPUID_80000001_ECX, 21),
    CPUID_TOPOEXT       = CPUID_BIT(CPUID_80000001_ECX, 22),
    CPUID_PERFCTR_CORE  = CPUID_BIT(CPUID_80000001_ECX, 23),
    CPUID_PERFCTR_NB    = CPUID_BIT(CPUID_80000001_ECX, 24),
};

static const char* features[CPUID_BIT(CPUID_NFLAGS, 0)] = {
    // CPUID(1): EDX
    [CPUID_FPU]           = "fpu",
    [CPUID_VME]           = "vme",
    [CPUID_DE]            = "de",
    [CPUID_PSE]           = "pse",
    [CPUID_TSC]           = "tsc",
    [CPUID_MSR]           = "msr",
    [CPUID_PAE]           = "pae",
    [CPUID_MCE]           = "mce",
    [CPUID_CX8]           = "cx8",
    [CPUID_APIC]          = "apic",
    [CPUID_SEP]           = "sep",
    [CPUID_MTRR]          = "mtrr",
    [CPUID_PGE]           = "pge",
    [CPUID_MCA]           = "mca",
    [CPUID_CMOV]          = "cmov",
    [CPUID_PAT]           = "pat",
    [CPUID_PSE36]         = "pse36",
    [CPUID_PN]            = "pn",
    [CPUID_CLFLUSH]       = "clflush",
    [CPUID_DS]            = "ds",
    [CPUID_ACPI]          = "acpi",
    [CPUID_MMX]           = "mmx",
    [CPUID_FXSR]          = "fxsr",
    [CPUID_SSE]           = "sse",
    [CPUID_SSE2]          = "sse2",
    [CPUID_SS]            = "ss",
    [CPUID_HT]            = "ht",
    [CPUID_TM]            = "tm",
    [CPUID_IA64]          = "ia64",
    [CPUID_PBE]           = "pbe",

    // CPUID(1): ECX
    [CPUID_SSE3]          = "sse3",
    [CPUID_PCLMULQDQ]     = "pclmulqdq",
    [CPUID_DTES64]        = "dtes64",
    [CPUID_MONITOR]       = "monitor",
    [CPUID_DSCPL]         = "ds_cpl",
    [CPUID_VMX]           = "vmx",
    [CPUID_SMX]           = "smx",
    [CPUID_EST]           = "est",
    [CPUID_TM2]           = "tm2",
    [CPUID_SSSE3]         = "ssse3",
    [CPUID_CID]           = "cid",
    [CPUID_SDBG]          = "sdbg",
    [CPUID_FMA]           = "fma",
    [CPUID_CX16]          = "cx16",
    [CPUID_XTPR]          = "xtpr",
    [CPUID_PDCM]          = "pdcm",
    [CPUID_PCID]          = "pcid",
    [CPUID_DCA]           = "dca",
    [CPUID_SSE41]         = "sse4.1",
    [CPUID_SSE42]         = "sse4.2",
    [CPUID_X2APIC]        = "x2apic",
    [CPUID_MOVBE]         = "movbe",
    [CPUID_POPCNT]        = "popcnt",
    [CPUID_TSC_DEADLINE]  = "tsc-deadline",
    [CPUID_AES]           = "aes",
    [CPUID_XSAVE]         = "xsave",
    [CPUID_OSXSAVE]       = "osxsave",
    [CPUID_AVX]           = "avx",
    [CPUID_F16C]          = "f16c",
    [CPUID_RDRAND]        = "rdrand",
    [CPUID_HYPERVISOR]    = "hypervisor",

    // CPUID(0x80000001): EDX
    [CPUID_SYSCALL]       = "syscall",
    [CPUID_MP]            = "mp",
    [CPUID_NX]            = "nx",
    [CPUID_MMXEXT]        = "mmxext",
    [CPUID_FXSR_OPT]      = "fxsr_opt",
    [CPUID_PDPE1GB]       = "pdpe1gb",
    [CPUID_RDTSCP]        = "rdtscp",
    [CPUID_LM]            = "lm",
    [CPUID_3DNOWEXT]      = "3dnowext",
    [CPUID_3DNOW]         = "3dnow",

    // CPUID(0x80000001): ECX
    [CPUID_LAHF_LM]       = "lahf_lm",
    [CPUID_CMP_LEGACY]    = "cmp_legacy",
    [CPUID_SVM]           = "svm",
    [CPUID_EXTAPIC]       = "extapic",
    [CPUID_CR8LEGACY]     = "cr8legacy",
    [CPUID_ABM]           = "abm",
    [CPUID_SSE4A]         = "sse4a",
    [CPUID_MISALIGNSSE]   = "misalignsse",
    [CPUID_3DNOWPREFETCH] = "3dnowprefetch",
    [CPUID_OSVW]          = "osvw",
    [CPUID_IBS]           = "ibs",
    [CPUID_XOP]           = "xop",
    [CPUID_SKINIT]        = "skinit",
    [CPUID_WDT]           = "wdt",
    [CPUID_LWP]           = "lwp",
    [CPUID_FMA4]          = "fma4",
    [CPUID_TCE]           = "tce",
    [CPUID_NODEID_MSR]    = "nodeid_msr",
    [CPUID_TBM]           = "tbm",
    [CPUID_TOPOEXT]       = "topoext",
    [CPUID_PERFCTR_CORE]  = "perfctr_core",
    [CPUID_PERFCTR_NB]    = "perfctr_nb",
};

static void
print_feature(uint32_t* feature) {
    int i, j;

    for (i = 0; i < CPUID_NFLAGS; ++i) {
        if (!feature[i])
            continue;
        print(" ");
        for (j = 0; j < 32; ++j) {
            const char* name = features[CPUID_BIT(i, j)];

            if ((feature[i] & BIT(j)) && name)
                print(" %s", name);
        }
        print("\n");
    }
}

static bool
cpuid_has(uint32_t* feature, unsigned int bit) {
    return feature[bit / 32] & BIT(bit % 32);
}

static void
cpuid_info(void) {
    uint32_t eax, brand[12], feature[CPUID_NFLAGS] = {0};

    cpuid(0x80000000, &eax, NULL, NULL, NULL);
    if (eax < 0x80000004)
        panic("CPU too old!");

    cpuid(0x80000002, &brand[0], &brand[1], &brand[2], &brand[3]);
    cpuid(0x80000003, &brand[4], &brand[5], &brand[6], &brand[7]);
    cpuid(0x80000004, &brand[8], &brand[9], &brand[10], &brand[11]);
    print("CPU: %.48s\n", brand);

    cpuid(1, NULL, NULL,
          &feature[CPUID_1_ECX], &feature[CPUID_1_EDX]);
    cpuid(0x80000001, NULL, NULL,
          &feature[CPUID_80000001_ECX], &feature[CPUID_80000001_EDX]);
    print_feature(feature);
    // Check feature bits.
    assert(cpuid_has(feature, CPUID_PSE));
    assert(cpuid_has(feature, CPUID_APIC));
}

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

    print("SMP: %d CPU(s)\n", ncpu);
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

    thisthread = bootcpu->thread;
    thisthread->cpu = bootcpu;
    thisthread->page_directory = kpd;
    thisthread->stack = stackreg_get();
}
