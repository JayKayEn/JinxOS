#include <lib.h>
#include <multiboot.h>
#include <cga.h>
#include <e820.h>

struct multiboot_info* mbi;
struct e820_map e820_map;

static const char* e820_map_types[] = {
    "available",
    "reserved",
    "reclaimable",
    "acpi nvs",
    "unusable",
};

void
print_e820_mmap(void) {
    print("\tE820: memory map [mem 0x%08x-0x%08x]\n", mbi->mmap_addr,
            mbi->mmap_addr + mbi->mmap_length - 1);

    for (size_t i = 0; i < e820_map.size; ++i) {
        struct e820_e e820 = e820_map.entries[i];
        print("\t\t[ %08p - %08p ] ", (size_t) e820.addr,
                (size_t) (e820.addr + e820.len - 1));
        switch (e820.type) {
            case E820_AVAILABLE:
                settextcolor(VGA_GREEN);
                break;
            case E820_RESERVED:
            case E820_ACPI_NVS:
            case E820_UNUSABLE:
                settextcolor(VGA_RED);
                break;
            case E820_RECLAIMABLE:
                settextcolor(VGA_CYAN);
                break;
            default:
                panic("unknown region type %u", e820.type);
                break;
        }
        print(e820_map_types[e820.type - 1]);
        settextcolor(VGA_NORMAL);
        print("\n");

    }
}

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
