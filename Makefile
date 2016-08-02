PREFIX := i386-elf-

CC := $(PREFIX)gcc
CFLAGS := -Wall -Wextra -Werror -m32 -Wno-comment -gstabs
CFLAGS += -fno-builtin -fno-stack-protector -ffreestanding
CFLAGS += -nostartfiles -nodefaultlibs -nostdinc -nostdlib

UFLAGS := $(CFLAGS)
UFLAGS += -DUSER -I./user -I./ulib

OBJDIR := obj

LD := $(PREFIX)ld
LFLAGS := -m elf_i386 -nostdlib

AR := $(PREFIX)ar

COPY := $(PREFIX)objcopy
DUMP := $(PREFIX)objdump

GCC_LIB := ./klib/libgcc.a
# GCC_LIB := /usr/lib/gcc/x86_64-linux-gnu/4.8/libgcc.a
# GCC_LIB := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)

GDBPORT	:= $(shell expr `id -u` % 1024 + 25000)
GDB	:= $(PREFIX)gdb

CPUS ?= 1

QEMU := qemu-system-i386

QEMUOPTS = -m 256M -serial mon:stdio -smp cpus=$(CPUS) -gdb tcp::$(GDBPORT)
QEMUOPTS += -M q35
QEMUOPTS += -drive file=$(OBJDIR)/jinx,format=raw,if=none,id=kernel
QEMUOPTS += -device piix4-ide,id=piix4-ide
QEMUOPTS += -device ide-hd,drive=kernel,bus=piix4-ide.0
QEMUOPTS += -smp 1
# QEMUOPTS += -soundhw sb16,adlib,pcspk

default: $(OBJDIR)/jinx

OBJS :=
BINS :=

include boot/Makefrag
include kern/Makefrag
include debug/Makefrag
include mem/Makefrag
include hw/Makefrag
include synch/Makefrag
include klib/Makefrag
include thread/Makefrag
include cpu/Makefrag
include proc/Makefrag
include console/Makefrag
include test/Makefrag
include ulib/Makefrag
include user/Makefrag

INCLUDE := -I./include
INCLUDE += -I./boot
INCLUDE += -I./kern
INCLUDE += -I./debug
INCLUDE += -I./mem
INCLUDE += -I./hw
INCLUDE += -I./synch
INCLUDE += -I./klib
INCLUDE += -I./thread
INCLUDE += -I./cpu
INCLUDE += -I./proc
INCLUDE += -I./console
INCLUDE += -I./test

.PRECIOUS:                 \
	$(OBJDIR)/boot/%.o     \
	$(OBJDIR)/kern/%.o     \
	$(OBJDIR)/debug/%.o    \
	$(OBJDIR)/mem/%.o      \
	$(OBJDIR)/hw/%.o       \
	$(OBJDIR)/synch/%.o    \
	$(OBJDIR)/klib/%.o     \
	$(OBJDIR)/thread/%.o   \
	$(OBJDIR)/cpu/%.o      \
	$(OBJDIR)/proc/%.o     \
	$(OBJDIR)/console/%.o  \
	$(OBJDIR)/test/%.o     \
	$(OBJDIR)/ulib/%.o     \
	$(OBJDIR)/user/%.o

CFLAGS += $(INCLUDE)

qemu: $(OBJDIR)/jinx
	@echo " <:> $@"
	@$(QEMU) $(QEMUOPTS)

nox: $(OBJDIR)/jinx
	@echo " <:> $@"
	@$(QEMU) -nographic $(QEMUOPTS)

qemu-gdb: $(OBJDIR)/jinx .gdbinit
	@echo " <:> $@"
	@$(QEMU) $(QEMUOPTS) -S

nox-gdb: $(OBJDIR)/jinx .gdbinit
	@echo " <:> $@"
	@$(QEMU) -nographic $(QEMUOPTS) -S

gdb:
	$(GDB)

.gdbinit: .gdbinit.tmpl
	@sed "s/localhost:1234/localhost:$(GDBPORT)/" < $^ > $@

$(OBJDIR)/jinx: $(OBJDIR)/kernel $(OBJDIR)/boot/boot
	@echo " <+> jinx"
	@dd if=/dev/zero of=$(OBJDIR)/jinx~ count=20000 2>/dev/null
	@dd if=$(OBJDIR)/boot/boot of=$(OBJDIR)/jinx~ conv=notrunc 2>/dev/null
	@dd if=$(OBJDIR)/kernel of=$(OBJDIR)/jinx~ seek=1 conv=notrunc 2>/dev/null
	@mv $(OBJDIR)/jinx~ $@

$(OBJDIR)/kernel: $(OBJS) $(BINS)
	@$(LD) -o $@ -T kern/kern.ld $(LFLAGS) $(OBJS) $(GCC_LIB) -b binary $(BINS)
	@$(DUMP) -S $@ > $@.asm

$(OBJDIR)/%.o: %.S
	@echo " <+> $@"
	@$(CC) $(CFLAGS) -O3 -c -o $@ $< > /dev/null

$(OBJDIR)/%.o: %.c
	@echo " <+> $@"
	@$(CC) $(CFLAGS) -Os -c -o $@ $<

backup: clean
	# git archive --format=tar HEAD | gzip > jinx.tar.gz
	tar czf ../JinxOS.tar.gz --exclude=obj --exclude=_files .

clean:
	rm -rf *~ *dSYM $(OBJDIR) .gdbinit
