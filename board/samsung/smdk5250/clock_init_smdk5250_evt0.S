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

#ifdef CONFIG_CPU_EXYNOS5250_EVT1
#include "smdk5250_val_evt1.h"
#else
#include "smdk5250_val_evt0.h"
#endif

/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */

	.globl system_clock_init
system_clock_init:
	push	{lr}

	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000

@ CMU_CPU MUX / DIV
	ldr	r1, =0x00100000
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CORE1_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x01100000
	ldr	r2, =CLK_SRC_TOP2_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

/*
 *	Workaround Code for JPEG
 */
	ldr	r2, =CLK_DIV_GEN_OFFSET
	ldr	r1, [r0, r2]
	orr	r1, r1, #(0x7 << 4)
	str	r1, [r0, r2]

@ Set PLL locktime
	ldr	r1, =APLL_LOCK_VAL
	ldr	r2, =APLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =MPLL_LOCK_VAL
	ldr	r2, =MPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =BPLL_LOCK_VAL
	ldr	r2, =BPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CPLL_LOCK_VAL
	ldr	r2, =CPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =EPLL_LOCK_VAL
	ldr	r2, =EPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =VPLL_LOCK_VAL
	ldr	r2, =VPLL_LOCK_OFFSET
	str	r1, [r0, r2]

@ ARM_CLK
	ldr	r1, =CLK_DIV_CPU0_VAL		@0x01147720
	ldr	r2, =CLK_DIV_CPU0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_CPU1_VAL		@0x20
	ldr	r2, =CLK_DIV_CPU1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ Set APLL
	ldr	r1, =APLL_CON1_VAL
	ldr	r2, =APLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =APLL_CON0_VAL
	ldr	r2, =APLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set MPLL
	ldr	r1, =MPLL_CON1_VAL
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =MPLL_CON0_VAL
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set BPLL
	ldr	r1, =BPLL_CON1_VAL	@0x00203800
	ldr	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =BPLL_CON0_VAL	@0x82150C01
	ldr	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set CPLL
	ldr	r1, =CPLL_CON1_VAL	@0x00203800
	ldr	r2, =CPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CPLL_CON0_VAL	@0x80960400
	ldr	r2, =CPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set EPLL
	ldr     r1, =EPLL_CON2_VAL	@0x00000080
	ldr     r2, =EPLL_CON2_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON1_VAL	@0x0
	ldr     r2, =EPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON0_VAL	@0x80600303
	ldr     r2, =EPLL_CON0_OFFSET
	str     r1, [r0, r2]
	bl	wait_pll_lock

@ Set VPLL
	ldr     r1, =VPLL_CON2_VAL	@0x00000080
	ldr     r2, =VPLL_CON2_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON1_VAL	@0x0
	ldr     r2, =VPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON0_VAL	@0x80960302
	ldr     r2, =VPLL_CON0_OFFSET
	str     r1, [r0, r2]
	bl	wait_pll_lock

	ldr	r1, =CLK_SRC_CORE0_VAL		@0x00060000
	ldr	r2, =CLK_SRC_CORE0_OFFSET
	str	r1, [r0, r2]

@ CMU_CORE MUX / DIV
	ldr	r1, =CLK_DIV_CORE0_VAL		@0x00120000
	ldr	r2, =CLK_DIV_CORE0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_CORE1_VAL		@0x07070700
	ldr	r2, =CLK_DIV_CORE1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_CDREX MUX / DIV
	ldr	r1, =0x110
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011221
	bl	wait_mux_state

	ldr	r1, =0x71721171
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =0x4
	ldr	r2, =CLK_DIV_CDREX2_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_ACP DIV
	ldr	r1, =CLK_DIV_ACP_VAL	@0x12
	ldr	r2, =CLK_DIV_ACP_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_ISP DIV
	ldr	r1, =CLK_DIV_ISP0_VAL	@0x31
	ldr	r2, =CLK_DIV_ISP0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state
	ldr	r1, =CLK_DIV_ISP1_VAL	@0x00
	ldr	r2, =CLK_DIV_ISP1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state
	ldr	r1, =CLK_DIV_ISP2_VAL	@0x1
	ldr	r2, =CLK_DIV_ISP2_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_TOP SRC
	ldr	r1, =CLK_SRC_TOP0_VAL	@0x0
	ldr	r2, =CLK_SRC_TOP0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x11111111
	bl	wait_mux_state

	ldr	r1, =CLK_SRC_TOP1_VAL	@0x0
	ldr	r2, =CLK_SRC_TOP1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x01110000
	bl	wait_mux_state

	ldr	r1, =0x01100000
	ldr	r2, =CLK_SRC_TOP2_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x02211100
	bl	wait_mux_state

	ldr	r1, =CLK_SRC_TOP3_VAL	@0x01111550
	ldr	r2, =CLK_SRC_TOP3_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x22222222
@	bl	wait_mux_state

@ CMU_TOP MUX / DIV
	ldr	r1, =CLK_DIV_TOP0_VAL	@0x23023115
	ldr	r2, =CLK_DIV_TOP0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_TOP1_VAL	@0x31112700
	ldr	r2, =CLK_DIV_TOP1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_LEX SRC / DIV
	ldr	r1, =CLK_SRC_LEX_VAL	@0x0
	ldr	r2, =CLK_SRC_LEX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x1
	bl	wait_mux_state

	ldr	r1, =CLK_DIV_LEX_VAL	@0x10
	ldr	r2, =CLK_DIV_LEX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_R0X DIV
	ldr	r1, =CLK_DIV_R0X_VAL	@0x10
	ldr	r2, =CLK_DIV_R0X_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_R1X DIV
	ldr	r1, =CLK_DIV_R1X_VAL	@0x10
	ldr	r2, =CLK_DIV_R1X_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@CMU_CPU SRC
	ldr	r1, =CLK_SRC_CPU_VAL		@0x00100001
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00210002
	bl	wait_mux_state

	ldr	r1, =0x01111100
	ldr	r2, =CLK_SRC_TOP2_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x02222200
	bl	wait_mux_state

	ldr	r1, =CLK_SRC_CORE1_VAL		@0x100
	ldr	r2, =CLK_SRC_CORE1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0200
	bl	wait_mux_state

	ldr	r1, =0x66666
	ldr	r2, =CLK_SRC_FSYS_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x0FF00000
	ldr	r2, =CLK_DIV_FSYS0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_SRC_CDREX_VAL		@0x1
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011112
	bl	wait_mux_state

@disable CLKOUT_CMU
	ldr	r1, =0x0
	ldr	r2, =CLKOUT_CMU_CPU_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_CORE_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_ACP_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_TOP_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_LEX_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_R0X_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_R1X_OFFSET
	str	r1, [r0, r2]

	ldr	r2, =CLKOUT_CMU_CDREX_OFFSET
	str	r1, [r0, r2]

	ldr	r0, =ELFIN_POWER_BASE
@power down FSYS_ARM
	ldr	r1, =0x0
	ldr	r2, =FSYS_ARM_CONFIGURATION_OFFSET
	str	r1, [r0, r2]

@disable SATA_PHY_CONTROL
	ldr	r1, =0x0
	ldr	r2, =SATA_PHY_CONTROL_OFFSET
	str	r1, [r0, r2]

	pop	{pc}

wait_pll_lock:
	ldr	r1, [r0, r2]
	tst	r1, #(1<<29)
	beq	wait_pll_lock
	mov	pc, lr

wait_mux_state:
	add	r2, r2, #0x200
check_mux_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_mux_state
	mov	pc, lr

wait_div_state:
	add	r2, r2, #0x100
check_div_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_div_state
	mov	pc, lr
