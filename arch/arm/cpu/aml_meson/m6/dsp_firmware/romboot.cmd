

MEMORY {
	RAM: ORIGIN = 0 LENGTH = 0x100000
}
SECTIONS {
	GROUP: {
		.start ALIGN(4) TYPE(TEXT):{
			boot.o(.text)
		}

		___t1 = .;
		.text : {
		}
		___t2 = .;
		* (TEXT): {}
		* (LIT):{}
		* (DATA):{}
		__bss_start = .;
		__dsp_bss = .;
		* (BSS):{}
		__dsp_bss_end = .; 
	} > RAM
}
