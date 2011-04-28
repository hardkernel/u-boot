/*
 * armboot - Startup Code for OMAP3530/ARM Cortex CPU-core
 *
 * Copyright (c) 2004	Texas Instruments <r-woodruff2@ti.com>
 *
 * Copyright (c) 2001	Marius Gröger <mag@sysgo.de>
 * Copyright (c) 2002	Alex Züpke <azu@sysgo.de>
 * Copyright (c) 2002	Gary Jennejohn <garyj@denx.de>
 * Copyright (c) 2003	Richard Woodruff <r-woodruff2@ti.com>
 * Copyright (c) 2003	Kshitij <kshitij@ti.com>
 * Copyright (c) 2006-2008 Syed Mohammed Khasim <x0khasim@ti.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <version.h>

.globl _start 
_start: b	reset
	ldr	pc, _undefined_instruction
	ldr	pc, _software_interrupt
	ldr	pc, _prefetch_abort
	ldr	pc, _data_abort
	ldr	pc, _not_used
	ldr	pc, _irq
	ldr	pc, _fiq

_undefined_instruction: .word undefined_instruction
_software_interrupt:	.word software_interrupt
_prefetch_abort:	.word prefetch_abort
_data_abort:		.word data_abort
_not_used:		.word not_used
_irq:			.word irq
_fiq:			.word fiq
_pad:			.word 0x12345678 /* now 16*4=64 */
.global _end_vect
_end_vect:

	.balignl 16,0xdeadbeef
/*************************************************************************
 *
 * Startup Code (reset vector)
 *
 * do important init only if we don't start from memory!
 * setup Memory and board specific bits prior to relocation.
 * relocate armboot to ram
 * setup stack
 *
 *************************************************************************/

_TEXT_BASE:
	.word __text_start

.globl _armboot_start
_armboot_start:
	.word _start

/*
 * These are defined in the board-specific linker script.
 */
.globl _bss_start
_bss_start:
	.word __bss_start

.globl _bss_end
_bss_end:
	.word __bss_end

#ifdef CONFIG_USE_IRQ
/* IRQ stack memory (calculated at run-time) */
.globl IRQ_STACK_START
IRQ_STACK_START:
	.word	0x0badc0de

/* IRQ stack memory (calculated at run-time) */
.globl FIQ_STACK_START
FIQ_STACK_START:
	.word 0x0badc0de
#endif

/*
 * the actual reset code
 */

reset:
	/*
	 * set the cpu to SVC32 mode
	 */
	mrs	r0, cpsr
	bic	r0, r0, #0x1f
	orr	r0, r0, #0xd3
	msr	cpsr,r0

	/* the mask ROM code should have PLL and others stable */
#ifndef CONFIG_SKIP_LOWLEVEL_INIT
	//bl	cpu_init_crit
#endif

#ifndef CONFIG_SKIP_RELOCATE_UBOOT
relocate:				@ relocate U-Boot to RAM
	adr	r0, _start		@ r0 <- current position of code
	ldr	r1, _TEXT_BASE		@ test if we run from flash or RAM
	cmp	r0, r1			@ don't reloc during debug
	//beq	stack_setup
	beq init_cpu

	ldr	r2, _armboot_start
	ldr	r3, _bss_start
	sub	r2, r3, r2		@ r2 <- size of armboot
	add	r2, r0, r2		@ r2 <- source end address

copy_loop:				@ copy 32 bytes at a time
	ldmia	r0!, {r3 - r10}		@ copy from source address [r0]
	stmia	r1!, {r3 - r10}		@ copy to   target address [r1]
	cmp	r0, r2			@ until source end addreee [r2]
	ble	copy_loop
#endif	/* CONFIG_SKIP_RELOCATE_UBOOT */

    @enable i-cache,d-cache,mmu
init_cpu:
#ifndef CONFIG_SKIP_LOWLEVEL_INIT
    bl	cpu_init_crit
#endif
    
	/* Set up the stack */
stack_setup:
	ldr	r0, _TEXT_BASE		@ upper 128 KiB: relocated uboot
	ldr	r1, =CONFIG_SYS_MALLOC_LEN @ malloc area
	sub	r0, r0, r1
	sub	r0, r0, #CONFIG_SYS_GBL_DATA_SIZE @ bdinfo
#ifdef CONFIG_USE_IRQ
	sub	r0, r0, #(CONFIG_STACKSIZE_IRQ + CONFIG_STACKSIZE_FIQ)
