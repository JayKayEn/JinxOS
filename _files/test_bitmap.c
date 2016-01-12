#include <assert.h>
#include <bitmap.h>
#include <stdio.h>
#include <types.h>

#define TESTSIZE 1024

int bitmaptest(void) {
    struct bitmap b;
    char data[TESTSIZE];
    uint32_t x;
    int i;

    print("Starting bitmap test...\n");

    for (i = 0; i < TESTSIZE; i++)
        data[i] = i % 2;

    assert(bitmap_init(&b) == 0);

    for (i = 0; i < TESTSIZE; i++)
        assert(bitmap_isset(&b, i) == 0);

    for (i = 0; i < TESTSIZE; ++i)
        if (data[i])
            bitmap_mark(&b, i);

    for (i = 0; i < TESTSIZE; ++i) {
        if (data[i])
            assert(bitmap_isset(&b, i));
        else
            assert(bitmap_isset(&b, i) == 0);
    }

    for (i = 0; i < TESTSIZE; ++i) {
        if (data[i])
            bitmap_unmark(&b, i);
        else
            bitmap_mark(&b, i);
    }

    for (i = 0; i < TESTSIZE; ++i) {
        if (data[i])
            assert(bitmap_isset(&b, i) == 0);
        else
            assert(bitmap_isset(&b, i));
    }

    while (bitmap_alloc(&b, &x) == 0) {
        assert(x < TESTSIZE);
        assert(bitmap_isset(&b, x));
        assert(data[x] == 1);
        data[x] = 0;
    }

    for (i = 0; i < TESTSIZE; ++i) {
        assert(bitmap_isset(&b, i));
        assert(data[i] == 0);
    }

    print("Bitmap test complete\n");

    return 0;
}
