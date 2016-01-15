#include <lib.h>
#include <test.h>
#include <thread.h>

int
factorial(void* ptr, unsigned long val) {
    (void) ptr;

    if (val == 0)
        return 1;

    char name[24] = {0};
    int num = 10 * (int) ptr;
    struct thread* t[val];
    for (uint32_t i = 0; i < val; ++i) {
        snprintf(name, sizeof(name), "thread%d", num + i);
        thread_fork(name, &t[i], NULL, factorial, (void*) num + i, val - 1);
    }

    int ret = 0;
    int tret = 0;
    for (uint32_t i = 0; i < val; ++i) {
        thread_join(t[i], &tret);
        ret += tret;
    }

    return ret;
}

int
threadtest6(int argc, char** argv) {
    (void) argc;
    (void) argv;

    print("Starting thread test 6...\n");

    for (int i = 1; i <= 6; ++i)
        print("factorial(%d) = %d\n", i, factorial((void*) 0, (uint64_t) i));

    print("Thread test 6 complete.\n");

    return 0;
}
