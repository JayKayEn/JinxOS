#define BIT(n)   (1 << n)

#define PE  BIT(0)   // Protection Enabled
#define WP  BIT(16)  // Write Protect
#define PG  BIT(31)  // Paging Enabled

#define PSE BIT(4)   // Page Size Extensions

#define PADDR(x)    ((x) - KADDR)

#define PG_SIZE     BIT(12)  // Align to 4KB
#define STK_SIZE    BIT(15)  // 32KB = pow(2, 15) = 8 * 4KB

    .set KADDR,   0xC0000000

    .set MBOOT_MAGIC,   0x1BADB002
    .set MBOOT_FLAGS,   0x00000002
    .set CHECHSUM,      -(MBOOT_MAGIC + MBOOT_FLAGS)

    .text

    .align  4
    .long   MBOOT_MAGIC
    .long   MBOOT_FLAGS
    .long   CHECHSUM

    .globl _start
_start = PADDR(_entry)
_entry:
    movw    $0x1234, 0x0472

    movl    $(PADDR(bpgd)), %ecx
    movl    %ecx, %cr3

    movl    %cr4, %ecx
    orl     $PSE, %ecx
    movl    %ecx, %cr4

    movl    %cr0, %ecx
    orl     $(PE | PG | WP), %ecx
    movl    %ecx, %cr0

    mov     $vm, %ecx
    jmp     *%ecx
vm:
    movl    $0x0, %ebp
    movl    $ebstack, %esp

    pushl   %ebx
    pushl   %eax

    call    kmain
spin:
    jmp spin

    .data
    .align  PG_SIZE
    .globl  bstack
bstack:
    .space  STK_SIZE
    .globl  ebstack
ebstack:
