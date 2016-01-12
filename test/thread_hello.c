#include <lib.h>
#include <thread.h>
#include <syscall.h>


int hello(void* ptr, unsigned long val) {
    (void) ptr;
    (void) val;

    print("Hello from thread %lu\n", val);
    sys_yield();
    print("Bye from thread %lu\n", val);

    return 0;
}


int
thread_hello(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    thread_fork("th0", NULL, NULL, hello, NULL, 0);
    thread_fork("th1", NULL, NULL, hello, NULL, 1);
    thread_fork("th2", NULL, NULL, hello, NULL, 2);
    thread_fork("th3", NULL, NULL, hello, NULL, 3);
    thread_fork("th4", NULL, NULL, hello, NULL, 4);

    sys_yield();
    print("\n");
    sys_yield();

    return 0;
}

// thread[0]
// thread[1]
// thread[2]
// thread[3]
// thread[4]
