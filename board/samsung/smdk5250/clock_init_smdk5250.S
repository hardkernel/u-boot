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
	ldr	r2, =CLK_SRC_CPU_OFFSET
	ldr	r3, =0x00000001
	ldr	r1, [r0, r2]
	bic	r1, r1, r3
	str	r1, [r0, r2]
	ldr	r3, =0x00000001
	bl	wait_mux_state

	ldr	r2, =CLK_SRC_CORE1_OFFSET
	ldr	r3, =0x100
	ldr	r1, [r0, r2]
	bic	r1, r1, r3
	str	r1, [r0, r2]
	ldr	r3, =0x00000100
	bl	wait_mux_state

	ldr	r2, =CLK_SRC_TOP2_OFFSET
	ldr	r3, =0x10011100
	ldr	r1, [r0, r2]
	bic	r1, r1, r3
	str	r1, [r0, r2]
	ldr	r3, =0x10011100
	bl	wait_mux_state

	ldr	r2, =CLK_SRC_CDREX_OFFSET
	ldr	r3, =0x1
	ldr	r1, [r0, r2]
	bic	r1, r1, r3
	str	r1, [r0, r2]
	ldr	r3, =0x00000001
	bl	wait_mux_state

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

	ldr	r1, =GPLL_LOCK_VAL
	ldr	r2, =GPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =EPLL_LOCK_VAL
	ldr	r2, =EPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =VPLL_LOCK_VAL
	ldr	r2, =VPLL_LOCK_OFFSET
	str	r1, [r0, r2]

@ Set BPLL, MPLL Fixed Divider 2
	ldr	r1, =0x00
	ldr	r2, =PLL_DIV2_SEL_OFFSET
	str	r1, [r0, r2]

@ ARM_CLK
	ldr	r2, =CLK_SRC_CPU_OFFSET
	ldr	r3, =0x00100000
	str	r3, [r0, r2]
	ldr	r3, =0x00200000
	bl	wait_mux_state

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

@ Set MPLL @800Mhz
	ldr	r1, =MPLL_CON1_VAL
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =MPLL_CON0_VAL
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set BPLL @800Mhz
	ldr	r1, =BPLL_CON1_VAL
	ldr	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =BPLL_CON0_VAL
	ldr	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set CPLL @333Mhz
	ldr	r1, =CPLL_CON1_VAL
	ldr	r2, =CPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CPLL_CON0_VAL
	ldr	r2, =CPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set GPLL @533Mhz
	ldr	r1, =GPLL_CON1_VAL
	ldr	r2, =GPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =GPLL_CON0_VAL
	ldr	r2, =GPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

@ Set EPLL @96Mhz
	ldr     r1, =EPLL_CON2_VAL
	ldr     r2, =EPLL_CON2_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON1_VAL
	ldr     r2, =EPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON0_VAL
	ldr     r2, =EPLL_CON0_OFFSET
	str     r1, [r0, r2]
	bl	wait_pll_lock

@ Set VPLL @300Mhz
	ldr     r1, =VPLL_CON2_VAL
	ldr     r2, =VPLL_CON2_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON1_VAL
	ldr     r2, =VPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON0_VAL
	ldr     r2, =VPLL_CON0_OFFSET
	str     r1, [r0, r2]
	bl	wait_pll_lock

@ CMU_CORE MUX / DIV
	ldr	r2, =CLK_SRC_CORE0_OFFSET
	ldr	r3, =CLK_SRC_CORE0_VAL
	str	r3, [r0, r2]

	ldr	r1, =CLK_DIV_CORE0_VAL
	ldr	r2, =CLK_DIV_CORE0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_CORE1_VAL
	ldr	r2, =CLK_DIV_CORE1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_SYSRGT_VAL
	ldr	r2, =CLK_DIV_SYSRGT_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_ACP DIV
	ldr	r1, =CLK_DIV_ACP_VAL
	ldr	r2, =CLK_DIV_ACP_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_SYSLFT_VAL
	ldr	r2, =CLK_DIV_SYSLFT_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	ldr	r2, =CLK_DIV_STAT_SYSLFT_OFFSET
check_div_syslft_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_div_syslft_state

@ CMU_TOP SRC
	ldr	r2, =CLK_SRC_TOP0_OFFSET
	ldr	r3, =CLK_SRC_TOP0_VAL
	str	r3, [r0, r2]

	ldr	r2, =CLK_SRC_TOP1_OFFSET
	ldr	r3, =CLK_SRC_TOP1_VAL
	str	r3, [r0, r2]

	ldr	r2, =CLK_SRC_TOP2_OFFSET
	ldr	r3, =0x01100000
	str	r3, [r0, r2]

	ldr	r2, =CLK_SRC_TOP3_OFFSET
	ldr	r3, =CLK_SRC_TOP3_VAL
	ldr	r1, [r0, r2]
	str	r3, [r0, r2]

@ CMU_TOP MUX / DIV
	ldr	r1, =CLK_DIV_TOP0_VAL
	ldr	r2, =CLK_DIV_TOP0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr	r1, =CLK_DIV_TOP1_VAL
	ldr	r2, =CLK_DIV_TOP1_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_LEX SRC / DIV
	ldr	r2, =CLK_SRC_LEX_OFFSET
	ldr	r3, =CLK_SRC_LEX_VAL
	ldr	r1, [r0, r2]
	orr	r1, r1, r3
	str	r1, [r0, r2]
	ldr	r3, =0x1
	bl	wait_mux_state

	ldr	r1, =CLK_DIV_LEX_VAL
	ldr	r2, =CLK_DIV_LEX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_R0X DIV
	ldr	r1, =CLK_DIV_R0X_VAL
	ldr	r2, =CLK_DIV_R0X_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_R1X DIV
	ldr	r1, =CLK_DIV_R1X_VAL
	ldr	r2, =CLK_DIV_R1X_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ CMU_CDREX MUX / DIV
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	ldr	r3, =0x0
	str	r3, [r0, r2]

	ldr	r1, =0x71720071
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@CMU_CPU SRC
	ldr	r2, =CLK_SRC_CPU_OFFSET
	ldr	r3, =CLK_SRC_CPU_VAL
	ldr	r1, [r0, r2]
	orr	r1, r1, r3
	str	r1, [r0, r2]

	ldr	r2, =CLK_SRC_TOP2_OFFSET
	ldr	r3, =CLK_SRC_TOP2_VAL
	ldr	r1, [r0, r2]
	orr	r1, r1, r3
	str	r1, [r0, r2]

	ldr	r2, =CLK_SRC_CORE1_OFFSET
	ldr	r3, =CLK_SRC_CORE1_VAL
	ldr	r1, [r0, r2]
	orr	r1, r1, r3
	str	r1, [r0, r2]

	ldr	r1, =0x66666
	ldr	r2, =CLK_SRC_FSYS_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x0BB00000
	ldr	r2, =CLK_DIV_FSYS0_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

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
	orr	r4, r1, r3
	cmp	r1, r4
	bne	check_mux_state
	mov	pc, lr

wait_div_state:
	add	r2, r2, #0x100
check_div_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_div_state
	mov	pc, lr
