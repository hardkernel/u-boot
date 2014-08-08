/*
 * Lowlevel setup for SMDKV310 board based on EXYNOS4210
 *
 * Copyright (C) 2011 Samsung Electronics
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

#ifdef CONFIG_EXYNOS4412
#include "smdk4412_val.h"
#else
#include "smdk4212_val.h"
#endif

/*
 * Register usages:
 *
 * r5 has zero always
 * r7 has GPIO part1 base 0x11400000
 * r6 has GPIO part2 base 0x11000000
 */

#define MEM_DLLl_ON

_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

	.globl lowlevel_init
lowlevel_init:
	/* use iROM stack in bl2 */
	ldr	sp, =0x02060000
	stmdb	r13!, {ip,lr}

	/* initialization for CMU_SYSCLK_ISP function */
	mov	r1, #0
	ldr	r0, =0x10021174		/* CMU_RESET_ISP_SYS_PWR_REG */
	str	r1, [r0]
	ldr	r0, =0x100213B8		/* CMU_SYSCLK_ISP_SYS_PWR_REG */
	str	r1, [r0]

	/* r5 has always zero */
	mov	r5, #0
	ldr	r7, =EXYNOS4_GPIO_PART1_BASE
	ldr	r6, =EXYNOS4_GPIO_PART2_BASE

	bl	relocate_nscode

	/* check reset status  */
	ldr r0, =(EXYNOS4_POWER_BASE + INFORM1_OFFSET)
	ldr r1, [r0]

	/* Sleep wakeup reset */
	ldr	r2, =S5P_CHECK_SLEEP
	cmp	r1, r2
	beq	wakeup_reset

	/* PS-Hold high */
	ldr	r0, =0x1002330c
	ldr	r1, [r0]
	orr	r1, r1, #0x300
	str	r1, [r0]

	/* set CP reset to low */
	ldr	r0, =0x11000C60
	ldr	r1, [r0]
	ldr	r2, =0xFFFFFF0F
	and	r1, r1, r2
	orr	r1, r1, #0x10
	str	r1, [r0]
	ldr	r0, =0x11000C68
	ldr	r1, [r0]
	ldr	r2, =0xFFFFFFF3
	and	r1, r1, r2
	orr	r1, r1, #0x4
	str	r1, [r0]
	ldr	r0, =0x11000C64
	ldr	r1, [r0]
	ldr	r2, =0xFFFFFFFD
	and	r1, r1, r2
	str	r1, [r0]

	bl read_om

	/*
	 * If U-boot is already running in ram, no need to relocate U-Boot.
	 * Memory controller must be configured before relocating U-Boot
	 * in ram.
	 */
	ldr	r0, =0x00ffffff		/* r0 <- Mask Bits*/
	bic	r1, pc, r0		/* pc <- current addr of code */
					/* r1 <- unmasked bits of pc */

	ldr	r2, _TEXT_BASE		/* r2 <- original base addr in ram */
	bic	r2, r2, r0		/* r2 <- unmasked bits of r2*/
	cmp     r1, r2                  /* compare r1, r2 */
	beq     1f			/* r0 == r1 then skip sdram init */
					/* and image loading             */

	bl pmic_init

	ldr	r0, =0x10000000 /* CHIP_ID_BASE */
	ldr	r1, [r0]
	lsr r1, r1, #8
	and r1, r1, #3
	cmp r1, #2
	bne SCP

	/* Memory initialize */
	bl mem_ctrl_asm_init

	/* init system clock */
	bl system_clock_init

	b  1f

SCP:
	/* init system clock */
	bl system_clock_init

	/* Memory initialize */
	bl mem_ctrl_asm_init_ddr3

1:
	/* for UART */
	bl	uart_asm_init

	bl	mmc_divider_change

	ldmia	r13!, {ip,pc}

