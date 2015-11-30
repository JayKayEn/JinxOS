#include <lib.h>
#include <kmm.h>
#include <err.h>
#include <kadt.h>

#define DIVROUNDUP(a,b) (((a)+(b)-1)/(b))

struct kbitmap {
    size_t bits;
    uint8_t* bytes;
};

struct kbitmap *
kbitmap_create(uint32_t bits) {
    struct kbitmap* b = kalloc(sizeof(struct kbitmap));
    if (b == NULL) {
        return NULL;
    }

    uint32_t bytes = DIVROUNDUP(bits, 8);
    b->bytes = kalloc(bytes * sizeof(uint8_t));
    if (b->bytes == NULL) {
        kfree(b);
        return NULL;
    }

    memset(b->bytes, 0, bytes * sizeof(uint8_t));
    b->bits = bits;

    // Mark any leftover bits at the end in use
    if (bytes > bits >> 3) {
        uint32_t j, i = bytes - 1;
        uint32_t overbits = bits - (i << 3);

        assert(bits >> 3 == bytes - 1);
        assert(overbits > 0 && overbits < 8);

        for (j = overbits; j < 8; ++j) {
            b->bytes[i] |= (uint8_t) 1 << j;
        }
    }

    return b;
}

int
kbitmap_alloc(struct kbitmap* b, uint32_t* index) {
    uint32_t i;
    uint32_t max = DIVROUNDUP(b->bits, 8);
    for (i = 0; i < max; ++i) {
        // if not all bytes are set in this byte
        if (b->bytes[i] != 0xFF) {
            uint32_t offset;
            for (offset = 0; offset < 8; ++offset) {
                uint8_t mask = (uint8_t) 1 << offset;
                // if this bit is not set
                if ((b->bytes[i] & mask) == 0) {
                    b->bytes[i] |= mask;
                    *index = (i << 3) + offset;
                    assert(*index < b->bits);
                    return 0;
                }
            }
            panic("bitmap internal error");
        }
    }
    return ENOSPC;
}

static
inline
void
kbitmap_translate(uint32_t bitno, uint32_t* i, uint8_t* mask) {
    uint32_t offset = bitno % 8;
    *i = bitno >> 3;
    *mask = (uint8_t) 1 << offset;
}

void
kbitmap_mark(struct kbitmap* b, uint32_t index) {
    assert(index < b->bits);

    uint32_t i;
    uint8_t mask;
    kbitmap_translate(index, &i, &mask);

    assert((b->bytes[i] & mask) == 0);
    b->bytes[i] |= mask;
}

void
kbitmap_unmark(struct kbitmap* b, uint32_t index) {
    assert(index < b->bits);

    uint32_t i;
    uint8_t mask;
    kbitmap_translate(index, &i, &mask);

    assert((b->bytes[i] & mask) != 0);
    b->bytes[i] &= ~mask;
}


bool
kbitmap_isset(struct kbitmap* b, uint32_t index) {
    assert(index < b->bits);

    uint32_t i;
    uint8_t mask;
    kbitmap_translate(index, &i, &mask);

    return (b->bytes[i] & mask);
}

void
kbitmap_destroy(struct kbitmap *b) {
    kfree(b->bytes);
    b->bytes = NULL;
    kfree(b);
}
