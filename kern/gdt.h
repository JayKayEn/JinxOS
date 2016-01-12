#ifndef _GDT_H_
#define _GDT_H_

void gdt_set_gate(uint8_t num, uint32_t base, uint32_t limit, uint8_t access,
                  uint8_t gran);

#endif // _GDT_H_