#endif
/*	sub	sp, r0, #12		@ leave 3 words for abort-stack
	and	sp, sp, #~7		@ 8 byte alinged for (ldr/str)d
*/
	/* Clear BSS (if any). Is below tx (watch load addr - need space) */
clear_bss:
	ldr	r0, _bss_start		@ find start of bss segment
	ldr	r1, _bss_end		@ stop here
	mov	r2, #0x00000000		@ clear value
clbss_l:
	str	r2, [r0]		@ clear BSS location
	cmp	r0, r1			@ are we at the end yet
	add	r0, r0, #4		@ increment clear index pointer
	bne	clbss_l			@ keep clearing till at end

	ldr	pc, _start_armboot	@ jump to C code

_start_armboot: .word start_arcboot_ucl


/*************************************************************************
 *
 * CPU_init_critical registers
 *
 * setup important registers
 * setup memory timing
 *
 *************************************************************************/
__mmu_table:
	.word mmu_table
cpu_init_crit:
	/*
	 * Invalidate L1 I/D
	 */
	mov	r0, #0			@ set up for MCR
	mcr	p15, 0, r0, c8, c7, 0	@ invalidate TLBs
	mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache

	/*
	 * disable MMU stuff and caches
	 */
	mrc	p15, 0, r0, c1, c0, 0
	bic	r0, r0, #0x00002000	@ clear bits 13 (--V-)
	bic	r0, r0, #0x00000007	@ clear bits 2:0 (-CAM)
	orr	r0, r0, #0x00000002	@ set bit 1 (--A-) Align
	orr	r0, r0, #0x00000800	@ set bit 12 (Z---) BTB
	mcr	p15, 0, r0, c1, c0, 0

	/*
	 * Jump to board specific initialization...
	 * The Mask ROM will have already initialized
	 * basic memory. Go here to bump up clock rate and handle
	 * wake up conditions.
	 */
	/*
	 * mov	ip, lr			@ persevere link reg across call
	 * ldr r0,__mmu_table
	 * bl	cache_init		@ go setup pll,mux,memory
	 * mov	lr, ip			@ restore link
	 */
#ifdef UCL_DEC_EN_IDCACHE_FINE_TUNE
	ldr r0,__mmu_table
	mcr p15,0,r0,c2,c0,0   @ setup TTB0

	ldr r1,=0x55555555	   @ all domains set to client
	mcr p15,0,r1,c3,c0,0   @ write Domain access control register

	mov r3,#0
	mcr p15,0,r3,c7,c5,6   @ Invalidate BTAC
	mcr p15,0,r3,c7,c5,0   @ Invalidate ICache
	dsb
	mcr p15,0,r3,c8,c7,0   @ Invalidate TLBs
	dsb
#endif//UCL_DEC_EN_IDCACHE_FINE_TUNE
	mov	ip, lr			@ persevere link reg across call
	bl	new_d_inval		@ go setup pll,mux,memory
	mov	lr, ip			@ restore link

	mrc	p15, 0, r0, c1, c0, 0
#ifdef UCL_DEC_EN_IDCACHE
    orr	r0, r0, #(1<<12)    @ i-cache enable
    orr	r0, r0, #(1<<2)     @ d-cache enable
	orr r0, r0, #(1<<11)    @ enable Branch Prediction
#ifdef UCL_DEC_EN_IDCACHE_FINE_TUNE
	orr r0, r0, #1   	    @ enable MMU
#endif //UCL_DEC_EN_IDCACHE_FINE_TUNE
#endif
	mcr	p15, 0, r0, c1, c0, 0

	mov	pc, lr			@ back to my caller


new_d_inval:
	MOV 	r0,#0
	MCR 	p15,2,r0,c0,c0,0  @ cache size selection register, select L1 dcache
	MRC 	p15,1,r0,c0,c0,0  @ cache size ID register
	MOV 	r0,r0,ASR #13
	LDR 	r3,=0xfff
	AND 	r0,r0,r3		
	CMP 	r0,#0x7f
	MOVEQ	r6,#0x1000
	BEQ 	size_done
	CMP 	r0,#0xff
	MOVEQ	r6,#0x2000
	MOVNE	r6,#0x4000
		
size_done:
	MOV 	r2,#0
	MOV 	r3,#0x40000000
	MOV 	r4,#0x80000000
	MOV 	r5,#0xc0000000
		
