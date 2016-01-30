OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS {
	. = 0x0800020;

	.text : {
		*(.text .stub .text.* .gnu.linkonce.t.*)
	}
	PROVIDE(_etext = .);

	.rodata : {
		*(.rodata .rodata.* .gnu.linkonce.r.*)
	}

	. = ALIGN(0x1000);

	.data : {
		*(.data)
	}

	PROVIDE(_edata = .);

	.bss : {
		*(.bss)
	}

	PROVIDE(_ebss = .);


	/* Place debugging symbols so that they can be found by
	 * the kernel debugger.
	 * Specifically, the four words at 0x200000 mark the beginning of
	 * the stabs, the end of the stabs, the beginning of the stabs
	 * string table, and the end of the stabs string table, respectively.
	 */

	.stab_info 0x200000 : {
		LONG(_stab);
		LONG(_estab);
		LONG(_stabstr);
		LONG(_estabstr);
	}

	.stab : {
		_stab = DEFINED(_stab) ? _stab : .;
		*(.stab);
		_estab = DEFINED(_estab) ? _estab : .;
		BYTE(0)		/* Force the linker to allocate space
				   for this section */
	}

	.stabstr : {
		_stabstr = DEFINED(_stabstr) ? _stabstr : .;
		*(.stabstr);
		_estabstr = DEFINED(_estabstr) ? _estabstr : .;
		BYTE(0)		/* Force the linker to allocate space
				   for this section */
	}

	/DISCARD/ : {
		*(.eh_frame .note.GNU-stack .comment)
	}
}
