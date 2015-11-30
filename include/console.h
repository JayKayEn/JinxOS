#ifndef _CONSOLE_H_
#define _CONSOLE_H_

#include <lib.h>

#define CONSBUFSIZE 2000

struct console {
    uint8_t buf[CONSBUFSIZE];
    uint32_t rpos;
    uint32_t wpos;
} console;

void putc(const char c);
void puts(const char* s);

void prompt(void);

#endif
