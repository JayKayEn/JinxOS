#ifndef _PMM_H_
#define _PMM_H_

#define PG_NBITS    12
#define PG_SIZE     (1 << PG_NBITS)  // 4 KB
#define PT_SIZE     (1 << (PG_NBITS + TBL_NBITS))  // 4 MB

#define PM2VA(pm)   ((void*) (((size_t) (pm) << PG_NBITS) + KADDR))
#define PM2PA(pm)   ((size_t) (pm) << PG_NBITS)
#define PA2PM(pa)   ((size_t) (pa) >> PG_NBITS)

// #define PM2PT(pm)   (ROUNDDOWN((pm) << PG_NBITS, 1 << PD_SHIFT) >> PD_SHIFT)
// #define PM2PG(pm)   ((ROUNDDOWN((pm) << PG_NBITS, 1 << PT_SHIFT) >> PT_SHIFT) % TBL_SIZE)
// #define VA2PM(va)   (((size_t) (va) - KADDR) >> PG_NBITS)

size_t npages;

void init_pmm(void);

size_t pp_alloc(void);
void pp_free(void* p);

void pa_alloc(size_t pa);

void* page_get(void);
void page_return(void* page);

#endif // _PMM_H_
