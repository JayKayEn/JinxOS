#include <lib.h>
#include <vargs.h>

void printfmt(void (*putc)(int), const char* fmt, ...);
void vprintfmt(void (*putc)(int), const char* fmt, va_list);

void
vcprintf(const char* fmt, va_list ap) {
    vprintfmt((void (*)(int)) putc, fmt, ap);
}

void
print(const char* fmt, ...) {
    va_list ap;

    va_start(ap, fmt);
    vcprintf(fmt, ap);
    va_end(ap);
}

/*
 * Space or zero padding and a field width are supported for the numeric
 * formats only.
 *
 * The special format %e takes an integer error code
 * and prints a string describing the error.
 * The integer may be positive or negative,
 * so that -E_NO_MEM and E_NO_MEM are equivalent.
 */

// static const char* const error_string[MAXERROR] = {
//     [E_UNSPECIFIED] = "unspecified error",
//     [E_BAD_ENV] = "bad environment",
//     [E_INVAL]   = "invalid parameter",
//     [E_NO_MEM]  = "out of memory",
//     [E_NO_FREE_ENV] = "out of environments",
//     [E_FAULT]   = "segmentation fault",
//     [E_IPC_NOT_RECV] = "env is not recving",
//     [E_EOF]     = "unexpected end of file",
// };

/*
 * Print a number (base <= 16) in reverse order,
 * using specified putc function and associated pointer putdat.
 */
static void
printnum(void (*putc)(int),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
}

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
    else if (lflag)
        return va_arg(*ap, unsigned long);
    else
        return va_arg(*ap, unsigned int);
}

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, long long);
    else if (lflag)
        return va_arg(*ap, long);
    else
        return va_arg(*ap, int);
}


// Main function to format and print a string.
void printfmt(void (*putc)(int), const char* fmt, ...);

void
vprintfmt(void (*putc)(int), const char* fmt, va_list ap) {
    register const char* p;
    register int ch;
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
            if (ch == '\0')
                return;
            putc(ch);
        }

        // Process a %-escape sequence
        padc = ' ';
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {

            // flag to pad on the right
            case '-':
                padc = '-';
                goto reswitch;

            // flag to pad with 0's instead of spaces
            case '0':
                padc = '0';
                goto reswitch;

            // width field
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
                    precision = precision * 10 + ch - '0';
                    ch = *fmt;
                    if (ch < '0' || ch > '9')
                        break;
                }
                goto process_precision;

            case '*':
                precision = va_arg(ap, int);
                goto process_precision;

            case '.':
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
                goto reswitch;

process_precision:
                if (width < 0)
                    width = precision, precision = -1;
                goto reswitch;

            // long flag (doubled for long long)
            case 'l':
                lflag++;
                goto reswitch;

            // character
            case 'c':
                putc(va_arg(ap, int));
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
                    putc(' ');
                break;

            // (signed) decimal
            case 'd':
                num = getint(&ap, lflag);
                if ((long long) num < 0) {
                    putc('-');
                    num = -(long long) num;
                }
                base = 10;
                goto number;

            // unsigned decimal
            case 'u':
                num = getuint(&ap, lflag);
                base = 10;
                goto number;

            // (unsigned) octal
            case 'o':
                num = getuint(&ap, lflag);
                base = 8;
                printnum(putc, num, base, width, padc);
                break;

            // pointer
            case 'p':
                putc('0');
                putc('x');
                num = (unsigned long long)
                      (size_t) va_arg(ap, void*);
                base = 16;
                goto number;

            // (unsigned) hexadecimal
            case 'x':
                num = getuint(&ap, lflag);
                base = 16;
number:
                printnum(putc, num, base, width, padc);
                break;

            // escaped '%' character
            case '%':
                putc(ch);
                break;

            // unrecognized escape sequence - just print it literally
            default:
                putc('%');
                for (fmt--; fmt[-1] != '%'; fmt--)
                    /* do nothing */;
                break;
        }
    }
}

void
printfmt(void (*putc)(int), const char* fmt, ...) {
    va_list ap;

    va_start(ap, fmt);
    vprintfmt(putc, fmt, ap);
    va_end(ap);
}
