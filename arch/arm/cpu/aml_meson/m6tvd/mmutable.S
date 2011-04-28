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
		.rept 0x010
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_SO_MEM)
		.set __base, __base + 1
		.endr
				
		.set __base, 0x010
		/* N/A */
		.rept 0x800 -0x010
		.word 0x00000000
		.endr		
		
		.set __base,0x800
		/** DDR memory **/
#ifdef M6TV_DDR3_1GB		
		.rept 0xc00 - 0x800
#else
		.rept 0xa00 - 0x800
#endif
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		.endr

#ifndef M6TV_DDR3_1GB		
		/** DDR without cache , debug **/
		.rept 0xc00 - 0xa00
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_SO_MEM )
		.set __base, __base + 1
		.endr
#endif
		
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
			
		/* N/A */
		.rept 0xd90 -0xd01
		.word 0x00000000
		.endr
		
		/* SRAM flash */
		.set __base,0xd90
		.rept 0xd91 -0xd90
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		.endr
		
		/* N/A */
		.set __base,0xd91
		.rept 0xda0 -0xd91
		.word 0x00000000
		.endr
		
		.set __base,0xda0
		/* Device registers */		
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA |  SEC_XN | SEC_DEVICE )
		.set __base, __base + 1		
				
		/* N/A */
		.rept 0xe00 -0xda1
		.word 0x00000000
		.endr		
		
		.set __base,0xe00		
		/** DDR memory **/
		.rept 0x1000 - 0xe00
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_SO_MEM)
		.set __base, __base + 1
		.endr
