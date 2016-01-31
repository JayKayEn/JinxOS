#include <lib.h>

#include <mboot.h>
#include <x86.h>
#include <console.h>
#include <cga.h>
#include <serial.h>
#include <e820.h>
#include <pit.h>
#include <kmm.h>
#include <vmm.h>
// #include <debug.h>
// #include <int.h>

static int cmd_help(int argc, char* argv[]);
static int cmd_info(int argc, char* argv[]);
static int cmd_clear(int argc, char* argv[]);
static int cmd_reboot(int argc, char* argv[]);
static int cmd_ticks(int argc, char* argv[]);
static int cmd_test(int argc, char* argv[]);

static const struct cmd {
    const char* name;
    const char* desc;
    int (*func)(int argc, char* argv[]);
} cmds[] = {
    {"help", "  -  Display this list of commands", cmd_help},
    {"info", "  -  Display kernel info", cmd_info},
    {"clear", " -  Clear the console of text", cmd_clear},
    {"ticks", " -  Display the number of pit ticks since boot", cmd_ticks},
    {"reboot", "-  Restart the computer and reload the bootloader", cmd_reboot},
    {"test", "  -  Run system tests", cmd_test}
};

extern int test_suite(int argc, char* argv[]);
int
cmd_test(int argc, char* argv[]) {
    test_suite(argc, argv);
    sti();
    return 0;
}

static int
cmd_help(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    for (size_t i = 1; i < ARRAY_SIZE(cmds); i++)
        print("\t%s  %s\n", cmds[i].name, cmds[i].desc);
    return 0;
}

static int cmd_info(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    print("\tCompiled on %s at %s\n", __DATE__, __TIME__);
    return 0;
}

static int
cmd_clear(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    cls();
    return 0;
}

static int
cmd_ticks(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    print("%lu\n", pit_ticks());
    return 0;
}

static int
cmd_reboot(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    // 0x64 : the keyboard io and data interface port
    // 0xFE : reset cpu command
    outb(0x64, 0xFE);
    return 0;
}

void
putc(const char c) {
    putc_serial(c);
    // putc_lpt(c);
    putc_cga(c);
}

char
getc(void) {
    if (console.rpos != console.wpos) {
        char c = console.buf[console.rpos++];
        if (console.rpos == CONSBUFSIZE)
            console.rpos = 0;
        return c;
    }
    return 0;
}

#define BUFLEN 1024

char*
readline(void) {
    static char buf[BUFLEN];

    int i = 0;
    while (1) {
        char c = getc();
        if (c < 0)
            return NULL;
        else if ((c == '\b' || c == '\x7f') && i > 0) {
            putc('\b');
            i--;
        } else if (c >= ' ' && i < BUFLEN - 1) {
            putc(c);
            buf[i++] = c;
        } else if (c == '\n' || c == '\r') {
            putc('\n');
            buf[i] = 0;
            return buf;
        }
    }
}

#define WHITESPACE " \t\r\n"
#define MAXARGS 16

static int
runcmd(char* buf) {
    // Parse the command buffer into whitespace-separated arguments
    int argc = 0;
    char* argv[MAXARGS] = {0};

    for (;;) {
        // gobble whitespace
        while (*buf && strchr(WHITESPACE, *buf))
            *buf++ = 0;
        if (*buf == 0)
            break;

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            print("Too many arguments (max %d)\n", MAXARGS);
            return 0;
        }
        argv[argc++] = buf;
        while (*buf && !strchr(WHITESPACE, *buf))
            buf++;
    }
    argv[argc] = 0;

    // Lookup and invoke the command
    if (argc == 0)
        return 0;

    static const size_t ncmds = ARRAY_SIZE(cmds);
    for (size_t i = 0; i < ncmds; i++)
        if (strcmp(argv[0], cmds[i].name) == 0)
            return cmds[i].func(argc, argv);

    print("Unknown command '%s'\n", argv[0]);
    return 0;
}

void
prompt(void) {
    if (crt.pos != 0)
        print("\n");
    print("<j> ");
    char* buf = readline();
    if (buf != NULL)
        if (runcmd(buf) < 0)
            return;
}
