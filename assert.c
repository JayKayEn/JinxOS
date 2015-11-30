#include <lib.h>
#include <x86.h>

void
_panic(const char* file, int line, const char* func, const char* fmt, ...) {
    static const char* panicstr;

    if (panicstr ==  NULL) {
        panicstr = fmt;

        // Be extra sure that the machine is in a reasonable state
        asm volatile("cli; cld");

        va_list ap;
        va_start(ap, fmt);
        print("\n\t>>> panic at %s:%d in %s(): ", file, line, func);
        vcprintf(fmt, ap);
        print("\n");
        va_end(ap);
    }

    while(1)
        hlt();
}
