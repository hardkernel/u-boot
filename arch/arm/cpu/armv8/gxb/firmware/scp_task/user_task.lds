#include "config.h"

OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

SECTIONS
{
	. = CONFIG_RAM_BASE;
	HIGH_TASK_SHARE_MEMORY ALIGN(1024):
	{
		*(USER_HIGH_TASK_SHARE_MEMORY)
	}
	LOW_TASK_SHARE_MEMORY ALIGN(1024):
	{
		*(USER_LOW_TASK_SHARE_MEMORY)
	}
	HIGH_ENTRY_POINT ALIGN(512):
	{
		*(USER_HIGH_ENTRY_POINT)		
		*(.got .got.plt)
	}
	LOW_ENTRY_POINT ALIGN(512):
	{
		*(USER_LOW_ENTRY_POINT)		
		*(.got .got.plt)
	}
	
	. = ALIGN(4);
	.text		:
	{
		*(.text)
	}
	.data	:
	{
		*(.bss .data .rodata)
	}
	
	. = ALIGN(4);
	_bssstart = . ;
	.bss : { *(.bss) }
	. = ALIGN(4);
	_bssend = . ;	
	
}
ASSERT(_bssend <= 0x10000000 + 54*1024, "Data is too big. Please fine-tune start address and LENGTH!");