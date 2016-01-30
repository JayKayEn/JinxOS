#include <lib.h>
#include <debug.h>
#include <stab.h>
#include <int.h>
#include <x86.h>
#include <vmm.h>

extern const struct stab _stab[];  // Beginning of stabs table
extern const struct stab _estab[];    // End of stabs table
extern const char _stabstr[];      // Beginning of string table
extern const char _estabstr[];        // End of string table

struct ustab {
    const struct stab* stabs;
    const struct stab* stab_end;
    const char* stabstr;
    const char* stabstr_end;
};


// stab_binsearch(stabs, region_left, region_right, type, addr)
//
//  Some stab types are arranged in increasing order by instruction
//  address.  For example, N_FUN stabs (stab entries with n_type ==
//  N_FUN), which mark functions, and N_SO stabs, which mark source files.
//
//  Given an instruction address, this function finds the single stab
//  entry of type 'type' that contains that address.
//
//  The search takes place within the range [*region_left, *region_right].
//  Thus, to search an entire set of N stabs, you might do:
//
//      left = 0;
//      right = N - 1;     /* rightmost stab */
//      stab_binsearch(stabs, &left, &right, type, addr);
//
//  The search modifies *region_left and *region_right to bracket the
//  'addr'.  *region_left points to the matching stab that contains
//  'addr', and *region_right points just before the next stab.  If
//  *region_left > *region_right, then 'addr' is not contained in any
//  matching stab.
//
//  For example, given these N_SO stabs:
//      Index  Type   Address
//      0      SO     f0100000
//      13     SO     f0100040
//      117    SO     f0100176
//      118    SO     f0100178
//      555    SO     f0100652
//      556    SO     f0100654
//      657    SO     f0100849
//  this code:
//      left = 0, right = 657;
//      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//  will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct stab* stabs, int* region_left, int* region_right,
               int type, size_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
        if (m < l) {    // no match in [l, m]
            l = true_m + 1;
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
            *region_left = m;
            l = true_m + 1;
        } else if (stabs[m].n_value > addr) {
            *region_right = m - 1;
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
            l = m;
            addr++;
        }
    }

    if (!any_matches)
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
                l > *region_left && stabs[l].n_type != type;
                l--)
            /* do nothing */;
        *region_left = l;
    }
}


// debuginfo_eip(addr, info)
//
//  Fill in the 'info' structure with information about the specified
//  instruction address, 'addr'.  Returns 0 if information was found, and
//  negative if not.  But even if it returns negative it has stored some
//  information into '*info'.
//
int
debuginfo_eip(size_t addr, struct debuginfo* info) {
    const struct stab* stabs, *stab_end;
    const char* stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->dbg_file = "<unknown>";
    info->dbg_line = 0;
    info->dbg_fn_name = "<unknown>";
    info->dbg_fn_namelen = 9;
    info->dbg_fn_addr = addr;
    info->dbg_fn_narg = 0;

    // Find the relevant set of stabs
    if (addr >= 0xbf800000) {
        stabs = _stab;
        stab_end = _estab;
        stabstr = _stabstr;
        stabstr_end = _estabstr;
    } else {
        // Can't search for user-level addresses yet!
        // backtrace();
        const struct ustab* ustab = (const struct ustab*) USTABDATA;
        stabs = ustab->stabs;
        stab_end = ustab->stab_end;
        stabstr = ustab->stabstr;
        stabstr_end = ustab->stabstr_end;
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
        return -1;

    // Now we find the right stabs that define the function containing
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
    rfile = (stab_end - stabs) - 1;
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
    if (lfile == 0)
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
    rfun = rfile;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);

    if (lfun <= rfun) {
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
            info->dbg_fn_name = stabstr + stabs[lfun].n_strx;
        info->dbg_fn_addr = stabs[lfun].n_value;
        addr -= info->dbg_fn_addr;
        // Search within the function definition for the line number.
        lline = lfun;
        rline = rfun;
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->dbg_fn_addr = addr;
        lline = lfile;
        rline = rfile;
    }
    // Ignore stuff after the colon.
    info->dbg_fn_namelen = strstr(info->dbg_fn_name, ":") - info->dbg_fn_name;


    // Search within [lline, rline] for the line number stab.
    // If found, set info->dbg_line to the right line number.
    // If not found, return -1.
    //
    // Hint:
    //  There's a particular stabs type used for line numbers.
    //  Look at the STABS documentation and <inc/stab.h> to find
    //  which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (rline < lline)
        return -1;
    info->dbg_line = stabs[lline].n_desc;


    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
            && stabs[lline].n_type != N_SOL
            && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
        lline--;
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
        info->dbg_file = stabstr + stabs[lline].n_strx;


    // Set dbg_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
        for (lline = lfun + 1;
                lline < rfun && stabs[lline].n_type == N_PSYM;
                lline++)
            info->dbg_fn_narg++;

    return 0;
}

void
backtrace_regs(struct trapframe* regs) {
    uint32_t _ebp[2] = { regs->ebp, regs->eip };
    uint32_t* ebp = (uint32_t*) &_ebp;

    print("Stack backtrace:\n");
    // char* file = NULL;
    while(ebp != NULL) {
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
        print("\tebp %08x eip %08x args[%u]",
              ebp, ebp[1], info.dbg_fn_narg);
        for (int i = 0; i < info.dbg_fn_narg; ++i)
            print(" %08x", ebp[2 + i]);
        print("\n");
        print("\t\t%s:%d %.*s()\n\n",
              info.dbg_file, info.dbg_line,
              info.dbg_fn_namelen, info.dbg_fn_name);
        ebp = (uint32_t*) ebp[0];
        // file = (char*) info.dbg_file;
    }
}

void
backtrace(void) {
    uint32_t* ebp = (uint32_t*) read_ebp();

    print("Stack backtrace:\n");
    // char* file = NULL;
    while(ebp != NULL) {
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
        print("\tebp %08x eip %08x args[%u]",
              ebp, ebp[1], info.dbg_fn_narg);
        for (int i = 0; i < info.dbg_fn_narg; ++i)
            print(" %08x", ebp[2 + i]);
        print("\n");
        print("\t\t%s:%d %.*s()\n\n",
              info.dbg_file, info.dbg_line,
              info.dbg_fn_namelen, info.dbg_fn_name);
        ebp = (uint32_t*) ebp[0];
        // file = (char*) info.dbg_file;
    }
}

void
print_regs(struct trapframe* r) {
    if (r == NULL)
        print("NULL");
    else {
        print("regs: %08p\n", r);
        print("\tes     : 0x%x\n", r->es);
        print("\tds     : 0x%x\n", r->ds);
        print("\tedi    : %p\n", r->edi);
        print("\tesi    : %p\n", r->esi);
        print("\tebp    : %p\n", r->ebp);
        print("\t_esp   : %p\n", r->_esp);
        print("\tebx    : %p\n", r->ebx);
        print("\tedx    : %p\n", r->edx);
        print("\tecx    : %p\n", r->ecx);
        print("\teax    : %p\n", r->eax);
        print("\tintno  : %u\n", r->int_no);
        print("\tecode  : %u\n", r->err_code);
        print("\teip    : %p\n", r->eip);
        print("\tcs     : 0x%x\n", r->cs);
        print("\teflags : 0x%08x\n", r->eflags);
        print("\tesp    : %p\n", r->esp);
        print("\tss     : 0x%x\n", r->ss);
    }
}
