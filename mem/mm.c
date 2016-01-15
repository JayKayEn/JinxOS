#include <lib.h>
#include <memlib.h>
#include <pmm.h>
#include <mm.h>
#include <spinlock.h>

struct block {
    size_t sizeAndTags;
    struct block* next;
    struct block* prev;
};

#define ADD(p,x)            ((void*)((char*)(p) + (x)))
#define SUB(p,x)            ((void*)((char*)(p) - (x)))
#define FREE_LIST_HEAD      (*((struct block**)mem_heap_lo()))
#define WORD_SIZE           sizeof(void*)
#define MIN_BLOCK_SIZE      (sizeof(struct block) + WORD_SIZE)
#define ALIGNMENT           4
#define BLOCK_USED          1
#define PREV_BLOCK_USED     2
#define SIZE(x)             ((x) & ~(ALIGNMENT - 1))
#define BLOCK_IS_USED(x)    (((x)->sizeAndTags) & BLOCK_USED)
#define PREV_BLOCK_IS_USED(x) (((x)->sizeAndTags) & PREV_BLOCK_USED)
#define NEXT_BLOCK_SIZE(x)  (SIZE(((struct block*) ADD((x), SIZE((x)->sizeAndTags)))->sizeAndTags))

// CUSTOM HELPER FUNCTIONS
static size_t valid_size(size_t size);
static void free_block(struct block* block, size_t block_size, size_t keepSize);
static void copy_payload(struct block* src, struct block* dst);

// DIAGNOSTICS FUNCTIONS
// static void mm_printFreeList(void);
// static void mm_printHeap(void);

/* Initialize the allocator. */
void init_mm() {
    size_t init_size = 32 * PG_SIZE;
    size_t total_size;
    struct block* first_free_block;

    mem_sbrk(init_size);
    first_free_block = (struct block*) ADD(mem_heap_lo(), WORD_SIZE);
    total_size = init_size - (2 * WORD_SIZE);

    first_free_block->sizeAndTags = total_size | PREV_BLOCK_USED;
    first_free_block->next = NULL;
    first_free_block->prev = NULL;

    *((size_t*) ADD(first_free_block, total_size - WORD_SIZE)) = first_free_block->sizeAndTags;
    *((size_t*) SUB(mem_heap_hi(), WORD_SIZE - 1)) = BLOCK_USED;

    FREE_LIST_HEAD = first_free_block;
}

/* Find a free block of the requested size in the free list.  Returns
   NULL if no free block is large enough. */
static void* find_free_block(size_t size) {
    struct block* free_block;

    free_block = FREE_LIST_HEAD;
    while (free_block != NULL) {
        if (SIZE(free_block->sizeAndTags) >= size)
            return free_block;
        else
            free_block = free_block->next;
    }
    return NULL;
}

/* Insert free_block at the head of the list.  (LIFO) */
static void insert_free_block(struct block* free_block) {
    struct block* oldHead = FREE_LIST_HEAD;

    free_block->next = oldHead;
    if (oldHead != NULL)
        oldHead->prev = free_block;
    FREE_LIST_HEAD = free_block;
}

/* Remove a free block from the free list. */
static void remove_free_block(struct block* free_block) {
    struct block* next_free_block = free_block->next;
    struct block* prev_free_block = free_block->prev;

    if (next_free_block != NULL)
        next_free_block->prev = prev_free_block;

    if (free_block == FREE_LIST_HEAD)
        FREE_LIST_HEAD = next_free_block;
    else
        prev_free_block->next = next_free_block;
}

/* Coalesce 'block' with any preceeding or following free blocks. */
static void coalesce_free_block(struct block* block) {
    size_t old_size = SIZE(block->sizeAndTags);
    size_t new_size = old_size;
    struct block* block_cursor;
    struct block* new_block;
    struct block* free_block;

    block_cursor = block;
    while (!PREV_BLOCK_IS_USED(block_cursor)) {
        size_t size = SIZE(*((size_t*) SUB(block_cursor, WORD_SIZE)));
        free_block = (struct block*) SUB(block_cursor, size);
        remove_free_block(free_block);
        new_size += size;
        block_cursor = free_block;
    }

    new_block = block_cursor;

    block_cursor = (struct block*) ADD(block, old_size);
    while (!BLOCK_IS_USED(block_cursor)) {
        size_t size = SIZE(block_cursor->sizeAndTags);
        remove_free_block(block_cursor);
        new_size += size;
        block_cursor = (struct block*) ADD(block_cursor, size);
    }

    if (new_size != old_size) {
        remove_free_block(block);
        new_block->sizeAndTags = new_size | PREV_BLOCK_USED;
        *(size_t*) SUB(block_cursor, WORD_SIZE) = new_size | PREV_BLOCK_USED;
        insert_free_block(new_block);
    }
}

