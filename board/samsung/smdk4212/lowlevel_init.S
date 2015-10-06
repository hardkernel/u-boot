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
#include <version.h>
#include <asm/arch/cpu.h>
#include <asm/arch/s5p_nand.h>
#ifdef CONFIG_EXYNOS4412
#include "smdk4412_val.h"
#else
#include "smdk4212_val.h"
#endif

_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

	.globl cache_init
cache_init:
	mrc	p15, 0, r0, c0, c0, 0	@ read main ID register
	and	r1, r0, #0x00f00000	@ variant
	and	r2, r0, #0x0000000f	@ revision
	orr	r2, r2, r1, lsr #20-4	@ combine variant and revision
	cmp	r2, #0x30
	mrceq	p15, 0, r0, c1, c0, 1	@ read ACTLR
	orreq	r0, r0, #0x6		@ Enable DP1(2), DP2(1)
	mcreq	p15, 0, r0, c1, c0, 1	@ write ACTLR
	mov pc, lr

	/* Set EMA value for Pegasus-Q Prime */
set_ema_value:
	ldr r0, =CHIP_ID_BASE
	ldr r1, [r0]

	lsr r2, r1, #12
	ldr r3, =0xE4412
	cmp r2, r3
	movne pc, lr

	and r1, r1, #0xff
	subs r1, r1, #0x20
	movmi pc, lr

	/* before setting EMA value
	   SCLK_APLL must be under 200Mhz
	   iROM sets APLL 400Mhz
	   so set SCLK_APLL to 200Mhz
	   by changing APLL_RATIO from 0 to 1 */
	ldr r0, =0x10044500
	ldr r1, [r0]
	orr r1, r1, #0x1000000
	str r1, [r0]

	ldr r0, =0x10045008
	ldr r1, =0x00000101
	str r1, [r0]
	mov pc, lr

	.globl lowlevel_init
lowlevel_init:

	/* use iROM stack in bl2 */
	ldr	sp, =0x02060000
	push {lr}

	ldr	r0, =ELFIN_PMU_BASE		@0x1002_0000

@ Set XCLKOUT SRC XUSBXTI for ODROID-EX USB-Host
	ldr	r1, =0x0900
	ldr	r2, =PMU_DEBUG_OFFSET
	str	r1, [r0, r2]

	bl set_ema_value

	/* initialization for CMU_SYSCLK_ISP function */
	mov	r1, #0
	ldr	r0, =0x10021174		/* CMU_RESET_ISP_SYS_PWR_REG */
	str	r1, [r0]
	ldr	r0, =0x100213B8		/* CMU_SYSCLK_ISP_SYS_PWR_REG */
	str	r1, [r0]

	/* check reset status  */
	ldr     r0, =(INF_REG_BASE + INF_REG1_OFFSET)
	ldr     r1, [r0]

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

	/* During sleep/wakeup or AFTR mode, pmic_init function is not available 
	 * and it causes delays. So except for sleep/wakeup and AFTR mode, 
	 * the below function is needed 
	 */
	bl pmic_init

	bl read_om

	/* when we already run in ram, we don't need to relocate U-Boot.
	 * and actually, memory controller must be configured before U-Boot
	 * is running in ram.
	 */
	ldr	r0, =0xff000fff
	bic	r1, pc, r0		/* r0 <- current base addr of code */
	ldr	r2, _TEXT_BASE	/* r1 <- original base addr in ram */
	bic	r2, r2, r0		/* r0 <- current base addr of code */
	cmp r1, r2			/* compare r0, r1 */
	beq after_copy		/* r0 == r1 then skip sdram init and u-boot.bin loading */

	ldr	r0, =CHIP_ID_BASE
	ldr	r1, [r0]
	lsr r1, r1, #8
	and r1, r1, #3
	cmp r1, #2
	bne v310_1

	/* Memory initialize */
	bl mem_ctrl_asm_init

	/* init system clock */
	bl system_clock_init

	b  1f

