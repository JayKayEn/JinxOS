#ifndef _ERRNO_H_
#define _ERRNO_H_

#define EINVAL      1       //  Invalid argument
#define ENOMEM      2       //  Out of memory
#define EFAULT      3       //  Bad memory reference
#define EBOUND      4       //  Argument out of bounds
#define ENOSPC      5       //  No space left is available

// #define ENOSYS           //  Function not implemented
// #define EDEADLK          //  Resource deadlock avoided

// #define EAGAIN           //  Operation would block
// #define EINTR            //  Interrupted system call
// #define EFAULT           //  Bad memory reference
// #define ELENGTH          //  String too long

// #define EPERM            //  Operation not permitted
// #define EACCES           //  Permission denied
// #define EMPROC           //  Too many processes
// #define ENPROC           //  Too many processes in system
// #define ENOEXEC          //  File is not executable
// #define E2BIG            //  Argument list too long
// #define ESRCH            //  No such process
// #define ECHILD           //  No child processes
// #define ENOTDIR          //  Not a directory
// #define EISDIR           //  Is a directory
// #define ENOENT           //  No such file or directory
// #define ELOOP            //  Too many levels of symbolic links
// #define ENOTEMPTY        //  Directory not empty
// #define EEXIST           //  File or object exists
// #define EMLINK           //  Too many hard links
// #define EXDEV            //  Cross-device link
// #define ENODEV           //  No such device
// #define ENXIO            //  Device not available
// #define EBUSY            //  Device or resource busy
// #define EMFILE           //  Too many open files
// #define ENFILE           //  Too many open files in system
// #define EBADF            //  Bad file number
// #define EIOCTL           //  Invalid or inappropriate ioctl
// #define EIO              //  Input/output error
// #define ESPIPE           //  Illegal seek
// #define EPIPE            //  Broken pipe
// #define EROFS            //  Read-only file system
// #define EDQUOT           //  Disc quota exceeded
// #define EFBIG            //  File too large
// #define EFTYPE           //  Invalid file type or format
// #define EDOM             //  Argument out of range
// #define ERANGE           //  Result out of range
// #define EILSEQ           //  Invalid multibyte character sequence
// #define ENOTSOCK         //  Not a socket
// #define EISSOCK          //  Is a socket
// #define EISCONN          //  Socket is already connected
// #define ENOTCONN         //  Socket is not connected
// #define ESHUTDOWN        //  Socket has been shut down
// #define EPFNOSUPPORT     //  Protocol family not supported
// #define ESOCKTNOSUPPORT  //  Socket type not supported
// #define EPROTONOSUPPORT  //  Protocol not supported
// #define EPROTOTYPE       //  Protocol wrong type for socket
// #define EAFNOSUPPORT     //  Address family not supported by protocol family
// #define ENOPROTOOPT      //  Protocol option not available
// #define EADDRINUSE       //  Address already in use
// #define EADDRNOTAVAIL    //  Cannot assign requested address
// #define ENETDOWN         //  Network is down
// #define ENETUNREACH      //  Network is unreachable
// #define EHOSTDOWN        //  Host is down
// #define EHOSTUNREACH     //  Host is unreachable
// #define ECONNREFUSED     //  Connection refused
// #define ETIMEDOUT        //  Connection timed out
// #define ECONNRESET       //  Connection reset by peer
// #define EMSGSIZE         //  Message too large
// #define ENOTSUP          //  Operation not supported

#endif // _ERRNO_H_
