#ifndef _TEST_H_
#define _TEST_H_

/*
 * Declarations for test code and other miscellaneous high-level
 * functions.
 */

int test_suite(int argc, char* argv[]);
int alltests(int argc, char* argv[]);

/*
 * Test code.
 */

/* data structure tests */
int arraytest(int argc, char* argv[]);
int bitmaptest(int argc, char* argv[]);
int listtest(int argc, char* argv[]);
int queuetest(int argc, char* argv[]);
int heaptest(int argc, char* argv[]);
int hashtabletest(int argc, char* argv[]);
int threadlisttest(int argc, char* argv[]);

/* thread tests */
int threadtest(int argc, char* argv[]);
int threadtest2(int argc, char* argv[]);
int threadtest3(int argc, char* argv[]);
int threadtest4(int argc, char* argv[]);
int threadtest5(int argc, char* argv[]);
int threadtest6(int argc, char* argv[]);
int threadtest7(int argc, char* argv[]);

int semtest(int argc, char* argv[]);
int locktest(int argc, char* argv[]);
int cvtest(int argc, char* argv[]);

int synchtest(int argc, char* argv[]);
int threadforktest(int argc, char* argv[]);

// /* filesystem tests */
// int fstest(int argc, char* argv[]);
// int readstress(int argc, char* argv[]);
// int writestress(int argc, char* argv[]);
// int writestress2(int argc, char* argv[]);
// int longstress(int argc, char* argv[]);
// int createstress(int argc, char* argv[]);
// int printfile(int argc, char* argv[]);

/* other tests */
int malloctest(int argc, char* argv[]);
int malloctest2(int argc, char* argv[]);
int mallocstress(int argc, char* argv[]);

// int nettest(int argc, char* argv[]);

// #if OPT_SYNCHPROBS
// int netqueuetest(int argc, char* argv[]);
// #endif

int timertest(int argc, char* argv[]);

int extreme(int argc, char* argv[]);

#endif // _TEST_H_ */
