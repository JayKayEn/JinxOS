#include <lib.h>
#include <int.h>
#include <pit.h>
#include <x86.h>

volatile uint32_t nticks = 0;

uint32_t ticks(void) {
    return nticks;
}

void iqr_handler_pit(struct regs* r) {
    (void) r;

    ++nticks;
}

void timer(uint32_t ticks) {
    uint32_t eticks = nticks + ticks;
    while(nticks != eticks);
}

void pit_rate(double hz) {
    uint16_t interval = 1193180 / hz;

    outb(0x43, 0x36);
    outb(0x40, interval & 0xFF);
    outb(0x40, interval >> 8);
}

void init_pit(void) {
    pit_rate(18.22222222);
    irq_install_handler(IRQ_TIMER, iqr_handler_pit);
}
