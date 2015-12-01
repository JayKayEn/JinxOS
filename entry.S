#define BIT(n)   (1 << n)

#define CR0_PE      BIT(0)   // Protection Enabled
#define CR0_WP      BIT(16)  // Write Protect
#define CR0_PG      BIT(31)  // Paging Enabled

#define CR4_PSE     BIT(4)   // Page Size Extensions

#define PG_SIZE     BIT(12)  // Align to 4KB
#define STK_SIZE    BIT(15)  // 32KB = pow(2, 15) = 8 * 4KB

    .set MBOOT_HEADER,  0x1BADB002
    .set MBOOT_FLAGS,   0x00000002
    .set CHECHSUM,      -(MBOOT_HEADER + MBOOT_FLAGS)

    .text

    .align  4
    .long   MBOOT_HEADER
    .long   MBOOT_FLAGS
    .long   CHECHSUM

    .globl _start
_start = _entry
_entry:
    movw    $0x1234, 0x0472

    movl    $bpgd, %ecx
    movl    %ecx, %cr3

    movl    %cr4, %ecx
    orl     $CR4_PSE, %ecx
    movl    %ecx, %cr4

    movl    %cr0, %ecx
    orl     $(CR0_PE|CR0_PG|CR0_WP), %ecx
    movl    %ecx, %cr0

    mov     $vm, %ecx
    jmp     *%ecx
vm:
    movl    $0x0, %ebp
    movl    $ebstack,%esp

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
ebstack:
