#ifndef _VARGS_H_
#define _VARGS_H_

typedef __builtin_va_list va_list;

#define va_start(ap, fmt)   __builtin_va_start(ap, fmt)
#define va_arg(ap, type)    __builtin_va_arg(ap, type)
#define va_copy(ap1, ap2)   __builtin_va_copy(ap1, ap2)
#define va_end(ap)          __builtin_va_end(ap)

#endif // _VARGS_H_
