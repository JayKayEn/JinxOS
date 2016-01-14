#ifndef _GCC_H_
#define _GCC_H_

#include <pmm.h>

#ifdef __GNUC__

#define PACKED __attribute__((packed))
#define PAGE_ALIGNED __attribute__((aligned(PG_SIZE)))
#define THISCALL __attribute__((thiscall))

#else

#define PACKED
#define PAGE_ALIGNED
#define THISCALL

#endif // __GNUC__

#endif // _GCC_H_
