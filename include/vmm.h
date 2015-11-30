#ifndef _VMM_H_
#define _VMM_H_

#include <lib.h>
#include <pmm.h>

#define TBL_NBITS   10
#define TBL_SIZE    (1 << TBL_NBITS)

size_t pd[TBL_SIZE];
size_t pt[TBL_SIZE];

#define PG_IDX(a)   (((size_t) a & 0xFFF)

#define PT_SHIFT   (PG_NBITS)  // 12
#define PT_IDX(a)  (((size_t) a >> PT_SHIFT) & 0x3FF)

#define PD_SHIFT   (TBL_NBITS + PG_NBITS)  // 22
#define PD_IDX(a)  (((size_t) a >> PD_SHIFT) & 0x3FF)

#define PG_P   BIT(0)   // Present
#define PG_W   BIT(1)   // Writeable
#define PG_U   BIT(2)   // User
#define PG_A   BIT(5)   // Accessed
#define PG_D   BIT(6)   // Dirty
#define PG_PS  BIT(7)   // Page Size

#define CR0_PE   BIT(0)   // Protection Enable
#define CR0_MP   BIT(1)   // Monitor coProcessor
#define CR0_EM   BIT(2)   // Emulation
#define CR0_TS   BIT(3)   // Task Switched
#define CR0_ET   BIT(4)   // Extension Type
#define CR0_NE   BIT(5)   // Numeric Errror
#define CR0_WP   BIT(16)  // Write Protect
#define CR0_AM   BIT(18)  // Alignment Mask
#define CR0_NW   BIT(29)  // Not Writethrough
#define CR0_CD   BIT(30)  // Cache Disable
#define CR0_PG   BIT(31)  // Paging

#define CR4_VME  BIT(0)   // V86 Mode Extensions
#define CR4_PVI  BIT(1)   // Protected-Mode Virtual Interrupts
#define CR4_TSD  BIT(2)   // Time Stamp Disable
#define CR4_DE   BIT(3)   // Debugging Extensions
#define CR4_PSE  BIT(4)   // Page Size Extensions
#define CR4_MCE  BIT(6)   // Machine Check Enable
#define CR4_PCE  BIT(8)   // Performance counter enable

#endif // _VMM_H_
