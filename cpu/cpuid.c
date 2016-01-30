#include <lib.h>
#include <x86.h>
#include <gcc.h>
#include <acpi.h>
#include <cpu.h>
#include <x86.h>
#include <threadlist.h>
#include <vmm.h>
#include <kmm.h>

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

// static const char* features[CPUID_BIT(CPUID_NFLAGS, 0)] = {
//     // CPUID(1): EDX
//     [CPUID_FPU]           = "fpu",
//     [CPUID_VME]           = "vme",
//     [CPUID_DE]            = "de",
//     [CPUID_PSE]           = "pse",
//     [CPUID_TSC]           = "tsc",
//     [CPUID_MSR]           = "msr",
//     [CPUID_PAE]           = "pae",
//     [CPUID_MCE]           = "mce",
//     [CPUID_CX8]           = "cx8",
//     [CPUID_APIC]          = "apic",
//     [CPUID_SEP]           = "sep",
//     [CPUID_MTRR]          = "mtrr",
//     [CPUID_PGE]           = "pge",
//     [CPUID_MCA]           = "mca",
//     [CPUID_CMOV]          = "cmov",
//     [CPUID_PAT]           = "pat",
//     [CPUID_PSE36]         = "pse36",
//     [CPUID_PN]            = "pn",
//     [CPUID_CLFLUSH]       = "clflush",
//     [CPUID_DS]            = "ds",
//     [CPUID_ACPI]          = "acpi",
//     [CPUID_MMX]           = "mmx",
//     [CPUID_FXSR]          = "fxsr",
//     [CPUID_SSE]           = "sse",
//     [CPUID_SSE2]          = "sse2",
//     [CPUID_SS]            = "ss",
//     [CPUID_HT]            = "ht",
//     [CPUID_TM]            = "tm",
//     [CPUID_IA64]          = "ia64",
//     [CPUID_PBE]           = "pbe",

//     // CPUID(1): ECX
//     [CPUID_SSE3]          = "sse3",
//     [CPUID_PCLMULQDQ]     = "pclmulqdq",
//     [CPUID_DTES64]        = "dtes64",
//     [CPUID_MONITOR]       = "monitor",
//     [CPUID_DSCPL]         = "ds_cpl",
//     [CPUID_VMX]           = "vmx",
//     [CPUID_SMX]           = "smx",
//     [CPUID_EST]           = "est",
//     [CPUID_TM2]           = "tm2",
//     [CPUID_SSSE3]         = "ssse3",
//     [CPUID_CID]           = "cid",
//     [CPUID_SDBG]          = "sdbg",
//     [CPUID_FMA]           = "fma",
//     [CPUID_CX16]          = "cx16",
//     [CPUID_XTPR]          = "xtpr",
//     [CPUID_PDCM]          = "pdcm",
//     [CPUID_PCID]          = "pcid",
//     [CPUID_DCA]           = "dca",
//     [CPUID_SSE41]         = "sse4.1",
//     [CPUID_SSE42]         = "sse4.2",
//     [CPUID_X2APIC]        = "x2apic",
//     [CPUID_MOVBE]         = "movbe",
//     [CPUID_POPCNT]        = "popcnt",
//     [CPUID_TSC_DEADLINE]  = "tsc-deadline",
//     [CPUID_AES]           = "aes",
//     [CPUID_XSAVE]         = "xsave",
//     [CPUID_OSXSAVE]       = "osxsave",
//     [CPUID_AVX]           = "avx",
//     [CPUID_F16C]          = "f16c",
//     [CPUID_RDRAND]        = "rdrand",
//     [CPUID_HYPERVISOR]    = "hypervisor",

//     // CPUID(0x80000001): EDX
//     [CPUID_SYSCALL]       = "syscall",
//     [CPUID_MP]            = "mp",
//     [CPUID_NX]            = "nx",
//     [CPUID_MMXEXT]        = "mmxext",
//     [CPUID_FXSR_OPT]      = "fxsr_opt",
//     [CPUID_PDPE1GB]       = "pdpe1gb",
//     [CPUID_RDTSCP]        = "rdtscp",
//     [CPUID_LM]            = "lm",
//     [CPUID_3DNOWEXT]      = "3dnowext",
//     [CPUID_3DNOW]         = "3dnow",

//     // CPUID(0x80000001): ECX
//     [CPUID_LAHF_LM]       = "lahf_lm",
//     [CPUID_CMP_LEGACY]    = "cmp_legacy",
//     [CPUID_SVM]           = "svm",
//     [CPUID_EXTAPIC]       = "extapic",
//     [CPUID_CR8LEGACY]     = "cr8legacy",
//     [CPUID_ABM]           = "abm",
//     [CPUID_SSE4A]         = "sse4a",
//     [CPUID_MISALIGNSSE]   = "misalignsse",
//     [CPUID_3DNOWPREFETCH] = "3dnowprefetch",
//     [CPUID_OSVW]          = "osvw",
//     [CPUID_IBS]           = "ibs",
//     [CPUID_XOP]           = "xop",
//     [CPUID_SKINIT]        = "skinit",
//     [CPUID_WDT]           = "wdt",
//     [CPUID_LWP]           = "lwp",
//     [CPUID_FMA4]          = "fma4",
//     [CPUID_TCE]           = "tce",
//     [CPUID_NODEID_MSR]    = "nodeid_msr",
//     [CPUID_TBM]           = "tbm",
//     [CPUID_TOPOEXT]       = "topoext",
//     [CPUID_PERFCTR_CORE]  = "perfctr_core",
//     [CPUID_PERFCTR_NB]    = "perfctr_nb",
// };

// static void
// print_feature(uint32_t* feature) {
//     int i, j;

//     for (i = 0; i < CPUID_NFLAGS; ++i) {
//         if (!feature[i])
//             continue;
//         print(" ");
//         for (j = 0; j < 32; ++j) {
//             const char* name = features[CPUID_BIT(i, j)];

//             if ((feature[i] & BIT(j)) && name)
//                 print(" %s", name);
//         }
//         print("\n");
//     }
// }

static bool
cpuid_has(uint32_t* feature, unsigned int bit) {
    return feature[bit / 32] & BIT(bit % 32);
}

void
cpuid_info(void) {
    uint32_t eax, brand[12], feature[CPUID_NFLAGS] = {0};

    cpuid(0x80000000, &eax, NULL, NULL, NULL);
    if (eax < 0x80000004)
        panic("CPU too old!");

    cpuid(0x80000002, &brand[0], &brand[1], &brand[2], &brand[3]);
    cpuid(0x80000003, &brand[4], &brand[5], &brand[6], &brand[7]);
    cpuid(0x80000004, &brand[8], &brand[9], &brand[10], &brand[11]);
    // print("CPU: %.48s\n", brand);

    cpuid(1, NULL, NULL,
          &feature[CPUID_1_ECX], &feature[CPUID_1_EDX]);
    cpuid(0x80000001, NULL, NULL,
          &feature[CPUID_80000001_ECX], &feature[CPUID_80000001_EDX]);
    // print_feature(feature);
    // Check feature bits.
    assert(cpuid_has(feature, CPUID_PSE));
    assert(cpuid_has(feature, CPUID_APIC));
    assert(cpuid_has(feature, CPUID_TSC));
}