/* Get more heap space of size at least size. */
static void increase_heap(size_t size) {
    size_t page_size = mem_pagesize();
    size_t npages = (size + page_size - 1) / page_size;
    size_t total_size = npages * page_size;
    struct block* new_block;

    new_block = (struct block*) SUB(mem_sbrk(total_size), WORD_SIZE);

    new_block->sizeAndTags = total_size | PREV_BLOCK_IS_USED(new_block);
    ((struct block*) ADD(new_block, total_size - WORD_SIZE))->sizeAndTags = total_size | PREV_BLOCK_IS_USED(new_block);
    *((size_t*) ADD(new_block, total_size)) = BLOCK_USED;

    insert_free_block(new_block);
    coalesce_free_block(new_block);
}

// Accepts a size and returns the nearest aligned size, rounded up, that is at
// least MIN_BLOCK_SIZE
static size_t valid_size(size_t size) {
    size += WORD_SIZE;
    size_t valid = size <= MIN_BLOCK_SIZE
                   ? MIN_BLOCK_SIZE
                   : ALIGNMENT * ((size + ALIGNMENT - 1) / ALIGNMENT);
    return valid;
}

// Takes a struct block with size block_size and frees memory from the end in
// excess of keepSize.
static void free_block(struct block* block, size_t block_size, size_t keepSize) {
    struct block* block_surplus = (struct block*) ADD(block, keepSize);

    // When called by kfree, block_surplus won't automatically be preceded by a BLOCK_IS_used block
    if (keepSize > 0)
        // block will always precede and be in a BLOCK_IS_used state;
        block_surplus->sizeAndTags = (block_size - keepSize) | PREV_BLOCK_USED;
    else
        // called by kfree and keepSize = 0
        // block is gone so must check the if preceding block is BLOCK_IS_used
        block_surplus->sizeAndTags = block_size | PREV_BLOCK_IS_USED(block);

    // Set boundary footer
    *(size_t*) ADD(block, block_size - WORD_SIZE) = block_surplus->sizeAndTags;

    // Unset the succeeding block's PREV_BLOCK_IS_USED tag to reflect the change
    struct block* next_block = (struct block*) ADD(block, block_size);
    next_block->sizeAndTags |= PREV_BLOCK_USED;
    next_block->sizeAndTags ^= PREV_BLOCK_USED;

    insert_free_block(block_surplus);
    coalesce_free_block(block_surplus);
}

// Copies the payload over from src to dst
static void copy_payload(struct block* src, struct block* dst) {
    size_t payload_size;
    uint32_t* src_payload;
    uint32_t* dst_payload;

    payload_size = SIZE(src->sizeAndTags) - WORD_SIZE;

    // Pointers to payload using %llu so pointer arithmetic will scale to
    // WORD_SIZE increments
    src_payload = (uint32_t*) ADD(src, WORD_SIZE);
    dst_payload = (uint32_t*) ADD(dst, WORD_SIZE);

    // sizes are all aligned so can just divide by WORD_SIZE
    for (size_t i = 0; i < payload_size / WORD_SIZE; i++)
        dst_payload[i] = src_payload[i];
}

// DIAGNOSTICS FUNCTIONS --------------------------------------------

// static void
// mm_printHeap(void) {
//     size_t sumBlockSize;
//     struct block* block;

//     // When printing in krealloc, this value can be incorrect
//     (FREE_LIST_HEAD)->prev = 0;

//     sumBlockSize = 0;
//     print("\n---Inspecting heap---\n\n");
//     print("Heap Size: %ld \nPage Size: %ld \n\n", mem_heapsize(), mem_pagesize());
//     block = (struct block*) ADD(mem_heap_lo(), WORD_SIZE);
//     while (block != NULL && SIZE(block->sizeAndTags) != 0 && (void*)block < (void*)mem_heap_hi()) {
//         print("Block Address: %p \nHeader: 0x%x  0x%x  0x%x \n",
//                 (void*)block, SIZE(block->sizeAndTags),
//                 PREV_BLOCK_IS_USED(block), BLOCK_IS_USED(block));
//         sumBlockSize += SIZE(block->sizeAndTags);
//         if ((block->sizeAndTags & BLOCK_USED) == 0)
//             print("Previous Block: %p \nNext Block: %p \n",
//                 (void*)block->prev, (void*)block->next);
//         print("\n");
//         block = (struct block*) ADD(block, SIZE(block->sizeAndTags));
//     }
//     print("Block Address: %p \nHeader: 0x%x  0x%x  0x%x \n\n",
//             (void*)block, SIZE(block->sizeAndTags),
//             PREV_BLOCK_IS_USED(block), BLOCK_IS_USED(block));
//     print("Total Block Size: %ld\n\n", sumBlockSize + 2 * WORD_SIZE);
//     print("---End inspection---\n\n");
// }

