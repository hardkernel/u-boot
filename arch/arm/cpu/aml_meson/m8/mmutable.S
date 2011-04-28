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
		/**  DDR memory **/
		.rept CONFIG_MMU_DDR_SIZE
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		.endr

		
		/** N/A **/
		.rept 0xc00 - CONFIG_MMU_DDR_SIZE
		.word 0x00000000		
		.endr

	
        /** APB3 CBUS **/
		.set __base,0xc00
		.rept 0xc13 - 0xc00
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA | SEC_XN | SEC_SO_MEM )
		.set __base, __base + 1
		.endr
	
		
		/** N/A **/
		.rept 0xc42 -0xc13
		.word 0x00000000
		.endr
		
		
		/** L2 A9 REGs **/
		.set __base,0xc42
		/* Device registers */
		.rept 0xc44 - 0xc42
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA |  SEC_XN | SEC_DEVICE )
		.set __base, __base + 1
		.endr
		
		
		/** N/A **/
		.rept 0xc80 -0xc44
		.word 0x00000000
		.endr
		
		
		/** APB bus **/
		.set __base,0xc80
		.rept 0xd02 - 0xc80
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA | SEC_XN | SECTION )
		.set __base, __base + 1
		.endr
			
			
		/** N/A **/
		.rept 0xd90 -0xd02
		.word 0x00000000
		.endr
		
		
		/** AHB SRAM **/
		.set __base,0xd90
		.rept 0xd91 -0xd90
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_RW | SEC_WB)
		.set __base, __base + 1
		.endr
		
		
		/** N/A **/		
		.rept 0xda0 -0xd91
		.word 0x00000000
		.endr
		
		
		/** sMMC **/
		.set __base,0xda0
		/* Device registers */		
		FL_SECTION_ENTRY __base,(SEC_PROT_RW_NA |  SEC_XN | SEC_DEVICE )
		.set __base, __base + 1		
				
				
		/** N/A **/
		.rept 0x1000 -0xda1
		.word 0x00000000
		.endr		
		