d_inv_loop:
	MCR 	p15,0,r2,c7,c6,2  @ invalidate dcache by set / way
	MCR 	p15,0,r3,c7,c6,2  @ invalidate dcache by set / way
	MCR 	p15,0,r4,c7,c6,2  @ invalidate dcache by set / way
	MCR 	p15,0,r5,c7,c6,2  @ invalidate dcache by set / way
	ADD 	r2,r2,#0x20
	ADD 	r3,r3,#0x20
	ADD 	r4,r4,#0x20
	ADD 	r5,r5,#0x20
	CMP 	r2,r6
	BNE 	d_inv_loop
	BX	r14


    .global   clean_invalidable_cache
@void clean_invalidable_cache(void)
clean_invalidable_cache:
    push    {r4,r5,r6,lr}
#ifdef UCL_DEC_EN_IDCACHE
    //wfi
    mov	r0, #0			@ set up for MCR
/*    mcr	p15, 0, r0, c7, c6, 0	@ invalidate dcache */
    mcr p15, 0, r0, c7, c5, 6   @ invaliddate entire branch preditor 
    mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache
    DSB
    ISB
    NOP

    @ read d-cache size
	MOV 	r0,#0
	MCR 	p15,2,r0,c0,c0,0  @ cache size selection register, select L1 dcache
	MRC 	p15,1,r0,c0,c0,0  @ cache size ID register
	MOV 	r0,r0,ASR #13
	LDR 	r3,=0xfff
	AND 	r0,r0,r3		
	CMP 	r0,#0x7f
	MOVEQ	r6,#0x1000
	BEQ 	size_done_ucl
	CMP 	r0,#0xff
	MOVEQ	r6,#0x2000
	MOVNE	r6,#0x4000

    @//MOV     r6,#0x4000
    @MOV     r6,#0x2000
size_done_ucl:
    MOV     r2,#0
    MOV     r3,#0x40000000
    MOV     r4,#0x80000000
    MOV     r5,#0xc0000000
clean_inv:
    mcr	p15, 0, r2, c7, c14, 2	@ clean and invalidate dcache
    mcr	p15, 0, r3, c7, c14, 2	@ clean and invalidate dcache
    mcr	p15, 0, r4, c7, c14, 2	@ clean and invalidate dcache
    mcr	p15, 0, r5, c7, c14, 2	@ clean and invalidate dcache
    add r2,  r2, #0x20
    add r3,  r3, #0x20
    add r4,  r4, #0x20
    add r5,  r5, #0x20
    cmp r2, r6
    bne clean_inv
    DSB
    ISB
    
	mov r0,#0
__NOP:    
	nop
	nop
	nop
	add r0, r0, #1
	cmp r0, #100
	bne __NOP    
    
    mrc	p15, 0, r0, c1, c0, 0
    bic	r0, r0, #(1<<12)    @ i-cache disable 
    bic	r0, r0, #(1<<2)     @ d-cache disable
    bic r0, r0, #(1<<11)    @ disable branch prediction
#ifdef UCL_DEC_EN_IDCACHE_FINE_TUNE
	bic r0, r0, #1   	    @ disable MMU
#endif //UCL_DEC_EN_IDCACHE_FINE_TUNE
    mcr	p15, 0, r0, c1, c0, 0

#endif
    pop {r4, r5,r6, pc}

/*
 *************************************************************************
 *
 * Interrupt handling
 *
 *************************************************************************
 */
@
@ IRQ stack frame.
@
#define S_FRAME_SIZE	72

#define S_OLD_R0	68
#define S_PSR		64
#define S_PC		60
#define S_LR		56
#define S_SP		52

#define S_IP		48
#define S_FP		44
#define S_R10		40
#define S_R9		36
#define S_R8		32
#define S_R7		28
#define S_R6		24
#define S_R5		20
#define S_R4		16
#define S_R3		12
#define S_R2		8
#define S_R1		4
#define S_R0		0

#define MODE_SVC 0x13
#define I_BIT	 0x80