// static void
// mm_printFreeList(void) {
//     struct block* block;

//     // When printing in krealloc, this value can be incorrect
//     (FREE_LIST_HEAD)->prev = 0;

//     print("\n---Inspecting free list---\n\n");
//     block = FREE_LIST_HEAD;
//     while (block != NULL && SIZE(block->sizeAndTags) != 0 && (void*)block < (void*)mem_heap_hi()) {
//         print("Block Address: %p \nHeader: 0x%x  0x%x  0x%x  \nPrevious Block: %p \nNext Block: %p \n\n",
//                 (void*)block, SIZE(block->sizeAndTags),
//                 PREV_BLOCK_IS_USED(block), BLOCK_IS_USED(block),
//                 (void*)block->prev, (void*)block->next);
//         block = block->next;
//     }
//     print("---End inspection---\n\n");
// }


// TOP-LEVEL ALLOCATOR INTERFACE ------------------------------------


void* kmalloc(size_t size) {
    if (size == 0)
        return NULL;

    spinlock_acquire(&mem_lock);

    // Ensure a valid and aligned size
    size_t alloc_size = valid_size(size);

    // Search free list for a suitable block.
    struct block* block = find_free_block(alloc_size);
    if (block == NULL) {
        increase_heap(alloc_size);
        block = find_free_block(alloc_size);
    }
    remove_free_block(block);

    size_t block_size = SIZE(block->sizeAndTags);

    // Block may be larger than necessary so first check if it is possible to
    // chop off the end of the block and put in back in the free list.
    if (block_size - alloc_size >= MIN_BLOCK_SIZE) {
        block->sizeAndTags = alloc_size | BLOCK_USED | PREV_BLOCK_IS_USED(block);
        free_block(block, block_size, alloc_size);
    } else {
        block->sizeAndTags |= BLOCK_USED | PREV_BLOCK_IS_USED(block);
        *(size_t*) ADD(block, block_size) |= PREV_BLOCK_USED;
    }

    spinlock_release(&mem_lock);

    // Return a pointer to the start of the payload
    return ADD(block, WORD_SIZE);
}

void kfree(void* ptr) {
    if (ptr == NULL)
        return;

    spinlock_acquire(&mem_lock);

    // If the block is in a BLOCK_IS_USED state, treat it all as surplus and free
    struct block* block = (struct block*) SUB(ptr, WORD_SIZE);
    if (BLOCK_IS_USED(block))
        free_block(block, SIZE(block->sizeAndTags), 0);

    spinlock_release(&mem_lock);
}

