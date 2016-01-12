#ifndef _LAPIC_H_
#define _LAPIC_H_

void init_lapic(void);

int cpunum(void);

// Acknowledge interrupt.
void lapic_eoi(void);

#define IO_RTC  0x70

void lapic_startap(uint8_t apicid, uint32_t addr);

void lapic_ipi(int vector);


#endif // _LAPIC_H_
