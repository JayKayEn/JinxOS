#include <types.h>

size_t strlen(const char* str);
char* strchr(const char* s, char c);
char* strstr(const char* str, const char* sub);
int strcmp(const char* s1, const char* s2);
char* strcat(char* dst, const char* s2);
char* strcpy(char* dst, const char* src);
int strncmp(const char* s1, const char* s2, size_t n);
char* strncat(char* dst, const char* src, size_t n);
char* strncpy(char* dst, const char* src, size_t n);

size_t
strlen(const char* str) {
    size_t len;
    for(len = 0; *str != '\0'; ++str)
        len++;

    return len;
}

char*
strchr(const char* s, char c) {
    for (; *s != c; ++s)
        if (*s == '\0')
            return 0;

    return (char*) s;
}

char*
strstr(const char* str, const char* sub) {
    char* b = (char*) sub;
    if (*b == 0)
        return (char*) str;

    for (; *str != 0; ++str) {
        if (*str != *b)
            continue;

        char* a = (char*) str;
        while (1) {
            if (*b == 0)
                return (char*) str;
            if (*a++ != *b++)
                break;
        }
        b = (char*) sub;
    }
    return NULL;
}

int
strcmp(const char* s1, const char* s2) {
    for (; *s1 == *s2; ++s1, ++s2)
        if (*s1 == '\0')
            return 0;

    return ((*(unsigned char*) s1 < * (unsigned char*) s2) ? -1 : +1);
}

char*
strcat(char* dst, const char* src) {
    strcpy(&dst[strlen(dst)], src);

    return dst;
}

char*
strcpy(char* dst, const char* src) {
    char* s = dst;

    while ((*s++ = *src++) != 0);

    return dst;
}

int
strncmp(const char* s1, const char* s2, size_t n) {
    for (; n > 0; ++s1, ++s2, --n) {
        if (*s1 != *s2)
            return ((*(unsigned char*) s1 < * (unsigned char*) s2) ? -1 : +1);
        if (*s1 == '\0')
            return 0;
    }

    return 0;
}

char*
strncat(char* dst, const char* src, size_t n) {
    if (n != 0) {
        char* d = dst;

        while (*d != 0)
            d++;
        do
            if ((*d++ = *src++) == 0)
                break;
        while (--n != 0);
        *d = 0;
    }

    return dst;
}

char*
strncpy(char* dst, const char* src, size_t n) {
    char* s = dst;
    while (n-- > 0 && *src != '\0')
        *s++ = *src++;

    while (n-- > 0)
        *s++ = '\0';

    return dst;
}

void*
memcpy(void* dst, const void* src, size_t count) {
    const uint8_t* sp = (const uint8_t*) src;
    for(uint8_t* dp = (uint8_t*) dst; count != 0; count--)
        *dp++ = *sp++;
    return dst;
}

void*
memmove(void* dst, const void* src, size_t count) {
    return memcpy(dst, src, count);
}

void*
memset(void* dst, uint8_t val, size_t count) {
    for(uint8_t* ptr = (uint8_t*) dst; count != 0; count--)
        *ptr++ = val;
    return dst;
}

uint16_t*
memsetw(uint16_t* dst, uint16_t val, size_t count) {
    for(uint16_t* ptr = (uint16_t*) dst; count != 0; count--)
        *ptr++ = val;
    return dst;
}

int
memcmp(const void* s1, const void* s2, size_t n) {
    if (n != 0) {
        uint8_t* p1 = (uint8_t*) s1;
        uint8_t* p2 = (uint8_t*) s2;

        do {
            if (*p1++ != *p2++)
                return (*--p1 - *--p2);
        } while (--n != 0);
    }
    return (0);
}

#ifndef USER
#include <kmm.h>

char*
strdup(const char* s) {
    size_t len = strlen(s);
    char* dup = kmalloc(len + 1);

    for (size_t i = 0; i < len; i++)
        dup[i] = s[i];
    dup[len] = 0;

    return dup;
}

#endif
