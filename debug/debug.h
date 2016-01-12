#ifndef _DEBUG_H_
#define _DEBUG_H_

#include <lib.h>
#include <int.h>

// Debug information about a particular instruction pointer
struct debuginfo {
    const char* dbg_file;       // Source code filename for EIP
    int dbg_line;           // Source code linenumber for EIP

    const char* dbg_fn_name;    // Name of function containing EIP
    //  - Note: not null terminated!
    int dbg_fn_namelen;     // Length of function name
    size_t dbg_fn_addr;      // Address of start of function
    int dbg_fn_narg;        // Number of function arguments
};

int debuginfo_eip(size_t eip, struct debuginfo* info);
void backtrace(void);
void backtrace_regs(struct regs* regs);
void print_regs(struct regs* r);

#endif // _DEBUG_H_
