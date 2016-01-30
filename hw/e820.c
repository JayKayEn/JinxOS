#include <lib.h>
#include <mboot.h>
#include <cga.h>
#include <e820.h>

struct multiboot_info* mbi;
struct e820_map e820_map;

void
init_e820(size_t mbi_addr) {
    mbi = (struct multiboot_info*) mbi_addr;
    assert(mbi->flags & MB_MEM_MAP);

    size_t mmap_addr = mbi->mmap_addr;
    size_t mmap_end = mbi->mmap_addr + mbi->mmap_length;
    assert(mmap_end - mmap_addr >= sizeof(struct multiboot_mmap_entry));

    size_t i;
    for (i = 0; mmap_addr < mmap_end; ++i) {
        struct multiboot_mmap_entry* e = (struct multiboot_mmap_entry*) mmap_addr;
        e820_map.entries[i] = e->e820;
        mmap_addr += e->size + 4;
    }
    assert(i < E820_MAX_SIZE);
    e820_map.size = i;
}
