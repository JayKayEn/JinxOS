#ifndef _PIT_H_
#define _PIT_H_

// void init_pit(void);

uint32_t pit_ticks(void);
void pit_wait(uint32_t ticks);
void pit_freq(double hz);

#endif // _PIT_H_
