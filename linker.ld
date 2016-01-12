OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS {
	. = 0xC0000000 + 0x100000;

	.text : AT(0x100000) {
		PROVIDE(_text = .);
		*(.text)
	}
	PROVIDE(_etext = .);

	.rodata : {
		PROVIDE(_rodata = .);
		*(.rodata .rodata.*)
	}
	PROVIDE(_erodata = .);

	. = ALIGN(0x1000);

	.stab : {
		PROVIDE(_sym_table = .);
		*(.stab);
		PROVIDE(_esym_table = .);
		BYTE(0)
	}

	.stabstr : {
		PROVIDE(_stab_strs = .);
		*(.stabstr);
		PROVIDE(_estab_strs = .);
		BYTE(0)
	}

	. = ALIGN(0x1000);

	.data : {
	    PROVIDE(_data = .);
		*(.data)
	}
	PROVIDE(_edata = .);

	. = ALIGN(0x1000);

	.bss : {
		PROVIDE(_bss = .);
		*(.bss)
	}
	PROVIDE(_ebss = .);

	. = ALIGN(0x1000);

	PROVIDE(_end = .);

	/DISCARD/ : {
		*(.note .comment .eh_frame .debug_*)
	}
}
