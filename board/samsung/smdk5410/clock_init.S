/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */


#include <config.h>
#include <asm/arch/cpu.h>

#include "smdk5410_val.h"



/*******************************************************************************
*	Functions for waiting
*******************************************************************************/
wait_div_state:
	add	r2, r2, #0x100
check_div_state:
	ldr	r1, [r0, r2]
	mov	r4, #0x10000
	orr	r4, r4, #0x6A0
	cmp	r2, r4
	lsreq	r1, r1, #4
	cmp	r1, r3
	bne	check_div_state
	mov	pc, lr

wait_mux_state:
	add	r2, r2, #0x200
check_mux_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_mux_state
	mov	pc, lr

wait_pll_lock:
	ldr	r1, [r0, r2]
	tst	r1, #(1<<29)
	beq	wait_pll_lock
	mov	pc, lr



/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */

	.globl system_clock_init
system_clock_init:
	push	{lr}

	ldr	r0, =EXYNOS5_CLOCK_BASE		@0x1001_0000

@ Set PLL locktime
	ldr	r1, =APLL_LOCK_VAL		@0x320
	ldr	r2, =APLL_LOCK_OFFSET		@0x0
	str	r1, [r0, r2]

	ldr	r1, =MPLL_LOCK_VAL		@0x258
	ldr	r2, =MPLL_LOCK_OFFSET		@0x4000
	str	r1, [r0, r2]

	ldr	r1, =BPLL_LOCK_VAL		@0x258
	ldr	r2, =BPLL_LOCK_OFFSET		@0x20010
	str	r1, [r0, r2]

	ldr r1, =CPLL_LOCK_VAL
	ldr r2, =CPLL_LOCK_OFFSET
	str r1, [r0, r2]

	ldr	r1, =KPLL_LOCK_VAL		@0x258
	ldr	r2, =KPLL_LOCK_OFFSET		@0x28000
	str	r1, [r0, r2]

@ Turn off PLL Mout
	ldr	r1, =0x00100000
	ldr	r2, =CLK_SRC_CPU_OFFSET		@0x00200
	str	r1, [r0, r2]

	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CORE1_OFFSET	@0x04204
	str	r1, [r0, r2]

	ldr	r1, =0x01100000
	ldr	r2, =CLK_SRC_TOP2_OFFSET	@0x10218
	str	r1, [r0, r2]

	ldr	r1, =0x00001000
	ldr	r2, =CLK_SRC_CDREX_OFFSET	@0x20200
	str	r1, [r0, r2]

	ldr	r1, =0x00008000
	ldr	r2, =CLK_SRC_KFC_OFFSET		@0x28200
	str	r1, [r0, r2]

	ldr	r3, =0x00210001
	bl	wait_mux_state

@ Set CMU_CPU, MUX & DIV
	ldr	r1, =0x00100000
	ldr	r2, =CLK_SRC_CPU_OFFSET		@0x00200
	str	r1, [r0, r2]

	ldr	r1, =0x1
	ldr	r2, =CLK_DIV_CPU1_OFFSET	@0x00504
	str	r1, [r0, r2]

	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_CPU0_VAL
	ldr	r2, =CLK_DIV_CPU0_OFFSET	@0x00500
	str	r1, [r0, r2]

	ldr	r1, =APLL_CON1_VAL		@0x0020F300
	ldr	r2, =APLL_CON1_OFFSET		@0x00104
	str	r1, [r0, r2]

	ldr	r1, =APLL_CON0_VAL
	ldr	r2, =APLL_CON0_OFFSET		@0x00100
	str	r1, [r0, r2]

	bl	wait_pll_lock

@ Set CMU_KFC, MUX & DIV
	ldr	r1, =0x00008000
	ldr	r2, =CLK_SRC_KFC_OFFSET		@0x28200
	str	r1, [r0, r2]

	ldr	r3, =0x00210001
	bl	wait_mux_state

	ldr	r1, =CLK_DIV_KFC0_VAL
	ldr	r2, =CLK_DIV_KFC0_OFFSET	@0x28500
	str	r1, [r0, r2]

	ldr	r1, =KPLL_CON1_VAL		@0x00200000
	ldr	r2, =KPLL_CON1_OFFSET		@0x28104
	str	r1, [r0, r2]

	ldr	r1, =KPLL_CON0_VAL
	ldr	r2, =KPLL_CON0_OFFSET		@0x28100
	str	r1, [r0, r2]

	bl	wait_pll_lock

