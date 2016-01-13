#ifndef _INIT_H_
#define _INIT_H_

extern void init_cga(void);
extern void init_serial(void);
extern void init_e820(size_t);
extern void init_gdt(void);
extern void init_idt(void);
extern void init_isr(void);
extern void init_irq(void);
extern void init_pit(void);
extern void init_kbd(void);
extern void init_mem(void);
extern void init_kmm(void);
extern void init_mm(void);
extern void init_pmm(void);
extern void init_vmm(void);

extern void init_wchan(void);
extern void init_thread(void);
extern void init_cpu(void);
extern void init_proc(void);

extern void init_smp(void);
extern void init_lapic(void);
extern void init_acpi(void);

extern void init_speaker(void);

extern void init_rand(void);

#endif // _INIT_H_
