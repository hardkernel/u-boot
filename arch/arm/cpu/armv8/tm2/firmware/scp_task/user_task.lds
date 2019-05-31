#include "config.h"

OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)
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
		*(.data .rodata*)
	}

	. = ALIGN(4);
	_bssstart = . ;


	.bss            :
	{
		*(.sbss*)
		*(.gnu.linkonce.sb.*)
		*(.bss .bss.*)
		*(.gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(4);
	}

	_bssend = . ;

	. = CONFIG_RAM_END - 3*CONFIG_TASK_STACK_SIZE - 128;
	.bss_stack : { *(.bss_stack.usr_stack) }

}
ASSERT(_bssend <= (CONFIG_RAM_END - 3*CONFIG_TASK_STACK_SIZE - 128), "Data is too big. Please fine-tune start address and LENGTH!");
