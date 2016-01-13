#include <lib.h>


// Now: consistent generation
#define SEED0 0x5EED1D15EA5EC0DE
#define SEED1 0xDEADFACEF00DBABE

// Later:
// Get compile time and machine-specific information for the initial seed
//      - attempt to thread_yield some and use cpu_time for randomization

uint64_t state_128plus[2];

uint64_t xorshift128plus(void) {
    uint64_t s1 = state_128plus[0];
    const uint64_t s0 = state_128plus[1];
    state_128plus[0] = s0;
    s1 ^= s1 << 23; // a
    state_128plus[1] = s1 ^ s0 ^ (s1 >> 17) ^ (s0 >> 26);
    return state_128plus[1] + s0; // b, c
}

uint64_t state_1024star[16];
int p;

uint64_t xorshift1024star(void) {
    uint64_t s0 = state_1024star[p];
    uint64_t s1 = state_1024star[p = (p + 1) & 15];
    s1 ^= s1 << 31; // a
    s1 ^= s1 >> 11; // b
    s0 ^= s0 >> 30; // c
    return (state_1024star[p] = s0 ^ s1) * 1181783497276652981LL;
}

uint64_t
random(void) {
    return xorshift1024star();
}

void
init_rand(void) {
    state_128plus[0] = SEED0;
    state_128plus[1] = SEED1;

    uint64_t init = xorshift128plus();
    for (uint8_t i = 0; i < (init & 0xFF); ++i)
        xorshift128plus();
    for (uint8_t i = 0; i < 16; ++i)
        state_1024star[i] = xorshift128plus();
}
