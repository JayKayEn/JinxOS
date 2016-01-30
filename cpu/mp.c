#include <lib.h>
#include <cpu.h>
#include <mp.h>
#include <gdt.h>
#include <x86.h>

void
mp_main(void) {
    mp_lgdt();
    mp_ltr();
    mp_lidt();

}

void
mp_lgdt(void) {
    lgdt(&gdt_addr);

    asm volatile("movw %%ax,%%gs" : : "a" (GD_UD | DPL_USER));
    asm volatile("movw %%ax,%%fs" : : "a" (GD_UD | DPL_USER));

    asm volatile("movw %%ax,%%es" : : "a" (GD_KD | DPL_KERN));
    asm volatile("movw %%ax,%%ds" : : "a" (GD_KD | DPL_KERN));
    asm volatile("movw %%ax,%%ss" : : "a" (GD_KD | DPL_KERN));

    asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));

    lldt(0);
}

// Initialize and load the per-CPU TSS and IDT
void
mp_ltr(void) {
    // LAB 4: Your code here:

    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    int i = cpunum();
    // thiscpu->ts.ts_esp0 = (uint32_t) KSTACKTOP;
    thiscpu->ts.ts_esp0 = (uint32_t) percpu_kstacks[i];
    thiscpu->ts.ts_ss0 = GD_KD;

    // Initialize the TSS slot of the gdt.

    gdt_set_gate16(GDT_TSS + i, (uint32_t) &thiscpu->ts, sizeof(struct taskstate) - 1, DPL_KERN, STS_T32A);
    gdt[GDT_TSS + i].app = 0;   // system not application

    // Load the TSS selector (like other segment selectors, the
    // bottom three bits are special; we leave them 0)
    ltr((GDT_TSS + i) << 3);

}

void
mp_lidt(void) {
    extern struct idt_ptr idtp;
    lidt(&idtp);
}
