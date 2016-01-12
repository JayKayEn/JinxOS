#ifndef _TEST_H_
#define _TEST_H_

/*
 * Declarations for test code and other miscellaneous high-level
 * functions.
 */


/*
 * Test code.
 */

/* data structure tests */
int arraytest(int, char **);
int bitmaptest(int, char **);
int listtest(int, char **);
int queuetest(int, char **);
int heaptest(int, char **);
int hashtabletest(int, char **);
int threadlisttest(int, char **);

/* thread tests */
int threadtest(int, char **);
int threadtest2(int, char **);
int threadtest3(int, char **);
int semtest(int, char **);
int locktest(int, char **);
int cvtest(int, char **);

// /* filesystem tests */
// int fstest(int, char **);
// int readstress(int, char **);
// int writestress(int, char **);
// int writestress2(int, char **);
// int longstress(int, char **);
// int createstress(int, char **);
// int printfile(int, char **);

/* other tests */
int malloctest(int, char **);
int mallocstress(int, char **);
int malloctest3(int, char **);
// int nettest(int, char **);

// #if OPT_SYNCHPROBS
// int netqueuetest(int, char **);
// #endif

// /* Routine for running a user-level program. */
// int runprogram(char *progname);

// /* Kernel menu system. */
// void menu(char *argstr);

// /* The main function, called from start.S. */
// void kmain(char *bootstring);


#endif // _TEST_H_ */
