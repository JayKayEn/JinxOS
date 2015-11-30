#ifndef _LIB_H_
#define _LIB_H_

#include <vargs.h>

#define NULL ((void*) 0)

#ifndef _TYPES_
#define _TYPES_

typedef _Bool bool;
enum { false, true };

typedef signed char           int8_t;
typedef short                int16_t;
typedef int                  int32_t;
typedef long long            int64_t;

typedef unsigned char        uint8_t;
typedef unsigned short      uint16_t;
typedef unsigned int        uint32_t;
typedef unsigned long long  uint64_t;

typedef uint32_t              size_t;

#endif // _TYPES_

void puts(const char* text);
void putc(const char c);
char getc(void);

void print(const char* fmt, ...);
void vcprintf(const char* fmt, va_list);

int fprint(int fd, const char* fmt, ...);
int vfprintf(int fd, const char* fmt, va_list);

size_t strlen(const char* str);
char* strchr(const char* s, char c);
char* strstr(const char* str, const char* sub);
int strcmp(const char* s1, const char* s2);
char* strcat(char* dst, const char* s2);
char* strcpy(char* dst, const char* src);
int strncmp(const char* s1, const char* s2, size_t n);
char* strncat(char* dst, const char* src, size_t n);
char* strncpy(char* dst, const char* src, size_t n);

void* memcpy(void* dest, const void* src, size_t count);
void* memset(void* dest, uint8_t val, size_t count);
uint16_t* memsetw(uint16_t* dest, uint16_t val, size_t count);


#define assert(exp)                                                 \
    do {                                                            \
        if (!(exp)) {                                               \
            print("\n\t>>> assert(%s) failed at %s:%u in %s()\n",   \
                    #exp, __FILE__, __LINE__, __func__);            \
            asm volatile ("cli");                                   \
            asm volatile ("hlt");                                   \
        }                                                           \
    } while (0)

#define static_assert(exp) switch (exp) case 0: case (exp):

void _panic(const char* file, int line, const char* func, const char* fmt, ...);
#define panic(...) _panic(__FILE__, __LINE__, __func__, __VA_ARGS__)

#define MIN(_a, _b)             \
({                              \
    typeof(_a) __a = (_a);      \
    typeof(_b) __b = (_b);      \
    __a <= __b ? __a : __b;     \
})

#define MAX(_a, _b)             \
({                              \
    typeof(_a) __a = (_a);      \
    typeof(_b) __b = (_b);      \
    __a >= __b ? __a : __b;     \
})

#define ROUNDDOWN(a, n)                 \
({                                      \
    uint32_t __a = (uint32_t) (a);      \
    (typeof(a)) (__a - __a % (n));      \
})

#define ROUNDUP(a, n)                                           \
({                                                              \
    uint32_t __n = (uint32_t) (n);                              \
    (typeof(a)) (ROUNDDOWN((uint32_t) (a) + __n - 1, __n));     \
})

#define BIT(n)      (1UL << (n))

#define ARRAY_SIZE(a)   (sizeof(a) / sizeof(a[0]))

#endif // _LIB_H_
