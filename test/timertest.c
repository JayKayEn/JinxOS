#include <lib.h>
#include <test.h>
#include <time.h>

#define NTIMES 25000

void
spin() {
    static volatile int x;
    x = 0;
    while (x++ < NTIMES);
}

int
timertest(int argc, char** argv) {
    (void) argc;
    (void) argv;

    print("Starting timer test...\n");

    int timer_id = timer_create();
    timer_start(timer_id);

    static volatile int x;
    x = 0;
    while (x++ < NTIMES)
        spin();

    struct time time = timer_stop(timer_id);
    print_time(time);

    timer_delete(timer_id);

    print("Timer test complete.\n");

    return 0;
}
