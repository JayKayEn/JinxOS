#ifndef _KMM_H_
#define _KMM_H_

#include <lib.h>
#include <vmm.h>

#include <mm.h>

#define FRMEM_MIN ((void*)(KADDR + 0x10000))
#define FRMEM_MAX ((void*)(KADDR + 0x9F000))

// void init_kmm(void);

void* kalign(size_t nbytes);

#endif // _KMM_H_
