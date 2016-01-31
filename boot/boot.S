    .set K_CS,      0x08           # kernel code segment selector
    .set K_DS,      0x10           # kernel data segment selector
    .set CR0_PE,    0x1            # protected mode enable flag
    .set SMAP,      0x534d4150     # "SMAP"
    .set MB_PA,     0x9000         # Multiboot info physical address

    .code16
    .globl start
start:
    cli
    cld

    xorw    %ax, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %ss

# # A20:
#     jmp a20
# wait:
#     inb     $0x64, %al          # Wait for not busy
#     testb   $0x2, %al
#     jnz     wait
#     ret
# a20:
#     call    wait
#     movb    $0xD1, %al          # 0xd1 -> port 0x64
#     outb    %al, $0x64
#     call    wait
#     movb    $0xDF, %al          # 0xdf -> port 0x60
#     outb    %al, $0x60

# Fast A20:
    inb     $0x92, %al
    orb     $0x2, %al
    outb    %al, $0x92

# E820:
e820:
    xorl    %ebx, %ebx          # clear ebx
    movw    $MB_PA, %di
e820.loop:
    movl    $0x14, (%di)        # Request 32 bytes
    addw    $0x4, %di             # bump to payload
    movl    $SMAP, %edx         # "SMAP"
    movl    $0xE820, %eax
    movw    $0x20, %cx          # ignore ACPI 3.0 extended attributes
    int     $0x15
    jc      e820.end            # none?
    cmpw    $0x14, %cx
    jg      e820.skip           # entry should have at least 20 byte
    addw    $0x14, %di            # continue to next entry
e820.skip:
    test    %ebx, %ebx
    jne     e820.loop           # done if ebx = 0
e820.end:
    mov     %edi, mbi         # store end pointer to mbi

# Enable Paging
    lgdt    gdtdesc
    movl    %cr0, %eax
    orl     $CR0_PE, %eax
    movl    %eax, %cr0

    movw    $K_DS, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movw    %ax, %ss

    ljmp    $K_CS, $protected

    .code32
protected:
    movl    $start, %esp
    call    bmain
spin:
    jmp     spin
    hlt

# puts:
#     pusha
#     movb    $0x0E, %ah
# puts.loop:
#     lodsb
#     cmp     $0x00, %al
#     je      puts.2
#     int     $0x10
#     jmp     puts.1
# puts.end:
#     popa
#     ret

# start_msg:
#     .ascii  "Start the jinx bootloader ...\r\n\0"
# error_msg:
#     .ascii  "Error: failed to load\r\n\0"

# Boot GDT
    .align 4
gdt:
    .quad 0
    .quad 0x00CF9A000000FFFF        # kernel CS
    .quad 0x00CF92000000FFFF        # kernel DS
gdtend:
gdtdesc:
    .word   gdtend - gdt
    .long   gdt
