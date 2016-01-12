#include <lib.h>
#include <kmm.h>
#include <err.h>
#include <bitmap.h>

#define DIVROUNDUP(a,b) (((a)+(b)-1)/(b))

struct bitmap {
    size_t bits;
    uint8_t* bytes;
};

struct bitmap*
bitmap_create(uint32_t bits) {
    struct bitmap* b = kmalloc(sizeof(struct bitmap));
    if (b == NULL)
        return NULL;

    uint32_t bytes = DIVROUNDUP(bits, 8);
    b->bytes = kmalloc(bytes);
    if (b->bytes == NULL) {
        kfree(b);
        return NULL;
    }

    memset(b->bytes, 0, bytes * sizeof(uint8_t));
    b->bits = bits;

    // extra bits (greater than @bits) at the end get marked
    if (bytes > bits >> 3) {
        uint32_t i = bytes - 1;
        assert(bits >> 3 == i);

        uint32_t extra = bits - (i << 3);
        assert(extra > 0 && extra < 8);

        for (uint32_t j = extra; j < 8; ++j)
            b->bytes[i] |= (uint8_t) 1 << j;
    }

    return b;
}

void*
bitmap_getdata(struct bitmap* b) {
    return b->bytes;
}

int
bitmap_alloc(struct bitmap* b, uint32_t* idx) {
    uint32_t max = DIVROUNDUP(b->bits, 8);
    for (uint32_t i = 0; i < max; ++i) {
        // if all bytes are set in this byte
        if (b->bytes[i] == 0xFF)
            continue;
        for (uint32_t n = 0; n < 8; ++n) {
            uint8_t msk = (uint8_t) 1 << n;
            // if this bit is not set
            if ((b->bytes[i] & msk) == 0) {
                b->bytes[i] |= msk;
                *idx = (i << 3) + n;
                assert(*idx < b->bits);
                return 0;
            }
        }
        panic("bitmap internal error");
    }
    return ENOSPC;
}

static inline void
bitmap_translate(uint32_t bit, uint32_t* i, uint8_t* msk) {
    uint32_t n = bit % 8;
    *i = bit >> 3;
    *msk = (uint8_t) 1 << n;
}

void
bitmap_mark(struct bitmap* b, uint32_t idx) {
    assert(idx < b->bits);

    uint32_t i;
    uint8_t msk;
    bitmap_translate(idx, &i, &msk);

    assert((b->bytes[i] & msk) == 0);
    b->bytes[i] |= msk;
}

void
bitmap_unmark(struct bitmap* b, uint32_t idx) {
    assert(idx < b->bits);

    uint32_t i;
    uint8_t msk;
    bitmap_translate(idx, &i, &msk);

    assert((b->bytes[i] & msk) != 0);
    b->bytes[i] &= ~msk;
}


bool
bitmap_isset(struct bitmap* b, uint32_t idx) {
    assert(idx < b->bits);

    uint32_t i;
    uint8_t msk;
    bitmap_translate(idx, &i, &msk);

    return (b->bytes[i] & msk);
}

void
bitmap_destroy(struct bitmap* b) {
    kfree(b->bytes);
    b->bytes = NULL;
    kfree(b);
}
