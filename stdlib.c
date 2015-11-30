#include <stdlib.h>

int
itoa(int n, char* buf) {
    const uint8_t radix = 10;

    char* ptr = buf;

    // get negatives out of the way
    if (n < 0) {
        *ptr++ = '-';
        n = -n;
    }

    char* cpy = ptr;

    do {
        *ptr++ = (n % radix) + '0';
        n /= radix;
    } while (n > 0);

    int len = (int) (ptr - buf);

    *ptr-- = 0;

    // reverse digits to place in correct order
    do {
        char tmp = *ptr;
        *ptr = *cpy;
        *cpy = tmp;
    } while (++cpy < --ptr);

    return len;
}
