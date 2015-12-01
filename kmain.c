#include <lib.h>
#include <spinlock.h>
#include <multiboot.h>
// #include <mmu.h>
// #include <memlayout.h>
#include <console.h>
#include <x86.h>
#include <init.h>
#include <pmm.h>
#include <pit.h>
#include <kmm.h>
#include <cga.h>
#include <vmm.h>
#include <cga.h>

// demand() will restart if the expression evaluates to false
#define demand(exp)                                         \
    do {                                                    \
        if (!(exp))                                         \
            outb(0x92, 0x3);                                \
    } while(0)

// At boot there is a single 4MB mapping
__attribute__((aligned(BIT(12))))
size_t bpgd[TBL_SIZE] = {
    [0] = PG_P | PG_W | PG_PS,
};

static void jinx() {
    static const char* title[] = {
        "\t\t          _/  _/                               _/_/      _/_/_/\n",
        "\t\t         _/      _/_/_/    _/    _/         _/    _/  _/       \n",
        "\t\t        _/  _/  _/    _/    _/_/           _/    _/    _/_/    \n",
        "\t\t _/    _/  _/  _/    _/  _/    _/         _/    _/        _/   \n",
        "\t\t  _/_/    _/  _/    _/  _/    _/           _/_/    _/_/_/      \n",
    };

    print("\n");
    for (int i = 0, k = 0; i < 5; ++i, k = 0) {
        for (int j = 0; j < 6 - i; ++j, ++k)    // whitespace
            putc(title[i][k]);
        settextcolor(VGA_DGREEN);
        for (int j = 0; j < 32; ++j, ++k)       // "Jinx"
            putc(title[i][k]);
        settextcolor(VGA_DGREY);
        for (int j = 0; j < 27; ++j, ++k)       // "OS"
            putc(title[i][k]);
        putc('\n');
    }
    settextcolor(VGA_NORMAL);
}

void kmain(uint32_t eax, size_t ebx) {
    demand(*(uint16_t*) 0x7DFE == 0xAA55);  // Reboot if false
    demand(eax == 0x2BADB002);

    extern char _bss[], _ebss[];            // Init static data to zero
    memset(_bss, 0, _ebss - _bss);

    init_cga();
    init_serial();

    init_e820(ebx);
    init_gdt();
    init_idt();
    init_isr();
    init_irq();
    init_pit();
    init_kbd();

    init_kmm();
    init_pmm();

    sti();              // enable interrupts
    hlt();              // ensure interrupts are enabled

    lock_kernel();

    jinx();

    prompt();
}