/*
 * use bad_save_user_regs for abort/prefetch/undef/swi ...
 * use irq_save_user_regs / irq_restore_user_regs for IRQ/FIQ handling
 */

	.macro	bad_save_user_regs
	sub	sp, sp, #S_FRAME_SIZE		@ carve out a frame on current
						@ user stack
	stmia	sp, {r0 - r12}			@ Save user registers (now in
						@ svc mode) r0-r12

	ldr	r2, _armboot_start
	ldr	r1, =CONFIG_SYS_MALLOC_LEN @ malloc area
	sub	r2, r2, r1
	sub	r2, r2, #(CONFIG_SYS_GBL_DATA_SIZE + 8)	@ set base 2 words into abort
						@ stack
	ldmia	r2, {r2 - r3}			@ get values for "aborted" pc
						@ and cpsr (into parm regs)
	add	r0, sp, #S_FRAME_SIZE		@ grab pointer to old stack

	add	r5, sp, #S_SP
	mov	r1, lr
	stmia	r5, {r0 - r3}			@ save sp_SVC, lr_SVC, pc, cpsr
	mov	r0, sp				@ save current stack into r0
						@ (param register)
	.endm

	.macro	irq_save_user_regs
	sub	sp, sp, #S_FRAME_SIZE
	stmia	sp, {r0 - r12}			@ Calling r0-r12
	add	r8, sp, #S_PC			@ !! R8 NEEDS to be saved !!
						@ a reserved stack spot would
						@ be good.
	stmdb	r8, {sp, lr}^			@ Calling SP, LR
	str	lr, [r8, #0]			@ Save calling PC
	mrs	r6, spsr
	str	r6, [r8, #4]			@ Save CPSR
	str	r0, [r8, #8]			@ Save OLD_R0
	mov	r0, sp
	.endm

	.macro	irq_restore_user_regs
	ldmia	sp, {r0 - lr}^			@ Calling r0 - lr
	mov	r0, r0
	ldr	lr, [sp, #S_PC]			@ Get PC
	add	sp, sp, #S_FRAME_SIZE
	subs	pc, lr, #4			@ return & move spsr_svc into
						@ cpsr
	.endm

	.macro get_bad_stack
	ldr	r13, _armboot_start		@ setup our mode stack (enter
						@ in banked mode)
	ldr	r1, =CONFIG_SYS_MALLOC_LEN @ malloc area
	sub	r13, r13, r1	@ move past malloc pool
	sub	r13, r13, #(CONFIG_SYS_GBL_DATA_SIZE + 8) @ move to reserved a couple
						@ spots for abort stack

	str	lr, [r13]			@ save caller lr in position 0
						@ of saved stack
	mrs	lr, spsr			@ get the spsr
	str	lr, [r13, #4]			@ save spsr in position 1 of
						@ saved stack

	mov	r13, #MODE_SVC			@ prepare SVC-Mode
	@ msr	spsr_c, r13
	msr	spsr, r13			@ switch modes, make sure
						@ moves will execute
	mov	lr, pc				@ capture return pc
	movs	pc, lr				@ jump to next instruction &
						@ switch modes.
	.endm

	.macro get_bad_stack_swi
	sub	r13, r13, #4			@ space on current stack for
						@ scratch reg.
	str	r0, [r13]			@ save R0's value.
	ldr	r0, _armboot_start		@ get data regions start
	ldr	r1, =CONFIG_SYS_MALLOC_LEN @ malloc area
	sub	r0, r0, r1	@ move past malloc pool
	sub	r0, r0, #(CONFIG_SYS_GBL_DATA_SIZE + 8)	@ move past gbl and a couple
						@ spots for abort stack
	str	lr, [r0]			@ save caller lr in position 0
						@ of saved stack
	mrs	r0, spsr			@ get the spsr
	str	lr, [r0, #4]			@ save spsr in position 1 of
						@ saved stack
	ldr	r0, [r13]			@ restore r0
	add	r13, r13, #4			@ pop stack entry
	.endm

	.macro get_irq_stack			@ setup IRQ stack
	ldr	sp, IRQ_STACK_START
	.endm

	.macro get_fiq_stack			@ setup FIQ stack
	ldr	sp, FIQ_STACK_START
	.endm

/*
 * exception handlers
 */
	.align	5
undefined_instruction:
	get_bad_stack
	bad_save_user_regs
	bl	do_undefined_instruction

	.align	5
software_interrupt:
	get_bad_stack_swi
	bad_save_user_regs
	bl	do_software_interrupt

	.align	5
prefetch_abort:
	get_bad_stack
	bad_save_user_regs
	bl	do_prefetch_abort

	.align	5
data_abort:
	get_bad_stack
	bad_save_user_regs
	bl	do_data_abort

	.align	5
not_used:
	get_bad_stack
	bad_save_user_regs
	bl	do_not_used

#ifdef CONFIG_USE_IRQ

	.align	5
irq:
	get_irq_stack
	irq_save_user_regs
	bl	do_irq
	irq_restore_user_regs

	.align	5
fiq:
	get_fiq_stack
	/* someone ought to write a more effective fiq_save_user_regs */
	irq_save_user_regs
	bl	do_fiq
	irq_restore_user_regs

#else

	.align	5
irq:
	get_bad_stack
	bad_save_user_regs
	bl	do_irq

	.align	5
fiq:
	get_bad_stack
	bad_save_user_regs
	bl	do_fiq

#endif

