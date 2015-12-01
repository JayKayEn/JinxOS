#ifndef _CGA_H_
#define _CGA_H_

#include <lib.h>

// Each text element is 16 bits composed of the character itself
// and two bytes designating the background and font color.
//
//  +---------+--------+-------------+
//  | 15 - 12 | 11 - 8 | 7    -    0 |
//  +---------+--------+-------------+
//    Backgnd    Font     Character
//
//  Value   Color       Value   Color
//    0     BLACK         8     DARK GREY
//    1     BLUE          9     LIGHT BLUE
//    2     GREEN         A     LIGHT GREEN
//    3     CYAN          B     LIGHT CYAN
//    4     RED           C     LIGHT RED
//    5     MAGENTA       D     LIGHT MAGENTA
//    6     BROWN         E     LIGHT BROWN
//    7     LIGHT GREY    F     WHITE

// Default: Light Grey
#define VGA_NORMAL      0x0F00

// Light colors
#define VGA_BLUE        0x0900
#define VGA_GREEN       0x0A00
#define VGA_CYAN        0x0B00
#define VGA_RED         0x0C00
#define VGA_MAGENTA     0x0D00
#define VGA_BROWN       0x0E00
#define VGA_GREY        0x0700

// Dark colors
#define VGA_DBLUE       0x0100
#define VGA_DGREEN      0x0200
#define VGA_DCYAN       0x0300
#define VGA_DRED        0x0400
#define VGA_DMAGENTA    0x0500
#define VGA_DBROWN      0x0600
#define VGA_DGREY       0x0800

struct crt {
    uint16_t* buf;
    uint16_t pos;
} crt;

void init_console(void);

void putc_cga(const char c);
void cls(void);
void settextcolor(uint16_t color);

#endif // _CGA_H_
