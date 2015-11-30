#ifndef _GDT_H_
#define _GDT_H_

void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran);

#endif // _GDT_H_
