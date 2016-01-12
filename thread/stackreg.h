#ifndef _STACKREG_H_
#define _STACKREG_H_

#define THREAD_STACK_MAGIC 0xDEADFACE

void stackreg_create(void);
void stackreg_destroy(void);

void* stackreg_get(void);
void stackreg_return(void* stack_addr);

#endif // _STACKREG_H_
