#include <lib.h>
#include <syscall.h>

static uint64_t state_128plus[2];

static
uint64_t
xorshift128plus(void) {
    uint64_t s1 = state_128plus[0];
    uint64_t s0 = state_128plus[1];
    state_128plus[0] = s0;
    s1 ^= s1 << 23;  // a
    s1 ^= s1 >> 17;  // b
    s0 ^= s0 >> 26;  // c
    return (state_128plus[1] = s0 ^ s1) + state_128plus[0];
}

static uint64_t state_1024star[16];
static int p;

static
uint64_t
xorshift1024star(void) {
    uint64_t s0 = state_1024star[p];
    uint64_t s1 = state_1024star[p = (p + 1) & 0xF];
    s1 ^= s1 << 31;  // a
    s1 ^= s1 >> 11;  // b
    s0 ^= s0 >> 30;  // c
    return (state_1024star[p] = s0 ^ s1) * 1181783497276652981LL;
}

uint64_t
random(void) {
    return xorshift1024star();
}

void
init_rand(void) {
    uint64_t zero = 0, one = 0;
    asm volatile ("\trdtsc\n"
                  "\tmovl %%eax, %0\n"
                  "\tmovl %%edx, %1\n" : "=r"(zero), "=r"(one));
    state_128plus[0] = zero;
    state_128plus[1] = one;

    while ((xorshift128plus() & 0x3F) != 0);

    for (uint8_t i = 0; i < 16; ++i)
        state_1024star[i] = xorshift128plus();

    while((random() & 0x3F) != 0)
        assert(random() != random());
}
