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
#include "smdkv310_val.h"
#include <asm/arch/s5p_nand.h>

_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

	.globl cache_init
cache_init:
	mov pc, lr

	.globl lowlevel_init
lowlevel_init:

	/* use iROM stack in bl2 */
	ldr	sp, =0x02040000
	push {lr}

	/* check reset status  */
	ldr     r0, =(INF_REG_BASE + INF_REG1_OFFSET)
	ldr     r1, [r0]

	/* Sleep wakeup reset */
	ldr	r2, =S5P_CHECK_SLEEP
	cmp	r1, r2
	beq	wakeup_reset

	/* During sleep/wakeup or AFTR mode, pmic_init function is not available 
	 * and it causes delays. So except for sleep/wakeup and AFTR mode, 
	 * the below function is needed 
	 */
	bl pmic_init

	bl uart_asm_init
	
#if defined(CONFIG_ONENAND)
	bl onenandcon_init
#endif
	
#if defined(NAND_BOOTING)
	bl nand_asm_init
#endif

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
	bl mem_ctrl_asm_init

1:

#ifdef CONFIG_EVT1
	/* store DMC density information in DRAM */
	ldr r0, =CONFIG_PHY_UBOOT_BASE
	sub r0, r0, #4
	str r6, [r0]
#endif

	bl tzpc_init

	b load_uboot

after_copy:


#ifdef CONFIG_ENABLE_MMU
	bl enable_mmu
#endif

#ifdef CONFIG_EVT1
	/* store DMC density information in u-boot C level variable */
	ldr r0, =CONFIG_PHY_UBOOT_BASE
	sub r0, r0, #4
	ldr r1, [r0]
	ldr r0, _dmc_density
	str r1, [r0]
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

#ifdef CONFIG_EVT1
_dmc_density:
	.word dmc_density
#endif
_second_boot_info:
	.word second_boot_info


wakeup_reset:

	bl read_om

#if defined(CONFIG_EVT1)
	/* If eMMC booting */
	ldr	r0, =INF_REG_BASE
	ldr	r1, [r0, #INF_REG3_OFFSET]
	cmp	r1, #BOOT_EMMC_4_4
	bleq	emmc_4_4_endbootOp_eMMC
#endif
	/* check reset status  */
	ldr     r0, =(INF_REG_BASE + INF_REG1_OFFSET)
	ldr     r1, [r0]

	/* If NOT Sleep wakeup reset */
	ldr	r2, =S5P_CHECK_SLEEP
	cmp	r1, r2
	bne	exit_wakeup

	/* MSHC CLKENA Disable */
	ldr	r0, =0x12550010
	ldr	r1, =0x0
	str   	r1, [r0]

	ldr	r0, =0x1255002C
	ldr	r1, =(1<<31|1<<21|1<<13);
	str   	r1, [r0]

	ldr	r0, =CHIP_ID_BASE
	ldr	r1, [r0]
	lsr	r1, r1, #8
	and	r1, r1, #3
	cmp	r1, #2
	bne	wake_v310

	/* init system clock */
	bl	mem_ctrl_asm_init
	bl	system_clock_init

#if defined(CONFIG_EVT1)
	/* If eMMC booting */
	/* mmc ch4 devider value change */
	ldr	r0, =INF_REG_BASE
	ldr	r1, [r0, #INF_REG3_OFFSET]
	cmp	r1, #BOOT_EMMC_4_4
	bleq	mmc_ch4_devider_change
#endif

	bl	tzpc_init
	b	exit_wakeup

wake_v310:
	bl system_clock_init
	bl mem_ctrl_asm_init
	bl tzpc_init

exit_wakeup:

	/*Load return address and jump to kernel*/
	ldr	r0, =(INF_REG_BASE + INF_REG0_OFFSET)
	ldr	r1, [r0]	/* r1 = physical address of s5pc110_cpu_resume function*/

	mov	pc, r1		/*Jump to kernel */
	nop
	nop


read_om:
	/* Read booting information */
	ldr	r0, =S5PV310_POWER_BASE
	ldr	r1, [r0,#OMR_OFFSET]
	bic	r2, r1, #0xffffffc1

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

	/* SD/MMC BOOT */
	cmp     r2, #0x4
	moveq   r3, #BOOT_MMCSD

	/* eMMC BOOT */
	cmp	r2, #0x6
	moveq	r3, #BOOT_EMMC

#if defined(CONFIG_EVT1)
	/* eMMC 4.4 BOOT */
	cmp	r2, #0x8
	moveq	r3, #BOOT_EMMC_4_4
	cmp	r2, #0x28
	moveq	r3, #BOOT_EMMC_4_4
#endif

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

/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */
#define MEM_DLLl_ON

system_clock_init:
	push	{lr}
	
	ldr	r0, =ELFIN_CLOCK_BASE	@0x1003_0000

@ CMU_CPU MUX / DIV
	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
1:	subs	r1, r1, #1
	bne	1b

	ldr	r1, =CLK_DIV_CPU0_VAL
	ldr	r2, =CLK_DIV_CPU0_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_CPU1_VAL
	ldr	r2, =CLK_DIV_CPU1_OFFSET
	str	r1, [r0, r2]

@ CMU_DMC MUX / DIV
#ifdef CONFIG_EVT1
	ldr	r1, =0x10000
#else
	ldr	r1, =CLK_SRC_DMC_VAL
#endif
	ldr	r2, =CLK_SRC_DMC_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
2:	subs	r1, r1, #1
	bne	2b

	ldr	r1, =CLK_DIV_DMC0_VAL
	ldr	r2, =CLK_DIV_DMC0_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =CLK_DIV_DMC1_VAL
	ldr	r2, =CLK_DIV_DMC1_OFFSET
	str	r1, [r0, r2]

@ CMU_TOP MUX / DIV
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

@ CMU_LEFTBUS MUX / DIV
	ldr	r1, =CLK_SRC_LEFTBUS_VAL
	ldr	r2, =CLK_SRC_LEFTBUS_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
4:	subs	r1, r1, #1
	bne	4b

	ldr	r1, =CLK_DIV_LEFRBUS_VAL
	ldr	r2, =CLK_DIV_LEFTBUS_OFFSET
	str	r1, [r0, r2]

@ CMU_RIGHTBUS MUX / DIV
	ldr	r1, =CLK_SRC_RIGHTBUS_VAL
	ldr	r2, =CLK_SRC_RIGHTBUS_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
5:	subs	r1, r1, #1
	bne	5b

	ldr	r1, =CLK_DIV_RIGHTBUS_VAL
	ldr	r2, =CLK_DIV_RIGHTBUS_OFFSET
	str	r1, [r0, r2]

@ Set PLL locktime
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

@ Set PLL P,M,S ON
	ldr	r1, =APLL_CON1_VAL
	ldr	r2, =APLL_CON1_OFFSET
	str	r1, [r0, r2]

@ Set APLL
	ldr	r1, =APLL_CON0_VAL
	ldr	r2, =APLL_CON0_OFFSET
	str	r1, [r0, r2]

@ Set MPLL
	ldr	r1, =MPLL_CON1_VAL
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =MPLL_CON0_VAL
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]

@ Set EPLL
	ldr     r1, =EPLL_CON1_VAL
	ldr     r2, =EPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =EPLL_CON0_VAL
	ldr     r2, =EPLL_CON0_OFFSET
	str     r1, [r0, r2]

@ Set VPLL
	ldr     r1, =VPLL_CON1_VAL
	ldr     r2, =VPLL_CON1_OFFSET
	str     r1, [r0, r2]
	ldr     r1, =VPLL_CON0_VAL
	ldr     r2, =VPLL_CON0_OFFSET
	str     r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x30000
6:	subs	r1, r1, #1
	bne	6b

	ldr	r1, =CLK_SRC_CPU_VAL_MOUTMPLLFOUT
	ldr	r2, =CLK_SRC_CPU_OFFSET
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x10000
7:	subs	r1, r1, #1
	bne	7b

	ldr	r0, =CHIP_ID_BASE
	ldr	r1, [r0]
	lsr r1, r1, #8
	and r1, r1, #3
	cmp r1, #2
	bne v310_2

@ ConControl
#ifdef MEM_DLLl_ON
	ldr	r0, =APB_DMC_0_BASE

#ifdef CONFIG_EVT1
	ldr	r1, =0x6910100A
#else
	ldr	r1, =0x7110100A
#endif
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
#ifdef CONFIG_EVT1
	ldr	r1, =0x6910100B
#else
	ldr	r1, =0x7110100B
#endif
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
8:	subs	r1, r1, #1
	bne	8b

	ldr	r1, =0x0000008C
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
9:	subs	r1, r1, #1
	bne	9b

	ldr	r0, =APB_DMC_1_BASE

#ifdef CONFIG_EVT1
	ldr	r1, =0xe910100A
#else
	ldr	r1, =0x7110100A
#endif
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
#ifdef CONFIG_EVT1
	ldr	r1, =0xe910100B
#else
	ldr	r1, =0x7110100B
#endif
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	/* wait ?us */
	mov	r1, #0x20000
10:	subs	r1, r1, #1
	bne	10b

	ldr	r1, =0x0000008C
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x00000084
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	
	/* wait ?us */
	mov	r1, #0x20000
11:	subs	r1, r1, #1
	bne	11b
#endif

	ldr	r0, =APB_DMC_0_BASE
#ifdef CONFIG_CLK_1000_200_200
	ldr	r1, =0x0FFF30f0
#else
	ldr	r1, =0x0FFF30fa
#endif
	ldr	r2, =DMC_CONCONTROL
	str	r1, [r0, r2]
	ldr	r0, =APB_DMC_1_BASE
#ifdef CONFIG_CLK_1000_200_200
	ldr	r1, =0x0FFF30f0
#else
	ldr	r1, =0x0FFF30fa
#endif
	ldr	r2, =DMC_CONCONTROL
	str	r1, [r0, r2]

	ldr	r0, =APB_DMC_0_BASE
	ldr	r1, =0x00202537
	ldr	r2, =DMC_MEMCONTROL
	str	r1, [r0, r2]
	ldr	r0, =APB_DMC_1_BASE
	ldr	r1, =0x00202537
	ldr	r2, =DMC_MEMCONTROL
	str	r1, [r0, r2]

v310_2:
	pop	{pc}


load_uboot:
	ldr	r0, =INF_REG_BASE
	ldr	r1, [r0, #INF_REG3_OFFSET]
	cmp	r1, #BOOT_NAND
	beq	nand_boot
	cmp	r1, #BOOT_ONENAND
	beq	onenand_boot
	cmp 	r1, #BOOT_MMCSD
	beq 	mmcsd_boot
	cmp	r1, #BOOT_EMMC
	beq	emmc_boot
#if defined(CONFIG_EVT1)
	cmp	r1, #BOOT_EMMC_4_4
	beq	emmc_boot_4_4
#endif
	cmp     r1, #BOOT_NOR
	beq     nor_boot
	cmp     r1, #BOOT_SEC_DEV
	beq     mmcsd_boot

nand_boot:
	mov	r0, #0x1000
	bl	copy_uboot_to_ram
	b	after_copy

onenand_boot:
	bl	onenand_bl2_copy /*goto 0x1010*/
	b	after_copy

mmcsd_boot:
#if defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS2_OFFSET
	ldr	r1, [r0, r2]
	orr r1, r1, #0xf
	str r1, [r0, r2]
#endif
	bl      movi_uboot_copy
	b       after_copy

emmc_boot:
#if defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS1_OFFSET
	ldr	r1, [r0, r2]
	orr 	r1, r1, #0xf
	str 	r1, [r0, r2]
#endif
	bl	emmc_uboot_copy
	b	after_copy

#if defined(CONFIG_EVT1)
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
	blo mmcsd_boot		/* BL1 and BL2 are loaded from emmc 4.4 			     */
						/* Otherwise BL1 and BL2 are loaded from sdmmc ch2.      */
	/* mmc ch4 devider value change */
	bl	mmc_ch4_devider_change
	/* u-boot image copy from boot partition to DRAM. */
	bl	emmc_4_4_uboot_copy
	/* Exit Boot mood */
	bl	emmc_4_4_endbootOp_eMMC
	b	after_copy
#endif

nor_boot:
@	bl      read_hword
	b       after_copy

check_om_setting:
	b check_om_setting

/*
 * OneNAND Interface Init
 */
onenandcon_init:
wait_orwb:

	@; Read ONENAND_IF_STATUS
	ldr	r0, =CFG_ONENANDXL_BASE		@; 0x0C600000
	ldr	r1, [r0, #0x100]		@; ONENAND_IF_STATUS_OFFSET(0x100)
	bic	r1, r1, #0xFFFFFFFE
	cmp	r1, #0x0

	@; ORWB != 0x0
	bne	wait_orwb

	@; write new configuration to onenand system configuration1 register
	ldr	r1, =0xF006			@; Sync.
	ldr	r2, =(CFG_ONENAND_BASE+0x1E442)	@; 0x1E442(REG_SYS_CONF1)
	strh	r1, [r2]

	@; read one dummy halfword
	ldrh	r1, [r2]
	ldrh	r1, [r2]

	@; write new configuration to ONENAND_IF_CTRL
	ldr	r0, =CFG_ONENANDXL_BASE		@; 0x0C600000
	@;ldr	r1, =0x2F006			@; ONENAND_IF_CTRL_REG_VAL (GCE off)
	ldr	r1, =0x402F006			@; ONENAND_IF_CTRL_REG_VAL (GCE on)
	str	r1, [r0, #0x100]		@; ONENAND_IF_STATUS_OFFSET(0x100)

	mov	pc, lr

/*
 * Setting TZPC[TrustZone Protection Controller]
 */

tzpc_init:

	ldr	r0, =ELFIN_TZPC0_BASE
 	mov	r1, #0x0
 	str	r1, [r0]
 	mov	r1, #0xff
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

 	ldr 	r0, =ELFIN_TZPC1_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

 	ldr	r0, =ELFIN_TZPC2_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET] 

 	ldr	r0, =ELFIN_TZPC3_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

 	ldr	r0, =ELFIN_TZPC4_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

 	ldr	r0, =ELFIN_TZPC5_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET]

 	mov	pc, lr
/*
 * MPLL is Changed from 400MHz to 800MHz.
 * So, MMC CH4 devider need to change.
 */

mmc_ch4_devider_change:

#if defined(CONFIG_CLK_1000_400_200) || defined(CONFIG_CLK_1000_200_200) || defined(CONFIG_CLK_800_400_200)
	ldr	r0, =ELFIN_CLOCK_BASE
	ldr	r2, =CLK_DIV_FSYS3_OFFSET
	ldr	r1, [r0, r2]
	bic	r1, r1, #(0xFF << 8)
	bic	r1, r1, #(0xF)
	orr 	r1, r1, #(0x1<< 8)
	orr 	r1, r1, #0x7
	str 	r1, [r0, r2]
#endif
	mov	pc, lr


	
/*
 * Nand Interface Init for SMDKC100
 */
	.globl nand_asm_init
nand_asm_init:

	/* Setting GPIO for NAND */
	/* This setting is NAND initialze code at booting time in iROM. */

	ldr	r0, =0x11000000

        ldr     r1, [r0, #MP01CON_OFFSET]
        bic     r1, r1, #(0xf<<8)
        orr     r1, r1, #(0x3<<8)
        str     r1, [r0, #MP01CON_OFFSET]
	
	ldr	r2, =0x220300
	str	r2, [r0, #MP01CON_OFFSET]

	ldr	r1, [r0, #MP01PUD_OFFSET]
	bic	r1, r1, #(0x3<<4)
	str	r1, [r0, #MP01PUD_OFFSET]

	ldr	r1, [r0, #MP03CON_OFFSET]
	bic	r1, r1, #0xFFFFFF
	ldr	r2, =0x222
	orr	r1, r1, r2
	str	r1, [r0, #MP03CON_OFFSET]

	ldr	r1, [r0, #MP03PUD_OFFSET]
	ldr	r2, =0x3fff
	bic	r1, r1, r2
	str	r1, [r0, #MP03PUD_OFFSET]

	ldr	r0, =ELFIN_NAND_BASE
	ldr	r1, [r0, #NFCONF_OFFSET]
	ldr	r2, =0x7772
	bic	r1, r1, r2
	ldr	r2, =NFCONF_VAL
	orr	r1, r1, r2
	str	r1, [r0, #NFCONF_OFFSET]
	ldr	r1, [r0, #NFCONT_OFFSET]
	ldr	r2, =0x6
	bic	r1, r1, r2
	ldr	r2, =NFCONT_VAL
	orr	r1, r1, r2
	str	r1, [r0, #NFCONT_OFFSET]
        ldr     r1, [r0, #MP01CON_OFFSET]
        bic     r1, r1, #(0xf<<8)
        orr     r1, r1, #(0x3<<8)
        str     r1, [r0, #MP01CON_OFFSET]
	mov	pc, lr


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