wakeup_reset:
	/* clear INFORM1 for security reason  */
	ldr r0, =(EXYNOS4_POWER_BASE + INFORM1_OFFSET)
	mov r1, #0x0
	str r1, [r0]

	ldr r0, =0x10000000 /* CHIP_ID_BASE */
	ldr r1, [r0]
	lsr r1, r1, #8
	and r1, r1, #3
	cmp r1, #2
	bne SCP_wake

	/* check C2C_CTRL enable bit */
	ldr r3, =EXYNOS4_POWER_BASE
	ldr r1, [r3, #0x24] /* 0x24: C2C_CTRL_OFFSET */
	and r1, r1, #1
	cmp r1, #0
	bne skip_dmc

	/* Memory initialize */
	bl mem_ctrl_asm_init
skip_dmc:
	/* init system clock */
	bl system_clock_init

	b exit_wakeup

SCP_wake:
	/* init system clock */
	bl system_clock_init

	/* Memory initialize */
	bl mem_ctrl_asm_init_ddr3


exit_wakeup:
	b warmboot

read_om:
	/* Read booting information */
	ldr	r0, =(EXYNOS4_POWER_BASE + OM_STATUS_OFFSET)
	ldr	r1, [r0]
	bic	r2, r1, #0xffffffc1

	/* SD/MMC BOOT */
	cmp     r2, #0x4
	moveq   r3, #BOOT_MMCSD

	/* eMMC 4.4 BOOT */
	cmp	r2, #0x8
	moveq	r3, #BOOT_EMMC_4_4
	cmp	r2, #0x28
	moveq	r3, #BOOT_EMMC_4_4

	ldr	r0, =(EXYNOS4_POWER_BASE + INFORM3_OFFSET)
	str	r3, [r0]

	mov	pc, lr

/*
 * uart_asm_init: Initialize UART in asm mode, 115200bps fixed.
 * void uart_asm_init(void)
 */
	.globl uart_asm_init
uart_asm_init:

	/* setup UART0-UART3 GPIOs (part1) */
	mov	r0, r7
	ldr	r1, =0x22222222
	str	r1, [r0, #0x00]			@ EXYNOS4_GPIO_A0_OFFSET
	ldr	r1, =0x00222222
	str	r1, [r0, #0x20]			@ EXYNOS4_GPIO_A1_OFFSET

	ldr	r0, =EXYNOS4_CLOCK_BASE
	ldr	r1, =CLK_SRC_PERIL0_VAL
	ldr	r2, =0x0C250
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_PERIL0_VAL
	ldr	r2, =0x0C550
	str	r1, [r0, r2]

	ldr r0, =EXYNOS4_UART_BASE
	add r0, r0, #EXYNOS4_DEFAULT_UART_OFFSET

	ldr r1, =0x3C5
	str	r1, [r0, #0x4]
	ldr r1, =0x111
	str	r1, [r0, #0x8]
	ldr r1, =0x3
	str	r1, [r0, #0x0]
	ldr r1, =0x35
	str	r1, [r0, #0x28]
	ldr r1, =0x4
	str	r1, [r0, #0x2c]

	mov	pc, lr
	nop
	nop
	nop

check_om_setting:
	b check_om_setting


/*
 * MPLL is Changed from 400MHz to 800MHz.
 * So, MMC CH2, 4 divider need to change.
 */

mmc_divider_change:
	ldr	r0, =EXYNOS4_CLOCK_BASE
	ldr	r2, =0x0C54C /* CLK_DIV_FSYS3_OFFSET */
	ldr	r1, [r0, r2]
	bic	r1, r1, #(0xFF << 8)
	bic	r1, r1, #(0xF)
	orr	r1, r1, #(0x1 << 8)
	orr	r1, r1, #0x7
	str	r1, [r0, r2]
	ldr	r2, =0x0C548 /* CLK_DIV_FSYS2_OFFSET */
	ldr	r1, [r0, r2]
	orr	r1, r1, #0xf
	str	r1, [r0, r2]

	mov	pc, lr

/*
 * Relocate codes for secondary core to non-secure iRAM
 */
relocate_nscode:
	adr	r0, nscode_base			@ r0: source address (start)
	adr	r1, nscode_end			@ r1: source address (end)
	ldr	r2, =CONFIG_PHY_IRAM_NS_BASE	@ r2: target address

1:
	ldmia	r0!, {r3-r6}
	stmia	r2!, {r3-r6}
	cmp	r0, r1
	blt	1b

	dsb
	isb

	mov	pc, lr


	.align	4
nscode_base:
	adr	r0, _ns_reg5
	b	1f

	.word	0x0		@ REG0: RESUME_ADDR
	.word	0x0		@ REG1: RESUME_FLAG
	.word	0x0		@ REG2
	.word	0x0		@ REG3
	.word	0x0		@ REG4
_ns_reg5:
	.word	0x0		@ REG5: CPU1_BOOT_REG
	.word	0x0		@ REG6: REG_DIRECTGO_FLAG
	.word	0x0		@ REG7: REG_DIRECTGO_ADDR
	.word	0x0		@ REG8
	.word	0x0		@ REG9

	nop
	nop

1:
#if defined(CONFIG_EXYNOS4412)
	mrc	p15, 0, r1, c0, c0, 5		@ MPIDR
	and	r1, r1, #0x3
	add	r0, r0, r1, lsl #0x2
#endif
cpu1_wait:
	.word	0xE320F002			@ wfe instruction
	ldr	r1, [r0]
	cmp	r1, #0x0
	bxne	r1
	b	cpu1_wait
	nop
nscode_end:
