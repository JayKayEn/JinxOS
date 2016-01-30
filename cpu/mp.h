#ifndef _MP_H_
#define _MP_H_

uint8_t percpu_kstacks[NCPU][KSTKSIZE] PAGE_ALIGNED;

void mp_lgdt(void);
void mp_ltr(void);
void mp_lidt(void);

#endif // _MP_H_
