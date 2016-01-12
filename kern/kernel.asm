
kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <_text>:
    .long   CHECHSUM

    .globl _start
_start = PADDR(_entry)
_entry:
    movw    $0x1234, 0x0472
c0100000:	02 b0 ad 1b 02 00    	add    0x21bad(%eax),%dh
c0100006:	00 00                	add    %al,(%eax)
c0100008:	fc                   	cld    
c0100009:	4f                   	dec    %edi
c010000a:	52                   	push   %edx
c010000b:	e4 66                	in     $0x66,%al

c010000c <_entry>:
c010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
c0100013:	34 12 

    movl    $(PADDR(bpgd)), %ecx
c0100015:	b9 00 40 13 00       	mov    $0x134000,%ecx
    movl    %ecx, %cr3
c010001a:	0f 22 d9             	mov    %ecx,%cr3

    movl    %cr4, %ecx
c010001d:	0f 20 e1             	mov    %cr4,%ecx
    orl     $PSE, %ecx
c0100020:	83 c9 10             	or     $0x10,%ecx
    movl    %ecx, %cr4
c0100023:	0f 22 e1             	mov    %ecx,%cr4

    movl    %cr0, %ecx
c0100026:	0f 20 c1             	mov    %cr0,%ecx
    orl     $(PE | PG | WP), %ecx
c0100029:	81 c9 01 00 01 80    	or     $0x80010001,%ecx
    movl    %ecx, %cr0
c010002f:	0f 22 c1             	mov    %ecx,%cr0

    mov     $vm, %ecx
c0100032:	b9 39 00 10 c0       	mov    $0xc0100039,%ecx
    jmp     *%ecx
c0100037:	ff e1                	jmp    *%ecx

c0100039 <vm>:
vm:
    movl    $0x0, %ebp
c0100039:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl    $ebstack, %esp
c010003e:	bc 00 40 13 c0       	mov    $0xc0134000,%esp

    pushl   %ebx
c0100043:	53                   	push   %ebx
    pushl   %eax
c0100044:	50                   	push   %eax

    call    kmain
c0100045:	e8 40 09 00 00       	call   c010098a <kmain>

c010004a <spin>:
spin:
    jmp spin
c010004a:	eb fe                	jmp    c010004a <spin>

c010004c <gdt_flush>:

    .code32
    .global gdt_flush
    .extern gp
gdt_flush:
    lgdt    (gp)
c010004c:	0f 01 15 40 6e 13 c0 	lgdtl  0xc0136e40
    movw    $0x10, %ax
c0100053:	66 b8 10 00          	mov    $0x10,%ax
    movw    %ax ,%ds
c0100057:	8e d8                	mov    %eax,%ds
    movw    %ax ,%es
c0100059:	8e c0                	mov    %eax,%es
    movw    %ax ,%fs
c010005b:	8e e0                	mov    %eax,%fs
    movw    %ax ,%gs
c010005d:	8e e8                	mov    %eax,%gs
    movw    %ax ,%ss
c010005f:	8e d0                	mov    %eax,%ss
    ljmp    $0x08, $flush
c0100061:	ea 68 00 10 c0 08 00 	ljmp   $0x8,$0xc0100068

c0100068 <flush>:
flush:
    ret
c0100068:	c3                   	ret    

c0100069 <lidt>:

// lidt
    .global lidt
    .extern idtp
lidt:
    lidt (idtp)
c0100069:	0f 01 1d 8c 6e 13 c0 	lidtl  0xc0136e8c
    ret
c0100070:	c3                   	ret    
c0100071:	90                   	nop

c0100072 <isr0>:
//  0: Divide By Zero
    .global isr0
    .type isr0, @function
    .align 2
isr0:
    cli
c0100072:	fa                   	cli    
    pushl $0x0
c0100073:	6a 00                	push   $0x0
    pushl $0x0
c0100075:	6a 00                	push   $0x0
    jmp isr_common_stub
c0100077:	e9 83 00 00 00       	jmp    c01000ff <isr_common_stub>

c010007c <isr1>:
//  1: Debug
    .global isr1
    .type isr1, @function
    .align 2
isr1:
    cli
c010007c:	fa                   	cli    
    pushl $0x0
c010007d:	6a 00                	push   $0x0
    pushl $0x1
c010007f:	6a 01                	push   $0x1
    jmp isr_common_stub
c0100081:	eb 7c                	jmp    c01000ff <isr_common_stub>
c0100083:	90                   	nop

c0100084 <isr2>:
//  2: Non Maskable Interrupt
    .global isr2
    .type isr2, @function
    .align 2
isr2:
    cli
c0100084:	fa                   	cli    
    pushl $0x0
c0100085:	6a 00                	push   $0x0
    pushl $0x2
c0100087:	6a 02                	push   $0x2
    jmp isr_common_stub
c0100089:	eb 74                	jmp    c01000ff <isr_common_stub>
c010008b:	90                   	nop

c010008c <isr3>:
//  3: Int 3
    .global isr3
    .type isr3, @function
    .align 2
isr3:
    cli
c010008c:	fa                   	cli    
    pushl $0x0
c010008d:	6a 00                	push   $0x0
    pushl $0x3
c010008f:	6a 03                	push   $0x3
    jmp isr_common_stub
c0100091:	eb 6c                	jmp    c01000ff <isr_common_stub>
c0100093:	90                   	nop

c0100094 <isr4>:
//  4: INTO
    .global isr4
    .type isr4, @function
    .align 2
isr4:
    cli
c0100094:	fa                   	cli    
    pushl $0x0
c0100095:	6a 00                	push   $0x0
    pushl $0x4
c0100097:	6a 04                	push   $0x4
    jmp isr_common_stub
c0100099:	eb 64                	jmp    c01000ff <isr_common_stub>
c010009b:	90                   	nop

c010009c <isr5>:
//  5: Out of Bounds
    .global isr5
    .type isr5, @function
    .align 2
isr5:
    cli
c010009c:	fa                   	cli    
    pushl $0x0
c010009d:	6a 00                	push   $0x0
    pushl $0x5
c010009f:	6a 05                	push   $0x5
    jmp isr_common_stub
c01000a1:	eb 5c                	jmp    c01000ff <isr_common_stub>
c01000a3:	90                   	nop

c01000a4 <isr6>:
//  6: Invalid Opcode
    .global isr6
    .type isr6, @function
    .align 2
isr6:
    cli
c01000a4:	fa                   	cli    
    pushl $0x0
c01000a5:	6a 00                	push   $0x0
    pushl $0x6
c01000a7:	6a 06                	push   $0x6
    jmp isr_common_stub
c01000a9:	eb 54                	jmp    c01000ff <isr_common_stub>
c01000ab:	90                   	nop

c01000ac <isr7>:
//  7: Coprocessor Not Available
    .global isr7
    .type isr7, @function
    .align 2
isr7:
    cli
c01000ac:	fa                   	cli    
    pushl $0x0
c01000ad:	6a 00                	push   $0x0
    pushl $0x7
c01000af:	6a 07                	push   $0x7
    jmp isr_common_stub
c01000b1:	eb 4c                	jmp    c01000ff <isr_common_stub>
c01000b3:	90                   	nop

c01000b4 <isr8>:
//  8: Double Fault
    .global isr8
    .type isr8, @function
    .align 2
isr8:
    cli
c01000b4:	fa                   	cli    
    pushl $0x8
c01000b5:	6a 08                	push   $0x8
    jmp isr_common_stub
c01000b7:	eb 46                	jmp    c01000ff <isr_common_stub>
c01000b9:	90                   	nop

c01000ba <isr10>:
// 10: Bad TSS
    .global isr10
    .type isr10, @function
    .align 2
isr10:
    cli
c01000ba:	fa                   	cli    
    pushl $0xA
c01000bb:	6a 0a                	push   $0xa
    jmp isr_common_stub
c01000bd:	eb 40                	jmp    c01000ff <isr_common_stub>
c01000bf:	90                   	nop

c01000c0 <isr11>:
// 11: Segment Not Present
    .global isr11
    .type isr11, @function
    .align 2
isr11:
    cli
c01000c0:	fa                   	cli    
    pushl $0xB
c01000c1:	6a 0b                	push   $0xb
    jmp isr_common_stub
c01000c3:	eb 3a                	jmp    c01000ff <isr_common_stub>
c01000c5:	90                   	nop

c01000c6 <isr12>:
// 12: Stack Fault
    .global isr12
    .type isr12, @function
    .align 2
isr12:
    cli
c01000c6:	fa                   	cli    
    pushl $0xC
c01000c7:	6a 0c                	push   $0xc
    jmp isr_common_stub
c01000c9:	eb 34                	jmp    c01000ff <isr_common_stub>
c01000cb:	90                   	nop

c01000cc <isr13>:
// 13: General Protection Fault
    .global isr13
    .type isr13, @function
    .align 2
isr13:
    cli
c01000cc:	fa                   	cli    
    pushl $0xD
c01000cd:	6a 0d                	push   $0xd
    jmp isr_common_stub
c01000cf:	eb 2e                	jmp    c01000ff <isr_common_stub>
c01000d1:	90                   	nop

c01000d2 <isr14>:
// 14: Page Fault
    .global isr14
    .type isr14, @function
    .align 2
isr14:
    cli
c01000d2:	fa                   	cli    
    pushl $0xE
c01000d3:	6a 0e                	push   $0xe
    jmp isr_common_stub
c01000d5:	eb 28                	jmp    c01000ff <isr_common_stub>
c01000d7:	90                   	nop

c01000d8 <isr16>:
// 16: Floating Point
    .global isr16
    .type isr16, @function
    .align 2
isr16:
    cli
c01000d8:	fa                   	cli    
    pushl $0x0
c01000d9:	6a 00                	push   $0x0
    pushl $0x10
c01000db:	6a 10                	push   $0x10
    jmp isr_common_stub
c01000dd:	eb 20                	jmp    c01000ff <isr_common_stub>
c01000df:	90                   	nop

c01000e0 <isr17>:
// 17: Alignment Check
    .global isr17
    .type isr17, @function
    .align 2
isr17:
    cli
c01000e0:	fa                   	cli    
    pushl $0x0
c01000e1:	6a 00                	push   $0x0
    pushl $0x11
c01000e3:	6a 11                	push   $0x11
    jmp isr_common_stub
c01000e5:	eb 18                	jmp    c01000ff <isr_common_stub>
c01000e7:	90                   	nop

c01000e8 <isr18>:
// 18: Machine Check
    .global isr18
    .type isr18, @function
    .align 2
isr18:
    cli
c01000e8:	fa                   	cli    
    pushl $0x0
c01000e9:	6a 00                	push   $0x0
    pushl $0x12
c01000eb:	6a 12                	push   $0x12
    jmp isr_common_stub
c01000ed:	eb 10                	jmp    c01000ff <isr_common_stub>
c01000ef:	90                   	nop

c01000f0 <isr19>:
// 19: Reserved
    .global isr19
    .type isr19, @function
    .align 2
isr19:
    cli
c01000f0:	fa                   	cli    
    pushl $0x0
c01000f1:	6a 00                	push   $0x0
    pushl $0x13
c01000f3:	6a 13                	push   $0x13
    jmp isr_common_stub
c01000f5:	eb 08                	jmp    c01000ff <isr_common_stub>
c01000f7:	90                   	nop

c01000f8 <isr48>:
// 48: System Call
    .global isr48
    .type isr48, @function
    .align 2
isr48:
    cli
c01000f8:	fa                   	cli    
    pushl $0x0
c01000f9:	6a 00                	push   $0x0
    pushl $0x30
c01000fb:	6a 30                	push   $0x30
    jmp isr_common_stub
c01000fd:	eb 00                	jmp    c01000ff <isr_common_stub>

c01000ff <isr_common_stub>:

    .extern isr_handler
isr_common_stub:
    pushal
c01000ff:	60                   	pusha  
    pushl   %ds
c0100100:	1e                   	push   %ds
    pushl   %es
c0100101:	06                   	push   %es

    movw    $0x10, %ax
c0100102:	66 b8 10 00          	mov    $0x10,%ax
    movw    %ax, %ds
c0100106:	8e d8                	mov    %eax,%ds
    movw    %ax, %es
c0100108:	8e c0                	mov    %eax,%es

    pushl   %esp
c010010a:	54                   	push   %esp
    call    isr_handler
c010010b:	e8 76 03 00 00       	call   c0100486 <isr_handler>
    popl    %esp
c0100110:	5c                   	pop    %esp

    popl    %es
c0100111:	07                   	pop    %es
    popl    %ds
c0100112:	1f                   	pop    %ds
    popal
c0100113:	61                   	popa   

    addl     $0x8, %esp
c0100114:	83 c4 08             	add    $0x8,%esp
    iret
c0100117:	cf                   	iret   

c0100118 <irq0>:

// 32: IRQ0
    .global irq0
irq0:
    cli
c0100118:	fa                   	cli    
    pushl $0x0
c0100119:	6a 00                	push   $0x0
    pushl $0x20
c010011b:	6a 20                	push   $0x20
    jmp irq_common_stub
c010011d:	eb 69                	jmp    c0100188 <irq_common_stub>

c010011f <irq1>:

// 33: IRQ1
    .global irq1
irq1:
    cli
c010011f:	fa                   	cli    
    pushl $0x0
c0100120:	6a 00                	push   $0x0
    pushl $0x21
c0100122:	6a 21                	push   $0x21
    jmp irq_common_stub
c0100124:	eb 62                	jmp    c0100188 <irq_common_stub>

c0100126 <irq2>:

// 34: IRQ2
    .global irq2
irq2:
    cli
c0100126:	fa                   	cli    
    pushl $0x0
c0100127:	6a 00                	push   $0x0
    pushl $0x22
c0100129:	6a 22                	push   $0x22
    jmp irq_common_stub
c010012b:	eb 5b                	jmp    c0100188 <irq_common_stub>

c010012d <irq3>:

// 35: IRQ3
    .global irq3
irq3:
    cli
c010012d:	fa                   	cli    
    pushl $0x0
c010012e:	6a 00                	push   $0x0
    pushl $0x23
c0100130:	6a 23                	push   $0x23
    jmp irq_common_stub
c0100132:	eb 54                	jmp    c0100188 <irq_common_stub>

c0100134 <irq4>:

// 36: IRQ4
    .global irq4
irq4:
    cli
c0100134:	fa                   	cli    
    pushl $0x0
c0100135:	6a 00                	push   $0x0
    pushl $0x24
c0100137:	6a 24                	push   $0x24
    jmp irq_common_stub
c0100139:	eb 4d                	jmp    c0100188 <irq_common_stub>

c010013b <irq5>:

// 37: IRQ5
    .global irq5
irq5:
    cli
c010013b:	fa                   	cli    
    pushl $0x0
c010013c:	6a 00                	push   $0x0
    pushl $0x25
c010013e:	6a 25                	push   $0x25
    jmp irq_common_stub
c0100140:	eb 46                	jmp    c0100188 <irq_common_stub>

c0100142 <irq6>:

// 38: IRQ6
    .global irq6
irq6:
    cli
c0100142:	fa                   	cli    
    pushl $0x0
c0100143:	6a 00                	push   $0x0
    pushl $0x26
c0100145:	6a 26                	push   $0x26
    jmp irq_common_stub
c0100147:	eb 3f                	jmp    c0100188 <irq_common_stub>

c0100149 <irq7>:

// 39: IRQ7
    .global irq7
irq7:
    cli
c0100149:	fa                   	cli    
    pushl $0x0
c010014a:	6a 00                	push   $0x0
    pushl $0x27
c010014c:	6a 27                	push   $0x27
    jmp irq_common_stub
c010014e:	eb 38                	jmp    c0100188 <irq_common_stub>

c0100150 <irq8>:

// 40: IRQ8
    .global irq8
irq8:
    cli
c0100150:	fa                   	cli    
    pushl $0x0
c0100151:	6a 00                	push   $0x0
    pushl $0x28
c0100153:	6a 28                	push   $0x28
    jmp irq_common_stub
c0100155:	eb 31                	jmp    c0100188 <irq_common_stub>

c0100157 <irq9>:

// 41: IRQ9
    .global irq9
irq9:
    cli
c0100157:	fa                   	cli    
    pushl $0x0
c0100158:	6a 00                	push   $0x0
    pushl $0x29
c010015a:	6a 29                	push   $0x29
    jmp irq_common_stub
c010015c:	eb 2a                	jmp    c0100188 <irq_common_stub>

c010015e <irq10>:

// 42: IRQ10
    .global irq10
irq10:
    cli
c010015e:	fa                   	cli    
    pushl $0x0
c010015f:	6a 00                	push   $0x0
    pushl $0x2A
c0100161:	6a 2a                	push   $0x2a
    jmp irq_common_stub
c0100163:	eb 23                	jmp    c0100188 <irq_common_stub>

c0100165 <irq11>:

// 43: IRQ11
    .global irq11
irq11:
    cli
c0100165:	fa                   	cli    
    pushl $0x0
c0100166:	6a 00                	push   $0x0
    pushl $0x2B
c0100168:	6a 2b                	push   $0x2b
    jmp irq_common_stub
c010016a:	eb 1c                	jmp    c0100188 <irq_common_stub>

c010016c <irq12>:

// 44: IRQ12
    .global irq12
irq12:
    cli
c010016c:	fa                   	cli    
    pushl $0x0
c010016d:	6a 00                	push   $0x0
    pushl $0x2C
c010016f:	6a 2c                	push   $0x2c
    jmp irq_common_stub
c0100171:	eb 15                	jmp    c0100188 <irq_common_stub>

c0100173 <irq13>:

// 45: IRQ13
    .global irq13
irq13:
    cli
c0100173:	fa                   	cli    
    pushl $0x0
c0100174:	6a 00                	push   $0x0
    pushl $0x2D
c0100176:	6a 2d                	push   $0x2d
    jmp irq_common_stub
c0100178:	eb 0e                	jmp    c0100188 <irq_common_stub>

c010017a <irq14>:

// 46: IRQ14
    .global irq14
irq14:
    cli
c010017a:	fa                   	cli    
    pushl $0x0
c010017b:	6a 00                	push   $0x0
    pushl $0x2E
c010017d:	6a 2e                	push   $0x2e
    jmp irq_common_stub
c010017f:	eb 07                	jmp    c0100188 <irq_common_stub>

c0100181 <irq15>:

// 47: IRQ15
    .global irq15
irq15:
    cli
c0100181:	fa                   	cli    
    pushl $0x0
c0100182:	6a 00                	push   $0x0
    pushl $0x2F
c0100184:	6a 2f                	push   $0x2f
    jmp irq_common_stub
c0100186:	eb 00                	jmp    c0100188 <irq_common_stub>

c0100188 <irq_common_stub>:

    .extern irq_handler
irq_common_stub:
    pushal
c0100188:	60                   	pusha  
    pushl   %ds
c0100189:	1e                   	push   %ds
    pushl   %es
c010018a:	06                   	push   %es

    movw    $0x10, %ax
c010018b:	66 b8 10 00          	mov    $0x10,%ax
    movw    %ax, %ds
c010018f:	8e d8                	mov    %eax,%ds
    movw    %ax, %es
c0100191:	8e c0                	mov    %eax,%es

    pushl   %esp
c0100193:	54                   	push   %esp
    call    irq_handler
c0100194:	e8 d0 06 00 00       	call   c0100869 <irq_handler>
    popl    %esp
c0100199:	5c                   	pop    %esp

    popl    %es
c010019a:	07                   	pop    %es
    popl    %ds
c010019b:	1f                   	pop    %ds
    popal
c010019c:	61                   	popa   

    addl     $0x8, %esp
c010019d:	83 c4 08             	add    $0x8,%esp
    iret
c01001a0:	cf                   	iret   

c01001a1 <gdt_set_gate>:
 *  | G | D | 0 | A | SegLen |  SegLen - 0xF
 *  +------------------------+
 *
 */
void gdt_set_gate(uint8_t num, uint32_t base, uint32_t limit, uint8_t access,
                  uint8_t gran) {
c01001a1:	55                   	push   %ebp
c01001a2:	89 e5                	mov    %esp,%ebp
c01001a4:	53                   	push   %ebx
c01001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01001a8:	8b 55 10             	mov    0x10(%ebp),%edx
    /* Setup the descriptor base address */
    gdt[num].base_lo = (base & 0xFFFF);
c01001ab:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
c01001af:	66 89 0c c5 62 6e 13 	mov    %cx,-0x3fec919e(,%eax,8)
c01001b6:	c0 
    gdt[num].base_md = (base >> 16) & 0xFF;
c01001b7:	89 cb                	mov    %ecx,%ebx
c01001b9:	c1 eb 10             	shr    $0x10,%ebx
c01001bc:	88 1c c5 64 6e 13 c0 	mov    %bl,-0x3fec919c(,%eax,8)
    gdt[num].base_hi = (base >> 24) & 0xFF;
c01001c3:	c1 e9 18             	shr    $0x18,%ecx
c01001c6:	88 0c c5 67 6e 13 c0 	mov    %cl,-0x3fec9199(,%eax,8)

    /* Setup the descriptor limits */
    gdt[num].limit_lo = (limit & 0xFFFF);
c01001cd:	66 89 14 c5 60 6e 13 	mov    %dx,-0x3fec91a0(,%eax,8)
c01001d4:	c0 
    gdt[num].granularity = ((limit >> 16) & 0x0F);

    /* Finally, set up the granularity and access flags */
    gdt[num].granularity |= (gran & 0xF0);
c01001d5:	c1 ea 10             	shr    $0x10,%edx
c01001d8:	83 e2 0f             	and    $0xf,%edx
c01001db:	8a 4d 18             	mov    0x18(%ebp),%cl
c01001de:	83 e1 f0             	and    $0xfffffff0,%ecx
c01001e1:	09 ca                	or     %ecx,%edx
c01001e3:	88 14 c5 66 6e 13 c0 	mov    %dl,-0x3fec919a(,%eax,8)
    gdt[num].access = access;
c01001ea:	8b 55 14             	mov    0x14(%ebp),%edx
c01001ed:	88 14 c5 65 6e 13 c0 	mov    %dl,-0x3fec919b(,%eax,8)
}
c01001f4:	5b                   	pop    %ebx
c01001f5:	5d                   	pop    %ebp
c01001f6:	c3                   	ret    

c01001f7 <init_gdt>:
    GDT_UDATA,
};

struct gdt_ptr gp;

void init_gdt(void) {
c01001f7:	55                   	push   %ebp
c01001f8:	89 e5                	mov    %esp,%ebp
c01001fa:	83 ec 08             	sub    $0x8,%esp
    gp.limit = (sizeof(struct gdt_entry) * GDT_ENTRIES) - 1;
c01001fd:	66 c7 05 40 6e 13 c0 	movw   $0x27,0xc0136e40
c0100204:	27 00 
    gp.base = (uint32_t) &gdt;
c0100206:	c7 05 42 6e 13 c0 60 	movl   $0xc0136e60,0xc0136e42
c010020d:	6e 13 c0 

    gdt_set_gate(GDT_NULL,  0, 0x00000000, 0x00, 0x00);
c0100210:	6a 00                	push   $0x0
c0100212:	6a 00                	push   $0x0
c0100214:	6a 00                	push   $0x0
c0100216:	6a 00                	push   $0x0
c0100218:	6a 00                	push   $0x0
c010021a:	e8 82 ff ff ff       	call   c01001a1 <gdt_set_gate>
    gdt_set_gate(GDT_KCODE, 0, 0xFFFFFFFF, 0x9A, 0xCF);
c010021f:	68 cf 00 00 00       	push   $0xcf
c0100224:	68 9a 00 00 00       	push   $0x9a
c0100229:	6a ff                	push   $0xffffffff
c010022b:	6a 00                	push   $0x0
c010022d:	6a 01                	push   $0x1
c010022f:	e8 6d ff ff ff       	call   c01001a1 <gdt_set_gate>
    gdt_set_gate(GDT_KDATA, 0, 0xFFFFFFFF, 0x92, 0xCF);
c0100234:	83 c4 28             	add    $0x28,%esp
c0100237:	68 cf 00 00 00       	push   $0xcf
c010023c:	68 92 00 00 00       	push   $0x92
c0100241:	6a ff                	push   $0xffffffff
c0100243:	6a 00                	push   $0x0
c0100245:	6a 02                	push   $0x2
c0100247:	e8 55 ff ff ff       	call   c01001a1 <gdt_set_gate>
    gdt_set_gate(GDT_UCODE, 0, 0xBFFFFFFF, 0xFA, 0xCF);
c010024c:	68 cf 00 00 00       	push   $0xcf
c0100251:	68 fa 00 00 00       	push   $0xfa
c0100256:	68 ff ff ff bf       	push   $0xbfffffff
c010025b:	6a 00                	push   $0x0
c010025d:	6a 03                	push   $0x3
c010025f:	e8 3d ff ff ff       	call   c01001a1 <gdt_set_gate>
    gdt_set_gate(GDT_UDATA, 0, 0xBFFFFFFF, 0xF2, 0xCF);
c0100264:	83 c4 28             	add    $0x28,%esp
c0100267:	68 cf 00 00 00       	push   $0xcf
c010026c:	68 f2 00 00 00       	push   $0xf2
c0100271:	68 ff ff ff bf       	push   $0xbfffffff
c0100276:	6a 00                	push   $0x0
c0100278:	6a 04                	push   $0x4
c010027a:	e8 22 ff ff ff       	call   c01001a1 <gdt_set_gate>

    gdt_flush();    // asm.c
c010027f:	83 c4 14             	add    $0x14,%esp
}
c0100282:	c9                   	leave  
    gdt_set_gate(GDT_KCODE, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    gdt_set_gate(GDT_KDATA, 0, 0xFFFFFFFF, 0x92, 0xCF);
    gdt_set_gate(GDT_UCODE, 0, 0xBFFFFFFF, 0xFA, 0xCF);
    gdt_set_gate(GDT_UDATA, 0, 0xBFFFFFFF, 0xF2, 0xCF);

    gdt_flush();    // asm.c
c0100283:	e9 c4 fd ff ff       	jmp    c010004c <gdt_flush>

c0100288 <idt_set_gate>:
/* This exists in 'start.asm', and is used to load our IDT */
extern void lidt(void);

/* Use this function to set an entry in the IDT. Alot simpler
*  than twiddling with the GDT ;) */
void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
c0100288:	55                   	push   %ebp
c0100289:	89 e5                	mov    %esp,%ebp
c010028b:	8b 55 0c             	mov    0xc(%ebp),%edx
    /* The interrupt routine's base address */
    idt[num].base_lo = (base & 0xFFFF);
c010028e:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
c0100292:	66 89 14 c5 00 60 13 	mov    %dx,-0x3feca000(,%eax,8)
c0100299:	c0 
    idt[num].base_hi = (base >> 16);
c010029a:	c1 ea 10             	shr    $0x10,%edx
c010029d:	66 89 14 c5 06 60 13 	mov    %dx,-0x3fec9ffa(,%eax,8)
c01002a4:	c0 

    /* The segment or 'selector' that this IDT entry will use
    *  is set here, along with any access flags */
    idt[num].sel = sel;
c01002a5:	8b 55 10             	mov    0x10(%ebp),%edx
c01002a8:	66 89 14 c5 02 60 13 	mov    %dx,-0x3fec9ffe(,%eax,8)
c01002af:	c0 
    idt[num].zero = 0;
c01002b0:	c6 04 c5 04 60 13 c0 	movb   $0x0,-0x3fec9ffc(,%eax,8)
c01002b7:	00 
    idt[num].flags = flags;
c01002b8:	8b 55 14             	mov    0x14(%ebp),%edx
c01002bb:	88 14 c5 05 60 13 c0 	mov    %dl,-0x3fec9ffb(,%eax,8)
}
c01002c2:	5d                   	pop    %ebp
c01002c3:	c3                   	ret    

c01002c4 <init_idt>:

/* Installs the IDT */
void init_idt(void) {
c01002c4:	55                   	push   %ebp
c01002c5:	89 e5                	mov    %esp,%ebp
c01002c7:	83 ec 0c             	sub    $0xc,%esp
    /* Sets the special IDT pointer up, just like in 'gdt.c' */
    idtp.limit = (sizeof(struct idt_entry) * IDT_ENTRIES) - 1;
c01002ca:	66 c7 05 8c 6e 13 c0 	movw   $0x7ff,0xc0136e8c
c01002d1:	ff 07 
    idtp.base = (uint32_t) &idt;
c01002d3:	c7 05 8e 6e 13 c0 00 	movl   $0xc0136000,0xc0136e8e
c01002da:	60 13 c0 

    /* Clear out the entire IDT, initializing it to zeros */
    memset(&idt, 0, sizeof(struct idt_entry) * IDT_ENTRIES);
c01002dd:	68 00 08 00 00       	push   $0x800
c01002e2:	6a 00                	push   $0x0
c01002e4:	68 00 60 13 c0       	push   $0xc0136000
c01002e9:	e8 ce 41 00 00       	call   c01044bc <memset>
    lidt();
c01002ee:	83 c4 10             	add    $0x10,%esp
}
c01002f1:	c9                   	leave  
    idtp.limit = (sizeof(struct idt_entry) * IDT_ENTRIES) - 1;
    idtp.base = (uint32_t) &idt;

    /* Clear out the entire IDT, initializing it to zeros */
    memset(&idt, 0, sizeof(struct idt_entry) * IDT_ENTRIES);
    lidt();
c01002f2:	e9 72 fd ff ff       	jmp    c0100069 <lidt>

c01002f7 <init_isr>:
*  that correspond to that given entry. We set the access
*  flags to 0x8E. This means that the entry is present, is
*  running in ring 0 (kernel level), and has the lower 5 bits
*  set to the required '14', which is represented by 'E' in
*  hex. */
void init_isr(void) {
c01002f7:	55                   	push   %ebp
c01002f8:	89 e5                	mov    %esp,%ebp
c01002fa:	83 ec 08             	sub    $0x8,%esp
    idt_set_gate( 0, (unsigned)  isr0, 0x08, 0x8F);
c01002fd:	68 8f 00 00 00       	push   $0x8f
c0100302:	6a 08                	push   $0x8
c0100304:	68 72 00 10 c0       	push   $0xc0100072
c0100309:	6a 00                	push   $0x0
c010030b:	e8 78 ff ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 1, (unsigned)  isr1, 0x08, 0x8F);
c0100310:	68 8f 00 00 00       	push   $0x8f
c0100315:	6a 08                	push   $0x8
c0100317:	68 7c 00 10 c0       	push   $0xc010007c
c010031c:	6a 01                	push   $0x1
c010031e:	e8 65 ff ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 2, (unsigned)  isr2, 0x08, 0x8F);
c0100323:	83 c4 20             	add    $0x20,%esp
c0100326:	68 8f 00 00 00       	push   $0x8f
c010032b:	6a 08                	push   $0x8
c010032d:	68 84 00 10 c0       	push   $0xc0100084
c0100332:	6a 02                	push   $0x2
c0100334:	e8 4f ff ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 3, (unsigned)  isr3, 0x08, 0x8F);
c0100339:	68 8f 00 00 00       	push   $0x8f
c010033e:	6a 08                	push   $0x8
c0100340:	68 8c 00 10 c0       	push   $0xc010008c
c0100345:	6a 03                	push   $0x3
c0100347:	e8 3c ff ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 4, (unsigned)  isr4, 0x08, 0x8F);
c010034c:	83 c4 20             	add    $0x20,%esp
c010034f:	68 8f 00 00 00       	push   $0x8f
c0100354:	6a 08                	push   $0x8
c0100356:	68 94 00 10 c0       	push   $0xc0100094
c010035b:	6a 04                	push   $0x4
c010035d:	e8 26 ff ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 5, (unsigned)  isr5, 0x08, 0x8F);
c0100362:	68 8f 00 00 00       	push   $0x8f
c0100367:	6a 08                	push   $0x8
c0100369:	68 9c 00 10 c0       	push   $0xc010009c
c010036e:	6a 05                	push   $0x5
c0100370:	e8 13 ff ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 6, (unsigned)  isr6, 0x08, 0x8F);
c0100375:	83 c4 20             	add    $0x20,%esp
c0100378:	68 8f 00 00 00       	push   $0x8f
c010037d:	6a 08                	push   $0x8
c010037f:	68 a4 00 10 c0       	push   $0xc01000a4
c0100384:	6a 06                	push   $0x6
c0100386:	e8 fd fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate( 7, (unsigned)  isr7, 0x08, 0x8F);
c010038b:	68 8f 00 00 00       	push   $0x8f
c0100390:	6a 08                	push   $0x8
c0100392:	68 ac 00 10 c0       	push   $0xc01000ac
c0100397:	6a 07                	push   $0x7
c0100399:	e8 ea fe ff ff       	call   c0100288 <idt_set_gate>

    idt_set_gate( 8, (unsigned)  isr8, 0x08, 0x8F);
c010039e:	83 c4 20             	add    $0x20,%esp
c01003a1:	68 8f 00 00 00       	push   $0x8f
c01003a6:	6a 08                	push   $0x8
c01003a8:	68 b4 00 10 c0       	push   $0xc01000b4
c01003ad:	6a 08                	push   $0x8
c01003af:	e8 d4 fe ff ff       	call   c0100288 <idt_set_gate>
    // idt_set_gate( 9, (unsigned)  isr9, 0x08, 0x8F);
    idt_set_gate(10, (unsigned) isr10, 0x08, 0x8F);
c01003b4:	68 8f 00 00 00       	push   $0x8f
c01003b9:	6a 08                	push   $0x8
c01003bb:	68 ba 00 10 c0       	push   $0xc01000ba
c01003c0:	6a 0a                	push   $0xa
c01003c2:	e8 c1 fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(11, (unsigned) isr11, 0x08, 0x8F);
c01003c7:	83 c4 20             	add    $0x20,%esp
c01003ca:	68 8f 00 00 00       	push   $0x8f
c01003cf:	6a 08                	push   $0x8
c01003d1:	68 c0 00 10 c0       	push   $0xc01000c0
c01003d6:	6a 0b                	push   $0xb
c01003d8:	e8 ab fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(12, (unsigned) isr12, 0x08, 0x8F);
c01003dd:	68 8f 00 00 00       	push   $0x8f
c01003e2:	6a 08                	push   $0x8
c01003e4:	68 c6 00 10 c0       	push   $0xc01000c6
c01003e9:	6a 0c                	push   $0xc
c01003eb:	e8 98 fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(13, (unsigned) isr13, 0x08, 0x8F);
c01003f0:	83 c4 20             	add    $0x20,%esp
c01003f3:	68 8f 00 00 00       	push   $0x8f
c01003f8:	6a 08                	push   $0x8
c01003fa:	68 cc 00 10 c0       	push   $0xc01000cc
c01003ff:	6a 0d                	push   $0xd
c0100401:	e8 82 fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(14, (unsigned) isr14, 0x08, 0x8F);
c0100406:	68 8f 00 00 00       	push   $0x8f
c010040b:	6a 08                	push   $0x8
c010040d:	68 d2 00 10 c0       	push   $0xc01000d2
c0100412:	6a 0e                	push   $0xe
c0100414:	e8 6f fe ff ff       	call   c0100288 <idt_set_gate>
    // idt_set_gate(15, (unsigned) isr15, 0x08, 0x8F);

    idt_set_gate(16, (unsigned) isr16, 0x08, 0x8F);
c0100419:	83 c4 20             	add    $0x20,%esp
c010041c:	68 8f 00 00 00       	push   $0x8f
c0100421:	6a 08                	push   $0x8
c0100423:	68 d8 00 10 c0       	push   $0xc01000d8
c0100428:	6a 10                	push   $0x10
c010042a:	e8 59 fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(17, (unsigned) isr17, 0x08, 0x8F);
c010042f:	68 8f 00 00 00       	push   $0x8f
c0100434:	6a 08                	push   $0x8
c0100436:	68 e0 00 10 c0       	push   $0xc01000e0
c010043b:	6a 11                	push   $0x11
c010043d:	e8 46 fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(18, (unsigned) isr18, 0x08, 0x8F);
c0100442:	83 c4 20             	add    $0x20,%esp
c0100445:	68 8f 00 00 00       	push   $0x8f
c010044a:	6a 08                	push   $0x8
c010044c:	68 e8 00 10 c0       	push   $0xc01000e8
c0100451:	6a 12                	push   $0x12
c0100453:	e8 30 fe ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(19, (unsigned) isr19, 0x08, 0x8F);
c0100458:	68 8f 00 00 00       	push   $0x8f
c010045d:	6a 08                	push   $0x8
c010045f:	68 f0 00 10 c0       	push   $0xc01000f0
c0100464:	6a 13                	push   $0x13
c0100466:	e8 1d fe ff ff       	call   c0100288 <idt_set_gate>
    // idt_set_gate(28, (unsigned) isr28, 0x08, 0x8F);
    // idt_set_gate(29, (unsigned) isr29, 0x08, 0x8F);
    // idt_set_gate(30, (unsigned) isr30, 0x08, 0x8F);
    // idt_set_gate(31, (unsigned) isr31, 0x08, 0x8F);

    idt_set_gate(48, (unsigned) isr48, 0x08, 0x8E);
c010046b:	83 c4 20             	add    $0x20,%esp
c010046e:	68 8e 00 00 00       	push   $0x8e
c0100473:	6a 08                	push   $0x8
c0100475:	68 f8 00 10 c0       	push   $0xc01000f8
c010047a:	6a 30                	push   $0x30
c010047c:	e8 07 fe ff ff       	call   c0100288 <idt_set_gate>
}
c0100481:	83 c4 10             	add    $0x10,%esp
c0100484:	c9                   	leave  
c0100485:	c3                   	ret    

c0100486 <isr_handler>:
    "Reserved",
    "Reserved",
    "Reserved"
};

void isr_handler(struct regs* r) {
c0100486:	55                   	push   %ebp
c0100487:	89 e5                	mov    %esp,%ebp
c0100489:	53                   	push   %ebx
c010048a:	53                   	push   %ebx
c010048b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(r != NULL);
c010048e:	85 db                	test   %ebx,%ebx
c0100490:	75 2b                	jne    c01004bd <isr_handler+0x37>
c0100492:	83 ec 0c             	sub    $0xc,%esp
c0100495:	68 cc ab 10 c0       	push   $0xc010abcc
c010049a:	68 8c 00 00 00       	push   $0x8c
c010049f:	68 80 a9 10 c0       	push   $0xc010a980
c01004a4:	68 8b a9 10 c0       	push   $0xc010a98b
c01004a9:	68 95 a9 10 c0       	push   $0xc010a995
c01004ae:	e8 11 39 00 00       	call   c0103dc4 <print>
c01004b3:	83 c4 20             	add    $0x20,%esp
c01004b6:	e8 8f 09 00 00       	call   c0100e4a <backtrace>
c01004bb:	fa                   	cli    
c01004bc:	f4                   	hlt    

    switch (r->int_no) {
c01004bd:	83 7b 28 30          	cmpl   $0x30,0x28(%ebx)
c01004c1:	75 53                	jne    c0100516 <isr_handler+0x90>
        case ISR_SYSCALL: {
            if (thiscpu && thisthread)
c01004c3:	e8 7a 20 00 00       	call   c0102542 <cpunum>
c01004c8:	83 3c 85 a0 6e 13 c0 	cmpl   $0x0,-0x3fec9160(,%eax,4)
c01004cf:	00 
c01004d0:	74 23                	je     c01004f5 <isr_handler+0x6f>
c01004d2:	e8 6b 20 00 00       	call   c0102542 <cpunum>
c01004d7:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01004de:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
c01004e2:	74 11                	je     c01004f5 <isr_handler+0x6f>
                thisthread->context = r;
c01004e4:	e8 59 20 00 00       	call   c0102542 <cpunum>
c01004e9:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01004f0:	8b 40 08             	mov    0x8(%eax),%eax
c01004f3:	89 18                	mov    %ebx,(%eax)
            uint32_t arg1 = r->edx;
            uint32_t arg2 = r->ecx;
            uint32_t arg3 = r->ebx;
            uint32_t arg4 = r->edi;
            uint32_t arg5 = r->esi;
            r->eax = syscall(syscallno, arg1, arg2, arg3, arg4, arg5);
c01004f5:	51                   	push   %ecx
c01004f6:	51                   	push   %ecx
c01004f7:	ff 73 0c             	pushl  0xc(%ebx)
c01004fa:	ff 73 08             	pushl  0x8(%ebx)
c01004fd:	ff 73 18             	pushl  0x18(%ebx)
c0100500:	ff 73 20             	pushl  0x20(%ebx)
c0100503:	ff 73 1c             	pushl  0x1c(%ebx)
c0100506:	ff 73 24             	pushl  0x24(%ebx)
c0100509:	e8 95 03 00 00       	call   c01008a3 <syscall>
c010050e:	89 43 24             	mov    %eax,0x24(%ebx)
            }

            for (;;);
        }
    }
}
c0100511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100514:	c9                   	leave  
c0100515:	c3                   	ret    
            uint32_t arg5 = r->esi;
            r->eax = syscall(syscallno, arg1, arg2, arg3, arg4, arg5);
            break;
        }
        default: {
            print("\n\t>>> ");
c0100516:	83 ec 0c             	sub    $0xc,%esp
c0100519:	68 bf a9 10 c0       	push   $0xc010a9bf
c010051e:	e8 a1 38 00 00       	call   c0103dc4 <print>
            if (r->int_no < 32) {
c0100523:	8b 43 28             	mov    0x28(%ebx),%eax
c0100526:	83 c4 10             	add    $0x10,%esp
c0100529:	83 f8 1f             	cmp    $0x1f,%eax
c010052c:	77 1a                	ja     c0100548 <isr_handler+0xc2>
                print("Exception: ");
c010052e:	83 ec 0c             	sub    $0xc,%esp
c0100531:	68 c6 a9 10 c0       	push   $0xc010a9c6
c0100536:	e8 89 38 00 00       	call   c0103dc4 <print>
                print(exception_messages[r->int_no]);
c010053b:	5a                   	pop    %edx
c010053c:	8b 43 28             	mov    0x28(%ebx),%eax
c010053f:	ff 34 85 e0 ab 10 c0 	pushl  -0x3fef5420(,%eax,4)
c0100546:	eb 26                	jmp    c010056e <isr_handler+0xe8>
            } else if(r->int_no < 48)
c0100548:	83 f8 2f             	cmp    $0x2f,%eax
c010054b:	77 0a                	ja     c0100557 <isr_handler+0xd1>
                print("Interrupt Request");
c010054d:	83 ec 0c             	sub    $0xc,%esp
c0100550:	68 d2 a9 10 c0       	push   $0xc010a9d2
c0100555:	eb 17                	jmp    c010056e <isr_handler+0xe8>
            else if (r->int_no == 48)
c0100557:	83 f8 30             	cmp    $0x30,%eax
c010055a:	75 0a                	jne    c0100566 <isr_handler+0xe0>
                print("System Call");
c010055c:	83 ec 0c             	sub    $0xc,%esp
c010055f:	68 e4 a9 10 c0       	push   $0xc010a9e4
c0100564:	eb 08                	jmp    c010056e <isr_handler+0xe8>
            else
                print("Unanticipated exception");
c0100566:	83 ec 0c             	sub    $0xc,%esp
c0100569:	68 f0 a9 10 c0       	push   $0xc010a9f0
c010056e:	e8 51 38 00 00       	call   c0103dc4 <print>
c0100573:	83 c4 10             	add    $0x10,%esp
            print(" (%u).  System halted.\n\n", r->int_no);
c0100576:	50                   	push   %eax
c0100577:	50                   	push   %eax
c0100578:	ff 73 28             	pushl  0x28(%ebx)
c010057b:	68 08 aa 10 c0       	push   $0xc010aa08
c0100580:	e8 3f 38 00 00       	call   c0103dc4 <print>

            if (isr_routines[r->int_no] != NULL)
c0100585:	8b 43 28             	mov    0x28(%ebx),%eax
c0100588:	8b 04 85 20 68 13 c0 	mov    -0x3fec97e0(,%eax,4),%eax
c010058f:	83 c4 10             	add    $0x10,%esp
c0100592:	85 c0                	test   %eax,%eax
c0100594:	74 09                	je     c010059f <isr_handler+0x119>
                isr_routines[r->int_no](r);
c0100596:	83 ec 0c             	sub    $0xc,%esp
c0100599:	53                   	push   %ebx
c010059a:	ff d0                	call   *%eax
c010059c:	83 c4 10             	add    $0x10,%esp

            static volatile bool backtraced;

            if (!backtraced) {
c010059f:	a0 00 68 13 c0       	mov    0xc0136800,%al
c01005a4:	84 c0                	test   %al,%al
c01005a6:	75 13                	jne    c01005bb <isr_handler+0x135>
                backtraced = true;
c01005a8:	c6 05 00 68 13 c0 01 	movb   $0x1,0xc0136800
                backtrace_regs(r);
c01005af:	83 ec 0c             	sub    $0xc,%esp
c01005b2:	53                   	push   %ebx
c01005b3:	e8 f6 07 00 00       	call   c0100dae <backtrace_regs>
c01005b8:	83 c4 10             	add    $0x10,%esp
c01005bb:	eb fe                	jmp    c01005bb <isr_handler+0x135>

c01005bd <isr_install_handler>:
            for (;;);
        }
    }
}

void isr_install_handler(int isr, void (*handler)(struct regs* r)) {
c01005bd:	55                   	push   %ebp
c01005be:	89 e5                	mov    %esp,%ebp
c01005c0:	53                   	push   %ebx
c01005c1:	50                   	push   %eax
c01005c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(isr < NISR);
c01005c5:	83 fb 1f             	cmp    $0x1f,%ebx
c01005c8:	7e 2b                	jle    c01005f5 <isr_install_handler+0x38>
c01005ca:	83 ec 0c             	sub    $0xc,%esp
c01005cd:	68 b8 ab 10 c0       	push   $0xc010abb8
c01005d2:	68 b8 00 00 00       	push   $0xb8
c01005d7:	68 80 a9 10 c0       	push   $0xc010a980
c01005dc:	68 21 aa 10 c0       	push   $0xc010aa21
c01005e1:	68 95 a9 10 c0       	push   $0xc010a995
c01005e6:	e8 d9 37 00 00       	call   c0103dc4 <print>
c01005eb:	83 c4 20             	add    $0x20,%esp
c01005ee:	e8 57 08 00 00       	call   c0100e4a <backtrace>
c01005f3:	fa                   	cli    
c01005f4:	f4                   	hlt    
    isr_routines[isr] = handler;
c01005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f8:	89 04 9d 20 68 13 c0 	mov    %eax,-0x3fec97e0(,%ebx,4)
}
c01005ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100602:	c9                   	leave  
c0100603:	c3                   	ret    

c0100604 <isr_uninstall_handler>:

void isr_uninstall_handler(int isr) {
c0100604:	55                   	push   %ebp
c0100605:	89 e5                	mov    %esp,%ebp
c0100607:	53                   	push   %ebx
c0100608:	50                   	push   %eax
c0100609:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(isr < NISR);
c010060c:	83 fb 1f             	cmp    $0x1f,%ebx
c010060f:	7e 2b                	jle    c010063c <isr_uninstall_handler+0x38>
c0100611:	83 ec 0c             	sub    $0xc,%esp
c0100614:	68 a0 ab 10 c0       	push   $0xc010aba0
c0100619:	68 bd 00 00 00       	push   $0xbd
c010061e:	68 80 a9 10 c0       	push   $0xc010a980
c0100623:	68 21 aa 10 c0       	push   $0xc010aa21
c0100628:	68 95 a9 10 c0       	push   $0xc010a995
c010062d:	e8 92 37 00 00       	call   c0103dc4 <print>
c0100632:	83 c4 20             	add    $0x20,%esp
c0100635:	e8 10 08 00 00       	call   c0100e4a <backtrace>
c010063a:	fa                   	cli    
c010063b:	f4                   	hlt    
    isr_routines[isr] = NULL;
c010063c:	c7 04 9d 20 68 13 c0 	movl   $0x0,-0x3fec97e0(,%ebx,4)
c0100643:	00 00 00 00 
}
c0100647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010064a:	c9                   	leave  
c010064b:	c3                   	ret    

c010064c <irq_install_handler>:
extern void irq12(void);
extern void irq13(void);
extern void irq14(void);
extern void irq15(void);

void irq_install_handler(int irq, void (*handler)(struct regs* r)) {
c010064c:	55                   	push   %ebp
c010064d:	89 e5                	mov    %esp,%ebp
c010064f:	53                   	push   %ebx
c0100650:	50                   	push   %eax
c0100651:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(irq < NIRQ);
c0100654:	83 fb 0f             	cmp    $0xf,%ebx
c0100657:	7e 28                	jle    c0100681 <irq_install_handler+0x35>
c0100659:	83 ec 0c             	sub    $0xc,%esp
c010065c:	68 90 ac 10 c0       	push   $0xc010ac90
c0100661:	6a 1c                	push   $0x1c
c0100663:	68 60 ac 10 c0       	push   $0xc010ac60
c0100668:	68 6b ac 10 c0       	push   $0xc010ac6b
c010066d:	68 95 a9 10 c0       	push   $0xc010a995
c0100672:	e8 4d 37 00 00       	call   c0103dc4 <print>
c0100677:	83 c4 20             	add    $0x20,%esp
c010067a:	e8 cb 07 00 00       	call   c0100e4a <backtrace>
c010067f:	fa                   	cli    
c0100680:	f4                   	hlt    
    irq_routines[irq] = handler;
c0100681:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100684:	89 04 9d a0 68 13 c0 	mov    %eax,-0x3fec9760(,%ebx,4)
}
c010068b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010068e:	c9                   	leave  
c010068f:	c3                   	ret    

c0100690 <irq_uninstall_handler>:

void irq_uninstall_handler(int irq) {
c0100690:	55                   	push   %ebp
c0100691:	89 e5                	mov    %esp,%ebp
c0100693:	53                   	push   %ebx
c0100694:	50                   	push   %eax
c0100695:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(irq < NIRQ);
c0100698:	83 fb 0f             	cmp    $0xf,%ebx
c010069b:	7e 28                	jle    c01006c5 <irq_uninstall_handler+0x35>
c010069d:	83 ec 0c             	sub    $0xc,%esp
c01006a0:	68 78 ac 10 c0       	push   $0xc010ac78
c01006a5:	6a 21                	push   $0x21
c01006a7:	68 60 ac 10 c0       	push   $0xc010ac60
c01006ac:	68 6b ac 10 c0       	push   $0xc010ac6b
c01006b1:	68 95 a9 10 c0       	push   $0xc010a995
c01006b6:	e8 09 37 00 00       	call   c0103dc4 <print>
c01006bb:	83 c4 20             	add    $0x20,%esp
c01006be:	e8 87 07 00 00       	call   c0100e4a <backtrace>
c01006c3:	fa                   	cli    
c01006c4:	f4                   	hlt    
    irq_routines[irq] = NULL;
c01006c5:	c7 04 9d a0 68 13 c0 	movl   $0x0,-0x3fec9760(,%ebx,4)
c01006cc:	00 00 00 00 
}
c01006d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01006d3:	c9                   	leave  
c01006d4:	c3                   	ret    

c01006d5 <irq_remap>:

void irq_remap(void) {
c01006d5:	55                   	push   %ebp
c01006d6:	89 e5                	mov    %esp,%ebp
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01006d8:	ba 20 00 00 00       	mov    $0x20,%edx
c01006dd:	b0 11                	mov    $0x11,%al
c01006df:	ee                   	out    %al,(%dx)
c01006e0:	ba 21 00 00 00       	mov    $0x21,%edx
c01006e5:	b0 20                	mov    $0x20,%al
c01006e7:	ee                   	out    %al,(%dx)
c01006e8:	b0 04                	mov    $0x4,%al
c01006ea:	ee                   	out    %al,(%dx)
c01006eb:	b0 01                	mov    $0x1,%al
c01006ed:	ee                   	out    %al,(%dx)
c01006ee:	ba a0 00 00 00       	mov    $0xa0,%edx
c01006f3:	b0 11                	mov    $0x11,%al
c01006f5:	ee                   	out    %al,(%dx)
c01006f6:	ba a1 00 00 00       	mov    $0xa1,%edx
c01006fb:	b0 28                	mov    $0x28,%al
c01006fd:	ee                   	out    %al,(%dx)
c01006fe:	b0 02                	mov    $0x2,%al
c0100700:	ee                   	out    %al,(%dx)
c0100701:	b0 01                	mov    $0x1,%al
c0100703:	ee                   	out    %al,(%dx)
c0100704:	ba 21 00 00 00       	mov    $0x21,%edx
c0100709:	31 c0                	xor    %eax,%eax
c010070b:	ee                   	out    %al,(%dx)
c010070c:	ba a1 00 00 00       	mov    $0xa1,%edx
c0100711:	ee                   	out    %al,(%dx)
    outb(0xA1, 0x02);
    outb(0xA1, 0x01);

    outb(0x21, 0x00);
    outb(0xA1, 0x00);
}
c0100712:	5d                   	pop    %ebp
c0100713:	c3                   	ret    

c0100714 <init_irq>:

void init_irq(void) {
c0100714:	55                   	push   %ebp
c0100715:	89 e5                	mov    %esp,%ebp
c0100717:	83 ec 08             	sub    $0x8,%esp
    irq_remap();
c010071a:	e8 b6 ff ff ff       	call   c01006d5 <irq_remap>

    idt_set_gate(IRQ_OFFSET + IRQ_TIMER,  (unsigned) irq0,  0x08, 0x8E);
c010071f:	68 8e 00 00 00       	push   $0x8e
c0100724:	6a 08                	push   $0x8
c0100726:	68 18 01 10 c0       	push   $0xc0100118
c010072b:	6a 20                	push   $0x20
c010072d:	e8 56 fb ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_KBD,    (unsigned) irq1,  0x08, 0x8E);
c0100732:	68 8e 00 00 00       	push   $0x8e
c0100737:	6a 08                	push   $0x8
c0100739:	68 1f 01 10 c0       	push   $0xc010011f
c010073e:	6a 21                	push   $0x21
c0100740:	e8 43 fb ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_SLAVE,  (unsigned) irq2,  0x08, 0x8E);
c0100745:	83 c4 20             	add    $0x20,%esp
c0100748:	68 8e 00 00 00       	push   $0x8e
c010074d:	6a 08                	push   $0x8
c010074f:	68 26 01 10 c0       	push   $0xc0100126
c0100754:	6a 22                	push   $0x22
c0100756:	e8 2d fb ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_SER2,   (unsigned) irq3,  0x08, 0x8E);
c010075b:	68 8e 00 00 00       	push   $0x8e
c0100760:	6a 08                	push   $0x8
c0100762:	68 2d 01 10 c0       	push   $0xc010012d
c0100767:	6a 23                	push   $0x23
c0100769:	e8 1a fb ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_SER1,   (unsigned) irq4,  0x08, 0x8E);
c010076e:	83 c4 20             	add    $0x20,%esp
c0100771:	68 8e 00 00 00       	push   $0x8e
c0100776:	6a 08                	push   $0x8
c0100778:	68 34 01 10 c0       	push   $0xc0100134
c010077d:	6a 24                	push   $0x24
c010077f:	e8 04 fb ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_SOUND,  (unsigned) irq5,  0x08, 0x8E);
c0100784:	68 8e 00 00 00       	push   $0x8e
c0100789:	6a 08                	push   $0x8
c010078b:	68 3b 01 10 c0       	push   $0xc010013b
c0100790:	6a 25                	push   $0x25
c0100792:	e8 f1 fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_FLOPPY, (unsigned) irq6,  0x08, 0x8E);
c0100797:	83 c4 20             	add    $0x20,%esp
c010079a:	68 8e 00 00 00       	push   $0x8e
c010079f:	6a 08                	push   $0x8
c01007a1:	68 42 01 10 c0       	push   $0xc0100142
c01007a6:	6a 26                	push   $0x26
c01007a8:	e8 db fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_SPUR,   (unsigned) irq7,  0x08, 0x8E);
c01007ad:	68 8e 00 00 00       	push   $0x8e
c01007b2:	6a 08                	push   $0x8
c01007b4:	68 49 01 10 c0       	push   $0xc0100149
c01007b9:	6a 27                	push   $0x27
c01007bb:	e8 c8 fa ff ff       	call   c0100288 <idt_set_gate>

    idt_set_gate(IRQ_OFFSET + IRQ_RTC,    (unsigned) irq8,  0x08, 0x8E);
c01007c0:	83 c4 20             	add    $0x20,%esp
c01007c3:	68 8e 00 00 00       	push   $0x8e
c01007c8:	6a 08                	push   $0x8
c01007ca:	68 50 01 10 c0       	push   $0xc0100150
c01007cf:	6a 28                	push   $0x28
c01007d1:	e8 b2 fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_ACPI,   (unsigned) irq9,  0x08, 0x8E);
c01007d6:	68 8e 00 00 00       	push   $0x8e
c01007db:	6a 08                	push   $0x8
c01007dd:	68 57 01 10 c0       	push   $0xc0100157
c01007e2:	6a 29                	push   $0x29
c01007e4:	e8 9f fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_SCSI,   (unsigned) irq10, 0x08, 0x8E);
c01007e9:	83 c4 20             	add    $0x20,%esp
c01007ec:	68 8e 00 00 00       	push   $0x8e
c01007f1:	6a 08                	push   $0x8
c01007f3:	68 5e 01 10 c0       	push   $0xc010015e
c01007f8:	6a 2a                	push   $0x2a
c01007fa:	e8 89 fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_NIC,    (unsigned) irq11, 0x08, 0x8E);
c01007ff:	68 8e 00 00 00       	push   $0x8e
c0100804:	6a 08                	push   $0x8
c0100806:	68 65 01 10 c0       	push   $0xc0100165
c010080b:	6a 2b                	push   $0x2b
c010080d:	e8 76 fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_MOUSE,  (unsigned) irq12, 0x08, 0x8E);
c0100812:	83 c4 20             	add    $0x20,%esp
c0100815:	68 8e 00 00 00       	push   $0x8e
c010081a:	6a 08                	push   $0x8
c010081c:	68 6c 01 10 c0       	push   $0xc010016c
c0100821:	6a 2c                	push   $0x2c
c0100823:	e8 60 fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_FPU,    (unsigned) irq13, 0x08, 0x8E);
c0100828:	68 8e 00 00 00       	push   $0x8e
c010082d:	6a 08                	push   $0x8
c010082f:	68 73 01 10 c0       	push   $0xc0100173
c0100834:	6a 2d                	push   $0x2d
c0100836:	e8 4d fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_IDE,    (unsigned) irq14, 0x08, 0x8E);
c010083b:	83 c4 20             	add    $0x20,%esp
c010083e:	68 8e 00 00 00       	push   $0x8e
c0100843:	6a 08                	push   $0x8
c0100845:	68 7a 01 10 c0       	push   $0xc010017a
c010084a:	6a 2e                	push   $0x2e
c010084c:	e8 37 fa ff ff       	call   c0100288 <idt_set_gate>
    idt_set_gate(IRQ_OFFSET + IRQ_IPI,    (unsigned) irq15, 0x08, 0x8E);
c0100851:	68 8e 00 00 00       	push   $0x8e
c0100856:	6a 08                	push   $0x8
c0100858:	68 81 01 10 c0       	push   $0xc0100181
c010085d:	6a 2f                	push   $0x2f
c010085f:	e8 24 fa ff ff       	call   c0100288 <idt_set_gate>
}
c0100864:	83 c4 20             	add    $0x20,%esp
c0100867:	c9                   	leave  
c0100868:	c3                   	ret    

c0100869 <irq_handler>:

void irq_handler(struct regs* r) {
c0100869:	55                   	push   %ebp
c010086a:	89 e5                	mov    %esp,%ebp
c010086c:	53                   	push   %ebx
c010086d:	50                   	push   %eax
c010086e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // thisthread->context = r;

    void (*handler)(struct regs * r) = irq_routines[r->int_no - IRQ_OFFSET];
c0100871:	8b 43 28             	mov    0x28(%ebx),%eax
c0100874:	8b 04 85 20 68 13 c0 	mov    -0x3fec97e0(,%eax,4),%eax
    if (handler)
c010087b:	85 c0                	test   %eax,%eax
c010087d:	74 09                	je     c0100888 <irq_handler+0x1f>
        handler(r);
c010087f:	83 ec 0c             	sub    $0xc,%esp
c0100882:	53                   	push   %ebx
c0100883:	ff d0                	call   *%eax
c0100885:	83 c4 10             	add    $0x10,%esp

    if (r->int_no >= 0x28)
c0100888:	83 7b 28 27          	cmpl   $0x27,0x28(%ebx)
c010088c:	76 08                	jbe    c0100896 <irq_handler+0x2d>
c010088e:	ba a0 00 00 00       	mov    $0xa0,%edx
c0100893:	b0 20                	mov    $0x20,%al
c0100895:	ee                   	out    %al,(%dx)
c0100896:	ba 20 00 00 00       	mov    $0x20,%edx
c010089b:	b0 20                	mov    $0x20,%al
c010089d:	ee                   	out    %al,(%dx)
        outb(0xA0, 0x20);

    outb(0x20, 0x20);
}
c010089e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01008a1:	c9                   	leave  
c01008a2:	c3                   	ret    

c01008a3 <syscall>:
#include <syscall.h>
#include <int.h>
#include <thread.h>

int
syscall(uint32_t num, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5) {
c01008a3:	55                   	push   %ebp
c01008a4:	89 e5                	mov    %esp,%ebp
c01008a6:	56                   	push   %esi
c01008a7:	53                   	push   %ebx
c01008a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01008ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c01008ae:	8b 75 10             	mov    0x10(%ebp),%esi
    (void) a4;
    (void) a5;

    int ret = 0;

    switch (num) {
c01008b1:	85 c0                	test   %eax,%eax
c01008b3:	74 07                	je     c01008bc <syscall+0x19>
c01008b5:	83 f8 01             	cmp    $0x1,%eax
c01008b8:	74 0c                	je     c01008c6 <syscall+0x23>
c01008ba:	eb 71                	jmp    c010092d <syscall+0x8a>
        case syscall_yield:
            thread_yield();
c01008bc:	e8 da 6a 00 00       	call   c010739b <thread_yield>
            break;
c01008c1:	e9 84 00 00 00       	jmp    c010094a <syscall+0xa7>
        case syscall_sleep:
            assert(a1 != 0);
c01008c6:	85 db                	test   %ebx,%ebx
c01008c8:	75 28                	jne    c01008f2 <syscall+0x4f>
c01008ca:	83 ec 0c             	sub    $0xc,%esp
c01008cd:	68 dc ac 10 c0       	push   $0xc010acdc
c01008d2:	6a 13                	push   $0x13
c01008d4:	68 a4 ac 10 c0       	push   $0xc010aca4
c01008d9:	68 b3 ac 10 c0       	push   $0xc010acb3
c01008de:	68 95 a9 10 c0       	push   $0xc010a995
c01008e3:	e8 dc 34 00 00       	call   c0103dc4 <print>
c01008e8:	83 c4 20             	add    $0x20,%esp
c01008eb:	e8 5a 05 00 00       	call   c0100e4a <backtrace>
c01008f0:	fa                   	cli    
c01008f1:	f4                   	hlt    
            assert(a2 != 0);
c01008f2:	85 f6                	test   %esi,%esi
c01008f4:	75 28                	jne    c010091e <syscall+0x7b>
c01008f6:	83 ec 0c             	sub    $0xc,%esp
c01008f9:	68 dc ac 10 c0       	push   $0xc010acdc
c01008fe:	6a 14                	push   $0x14
c0100900:	68 a4 ac 10 c0       	push   $0xc010aca4
c0100905:	68 bb ac 10 c0       	push   $0xc010acbb
c010090a:	68 95 a9 10 c0       	push   $0xc010a995
c010090f:	e8 b0 34 00 00       	call   c0103dc4 <print>
c0100914:	83 c4 20             	add    $0x20,%esp
c0100917:	e8 2e 05 00 00       	call   c0100e4a <backtrace>
c010091c:	fa                   	cli    
c010091d:	f4                   	hlt    
            thread_switch(S_SLEEP, (struct wchan*) a1, (struct spinlock*) a2);
c010091e:	50                   	push   %eax
c010091f:	56                   	push   %esi
c0100920:	53                   	push   %ebx
c0100921:	6a 02                	push   $0x2
c0100923:	e8 7b 67 00 00       	call   c01070a3 <thread_switch>
            break;
c0100928:	83 c4 10             	add    $0x10,%esp
c010092b:	eb 1d                	jmp    c010094a <syscall+0xa7>
        default:
            panic("unhandled syscall no: %u", num);
c010092d:	83 ec 0c             	sub    $0xc,%esp
c0100930:	50                   	push   %eax
c0100931:	68 c3 ac 10 c0       	push   $0xc010acc3
c0100936:	68 dc ac 10 c0       	push   $0xc010acdc
c010093b:	6a 18                	push   $0x18
c010093d:	68 a4 ac 10 c0       	push   $0xc010aca4
c0100942:	e8 fb 2f 00 00       	call   c0103942 <_panic>
c0100947:	83 c4 20             	add    $0x20,%esp
    }

    return ret;
}
c010094a:	31 c0                	xor    %eax,%eax
c010094c:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010094f:	5b                   	pop    %ebx
c0100950:	5e                   	pop    %esi
c0100951:	5d                   	pop    %ebp
c0100952:	c3                   	ret    

c0100953 <sys_yield>:

    return ret;
}

void
sys_yield(void) {
c0100953:	55                   	push   %ebp
c0100954:	89 e5                	mov    %esp,%ebp
c0100956:	57                   	push   %edi
c0100957:	56                   	push   %esi
c0100958:	53                   	push   %ebx
    // potentially change the condition codes and arbitrary
    // memory locations.

    int ret;

    asm volatile("int %1\n"
c0100959:	31 f6                	xor    %esi,%esi
c010095b:	89 f0                	mov    %esi,%eax
c010095d:	89 f2                	mov    %esi,%edx
c010095f:	89 f1                	mov    %esi,%ecx
c0100961:	89 f3                	mov    %esi,%ebx
c0100963:	89 f7                	mov    %esi,%edi
c0100965:	cd 30                	int    $0x30
}

void
sys_yield(void) {
    _syscall(syscall_yield, false, 0, 0, 0, 0, 0);
}
c0100967:	5b                   	pop    %ebx
c0100968:	5e                   	pop    %esi
c0100969:	5f                   	pop    %edi
c010096a:	5d                   	pop    %ebp
c010096b:	c3                   	ret    

c010096c <sys_sleep>:

void
sys_sleep(struct wchan* wc, struct spinlock* lk) {
c010096c:	55                   	push   %ebp
c010096d:	89 e5                	mov    %esp,%ebp
c010096f:	57                   	push   %edi
c0100970:	56                   	push   %esi
c0100971:	53                   	push   %ebx
    // potentially change the condition codes and arbitrary
    // memory locations.

    int ret;

    asm volatile("int %1\n"
c0100972:	31 db                	xor    %ebx,%ebx
c0100974:	b8 01 00 00 00       	mov    $0x1,%eax
c0100979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c010097c:	8b 55 08             	mov    0x8(%ebp),%edx
c010097f:	89 df                	mov    %ebx,%edi
c0100981:	89 de                	mov    %ebx,%esi
c0100983:	cd 30                	int    $0x30
}

void
sys_sleep(struct wchan* wc, struct spinlock* lk) {
    _syscall(syscall_sleep, false, (uint32_t) wc, (uint32_t) lk, 0, 0, 0);
}
c0100985:	5b                   	pop    %ebx
c0100986:	5e                   	pop    %esi
c0100987:	5f                   	pop    %edi
c0100988:	5d                   	pop    %ebp
c0100989:	c3                   	ret    

c010098a <kmain>:
    }
    settextcolor(VGA_NORMAL);
}

void
kmain(uint32_t eax, size_t ebx) {
c010098a:	55                   	push   %ebp
c010098b:	89 e5                	mov    %esp,%ebp
c010098d:	57                   	push   %edi
c010098e:	56                   	push   %esi
c010098f:	53                   	push   %ebx
c0100990:	83 ec 1c             	sub    $0x1c,%esp
    demand(*(uint16_t*) 0x7DFE == 0xAA55);  // Reboot if false
c0100993:	66 81 3d fe 7d 00 00 	cmpw   $0xaa55,0x7dfe
c010099a:	55 aa 
c010099c:	74 08                	je     c01009a6 <kmain+0x1c>
c010099e:	ba 92 00 00 00       	mov    $0x92,%edx
c01009a3:	b0 03                	mov    $0x3,%al
c01009a5:	ee                   	out    %al,(%dx)
    demand(eax == 0x2BADB002);
c01009a6:	81 7d 08 02 b0 ad 2b 	cmpl   $0x2badb002,0x8(%ebp)
c01009ad:	74 08                	je     c01009b7 <kmain+0x2d>
c01009af:	ba 92 00 00 00       	mov    $0x92,%edx
c01009b4:	b0 03                	mov    $0x3,%al
c01009b6:	ee                   	out    %al,(%dx)

    extern char _bss[], _ebss[];            // Init static data to zero
    memset(_bss, 0, _ebss - _bss);
c01009b7:	51                   	push   %ecx
c01009b8:	b8 08 80 17 c0       	mov    $0xc0178008,%eax
c01009bd:	2d 00 60 13 c0       	sub    $0xc0136000,%eax
c01009c2:	50                   	push   %eax
c01009c3:	6a 00                	push   $0x0
c01009c5:	68 00 60 13 c0       	push   $0xc0136000
c01009ca:	e8 ed 3a 00 00       	call   c01044bc <memset>

    init_cga();
c01009cf:	e8 6e 17 00 00       	call   c0102142 <init_cga>
    init_serial();
c01009d4:	e8 f2 1f 00 00       	call   c01029cb <init_serial>

    init_e820(ebx);
c01009d9:	5b                   	pop    %ebx
c01009da:	ff 75 0c             	pushl  0xc(%ebp)
c01009dd:	e8 95 18 00 00       	call   c0102277 <init_e820>

    init_gdt();
c01009e2:	e8 10 f8 ff ff       	call   c01001f7 <init_gdt>
    init_idt();
c01009e7:	e8 d8 f8 ff ff       	call   c01002c4 <init_idt>
    init_isr();
c01009ec:	e8 06 f9 ff ff       	call   c01002f7 <init_isr>
    init_irq();
c01009f1:	e8 1e fd ff ff       	call   c0100714 <init_irq>
    init_pit();
c01009f6:	e8 2b 1f 00 00       	call   c0102926 <init_pit>

    init_kbd();
c01009fb:	e8 18 1b 00 00       	call   c0102518 <init_kbd>

    init_mem();
c0100a00:	e8 12 0c 00 00       	call   c0101617 <init_mem>
    init_kmm();
c0100a05:	e8 29 09 00 00       	call   c0101333 <init_kmm>

    init_pmm();
c0100a0a:	e8 f8 05 00 00       	call   c0101007 <init_pmm>
    init_vmm();
c0100a0f:	e8 de 0a 00 00       	call   c01014f2 <init_vmm>

    init_acpi();
c0100a14:	e8 ee 12 00 00       	call   c0101d07 <init_acpi>

    init_wchan();
c0100a19:	e8 44 2b 00 00       	call   c0103562 <init_wchan>

    // init_thread();
    init_smp();
c0100a1e:	e8 31 78 00 00       	call   c0108254 <init_smp>
    init_cpu();
c0100a23:	e8 f7 79 00 00       	call   c010841f <init_cpu>

    init_proc();
c0100a28:	e8 04 81 00 00       	call   c0108b31 <init_proc>
    //     "movl %%ebx, %%ss\n"
    //     "popl %%ebx\n"
    //     : : : "memory"
    // );

    init_lapic();
c0100a2d:	e8 76 1b 00 00       	call   c01025a8 <init_lapic>
    asm volatile ("cli");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0100a32:	fb                   	sti    
}

static inline void
hlt(void) {
    asm volatile ("hlt");
c0100a33:	f4                   	hlt    
        "\t\t        _/  _/  _/    _/    _/_/           _/    _/    _/_/    \n",
        "\t\t _/    _/  _/  _/    _/  _/    _/         _/    _/        _/   \n",
        "\t\t  _/_/    _/  _/    _/  _/    _/           _/_/    _/_/_/      \n",
    };

    print("\n");
c0100a34:	c7 04 24 c9 ae 10 c0 	movl   $0xc010aec9,(%esp)
c0100a3b:	e8 84 33 00 00       	call   c0103dc4 <print>
c0100a40:	83 c4 10             	add    $0x10,%esp
    for (int i = 0, k = 0; i < 5; ++i, k = 0) {
c0100a43:	31 f6                	xor    %esi,%esi
    }
    settextcolor(VGA_NORMAL);
}

void
kmain(uint32_t eax, size_t ebx) {
c0100a45:	31 ff                	xor    %edi,%edi
c0100a47:	b8 06 00 00 00       	mov    $0x6,%eax
c0100a4c:	29 f0                	sub    %esi,%eax
c0100a4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100a51:	8b 1c b5 48 ae 10 c0 	mov    -0x3fef51b8(,%esi,4),%ebx
        "\t\t  _/_/    _/  _/    _/  _/    _/           _/_/    _/_/_/      \n",
    };

    print("\n");
    for (int i = 0, k = 0; i < 5; ++i, k = 0) {
        for (int j = 0; j < 6 - i; ++j, ++k)    // whitespace
c0100a58:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
c0100a5b:	7d 13                	jge    c0100a70 <kmain+0xe6>
            putc(title[i][k]);
c0100a5d:	83 ec 0c             	sub    $0xc,%esp
c0100a60:	0f be 04 3b          	movsbl (%ebx,%edi,1),%eax
c0100a64:	50                   	push   %eax
c0100a65:	e8 30 89 00 00       	call   c010939a <putc>
        "\t\t  _/_/    _/  _/    _/  _/    _/           _/_/    _/_/_/      \n",
    };

    print("\n");
    for (int i = 0, k = 0; i < 5; ++i, k = 0) {
        for (int j = 0; j < 6 - i; ++j, ++k)    // whitespace
c0100a6a:	47                   	inc    %edi
c0100a6b:	83 c4 10             	add    $0x10,%esp
c0100a6e:	eb e8                	jmp    c0100a58 <kmain+0xce>
c0100a70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
c0100a73:	85 ff                	test   %edi,%edi
c0100a75:	79 02                	jns    c0100a79 <kmain+0xef>
c0100a77:	31 ff                	xor    %edi,%edi
            putc(title[i][k]);
        settextcolor(VGA_DGREEN);
c0100a79:	83 ec 0c             	sub    $0xc,%esp
c0100a7c:	68 00 02 00 00       	push   $0x200
c0100a81:	e8 ae 16 00 00       	call   c0102134 <settextcolor>
c0100a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
c0100a89:	8d 47 20             	lea    0x20(%edi),%eax
c0100a8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100a8f:	83 c4 10             	add    $0x10,%esp
        for (int j = 0; j < 32; ++j, ++k)       // "Jinx"
            putc(title[i][k]);
c0100a92:	83 ec 0c             	sub    $0xc,%esp
c0100a95:	0f be 14 3b          	movsbl (%ebx,%edi,1),%edx
c0100a99:	52                   	push   %edx
c0100a9a:	e8 fb 88 00 00       	call   c010939a <putc>
    print("\n");
    for (int i = 0, k = 0; i < 5; ++i, k = 0) {
        for (int j = 0; j < 6 - i; ++j, ++k)    // whitespace
            putc(title[i][k]);
        settextcolor(VGA_DGREEN);
        for (int j = 0; j < 32; ++j, ++k)       // "Jinx"
c0100a9f:	47                   	inc    %edi
c0100aa0:	83 c4 10             	add    $0x10,%esp
c0100aa3:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
c0100aa6:	75 ea                	jne    c0100a92 <kmain+0x108>
            putc(title[i][k]);
        settextcolor(VGA_DGREY);
c0100aa8:	83 ec 0c             	sub    $0xc,%esp
c0100aab:	68 00 08 00 00       	push   $0x800
c0100ab0:	e8 7f 16 00 00       	call   c0102134 <settextcolor>
c0100ab5:	83 c4 10             	add    $0x10,%esp
        for (int j = 0; j < 27; ++j, ++k)       // "OS"
c0100ab8:	31 ff                	xor    %edi,%edi
            putc(title[i][k]);
c0100aba:	03 5d e0             	add    -0x20(%ebp),%ebx
c0100abd:	83 ec 0c             	sub    $0xc,%esp
c0100ac0:	0f be 44 3b 20       	movsbl 0x20(%ebx,%edi,1),%eax
c0100ac5:	50                   	push   %eax
c0100ac6:	e8 cf 88 00 00       	call   c010939a <putc>
            putc(title[i][k]);
        settextcolor(VGA_DGREEN);
        for (int j = 0; j < 32; ++j, ++k)       // "Jinx"
            putc(title[i][k]);
        settextcolor(VGA_DGREY);
        for (int j = 0; j < 27; ++j, ++k)       // "OS"
c0100acb:	47                   	inc    %edi
c0100acc:	83 c4 10             	add    $0x10,%esp
c0100acf:	83 ff 1b             	cmp    $0x1b,%edi
c0100ad2:	75 e9                	jne    c0100abd <kmain+0x133>
            putc(title[i][k]);
        putc('\n');
c0100ad4:	83 ec 0c             	sub    $0xc,%esp
c0100ad7:	6a 0a                	push   $0xa
c0100ad9:	e8 bc 88 00 00       	call   c010939a <putc>
        "\t\t _/    _/  _/  _/    _/  _/    _/         _/    _/        _/   \n",
        "\t\t  _/_/    _/  _/    _/  _/    _/           _/_/    _/_/_/      \n",
    };

    print("\n");
    for (int i = 0, k = 0; i < 5; ++i, k = 0) {
c0100ade:	46                   	inc    %esi
c0100adf:	83 c4 10             	add    $0x10,%esp
c0100ae2:	83 fe 05             	cmp    $0x5,%esi
c0100ae5:	0f 85 5a ff ff ff    	jne    c0100a45 <kmain+0xbb>
        settextcolor(VGA_DGREY);
        for (int j = 0; j < 27; ++j, ++k)       // "OS"
            putc(title[i][k]);
        putc('\n');
    }
    settextcolor(VGA_NORMAL);
c0100aeb:	83 ec 0c             	sub    $0xc,%esp
c0100aee:	68 00 0f 00 00       	push   $0xf00
c0100af3:	e8 3c 16 00 00       	call   c0102134 <settextcolor>
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile("pushfl; popl %0" : "=r" (eflags));
c0100af8:	9c                   	pushf  
c0100af9:	5a                   	pop    %edx

    // lock_kernel();

    jinx();

    print("interrupt flag: %s\n", (read_eflags() >> 9) & 1 ? "on" : "off");
c0100afa:	83 c4 10             	add    $0x10,%esp
c0100afd:	b8 09 b1 10 c0       	mov    $0xc010b109,%eax
c0100b02:	80 e6 02             	and    $0x2,%dh
c0100b05:	75 05                	jne    c0100b0c <kmain+0x182>
c0100b07:	b8 70 d3 10 c0       	mov    $0xc010d370,%eax
c0100b0c:	52                   	push   %edx
c0100b0d:	52                   	push   %edx
c0100b0e:	50                   	push   %eax
c0100b0f:	68 e4 ac 10 c0       	push   $0xc010ace4
c0100b14:	e8 ab 32 00 00       	call   c0103dc4 <print>
c0100b19:	83 c4 10             	add    $0x10,%esp
    // print("thiscpu->status: %u\n", thiscpu->status);

    // init_speaker();

    for(;;) for(;;) for (;;)
        prompt();
c0100b1c:	e8 8a 89 00 00       	call   c01094ab <prompt>
c0100b21:	eb f9                	jmp    c0100b1c <kmain+0x192>

c0100b23 <stab_binsearch.constprop.0>:
//      left = 0, right = 657;
//      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//  will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct stab* stabs, int* region_left, int* region_right,
c0100b23:	55                   	push   %ebp
c0100b24:	89 e5                	mov    %esp,%ebp
c0100b26:	57                   	push   %edi
c0100b27:	56                   	push   %esi
c0100b28:	53                   	push   %ebx
c0100b29:	83 ec 14             	sub    $0x14,%esp
c0100b2c:	89 c3                	mov    %eax,%ebx
c0100b2e:	89 d6                	mov    %edx,%esi
c0100b30:	89 4d e0             	mov    %ecx,-0x20(%ebp)
               int type, size_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;
c0100b33:	8b 38                	mov    (%eax),%edi
c0100b35:	8b 02                	mov    (%edx),%eax
c0100b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100b3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    while (l <= r) {
c0100b41:	3b 7d f0             	cmp    -0x10(%ebp),%edi
c0100b44:	7f 65                	jg     c0100bab <stab_binsearch.constprop.0+0x88>
        int true_m = (l + r) / 2, m = true_m;
c0100b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b49:	01 f8                	add    %edi,%eax
c0100b4b:	b9 02 00 00 00       	mov    $0x2,%ecx
c0100b50:	99                   	cltd   
c0100b51:	f7 f9                	idiv   %ecx
c0100b53:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0100b56:	6b c0 0c             	imul   $0xc,%eax,%eax
c0100b59:	05 00 e0 10 c0       	add    $0xc010e000,%eax
c0100b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0100b61:	8b 45 e8             	mov    -0x18(%ebp),%eax

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
c0100b64:	39 c7                	cmp    %eax,%edi
c0100b66:	7f 13                	jg     c0100b7b <stab_binsearch.constprop.0+0x58>
c0100b68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100b6b:	83 6d e4 0c          	subl   $0xc,-0x1c(%ebp)
c0100b6f:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
c0100b73:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
c0100b76:	74 09                	je     c0100b81 <stab_binsearch.constprop.0+0x5e>
            m--;
c0100b78:	48                   	dec    %eax
c0100b79:	eb e9                	jmp    c0100b64 <stab_binsearch.constprop.0+0x41>
        if (m < l) {    // no match in [l, m]
            l = true_m + 1;
c0100b7b:	8b 7d e8             	mov    -0x18(%ebp),%edi
c0100b7e:	47                   	inc    %edi
c0100b7f:	eb c0                	jmp    c0100b41 <stab_binsearch.constprop.0+0x1e>
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
c0100b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
c0100b84:	39 4a 08             	cmp    %ecx,0x8(%edx)
c0100b87:	73 08                	jae    c0100b91 <stab_binsearch.constprop.0+0x6e>
            *region_left = m;
c0100b89:	89 03                	mov    %eax,(%ebx)
            l = true_m + 1;
c0100b8b:	8b 7d e8             	mov    -0x18(%ebp),%edi
c0100b8e:	47                   	inc    %edi
c0100b8f:	eb 11                	jmp    c0100ba2 <stab_binsearch.constprop.0+0x7f>
        } else if (stabs[m].n_value > addr) {
c0100b91:	76 08                	jbe    c0100b9b <stab_binsearch.constprop.0+0x78>
            *region_right = m - 1;
c0100b93:	48                   	dec    %eax
c0100b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100b97:	89 06                	mov    %eax,(%esi)
c0100b99:	eb 07                	jmp    c0100ba2 <stab_binsearch.constprop.0+0x7f>
            r = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100b9b:	89 03                	mov    %eax,(%ebx)
            l = m;
            addr++;
c0100b9d:	ff 45 08             	incl   0x8(%ebp)
c0100ba0:	89 c7                	mov    %eax,%edi
            l = true_m + 1;
            continue;
        }

        // actual binary search
        any_matches = 1;
c0100ba2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0100ba9:	eb 96                	jmp    c0100b41 <stab_binsearch.constprop.0+0x1e>
            l = m;
            addr++;
        }
    }

    if (!any_matches)
c0100bab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100baf:	8b 13                	mov    (%ebx),%edx
c0100bb1:	75 05                	jne    c0100bb8 <stab_binsearch.constprop.0+0x95>
        *region_right = *region_left - 1;
c0100bb3:	4a                   	dec    %edx
c0100bb4:	89 16                	mov    %edx,(%esi)
c0100bb6:	eb 1a                	jmp    c0100bd2 <stab_binsearch.constprop.0+0xaf>
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
c0100bb8:	8b 06                	mov    (%esi),%eax
c0100bba:	39 d0                	cmp    %edx,%eax
c0100bbc:	7e 12                	jle    c0100bd0 <stab_binsearch.constprop.0+0xad>
                l > *region_left && stabs[l].n_type != type;
c0100bbe:	6b c8 0c             	imul   $0xc,%eax,%ecx
c0100bc1:	0f b6 89 04 e0 10 c0 	movzbl -0x3fef1ffc(%ecx),%ecx
c0100bc8:	39 4d e0             	cmp    %ecx,-0x20(%ebp)
c0100bcb:	74 03                	je     c0100bd0 <stab_binsearch.constprop.0+0xad>
                l--)
c0100bcd:	48                   	dec    %eax
c0100bce:	eb ea                	jmp    c0100bba <stab_binsearch.constprop.0+0x97>
            /* do nothing */;
        *region_left = l;
c0100bd0:	89 03                	mov    %eax,(%ebx)
    }
}
c0100bd2:	83 c4 14             	add    $0x14,%esp
c0100bd5:	5b                   	pop    %ebx
c0100bd6:	5e                   	pop    %esi
c0100bd7:	5f                   	pop    %edi
c0100bd8:	5d                   	pop    %ebp
c0100bd9:	c3                   	ret    

c0100bda <debuginfo_eip>:
//  instruction address, 'addr'.  Returns 0 if information was found, and
//  negative if not.  But even if it returns negative it has stored some
//  information into '*info'.
//
int
debuginfo_eip(size_t addr, struct debuginfo* info) {
c0100bda:	55                   	push   %ebp
c0100bdb:	89 e5                	mov    %esp,%ebp
c0100bdd:	57                   	push   %edi
c0100bde:	56                   	push   %esi
c0100bdf:	53                   	push   %ebx
c0100be0:	83 ec 3c             	sub    $0x3c,%esp
c0100be3:	8b 75 08             	mov    0x8(%ebp),%esi
c0100be6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    const struct stab* stabs, *stab_end;
    const char* stabstr, *stabstr_end;
    int lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->dbg_file = "<unknown>";
c0100be9:	c7 03 5c ae 10 c0    	movl   $0xc010ae5c,(%ebx)
    info->dbg_line = 0;
c0100bef:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    info->dbg_fn_name = "<unknown>";
c0100bf6:	c7 43 08 5c ae 10 c0 	movl   $0xc010ae5c,0x8(%ebx)
    info->dbg_fn_namelen = 9;
c0100bfd:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
    info->dbg_fn_addr = addr;
c0100c04:	89 73 10             	mov    %esi,0x10(%ebx)
    info->dbg_fn_narg = 0;
c0100c07:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

    // Find the relevant set of stabs
    if (addr >= 0xbf800000) {
c0100c0e:	81 fe ff ff 7f bf    	cmp    $0xbf7fffff,%esi
c0100c14:	77 1d                	ja     c0100c33 <debuginfo_eip+0x59>
        stabstr = _stab_strs;
        stabstr_end = _estab_strs;
    } else {
        // Can't search for user-level addresses yet!
        // backtrace();
        panic("Invalid address: %08p", addr);
c0100c16:	83 ec 0c             	sub    $0xc,%esp
c0100c19:	56                   	push   %esi
c0100c1a:	68 66 ae 10 c0       	push   $0xc010ae66
c0100c1f:	68 d4 af 10 c0       	push   $0xc010afd4
c0100c24:	6a 7d                	push   $0x7d
c0100c26:	68 7c ae 10 c0       	push   $0xc010ae7c
c0100c2b:	e8 12 2d 00 00       	call   c0103942 <_panic>
c0100c30:	83 c4 20             	add    $0x20,%esp
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
c0100c33:	b8 90 bf 12 c0       	mov    $0xc012bf90,%eax
c0100c38:	3d 35 44 12 c0       	cmp    $0xc0124435,%eax
c0100c3d:	77 08                	ja     c0100c47 <debuginfo_eip+0x6d>
        return -1;
c0100c3f:	83 c8 ff             	or     $0xffffffff,%eax
c0100c42:	e9 5f 01 00 00       	jmp    c0100da6 <debuginfo_eip+0x1cc>
        // backtrace();
        panic("Invalid address: %08p", addr);
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
c0100c47:	80 3d 8f bf 12 c0 00 	cmpb   $0x0,0xc012bf8f
c0100c4e:	75 ef                	jne    c0100c3f <debuginfo_eip+0x65>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
c0100c50:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    rfile = (stab_end - stabs) - 1;
c0100c57:	b8 34 44 12 c0       	mov    $0xc0124434,%eax
c0100c5c:	2d 00 e0 10 c0       	sub    $0xc010e000,%eax
c0100c61:	c1 f8 02             	sar    $0x2,%eax
c0100c64:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100c6a:	48                   	dec    %eax
c0100c6b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100c6e:	83 ec 0c             	sub    $0xc,%esp
c0100c71:	56                   	push   %esi
c0100c72:	b9 64 00 00 00       	mov    $0x64,%ecx
c0100c77:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0100c7a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100c7d:	e8 a1 fe ff ff       	call   c0100b23 <stab_binsearch.constprop.0>
    if (lfile == 0)
c0100c82:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100c85:	83 c4 10             	add    $0x10,%esp
c0100c88:	85 c0                	test   %eax,%eax
c0100c8a:	74 b3                	je     c0100c3f <debuginfo_eip+0x65>
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
c0100c8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    rfun = rfile;
c0100c8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100c92:	89 45 dc             	mov    %eax,-0x24(%ebp)
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100c95:	83 ec 0c             	sub    $0xc,%esp
c0100c98:	56                   	push   %esi
c0100c99:	b9 24 00 00 00       	mov    $0x24,%ecx
c0100c9e:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0100ca1:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100ca4:	e8 7a fe ff ff       	call   c0100b23 <stab_binsearch.constprop.0>

    if (lfun <= rfun) {
c0100ca9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100cac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100caf:	83 c4 10             	add    $0x10,%esp
c0100cb2:	39 ca                	cmp    %ecx,%edx
c0100cb4:	7f 3c                	jg     c0100cf2 <debuginfo_eip+0x118>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
c0100cb6:	6b c2 0c             	imul   $0xc,%edx,%eax
c0100cb9:	8d b8 00 e0 10 c0    	lea    -0x3fef2000(%eax),%edi
c0100cbf:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0100cc2:	8b 80 00 e0 10 c0    	mov    -0x3fef2000(%eax),%eax
c0100cc8:	bf 90 bf 12 c0       	mov    $0xc012bf90,%edi
c0100ccd:	81 ef 35 44 12 c0    	sub    $0xc0124435,%edi
c0100cd3:	39 f8                	cmp    %edi,%eax
c0100cd5:	7d 08                	jge    c0100cdf <debuginfo_eip+0x105>
            info->dbg_fn_name = stabstr + stabs[lfun].n_strx;
c0100cd7:	05 35 44 12 c0       	add    $0xc0124435,%eax
c0100cdc:	89 43 08             	mov    %eax,0x8(%ebx)
        info->dbg_fn_addr = stabs[lfun].n_value;
c0100cdf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0100ce2:	8b 40 08             	mov    0x8(%eax),%eax
c0100ce5:	89 43 10             	mov    %eax,0x10(%ebx)
        addr -= info->dbg_fn_addr;
c0100ce8:	29 c6                	sub    %eax,%esi
        // Search within the function definition for the line number.
        lline = lfun;
c0100cea:	89 55 e0             	mov    %edx,-0x20(%ebp)
        rline = rfun;
c0100ced:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c0100cf0:	eb 0f                	jmp    c0100d01 <debuginfo_eip+0x127>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->dbg_fn_addr = addr;
c0100cf2:	89 73 10             	mov    %esi,0x10(%ebx)
        lline = lfile;
c0100cf5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100cf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        rline = rfile;
c0100cfb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    }
    // Ignore stuff after the colon.
    info->dbg_fn_namelen = strstr(info->dbg_fn_name, ":") - info->dbg_fn_name;
c0100d01:	50                   	push   %eax
c0100d02:	50                   	push   %eax
c0100d03:	68 8a ae 10 c0       	push   $0xc010ae8a
c0100d08:	ff 73 08             	pushl  0x8(%ebx)
c0100d0b:	e8 4a 36 00 00       	call   c010435a <strstr>
c0100d10:	2b 43 08             	sub    0x8(%ebx),%eax
c0100d13:	89 43 0c             	mov    %eax,0xc(%ebx)
    // Hint:
    //  There's a particular stabs type used for line numbers.
    //  Look at the STABS documentation and <inc/stab.h> to find
    //  which one.
    // Your code here.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100d16:	89 34 24             	mov    %esi,(%esp)
c0100d19:	b9 44 00 00 00       	mov    $0x44,%ecx
c0100d1e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0100d21:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100d24:	e8 fa fd ff ff       	call   c0100b23 <stab_binsearch.constprop.0>
    if (rline < lline)
c0100d29:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100d2c:	83 c4 10             	add    $0x10,%esp
c0100d2f:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
c0100d32:	0f 8c 07 ff ff ff    	jl     c0100c3f <debuginfo_eip+0x65>
        return -1;
    info->dbg_line = stabs[lline].n_desc;
c0100d38:	6b c2 0c             	imul   $0xc,%edx,%eax
c0100d3b:	05 00 e0 10 c0       	add    $0xc010e000,%eax
c0100d40:	0f b7 48 06          	movzwl 0x6(%eax),%ecx
c0100d44:	89 4b 04             	mov    %ecx,0x4(%ebx)
    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100d47:	8b 75 d0             	mov    -0x30(%ebp),%esi
c0100d4a:	39 d6                	cmp    %edx,%esi
c0100d4c:	7f 31                	jg     c0100d7f <debuginfo_eip+0x1a5>
            && stabs[lline].n_type != N_SOL
c0100d4e:	8a 48 04             	mov    0x4(%eax),%cl
c0100d51:	80 f9 84             	cmp    $0x84,%cl
c0100d54:	74 11                	je     c0100d67 <debuginfo_eip+0x18d>
            && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
c0100d56:	80 f9 64             	cmp    $0x64,%cl
c0100d59:	74 06                	je     c0100d61 <debuginfo_eip+0x187>
c0100d5b:	4a                   	dec    %edx
c0100d5c:	83 e8 0c             	sub    $0xc,%eax
c0100d5f:	eb e9                	jmp    c0100d4a <debuginfo_eip+0x170>
c0100d61:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
c0100d65:	74 f4                	je     c0100d5b <debuginfo_eip+0x181>
        lline--;
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
c0100d67:	8b 00                	mov    (%eax),%eax
c0100d69:	ba 90 bf 12 c0       	mov    $0xc012bf90,%edx
c0100d6e:	81 ea 35 44 12 c0    	sub    $0xc0124435,%edx
c0100d74:	39 d0                	cmp    %edx,%eax
c0100d76:	7d 07                	jge    c0100d7f <debuginfo_eip+0x1a5>
        info->dbg_file = stabstr + stabs[lline].n_strx;
c0100d78:	05 35 44 12 c0       	add    $0xc0124435,%eax
c0100d7d:	89 03                	mov    %eax,(%ebx)


    // Set dbg_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
c0100d7f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0100d82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100d85:	8d 41 01             	lea    0x1(%ecx),%eax
c0100d88:	39 d1                	cmp    %edx,%ecx
c0100d8a:	7c 14                	jl     c0100da0 <debuginfo_eip+0x1c6>
        for (lline = lfun + 1;
                lline < rfun && stabs[lline].n_type == N_PSYM;
                lline++)
            info->dbg_fn_narg++;

    return 0;
c0100d8c:	31 c0                	xor    %eax,%eax
c0100d8e:	eb 16                	jmp    c0100da6 <debuginfo_eip+0x1cc>
c0100d90:	40                   	inc    %eax

    // Set dbg_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
        for (lline = lfun + 1;
                lline < rfun && stabs[lline].n_type == N_PSYM;
c0100d91:	6b c8 0c             	imul   $0xc,%eax,%ecx
c0100d94:	80 b9 f8 df 10 c0 a0 	cmpb   $0xa0,-0x3fef2008(%ecx)
c0100d9b:	75 ef                	jne    c0100d8c <debuginfo_eip+0x1b2>
                lline++)
            info->dbg_fn_narg++;
c0100d9d:	ff 43 14             	incl   0x14(%ebx)


    // Set dbg_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
        for (lline = lfun + 1;
c0100da0:	39 c2                	cmp    %eax,%edx
c0100da2:	7f ec                	jg     c0100d90 <debuginfo_eip+0x1b6>
c0100da4:	eb e6                	jmp    c0100d8c <debuginfo_eip+0x1b2>
                lline < rfun && stabs[lline].n_type == N_PSYM;
                lline++)
            info->dbg_fn_narg++;

    return 0;
}
c0100da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0100da9:	5b                   	pop    %ebx
c0100daa:	5e                   	pop    %esi
c0100dab:	5f                   	pop    %edi
c0100dac:	5d                   	pop    %ebp
c0100dad:	c3                   	ret    

c0100dae <backtrace_regs>:

void
backtrace_regs(struct regs* regs) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	57                   	push   %edi
c0100db2:	56                   	push   %esi
c0100db3:	53                   	push   %ebx
c0100db4:	83 ec 38             	sub    $0x38,%esp
c0100db7:	8b 45 08             	mov    0x8(%ebp),%eax
    uint32_t _ebp[2] = { regs->ebp, regs->eip };
c0100dba:	8b 50 10             	mov    0x10(%eax),%edx
c0100dbd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0100dc0:	8b 40 30             	mov    0x30(%eax),%eax
c0100dc3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    uint32_t* ebp = (uint32_t*) &_ebp;

    print("Stack backtrace:\n");
c0100dc6:	68 8c ae 10 c0       	push   $0xc010ae8c
c0100dcb:	e8 f4 2f 00 00       	call   c0103dc4 <print>
c0100dd0:	83 c4 10             	add    $0x10,%esp
}

void
backtrace_regs(struct regs* regs) {
    uint32_t _ebp[2] = { regs->ebp, regs->eip };
    uint32_t* ebp = (uint32_t*) &_ebp;
c0100dd3:	8d 5d c8             	lea    -0x38(%ebp),%ebx

    print("Stack backtrace:\n");
    while(ebp != NULL) {
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
c0100dd6:	8d 7d d0             	lea    -0x30(%ebp),%edi
c0100dd9:	51                   	push   %ecx
c0100dda:	51                   	push   %ecx
c0100ddb:	57                   	push   %edi
c0100ddc:	ff 73 04             	pushl  0x4(%ebx)
c0100ddf:	e8 f6 fd ff ff       	call   c0100bda <debuginfo_eip>
        print("\tebp %08x eip %08x args[%u]",
c0100de4:	ff 75 e4             	pushl  -0x1c(%ebp)
c0100de7:	ff 73 04             	pushl  0x4(%ebx)
c0100dea:	53                   	push   %ebx
c0100deb:	68 9e ae 10 c0       	push   $0xc010ae9e
c0100df0:	e8 cf 2f 00 00       	call   c0103dc4 <print>
              ebp, ebp[1], info.dbg_fn_narg);
        for (int i = 0; i < info.dbg_fn_narg; ++i)
c0100df5:	83 c4 20             	add    $0x20,%esp
c0100df8:	31 f6                	xor    %esi,%esi
c0100dfa:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
c0100dfd:	7d 16                	jge    c0100e15 <backtrace_regs+0x67>
            print(" %08x", ebp[2 + i]);
c0100dff:	52                   	push   %edx
c0100e00:	52                   	push   %edx
c0100e01:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
c0100e05:	68 32 b1 10 c0       	push   $0xc010b132
c0100e0a:	e8 b5 2f 00 00       	call   c0103dc4 <print>
    while(ebp != NULL) {
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
        print("\tebp %08x eip %08x args[%u]",
              ebp, ebp[1], info.dbg_fn_narg);
        for (int i = 0; i < info.dbg_fn_narg; ++i)
c0100e0f:	46                   	inc    %esi
c0100e10:	83 c4 10             	add    $0x10,%esp
c0100e13:	eb e5                	jmp    c0100dfa <backtrace_regs+0x4c>
            print(" %08x", ebp[2 + i]);
        print("\n");
c0100e15:	83 ec 0c             	sub    $0xc,%esp
c0100e18:	68 c9 ae 10 c0       	push   $0xc010aec9
c0100e1d:	e8 a2 2f 00 00       	call   c0103dc4 <print>
        print("\t\t%s:%d %.*s()\n\n",
c0100e22:	58                   	pop    %eax
c0100e23:	ff 75 d8             	pushl  -0x28(%ebp)
c0100e26:	ff 75 dc             	pushl  -0x24(%ebp)
c0100e29:	ff 75 d4             	pushl  -0x2c(%ebp)
c0100e2c:	ff 75 d0             	pushl  -0x30(%ebp)
c0100e2f:	68 ba ae 10 c0       	push   $0xc010aeba
c0100e34:	e8 8b 2f 00 00       	call   c0103dc4 <print>
              info.dbg_file, info.dbg_line,
              info.dbg_fn_namelen, info.dbg_fn_name);
        ebp = (uint32_t*) ebp[0];
c0100e39:	8b 1b                	mov    (%ebx),%ebx
backtrace_regs(struct regs* regs) {
    uint32_t _ebp[2] = { regs->ebp, regs->eip };
    uint32_t* ebp = (uint32_t*) &_ebp;

    print("Stack backtrace:\n");
    while(ebp != NULL) {
c0100e3b:	83 c4 20             	add    $0x20,%esp
c0100e3e:	85 db                	test   %ebx,%ebx
c0100e40:	75 97                	jne    c0100dd9 <backtrace_regs+0x2b>
        print("\t\t%s:%d %.*s()\n\n",
              info.dbg_file, info.dbg_line,
              info.dbg_fn_namelen, info.dbg_fn_name);
        ebp = (uint32_t*) ebp[0];
    }
}
c0100e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0100e45:	5b                   	pop    %ebx
c0100e46:	5e                   	pop    %esi
c0100e47:	5f                   	pop    %edi
c0100e48:	5d                   	pop    %ebp
c0100e49:	c3                   	ret    

c0100e4a <backtrace>:

void
backtrace(void) {
c0100e4a:	55                   	push   %ebp
c0100e4b:	89 e5                	mov    %esp,%ebp
c0100e4d:	57                   	push   %edi
c0100e4e:	56                   	push   %esi
c0100e4f:	53                   	push   %ebx
c0100e50:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile("movl %%ebp,%0" : "=r" (ebp));
c0100e53:	89 eb                	mov    %ebp,%ebx
    uint32_t* ebp = (uint32_t*) read_ebp();

    print("Stack backtrace:\n");
c0100e55:	68 8c ae 10 c0       	push   $0xc010ae8c
c0100e5a:	e8 65 2f 00 00       	call   c0103dc4 <print>
    while(ebp != NULL) {
c0100e5f:	83 c4 10             	add    $0x10,%esp
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
c0100e62:	8d 7d d0             	lea    -0x30(%ebp),%edi
void
backtrace(void) {
    uint32_t* ebp = (uint32_t*) read_ebp();

    print("Stack backtrace:\n");
    while(ebp != NULL) {
c0100e65:	85 db                	test   %ebx,%ebx
c0100e67:	74 67                	je     c0100ed0 <backtrace+0x86>
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
c0100e69:	51                   	push   %ecx
c0100e6a:	51                   	push   %ecx
c0100e6b:	57                   	push   %edi
c0100e6c:	ff 73 04             	pushl  0x4(%ebx)
c0100e6f:	e8 66 fd ff ff       	call   c0100bda <debuginfo_eip>
        print("\tebp %08x eip %08x args[%u]",
c0100e74:	ff 75 e4             	pushl  -0x1c(%ebp)
c0100e77:	ff 73 04             	pushl  0x4(%ebx)
c0100e7a:	53                   	push   %ebx
c0100e7b:	68 9e ae 10 c0       	push   $0xc010ae9e
c0100e80:	e8 3f 2f 00 00       	call   c0103dc4 <print>
              ebp, ebp[1], info.dbg_fn_narg);
        for (int i = 0; i < info.dbg_fn_narg; ++i)
c0100e85:	83 c4 20             	add    $0x20,%esp
c0100e88:	31 f6                	xor    %esi,%esi
c0100e8a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
c0100e8d:	7d 16                	jge    c0100ea5 <backtrace+0x5b>
            print(" %08x", ebp[2 + i]);
c0100e8f:	52                   	push   %edx
c0100e90:	52                   	push   %edx
c0100e91:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
c0100e95:	68 32 b1 10 c0       	push   $0xc010b132
c0100e9a:	e8 25 2f 00 00       	call   c0103dc4 <print>
    while(ebp != NULL) {
        struct debuginfo info;
        debuginfo_eip(ebp[1], &info);
        print("\tebp %08x eip %08x args[%u]",
              ebp, ebp[1], info.dbg_fn_narg);
        for (int i = 0; i < info.dbg_fn_narg; ++i)
c0100e9f:	46                   	inc    %esi
c0100ea0:	83 c4 10             	add    $0x10,%esp
c0100ea3:	eb e5                	jmp    c0100e8a <backtrace+0x40>
            print(" %08x", ebp[2 + i]);
        print("\n");
c0100ea5:	83 ec 0c             	sub    $0xc,%esp
c0100ea8:	68 c9 ae 10 c0       	push   $0xc010aec9
c0100ead:	e8 12 2f 00 00       	call   c0103dc4 <print>
        print("\t\t%s:%d %.*s()\n\n",
c0100eb2:	58                   	pop    %eax
c0100eb3:	ff 75 d8             	pushl  -0x28(%ebp)
c0100eb6:	ff 75 dc             	pushl  -0x24(%ebp)
c0100eb9:	ff 75 d4             	pushl  -0x2c(%ebp)
c0100ebc:	ff 75 d0             	pushl  -0x30(%ebp)
c0100ebf:	68 ba ae 10 c0       	push   $0xc010aeba
c0100ec4:	e8 fb 2e 00 00       	call   c0103dc4 <print>
              info.dbg_file, info.dbg_line,
              info.dbg_fn_namelen, info.dbg_fn_name);
        ebp = (uint32_t*) ebp[0];
c0100ec9:	8b 1b                	mov    (%ebx),%ebx
c0100ecb:	83 c4 20             	add    $0x20,%esp
c0100ece:	eb 95                	jmp    c0100e65 <backtrace+0x1b>
    }
}
c0100ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0100ed3:	5b                   	pop    %ebx
c0100ed4:	5e                   	pop    %esi
c0100ed5:	5f                   	pop    %edi
c0100ed6:	5d                   	pop    %ebp
c0100ed7:	c3                   	ret    

c0100ed8 <print_regs>:

void
print_regs(struct regs* r) {
c0100ed8:	55                   	push   %ebp
c0100ed9:	89 e5                	mov    %esp,%ebp
c0100edb:	53                   	push   %ebx
c0100edc:	50                   	push   %eax
c0100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (r == NULL)
c0100ee0:	85 db                	test   %ebx,%ebx
c0100ee2:	75 10                	jne    c0100ef4 <print_regs+0x1c>
        print("NULL");
c0100ee4:	c7 45 08 d3 c8 10 c0 	movl   $0xc010c8d3,0x8(%ebp)
        print("\tcs     : 0x%x\n", r->cs);
        print("\teflags : 0x%08x\n", r->eflags);
        print("\tesp    : %p\n", r->esp);
        print("\tss     : 0x%x\n", r->ss);
    }
}
c0100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100eee:	c9                   	leave  
}

void
print_regs(struct regs* r) {
    if (r == NULL)
        print("NULL");
c0100eef:	e9 d0 2e 00 00       	jmp    c0103dc4 <print>
    else {
        print("regs: %08p\n", r);
c0100ef4:	50                   	push   %eax
c0100ef5:	50                   	push   %eax
c0100ef6:	53                   	push   %ebx
c0100ef7:	68 cb ae 10 c0       	push   $0xc010aecb
c0100efc:	e8 c3 2e 00 00       	call   c0103dc4 <print>
        print("\tes     : 0x%x\n", r->es);
c0100f01:	5a                   	pop    %edx
c0100f02:	59                   	pop    %ecx
c0100f03:	ff 33                	pushl  (%ebx)
c0100f05:	68 d7 ae 10 c0       	push   $0xc010aed7
c0100f0a:	e8 b5 2e 00 00       	call   c0103dc4 <print>
        print("\tds     : 0x%x\n", r->ds);
c0100f0f:	58                   	pop    %eax
c0100f10:	5a                   	pop    %edx
c0100f11:	ff 73 04             	pushl  0x4(%ebx)
c0100f14:	68 e7 ae 10 c0       	push   $0xc010aee7
c0100f19:	e8 a6 2e 00 00       	call   c0103dc4 <print>
        print("\tedi    : %p\n", r->edi);
c0100f1e:	59                   	pop    %ecx
c0100f1f:	58                   	pop    %eax
c0100f20:	ff 73 08             	pushl  0x8(%ebx)
c0100f23:	68 f7 ae 10 c0       	push   $0xc010aef7
c0100f28:	e8 97 2e 00 00       	call   c0103dc4 <print>
        print("\tesi    : %p\n", r->esi);
c0100f2d:	58                   	pop    %eax
c0100f2e:	5a                   	pop    %edx
c0100f2f:	ff 73 0c             	pushl  0xc(%ebx)
c0100f32:	68 05 af 10 c0       	push   $0xc010af05
c0100f37:	e8 88 2e 00 00       	call   c0103dc4 <print>
        print("\tebp    : %p\n", r->ebp);
c0100f3c:	59                   	pop    %ecx
c0100f3d:	58                   	pop    %eax
c0100f3e:	ff 73 10             	pushl  0x10(%ebx)
c0100f41:	68 13 af 10 c0       	push   $0xc010af13
c0100f46:	e8 79 2e 00 00       	call   c0103dc4 <print>
        print("\t_esp   : %p\n", r->_esp);
c0100f4b:	58                   	pop    %eax
c0100f4c:	5a                   	pop    %edx
c0100f4d:	ff 73 14             	pushl  0x14(%ebx)
c0100f50:	68 21 af 10 c0       	push   $0xc010af21
c0100f55:	e8 6a 2e 00 00       	call   c0103dc4 <print>
        print("\tebx    : %p\n", r->ebx);
c0100f5a:	59                   	pop    %ecx
c0100f5b:	58                   	pop    %eax
c0100f5c:	ff 73 18             	pushl  0x18(%ebx)
c0100f5f:	68 2f af 10 c0       	push   $0xc010af2f
c0100f64:	e8 5b 2e 00 00       	call   c0103dc4 <print>
        print("\tedx    : %p\n", r->edx);
c0100f69:	58                   	pop    %eax
c0100f6a:	5a                   	pop    %edx
c0100f6b:	ff 73 1c             	pushl  0x1c(%ebx)
c0100f6e:	68 3d af 10 c0       	push   $0xc010af3d
c0100f73:	e8 4c 2e 00 00       	call   c0103dc4 <print>
        print("\tecx    : %p\n", r->ecx);
c0100f78:	59                   	pop    %ecx
c0100f79:	58                   	pop    %eax
c0100f7a:	ff 73 20             	pushl  0x20(%ebx)
c0100f7d:	68 4b af 10 c0       	push   $0xc010af4b
c0100f82:	e8 3d 2e 00 00       	call   c0103dc4 <print>
        print("\teax    : %p\n", r->eax);
c0100f87:	58                   	pop    %eax
c0100f88:	5a                   	pop    %edx
c0100f89:	ff 73 24             	pushl  0x24(%ebx)
c0100f8c:	68 59 af 10 c0       	push   $0xc010af59
c0100f91:	e8 2e 2e 00 00       	call   c0103dc4 <print>
        print("\tintno  : %u\n", r->int_no);
c0100f96:	59                   	pop    %ecx
c0100f97:	58                   	pop    %eax
c0100f98:	ff 73 28             	pushl  0x28(%ebx)
c0100f9b:	68 67 af 10 c0       	push   $0xc010af67
c0100fa0:	e8 1f 2e 00 00       	call   c0103dc4 <print>
        print("\tecode  : %u\n", r->err_code);
c0100fa5:	58                   	pop    %eax
c0100fa6:	5a                   	pop    %edx
c0100fa7:	ff 73 2c             	pushl  0x2c(%ebx)
c0100faa:	68 75 af 10 c0       	push   $0xc010af75
c0100faf:	e8 10 2e 00 00       	call   c0103dc4 <print>
        print("\teip    : %p\n", r->eip);
c0100fb4:	59                   	pop    %ecx
c0100fb5:	58                   	pop    %eax
c0100fb6:	ff 73 30             	pushl  0x30(%ebx)
c0100fb9:	68 83 af 10 c0       	push   $0xc010af83
c0100fbe:	e8 01 2e 00 00       	call   c0103dc4 <print>
        print("\tcs     : 0x%x\n", r->cs);
c0100fc3:	58                   	pop    %eax
c0100fc4:	5a                   	pop    %edx
c0100fc5:	ff 73 34             	pushl  0x34(%ebx)
c0100fc8:	68 91 af 10 c0       	push   $0xc010af91
c0100fcd:	e8 f2 2d 00 00       	call   c0103dc4 <print>
        print("\teflags : 0x%08x\n", r->eflags);
c0100fd2:	59                   	pop    %ecx
c0100fd3:	58                   	pop    %eax
c0100fd4:	ff 73 38             	pushl  0x38(%ebx)
c0100fd7:	68 a1 af 10 c0       	push   $0xc010afa1
c0100fdc:	e8 e3 2d 00 00       	call   c0103dc4 <print>
        print("\tesp    : %p\n", r->esp);
c0100fe1:	58                   	pop    %eax
c0100fe2:	5a                   	pop    %edx
c0100fe3:	ff 73 3c             	pushl  0x3c(%ebx)
c0100fe6:	68 b3 af 10 c0       	push   $0xc010afb3
c0100feb:	e8 d4 2d 00 00       	call   c0103dc4 <print>
        print("\tss     : 0x%x\n", r->ss);
c0100ff0:	59                   	pop    %ecx
c0100ff1:	58                   	pop    %eax
c0100ff2:	ff 73 40             	pushl  0x40(%ebx)
c0100ff5:	68 c1 af 10 c0       	push   $0xc010afc1
c0100ffa:	e8 c5 2d 00 00       	call   c0103dc4 <print>
c0100fff:	83 c4 10             	add    $0x10,%esp
    }
}
c0101002:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101005:	c9                   	leave  
c0101006:	c3                   	ret    

c0101007 <init_pmm>:
#include <vmm.h>

struct bitmap* physmap;

void
init_pmm(void) {
c0101007:	55                   	push   %ebp
c0101008:	89 e5                	mov    %esp,%ebp
c010100a:	57                   	push   %edi
c010100b:	56                   	push   %esi
c010100c:	53                   	push   %ebx
c010100d:	83 ec 1c             	sub    $0x1c,%esp
    size_t ram = 0;

    struct e820_e* e;
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e)
c0101010:	6b 1d 00 7c 13 c0 14 	imul   $0x14,0xc0137c00,%ebx
c0101017:	81 c3 00 77 13 c0    	add    $0xc0137700,%ebx
c010101d:	ba 00 77 13 c0       	mov    $0xc0137700,%edx

struct bitmap* physmap;

void
init_pmm(void) {
    size_t ram = 0;
c0101022:	31 c0                	xor    %eax,%eax

    struct e820_e* e;
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e)
c0101024:	39 da                	cmp    %ebx,%edx
c0101026:	74 10                	je     c0101038 <init_pmm+0x31>
        ram = MAX(ram, (size_t)(e->addr + e->len));
c0101028:	8b 4a 08             	mov    0x8(%edx),%ecx
c010102b:	03 0a                	add    (%edx),%ecx
c010102d:	39 c8                	cmp    %ecx,%eax
c010102f:	73 02                	jae    c0101033 <init_pmm+0x2c>
c0101031:	89 c8                	mov    %ecx,%eax
void
init_pmm(void) {
    size_t ram = 0;

    struct e820_e* e;
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e)
c0101033:	83 c2 14             	add    $0x14,%edx
c0101036:	eb ec                	jmp    c0101024 <init_pmm+0x1d>
        ram = MAX(ram, (size_t)(e->addr + e->len));
    npages = ram >> PG_NBITS;
c0101038:	c1 e8 0c             	shr    $0xc,%eax
c010103b:	a3 88 6e 13 c0       	mov    %eax,0xc0136e88
    physmap = bitmap_create(npages);
c0101040:	83 ec 0c             	sub    $0xc,%esp
c0101043:	50                   	push   %eax
c0101044:	e8 ec 3e 00 00       	call   c0104f35 <bitmap_create>
c0101049:	a3 c0 76 13 c0       	mov    %eax,0xc01376c0
    for (size_t i = 0; i < npages; ++i) {
c010104e:	83 c4 10             	add    $0x10,%esp
c0101051:	31 db                	xor    %ebx,%ebx
c0101053:	3b 1d 88 6e 13 c0    	cmp    0xc0136e88,%ebx
c0101059:	73 51                	jae    c01010ac <init_pmm+0xa5>
        assert(!bitmap_isset(physmap, i));
c010105b:	56                   	push   %esi
c010105c:	56                   	push   %esi
c010105d:	53                   	push   %ebx
c010105e:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c0101064:	e8 9b 41 00 00       	call   c0105204 <bitmap_isset>
c0101069:	83 c4 10             	add    $0x10,%esp
c010106c:	84 c0                	test   %al,%al
c010106e:	74 28                	je     c0101098 <init_pmm+0x91>
c0101070:	83 ec 0c             	sub    $0xc,%esp
c0101073:	68 c4 b0 10 c0       	push   $0xc010b0c4
c0101078:	6a 14                	push   $0x14
c010107a:	68 e2 af 10 c0       	push   $0xc010afe2
c010107f:	68 ec af 10 c0       	push   $0xc010afec
c0101084:	68 95 a9 10 c0       	push   $0xc010a995
c0101089:	e8 36 2d 00 00       	call   c0103dc4 <print>
c010108e:	83 c4 20             	add    $0x20,%esp
c0101091:	e8 b4 fd ff ff       	call   c0100e4a <backtrace>
c0101096:	fa                   	cli    
c0101097:	f4                   	hlt    
        bitmap_mark(physmap, i);
c0101098:	51                   	push   %ecx
c0101099:	51                   	push   %ecx
c010109a:	53                   	push   %ebx
c010109b:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c01010a1:	e8 44 40 00 00       	call   c01050ea <bitmap_mark>
    struct e820_e* e;
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e)
        ram = MAX(ram, (size_t)(e->addr + e->len));
    npages = ram >> PG_NBITS;
    physmap = bitmap_create(npages);
    for (size_t i = 0; i < npages; ++i) {
c01010a6:	43                   	inc    %ebx
c01010a7:	83 c4 10             	add    $0x10,%esp
c01010aa:	eb a7                	jmp    c0101053 <init_pmm+0x4c>
c01010ac:	b8 00 77 13 c0       	mov    $0xc0137700,%eax
    }

    extern size_t _kbrk;
    // Mark any pages with an E820_AVAILABLE entry in the e820 map as free
    // note: assumes that the e820 map references non-overlapping regions
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e) {
c01010b1:	6b 15 00 7c 13 c0 14 	imul   $0x14,0xc0137c00,%edx
c01010b8:	81 c2 00 77 13 c0    	add    $0xc0137700,%edx
c01010be:	39 d0                	cmp    %edx,%eax
c01010c0:	0f 84 96 00 00 00    	je     c010115c <init_pmm+0x155>
        if (e->type == E820_AVAILABLE) {
c01010c6:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
c01010ca:	74 05                	je     c01010d1 <init_pmm+0xca>
    }

    extern size_t _kbrk;
    // Mark any pages with an E820_AVAILABLE entry in the e820 map as free
    // note: assumes that the e820 map references non-overlapping regions
    for (e = e820_map.entries; e != e820_map.entries + e820_map.size; ++e) {
c01010cc:	83 c0 14             	add    $0x14,%eax
c01010cf:	eb e0                	jmp    c01010b1 <init_pmm+0xaa>
        if (e->type == E820_AVAILABLE) {
            size_t min_page = MAX(PA2PM(e->addr), 1U);
c01010d1:	8b 18                	mov    (%eax),%ebx
c01010d3:	89 de                	mov    %ebx,%esi
c01010d5:	c1 ee 0c             	shr    $0xc,%esi
c01010d8:	75 05                	jne    c01010df <init_pmm+0xd8>
c01010da:	be 01 00 00 00       	mov    $0x1,%esi
            if (min_page >= npages)
c01010df:	8b 15 88 6e 13 c0    	mov    0xc0136e88,%edx
c01010e5:	39 d6                	cmp    %edx,%esi
c01010e7:	73 e3                	jae    c01010cc <init_pmm+0xc5>
                continue;
            size_t max_page = MIN(PA2PM(e->addr + e->len) + 1, npages);
c01010e9:	03 58 08             	add    0x8(%eax),%ebx
c01010ec:	c1 eb 0c             	shr    $0xc,%ebx
c01010ef:	43                   	inc    %ebx
c01010f0:	39 d3                	cmp    %edx,%ebx
c01010f2:	76 5f                	jbe    c0101153 <init_pmm+0x14c>
c01010f4:	89 d3                	mov    %edx,%ebx
            for (size_t i = min_page; i < max_page; ++i) {
c01010f6:	eb 5b                	jmp    c0101153 <init_pmm+0x14c>
                if (i >= PA2PM(PADDR(KADDR)) && i < PA2PM(PADDR(_kbrk)))
c01010f8:	8b 3d c4 76 13 c0    	mov    0xc01376c4,%edi

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
c01010fe:	81 ff ff ff ff bf    	cmp    $0xbfffffff,%edi
c0101104:	77 28                	ja     c010112e <init_pmm+0x127>
c0101106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        panic(file, line, "PADDR called with invalid va %08x", va);
c0101109:	52                   	push   %edx
c010110a:	57                   	push   %edi
c010110b:	68 06 b0 10 c0       	push   $0xc010b006
c0101110:	6a 22                	push   $0x22
c0101112:	68 e2 af 10 c0       	push   $0xc010afe2
c0101117:	68 bc b0 10 c0       	push   $0xc010b0bc
c010111c:	6a 38                	push   $0x38
c010111e:	68 28 b0 10 c0       	push   $0xc010b028
c0101123:	e8 1a 28 00 00       	call   c0103942 <_panic>
c0101128:	83 c4 20             	add    $0x20,%esp
c010112b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010112e:	81 c7 00 00 00 40    	add    $0x40000000,%edi
c0101134:	c1 ef 0c             	shr    $0xc,%edi
c0101137:	39 fe                	cmp    %edi,%esi
c0101139:	72 17                	jb     c0101152 <init_pmm+0x14b>
c010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    continue;
                bitmap_unmark(physmap, i);
c010113e:	50                   	push   %eax
c010113f:	50                   	push   %eax
c0101140:	56                   	push   %esi
c0101141:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c0101147:	e8 2d 40 00 00       	call   c0105179 <bitmap_unmark>
c010114c:	83 c4 10             	add    $0x10,%esp
c010114f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        if (e->type == E820_AVAILABLE) {
            size_t min_page = MAX(PA2PM(e->addr), 1U);
            if (min_page >= npages)
                continue;
            size_t max_page = MIN(PA2PM(e->addr + e->len) + 1, npages);
            for (size_t i = min_page; i < max_page; ++i) {
c0101152:	46                   	inc    %esi
c0101153:	39 de                	cmp    %ebx,%esi
c0101155:	72 a1                	jb     c01010f8 <init_pmm+0xf1>
c0101157:	e9 70 ff ff ff       	jmp    c01010cc <init_pmm+0xc5>
                    continue;
                bitmap_unmark(physmap, i);
            }
        }
    }
}
c010115c:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010115f:	5b                   	pop    %ebx
c0101160:	5e                   	pop    %esi
c0101161:	5f                   	pop    %edi
c0101162:	5d                   	pop    %ebp
c0101163:	c3                   	ret    

c0101164 <pp_alloc>:

size_t
pp_alloc(void) {
c0101164:	55                   	push   %ebp
c0101165:	89 e5                	mov    %esp,%ebp
c0101167:	83 ec 20             	sub    $0x20,%esp
    size_t idx = 0;
c010116a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (bitmap_alloc(physmap, &idx) == ENOSPC)
c0101171:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0101174:	50                   	push   %eax
c0101175:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c010117b:	e8 be 3e 00 00       	call   c010503e <bitmap_alloc>
c0101180:	83 c4 10             	add    $0x10,%esp
c0101183:	83 f8 05             	cmp    $0x5,%eax
c0101186:	75 19                	jne    c01011a1 <pp_alloc+0x3d>
        panic("out of physical memory npages");
c0101188:	68 34 b0 10 c0       	push   $0xc010b034
c010118d:	68 b0 b0 10 c0       	push   $0xc010b0b0
c0101192:	6a 2e                	push   $0x2e
c0101194:	68 e2 af 10 c0       	push   $0xc010afe2
c0101199:	e8 a4 27 00 00       	call   c0103942 <_panic>
c010119e:	83 c4 10             	add    $0x10,%esp

    memset(PM2VA(idx), 0, PG_SIZE);
c01011a1:	50                   	push   %eax
c01011a2:	68 00 10 00 00       	push   $0x1000
c01011a7:	6a 00                	push   $0x0
c01011a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01011ac:	c1 e0 0c             	shl    $0xc,%eax
c01011af:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01011b4:	50                   	push   %eax
c01011b5:	e8 02 33 00 00       	call   c01044bc <memset>

    return idx;
}
c01011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01011bd:	c9                   	leave  
c01011be:	c3                   	ret    

c01011bf <pp_free>:

void
pp_free(void* pa) {
c01011bf:	55                   	push   %ebp
c01011c0:	89 e5                	mov    %esp,%ebp
c01011c2:	53                   	push   %ebx
c01011c3:	51                   	push   %ecx
    size_t idx = (size_t) pa >> PG_NBITS;
c01011c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01011c7:	c1 eb 0c             	shr    $0xc,%ebx

    assert(idx < npages);
c01011ca:	3b 1d 88 6e 13 c0    	cmp    0xc0136e88,%ebx
c01011d0:	72 28                	jb     c01011fa <pp_free+0x3b>
c01011d2:	83 ec 0c             	sub    $0xc,%esp
c01011d5:	68 a8 b0 10 c0       	push   $0xc010b0a8
c01011da:	6a 39                	push   $0x39
c01011dc:	68 e2 af 10 c0       	push   $0xc010afe2
c01011e1:	68 52 b0 10 c0       	push   $0xc010b052
c01011e6:	68 95 a9 10 c0       	push   $0xc010a995
c01011eb:	e8 d4 2b 00 00       	call   c0103dc4 <print>
c01011f0:	83 c4 20             	add    $0x20,%esp
c01011f3:	e8 52 fc ff ff       	call   c0100e4a <backtrace>
c01011f8:	fa                   	cli    
c01011f9:	f4                   	hlt    
    assert(bitmap_isset(physmap, idx));
c01011fa:	52                   	push   %edx
c01011fb:	52                   	push   %edx
c01011fc:	53                   	push   %ebx
c01011fd:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c0101203:	e8 fc 3f 00 00       	call   c0105204 <bitmap_isset>
c0101208:	83 c4 10             	add    $0x10,%esp
c010120b:	84 c0                	test   %al,%al
c010120d:	75 28                	jne    c0101237 <pp_free+0x78>
c010120f:	83 ec 0c             	sub    $0xc,%esp
c0101212:	68 a8 b0 10 c0       	push   $0xc010b0a8
c0101217:	6a 3a                	push   $0x3a
c0101219:	68 e2 af 10 c0       	push   $0xc010afe2
c010121e:	68 7f b0 10 c0       	push   $0xc010b07f
c0101223:	68 95 a9 10 c0       	push   $0xc010a995
c0101228:	e8 97 2b 00 00       	call   c0103dc4 <print>
c010122d:	83 c4 20             	add    $0x20,%esp
c0101230:	e8 15 fc ff ff       	call   c0100e4a <backtrace>
c0101235:	fa                   	cli    
c0101236:	f4                   	hlt    

    bitmap_unmark(physmap, idx);
c0101237:	50                   	push   %eax
c0101238:	50                   	push   %eax
c0101239:	53                   	push   %ebx
c010123a:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c0101240:	e8 34 3f 00 00       	call   c0105179 <bitmap_unmark>
}
c0101245:	83 c4 10             	add    $0x10,%esp
c0101248:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010124b:	c9                   	leave  
c010124c:	c3                   	ret    

c010124d <pa_alloc>:

void
pa_alloc(size_t pa) {
c010124d:	55                   	push   %ebp
c010124e:	89 e5                	mov    %esp,%ebp
c0101250:	53                   	push   %ebx
c0101251:	50                   	push   %eax
    size_t idx = pa >> PG_NBITS;
c0101252:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101255:	c1 eb 0c             	shr    $0xc,%ebx

    assert(idx < npages);
c0101258:	3b 1d 88 6e 13 c0    	cmp    0xc0136e88,%ebx
c010125e:	72 28                	jb     c0101288 <pa_alloc+0x3b>
c0101260:	83 ec 0c             	sub    $0xc,%esp
c0101263:	68 9c b0 10 c0       	push   $0xc010b09c
c0101268:	6a 43                	push   $0x43
c010126a:	68 e2 af 10 c0       	push   $0xc010afe2
c010126f:	68 52 b0 10 c0       	push   $0xc010b052
c0101274:	68 95 a9 10 c0       	push   $0xc010a995
c0101279:	e8 46 2b 00 00       	call   c0103dc4 <print>
c010127e:	83 c4 20             	add    $0x20,%esp
c0101281:	e8 c4 fb ff ff       	call   c0100e4a <backtrace>
c0101286:	fa                   	cli    
c0101287:	f4                   	hlt    
    assert(bitmap_isset(physmap, idx - 1));
c0101288:	50                   	push   %eax
c0101289:	50                   	push   %eax
c010128a:	8d 43 ff             	lea    -0x1(%ebx),%eax
c010128d:	50                   	push   %eax
c010128e:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c0101294:	e8 6b 3f 00 00       	call   c0105204 <bitmap_isset>
c0101299:	83 c4 10             	add    $0x10,%esp
c010129c:	84 c0                	test   %al,%al
c010129e:	75 28                	jne    c01012c8 <pa_alloc+0x7b>
c01012a0:	83 ec 0c             	sub    $0xc,%esp
c01012a3:	68 9c b0 10 c0       	push   $0xc010b09c
c01012a8:	6a 44                	push   $0x44
c01012aa:	68 e2 af 10 c0       	push   $0xc010afe2
c01012af:	68 5f b0 10 c0       	push   $0xc010b05f
c01012b4:	68 95 a9 10 c0       	push   $0xc010a995
c01012b9:	e8 06 2b 00 00       	call   c0103dc4 <print>
c01012be:	83 c4 20             	add    $0x20,%esp
c01012c1:	e8 84 fb ff ff       	call   c0100e4a <backtrace>
c01012c6:	fa                   	cli    
c01012c7:	f4                   	hlt    
    assert(!bitmap_isset(physmap, idx));
c01012c8:	50                   	push   %eax
c01012c9:	50                   	push   %eax
c01012ca:	53                   	push   %ebx
c01012cb:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c01012d1:	e8 2e 3f 00 00       	call   c0105204 <bitmap_isset>
c01012d6:	83 c4 10             	add    $0x10,%esp
c01012d9:	84 c0                	test   %al,%al
c01012db:	74 28                	je     c0101305 <pa_alloc+0xb8>
c01012dd:	83 ec 0c             	sub    $0xc,%esp
c01012e0:	68 9c b0 10 c0       	push   $0xc010b09c
c01012e5:	6a 45                	push   $0x45
c01012e7:	68 e2 af 10 c0       	push   $0xc010afe2
c01012ec:	68 7e b0 10 c0       	push   $0xc010b07e
c01012f1:	68 95 a9 10 c0       	push   $0xc010a995
c01012f6:	e8 c9 2a 00 00       	call   c0103dc4 <print>
c01012fb:	83 c4 20             	add    $0x20,%esp
c01012fe:	e8 47 fb ff ff       	call   c0100e4a <backtrace>
c0101303:	fa                   	cli    
c0101304:	f4                   	hlt    

    memset(PM2VA(idx), 0, PG_SIZE);
c0101305:	50                   	push   %eax
c0101306:	68 00 10 00 00       	push   $0x1000
c010130b:	6a 00                	push   $0x0
c010130d:	89 d8                	mov    %ebx,%eax
c010130f:	c1 e0 0c             	shl    $0xc,%eax
c0101312:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0101317:	50                   	push   %eax
c0101318:	e8 9f 31 00 00       	call   c01044bc <memset>

    bitmap_mark(physmap, idx);
c010131d:	5a                   	pop    %edx
c010131e:	59                   	pop    %ecx
c010131f:	53                   	push   %ebx
c0101320:	ff 35 c0 76 13 c0    	pushl  0xc01376c0
c0101326:	e8 bf 3d 00 00       	call   c01050ea <bitmap_mark>
}
c010132b:	83 c4 10             	add    $0x10,%esp
c010132e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101331:	c9                   	leave  
c0101332:	c3                   	ret    

c0101333 <init_kmm>:

extern size_t kbrk_max;
size_t _kbrk;

void
init_kmm(void) {
c0101333:	55                   	push   %ebp
c0101334:	89 e5                	mov    %esp,%ebp
c0101336:	83 ec 08             	sub    $0x8,%esp
    init_mm();
c0101339:	e8 12 05 00 00       	call   c0101850 <init_mm>
    _kbrk = kbrk_max;
c010133e:	a1 c8 76 13 c0       	mov    0xc01376c8,%eax
c0101343:	a3 c4 76 13 c0       	mov    %eax,0xc01376c4
    kbrk_max = ROUNDDOWN(kbrk_max, PG_SIZE);
c0101348:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010134d:	a3 c8 76 13 c0       	mov    %eax,0xc01376c8
}
c0101352:	c9                   	leave  
c0101353:	c3                   	ret    

c0101354 <kalign>:

void*
kalign(size_t nbytes) {
c0101354:	55                   	push   %ebp
c0101355:	89 e5                	mov    %esp,%ebp
c0101357:	53                   	push   %ebx
c0101358:	83 ec 08             	sub    $0x8,%esp
c010135b:	8b 45 08             	mov    0x8(%ebp),%eax
    size_t kptr = ROUNDDOWN(kbrk_max - nbytes, PG_SIZE);
c010135e:	8b 1d c8 76 13 c0    	mov    0xc01376c8,%ebx
c0101364:	29 c3                	sub    %eax,%ebx
c0101366:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    kbrk_max = kptr;
c010136c:	89 1d c8 76 13 c0    	mov    %ebx,0xc01376c8
    memset((void*) kptr, 0, nbytes);
c0101372:	50                   	push   %eax
c0101373:	6a 00                	push   $0x0
c0101375:	53                   	push   %ebx
c0101376:	e8 41 31 00 00       	call   c01044bc <memset>

    return (void*) (kptr);
}
c010137b:	89 d8                	mov    %ebx,%eax
c010137d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101380:	c9                   	leave  
c0101381:	c3                   	ret    

c0101382 <isr_pgfault>:

    return (void*) (base - size);
}

void
isr_pgfault(struct regs* r) {
c0101382:	55                   	push   %ebp
c0101383:	89 e5                	mov    %esp,%ebp
c0101385:	83 ec 10             	sub    $0x10,%esp
}

static inline uint32_t
rcr2(void) {
    uint32_t val;
    asm volatile("movl %%cr2,%0" : "=r" (val));
c0101388:	0f 20 d0             	mov    %cr2,%eax
    (void) r;

    uint32_t fault_addr = rcr2();
    print("fa: %x\n", fault_addr);
c010138b:	50                   	push   %eax
c010138c:	68 cd b0 10 c0       	push   $0xc010b0cd
c0101391:	e8 2e 2a 00 00       	call   c0103dc4 <print>
}
c0101396:	83 c4 10             	add    $0x10,%esp
c0101399:	c9                   	leave  
c010139a:	c3                   	ret    

c010139b <pd_map>:
#include <mboot.h>

extern struct kbitmap* physmap;

struct pte*
pd_map(struct pde* pd, void* va, bool write, bool user) {
c010139b:	55                   	push   %ebp
c010139c:	89 e5                	mov    %esp,%ebp
c010139e:	57                   	push   %edi
c010139f:	56                   	push   %esi
c01013a0:	53                   	push   %ebx
c01013a1:	83 ec 1c             	sub    $0x1c,%esp
c01013a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013a7:	8b 75 10             	mov    0x10(%ebp),%esi
c01013aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
    size_t pdx = PDX(va);
    size_t ptx = PTX(va);
c01013ad:	89 d7                	mov    %edx,%edi
c01013af:	c1 ef 0c             	shr    $0xc,%edi
c01013b2:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
c01013b8:	89 7d e4             	mov    %edi,-0x1c(%ebp)

    if (!pd[pdx].present) {
c01013bb:	c1 ea 16             	shr    $0x16,%edx
c01013be:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c1:	8d 14 90             	lea    (%eax,%edx,4),%edx
c01013c4:	89 d7                	mov    %edx,%edi
c01013c6:	f6 02 01             	testb  $0x1,(%edx)
c01013c9:	75 2b                	jne    c01013f6 <pd_map+0x5b>
        size_t pno = pp_alloc();
c01013cb:	e8 94 fd ff ff       	call   c0101164 <pp_alloc>
        pd[pdx].addr = pno;
c01013d0:	c1 e0 0c             	shl    $0xc,%eax
c01013d3:	8b 0f                	mov    (%edi),%ecx
c01013d5:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
c01013db:	09 c8                	or     %ecx,%eax
c01013dd:	89 07                	mov    %eax,(%edi)
        pd[pdx].present = true;
c01013df:	83 c8 01             	or     $0x1,%eax
        pd[pdx].write = write;
c01013e2:	83 e6 01             	and    $0x1,%esi
c01013e5:	d1 e6                	shl    %esi
c01013e7:	83 e0 f9             	and    $0xfffffff9,%eax
        pd[pdx].user = user;
c01013ea:	83 e3 01             	and    $0x1,%ebx
c01013ed:	c1 e3 02             	shl    $0x2,%ebx
c01013f0:	09 f0                	or     %esi,%eax
c01013f2:	09 d8                	or     %ebx,%eax
c01013f4:	88 07                	mov    %al,(%edi)
    }

    struct pde* pt = PM2VA(pd[pdx].addr);
c01013f6:	8b 07                	mov    (%edi),%eax

    return (struct pte*) (pt + ptx);
c01013f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01013fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0101400:	8d 84 88 00 00 00 c0 	lea    -0x40000000(%eax,%ecx,4),%eax

}
c0101407:	83 c4 1c             	add    $0x1c,%esp
c010140a:	5b                   	pop    %ebx
c010140b:	5e                   	pop    %esi
c010140c:	5f                   	pop    %edi
c010140d:	5d                   	pop    %ebp
c010140e:	c3                   	ret    

c010140f <boot_map>:

void
boot_map(struct pde* pd, void* va, size_t pa, size_t bytes,
         bool write, bool user) {
c010140f:	55                   	push   %ebp
c0101410:	89 e5                	mov    %esp,%ebp
c0101412:	57                   	push   %edi
c0101413:	56                   	push   %esi
c0101414:	53                   	push   %ebx
c0101415:	83 ec 1c             	sub    $0x1c,%esp
c0101418:	8a 4d 18             	mov    0x18(%ebp),%cl
c010141b:	8a 45 1c             	mov    0x1c(%ebp),%al
c010141e:	88 45 e7             	mov    %al,-0x19(%ebp)

    for (size_t i = 0; i < bytes; i += PG_SIZE) {
c0101421:	31 db                	xor    %ebx,%ebx
        struct pte* pg = pd_map(pd, va + i, write, user);
        pg->addr = PA2PM(pa + i);
        pg->present = true;
        pg->write = write;
        pg->user = user;
c0101423:	89 c7                	mov    %eax,%edi
c0101425:	83 e7 01             	and    $0x1,%edi
c0101428:	c1 e7 02             	shl    $0x2,%edi

void
boot_map(struct pde* pd, void* va, size_t pa, size_t bytes,
         bool write, bool user) {

    for (size_t i = 0; i < bytes; i += PG_SIZE) {
c010142b:	3b 5d 14             	cmp    0x14(%ebp),%ebx
c010142e:	73 52                	jae    c0101482 <boot_map+0x73>
        struct pte* pg = pd_map(pd, va + i, write, user);
c0101430:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101434:	50                   	push   %eax
c0101435:	0f b6 c1             	movzbl %cl,%eax
c0101438:	88 4d e6             	mov    %cl,-0x1a(%ebp)
c010143b:	50                   	push   %eax
c010143c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010143f:	01 d8                	add    %ebx,%eax
c0101441:	50                   	push   %eax
c0101442:	ff 75 08             	pushl  0x8(%ebp)
c0101445:	e8 51 ff ff ff       	call   c010139b <pd_map>
        pg->addr = PA2PM(pa + i);
c010144a:	8b 55 10             	mov    0x10(%ebp),%edx
c010144d:	01 da                	add    %ebx,%edx
c010144f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0101455:	8b 30                	mov    (%eax),%esi
c0101457:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
c010145d:	09 f2                	or     %esi,%edx
c010145f:	89 10                	mov    %edx,(%eax)
        pg->present = true;
c0101461:	83 ca 01             	or     $0x1,%edx
        pg->write = write;
c0101464:	8a 4d e6             	mov    -0x1a(%ebp),%cl
c0101467:	89 ce                	mov    %ecx,%esi
c0101469:	83 e6 01             	and    $0x1,%esi
c010146c:	d1 e6                	shl    %esi
c010146e:	83 e2 f9             	and    $0xfffffff9,%edx
        pg->user = user;
c0101471:	09 f2                	or     %esi,%edx
c0101473:	09 fa                	or     %edi,%edx
c0101475:	88 10                	mov    %dl,(%eax)

void
boot_map(struct pde* pd, void* va, size_t pa, size_t bytes,
         bool write, bool user) {

    for (size_t i = 0; i < bytes; i += PG_SIZE) {
c0101477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
c010147d:	83 c4 10             	add    $0x10,%esp
c0101480:	eb a9                	jmp    c010142b <boot_map+0x1c>
        pg->addr = PA2PM(pa + i);
        pg->present = true;
        pg->write = write;
        pg->user = user;
    }
}
c0101482:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101485:	5b                   	pop    %ebx
c0101486:	5e                   	pop    %esi
c0101487:	5f                   	pop    %edi
c0101488:	5d                   	pop    %ebp
c0101489:	c3                   	ret    

c010148a <mmio_map>:

void*
mmio_map(size_t pa, size_t size) {
c010148a:	55                   	push   %ebp
c010148b:	89 e5                	mov    %esp,%ebp
c010148d:	53                   	push   %ebx
c010148e:	52                   	push   %edx
    static size_t base = MMIOBASE;

    size = ROUNDUP(size, PG_SIZE);
c010148f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101492:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
c0101498:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

    if (base + size > MMIOLIM)
c010149e:	a1 00 50 13 c0       	mov    0xc0135000,%eax
c01014a3:	01 d8                	add    %ebx,%eax
c01014a5:	3d 00 00 c0 bf       	cmp    $0xbfc00000,%eax
c01014aa:	76 19                	jbe    c01014c5 <mmio_map+0x3b>
        panic("ERROR: this reservation would overflow the mmio region");
c01014ac:	68 d5 b0 10 c0       	push   $0xc010b0d5
c01014b1:	68 48 b1 10 c0       	push   $0xc010b148
c01014b6:	6a 34                	push   $0x34
c01014b8:	68 0c b1 10 c0       	push   $0xc010b10c
c01014bd:	e8 80 24 00 00       	call   c0103942 <_panic>
c01014c2:	83 c4 10             	add    $0x10,%esp

    boot_map(kpd, (void*) base, pa, size, true, false);
c01014c5:	50                   	push   %eax
c01014c6:	50                   	push   %eax
c01014c7:	6a 00                	push   $0x0
c01014c9:	6a 01                	push   $0x1
c01014cb:	53                   	push   %ebx
c01014cc:	ff 75 08             	pushl  0x8(%ebp)
c01014cf:	ff 35 00 50 13 c0    	pushl  0xc0135000
c01014d5:	ff 35 c4 6e 13 c0    	pushl  0xc0136ec4
c01014db:	e8 2f ff ff ff       	call   c010140f <boot_map>
    base += size;
c01014e0:	a1 00 50 13 c0       	mov    0xc0135000,%eax
c01014e5:	01 c3                	add    %eax,%ebx
c01014e7:	89 1d 00 50 13 c0    	mov    %ebx,0xc0135000

    return (void*) (base - size);
}
c01014ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01014f0:	c9                   	leave  
c01014f1:	c3                   	ret    

c01014f2 <init_vmm>:
    uint32_t fault_addr = rcr2();
    print("fa: %x\n", fault_addr);
}

void
init_vmm(void) {
c01014f2:	55                   	push   %ebp
c01014f3:	89 e5                	mov    %esp,%ebp
c01014f5:	53                   	push   %ebx
c01014f6:	83 ec 10             	sub    $0x10,%esp
    extern char bstack[];

    // allocate a page directory for the kernel
    kpd = kalign(PG_SIZE);
c01014f9:	68 00 10 00 00       	push   $0x1000
c01014fe:	e8 51 fe ff ff       	call   c0101354 <kalign>
c0101503:	a3 c4 6e 13 c0       	mov    %eax,0xc0136ec4

    boot_map(kpd, (void*) KADDR, 0, npages * PG_SIZE, true, false);
c0101508:	59                   	pop    %ecx
c0101509:	5b                   	pop    %ebx
c010150a:	6a 00                	push   $0x0
c010150c:	6a 01                	push   $0x1
c010150e:	8b 15 88 6e 13 c0    	mov    0xc0136e88,%edx
c0101514:	c1 e2 0c             	shl    $0xc,%edx
c0101517:	52                   	push   %edx
c0101518:	6a 00                	push   $0x0
c010151a:	68 00 00 00 c0       	push   $0xc0000000
c010151f:	50                   	push   %eax
c0101520:	e8 ea fe ff ff       	call   c010140f <boot_map>

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
c0101525:	83 c4 20             	add    $0x20,%esp
c0101528:	b8 00 c0 12 c0       	mov    $0xc012c000,%eax
c010152d:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101532:	77 22                	ja     c0101556 <init_vmm+0x64>
        panic(file, line, "PADDR called with invalid va %08x", va);
c0101534:	52                   	push   %edx
c0101535:	50                   	push   %eax
c0101536:	68 06 b0 10 c0       	push   $0xc010b006
c010153b:	6a 4c                	push   $0x4c
c010153d:	68 0c b1 10 c0       	push   $0xc010b10c
c0101542:	68 40 b1 10 c0       	push   $0xc010b140
c0101547:	6a 38                	push   $0x38
c0101549:	68 28 b0 10 c0       	push   $0xc010b028
c010154e:	e8 ef 23 00 00       	call   c0103942 <_panic>
c0101553:	83 c4 20             	add    $0x20,%esp
    boot_map(kpd, (void*) (KADDR - BIT(15)), PADDR(bstack), BIT(15), true, false);
c0101556:	53                   	push   %ebx
c0101557:	53                   	push   %ebx
c0101558:	6a 00                	push   $0x0
c010155a:	6a 01                	push   $0x1
c010155c:	68 00 80 00 00       	push   $0x8000
c0101561:	68 00 c0 12 00       	push   $0x12c000
c0101566:	68 00 80 ff bf       	push   $0xbfff8000
c010156b:	ff 35 c4 6e 13 c0    	pushl  0xc0136ec4
c0101571:	e8 99 fe ff ff       	call   c010140f <boot_map>

    lcr3(PADDR(kpd));
c0101576:	8b 1d c4 6e 13 c0    	mov    0xc0136ec4,%ebx

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
c010157c:	83 c4 20             	add    $0x20,%esp
c010157f:	81 fb ff ff ff bf    	cmp    $0xbfffffff,%ebx
c0101585:	77 22                	ja     c01015a9 <init_vmm+0xb7>
        panic(file, line, "PADDR called with invalid va %08x", va);
c0101587:	51                   	push   %ecx
c0101588:	53                   	push   %ebx
c0101589:	68 06 b0 10 c0       	push   $0xc010b006
c010158e:	6a 4e                	push   $0x4e
c0101590:	68 0c b1 10 c0       	push   $0xc010b10c
c0101595:	68 40 b1 10 c0       	push   $0xc010b140
c010159a:	6a 38                	push   $0x38
c010159c:	68 28 b0 10 c0       	push   $0xc010b028
c01015a1:	e8 9c 23 00 00       	call   c0103942 <_panic>
c01015a6:	83 c4 20             	add    $0x20,%esp
    return val;
}

static inline void
lcr3(uint32_t val) {
    asm volatile("movl %0,%%cr3" : : "r" (val));
c01015a9:	81 c3 00 00 00 40    	add    $0x40000000,%ebx
c01015af:	0f 22 db             	mov    %ebx,%cr3
}

static inline uint32_t
rcr0(void) {
    uint32_t val;
    asm volatile("movl %%cr0,%0" : "=r" (val));
c01015b2:	0f 20 c0             	mov    %cr0,%eax
c01015b5:	83 e0 f3             	and    $0xfffffff3,%eax
    asm volatile("ltr %0" : : "r" (sel));
}

static inline void
lcr0(uint32_t val) {
    asm volatile("movl %0,%%cr0" : : "r" (val));
c01015b8:	0d 23 00 05 80       	or     $0x80050023,%eax
c01015bd:	0f 22 c0             	mov    %eax,%cr0
    uint32_t cr0 = rcr0();
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_MP;
    cr0 &= ~(CR0_TS | CR0_EM);
    lcr0(cr0);

    mbi = VADDR(mbi);
c01015c0:	8b 1d e0 76 13 c0    	mov    0xc01376e0,%ebx

#define VADDR(pa) _vaddr(__FILE__, __LINE__, (size_t) pa)

static inline void*
_vaddr(const char* file, int line, size_t pa) {
    if (PA2PM(pa) >= npages)
c01015c6:	89 d8                	mov    %ebx,%eax
c01015c8:	c1 e8 0c             	shr    $0xc,%eax
c01015cb:	3b 05 88 6e 13 c0    	cmp    0xc0136e88,%eax
c01015d1:	72 22                	jb     c01015f5 <init_vmm+0x103>
        panic(file, line, "VADDR called with invalid pa %08x", pa);
c01015d3:	52                   	push   %edx
c01015d4:	53                   	push   %ebx
c01015d5:	68 16 b1 10 c0       	push   $0xc010b116
c01015da:	6a 55                	push   $0x55
c01015dc:	68 0c b1 10 c0       	push   $0xc010b10c
c01015e1:	68 38 b1 10 c0       	push   $0xc010b138
c01015e6:	6a 43                	push   $0x43
c01015e8:	68 28 b0 10 c0       	push   $0xc010b028
c01015ed:	e8 50 23 00 00       	call   c0103942 <_panic>
c01015f2:	83 c4 20             	add    $0x20,%esp
c01015f5:	81 eb 00 00 00 40    	sub    $0x40000000,%ebx
c01015fb:	89 1d e0 76 13 c0    	mov    %ebx,0xc01376e0

    isr_install_handler(ISR_PGFLT, isr_pgfault);
c0101601:	50                   	push   %eax
c0101602:	50                   	push   %eax
c0101603:	68 82 13 10 c0       	push   $0xc0101382
c0101608:	6a 0e                	push   $0xe
c010160a:	e8 ae ef ff ff       	call   c01005bd <isr_install_handler>
}
c010160f:	83 c4 10             	add    $0x10,%esp
c0101612:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101615:	c9                   	leave  
c0101616:	c3                   	ret    

c0101617 <init_mem>:
size_t kbrk_min;
size_t kbrk;
size_t kbrk_max;

void
init_mem(void) {
c0101617:	55                   	push   %ebp
c0101618:	89 e5                	mov    %esp,%ebp
    kbrk_min = ROUNDUP(KHEAP, PG_SIZE);
c010161a:	b8 ff 9f 17 c0       	mov    $0xc0179fff,%eax
c010161f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0101624:	a3 d0 76 13 c0       	mov    %eax,0xc01376d0
    kbrk_max = kbrk_min + ROUNDDOWN(MAX_HEAP, PG_SIZE);
c0101629:	8d 90 00 00 10 00    	lea    0x100000(%eax),%edx
c010162f:	89 15 c8 76 13 c0    	mov    %edx,0xc01376c8
    kbrk = kbrk_min;
c0101635:	a3 cc 76 13 c0       	mov    %eax,0xc01376cc
}
c010163a:	5d                   	pop    %ebp
c010163b:	c3                   	ret    

c010163c <term_mem>:

void
term_mem(void) {
c010163c:	55                   	push   %ebp
c010163d:	89 e5                	mov    %esp,%ebp
c010163f:	83 ec 14             	sub    $0x14,%esp
    print("term_mem()");
c0101642:	68 51 b1 10 c0       	push   $0xc010b151
c0101647:	e8 78 27 00 00       	call   c0103dc4 <print>
}
c010164c:	83 c4 10             	add    $0x10,%esp
c010164f:	c9                   	leave  
c0101650:	c3                   	ret    

c0101651 <mem_reset_brk>:

void
mem_reset_brk() {
c0101651:	55                   	push   %ebp
c0101652:	89 e5                	mov    %esp,%ebp
    kbrk = kbrk_min;
c0101654:	a1 d0 76 13 c0       	mov    0xc01376d0,%eax
c0101659:	a3 cc 76 13 c0       	mov    %eax,0xc01376cc
}
c010165e:	5d                   	pop    %ebp
c010165f:	c3                   	ret    

c0101660 <mem_sbrk>:

void*
mem_sbrk(size_t incr) {
c0101660:	55                   	push   %ebp
c0101661:	89 e5                	mov    %esp,%ebp
c0101663:	56                   	push   %esi
c0101664:	53                   	push   %ebx
    size_t old_brk = kbrk;
c0101665:	8b 35 cc 76 13 c0    	mov    0xc01376cc,%esi

    incr = ROUNDUP(incr, PG_SIZE);
c010166b:	8b 45 08             	mov    0x8(%ebp),%eax
c010166e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
c0101674:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

    if (kbrk + incr > kbrk_max)
c010167a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
c010167d:	3b 05 c8 76 13 c0    	cmp    0xc01376c8,%eax
c0101683:	76 19                	jbe    c010169e <mem_sbrk+0x3e>
        panic("ERROR: mem_sbrk failed. Ran out of memory...\n");
c0101685:	68 5c b1 10 c0       	push   $0xc010b15c
c010168a:	68 94 b1 10 c0       	push   $0xc010b194
c010168f:	6a 24                	push   $0x24
c0101691:	68 8a b1 10 c0       	push   $0xc010b18a
c0101696:	e8 a7 22 00 00       	call   c0103942 <_panic>
c010169b:	83 c4 10             	add    $0x10,%esp
    kbrk += incr;
c010169e:	01 1d cc 76 13 c0    	add    %ebx,0xc01376cc
    return (void*) old_brk;
}
c01016a4:	89 f0                	mov    %esi,%eax
c01016a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01016a9:	5b                   	pop    %ebx
c01016aa:	5e                   	pop    %esi
c01016ab:	5d                   	pop    %ebp
c01016ac:	c3                   	ret    

c01016ad <mem_heap_lo>:

void*
mem_heap_lo() {
c01016ad:	55                   	push   %ebp
c01016ae:	89 e5                	mov    %esp,%ebp
    return (void*) kbrk_min;
}
c01016b0:	a1 d0 76 13 c0       	mov    0xc01376d0,%eax
c01016b5:	5d                   	pop    %ebp
c01016b6:	c3                   	ret    

c01016b7 <mem_heap_hi>:

void*
mem_heap_hi() {
c01016b7:	55                   	push   %ebp
c01016b8:	89 e5                	mov    %esp,%ebp
    return (void*) (kbrk - 1);
c01016ba:	a1 cc 76 13 c0       	mov    0xc01376cc,%eax
c01016bf:	48                   	dec    %eax
}
c01016c0:	5d                   	pop    %ebp
c01016c1:	c3                   	ret    

c01016c2 <mem_heapsize>:

size_t
mem_heapsize() {
c01016c2:	55                   	push   %ebp
c01016c3:	89 e5                	mov    %esp,%ebp
    return (size_t) (kbrk - kbrk_min);
c01016c5:	a1 cc 76 13 c0       	mov    0xc01376cc,%eax
c01016ca:	2b 05 d0 76 13 c0    	sub    0xc01376d0,%eax
}
c01016d0:	5d                   	pop    %ebp
c01016d1:	c3                   	ret    

c01016d2 <mem_pagesize>:

size_t
mem_pagesize() {
c01016d2:	55                   	push   %ebp
c01016d3:	89 e5                	mov    %esp,%ebp
    return (size_t) PG_SIZE;
}
c01016d5:	b8 00 10 00 00       	mov    $0x1000,%eax
c01016da:	5d                   	pop    %ebp
c01016db:	c3                   	ret    

c01016dc <copyPayloadOver>:

    return;
}

// Copies the payload over from src to dst
static void copyPayloadOver(BlockInfo* src, BlockInfo* dst) {
c01016dc:	55                   	push   %ebp
c01016dd:	89 e5                	mov    %esp,%ebp
c01016df:	57                   	push   %edi
c01016e0:	56                   	push   %esi
c01016e1:	53                   	push   %ebx
    // WORD_SIZE increments
    srcWord = (long long unsigned*)UNSCALED_POINTER_ADD(src, WORD_SIZE);
    dstWord = (long long unsigned*)UNSCALED_POINTER_ADD(dst, WORD_SIZE);

    // sizes are all aligned so can just divide by WORD_SIZE
    for(size_t i = 0; i < payloadSize / WORD_SIZE; i++)
c01016e2:	8b 08                	mov    (%eax),%ecx
c01016e4:	83 e1 fc             	and    $0xfffffffc,%ecx
c01016e7:	83 e9 04             	sub    $0x4,%ecx
c01016ea:	c1 e9 02             	shr    $0x2,%ecx
c01016ed:	31 db                	xor    %ebx,%ebx
c01016ef:	39 cb                	cmp    %ecx,%ebx
c01016f1:	74 13                	je     c0101706 <copyPayloadOver+0x2a>
        dstWord[i] = srcWord[i];
c01016f3:	8b 74 d8 04          	mov    0x4(%eax,%ebx,8),%esi
c01016f7:	8b 7c d8 08          	mov    0x8(%eax,%ebx,8),%edi
c01016fb:	89 74 da 04          	mov    %esi,0x4(%edx,%ebx,8)
c01016ff:	89 7c da 08          	mov    %edi,0x8(%edx,%ebx,8)
    // WORD_SIZE increments
    srcWord = (long long unsigned*)UNSCALED_POINTER_ADD(src, WORD_SIZE);
    dstWord = (long long unsigned*)UNSCALED_POINTER_ADD(dst, WORD_SIZE);

    // sizes are all aligned so can just divide by WORD_SIZE
    for(size_t i = 0; i < payloadSize / WORD_SIZE; i++)
c0101703:	43                   	inc    %ebx
c0101704:	eb e9                	jmp    c01016ef <copyPayloadOver+0x13>
        dstWord[i] = srcWord[i];

    return;
}
c0101706:	5b                   	pop    %ebx
c0101707:	5e                   	pop    %esi
c0101708:	5f                   	pop    %edi
c0101709:	5d                   	pop    %ebp
c010170a:	c3                   	ret    

c010170b <insertFreeBlock>:
    }
    return NULL;
}

/* Insert freeBlock at the head of the list.  (LIFO) */
static void insertFreeBlock(BlockInfo* freeBlock) {
c010170b:	55                   	push   %ebp
c010170c:	89 e5                	mov    %esp,%ebp
c010170e:	53                   	push   %ebx
c010170f:	52                   	push   %edx
c0101710:	89 c3                	mov    %eax,%ebx
    BlockInfo* oldHead = FREE_LIST_HEAD;
c0101712:	e8 96 ff ff ff       	call   c01016ad <mem_heap_lo>
c0101717:	8b 00                	mov    (%eax),%eax

    freeBlock->next = oldHead;
c0101719:	89 43 04             	mov    %eax,0x4(%ebx)
    if(oldHead != NULL)
c010171c:	85 c0                	test   %eax,%eax
c010171e:	74 03                	je     c0101723 <insertFreeBlock+0x18>
        oldHead->prev = freeBlock;
c0101720:	89 58 08             	mov    %ebx,0x8(%eax)
    FREE_LIST_HEAD = freeBlock;
c0101723:	e8 85 ff ff ff       	call   c01016ad <mem_heap_lo>
c0101728:	89 18                	mov    %ebx,(%eax)
}
c010172a:	58                   	pop    %eax
c010172b:	5b                   	pop    %ebx
c010172c:	5d                   	pop    %ebp
c010172d:	c3                   	ret    

c010172e <searchFreeList>:
    FREE_LIST_HEAD = firstFreeBlock;
}

/* Find a free block of the requested size in the free list.  Returns
   NULL if no free block is large enough. */
static void* searchFreeList(size_t reqSize) {
c010172e:	55                   	push   %ebp
c010172f:	89 e5                	mov    %esp,%ebp
c0101731:	53                   	push   %ebx
c0101732:	51                   	push   %ecx
c0101733:	89 c3                	mov    %eax,%ebx
    BlockInfo* freeBlock;

    freeBlock = FREE_LIST_HEAD;
c0101735:	e8 73 ff ff ff       	call   c01016ad <mem_heap_lo>
c010173a:	8b 00                	mov    (%eax),%eax
    while(freeBlock != NULL) {
c010173c:	85 c0                	test   %eax,%eax
c010173e:	74 0e                	je     c010174e <searchFreeList+0x20>
        if(SIZE(freeBlock->sizeAndTags) >= reqSize)
c0101740:	8b 10                	mov    (%eax),%edx
c0101742:	83 e2 fc             	and    $0xfffffffc,%edx
c0101745:	39 da                	cmp    %ebx,%edx
c0101747:	73 05                	jae    c010174e <searchFreeList+0x20>
            return freeBlock;
        else
            freeBlock = freeBlock->next;
c0101749:	8b 40 04             	mov    0x4(%eax),%eax
c010174c:	eb ee                	jmp    c010173c <searchFreeList+0xe>
    }
    return NULL;
}
c010174e:	5a                   	pop    %edx
c010174f:	5b                   	pop    %ebx
c0101750:	5d                   	pop    %ebp
c0101751:	c3                   	ret    

c0101752 <removeFreeBlock>:
        oldHead->prev = freeBlock;
    FREE_LIST_HEAD = freeBlock;
}

/* Remove a free block from the free list. */
static void removeFreeBlock(BlockInfo* freeBlock) {
c0101752:	55                   	push   %ebp
c0101753:	89 e5                	mov    %esp,%ebp
c0101755:	57                   	push   %edi
c0101756:	56                   	push   %esi
c0101757:	53                   	push   %ebx
c0101758:	83 ec 0c             	sub    $0xc,%esp
c010175b:	89 c6                	mov    %eax,%esi
    BlockInfo* nextFree = freeBlock->next;
c010175d:	8b 58 04             	mov    0x4(%eax),%ebx
    BlockInfo* prevFree = freeBlock->prev;
c0101760:	8b 78 08             	mov    0x8(%eax),%edi

    if(nextFree != NULL)
c0101763:	85 db                	test   %ebx,%ebx
c0101765:	74 03                	je     c010176a <removeFreeBlock+0x18>
        nextFree->prev = prevFree;
c0101767:	89 7b 08             	mov    %edi,0x8(%ebx)
    if(freeBlock == FREE_LIST_HEAD)
c010176a:	e8 3e ff ff ff       	call   c01016ad <mem_heap_lo>
c010176f:	3b 30                	cmp    (%eax),%esi
c0101771:	75 09                	jne    c010177c <removeFreeBlock+0x2a>
        FREE_LIST_HEAD = nextFree;
c0101773:	e8 35 ff ff ff       	call   c01016ad <mem_heap_lo>
c0101778:	89 18                	mov    %ebx,(%eax)
c010177a:	eb 03                	jmp    c010177f <removeFreeBlock+0x2d>
    else
        prevFree->next = nextFree;
c010177c:	89 5f 04             	mov    %ebx,0x4(%edi)
}
c010177f:	83 c4 0c             	add    $0xc,%esp
c0101782:	5b                   	pop    %ebx
c0101783:	5e                   	pop    %esi
c0101784:	5f                   	pop    %edi
c0101785:	5d                   	pop    %ebp
c0101786:	c3                   	ret    

c0101787 <coalesceFreeBlock>:

/* Coalesce 'oldBlock' with any preceeding or following free blocks. */
static void coalesceFreeBlock(BlockInfo* oldBlock) {
c0101787:	55                   	push   %ebp
c0101788:	89 e5                	mov    %esp,%ebp
c010178a:	57                   	push   %edi
c010178b:	56                   	push   %esi
c010178c:	53                   	push   %ebx
c010178d:	83 ec 1c             	sub    $0x1c,%esp
c0101790:	89 c1                	mov    %eax,%ecx
    size_t oldSize = SIZE(oldBlock->sizeAndTags);
c0101792:	8b 00                	mov    (%eax),%eax
c0101794:	83 e0 fc             	and    $0xfffffffc,%eax
c0101797:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    BlockInfo* blockCursor;
    BlockInfo* newBlock;
    BlockInfo* freeBlock;

    blockCursor = oldBlock;
    while (!PRECEDING_USED(blockCursor)) {
c010179a:	89 ce                	mov    %ecx,%esi
}

/* Coalesce 'oldBlock' with any preceeding or following free blocks. */
static void coalesceFreeBlock(BlockInfo* oldBlock) {
    size_t oldSize = SIZE(oldBlock->sizeAndTags);
    size_t newSize = oldSize;
c010179c:	89 c3                	mov    %eax,%ebx
    BlockInfo* blockCursor;
    BlockInfo* newBlock;
    BlockInfo* freeBlock;

    blockCursor = oldBlock;
    while (!PRECEDING_USED(blockCursor)) {
c010179e:	f6 06 02             	testb  $0x2,(%esi)
c01017a1:	75 19                	jne    c01017bc <coalesceFreeBlock+0x35>
c01017a3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        size_t size = SIZE(*((size_t*)UNSCALED_POINTER_SUB(blockCursor, WORD_SIZE)));
c01017a6:	8b 7e fc             	mov    -0x4(%esi),%edi
c01017a9:	83 e7 fc             	and    $0xfffffffc,%edi
        freeBlock = (BlockInfo*)UNSCALED_POINTER_SUB(blockCursor, size);
c01017ac:	29 fe                	sub    %edi,%esi
        removeFreeBlock(freeBlock);
c01017ae:	89 f0                	mov    %esi,%eax
c01017b0:	e8 9d ff ff ff       	call   c0101752 <removeFreeBlock>
        newSize += size;
c01017b5:	01 fb                	add    %edi,%ebx
c01017b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01017ba:	eb e2                	jmp    c010179e <coalesceFreeBlock+0x17>
        blockCursor = freeBlock;
    }

    newBlock = blockCursor;

    blockCursor = (BlockInfo*)UNSCALED_POINTER_ADD(oldBlock, oldSize);
c01017bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01017bf:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
    while (!USED(blockCursor)) {
c01017c2:	8b 07                	mov    (%edi),%eax
c01017c4:	a8 01                	test   $0x1,%al
c01017c6:	75 1b                	jne    c01017e3 <coalesceFreeBlock+0x5c>
c01017c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
        size_t size = SIZE(blockCursor->sizeAndTags);
c01017cb:	83 e0 fc             	and    $0xfffffffc,%eax
c01017ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
        removeFreeBlock(blockCursor);
c01017d1:	89 f8                	mov    %edi,%eax
c01017d3:	e8 7a ff ff ff       	call   c0101752 <removeFreeBlock>
        newSize += size;
c01017d8:	03 5d e0             	add    -0x20(%ebp),%ebx
        blockCursor = (BlockInfo*)UNSCALED_POINTER_ADD(blockCursor, size);
c01017db:	03 7d e0             	add    -0x20(%ebp),%edi
c01017de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01017e1:	eb df                	jmp    c01017c2 <coalesceFreeBlock+0x3b>
    }

    if (newSize != oldSize) {
c01017e3:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
c01017e6:	74 1d                	je     c0101805 <coalesceFreeBlock+0x7e>
        removeFreeBlock(oldBlock);
c01017e8:	89 c8                	mov    %ecx,%eax
c01017ea:	e8 63 ff ff ff       	call   c0101752 <removeFreeBlock>
        newBlock->sizeAndTags = newSize | TAG_PRECEDING_USED;
c01017ef:	83 cb 02             	or     $0x2,%ebx
c01017f2:	89 1e                	mov    %ebx,(%esi)
        *(size_t*)UNSCALED_POINTER_SUB(blockCursor, WORD_SIZE) = newSize | TAG_PRECEDING_USED;
c01017f4:	89 5f fc             	mov    %ebx,-0x4(%edi)
        insertFreeBlock(newBlock);
c01017f7:	89 f0                	mov    %esi,%eax
    }

    return;
}
c01017f9:	83 c4 1c             	add    $0x1c,%esp
c01017fc:	5b                   	pop    %ebx
c01017fd:	5e                   	pop    %esi
c01017fe:	5f                   	pop    %edi
c01017ff:	5d                   	pop    %ebp

    if (newSize != oldSize) {
        removeFreeBlock(oldBlock);
        newBlock->sizeAndTags = newSize | TAG_PRECEDING_USED;
        *(size_t*)UNSCALED_POINTER_SUB(blockCursor, WORD_SIZE) = newSize | TAG_PRECEDING_USED;
        insertFreeBlock(newBlock);
c0101800:	e9 06 ff ff ff       	jmp    c010170b <insertFreeBlock>
    }

    return;
}
c0101805:	83 c4 1c             	add    $0x1c,%esp
c0101808:	5b                   	pop    %ebx
c0101809:	5e                   	pop    %esi
c010180a:	5f                   	pop    %edi
c010180b:	5d                   	pop    %ebp
c010180c:	c3                   	ret    

c010180d <freeSurplusBlock>:
    return validSize;
}

// Takes a BlockInfo with size blockSize and frees memory from the end in
// excess of keepSize.
static void freeSurplusBlock(BlockInfo* blockInfo, size_t blockSize, size_t keepSize) {
c010180d:	55                   	push   %ebp
c010180e:	89 e5                	mov    %esp,%ebp
c0101810:	56                   	push   %esi
c0101811:	53                   	push   %ebx
    BlockInfo* followingBlock;
    BlockInfo* blockSurplus;

    blockSurplus = (BlockInfo*)UNSCALED_POINTER_ADD(blockInfo, keepSize);
c0101812:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx

    // When called by kfree, blockSurplus won't automatically be preceded by a used block
    if(keepSize > 0)
c0101815:	85 c9                	test   %ecx,%ecx
c0101817:	74 0b                	je     c0101824 <freeSurplusBlock+0x17>
        // blockInfo will always precede and be in a used state;
        blockSurplus->sizeAndTags = (blockSize - keepSize) | TAG_PRECEDING_USED;
c0101819:	89 d6                	mov    %edx,%esi
c010181b:	29 ce                	sub    %ecx,%esi
c010181d:	89 f1                	mov    %esi,%ecx
c010181f:	83 c9 02             	or     $0x2,%ecx
c0101822:	eb 07                	jmp    c010182b <freeSurplusBlock+0x1e>
    else
        // called by kfree and keepSize = 0
        // blockInfo is gone so must check the if preceding block is used
        blockSurplus->sizeAndTags = blockSize | PRECEDING_USED(blockInfo);
c0101824:	8b 08                	mov    (%eax),%ecx
c0101826:	83 e1 02             	and    $0x2,%ecx
c0101829:	09 d1                	or     %edx,%ecx
c010182b:	89 0b                	mov    %ecx,(%ebx)

    // Set boundary footer
    *(size_t*)UNSCALED_POINTER_ADD(blockInfo, blockSize - WORD_SIZE) = blockSurplus->sizeAndTags;
c010182d:	8b 0b                	mov    (%ebx),%ecx
c010182f:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)

    // Unset the succeeding block's PRECEDING_USED tag to reflect the change
    followingBlock = (BlockInfo*)UNSCALED_POINTER_ADD(blockInfo, blockSize);
c0101833:	01 c2                	add    %eax,%edx
    followingBlock->sizeAndTags |= TAG_PRECEDING_USED;
    followingBlock->sizeAndTags ^= TAG_PRECEDING_USED;
c0101835:	8b 02                	mov    (%edx),%eax
c0101837:	83 c8 02             	or     $0x2,%eax
c010183a:	83 f0 02             	xor    $0x2,%eax
c010183d:	89 02                	mov    %eax,(%edx)

    insertFreeBlock(blockSurplus);
c010183f:	89 d8                	mov    %ebx,%eax
c0101841:	e8 c5 fe ff ff       	call   c010170b <insertFreeBlock>
    coalesceFreeBlock(blockSurplus);
c0101846:	89 d8                	mov    %ebx,%eax

    return;
}
c0101848:	5b                   	pop    %ebx
c0101849:	5e                   	pop    %esi
c010184a:	5d                   	pop    %ebp
    followingBlock = (BlockInfo*)UNSCALED_POINTER_ADD(blockInfo, blockSize);
    followingBlock->sizeAndTags |= TAG_PRECEDING_USED;
    followingBlock->sizeAndTags ^= TAG_PRECEDING_USED;

    insertFreeBlock(blockSurplus);
    coalesceFreeBlock(blockSurplus);
c010184b:	e9 37 ff ff ff       	jmp    c0101787 <coalesceFreeBlock>

c0101850 <init_mm>:
// DIAGNOSTICS FUNCTIONS
// static void mm_printFreeList(void);
// static void mm_printHeap(void);

/* Initialize the allocator. */
void init_mm() {
c0101850:	55                   	push   %ebp
c0101851:	89 e5                	mov    %esp,%ebp
c0101853:	53                   	push   %ebx
c0101854:	83 ec 10             	sub    $0x10,%esp
    size_t initSize = 32 * PG_SIZE;
    size_t totalSize;
    BlockInfo* firstFreeBlock;

    mem_sbrk(initSize);
c0101857:	68 00 00 02 00       	push   $0x20000
c010185c:	e8 ff fd ff ff       	call   c0101660 <mem_sbrk>
    firstFreeBlock = (BlockInfo*) UNSCALED_POINTER_ADD(mem_heap_lo(), WORD_SIZE);
c0101861:	e8 47 fe ff ff       	call   c01016ad <mem_heap_lo>
c0101866:	89 c3                	mov    %eax,%ebx
    totalSize = initSize - (2 * WORD_SIZE);

    firstFreeBlock->sizeAndTags = totalSize | TAG_PRECEDING_USED;
c0101868:	c7 40 04 fa ff 01 00 	movl   $0x1fffa,0x4(%eax)
    firstFreeBlock->next = NULL;
c010186f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    firstFreeBlock->prev = NULL;
c0101876:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

    *((size_t*) UNSCALED_POINTER_ADD(firstFreeBlock, totalSize - WORD_SIZE)) = firstFreeBlock->sizeAndTags;
c010187d:	c7 80 f8 ff 01 00 fa 	movl   $0x1fffa,0x1fff8(%eax)
c0101884:	ff 01 00 
    *((size_t*) UNSCALED_POINTER_SUB(mem_heap_hi(), WORD_SIZE - 1)) = TAG_USED;
c0101887:	e8 2b fe ff ff       	call   c01016b7 <mem_heap_hi>
c010188c:	c7 40 fd 01 00 00 00 	movl   $0x1,-0x3(%eax)

    FREE_LIST_HEAD = firstFreeBlock;
c0101893:	e8 15 fe ff ff       	call   c01016ad <mem_heap_lo>
c0101898:	83 c3 04             	add    $0x4,%ebx
c010189b:	89 18                	mov    %ebx,(%eax)
}
c010189d:	83 c4 10             	add    $0x10,%esp
c01018a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01018a3:	c9                   	leave  
c01018a4:	c3                   	ret    

c01018a5 <kmalloc>:


// TOP-LEVEL ALLOCATOR INTERFACE ------------------------------------


void* kmalloc(size_t size) {
c01018a5:	55                   	push   %ebp
c01018a6:	89 e5                	mov    %esp,%ebp
c01018a8:	57                   	push   %edi
c01018a9:	56                   	push   %esi
c01018aa:	53                   	push   %ebx
c01018ab:	83 ec 0c             	sub    $0xc,%esp
c01018ae:	8b 55 08             	mov    0x8(%ebp),%edx
c01018b1:	31 c0                	xor    %eax,%eax
    size_t reqSize;
    size_t blockSize;
    BlockInfo* ptrFreeBlock;

    if(size == 0)
c01018b3:	85 d2                	test   %edx,%edx
c01018b5:	0f 84 ae 00 00 00    	je     c0101969 <kmalloc+0xc4>
// least MIN_BLOCK_SIZE
static size_t getValidSize(size_t size) {
    size_t validSize;

    size += WORD_SIZE;
    if(size <= MIN_BLOCK_SIZE)
c01018bb:	8d 42 04             	lea    0x4(%edx),%eax
        validSize = MIN_BLOCK_SIZE;
c01018be:	be 10 00 00 00       	mov    $0x10,%esi
// least MIN_BLOCK_SIZE
static size_t getValidSize(size_t size) {
    size_t validSize;

    size += WORD_SIZE;
    if(size <= MIN_BLOCK_SIZE)
c01018c3:	83 f8 10             	cmp    $0x10,%eax
c01018c6:	76 06                	jbe    c01018ce <kmalloc+0x29>
        validSize = MIN_BLOCK_SIZE;
    else
        validSize = ALIGNMENT * ((size + ALIGNMENT - 1) / ALIGNMENT);
c01018c8:	8d 72 07             	lea    0x7(%edx),%esi
c01018cb:	83 e6 fc             	and    $0xfffffffc,%esi

    // Ensure a valid and aligned size
    reqSize = getValidSize(size);

    // Search free list for a suitable block.
    ptrFreeBlock = searchFreeList(reqSize);
c01018ce:	89 f0                	mov    %esi,%eax
c01018d0:	e8 59 fe ff ff       	call   c010172e <searchFreeList>
c01018d5:	89 c3                	mov    %eax,%ebx
    if(ptrFreeBlock == NULL) {
c01018d7:	85 c0                	test   %eax,%eax
c01018d9:	75 56                	jne    c0101931 <kmalloc+0x8c>
    return;
}

/* Get more heap space of size at least reqSize. */
static void requestMoreSpace(size_t reqSize) {
    size_t pagesize = mem_pagesize();
c01018db:	e8 f2 fd ff ff       	call   c01016d2 <mem_pagesize>
c01018e0:	89 c1                	mov    %eax,%ecx
    size_t numPages = (reqSize + pagesize - 1) / pagesize;
    size_t totalSize = numPages * pagesize;
c01018e2:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
c01018e6:	31 d2                	xor    %edx,%edx
c01018e8:	f7 f1                	div    %ecx
c01018ea:	0f af c1             	imul   %ecx,%eax
c01018ed:	89 c3                	mov    %eax,%ebx
    BlockInfo* newBlock;

    newBlock = (BlockInfo*)UNSCALED_POINTER_SUB(mem_sbrk(totalSize), WORD_SIZE);
c01018ef:	83 ec 0c             	sub    $0xc,%esp
c01018f2:	50                   	push   %eax
c01018f3:	e8 68 fd ff ff       	call   c0101660 <mem_sbrk>
c01018f8:	8d 78 fc             	lea    -0x4(%eax),%edi

    newBlock->sizeAndTags = totalSize | PRECEDING_USED(newBlock);
c01018fb:	8b 50 fc             	mov    -0x4(%eax),%edx
c01018fe:	83 e2 02             	and    $0x2,%edx
c0101901:	09 da                	or     %ebx,%edx
c0101903:	89 50 fc             	mov    %edx,-0x4(%eax)
    ((BlockInfo*)UNSCALED_POINTER_ADD(newBlock, totalSize - WORD_SIZE))->sizeAndTags = totalSize | PRECEDING_USED(newBlock);
c0101906:	83 e2 02             	and    $0x2,%edx
c0101909:	09 da                	or     %ebx,%edx
c010190b:	89 54 18 f8          	mov    %edx,-0x8(%eax,%ebx,1)
    *((size_t*)UNSCALED_POINTER_ADD(newBlock, totalSize)) = TAG_USED;
c010190f:	c7 44 18 fc 01 00 00 	movl   $0x1,-0x4(%eax,%ebx,1)
c0101916:	00 

    insertFreeBlock(newBlock);
c0101917:	89 f8                	mov    %edi,%eax
c0101919:	e8 ed fd ff ff       	call   c010170b <insertFreeBlock>
    coalesceFreeBlock(newBlock);
c010191e:	89 f8                	mov    %edi,%eax
c0101920:	e8 62 fe ff ff       	call   c0101787 <coalesceFreeBlock>

    // Search free list for a suitable block.
    ptrFreeBlock = searchFreeList(reqSize);
    if(ptrFreeBlock == NULL) {
        requestMoreSpace(reqSize);
        ptrFreeBlock = searchFreeList(reqSize);
c0101925:	89 f0                	mov    %esi,%eax
c0101927:	e8 02 fe ff ff       	call   c010172e <searchFreeList>
c010192c:	89 c3                	mov    %eax,%ebx
c010192e:	83 c4 10             	add    $0x10,%esp
    }
    removeFreeBlock(ptrFreeBlock);
c0101931:	89 d8                	mov    %ebx,%eax
c0101933:	e8 1a fe ff ff       	call   c0101752 <removeFreeBlock>

    blockSize = SIZE(ptrFreeBlock->sizeAndTags);
c0101938:	8b 03                	mov    (%ebx),%eax
c010193a:	89 c2                	mov    %eax,%edx
c010193c:	83 e2 fc             	and    $0xfffffffc,%edx

    // Block may be larger than necessary so must check if it is possible to
    // chop off the end of the block and put in back in the free list.
    if(blockSize - reqSize >= MIN_BLOCK_SIZE) {
c010193f:	89 d1                	mov    %edx,%ecx
c0101941:	29 f1                	sub    %esi,%ecx
c0101943:	83 f9 0f             	cmp    $0xf,%ecx
c0101946:	76 15                	jbe    c010195d <kmalloc+0xb8>
        ptrFreeBlock->sizeAndTags = reqSize | TAG_USED | PRECEDING_USED(ptrFreeBlock);
c0101948:	83 e0 02             	and    $0x2,%eax
c010194b:	83 c8 01             	or     $0x1,%eax
c010194e:	09 f0                	or     %esi,%eax
c0101950:	89 03                	mov    %eax,(%ebx)
        freeSurplusBlock(ptrFreeBlock, blockSize, reqSize);
c0101952:	89 f1                	mov    %esi,%ecx
c0101954:	89 d8                	mov    %ebx,%eax
c0101956:	e8 b2 fe ff ff       	call   c010180d <freeSurplusBlock>
c010195b:	eb 09                	jmp    c0101966 <kmalloc+0xc1>
    } else {
        ptrFreeBlock->sizeAndTags |= TAG_USED | PRECEDING_USED(ptrFreeBlock);
c010195d:	83 c8 01             	or     $0x1,%eax
c0101960:	89 03                	mov    %eax,(%ebx)
        *(size_t*) UNSCALED_POINTER_ADD(ptrFreeBlock, blockSize) |= TAG_PRECEDING_USED;
c0101962:	83 0c 13 02          	orl    $0x2,(%ebx,%edx,1)
    }

    // Return a pointer to the start of the payload
    return UNSCALED_POINTER_ADD(ptrFreeBlock, WORD_SIZE);
c0101966:	8d 43 04             	lea    0x4(%ebx),%eax
}
c0101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010196c:	5b                   	pop    %ebx
c010196d:	5e                   	pop    %esi
c010196e:	5f                   	pop    %edi
c010196f:	5d                   	pop    %ebp
c0101970:	c3                   	ret    

c0101971 <kfree>:

void kfree(void* ptr) {
c0101971:	55                   	push   %ebp
c0101972:	89 e5                	mov    %esp,%ebp
c0101974:	8b 45 08             	mov    0x8(%ebp),%eax
    if (ptr == NULL)
c0101977:	85 c0                	test   %eax,%eax
c0101979:	74 16                	je     c0101991 <kfree+0x20>
        return;

    // If the block is in a USED state, treat it all as surplus and free
    BlockInfo* blockInfo = (BlockInfo*) UNSCALED_POINTER_SUB(ptr, WORD_SIZE);
    if (USED(blockInfo))
c010197b:	8b 50 fc             	mov    -0x4(%eax),%edx
c010197e:	f6 c2 01             	test   $0x1,%dl
c0101981:	74 0e                	je     c0101991 <kfree+0x20>
        freeSurplusBlock(blockInfo, SIZE(blockInfo->sizeAndTags), 0);
c0101983:	83 e2 fc             	and    $0xfffffffc,%edx
c0101986:	83 e8 04             	sub    $0x4,%eax
c0101989:	31 c9                	xor    %ecx,%ecx
}
c010198b:	5d                   	pop    %ebp
        return;

    // If the block is in a USED state, treat it all as surplus and free
    BlockInfo* blockInfo = (BlockInfo*) UNSCALED_POINTER_SUB(ptr, WORD_SIZE);
    if (USED(blockInfo))
        freeSurplusBlock(blockInfo, SIZE(blockInfo->sizeAndTags), 0);
c010198c:	e9 7c fe ff ff       	jmp    c010180d <freeSurplusBlock>
}
c0101991:	5d                   	pop    %ebp
c0101992:	c3                   	ret    

c0101993 <krealloc>:

void* krealloc(void* ptr, size_t size) {
c0101993:	55                   	push   %ebp
c0101994:	89 e5                	mov    %esp,%ebp
c0101996:	57                   	push   %edi
c0101997:	56                   	push   %esi
c0101998:	53                   	push   %ebx
c0101999:	83 ec 1c             	sub    $0x1c,%esp
c010199c:	8b 75 08             	mov    0x8(%ebp),%esi
c010199f:	8b 45 0c             	mov    0xc(%ebp),%eax
    BlockInfo* followingBlock = NULL;
    BlockInfo* blockPreceding = NULL;
    BlockInfo* blockNew = NULL;

    // Take care of cases that don't necessarily require this function
    if (ptr == NULL)
c01019a2:	85 f6                	test   %esi,%esi
c01019a4:	75 0f                	jne    c01019b5 <krealloc+0x22>
        return kmalloc(size);
c01019a6:	89 45 08             	mov    %eax,0x8(%ebp)
    copyPayloadOver(blockInfo, blockNew);
    kfree(UNSCALED_POINTER_ADD(blockInfo, WORD_SIZE));

    return UNSCALED_POINTER_ADD(blockNew, WORD_SIZE);

}
c01019a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01019ac:	5b                   	pop    %ebx
c01019ad:	5e                   	pop    %esi
c01019ae:	5f                   	pop    %edi
c01019af:	5d                   	pop    %ebp
    BlockInfo* blockPreceding = NULL;
    BlockInfo* blockNew = NULL;

    // Take care of cases that don't necessarily require this function
    if (ptr == NULL)
        return kmalloc(size);
c01019b0:	e9 f0 fe ff ff       	jmp    c01018a5 <kmalloc>

    if (size == 0) {
c01019b5:	85 c0                	test   %eax,%eax
c01019b7:	75 13                	jne    c01019cc <krealloc+0x39>
        kfree(ptr);
c01019b9:	83 ec 0c             	sub    $0xc,%esp
c01019bc:	56                   	push   %esi
c01019bd:	e8 af ff ff ff       	call   c0101971 <kfree>
        return NULL;
c01019c2:	83 c4 10             	add    $0x10,%esp
c01019c5:	31 db                	xor    %ebx,%ebx
c01019c7:	e9 df 01 00 00       	jmp    c0101bab <krealloc+0x218>
    }

    // Get header and size of the block.
    blockInfo = (BlockInfo*)UNSCALED_POINTER_SUB(ptr, WORD_SIZE);
c01019cc:	8d 7e fc             	lea    -0x4(%esi),%edi
c01019cf:	89 7d e0             	mov    %edi,-0x20(%ebp)
    blockInfo->sizeAndTags |= TAG_USED;
c01019d2:	8b 56 fc             	mov    -0x4(%esi),%edx
c01019d5:	89 d1                	mov    %edx,%ecx
c01019d7:	83 c9 01             	or     $0x1,%ecx
c01019da:	89 4e fc             	mov    %ecx,-0x4(%esi)
c01019dd:	89 d7                	mov    %edx,%edi
c01019df:	83 e7 fc             	and    $0xfffffffc,%edi
c01019e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    size_t reqSize;
    size_t blockSize;

    BlockInfo* blockInfo = NULL;
    BlockInfo* followingBlock = NULL;
    BlockInfo* blockPreceding = NULL;
c01019e5:	31 db                	xor    %ebx,%ebx
    blockSize = SIZE(blockInfo->sizeAndTags);

    followingBlock = (BlockInfo*)UNSCALED_POINTER_ADD(blockInfo, blockSize);
    // Get the preceding block by reading its boundary footer to get the size
    // and then subtracting the size from blockInfo
    if (!PRECEDING_USED(blockInfo))
c01019e7:	83 e2 02             	and    $0x2,%edx
c01019ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01019ed:	75 0b                	jne    c01019fa <krealloc+0x67>
        blockPreceding = (BlockInfo*)UNSCALED_POINTER_SUB(blockInfo, SIZE(*(size_t*)UNSCALED_POINTER_SUB(blockInfo, WORD_SIZE)));
c01019ef:	8b 56 f8             	mov    -0x8(%esi),%edx
c01019f2:	83 e2 fc             	and    $0xfffffffc,%edx
c01019f5:	8d 5e fc             	lea    -0x4(%esi),%ebx
c01019f8:	29 d3                	sub    %edx,%ebx
// least MIN_BLOCK_SIZE
static size_t getValidSize(size_t size) {
    size_t validSize;

    size += WORD_SIZE;
    if(size <= MIN_BLOCK_SIZE)
c01019fa:	8d 50 04             	lea    0x4(%eax),%edx
        validSize = MIN_BLOCK_SIZE;
c01019fd:	b9 10 00 00 00       	mov    $0x10,%ecx
// least MIN_BLOCK_SIZE
static size_t getValidSize(size_t size) {
    size_t validSize;

    size += WORD_SIZE;
    if(size <= MIN_BLOCK_SIZE)
c0101a02:	83 fa 10             	cmp    $0x10,%edx
c0101a05:	76 06                	jbe    c0101a0d <krealloc+0x7a>
        validSize = MIN_BLOCK_SIZE;
    else
        validSize = ALIGNMENT * ((size + ALIGNMENT - 1) / ALIGNMENT);
c0101a07:	8d 48 07             	lea    0x7(%eax),%ecx
c0101a0a:	83 e1 fc             	and    $0xfffffffc,%ecx

    // For a reqeusted size smaller than the current size, attempt to free
    // space at the end of the block. If the requested size is larger and the
    // current block is at the end of the heap, extend the heap to the
    // necessary size.
    if (reqSize <= blockSize) {
c0101a0d:	3b 4d e4             	cmp    -0x1c(%ebp),%ecx
c0101a10:	77 2b                	ja     c0101a3d <krealloc+0xaa>
        // Free excess space if possible
        if (blockSize - reqSize >= MIN_BLOCK_SIZE) {
c0101a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a15:	29 c8                	sub    %ecx,%eax
c0101a17:	89 f3                	mov    %esi,%ebx
c0101a19:	83 f8 0f             	cmp    $0xf,%eax
c0101a1c:	0f 86 89 01 00 00    	jbe    c0101bab <krealloc+0x218>
            blockInfo->sizeAndTags = reqSize | TAG_USED | PRECEDING_USED(blockInfo);
c0101a22:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a25:	83 c8 01             	or     $0x1,%eax
c0101a28:	09 c8                	or     %ecx,%eax
c0101a2a:	89 46 fc             	mov    %eax,-0x4(%esi)
            freeSurplusBlock(blockInfo, blockSize, reqSize);
c0101a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101a33:	e8 d5 fd ff ff       	call   c010180d <freeSurplusBlock>
c0101a38:	e9 6e 01 00 00       	jmp    c0101bab <krealloc+0x218>
    // Get header and size of the block.
    blockInfo = (BlockInfo*)UNSCALED_POINTER_SUB(ptr, WORD_SIZE);
    blockInfo->sizeAndTags |= TAG_USED;
    blockSize = SIZE(blockInfo->sizeAndTags);

    followingBlock = (BlockInfo*)UNSCALED_POINTER_ADD(blockInfo, blockSize);
c0101a3d:	8d 46 fc             	lea    -0x4(%esi),%eax
c0101a40:	03 45 e4             	add    -0x1c(%ebp),%eax
        }

        return UNSCALED_POINTER_ADD(blockInfo, WORD_SIZE);
    }
    // If the size of the next block is 0, blockInfo is the last block on the heap
    else if (FOLLOWING_BLOCK_SIZE(blockInfo) == 0) {
c0101a43:	8b 38                	mov    (%eax),%edi
c0101a45:	89 fa                	mov    %edi,%edx
c0101a47:	83 e2 fc             	and    $0xfffffffc,%edx
c0101a4a:	75 22                	jne    c0101a6e <krealloc+0xdb>
        // extend the heap
        mem_sbrk((size_t)(reqSize - blockSize));
c0101a4c:	83 ec 0c             	sub    $0xc,%esp
c0101a4f:	89 c8                	mov    %ecx,%eax
c0101a51:	89 4d e0             	mov    %ecx,-0x20(%ebp)
c0101a54:	2b 45 e4             	sub    -0x1c(%ebp),%eax
c0101a57:	50                   	push   %eax
c0101a58:	e8 03 fc ff ff       	call   c0101660 <mem_sbrk>
        blockInfo->sizeAndTags = reqSize | TAG_USED | PRECEDING_USED(blockInfo);
c0101a5d:	8b 46 fc             	mov    -0x4(%esi),%eax
c0101a60:	83 e0 02             	and    $0x2,%eax
c0101a63:	83 c8 01             	or     $0x1,%eax
c0101a66:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0101a69:	e9 87 00 00 00       	jmp    c0101af5 <krealloc+0x162>
    }
    // If the block following the current block is free, attempt to combine it
    // with the current block and, if possible, free any excess space. If the
    // combination is not enough memory but the following block is at the end
    // of the heap, extend the heap.
    if(!USED(followingBlock)) {
c0101a6e:	83 e7 01             	and    $0x1,%edi
c0101a71:	0f 85 94 00 00 00    	jne    c0101b0b <krealloc+0x178>
        size = blockSize + SIZE(followingBlock->sizeAndTags);
c0101a77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
c0101a7a:	01 d7                	add    %edx,%edi
        if(size >= reqSize) {
c0101a7c:	39 cf                	cmp    %ecx,%edi
c0101a7e:	72 44                	jb     c0101ac4 <krealloc+0x131>
c0101a80:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
            removeFreeBlock(followingBlock);
c0101a83:	e8 ca fc ff ff       	call   c0101752 <removeFreeBlock>
            blockInfo->sizeAndTags = TAG_USED | PRECEDING_USED(blockInfo);
c0101a88:	8b 46 fc             	mov    -0x4(%esi),%eax
c0101a8b:	83 e0 02             	and    $0x2,%eax
c0101a8e:	83 c8 01             	or     $0x1,%eax
c0101a91:	89 46 fc             	mov    %eax,-0x4(%esi)
            // Free excess space if possible
            if(size - reqSize >= MIN_BLOCK_SIZE) {
c0101a94:	89 fa                	mov    %edi,%edx
c0101a96:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0101a99:	29 ca                	sub    %ecx,%edx
c0101a9b:	83 fa 0f             	cmp    $0xf,%edx
c0101a9e:	76 16                	jbe    c0101ab6 <krealloc+0x123>
                blockInfo->sizeAndTags |= reqSize;
c0101aa0:	09 c8                	or     %ecx,%eax
c0101aa2:	89 46 fc             	mov    %eax,-0x4(%esi)
                freeSurplusBlock(blockInfo, size, reqSize);
c0101aa5:	89 fa                	mov    %edi,%edx
c0101aa7:	8d 46 fc             	lea    -0x4(%esi),%eax
c0101aaa:	e8 5e fd ff ff       	call   c010180d <freeSurplusBlock>
c0101aaf:	89 f3                	mov    %esi,%ebx
c0101ab1:	e9 f5 00 00 00       	jmp    c0101bab <krealloc+0x218>
            } else {
                blockInfo->sizeAndTags |= size;
c0101ab6:	09 f8                	or     %edi,%eax
c0101ab8:	89 46 fc             	mov    %eax,-0x4(%esi)
                *(size_t*)UNSCALED_POINTER_ADD(blockInfo, size) |= TAG_PRECEDING_USED;
c0101abb:	8d 46 fc             	lea    -0x4(%esi),%eax
c0101abe:	83 0c 38 02          	orl    $0x2,(%eax,%edi,1)
c0101ac2:	eb eb                	jmp    c0101aaf <krealloc+0x11c>
            }

            return UNSCALED_POINTER_ADD(blockInfo, WORD_SIZE);
        }
        // If the size of the next block is 0, followingBlock is the last block on the heap
        else if(FOLLOWING_BLOCK_SIZE(followingBlock) == 0) {
c0101ac4:	f7 04 10 fc ff ff ff 	testl  $0xfffffffc,(%eax,%edx,1)
c0101acb:	0f 85 92 00 00 00    	jne    c0101b63 <krealloc+0x1d0>
c0101ad1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
            removeFreeBlock(followingBlock);
c0101ad4:	e8 79 fc ff ff       	call   c0101752 <removeFreeBlock>
            // extend the heap
            mem_sbrk((size_t)(reqSize - size));
c0101ad9:	83 ec 0c             	sub    $0xc,%esp
c0101adc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0101adf:	89 c8                	mov    %ecx,%eax
c0101ae1:	29 f8                	sub    %edi,%eax
c0101ae3:	50                   	push   %eax
c0101ae4:	e8 77 fb ff ff       	call   c0101660 <mem_sbrk>
            blockInfo->sizeAndTags = reqSize | TAG_USED | PRECEDING_USED(blockInfo);
c0101ae9:	8b 46 fc             	mov    -0x4(%esi),%eax
c0101aec:	83 e0 02             	and    $0x2,%eax
c0101aef:	83 c8 01             	or     $0x1,%eax
c0101af2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0101af5:	09 c1                	or     %eax,%ecx
c0101af7:	89 4e fc             	mov    %ecx,-0x4(%esi)
            // Need to create a new heap footer
            *((size_t*)UNSCALED_POINTER_SUB(mem_heap_hi(), WORD_SIZE - 1)) = TAG_PRECEDING_USED | TAG_USED;
c0101afa:	e8 b8 fb ff ff       	call   c01016b7 <mem_heap_hi>
c0101aff:	c7 40 fd 03 00 00 00 	movl   $0x3,-0x3(%eax)

            return UNSCALED_POINTER_ADD(blockInfo, WORD_SIZE);
c0101b06:	83 c4 10             	add    $0x10,%esp
c0101b09:	eb a4                	jmp    c0101aaf <krealloc+0x11c>
        }
    }
    // If the blocks preceding and following the current block are free,
    // attempt to use all three to satisfy the new size requirement, and, if
    // possible, free any excess space.
    if(!PRECEDING_USED(blockInfo) && !USED(followingBlock)) {
c0101b0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101b0f:	75 58                	jne    c0101b69 <krealloc+0x1d6>
        }
    }
    // If the block preceding the current block is free, attempt to use both to
    // satisfy the new size requirement.
    if(!PRECEDING_USED(blockInfo)) {
        size = blockSize + SIZE(blockPreceding->sizeAndTags);
c0101b11:	8b 3b                	mov    (%ebx),%edi
c0101b13:	83 e7 fc             	and    $0xfffffffc,%edi
c0101b16:	03 7d e4             	add    -0x1c(%ebp),%edi
        if(size >= reqSize) {
c0101b19:	39 cf                	cmp    %ecx,%edi
c0101b1b:	72 4c                	jb     c0101b69 <krealloc+0x1d6>
c0101b1d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
            removeFreeBlock(blockPreceding);
c0101b20:	89 d8                	mov    %ebx,%eax
c0101b22:	e8 2b fc ff ff       	call   c0101752 <removeFreeBlock>
            copyPayloadOver(blockInfo, blockPreceding);
c0101b27:	89 da                	mov    %ebx,%edx
c0101b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101b2c:	e8 ab fb ff ff       	call   c01016dc <copyPayloadOver>
            blockPreceding->sizeAndTags = TAG_USED | PRECEDING_USED(blockPreceding);
c0101b31:	8b 03                	mov    (%ebx),%eax
c0101b33:	83 e0 02             	and    $0x2,%eax
c0101b36:	83 c8 01             	or     $0x1,%eax
c0101b39:	89 03                	mov    %eax,(%ebx)
            // Free excess space if possible
            if(size - reqSize >= MIN_BLOCK_SIZE) {
c0101b3b:	89 fa                	mov    %edi,%edx
c0101b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0101b40:	29 ca                	sub    %ecx,%edx
c0101b42:	83 fa 0f             	cmp    $0xf,%edx
c0101b45:	76 0f                	jbe    c0101b56 <krealloc+0x1c3>
                blockPreceding->sizeAndTags |= reqSize;
c0101b47:	09 c8                	or     %ecx,%eax
c0101b49:	89 03                	mov    %eax,(%ebx)
                freeSurplusBlock(blockPreceding, size, reqSize);
c0101b4b:	89 fa                	mov    %edi,%edx
c0101b4d:	89 d8                	mov    %ebx,%eax
c0101b4f:	e8 b9 fc ff ff       	call   c010180d <freeSurplusBlock>
c0101b54:	eb 08                	jmp    c0101b5e <krealloc+0x1cb>
            } else {
                blockPreceding->sizeAndTags |= size;
c0101b56:	09 f8                	or     %edi,%eax
c0101b58:	89 03                	mov    %eax,(%ebx)
                *(size_t*)UNSCALED_POINTER_ADD(blockPreceding, size) |= TAG_PRECEDING_USED;
c0101b5a:	83 0c 3b 02          	orl    $0x2,(%ebx,%edi,1)
            }

            return UNSCALED_POINTER_ADD(blockPreceding, WORD_SIZE);
c0101b5e:	83 c3 04             	add    $0x4,%ebx
c0101b61:	eb 48                	jmp    c0101bab <krealloc+0x218>
        }
    }
    // If the blocks preceding and following the current block are free,
    // attempt to use all three to satisfy the new size requirement, and, if
    // possible, free any excess space.
    if(!PRECEDING_USED(blockInfo) && !USED(followingBlock)) {
c0101b63:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101b67:	74 26                	je     c0101b8f <krealloc+0x1fc>
        }
    }
    // If no previous method can satisfy the reallocation request, allocate a
    // new block and copy the block's data to the new payload and free the old
    // block.
    blockNew = (BlockInfo*)UNSCALED_POINTER_SUB(kmalloc(reqSize - WORD_SIZE), WORD_SIZE);
c0101b69:	83 ec 0c             	sub    $0xc,%esp
c0101b6c:	83 e9 04             	sub    $0x4,%ecx
c0101b6f:	51                   	push   %ecx
c0101b70:	e8 30 fd ff ff       	call   c01018a5 <kmalloc>
c0101b75:	89 c3                	mov    %eax,%ebx
    copyPayloadOver(blockInfo, blockNew);
c0101b77:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101b7a:	8d 46 fc             	lea    -0x4(%esi),%eax
c0101b7d:	e8 5a fb ff ff       	call   c01016dc <copyPayloadOver>
    kfree(UNSCALED_POINTER_ADD(blockInfo, WORD_SIZE));
c0101b82:	89 34 24             	mov    %esi,(%esp)
c0101b85:	e8 e7 fd ff ff       	call   c0101971 <kfree>

    return UNSCALED_POINTER_ADD(blockNew, WORD_SIZE);
c0101b8a:	83 c4 10             	add    $0x10,%esp
c0101b8d:	eb 1c                	jmp    c0101bab <krealloc+0x218>
    }
    // If the blocks preceding and following the current block are free,
    // attempt to use all three to satisfy the new size requirement, and, if
    // possible, free any excess space.
    if(!PRECEDING_USED(blockInfo) && !USED(followingBlock)) {
        size = blockSize + SIZE(followingBlock->sizeAndTags) + SIZE(blockPreceding->sizeAndTags);
c0101b8f:	8b 13                	mov    (%ebx),%edx
c0101b91:	83 e2 fc             	and    $0xfffffffc,%edx
c0101b94:	01 d7                	add    %edx,%edi
        if(size >= reqSize) {
c0101b96:	39 cf                	cmp    %ecx,%edi
c0101b98:	0f 82 73 ff ff ff    	jb     c0101b11 <krealloc+0x17e>
c0101b9e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
            removeFreeBlock(followingBlock);
c0101ba1:	e8 ac fb ff ff       	call   c0101752 <removeFreeBlock>
c0101ba6:	e9 75 ff ff ff       	jmp    c0101b20 <krealloc+0x18d>
    copyPayloadOver(blockInfo, blockNew);
    kfree(UNSCALED_POINTER_ADD(blockInfo, WORD_SIZE));

    return UNSCALED_POINTER_ADD(blockNew, WORD_SIZE);

}
c0101bab:	89 d8                	mov    %ebx,%eax
c0101bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101bb0:	5b                   	pop    %ebx
c0101bb1:	5e                   	pop    %esi
c0101bb2:	5f                   	pop    %edi
c0101bb3:	5d                   	pop    %ebp
c0101bb4:	c3                   	ret    

c0101bb5 <_vaddr.constprop.0>:
// #define VADDR(a)    (((size_t) a) + KADDR)

#define VADDR(pa) _vaddr(__FILE__, __LINE__, (size_t) pa)

static inline void*
_vaddr(const char* file, int line, size_t pa) {
c0101bb5:	55                   	push   %ebp
c0101bb6:	89 e5                	mov    %esp,%ebp
c0101bb8:	53                   	push   %ebx
c0101bb9:	51                   	push   %ecx
c0101bba:	89 d3                	mov    %edx,%ebx
    if (PA2PM(pa) >= npages)
c0101bbc:	c1 ea 0c             	shr    $0xc,%edx
c0101bbf:	3b 15 88 6e 13 c0    	cmp    0xc0136e88,%edx
c0101bc5:	72 21                	jb     c0101be8 <_vaddr.constprop.0+0x33>
        panic(file, line, "VADDR called with invalid pa %08x", pa);
c0101bc7:	52                   	push   %edx
c0101bc8:	53                   	push   %ebx
c0101bc9:	68 16 b1 10 c0       	push   $0xc010b116
c0101bce:	50                   	push   %eax
c0101bcf:	68 9d b1 10 c0       	push   $0xc010b19d
c0101bd4:	68 68 b2 10 c0       	push   $0xc010b268
c0101bd9:	6a 43                	push   $0x43
c0101bdb:	68 28 b0 10 c0       	push   $0xc010b028
c0101be0:	e8 5d 1d 00 00       	call   c0103942 <_panic>
c0101be5:	83 c4 20             	add    $0x20,%esp
    return (void*)(pa + KADDR);
c0101be8:	8d 83 00 00 00 c0    	lea    -0x40000000(%ebx),%eax
}
c0101bee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101bf1:	c9                   	leave  
c0101bf2:	c3                   	ret    

c0101bf3 <print_table_header>:
          PADDR(rsdp), (rsdp->revision) ? rsdp->length : 20,
          rsdp->revision, rsdp->oem_id);
}

static void
print_table_header(struct acpi_table_header* hdr) {
c0101bf3:	55                   	push   %ebp
c0101bf4:	89 e5                	mov    %esp,%ebp
c0101bf6:	57                   	push   %edi
c0101bf7:	56                   	push   %esi
c0101bf8:	53                   	push   %ebx
c0101bf9:	83 ec 2c             	sub    $0x2c,%esp
c0101bfc:	89 c2                	mov    %eax,%edx
    print("ACPI: %.4s %08p %06x v%02d %.6s %.8s %02d %.4s %02d\n",
c0101bfe:	8b 48 20             	mov    0x20(%eax),%ecx
          hdr->signature, PADDR(hdr), hdr->length, hdr->revision,
          hdr->oem_id, hdr->oem_table_id, hdr->oem_revision,
          hdr->asl_compiler_id, hdr->asl_compiler_revision);
c0101c01:	83 c0 1c             	add    $0x1c,%eax
c0101c04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          rsdp->revision, rsdp->oem_id);
}

static void
print_table_header(struct acpi_table_header* hdr) {
    print("ACPI: %.4s %08p %06x v%02d %.6s %.8s %02d %.4s %02d\n",
c0101c07:	8b 42 18             	mov    0x18(%edx),%eax
          hdr->signature, PADDR(hdr), hdr->length, hdr->revision,
          hdr->oem_id, hdr->oem_table_id, hdr->oem_revision,
c0101c0a:	8d 7a 10             	lea    0x10(%edx),%edi
c0101c0d:	8d 72 0a             	lea    0xa(%edx),%esi
          rsdp->revision, rsdp->oem_id);
}

static void
print_table_header(struct acpi_table_header* hdr) {
    print("ACPI: %.4s %08p %06x v%02d %.6s %.8s %02d %.4s %02d\n",
c0101c10:	0f b6 5a 08          	movzbl 0x8(%edx),%ebx
c0101c14:	89 5d e0             	mov    %ebx,-0x20(%ebp)
c0101c17:	8b 5a 04             	mov    0x4(%edx),%ebx

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
c0101c1a:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
c0101c20:	77 34                	ja     c0101c56 <print_table_header+0x63>
c0101c22:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0101c25:	89 4d d8             	mov    %ecx,-0x28(%ebp)
        panic(file, line, "PADDR called with invalid va %08x", va);
c0101c28:	50                   	push   %eax
c0101c29:	52                   	push   %edx
c0101c2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0101c2d:	68 06 b0 10 c0       	push   $0xc010b006
c0101c32:	6a 18                	push   $0x18
c0101c34:	68 9d b1 10 c0       	push   $0xc010b19d
c0101c39:	68 70 b2 10 c0       	push   $0xc010b270
c0101c3e:	6a 38                	push   $0x38
c0101c40:	68 28 b0 10 c0       	push   $0xc010b028
c0101c45:	e8 f8 1c 00 00       	call   c0103942 <_panic>
c0101c4a:	83 c4 20             	add    $0x20,%esp
c0101c4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101c50:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101c53:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101c56:	83 ec 08             	sub    $0x8,%esp
c0101c59:	51                   	push   %ecx
c0101c5a:	ff 75 e4             	pushl  -0x1c(%ebp)
c0101c5d:	50                   	push   %eax
c0101c5e:	57                   	push   %edi
c0101c5f:	56                   	push   %esi
c0101c60:	ff 75 e0             	pushl  -0x20(%ebp)
c0101c63:	53                   	push   %ebx
c0101c64:	8d 82 00 00 00 40    	lea    0x40000000(%edx),%eax
c0101c6a:	50                   	push   %eax
c0101c6b:	52                   	push   %edx
c0101c6c:	68 a7 b1 10 c0       	push   $0xc010b1a7
c0101c71:	e8 4e 21 00 00       	call   c0103dc4 <print>
          hdr->signature, PADDR(hdr), hdr->length, hdr->revision,
          hdr->oem_id, hdr->oem_table_id, hdr->oem_revision,
          hdr->asl_compiler_id, hdr->asl_compiler_revision);
}
c0101c76:	83 c4 30             	add    $0x30,%esp
c0101c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101c7c:	5b                   	pop    %ebx
c0101c7d:	5e                   	pop    %esi
c0101c7e:	5f                   	pop    %edi
c0101c7f:	5d                   	pop    %ebp
c0101c80:	c3                   	ret    

c0101c81 <rsdp_search1>:
    return sum;
}

// Look for the RSDP in the len bytes at physical address addr.
static struct acpi_table_rsdp*
rsdp_search1(size_t a, int len) {
c0101c81:	55                   	push   %ebp
c0101c82:	89 e5                	mov    %esp,%ebp
c0101c84:	57                   	push   %edi
c0101c85:	56                   	push   %esi
c0101c86:	53                   	push   %ebx
c0101c87:	83 ec 0c             	sub    $0xc,%esp
c0101c8a:	89 c6                	mov    %eax,%esi
c0101c8c:	89 d7                	mov    %edx,%edi
    void* p = VADDR(a), *e = VADDR(a + len);
c0101c8e:	89 c2                	mov    %eax,%edx
c0101c90:	b8 2a 00 00 00       	mov    $0x2a,%eax
c0101c95:	e8 1b ff ff ff       	call   c0101bb5 <_vaddr.constprop.0>
c0101c9a:	89 c3                	mov    %eax,%ebx
c0101c9c:	8d 14 37             	lea    (%edi,%esi,1),%edx
c0101c9f:	b8 2a 00 00 00       	mov    $0x2a,%eax
c0101ca4:	e8 0c ff ff ff       	call   c0101bb5 <_vaddr.constprop.0>
c0101ca9:	89 c6                	mov    %eax,%esi

    // The signature is on a 16-byte boundary.
    for (; p < e; p += 16) {
c0101cab:	39 f3                	cmp    %esi,%ebx
c0101cad:	73 4a                	jae    c0101cf9 <rsdp_search1+0x78>
        struct acpi_table_rsdp* rsdp = p;

        if (memcmp(rsdp->signature, ACPI_SIG_RSDP, 8) ||
c0101caf:	50                   	push   %eax
c0101cb0:	6a 08                	push   $0x8
c0101cb2:	68 dc b1 10 c0       	push   $0xc010b1dc
c0101cb7:	53                   	push   %ebx
c0101cb8:	e8 30 28 00 00       	call   c01044ed <memcmp>
c0101cbd:	83 c4 10             	add    $0x10,%esp
c0101cc0:	85 c0                	test   %eax,%eax
c0101cc2:	75 30                	jne    c0101cf4 <rsdp_search1+0x73>
c0101cc4:	31 d2                	xor    %edx,%edx
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
    for (i = 0; i < len; i++)
        sum += ((uint8_t*) addr)[i];
c0101cc6:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
c0101cca:	01 ca                	add    %ecx,%edx
static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
    for (i = 0; i < len; i++)
c0101ccc:	40                   	inc    %eax
c0101ccd:	83 f8 14             	cmp    $0x14,%eax
c0101cd0:	75 f4                	jne    c0101cc6 <rsdp_search1+0x45>

    // The signature is on a 16-byte boundary.
    for (; p < e; p += 16) {
        struct acpi_table_rsdp* rsdp = p;

        if (memcmp(rsdp->signature, ACPI_SIG_RSDP, 8) ||
c0101cd2:	84 d2                	test   %dl,%dl
c0101cd4:	75 1e                	jne    c0101cf4 <rsdp_search1+0x73>
                sum(rsdp, 20))
            continue;
        // ACPI 2.0+
        if (rsdp->revision && sum(rsdp, rsdp->length))
c0101cd6:	80 7b 0f 00          	cmpb   $0x0,0xf(%ebx)
c0101cda:	74 21                	je     c0101cfd <rsdp_search1+0x7c>
c0101cdc:	8b 4b 14             	mov    0x14(%ebx),%ecx

static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
c0101cdf:	31 d2                	xor    %edx,%edx
    for (i = 0; i < len; i++)
c0101ce1:	31 c0                	xor    %eax,%eax
c0101ce3:	39 c1                	cmp    %eax,%ecx
c0101ce5:	7e 09                	jle    c0101cf0 <rsdp_search1+0x6f>
        sum += ((uint8_t*) addr)[i];
c0101ce7:	0f b6 3c 03          	movzbl (%ebx,%eax,1),%edi
c0101ceb:	01 fa                	add    %edi,%edx
static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
    for (i = 0; i < len; i++)
c0101ced:	40                   	inc    %eax
c0101cee:	eb f3                	jmp    c0101ce3 <rsdp_search1+0x62>

        if (memcmp(rsdp->signature, ACPI_SIG_RSDP, 8) ||
                sum(rsdp, 20))
            continue;
        // ACPI 2.0+
        if (rsdp->revision && sum(rsdp, rsdp->length))
c0101cf0:	84 d2                	test   %dl,%dl
c0101cf2:	74 09                	je     c0101cfd <rsdp_search1+0x7c>
static struct acpi_table_rsdp*
rsdp_search1(size_t a, int len) {
    void* p = VADDR(a), *e = VADDR(a + len);

    // The signature is on a 16-byte boundary.
    for (; p < e; p += 16) {
c0101cf4:	83 c3 10             	add    $0x10,%ebx
c0101cf7:	eb b2                	jmp    c0101cab <rsdp_search1+0x2a>
        // ACPI 2.0+
        if (rsdp->revision && sum(rsdp, rsdp->length))
            continue;
        return rsdp;
    }
    return NULL;
c0101cf9:	31 c0                	xor    %eax,%eax
c0101cfb:	eb 02                	jmp    c0101cff <rsdp_search1+0x7e>
c0101cfd:	89 d8                	mov    %ebx,%eax
}
c0101cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101d02:	5b                   	pop    %ebx
c0101d03:	5e                   	pop    %esi
c0101d04:	5f                   	pop    %edi
c0101d05:	5d                   	pop    %ebp
c0101d06:	c3                   	ret    

c0101d07 <init_acpi>:
        return rsdp;
    return rsdp_search1(0xE0000, 0x20000);
}

void
init_acpi(void) {
c0101d07:	55                   	push   %ebp
c0101d08:	89 e5                	mov    %esp,%ebp
c0101d0a:	57                   	push   %edi
c0101d0b:	56                   	push   %esi
c0101d0c:	53                   	push   %ebx
c0101d0d:	83 ec 1c             	sub    $0x1c,%esp
rsdp_search(void) {
    size_t ebda;
    struct acpi_table_rsdp* rsdp;

    // The 16-bit segment of the EBDA is in the two byte at 0x40:0x0E.
    ebda = *(uint16_t*) VADDR(0x40E);
c0101d10:	ba 0e 04 00 00       	mov    $0x40e,%edx
c0101d15:	b8 44 00 00 00       	mov    $0x44,%eax
c0101d1a:	e8 96 fe ff ff       	call   c0101bb5 <_vaddr.constprop.0>
c0101d1f:	0f b7 00             	movzwl (%eax),%eax
    ebda <<= 4;
    if ((rsdp = rsdp_search1(ebda, 1024)))
c0101d22:	c1 e0 04             	shl    $0x4,%eax
c0101d25:	ba 00 04 00 00       	mov    $0x400,%edx
c0101d2a:	e8 52 ff ff ff       	call   c0101c81 <rsdp_search1>
c0101d2f:	89 c3                	mov    %eax,%ebx
c0101d31:	85 c0                	test   %eax,%eax
c0101d33:	75 32                	jne    c0101d67 <init_acpi+0x60>
        return rsdp;
    return rsdp_search1(0xE0000, 0x20000);
c0101d35:	ba 00 00 02 00       	mov    $0x20000,%edx
c0101d3a:	b8 00 00 0e 00       	mov    $0xe0000,%eax
c0101d3f:	e8 3d ff ff ff       	call   c0101c81 <rsdp_search1>
c0101d44:	89 c3                	mov    %eax,%ebx
    size_t entry_size;
    void* p, *e;
    uint32_t i;

    rsdp = rsdp_search();
    if (!rsdp)
c0101d46:	85 c0                	test   %eax,%eax
c0101d48:	75 1d                	jne    c0101d67 <init_acpi+0x60>
        panic("ACPI: No RSDP found");
c0101d4a:	68 ef b1 10 c0       	push   $0xc010b1ef
c0101d4f:	68 78 b2 10 c0       	push   $0xc010b278
c0101d54:	6a 56                	push   $0x56
c0101d56:	68 9d b1 10 c0       	push   $0xc010b19d
c0101d5b:	e8 e2 1b 00 00       	call   c0103942 <_panic>

static void
print_table_rsdp(struct acpi_table_rsdp* rsdp) {
    print("ACPI: RSDP %08p %06x v%02d %.6s\n",
          PADDR(rsdp), (rsdp->revision) ? rsdp->length : 20,
          rsdp->revision, rsdp->oem_id);
c0101d60:	a0 0f 00 00 00       	mov    0xf,%al
c0101d65:	0f 0b                	ud2    
c0101d67:	8d 53 09             	lea    0x9(%ebx),%edx
c0101d6a:	0f b6 7b 0f          	movzbl 0xf(%ebx),%edi
c0101d6e:	89 f8                	mov    %edi,%eax

static struct acpi_tables acpi_tables;

static void
print_table_rsdp(struct acpi_table_rsdp* rsdp) {
    print("ACPI: RSDP %08p %06x v%02d %.6s\n",
c0101d70:	be 14 00 00 00       	mov    $0x14,%esi
c0101d75:	84 c0                	test   %al,%al
c0101d77:	74 03                	je     c0101d7c <init_acpi+0x75>
c0101d79:	8b 73 14             	mov    0x14(%ebx),%esi

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
c0101d7c:	81 fb ff ff ff bf    	cmp    $0xbfffffff,%ebx
c0101d82:	77 28                	ja     c0101dac <init_acpi+0xa5>
c0101d84:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        panic(file, line, "PADDR called with invalid va %08x", va);
c0101d87:	52                   	push   %edx
c0101d88:	53                   	push   %ebx
c0101d89:	68 06 b0 10 c0       	push   $0xc010b006
c0101d8e:	6a 11                	push   $0x11
c0101d90:	68 9d b1 10 c0       	push   $0xc010b19d
c0101d95:	68 70 b2 10 c0       	push   $0xc010b270
c0101d9a:	6a 38                	push   $0x38
c0101d9c:	68 28 b0 10 c0       	push   $0xc010b028
c0101da1:	e8 9c 1b 00 00       	call   c0103942 <_panic>
c0101da6:	83 c4 20             	add    $0x20,%esp
c0101da9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101dac:	83 ec 0c             	sub    $0xc,%esp
c0101daf:	52                   	push   %edx
c0101db0:	57                   	push   %edi
c0101db1:	56                   	push   %esi
c0101db2:	8d 83 00 00 00 40    	lea    0x40000000(%ebx),%eax
c0101db8:	50                   	push   %eax
c0101db9:	68 03 b2 10 c0       	push   $0xc010b203
c0101dbe:	e8 01 20 00 00       	call   c0103dc4 <print>
    rsdp = rsdp_search();
    if (!rsdp)
        panic("ACPI: No RSDP found");
    print_table_rsdp(rsdp);

    if (rsdp->revision) {
c0101dc3:	83 c4 20             	add    $0x20,%esp
c0101dc6:	80 7b 0f 00          	cmpb   $0x0,0xf(%ebx)
c0101dca:	74 1d                	je     c0101de9 <init_acpi+0xe2>
        hdr = VADDR(rsdp->xsdt_physical_address);
c0101dcc:	8b 53 18             	mov    0x18(%ebx),%edx
c0101dcf:	b8 5a 00 00 00       	mov    $0x5a,%eax
c0101dd4:	e8 dc fd ff ff       	call   c0101bb5 <_vaddr.constprop.0>
c0101dd9:	89 c3                	mov    %eax,%ebx
        sig = ACPI_SIG_XSDT;
        entry_size = 8;
c0101ddb:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%ebp)
        panic("ACPI: No RSDP found");
    print_table_rsdp(rsdp);

    if (rsdp->revision) {
        hdr = VADDR(rsdp->xsdt_physical_address);
        sig = ACPI_SIG_XSDT;
c0101de2:	be e5 b1 10 c0       	mov    $0xc010b1e5,%esi
c0101de7:	eb 1b                	jmp    c0101e04 <init_acpi+0xfd>
        entry_size = 8;
    } else {
        hdr = VADDR(rsdp->rsdt_physical_address);
c0101de9:	8b 53 10             	mov    0x10(%ebx),%edx
c0101dec:	b8 5e 00 00 00       	mov    $0x5e,%eax
c0101df1:	e8 bf fd ff ff       	call   c0101bb5 <_vaddr.constprop.0>
c0101df6:	89 c3                	mov    %eax,%ebx
        sig = ACPI_SIG_RSDT;
        entry_size = 4;
c0101df8:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        hdr = VADDR(rsdp->xsdt_physical_address);
        sig = ACPI_SIG_XSDT;
        entry_size = 8;
    } else {
        hdr = VADDR(rsdp->rsdt_physical_address);
        sig = ACPI_SIG_RSDT;
c0101dff:	be ea b1 10 c0       	mov    $0xc010b1ea,%esi
        entry_size = 4;
    }

    if (memcmp(hdr->signature, sig, 4))
c0101e04:	50                   	push   %eax
c0101e05:	6a 04                	push   $0x4
c0101e07:	56                   	push   %esi
c0101e08:	53                   	push   %ebx
c0101e09:	e8 df 26 00 00       	call   c01044ed <memcmp>
c0101e0e:	83 c4 10             	add    $0x10,%esp
c0101e11:	85 c0                	test   %eax,%eax
c0101e13:	74 1d                	je     c0101e32 <init_acpi+0x12b>
        panic("ACPI: Incorrect %s signature", sig);
c0101e15:	83 ec 0c             	sub    $0xc,%esp
c0101e18:	56                   	push   %esi
c0101e19:	68 24 b2 10 c0       	push   $0xc010b224
c0101e1e:	68 78 b2 10 c0       	push   $0xc010b278
c0101e23:	6a 64                	push   $0x64
c0101e25:	68 9d b1 10 c0       	push   $0xc010b19d
c0101e2a:	e8 13 1b 00 00       	call   c0103942 <_panic>
c0101e2f:	83 c4 20             	add    $0x20,%esp
    if (sum(hdr, hdr->length))
c0101e32:	8b 4b 04             	mov    0x4(%ebx),%ecx

static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
c0101e35:	31 d2                	xor    %edx,%edx
    for (i = 0; i < len; i++)
c0101e37:	31 c0                	xor    %eax,%eax
c0101e39:	39 c1                	cmp    %eax,%ecx
c0101e3b:	7e 09                	jle    c0101e46 <init_acpi+0x13f>
        sum += ((uint8_t*) addr)[i];
c0101e3d:	0f b6 3c 03          	movzbl (%ebx,%eax,1),%edi
c0101e41:	01 fa                	add    %edi,%edx
static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
    for (i = 0; i < len; i++)
c0101e43:	40                   	inc    %eax
c0101e44:	eb f3                	jmp    c0101e39 <init_acpi+0x132>
        entry_size = 4;
    }

    if (memcmp(hdr->signature, sig, 4))
        panic("ACPI: Incorrect %s signature", sig);
    if (sum(hdr, hdr->length))
c0101e46:	84 d2                	test   %dl,%dl
c0101e48:	74 1d                	je     c0101e67 <init_acpi+0x160>
        panic("ACPI: Bad %s checksum", sig);
c0101e4a:	83 ec 0c             	sub    $0xc,%esp
c0101e4d:	56                   	push   %esi
c0101e4e:	68 41 b2 10 c0       	push   $0xc010b241
c0101e53:	68 78 b2 10 c0       	push   $0xc010b278
c0101e58:	6a 66                	push   $0x66
c0101e5a:	68 9d b1 10 c0       	push   $0xc010b19d
c0101e5f:	e8 de 1a 00 00       	call   c0103942 <_panic>
c0101e64:	83 c4 20             	add    $0x20,%esp
    print_table_header(hdr);
c0101e67:	89 d8                	mov    %ebx,%eax
c0101e69:	e8 85 fd ff ff       	call   c0101bf3 <print_table_header>

    p = hdr + 1;
c0101e6e:	8d 73 24             	lea    0x24(%ebx),%esi
    e = (void*)hdr + hdr->length;
c0101e71:	8b 43 04             	mov    0x4(%ebx),%eax
c0101e74:	01 d8                	add    %ebx,%eax
c0101e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (i = 0; p < e; p += entry_size) {
c0101e79:	31 db                	xor    %ebx,%ebx
c0101e7b:	3b 75 e0             	cmp    -0x20(%ebp),%esi
c0101e7e:	73 6b                	jae    c0101eeb <init_acpi+0x1e4>
        hdr = VADDR(*(uint32_t*)p);
c0101e80:	8b 16                	mov    (%esi),%edx
c0101e82:	b8 6c 00 00 00       	mov    $0x6c,%eax
c0101e87:	e8 29 fd ff ff       	call   c0101bb5 <_vaddr.constprop.0>
c0101e8c:	89 c7                	mov    %eax,%edi
        if (sum(hdr, hdr->length))
c0101e8e:	8b 40 04             	mov    0x4(%eax),%eax
c0101e91:	89 45 dc             	mov    %eax,-0x24(%ebp)

static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
c0101e94:	31 d2                	xor    %edx,%edx
    for (i = 0; i < len; i++)
c0101e96:	31 c0                	xor    %eax,%eax
c0101e98:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0101e9b:	7e 09                	jle    c0101ea6 <init_acpi+0x19f>
        sum += ((uint8_t*) addr)[i];
c0101e9d:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
c0101ea1:	01 ca                	add    %ecx,%edx
static uint8_t
sum(void* addr, int len) {
    int i, sum;

    sum = 0;
    for (i = 0; i < len; i++)
c0101ea3:	40                   	inc    %eax
c0101ea4:	eb f2                	jmp    c0101e98 <init_acpi+0x191>

    p = hdr + 1;
    e = (void*)hdr + hdr->length;
    for (i = 0; p < e; p += entry_size) {
        hdr = VADDR(*(uint32_t*)p);
        if (sum(hdr, hdr->length))
c0101ea6:	84 d2                	test   %dl,%dl
c0101ea8:	75 3c                	jne    c0101ee6 <init_acpi+0x1df>
            continue;
        print_table_header(hdr);
c0101eaa:	89 f8                	mov    %edi,%eax
c0101eac:	e8 42 fd ff ff       	call   c0101bf3 <print_table_header>
        assert(i < ACPI_NR_MAX);
c0101eb1:	83 fb 1f             	cmp    $0x1f,%ebx
c0101eb4:	76 28                	jbe    c0101ede <init_acpi+0x1d7>
c0101eb6:	83 ec 0c             	sub    $0xc,%esp
c0101eb9:	68 78 b2 10 c0       	push   $0xc010b278
c0101ebe:	6a 70                	push   $0x70
c0101ec0:	68 9d b1 10 c0       	push   $0xc010b19d
c0101ec5:	68 57 b2 10 c0       	push   $0xc010b257
c0101eca:	68 95 a9 10 c0       	push   $0xc010a995
c0101ecf:	e8 f0 1e 00 00       	call   c0103dc4 <print>
c0101ed4:	83 c4 20             	add    $0x20,%esp
c0101ed7:	e8 6e ef ff ff       	call   c0100e4a <backtrace>
c0101edc:	fa                   	cli    
c0101edd:	f4                   	hlt    
        acpi_tables.entries[i++] = hdr;
c0101ede:	89 3c 9d e4 68 13 c0 	mov    %edi,-0x3fec971c(,%ebx,4)
c0101ee5:	43                   	inc    %ebx
        panic("ACPI: Bad %s checksum", sig);
    print_table_header(hdr);

    p = hdr + 1;
    e = (void*)hdr + hdr->length;
    for (i = 0; p < e; p += entry_size) {
c0101ee6:	03 75 e4             	add    -0x1c(%ebp),%esi
c0101ee9:	eb 90                	jmp    c0101e7b <init_acpi+0x174>
            continue;
        print_table_header(hdr);
        assert(i < ACPI_NR_MAX);
        acpi_tables.entries[i++] = hdr;
    }
    acpi_tables.nr = i;
c0101eeb:	89 1d e0 68 13 c0    	mov    %ebx,0xc01368e0
}
c0101ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0101ef4:	5b                   	pop    %ebx
c0101ef5:	5e                   	pop    %esi
c0101ef6:	5f                   	pop    %edi
c0101ef7:	5d                   	pop    %ebp
c0101ef8:	c3                   	ret    

c0101ef9 <acpi_get_table>:

void*
acpi_get_table(const char* signature) {
c0101ef9:	55                   	push   %ebp
c0101efa:	89 e5                	mov    %esp,%ebp
c0101efc:	56                   	push   %esi
c0101efd:	53                   	push   %ebx
    uint32_t i;
    struct acpi_table_header** phdr = acpi_tables.entries;
c0101efe:	bb e4 68 13 c0       	mov    $0xc01368e4,%ebx

    for (i = 0; i < acpi_tables.nr; ++i, ++phdr) {
c0101f03:	31 f6                	xor    %esi,%esi
c0101f05:	3b 35 e0 68 13 c0    	cmp    0xc01368e0,%esi
c0101f0b:	73 1e                	jae    c0101f2b <acpi_get_table+0x32>
        if (!memcmp((*phdr)->signature, signature, 4))
c0101f0d:	50                   	push   %eax
c0101f0e:	6a 04                	push   $0x4
c0101f10:	ff 75 08             	pushl  0x8(%ebp)
c0101f13:	ff 33                	pushl  (%ebx)
c0101f15:	e8 d3 25 00 00       	call   c01044ed <memcmp>
c0101f1a:	83 c4 10             	add    $0x10,%esp
c0101f1d:	85 c0                	test   %eax,%eax
c0101f1f:	75 04                	jne    c0101f25 <acpi_get_table+0x2c>
            return *phdr;
c0101f21:	8b 03                	mov    (%ebx),%eax
c0101f23:	eb 08                	jmp    c0101f2d <acpi_get_table+0x34>
void*
acpi_get_table(const char* signature) {
    uint32_t i;
    struct acpi_table_header** phdr = acpi_tables.entries;

    for (i = 0; i < acpi_tables.nr; ++i, ++phdr) {
c0101f25:	46                   	inc    %esi
c0101f26:	83 c3 04             	add    $0x4,%ebx
c0101f29:	eb da                	jmp    c0101f05 <acpi_get_table+0xc>
        if (!memcmp((*phdr)->signature, signature, 4))
            return *phdr;
    }
    return NULL;
c0101f2b:	31 c0                	xor    %eax,%eax
}
c0101f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101f30:	5b                   	pop    %ebx
c0101f31:	5e                   	pop    %esi
c0101f32:	5d                   	pop    %ebp
c0101f33:	c3                   	ret    

c0101f34 <scroll>:

static size_t addr_6845;


/* Scrolls the screen */
void scroll(void) {
c0101f34:	55                   	push   %ebp
c0101f35:	89 e5                	mov    %esp,%ebp
c0101f37:	83 ec 0c             	sub    $0xc,%esp
    memcpy(crt.buf, crt.buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101f3a:	a1 b8 76 13 c0       	mov    0xc01376b8,%eax
c0101f3f:	68 00 0f 00 00       	push   $0xf00
c0101f44:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101f4a:	52                   	push   %edx
c0101f4b:	50                   	push   %eax
c0101f4c:	e8 45 25 00 00       	call   c0104496 <memcpy>

    for (int i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; ++i)
        crt.buf[i] = attrib | ' ';
c0101f51:	8b 0d b8 76 13 c0    	mov    0xc01376b8,%ecx
c0101f57:	83 c4 10             	add    $0x10,%esp

/* Scrolls the screen */
void scroll(void) {
    memcpy(crt.buf, crt.buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));

    for (int i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; ++i)
c0101f5a:	b8 80 07 00 00       	mov    $0x780,%eax
        crt.buf[i] = attrib | ' ';
c0101f5f:	66 8b 15 04 50 13 c0 	mov    0xc0135004,%dx
c0101f66:	83 ca 20             	or     $0x20,%edx
c0101f69:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)

/* Scrolls the screen */
void scroll(void) {
    memcpy(crt.buf, crt.buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));

    for (int i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; ++i)
c0101f6d:	40                   	inc    %eax
c0101f6e:	3d d0 07 00 00       	cmp    $0x7d0,%eax
c0101f73:	75 ea                	jne    c0101f5f <scroll+0x2b>
        crt.buf[i] = attrib | ' ';

    crt.pos -= CRT_COLS;
c0101f75:	66 83 2d bc 76 13 c0 	subw   $0x50,0xc01376bc
c0101f7c:	50 
}
c0101f7d:	c9                   	leave  
c0101f7e:	c3                   	ret    

c0101f7f <update_cursor>:

// Updates the positoin of the blinking cursor
void update_cursor(void) {
c0101f7f:	55                   	push   %ebp
c0101f80:	89 e5                	mov    %esp,%ebp
c0101f82:	53                   	push   %ebx
    outb(addr_6845, 14);
c0101f83:	8b 0d 64 69 13 c0    	mov    0xc0136964,%ecx
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101f89:	b0 0e                	mov    $0xe,%al
c0101f8b:	89 ca                	mov    %ecx,%edx
c0101f8d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt.pos >> 8);
c0101f8e:	8d 59 01             	lea    0x1(%ecx),%ebx
c0101f91:	a1 bc 76 13 c0       	mov    0xc01376bc,%eax
c0101f96:	66 c1 e8 08          	shr    $0x8,%ax
c0101f9a:	89 da                	mov    %ebx,%edx
c0101f9c:	ee                   	out    %al,(%dx)
c0101f9d:	b0 0f                	mov    $0xf,%al
c0101f9f:	89 ca                	mov    %ecx,%edx
c0101fa1:	ee                   	out    %al,(%dx)
c0101fa2:	a0 bc 76 13 c0       	mov    0xc01376bc,%al
c0101fa7:	89 da                	mov    %ebx,%edx
c0101fa9:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
    outb(addr_6845 + 1, crt.pos);
}
c0101faa:	5b                   	pop    %ebx
c0101fab:	5d                   	pop    %ebp
c0101fac:	c3                   	ret    

c0101fad <cls>:

// Clears the console
void cls() {
c0101fad:	55                   	push   %ebp
c0101fae:	89 e5                	mov    %esp,%ebp
c0101fb0:	56                   	push   %esi
c0101fb1:	53                   	push   %ebx
    unsigned blank = attrib | ' ';
c0101fb2:	66 8b 1d 04 50 13 c0 	mov    0xc0135004,%bx
c0101fb9:	83 cb 20             	or     $0x20,%ebx
c0101fbc:	be d0 07 00 00       	mov    $0x7d0,%esi

    for(int i = 0; i < CRT_SIZE; ++i)
        memsetw(crt.buf, blank, CRT_SIZE);
c0101fc1:	0f b7 db             	movzwl %bx,%ebx
c0101fc4:	50                   	push   %eax
c0101fc5:	68 d0 07 00 00       	push   $0x7d0
c0101fca:	53                   	push   %ebx
c0101fcb:	ff 35 b8 76 13 c0    	pushl  0xc01376b8
c0101fd1:	e8 fe 24 00 00       	call   c01044d4 <memsetw>

// Clears the console
void cls() {
    unsigned blank = attrib | ' ';

    for(int i = 0; i < CRT_SIZE; ++i)
c0101fd6:	83 c4 10             	add    $0x10,%esp
c0101fd9:	4e                   	dec    %esi
c0101fda:	75 e8                	jne    c0101fc4 <cls+0x17>
        memsetw(crt.buf, blank, CRT_SIZE);

    crt.pos = 0;
c0101fdc:	66 c7 05 bc 76 13 c0 	movw   $0x0,0xc01376bc
c0101fe3:	00 00 
    update_cursor();
}
c0101fe5:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101fe8:	5b                   	pop    %ebx
c0101fe9:	5e                   	pop    %esi
c0101fea:	5d                   	pop    %ebp

    for(int i = 0; i < CRT_SIZE; ++i)
        memsetw(crt.buf, blank, CRT_SIZE);

    crt.pos = 0;
    update_cursor();
c0101feb:	e9 8f ff ff ff       	jmp    c0101f7f <update_cursor>

c0101ff0 <putc_cga>:
}

/* Puts a single character on the screen */
void putc_cga(const char c) {
c0101ff0:	55                   	push   %ebp
c0101ff1:	89 e5                	mov    %esp,%ebp
c0101ff3:	83 ec 08             	sub    $0x8,%esp
c0101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (c) {
c0101ff9:	3c 09                	cmp    $0x9,%al
c0101ffb:	74 72                	je     c010206f <putc_cga+0x7f>
c0101ffd:	7f 09                	jg     c0102008 <putc_cga+0x18>
c0101fff:	3c 08                	cmp    $0x8,%al
c0102001:	74 12                	je     c0102015 <putc_cga+0x25>
c0102003:	e9 ea 00 00 00       	jmp    c01020f2 <putc_cga+0x102>
c0102008:	3c 0a                	cmp    $0xa,%al
c010200a:	74 3a                	je     c0102046 <putc_cga+0x56>
c010200c:	3c 0d                	cmp    $0xd,%al
c010200e:	74 3e                	je     c010204e <putc_cga+0x5e>
c0102010:	e9 dd 00 00 00       	jmp    c01020f2 <putc_cga+0x102>
        case '\b':
            if (crt.pos > 0) {
c0102015:	a1 bc 76 13 c0       	mov    0xc01376bc,%eax
c010201a:	66 85 c0             	test   %ax,%ax
c010201d:	0f 84 fb 00 00 00    	je     c010211e <putc_cga+0x12e>
                crt.pos--;
c0102023:	48                   	dec    %eax
c0102024:	66 a3 bc 76 13 c0    	mov    %ax,0xc01376bc
                crt.buf[crt.pos] = attrib | ' ';
c010202a:	0f b7 c0             	movzwl %ax,%eax
c010202d:	66 8b 15 04 50 13 c0 	mov    0xc0135004,%dx
c0102034:	83 ca 20             	or     $0x20,%edx
c0102037:	8b 0d b8 76 13 c0    	mov    0xc01376b8,%ecx
c010203d:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
c0102041:	e9 d8 00 00 00       	jmp    c010211e <putc_cga+0x12e>
            }
            break;
        case '\n':
            crt.pos += CRT_COLS;
c0102046:	66 83 05 bc 76 13 c0 	addw   $0x50,0xc01376bc
c010204d:	50 
        // fallthru
        case '\r':
            crt.pos -= (crt.pos % CRT_COLS);
c010204e:	b9 50 00 00 00       	mov    $0x50,%ecx
c0102053:	a1 bc 76 13 c0       	mov    0xc01376bc,%eax
c0102058:	31 d2                	xor    %edx,%edx
c010205a:	66 f7 f1             	div    %cx
c010205d:	a1 bc 76 13 c0       	mov    0xc01376bc,%eax
c0102062:	29 d0                	sub    %edx,%eax
c0102064:	66 a3 bc 76 13 c0    	mov    %ax,0xc01376bc
            break;
c010206a:	e9 af 00 00 00       	jmp    c010211e <putc_cga+0x12e>
        case '\t':
            crt.buf[crt.pos++] = attrib | ' ';
c010206f:	a1 b8 76 13 c0       	mov    0xc01376b8,%eax
c0102074:	0f b7 15 bc 76 13 c0 	movzwl 0xc01376bc,%edx
c010207b:	8d 4a 01             	lea    0x1(%edx),%ecx
c010207e:	66 89 0d bc 76 13 c0 	mov    %cx,0xc01376bc
c0102085:	66 8b 0d 04 50 13 c0 	mov    0xc0135004,%cx
c010208c:	83 c9 20             	or     $0x20,%ecx
c010208f:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
            crt.buf[crt.pos++] = attrib | ' ';
c0102093:	0f b7 15 bc 76 13 c0 	movzwl 0xc01376bc,%edx
c010209a:	8d 4a 01             	lea    0x1(%edx),%ecx
c010209d:	66 89 0d bc 76 13 c0 	mov    %cx,0xc01376bc
c01020a4:	66 8b 0d 04 50 13 c0 	mov    0xc0135004,%cx
c01020ab:	83 c9 20             	or     $0x20,%ecx
c01020ae:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
            crt.buf[crt.pos++] = attrib | ' ';
c01020b2:	0f b7 15 bc 76 13 c0 	movzwl 0xc01376bc,%edx
c01020b9:	8d 4a 01             	lea    0x1(%edx),%ecx
c01020bc:	66 89 0d bc 76 13 c0 	mov    %cx,0xc01376bc
c01020c3:	66 8b 0d 04 50 13 c0 	mov    0xc0135004,%cx
c01020ca:	83 c9 20             	or     $0x20,%ecx
c01020cd:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
            crt.buf[crt.pos++] = attrib | ' ';
c01020d1:	0f b7 15 bc 76 13 c0 	movzwl 0xc01376bc,%edx
c01020d8:	8d 4a 01             	lea    0x1(%edx),%ecx
c01020db:	66 89 0d bc 76 13 c0 	mov    %cx,0xc01376bc
c01020e2:	66 8b 0d 04 50 13 c0 	mov    0xc0135004,%cx
c01020e9:	83 c9 20             	or     $0x20,%ecx
c01020ec:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
            break;
c01020f0:	eb 2c                	jmp    c010211e <putc_cga+0x12e>
        default:
            if (c >= 0x20 && c <= 0x7E)
c01020f2:	8d 50 e0             	lea    -0x20(%eax),%edx
c01020f5:	80 fa 5e             	cmp    $0x5e,%dl
c01020f8:	77 24                	ja     c010211e <putc_cga+0x12e>
                crt.buf[crt.pos++] = attrib | c;
c01020fa:	0f b7 15 bc 76 13 c0 	movzwl 0xc01376bc,%edx
c0102101:	8d 4a 01             	lea    0x1(%edx),%ecx
c0102104:	66 89 0d bc 76 13 c0 	mov    %cx,0xc01376bc
c010210b:	66 98                	cbtw   
c010210d:	66 0b 05 04 50 13 c0 	or     0xc0135004,%ax
c0102114:	8b 0d b8 76 13 c0    	mov    0xc01376b8,%ecx
c010211a:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
            break;
    }

    if (crt.pos >= CRT_SIZE)
c010211e:	66 81 3d bc 76 13 c0 	cmpw   $0x7cf,0xc01376bc
c0102125:	cf 07 
c0102127:	76 05                	jbe    c010212e <putc_cga+0x13e>
        scroll();
c0102129:	e8 06 fe ff ff       	call   c0101f34 <scroll>

    update_cursor();
}
c010212e:	c9                   	leave  
    }

    if (crt.pos >= CRT_SIZE)
        scroll();

    update_cursor();
c010212f:	e9 4b fe ff ff       	jmp    c0101f7f <update_cursor>

c0102134 <settextcolor>:
}

/* Sets the forecolor and backcolor that we will use */
void settextcolor(uint16_t color) {
c0102134:	55                   	push   %ebp
c0102135:	89 e5                	mov    %esp,%ebp
    attrib = color;
c0102137:	8b 45 08             	mov    0x8(%ebp),%eax
c010213a:	66 a3 04 50 13 c0    	mov    %ax,0xc0135004
}
c0102140:	5d                   	pop    %ebp
c0102141:	c3                   	ret    

c0102142 <init_cga>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_cga(void) {
c0102142:	55                   	push   %ebp
c0102143:	89 e5                	mov    %esp,%ebp
c0102145:	53                   	push   %ebx
    crt.buf = (uint16_t*) (KADDR + CGA_BUF);
c0102146:	c7 05 b8 76 13 c0 00 	movl   $0xc00b8000,0xc01376b8
c010214d:	80 0b c0 
    addr_6845 = CGA_BASE;
c0102150:	c7 05 64 69 13 c0 d4 	movl   $0x3d4,0xc0136964
c0102157:	03 00 00 
c010215a:	ba d4 03 00 00       	mov    $0x3d4,%edx
c010215f:	b0 0e                	mov    $0xe,%al
c0102161:	ee                   	out    %al,(%dx)
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102162:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
c0102167:	89 ca                	mov    %ecx,%edx
c0102169:	ec                   	in     (%dx),%al
c010216a:	88 c3                	mov    %al,%bl
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010216c:	ba d4 03 00 00       	mov    $0x3d4,%edx
c0102171:	b0 0f                	mov    $0xf,%al
c0102173:	ee                   	out    %al,(%dx)
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102174:	89 ca                	mov    %ecx,%edx
c0102176:	ec                   	in     (%dx),%al

    // get current cursor location
    outb(addr_6845, 14);
    crt.pos = inb(addr_6845 + 1) << 8;
    outb(addr_6845, 15);
    crt.pos |= inb(addr_6845 + 1);
c0102177:	c1 e3 08             	shl    $0x8,%ebx
c010217a:	0f b6 c8             	movzbl %al,%ecx
c010217d:	89 d8                	mov    %ebx,%eax
c010217f:	09 c8                	or     %ecx,%eax
c0102181:	66 a3 bc 76 13 c0    	mov    %ax,0xc01376bc

    cls();
}
c0102187:	5b                   	pop    %ebx
c0102188:	5d                   	pop    %ebp
    outb(addr_6845, 14);
    crt.pos = inb(addr_6845 + 1) << 8;
    outb(addr_6845, 15);
    crt.pos |= inb(addr_6845 + 1);

    cls();
c0102189:	e9 1f fe ff ff       	jmp    c0101fad <cls>

c010218e <print_e820_mmap>:
    "acpi nvs",
    "unusable",
};

void
print_e820_mmap(void) {
c010218e:	55                   	push   %ebp
c010218f:	89 e5                	mov    %esp,%ebp
c0102191:	57                   	push   %edi
c0102192:	56                   	push   %esi
c0102193:	53                   	push   %ebx
c0102194:	83 ec 20             	sub    $0x20,%esp
    print("\tE820: memory map [mem 0x%08x-0x%08x]\n", mbi->mmap_addr,
          mbi->mmap_addr + mbi->mmap_length - 1);
c0102197:	a1 e0 76 13 c0       	mov    0xc01376e0,%eax
c010219c:	8b 50 30             	mov    0x30(%eax),%edx
    "unusable",
};

void
print_e820_mmap(void) {
    print("\tE820: memory map [mem 0x%08x-0x%08x]\n", mbi->mmap_addr,
c010219f:	8b 48 2c             	mov    0x2c(%eax),%ecx
c01021a2:	01 d1                	add    %edx,%ecx
c01021a4:	89 c8                	mov    %ecx,%eax
c01021a6:	48                   	dec    %eax
c01021a7:	50                   	push   %eax
c01021a8:	52                   	push   %edx
c01021a9:	68 82 b2 10 c0       	push   $0xc010b282
c01021ae:	e8 11 1c 00 00       	call   c0103dc4 <print>
c01021b3:	bb 00 77 13 c0       	mov    $0xc0137700,%ebx
          mbi->mmap_addr + mbi->mmap_length - 1);

    for (size_t i = 0; i < e820_map.size; ++i) {
c01021b8:	83 c4 10             	add    $0x10,%esp
c01021bb:	31 f6                	xor    %esi,%esi
c01021bd:	3b 35 00 7c 13 c0    	cmp    0xc0137c00,%esi
c01021c3:	0f 83 a6 00 00 00    	jae    c010226f <print_e820_mmap+0xe1>
        struct e820_e e820 = e820_map.entries[i];
c01021c9:	8b 53 10             	mov    0x10(%ebx),%edx
c01021cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        print("\t\t[ %08p - %08p ] ", (size_t) e820.addr,
c01021cf:	8b 0b                	mov    (%ebx),%ecx
c01021d1:	50                   	push   %eax
c01021d2:	8b 43 08             	mov    0x8(%ebx),%eax
c01021d5:	01 c8                	add    %ecx,%eax
c01021d7:	48                   	dec    %eax
c01021d8:	50                   	push   %eax
c01021d9:	51                   	push   %ecx
c01021da:	68 a9 b2 10 c0       	push   $0xc010b2a9
c01021df:	e8 e0 1b 00 00       	call   c0103dc4 <print>
              (size_t) (e820.addr + e820.len - 1));
        switch (e820.type) {
c01021e4:	83 c4 10             	add    $0x10,%esp
c01021e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01021ea:	8d 7a ff             	lea    -0x1(%edx),%edi
c01021ed:	83 ff 04             	cmp    $0x4,%edi
c01021f0:	77 2d                	ja     c010221f <print_e820_mmap+0x91>
c01021f2:	ff 24 bd 6c b3 10 c0 	jmp    *-0x3fef4c94(,%edi,4)
            case E820_AVAILABLE:
                settextcolor(VGA_GREEN);
c01021f9:	83 ec 0c             	sub    $0xc,%esp
c01021fc:	68 00 0a 00 00       	push   $0xa00
c0102201:	eb 08                	jmp    c010220b <print_e820_mmap+0x7d>
                break;
            case E820_RESERVED:
            case E820_ACPI_NVS:
            case E820_UNUSABLE:
                settextcolor(VGA_RED);
c0102203:	83 ec 0c             	sub    $0xc,%esp
c0102206:	68 00 0c 00 00       	push   $0xc00
c010220b:	e8 24 ff ff ff       	call   c0102134 <settextcolor>
                break;
c0102210:	83 c4 10             	add    $0x10,%esp
c0102213:	eb 27                	jmp    c010223c <print_e820_mmap+0xae>
            case E820_RECLAIMABLE:
                settextcolor(VGA_CYAN);
c0102215:	83 ec 0c             	sub    $0xc,%esp
c0102218:	68 00 0b 00 00       	push   $0xb00
c010221d:	eb ec                	jmp    c010220b <print_e820_mmap+0x7d>
                break;
            default:
                panic("unknown region type %u", e820.type);
c010221f:	83 ec 0c             	sub    $0xc,%esp
c0102222:	52                   	push   %edx
c0102223:	68 bc b2 10 c0       	push   $0xc010b2bc
c0102228:	68 8c b3 10 c0       	push   $0xc010b38c
c010222d:	6a 27                	push   $0x27
c010222f:	68 d3 b2 10 c0       	push   $0xc010b2d3
c0102234:	e8 09 17 00 00       	call   c0103942 <_panic>
                break;
c0102239:	83 c4 20             	add    $0x20,%esp
        }
        print(e820_map_types[e820.type - 1]);
c010223c:	83 ec 0c             	sub    $0xc,%esp
c010223f:	ff 34 bd 9c b3 10 c0 	pushl  -0x3fef4c64(,%edi,4)
c0102246:	e8 79 1b 00 00       	call   c0103dc4 <print>
        settextcolor(VGA_NORMAL);
c010224b:	c7 04 24 00 0f 00 00 	movl   $0xf00,(%esp)
c0102252:	e8 dd fe ff ff       	call   c0102134 <settextcolor>
        print("\n");
c0102257:	c7 04 24 c9 ae 10 c0 	movl   $0xc010aec9,(%esp)
c010225e:	e8 61 1b 00 00       	call   c0103dc4 <print>
void
print_e820_mmap(void) {
    print("\tE820: memory map [mem 0x%08x-0x%08x]\n", mbi->mmap_addr,
          mbi->mmap_addr + mbi->mmap_length - 1);

    for (size_t i = 0; i < e820_map.size; ++i) {
c0102263:	46                   	inc    %esi
c0102264:	83 c3 14             	add    $0x14,%ebx
c0102267:	83 c4 10             	add    $0x10,%esp
c010226a:	e9 4e ff ff ff       	jmp    c01021bd <print_e820_mmap+0x2f>
        print(e820_map_types[e820.type - 1]);
        settextcolor(VGA_NORMAL);
        print("\n");

    }
}
c010226f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102272:	5b                   	pop    %ebx
c0102273:	5e                   	pop    %esi
c0102274:	5f                   	pop    %edi
c0102275:	5d                   	pop    %ebp
c0102276:	c3                   	ret    

c0102277 <init_e820>:

void
init_e820(size_t mbi_addr) {
c0102277:	55                   	push   %ebp
c0102278:	89 e5                	mov    %esp,%ebp
c010227a:	57                   	push   %edi
c010227b:	56                   	push   %esi
c010227c:	53                   	push   %ebx
c010227d:	83 ec 1c             	sub    $0x1c,%esp
c0102280:	8b 45 08             	mov    0x8(%ebp),%eax
    mbi = (struct multiboot_info*) mbi_addr;
c0102283:	a3 e0 76 13 c0       	mov    %eax,0xc01376e0
    assert(mbi->flags & MB_MEM_MAP);
c0102288:	f6 00 40             	testb  $0x40,(%eax)
c010228b:	75 28                	jne    c01022b5 <init_e820+0x3e>
c010228d:	83 ec 0c             	sub    $0xc,%esp
c0102290:	68 80 b3 10 c0       	push   $0xc010b380
c0102295:	6a 34                	push   $0x34
c0102297:	68 d3 b2 10 c0       	push   $0xc010b2d3
c010229c:	68 dd b2 10 c0       	push   $0xc010b2dd
c01022a1:	68 95 a9 10 c0       	push   $0xc010a995
c01022a6:	e8 19 1b 00 00       	call   c0103dc4 <print>
c01022ab:	83 c4 20             	add    $0x20,%esp
c01022ae:	e8 97 eb ff ff       	call   c0100e4a <backtrace>
c01022b3:	fa                   	cli    
c01022b4:	f4                   	hlt    

    size_t mmap_addr = mbi->mmap_addr;
c01022b5:	a1 e0 76 13 c0       	mov    0xc01376e0,%eax
c01022ba:	8b 58 30             	mov    0x30(%eax),%ebx
    size_t mmap_end = mbi->mmap_addr + mbi->mmap_length;
c01022bd:	8b 40 2c             	mov    0x2c(%eax),%eax
c01022c0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
c01022c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    assert(mmap_end - mmap_addr >= sizeof(struct multiboot_mmap_entry));
c01022c6:	83 f8 17             	cmp    $0x17,%eax
c01022c9:	77 28                	ja     c01022f3 <init_e820+0x7c>
c01022cb:	83 ec 0c             	sub    $0xc,%esp
c01022ce:	68 80 b3 10 c0       	push   $0xc010b380
c01022d3:	6a 38                	push   $0x38
c01022d5:	68 d3 b2 10 c0       	push   $0xc010b2d3
c01022da:	68 f5 b2 10 c0       	push   $0xc010b2f5
c01022df:	68 95 a9 10 c0       	push   $0xc010a995
c01022e4:	e8 db 1a 00 00       	call   c0103dc4 <print>
c01022e9:	83 c4 20             	add    $0x20,%esp
c01022ec:	e8 59 eb ff ff       	call   c0100e4a <backtrace>
c01022f1:	fa                   	cli    
c01022f2:	f4                   	hlt    

    }
}

void
init_e820(size_t mbi_addr) {
c01022f3:	31 c0                	xor    %eax,%eax
    size_t mmap_addr = mbi->mmap_addr;
    size_t mmap_end = mbi->mmap_addr + mbi->mmap_length;
    assert(mmap_end - mmap_addr >= sizeof(struct multiboot_mmap_entry));

    size_t i;
    for (i = 0; mmap_addr < mmap_end; ++i) {
c01022f5:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
c01022f8:	73 1c                	jae    c0102316 <init_e820+0x9f>
        struct multiboot_mmap_entry* e = (struct multiboot_mmap_entry*) mmap_addr;
        e820_map.entries[i] = e->e820;
c01022fa:	6b f8 14             	imul   $0x14,%eax,%edi
c01022fd:	81 c7 00 77 13 c0    	add    $0xc0137700,%edi
c0102303:	8d 73 04             	lea    0x4(%ebx),%esi
c0102306:	b9 05 00 00 00       	mov    $0x5,%ecx
c010230b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        mmap_addr += e->size + 4;
c010230d:	8b 13                	mov    (%ebx),%edx
c010230f:	8d 5c 13 04          	lea    0x4(%ebx,%edx,1),%ebx
    size_t mmap_addr = mbi->mmap_addr;
    size_t mmap_end = mbi->mmap_addr + mbi->mmap_length;
    assert(mmap_end - mmap_addr >= sizeof(struct multiboot_mmap_entry));

    size_t i;
    for (i = 0; mmap_addr < mmap_end; ++i) {
c0102313:	40                   	inc    %eax
c0102314:	eb df                	jmp    c01022f5 <init_e820+0x7e>
        struct multiboot_mmap_entry* e = (struct multiboot_mmap_entry*) mmap_addr;
        e820_map.entries[i] = e->e820;
        mmap_addr += e->size + 4;
    }
    assert(i < E820_MAX_SIZE);
c0102316:	83 f8 40             	cmp    $0x40,%eax
c0102319:	75 2e                	jne    c0102349 <init_e820+0xd2>
c010231b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010231e:	83 ec 0c             	sub    $0xc,%esp
c0102321:	68 80 b3 10 c0       	push   $0xc010b380
c0102326:	6a 40                	push   $0x40
c0102328:	68 d3 b2 10 c0       	push   $0xc010b2d3
c010232d:	68 31 b3 10 c0       	push   $0xc010b331
c0102332:	68 95 a9 10 c0       	push   $0xc010a995
c0102337:	e8 88 1a 00 00       	call   c0103dc4 <print>
c010233c:	83 c4 20             	add    $0x20,%esp
c010233f:	e8 06 eb ff ff       	call   c0100e4a <backtrace>
c0102344:	fa                   	cli    
c0102345:	f4                   	hlt    
c0102346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    e820_map.size = i;
c0102349:	a3 00 7c 13 c0       	mov    %eax,0xc0137c00
}
c010234e:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102351:	5b                   	pop    %ebx
c0102352:	5e                   	pop    %esi
c0102353:	5f                   	pop    %edi
c0102354:	5d                   	pop    %ebp
c0102355:	c3                   	ret    

c0102356 <ioapic_init>:
    *(ioapic + IOREGSEL) = reg;
    *(ioapic + IOWIN) = data;
}

void
ioapic_init(void) {
c0102356:	55                   	push   %ebp
c0102357:	89 e5                	mov    %esp,%ebp
c0102359:	56                   	push   %esi
c010235a:	53                   	push   %ebx
    // Default physical address.
    assert(ioapic_addr == 0xfec00000);
c010235b:	81 3d 04 7c 13 c0 00 	cmpl   $0xfec00000,0xc0137c04
c0102362:	00 c0 fe 
c0102365:	74 28                	je     c010238f <ioapic_init+0x39>
c0102367:	83 ec 0c             	sub    $0xc,%esp
c010236a:	68 08 b4 10 c0       	push   $0xc010b408
c010236f:	6a 28                	push   $0x28
c0102371:	68 b0 b3 10 c0       	push   $0xc010b3b0
c0102376:	68 bc b3 10 c0       	push   $0xc010b3bc
c010237b:	68 95 a9 10 c0       	push   $0xc010a995
c0102380:	e8 3f 1a 00 00       	call   c0103dc4 <print>
c0102385:	83 c4 20             	add    $0x20,%esp
c0102388:	e8 bd ea ff ff       	call   c0100e4a <backtrace>
c010238d:	fa                   	cli    
c010238e:	f4                   	hlt    

    // IOAPIC is the default physical address.  Map it in to
    // virtual memory so we can access it.
    ioapic = mmio_map(ioapic_addr, 4096);
c010238f:	50                   	push   %eax
c0102390:	50                   	push   %eax
c0102391:	68 00 10 00 00       	push   $0x1000
c0102396:	ff 35 04 7c 13 c0    	pushl  0xc0137c04
c010239c:	e8 e9 f0 ff ff       	call   c010148a <mmio_map>
c01023a1:	a3 68 69 13 c0       	mov    %eax,0xc0136968
size_t ioapic_addr;         // Initialized in mpconfig.c
static volatile uint32_t* ioapic;

static uint32_t
ioapic_read(int reg) {
    *(ioapic + IOREGSEL) = reg;
c01023a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    return *(ioapic + IOWIN);
c01023ac:	8b 40 10             	mov    0x10(%eax),%eax
    // virtual memory so we can access it.
    ioapic = mmio_map(ioapic_addr, 4096);

    int reg_ver = ioapic_read(IOAPICVER);
    int ver = reg_ver & 0xff;
    int pins = ((reg_ver >> 16) & 0xff) + 1;
c01023af:	89 c3                	mov    %eax,%ebx
c01023b1:	c1 fb 10             	sar    $0x10,%ebx
c01023b4:	0f b6 db             	movzbl %bl,%ebx
    print("SMP: IOAPIC %08p v%02x [global_irq %02d-%02d]\n",
c01023b7:	89 1c 24             	mov    %ebx,(%esp)
c01023ba:	6a 00                	push   $0x0
c01023bc:	0f b6 c0             	movzbl %al,%eax
c01023bf:	50                   	push   %eax
c01023c0:	ff 35 04 7c 13 c0    	pushl  0xc0137c04
c01023c6:	68 d6 b3 10 c0       	push   $0xc010b3d6
c01023cb:	e8 f4 19 00 00       	call   c0103dc4 <print>
    return *(ioapic + IOWIN);
}

static void
ioapic_write(int reg, uint32_t data) {
    *(ioapic + IOREGSEL) = reg;
c01023d0:	8b 0d 68 69 13 c0    	mov    0xc0136968,%ecx
c01023d6:	83 c4 20             	add    $0x20,%esp
c01023d9:	ba 10 00 00 00       	mov    $0x10,%edx
    print("SMP: IOAPIC %08p v%02x [global_irq %02d-%02d]\n",
          ioapic_addr, ver, 0, pins - 1);

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (int i = 0; i < pins; ++i) {
c01023de:	31 c0                	xor    %eax,%eax
        ioapic_write(IOREDTBL + 2 * i, INT_DISABLED | (IRQ_OFFSET + i));
c01023e0:	8d 70 20             	lea    0x20(%eax),%esi
c01023e3:	81 ce 00 00 01 00    	or     $0x10000,%esi
    return *(ioapic + IOWIN);
}

static void
ioapic_write(int reg, uint32_t data) {
    *(ioapic + IOREGSEL) = reg;
c01023e9:	89 11                	mov    %edx,(%ecx)
    *(ioapic + IOWIN) = data;
c01023eb:	89 71 10             	mov    %esi,0x10(%ecx)
c01023ee:	8d 72 01             	lea    0x1(%edx),%esi
    return *(ioapic + IOWIN);
}

static void
ioapic_write(int reg, uint32_t data) {
    *(ioapic + IOREGSEL) = reg;
c01023f1:	89 31                	mov    %esi,(%ecx)
    *(ioapic + IOWIN) = data;
c01023f3:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
    print("SMP: IOAPIC %08p v%02x [global_irq %02d-%02d]\n",
          ioapic_addr, ver, 0, pins - 1);

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (int i = 0; i < pins; ++i) {
c01023fa:	40                   	inc    %eax
c01023fb:	83 c2 02             	add    $0x2,%edx
c01023fe:	39 c3                	cmp    %eax,%ebx
c0102400:	7d de                	jge    c01023e0 <ioapic_init+0x8a>
        ioapic_write(IOREDTBL + 2 * i, INT_DISABLED | (IRQ_OFFSET + i));
        ioapic_write(IOREDTBL + 2 * i + 1, 0);
    }
}
c0102402:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0102405:	5b                   	pop    %ebx
c0102406:	5e                   	pop    %esi
c0102407:	5d                   	pop    %ebp
c0102408:	c3                   	ret    

c0102409 <ioapic_enable>:

void
ioapic_enable(int irq, int apicid) {
c0102409:	55                   	push   %ebp
c010240a:	89 e5                	mov    %esp,%ebp
c010240c:	8b 45 08             	mov    0x8(%ebp),%eax
    // Mark interrupt edge-triggered, active high, enabled,
    // and routed to the given cpu's APIC ID.
    ioapic_write(IOREDTBL + 2 * irq, IRQ_OFFSET + irq);
c010240f:	8d 48 20             	lea    0x20(%eax),%ecx
c0102412:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
    return *(ioapic + IOWIN);
}

static void
ioapic_write(int reg, uint32_t data) {
    *(ioapic + IOREGSEL) = reg;
c0102416:	a1 68 69 13 c0       	mov    0xc0136968,%eax
c010241b:	89 10                	mov    %edx,(%eax)
    *(ioapic + IOWIN) = data;
c010241d:	89 48 10             	mov    %ecx,0x10(%eax)
void
ioapic_enable(int irq, int apicid) {
    // Mark interrupt edge-triggered, active high, enabled,
    // and routed to the given cpu's APIC ID.
    ioapic_write(IOREDTBL + 2 * irq, IRQ_OFFSET + irq);
    ioapic_write(IOREDTBL + 2 * irq + 1, apicid << 24);
c0102420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0102423:	c1 e1 18             	shl    $0x18,%ecx
    return *(ioapic + IOWIN);
}

static void
ioapic_write(int reg, uint32_t data) {
    *(ioapic + IOREGSEL) = reg;
c0102426:	42                   	inc    %edx
c0102427:	89 10                	mov    %edx,(%eax)
    *(ioapic + IOWIN) = data;
c0102429:	89 48 10             	mov    %ecx,0x10(%eax)
ioapic_enable(int irq, int apicid) {
    // Mark interrupt edge-triggered, active high, enabled,
    // and routed to the given cpu's APIC ID.
    ioapic_write(IOREDTBL + 2 * irq, IRQ_OFFSET + irq);
    ioapic_write(IOREDTBL + 2 * irq + 1, apicid << 24);
}
c010242c:	5d                   	pop    %ebp
c010242d:	c3                   	ret    

c010242e <irq_handler_kdb>:
    ctlmap
};

/* Handles the keyboard interrupt */
void
irq_handler_kdb(struct regs* r) {
c010242e:	55                   	push   %ebp
c010242f:	89 e5                	mov    %esp,%ebp
c0102431:	56                   	push   %esi
c0102432:	53                   	push   %ebx
c0102433:	ba 60 00 00 00       	mov    $0x60,%edx
c0102438:	ec                   	in     (%dx),%al
c0102439:	89 c6                	mov    %eax,%esi
c010243b:	88 c3                	mov    %al,%bl

    static uint32_t shift;

    uint8_t data = inb(KBDIO);

    if (data == 0xE0) {
c010243d:	3c e0                	cmp    $0xe0,%al
c010243f:	75 0c                	jne    c010244d <irq_handler_kdb+0x1f>
        shift |= ESC;
c0102441:	83 0d 6c 69 13 c0 40 	orl    $0x40,0xc013696c
        return;
c0102448:	e9 c7 00 00 00       	jmp    c0102514 <irq_handler_kdb+0xe6>
    } else if (data & 0x80) {                           // Key-up
c010244d:	84 c0                	test   %al,%al
c010244f:	8b 0d 6c 69 13 c0    	mov    0xc013696c,%ecx
c0102455:	79 38                	jns    c010248f <irq_handler_kdb+0x61>
        // Reboot = Shift + Ctrl + Fn + Del
        if (shift == 0x46 && data == 0xD3)
c0102457:	83 f9 46             	cmp    $0x46,%ecx
c010245a:	75 0c                	jne    c0102468 <irq_handler_kdb+0x3a>
c010245c:	3c d3                	cmp    $0xd3,%al
c010245e:	75 08                	jne    c0102468 <irq_handler_kdb+0x3a>
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102460:	ba 64 00 00 00       	mov    $0x64,%edx
c0102465:	b0 fe                	mov    $0xfe,%al
c0102467:	ee                   	out    %al,(%dx)
            outb(0x64, 0xFE);
        data = (shift & ESC ? data : data & 0x7F);
c0102468:	f6 c1 40             	test   $0x40,%cl
c010246b:	75 05                	jne    c0102472 <irq_handler_kdb+0x44>
c010246d:	89 f3                	mov    %esi,%ebx
c010246f:	83 e3 7f             	and    $0x7f,%ebx
        shift &= ~(shiftcode[data] | ESC);
c0102472:	0f b6 db             	movzbl %bl,%ebx
c0102475:	8a 83 40 b5 10 c0    	mov    -0x3fef4ac0(%ebx),%al
c010247b:	83 c8 40             	or     $0x40,%eax
c010247e:	0f b6 c0             	movzbl %al,%eax
c0102481:	f7 d0                	not    %eax
c0102483:	21 c8                	and    %ecx,%eax
c0102485:	a3 6c 69 13 c0       	mov    %eax,0xc013696c
        return;
c010248a:	e9 85 00 00 00       	jmp    c0102514 <irq_handler_kdb+0xe6>
    } else if (shift & ESC) {
c010248f:	f6 c1 40             	test   $0x40,%cl
c0102492:	74 0d                	je     c01024a1 <irq_handler_kdb+0x73>
        data |= 0x80;
c0102494:	83 cb 80             	or     $0xffffff80,%ebx
        shift &= ~ESC;
c0102497:	89 c8                	mov    %ecx,%eax
c0102499:	83 e0 bf             	and    $0xffffffbf,%eax
c010249c:	a3 6c 69 13 c0       	mov    %eax,0xc013696c
    }


    shift |= shiftcode[data];
c01024a1:	0f b6 db             	movzbl %bl,%ebx
    shift ^= togglecode[data];
c01024a4:	0f b6 93 40 b5 10 c0 	movzbl -0x3fef4ac0(%ebx),%edx
c01024ab:	0b 15 6c 69 13 c0    	or     0xc013696c,%edx
c01024b1:	0f b6 83 40 b4 10 c0 	movzbl -0x3fef4bc0(%ebx),%eax
c01024b8:	31 c2                	xor    %eax,%edx
c01024ba:	89 15 6c 69 13 c0    	mov    %edx,0xc013696c

    int c = charcode[shift & (CTL | SHIFT)][data];
c01024c0:	89 d0                	mov    %edx,%eax
c01024c2:	83 e0 03             	and    $0x3,%eax
c01024c5:	8b 04 85 20 b4 10 c0 	mov    -0x3fef4be0(,%eax,4),%eax
c01024cc:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
    if (shift & CAPSLOCK) {
c01024d0:	80 e2 08             	and    $0x8,%dl
c01024d3:	74 18                	je     c01024ed <irq_handler_kdb+0xbf>
        if ('a' <= c && c <= 'z')
c01024d5:	8d 50 9f             	lea    -0x61(%eax),%edx
c01024d8:	83 fa 19             	cmp    $0x19,%edx
c01024db:	77 05                	ja     c01024e2 <irq_handler_kdb+0xb4>
            c += 'A' - 'a';
c01024dd:	83 e8 20             	sub    $0x20,%eax
c01024e0:	eb 0b                	jmp    c01024ed <irq_handler_kdb+0xbf>
        else if ('A' <= c && c <= 'Z')
c01024e2:	8d 50 bf             	lea    -0x41(%eax),%edx
c01024e5:	83 fa 19             	cmp    $0x19,%edx
c01024e8:	77 03                	ja     c01024ed <irq_handler_kdb+0xbf>
            c += 'a' - 'A';
c01024ea:	83 c0 20             	add    $0x20,%eax
    }

    extern struct console console;
    console.buf[console.wpos++] = c;
c01024ed:	8b 0d b4 76 13 c0    	mov    0xc01376b4,%ecx
c01024f3:	8d 51 01             	lea    0x1(%ecx),%edx
c01024f6:	89 15 b4 76 13 c0    	mov    %edx,0xc01376b4
c01024fc:	88 81 e0 6e 13 c0    	mov    %al,-0x3fec9120(%ecx)
    if (console.wpos == CONSBUFSIZE)
c0102502:	81 fa d0 07 00 00    	cmp    $0x7d0,%edx
c0102508:	75 0a                	jne    c0102514 <irq_handler_kdb+0xe6>
        console.wpos = 0;
c010250a:	c7 05 b4 76 13 c0 00 	movl   $0x0,0xc01376b4
c0102511:	00 00 00 
}
c0102514:	5b                   	pop    %ebx
c0102515:	5e                   	pop    %esi
c0102516:	5d                   	pop    %ebp
c0102517:	c3                   	ret    

c0102518 <init_kbd>:

void
init_kbd(void) {
c0102518:	55                   	push   %ebp
c0102519:	89 e5                	mov    %esp,%ebp
c010251b:	83 ec 10             	sub    $0x10,%esp
    irq_install_handler(IRQ_KBD, irq_handler_kdb);
c010251e:	68 2e 24 10 c0       	push   $0xc010242e
c0102523:	6a 01                	push   $0x1
c0102525:	e8 22 e1 ff ff       	call   c010064c <irq_install_handler>
}
c010252a:	83 c4 10             	add    $0x10,%esp
c010252d:	c9                   	leave  
c010252e:	c3                   	ret    

c010252f <lapic_write>:
lapic_read(uint32_t index) {
    return lapic[index];
}

static void
lapic_write(uint32_t index, uint32_t value) {
c010252f:	55                   	push   %ebp
c0102530:	89 e5                	mov    %esp,%ebp
    lapic[index] = value;
c0102532:	8b 0d 70 69 13 c0    	mov    0xc0136970,%ecx
c0102538:	8d 04 81             	lea    (%ecx,%eax,4),%eax
c010253b:	89 10                	mov    %edx,(%eax)
    lapic[ID];  // wait for write to finish, by reading
c010253d:	8b 41 20             	mov    0x20(%ecx),%eax
}
c0102540:	5d                   	pop    %ebp
c0102541:	c3                   	ret    

c0102542 <cpunum>:

int
cpunum(void) {
    int apicid, i;

    if (!lapic)
c0102542:	8b 15 70 69 13 c0    	mov    0xc0136970,%edx
        return 0;
c0102548:	31 c0                	xor    %eax,%eax

int
cpunum(void) {
    int apicid, i;

    if (!lapic)
c010254a:	85 d2                	test   %edx,%edx
c010254c:	74 59                	je     c01025a7 <cpunum+0x65>
    // Enable interrupts on the APIC (but not on the processor).
    lapic_write(TPR, 0);
}

int
cpunum(void) {
c010254e:	55                   	push   %ebp
c010254f:	89 e5                	mov    %esp,%ebp
c0102551:	53                   	push   %ebx
c0102552:	51                   	push   %ecx
size_t lapic_addr;       // Initialized in mpconfig.c
static volatile uint32_t* lapic;

static uint32_t
lapic_read(uint32_t index) {
    return lapic[index];
c0102553:	8b 5a 20             	mov    0x20(%edx),%ebx
cpunum(void) {
    int apicid, i;

    if (!lapic)
        return 0;
    apicid = lapic_read(ID) >> 24;
c0102556:	c1 eb 18             	shr    $0x18,%ebx
    for (i = 0; i < ncpu; ++i) {
c0102559:	0f b6 15 c0 6e 13 c0 	movzbl 0xc0136ec0,%edx
c0102560:	39 d0                	cmp    %edx,%eax
c0102562:	7d 12                	jge    c0102576 <cpunum+0x34>
        if (cpus[i]->apicid == apicid)
c0102564:	8b 0c 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%ecx
c010256b:	0f b6 49 04          	movzbl 0x4(%ecx),%ecx
c010256f:	39 cb                	cmp    %ecx,%ebx
c0102571:	74 30                	je     c01025a3 <cpunum+0x61>
    int apicid, i;

    if (!lapic)
        return 0;
    apicid = lapic_read(ID) >> 24;
    for (i = 0; i < ncpu; ++i) {
c0102573:	40                   	inc    %eax
c0102574:	eb ea                	jmp    c0102560 <cpunum+0x1e>
        if (cpus[i]->apicid == apicid)
            return i;
    }
    panic("could not find cpu apicid: %d  thiscpu: %d\n", apicid, thiscpu);
c0102576:	e8 c7 ff ff ff       	call   c0102542 <cpunum>
c010257b:	52                   	push   %edx
c010257c:	52                   	push   %edx
c010257d:	ff 34 85 a0 6e 13 c0 	pushl  -0x3fec9160(,%eax,4)
c0102584:	53                   	push   %ebx
c0102585:	68 40 b6 10 c0       	push   $0xc010b640
c010258a:	68 a4 b6 10 c0       	push   $0xc010b6a4
c010258f:	68 83 00 00 00       	push   $0x83
c0102594:	68 6c b6 10 c0       	push   $0xc010b66c
c0102599:	e8 a4 13 00 00       	call   c0103942 <_panic>

    return 0;
c010259e:	83 c4 20             	add    $0x20,%esp
c01025a1:	31 c0                	xor    %eax,%eax
}
c01025a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01025a6:	c9                   	leave  
c01025a7:	c3                   	ret    

c01025a8 <init_lapic>:
    lapic[index] = value;
    lapic[ID];  // wait for write to finish, by reading
}

void
init_lapic(void) {
c01025a8:	55                   	push   %ebp
c01025a9:	89 e5                	mov    %esp,%ebp
c01025ab:	53                   	push   %ebx
c01025ac:	53                   	push   %ebx
    assert(lapic_addr);
c01025ad:	83 3d 08 7c 13 c0 00 	cmpl   $0x0,0xc0137c08
c01025b4:	75 28                	jne    c01025de <init_lapic+0x36>
c01025b6:	83 ec 0c             	sub    $0xc,%esp
c01025b9:	68 ac b6 10 c0       	push   $0xc010b6ac
c01025be:	6a 3e                	push   $0x3e
c01025c0:	68 6c b6 10 c0       	push   $0xc010b66c
c01025c5:	68 77 b6 10 c0       	push   $0xc010b677
c01025ca:	68 95 a9 10 c0       	push   $0xc010a995
c01025cf:	e8 f0 17 00 00       	call   c0103dc4 <print>
c01025d4:	83 c4 20             	add    $0x20,%esp
c01025d7:	e8 6e e8 ff ff       	call   c0100e4a <backtrace>
c01025dc:	fa                   	cli    
c01025dd:	f4                   	hlt    

    // lapic_addr is the physical address of the LAPIC's 4K MMIO
    // region.  Map it in to virtual memory so we can access it.
    lapic = mmio_map(lapic_addr, 4096);
c01025de:	51                   	push   %ecx
c01025df:	51                   	push   %ecx
c01025e0:	68 00 10 00 00       	push   $0x1000
c01025e5:	ff 35 08 7c 13 c0    	pushl  0xc0137c08
c01025eb:	e8 9a ee ff ff       	call   c010148a <mmio_map>
c01025f0:	a3 70 69 13 c0       	mov    %eax,0xc0136970

    if (thiscpu == bootcpu)
c01025f5:	e8 48 ff ff ff       	call   c0102542 <cpunum>
c01025fa:	83 c4 10             	add    $0x10,%esp
c01025fd:	8b 0d a0 6e 13 c0    	mov    0xc0136ea0,%ecx
c0102603:	39 0c 85 a0 6e 13 c0 	cmp    %ecx,-0x3fec9160(,%eax,4)
c010260a:	75 20                	jne    c010262c <init_lapic+0x84>
size_t lapic_addr;       // Initialized in mpconfig.c
static volatile uint32_t* lapic;

static uint32_t
lapic_read(uint32_t index) {
    return lapic[index];
c010260c:	a1 70 69 13 c0       	mov    0xc0136970,%eax
c0102611:	8b 40 30             	mov    0x30(%eax),%eax
    // lapic_addr is the physical address of the LAPIC's 4K MMIO
    // region.  Map it in to virtual memory so we can access it.
    lapic = mmio_map(lapic_addr, 4096);

    if (thiscpu == bootcpu)
        print("SMP: LAPIC %08p v%02x\n", lapic_addr, lapic_read(VER) & 0xFF);
c0102614:	52                   	push   %edx
c0102615:	0f b6 c0             	movzbl %al,%eax
c0102618:	50                   	push   %eax
c0102619:	ff 35 08 7c 13 c0    	pushl  0xc0137c08
c010261f:	68 82 b6 10 c0       	push   $0xc010b682
c0102624:	e8 9b 17 00 00       	call   c0103dc4 <print>
c0102629:	83 c4 10             	add    $0x10,%esp

    // Enable local APIC; set spurious interrupt vector.
    lapic_write(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPUR));
c010262c:	ba 27 01 00 00       	mov    $0x127,%edx
c0102631:	b8 3c 00 00 00       	mov    $0x3c,%eax
c0102636:	e8 f4 fe ff ff       	call   c010252f <lapic_write>

    // The timer repeatedly counts down at bus frequency
    // from lapic[TICR] and then issues an interrupt.
    // If we cared more about precise timekeeping,
    // TICR would be calibrated using an external time source.
    lapic_write(TDCR, X1);
c010263b:	ba 0b 00 00 00       	mov    $0xb,%edx
c0102640:	b8 f8 00 00 00       	mov    $0xf8,%eax
c0102645:	e8 e5 fe ff ff       	call   c010252f <lapic_write>
    lapic_write(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
c010264a:	ba 20 00 02 00       	mov    $0x20020,%edx
c010264f:	b8 c8 00 00 00       	mov    $0xc8,%eax
c0102654:	e8 d6 fe ff ff       	call   c010252f <lapic_write>
    lapic_write(TICR, 10000000);
c0102659:	ba 80 96 98 00       	mov    $0x989680,%edx
c010265e:	b8 e0 00 00 00       	mov    $0xe0,%eax
c0102663:	e8 c7 fe ff ff       	call   c010252f <lapic_write>
    //
    // According to Intel MP Specification, the BIOS should initialize
    // BSP's local APIC in Virtual Wire Mode, in which 8259A's
    // INTR is virtually connected to BSP's LINTIN0. In this mode,
    // we do not need to program the IOAPIC.
    if (thiscpu != bootcpu)
c0102668:	e8 d5 fe ff ff       	call   c0102542 <cpunum>
c010266d:	8b 0d a0 6e 13 c0    	mov    0xc0136ea0,%ecx
c0102673:	39 0c 85 a0 6e 13 c0 	cmp    %ecx,-0x3fec9160(,%eax,4)
c010267a:	74 0f                	je     c010268b <init_lapic+0xe3>
        lapic_write(LINT0, MASKED);
c010267c:	ba 00 00 01 00       	mov    $0x10000,%edx
c0102681:	b8 d4 00 00 00       	mov    $0xd4,%eax
c0102686:	e8 a4 fe ff ff       	call   c010252f <lapic_write>

    // Disable NMI (LINT1) on all CPUs
    lapic_write(LINT1, MASKED);
c010268b:	ba 00 00 01 00       	mov    $0x10000,%edx
c0102690:	b8 d8 00 00 00       	mov    $0xd8,%eax
c0102695:	e8 95 fe ff ff       	call   c010252f <lapic_write>
size_t lapic_addr;       // Initialized in mpconfig.c
static volatile uint32_t* lapic;

static uint32_t
lapic_read(uint32_t index) {
    return lapic[index];
c010269a:	8b 1d 70 69 13 c0    	mov    0xc0136970,%ebx
c01026a0:	8b 43 30             	mov    0x30(%ebx),%eax
    // Disable NMI (LINT1) on all CPUs
    lapic_write(LINT1, MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic_read(VER) >> 16) & 0xFF) >= 4)
c01026a3:	c1 e8 10             	shr    $0x10,%eax
c01026a6:	3c 03                	cmp    $0x3,%al
c01026a8:	76 0f                	jbe    c01026b9 <init_lapic+0x111>
        lapic_write(PCINT, MASKED);
c01026aa:	ba 00 00 01 00       	mov    $0x10000,%edx
c01026af:	b8 d0 00 00 00       	mov    $0xd0,%eax
c01026b4:	e8 76 fe ff ff       	call   c010252f <lapic_write>

    // Map error interrupt to IRQ_ERROR.
    lapic_write(ERROR, IRQ_OFFSET + IRQ_ERROR);
c01026b9:	ba 51 00 00 00       	mov    $0x51,%edx
c01026be:	b8 dc 00 00 00       	mov    $0xdc,%eax
c01026c3:	e8 67 fe ff ff       	call   c010252f <lapic_write>

    // Clear error status register (requires back-to-back writes).
    lapic_write(ESR, 0);
c01026c8:	31 d2                	xor    %edx,%edx
c01026ca:	b8 a0 00 00 00       	mov    $0xa0,%eax
c01026cf:	e8 5b fe ff ff       	call   c010252f <lapic_write>
    lapic_write(ESR, 0);
c01026d4:	31 d2                	xor    %edx,%edx
c01026d6:	b8 a0 00 00 00       	mov    $0xa0,%eax
c01026db:	e8 4f fe ff ff       	call   c010252f <lapic_write>

    // Ack any outstanding interrupts.
    lapic_write(EOI, 0);
c01026e0:	31 d2                	xor    %edx,%edx
c01026e2:	b8 2c 00 00 00       	mov    $0x2c,%eax
c01026e7:	e8 43 fe ff ff       	call   c010252f <lapic_write>

    // Send an Init Level De-Assert to synchronize arbitration ID's.
    lapic_write(ICRHI, 0);
c01026ec:	31 d2                	xor    %edx,%edx
c01026ee:	b8 c4 00 00 00       	mov    $0xc4,%eax
c01026f3:	e8 37 fe ff ff       	call   c010252f <lapic_write>
    lapic_write(ICRLO, BCAST | INIT | LEVEL);
c01026f8:	ba 00 85 08 00       	mov    $0x88500,%edx
c01026fd:	b8 c0 00 00 00       	mov    $0xc0,%eax
c0102702:	e8 28 fe ff ff       	call   c010252f <lapic_write>
size_t lapic_addr;       // Initialized in mpconfig.c
static volatile uint32_t* lapic;

static uint32_t
lapic_read(uint32_t index) {
    return lapic[index];
c0102707:	8b 83 00 03 00 00    	mov    0x300(%ebx),%eax
    lapic_write(EOI, 0);

    // Send an Init Level De-Assert to synchronize arbitration ID's.
    lapic_write(ICRHI, 0);
    lapic_write(ICRLO, BCAST | INIT | LEVEL);
    while(lapic_read(ICRLO) & DELIVS)
c010270d:	f6 c4 10             	test   $0x10,%ah
c0102710:	75 f5                	jne    c0102707 <init_lapic+0x15f>
        ;

    // Enable interrupts on the APIC (but not on the processor).
    lapic_write(TPR, 0);
c0102712:	31 d2                	xor    %edx,%edx
c0102714:	b8 20 00 00 00       	mov    $0x20,%eax
}
c0102719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010271c:	c9                   	leave  
    lapic_write(ICRLO, BCAST | INIT | LEVEL);
    while(lapic_read(ICRLO) & DELIVS)
        ;

    // Enable interrupts on the APIC (but not on the processor).
    lapic_write(TPR, 0);
c010271d:	e9 0d fe ff ff       	jmp    c010252f <lapic_write>

c0102722 <lapic_eoi>:
    return 0;
}

// Acknowledge interrupt.
void
lapic_eoi(void) {
c0102722:	55                   	push   %ebp
c0102723:	89 e5                	mov    %esp,%ebp
    if (lapic)
c0102725:	83 3d 70 69 13 c0 00 	cmpl   $0x0,0xc0136970
c010272c:	74 0d                	je     c010273b <lapic_eoi+0x19>
        lapic_write(EOI, 0);
c010272e:	31 d2                	xor    %edx,%edx
c0102730:	b8 2c 00 00 00       	mov    $0x2c,%eax
}
c0102735:	5d                   	pop    %ebp

// Acknowledge interrupt.
void
lapic_eoi(void) {
    if (lapic)
        lapic_write(EOI, 0);
c0102736:	e9 f4 fd ff ff       	jmp    c010252f <lapic_write>
}
c010273b:	5d                   	pop    %ebp
c010273c:	c3                   	ret    

c010273d <lapic_startap>:
#define IO_RTC  0x70

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr) {
c010273d:	55                   	push   %ebp
c010273e:	89 e5                	mov    %esp,%ebp
c0102740:	56                   	push   %esi
c0102741:	53                   	push   %ebx
c0102742:	8b 75 08             	mov    0x8(%ebp),%esi
c0102745:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c0102748:	ba 70 00 00 00       	mov    $0x70,%edx
c010274d:	b0 0f                	mov    $0xf,%al
c010274f:	ee                   	out    %al,(%dx)
c0102750:	ba 71 00 00 00       	mov    $0x71,%edx
c0102755:	b0 0a                	mov    $0xa,%al
c0102757:	ee                   	out    %al,(%dx)

#define VADDR(pa) _vaddr(__FILE__, __LINE__, (size_t) pa)

static inline void*
_vaddr(const char* file, int line, size_t pa) {
    if (PA2PM(pa) >= npages)
c0102758:	83 3d 88 6e 13 c0 00 	cmpl   $0x0,0xc0136e88
c010275f:	75 29                	jne    c010278a <lapic_startap+0x4d>
        panic(file, line, "VADDR called with invalid pa %08x", pa);
c0102761:	50                   	push   %eax
c0102762:	68 67 04 00 00       	push   $0x467
c0102767:	68 16 b1 10 c0       	push   $0xc010b116
c010276c:	68 a4 00 00 00       	push   $0xa4
c0102771:	68 6c b6 10 c0       	push   $0xc010b66c
c0102776:	68 9c b6 10 c0       	push   $0xc010b69c
c010277b:	6a 43                	push   $0x43
c010277d:	68 28 b0 10 c0       	push   $0xc010b028
c0102782:	e8 bb 11 00 00       	call   c0103942 <_panic>
c0102787:	83 c4 20             	add    $0x20,%esp
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
    outb(IO_RTC + 1, 0x0A);
    wrv = (uint16_t*) VADDR((0x40 << 4 | 0x67));   // Warm reset vector
    wrv[0] = 0;
c010278a:	66 c7 05 67 04 00 c0 	movw   $0x0,0xc0000467
c0102791:	00 00 
    wrv[1] = addr >> 4;
c0102793:	89 d8                	mov    %ebx,%eax
c0102795:	c1 e8 04             	shr    $0x4,%eax
c0102798:	66 a3 69 04 00 c0    	mov    %ax,0xc0000469

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapic_write(ICRHI, apicid << 24);
c010279e:	c1 e6 18             	shl    $0x18,%esi
c01027a1:	89 f2                	mov    %esi,%edx
c01027a3:	b8 c4 00 00 00       	mov    $0xc4,%eax
c01027a8:	e8 82 fd ff ff       	call   c010252f <lapic_write>
    lapic_write(ICRLO, INIT | LEVEL | ASSERT);
c01027ad:	ba 00 c5 00 00       	mov    $0xc500,%edx
c01027b2:	b8 c0 00 00 00       	mov    $0xc0,%eax
c01027b7:	e8 73 fd ff ff       	call   c010252f <lapic_write>
    microdelay(200);
    lapic_write(ICRLO, INIT | LEVEL);
c01027bc:	ba 00 85 00 00       	mov    $0x8500,%edx
c01027c1:	b8 c0 00 00 00       	mov    $0xc0,%eax
c01027c6:	e8 64 fd ff ff       	call   c010252f <lapic_write>
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapic_write(ICRHI, apicid << 24);
        lapic_write(ICRLO, STARTUP | (addr >> 12));
c01027cb:	c1 eb 0c             	shr    $0xc,%ebx
c01027ce:	80 cf 06             	or     $0x6,%bh
    // Regular hardware is supposed to only accept a STARTUP
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapic_write(ICRHI, apicid << 24);
c01027d1:	89 f2                	mov    %esi,%edx
c01027d3:	b8 c4 00 00 00       	mov    $0xc4,%eax
c01027d8:	e8 52 fd ff ff       	call   c010252f <lapic_write>
        lapic_write(ICRLO, STARTUP | (addr >> 12));
c01027dd:	89 da                	mov    %ebx,%edx
c01027df:	b8 c0 00 00 00       	mov    $0xc0,%eax
c01027e4:	e8 46 fd ff ff       	call   c010252f <lapic_write>
    // Regular hardware is supposed to only accept a STARTUP
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapic_write(ICRHI, apicid << 24);
c01027e9:	89 f2                	mov    %esi,%edx
c01027eb:	b8 c4 00 00 00       	mov    $0xc4,%eax
c01027f0:	e8 3a fd ff ff       	call   c010252f <lapic_write>
        lapic_write(ICRLO, STARTUP | (addr >> 12));
c01027f5:	89 da                	mov    %ebx,%edx
c01027f7:	b8 c0 00 00 00       	mov    $0xc0,%eax
        microdelay(200);
    }
}
c01027fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01027ff:	5b                   	pop    %ebx
c0102800:	5e                   	pop    %esi
c0102801:	5d                   	pop    %ebp
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapic_write(ICRHI, apicid << 24);
        lapic_write(ICRLO, STARTUP | (addr >> 12));
c0102802:	e9 28 fd ff ff       	jmp    c010252f <lapic_write>

c0102807 <lapic_ipi>:
        microdelay(200);
    }
}

void
lapic_ipi(int vector) {
c0102807:	55                   	push   %ebp
c0102808:	89 e5                	mov    %esp,%ebp
    lapic_write(ICRLO, OTHERS | FIXED | vector);
c010280a:	8b 55 08             	mov    0x8(%ebp),%edx
c010280d:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
c0102813:	b8 c0 00 00 00       	mov    $0xc0,%eax
c0102818:	e8 12 fd ff ff       	call   c010252f <lapic_write>
size_t lapic_addr;       // Initialized in mpconfig.c
static volatile uint32_t* lapic;

static uint32_t
lapic_read(uint32_t index) {
    return lapic[index];
c010281d:	8b 15 70 69 13 c0    	mov    0xc0136970,%edx
c0102823:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
}

void
lapic_ipi(int vector) {
    lapic_write(ICRLO, OTHERS | FIXED | vector);
    while (lapic_read(ICRLO) & DELIVS)
c0102829:	f6 c4 10             	test   $0x10,%ah
c010282c:	75 f5                	jne    c0102823 <lapic_ipi+0x1c>
        ;
}
c010282e:	5d                   	pop    %ebp
c010282f:	c3                   	ret    

c0102830 <irq_handler_pit>:
    outb(0x40, (interval & 0xFF00) >> 8);

    pit_reset();
}

void irq_handler_pit(struct regs* r) {
c0102830:	55                   	push   %ebp
c0102831:	89 e5                	mov    %esp,%ebp
c0102833:	53                   	push   %ebx
c0102834:	50                   	push   %eax
c0102835:	8b 5d 08             	mov    0x8(%ebp),%ebx
    (void) r;

    // assert(!spinlock_held(&thiscpu->active_threads_lock));

    lapic_eoi();
c0102838:	e8 e5 fe ff ff       	call   c0102722 <lapic_eoi>

    ++nticks;
c010283d:	a1 74 69 13 c0       	mov    0xc0136974,%eax
c0102842:	40                   	inc    %eax
c0102843:	a3 74 69 13 c0       	mov    %eax,0xc0136974

    if (thiscpu && thisthread && nticks % YIELD_MOD == 0) {
c0102848:	e8 f5 fc ff ff       	call   c0102542 <cpunum>
c010284d:	83 3c 85 a0 6e 13 c0 	cmpl   $0x0,-0x3fec9160(,%eax,4)
c0102854:	00 
c0102855:	74 4e                	je     c01028a5 <irq_handler_pit+0x75>
c0102857:	e8 e6 fc ff ff       	call   c0102542 <cpunum>
c010285c:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0102863:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
c0102867:	74 3c                	je     c01028a5 <irq_handler_pit+0x75>
c0102869:	a1 74 69 13 c0       	mov    0xc0136974,%eax
c010286e:	b9 14 00 00 00       	mov    $0x14,%ecx
c0102873:	31 d2                	xor    %edx,%edx
c0102875:	f7 f1                	div    %ecx
c0102877:	85 d2                	test   %edx,%edx
c0102879:	75 2a                	jne    c01028a5 <irq_handler_pit+0x75>
        print("\n\t\tyield\n\n");
c010287b:	83 ec 0c             	sub    $0xc,%esp
c010287e:	68 b7 b6 10 c0       	push   $0xc010b6b7
c0102883:	e8 3c 15 00 00       	call   c0103dc4 <print>
        thisthread->context = r;
c0102888:	e8 b5 fc ff ff       	call   c0102542 <cpunum>
c010288d:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0102894:	8b 40 08             	mov    0x8(%eax),%eax
c0102897:	89 18                	mov    %ebx,(%eax)
        // memcpy(thisthread->context, r, sizeof(struct regs));
        thread_yield();
c0102899:	83 c4 10             	add    $0x10,%esp
    }
    // } else
    //     print("\ttick\n");
}
c010289c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010289f:	c9                   	leave  

    if (thiscpu && thisthread && nticks % YIELD_MOD == 0) {
        print("\n\t\tyield\n\n");
        thisthread->context = r;
        // memcpy(thisthread->context, r, sizeof(struct regs));
        thread_yield();
c01028a0:	e9 f6 4a 00 00       	jmp    c010739b <thread_yield>
    }
    // } else
    //     print("\ttick\n");
}
c01028a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01028a8:	c9                   	leave  
c01028a9:	c3                   	ret    

c01028aa <pit_ticks>:
#define PIT_DEFAULT 18.223
#define YIELD_MOD   20

static volatile uint32_t nticks;

uint32_t pit_ticks(void) {
c01028aa:	55                   	push   %ebp
c01028ab:	89 e5                	mov    %esp,%ebp
    return nticks;
c01028ad:	a1 74 69 13 c0       	mov    0xc0136974,%eax
}
c01028b2:	5d                   	pop    %ebp
c01028b3:	c3                   	ret    

c01028b4 <pit_wait>:

void pit_wait(uint32_t ticks) {
c01028b4:	55                   	push   %ebp
c01028b5:	89 e5                	mov    %esp,%ebp
    uint32_t eticks = nticks + ticks;
c01028b7:	a1 74 69 13 c0       	mov    0xc0136974,%eax
c01028bc:	03 45 08             	add    0x8(%ebp),%eax
    while(nticks != eticks);
c01028bf:	8b 15 74 69 13 c0    	mov    0xc0136974,%edx
c01028c5:	39 d0                	cmp    %edx,%eax
c01028c7:	75 f6                	jne    c01028bf <pit_wait+0xb>
}
c01028c9:	5d                   	pop    %ebp
c01028ca:	c3                   	ret    

c01028cb <pit_reset>:

void pit_reset(void) {
c01028cb:	55                   	push   %ebp
c01028cc:	89 e5                	mov    %esp,%ebp
    nticks = 0;
c01028ce:	c7 05 74 69 13 c0 00 	movl   $0x0,0xc0136974
c01028d5:	00 00 00 
}
c01028d8:	5d                   	pop    %ebp
c01028d9:	c3                   	ret    

c01028da <pit_freq>:

void pit_freq(double hz) {
c01028da:	55                   	push   %ebp
c01028db:	89 e5                	mov    %esp,%ebp
c01028dd:	83 ec 08             	sub    $0x8,%esp
    uint16_t interval = 1193180 / hz;
c01028e0:	d9 05 c4 b6 10 c0    	flds   0xc010b6c4
c01028e6:	dc 75 08             	fdivl  0x8(%ebp)
c01028e9:	d9 7d fe             	fnstcw -0x2(%ebp)
c01028ec:	66 8b 45 fe          	mov    -0x2(%ebp),%ax
c01028f0:	80 cc 0c             	or     $0xc,%ah
c01028f3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
c01028f7:	d9 6d fc             	fldcw  -0x4(%ebp)
c01028fa:	db 5d f8             	fistpl -0x8(%ebp)
c01028fd:	d9 6d fe             	fldcw  -0x2(%ebp)
c0102900:	8b 4d f8             	mov    -0x8(%ebp),%ecx
c0102903:	ba 43 00 00 00       	mov    $0x43,%edx
c0102908:	b0 36                	mov    $0x36,%al
c010290a:	ee                   	out    %al,(%dx)
c010290b:	ba 40 00 00 00       	mov    $0x40,%edx
c0102910:	88 c8                	mov    %cl,%al
c0102912:	ee                   	out    %al,(%dx)
c0102913:	89 c8                	mov    %ecx,%eax
c0102915:	66 c1 e8 08          	shr    $0x8,%ax
c0102919:	ee                   	out    %al,(%dx)
    uint32_t eticks = nticks + ticks;
    while(nticks != eticks);
}

void pit_reset(void) {
    nticks = 0;
c010291a:	c7 05 74 69 13 c0 00 	movl   $0x0,0xc0136974
c0102921:	00 00 00 
    outb(0x43, 0x36);
    outb(0x40, interval & 0xFF);
    outb(0x40, (interval & 0xFF00) >> 8);

    pit_reset();
}
c0102924:	c9                   	leave  
c0102925:	c3                   	ret    

c0102926 <init_pit>:
    }
    // } else
    //     print("\ttick\n");
}

void init_pit(void) {
c0102926:	55                   	push   %ebp
c0102927:	89 e5                	mov    %esp,%ebp
c0102929:	83 ec 08             	sub    $0x8,%esp
    pit_freq(PIT_DEFAULT);
c010292c:	68 16 39 32 40       	push   $0x40323916
c0102931:	68 0c 02 2b 87       	push   $0x872b020c
c0102936:	e8 9f ff ff ff       	call   c01028da <pit_freq>
    irq_install_handler(IRQ_TIMER, irq_handler_pit);
c010293b:	68 30 28 10 c0       	push   $0xc0102830
c0102940:	6a 00                	push   $0x0
c0102942:	e8 05 dd ff ff       	call   c010064c <irq_install_handler>
}
c0102947:	83 c4 10             	add    $0x10,%esp
c010294a:	c9                   	leave  
c010294b:	c3                   	ret    

c010294c <irq_handler_serial>:
    inb(0x84);
    inb(0x84);
}

void
irq_handler_serial(struct regs* r) {
c010294c:	55                   	push   %ebp
c010294d:	89 e5                	mov    %esp,%ebp
    (void) r;

    if (serial) {
c010294f:	80 3d 78 69 13 c0 00 	cmpb   $0x0,0xc0136978
c0102956:	74 37                	je     c010298f <irq_handler_serial+0x43>
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102958:	ba fd 03 00 00       	mov    $0x3fd,%edx
c010295d:	ec                   	in     (%dx),%al
        if (!(inb(SERIAL_IO + COM_LSR) & COM_LSR_DATA))
c010295e:	a8 01                	test   $0x1,%al
c0102960:	74 2d                	je     c010298f <irq_handler_serial+0x43>
c0102962:	ba f8 03 00 00       	mov    $0x3f8,%edx
c0102967:	ec                   	in     (%dx),%al
            return;

        char c = (char) inb(SERIAL_IO + COM_RX);

        extern struct console console;
        console.buf[console.wpos++] = c;
c0102968:	8b 0d b4 76 13 c0    	mov    0xc01376b4,%ecx
c010296e:	8d 51 01             	lea    0x1(%ecx),%edx
c0102971:	89 15 b4 76 13 c0    	mov    %edx,0xc01376b4
c0102977:	88 81 e0 6e 13 c0    	mov    %al,-0x3fec9120(%ecx)
        if (console.wpos == CONSBUFSIZE)
c010297d:	81 fa d0 07 00 00    	cmp    $0x7d0,%edx
c0102983:	75 0a                	jne    c010298f <irq_handler_serial+0x43>
            console.wpos = 0;
c0102985:	c7 05 b4 76 13 c0 00 	movl   $0x0,0xc01376b4
c010298c:	00 00 00 
    }
}
c010298f:	5d                   	pop    %ebp
c0102990:	c3                   	ret    

c0102991 <putc_serial>:

void
putc_serial(int c) {
    if (serial) {
c0102991:	80 3d 78 69 13 c0 00 	cmpb   $0x0,0xc0136978
c0102998:	74 30                	je     c01029ca <putc_serial+0x39>
            console.wpos = 0;
    }
}

void
putc_serial(int c) {
c010299a:	55                   	push   %ebp
c010299b:	89 e5                	mov    %esp,%ebp
c010299d:	56                   	push   %esi
c010299e:	53                   	push   %ebx
c010299f:	bb 00 32 00 00       	mov    $0x3200,%ebx
c01029a4:	be fd 03 00 00       	mov    $0x3fd,%esi
c01029a9:	b9 84 00 00 00       	mov    $0x84,%ecx
c01029ae:	89 f2                	mov    %esi,%edx
c01029b0:	ec                   	in     (%dx),%al
    if (serial) {
        for (int i = 0; i < 12800; ++i) {
            if (inb(SERIAL_IO + COM_LSR) & COM_LSR_TXRDY)
c01029b1:	a8 20                	test   $0x20,%al
c01029b3:	75 09                	jne    c01029be <putc_serial+0x2d>
c01029b5:	89 ca                	mov    %ecx,%edx
c01029b7:	ec                   	in     (%dx),%al
c01029b8:	ec                   	in     (%dx),%al
c01029b9:	ec                   	in     (%dx),%al
c01029ba:	ec                   	in     (%dx),%al
}

void
putc_serial(int c) {
    if (serial) {
        for (int i = 0; i < 12800; ++i) {
c01029bb:	4b                   	dec    %ebx
c01029bc:	75 f0                	jne    c01029ae <putc_serial+0x1d>
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01029be:	ba f8 03 00 00       	mov    $0x3f8,%edx
c01029c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c6:	ee                   	out    %al,(%dx)
                break;
            delay();
        }
        outb(SERIAL_IO + COM_TX, c);
    }
}
c01029c7:	5b                   	pop    %ebx
c01029c8:	5e                   	pop    %esi
c01029c9:	5d                   	pop    %ebp
c01029ca:	c3                   	ret    

c01029cb <init_serial>:
//     outb(0x378 + 2, 0x08 | 0x04 | 0x01);
//     outb(0x378 + 2, 0x08);
// }

void
init_serial(void) {
c01029cb:	55                   	push   %ebp
c01029cc:	89 e5                	mov    %esp,%ebp
c01029ce:	53                   	push   %ebx
c01029cf:	83 ec 0c             	sub    $0xc,%esp
c01029d2:	bb fa 03 00 00       	mov    $0x3fa,%ebx
c01029d7:	31 c0                	xor    %eax,%eax
c01029d9:	89 da                	mov    %ebx,%edx
c01029db:	ee                   	out    %al,(%dx)
c01029dc:	ba fb 03 00 00       	mov    $0x3fb,%edx
c01029e1:	b0 80                	mov    $0x80,%al
c01029e3:	ee                   	out    %al,(%dx)
c01029e4:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
c01029e9:	b0 0c                	mov    $0xc,%al
c01029eb:	89 ca                	mov    %ecx,%edx
c01029ed:	ee                   	out    %al,(%dx)
c01029ee:	ba f9 03 00 00       	mov    $0x3f9,%edx
c01029f3:	31 c0                	xor    %eax,%eax
c01029f5:	ee                   	out    %al,(%dx)
c01029f6:	ba fb 03 00 00       	mov    $0x3fb,%edx
c01029fb:	b0 03                	mov    $0x3,%al
c01029fd:	ee                   	out    %al,(%dx)
c01029fe:	ba fc 03 00 00       	mov    $0x3fc,%edx
c0102a03:	31 c0                	xor    %eax,%eax
c0102a05:	ee                   	out    %al,(%dx)
c0102a06:	ba f9 03 00 00       	mov    $0x3f9,%edx
c0102a0b:	b0 01                	mov    $0x1,%al
c0102a0d:	ee                   	out    %al,(%dx)
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102a0e:	ba fd 03 00 00       	mov    $0x3fd,%edx
c0102a13:	ec                   	in     (%dx),%al
    // Enable rcv interrupts
    outb(SERIAL_IO + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial = (inb(SERIAL_IO + COM_LSR) != 0xFF);
c0102a14:	fe c0                	inc    %al
c0102a16:	0f 95 05 78 69 13 c0 	setne  0xc0136978
c0102a1d:	89 da                	mov    %ebx,%edx
c0102a1f:	ec                   	in     (%dx),%al
c0102a20:	89 ca                	mov    %ecx,%edx
c0102a22:	ec                   	in     (%dx),%al
    (void) inb(SERIAL_IO + COM_IIR);
    (void) inb(SERIAL_IO + COM_RX);

    irq_install_handler(IRQ_SER1, irq_handler_serial);
c0102a23:	68 4c 29 10 c0       	push   $0xc010294c
c0102a28:	6a 04                	push   $0x4
c0102a2a:	e8 1d dc ff ff       	call   c010064c <irq_install_handler>
}
c0102a2f:	83 c4 10             	add    $0x10,%esp
c0102a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102a35:	c9                   	leave  
c0102a36:	c3                   	ret    

c0102a37 <speaker_beep>:
nosound() {
    outb(0x61, inb(0x61) & 0xFC);
}

static void
speaker_beep(uint32_t freq, uint32_t ticks) {
c0102a37:	55                   	push   %ebp
c0102a38:	89 e5                	mov    %esp,%ebp
c0102a3a:	56                   	push   %esi
c0102a3b:	53                   	push   %ebx
c0102a3c:	89 c1                	mov    %eax,%ecx
c0102a3e:	89 d6                	mov    %edx,%esi
#include <speaker.h>
#include <pit.h>

static void
sound(uint32_t freq) {
    uint32_t div = 1193180 / freq;
c0102a40:	b8 dc 34 12 00       	mov    $0x1234dc,%eax
c0102a45:	31 d2                	xor    %edx,%edx
c0102a47:	f7 f1                	div    %ecx
c0102a49:	89 c1                	mov    %eax,%ecx
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102a4b:	ba 43 00 00 00       	mov    $0x43,%edx
c0102a50:	b0 b6                	mov    $0xb6,%al
c0102a52:	ee                   	out    %al,(%dx)
c0102a53:	ba 42 00 00 00       	mov    $0x42,%edx
c0102a58:	88 c8                	mov    %cl,%al
c0102a5a:	ee                   	out    %al,(%dx)
c0102a5b:	89 c8                	mov    %ecx,%eax
c0102a5d:	c1 e8 08             	shr    $0x8,%eax
c0102a60:	ee                   	out    %al,(%dx)
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102a61:	bb 61 00 00 00       	mov    $0x61,%ebx
c0102a66:	89 da                	mov    %ebx,%edx
c0102a68:	ec                   	in     (%dx),%al
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102a69:	83 c8 03             	or     $0x3,%eax
c0102a6c:	ee                   	out    %al,(%dx)
}

static void
speaker_beep(uint32_t freq, uint32_t ticks) {
    sound(freq);
    pit_wait(ticks);
c0102a6d:	83 ec 0c             	sub    $0xc,%esp
c0102a70:	56                   	push   %esi
c0102a71:	e8 3e fe ff ff       	call   c01028b4 <pit_wait>
}

static inline uint8_t
inb(int port) {
    uint8_t data;
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102a76:	89 da                	mov    %ebx,%edx
c0102a78:	ec                   	in     (%dx),%al
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102a79:	83 e0 fc             	and    $0xfffffffc,%eax
c0102a7c:	ee                   	out    %al,(%dx)
    nosound();
}
c0102a7d:	83 c4 10             	add    $0x10,%esp
c0102a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0102a83:	5b                   	pop    %ebx
c0102a84:	5e                   	pop    %esi
c0102a85:	5d                   	pop    %ebp
c0102a86:	c3                   	ret    

c0102a87 <speaker_warning>:

void
speaker_warning(void) {
c0102a87:	55                   	push   %ebp
c0102a88:	89 e5                	mov    %esp,%ebp

}
c0102a8a:	5d                   	pop    %ebp
c0102a8b:	c3                   	ret    

c0102a8c <speaker_error>:

void
speaker_error(void) {
c0102a8c:	55                   	push   %ebp
c0102a8d:	89 e5                	mov    %esp,%ebp
c0102a8f:	83 ec 08             	sub    $0x8,%esp
    speaker_beep(300, 4);
c0102a92:	ba 04 00 00 00       	mov    $0x4,%edx
c0102a97:	b8 2c 01 00 00       	mov    $0x12c,%eax
c0102a9c:	e8 96 ff ff ff       	call   c0102a37 <speaker_beep>
    pit_wait(1);
c0102aa1:	83 ec 0c             	sub    $0xc,%esp
c0102aa4:	6a 01                	push   $0x1
c0102aa6:	e8 09 fe ff ff       	call   c01028b4 <pit_wait>
    speaker_beep(300, 7);
c0102aab:	83 c4 10             	add    $0x10,%esp
c0102aae:	ba 07 00 00 00       	mov    $0x7,%edx
c0102ab3:	b8 2c 01 00 00       	mov    $0x12c,%eax
}
c0102ab8:	c9                   	leave  

void
speaker_error(void) {
    speaker_beep(300, 4);
    pit_wait(1);
    speaker_beep(300, 7);
c0102ab9:	e9 79 ff ff ff       	jmp    c0102a37 <speaker_beep>

c0102abe <init_speaker>:
}

void
init_speaker(void) {
c0102abe:	55                   	push   %ebp
c0102abf:	89 e5                	mov    %esp,%ebp
c0102ac1:	83 ec 08             	sub    $0x8,%esp
    speaker_beep(800, 3);
c0102ac4:	ba 03 00 00 00       	mov    $0x3,%edx
c0102ac9:	b8 20 03 00 00       	mov    $0x320,%eax
c0102ace:	e8 64 ff ff ff       	call   c0102a37 <speaker_beep>
    speaker_beep(1000, 3);
c0102ad3:	ba 03 00 00 00       	mov    $0x3,%edx
c0102ad8:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0102add:	e8 55 ff ff ff       	call   c0102a37 <speaker_beep>
    speaker_beep(900, 8);
c0102ae2:	ba 08 00 00 00       	mov    $0x8,%edx
c0102ae7:	b8 84 03 00 00       	mov    $0x384,%eax
}
c0102aec:	c9                   	leave  

void
init_speaker(void) {
    speaker_beep(800, 3);
    speaker_beep(1000, 3);
    speaker_beep(900, 8);
c0102aed:	e9 45 ff ff ff       	jmp    c0102a37 <speaker_beep>

c0102af2 <cv_create>:
#include <cv.h>
#include <spinlock.h>
#include <wchan.h>

struct cv*
cv_create(const char* name) {
c0102af2:	55                   	push   %ebp
c0102af3:	89 e5                	mov    %esp,%ebp
c0102af5:	53                   	push   %ebx
c0102af6:	83 ec 10             	sub    $0x10,%esp
    struct cv* cv;

    cv = kmalloc(sizeof(struct cv));
c0102af9:	6a 10                	push   $0x10
c0102afb:	e8 a5 ed ff ff       	call   c01018a5 <kmalloc>
c0102b00:	89 c3                	mov    %eax,%ebx
    if (cv == NULL)
c0102b02:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0102b05:	31 c0                	xor    %eax,%eax
struct cv*
cv_create(const char* name) {
    struct cv* cv;

    cv = kmalloc(sizeof(struct cv));
    if (cv == NULL)
c0102b07:	85 db                	test   %ebx,%ebx
c0102b09:	74 40                	je     c0102b4b <cv_create+0x59>
        return NULL;

    cv->cv_name = strdup(name);
c0102b0b:	83 ec 0c             	sub    $0xc,%esp
c0102b0e:	ff 75 08             	pushl  0x8(%ebp)
c0102b11:	e8 f4 17 00 00       	call   c010430a <strdup>
c0102b16:	89 03                	mov    %eax,(%ebx)
    if (cv->cv_name == NULL) {
c0102b18:	83 c4 10             	add    $0x10,%esp
c0102b1b:	85 c0                	test   %eax,%eax
c0102b1d:	75 10                	jne    c0102b2f <cv_create+0x3d>
        kfree(cv);
c0102b1f:	83 ec 0c             	sub    $0xc,%esp
c0102b22:	53                   	push   %ebx
c0102b23:	e8 49 ee ff ff       	call   c0101971 <kfree>
        return NULL;
c0102b28:	83 c4 10             	add    $0x10,%esp
c0102b2b:	31 c0                	xor    %eax,%eax
c0102b2d:	eb 1c                	jmp    c0102b4b <cv_create+0x59>
    }

    // Initialize cv fields
    cv->cv_wchan = wchan_create(cv->cv_name);
c0102b2f:	83 ec 0c             	sub    $0xc,%esp
c0102b32:	50                   	push   %eax
c0102b33:	e8 4b 0a 00 00       	call   c0103583 <wchan_create>
c0102b38:	89 43 04             	mov    %eax,0x4(%ebx)
    spinlock_init(&cv->cv_splock);
c0102b3b:	8d 43 08             	lea    0x8(%ebx),%eax
c0102b3e:	89 04 24             	mov    %eax,(%esp)
c0102b41:	e8 6b 07 00 00       	call   c01032b1 <spinlock_init>

    return cv;
c0102b46:	83 c4 10             	add    $0x10,%esp
c0102b49:	89 d8                	mov    %ebx,%eax
}
c0102b4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102b4e:	c9                   	leave  
c0102b4f:	c3                   	ret    

c0102b50 <cv_destroy>:

void
cv_destroy(struct cv* cv) {
c0102b50:	55                   	push   %ebp
c0102b51:	89 e5                	mov    %esp,%ebp
c0102b53:	53                   	push   %ebx
c0102b54:	51                   	push   %ecx
c0102b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(cv != NULL);
c0102b58:	85 db                	test   %ebx,%ebx
c0102b5a:	75 28                	jne    c0102b84 <cv_destroy+0x34>
c0102b5c:	83 ec 0c             	sub    $0xc,%esp
c0102b5f:	68 e0 b6 10 c0       	push   $0xc010b6e0
c0102b64:	6a 1e                	push   $0x1e
c0102b66:	68 c8 b6 10 c0       	push   $0xc010b6c8
c0102b6b:	68 d3 b6 10 c0       	push   $0xc010b6d3
c0102b70:	68 95 a9 10 c0       	push   $0xc010a995
c0102b75:	e8 4a 12 00 00       	call   c0103dc4 <print>
c0102b7a:	83 c4 20             	add    $0x20,%esp
c0102b7d:	e8 c8 e2 ff ff       	call   c0100e4a <backtrace>
c0102b82:	fa                   	cli    
c0102b83:	f4                   	hlt    

    // wchan_cleanup will assert if anyone's waiting on it
    spinlock_cleanup(&cv->cv_splock);
c0102b84:	83 ec 0c             	sub    $0xc,%esp
c0102b87:	8d 43 08             	lea    0x8(%ebx),%eax
c0102b8a:	50                   	push   %eax
c0102b8b:	e8 c5 08 00 00       	call   c0103455 <spinlock_cleanup>
    wchan_destroy(cv->cv_wchan);
c0102b90:	58                   	pop    %eax
c0102b91:	ff 73 04             	pushl  0x4(%ebx)
c0102b94:	e8 9a 0a 00 00       	call   c0103633 <wchan_destroy>

    // provided code
    kfree(cv->cv_name);
c0102b99:	5a                   	pop    %edx
c0102b9a:	ff 33                	pushl  (%ebx)
c0102b9c:	e8 d0 ed ff ff       	call   c0101971 <kfree>
    kfree(cv);
c0102ba1:	83 c4 10             	add    $0x10,%esp
c0102ba4:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c0102ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102baa:	c9                   	leave  
    spinlock_cleanup(&cv->cv_splock);
    wchan_destroy(cv->cv_wchan);

    // provided code
    kfree(cv->cv_name);
    kfree(cv);
c0102bab:	e9 c1 ed ff ff       	jmp    c0101971 <kfree>

c0102bb0 <cv_wait>:
}

void
cv_wait(struct cv* cv, struct lock* lock) {
c0102bb0:	55                   	push   %ebp
c0102bb1:	89 e5                	mov    %esp,%ebp
c0102bb3:	57                   	push   %edi
c0102bb4:	56                   	push   %esi
c0102bb5:	53                   	push   %ebx
c0102bb6:	83 ec 18             	sub    $0x18,%esp
c0102bb9:	8b 7d 08             	mov    0x8(%ebp),%edi
c0102bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
    // Acquire spinlock
    spinlock_acquire(&cv->cv_splock);
c0102bbf:	8d 5f 08             	lea    0x8(%edi),%ebx
c0102bc2:	53                   	push   %ebx
c0102bc3:	e8 2f 07 00 00       	call   c01032f7 <spinlock_acquire>

    // release the passed in lock so it can be acquired by other
    // threads while this thread is down for the count.
    //
    // this is ok since we still hold the spinlock.
    lock_release(lock);
c0102bc8:	89 34 24             	mov    %esi,(%esp)
c0102bcb:	e8 67 03 00 00       	call   c0102f37 <lock_release>
    // let other threads have their turns while this is put on the
    // waiting queue.
    //
    // spinlock will be released, so other threads can acquire it,
    // and reacquired before this returns.
    wchan_sleep(cv->cv_wchan, &cv->cv_splock);
c0102bd0:	58                   	pop    %eax
c0102bd1:	5a                   	pop    %edx
c0102bd2:	53                   	push   %ebx
c0102bd3:	ff 77 04             	pushl  0x4(%edi)
c0102bd6:	e8 1f 0b 00 00       	call   c01036fa <wchan_sleep>

    // release the spinlock.
    spinlock_release(&cv->cv_splock);
c0102bdb:	89 1c 24             	mov    %ebx,(%esp)
c0102bde:	e8 bc 07 00 00       	call   c010339f <spinlock_release>

    // acquire the lock again
    lock_acquire(lock);
c0102be3:	83 c4 10             	add    $0x10,%esp
c0102be6:	89 75 08             	mov    %esi,0x8(%ebp)
}
c0102be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102bec:	5b                   	pop    %ebx
c0102bed:	5e                   	pop    %esi
c0102bee:	5f                   	pop    %edi
c0102bef:	5d                   	pop    %ebp

    // release the spinlock.
    spinlock_release(&cv->cv_splock);

    // acquire the lock again
    lock_acquire(lock);
c0102bf0:	e9 da 01 00 00       	jmp    c0102dcf <lock_acquire>

c0102bf5 <cv_signal>:
}

void
cv_signal(struct cv* cv, struct lock* lock) {
c0102bf5:	55                   	push   %ebp
c0102bf6:	89 e5                	mov    %esp,%ebp
c0102bf8:	57                   	push   %edi
c0102bf9:	56                   	push   %esi
c0102bfa:	53                   	push   %ebx
c0102bfb:	83 ec 18             	sub    $0x18,%esp
c0102bfe:	8b 7d 08             	mov    0x8(%ebp),%edi
c0102c01:	8b 75 0c             	mov    0xc(%ebp),%esi
    // acquire spinlock for atomicity
    spinlock_acquire(&cv->cv_splock);
c0102c04:	8d 5f 08             	lea    0x8(%edi),%ebx
c0102c07:	53                   	push   %ebx
c0102c08:	e8 ea 06 00 00       	call   c01032f7 <spinlock_acquire>

    // release lock so other thread can use it
    lock_release(lock);
c0102c0d:	89 34 24             	mov    %esi,(%esp)
c0102c10:	e8 22 03 00 00       	call   c0102f37 <lock_release>

    // move one TCB in the waiting queue from waiting to ready
    wchan_wakeone(cv->cv_wchan, &cv->cv_splock);
c0102c15:	58                   	pop    %eax
c0102c16:	5a                   	pop    %edx
c0102c17:	53                   	push   %ebx
c0102c18:	ff 77 04             	pushl  0x4(%edi)
c0102c1b:	e8 ae 0b 00 00       	call   c01037ce <wchan_wakeone>

    // release spinlock
    spinlock_release(&cv->cv_splock);
c0102c20:	89 1c 24             	mov    %ebx,(%esp)
c0102c23:	e8 77 07 00 00       	call   c010339f <spinlock_release>

    // reacquire lock while we have control again
    lock_acquire(lock);
c0102c28:	83 c4 10             	add    $0x10,%esp
c0102c2b:	89 75 08             	mov    %esi,0x8(%ebp)
}
c0102c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102c31:	5b                   	pop    %ebx
c0102c32:	5e                   	pop    %esi
c0102c33:	5f                   	pop    %edi
c0102c34:	5d                   	pop    %ebp

    // release spinlock
    spinlock_release(&cv->cv_splock);

    // reacquire lock while we have control again
    lock_acquire(lock);
c0102c35:	e9 95 01 00 00       	jmp    c0102dcf <lock_acquire>

c0102c3a <cv_broadcast>:
}

void
cv_broadcast(struct cv* cv, struct lock* lock) {
c0102c3a:	55                   	push   %ebp
c0102c3b:	89 e5                	mov    %esp,%ebp
c0102c3d:	57                   	push   %edi
c0102c3e:	56                   	push   %esi
c0102c3f:	53                   	push   %ebx
c0102c40:	83 ec 18             	sub    $0x18,%esp
c0102c43:	8b 7d 08             	mov    0x8(%ebp),%edi
c0102c46:	8b 75 0c             	mov    0xc(%ebp),%esi
    // acquire spinlock
    spinlock_acquire(&cv->cv_splock);
c0102c49:	8d 5f 08             	lea    0x8(%edi),%ebx
c0102c4c:	53                   	push   %ebx
c0102c4d:	e8 a5 06 00 00       	call   c01032f7 <spinlock_acquire>

    // release lock so other thread can use it
    lock_release(lock);
c0102c52:	89 34 24             	mov    %esi,(%esp)
c0102c55:	e8 dd 02 00 00       	call   c0102f37 <lock_release>

    // move all TCBs in cv's waiting queue from waiting to ready
    wchan_wakeall(cv->cv_wchan, &cv->cv_splock);
c0102c5a:	58                   	pop    %eax
c0102c5b:	5a                   	pop    %edx
c0102c5c:	53                   	push   %ebx
c0102c5d:	ff 77 04             	pushl  0x4(%edi)
c0102c60:	e8 d5 0b 00 00       	call   c010383a <wchan_wakeall>

    // release spinlock
    spinlock_release(&cv->cv_splock);
c0102c65:	89 1c 24             	mov    %ebx,(%esp)
c0102c68:	e8 32 07 00 00       	call   c010339f <spinlock_release>

    // reacquire lock while we have control again
    lock_acquire(lock);
c0102c6d:	83 c4 10             	add    $0x10,%esp
c0102c70:	89 75 08             	mov    %esi,0x8(%ebp)
}
c0102c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102c76:	5b                   	pop    %ebx
c0102c77:	5e                   	pop    %esi
c0102c78:	5f                   	pop    %edi
c0102c79:	5d                   	pop    %ebp

    // release spinlock
    spinlock_release(&cv->cv_splock);

    // reacquire lock while we have control again
    lock_acquire(lock);
c0102c7a:	e9 50 01 00 00       	jmp    c0102dcf <lock_acquire>

c0102c7f <lock_create>:
#include <lock.h>
#include <thread.h>
#include <x86.h>

struct lock*
lock_create(const char* name) {
c0102c7f:	55                   	push   %ebp
c0102c80:	89 e5                	mov    %esp,%ebp
c0102c82:	53                   	push   %ebx
c0102c83:	83 ec 10             	sub    $0x10,%esp
    struct lock* lock;

    lock = kmalloc(sizeof(struct lock));
c0102c86:	6a 18                	push   $0x18
c0102c88:	e8 18 ec ff ff       	call   c01018a5 <kmalloc>
c0102c8d:	89 c3                	mov    %eax,%ebx
    if (lock == NULL)
c0102c8f:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0102c92:	31 c0                	xor    %eax,%eax
struct lock*
lock_create(const char* name) {
    struct lock* lock;

    lock = kmalloc(sizeof(struct lock));
    if (lock == NULL)
c0102c94:	85 db                	test   %ebx,%ebx
c0102c96:	74 65                	je     c0102cfd <lock_create+0x7e>
        return NULL;

    lock->lk_name = strdup(name);
c0102c98:	83 ec 0c             	sub    $0xc,%esp
c0102c9b:	ff 75 08             	pushl  0x8(%ebp)
c0102c9e:	e8 67 16 00 00       	call   c010430a <strdup>
c0102ca3:	89 03                	mov    %eax,(%ebx)
    if (lock->lk_name == NULL) {
c0102ca5:	83 c4 10             	add    $0x10,%esp
c0102ca8:	85 c0                	test   %eax,%eax
c0102caa:	75 06                	jne    c0102cb2 <lock_create+0x33>
        kfree(lock);
c0102cac:	83 ec 0c             	sub    $0xc,%esp
c0102caf:	53                   	push   %ebx
c0102cb0:	eb 2e                	jmp    c0102ce0 <lock_create+0x61>
        return NULL;
    }

    // initially lock is owned by no one
    lock->lk_owner = NULL;
c0102cb2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    lock->lk_count = 0;
c0102cb9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

    lock->lk_wchan = wchan_create(lock->lk_name);
c0102cc0:	83 ec 0c             	sub    $0xc,%esp
c0102cc3:	50                   	push   %eax
c0102cc4:	e8 ba 08 00 00       	call   c0103583 <wchan_create>
c0102cc9:	89 43 0c             	mov    %eax,0xc(%ebx)
    if (lock->lk_wchan == NULL) {
c0102ccc:	83 c4 10             	add    $0x10,%esp
c0102ccf:	85 c0                	test   %eax,%eax
c0102cd1:	75 19                	jne    c0102cec <lock_create+0x6d>
        kfree(lock->lk_name);
c0102cd3:	83 ec 0c             	sub    $0xc,%esp
c0102cd6:	ff 33                	pushl  (%ebx)
c0102cd8:	e8 94 ec ff ff       	call   c0101971 <kfree>
        kfree(lock);
c0102cdd:	89 1c 24             	mov    %ebx,(%esp)
c0102ce0:	e8 8c ec ff ff       	call   c0101971 <kfree>
        return NULL;
c0102ce5:	83 c4 10             	add    $0x10,%esp
c0102ce8:	31 c0                	xor    %eax,%eax
c0102cea:	eb 11                	jmp    c0102cfd <lock_create+0x7e>
    }

    // lock gets its own baby lock
    spinlock_init(&lock->lk_lock);
c0102cec:	83 ec 0c             	sub    $0xc,%esp
c0102cef:	8d 43 10             	lea    0x10(%ebx),%eax
c0102cf2:	50                   	push   %eax
c0102cf3:	e8 b9 05 00 00       	call   c01032b1 <spinlock_init>

    return lock;
c0102cf8:	83 c4 10             	add    $0x10,%esp
c0102cfb:	89 d8                	mov    %ebx,%eax
}
c0102cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102d00:	c9                   	leave  
c0102d01:	c3                   	ret    

c0102d02 <lock_destroy>:

void
lock_destroy(struct lock* lock) {
c0102d02:	55                   	push   %ebp
c0102d03:	89 e5                	mov    %esp,%ebp
c0102d05:	53                   	push   %ebx
c0102d06:	53                   	push   %ebx
c0102d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lock != NULL);
c0102d0a:	85 db                	test   %ebx,%ebx
c0102d0c:	75 28                	jne    c0102d36 <lock_destroy+0x34>
c0102d0e:	83 ec 0c             	sub    $0xc,%esp
c0102d11:	68 a8 b7 10 c0       	push   $0xc010b7a8
c0102d16:	6a 28                	push   $0x28
c0102d18:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102d1d:	68 f8 b6 10 c0       	push   $0xc010b6f8
c0102d22:	68 95 a9 10 c0       	push   $0xc010a995
c0102d27:	e8 98 10 00 00       	call   c0103dc4 <print>
c0102d2c:	83 c4 20             	add    $0x20,%esp
c0102d2f:	e8 16 e1 ff ff       	call   c0100e4a <backtrace>
c0102d34:	fa                   	cli    
c0102d35:	f4                   	hlt    

    /* wchan_cleanup will assert if anyone's waiting on it */
    spinlock_cleanup(&lock->lk_lock);
c0102d36:	83 ec 0c             	sub    $0xc,%esp
c0102d39:	8d 43 10             	lea    0x10(%ebx),%eax
c0102d3c:	50                   	push   %eax
c0102d3d:	e8 13 07 00 00       	call   c0103455 <spinlock_cleanup>
    wchan_destroy(lock->lk_wchan);
c0102d42:	58                   	pop    %eax
c0102d43:	ff 73 0c             	pushl  0xc(%ebx)
c0102d46:	e8 e8 08 00 00       	call   c0103633 <wchan_destroy>
    kfree(lock->lk_owner);
c0102d4b:	5a                   	pop    %edx
c0102d4c:	ff 73 04             	pushl  0x4(%ebx)
c0102d4f:	e8 1d ec ff ff       	call   c0101971 <kfree>
    kfree(lock->lk_name);
c0102d54:	59                   	pop    %ecx
c0102d55:	ff 33                	pushl  (%ebx)
c0102d57:	e8 15 ec ff ff       	call   c0101971 <kfree>
    kfree(lock);
c0102d5c:	83 c4 10             	add    $0x10,%esp
c0102d5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c0102d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102d65:	c9                   	leave  
    /* wchan_cleanup will assert if anyone's waiting on it */
    spinlock_cleanup(&lock->lk_lock);
    wchan_destroy(lock->lk_wchan);
    kfree(lock->lk_owner);
    kfree(lock->lk_name);
    kfree(lock);
c0102d66:	e9 06 ec ff ff       	jmp    c0101971 <kfree>

c0102d6b <lock_holding>:

    spinlock_release(&lock->lk_lock);
}

bool
lock_holding(struct lock* lock) {
c0102d6b:	55                   	push   %ebp
c0102d6c:	89 e5                	mov    %esp,%ebp
c0102d6e:	53                   	push   %ebx
c0102d6f:	51                   	push   %ecx
c0102d70:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lock != NULL);
c0102d73:	85 db                	test   %ebx,%ebx
c0102d75:	75 28                	jne    c0102d9f <lock_holding+0x34>
c0102d77:	83 ec 0c             	sub    $0xc,%esp
c0102d7a:	68 78 b7 10 c0       	push   $0xc010b778
c0102d7f:	6a 61                	push   $0x61
c0102d81:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102d86:	68 f8 b6 10 c0       	push   $0xc010b6f8
c0102d8b:	68 95 a9 10 c0       	push   $0xc010a995
c0102d90:	e8 2f 10 00 00       	call   c0103dc4 <print>
c0102d95:	83 c4 20             	add    $0x20,%esp
c0102d98:	e8 ad e0 ff ff       	call   c0100e4a <backtrace>
c0102d9d:	fa                   	cli    
c0102d9e:	f4                   	hlt    
    if (lock->lk_owner == NULL)
c0102d9f:	8b 5b 04             	mov    0x4(%ebx),%ebx
        return false;
c0102da2:	31 c0                	xor    %eax,%eax
}

bool
lock_holding(struct lock* lock) {
    assert(lock != NULL);
    if (lock->lk_owner == NULL)
c0102da4:	85 db                	test   %ebx,%ebx
c0102da6:	74 22                	je     c0102dca <lock_holding+0x5f>
        return false;
    return strcmp(thisthread->name, lock->lk_owner) == 0;
c0102da8:	e8 95 f7 ff ff       	call   c0102542 <cpunum>
c0102dad:	52                   	push   %edx
c0102dae:	52                   	push   %edx
c0102daf:	53                   	push   %ebx
c0102db0:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0102db7:	8b 40 08             	mov    0x8(%eax),%eax
c0102dba:	ff 70 10             	pushl  0x10(%eax)
c0102dbd:	e8 d3 15 00 00       	call   c0104395 <strcmp>
c0102dc2:	83 c4 10             	add    $0x10,%esp
c0102dc5:	85 c0                	test   %eax,%eax
c0102dc7:	0f 94 c0             	sete   %al
}
c0102dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102dcd:	c9                   	leave  
c0102dce:	c3                   	ret    

c0102dcf <lock_acquire>:
    kfree(lock->lk_name);
    kfree(lock);
}

void
lock_acquire(struct lock* lock) {
c0102dcf:	55                   	push   %ebp
c0102dd0:	89 e5                	mov    %esp,%ebp
c0102dd2:	56                   	push   %esi
c0102dd3:	53                   	push   %ebx
c0102dd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lock != NULL);
c0102dd7:	85 db                	test   %ebx,%ebx
c0102dd9:	75 28                	jne    c0102e03 <lock_acquire+0x34>
c0102ddb:	83 ec 0c             	sub    $0xc,%esp
c0102dde:	68 98 b7 10 c0       	push   $0xc010b798
c0102de3:	6a 34                	push   $0x34
c0102de5:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102dea:	68 f8 b6 10 c0       	push   $0xc010b6f8
c0102def:	68 95 a9 10 c0       	push   $0xc010a995
c0102df4:	e8 cb 0f 00 00       	call   c0103dc4 <print>
c0102df9:	83 c4 20             	add    $0x20,%esp
c0102dfc:	e8 49 e0 ff ff       	call   c0100e4a <backtrace>
c0102e01:	fa                   	cli    
c0102e02:	f4                   	hlt    
    assert(thisthread->in_interrupt == false);
c0102e03:	e8 3a f7 ff ff       	call   c0102542 <cpunum>
c0102e08:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0102e0f:	8b 40 08             	mov    0x8(%eax),%eax
c0102e12:	80 78 2c 00          	cmpb   $0x0,0x2c(%eax)
c0102e16:	74 28                	je     c0102e40 <lock_acquire+0x71>
c0102e18:	83 ec 0c             	sub    $0xc,%esp
c0102e1b:	68 98 b7 10 c0       	push   $0xc010b798
c0102e20:	6a 35                	push   $0x35
c0102e22:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102e27:	68 05 b7 10 c0       	push   $0xc010b705
c0102e2c:	68 95 a9 10 c0       	push   $0xc010a995
c0102e31:	e8 8e 0f 00 00       	call   c0103dc4 <print>
c0102e36:	83 c4 20             	add    $0x20,%esp
c0102e39:	e8 0c e0 ff ff       	call   c0100e4a <backtrace>
c0102e3e:	fa                   	cli    
c0102e3f:	f4                   	hlt    

    // Use the lock spinlock to protect the wchan as well.
    spinlock_acquire(&lock->lk_lock);
c0102e40:	8d 73 10             	lea    0x10(%ebx),%esi
c0102e43:	83 ec 0c             	sub    $0xc,%esp
c0102e46:	56                   	push   %esi
c0102e47:	e8 ab 04 00 00       	call   c01032f7 <spinlock_acquire>

    if (!lock_holding(lock)) {
c0102e4c:	89 1c 24             	mov    %ebx,(%esp)
c0102e4f:	e8 17 ff ff ff       	call   c0102d6b <lock_holding>
c0102e54:	83 c4 10             	add    $0x10,%esp
c0102e57:	84 c0                	test   %al,%al
c0102e59:	0f 85 8f 00 00 00    	jne    c0102eee <lock_acquire+0x11f>
        while (lock->lk_count > 0)
c0102e5f:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c0102e63:	7e 10                	jle    c0102e75 <lock_acquire+0xa6>
            wchan_sleep(lock->lk_wchan, &lock->lk_lock);
c0102e65:	50                   	push   %eax
c0102e66:	50                   	push   %eax
c0102e67:	56                   	push   %esi
c0102e68:	ff 73 0c             	pushl  0xc(%ebx)
c0102e6b:	e8 8a 08 00 00       	call   c01036fa <wchan_sleep>
c0102e70:	83 c4 10             	add    $0x10,%esp
c0102e73:	eb ea                	jmp    c0102e5f <lock_acquire+0x90>

        assert(lock->lk_count == 0);
c0102e75:	74 28                	je     c0102e9f <lock_acquire+0xd0>
c0102e77:	83 ec 0c             	sub    $0xc,%esp
c0102e7a:	68 98 b7 10 c0       	push   $0xc010b798
c0102e7f:	6a 3e                	push   $0x3e
c0102e81:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102e86:	68 27 b7 10 c0       	push   $0xc010b727
c0102e8b:	68 95 a9 10 c0       	push   $0xc010a995
c0102e90:	e8 2f 0f 00 00       	call   c0103dc4 <print>
c0102e95:	83 c4 20             	add    $0x20,%esp
c0102e98:	e8 ad df ff ff       	call   c0100e4a <backtrace>
c0102e9d:	fa                   	cli    
c0102e9e:	f4                   	hlt    
        assert(lock->lk_owner == NULL);
c0102e9f:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
c0102ea3:	74 28                	je     c0102ecd <lock_acquire+0xfe>
c0102ea5:	83 ec 0c             	sub    $0xc,%esp
c0102ea8:	68 98 b7 10 c0       	push   $0xc010b798
c0102ead:	6a 3f                	push   $0x3f
c0102eaf:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102eb4:	68 3b b7 10 c0       	push   $0xc010b73b
c0102eb9:	68 95 a9 10 c0       	push   $0xc010a995
c0102ebe:	e8 01 0f 00 00       	call   c0103dc4 <print>
c0102ec3:	83 c4 20             	add    $0x20,%esp
c0102ec6:	e8 7f df ff ff       	call   c0100e4a <backtrace>
c0102ecb:	fa                   	cli    
c0102ecc:	f4                   	hlt    
        lock->lk_owner = strdup(thisthread->name);
c0102ecd:	e8 70 f6 ff ff       	call   c0102542 <cpunum>
c0102ed2:	83 ec 0c             	sub    $0xc,%esp
c0102ed5:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0102edc:	8b 40 08             	mov    0x8(%eax),%eax
c0102edf:	ff 70 10             	pushl  0x10(%eax)
c0102ee2:	e8 23 14 00 00       	call   c010430a <strdup>
c0102ee7:	89 43 04             	mov    %eax,0x4(%ebx)

#endif // _TYPES_

static inline void
cli(void) {
    asm volatile ("cli");
c0102eea:	fa                   	cli    
c0102eeb:	83 c4 10             	add    $0x10,%esp
        cli();
    }

    lock->lk_count++;
c0102eee:	ff 43 08             	incl   0x8(%ebx)
    assert(lock_holding(lock));
c0102ef1:	83 ec 0c             	sub    $0xc,%esp
c0102ef4:	53                   	push   %ebx
c0102ef5:	e8 71 fe ff ff       	call   c0102d6b <lock_holding>
c0102efa:	83 c4 10             	add    $0x10,%esp
c0102efd:	84 c0                	test   %al,%al
c0102eff:	75 28                	jne    c0102f29 <lock_acquire+0x15a>
c0102f01:	83 ec 0c             	sub    $0xc,%esp
c0102f04:	68 98 b7 10 c0       	push   $0xc010b798
c0102f09:	6a 45                	push   $0x45
c0102f0b:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102f10:	68 52 b7 10 c0       	push   $0xc010b752
c0102f15:	68 95 a9 10 c0       	push   $0xc010a995
c0102f1a:	e8 a5 0e 00 00       	call   c0103dc4 <print>
c0102f1f:	83 c4 20             	add    $0x20,%esp
c0102f22:	e8 23 df ff ff       	call   c0100e4a <backtrace>
c0102f27:	fa                   	cli    
c0102f28:	f4                   	hlt    
    spinlock_release(&lock->lk_lock);
c0102f29:	89 75 08             	mov    %esi,0x8(%ebp)
}
c0102f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0102f2f:	5b                   	pop    %ebx
c0102f30:	5e                   	pop    %esi
c0102f31:	5d                   	pop    %ebp
        cli();
    }

    lock->lk_count++;
    assert(lock_holding(lock));
    spinlock_release(&lock->lk_lock);
c0102f32:	e9 68 04 00 00       	jmp    c010339f <spinlock_release>

c0102f37 <lock_release>:
}

void
lock_release(struct lock* lock) {
c0102f37:	55                   	push   %ebp
c0102f38:	89 e5                	mov    %esp,%ebp
c0102f3a:	56                   	push   %esi
c0102f3b:	53                   	push   %ebx
c0102f3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lock != NULL);
c0102f3f:	85 db                	test   %ebx,%ebx
c0102f41:	75 28                	jne    c0102f6b <lock_release+0x34>
c0102f43:	83 ec 0c             	sub    $0xc,%esp
c0102f46:	68 88 b7 10 c0       	push   $0xc010b788
c0102f4b:	6a 4b                	push   $0x4b
c0102f4d:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102f52:	68 f8 b6 10 c0       	push   $0xc010b6f8
c0102f57:	68 95 a9 10 c0       	push   $0xc010a995
c0102f5c:	e8 63 0e 00 00       	call   c0103dc4 <print>
c0102f61:	83 c4 20             	add    $0x20,%esp
c0102f64:	e8 e1 de ff ff       	call   c0100e4a <backtrace>
c0102f69:	fa                   	cli    
c0102f6a:	f4                   	hlt    
    spinlock_acquire(&lock->lk_lock);
c0102f6b:	8d 73 10             	lea    0x10(%ebx),%esi
c0102f6e:	83 ec 0c             	sub    $0xc,%esp
c0102f71:	56                   	push   %esi
c0102f72:	e8 80 03 00 00       	call   c01032f7 <spinlock_acquire>

    // if I don't hold lock, I can't release it
    assert(lock_holding(lock)); // Won't compile with &lock
c0102f77:	89 1c 24             	mov    %ebx,(%esp)
c0102f7a:	e8 ec fd ff ff       	call   c0102d6b <lock_holding>
c0102f7f:	83 c4 10             	add    $0x10,%esp
c0102f82:	84 c0                	test   %al,%al
c0102f84:	75 28                	jne    c0102fae <lock_release+0x77>
c0102f86:	83 ec 0c             	sub    $0xc,%esp
c0102f89:	68 88 b7 10 c0       	push   $0xc010b788
c0102f8e:	6a 4f                	push   $0x4f
c0102f90:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102f95:	68 52 b7 10 c0       	push   $0xc010b752
c0102f9a:	68 95 a9 10 c0       	push   $0xc010a995
c0102f9f:	e8 20 0e 00 00       	call   c0103dc4 <print>
c0102fa4:	83 c4 20             	add    $0x20,%esp
c0102fa7:	e8 9e de ff ff       	call   c0100e4a <backtrace>
c0102fac:	fa                   	cli    
c0102fad:	f4                   	hlt    
    assert(lock->lk_count > 0);
c0102fae:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c0102fb2:	7f 28                	jg     c0102fdc <lock_release+0xa5>
c0102fb4:	83 ec 0c             	sub    $0xc,%esp
c0102fb7:	68 88 b7 10 c0       	push   $0xc010b788
c0102fbc:	6a 50                	push   $0x50
c0102fbe:	68 eb b6 10 c0       	push   $0xc010b6eb
c0102fc3:	68 65 b7 10 c0       	push   $0xc010b765
c0102fc8:	68 95 a9 10 c0       	push   $0xc010a995
c0102fcd:	e8 f2 0d 00 00       	call   c0103dc4 <print>
c0102fd2:	83 c4 20             	add    $0x20,%esp
c0102fd5:	e8 70 de ff ff       	call   c0100e4a <backtrace>
c0102fda:	fa                   	cli    
c0102fdb:	f4                   	hlt    

    lock->lk_count--;

    if (lock->lk_count == 0) {
c0102fdc:	ff 4b 08             	decl   0x8(%ebx)
c0102fdf:	75 21                	jne    c0103002 <lock_release+0xcb>
        // time for a new thread to acquire this lock
        kfree(lock->lk_owner);
c0102fe1:	83 ec 0c             	sub    $0xc,%esp
c0102fe4:	ff 73 04             	pushl  0x4(%ebx)
c0102fe7:	e8 85 e9 ff ff       	call   c0101971 <kfree>
        lock->lk_owner = NULL;
c0102fec:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
c0102ff3:	fa                   	cli    
        cli();
        wchan_wakeone(lock->lk_wchan, &lock->lk_lock);
c0102ff4:	58                   	pop    %eax
c0102ff5:	5a                   	pop    %edx
c0102ff6:	56                   	push   %esi
c0102ff7:	ff 73 0c             	pushl  0xc(%ebx)
c0102ffa:	e8 cf 07 00 00       	call   c01037ce <wchan_wakeone>
c0102fff:	83 c4 10             	add    $0x10,%esp
    }  // else this thread maintains its hold on the lock

    spinlock_release(&lock->lk_lock);
c0103002:	89 75 08             	mov    %esi,0x8(%ebp)
}
c0103005:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0103008:	5b                   	pop    %ebx
c0103009:	5e                   	pop    %esi
c010300a:	5d                   	pop    %ebp
        lock->lk_owner = NULL;
        cli();
        wchan_wakeone(lock->lk_wchan, &lock->lk_lock);
    }  // else this thread maintains its hold on the lock

    spinlock_release(&lock->lk_lock);
c010300b:	e9 8f 03 00 00       	jmp    c010339f <spinlock_release>

c0103010 <semaphore_create>:
#include <spinlock.h>
#include <wchan.h>
#include <thread.h>

struct semaphore*
semaphore_create(const char* name, unsigned initial_count) {
c0103010:	55                   	push   %ebp
c0103011:	89 e5                	mov    %esp,%ebp
c0103013:	53                   	push   %ebx
c0103014:	83 ec 10             	sub    $0x10,%esp
    struct semaphore* sem;

    sem = kmalloc(sizeof(struct semaphore));
c0103017:	6a 14                	push   $0x14
c0103019:	e8 87 e8 ff ff       	call   c01018a5 <kmalloc>
c010301e:	89 c3                	mov    %eax,%ebx
    if (sem == NULL)
c0103020:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0103023:	31 c0                	xor    %eax,%eax
struct semaphore*
semaphore_create(const char* name, unsigned initial_count) {
    struct semaphore* sem;

    sem = kmalloc(sizeof(struct semaphore));
    if (sem == NULL)
c0103025:	85 db                	test   %ebx,%ebx
c0103027:	74 5d                	je     c0103086 <semaphore_create+0x76>
        return NULL;

    sem->sem_name = strdup(name);
c0103029:	83 ec 0c             	sub    $0xc,%esp
c010302c:	ff 75 08             	pushl  0x8(%ebp)
c010302f:	e8 d6 12 00 00       	call   c010430a <strdup>
c0103034:	89 03                	mov    %eax,(%ebx)
    if (sem->sem_name == NULL) {
c0103036:	83 c4 10             	add    $0x10,%esp
c0103039:	85 c0                	test   %eax,%eax
c010303b:	75 06                	jne    c0103043 <semaphore_create+0x33>
        kfree(sem);
c010303d:	83 ec 0c             	sub    $0xc,%esp
c0103040:	53                   	push   %ebx
c0103041:	eb 20                	jmp    c0103063 <semaphore_create+0x53>
        return NULL;
    }

    sem->sem_wchan = wchan_create(sem->sem_name);
c0103043:	83 ec 0c             	sub    $0xc,%esp
c0103046:	50                   	push   %eax
c0103047:	e8 37 05 00 00       	call   c0103583 <wchan_create>
c010304c:	89 43 04             	mov    %eax,0x4(%ebx)
    if (sem->sem_wchan == NULL) {
c010304f:	83 c4 10             	add    $0x10,%esp
c0103052:	85 c0                	test   %eax,%eax
c0103054:	75 19                	jne    c010306f <semaphore_create+0x5f>
        kfree(sem->sem_name);
c0103056:	83 ec 0c             	sub    $0xc,%esp
c0103059:	ff 33                	pushl  (%ebx)
c010305b:	e8 11 e9 ff ff       	call   c0101971 <kfree>
        kfree(sem);
c0103060:	89 1c 24             	mov    %ebx,(%esp)
c0103063:	e8 09 e9 ff ff       	call   c0101971 <kfree>
        return NULL;
c0103068:	83 c4 10             	add    $0x10,%esp
c010306b:	31 c0                	xor    %eax,%eax
c010306d:	eb 17                	jmp    c0103086 <semaphore_create+0x76>
    }

    spinlock_init(&sem->sem_lock);
c010306f:	83 ec 0c             	sub    $0xc,%esp
c0103072:	8d 43 08             	lea    0x8(%ebx),%eax
c0103075:	50                   	push   %eax
c0103076:	e8 36 02 00 00       	call   c01032b1 <spinlock_init>
    sem->sem_count = initial_count;
c010307b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010307e:	89 43 10             	mov    %eax,0x10(%ebx)

    return sem;
c0103081:	83 c4 10             	add    $0x10,%esp
c0103084:	89 d8                	mov    %ebx,%eax
}
c0103086:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103089:	c9                   	leave  
c010308a:	c3                   	ret    

c010308b <semaphore_destroy>:

void
semaphore_destroy(struct semaphore* sem) {
c010308b:	55                   	push   %ebp
c010308c:	89 e5                	mov    %esp,%ebp
c010308e:	53                   	push   %ebx
c010308f:	51                   	push   %ecx
c0103090:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(sem != NULL);
c0103093:	85 db                	test   %ebx,%ebx
c0103095:	75 28                	jne    c01030bf <semaphore_destroy+0x34>
c0103097:	83 ec 0c             	sub    $0xc,%esp
c010309a:	68 ec b7 10 c0       	push   $0xc010b7ec
c010309f:	6a 25                	push   $0x25
c01030a1:	68 b5 b7 10 c0       	push   $0xc010b7b5
c01030a6:	68 c7 b7 10 c0       	push   $0xc010b7c7
c01030ab:	68 95 a9 10 c0       	push   $0xc010a995
c01030b0:	e8 0f 0d 00 00       	call   c0103dc4 <print>
c01030b5:	83 c4 20             	add    $0x20,%esp
c01030b8:	e8 8d dd ff ff       	call   c0100e4a <backtrace>
c01030bd:	fa                   	cli    
c01030be:	f4                   	hlt    

    /* wchan_cleanup will assert if anyone's waiting on it */
    spinlock_cleanup(&sem->sem_lock);
c01030bf:	83 ec 0c             	sub    $0xc,%esp
c01030c2:	8d 43 08             	lea    0x8(%ebx),%eax
c01030c5:	50                   	push   %eax
c01030c6:	e8 8a 03 00 00       	call   c0103455 <spinlock_cleanup>
    wchan_destroy(sem->sem_wchan);
c01030cb:	58                   	pop    %eax
c01030cc:	ff 73 04             	pushl  0x4(%ebx)
c01030cf:	e8 5f 05 00 00       	call   c0103633 <wchan_destroy>
    kfree(sem->sem_name);
c01030d4:	5a                   	pop    %edx
c01030d5:	ff 33                	pushl  (%ebx)
c01030d7:	e8 95 e8 ff ff       	call   c0101971 <kfree>
    kfree(sem);
c01030dc:	83 c4 10             	add    $0x10,%esp
c01030df:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c01030e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01030e5:	c9                   	leave  

    /* wchan_cleanup will assert if anyone's waiting on it */
    spinlock_cleanup(&sem->sem_lock);
    wchan_destroy(sem->sem_wchan);
    kfree(sem->sem_name);
    kfree(sem);
c01030e6:	e9 86 e8 ff ff       	jmp    c0101971 <kfree>

c01030eb <P>:
}

void
P(struct semaphore* sem) {
c01030eb:	55                   	push   %ebp
c01030ec:	89 e5                	mov    %esp,%ebp
c01030ee:	56                   	push   %esi
c01030ef:	53                   	push   %ebx
c01030f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(sem != NULL);
c01030f3:	85 db                	test   %ebx,%ebx
c01030f5:	75 28                	jne    c010311f <P+0x34>
c01030f7:	83 ec 0c             	sub    $0xc,%esp
c01030fa:	68 ea b7 10 c0       	push   $0xc010b7ea
c01030ff:	6a 30                	push   $0x30
c0103101:	68 b5 b7 10 c0       	push   $0xc010b7b5
c0103106:	68 c7 b7 10 c0       	push   $0xc010b7c7
c010310b:	68 95 a9 10 c0       	push   $0xc010a995
c0103110:	e8 af 0c 00 00       	call   c0103dc4 <print>
c0103115:	83 c4 20             	add    $0x20,%esp
c0103118:	e8 2d dd ff ff       	call   c0100e4a <backtrace>
c010311d:	fa                   	cli    
c010311e:	f4                   	hlt    
     * May not block in an interrupt handler.
     *
     * For robustness, always check, even if we can actually
     * complete the P without blocking.
     */
    assert(thisthread->in_interrupt == false);
c010311f:	e8 1e f4 ff ff       	call   c0102542 <cpunum>
c0103124:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010312b:	8b 40 08             	mov    0x8(%eax),%eax
c010312e:	80 78 2c 00          	cmpb   $0x0,0x2c(%eax)
c0103132:	74 28                	je     c010315c <P+0x71>
c0103134:	83 ec 0c             	sub    $0xc,%esp
c0103137:	68 ea b7 10 c0       	push   $0xc010b7ea
c010313c:	6a 38                	push   $0x38
c010313e:	68 b5 b7 10 c0       	push   $0xc010b7b5
c0103143:	68 05 b7 10 c0       	push   $0xc010b705
c0103148:	68 95 a9 10 c0       	push   $0xc010a995
c010314d:	e8 72 0c 00 00       	call   c0103dc4 <print>
c0103152:	83 c4 20             	add    $0x20,%esp
c0103155:	e8 f0 dc ff ff       	call   c0100e4a <backtrace>
c010315a:	fa                   	cli    
c010315b:	f4                   	hlt    

    /* Use the semaphore spinlock to protect the wchan as well. */
    spinlock_acquire(&sem->sem_lock);
c010315c:	8d 73 08             	lea    0x8(%ebx),%esi
c010315f:	83 ec 0c             	sub    $0xc,%esp
c0103162:	56                   	push   %esi
c0103163:	e8 8f 01 00 00       	call   c01032f7 <spinlock_acquire>
         * strict ordering. Too bad. :-)
         *
         * Exercise: how would you implement strict FIFO
         * ordering?
         */
        wchan_sleep(sem->sem_wchan, &sem->sem_lock);
c0103168:	83 c4 10             	add    $0x10,%esp
     */
    assert(thisthread->in_interrupt == false);

    /* Use the semaphore spinlock to protect the wchan as well. */
    spinlock_acquire(&sem->sem_lock);
    while (sem->sem_count == 0) {
c010316b:	8b 43 10             	mov    0x10(%ebx),%eax
c010316e:	85 c0                	test   %eax,%eax
c0103170:	75 0d                	jne    c010317f <P+0x94>
         * strict ordering. Too bad. :-)
         *
         * Exercise: how would you implement strict FIFO
         * ordering?
         */
        wchan_sleep(sem->sem_wchan, &sem->sem_lock);
c0103172:	50                   	push   %eax
c0103173:	50                   	push   %eax
c0103174:	56                   	push   %esi
c0103175:	ff 73 04             	pushl  0x4(%ebx)
c0103178:	e8 7d 05 00 00       	call   c01036fa <wchan_sleep>
c010317d:	eb e9                	jmp    c0103168 <P+0x7d>
    }
    assert(sem->sem_count > 0);
c010317f:	8b 43 10             	mov    0x10(%ebx),%eax
c0103182:	85 c0                	test   %eax,%eax
c0103184:	75 28                	jne    c01031ae <P+0xc3>
c0103186:	83 ec 0c             	sub    $0xc,%esp
c0103189:	68 ea b7 10 c0       	push   $0xc010b7ea
c010318e:	6a 4b                	push   $0x4b
c0103190:	68 b5 b7 10 c0       	push   $0xc010b7b5
c0103195:	68 d3 b7 10 c0       	push   $0xc010b7d3
c010319a:	68 95 a9 10 c0       	push   $0xc010a995
c010319f:	e8 20 0c 00 00       	call   c0103dc4 <print>
c01031a4:	83 c4 20             	add    $0x20,%esp
c01031a7:	e8 9e dc ff ff       	call   c0100e4a <backtrace>
c01031ac:	fa                   	cli    
c01031ad:	f4                   	hlt    
    sem->sem_count--;
c01031ae:	8b 43 10             	mov    0x10(%ebx),%eax
c01031b1:	48                   	dec    %eax
c01031b2:	89 43 10             	mov    %eax,0x10(%ebx)
    spinlock_release(&sem->sem_lock);
c01031b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
c01031b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01031bb:	5b                   	pop    %ebx
c01031bc:	5e                   	pop    %esi
c01031bd:	5d                   	pop    %ebp
         */
        wchan_sleep(sem->sem_wchan, &sem->sem_lock);
    }
    assert(sem->sem_count > 0);
    sem->sem_count--;
    spinlock_release(&sem->sem_lock);
c01031be:	e9 dc 01 00 00       	jmp    c010339f <spinlock_release>

c01031c3 <V>:
}

void
V(struct semaphore* sem) {
c01031c3:	55                   	push   %ebp
c01031c4:	89 e5                	mov    %esp,%ebp
c01031c6:	56                   	push   %esi
c01031c7:	53                   	push   %ebx
c01031c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(sem != NULL);
c01031cb:	85 db                	test   %ebx,%ebx
c01031cd:	75 28                	jne    c01031f7 <V+0x34>
c01031cf:	83 ec 0c             	sub    $0xc,%esp
c01031d2:	68 e8 b7 10 c0       	push   $0xc010b7e8
c01031d7:	6a 52                	push   $0x52
c01031d9:	68 b5 b7 10 c0       	push   $0xc010b7b5
c01031de:	68 c7 b7 10 c0       	push   $0xc010b7c7
c01031e3:	68 95 a9 10 c0       	push   $0xc010a995
c01031e8:	e8 d7 0b 00 00       	call   c0103dc4 <print>
c01031ed:	83 c4 20             	add    $0x20,%esp
c01031f0:	e8 55 dc ff ff       	call   c0100e4a <backtrace>
c01031f5:	fa                   	cli    
c01031f6:	f4                   	hlt    

    spinlock_acquire(&sem->sem_lock);
c01031f7:	8d 73 08             	lea    0x8(%ebx),%esi
c01031fa:	83 ec 0c             	sub    $0xc,%esp
c01031fd:	56                   	push   %esi
c01031fe:	e8 f4 00 00 00       	call   c01032f7 <spinlock_acquire>

    sem->sem_count++;
c0103203:	8b 43 10             	mov    0x10(%ebx),%eax
c0103206:	40                   	inc    %eax
c0103207:	89 43 10             	mov    %eax,0x10(%ebx)
    assert(sem->sem_count > 0);
c010320a:	8b 43 10             	mov    0x10(%ebx),%eax
c010320d:	83 c4 10             	add    $0x10,%esp
c0103210:	85 c0                	test   %eax,%eax
c0103212:	75 28                	jne    c010323c <V+0x79>
c0103214:	83 ec 0c             	sub    $0xc,%esp
c0103217:	68 e8 b7 10 c0       	push   $0xc010b7e8
c010321c:	6a 57                	push   $0x57
c010321e:	68 b5 b7 10 c0       	push   $0xc010b7b5
c0103223:	68 d3 b7 10 c0       	push   $0xc010b7d3
c0103228:	68 95 a9 10 c0       	push   $0xc010a995
c010322d:	e8 92 0b 00 00       	call   c0103dc4 <print>
c0103232:	83 c4 20             	add    $0x20,%esp
c0103235:	e8 10 dc ff ff       	call   c0100e4a <backtrace>
c010323a:	fa                   	cli    
c010323b:	f4                   	hlt    
    wchan_wakeone(sem->sem_wchan, &sem->sem_lock);
c010323c:	50                   	push   %eax
c010323d:	50                   	push   %eax
c010323e:	56                   	push   %esi
c010323f:	ff 73 04             	pushl  0x4(%ebx)
c0103242:	e8 87 05 00 00       	call   c01037ce <wchan_wakeone>

    spinlock_release(&sem->sem_lock);
c0103247:	83 c4 10             	add    $0x10,%esp
c010324a:	89 75 08             	mov    %esi,0x8(%ebp)
}
c010324d:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0103250:	5b                   	pop    %ebx
c0103251:	5e                   	pop    %esi
c0103252:	5d                   	pop    %ebp

    sem->sem_count++;
    assert(sem->sem_count > 0);
    wchan_wakeone(sem->sem_wchan, &sem->sem_lock);

    spinlock_release(&sem->sem_lock);
c0103253:	e9 47 01 00 00       	jmp    c010339f <spinlock_release>

c0103258 <spinlock_held>:
#include <thread.h>

struct spinlock kernel_spinlock = {0};

bool
spinlock_held(struct spinlock* lk) {
c0103258:	55                   	push   %ebp
c0103259:	89 e5                	mov    %esp,%ebp
c010325b:	53                   	push   %ebx
c010325c:	50                   	push   %eax
c010325d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lk != NULL);
c0103260:	85 db                	test   %ebx,%ebx
c0103262:	75 28                	jne    c010328c <spinlock_held+0x34>
c0103264:	83 ec 0c             	sub    $0xc,%esp
c0103267:	68 e0 b8 10 c0       	push   $0xc010b8e0
c010326c:	6a 0b                	push   $0xb
c010326e:	68 fe b7 10 c0       	push   $0xc010b7fe
c0103273:	68 0f b8 10 c0       	push   $0xc010b80f
c0103278:	68 95 a9 10 c0       	push   $0xc010a995
c010327d:	e8 42 0b 00 00       	call   c0103dc4 <print>
c0103282:	83 c4 20             	add    $0x20,%esp
c0103285:	e8 c0 db ff ff       	call   c0100e4a <backtrace>
c010328a:	fa                   	cli    
c010328b:	f4                   	hlt    
    return lk->locked && lk->cpu == thiscpu;
c010328c:	8b 13                	mov    (%ebx),%edx
c010328e:	31 c0                	xor    %eax,%eax
c0103290:	85 d2                	test   %edx,%edx
c0103292:	74 15                	je     c01032a9 <spinlock_held+0x51>
c0103294:	8b 5b 04             	mov    0x4(%ebx),%ebx
c0103297:	e8 a6 f2 ff ff       	call   c0102542 <cpunum>
c010329c:	39 1c 85 a0 6e 13 c0 	cmp    %ebx,-0x3fec9160(,%eax,4)
c01032a3:	0f 94 c0             	sete   %al
c01032a6:	0f b6 c0             	movzbl %al,%eax
c01032a9:	83 e0 01             	and    $0x1,%eax
}
c01032ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01032af:	c9                   	leave  
c01032b0:	c3                   	ret    

c01032b1 <spinlock_init>:

void
spinlock_init(struct spinlock* lk) {
c01032b1:	55                   	push   %ebp
c01032b2:	89 e5                	mov    %esp,%ebp
c01032b4:	53                   	push   %ebx
c01032b5:	50                   	push   %eax
c01032b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lk != NULL);
c01032b9:	85 db                	test   %ebx,%ebx
c01032bb:	75 28                	jne    c01032e5 <spinlock_init+0x34>
c01032bd:	83 ec 0c             	sub    $0xc,%esp
c01032c0:	68 d0 b8 10 c0       	push   $0xc010b8d0
c01032c5:	6a 11                	push   $0x11
c01032c7:	68 fe b7 10 c0       	push   $0xc010b7fe
c01032cc:	68 0f b8 10 c0       	push   $0xc010b80f
c01032d1:	68 95 a9 10 c0       	push   $0xc010a995
c01032d6:	e8 e9 0a 00 00       	call   c0103dc4 <print>
c01032db:	83 c4 20             	add    $0x20,%esp
c01032de:	e8 67 db ff ff       	call   c0100e4a <backtrace>
c01032e3:	fa                   	cli    
c01032e4:	f4                   	hlt    

    lk->locked = 0;
c01032e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->cpu = NULL;
c01032eb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
c01032f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01032f5:	c9                   	leave  
c01032f6:	c3                   	ret    

c01032f7 <spinlock_acquire>:

void
spinlock_acquire(struct spinlock* lk) {
c01032f7:	55                   	push   %ebp
c01032f8:	89 e5                	mov    %esp,%ebp
c01032fa:	53                   	push   %ebx
c01032fb:	52                   	push   %edx
c01032fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lk != NULL);
c01032ff:	85 db                	test   %ebx,%ebx
c0103301:	75 28                	jne    c010332b <spinlock_acquire+0x34>
c0103303:	83 ec 0c             	sub    $0xc,%esp
c0103306:	68 bc b8 10 c0       	push   $0xc010b8bc
c010330b:	6a 19                	push   $0x19
c010330d:	68 fe b7 10 c0       	push   $0xc010b7fe
c0103312:	68 0f b8 10 c0       	push   $0xc010b80f
c0103317:	68 95 a9 10 c0       	push   $0xc010a995
c010331c:	e8 a3 0a 00 00       	call   c0103dc4 <print>
c0103321:	83 c4 20             	add    $0x20,%esp
c0103324:	e8 21 db ff ff       	call   c0100e4a <backtrace>
c0103329:	fa                   	cli    
c010332a:	f4                   	hlt    
    assert(!spinlock_held(lk));
c010332b:	83 ec 0c             	sub    $0xc,%esp
c010332e:	53                   	push   %ebx
c010332f:	e8 24 ff ff ff       	call   c0103258 <spinlock_held>
c0103334:	83 c4 10             	add    $0x10,%esp
c0103337:	84 c0                	test   %al,%al
c0103339:	74 28                	je     c0103363 <spinlock_acquire+0x6c>
c010333b:	83 ec 0c             	sub    $0xc,%esp
c010333e:	68 bc b8 10 c0       	push   $0xc010b8bc
c0103343:	6a 1a                	push   $0x1a
c0103345:	68 fe b7 10 c0       	push   $0xc010b7fe
c010334a:	68 1a b8 10 c0       	push   $0xc010b81a
c010334f:	68 95 a9 10 c0       	push   $0xc010a995
c0103354:	e8 6b 0a 00 00       	call   c0103dc4 <print>
c0103359:	83 c4 20             	add    $0x20,%esp
c010335c:	e8 e9 da ff ff       	call   c0100e4a <backtrace>
c0103361:	fa                   	cli    
c0103362:	f4                   	hlt    
c0103363:	fa                   	cli    
static inline uint32_t
xchg(volatile uint32_t* addr, uint32_t newval) {
    uint32_t result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile("lock; xchgl %0, %1"
c0103364:	ba 01 00 00 00       	mov    $0x1,%edx
c0103369:	89 d0                	mov    %edx,%eax
c010336b:	f0 87 03             	lock xchg %eax,(%ebx)

    cli();
    while (xchg(&lk->locked, 1) != 0) {
c010336e:	85 c0                	test   %eax,%eax
c0103370:	74 06                	je     c0103378 <spinlock_acquire+0x81>
    asm volatile ("cli");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0103372:	fb                   	sti    
        sti();
        asm volatile ("pause");
c0103373:	f3 90                	pause  

#endif // _TYPES_

static inline void
cli(void) {
    asm volatile ("cli");
c0103375:	fa                   	cli    
c0103376:	eb f1                	jmp    c0103369 <spinlock_acquire+0x72>
        cli();
    }

    lk->cpu = thiscpu;
c0103378:	e8 c5 f1 ff ff       	call   c0102542 <cpunum>
c010337d:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0103384:	89 43 04             	mov    %eax,0x4(%ebx)
    lk->cpu->spinlocks++;
c0103387:	ff 40 0c             	incl   0xc(%eax)

    print(" >>> Locked %08p\n", lk);
c010338a:	50                   	push   %eax
c010338b:	50                   	push   %eax
c010338c:	53                   	push   %ebx
c010338d:	68 2d b8 10 c0       	push   $0xc010b82d
c0103392:	e8 2d 0a 00 00       	call   c0103dc4 <print>
}
c0103397:	83 c4 10             	add    $0x10,%esp
c010339a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010339d:	c9                   	leave  
c010339e:	c3                   	ret    

c010339f <spinlock_release>:

void
spinlock_release(struct spinlock* lk) {
c010339f:	55                   	push   %ebp
c01033a0:	89 e5                	mov    %esp,%ebp
c01033a2:	53                   	push   %ebx
c01033a3:	52                   	push   %edx
c01033a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lk != NULL);
c01033a7:	85 db                	test   %ebx,%ebx
c01033a9:	75 28                	jne    c01033d3 <spinlock_release+0x34>
c01033ab:	83 ec 0c             	sub    $0xc,%esp
c01033ae:	68 a8 b8 10 c0       	push   $0xc010b8a8
c01033b3:	6a 2b                	push   $0x2b
c01033b5:	68 fe b7 10 c0       	push   $0xc010b7fe
c01033ba:	68 0f b8 10 c0       	push   $0xc010b80f
c01033bf:	68 95 a9 10 c0       	push   $0xc010a995
c01033c4:	e8 fb 09 00 00       	call   c0103dc4 <print>
c01033c9:	83 c4 20             	add    $0x20,%esp
c01033cc:	e8 79 da ff ff       	call   c0100e4a <backtrace>
c01033d1:	fa                   	cli    
c01033d2:	f4                   	hlt    
    assert(spinlock_held(lk));
c01033d3:	83 ec 0c             	sub    $0xc,%esp
c01033d6:	53                   	push   %ebx
c01033d7:	e8 7c fe ff ff       	call   c0103258 <spinlock_held>
c01033dc:	83 c4 10             	add    $0x10,%esp
c01033df:	84 c0                	test   %al,%al
c01033e1:	75 28                	jne    c010340b <spinlock_release+0x6c>
c01033e3:	83 ec 0c             	sub    $0xc,%esp
c01033e6:	68 a8 b8 10 c0       	push   $0xc010b8a8
c01033eb:	6a 2c                	push   $0x2c
c01033ed:	68 fe b7 10 c0       	push   $0xc010b7fe
c01033f2:	68 1b b8 10 c0       	push   $0xc010b81b
c01033f7:	68 95 a9 10 c0       	push   $0xc010a995
c01033fc:	e8 c3 09 00 00       	call   c0103dc4 <print>
c0103401:	83 c4 20             	add    $0x20,%esp
c0103404:	e8 41 da ff ff       	call   c0100e4a <backtrace>
c0103409:	fa                   	cli    
c010340a:	f4                   	hlt    

    lk->cpu->spinlocks--;
c010340b:	8b 43 04             	mov    0x4(%ebx),%eax
c010340e:	ff 48 0c             	decl   0xc(%eax)
    lk->cpu = NULL;
c0103411:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
static inline uint32_t
xchg(volatile uint32_t* addr, uint32_t newval) {
    uint32_t result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile("lock; xchgl %0, %1"
c0103418:	31 c0                	xor    %eax,%eax
c010341a:	f0 87 03             	lock xchg %eax,(%ebx)
    asm volatile ("cli");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010341d:	fb                   	sti    

    xchg(&lk->locked, 0);
    sti();

    print(" >>> Unlocked %08p\n", lk);
c010341e:	50                   	push   %eax
c010341f:	50                   	push   %eax
c0103420:	53                   	push   %ebx
c0103421:	68 3f b8 10 c0       	push   $0xc010b83f
c0103426:	e8 99 09 00 00       	call   c0103dc4 <print>

    if (thiscpu->spinlocks == 0)
c010342b:	e8 12 f1 ff ff       	call   c0102542 <cpunum>
c0103430:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0103437:	83 c4 10             	add    $0x10,%esp
c010343a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
c010343e:	75 10                	jne    c0103450 <spinlock_release+0xb1>
        print("-------------------------------------------------------------\n");
c0103440:	c7 45 08 53 b8 10 c0 	movl   $0xc010b853,0x8(%ebp)
}
c0103447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010344a:	c9                   	leave  
    sti();

    print(" >>> Unlocked %08p\n", lk);

    if (thiscpu->spinlocks == 0)
        print("-------------------------------------------------------------\n");
c010344b:	e9 74 09 00 00       	jmp    c0103dc4 <print>
}
c0103450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103453:	c9                   	leave  
c0103454:	c3                   	ret    

c0103455 <spinlock_cleanup>:


void
spinlock_cleanup(struct spinlock* lk) {
c0103455:	55                   	push   %ebp
c0103456:	89 e5                	mov    %esp,%ebp
c0103458:	53                   	push   %ebx
c0103459:	50                   	push   %eax
c010345a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lk != NULL);
c010345d:	85 db                	test   %ebx,%ebx
c010345f:	75 28                	jne    c0103489 <spinlock_cleanup+0x34>
c0103461:	83 ec 0c             	sub    $0xc,%esp
c0103464:	68 94 b8 10 c0       	push   $0xc010b894
c0103469:	6a 3d                	push   $0x3d
c010346b:	68 fe b7 10 c0       	push   $0xc010b7fe
c0103470:	68 0f b8 10 c0       	push   $0xc010b80f
c0103475:	68 95 a9 10 c0       	push   $0xc010a995
c010347a:	e8 45 09 00 00       	call   c0103dc4 <print>
c010347f:	83 c4 20             	add    $0x20,%esp
c0103482:	e8 c3 d9 ff ff       	call   c0100e4a <backtrace>
c0103487:	fa                   	cli    
c0103488:	f4                   	hlt    
    assert(!spinlock_held(lk));
c0103489:	83 ec 0c             	sub    $0xc,%esp
c010348c:	53                   	push   %ebx
c010348d:	e8 c6 fd ff ff       	call   c0103258 <spinlock_held>
c0103492:	83 c4 10             	add    $0x10,%esp
c0103495:	84 c0                	test   %al,%al
c0103497:	74 28                	je     c01034c1 <spinlock_cleanup+0x6c>
c0103499:	83 ec 0c             	sub    $0xc,%esp
c010349c:	68 94 b8 10 c0       	push   $0xc010b894
c01034a1:	6a 3e                	push   $0x3e
c01034a3:	68 fe b7 10 c0       	push   $0xc010b7fe
c01034a8:	68 1a b8 10 c0       	push   $0xc010b81a
c01034ad:	68 95 a9 10 c0       	push   $0xc010a995
c01034b2:	e8 0d 09 00 00       	call   c0103dc4 <print>
c01034b7:	83 c4 20             	add    $0x20,%esp
c01034ba:	e8 8b d9 ff ff       	call   c0100e4a <backtrace>
c01034bf:	fa                   	cli    
c01034c0:	f4                   	hlt    

    lk->locked = 0;
c01034c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->cpu = NULL;
c01034c7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
c01034ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01034d1:	c9                   	leave  
c01034d2:	c3                   	ret    

c01034d3 <wchanarray_create>:
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
c01034d3:	55                   	push   %ebp
c01034d4:	89 e5                	mov    %esp,%ebp
c01034d6:	83 ec 24             	sub    $0x24,%esp
c01034d9:	6a 0c                	push   $0xc
c01034db:	e8 c5 e3 ff ff       	call   c01018a5 <kmalloc>
c01034e0:	83 c4 10             	add    $0x10,%esp
c01034e3:	85 c0                	test   %eax,%eax
c01034e5:	74 12                	je     c01034f9 <wchanarray_create+0x26>
c01034e7:	83 ec 0c             	sub    $0xc,%esp
c01034ea:	50                   	push   %eax
c01034eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034ee:	e8 e9 10 00 00       	call   c01045dc <array_init>
c01034f3:	83 c4 10             	add    $0x10,%esp
c01034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f9:	c9                   	leave  
c01034fa:	c3                   	ret    

c01034fb <wchanarray_destroy>:
c01034fb:	55                   	push   %ebp
c01034fc:	89 e5                	mov    %esp,%ebp
c01034fe:	53                   	push   %ebx
c01034ff:	83 ec 10             	sub    $0x10,%esp
c0103502:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103505:	53                   	push   %ebx
c0103506:	e8 ed 10 00 00       	call   c01045f8 <array_cleanup>
c010350b:	83 c4 10             	add    $0x10,%esp
c010350e:	89 5d 08             	mov    %ebx,0x8(%ebp)
c0103511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103514:	c9                   	leave  
c0103515:	e9 57 e4 ff ff       	jmp    c0101971 <kfree>

c010351a <wchanarray_init>:
c010351a:	55                   	push   %ebp
c010351b:	89 e5                	mov    %esp,%ebp
c010351d:	5d                   	pop    %ebp
c010351e:	e9 b9 10 00 00       	jmp    c01045dc <array_init>

c0103523 <wchanarray_cleanup>:
c0103523:	55                   	push   %ebp
c0103524:	89 e5                	mov    %esp,%ebp
c0103526:	5d                   	pop    %ebp
c0103527:	e9 cc 10 00 00       	jmp    c01045f8 <array_cleanup>

c010352c <wchanarray_num>:
c010352c:	55                   	push   %ebp
c010352d:	89 e5                	mov    %esp,%ebp
c010352f:	5d                   	pop    %ebp
c0103530:	e9 e7 0f 00 00       	jmp    c010451c <array_num>

c0103535 <wchanarray_get>:
c0103535:	55                   	push   %ebp
c0103536:	89 e5                	mov    %esp,%ebp
c0103538:	5d                   	pop    %ebp
c0103539:	e9 e9 0f 00 00       	jmp    c0104527 <array_get>

c010353e <wchanarray_set>:
c010353e:	55                   	push   %ebp
c010353f:	89 e5                	mov    %esp,%ebp
c0103541:	5d                   	pop    %ebp
c0103542:	e9 24 10 00 00       	jmp    c010456b <array_set>

c0103547 <wchanarray_setsize>:
c0103547:	55                   	push   %ebp
c0103548:	89 e5                	mov    %esp,%ebp
c010354a:	5d                   	pop    %ebp
c010354b:	e9 15 11 00 00       	jmp    c0104665 <array_setsize>

c0103550 <wchanarray_add>:
c0103550:	55                   	push   %ebp
c0103551:	89 e5                	mov    %esp,%ebp
c0103553:	5d                   	pop    %ebp
c0103554:	e9 82 11 00 00       	jmp    c01046db <array_add>

c0103559 <wchanarray_remove>:
c0103559:	55                   	push   %ebp
c010355a:	89 e5                	mov    %esp,%ebp
c010355c:	5d                   	pop    %ebp
c010355d:	e9 b2 11 00 00       	jmp    c0104714 <array_remove>

c0103562 <init_wchan>:
/*
 * Wait channel functions
 */

void
init_wchan(void) {
c0103562:	55                   	push   %ebp
c0103563:	89 e5                	mov    %esp,%ebp
c0103565:	83 ec 14             	sub    $0x14,%esp
    spinlock_init(&allwchans_lock);
c0103568:	68 90 69 13 c0       	push   $0xc0136990
c010356d:	e8 3f fd ff ff       	call   c01032b1 <spinlock_init>
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
c0103572:	c7 04 24 84 69 13 c0 	movl   $0xc0136984,(%esp)
c0103579:	e8 5e 10 00 00       	call   c01045dc <array_init>

void
init_wchan(void) {
    spinlock_init(&allwchans_lock);
    wchanarray_init(&allwchans);
}
c010357e:	83 c4 10             	add    $0x10,%esp
c0103581:	c9                   	leave  
c0103582:	c3                   	ret    

c0103583 <wchan_create>:
 * NAME should generally be a string constant. If it isn't, alternate
 * arrangements should be made to free it after the wait channel is
 * destroyed.
 */
struct wchan*
wchan_create(const char* name) {
c0103583:	55                   	push   %ebp
c0103584:	89 e5                	mov    %esp,%ebp
c0103586:	57                   	push   %edi
c0103587:	56                   	push   %esi
c0103588:	53                   	push   %ebx
c0103589:	83 ec 18             	sub    $0x18,%esp
    int result;

    struct wchan* wc = kmalloc(sizeof(struct wchan));
c010358c:	6a 24                	push   $0x24
c010358e:	e8 12 e3 ff ff       	call   c01018a5 <kmalloc>
c0103593:	89 c3                	mov    %eax,%ebx
    if (wc == NULL)
c0103595:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0103598:	31 c0                	xor    %eax,%eax
struct wchan*
wchan_create(const char* name) {
    int result;

    struct wchan* wc = kmalloc(sizeof(struct wchan));
    if (wc == NULL)
c010359a:	85 db                	test   %ebx,%ebx
c010359c:	0f 84 89 00 00 00    	je     c010362b <wchan_create+0xa8>
        return NULL;
    threadlist_init(&wc->wc_threads);
c01035a2:	8d 73 04             	lea    0x4(%ebx),%esi
c01035a5:	83 ec 0c             	sub    $0xc,%esp
c01035a8:	56                   	push   %esi
c01035a9:	e8 e9 42 00 00       	call   c0107897 <threadlist_init>
    wc->wc_name = name;
c01035ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01035b1:	89 03                	mov    %eax,(%ebx)

    /* add to allwchans[] */
    spinlock_acquire(&allwchans_lock);
c01035b3:	c7 04 24 90 69 13 c0 	movl   $0xc0136990,(%esp)
c01035ba:	e8 38 fd ff ff       	call   c01032f7 <spinlock_acquire>
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
c01035bf:	83 c4 0c             	add    $0xc,%esp
    threadlist_init(&wc->wc_threads);
    wc->wc_name = name;

    /* add to allwchans[] */
    spinlock_acquire(&allwchans_lock);
    result = wchanarray_add(&allwchans, wc, &wc->wc_index);
c01035c2:	8d 43 20             	lea    0x20(%ebx),%eax
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
c01035c5:	50                   	push   %eax
c01035c6:	53                   	push   %ebx
c01035c7:	68 84 69 13 c0       	push   $0xc0136984
c01035cc:	e8 0a 11 00 00       	call   c01046db <array_add>
c01035d1:	89 c7                	mov    %eax,%edi
    wc->wc_name = name;

    /* add to allwchans[] */
    spinlock_acquire(&allwchans_lock);
    result = wchanarray_add(&allwchans, wc, &wc->wc_index);
    spinlock_release(&allwchans_lock);
c01035d3:	c7 04 24 90 69 13 c0 	movl   $0xc0136990,(%esp)
c01035da:	e8 c0 fd ff ff       	call   c010339f <spinlock_release>
    if (result) {
c01035df:	83 c4 10             	add    $0x10,%esp
c01035e2:	89 d8                	mov    %ebx,%eax
c01035e4:	85 ff                	test   %edi,%edi
c01035e6:	74 43                	je     c010362b <wchan_create+0xa8>
        assert(result == ENOMEM);
c01035e8:	83 ff 02             	cmp    $0x2,%edi
c01035eb:	74 28                	je     c0103615 <wchan_create+0x92>
c01035ed:	83 ec 0c             	sub    $0xc,%esp
c01035f0:	68 bc b9 10 c0       	push   $0xc010b9bc
c01035f5:	6a 35                	push   $0x35
c01035f7:	68 ee b8 10 c0       	push   $0xc010b8ee
c01035fc:	68 fc b8 10 c0       	push   $0xc010b8fc
c0103601:	68 95 a9 10 c0       	push   $0xc010a995
c0103606:	e8 b9 07 00 00       	call   c0103dc4 <print>
c010360b:	83 c4 20             	add    $0x20,%esp
c010360e:	e8 37 d8 ff ff       	call   c0100e4a <backtrace>
c0103613:	fa                   	cli    
c0103614:	f4                   	hlt    
        threadlist_cleanup(&wc->wc_threads);
c0103615:	83 ec 0c             	sub    $0xc,%esp
c0103618:	56                   	push   %esi
c0103619:	e8 1d 43 00 00       	call   c010793b <threadlist_cleanup>
        kfree(wc);
c010361e:	89 1c 24             	mov    %ebx,(%esp)
c0103621:	e8 4b e3 ff ff       	call   c0101971 <kfree>
        return NULL;
c0103626:	83 c4 10             	add    $0x10,%esp
c0103629:	31 c0                	xor    %eax,%eax
    }

    return wc;
}
c010362b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010362e:	5b                   	pop    %ebx
c010362f:	5e                   	pop    %esi
c0103630:	5f                   	pop    %edi
c0103631:	5d                   	pop    %ebp
c0103632:	c3                   	ret    

c0103633 <wchan_destroy>:
/*
 * Destroy a wait channel. Must be empty and unlocked.
 * (The corresponding cleanup functions require this.)
 */
void
wchan_destroy(struct wchan* wc) {
c0103633:	55                   	push   %ebp
c0103634:	89 e5                	mov    %esp,%ebp
c0103636:	57                   	push   %edi
c0103637:	56                   	push   %esi
c0103638:	53                   	push   %ebx
c0103639:	83 ec 18             	sub    $0x18,%esp
c010363c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    unsigned num;
    struct wchan* wc2;

    /* remove from allwchans[] */
    spinlock_acquire(&allwchans_lock);
c010363f:	68 90 69 13 c0       	push   $0xc0136990
c0103644:	e8 ae fc ff ff       	call   c01032f7 <spinlock_acquire>
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
c0103649:	c7 04 24 84 69 13 c0 	movl   $0xc0136984,(%esp)
c0103650:	e8 c7 0e 00 00       	call   c010451c <array_num>
c0103655:	89 c6                	mov    %eax,%esi
c0103657:	59                   	pop    %ecx
c0103658:	5f                   	pop    %edi
c0103659:	ff 73 20             	pushl  0x20(%ebx)
c010365c:	68 84 69 13 c0       	push   $0xc0136984
c0103661:	e8 c1 0e 00 00       	call   c0104527 <array_get>
    struct wchan* wc2;

    /* remove from allwchans[] */
    spinlock_acquire(&allwchans_lock);
    num = wchanarray_num(&allwchans);
    assert(wchanarray_get(&allwchans, wc->wc_index) == wc);
c0103666:	83 c4 10             	add    $0x10,%esp
c0103669:	39 c3                	cmp    %eax,%ebx
c010366b:	74 28                	je     c0103695 <wchan_destroy+0x62>
c010366d:	83 ec 0c             	sub    $0xc,%esp
c0103670:	68 ac b9 10 c0       	push   $0xc010b9ac
c0103675:	6a 4a                	push   $0x4a
c0103677:	68 ee b8 10 c0       	push   $0xc010b8ee
c010367c:	68 0d b9 10 c0       	push   $0xc010b90d
c0103681:	68 95 a9 10 c0       	push   $0xc010a995
c0103686:	e8 39 07 00 00       	call   c0103dc4 <print>
c010368b:	83 c4 20             	add    $0x20,%esp
c010368e:	e8 b7 d7 ff ff       	call   c0100e4a <backtrace>
c0103693:	fa                   	cli    
c0103694:	f4                   	hlt    
    if (wc->wc_index < num - 1) {
c0103695:	4e                   	dec    %esi
c0103696:	39 73 20             	cmp    %esi,0x20(%ebx)
c0103699:	73 29                	jae    c01036c4 <wchan_destroy+0x91>
#include <err.h>
#include <array.h>
#include <syscall.h>

DECLARRAY(wchan);
DEFARRAY(wchan, /* no inline */ );
c010369b:	52                   	push   %edx
c010369c:	52                   	push   %edx
c010369d:	56                   	push   %esi
c010369e:	68 84 69 13 c0       	push   $0xc0136984
c01036a3:	e8 7f 0e 00 00       	call   c0104527 <array_get>
c01036a8:	89 c7                	mov    %eax,%edi
c01036aa:	83 c4 0c             	add    $0xc,%esp
c01036ad:	50                   	push   %eax
c01036ae:	ff 73 20             	pushl  0x20(%ebx)
c01036b1:	68 84 69 13 c0       	push   $0xc0136984
c01036b6:	e8 b0 0e 00 00       	call   c010456b <array_set>
    assert(wchanarray_get(&allwchans, wc->wc_index) == wc);
    if (wc->wc_index < num - 1) {
        /* move the last entry into our slot */
        wc2 = wchanarray_get(&allwchans, num - 1);
        wchanarray_set(&allwchans, wc->wc_index, wc2);
        wc2->wc_index = wc->wc_index;
c01036bb:	8b 43 20             	mov    0x20(%ebx),%eax
c01036be:	89 47 20             	mov    %eax,0x20(%edi)
c01036c1:	83 c4 10             	add    $0x10,%esp
    }
    wchanarray_setsize(&allwchans, num - 1);
c01036c4:	50                   	push   %eax
c01036c5:	50                   	push   %eax
c01036c6:	56                   	push   %esi
c01036c7:	68 84 69 13 c0       	push   $0xc0136984
c01036cc:	e8 76 fe ff ff       	call   c0103547 <wchanarray_setsize>
    spinlock_release(&allwchans_lock);
c01036d1:	c7 04 24 90 69 13 c0 	movl   $0xc0136990,(%esp)
c01036d8:	e8 c2 fc ff ff       	call   c010339f <spinlock_release>

    threadlist_cleanup(&wc->wc_threads);
c01036dd:	8d 43 04             	lea    0x4(%ebx),%eax
c01036e0:	89 04 24             	mov    %eax,(%esp)
c01036e3:	e8 53 42 00 00       	call   c010793b <threadlist_cleanup>
    kfree(wc);
c01036e8:	83 c4 10             	add    $0x10,%esp
c01036eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c01036ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01036f1:	5b                   	pop    %ebx
c01036f2:	5e                   	pop    %esi
c01036f3:	5f                   	pop    %edi
c01036f4:	5d                   	pop    %ebp
    }
    wchanarray_setsize(&allwchans, num - 1);
    spinlock_release(&allwchans_lock);

    threadlist_cleanup(&wc->wc_threads);
    kfree(wc);
c01036f5:	e9 77 e2 ff ff       	jmp    c0101971 <kfree>

c01036fa <wchan_sleep>:
 * the channel will make the thread runnable again. The spinlock must
 * be locked. The call to thread_switch unlocks it; we relock it
 * before returning.
 */
void
wchan_sleep(struct wchan* wc, struct spinlock* lk) {
c01036fa:	55                   	push   %ebp
c01036fb:	89 e5                	mov    %esp,%ebp
c01036fd:	56                   	push   %esi
c01036fe:	53                   	push   %ebx
c01036ff:	8b 75 08             	mov    0x8(%ebp),%esi
c0103702:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    /* may not sleep in an interrupt handler */
    assert(!thisthread->in_interrupt);
c0103705:	e8 38 ee ff ff       	call   c0102542 <cpunum>
c010370a:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0103711:	8b 40 08             	mov    0x8(%eax),%eax
c0103714:	80 78 2c 00          	cmpb   $0x0,0x2c(%eax)
c0103718:	74 28                	je     c0103742 <wchan_sleep+0x48>
c010371a:	83 ec 0c             	sub    $0xc,%esp
c010371d:	68 a0 b9 10 c0       	push   $0xc010b9a0
c0103722:	6a 62                	push   $0x62
c0103724:	68 ee b8 10 c0       	push   $0xc010b8ee
c0103729:	68 3c b9 10 c0       	push   $0xc010b93c
c010372e:	68 95 a9 10 c0       	push   $0xc010a995
c0103733:	e8 8c 06 00 00       	call   c0103dc4 <print>
c0103738:	83 c4 20             	add    $0x20,%esp
c010373b:	e8 0a d7 ff ff       	call   c0100e4a <backtrace>
c0103740:	fa                   	cli    
c0103741:	f4                   	hlt    

    /* must hold the spinlock */
    assert(spinlock_held(lk));
c0103742:	83 ec 0c             	sub    $0xc,%esp
c0103745:	53                   	push   %ebx
c0103746:	e8 0d fb ff ff       	call   c0103258 <spinlock_held>
c010374b:	83 c4 10             	add    $0x10,%esp
c010374e:	84 c0                	test   %al,%al
c0103750:	75 28                	jne    c010377a <wchan_sleep+0x80>
c0103752:	83 ec 0c             	sub    $0xc,%esp
c0103755:	68 a0 b9 10 c0       	push   $0xc010b9a0
c010375a:	6a 65                	push   $0x65
c010375c:	68 ee b8 10 c0       	push   $0xc010b8ee
c0103761:	68 1b b8 10 c0       	push   $0xc010b81b
c0103766:	68 95 a9 10 c0       	push   $0xc010a995
c010376b:	e8 54 06 00 00       	call   c0103dc4 <print>
c0103770:	83 c4 20             	add    $0x20,%esp
c0103773:	e8 d2 d6 ff ff       	call   c0100e4a <backtrace>
c0103778:	fa                   	cli    
c0103779:	f4                   	hlt    

    /* must not hold other spinlocks */
    assert(thiscpu->spinlocks == 1);
c010377a:	e8 c3 ed ff ff       	call   c0102542 <cpunum>
c010377f:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0103786:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
c010378a:	74 28                	je     c01037b4 <wchan_sleep+0xba>
c010378c:	83 ec 0c             	sub    $0xc,%esp
c010378f:	68 a0 b9 10 c0       	push   $0xc010b9a0
c0103794:	6a 68                	push   $0x68
c0103796:	68 ee b8 10 c0       	push   $0xc010b8ee
c010379b:	68 56 b9 10 c0       	push   $0xc010b956
c01037a0:	68 95 a9 10 c0       	push   $0xc010a995
c01037a5:	e8 1a 06 00 00       	call   c0103dc4 <print>
c01037aa:	83 c4 20             	add    $0x20,%esp
c01037ad:	e8 98 d6 ff ff       	call   c0100e4a <backtrace>
c01037b2:	fa                   	cli    
c01037b3:	f4                   	hlt    

    // thread_switch(S_SLEEP, wc, lk);
    sys_sleep(wc, lk);
c01037b4:	50                   	push   %eax
c01037b5:	50                   	push   %eax
c01037b6:	53                   	push   %ebx
c01037b7:	56                   	push   %esi
c01037b8:	e8 af d1 ff ff       	call   c010096c <sys_sleep>

    spinlock_acquire(lk);
c01037bd:	83 c4 10             	add    $0x10,%esp
c01037c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c01037c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01037c6:	5b                   	pop    %ebx
c01037c7:	5e                   	pop    %esi
c01037c8:	5d                   	pop    %ebp
    assert(thiscpu->spinlocks == 1);

    // thread_switch(S_SLEEP, wc, lk);
    sys_sleep(wc, lk);

    spinlock_acquire(lk);
c01037c9:	e9 29 fb ff ff       	jmp    c01032f7 <spinlock_acquire>

c01037ce <wchan_wakeone>:

/*
 * Wake up one thread sleeping on a wait channel.
 */
void
wchan_wakeone(struct wchan* wc, struct spinlock* lk) {
c01037ce:	55                   	push   %ebp
c01037cf:	89 e5                	mov    %esp,%ebp
c01037d1:	53                   	push   %ebx
c01037d2:	83 ec 10             	sub    $0x10,%esp
c01037d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct thread* target;

    assert(spinlock_held(lk));
c01037d8:	ff 75 0c             	pushl  0xc(%ebp)
c01037db:	e8 78 fa ff ff       	call   c0103258 <spinlock_held>
c01037e0:	83 c4 10             	add    $0x10,%esp
c01037e3:	84 c0                	test   %al,%al
c01037e5:	75 28                	jne    c010380f <wchan_wakeone+0x41>
c01037e7:	83 ec 0c             	sub    $0xc,%esp
c01037ea:	68 90 b9 10 c0       	push   $0xc010b990
c01037ef:	6a 77                	push   $0x77
c01037f1:	68 ee b8 10 c0       	push   $0xc010b8ee
c01037f6:	68 1b b8 10 c0       	push   $0xc010b81b
c01037fb:	68 95 a9 10 c0       	push   $0xc010a995
c0103800:	e8 bf 05 00 00       	call   c0103dc4 <print>
c0103805:	83 c4 20             	add    $0x20,%esp
c0103808:	e8 3d d6 ff ff       	call   c0100e4a <backtrace>
c010380d:	fa                   	cli    
c010380e:	f4                   	hlt    

    /* Grab a thread from the channel */
    target = threadlist_remhead(&wc->wc_threads);
c010380f:	83 ec 0c             	sub    $0xc,%esp
c0103812:	83 c3 04             	add    $0x4,%ebx
c0103815:	53                   	push   %ebx
c0103816:	e8 c6 43 00 00       	call   c0107be1 <threadlist_remhead>

    if (target == NULL) {
c010381b:	83 c4 10             	add    $0x10,%esp
c010381e:	85 c0                	test   %eax,%eax
c0103820:	74 13                	je     c0103835 <wchan_wakeone+0x67>
     * associated with wchans must come before the runqueue locks,
     * as we also bridge from the wchan lock to the runqueue lock
     * in thread_sleep.
     */

    thread_make_runnable(target, false);
c0103822:	c7 45 0c 00 00 00 00 	movl   $0x0,0xc(%ebp)
c0103829:	89 45 08             	mov    %eax,0x8(%ebp)
}
c010382c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010382f:	c9                   	leave  
     * associated with wchans must come before the runqueue locks,
     * as we also bridge from the wchan lock to the runqueue lock
     * in thread_sleep.
     */

    thread_make_runnable(target, false);
c0103830:	e9 9b 36 00 00       	jmp    c0106ed0 <thread_make_runnable>
}
c0103835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103838:	c9                   	leave  
c0103839:	c3                   	ret    

c010383a <wchan_wakeall>:

/*
 * Wake up all threads sleeping on a wait channel.
 */
void
wchan_wakeall(struct wchan* wc, struct spinlock* lk) {
c010383a:	55                   	push   %ebp
c010383b:	89 e5                	mov    %esp,%ebp
c010383d:	57                   	push   %edi
c010383e:	56                   	push   %esi
c010383f:	53                   	push   %ebx
c0103840:	83 ec 38             	sub    $0x38,%esp
    assert(spinlock_held(lk));
c0103843:	ff 75 0c             	pushl  0xc(%ebp)
c0103846:	e8 0d fa ff ff       	call   c0103258 <spinlock_held>
c010384b:	83 c4 10             	add    $0x10,%esp
c010384e:	84 c0                	test   %al,%al
c0103850:	75 2b                	jne    c010387d <wchan_wakeall+0x43>
c0103852:	83 ec 0c             	sub    $0xc,%esp
c0103855:	68 80 b9 10 c0       	push   $0xc010b980
c010385a:	68 91 00 00 00       	push   $0x91
c010385f:	68 ee b8 10 c0       	push   $0xc010b8ee
c0103864:	68 1b b8 10 c0       	push   $0xc010b81b
c0103869:	68 95 a9 10 c0       	push   $0xc010a995
c010386e:	e8 51 05 00 00       	call   c0103dc4 <print>
c0103873:	83 c4 20             	add    $0x20,%esp
c0103876:	e8 cf d5 ff ff       	call   c0100e4a <backtrace>
c010387b:	fa                   	cli    
c010387c:	f4                   	hlt    

    struct threadlist list = {0};
c010387d:	8d 7d cc             	lea    -0x34(%ebp),%edi
c0103880:	b9 07 00 00 00       	mov    $0x7,%ecx
c0103885:	31 c0                	xor    %eax,%eax
c0103887:	f3 ab                	rep stos %eax,%es:(%edi)
    threadlist_init(&list);
c0103889:	83 ec 0c             	sub    $0xc,%esp
c010388c:	8d 5d cc             	lea    -0x34(%ebp),%ebx
c010388f:	53                   	push   %ebx
c0103890:	e8 02 40 00 00       	call   c0107897 <threadlist_init>
    /*
     * Grab all the threads from the channel, moving them to a
     * private list.
     */
    struct thread* target = NULL;
    while ((target = threadlist_remhead(&wc->wc_threads)) != NULL)
c0103895:	83 c4 10             	add    $0x10,%esp
c0103898:	8b 45 08             	mov    0x8(%ebp),%eax
c010389b:	8d 70 04             	lea    0x4(%eax),%esi
c010389e:	83 ec 0c             	sub    $0xc,%esp
c01038a1:	56                   	push   %esi
c01038a2:	e8 3a 43 00 00       	call   c0107be1 <threadlist_remhead>
c01038a7:	83 c4 10             	add    $0x10,%esp
c01038aa:	85 c0                	test   %eax,%eax
c01038ac:	74 0e                	je     c01038bc <wchan_wakeall+0x82>
        threadlist_addtail(&list, target);
c01038ae:	51                   	push   %ecx
c01038af:	51                   	push   %ecx
c01038b0:	50                   	push   %eax
c01038b1:	53                   	push   %ebx
c01038b2:	e8 ad 42 00 00       	call   c0107b64 <threadlist_addtail>
c01038b7:	83 c4 10             	add    $0x10,%esp
c01038ba:	eb e2                	jmp    c010389e <wchan_wakeall+0x64>
    /*
     * We could conceivably sort by cpu first to cause fewer lock
     * ops and fewer IPIs, but for now at least don't bother. Just
     * make each thread runnable.
     */
    while ((target = threadlist_remhead(&list)) != NULL)
c01038bc:	83 ec 0c             	sub    $0xc,%esp
c01038bf:	53                   	push   %ebx
c01038c0:	e8 1c 43 00 00       	call   c0107be1 <threadlist_remhead>
c01038c5:	83 c4 10             	add    $0x10,%esp
c01038c8:	85 c0                	test   %eax,%eax
c01038ca:	74 0f                	je     c01038db <wchan_wakeall+0xa1>
        thread_make_runnable(target, false);
c01038cc:	52                   	push   %edx
c01038cd:	52                   	push   %edx
c01038ce:	6a 00                	push   $0x0
c01038d0:	50                   	push   %eax
c01038d1:	e8 fa 35 00 00       	call   c0106ed0 <thread_make_runnable>
c01038d6:	83 c4 10             	add    $0x10,%esp
c01038d9:	eb e1                	jmp    c01038bc <wchan_wakeall+0x82>

    threadlist_cleanup(&list);
c01038db:	83 ec 0c             	sub    $0xc,%esp
c01038de:	53                   	push   %ebx
c01038df:	e8 57 40 00 00       	call   c010793b <threadlist_cleanup>
}
c01038e4:	83 c4 10             	add    $0x10,%esp
c01038e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01038ea:	5b                   	pop    %ebx
c01038eb:	5e                   	pop    %esi
c01038ec:	5f                   	pop    %edi
c01038ed:	5d                   	pop    %ebp
c01038ee:	c3                   	ret    

c01038ef <wchan_isempty>:
/*
 * Return nonzero if there are no threads sleeping on the channel.
 * This is meant to be used only for diagnostic purposes.
 */
bool
wchan_isempty(struct wchan* wc, struct spinlock* lk) {
c01038ef:	55                   	push   %ebp
c01038f0:	89 e5                	mov    %esp,%ebp
c01038f2:	53                   	push   %ebx
c01038f3:	83 ec 10             	sub    $0x10,%esp
c01038f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bool ret;

    assert(spinlock_held(lk));
c01038f9:	ff 75 0c             	pushl  0xc(%ebp)
c01038fc:	e8 57 f9 ff ff       	call   c0103258 <spinlock_held>
c0103901:	83 c4 10             	add    $0x10,%esp
c0103904:	84 c0                	test   %al,%al
c0103906:	75 2b                	jne    c0103933 <wchan_isempty+0x44>
c0103908:	83 ec 0c             	sub    $0xc,%esp
c010390b:	68 70 b9 10 c0       	push   $0xc010b970
c0103910:	68 b1 00 00 00       	push   $0xb1
c0103915:	68 ee b8 10 c0       	push   $0xc010b8ee
c010391a:	68 1b b8 10 c0       	push   $0xc010b81b
c010391f:	68 95 a9 10 c0       	push   $0xc010a995
c0103924:	e8 9b 04 00 00       	call   c0103dc4 <print>
c0103929:	83 c4 20             	add    $0x20,%esp
c010392c:	e8 19 d5 ff ff       	call   c0100e4a <backtrace>
c0103931:	fa                   	cli    
c0103932:	f4                   	hlt    
    ret = threadlist_isempty(&wc->wc_threads);
c0103933:	83 c3 04             	add    $0x4,%ebx
c0103936:	89 5d 08             	mov    %ebx,0x8(%ebp)

    return ret;
}
c0103939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010393c:	c9                   	leave  
bool
wchan_isempty(struct wchan* wc, struct spinlock* lk) {
    bool ret;

    assert(spinlock_held(lk));
    ret = threadlist_isempty(&wc->wc_threads);
c010393d:	e9 b9 3f 00 00       	jmp    c01078fb <threadlist_isempty>

c0103942 <_panic>:
#include <lib.h>
#include <x86.h>

void
_panic(const char* file, int line, const char* func, const char* fmt, ...) {
c0103942:	55                   	push   %ebp
c0103943:	89 e5                	mov    %esp,%ebp
c0103945:	56                   	push   %esi
c0103946:	53                   	push   %ebx
c0103947:	8b 5d 14             	mov    0x14(%ebp),%ebx
    static volatile const char* panicstr;

    if (panicstr ==  NULL) {
c010394a:	83 3d 98 69 13 c0 00 	cmpl   $0x0,0xc0136998
c0103951:	75 35                	jne    c0103988 <_panic+0x46>
        panicstr = fmt;
c0103953:	89 1d 98 69 13 c0    	mov    %ebx,0xc0136998

#endif // _TYPES_

static inline void
cli(void) {
    asm volatile ("cli");
c0103959:	fa                   	cli    

        cli();

        va_list ap;
        va_start(ap, fmt);
c010395a:	8d 75 18             	lea    0x18(%ebp),%esi
        print("\n\t>>> panic at %s:%d in %s: ", file, line, func);
c010395d:	ff 75 10             	pushl  0x10(%ebp)
c0103960:	ff 75 0c             	pushl  0xc(%ebp)
c0103963:	ff 75 08             	pushl  0x8(%ebp)
c0103966:	68 c9 b9 10 c0       	push   $0xc010b9c9
c010396b:	e8 54 04 00 00       	call   c0103dc4 <print>
        vcprintf(fmt, ap);
c0103970:	58                   	pop    %eax
c0103971:	5a                   	pop    %edx
c0103972:	56                   	push   %esi
c0103973:	53                   	push   %ebx
c0103974:	e8 30 04 00 00       	call   c0103da9 <vcprintf>
        print("\n");
c0103979:	c7 04 24 c9 ae 10 c0 	movl   $0xc010aec9,(%esp)
c0103980:	e8 3f 04 00 00       	call   c0103dc4 <print>
        va_end(ap);
c0103985:	83 c4 10             	add    $0x10,%esp
    asm volatile ("sti");
}

static inline void
hlt(void) {
    asm volatile ("hlt");
c0103988:	f4                   	hlt    
c0103989:	eb fd                	jmp    c0103988 <_panic+0x46>

c010398b <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putc function and associated pointer putdat.
 */
static void
printnum(void (*putc)(int),
         unsigned long long num, unsigned base, int width, int padc) {
c010398b:	55                   	push   %ebp
c010398c:	89 e5                	mov    %esp,%ebp
c010398e:	57                   	push   %edi
c010398f:	56                   	push   %esi
c0103990:	53                   	push   %ebx
c0103991:	83 ec 2c             	sub    $0x2c,%esp
c0103994:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103997:	89 d6                	mov    %edx,%esi
c0103999:	89 cf                	mov    %ecx,%edi
c010399b:	8b 4d 08             	mov    0x8(%ebp),%ecx
c010399e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c01039a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01039a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    // first recursively print all preceding (more significant) digits
    if (num >= base)
c01039a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
c01039aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01039b1:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
c01039b4:	72 06                	jb     c01039bc <printnum+0x31>
c01039b6:	77 31                	ja     c01039e9 <printnum+0x5e>
c01039b8:	39 d1                	cmp    %edx,%ecx
c01039ba:	77 2d                	ja     c01039e9 <printnum+0x5e>
c01039bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        printnum(putc, num / base, base, width - 1, padc);
c01039bf:	ff 75 e4             	pushl  -0x1c(%ebp)
c01039c2:	ff 75 e0             	pushl  -0x20(%ebp)
c01039c5:	57                   	push   %edi
c01039c6:	56                   	push   %esi
c01039c7:	e8 38 6d 00 00       	call   c010a704 <__udivdi3>
c01039cc:	83 c4 0c             	add    $0xc,%esp
c01039cf:	ff 75 d8             	pushl  -0x28(%ebp)
c01039d2:	4b                   	dec    %ebx
c01039d3:	53                   	push   %ebx
c01039d4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01039d7:	51                   	push   %ecx
c01039d8:	89 d1                	mov    %edx,%ecx
c01039da:	89 c2                	mov    %eax,%edx
c01039dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039df:	e8 a7 ff ff ff       	call   c010398b <printnum>
c01039e4:	83 c4 10             	add    $0x10,%esp
c01039e7:	eb 15                	jmp    c01039fe <printnum+0x73>
    // print any needed pad characters before first digit
    else
        while (--width > 0)
c01039e9:	4b                   	dec    %ebx
c01039ea:	85 db                	test   %ebx,%ebx
c01039ec:	7e 10                	jle    c01039fe <printnum+0x73>
            putc(padc);
c01039ee:	83 ec 0c             	sub    $0xc,%esp
c01039f1:	ff 75 d8             	pushl  -0x28(%ebp)
c01039f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039f7:	ff d0                	call   *%eax
c01039f9:	83 c4 10             	add    $0x10,%esp
c01039fc:	eb eb                	jmp    c01039e9 <printnum+0x5e>

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
c01039fe:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a01:	ff 75 e0             	pushl  -0x20(%ebp)
c0103a04:	57                   	push   %edi
c0103a05:	56                   	push   %esi
c0103a06:	e8 09 6e 00 00       	call   c010a814 <__umoddi3>
c0103a0b:	83 c4 10             	add    $0x10,%esp
c0103a0e:	0f be 80 e6 b9 10 c0 	movsbl -0x3fef461a(%eax),%eax
c0103a15:	89 45 08             	mov    %eax,0x8(%ebp)
c0103a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
c0103a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103a1e:	5b                   	pop    %ebx
c0103a1f:	5e                   	pop    %esi
c0103a20:	5f                   	pop    %edi
c0103a21:	5d                   	pop    %ebp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
c0103a22:	ff e0                	jmp    *%eax

c0103a24 <getuint>:
}

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
c0103a24:	55                   	push   %ebp
c0103a25:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c0103a27:	83 fa 01             	cmp    $0x1,%edx
c0103a2a:	8b 08                	mov    (%eax),%ecx
c0103a2c:	7e 0c                	jle    c0103a3a <getuint+0x16>
        return va_arg(*ap, unsigned long long);
c0103a2e:	8d 51 08             	lea    0x8(%ecx),%edx
c0103a31:	89 10                	mov    %edx,(%eax)
c0103a33:	8b 01                	mov    (%ecx),%eax
c0103a35:	8b 51 04             	mov    0x4(%ecx),%edx
c0103a38:	eb 09                	jmp    c0103a43 <getuint+0x1f>
    else if (lflag)
        return va_arg(*ap, unsigned long);
c0103a3a:	8d 51 04             	lea    0x4(%ecx),%edx
c0103a3d:	89 10                	mov    %edx,(%eax)
c0103a3f:	8b 01                	mov    (%ecx),%eax
c0103a41:	31 d2                	xor    %edx,%edx
    else
        return va_arg(*ap, unsigned int);
}
c0103a43:	5d                   	pop    %ebp
c0103a44:	c3                   	ret    

c0103a45 <vprintfmt>:

// Main function to format and print a string.
void printfmt(void (*putc)(int), const char* fmt, ...);

void
vprintfmt(void (*putc)(int), const char* fmt, va_list ap) {
c0103a45:	55                   	push   %ebp
c0103a46:	89 e5                	mov    %esp,%ebp
c0103a48:	57                   	push   %edi
c0103a49:	56                   	push   %esi
c0103a4a:	53                   	push   %ebx
c0103a4b:	83 ec 2c             	sub    $0x2c,%esp
c0103a4e:	8b 75 0c             	mov    0xc(%ebp),%esi
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
c0103a51:	46                   	inc    %esi
c0103a52:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
c0103a56:	83 f8 25             	cmp    $0x25,%eax
c0103a59:	74 14                	je     c0103a6f <vprintfmt+0x2a>
            if (ch == '\0')
c0103a5b:	85 c0                	test   %eax,%eax
c0103a5d:	0f 84 3e 03 00 00    	je     c0103da1 <vprintfmt+0x35c>
                return;
            putc(ch);
c0103a63:	83 ec 0c             	sub    $0xc,%esp
c0103a66:	50                   	push   %eax
c0103a67:	ff 55 08             	call   *0x8(%ebp)
c0103a6a:	83 c4 10             	add    $0x10,%esp
c0103a6d:	eb e2                	jmp    c0103a51 <vprintfmt+0xc>
c0103a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
c0103a72:	31 db                	xor    %ebx,%ebx
c0103a74:	c6 45 d7 20          	movb   $0x20,-0x29(%ebp)
c0103a78:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
c0103a7f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
c0103a86:	83 cf ff             	or     $0xffffffff,%edi
c0103a89:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
c0103a90:	8d 46 01             	lea    0x1(%esi),%eax
c0103a93:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103a96:	0f b6 16             	movzbl (%esi),%edx
c0103a99:	80 fa 39             	cmp    $0x39,%dl
c0103a9c:	77 67                	ja     c0103b05 <vprintfmt+0xc0>
c0103a9e:	80 fa 31             	cmp    $0x31,%dl
c0103aa1:	0f 83 b6 00 00 00    	jae    c0103b5d <vprintfmt+0x118>
c0103aa7:	80 fa 2a             	cmp    $0x2a,%dl
c0103aaa:	74 2d                	je     c0103ad9 <vprintfmt+0x94>
c0103aac:	77 17                	ja     c0103ac5 <vprintfmt+0x80>
c0103aae:	80 fa 23             	cmp    $0x23,%dl
c0103ab1:	0f 84 e0 00 00 00    	je     c0103b97 <vprintfmt+0x152>
c0103ab7:	80 fa 25             	cmp    $0x25,%dl
c0103aba:	0f 84 a4 02 00 00    	je     c0103d64 <vprintfmt+0x31f>
c0103ac0:	e9 b5 02 00 00       	jmp    c0103d7a <vprintfmt+0x335>
c0103ac5:	80 fa 2e             	cmp    $0x2e,%dl
c0103ac8:	0f 84 ba 00 00 00    	je     c0103b88 <vprintfmt+0x143>
c0103ace:	80 fa 30             	cmp    $0x30,%dl
c0103ad1:	75 23                	jne    c0103af6 <vprintfmt+0xb1>
                padc = '-';
                goto reswitch;

            // flag to pad with 0's instead of spaces
            case '0':
                padc = '0';
c0103ad3:	c6 45 d7 30          	movb   $0x30,-0x29(%ebp)
c0103ad7:	eb 18                	jmp    c0103af1 <vprintfmt+0xac>
                        break;
                }
                goto process_precision;

            case '*':
                precision = va_arg(ap, int);
c0103ad9:	8b 01                	mov    (%ecx),%eax
c0103adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ade:	83 c1 04             	add    $0x4,%ecx
                goto process_precision;
c0103ae1:	b3 01                	mov    $0x1,%bl
            case '#':
                altflag = 1;
                goto reswitch;

process_precision:
                if (width < 0)
c0103ae3:	85 ff                	test   %edi,%edi
c0103ae5:	79 0a                	jns    c0103af1 <vprintfmt+0xac>
                    width = precision, precision = -1;
c0103ae7:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0103aea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
c0103af1:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103af4:	eb 9a                	jmp    c0103a90 <vprintfmt+0x4b>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
c0103af6:	80 fa 2d             	cmp    $0x2d,%dl
c0103af9:	0f 85 7b 02 00 00    	jne    c0103d7a <vprintfmt+0x335>

            // flag to pad on the right
            case '-':
                padc = '-';
c0103aff:	c6 45 d7 2d          	movb   $0x2d,-0x29(%ebp)
c0103b03:	eb ec                	jmp    c0103af1 <vprintfmt+0xac>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
c0103b05:	80 fa 6f             	cmp    $0x6f,%dl
c0103b08:	0f 84 e1 01 00 00    	je     c0103cef <vprintfmt+0x2aa>
c0103b0e:	77 1d                	ja     c0103b2d <vprintfmt+0xe8>
c0103b10:	80 fa 64             	cmp    $0x64,%dl
c0103b13:	0f 84 6a 01 00 00    	je     c0103c83 <vprintfmt+0x23e>
c0103b19:	80 fa 6c             	cmp    $0x6c,%dl
c0103b1c:	0f 84 81 00 00 00    	je     c0103ba3 <vprintfmt+0x15e>
c0103b22:	80 fa 63             	cmp    $0x63,%dl
c0103b25:	0f 85 4f 02 00 00    	jne    c0103d7a <vprintfmt+0x335>
c0103b2b:	eb 7e                	jmp    c0103bab <vprintfmt+0x166>
c0103b2d:	80 fa 73             	cmp    $0x73,%dl
c0103b30:	0f 84 8f 00 00 00    	je     c0103bc5 <vprintfmt+0x180>
c0103b36:	77 0e                	ja     c0103b46 <vprintfmt+0x101>
c0103b38:	80 fa 70             	cmp    $0x70,%dl
c0103b3b:	0f 84 cb 01 00 00    	je     c0103d0c <vprintfmt+0x2c7>
c0103b41:	e9 34 02 00 00       	jmp    c0103d7a <vprintfmt+0x335>
c0103b46:	80 fa 75             	cmp    $0x75,%dl
c0103b49:	0f 84 87 01 00 00    	je     c0103cd6 <vprintfmt+0x291>
c0103b4f:	80 fa 78             	cmp    $0x78,%dl
c0103b52:	0f 84 df 01 00 00    	je     c0103d37 <vprintfmt+0x2f2>
c0103b58:	e9 1d 02 00 00       	jmp    c0103d7a <vprintfmt+0x335>
c0103b5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
                    precision = precision * 10 + ch - '0';
c0103b64:	6b 45 e0 0a          	imul   $0xa,-0x20(%ebp),%eax
c0103b68:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
c0103b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
                    ch = *fmt;
c0103b6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b72:	0f be 00             	movsbl (%eax),%eax
c0103b75:	89 c2                	mov    %eax,%edx
                    if (ch < '0' || ch > '9')
c0103b77:	83 e8 30             	sub    $0x30,%eax
c0103b7a:	83 f8 09             	cmp    $0x9,%eax
c0103b7d:	0f 87 60 ff ff ff    	ja     c0103ae3 <vprintfmt+0x9e>
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
c0103b83:	ff 45 dc             	incl   -0x24(%ebp)
                    precision = precision * 10 + ch - '0';
                    ch = *fmt;
                    if (ch < '0' || ch > '9')
                        break;
                }
c0103b86:	eb dc                	jmp    c0103b64 <vprintfmt+0x11f>
c0103b88:	85 ff                	test   %edi,%edi
c0103b8a:	0f 89 61 ff ff ff    	jns    c0103af1 <vprintfmt+0xac>
c0103b90:	31 ff                	xor    %edi,%edi
c0103b92:	e9 5a ff ff ff       	jmp    c0103af1 <vprintfmt+0xac>
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
c0103b97:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
                goto reswitch;
c0103b9e:	e9 4e ff ff ff       	jmp    c0103af1 <vprintfmt+0xac>
                    width = precision, precision = -1;
                goto reswitch;

            // long flag (doubled for long long)
            case 'l':
                lflag++;
c0103ba3:	ff 45 d8             	incl   -0x28(%ebp)
                goto reswitch;
c0103ba6:	e9 46 ff ff ff       	jmp    c0103af1 <vprintfmt+0xac>
c0103bab:	84 db                	test   %bl,%bl
c0103bad:	74 03                	je     c0103bb2 <vprintfmt+0x16d>
c0103baf:	89 4d 10             	mov    %ecx,0x10(%ebp)

            // character
            case 'c':
                putc(va_arg(ap, int));
c0103bb2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103bb5:	8d 50 04             	lea    0x4(%eax),%edx
c0103bb8:	89 55 10             	mov    %edx,0x10(%ebp)
c0103bbb:	83 ec 0c             	sub    $0xc,%esp
c0103bbe:	ff 30                	pushl  (%eax)
c0103bc0:	e9 aa 01 00 00       	jmp    c0103d6f <vprintfmt+0x32a>
c0103bc5:	84 db                	test   %bl,%bl
c0103bc7:	74 03                	je     c0103bcc <vprintfmt+0x187>
c0103bc9:	89 4d 10             	mov    %ecx,0x10(%ebp)
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
c0103bcc:	8b 45 10             	mov    0x10(%ebp),%eax
c0103bcf:	8d 50 04             	lea    0x4(%eax),%edx
c0103bd2:	89 55 10             	mov    %edx,0x10(%ebp)
c0103bd5:	8b 18                	mov    (%eax),%ebx
c0103bd7:	85 db                	test   %ebx,%ebx
c0103bd9:	75 05                	jne    c0103be0 <vprintfmt+0x19b>
                    p = "(null)";
c0103bdb:	bb f7 b9 10 c0       	mov    $0xc010b9f7,%ebx
                if (width > 0 && padc != '-')
c0103be0:	80 7d d7 2d          	cmpb   $0x2d,-0x29(%ebp)
c0103be4:	74 3b                	je     c0103c21 <vprintfmt+0x1dc>
c0103be6:	85 ff                	test   %edi,%edi
c0103be8:	7e 37                	jle    c0103c21 <vprintfmt+0x1dc>
                    for (width -= strlen(p); width > 0; width--)
c0103bea:	83 ec 0c             	sub    $0xc,%esp
c0103bed:	53                   	push   %ebx
c0103bee:	e8 04 07 00 00       	call   c01042f7 <strlen>
c0103bf3:	29 c7                	sub    %eax,%edi
c0103bf5:	89 fe                	mov    %edi,%esi
c0103bf7:	83 c4 10             	add    $0x10,%esp
                        putc(padc);
c0103bfa:	0f be 45 d7          	movsbl -0x29(%ebp),%eax
            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
c0103bfe:	85 ff                	test   %edi,%edi
c0103c00:	7e 13                	jle    c0103c15 <vprintfmt+0x1d0>
                        putc(padc);
c0103c02:	83 ec 0c             	sub    $0xc,%esp
c0103c05:	50                   	push   %eax
c0103c06:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103c09:	ff 55 08             	call   *0x8(%ebp)
            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
c0103c0c:	4f                   	dec    %edi
c0103c0d:	83 c4 10             	add    $0x10,%esp
c0103c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c13:	eb e9                	jmp    c0103bfe <vprintfmt+0x1b9>
c0103c15:	89 f0                	mov    %esi,%eax
c0103c17:	85 f6                	test   %esi,%esi
c0103c19:	79 02                	jns    c0103c1d <vprintfmt+0x1d8>
c0103c1b:	31 c0                	xor    %eax,%eax
c0103c1d:	29 c6                	sub    %eax,%esi
c0103c1f:	89 f7                	mov    %esi,%edi
c0103c21:	89 de                	mov    %ebx,%esi
c0103c23:	89 f8                	mov    %edi,%eax
c0103c25:	29 f0                	sub    %esi,%eax
c0103c27:	8d 14 03             	lea    (%ebx,%eax,1),%edx
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0103c2a:	46                   	inc    %esi
c0103c2b:	0f be 46 ff          	movsbl -0x1(%esi),%eax
c0103c2f:	85 c0                	test   %eax,%eax
c0103c31:	74 44                	je     c0103c77 <vprintfmt+0x232>
c0103c33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103c37:	79 21                	jns    c0103c5a <vprintfmt+0x215>
                    if (altflag && (ch < ' ' || ch > '~'))
c0103c39:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103c3d:	74 0f                	je     c0103c4e <vprintfmt+0x209>
c0103c3f:	8d 50 e0             	lea    -0x20(%eax),%edx
c0103c42:	83 fa 5e             	cmp    $0x5e,%edx
c0103c45:	76 07                	jbe    c0103c4e <vprintfmt+0x209>
                        putc('?');
c0103c47:	83 ec 0c             	sub    $0xc,%esp
c0103c4a:	6a 3f                	push   $0x3f
c0103c4c:	eb 04                	jmp    c0103c52 <vprintfmt+0x20d>
                    else
                        putc(ch);
c0103c4e:	83 ec 0c             	sub    $0xc,%esp
c0103c51:	50                   	push   %eax
c0103c52:	ff 55 08             	call   *0x8(%ebp)
c0103c55:	83 c4 10             	add    $0x10,%esp
c0103c58:	eb c9                	jmp    c0103c23 <vprintfmt+0x1de>
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0103c5a:	ff 4d e0             	decl   -0x20(%ebp)
c0103c5d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
c0103c61:	75 d6                	jne    c0103c39 <vprintfmt+0x1f4>
c0103c63:	eb 12                	jmp    c0103c77 <vprintfmt+0x232>
c0103c65:	89 55 e0             	mov    %edx,-0x20(%ebp)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
                    putc(' ');
c0103c68:	83 ec 0c             	sub    $0xc,%esp
c0103c6b:	6a 20                	push   $0x20
c0103c6d:	ff 55 08             	call   *0x8(%ebp)
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
c0103c70:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103c73:	4a                   	dec    %edx
c0103c74:	83 c4 10             	add    $0x10,%esp
c0103c77:	85 d2                	test   %edx,%edx
c0103c79:	7f ea                	jg     c0103c65 <vprintfmt+0x220>

// Main function to format and print a string.
void printfmt(void (*putc)(int), const char* fmt, ...);

void
vprintfmt(void (*putc)(int), const char* fmt, va_list ap) {
c0103c7b:	8b 75 dc             	mov    -0x24(%ebp),%esi
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
c0103c7e:	e9 ce fd ff ff       	jmp    c0103a51 <vprintfmt+0xc>
c0103c83:	84 db                	test   %bl,%bl
c0103c85:	74 03                	je     c0103c8a <vprintfmt+0x245>
c0103c87:	89 4d 10             	mov    %ecx,0x10(%ebp)

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
c0103c8a:	83 7d d8 01          	cmpl   $0x1,-0x28(%ebp)
c0103c8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103c91:	7e 0d                	jle    c0103ca0 <vprintfmt+0x25b>
        return va_arg(*ap, long long);
c0103c93:	8d 50 08             	lea    0x8(%eax),%edx
c0103c96:	89 55 10             	mov    %edx,0x10(%ebp)
c0103c99:	8b 50 04             	mov    0x4(%eax),%edx
c0103c9c:	8b 00                	mov    (%eax),%eax
c0103c9e:	eb 09                	jmp    c0103ca9 <vprintfmt+0x264>
    else if (lflag)
        return va_arg(*ap, long);
c0103ca0:	8d 50 04             	lea    0x4(%eax),%edx
c0103ca3:	89 55 10             	mov    %edx,0x10(%ebp)
c0103ca6:	8b 00                	mov    (%eax),%eax
    else
        return va_arg(*ap, int);
c0103ca8:	99                   	cltd   
                num = getint(&ap, lflag);
                if ((long long) num < 0) {
                    putc('-');
                    num = -(long long) num;
                }
                base = 10;
c0103ca9:	bb 0a 00 00 00       	mov    $0xa,%ebx
                break;

            // (signed) decimal
            case 'd':
                num = getint(&ap, lflag);
                if ((long long) num < 0) {
c0103cae:	85 d2                	test   %edx,%edx
c0103cb0:	0f 89 98 00 00 00    	jns    c0103d4e <vprintfmt+0x309>
c0103cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103cb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                    putc('-');
c0103cbc:	83 ec 0c             	sub    $0xc,%esp
c0103cbf:	6a 2d                	push   $0x2d
c0103cc1:	ff 55 08             	call   *0x8(%ebp)
                    num = -(long long) num;
c0103cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103cca:	f7 d8                	neg    %eax
c0103ccc:	83 d2 00             	adc    $0x0,%edx
c0103ccf:	f7 da                	neg    %edx
c0103cd1:	83 c4 10             	add    $0x10,%esp
c0103cd4:	eb 78                	jmp    c0103d4e <vprintfmt+0x309>
c0103cd6:	84 db                	test   %bl,%bl
c0103cd8:	74 03                	je     c0103cdd <vprintfmt+0x298>
c0103cda:	89 4d 10             	mov    %ecx,0x10(%ebp)
                base = 10;
                goto number;

            // unsigned decimal
            case 'u':
                num = getuint(&ap, lflag);
c0103cdd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103ce0:	8d 45 10             	lea    0x10(%ebp),%eax
c0103ce3:	e8 3c fd ff ff       	call   c0103a24 <getuint>
                base = 10;
c0103ce8:	bb 0a 00 00 00       	mov    $0xa,%ebx
                goto number;
c0103ced:	eb 5f                	jmp    c0103d4e <vprintfmt+0x309>
c0103cef:	84 db                	test   %bl,%bl
c0103cf1:	74 03                	je     c0103cf6 <vprintfmt+0x2b1>
c0103cf3:	89 4d 10             	mov    %ecx,0x10(%ebp)

            // (unsigned) octal
            case 'o':
                num = getuint(&ap, lflag);
c0103cf6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103cf9:	8d 45 10             	lea    0x10(%ebp),%eax
c0103cfc:	e8 23 fd ff ff       	call   c0103a24 <getuint>
                base = 8;
                printnum(putc, num, base, width, padc);
c0103d01:	53                   	push   %ebx
c0103d02:	0f be 4d d7          	movsbl -0x29(%ebp),%ecx
c0103d06:	51                   	push   %ecx
c0103d07:	57                   	push   %edi
c0103d08:	6a 08                	push   $0x8
c0103d0a:	eb 4a                	jmp    c0103d56 <vprintfmt+0x311>
c0103d0c:	84 db                	test   %bl,%bl
c0103d0e:	74 03                	je     c0103d13 <vprintfmt+0x2ce>
c0103d10:	89 4d 10             	mov    %ecx,0x10(%ebp)
                break;

            // pointer
            case 'p':
                putc('0');
c0103d13:	83 ec 0c             	sub    $0xc,%esp
c0103d16:	6a 30                	push   $0x30
c0103d18:	ff 55 08             	call   *0x8(%ebp)
                putc('x');
c0103d1b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0103d22:	ff 55 08             	call   *0x8(%ebp)
                num = (unsigned long long)
                      (size_t) va_arg(ap, void*);
c0103d25:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d28:	8d 50 04             	lea    0x4(%eax),%edx
c0103d2b:	89 55 10             	mov    %edx,0x10(%ebp)

            // pointer
            case 'p':
                putc('0');
                putc('x');
                num = (unsigned long long)
c0103d2e:	8b 00                	mov    (%eax),%eax
c0103d30:	31 d2                	xor    %edx,%edx
                      (size_t) va_arg(ap, void*);
                base = 16;
                goto number;
c0103d32:	83 c4 10             	add    $0x10,%esp
c0103d35:	eb 12                	jmp    c0103d49 <vprintfmt+0x304>
c0103d37:	84 db                	test   %bl,%bl
c0103d39:	74 03                	je     c0103d3e <vprintfmt+0x2f9>
c0103d3b:	89 4d 10             	mov    %ecx,0x10(%ebp)

            // (unsigned) hexadecimal
            case 'x':
                num = getuint(&ap, lflag);
c0103d3e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103d41:	8d 45 10             	lea    0x10(%ebp),%eax
c0103d44:	e8 db fc ff ff       	call   c0103a24 <getuint>
                base = 16;
c0103d49:	bb 10 00 00 00       	mov    $0x10,%ebx
number:
                printnum(putc, num, base, width, padc);
c0103d4e:	51                   	push   %ecx
c0103d4f:	0f be 4d d7          	movsbl -0x29(%ebp),%ecx
c0103d53:	51                   	push   %ecx
c0103d54:	57                   	push   %edi
c0103d55:	53                   	push   %ebx
c0103d56:	89 d1                	mov    %edx,%ecx
c0103d58:	89 c2                	mov    %eax,%edx
c0103d5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d5d:	e8 29 fc ff ff       	call   c010398b <printnum>
c0103d62:	eb 0e                	jmp    c0103d72 <vprintfmt+0x32d>
c0103d64:	84 db                	test   %bl,%bl
c0103d66:	74 03                	je     c0103d6b <vprintfmt+0x326>
c0103d68:	89 4d 10             	mov    %ecx,0x10(%ebp)
                break;

            // escaped '%' character
            case '%':
                putc(ch);
c0103d6b:	83 ec 0c             	sub    $0xc,%esp
c0103d6e:	52                   	push   %edx
c0103d6f:	ff 55 08             	call   *0x8(%ebp)
                break;
c0103d72:	83 c4 10             	add    $0x10,%esp
c0103d75:	e9 01 ff ff ff       	jmp    c0103c7b <vprintfmt+0x236>
c0103d7a:	84 db                	test   %bl,%bl
c0103d7c:	74 03                	je     c0103d81 <vprintfmt+0x33c>
c0103d7e:	89 4d 10             	mov    %ecx,0x10(%ebp)

            // unrecognized escape sequence - just print it literally
            default:
                putc('%');
c0103d81:	83 ec 0c             	sub    $0xc,%esp
c0103d84:	6a 25                	push   $0x25
c0103d86:	ff 55 08             	call   *0x8(%ebp)
                for (fmt--; fmt[-1] != '%'; fmt--)
c0103d89:	83 c4 10             	add    $0x10,%esp
c0103d8c:	89 75 dc             	mov    %esi,-0x24(%ebp)
c0103d8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d92:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
c0103d96:	0f 84 df fe ff ff    	je     c0103c7b <vprintfmt+0x236>
c0103d9c:	ff 4d dc             	decl   -0x24(%ebp)
c0103d9f:	eb ee                	jmp    c0103d8f <vprintfmt+0x34a>
                    /* do nothing */;
                break;
        }
    }
}
c0103da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103da4:	5b                   	pop    %ebx
c0103da5:	5e                   	pop    %esi
c0103da6:	5f                   	pop    %edi
c0103da7:	5d                   	pop    %ebp
c0103da8:	c3                   	ret    

c0103da9 <vcprintf>:

void printfmt(void (*putc)(int), const char* fmt, ...);
void vprintfmt(void (*putc)(int), const char* fmt, va_list);

void
vcprintf(const char* fmt, va_list ap) {
c0103da9:	55                   	push   %ebp
c0103daa:	89 e5                	mov    %esp,%ebp
c0103dac:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt((void (*)(int)) putc, fmt, ap);
c0103daf:	ff 75 0c             	pushl  0xc(%ebp)
c0103db2:	ff 75 08             	pushl  0x8(%ebp)
c0103db5:	68 9a 93 10 c0       	push   $0xc010939a
c0103dba:	e8 86 fc ff ff       	call   c0103a45 <vprintfmt>
}
c0103dbf:	83 c4 10             	add    $0x10,%esp
c0103dc2:	c9                   	leave  
c0103dc3:	c3                   	ret    

c0103dc4 <print>:

void
print(const char* fmt, ...) {
c0103dc4:	55                   	push   %ebp
c0103dc5:	89 e5                	mov    %esp,%ebp
c0103dc7:	83 ec 10             	sub    $0x10,%esp
    va_list ap;

    va_start(ap, fmt);
c0103dca:	8d 45 0c             	lea    0xc(%ebp),%eax
    vcprintf(fmt, ap);
c0103dcd:	50                   	push   %eax
c0103dce:	ff 75 08             	pushl  0x8(%ebp)
c0103dd1:	e8 d3 ff ff ff       	call   c0103da9 <vcprintf>
    va_end(ap);
}
c0103dd6:	83 c4 10             	add    $0x10,%esp
c0103dd9:	c9                   	leave  
c0103dda:	c3                   	ret    

c0103ddb <printfmt>:
        }
    }
}

void
printfmt(void (*putc)(int), const char* fmt, ...) {
c0103ddb:	55                   	push   %ebp
c0103ddc:	89 e5                	mov    %esp,%ebp
c0103dde:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;

    va_start(ap, fmt);
c0103de1:	8d 45 10             	lea    0x10(%ebp),%eax
    vprintfmt(putc, fmt, ap);
c0103de4:	50                   	push   %eax
c0103de5:	ff 75 0c             	pushl  0xc(%ebp)
c0103de8:	ff 75 08             	pushl  0x8(%ebp)
c0103deb:	e8 55 fc ff ff       	call   c0103a45 <vprintfmt>
    va_end(ap);
}
c0103df0:	83 c4 10             	add    $0x10,%esp
c0103df3:	c9                   	leave  
c0103df4:	c3                   	ret    

c0103df5 <sprintputch>:
    char* ebuf;
    int cnt;
};

static void
sprintputch (int ch, struct sprintbuf* b) {
c0103df5:	55                   	push   %ebp
c0103df6:	89 e5                	mov    %esp,%ebp
c0103df8:	8b 45 0c             	mov    0xc(%ebp),%eax
    b->cnt++;
c0103dfb:	ff 40 08             	incl   0x8(%eax)
    if (b->buf < b->ebuf)
c0103dfe:	8b 10                	mov    (%eax),%edx
c0103e00:	3b 50 04             	cmp    0x4(%eax),%edx
c0103e03:	73 0a                	jae    c0103e0f <sprintputch+0x1a>
        *b->buf++ = ch;
c0103e05:	8d 4a 01             	lea    0x1(%edx),%ecx
c0103e08:	89 08                	mov    %ecx,(%eax)
c0103e0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e0d:	88 02                	mov    %al,(%edx)
}
c0103e0f:	5d                   	pop    %ebp
c0103e10:	c3                   	ret    

c0103e11 <vsnprintfmt>:
    __v;                    \
  })

void
vsnprintfmt (void (*putch) (int, void*), void* putdat, const char* fmt,
             va_list ap) {
c0103e11:	55                   	push   %ebp
c0103e12:	89 e5                	mov    %esp,%ebp
c0103e14:	57                   	push   %edi
c0103e15:	56                   	push   %esi
c0103e16:	53                   	push   %ebx
c0103e17:	83 ec 7c             	sub    $0x7c,%esp
c0103e1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
c0103e1d:	8b 7d 10             	mov    0x10(%ebp),%edi
c0103e20:	47                   	inc    %edi
c0103e21:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
c0103e25:	83 fa 25             	cmp    $0x25,%edx
c0103e28:	74 16                	je     c0103e40 <vsnprintfmt+0x2f>
            if (ch == '\0')
c0103e2a:	85 d2                	test   %edx,%edx
c0103e2c:	0f 84 39 04 00 00    	je     c010426b <vsnprintfmt+0x45a>
                return;
            putch (ch, putdat);
c0103e32:	50                   	push   %eax
c0103e33:	50                   	push   %eax
c0103e34:	ff 75 0c             	pushl  0xc(%ebp)
c0103e37:	52                   	push   %edx
c0103e38:	ff 55 08             	call   *0x8(%ebp)
c0103e3b:	83 c4 10             	add    $0x10,%esp
c0103e3e:	eb e0                	jmp    c0103e20 <vsnprintfmt+0xf>
c0103e40:	c6 45 90 20          	movb   $0x20,-0x70(%ebp)
c0103e44:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)
c0103e4b:	83 c9 ff             	or     $0xffffffff,%ecx
c0103e4e:	c7 45 94 ff ff ff ff 	movl   $0xffffffff,-0x6c(%ebp)
c0103e55:	31 f6                	xor    %esi,%esi
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
c0103e57:	8d 47 01             	lea    0x1(%edi),%eax
c0103e5a:	89 45 10             	mov    %eax,0x10(%ebp)
c0103e5d:	0f b6 3f             	movzbl (%edi),%edi
c0103e60:	89 f8                	mov    %edi,%eax
c0103e62:	3c 62                	cmp    $0x62,%al
c0103e64:	0f 84 f3 01 00 00    	je     c010405d <vsnprintfmt+0x24c>
c0103e6a:	77 53                	ja     c0103ebf <vsnprintfmt+0xae>
c0103e6c:	3c 2d                	cmp    $0x2d,%al
c0103e6e:	0f 84 a9 00 00 00    	je     c0103f1d <vsnprintfmt+0x10c>
c0103e74:	77 24                	ja     c0103e9a <vsnprintfmt+0x89>
c0103e76:	3c 25                	cmp    $0x25,%al
c0103e78:	0f 84 da 03 00 00    	je     c0104258 <vsnprintfmt+0x447>
c0103e7e:	3c 2a                	cmp    $0x2a,%al
c0103e80:	0f 84 ba 00 00 00    	je     c0103f40 <vsnprintfmt+0x12f>
c0103e86:	3c 23                	cmp    $0x23,%al
c0103e88:	0f 85 ae 03 00 00    	jne    c010423c <vsnprintfmt+0x42b>
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
c0103e8e:	c7 45 88 01 00 00 00 	movl   $0x1,-0x78(%ebp)
c0103e95:	8b 7d 10             	mov    0x10(%ebp),%edi
c0103e98:	eb bd                	jmp    c0103e57 <vsnprintfmt+0x46>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
c0103e9a:	3c 30                	cmp    $0x30,%al
c0103e9c:	75 06                	jne    c0103ea4 <vsnprintfmt+0x93>
            case '-':
                padc = '-';
                goto reswitch;

            case '0':
                padc = '0';
c0103e9e:	c6 45 90 30          	movb   $0x30,-0x70(%ebp)
c0103ea2:	eb f1                	jmp    c0103e95 <vsnprintfmt+0x84>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
c0103ea4:	77 0d                	ja     c0103eb3 <vsnprintfmt+0xa2>
c0103ea6:	3c 2e                	cmp    $0x2e,%al
c0103ea8:	0f 84 99 00 00 00    	je     c0103f47 <vsnprintfmt+0x136>
c0103eae:	e9 89 03 00 00       	jmp    c010423c <vsnprintfmt+0x42b>
c0103eb3:	3c 39                	cmp    $0x39,%al
c0103eb5:	0f 87 81 03 00 00    	ja     c010423c <vsnprintfmt+0x42b>
c0103ebb:	31 c9                	xor    %ecx,%ecx
c0103ebd:	eb 67                	jmp    c0103f26 <vsnprintfmt+0x115>
c0103ebf:	3c 70                	cmp    $0x70,%al
c0103ec1:	0f 84 3f 02 00 00    	je     c0104106 <vsnprintfmt+0x2f5>
c0103ec7:	77 23                	ja     c0103eec <vsnprintfmt+0xdb>
c0103ec9:	3c 64                	cmp    $0x64,%al
c0103ecb:	0f 84 af 01 00 00    	je     c0104080 <vsnprintfmt+0x26f>
c0103ed1:	0f 82 a1 00 00 00    	jb     c0103f78 <vsnprintfmt+0x167>
c0103ed7:	3c 6c                	cmp    $0x6c,%al
c0103ed9:	0f 84 93 00 00 00    	je     c0103f72 <vsnprintfmt+0x161>
c0103edf:	3c 6f                	cmp    $0x6f,%al
c0103ee1:	0f 84 00 02 00 00    	je     c01040e7 <vsnprintfmt+0x2d6>
c0103ee7:	e9 50 03 00 00       	jmp    c010423c <vsnprintfmt+0x42b>
c0103eec:	3c 75                	cmp    $0x75,%al
c0103eee:	0f 84 d4 01 00 00    	je     c01040c8 <vsnprintfmt+0x2b7>
c0103ef4:	77 0d                	ja     c0103f03 <vsnprintfmt+0xf2>
c0103ef6:	3c 73                	cmp    $0x73,%al
c0103ef8:	0f 84 91 00 00 00    	je     c0103f8f <vsnprintfmt+0x17e>
c0103efe:	e9 39 03 00 00       	jmp    c010423c <vsnprintfmt+0x42b>
c0103f03:	3c 78                	cmp    $0x78,%al
c0103f05:	0f 84 1b 02 00 00    	je     c0104126 <vsnprintfmt+0x315>
c0103f0b:	3c 7a                	cmp    $0x7a,%al
c0103f0d:	0f 85 29 03 00 00    	jne    c010423c <vsnprintfmt+0x42b>
                lflag++;
                goto reswitch;

            case 'z':
                if (sizeof(size_t) == sizeof(long))
                    lflag = 1;
c0103f13:	be 01 00 00 00       	mov    $0x1,%esi
                else if (sizeof(size_t) == sizeof(long long))
                    lflag = 2;
                else
                    lflag = 0;
                goto reswitch;
c0103f18:	e9 78 ff ff ff       	jmp    c0103e95 <vsnprintfmt+0x84>
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
            case '-':
                padc = '-';
c0103f1d:	c6 45 90 2d          	movb   $0x2d,-0x70(%ebp)
c0103f21:	e9 6f ff ff ff       	jmp    c0103e95 <vsnprintfmt+0x84>
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0;; ++fmt) {
                    precision = precision * 10 + ch - '0';
c0103f26:	6b c1 0a             	imul   $0xa,%ecx,%eax
c0103f29:	8d 4c 07 d0          	lea    -0x30(%edi,%eax,1),%ecx
                    ch = *fmt;
c0103f2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f30:	0f be 38             	movsbl (%eax),%edi
                    if (ch < '0' || ch > '9')
c0103f33:	8d 47 d0             	lea    -0x30(%edi),%eax
c0103f36:	83 f8 09             	cmp    $0x9,%eax
c0103f39:	77 22                	ja     c0103f5d <vsnprintfmt+0x14c>
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0;; ++fmt) {
c0103f3b:	ff 45 10             	incl   0x10(%ebp)
                    precision = precision * 10 + ch - '0';
                    ch = *fmt;
                    if (ch < '0' || ch > '9')
                        break;
                }
c0103f3e:	eb e6                	jmp    c0103f26 <vsnprintfmt+0x115>
                goto process_precision;

            case '*':
                precision = va_arg (ap, int);
c0103f40:	8b 0b                	mov    (%ebx),%ecx
c0103f42:	83 c3 04             	add    $0x4,%ebx
                goto process_precision;
c0103f45:	eb 16                	jmp    c0103f5d <vsnprintfmt+0x14c>
c0103f47:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
c0103f4b:	0f 89 44 ff ff ff    	jns    c0103e95 <vsnprintfmt+0x84>
c0103f51:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103f58:	e9 38 ff ff ff       	jmp    c0103e95 <vsnprintfmt+0x84>
            case '#':
                altflag = 1;
                goto reswitch;

process_precision:
                if (width < 0)
c0103f5d:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
c0103f61:	0f 89 2e ff ff ff    	jns    c0103e95 <vsnprintfmt+0x84>
                    width = precision, precision = -1;
c0103f67:	89 4d 94             	mov    %ecx,-0x6c(%ebp)
c0103f6a:	83 c9 ff             	or     $0xffffffff,%ecx
c0103f6d:	e9 23 ff ff ff       	jmp    c0103e95 <vsnprintfmt+0x84>
                goto reswitch;

            case 'l':
                lflag++;
c0103f72:	46                   	inc    %esi
                goto reswitch;
c0103f73:	e9 1d ff ff ff       	jmp    c0103e95 <vsnprintfmt+0x84>
                else
                    lflag = 0;
                goto reswitch;

            case 'c':
                putch (va_arg (ap, int), putdat);
c0103f78:	8d 7b 04             	lea    0x4(%ebx),%edi
c0103f7b:	50                   	push   %eax
c0103f7c:	50                   	push   %eax
c0103f7d:	ff 75 0c             	pushl  0xc(%ebp)
c0103f80:	ff 33                	pushl  (%ebx)
c0103f82:	ff 55 08             	call   *0x8(%ebp)
                break;
c0103f85:	83 c4 10             	add    $0x10,%esp
                putch ('%', putdat);
                while (lflag-- > 0)
                    putch ('l', putdat);

            case '%':
                putch (ch, putdat);
c0103f88:	89 fb                	mov    %edi,%ebx
c0103f8a:	e9 8e fe ff ff       	jmp    c0103e1d <vsnprintfmt+0xc>
            case 'c':
                putch (va_arg (ap, int), putdat);
                break;

            case 's':
                if ((p = va_arg (ap, char*)) == NULL)
c0103f8f:	8d 7b 04             	lea    0x4(%ebx),%edi
c0103f92:	8b 1b                	mov    (%ebx),%ebx
c0103f94:	85 db                	test   %ebx,%ebx
c0103f96:	75 05                	jne    c0103f9d <vsnprintfmt+0x18c>
                    p = "(null)";
c0103f98:	bb f7 b9 10 c0       	mov    $0xc010b9f7,%ebx
                if (width > 0 && padc != '-')
c0103f9d:	80 7d 90 2d          	cmpb   $0x2d,-0x70(%ebp)
c0103fa1:	74 55                	je     c0103ff8 <vsnprintfmt+0x1e7>
c0103fa3:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
c0103fa7:	7e 4f                	jle    c0103ff8 <vsnprintfmt+0x1e7>
c0103fa9:	89 4d 80             	mov    %ecx,-0x80(%ebp)
                    for (width -= strlen (p); width > 0; width--)
c0103fac:	83 ec 0c             	sub    $0xc,%esp
c0103faf:	53                   	push   %ebx
c0103fb0:	e8 42 03 00 00       	call   c01042f7 <strlen>
c0103fb5:	8b 75 94             	mov    -0x6c(%ebp),%esi
c0103fb8:	29 c6                	sub    %eax,%esi
c0103fba:	83 c4 10             	add    $0x10,%esp
c0103fbd:	89 f0                	mov    %esi,%eax
                        putch (padc, putdat);
c0103fbf:	0f be 55 90          	movsbl -0x70(%ebp),%edx

            case 's':
                if ((p = va_arg (ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen (p); width > 0; width--)
c0103fc3:	8b 4d 80             	mov    -0x80(%ebp),%ecx
c0103fc6:	85 c0                	test   %eax,%eax
c0103fc8:	7e 21                	jle    c0103feb <vsnprintfmt+0x1da>
c0103fca:	89 4d 80             	mov    %ecx,-0x80(%ebp)
c0103fcd:	89 45 90             	mov    %eax,-0x70(%ebp)
                        putch (padc, putdat);
c0103fd0:	50                   	push   %eax
c0103fd1:	50                   	push   %eax
c0103fd2:	ff 75 0c             	pushl  0xc(%ebp)
c0103fd5:	52                   	push   %edx
c0103fd6:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0103fd9:	ff 55 08             	call   *0x8(%ebp)

            case 's':
                if ((p = va_arg (ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen (p); width > 0; width--)
c0103fdc:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103fdf:	48                   	dec    %eax
c0103fe0:	83 c4 10             	add    $0x10,%esp
c0103fe3:	8b 4d 80             	mov    -0x80(%ebp),%ecx
c0103fe6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103fe9:	eb db                	jmp    c0103fc6 <vsnprintfmt+0x1b5>
c0103feb:	89 f0                	mov    %esi,%eax
c0103fed:	85 f6                	test   %esi,%esi
c0103fef:	79 02                	jns    c0103ff3 <vsnprintfmt+0x1e2>
c0103ff1:	31 c0                	xor    %eax,%eax
c0103ff3:	29 c6                	sub    %eax,%esi
c0103ff5:	89 75 94             	mov    %esi,-0x6c(%ebp)
c0103ff8:	89 de                	mov    %ebx,%esi
c0103ffa:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103ffd:	29 f0                	sub    %esi,%eax
c0103fff:	01 d8                	add    %ebx,%eax
                        putch (padc, putdat);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0104001:	46                   	inc    %esi
c0104002:	0f be 56 ff          	movsbl -0x1(%esi),%edx
c0104006:	85 d2                	test   %edx,%edx
c0104008:	74 35                	je     c010403f <vsnprintfmt+0x22e>
c010400a:	85 c9                	test   %ecx,%ecx
c010400c:	79 2b                	jns    c0104039 <vsnprintfmt+0x228>
                    if (altflag && (ch < ' ' || ch > '~'))
c010400e:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104012:	89 4d 90             	mov    %ecx,-0x70(%ebp)
c0104015:	74 11                	je     c0104028 <vsnprintfmt+0x217>
c0104017:	8d 42 e0             	lea    -0x20(%edx),%eax
c010401a:	83 f8 5e             	cmp    $0x5e,%eax
c010401d:	76 09                	jbe    c0104028 <vsnprintfmt+0x217>
                        putch ('?', putdat);
c010401f:	50                   	push   %eax
c0104020:	50                   	push   %eax
c0104021:	ff 75 0c             	pushl  0xc(%ebp)
c0104024:	6a 3f                	push   $0x3f
c0104026:	eb 06                	jmp    c010402e <vsnprintfmt+0x21d>
                    else
                        putch (ch, putdat);
c0104028:	50                   	push   %eax
c0104029:	50                   	push   %eax
c010402a:	ff 75 0c             	pushl  0xc(%ebp)
c010402d:	52                   	push   %edx
c010402e:	ff 55 08             	call   *0x8(%ebp)
c0104031:	83 c4 10             	add    $0x10,%esp
c0104034:	8b 4d 90             	mov    -0x70(%ebp),%ecx
c0104037:	eb c1                	jmp    c0103ffa <vsnprintfmt+0x1e9>
                if ((p = va_arg (ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen (p); width > 0; width--)
                        putch (padc, putdat);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0104039:	49                   	dec    %ecx
c010403a:	83 f9 ff             	cmp    $0xffffffff,%ecx
c010403d:	75 cf                	jne    c010400e <vsnprintfmt+0x1fd>
                    if (altflag && (ch < ' ' || ch > '~'))
                        putch ('?', putdat);
                    else
                        putch (ch, putdat);
                for (; width > 0; width--)
c010403f:	85 c0                	test   %eax,%eax
c0104041:	0f 8e 41 ff ff ff    	jle    c0103f88 <vsnprintfmt+0x177>
c0104047:	89 45 94             	mov    %eax,-0x6c(%ebp)
                    putch (' ', putdat);
c010404a:	53                   	push   %ebx
c010404b:	53                   	push   %ebx
c010404c:	ff 75 0c             	pushl  0xc(%ebp)
c010404f:	6a 20                	push   $0x20
c0104051:	ff 55 08             	call   *0x8(%ebp)
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putch ('?', putdat);
                    else
                        putch (ch, putdat);
                for (; width > 0; width--)
c0104054:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104057:	48                   	dec    %eax
c0104058:	83 c4 10             	add    $0x10,%esp
c010405b:	eb e2                	jmp    c010403f <vsnprintfmt+0x22e>
                    putch (' ', putdat);
                break;

            case 'b':
                num = getint (ap, lflag);
c010405d:	4e                   	dec    %esi
c010405e:	7e 0a                	jle    c010406a <vsnprintfmt+0x259>
c0104060:	8d 7b 08             	lea    0x8(%ebx),%edi
c0104063:	8b 0b                	mov    (%ebx),%ecx
c0104065:	8b 5b 04             	mov    0x4(%ebx),%ebx
c0104068:	eb 0c                	jmp    c0104076 <vsnprintfmt+0x265>
c010406a:	8d 43 04             	lea    0x4(%ebx),%eax
c010406d:	89 c7                	mov    %eax,%edi
c010406f:	8b 0b                	mov    (%ebx),%ecx
c0104071:	89 cb                	mov    %ecx,%ebx
c0104073:	c1 fb 1f             	sar    $0x1f,%ebx
                base = 2;
c0104076:	be 02 00 00 00       	mov    $0x2,%esi
                goto number;
c010407b:	e9 c3 00 00 00       	jmp    c0104143 <vsnprintfmt+0x332>

            case 'd':
                num = getint (ap, lflag);
c0104080:	4e                   	dec    %esi
c0104081:	7e 0a                	jle    c010408d <vsnprintfmt+0x27c>
c0104083:	8d 7b 08             	lea    0x8(%ebx),%edi
c0104086:	8b 0b                	mov    (%ebx),%ecx
c0104088:	8b 5b 04             	mov    0x4(%ebx),%ebx
c010408b:	eb 0c                	jmp    c0104099 <vsnprintfmt+0x288>
c010408d:	8d 43 04             	lea    0x4(%ebx),%eax
c0104090:	89 c7                	mov    %eax,%edi
c0104092:	8b 0b                	mov    (%ebx),%ecx
c0104094:	89 cb                	mov    %ecx,%ebx
c0104096:	c1 fb 1f             	sar    $0x1f,%ebx
                if ((long long) num < 0) {
                    putch ('-', putdat);
                    num = -(long long) num;
                }
                base = 10;
c0104099:	be 0a 00 00 00       	mov    $0xa,%esi
                base = 2;
                goto number;

            case 'd':
                num = getint (ap, lflag);
                if ((long long) num < 0) {
c010409e:	85 db                	test   %ebx,%ebx
c01040a0:	0f 89 9d 00 00 00    	jns    c0104143 <vsnprintfmt+0x332>
c01040a6:	89 4d 88             	mov    %ecx,-0x78(%ebp)
c01040a9:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
                    putch ('-', putdat);
c01040ac:	51                   	push   %ecx
c01040ad:	51                   	push   %ecx
c01040ae:	ff 75 0c             	pushl  0xc(%ebp)
c01040b1:	6a 2d                	push   $0x2d
c01040b3:	ff 55 08             	call   *0x8(%ebp)
                    num = -(long long) num;
c01040b6:	8b 4d 88             	mov    -0x78(%ebp),%ecx
c01040b9:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
c01040bc:	f7 d9                	neg    %ecx
c01040be:	83 d3 00             	adc    $0x0,%ebx
c01040c1:	f7 db                	neg    %ebx
c01040c3:	83 c4 10             	add    $0x10,%esp
c01040c6:	eb 7b                	jmp    c0104143 <vsnprintfmt+0x332>
                }
                base = 10;
                goto number;

            case 'u':
                num = getuint (ap, lflag);
c01040c8:	83 fe 01             	cmp    $0x1,%esi
c01040cb:	7e 0a                	jle    c01040d7 <vsnprintfmt+0x2c6>
c01040cd:	8d 7b 08             	lea    0x8(%ebx),%edi
c01040d0:	8b 0b                	mov    (%ebx),%ecx
c01040d2:	8b 5b 04             	mov    0x4(%ebx),%ebx
c01040d5:	eb 09                	jmp    c01040e0 <vsnprintfmt+0x2cf>
c01040d7:	8d 43 04             	lea    0x4(%ebx),%eax
c01040da:	89 c7                	mov    %eax,%edi
c01040dc:	8b 0b                	mov    (%ebx),%ecx
c01040de:	31 db                	xor    %ebx,%ebx
                base = 10;
c01040e0:	be 0a 00 00 00       	mov    $0xa,%esi
                goto number;
c01040e5:	eb 5c                	jmp    c0104143 <vsnprintfmt+0x332>

            case 'o':
                num = getuint (ap, lflag);
c01040e7:	83 fe 01             	cmp    $0x1,%esi
c01040ea:	7e 0a                	jle    c01040f6 <vsnprintfmt+0x2e5>
c01040ec:	8d 7b 08             	lea    0x8(%ebx),%edi
c01040ef:	8b 0b                	mov    (%ebx),%ecx
c01040f1:	8b 5b 04             	mov    0x4(%ebx),%ebx
c01040f4:	eb 09                	jmp    c01040ff <vsnprintfmt+0x2ee>
c01040f6:	8d 43 04             	lea    0x4(%ebx),%eax
c01040f9:	89 c7                	mov    %eax,%edi
c01040fb:	8b 0b                	mov    (%ebx),%ecx
c01040fd:	31 db                	xor    %ebx,%ebx
                base = 8;
c01040ff:	be 08 00 00 00       	mov    $0x8,%esi
                goto number;
c0104104:	eb 3d                	jmp    c0104143 <vsnprintfmt+0x332>

            case 'p':
                putch ('0', putdat);
c0104106:	50                   	push   %eax
c0104107:	50                   	push   %eax
c0104108:	ff 75 0c             	pushl  0xc(%ebp)
c010410b:	6a 30                	push   $0x30
c010410d:	ff 55 08             	call   *0x8(%ebp)
                putch ('x', putdat);
c0104110:	58                   	pop    %eax
c0104111:	5a                   	pop    %edx
c0104112:	ff 75 0c             	pushl  0xc(%ebp)
c0104115:	6a 78                	push   $0x78
c0104117:	ff 55 08             	call   *0x8(%ebp)
                num = (unsigned long long)
                      (size_t) va_arg (ap, void*);
c010411a:	8d 7b 04             	lea    0x4(%ebx),%edi
                goto number;

            case 'p':
                putch ('0', putdat);
                putch ('x', putdat);
                num = (unsigned long long)
c010411d:	8b 0b                	mov    (%ebx),%ecx
c010411f:	31 db                	xor    %ebx,%ebx
                      (size_t) va_arg (ap, void*);
                base = 16;
                goto number;
c0104121:	83 c4 10             	add    $0x10,%esp
c0104124:	eb 18                	jmp    c010413e <vsnprintfmt+0x32d>

            case 'x':
                num = getuint (ap, lflag);
c0104126:	83 fe 01             	cmp    $0x1,%esi
c0104129:	7e 0a                	jle    c0104135 <vsnprintfmt+0x324>
c010412b:	8d 7b 08             	lea    0x8(%ebx),%edi
c010412e:	8b 0b                	mov    (%ebx),%ecx
c0104130:	8b 5b 04             	mov    0x4(%ebx),%ebx
c0104133:	eb 09                	jmp    c010413e <vsnprintfmt+0x32d>
c0104135:	8d 43 04             	lea    0x4(%ebx),%eax
c0104138:	89 c7                	mov    %eax,%edi
c010413a:	8b 0b                	mov    (%ebx),%ecx
c010413c:	31 db                	xor    %ebx,%ebx
                base = 16;
c010413e:	be 10 00 00 00       	mov    $0x10,%esi
number:
                snprintnum (putch, putdat, num, base, MAX(width, 0), padc);
c0104143:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104146:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104149:	85 c0                	test   %eax,%eax
c010414b:	79 07                	jns    c0104154 <vsnprintfmt+0x343>
c010414d:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)
static void
snprintnum (void (*putch) (int, void*), void* putdat,
            unsigned long long num, unsigned base, int width, int padc) {
    char buf[68], *x;

    for (x = buf; num; num /= base)
c0104154:	8d 45 a4             	lea    -0x5c(%ebp),%eax
c0104157:	89 45 94             	mov    %eax,-0x6c(%ebp)
        * x++ = "0123456789abcdef"[num % base];
c010415a:	89 75 80             	mov    %esi,-0x80(%ebp)
c010415d:	c1 fe 1f             	sar    $0x1f,%esi
c0104160:	89 75 84             	mov    %esi,-0x7c(%ebp)
static void
snprintnum (void (*putch) (int, void*), void* putdat,
            unsigned long long num, unsigned base, int width, int padc) {
    char buf[68], *x;

    for (x = buf; num; num /= base)
c0104163:	89 d8                	mov    %ebx,%eax
c0104165:	09 c8                	or     %ecx,%eax
c0104167:	74 4d                	je     c01041b6 <vsnprintfmt+0x3a5>
        * x++ = "0123456789abcdef"[num % base];
c0104169:	ff 45 94             	incl   -0x6c(%ebp)
c010416c:	ff 75 84             	pushl  -0x7c(%ebp)
c010416f:	ff 75 80             	pushl  -0x80(%ebp)
c0104172:	53                   	push   %ebx
c0104173:	51                   	push   %ecx
c0104174:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
c010417a:	89 9d 7c ff ff ff    	mov    %ebx,-0x84(%ebp)
c0104180:	e8 8f 66 00 00       	call   c010a814 <__umoddi3>
c0104185:	83 c4 10             	add    $0x10,%esp
c0104188:	8a 80 e6 b9 10 c0    	mov    -0x3fef461a(%eax),%al
c010418e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104191:	88 42 ff             	mov    %al,-0x1(%edx)
static void
snprintnum (void (*putch) (int, void*), void* putdat,
            unsigned long long num, unsigned base, int width, int padc) {
    char buf[68], *x;

    for (x = buf; num; num /= base)
c0104194:	ff 75 84             	pushl  -0x7c(%ebp)
c0104197:	ff 75 80             	pushl  -0x80(%ebp)
c010419a:	8b 8d 78 ff ff ff    	mov    -0x88(%ebp),%ecx
c01041a0:	8b 9d 7c ff ff ff    	mov    -0x84(%ebp),%ebx
c01041a6:	53                   	push   %ebx
c01041a7:	51                   	push   %ecx
c01041a8:	e8 57 65 00 00       	call   c010a704 <__udivdi3>
c01041ad:	83 c4 10             	add    $0x10,%esp
c01041b0:	89 c1                	mov    %eax,%ecx
c01041b2:	89 d3                	mov    %edx,%ebx
c01041b4:	eb ad                	jmp    c0104163 <vsnprintfmt+0x352>
        * x++ = "0123456789abcdef"[num % base];
    if (x == buf)
c01041b6:	8d 55 a4             	lea    -0x5c(%ebp),%edx
c01041b9:	39 55 94             	cmp    %edx,-0x6c(%ebp)
c01041bc:	75 0a                	jne    c01041c8 <vsnprintfmt+0x3b7>
        *x++ = '0';
c01041be:	c6 45 a4 30          	movb   $0x30,-0x5c(%ebp)
c01041c2:	8d 45 a5             	lea    -0x5b(%ebp),%eax
c01041c5:	89 45 94             	mov    %eax,-0x6c(%ebp)

    if (padc != '-')
c01041c8:	80 7d 90 2d          	cmpb   $0x2d,-0x70(%ebp)
c01041cc:	74 22                	je     c01041f0 <vsnprintfmt+0x3df>
        for (; width > x - buf; width--)
c01041ce:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
c01041d1:	8d 45 a4             	lea    -0x5c(%ebp),%eax
c01041d4:	29 c3                	sub    %eax,%ebx
            putch (padc, putdat);
c01041d6:	0f be 75 90          	movsbl -0x70(%ebp),%esi
        * x++ = "0123456789abcdef"[num % base];
    if (x == buf)
        *x++ = '0';

    if (padc != '-')
        for (; width > x - buf; width--)
c01041da:	39 5d 88             	cmp    %ebx,-0x78(%ebp)
c01041dd:	7e 11                	jle    c01041f0 <vsnprintfmt+0x3df>
            putch (padc, putdat);
c01041df:	50                   	push   %eax
c01041e0:	50                   	push   %eax
c01041e1:	ff 75 0c             	pushl  0xc(%ebp)
c01041e4:	56                   	push   %esi
c01041e5:	ff 55 08             	call   *0x8(%ebp)
        * x++ = "0123456789abcdef"[num % base];
    if (x == buf)
        *x++ = '0';

    if (padc != '-')
        for (; width > x - buf; width--)
c01041e8:	ff 4d 88             	decl   -0x78(%ebp)
c01041eb:	83 c4 10             	add    $0x10,%esp
c01041ee:	eb ea                	jmp    c01041da <vsnprintfmt+0x3c9>
    char buf[68], *x;

    for (x = buf; num; num /= base)
        * x++ = "0123456789abcdef"[num % base];
    if (x == buf)
        *x++ = '0';
c01041f0:	8b 75 94             	mov    -0x6c(%ebp),%esi
c01041f3:	8b 45 88             	mov    -0x78(%ebp),%eax
c01041f6:	29 f0                	sub    %esi,%eax
c01041f8:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01041fb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01041fe:	8d 1c 06             	lea    (%esi,%eax,1),%ebx

    if (padc != '-')
        for (; width > x - buf; width--)
            putch (padc, putdat);

    for (; x > buf; width--)
c0104201:	8d 45 a4             	lea    -0x5c(%ebp),%eax
c0104204:	39 c6                	cmp    %eax,%esi
c0104206:	76 12                	jbe    c010421a <vsnprintfmt+0x409>
        putch (*--x, putdat);
c0104208:	4e                   	dec    %esi
c0104209:	50                   	push   %eax
c010420a:	50                   	push   %eax
c010420b:	ff 75 0c             	pushl  0xc(%ebp)
c010420e:	0f be 06             	movsbl (%esi),%eax
c0104211:	50                   	push   %eax
c0104212:	ff 55 08             	call   *0x8(%ebp)
c0104215:	83 c4 10             	add    $0x10,%esp
c0104218:	eb e1                	jmp    c01041fb <vsnprintfmt+0x3ea>

    if (padc == '-')
c010421a:	80 7d 90 2d          	cmpb   $0x2d,-0x70(%ebp)
c010421e:	0f 85 64 fd ff ff    	jne    c0103f88 <vsnprintfmt+0x177>
        for (; width > 0; width--)
c0104224:	85 db                	test   %ebx,%ebx
c0104226:	0f 8e 5c fd ff ff    	jle    c0103f88 <vsnprintfmt+0x177>
            putch (' ', putdat);
c010422c:	56                   	push   %esi
c010422d:	56                   	push   %esi
c010422e:	ff 75 0c             	pushl  0xc(%ebp)
c0104231:	6a 20                	push   $0x20
c0104233:	ff 55 08             	call   *0x8(%ebp)

    for (; x > buf; width--)
        putch (*--x, putdat);

    if (padc == '-')
        for (; width > 0; width--)
c0104236:	4b                   	dec    %ebx
c0104237:	83 c4 10             	add    $0x10,%esp
c010423a:	eb e8                	jmp    c0104224 <vsnprintfmt+0x413>
number:
                snprintnum (putch, putdat, num, base, MAX(width, 0), padc);
                break;

            default:
                putch ('%', putdat);
c010423c:	51                   	push   %ecx
c010423d:	51                   	push   %ecx
c010423e:	ff 75 0c             	pushl  0xc(%ebp)
c0104241:	6a 25                	push   $0x25
                while (lflag-- > 0)
                    putch ('l', putdat);
c0104243:	ff 55 08             	call   *0x8(%ebp)
c0104246:	83 c4 10             	add    $0x10,%esp
                snprintnum (putch, putdat, num, base, MAX(width, 0), padc);
                break;

            default:
                putch ('%', putdat);
                while (lflag-- > 0)
c0104249:	4e                   	dec    %esi
c010424a:	83 fe ff             	cmp    $0xffffffff,%esi
c010424d:	74 09                	je     c0104258 <vsnprintfmt+0x447>
                    putch ('l', putdat);
c010424f:	52                   	push   %edx
c0104250:	52                   	push   %edx
c0104251:	ff 75 0c             	pushl  0xc(%ebp)
c0104254:	6a 6c                	push   $0x6c
c0104256:	eb eb                	jmp    c0104243 <vsnprintfmt+0x432>

            case '%':
                putch (ch, putdat);
c0104258:	50                   	push   %eax
c0104259:	50                   	push   %eax
c010425a:	ff 75 0c             	pushl  0xc(%ebp)
c010425d:	57                   	push   %edi
c010425e:	ff 55 08             	call   *0x8(%ebp)
c0104261:	83 c4 10             	add    $0x10,%esp
c0104264:	89 df                	mov    %ebx,%edi
c0104266:	e9 1d fd ff ff       	jmp    c0103f88 <vsnprintfmt+0x177>
        }
    }
}
c010426b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010426e:	5b                   	pop    %ebx
c010426f:	5e                   	pop    %esi
c0104270:	5f                   	pop    %edi
c0104271:	5d                   	pop    %ebp
c0104272:	c3                   	ret    

c0104273 <vsnprintf>:
    if (b->buf < b->ebuf)
        *b->buf++ = ch;
}

int
vsnprintf (char* buf, size_t n, const char* fmt, va_list ap) {
c0104273:	55                   	push   %ebp
c0104274:	89 e5                	mov    %esp,%ebp
c0104276:	83 ec 18             	sub    $0x18,%esp
c0104279:	8b 45 08             	mov    0x8(%ebp),%eax
c010427c:	8b 55 0c             	mov    0xc(%ebp),%edx
    struct sprintbuf b = { buf, buf + n - 1, 0 };
c010427f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104282:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
c0104286:	89 4d f0             	mov    %ecx,-0x10(%ebp)
c0104289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    if (buf == NULL || n < 1)
c0104290:	85 d2                	test   %edx,%edx
c0104292:	74 26                	je     c01042ba <vsnprintf+0x47>
c0104294:	85 c0                	test   %eax,%eax
c0104296:	74 22                	je     c01042ba <vsnprintf+0x47>
        return EINVAL;

    vsnprintfmt ((void*) sprintputch, &b, fmt, ap);
c0104298:	ff 75 14             	pushl  0x14(%ebp)
c010429b:	ff 75 10             	pushl  0x10(%ebp)
c010429e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01042a1:	50                   	push   %eax
c01042a2:	68 f5 3d 10 c0       	push   $0xc0103df5
c01042a7:	e8 65 fb ff ff       	call   c0103e11 <vsnprintfmt>

    *b.buf = '\0';
c01042ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042af:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
c01042b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042b5:	83 c4 10             	add    $0x10,%esp
c01042b8:	eb 05                	jmp    c01042bf <vsnprintf+0x4c>
int
vsnprintf (char* buf, size_t n, const char* fmt, va_list ap) {
    struct sprintbuf b = { buf, buf + n - 1, 0 };

    if (buf == NULL || n < 1)
        return EINVAL;
c01042ba:	b8 01 00 00 00       	mov    $0x1,%eax
    vsnprintfmt ((void*) sprintputch, &b, fmt, ap);

    *b.buf = '\0';

    return b.cnt;
}
c01042bf:	c9                   	leave  
c01042c0:	c3                   	ret    

c01042c1 <snprintf>:

int
snprintf (char* buf, size_t n, const char* fmt, ...) {
c01042c1:	55                   	push   %ebp
c01042c2:	89 e5                	mov    %esp,%ebp
c01042c4:	83 ec 08             	sub    $0x8,%esp
    va_list ap;
    int rc;

    va_start (ap, fmt);
c01042c7:	8d 45 14             	lea    0x14(%ebp),%eax
    rc = vsnprintf (buf, n, fmt, ap);
c01042ca:	50                   	push   %eax
c01042cb:	ff 75 10             	pushl  0x10(%ebp)
c01042ce:	ff 75 0c             	pushl  0xc(%ebp)
c01042d1:	ff 75 08             	pushl  0x8(%ebp)
c01042d4:	e8 9a ff ff ff       	call   c0104273 <vsnprintf>
    va_end (ap);

    return rc;
}
c01042d9:	c9                   	leave  
c01042da:	c3                   	ret    

c01042db <sprintf>:

int
sprintf (char* buf, const char* fmt, ...) {
c01042db:	55                   	push   %ebp
c01042dc:	89 e5                	mov    %esp,%ebp
c01042de:	83 ec 08             	sub    $0x8,%esp
    va_list ap;
    int cnt;

    va_start (ap, fmt);
c01042e1:	8d 45 10             	lea    0x10(%ebp),%eax
    cnt = vsnprintf (buf, 100000, fmt, ap);
c01042e4:	50                   	push   %eax
c01042e5:	ff 75 0c             	pushl  0xc(%ebp)
c01042e8:	68 a0 86 01 00       	push   $0x186a0
c01042ed:	ff 75 08             	pushl  0x8(%ebp)
c01042f0:	e8 7e ff ff ff       	call   c0104273 <vsnprintf>
    va_end (ap);

    return cnt;
}
c01042f5:	c9                   	leave  
c01042f6:	c3                   	ret    

c01042f7 <strlen>:
#include <lib.h>
#include <kmm.h>

size_t
strlen(const char* str) {
c01042f7:	55                   	push   %ebp
c01042f8:	89 e5                	mov    %esp,%ebp
c01042fa:	8b 55 08             	mov    0x8(%ebp),%edx
    size_t len;
    for(len = 0; *str != '\0'; ++str)
c01042fd:	31 c0                	xor    %eax,%eax
c01042ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
c0104303:	74 03                	je     c0104308 <strlen+0x11>
        len++;
c0104305:	40                   	inc    %eax
c0104306:	eb f7                	jmp    c01042ff <strlen+0x8>

    return len;
}
c0104308:	5d                   	pop    %ebp
c0104309:	c3                   	ret    

c010430a <strdup>:

char*
strdup(const char* s) {
c010430a:	55                   	push   %ebp
c010430b:	89 e5                	mov    %esp,%ebp
c010430d:	56                   	push   %esi
c010430e:	53                   	push   %ebx
c010430f:	8b 75 08             	mov    0x8(%ebp),%esi
    size_t len = strlen(s);
c0104312:	56                   	push   %esi
c0104313:	e8 df ff ff ff       	call   c01042f7 <strlen>
c0104318:	52                   	push   %edx
c0104319:	52                   	push   %edx
c010431a:	89 c3                	mov    %eax,%ebx
    char* dup = kmalloc(len + 1);
c010431c:	40                   	inc    %eax
c010431d:	50                   	push   %eax
c010431e:	e8 82 d5 ff ff       	call   c01018a5 <kmalloc>

    for (size_t i = 0; i < len; i++)
c0104323:	83 c4 10             	add    $0x10,%esp
c0104326:	31 d2                	xor    %edx,%edx
c0104328:	39 da                	cmp    %ebx,%edx
c010432a:	74 09                	je     c0104335 <strdup+0x2b>
        dup[i] = s[i];
c010432c:	8a 0c 16             	mov    (%esi,%edx,1),%cl
c010432f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
char*
strdup(const char* s) {
    size_t len = strlen(s);
    char* dup = kmalloc(len + 1);

    for (size_t i = 0; i < len; i++)
c0104332:	42                   	inc    %edx
c0104333:	eb f3                	jmp    c0104328 <strdup+0x1e>
        dup[i] = s[i];
    dup[len] = 0;
c0104335:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)

    return dup;
}
c0104339:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010433c:	5b                   	pop    %ebx
c010433d:	5e                   	pop    %esi
c010433e:	5d                   	pop    %ebp
c010433f:	c3                   	ret    

c0104340 <strchr>:

char*
strchr(const char* s, char c) {
c0104340:	55                   	push   %ebp
c0104341:	89 e5                	mov    %esp,%ebp
c0104343:	8b 45 08             	mov    0x8(%ebp),%eax
c0104346:	8a 4d 0c             	mov    0xc(%ebp),%cl
    for (; *s != c; ++s)
c0104349:	8a 10                	mov    (%eax),%dl
c010434b:	38 ca                	cmp    %cl,%dl
c010434d:	74 09                	je     c0104358 <strchr+0x18>
        if (*s == '\0')
c010434f:	84 d2                	test   %dl,%dl
c0104351:	74 03                	je     c0104356 <strchr+0x16>
    return dup;
}

char*
strchr(const char* s, char c) {
    for (; *s != c; ++s)
c0104353:	40                   	inc    %eax
c0104354:	eb f3                	jmp    c0104349 <strchr+0x9>
        if (*s == '\0')
            return 0;
c0104356:	31 c0                	xor    %eax,%eax

    return (char*) s;
}
c0104358:	5d                   	pop    %ebp
c0104359:	c3                   	ret    

c010435a <strstr>:

char*
strstr(const char* str, const char* sub) {
c010435a:	55                   	push   %ebp
c010435b:	89 e5                	mov    %esp,%ebp
c010435d:	57                   	push   %edi
c010435e:	56                   	push   %esi
c010435f:	53                   	push   %ebx
c0104360:	8b 55 08             	mov    0x8(%ebp),%edx
c0104363:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char* b = (char*) sub;
    if (*b == 0)
c0104366:	8a 0f                	mov    (%edi),%cl
c0104368:	84 c9                	test   %cl,%cl
c010436a:	74 22                	je     c010438e <strstr+0x34>
        return (char*) str;

    for (; *str != 0; ++str) {
c010436c:	8a 02                	mov    (%edx),%al
c010436e:	84 c0                	test   %al,%al
c0104370:	74 18                	je     c010438a <strstr+0x30>
        if (*str != *b)
c0104372:	38 c1                	cmp    %al,%cl
c0104374:	75 11                	jne    c0104387 <strstr+0x2d>
c0104376:	31 f6                	xor    %esi,%esi
            continue;

        char* a = (char*) str;
        while (1) {
            if (*b == 0)
c0104378:	8a 04 37             	mov    (%edi,%esi,1),%al
c010437b:	84 c0                	test   %al,%al
c010437d:	74 0f                	je     c010438e <strstr+0x34>
                return (char*) str;
            if (*a++ != *b++)
c010437f:	8a 1c 32             	mov    (%edx,%esi,1),%bl
c0104382:	46                   	inc    %esi
c0104383:	38 d8                	cmp    %bl,%al
c0104385:	74 f1                	je     c0104378 <strstr+0x1e>
strstr(const char* str, const char* sub) {
    char* b = (char*) sub;
    if (*b == 0)
        return (char*) str;

    for (; *str != 0; ++str) {
c0104387:	42                   	inc    %edx
c0104388:	eb e2                	jmp    c010436c <strstr+0x12>
            if (*a++ != *b++)
                break;
        }
        b = (char*) sub;
    }
    return NULL;
c010438a:	31 c0                	xor    %eax,%eax
c010438c:	eb 02                	jmp    c0104390 <strstr+0x36>
c010438e:	89 d0                	mov    %edx,%eax
}
c0104390:	5b                   	pop    %ebx
c0104391:	5e                   	pop    %esi
c0104392:	5f                   	pop    %edi
c0104393:	5d                   	pop    %ebp
c0104394:	c3                   	ret    

c0104395 <strcmp>:

int
strcmp(const char* s1, const char* s2) {
c0104395:	55                   	push   %ebp
c0104396:	89 e5                	mov    %esp,%ebp
c0104398:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    for (; *s1 == *s2; ++s1, ++s2)
c010439b:	31 c0                	xor    %eax,%eax
c010439d:	8b 55 08             	mov    0x8(%ebp),%edx
c01043a0:	8a 14 02             	mov    (%edx,%eax,1),%dl
c01043a3:	3a 14 01             	cmp    (%ecx,%eax,1),%dl
c01043a6:	75 09                	jne    c01043b1 <strcmp+0x1c>
c01043a8:	40                   	inc    %eax
        if (*s1 == '\0')
c01043a9:	84 d2                	test   %dl,%dl
c01043ab:	75 f0                	jne    c010439d <strcmp+0x8>
            return 0;
c01043ad:	31 c0                	xor    %eax,%eax
c01043af:	eb 05                	jmp    c01043b6 <strcmp+0x21>

    return ((*(unsigned char*) s1 < * (unsigned char*) s2) ? -1 : +1);
c01043b1:	19 c0                	sbb    %eax,%eax
c01043b3:	83 c8 01             	or     $0x1,%eax
}
c01043b6:	5d                   	pop    %ebp
c01043b7:	c3                   	ret    

c01043b8 <strcpy>:

    return dst;
}

char*
strcpy(char* dst, const char* src) {
c01043b8:	55                   	push   %ebp
c01043b9:	89 e5                	mov    %esp,%ebp
c01043bb:	8b 45 08             	mov    0x8(%ebp),%eax
    char* s = dst;

    while ((*s++ = *src++) != 0);
c01043be:	31 d2                	xor    %edx,%edx
c01043c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01043c3:	8a 0c 11             	mov    (%ecx,%edx,1),%cl
c01043c6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
c01043c9:	42                   	inc    %edx
c01043ca:	84 c9                	test   %cl,%cl
c01043cc:	75 f2                	jne    c01043c0 <strcpy+0x8>

    return dst;
}
c01043ce:	5d                   	pop    %ebp
c01043cf:	c3                   	ret    

c01043d0 <strcat>:

    return ((*(unsigned char*) s1 < * (unsigned char*) s2) ? -1 : +1);
}

char*
strcat(char* dst, const char* src) {
c01043d0:	55                   	push   %ebp
c01043d1:	89 e5                	mov    %esp,%ebp
c01043d3:	53                   	push   %ebx
c01043d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    strcpy(&dst[strlen(dst)], src);
c01043d7:	53                   	push   %ebx
c01043d8:	e8 1a ff ff ff       	call   c01042f7 <strlen>
c01043dd:	5a                   	pop    %edx
c01043de:	ff 75 0c             	pushl  0xc(%ebp)
c01043e1:	01 d8                	add    %ebx,%eax
c01043e3:	50                   	push   %eax
c01043e4:	e8 cf ff ff ff       	call   c01043b8 <strcpy>

    return dst;
}
c01043e9:	89 d8                	mov    %ebx,%eax
c01043eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01043ee:	c9                   	leave  
c01043ef:	c3                   	ret    

c01043f0 <strncmp>:

    return dst;
}

int
strncmp(const char* s1, const char* s2, size_t n) {
c01043f0:	55                   	push   %ebp
c01043f1:	89 e5                	mov    %esp,%ebp
c01043f3:	53                   	push   %ebx
c01043f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    for (; n > 0; ++s1, ++s2, --n) {
c01043f7:	31 c0                	xor    %eax,%eax
c01043f9:	39 45 10             	cmp    %eax,0x10(%ebp)
c01043fc:	74 17                	je     c0104415 <strncmp+0x25>
        if (*s1 != *s2)
c01043fe:	8a 14 01             	mov    (%ecx,%eax,1),%dl
c0104401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c0104404:	3a 14 03             	cmp    (%ebx,%eax,1),%dl
c0104407:	74 07                	je     c0104410 <strncmp+0x20>
            return ((*(unsigned char*) s1 < * (unsigned char*) s2) ? -1 : +1);
c0104409:	19 c0                	sbb    %eax,%eax
c010440b:	83 c8 01             	or     $0x1,%eax
c010440e:	eb 07                	jmp    c0104417 <strncmp+0x27>
c0104410:	40                   	inc    %eax
        if (*s1 == '\0')
c0104411:	84 d2                	test   %dl,%dl
c0104413:	75 e4                	jne    c01043f9 <strncmp+0x9>
            return 0;
c0104415:	31 c0                	xor    %eax,%eax
    }

    return 0;
}
c0104417:	5b                   	pop    %ebx
c0104418:	5d                   	pop    %ebp
c0104419:	c3                   	ret    

c010441a <strncat>:

char*
strncat(char* dst, const char* src, size_t n) {
c010441a:	55                   	push   %ebp
c010441b:	89 e5                	mov    %esp,%ebp
c010441d:	56                   	push   %esi
c010441e:	53                   	push   %ebx
c010441f:	8b 75 10             	mov    0x10(%ebp),%esi
    if (n != 0) {
c0104422:	85 f6                	test   %esi,%esi
c0104424:	74 2c                	je     c0104452 <strncat+0x38>
c0104426:	8b 55 08             	mov    0x8(%ebp),%edx
        char* d = dst;

        while (*d != 0)
c0104429:	80 3a 00             	cmpb   $0x0,(%edx)
c010442c:	74 03                	je     c0104431 <strncat+0x17>
            d++;
c010442e:	42                   	inc    %edx
c010442f:	eb f8                	jmp    c0104429 <strncat+0xf>
c0104431:	31 c9                	xor    %ecx,%ecx
        do
            if ((*d++ = *src++) == 0)
c0104433:	8d 5a 01             	lea    0x1(%edx),%ebx
c0104436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104439:	8a 04 08             	mov    (%eax,%ecx,1),%al
c010443c:	88 43 ff             	mov    %al,-0x1(%ebx)
c010443f:	84 c0                	test   %al,%al
c0104441:	75 06                	jne    c0104449 <strncat+0x2f>
                break;
        while (--n != 0);
        *d = 0;
c0104443:	c6 42 01 00          	movb   $0x0,0x1(%edx)
c0104447:	eb 09                	jmp    c0104452 <strncat+0x38>
c0104449:	41                   	inc    %ecx
        while (*d != 0)
            d++;
        do
            if ((*d++ = *src++) == 0)
                break;
        while (--n != 0);
c010444a:	39 ce                	cmp    %ecx,%esi
c010444c:	74 f5                	je     c0104443 <strncat+0x29>
c010444e:	89 da                	mov    %ebx,%edx
c0104450:	eb e1                	jmp    c0104433 <strncat+0x19>
        *d = 0;
    }

    return dst;
}
c0104452:	8b 45 08             	mov    0x8(%ebp),%eax
c0104455:	5b                   	pop    %ebx
c0104456:	5e                   	pop    %esi
c0104457:	5d                   	pop    %ebp
c0104458:	c3                   	ret    

c0104459 <strncpy>:

char*
strncpy(char* dst, const char* src, size_t n) {
c0104459:	55                   	push   %ebp
c010445a:	89 e5                	mov    %esp,%ebp
c010445c:	57                   	push   %edi
c010445d:	56                   	push   %esi
c010445e:	53                   	push   %ebx
c010445f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104462:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char* s = dst;
    while (n-- > 0 && *src != '\0')
c0104465:	8b 75 10             	mov    0x10(%ebp),%esi
c0104468:	8d 56 ff             	lea    -0x1(%esi),%edx
    return dst;
}

char*
strncpy(char* dst, const char* src, size_t n) {
    char* s = dst;
c010446b:	89 c3                	mov    %eax,%ebx
    while (n-- > 0 && *src != '\0')
c010446d:	83 fa ff             	cmp    $0xffffffff,%edx
c0104470:	74 12                	je     c0104484 <strncpy+0x2b>
c0104472:	8a 0f                	mov    (%edi),%cl
c0104474:	8d 72 ff             	lea    -0x1(%edx),%esi
c0104477:	84 c9                	test   %cl,%cl
c0104479:	74 09                	je     c0104484 <strncpy+0x2b>
        *s++ = *src++;
c010447b:	43                   	inc    %ebx
c010447c:	47                   	inc    %edi
c010447d:	88 4b ff             	mov    %cl,-0x1(%ebx)
c0104480:	89 f2                	mov    %esi,%edx
c0104482:	eb e9                	jmp    c010446d <strncpy+0x14>
    return dst;
}

char*
strncpy(char* dst, const char* src, size_t n) {
    char* s = dst;
c0104484:	31 c9                	xor    %ecx,%ecx
    while (n-- > 0 && *src != '\0')
        *s++ = *src++;

    while (n-- > 0)
c0104486:	39 ca                	cmp    %ecx,%edx
c0104488:	74 07                	je     c0104491 <strncpy+0x38>
        *s++ = '\0';
c010448a:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
c010448e:	41                   	inc    %ecx
c010448f:	eb f5                	jmp    c0104486 <strncpy+0x2d>

    return dst;
}
c0104491:	5b                   	pop    %ebx
c0104492:	5e                   	pop    %esi
c0104493:	5f                   	pop    %edi
c0104494:	5d                   	pop    %ebp
c0104495:	c3                   	ret    

c0104496 <memcpy>:

void*
memcpy(void* dst, const void* src, size_t count) {
c0104496:	55                   	push   %ebp
c0104497:	89 e5                	mov    %esp,%ebp
c0104499:	53                   	push   %ebx
c010449a:	8b 45 08             	mov    0x8(%ebp),%eax
c010449d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    const uint8_t* sp = (const uint8_t*) src;
    for(uint8_t* dp = (uint8_t*) dst; count != 0; count--)
c01044a0:	31 d2                	xor    %edx,%edx
c01044a2:	39 55 10             	cmp    %edx,0x10(%ebp)
c01044a5:	74 09                	je     c01044b0 <memcpy+0x1a>
        *dp++ = *sp++;
c01044a7:	8a 1c 11             	mov    (%ecx,%edx,1),%bl
c01044aa:	88 1c 10             	mov    %bl,(%eax,%edx,1)
c01044ad:	42                   	inc    %edx
c01044ae:	eb f2                	jmp    c01044a2 <memcpy+0xc>
    return dst;
}
c01044b0:	5b                   	pop    %ebx
c01044b1:	5d                   	pop    %ebp
c01044b2:	c3                   	ret    

c01044b3 <memmove>:

void*
memmove(void* dst, const void* src, size_t count) {
c01044b3:	55                   	push   %ebp
c01044b4:	89 e5                	mov    %esp,%ebp
    return memcpy(dst, src, count);
}
c01044b6:	5d                   	pop    %ebp
    return dst;
}

void*
memmove(void* dst, const void* src, size_t count) {
    return memcpy(dst, src, count);
c01044b7:	e9 da ff ff ff       	jmp    c0104496 <memcpy>

c01044bc <memset>:
}

void*
memset(void* dst, uint8_t val, size_t count) {
c01044bc:	55                   	push   %ebp
c01044bd:	89 e5                	mov    %esp,%ebp
c01044bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c2:	8a 4d 0c             	mov    0xc(%ebp),%cl
    for(uint8_t* ptr = (uint8_t*) dst; count != 0; count--)
c01044c5:	31 d2                	xor    %edx,%edx
c01044c7:	39 55 10             	cmp    %edx,0x10(%ebp)
c01044ca:	74 06                	je     c01044d2 <memset+0x16>
        *ptr++ = val;
c01044cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
c01044cf:	42                   	inc    %edx
c01044d0:	eb f5                	jmp    c01044c7 <memset+0xb>
    return dst;
}
c01044d2:	5d                   	pop    %ebp
c01044d3:	c3                   	ret    

c01044d4 <memsetw>:

uint16_t*
memsetw(uint16_t* dst, uint16_t val, size_t count) {
c01044d4:	55                   	push   %ebp
c01044d5:	89 e5                	mov    %esp,%ebp
c01044d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01044da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    for(uint16_t* ptr = (uint16_t*) dst; count != 0; count--)
c01044dd:	31 d2                	xor    %edx,%edx
c01044df:	39 55 10             	cmp    %edx,0x10(%ebp)
c01044e2:	74 07                	je     c01044eb <memsetw+0x17>
        *ptr++ = val;
c01044e4:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
c01044e8:	42                   	inc    %edx
c01044e9:	eb f4                	jmp    c01044df <memsetw+0xb>
    return dst;
}
c01044eb:	5d                   	pop    %ebp
c01044ec:	c3                   	ret    

c01044ed <memcmp>:

int
memcmp(const void* s1, const void* s2, size_t n) {
c01044ed:	55                   	push   %ebp
c01044ee:	89 e5                	mov    %esp,%ebp
c01044f0:	53                   	push   %ebx
c01044f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
        do {
            if (*p1++ != *p2++)
                return (*--p1 - *--p2);
        } while (--n != 0);
    }
    return (0);
c01044f4:	31 c0                	xor    %eax,%eax
    return dst;
}

int
memcmp(const void* s1, const void* s2, size_t n) {
    if (n != 0) {
c01044f6:	85 c9                	test   %ecx,%ecx
c01044f8:	74 1f                	je     c0104519 <memcmp+0x2c>
c01044fa:	31 db                	xor    %ebx,%ebx
        uint8_t* p1 = (uint8_t*) s1;
        uint8_t* p2 = (uint8_t*) s2;

        do {
            if (*p1++ != *p2++)
c01044fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ff:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
c0104503:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104506:	0f b6 14 1a          	movzbl (%edx,%ebx,1),%edx
c010450a:	38 d0                	cmp    %dl,%al
c010450c:	74 04                	je     c0104512 <memcmp+0x25>
                return (*--p1 - *--p2);
c010450e:	29 d0                	sub    %edx,%eax
c0104510:	eb 07                	jmp    c0104519 <memcmp+0x2c>
c0104512:	43                   	inc    %ebx
        } while (--n != 0);
c0104513:	39 d9                	cmp    %ebx,%ecx
c0104515:	75 e5                	jne    c01044fc <memcmp+0xf>
    }
    return (0);
c0104517:	31 c0                	xor    %eax,%eax
}
c0104519:	5b                   	pop    %ebx
c010451a:	5d                   	pop    %ebp
c010451b:	c3                   	ret    

c010451c <array_num>:
#ifndef ARRAYINLINE
#define ARRAYINLINE
#endif

ARRAYINLINE unsigned
array_num(const struct array* a) {
c010451c:	55                   	push   %ebp
c010451d:	89 e5                	mov    %esp,%ebp
    return a->num;
c010451f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104522:	8b 40 04             	mov    0x4(%eax),%eax
}
c0104525:	5d                   	pop    %ebp
c0104526:	c3                   	ret    

c0104527 <array_get>:

ARRAYINLINE void*
array_get(const struct array* a, unsigned index) {
c0104527:	55                   	push   %ebp
c0104528:	89 e5                	mov    %esp,%ebp
c010452a:	56                   	push   %esi
c010452b:	53                   	push   %ebx
c010452c:	8b 75 08             	mov    0x8(%ebp),%esi
c010452f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    assert(index < a->num);
c0104532:	39 5e 04             	cmp    %ebx,0x4(%esi)
c0104535:	77 28                	ja     c010455f <array_get+0x38>
c0104537:	83 ec 0c             	sub    $0xc,%esp
c010453a:	68 64 ba 10 c0       	push   $0xc010ba64
c010453f:	6a 34                	push   $0x34
c0104541:	68 fe b9 10 c0       	push   $0xc010b9fe
c0104546:	68 0a ba 10 c0       	push   $0xc010ba0a
c010454b:	68 95 a9 10 c0       	push   $0xc010a995
c0104550:	e8 6f f8 ff ff       	call   c0103dc4 <print>
c0104555:	83 c4 20             	add    $0x20,%esp
c0104558:	e8 ed c8 ff ff       	call   c0100e4a <backtrace>
c010455d:	fa                   	cli    
c010455e:	f4                   	hlt    
    return a->v[index];
c010455f:	8b 06                	mov    (%esi),%eax
c0104561:	8b 04 98             	mov    (%eax,%ebx,4),%eax
}
c0104564:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0104567:	5b                   	pop    %ebx
c0104568:	5e                   	pop    %esi
c0104569:	5d                   	pop    %ebp
c010456a:	c3                   	ret    

c010456b <array_set>:

ARRAYINLINE void
array_set(const struct array* a, unsigned index, void* val) {
c010456b:	55                   	push   %ebp
c010456c:	89 e5                	mov    %esp,%ebp
c010456e:	56                   	push   %esi
c010456f:	53                   	push   %ebx
c0104570:	8b 75 08             	mov    0x8(%ebp),%esi
c0104573:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    assert(index < a->num);
c0104576:	39 5e 04             	cmp    %ebx,0x4(%esi)
c0104579:	77 28                	ja     c01045a3 <array_set+0x38>
c010457b:	83 ec 0c             	sub    $0xc,%esp
c010457e:	68 58 ba 10 c0       	push   $0xc010ba58
c0104583:	6a 3a                	push   $0x3a
c0104585:	68 fe b9 10 c0       	push   $0xc010b9fe
c010458a:	68 0a ba 10 c0       	push   $0xc010ba0a
c010458f:	68 95 a9 10 c0       	push   $0xc010a995
c0104594:	e8 2b f8 ff ff       	call   c0103dc4 <print>
c0104599:	83 c4 20             	add    $0x20,%esp
c010459c:	e8 a9 c8 ff ff       	call   c0100e4a <backtrace>
c01045a1:	fa                   	cli    
c01045a2:	f4                   	hlt    
    a->v[index] = val;
c01045a3:	8b 06                	mov    (%esi),%eax
c01045a5:	8b 55 10             	mov    0x10(%ebp),%edx
c01045a8:	89 14 98             	mov    %edx,(%eax,%ebx,4)
}
c01045ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01045ae:	5b                   	pop    %ebx
c01045af:	5e                   	pop    %esi
c01045b0:	5d                   	pop    %ebp
c01045b1:	c3                   	ret    

c01045b2 <array_create>:
        *index_ret = index;
    return 0;
}

struct array*
array_create(void) {
c01045b2:	55                   	push   %ebp
c01045b3:	89 e5                	mov    %esp,%ebp
c01045b5:	83 ec 14             	sub    $0x14,%esp
    struct array* a;

    a = kmalloc(sizeof(*a));
c01045b8:	6a 0c                	push   $0xc
c01045ba:	e8 e6 d2 ff ff       	call   c01018a5 <kmalloc>
    if (a != NULL)
c01045bf:	83 c4 10             	add    $0x10,%esp
c01045c2:	85 c0                	test   %eax,%eax
c01045c4:	74 14                	je     c01045da <array_create+0x28>
    kfree(a);
}

void
array_init(struct array* a) {
    a->num = a->max = 0;
c01045c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01045cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    a->v = NULL;
c01045d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    a = kmalloc(sizeof(*a));
    if (a != NULL)
        array_init(a);
    return a;
}
c01045da:	c9                   	leave  
c01045db:	c3                   	ret    

c01045dc <array_init>:
    array_cleanup(a);
    kfree(a);
}

void
array_init(struct array* a) {
c01045dc:	55                   	push   %ebp
c01045dd:	89 e5                	mov    %esp,%ebp
c01045df:	8b 45 08             	mov    0x8(%ebp),%eax
    a->num = a->max = 0;
c01045e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01045e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    a->v = NULL;
c01045f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c01045f6:	5d                   	pop    %ebp
c01045f7:	c3                   	ret    

c01045f8 <array_cleanup>:

void
array_cleanup(struct array* a) {
c01045f8:	55                   	push   %ebp
c01045f9:	89 e5                	mov    %esp,%ebp
c01045fb:	53                   	push   %ebx
c01045fc:	50                   	push   %eax
c01045fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
    /*
     * Require array to be empty - helps avoid memory leaks since
     * we don't/can't free anything any contents may be pointing
     * to.
     */
    assert(a->num == 0);
c0104600:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
c0104604:	74 28                	je     c010462e <array_cleanup+0x36>
c0104606:	83 ec 0c             	sub    $0xc,%esp
c0104609:	68 48 ba 10 c0       	push   $0xc010ba48
c010460e:	6a 6a                	push   $0x6a
c0104610:	68 fe b9 10 c0       	push   $0xc010b9fe
c0104615:	68 19 ba 10 c0       	push   $0xc010ba19
c010461a:	68 95 a9 10 c0       	push   $0xc010a995
c010461f:	e8 a0 f7 ff ff       	call   c0103dc4 <print>
c0104624:	83 c4 20             	add    $0x20,%esp
c0104627:	e8 1e c8 ff ff       	call   c0100e4a <backtrace>
c010462c:	fa                   	cli    
c010462d:	f4                   	hlt    
    kfree(a->v);
c010462e:	83 ec 0c             	sub    $0xc,%esp
c0104631:	ff 33                	pushl  (%ebx)
c0104633:	e8 39 d3 ff ff       	call   c0101971 <kfree>
    a->v = NULL;
c0104638:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
c010463e:	83 c4 10             	add    $0x10,%esp
c0104641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104644:	c9                   	leave  
c0104645:	c3                   	ret    

c0104646 <array_destroy>:
        array_init(a);
    return a;
}

void
array_destroy(struct array* a) {
c0104646:	55                   	push   %ebp
c0104647:	89 e5                	mov    %esp,%ebp
c0104649:	53                   	push   %ebx
c010464a:	83 ec 10             	sub    $0x10,%esp
c010464d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    array_cleanup(a);
c0104650:	53                   	push   %ebx
c0104651:	e8 a2 ff ff ff       	call   c01045f8 <array_cleanup>
    kfree(a);
c0104656:	83 c4 10             	add    $0x10,%esp
c0104659:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c010465c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010465f:	c9                   	leave  
}

void
array_destroy(struct array* a) {
    array_cleanup(a);
    kfree(a);
c0104660:	e9 0c d3 ff ff       	jmp    c0101971 <kfree>

c0104665 <array_setsize>:
    kfree(a->v);
    a->v = NULL;
}

int
array_setsize(struct array* a, unsigned num) {
c0104665:	55                   	push   %ebp
c0104666:	89 e5                	mov    %esp,%ebp
c0104668:	57                   	push   %edi
c0104669:	56                   	push   %esi
c010466a:	53                   	push   %ebx
c010466b:	83 ec 0c             	sub    $0xc,%esp
c010466e:	8b 75 08             	mov    0x8(%ebp),%esi
    void** newptr;
    unsigned newmax;

    if (num > a->max) {
c0104671:	8b 5e 08             	mov    0x8(%esi),%ebx
c0104674:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
c0104677:	73 52                	jae    c01046cb <array_setsize+0x66>
        /* Don't touch A until the allocation succeeds. */
        newmax = a->max;
        while (num > newmax)
c0104679:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
c010467c:	73 0f                	jae    c010468d <array_setsize+0x28>
            newmax = newmax ? newmax * 2 : 4;
c010467e:	85 db                	test   %ebx,%ebx
c0104680:	74 04                	je     c0104686 <array_setsize+0x21>
c0104682:	01 db                	add    %ebx,%ebx
c0104684:	eb f3                	jmp    c0104679 <array_setsize+0x14>
c0104686:	bb 04 00 00 00       	mov    $0x4,%ebx
c010468b:	eb ec                	jmp    c0104679 <array_setsize+0x14>
         * worthwhile to implement just for this. So just
         * allocate a new block and copy. (Exercise: what
         * about this and/or kmalloc makes it not worthwhile?)
         */

        newptr = kmalloc(newmax * sizeof(*a->v));
c010468d:	83 ec 0c             	sub    $0xc,%esp
c0104690:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
c0104697:	50                   	push   %eax
c0104698:	e8 08 d2 ff ff       	call   c01018a5 <kmalloc>
c010469d:	89 c7                	mov    %eax,%edi
        if (newptr == NULL)
c010469f:	83 c4 10             	add    $0x10,%esp
            return ENOMEM;
c01046a2:	b8 02 00 00 00       	mov    $0x2,%eax
         * allocate a new block and copy. (Exercise: what
         * about this and/or kmalloc makes it not worthwhile?)
         */

        newptr = kmalloc(newmax * sizeof(*a->v));
        if (newptr == NULL)
c01046a7:	85 ff                	test   %edi,%edi
c01046a9:	74 28                	je     c01046d3 <array_setsize+0x6e>
            return ENOMEM;
        memcpy(newptr, a->v, a->num * sizeof(*a->v));
c01046ab:	50                   	push   %eax
c01046ac:	8b 46 04             	mov    0x4(%esi),%eax
c01046af:	c1 e0 02             	shl    $0x2,%eax
c01046b2:	50                   	push   %eax
c01046b3:	ff 36                	pushl  (%esi)
c01046b5:	57                   	push   %edi
c01046b6:	e8 db fd ff ff       	call   c0104496 <memcpy>
        kfree(a->v);
c01046bb:	5a                   	pop    %edx
c01046bc:	ff 36                	pushl  (%esi)
c01046be:	e8 ae d2 ff ff       	call   c0101971 <kfree>
        a->v = newptr;
c01046c3:	89 3e                	mov    %edi,(%esi)
        a->max = newmax;
c01046c5:	89 5e 08             	mov    %ebx,0x8(%esi)
c01046c8:	83 c4 10             	add    $0x10,%esp
    }
    a->num = num;
c01046cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046ce:	89 46 04             	mov    %eax,0x4(%esi)

    return 0;
c01046d1:	31 c0                	xor    %eax,%eax
}
c01046d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01046d6:	5b                   	pop    %ebx
c01046d7:	5e                   	pop    %esi
c01046d8:	5f                   	pop    %edi
c01046d9:	5d                   	pop    %ebp
c01046da:	c3                   	ret    

c01046db <array_add>:
    assert(index < a->num);
    a->v[index] = val;
}

ARRAYINLINE int
array_add(struct array* a, void* val, unsigned* index_ret) {
c01046db:	55                   	push   %ebp
c01046dc:	89 e5                	mov    %esp,%ebp
c01046de:	57                   	push   %edi
c01046df:	56                   	push   %esi
c01046e0:	53                   	push   %ebx
c01046e1:	83 ec 14             	sub    $0x14,%esp
c01046e4:	8b 7d 08             	mov    0x8(%ebp),%edi
c01046e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    unsigned index;
    int ret;

    index = a->num;
c01046ea:	8b 77 04             	mov    0x4(%edi),%esi
    ret = array_setsize(a, index + 1);
c01046ed:	8d 46 01             	lea    0x1(%esi),%eax
c01046f0:	50                   	push   %eax
c01046f1:	57                   	push   %edi
c01046f2:	e8 6e ff ff ff       	call   c0104665 <array_setsize>
    if (ret)
c01046f7:	83 c4 10             	add    $0x10,%esp
c01046fa:	85 c0                	test   %eax,%eax
c01046fc:	75 0e                	jne    c010470c <array_add+0x31>
        return ret;
    a->v[index] = val;
c01046fe:	8b 17                	mov    (%edi),%edx
c0104700:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0104703:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
    if (index_ret != NULL)
c0104706:	85 db                	test   %ebx,%ebx
c0104708:	74 02                	je     c010470c <array_add+0x31>
        *index_ret = index;
c010470a:	89 33                	mov    %esi,(%ebx)
    return 0;
}
c010470c:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010470f:	5b                   	pop    %ebx
c0104710:	5e                   	pop    %esi
c0104711:	5f                   	pop    %edi
c0104712:	5d                   	pop    %ebp
c0104713:	c3                   	ret    

c0104714 <array_remove>:

    return 0;
}

void
array_remove(struct array* a, unsigned index) {
c0104714:	55                   	push   %ebp
c0104715:	89 e5                	mov    %esp,%ebp
c0104717:	56                   	push   %esi
c0104718:	53                   	push   %ebx
c0104719:	8b 75 08             	mov    0x8(%ebp),%esi
c010471c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    unsigned num_to_move;

    assert(a->num <= a->max);
c010471f:	8b 46 08             	mov    0x8(%esi),%eax
c0104722:	39 46 04             	cmp    %eax,0x4(%esi)
c0104725:	76 2b                	jbe    c0104752 <array_remove+0x3e>
c0104727:	83 ec 0c             	sub    $0xc,%esp
c010472a:	68 38 ba 10 c0       	push   $0xc010ba38
c010472f:	68 92 00 00 00       	push   $0x92
c0104734:	68 fe b9 10 c0       	push   $0xc010b9fe
c0104739:	68 25 ba 10 c0       	push   $0xc010ba25
c010473e:	68 95 a9 10 c0       	push   $0xc010a995
c0104743:	e8 7c f6 ff ff       	call   c0103dc4 <print>
c0104748:	83 c4 20             	add    $0x20,%esp
c010474b:	e8 fa c6 ff ff       	call   c0100e4a <backtrace>
c0104750:	fa                   	cli    
c0104751:	f4                   	hlt    
    assert(index < a->num);
c0104752:	39 5e 04             	cmp    %ebx,0x4(%esi)
c0104755:	77 2b                	ja     c0104782 <array_remove+0x6e>
c0104757:	83 ec 0c             	sub    $0xc,%esp
c010475a:	68 38 ba 10 c0       	push   $0xc010ba38
c010475f:	68 93 00 00 00       	push   $0x93
c0104764:	68 fe b9 10 c0       	push   $0xc010b9fe
c0104769:	68 0a ba 10 c0       	push   $0xc010ba0a
c010476e:	68 95 a9 10 c0       	push   $0xc010a995
c0104773:	e8 4c f6 ff ff       	call   c0103dc4 <print>
c0104778:	83 c4 20             	add    $0x20,%esp
c010477b:	e8 ca c6 ff ff       	call   c0100e4a <backtrace>
c0104780:	fa                   	cli    
c0104781:	f4                   	hlt    

    num_to_move = a->num - (index + 1);
    memmove(a->v + index, a->v + index + 1, num_to_move * sizeof(void*));
c0104782:	8b 16                	mov    (%esi),%edx
c0104784:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
c010478b:	51                   	push   %ecx
c010478c:	f7 d3                	not    %ebx
c010478e:	03 5e 04             	add    0x4(%esi),%ebx
c0104791:	c1 e3 02             	shl    $0x2,%ebx
c0104794:	53                   	push   %ebx
c0104795:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0104798:	51                   	push   %ecx
c0104799:	8d 44 02 fc          	lea    -0x4(%edx,%eax,1),%eax
c010479d:	50                   	push   %eax
c010479e:	e8 10 fd ff ff       	call   c01044b3 <memmove>
    a->num--;
c01047a3:	ff 4e 04             	decl   0x4(%esi)
}
c01047a6:	83 c4 10             	add    $0x10,%esp
c01047a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01047ac:	5b                   	pop    %ebx
c01047ad:	5e                   	pop    %esi
c01047ae:	5d                   	pop    %ebp
c01047af:	c3                   	ret    

c01047b0 <listnode_create>:

/* Allocates and returns a list node object containing given element */
struct listnode* listnode_create(void* newval);

struct listnode*
listnode_create(void* newval) {
c01047b0:	55                   	push   %ebp
c01047b1:	89 e5                	mov    %esp,%ebp
c01047b3:	83 ec 14             	sub    $0x14,%esp
    struct listnode* newnode;

    newnode = (struct listnode*)kmalloc(sizeof(struct listnode));
c01047b6:	6a 0c                	push   $0xc
c01047b8:	e8 e8 d0 ff ff       	call   c01018a5 <kmalloc>
    if (newnode == NULL)
c01047bd:	83 c4 10             	add    $0x10,%esp
c01047c0:	85 c0                	test   %eax,%eax
c01047c2:	74 13                	je     c01047d7 <listnode_create+0x27>
        return NULL;
    newnode->datatype = LISTNODETYPE;
c01047c4:	c7 00 58 04 00 00    	movl   $0x458,(%eax)
    newnode->val = newval;
c01047ca:	8b 55 08             	mov    0x8(%ebp),%edx
c01047cd:	89 50 04             	mov    %edx,0x4(%eax)
    newnode->next = NULL;
c01047d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    return newnode;
}
c01047d7:	c9                   	leave  
c01047d8:	c3                   	ret    

c01047d9 <list_create>:

struct list*
list_create(void) {
c01047d9:	55                   	push   %ebp
c01047da:	89 e5                	mov    %esp,%ebp
c01047dc:	83 ec 14             	sub    $0x14,%esp
    struct list* newlist;

    newlist = (struct list*)kmalloc(sizeof(struct list));
c01047df:	6a 10                	push   $0x10
c01047e1:	e8 bf d0 ff ff       	call   c01018a5 <kmalloc>
    if (newlist == NULL)
c01047e6:	83 c4 10             	add    $0x10,%esp
c01047e9:	85 c0                	test   %eax,%eax
c01047eb:	74 1b                	je     c0104808 <list_create+0x2f>
        return NULL;

    newlist->datatype = LISTTYPE;
c01047ed:	c7 00 57 04 00 00    	movl   $0x457,(%eax)
    newlist->head = NULL;
c01047f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    newlist->tail = NULL;
c01047fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    newlist->size = 0;
c0104801:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

    return newlist;
}
c0104808:	c9                   	leave  
c0104809:	c3                   	ret    

c010480a <list_push_back>:

int
list_push_back(struct list* lst, void* newval) {
c010480a:	55                   	push   %ebp
c010480b:	89 e5                	mov    %esp,%ebp
c010480d:	56                   	push   %esi
c010480e:	53                   	push   %ebx
c010480f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104812:	85 db                	test   %ebx,%ebx
c0104814:	75 28                	jne    c010483e <list_push_back+0x34>
c0104816:	83 ec 0c             	sub    $0xc,%esp
c0104819:	68 0c bc 10 c0       	push   $0xc010bc0c
c010481e:	6a 3d                	push   $0x3d
c0104820:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104825:	68 79 ba 10 c0       	push   $0xc010ba79
c010482a:	68 95 a9 10 c0       	push   $0xc010a995
c010482f:	e8 90 f5 ff ff       	call   c0103dc4 <print>
c0104834:	83 c4 20             	add    $0x20,%esp
c0104837:	e8 0e c6 ff ff       	call   c0100e4a <backtrace>
c010483c:	fa                   	cli    
c010483d:	f4                   	hlt    
    ASSERT_LIST(lst);
c010483e:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104844:	74 28                	je     c010486e <list_push_back+0x64>
c0104846:	83 ec 0c             	sub    $0xc,%esp
c0104849:	68 0c bc 10 c0       	push   $0xc010bc0c
c010484e:	6a 3e                	push   $0x3e
c0104850:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104855:	68 85 ba 10 c0       	push   $0xc010ba85
c010485a:	68 95 a9 10 c0       	push   $0xc010a995
c010485f:	e8 60 f5 ff ff       	call   c0103dc4 <print>
c0104864:	83 c4 20             	add    $0x20,%esp
c0104867:	e8 de c5 ff ff       	call   c0100e4a <backtrace>
c010486c:	fa                   	cli    
c010486d:	f4                   	hlt    

    struct listnode* newnode = listnode_create(newval);
c010486e:	83 ec 0c             	sub    $0xc,%esp
c0104871:	ff 75 0c             	pushl  0xc(%ebp)
c0104874:	e8 37 ff ff ff       	call   c01047b0 <listnode_create>
c0104879:	89 c6                	mov    %eax,%esi
    if (newnode == NULL)
c010487b:	83 c4 10             	add    $0x10,%esp
        return ENOMEM;
c010487e:	b8 02 00 00 00       	mov    $0x2,%eax
list_push_back(struct list* lst, void* newval) {
    assert(lst != NULL);
    ASSERT_LIST(lst);

    struct listnode* newnode = listnode_create(newval);
    if (newnode == NULL)
c0104883:	85 f6                	test   %esi,%esi
c0104885:	74 7c                	je     c0104903 <list_push_back+0xf9>
        return ENOMEM;
    ASSERT_LISTNODE(newnode);
c0104887:	81 3e 58 04 00 00    	cmpl   $0x458,(%esi)
c010488d:	74 28                	je     c01048b7 <list_push_back+0xad>
c010488f:	83 ec 0c             	sub    $0xc,%esp
c0104892:	68 0c bc 10 c0       	push   $0xc010bc0c
c0104897:	6a 43                	push   $0x43
c0104899:	68 6e ba 10 c0       	push   $0xc010ba6e
c010489e:	68 9f ba 10 c0       	push   $0xc010ba9f
c01048a3:	68 95 a9 10 c0       	push   $0xc010a995
c01048a8:	e8 17 f5 ff ff       	call   c0103dc4 <print>
c01048ad:	83 c4 20             	add    $0x20,%esp
c01048b0:	e8 95 c5 ff ff       	call   c0100e4a <backtrace>
c01048b5:	fa                   	cli    
c01048b6:	f4                   	hlt    

    if (lst->size == 0)
c01048b7:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
c01048bb:	75 05                	jne    c01048c2 <list_push_back+0xb8>
        lst->head = newnode;
c01048bd:	89 73 04             	mov    %esi,0x4(%ebx)
c01048c0:	eb 39                	jmp    c01048fb <list_push_back+0xf1>
    else {
        ASSERT_LISTNODE(lst->tail);
c01048c2:	8b 43 08             	mov    0x8(%ebx),%eax
c01048c5:	81 38 58 04 00 00    	cmpl   $0x458,(%eax)
c01048cb:	74 28                	je     c01048f5 <list_push_back+0xeb>
c01048cd:	83 ec 0c             	sub    $0xc,%esp
c01048d0:	68 0c bc 10 c0       	push   $0xc010bc0c
c01048d5:	6a 48                	push   $0x48
c01048d7:	68 6e ba 10 c0       	push   $0xc010ba6e
c01048dc:	68 c1 ba 10 c0       	push   $0xc010bac1
c01048e1:	68 95 a9 10 c0       	push   $0xc010a995
c01048e6:	e8 d9 f4 ff ff       	call   c0103dc4 <print>
c01048eb:	83 c4 20             	add    $0x20,%esp
c01048ee:	e8 57 c5 ff ff       	call   c0100e4a <backtrace>
c01048f3:	fa                   	cli    
c01048f4:	f4                   	hlt    
        lst->tail->next = newnode;
c01048f5:	8b 43 08             	mov    0x8(%ebx),%eax
c01048f8:	89 70 08             	mov    %esi,0x8(%eax)
    }
    lst->tail = newnode;
c01048fb:	89 73 08             	mov    %esi,0x8(%ebx)

    ++lst->size;
c01048fe:	ff 43 0c             	incl   0xc(%ebx)

    return 0;
c0104901:	31 c0                	xor    %eax,%eax
}
c0104903:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0104906:	5b                   	pop    %ebx
c0104907:	5e                   	pop    %esi
c0104908:	5d                   	pop    %ebp
c0104909:	c3                   	ret    

c010490a <list_pop_front>:

void
list_pop_front(struct list* lst) {
c010490a:	55                   	push   %ebp
c010490b:	89 e5                	mov    %esp,%ebp
c010490d:	56                   	push   %esi
c010490e:	53                   	push   %ebx
c010490f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104912:	85 db                	test   %ebx,%ebx
c0104914:	75 28                	jne    c010493e <list_pop_front+0x34>
c0104916:	83 ec 0c             	sub    $0xc,%esp
c0104919:	68 fc bb 10 c0       	push   $0xc010bbfc
c010491e:	6a 54                	push   $0x54
c0104920:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104925:	68 79 ba 10 c0       	push   $0xc010ba79
c010492a:	68 95 a9 10 c0       	push   $0xc010a995
c010492f:	e8 90 f4 ff ff       	call   c0103dc4 <print>
c0104934:	83 c4 20             	add    $0x20,%esp
c0104937:	e8 0e c5 ff ff       	call   c0100e4a <backtrace>
c010493c:	fa                   	cli    
c010493d:	f4                   	hlt    
    assert(lst->datatype == LISTTYPE);
c010493e:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104944:	74 28                	je     c010496e <list_pop_front+0x64>
c0104946:	83 ec 0c             	sub    $0xc,%esp
c0104949:	68 fc bb 10 c0       	push   $0xc010bbfc
c010494e:	6a 55                	push   $0x55
c0104950:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104955:	68 85 ba 10 c0       	push   $0xc010ba85
c010495a:	68 95 a9 10 c0       	push   $0xc010a995
c010495f:	e8 60 f4 ff ff       	call   c0103dc4 <print>
c0104964:	83 c4 20             	add    $0x20,%esp
c0104967:	e8 de c4 ff ff       	call   c0100e4a <backtrace>
c010496c:	fa                   	cli    
c010496d:	f4                   	hlt    

    if (lst->size == 0)
c010496e:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
c0104972:	74 56                	je     c01049ca <list_pop_front+0xc0>
        return;

    struct listnode* old_head = lst->head;
c0104974:	8b 73 04             	mov    0x4(%ebx),%esi
    ASSERT_LISTNODE(old_head);
c0104977:	81 3e 58 04 00 00    	cmpl   $0x458,(%esi)
c010497d:	74 28                	je     c01049a7 <list_pop_front+0x9d>
c010497f:	83 ec 0c             	sub    $0xc,%esp
c0104982:	68 fc bb 10 c0       	push   $0xc010bbfc
c0104987:	6a 5b                	push   $0x5b
c0104989:	68 6e ba 10 c0       	push   $0xc010ba6e
c010498e:	68 e5 ba 10 c0       	push   $0xc010bae5
c0104993:	68 95 a9 10 c0       	push   $0xc010a995
c0104998:	e8 27 f4 ff ff       	call   c0103dc4 <print>
c010499d:	83 c4 20             	add    $0x20,%esp
c01049a0:	e8 a5 c4 ff ff       	call   c0100e4a <backtrace>
c01049a5:	fa                   	cli    
c01049a6:	f4                   	hlt    
    lst->head = lst->head->next;
c01049a7:	8b 43 04             	mov    0x4(%ebx),%eax
c01049aa:	8b 40 08             	mov    0x8(%eax),%eax
c01049ad:	89 43 04             	mov    %eax,0x4(%ebx)
    --lst->size;

    if (lst->size == 0)
c01049b0:	ff 4b 0c             	decl   0xc(%ebx)
c01049b3:	75 07                	jne    c01049bc <list_pop_front+0xb2>
        lst->tail = NULL;
c01049b5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

    kfree(old_head);
c01049bc:	89 75 08             	mov    %esi,0x8(%ebp)
}
c01049bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01049c2:	5b                   	pop    %ebx
c01049c3:	5e                   	pop    %esi
c01049c4:	5d                   	pop    %ebp
    --lst->size;

    if (lst->size == 0)
        lst->tail = NULL;

    kfree(old_head);
c01049c5:	e9 a7 cf ff ff       	jmp    c0101971 <kfree>
}
c01049ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01049cd:	5b                   	pop    %ebx
c01049ce:	5e                   	pop    %esi
c01049cf:	5d                   	pop    %ebp
c01049d0:	c3                   	ret    

c01049d1 <list_front>:

void*
list_front(struct list* lst) {
c01049d1:	55                   	push   %ebp
c01049d2:	89 e5                	mov    %esp,%ebp
c01049d4:	53                   	push   %ebx
c01049d5:	50                   	push   %eax
c01049d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c01049d9:	85 db                	test   %ebx,%ebx
c01049db:	75 28                	jne    c0104a05 <list_front+0x34>
c01049dd:	83 ec 0c             	sub    $0xc,%esp
c01049e0:	68 f0 bb 10 c0       	push   $0xc010bbf0
c01049e5:	6a 67                	push   $0x67
c01049e7:	68 6e ba 10 c0       	push   $0xc010ba6e
c01049ec:	68 79 ba 10 c0       	push   $0xc010ba79
c01049f1:	68 95 a9 10 c0       	push   $0xc010a995
c01049f6:	e8 c9 f3 ff ff       	call   c0103dc4 <print>
c01049fb:	83 c4 20             	add    $0x20,%esp
c01049fe:	e8 47 c4 ff ff       	call   c0100e4a <backtrace>
c0104a03:	fa                   	cli    
c0104a04:	f4                   	hlt    
    ASSERT_LIST(lst);
c0104a05:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104a0b:	74 28                	je     c0104a35 <list_front+0x64>
c0104a0d:	83 ec 0c             	sub    $0xc,%esp
c0104a10:	68 f0 bb 10 c0       	push   $0xc010bbf0
c0104a15:	6a 68                	push   $0x68
c0104a17:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104a1c:	68 85 ba 10 c0       	push   $0xc010ba85
c0104a21:	68 95 a9 10 c0       	push   $0xc010a995
c0104a26:	e8 99 f3 ff ff       	call   c0103dc4 <print>
c0104a2b:	83 c4 20             	add    $0x20,%esp
c0104a2e:	e8 17 c4 ff ff       	call   c0100e4a <backtrace>
c0104a33:	fa                   	cli    
c0104a34:	f4                   	hlt    

    if (lst->size == 0)
        return NULL;
c0104a35:	31 c0                	xor    %eax,%eax
void*
list_front(struct list* lst) {
    assert(lst != NULL);
    ASSERT_LIST(lst);

    if (lst->size == 0)
c0104a37:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
c0104a3b:	74 67                	je     c0104aa4 <list_front+0xd3>
        return NULL;

    assert(lst->head != NULL);
c0104a3d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
c0104a41:	75 28                	jne    c0104a6b <list_front+0x9a>
c0104a43:	83 ec 0c             	sub    $0xc,%esp
c0104a46:	68 f0 bb 10 c0       	push   $0xc010bbf0
c0104a4b:	6a 6d                	push   $0x6d
c0104a4d:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104a52:	68 08 bb 10 c0       	push   $0xc010bb08
c0104a57:	68 95 a9 10 c0       	push   $0xc010a995
c0104a5c:	e8 63 f3 ff ff       	call   c0103dc4 <print>
c0104a61:	83 c4 20             	add    $0x20,%esp
c0104a64:	e8 e1 c3 ff ff       	call   c0100e4a <backtrace>
c0104a69:	fa                   	cli    
c0104a6a:	f4                   	hlt    
    ASSERT_LISTNODE(lst->head);
c0104a6b:	8b 43 04             	mov    0x4(%ebx),%eax
c0104a6e:	81 38 58 04 00 00    	cmpl   $0x458,(%eax)
c0104a74:	74 28                	je     c0104a9e <list_front+0xcd>
c0104a76:	83 ec 0c             	sub    $0xc,%esp
c0104a79:	68 f0 bb 10 c0       	push   $0xc010bbf0
c0104a7e:	6a 6e                	push   $0x6e
c0104a80:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104a85:	68 1a bb 10 c0       	push   $0xc010bb1a
c0104a8a:	68 95 a9 10 c0       	push   $0xc010a995
c0104a8f:	e8 30 f3 ff ff       	call   c0103dc4 <print>
c0104a94:	83 c4 20             	add    $0x20,%esp
c0104a97:	e8 ae c3 ff ff       	call   c0100e4a <backtrace>
c0104a9c:	fa                   	cli    
c0104a9d:	f4                   	hlt    
    return lst->head->val;
c0104a9e:	8b 43 04             	mov    0x4(%ebx),%eax
c0104aa1:	8b 40 04             	mov    0x4(%eax),%eax
}
c0104aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104aa7:	c9                   	leave  
c0104aa8:	c3                   	ret    

c0104aa9 <list_find>:

void*
list_find(struct list* lst, void* query_val, int(*comparator)(void* left, void* right)) {
c0104aa9:	55                   	push   %ebp
c0104aaa:	89 e5                	mov    %esp,%ebp
c0104aac:	53                   	push   %ebx
c0104aad:	52                   	push   %edx
c0104aae:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104ab1:	85 db                	test   %ebx,%ebx
c0104ab3:	75 28                	jne    c0104add <list_find+0x34>
c0104ab5:	83 ec 0c             	sub    $0xc,%esp
c0104ab8:	68 e4 bb 10 c0       	push   $0xc010bbe4
c0104abd:	6a 74                	push   $0x74
c0104abf:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104ac4:	68 79 ba 10 c0       	push   $0xc010ba79
c0104ac9:	68 95 a9 10 c0       	push   $0xc010a995
c0104ace:	e8 f1 f2 ff ff       	call   c0103dc4 <print>
c0104ad3:	83 c4 20             	add    $0x20,%esp
c0104ad6:	e8 6f c3 ff ff       	call   c0100e4a <backtrace>
c0104adb:	fa                   	cli    
c0104adc:	f4                   	hlt    
    ASSERT_LIST(lst);
c0104add:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104ae3:	74 28                	je     c0104b0d <list_find+0x64>
c0104ae5:	83 ec 0c             	sub    $0xc,%esp
c0104ae8:	68 e4 bb 10 c0       	push   $0xc010bbe4
c0104aed:	6a 75                	push   $0x75
c0104aef:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104af4:	68 85 ba 10 c0       	push   $0xc010ba85
c0104af9:	68 95 a9 10 c0       	push   $0xc010a995
c0104afe:	e8 c1 f2 ff ff       	call   c0103dc4 <print>
c0104b03:	83 c4 20             	add    $0x20,%esp
c0104b06:	e8 3f c3 ff ff       	call   c0100e4a <backtrace>
c0104b0b:	fa                   	cli    
c0104b0c:	f4                   	hlt    

    struct listnode* p = lst->head;
c0104b0d:	8b 5b 04             	mov    0x4(%ebx),%ebx
    while (p) {
c0104b10:	85 db                	test   %ebx,%ebx
c0104b12:	74 4c                	je     c0104b60 <list_find+0xb7>
        ASSERT_LISTNODE(p);
c0104b14:	81 3b 58 04 00 00    	cmpl   $0x458,(%ebx)
c0104b1a:	74 28                	je     c0104b44 <list_find+0x9b>
c0104b1c:	83 ec 0c             	sub    $0xc,%esp
c0104b1f:	68 e4 bb 10 c0       	push   $0xc010bbe4
c0104b24:	6a 79                	push   $0x79
c0104b26:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104b2b:	68 3e bb 10 c0       	push   $0xc010bb3e
c0104b30:	68 95 a9 10 c0       	push   $0xc010a995
c0104b35:	e8 8a f2 ff ff       	call   c0103dc4 <print>
c0104b3a:	83 c4 20             	add    $0x20,%esp
c0104b3d:	e8 08 c3 ff ff       	call   c0100e4a <backtrace>
c0104b42:	fa                   	cli    
c0104b43:	f4                   	hlt    
        if (comparator(p->val, query_val) == 0)
c0104b44:	50                   	push   %eax
c0104b45:	50                   	push   %eax
c0104b46:	ff 75 0c             	pushl  0xc(%ebp)
c0104b49:	ff 73 04             	pushl  0x4(%ebx)
c0104b4c:	ff 55 10             	call   *0x10(%ebp)
c0104b4f:	83 c4 10             	add    $0x10,%esp
c0104b52:	85 c0                	test   %eax,%eax
c0104b54:	75 05                	jne    c0104b5b <list_find+0xb2>
            return p->val;
c0104b56:	8b 43 04             	mov    0x4(%ebx),%eax
c0104b59:	eb 07                	jmp    c0104b62 <list_find+0xb9>
        p = p->next;
c0104b5b:	8b 5b 08             	mov    0x8(%ebx),%ebx
c0104b5e:	eb b0                	jmp    c0104b10 <list_find+0x67>
    }
    return NULL;
c0104b60:	31 c0                	xor    %eax,%eax
}
c0104b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104b65:	c9                   	leave  
c0104b66:	c3                   	ret    

c0104b67 <list_remove>:

void*
list_remove(struct list* lst, void* query_val, int(*comparator)(void* left, void* right)) {
c0104b67:	55                   	push   %ebp
c0104b68:	89 e5                	mov    %esp,%ebp
c0104b6a:	57                   	push   %edi
c0104b6b:	56                   	push   %esi
c0104b6c:	53                   	push   %ebx
c0104b6d:	83 ec 0c             	sub    $0xc,%esp
c0104b70:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104b73:	85 db                	test   %ebx,%ebx
c0104b75:	75 2b                	jne    c0104ba2 <list_remove+0x3b>
c0104b77:	83 ec 0c             	sub    $0xc,%esp
c0104b7a:	68 d8 bb 10 c0       	push   $0xc010bbd8
c0104b7f:	68 83 00 00 00       	push   $0x83
c0104b84:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104b89:	68 79 ba 10 c0       	push   $0xc010ba79
c0104b8e:	68 95 a9 10 c0       	push   $0xc010a995
c0104b93:	e8 2c f2 ff ff       	call   c0103dc4 <print>
c0104b98:	83 c4 20             	add    $0x20,%esp
c0104b9b:	e8 aa c2 ff ff       	call   c0100e4a <backtrace>
c0104ba0:	fa                   	cli    
c0104ba1:	f4                   	hlt    
    ASSERT_LIST(lst);
c0104ba2:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104ba8:	74 2b                	je     c0104bd5 <list_remove+0x6e>
c0104baa:	83 ec 0c             	sub    $0xc,%esp
c0104bad:	68 d8 bb 10 c0       	push   $0xc010bbd8
c0104bb2:	68 84 00 00 00       	push   $0x84
c0104bb7:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104bbc:	68 85 ba 10 c0       	push   $0xc010ba85
c0104bc1:	68 95 a9 10 c0       	push   $0xc010a995
c0104bc6:	e8 f9 f1 ff ff       	call   c0103dc4 <print>
c0104bcb:	83 c4 20             	add    $0x20,%esp
c0104bce:	e8 77 c2 ff ff       	call   c0100e4a <backtrace>
c0104bd3:	fa                   	cli    
c0104bd4:	f4                   	hlt    

    void* res = NULL;
    struct listnode* p;
    struct listnode* q = NULL;
    for (p = lst->head; p != NULL; q = p, p = p->next) {
c0104bd5:	8b 73 04             	mov    0x4(%ebx),%esi
    assert(lst != NULL);
    ASSERT_LIST(lst);

    void* res = NULL;
    struct listnode* p;
    struct listnode* q = NULL;
c0104bd8:	31 ff                	xor    %edi,%edi
    for (p = lst->head; p != NULL; q = p, p = p->next) {
c0104bda:	85 f6                	test   %esi,%esi
c0104bdc:	74 76                	je     c0104c54 <list_remove+0xed>
        ASSERT_LISTNODE(p);
c0104bde:	81 3e 58 04 00 00    	cmpl   $0x458,(%esi)
c0104be4:	74 2b                	je     c0104c11 <list_remove+0xaa>
c0104be6:	83 ec 0c             	sub    $0xc,%esp
c0104be9:	68 d8 bb 10 c0       	push   $0xc010bbd8
c0104bee:	68 8a 00 00 00       	push   $0x8a
c0104bf3:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104bf8:	68 3e bb 10 c0       	push   $0xc010bb3e
c0104bfd:	68 95 a9 10 c0       	push   $0xc010a995
c0104c02:	e8 bd f1 ff ff       	call   c0103dc4 <print>
c0104c07:	83 c4 20             	add    $0x20,%esp
c0104c0a:	e8 3b c2 ff ff       	call   c0100e4a <backtrace>
c0104c0f:	fa                   	cli    
c0104c10:	f4                   	hlt    
        if (comparator(p->val, query_val) == 0) {
c0104c11:	50                   	push   %eax
c0104c12:	50                   	push   %eax
c0104c13:	ff 75 0c             	pushl  0xc(%ebp)
c0104c16:	ff 76 04             	pushl  0x4(%esi)
c0104c19:	ff 55 10             	call   *0x10(%ebp)
c0104c1c:	83 c4 10             	add    $0x10,%esp
c0104c1f:	85 c0                	test   %eax,%eax
c0104c21:	8b 46 08             	mov    0x8(%esi),%eax
c0104c24:	75 28                	jne    c0104c4e <list_remove+0xe7>
            if (q == NULL) {
c0104c26:	85 ff                	test   %edi,%edi
c0104c28:	75 05                	jne    c0104c2f <list_remove+0xc8>
                /* Removing from head */
                lst->head = p->next;
c0104c2a:	89 43 04             	mov    %eax,0x4(%ebx)
c0104c2d:	eb 03                	jmp    c0104c32 <list_remove+0xcb>
            } else {
                /* Removing after head. */
                q->next = p->next;
c0104c2f:	89 47 08             	mov    %eax,0x8(%edi)
            }
            if (p == lst->tail)
c0104c32:	3b 73 08             	cmp    0x8(%ebx),%esi
c0104c35:	75 03                	jne    c0104c3a <list_remove+0xd3>
                lst->tail = q;
c0104c37:	89 7b 08             	mov    %edi,0x8(%ebx)
            res = p->val;
c0104c3a:	8b 7e 04             	mov    0x4(%esi),%edi
            kfree(p);
c0104c3d:	83 ec 0c             	sub    $0xc,%esp
c0104c40:	56                   	push   %esi
c0104c41:	e8 2b cd ff ff       	call   c0101971 <kfree>
            --lst->size;
c0104c46:	ff 4b 0c             	decl   0xc(%ebx)
            break;
c0104c49:	83 c4 10             	add    $0x10,%esp
c0104c4c:	eb 08                	jmp    c0104c56 <list_remove+0xef>
    ASSERT_LIST(lst);

    void* res = NULL;
    struct listnode* p;
    struct listnode* q = NULL;
    for (p = lst->head; p != NULL; q = p, p = p->next) {
c0104c4e:	89 f7                	mov    %esi,%edi
c0104c50:	89 c6                	mov    %eax,%esi
c0104c52:	eb 86                	jmp    c0104bda <list_remove+0x73>
void*
list_remove(struct list* lst, void* query_val, int(*comparator)(void* left, void* right)) {
    assert(lst != NULL);
    ASSERT_LIST(lst);

    void* res = NULL;
c0104c54:	31 ff                	xor    %edi,%edi
            kfree(p);
            --lst->size;
            break;
        }
    }
    if (lst->size == 0)
c0104c56:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
c0104c5a:	75 07                	jne    c0104c63 <list_remove+0xfc>
        lst->tail = NULL;
c0104c5c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return res;
}
c0104c63:	89 f8                	mov    %edi,%eax
c0104c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104c68:	5b                   	pop    %ebx
c0104c69:	5e                   	pop    %esi
c0104c6a:	5f                   	pop    %edi
c0104c6b:	5d                   	pop    %ebp
c0104c6c:	c3                   	ret    

c0104c6d <list_isempty>:

int
list_isempty(struct list* lst) {
c0104c6d:	55                   	push   %ebp
c0104c6e:	89 e5                	mov    %esp,%ebp
c0104c70:	53                   	push   %ebx
c0104c71:	50                   	push   %eax
c0104c72:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104c75:	85 db                	test   %ebx,%ebx
c0104c77:	75 2b                	jne    c0104ca4 <list_isempty+0x37>
c0104c79:	83 ec 0c             	sub    $0xc,%esp
c0104c7c:	68 c8 bb 10 c0       	push   $0xc010bbc8
c0104c81:	68 a2 00 00 00       	push   $0xa2
c0104c86:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104c8b:	68 79 ba 10 c0       	push   $0xc010ba79
c0104c90:	68 95 a9 10 c0       	push   $0xc010a995
c0104c95:	e8 2a f1 ff ff       	call   c0103dc4 <print>
c0104c9a:	83 c4 20             	add    $0x20,%esp
c0104c9d:	e8 a8 c1 ff ff       	call   c0100e4a <backtrace>
c0104ca2:	fa                   	cli    
c0104ca3:	f4                   	hlt    
    ASSERT_LIST(lst);
c0104ca4:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104caa:	74 2b                	je     c0104cd7 <list_isempty+0x6a>
c0104cac:	83 ec 0c             	sub    $0xc,%esp
c0104caf:	68 c8 bb 10 c0       	push   $0xc010bbc8
c0104cb4:	68 a3 00 00 00       	push   $0xa3
c0104cb9:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104cbe:	68 85 ba 10 c0       	push   $0xc010ba85
c0104cc3:	68 95 a9 10 c0       	push   $0xc010a995
c0104cc8:	e8 f7 f0 ff ff       	call   c0103dc4 <print>
c0104ccd:	83 c4 20             	add    $0x20,%esp
c0104cd0:	e8 75 c1 ff ff       	call   c0100e4a <backtrace>
c0104cd5:	fa                   	cli    
c0104cd6:	f4                   	hlt    

    return (lst->size == 0);
c0104cd7:	31 c0                	xor    %eax,%eax
c0104cd9:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
c0104cdd:	0f 94 c0             	sete   %al
}
c0104ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104ce3:	c9                   	leave  
c0104ce4:	c3                   	ret    

c0104ce5 <list_getsize>:

unsigned int
list_getsize(struct list* lst) {
c0104ce5:	55                   	push   %ebp
c0104ce6:	89 e5                	mov    %esp,%ebp
c0104ce8:	53                   	push   %ebx
c0104ce9:	50                   	push   %eax
c0104cea:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104ced:	85 db                	test   %ebx,%ebx
c0104cef:	75 2b                	jne    c0104d1c <list_getsize+0x37>
c0104cf1:	83 ec 0c             	sub    $0xc,%esp
c0104cf4:	68 b8 bb 10 c0       	push   $0xc010bbb8
c0104cf9:	68 aa 00 00 00       	push   $0xaa
c0104cfe:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104d03:	68 79 ba 10 c0       	push   $0xc010ba79
c0104d08:	68 95 a9 10 c0       	push   $0xc010a995
c0104d0d:	e8 b2 f0 ff ff       	call   c0103dc4 <print>
c0104d12:	83 c4 20             	add    $0x20,%esp
c0104d15:	e8 30 c1 ff ff       	call   c0100e4a <backtrace>
c0104d1a:	fa                   	cli    
c0104d1b:	f4                   	hlt    
    ASSERT_LIST(lst);
c0104d1c:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104d22:	74 2b                	je     c0104d4f <list_getsize+0x6a>
c0104d24:	83 ec 0c             	sub    $0xc,%esp
c0104d27:	68 b8 bb 10 c0       	push   $0xc010bbb8
c0104d2c:	68 ab 00 00 00       	push   $0xab
c0104d31:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104d36:	68 85 ba 10 c0       	push   $0xc010ba85
c0104d3b:	68 95 a9 10 c0       	push   $0xc010a995
c0104d40:	e8 7f f0 ff ff       	call   c0103dc4 <print>
c0104d45:	83 c4 20             	add    $0x20,%esp
c0104d48:	e8 fd c0 ff ff       	call   c0100e4a <backtrace>
c0104d4d:	fa                   	cli    
c0104d4e:	f4                   	hlt    

    return (lst->size);
c0104d4f:	8b 43 0c             	mov    0xc(%ebx),%eax
}
c0104d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104d55:	c9                   	leave  
c0104d56:	c3                   	ret    

c0104d57 <list_destroy>:

void
list_destroy(struct list* lst) {
c0104d57:	55                   	push   %ebp
c0104d58:	89 e5                	mov    %esp,%ebp
c0104d5a:	57                   	push   %edi
c0104d5b:	56                   	push   %esi
c0104d5c:	53                   	push   %ebx
c0104d5d:	83 ec 0c             	sub    $0xc,%esp
c0104d60:	8b 75 08             	mov    0x8(%ebp),%esi
    if (lst != NULL) {
c0104d63:	85 f6                	test   %esi,%esi
c0104d65:	75 0f                	jne    c0104d76 <list_destroy+0x1f>
            kfree(p);
            p = q;
        }
    }
    /* frees the list object itself */
    kfree(lst);
c0104d67:	89 75 08             	mov    %esi,0x8(%ebp)
}
c0104d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104d6d:	5b                   	pop    %ebx
c0104d6e:	5e                   	pop    %esi
c0104d6f:	5f                   	pop    %edi
c0104d70:	5d                   	pop    %ebp
            kfree(p);
            p = q;
        }
    }
    /* frees the list object itself */
    kfree(lst);
c0104d71:	e9 fb cb ff ff       	jmp    c0101971 <kfree>
}

void
list_destroy(struct list* lst) {
    if (lst != NULL) {
        ASSERT_LIST(lst);
c0104d76:	81 3e 57 04 00 00    	cmpl   $0x457,(%esi)
c0104d7c:	74 2b                	je     c0104da9 <list_destroy+0x52>
c0104d7e:	83 ec 0c             	sub    $0xc,%esp
c0104d81:	68 a8 bb 10 c0       	push   $0xc010bba8
c0104d86:	68 b3 00 00 00       	push   $0xb3
c0104d8b:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104d90:	68 85 ba 10 c0       	push   $0xc010ba85
c0104d95:	68 95 a9 10 c0       	push   $0xc010a995
c0104d9a:	e8 25 f0 ff ff       	call   c0103dc4 <print>
c0104d9f:	83 c4 20             	add    $0x20,%esp
c0104da2:	e8 a3 c0 ff ff       	call   c0100e4a <backtrace>
c0104da7:	fa                   	cli    
c0104da8:	f4                   	hlt    

        struct listnode* p = lst->head;
c0104da9:	8b 5e 04             	mov    0x4(%esi),%ebx
        struct listnode* q;
        /* frees every listnode object in the list */
        while (p != NULL) {
c0104dac:	85 db                	test   %ebx,%ebx
c0104dae:	74 b7                	je     c0104d67 <list_destroy+0x10>
            ASSERT_LISTNODE(p);
c0104db0:	81 3b 58 04 00 00    	cmpl   $0x458,(%ebx)
c0104db6:	74 2b                	je     c0104de3 <list_destroy+0x8c>
c0104db8:	83 ec 0c             	sub    $0xc,%esp
c0104dbb:	68 a8 bb 10 c0       	push   $0xc010bba8
c0104dc0:	68 b9 00 00 00       	push   $0xb9
c0104dc5:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104dca:	68 3e bb 10 c0       	push   $0xc010bb3e
c0104dcf:	68 95 a9 10 c0       	push   $0xc010a995
c0104dd4:	e8 eb ef ff ff       	call   c0103dc4 <print>
c0104dd9:	83 c4 20             	add    $0x20,%esp
c0104ddc:	e8 69 c0 ff ff       	call   c0100e4a <backtrace>
c0104de1:	fa                   	cli    
c0104de2:	f4                   	hlt    
            q = p->next;
c0104de3:	8b 7b 08             	mov    0x8(%ebx),%edi
            kfree(p);
c0104de6:	83 ec 0c             	sub    $0xc,%esp
c0104de9:	53                   	push   %ebx
c0104dea:	e8 82 cb ff ff       	call   c0101971 <kfree>
c0104def:	83 c4 10             	add    $0x10,%esp
            p = q;
c0104df2:	89 fb                	mov    %edi,%ebx
c0104df4:	eb b6                	jmp    c0104dac <list_destroy+0x55>

c0104df6 <list_assertvalid>:
    /* frees the list object itself */
    kfree(lst);
}

void
list_assertvalid(struct list* lst) {
c0104df6:	55                   	push   %ebp
c0104df7:	89 e5                	mov    %esp,%ebp
c0104df9:	57                   	push   %edi
c0104dfa:	56                   	push   %esi
c0104dfb:	53                   	push   %ebx
c0104dfc:	83 ec 0c             	sub    $0xc,%esp
c0104dff:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(lst != NULL);
c0104e02:	85 db                	test   %ebx,%ebx
c0104e04:	75 2b                	jne    c0104e31 <list_assertvalid+0x3b>
c0104e06:	83 ec 0c             	sub    $0xc,%esp
c0104e09:	68 94 bb 10 c0       	push   $0xc010bb94
c0104e0e:	68 c5 00 00 00       	push   $0xc5
c0104e13:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104e18:	68 79 ba 10 c0       	push   $0xc010ba79
c0104e1d:	68 95 a9 10 c0       	push   $0xc010a995
c0104e22:	e8 9d ef ff ff       	call   c0103dc4 <print>
c0104e27:	83 c4 20             	add    $0x20,%esp
c0104e2a:	e8 1b c0 ff ff       	call   c0100e4a <backtrace>
c0104e2f:	fa                   	cli    
c0104e30:	f4                   	hlt    
    ASSERT_LIST(lst);
c0104e31:	81 3b 57 04 00 00    	cmpl   $0x457,(%ebx)
c0104e37:	74 2b                	je     c0104e64 <list_assertvalid+0x6e>
c0104e39:	83 ec 0c             	sub    $0xc,%esp
c0104e3c:	68 94 bb 10 c0       	push   $0xc010bb94
c0104e41:	68 c6 00 00 00       	push   $0xc6
c0104e46:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104e4b:	68 85 ba 10 c0       	push   $0xc010ba85
c0104e50:	68 95 a9 10 c0       	push   $0xc010a995
c0104e55:	e8 6a ef ff ff       	call   c0103dc4 <print>
c0104e5a:	83 c4 20             	add    $0x20,%esp
c0104e5d:	e8 e8 bf ff ff       	call   c0100e4a <backtrace>
c0104e62:	fa                   	cli    
c0104e63:	f4                   	hlt    
    /* Validate if the stated number of items in the list is correct. */
    unsigned int count = 0;
    struct listnode* p;
    struct listnode* prev = NULL;
    for (p = lst->head; p != NULL; p = p->next) {
c0104e64:	8b 73 04             	mov    0x4(%ebx),%esi
    assert(lst != NULL);
    ASSERT_LIST(lst);
    /* Validate if the stated number of items in the list is correct. */
    unsigned int count = 0;
    struct listnode* p;
    struct listnode* prev = NULL;
c0104e67:	31 c0                	xor    %eax,%eax
void
list_assertvalid(struct list* lst) {
    assert(lst != NULL);
    ASSERT_LIST(lst);
    /* Validate if the stated number of items in the list is correct. */
    unsigned int count = 0;
c0104e69:	31 ff                	xor    %edi,%edi
    struct listnode* p;
    struct listnode* prev = NULL;
    for (p = lst->head; p != NULL; p = p->next) {
c0104e6b:	85 f6                	test   %esi,%esi
c0104e6d:	74 3b                	je     c0104eaa <list_assertvalid+0xb4>
        ASSERT_LISTNODE(p);
c0104e6f:	81 3e 58 04 00 00    	cmpl   $0x458,(%esi)
c0104e75:	74 2b                	je     c0104ea2 <list_assertvalid+0xac>
c0104e77:	83 ec 0c             	sub    $0xc,%esp
c0104e7a:	68 94 bb 10 c0       	push   $0xc010bb94
c0104e7f:	68 cc 00 00 00       	push   $0xcc
c0104e84:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104e89:	68 3e bb 10 c0       	push   $0xc010bb3e
c0104e8e:	68 95 a9 10 c0       	push   $0xc010a995
c0104e93:	e8 2c ef ff ff       	call   c0103dc4 <print>
c0104e98:	83 c4 20             	add    $0x20,%esp
c0104e9b:	e8 aa bf ff ff       	call   c0100e4a <backtrace>
c0104ea0:	fa                   	cli    
c0104ea1:	f4                   	hlt    
        ++count;
c0104ea2:	47                   	inc    %edi
    ASSERT_LIST(lst);
    /* Validate if the stated number of items in the list is correct. */
    unsigned int count = 0;
    struct listnode* p;
    struct listnode* prev = NULL;
    for (p = lst->head; p != NULL; p = p->next) {
c0104ea3:	89 f0                	mov    %esi,%eax
c0104ea5:	8b 76 08             	mov    0x8(%esi),%esi
c0104ea8:	eb c1                	jmp    c0104e6b <list_assertvalid+0x75>
        ASSERT_LISTNODE(p);
        ++count;
        prev = p;
    }
    /* Validate if the tail is reachable from the head. */
    if (count == 0)
c0104eaa:	85 ff                	test   %edi,%edi
c0104eac:	75 1f                	jne    c0104ecd <list_assertvalid+0xd7>
        assert(lst->tail == NULL);
c0104eae:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c0104eb2:	74 49                	je     c0104efd <list_assertvalid+0x107>
c0104eb4:	83 ec 0c             	sub    $0xc,%esp
c0104eb7:	68 94 bb 10 c0       	push   $0xc010bb94
c0104ebc:	68 d2 00 00 00       	push   $0xd2
c0104ec1:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104ec6:	68 5a bb 10 c0       	push   $0xc010bb5a
c0104ecb:	eb 1c                	jmp    c0104ee9 <list_assertvalid+0xf3>
    else
        assert(prev == lst->tail);
c0104ecd:	3b 43 08             	cmp    0x8(%ebx),%eax
c0104ed0:	74 2b                	je     c0104efd <list_assertvalid+0x107>
c0104ed2:	83 ec 0c             	sub    $0xc,%esp
c0104ed5:	68 94 bb 10 c0       	push   $0xc010bb94
c0104eda:	68 d4 00 00 00       	push   $0xd4
c0104edf:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104ee4:	68 6c bb 10 c0       	push   $0xc010bb6c
c0104ee9:	68 95 a9 10 c0       	push   $0xc010a995
c0104eee:	e8 d1 ee ff ff       	call   c0103dc4 <print>
c0104ef3:	83 c4 20             	add    $0x20,%esp
c0104ef6:	e8 4f bf ff ff       	call   c0100e4a <backtrace>
c0104efb:	fa                   	cli    
c0104efc:	f4                   	hlt    
    assert(count == lst->size);
c0104efd:	3b 7b 0c             	cmp    0xc(%ebx),%edi
c0104f00:	74 2b                	je     c0104f2d <list_assertvalid+0x137>
c0104f02:	83 ec 0c             	sub    $0xc,%esp
c0104f05:	68 94 bb 10 c0       	push   $0xc010bb94
c0104f0a:	68 d5 00 00 00       	push   $0xd5
c0104f0f:	68 6e ba 10 c0       	push   $0xc010ba6e
c0104f14:	68 7e bb 10 c0       	push   $0xc010bb7e
c0104f19:	68 95 a9 10 c0       	push   $0xc010a995
c0104f1e:	e8 a1 ee ff ff       	call   c0103dc4 <print>
c0104f23:	83 c4 20             	add    $0x20,%esp
c0104f26:	e8 1f bf ff ff       	call   c0100e4a <backtrace>
c0104f2b:	fa                   	cli    
c0104f2c:	f4                   	hlt    
}
c0104f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104f30:	5b                   	pop    %ebx
c0104f31:	5e                   	pop    %esi
c0104f32:	5f                   	pop    %edi
c0104f33:	5d                   	pop    %ebp
c0104f34:	c3                   	ret    

c0104f35 <bitmap_create>:
    size_t bits;
    uint8_t* bytes;
};

struct bitmap*
bitmap_create(uint32_t bits) {
c0104f35:	55                   	push   %ebp
c0104f36:	89 e5                	mov    %esp,%ebp
c0104f38:	57                   	push   %edi
c0104f39:	56                   	push   %esi
c0104f3a:	53                   	push   %ebx
c0104f3b:	83 ec 28             	sub    $0x28,%esp
c0104f3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct bitmap* b = kmalloc(sizeof(struct bitmap));
c0104f41:	6a 08                	push   $0x8
c0104f43:	e8 5d c9 ff ff       	call   c01018a5 <kmalloc>
c0104f48:	89 c7                	mov    %eax,%edi
    if (b == NULL)
c0104f4a:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0104f4d:	31 c0                	xor    %eax,%eax
};

struct bitmap*
bitmap_create(uint32_t bits) {
    struct bitmap* b = kmalloc(sizeof(struct bitmap));
    if (b == NULL)
c0104f4f:	85 ff                	test   %edi,%edi
c0104f51:	0f 84 d4 00 00 00    	je     c010502b <bitmap_create+0xf6>
        return NULL;

    uint32_t bytes = DIVROUNDUP(bits, 8);
c0104f57:	8d 73 07             	lea    0x7(%ebx),%esi
c0104f5a:	c1 ee 03             	shr    $0x3,%esi
    b->bytes = kmalloc(bytes);
c0104f5d:	83 ec 0c             	sub    $0xc,%esp
c0104f60:	56                   	push   %esi
c0104f61:	e8 3f c9 ff ff       	call   c01018a5 <kmalloc>
c0104f66:	89 47 04             	mov    %eax,0x4(%edi)
    if (b->bytes == NULL) {
c0104f69:	83 c4 10             	add    $0x10,%esp
c0104f6c:	85 c0                	test   %eax,%eax
c0104f6e:	75 13                	jne    c0104f83 <bitmap_create+0x4e>
        kfree(b);
c0104f70:	83 ec 0c             	sub    $0xc,%esp
c0104f73:	57                   	push   %edi
c0104f74:	e8 f8 c9 ff ff       	call   c0101971 <kfree>
        return NULL;
c0104f79:	83 c4 10             	add    $0x10,%esp
c0104f7c:	31 c0                	xor    %eax,%eax
c0104f7e:	e9 a8 00 00 00       	jmp    c010502b <bitmap_create+0xf6>
    }

    memset(b->bytes, 0, bytes * sizeof(uint8_t));
c0104f83:	52                   	push   %edx
c0104f84:	56                   	push   %esi
c0104f85:	6a 00                	push   $0x0
c0104f87:	50                   	push   %eax
c0104f88:	e8 2f f5 ff ff       	call   c01044bc <memset>
    b->bits = bits;
c0104f8d:	89 1f                	mov    %ebx,(%edi)

    // extra bits (greater than @bits) at the end get marked
    if (bytes > bits >> 3) {
c0104f8f:	89 da                	mov    %ebx,%edx
c0104f91:	c1 ea 03             	shr    $0x3,%edx
c0104f94:	83 c4 10             	add    $0x10,%esp
c0104f97:	89 f8                	mov    %edi,%eax
c0104f99:	39 d6                	cmp    %edx,%esi
c0104f9b:	0f 86 8a 00 00 00    	jbe    c010502b <bitmap_create+0xf6>
        uint32_t i = bytes - 1;
c0104fa1:	4e                   	dec    %esi
        assert(bits >> 3 == i);
c0104fa2:	39 f2                	cmp    %esi,%edx
c0104fa4:	74 28                	je     c0104fce <bitmap_create+0x99>
c0104fa6:	83 ec 0c             	sub    $0xc,%esp
c0104fa9:	68 e4 bc 10 c0       	push   $0xc010bce4
c0104fae:	6a 20                	push   $0x20
c0104fb0:	68 1b bc 10 c0       	push   $0xc010bc1b
c0104fb5:	68 28 bc 10 c0       	push   $0xc010bc28
c0104fba:	68 95 a9 10 c0       	push   $0xc010a995
c0104fbf:	e8 00 ee ff ff       	call   c0103dc4 <print>
c0104fc4:	83 c4 20             	add    $0x20,%esp
c0104fc7:	e8 7e be ff ff       	call   c0100e4a <backtrace>
c0104fcc:	fa                   	cli    
c0104fcd:	f4                   	hlt    

        uint32_t extra = bits - (i << 3);
c0104fce:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
c0104fd5:	29 c3                	sub    %eax,%ebx
        assert(extra > 0 && extra < 8);
c0104fd7:	8d 43 ff             	lea    -0x1(%ebx),%eax
c0104fda:	83 f8 06             	cmp    $0x6,%eax
c0104fdd:	76 28                	jbe    c0105007 <bitmap_create+0xd2>
c0104fdf:	83 ec 0c             	sub    $0xc,%esp
c0104fe2:	68 e4 bc 10 c0       	push   $0xc010bce4
c0104fe7:	6a 23                	push   $0x23
c0104fe9:	68 1b bc 10 c0       	push   $0xc010bc1b
c0104fee:	68 37 bc 10 c0       	push   $0xc010bc37
c0104ff3:	68 95 a9 10 c0       	push   $0xc010a995
c0104ff8:	e8 c7 ed ff ff       	call   c0103dc4 <print>
c0104ffd:	83 c4 20             	add    $0x20,%esp
c0105000:	e8 45 be ff ff       	call   c0100e4a <backtrace>
c0105005:	fa                   	cli    
c0105006:	f4                   	hlt    

        for (uint32_t j = extra; j < 8; ++j)
            b->bytes[i] |= (uint8_t) 1 << j;
c0105007:	ba 01 00 00 00       	mov    $0x1,%edx
        assert(bits >> 3 == i);

        uint32_t extra = bits - (i << 3);
        assert(extra > 0 && extra < 8);

        for (uint32_t j = extra; j < 8; ++j)
c010500c:	83 fb 07             	cmp    $0x7,%ebx
c010500f:	77 18                	ja     c0105029 <bitmap_create+0xf4>
            b->bytes[i] |= (uint8_t) 1 << j;
c0105011:	8b 47 04             	mov    0x4(%edi),%eax
c0105014:	01 f0                	add    %esi,%eax
c0105016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105019:	89 d0                	mov    %edx,%eax
c010501b:	88 d9                	mov    %bl,%cl
c010501d:	d3 e0                	shl    %cl,%eax
c010501f:	89 c1                	mov    %eax,%ecx
c0105021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105024:	08 08                	or     %cl,(%eax)
        assert(bits >> 3 == i);

        uint32_t extra = bits - (i << 3);
        assert(extra > 0 && extra < 8);

        for (uint32_t j = extra; j < 8; ++j)
c0105026:	43                   	inc    %ebx
c0105027:	eb e3                	jmp    c010500c <bitmap_create+0xd7>
c0105029:	89 f8                	mov    %edi,%eax
            b->bytes[i] |= (uint8_t) 1 << j;
    }

    return b;
}
c010502b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010502e:	5b                   	pop    %ebx
c010502f:	5e                   	pop    %esi
c0105030:	5f                   	pop    %edi
c0105031:	5d                   	pop    %ebp
c0105032:	c3                   	ret    

c0105033 <bitmap_getdata>:

void*
bitmap_getdata(struct bitmap* b) {
c0105033:	55                   	push   %ebp
c0105034:	89 e5                	mov    %esp,%ebp
    return b->bytes;
c0105036:	8b 45 08             	mov    0x8(%ebp),%eax
c0105039:	8b 40 04             	mov    0x4(%eax),%eax
}
c010503c:	5d                   	pop    %ebp
c010503d:	c3                   	ret    

c010503e <bitmap_alloc>:

int
bitmap_alloc(struct bitmap* b, uint32_t* idx) {
c010503e:	55                   	push   %ebp
c010503f:	89 e5                	mov    %esp,%ebp
c0105041:	57                   	push   %edi
c0105042:	56                   	push   %esi
c0105043:	53                   	push   %ebx
c0105044:	83 ec 1c             	sub    $0x1c,%esp
c0105047:	8b 75 08             	mov    0x8(%ebp),%esi
    uint32_t max = DIVROUNDUP(b->bits, 8);
c010504a:	8b 06                	mov    (%esi),%eax
c010504c:	83 c0 07             	add    $0x7,%eax
c010504f:	c1 e8 03             	shr    $0x3,%eax
c0105052:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (uint32_t i = 0; i < max; ++i) {
c0105055:	31 db                	xor    %ebx,%ebx
c0105057:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
c010505a:	74 7f                	je     c01050db <bitmap_alloc+0x9d>
        // if all bytes are set in this byte
        if (b->bytes[i] == 0xFF)
c010505c:	8b 7e 04             	mov    0x4(%esi),%edi
c010505f:	01 df                	add    %ebx,%edi
c0105061:	8a 07                	mov    (%edi),%al
c0105063:	3c ff                	cmp    $0xff,%al
c0105065:	74 6e                	je     c01050d5 <bitmap_alloc+0x97>
c0105067:	31 c9                	xor    %ecx,%ecx
            continue;
        for (uint32_t n = 0; n < 8; ++n) {
            uint8_t msk = (uint8_t) 1 << n;
c0105069:	ba 01 00 00 00       	mov    $0x1,%edx
c010506e:	d3 e2                	shl    %cl,%edx
c0105070:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105073:	8a 55 e4             	mov    -0x1c(%ebp),%dl
            // if this bit is not set
            if ((b->bytes[i] & msk) == 0) {
c0105076:	84 c2                	test   %al,%dl
c0105078:	75 3c                	jne    c01050b6 <bitmap_alloc+0x78>
                b->bytes[i] |= msk;
c010507a:	09 d0                	or     %edx,%eax
c010507c:	88 07                	mov    %al,(%edi)
                *idx = (i << 3) + n;
c010507e:	8d 04 d9             	lea    (%ecx,%ebx,8),%eax
c0105081:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105084:	89 02                	mov    %eax,(%edx)
                assert(*idx < b->bits);
                return 0;
c0105086:	31 db                	xor    %ebx,%ebx
            uint8_t msk = (uint8_t) 1 << n;
            // if this bit is not set
            if ((b->bytes[i] & msk) == 0) {
                b->bytes[i] |= msk;
                *idx = (i << 3) + n;
                assert(*idx < b->bits);
c0105088:	3b 06                	cmp    (%esi),%eax
c010508a:	72 54                	jb     c01050e0 <bitmap_alloc+0xa2>
c010508c:	83 ec 0c             	sub    $0xc,%esp
c010508f:	68 d4 bc 10 c0       	push   $0xc010bcd4
c0105094:	6a 3e                	push   $0x3e
c0105096:	68 1b bc 10 c0       	push   $0xc010bc1b
c010509b:	68 4e bc 10 c0       	push   $0xc010bc4e
c01050a0:	68 95 a9 10 c0       	push   $0xc010a995
c01050a5:	e8 1a ed ff ff       	call   c0103dc4 <print>
c01050aa:	83 c4 20             	add    $0x20,%esp
c01050ad:	e8 98 bd ff ff       	call   c0100e4a <backtrace>
c01050b2:	fa                   	cli    
c01050b3:	f4                   	hlt    
c01050b4:	eb 2a                	jmp    c01050e0 <bitmap_alloc+0xa2>
    uint32_t max = DIVROUNDUP(b->bits, 8);
    for (uint32_t i = 0; i < max; ++i) {
        // if all bytes are set in this byte
        if (b->bytes[i] == 0xFF)
            continue;
        for (uint32_t n = 0; n < 8; ++n) {
c01050b6:	41                   	inc    %ecx
c01050b7:	83 f9 08             	cmp    $0x8,%ecx
c01050ba:	75 ad                	jne    c0105069 <bitmap_alloc+0x2b>
                *idx = (i << 3) + n;
                assert(*idx < b->bits);
                return 0;
            }
        }
        panic("bitmap internal error");
c01050bc:	68 5d bc 10 c0       	push   $0xc010bc5d
c01050c1:	68 d4 bc 10 c0       	push   $0xc010bcd4
c01050c6:	6a 42                	push   $0x42
c01050c8:	68 1b bc 10 c0       	push   $0xc010bc1b
c01050cd:	e8 70 e8 ff ff       	call   c0103942 <_panic>
c01050d2:	83 c4 10             	add    $0x10,%esp
}

int
bitmap_alloc(struct bitmap* b, uint32_t* idx) {
    uint32_t max = DIVROUNDUP(b->bits, 8);
    for (uint32_t i = 0; i < max; ++i) {
c01050d5:	43                   	inc    %ebx
c01050d6:	e9 7c ff ff ff       	jmp    c0105057 <bitmap_alloc+0x19>
                return 0;
            }
        }
        panic("bitmap internal error");
    }
    return ENOSPC;
c01050db:	bb 05 00 00 00       	mov    $0x5,%ebx
}
c01050e0:	89 d8                	mov    %ebx,%eax
c01050e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01050e5:	5b                   	pop    %ebx
c01050e6:	5e                   	pop    %esi
c01050e7:	5f                   	pop    %edi
c01050e8:	5d                   	pop    %ebp
c01050e9:	c3                   	ret    

c01050ea <bitmap_mark>:
    *i = bit >> 3;
    *msk = (uint8_t) 1 << n;
}

void
bitmap_mark(struct bitmap* b, uint32_t idx) {
c01050ea:	55                   	push   %ebp
c01050eb:	89 e5                	mov    %esp,%ebp
c01050ed:	57                   	push   %edi
c01050ee:	56                   	push   %esi
c01050ef:	53                   	push   %ebx
c01050f0:	83 ec 1c             	sub    $0x1c,%esp
c01050f3:	8b 7d 08             	mov    0x8(%ebp),%edi
c01050f6:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(idx < b->bits);
c01050f9:	39 37                	cmp    %esi,(%edi)
c01050fb:	77 28                	ja     c0105125 <bitmap_mark+0x3b>
c01050fd:	83 ec 0c             	sub    $0xc,%esp
c0105100:	68 c8 bc 10 c0       	push   $0xc010bcc8
c0105105:	6a 50                	push   $0x50
c0105107:	68 1b bc 10 c0       	push   $0xc010bc1b
c010510c:	68 4f bc 10 c0       	push   $0xc010bc4f
c0105111:	68 95 a9 10 c0       	push   $0xc010a995
c0105116:	e8 a9 ec ff ff       	call   c0103dc4 <print>
c010511b:	83 c4 20             	add    $0x20,%esp
c010511e:	e8 27 bd ff ff       	call   c0100e4a <backtrace>
c0105123:	fa                   	cli    
c0105124:	f4                   	hlt    
}

static inline void
bitmap_translate(uint32_t bit, uint32_t* i, uint8_t* msk) {
    uint32_t n = bit % 8;
    *i = bit >> 3;
c0105125:	89 f3                	mov    %esi,%ebx
c0105127:	c1 eb 03             	shr    $0x3,%ebx
    *msk = (uint8_t) 1 << n;
c010512a:	89 f1                	mov    %esi,%ecx
c010512c:	83 e1 07             	and    $0x7,%ecx
c010512f:	b8 01 00 00 00       	mov    $0x1,%eax
c0105134:	d3 e0                	shl    %cl,%eax

    uint32_t i;
    uint8_t msk;
    bitmap_translate(idx, &i, &msk);

    assert((b->bytes[i] & msk) == 0);
c0105136:	8b 57 04             	mov    0x4(%edi),%edx
c0105139:	84 04 1a             	test   %al,(%edx,%ebx,1)
c010513c:	74 2e                	je     c010516c <bitmap_mark+0x82>
c010513e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105141:	83 ec 0c             	sub    $0xc,%esp
c0105144:	68 c8 bc 10 c0       	push   $0xc010bcc8
c0105149:	6a 56                	push   $0x56
c010514b:	68 1b bc 10 c0       	push   $0xc010bc1b
c0105150:	68 73 bc 10 c0       	push   $0xc010bc73
c0105155:	68 95 a9 10 c0       	push   $0xc010a995
c010515a:	e8 65 ec ff ff       	call   c0103dc4 <print>
c010515f:	83 c4 20             	add    $0x20,%esp
c0105162:	e8 e3 bc ff ff       	call   c0100e4a <backtrace>
c0105167:	fa                   	cli    
c0105168:	f4                   	hlt    
c0105169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    b->bytes[i] |= msk;
c010516c:	03 5f 04             	add    0x4(%edi),%ebx
c010516f:	08 03                	or     %al,(%ebx)
}
c0105171:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105174:	5b                   	pop    %ebx
c0105175:	5e                   	pop    %esi
c0105176:	5f                   	pop    %edi
c0105177:	5d                   	pop    %ebp
c0105178:	c3                   	ret    

c0105179 <bitmap_unmark>:

void
bitmap_unmark(struct bitmap* b, uint32_t idx) {
c0105179:	55                   	push   %ebp
c010517a:	89 e5                	mov    %esp,%ebp
c010517c:	57                   	push   %edi
c010517d:	56                   	push   %esi
c010517e:	53                   	push   %ebx
c010517f:	83 ec 0c             	sub    $0xc,%esp
c0105182:	8b 75 08             	mov    0x8(%ebp),%esi
c0105185:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    assert(idx < b->bits);
c0105188:	39 1e                	cmp    %ebx,(%esi)
c010518a:	77 28                	ja     c01051b4 <bitmap_unmark+0x3b>
c010518c:	83 ec 0c             	sub    $0xc,%esp
c010518f:	68 b8 bc 10 c0       	push   $0xc010bcb8
c0105194:	6a 5c                	push   $0x5c
c0105196:	68 1b bc 10 c0       	push   $0xc010bc1b
c010519b:	68 4f bc 10 c0       	push   $0xc010bc4f
c01051a0:	68 95 a9 10 c0       	push   $0xc010a995
c01051a5:	e8 1a ec ff ff       	call   c0103dc4 <print>
c01051aa:	83 c4 20             	add    $0x20,%esp
c01051ad:	e8 98 bc ff ff       	call   c0100e4a <backtrace>
c01051b2:	fa                   	cli    
c01051b3:	f4                   	hlt    
}

static inline void
bitmap_translate(uint32_t bit, uint32_t* i, uint8_t* msk) {
    uint32_t n = bit % 8;
    *i = bit >> 3;
c01051b4:	89 df                	mov    %ebx,%edi
c01051b6:	c1 ef 03             	shr    $0x3,%edi
    *msk = (uint8_t) 1 << n;
c01051b9:	89 d9                	mov    %ebx,%ecx
c01051bb:	83 e1 07             	and    $0x7,%ecx
c01051be:	bb 01 00 00 00       	mov    $0x1,%ebx
c01051c3:	d3 e3                	shl    %cl,%ebx

    uint32_t i;
    uint8_t msk;
    bitmap_translate(idx, &i, &msk);

    assert((b->bytes[i] & msk) != 0);
c01051c5:	8b 46 04             	mov    0x4(%esi),%eax
c01051c8:	84 1c 38             	test   %bl,(%eax,%edi,1)
c01051cb:	75 28                	jne    c01051f5 <bitmap_unmark+0x7c>
c01051cd:	83 ec 0c             	sub    $0xc,%esp
c01051d0:	68 b8 bc 10 c0       	push   $0xc010bcb8
c01051d5:	6a 62                	push   $0x62
c01051d7:	68 1b bc 10 c0       	push   $0xc010bc1b
c01051dc:	68 8c bc 10 c0       	push   $0xc010bc8c
c01051e1:	68 95 a9 10 c0       	push   $0xc010a995
c01051e6:	e8 d9 eb ff ff       	call   c0103dc4 <print>
c01051eb:	83 c4 20             	add    $0x20,%esp
c01051ee:	e8 57 bc ff ff       	call   c0100e4a <backtrace>
c01051f3:	fa                   	cli    
c01051f4:	f4                   	hlt    
    b->bytes[i] &= ~msk;
c01051f5:	03 7e 04             	add    0x4(%esi),%edi
c01051f8:	f7 d3                	not    %ebx
c01051fa:	20 1f                	and    %bl,(%edi)
}
c01051fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01051ff:	5b                   	pop    %ebx
c0105200:	5e                   	pop    %esi
c0105201:	5f                   	pop    %edi
c0105202:	5d                   	pop    %ebp
c0105203:	c3                   	ret    

c0105204 <bitmap_isset>:


bool
bitmap_isset(struct bitmap* b, uint32_t idx) {
c0105204:	55                   	push   %ebp
c0105205:	89 e5                	mov    %esp,%ebp
c0105207:	56                   	push   %esi
c0105208:	53                   	push   %ebx
c0105209:	8b 75 08             	mov    0x8(%ebp),%esi
c010520c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    assert(idx < b->bits);
c010520f:	39 1e                	cmp    %ebx,(%esi)
c0105211:	77 28                	ja     c010523b <bitmap_isset+0x37>
c0105213:	83 ec 0c             	sub    $0xc,%esp
c0105216:	68 a8 bc 10 c0       	push   $0xc010bca8
c010521b:	6a 69                	push   $0x69
c010521d:	68 1b bc 10 c0       	push   $0xc010bc1b
c0105222:	68 4f bc 10 c0       	push   $0xc010bc4f
c0105227:	68 95 a9 10 c0       	push   $0xc010a995
c010522c:	e8 93 eb ff ff       	call   c0103dc4 <print>
c0105231:	83 c4 20             	add    $0x20,%esp
c0105234:	e8 11 bc ff ff       	call   c0100e4a <backtrace>
c0105239:	fa                   	cli    
c010523a:	f4                   	hlt    

    uint32_t i;
    uint8_t msk;
    bitmap_translate(idx, &i, &msk);

    return (b->bytes[i] & msk);
c010523b:	89 da                	mov    %ebx,%edx
c010523d:	c1 ea 03             	shr    $0x3,%edx
c0105240:	8b 76 04             	mov    0x4(%esi),%esi
c0105243:	89 d9                	mov    %ebx,%ecx
c0105245:	83 e1 07             	and    $0x7,%ecx
c0105248:	b8 01 00 00 00       	mov    $0x1,%eax
c010524d:	d3 e0                	shl    %cl,%eax
c010524f:	84 04 16             	test   %al,(%esi,%edx,1)
c0105252:	0f 95 c0             	setne  %al
}
c0105255:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105258:	5b                   	pop    %ebx
c0105259:	5e                   	pop    %esi
c010525a:	5d                   	pop    %ebp
c010525b:	c3                   	ret    

c010525c <bitmap_destroy>:

void
bitmap_destroy(struct bitmap* b) {
c010525c:	55                   	push   %ebp
c010525d:	89 e5                	mov    %esp,%ebp
c010525f:	53                   	push   %ebx
c0105260:	83 ec 10             	sub    $0x10,%esp
c0105263:	8b 5d 08             	mov    0x8(%ebp),%ebx
    kfree(b->bytes);
c0105266:	ff 73 04             	pushl  0x4(%ebx)
c0105269:	e8 03 c7 ff ff       	call   c0101971 <kfree>
    b->bytes = NULL;
c010526e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    kfree(b);
c0105275:	83 c4 10             	add    $0x10,%esp
c0105278:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c010527b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010527e:	c9                   	leave  

void
bitmap_destroy(struct bitmap* b) {
    kfree(b->bytes);
    b->bytes = NULL;
    kfree(b);
c010527f:	e9 ed c6 ff ff       	jmp    c0101971 <kfree>

c0105284 <queue_create>:
    int datatype;
    struct list* vals;
};

struct queue*
queue_create(void) {
c0105284:	55                   	push   %ebp
c0105285:	89 e5                	mov    %esp,%ebp
c0105287:	53                   	push   %ebx
c0105288:	83 ec 10             	sub    $0x10,%esp
    struct queue* q = (struct queue*) kmalloc(sizeof(struct queue));
c010528b:	6a 08                	push   $0x8
c010528d:	e8 13 c6 ff ff       	call   c01018a5 <kmalloc>
c0105292:	89 c3                	mov    %eax,%ebx
    if (q == NULL)
c0105294:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0105297:	31 c0                	xor    %eax,%eax
};

struct queue*
queue_create(void) {
    struct queue* q = (struct queue*) kmalloc(sizeof(struct queue));
    if (q == NULL)
c0105299:	85 db                	test   %ebx,%ebx
c010529b:	74 24                	je     c01052c1 <queue_create+0x3d>
        return NULL;
    q->vals = list_create();
c010529d:	e8 37 f5 ff ff       	call   c01047d9 <list_create>
c01052a2:	89 43 04             	mov    %eax,0x4(%ebx)
    if (q->vals == NULL) {
c01052a5:	85 c0                	test   %eax,%eax
c01052a7:	75 10                	jne    c01052b9 <queue_create+0x35>
        kfree(q);
c01052a9:	83 ec 0c             	sub    $0xc,%esp
c01052ac:	53                   	push   %ebx
c01052ad:	e8 bf c6 ff ff       	call   c0101971 <kfree>
        return NULL;
c01052b2:	83 c4 10             	add    $0x10,%esp
c01052b5:	31 c0                	xor    %eax,%eax
c01052b7:	eb 08                	jmp    c01052c1 <queue_create+0x3d>
    }
    q->datatype = QUEUETYPE;
c01052b9:	c7 03 ae 08 00 00    	movl   $0x8ae,(%ebx)
    return q;
c01052bf:	89 d8                	mov    %ebx,%eax
}
c01052c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01052c4:	c9                   	leave  
c01052c5:	c3                   	ret    

c01052c6 <queue_push>:

int
queue_push(struct queue* q, void* newval) {
c01052c6:	55                   	push   %ebp
c01052c7:	89 e5                	mov    %esp,%ebp
c01052c9:	56                   	push   %esi
c01052ca:	53                   	push   %ebx
c01052cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01052ce:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(q != NULL);
c01052d1:	85 db                	test   %ebx,%ebx
c01052d3:	75 28                	jne    c01052fd <queue_push+0x37>
c01052d5:	83 ec 0c             	sub    $0xc,%esp
c01052d8:	68 80 bd 10 c0       	push   $0xc010bd80
c01052dd:	6a 21                	push   $0x21
c01052df:	68 f2 bc 10 c0       	push   $0xc010bcf2
c01052e4:	68 fe bc 10 c0       	push   $0xc010bcfe
c01052e9:	68 95 a9 10 c0       	push   $0xc010a995
c01052ee:	e8 d1 ea ff ff       	call   c0103dc4 <print>
c01052f3:	83 c4 20             	add    $0x20,%esp
c01052f6:	e8 4f bb ff ff       	call   c0100e4a <backtrace>
c01052fb:	fa                   	cli    
c01052fc:	f4                   	hlt    
    ASSERT_QUEUE(q);
c01052fd:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c0105303:	74 28                	je     c010532d <queue_push+0x67>
c0105305:	83 ec 0c             	sub    $0xc,%esp
c0105308:	68 80 bd 10 c0       	push   $0xc010bd80
c010530d:	6a 22                	push   $0x22
c010530f:	68 f2 bc 10 c0       	push   $0xc010bcf2
c0105314:	68 08 bd 10 c0       	push   $0xc010bd08
c0105319:	68 95 a9 10 c0       	push   $0xc010a995
c010531e:	e8 a1 ea ff ff       	call   c0103dc4 <print>
c0105323:	83 c4 20             	add    $0x20,%esp
c0105326:	e8 1f bb ff ff       	call   c0100e4a <backtrace>
c010532b:	fa                   	cli    
c010532c:	f4                   	hlt    
    return list_push_back(q->vals, newval);
c010532d:	89 75 0c             	mov    %esi,0xc(%ebp)
c0105330:	8b 43 04             	mov    0x4(%ebx),%eax
c0105333:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0105336:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105339:	5b                   	pop    %ebx
c010533a:	5e                   	pop    %esi
c010533b:	5d                   	pop    %ebp

int
queue_push(struct queue* q, void* newval) {
    assert(q != NULL);
    ASSERT_QUEUE(q);
    return list_push_back(q->vals, newval);
c010533c:	e9 c9 f4 ff ff       	jmp    c010480a <list_push_back>

c0105341 <queue_pop>:
}

void
queue_pop(struct queue* q) {
c0105341:	55                   	push   %ebp
c0105342:	89 e5                	mov    %esp,%ebp
c0105344:	53                   	push   %ebx
c0105345:	50                   	push   %eax
c0105346:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c0105349:	85 db                	test   %ebx,%ebx
c010534b:	75 28                	jne    c0105375 <queue_pop+0x34>
c010534d:	83 ec 0c             	sub    $0xc,%esp
c0105350:	68 74 bd 10 c0       	push   $0xc010bd74
c0105355:	6a 28                	push   $0x28
c0105357:	68 f2 bc 10 c0       	push   $0xc010bcf2
c010535c:	68 fe bc 10 c0       	push   $0xc010bcfe
c0105361:	68 95 a9 10 c0       	push   $0xc010a995
c0105366:	e8 59 ea ff ff       	call   c0103dc4 <print>
c010536b:	83 c4 20             	add    $0x20,%esp
c010536e:	e8 d7 ba ff ff       	call   c0100e4a <backtrace>
c0105373:	fa                   	cli    
c0105374:	f4                   	hlt    
    ASSERT_QUEUE(q);
c0105375:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c010537b:	74 28                	je     c01053a5 <queue_pop+0x64>
c010537d:	83 ec 0c             	sub    $0xc,%esp
c0105380:	68 74 bd 10 c0       	push   $0xc010bd74
c0105385:	6a 29                	push   $0x29
c0105387:	68 f2 bc 10 c0       	push   $0xc010bcf2
c010538c:	68 08 bd 10 c0       	push   $0xc010bd08
c0105391:	68 95 a9 10 c0       	push   $0xc010a995
c0105396:	e8 29 ea ff ff       	call   c0103dc4 <print>
c010539b:	83 c4 20             	add    $0x20,%esp
c010539e:	e8 a7 ba ff ff       	call   c0100e4a <backtrace>
c01053a3:	fa                   	cli    
c01053a4:	f4                   	hlt    
    list_pop_front(q->vals);
c01053a5:	8b 43 04             	mov    0x4(%ebx),%eax
c01053a8:	89 45 08             	mov    %eax,0x8(%ebp)
}
c01053ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01053ae:	c9                   	leave  

void
queue_pop(struct queue* q) {
    assert(q != NULL);
    ASSERT_QUEUE(q);
    list_pop_front(q->vals);
c01053af:	e9 56 f5 ff ff       	jmp    c010490a <list_pop_front>

c01053b4 <queue_front>:
}

void*
queue_front(struct queue* q) {
c01053b4:	55                   	push   %ebp
c01053b5:	89 e5                	mov    %esp,%ebp
c01053b7:	53                   	push   %ebx
c01053b8:	50                   	push   %eax
c01053b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c01053bc:	85 db                	test   %ebx,%ebx
c01053be:	75 28                	jne    c01053e8 <queue_front+0x34>
c01053c0:	83 ec 0c             	sub    $0xc,%esp
c01053c3:	68 68 bd 10 c0       	push   $0xc010bd68
c01053c8:	6a 2f                	push   $0x2f
c01053ca:	68 f2 bc 10 c0       	push   $0xc010bcf2
c01053cf:	68 fe bc 10 c0       	push   $0xc010bcfe
c01053d4:	68 95 a9 10 c0       	push   $0xc010a995
c01053d9:	e8 e6 e9 ff ff       	call   c0103dc4 <print>
c01053de:	83 c4 20             	add    $0x20,%esp
c01053e1:	e8 64 ba ff ff       	call   c0100e4a <backtrace>
c01053e6:	fa                   	cli    
c01053e7:	f4                   	hlt    
    ASSERT_QUEUE(q);
c01053e8:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c01053ee:	74 28                	je     c0105418 <queue_front+0x64>
c01053f0:	83 ec 0c             	sub    $0xc,%esp
c01053f3:	68 68 bd 10 c0       	push   $0xc010bd68
c01053f8:	6a 30                	push   $0x30
c01053fa:	68 f2 bc 10 c0       	push   $0xc010bcf2
c01053ff:	68 08 bd 10 c0       	push   $0xc010bd08
c0105404:	68 95 a9 10 c0       	push   $0xc010a995
c0105409:	e8 b6 e9 ff ff       	call   c0103dc4 <print>
c010540e:	83 c4 20             	add    $0x20,%esp
c0105411:	e8 34 ba ff ff       	call   c0100e4a <backtrace>
c0105416:	fa                   	cli    
c0105417:	f4                   	hlt    
    return list_front(q->vals);
c0105418:	8b 43 04             	mov    0x4(%ebx),%eax
c010541b:	89 45 08             	mov    %eax,0x8(%ebp)
}
c010541e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105421:	c9                   	leave  

void*
queue_front(struct queue* q) {
    assert(q != NULL);
    ASSERT_QUEUE(q);
    return list_front(q->vals);
c0105422:	e9 aa f5 ff ff       	jmp    c01049d1 <list_front>

c0105427 <queue_isempty>:
}

int
queue_isempty(struct queue* q) {
c0105427:	55                   	push   %ebp
c0105428:	89 e5                	mov    %esp,%ebp
c010542a:	53                   	push   %ebx
c010542b:	50                   	push   %eax
c010542c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c010542f:	85 db                	test   %ebx,%ebx
c0105431:	75 28                	jne    c010545b <queue_isempty+0x34>
c0105433:	83 ec 0c             	sub    $0xc,%esp
c0105436:	68 58 bd 10 c0       	push   $0xc010bd58
c010543b:	6a 36                	push   $0x36
c010543d:	68 f2 bc 10 c0       	push   $0xc010bcf2
c0105442:	68 fe bc 10 c0       	push   $0xc010bcfe
c0105447:	68 95 a9 10 c0       	push   $0xc010a995
c010544c:	e8 73 e9 ff ff       	call   c0103dc4 <print>
c0105451:	83 c4 20             	add    $0x20,%esp
c0105454:	e8 f1 b9 ff ff       	call   c0100e4a <backtrace>
c0105459:	fa                   	cli    
c010545a:	f4                   	hlt    
    ASSERT_QUEUE(q);
c010545b:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c0105461:	74 28                	je     c010548b <queue_isempty+0x64>
c0105463:	83 ec 0c             	sub    $0xc,%esp
c0105466:	68 58 bd 10 c0       	push   $0xc010bd58
c010546b:	6a 37                	push   $0x37
c010546d:	68 f2 bc 10 c0       	push   $0xc010bcf2
c0105472:	68 08 bd 10 c0       	push   $0xc010bd08
c0105477:	68 95 a9 10 c0       	push   $0xc010a995
c010547c:	e8 43 e9 ff ff       	call   c0103dc4 <print>
c0105481:	83 c4 20             	add    $0x20,%esp
c0105484:	e8 c1 b9 ff ff       	call   c0100e4a <backtrace>
c0105489:	fa                   	cli    
c010548a:	f4                   	hlt    
    return list_isempty(q->vals);
c010548b:	8b 43 04             	mov    0x4(%ebx),%eax
c010548e:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0105491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105494:	c9                   	leave  

int
queue_isempty(struct queue* q) {
    assert(q != NULL);
    ASSERT_QUEUE(q);
    return list_isempty(q->vals);
c0105495:	e9 d3 f7 ff ff       	jmp    c0104c6d <list_isempty>

c010549a <queue_getsize>:
}

unsigned int
queue_getsize(struct queue* q) {
c010549a:	55                   	push   %ebp
c010549b:	89 e5                	mov    %esp,%ebp
c010549d:	53                   	push   %ebx
c010549e:	50                   	push   %eax
c010549f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c01054a2:	85 db                	test   %ebx,%ebx
c01054a4:	75 28                	jne    c01054ce <queue_getsize+0x34>
c01054a6:	83 ec 0c             	sub    $0xc,%esp
c01054a9:	68 48 bd 10 c0       	push   $0xc010bd48
c01054ae:	6a 3d                	push   $0x3d
c01054b0:	68 f2 bc 10 c0       	push   $0xc010bcf2
c01054b5:	68 fe bc 10 c0       	push   $0xc010bcfe
c01054ba:	68 95 a9 10 c0       	push   $0xc010a995
c01054bf:	e8 00 e9 ff ff       	call   c0103dc4 <print>
c01054c4:	83 c4 20             	add    $0x20,%esp
c01054c7:	e8 7e b9 ff ff       	call   c0100e4a <backtrace>
c01054cc:	fa                   	cli    
c01054cd:	f4                   	hlt    
    ASSERT_QUEUE(q);
c01054ce:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c01054d4:	74 28                	je     c01054fe <queue_getsize+0x64>
c01054d6:	83 ec 0c             	sub    $0xc,%esp
c01054d9:	68 48 bd 10 c0       	push   $0xc010bd48
c01054de:	6a 3e                	push   $0x3e
c01054e0:	68 f2 bc 10 c0       	push   $0xc010bcf2
c01054e5:	68 08 bd 10 c0       	push   $0xc010bd08
c01054ea:	68 95 a9 10 c0       	push   $0xc010a995
c01054ef:	e8 d0 e8 ff ff       	call   c0103dc4 <print>
c01054f4:	83 c4 20             	add    $0x20,%esp
c01054f7:	e8 4e b9 ff ff       	call   c0100e4a <backtrace>
c01054fc:	fa                   	cli    
c01054fd:	f4                   	hlt    
    return list_getsize(q->vals);
c01054fe:	8b 43 04             	mov    0x4(%ebx),%eax
c0105501:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0105504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105507:	c9                   	leave  

unsigned int
queue_getsize(struct queue* q) {
    assert(q != NULL);
    ASSERT_QUEUE(q);
    return list_getsize(q->vals);
c0105508:	e9 d8 f7 ff ff       	jmp    c0104ce5 <list_getsize>

c010550d <queue_destroy>:
}

void
queue_destroy(struct queue* q) {
c010550d:	55                   	push   %ebp
c010550e:	89 e5                	mov    %esp,%ebp
c0105510:	53                   	push   %ebx
c0105511:	50                   	push   %eax
c0105512:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (q != NULL) {
c0105515:	85 db                	test   %ebx,%ebx
c0105517:	74 3e                	je     c0105557 <queue_destroy+0x4a>
        ASSERT_QUEUE(q);
c0105519:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c010551f:	74 28                	je     c0105549 <queue_destroy+0x3c>
c0105521:	83 ec 0c             	sub    $0xc,%esp
c0105524:	68 38 bd 10 c0       	push   $0xc010bd38
c0105529:	6a 45                	push   $0x45
c010552b:	68 f2 bc 10 c0       	push   $0xc010bcf2
c0105530:	68 08 bd 10 c0       	push   $0xc010bd08
c0105535:	68 95 a9 10 c0       	push   $0xc010a995
c010553a:	e8 85 e8 ff ff       	call   c0103dc4 <print>
c010553f:	83 c4 20             	add    $0x20,%esp
c0105542:	e8 03 b9 ff ff       	call   c0100e4a <backtrace>
c0105547:	fa                   	cli    
c0105548:	f4                   	hlt    
        list_destroy(q->vals);
c0105549:	83 ec 0c             	sub    $0xc,%esp
c010554c:	ff 73 04             	pushl  0x4(%ebx)
c010554f:	e8 03 f8 ff ff       	call   c0104d57 <list_destroy>
c0105554:	83 c4 10             	add    $0x10,%esp
    }
    kfree(q);
c0105557:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c010555a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010555d:	c9                   	leave  
queue_destroy(struct queue* q) {
    if (q != NULL) {
        ASSERT_QUEUE(q);
        list_destroy(q->vals);
    }
    kfree(q);
c010555e:	e9 0e c4 ff ff       	jmp    c0101971 <kfree>

c0105563 <queue_assertvalid>:
}

void
queue_assertvalid(struct queue* q) {
c0105563:	55                   	push   %ebp
c0105564:	89 e5                	mov    %esp,%ebp
c0105566:	53                   	push   %ebx
c0105567:	50                   	push   %eax
c0105568:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c010556b:	85 db                	test   %ebx,%ebx
c010556d:	75 28                	jne    c0105597 <queue_assertvalid+0x34>
c010556f:	83 ec 0c             	sub    $0xc,%esp
c0105572:	68 24 bd 10 c0       	push   $0xc010bd24
c0105577:	6a 4d                	push   $0x4d
c0105579:	68 f2 bc 10 c0       	push   $0xc010bcf2
c010557e:	68 fe bc 10 c0       	push   $0xc010bcfe
c0105583:	68 95 a9 10 c0       	push   $0xc010a995
c0105588:	e8 37 e8 ff ff       	call   c0103dc4 <print>
c010558d:	83 c4 20             	add    $0x20,%esp
c0105590:	e8 b5 b8 ff ff       	call   c0100e4a <backtrace>
c0105595:	fa                   	cli    
c0105596:	f4                   	hlt    
    ASSERT_QUEUE(q);
c0105597:	81 3b ae 08 00 00    	cmpl   $0x8ae,(%ebx)
c010559d:	74 28                	je     c01055c7 <queue_assertvalid+0x64>
c010559f:	83 ec 0c             	sub    $0xc,%esp
c01055a2:	68 24 bd 10 c0       	push   $0xc010bd24
c01055a7:	6a 4e                	push   $0x4e
c01055a9:	68 f2 bc 10 c0       	push   $0xc010bcf2
c01055ae:	68 08 bd 10 c0       	push   $0xc010bd08
c01055b3:	68 95 a9 10 c0       	push   $0xc010a995
c01055b8:	e8 07 e8 ff ff       	call   c0103dc4 <print>
c01055bd:	83 c4 20             	add    $0x20,%esp
c01055c0:	e8 85 b8 ff ff       	call   c0100e4a <backtrace>
c01055c5:	fa                   	cli    
c01055c6:	f4                   	hlt    
    list_assertvalid(q->vals);
c01055c7:	8b 43 04             	mov    0x4(%ebx),%eax
c01055ca:	89 45 08             	mov    %eax,0x8(%ebp)
}
c01055cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01055d0:	c9                   	leave  

void
queue_assertvalid(struct queue* q) {
    assert(q != NULL);
    ASSERT_QUEUE(q);
    list_assertvalid(q->vals);
c01055d1:	e9 20 f8 ff ff       	jmp    c0104df6 <list_assertvalid>

c01055d6 <hash>:
 * djb2 hash function
 * http://www.cse.yorku.ca/~oz/hash.html
 */
static
unsigned long
hash(char* key, unsigned int keylen) {
c01055d6:	55                   	push   %ebp
c01055d7:	89 e5                	mov    %esp,%ebp
c01055d9:	57                   	push   %edi
c01055da:	56                   	push   %esi
c01055db:	53                   	push   %ebx
    unsigned long hashval = 5381;
    unsigned int i;
    int c;
    for (i = 0; i < keylen; ++i) {
c01055dc:	31 db                	xor    %ebx,%ebx
 * http://www.cse.yorku.ca/~oz/hash.html
 */
static
unsigned long
hash(char* key, unsigned int keylen) {
    unsigned long hashval = 5381;
c01055de:	b9 05 15 00 00       	mov    $0x1505,%ecx
    unsigned int i;
    int c;
    for (i = 0; i < keylen; ++i) {
c01055e3:	39 d3                	cmp    %edx,%ebx
c01055e5:	74 10                	je     c01055f7 <hash+0x21>
c01055e7:	89 cf                	mov    %ecx,%edi
c01055e9:	c1 e7 05             	shl    $0x5,%edi
c01055ec:	0f be 34 18          	movsbl (%eax,%ebx,1),%esi
c01055f0:	01 fe                	add    %edi,%esi
        c = key[i];
        /* hashval * 33 + c */
        hashval = ((hashval << 5) + hashval) + c;
c01055f2:	01 f1                	add    %esi,%ecx
unsigned long
hash(char* key, unsigned int keylen) {
    unsigned long hashval = 5381;
    unsigned int i;
    int c;
    for (i = 0; i < keylen; ++i) {
c01055f4:	43                   	inc    %ebx
c01055f5:	eb ec                	jmp    c01055e3 <hash+0xd>
        c = key[i];
        /* hashval * 33 + c */
        hashval = ((hashval << 5) + hashval) + c;
    }
    return hashval;
}
c01055f7:	89 c8                	mov    %ecx,%eax
c01055f9:	5b                   	pop    %ebx
c01055fa:	5e                   	pop    %esi
c01055fb:	5f                   	pop    %edi
c01055fc:	5d                   	pop    %ebp
c01055fd:	c3                   	ret    

c01055fe <key_comparator>:
    return 0;
}

static
int
key_comparator(void* left, void* right) {
c01055fe:	55                   	push   %ebp
c01055ff:	89 e5                	mov    %esp,%ebp
c0105601:	56                   	push   %esi
c0105602:	53                   	push   %ebx
c0105603:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0105606:	8b 75 0c             	mov    0xc(%ebp),%esi
    struct kv_pair* l = (struct kv_pair*)left;
    struct kv_pair* r = (struct kv_pair*)right;
    ASSERT_KV(l);
c0105609:	81 3b 5d 11 00 00    	cmpl   $0x115d,(%ebx)
c010560f:	74 2b                	je     c010563c <key_comparator+0x3e>
c0105611:	83 ec 0c             	sub    $0xc,%esp
c0105614:	68 7c bf 10 c0       	push   $0xc010bf7c
c0105619:	68 ce 00 00 00       	push   $0xce
c010561e:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105623:	68 9b bd 10 c0       	push   $0xc010bd9b
c0105628:	68 95 a9 10 c0       	push   $0xc010a995
c010562d:	e8 92 e7 ff ff       	call   c0103dc4 <print>
c0105632:	83 c4 20             	add    $0x20,%esp
c0105635:	e8 10 b8 ff ff       	call   c0100e4a <backtrace>
c010563a:	fa                   	cli    
c010563b:	f4                   	hlt    
    ASSERT_KV(r);
c010563c:	81 3e 5d 11 00 00    	cmpl   $0x115d,(%esi)
c0105642:	74 2b                	je     c010566f <key_comparator+0x71>
c0105644:	83 ec 0c             	sub    $0xc,%esp
c0105647:	68 7c bf 10 c0       	push   $0xc010bf7c
c010564c:	68 cf 00 00 00       	push   $0xcf
c0105651:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105656:	68 b1 bd 10 c0       	push   $0xc010bdb1
c010565b:	68 95 a9 10 c0       	push   $0xc010a995
c0105660:	e8 5f e7 ff ff       	call   c0103dc4 <print>
c0105665:	83 c4 20             	add    $0x20,%esp
c0105668:	e8 dd b7 ff ff       	call   c0100e4a <backtrace>
c010566d:	fa                   	cli    
c010566e:	f4                   	hlt    
    if (l->keylen == r->keylen)
c010566f:	8b 43 08             	mov    0x8(%ebx),%eax
c0105672:	8b 56 08             	mov    0x8(%esi),%edx
c0105675:	39 d0                	cmp    %edx,%eax
c0105677:	75 17                	jne    c0105690 <key_comparator+0x92>
        return strcmp(l->key, r->key);
c0105679:	8b 46 04             	mov    0x4(%esi),%eax
c010567c:	89 45 0c             	mov    %eax,0xc(%ebp)
c010567f:	8b 43 04             	mov    0x4(%ebx),%eax
c0105682:	89 45 08             	mov    %eax,0x8(%ebp)
    return (l->keylen - r->keylen);
}
c0105685:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105688:	5b                   	pop    %ebx
c0105689:	5e                   	pop    %esi
c010568a:	5d                   	pop    %ebp
    struct kv_pair* l = (struct kv_pair*)left;
    struct kv_pair* r = (struct kv_pair*)right;
    ASSERT_KV(l);
    ASSERT_KV(r);
    if (l->keylen == r->keylen)
        return strcmp(l->key, r->key);
c010568b:	e9 05 ed ff ff       	jmp    c0104395 <strcmp>
    return (l->keylen - r->keylen);
c0105690:	29 d0                	sub    %edx,%eax
}
c0105692:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105695:	5b                   	pop    %ebx
c0105696:	5e                   	pop    %esi
c0105697:	5d                   	pop    %ebp
c0105698:	c3                   	ret    

c0105699 <cleanup_array_with_lists.constprop.1>:
/*
 * Cleanup the array with empty lists from start to end index.
 */
static
void
cleanup_array_with_lists(struct list** vals, unsigned int start, unsigned int end) {
c0105699:	55                   	push   %ebp
c010569a:	89 e5                	mov    %esp,%ebp
c010569c:	57                   	push   %edi
c010569d:	56                   	push   %esi
c010569e:	53                   	push   %ebx
c010569f:	83 ec 0c             	sub    $0xc,%esp
c01056a2:	89 c6                	mov    %eax,%esi
c01056a4:	89 d7                	mov    %edx,%edi
    unsigned int i;
    for (i = start; i < end; ++i) {
c01056a6:	31 db                	xor    %ebx,%ebx
c01056a8:	39 fb                	cmp    %edi,%ebx
c01056aa:	74 4b                	je     c01056f7 <cleanup_array_with_lists.constprop.1+0x5e>
        assert(list_isempty(vals[i]));
c01056ac:	83 ec 0c             	sub    $0xc,%esp
c01056af:	ff 34 9e             	pushl  (%esi,%ebx,4)
c01056b2:	e8 b6 f5 ff ff       	call   c0104c6d <list_isempty>
c01056b7:	83 c4 10             	add    $0x10,%esp
c01056ba:	85 c0                	test   %eax,%eax
c01056bc:	75 28                	jne    c01056e6 <cleanup_array_with_lists.constprop.1+0x4d>
c01056be:	83 ec 0c             	sub    $0xc,%esp
c01056c1:	68 50 bf 10 c0       	push   $0xc010bf50
c01056c6:	6a 68                	push   $0x68
c01056c8:	68 8b bd 10 c0       	push   $0xc010bd8b
c01056cd:	68 c7 bd 10 c0       	push   $0xc010bdc7
c01056d2:	68 95 a9 10 c0       	push   $0xc010a995
c01056d7:	e8 e8 e6 ff ff       	call   c0103dc4 <print>
c01056dc:	83 c4 20             	add    $0x20,%esp
c01056df:	e8 66 b7 ff ff       	call   c0100e4a <backtrace>
c01056e4:	fa                   	cli    
c01056e5:	f4                   	hlt    
        list_destroy(vals[i]);
c01056e6:	83 ec 0c             	sub    $0xc,%esp
c01056e9:	ff 34 9e             	pushl  (%esi,%ebx,4)
c01056ec:	e8 66 f6 ff ff       	call   c0104d57 <list_destroy>
 */
static
void
cleanup_array_with_lists(struct list** vals, unsigned int start, unsigned int end) {
    unsigned int i;
    for (i = start; i < end; ++i) {
c01056f1:	43                   	inc    %ebx
c01056f2:	83 c4 10             	add    $0x10,%esp
c01056f5:	eb b1                	jmp    c01056a8 <cleanup_array_with_lists.constprop.1+0xf>
        assert(list_isempty(vals[i]));
        list_destroy(vals[i]);
    }
}
c01056f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01056fa:	5b                   	pop    %ebx
c01056fb:	5e                   	pop    %esi
c01056fc:	5f                   	pop    %edi
c01056fd:	5d                   	pop    %ebp
c01056fe:	c3                   	ret    

c01056ff <init_array_with_lists.constprop.2>:
/*
 * Fill the array with empty lists from start to end index.
 */
static
int
init_array_with_lists(struct list** vals, unsigned int start, unsigned int end) {
c01056ff:	55                   	push   %ebp
c0105700:	89 e5                	mov    %esp,%ebp
c0105702:	57                   	push   %edi
c0105703:	56                   	push   %esi
c0105704:	53                   	push   %ebx
c0105705:	83 ec 0c             	sub    $0xc,%esp
c0105708:	89 c7                	mov    %eax,%edi
c010570a:	89 d6                	mov    %edx,%esi
    unsigned int i, j;
    int flag = 0;
    for (i = start; i < end; ++i) {
c010570c:	31 db                	xor    %ebx,%ebx
c010570e:	39 f3                	cmp    %esi,%ebx
c0105710:	74 13                	je     c0105725 <init_array_with_lists.constprop.2+0x26>
        vals[i] = list_create();
c0105712:	e8 c2 f0 ff ff       	call   c01047d9 <list_create>
c0105717:	89 04 9f             	mov    %eax,(%edi,%ebx,4)
        if (vals[i] == NULL) {
c010571a:	85 c0                	test   %eax,%eax
c010571c:	75 04                	jne    c0105722 <init_array_with_lists.constprop.2+0x23>
c010571e:	31 f6                	xor    %esi,%esi
c0105720:	eb 07                	jmp    c0105729 <init_array_with_lists.constprop.2+0x2a>
static
int
init_array_with_lists(struct list** vals, unsigned int start, unsigned int end) {
    unsigned int i, j;
    int flag = 0;
    for (i = start; i < end; ++i) {
c0105722:	43                   	inc    %ebx
c0105723:	eb e9                	jmp    c010570e <init_array_with_lists.constprop.2+0xf>
        /* kfree all lists in the array */
        for (i = 0; i < j; ++i)
            list_destroy(vals[i]);
        return ENOMEM;
    }
    return 0;
c0105725:	31 c0                	xor    %eax,%eax
c0105727:	eb 1a                	jmp    c0105743 <init_array_with_lists.constprop.2+0x44>
            break;
        }
    }
    if (flag) {
        /* kfree all lists in the array */
        for (i = 0; i < j; ++i)
c0105729:	39 f3                	cmp    %esi,%ebx
c010572b:	74 11                	je     c010573e <init_array_with_lists.constprop.2+0x3f>
            list_destroy(vals[i]);
c010572d:	83 ec 0c             	sub    $0xc,%esp
c0105730:	ff 34 b7             	pushl  (%edi,%esi,4)
c0105733:	e8 1f f6 ff ff       	call   c0104d57 <list_destroy>
            break;
        }
    }
    if (flag) {
        /* kfree all lists in the array */
        for (i = 0; i < j; ++i)
c0105738:	46                   	inc    %esi
c0105739:	83 c4 10             	add    $0x10,%esp
c010573c:	eb eb                	jmp    c0105729 <init_array_with_lists.constprop.2+0x2a>
            list_destroy(vals[i]);
        return ENOMEM;
c010573e:	b8 02 00 00 00       	mov    $0x2,%eax
    }
    return 0;
}
c0105743:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105746:	5b                   	pop    %ebx
c0105747:	5e                   	pop    %esi
c0105748:	5f                   	pop    %edi
c0105749:	5d                   	pop    %ebp
c010574a:	c3                   	ret    

c010574b <hashtable_create>:
        list_destroy(vals[i]);
    }
}

struct hashtable*
hashtable_create(void) {
c010574b:	55                   	push   %ebp
c010574c:	89 e5                	mov    %esp,%ebp
c010574e:	53                   	push   %ebx
c010574f:	83 ec 10             	sub    $0x10,%esp
    struct hashtable* h = (struct hashtable*)kmalloc(sizeof(struct hashtable));
c0105752:	6a 14                	push   $0x14
c0105754:	e8 4c c1 ff ff       	call   c01018a5 <kmalloc>
c0105759:	89 c3                	mov    %eax,%ebx
    if (h == NULL)
c010575b:	83 c4 10             	add    $0x10,%esp
        return NULL;
c010575e:	31 c0                	xor    %eax,%eax
}

struct hashtable*
hashtable_create(void) {
    struct hashtable* h = (struct hashtable*)kmalloc(sizeof(struct hashtable));
    if (h == NULL)
c0105760:	85 db                	test   %ebx,%ebx
c0105762:	74 57                	je     c01057bb <hashtable_create+0x70>
        return NULL;
    h->size = 0;
c0105764:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    h->arraysize = MIN_SIZE;
c010576b:	c7 43 08 08 00 00 00 	movl   $0x8,0x8(%ebx)
    h->vals = (struct list**)kmalloc(MIN_SIZE * sizeof(struct list*));
c0105772:	83 ec 0c             	sub    $0xc,%esp
c0105775:	6a 20                	push   $0x20
c0105777:	e8 29 c1 ff ff       	call   c01018a5 <kmalloc>
c010577c:	89 43 10             	mov    %eax,0x10(%ebx)
    if (h->vals == NULL) {
c010577f:	83 c4 10             	add    $0x10,%esp
c0105782:	85 c0                	test   %eax,%eax
c0105784:	75 06                	jne    c010578c <hashtable_create+0x41>
        kfree(h);
c0105786:	83 ec 0c             	sub    $0xc,%esp
c0105789:	53                   	push   %ebx
c010578a:	eb 1b                	jmp    c01057a7 <hashtable_create+0x5c>
        return NULL;
    }
    /* Allocate lists for the array. */
    int err = init_array_with_lists(h->vals, 0, h->arraysize);
c010578c:	8b 53 08             	mov    0x8(%ebx),%edx
c010578f:	e8 6b ff ff ff       	call   c01056ff <init_array_with_lists.constprop.2>
    if (err == ENOMEM) {
c0105794:	83 f8 02             	cmp    $0x2,%eax
c0105797:	75 1a                	jne    c01057b3 <hashtable_create+0x68>
        kfree(h->vals);
c0105799:	83 ec 0c             	sub    $0xc,%esp
c010579c:	ff 73 10             	pushl  0x10(%ebx)
c010579f:	e8 cd c1 ff ff       	call   c0101971 <kfree>
        kfree(h);
c01057a4:	89 1c 24             	mov    %ebx,(%esp)
c01057a7:	e8 c5 c1 ff ff       	call   c0101971 <kfree>
        return NULL;
c01057ac:	83 c4 10             	add    $0x10,%esp
c01057af:	31 c0                	xor    %eax,%eax
c01057b1:	eb 08                	jmp    c01057bb <hashtable_create+0x70>
    }
    h->datatype = HASHTABLETYPE;
c01057b3:	c7 03 5c 11 00 00    	movl   $0x115c,(%ebx)
    return h;
c01057b9:	89 d8                	mov    %ebx,%eax
}
c01057bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01057be:	c9                   	leave  
c01057bf:	c3                   	ret    

c01057c0 <hashtable_add>:
        return strcmp(l->key, r->key);
    return (l->keylen - r->keylen);
}

int
hashtable_add(struct hashtable* h, char* key, unsigned int keylen, void* val) {
c01057c0:	55                   	push   %ebp
c01057c1:	89 e5                	mov    %esp,%ebp
c01057c3:	57                   	push   %edi
c01057c4:	56                   	push   %esi
c01057c5:	53                   	push   %ebx
c01057c6:	83 ec 2c             	sub    $0x2c,%esp
c01057c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(h != NULL);
c01057cc:	85 db                	test   %ebx,%ebx
c01057ce:	75 2b                	jne    c01057fb <hashtable_add+0x3b>
c01057d0:	83 ec 0c             	sub    $0xc,%esp
c01057d3:	68 8c bf 10 c0       	push   $0xc010bf8c
c01057d8:	68 d7 00 00 00       	push   $0xd7
c01057dd:	68 8b bd 10 c0       	push   $0xc010bd8b
c01057e2:	68 dd bd 10 c0       	push   $0xc010bddd
c01057e7:	68 95 a9 10 c0       	push   $0xc010a995
c01057ec:	e8 d3 e5 ff ff       	call   c0103dc4 <print>
c01057f1:	83 c4 20             	add    $0x20,%esp
c01057f4:	e8 51 b6 ff ff       	call   c0100e4a <backtrace>
c01057f9:	fa                   	cli    
c01057fa:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c01057fb:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105801:	74 2b                	je     c010582e <hashtable_add+0x6e>
c0105803:	83 ec 0c             	sub    $0xc,%esp
c0105806:	68 8c bf 10 c0       	push   $0xc010bf8c
c010580b:	68 d8 00 00 00       	push   $0xd8
c0105810:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105815:	68 e7 bd 10 c0       	push   $0xc010bde7
c010581a:	68 95 a9 10 c0       	push   $0xc010a995
c010581f:	e8 a0 e5 ff ff       	call   c0103dc4 <print>
c0105824:	83 c4 20             	add    $0x20,%esp
c0105827:	e8 1e b6 ff ff       	call   c0100e4a <backtrace>
c010582c:	fa                   	cli    
c010582d:	f4                   	hlt    
    /* If LOAD_FACTOR exceeded, double the size of array. */
    if ((h->size + 1) * LF_MULTIPLE > h->arraysize)
c010582e:	8b 43 04             	mov    0x4(%ebx),%eax
c0105831:	8d 44 00 02          	lea    0x2(%eax,%eax,1),%eax
c0105835:	3b 43 08             	cmp    0x8(%ebx),%eax
c0105838:	0f 86 9b 00 00 00    	jbe    c01058d9 <hashtable_add+0x119>
 */
static
int
grow(struct hashtable* h) {
    assert(h != NULL);
    ASSERT_HASHTABLE(h);
c010583e:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105844:	74 2b                	je     c0105871 <hashtable_add+0xb1>
c0105846:	83 ec 0c             	sub    $0xc,%esp
c0105849:	68 74 bf 10 c0       	push   $0xc010bf74
c010584e:	68 ac 00 00 00       	push   $0xac
c0105853:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105858:	68 e7 bd 10 c0       	push   $0xc010bde7
c010585d:	68 95 a9 10 c0       	push   $0xc010a995
c0105862:	e8 5d e5 ff ff       	call   c0103dc4 <print>
c0105867:	83 c4 20             	add    $0x20,%esp
c010586a:	e8 db b5 ff ff       	call   c0100e4a <backtrace>
c010586f:	fa                   	cli    
c0105870:	f4                   	hlt    
    struct list** old_array = h->vals;
c0105871:	8b 43 10             	mov    0x10(%ebx),%eax
c0105874:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned int old_arraysize = h->arraysize;
c0105877:	8b 73 08             	mov    0x8(%ebx),%esi

    /* allocate a new array twice the size. */
    struct list** new_array
c010587a:	83 ec 0c             	sub    $0xc,%esp
c010587d:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
c0105884:	50                   	push   %eax
c0105885:	e8 1b c0 ff ff       	call   c01018a5 <kmalloc>
c010588a:	89 c7                	mov    %eax,%edi
        = (struct list**)kmalloc(old_arraysize * 2 * sizeof(struct list*));
    if (new_array == NULL)
c010588c:	83 c4 10             	add    $0x10,%esp
c010588f:	85 c0                	test   %eax,%eax
c0105891:	74 46                	je     c01058d9 <hashtable_add+0x119>
        return ENOMEM;
    /* allocate lists for the new array. */
    int err = init_array_with_lists(new_array, 0, old_arraysize * 2);
c0105893:	8d 0c 36             	lea    (%esi,%esi,1),%ecx
c0105896:	89 ca                	mov    %ecx,%edx
c0105898:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c010589b:	e8 5f fe ff ff       	call   c01056ff <init_array_with_lists.constprop.2>
    if (err == ENOMEM)
c01058a0:	83 f8 02             	cmp    $0x2,%eax
c01058a3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01058a6:	74 31                	je     c01058d9 <hashtable_add+0x119>
        return ENOMEM;

    /* replace old array with new array in hash table. */
    h->vals = new_array;
c01058a8:	89 7b 10             	mov    %edi,0x10(%ebx)
    h->size = 0;
c01058ab:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    h->arraysize = old_arraysize * 2;
c01058b2:	89 4b 08             	mov    %ecx,0x8(%ebx)

    /* relocate all items from old array to new array */
    rehash(h, old_array, old_arraysize);
c01058b5:	89 f1                	mov    %esi,%ecx
c01058b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058ba:	89 d8                	mov    %ebx,%eax
c01058bc:	e8 d6 00 00 00       	call   c0105997 <rehash>

    /* cleanup list objects in old array and kfree old array. */
    cleanup_array_with_lists(old_array, 0, old_arraysize);
c01058c1:	89 f2                	mov    %esi,%edx
c01058c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058c6:	e8 ce fd ff ff       	call   c0105699 <cleanup_array_with_lists.constprop.1>
    kfree(old_array);
c01058cb:	83 ec 0c             	sub    $0xc,%esp
c01058ce:	ff 75 d4             	pushl  -0x2c(%ebp)
c01058d1:	e8 9b c0 ff ff       	call   c0101971 <kfree>
c01058d6:	83 c4 10             	add    $0x10,%esp
    ASSERT_HASHTABLE(h);
    /* If LOAD_FACTOR exceeded, double the size of array. */
    if ((h->size + 1) * LF_MULTIPLE > h->arraysize)
        grow(h);
    /* Compute the hash to index into array. */
    int index = hash(key, keylen) % h->arraysize;
c01058d9:	8b 55 10             	mov    0x10(%ebp),%edx
c01058dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058df:	e8 f2 fc ff ff       	call   c01055d6 <hash>
    struct list* chain = h->vals[index];
c01058e4:	31 d2                	xor    %edx,%edx
c01058e6:	f7 73 08             	divl   0x8(%ebx)
c01058e9:	8b 43 10             	mov    0x10(%ebx),%eax
c01058ec:	8b 3c 90             	mov    (%eax,%edx,4),%edi
    assert(chain != NULL);
c01058ef:	85 ff                	test   %edi,%edi
c01058f1:	75 2b                	jne    c010591e <hashtable_add+0x15e>
c01058f3:	83 ec 0c             	sub    $0xc,%esp
c01058f6:	68 8c bf 10 c0       	push   $0xc010bf8c
c01058fb:	68 df 00 00 00       	push   $0xdf
c0105900:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105905:	68 04 be 10 c0       	push   $0xc010be04
c010590a:	68 95 a9 10 c0       	push   $0xc010a995
c010590f:	e8 b0 e4 ff ff       	call   c0103dc4 <print>
c0105914:	83 c4 20             	add    $0x20,%esp
c0105917:	e8 2e b5 ff ff       	call   c0100e4a <backtrace>
c010591c:	fa                   	cli    
c010591d:	f4                   	hlt    

    struct kv_pair query_item;
    query_item.datatype = KVTYPE;
c010591e:	c7 45 d8 5d 11 00 00 	movl   $0x115d,-0x28(%ebp)
    query_item.key = key;
c0105925:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105928:	89 45 dc             	mov    %eax,-0x24(%ebp)
    query_item.keylen = keylen;
c010592b:	8b 45 10             	mov    0x10(%ebp),%eax
c010592e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    /* Remove any existing value with the same key. */
    struct kv_pair* removed
c0105931:	51                   	push   %ecx
c0105932:	68 fe 55 10 c0       	push   $0xc01055fe
c0105937:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010593a:	50                   	push   %eax
c010593b:	57                   	push   %edi
c010593c:	e8 26 f2 ff ff       	call   c0104b67 <list_remove>
c0105941:	89 c6                	mov    %eax,%esi
    void* val;
};

static
struct kv_pair* kv_create(char* key, unsigned int keylen, void* val) {
    struct kv_pair* new_item = (struct kv_pair*)kmalloc(sizeof(struct kv_pair));
c0105943:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
c010594a:	e8 56 bf ff ff       	call   c01018a5 <kmalloc>
    if (new_item == NULL)
c010594f:	83 c4 10             	add    $0x10,%esp
c0105952:	85 c0                	test   %eax,%eax
c0105954:	75 07                	jne    c010595d <hashtable_add+0x19d>
        = (struct kv_pair*)list_remove(chain, &query_item, &key_comparator);

    /* Append the new item to end of chain. */
    struct kv_pair* new_item = kv_create(key, keylen, val);
    if (new_item == NULL)
        return ENOMEM;
c0105956:	b8 02 00 00 00       	mov    $0x2,%eax
c010595b:	eb 32                	jmp    c010598f <hashtable_add+0x1cf>
static
struct kv_pair* kv_create(char* key, unsigned int keylen, void* val) {
    struct kv_pair* new_item = (struct kv_pair*)kmalloc(sizeof(struct kv_pair));
    if (new_item == NULL)
        return NULL;
    new_item->datatype = KVTYPE;
c010595d:	c7 00 5d 11 00 00    	movl   $0x115d,(%eax)
    new_item->key = key;
c0105963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0105966:	89 48 04             	mov    %ecx,0x4(%eax)
    new_item->keylen = keylen;
c0105969:	8b 55 10             	mov    0x10(%ebp),%edx
c010596c:	89 50 08             	mov    %edx,0x8(%eax)
    new_item->val = val;
c010596f:	8b 55 14             	mov    0x14(%ebp),%edx
c0105972:	89 50 0c             	mov    %edx,0xc(%eax)

    /* Append the new item to end of chain. */
    struct kv_pair* new_item = kv_create(key, keylen, val);
    if (new_item == NULL)
        return ENOMEM;
    int err = list_push_back(chain, new_item);
c0105975:	52                   	push   %edx
c0105976:	52                   	push   %edx
c0105977:	50                   	push   %eax
c0105978:	57                   	push   %edi
c0105979:	e8 8c ee ff ff       	call   c010480a <list_push_back>
    if (err == ENOMEM)
c010597e:	83 c4 10             	add    $0x10,%esp
c0105981:	83 f8 02             	cmp    $0x2,%eax
c0105984:	74 d0                	je     c0105956 <hashtable_add+0x196>
        return ENOMEM;

    if (!removed)
        ++h->size;

    return 0;
c0105986:	31 c0                	xor    %eax,%eax
        return ENOMEM;
    int err = list_push_back(chain, new_item);
    if (err == ENOMEM)
        return ENOMEM;

    if (!removed)
c0105988:	85 f6                	test   %esi,%esi
c010598a:	75 03                	jne    c010598f <hashtable_add+0x1cf>
        ++h->size;
c010598c:	ff 43 04             	incl   0x4(%ebx)

    return 0;
}
c010598f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105992:	5b                   	pop    %ebx
c0105993:	5e                   	pop    %esi
c0105994:	5f                   	pop    %edi
c0105995:	5d                   	pop    %ebp
c0105996:	c3                   	ret    

c0105997 <rehash>:
 * in the hashtable.
 */
static
void
rehash(struct hashtable* h,
       struct list** source_array, unsigned int source_size) {
c0105997:	55                   	push   %ebp
c0105998:	89 e5                	mov    %esp,%ebp
c010599a:	57                   	push   %edi
c010599b:	56                   	push   %esi
c010599c:	53                   	push   %ebx
c010599d:	83 ec 1c             	sub    $0x1c,%esp
c01059a0:	89 c7                	mov    %eax,%edi
c01059a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01059a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    assert(h != NULL);
c01059a8:	85 c0                	test   %eax,%eax
c01059aa:	75 2b                	jne    c01059d7 <rehash+0x40>
c01059ac:	83 ec 0c             	sub    $0xc,%esp
c01059af:	68 6c bf 10 c0       	push   $0xc010bf6c
c01059b4:	68 8d 00 00 00       	push   $0x8d
c01059b9:	68 8b bd 10 c0       	push   $0xc010bd8b
c01059be:	68 dd bd 10 c0       	push   $0xc010bddd
c01059c3:	68 95 a9 10 c0       	push   $0xc010a995
c01059c8:	e8 f7 e3 ff ff       	call   c0103dc4 <print>
c01059cd:	83 c4 20             	add    $0x20,%esp
c01059d0:	e8 75 b4 ff ff       	call   c0100e4a <backtrace>
c01059d5:	fa                   	cli    
c01059d6:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c01059d7:	81 3f 5c 11 00 00    	cmpl   $0x115c,(%edi)
c01059dd:	74 2b                	je     c0105a0a <rehash+0x73>
c01059df:	83 ec 0c             	sub    $0xc,%esp
c01059e2:	68 6c bf 10 c0       	push   $0xc010bf6c
c01059e7:	68 8e 00 00 00       	push   $0x8e
c01059ec:	68 8b bd 10 c0       	push   $0xc010bd8b
c01059f1:	68 e7 bd 10 c0       	push   $0xc010bde7
c01059f6:	68 95 a9 10 c0       	push   $0xc010a995
c01059fb:	e8 c4 e3 ff ff       	call   c0103dc4 <print>
c0105a00:	83 c4 20             	add    $0x20,%esp
c0105a03:	e8 42 b4 ff ff       	call   c0100e4a <backtrace>
c0105a08:	fa                   	cli    
c0105a09:	f4                   	hlt    
 * in the hashtable.
 */
static
void
rehash(struct hashtable* h,
       struct list** source_array, unsigned int source_size) {
c0105a0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    assert(h != NULL);
    ASSERT_HASHTABLE(h);
    unsigned int i;
    struct list* chain;
    struct kv_pair* item;
    for (i = 0; i < source_size; ++i) {
c0105a11:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105a14:	39 4d e4             	cmp    %ecx,-0x1c(%ebp)
c0105a17:	0f 84 f8 00 00 00    	je     c0105b15 <rehash+0x17e>
        chain = source_array[i];
c0105a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a23:	8b 1c 90             	mov    (%eax,%edx,4),%ebx
        assert(chain != NULL);
c0105a26:	85 db                	test   %ebx,%ebx
c0105a28:	75 2b                	jne    c0105a55 <rehash+0xbe>
c0105a2a:	83 ec 0c             	sub    $0xc,%esp
c0105a2d:	68 6c bf 10 c0       	push   $0xc010bf6c
c0105a32:	68 94 00 00 00       	push   $0x94
c0105a37:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105a3c:	68 04 be 10 c0       	push   $0xc010be04
c0105a41:	68 95 a9 10 c0       	push   $0xc010a995
c0105a46:	e8 79 e3 ff ff       	call   c0103dc4 <print>
c0105a4b:	83 c4 20             	add    $0x20,%esp
c0105a4e:	e8 f7 b3 ff ff       	call   c0100e4a <backtrace>
c0105a53:	fa                   	cli    
c0105a54:	f4                   	hlt    
        if (list_getsize(chain) > 0) {
c0105a55:	83 ec 0c             	sub    $0xc,%esp
c0105a58:	53                   	push   %ebx
c0105a59:	e8 87 f2 ff ff       	call   c0104ce5 <list_getsize>
c0105a5e:	83 c4 10             	add    $0x10,%esp
c0105a61:	85 c0                	test   %eax,%eax
c0105a63:	0f 84 a4 00 00 00    	je     c0105b0d <rehash+0x176>
            item = (struct kv_pair*)list_front(chain);
c0105a69:	83 ec 0c             	sub    $0xc,%esp
c0105a6c:	53                   	push   %ebx
            while (item) {
                ASSERT_KV(item);
                hashtable_add(h, item->key, item->keylen, item->val);
                list_pop_front(chain);
                kfree(item);
                item = (struct kv_pair*)list_front(chain);
c0105a6d:	e8 5f ef ff ff       	call   c01049d1 <list_front>
c0105a72:	89 c6                	mov    %eax,%esi
c0105a74:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < source_size; ++i) {
        chain = source_array[i];
        assert(chain != NULL);
        if (list_getsize(chain) > 0) {
            item = (struct kv_pair*)list_front(chain);
            while (item) {
c0105a77:	85 c0                	test   %eax,%eax
c0105a79:	74 57                	je     c0105ad2 <rehash+0x13b>
                ASSERT_KV(item);
c0105a7b:	81 3e 5d 11 00 00    	cmpl   $0x115d,(%esi)
c0105a81:	74 2b                	je     c0105aae <rehash+0x117>
c0105a83:	83 ec 0c             	sub    $0xc,%esp
c0105a86:	68 6c bf 10 c0       	push   $0xc010bf6c
c0105a8b:	68 98 00 00 00       	push   $0x98
c0105a90:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105a95:	68 12 be 10 c0       	push   $0xc010be12
c0105a9a:	68 95 a9 10 c0       	push   $0xc010a995
c0105a9f:	e8 20 e3 ff ff       	call   c0103dc4 <print>
c0105aa4:	83 c4 20             	add    $0x20,%esp
c0105aa7:	e8 9e b3 ff ff       	call   c0100e4a <backtrace>
c0105aac:	fa                   	cli    
c0105aad:	f4                   	hlt    
                hashtable_add(h, item->key, item->keylen, item->val);
c0105aae:	ff 76 0c             	pushl  0xc(%esi)
c0105ab1:	ff 76 08             	pushl  0x8(%esi)
c0105ab4:	ff 76 04             	pushl  0x4(%esi)
c0105ab7:	57                   	push   %edi
c0105ab8:	e8 03 fd ff ff       	call   c01057c0 <hashtable_add>
                list_pop_front(chain);
c0105abd:	89 1c 24             	mov    %ebx,(%esp)
c0105ac0:	e8 45 ee ff ff       	call   c010490a <list_pop_front>
                kfree(item);
c0105ac5:	89 34 24             	mov    %esi,(%esp)
c0105ac8:	e8 a4 be ff ff       	call   c0101971 <kfree>
                item = (struct kv_pair*)list_front(chain);
c0105acd:	89 1c 24             	mov    %ebx,(%esp)
c0105ad0:	eb 9b                	jmp    c0105a6d <rehash+0xd6>
            }
            assert(list_getsize(chain) == 0);
c0105ad2:	83 ec 0c             	sub    $0xc,%esp
c0105ad5:	53                   	push   %ebx
c0105ad6:	e8 0a f2 ff ff       	call   c0104ce5 <list_getsize>
c0105adb:	83 c4 10             	add    $0x10,%esp
c0105ade:	85 c0                	test   %eax,%eax
c0105ae0:	74 2b                	je     c0105b0d <rehash+0x176>
c0105ae2:	83 ec 0c             	sub    $0xc,%esp
c0105ae5:	68 6c bf 10 c0       	push   $0xc010bf6c
c0105aea:	68 9e 00 00 00       	push   $0x9e
c0105aef:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105af4:	68 2b be 10 c0       	push   $0xc010be2b
c0105af9:	68 95 a9 10 c0       	push   $0xc010a995
c0105afe:	e8 c1 e2 ff ff       	call   c0103dc4 <print>
c0105b03:	83 c4 20             	add    $0x20,%esp
c0105b06:	e8 3f b3 ff ff       	call   c0100e4a <backtrace>
c0105b0b:	fa                   	cli    
c0105b0c:	f4                   	hlt    
    assert(h != NULL);
    ASSERT_HASHTABLE(h);
    unsigned int i;
    struct list* chain;
    struct kv_pair* item;
    for (i = 0; i < source_size; ++i) {
c0105b0d:	ff 45 e4             	incl   -0x1c(%ebp)
c0105b10:	e9 fc fe ff ff       	jmp    c0105a11 <rehash+0x7a>
                item = (struct kv_pair*)list_front(chain);
            }
            assert(list_getsize(chain) == 0);
        }
    }
}
c0105b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105b18:	5b                   	pop    %ebx
c0105b19:	5e                   	pop    %esi
c0105b1a:	5f                   	pop    %edi
c0105b1b:	5d                   	pop    %ebp
c0105b1c:	c3                   	ret    

c0105b1d <hashtable_find>:

    return 0;
}

void*
hashtable_find(struct hashtable* h, char* key, unsigned int keylen) {
c0105b1d:	55                   	push   %ebp
c0105b1e:	89 e5                	mov    %esp,%ebp
c0105b20:	57                   	push   %edi
c0105b21:	56                   	push   %esi
c0105b22:	53                   	push   %ebx
c0105b23:	83 ec 1c             	sub    $0x1c,%esp
c0105b26:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0105b29:	8b 7d 0c             	mov    0xc(%ebp),%edi
c0105b2c:	8b 75 10             	mov    0x10(%ebp),%esi
    assert(h != NULL);
c0105b2f:	85 db                	test   %ebx,%ebx
c0105b31:	75 2b                	jne    c0105b5e <hashtable_find+0x41>
c0105b33:	83 ec 0c             	sub    $0xc,%esp
c0105b36:	68 40 bf 10 c0       	push   $0xc010bf40
c0105b3b:	68 fa 00 00 00       	push   $0xfa
c0105b40:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105b45:	68 dd bd 10 c0       	push   $0xc010bddd
c0105b4a:	68 95 a9 10 c0       	push   $0xc010a995
c0105b4f:	e8 70 e2 ff ff       	call   c0103dc4 <print>
c0105b54:	83 c4 20             	add    $0x20,%esp
c0105b57:	e8 ee b2 ff ff       	call   c0100e4a <backtrace>
c0105b5c:	fa                   	cli    
c0105b5d:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c0105b5e:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105b64:	74 2b                	je     c0105b91 <hashtable_find+0x74>
c0105b66:	83 ec 0c             	sub    $0xc,%esp
c0105b69:	68 40 bf 10 c0       	push   $0xc010bf40
c0105b6e:	68 fb 00 00 00       	push   $0xfb
c0105b73:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105b78:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105b7d:	68 95 a9 10 c0       	push   $0xc010a995
c0105b82:	e8 3d e2 ff ff       	call   c0103dc4 <print>
c0105b87:	83 c4 20             	add    $0x20,%esp
c0105b8a:	e8 bb b2 ff ff       	call   c0100e4a <backtrace>
c0105b8f:	fa                   	cli    
c0105b90:	f4                   	hlt    

    /* Compute the hash to index into array. */
    int index = hash(key, keylen) % h->arraysize;
c0105b91:	89 f2                	mov    %esi,%edx
c0105b93:	89 f8                	mov    %edi,%eax
c0105b95:	e8 3c fa ff ff       	call   c01055d6 <hash>
    struct list* chain = h->vals[index];
c0105b9a:	31 d2                	xor    %edx,%edx
c0105b9c:	f7 73 08             	divl   0x8(%ebx)
c0105b9f:	8b 43 10             	mov    0x10(%ebx),%eax
c0105ba2:	8b 1c 90             	mov    (%eax,%edx,4),%ebx
    assert(chain != NULL);
c0105ba5:	85 db                	test   %ebx,%ebx
c0105ba7:	75 2b                	jne    c0105bd4 <hashtable_find+0xb7>
c0105ba9:	83 ec 0c             	sub    $0xc,%esp
c0105bac:	68 40 bf 10 c0       	push   $0xc010bf40
c0105bb1:	68 00 01 00 00       	push   $0x100
c0105bb6:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105bbb:	68 04 be 10 c0       	push   $0xc010be04
c0105bc0:	68 95 a9 10 c0       	push   $0xc010a995
c0105bc5:	e8 fa e1 ff ff       	call   c0103dc4 <print>
c0105bca:	83 c4 20             	add    $0x20,%esp
c0105bcd:	e8 78 b2 ff ff       	call   c0100e4a <backtrace>
c0105bd2:	fa                   	cli    
c0105bd3:	f4                   	hlt    

    /* Build a kv_pair object with the query key. */
    struct kv_pair query_item;
    query_item.datatype = KVTYPE;
c0105bd4:	c7 45 d8 5d 11 00 00 	movl   $0x115d,-0x28(%ebp)
    query_item.key = key;
c0105bdb:	89 7d dc             	mov    %edi,-0x24(%ebp)
    query_item.keylen = keylen;
c0105bde:	89 75 e0             	mov    %esi,-0x20(%ebp)

    struct kv_pair* found
c0105be1:	50                   	push   %eax
c0105be2:	68 fe 55 10 c0       	push   $0xc01055fe
c0105be7:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0105bea:	50                   	push   %eax
c0105beb:	53                   	push   %ebx
c0105bec:	e8 b8 ee ff ff       	call   c0104aa9 <list_find>
c0105bf1:	89 c3                	mov    %eax,%ebx
        = (struct kv_pair*)list_find(chain, &query_item, &key_comparator);
    if (found == NULL)
c0105bf3:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0105bf6:	31 c0                	xor    %eax,%eax
    query_item.key = key;
    query_item.keylen = keylen;

    struct kv_pair* found
        = (struct kv_pair*)list_find(chain, &query_item, &key_comparator);
    if (found == NULL)
c0105bf8:	85 db                	test   %ebx,%ebx
c0105bfa:	74 36                	je     c0105c32 <hashtable_find+0x115>
        return NULL;
    ASSERT_KV(found);
c0105bfc:	81 3b 5d 11 00 00    	cmpl   $0x115d,(%ebx)
c0105c02:	74 2b                	je     c0105c2f <hashtable_find+0x112>
c0105c04:	83 ec 0c             	sub    $0xc,%esp
c0105c07:	68 40 bf 10 c0       	push   $0xc010bf40
c0105c0c:	68 0c 01 00 00       	push   $0x10c
c0105c11:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105c16:	68 44 be 10 c0       	push   $0xc010be44
c0105c1b:	68 95 a9 10 c0       	push   $0xc010a995
c0105c20:	e8 9f e1 ff ff       	call   c0103dc4 <print>
c0105c25:	83 c4 20             	add    $0x20,%esp
c0105c28:	e8 1d b2 ff ff       	call   c0100e4a <backtrace>
c0105c2d:	fa                   	cli    
c0105c2e:	f4                   	hlt    
    return found->val;
c0105c2f:	8b 43 0c             	mov    0xc(%ebx),%eax
}
c0105c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105c35:	5b                   	pop    %ebx
c0105c36:	5e                   	pop    %esi
c0105c37:	5f                   	pop    %edi
c0105c38:	5d                   	pop    %ebp
c0105c39:	c3                   	ret    

c0105c3a <hashtable_remove>:

    return 0;
}

void*
hashtable_remove(struct hashtable* h, char* key, unsigned int keylen) {
c0105c3a:	55                   	push   %ebp
c0105c3b:	89 e5                	mov    %esp,%ebp
c0105c3d:	57                   	push   %edi
c0105c3e:	56                   	push   %esi
c0105c3f:	53                   	push   %ebx
c0105c40:	83 ec 2c             	sub    $0x2c,%esp
c0105c43:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0105c46:	8b 7d 0c             	mov    0xc(%ebp),%edi
    assert(h != NULL);
c0105c49:	85 db                	test   %ebx,%ebx
c0105c4b:	75 2b                	jne    c0105c78 <hashtable_remove+0x3e>
c0105c4d:	83 ec 0c             	sub    $0xc,%esp
c0105c50:	68 2c bf 10 c0       	push   $0xc010bf2c
c0105c55:	68 39 01 00 00       	push   $0x139
c0105c5a:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105c5f:	68 dd bd 10 c0       	push   $0xc010bddd
c0105c64:	68 95 a9 10 c0       	push   $0xc010a995
c0105c69:	e8 56 e1 ff ff       	call   c0103dc4 <print>
c0105c6e:	83 c4 20             	add    $0x20,%esp
c0105c71:	e8 d4 b1 ff ff       	call   c0100e4a <backtrace>
c0105c76:	fa                   	cli    
c0105c77:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c0105c78:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105c7e:	74 2b                	je     c0105cab <hashtable_remove+0x71>
c0105c80:	83 ec 0c             	sub    $0xc,%esp
c0105c83:	68 2c bf 10 c0       	push   $0xc010bf2c
c0105c88:	68 3a 01 00 00       	push   $0x13a
c0105c8d:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105c92:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105c97:	68 95 a9 10 c0       	push   $0xc010a995
c0105c9c:	e8 23 e1 ff ff       	call   c0103dc4 <print>
c0105ca1:	83 c4 20             	add    $0x20,%esp
c0105ca4:	e8 a1 b1 ff ff       	call   c0100e4a <backtrace>
c0105ca9:	fa                   	cli    
c0105caa:	f4                   	hlt    

    /* Compute the hash to index into array. */
    int index = hash(key, keylen) % h->arraysize;
c0105cab:	8b 55 10             	mov    0x10(%ebp),%edx
c0105cae:	89 f8                	mov    %edi,%eax
c0105cb0:	e8 21 f9 ff ff       	call   c01055d6 <hash>
    struct list* chain = h->vals[index];
c0105cb5:	31 d2                	xor    %edx,%edx
c0105cb7:	f7 73 08             	divl   0x8(%ebx)
c0105cba:	8b 43 10             	mov    0x10(%ebx),%eax
c0105cbd:	8b 34 90             	mov    (%eax,%edx,4),%esi
    assert(chain != NULL);
c0105cc0:	85 f6                	test   %esi,%esi
c0105cc2:	75 2b                	jne    c0105cef <hashtable_remove+0xb5>
c0105cc4:	83 ec 0c             	sub    $0xc,%esp
c0105cc7:	68 2c bf 10 c0       	push   $0xc010bf2c
c0105ccc:	68 3f 01 00 00       	push   $0x13f
c0105cd1:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105cd6:	68 04 be 10 c0       	push   $0xc010be04
c0105cdb:	68 95 a9 10 c0       	push   $0xc010a995
c0105ce0:	e8 df e0 ff ff       	call   c0103dc4 <print>
c0105ce5:	83 c4 20             	add    $0x20,%esp
c0105ce8:	e8 5d b1 ff ff       	call   c0100e4a <backtrace>
c0105ced:	fa                   	cli    
c0105cee:	f4                   	hlt    

    /* Build a kv_pair object with the query key. */
    struct kv_pair query_item;
    query_item.datatype = KVTYPE;
c0105cef:	c7 45 d8 5d 11 00 00 	movl   $0x115d,-0x28(%ebp)
    query_item.key = key;
c0105cf6:	89 7d dc             	mov    %edi,-0x24(%ebp)
    query_item.keylen = keylen;
c0105cf9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cfc:	89 45 e0             	mov    %eax,-0x20(%ebp)

    struct kv_pair* removed
c0105cff:	50                   	push   %eax
c0105d00:	68 fe 55 10 c0       	push   $0xc01055fe
c0105d05:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105d08:	52                   	push   %edx
c0105d09:	56                   	push   %esi
c0105d0a:	e8 58 ee ff ff       	call   c0104b67 <list_remove>
c0105d0f:	89 c6                	mov    %eax,%esi
        = (struct kv_pair*)list_remove(chain, &query_item, &key_comparator);
    if (removed == NULL) {
c0105d11:	83 c4 10             	add    $0x10,%esp
        /* Key does not exist. */
        return NULL;
c0105d14:	31 c0                	xor    %eax,%eax
    query_item.key = key;
    query_item.keylen = keylen;

    struct kv_pair* removed
        = (struct kv_pair*)list_remove(chain, &query_item, &key_comparator);
    if (removed == NULL) {
c0105d16:	85 f6                	test   %esi,%esi
c0105d18:	0f 84 04 01 00 00    	je     c0105e22 <hashtable_remove+0x1e8>
        /* Key does not exist. */
        return NULL;
    }
    ASSERT_KV(removed);
c0105d1e:	81 3e 5d 11 00 00    	cmpl   $0x115d,(%esi)
c0105d24:	74 2b                	je     c0105d51 <hashtable_remove+0x117>
c0105d26:	83 ec 0c             	sub    $0xc,%esp
c0105d29:	68 2c bf 10 c0       	push   $0xc010bf2c
c0105d2e:	68 4d 01 00 00       	push   $0x14d
c0105d33:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105d38:	68 5e be 10 c0       	push   $0xc010be5e
c0105d3d:	68 95 a9 10 c0       	push   $0xc010a995
c0105d42:	e8 7d e0 ff ff       	call   c0103dc4 <print>
c0105d47:	83 c4 20             	add    $0x20,%esp
c0105d4a:	e8 fb b0 ff ff       	call   c0100e4a <backtrace>
c0105d4f:	fa                   	cli    
c0105d50:	f4                   	hlt    

    /* Key value pair removed. */
    --h->size;
c0105d51:	8b 53 04             	mov    0x4(%ebx),%edx
c0105d54:	8d 42 ff             	lea    -0x1(%edx),%eax
c0105d57:	89 43 04             	mov    %eax,0x4(%ebx)
    if (h->arraysize > MIN_SIZE &&
c0105d5a:	8b 43 08             	mov    0x8(%ebx),%eax
c0105d5d:	83 f8 08             	cmp    $0x8,%eax
c0105d60:	0f 86 ab 00 00 00    	jbe    c0105e11 <hashtable_remove+0x1d7>
c0105d66:	8d 54 12 fc          	lea    -0x4(%edx,%edx,1),%edx
c0105d6a:	39 d0                	cmp    %edx,%eax
c0105d6c:	0f 86 9f 00 00 00    	jbe    c0105e11 <hashtable_remove+0x1d7>
 */
static
int
shrink(struct hashtable* h) {
    assert(h != NULL);
    ASSERT_HASHTABLE(h);
c0105d72:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105d78:	74 2b                	je     c0105da5 <hashtable_remove+0x16b>
c0105d7a:	83 ec 0c             	sub    $0xc,%esp
c0105d7d:	68 24 bf 10 c0       	push   $0xc010bf24
c0105d82:	68 19 01 00 00       	push   $0x119
c0105d87:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105d8c:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105d91:	68 95 a9 10 c0       	push   $0xc010a995
c0105d96:	e8 29 e0 ff ff       	call   c0103dc4 <print>
c0105d9b:	83 c4 20             	add    $0x20,%esp
c0105d9e:	e8 a7 b0 ff ff       	call   c0100e4a <backtrace>
c0105da3:	fa                   	cli    
c0105da4:	f4                   	hlt    
    struct list** old_array = h->vals;
c0105da5:	8b 43 10             	mov    0x10(%ebx),%eax
c0105da8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned int old_arraysize = h->arraysize;
c0105dab:	8b 43 08             	mov    0x8(%ebx),%eax
c0105dae:	89 45 d0             	mov    %eax,-0x30(%ebp)
    unsigned int new_arraysize = old_arraysize / 2;
c0105db1:	89 c7                	mov    %eax,%edi
c0105db3:	d1 ef                	shr    %edi

    /* Allocate a new array half the size. */
    struct list** new_array
c0105db5:	83 ec 0c             	sub    $0xc,%esp
c0105db8:	8d 04 bd 00 00 00 00 	lea    0x0(,%edi,4),%eax
c0105dbf:	50                   	push   %eax
c0105dc0:	e8 e0 ba ff ff       	call   c01018a5 <kmalloc>
        = (struct list**)kmalloc(new_arraysize * sizeof(struct list*));
    if (new_array == NULL)
c0105dc5:	83 c4 10             	add    $0x10,%esp
c0105dc8:	85 c0                	test   %eax,%eax
c0105dca:	74 45                	je     c0105e11 <hashtable_remove+0x1d7>
        return ENOMEM;
    /* Allocate lists for the new array. */
    int err = init_array_with_lists(new_array, 0, new_arraysize);
c0105dcc:	89 fa                	mov    %edi,%edx
c0105dce:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0105dd1:	e8 29 f9 ff ff       	call   c01056ff <init_array_with_lists.constprop.2>
    if (err == ENOMEM)
c0105dd6:	83 f8 02             	cmp    $0x2,%eax
c0105dd9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0105ddc:	74 33                	je     c0105e11 <hashtable_remove+0x1d7>
        return ENOMEM;

    /* replace old array with new array in hash table. */
    h->vals = new_array;
c0105dde:	89 4b 10             	mov    %ecx,0x10(%ebx)
    h->size = 0;
c0105de1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    h->arraysize = new_arraysize;
c0105de8:	89 7b 08             	mov    %edi,0x8(%ebx)

    /* relocate all items from old array to new array */
    rehash(h, old_array, old_arraysize);
c0105deb:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0105dee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105df1:	89 d8                	mov    %ebx,%eax
c0105df3:	e8 9f fb ff ff       	call   c0105997 <rehash>

    /* cleanup list objects in old array and kfree old array. */
    cleanup_array_with_lists(old_array, 0, old_arraysize);
c0105df8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105dfb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105dfe:	e8 96 f8 ff ff       	call   c0105699 <cleanup_array_with_lists.constprop.1>
    kfree(old_array);
c0105e03:	83 ec 0c             	sub    $0xc,%esp
c0105e06:	ff 75 d4             	pushl  -0x2c(%ebp)
c0105e09:	e8 63 bb ff ff       	call   c0101971 <kfree>
c0105e0e:	83 c4 10             	add    $0x10,%esp
    if (h->arraysize > MIN_SIZE &&
            (h->size - 1) * LF_MULTIPLE < h->arraysize) {
        /* Half the size of array. */
        shrink(h);
    }
    void* res = removed->val;
c0105e11:	8b 5e 0c             	mov    0xc(%esi),%ebx
    kfree(removed);
c0105e14:	83 ec 0c             	sub    $0xc,%esp
c0105e17:	56                   	push   %esi
c0105e18:	e8 54 bb ff ff       	call   c0101971 <kfree>

    return res;
c0105e1d:	83 c4 10             	add    $0x10,%esp
c0105e20:	89 d8                	mov    %ebx,%eax
}
c0105e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105e25:	5b                   	pop    %ebx
c0105e26:	5e                   	pop    %esi
c0105e27:	5f                   	pop    %edi
c0105e28:	5d                   	pop    %ebp
c0105e29:	c3                   	ret    

c0105e2a <hashtable_isempty>:

int
hashtable_isempty(struct hashtable* h) {
c0105e2a:	55                   	push   %ebp
c0105e2b:	89 e5                	mov    %esp,%ebp
c0105e2d:	53                   	push   %ebx
c0105e2e:	50                   	push   %eax
c0105e2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(h != NULL);
c0105e32:	85 db                	test   %ebx,%ebx
c0105e34:	75 2b                	jne    c0105e61 <hashtable_isempty+0x37>
c0105e36:	83 ec 0c             	sub    $0xc,%esp
c0105e39:	68 10 bf 10 c0       	push   $0xc010bf10
c0105e3e:	68 5e 01 00 00       	push   $0x15e
c0105e43:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105e48:	68 dd bd 10 c0       	push   $0xc010bddd
c0105e4d:	68 95 a9 10 c0       	push   $0xc010a995
c0105e52:	e8 6d df ff ff       	call   c0103dc4 <print>
c0105e57:	83 c4 20             	add    $0x20,%esp
c0105e5a:	e8 eb af ff ff       	call   c0100e4a <backtrace>
c0105e5f:	fa                   	cli    
c0105e60:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c0105e61:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105e67:	74 2b                	je     c0105e94 <hashtable_isempty+0x6a>
c0105e69:	83 ec 0c             	sub    $0xc,%esp
c0105e6c:	68 10 bf 10 c0       	push   $0xc010bf10
c0105e71:	68 5f 01 00 00       	push   $0x15f
c0105e76:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105e7b:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105e80:	68 95 a9 10 c0       	push   $0xc010a995
c0105e85:	e8 3a df ff ff       	call   c0103dc4 <print>
c0105e8a:	83 c4 20             	add    $0x20,%esp
c0105e8d:	e8 b8 af ff ff       	call   c0100e4a <backtrace>
c0105e92:	fa                   	cli    
c0105e93:	f4                   	hlt    
    return (h->size == 0);
c0105e94:	31 c0                	xor    %eax,%eax
c0105e96:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
c0105e9a:	0f 94 c0             	sete   %al
}
c0105e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105ea0:	c9                   	leave  
c0105ea1:	c3                   	ret    

c0105ea2 <hashtable_getsize>:

unsigned int
hashtable_getsize(struct hashtable* h) {
c0105ea2:	55                   	push   %ebp
c0105ea3:	89 e5                	mov    %esp,%ebp
c0105ea5:	53                   	push   %ebx
c0105ea6:	50                   	push   %eax
c0105ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(h != NULL);
c0105eaa:	85 db                	test   %ebx,%ebx
c0105eac:	75 2b                	jne    c0105ed9 <hashtable_getsize+0x37>
c0105eae:	83 ec 0c             	sub    $0xc,%esp
c0105eb1:	68 fc be 10 c0       	push   $0xc010befc
c0105eb6:	68 65 01 00 00       	push   $0x165
c0105ebb:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105ec0:	68 dd bd 10 c0       	push   $0xc010bddd
c0105ec5:	68 95 a9 10 c0       	push   $0xc010a995
c0105eca:	e8 f5 de ff ff       	call   c0103dc4 <print>
c0105ecf:	83 c4 20             	add    $0x20,%esp
c0105ed2:	e8 73 af ff ff       	call   c0100e4a <backtrace>
c0105ed7:	fa                   	cli    
c0105ed8:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c0105ed9:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105edf:	74 2b                	je     c0105f0c <hashtable_getsize+0x6a>
c0105ee1:	83 ec 0c             	sub    $0xc,%esp
c0105ee4:	68 fc be 10 c0       	push   $0xc010befc
c0105ee9:	68 66 01 00 00       	push   $0x166
c0105eee:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105ef3:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105ef8:	68 95 a9 10 c0       	push   $0xc010a995
c0105efd:	e8 c2 de ff ff       	call   c0103dc4 <print>
c0105f02:	83 c4 20             	add    $0x20,%esp
c0105f05:	e8 40 af ff ff       	call   c0100e4a <backtrace>
c0105f0a:	fa                   	cli    
c0105f0b:	f4                   	hlt    
    return h->size;
c0105f0c:	8b 43 04             	mov    0x4(%ebx),%eax
}
c0105f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105f12:	c9                   	leave  
c0105f13:	c3                   	ret    

c0105f14 <hashtable_destroy>:

void
hashtable_destroy(struct hashtable* h) {
c0105f14:	55                   	push   %ebp
c0105f15:	89 e5                	mov    %esp,%ebp
c0105f17:	53                   	push   %ebx
c0105f18:	50                   	push   %eax
c0105f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (h != NULL) {
c0105f1c:	85 db                	test   %ebx,%ebx
c0105f1e:	74 4c                	je     c0105f6c <hashtable_destroy+0x58>
        ASSERT_HASHTABLE(h);
c0105f20:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105f26:	74 2b                	je     c0105f53 <hashtable_destroy+0x3f>
c0105f28:	83 ec 0c             	sub    $0xc,%esp
c0105f2b:	68 e8 be 10 c0       	push   $0xc010bee8
c0105f30:	68 6d 01 00 00       	push   $0x16d
c0105f35:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105f3a:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105f3f:	68 95 a9 10 c0       	push   $0xc010a995
c0105f44:	e8 7b de ff ff       	call   c0103dc4 <print>
c0105f49:	83 c4 20             	add    $0x20,%esp
c0105f4c:	e8 f9 ae ff ff       	call   c0100e4a <backtrace>
c0105f51:	fa                   	cli    
c0105f52:	f4                   	hlt    
        cleanup_array_with_lists(h->vals, 0, h->arraysize);
c0105f53:	8b 53 08             	mov    0x8(%ebx),%edx
c0105f56:	8b 43 10             	mov    0x10(%ebx),%eax
c0105f59:	e8 3b f7 ff ff       	call   c0105699 <cleanup_array_with_lists.constprop.1>
        kfree(h->vals);
c0105f5e:	83 ec 0c             	sub    $0xc,%esp
c0105f61:	ff 73 10             	pushl  0x10(%ebx)
c0105f64:	e8 08 ba ff ff       	call   c0101971 <kfree>
c0105f69:	83 c4 10             	add    $0x10,%esp
    }
    kfree(h);
c0105f6c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c0105f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0105f72:	c9                   	leave  
    if (h != NULL) {
        ASSERT_HASHTABLE(h);
        cleanup_array_with_lists(h->vals, 0, h->arraysize);
        kfree(h->vals);
    }
    kfree(h);
c0105f73:	e9 f9 b9 ff ff       	jmp    c0101971 <kfree>

c0105f78 <hashtable_assertvalid>:
}

void
hashtable_assertvalid(struct hashtable* h) {
c0105f78:	55                   	push   %ebp
c0105f79:	89 e5                	mov    %esp,%ebp
c0105f7b:	57                   	push   %edi
c0105f7c:	56                   	push   %esi
c0105f7d:	53                   	push   %ebx
c0105f7e:	83 ec 1c             	sub    $0x1c,%esp
c0105f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(h != NULL);
c0105f84:	85 db                	test   %ebx,%ebx
c0105f86:	75 2b                	jne    c0105fb3 <hashtable_assertvalid+0x3b>
c0105f88:	83 ec 0c             	sub    $0xc,%esp
c0105f8b:	68 d0 be 10 c0       	push   $0xc010bed0
c0105f90:	68 76 01 00 00       	push   $0x176
c0105f95:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105f9a:	68 dd bd 10 c0       	push   $0xc010bddd
c0105f9f:	68 95 a9 10 c0       	push   $0xc010a995
c0105fa4:	e8 1b de ff ff       	call   c0103dc4 <print>
c0105fa9:	83 c4 20             	add    $0x20,%esp
c0105fac:	e8 99 ae ff ff       	call   c0100e4a <backtrace>
c0105fb1:	fa                   	cli    
c0105fb2:	f4                   	hlt    
    ASSERT_HASHTABLE(h);
c0105fb3:	81 3b 5c 11 00 00    	cmpl   $0x115c,(%ebx)
c0105fb9:	74 2b                	je     c0105fe6 <hashtable_assertvalid+0x6e>
c0105fbb:	83 ec 0c             	sub    $0xc,%esp
c0105fbe:	68 d0 be 10 c0       	push   $0xc010bed0
c0105fc3:	68 77 01 00 00       	push   $0x177
c0105fc8:	68 8b bd 10 c0       	push   $0xc010bd8b
c0105fcd:	68 e7 bd 10 c0       	push   $0xc010bde7
c0105fd2:	68 95 a9 10 c0       	push   $0xc010a995
c0105fd7:	e8 e8 dd ff ff       	call   c0103dc4 <print>
c0105fdc:	83 c4 20             	add    $0x20,%esp
c0105fdf:	e8 66 ae ff ff       	call   c0100e4a <backtrace>
c0105fe4:	fa                   	cli    
c0105fe5:	f4                   	hlt    
        assert(chain != NULL);
        list_assertvalid(chain);
        size = list_getsize(chain);
        count += size;
        /* check if key hashes to the correct index */
        for (j = 0; j < size; ++j) {
c0105fe6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0105fed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    /* Validate if the size of items in the hashtable is correct. */
    unsigned int count = 0;
    unsigned int i, j, size;
    struct list* chain;
    struct kv_pair* kv;
    for (i = 0; i < h->arraysize; ++i) {
c0105ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ff7:	3b 43 08             	cmp    0x8(%ebx),%eax
c0105ffa:	0f 83 0b 01 00 00    	jae    c010610b <hashtable_assertvalid+0x193>
        chain = h->vals[i];
c0106000:	8b 43 10             	mov    0x10(%ebx),%eax
c0106003:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0106006:	8b 34 88             	mov    (%eax,%ecx,4),%esi
        assert(chain != NULL);
c0106009:	85 f6                	test   %esi,%esi
c010600b:	75 2b                	jne    c0106038 <hashtable_assertvalid+0xc0>
c010600d:	83 ec 0c             	sub    $0xc,%esp
c0106010:	68 d0 be 10 c0       	push   $0xc010bed0
c0106015:	68 7f 01 00 00       	push   $0x17f
c010601a:	68 8b bd 10 c0       	push   $0xc010bd8b
c010601f:	68 04 be 10 c0       	push   $0xc010be04
c0106024:	68 95 a9 10 c0       	push   $0xc010a995
c0106029:	e8 96 dd ff ff       	call   c0103dc4 <print>
c010602e:	83 c4 20             	add    $0x20,%esp
c0106031:	e8 14 ae ff ff       	call   c0100e4a <backtrace>
c0106036:	fa                   	cli    
c0106037:	f4                   	hlt    
        list_assertvalid(chain);
c0106038:	83 ec 0c             	sub    $0xc,%esp
c010603b:	56                   	push   %esi
c010603c:	e8 b5 ed ff ff       	call   c0104df6 <list_assertvalid>
        size = list_getsize(chain);
c0106041:	89 34 24             	mov    %esi,(%esp)
c0106044:	e8 9c ec ff ff       	call   c0104ce5 <list_getsize>
c0106049:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count += size;
c010604c:	01 45 e0             	add    %eax,-0x20(%ebp)
        /* check if key hashes to the correct index */
        for (j = 0; j < size; ++j) {
c010604f:	83 c4 10             	add    $0x10,%esp
c0106052:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106059:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010605c:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
c010605f:	0f 84 9e 00 00 00    	je     c0106103 <hashtable_assertvalid+0x18b>
            kv = (struct kv_pair*)list_front(chain);
c0106065:	83 ec 0c             	sub    $0xc,%esp
c0106068:	56                   	push   %esi
c0106069:	e8 63 e9 ff ff       	call   c01049d1 <list_front>
c010606e:	89 c7                	mov    %eax,%edi
            ASSERT_KV(kv);
c0106070:	83 c4 10             	add    $0x10,%esp
c0106073:	81 38 5d 11 00 00    	cmpl   $0x115d,(%eax)
c0106079:	74 2b                	je     c01060a6 <hashtable_assertvalid+0x12e>
c010607b:	83 ec 0c             	sub    $0xc,%esp
c010607e:	68 d0 be 10 c0       	push   $0xc010bed0
c0106083:	68 86 01 00 00       	push   $0x186
c0106088:	68 8b bd 10 c0       	push   $0xc010bd8b
c010608d:	68 7a be 10 c0       	push   $0xc010be7a
c0106092:	68 95 a9 10 c0       	push   $0xc010a995
c0106097:	e8 28 dd ff ff       	call   c0103dc4 <print>
c010609c:	83 c4 20             	add    $0x20,%esp
c010609f:	e8 a6 ad ff ff       	call   c0100e4a <backtrace>
c01060a4:	fa                   	cli    
c01060a5:	f4                   	hlt    
            assert(hash(kv->key, kv->keylen) % h->arraysize == i);
c01060a6:	8b 57 08             	mov    0x8(%edi),%edx
c01060a9:	8b 47 04             	mov    0x4(%edi),%eax
c01060ac:	e8 25 f5 ff ff       	call   c01055d6 <hash>
c01060b1:	31 d2                	xor    %edx,%edx
c01060b3:	f7 73 08             	divl   0x8(%ebx)
c01060b6:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
c01060b9:	74 2b                	je     c01060e6 <hashtable_assertvalid+0x16e>
c01060bb:	83 ec 0c             	sub    $0xc,%esp
c01060be:	68 d0 be 10 c0       	push   $0xc010bed0
c01060c3:	68 87 01 00 00       	push   $0x187
c01060c8:	68 8b bd 10 c0       	push   $0xc010bd8b
c01060cd:	68 91 be 10 c0       	push   $0xc010be91
c01060d2:	68 95 a9 10 c0       	push   $0xc010a995
c01060d7:	e8 e8 dc ff ff       	call   c0103dc4 <print>
c01060dc:	83 c4 20             	add    $0x20,%esp
c01060df:	e8 66 ad ff ff       	call   c0100e4a <backtrace>
c01060e4:	fa                   	cli    
c01060e5:	f4                   	hlt    
            list_pop_front(chain);
c01060e6:	83 ec 0c             	sub    $0xc,%esp
c01060e9:	56                   	push   %esi
c01060ea:	e8 1b e8 ff ff       	call   c010490a <list_pop_front>
            list_push_back(chain, kv);
c01060ef:	58                   	pop    %eax
c01060f0:	5a                   	pop    %edx
c01060f1:	57                   	push   %edi
c01060f2:	56                   	push   %esi
c01060f3:	e8 12 e7 ff ff       	call   c010480a <list_push_back>
        assert(chain != NULL);
        list_assertvalid(chain);
        size = list_getsize(chain);
        count += size;
        /* check if key hashes to the correct index */
        for (j = 0; j < size; ++j) {
c01060f8:	ff 45 dc             	incl   -0x24(%ebp)
c01060fb:	83 c4 10             	add    $0x10,%esp
c01060fe:	e9 56 ff ff ff       	jmp    c0106059 <hashtable_assertvalid+0xe1>
    /* Validate if the size of items in the hashtable is correct. */
    unsigned int count = 0;
    unsigned int i, j, size;
    struct list* chain;
    struct kv_pair* kv;
    for (i = 0; i < h->arraysize; ++i) {
c0106103:	ff 45 e4             	incl   -0x1c(%ebp)
c0106106:	e9 e9 fe ff ff       	jmp    c0105ff4 <hashtable_assertvalid+0x7c>
            assert(hash(kv->key, kv->keylen) % h->arraysize == i);
            list_pop_front(chain);
            list_push_back(chain, kv);
        }
    }
    assert(count == h->size);
c010610b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010610e:	3b 43 04             	cmp    0x4(%ebx),%eax
c0106111:	74 2b                	je     c010613e <hashtable_assertvalid+0x1c6>
c0106113:	83 ec 0c             	sub    $0xc,%esp
c0106116:	68 d0 be 10 c0       	push   $0xc010bed0
c010611b:	68 8c 01 00 00       	push   $0x18c
c0106120:	68 8b bd 10 c0       	push   $0xc010bd8b
c0106125:	68 bf be 10 c0       	push   $0xc010bebf
c010612a:	68 95 a9 10 c0       	push   $0xc010a995
c010612f:	e8 90 dc ff ff       	call   c0103dc4 <print>
c0106134:	83 c4 20             	add    $0x20,%esp
c0106137:	e8 0e ad ff ff       	call   c0100e4a <backtrace>
c010613c:	fa                   	cli    
c010613d:	f4                   	hlt    
}
c010613e:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106141:	5b                   	pop    %ebx
c0106142:	5e                   	pop    %esi
c0106143:	5f                   	pop    %edi
c0106144:	5d                   	pop    %ebp
c0106145:	c3                   	ret    

c0106146 <bitmap_ts_create>:
    struct bitmap* bm;
    struct lock* lk;
    struct cv* cv;
};

struct bitmap_ts* bitmap_ts_create(unsigned nbits) {
c0106146:	55                   	push   %ebp
c0106147:	89 e5                	mov    %esp,%ebp
c0106149:	56                   	push   %esi
c010614a:	53                   	push   %ebx
    struct bitmap_ts* b = (struct bitmap_ts*) kmalloc(sizeof(struct bitmap_ts));
c010614b:	83 ec 0c             	sub    $0xc,%esp
c010614e:	6a 0c                	push   $0xc
c0106150:	e8 50 b7 ff ff       	call   c01018a5 <kmalloc>
    if (b == NULL)
c0106155:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0106158:	31 db                	xor    %ebx,%ebx
    struct cv* cv;
};

struct bitmap_ts* bitmap_ts_create(unsigned nbits) {
    struct bitmap_ts* b = (struct bitmap_ts*) kmalloc(sizeof(struct bitmap_ts));
    if (b == NULL)
c010615a:	85 c0                	test   %eax,%eax
c010615c:	0f 84 83 00 00 00    	je     c01061e5 <bitmap_ts_create+0x9f>
c0106162:	89 c6                	mov    %eax,%esi
        return NULL;
    b->bm = bitmap_create(nbits);
c0106164:	83 ec 0c             	sub    $0xc,%esp
c0106167:	ff 75 08             	pushl  0x8(%ebp)
c010616a:	e8 c6 ed ff ff       	call   c0104f35 <bitmap_create>
c010616f:	89 06                	mov    %eax,(%esi)
    if (b->bm == NULL) {
c0106171:	83 c4 10             	add    $0x10,%esp
c0106174:	85 c0                	test   %eax,%eax
c0106176:	75 0e                	jne    c0106186 <bitmap_ts_create+0x40>
        kfree(b);
c0106178:	83 ec 0c             	sub    $0xc,%esp
c010617b:	56                   	push   %esi
c010617c:	e8 f0 b7 ff ff       	call   c0101971 <kfree>
        return NULL;
c0106181:	83 c4 10             	add    $0x10,%esp
c0106184:	eb 5f                	jmp    c01061e5 <bitmap_ts_create+0x9f>
    }
    b->lk = lock_create("bitmap_ts.lk");
c0106186:	83 ec 0c             	sub    $0xc,%esp
c0106189:	68 9a bf 10 c0       	push   $0xc010bf9a
c010618e:	e8 ec ca ff ff       	call   c0102c7f <lock_create>
c0106193:	89 46 04             	mov    %eax,0x4(%esi)
    if (b->lk == NULL) {
c0106196:	83 c4 10             	add    $0x10,%esp
c0106199:	85 c0                	test   %eax,%eax
c010619b:	75 0f                	jne    c01061ac <bitmap_ts_create+0x66>
        kfree(b->bm);
c010619d:	83 ec 0c             	sub    $0xc,%esp
c01061a0:	ff 36                	pushl  (%esi)
c01061a2:	e8 ca b7 ff ff       	call   c0101971 <kfree>
        kfree(b);
c01061a7:	89 34 24             	mov    %esi,(%esp)
c01061aa:	eb 2f                	jmp    c01061db <bitmap_ts_create+0x95>
        return NULL;
    }
    b->cv = cv_create("bitmap_ts.cv");
c01061ac:	83 ec 0c             	sub    $0xc,%esp
c01061af:	68 a7 bf 10 c0       	push   $0xc010bfa7
c01061b4:	e8 39 c9 ff ff       	call   c0102af2 <cv_create>
c01061b9:	89 46 08             	mov    %eax,0x8(%esi)
    if (b->cv == NULL) {
c01061bc:	83 c4 10             	add    $0x10,%esp
c01061bf:	89 f3                	mov    %esi,%ebx
c01061c1:	85 c0                	test   %eax,%eax
c01061c3:	75 20                	jne    c01061e5 <bitmap_ts_create+0x9f>
        kfree(b->lk);
c01061c5:	83 ec 0c             	sub    $0xc,%esp
c01061c8:	ff 76 04             	pushl  0x4(%esi)
c01061cb:	e8 a1 b7 ff ff       	call   c0101971 <kfree>
        kfree(b->bm);
c01061d0:	58                   	pop    %eax
c01061d1:	ff 36                	pushl  (%esi)
c01061d3:	e8 99 b7 ff ff       	call   c0101971 <kfree>
        kfree(b);
c01061d8:	89 34 24             	mov    %esi,(%esp)
c01061db:	e8 91 b7 ff ff       	call   c0101971 <kfree>
        return NULL;
c01061e0:	83 c4 10             	add    $0x10,%esp
c01061e3:	31 db                	xor    %ebx,%ebx
    }
    return b;
}
c01061e5:	89 d8                	mov    %ebx,%eax
c01061e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01061ea:	5b                   	pop    %ebx
c01061eb:	5e                   	pop    %esi
c01061ec:	5d                   	pop    %ebp
c01061ed:	c3                   	ret    

c01061ee <bitmap_ts_getdata>:

void* bitmap_ts_getdata(struct bitmap_ts* b) {
c01061ee:	55                   	push   %ebp
c01061ef:	89 e5                	mov    %esp,%ebp
c01061f1:	53                   	push   %ebx
c01061f2:	83 ec 14             	sub    $0x14,%esp
c01061f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(b != NULL);
c01061f8:	85 db                	test   %ebx,%ebx
c01061fa:	75 28                	jne    c0106224 <bitmap_ts_getdata+0x36>
c01061fc:	83 ec 0c             	sub    $0xc,%esp
c01061ff:	68 50 c0 10 c0       	push   $0xc010c050
c0106204:	6a 29                	push   $0x29
c0106206:	68 b4 bf 10 c0       	push   $0xc010bfb4
c010620b:	68 c4 bf 10 c0       	push   $0xc010bfc4
c0106210:	68 95 a9 10 c0       	push   $0xc010a995
c0106215:	e8 aa db ff ff       	call   c0103dc4 <print>
c010621a:	83 c4 20             	add    $0x20,%esp
c010621d:	e8 28 ac ff ff       	call   c0100e4a <backtrace>
c0106222:	fa                   	cli    
c0106223:	f4                   	hlt    

    lock_acquire(b->lk);
c0106224:	83 ec 0c             	sub    $0xc,%esp
c0106227:	ff 73 04             	pushl  0x4(%ebx)
c010622a:	e8 a0 cb ff ff       	call   c0102dcf <lock_acquire>
    void* ret = bitmap_getdata(b->bm);
c010622f:	58                   	pop    %eax
c0106230:	ff 33                	pushl  (%ebx)
c0106232:	e8 fc ed ff ff       	call   c0105033 <bitmap_getdata>
c0106237:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(b->lk);
c010623a:	5a                   	pop    %edx
c010623b:	ff 73 04             	pushl  0x4(%ebx)
c010623e:	e8 f4 cc ff ff       	call   c0102f37 <lock_release>
    return ret;
}
c0106243:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106249:	c9                   	leave  
c010624a:	c3                   	ret    

c010624b <bitmap_ts_alloc>:

int bitmap_ts_alloc(struct bitmap_ts* b, unsigned* index) {
c010624b:	55                   	push   %ebp
c010624c:	89 e5                	mov    %esp,%ebp
c010624e:	56                   	push   %esi
c010624f:	53                   	push   %ebx
c0106250:	83 ec 10             	sub    $0x10,%esp
c0106253:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0106256:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(b != NULL);
c0106259:	85 db                	test   %ebx,%ebx
c010625b:	75 28                	jne    c0106285 <bitmap_ts_alloc+0x3a>
c010625d:	83 ec 0c             	sub    $0xc,%esp
c0106260:	68 40 c0 10 c0       	push   $0xc010c040
c0106265:	6a 32                	push   $0x32
c0106267:	68 b4 bf 10 c0       	push   $0xc010bfb4
c010626c:	68 c4 bf 10 c0       	push   $0xc010bfc4
c0106271:	68 95 a9 10 c0       	push   $0xc010a995
c0106276:	e8 49 db ff ff       	call   c0103dc4 <print>
c010627b:	83 c4 20             	add    $0x20,%esp
c010627e:	e8 c7 ab ff ff       	call   c0100e4a <backtrace>
c0106283:	fa                   	cli    
c0106284:	f4                   	hlt    
    assert(index != NULL);
c0106285:	85 f6                	test   %esi,%esi
c0106287:	75 28                	jne    c01062b1 <bitmap_ts_alloc+0x66>
c0106289:	83 ec 0c             	sub    $0xc,%esp
c010628c:	68 40 c0 10 c0       	push   $0xc010c040
c0106291:	6a 33                	push   $0x33
c0106293:	68 b4 bf 10 c0       	push   $0xc010bfb4
c0106298:	68 ce bf 10 c0       	push   $0xc010bfce
c010629d:	68 95 a9 10 c0       	push   $0xc010a995
c01062a2:	e8 1d db ff ff       	call   c0103dc4 <print>
c01062a7:	83 c4 20             	add    $0x20,%esp
c01062aa:	e8 9b ab ff ff       	call   c0100e4a <backtrace>
c01062af:	fa                   	cli    
c01062b0:	f4                   	hlt    

    lock_acquire(b->lk);
c01062b1:	83 ec 0c             	sub    $0xc,%esp
c01062b4:	ff 73 04             	pushl  0x4(%ebx)
c01062b7:	e8 13 cb ff ff       	call   c0102dcf <lock_acquire>
    int ret = bitmap_alloc(b->bm, index);
c01062bc:	58                   	pop    %eax
c01062bd:	5a                   	pop    %edx
c01062be:	56                   	push   %esi
c01062bf:	ff 33                	pushl  (%ebx)
c01062c1:	e8 78 ed ff ff       	call   c010503e <bitmap_alloc>
c01062c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(b->lk);
c01062c9:	59                   	pop    %ecx
c01062ca:	ff 73 04             	pushl  0x4(%ebx)
c01062cd:	e8 65 cc ff ff       	call   c0102f37 <lock_release>
    // may return ENOMEM
    return ret;
}
c01062d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01062d8:	5b                   	pop    %ebx
c01062d9:	5e                   	pop    %esi
c01062da:	5d                   	pop    %ebp
c01062db:	c3                   	ret    

c01062dc <bitmap_ts_mark>:

void bitmap_ts_mark(struct bitmap_ts* b, unsigned index) {
c01062dc:	55                   	push   %ebp
c01062dd:	89 e5                	mov    %esp,%ebp
c01062df:	56                   	push   %esi
c01062e0:	53                   	push   %ebx
c01062e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01062e4:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(b != NULL);
c01062e7:	85 db                	test   %ebx,%ebx
c01062e9:	75 28                	jne    c0106313 <bitmap_ts_mark+0x37>
c01062eb:	83 ec 0c             	sub    $0xc,%esp
c01062ee:	68 30 c0 10 c0       	push   $0xc010c030
c01062f3:	6a 3d                	push   $0x3d
c01062f5:	68 b4 bf 10 c0       	push   $0xc010bfb4
c01062fa:	68 c4 bf 10 c0       	push   $0xc010bfc4
c01062ff:	68 95 a9 10 c0       	push   $0xc010a995
c0106304:	e8 bb da ff ff       	call   c0103dc4 <print>
c0106309:	83 c4 20             	add    $0x20,%esp
c010630c:	e8 39 ab ff ff       	call   c0100e4a <backtrace>
c0106311:	fa                   	cli    
c0106312:	f4                   	hlt    

    lock_acquire(b->lk);
c0106313:	83 ec 0c             	sub    $0xc,%esp
c0106316:	ff 73 04             	pushl  0x4(%ebx)
c0106319:	e8 b1 ca ff ff       	call   c0102dcf <lock_acquire>
    bitmap_mark(b->bm, index);
c010631e:	58                   	pop    %eax
c010631f:	5a                   	pop    %edx
c0106320:	56                   	push   %esi
c0106321:	ff 33                	pushl  (%ebx)
c0106323:	e8 c2 ed ff ff       	call   c01050ea <bitmap_mark>
    cv_signal(b->cv, b->lk);
c0106328:	59                   	pop    %ecx
c0106329:	5e                   	pop    %esi
c010632a:	ff 73 04             	pushl  0x4(%ebx)
c010632d:	ff 73 08             	pushl  0x8(%ebx)
c0106330:	e8 c0 c8 ff ff       	call   c0102bf5 <cv_signal>
    lock_release(b->lk);
c0106335:	83 c4 10             	add    $0x10,%esp
c0106338:	8b 43 04             	mov    0x4(%ebx),%eax
c010633b:	89 45 08             	mov    %eax,0x8(%ebp)
}
c010633e:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0106341:	5b                   	pop    %ebx
c0106342:	5e                   	pop    %esi
c0106343:	5d                   	pop    %ebp
    assert(b != NULL);

    lock_acquire(b->lk);
    bitmap_mark(b->bm, index);
    cv_signal(b->cv, b->lk);
    lock_release(b->lk);
c0106344:	e9 ee cb ff ff       	jmp    c0102f37 <lock_release>

c0106349 <bitmap_ts_unmark>:
}

void bitmap_ts_unmark(struct bitmap_ts* b, unsigned index) {
c0106349:	55                   	push   %ebp
c010634a:	89 e5                	mov    %esp,%ebp
c010634c:	56                   	push   %esi
c010634d:	53                   	push   %ebx
c010634e:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0106351:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(b != NULL);
c0106354:	85 db                	test   %ebx,%ebx
c0106356:	75 28                	jne    c0106380 <bitmap_ts_unmark+0x37>
c0106358:	83 ec 0c             	sub    $0xc,%esp
c010635b:	68 1c c0 10 c0       	push   $0xc010c01c
c0106360:	6a 46                	push   $0x46
c0106362:	68 b4 bf 10 c0       	push   $0xc010bfb4
c0106367:	68 c4 bf 10 c0       	push   $0xc010bfc4
c010636c:	68 95 a9 10 c0       	push   $0xc010a995
c0106371:	e8 4e da ff ff       	call   c0103dc4 <print>
c0106376:	83 c4 20             	add    $0x20,%esp
c0106379:	e8 cc aa ff ff       	call   c0100e4a <backtrace>
c010637e:	fa                   	cli    
c010637f:	f4                   	hlt    

    lock_acquire(b->lk);
c0106380:	83 ec 0c             	sub    $0xc,%esp
c0106383:	ff 73 04             	pushl  0x4(%ebx)
c0106386:	e8 44 ca ff ff       	call   c0102dcf <lock_acquire>
    bitmap_unmark(b->bm, index);
c010638b:	58                   	pop    %eax
c010638c:	5a                   	pop    %edx
c010638d:	56                   	push   %esi
c010638e:	ff 33                	pushl  (%ebx)
c0106390:	e8 e4 ed ff ff       	call   c0105179 <bitmap_unmark>
    lock_release(b->lk);
c0106395:	83 c4 10             	add    $0x10,%esp
c0106398:	8b 43 04             	mov    0x4(%ebx),%eax
c010639b:	89 45 08             	mov    %eax,0x8(%ebp)
}
c010639e:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01063a1:	5b                   	pop    %ebx
c01063a2:	5e                   	pop    %esi
c01063a3:	5d                   	pop    %ebp
void bitmap_ts_unmark(struct bitmap_ts* b, unsigned index) {
    assert(b != NULL);

    lock_acquire(b->lk);
    bitmap_unmark(b->bm, index);
    lock_release(b->lk);
c01063a4:	e9 8e cb ff ff       	jmp    c0102f37 <lock_release>

c01063a9 <bitmap_ts_isset>:
}

int bitmap_ts_isset(struct bitmap_ts* b, unsigned index) {
c01063a9:	55                   	push   %ebp
c01063aa:	89 e5                	mov    %esp,%ebp
c01063ac:	53                   	push   %ebx
c01063ad:	83 ec 14             	sub    $0x14,%esp
c01063b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(b != NULL);
c01063b3:	85 db                	test   %ebx,%ebx
c01063b5:	75 28                	jne    c01063df <bitmap_ts_isset+0x36>
c01063b7:	83 ec 0c             	sub    $0xc,%esp
c01063ba:	68 0c c0 10 c0       	push   $0xc010c00c
c01063bf:	6a 4e                	push   $0x4e
c01063c1:	68 b4 bf 10 c0       	push   $0xc010bfb4
c01063c6:	68 c4 bf 10 c0       	push   $0xc010bfc4
c01063cb:	68 95 a9 10 c0       	push   $0xc010a995
c01063d0:	e8 ef d9 ff ff       	call   c0103dc4 <print>
c01063d5:	83 c4 20             	add    $0x20,%esp
c01063d8:	e8 6d aa ff ff       	call   c0100e4a <backtrace>
c01063dd:	fa                   	cli    
c01063de:	f4                   	hlt    

    lock_acquire(b->lk);
c01063df:	83 ec 0c             	sub    $0xc,%esp
c01063e2:	ff 73 04             	pushl  0x4(%ebx)
c01063e5:	e8 e5 c9 ff ff       	call   c0102dcf <lock_acquire>
    int ret = bitmap_isset(b->bm, index);
c01063ea:	58                   	pop    %eax
c01063eb:	5a                   	pop    %edx
c01063ec:	ff 75 0c             	pushl  0xc(%ebp)
c01063ef:	ff 33                	pushl  (%ebx)
c01063f1:	e8 0e ee ff ff       	call   c0105204 <bitmap_isset>
c01063f6:	88 45 f7             	mov    %al,-0x9(%ebp)
    lock_release(b->lk);
c01063f9:	59                   	pop    %ecx
c01063fa:	ff 73 04             	pushl  0x4(%ebx)
c01063fd:	e8 35 cb ff ff       	call   c0102f37 <lock_release>
    return ret;
c0106402:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
c0106406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106409:	c9                   	leave  
c010640a:	c3                   	ret    

c010640b <bitmap_ts_isset_blocking>:

int bitmap_ts_isset_blocking(struct bitmap_ts* b, unsigned index) {
c010640b:	55                   	push   %ebp
c010640c:	89 e5                	mov    %esp,%ebp
c010640e:	53                   	push   %ebx
c010640f:	51                   	push   %ecx
c0106410:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(b != NULL);
c0106413:	85 db                	test   %ebx,%ebx
c0106415:	75 28                	jne    c010643f <bitmap_ts_isset_blocking+0x34>
c0106417:	83 ec 0c             	sub    $0xc,%esp
c010641a:	68 f0 bf 10 c0       	push   $0xc010bff0
c010641f:	6a 57                	push   $0x57
c0106421:	68 b4 bf 10 c0       	push   $0xc010bfb4
c0106426:	68 c4 bf 10 c0       	push   $0xc010bfc4
c010642b:	68 95 a9 10 c0       	push   $0xc010a995
c0106430:	e8 8f d9 ff ff       	call   c0103dc4 <print>
c0106435:	83 c4 20             	add    $0x20,%esp
c0106438:	e8 0d aa ff ff       	call   c0100e4a <backtrace>
c010643d:	fa                   	cli    
c010643e:	f4                   	hlt    

    lock_acquire(b->lk);
c010643f:	83 ec 0c             	sub    $0xc,%esp
c0106442:	ff 73 04             	pushl  0x4(%ebx)
c0106445:	e8 85 c9 ff ff       	call   c0102dcf <lock_acquire>
    while (bitmap_isset(b->bm, index) == 1)
        cv_wait(b->cv, b->lk);
c010644a:	83 c4 10             	add    $0x10,%esp

int bitmap_ts_isset_blocking(struct bitmap_ts* b, unsigned index) {
    assert(b != NULL);

    lock_acquire(b->lk);
    while (bitmap_isset(b->bm, index) == 1)
c010644d:	50                   	push   %eax
c010644e:	50                   	push   %eax
c010644f:	ff 75 0c             	pushl  0xc(%ebp)
c0106452:	ff 33                	pushl  (%ebx)
c0106454:	e8 ab ed ff ff       	call   c0105204 <bitmap_isset>
c0106459:	83 c4 10             	add    $0x10,%esp
c010645c:	84 c0                	test   %al,%al
c010645e:	74 0f                	je     c010646f <bitmap_ts_isset_blocking+0x64>
        cv_wait(b->cv, b->lk);
c0106460:	52                   	push   %edx
c0106461:	52                   	push   %edx
c0106462:	ff 73 04             	pushl  0x4(%ebx)
c0106465:	ff 73 08             	pushl  0x8(%ebx)
c0106468:	e8 43 c7 ff ff       	call   c0102bb0 <cv_wait>
c010646d:	eb db                	jmp    c010644a <bitmap_ts_isset_blocking+0x3f>
    lock_release(b->lk);
c010646f:	83 ec 0c             	sub    $0xc,%esp
c0106472:	ff 73 04             	pushl  0x4(%ebx)
c0106475:	e8 bd ca ff ff       	call   c0102f37 <lock_release>
    return 0;
}
c010647a:	31 c0                	xor    %eax,%eax
c010647c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010647f:	c9                   	leave  
c0106480:	c3                   	ret    

c0106481 <bitmap_ts_destroy>:

void bitmap_ts_destroy(struct bitmap_ts* b) {
c0106481:	55                   	push   %ebp
c0106482:	89 e5                	mov    %esp,%ebp
c0106484:	53                   	push   %ebx
c0106485:	50                   	push   %eax
c0106486:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(b != NULL);
c0106489:	85 db                	test   %ebx,%ebx
c010648b:	75 28                	jne    c01064b5 <bitmap_ts_destroy+0x34>
c010648d:	83 ec 0c             	sub    $0xc,%esp
c0106490:	68 dc bf 10 c0       	push   $0xc010bfdc
c0106495:	6a 61                	push   $0x61
c0106497:	68 b4 bf 10 c0       	push   $0xc010bfb4
c010649c:	68 c4 bf 10 c0       	push   $0xc010bfc4
c01064a1:	68 95 a9 10 c0       	push   $0xc010a995
c01064a6:	e8 19 d9 ff ff       	call   c0103dc4 <print>
c01064ab:	83 c4 20             	add    $0x20,%esp
c01064ae:	e8 97 a9 ff ff       	call   c0100e4a <backtrace>
c01064b3:	fa                   	cli    
c01064b4:	f4                   	hlt    

    lock_acquire(b->lk);
c01064b5:	83 ec 0c             	sub    $0xc,%esp
c01064b8:	ff 73 04             	pushl  0x4(%ebx)
c01064bb:	e8 0f c9 ff ff       	call   c0102dcf <lock_acquire>
    bitmap_destroy(b->bm);
c01064c0:	58                   	pop    %eax
c01064c1:	ff 33                	pushl  (%ebx)
c01064c3:	e8 94 ed ff ff       	call   c010525c <bitmap_destroy>
    cv_destroy(b->cv);
c01064c8:	5a                   	pop    %edx
c01064c9:	ff 73 08             	pushl  0x8(%ebx)
c01064cc:	e8 7f c6 ff ff       	call   c0102b50 <cv_destroy>
    lock_release(b->lk);
c01064d1:	59                   	pop    %ecx
c01064d2:	ff 73 04             	pushl  0x4(%ebx)
c01064d5:	e8 5d ca ff ff       	call   c0102f37 <lock_release>
    lock_destroy(b->lk);
c01064da:	58                   	pop    %eax
c01064db:	ff 73 04             	pushl  0x4(%ebx)
c01064de:	e8 1f c8 ff ff       	call   c0102d02 <lock_destroy>
    kfree(b);
c01064e3:	83 c4 10             	add    $0x10,%esp
c01064e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c01064e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01064ec:	c9                   	leave  
    lock_acquire(b->lk);
    bitmap_destroy(b->bm);
    cv_destroy(b->cv);
    lock_release(b->lk);
    lock_destroy(b->lk);
    kfree(b);
c01064ed:	e9 7f b4 ff ff       	jmp    c0101971 <kfree>

c01064f2 <queue_ts_create>:
    struct queue* qu;
    struct lock* lk;
    struct cv* cv;
};

struct queue_ts* queue_ts_create(void) {
c01064f2:	55                   	push   %ebp
c01064f3:	89 e5                	mov    %esp,%ebp
c01064f5:	56                   	push   %esi
c01064f6:	53                   	push   %ebx
    struct queue_ts* q = (struct queue_ts*) kmalloc(sizeof(struct queue_ts));
c01064f7:	83 ec 0c             	sub    $0xc,%esp
c01064fa:	6a 0c                	push   $0xc
c01064fc:	e8 a4 b3 ff ff       	call   c01018a5 <kmalloc>
    if (q == NULL)
c0106501:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0106504:	31 db                	xor    %ebx,%ebx
    struct cv* cv;
};

struct queue_ts* queue_ts_create(void) {
    struct queue_ts* q = (struct queue_ts*) kmalloc(sizeof(struct queue_ts));
    if (q == NULL)
c0106506:	85 c0                	test   %eax,%eax
c0106508:	74 7a                	je     c0106584 <queue_ts_create+0x92>
c010650a:	89 c6                	mov    %eax,%esi
        return NULL;
    q->qu = queue_create();
c010650c:	e8 73 ed ff ff       	call   c0105284 <queue_create>
c0106511:	89 06                	mov    %eax,(%esi)
    if (q->qu == NULL) {
c0106513:	85 c0                	test   %eax,%eax
c0106515:	75 0e                	jne    c0106525 <queue_ts_create+0x33>
        kfree(q);
c0106517:	83 ec 0c             	sub    $0xc,%esp
c010651a:	56                   	push   %esi
c010651b:	e8 51 b4 ff ff       	call   c0101971 <kfree>
        return NULL;
c0106520:	83 c4 10             	add    $0x10,%esp
c0106523:	eb 5f                	jmp    c0106584 <queue_ts_create+0x92>
    }
    q->lk = lock_create("queue_ts.lk");
c0106525:	83 ec 0c             	sub    $0xc,%esp
c0106528:	68 62 c0 10 c0       	push   $0xc010c062
c010652d:	e8 4d c7 ff ff       	call   c0102c7f <lock_create>
c0106532:	89 46 04             	mov    %eax,0x4(%esi)
    if (q->lk == NULL) {
c0106535:	83 c4 10             	add    $0x10,%esp
c0106538:	85 c0                	test   %eax,%eax
c010653a:	75 0f                	jne    c010654b <queue_ts_create+0x59>
        kfree(q->qu);
c010653c:	83 ec 0c             	sub    $0xc,%esp
c010653f:	ff 36                	pushl  (%esi)
c0106541:	e8 2b b4 ff ff       	call   c0101971 <kfree>
        kfree(q);
c0106546:	89 34 24             	mov    %esi,(%esp)
c0106549:	eb 2f                	jmp    c010657a <queue_ts_create+0x88>
        return NULL;
    }
    q->cv = cv_create("queue_ts.cv");
c010654b:	83 ec 0c             	sub    $0xc,%esp
c010654e:	68 6e c0 10 c0       	push   $0xc010c06e
c0106553:	e8 9a c5 ff ff       	call   c0102af2 <cv_create>
c0106558:	89 46 08             	mov    %eax,0x8(%esi)
    if (q->cv == NULL) {
c010655b:	83 c4 10             	add    $0x10,%esp
c010655e:	89 f3                	mov    %esi,%ebx
c0106560:	85 c0                	test   %eax,%eax
c0106562:	75 20                	jne    c0106584 <queue_ts_create+0x92>
        kfree(q->lk);
c0106564:	83 ec 0c             	sub    $0xc,%esp
c0106567:	ff 76 04             	pushl  0x4(%esi)
c010656a:	e8 02 b4 ff ff       	call   c0101971 <kfree>
        kfree(q->qu);
c010656f:	58                   	pop    %eax
c0106570:	ff 36                	pushl  (%esi)
c0106572:	e8 fa b3 ff ff       	call   c0101971 <kfree>
        kfree(q);
c0106577:	89 34 24             	mov    %esi,(%esp)
c010657a:	e8 f2 b3 ff ff       	call   c0101971 <kfree>
        return NULL;
c010657f:	83 c4 10             	add    $0x10,%esp
c0106582:	31 db                	xor    %ebx,%ebx
    }
    return q;
}
c0106584:	89 d8                	mov    %ebx,%eax
c0106586:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0106589:	5b                   	pop    %ebx
c010658a:	5e                   	pop    %esi
c010658b:	5d                   	pop    %ebp
c010658c:	c3                   	ret    

c010658d <queue_ts_push>:

int queue_ts_push(struct queue_ts* q, void* newval) {
c010658d:	55                   	push   %ebp
c010658e:	89 e5                	mov    %esp,%ebp
c0106590:	53                   	push   %ebx
c0106591:	83 ec 14             	sub    $0x14,%esp
c0106594:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c0106597:	85 db                	test   %ebx,%ebx
c0106599:	75 28                	jne    c01065c3 <queue_ts_push+0x36>
c010659b:	83 ec 0c             	sub    $0xc,%esp
c010659e:	68 08 c1 10 c0       	push   $0xc010c108
c01065a3:	6a 29                	push   $0x29
c01065a5:	68 7a c0 10 c0       	push   $0xc010c07a
c01065aa:	68 fe bc 10 c0       	push   $0xc010bcfe
c01065af:	68 95 a9 10 c0       	push   $0xc010a995
c01065b4:	e8 0b d8 ff ff       	call   c0103dc4 <print>
c01065b9:	83 c4 20             	add    $0x20,%esp
c01065bc:	e8 89 a8 ff ff       	call   c0100e4a <backtrace>
c01065c1:	fa                   	cli    
c01065c2:	f4                   	hlt    

    int ret;
    lock_acquire(q->lk);
c01065c3:	83 ec 0c             	sub    $0xc,%esp
c01065c6:	ff 73 04             	pushl  0x4(%ebx)
c01065c9:	e8 01 c8 ff ff       	call   c0102dcf <lock_acquire>
    ret = queue_push(q->qu, newval);
c01065ce:	58                   	pop    %eax
c01065cf:	5a                   	pop    %edx
c01065d0:	ff 75 0c             	pushl  0xc(%ebp)
c01065d3:	ff 33                	pushl  (%ebx)
c01065d5:	e8 ec ec ff ff       	call   c01052c6 <queue_push>
c01065da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cv_signal(q->cv, q->lk);
c01065dd:	59                   	pop    %ecx
c01065de:	58                   	pop    %eax
c01065df:	ff 73 04             	pushl  0x4(%ebx)
c01065e2:	ff 73 08             	pushl  0x8(%ebx)
c01065e5:	e8 0b c6 ff ff       	call   c0102bf5 <cv_signal>
    lock_release(q->lk);
c01065ea:	58                   	pop    %eax
c01065eb:	ff 73 04             	pushl  0x4(%ebx)
c01065ee:	e8 44 c9 ff ff       	call   c0102f37 <lock_release>
    return ret;
}
c01065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01065f9:	c9                   	leave  
c01065fa:	c3                   	ret    

c01065fb <queue_ts_pop>:

void* queue_ts_pop(struct queue_ts* q) {
c01065fb:	55                   	push   %ebp
c01065fc:	89 e5                	mov    %esp,%ebp
c01065fe:	56                   	push   %esi
c01065ff:	53                   	push   %ebx
c0106600:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c0106603:	85 db                	test   %ebx,%ebx
c0106605:	75 28                	jne    c010662f <queue_ts_pop+0x34>
c0106607:	83 ec 0c             	sub    $0xc,%esp
c010660a:	68 f8 c0 10 c0       	push   $0xc010c0f8
c010660f:	6a 34                	push   $0x34
c0106611:	68 7a c0 10 c0       	push   $0xc010c07a
c0106616:	68 fe bc 10 c0       	push   $0xc010bcfe
c010661b:	68 95 a9 10 c0       	push   $0xc010a995
c0106620:	e8 9f d7 ff ff       	call   c0103dc4 <print>
c0106625:	83 c4 20             	add    $0x20,%esp
c0106628:	e8 1d a8 ff ff       	call   c0100e4a <backtrace>
c010662d:	fa                   	cli    
c010662e:	f4                   	hlt    

    void* ret = NULL;
    lock_acquire(q->lk);
c010662f:	83 ec 0c             	sub    $0xc,%esp
c0106632:	ff 73 04             	pushl  0x4(%ebx)
c0106635:	e8 95 c7 ff ff       	call   c0102dcf <lock_acquire>
    if (!queue_isempty(q->qu)) {
c010663a:	5a                   	pop    %edx
c010663b:	ff 33                	pushl  (%ebx)
c010663d:	e8 e5 ed ff ff       	call   c0105427 <queue_isempty>
c0106642:	83 c4 10             	add    $0x10,%esp
}

void* queue_ts_pop(struct queue_ts* q) {
    assert(q != NULL);

    void* ret = NULL;
c0106645:	31 f6                	xor    %esi,%esi
    lock_acquire(q->lk);
    if (!queue_isempty(q->qu)) {
c0106647:	85 c0                	test   %eax,%eax
c0106649:	75 17                	jne    c0106662 <queue_ts_pop+0x67>
        ret = queue_front(q->qu);
c010664b:	83 ec 0c             	sub    $0xc,%esp
c010664e:	ff 33                	pushl  (%ebx)
c0106650:	e8 5f ed ff ff       	call   c01053b4 <queue_front>
c0106655:	89 c6                	mov    %eax,%esi
        queue_pop(q->qu);
c0106657:	58                   	pop    %eax
c0106658:	ff 33                	pushl  (%ebx)
c010665a:	e8 e2 ec ff ff       	call   c0105341 <queue_pop>
c010665f:	83 c4 10             	add    $0x10,%esp
    }
    lock_release(q->lk);
c0106662:	83 ec 0c             	sub    $0xc,%esp
c0106665:	ff 73 04             	pushl  0x4(%ebx)
c0106668:	e8 ca c8 ff ff       	call   c0102f37 <lock_release>
    return ret;
}
c010666d:	89 f0                	mov    %esi,%eax
c010666f:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0106672:	5b                   	pop    %ebx
c0106673:	5e                   	pop    %esi
c0106674:	5d                   	pop    %ebp
c0106675:	c3                   	ret    

c0106676 <queue_ts_pop_blocking>:

void* queue_ts_pop_blocking(struct queue_ts* q) {
c0106676:	55                   	push   %ebp
c0106677:	89 e5                	mov    %esp,%ebp
c0106679:	56                   	push   %esi
c010667a:	53                   	push   %ebx
c010667b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c010667e:	85 db                	test   %ebx,%ebx
c0106680:	75 28                	jne    c01066aa <queue_ts_pop_blocking+0x34>
c0106682:	83 ec 0c             	sub    $0xc,%esp
c0106685:	68 e0 c0 10 c0       	push   $0xc010c0e0
c010668a:	6a 41                	push   $0x41
c010668c:	68 7a c0 10 c0       	push   $0xc010c07a
c0106691:	68 fe bc 10 c0       	push   $0xc010bcfe
c0106696:	68 95 a9 10 c0       	push   $0xc010a995
c010669b:	e8 24 d7 ff ff       	call   c0103dc4 <print>
c01066a0:	83 c4 20             	add    $0x20,%esp
c01066a3:	e8 a2 a7 ff ff       	call   c0100e4a <backtrace>
c01066a8:	fa                   	cli    
c01066a9:	f4                   	hlt    

    void* ret = NULL;
    lock_acquire(q->lk);
c01066aa:	83 ec 0c             	sub    $0xc,%esp
c01066ad:	ff 73 04             	pushl  0x4(%ebx)
c01066b0:	e8 1a c7 ff ff       	call   c0102dcf <lock_acquire>
    while (queue_isempty(q->qu))
        cv_wait(q->cv, q->lk);
c01066b5:	83 c4 10             	add    $0x10,%esp
void* queue_ts_pop_blocking(struct queue_ts* q) {
    assert(q != NULL);

    void* ret = NULL;
    lock_acquire(q->lk);
    while (queue_isempty(q->qu))
c01066b8:	83 ec 0c             	sub    $0xc,%esp
c01066bb:	ff 33                	pushl  (%ebx)
c01066bd:	e8 65 ed ff ff       	call   c0105427 <queue_isempty>
c01066c2:	83 c4 10             	add    $0x10,%esp
c01066c5:	85 c0                	test   %eax,%eax
c01066c7:	74 0f                	je     c01066d8 <queue_ts_pop_blocking+0x62>
        cv_wait(q->cv, q->lk);
c01066c9:	50                   	push   %eax
c01066ca:	50                   	push   %eax
c01066cb:	ff 73 04             	pushl  0x4(%ebx)
c01066ce:	ff 73 08             	pushl  0x8(%ebx)
c01066d1:	e8 da c4 ff ff       	call   c0102bb0 <cv_wait>
c01066d6:	eb dd                	jmp    c01066b5 <queue_ts_pop_blocking+0x3f>
    ret = queue_front(q->qu);
c01066d8:	83 ec 0c             	sub    $0xc,%esp
c01066db:	ff 33                	pushl  (%ebx)
c01066dd:	e8 d2 ec ff ff       	call   c01053b4 <queue_front>
c01066e2:	89 c6                	mov    %eax,%esi
    if (ret != NULL)
c01066e4:	83 c4 10             	add    $0x10,%esp
c01066e7:	85 c0                	test   %eax,%eax
c01066e9:	74 0d                	je     c01066f8 <queue_ts_pop_blocking+0x82>
        queue_pop(q->qu);
c01066eb:	83 ec 0c             	sub    $0xc,%esp
c01066ee:	ff 33                	pushl  (%ebx)
c01066f0:	e8 4c ec ff ff       	call   c0105341 <queue_pop>
c01066f5:	83 c4 10             	add    $0x10,%esp
    lock_release(q->lk);
c01066f8:	83 ec 0c             	sub    $0xc,%esp
c01066fb:	ff 73 04             	pushl  0x4(%ebx)
c01066fe:	e8 34 c8 ff ff       	call   c0102f37 <lock_release>
    return ret;
}
c0106703:	89 f0                	mov    %esi,%eax
c0106705:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0106708:	5b                   	pop    %ebx
c0106709:	5e                   	pop    %esi
c010670a:	5d                   	pop    %ebp
c010670b:	c3                   	ret    

c010670c <queue_ts_isempty>:

int queue_ts_isempty(struct queue_ts* q) {
c010670c:	55                   	push   %ebp
c010670d:	89 e5                	mov    %esp,%ebp
c010670f:	53                   	push   %ebx
c0106710:	83 ec 14             	sub    $0x14,%esp
c0106713:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c0106716:	85 db                	test   %ebx,%ebx
c0106718:	75 28                	jne    c0106742 <queue_ts_isempty+0x36>
c010671a:	83 ec 0c             	sub    $0xc,%esp
c010671d:	68 cc c0 10 c0       	push   $0xc010c0cc
c0106722:	6a 4f                	push   $0x4f
c0106724:	68 7a c0 10 c0       	push   $0xc010c07a
c0106729:	68 fe bc 10 c0       	push   $0xc010bcfe
c010672e:	68 95 a9 10 c0       	push   $0xc010a995
c0106733:	e8 8c d6 ff ff       	call   c0103dc4 <print>
c0106738:	83 c4 20             	add    $0x20,%esp
c010673b:	e8 0a a7 ff ff       	call   c0100e4a <backtrace>
c0106740:	fa                   	cli    
c0106741:	f4                   	hlt    

    int ret;
    lock_acquire(q->lk);
c0106742:	83 ec 0c             	sub    $0xc,%esp
c0106745:	ff 73 04             	pushl  0x4(%ebx)
c0106748:	e8 82 c6 ff ff       	call   c0102dcf <lock_acquire>
    ret = queue_isempty(q->qu);
c010674d:	58                   	pop    %eax
c010674e:	ff 33                	pushl  (%ebx)
c0106750:	e8 d2 ec ff ff       	call   c0105427 <queue_isempty>
c0106755:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(q->lk);
c0106758:	5a                   	pop    %edx
c0106759:	ff 73 04             	pushl  0x4(%ebx)
c010675c:	e8 d6 c7 ff ff       	call   c0102f37 <lock_release>
    return ret;
}
c0106761:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106767:	c9                   	leave  
c0106768:	c3                   	ret    

c0106769 <queue_ts_getsize>:

unsigned queue_ts_getsize(struct queue_ts* q) {
c0106769:	55                   	push   %ebp
c010676a:	89 e5                	mov    %esp,%ebp
c010676c:	53                   	push   %ebx
c010676d:	83 ec 14             	sub    $0x14,%esp
c0106770:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c0106773:	85 db                	test   %ebx,%ebx
c0106775:	75 28                	jne    c010679f <queue_ts_getsize+0x36>
c0106777:	83 ec 0c             	sub    $0xc,%esp
c010677a:	68 b8 c0 10 c0       	push   $0xc010c0b8
c010677f:	6a 59                	push   $0x59
c0106781:	68 7a c0 10 c0       	push   $0xc010c07a
c0106786:	68 fe bc 10 c0       	push   $0xc010bcfe
c010678b:	68 95 a9 10 c0       	push   $0xc010a995
c0106790:	e8 2f d6 ff ff       	call   c0103dc4 <print>
c0106795:	83 c4 20             	add    $0x20,%esp
c0106798:	e8 ad a6 ff ff       	call   c0100e4a <backtrace>
c010679d:	fa                   	cli    
c010679e:	f4                   	hlt    

    int ret;
    lock_acquire(q->lk);
c010679f:	83 ec 0c             	sub    $0xc,%esp
c01067a2:	ff 73 04             	pushl  0x4(%ebx)
c01067a5:	e8 25 c6 ff ff       	call   c0102dcf <lock_acquire>
    ret = queue_getsize(q->qu);
c01067aa:	58                   	pop    %eax
c01067ab:	ff 33                	pushl  (%ebx)
c01067ad:	e8 e8 ec ff ff       	call   c010549a <queue_getsize>
c01067b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(q->lk);
c01067b5:	5a                   	pop    %edx
c01067b6:	ff 73 04             	pushl  0x4(%ebx)
c01067b9:	e8 79 c7 ff ff       	call   c0102f37 <lock_release>
    return ret;
}
c01067be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01067c4:	c9                   	leave  
c01067c5:	c3                   	ret    

c01067c6 <queue_ts_destroy>:

void queue_ts_destroy(struct queue_ts* q) {
c01067c6:	55                   	push   %ebp
c01067c7:	89 e5                	mov    %esp,%ebp
c01067c9:	53                   	push   %ebx
c01067ca:	50                   	push   %eax
c01067cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c01067ce:	85 db                	test   %ebx,%ebx
c01067d0:	75 28                	jne    c01067fa <queue_ts_destroy+0x34>
c01067d2:	83 ec 0c             	sub    $0xc,%esp
c01067d5:	68 a4 c0 10 c0       	push   $0xc010c0a4
c01067da:	6a 63                	push   $0x63
c01067dc:	68 7a c0 10 c0       	push   $0xc010c07a
c01067e1:	68 fe bc 10 c0       	push   $0xc010bcfe
c01067e6:	68 95 a9 10 c0       	push   $0xc010a995
c01067eb:	e8 d4 d5 ff ff       	call   c0103dc4 <print>
c01067f0:	83 c4 20             	add    $0x20,%esp
c01067f3:	e8 52 a6 ff ff       	call   c0100e4a <backtrace>
c01067f8:	fa                   	cli    
c01067f9:	f4                   	hlt    

    lock_acquire(q->lk);
c01067fa:	83 ec 0c             	sub    $0xc,%esp
c01067fd:	ff 73 04             	pushl  0x4(%ebx)
c0106800:	e8 ca c5 ff ff       	call   c0102dcf <lock_acquire>
    queue_destroy(q->qu);
c0106805:	58                   	pop    %eax
c0106806:	ff 33                	pushl  (%ebx)
c0106808:	e8 00 ed ff ff       	call   c010550d <queue_destroy>
    cv_destroy(q->cv);
c010680d:	5a                   	pop    %edx
c010680e:	ff 73 08             	pushl  0x8(%ebx)
c0106811:	e8 3a c3 ff ff       	call   c0102b50 <cv_destroy>
    lock_release(q->lk);
c0106816:	59                   	pop    %ecx
c0106817:	ff 73 04             	pushl  0x4(%ebx)
c010681a:	e8 18 c7 ff ff       	call   c0102f37 <lock_release>
    lock_destroy(q->lk);
c010681f:	58                   	pop    %eax
c0106820:	ff 73 04             	pushl  0x4(%ebx)
c0106823:	e8 da c4 ff ff       	call   c0102d02 <lock_destroy>
    kfree(q);
c0106828:	83 c4 10             	add    $0x10,%esp
c010682b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c010682e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106831:	c9                   	leave  
    lock_acquire(q->lk);
    queue_destroy(q->qu);
    cv_destroy(q->cv);
    lock_release(q->lk);
    lock_destroy(q->lk);
    kfree(q);
c0106832:	e9 3a b1 ff ff       	jmp    c0101971 <kfree>

c0106837 <queue_ts_assertvalid>:
}

void
queue_ts_assertvalid(struct queue_ts* q) {
c0106837:	55                   	push   %ebp
c0106838:	89 e5                	mov    %esp,%ebp
c010683a:	53                   	push   %ebx
c010683b:	52                   	push   %edx
c010683c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(q != NULL);
c010683f:	85 db                	test   %ebx,%ebx
c0106841:	75 28                	jne    c010686b <queue_ts_assertvalid+0x34>
c0106843:	83 ec 0c             	sub    $0xc,%esp
c0106846:	68 8c c0 10 c0       	push   $0xc010c08c
c010684b:	6a 6f                	push   $0x6f
c010684d:	68 7a c0 10 c0       	push   $0xc010c07a
c0106852:	68 fe bc 10 c0       	push   $0xc010bcfe
c0106857:	68 95 a9 10 c0       	push   $0xc010a995
c010685c:	e8 63 d5 ff ff       	call   c0103dc4 <print>
c0106861:	83 c4 20             	add    $0x20,%esp
c0106864:	e8 e1 a5 ff ff       	call   c0100e4a <backtrace>
c0106869:	fa                   	cli    
c010686a:	f4                   	hlt    

    lock_acquire(q->lk);
c010686b:	83 ec 0c             	sub    $0xc,%esp
c010686e:	ff 73 04             	pushl  0x4(%ebx)
c0106871:	e8 59 c5 ff ff       	call   c0102dcf <lock_acquire>
    queue_assertvalid(q->qu);
c0106876:	58                   	pop    %eax
c0106877:	ff 33                	pushl  (%ebx)
c0106879:	e8 e5 ec ff ff       	call   c0105563 <queue_assertvalid>
    lock_release(q->lk);
c010687e:	83 c4 10             	add    $0x10,%esp
c0106881:	8b 43 04             	mov    0x4(%ebx),%eax
c0106884:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0106887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010688a:	c9                   	leave  
queue_ts_assertvalid(struct queue_ts* q) {
    assert(q != NULL);

    lock_acquire(q->lk);
    queue_assertvalid(q->qu);
    lock_release(q->lk);
c010688b:	e9 a7 c6 ff ff       	jmp    c0102f37 <lock_release>

c0106890 <hashtable_ts_create>:
struct hashtable_ts {
    struct hashtable* ht;
    struct lock* lock;
};

struct hashtable_ts* hashtable_ts_create() {
c0106890:	55                   	push   %ebp
c0106891:	89 e5                	mov    %esp,%ebp
c0106893:	56                   	push   %esi
c0106894:	53                   	push   %ebx

    struct hashtable_ts* ht;
    ht = kmalloc(sizeof(struct hashtable_ts));
c0106895:	83 ec 0c             	sub    $0xc,%esp
c0106898:	6a 08                	push   $0x8
c010689a:	e8 06 b0 ff ff       	call   c01018a5 <kmalloc>

    if(ht == NULL)
c010689f:	83 c4 10             	add    $0x10,%esp
        return NULL;
c01068a2:	31 db                	xor    %ebx,%ebx
struct hashtable_ts* hashtable_ts_create() {

    struct hashtable_ts* ht;
    ht = kmalloc(sizeof(struct hashtable_ts));

    if(ht == NULL)
c01068a4:	85 c0                	test   %eax,%eax
c01068a6:	74 4b                	je     c01068f3 <hashtable_ts_create+0x63>
c01068a8:	89 c6                	mov    %eax,%esi
        return NULL;

    // create the internal hashtable
    ht->ht = hashtable_create();
c01068aa:	e8 9c ee ff ff       	call   c010574b <hashtable_create>
c01068af:	89 06                	mov    %eax,(%esi)
    if(ht->ht == NULL) {
c01068b1:	85 c0                	test   %eax,%eax
c01068b3:	75 0e                	jne    c01068c3 <hashtable_ts_create+0x33>
        kfree(ht);
c01068b5:	83 ec 0c             	sub    $0xc,%esp
c01068b8:	56                   	push   %esi
c01068b9:	e8 b3 b0 ff ff       	call   c0101971 <kfree>
        return NULL;
c01068be:	83 c4 10             	add    $0x10,%esp
c01068c1:	eb 30                	jmp    c01068f3 <hashtable_ts_create+0x63>
    }

    //create the lock
    ht->lock = lock_create("hashtable lock");
c01068c3:	83 ec 0c             	sub    $0xc,%esp
c01068c6:	68 16 c1 10 c0       	push   $0xc010c116
c01068cb:	e8 af c3 ff ff       	call   c0102c7f <lock_create>
c01068d0:	89 46 04             	mov    %eax,0x4(%esi)
    if(ht->lock == NULL) {
c01068d3:	83 c4 10             	add    $0x10,%esp
c01068d6:	89 f3                	mov    %esi,%ebx
c01068d8:	85 c0                	test   %eax,%eax
c01068da:	75 17                	jne    c01068f3 <hashtable_ts_create+0x63>
        hashtable_destroy(ht->ht);
c01068dc:	83 ec 0c             	sub    $0xc,%esp
c01068df:	ff 36                	pushl  (%esi)
c01068e1:	e8 2e f6 ff ff       	call   c0105f14 <hashtable_destroy>
        kfree(ht);
c01068e6:	89 34 24             	mov    %esi,(%esp)
c01068e9:	e8 83 b0 ff ff       	call   c0101971 <kfree>
        return NULL;
c01068ee:	83 c4 10             	add    $0x10,%esp
c01068f1:	31 db                	xor    %ebx,%ebx
    }

    return ht;
};
c01068f3:	89 d8                	mov    %ebx,%eax
c01068f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01068f8:	5b                   	pop    %ebx
c01068f9:	5e                   	pop    %esi
c01068fa:	5d                   	pop    %ebp
c01068fb:	c3                   	ret    

c01068fc <hashtable_ts_destroy>:

void hashtable_ts_destroy(struct hashtable_ts* ht) {
c01068fc:	55                   	push   %ebp
c01068fd:	89 e5                	mov    %esp,%ebp
c01068ff:	53                   	push   %ebx
c0106900:	83 ec 10             	sub    $0x10,%esp
c0106903:	8b 5d 08             	mov    0x8(%ebp),%ebx

    hashtable_destroy(ht->ht);
c0106906:	ff 33                	pushl  (%ebx)
c0106908:	e8 07 f6 ff ff       	call   c0105f14 <hashtable_destroy>
    lock_destroy(ht->lock);
c010690d:	58                   	pop    %eax
c010690e:	ff 73 04             	pushl  0x4(%ebx)
c0106911:	e8 ec c3 ff ff       	call   c0102d02 <lock_destroy>

    kfree(ht);
c0106916:	83 c4 10             	add    $0x10,%esp
c0106919:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c010691c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010691f:	c9                   	leave  
void hashtable_ts_destroy(struct hashtable_ts* ht) {

    hashtable_destroy(ht->ht);
    lock_destroy(ht->lock);

    kfree(ht);
c0106920:	e9 4c b0 ff ff       	jmp    c0101971 <kfree>

c0106925 <hashtable_ts_add>:
}



int hashtable_ts_add(struct hashtable_ts* h, char* key, unsigned int keylen, void* val) {
c0106925:	55                   	push   %ebp
c0106926:	89 e5                	mov    %esp,%ebp
c0106928:	53                   	push   %ebx
c0106929:	83 ec 20             	sub    $0x20,%esp
c010692c:	8b 5d 08             	mov    0x8(%ebp),%ebx

    int ret;

    lock_acquire(h->lock);
c010692f:	ff 73 04             	pushl  0x4(%ebx)
c0106932:	e8 98 c4 ff ff       	call   c0102dcf <lock_acquire>

    ret = hashtable_add(h->ht, key, keylen, val);
c0106937:	ff 75 14             	pushl  0x14(%ebp)
c010693a:	ff 75 10             	pushl  0x10(%ebp)
c010693d:	ff 75 0c             	pushl  0xc(%ebp)
c0106940:	ff 33                	pushl  (%ebx)
c0106942:	e8 79 ee ff ff       	call   c01057c0 <hashtable_add>
c0106947:	89 45 f4             	mov    %eax,-0xc(%ebp)

    lock_release(h->lock);
c010694a:	83 c4 14             	add    $0x14,%esp
c010694d:	ff 73 04             	pushl  0x4(%ebx)
c0106950:	e8 e2 c5 ff ff       	call   c0102f37 <lock_release>

    return ret;
}
c0106955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010695b:	c9                   	leave  
c010695c:	c3                   	ret    

c010695d <hashtable_ts_find>:



void* hashtable_ts_find(struct hashtable_ts* h, char* key, unsigned int keylen) {
c010695d:	55                   	push   %ebp
c010695e:	89 e5                	mov    %esp,%ebp
c0106960:	53                   	push   %ebx
c0106961:	83 ec 20             	sub    $0x20,%esp
c0106964:	8b 5d 08             	mov    0x8(%ebp),%ebx

    void* ret;

    lock_acquire(h->lock);
c0106967:	ff 73 04             	pushl  0x4(%ebx)
c010696a:	e8 60 c4 ff ff       	call   c0102dcf <lock_acquire>
    ret = hashtable_find(h->ht, key, keylen);
c010696f:	83 c4 0c             	add    $0xc,%esp
c0106972:	ff 75 10             	pushl  0x10(%ebp)
c0106975:	ff 75 0c             	pushl  0xc(%ebp)
c0106978:	ff 33                	pushl  (%ebx)
c010697a:	e8 9e f1 ff ff       	call   c0105b1d <hashtable_find>
c010697f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(h->lock);
c0106982:	58                   	pop    %eax
c0106983:	ff 73 04             	pushl  0x4(%ebx)
c0106986:	e8 ac c5 ff ff       	call   c0102f37 <lock_release>

    return ret;
}
c010698b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010698e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106991:	c9                   	leave  
c0106992:	c3                   	ret    

c0106993 <hashtable_ts_remove>:


void* hashtable_ts_remove(struct hashtable_ts* h, char* key, unsigned int keylen) {
c0106993:	55                   	push   %ebp
c0106994:	89 e5                	mov    %esp,%ebp
c0106996:	53                   	push   %ebx
c0106997:	83 ec 20             	sub    $0x20,%esp
c010699a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void* ret;

    lock_acquire(h->lock);
c010699d:	ff 73 04             	pushl  0x4(%ebx)
c01069a0:	e8 2a c4 ff ff       	call   c0102dcf <lock_acquire>
    ret = hashtable_remove(h->ht, key, keylen);
c01069a5:	83 c4 0c             	add    $0xc,%esp
c01069a8:	ff 75 10             	pushl  0x10(%ebp)
c01069ab:	ff 75 0c             	pushl  0xc(%ebp)
c01069ae:	ff 33                	pushl  (%ebx)
c01069b0:	e8 85 f2 ff ff       	call   c0105c3a <hashtable_remove>
c01069b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(h->lock);
c01069b8:	58                   	pop    %eax
c01069b9:	ff 73 04             	pushl  0x4(%ebx)
c01069bc:	e8 76 c5 ff ff       	call   c0102f37 <lock_release>

    return ret;
}
c01069c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01069c7:	c9                   	leave  
c01069c8:	c3                   	ret    

c01069c9 <hashtable_ts_isempty>:


int hashtable_ts_isempty(struct hashtable_ts* h) {
c01069c9:	55                   	push   %ebp
c01069ca:	89 e5                	mov    %esp,%ebp
c01069cc:	53                   	push   %ebx
c01069cd:	83 ec 20             	sub    $0x20,%esp
c01069d0:	8b 5d 08             	mov    0x8(%ebp),%ebx

    int ret;

    lock_acquire(h->lock);
c01069d3:	ff 73 04             	pushl  0x4(%ebx)
c01069d6:	e8 f4 c3 ff ff       	call   c0102dcf <lock_acquire>

    ret = hashtable_isempty(h->ht);
c01069db:	58                   	pop    %eax
c01069dc:	ff 33                	pushl  (%ebx)
c01069de:	e8 47 f4 ff ff       	call   c0105e2a <hashtable_isempty>
c01069e3:	89 45 f4             	mov    %eax,-0xc(%ebp)

    lock_release(h->lock);
c01069e6:	5a                   	pop    %edx
c01069e7:	ff 73 04             	pushl  0x4(%ebx)
c01069ea:	e8 48 c5 ff ff       	call   c0102f37 <lock_release>

    return ret;
}
c01069ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01069f5:	c9                   	leave  
c01069f6:	c3                   	ret    

c01069f7 <hashtable_ts_getsize>:


unsigned int hashtable_ts_getsize(struct hashtable_ts* h) {
c01069f7:	55                   	push   %ebp
c01069f8:	89 e5                	mov    %esp,%ebp
c01069fa:	53                   	push   %ebx
c01069fb:	83 ec 20             	sub    $0x20,%esp
c01069fe:	8b 5d 08             	mov    0x8(%ebp),%ebx

    unsigned int ret;

    lock_acquire(h->lock);
c0106a01:	ff 73 04             	pushl  0x4(%ebx)
c0106a04:	e8 c6 c3 ff ff       	call   c0102dcf <lock_acquire>
    ret = hashtable_getsize(h->ht);
c0106a09:	58                   	pop    %eax
c0106a0a:	ff 33                	pushl  (%ebx)
c0106a0c:	e8 91 f4 ff ff       	call   c0105ea2 <hashtable_getsize>
c0106a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_release(h->lock);
c0106a14:	5a                   	pop    %edx
c0106a15:	ff 73 04             	pushl  0x4(%ebx)
c0106a18:	e8 1a c5 ff ff       	call   c0102f37 <lock_release>

    return ret;
}
c0106a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106a23:	c9                   	leave  
c0106a24:	c3                   	ret    

c0106a25 <hashtable_ts_assertvalid>:


void hashtable_ts_assertvalid(struct hashtable_ts* h) {
c0106a25:	55                   	push   %ebp
c0106a26:	89 e5                	mov    %esp,%ebp
c0106a28:	53                   	push   %ebx
c0106a29:	83 ec 10             	sub    $0x10,%esp
c0106a2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    lock_acquire(h->lock);
c0106a2f:	ff 73 04             	pushl  0x4(%ebx)
c0106a32:	e8 98 c3 ff ff       	call   c0102dcf <lock_acquire>
    hashtable_assertvalid(h->ht);
c0106a37:	58                   	pop    %eax
c0106a38:	ff 33                	pushl  (%ebx)
c0106a3a:	e8 39 f5 ff ff       	call   c0105f78 <hashtable_assertvalid>
    lock_release(h->lock);
c0106a3f:	83 c4 10             	add    $0x10,%esp
c0106a42:	8b 43 04             	mov    0x4(%ebx),%eax
c0106a45:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0106a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106a4b:	c9                   	leave  


void hashtable_ts_assertvalid(struct hashtable_ts* h) {
    lock_acquire(h->lock);
    hashtable_assertvalid(h->ht);
    lock_release(h->lock);
c0106a4c:	e9 e6 c4 ff ff       	jmp    c0102f37 <lock_release>

c0106a51 <thread_checkstack.isra.0>:

DEFARRAY(thread, );

static
void
thread_checkstack(struct thread *thread) {
c0106a51:	55                   	push   %ebp
c0106a52:	89 e5                	mov    %esp,%ebp
c0106a54:	53                   	push   %ebx
c0106a55:	52                   	push   %edx
c0106a56:	89 c3                	mov    %eax,%ebx
    assert(thread->stack != NULL);
c0106a58:	83 38 00             	cmpl   $0x0,(%eax)
c0106a5b:	75 28                	jne    c0106a85 <thread_checkstack.isra.0+0x34>
c0106a5d:	83 ec 0c             	sub    $0xc,%esp
c0106a60:	68 58 c3 10 c0       	push   $0xc010c358
c0106a65:	6a 17                	push   $0x17
c0106a67:	68 25 c1 10 c0       	push   $0xc010c125
c0106a6c:	68 35 c1 10 c0       	push   $0xc010c135
c0106a71:	68 95 a9 10 c0       	push   $0xc010a995
c0106a76:	e8 49 d3 ff ff       	call   c0103dc4 <print>
c0106a7b:	83 c4 20             	add    $0x20,%esp
c0106a7e:	e8 c7 a3 ff ff       	call   c0100e4a <backtrace>
c0106a83:	fa                   	cli    
c0106a84:	f4                   	hlt    
    assert(((uint32_t*) thread->stack)[0] = THREAD_STACK_MAGIC);
c0106a85:	8b 03                	mov    (%ebx),%eax
c0106a87:	c7 00 ce fa ad de    	movl   $0xdeadface,(%eax)
    assert(((uint32_t*) thread->stack)[1] = THREAD_STACK_MAGIC);
c0106a8d:	c7 40 04 ce fa ad de 	movl   $0xdeadface,0x4(%eax)
    assert(((uint32_t*) thread->stack)[2] = THREAD_STACK_MAGIC);
c0106a94:	c7 40 08 ce fa ad de 	movl   $0xdeadface,0x8(%eax)
    assert(((uint32_t*) thread->stack)[3] = THREAD_STACK_MAGIC);
c0106a9b:	c7 40 0c ce fa ad de 	movl   $0xdeadface,0xc(%eax)
}
c0106aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106aa5:	c9                   	leave  
c0106aa6:	c3                   	ret    

c0106aa7 <threadarray_create>:
#include <stackreg.h>
#include <err.h>
#include <switchframe.h>
#include <debug.h>

DEFARRAY(thread, );
c0106aa7:	55                   	push   %ebp
c0106aa8:	89 e5                	mov    %esp,%ebp
c0106aaa:	83 ec 24             	sub    $0x24,%esp
c0106aad:	6a 0c                	push   $0xc
c0106aaf:	e8 f1 ad ff ff       	call   c01018a5 <kmalloc>
c0106ab4:	83 c4 10             	add    $0x10,%esp
c0106ab7:	85 c0                	test   %eax,%eax
c0106ab9:	74 12                	je     c0106acd <threadarray_create+0x26>
c0106abb:	83 ec 0c             	sub    $0xc,%esp
c0106abe:	50                   	push   %eax
c0106abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106ac2:	e8 15 db ff ff       	call   c01045dc <array_init>
c0106ac7:	83 c4 10             	add    $0x10,%esp
c0106aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106acd:	c9                   	leave  
c0106ace:	c3                   	ret    

c0106acf <threadarray_destroy>:
c0106acf:	55                   	push   %ebp
c0106ad0:	89 e5                	mov    %esp,%ebp
c0106ad2:	53                   	push   %ebx
c0106ad3:	83 ec 10             	sub    $0x10,%esp
c0106ad6:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0106ad9:	53                   	push   %ebx
c0106ada:	e8 19 db ff ff       	call   c01045f8 <array_cleanup>
c0106adf:	83 c4 10             	add    $0x10,%esp
c0106ae2:	89 5d 08             	mov    %ebx,0x8(%ebp)
c0106ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106ae8:	c9                   	leave  
c0106ae9:	e9 83 ae ff ff       	jmp    c0101971 <kfree>

c0106aee <threadarray_init>:
c0106aee:	55                   	push   %ebp
c0106aef:	89 e5                	mov    %esp,%ebp
c0106af1:	5d                   	pop    %ebp
c0106af2:	e9 e5 da ff ff       	jmp    c01045dc <array_init>

c0106af7 <threadarray_cleanup>:
c0106af7:	55                   	push   %ebp
c0106af8:	89 e5                	mov    %esp,%ebp
c0106afa:	5d                   	pop    %ebp
c0106afb:	e9 f8 da ff ff       	jmp    c01045f8 <array_cleanup>

c0106b00 <threadarray_num>:
c0106b00:	55                   	push   %ebp
c0106b01:	89 e5                	mov    %esp,%ebp
c0106b03:	5d                   	pop    %ebp
c0106b04:	e9 13 da ff ff       	jmp    c010451c <array_num>

c0106b09 <threadarray_get>:
c0106b09:	55                   	push   %ebp
c0106b0a:	89 e5                	mov    %esp,%ebp
c0106b0c:	5d                   	pop    %ebp
c0106b0d:	e9 15 da ff ff       	jmp    c0104527 <array_get>

c0106b12 <threadarray_set>:
c0106b12:	55                   	push   %ebp
c0106b13:	89 e5                	mov    %esp,%ebp
c0106b15:	5d                   	pop    %ebp
c0106b16:	e9 50 da ff ff       	jmp    c010456b <array_set>

c0106b1b <threadarray_setsize>:
c0106b1b:	55                   	push   %ebp
c0106b1c:	89 e5                	mov    %esp,%ebp
c0106b1e:	5d                   	pop    %ebp
c0106b1f:	e9 41 db ff ff       	jmp    c0104665 <array_setsize>

c0106b24 <threadarray_add>:
c0106b24:	55                   	push   %ebp
c0106b25:	89 e5                	mov    %esp,%ebp
c0106b27:	5d                   	pop    %ebp
c0106b28:	e9 ae db ff ff       	jmp    c01046db <array_add>

c0106b2d <threadarray_remove>:
c0106b2d:	55                   	push   %ebp
c0106b2e:	89 e5                	mov    %esp,%ebp
c0106b30:	5d                   	pop    %ebp
c0106b31:	e9 de db ff ff       	jmp    c0104714 <array_remove>

c0106b36 <thread_create>:
    assert(((uint32_t*) thread->stack)[2] = THREAD_STACK_MAGIC);
    assert(((uint32_t*) thread->stack)[3] = THREAD_STACK_MAGIC);
}

struct thread*
thread_create(const char* name) {
c0106b36:	55                   	push   %ebp
c0106b37:	89 e5                	mov    %esp,%ebp
c0106b39:	56                   	push   %esi
c0106b3a:	53                   	push   %ebx
c0106b3b:	8b 75 08             	mov    0x8(%ebp),%esi
    struct thread* thread = kmalloc(sizeof(struct thread));
c0106b3e:	83 ec 0c             	sub    $0xc,%esp
c0106b41:	6a 40                	push   $0x40
c0106b43:	e8 5d ad ff ff       	call   c01018a5 <kmalloc>
c0106b48:	89 c3                	mov    %eax,%ebx
    if (thread == NULL)
c0106b4a:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0106b4d:	31 c0                	xor    %eax,%eax
}

struct thread*
thread_create(const char* name) {
    struct thread* thread = kmalloc(sizeof(struct thread));
    if (thread == NULL)
c0106b4f:	85 db                	test   %ebx,%ebx
c0106b51:	0f 84 aa 00 00 00    	je     c0106c01 <thread_create+0xcb>
        return NULL;

    assert(name != NULL);
c0106b57:	85 f6                	test   %esi,%esi
c0106b59:	75 28                	jne    c0106b83 <thread_create+0x4d>
c0106b5b:	83 ec 0c             	sub    $0xc,%esp
c0106b5e:	68 6c c3 10 c0       	push   $0xc010c36c
c0106b63:	6a 24                	push   $0x24
c0106b65:	68 25 c1 10 c0       	push   $0xc010c125
c0106b6a:	68 4b c1 10 c0       	push   $0xc010c14b
c0106b6f:	68 95 a9 10 c0       	push   $0xc010a995
c0106b74:	e8 4b d2 ff ff       	call   c0103dc4 <print>
c0106b79:	83 c4 20             	add    $0x20,%esp
c0106b7c:	e8 c9 a2 ff ff       	call   c0100e4a <backtrace>
c0106b81:	fa                   	cli    
c0106b82:	f4                   	hlt    
    thread->name = strdup(name);
c0106b83:	83 ec 0c             	sub    $0xc,%esp
c0106b86:	56                   	push   %esi
c0106b87:	e8 7e d7 ff ff       	call   c010430a <strdup>
c0106b8c:	89 43 10             	mov    %eax,0x10(%ebx)
    if (thread->name == NULL) {
c0106b8f:	83 c4 10             	add    $0x10,%esp
c0106b92:	85 c0                	test   %eax,%eax
c0106b94:	75 10                	jne    c0106ba6 <thread_create+0x70>
        kfree(thread);
c0106b96:	83 ec 0c             	sub    $0xc,%esp
c0106b99:	53                   	push   %ebx
c0106b9a:	e8 d2 ad ff ff       	call   c0101971 <kfree>
        return NULL;
c0106b9f:	83 c4 10             	add    $0x10,%esp
c0106ba2:	31 c0                	xor    %eax,%eax
c0106ba4:	eb 5b                	jmp    c0106c01 <thread_create+0xcb>
    }

    thread->wchan_name = "NEW";
c0106ba6:	c7 43 14 58 c1 10 c0 	movl   $0xc010c158,0x14(%ebx)
    thread->state = S_READY;
c0106bad:	c7 43 18 01 00 00 00 	movl   $0x1,0x18(%ebx)

    threadlistnode_init(&thread->listnode, thread);
c0106bb4:	50                   	push   %eax
c0106bb5:	50                   	push   %eax
c0106bb6:	53                   	push   %ebx
c0106bb7:	8d 43 04             	lea    0x4(%ebx),%eax
c0106bba:	50                   	push   %eax
c0106bbb:	e8 9b 0b 00 00       	call   c010775b <threadlistnode_init>

    thread->cpu = NULL;
c0106bc0:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    thread->proc = NULL;
c0106bc7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

    thread->page_directory = NULL;
c0106bce:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    thread->stack = NULL;
c0106bd5:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)

    thread->in_interrupt = false;
c0106bdc:	c6 43 2c 00          	movb   $0x0,0x2c(%ebx)

    thread->rval = -1;
c0106be0:	c7 43 30 ff ff ff ff 	movl   $0xffffffff,0x30(%ebx)
    thread->parent = NULL;
c0106be7:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
    thread->psem = NULL;
c0106bee:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
    thread->csem = NULL;
c0106bf5:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

    return thread;
c0106bfc:	83 c4 10             	add    $0x10,%esp
c0106bff:	89 d8                	mov    %ebx,%eax
}
c0106c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0106c04:	5b                   	pop    %ebx
c0106c05:	5e                   	pop    %esi
c0106c06:	5d                   	pop    %ebp
c0106c07:	c3                   	ret    

c0106c08 <thread_destroy>:
    thread_switch(S_ZOMBIE, NULL, NULL);
    panic("thread_switch returned\n");
}

void
thread_destroy(struct thread* thread) {
c0106c08:	55                   	push   %ebp
c0106c09:	89 e5                	mov    %esp,%ebp
c0106c0b:	53                   	push   %ebx
c0106c0c:	52                   	push   %edx
c0106c0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(thread != thisthread);
c0106c10:	e8 2d b9 ff ff       	call   c0102542 <cpunum>
c0106c15:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106c1c:	39 58 08             	cmp    %ebx,0x8(%eax)
c0106c1f:	75 2b                	jne    c0106c4c <thread_destroy+0x44>
c0106c21:	83 ec 0c             	sub    $0xc,%esp
c0106c24:	68 1c c3 10 c0       	push   $0xc010c31c
c0106c29:	68 03 01 00 00       	push   $0x103
c0106c2e:	68 25 c1 10 c0       	push   $0xc010c125
c0106c33:	68 5c c1 10 c0       	push   $0xc010c15c
c0106c38:	68 95 a9 10 c0       	push   $0xc010a995
c0106c3d:	e8 82 d1 ff ff       	call   c0103dc4 <print>
c0106c42:	83 c4 20             	add    $0x20,%esp
c0106c45:	e8 00 a2 ff ff       	call   c0100e4a <backtrace>
c0106c4a:	fa                   	cli    
c0106c4b:	f4                   	hlt    
    assert(thread->state != S_RUN);
c0106c4c:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
c0106c50:	75 2b                	jne    c0106c7d <thread_destroy+0x75>
c0106c52:	83 ec 0c             	sub    $0xc,%esp
c0106c55:	68 1c c3 10 c0       	push   $0xc010c31c
c0106c5a:	68 04 01 00 00       	push   $0x104
c0106c5f:	68 25 c1 10 c0       	push   $0xc010c125
c0106c64:	68 71 c1 10 c0       	push   $0xc010c171
c0106c69:	68 95 a9 10 c0       	push   $0xc010a995
c0106c6e:	e8 51 d1 ff ff       	call   c0103dc4 <print>
c0106c73:	83 c4 20             	add    $0x20,%esp
c0106c76:	e8 cf a1 ff ff       	call   c0100e4a <backtrace>
c0106c7b:	fa                   	cli    
c0106c7c:	f4                   	hlt    
    assert(thread->proc == NULL);
c0106c7d:	83 7b 20 00          	cmpl   $0x0,0x20(%ebx)
c0106c81:	74 2b                	je     c0106cae <thread_destroy+0xa6>
c0106c83:	83 ec 0c             	sub    $0xc,%esp
c0106c86:	68 1c c3 10 c0       	push   $0xc010c31c
c0106c8b:	68 05 01 00 00       	push   $0x105
c0106c90:	68 25 c1 10 c0       	push   $0xc010c125
c0106c95:	68 a7 c2 10 c0       	push   $0xc010c2a7
c0106c9a:	68 95 a9 10 c0       	push   $0xc010a995
c0106c9f:	e8 20 d1 ff ff       	call   c0103dc4 <print>
c0106ca4:	83 c4 20             	add    $0x20,%esp
c0106ca7:	e8 9e a1 ff ff       	call   c0100e4a <backtrace>
c0106cac:	fa                   	cli    
c0106cad:	f4                   	hlt    

    // if (thread->page_directory != NULL)
    //     kfree(thread->page_directory);      // not correct

    stackreg_return(thread->stack);
c0106cae:	83 ec 0c             	sub    $0xc,%esp
c0106cb1:	ff 73 28             	pushl  0x28(%ebx)
c0106cb4:	e8 2e 14 00 00       	call   c01080e7 <stackreg_return>

    threadlistnode_cleanup(&thread->listnode);
c0106cb9:	8d 43 04             	lea    0x4(%ebx),%eax
c0106cbc:	89 04 24             	mov    %eax,(%esp)
c0106cbf:	e8 11 0b 00 00       	call   c01077d5 <threadlistnode_cleanup>

    thread->wchan_name = "DESTROYED";
c0106cc4:	c7 43 14 88 c1 10 c0 	movl   $0xc010c188,0x14(%ebx)

    kfree(thread->name);
c0106ccb:	58                   	pop    %eax
c0106ccc:	ff 73 10             	pushl  0x10(%ebx)
c0106ccf:	e8 9d ac ff ff       	call   c0101971 <kfree>
    kfree(thread);
c0106cd4:	83 c4 10             	add    $0x10,%esp
c0106cd7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c0106cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106cdd:	c9                   	leave  
    threadlistnode_cleanup(&thread->listnode);

    thread->wchan_name = "DESTROYED";

    kfree(thread->name);
    kfree(thread);
c0106cde:	e9 8e ac ff ff       	jmp    c0101971 <kfree>

c0106ce3 <thread_exorcise>:
}

void
thread_exorcise(void) {
c0106ce3:	55                   	push   %ebp
c0106ce4:	89 e5                	mov    %esp,%ebp
c0106ce6:	53                   	push   %ebx
c0106ce7:	50                   	push   %eax
    struct thread* thread;

    while ((thread = threadlist_remhead(&thiscpu->zombie_threads)) != NULL) {
c0106ce8:	e8 55 b8 ff ff       	call   c0102542 <cpunum>
c0106ced:	83 ec 0c             	sub    $0xc,%esp
c0106cf0:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106cf7:	83 c0 10             	add    $0x10,%eax
c0106cfa:	50                   	push   %eax
c0106cfb:	e8 e1 0e 00 00       	call   c0107be1 <threadlist_remhead>
c0106d00:	89 c3                	mov    %eax,%ebx
c0106d02:	83 c4 10             	add    $0x10,%esp
c0106d05:	85 c0                	test   %eax,%eax
c0106d07:	0f 84 8f 00 00 00    	je     c0106d9c <thread_exorcise+0xb9>
        assert(thread != NULL);
        if (thread == thisthread)
c0106d0d:	e8 30 b8 ff ff       	call   c0102542 <cpunum>
c0106d12:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106d19:	3b 58 08             	cmp    0x8(%eax),%ebx
c0106d1c:	74 ca                	je     c0106ce8 <thread_exorcise+0x5>
            continue;
        assert(thread != thisthread);
c0106d1e:	e8 1f b8 ff ff       	call   c0102542 <cpunum>
c0106d23:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106d2a:	3b 58 08             	cmp    0x8(%eax),%ebx
c0106d2d:	75 2b                	jne    c0106d5a <thread_exorcise+0x77>
c0106d2f:	83 ec 0c             	sub    $0xc,%esp
c0106d32:	68 0c c3 10 c0       	push   $0xc010c30c
c0106d37:	68 1c 01 00 00       	push   $0x11c
c0106d3c:	68 25 c1 10 c0       	push   $0xc010c125
c0106d41:	68 5c c1 10 c0       	push   $0xc010c15c
c0106d46:	68 95 a9 10 c0       	push   $0xc010a995
c0106d4b:	e8 74 d0 ff ff       	call   c0103dc4 <print>
c0106d50:	83 c4 20             	add    $0x20,%esp
c0106d53:	e8 f2 a0 ff ff       	call   c0100e4a <backtrace>
c0106d58:	fa                   	cli    
c0106d59:	f4                   	hlt    
        assert(thread->state == S_ZOMBIE);
c0106d5a:	83 7b 18 03          	cmpl   $0x3,0x18(%ebx)
c0106d5e:	74 2b                	je     c0106d8b <thread_exorcise+0xa8>
c0106d60:	83 ec 0c             	sub    $0xc,%esp
c0106d63:	68 0c c3 10 c0       	push   $0xc010c30c
c0106d68:	68 1d 01 00 00       	push   $0x11d
c0106d6d:	68 25 c1 10 c0       	push   $0xc010c125
c0106d72:	68 92 c1 10 c0       	push   $0xc010c192
c0106d77:	68 95 a9 10 c0       	push   $0xc010a995
c0106d7c:	e8 43 d0 ff ff       	call   c0103dc4 <print>
c0106d81:	83 c4 20             	add    $0x20,%esp
c0106d84:	e8 c1 a0 ff ff       	call   c0100e4a <backtrace>
c0106d89:	fa                   	cli    
c0106d8a:	f4                   	hlt    
        thread_destroy(thread);
c0106d8b:	83 ec 0c             	sub    $0xc,%esp
c0106d8e:	53                   	push   %ebx
c0106d8f:	e8 74 fe ff ff       	call   c0106c08 <thread_destroy>
c0106d94:	83 c4 10             	add    $0x10,%esp
c0106d97:	e9 4c ff ff ff       	jmp    c0106ce8 <thread_exorcise+0x5>
    }
}
c0106d9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0106d9f:	c9                   	leave  
c0106da0:	c3                   	ret    

c0106da1 <thread_join>:

int thread_join(struct thread* thread, int* ret_out) {
c0106da1:	55                   	push   %ebp
c0106da2:	89 e5                	mov    %esp,%ebp
c0106da4:	57                   	push   %edi
c0106da5:	56                   	push   %esi
c0106da6:	53                   	push   %ebx
c0106da7:	83 ec 0c             	sub    $0xc,%esp
c0106daa:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0106dad:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(thread != NULL);
c0106db0:	85 db                	test   %ebx,%ebx
c0106db2:	75 2b                	jne    c0106ddf <thread_join+0x3e>
c0106db4:	83 ec 0c             	sub    $0xc,%esp
c0106db7:	68 00 c3 10 c0       	push   $0xc010c300
c0106dbc:	68 23 01 00 00       	push   $0x123
c0106dc1:	68 25 c1 10 c0       	push   $0xc010c125
c0106dc6:	68 d8 c2 10 c0       	push   $0xc010c2d8
c0106dcb:	68 95 a9 10 c0       	push   $0xc010a995
c0106dd0:	e8 ef cf ff ff       	call   c0103dc4 <print>
c0106dd5:	83 c4 20             	add    $0x20,%esp
c0106dd8:	e8 6d a0 ff ff       	call   c0100e4a <backtrace>
c0106ddd:	fa                   	cli    
c0106dde:	f4                   	hlt    
    assert(ret_out != NULL);
c0106ddf:	85 f6                	test   %esi,%esi
c0106de1:	75 2b                	jne    c0106e0e <thread_join+0x6d>
c0106de3:	83 ec 0c             	sub    $0xc,%esp
c0106de6:	68 00 c3 10 c0       	push   $0xc010c300
c0106deb:	68 24 01 00 00       	push   $0x124
c0106df0:	68 25 c1 10 c0       	push   $0xc010c125
c0106df5:	68 ac c1 10 c0       	push   $0xc010c1ac
c0106dfa:	68 95 a9 10 c0       	push   $0xc010a995
c0106dff:	e8 c0 cf ff ff       	call   c0103dc4 <print>
c0106e04:	83 c4 20             	add    $0x20,%esp
c0106e07:	e8 3e a0 ff ff       	call   c0100e4a <backtrace>
c0106e0c:	fa                   	cli    
c0106e0d:	f4                   	hlt    
    assert(thread->parent != NULL);
c0106e0e:	83 7b 34 00          	cmpl   $0x0,0x34(%ebx)
c0106e12:	75 2b                	jne    c0106e3f <thread_join+0x9e>
c0106e14:	83 ec 0c             	sub    $0xc,%esp
c0106e17:	68 00 c3 10 c0       	push   $0xc010c300
c0106e1c:	68 25 01 00 00       	push   $0x125
c0106e21:	68 25 c1 10 c0       	push   $0xc010c125
c0106e26:	68 bc c1 10 c0       	push   $0xc010c1bc
c0106e2b:	68 95 a9 10 c0       	push   $0xc010a995
c0106e30:	e8 8f cf ff ff       	call   c0103dc4 <print>
c0106e35:	83 c4 20             	add    $0x20,%esp
c0106e38:	e8 0d a0 ff ff       	call   c0100e4a <backtrace>
c0106e3d:	fa                   	cli    
c0106e3e:	f4                   	hlt    

    if (thread == thisthread)
c0106e3f:	e8 fe b6 ff ff       	call   c0102542 <cpunum>
c0106e44:	8b 14 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%edx
        return EDEADLK;
c0106e4b:	b8 08 00 00 00       	mov    $0x8,%eax
int thread_join(struct thread* thread, int* ret_out) {
    assert(thread != NULL);
    assert(ret_out != NULL);
    assert(thread->parent != NULL);

    if (thread == thisthread)
c0106e50:	3b 5a 08             	cmp    0x8(%edx),%ebx
c0106e53:	74 64                	je     c0106eb9 <thread_join+0x118>
        return EDEADLK;

    assert(thread->parent == thisthread);
c0106e55:	8b 7b 34             	mov    0x34(%ebx),%edi
c0106e58:	e8 e5 b6 ff ff       	call   c0102542 <cpunum>
c0106e5d:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106e64:	3b 78 08             	cmp    0x8(%eax),%edi
c0106e67:	74 2b                	je     c0106e94 <thread_join+0xf3>
c0106e69:	83 ec 0c             	sub    $0xc,%esp
c0106e6c:	68 00 c3 10 c0       	push   $0xc010c300
c0106e71:	68 2a 01 00 00       	push   $0x12a
c0106e76:	68 25 c1 10 c0       	push   $0xc010c125
c0106e7b:	68 d3 c1 10 c0       	push   $0xc010c1d3
c0106e80:	68 95 a9 10 c0       	push   $0xc010a995
c0106e85:	e8 3a cf ff ff       	call   c0103dc4 <print>
c0106e8a:	83 c4 20             	add    $0x20,%esp
c0106e8d:	e8 b8 9f ff ff       	call   c0100e4a <backtrace>
c0106e92:	fa                   	cli    
c0106e93:	f4                   	hlt    

    P(thread->psem);
c0106e94:	83 ec 0c             	sub    $0xc,%esp
c0106e97:	ff 73 38             	pushl  0x38(%ebx)
c0106e9a:	e8 4c c2 ff ff       	call   c01030eb <P>
    V(thread->csem);
c0106e9f:	58                   	pop    %eax
c0106ea0:	ff 73 3c             	pushl  0x3c(%ebx)
c0106ea3:	e8 1b c3 ff ff       	call   c01031c3 <V>

    *ret_out = thread->rval;
c0106ea8:	8b 43 30             	mov    0x30(%ebx),%eax
c0106eab:	89 06                	mov    %eax,(%esi)
    thread->parent = NULL;
c0106ead:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)

    return 0;
c0106eb4:	83 c4 10             	add    $0x10,%esp
c0106eb7:	31 c0                	xor    %eax,%eax
}
c0106eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106ebc:	5b                   	pop    %ebx
c0106ebd:	5e                   	pop    %esi
c0106ebe:	5f                   	pop    %edi
c0106ebf:	5d                   	pop    %ebp
c0106ec0:	c3                   	ret    

c0106ec1 <thread_start_cpus>:
c0106ec1:	55                   	push   %ebp
c0106ec2:	89 e5                	mov    %esp,%ebp
c0106ec4:	5d                   	pop    %ebp
c0106ec5:	c3                   	ret    

c0106ec6 <thread_panic>:
c0106ec6:	55                   	push   %ebp
c0106ec7:	89 e5                	mov    %esp,%ebp
c0106ec9:	5d                   	pop    %ebp
c0106eca:	c3                   	ret    

c0106ecb <thread_shutdown>:

void thread_panic(void) {

}

void thread_shutdown(void) {
c0106ecb:	55                   	push   %ebp
c0106ecc:	89 e5                	mov    %esp,%ebp

}
c0106ece:	5d                   	pop    %ebp
c0106ecf:	c3                   	ret    

c0106ed0 <thread_make_runnable>:



void
thread_make_runnable(struct thread* target, bool holding_lock) {
c0106ed0:	55                   	push   %ebp
c0106ed1:	89 e5                	mov    %esp,%ebp
c0106ed3:	57                   	push   %edi
c0106ed4:	56                   	push   %esi
c0106ed5:	53                   	push   %ebx
c0106ed6:	83 ec 1c             	sub    $0x1c,%esp
c0106ed9:	8b 7d 08             	mov    0x8(%ebp),%edi
c0106edc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106edf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    (void) holding_lock;
    struct cpu *targetcpu = target->cpu;
c0106ee2:	8b 77 1c             	mov    0x1c(%edi),%esi

    target->state = S_READY;
c0106ee5:	c7 47 18 01 00 00 00 	movl   $0x1,0x18(%edi)

    if (holding_lock)
c0106eec:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
c0106ef0:	8d 5e 48             	lea    0x48(%esi),%ebx
c0106ef3:	74 3d                	je     c0106f32 <thread_make_runnable+0x62>
        assert(spinlock_held(&targetcpu->active_threads_lock));
c0106ef5:	83 ec 0c             	sub    $0xc,%esp
c0106ef8:	53                   	push   %ebx
c0106ef9:	e8 5a c3 ff ff       	call   c0103258 <spinlock_held>
c0106efe:	83 c4 10             	add    $0x10,%esp
c0106f01:	84 c0                	test   %al,%al
c0106f03:	75 39                	jne    c0106f3e <thread_make_runnable+0x6e>
c0106f05:	83 ec 0c             	sub    $0xc,%esp
c0106f08:	68 e8 c2 10 c0       	push   $0xc010c2e8
c0106f0d:	68 4b 01 00 00       	push   $0x14b
c0106f12:	68 25 c1 10 c0       	push   $0xc010c125
c0106f17:	68 f0 c1 10 c0       	push   $0xc010c1f0
c0106f1c:	68 95 a9 10 c0       	push   $0xc010a995
c0106f21:	e8 9e ce ff ff       	call   c0103dc4 <print>
c0106f26:	83 c4 20             	add    $0x20,%esp
c0106f29:	e8 1c 9f ff ff       	call   c0100e4a <backtrace>
c0106f2e:	fa                   	cli    
c0106f2f:	f4                   	hlt    
c0106f30:	eb 0c                	jmp    c0106f3e <thread_make_runnable+0x6e>
    else
        spinlock_acquire(&targetcpu->active_threads_lock);
c0106f32:	83 ec 0c             	sub    $0xc,%esp
c0106f35:	53                   	push   %ebx
c0106f36:	e8 bc c3 ff ff       	call   c01032f7 <spinlock_acquire>
c0106f3b:	83 c4 10             	add    $0x10,%esp

    threadlist_addtail(&targetcpu->active_threads, target);
c0106f3e:	50                   	push   %eax
c0106f3f:	50                   	push   %eax
c0106f40:	57                   	push   %edi
c0106f41:	8d 46 2c             	lea    0x2c(%esi),%eax
c0106f44:	50                   	push   %eax
c0106f45:	e8 1a 0c 00 00       	call   c0107b64 <threadlist_addtail>

    /*
     * Other processor is idle; send interrupt to make
     * sure it unidles.
     */
    if (targetcpu->status == CPU_IDLE) {
c0106f4a:	8a 46 05             	mov    0x5(%esi),%al
c0106f4d:	83 c4 10             	add    $0x10,%esp
c0106f50:	3c 03                	cmp    $0x3,%al
c0106f52:	75 1c                	jne    c0106f70 <thread_make_runnable+0xa0>
        // ipi_send(targetcpu, IPI_UNIDLE);
        panic("CPU_IDLE");
c0106f54:	68 1f c2 10 c0       	push   $0xc010c21f
c0106f59:	68 e8 c2 10 c0       	push   $0xc010c2e8
c0106f5e:	68 57 01 00 00       	push   $0x157
c0106f63:	68 25 c1 10 c0       	push   $0xc010c125
c0106f68:	e8 d5 c9 ff ff       	call   c0103942 <_panic>
c0106f6d:	83 c4 10             	add    $0x10,%esp
    }

    if (!holding_lock)
c0106f70:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
c0106f74:	75 0f                	jne    c0106f85 <thread_make_runnable+0xb5>
        spinlock_release(&targetcpu->active_threads_lock);
c0106f76:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c0106f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106f7c:	5b                   	pop    %ebx
c0106f7d:	5e                   	pop    %esi
c0106f7e:	5f                   	pop    %edi
c0106f7f:	5d                   	pop    %ebp
        // ipi_send(targetcpu, IPI_UNIDLE);
        panic("CPU_IDLE");
    }

    if (!holding_lock)
        spinlock_release(&targetcpu->active_threads_lock);
c0106f80:	e9 1a c4 ff ff       	jmp    c010339f <spinlock_release>
}
c0106f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0106f88:	5b                   	pop    %ebx
c0106f89:	5e                   	pop    %esi
c0106f8a:	5f                   	pop    %edi
c0106f8b:	5d                   	pop    %ebp
c0106f8c:	c3                   	ret    

c0106f8d <thread_fork>:
}

int
thread_fork(const char* name, struct thread** thread_out,
        struct proc* proc, int (*entrypoint)(void*, unsigned long),
        void* data1, unsigned long data2) {
c0106f8d:	55                   	push   %ebp
c0106f8e:	89 e5                	mov    %esp,%ebp
c0106f90:	57                   	push   %edi
c0106f91:	56                   	push   %esi
c0106f92:	53                   	push   %ebx
c0106f93:	83 ec 18             	sub    $0x18,%esp
c0106f96:	8b 7d 08             	mov    0x8(%ebp),%edi

    struct thread* newthread = thread_create(name);
c0106f99:	57                   	push   %edi
c0106f9a:	e8 97 fb ff ff       	call   c0106b36 <thread_create>
    if (newthread == NULL) {
c0106f9f:	83 c4 10             	add    $0x10,%esp
        return ENOMEM;
c0106fa2:	be 02 00 00 00       	mov    $0x2,%esi
thread_fork(const char* name, struct thread** thread_out,
        struct proc* proc, int (*entrypoint)(void*, unsigned long),
        void* data1, unsigned long data2) {

    struct thread* newthread = thread_create(name);
    if (newthread == NULL) {
c0106fa7:	85 c0                	test   %eax,%eax
c0106fa9:	0f 84 ea 00 00 00    	je     c0107099 <thread_fork+0x10c>
c0106faf:	89 c3                	mov    %eax,%ebx
        return ENOMEM;
    }

    newthread->stack = stackreg_get();
c0106fb1:	e8 64 10 00 00       	call   c010801a <stackreg_get>
c0106fb6:	89 43 28             	mov    %eax,0x28(%ebx)
    if (newthread->stack == NULL) {
c0106fb9:	85 c0                	test   %eax,%eax
c0106fbb:	0f 84 ac 00 00 00    	je     c010706d <thread_fork+0xe0>
c0106fc1:	8d 43 28             	lea    0x28(%ebx),%eax
        thread_destroy(newthread);
        return ENOMEM;
    }
    thread_checkstack(newthread);
c0106fc4:	e8 88 fa ff ff       	call   c0106a51 <thread_checkstack.isra.0>

    newthread->cpu = thiscpu;
c0106fc9:	e8 74 b5 ff ff       	call   c0102542 <cpunum>
c0106fce:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106fd5:	89 43 1c             	mov    %eax,0x1c(%ebx)
    newthread->page_directory = thisthread->page_directory;
c0106fd8:	e8 65 b5 ff ff       	call   c0102542 <cpunum>
c0106fdd:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0106fe4:	8b 40 08             	mov    0x8(%eax),%eax
c0106fe7:	8b 40 24             	mov    0x24(%eax),%eax
c0106fea:	89 43 24             	mov    %eax,0x24(%ebx)

    if (thread_out != NULL) {
c0106fed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106ff1:	74 4f                	je     c0107042 <thread_fork+0xb5>
        *thread_out = newthread;
c0106ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ff6:	89 18                	mov    %ebx,(%eax)
        newthread->parent = thisthread;
c0106ff8:	e8 45 b5 ff ff       	call   c0102542 <cpunum>
c0106ffd:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107004:	8b 40 08             	mov    0x8(%eax),%eax
c0107007:	89 43 34             	mov    %eax,0x34(%ebx)

        newthread->csem = semaphore_create(name, 0);
c010700a:	50                   	push   %eax
c010700b:	50                   	push   %eax
c010700c:	6a 00                	push   $0x0
c010700e:	57                   	push   %edi
c010700f:	e8 fc bf ff ff       	call   c0103010 <semaphore_create>
c0107014:	89 43 3c             	mov    %eax,0x3c(%ebx)
        if (newthread->csem == NULL) {
c0107017:	83 c4 10             	add    $0x10,%esp
c010701a:	85 c0                	test   %eax,%eax
c010701c:	74 4f                	je     c010706d <thread_fork+0xe0>
            thread_destroy(newthread);
            return ENOMEM;
        }

        newthread->psem = semaphore_create(name, 0);
c010701e:	50                   	push   %eax
c010701f:	50                   	push   %eax
c0107020:	6a 00                	push   $0x0
c0107022:	57                   	push   %edi
c0107023:	e8 e8 bf ff ff       	call   c0103010 <semaphore_create>
c0107028:	89 43 38             	mov    %eax,0x38(%ebx)
        if (newthread->psem == NULL) {
c010702b:	83 c4 10             	add    $0x10,%esp
c010702e:	85 c0                	test   %eax,%eax
c0107030:	75 10                	jne    c0107042 <thread_fork+0xb5>
            semaphore_destroy(newthread->csem);
c0107032:	83 ec 0c             	sub    $0xc,%esp
c0107035:	ff 73 3c             	pushl  0x3c(%ebx)
c0107038:	e8 4e c0 ff ff       	call   c010308b <semaphore_destroy>
            thread_destroy(newthread);
c010703d:	89 1c 24             	mov    %ebx,(%esp)
c0107040:	eb 2f                	jmp    c0107071 <thread_fork+0xe4>
c0107042:	8b 45 10             	mov    0x10(%ebp),%eax
            return ENOMEM;
        }
    }

    int result = proc_addthread(proc ? proc : thisthread->proc, newthread);
c0107045:	85 c0                	test   %eax,%eax
c0107047:	75 12                	jne    c010705b <thread_fork+0xce>
c0107049:	e8 f4 b4 ff ff       	call   c0102542 <cpunum>
c010704e:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107055:	8b 40 08             	mov    0x8(%eax),%eax
c0107058:	8b 40 20             	mov    0x20(%eax),%eax
c010705b:	51                   	push   %ecx
c010705c:	51                   	push   %ecx
c010705d:	53                   	push   %ebx
c010705e:	50                   	push   %eax
c010705f:	e8 5f 19 00 00       	call   c01089c3 <proc_addthread>
c0107064:	89 c6                	mov    %eax,%esi
    if (result) {
c0107066:	83 c4 10             	add    $0x10,%esp
c0107069:	85 c0                	test   %eax,%eax
c010706b:	74 0e                	je     c010707b <thread_fork+0xee>
        thread_destroy(newthread);
c010706d:	83 ec 0c             	sub    $0xc,%esp
c0107070:	53                   	push   %ebx
c0107071:	e8 92 fb ff ff       	call   c0106c08 <thread_destroy>
        return result;
c0107076:	83 c4 10             	add    $0x10,%esp
c0107079:	eb 1e                	jmp    c0107099 <thread_fork+0x10c>
    }

    switchframe_init(newthread, entrypoint, data1, data2);
c010707b:	ff 75 1c             	pushl  0x1c(%ebp)
c010707e:	ff 75 18             	pushl  0x18(%ebp)
c0107081:	ff 75 14             	pushl  0x14(%ebp)
c0107084:	53                   	push   %ebx
c0107085:	e8 75 0d 00 00       	call   c0107dff <switchframe_init>

    thread_make_runnable(newthread, false);
c010708a:	58                   	pop    %eax
c010708b:	5a                   	pop    %edx
c010708c:	6a 00                	push   $0x0
c010708e:	53                   	push   %ebx
c010708f:	e8 3c fe ff ff       	call   c0106ed0 <thread_make_runnable>

    return 0;
c0107094:	83 c4 10             	add    $0x10,%esp
c0107097:	31 f6                	xor    %esi,%esi
}
c0107099:	89 f0                	mov    %esi,%eax
c010709b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010709e:	5b                   	pop    %ebx
c010709f:	5e                   	pop    %esi
c01070a0:	5f                   	pop    %edi
c01070a1:	5d                   	pop    %ebp
c01070a2:	c3                   	ret    

c01070a3 <thread_switch>:
thread_yield(void) {
    thread_switch(S_READY, NULL, NULL);
}

void
thread_switch(threadstate_t newstate, struct wchan* wc, struct spinlock* lk) {
c01070a3:	55                   	push   %ebp
c01070a4:	89 e5                	mov    %esp,%ebp
c01070a6:	57                   	push   %edi
c01070a7:	56                   	push   %esi
c01070a8:	53                   	push   %ebx
c01070a9:	83 ec 1c             	sub    $0x1c,%esp
c01070ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01070af:	8b 75 0c             	mov    0xc(%ebp),%esi
c01070b2:	8b 7d 10             	mov    0x10(%ebp),%edi
    assert(thiscpu->thread == thisthread);
c01070b5:	e8 88 b4 ff ff       	call   c0102542 <cpunum>
c01070ba:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01070c1:	8b 50 08             	mov    0x8(%eax),%edx
c01070c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01070c7:	e8 76 b4 ff ff       	call   c0102542 <cpunum>
c01070cc:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01070d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01070d6:	3b 50 08             	cmp    0x8(%eax),%edx
c01070d9:	74 2b                	je     c0107106 <thread_switch+0x63>
c01070db:	83 ec 0c             	sub    $0xc,%esp
c01070de:	68 38 c3 10 c0       	push   $0xc010c338
c01070e3:	68 a0 00 00 00       	push   $0xa0
c01070e8:	68 25 c1 10 c0       	push   $0xc010c125
c01070ed:	68 28 c2 10 c0       	push   $0xc010c228
c01070f2:	68 95 a9 10 c0       	push   $0xc010a995
c01070f7:	e8 c8 cc ff ff       	call   c0103dc4 <print>
c01070fc:	83 c4 20             	add    $0x20,%esp
c01070ff:	e8 46 9d ff ff       	call   c0100e4a <backtrace>
c0107104:	fa                   	cli    
c0107105:	f4                   	hlt    
    assert(thisthread->cpu == thiscpu->self);
c0107106:	e8 37 b4 ff ff       	call   c0102542 <cpunum>
c010710b:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107112:	8b 40 08             	mov    0x8(%eax),%eax
c0107115:	8b 50 1c             	mov    0x1c(%eax),%edx
c0107118:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010711b:	e8 22 b4 ff ff       	call   c0102542 <cpunum>
c0107120:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107127:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010712a:	3b 10                	cmp    (%eax),%edx
c010712c:	74 2b                	je     c0107159 <thread_switch+0xb6>
c010712e:	83 ec 0c             	sub    $0xc,%esp
c0107131:	68 38 c3 10 c0       	push   $0xc010c338
c0107136:	68 a1 00 00 00       	push   $0xa1
c010713b:	68 25 c1 10 c0       	push   $0xc010c125
c0107140:	68 46 c2 10 c0       	push   $0xc010c246
c0107145:	68 95 a9 10 c0       	push   $0xc010a995
c010714a:	e8 75 cc ff ff       	call   c0103dc4 <print>
c010714f:	83 c4 20             	add    $0x20,%esp
c0107152:	e8 f3 9c ff ff       	call   c0100e4a <backtrace>
c0107157:	fa                   	cli    
c0107158:	f4                   	hlt    

    thread_exorcise();
c0107159:	e8 85 fb ff ff       	call   c0106ce3 <thread_exorcise>

    /*
     * If we're idle, return without doing anything. thisthread happens
     * when the timer interrupt interrupts the idle loop.
     */
    if (thiscpu->status == CPU_IDLE)
c010715e:	e8 df b3 ff ff       	call   c0102542 <cpunum>
c0107163:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010716a:	8a 40 05             	mov    0x5(%eax),%al
c010716d:	3c 03                	cmp    $0x3,%al
c010716f:	0f 84 1e 02 00 00    	je     c0107393 <thread_switch+0x2f0>
        return;

    // struct thread* thisthread = thisthread;

    /* Check the stack guard band. */
    thread_checkstack(thisthread);
c0107175:	e8 c8 b3 ff ff       	call   c0102542 <cpunum>
c010717a:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107181:	8b 40 08             	mov    0x8(%eax),%eax
c0107184:	83 c0 28             	add    $0x28,%eax
c0107187:	e8 c5 f8 ff ff       	call   c0106a51 <thread_checkstack.isra.0>

    spinlock_acquire(&thiscpu->active_threads_lock);
c010718c:	e8 b1 b3 ff ff       	call   c0102542 <cpunum>
c0107191:	83 ec 0c             	sub    $0xc,%esp
c0107194:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010719b:	83 c0 48             	add    $0x48,%eax
c010719e:	50                   	push   %eax
c010719f:	e8 53 c1 ff ff       	call   c01032f7 <spinlock_acquire>

    switch (newstate) {
c01071a4:	83 c4 10             	add    $0x10,%esp
c01071a7:	83 fb 01             	cmp    $0x1,%ebx
c01071aa:	74 72                	je     c010721e <thread_switch+0x17b>
c01071ac:	72 54                	jb     c0107202 <thread_switch+0x15f>
c01071ae:	83 fb 02             	cmp    $0x2,%ebx
c01071b1:	0f 84 be 00 00 00    	je     c0107275 <thread_switch+0x1d2>
c01071b7:	83 fb 03             	cmp    $0x3,%ebx
c01071ba:	0f 85 ee 00 00 00    	jne    c01072ae <thread_switch+0x20b>
            thisthread->wchan_name = wc->wc_name;
            threadlist_addtail(&wc->wc_threads, thisthread);
            spinlock_release(lk);
            break;
        case S_ZOMBIE:
            thisthread->wchan_name = "ZOMBIE";
c01071c0:	e8 7d b3 ff ff       	call   c0102542 <cpunum>
c01071c5:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01071cc:	8b 40 08             	mov    0x8(%eax),%eax
c01071cf:	c7 40 14 a5 c1 10 c0 	movl   $0xc010c1a5,0x14(%eax)
            threadlist_addtail(&thiscpu->zombie_threads, thisthread);
c01071d6:	e8 67 b3 ff ff       	call   c0102542 <cpunum>
c01071db:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01071e2:	8b 70 08             	mov    0x8(%eax),%esi
c01071e5:	e8 58 b3 ff ff       	call   c0102542 <cpunum>
c01071ea:	52                   	push   %edx
c01071eb:	52                   	push   %edx
c01071ec:	56                   	push   %esi
c01071ed:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01071f4:	83 c0 10             	add    $0x10,%eax
c01071f7:	50                   	push   %eax
c01071f8:	e8 67 09 00 00       	call   c0107b64 <threadlist_addtail>
c01071fd:	e9 a9 00 00 00       	jmp    c01072ab <thread_switch+0x208>

    spinlock_acquire(&thiscpu->active_threads_lock);

    switch (newstate) {
        case S_RUN:
            panic("Illegal S_RUN in thread_switch\n");
c0107202:	68 67 c2 10 c0       	push   $0xc010c267
c0107207:	68 38 c3 10 c0       	push   $0xc010c338
c010720c:	68 b5 00 00 00       	push   $0xb5
c0107211:	68 25 c1 10 c0       	push   $0xc010c125
c0107216:	e8 27 c7 ff ff       	call   c0103942 <_panic>
c010721b:	83 c4 10             	add    $0x10,%esp
        case S_READY: {
            // if thisthread is the only thread, just return
            if (threadlist_isempty(&thiscpu->active_threads)) {
c010721e:	e8 1f b3 ff ff       	call   c0102542 <cpunum>
c0107223:	83 ec 0c             	sub    $0xc,%esp
c0107226:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010722d:	83 c0 2c             	add    $0x2c,%eax
c0107230:	50                   	push   %eax
c0107231:	e8 c5 06 00 00       	call   c01078fb <threadlist_isempty>
c0107236:	83 c4 10             	add    $0x10,%esp
c0107239:	84 c0                	test   %al,%al
c010723b:	74 1e                	je     c010725b <thread_switch+0x1b8>
                spinlock_release(&thiscpu->active_threads_lock);
c010723d:	e8 00 b3 ff ff       	call   c0102542 <cpunum>
c0107242:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107249:	83 c0 48             	add    $0x48,%eax
c010724c:	89 45 08             	mov    %eax,0x8(%ebp)
    spinlock_release(&thiscpu->active_threads_lock);

    switchframe_switch(next->context);

    panic("switchframe_switch returned");
}
c010724f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0107252:	5b                   	pop    %ebx
c0107253:	5e                   	pop    %esi
c0107254:	5f                   	pop    %edi
c0107255:	5d                   	pop    %ebp
        case S_RUN:
            panic("Illegal S_RUN in thread_switch\n");
        case S_READY: {
            // if thisthread is the only thread, just return
            if (threadlist_isempty(&thiscpu->active_threads)) {
                spinlock_release(&thiscpu->active_threads_lock);
c0107256:	e9 44 c1 ff ff       	jmp    c010339f <spinlock_release>
                return;
            }
            thread_make_runnable(thisthread, true /* holding_lock */);
c010725b:	e8 e2 b2 ff ff       	call   c0102542 <cpunum>
c0107260:	56                   	push   %esi
c0107261:	56                   	push   %esi
c0107262:	6a 01                	push   $0x1
c0107264:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010726b:	ff 70 08             	pushl  0x8(%eax)
c010726e:	e8 5d fc ff ff       	call   c0106ed0 <thread_make_runnable>
c0107273:	eb 36                	jmp    c01072ab <thread_switch+0x208>
            break;
        }
        case S_SLEEP:
            thisthread->wchan_name = wc->wc_name;
c0107275:	e8 c8 b2 ff ff       	call   c0102542 <cpunum>
c010727a:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107281:	8b 40 08             	mov    0x8(%eax),%eax
c0107284:	8b 16                	mov    (%esi),%edx
c0107286:	89 50 14             	mov    %edx,0x14(%eax)
            threadlist_addtail(&wc->wc_threads, thisthread);
c0107289:	e8 b4 b2 ff ff       	call   c0102542 <cpunum>
c010728e:	51                   	push   %ecx
c010728f:	51                   	push   %ecx
c0107290:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107297:	ff 70 08             	pushl  0x8(%eax)
c010729a:	83 c6 04             	add    $0x4,%esi
c010729d:	56                   	push   %esi
c010729e:	e8 c1 08 00 00       	call   c0107b64 <threadlist_addtail>
            spinlock_release(lk);
c01072a3:	89 3c 24             	mov    %edi,(%esp)
c01072a6:	e8 f4 c0 ff ff       	call   c010339f <spinlock_release>
            break;
        case S_ZOMBIE:
            thisthread->wchan_name = "ZOMBIE";
            threadlist_addtail(&thiscpu->zombie_threads, thisthread);
            break;
c01072ab:	83 c4 10             	add    $0x10,%esp
    }
    thisthread->state = newstate;
c01072ae:	e8 8f b2 ff ff       	call   c0102542 <cpunum>
c01072b3:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01072ba:	8b 40 08             	mov    0x8(%eax),%eax
c01072bd:	89 58 18             	mov    %ebx,0x18(%eax)

    thiscpu->status = CPU_IDLE;
c01072c0:	e8 7d b2 ff ff       	call   c0102542 <cpunum>
c01072c5:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01072cc:	c6 40 05 03          	movb   $0x3,0x5(%eax)
    struct thread* next = NULL;
    do {
        next = threadlist_remhead(&thiscpu->active_threads);
c01072d0:	e8 6d b2 ff ff       	call   c0102542 <cpunum>
c01072d5:	83 ec 0c             	sub    $0xc,%esp
c01072d8:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01072df:	83 c0 2c             	add    $0x2c,%eax
c01072e2:	50                   	push   %eax
c01072e3:	e8 f9 08 00 00       	call   c0107be1 <threadlist_remhead>
c01072e8:	89 c3                	mov    %eax,%ebx
        if (next == NULL) {
c01072ea:	83 c4 10             	add    $0x10,%esp
c01072ed:	85 c0                	test   %eax,%eax
c01072ef:	75 39                	jne    c010732a <thread_switch+0x287>
            spinlock_release(&thiscpu->active_threads_lock);
c01072f1:	e8 4c b2 ff ff       	call   c0102542 <cpunum>
c01072f6:	83 ec 0c             	sub    $0xc,%esp
c01072f9:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107300:	83 c0 48             	add    $0x48,%eax
c0107303:	50                   	push   %eax
c0107304:	e8 96 c0 ff ff       	call   c010339f <spinlock_release>
            // print("\n\n!\n\n");
            cpu_idle();
c0107309:	e8 4f 10 00 00       	call   c010835d <cpu_idle>
            spinlock_acquire(&thiscpu->active_threads_lock);
c010730e:	e8 2f b2 ff ff       	call   c0102542 <cpunum>
c0107313:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010731a:	83 c0 48             	add    $0x48,%eax
c010731d:	89 04 24             	mov    %eax,(%esp)
c0107320:	e8 d2 bf ff ff       	call   c01032f7 <spinlock_acquire>
c0107325:	83 c4 10             	add    $0x10,%esp
c0107328:	eb a6                	jmp    c01072d0 <thread_switch+0x22d>
        }
    } while (next == NULL);

    thiscpu->status = CPU_STARTED;
c010732a:	e8 13 b2 ff ff       	call   c0102542 <cpunum>
c010732f:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107336:	c6 40 05 01          	movb   $0x1,0x5(%eax)
    next->wchan_name = NULL;
c010733a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    next->state = S_RUN;
c0107341:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    thisthread = next;
c0107348:	e8 f5 b1 ff ff       	call   c0102542 <cpunum>
c010734d:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107354:	89 58 08             	mov    %ebx,0x8(%eax)

    // lcr3(PADDR(thisthread->page_directory));

    spinlock_release(&thiscpu->active_threads_lock);
c0107357:	e8 e6 b1 ff ff       	call   c0102542 <cpunum>
c010735c:	83 ec 0c             	sub    $0xc,%esp
c010735f:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107366:	83 c0 48             	add    $0x48,%eax
c0107369:	50                   	push   %eax
c010736a:	e8 30 c0 ff ff       	call   c010339f <spinlock_release>

    switchframe_switch(next->context);
c010736f:	58                   	pop    %eax
c0107370:	ff 33                	pushl  (%ebx)
c0107372:	e8 26 0a 00 00       	call   c0107d9d <switchframe_switch>

    panic("switchframe_switch returned");
c0107377:	68 87 c2 10 c0       	push   $0xc010c287
c010737c:	68 38 c3 10 c0       	push   $0xc010c338
c0107381:	68 e2 00 00 00       	push   $0xe2
c0107386:	68 25 c1 10 c0       	push   $0xc010c125
c010738b:	e8 b2 c5 ff ff       	call   c0103942 <_panic>
c0107390:	83 c4 20             	add    $0x20,%esp
}
c0107393:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0107396:	5b                   	pop    %ebx
c0107397:	5e                   	pop    %esi
c0107398:	5f                   	pop    %edi
c0107399:	5d                   	pop    %ebp
c010739a:	c3                   	ret    

c010739b <thread_yield>:

    thread_exit(ret);
}

void
thread_yield(void) {
c010739b:	55                   	push   %ebp
c010739c:	89 e5                	mov    %esp,%ebp
c010739e:	83 ec 0c             	sub    $0xc,%esp
    thread_switch(S_READY, NULL, NULL);
c01073a1:	6a 00                	push   $0x0
c01073a3:	6a 00                	push   $0x0
c01073a5:	6a 01                	push   $0x1
c01073a7:	e8 f7 fc ff ff       	call   c01070a3 <thread_switch>
}
c01073ac:	83 c4 10             	add    $0x10,%esp
c01073af:	c9                   	leave  
c01073b0:	c3                   	ret    

c01073b1 <thread_exit>:

    panic("switchframe_switch returned");
}

void
thread_exit(int ret) {
c01073b1:	55                   	push   %ebp
c01073b2:	89 e5                	mov    %esp,%ebp
c01073b4:	83 ec 08             	sub    $0x8,%esp
    thisthread->rval = ret;
c01073b7:	e8 86 b1 ff ff       	call   c0102542 <cpunum>
c01073bc:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01073c3:	8b 40 08             	mov    0x8(%eax),%eax
c01073c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01073c9:	89 50 30             	mov    %edx,0x30(%eax)

    if(thisthread->parent != NULL) {
c01073cc:	e8 71 b1 ff ff       	call   c0102542 <cpunum>
c01073d1:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01073d8:	8b 40 08             	mov    0x8(%eax),%eax
c01073db:	83 78 34 00          	cmpl   $0x0,0x34(%eax)
c01073df:	0f 84 a7 00 00 00    	je     c010748c <thread_exit+0xdb>
        V(thisthread->psem);
c01073e5:	e8 58 b1 ff ff       	call   c0102542 <cpunum>
c01073ea:	83 ec 0c             	sub    $0xc,%esp
c01073ed:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01073f4:	8b 40 08             	mov    0x8(%eax),%eax
c01073f7:	ff 70 38             	pushl  0x38(%eax)
c01073fa:	e8 c4 bd ff ff       	call   c01031c3 <V>
        P(thisthread->csem);
c01073ff:	e8 3e b1 ff ff       	call   c0102542 <cpunum>
c0107404:	5a                   	pop    %edx
c0107405:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010740c:	8b 40 08             	mov    0x8(%eax),%eax
c010740f:	ff 70 3c             	pushl  0x3c(%eax)
c0107412:	e8 d4 bc ff ff       	call   c01030eb <P>

        semaphore_destroy(thisthread->psem);
c0107417:	e8 26 b1 ff ff       	call   c0102542 <cpunum>
c010741c:	59                   	pop    %ecx
c010741d:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107424:	8b 40 08             	mov    0x8(%eax),%eax
c0107427:	ff 70 38             	pushl  0x38(%eax)
c010742a:	e8 5c bc ff ff       	call   c010308b <semaphore_destroy>
        semaphore_destroy(thisthread->csem);
c010742f:	e8 0e b1 ff ff       	call   c0102542 <cpunum>
c0107434:	5a                   	pop    %edx
c0107435:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010743c:	8b 40 08             	mov    0x8(%eax),%eax
c010743f:	ff 70 3c             	pushl  0x3c(%eax)
c0107442:	e8 44 bc ff ff       	call   c010308b <semaphore_destroy>

        thisthread->psem = NULL;
c0107447:	e8 f6 b0 ff ff       	call   c0102542 <cpunum>
c010744c:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107453:	8b 40 08             	mov    0x8(%eax),%eax
c0107456:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
        thisthread->csem = NULL;
c010745d:	e8 e0 b0 ff ff       	call   c0102542 <cpunum>
c0107462:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107469:	8b 40 08             	mov    0x8(%eax),%eax
c010746c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)

        thisthread->parent = NULL;
c0107473:	e8 ca b0 ff ff       	call   c0102542 <cpunum>
c0107478:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010747f:	8b 40 08             	mov    0x8(%eax),%eax
c0107482:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
c0107489:	83 c4 10             	add    $0x10,%esp
    }

    // struct thread* thisthread = thisthread;

    proc_remthread(thisthread);
c010748c:	e8 b1 b0 ff ff       	call   c0102542 <cpunum>
c0107491:	83 ec 0c             	sub    $0xc,%esp
c0107494:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010749b:	ff 70 08             	pushl  0x8(%eax)
c010749e:	e8 97 16 00 00       	call   c0108b3a <proc_remthread>
    assert(thisthread->proc == NULL);
c01074a3:	e8 9a b0 ff ff       	call   c0102542 <cpunum>
c01074a8:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01074af:	8b 40 08             	mov    0x8(%eax),%eax
c01074b2:	83 c4 10             	add    $0x10,%esp
c01074b5:	83 78 20 00          	cmpl   $0x0,0x20(%eax)
c01074b9:	74 2b                	je     c01074e6 <thread_exit+0x135>
c01074bb:	83 ec 0c             	sub    $0xc,%esp
c01074be:	68 2c c3 10 c0       	push   $0xc010c32c
c01074c3:	68 f9 00 00 00       	push   $0xf9
c01074c8:	68 25 c1 10 c0       	push   $0xc010c125
c01074cd:	68 a3 c2 10 c0       	push   $0xc010c2a3
c01074d2:	68 95 a9 10 c0       	push   $0xc010a995
c01074d7:	e8 e8 c8 ff ff       	call   c0103dc4 <print>
c01074dc:	83 c4 20             	add    $0x20,%esp
c01074df:	e8 66 99 ff ff       	call   c0100e4a <backtrace>
c01074e4:	fa                   	cli    
c01074e5:	f4                   	hlt    

    /* Interrupts off on thisthread processor */
    // cli();
    thread_switch(S_ZOMBIE, NULL, NULL);
c01074e6:	50                   	push   %eax
c01074e7:	6a 00                	push   $0x0
c01074e9:	6a 00                	push   $0x0
c01074eb:	6a 03                	push   $0x3
c01074ed:	e8 b1 fb ff ff       	call   c01070a3 <thread_switch>
    panic("thread_switch returned\n");
c01074f2:	68 bc c2 10 c0       	push   $0xc010c2bc
c01074f7:	68 2c c3 10 c0       	push   $0xc010c32c
c01074fc:	68 fe 00 00 00       	push   $0xfe
c0107501:	68 25 c1 10 c0       	push   $0xc010c125
c0107506:	e8 37 c4 ff ff       	call   c0103942 <_panic>
}
c010750b:	83 c4 20             	add    $0x20,%esp
c010750e:	c9                   	leave  
c010750f:	c3                   	ret    

c0107510 <thread_startup>:
    return 0;
}

void
thread_startup(int (*entrypoint)(void *data1, unsigned long data2),
               void *data1, unsigned long data2) {
c0107510:	55                   	push   %ebp
c0107511:	89 e5                	mov    %esp,%ebp
c0107513:	57                   	push   %edi
c0107514:	56                   	push   %esi
c0107515:	53                   	push   %ebx
c0107516:	83 ec 0c             	sub    $0xc,%esp
c0107519:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010751c:	8b 75 0c             	mov    0xc(%ebp),%esi
c010751f:	8b 7d 10             	mov    0x10(%ebp),%edi
    // print("%s:%d\n", __func__, __LINE__);
    assert(thisthread != NULL);
c0107522:	e8 1b b0 ff ff       	call   c0102542 <cpunum>
c0107527:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010752e:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
c0107532:	75 28                	jne    c010755c <thread_startup+0x4c>
c0107534:	83 ec 0c             	sub    $0xc,%esp
c0107537:	68 48 c3 10 c0       	push   $0xc010c348
c010753c:	6a 77                	push   $0x77
c010753e:	68 25 c1 10 c0       	push   $0xc010c125
c0107543:	68 d4 c2 10 c0       	push   $0xc010c2d4
c0107548:	68 95 a9 10 c0       	push   $0xc010a995
c010754d:	e8 72 c8 ff ff       	call   c0103dc4 <print>
c0107552:	83 c4 20             	add    $0x20,%esp
c0107555:	e8 f0 98 ff ff       	call   c0100e4a <backtrace>
c010755a:	fa                   	cli    
c010755b:	f4                   	hlt    

    // spinlock_acquire(&thiscpu->active_threads_lock);

    /* Clear the wait channel and set the thread state. */
    thisthread->wchan_name = NULL;
c010755c:	e8 e1 af ff ff       	call   c0102542 <cpunum>
c0107561:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0107568:	8b 40 08             	mov    0x8(%eax),%eax
c010756b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    thisthread->state = S_RUN;
c0107572:	e8 cb af ff ff       	call   c0102542 <cpunum>
c0107577:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010757e:	8b 40 08             	mov    0x8(%eax),%eax
c0107581:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

    thread_exorcise();
c0107588:	e8 56 f7 ff ff       	call   c0106ce3 <thread_exorcise>
//         for (i = 0; i < n; i++)
//             thread_yield();
//     }
// #endif

    int ret = entrypoint(data1, data2);
c010758d:	50                   	push   %eax
c010758e:	50                   	push   %eax
c010758f:	57                   	push   %edi
c0107590:	56                   	push   %esi
c0107591:	ff d3                	call   *%ebx

    thread_exit(ret);
c0107593:	83 c4 10             	add    $0x10,%esp
c0107596:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0107599:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010759c:	5b                   	pop    %ebx
c010759d:	5e                   	pop    %esi
c010759e:	5f                   	pop    %edi
c010759f:	5d                   	pop    %ebp
//     }
// #endif

    int ret = entrypoint(data1, data2);

    thread_exit(ret);
c01075a0:	e9 0c fe ff ff       	jmp    c01073b1 <thread_exit>

c01075a5 <threadlist_insertafternode>:
/*
 * Do insertion. Doesn't update tl_count.
 */
static
void
threadlist_insertafternode(struct threadlistnode* onlist, struct thread* t) {
c01075a5:	55                   	push   %ebp
c01075a6:	89 e5                	mov    %esp,%ebp
c01075a8:	57                   	push   %edi
c01075a9:	56                   	push   %esi
c01075aa:	53                   	push   %ebx
c01075ab:	83 ec 0c             	sub    $0xc,%esp
c01075ae:	89 c6                	mov    %eax,%esi
c01075b0:	89 d3                	mov    %edx,%ebx
    struct threadlistnode* addee;

    addee = &t->listnode;
c01075b2:	8d 7a 04             	lea    0x4(%edx),%edi

    assert(addee->tln_prev == NULL);
c01075b5:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
c01075b9:	74 28                	je     c01075e3 <threadlist_insertafternode+0x3e>
c01075bb:	83 ec 0c             	sub    $0xc,%esp
c01075be:	68 c0 c5 10 c0       	push   $0xc010c5c0
c01075c3:	6a 49                	push   $0x49
c01075c5:	68 7a c3 10 c0       	push   $0xc010c37a
c01075ca:	68 8e c3 10 c0       	push   $0xc010c38e
c01075cf:	68 95 a9 10 c0       	push   $0xc010a995
c01075d4:	e8 eb c7 ff ff       	call   c0103dc4 <print>
c01075d9:	83 c4 20             	add    $0x20,%esp
c01075dc:	e8 69 98 ff ff       	call   c0100e4a <backtrace>
c01075e1:	fa                   	cli    
c01075e2:	f4                   	hlt    
    assert(addee->tln_next == NULL);
c01075e3:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c01075e7:	74 28                	je     c0107611 <threadlist_insertafternode+0x6c>
c01075e9:	83 ec 0c             	sub    $0xc,%esp
c01075ec:	68 c0 c5 10 c0       	push   $0xc010c5c0
c01075f1:	6a 4a                	push   $0x4a
c01075f3:	68 7a c3 10 c0       	push   $0xc010c37a
c01075f8:	68 a6 c3 10 c0       	push   $0xc010c3a6
c01075fd:	68 95 a9 10 c0       	push   $0xc010a995
c0107602:	e8 bd c7 ff ff       	call   c0103dc4 <print>
c0107607:	83 c4 20             	add    $0x20,%esp
c010760a:	e8 3b 98 ff ff       	call   c0100e4a <backtrace>
c010760f:	fa                   	cli    
c0107610:	f4                   	hlt    

    addee->tln_prev = onlist;
c0107611:	89 73 04             	mov    %esi,0x4(%ebx)
    addee->tln_next = onlist->tln_next;
c0107614:	8b 46 04             	mov    0x4(%esi),%eax
c0107617:	89 43 08             	mov    %eax,0x8(%ebx)
    addee->tln_prev->tln_next = addee;
c010761a:	89 7e 04             	mov    %edi,0x4(%esi)
    addee->tln_next->tln_prev = addee;
c010761d:	8b 43 08             	mov    0x8(%ebx),%eax
c0107620:	89 38                	mov    %edi,(%eax)
}
c0107622:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0107625:	5b                   	pop    %ebx
c0107626:	5e                   	pop    %esi
c0107627:	5f                   	pop    %edi
c0107628:	5d                   	pop    %ebp
c0107629:	c3                   	ret    

c010762a <threadlist_insertbeforenode>:
/*
 * Do insertion. Doesn't update tl_count.
 */
static
void
threadlist_insertbeforenode(struct thread* t, struct threadlistnode* onlist) {
c010762a:	55                   	push   %ebp
c010762b:	89 e5                	mov    %esp,%ebp
c010762d:	57                   	push   %edi
c010762e:	56                   	push   %esi
c010762f:	53                   	push   %ebx
c0107630:	83 ec 0c             	sub    $0xc,%esp
c0107633:	89 c3                	mov    %eax,%ebx
c0107635:	89 d7                	mov    %edx,%edi
    struct threadlistnode* addee;

    addee = &t->listnode;
c0107637:	8d 70 04             	lea    0x4(%eax),%esi

    assert(addee->tln_prev == NULL);
c010763a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
c010763e:	74 28                	je     c0107668 <threadlist_insertbeforenode+0x3e>
c0107640:	83 ec 0c             	sub    $0xc,%esp
c0107643:	68 90 c5 10 c0       	push   $0xc010c590
c0107648:	6a 5c                	push   $0x5c
c010764a:	68 7a c3 10 c0       	push   $0xc010c37a
c010764f:	68 8e c3 10 c0       	push   $0xc010c38e
c0107654:	68 95 a9 10 c0       	push   $0xc010a995
c0107659:	e8 66 c7 ff ff       	call   c0103dc4 <print>
c010765e:	83 c4 20             	add    $0x20,%esp
c0107661:	e8 e4 97 ff ff       	call   c0100e4a <backtrace>
c0107666:	fa                   	cli    
c0107667:	f4                   	hlt    
    assert(addee->tln_next == NULL);
c0107668:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c010766c:	74 28                	je     c0107696 <threadlist_insertbeforenode+0x6c>
c010766e:	83 ec 0c             	sub    $0xc,%esp
c0107671:	68 90 c5 10 c0       	push   $0xc010c590
c0107676:	6a 5d                	push   $0x5d
c0107678:	68 7a c3 10 c0       	push   $0xc010c37a
c010767d:	68 a6 c3 10 c0       	push   $0xc010c3a6
c0107682:	68 95 a9 10 c0       	push   $0xc010a995
c0107687:	e8 38 c7 ff ff       	call   c0103dc4 <print>
c010768c:	83 c4 20             	add    $0x20,%esp
c010768f:	e8 b6 97 ff ff       	call   c0100e4a <backtrace>
c0107694:	fa                   	cli    
c0107695:	f4                   	hlt    

    addee->tln_prev = onlist->tln_prev;
c0107696:	8b 07                	mov    (%edi),%eax
c0107698:	89 43 04             	mov    %eax,0x4(%ebx)
    addee->tln_next = onlist;
c010769b:	89 7b 08             	mov    %edi,0x8(%ebx)
    addee->tln_prev->tln_next = addee;
c010769e:	89 70 04             	mov    %esi,0x4(%eax)
    addee->tln_next->tln_prev = addee;
c01076a1:	8b 43 08             	mov    0x8(%ebx),%eax
c01076a4:	89 30                	mov    %esi,(%eax)
}
c01076a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01076a9:	5b                   	pop    %ebx
c01076aa:	5e                   	pop    %esi
c01076ab:	5f                   	pop    %edi
c01076ac:	5d                   	pop    %ebp
c01076ad:	c3                   	ret    

c01076ae <threadlist_removenode>:
/*
 * Do removal. Doesn't update tl_count.
 */
static
void
threadlist_removenode(struct threadlistnode* tln) {
c01076ae:	55                   	push   %ebp
c01076af:	89 e5                	mov    %esp,%ebp
c01076b1:	53                   	push   %ebx
c01076b2:	52                   	push   %edx
c01076b3:	89 c3                	mov    %eax,%ebx
    assert(tln != NULL);
c01076b5:	85 c0                	test   %eax,%eax
c01076b7:	75 28                	jne    c01076e1 <threadlist_removenode+0x33>
c01076b9:	83 ec 0c             	sub    $0xc,%esp
c01076bc:	68 64 c5 10 c0       	push   $0xc010c564
c01076c1:	6a 6b                	push   $0x6b
c01076c3:	68 7a c3 10 c0       	push   $0xc010c37a
c01076c8:	68 be c3 10 c0       	push   $0xc010c3be
c01076cd:	68 95 a9 10 c0       	push   $0xc010a995
c01076d2:	e8 ed c6 ff ff       	call   c0103dc4 <print>
c01076d7:	83 c4 20             	add    $0x20,%esp
c01076da:	e8 6b 97 ff ff       	call   c0100e4a <backtrace>
c01076df:	fa                   	cli    
c01076e0:	f4                   	hlt    
    assert(tln->tln_prev != NULL);
c01076e1:	83 3b 00             	cmpl   $0x0,(%ebx)
c01076e4:	75 28                	jne    c010770e <threadlist_removenode+0x60>
c01076e6:	83 ec 0c             	sub    $0xc,%esp
c01076e9:	68 64 c5 10 c0       	push   $0xc010c564
c01076ee:	6a 6c                	push   $0x6c
c01076f0:	68 7a c3 10 c0       	push   $0xc010c37a
c01076f5:	68 ca c3 10 c0       	push   $0xc010c3ca
c01076fa:	68 95 a9 10 c0       	push   $0xc010a995
c01076ff:	e8 c0 c6 ff ff       	call   c0103dc4 <print>
c0107704:	83 c4 20             	add    $0x20,%esp
c0107707:	e8 3e 97 ff ff       	call   c0100e4a <backtrace>
c010770c:	fa                   	cli    
c010770d:	f4                   	hlt    
    assert(tln->tln_next != NULL);
c010770e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
c0107712:	75 28                	jne    c010773c <threadlist_removenode+0x8e>
c0107714:	83 ec 0c             	sub    $0xc,%esp
c0107717:	68 64 c5 10 c0       	push   $0xc010c564
c010771c:	6a 6d                	push   $0x6d
c010771e:	68 7a c3 10 c0       	push   $0xc010c37a
c0107723:	68 e0 c3 10 c0       	push   $0xc010c3e0
c0107728:	68 95 a9 10 c0       	push   $0xc010a995
c010772d:	e8 92 c6 ff ff       	call   c0103dc4 <print>
c0107732:	83 c4 20             	add    $0x20,%esp
c0107735:	e8 10 97 ff ff       	call   c0100e4a <backtrace>
c010773a:	fa                   	cli    
c010773b:	f4                   	hlt    

    tln->tln_prev->tln_next = tln->tln_next;
c010773c:	8b 03                	mov    (%ebx),%eax
c010773e:	8b 53 04             	mov    0x4(%ebx),%edx
c0107741:	89 50 04             	mov    %edx,0x4(%eax)
    tln->tln_next->tln_prev = tln->tln_prev;
c0107744:	8b 53 04             	mov    0x4(%ebx),%edx
c0107747:	89 02                	mov    %eax,(%edx)
    tln->tln_prev = NULL;
c0107749:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    tln->tln_next = NULL;
c010774f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
c0107756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107759:	c9                   	leave  
c010775a:	c3                   	ret    

c010775b <threadlistnode_init>:
#include <lib.h>
#include <thread.h>
#include <threadlist.h>

void
threadlistnode_init(struct threadlistnode* tln, struct thread* t) {
c010775b:	55                   	push   %ebp
c010775c:	89 e5                	mov    %esp,%ebp
c010775e:	56                   	push   %esi
c010775f:	53                   	push   %ebx
c0107760:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0107763:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(tln != NULL);
c0107766:	85 db                	test   %ebx,%ebx
c0107768:	75 28                	jne    c0107792 <threadlistnode_init+0x37>
c010776a:	83 ec 0c             	sub    $0xc,%esp
c010776d:	68 40 c6 10 c0       	push   $0xc010c640
c0107772:	6a 07                	push   $0x7
c0107774:	68 7a c3 10 c0       	push   $0xc010c37a
c0107779:	68 be c3 10 c0       	push   $0xc010c3be
c010777e:	68 95 a9 10 c0       	push   $0xc010a995
c0107783:	e8 3c c6 ff ff       	call   c0103dc4 <print>
c0107788:	83 c4 20             	add    $0x20,%esp
c010778b:	e8 ba 96 ff ff       	call   c0100e4a <backtrace>
c0107790:	fa                   	cli    
c0107791:	f4                   	hlt    
    assert(t != NULL);
c0107792:	85 f6                	test   %esi,%esi
c0107794:	75 28                	jne    c01077be <threadlistnode_init+0x63>
c0107796:	83 ec 0c             	sub    $0xc,%esp
c0107799:	68 40 c6 10 c0       	push   $0xc010c640
c010779e:	6a 08                	push   $0x8
c01077a0:	68 7a c3 10 c0       	push   $0xc010c37a
c01077a5:	68 c9 c1 10 c0       	push   $0xc010c1c9
c01077aa:	68 95 a9 10 c0       	push   $0xc010a995
c01077af:	e8 10 c6 ff ff       	call   c0103dc4 <print>
c01077b4:	83 c4 20             	add    $0x20,%esp
c01077b7:	e8 8e 96 ff ff       	call   c0100e4a <backtrace>
c01077bc:	fa                   	cli    
c01077bd:	f4                   	hlt    

    tln->tln_next = NULL;
c01077be:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    tln->tln_prev = NULL;
c01077c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    tln->tln_self = t;
c01077cb:	89 73 08             	mov    %esi,0x8(%ebx)
}
c01077ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01077d1:	5b                   	pop    %ebx
c01077d2:	5e                   	pop    %esi
c01077d3:	5d                   	pop    %ebp
c01077d4:	c3                   	ret    

c01077d5 <threadlistnode_cleanup>:

void
threadlistnode_cleanup(struct threadlistnode* tln) {
c01077d5:	55                   	push   %ebp
c01077d6:	89 e5                	mov    %esp,%ebp
c01077d8:	53                   	push   %ebx
c01077d9:	50                   	push   %eax
c01077da:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(tln != NULL);
c01077dd:	85 db                	test   %ebx,%ebx
c01077df:	75 28                	jne    c0107809 <threadlistnode_cleanup+0x34>
c01077e1:	83 ec 0c             	sub    $0xc,%esp
c01077e4:	68 28 c6 10 c0       	push   $0xc010c628
c01077e9:	6a 11                	push   $0x11
c01077eb:	68 7a c3 10 c0       	push   $0xc010c37a
c01077f0:	68 be c3 10 c0       	push   $0xc010c3be
c01077f5:	68 95 a9 10 c0       	push   $0xc010a995
c01077fa:	e8 c5 c5 ff ff       	call   c0103dc4 <print>
c01077ff:	83 c4 20             	add    $0x20,%esp
c0107802:	e8 43 96 ff ff       	call   c0100e4a <backtrace>
c0107807:	fa                   	cli    
c0107808:	f4                   	hlt    

    assert(tln->tln_next == NULL);
c0107809:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
c010780d:	74 28                	je     c0107837 <threadlistnode_cleanup+0x62>
c010780f:	83 ec 0c             	sub    $0xc,%esp
c0107812:	68 28 c6 10 c0       	push   $0xc010c628
c0107817:	6a 13                	push   $0x13
c0107819:	68 7a c3 10 c0       	push   $0xc010c37a
c010781e:	68 f6 c3 10 c0       	push   $0xc010c3f6
c0107823:	68 95 a9 10 c0       	push   $0xc010a995
c0107828:	e8 97 c5 ff ff       	call   c0103dc4 <print>
c010782d:	83 c4 20             	add    $0x20,%esp
c0107830:	e8 15 96 ff ff       	call   c0100e4a <backtrace>
c0107835:	fa                   	cli    
c0107836:	f4                   	hlt    
    assert(tln->tln_prev == NULL);
c0107837:	83 3b 00             	cmpl   $0x0,(%ebx)
c010783a:	74 28                	je     c0107864 <threadlistnode_cleanup+0x8f>
c010783c:	83 ec 0c             	sub    $0xc,%esp
c010783f:	68 28 c6 10 c0       	push   $0xc010c628
c0107844:	6a 14                	push   $0x14
c0107846:	68 7a c3 10 c0       	push   $0xc010c37a
c010784b:	68 0c c4 10 c0       	push   $0xc010c40c
c0107850:	68 95 a9 10 c0       	push   $0xc010a995
c0107855:	e8 6a c5 ff ff       	call   c0103dc4 <print>
c010785a:	83 c4 20             	add    $0x20,%esp
c010785d:	e8 e8 95 ff ff       	call   c0100e4a <backtrace>
c0107862:	fa                   	cli    
c0107863:	f4                   	hlt    
    assert(tln->tln_self != NULL);
c0107864:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c0107868:	75 28                	jne    c0107892 <threadlistnode_cleanup+0xbd>
c010786a:	83 ec 0c             	sub    $0xc,%esp
c010786d:	68 28 c6 10 c0       	push   $0xc010c628
c0107872:	6a 15                	push   $0x15
c0107874:	68 7a c3 10 c0       	push   $0xc010c37a
c0107879:	68 22 c4 10 c0       	push   $0xc010c422
c010787e:	68 95 a9 10 c0       	push   $0xc010a995
c0107883:	e8 3c c5 ff ff       	call   c0103dc4 <print>
c0107888:	83 c4 20             	add    $0x20,%esp
c010788b:	e8 ba 95 ff ff       	call   c0100e4a <backtrace>
c0107890:	fa                   	cli    
c0107891:	f4                   	hlt    
}
c0107892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107895:	c9                   	leave  
c0107896:	c3                   	ret    

c0107897 <threadlist_init>:

void
threadlist_init(struct threadlist* tl) {
c0107897:	55                   	push   %ebp
c0107898:	89 e5                	mov    %esp,%ebp
c010789a:	53                   	push   %ebx
c010789b:	50                   	push   %eax
c010789c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(tl != NULL);
c010789f:	85 db                	test   %ebx,%ebx
c01078a1:	75 28                	jne    c01078cb <threadlist_init+0x34>
c01078a3:	83 ec 0c             	sub    $0xc,%esp
c01078a6:	68 18 c6 10 c0       	push   $0xc010c618
c01078ab:	6a 1a                	push   $0x1a
c01078ad:	68 7a c3 10 c0       	push   $0xc010c37a
c01078b2:	68 38 c4 10 c0       	push   $0xc010c438
c01078b7:	68 95 a9 10 c0       	push   $0xc010a995
c01078bc:	e8 03 c5 ff ff       	call   c0103dc4 <print>
c01078c1:	83 c4 20             	add    $0x20,%esp
c01078c4:	e8 81 95 ff ff       	call   c0100e4a <backtrace>
c01078c9:	fa                   	cli    
c01078ca:	f4                   	hlt    

    tl->tl_head.tln_next = &tl->tl_tail;
c01078cb:	8d 43 0c             	lea    0xc(%ebx),%eax
c01078ce:	89 43 04             	mov    %eax,0x4(%ebx)
    tl->tl_head.tln_prev = NULL;
c01078d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    tl->tl_tail.tln_next = NULL;
c01078d7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    tl->tl_tail.tln_prev = &tl->tl_head;
c01078de:	89 5b 0c             	mov    %ebx,0xc(%ebx)
    tl->tl_head.tln_self = NULL;
c01078e1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    tl->tl_tail.tln_self = NULL;
c01078e8:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    tl->tl_count = 0;
c01078ef:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
}
c01078f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01078f9:	c9                   	leave  
c01078fa:	c3                   	ret    

c01078fb <threadlist_isempty>:

    /* nothing (else) to do */
}

bool
threadlist_isempty(struct threadlist* tl) {
c01078fb:	55                   	push   %ebp
c01078fc:	89 e5                	mov    %esp,%ebp
c01078fe:	53                   	push   %ebx
c01078ff:	50                   	push   %eax
c0107900:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(tl != NULL);
c0107903:	85 db                	test   %ebx,%ebx
c0107905:	75 28                	jne    c010792f <threadlist_isempty+0x34>
c0107907:	83 ec 0c             	sub    $0xc,%esp
c010790a:	68 f0 c5 10 c0       	push   $0xc010c5f0
c010790f:	6a 37                	push   $0x37
c0107911:	68 7a c3 10 c0       	push   $0xc010c37a
c0107916:	68 38 c4 10 c0       	push   $0xc010c438
c010791b:	68 95 a9 10 c0       	push   $0xc010a995
c0107920:	e8 9f c4 ff ff       	call   c0103dc4 <print>
c0107925:	83 c4 20             	add    $0x20,%esp
c0107928:	e8 1d 95 ff ff       	call   c0100e4a <backtrace>
c010792d:	fa                   	cli    
c010792e:	f4                   	hlt    

    return (tl->tl_count == 0);
c010792f:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
c0107933:	0f 94 c0             	sete   %al
}
c0107936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107939:	c9                   	leave  
c010793a:	c3                   	ret    

c010793b <threadlist_cleanup>:
    tl->tl_tail.tln_self = NULL;
    tl->tl_count = 0;
}

void
threadlist_cleanup(struct threadlist* tl) {
c010793b:	55                   	push   %ebp
c010793c:	89 e5                	mov    %esp,%ebp
c010793e:	53                   	push   %ebx
c010793f:	50                   	push   %eax
c0107940:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(tl != NULL);
c0107943:	85 db                	test   %ebx,%ebx
c0107945:	75 28                	jne    c010796f <threadlist_cleanup+0x34>
c0107947:	83 ec 0c             	sub    $0xc,%esp
c010794a:	68 04 c6 10 c0       	push   $0xc010c604
c010794f:	6a 27                	push   $0x27
c0107951:	68 7a c3 10 c0       	push   $0xc010c37a
c0107956:	68 38 c4 10 c0       	push   $0xc010c438
c010795b:	68 95 a9 10 c0       	push   $0xc010a995
c0107960:	e8 5f c4 ff ff       	call   c0103dc4 <print>
c0107965:	83 c4 20             	add    $0x20,%esp
c0107968:	e8 dd 94 ff ff       	call   c0100e4a <backtrace>
c010796d:	fa                   	cli    
c010796e:	f4                   	hlt    
    assert(tl->tl_head.tln_next == &tl->tl_tail);
c010796f:	8d 43 0c             	lea    0xc(%ebx),%eax
c0107972:	39 43 04             	cmp    %eax,0x4(%ebx)
c0107975:	74 28                	je     c010799f <threadlist_cleanup+0x64>
c0107977:	83 ec 0c             	sub    $0xc,%esp
c010797a:	68 04 c6 10 c0       	push   $0xc010c604
c010797f:	6a 28                	push   $0x28
c0107981:	68 7a c3 10 c0       	push   $0xc010c37a
c0107986:	68 43 c4 10 c0       	push   $0xc010c443
c010798b:	68 95 a9 10 c0       	push   $0xc010a995
c0107990:	e8 2f c4 ff ff       	call   c0103dc4 <print>
c0107995:	83 c4 20             	add    $0x20,%esp
c0107998:	e8 ad 94 ff ff       	call   c0100e4a <backtrace>
c010799d:	fa                   	cli    
c010799e:	f4                   	hlt    
    assert(tl->tl_head.tln_prev == NULL);
c010799f:	83 3b 00             	cmpl   $0x0,(%ebx)
c01079a2:	74 28                	je     c01079cc <threadlist_cleanup+0x91>
c01079a4:	83 ec 0c             	sub    $0xc,%esp
c01079a7:	68 04 c6 10 c0       	push   $0xc010c604
c01079ac:	6a 29                	push   $0x29
c01079ae:	68 7a c3 10 c0       	push   $0xc010c37a
c01079b3:	68 68 c4 10 c0       	push   $0xc010c468
c01079b8:	68 95 a9 10 c0       	push   $0xc010a995
c01079bd:	e8 02 c4 ff ff       	call   c0103dc4 <print>
c01079c2:	83 c4 20             	add    $0x20,%esp
c01079c5:	e8 80 94 ff ff       	call   c0100e4a <backtrace>
c01079ca:	fa                   	cli    
c01079cb:	f4                   	hlt    
    assert(tl->tl_tail.tln_next == NULL);
c01079cc:	83 7b 10 00          	cmpl   $0x0,0x10(%ebx)
c01079d0:	74 28                	je     c01079fa <threadlist_cleanup+0xbf>
c01079d2:	83 ec 0c             	sub    $0xc,%esp
c01079d5:	68 04 c6 10 c0       	push   $0xc010c604
c01079da:	6a 2a                	push   $0x2a
c01079dc:	68 7a c3 10 c0       	push   $0xc010c37a
c01079e1:	68 85 c4 10 c0       	push   $0xc010c485
c01079e6:	68 95 a9 10 c0       	push   $0xc010a995
c01079eb:	e8 d4 c3 ff ff       	call   c0103dc4 <print>
c01079f0:	83 c4 20             	add    $0x20,%esp
c01079f3:	e8 52 94 ff ff       	call   c0100e4a <backtrace>
c01079f8:	fa                   	cli    
c01079f9:	f4                   	hlt    
    assert(tl->tl_tail.tln_prev == &tl->tl_head);
c01079fa:	39 5b 0c             	cmp    %ebx,0xc(%ebx)
c01079fd:	74 28                	je     c0107a27 <threadlist_cleanup+0xec>
c01079ff:	83 ec 0c             	sub    $0xc,%esp
c0107a02:	68 04 c6 10 c0       	push   $0xc010c604
c0107a07:	6a 2b                	push   $0x2b
c0107a09:	68 7a c3 10 c0       	push   $0xc010c37a
c0107a0e:	68 a2 c4 10 c0       	push   $0xc010c4a2
c0107a13:	68 95 a9 10 c0       	push   $0xc010a995
c0107a18:	e8 a7 c3 ff ff       	call   c0103dc4 <print>
c0107a1d:	83 c4 20             	add    $0x20,%esp
c0107a20:	e8 25 94 ff ff       	call   c0100e4a <backtrace>
c0107a25:	fa                   	cli    
c0107a26:	f4                   	hlt    
    assert(tl->tl_head.tln_self == NULL);
c0107a27:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c0107a2b:	74 28                	je     c0107a55 <threadlist_cleanup+0x11a>
c0107a2d:	83 ec 0c             	sub    $0xc,%esp
c0107a30:	68 04 c6 10 c0       	push   $0xc010c604
c0107a35:	6a 2c                	push   $0x2c
c0107a37:	68 7a c3 10 c0       	push   $0xc010c37a
c0107a3c:	68 c7 c4 10 c0       	push   $0xc010c4c7
c0107a41:	68 95 a9 10 c0       	push   $0xc010a995
c0107a46:	e8 79 c3 ff ff       	call   c0103dc4 <print>
c0107a4b:	83 c4 20             	add    $0x20,%esp
c0107a4e:	e8 f7 93 ff ff       	call   c0100e4a <backtrace>
c0107a53:	fa                   	cli    
c0107a54:	f4                   	hlt    
    assert(tl->tl_tail.tln_self == NULL);
c0107a55:	83 7b 14 00          	cmpl   $0x0,0x14(%ebx)
c0107a59:	74 28                	je     c0107a83 <threadlist_cleanup+0x148>
c0107a5b:	83 ec 0c             	sub    $0xc,%esp
c0107a5e:	68 04 c6 10 c0       	push   $0xc010c604
c0107a63:	6a 2d                	push   $0x2d
c0107a65:	68 7a c3 10 c0       	push   $0xc010c37a
c0107a6a:	68 e4 c4 10 c0       	push   $0xc010c4e4
c0107a6f:	68 95 a9 10 c0       	push   $0xc010a995
c0107a74:	e8 4b c3 ff ff       	call   c0103dc4 <print>
c0107a79:	83 c4 20             	add    $0x20,%esp
c0107a7c:	e8 c9 93 ff ff       	call   c0100e4a <backtrace>
c0107a81:	fa                   	cli    
c0107a82:	f4                   	hlt    

    assert(threadlist_isempty(tl));
c0107a83:	83 ec 0c             	sub    $0xc,%esp
c0107a86:	53                   	push   %ebx
c0107a87:	e8 6f fe ff ff       	call   c01078fb <threadlist_isempty>
c0107a8c:	83 c4 10             	add    $0x10,%esp
c0107a8f:	84 c0                	test   %al,%al
c0107a91:	75 28                	jne    c0107abb <threadlist_cleanup+0x180>
c0107a93:	83 ec 0c             	sub    $0xc,%esp
c0107a96:	68 04 c6 10 c0       	push   $0xc010c604
c0107a9b:	6a 2f                	push   $0x2f
c0107a9d:	68 7a c3 10 c0       	push   $0xc010c37a
c0107aa2:	68 01 c5 10 c0       	push   $0xc010c501
c0107aa7:	68 95 a9 10 c0       	push   $0xc010a995
c0107aac:	e8 13 c3 ff ff       	call   c0103dc4 <print>
c0107ab1:	83 c4 20             	add    $0x20,%esp
c0107ab4:	e8 91 93 ff ff       	call   c0100e4a <backtrace>
c0107ab9:	fa                   	cli    
c0107aba:	f4                   	hlt    
    assert(tl->tl_count == 0);
c0107abb:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
c0107abf:	74 28                	je     c0107ae9 <threadlist_cleanup+0x1ae>
c0107ac1:	83 ec 0c             	sub    $0xc,%esp
c0107ac4:	68 04 c6 10 c0       	push   $0xc010c604
c0107ac9:	6a 30                	push   $0x30
c0107acb:	68 7a c3 10 c0       	push   $0xc010c37a
c0107ad0:	68 18 c5 10 c0       	push   $0xc010c518
c0107ad5:	68 95 a9 10 c0       	push   $0xc010a995
c0107ada:	e8 e5 c2 ff ff       	call   c0103dc4 <print>
c0107adf:	83 c4 20             	add    $0x20,%esp
c0107ae2:	e8 63 93 ff ff       	call   c0100e4a <backtrace>
c0107ae7:	fa                   	cli    
c0107ae8:	f4                   	hlt    

    /* nothing (else) to do */
}
c0107ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107aec:	c9                   	leave  
c0107aed:	c3                   	ret    

c0107aee <threadlist_addhead>:

////////////////////////////////////////////////////////////
// public

void
threadlist_addhead(struct threadlist* tl, struct thread* t) {
c0107aee:	55                   	push   %ebp
c0107aef:	89 e5                	mov    %esp,%ebp
c0107af1:	56                   	push   %esi
c0107af2:	53                   	push   %ebx
c0107af3:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0107af6:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(tl != NULL);
c0107af9:	85 db                	test   %ebx,%ebx
c0107afb:	75 28                	jne    c0107b25 <threadlist_addhead+0x37>
c0107afd:	83 ec 0c             	sub    $0xc,%esp
c0107b00:	68 dc c5 10 c0       	push   $0xc010c5dc
c0107b05:	6a 7a                	push   $0x7a
c0107b07:	68 7a c3 10 c0       	push   $0xc010c37a
c0107b0c:	68 38 c4 10 c0       	push   $0xc010c438
c0107b11:	68 95 a9 10 c0       	push   $0xc010a995
c0107b16:	e8 a9 c2 ff ff       	call   c0103dc4 <print>
c0107b1b:	83 c4 20             	add    $0x20,%esp
c0107b1e:	e8 27 93 ff ff       	call   c0100e4a <backtrace>
c0107b23:	fa                   	cli    
c0107b24:	f4                   	hlt    
    assert(t != NULL);
c0107b25:	85 f6                	test   %esi,%esi
c0107b27:	75 28                	jne    c0107b51 <threadlist_addhead+0x63>
c0107b29:	83 ec 0c             	sub    $0xc,%esp
c0107b2c:	68 dc c5 10 c0       	push   $0xc010c5dc
c0107b31:	6a 7b                	push   $0x7b
c0107b33:	68 7a c3 10 c0       	push   $0xc010c37a
c0107b38:	68 c9 c1 10 c0       	push   $0xc010c1c9
c0107b3d:	68 95 a9 10 c0       	push   $0xc010a995
c0107b42:	e8 7d c2 ff ff       	call   c0103dc4 <print>
c0107b47:	83 c4 20             	add    $0x20,%esp
c0107b4a:	e8 fb 92 ff ff       	call   c0100e4a <backtrace>
c0107b4f:	fa                   	cli    
c0107b50:	f4                   	hlt    

    threadlist_insertafternode(&tl->tl_head, t);
c0107b51:	89 f2                	mov    %esi,%edx
c0107b53:	89 d8                	mov    %ebx,%eax
c0107b55:	e8 4b fa ff ff       	call   c01075a5 <threadlist_insertafternode>
    tl->tl_count++;
c0107b5a:	ff 43 18             	incl   0x18(%ebx)
}
c0107b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0107b60:	5b                   	pop    %ebx
c0107b61:	5e                   	pop    %esi
c0107b62:	5d                   	pop    %ebp
c0107b63:	c3                   	ret    

c0107b64 <threadlist_addtail>:

void
threadlist_addtail(struct threadlist* tl, struct thread* t) {
c0107b64:	55                   	push   %ebp
c0107b65:	89 e5                	mov    %esp,%ebp
c0107b67:	56                   	push   %esi
c0107b68:	53                   	push   %ebx
c0107b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0107b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(tl != NULL);
c0107b6f:	85 db                	test   %ebx,%ebx
c0107b71:	75 2b                	jne    c0107b9e <threadlist_addtail+0x3a>
c0107b73:	83 ec 0c             	sub    $0xc,%esp
c0107b76:	68 ac c5 10 c0       	push   $0xc010c5ac
c0107b7b:	68 83 00 00 00       	push   $0x83
c0107b80:	68 7a c3 10 c0       	push   $0xc010c37a
c0107b85:	68 38 c4 10 c0       	push   $0xc010c438
c0107b8a:	68 95 a9 10 c0       	push   $0xc010a995
c0107b8f:	e8 30 c2 ff ff       	call   c0103dc4 <print>
c0107b94:	83 c4 20             	add    $0x20,%esp
c0107b97:	e8 ae 92 ff ff       	call   c0100e4a <backtrace>
c0107b9c:	fa                   	cli    
c0107b9d:	f4                   	hlt    
    assert(t != NULL);
c0107b9e:	85 f6                	test   %esi,%esi
c0107ba0:	75 2b                	jne    c0107bcd <threadlist_addtail+0x69>
c0107ba2:	83 ec 0c             	sub    $0xc,%esp
c0107ba5:	68 ac c5 10 c0       	push   $0xc010c5ac
c0107baa:	68 84 00 00 00       	push   $0x84
c0107baf:	68 7a c3 10 c0       	push   $0xc010c37a
c0107bb4:	68 c9 c1 10 c0       	push   $0xc010c1c9
c0107bb9:	68 95 a9 10 c0       	push   $0xc010a995
c0107bbe:	e8 01 c2 ff ff       	call   c0103dc4 <print>
c0107bc3:	83 c4 20             	add    $0x20,%esp
c0107bc6:	e8 7f 92 ff ff       	call   c0100e4a <backtrace>
c0107bcb:	fa                   	cli    
c0107bcc:	f4                   	hlt    

    threadlist_insertbeforenode(t, &tl->tl_tail);
c0107bcd:	8d 53 0c             	lea    0xc(%ebx),%edx
c0107bd0:	89 f0                	mov    %esi,%eax
c0107bd2:	e8 53 fa ff ff       	call   c010762a <threadlist_insertbeforenode>
    tl->tl_count++;
c0107bd7:	ff 43 18             	incl   0x18(%ebx)
}
c0107bda:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0107bdd:	5b                   	pop    %ebx
c0107bde:	5e                   	pop    %esi
c0107bdf:	5d                   	pop    %ebp
c0107be0:	c3                   	ret    

c0107be1 <threadlist_remhead>:

struct thread*
threadlist_remhead(struct threadlist* tl) {
c0107be1:	55                   	push   %ebp
c0107be2:	89 e5                	mov    %esp,%ebp
c0107be4:	56                   	push   %esi
c0107be5:	53                   	push   %ebx
c0107be6:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct threadlistnode* tln;

    assert(tl != NULL);
c0107be9:	85 db                	test   %ebx,%ebx
c0107beb:	75 2b                	jne    c0107c18 <threadlist_remhead+0x37>
c0107bed:	83 ec 0c             	sub    $0xc,%esp
c0107bf0:	68 7c c5 10 c0       	push   $0xc010c57c
c0107bf5:	68 8e 00 00 00       	push   $0x8e
c0107bfa:	68 7a c3 10 c0       	push   $0xc010c37a
c0107bff:	68 38 c4 10 c0       	push   $0xc010c438
c0107c04:	68 95 a9 10 c0       	push   $0xc010a995
c0107c09:	e8 b6 c1 ff ff       	call   c0103dc4 <print>
c0107c0e:	83 c4 20             	add    $0x20,%esp
c0107c11:	e8 34 92 ff ff       	call   c0100e4a <backtrace>
c0107c16:	fa                   	cli    
c0107c17:	f4                   	hlt    

    tln = tl->tl_head.tln_next;
c0107c18:	8b 73 04             	mov    0x4(%ebx),%esi
    if (tln->tln_next == NULL)
        return NULL;
c0107c1b:	31 c0                	xor    %eax,%eax
    struct threadlistnode* tln;

    assert(tl != NULL);

    tln = tl->tl_head.tln_next;
    if (tln->tln_next == NULL)
c0107c1d:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
c0107c21:	74 3e                	je     c0107c61 <threadlist_remhead+0x80>
        return NULL;

    threadlist_removenode(tln);
c0107c23:	89 f0                	mov    %esi,%eax
c0107c25:	e8 84 fa ff ff       	call   c01076ae <threadlist_removenode>
    assert(tl->tl_count > 0);
c0107c2a:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
c0107c2e:	75 2b                	jne    c0107c5b <threadlist_remhead+0x7a>
c0107c30:	83 ec 0c             	sub    $0xc,%esp
c0107c33:	68 7c c5 10 c0       	push   $0xc010c57c
c0107c38:	68 95 00 00 00       	push   $0x95
c0107c3d:	68 7a c3 10 c0       	push   $0xc010c37a
c0107c42:	68 2a c5 10 c0       	push   $0xc010c52a
c0107c47:	68 95 a9 10 c0       	push   $0xc010a995
c0107c4c:	e8 73 c1 ff ff       	call   c0103dc4 <print>
c0107c51:	83 c4 20             	add    $0x20,%esp
c0107c54:	e8 f1 91 ff ff       	call   c0100e4a <backtrace>
c0107c59:	fa                   	cli    
c0107c5a:	f4                   	hlt    
    tl->tl_count--;
c0107c5b:	ff 4b 18             	decl   0x18(%ebx)
    return tln->tln_self;
c0107c5e:	8b 46 08             	mov    0x8(%esi),%eax
}
c0107c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0107c64:	5b                   	pop    %ebx
c0107c65:	5e                   	pop    %esi
c0107c66:	5d                   	pop    %ebp
c0107c67:	c3                   	ret    

c0107c68 <threadlist_remtail>:

struct thread*
threadlist_remtail(struct threadlist* tl) {
c0107c68:	55                   	push   %ebp
c0107c69:	89 e5                	mov    %esp,%ebp
c0107c6b:	56                   	push   %esi
c0107c6c:	53                   	push   %ebx
c0107c6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct threadlistnode* tln;

    assert(tl != NULL);
c0107c70:	85 db                	test   %ebx,%ebx
c0107c72:	75 2b                	jne    c0107c9f <threadlist_remtail+0x37>
c0107c74:	83 ec 0c             	sub    $0xc,%esp
c0107c77:	68 50 c5 10 c0       	push   $0xc010c550
c0107c7c:	68 9e 00 00 00       	push   $0x9e
c0107c81:	68 7a c3 10 c0       	push   $0xc010c37a
c0107c86:	68 38 c4 10 c0       	push   $0xc010c438
c0107c8b:	68 95 a9 10 c0       	push   $0xc010a995
c0107c90:	e8 2f c1 ff ff       	call   c0103dc4 <print>
c0107c95:	83 c4 20             	add    $0x20,%esp
c0107c98:	e8 ad 91 ff ff       	call   c0100e4a <backtrace>
c0107c9d:	fa                   	cli    
c0107c9e:	f4                   	hlt    

    tln = tl->tl_tail.tln_prev;
c0107c9f:	8b 73 0c             	mov    0xc(%ebx),%esi
    if (tln->tln_prev == NULL)
        return NULL;
c0107ca2:	31 c0                	xor    %eax,%eax
    struct threadlistnode* tln;

    assert(tl != NULL);

    tln = tl->tl_tail.tln_prev;
    if (tln->tln_prev == NULL)
c0107ca4:	83 3e 00             	cmpl   $0x0,(%esi)
c0107ca7:	74 3e                	je     c0107ce7 <threadlist_remtail+0x7f>
        return NULL;

    threadlist_removenode(tln);
c0107ca9:	89 f0                	mov    %esi,%eax
c0107cab:	e8 fe f9 ff ff       	call   c01076ae <threadlist_removenode>
    assert(tl->tl_count > 0);
c0107cb0:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
c0107cb4:	75 2b                	jne    c0107ce1 <threadlist_remtail+0x79>
c0107cb6:	83 ec 0c             	sub    $0xc,%esp
c0107cb9:	68 50 c5 10 c0       	push   $0xc010c550
c0107cbe:	68 a5 00 00 00       	push   $0xa5
c0107cc3:	68 7a c3 10 c0       	push   $0xc010c37a
c0107cc8:	68 2a c5 10 c0       	push   $0xc010c52a
c0107ccd:	68 95 a9 10 c0       	push   $0xc010a995
c0107cd2:	e8 ed c0 ff ff       	call   c0103dc4 <print>
c0107cd7:	83 c4 20             	add    $0x20,%esp
c0107cda:	e8 6b 91 ff ff       	call   c0100e4a <backtrace>
c0107cdf:	fa                   	cli    
c0107ce0:	f4                   	hlt    
    tl->tl_count--;
c0107ce1:	ff 4b 18             	decl   0x18(%ebx)
    return tln->tln_self;
c0107ce4:	8b 46 08             	mov    0x8(%esi),%eax
}
c0107ce7:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0107cea:	5b                   	pop    %ebx
c0107ceb:	5e                   	pop    %esi
c0107cec:	5d                   	pop    %ebp
c0107ced:	c3                   	ret    

c0107cee <threadlist_insertafter>:

void
threadlist_insertafter(struct threadlist* tl,
                       struct thread* onlist, struct thread* addee) {
c0107cee:	55                   	push   %ebp
c0107cef:	89 e5                	mov    %esp,%ebp
c0107cf1:	53                   	push   %ebx
c0107cf2:	50                   	push   %eax
c0107cf3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    threadlist_insertafternode(&onlist->listnode, addee);
c0107cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cf9:	83 c0 04             	add    $0x4,%eax
c0107cfc:	8b 55 10             	mov    0x10(%ebp),%edx
c0107cff:	e8 a1 f8 ff ff       	call   c01075a5 <threadlist_insertafternode>
    tl->tl_count++;
c0107d04:	ff 43 18             	incl   0x18(%ebx)
}
c0107d07:	5a                   	pop    %edx
c0107d08:	5b                   	pop    %ebx
c0107d09:	5d                   	pop    %ebp
c0107d0a:	c3                   	ret    

c0107d0b <threadlist_insertbefore>:

void
threadlist_insertbefore(struct threadlist* tl,
                        struct thread* addee, struct thread* onlist) {
c0107d0b:	55                   	push   %ebp
c0107d0c:	89 e5                	mov    %esp,%ebp
c0107d0e:	53                   	push   %ebx
c0107d0f:	50                   	push   %eax
c0107d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
    threadlist_insertbeforenode(addee, &onlist->listnode);
c0107d13:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d16:	8d 50 04             	lea    0x4(%eax),%edx
c0107d19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d1c:	e8 09 f9 ff ff       	call   c010762a <threadlist_insertbeforenode>
    tl->tl_count++;
c0107d21:	ff 43 18             	incl   0x18(%ebx)
}
c0107d24:	5a                   	pop    %edx
c0107d25:	5b                   	pop    %ebx
c0107d26:	5d                   	pop    %ebp
c0107d27:	c3                   	ret    

c0107d28 <threadlist_remove>:

void
threadlist_remove(struct threadlist* tl, struct thread* t) {
c0107d28:	55                   	push   %ebp
c0107d29:	89 e5                	mov    %esp,%ebp
c0107d2b:	53                   	push   %ebx
c0107d2c:	50                   	push   %eax
c0107d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    threadlist_removenode(&t->listnode);
c0107d30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d33:	83 c0 04             	add    $0x4,%eax
c0107d36:	e8 73 f9 ff ff       	call   c01076ae <threadlist_removenode>
    assert(tl->tl_count > 0);
c0107d3b:	83 7b 18 00          	cmpl   $0x0,0x18(%ebx)
c0107d3f:	75 2b                	jne    c0107d6c <threadlist_remove+0x44>
c0107d41:	83 ec 0c             	sub    $0xc,%esp
c0107d44:	68 3c c5 10 c0       	push   $0xc010c53c
c0107d49:	68 bb 00 00 00       	push   $0xbb
c0107d4e:	68 7a c3 10 c0       	push   $0xc010c37a
c0107d53:	68 2a c5 10 c0       	push   $0xc010c52a
c0107d58:	68 95 a9 10 c0       	push   $0xc010a995
c0107d5d:	e8 62 c0 ff ff       	call   c0103dc4 <print>
c0107d62:	83 c4 20             	add    $0x20,%esp
c0107d65:	e8 e0 90 ff ff       	call   c0100e4a <backtrace>
c0107d6a:	fa                   	cli    
c0107d6b:	f4                   	hlt    
    tl->tl_count--;
c0107d6c:	ff 4b 18             	decl   0x18(%ebx)
}
c0107d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107d72:	c9                   	leave  
c0107d73:	c3                   	ret    

c0107d74 <switchframe_start>:
        : : "g" (regs) : "memory");
    panic("iret failed");
}

static void
switchframe_start(void) {
c0107d74:	55                   	push   %ebp
c0107d75:	89 e5                	mov    %esp,%ebp
c0107d77:	83 ec 08             	sub    $0x8,%esp
    asm volatile(
c0107d7a:	52                   	push   %edx
c0107d7b:	51                   	push   %ecx
c0107d7c:	50                   	push   %eax
c0107d7d:	e8 8e f7 ff ff       	call   c0107510 <thread_startup>
        "\tpushl    %%edx\n"
        "\tpushl    %%ecx\n"
        "\tpushl    %%eax\n"
        "\tcall     thread_startup\n"
        : : : "memory");
    panic("call thread_startup failed");
c0107d82:	68 54 c6 10 c0       	push   $0xc010c654
c0107d87:	68 a0 c6 10 c0       	push   $0xc010c6a0
c0107d8c:	6a 22                	push   $0x22
c0107d8e:	68 6f c6 10 c0       	push   $0xc010c66f
c0107d93:	e8 aa bb ff ff       	call   c0103942 <_panic>
}
c0107d98:	83 c4 10             	add    $0x10,%esp
c0107d9b:	c9                   	leave  
c0107d9c:	c3                   	ret    

c0107d9d <switchframe_switch>:
#include <pmm.h>
#include <int.h>
#include <thread.h>

void
switchframe_switch(struct regs* regs) {
c0107d9d:	55                   	push   %ebp
c0107d9e:	89 e5                	mov    %esp,%ebp
c0107da0:	53                   	push   %ebx
c0107da1:	50                   	push   %eax
c0107da2:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // print("%s:%d\n", __func__, __LINE__);

    assert(regs != NULL);
c0107da5:	85 db                	test   %ebx,%ebx
c0107da7:	75 28                	jne    c0107dd1 <switchframe_switch+0x34>
c0107da9:	83 ec 0c             	sub    $0xc,%esp
c0107dac:	68 b4 c6 10 c0       	push   $0xc010c6b4
c0107db1:	6a 0b                	push   $0xb
c0107db3:	68 6f c6 10 c0       	push   $0xc010c66f
c0107db8:	68 84 c6 10 c0       	push   $0xc010c684
c0107dbd:	68 95 a9 10 c0       	push   $0xc010a995
c0107dc2:	e8 fd bf ff ff       	call   c0103dc4 <print>
c0107dc7:	83 c4 20             	add    $0x20,%esp
c0107dca:	e8 7b 90 ff ff       	call   c0100e4a <backtrace>
c0107dcf:	fa                   	cli    
c0107dd0:	f4                   	hlt    

    regs->eflags |= FL_IF;
c0107dd1:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)

    asm volatile(
c0107dd8:	89 dc                	mov    %ebx,%esp
c0107dda:	1f                   	pop    %ds
c0107ddb:	07                   	pop    %es
c0107ddc:	61                   	popa   
c0107ddd:	83 c4 08             	add    $0x8,%esp
c0107de0:	cf                   	iret   
        "\tpopl     %%es\n"
        "\tpopal\n"
        "\taddl     $0x8,%%esp\n"
        "\tiret\n"
        : : "g" (regs) : "memory");
    panic("iret failed");
c0107de1:	68 91 c6 10 c0       	push   $0xc010c691
c0107de6:	68 b4 c6 10 c0       	push   $0xc010c6b4
c0107deb:	6a 17                	push   $0x17
c0107ded:	68 6f c6 10 c0       	push   $0xc010c66f
c0107df2:	e8 4b bb ff ff       	call   c0103942 <_panic>
}
c0107df7:	83 c4 10             	add    $0x10,%esp
c0107dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107dfd:	c9                   	leave  
c0107dfe:	c3                   	ret    

c0107dff <switchframe_init>:
}

void
switchframe_init(struct thread* thread,
        int (*entrypoint)(void* data1, unsigned long data2),
        void* data1, unsigned long data2) {
c0107dff:	55                   	push   %ebp
c0107e00:	89 e5                	mov    %esp,%ebp
c0107e02:	53                   	push   %ebx
c0107e03:	83 ec 08             	sub    $0x8,%esp
c0107e06:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // print("%s:%d\n", __func__, __LINE__);

    uint32_t stacktop = (uint32_t) thread->stack + STACK_SIZE;

    thread->context = (struct regs*) stacktop - 1;
c0107e09:	8b 43 28             	mov    0x28(%ebx),%eax
c0107e0c:	05 bc 0f 00 00       	add    $0xfbc,%eax
c0107e11:	89 03                	mov    %eax,(%ebx)
    memset(thread->context, 0, sizeof(struct regs));
c0107e13:	6a 44                	push   $0x44
c0107e15:	6a 00                	push   $0x0
c0107e17:	50                   	push   %eax
c0107e18:	e8 9f c6 ff ff       	call   c01044bc <memset>

    thread->context->cs = GD_KT;
c0107e1d:	8b 03                	mov    (%ebx),%eax
c0107e1f:	c7 40 34 08 00 00 00 	movl   $0x8,0x34(%eax)
    thread->context->ds = GD_KD;
c0107e26:	c7 40 04 10 00 00 00 	movl   $0x10,0x4(%eax)
    thread->context->es = GD_KD;
c0107e2d:	c7 00 10 00 00 00    	movl   $0x10,(%eax)
    thread->context->ss = GD_KD;
c0107e33:	c7 40 40 10 00 00 00 	movl   $0x10,0x40(%eax)
    // thread->context->eflags = FL_IF;

    thread->context->eax = (uint32_t) entrypoint;
c0107e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107e3d:	89 50 24             	mov    %edx,0x24(%eax)
    thread->context->ecx = (uint32_t) data1;
c0107e40:	8b 55 10             	mov    0x10(%ebp),%edx
c0107e43:	89 50 20             	mov    %edx,0x20(%eax)
    thread->context->edx = (uint32_t) data2;
c0107e46:	8b 55 14             	mov    0x14(%ebp),%edx
c0107e49:	89 50 1c             	mov    %edx,0x1c(%eax)
    thread->context->eip = (uint32_t) switchframe_start;
c0107e4c:	c7 40 30 74 7d 10 c0 	movl   $0xc0107d74,0x30(%eax)

    thread->context->ebp = (uint32_t) thread->context;
c0107e53:	89 40 10             	mov    %eax,0x10(%eax)
    thread->context->esp = (uint32_t) thread->context;
c0107e56:	89 40 3c             	mov    %eax,0x3c(%eax)
}
c0107e59:	83 c4 10             	add    $0x10,%esp
c0107e5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107e5f:	c9                   	leave  
c0107e60:	c3                   	ret    

c0107e61 <stackreg_create>:
}

/*
 * Create a stack_registrar structure for the system
 */
void stackreg_create(void) {
c0107e61:	55                   	push   %ebp
c0107e62:	89 e5                	mov    %esp,%ebp
c0107e64:	53                   	push   %ebx
c0107e65:	83 ec 10             	sub    $0x10,%esp
    struct stack_registrar* stackreg = kmalloc(sizeof(struct stack_registrar));
c0107e68:	6a 0c                	push   $0xc
c0107e6a:	e8 36 9a ff ff       	call   c01018a5 <kmalloc>
c0107e6f:	89 c3                	mov    %eax,%ebx
    if (stackreg == NULL)
c0107e71:	83 c4 10             	add    $0x10,%esp
c0107e74:	85 c0                	test   %eax,%eax
c0107e76:	75 19                	jne    c0107e91 <stackreg_create+0x30>
        panic("kmalloc failed");
c0107e78:	68 c7 c6 10 c0       	push   $0xc010c6c7
c0107e7d:	68 a4 c7 10 c0       	push   $0xc010c7a4
c0107e82:	6a 24                	push   $0x24
c0107e84:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0107e89:	e8 b4 ba ff ff       	call   c0103942 <_panic>
c0107e8e:	83 c4 10             	add    $0x10,%esp


    stackreg->lk = lock_create("stackreg_lock");
c0107e91:	83 ec 0c             	sub    $0xc,%esp
c0107e94:	68 e8 c6 10 c0       	push   $0xc010c6e8
c0107e99:	e8 e1 ad ff ff       	call   c0102c7f <lock_create>
c0107e9e:	89 03                	mov    %eax,(%ebx)
    if (stackreg->lk == NULL) {
c0107ea0:	83 c4 10             	add    $0x10,%esp
c0107ea3:	85 c0                	test   %eax,%eax
c0107ea5:	75 22                	jne    c0107ec9 <stackreg_create+0x68>
        kfree(stackreg);
c0107ea7:	83 ec 0c             	sub    $0xc,%esp
c0107eaa:	53                   	push   %ebx
c0107eab:	e8 c1 9a ff ff       	call   c0101971 <kfree>
        panic("lock_create failed");
c0107eb0:	68 f6 c6 10 c0       	push   $0xc010c6f6
c0107eb5:	68 a4 c7 10 c0       	push   $0xc010c7a4
c0107eba:	6a 2a                	push   $0x2a
c0107ebc:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0107ec1:	e8 7c ba ff ff       	call   c0103942 <_panic>
c0107ec6:	83 c4 20             	add    $0x20,%esp
    }

    // queue for reusing stack_addrs
    stackreg->stack_reuse = queue_ts_create();
c0107ec9:	e8 24 e6 ff ff       	call   c01064f2 <queue_ts_create>
c0107ece:	89 43 04             	mov    %eax,0x4(%ebx)
    if (stackreg->stack_reuse == NULL) {
c0107ed1:	85 c0                	test   %eax,%eax
c0107ed3:	75 2b                	jne    c0107f00 <stackreg_create+0x9f>
        lock_destroy(stackreg->lk);
c0107ed5:	83 ec 0c             	sub    $0xc,%esp
c0107ed8:	ff 33                	pushl  (%ebx)
c0107eda:	e8 23 ae ff ff       	call   c0102d02 <lock_destroy>
        kfree(stackreg);
c0107edf:	89 1c 24             	mov    %ebx,(%esp)
c0107ee2:	e8 8a 9a ff ff       	call   c0101971 <kfree>
        panic("create stackreg->stack_reuse failed");
c0107ee7:	68 09 c7 10 c0       	push   $0xc010c709
c0107eec:	68 a4 c7 10 c0       	push   $0xc010c7a4
c0107ef1:	6a 32                	push   $0x32
c0107ef3:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0107ef8:	e8 45 ba ff ff       	call   c0103942 <_panic>
c0107efd:	83 c4 20             	add    $0x20,%esp
    }

    stackreg->scounter = 0;
c0107f00:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

    kstackreg = stackreg;
c0107f07:	89 1d 0c 7c 13 c0    	mov    %ebx,0xc0137c0c
}
c0107f0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0107f10:	c9                   	leave  
c0107f11:	c3                   	ret    

c0107f12 <stackreg_destroy>:


/*
 * Destroy the stack_registrar.
 */
void stackreg_destroy(void) {
c0107f12:	55                   	push   %ebp
c0107f13:	89 e5                	mov    %esp,%ebp
c0107f15:	83 ec 08             	sub    $0x8,%esp
    assert(kstackreg != NULL);
c0107f18:	83 3d 0c 7c 13 c0 00 	cmpl   $0x0,0xc0137c0c
c0107f1f:	75 28                	jne    c0107f49 <stackreg_destroy+0x37>
c0107f21:	83 ec 0c             	sub    $0xc,%esp
c0107f24:	68 90 c7 10 c0       	push   $0xc010c790
c0107f29:	6a 3f                	push   $0x3f
c0107f2b:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0107f30:	68 2d c7 10 c0       	push   $0xc010c72d
c0107f35:	68 95 a9 10 c0       	push   $0xc010a995
c0107f3a:	e8 85 be ff ff       	call   c0103dc4 <print>
c0107f3f:	83 c4 20             	add    $0x20,%esp
c0107f42:	e8 03 8f ff ff       	call   c0100e4a <backtrace>
c0107f47:	fa                   	cli    
c0107f48:	f4                   	hlt    

    lock_acquire(kstackreg->lk);
c0107f49:	83 ec 0c             	sub    $0xc,%esp
c0107f4c:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0107f51:	ff 30                	pushl  (%eax)
c0107f53:	e8 77 ae ff ff       	call   c0102dcf <lock_acquire>
    queue_ts_destroy(kstackreg->stack_reuse);
c0107f58:	58                   	pop    %eax
c0107f59:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0107f5e:	ff 70 04             	pushl  0x4(%eax)
c0107f61:	e8 60 e8 ff ff       	call   c01067c6 <queue_ts_destroy>
    lock_release(kstackreg->lk);
c0107f66:	5a                   	pop    %edx
c0107f67:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0107f6c:	ff 30                	pushl  (%eax)
c0107f6e:	e8 c4 af ff ff       	call   c0102f37 <lock_release>

    lock_destroy(kstackreg->lk);
c0107f73:	59                   	pop    %ecx
c0107f74:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0107f79:	ff 30                	pushl  (%eax)
c0107f7b:	e8 82 ad ff ff       	call   c0102d02 <lock_destroy>
    kfree(kstackreg);
c0107f80:	58                   	pop    %eax
c0107f81:	ff 35 0c 7c 13 c0    	pushl  0xc0137c0c
c0107f87:	e8 e5 99 ff ff       	call   c0101971 <kfree>
}
c0107f8c:	83 c4 10             	add    $0x10,%esp
c0107f8f:	c9                   	leave  
c0107f90:	c3                   	ret    

c0107f91 <stack_available>:

// this checks if a stack_addr is available for use
bool
stack_available(void) {
c0107f91:	55                   	push   %ebp
c0107f92:	89 e5                	mov    %esp,%ebp
c0107f94:	53                   	push   %ebx
c0107f95:	50                   	push   %eax
    assert(kstackreg != NULL);
c0107f96:	83 3d 0c 7c 13 c0 00 	cmpl   $0x0,0xc0137c0c
c0107f9d:	75 28                	jne    c0107fc7 <stack_available+0x36>
c0107f9f:	83 ec 0c             	sub    $0xc,%esp
c0107fa2:	68 80 c7 10 c0       	push   $0xc010c780
c0107fa7:	6a 4c                	push   $0x4c
c0107fa9:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0107fae:	68 2d c7 10 c0       	push   $0xc010c72d
c0107fb3:	68 95 a9 10 c0       	push   $0xc010a995
c0107fb8:	e8 07 be ff ff       	call   c0103dc4 <print>
c0107fbd:	83 c4 20             	add    $0x20,%esp
c0107fc0:	e8 85 8e ff ff       	call   c0100e4a <backtrace>
c0107fc5:	fa                   	cli    
c0107fc6:	f4                   	hlt    

    lock_acquire(kstackreg->lk);
c0107fc7:	83 ec 0c             	sub    $0xc,%esp
c0107fca:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0107fcf:	ff 30                	pushl  (%eax)
c0107fd1:	e8 f9 ad ff ff       	call   c0102dcf <lock_acquire>
    bool res = kstackreg->scounter < NSTACK || !queue_ts_isempty(kstackreg->stack_reuse);
c0107fd6:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0107fdb:	83 c4 10             	add    $0x10,%esp
c0107fde:	bb 01 00 00 00       	mov    $0x1,%ebx
c0107fe3:	81 78 08 ff 03 00 00 	cmpl   $0x3ff,0x8(%eax)
c0107fea:	7e 15                	jle    c0108001 <stack_available+0x70>
c0107fec:	83 ec 0c             	sub    $0xc,%esp
c0107fef:	ff 70 04             	pushl  0x4(%eax)
c0107ff2:	e8 15 e7 ff ff       	call   c010670c <queue_ts_isempty>
c0107ff7:	83 c4 10             	add    $0x10,%esp
c0107ffa:	31 db                	xor    %ebx,%ebx
c0107ffc:	85 c0                	test   %eax,%eax
c0107ffe:	0f 94 c3             	sete   %bl
    lock_release(kstackreg->lk);
c0108001:	83 ec 0c             	sub    $0xc,%esp
c0108004:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108009:	ff 30                	pushl  (%eax)
c010800b:	e8 27 af ff ff       	call   c0102f37 <lock_release>

    return res;
c0108010:	88 d8                	mov    %bl,%al
c0108012:	83 e0 01             	and    $0x1,%eax
}
c0108015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108018:	c9                   	leave  
c0108019:	c3                   	ret    

c010801a <stackreg_get>:

/*
 * Marks next avaialble stack_addr in registrar's bitmap as in use.
 * Returns this stack_addr.
 */
void* stackreg_get(void) {
c010801a:	55                   	push   %ebp
c010801b:	89 e5                	mov    %esp,%ebp
c010801d:	53                   	push   %ebx
c010801e:	50                   	push   %eax
    if (kstackreg == NULL)
c010801f:	83 3d 0c 7c 13 c0 00 	cmpl   $0x0,0xc0137c0c
c0108026:	75 05                	jne    c010802d <stackreg_get+0x13>
        stackreg_create();
c0108028:	e8 34 fe ff ff       	call   c0107e61 <stackreg_create>

    lock_acquire(kstackreg->lk);
c010802d:	83 ec 0c             	sub    $0xc,%esp
c0108030:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108035:	ff 30                	pushl  (%eax)
c0108037:	e8 93 ad ff ff       	call   c0102dcf <lock_acquire>

    if (!stack_available())
c010803c:	e8 50 ff ff ff       	call   c0107f91 <stack_available>
c0108041:	83 c4 10             	add    $0x10,%esp
c0108044:	84 c0                	test   %al,%al
c0108046:	75 19                	jne    c0108061 <stackreg_get+0x47>
        panic("OOM: no more stacks available");
c0108048:	68 3f c7 10 c0       	push   $0xc010c73f
c010804d:	68 70 c7 10 c0       	push   $0xc010c770
c0108052:	6a 60                	push   $0x60
c0108054:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0108059:	e8 e4 b8 ff ff       	call   c0103942 <_panic>
c010805e:	83 c4 10             	add    $0x10,%esp

    void* stack_addr = NULL;
    if (!queue_ts_isempty(kstackreg->stack_reuse)) {
c0108061:	83 ec 0c             	sub    $0xc,%esp
c0108064:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108069:	ff 70 04             	pushl  0x4(%eax)
c010806c:	e8 9b e6 ff ff       	call   c010670c <queue_ts_isempty>
c0108071:	83 c4 10             	add    $0x10,%esp
c0108074:	85 c0                	test   %eax,%eax
c0108076:	75 24                	jne    c010809c <stackreg_get+0x82>
        stack_addr = (void*) queue_ts_pop(kstackreg->stack_reuse);
c0108078:	83 ec 0c             	sub    $0xc,%esp
c010807b:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108080:	ff 70 04             	pushl  0x4(%eax)
c0108083:	e8 73 e5 ff ff       	call   c01065fb <queue_ts_pop>
c0108088:	89 c3                	mov    %eax,%ebx
        memset(stack_addr, 0, STACK_SIZE);
c010808a:	83 c4 0c             	add    $0xc,%esp
c010808d:	68 00 10 00 00       	push   $0x1000
c0108092:	6a 00                	push   $0x0
c0108094:	50                   	push   %eax
c0108095:	e8 22 c4 ff ff       	call   c01044bc <memset>
c010809a:	eb 17                	jmp    c01080b3 <stackreg_get+0x99>
    } else {
        stack_addr = kalign(STACK_SIZE);
c010809c:	83 ec 0c             	sub    $0xc,%esp
c010809f:	68 00 10 00 00       	push   $0x1000
c01080a4:	e8 ab 92 ff ff       	call   c0101354 <kalign>
c01080a9:	89 c3                	mov    %eax,%ebx
        kstackreg->scounter++;
c01080ab:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c01080b0:	ff 40 08             	incl   0x8(%eax)
c01080b3:	83 c4 10             	add    $0x10,%esp
struct stack_registrar* kstackreg;

static
void
stack_init(void* stack_addr) {
    ((uint32_t*) stack_addr)[0] = THREAD_STACK_MAGIC;
c01080b6:	c7 03 ce fa ad de    	movl   $0xdeadface,(%ebx)
    ((uint32_t*) stack_addr)[1] = THREAD_STACK_MAGIC;
c01080bc:	c7 43 04 ce fa ad de 	movl   $0xdeadface,0x4(%ebx)
    ((uint32_t*) stack_addr)[2] = THREAD_STACK_MAGIC;
c01080c3:	c7 43 08 ce fa ad de 	movl   $0xdeadface,0x8(%ebx)
    ((uint32_t*) stack_addr)[3] = THREAD_STACK_MAGIC;
c01080ca:	c7 43 0c ce fa ad de 	movl   $0xdeadface,0xc(%ebx)
        stack_addr = kalign(STACK_SIZE);
        kstackreg->scounter++;
    }
    stack_init(stack_addr);

    lock_release(kstackreg->lk);
c01080d1:	83 ec 0c             	sub    $0xc,%esp
c01080d4:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c01080d9:	ff 30                	pushl  (%eax)
c01080db:	e8 57 ae ff ff       	call   c0102f37 <lock_release>

    return stack_addr;
}
c01080e0:	89 d8                	mov    %ebx,%eax
c01080e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01080e5:	c9                   	leave  
c01080e6:	c3                   	ret    

c01080e7 <stackreg_return>:

// this makes a stack_addr available again to the system
void
stackreg_return(void* stack_addr) {
c01080e7:	55                   	push   %ebp
c01080e8:	89 e5                	mov    %esp,%ebp
c01080ea:	53                   	push   %ebx
c01080eb:	51                   	push   %ecx
c01080ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(kstackreg != NULL);
c01080ef:	83 3d 0c 7c 13 c0 00 	cmpl   $0x0,0xc0137c0c
c01080f6:	75 28                	jne    c0108120 <stackreg_return+0x39>
c01080f8:	83 ec 0c             	sub    $0xc,%esp
c01080fb:	68 60 c7 10 c0       	push   $0xc010c760
c0108100:	6a 74                	push   $0x74
c0108102:	68 d6 c6 10 c0       	push   $0xc010c6d6
c0108107:	68 2d c7 10 c0       	push   $0xc010c72d
c010810c:	68 95 a9 10 c0       	push   $0xc010a995
c0108111:	e8 ae bc ff ff       	call   c0103dc4 <print>
c0108116:	83 c4 20             	add    $0x20,%esp
c0108119:	e8 2c 8d ff ff       	call   c0100e4a <backtrace>
c010811e:	fa                   	cli    
c010811f:	f4                   	hlt    

    lock_acquire(kstackreg->lk);
c0108120:	83 ec 0c             	sub    $0xc,%esp
c0108123:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108128:	ff 30                	pushl  (%eax)
c010812a:	e8 a0 ac ff ff       	call   c0102dcf <lock_acquire>

    queue_ts_push(kstackreg->stack_reuse, (void*) stack_addr);
c010812f:	58                   	pop    %eax
c0108130:	5a                   	pop    %edx
c0108131:	53                   	push   %ebx
c0108132:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108137:	ff 70 04             	pushl  0x4(%eax)
c010813a:	e8 4e e4 ff ff       	call   c010658d <queue_ts_push>

    lock_release(kstackreg->lk);
c010813f:	83 c4 10             	add    $0x10,%esp
c0108142:	a1 0c 7c 13 c0       	mov    0xc0137c0c,%eax
c0108147:	8b 00                	mov    (%eax),%eax
c0108149:	89 45 08             	mov    %eax,0x8(%ebp)
}
c010814c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010814f:	c9                   	leave  

    lock_acquire(kstackreg->lk);

    queue_ts_push(kstackreg->stack_reuse, (void*) stack_addr);

    lock_release(kstackreg->lk);
c0108150:	e9 e2 ad ff ff       	jmp    c0102f37 <lock_release>

c0108155 <cpu_create>:
    assert(cpuid_has(feature, CPUID_PSE));
    assert(cpuid_has(feature, CPUID_APIC));
}

struct cpu*
cpu_create(uint8_t id) {
c0108155:	55                   	push   %ebp
c0108156:	89 e5                	mov    %esp,%ebp
c0108158:	57                   	push   %edi
c0108159:	56                   	push   %esi
c010815a:	53                   	push   %ebx
c010815b:	83 ec 38             	sub    $0x38,%esp
c010815e:	8b 75 08             	mov    0x8(%ebp),%esi
    struct cpu* cpu = kmalloc(sizeof(struct cpu));
c0108161:	6a 60                	push   $0x60
c0108163:	e8 3d 97 ff ff       	call   c01018a5 <kmalloc>
c0108168:	89 c3                	mov    %eax,%ebx
    if (cpu == NULL)
c010816a:	83 c4 10             	add    $0x10,%esp
c010816d:	85 c0                	test   %eax,%eax
c010816f:	75 1c                	jne    c010818d <cpu_create+0x38>
        panic("kmalloc returned NULL\n");
c0108171:	68 b4 c7 10 c0       	push   $0xc010c7b4
c0108176:	68 18 cb 10 c0       	push   $0xc010cb18
c010817b:	68 26 01 00 00       	push   $0x126
c0108180:	68 cb c7 10 c0       	push   $0xc010c7cb
c0108185:	e8 b8 b7 ff ff       	call   c0103942 <_panic>
c010818a:	83 c4 10             	add    $0x10,%esp

    cpu->self = cpu;
c010818d:	89 1b                	mov    %ebx,(%ebx)
    cpu->apicid = id;
c010818f:	89 f0                	mov    %esi,%eax
c0108191:	88 43 04             	mov    %al,0x4(%ebx)

    cpu->thread = NULL;
c0108194:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    threadlist_init(&cpu->zombie_threads);
c010819b:	83 ec 0c             	sub    $0xc,%esp
c010819e:	8d 43 10             	lea    0x10(%ebx),%eax
c01081a1:	50                   	push   %eax
c01081a2:	e8 f0 f6 ff ff       	call   c0107897 <threadlist_init>

    cpu->status = CPU_STARTED;
c01081a7:	c6 43 05 01          	movb   $0x1,0x5(%ebx)
    threadlist_init(&cpu->active_threads);
c01081ab:	8d 43 2c             	lea    0x2c(%ebx),%eax
c01081ae:	89 04 24             	mov    %eax,(%esp)
c01081b1:	e8 e1 f6 ff ff       	call   c0107897 <threadlist_init>
    spinlock_init(&cpu->active_threads_lock);
c01081b6:	8d 43 48             	lea    0x48(%ebx),%eax
c01081b9:	89 04 24             	mov    %eax,(%esp)
c01081bc:	e8 f0 b0 ff ff       	call   c01032b1 <spinlock_init>

    // cpu->ipi_pending = 0;
    // cpu->numshootdown = 0;
    // spinlock_init(&cpu->ipi_lock);

    char namebuf[24] = {0};
c01081c1:	8d 7d d0             	lea    -0x30(%ebp),%edi
c01081c4:	b9 06 00 00 00       	mov    $0x6,%ecx
c01081c9:	31 c0                	xor    %eax,%eax
c01081cb:	f3 ab                	rep stos %eax,%es:(%edi)
    snprintf(namebuf, sizeof(namebuf), "boot thread %d", cpu->apicid);
c01081cd:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
c01081d1:	50                   	push   %eax
c01081d2:	68 d5 c7 10 c0       	push   $0xc010c7d5
c01081d7:	6a 18                	push   $0x18
c01081d9:	8d 7d d0             	lea    -0x30(%ebp),%edi
c01081dc:	57                   	push   %edi
c01081dd:	e8 df c0 ff ff       	call   c01042c1 <snprintf>
    cpu->thread = thread_create(namebuf);
c01081e2:	83 c4 14             	add    $0x14,%esp
c01081e5:	57                   	push   %edi
c01081e6:	e8 4b e9 ff ff       	call   c0106b36 <thread_create>
c01081eb:	89 43 08             	mov    %eax,0x8(%ebx)
    if (cpu->thread == NULL)
c01081ee:	83 c4 10             	add    $0x10,%esp
c01081f1:	85 c0                	test   %eax,%eax
c01081f3:	75 1c                	jne    c0108211 <cpu_create+0xbc>
        panic("thread_create failed\n");
c01081f5:	68 e4 c7 10 c0       	push   $0xc010c7e4
c01081fa:	68 18 cb 10 c0       	push   $0xc010cb18
c01081ff:	68 3a 01 00 00       	push   $0x13a
c0108204:	68 cb c7 10 c0       	push   $0xc010c7cb
c0108209:	e8 34 b7 ff ff       	call   c0103942 <_panic>
c010820e:	83 c4 10             	add    $0x10,%esp

    if (id != 0) {
c0108211:	89 f0                	mov    %esi,%eax
c0108213:	84 c0                	test   %al,%al
c0108215:	74 33                	je     c010824a <cpu_create+0xf5>
        int result = proc_addthread(kproc, cpu->thread);
c0108217:	50                   	push   %eax
c0108218:	50                   	push   %eax
c0108219:	ff 73 08             	pushl  0x8(%ebx)
c010821c:	ff 35 00 80 17 c0    	pushl  0xc0178000
c0108222:	e8 9c 07 00 00       	call   c01089c3 <proc_addthread>
        if (result)
c0108227:	83 c4 10             	add    $0x10,%esp
c010822a:	85 c0                	test   %eax,%eax
c010822c:	74 1c                	je     c010824a <cpu_create+0xf5>
            panic("proc_addthread\n");
c010822e:	68 fa c7 10 c0       	push   $0xc010c7fa
c0108233:	68 18 cb 10 c0       	push   $0xc010cb18
c0108238:	68 3f 01 00 00       	push   $0x13f
c010823d:	68 cb c7 10 c0       	push   $0xc010c7cb
c0108242:	e8 fb b6 ff ff       	call   c0103942 <_panic>
c0108247:	83 c4 10             	add    $0x10,%esp
    }

    return cpu;
}
c010824a:	89 d8                	mov    %ebx,%eax
c010824c:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010824f:	5b                   	pop    %ebx
c0108250:	5e                   	pop    %esi
c0108251:	5f                   	pop    %edi
c0108252:	5d                   	pop    %ebp
c0108253:	c3                   	ret    

c0108254 <init_smp>:

uint8_t apicids[NCPU] = {0};

void
init_smp(void) {
c0108254:	55                   	push   %ebp
c0108255:	89 e5                	mov    %esp,%ebp
c0108257:	57                   	push   %edi
c0108258:	56                   	push   %esi
c0108259:	53                   	push   %ebx
c010825a:	83 ec 1c             	sub    $0x1c,%esp
    extern size_t lapic_addr;
    extern size_t ioapic_addr;

    assert(ncpu == 0);
c010825d:	80 3d c0 6e 13 c0 00 	cmpb   $0x0,0xc0136ec0
c0108264:	74 2b                	je     c0108291 <init_smp+0x3d>
c0108266:	83 ec 0c             	sub    $0xc,%esp
c0108269:	68 0c cb 10 c0       	push   $0xc010cb0c
c010826e:	68 4c 01 00 00       	push   $0x14c
c0108273:	68 cb c7 10 c0       	push   $0xc010c7cb
c0108278:	68 0a c8 10 c0       	push   $0xc010c80a
c010827d:	68 95 a9 10 c0       	push   $0xc010a995
c0108282:	e8 3d bb ff ff       	call   c0103dc4 <print>
c0108287:	83 c4 20             	add    $0x20,%esp
c010828a:	e8 bb 8b ff ff       	call   c0100e4a <backtrace>
c010828f:	fa                   	cli    
c0108290:	f4                   	hlt    

    // 5.2.12.1 MADT Processor Local APIC / SAPIC Structure Entry Order
    // * initialize processors in the order that they appear in MADT;
    // * the boot processor is the first processor entry.
    struct acpi_table_madt* madt = acpi_get_table(ACPI_SIG_MADT);
c0108291:	83 ec 0c             	sub    $0xc,%esp
c0108294:	68 14 c8 10 c0       	push   $0xc010c814
c0108299:	e8 5b 9c ff ff       	call   c0101ef9 <acpi_get_table>
c010829e:	89 c3                	mov    %eax,%ebx
    if (!madt)
c01082a0:	83 c4 10             	add    $0x10,%esp
c01082a3:	85 c0                	test   %eax,%eax
c01082a5:	75 1c                	jne    c01082c3 <init_smp+0x6f>
        panic("ACPI: No MADT found");
c01082a7:	68 19 c8 10 c0       	push   $0xc010c819
c01082ac:	68 0c cb 10 c0       	push   $0xc010cb0c
c01082b1:	68 53 01 00 00       	push   $0x153
c01082b6:	68 cb c7 10 c0       	push   $0xc010c7cb
c01082bb:	e8 82 b6 ff ff       	call   c0103942 <_panic>
c01082c0:	83 c4 10             	add    $0x10,%esp

    lapic_addr = madt->address;
c01082c3:	8b 43 24             	mov    0x24(%ebx),%eax
c01082c6:	a3 08 7c 13 c0       	mov    %eax,0xc0137c08

    struct acpi_subtable_header* hdr = (void*) madt + sizeof(*madt);
c01082cb:	8d 53 2c             	lea    0x2c(%ebx),%edx
    struct acpi_subtable_header* end = (void*) madt + madt->header.length;
c01082ce:	8b 43 04             	mov    0x4(%ebx),%eax
c01082d1:	01 d8                	add    %ebx,%eax
c01082d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01082d6:	a0 c0 6e 13 c0       	mov    0xc0136ec0,%al
c01082db:	8b 3d 04 7c 13 c0    	mov    0xc0137c04,%edi
    for (; hdr < end; hdr = (void*) hdr + hdr->length) {
c01082e1:	31 db                	xor    %ebx,%ebx
c01082e3:	31 f6                	xor    %esi,%esi
c01082e5:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
c01082e8:	73 3f                	jae    c0108329 <init_smp+0xd5>
        switch (hdr->type) {
c01082ea:	8a 0a                	mov    (%edx),%cl
c01082ec:	84 c9                	test   %cl,%cl
c01082ee:	74 06                	je     c01082f6 <init_smp+0xa2>
c01082f0:	fe c9                	dec    %cl
c01082f2:	74 22                	je     c0108316 <init_smp+0xc2>
c01082f4:	eb 2b                	jmp    c0108321 <init_smp+0xcd>
            case ACPI_MADT_TYPE_LOCAL_APIC: {
                struct acpi_madt_local_apic* p = (void*) hdr;
                bool enabled = p->lapic_flags & BIT(0);
                if (ncpu < NCPU && enabled)
c01082f6:	3c 07                	cmp    $0x7,%al
c01082f8:	0f 96 c1             	setbe  %cl
c01082fb:	22 4a 04             	and    0x4(%edx),%cl
c01082fe:	88 4d e3             	mov    %cl,-0x1d(%ebp)
c0108301:	74 1e                	je     c0108321 <init_smp+0xcd>
                    apicids[ncpu++] = p->id;
c0108303:	0f b6 f0             	movzbl %al,%esi
c0108306:	8a 4a 03             	mov    0x3(%edx),%cl
c0108309:	88 8e 9c 69 13 c0    	mov    %cl,-0x3fec9664(%esi)
c010830f:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
c0108313:	40                   	inc    %eax
c0108314:	eb 0b                	jmp    c0108321 <init_smp+0xcd>
                break;
            }
            case ACPI_MADT_TYPE_IO_APIC: {
                struct acpi_madt_io_apic* p = (void*) hdr;
                if (p->global_irq_base == 0)
c0108316:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
c010831a:	75 05                	jne    c0108321 <init_smp+0xcd>
                    ioapic_addr = p->address;
c010831c:	8b 7a 04             	mov    0x4(%edx),%edi
c010831f:	b3 01                	mov    $0x1,%bl

    lapic_addr = madt->address;

    struct acpi_subtable_header* hdr = (void*) madt + sizeof(*madt);
    struct acpi_subtable_header* end = (void*) madt + madt->header.length;
    for (; hdr < end; hdr = (void*) hdr + hdr->length) {
c0108321:	0f b6 4a 01          	movzbl 0x1(%edx),%ecx
c0108325:	01 ca                	add    %ecx,%edx
c0108327:	eb bc                	jmp    c01082e5 <init_smp+0x91>
c0108329:	89 f2                	mov    %esi,%edx
c010832b:	84 d2                	test   %dl,%dl
c010832d:	74 05                	je     c0108334 <init_smp+0xe0>
c010832f:	a2 c0 6e 13 c0       	mov    %al,0xc0136ec0
c0108334:	84 db                	test   %bl,%bl
c0108336:	74 06                	je     c010833e <init_smp+0xea>
c0108338:	89 3d 04 7c 13 c0    	mov    %edi,0xc0137c04
            default:
                break;
        }
    }

    print("SMP: %d CPU(s)\n", ncpu);
c010833e:	50                   	push   %eax
c010833f:	50                   	push   %eax
c0108340:	0f b6 05 c0 6e 13 c0 	movzbl 0xc0136ec0,%eax
c0108347:	50                   	push   %eax
c0108348:	68 2d c8 10 c0       	push   $0xc010c82d
c010834d:	e8 72 ba ff ff       	call   c0103dc4 <print>
}
c0108352:	83 c4 10             	add    $0x10,%esp
c0108355:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0108358:	5b                   	pop    %ebx
c0108359:	5e                   	pop    %esi
c010835a:	5f                   	pop    %edi
c010835b:	5d                   	pop    %ebp
c010835c:	c3                   	ret    

c010835d <cpu_idle>:

void
cpu_idle(void) {
c010835d:	55                   	push   %ebp
c010835e:	89 e5                	mov    %esp,%ebp
c0108360:	53                   	push   %ebx
c0108361:	52                   	push   %edx
    print("thisthread: %08p\n", thisthread);
c0108362:	e8 db a1 ff ff       	call   c0102542 <cpunum>
c0108367:	51                   	push   %ecx
c0108368:	51                   	push   %ecx
c0108369:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108370:	ff 70 08             	pushl  0x8(%eax)
c0108373:	68 3d c8 10 c0       	push   $0xc010c83d
c0108378:	e8 47 ba ff ff       	call   c0103dc4 <print>
    panic("cpu_idle on cpunum %u", cpunum());
c010837d:	e8 c0 a1 ff ff       	call   c0102542 <cpunum>
c0108382:	89 04 24             	mov    %eax,(%esp)
c0108385:	68 4f c8 10 c0       	push   $0xc010c84f
c010838a:	68 00 cb 10 c0       	push   $0xc010cb00
c010838f:	68 73 01 00 00       	push   $0x173
c0108394:	68 cb c7 10 c0       	push   $0xc010c7cb
c0108399:	e8 a4 b5 ff ff       	call   c0103942 <_panic>
    thisproc = NULL;
c010839e:	83 c4 20             	add    $0x20,%esp
c01083a1:	e8 9c a1 ff ff       	call   c0102542 <cpunum>
c01083a6:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01083ad:	8b 40 08             	mov    0x8(%eax),%eax
c01083b0:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    lcr3(PADDR(kpd));
c01083b7:	8b 1d c4 6e 13 c0    	mov    0xc0136ec4,%ebx

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
    if ((uint32_t) va < KADDR)
c01083bd:	81 fb ff ff ff bf    	cmp    $0xbfffffff,%ebx
c01083c3:	77 25                	ja     c01083ea <cpu_idle+0x8d>
        panic(file, line, "PADDR called with invalid va %08x", va);
c01083c5:	50                   	push   %eax
c01083c6:	53                   	push   %ebx
c01083c7:	68 06 b0 10 c0       	push   $0xc010b006
c01083cc:	68 76 01 00 00       	push   $0x176
c01083d1:	68 cb c7 10 c0       	push   $0xc010c7cb
c01083d6:	68 f8 ca 10 c0       	push   $0xc010caf8
c01083db:	6a 38                	push   $0x38
c01083dd:	68 28 b0 10 c0       	push   $0xc010b028
c01083e2:	e8 5b b5 ff ff       	call   c0103942 <_panic>
c01083e7:	83 c4 20             	add    $0x20,%esp
    return val;
}

static inline void
lcr3(uint32_t val) {
    asm volatile("movl %0,%%cr3" : : "r" (val));
c01083ea:	81 c3 00 00 00 40    	add    $0x40000000,%ebx
c01083f0:	0f 22 db             	mov    %ebx,%cr3

    // Mark that this CPU is in the HALT state, so that when
    // timer interupts come in, we know we should re-acquire the
    // big kernel lock
    xchg((uint32_t*) &thiscpu->status, CPU_IDLE);
c01083f3:	e8 4a a1 ff ff       	call   c0102542 <cpunum>
c01083f8:	8b 14 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%edx
static inline uint32_t
xchg(volatile uint32_t* addr, uint32_t newval) {
    uint32_t result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile("lock; xchgl %0, %1"
c01083ff:	b8 03 00 00 00       	mov    $0x3,%eax
c0108404:	f0 87 42 05          	lock xchg %eax,0x5(%edx)
    spinlock_acquire(&kernel_spinlock);
}

static inline void
unlock_kernel(void) {
    spinlock_release(&kernel_spinlock);
c0108408:	83 ec 0c             	sub    $0xc,%esp
c010840b:	68 7c 69 13 c0       	push   $0xc013697c
c0108410:	e8 8a af ff ff       	call   c010339f <spinlock_release>
    asm volatile("pause");
c0108415:	f3 90                	pause  
    //     "1:\n"
    //     "hlt\n"
    //     "jmp 1b\n"
    //     : : "a" (ebstack)
    // );
}
c0108417:	83 c4 10             	add    $0x10,%esp
c010841a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010841d:	c9                   	leave  
c010841e:	c3                   	ret    

c010841f <init_cpu>:

void
init_cpu(void) {
c010841f:	55                   	push   %ebp
c0108420:	89 e5                	mov    %esp,%ebp
c0108422:	57                   	push   %edi
c0108423:	56                   	push   %esi
c0108424:	53                   	push   %ebx
c0108425:	83 ec 6c             	sub    $0x6c,%esp
    return feature[bit / 32] & BIT(bit % 32);
}

static void
cpuid_info(void) {
    uint32_t eax, brand[12], feature[CPUID_NFLAGS] = {0};
c0108428:	8d 7d a4             	lea    -0x5c(%ebp),%edi
c010842b:	b9 05 00 00 00       	mov    $0x5,%ecx
c0108430:	31 c0                	xor    %eax,%eax
c0108432:	f3 ab                	rep stos %eax,%es:(%edi)
}

static inline void
cpuid(uint32_t info, uint32_t* eaxp, uint32_t* ebxp, uint32_t* ecxp, uint32_t* edxp) {
    uint32_t eax, ebx, ecx, edx;
    asm volatile("cpuid"
c0108434:	b8 00 00 00 80       	mov    $0x80000000,%eax
c0108439:	0f a2                	cpuid  

    cpuid(0x80000000, &eax, NULL, NULL, NULL);
    if (eax < 0x80000004)
c010843b:	3d 03 00 00 80       	cmp    $0x80000003,%eax
c0108440:	77 1c                	ja     c010845e <init_cpu+0x3f>
        panic("CPU too old!");
c0108442:	68 65 c8 10 c0       	push   $0xc010c865
c0108447:	68 e0 ca 10 c0       	push   $0xc010cae0
c010844c:	68 11 01 00 00       	push   $0x111
c0108451:	68 cb c7 10 c0       	push   $0xc010c7cb
c0108456:	e8 e7 b4 ff ff       	call   c0103942 <_panic>
c010845b:	83 c4 10             	add    $0x10,%esp
c010845e:	b8 02 00 00 80       	mov    $0x80000002,%eax
c0108463:	0f a2                	cpuid  
                 : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
                 : "a" (info));
    if (eaxp)
        *eaxp = eax;
c0108465:	89 45 b8             	mov    %eax,-0x48(%ebp)
    if (ebxp)
        *ebxp = ebx;
c0108468:	89 5d bc             	mov    %ebx,-0x44(%ebp)
    if (ecxp)
        *ecxp = ecx;
c010846b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
    if (edxp)
        *edxp = edx;
c010846e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
}

static inline void
cpuid(uint32_t info, uint32_t* eaxp, uint32_t* ebxp, uint32_t* ecxp, uint32_t* edxp) {
    uint32_t eax, ebx, ecx, edx;
    asm volatile("cpuid"
c0108471:	b8 03 00 00 80       	mov    $0x80000003,%eax
c0108476:	0f a2                	cpuid  
                 : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
                 : "a" (info));
    if (eaxp)
        *eaxp = eax;
c0108478:	89 45 c8             	mov    %eax,-0x38(%ebp)
    if (ebxp)
        *ebxp = ebx;
c010847b:	89 5d cc             	mov    %ebx,-0x34(%ebp)
    if (ecxp)
        *ecxp = ecx;
c010847e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    if (edxp)
        *edxp = edx;
c0108481:	89 55 d4             	mov    %edx,-0x2c(%ebp)
}

static inline void
cpuid(uint32_t info, uint32_t* eaxp, uint32_t* ebxp, uint32_t* ecxp, uint32_t* edxp) {
    uint32_t eax, ebx, ecx, edx;
    asm volatile("cpuid"
c0108484:	b8 04 00 00 80       	mov    $0x80000004,%eax
c0108489:	0f a2                	cpuid  
                 : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
                 : "a" (info));
    if (eaxp)
        *eaxp = eax;
c010848b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (ebxp)
        *ebxp = ebx;
c010848e:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    if (ecxp)
        *ecxp = ecx;
c0108491:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    if (edxp)
        *edxp = edx;
c0108494:	89 55 e4             	mov    %edx,-0x1c(%ebp)

    cpuid(0x80000002, &brand[0], &brand[1], &brand[2], &brand[3]);
    cpuid(0x80000003, &brand[4], &brand[5], &brand[6], &brand[7]);
    cpuid(0x80000004, &brand[8], &brand[9], &brand[10], &brand[11]);
    print("CPU: %.48s\n", brand);
c0108497:	52                   	push   %edx
c0108498:	52                   	push   %edx
c0108499:	8d 45 b8             	lea    -0x48(%ebp),%eax
c010849c:	50                   	push   %eax
c010849d:	68 72 c8 10 c0       	push   $0xc010c872
c01084a2:	e8 1d b9 ff ff       	call   c0103dc4 <print>
}

static inline void
cpuid(uint32_t info, uint32_t* eaxp, uint32_t* ebxp, uint32_t* ecxp, uint32_t* edxp) {
    uint32_t eax, ebx, ecx, edx;
    asm volatile("cpuid"
c01084a7:	b8 01 00 00 00       	mov    $0x1,%eax
c01084ac:	0f a2                	cpuid  
c01084ae:	89 d7                	mov    %edx,%edi
    if (eaxp)
        *eaxp = eax;
    if (ebxp)
        *ebxp = ebx;
    if (ecxp)
        *ecxp = ecx;
c01084b0:	89 4d a8             	mov    %ecx,-0x58(%ebp)
    if (edxp)
        *edxp = edx;
c01084b3:	89 55 a4             	mov    %edx,-0x5c(%ebp)
}

static inline void
cpuid(uint32_t info, uint32_t* eaxp, uint32_t* ebxp, uint32_t* ecxp, uint32_t* edxp) {
    uint32_t eax, ebx, ecx, edx;
    asm volatile("cpuid"
c01084b6:	b8 01 00 00 80       	mov    $0x80000001,%eax
c01084bb:	0f a2                	cpuid  
    if (eaxp)
        *eaxp = eax;
    if (ebxp)
        *ebxp = ebx;
    if (ecxp)
        *ecxp = ecx;
c01084bd:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
    if (edxp)
        *edxp = edx;
c01084c0:	89 55 b0             	mov    %edx,-0x50(%ebp)
c01084c3:	83 c4 10             	add    $0x10,%esp

static void
print_feature(uint32_t* feature) {
    int i, j;

    for (i = 0; i < CPUID_NFLAGS; ++i) {
c01084c6:	31 f6                	xor    %esi,%esi
        if (!feature[i])
c01084c8:	8b 5c b5 a4          	mov    -0x5c(%ebp,%esi,4),%ebx
c01084cc:	85 db                	test   %ebx,%ebx
c01084ce:	74 5c                	je     c010852c <init_cpu+0x10d>
            continue;
        print(" ");
c01084d0:	83 ec 0c             	sub    $0xc,%esp
c01084d3:	68 d0 a9 10 c0       	push   $0xc010a9d0
c01084d8:	e8 e7 b8 ff ff       	call   c0103dc4 <print>
        for (j = 0; j < 32; ++j) {
            const char* name = features[CPUID_BIT(i, j)];
c01084dd:	89 f0                	mov    %esi,%eax
c01084df:	c1 e0 05             	shl    $0x5,%eax
c01084e2:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01084e5:	83 c4 10             	add    $0x10,%esp

    for (i = 0; i < CPUID_NFLAGS; ++i) {
        if (!feature[i])
            continue;
        print(" ");
        for (j = 0; j < 32; ++j) {
c01084e8:	31 c0                	xor    %eax,%eax
            const char* name = features[CPUID_BIT(i, j)];
c01084ea:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
c01084ed:	8d 14 08             	lea    (%eax,%ecx,1),%edx
c01084f0:	8b 14 95 40 cb 10 c0 	mov    -0x3fef34c0(,%edx,4),%edx

            if ((feature[i] & BIT(j)) && name)
c01084f7:	85 d2                	test   %edx,%edx
c01084f9:	74 1b                	je     c0108516 <init_cpu+0xf7>
c01084fb:	0f a3 c3             	bt     %eax,%ebx
c01084fe:	73 16                	jae    c0108516 <init_cpu+0xf7>
c0108500:	89 45 90             	mov    %eax,-0x70(%ebp)
                print(" %s", name);
c0108503:	50                   	push   %eax
c0108504:	50                   	push   %eax
c0108505:	52                   	push   %edx
c0108506:	68 7e c8 10 c0       	push   $0xc010c87e
c010850b:	e8 b4 b8 ff ff       	call   c0103dc4 <print>
c0108510:	83 c4 10             	add    $0x10,%esp
c0108513:	8b 45 90             	mov    -0x70(%ebp),%eax

    for (i = 0; i < CPUID_NFLAGS; ++i) {
        if (!feature[i])
            continue;
        print(" ");
        for (j = 0; j < 32; ++j) {
c0108516:	40                   	inc    %eax
c0108517:	83 f8 20             	cmp    $0x20,%eax
c010851a:	75 ce                	jne    c01084ea <init_cpu+0xcb>
            const char* name = features[CPUID_BIT(i, j)];

            if ((feature[i] & BIT(j)) && name)
                print(" %s", name);
        }
        print("\n");
c010851c:	83 ec 0c             	sub    $0xc,%esp
c010851f:	68 c9 ae 10 c0       	push   $0xc010aec9
c0108524:	e8 9b b8 ff ff       	call   c0103dc4 <print>
c0108529:	83 c4 10             	add    $0x10,%esp

static void
print_feature(uint32_t* feature) {
    int i, j;

    for (i = 0; i < CPUID_NFLAGS; ++i) {
c010852c:	46                   	inc    %esi
c010852d:	83 fe 05             	cmp    $0x5,%esi
c0108530:	75 96                	jne    c01084c8 <init_cpu+0xa9>
          &feature[CPUID_1_ECX], &feature[CPUID_1_EDX]);
    cpuid(0x80000001, NULL, NULL,
          &feature[CPUID_80000001_ECX], &feature[CPUID_80000001_EDX]);
    print_feature(feature);
    // Check feature bits.
    assert(cpuid_has(feature, CPUID_PSE));
c0108532:	f7 c7 08 00 00 00    	test   $0x8,%edi
c0108538:	75 2b                	jne    c0108565 <init_cpu+0x146>
c010853a:	83 ec 0c             	sub    $0xc,%esp
c010853d:	68 e0 ca 10 c0       	push   $0xc010cae0
c0108542:	68 1e 01 00 00       	push   $0x11e
c0108547:	68 cb c7 10 c0       	push   $0xc010c7cb
c010854c:	68 82 c8 10 c0       	push   $0xc010c882
c0108551:	68 95 a9 10 c0       	push   $0xc010a995
c0108556:	e8 69 b8 ff ff       	call   c0103dc4 <print>
c010855b:	83 c4 20             	add    $0x20,%esp
c010855e:	e8 e7 88 ff ff       	call   c0100e4a <backtrace>
c0108563:	fa                   	cli    
c0108564:	f4                   	hlt    
    assert(cpuid_has(feature, CPUID_APIC));
c0108565:	81 e7 00 02 00 00    	and    $0x200,%edi
c010856b:	75 2b                	jne    c0108598 <init_cpu+0x179>
c010856d:	83 ec 0c             	sub    $0xc,%esp
c0108570:	68 e0 ca 10 c0       	push   $0xc010cae0
c0108575:	68 1f 01 00 00       	push   $0x11f
c010857a:	68 cb c7 10 c0       	push   $0xc010c7cb
c010857f:	68 a0 c8 10 c0       	push   $0xc010c8a0
c0108584:	68 95 a9 10 c0       	push   $0xc010a995
c0108589:	e8 36 b8 ff ff       	call   c0103dc4 <print>
c010858e:	83 c4 20             	add    $0x20,%esp
c0108591:	e8 b4 88 ff ff       	call   c0100e4a <backtrace>
c0108596:	fa                   	cli    
c0108597:	f4                   	hlt    

void
init_cpu(void) {
    cpuid_info();

    assert(ncpu > 0);
c0108598:	80 3d c0 6e 13 c0 00 	cmpb   $0x0,0xc0136ec0
c010859f:	75 2b                	jne    c01085cc <init_cpu+0x1ad>
c01085a1:	83 ec 0c             	sub    $0xc,%esp
c01085a4:	68 ec ca 10 c0       	push   $0xc010caec
c01085a9:	68 92 01 00 00       	push   $0x192
c01085ae:	68 cb c7 10 c0       	push   $0xc010c7cb
c01085b3:	68 bf c8 10 c0       	push   $0xc010c8bf
c01085b8:	68 95 a9 10 c0       	push   $0xc010a995
c01085bd:	e8 02 b8 ff ff       	call   c0103dc4 <print>
c01085c2:	83 c4 20             	add    $0x20,%esp
c01085c5:	e8 80 88 ff ff       	call   c0100e4a <backtrace>
c01085ca:	fa                   	cli    
c01085cb:	f4                   	hlt    

    bootcpu = cpu_create(apicids[0]);
c01085cc:	83 ec 0c             	sub    $0xc,%esp
c01085cf:	0f b6 05 9c 69 13 c0 	movzbl 0xc013699c,%eax
c01085d6:	50                   	push   %eax
c01085d7:	e8 79 fb ff ff       	call   c0108155 <cpu_create>
c01085dc:	a3 a0 6e 13 c0       	mov    %eax,0xc0136ea0
    assert(cpus[0] != NULL);
c01085e1:	83 c4 10             	add    $0x10,%esp
c01085e4:	85 c0                	test   %eax,%eax
c01085e6:	75 2b                	jne    c0108613 <init_cpu+0x1f4>
c01085e8:	83 ec 0c             	sub    $0xc,%esp
c01085eb:	68 ec ca 10 c0       	push   $0xc010caec
c01085f0:	68 95 01 00 00       	push   $0x195
c01085f5:	68 cb c7 10 c0       	push   $0xc010c7cb
c01085fa:	68 c8 c8 10 c0       	push   $0xc010c8c8
c01085ff:	68 95 a9 10 c0       	push   $0xc010a995
c0108604:	e8 bb b7 ff ff       	call   c0103dc4 <print>
c0108609:	83 c4 20             	add    $0x20,%esp
c010860c:	e8 39 88 ff ff       	call   c0100e4a <backtrace>
c0108611:	fa                   	cli    
c0108612:	f4                   	hlt    

    thisthread = bootcpu->thread;
c0108613:	e8 2a 9f ff ff       	call   c0102542 <cpunum>
c0108618:	8b 15 a0 6e 13 c0    	mov    0xc0136ea0,%edx
c010861e:	8b 52 08             	mov    0x8(%edx),%edx
c0108621:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108628:	89 50 08             	mov    %edx,0x8(%eax)
    thisthread->cpu = bootcpu;
c010862b:	e8 12 9f ff ff       	call   c0102542 <cpunum>
c0108630:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108637:	8b 40 08             	mov    0x8(%eax),%eax
c010863a:	8b 15 a0 6e 13 c0    	mov    0xc0136ea0,%edx
c0108640:	89 50 1c             	mov    %edx,0x1c(%eax)
    thisthread->page_directory = kpd;
c0108643:	e8 fa 9e ff ff       	call   c0102542 <cpunum>
c0108648:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010864f:	8b 40 08             	mov    0x8(%eax),%eax
c0108652:	8b 15 c4 6e 13 c0    	mov    0xc0136ec4,%edx
c0108658:	89 50 24             	mov    %edx,0x24(%eax)
    thisthread->stack = stackreg_get();
c010865b:	e8 e2 9e ff ff       	call   c0102542 <cpunum>
c0108660:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108667:	8b 58 08             	mov    0x8(%eax),%ebx
c010866a:	e8 ab f9 ff ff       	call   c010801a <stackreg_get>
c010866f:	89 43 28             	mov    %eax,0x28(%ebx)
}
c0108672:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0108675:	5b                   	pop    %ebx
c0108676:	5e                   	pop    %esi
c0108677:	5f                   	pop    %edi
c0108678:	5d                   	pop    %ebp
c0108679:	c3                   	ret    

c010867a <ipi_send>:
    int ts_placeholder;
};

void
ipi_send(struct cpu *target, int code)
{
c010867a:	55                   	push   %ebp
c010867b:	89 e5                	mov    %esp,%ebp
c010867d:	57                   	push   %edi
c010867e:	56                   	push   %esi
c010867f:	53                   	push   %ebx
c0108680:	83 ec 0c             	sub    $0xc,%esp
c0108683:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0108686:	8b 75 0c             	mov    0xc(%ebp),%esi
    assert(code >= 0 && code < 32);
c0108689:	83 fe 1f             	cmp    $0x1f,%esi
c010868c:	76 28                	jbe    c01086b6 <ipi_send+0x3c>
c010868e:	83 ec 0c             	sub    $0xc,%esp
c0108691:	68 18 ce 10 c0       	push   $0xc010ce18
c0108696:	6a 13                	push   $0x13
c0108698:	68 c0 cd 10 c0       	push   $0xc010cdc0
c010869d:	68 ca cd 10 c0       	push   $0xc010cdca
c01086a2:	68 95 a9 10 c0       	push   $0xc010a995
c01086a7:	e8 18 b7 ff ff       	call   c0103dc4 <print>
c01086ac:	83 c4 20             	add    $0x20,%esp
c01086af:	e8 96 87 ff ff       	call   c0100e4a <backtrace>
c01086b4:	fa                   	cli    
c01086b5:	f4                   	hlt    

    spinlock_acquire(&target->ipi_lock);
c01086b6:	8d 7b 58             	lea    0x58(%ebx),%edi
c01086b9:	83 ec 0c             	sub    $0xc,%esp
c01086bc:	57                   	push   %edi
c01086bd:	e8 35 ac ff ff       	call   c01032f7 <spinlock_acquire>
    target->ipi_pending |= (uint32_t)1 << code;
c01086c2:	b8 01 00 00 00       	mov    $0x1,%eax
c01086c7:	89 f1                	mov    %esi,%ecx
c01086c9:	d3 e0                	shl    %cl,%eax
c01086cb:	09 43 50             	or     %eax,0x50(%ebx)
    // mainbus_send_ipi(target);
    spinlock_release(&target->ipi_lock);
c01086ce:	83 c4 10             	add    $0x10,%esp
c01086d1:	89 7d 08             	mov    %edi,0x8(%ebp)
}
c01086d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01086d7:	5b                   	pop    %ebx
c01086d8:	5e                   	pop    %esi
c01086d9:	5f                   	pop    %edi
c01086da:	5d                   	pop    %ebp
    assert(code >= 0 && code < 32);

    spinlock_acquire(&target->ipi_lock);
    target->ipi_pending |= (uint32_t)1 << code;
    // mainbus_send_ipi(target);
    spinlock_release(&target->ipi_lock);
c01086db:	e9 bf ac ff ff       	jmp    c010339f <spinlock_release>

c01086e0 <ipi_broadcast>:
}

void
ipi_broadcast(int code)
{
c01086e0:	55                   	push   %ebp
c01086e1:	89 e5                	mov    %esp,%ebp
c01086e3:	56                   	push   %esi
c01086e4:	53                   	push   %ebx
    for (size_t i = 0; i < ncpu; i++)
c01086e5:	31 db                	xor    %ebx,%ebx
c01086e7:	0f b6 05 c0 6e 13 c0 	movzbl 0xc0136ec0,%eax
c01086ee:	39 c3                	cmp    %eax,%ebx
c01086f0:	73 2e                	jae    c0108720 <ipi_broadcast+0x40>
        if (cpus[i] != thiscpu->self)
c01086f2:	8b 34 9d a0 6e 13 c0 	mov    -0x3fec9160(,%ebx,4),%esi
c01086f9:	e8 44 9e ff ff       	call   c0102542 <cpunum>
c01086fe:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108705:	3b 30                	cmp    (%eax),%esi
c0108707:	74 14                	je     c010871d <ipi_broadcast+0x3d>
            ipi_send(cpus[i], code);
c0108709:	50                   	push   %eax
c010870a:	50                   	push   %eax
c010870b:	ff 75 08             	pushl  0x8(%ebp)
c010870e:	ff 34 9d a0 6e 13 c0 	pushl  -0x3fec9160(,%ebx,4)
c0108715:	e8 60 ff ff ff       	call   c010867a <ipi_send>
c010871a:	83 c4 10             	add    $0x10,%esp
}

void
ipi_broadcast(int code)
{
    for (size_t i = 0; i < ncpu; i++)
c010871d:	43                   	inc    %ebx
c010871e:	eb c7                	jmp    c01086e7 <ipi_broadcast+0x7>
        if (cpus[i] != thiscpu->self)
            ipi_send(cpus[i], code);
}
c0108720:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0108723:	5b                   	pop    %ebx
c0108724:	5e                   	pop    %esi
c0108725:	5d                   	pop    %ebp
c0108726:	c3                   	ret    

c0108727 <interprocessor_interrupt>:
//     spinlock_release(&target->ipi_lock);
// }

void
interprocessor_interrupt(void)
{
c0108727:	55                   	push   %ebp
c0108728:	89 e5                	mov    %esp,%ebp
c010872a:	53                   	push   %ebx
c010872b:	51                   	push   %ecx
    spinlock_acquire(&thiscpu->ipi_lock);
c010872c:	e8 11 9e ff ff       	call   c0102542 <cpunum>
c0108731:	83 ec 0c             	sub    $0xc,%esp
c0108734:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010873b:	83 c0 58             	add    $0x58,%eax
c010873e:	50                   	push   %eax
c010873f:	e8 b3 ab ff ff       	call   c01032f7 <spinlock_acquire>
    uint32_t bits = thiscpu->ipi_pending;
c0108744:	e8 f9 9d ff ff       	call   c0102542 <cpunum>
c0108749:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108750:	8b 58 50             	mov    0x50(%eax),%ebx

    if (bits & BIT(IPI_PANIC)) {
c0108753:	83 c4 10             	add    $0x10,%esp
c0108756:	f6 c3 01             	test   $0x1,%bl
c0108759:	74 1b                	je     c0108776 <interprocessor_interrupt+0x4f>
        /* panic on another cpu - just stop dead */
        spinlock_release(&thiscpu->ipi_lock);
c010875b:	e8 e2 9d ff ff       	call   c0102542 <cpunum>
c0108760:	83 ec 0c             	sub    $0xc,%esp
c0108763:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010876a:	83 c0 58             	add    $0x58,%eax
c010876d:	50                   	push   %eax
c010876e:	e8 2c ac ff ff       	call   c010339f <spinlock_release>
c0108773:	83 c4 10             	add    $0x10,%esp
        // cpu_halt();
    }
    if (bits & BIT(IPI_OFFLINE)) {
c0108776:	f6 c3 02             	test   $0x2,%bl
c0108779:	0f 84 9d 00 00 00    	je     c010881c <interprocessor_interrupt+0xf5>
        /* offline request */
        spinlock_release(&thiscpu->ipi_lock);
c010877f:	e8 be 9d ff ff       	call   c0102542 <cpunum>
c0108784:	83 ec 0c             	sub    $0xc,%esp
c0108787:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010878e:	83 c0 58             	add    $0x58,%eax
c0108791:	50                   	push   %eax
c0108792:	e8 08 ac ff ff       	call   c010339f <spinlock_release>
        spinlock_acquire(&thiscpu->active_threads_lock);
c0108797:	e8 a6 9d ff ff       	call   c0102542 <cpunum>
c010879c:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01087a3:	83 c0 48             	add    $0x48,%eax
c01087a6:	89 04 24             	mov    %eax,(%esp)
c01087a9:	e8 49 ab ff ff       	call   c01032f7 <spinlock_acquire>
        if (thiscpu->status != CPU_IDLE)
c01087ae:	e8 8f 9d ff ff       	call   c0102542 <cpunum>
c01087b3:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01087ba:	8a 40 05             	mov    0x5(%eax),%al
c01087bd:	83 c4 10             	add    $0x10,%esp
c01087c0:	3c 03                	cmp    $0x3,%al
c01087c2:	74 20                	je     c01087e4 <interprocessor_interrupt+0xbd>
            print("cpu%d: offline: warning: not idle\n", thiscpu->apicid);
c01087c4:	e8 79 9d ff ff       	call   c0102542 <cpunum>
c01087c9:	52                   	push   %edx
c01087ca:	52                   	push   %edx
c01087cb:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01087d2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01087d6:	50                   	push   %eax
c01087d7:	68 e1 cd 10 c0       	push   $0xc010cde1
c01087dc:	e8 e3 b5 ff ff       	call   c0103dc4 <print>
c01087e1:	83 c4 10             	add    $0x10,%esp
        spinlock_release(&thiscpu->active_threads_lock);
c01087e4:	e8 59 9d ff ff       	call   c0102542 <cpunum>
c01087e9:	83 ec 0c             	sub    $0xc,%esp
c01087ec:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c01087f3:	83 c0 48             	add    $0x48,%eax
c01087f6:	50                   	push   %eax
c01087f7:	e8 a3 ab ff ff       	call   c010339f <spinlock_release>
        print("cpu%d: offline.\n", thiscpu->apicid);
c01087fc:	e8 41 9d ff ff       	call   c0102542 <cpunum>
c0108801:	5a                   	pop    %edx
c0108802:	59                   	pop    %ecx
c0108803:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c010880a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010880e:	50                   	push   %eax
c010880f:	68 04 ce 10 c0       	push   $0xc010ce04
c0108814:	e8 ab b5 ff ff       	call   c0103dc4 <print>
c0108819:	83 c4 10             	add    $0x10,%esp
        /*
         * The cpu has already unidled itself to take the
         * interrupt; don't need to do anything else.
         */
    }
    if (bits & BIT(IPI_TLBSHOOTDOWN))
c010881c:	80 e3 08             	and    $0x8,%bl
c010881f:	74 06                	je     c0108827 <interprocessor_interrupt+0x100>
}

static inline void
tlbflush(void) {
    uint32_t cr3;
    asm volatile("movl %%cr3,%0" : "=r" (cr3));
c0108821:	0f 20 d8             	mov    %cr3,%eax
    asm volatile("movl %0,%%cr3" : : "r" (cr3));
c0108824:	0f 22 d8             	mov    %eax,%cr3
        tlbflush();

    thiscpu->ipi_pending = 0;
c0108827:	e8 16 9d ff ff       	call   c0102542 <cpunum>
c010882c:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108833:	c7 40 50 00 00 00 00 	movl   $0x0,0x50(%eax)
    spinlock_release(&thiscpu->ipi_lock);
c010883a:	e8 03 9d ff ff       	call   c0102542 <cpunum>
c010883f:	83 ec 0c             	sub    $0xc,%esp
c0108842:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108849:	83 c0 58             	add    $0x58,%eax
c010884c:	50                   	push   %eax
c010884d:	e8 4d ab ff ff       	call   c010339f <spinlock_release>
}
c0108852:	83 c4 10             	add    $0x10,%esp
c0108855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108858:	c9                   	leave  
c0108859:	c3                   	ret    

c010885a <proc_create>:
void init_proc(void) {
    proc_bootstrap();
}

struct proc*
proc_create(const char* name) {
c010885a:	55                   	push   %ebp
c010885b:	89 e5                	mov    %esp,%ebp
c010885d:	56                   	push   %esi
c010885e:	53                   	push   %ebx
c010885f:	8b 75 08             	mov    0x8(%ebp),%esi
    struct proc* proc;

    proc = kmalloc(sizeof(*proc));
c0108862:	83 ec 0c             	sub    $0xc,%esp
c0108865:	6a 3c                	push   $0x3c
c0108867:	e8 39 90 ff ff       	call   c01018a5 <kmalloc>
c010886c:	89 c3                	mov    %eax,%ebx
    if (proc == NULL)
c010886e:	83 c4 10             	add    $0x10,%esp
        return NULL;
c0108871:	31 c0                	xor    %eax,%eax
struct proc*
proc_create(const char* name) {
    struct proc* proc;

    proc = kmalloc(sizeof(*proc));
    if (proc == NULL)
c0108873:	85 db                	test   %ebx,%ebx
c0108875:	0f 84 94 00 00 00    	je     c010890f <proc_create+0xb5>
        return NULL;
    proc->name = strdup(name);
c010887b:	83 ec 0c             	sub    $0xc,%esp
c010887e:	56                   	push   %esi
c010887f:	e8 86 ba ff ff       	call   c010430a <strdup>
c0108884:	89 03                	mov    %eax,(%ebx)
    if (proc->name == NULL) {
c0108886:	83 c4 10             	add    $0x10,%esp
c0108889:	85 c0                	test   %eax,%eax
c010888b:	75 10                	jne    c010889d <proc_create+0x43>
        kfree(proc);
c010888d:	83 ec 0c             	sub    $0xc,%esp
c0108890:	53                   	push   %ebx
c0108891:	e8 db 90 ff ff       	call   c0101971 <kfree>
        return NULL;
c0108896:	83 c4 10             	add    $0x10,%esp
c0108899:	31 c0                	xor    %eax,%eax
c010889b:	eb 72                	jmp    c010890f <proc_create+0xb5>
    //     assert(temp_res == 0);

    //     assert(fdi_2 ==2);
    // }

    threadarray_init(&proc->threads);
c010889d:	83 ec 0c             	sub    $0xc,%esp
c01088a0:	8d 43 0c             	lea    0xc(%ebx),%eax
c01088a3:	50                   	push   %eax
c01088a4:	e8 45 e2 ff ff       	call   c0106aee <threadarray_init>
    spinlock_init(&proc->lock);
c01088a9:	8d 43 04             	lea    0x4(%ebx),%eax
c01088ac:	89 04 24             	mov    %eax,(%esp)
c01088af:	e8 fd a9 ff ff       	call   c01032b1 <spinlock_init>

    /* Process ID */
    proc->pid = pidreg_getpid();
c01088b4:	e8 0a 05 00 00       	call   c0108dc3 <pidreg_getpid>
c01088b9:	89 43 1c             	mov    %eax,0x1c(%ebx)

    /* Child list */
    proc->childlist = list_create();
c01088bc:	e8 18 bf ff ff       	call   c01047d9 <list_create>
c01088c1:	89 43 20             	mov    %eax,0x20(%ebx)

    proc->parent = NULL;
c01088c4:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    proc->returnvalue = 0;
c01088cb:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    proc->childlist_lock = lock_create(name);
c01088d2:	89 34 24             	mov    %esi,(%esp)
c01088d5:	e8 a5 a3 ff ff       	call   c0102c7f <lock_create>
c01088da:	89 43 24             	mov    %eax,0x24(%ebx)
    proc->childlist_lock = lock_create(name);
c01088dd:	89 34 24             	mov    %esi,(%esp)
c01088e0:	e8 9a a3 ff ff       	call   c0102c7f <lock_create>
c01088e5:	89 43 24             	mov    %eax,0x24(%ebx)
    proc->exit_sem_child = semaphore_create("wait_sem_child", 0);
c01088e8:	58                   	pop    %eax
c01088e9:	5a                   	pop    %edx
c01088ea:	6a 00                	push   $0x0
c01088ec:	68 21 ce 10 c0       	push   $0xc010ce21
c01088f1:	e8 1a a7 ff ff       	call   c0103010 <semaphore_create>
c01088f6:	89 43 34             	mov    %eax,0x34(%ebx)
    proc->exit_sem_parent = semaphore_create("wait_sem_parent", 0);
c01088f9:	59                   	pop    %ecx
c01088fa:	5e                   	pop    %esi
c01088fb:	6a 00                	push   $0x0
c01088fd:	68 30 ce 10 c0       	push   $0xc010ce30
c0108902:	e8 09 a7 ff ff       	call   c0103010 <semaphore_create>
c0108907:	89 43 38             	mov    %eax,0x38(%ebx)
    return proc;
c010890a:	83 c4 10             	add    $0x10,%esp
c010890d:	89 d8                	mov    %ebx,%eax
}
c010890f:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0108912:	5b                   	pop    %ebx
c0108913:	5e                   	pop    %esi
c0108914:	5d                   	pop    %ebp
c0108915:	c3                   	ret    

c0108916 <proc_destroy>:
 *
 * Note: nothing currently calls this. Your wait/exit code will
 * probably want to do so.
 */
void
proc_destroy(struct proc* proc) {
c0108916:	55                   	push   %ebp
c0108917:	89 e5                	mov    %esp,%ebp
c0108919:	53                   	push   %ebx
c010891a:	50                   	push   %eax
c010891b:	8b 5d 08             	mov    0x8(%ebp),%ebx
     * your wait/exit design calls for the process structure to
     * hang around beyond process exit. Some wait/exit designs
     * do, some don't.
     */

    assert(proc != NULL);
c010891e:	85 db                	test   %ebx,%ebx
c0108920:	75 28                	jne    c010894a <proc_destroy+0x34>
c0108922:	83 ec 0c             	sub    $0xc,%esp
c0108925:	68 04 cf 10 c0       	push   $0xc010cf04
c010892a:	6a 70                	push   $0x70
c010892c:	68 40 ce 10 c0       	push   $0xc010ce40
c0108931:	68 a5 ce 10 c0       	push   $0xc010cea5
c0108936:	68 95 a9 10 c0       	push   $0xc010a995
c010893b:	e8 84 b4 ff ff       	call   c0103dc4 <print>
c0108940:	83 c4 20             	add    $0x20,%esp
c0108943:	e8 02 85 ff ff       	call   c0100e4a <backtrace>
c0108948:	fa                   	cli    
c0108949:	f4                   	hlt    
    assert(proc != kproc);
c010894a:	3b 1d 00 80 17 c0    	cmp    0xc0178000,%ebx
c0108950:	75 28                	jne    c010897a <proc_destroy+0x64>
c0108952:	83 ec 0c             	sub    $0xc,%esp
c0108955:	68 04 cf 10 c0       	push   $0xc010cf04
c010895a:	6a 71                	push   $0x71
c010895c:	68 40 ce 10 c0       	push   $0xc010ce40
c0108961:	68 4c ce 10 c0       	push   $0xc010ce4c
c0108966:	68 95 a9 10 c0       	push   $0xc010a995
c010896b:	e8 54 b4 ff ff       	call   c0103dc4 <print>
c0108970:	83 c4 20             	add    $0x20,%esp
c0108973:	e8 d2 84 ff ff       	call   c0100e4a <backtrace>
c0108978:	fa                   	cli    
c0108979:	f4                   	hlt    
    //         proc->addrspace = NULL;
    //     }
    //     as_destroy(as);
    // }

    threadarray_cleanup(&proc->threads);
c010897a:	83 ec 0c             	sub    $0xc,%esp
c010897d:	8d 43 0c             	lea    0xc(%ebx),%eax
c0108980:	50                   	push   %eax
c0108981:	e8 71 e1 ff ff       	call   c0106af7 <threadarray_cleanup>
    spinlock_cleanup(&proc->lock);
c0108986:	8d 43 04             	lea    0x4(%ebx),%eax
c0108989:	89 04 24             	mov    %eax,(%esp)
c010898c:	e8 c4 aa ff ff       	call   c0103455 <spinlock_cleanup>

    pidreg_returnpid(proc->pid);
c0108991:	58                   	pop    %eax
c0108992:	ff 73 1c             	pushl  0x1c(%ebx)
c0108995:	e8 2c 06 00 00       	call   c0108fc6 <pidreg_returnpid>

    /* Child list */
    list_destroy(proc->childlist);
c010899a:	5a                   	pop    %edx
c010899b:	ff 73 20             	pushl  0x20(%ebx)
c010899e:	e8 b4 c3 ff ff       	call   c0104d57 <list_destroy>
    lock_destroy(proc->childlist_lock);
c01089a3:	59                   	pop    %ecx
c01089a4:	ff 73 24             	pushl  0x24(%ebx)
c01089a7:	e8 56 a3 ff ff       	call   c0102d02 <lock_destroy>
    // fd_table_destroy(proc->fd_table);

    kfree(proc->name);
c01089ac:	58                   	pop    %eax
c01089ad:	ff 33                	pushl  (%ebx)
c01089af:	e8 bd 8f ff ff       	call   c0101971 <kfree>
    kfree(proc);
c01089b4:	83 c4 10             	add    $0x10,%esp
c01089b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c01089ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01089bd:	c9                   	leave  
    list_destroy(proc->childlist);
    lock_destroy(proc->childlist_lock);
    // fd_table_destroy(proc->fd_table);

    kfree(proc->name);
    kfree(proc);
c01089be:	e9 ae 8f ff ff       	jmp    c0101971 <kfree>

c01089c3 <proc_addthread>:
 * case it's current, to protect against the as_activate call in
 * the timer interrupt context switch, and any other implicit uses
 * of "curproc".
 */
int
proc_addthread(struct proc* proc, struct thread* t) {
c01089c3:	55                   	push   %ebp
c01089c4:	89 e5                	mov    %esp,%ebp
c01089c6:	57                   	push   %edi
c01089c7:	56                   	push   %esi
c01089c8:	53                   	push   %ebx
c01089c9:	83 ec 1c             	sub    $0x1c,%esp
c01089cc:	8b 75 08             	mov    0x8(%ebp),%esi
c01089cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    int result;

    assert(t->proc == NULL);
c01089d2:	83 7b 20 00          	cmpl   $0x0,0x20(%ebx)
c01089d6:	74 2b                	je     c0108a03 <proc_addthread+0x40>
c01089d8:	83 ec 0c             	sub    $0xc,%esp
c01089db:	68 f4 ce 10 c0       	push   $0xc010cef4
c01089e0:	68 e9 00 00 00       	push   $0xe9
c01089e5:	68 40 ce 10 c0       	push   $0xc010ce40
c01089ea:	68 5a ce 10 c0       	push   $0xc010ce5a
c01089ef:	68 95 a9 10 c0       	push   $0xc010a995
c01089f4:	e8 cb b3 ff ff       	call   c0103dc4 <print>
c01089f9:	83 c4 20             	add    $0x20,%esp
c01089fc:	e8 49 84 ff ff       	call   c0100e4a <backtrace>
c0108a01:	fa                   	cli    
c0108a02:	f4                   	hlt    

    spinlock_acquire(&proc->lock);
c0108a03:	8d 7e 04             	lea    0x4(%esi),%edi
c0108a06:	83 ec 0c             	sub    $0xc,%esp
c0108a09:	57                   	push   %edi
c0108a0a:	e8 e8 a8 ff ff       	call   c01032f7 <spinlock_acquire>
    result = threadarray_add(&proc->threads, t, NULL);
c0108a0f:	83 c4 0c             	add    $0xc,%esp
c0108a12:	6a 00                	push   $0x0
c0108a14:	53                   	push   %ebx
c0108a15:	8d 46 0c             	lea    0xc(%esi),%eax
c0108a18:	50                   	push   %eax
c0108a19:	e8 06 e1 ff ff       	call   c0106b24 <threadarray_add>
c0108a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    spinlock_release(&proc->lock);
c0108a21:	89 3c 24             	mov    %edi,(%esp)
c0108a24:	e8 76 a9 ff ff       	call   c010339f <spinlock_release>
    if (result)
c0108a29:	83 c4 10             	add    $0x10,%esp
c0108a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a2f:	85 c0                	test   %eax,%eax
c0108a31:	75 03                	jne    c0108a36 <proc_addthread+0x73>
        return result;
    t->proc = proc;
c0108a33:	89 73 20             	mov    %esi,0x20(%ebx)
    return 0;
}
c0108a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0108a39:	5b                   	pop    %ebx
c0108a3a:	5e                   	pop    %esi
c0108a3b:	5f                   	pop    %edi
c0108a3c:	5d                   	pop    %ebp
c0108a3d:	c3                   	ret    

c0108a3e <proc_bootstrap>:

/*
 * Create the process structure for the kernel.
 */
void
proc_bootstrap(void) {
c0108a3e:	55                   	push   %ebp
c0108a3f:	89 e5                	mov    %esp,%ebp
c0108a41:	83 ec 08             	sub    $0x8,%esp
    assert(thisproc == NULL);
c0108a44:	e8 f9 9a ff ff       	call   c0102542 <cpunum>
c0108a49:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108a50:	8b 40 08             	mov    0x8(%eax),%eax
c0108a53:	83 78 20 00          	cmpl   $0x0,0x20(%eax)
c0108a57:	74 28                	je     c0108a81 <proc_bootstrap+0x43>
c0108a59:	83 ec 0c             	sub    $0xc,%esp
c0108a5c:	68 14 cf 10 c0       	push   $0xc010cf14
c0108a61:	6a 11                	push   $0x11
c0108a63:	68 40 ce 10 c0       	push   $0xc010ce40
c0108a68:	68 6a ce 10 c0       	push   $0xc010ce6a
c0108a6d:	68 95 a9 10 c0       	push   $0xc010a995
c0108a72:	e8 4d b3 ff ff       	call   c0103dc4 <print>
c0108a77:	83 c4 20             	add    $0x20,%esp
c0108a7a:	e8 cb 83 ff ff       	call   c0100e4a <backtrace>
c0108a7f:	fa                   	cli    
c0108a80:	f4                   	hlt    

    kproc = proc_create("[kproc]");
c0108a81:	83 ec 0c             	sub    $0xc,%esp
c0108a84:	68 7b ce 10 c0       	push   $0xc010ce7b
c0108a89:	e8 cc fd ff ff       	call   c010885a <proc_create>
c0108a8e:	a3 00 80 17 c0       	mov    %eax,0xc0178000
    if (kproc == NULL)
c0108a93:	83 c4 10             	add    $0x10,%esp
c0108a96:	85 c0                	test   %eax,%eax
c0108a98:	75 19                	jne    c0108ab3 <proc_bootstrap+0x75>
        panic("proc_create for kproc failed\n");
c0108a9a:	68 83 ce 10 c0       	push   $0xc010ce83
c0108a9f:	68 14 cf 10 c0       	push   $0xc010cf14
c0108aa4:	6a 15                	push   $0x15
c0108aa6:	68 40 ce 10 c0       	push   $0xc010ce40
c0108aab:	e8 92 ae ff ff       	call   c0103942 <_panic>
c0108ab0:	83 c4 10             	add    $0x10,%esp
    kproc->page_directory = kpd;
c0108ab3:	a1 00 80 17 c0       	mov    0xc0178000,%eax
c0108ab8:	8b 15 c4 6e 13 c0    	mov    0xc0136ec4,%edx
c0108abe:	89 50 18             	mov    %edx,0x18(%eax)

    int result = proc_addthread(kproc, bootcpu->thread);
c0108ac1:	52                   	push   %edx
c0108ac2:	52                   	push   %edx
c0108ac3:	8b 15 a0 6e 13 c0    	mov    0xc0136ea0,%edx
c0108ac9:	ff 72 08             	pushl  0x8(%edx)
c0108acc:	50                   	push   %eax
c0108acd:	e8 f1 fe ff ff       	call   c01089c3 <proc_addthread>
    if (result)
c0108ad2:	83 c4 10             	add    $0x10,%esp
c0108ad5:	85 c0                	test   %eax,%eax
c0108ad7:	74 19                	je     c0108af2 <proc_bootstrap+0xb4>
        panic("proc_addthread\n");
c0108ad9:	68 fa c7 10 c0       	push   $0xc010c7fa
c0108ade:	68 14 cf 10 c0       	push   $0xc010cf14
c0108ae3:	6a 1a                	push   $0x1a
c0108ae5:	68 40 ce 10 c0       	push   $0xc010ce40
c0108aea:	e8 53 ae ff ff       	call   c0103942 <_panic>
c0108aef:	83 c4 10             	add    $0x10,%esp

    assert(thisproc != NULL);
c0108af2:	e8 4b 9a ff ff       	call   c0102542 <cpunum>
c0108af7:	8b 04 85 a0 6e 13 c0 	mov    -0x3fec9160(,%eax,4),%eax
c0108afe:	8b 40 08             	mov    0x8(%eax),%eax
c0108b01:	83 78 20 00          	cmpl   $0x0,0x20(%eax)
c0108b05:	75 28                	jne    c0108b2f <proc_bootstrap+0xf1>
c0108b07:	83 ec 0c             	sub    $0xc,%esp
c0108b0a:	68 14 cf 10 c0       	push   $0xc010cf14
c0108b0f:	6a 1c                	push   $0x1c
c0108b11:	68 40 ce 10 c0       	push   $0xc010ce40
c0108b16:	68 a1 ce 10 c0       	push   $0xc010cea1
c0108b1b:	68 95 a9 10 c0       	push   $0xc010a995
c0108b20:	e8 9f b2 ff ff       	call   c0103dc4 <print>
c0108b25:	83 c4 20             	add    $0x20,%esp
c0108b28:	e8 1d 83 ff ff       	call   c0100e4a <backtrace>
c0108b2d:	fa                   	cli    
c0108b2e:	f4                   	hlt    
}
c0108b2f:	c9                   	leave  
c0108b30:	c3                   	ret    

c0108b31 <init_proc>:

void init_proc(void) {
c0108b31:	55                   	push   %ebp
c0108b32:	89 e5                	mov    %esp,%ebp
    proc_bootstrap();
}
c0108b34:	5d                   	pop    %ebp

    assert(thisproc != NULL);
}

void init_proc(void) {
    proc_bootstrap();
c0108b35:	e9 04 ff ff ff       	jmp    c0108a3e <proc_bootstrap>

c0108b3a <proc_remthread>:
 * case it's current, to protect against the as_activate call in
 * the timer interrupt context switch, and any other implicit uses
 * of "curproc".
 */
void
proc_remthread(struct thread* t) {
c0108b3a:	55                   	push   %ebp
c0108b3b:	89 e5                	mov    %esp,%ebp
c0108b3d:	57                   	push   %edi
c0108b3e:	56                   	push   %esi
c0108b3f:	53                   	push   %ebx
c0108b40:	83 ec 1c             	sub    $0x1c,%esp
    assert(t != NULL);
c0108b43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108b47:	75 2b                	jne    c0108b74 <proc_remthread+0x3a>
c0108b49:	83 ec 0c             	sub    $0xc,%esp
c0108b4c:	68 e4 ce 10 c0       	push   $0xc010cee4
c0108b51:	68 ff 00 00 00       	push   $0xff
c0108b56:	68 40 ce 10 c0       	push   $0xc010ce40
c0108b5b:	68 c9 c1 10 c0       	push   $0xc010c1c9
c0108b60:	68 95 a9 10 c0       	push   $0xc010a995
c0108b65:	e8 5a b2 ff ff       	call   c0103dc4 <print>
c0108b6a:	83 c4 20             	add    $0x20,%esp
c0108b6d:	e8 d8 82 ff ff       	call   c0100e4a <backtrace>
c0108b72:	fa                   	cli    
c0108b73:	f4                   	hlt    

    struct proc* proc = t->proc;
c0108b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b77:	8b 70 20             	mov    0x20(%eax),%esi
    assert(proc != NULL);
c0108b7a:	85 f6                	test   %esi,%esi
c0108b7c:	75 2b                	jne    c0108ba9 <proc_remthread+0x6f>
c0108b7e:	83 ec 0c             	sub    $0xc,%esp
c0108b81:	68 e4 ce 10 c0       	push   $0xc010cee4
c0108b86:	68 02 01 00 00       	push   $0x102
c0108b8b:	68 40 ce 10 c0       	push   $0xc010ce40
c0108b90:	68 a5 ce 10 c0       	push   $0xc010cea5
c0108b95:	68 95 a9 10 c0       	push   $0xc010a995
c0108b9a:	e8 25 b2 ff ff       	call   c0103dc4 <print>
c0108b9f:	83 c4 20             	add    $0x20,%esp
c0108ba2:	e8 a3 82 ff ff       	call   c0100e4a <backtrace>
c0108ba7:	fa                   	cli    
c0108ba8:	f4                   	hlt    

    spinlock_acquire(&proc->lock);
c0108ba9:	8d 7e 04             	lea    0x4(%esi),%edi
c0108bac:	83 ec 0c             	sub    $0xc,%esp
c0108baf:	57                   	push   %edi
c0108bb0:	e8 42 a7 ff ff       	call   c01032f7 <spinlock_acquire>
    /* ugh: find the thread in the array */
    unsigned num = threadarray_num(&proc->threads);
c0108bb5:	8d 5e 0c             	lea    0xc(%esi),%ebx
c0108bb8:	89 1c 24             	mov    %ebx,(%esp)
c0108bbb:	e8 40 df ff ff       	call   c0106b00 <threadarray_num>
c0108bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (unsigned i = 0; i < num; i++) {
c0108bc3:	83 c4 10             	add    $0x10,%esp
c0108bc6:	31 d2                	xor    %edx,%edx
c0108bc8:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
c0108bcb:	74 3a                	je     c0108c07 <proc_remthread+0xcd>
        if (threadarray_get(&proc->threads, i) == t) {
c0108bcd:	50                   	push   %eax
c0108bce:	50                   	push   %eax
c0108bcf:	52                   	push   %edx
c0108bd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108bd3:	53                   	push   %ebx
c0108bd4:	e8 30 df ff ff       	call   c0106b09 <threadarray_get>
c0108bd9:	83 c4 10             	add    $0x10,%esp
c0108bdc:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108bdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108be2:	75 20                	jne    c0108c04 <proc_remthread+0xca>
            threadarray_remove(&proc->threads, i);
c0108be4:	51                   	push   %ecx
c0108be5:	51                   	push   %ecx
c0108be6:	52                   	push   %edx
c0108be7:	53                   	push   %ebx
c0108be8:	e8 40 df ff ff       	call   c0106b2d <threadarray_remove>
            spinlock_release(&proc->lock);
c0108bed:	89 3c 24             	mov    %edi,(%esp)
c0108bf0:	e8 aa a7 ff ff       	call   c010339f <spinlock_release>
            t->proc = NULL;
c0108bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bf8:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
            return;
c0108bff:	83 c4 10             	add    $0x10,%esp
c0108c02:	eb 2e                	jmp    c0108c32 <proc_remthread+0xf8>
    assert(proc != NULL);

    spinlock_acquire(&proc->lock);
    /* ugh: find the thread in the array */
    unsigned num = threadarray_num(&proc->threads);
    for (unsigned i = 0; i < num; i++) {
c0108c04:	42                   	inc    %edx
c0108c05:	eb c1                	jmp    c0108bc8 <proc_remthread+0x8e>
            t->proc = NULL;
            return;
        }
    }
    /* Did not find it. */
    spinlock_release(&proc->lock);
c0108c07:	83 ec 0c             	sub    $0xc,%esp
c0108c0a:	57                   	push   %edi
c0108c0b:	e8 8f a7 ff ff       	call   c010339f <spinlock_release>
    panic("Thread (%p) has escaped from its process (%p)\n", t, proc);
c0108c10:	58                   	pop    %eax
c0108c11:	5a                   	pop    %edx
c0108c12:	56                   	push   %esi
c0108c13:	ff 75 08             	pushl  0x8(%ebp)
c0108c16:	68 b2 ce 10 c0       	push   $0xc010ceb2
c0108c1b:	68 e4 ce 10 c0       	push   $0xc010cee4
c0108c20:	68 11 01 00 00       	push   $0x111
c0108c25:	68 40 ce 10 c0       	push   $0xc010ce40
c0108c2a:	e8 13 ad ff ff       	call   c0103942 <_panic>
c0108c2f:	83 c4 20             	add    $0x20,%esp
}
c0108c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0108c35:	5b                   	pop    %ebx
c0108c36:	5e                   	pop    %esi
c0108c37:	5f                   	pop    %edi
c0108c38:	5d                   	pop    %ebp
c0108c39:	c3                   	ret    

c0108c3a <pidreg_create>:
struct pid_registrar* kpidreg;

/*
 * Create a pid_registrar structure for the system
 */
void pidreg_create(void) {
c0108c3a:	55                   	push   %ebp
c0108c3b:	89 e5                	mov    %esp,%ebp
c0108c3d:	53                   	push   %ebx
c0108c3e:	83 ec 10             	sub    $0x10,%esp
    struct pid_registrar* pidreg = kmalloc(sizeof(struct pid_registrar));
c0108c41:	6a 10                	push   $0x10
c0108c43:	e8 5d 8c ff ff       	call   c01018a5 <kmalloc>
c0108c48:	89 c3                	mov    %eax,%ebx
    if (pidreg == NULL)
c0108c4a:	83 c4 10             	add    $0x10,%esp
c0108c4d:	85 c0                	test   %eax,%eax
c0108c4f:	75 19                	jne    c0108c6a <pidreg_create+0x30>
        panic("kmalloc failed");
c0108c51:	68 c7 c6 10 c0       	push   $0xc010c6c7
c0108c56:	68 18 d0 10 c0       	push   $0xc010d018
c0108c5b:	6a 1c                	push   $0x1c
c0108c5d:	68 23 cf 10 c0       	push   $0xc010cf23
c0108c62:	e8 db ac ff ff       	call   c0103942 <_panic>
c0108c67:	83 c4 10             	add    $0x10,%esp


    pidreg->lk = lock_create("pidreg_lock");
c0108c6a:	83 ec 0c             	sub    $0xc,%esp
c0108c6d:	68 31 cf 10 c0       	push   $0xc010cf31
c0108c72:	e8 08 a0 ff ff       	call   c0102c7f <lock_create>
c0108c77:	89 03                	mov    %eax,(%ebx)
    if (pidreg->lk == NULL) {
c0108c79:	83 c4 10             	add    $0x10,%esp
c0108c7c:	85 c0                	test   %eax,%eax
c0108c7e:	75 22                	jne    c0108ca2 <pidreg_create+0x68>
        kfree(pidreg);
c0108c80:	83 ec 0c             	sub    $0xc,%esp
c0108c83:	53                   	push   %ebx
c0108c84:	e8 e8 8c ff ff       	call   c0101971 <kfree>
        panic("lock_create failed");
c0108c89:	68 f6 c6 10 c0       	push   $0xc010c6f6
c0108c8e:	68 18 d0 10 c0       	push   $0xc010d018
c0108c93:	6a 22                	push   $0x22
c0108c95:	68 23 cf 10 c0       	push   $0xc010cf23
c0108c9a:	e8 a3 ac ff ff       	call   c0103942 <_panic>
c0108c9f:	83 c4 20             	add    $0x20,%esp
    }

    // marks which pids are in use
    pidreg->pmap = bitmap_ts_create(NPID);
c0108ca2:	83 ec 0c             	sub    $0xc,%esp
c0108ca5:	68 00 80 00 00       	push   $0x8000
c0108caa:	e8 97 d4 ff ff       	call   c0106146 <bitmap_ts_create>
c0108caf:	89 43 04             	mov    %eax,0x4(%ebx)
    if (pidreg->pmap == NULL) {
c0108cb2:	83 c4 10             	add    $0x10,%esp
c0108cb5:	85 c0                	test   %eax,%eax
c0108cb7:	75 2b                	jne    c0108ce4 <pidreg_create+0xaa>
        lock_destroy(pidreg->lk);
c0108cb9:	83 ec 0c             	sub    $0xc,%esp
c0108cbc:	ff 33                	pushl  (%ebx)
c0108cbe:	e8 3f a0 ff ff       	call   c0102d02 <lock_destroy>
        kfree(pidreg);
c0108cc3:	89 1c 24             	mov    %ebx,(%esp)
c0108cc6:	e8 a6 8c ff ff       	call   c0101971 <kfree>
        panic("create pidreg->pmap failed");
c0108ccb:	68 3d cf 10 c0       	push   $0xc010cf3d
c0108cd0:	68 18 d0 10 c0       	push   $0xc010d018
c0108cd5:	6a 2a                	push   $0x2a
c0108cd7:	68 23 cf 10 c0       	push   $0xc010cf23
c0108cdc:	e8 61 ac ff ff       	call   c0103942 <_panic>
c0108ce1:	83 c4 20             	add    $0x20,%esp
    }

    // queue for reusing pids
    pidreg->pid_reuse = queue_ts_create();
c0108ce4:	e8 09 d8 ff ff       	call   c01064f2 <queue_ts_create>
c0108ce9:	89 43 08             	mov    %eax,0x8(%ebx)
    if (pidreg->pid_reuse == NULL) {
c0108cec:	85 c0                	test   %eax,%eax
c0108cee:	75 34                	jne    c0108d24 <pidreg_create+0xea>
        bitmap_ts_destroy(pidreg->pmap);
c0108cf0:	83 ec 0c             	sub    $0xc,%esp
c0108cf3:	ff 73 04             	pushl  0x4(%ebx)
c0108cf6:	e8 86 d7 ff ff       	call   c0106481 <bitmap_ts_destroy>
        lock_destroy(pidreg->lk);
c0108cfb:	58                   	pop    %eax
c0108cfc:	ff 33                	pushl  (%ebx)
c0108cfe:	e8 ff 9f ff ff       	call   c0102d02 <lock_destroy>
        kfree(pidreg);
c0108d03:	89 1c 24             	mov    %ebx,(%esp)
c0108d06:	e8 66 8c ff ff       	call   c0101971 <kfree>
        panic("create pidreg->pid_reuse failed");
c0108d0b:	68 58 cf 10 c0       	push   $0xc010cf58
c0108d10:	68 18 d0 10 c0       	push   $0xc010d018
c0108d15:	6a 33                	push   $0x33
c0108d17:	68 23 cf 10 c0       	push   $0xc010cf23
c0108d1c:	e8 21 ac ff ff       	call   c0103942 <_panic>
c0108d21:	83 c4 20             	add    $0x20,%esp
    }

    pidreg->pcounter = PID_MIN;
c0108d24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

    kpidreg = pidreg;
c0108d2b:	89 1d 04 80 17 c0    	mov    %ebx,0xc0178004
}
c0108d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108d34:	c9                   	leave  
c0108d35:	c3                   	ret    

c0108d36 <pidreg_destroy>:


/*
 * Destroy the pid_registrar.
 */
void pidreg_destroy(void) {
c0108d36:	55                   	push   %ebp
c0108d37:	89 e5                	mov    %esp,%ebp
c0108d39:	83 ec 08             	sub    $0x8,%esp
    assert(kpidreg != NULL);
c0108d3c:	83 3d 04 80 17 c0 00 	cmpl   $0x0,0xc0178004
c0108d43:	75 28                	jne    c0108d6d <pidreg_destroy+0x37>
c0108d45:	83 ec 0c             	sub    $0xc,%esp
c0108d48:	68 08 d0 10 c0       	push   $0xc010d008
c0108d4d:	6a 40                	push   $0x40
c0108d4f:	68 23 cf 10 c0       	push   $0xc010cf23
c0108d54:	68 78 cf 10 c0       	push   $0xc010cf78
c0108d59:	68 95 a9 10 c0       	push   $0xc010a995
c0108d5e:	e8 61 b0 ff ff       	call   c0103dc4 <print>
c0108d63:	83 c4 20             	add    $0x20,%esp
c0108d66:	e8 df 80 ff ff       	call   c0100e4a <backtrace>
c0108d6b:	fa                   	cli    
c0108d6c:	f4                   	hlt    

    lock_acquire(kpidreg->lk);
c0108d6d:	83 ec 0c             	sub    $0xc,%esp
c0108d70:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108d75:	ff 30                	pushl  (%eax)
c0108d77:	e8 53 a0 ff ff       	call   c0102dcf <lock_acquire>

    bitmap_ts_destroy(kpidreg->pmap);
c0108d7c:	58                   	pop    %eax
c0108d7d:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108d82:	ff 70 04             	pushl  0x4(%eax)
c0108d85:	e8 f7 d6 ff ff       	call   c0106481 <bitmap_ts_destroy>
    queue_ts_destroy(kpidreg->pid_reuse);
c0108d8a:	5a                   	pop    %edx
c0108d8b:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108d90:	ff 70 08             	pushl  0x8(%eax)
c0108d93:	e8 2e da ff ff       	call   c01067c6 <queue_ts_destroy>

    lock_release(kpidreg->lk);
c0108d98:	59                   	pop    %ecx
c0108d99:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108d9e:	ff 30                	pushl  (%eax)
c0108da0:	e8 92 a1 ff ff       	call   c0102f37 <lock_release>

    lock_destroy(kpidreg->lk);
c0108da5:	58                   	pop    %eax
c0108da6:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108dab:	ff 30                	pushl  (%eax)
c0108dad:	e8 50 9f ff ff       	call   c0102d02 <lock_destroy>
    kfree(kpidreg);
c0108db2:	58                   	pop    %eax
c0108db3:	ff 35 04 80 17 c0    	pushl  0xc0178004
c0108db9:	e8 b3 8b ff ff       	call   c0101971 <kfree>
}
c0108dbe:	83 c4 10             	add    $0x10,%esp
c0108dc1:	c9                   	leave  
c0108dc2:	c3                   	ret    

c0108dc3 <pidreg_getpid>:

/*
 * Marks next avaialble pid in registrar's bitmap as in use.
 * Returns this pid.
 */
int pidreg_getpid(void) {
c0108dc3:	55                   	push   %ebp
c0108dc4:	89 e5                	mov    %esp,%ebp
c0108dc6:	53                   	push   %ebx
c0108dc7:	53                   	push   %ebx
    if (kpidreg == NULL)
c0108dc8:	83 3d 04 80 17 c0 00 	cmpl   $0x0,0xc0178004
c0108dcf:	75 05                	jne    c0108dd6 <pidreg_getpid+0x13>
        pidreg_create();
c0108dd1:	e8 64 fe ff ff       	call   c0108c3a <pidreg_create>

    lock_acquire(kpidreg->lk);
c0108dd6:	83 ec 0c             	sub    $0xc,%esp
c0108dd9:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108dde:	ff 30                	pushl  (%eax)
c0108de0:	e8 ea 9f ff ff       	call   c0102dcf <lock_acquire>
}

// this checks if a pid is available for use
static bool
pid_available(void) {
    assert(kpidreg != NULL);
c0108de5:	83 c4 10             	add    $0x10,%esp
c0108de8:	83 3d 04 80 17 c0 00 	cmpl   $0x0,0xc0178004
c0108def:	75 28                	jne    c0108e19 <pidreg_getpid+0x56>
c0108df1:	83 ec 0c             	sub    $0xc,%esp
c0108df4:	68 e8 cf 10 c0       	push   $0xc010cfe8
c0108df9:	6a 50                	push   $0x50
c0108dfb:	68 23 cf 10 c0       	push   $0xc010cf23
c0108e00:	68 78 cf 10 c0       	push   $0xc010cf78
c0108e05:	68 95 a9 10 c0       	push   $0xc010a995
c0108e0a:	e8 b5 af ff ff       	call   c0103dc4 <print>
c0108e0f:	83 c4 20             	add    $0x20,%esp
c0108e12:	e8 33 80 ff ff       	call   c0100e4a <backtrace>
c0108e17:	fa                   	cli    
c0108e18:	f4                   	hlt    

    lock_acquire(kpidreg->lk);
c0108e19:	83 ec 0c             	sub    $0xc,%esp
c0108e1c:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108e21:	ff 30                	pushl  (%eax)
c0108e23:	e8 a7 9f ff ff       	call   c0102dcf <lock_acquire>
    bool res = kpidreg->pcounter < NPID || !queue_ts_isempty(kpidreg->pid_reuse);
c0108e28:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108e2d:	83 c4 10             	add    $0x10,%esp
c0108e30:	bb 01 00 00 00       	mov    $0x1,%ebx
c0108e35:	81 78 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%eax)
c0108e3c:	7e 15                	jle    c0108e53 <pidreg_getpid+0x90>
c0108e3e:	83 ec 0c             	sub    $0xc,%esp
c0108e41:	ff 70 08             	pushl  0x8(%eax)
c0108e44:	e8 c3 d8 ff ff       	call   c010670c <queue_ts_isempty>
c0108e49:	83 c4 10             	add    $0x10,%esp
c0108e4c:	31 db                	xor    %ebx,%ebx
c0108e4e:	85 c0                	test   %eax,%eax
c0108e50:	0f 94 c3             	sete   %bl
    lock_release(kpidreg->lk);
c0108e53:	83 ec 0c             	sub    $0xc,%esp
c0108e56:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108e5b:	ff 30                	pushl  (%eax)
c0108e5d:	e8 d5 a0 ff ff       	call   c0102f37 <lock_release>
    if (kpidreg == NULL)
        pidreg_create();

    lock_acquire(kpidreg->lk);

    if (!pid_available())
c0108e62:	83 c4 10             	add    $0x10,%esp
        return EMPROC;
c0108e65:	b8 06 00 00 00       	mov    $0x6,%eax
    if (kpidreg == NULL)
        pidreg_create();

    lock_acquire(kpidreg->lk);

    if (!pid_available())
c0108e6a:	85 db                	test   %ebx,%ebx
c0108e6c:	0f 84 98 00 00 00    	je     c0108f0a <pidreg_getpid+0x147>
        return EMPROC;

    int pid = !queue_ts_isempty(kpidreg->pid_reuse)
c0108e72:	83 ec 0c             	sub    $0xc,%esp
c0108e75:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108e7a:	ff 70 08             	pushl  0x8(%eax)
c0108e7d:	e8 8a d8 ff ff       	call   c010670c <queue_ts_isempty>
              ? (int) queue_ts_pop(kpidreg->pid_reuse)
              : kpidreg->pcounter++;
c0108e82:	83 c4 10             	add    $0x10,%esp
c0108e85:	85 c0                	test   %eax,%eax
c0108e87:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108e8c:	75 12                	jne    c0108ea0 <pidreg_getpid+0xdd>

    if (!pid_available())
        return EMPROC;

    int pid = !queue_ts_isempty(kpidreg->pid_reuse)
              ? (int) queue_ts_pop(kpidreg->pid_reuse)
c0108e8e:	83 ec 0c             	sub    $0xc,%esp
c0108e91:	ff 70 08             	pushl  0x8(%eax)
c0108e94:	e8 62 d7 ff ff       	call   c01065fb <queue_ts_pop>
c0108e99:	89 c3                	mov    %eax,%ebx
c0108e9b:	83 c4 10             	add    $0x10,%esp
c0108e9e:	eb 09                	jmp    c0108ea9 <pidreg_getpid+0xe6>
              : kpidreg->pcounter++;
c0108ea0:	8b 58 0c             	mov    0xc(%eax),%ebx
c0108ea3:	8d 53 01             	lea    0x1(%ebx),%edx
c0108ea6:	89 50 0c             	mov    %edx,0xc(%eax)
    assert(!bitmap_ts_isset(kpidreg->pmap, pid));
c0108ea9:	51                   	push   %ecx
c0108eaa:	51                   	push   %ecx
c0108eab:	53                   	push   %ebx
c0108eac:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108eb1:	ff 70 04             	pushl  0x4(%eax)
c0108eb4:	e8 f0 d4 ff ff       	call   c01063a9 <bitmap_ts_isset>
c0108eb9:	83 c4 10             	add    $0x10,%esp
c0108ebc:	85 c0                	test   %eax,%eax
c0108ebe:	74 28                	je     c0108ee8 <pidreg_getpid+0x125>
c0108ec0:	83 ec 0c             	sub    $0xc,%esp
c0108ec3:	68 f8 cf 10 c0       	push   $0xc010cff8
c0108ec8:	6a 69                	push   $0x69
c0108eca:	68 23 cf 10 c0       	push   $0xc010cf23
c0108ecf:	68 88 cf 10 c0       	push   $0xc010cf88
c0108ed4:	68 95 a9 10 c0       	push   $0xc010a995
c0108ed9:	e8 e6 ae ff ff       	call   c0103dc4 <print>
c0108ede:	83 c4 20             	add    $0x20,%esp
c0108ee1:	e8 64 7f ff ff       	call   c0100e4a <backtrace>
c0108ee6:	fa                   	cli    
c0108ee7:	f4                   	hlt    
    bitmap_ts_mark(kpidreg->pmap, pid);
c0108ee8:	50                   	push   %eax
c0108ee9:	50                   	push   %eax
c0108eea:	53                   	push   %ebx
c0108eeb:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108ef0:	ff 70 04             	pushl  0x4(%eax)
c0108ef3:	e8 e4 d3 ff ff       	call   c01062dc <bitmap_ts_mark>

    lock_release(kpidreg->lk);
c0108ef8:	5a                   	pop    %edx
c0108ef9:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108efe:	ff 30                	pushl  (%eax)
c0108f00:	e8 32 a0 ff ff       	call   c0102f37 <lock_release>

    return pid;
c0108f05:	83 c4 10             	add    $0x10,%esp
c0108f08:	89 d8                	mov    %ebx,%eax
}
c0108f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0108f0d:	c9                   	leave  
c0108f0e:	c3                   	ret    

c0108f0f <pid_used>:

// this checks that a pid is in bounds and is in use
bool
pid_used(int pid) {
c0108f0f:	55                   	push   %ebp
c0108f10:	89 e5                	mov    %esp,%ebp
c0108f12:	56                   	push   %esi
c0108f13:	53                   	push   %ebx
c0108f14:	8b 75 08             	mov    0x8(%ebp),%esi
    assert(kpidreg != NULL);
c0108f17:	83 3d 04 80 17 c0 00 	cmpl   $0x0,0xc0178004
c0108f1e:	75 28                	jne    c0108f48 <pid_used+0x39>
c0108f20:	83 ec 0c             	sub    $0xc,%esp
c0108f23:	68 dc cf 10 c0       	push   $0xc010cfdc
c0108f28:	6a 74                	push   $0x74
c0108f2a:	68 23 cf 10 c0       	push   $0xc010cf23
c0108f2f:	68 78 cf 10 c0       	push   $0xc010cf78
c0108f34:	68 95 a9 10 c0       	push   $0xc010a995
c0108f39:	e8 86 ae ff ff       	call   c0103dc4 <print>
c0108f3e:	83 c4 20             	add    $0x20,%esp
c0108f41:	e8 04 7f ff ff       	call   c0100e4a <backtrace>
c0108f46:	fa                   	cli    
c0108f47:	f4                   	hlt    
    assert(pid < NPID);
c0108f48:	81 fe ff 7f 00 00    	cmp    $0x7fff,%esi
c0108f4e:	7e 28                	jle    c0108f78 <pid_used+0x69>
c0108f50:	83 ec 0c             	sub    $0xc,%esp
c0108f53:	68 dc cf 10 c0       	push   $0xc010cfdc
c0108f58:	6a 75                	push   $0x75
c0108f5a:	68 23 cf 10 c0       	push   $0xc010cf23
c0108f5f:	68 ad cf 10 c0       	push   $0xc010cfad
c0108f64:	68 95 a9 10 c0       	push   $0xc010a995
c0108f69:	e8 56 ae ff ff       	call   c0103dc4 <print>
c0108f6e:	83 c4 20             	add    $0x20,%esp
c0108f71:	e8 d4 7e ff ff       	call   c0100e4a <backtrace>
c0108f76:	fa                   	cli    
c0108f77:	f4                   	hlt    

    lock_acquire(kpidreg->lk);
c0108f78:	83 ec 0c             	sub    $0xc,%esp
c0108f7b:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108f80:	ff 30                	pushl  (%eax)
c0108f82:	e8 48 9e ff ff       	call   c0102dcf <lock_acquire>
    // int res = fd >= PID_MIN && fd < NPID && bitmap_ts_isset(kpidreg->pmap, pid);
    // changed the above line to the below line... pid instead of fd... is that right? :)
    bool res = pid < kpidreg->pcounter && bitmap_ts_isset(kpidreg->pmap, pid);
c0108f87:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108f8c:	83 c4 10             	add    $0x10,%esp
c0108f8f:	31 db                	xor    %ebx,%ebx
c0108f91:	3b 70 0c             	cmp    0xc(%eax),%esi
c0108f94:	7d 15                	jge    c0108fab <pid_used+0x9c>
c0108f96:	52                   	push   %edx
c0108f97:	52                   	push   %edx
c0108f98:	56                   	push   %esi
c0108f99:	ff 70 04             	pushl  0x4(%eax)
c0108f9c:	e8 08 d4 ff ff       	call   c01063a9 <bitmap_ts_isset>
c0108fa1:	83 c4 10             	add    $0x10,%esp
c0108fa4:	31 db                	xor    %ebx,%ebx
c0108fa6:	85 c0                	test   %eax,%eax
c0108fa8:	0f 95 c3             	setne  %bl

    lock_release(kpidreg->lk);
c0108fab:	83 ec 0c             	sub    $0xc,%esp
c0108fae:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0108fb3:	ff 30                	pushl  (%eax)
c0108fb5:	e8 7d 9f ff ff       	call   c0102f37 <lock_release>

    return res;
c0108fba:	88 d8                	mov    %bl,%al
c0108fbc:	83 e0 01             	and    $0x1,%eax
}
c0108fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0108fc2:	5b                   	pop    %ebx
c0108fc3:	5e                   	pop    %esi
c0108fc4:	5d                   	pop    %ebp
c0108fc5:	c3                   	ret    

c0108fc6 <pidreg_returnpid>:

// this makes a pid available again to the system
void pidreg_returnpid(int pid) {
c0108fc6:	55                   	push   %ebp
c0108fc7:	89 e5                	mov    %esp,%ebp
c0108fc9:	53                   	push   %ebx
c0108fca:	50                   	push   %eax
c0108fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    assert(kpidreg != NULL);
c0108fce:	83 3d 04 80 17 c0 00 	cmpl   $0x0,0xc0178004
c0108fd5:	75 2b                	jne    c0109002 <pidreg_returnpid+0x3c>
c0108fd7:	83 ec 0c             	sub    $0xc,%esp
c0108fda:	68 c8 cf 10 c0       	push   $0xc010cfc8
c0108fdf:	68 83 00 00 00       	push   $0x83
c0108fe4:	68 23 cf 10 c0       	push   $0xc010cf23
c0108fe9:	68 78 cf 10 c0       	push   $0xc010cf78
c0108fee:	68 95 a9 10 c0       	push   $0xc010a995
c0108ff3:	e8 cc ad ff ff       	call   c0103dc4 <print>
c0108ff8:	83 c4 20             	add    $0x20,%esp
c0108ffb:	e8 4a 7e ff ff       	call   c0100e4a <backtrace>
c0109000:	fa                   	cli    
c0109001:	f4                   	hlt    
    assert(pid_used(pid));
c0109002:	83 ec 0c             	sub    $0xc,%esp
c0109005:	53                   	push   %ebx
c0109006:	e8 04 ff ff ff       	call   c0108f0f <pid_used>
c010900b:	83 c4 10             	add    $0x10,%esp
c010900e:	84 c0                	test   %al,%al
c0109010:	75 2b                	jne    c010903d <pidreg_returnpid+0x77>
c0109012:	83 ec 0c             	sub    $0xc,%esp
c0109015:	68 c8 cf 10 c0       	push   $0xc010cfc8
c010901a:	68 84 00 00 00       	push   $0x84
c010901f:	68 23 cf 10 c0       	push   $0xc010cf23
c0109024:	68 b8 cf 10 c0       	push   $0xc010cfb8
c0109029:	68 95 a9 10 c0       	push   $0xc010a995
c010902e:	e8 91 ad ff ff       	call   c0103dc4 <print>
c0109033:	83 c4 20             	add    $0x20,%esp
c0109036:	e8 0f 7e ff ff       	call   c0100e4a <backtrace>
c010903b:	fa                   	cli    
c010903c:	f4                   	hlt    

    lock_acquire(kpidreg->lk);
c010903d:	83 ec 0c             	sub    $0xc,%esp
c0109040:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0109045:	ff 30                	pushl  (%eax)
c0109047:	e8 83 9d ff ff       	call   c0102dcf <lock_acquire>

    bitmap_ts_unmark(kpidreg->pmap, pid);
c010904c:	58                   	pop    %eax
c010904d:	5a                   	pop    %edx
c010904e:	53                   	push   %ebx
c010904f:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0109054:	ff 70 04             	pushl  0x4(%eax)
c0109057:	e8 ed d2 ff ff       	call   c0106349 <bitmap_ts_unmark>
    queue_ts_push(kpidreg->pid_reuse, (void*) pid);
c010905c:	59                   	pop    %ecx
c010905d:	58                   	pop    %eax
c010905e:	53                   	push   %ebx
c010905f:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0109064:	ff 70 08             	pushl  0x8(%eax)
c0109067:	e8 21 d5 ff ff       	call   c010658d <queue_ts_push>

    lock_release(kpidreg->lk);
c010906c:	83 c4 10             	add    $0x10,%esp
c010906f:	a1 04 80 17 c0       	mov    0xc0178004,%eax
c0109074:	8b 00                	mov    (%eax),%eax
c0109076:	89 45 08             	mov    %eax,0x8(%ebp)
}
c0109079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010907c:	c9                   	leave  
    lock_acquire(kpidreg->lk);

    bitmap_ts_unmark(kpidreg->pmap, pid);
    queue_ts_push(kpidreg->pid_reuse, (void*) pid);

    lock_release(kpidreg->lk);
c010907d:	e9 b5 9e ff ff       	jmp    c0102f37 <lock_release>

c0109082 <cmd_reboot>:
    print("%lu\n", pit_ticks());
    return 0;
}

int
cmd_reboot(int argc, char* argv[]) {
c0109082:	55                   	push   %ebp
c0109083:	89 e5                	mov    %esp,%ebp
                 : "memory", "cc");
}

static inline void
outb(int port, uint8_t data) {
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0109085:	ba 64 00 00 00       	mov    $0x64,%edx
c010908a:	b0 fe                	mov    $0xfe,%al
c010908c:	ee                   	out    %al,(%dx)

    // 0x64 : the keyboard io and data interface port
    // 0xFE : reset cpu command
    outb(0x64, 0xFE);
    return 0;
}
c010908d:	31 c0                	xor    %eax,%eax
c010908f:	5d                   	pop    %ebp
c0109090:	c3                   	ret    

c0109091 <cmd_tests>:
    }
};

extern int tests(int nargs, char **args);
int
cmd_tests(int argc, char* argv[]) {
c0109091:	55                   	push   %ebp
c0109092:	89 e5                	mov    %esp,%ebp
c0109094:	57                   	push   %edi
c0109095:	56                   	push   %esi
c0109096:	53                   	push   %ebx
c0109097:	83 ec 0c             	sub    $0xc,%esp
c010909a:	8b 75 08             	mov    0x8(%ebp),%esi
c010909d:	8b 7d 0c             	mov    0xc(%ebp),%edi
c01090a0:	bb 64 00 00 00       	mov    $0x64,%ebx
    for (int i = 0; i < 100; ++i)
        tests(argc, argv);
c01090a5:	50                   	push   %eax
c01090a6:	50                   	push   %eax
c01090a7:	57                   	push   %edi
c01090a8:	56                   	push   %esi
c01090a9:	e8 37 09 00 00       	call   c01099e5 <tests>
};

extern int tests(int nargs, char **args);
int
cmd_tests(int argc, char* argv[]) {
    for (int i = 0; i < 100; ++i)
c01090ae:	83 c4 10             	add    $0x10,%esp
c01090b1:	4b                   	dec    %ebx
c01090b2:	75 f1                	jne    c01090a5 <cmd_tests+0x14>
        tests(argc, argv);
    return tests(argc, argv);
c01090b4:	89 7d 0c             	mov    %edi,0xc(%ebp)
c01090b7:	89 75 08             	mov    %esi,0x8(%ebp)
}
c01090ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01090bd:	5b                   	pop    %ebx
c01090be:	5e                   	pop    %esi
c01090bf:	5f                   	pop    %edi
c01090c0:	5d                   	pop    %ebp
extern int tests(int nargs, char **args);
int
cmd_tests(int argc, char* argv[]) {
    for (int i = 0; i < 100; ++i)
        tests(argc, argv);
    return tests(argc, argv);
c01090c1:	e9 1f 09 00 00       	jmp    c01099e5 <tests>

c01090c6 <cmd_help>:
}

// static struct cmd

int
cmd_help(int argc, char* argv[]) {
c01090c6:	55                   	push   %ebp
c01090c7:	89 e5                	mov    %esp,%ebp
c01090c9:	53                   	push   %ebx
c01090ca:	52                   	push   %edx
c01090cb:	bb 00 d4 10 c0       	mov    $0xc010d400,%ebx
    (void) argc;
    (void) argv;

    for (size_t i = 0; i < ARRAY_SIZE(cmds); i++)
        print("\t%s  %s\n", cmds[i].name, cmds[i].desc);
c01090d0:	50                   	push   %eax
c01090d1:	ff 73 04             	pushl  0x4(%ebx)
c01090d4:	ff 33                	pushl  (%ebx)
c01090d6:	68 26 d0 10 c0       	push   $0xc010d026
c01090db:	e8 e4 ac ff ff       	call   c0103dc4 <print>
c01090e0:	83 c3 0c             	add    $0xc,%ebx
int
cmd_help(int argc, char* argv[]) {
    (void) argc;
    (void) argv;

    for (size_t i = 0; i < ARRAY_SIZE(cmds); i++)
c01090e3:	83 c4 10             	add    $0x10,%esp
c01090e6:	81 fb 6c d4 10 c0    	cmp    $0xc010d46c,%ebx
c01090ec:	75 e2                	jne    c01090d0 <cmd_help+0xa>
        print("\t%s  %s\n", cmds[i].name, cmds[i].desc);
    return 0;
}
c01090ee:	31 c0                	xor    %eax,%eax
c01090f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01090f3:	c9                   	leave  
c01090f4:	c3                   	ret    

c01090f5 <cmd_info>:

int cmd_info(int argc, char* argv[]) {
c01090f5:	55                   	push   %ebp
c01090f6:	89 e5                	mov    %esp,%ebp
c01090f8:	83 ec 0c             	sub    $0xc,%esp
    (void) argc;
    (void) argv;

    print("\tCompiled on %s at %s\n", __DATE__, __TIME__);
c01090fb:	68 2f d0 10 c0       	push   $0xc010d02f
c0109100:	68 38 d0 10 c0       	push   $0xc010d038
c0109105:	68 44 d0 10 c0       	push   $0xc010d044
c010910a:	e8 b5 ac ff ff       	call   c0103dc4 <print>
    return 0;
}
c010910f:	31 c0                	xor    %eax,%eax
c0109111:	c9                   	leave  
c0109112:	c3                   	ret    

c0109113 <cmd_timestamp>:

    return 0;
}

int
cmd_timestamp(int argc, char* argv[]) {
c0109113:	55                   	push   %ebp
c0109114:	89 e5                	mov    %esp,%ebp
c0109116:	56                   	push   %esi
c0109117:	53                   	push   %ebx
    (void) argc;
    (void) argv;

    uint64_t low = 0, high = 0;
    asm volatile ("rdtsc\n"
c0109118:	0f 31                	rdtsc  
c010911a:	89 c1                	mov    %eax,%ecx
c010911c:	89 d0                	mov    %edx,%eax
c010911e:	89 de                	mov    %ebx,%esi
c0109120:	89 c3                	mov    %eax,%ebx
                  "movl %%eax, %0\n"
                  "movl %%edx, %1\n" : "=r"(low), "=r"(high));
    print("%llu\n", (uint64_t) (high << 32) | (low));
c0109122:	50                   	push   %eax
c0109123:	09 f3                	or     %esi,%ebx
c0109125:	53                   	push   %ebx
c0109126:	51                   	push   %ecx
c0109127:	68 5b d0 10 c0       	push   $0xc010d05b
c010912c:	e8 93 ac ff ff       	call   c0103dc4 <print>
    return 0;
}
c0109131:	31 c0                	xor    %eax,%eax
c0109133:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0109136:	5b                   	pop    %ebx
c0109137:	5e                   	pop    %esi
c0109138:	5d                   	pop    %ebp
c0109139:	c3                   	ret    

c010913a <cmd_clear>:
    print("\tCompiled on %s at %s\n", __DATE__, __TIME__);
    return 0;
}

int
cmd_clear(int argc, char* argv[]) {
c010913a:	55                   	push   %ebp
c010913b:	89 e5                	mov    %esp,%ebp
c010913d:	83 ec 08             	sub    $0x8,%esp
    (void) argc;
    (void) argv;

    cls();
c0109140:	e8 68 8e ff ff       	call   c0101fad <cls>
    return 0;
}
c0109145:	31 c0                	xor    %eax,%eax
c0109147:	c9                   	leave  
c0109148:	c3                   	ret    

c0109149 <cmd_e820>:

int
cmd_e820(int argc, char* argv[]) {
c0109149:	55                   	push   %ebp
c010914a:	89 e5                	mov    %esp,%ebp
c010914c:	83 ec 08             	sub    $0x8,%esp
    (void) argc;
    (void) argv;

    print_e820_mmap();
c010914f:	e8 3a 90 ff ff       	call   c010218e <print_e820_mmap>
    return 0;
}
c0109154:	31 c0                	xor    %eax,%eax
c0109156:	c9                   	leave  
c0109157:	c3                   	ret    

c0109158 <cmd_ticks>:
    print("%llu\n", (uint64_t) (high << 32) | (low));
    return 0;
}

int
cmd_ticks(int argc, char* argv[]) {
c0109158:	55                   	push   %ebp
c0109159:	89 e5                	mov    %esp,%ebp
c010915b:	83 ec 08             	sub    $0x8,%esp
    (void) argc;
    (void) argv;

    print("%lu\n", pit_ticks());
c010915e:	e8 47 97 ff ff       	call   c01028aa <pit_ticks>
c0109163:	52                   	push   %edx
c0109164:	52                   	push   %edx
c0109165:	50                   	push   %eax
c0109166:	68 61 d0 10 c0       	push   $0xc010d061
c010916b:	e8 54 ac ff ff       	call   c0103dc4 <print>
    return 0;
}
c0109170:	31 c0                	xor    %eax,%eax
c0109172:	c9                   	leave  
c0109173:	c3                   	ret    

c0109174 <_paddr.constprop.0>:
// #define PADDR(a)    (((size_t) a) - KADDR)

#define PADDR(va) _paddr(__FILE__, __LINE__, (void*) va)

static inline size_t
_paddr(const char* file, int line, void* va) {
c0109174:	55                   	push   %ebp
c0109175:	89 e5                	mov    %esp,%ebp
c0109177:	53                   	push   %ebx
c0109178:	51                   	push   %ecx
c0109179:	89 d3                	mov    %edx,%ebx
    if ((uint32_t) va < KADDR)
c010917b:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
c0109181:	77 21                	ja     c01091a4 <_paddr.constprop.0+0x30>
        panic(file, line, "PADDR called with invalid va %08x", va);
c0109183:	52                   	push   %edx
c0109184:	53                   	push   %ebx
c0109185:	68 06 b0 10 c0       	push   $0xc010b006
c010918a:	50                   	push   %eax
c010918b:	68 66 d0 10 c0       	push   $0xc010d066
c0109190:	68 e0 d3 10 c0       	push   $0xc010d3e0
c0109195:	6a 38                	push   $0x38
c0109197:	68 28 b0 10 c0       	push   $0xc010b028
c010919c:	e8 a1 a7 ff ff       	call   c0103942 <_panic>
c01091a1:	83 c4 20             	add    $0x20,%esp
    return (size_t) va - KADDR;
c01091a4:	8d 83 00 00 00 40    	lea    0x40000000(%ebx),%eax
}
c01091aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01091ad:	c9                   	leave  
c01091ae:	c3                   	ret    

c01091af <cmd_meminfo>:
    print_e820_mmap();
    return 0;
}

int
cmd_meminfo(int argc, char* argv[]) {
c01091af:	55                   	push   %ebp
c01091b0:	89 e5                	mov    %esp,%ebp
c01091b2:	53                   	push   %ebx
c01091b3:	83 ec 10             	sub    $0x10,%esp

    extern char _start[], _text[], _etext[], _rodata[], _erodata[],
           _sym_table[], _esym_table[], _stab_strs[], _estab_strs[],
           _data[], _edata[], _bss[], _ebss[], _end[];

    print("\tPhysical Memory Layout:\n");
c01091b6:	68 78 d0 10 c0       	push   $0xc010d078
c01091bb:	e8 04 ac ff ff       	call   c0103dc4 <print>

    print("\t  Lower:\n");
c01091c0:	c7 04 24 92 d0 10 c0 	movl   $0xc010d092,(%esp)
c01091c7:	e8 f8 ab ff ff       	call   c0103dc4 <print>
    print("\t\tbootsector  [ %08p - %08p ]\n",
c01091cc:	83 c4 0c             	add    $0xc,%esp
c01091cf:	68 00 7e 00 00       	push   $0x7e00
c01091d4:	68 00 7c 00 00       	push   $0x7c00
c01091d9:	68 9d d0 10 c0       	push   $0xc010d09d
c01091de:	e8 e1 ab ff ff       	call   c0103dc4 <print>
          0x7c00, 0x7e00);
    print("\t\tmultiboot   [ %08p - %08p ]\n",
          mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);
c01091e3:	a1 e0 76 13 c0       	mov    0xc01376e0,%eax
c01091e8:	8b 50 30             	mov    0x30(%eax),%edx
    print("\tPhysical Memory Layout:\n");

    print("\t  Lower:\n");
    print("\t\tbootsector  [ %08p - %08p ]\n",
          0x7c00, 0x7e00);
    print("\t\tmultiboot   [ %08p - %08p ]\n",
c01091eb:	83 c4 0c             	add    $0xc,%esp
c01091ee:	8b 48 2c             	mov    0x2c(%eax),%ecx
c01091f1:	01 d1                	add    %edx,%ecx
c01091f3:	89 c8                	mov    %ecx,%eax
c01091f5:	48                   	dec    %eax
c01091f6:	50                   	push   %eax
c01091f7:	52                   	push   %edx
c01091f8:	68 bc d0 10 c0       	push   $0xc010d0bc
c01091fd:	e8 c2 ab ff ff       	call   c0103dc4 <print>
          mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);
    print("\t\tmboot info  [ %08p - %08p ]\n",
          mbi, (char*) mbi + sizeof(*mbi));
c0109202:	a1 e0 76 13 c0       	mov    0xc01376e0,%eax
    print("\t  Lower:\n");
    print("\t\tbootsector  [ %08p - %08p ]\n",
          0x7c00, 0x7e00);
    print("\t\tmultiboot   [ %08p - %08p ]\n",
          mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);
    print("\t\tmboot info  [ %08p - %08p ]\n",
c0109207:	83 c4 0c             	add    $0xc,%esp
c010920a:	8d 50 58             	lea    0x58(%eax),%edx
c010920d:	52                   	push   %edx
c010920e:	50                   	push   %eax
c010920f:	68 db d0 10 c0       	push   $0xc010d0db
c0109214:	e8 ab ab ff ff       	call   c0103dc4 <print>
          mbi, (char*) mbi + sizeof(*mbi));
    print("\t\tfree memory [ %08p - %08p ]\n",
          PADDR(FRMEM_MIN), PADDR(FRMEM_MAX) - 1);
c0109219:	ba 00 f0 09 c0       	mov    $0xc009f000,%edx
c010921e:	b8 89 00 00 00       	mov    $0x89,%eax
c0109223:	e8 4c ff ff ff       	call   c0109174 <_paddr.constprop.0>
c0109228:	89 c3                	mov    %eax,%ebx
          0x7c00, 0x7e00);
    print("\t\tmultiboot   [ %08p - %08p ]\n",
          mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);
    print("\t\tmboot info  [ %08p - %08p ]\n",
          mbi, (char*) mbi + sizeof(*mbi));
    print("\t\tfree memory [ %08p - %08p ]\n",
c010922a:	ba 00 00 01 c0       	mov    $0xc0010000,%edx
c010922f:	b8 89 00 00 00       	mov    $0x89,%eax
c0109234:	e8 3b ff ff ff       	call   c0109174 <_paddr.constprop.0>
c0109239:	83 c4 0c             	add    $0xc,%esp
c010923c:	4b                   	dec    %ebx
c010923d:	53                   	push   %ebx
c010923e:	50                   	push   %eax
c010923f:	68 fa d0 10 c0       	push   $0xc010d0fa
c0109244:	e8 7b ab ff ff       	call   c0103dc4 <print>
          PADDR(FRMEM_MIN), PADDR(FRMEM_MAX) - 1);

    print("\t  Kernel:\n");
c0109249:	c7 04 24 19 d1 10 c0 	movl   $0xc010d119,(%esp)
c0109250:	e8 6f ab ff ff       	call   c0103dc4 <print>
    print("\t\ttext        [ %08p - %08p ]\n",
c0109255:	ba 65 a9 10 c0       	mov    $0xc010a965,%edx
c010925a:	b8 8d 00 00 00       	mov    $0x8d,%eax
c010925f:	e8 10 ff ff ff       	call   c0109174 <_paddr.constprop.0>
c0109264:	89 c3                	mov    %eax,%ebx
c0109266:	ba 00 00 10 c0       	mov    $0xc0100000,%edx
c010926b:	b8 8d 00 00 00       	mov    $0x8d,%eax
c0109270:	e8 ff fe ff ff       	call   c0109174 <_paddr.constprop.0>
c0109275:	83 c4 0c             	add    $0xc,%esp
c0109278:	53                   	push   %ebx
c0109279:	50                   	push   %eax
c010927a:	68 25 d1 10 c0       	push   $0xc010d125
c010927f:	e8 40 ab ff ff       	call   c0103dc4 <print>
          PADDR(_text), PADDR(_etext));
    print("\t\trodata      [ %08p - %08p ]\n",
c0109284:	ba e7 d7 10 c0       	mov    $0xc010d7e7,%edx
c0109289:	b8 8f 00 00 00       	mov    $0x8f,%eax
c010928e:	e8 e1 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c0109293:	89 c3                	mov    %eax,%ebx
c0109295:	ba 80 a9 10 c0       	mov    $0xc010a980,%edx
c010929a:	b8 8f 00 00 00       	mov    $0x8f,%eax
c010929f:	e8 d0 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c01092a4:	83 c4 0c             	add    $0xc,%esp
c01092a7:	53                   	push   %ebx
c01092a8:	50                   	push   %eax
c01092a9:	68 44 d1 10 c0       	push   $0xc010d144
c01092ae:	e8 11 ab ff ff       	call   c0103dc4 <print>
          PADDR(_rodata), PADDR(_erodata));
    print("\t\tsym table   [ %08p - %08p ]\n",
c01092b3:	ba 34 44 12 c0       	mov    $0xc0124434,%edx
c01092b8:	b8 91 00 00 00       	mov    $0x91,%eax
c01092bd:	e8 b2 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c01092c2:	89 c3                	mov    %eax,%ebx
c01092c4:	ba 00 e0 10 c0       	mov    $0xc010e000,%edx
c01092c9:	b8 91 00 00 00       	mov    $0x91,%eax
c01092ce:	e8 a1 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c01092d3:	83 c4 0c             	add    $0xc,%esp
c01092d6:	53                   	push   %ebx
c01092d7:	50                   	push   %eax
c01092d8:	68 63 d1 10 c0       	push   $0xc010d163
c01092dd:	e8 e2 aa ff ff       	call   c0103dc4 <print>
          PADDR(_sym_table), PADDR(_esym_table));
    print("\t\tstab strs   [ %08p - %08p ]\n",
c01092e2:	ba 90 bf 12 c0       	mov    $0xc012bf90,%edx
c01092e7:	b8 93 00 00 00       	mov    $0x93,%eax
c01092ec:	e8 83 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c01092f1:	89 c3                	mov    %eax,%ebx
c01092f3:	ba 35 44 12 c0       	mov    $0xc0124435,%edx
c01092f8:	b8 93 00 00 00       	mov    $0x93,%eax
c01092fd:	e8 72 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c0109302:	83 c4 0c             	add    $0xc,%esp
c0109305:	53                   	push   %ebx
c0109306:	50                   	push   %eax
c0109307:	68 82 d1 10 c0       	push   $0xc010d182
c010930c:	e8 b3 aa ff ff       	call   c0103dc4 <print>
          PADDR(_stab_strs), PADDR(_estab_strs));
    print("\t\tdata        [ %08p - %08p ]\n",
c0109311:	ba 20 53 13 c0       	mov    $0xc0135320,%edx
c0109316:	b8 95 00 00 00       	mov    $0x95,%eax
c010931b:	e8 54 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c0109320:	89 c3                	mov    %eax,%ebx
c0109322:	ba 00 c0 12 c0       	mov    $0xc012c000,%edx
c0109327:	b8 95 00 00 00       	mov    $0x95,%eax
c010932c:	e8 43 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c0109331:	83 c4 0c             	add    $0xc,%esp
c0109334:	53                   	push   %ebx
c0109335:	50                   	push   %eax
c0109336:	68 a1 d1 10 c0       	push   $0xc010d1a1
c010933b:	e8 84 aa ff ff       	call   c0103dc4 <print>
          PADDR(_data), PADDR(_edata));
    print("\t\tbss         [ %08p - %08p ]\n",
c0109340:	ba 08 80 17 c0       	mov    $0xc0178008,%edx
c0109345:	b8 97 00 00 00       	mov    $0x97,%eax
c010934a:	e8 25 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c010934f:	89 c3                	mov    %eax,%ebx
c0109351:	ba 00 60 13 c0       	mov    $0xc0136000,%edx
c0109356:	b8 97 00 00 00       	mov    $0x97,%eax
c010935b:	e8 14 fe ff ff       	call   c0109174 <_paddr.constprop.0>
c0109360:	83 c4 0c             	add    $0xc,%esp
c0109363:	53                   	push   %ebx
c0109364:	50                   	push   %eax
c0109365:	68 c0 d1 10 c0       	push   $0xc010d1c0
c010936a:	e8 55 aa ff ff       	call   c0103dc4 <print>
          PADDR(_bss), PADDR(_ebss));
    print("\t  Kernel executable footprint: %luKB\n",
          (PADDR(_end) - (size_t) _start) >> 10);
c010936f:	ba 00 90 17 c0       	mov    $0xc0179000,%edx
c0109374:	b8 99 00 00 00       	mov    $0x99,%eax
c0109379:	e8 f6 fd ff ff       	call   c0109174 <_paddr.constprop.0>
          PADDR(_stab_strs), PADDR(_estab_strs));
    print("\t\tdata        [ %08p - %08p ]\n",
          PADDR(_data), PADDR(_edata));
    print("\t\tbss         [ %08p - %08p ]\n",
          PADDR(_bss), PADDR(_ebss));
    print("\t  Kernel executable footprint: %luKB\n",
c010937e:	5a                   	pop    %edx
c010937f:	59                   	pop    %ecx
c0109380:	2d 0c 00 10 00       	sub    $0x10000c,%eax
c0109385:	c1 e8 0a             	shr    $0xa,%eax
c0109388:	50                   	push   %eax
c0109389:	68 df d1 10 c0       	push   $0xc010d1df
c010938e:	e8 31 aa ff ff       	call   c0103dc4 <print>
          (PADDR(_end) - (size_t) _start) >> 10);

    return 0;
}
c0109393:	31 c0                	xor    %eax,%eax
c0109395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0109398:	c9                   	leave  
c0109399:	c3                   	ret    

c010939a <putc>:
    outb(0x64, 0xFE);
    return 0;
}

void
putc(const char c) {
c010939a:	55                   	push   %ebp
c010939b:	89 e5                	mov    %esp,%ebp
c010939d:	53                   	push   %ebx
c010939e:	83 ec 10             	sub    $0x10,%esp
    putc_serial(c);
c01093a1:	0f be 5d 08          	movsbl 0x8(%ebp),%ebx
c01093a5:	53                   	push   %ebx
c01093a6:	e8 e6 95 ff ff       	call   c0102991 <putc_serial>
    // putc_lpt(c);
    putc_cga(c);
c01093ab:	83 c4 10             	add    $0x10,%esp
c01093ae:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
c01093b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01093b4:	c9                   	leave  

void
putc(const char c) {
    putc_serial(c);
    // putc_lpt(c);
    putc_cga(c);
c01093b5:	e9 36 8c ff ff       	jmp    c0101ff0 <putc_cga>

c01093ba <puts>:
}

void
puts(const char* text) {
c01093ba:	55                   	push   %ebp
c01093bb:	89 e5                	mov    %esp,%ebp
c01093bd:	56                   	push   %esi
c01093be:	53                   	push   %ebx
c01093bf:	8b 75 08             	mov    0x8(%ebp),%esi
    size_t i;
    for (i = 0; i < strlen(text); ++i)
c01093c2:	31 db                	xor    %ebx,%ebx
c01093c4:	83 ec 0c             	sub    $0xc,%esp
c01093c7:	56                   	push   %esi
c01093c8:	e8 2a af ff ff       	call   c01042f7 <strlen>
c01093cd:	83 c4 10             	add    $0x10,%esp
c01093d0:	39 c3                	cmp    %eax,%ebx
c01093d2:	73 13                	jae    c01093e7 <puts+0x2d>
        putc(text[i]);
c01093d4:	83 ec 0c             	sub    $0xc,%esp
c01093d7:	0f be 04 1e          	movsbl (%esi,%ebx,1),%eax
c01093db:	50                   	push   %eax
c01093dc:	e8 b9 ff ff ff       	call   c010939a <putc>
}

void
puts(const char* text) {
    size_t i;
    for (i = 0; i < strlen(text); ++i)
c01093e1:	43                   	inc    %ebx
c01093e2:	83 c4 10             	add    $0x10,%esp
c01093e5:	eb dd                	jmp    c01093c4 <puts+0xa>
        putc(text[i]);
}
c01093e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01093ea:	5b                   	pop    %ebx
c01093eb:	5e                   	pop    %esi
c01093ec:	5d                   	pop    %ebp
c01093ed:	c3                   	ret    

c01093ee <getc>:

char
getc(void) {
c01093ee:	55                   	push   %ebp
c01093ef:	89 e5                	mov    %esp,%ebp
    if (console.rpos != console.wpos) {
c01093f1:	8b 15 b0 76 13 c0    	mov    0xc01376b0,%edx
        char c = console.buf[console.rpos++];
        if (console.rpos == CONSBUFSIZE)
            console.rpos = 0;
        return c;
    }
    return 0;
c01093f7:	31 c0                	xor    %eax,%eax
        putc(text[i]);
}

char
getc(void) {
    if (console.rpos != console.wpos) {
c01093f9:	3b 15 b4 76 13 c0    	cmp    0xc01376b4,%edx
c01093ff:	74 21                	je     c0109422 <getc+0x34>
        char c = console.buf[console.rpos++];
c0109401:	8d 4a 01             	lea    0x1(%edx),%ecx
c0109404:	89 0d b0 76 13 c0    	mov    %ecx,0xc01376b0
c010940a:	8a 82 e0 6e 13 c0    	mov    -0x3fec9120(%edx),%al
        if (console.rpos == CONSBUFSIZE)
c0109410:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
c0109416:	75 0a                	jne    c0109422 <getc+0x34>
            console.rpos = 0;
c0109418:	c7 05 b0 76 13 c0 00 	movl   $0x0,0xc01376b0
c010941f:	00 00 00 
        return c;
    }
    return 0;
}
c0109422:	5d                   	pop    %ebp
c0109423:	c3                   	ret    

c0109424 <readline>:

#define BUFLEN 1024

char*
readline(void) {
c0109424:	55                   	push   %ebp
c0109425:	89 e5                	mov    %esp,%ebp
c0109427:	56                   	push   %esi
c0109428:	53                   	push   %ebx
    static char buf[BUFLEN];

    int i = 0;
c0109429:	31 f6                	xor    %esi,%esi
    while (1) {
        char c = getc();
c010942b:	e8 be ff ff ff       	call   c01093ee <getc>
c0109430:	88 c3                	mov    %al,%bl
        if (c < 0)
c0109432:	84 c0                	test   %al,%al
c0109434:	78 6c                	js     c01094a2 <readline+0x7e>
            return NULL;
        else if ((c == '\b' || c == '\x7f') && i > 0) {
c0109436:	3c 7f                	cmp    $0x7f,%al
c0109438:	74 04                	je     c010943e <readline+0x1a>
c010943a:	3c 08                	cmp    $0x8,%al
c010943c:	75 14                	jne    c0109452 <readline+0x2e>
c010943e:	85 f6                	test   %esi,%esi
c0109440:	74 34                	je     c0109476 <readline+0x52>
            putc('\b');
c0109442:	83 ec 0c             	sub    $0xc,%esp
c0109445:	6a 08                	push   $0x8
c0109447:	e8 4e ff ff ff       	call   c010939a <putc>
            i--;
c010944c:	4e                   	dec    %esi
c010944d:	83 c4 10             	add    $0x10,%esp
c0109450:	eb d9                	jmp    c010942b <readline+0x7>
        } else if (c >= ' ' && i < BUFLEN - 1) {
c0109452:	3c 1f                	cmp    $0x1f,%al
c0109454:	7e 25                	jle    c010947b <readline+0x57>
c0109456:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
c010945c:	7f 3d                	jg     c010949b <readline+0x77>
            putc(c);
c010945e:	83 ec 0c             	sub    $0xc,%esp
c0109461:	0f be c3             	movsbl %bl,%eax
c0109464:	50                   	push   %eax
c0109465:	e8 30 ff ff ff       	call   c010939a <putc>
            buf[i++] = c;
c010946a:	88 9e c0 69 13 c0    	mov    %bl,-0x3fec9640(%esi)
c0109470:	83 c4 10             	add    $0x10,%esp
c0109473:	46                   	inc    %esi
c0109474:	eb b5                	jmp    c010942b <readline+0x7>
        if (c < 0)
            return NULL;
        else if ((c == '\b' || c == '\x7f') && i > 0) {
            putc('\b');
            i--;
        } else if (c >= ' ' && i < BUFLEN - 1) {
c0109476:	80 fb 1f             	cmp    $0x1f,%bl
c0109479:	7f e3                	jg     c010945e <readline+0x3a>
            putc(c);
            buf[i++] = c;
        } else if (c == '\n' || c == '\r') {
c010947b:	80 fb 0a             	cmp    $0xa,%bl
c010947e:	75 1b                	jne    c010949b <readline+0x77>
            putc('\n');
c0109480:	83 ec 0c             	sub    $0xc,%esp
c0109483:	6a 0a                	push   $0xa
c0109485:	e8 10 ff ff ff       	call   c010939a <putc>
            buf[i] = 0;
c010948a:	c6 86 c0 69 13 c0 00 	movb   $0x0,-0x3fec9640(%esi)
            return buf;
c0109491:	83 c4 10             	add    $0x10,%esp
c0109494:	b8 c0 69 13 c0       	mov    $0xc01369c0,%eax
c0109499:	eb 09                	jmp    c01094a4 <readline+0x80>
            putc('\b');
            i--;
        } else if (c >= ' ' && i < BUFLEN - 1) {
            putc(c);
            buf[i++] = c;
        } else if (c == '\n' || c == '\r') {
c010949b:	80 fb 0d             	cmp    $0xd,%bl
c010949e:	75 8b                	jne    c010942b <readline+0x7>
c01094a0:	eb de                	jmp    c0109480 <readline+0x5c>

    int i = 0;
    while (1) {
        char c = getc();
        if (c < 0)
            return NULL;
c01094a2:	31 c0                	xor    %eax,%eax
            putc('\n');
            buf[i] = 0;
            return buf;
        }
    }
}
c01094a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01094a7:	5b                   	pop    %ebx
c01094a8:	5e                   	pop    %esi
c01094a9:	5d                   	pop    %ebp
c01094aa:	c3                   	ret    

c01094ab <prompt>:
    print("Unknown command '%s'\n", argv[0]);
    return 0;
}

void
prompt(void) {
c01094ab:	55                   	push   %ebp
c01094ac:	89 e5                	mov    %esp,%ebp
c01094ae:	57                   	push   %edi
c01094af:	56                   	push   %esi
c01094b0:	53                   	push   %ebx
c01094b1:	83 ec 4c             	sub    $0x4c,%esp
    if (crt.pos != 0)
c01094b4:	66 83 3d bc 76 13 c0 	cmpw   $0x0,0xc01376bc
c01094bb:	00 
c01094bc:	74 10                	je     c01094ce <prompt+0x23>
        print("\n");
c01094be:	83 ec 0c             	sub    $0xc,%esp
c01094c1:	68 c9 ae 10 c0       	push   $0xc010aec9
c01094c6:	e8 f9 a8 ff ff       	call   c0103dc4 <print>
c01094cb:	83 c4 10             	add    $0x10,%esp
    print("<j> ");
c01094ce:	83 ec 0c             	sub    $0xc,%esp
c01094d1:	68 06 d2 10 c0       	push   $0xc010d206
c01094d6:	e8 e9 a8 ff ff       	call   c0103dc4 <print>
    char* buf = readline();
c01094db:	e8 44 ff ff ff       	call   c0109424 <readline>
c01094e0:	89 c3                	mov    %eax,%ebx
    if (buf != NULL)
c01094e2:	83 c4 10             	add    $0x10,%esp
c01094e5:	85 c0                	test   %eax,%eax
c01094e7:	0f 84 be 00 00 00    	je     c01095ab <prompt+0x100>

static int
runcmd(char* buf) {
    // Parse the command buffer into whitespace-separated arguments
    int argc = 0;
    char* argv[MAXARGS] = {0};
c01094ed:	8d 7d a8             	lea    -0x58(%ebp),%edi
c01094f0:	b9 10 00 00 00       	mov    $0x10,%ecx
c01094f5:	31 c0                	xor    %eax,%eax
c01094f7:	f3 ab                	rep stos %eax,%es:(%edi)
#define MAXARGS 16

static int
runcmd(char* buf) {
    // Parse the command buffer into whitespace-separated arguments
    int argc = 0;
c01094f9:	31 f6                	xor    %esi,%esi
    char* argv[MAXARGS] = {0};

    for (;;) {
        // gobble whitespace
        while (*buf && strchr(WHITESPACE, *buf))
c01094fb:	0f be 03             	movsbl (%ebx),%eax
c01094fe:	84 c0                	test   %al,%al
c0109500:	75 07                	jne    c0109509 <prompt+0x5e>
            *buf++ = 0;
        if (*buf == 0)
c0109502:	80 3b 00             	cmpb   $0x0,(%ebx)
c0109505:	75 20                	jne    c0109527 <prompt+0x7c>
c0109507:	eb 53                	jmp    c010955c <prompt+0xb1>
    int argc = 0;
    char* argv[MAXARGS] = {0};

    for (;;) {
        // gobble whitespace
        while (*buf && strchr(WHITESPACE, *buf))
c0109509:	52                   	push   %edx
c010950a:	52                   	push   %edx
c010950b:	50                   	push   %eax
c010950c:	68 0b d2 10 c0       	push   $0xc010d20b
c0109511:	e8 2a ae ff ff       	call   c0104340 <strchr>
c0109516:	83 c4 10             	add    $0x10,%esp
c0109519:	85 c0                	test   %eax,%eax
c010951b:	74 e5                	je     c0109502 <prompt+0x57>
            *buf++ = 0;
c010951d:	c6 03 00             	movb   $0x0,(%ebx)
c0109520:	89 f7                	mov    %esi,%edi
c0109522:	43                   	inc    %ebx
c0109523:	89 fe                	mov    %edi,%esi
c0109525:	eb d4                	jmp    c01094fb <prompt+0x50>
        if (*buf == 0)
            break;

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0109527:	83 fe 0f             	cmp    $0xf,%esi
c010952a:	75 0b                	jne    c0109537 <prompt+0x8c>
            print("Too many arguments (max %d)\n", MAXARGS);
c010952c:	57                   	push   %edi
c010952d:	57                   	push   %edi
c010952e:	6a 10                	push   $0x10
c0109530:	68 10 d2 10 c0       	push   $0xc010d210
c0109535:	eb 6c                	jmp    c01095a3 <prompt+0xf8>
            return 0;
        }
        argv[argc++] = buf;
c0109537:	8d 7e 01             	lea    0x1(%esi),%edi
c010953a:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
        while (*buf && !strchr(WHITESPACE, *buf))
c010953e:	0f be 03             	movsbl (%ebx),%eax
c0109541:	84 c0                	test   %al,%al
c0109543:	74 de                	je     c0109523 <prompt+0x78>
c0109545:	56                   	push   %esi
c0109546:	56                   	push   %esi
c0109547:	50                   	push   %eax
c0109548:	68 0b d2 10 c0       	push   $0xc010d20b
c010954d:	e8 ee ad ff ff       	call   c0104340 <strchr>
c0109552:	83 c4 10             	add    $0x10,%esp
c0109555:	85 c0                	test   %eax,%eax
c0109557:	75 ca                	jne    c0109523 <prompt+0x78>
            buf++;
c0109559:	43                   	inc    %ebx
c010955a:	eb e2                	jmp    c010953e <prompt+0x93>
    }
    argv[argc] = 0;
c010955c:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
c0109563:	00 

    // Lookup and invoke the command
    if (argc == 0)
c0109564:	85 f6                	test   %esi,%esi
c0109566:	74 43                	je     c01095ab <prompt+0x100>
c0109568:	31 db                	xor    %ebx,%ebx
        return 0;

    static const size_t ncmds = ARRAY_SIZE(cmds);
    for (size_t i = 0; i < ncmds; i++)
        if (strcmp(argv[0], cmds[i].name) == 0)
c010956a:	51                   	push   %ecx
c010956b:	51                   	push   %ecx
c010956c:	6b fb 0c             	imul   $0xc,%ebx,%edi
c010956f:	ff b7 00 d4 10 c0    	pushl  -0x3fef2c00(%edi)
c0109575:	ff 75 a8             	pushl  -0x58(%ebp)
c0109578:	e8 18 ae ff ff       	call   c0104395 <strcmp>
c010957d:	83 c4 10             	add    $0x10,%esp
c0109580:	85 c0                	test   %eax,%eax
c0109582:	75 0f                	jne    c0109593 <prompt+0xe8>
            return cmds[i].func(argc, argv);
c0109584:	52                   	push   %edx
c0109585:	52                   	push   %edx
c0109586:	8d 45 a8             	lea    -0x58(%ebp),%eax
c0109589:	50                   	push   %eax
c010958a:	56                   	push   %esi
c010958b:	ff 97 08 d4 10 c0    	call   *-0x3fef2bf8(%edi)
c0109591:	eb 15                	jmp    c01095a8 <prompt+0xfd>
    // Lookup and invoke the command
    if (argc == 0)
        return 0;

    static const size_t ncmds = ARRAY_SIZE(cmds);
    for (size_t i = 0; i < ncmds; i++)
c0109593:	43                   	inc    %ebx
c0109594:	83 fb 09             	cmp    $0x9,%ebx
c0109597:	75 d1                	jne    c010956a <prompt+0xbf>
        if (strcmp(argv[0], cmds[i].name) == 0)
            return cmds[i].func(argc, argv);

    print("Unknown command '%s'\n", argv[0]);
c0109599:	50                   	push   %eax
c010959a:	50                   	push   %eax
c010959b:	ff 75 a8             	pushl  -0x58(%ebp)
c010959e:	68 2d d2 10 c0       	push   $0xc010d22d
c01095a3:	e8 1c a8 ff ff       	call   c0103dc4 <print>
c01095a8:	83 c4 10             	add    $0x10,%esp
    print("<j> ");
    char* buf = readline();
    if (buf != NULL)
        if (runcmd(buf) < 0)
            return;
}
c01095ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01095ae:	5b                   	pop    %ebx
c01095af:	5e                   	pop    %esi
c01095b0:	5f                   	pop    %edi
c01095b1:	5d                   	pop    %ebp
c01095b2:	c3                   	ret    

c01095b3 <wait_and_set>:

/*
 * Helper function that does nothing for a while,
 * then updates cv_var to 1
 */
int wait_and_set(void* stuff, unsigned long num) {
c01095b3:	55                   	push   %ebp
c01095b4:	89 e5                	mov    %esp,%ebp
    (void) stuff;
    (void) num;

    cv_var = 1;
c01095b6:	c7 05 2c 6e 13 c0 01 	movl   $0x1,0xc0136e2c
c01095bd:	00 00 00 
    return 0;
}
c01095c0:	31 c0                	xor    %eax,%eax
c01095c2:	5d                   	pop    %ebp
c01095c3:	c3                   	ret    

c01095c4 <thread_return>:
    for (int i = 0; i < 2 * NTHREADS; ++i)
        array[i] = i;
}

int
thread_return(void* stuff, unsigned long num) {
c01095c4:	55                   	push   %ebp
c01095c5:	89 e5                	mov    %esp,%ebp
    (void) stuff;
    (void) num;

    return 0;
}
c01095c7:	31 c0                	xor    %eax,%eax
c01095c9:	5d                   	pop    %ebp
c01095ca:	c3                   	ret    

c01095cb <return_one>:

// each thread returns the value 1 and the result will be summed and verified to
// match NTHREADS
int return_one(void* data1, unsigned long data2) {
c01095cb:	55                   	push   %ebp
c01095cc:	89 e5                	mov    %esp,%ebp
    (void) data1;
    (void) data2;

    return 1;
}
c01095ce:	b8 01 00 00 00       	mov    $0x1,%eax
c01095d3:	5d                   	pop    %ebp
c01095d4:	c3                   	ret    

c01095d5 <sum_array>:

// each thread will sum and return two elements from the array and the total
// returned from all threads will be checks to equal the expected value
int sum_array(void* data1, unsigned long data2) {
c01095d5:	55                   	push   %ebp
c01095d6:	89 e5                	mov    %esp,%ebp
c01095d8:	8b 55 0c             	mov    0xc(%ebp),%edx
    (void) data1;

    return array[data2] + array[data2 + NTHREADS];
c01095db:	8b 0c 95 e0 6d 13 c0 	mov    -0x3fec9220(,%edx,4),%ecx
c01095e2:	83 c2 08             	add    $0x8,%edx
c01095e5:	8b 04 95 e0 6d 13 c0 	mov    -0x3fec9220(,%edx,4),%eax
c01095ec:	01 c8                	add    %ecx,%eax
}
c01095ee:	5d                   	pop    %ebp
c01095ef:	c3                   	ret    

c01095f0 <threadtester>:

// this accepts a test number and administers the corresponding thread_join test
int threadtester(int test) {
c01095f0:	55                   	push   %ebp
c01095f1:	89 e5                	mov    %esp,%ebp
c01095f3:	57                   	push   %edi
c01095f4:	56                   	push   %esi
c01095f5:	53                   	push   %ebx
c01095f6:	83 ec 4c             	sub    $0x4c,%esp
    if (test == 1)
c01095f9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01095fd:	74 1d                	je     c010961c <threadtester+0x2c>
        init_array();
    char name[16] = {'\0'};
c01095ff:	8d 7d b8             	lea    -0x48(%ebp),%edi
c0109602:	b9 04 00 00 00       	mov    $0x4,%ecx
c0109607:	31 c0                	xor    %eax,%eax
c0109609:	f3 ab                	rep stos %eax,%es:(%edi)
    struct thread* t[NTHREADS];
    int tot = 0;
    int tret = 0;
c010960b:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
c0109612:	8d 75 c8             	lea    -0x38(%ebp),%esi
    int sum = 0;
    int ret = 0;

    for (int i = 0; i < NTHREADS; ++i) {
c0109615:	31 db                	xor    %ebx,%ebx
c0109617:	8d 7d b8             	lea    -0x48(%ebp),%edi
c010961a:	eb 6a                	jmp    c0109686 <threadtester+0x96>
c010961c:	31 c0                	xor    %eax,%eax
#define NTHREADS 8

static volatile int array[2 * NTHREADS];
static void init_array(void) {
    for (int i = 0; i < 2 * NTHREADS; ++i)
        array[i] = i;
c010961e:	89 04 85 e0 6d 13 c0 	mov    %eax,-0x3fec9220(,%eax,4)
//////////////////////////////////////*/
#define NTHREADS 8

static volatile int array[2 * NTHREADS];
static void init_array(void) {
    for (int i = 0; i < 2 * NTHREADS; ++i)
c0109625:	40                   	inc    %eax
c0109626:	83 f8 10             	cmp    $0x10,%eax
c0109629:	75 f3                	jne    c010961e <threadtester+0x2e>
c010962b:	eb d2                	jmp    c01095ff <threadtester+0xf>
    int sum = 0;
    int ret = 0;

    for (int i = 0; i < NTHREADS; ++i) {
        snprintf(name, sizeof(name), "threadtester%d", i);
        switch (test) {
c010962d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
c0109631:	0f 84 91 00 00 00    	je     c01096c8 <threadtester+0xd8>
c0109637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010963b:	0f 85 18 01 00 00    	jne    c0109759 <threadtester+0x169>
            case 0:
                ret = thread_fork("test_fork", NULL, NULL, thread_return, NULL, 0);
c0109641:	50                   	push   %eax
c0109642:	50                   	push   %eax
c0109643:	6a 00                	push   $0x0
c0109645:	6a 00                	push   $0x0
c0109647:	68 c4 95 10 c0       	push   $0xc01095c4
c010964c:	6a 00                	push   $0x0
c010964e:	6a 00                	push   $0x0
c0109650:	68 7b d4 10 c0       	push   $0xc010d47b
c0109655:	e8 33 d9 ff ff       	call   c0106f8d <thread_fork>
                if (ret)
c010965a:	83 c4 20             	add    $0x20,%esp
c010965d:	85 c0                	test   %eax,%eax
c010965f:	74 1c                	je     c010967d <threadtester+0x8d>
                    panic("ERROR: in thread_fork");
c0109661:	68 85 d4 10 c0       	push   $0xc010d485
c0109666:	68 c8 d7 10 c0       	push   $0xc010d7c8
c010966b:	68 52 01 00 00       	push   $0x152
                    panic("threadtester: thread_fork failed\n");
                break;
            case 2:
                ret = thread_fork(name, &t[i], NULL, sum_array, NULL, i);
                if (ret)
                    panic("threadtester: thread_fork failed\n");
c0109670:	68 9b d4 10 c0       	push   $0xc010d49b
c0109675:	e8 c8 a2 ff ff       	call   c0103942 <_panic>
c010967a:	83 c4 10             	add    $0x10,%esp
    int tot = 0;
    int tret = 0;
    int sum = 0;
    int ret = 0;

    for (int i = 0; i < NTHREADS; ++i) {
c010967d:	43                   	inc    %ebx
c010967e:	83 c6 04             	add    $0x4,%esi
c0109681:	83 fb 08             	cmp    $0x8,%ebx
c0109684:	74 70                	je     c01096f6 <threadtester+0x106>
        snprintf(name, sizeof(name), "threadtester%d", i);
c0109686:	53                   	push   %ebx
c0109687:	68 6c d4 10 c0       	push   $0xc010d46c
c010968c:	6a 10                	push   $0x10
c010968e:	57                   	push   %edi
c010968f:	e8 2d ac ff ff       	call   c01042c1 <snprintf>
        switch (test) {
c0109694:	83 c4 10             	add    $0x10,%esp
c0109697:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010969b:	75 90                	jne    c010962d <threadtester+0x3d>
                ret = thread_fork("test_fork", NULL, NULL, thread_return, NULL, 0);
                if (ret)
                    panic("ERROR: in thread_fork");
                break;
            case 1:
                ret = thread_fork(name, &t[i], NULL, return_one, NULL, i);
c010969d:	51                   	push   %ecx
c010969e:	51                   	push   %ecx
c010969f:	53                   	push   %ebx
c01096a0:	6a 00                	push   $0x0
c01096a2:	68 cb 95 10 c0       	push   $0xc01095cb
c01096a7:	6a 00                	push   $0x0
c01096a9:	56                   	push   %esi
c01096aa:	57                   	push   %edi
c01096ab:	e8 dd d8 ff ff       	call   c0106f8d <thread_fork>
                if (ret)
c01096b0:	83 c4 20             	add    $0x20,%esp
c01096b3:	85 c0                	test   %eax,%eax
c01096b5:	74 c6                	je     c010967d <threadtester+0x8d>
                    panic("threadtester: thread_fork failed\n");
c01096b7:	68 a8 d4 10 c0       	push   $0xc010d4a8
c01096bc:	68 c8 d7 10 c0       	push   $0xc010d7c8
c01096c1:	68 57 01 00 00       	push   $0x157
c01096c6:	eb a8                	jmp    c0109670 <threadtester+0x80>
                break;
            case 2:
                ret = thread_fork(name, &t[i], NULL, sum_array, NULL, i);
c01096c8:	52                   	push   %edx
c01096c9:	52                   	push   %edx
c01096ca:	53                   	push   %ebx
c01096cb:	6a 00                	push   $0x0
c01096cd:	68 d5 95 10 c0       	push   $0xc01095d5
c01096d2:	6a 00                	push   $0x0
c01096d4:	56                   	push   %esi
c01096d5:	57                   	push   %edi
c01096d6:	e8 b2 d8 ff ff       	call   c0106f8d <thread_fork>
                if (ret)
c01096db:	83 c4 20             	add    $0x20,%esp
c01096de:	85 c0                	test   %eax,%eax
c01096e0:	74 9b                	je     c010967d <threadtester+0x8d>
                    panic("threadtester: thread_fork failed\n");
c01096e2:	68 a8 d4 10 c0       	push   $0xc010d4a8
c01096e7:	68 c8 d7 10 c0       	push   $0xc010d7c8
c01096ec:	68 5c 01 00 00       	push   $0x15c
c01096f1:	e9 7a ff ff ff       	jmp    c0109670 <threadtester+0x80>
        }
    }

    switch (test) {
        case 0:
            return 0;
c01096f6:	31 c0                	xor    %eax,%eax
            default:
                return 0;
        }
    }

    if (test != 0) {
c01096f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01096fc:	74 5d                	je     c010975b <threadtester+0x16b>
c01096fe:	31 db                	xor    %ebx,%ebx
c0109700:	31 ff                	xor    %edi,%edi
        for (int i = 0; i < NTHREADS; ++i) {
            ret = thread_join(t[i], &tret);
c0109702:	8d 75 b4             	lea    -0x4c(%ebp),%esi
c0109705:	50                   	push   %eax
c0109706:	50                   	push   %eax
c0109707:	56                   	push   %esi
c0109708:	ff 74 9d c8          	pushl  -0x38(%ebp,%ebx,4)
c010970c:	e8 90 d6 ff ff       	call   c0106da1 <thread_join>
            if (ret)
c0109711:	83 c4 10             	add    $0x10,%esp
c0109714:	85 c0                	test   %eax,%eax
c0109716:	74 1c                	je     c0109734 <threadtester+0x144>
                panic("threadtester: thread_join failed\n");
c0109718:	68 ca d4 10 c0       	push   $0xc010d4ca
c010971d:	68 c8 d7 10 c0       	push   $0xc010d7c8
c0109722:	68 67 01 00 00       	push   $0x167
c0109727:	68 9b d4 10 c0       	push   $0xc010d49b
c010972c:	e8 11 a2 ff ff       	call   c0103942 <_panic>
c0109731:	83 c4 10             	add    $0x10,%esp
            tot += tret;
c0109734:	03 7d b4             	add    -0x4c(%ebp),%edi
                return 0;
        }
    }

    if (test != 0) {
        for (int i = 0; i < NTHREADS; ++i) {
c0109737:	43                   	inc    %ebx
c0109738:	83 fb 08             	cmp    $0x8,%ebx
c010973b:	75 c8                	jne    c0109705 <threadtester+0x115>
                panic("threadtester: thread_join failed\n");
            tot += tret;
        }
    }

    switch (test) {
c010973d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0109741:	74 0b                	je     c010974e <threadtester+0x15e>
c0109743:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
c0109747:	75 10                	jne    c0109759 <threadtester+0x169>
        case 1:
            return tot != NTHREADS;
        case 2:
            for (int i = 0; i < 2 * NTHREADS; ++i)
                sum += i;
            return tot != sum;
c0109749:	83 ff 78             	cmp    $0x78,%edi
c010974c:	eb 03                	jmp    c0109751 <threadtester+0x161>

    switch (test) {
        case 0:
            return 0;
        case 1:
            return tot != NTHREADS;
c010974e:	83 ff 08             	cmp    $0x8,%edi
        case 2:
            for (int i = 0; i < 2 * NTHREADS; ++i)
                sum += i;
            return tot != sum;
c0109751:	0f 95 c0             	setne  %al
c0109754:	0f b6 c0             	movzbl %al,%eax
c0109757:	eb 02                	jmp    c010975b <threadtester+0x16b>
        }
    }

    switch (test) {
        case 0:
            return 0;
c0109759:	31 c0                	xor    %eax,%eax
                sum += i;
            return tot != sum;
        default:
            return 0;
    }
}
c010975b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010975e:	5b                   	pop    %ebx
c010975f:	5e                   	pop    %esi
c0109760:	5f                   	pop    %edi
c0109761:	5d                   	pop    %ebp
c0109762:	c3                   	ret    

c0109763 <locktester_array_thread>:

    return 0;
}

// entry point function for threads in locktester_array
static int locktester_array_thread(void *junk, unsigned long num) {
c0109763:	55                   	push   %ebp
c0109764:	89 e5                	mov    %esp,%ebp
c0109766:	83 ec 14             	sub    $0x14,%esp
    (void) junk;
    lock_acquire(testlock);
c0109769:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c010976f:	e8 5b 96 ff ff       	call   c0102dcf <lock_acquire>
    testarray[num] = true;
c0109774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109777:	03 05 20 6e 13 c0    	add    0xc0136e20,%eax
c010977d:	c6 00 01             	movb   $0x1,(%eax)
    lock_release(testlock);
c0109780:	58                   	pop    %eax
c0109781:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109787:	e8 ab 97 ff ff       	call   c0102f37 <lock_release>
    return 0;
}
c010978c:	31 c0                	xor    %eax,%eax
c010978e:	c9                   	leave  
c010978f:	c3                   	ret    

c0109790 <signal_sleep>:

/*
 * Helper function that puts a thread to sleep on test_cv's
 * wait channel and once awoken, increments signal_wakes by 1
 */
int signal_sleep(void* stuff, unsigned long num) {
c0109790:	55                   	push   %ebp
c0109791:	89 e5                	mov    %esp,%ebp
c0109793:	83 ec 14             	sub    $0x14,%esp
    (void) stuff;
    (void) num;

    // Put the thread on testcv's wait channel
    spinlock_acquire(&test_cv->cv_splock);
c0109796:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c010979b:	83 c0 08             	add    $0x8,%eax
c010979e:	50                   	push   %eax
c010979f:	e8 53 9b ff ff       	call   c01032f7 <spinlock_acquire>
    wchan_sleep(test_cv->cv_wchan, &test_cv->cv_splock);
c01097a4:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c01097a9:	5a                   	pop    %edx
c01097aa:	59                   	pop    %ecx
c01097ab:	8d 50 08             	lea    0x8(%eax),%edx
c01097ae:	52                   	push   %edx
c01097af:	ff 70 04             	pushl  0x4(%eax)
c01097b2:	e8 43 9f ff ff       	call   c01036fa <wchan_sleep>
    signal_wakes++;
c01097b7:	a1 38 6e 13 c0       	mov    0xc0136e38,%eax
c01097bc:	40                   	inc    %eax
c01097bd:	a3 38 6e 13 c0       	mov    %eax,0xc0136e38
    spinlock_release(&test_cv->cv_splock);
c01097c2:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c01097c7:	83 c0 08             	add    $0x8,%eax
c01097ca:	89 04 24             	mov    %eax,(%esp)
c01097cd:	e8 cd 9b ff ff       	call   c010339f <spinlock_release>

    return 0;
}
c01097d2:	31 c0                	xor    %eax,%eax
c01097d4:	c9                   	leave  
c01097d5:	c3                   	ret    

c01097d6 <broadcast_sleep>:

/*
 * Helper function that decrements broadcast_wakes, puts a thread to sleep
 * on test_cv's wait channel and once awoken, increments broadcast_wakes
 */
int broadcast_sleep(void* stuff, unsigned long num) {
c01097d6:	55                   	push   %ebp
c01097d7:	89 e5                	mov    %esp,%ebp
c01097d9:	83 ec 14             	sub    $0x14,%esp
    (void) stuff;
    (void) num;
    spinlock_acquire(&test_cv->cv_splock);
c01097dc:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c01097e1:	83 c0 08             	add    $0x8,%eax
c01097e4:	50                   	push   %eax
c01097e5:	e8 0d 9b ff ff       	call   c01032f7 <spinlock_acquire>
    broadcast_wakes--;
c01097ea:	a1 34 6e 13 c0       	mov    0xc0136e34,%eax
c01097ef:	48                   	dec    %eax
c01097f0:	a3 34 6e 13 c0       	mov    %eax,0xc0136e34
    // Put the thread on testcv's wait channel
    wchan_sleep(test_cv->cv_wchan, &test_cv->cv_splock);
c01097f5:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c01097fa:	5a                   	pop    %edx
c01097fb:	59                   	pop    %ecx
c01097fc:	8d 50 08             	lea    0x8(%eax),%edx
c01097ff:	52                   	push   %edx
c0109800:	ff 70 04             	pushl  0x4(%eax)
c0109803:	e8 f2 9e ff ff       	call   c01036fa <wchan_sleep>
    // Should only get here if awoken by the broadcast
    broadcast_wakes++;
c0109808:	a1 34 6e 13 c0       	mov    0xc0136e34,%eax
c010980d:	40                   	inc    %eax
c010980e:	a3 34 6e 13 c0       	mov    %eax,0xc0136e34
    spinlock_release(&test_cv->cv_splock);
c0109813:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109818:	83 c0 08             	add    $0x8,%eax
c010981b:	89 04 24             	mov    %eax,(%esp)
c010981e:	e8 7c 9b ff ff       	call   c010339f <spinlock_release>

    return 0;
}
c0109823:	31 c0                	xor    %eax,%eax
c0109825:	c9                   	leave  
c0109826:	c3                   	ret    

c0109827 <push_pop_par>:
    return 0;
}

// tries to pop from an empty queue_ts and must wait for the parent thread to
// insert values
int push_pop_par(void* data1, unsigned long data2) {
c0109827:	55                   	push   %ebp
c0109828:	89 e5                	mov    %esp,%ebp
c010982a:	83 ec 14             	sub    $0x14,%esp
    (void) data1;
    (void) data2;
    void* j = NULL;
    assert(queue_ts_isempty(q));
c010982d:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c0109833:	e8 d4 ce ff ff       	call   c010670c <queue_ts_isempty>
c0109838:	83 c4 10             	add    $0x10,%esp
c010983b:	85 c0                	test   %eax,%eax
c010983d:	75 2b                	jne    c010986a <push_pop_par+0x43>
c010983f:	83 ec 0c             	sub    $0xc,%esp
c0109842:	68 4c d7 10 c0       	push   $0xc010d74c
c0109847:	68 95 02 00 00       	push   $0x295
c010984c:	68 9b d4 10 c0       	push   $0xc010d49b
c0109851:	68 ec d4 10 c0       	push   $0xc010d4ec
c0109856:	68 95 a9 10 c0       	push   $0xc010a995
c010985b:	e8 64 a5 ff ff       	call   c0103dc4 <print>
c0109860:	83 c4 20             	add    $0x20,%esp
c0109863:	e8 e2 75 ff ff       	call   c0100e4a <backtrace>
c0109868:	fa                   	cli    
c0109869:	f4                   	hlt    
    if ((j = queue_ts_pop_blocking(q)) == NULL) {
c010986a:	83 ec 0c             	sub    $0xc,%esp
c010986d:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c0109873:	e8 fe cd ff ff       	call   c0106676 <queue_ts_pop_blocking>
c0109878:	83 c4 10             	add    $0x10,%esp
c010987b:	85 c0                	test   %eax,%eax
c010987d:	75 12                	jne    c0109891 <push_pop_par+0x6a>
        kfree(j);
c010987f:	83 ec 0c             	sub    $0xc,%esp
c0109882:	6a 00                	push   $0x0
c0109884:	e8 e8 80 ff ff       	call   c0101971 <kfree>
        return -1;
c0109889:	83 c4 10             	add    $0x10,%esp
c010988c:	83 c8 ff             	or     $0xffffffff,%eax
c010988f:	eb 0e                	jmp    c010989f <push_pop_par+0x78>
    }
    kfree(j);
c0109891:	83 ec 0c             	sub    $0xc,%esp
c0109894:	50                   	push   %eax
c0109895:	e8 d7 80 ff ff       	call   c0101971 <kfree>

    return 0;
c010989a:	83 c4 10             	add    $0x10,%esp
c010989d:	31 c0                	xor    %eax,%eax
}
c010989f:	c9                   	leave  
c01098a0:	c3                   	ret    

c01098a1 <markbits_par>:
    // bitmap_ts_destroy(b);
    // return 0;s
}

// has multiple threads mark bits in parallel
int markbits_par(void* data1, unsigned long data2) {
c01098a1:	55                   	push   %ebp
c01098a2:	89 e5                	mov    %esp,%ebp
c01098a4:	53                   	push   %ebx
c01098a5:	50                   	push   %eax
c01098a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    (void) data1;
    if (data2 == NTHREADS - 1)
c01098a9:	83 fb 07             	cmp    $0x7,%ebx
c01098ac:	75 1d                	jne    c01098cb <markbits_par+0x2a>
c01098ae:	31 db                	xor    %ebx,%ebx
        for (int i = 0; i < NTHREADS * 4; ++i)
            bitmap_ts_mark(b, i);
c01098b0:	50                   	push   %eax
c01098b1:	50                   	push   %eax
c01098b2:	53                   	push   %ebx
c01098b3:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c01098b9:	e8 1e ca ff ff       	call   c01062dc <bitmap_ts_mark>

// has multiple threads mark bits in parallel
int markbits_par(void* data1, unsigned long data2) {
    (void) data1;
    if (data2 == NTHREADS - 1)
        for (int i = 0; i < NTHREADS * 4; ++i)
c01098be:	43                   	inc    %ebx
c01098bf:	83 c4 10             	add    $0x10,%esp
c01098c2:	83 fb 20             	cmp    $0x20,%ebx
c01098c5:	75 e9                	jne    c01098b0 <markbits_par+0xf>
            return -1;
        if (bitmap_ts_isset(b, data2 + 3 * NTHREADS) == 0)
            return -1;
    }

    return 0;
c01098c7:	31 c0                	xor    %eax,%eax
c01098c9:	eb 68                	jmp    c0109933 <markbits_par+0x92>
    (void) data1;
    if (data2 == NTHREADS - 1)
        for (int i = 0; i < NTHREADS * 4; ++i)
            bitmap_ts_mark(b, i);
    else {
        if (bitmap_ts_isset(b, data2) == 0)
c01098cb:	50                   	push   %eax
c01098cc:	50                   	push   %eax
c01098cd:	53                   	push   %ebx
c01098ce:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c01098d4:	e8 d0 ca ff ff       	call   c01063a9 <bitmap_ts_isset>
c01098d9:	83 c4 10             	add    $0x10,%esp
c01098dc:	85 c0                	test   %eax,%eax
c01098de:	75 05                	jne    c01098e5 <markbits_par+0x44>
            return -1;
c01098e0:	83 c8 ff             	or     $0xffffffff,%eax
c01098e3:	eb 4e                	jmp    c0109933 <markbits_par+0x92>
        if (bitmap_ts_isset(b, data2 + NTHREADS) == 0)
c01098e5:	51                   	push   %ecx
c01098e6:	51                   	push   %ecx
c01098e7:	8d 43 08             	lea    0x8(%ebx),%eax
c01098ea:	50                   	push   %eax
c01098eb:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c01098f1:	e8 b3 ca ff ff       	call   c01063a9 <bitmap_ts_isset>
c01098f6:	83 c4 10             	add    $0x10,%esp
c01098f9:	85 c0                	test   %eax,%eax
c01098fb:	74 e3                	je     c01098e0 <markbits_par+0x3f>
            return -1;
        if (bitmap_ts_isset(b, data2 + 2 * NTHREADS) == 0)
c01098fd:	52                   	push   %edx
c01098fe:	52                   	push   %edx
c01098ff:	8d 43 10             	lea    0x10(%ebx),%eax
c0109902:	50                   	push   %eax
c0109903:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109909:	e8 9b ca ff ff       	call   c01063a9 <bitmap_ts_isset>
c010990e:	83 c4 10             	add    $0x10,%esp
c0109911:	85 c0                	test   %eax,%eax
c0109913:	74 cb                	je     c01098e0 <markbits_par+0x3f>
            return -1;
        if (bitmap_ts_isset(b, data2 + 3 * NTHREADS) == 0)
c0109915:	50                   	push   %eax
c0109916:	50                   	push   %eax
c0109917:	83 c3 18             	add    $0x18,%ebx
c010991a:	53                   	push   %ebx
c010991b:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109921:	e8 83 ca ff ff       	call   c01063a9 <bitmap_ts_isset>
c0109926:	83 c4 10             	add    $0x10,%esp
c0109929:	85 c0                	test   %eax,%eax
c010992b:	0f 94 c0             	sete   %al
c010992e:	0f b6 c0             	movzbl %al,%eax
c0109931:	f7 d8                	neg    %eax
            return -1;
    }

    return 0;
}
c0109933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0109936:	c9                   	leave  
c0109937:	c3                   	ret    

c0109938 <run_test_suite>:
    return 0;
}

// this executes each of the ntest tests in the suite tester and prints an
// error/success message to the console upon completion
void run_test_suite(char* tname, int (*tester)(int tnum), int ntest) {
c0109938:	55                   	push   %ebp
c0109939:	89 e5                	mov    %esp,%ebp
c010993b:	57                   	push   %edi
c010993c:	56                   	push   %esi
c010993d:	53                   	push   %ebx
c010993e:	83 ec 44             	sub    $0x44,%esp
c0109941:	8b 75 08             	mov    0x8(%ebp),%esi
    print("\n  commencing %s tests:\n", tname);
c0109944:	56                   	push   %esi
c0109945:	68 0a d5 10 c0       	push   $0xc010d50a
c010994a:	e8 75 a4 ff ff       	call   c0103dc4 <print>
    for (int i = 0; i < ntest; ++i) {
c010994f:	83 c4 10             	add    $0x10,%esp
c0109952:	31 db                	xor    %ebx,%ebx
        char buf[32];
        snprintf(buf, 32, ">> %s test %d", tname, i);
c0109954:	8d 7d c8             	lea    -0x38(%ebp),%edi

// this executes each of the ntest tests in the suite tester and prints an
// error/success message to the console upon completion
void run_test_suite(char* tname, int (*tester)(int tnum), int ntest) {
    print("\n  commencing %s tests:\n", tname);
    for (int i = 0; i < ntest; ++i) {
c0109957:	3b 5d 10             	cmp    0x10(%ebp),%ebx
c010995a:	7d 71                	jge    c01099cd <run_test_suite+0x95>
        char buf[32];
        snprintf(buf, 32, ">> %s test %d", tname, i);
c010995c:	83 ec 0c             	sub    $0xc,%esp
c010995f:	53                   	push   %ebx
c0109960:	56                   	push   %esi
c0109961:	68 23 d5 10 c0       	push   $0xc010d523
c0109966:	6a 20                	push   $0x20
c0109968:	57                   	push   %edi
c0109969:	e8 53 a9 ff ff       	call   c01042c1 <snprintf>
        print("\t%-28s [ ---- ]", buf);
c010996e:	83 c4 18             	add    $0x18,%esp
c0109971:	57                   	push   %edi
c0109972:	68 31 d5 10 c0       	push   $0xc010d531
c0109977:	e8 48 a4 ff ff       	call   c0103dc4 <print>
        int result = tester(i);
c010997c:	89 1c 24             	mov    %ebx,(%esp)
c010997f:	ff 55 0c             	call   *0xc(%ebp)
        print("\b\b\b\b\b\b%s ]\n", result == 0 ? "PASS" : "FAIL");
c0109982:	83 c4 10             	add    $0x10,%esp
c0109985:	ba 00 d5 10 c0       	mov    $0xc010d500,%edx
c010998a:	85 c0                	test   %eax,%eax
c010998c:	74 05                	je     c0109993 <run_test_suite+0x5b>
c010998e:	ba 05 d5 10 c0       	mov    $0xc010d505,%edx
c0109993:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0109996:	51                   	push   %ecx
c0109997:	51                   	push   %ecx
c0109998:	52                   	push   %edx
c0109999:	68 41 d5 10 c0       	push   $0xc010d541
c010999e:	e8 21 a4 ff ff       	call   c0103dc4 <print>
        if (result != 0)
c01099a3:	83 c4 10             	add    $0x10,%esp
c01099a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01099a9:	85 c0                	test   %eax,%eax
c01099ab:	74 1d                	je     c01099ca <run_test_suite+0x92>
            panic("failed test: %s %d", tname, i);
c01099ad:	52                   	push   %edx
c01099ae:	52                   	push   %edx
c01099af:	53                   	push   %ebx
c01099b0:	56                   	push   %esi
c01099b1:	68 4d d5 10 c0       	push   $0xc010d54d
c01099b6:	68 d8 d7 10 c0       	push   $0xc010d7d8
c01099bb:	6a 6a                	push   $0x6a
c01099bd:	68 9b d4 10 c0       	push   $0xc010d49b
c01099c2:	e8 7b 9f ff ff       	call   c0103942 <_panic>
c01099c7:	83 c4 20             	add    $0x20,%esp

// this executes each of the ntest tests in the suite tester and prints an
// error/success message to the console upon completion
void run_test_suite(char* tname, int (*tester)(int tnum), int ntest) {
    print("\n  commencing %s tests:\n", tname);
    for (int i = 0; i < ntest; ++i) {
c01099ca:	43                   	inc    %ebx
c01099cb:	eb 8a                	jmp    c0109957 <run_test_suite+0x1f>
        int result = tester(i);
        print("\b\b\b\b\b\b%s ]\n", result == 0 ? "PASS" : "FAIL");
        if (result != 0)
            panic("failed test: %s %d", tname, i);
    }
    print("  finished %s tests.\n", tname);
c01099cd:	50                   	push   %eax
c01099ce:	50                   	push   %eax
c01099cf:	56                   	push   %esi
c01099d0:	68 60 d5 10 c0       	push   $0xc010d560
c01099d5:	e8 ea a3 ff ff       	call   c0103dc4 <print>
}
c01099da:	83 c4 10             	add    $0x10,%esp
c01099dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01099e0:	5b                   	pop    %ebx
c01099e1:	5e                   	pop    %esi
c01099e2:	5f                   	pop    %edi
c01099e3:	5d                   	pop    %ebp
c01099e4:	c3                   	ret    

c01099e5 <tests>:
int push_pop_seq(void);
int pop_blocking_seq(void);
int push_pop_par(void*, unsigned long);

// main test function that called each test suite
int tests(int nargs, char **args) {
c01099e5:	55                   	push   %ebp
c01099e6:	89 e5                	mov    %esp,%ebp
c01099e8:	57                   	push   %edi
c01099e9:	53                   	push   %ebx
c01099ea:	83 ec 24             	sub    $0x24,%esp
    (void) nargs;  // suppress warnings
    (void) args;   // suppress warnings

    char tname[24] = {0};
c01099ed:	8d 7d e0             	lea    -0x20(%ebp),%edi
c01099f0:	b9 06 00 00 00       	mov    $0x6,%ecx
c01099f5:	31 c0                	xor    %eax,%eax
c01099f7:	f3 ab                	rep stos %eax,%es:(%edi)

    // thread_join
    snprintf(tname, sizeof(tname), "thread_join");
c01099f9:	68 76 d5 10 c0       	push   $0xc010d576
c01099fe:	6a 18                	push   $0x18
c0109a00:	8d 5d e0             	lea    -0x20(%ebp),%ebx
c0109a03:	53                   	push   %ebx
c0109a04:	e8 b8 a8 ff ff       	call   c01042c1 <snprintf>
    run_test_suite(tname, threadtester, 3);
c0109a09:	83 c4 0c             	add    $0xc,%esp
c0109a0c:	6a 03                	push   $0x3
c0109a0e:	68 f0 95 10 c0       	push   $0xc01095f0
c0109a13:	53                   	push   %ebx
c0109a14:	e8 1f ff ff ff       	call   c0109938 <run_test_suite>
    memset(tname, '\0', sizeof(tname));
c0109a19:	83 c4 0c             	add    $0xc,%esp
c0109a1c:	6a 18                	push   $0x18
c0109a1e:	6a 00                	push   $0x0
c0109a20:	53                   	push   %ebx
c0109a21:	e8 96 aa ff ff       	call   c01044bc <memset>

    // lock
    snprintf(tname, sizeof(tname), "lock");
c0109a26:	83 c4 0c             	add    $0xc,%esp
c0109a29:	68 20 c1 10 c0       	push   $0xc010c120
c0109a2e:	6a 18                	push   $0x18
c0109a30:	53                   	push   %ebx
c0109a31:	e8 8b a8 ff ff       	call   c01042c1 <snprintf>
    run_test_suite(tname, locktester, 2);
c0109a36:	83 c4 0c             	add    $0xc,%esp
c0109a39:	6a 02                	push   $0x2
c0109a3b:	68 fb a2 10 c0       	push   $0xc010a2fb
c0109a40:	53                   	push   %ebx
c0109a41:	e8 f2 fe ff ff       	call   c0109938 <run_test_suite>
    memset(tname, '\0', sizeof(tname));
c0109a46:	83 c4 0c             	add    $0xc,%esp
c0109a49:	6a 18                	push   $0x18
c0109a4b:	6a 00                	push   $0x0
c0109a4d:	53                   	push   %ebx
c0109a4e:	e8 69 aa ff ff       	call   c01044bc <memset>

    // cv
    snprintf(tname, sizeof(tname), "cv");
c0109a53:	83 c4 0c             	add    $0xc,%esp
c0109a56:	68 77 c0 10 c0       	push   $0xc010c077
c0109a5b:	6a 18                	push   $0x18
c0109a5d:	53                   	push   %ebx
c0109a5e:	e8 5e a8 ff ff       	call   c01042c1 <snprintf>
    run_test_suite(tname, cv_tests, 4);
c0109a63:	83 c4 0c             	add    $0xc,%esp
c0109a66:	6a 04                	push   $0x4
c0109a68:	68 ab 9d 10 c0       	push   $0xc0109dab
c0109a6d:	53                   	push   %ebx
c0109a6e:	e8 c5 fe ff ff       	call   c0109938 <run_test_suite>
    memset(tname, '\0', sizeof(tname));
c0109a73:	83 c4 0c             	add    $0xc,%esp
c0109a76:	6a 18                	push   $0x18
c0109a78:	6a 00                	push   $0x0
c0109a7a:	53                   	push   %ebx
c0109a7b:	e8 3c aa ff ff       	call   c01044bc <memset>

    // bitmap_ts
    snprintf(tname, sizeof(tname), "bitmap_ts");
c0109a80:	83 c4 0c             	add    $0xc,%esp
c0109a83:	68 82 d5 10 c0       	push   $0xc010d582
c0109a88:	6a 18                	push   $0x18
c0109a8a:	53                   	push   %ebx
c0109a8b:	e8 31 a8 ff ff       	call   c01042c1 <snprintf>
    run_test_suite(tname, bitmaptester, 4);
c0109a90:	83 c4 0c             	add    $0xc,%esp
c0109a93:	6a 04                	push   $0x4
c0109a95:	68 8e 9e 10 c0       	push   $0xc0109e8e
c0109a9a:	53                   	push   %ebx
c0109a9b:	e8 98 fe ff ff       	call   c0109938 <run_test_suite>
    memset(tname, '\0', sizeof(tname));
c0109aa0:	83 c4 0c             	add    $0xc,%esp
c0109aa3:	6a 18                	push   $0x18
c0109aa5:	6a 00                	push   $0x0
c0109aa7:	53                   	push   %ebx
c0109aa8:	e8 0f aa ff ff       	call   c01044bc <memset>

    // queue_ts
    snprintf(tname, sizeof(tname), "queue_ts");
c0109aad:	83 c4 0c             	add    $0xc,%esp
c0109ab0:	68 8c d5 10 c0       	push   $0xc010d58c
c0109ab5:	6a 18                	push   $0x18
c0109ab7:	53                   	push   %ebx
c0109ab8:	e8 04 a8 ff ff       	call   c01042c1 <snprintf>
    run_test_suite(tname, queuetester, 4);
c0109abd:	83 c4 0c             	add    $0xc,%esp
c0109ac0:	6a 04                	push   $0x4
c0109ac2:	68 38 a5 10 c0       	push   $0xc010a538
c0109ac7:	53                   	push   %ebx
c0109ac8:	e8 6b fe ff ff       	call   c0109938 <run_test_suite>
    memset(tname, '\0', sizeof(tname));
c0109acd:	83 c4 0c             	add    $0xc,%esp
c0109ad0:	6a 18                	push   $0x18
c0109ad2:	6a 00                	push   $0x0
c0109ad4:	53                   	push   %ebx
c0109ad5:	e8 e2 a9 ff ff       	call   c01044bc <memset>

    print("\n\t<!> all test suites executed <!>\n");
c0109ada:	c7 04 24 95 d5 10 c0 	movl   $0xc010d595,(%esp)
c0109ae1:	e8 de a2 ff ff       	call   c0103dc4 <print>

    return 0;
}
c0109ae6:	31 c0                	xor    %eax,%eax
c0109ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0109aeb:	5b                   	pop    %ebx
c0109aec:	5f                   	pop    %edi
c0109aed:	5d                   	pop    %ebp
c0109aee:	c3                   	ret    

c0109aef <test_create_cv>:
}

/*
 * Simply makes sure cv_create succeeds and returns a non-null value
 */
int test_create_cv() {
c0109aef:	55                   	push   %ebp
c0109af0:	89 e5                	mov    %esp,%ebp
c0109af2:	83 ec 14             	sub    $0x14,%esp
    test_cv = cv_create("test_cv");
c0109af5:	68 b9 d5 10 c0       	push   $0xc010d5b9
c0109afa:	e8 f3 8f ff ff       	call   c0102af2 <cv_create>
c0109aff:	a3 28 6e 13 c0       	mov    %eax,0xc0136e28
    return test_cv == NULL ? -1 : 0;
c0109b04:	83 c4 10             	add    $0x10,%esp
c0109b07:	85 c0                	test   %eax,%eax
c0109b09:	0f 94 c0             	sete   %al
c0109b0c:	0f b6 c0             	movzbl %al,%eax
c0109b0f:	f7 d8                	neg    %eax
}
c0109b11:	c9                   	leave  
c0109b12:	c3                   	ret    

c0109b13 <test_cv_wait>:
 * the global var is updated), then sets the global variable to 1. The original
 * thread waits until the forked thread updates the global variable and then
 * finishes. This tests the basic functionality of cv_wait: give up control
 * until a condition is met.
 */
int test_cv_wait() {
c0109b13:	55                   	push   %ebp
c0109b14:	89 e5                	mov    %esp,%ebp
c0109b16:	83 ec 24             	sub    $0x24,%esp
    int tret;
    struct thread* t;
    testlock = lock_create("test_cv_wait_lk");
c0109b19:	68 c1 d5 10 c0       	push   $0xc010d5c1
c0109b1e:	e8 5c 91 ff ff       	call   c0102c7f <lock_create>
c0109b23:	a3 24 6e 13 c0       	mov    %eax,0xc0136e24
    test_cv = cv_create("test_cv");
c0109b28:	c7 04 24 b9 d5 10 c0 	movl   $0xc010d5b9,(%esp)
c0109b2f:	e8 be 8f ff ff       	call   c0102af2 <cv_create>
c0109b34:	a3 28 6e 13 c0       	mov    %eax,0xc0136e28
    cv_var = 0;
c0109b39:	c7 05 2c 6e 13 c0 00 	movl   $0x0,0xc0136e2c
c0109b40:	00 00 00 
    thread_fork("waitandset", &t, NULL, wait_and_set, NULL, 0);
c0109b43:	5a                   	pop    %edx
c0109b44:	59                   	pop    %ecx
c0109b45:	6a 00                	push   $0x0
c0109b47:	6a 00                	push   $0x0
c0109b49:	68 b3 95 10 c0       	push   $0xc01095b3
c0109b4e:	6a 00                	push   $0x0
c0109b50:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0109b53:	50                   	push   %eax
c0109b54:	68 d1 d5 10 c0       	push   $0xc010d5d1
c0109b59:	e8 2f d4 ff ff       	call   c0106f8d <thread_fork>
    thread_join(t, &tret);
c0109b5e:	83 c4 18             	add    $0x18,%esp
c0109b61:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0109b64:	50                   	push   %eax
c0109b65:	ff 75 f4             	pushl  -0xc(%ebp)
c0109b68:	e8 34 d2 ff ff       	call   c0106da1 <thread_join>
    lock_acquire(testlock);
c0109b6d:	58                   	pop    %eax
c0109b6e:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109b74:	e8 56 92 ff ff       	call   c0102dcf <lock_acquire>
    while (cv_var == 0)
        cv_wait(test_cv, testlock);
c0109b79:	83 c4 10             	add    $0x10,%esp
    test_cv = cv_create("test_cv");
    cv_var = 0;
    thread_fork("waitandset", &t, NULL, wait_and_set, NULL, 0);
    thread_join(t, &tret);
    lock_acquire(testlock);
    while (cv_var == 0)
c0109b7c:	a1 2c 6e 13 c0       	mov    0xc0136e2c,%eax
c0109b81:	85 c0                	test   %eax,%eax
c0109b83:	75 15                	jne    c0109b9a <test_cv_wait+0x87>
        cv_wait(test_cv, testlock);
c0109b85:	50                   	push   %eax
c0109b86:	50                   	push   %eax
c0109b87:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109b8d:	ff 35 28 6e 13 c0    	pushl  0xc0136e28
c0109b93:	e8 18 90 ff ff       	call   c0102bb0 <cv_wait>
c0109b98:	eb df                	jmp    c0109b79 <test_cv_wait+0x66>
    lock_release(testlock);
c0109b9a:	83 ec 0c             	sub    $0xc,%esp
c0109b9d:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109ba3:	e8 8f 93 ff ff       	call   c0102f37 <lock_release>

    return 0;
}
c0109ba8:	31 c0                	xor    %eax,%eax
c0109baa:	c9                   	leave  
c0109bab:	c3                   	ret    

c0109bac <test_cv_signal>:
 * on the wait channel. The forked thread then updates a global variable and the
 * test only passes if this global variable has been updated, ie. the sleeping
 * thread was signaled and awoken. This tests the basic functionality of cv_signal:
 * wake something that is waiting on the cv's wait channel.
 */
int test_cv_signal() {
c0109bac:	55                   	push   %ebp
c0109bad:	89 e5                	mov    %esp,%ebp
c0109baf:	83 ec 24             	sub    $0x24,%esp
    testlock = lock_create("test_cv_signal_lk");
c0109bb2:	68 dc d5 10 c0       	push   $0xc010d5dc
c0109bb7:	e8 c3 90 ff ff       	call   c0102c7f <lock_create>
c0109bbc:	a3 24 6e 13 c0       	mov    %eax,0xc0136e24
    int tret;
    struct thread* t;
    test_cv = cv_create("test_cv");
c0109bc1:	c7 04 24 b9 d5 10 c0 	movl   $0xc010d5b9,(%esp)
c0109bc8:	e8 25 8f ff ff       	call   c0102af2 <cv_create>
c0109bcd:	a3 28 6e 13 c0       	mov    %eax,0xc0136e28
    signal_wakes = 0;
c0109bd2:	c7 05 38 6e 13 c0 00 	movl   $0x0,0xc0136e38
c0109bd9:	00 00 00 

    thread_fork("sleep", &t, NULL, signal_sleep, NULL, 0);
c0109bdc:	58                   	pop    %eax
c0109bdd:	5a                   	pop    %edx
c0109bde:	6a 00                	push   $0x0
c0109be0:	6a 00                	push   $0x0
c0109be2:	68 90 97 10 c0       	push   $0xc0109790
c0109be7:	6a 00                	push   $0x0
c0109be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0109bec:	50                   	push   %eax
c0109bed:	68 ee d5 10 c0       	push   $0xc010d5ee
c0109bf2:	e8 96 d3 ff ff       	call   c0106f8d <thread_fork>

    // the spinlock must be help prior to calling wchan_isempty due to KASSERTs
    spinlock_acquire(&test_cv->cv_splock);
c0109bf7:	83 c4 14             	add    $0x14,%esp
c0109bfa:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109bff:	83 c0 08             	add    $0x8,%eax
c0109c02:	50                   	push   %eax
    while (wchan_isempty(test_cv->cv_wchan, &test_cv->cv_splock)) {
        // don't don't don't sleep while holding the spinlock
        spinlock_release(&test_cv->cv_splock);
        sys_yield();
        // must re-acquire before going round the loop
        spinlock_acquire(&test_cv->cv_splock);
c0109c03:	e8 ef 96 ff ff       	call   c01032f7 <spinlock_acquire>
c0109c08:	83 c4 10             	add    $0x10,%esp

    thread_fork("sleep", &t, NULL, signal_sleep, NULL, 0);

    // the spinlock must be help prior to calling wchan_isempty due to KASSERTs
    spinlock_acquire(&test_cv->cv_splock);
    while (wchan_isempty(test_cv->cv_wchan, &test_cv->cv_splock)) {
c0109c0b:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109c10:	51                   	push   %ecx
c0109c11:	51                   	push   %ecx
c0109c12:	8d 50 08             	lea    0x8(%eax),%edx
c0109c15:	52                   	push   %edx
c0109c16:	ff 70 04             	pushl  0x4(%eax)
c0109c19:	e8 d1 9c ff ff       	call   c01038ef <wchan_isempty>
c0109c1e:	83 c4 10             	add    $0x10,%esp
c0109c21:	84 c0                	test   %al,%al
c0109c23:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109c28:	74 1e                	je     c0109c48 <test_cv_signal+0x9c>
        // don't don't don't sleep while holding the spinlock
        spinlock_release(&test_cv->cv_splock);
c0109c2a:	83 ec 0c             	sub    $0xc,%esp
c0109c2d:	83 c0 08             	add    $0x8,%eax
c0109c30:	50                   	push   %eax
c0109c31:	e8 69 97 ff ff       	call   c010339f <spinlock_release>
        sys_yield();
c0109c36:	e8 18 6d ff ff       	call   c0100953 <sys_yield>
        // must re-acquire before going round the loop
        spinlock_acquire(&test_cv->cv_splock);
c0109c3b:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109c40:	83 c0 08             	add    $0x8,%eax
c0109c43:	89 04 24             	mov    %eax,(%esp)
c0109c46:	eb bb                	jmp    c0109c03 <test_cv_signal+0x57>
    }
    spinlock_release(&test_cv->cv_splock);
c0109c48:	83 ec 0c             	sub    $0xc,%esp
c0109c4b:	83 c0 08             	add    $0x8,%eax
c0109c4e:	50                   	push   %eax
c0109c4f:	e8 4b 97 ff ff       	call   c010339f <spinlock_release>

    // must hold the lock prior to calling cv_signal due to KASSERTs
    lock_acquire(testlock);
c0109c54:	58                   	pop    %eax
c0109c55:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109c5b:	e8 6f 91 ff ff       	call   c0102dcf <lock_acquire>
    cv_signal(test_cv, testlock);
c0109c60:	5a                   	pop    %edx
c0109c61:	59                   	pop    %ecx
c0109c62:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109c68:	ff 35 28 6e 13 c0    	pushl  0xc0136e28
c0109c6e:	e8 82 8f ff ff       	call   c0102bf5 <cv_signal>
    lock_release(testlock);
c0109c73:	58                   	pop    %eax
c0109c74:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109c7a:	e8 b8 92 ff ff       	call   c0102f37 <lock_release>

    thread_join(t, &tret);
c0109c7f:	58                   	pop    %eax
c0109c80:	5a                   	pop    %edx
c0109c81:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0109c84:	50                   	push   %eax
c0109c85:	ff 75 f4             	pushl  -0xc(%ebp)
c0109c88:	e8 14 d1 ff ff       	call   c0106da1 <thread_join>

    return signal_wakes == 1 ? 0 : -1;
c0109c8d:	a1 38 6e 13 c0       	mov    0xc0136e38,%eax
c0109c92:	83 c4 10             	add    $0x10,%esp
c0109c95:	48                   	dec    %eax
c0109c96:	0f 95 c0             	setne  %al
c0109c99:	0f b6 c0             	movzbl %al,%eax
c0109c9c:	f7 d8                	neg    %eax
}
c0109c9e:	c9                   	leave  
c0109c9f:	c3                   	ret    

c0109ca0 <test_cv_broadcast>:
 * a call to cv_broadcast after all the threads have been put to sleep on the cv's
 * wait channel. Passes if all 5 threads were awoken and incremented the global
 * variable. Tests the basic functionality of cv_broadcast: Awaking all threads
 * on a cv's wait channel.
 */
int test_cv_broadcast() {
c0109ca0:	55                   	push   %ebp
c0109ca1:	89 e5                	mov    %esp,%ebp
c0109ca3:	57                   	push   %edi
c0109ca4:	56                   	push   %esi
c0109ca5:	53                   	push   %ebx
c0109ca6:	83 ec 38             	sub    $0x38,%esp
    testlock = lock_create("test_cv_broadcast_lk");
c0109ca9:	68 f4 d5 10 c0       	push   $0xc010d5f4
c0109cae:	e8 cc 8f ff ff       	call   c0102c7f <lock_create>
c0109cb3:	a3 24 6e 13 c0       	mov    %eax,0xc0136e24
    int n, tret;
    struct thread* t[5];
    test_cv = cv_create("test_cv");
c0109cb8:	c7 04 24 b9 d5 10 c0 	movl   $0xc010d5b9,(%esp)
c0109cbf:	e8 2e 8e ff ff       	call   c0102af2 <cv_create>
c0109cc4:	a3 28 6e 13 c0       	mov    %eax,0xc0136e28
    broadcast_wakes = 5;
c0109cc9:	c7 05 34 6e 13 c0 05 	movl   $0x5,0xc0136e34
c0109cd0:	00 00 00 
c0109cd3:	8d 75 d4             	lea    -0x2c(%ebp),%esi
c0109cd6:	8d 7d e8             	lea    -0x18(%ebp),%edi
c0109cd9:	83 c4 10             	add    $0x10,%esp
c0109cdc:	89 f3                	mov    %esi,%ebx

    // Put multiple threads on the wait channel
    for (n = 0; n < 5; n++)
        thread_fork("sleep", &t[n], NULL, broadcast_sleep, NULL, 0);
c0109cde:	50                   	push   %eax
c0109cdf:	50                   	push   %eax
c0109ce0:	6a 00                	push   $0x0
c0109ce2:	6a 00                	push   $0x0
c0109ce4:	68 d6 97 10 c0       	push   $0xc01097d6
c0109ce9:	6a 00                	push   $0x0
c0109ceb:	56                   	push   %esi
c0109cec:	68 ee d5 10 c0       	push   $0xc010d5ee
c0109cf1:	e8 97 d2 ff ff       	call   c0106f8d <thread_fork>
c0109cf6:	83 c6 04             	add    $0x4,%esi
    struct thread* t[5];
    test_cv = cv_create("test_cv");
    broadcast_wakes = 5;

    // Put multiple threads on the wait channel
    for (n = 0; n < 5; n++)
c0109cf9:	83 c4 20             	add    $0x20,%esp
c0109cfc:	39 fe                	cmp    %edi,%esi
c0109cfe:	75 de                	jne    c0109cde <test_cv_broadcast+0x3e>
        thread_fork("sleep", &t[n], NULL, broadcast_sleep, NULL, 0);

    spinlock_acquire(&test_cv->cv_splock);
c0109d00:	83 ec 0c             	sub    $0xc,%esp
c0109d03:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109d08:	83 c0 08             	add    $0x8,%eax
c0109d0b:	50                   	push   %eax
    while (broadcast_wakes > 0) {
        // don't don't don't sleep while holding the spinlock
        spinlock_release(&test_cv->cv_splock);
        sys_yield();
        // must re-acquire before going round the loop
        spinlock_acquire(&test_cv->cv_splock);
c0109d0c:	e8 e6 95 ff ff       	call   c01032f7 <spinlock_acquire>
c0109d11:	83 c4 10             	add    $0x10,%esp
    // Put multiple threads on the wait channel
    for (n = 0; n < 5; n++)
        thread_fork("sleep", &t[n], NULL, broadcast_sleep, NULL, 0);

    spinlock_acquire(&test_cv->cv_splock);
    while (broadcast_wakes > 0) {
c0109d14:	a1 34 6e 13 c0       	mov    0xc0136e34,%eax
c0109d19:	85 c0                	test   %eax,%eax
c0109d1b:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109d20:	74 1e                	je     c0109d40 <test_cv_broadcast+0xa0>
        // don't don't don't sleep while holding the spinlock
        spinlock_release(&test_cv->cv_splock);
c0109d22:	83 ec 0c             	sub    $0xc,%esp
c0109d25:	83 c0 08             	add    $0x8,%eax
c0109d28:	50                   	push   %eax
c0109d29:	e8 71 96 ff ff       	call   c010339f <spinlock_release>
        sys_yield();
c0109d2e:	e8 20 6c ff ff       	call   c0100953 <sys_yield>
        // must re-acquire before going round the loop
        spinlock_acquire(&test_cv->cv_splock);
c0109d33:	a1 28 6e 13 c0       	mov    0xc0136e28,%eax
c0109d38:	83 c0 08             	add    $0x8,%eax
c0109d3b:	89 04 24             	mov    %eax,(%esp)
c0109d3e:	eb cc                	jmp    c0109d0c <test_cv_broadcast+0x6c>
    }
    spinlock_release(&test_cv->cv_splock);
c0109d40:	83 ec 0c             	sub    $0xc,%esp
c0109d43:	83 c0 08             	add    $0x8,%eax
c0109d46:	50                   	push   %eax
c0109d47:	e8 53 96 ff ff       	call   c010339f <spinlock_release>
    // Need to wait here for a while?
    // must hold the lock prior to calling cv_signal due to KASSERTs
    lock_acquire(testlock);
c0109d4c:	5a                   	pop    %edx
c0109d4d:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109d53:	e8 77 90 ff ff       	call   c0102dcf <lock_acquire>
    cv_broadcast(test_cv, testlock);
c0109d58:	59                   	pop    %ecx
c0109d59:	5e                   	pop    %esi
c0109d5a:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109d60:	ff 35 28 6e 13 c0    	pushl  0xc0136e28
c0109d66:	e8 cf 8e ff ff       	call   c0102c3a <cv_broadcast>
    lock_release(testlock);
c0109d6b:	5f                   	pop    %edi
c0109d6c:	ff 35 24 6e 13 c0    	pushl  0xc0136e24
c0109d72:	e8 c0 91 ff ff       	call   c0102f37 <lock_release>
c0109d77:	83 c4 10             	add    $0x10,%esp

    for (n = 0; n < 5; n++)
c0109d7a:	31 f6                	xor    %esi,%esi
        thread_join(t[n], &tret);
c0109d7c:	8d 7d d0             	lea    -0x30(%ebp),%edi
c0109d7f:	50                   	push   %eax
c0109d80:	50                   	push   %eax
c0109d81:	57                   	push   %edi
c0109d82:	ff 34 b3             	pushl  (%ebx,%esi,4)
c0109d85:	e8 17 d0 ff ff       	call   c0106da1 <thread_join>
    // must hold the lock prior to calling cv_signal due to KASSERTs
    lock_acquire(testlock);
    cv_broadcast(test_cv, testlock);
    lock_release(testlock);

    for (n = 0; n < 5; n++)
c0109d8a:	46                   	inc    %esi
c0109d8b:	83 c4 10             	add    $0x10,%esp
c0109d8e:	83 fe 05             	cmp    $0x5,%esi
c0109d91:	75 ec                	jne    c0109d7f <test_cv_broadcast+0xdf>
        thread_join(t[n], &tret);

    return broadcast_wakes == 5 ? 0 : -1;
c0109d93:	a1 34 6e 13 c0       	mov    0xc0136e34,%eax
c0109d98:	83 f8 05             	cmp    $0x5,%eax
c0109d9b:	0f 95 c0             	setne  %al
c0109d9e:	0f b6 c0             	movzbl %al,%eax
c0109da1:	f7 d8                	neg    %eax
}
c0109da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0109da6:	5b                   	pop    %ebx
c0109da7:	5e                   	pop    %esi
c0109da8:	5f                   	pop    %edi
c0109da9:	5d                   	pop    %ebp
c0109daa:	c3                   	ret    

c0109dab <cv_tests>:
    }
    print("  finished %s tests.\n", tname);
}

// calls the test in the suite designated by the argument value
int cv_tests(int test) {
c0109dab:	55                   	push   %ebp
c0109dac:	89 e5                	mov    %esp,%ebp
c0109dae:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (test) {
c0109db1:	83 f8 01             	cmp    $0x1,%eax
c0109db4:	74 1c                	je     c0109dd2 <cv_tests+0x27>
c0109db6:	7f 0a                	jg     c0109dc2 <cv_tests+0x17>
c0109db8:	85 c0                	test   %eax,%eax
c0109dba:	75 22                	jne    c0109dde <cv_tests+0x33>
            return test_cv_broadcast();
        default:
            return 1;
    }
    return 0;
}
c0109dbc:	5d                   	pop    %ebp

// calls the test in the suite designated by the argument value
int cv_tests(int test) {
    switch (test) {
        case 0:
            return test_create_cv();
c0109dbd:	e9 2d fd ff ff       	jmp    c0109aef <test_create_cv>
    print("  finished %s tests.\n", tname);
}

// calls the test in the suite designated by the argument value
int cv_tests(int test) {
    switch (test) {
c0109dc2:	83 f8 02             	cmp    $0x2,%eax
c0109dc5:	74 11                	je     c0109dd8 <cv_tests+0x2d>
c0109dc7:	83 f8 03             	cmp    $0x3,%eax
c0109dca:	75 12                	jne    c0109dde <cv_tests+0x33>
            return test_cv_broadcast();
        default:
            return 1;
    }
    return 0;
}
c0109dcc:	5d                   	pop    %ebp
        case 1:
            return test_cv_wait();
        case 2:
            return test_cv_signal();
        case 3:
            return test_cv_broadcast();
c0109dcd:	e9 ce fe ff ff       	jmp    c0109ca0 <test_cv_broadcast>
        default:
            return 1;
    }
    return 0;
}
c0109dd2:	5d                   	pop    %ebp
int cv_tests(int test) {
    switch (test) {
        case 0:
            return test_create_cv();
        case 1:
            return test_cv_wait();
c0109dd3:	e9 3b fd ff ff       	jmp    c0109b13 <test_cv_wait>
            return test_cv_broadcast();
        default:
            return 1;
    }
    return 0;
}
c0109dd8:	5d                   	pop    %ebp
        case 0:
            return test_create_cv();
        case 1:
            return test_cv_wait();
        case 2:
            return test_cv_signal();
c0109dd9:	e9 ce fd ff ff       	jmp    c0109bac <test_cv_signal>
            return test_cv_broadcast();
        default:
            return 1;
    }
    return 0;
}
c0109dde:	b8 01 00 00 00       	mov    $0x1,%eax
c0109de3:	5d                   	pop    %ebp
c0109de4:	c3                   	ret    

c0109de5 <bitmap_ts_init>:
//////////////////////////////////////*/

static struct bitmap_ts* b;

// checks that a bitmap_ts can be successfully created
int bitmap_ts_init(unsigned nbits) {
c0109de5:	55                   	push   %ebp
c0109de6:	89 e5                	mov    %esp,%ebp
c0109de8:	83 ec 14             	sub    $0x14,%esp
    b = bitmap_ts_create(nbits);
c0109deb:	ff 75 08             	pushl  0x8(%ebp)
c0109dee:	e8 53 c3 ff ff       	call   c0106146 <bitmap_ts_create>
c0109df3:	89 c2                	mov    %eax,%edx
c0109df5:	a3 c4 6d 13 c0       	mov    %eax,0xc0136dc4
    if (b == NULL)
c0109dfa:	83 c4 10             	add    $0x10,%esp
c0109dfd:	83 c8 ff             	or     $0xffffffff,%eax
c0109e00:	85 d2                	test   %edx,%edx
c0109e02:	74 0e                	je     c0109e12 <bitmap_ts_init+0x2d>
        return -1;
    bitmap_ts_destroy(b);
c0109e04:	83 ec 0c             	sub    $0xc,%esp
c0109e07:	52                   	push   %edx
c0109e08:	e8 74 c6 ff ff       	call   c0106481 <bitmap_ts_destroy>
    return 0;
c0109e0d:	83 c4 10             	add    $0x10,%esp
c0109e10:	31 c0                	xor    %eax,%eax
}
c0109e12:	c9                   	leave  
c0109e13:	c3                   	ret    

c0109e14 <markbits_seq>:

// has one thread mark each bit and check with isset (impl test)
int markbits_seq(void) {
c0109e14:	55                   	push   %ebp
c0109e15:	89 e5                	mov    %esp,%ebp
c0109e17:	53                   	push   %ebx
c0109e18:	83 ec 10             	sub    $0x10,%esp
    b = bitmap_ts_create(NTHREADS * 4);
c0109e1b:	6a 20                	push   $0x20
c0109e1d:	e8 24 c3 ff ff       	call   c0106146 <bitmap_ts_create>
c0109e22:	a3 c4 6d 13 c0       	mov    %eax,0xc0136dc4
c0109e27:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < NTHREADS * 4; ++i)
c0109e2a:	31 db                	xor    %ebx,%ebx
        bitmap_ts_mark(b, i);
c0109e2c:	52                   	push   %edx
c0109e2d:	52                   	push   %edx
c0109e2e:	53                   	push   %ebx
c0109e2f:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109e35:	e8 a2 c4 ff ff       	call   c01062dc <bitmap_ts_mark>
}

// has one thread mark each bit and check with isset (impl test)
int markbits_seq(void) {
    b = bitmap_ts_create(NTHREADS * 4);
    for (int i = 0; i < NTHREADS * 4; ++i)
c0109e3a:	43                   	inc    %ebx
c0109e3b:	83 c4 10             	add    $0x10,%esp
c0109e3e:	83 fb 20             	cmp    $0x20,%ebx
c0109e41:	75 e9                	jne    c0109e2c <markbits_seq+0x18>
c0109e43:	31 db                	xor    %ebx,%ebx
        bitmap_ts_mark(b, i);
    for (int i = 0; i < NTHREADS * 4; ++i) {
        if (bitmap_ts_isset(b, i) == 0) {
c0109e45:	50                   	push   %eax
c0109e46:	50                   	push   %eax
c0109e47:	53                   	push   %ebx
c0109e48:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109e4e:	e8 56 c5 ff ff       	call   c01063a9 <bitmap_ts_isset>
c0109e53:	83 c4 10             	add    $0x10,%esp
c0109e56:	85 c0                	test   %eax,%eax
c0109e58:	75 16                	jne    c0109e70 <markbits_seq+0x5c>
            bitmap_ts_destroy(b);
c0109e5a:	83 ec 0c             	sub    $0xc,%esp
c0109e5d:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109e63:	e8 19 c6 ff ff       	call   c0106481 <bitmap_ts_destroy>
            return -1;
c0109e68:	83 c4 10             	add    $0x10,%esp
c0109e6b:	83 c8 ff             	or     $0xffffffff,%eax
c0109e6e:	eb 19                	jmp    c0109e89 <markbits_seq+0x75>
// has one thread mark each bit and check with isset (impl test)
int markbits_seq(void) {
    b = bitmap_ts_create(NTHREADS * 4);
    for (int i = 0; i < NTHREADS * 4; ++i)
        bitmap_ts_mark(b, i);
    for (int i = 0; i < NTHREADS * 4; ++i) {
c0109e70:	43                   	inc    %ebx
c0109e71:	83 fb 20             	cmp    $0x20,%ebx
c0109e74:	75 cf                	jne    c0109e45 <markbits_seq+0x31>
        if (bitmap_ts_isset(b, i) == 0) {
            bitmap_ts_destroy(b);
            return -1;
        }
    }
    bitmap_ts_destroy(b);
c0109e76:	83 ec 0c             	sub    $0xc,%esp
c0109e79:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109e7f:	e8 fd c5 ff ff       	call   c0106481 <bitmap_ts_destroy>
c0109e84:	83 c4 10             	add    $0x10,%esp
c0109e87:	31 c0                	xor    %eax,%eax
    return 0;
}
c0109e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0109e8c:	c9                   	leave  
c0109e8d:	c3                   	ret    

c0109e8e <bitmaptester>:

    return 0;
}

// launches each bitmap_ts test and returns the test's return value
int bitmaptester(int test) {
c0109e8e:	55                   	push   %ebp
c0109e8f:	89 e5                	mov    %esp,%ebp
c0109e91:	57                   	push   %edi
c0109e92:	56                   	push   %esi
c0109e93:	53                   	push   %ebx
c0109e94:	83 ec 4c             	sub    $0x4c,%esp
c0109e97:	8b 55 08             	mov    0x8(%ebp),%edx
    struct thread* t[NTHREADS] = {NULL};
c0109e9a:	8d 7d c8             	lea    -0x38(%ebp),%edi
c0109e9d:	31 c0                	xor    %eax,%eax
c0109e9f:	b9 08 00 00 00       	mov    $0x8,%ecx
c0109ea4:	f3 ab                	rep stos %eax,%es:(%edi)
    char name[16] = {'\0'};
c0109ea6:	8d 7d b8             	lea    -0x48(%ebp),%edi
c0109ea9:	b9 04 00 00 00       	mov    $0x4,%ecx
c0109eae:	f3 ab                	rep stos %eax,%es:(%edi)
    int tret = 0;
c0109eb0:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
    int ret = 0;
    switch (test) {
c0109eb7:	83 fa 01             	cmp    $0x1,%edx
c0109eba:	74 1f                	je     c0109edb <bitmaptester+0x4d>
c0109ebc:	83 fa 03             	cmp    $0x3,%edx
c0109ebf:	74 24                	je     c0109ee5 <bitmaptester+0x57>
c0109ec1:	85 d2                	test   %edx,%edx
c0109ec3:	0f 85 c8 00 00 00    	jne    c0109f91 <bitmaptester+0x103>
        case 0:
            return bitmap_ts_init((unsigned) NTHREADS);
c0109ec9:	83 ec 0c             	sub    $0xc,%esp
c0109ecc:	6a 08                	push   $0x8
c0109ece:	e8 12 ff ff ff       	call   c0109de5 <bitmap_ts_init>
c0109ed3:	83 c4 10             	add    $0x10,%esp
c0109ed6:	e9 b8 00 00 00       	jmp    c0109f93 <bitmaptester+0x105>
        case 1:
            return markbits_seq();
c0109edb:	e8 34 ff ff ff       	call   c0109e14 <markbits_seq>
c0109ee0:	e9 ae 00 00 00       	jmp    c0109f93 <bitmaptester+0x105>
c0109ee5:	8d 7d c8             	lea    -0x38(%ebp),%edi
c0109ee8:	8d 5d b8             	lea    -0x48(%ebp),%ebx
        case 2:
            return markbits_blocking_seq();
        case 3:
            b = bitmap_ts_create(NTHREADS * 4);
c0109eeb:	83 ec 0c             	sub    $0xc,%esp
c0109eee:	6a 20                	push   $0x20
c0109ef0:	e8 51 c2 ff ff       	call   c0106146 <bitmap_ts_create>
c0109ef5:	a3 c4 6d 13 c0       	mov    %eax,0xc0136dc4
            for (int i = 0; i < NTHREADS; ++i) {
                snprintf(name, sizeof(name), "bitmaptester%d", i);
c0109efa:	6a 00                	push   $0x0
c0109efc:	68 09 d6 10 c0       	push   $0xc010d609
c0109f01:	6a 10                	push   $0x10
c0109f03:	53                   	push   %ebx
c0109f04:	e8 b8 a3 ff ff       	call   c01042c1 <snprintf>
                ret = thread_fork(name, &t[i], NULL, markbits_par, NULL, i);
c0109f09:	83 c4 18             	add    $0x18,%esp
c0109f0c:	6a 00                	push   $0x0
c0109f0e:	6a 00                	push   $0x0
c0109f10:	68 a1 98 10 c0       	push   $0xc01098a1
c0109f15:	6a 00                	push   $0x0
c0109f17:	57                   	push   %edi
c0109f18:	53                   	push   %ebx
c0109f19:	e8 6f d0 ff ff       	call   c0106f8d <thread_fork>
                if (ret)
c0109f1e:	83 c4 20             	add    $0x20,%esp
c0109f21:	85 c0                	test   %eax,%eax
c0109f23:	74 1c                	je     c0109f41 <bitmaptester+0xb3>
                    panic("bitmaptester: thread_fork faile\n");
c0109f25:	68 18 d6 10 c0       	push   $0xc010d618
c0109f2a:	68 b8 d7 10 c0       	push   $0xc010d7b8
c0109f2f:	68 d0 01 00 00       	push   $0x1d0
c0109f34:	68 9b d4 10 c0       	push   $0xc010d49b
c0109f39:	e8 04 9a ff ff       	call   c0103942 <_panic>
c0109f3e:	83 c4 10             	add    $0x10,%esp

    return 0;
}

// launches each bitmap_ts test and returns the test's return value
int bitmaptester(int test) {
c0109f41:	31 db                	xor    %ebx,%ebx
                if (ret)
                    panic("bitmaptester: thread_fork faile\n");
                break;
            }
            for (int i = 0; i < NTHREADS; ++i) {
                ret = thread_join(t[i], &tret);
c0109f43:	8d 75 b4             	lea    -0x4c(%ebp),%esi
c0109f46:	50                   	push   %eax
c0109f47:	50                   	push   %eax
c0109f48:	56                   	push   %esi
c0109f49:	ff 34 9f             	pushl  (%edi,%ebx,4)
c0109f4c:	e8 50 ce ff ff       	call   c0106da1 <thread_join>
                if (ret)
c0109f51:	83 c4 10             	add    $0x10,%esp
c0109f54:	85 c0                	test   %eax,%eax
c0109f56:	74 1c                	je     c0109f74 <bitmaptester+0xe6>
                    panic("bitmaptester: thread_join faile\n");
c0109f58:	68 39 d6 10 c0       	push   $0xc010d639
c0109f5d:	68 b8 d7 10 c0       	push   $0xc010d7b8
c0109f62:	68 d6 01 00 00       	push   $0x1d6
c0109f67:	68 9b d4 10 c0       	push   $0xc010d49b
c0109f6c:	e8 d1 99 ff ff       	call   c0103942 <_panic>
c0109f71:	83 c4 10             	add    $0x10,%esp
                if (tret != 0)
c0109f74:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0109f78:	75 06                	jne    c0109f80 <bitmaptester+0xf2>
                ret = thread_fork(name, &t[i], NULL, markbits_par, NULL, i);
                if (ret)
                    panic("bitmaptester: thread_fork faile\n");
                break;
            }
            for (int i = 0; i < NTHREADS; ++i) {
c0109f7a:	43                   	inc    %ebx
c0109f7b:	83 fb 08             	cmp    $0x8,%ebx
c0109f7e:	75 c6                	jne    c0109f46 <bitmaptester+0xb8>
                if (ret)
                    panic("bitmaptester: thread_join faile\n");
                if (tret != 0)
                    break;
            }
            bitmap_ts_destroy(b);
c0109f80:	83 ec 0c             	sub    $0xc,%esp
c0109f83:	ff 35 c4 6d 13 c0    	pushl  0xc0136dc4
c0109f89:	e8 f3 c4 ff ff       	call   c0106481 <bitmap_ts_destroy>
c0109f8e:	83 c4 10             	add    $0x10,%esp
        case 0:
            return bitmap_ts_init((unsigned) NTHREADS);
        case 1:
            return markbits_seq();
        case 2:
            return markbits_blocking_seq();
c0109f91:	31 c0                	xor    %eax,%eax
            bitmap_ts_destroy(b);
        default:
            return 0;
    }
    return tret;
}
c0109f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0109f96:	5b                   	pop    %ebx
c0109f97:	5e                   	pop    %esi
c0109f98:	5f                   	pop    %edi
c0109f99:	5d                   	pop    %ebp
c0109f9a:	c3                   	ret    

c0109f9b <markbits_blocking_seq>:
    bitmap_ts_destroy(b);
    return 0;
}

// has one thread mark each bit and check with isset_blocking (impl test)
int markbits_blocking_seq(void) {
c0109f9b:	55                   	push   %ebp
c0109f9c:	89 e5                	mov    %esp,%ebp
    //         return -1;
    //     }
    // }
    // bitmap_ts_destroy(b);
    // return 0;s
}
c0109f9e:	31 c0                	xor    %eax,%eax
c0109fa0:	5d                   	pop    %ebp
c0109fa1:	c3                   	ret    

c0109fa2 <init_lock_items>:
    lock tests
//////////////////////////////////////*/


// initializes variables used by locktester
void init_lock_items(void) {
c0109fa2:	55                   	push   %ebp
c0109fa3:	89 e5                	mov    %esp,%ebp
c0109fa5:	83 ec 14             	sub    $0x14,%esp
    testarray = kmalloc(sizeof(bool) * NTHREADS);
c0109fa8:	6a 08                	push   $0x8
c0109faa:	e8 f6 78 ff ff       	call   c01018a5 <kmalloc>
c0109faf:	a3 20 6e 13 c0       	mov    %eax,0xc0136e20
    unsigned int i;
    if (testlock == NULL) {
c0109fb4:	83 c4 10             	add    $0x10,%esp
c0109fb7:	83 3d 24 6e 13 c0 00 	cmpl   $0x0,0xc0136e24
c0109fbe:	75 35                	jne    c0109ff5 <init_lock_items+0x53>
        testlock = lock_create("testlock");
c0109fc0:	83 ec 0c             	sub    $0xc,%esp
c0109fc3:	68 5a d6 10 c0       	push   $0xc010d65a
c0109fc8:	e8 b2 8c ff ff       	call   c0102c7f <lock_create>
c0109fcd:	a3 24 6e 13 c0       	mov    %eax,0xc0136e24
        if (testlock == NULL)
c0109fd2:	83 c4 10             	add    $0x10,%esp
c0109fd5:	85 c0                	test   %eax,%eax
c0109fd7:	75 1c                	jne    c0109ff5 <init_lock_items+0x53>
            panic("asst1_test: lock_create failed\n");
c0109fd9:	68 63 d6 10 c0       	push   $0xc010d663
c0109fde:	68 a8 d7 10 c0       	push   $0xc010d7a8
c0109fe3:	68 ee 01 00 00       	push   $0x1ee
c0109fe8:	68 9b d4 10 c0       	push   $0xc010d49b
c0109fed:	e8 50 99 ff ff       	call   c0103942 <_panic>
c0109ff2:	83 c4 10             	add    $0x10,%esp
    }
    for (i = 0; i < NTHREADS; i++)
        testarray[i] = false;
c0109ff5:	8b 0d 20 6e 13 c0    	mov    0xc0136e20,%ecx
c0109ffb:	31 c0                	xor    %eax,%eax
c0109ffd:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c010a000:	c6 02 00             	movb   $0x0,(%edx)
    if (testlock == NULL) {
        testlock = lock_create("testlock");
        if (testlock == NULL)
            panic("asst1_test: lock_create failed\n");
    }
    for (i = 0; i < NTHREADS; i++)
c010a003:	40                   	inc    %eax
c010a004:	83 f8 08             	cmp    $0x8,%eax
c010a007:	75 f4                	jne    c0109ffd <init_lock_items+0x5b>
        testarray[i] = false;
}
c010a009:	c9                   	leave  
c010a00a:	c3                   	ret    

c010a00b <locktester_simple>:
    }
}

// tests basic lock functionality: create, acquire, release
// with just one thread
int locktester_simple(void) {
c010a00b:	55                   	push   %ebp
c010a00c:	89 e5                	mov    %esp,%ebp
c010a00e:	56                   	push   %esi
c010a00f:	53                   	push   %ebx
    struct lock* l1 = lock_create("l1");
c010a010:	83 ec 0c             	sub    $0xc,%esp
c010a013:	68 83 d6 10 c0       	push   $0xc010d683
c010a018:	e8 62 8c ff ff       	call   c0102c7f <lock_create>
c010a01d:	89 c3                	mov    %eax,%ebx
    assert(!lock_holding(l1));
c010a01f:	89 04 24             	mov    %eax,(%esp)
c010a022:	e8 44 8d ff ff       	call   c0102d6b <lock_holding>
c010a027:	83 c4 10             	add    $0x10,%esp
c010a02a:	84 c0                	test   %al,%al
c010a02c:	74 2b                	je     c010a059 <locktester_simple+0x4e>
c010a02e:	83 ec 0c             	sub    $0xc,%esp
c010a031:	68 94 d7 10 c0       	push   $0xc010d794
c010a036:	68 05 02 00 00       	push   $0x205
c010a03b:	68 9b d4 10 c0       	push   $0xc010d49b
c010a040:	68 86 d6 10 c0       	push   $0xc010d686
c010a045:	68 95 a9 10 c0       	push   $0xc010a995
c010a04a:	e8 75 9d ff ff       	call   c0103dc4 <print>
c010a04f:	83 c4 20             	add    $0x20,%esp
c010a052:	e8 f3 6d ff ff       	call   c0100e4a <backtrace>
c010a057:	fa                   	cli    
c010a058:	f4                   	hlt    

    lock_acquire(l1);
c010a059:	83 ec 0c             	sub    $0xc,%esp
c010a05c:	53                   	push   %ebx
c010a05d:	e8 6d 8d ff ff       	call   c0102dcf <lock_acquire>
    assert(lock_holding(l1));
c010a062:	89 1c 24             	mov    %ebx,(%esp)
c010a065:	e8 01 8d ff ff       	call   c0102d6b <lock_holding>
c010a06a:	83 c4 10             	add    $0x10,%esp
c010a06d:	84 c0                	test   %al,%al
c010a06f:	75 2b                	jne    c010a09c <locktester_simple+0x91>
c010a071:	83 ec 0c             	sub    $0xc,%esp
c010a074:	68 94 d7 10 c0       	push   $0xc010d794
c010a079:	68 08 02 00 00       	push   $0x208
c010a07e:	68 9b d4 10 c0       	push   $0xc010d49b
c010a083:	68 87 d6 10 c0       	push   $0xc010d687
c010a088:	68 95 a9 10 c0       	push   $0xc010a995
c010a08d:	e8 32 9d ff ff       	call   c0103dc4 <print>
c010a092:	83 c4 20             	add    $0x20,%esp
c010a095:	e8 b0 6d ff ff       	call   c0100e4a <backtrace>
c010a09a:	fa                   	cli    
c010a09b:	f4                   	hlt    

    lock_release(l1);
c010a09c:	83 ec 0c             	sub    $0xc,%esp
c010a09f:	53                   	push   %ebx
c010a0a0:	e8 92 8e ff ff       	call   c0102f37 <lock_release>
    assert(!lock_holding(l1));
c010a0a5:	89 1c 24             	mov    %ebx,(%esp)
c010a0a8:	e8 be 8c ff ff       	call   c0102d6b <lock_holding>
c010a0ad:	83 c4 10             	add    $0x10,%esp
c010a0b0:	84 c0                	test   %al,%al
c010a0b2:	74 2b                	je     c010a0df <locktester_simple+0xd4>
c010a0b4:	83 ec 0c             	sub    $0xc,%esp
c010a0b7:	68 94 d7 10 c0       	push   $0xc010d794
c010a0bc:	68 0b 02 00 00       	push   $0x20b
c010a0c1:	68 9b d4 10 c0       	push   $0xc010d49b
c010a0c6:	68 86 d6 10 c0       	push   $0xc010d686
c010a0cb:	68 95 a9 10 c0       	push   $0xc010a995
c010a0d0:	e8 ef 9c ff ff       	call   c0103dc4 <print>
c010a0d5:	83 c4 20             	add    $0x20,%esp
c010a0d8:	e8 6d 6d ff ff       	call   c0100e4a <backtrace>
c010a0dd:	fa                   	cli    
c010a0de:	f4                   	hlt    
    /*
     * acquire lock twice
     * makes sure lk_count works properly
     * should require 2 releases before I don't hold
     */
    lock_acquire(l1);
c010a0df:	83 ec 0c             	sub    $0xc,%esp
c010a0e2:	53                   	push   %ebx
c010a0e3:	e8 e7 8c ff ff       	call   c0102dcf <lock_acquire>
    lock_acquire(l1);
c010a0e8:	89 1c 24             	mov    %ebx,(%esp)
c010a0eb:	e8 df 8c ff ff       	call   c0102dcf <lock_acquire>
    assert(lock_holding(l1));
c010a0f0:	89 1c 24             	mov    %ebx,(%esp)
c010a0f3:	e8 73 8c ff ff       	call   c0102d6b <lock_holding>
c010a0f8:	83 c4 10             	add    $0x10,%esp
c010a0fb:	84 c0                	test   %al,%al
c010a0fd:	75 2b                	jne    c010a12a <locktester_simple+0x11f>
c010a0ff:	83 ec 0c             	sub    $0xc,%esp
c010a102:	68 94 d7 10 c0       	push   $0xc010d794
c010a107:	68 14 02 00 00       	push   $0x214
c010a10c:	68 9b d4 10 c0       	push   $0xc010d49b
c010a111:	68 87 d6 10 c0       	push   $0xc010d687
c010a116:	68 95 a9 10 c0       	push   $0xc010a995
c010a11b:	e8 a4 9c ff ff       	call   c0103dc4 <print>
c010a120:	83 c4 20             	add    $0x20,%esp
c010a123:	e8 22 6d ff ff       	call   c0100e4a <backtrace>
c010a128:	fa                   	cli    
c010a129:	f4                   	hlt    

    lock_release(l1);
c010a12a:	83 ec 0c             	sub    $0xc,%esp
c010a12d:	53                   	push   %ebx
c010a12e:	e8 04 8e ff ff       	call   c0102f37 <lock_release>
    assert(lock_holding(l1));
c010a133:	89 1c 24             	mov    %ebx,(%esp)
c010a136:	e8 30 8c ff ff       	call   c0102d6b <lock_holding>
c010a13b:	83 c4 10             	add    $0x10,%esp
c010a13e:	84 c0                	test   %al,%al
c010a140:	75 2b                	jne    c010a16d <locktester_simple+0x162>
c010a142:	83 ec 0c             	sub    $0xc,%esp
c010a145:	68 94 d7 10 c0       	push   $0xc010d794
c010a14a:	68 17 02 00 00       	push   $0x217
c010a14f:	68 9b d4 10 c0       	push   $0xc010d49b
c010a154:	68 87 d6 10 c0       	push   $0xc010d687
c010a159:	68 95 a9 10 c0       	push   $0xc010a995
c010a15e:	e8 61 9c ff ff       	call   c0103dc4 <print>
c010a163:	83 c4 20             	add    $0x20,%esp
c010a166:	e8 df 6c ff ff       	call   c0100e4a <backtrace>
c010a16b:	fa                   	cli    
c010a16c:	f4                   	hlt    

    lock_release(l1);
c010a16d:	83 ec 0c             	sub    $0xc,%esp
c010a170:	53                   	push   %ebx
c010a171:	e8 c1 8d ff ff       	call   c0102f37 <lock_release>
    assert(!lock_holding(l1));
c010a176:	89 1c 24             	mov    %ebx,(%esp)
c010a179:	e8 ed 8b ff ff       	call   c0102d6b <lock_holding>
c010a17e:	83 c4 10             	add    $0x10,%esp
c010a181:	84 c0                	test   %al,%al
c010a183:	74 2b                	je     c010a1b0 <locktester_simple+0x1a5>
c010a185:	83 ec 0c             	sub    $0xc,%esp
c010a188:	68 94 d7 10 c0       	push   $0xc010d794
c010a18d:	68 1a 02 00 00       	push   $0x21a
c010a192:	68 9b d4 10 c0       	push   $0xc010d49b
c010a197:	68 86 d6 10 c0       	push   $0xc010d686
c010a19c:	68 95 a9 10 c0       	push   $0xc010a995
c010a1a1:	e8 1e 9c ff ff       	call   c0103dc4 <print>
c010a1a6:	83 c4 20             	add    $0x20,%esp
c010a1a9:	e8 9c 6c ff ff       	call   c0100e4a <backtrace>
c010a1ae:	fa                   	cli    
c010a1af:	f4                   	hlt    

    struct lock *l2 = lock_create("l2");
c010a1b0:	83 ec 0c             	sub    $0xc,%esp
c010a1b3:	68 98 d6 10 c0       	push   $0xc010d698
c010a1b8:	e8 c2 8a ff ff       	call   c0102c7f <lock_create>
c010a1bd:	89 c6                	mov    %eax,%esi

    /*
     * make sure acquiring l1 doesn't somehow make this
     * thread think that it holds all locks
     */
    lock_acquire(l1);
c010a1bf:	89 1c 24             	mov    %ebx,(%esp)
c010a1c2:	e8 08 8c ff ff       	call   c0102dcf <lock_acquire>
    assert(lock_holding(l1));
c010a1c7:	89 1c 24             	mov    %ebx,(%esp)
c010a1ca:	e8 9c 8b ff ff       	call   c0102d6b <lock_holding>
c010a1cf:	83 c4 10             	add    $0x10,%esp
c010a1d2:	84 c0                	test   %al,%al
c010a1d4:	75 2b                	jne    c010a201 <locktester_simple+0x1f6>
c010a1d6:	83 ec 0c             	sub    $0xc,%esp
c010a1d9:	68 94 d7 10 c0       	push   $0xc010d794
c010a1de:	68 23 02 00 00       	push   $0x223
c010a1e3:	68 9b d4 10 c0       	push   $0xc010d49b
c010a1e8:	68 87 d6 10 c0       	push   $0xc010d687
c010a1ed:	68 95 a9 10 c0       	push   $0xc010a995
c010a1f2:	e8 cd 9b ff ff       	call   c0103dc4 <print>
c010a1f7:	83 c4 20             	add    $0x20,%esp
c010a1fa:	e8 4b 6c ff ff       	call   c0100e4a <backtrace>
c010a1ff:	fa                   	cli    
c010a200:	f4                   	hlt    
    assert(!lock_holding(l2));
c010a201:	83 ec 0c             	sub    $0xc,%esp
c010a204:	56                   	push   %esi
c010a205:	e8 61 8b ff ff       	call   c0102d6b <lock_holding>
c010a20a:	83 c4 10             	add    $0x10,%esp
c010a20d:	84 c0                	test   %al,%al
c010a20f:	74 2b                	je     c010a23c <locktester_simple+0x231>
c010a211:	83 ec 0c             	sub    $0xc,%esp
c010a214:	68 94 d7 10 c0       	push   $0xc010d794
c010a219:	68 24 02 00 00       	push   $0x224
c010a21e:	68 9b d4 10 c0       	push   $0xc010d49b
c010a223:	68 9b d6 10 c0       	push   $0xc010d69b
c010a228:	68 95 a9 10 c0       	push   $0xc010a995
c010a22d:	e8 92 9b ff ff       	call   c0103dc4 <print>
c010a232:	83 c4 20             	add    $0x20,%esp
c010a235:	e8 10 6c ff ff       	call   c0100e4a <backtrace>
c010a23a:	fa                   	cli    
c010a23b:	f4                   	hlt    

    return 0;
}
c010a23c:	31 c0                	xor    %eax,%eax
c010a23e:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010a241:	5b                   	pop    %ebx
c010a242:	5e                   	pop    %esi
c010a243:	5d                   	pop    %ebp
c010a244:	c3                   	ret    

c010a245 <locktester_array>:
}

// tests multiple threads trying to acquire a single lock
// makes sure each thread gets the lock eventually and that
// data structure has expected post state
int locktester_array(void) {
c010a245:	55                   	push   %ebp
c010a246:	89 e5                	mov    %esp,%ebp
c010a248:	57                   	push   %edi
c010a249:	56                   	push   %esi
c010a24a:	53                   	push   %ebx
c010a24b:	83 ec 3c             	sub    $0x3c,%esp
c010a24e:	8d 7d c8             	lea    -0x38(%ebp),%edi
    unsigned int i;
    int err;
    struct thread *threads[NTHREADS];

    for (i = 0; i < NTHREADS; i++) {
c010a251:	31 db                	xor    %ebx,%ebx
c010a253:	89 fe                	mov    %edi,%esi
        err = thread_fork("locktest_array_thread", &threads[i], NULL,
c010a255:	52                   	push   %edx
c010a256:	52                   	push   %edx
c010a257:	53                   	push   %ebx
c010a258:	6a 00                	push   $0x0
c010a25a:	68 63 97 10 c0       	push   $0xc0109763
c010a25f:	6a 00                	push   $0x0
c010a261:	57                   	push   %edi
c010a262:	68 ad d6 10 c0       	push   $0xc010d6ad
c010a267:	e8 21 cd ff ff       	call   c0106f8d <thread_fork>
                          locktester_array_thread, NULL, i);
        if (err) {
c010a26c:	83 c4 20             	add    $0x20,%esp
c010a26f:	85 c0                	test   %eax,%eax
c010a271:	74 1c                	je     c010a28f <locktester_array+0x4a>
            panic("locktest: thread_fork failed\n");
c010a273:	68 c3 d6 10 c0       	push   $0xc010d6c3
c010a278:	68 80 d7 10 c0       	push   $0xc010d780
c010a27d:	68 3e 02 00 00       	push   $0x23e
c010a282:	68 9b d4 10 c0       	push   $0xc010d49b
c010a287:	e8 b6 96 ff ff       	call   c0103942 <_panic>
c010a28c:	83 c4 10             	add    $0x10,%esp
int locktester_array(void) {
    unsigned int i;
    int err;
    struct thread *threads[NTHREADS];

    for (i = 0; i < NTHREADS; i++) {
c010a28f:	43                   	inc    %ebx
c010a290:	83 c7 04             	add    $0x4,%edi
c010a293:	83 fb 08             	cmp    $0x8,%ebx
c010a296:	75 bd                	jne    c010a255 <locktester_array+0x10>
c010a298:	31 db                	xor    %ebx,%ebx
        }
    }

    int ret;
    for (i = 0; i < NTHREADS; i++) {
        thread_join(threads[i], &ret);
c010a29a:	8d 7d c4             	lea    -0x3c(%ebp),%edi
c010a29d:	50                   	push   %eax
c010a29e:	50                   	push   %eax
c010a29f:	57                   	push   %edi
c010a2a0:	ff 34 9e             	pushl  (%esi,%ebx,4)
c010a2a3:	e8 f9 ca ff ff       	call   c0106da1 <thread_join>
            panic("locktest: thread_fork failed\n");
        }
    }

    int ret;
    for (i = 0; i < NTHREADS; i++) {
c010a2a8:	43                   	inc    %ebx
c010a2a9:	83 c4 10             	add    $0x10,%esp
c010a2ac:	83 fb 08             	cmp    $0x8,%ebx
c010a2af:	75 ec                	jne    c010a29d <locktester_array+0x58>
c010a2b1:	31 db                	xor    %ebx,%ebx
        thread_join(threads[i], &ret);
    }

    for (i = 0; i < NTHREADS;i++) {
        assert(testarray[i]);
c010a2b3:	a1 20 6e 13 c0       	mov    0xc0136e20,%eax
c010a2b8:	01 d8                	add    %ebx,%eax
c010a2ba:	8a 00                	mov    (%eax),%al
c010a2bc:	84 c0                	test   %al,%al
c010a2be:	75 2b                	jne    c010a2eb <locktester_array+0xa6>
c010a2c0:	83 ec 0c             	sub    $0xc,%esp
c010a2c3:	68 80 d7 10 c0       	push   $0xc010d780
c010a2c8:	68 48 02 00 00       	push   $0x248
c010a2cd:	68 9b d4 10 c0       	push   $0xc010d49b
c010a2d2:	68 e1 d6 10 c0       	push   $0xc010d6e1
c010a2d7:	68 95 a9 10 c0       	push   $0xc010a995
c010a2dc:	e8 e3 9a ff ff       	call   c0103dc4 <print>
c010a2e1:	83 c4 20             	add    $0x20,%esp
c010a2e4:	e8 61 6b ff ff       	call   c0100e4a <backtrace>
c010a2e9:	fa                   	cli    
c010a2ea:	f4                   	hlt    
    int ret;
    for (i = 0; i < NTHREADS; i++) {
        thread_join(threads[i], &ret);
    }

    for (i = 0; i < NTHREADS;i++) {
c010a2eb:	43                   	inc    %ebx
c010a2ec:	83 fb 08             	cmp    $0x8,%ebx
c010a2ef:	75 c2                	jne    c010a2b3 <locktester_array+0x6e>
        assert(testarray[i]);
    }

    return 0;
}
c010a2f1:	31 c0                	xor    %eax,%eax
c010a2f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010a2f6:	5b                   	pop    %ebx
c010a2f7:	5e                   	pop    %esi
c010a2f8:	5f                   	pop    %edi
c010a2f9:	5d                   	pop    %ebp
c010a2fa:	c3                   	ret    

c010a2fb <locktester>:
    for (i = 0; i < NTHREADS; i++)
        testarray[i] = false;
}

// launches each lock test and returns the test's return value
int locktester(int test) {
c010a2fb:	55                   	push   %ebp
c010a2fc:	89 e5                	mov    %esp,%ebp
c010a2fe:	53                   	push   %ebx
c010a2ff:	50                   	push   %eax
c010a300:	8b 5d 08             	mov    0x8(%ebp),%ebx
    init_lock_items();
c010a303:	e8 9a fc ff ff       	call   c0109fa2 <init_lock_items>
    switch (test) {
c010a308:	85 db                	test   %ebx,%ebx
c010a30a:	74 0b                	je     c010a317 <locktester+0x1c>
c010a30c:	4b                   	dec    %ebx
c010a30d:	75 10                	jne    c010a31f <locktester+0x24>
        case 1:
            return locktester_array();
        default:
            return 0;
    }
}
c010a30f:	59                   	pop    %ecx
c010a310:	5b                   	pop    %ebx
c010a311:	5d                   	pop    %ebp
    init_lock_items();
    switch (test) {
        case 0:
            return locktester_simple();
        case 1:
            return locktester_array();
c010a312:	e9 2e ff ff ff       	jmp    c010a245 <locktester_array>
        default:
            return 0;
    }
}
c010a317:	5b                   	pop    %ebx
c010a318:	5b                   	pop    %ebx
c010a319:	5d                   	pop    %ebp
// launches each lock test and returns the test's return value
int locktester(int test) {
    init_lock_items();
    switch (test) {
        case 0:
            return locktester_simple();
c010a31a:	e9 ec fc ff ff       	jmp    c010a00b <locktester_simple>
        case 1:
            return locktester_array();
        default:
            return 0;
    }
}
c010a31f:	31 c0                	xor    %eax,%eax
c010a321:	5a                   	pop    %edx
c010a322:	5b                   	pop    %ebx
c010a323:	5d                   	pop    %ebp
c010a324:	c3                   	ret    

c010a325 <queue_ts_init>:
//////////////////////////////////////*/

static struct queue_ts* q;

// checks that a queue_ts can be created
int queue_ts_init(void) {
c010a325:	55                   	push   %ebp
c010a326:	89 e5                	mov    %esp,%ebp
c010a328:	83 ec 08             	sub    $0x8,%esp
    q = queue_ts_create();
c010a32b:	e8 c2 c1 ff ff       	call   c01064f2 <queue_ts_create>
c010a330:	89 c2                	mov    %eax,%edx
c010a332:	a3 c0 6d 13 c0       	mov    %eax,0xc0136dc0
c010a337:	83 c8 ff             	or     $0xffffffff,%eax
    if (q == NULL)
c010a33a:	85 d2                	test   %edx,%edx
c010a33c:	74 0e                	je     c010a34c <queue_ts_init+0x27>
        return -1;
    queue_ts_destroy(q);
c010a33e:	83 ec 0c             	sub    $0xc,%esp
c010a341:	52                   	push   %edx
c010a342:	e8 7f c4 ff ff       	call   c01067c6 <queue_ts_destroy>
    return  0;
c010a347:	83 c4 10             	add    $0x10,%esp
c010a34a:	31 c0                	xor    %eax,%eax
}
c010a34c:	c9                   	leave  
c010a34d:	c3                   	ret    

c010a34e <push_pop_seq>:

// checks that regular pop returns values when they are present (impl test)
int push_pop_seq(void) {
c010a34e:	55                   	push   %ebp
c010a34f:	89 e5                	mov    %esp,%ebp
c010a351:	56                   	push   %esi
c010a352:	53                   	push   %ebx
    q = queue_ts_create();
c010a353:	e8 9a c1 ff ff       	call   c01064f2 <queue_ts_create>
c010a358:	a3 c0 6d 13 c0       	mov    %eax,0xc0136dc0
    // int* j = NULL;
    for (int i = 0; i < NTHREADS; ++i) {
c010a35d:	31 db                	xor    %ebx,%ebx
        int* j = (int*) kmalloc(sizeof(int));
c010a35f:	83 ec 0c             	sub    $0xc,%esp
c010a362:	6a 04                	push   $0x4
c010a364:	e8 3c 75 ff ff       	call   c01018a5 <kmalloc>
c010a369:	89 c6                	mov    %eax,%esi
        assert(j != NULL);
c010a36b:	83 c4 10             	add    $0x10,%esp
c010a36e:	85 c0                	test   %eax,%eax
c010a370:	75 2b                	jne    c010a39d <push_pop_seq+0x4f>
c010a372:	83 ec 0c             	sub    $0xc,%esp
c010a375:	68 70 d7 10 c0       	push   $0xc010d770
c010a37a:	68 64 02 00 00       	push   $0x264
c010a37f:	68 9b d4 10 c0       	push   $0xc010d49b
c010a384:	68 ee d6 10 c0       	push   $0xc010d6ee
c010a389:	68 95 a9 10 c0       	push   $0xc010a995
c010a38e:	e8 31 9a ff ff       	call   c0103dc4 <print>
c010a393:	83 c4 20             	add    $0x20,%esp
c010a396:	e8 af 6a ff ff       	call   c0100e4a <backtrace>
c010a39b:	fa                   	cli    
c010a39c:	f4                   	hlt    
        *j = i;
c010a39d:	89 1e                	mov    %ebx,(%esi)
        queue_ts_push(q, j);
c010a39f:	50                   	push   %eax
c010a3a0:	50                   	push   %eax
c010a3a1:	56                   	push   %esi
c010a3a2:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a3a8:	e8 e0 c1 ff ff       	call   c010658d <queue_ts_push>

// checks that regular pop returns values when they are present (impl test)
int push_pop_seq(void) {
    q = queue_ts_create();
    // int* j = NULL;
    for (int i = 0; i < NTHREADS; ++i) {
c010a3ad:	43                   	inc    %ebx
c010a3ae:	83 c4 10             	add    $0x10,%esp
c010a3b1:	83 fb 08             	cmp    $0x8,%ebx
c010a3b4:	75 a9                	jne    c010a35f <push_pop_seq+0x11>
c010a3b6:	31 db                	xor    %ebx,%ebx
        assert(j != NULL);
        *j = i;
        queue_ts_push(q, j);
    }
    for (int i = 0; i < NTHREADS; ++i) {
        int* j = (int*) queue_ts_pop(q);
c010a3b8:	83 ec 0c             	sub    $0xc,%esp
c010a3bb:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a3c1:	e8 35 c2 ff ff       	call   c01065fb <queue_ts_pop>
        if (*j != i) {
c010a3c6:	83 c4 10             	add    $0x10,%esp
c010a3c9:	39 18                	cmp    %ebx,(%eax)
c010a3cb:	74 4a                	je     c010a417 <push_pop_seq+0xc9>
            kfree(j);
c010a3cd:	83 ec 0c             	sub    $0xc,%esp
c010a3d0:	50                   	push   %eax
            while (!queue_ts_isempty(q))
                kfree(queue_ts_pop_blocking(q));
c010a3d1:	e8 9b 75 ff ff       	call   c0101971 <kfree>
c010a3d6:	83 c4 10             	add    $0x10,%esp
    }
    for (int i = 0; i < NTHREADS; ++i) {
        int* j = (int*) queue_ts_pop(q);
        if (*j != i) {
            kfree(j);
            while (!queue_ts_isempty(q))
c010a3d9:	83 ec 0c             	sub    $0xc,%esp
c010a3dc:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a3e2:	e8 25 c3 ff ff       	call   c010670c <queue_ts_isempty>
c010a3e7:	83 c4 10             	add    $0x10,%esp
c010a3ea:	85 c0                	test   %eax,%eax
c010a3ec:	75 13                	jne    c010a401 <push_pop_seq+0xb3>
                kfree(queue_ts_pop_blocking(q));
c010a3ee:	83 ec 0c             	sub    $0xc,%esp
c010a3f1:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a3f7:	e8 7a c2 ff ff       	call   c0106676 <queue_ts_pop_blocking>
c010a3fc:	89 04 24             	mov    %eax,(%esp)
c010a3ff:	eb d0                	jmp    c010a3d1 <push_pop_seq+0x83>
            queue_ts_destroy(q);
c010a401:	83 ec 0c             	sub    $0xc,%esp
c010a404:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a40a:	e8 b7 c3 ff ff       	call   c01067c6 <queue_ts_destroy>
            return -1;
c010a40f:	83 c4 10             	add    $0x10,%esp
c010a412:	83 c8 ff             	or     $0xffffffff,%eax
c010a415:	eb 25                	jmp    c010a43c <push_pop_seq+0xee>
        }
        kfree(j);
c010a417:	83 ec 0c             	sub    $0xc,%esp
c010a41a:	50                   	push   %eax
c010a41b:	e8 51 75 ff ff       	call   c0101971 <kfree>
        int* j = (int*) kmalloc(sizeof(int));
        assert(j != NULL);
        *j = i;
        queue_ts_push(q, j);
    }
    for (int i = 0; i < NTHREADS; ++i) {
c010a420:	43                   	inc    %ebx
c010a421:	83 c4 10             	add    $0x10,%esp
c010a424:	83 fb 08             	cmp    $0x8,%ebx
c010a427:	75 8f                	jne    c010a3b8 <push_pop_seq+0x6a>
            queue_ts_destroy(q);
            return -1;
        }
        kfree(j);
    }
    queue_ts_destroy(q);
c010a429:	83 ec 0c             	sub    $0xc,%esp
c010a42c:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a432:	e8 8f c3 ff ff       	call   c01067c6 <queue_ts_destroy>
    return 0;
c010a437:	83 c4 10             	add    $0x10,%esp
c010a43a:	31 c0                	xor    %eax,%eax
}
c010a43c:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010a43f:	5b                   	pop    %ebx
c010a440:	5e                   	pop    %esi
c010a441:	5d                   	pop    %ebp
c010a442:	c3                   	ret    

c010a443 <pop_blocking_seq>:

// tests that pop_blocking properly returns values when they are present
int pop_blocking_seq(void) {
c010a443:	55                   	push   %ebp
c010a444:	89 e5                	mov    %esp,%ebp
c010a446:	56                   	push   %esi
c010a447:	53                   	push   %ebx
    q = queue_ts_create();
c010a448:	e8 a5 c0 ff ff       	call   c01064f2 <queue_ts_create>
c010a44d:	a3 c0 6d 13 c0       	mov    %eax,0xc0136dc0
    for (int i = 0; i < NTHREADS * 4; ++i) {
c010a452:	31 db                	xor    %ebx,%ebx
        int* j = (int*) kmalloc(sizeof(int));
c010a454:	83 ec 0c             	sub    $0xc,%esp
c010a457:	6a 04                	push   $0x4
c010a459:	e8 47 74 ff ff       	call   c01018a5 <kmalloc>
c010a45e:	89 c6                	mov    %eax,%esi
        assert(j != NULL);
c010a460:	83 c4 10             	add    $0x10,%esp
c010a463:	85 c0                	test   %eax,%eax
c010a465:	75 2b                	jne    c010a492 <pop_blocking_seq+0x4f>
c010a467:	83 ec 0c             	sub    $0xc,%esp
c010a46a:	68 5c d7 10 c0       	push   $0xc010d75c
c010a46f:	68 7c 02 00 00       	push   $0x27c
c010a474:	68 9b d4 10 c0       	push   $0xc010d49b
c010a479:	68 ee d6 10 c0       	push   $0xc010d6ee
c010a47e:	68 95 a9 10 c0       	push   $0xc010a995
c010a483:	e8 3c 99 ff ff       	call   c0103dc4 <print>
c010a488:	83 c4 20             	add    $0x20,%esp
c010a48b:	e8 ba 69 ff ff       	call   c0100e4a <backtrace>
c010a490:	fa                   	cli    
c010a491:	f4                   	hlt    
        *j = i;
c010a492:	89 1e                	mov    %ebx,(%esi)
        queue_ts_push(q, j);
c010a494:	50                   	push   %eax
c010a495:	50                   	push   %eax
c010a496:	56                   	push   %esi
c010a497:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a49d:	e8 eb c0 ff ff       	call   c010658d <queue_ts_push>
}

// tests that pop_blocking properly returns values when they are present
int pop_blocking_seq(void) {
    q = queue_ts_create();
    for (int i = 0; i < NTHREADS * 4; ++i) {
c010a4a2:	43                   	inc    %ebx
c010a4a3:	83 c4 10             	add    $0x10,%esp
c010a4a6:	83 fb 20             	cmp    $0x20,%ebx
c010a4a9:	75 a9                	jne    c010a454 <pop_blocking_seq+0x11>
c010a4ab:	31 db                	xor    %ebx,%ebx
        assert(j != NULL);
        *j = i;
        queue_ts_push(q, j);
    }
    for (int i = 0; i < NTHREADS * 4; ++i) {
        int* j = (int*) queue_ts_pop_blocking(q);
c010a4ad:	83 ec 0c             	sub    $0xc,%esp
c010a4b0:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a4b6:	e8 bb c1 ff ff       	call   c0106676 <queue_ts_pop_blocking>
        if (*j != i) {
c010a4bb:	83 c4 10             	add    $0x10,%esp
c010a4be:	39 18                	cmp    %ebx,(%eax)
c010a4c0:	74 4a                	je     c010a50c <pop_blocking_seq+0xc9>
            kfree(j);
c010a4c2:	83 ec 0c             	sub    $0xc,%esp
c010a4c5:	50                   	push   %eax
            while (!queue_ts_isempty(q))
                kfree(queue_ts_pop_blocking(q));
c010a4c6:	e8 a6 74 ff ff       	call   c0101971 <kfree>
c010a4cb:	83 c4 10             	add    $0x10,%esp
    }
    for (int i = 0; i < NTHREADS * 4; ++i) {
        int* j = (int*) queue_ts_pop_blocking(q);
        if (*j != i) {
            kfree(j);
            while (!queue_ts_isempty(q))
c010a4ce:	83 ec 0c             	sub    $0xc,%esp
c010a4d1:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a4d7:	e8 30 c2 ff ff       	call   c010670c <queue_ts_isempty>
c010a4dc:	83 c4 10             	add    $0x10,%esp
c010a4df:	85 c0                	test   %eax,%eax
c010a4e1:	75 13                	jne    c010a4f6 <pop_blocking_seq+0xb3>
                kfree(queue_ts_pop_blocking(q));
c010a4e3:	83 ec 0c             	sub    $0xc,%esp
c010a4e6:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a4ec:	e8 85 c1 ff ff       	call   c0106676 <queue_ts_pop_blocking>
c010a4f1:	89 04 24             	mov    %eax,(%esp)
c010a4f4:	eb d0                	jmp    c010a4c6 <pop_blocking_seq+0x83>
            queue_ts_destroy(q);
c010a4f6:	83 ec 0c             	sub    $0xc,%esp
c010a4f9:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a4ff:	e8 c2 c2 ff ff       	call   c01067c6 <queue_ts_destroy>
            return -1;
c010a504:	83 c4 10             	add    $0x10,%esp
c010a507:	83 c8 ff             	or     $0xffffffff,%eax
c010a50a:	eb 25                	jmp    c010a531 <pop_blocking_seq+0xee>
        }
        kfree(j);
c010a50c:	83 ec 0c             	sub    $0xc,%esp
c010a50f:	50                   	push   %eax
c010a510:	e8 5c 74 ff ff       	call   c0101971 <kfree>
        int* j = (int*) kmalloc(sizeof(int));
        assert(j != NULL);
        *j = i;
        queue_ts_push(q, j);
    }
    for (int i = 0; i < NTHREADS * 4; ++i) {
c010a515:	43                   	inc    %ebx
c010a516:	83 c4 10             	add    $0x10,%esp
c010a519:	83 fb 20             	cmp    $0x20,%ebx
c010a51c:	75 8f                	jne    c010a4ad <pop_blocking_seq+0x6a>
            queue_ts_destroy(q);
            return -1;
        }
        kfree(j);
    }
    queue_ts_destroy(q);
c010a51e:	83 ec 0c             	sub    $0xc,%esp
c010a521:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a527:	e8 9a c2 ff ff       	call   c01067c6 <queue_ts_destroy>
    return 0;
c010a52c:	83 c4 10             	add    $0x10,%esp
c010a52f:	31 c0                	xor    %eax,%eax
}
c010a531:	8d 65 f8             	lea    -0x8(%ebp),%esp
c010a534:	5b                   	pop    %ebx
c010a535:	5e                   	pop    %esi
c010a536:	5d                   	pop    %ebp
c010a537:	c3                   	ret    

c010a538 <queuetester>:

    return 0;
}

// launches each queue_ts test and returns the test's return value
int queuetester(int test) {
c010a538:	55                   	push   %ebp
c010a539:	89 e5                	mov    %esp,%ebp
c010a53b:	57                   	push   %edi
c010a53c:	56                   	push   %esi
c010a53d:	53                   	push   %ebx
c010a53e:	83 ec 4c             	sub    $0x4c,%esp
c010a541:	8b 55 08             	mov    0x8(%ebp),%edx
    struct thread* t[NTHREADS] = {NULL};
c010a544:	8d 7d c8             	lea    -0x38(%ebp),%edi
c010a547:	31 c0                	xor    %eax,%eax
c010a549:	b9 08 00 00 00       	mov    $0x8,%ecx
c010a54e:	f3 ab                	rep stos %eax,%es:(%edi)
    char name[16] = {'\0'};
c010a550:	8d 7d b8             	lea    -0x48(%ebp),%edi
c010a553:	b9 04 00 00 00       	mov    $0x4,%ecx
c010a558:	f3 ab                	rep stos %eax,%es:(%edi)
    int tret = 0;
c010a55a:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
    int ret = 0;
    switch (test) {
c010a561:	83 fa 01             	cmp    $0x1,%edx
c010a564:	74 23                	je     c010a589 <queuetester+0x51>
c010a566:	7f 12                	jg     c010a57a <queuetester+0x42>
c010a568:	85 d2                	test   %edx,%edx
c010a56a:	0f 85 8a 01 00 00    	jne    c010a6fa <queuetester+0x1c2>
        case 0:
            return queue_ts_init();
c010a570:	e8 b0 fd ff ff       	call   c010a325 <queue_ts_init>
c010a575:	e9 82 01 00 00       	jmp    c010a6fc <queuetester+0x1c4>
int queuetester(int test) {
    struct thread* t[NTHREADS] = {NULL};
    char name[16] = {'\0'};
    int tret = 0;
    int ret = 0;
    switch (test) {
c010a57a:	83 fa 02             	cmp    $0x2,%edx
c010a57d:	74 14                	je     c010a593 <queuetester+0x5b>
c010a57f:	83 fa 03             	cmp    $0x3,%edx
c010a582:	74 19                	je     c010a59d <queuetester+0x65>
c010a584:	e9 71 01 00 00       	jmp    c010a6fa <queuetester+0x1c2>
        case 0:
            return queue_ts_init();
        case 1:
            return push_pop_seq();
c010a589:	e8 c0 fd ff ff       	call   c010a34e <push_pop_seq>
c010a58e:	e9 69 01 00 00       	jmp    c010a6fc <queuetester+0x1c4>
        case 2:
            return pop_blocking_seq();
c010a593:	e8 ab fe ff ff       	call   c010a443 <pop_blocking_seq>
c010a598:	e9 5f 01 00 00       	jmp    c010a6fc <queuetester+0x1c4>
c010a59d:	8d 75 b8             	lea    -0x48(%ebp),%esi
        case 3:
            q = queue_ts_create();
c010a5a0:	e8 4d bf ff ff       	call   c01064f2 <queue_ts_create>
c010a5a5:	a3 c0 6d 13 c0       	mov    %eax,0xc0136dc0
            assert(queue_ts_isempty(q));
c010a5aa:	83 ec 0c             	sub    $0xc,%esp
c010a5ad:	50                   	push   %eax
c010a5ae:	e8 59 c1 ff ff       	call   c010670c <queue_ts_isempty>
c010a5b3:	83 c4 10             	add    $0x10,%esp
c010a5b6:	85 c0                	test   %eax,%eax
c010a5b8:	75 2b                	jne    c010a5e5 <queuetester+0xad>
c010a5ba:	83 ec 0c             	sub    $0xc,%esp
c010a5bd:	68 40 d7 10 c0       	push   $0xc010d740
c010a5c2:	68 ae 02 00 00       	push   $0x2ae
c010a5c7:	68 9b d4 10 c0       	push   $0xc010d49b
c010a5cc:	68 ec d4 10 c0       	push   $0xc010d4ec
c010a5d1:	68 95 a9 10 c0       	push   $0xc010a995
c010a5d6:	e8 e9 97 ff ff       	call   c0103dc4 <print>
c010a5db:	83 c4 20             	add    $0x20,%esp
c010a5de:	e8 67 68 ff ff       	call   c0100e4a <backtrace>
c010a5e3:	fa                   	cli    
c010a5e4:	f4                   	hlt    
c010a5e5:	8d 7d c8             	lea    -0x38(%ebp),%edi

    return 0;
}

// launches each queue_ts test and returns the test's return value
int queuetester(int test) {
c010a5e8:	31 db                	xor    %ebx,%ebx
        case 3:
            q = queue_ts_create();
            assert(queue_ts_isempty(q));
            // fork a bunch of theads that will wait for the !queue_ts_isempty
            for (int i = 0; i < NTHREADS; ++i) {
                snprintf(name, sizeof(name), "%s%d", __func__, i);
c010a5ea:	83 ec 0c             	sub    $0xc,%esp
c010a5ed:	53                   	push   %ebx
c010a5ee:	68 40 d7 10 c0       	push   $0xc010d740
c010a5f3:	68 f8 d6 10 c0       	push   $0xc010d6f8
c010a5f8:	6a 10                	push   $0x10
c010a5fa:	56                   	push   %esi
c010a5fb:	e8 c1 9c ff ff       	call   c01042c1 <snprintf>
                ret = thread_fork(name, &t[i], NULL, push_pop_par, NULL, i);
c010a600:	83 c4 18             	add    $0x18,%esp
c010a603:	53                   	push   %ebx
c010a604:	6a 00                	push   $0x0
c010a606:	68 27 98 10 c0       	push   $0xc0109827
c010a60b:	6a 00                	push   $0x0
c010a60d:	57                   	push   %edi
c010a60e:	56                   	push   %esi
c010a60f:	e8 79 c9 ff ff       	call   c0106f8d <thread_fork>
                if (ret)
c010a614:	83 c4 20             	add    $0x20,%esp
c010a617:	85 c0                	test   %eax,%eax
c010a619:	74 1c                	je     c010a637 <queuetester+0xff>
                    panic("queuetester: thread_fork failed\n");
c010a61b:	68 fd d6 10 c0       	push   $0xc010d6fd
c010a620:	68 40 d7 10 c0       	push   $0xc010d740
c010a625:	68 b4 02 00 00       	push   $0x2b4
c010a62a:	68 9b d4 10 c0       	push   $0xc010d49b
c010a62f:	e8 0e 93 ff ff       	call   c0103942 <_panic>
c010a634:	83 c4 10             	add    $0x10,%esp
            return pop_blocking_seq();
        case 3:
            q = queue_ts_create();
            assert(queue_ts_isempty(q));
            // fork a bunch of theads that will wait for the !queue_ts_isempty
            for (int i = 0; i < NTHREADS; ++i) {
c010a637:	43                   	inc    %ebx
c010a638:	83 c7 04             	add    $0x4,%edi
c010a63b:	83 fb 08             	cmp    $0x8,%ebx
c010a63e:	75 aa                	jne    c010a5ea <queuetester+0xb2>
c010a640:	bb 07 00 00 00       	mov    $0x7,%ebx
                if (ret)
                    panic("queuetester: thread_fork failed\n");
            }
            // wait just a bit so each thread will be asleep
            for (int i = 0; i < NTHREADS - 1; ++i)
                sys_yield();
c010a645:	e8 09 63 ff ff       	call   c0100953 <sys_yield>
                ret = thread_fork(name, &t[i], NULL, push_pop_par, NULL, i);
                if (ret)
                    panic("queuetester: thread_fork failed\n");
            }
            // wait just a bit so each thread will be asleep
            for (int i = 0; i < NTHREADS - 1; ++i)
c010a64a:	4b                   	dec    %ebx
c010a64b:	75 f8                	jne    c010a645 <queuetester+0x10d>
c010a64d:	bb 08 00 00 00       	mov    $0x8,%ebx
                sys_yield();
            // push values into the queue (and indirectly signal the waiting
            // threads)
            for (int i = 0; i < NTHREADS; ++i) {
                int* j = (int*) kmalloc(sizeof(int));
c010a652:	83 ec 0c             	sub    $0xc,%esp
c010a655:	6a 04                	push   $0x4
c010a657:	e8 49 72 ff ff       	call   c01018a5 <kmalloc>
c010a65c:	89 c6                	mov    %eax,%esi
                assert(j != NULL);
c010a65e:	83 c4 10             	add    $0x10,%esp
c010a661:	85 c0                	test   %eax,%eax
c010a663:	75 2b                	jne    c010a690 <queuetester+0x158>
c010a665:	83 ec 0c             	sub    $0xc,%esp
c010a668:	68 40 d7 10 c0       	push   $0xc010d740
c010a66d:	68 bd 02 00 00       	push   $0x2bd
c010a672:	68 9b d4 10 c0       	push   $0xc010d49b
c010a677:	68 ee d6 10 c0       	push   $0xc010d6ee
c010a67c:	68 95 a9 10 c0       	push   $0xc010a995
c010a681:	e8 3e 97 ff ff       	call   c0103dc4 <print>
c010a686:	83 c4 20             	add    $0x20,%esp
c010a689:	e8 bc 67 ff ff       	call   c0100e4a <backtrace>
c010a68e:	fa                   	cli    
c010a68f:	f4                   	hlt    
                *j = i + NTHREADS;
c010a690:	89 1e                	mov    %ebx,(%esi)
                queue_ts_push(q, j);
c010a692:	52                   	push   %edx
c010a693:	52                   	push   %edx
c010a694:	56                   	push   %esi
c010a695:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a69b:	e8 ed be ff ff       	call   c010658d <queue_ts_push>
c010a6a0:	43                   	inc    %ebx
            // wait just a bit so each thread will be asleep
            for (int i = 0; i < NTHREADS - 1; ++i)
                sys_yield();
            // push values into the queue (and indirectly signal the waiting
            // threads)
            for (int i = 0; i < NTHREADS; ++i) {
c010a6a1:	83 c4 10             	add    $0x10,%esp
c010a6a4:	83 fb 10             	cmp    $0x10,%ebx
c010a6a7:	75 a9                	jne    c010a652 <queuetester+0x11a>
c010a6a9:	31 db                	xor    %ebx,%ebx
                *j = i + NTHREADS;
                queue_ts_push(q, j);
            }
            // join each thread back
            for (int i = 0; i < NTHREADS; ++i) {
                ret = thread_join(t[i], &tret);
c010a6ab:	8d 75 b4             	lea    -0x4c(%ebp),%esi
c010a6ae:	50                   	push   %eax
c010a6af:	50                   	push   %eax
c010a6b0:	56                   	push   %esi
c010a6b1:	ff 74 9d c8          	pushl  -0x38(%ebp,%ebx,4)
c010a6b5:	e8 e7 c6 ff ff       	call   c0106da1 <thread_join>
                if (ret)
c010a6ba:	83 c4 10             	add    $0x10,%esp
c010a6bd:	85 c0                	test   %eax,%eax
c010a6bf:	74 1c                	je     c010a6dd <queuetester+0x1a5>
                    panic("queuetester: thread_join failed\n");
c010a6c1:	68 1e d7 10 c0       	push   $0xc010d71e
c010a6c6:	68 40 d7 10 c0       	push   $0xc010d740
c010a6cb:	68 c5 02 00 00       	push   $0x2c5
c010a6d0:	68 9b d4 10 c0       	push   $0xc010d49b
c010a6d5:	e8 68 92 ff ff       	call   c0103942 <_panic>
c010a6da:	83 c4 10             	add    $0x10,%esp
                if (tret != 0)
c010a6dd:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c010a6e1:	75 06                	jne    c010a6e9 <queuetester+0x1b1>
                assert(j != NULL);
                *j = i + NTHREADS;
                queue_ts_push(q, j);
            }
            // join each thread back
            for (int i = 0; i < NTHREADS; ++i) {
c010a6e3:	43                   	inc    %ebx
c010a6e4:	83 fb 08             	cmp    $0x8,%ebx
c010a6e7:	75 c5                	jne    c010a6ae <queuetester+0x176>
                if (ret)
                    panic("queuetester: thread_join failed\n");
                if (tret != 0)
                    break;
            }
            queue_ts_destroy(q);
c010a6e9:	83 ec 0c             	sub    $0xc,%esp
c010a6ec:	ff 35 c0 6d 13 c0    	pushl  0xc0136dc0
c010a6f2:	e8 cf c0 ff ff       	call   c01067c6 <queue_ts_destroy>
c010a6f7:	83 c4 10             	add    $0x10,%esp
        default:
            return 0;
c010a6fa:	31 c0                	xor    %eax,%eax
    }
    return 0;
}
c010a6fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010a6ff:	5b                   	pop    %ebx
c010a700:	5e                   	pop    %esi
c010a701:	5f                   	pop    %edi
c010a702:	5d                   	pop    %ebp
c010a703:	c3                   	ret    

c010a704 <__udivdi3>:
c010a704:	55                   	push   %ebp
c010a705:	57                   	push   %edi
c010a706:	56                   	push   %esi
c010a707:	53                   	push   %ebx
c010a708:	83 ec 1c             	sub    $0x1c,%esp
c010a70b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
c010a70f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
c010a713:	8b 7c 24 38          	mov    0x38(%esp),%edi
c010a717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010a71b:	89 ca                	mov    %ecx,%edx
c010a71d:	89 f8                	mov    %edi,%eax
c010a71f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
c010a723:	85 f6                	test   %esi,%esi
c010a725:	75 2d                	jne    c010a754 <__udivdi3+0x50>
c010a727:	39 cf                	cmp    %ecx,%edi
c010a729:	77 65                	ja     c010a790 <__udivdi3+0x8c>
c010a72b:	89 fd                	mov    %edi,%ebp
c010a72d:	85 ff                	test   %edi,%edi
c010a72f:	75 0b                	jne    c010a73c <__udivdi3+0x38>
c010a731:	b8 01 00 00 00       	mov    $0x1,%eax
c010a736:	31 d2                	xor    %edx,%edx
c010a738:	f7 f7                	div    %edi
c010a73a:	89 c5                	mov    %eax,%ebp
c010a73c:	31 d2                	xor    %edx,%edx
c010a73e:	89 c8                	mov    %ecx,%eax
c010a740:	f7 f5                	div    %ebp
c010a742:	89 c1                	mov    %eax,%ecx
c010a744:	89 d8                	mov    %ebx,%eax
c010a746:	f7 f5                	div    %ebp
c010a748:	89 cf                	mov    %ecx,%edi
c010a74a:	89 fa                	mov    %edi,%edx
c010a74c:	83 c4 1c             	add    $0x1c,%esp
c010a74f:	5b                   	pop    %ebx
c010a750:	5e                   	pop    %esi
c010a751:	5f                   	pop    %edi
c010a752:	5d                   	pop    %ebp
c010a753:	c3                   	ret    
c010a754:	39 ce                	cmp    %ecx,%esi
c010a756:	77 28                	ja     c010a780 <__udivdi3+0x7c>
c010a758:	0f bd fe             	bsr    %esi,%edi
c010a75b:	83 f7 1f             	xor    $0x1f,%edi
c010a75e:	75 40                	jne    c010a7a0 <__udivdi3+0x9c>
c010a760:	39 ce                	cmp    %ecx,%esi
c010a762:	72 0a                	jb     c010a76e <__udivdi3+0x6a>
c010a764:	3b 44 24 08          	cmp    0x8(%esp),%eax
c010a768:	0f 87 9e 00 00 00    	ja     c010a80c <__udivdi3+0x108>
c010a76e:	b8 01 00 00 00       	mov    $0x1,%eax
c010a773:	89 fa                	mov    %edi,%edx
c010a775:	83 c4 1c             	add    $0x1c,%esp
c010a778:	5b                   	pop    %ebx
c010a779:	5e                   	pop    %esi
c010a77a:	5f                   	pop    %edi
c010a77b:	5d                   	pop    %ebp
c010a77c:	c3                   	ret    
c010a77d:	8d 76 00             	lea    0x0(%esi),%esi
c010a780:	31 ff                	xor    %edi,%edi
c010a782:	31 c0                	xor    %eax,%eax
c010a784:	89 fa                	mov    %edi,%edx
c010a786:	83 c4 1c             	add    $0x1c,%esp
c010a789:	5b                   	pop    %ebx
c010a78a:	5e                   	pop    %esi
c010a78b:	5f                   	pop    %edi
c010a78c:	5d                   	pop    %ebp
c010a78d:	c3                   	ret    
c010a78e:	66 90                	xchg   %ax,%ax
c010a790:	89 d8                	mov    %ebx,%eax
c010a792:	f7 f7                	div    %edi
c010a794:	31 ff                	xor    %edi,%edi
c010a796:	89 fa                	mov    %edi,%edx
c010a798:	83 c4 1c             	add    $0x1c,%esp
c010a79b:	5b                   	pop    %ebx
c010a79c:	5e                   	pop    %esi
c010a79d:	5f                   	pop    %edi
c010a79e:	5d                   	pop    %ebp
c010a79f:	c3                   	ret    
c010a7a0:	bd 20 00 00 00       	mov    $0x20,%ebp
c010a7a5:	89 eb                	mov    %ebp,%ebx
c010a7a7:	29 fb                	sub    %edi,%ebx
c010a7a9:	89 f9                	mov    %edi,%ecx
c010a7ab:	d3 e6                	shl    %cl,%esi
c010a7ad:	89 c5                	mov    %eax,%ebp
c010a7af:	88 d9                	mov    %bl,%cl
c010a7b1:	d3 ed                	shr    %cl,%ebp
c010a7b3:	89 e9                	mov    %ebp,%ecx
c010a7b5:	09 f1                	or     %esi,%ecx
c010a7b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010a7bb:	89 f9                	mov    %edi,%ecx
c010a7bd:	d3 e0                	shl    %cl,%eax
c010a7bf:	89 c5                	mov    %eax,%ebp
c010a7c1:	89 d6                	mov    %edx,%esi
c010a7c3:	88 d9                	mov    %bl,%cl
c010a7c5:	d3 ee                	shr    %cl,%esi
c010a7c7:	89 f9                	mov    %edi,%ecx
c010a7c9:	d3 e2                	shl    %cl,%edx
c010a7cb:	8b 44 24 08          	mov    0x8(%esp),%eax
c010a7cf:	88 d9                	mov    %bl,%cl
c010a7d1:	d3 e8                	shr    %cl,%eax
c010a7d3:	09 c2                	or     %eax,%edx
c010a7d5:	89 d0                	mov    %edx,%eax
c010a7d7:	89 f2                	mov    %esi,%edx
c010a7d9:	f7 74 24 0c          	divl   0xc(%esp)
c010a7dd:	89 d6                	mov    %edx,%esi
c010a7df:	89 c3                	mov    %eax,%ebx
c010a7e1:	f7 e5                	mul    %ebp
c010a7e3:	39 d6                	cmp    %edx,%esi
c010a7e5:	72 19                	jb     c010a800 <__udivdi3+0xfc>
c010a7e7:	74 0b                	je     c010a7f4 <__udivdi3+0xf0>
c010a7e9:	89 d8                	mov    %ebx,%eax
c010a7eb:	31 ff                	xor    %edi,%edi
c010a7ed:	e9 58 ff ff ff       	jmp    c010a74a <__udivdi3+0x46>
c010a7f2:	66 90                	xchg   %ax,%ax
c010a7f4:	8b 54 24 08          	mov    0x8(%esp),%edx
c010a7f8:	89 f9                	mov    %edi,%ecx
c010a7fa:	d3 e2                	shl    %cl,%edx
c010a7fc:	39 c2                	cmp    %eax,%edx
c010a7fe:	73 e9                	jae    c010a7e9 <__udivdi3+0xe5>
c010a800:	8d 43 ff             	lea    -0x1(%ebx),%eax
c010a803:	31 ff                	xor    %edi,%edi
c010a805:	e9 40 ff ff ff       	jmp    c010a74a <__udivdi3+0x46>
c010a80a:	66 90                	xchg   %ax,%ax
c010a80c:	31 c0                	xor    %eax,%eax
c010a80e:	e9 37 ff ff ff       	jmp    c010a74a <__udivdi3+0x46>
c010a813:	90                   	nop

c010a814 <__umoddi3>:
c010a814:	55                   	push   %ebp
c010a815:	57                   	push   %edi
c010a816:	56                   	push   %esi
c010a817:	53                   	push   %ebx
c010a818:	83 ec 1c             	sub    $0x1c,%esp
c010a81b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
c010a81f:	8b 74 24 34          	mov    0x34(%esp),%esi
c010a823:	8b 7c 24 38          	mov    0x38(%esp),%edi
c010a827:	8b 44 24 3c          	mov    0x3c(%esp),%eax
c010a82b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a82f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010a833:	89 f3                	mov    %esi,%ebx
c010a835:	89 fa                	mov    %edi,%edx
c010a837:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010a83b:	89 34 24             	mov    %esi,(%esp)
c010a83e:	85 c0                	test   %eax,%eax
c010a840:	75 1a                	jne    c010a85c <__umoddi3+0x48>
c010a842:	39 f7                	cmp    %esi,%edi
c010a844:	0f 86 a2 00 00 00    	jbe    c010a8ec <__umoddi3+0xd8>
c010a84a:	89 c8                	mov    %ecx,%eax
c010a84c:	89 f2                	mov    %esi,%edx
c010a84e:	f7 f7                	div    %edi
c010a850:	89 d0                	mov    %edx,%eax
c010a852:	31 d2                	xor    %edx,%edx
c010a854:	83 c4 1c             	add    $0x1c,%esp
c010a857:	5b                   	pop    %ebx
c010a858:	5e                   	pop    %esi
c010a859:	5f                   	pop    %edi
c010a85a:	5d                   	pop    %ebp
c010a85b:	c3                   	ret    
c010a85c:	39 f0                	cmp    %esi,%eax
c010a85e:	0f 87 ac 00 00 00    	ja     c010a910 <__umoddi3+0xfc>
c010a864:	0f bd e8             	bsr    %eax,%ebp
c010a867:	83 f5 1f             	xor    $0x1f,%ebp
c010a86a:	0f 84 ac 00 00 00    	je     c010a91c <__umoddi3+0x108>
c010a870:	bf 20 00 00 00       	mov    $0x20,%edi
c010a875:	29 ef                	sub    %ebp,%edi
c010a877:	89 fe                	mov    %edi,%esi
c010a879:	89 7c 24 0c          	mov    %edi,0xc(%esp)
c010a87d:	89 e9                	mov    %ebp,%ecx
c010a87f:	d3 e0                	shl    %cl,%eax
c010a881:	89 d7                	mov    %edx,%edi
c010a883:	89 f1                	mov    %esi,%ecx
c010a885:	d3 ef                	shr    %cl,%edi
c010a887:	09 c7                	or     %eax,%edi
c010a889:	89 e9                	mov    %ebp,%ecx
c010a88b:	d3 e2                	shl    %cl,%edx
c010a88d:	89 14 24             	mov    %edx,(%esp)
c010a890:	89 d8                	mov    %ebx,%eax
c010a892:	d3 e0                	shl    %cl,%eax
c010a894:	89 c2                	mov    %eax,%edx
c010a896:	8b 44 24 08          	mov    0x8(%esp),%eax
c010a89a:	d3 e0                	shl    %cl,%eax
c010a89c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a8a0:	8b 44 24 08          	mov    0x8(%esp),%eax
c010a8a4:	89 f1                	mov    %esi,%ecx
c010a8a6:	d3 e8                	shr    %cl,%eax
c010a8a8:	09 d0                	or     %edx,%eax
c010a8aa:	d3 eb                	shr    %cl,%ebx
c010a8ac:	89 da                	mov    %ebx,%edx
c010a8ae:	f7 f7                	div    %edi
c010a8b0:	89 d3                	mov    %edx,%ebx
c010a8b2:	f7 24 24             	mull   (%esp)
c010a8b5:	89 c6                	mov    %eax,%esi
c010a8b7:	89 d1                	mov    %edx,%ecx
c010a8b9:	39 d3                	cmp    %edx,%ebx
c010a8bb:	0f 82 87 00 00 00    	jb     c010a948 <__umoddi3+0x134>
c010a8c1:	0f 84 91 00 00 00    	je     c010a958 <__umoddi3+0x144>
c010a8c7:	8b 54 24 04          	mov    0x4(%esp),%edx
c010a8cb:	29 f2                	sub    %esi,%edx
c010a8cd:	19 cb                	sbb    %ecx,%ebx
c010a8cf:	89 d8                	mov    %ebx,%eax
c010a8d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
c010a8d5:	d3 e0                	shl    %cl,%eax
c010a8d7:	89 e9                	mov    %ebp,%ecx
c010a8d9:	d3 ea                	shr    %cl,%edx
c010a8db:	09 d0                	or     %edx,%eax
c010a8dd:	89 e9                	mov    %ebp,%ecx
c010a8df:	d3 eb                	shr    %cl,%ebx
c010a8e1:	89 da                	mov    %ebx,%edx
c010a8e3:	83 c4 1c             	add    $0x1c,%esp
c010a8e6:	5b                   	pop    %ebx
c010a8e7:	5e                   	pop    %esi
c010a8e8:	5f                   	pop    %edi
c010a8e9:	5d                   	pop    %ebp
c010a8ea:	c3                   	ret    
c010a8eb:	90                   	nop
c010a8ec:	89 fd                	mov    %edi,%ebp
c010a8ee:	85 ff                	test   %edi,%edi
c010a8f0:	75 0b                	jne    c010a8fd <__umoddi3+0xe9>
c010a8f2:	b8 01 00 00 00       	mov    $0x1,%eax
c010a8f7:	31 d2                	xor    %edx,%edx
c010a8f9:	f7 f7                	div    %edi
c010a8fb:	89 c5                	mov    %eax,%ebp
c010a8fd:	89 f0                	mov    %esi,%eax
c010a8ff:	31 d2                	xor    %edx,%edx
c010a901:	f7 f5                	div    %ebp
c010a903:	89 c8                	mov    %ecx,%eax
c010a905:	f7 f5                	div    %ebp
c010a907:	89 d0                	mov    %edx,%eax
c010a909:	e9 44 ff ff ff       	jmp    c010a852 <__umoddi3+0x3e>
c010a90e:	66 90                	xchg   %ax,%ax
c010a910:	89 c8                	mov    %ecx,%eax
c010a912:	89 f2                	mov    %esi,%edx
c010a914:	83 c4 1c             	add    $0x1c,%esp
c010a917:	5b                   	pop    %ebx
c010a918:	5e                   	pop    %esi
c010a919:	5f                   	pop    %edi
c010a91a:	5d                   	pop    %ebp
c010a91b:	c3                   	ret    
c010a91c:	3b 04 24             	cmp    (%esp),%eax
c010a91f:	72 06                	jb     c010a927 <__umoddi3+0x113>
c010a921:	3b 7c 24 04          	cmp    0x4(%esp),%edi
c010a925:	77 0f                	ja     c010a936 <__umoddi3+0x122>
c010a927:	89 f2                	mov    %esi,%edx
c010a929:	29 f9                	sub    %edi,%ecx
c010a92b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
c010a92f:	89 14 24             	mov    %edx,(%esp)
c010a932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010a936:	8b 44 24 04          	mov    0x4(%esp),%eax
c010a93a:	8b 14 24             	mov    (%esp),%edx
c010a93d:	83 c4 1c             	add    $0x1c,%esp
c010a940:	5b                   	pop    %ebx
c010a941:	5e                   	pop    %esi
c010a942:	5f                   	pop    %edi
c010a943:	5d                   	pop    %ebp
c010a944:	c3                   	ret    
c010a945:	8d 76 00             	lea    0x0(%esi),%esi
c010a948:	2b 04 24             	sub    (%esp),%eax
c010a94b:	19 fa                	sbb    %edi,%edx
c010a94d:	89 d1                	mov    %edx,%ecx
c010a94f:	89 c6                	mov    %eax,%esi
c010a951:	e9 71 ff ff ff       	jmp    c010a8c7 <__umoddi3+0xb3>
c010a956:	66 90                	xchg   %ax,%ax
c010a958:	39 44 24 04          	cmp    %eax,0x4(%esp)
c010a95c:	72 ea                	jb     c010a948 <__umoddi3+0x134>
c010a95e:	89 d9                	mov    %ebx,%ecx
c010a960:	e9 62 ff ff ff       	jmp    c010a8c7 <__umoddi3+0xb3>
