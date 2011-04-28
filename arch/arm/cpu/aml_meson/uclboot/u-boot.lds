OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)
SECTIONS
{

	. = ALIGN(4);
	.text      :
	{
	 __text_start = .;
	  *arch/arm/cpu/aml_meson/uclboot/start.o	(.text) 	  
	  
	  *(.text)	  
	  . = ALIGN(4);
	  
	  *(.piggydata)	  
	}
	. = ALIGN(4);
	__text_end = .;

	__data_start = .;	
	.rodata : { *(.rodata) }	
	. = ALIGN(4);
	
	.data : { *(.data) }
	. = ALIGN(4);
	
	.got : { *(.got) }		
	__data_end = .;

	__bss_start = .;
	.bss : { *(.bss) }
	.stack ALIGN(4) (NOLOAD) :
	{
		__stack_start = .;
		. = __stack_start + 0x2000;
		__stack_end = .;
		. = __stack_end + 16 ;
	} 
	__bss_end = .;
	
	.heap ALIGN(4) (NOLOAD)  :
	{
		__heap_start = .;
		. = __heap_start + 0x1000;
		__heap_end = .;
	} 
	
	. = ALIGN(8192);
	end_kernel = .;

}
