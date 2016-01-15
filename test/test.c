#include <lib.h>
#include <test.h>

static const struct test {
    const char* name;
    int (*func)(int argc, char* argv[]);
} tests[] = {
    { "all", alltests },

    { "array", arraytest },
    { "heap", heaptest },
    { "bitmap", bitmaptest },
    { "list", listtest },
    { "queue", queuetest },
    { "hashtable", hashtabletest },

    { "malloc1", malloctest },
    { "malloc2", malloctest2 },
    { "malloc3", mallocstress },

    { "cv", cvtest },
    { "lock", locktest },

    { "threadlist", threadlisttest },

    { "thread1", threadtest },
    { "thread2", threadtest2 },
    { "thread3", threadtest3 },
    { "thread4", threadtest4 },
    { "thread5", threadtest5 },
    { "thread6", threadtest6 },
    { "thread7", threadtest7 },

    { "x", extreme }
};

static const size_t ntests = ARRAY_SIZE(tests);

int test_suite(int argc, char* argv[]) {
    if (argc == 1) {
        print("test options:\n");
        for (size_t i = 0; i < ntests - 1; i++)
            print("\t > %s\n", tests[i].name);
        return 0;
    }

    print("\n");
    for (size_t i = 0; i < ntests; i++)
        if (strcmp(argv[1], tests[i].name) == 0)
            return tests[i].func(argc, argv);

    print("Invalid test: %s\n", argv[1]);

    return 0;
}

int
alltests(int argc, char* argv[]) {
    for (size_t i = 1; i < ntests - 1; i++) {  // no extreme()
        print("\n");
        tests[i].func(argc, argv);
    }

    return 0;
}

int
extreme(int argc, char* argv[]) {
    print("\nStarting randomized testing...\n\n");
    for (int i = 0; i < 1024; ++i) {
        size_t test = (random() % (ntests - 2)) + 1;
        print("%d: \n", i);
        tests[test].func(argc, argv);
        print("\n");
    }
    print("Finished randomized testing...\n");
    return 0;
}
