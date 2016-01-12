#ifndef _ISR_H_
#define _ISR_H_

#include <int.h>

void isr_install_handler(int isr, void (*handler)(struct regs* r));
void isr_uninstall_handler(int isr);

#endif // _ISR_H_