void* krealloc(void* ptr, size_t size) {
    // Take care of cases that don't necessarily require this function
    if (ptr == NULL)
        return kmalloc(size);

    if (size == 0) {
        kfree(ptr);
        return NULL;
    }

    spinlock_acquire(&mem_lock);

    // Get header and size of the block.
    struct block* block = (struct block*) SUB(ptr, WORD_SIZE);
    block->sizeAndTags |= BLOCK_USED;
    size_t block_size = SIZE(block->sizeAndTags);

    struct block* next_block = (struct block*) ADD(block, block_size);
    // Get the preceding block by reading its boundary footer to get the size
    // and then subtracting the size from block
    struct block* prev_block = NULL;
    if (!PREV_BLOCK_IS_USED(block))
        prev_block = (struct block*) SUB(block, SIZE(*(size_t*) SUB(block, WORD_SIZE)));

    // Ensure a valid and aligned size.
    size_t alloc_size = valid_size(size);

    // For a reqeusted size smaller than the current size, attempt to free
    // space at the end of the block. If the requested size is larger and the
    // current block is at the end of the heap, extend the heap to the
    // necessary size.
    if (alloc_size <= block_size) {
        // Free excess space if possible
        if (block_size - alloc_size >= MIN_BLOCK_SIZE) {
            block->sizeAndTags = alloc_size | BLOCK_USED | PREV_BLOCK_IS_USED(block);
            free_block(block, block_size, alloc_size);
        }

        spinlock_release(&mem_lock);

        return ADD(block, WORD_SIZE);
    }
    // If the size of the next block is 0, block is the last block on the heap
    else if (NEXT_BLOCK_SIZE(block) == 0) {
        // extend the heap
        mem_sbrk((size_t)(alloc_size - block_size));
        block->sizeAndTags = alloc_size | BLOCK_USED | PREV_BLOCK_IS_USED(block);
        // Need to create a new heap footer
        *((size_t*) SUB(mem_heap_hi(), WORD_SIZE - 1)) = PREV_BLOCK_USED | BLOCK_USED;

        spinlock_release(&mem_lock);

        return ADD(block, WORD_SIZE);
    }
    // If the block following the current block is free, attempt to combine it
    // with the current block and, if possible, free any excess space. If the
    // combination is not enough memory but the following block is at the end
    // of the heap, extend the heap.
    if (!BLOCK_IS_USED(next_block)) {
        size = block_size + SIZE(next_block->sizeAndTags);
        if (size >= alloc_size) {
            remove_free_block(next_block);
            block->sizeAndTags = BLOCK_USED | PREV_BLOCK_IS_USED(block);
            // Free excess space if possible
            if (size - alloc_size >= MIN_BLOCK_SIZE) {
                block->sizeAndTags |= alloc_size;
                free_block(block, size, alloc_size);
            } else {
                block->sizeAndTags |= size;
                *(size_t*) ADD(block, size) |= PREV_BLOCK_USED;
            }

            spinlock_release(&mem_lock);

            return ADD(block, WORD_SIZE);
        }
        // If the size of the next block is 0, next_block is the last block on the heap
        else if (NEXT_BLOCK_SIZE(next_block) == 0) {
            remove_free_block(next_block);
            // extend the heap
            mem_sbrk((size_t)(alloc_size - size));
            block->sizeAndTags = alloc_size | BLOCK_USED | PREV_BLOCK_IS_USED(block);
            // Need to create a new heap footer
            *((size_t*) SUB(mem_heap_hi(), WORD_SIZE - 1)) = PREV_BLOCK_USED | BLOCK_USED;

            spinlock_release(&mem_lock);

            return ADD(block, WORD_SIZE);
        }
    }
    // If the blocks preceding and following the current block are free,
    // attempt to use all three to satisfy the new size requirement, and, if
    // possible, free any excess space.
    if (!PREV_BLOCK_IS_USED(block) && !BLOCK_IS_USED(next_block)) {
        size = block_size + SIZE(next_block->sizeAndTags) + SIZE(prev_block->sizeAndTags);
        if (size >= alloc_size) {
            remove_free_block(next_block);
            remove_free_block(prev_block);
            // Move data to start at the preceding block's payload
            copy_payload(block, prev_block);
            prev_block->sizeAndTags = BLOCK_USED | PREV_BLOCK_IS_USED(prev_block);
            // Free excess space if possible
            if (size - alloc_size >= MIN_BLOCK_SIZE) {
                prev_block->sizeAndTags |= alloc_size;
                free_block(prev_block, size, alloc_size);
            } else {
                prev_block->sizeAndTags |= size;
                *(size_t*) ADD(prev_block, size) |= PREV_BLOCK_USED;
            }

            spinlock_release(&mem_lock);

            return ADD(prev_block, WORD_SIZE);
        }
    }
    // If the block preceding the current block is free, attempt to use both to
    // satisfy the new size requirement.
    if (!PREV_BLOCK_IS_USED(block)) {
        size = block_size + SIZE(prev_block->sizeAndTags);
        if (size >= alloc_size) {
            remove_free_block(prev_block);
            copy_payload(block, prev_block);
            prev_block->sizeAndTags = BLOCK_USED | PREV_BLOCK_IS_USED(prev_block);
            // Free excess space if possible
            if (size - alloc_size >= MIN_BLOCK_SIZE) {
                prev_block->sizeAndTags |= alloc_size;
                free_block(prev_block, size, alloc_size);
            } else {
                prev_block->sizeAndTags |= size;
                *(size_t*) ADD(prev_block, size) |= PREV_BLOCK_USED;
            }

            spinlock_release(&mem_lock);

            return ADD(prev_block, WORD_SIZE);
        }
    }
    // If no previous method can satisfy the reallocation request, allocate a
    // new block and copy the block's data to the new payload and free the old
    // block.
    struct block* new_block = (struct block*)
                              SUB(kmalloc(alloc_size - WORD_SIZE), WORD_SIZE);
    copy_payload(block, new_block);
    kfree(ADD(block, WORD_SIZE));

    spinlock_release(&mem_lock);

    return ADD(new_block, WORD_SIZE);

}
