#include <config.h>
#include <asm/system.h>
	
	/* form a first-level section entry */
.macro FL_SECTION_ENTRY base,prot
	.word (\base << 20) | (\prot ) 
.endm

.section .mmudata, "a"
	.align 14
/* the following alignment creates the mmu table at address 0x4000. */
	.globl mmu_table
mmu_table:
		.set __base, 0
		/*  ddr */
		.rept 0x400
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_SO_MEM)
		.set __base, __base + 1
		.endr
		
		/* SPI flash */
		.rept 0x410 -0x400
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		.endr
		
		/* N/A */
		.rept 0x490 -0x410
		.word 0x00000000
		.endr
		.set __base,0x490
		/** AHB SRAM **/
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		/* N/A */
		.rept 0x498 -0x491
		.word 0x00000000
		.endr
		.set __base,0x498
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		/* N/A */
		.rept 0x800 -0x499
		.word 0x00000000
		.endr
		.set __base,0x800
		/** DDR memory **/
		.rept 0xa00 - 0x800
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		.endr
		/** DDR without cache , debug **/
		.rept 0xc00 - 0xa00
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_SO_MEM )
		.set __base, __base + 1
		.endr
		/* N/A */
		.rept 0xc11 -0xc00
		.word 0x00000000
		.endr
		.set __base,0xc11
		.rept 0xc13 - 0xc11
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA | SEC_XN | SEC_SO_MEM )
		.set __base, __base + 1
		.endr
		
		/* N/A */
		.rept 0xc42 -0xc13
		.word 0x00000000
		.endr
		.set __base,0xc42
		/* Device registers */
		.rept 0xc44 - 0xc42
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA |  SEC_XN | SEC_DEVICE )
		.set __base, __base + 1
		.endr
		/* N/A */
		.rept 0xc80 -0xc44
		.word 0x00000000
		.endr
		.set __base,0xc80
		.rept 0xd01 - 0xc80
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA | SEC_XN | SECTION )
		.set __base, __base + 1
		.endr
		
		
		/* access is not allowed. */
		.rept 0xe00 - 0xd01
		.word 0x00000000
		.endr
		.set __base,0xe00
		
		/** DDR memory **/
		.rept 0x1000 - 0xe00
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_SO_MEM)
		.set __base, __base + 1
		.endr