@ Set MPLL
	ldr	r1, =MPLL_CON1_VAL		@0x0020F300
	ldr	r2, =MPLL_CON1_OFFSET		@0x04104
	str	r1, [r0, r2]

	ldr	r1, =MPLL_CON0_VAL		@0x810A0302
	ldr	r2, =MPLL_CON0_OFFSET		@0x04100
	str	r1, [r0, r2]

	bl	wait_pll_lock

	/* ByPass :: BYPASS = 1, bypass mode is enabled - FOUT=FIN */
	ldr r2, =MPLL_CON1_OFFSET
	ldr r1, [r0, r2]
	mov r3, #1
	mov r3, r3, lsl #22
	orr r1, r1, r3
	str r1, [r0, r2]

@ Set BPLL
	ldr	r1, =BPLL_CON1_VAL		@0x0020F300
	ldr	r2, =BPLL_CON1_OFFSET		@0x20114
	str	r1, [r0, r2]

	ldr	r1, =BPLL_CON0_VAL		@0x80C80301
	ldr	r2, =BPLL_CON0_OFFSET		@0x20110
	str	r1, [r0, r2]

	bl	wait_pll_lock

@ Set CPLL
	ldr r1, =CPLL_CON1_VAL
	ldr r2, =CPLL_CON1_OFFSET
	str r1, [r0, r2]

	ldr r1, =CPLL_CON0_VAL
	ldr r2, =CPLL_CON0_OFFSET
	str r1, [r0, r2]

	bl	wait_pll_lock

@ Set CMU_CPERI, MUX & DIV
	ldr	r1, =CLK_SRC_CORE0_VAL		@0x00090000
	ldr	r2, =CLK_SRC_CORE0_OFFSET	@0x04200
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_CORE1_VAL		@0x00000F00
	ldr	r2, =CLK_DIV_CORE1_OFFSET	@0x04504
	str	r1, [r0, r2]

	ldr	r3, =0x0
	bl	wait_div_state

@ Set CMU_CDREX, MUX & DIV
	ldr	r1, =CLK_SRC_CDREX_VAL		@0x00001000
	ldr	r2, =CLK_SRC_CDREX_OFFSET	@0x20200
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_CDREX0_VAL		@0x31010100
	ldr	r2, =CLK_DIV_CDREX0_OFFSET	@0x20500
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_CDREX1_VAL		@0x00000011
	ldr	r2, =CLK_DIV_CDREX1_OFFSET	@0x20504
	str	r1, [r0, r2]

	ldr	r2, =CLK_DIV_CDREX0_OFFSET
	ldr	r3, =0x0
	bl	wait_div_state

@ Set CMU_TOP, MUX & DIV
	ldr	r1, =CLK_SRC_TOP0_VAL		@0x00000000
	ldr	r2, =CLK_SRC_TOP0_OFFSET	@0x10210
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_TOP1_VAL		@0x0
	ldr	r2, =CLK_SRC_TOP1_OFFSET	@0x10214
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_TOP2_VAL		@0x01100000
	ldr	r2, =CLK_SRC_TOP2_OFFSET	@0x10218
	str	r1, [r0, r2]

	ldr	r3, =0x02211111
	bl	wait_mux_state

@ SCLK mux setting
	ldr	r1, =CLK_SRC_FSYS_VAL		@0x30000666
	ldr	r2, =CLK_SRC_FSYS_OFFSET	@0x10244
	str	r1, [r0, r2]

	mov	r1, #0x50000
1:	subs	r1, r1, #1
	bne	1b

	ldr	r1, =CLK_DIV_TOP0_VAL		@0x02112303
	ldr	r2, =CLK_DIV_TOP0_OFFSET	@0x10510
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_TOP1_VAL		@0x71700000
	ldr	r2, =CLK_DIV_TOP1_OFFSET	@0x10514
	str	r1, [r0, r2]

	/* related to SSS,
	 * If MPLL is 800Mhz, then this divider bit[2:0] should be '2'.
	 * If MPLL is 532Mhz, then this divider bit[2:0] should be '1'.
	 */
	ldr	r1, =CLK_DIV_G2D_VAL		@0x00000011
	ldr	r2, =CLK_DIV_G2D_OFFSET		@0x08500
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_FSYS0_VAL		@0x0
	ldr	r2, =CLK_DIV_FSYS0_OFFSET	@0x10548
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_FSYS1_VAL		@0x000A000A
	ldr	r2, =CLK_DIV_FSYS1_OFFSET	@0x1054C
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_FSYS2_VAL		@0x0000000A
	ldr	r2, =CLK_DIV_FSYS2_OFFSET	@0x10550
	str	r1, [r0, r2]
	str	r1, [r0, r2]

	ldr	r1, =CLKDIV4_RATIO_VAL		@0x00000303
	ldr	r2, =CLKDIV4_RATIO_OFFSET	@0x105A0
	str	r1, [r0, r2]

	ldr	r3, =0x0
	bl	wait_div_state

@ Turn on PLL Mout
	ldr	r1, =0x00100001
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x00000100
	ldr	r2, =CLK_SRC_CORE1_OFFSET
	str	r1, [r0, r2]

	ldr	r3, =0x00000200
	bl	wait_mux_state

	ldr	r1, =0x01100100
	ldr	r2, =CLK_SRC_TOP2_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x00008001
	ldr	r2, =CLK_SRC_KFC_OFFSET
	str	r1, [r0, r2]

	ldr	r3, =0x00210002
	bl	wait_mux_state

	/* ByPass :: BYPASS = 0, PLL operates normally */
	ldr r2, =MPLL_CON1_OFFSET
	ldr r1, [r0, r2]
	mov r3, #1
	mov r3, r3, lsl #22
	bic r1, r1, r3
	str r1, [r0, r2]

@ Setting CLKOUT
	/* CLKOUT_CMU_CPU	*/
	ldr	r1, =0x00010904			@ ARMCLK/10
	ldr	r2, =CLKOUT_CMU_CPU_OFFSET
	str	r1, [r0, r2]

	/* CLKOUT_CMU_CPERI	*/
@	ldr	r1, =0x00010900			@ FOUT_MPLL/10
@	ldr	r2, =CLKOUT_CMU_CORE_OFFSET
@	str	r1, [r0, r2]

	/* CLKOUT_CMU_TOP	*/
@	ldr	r1, =0x00010900			@ FOUT_EPLL/10
@	ldr	r1, =0x00010003			@ SCLK_HDMI27M/1
@	ldr	r1, =0x00010004			@ SCLK_DPTXPHY/1
@	ldr	r1, =0x00010005			@ SCLK_UHOSTPHY/1
@	ldr	r1, =0x00010006			@ SCLK_HDMIPHY/1
@	ldr	r2, =CLKOUT_CMU_TOP_OFFSET
@	str	r1, [r0, r2]

	/* CLKOUT_CMU_CDREX	*/
@	ldr	r1, =0x00010900			@ MCLK_CDREX/10
@	ldr	r1, =0x00010908			@ ACLK_CDREX/10
@	ldr	r1, =0x00010909			@ PCLK_CDREX/10
@	ldr	r2, =CLKOUT_CMU_CDREX_OFFSET
@	str	r1, [r0, r2]

	/* PMU_DEBUG		*/
@	ldr	r1, =0x0			@ CLKOUT_DEBUG
@	ldr	r1, =0x00000100			@ CLKOUT_DEBUG1
@	ldr	r1, =0x00000200			@ CLKOUT_CMU_CDREX
@	ldr	r1, =0x00000300			@ CLKOUT_CMU_CPERI
@	ldr	r1, =0x00000900			@ CLKOUT_CMU_TOP
	ldr	r1, =0x00000A00			@ CLKOUT_CMU_CPU
@	ldr	r1, =0x00000C00			@ CLKOUT_CMU_KFC
@	ldr	r1, =0x00001000			@ XXTI
@	ldr	r1, =0x00001100			@ XUSBXTI
@	ldr	r1, =0x00001200			@ TICCLK
@	ldr	r1, =0x00001300			@ RTCCLK

@	ldr	r2, =0x10040A00
@	str	r1, [r2]


	pop	{pc}

