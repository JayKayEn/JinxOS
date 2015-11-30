#include <stdlib.h>

#define HEAP_MAX_SIZE   ((1 << 20) << 5)
#define ALIGNMENT       (8)

// static void* heap;
// static void* heap_end;
// static void* heap_max;

void init_mem(void) {

}

void* malloc(size_t size) {
    (void) size;

    return NULL;
}

void* calloc(size_t size) {
    (void) size;

    return NULL;
}

void* realloc(void* ptr, size_t size) {
    (void) ptr; (void) size;
    return NULL;
}

void free(void* ptr) {
    (void) ptr;

    return;
}

// ==================================================================
// The brk and sbrk functions are historical curiosities left over from ear-
// lier days before the advent of virtual memory management.  The brk()
// function sets the break or lowest address of a process's data segment
// (uninitialized data) to addr (immediately above bss).  Data addressing is
// restricted between addr and the lowest stack pointer to the stack seg-
// ment.  Memory is allocated by brk in page size pieces; if addr is not
// evenly divisible by the system page size, it is increased to the next
// page boundary.
//
// The current value of the program break is reliably returned by
// ``sbrk(0)'' (see also end(3)).  The getrlimit(2) system call may be used
// to determine the maximum permissible size of the data segment; it will
// not be possible to set the break beyond the rlim_max value returned from
// a call to getrlimit, e.g.  ``qetext + rlp->rlim_max.'' (see end(3) for
// the definition of etext).
// ==================================================================


void* brk(const void *addr) {
    (void) addr;

    return NULL;
}

void* sbrk(int incr) {
    if (incr == 0)
        return NULL;
    return NULL;
}
