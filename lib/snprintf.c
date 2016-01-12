#include <lib.h>
#include <err.h>


static void
snprintnum (void (*putch) (int, void*), void* putdat,
            unsigned long long num, unsigned base, int width, int padc) {
    char buf[68], *x;

    for (x = buf; num; num /= base)
        * x++ = "0123456789abcdef"[num % base];
    if (x == buf)
        *x++ = '0';

    if (padc != '-')
        for (; width > x - buf; width--)
            putch (padc, putdat);

    for (; x > buf; width--)
        putch (*--x, putdat);

    if (padc == '-')
        for (; width > 0; width--)
            putch (' ', putdat);
}

#define getuint(ap, lflag)          \
  ({                        \
    long long __v;              \
    if (lflag >= 2)             \
      __v = va_arg (ap, unsigned long long);    \
    else if (lflag)             \
      __v = va_arg (ap, unsigned long);     \
    else                    \
      __v = va_arg (ap, unsigned int);      \
    __v;                    \
  })

#define getint(ap, lflag)           \
  ({                        \
    long long __v;              \
    if (lflag >= 2)             \
      __v = va_arg (ap, long long);     \
    else if (lflag)             \
      __v = va_arg (ap, long);          \
    else                    \
      __v = va_arg (ap, int);           \
    __v;                    \
  })

void
vsnprintfmt (void (*putch) (int, void*), void* putdat, const char* fmt,
             va_list ap) {
    register const char* p;
    register int ch;
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
            if (ch == '\0')
                return;
            putch (ch, putdat);
        }

        padc = ' ';
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
            case '-':
                padc = '-';
                goto reswitch;

            case '0':
                padc = '0';
                goto reswitch;

            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0;; ++fmt) {
                    precision = precision * 10 + ch - '0';
                    ch = *fmt;
                    if (ch < '0' || ch > '9')
                        break;
                }
                goto process_precision;

            case '*':
                precision = va_arg (ap, int);
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

            case 'l':
                lflag++;
                goto reswitch;

            case 'z':
                if (sizeof(size_t) == sizeof(long))
                    lflag = 1;
                else if (sizeof(size_t) == sizeof(long long))
                    lflag = 2;
                else
                    lflag = 0;
                goto reswitch;

            case 'c':
                putch (va_arg (ap, int), putdat);
                break;

            case 's':
                if ((p = va_arg (ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen (p); width > 0; width--)
                        putch (padc, putdat);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putch ('?', putdat);
                    else
                        putch (ch, putdat);
                for (; width > 0; width--)
                    putch (' ', putdat);
                break;

            case 'b':
                num = getint (ap, lflag);
                base = 2;
                goto number;

            case 'd':
                num = getint (ap, lflag);
                if ((long long) num < 0) {
                    putch ('-', putdat);
                    num = -(long long) num;
                }
                base = 10;
                goto number;

            case 'u':
                num = getuint (ap, lflag);
                base = 10;
                goto number;

            case 'o':
                num = getuint (ap, lflag);
                base = 8;
                goto number;

            case 'p':
                putch ('0', putdat);
                putch ('x', putdat);
                num = (unsigned long long)
                      (size_t) va_arg (ap, void*);
                base = 16;
                goto number;

            case 'x':
                num = getuint (ap, lflag);
                base = 16;
number:
                snprintnum (putch, putdat, num, base, MAX(width, 0), padc);
                break;

            default:
                putch ('%', putdat);
                while (lflag-- > 0)
                    putch ('l', putdat);

            case '%':
                putch (ch, putdat);
        }
    }
}

struct sprintbuf {
    char* buf;
    char* ebuf;
    int cnt;
};

static void
sprintputch (int ch, struct sprintbuf* b) {
    b->cnt++;
    if (b->buf < b->ebuf)
        *b->buf++ = ch;
}

int
vsnprintf (char* buf, size_t n, const char* fmt, va_list ap) {
    struct sprintbuf b = { buf, buf + n - 1, 0 };

    if (buf == NULL || n < 1)
        return EINVAL;

    vsnprintfmt ((void*) sprintputch, &b, fmt, ap);

    *b.buf = '\0';

    return b.cnt;
}

int
snprintf (char* buf, size_t n, const char* fmt, ...) {
    va_list ap;
    int rc;

    va_start (ap, fmt);
    rc = vsnprintf (buf, n, fmt, ap);
    va_end (ap);

    return rc;
}

int
sprintf (char* buf, const char* fmt, ...) {
    va_list ap;
    int cnt;

    va_start (ap, fmt);
    cnt = vsnprintf (buf, 100000, fmt, ap);
    va_end (ap);

    return cnt;
}
