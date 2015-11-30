#include <lib.h>

void*
memcpy(void* dst, const void* src, size_t count) {
    const uint8_t* sp = (const uint8_t*) src;
    uint8_t* dp = (uint8_t*) dst;
    for(; count != 0; count--)
        *dp++ = *sp++;
    return dst;
}

void*
memset(void* dst, uint8_t val, size_t count) {
    uint8_t* temp = (uint8_t*) dst;
    for( ; count != 0; count--)
        *temp++ = val;
    return dst;
}

uint16_t*
memsetw(uint16_t* dst, uint16_t val, size_t count) {
    uint16_t* temp = (uint16_t*) dst;
    for( ; count != 0; count--)
        *temp++ = val;
    return dst;
}
