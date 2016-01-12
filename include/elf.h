#ifndef _ELF_H_
#define _ELF_H_

#include <lib.h>

#define ELF_INFO 12             // ELF info bytes

struct elf {
    uint32_t magic;               // ELF magic (ELF_MAGIC)
    uint8_t  info[ELF_INFO];      // Identifying info
    uint16_t type;                // Object file type
    uint16_t machine;             // Architecture
    uint32_t version;             // Object file version
    uint32_t entry;               // Entry point virtual address
    uint32_t phoff;               // Program header table file offset
    uint32_t shoff;               // Section header table file offset
    uint32_t flags;               // Processor-specific flags
    uint16_t ehsize;              // ELF header size in bytes
    uint16_t phentsize;           // Program header table entry size
    uint16_t phnum;               // Program header table entry count
    uint16_t shentsize;           // Section header table entry size
    uint16_t shnum;               // Section header table entry count
    uint16_t shstrndx;            // Section header string table index
};

// elf.magic
#define ELF_MAGIC   0x464C457FU   // "0x7FELF" in little endian

// elf.type
#define ET_NONE         0       // No file type
#define ET_REL          1       // Relocatable file
#define ET_EXEC         2       // Executable file
#define ET_DYN          3       // Shared object file
#define ET_CORE         4       // Core file

// elf.machine
#define EM_NONE         0       // No machine
#define EM_386          3       // Intel 80386
#define EM_JINX         0x44D   // Jinx Alpha (1101)

// elf.version
#define EV_NONE         0       // Invalid ELF version
#define EV_CURRENT      1       // Current version

struct prog {
    uint32_t type;                // Segment type
    uint32_t offset;              // Segment file offset
    uint32_t vaddr;               // Segment virtual address
    uint32_t paddr;               // Segment physical address
    uint32_t filesz;              // Segment size in file
    uint32_t memsz;               // Segment size in memory
    uint32_t flags;               // Segment flags
    uint32_t align;               // Segment alignment
};

// prog.type
#define PT_NULL         0       // Program header table entry unused
#define PT_LOAD         1       // Loadable program segment

// prog.flags
#define PF_X            1       // Segment is executable
#define PF_W            2       // Segment is writable
#define PF_R            4       // Segment is readable

struct sect {
    uint32_t name;                // Section name (string tbl index)
    uint32_t type;                // Section type
    uint32_t flags;               // Section flags
    uint32_t addr;                // Section virtual addr at execution
    uint32_t offset;              // Section file offset
    uint32_t size;                // Section size in bytes
    uint32_t link;                // Link to another section
    uint32_t info;                // Additional section information
    uint32_t addralign;           // Section alignment
    uint32_t entsize;             // Entry size if section holds table
};

// sect.type
#define ST_NULL         0       // Section header table entry unused
#define ST_PROGBITS     1       // Program data
#define ST_SYMTAB       2       // Symbol table
#define ST_STRTAB       3       // String table

// sect.flags
#define SF_W            1       // Writable
#define SF_A            2       // Read-only
#define SF_X            4       // Executable

// sect.name
#define SN_NULL         0       // Section name absent

#endif // _ELF_H_
