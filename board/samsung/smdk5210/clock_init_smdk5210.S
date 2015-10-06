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

#include "smdk5210_val.h"

/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */
#define MEM_DLLl_ON

	.globl system_clock_init
system_clock_init:
	push	{lr}

	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000

@ CMU_CPU MUX / DIV
	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CORE1_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
1:	subs	r1, r1, #1
	bne	1b

@ Set PLL locktime
	ldr	r1, =APLL_LOCK_VAL
	ldr	r2, =APLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =MPLL_LOCK_VAL
	ldr	r2, =MPLL_LOCK_OFFSET
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

	ldr	r1, =BPLL_LOCK_VAL
	ldr	r2, =BPLL_LOCK_OFFSET
	str	r1, [r0, r2]

@ ARM_CLK
	ldr	r1, =CLK_DIV_CPU0_VAL		@0x01133710
	ldr	r2, =CLK_DIV_CPU0_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_CPU1_VAL		@0x30
	ldr	r2, =CLK_DIV_CPU1_OFFSET
	str	r1, [r0, r2]

@ Set APLL
	ldr	r1, =APLL_CON1_VAL
	ldr	r2, =APLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =APLL_CON0_VAL
	ldr	r2, =APLL_CON0_OFFSET
	str	r1, [r0, r2]

	/* check MPLL and if MPLL is not 400 Mhz skip MPLL resetting for C2C operation */
	ldr	r2, =MPLL_CON0_OFFSET
	ldr r1, [r0, r2]
	ldr r3, =0xA0640301
	cmp r1, r3
	bne skip_mpll

@ Set MPLL
	ldr	r1, =MPLL_CON1_VAL
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =MPLL_CON0_VAL
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
2:	subs	r1, r1, #1
	bne	2b

skip_mpll:

@ CMU_CDREX MUX / DIV
	ldr	r1, =0x0110
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x1100
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
3:	subs	r1, r1, #1
	bne	3b

@ Set BPLL
	ldr	r1, =BPLL_CON1_VAL	@CLK_400_200 0x00203800
	ldr	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =BPLL_CON0_VAL	@CLK_400_200 0x80C80300
	ldr	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x111111
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
4:	subs	r1, r1, #1
	bne	4b

@ Set CPLL
	ldr	r1, =CPLL_CON1_VAL	@0x00203800
	ldr	r2, =CPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CPLL_CON0_VAL	@0x80960400
	ldr	r2, =CPLL_CON0_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_TOP3_VAL	@0x01111111
	ldr	r2, =CLK_SRC_TOP3_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_SRC_TOP0_VAL	@0x10000000
	ldr	r2, =CLK_SRC_TOP0_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_SRC_TOP1_VAL	@0x00000000
	ldr	r2, =CLK_SRC_TOP1_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
5:	subs	r1, r1, #1
	bne	5b

	ldr	r1, =CLK_DIV_TOP0_VAL	@0x03223555
	ldr	r2, =CLK_DIV_TOP0_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_TOP1_VAL	@0x31110200
	ldr	r2, =CLK_DIV_TOP1_OFFSET
	str	r1, [r0, r2]

@ CMU_CORE MUX / DIV

	ldr	r1, =CLK_DIV_CORE0_VAL @0x120000
	ldr	r2, =CLK_DIV_CORE0_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
6:	subs	r1, r1, #1
	bne	6b

@ Set EPLL
	ldr     r1, =EPLL_CON2_VAL	@0x00000080
	ldr     r2, =EPLL_CON2_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON1_VAL	@0x0
	ldr     r2, =EPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON0_VAL	@0x80400203
	ldr     r2, =EPLL_CON0_OFFSET
	str     r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x30000
7:	subs	r1, r1, #1
	bne	7b

@ Set VPLL
	ldr     r1, =VPLL_CON2_VAL	@0x00000080
	ldr     r2, =VPLL_CON2_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON1_VAL	@0x0
	ldr     r2, =VPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON0_VAL	@0x80480203
	ldr     r2, =VPLL_CON0_OFFSET
	str     r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x30000
8:	subs	r1, r1, #1
	bne	8b

@ CMU_ACP DIV
	ldr	r1, =CLK_DIV_ACP_VAL
	ldr	r2, =CLK_DIV_ACP_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
9:	subs	r1, r1, #1
	bne	9b

@ CMU_LEX DIV
	ldr	r1, =CLK_DIV_LEX_VAL	@0x110
	ldr	r2, =CLK_DIV_LEX_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_SRC_LEX_VAL	@0x1
	ldr	r2, =CLK_SRC_LEX_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
10:	subs	r1, r1, #1
	bne	10b

@ CMU_RIX0 DIV
	ldr	r1, =CLK_DIV_R0X_VAL	@0x10
	ldr	r2, =CLK_DIV_R0X_OFFSET
	str	r1, [r0, r2]

@ CMU_RIX1 DIV
	ldr	r1, =CLK_DIV_R1X_VAL	@0x10
	ldr	r2, =CLK_DIV_R1X_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x30000
11:	subs	r1, r1, #1
	bne	11b

@ CMU_ISP DIV
	ldr	r1, =CLK_DIV_ISP0_VAL	@0x31
	ldr	r2, =CLK_DIV_ISP0_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_ISP1_VAL	@0x0
	ldr	r2, =CLK_DIV_ISP1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_ISP2_VAL	@0x0
	ldr	r2, =CLK_DIV_ISP2_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x30000
12:	subs	r1, r1, #1
	bne	12b

	ldr	r1, =CLK_SRC_CPU_VAL		@0x1
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_CORE1_VAL		@0x100
	ldr	r2, =CLK_SRC_CORE1_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x0111
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_TOP2_VAL		@0x01111100
	ldr	r2, =CLK_SRC_TOP2_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x30000
13:	subs	r1, r1, #1
	bne	13b

	/* check C2C_CTRL enable bit */
	ldr r3, =ELFIN_POWER_BASE
	ldr r1, [r3, #C2C_CTRL_OFFSET]
	and r1, r1, #1
	cmp r1, #0
	bne skip_set_DMC

@ ConControl
#ifdef MEM_DLLl_ON
	ldr	r0, =APB_DMC_0_BASE

	ldr	r1, =0x7F10100A
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	ldr	r1, =0x7F10100B
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
14:	subs	r1, r1, #1
	bne	14b

	ldr	r1, =0x0000008C
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
15:	subs	r1, r1, #1
	bne	15b

	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0x7F10100A
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	ldr	r1, =0xE0000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	ldr	r1, =0x7F10100B
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
16:	subs	r1, r1, #1
	bne	16b

	ldr	r1, =0x0000008C
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
17:	subs	r1, r1, #1
	bne	17b
#endif

	ldr	r0, =APB_DMC_0_BASE
	ldr	r1, =0x0FFF30EA
	ldr	r2, =DMC_CONCONTROL
	str	r1, [r0, r2]

	ldr	r0, =APB_DMC_1_BASE
	ldr	r1, =0x0FFF30EA
	ldr	r2, =DMC_CONCONTROL
	str	r1, [r0, r2]

	ldr	r0, =APB_DMC_0_BASE
	ldr	r1, =0x00202533
	ldr	r2, =DMC_MEMCONTROL
	str	r1, [r0, r2]

	ldr	r0, =APB_DMC_1_BASE
	ldr	r1, =0x00202533
	ldr	r2, =DMC_MEMCONTROL
	str	r1, [r0, r2]

skip_set_DMC:

	pop	{pc}
