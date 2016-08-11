#include "config.h"

OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(task_entry)

SECTIONS
{
	. = CONFIG_RAM_BASE;
	.text		:
	{
		*task_entry.o (.text)
		*(.text .text*)
		*(.ARM.*)
	}
	.common :
	{
		*(.commo*)
	}
	.data	:
	{
		*(.bss .data .rodata*)
	}

	. = ALIGN(4);
	_bssstart = . ;
	.bss : { *(.bss) }
	. = ALIGN(4);
	_bssend = . ;

}
ASSERT(_bssend <= CONFIG_RAM_END, "Data is too big. Please fine-tune start address and LENGTH!");
