#include <x86.h>
#include <speaker.h>
#include <pit.h>

static void
sound(uint32_t freq) {
    uint32_t div = 1193180 / freq;
    outb(0x43, 0xb6);
    outb(0x42, (uint8_t) (div) );
    outb(0x42, (uint8_t) (div >> 8));

    outb(0x61, inb(0x61) | 3);
}

static void
nosound() {
    outb(0x61, inb(0x61) & 0xFC);
}

static void
speaker_beep(uint32_t freq, uint32_t ticks) {
    sound(freq);
    pit_wait(ticks);
    nosound();
}

void
speaker_warning(void) {

}

void
speaker_error(void) {
    speaker_beep(300, 4);
    pit_wait(1);
    speaker_beep(300, 7);
}

void
init_speaker(void) {
    speaker_beep(800, 3);
    speaker_beep(1000, 3);
    speaker_beep(900, 8);
}
