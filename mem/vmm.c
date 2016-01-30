#include <lib.h>
#include <vmm.h>
#include <pmm.h>
#include <kmm.h>
#include <bitmap.h>
#include <x86.h>
#include <int.h>
#include <isr.h>
#include <mboot.h>
#include <errno.h>

int
page_insert(struct pde* pgdir, size_t pno, void* va, bool write, bool user) {
    assert(pgdir != NULL);

    struct pte* pg = pgdir_walk(pgdir, va, write, user, true);
    if (pg == NULL)
        return ENOMEM;

    assert(!pg->present);

    pg->present = true;
    pg->write = write;
    pg->user = user;
    pg->addr = pno;

    return 0;
}

struct pte*
pgdir_walk(struct pde* pd, void* va, bool write, bool user, bool alloc) {
    size_t pdx = PDX(va);
    size_t ptx = PTX(va);

    if (!pd[pdx].present && alloc) {
        size_t pno = pp_alloc();

        pd[pdx].present = true;
        pd[pdx].write = write;
        pd[pdx].user = user;
        pd[pdx].addr = pno;
    }

    struct pde* pt = PM2VA(pd[pdx].addr);

    return (struct pte*) (pt + ptx);

}

void
boot_map(struct pde* pd, void* va, size_t pa, size_t bytes,
         bool write, bool user) {

    for (size_t i = 0; i < bytes; i += PG_SIZE) {
        struct pte* pg = pgdir_walk(pd, va + i, write, user, true);

        pg->present = true;
        pg->write = write;
        pg->user = user;
        pg->addr = PA2PM(pa + i);
    }
}

// void
// page_map(void) {

// }

void*
mmio_map(size_t pa, size_t size) {
    static size_t base = MMIOBASE;

    size = ROUNDUP(size, PG_SIZE);

    if (base + size > MMIOLIM)
        panic("ERROR: this reservation would overflow the mmio region");

    boot_map(kpd, (void*) base, pa, size, true, false);
    base += size;

    return (void*) (base - size);
}

void
isr_pgfault(struct trapframe* tf) {
    (void) tf;

    uint32_t fault_addr = rcr2();
    print("fa: %x\n", fault_addr);
}

void
init_vmm(void) {
    extern char bstack[];

    // allocate a page directory for the kernel
    kpd = kpalloc();

    boot_map(kpd, (void*) KADDR, 0, npages * PG_SIZE, true, false);
    boot_map(kpd, (void*) (KADDR - BIT(15)), PADDR(bstack), BIT(15), true, false);

    lcr3(PADDR(kpd));

    uint32_t cr0 = rcr0();
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_MP;
    cr0 &= ~(CR0_TS | CR0_EM);
    lcr0(cr0);

    mbi = VADDR(mbi);

    isr_install_handler(ISR_PGFLT, isr_pgfault);
}

struct pde*
pgdir_create(void) {
    struct pde* pgdir = page_get();

    memset(pgdir, 0, PG_SIZE);

    for (size_t i = PDX(UTOP); i < TBL_SIZE; ++i)
        pgdir[i] = kpd[i];

    return pgdir;
}

void
pgdir_delete(struct pde* pgdir) {
    page_return(pgdir);
}
