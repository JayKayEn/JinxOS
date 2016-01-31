#include <x86.h>
#include <elf.h>
#include <mboot.h>

#define SECTSIZE	512
#define ELFHDR		0x10000

void readsect(void*, uint32_t);
void readseg(uint32_t, uint32_t, uint32_t);

struct multiboot_info* mbi;

void
bmain(void) {
    struct elf* elf = (struct elf*) ELFHDR;

    readseg((uint32_t) elf, SECTSIZE * 8, 0);

    if (elf->magic != ELF_MAGIC)
        goto bad;

    struct prog* p = (struct prog*)((uint8_t*) elf + elf->phoff);
    struct prog* ep = p + elf->phnum;
    for (; p < ep; p++)
        readseg(p->paddr, p->memsz, p->offset);

    mbi->flags = MB_MEM_MAP;
    mbi->mmap_length = (uint32_t) mbi & (4096 - 1);
    mbi->mmap_addr = (uint32_t) mbi - mbi->mmap_length;

    asm ("movl %0, %%eax;"
         "movl %1, %%ebx;"
         : : "r"(MB_EAX_MAGIC), "r"(mbi)
         : "eax", "ebx");

    ((void (*)(void)) (elf->entry))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);
    while (1);
}

void
readseg(uint32_t paddr, uint32_t memsz, uint32_t offset) {

    uint32_t end = paddr + memsz;

    paddr &= ~(SECTSIZE - 1);
    offset = (offset / SECTSIZE) + 1;

    for (; paddr < end; paddr += SECTSIZE, ++offset)
        readsect((uint8_t*) paddr, offset);
}

void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40);
}

void
readsect(void* dst, uint32_t offset) {
    waitdisk();

    outb(0x1F2, 1);
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();

    insl(0x1F0, dst, SECTSIZE / 4);
}

