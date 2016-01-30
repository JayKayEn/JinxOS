#ifndef _VMM_H_
#define _VMM_H_

#ifndef __ASSEMBLER__

#include <lib.h>
#include <pmm.h>

#endif // __ASSEMBLER__

#define KADDR       (0xC0000000)
#define KSTACKTOP   (KADDR)
#define KSTKSIZE    (8 * PG_SIZE)
#define KSTKGAP     (8 * PG_SIZE)
#define MMIOLIM     (KSTACKTOP - PT_SIZE)
#define MMIOBASE    (MMIOLIM - PT_SIZE)


#define ULIM        (MMIOBASE)

/*
 * User read-only mappings! Anything below here til UTOP are readonly to user.
 * They are global pages mapped in at env allocation time.
 */

// User read-only virtual page table (see 'uvpt' below)
#define UVPT        (ULIM - PT_SIZE)
// Read-only copies of the Page structures
#define UPAGES      (UVPT - PT_SIZE)
// Read-only copies of the global env structures
#define UENVS       (UPAGES - PT_SIZE)

/*
 * Top of user VM. User can manipulate VA from UTOP-1 and down!
 */

// Top of user-accessible VM
#define UTOP        (UENVS)

#define UXSTACKTOP  (UTOP)                // Top of one-page user exception stack
#define USTACKTOP   (UTOP - 2 * PG_SIZE)   // one-page stack guard

#define UMMIOBASE   0xB0000000
#define UMMIOAHCI   UMMIOBASE

#define UTEXT       (2 * PT_SIZE)
#define UTEMP       ((void*) PT_SIZE)
// #define PFTEMP      (UTEMP + PT_SIZE - PG_SIZE)
#define USTABDATA   (PT_SIZE >> 1)

 #ifndef __ASSEMBLER__

void init_vmm(void);
void* mmio_map(size_t pa, size_t size);

// VA | VPN (virtual page number) : VPO (virtual page offset)
// PA | PPN (physical page number) : PPO (physical page offset)

#define TBL_NBITS   10
#define TBL_SIZE    (1 << TBL_NBITS)

struct pte {
    uint32_t present    : 1;
    uint32_t write      : 1;
    uint32_t user       : 1;
    uint32_t zero2      : 2;
    uint32_t accessed   : 1;
    uint32_t dirty      : 1;
    uint32_t page_size  : 1;
    uint32_t zero4      : 4;
    uint32_t addr       : 20;
};

struct pde {
    uint32_t present    : 1;
    uint32_t write      : 1;
    uint32_t user       : 1;
    uint32_t zero2      : 2;
    uint32_t accessed   : 1;
    uint32_t dirty      : 1;
    uint32_t page_size  : 1;
    uint32_t zero4      : 4;
    uint32_t addr       : 20;
};

struct pde* kpd;

int page_insert(struct pde* pgdir, size_t pno, void* va, bool write, bool user);
struct pte* pgdir_walk(struct pde* pd, void* va, bool write, bool user, bool alloc);

struct pde* pgdir_create(void);
void pgdir_delete(struct pde* pgdir);

// #define PADDR(a)    (((size_t) a) - KADDR)

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
        panic(file, line, "PADDR called with invalid va %08x", va);
    return (size_t) va - KADDR;
}

// #define VADDR(a)    (((size_t) a) + KADDR)

#define VADDR(pa) _vaddr(__FILE__, __LINE__, (size_t) pa)

static inline void*
_vaddr(const char* file, int line, size_t pa) {
    if (PA2PM(pa) >= npages)
        panic(file, line, "VADDR called with invalid pa %08x", pa);
    return (void*)(pa + KADDR);
}

#define PGX(a)      (((size_t) a & 0xFFF)

#define PT_SHIFT    (PG_NBITS)
#define PTX(a)      (((size_t) (a) >> PT_SHIFT) & 0x3FF)

#define PD_SHIFT    (TBL_NBITS + PG_NBITS)
#define PDX(a)      (((size_t) (a) >> PD_SHIFT) & 0x3FF)

#endif // __ASSEMBLER__

#define PG_P     BIT(0)   // Present
#define PG_W     BIT(1)   // Writeable
#define PG_U     BIT(2)   // User
#define PG_A     BIT(5)   // Accessed
#define PG_D     BIT(6)   // Dirty
#define PG_PS    BIT(7)   // Page Size

#define CR0_PE   BIT(0)   // Protection Enable
#define CR0_MP   BIT(1)   // Monitor coProcessor
#define CR0_EM   BIT(2)   // Emulation
#define CR0_TS   BIT(3)   // Task Switched
#define CR0_ET   BIT(4)   // Extension Type
#define CR0_NE   BIT(5)   // Numeric Errror
#define CR0_WP   BIT(16)  // Write Protect
#define CR0_AM   BIT(18)  // Alignment Mask
#define CR0_NW   BIT(29)  // Not Writethrough
#define CR0_CD   BIT(30)  // Cache Disable
#define CR0_PG   BIT(31)  // Paging

#define CR4_VME  BIT(0)   // V86 Mode Extensions
#define CR4_PVI  BIT(1)   // Protected-Mode Virtual Interrupts
#define CR4_TSD  BIT(2)   // Time Stamp Disable
#define CR4_DE   BIT(3)   // Debugging Extensions
#define CR4_PSE  BIT(4)   // Page Size Extensions
#define CR4_MCE  BIT(6)   // Machine Check Enable
#define CR4_PCE  BIT(8)   // Performance counter enable

#endif // _VMM_H_
