#ifndef _PIDREG_H_
#define _PIDREG_H_

void pidreg_create(void);
void pidreg_destroy(void);

int pidreg_getpid(void);
void pidreg_returnpid(int pid);

bool pid_used(int pid);

#endif // _PIDREG_H_
