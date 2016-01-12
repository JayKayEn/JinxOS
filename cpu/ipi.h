#ifndef _IPI_H_
#define _IPI_H_

#include <cpu.h>

#define IPI_PANIC           0   // System has called panic()
#define IPI_OFFLINE         1   // CPU has requested to go offline
#define IPI_UNIDLE          2   // Runnable threads are available
#define IPI_TLBSHOOTDOWN    3   // TBL needs invalidation

void ipi_send(struct cpu* target, int code);
void ipi_broadcast(int code);
// void ipi_tlbshootdown(struct cpu* target, const struct tlbshootdown* mapping);
void interprocessor_interrupt(void);

#endif // _IPI_H_
