
obj/bmain.o:     file format elf32-i386


Disassembly of section .text:

00000000 <waitdisk>:
    for (; pa < end; pa += SECTSIZE, ++offset)
        readsect((uint8_t*) pa, offset);
}

void
waitdisk(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   3:	ba f7 01 00 00       	mov    $0x1f7,%edx
   8:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40);
   9:	83 e0 c0             	and    $0xffffffc0,%eax
   c:	3c 40                	cmp    $0x40,%al
   e:	75 f8                	jne    8 <waitdisk+0x8>
}
  10:	5d                   	pop    %ebp
  11:	c3                   	ret    

00000012 <readsect>:

void
readsect(void* dst, uint32_t offset) {
  12:	55                   	push   %ebp
  13:	89 e5                	mov    %esp,%ebp
  15:	57                   	push   %edi
  16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    waitdisk();
  19:	e8 fc ff ff ff       	call   1a <readsect+0x8>
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1e:	ba f2 01 00 00       	mov    $0x1f2,%edx
  23:	b0 01                	mov    $0x1,%al
  25:	ee                   	out    %al,(%dx)
  26:	ba f3 01 00 00       	mov    $0x1f3,%edx
  2b:	88 c8                	mov    %cl,%al
  2d:	ee                   	out    %al,(%dx)
  2e:	89 c8                	mov    %ecx,%eax
  30:	c1 e8 08             	shr    $0x8,%eax
  33:	ba f4 01 00 00       	mov    $0x1f4,%edx
  38:	ee                   	out    %al,(%dx)
  39:	89 c8                	mov    %ecx,%eax
  3b:	c1 e8 10             	shr    $0x10,%eax
  3e:	ba f5 01 00 00       	mov    $0x1f5,%edx
  43:	ee                   	out    %al,(%dx)
  44:	89 c8                	mov    %ecx,%eax
  46:	c1 e8 18             	shr    $0x18,%eax
  49:	83 c8 e0             	or     $0xffffffe0,%eax
  4c:	ba f6 01 00 00       	mov    $0x1f6,%edx
  51:	ee                   	out    %al,(%dx)
  52:	ba f7 01 00 00       	mov    $0x1f7,%edx
  57:	b0 20                	mov    $0x20,%al
  59:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
  5a:	e8 fc ff ff ff       	call   5b <readsect+0x49>
    return data;
}

static inline void
insl(int port, void* addr, int cnt) {
    asm volatile("cld\n\trepne\n\tinsl"
  5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  62:	b9 80 00 00 00       	mov    $0x80,%ecx
  67:	ba f0 01 00 00       	mov    $0x1f0,%edx
  6c:	fc                   	cld    
  6d:	f2 6d                	repnz insl (%dx),%es:(%edi)

    insl(0x1F0, dst, SECTSIZE >> 2);
}
  6f:	5f                   	pop    %edi
  70:	5d                   	pop    %ebp
  71:	c3                   	ret    

00000072 <readseg>:

    ((void (*)(void)) (elf->entry))();
}

void
readseg(uint32_t pa, uint32_t count, uint32_t offset) {
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	56                   	push   %esi
  77:	53                   	push   %ebx
  78:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint32_t end = pa + count;
  7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  7e:	01 de                	add    %ebx,%esi

    pa &= ~(SECTSIZE - 1);
  80:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
    offset = (offset / SECTSIZE);
  86:	8b 7d 10             	mov    0x10(%ebp),%edi
  89:	c1 ef 09             	shr    $0x9,%edi

    for (; pa < end; pa += SECTSIZE, ++offset)
  8c:	39 f3                	cmp    %esi,%ebx
  8e:	73 12                	jae    a2 <readseg+0x30>
        readsect((uint8_t*) pa, offset);
  90:	57                   	push   %edi
  91:	53                   	push   %ebx
  92:	e8 fc ff ff ff       	call   93 <readseg+0x21>
    uint32_t end = pa + count;

    pa &= ~(SECTSIZE - 1);
    offset = (offset / SECTSIZE);

    for (; pa < end; pa += SECTSIZE, ++offset)
  97:	81 c3 00 02 00 00    	add    $0x200,%ebx
  9d:	47                   	inc    %edi
  9e:	58                   	pop    %eax
  9f:	5a                   	pop    %edx
  a0:	eb ea                	jmp    8c <readseg+0x1a>
        readsect((uint8_t*) pa, offset);
}
  a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  a5:	5b                   	pop    %ebx
  a6:	5e                   	pop    %esi
  a7:	5f                   	pop    %edi
  a8:	5d                   	pop    %ebp
  a9:	c3                   	ret    

