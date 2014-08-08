/*
 * Copyright (C) 2012 Samsung Electronics
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

#include "smdk5410_val.h"


_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

#ifdef CONFIG_MACH_UNIVERSAL5410
delay_for_t32:
	subs r0, r0, #1
	bne delay_for_t32
	mov pc, lr
#endif

	.globl lowlevel_init
lowlevel_init:
	/* PS-HOLD high */
	ldr r0, =0x1004330C
	mov r1, #0x5300
	str r1, [r0]
	ldr r0, =0x13400C48
	mov r1, #0
	str r1, [r0]
	ldr r0, =0x13400020
	mov r1, #0x22
	str r1, [r0]
	ldr r0, =0x13400028
	mov r1, #0
	str r1, [r0]

	/* use iRAM stack in bl2 */
	ldr	sp, =CONFIG_IRAM_STACK
	stmdb	r13!, {ip,lr}

	bl	relocate_nscode

	/* check reset status */
	ldr	r0, =(EXYNOS5_POWER_BASE + INFORM1_OFFSET)
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

#ifdef CONFIG_PM
	bl	pmic_init
#endif

	bl	uart_asm_init

	bl	read_om

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
	beq	after_copy		/* r0 == r1 then skip sdram init */

#ifdef CONFIG_MACH_UNIVERSAL5410
	/* wail 1 second for t32 attach */
	ldr r0, =0x400000
	bl delay_for_t32
#endif

	/* init system clock */
	bl	system_clock_init

	/* Memory initialize */
	bl	mem_ctrl_init

	/* Change clocks for eMMC and SDMMC */
	bl	emmc_devider_change
	bl	sdmmc_devider_change

	ldmia	r13!, {ip,pc}

after_copy:
#ifndef CONFIG_SPL_BUILD
#ifdef CONFIG_PM
	bl	pmic_late_init
#endif
#endif

	ldmia	r13!, {ip,pc}

wakeup_reset:
	/* init system clock */
	bl	system_clock_init

	/* Memory initialize */
	bl	mem_ctrl_init

exit_wakeup:
	b       warmboot

