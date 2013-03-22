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

_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

	.globl lowlevel_init
lowlevel_init:

	/* use iROM stack in bl2 */
	ldr	sp, =0xd0026000
	push	{lr}

	ldr	r0, =ELFIN_POWER_BASE
	ldr	r1, [r0, #INF_REG7_OFFSET]
	mov	r2, #0x7
	and	r1, r2, r1
	str	r1, [r0, #INF_REG3_OFFSET]

	/* set PSHOLD high */
	ldr	r0, =(ELFIN_GPIO_BASE + PSHOLD_CON_OFFSET)
	mov	r1, #0x1b
	str	r1, [r0]

	/* Disable Watchdog */
	ldr	r0, =(ELFIN_WATCHDOG_BASE + WTCON_OFFSET)
	mov	r1, #0
	str	r1, [r0]

	/* SROMC setting */
	ldr	r0, =(ELFIN_SROMC_BASE + SROM_BW_OFFSET)
	mov	r1, #9
	str	r1, [r0]

	/* GPIO -> SROMC */
	ldr	r0, =(ELFIN_GPIO_BASE + GPICON_OFFSET)
	ldr	r1, =0xffffffff
	str	r1, [r0]
	ldr	r0, =(ELFIN_GPIO_BASE + GPJCON_OFFSET)
	str	r1, [r0]

	/* wake up reset */
	ldr	r0, =(ELFIN_POWER_BASE + RST_STAT_OFFSET)
	ldr	r1, [r0]
	bic	r1, r1, #0xfffffff7
	cmp	r1, #0x8
	beq	wakeup_reset

	ldr	r0, =0xff000fff
	bic	r1, pc, r0		/* r0 <- current base addr of code */
	ldr	r2, _TEXT_BASE		/* r1 <- original base addr in ram */
	bic	r2, r2, r0		/* r0 <- current base addr of code */
	cmp 	r1, r2			/* compare r0, r1                  */
	beq	after_copy		/* r0 == r1 then skip sdram init   */

	/* init system clock */
	bl	system_clock_init

	/* init dram controller */
	bl	mem_ctrl_asm_init

	b	load_uboot

after_copy:

#ifndef CONFIG_S5P6460_IP_TEST
	/* for UART */
	bl 	uart_asm_init
#endif
	bl 	tzpc_init

#ifdef CONFIG_ENABLE_MMU
	bl	enable_mmu
#endif

	/* Print 'K' */
	ldr	r0, =ELFIN_UART_CONSOLE_BASE
	ldr	r1, =0x4b
	str	r1, [r0, #UTXH_OFFSET]		@'K'

	ldr	r0, _board_init_f
	mov	pc, r0

_board_init_f:
	.word board_init_f

wakeup_reset:

	/* init system clock */
	bl	system_clock_init

	/* init dram controller */
	bl	mem_ctrl_asm_init

	bl 	tzpc_init

	/* Clear wakeup status register */
	ldr	r0, =(ELFIN_POWER_BASE + WAKEUP_STAT_OFFSET)
	ldr	r1, [r0]
	str	r1, [r0]

	/* Load return address and jump to kernel */
	ldr	r0, =(ELFIN_POWER_BASE + INF_REG4_OFFSET)
	ldr	r1, [r0]	/* r1 = physical address of s5p6450_cpu_resume function*/
	mov	pc, r1		/*Jump to kernel (sleep-s5p6450.S)*/
	nop
	nop

/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */
system_clock_init:

	ldr	r0, =ELFIN_CLOCK_BASE	@0xE0100000

	mov	r1, #0
	str	r1, [r0, #CLK_SRC0_OFFSET]
	str	r1, [r0, #CLK_SRC1_OFFSET]

	ldr   	r1, =0x01051310
	str	r1, [r0, #CLK_DIV0_OFFSET]
	ldr   	r1, =0x60134666
	str	r1, [r0, #CLK_DIV1_OFFSET]
	ldr   	r1, =0x03283066
	str	r1, [r0, #CLK_DIV2_OFFSET]
	ldr   	r1, =0x00141420
	str	r1, [r0, #CLK_DIV3_OFFSET]

	ldr   	r1, =0x00001689
	str	r1, [r0, #APLL_LOCK_OFFSET]
	str	r1, [r0, #MPLL_LOCK_OFFSET]

	ldr   	r1, =0x01160401
	str	r1, [r0, #APLL_CON_OFFSET]
	ldr   	r1, =0x81160401
	str	r1, [r0, #APLL_CON_OFFSET]

	ldr   	r1, =0x01160401
	str	r1, [r0, #MPLL_CON_OFFSET]
	ldr   	r1, =0x81160401
	str	r1, [r0, #MPLL_CON_OFFSET]

	ldr   	r1, =0x00250203
	str	r1, [r0, #EPLL_CON_OFFSET]
	ldr   	r1, =0x000CA1B5
	str	r1, [r0, #EPLL_CON_K_OFFSET]
	ldr   	r1, =0x80250203
	str	r1, [r0, #EPLL_CON_OFFSET]

	ldr   	r1, =0x001B0102
	str	r1, [r0, #DPLL_CON_OFFSET]
	ldr   	r1, =0x01005055
	str	r1, [r0, #DPLL_CON_K_OFFSET]
	ldr   	r1, =0x801B0102
	str	r1, [r0, #DPLL_CON_OFFSET]

	/* wait at least ?us to stablize all clock */
	mov	r1, #0x10000
1:	subs	r1, r1, #1
	bne	1b

	ldr   	r1, =0x0008804e
	str	r1, [r0, #OTHERS_OFFSET]

	ldr   	r1, =0x84556467
	str	r1, [r0, #CLK_SRC0_OFFSET]
	ldr   	r1, =0x00000230
	str	r1, [r0, #CLK_SRC1_OFFSET]

	ldr	r2, =ELFIN_GPIO_BASE
	ldr   	r1, =0xf0000000
	str	r1, [r2, #GPFCON_OFFSET]
	ldr   	r1, =0x00002000
	str	r1, [r0, #CLK_OUT0_OFFSET]
	ldr   	r1, =0x00006000
	str	r1, [r0, #CLK_OUT1_OFFSET]

	mov	pc, lr

load_uboot:

	ldr	r0, =ELFIN_POWER_BASE
	ldr	r1, [r0, #INF_REG7_OFFSET]

	mov	r2, #0xF
	and	r1, r2, r1
	str	r1, [r0, #INF_REG3_OFFSET]

	cmp	r1, #BOOT_MMCSD
	beq	mmcsd_boot
	cmp	r1, #BOOT_EMMC
	beq	emmc43_boot
	cmp	r1, #BOOT_EMMC_4_4
	beq	emmc44_boot
	cmp	r1, #BOOT_SEC_DEV
	beq	mmcsd_boot

mmcsd_boot:

	/*
	 * MMC0, MMC1 Devider Change
	 */
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV1_OFFSET
	ldr	r1, [r0, r2]
	orr 	r1, r1, #0xFF
	str 	r1, [r0, r2]

	/* SDHC devider */
	ldr	r0, =ELFIN_HSMMC_0_BASE
	ldr	r2, =HM_CLKCON
	ldr	r1, [r0, r2]
	bic 	r1, r1, #(0xFF<<8)
	orr 	r1, r1, #(0x1<<8)
	str 	r1, [r0, r2]

	ldr	r0, =ELFIN_HSMMC_1_BASE
	ldr	r2, =HM_CLKCON
	ldr	r1, [r0, r2]
	bic 	r1, r1, #(0xFF<<8)
	orr 	r1, r1, #(0x1<<8)
	str 	r1, [r0, r2]

	bl	movi_uboot_copy
	b	after_copy

emmc43_boot:
	/* u-boot image copy from boot partition to DRAM */
	bl	emmc_uboot_copy
	/* Exit Boor Mode */
	bl emmc_4_3_endbootOp_eMMC
	b	after_copy

emmc44_boot:
	/*
	 * MMC3 Devider Change
	 */
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV1_OFFSET
	ldr	r1, [r0, r2]
	orr 	r1, r1, #(0xf<<28)
	str 	r1, [r0, r2]

	/* MSHC devider */
	ldr	r0, =ELFIN_MSH_BASE
	ldr	r2, =MSH_CLKDIV
	ldr	r1, [r0, r2]
	bic 	r1, r1, #(0xFF)
	orr 	r1, r1, #(0x1)
	str 	r1, [r0, r2]

	/* u-boot image copy from boot partition to DRAM */
	bl	emmc_4_4_uboot_copy
	/* Exit Boor Mode */
	bl emmc_4_4_endbootOp_eMMC
	b	after_copy

/*
 * uart_asm_init: Initialize UART in asm mode, 115200bps fixed.
 * void uart_asm_init(void)
 */
uart_asm_init:
	/* set GPIO to enable UART */
	@ GPIO setting for UART 0,1
	ldr	r0, =ELFIN_GPIO_BASE
	ldr	r1, =0x222222
	str   	r1, [r0, #GPACON_OFFSET]
	ldr	r1, =0x2222
	str   	r1, [r0, #GPBCON_OFFSET]

	ldr	r0, =ELFIN_UART_CONSOLE_BASE		@0xEC800400
	mov	r1, #0x0
	str	r1, [r0, #UFCON_OFFSET]
	str	r1, [r0, #UMCON_OFFSET]

	mov	r1, #0x3                	@was 0.
	str	r1, [r0, #ULCON_OFFSET]

	ldr	r1, =0xa45			/* UARTCLK SRC = x0 => PCLK */
	str	r1, [r0, #UCON_OFFSET]

#if defined(CONFIG_CLK_667_166_83)
	ldr	r1, =0x2c
	str	r1, [r0, #UBRDIV_OFFSET]

	ldr	r1, =0x0888

	str	r1, [r0, #UDIVSLOT_OFFSET]
#elif defined(CONFIG_CLK_533_133_66)
	ldr	r1, =0x22
	str	r1, [r0, #UBRDIV_OFFSET]

	ldr	r1, =0xDDDD

	str	r1, [r0, #UDIVSLOT_OFFSET]
#elif defined(CONFIG_CLK_400_100_50)
	ldr	r1, =0x1A
	str	r1, [r0, #UBRDIV_OFFSET]

	ldr	r1, =0x0808

	str	r1, [r0, #UDIVSLOT_OFFSET]
#endif
	ldr	r0, =ELFIN_UART_CONSOLE_BASE
	ldr	r1, =0x4f
	str	r1, [r0, #UTXH_OFFSET]		@'O'

	mov	pc, lr

#ifdef CONFIG_ENABLE_MMU
enable_mmu:
	/* enable domain access */
	ldr	r5, =0x0000ffff
	mcr	p15, 0, r5, c3, c0, 0	/* load domain access register */

	/* Set the TTB register */
	ldr	r0, =mmu_table
	ldr	r1, =CONFIG_SYS_PHY_UBOOT_BASE
	ldr	r2, =0xfff00000
	bic	r0, r0, r2
	orr	r1, r0, r1
	mcr	p15, 0, r1, c2, c0, 0

mmu_enable:
	/* Enable the MMU */
	mrc	p15, 0, r0, c1, c0, 0
	orr	r0, r0, #1		/* Set CR_M to enable MMU */
	mcr	p15, 0, r0, c1, c0, 0
	nop
	nop
	mov	pc, lr
#endif

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
 * Setting TZPC[TrustZone Protection Controller]
 */
tzpc_init:
        ldr     r0, =ELFIN_TZPC0_BASE
        mov     r1, #0x0
        str     r1, [r0]
        mov     r1, #0xff
        str     r1, [r0, #TZPC_DECPROT0SET_OFFSET]
        str     r1, [r0, #TZPC_DECPROT1SET_OFFSET]

        ldr     r0, =ELFIN_TZPC1_BASE
        str     r1, [r0, #TZPC_DECPROT0SET_OFFSET]
        str     r1, [r0, #TZPC_DECPROT1SET_OFFSET]

	mov	pc, lr

#ifdef CONFIG_ENABLE_MMU
/*
 * MMU Table for SMDK6400
 */

	/* form a first-level section entry */
.macro FL_SECTION_ENTRY base,ap,d,c,b
	.word (\base << 20) | (\ap << 10) | \
	      (\d << 5) | (1<<4) | (\c << 3) | (\b << 2) | (1<<1)
.endm

.section .mmudata, "a"
	.align 14
	/* the following alignment creates the mmu table at address 0x4000. */
	.globl mmu_table
mmu_table:
	.set __base, 0
	/* 1:1 mapping for debugging */
	.rept 0xA00
	FL_SECTION_ENTRY __base, 3, 0, 0, 0
	.set __base, __base + 1
	.endr

	/* access is not allowed. */
	.rept 0xC00 - 0xA00
	.word 0x00000000
	.endr

	/* 256MB for SDRAM 0xC0000000 -> 0x20000000 */
	.set __base, 0x200
	.rept 0xD00 - 0xC00
	FL_SECTION_ENTRY __base, 3, 0, 1, 1
	.set __base, __base + 1
	.endr

	.set __base, 0xD00
	.rept 0x1000 - 0xD00
	FL_SECTION_ENTRY __base, 3, 0, 0, 0
	.set __base, __base + 1
	.endr

	/* access is not allowed. */
	//.rept 0x1000 - 0xD00
	//.word 0x00000000
	//.endr
#endif
