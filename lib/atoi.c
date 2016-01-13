#include <lib.h>

/*
 * Standard C function: parse a string that represents a decimal integer.
 * Leading whitespace is allowed. Trailing gunk is allowed too. Doesn't
 * really report syntax errors or overflow in any useful way.
 */

int
atoi(const char *s) {
    static const char digits[] = "0123456789";
    unsigned val=0;


    /* skip whitespace */
    while (*s==' ' || *s=='\t') {
        s++;
    }

    bool neg = false;
    if (*s=='-') {
        neg = true;
        s++;
    } else if (*s=='+') {
        s++;
    }

    /* process each digit */
    while (*s) {
        const char *where;
        unsigned digit;

        /* look for the digit in the list of digits */
        where = strchr(digits, *s);
        if (where==NULL) {
            /* not found; not a digit, so stop */
            break;
        }

        /* get the index into the digit list, which is the value */
        digit = (where - digits);

        /* could (should?) check for overflow here */

        /* shift the number over and add in the new digit */
        val = val*10 + digit;

        /* look at the next character */
        s++;
    }

    /* handle negative numbers */
    if (neg) {
        return -val;
    }

    /* done */
    return val;
}
