#include "config.h"
OUTPUT_FORMAT("elf32-littlearc", "elf32-littlearc", "elf32-littlearc")
OUTPUT_ARCH(arc)
ENTRY(_start)
SECTIONS
{
        . = RAM_START;

        . = ALIGN(4);
        .text   :
        {
                *boot_gcc.o  (.text)
                 *(.text)
        }
        ___t1 = .;
        .text : {
        }
        ___t2 = .;

        . = ALIGN(4);
        .rodata : { *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.rodata*))) }
        .data : { *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.data*))) }
     	 .sdata          :
			  {
  	 		 	__SDATA_BEGIN__ = .;
   				 *(.sdata .sdata.* .gnu.linkonce.s.*)
  			}

        . = ALIGN(4);
        __bss_start = .;
        __dsp_bss = .;
        .bss : { *(.bss) }
        . = ALIGN(4);
        __dsp_bss_end = .;
        _end = .;
}
ASSERT(_end <= _STACK_END-1024, " too big");

