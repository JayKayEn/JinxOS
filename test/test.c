#include <lib.h>
#include <test.h>

static const struct test {
    const char* name;
    int (*func)(int argc, char* argv[]);
} tests[] = {
    { "all", alltests },
    { "array", arraytest },
    { "bitmap", bitmaptest },
    { "cv", cvtest },
    { "hashtable", hashtabletest },
    { "heap", heaptest },
    { "list", listtest },
    { "lock", locktest },
    { "malloc", malloctest },
    { "malloc2", malloctest2 },
    { "malloc3", mallocstress },
    { "queue", queuetest },
    { "threadlist", threadlisttest },
    { "thread1", threadtest },
    { "thread2", threadtest2 },
    { "thread3", threadtest3 },
    { "thread4", threadtest4 },
    { "x", extreme }
};

int test_suite(int argc, char* argv[]) {
    if (argc == 1) {
        print("test options:\n");
        for (size_t i = 0; i < ARRAY_SIZE(tests); i++)
            print("\t%s\n", tests[i].name);
        return 0;
    }

    static const size_t ntests = ARRAY_SIZE(tests);
    for (size_t i = 0; i < ntests; i++)
        if (strcmp(argv[1], tests[i].name) == 0)
            return tests[i].func(argc, argv);

    print("Invalid test: %s\n", argv[1]);

    return 0;
}

int
alltests(int argc, char* argv[]) {
    static const size_t ntests = ARRAY_SIZE(tests) - 1; // no extreme
    for (size_t i = 1; i < ntests; i++) {
        print("\n");
        tests[i].func(argc, argv);
    }

    return 0;
}

int
extreme(int argc, char* argv[]) {
    for (int i = 0; i < 128; ++i)
        mallocstress(argc, argv);
    return 0;
}
