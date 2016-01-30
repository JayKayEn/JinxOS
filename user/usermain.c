// Called from entry.S to get us going.
// entry.S already took care of defining envs, pages, uvpd, and uvpt.
#include <ulib.h>
#include <syscall.h>

const volatile struct proc* thisproc;
const char* binaryname = "<unknown>";

void
usermain(int argc, char** argv) {
    (void) argc;
    (void) argv;

    // // set thisenv to point at our Env structure in envs[].
    // // LAB 3: Your code here.
    // thisproc = &procs[ENVX(sys_getenvid())];

    // save the name of the program so that panic() can use it
    // if (argc > 0)
    //     binaryname = argv[0];

    // print("here!\n");

    // call user main routine
    main(argc, argv);

    // exit gracefully
    exit(0);
}