v310_1:
	/* init system clock */
	bl system_clock_init

	/* Memory initialize */
	bl mem_ctrl_asm_init_ddr3

1:
	b load_uboot

cold_boot:
	bl	relocate_code

	ldr	r0, _boot_device

	b	coldboot

_boot_device:
	.word	0x0

after_copy:
	bl uart_asm_init

	/* set up C2C */	
	ldr r0, =S5PV310_SYSREG_BASE
	ldr r2, =GENERAL_CTRL_C2C_OFFSET
	ldr r1, [r0, r2]
	ldr r3, =0x4000
	orr r1, r1, r3
	str r1, [r0, r2]

#ifdef CONFIG_ENABLE_MMU
	bl enable_mmu
#endif

	/* store second boot information in u-boot C level variable */
	ldr r0, =CONFIG_PHY_UBOOT_BASE
	sub r0, r0, #8
	ldr r1, [r0]
	ldr r0, _second_boot_info
	str r1, [r0]

	/* Print 'K' */
	ldr	r0, =S5PV310_UART_CONSOLE_BASE
	ldr	r1, =0x4b4b4b4b
	str	r1, [r0, #UTXH_OFFSET]

	ldr r0, _board_init_f
	mov pc, r0
	
_board_init_f:
	.word board_init_f

_second_boot_info:
	.word second_boot_info


wakeup_reset:
	/* clear INFORM1 for security reason  */
	ldr	r0, =(INF_REG_BASE + INF_REG1_OFFSET)
	mov	r1, #0x0
	str	r1, [r0]

	ldr	r0, =CHIP_ID_BASE
	ldr	r1, [r0]
	lsr	r1, r1, #8
	and	r1, r1, #3
	cmp	r1, #2
	bne	wake_v310

	/* check C2C_CTRL enable bit */
	ldr r3, =S5PV310_POWER_BASE
	ldr r1, [r3, #C2C_CTRL_OFFSET]
	and r1, r1, #1
	cmp r1, #0
	bne skip_dmc
	
	/* init system clock */
	bl	mem_ctrl_asm_init
skip_dmc:
	bl	system_clock_init
	b	exit_wakeup

wake_v310:
	bl system_clock_init
	bl mem_ctrl_asm_init_ddr3

exit_wakeup:
	bl	relocate_code

	b	warmboot

read_om:
	/* Read booting information */
	ldr	r0, =S5PV310_POWER_BASE
	ldr	r1, [r0,#OMR_OFFSET]
	bic	r2, r1, #0xffffffc1

#ifndef CONFIG_BOOTLOADER_MONITOR
	/* NAND BOOT */
@	cmp	r2, #0x0		@ 512B 4-cycle
@	moveq	r3, #BOOT_NAND

@	cmp	r2, #0x2		@ 2KB 5-cycle
@	moveq	r3, #BOOT_NAND

@	cmp	r2, #0x4		@ 4KB 5-cycle	8-bit ECC
@	moveq	r3, #BOOT_NAND

	cmp     r2, #0xA
	moveq   r3, #BOOT_ONENAND

	cmp	r2, #0x10	@ 2KB 5-cycle	16-bit ECC
	moveq	r3, #BOOT_NAND
#endif

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

	ldr	r0, =INF_REG_BASE
	str	r3, [r0, #INF_REG3_OFFSET]

	mov	pc, lr


/*
 * uart_asm_init: Initialize UART in asm mode, 115200bps fixed.
 * void uart_asm_init(void)
 */
	.globl uart_asm_init
uart_asm_init:

	/* set GPIO to enable UART */
	@ GPIO setting for UART for UART0/1/2/3
	ldr	r0, =0x11400000
	ldr	r1, =0x22222222
	str   	r1, [r0]
	ldr	r0, =0x11400020
	ldr	r1, =0x222222
	str   	r1, [r0]

	ldr	r0, =S5PV310_CLOCK_BASE
	ldr	r1, =CLK_SRC_PERIL0_VAL
	ldr	r2, =CLK_SRC_PERIL0_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_PERIL0_VAL
	ldr	r2, =CLK_DIV_PERIL0_OFFSET
	str	r1, [r0, r2]

	ldr	r0, =S5PV310_UART_CONSOLE_BASE
	ldr	r1, =0x111
	str	r1, [r0, #UFCON_OFFSET]

	mov	r1, #0x3
	str	r1, [r0, #ULCON_OFFSET]

	ldr	r1, =0x3c5
	str	r1, [r0, #UCON_OFFSET]

	ldr	r1, =UART_UBRDIV_VAL
	str	r1, [r0, #UBRDIV_OFFSET]

	ldr	r1, =UART_UDIVSLOT_VAL
	str	r1, [r0, #UDIVSLOT_OFFSET]

	ldr	r1, =0x4f4f4f4f
	str	r1, [r0, #UTXH_OFFSET]		@'O'

	mov	pc, lr


load_uboot:
	ldr	r0, =INF_REG_BASE
	ldr	r1, [r0, #INF_REG3_OFFSET]
	cmp 	r1, #BOOT_MMCSD
	beq 	mmcsd_boot
	cmp	r1, #BOOT_EMMC
	beq	emmc_boot
	cmp	r1, #BOOT_EMMC_4_4
	beq	emmc_boot_4_4
	cmp     r1, #BOOT_SEC_DEV
	beq     mmcsd_boot

mmcsd_boot:
#ifdef CONFIG_SMDKC220
//#ifdef CONFIG_CLK_BUS_DMC_200_400
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS2_OFFSET
	ldr	r1, [r0, r2]
	orr r1, r1, #0xf
	str r1, [r0, r2]
//#endif
#else
#if defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS2_OFFSET
	ldr	r1, [r0, r2]
	orr r1, r1, #0xf
	str r1, [r0, r2]
#endif
#endif

	mov	r0, #SDMMC_CH2
	str	r0, _boot_device
	bl	load_uboot_image

	b	cold_boot
	b       after_copy

emmc_boot:
#if defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS1_OFFSET
	ldr	r1, [r0, r2]
	orr 	r1, r1, #0xf
	str 	r1, [r0, r2]
#endif

	mov	r0, #EMMC
	str	r0, _boot_device
	bl	load_uboot_image

	b	cold_boot
	b	after_copy

emmc_boot_4_4:
	/* read TCBCNT to get Transferred CIU card byte count */
	ldr r0, =0x1255005c
	ldr r1, [r0]
	ldr r2, =0x6000
	cmp r1, r2
	/* store second boot information in DRAM */
	ldr r0, =CONFIG_PHY_UBOOT_BASE
	sub r0, r0, #8
	mov r3, #0
	movlo r3, #1
	str r3, [r0]

	/* if transferred CIU card byte count >= 0x6000 (24 KB)  */
	/* BL1 and BL2 are loaded from emmc 4.4 			     */
	/* Otherwise BL1 and BL2 are loaded from sdmmc ch2.      */
	blo mmcsd_boot

	/* mmc ch4 devider value change */
	bl	mmc_ch4_devider_change

	mov	r0, #EMMC_4_4
	str	r0, _boot_device
	bl	load_uboot_image

	b	cold_boot
	b	after_copy

check_om_setting:
	b check_om_setting


/*
 * MPLL is Changed from 400MHz to 800MHz.
 * So, MMC CH4 devider need to change.
 */

mmc_ch4_devider_change:
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS3_OFFSET
	ldr	r1, [r0, r2]
	bic	r1, r1, #(0xFF << 8)
	bic	r1, r1, #(0xF)
	orr r1, r1, #(0x1 << 8)
	orr r1, r1, #0x7
	str r1, [r0, r2]
	mov	pc, lr


/*
 * Relocate code
 */
relocate_code:
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


#ifdef CONFIG_ENABLE_MMU
enable_mmu:
	/* enable domain access */
	ldr	r5, =0x0000ffff
	mcr	p15, 0, r5, c3, c0, 0		@load domain access register

	/* Set the TTB register */
	ldr	r0, =mmu_table
	ldr	r1, =CONFIG_PHY_UBOOT_BASE
	ldr	r2, =0xfff00000
	bic	r0, r0, r2
	orr	r1, r0, r1
	mcr	p15, 0, r1, c2, c0, 0

	/* Enable the MMU */
mmu_on:
	mrc	p15, 0, r0, c1, c0, 0
	orr	r0, r0, #1
	mcr	p15, 0, r0, c1, c0, 0
	nop
	nop
	nop
	nop
	mov	pc, lr

/*
 * we assume that cache operation is done before. (eg. cleanup_before_linux())
 * actually, we don't need to do anything about cache if not use d-cache in U-Boot
 * So, in this function we clean only MMU. by scsuh
 *
 * void	theLastJump(void *kernel, int arch_num, uint boot_params);
 */
	.globl theLastJump
theLastJump:
	mov	r9, r0
	ldr	r3, =0xfff00000
	ldr	r4, =CONFIG_PHY_UBOOT_BASE
	adr	r5, phy_last_jump
	bic	r5, r5, r3
	orr	r5, r5, r4
	mov	pc, r5
phy_last_jump:
	/*
	 * disable MMU stuff
	 */
	mrc	p15, 0, r0, c1, c0, 0
	bic	r0, r0, #0x00002300	/* clear bits 13, 9:8 (--V- --RS) */
	bic	r0, r0, #0x00000087	/* clear bits 7, 2:0 (B--- -CAM) */
	orr	r0, r0, #0x00000002	/* set bit 2 (A) Align */
	orr	r0, r0, #0x00001000	/* set bit 12 (I) I-Cache */
	mcr	p15, 0, r0, c1, c0, 0

	mcr	p15, 0, r0, c8, c7, 0	/* flush v4 TLB */

	mov	r0, #0
	mov	pc, r9

/*
 * MMU Table for SMDKC210
 * 0x0000_0000 -- 0x1FFF_FFFF => A:0x0000_0000 -- 0x1FFF_FFFF
 * 0x2000_0000 -- 0x3FFF_FFFF => Not Allowed
 * 0x4000_0000 -- 0x5FFF_FFFF => A:0x4000_0000 -- 0x5FFF_FFFF
 * 0x6000_0000 -- 0xBFFF_FFFF => Not Allowed
 * 0xC000_0000 -- 0xDFFF_FFFF => A:0x4000_0000 -- 0X5FFF_FFFF
 * 0xE000_0000 -- 0xFFFF_FFFF => Not Allowed
 */

	/* form a first-level section entry */
.macro FL_SECTION_ENTRY base,ap,d,c,b
	.word (\base << 20) | (\ap << 10) | \
	      (\d << 5) | (1<<4) | (\c << 3) | (\b << 2) | (1<<1)
.endm

.section .mmudata, "a"
	.align 14
	// the following alignment creates the mmu table at address 0x4000.
	.globl mmu_table

#if defined(CONFIG_EXYNOS_PRIME)
mmu_table:
	.set __base,0
	// Access for iRAM
	.rept 0x200
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

	// Not Allowed
	.rept 0x400 - 0x200
	.word 0x00000000
	.endr

	.set __base,0x400
	// 512MB for SDRAM with cacheable
	.rept 0xc00 - 0x400
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	.set __base,0x400
	// 512MB for SDRAM with cacheable
	.rept 0x1000 - 0xC00
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

#else

mmu_table:
	.set __base,0
	// Access for iRAM
	.rept 0x200
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

	// Not Allowed
	.rept 0x400 - 0x200
	.word 0x00000000
	.endr

	.set __base,0x400
	// 512MB for SDRAM with cacheable
	.rept 0x600 - 0x400
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr
	
	// access is not allowed.
	.rept 0xc00 - 0x600
	.word 0x00000000
	.endr

	.set __base,0x400
	// 512MB for SDRAM with cacheable
	.rept 0xE00 - 0xC00
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	// access is not allowed.
	.rept 0x1000 - 0xE00
	.word 0x00000000
	.endr
#endif
#endif


