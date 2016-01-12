#include <lib.h>
#include <vmm.h>
#include <pmm.h>
#include <kmm.h>
#include <bitmap.h>
#include <x86.h>
#include <int.h>
#include <isr.h>
#include <mboot.h>

extern struct kbitmap* physmap;

struct pte*
pd_map(struct pde* pd, void* va, bool write, bool user) {
    size_t pdx = PDX(va);
    size_t ptx = PTX(va);

    if (!pd[pdx].present) {
        size_t pno = pp_alloc();
        pd[pdx].addr = pno;
        pd[pdx].present = true;
        pd[pdx].write = write;
        pd[pdx].user = user;
    }

    struct pde* pt = PM2VA(pd[pdx].addr);

    return (struct pte*) (pt + ptx);

}

void
boot_map(struct pde* pd, void* va, size_t pa, size_t bytes,
         bool write, bool user) {

    for (size_t i = 0; i < bytes; i += PG_SIZE) {
        struct pte* pg = pd_map(pd, va + i, write, user);
        pg->addr = PA2PM(pa + i);
        pg->present = true;
        pg->write = write;
        pg->user = user;
    }
}

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
isr_pgfault(struct regs* r) {
    (void) r;

    uint32_t fault_addr = rcr2();
    print("fa: %x\n", fault_addr);
}

void
init_vmm(void) {
    extern char bstack[];

    // allocate a page directory for the kernel
    kpd = kalign(PG_SIZE);

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
