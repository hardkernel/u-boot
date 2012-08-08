/*
 * Lowlevel setup for ODROIDX board based on EXYNOS4412
 *
 * Copyright (C) 2013 Hardkernel Co.,LTD. 
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <version.h>
#include <asm/arch/cpu.h>
#include "odroidx_setup.h"
#define MEM_DLLl_ON
/*
 * Register usages:
 *
 * r5 has zero always
 * r7 has GPIO part1 base 0x11400000
 * r6 has GPIO part2 base 0x11000000
 */

_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

	.globl lowlevel_init
lowlevel_init:

	/* use iRAM stack in bl2 */
	ldr	sp, =CONFIG_IRAM_STACK
	stmdb	r13!, {ip,lr}

	/* r5 has always zero */
	mov	r5, #0
	ldr	r7, =EXYNOS4_GPIO_PART1_BASE
	ldr	r6, =EXYNOS4_GPIO_PART2_BASE

	/* check reset status */
	ldr	r0, =(EXYNOS4_POWER_BASE + INFORM1_OFFSET)
	ldr	r1, [r0]

	/* AFTR wakeup reset */
	ldr	r2, =S5P_CHECK_DIDLE
	cmp	r1, r2
	beq	exit_wakeup

	/* LPA wakeup reset */
	ldr	r2, =S5P_CHECK_LPA
	cmp	r1, r2
	beq	exit_wakeup

	/* Sleep wakeup reset */
	ldr	r2, =S5P_CHECK_SLEEP
	cmp	r1, r2
	beq	wakeup_reset

	/*
	 * If U-boot is already running in RAM, no need to relocate U-Boot.
	 * Memory controller must be configured before relocating U-Boot
	 * in ram.
	 */
	ldr	r0, =0x0ffffff		/* r0 <- Mask Bits*/
	bic	r1, pc, r0		/* pc <- current addr of code */
					/* r1 <- unmasked bits of pc */
	ldr	r2, _TEXT_BASE		/* r2 <- original base addr in ram */
	bic	r2, r2, r0		/* r2 <- unmasked bits of r2*/
	cmp	r1, r2			/* compare r1, r2 */
	beq	1f			/* r0 == r1 then skip sdram init */

	/* Memory initialize */
	bl mem_ctrl_asm_init

	/* init system clock */
	bl	system_clock_init

1:
	/* for UART */
	bl uart_asm_init
	bl tzpc_init
    ldmia   r13!, {ip,pc}

wakeup_reset:
	bl mem_ctrl_asm_init
	bl system_clock_init
	bl tzpc_init

exit_wakeup:
	/* Load return address and jump to kernel */
	ldr	r0, =(EXYNOS4_POWER_BASE + INFORM0_OFFSET)

	/* r1 = physical address of exynos4_cpu_resume function */
	ldr	r1, [r0]

	/* Jump to kernel*/
	mov	pc, r1
	nop
	nop

/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */
system_clock_init:
	push	{lr}
	ldr	r0, =EXYNOS4_CLOCK_BASE

	/* APLL(0), MPLL(0), CORE(0), HPM(0) */
	ldr	r1, =CLK_SRC_CPU_VAL
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
2:	subs	r1, r1, #1
	bne	2b

	/* DMC */
	ldr	r1, =CLK_DIV_DMC0_VAL
	ldr	r2, =CLK_DIV_DMC0_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_DIV_DMC1_VAL
	ldr	r2, =CLK_DIV_DMC1_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_TOP0_VAL
	ldr	r2, =CLK_SRC_TOP0_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =CLK_SRC_TOP1_VAL
	ldr	r2, =CLK_SRC_TOP1_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
3:	subs	r1, r1, #1
	bne	3b

	ldr	r1, =CLK_DIV_TOP_VAL
	ldr	r2, =CLK_DIV_TOP_OFFSET
	str	r1, [r0, r2]

	/*_SRC_LEFTBUS */
	ldr	r1, =CLK_SRC_LEFTBUS_VAL
	ldr	r2, =CLK_SRC_LEFTBUS_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
4:	subs	r1, r1, #1
	bne	4b

	/*_DIV_LEFTBUS */
	ldr	r1, =CLK_DIV_LEFTBUS_VAL
	ldr	r2, =CLK_DIV_LEFTBUS_OFFSET
	str	r1, [r0, r2]

	/*_SRC_RIGHTBUS */
	ldr	r1, =CLK_SRC_RIGHTBUS_VAL
	ldr	r2, =CLK_SRC_RIGHTBUS_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