read_om:
	/* Read booting information */
	ldr	r0, =EXYNOS5_POWER_BASE
	ldr	r1, [r0]
	bic	r2, r1, #0xffffffc1

	/* SD/MMC BOOT */
	cmp     r2, #0x4
	moveq   r3, #BOOT_MMCSD

	/* eMMC BOOT */
	cmp	r2, #0x6
	moveq	r3, #BOOT_EMMC

	/* eMMC 4.4 BOOT */
	cmp	r2, #0x8
	moveq	r3, #BOOT_EMMC_4_4
	cmp	r2, #0x28
	moveq	r3, #BOOT_EMMC_4_4

	ldr	r0, =EXYNOS5_POWER_BASE
	str	r3, [r0, #INFORM3_OFFSET]

	mov	pc, lr

/*
 * uart_asm_init: Initialize UART in asm mode, 115200bps fixed.
 * void uart_asm_init(void)
 */
	.globl	uart_asm_init
uart_asm_init:

	/* set GPIO to enable UART */
	@ GPIO setting for UART for UART0/1/2/3
	ldr	r0, =0x13400000	@GPA0CON
	ldr	r1, =0x22222222 @UART0,1
	str   	r1, [r0]
	ldr	r0, =0x13400020 @GPA1CON
	ldr	r1, =0x00222222	@UART2,3
	str   	r1, [r0]

	ldr	r0, =EXYNOS5_CLOCK_BASE
	ldr	r1, =0x99999
	ldr	r2, =CLK_SRC_PERIC0_OFFSET	@0x10250
	str	r1, [r0, r2]

	ldr	r1, =0x99999
	ldr	r2, =CLK_DIV_PERIC0_OFFSET	@0x10558
	str	r1, [r0, r2]

	ldr	r0, =UART_CONSOLE_BASE
	ldr	r1, =0x3
	str	r1, [r0, #ULCON_OFFSET]

	ldr	r1, =0x3c5
	str	r1, [r0, #UCON_OFFSET]
#if defined(CONFIG_MACH_ASB5410)
	ldr	r1, =0x117
	str	r1, [r0, #UFCON_OFFSET]
#else
	ldr	r1, =0x111
	str	r1, [r0, #UFCON_OFFSET]
#endif

	ldr	r1, =UART_UBRDIV_VAL
	str	r1, [r0, #UBRDIV_OFFSET]

	ldr	r1, =UART_UDIVSLOT_VAL
	str	r1, [r0, #0x2C]

	mov	pc, lr

/*
 * MPLL is Changed from 400MHz to 800MHz.
 * So, eMMC devider need to change.
 */
emmc_devider_change:
#if defined(USE_MMC4)
	ldr	r0, =EXYNOS5_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS3_OFFSET
	ldr	r1, [r0, r2]
	bic	r1, r1, #(0xFF << 8)
	bic	r1, r1, #(0xF)
	orr 	r1, r1, #(0x1<< 8)
	orr 	r1, r1, #0x9
	str 	r1, [r0, r2]
#elif defined(USE_MMC0)
	ldr	r0, =EXYNOS5_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS1_OFFSET
	ldr	r1, [r0, r2]
	bic	r1, r1, #(0xFF << 8)
	bic	r1, r1, #(0xF)
	orr 	r1, r1, #(0x7 << 8)
	orr	r1, r1, #2
	str 	r1, [r0, r2]
#endif
	mov	pc, lr

sdmmc_devider_change:
	ldr	r0, =EXYNOS5_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS2_OFFSET
	ldr	r1, [r0, r2]
	bic	r1, r1, #(0xFF << 8)
	bic	r1, r1, #(0xF)
	orr	r1, r1, #(0x7<< 8)
	orr	r1, r1, #0x2
	str	r1, [r0, r2]
	mov	pc, lr

/*
 * Relocate code
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

	.word	0xF57FF04F			@dsb	sy
	.word	0xF57FF06F			@isb	sy

	mov	pc, lr
	.ltorg

/*
 * CPU1 waits here until CPU0 wake it up.
 * - below code is copied to CONFIG_PHY_IRAM_NS_BASE, which is non-secure memory.
 */
nscode_base:
	b	1f
	nop				@ for backward compatibility

	.word	0x0			@ REG0: RESUME_ADDR
	.word	0x0			@ REG1: RESUME_FLAG
	.word	0x0			@ REG2
	.word	0x0			@ REG3
_switch_addr:
	.word	0x0			@ REG4: SWITCH_ADDR
_hotplug_addr:
	.word	0x0			@ REG5: CPU1_BOOT_REG
	.word	0x0			@ REG6
_c2_addr:
	.word	0x0			@ REG7: REG_C2_ADDR
_cpu_state:
	.word	0x1			@ CPU0_STATE : RESET
	.word	0x2			@ CPU1_STATE : SECONDARY RESET
	.word	0x2			@ CPU2_STATE : SECONDARY RESET
	.word	0x2			@ CPU3_STATE : SECONDARY RESET
_gic_state:
	.word	0x0			@ CPU0 - GICD_IGROUPR0
	.word	0x0			@ CPU1 - GICD_IGROUPR0
	.word	0x0			@ CPU2 - GICD_IGROUPR0
	.word	0x0			@ CPU3 - GICD_IGROUPR0

#define RESET			(1 << 0)
#define SECONDARY_RESET		(1 << 1)
#define HOTPLUG			(1 << 2)
#define C2_STATE		(1 << 3)
#define SWITCH			(1 << 4)

1:
	adr	r0, _cpu_state

	mrc	p15, 0, r7, c0, c0, 5	@ read MPIDR
        and	r7, r7, #0xf		@ r7 = cpu id

	/* read the current cpu state */
	ldr	r10, [r0, r7, lsl #2]

	/* HYP entry */

	/*
	 * Set the HYP spsr to itself, so that the entry point
	 * does not see the difference between a function call
	 * and an exception return.
	 */
	mrs	r4, cpsr
	msr     spsr_cxsf, r4

	bic	r6, r4, #0x1f
	orr	r6, r6, #0x13
	msr     spsr_cxsf, r6		/* Setup SPSR to jump to NS SVC mode */
	add     r4, pc, #4
	.word	0xe12ef304	/* msr    elr_hyp, r4 */
	.word	0xe160006e	/* ERET */
ns_svc_entry:
	tst	r10, #SWITCH
	adrne	r0, _switch_addr
	bne	wait_for_addr
	tst	r10, #C2_STATE
	adrne	r0, _c2_addr
	bne	wait_for_addr

	/* clear INFORM1 for security reason  */
	ldr	r0, =(EXYNOS5_POWER_BASE + INFORM1_OFFSET)
	ldr	r1, [r0]
	cmp	r1, #0x0
	movne	r1, #0x0
	strne	r1, [r0]
	ldrne	r1, =(EXYNOS5_POWER_BASE + INFORM0_OFFSET)
	ldrne	pc, [r1]

	tst	r10, #RESET
	ldrne	pc, =CONFIG_SYS_TEXT_BASE

	adr	r0, _hotplug_addr
wait_for_addr:
	ldr	r1, [r0]
	cmp	r1, #0x0
	bxne	r1
	wfe
	b	wait_for_addr
	.ltorg
nscode_end:

