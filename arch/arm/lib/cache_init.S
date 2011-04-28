#include <config.h>
#include <version.h>
.equ PL310_BASE     , 0xc4200000
/* void cache_init(unsigned * mmu_tab)*/
	.globl cache_init
cache_init:

	MCR p15,0,r0,c2,c0,0      		// setup TTB0

	LDR r1,=0x55555555				// all domains set to client
	MCR p15,0,r1,c3,c0,0      		// write Domain access control register

	MOV r3,#0
	MCR p15,0,r3,c7,c5,6 			// Invalidate BTAC
	MCR p15,0,r3,c7,c5,0			// Invalidate ICache
	DSB
	MCR p15,0,r3,c8,c7,0			// Invalidate TLBs
	DSB

	mov r11,lr
//	BL _invalidate_dcache		@ Invalidate DCache
	BL new_d_inval
	DSB
	
	// Enable MMU, Caches etc.
	MRC p15, 0, r0, c1, c0, 0 		// get control register
#ifndef CONFIG_ICACHE_OFF
	ORR r0, r0, #1 << 12      		// enable ICache
#endif	
	ORR r0, r0, #1 << 11      		// enable Branch Prediction
#ifndef CONFIG_DCACHE_OFF
	ORR r0, r0, #1 << 2       		// enable DCache
#endif	
	ORR r0, r0, #1   	       		// enable MMU
	MCR p15, 0, r0, c1, c0, 0 		// write control register
	DSB
	ISB
	
	

#ifndef CONFIG_L2_OFF
	bl l2x0_enable
#endif	

	mov	pc, r11

	
new_d_inval:
    MOV     r0,#0
    MCR     p15,2,r0,c0,c0,0  @ cache size selection register, select dcache
    MRC     p15,1,r0,c0,c0,0  @ cache size ID register
    MOV     r0,r0,ASR #13
    LDR     r3,=0xfff
    AND     r0,r0,r3        
    CMP     r0,#0x7f
    MOVEQ   r6,#0x1000
    BEQ     size_done
    CMP     r0,#0xff
    MOVEQ   r6,#0x2000
    MOVNE   r6,#0x4000
        
size_done:
    MOV     r2,#0
    MOV     r3,#0x40000000
    MOV     r4,#0x80000000
    MOV     r5,#0xc0000000
        
d_inv_loop:
    MCR     p15,0,r2,c7,c6,2  @ invalidate dcache by set / way
    MCR     p15,0,r3,c7,c6,2  @ invalidate dcache by set / way
    MCR     p15,0,r4,c7,c6,2  @ invalidate dcache by set / way
    MCR     p15,0,r5,c7,c6,2  @ invalidate dcache by set / way
    ADD     r2,r2,#0x20
    ADD     r3,r3,#0x20
    ADD     r4,r4,#0x20
    ADD     r5,r5,#0x20
    CMP     r2,r6
    BNE     d_inv_loop
    BX 	r14