000000aa <bmain>:
void readseg(uint32_t, uint32_t, uint32_t);

struct multiboot_info* mbi;

void
bmain(void) {
  aa:	55                   	push   %ebp
  ab:	89 e5                	mov    %esp,%ebp
  ad:	56                   	push   %esi
  ae:	53                   	push   %ebx
    struct elf* elf = (struct elf*) ELFHDR;

    readseg((uint32_t) elf, SECTSIZE << 3, SECTSIZE << 3);
  af:	68 00 10 00 00       	push   $0x1000
  b4:	68 00 10 00 00       	push   $0x1000
  b9:	68 00 00 01 00       	push   $0x10000
  be:	e8 fc ff ff ff       	call   bf <bmain+0x15>

    if (elf->magic != ELF_MAGIC) {
  c3:	83 c4 0c             	add    $0xc,%esp
  c6:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
  cd:	45 4c 46 
  d0:	74 1d                	je     ef <bmain+0x45>
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  d2:	ba 92 00 00 00       	mov    $0x92,%edx
  d7:	b0 03                	mov    $0x3,%al
  d9:	ee                   	out    %al,(%dx)
                 : "cc");
}

static inline void
outw(int port, uint16_t data) {
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  da:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  df:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  e4:	66 ef                	out    %ax,(%dx)
  e6:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
  eb:	66 ef                	out    %ax,(%dx)
  ed:	eb fe                	jmp    ed <bmain+0x43>
        outw(0x8A00, 0x8A00);
        outw(0x8A00, 0x8E00);
        for (;;);               // spin just in case
    }

    struct prog* p = (struct prog*)((uint8_t*) elf + elf->poffset);
  ef:	a1 1c 00 01 00       	mov    0x1001c,%eax
  f4:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    struct prog* ep = p + elf->nprogs;
  fa:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
 101:	c1 e6 05             	shl    $0x5,%esi
 104:	01 de                	add    %ebx,%esi
    for (; p < ep; p++)
 106:	39 f3                	cmp    %esi,%ebx
 108:	73 16                	jae    120 <bmain+0x76>
        readseg(p->pa, p->memsize, p->offset);
 10a:	ff 73 04             	pushl  0x4(%ebx)
 10d:	ff 73 14             	pushl  0x14(%ebx)
 110:	ff 73 0c             	pushl  0xc(%ebx)
 113:	e8 fc ff ff ff       	call   114 <bmain+0x6a>
        for (;;);               // spin just in case
    }

    struct prog* p = (struct prog*)((uint8_t*) elf + elf->poffset);
    struct prog* ep = p + elf->nprogs;
    for (; p < ep; p++)
 118:	83 c3 20             	add    $0x20,%ebx
 11b:	83 c4 0c             	add    $0xc,%esp
 11e:	eb e6                	jmp    106 <bmain+0x5c>
        readseg(p->pa, p->memsize, p->offset);

    mbi->flags = MB_MEM_MAP;
 120:	8b 15 00 00 00 00    	mov    0x0,%edx
 126:	c7 02 40 00 00 00    	movl   $0x40,(%edx)
    mbi->mmap_length = (uint32_t) mbi & (4096 - 1);
 12c:	89 d0                	mov    %edx,%eax
 12e:	25 ff 0f 00 00       	and    $0xfff,%eax
 133:	89 42 2c             	mov    %eax,0x2c(%edx)
    mbi->mmap_addr = (uint32_t) mbi - mbi->mmap_length;
 136:	89 d1                	mov    %edx,%ecx
 138:	29 c1                	sub    %eax,%ecx
 13a:	89 4a 30             	mov    %ecx,0x30(%edx)

    asm ("movl %0, %%eax;"
 13d:	b9 02 b0 ad 2b       	mov    $0x2badb002,%ecx
 142:	89 c8                	mov    %ecx,%eax
 144:	89 d3                	mov    %edx,%ebx
         "movl %1, %%ebx;"
         : : "r"(MB_EAX_MAGIC), "r"(mbi)
         : "eax", "ebx");

    ((void (*)(void)) (elf->entry))();
}
 146:	8d 65 f8             	lea    -0x8(%ebp),%esp
 149:	5b                   	pop    %ebx
 14a:	5e                   	pop    %esi
 14b:	5d                   	pop    %ebp
    asm ("movl %0, %%eax;"
         "movl %1, %%ebx;"
         : : "r"(MB_EAX_MAGIC), "r"(mbi)
         : "eax", "ebx");

    ((void (*)(void)) (elf->entry))();
 14c:	ff 25 18 00 01 00    	jmp    *0x10018
