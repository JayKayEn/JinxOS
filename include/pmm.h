#ifndef _PMM_H_
#define _PMM_H_

#define PG_NBITS    12
#define PG_SIZE     (1 << PG_NBITS)  // 4096

struct page {
    struct page* next;
    uint32_t p_ref;
};

void init_pmm(void);

void* pg_alloc(void);
void pg_free(void* p);

#endif // _PMM_H_