5:	subs	r1, r1, #1
	bne	5b

	/*CLK_DIV_RIGHTBUS */
	ldr	r1, =CLK_DIV_RIGHTBUS_VAL
	ldr	r2, =CLK_DIV_RIGHTBUS_OFFSET
	str	r1, [r0, r2]

	/* UART[0:4] */
	ldr	r1, =CLK_SRC_PERIL0_VAL
	ldr	r2, =CLK_SRC_PERIL0_OFFSET
	str	r1, [r0, r2]

	/* FIMD0 */
	ldr	r1, =CLK_SRC_LCD0_VAL
	ldr	r2, =CLK_SRC_LCD0_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
6:	subs	r1, r1, #1
	bne	6b

	/* MMC[0:1] */
	ldr	r1, =CLK_DIV_FSYS1_VAL		/* 800(MPLL) / (15 + 1) */
	ldr	r2, =CLK_DIV_FSYS1_OFFSET
	str	r1, [r0, r2]

	/* MMC[2:3] */
	ldr	r1, =CLK_DIV_FSYS2_VAL		/* 800(MPLL) / (15 + 1) */
	ldr	r2, =CLK_DIV_FSYS2_OFFSET
	str	r1, [r0, r2]

	/* MMC4 */
	ldr	r1, =CLK_DIV_FSYS3_VAL		/* 800(MPLL) / (15 + 1) */
	ldr	r2, =CLK_DIV_FSYS3_OFFSET
	str	r1, [r0, r2]

	/* _DIV_PERIL0: UART Clock Divisors */
	ldr	r1, =CLK_DIV_PERIL0_VAL
	ldr	r2, =CLK_DIV_PERIL0_OFFSET
	str	r1, [r0, r2]

	/* Set PLL locktime */
	ldr	r1, =APLL_LOCK_VAL
	ldr	r2, =APLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =MPLL_LOCK_VAL
	ldr	r2, =MPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =EPLL_LOCK_VAL
	ldr	r2, =EPLL_LOCK_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =VPLL_LOCK_VAL
	ldr	r2, =VPLL_LOCK_OFFSET
	str	r1, [r0, r2]

    ldr r1, =CLK_DIV_CPU0_VAL
	ldr	r2, =CLK_DIV_CPU0_OFFSET
	str	r1, [r0, r2]
    ldr r1, =CLK_DIV_CPU1_VAL
	ldr	r2, =CLK_DIV_CPU1_OFFSET
	str	r1, [r0, r2]

 	/* APLL_CON1 */
	ldr	r1, =APLL_CON1_VAL
	ldr	r2, =APLL_CON1_OFFSET
	str	r1, [r0, r2]

	/* APLL_CON0 */
	ldr	r1, =APLL_CON0_VAL
	ldr	r2, =APLL_CON0_OFFSET
	str	r1, [r0, r2]

    /* check MPLL and if MPLL is not 400 Mhz skip MPLL resetting for C2C operation */
	ldr	r2, =MPLL_CON0_OFFSET
	ldr	r1, [r0, r2]
	ldr	r3, =0xa0640301
    cmp r1, r3
    bne skip_mpll 

	/* MPLL_CON1 */
	ldr	r1, =MPLL_CON1_VAL
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]

	/* MPLL_CON0 */
	ldr	r1, =MPLL_CON0_VAL
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
skip_mpll:

	/* EPLL_CON2 */
	ldr	r1, =EPLL_CON2_VAL
	ldr	r2, =EPLL_CON2_OFFSET
	str	r1, [r0, r2]

	/* EPLL_CON1 */
	ldr	r1, =EPLL_CON1_VAL
	ldr	r2, =EPLL_CON1_OFFSET
	str	r1, [r0, r2]

	/* EPLL_CON0 */
	ldr	r1, =EPLL_CON0_VAL
	ldr	r2, =EPLL_CON0_OFFSET
	str	r1, [r0, r2]

	/* VPLL_CON2 */
	ldr	r1, =VPLL_CON2_VAL
	ldr	r2, =VPLL_CON2_OFFSET
	str	r1, [r0, r2]

	/* VPLL_CON1 */
	ldr	r1, =VPLL_CON1_VAL
	ldr	r2, =VPLL_CON1_OFFSET
	str	r1, [r0, r2]

	/* VPLL_CON0 */
	ldr	r1, =VPLL_CON0_VAL
	ldr	r2, =VPLL_CON0_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x40000
