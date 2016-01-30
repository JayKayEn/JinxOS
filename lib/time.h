#ifndef _TIME_H_
#define _TIME_H_

struct time {
    uint32_t msec;
    uint32_t sec;
    uint32_t min;
    uint32_t hr;
};

int
timer_create(void);

void
timer_start(int timer_id);

struct time
timer_lap(int timer_id);

struct time
timer_stop(int timer_id);

void
timer_reset(int timer_id);

void
timer_delete(int timer_id);

void
print_time(struct time t);

#endif // _TIME_H_
