#include <x86.h>
#include <lib.h>
#include <int.h>
#include <console.h>

#define NO          0

#define SHIFT       BIT(0)
#define CTL         BIT(1)
#define ALT         BIT(2)

#define CAPSLOCK    BIT(3)
#define NUMLOCK     BIT(4)
#define SCROLLLOCK  BIT(5)

#define ESC         BIT(6)

#define KEY_HOME    0xE0
#define KEY_END     0xE1
#define KEY_UP      0xE2
#define KEY_DN      0xE3
#define KEY_LF      0xE4
#define KEY_RT      0xE5
#define KEY_PGUP    0xE6
#define KEY_PGDN    0xE7
#define KEY_INS     0xE8
#define KEY_DEL     0xE9

#define KBDIO       0x60    /* kbd I/O data port */

static uint8_t shiftcode[256] = {
    [0x1D] = CTL,
    [0x2A] = SHIFT,
    [0x36] = SHIFT,
    [0x38] = ALT,
    [0x9D] = CTL,
    [0xB8] = ALT
};

static uint8_t togglecode[256] = {
    [0x3A] = CAPSLOCK,
    [0x45] = NUMLOCK,
    [0x46] = SCROLLLOCK
};

static uint8_t normalmap[256] = {
    NO,   0x1B, '1',  '2',  '3',  '4',  '5',  '6',  // 0x00
    '7',  '8',  '9',  '0',  '-',  '=',  '\b', '\t',
    'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  // 0x10
    'o',  'p',  '[',  ']',  '\n', NO,   'a',  's',
    'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';',  // 0x20
    '\'', '`',  NO,   '\\', 'z',  'x',  'c',  'v',
    'b',  'n',  'm',  ',',  '.',  '/',  NO,   '*',  // 0x30
    NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
    NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
    '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
    '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50

    [0xC7] = KEY_HOME,      [0x9C] = '\n',
    [0xB5] = '/',           [0xC8] = KEY_UP,
    [0xC9] = KEY_PGUP,      [0xCB] = KEY_LF,
    [0xCD] = KEY_RT,        [0xCF] = KEY_END,
    [0xD0] = KEY_DN,        [0xD1] = KEY_PGDN,
    [0xD2] = KEY_INS,       [0xD3] = KEY_DEL
};

static uint8_t shiftmap[256] = {
    NO,   033,  '!',  '@',  '#',  '$',  '%',  '^',  // 0x00
    '&',  '*',  '(',  ')',  '_',  '+',  '\b', '\t',
    'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',  // 0x10
    'O',  'P',  '{',  '}',  '\n', NO,   'A',  'S',
    'D',  'F',  'G',  'H',  'J',  'K',  'L',  ':',  // 0x20
    '"',  '~',  NO,   '|',  'Z',  'X',  'C',  'V',
    'B',  'N',  'M',  '<',  '>',  '?',  NO,   '*',  // 0x30
    NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
    NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
    '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
    '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50

    [0xC7] = KEY_HOME,      [0x9C] = '\n',
    [0xB5] = '/',           [0xC8] = KEY_UP,
    [0xC9] = KEY_PGUP,      [0xCB] = KEY_LF,
    [0xCD] = KEY_RT,        [0xCF] = KEY_END,
    [0xD0] = KEY_DN,        [0xD1] = KEY_PGDN,
    [0xD2] = KEY_INS,       [0xD3] = KEY_DEL
};

#define C(x) (x - '@')

static uint8_t ctlmap[256] = {
    NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
    NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
    C('Q'),  C('W'),  C('E'),  C('R'),  C('T'),  C('Y'),  C('U'),  C('I'),
    C('O'),  C('P'),  NO,      NO,      '\r',    NO,      C('A'),  C('S'),
    C('D'),  C('F'),  C('G'),  C('H'),  C('J'),  C('K'),  C('L'),  NO,
    NO,      NO,      NO,      C('\\'), C('Z'),  C('X'),  C('C'),  C('V'),
    C('B'),  C('N'),  C('M'),  NO,      NO,      C('/'),  NO,      NO,

    [0x97] = KEY_HOME,
    [0xB5] = C('/'),        [0xC8] = KEY_UP,
    [0xC9] = KEY_PGUP,      [0xCB] = KEY_LF,
    [0xCD] = KEY_RT,        [0xCF] = KEY_END,
    [0xD0] = KEY_DN,        [0xD1] = KEY_PGDN,
    [0xD2] = KEY_INS,       [0xD3] = KEY_DEL
};

static uint8_t* charcode[4] = {
    normalmap,
    shiftmap,
    ctlmap,
    ctlmap
};

/* Handles the keyboard interrupt */
void
irq_handler_kdb(struct regs* r) {
    (void) r;

    static uint32_t shift;

    uint8_t data = inb(KBDIO);

    if (data == 0xE0) {
        shift |= ESC;
        return;
    } else if (data & 0x80) {                           // Key-up
        // Reboot = Shift + Ctrl + Fn + Del
        if (shift == 0x46 && data == 0xD3)
            outb(0x64, 0xFE);
        data = (shift & ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | ESC);
        return;
    } else if (shift & ESC) {
        data |= 0x80;
        shift &= ~ESC;
    }


    shift |= shiftcode[data];
    shift ^= togglecode[data];

    int c = charcode[shift & (CTL | SHIFT)][data];
    if (shift & CAPSLOCK) {
        if ('a' <= c && c <= 'z')
            c += 'A' - 'a';
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }

    extern struct console console;
    console.buf[console.wpos++] = c;
    if (console.wpos == CONSBUFSIZE)
        console.wpos = 0;
}

void
init_kbd(void) {
    irq_install_handler(IRQ_KBD, irq_handler_kdb);
}
