#ifndef _INIT_H_
#define _INIT_H_

extern void init_cga(void);
extern void init_serial(void);
extern void init_e820(size_t);
extern void init_gdt(void);
extern void init_idt(void);
extern void init_isr(void);
extern void init_irq(void);
extern void init_kbd(void);
extern void init_pit(void);

#endif // _INIT_H_