7:	subs	r1, r1, #1
	bne	7b

    ldr r1, =0x01000001
    ldr r2, =CLK_SRC_CPU_OFFSET
    str r1, [r0, r2]
    ldr r1, =0x00011000
    ldr r2, =CLK_SRC_DMC_OFFSET
    str r1, [r0, r2]
    ldr r1, =0x00000110
    ldr r2, =CLK_SRC_TOP0_OFFSET
    str r1, [r0, r2]
    ldr r1, =0x01111000
    ldr r2, =CLK_SRC_TOP1_OFFSET
    str r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
8:	subs	r1, r1, #1
	bne	8b

/* check C2C_CTRL enable bit */
	ldr r3, =EXYNOS4_POWER_BASE
	ldr r1, [r3, #C2C_CTRL_OFFSET]
	and r1, r1, #1
	cmp r1, #0
	bne v310_2

/* ConControl */
#ifdef MEM_DLLl_ON
	ldr	r0, =EXYNOS4_DMC0_BASE

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
9:	subs	r1, r1, #1
	bne	9b

	ldr	r1, =0x0000008C
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
10:	subs	r1, r1, #1
	bne	10b

	ldr	r0, =EXYNOS4_DMC1_BASE

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
11:	subs	r1, r1, #1
	bne	11b

	ldr	r1, =0x0000008C
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	
	/* wait ?us */
	mov	r1, #0x20000
12:	subs	r1, r1, #1
	bne	12b
#endif

	ldr	r0, =EXYNOS4_DMC0_BASE
	ldr	r1, =0x0FFF30FA
	ldr	r2, =DMC_CONCONTROL
	str	r1, [r0, r2]

	ldr	r0, =EXYNOS4_DMC1_BASE
	ldr	r1, =0x0FFF30FA
	ldr	r2, =DMC_CONCONTROL
	str	r1, [r0, r2]

	ldr	r0, =EXYNOS4_DMC0_BASE
	ldr	r1, =0x00202533
	ldr	r2, =DMC_MEMCONTROL
	str	r1, [r0, r2]

	ldr	r0, =EXYNOS4_DMC1_BASE
	ldr	r1, =0x00202533
	ldr	r2, =DMC_MEMCONTROL
	str	r1, [r0, r2]

v310_2:    
	pop	{pc}
/*
 * uart_asm_init: Initialize UART in asm mode, 115200bps fixed.
 * void uart_asm_init(void)
 */
	.globl uart_asm_init
uart_asm_init:

	/* setup UART0-UART3 GPIOs (part1) */
	mov	r0, r7
	ldr	r1, =EXYNOS4_GPIO_A0_CON_VAL
	str	r1, [r0, #EXYNOS4_GPIO_A0_CON_OFFSET]
	ldr	r1, =EXYNOS4_GPIO_A1_CON_VAL
	str	r1, [r0, #EXYNOS4_GPIO_A1_CON_OFFSET]

	ldr r0, =EXYNOS4_UART_BASE
	add r0, r0, #EXYNOS4_DEFAULT_UART_OFFSET
    
	ldr	r1, =ULCON_VAL
	str	r1, [r0, #ULCON_OFFSET]
	ldr	r1, =UCON_VAL
	str	r1, [r0, #UCON_OFFSET]
	ldr	r1, =UFCON_VAL
	str	r1, [r0, #UFCON_OFFSET]
	ldr	r1, =UBRDIV_VAL
	str	r1, [r0, #UBRDIV_OFFSET]
	ldr	r1, =UFRACVAL_VAL
	str	r1, [r0, #UFRACVAL_OFFSET]
#ifdef CONFIG_SPL_BUILD
	ldr	r1, =0x4f4f4f4f
	str	r1, [r0, #UTXHN_OFFSET]		@'O'
#endif
	mov	pc, lr

/* Setting TZPC[TrustZone Protection Controller] */
tzpc_init:
	ldr	r0, =TZPC0_BASE
	mov	r1, #R0SIZE
	str	r1, [r0]
	mov	r1, #DECPROTXSET
	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
    mov r1, #0xbd
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	mov	r1, #DECPROTXSET
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

	ldr	r0, =TZPC1_BASE
	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

	ldr	r0, =TZPC2_BASE
	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

	ldr	r0, =TZPC3_BASE
	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

	ldr	r0, =TZPC4_BASE
	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

	ldr	r0, =TZPC5_BASE
	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

	mov	pc, lr
