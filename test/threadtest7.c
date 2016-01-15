#include <lib.h>
#include <test.h>
#include <thread.h>

int
sum(void* ptr, unsigned long val) {
    (void) ptr;

    if (val < 2)
        return val;

    char name[24] = {0};
    snprintf(name, sizeof(name), "thread%d", val);

    struct thread* t;
    thread_fork(name, &t, NULL, sum, NULL, val - 1);

    int tret = 0;
    thread_join(t, &tret);

    return 1 + tret;
}

int
threadtest7(int argc, char** argv) {
    (void) argc;
    (void) argv;

    print("Starting thread test 7...\n");

    for (int i = 0; i < 128; ++i)
        assert(sum(NULL, i) == i);

    print("Thread test 7 complete.\n");

    return 0;
}
