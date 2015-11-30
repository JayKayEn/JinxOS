CC = i386-jos-elf-gcc
CFLAGS = -Wall -Wextra -Werror -m32  -Wno-comment
CFLAGS += -gstabs
# CFLAGS += -Wno-unused-value -Wno-unused-variable -Wno-unused-function
# CFLAGS += -Wno-implicit-function-declaration -Wno-unused-parameter
CFLAGS += -fno-builtin -fno-stack-protector -ffreestanding
CFLAGS += -nostartfiles -nodefaultlibs -nostdinc -nostdlib
CFLAGS += -I./include

LD = i386-jos-elf-ld
LFLAGS = -m elf_i386 -nostdlib

GCC_LIB = ./libgcc.a
# GCC_LIB = /usr/lib/gcc/x86_64-linux-gnu/4.8/libgcc.a
# GCC_LIB := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)

GDBPORT	:= $(shell expr `id -u` % 1024 + 25000)
GDB	:= gdb

CPUS ?= 1

QEMU = qemu-system-i386

QEMUOPTS = -m 256M -serial mon:stdio -smp cpus=$(CPUS) -gdb tcp::$(GDBPORT)
# QEMUOPTS += -M q35
QEMUOPTS += -drive file=jinx,format=raw,if=none,id=kernel
QEMUOPTS += -device piix4-ide,id=piix4-ide
QEMUOPTS += -device ide-hd,drive=kernel,bus=piix4-ide.0

qemu: jinx
	$(QEMU) $(QEMUOPTS)

nox: jinx
	$(QEMU) -nographic $(QEMUOPTS)

qemu-gdb: jinx .gdbinit
	$(QEMU) $(QEMUOPTS) -S

nox-gdb: jinx .gdbinit
	$(QEMU) -nographic $(QEMUOPTS) -S

gdb:
	$(GDB)

.gdbinit: .gdbinit.tmpl
	sed "s/localhost:1234/localhost:$(GDBPORT)/" < $^ > $@

jinx: kernel bootloader
	dd if=/dev/zero of=jinx~ count=10000 2>/dev/null
	dd if=bootloader of=jinx~ conv=notrunc 2>/dev/null
	dd if=kernel of=jinx~ seek=1 conv=notrunc 2>/dev/null
	mv jinx~ jinx

OBJS := obj/entry.o obj/asm.o obj/gdt.o obj/idt.o obj/isr.o obj/e820.o obj/cga.o
OBJS += obj/assert.o obj/console.o obj/irq.o obj/pit.o obj/kbd.o obj/cpu.o
OBJS += obj/spinlock.o obj/kmain.o obj/pmm.o obj/serial.o obj/kbitmap.o obj/kmm.o

LIBC += obj/mem.o obj/str.o obj/print.o obj/mm.o

kernel: $(OBJS) $(LIBC)
	$(LD) -o $@ -T kernel.ld -nostdlib $(LFLAGS) $^ $(GCC_LIB)

bootloader: obj/boot.o obj/bmain.o
	$(LD) $(LFLAGS) -N -e start -Ttext 0x7C00 -o $@ $^
	i386-jos-elf-objcopy -S -O binary -j .text bootloader bootloader
	perl sign.pl bootloader

obj/%.o: %.S
	$(CC) $(CFLAGS) -O3 -c -o $@ $<

obj/%.o: %.c
	$(CC) $(CFLAGS) -Os -c -o $@ $<

clean:
	/bin/rm -rf bootloader kernel jinx obj/* *~ *dSYM
