
#include <config.h>
MEMORY {
	RAM: ORIGIN = ROMBOOT_START LENGTH = RAM_SIZE
}
SECTIONS {
	GROUP: {
		.start ALIGN(4) TYPE(TEXT):{
			start_arc.o(.text)
		}
		.main ALIGN(4) TYPE(TEXT):{
			test.o(.text)
			i2c.o(.text)
		}
		* (TEXT): {}
		* (LIT):{}
		* (DATA):{}
		__bss_start = .;
		* (BSS):{}
	} > RAM
}
