#ifndef _ELF_H_
#define _ELF_H_

#define ELF_MAGIC 0x464C457FU   // "\x7FELF" in little endian

struct elf {
    uint32_t magic;
    uint8_t  elf[12];
    uint16_t type;
    uint16_t machine;
    uint32_t version;
    uint32_t entry;
    uint32_t poffset;
    uint32_t soffset;
    uint32_t flags;
    uint16_t size;
    uint16_t pesize;
    uint16_t nprogs;
    uint16_t sesize;
    uint16_t nsects;
    uint16_t sstridx;
};

struct prog {
    uint32_t type;
    uint32_t offset;
    uint32_t va;
    uint32_t pa;
    uint32_t filesize;
    uint32_t memsize;
    uint32_t flags;
    uint32_t align;
};

struct sect {
    uint32_t name;
    uint32_t type;
    uint32_t flags;
    uint32_t addr;
    uint32_t offset;
    uint32_t size;
    uint32_t link;
    uint32_t info;
    uint32_t addralign;
    uint32_t esize;
};

// prog.type
#define ELF_PT_LD       1

// prog.flags
#define ELF_PF_X        1
#define ELF_PF_W        2
#define ELF_PF_R        4

// sect.type
#define ELF_ST_NULL     0
#define ELF_ST_BITS     1
#define ELF_ST_STAB     2
#define ELF_ST_STRT     3

// sect.name
#define ELF_SN_NULL     0

#endif // _ELF_H_
