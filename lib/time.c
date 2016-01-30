#include <lib.h>
#include <time.h>
#include <x86.h>
#include <errno.h>
#include <pit.h>
#include <kmm.h>

#define NTIMERS    128

static struct timer {
    uint32_t start_ticks;
    uint32_t stop_ticks;
    bool active;
}* timers[NTIMERS];

static
struct time
msec2time(uint32_t msec) {
    struct time t = {0};

    t.msec = msec % 1000;
    if ((msec /= 1000) != 0) {
        t.sec = msec % 60;
        if ((msec /= 60) != 0) {
            t.min = msec % 60;
            if ((msec /= 60) != 0)
                t.hr = msec;
        }
    }

    return t;
}

static
uint32_t
time2msec(struct time t) {
    return ((t.hr * 60 + t.min) * 60 + t.sec) * 1000 + t.msec;
}

int
timer_create(void) {
    for (int timer_id = 0; timer_id < NTIMERS; ++timer_id)
        if (timers[timer_id] == NULL) {
            timers[timer_id] = kmalloc(sizeof(struct timer));
            return timer_id;
        }
    return ENTIMER;
}

void
timer_start(int timer_id) {
    assert(timers[timer_id] != NULL);
    assert(!timers[timer_id]->active);

    timers[timer_id]->active = true;
    timers[timer_id]->start_ticks = pit_ticks();
}

struct time
timer_lap(int timer_id) {
    assert(timers[timer_id] != NULL);
    assert(timers[timer_id]->active);

    uint32_t now_ticks = pit_ticks();

    uint32_t ticks = now_ticks - timers[timer_id]->start_ticks;
    return msec2time(ticks);
}

struct time
timer_stop(int timer_id) {
    assert(timers[timer_id] != NULL);
    assert(timers[timer_id]->active);

    timers[timer_id]->stop_ticks = pit_ticks();
    timers[timer_id]->active = false;

    uint32_t ticks = timers[timer_id]->stop_ticks - timers[timer_id]->start_ticks;
    return msec2time(ticks);
}

void
timer_resume(int timer_id) {
    assert(timers[timer_id] != NULL);
    assert(!timers[timer_id]->active);

    timers[timer_id]->active = true;
}

void
timer_reset(int timer_id) {
    assert(timers[timer_id] != NULL);

    timers[timer_id]->start_ticks = 0;
    timers[timer_id]->stop_ticks = 0;
    timers[timer_id]->active = false;
}

void
timer_delete(int timer_id) {
    assert(timers[timer_id] != NULL);
    assert(!timers[timer_id]->active);

    kfree(timers[timer_id]);
    timers[timer_id] = NULL;
}

void
print_time(struct time t) {
    char buffer[32] = {0};

    if (t.hr != 0)
        snprintf(buffer, 32, "%u:%u:%u.%u", t.hr, t.min, t.sec, t.msec);
    else if (t.min != 0)
        snprintf(buffer, 32, "%u:%u.%u", t.min, t.sec, t.msec);
    else
        snprintf(buffer, 32, "%u.%u", t.sec, t.msec);

    print("%s\n", buffer);
}

struct time
time_diff(struct time start, struct time stop) {
    uint32_t ms_start = time2msec(start);
    uint32_t ms_stop = time2msec(stop);

    return ms_stop > ms_start ? msec2time(ms_stop - ms_start) : msec2time(ms_start - ms_stop);
}
