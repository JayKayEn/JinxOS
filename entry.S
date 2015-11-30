#include <multiboot.h>
#include <mmu.h>
#include <memlayout.h>

.text

.align 4
.long 0x1BADB002                    // MULTIBOOT_HEADER_MAGIC
.long 0x00000002                    // MULTIBOOT_HEADER_FLAGS
.long -(0x1BADB002 + 0x00000002)    // CHECKSUM

.globl _start
_start = _entry
_entry:
    movw    $0x1234, 0x472

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
.align      (1 << 12)       // 4KB = pow(2, 12)

.globl      bstack
bstack:
.space      (1 << 12 << 3)  // 32KB = 8 * 4KB

.globl      ebstack
ebstack:
