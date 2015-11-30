#ifndef _PIT_H_
#define _PIT_H_

void init_pit(void);

uint32_t ticks(void);
void timer(uint32_t ticks);
void pit_rate(double hz);

#endif // _PIT_H_
