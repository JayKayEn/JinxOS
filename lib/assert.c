#include <lib.h>
#include <x86.h>

void
_panic(const char* file, int line, const char* func, const char* fmt, ...) {
    cli();

    static volatile const char* panicstr;
    if (panicstr ==  NULL) {
        panicstr = fmt;

        va_list ap;
        va_start(ap, fmt);
        print("\n\t>>> panic at %s:%d in %s: ", file, line, func);
        vcprintf(fmt, ap);
        print("\n");
        va_end(ap);

        print("\n");
        extern void backtrace(void);
        backtrace();
    }

    for (;;)
        hlt();
}
