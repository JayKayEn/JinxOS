#include <cga.h>
#include <x86.h>
#include <lib.h>
#include <vmm.h>

#define CGA_BASE    0x3D4
#define CGA_BUF     0xB8000

#define CRT_ROWS    25
#define CRT_COLS    80
#define CRT_SIZE    (CRT_ROWS * CRT_COLS)

uint16_t attrib = VGA_NORMAL;

static size_t addr_6845;


/* Scrolls the screen */
void scroll(void) {
    memcpy(crt.buf, crt.buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));

    for (int i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; ++i)
        crt.buf[i] = attrib | ' ';

    crt.pos -= CRT_COLS;
}

// Updates the positoin of the blinking cursor
void update_cursor(void) {
    outb(addr_6845, 14);
    outb(addr_6845 + 1, crt.pos >> 8);
    outb(addr_6845, 15);
    outb(addr_6845 + 1, crt.pos);
}

// Clears the console
void cls() {
    unsigned blank = attrib | ' ';

    for(int i = 0; i < CRT_SIZE; ++i)
        memsetw(crt.buf, blank, CRT_SIZE);

    crt.pos = 0;
    update_cursor();
}

/* Puts a single character on the screen */
void putc_cga(const char c) {
    switch (c) {
        case '\b':
            if (crt.pos > 0) {
                crt.pos--;
                crt.buf[crt.pos] = attrib | ' ';
            }
            break;
        case '\n':
            crt.pos += CRT_COLS;
        // fallthru
        case '\r':
            crt.pos -= (crt.pos % CRT_COLS);
            break;
        case '\t':
            crt.buf[crt.pos++] = attrib | ' ';
            crt.buf[crt.pos++] = attrib | ' ';
            crt.buf[crt.pos++] = attrib | ' ';
            crt.buf[crt.pos++] = attrib | ' ';
            break;
        default:
            if (c >= 0x20 && c <= 0x7E)
                crt.buf[crt.pos++] = attrib | c;
            break;
    }

    if (crt.pos >= CRT_SIZE)
        scroll();

    update_cursor();
}

/* Sets the forecolor and backcolor that we will use */
void settextcolor(uint16_t color) {
    attrib = color;
}

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_cga(void) {
    crt.buf = (uint16_t*) (KADDR + CGA_BUF);
    addr_6845 = CGA_BASE;

    // get current cursor location
    outb(addr_6845, 14);
    crt.pos = inb(addr_6845 + 1) << 8;
    outb(addr_6845, 15);
    crt.pos |= inb(addr_6845 + 1);

    cls();
}
