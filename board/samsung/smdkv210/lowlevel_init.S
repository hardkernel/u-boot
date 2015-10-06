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

	.globl cache_init
cache_init:
	mov	ip, lr			@ persevere link reg across call

	bl	disable_l2cache

	bl	set_l2cache_auxctrl_cycle

	bl	enable_l2cache
	
	mov	lr, ip			@ restore link
	mov pc, lr

	.align 5
.global arm_cache_flush
arm_cache_flush:
       mcr     p15, 0, r1, c7, c5, 0           @ invalidate I cache
       mov     pc, lr                          @ back to caller

/*
 *     v7_flush_dcache_all()
 *
 *     Flush the whole D-cache.
 *
 *     Corrupted registers: r0-r5, r7, r9-r11
 *
 *     - mm    - mm_struct describing address space
 */
       .align 5
.global v7_flush_dcache_all
v7_flush_dcache_all:

	ldr	r0, =0xffffffff
	mrc	p15, 1, r0, c0, c0, 1 		@ Read CLIDR
	ands	r3, r0, #0x7000000
	mov	r3, r3, LSR #23       		@ Cache level value (naturally aligned)
	beq 	Finished
	mov	r10, #0
Loop1:         
	add	r2, r10, r10, LSR #1  		@ Work out 3xcachelevel
	mov	r1, r0, LSR r2        		@ bottom 3 bits are the Ctype for this level
	and	r1, r1, #7            		@ get those 3 bits alone
	cmp	r1, #2
	blt	Skip                   		@ no cache or only instruction cache at this level
	mcr	p15, 2, r10, c0, c0, 0 		@ write the Cache Size selection register
	mov	r1, #0
	mcr	p15, 0, r1, c7, c5, 4 		@ PrefetchFlush to sync the change to the CacheSizeID reg
	mrc	p15, 1, r1, c0, c0, 0 		@ reads current Cache Size ID register
	and	r2, r1, #0x7           		@ extract the line length field
	add	r2, r2, #4            		@ add 4 for the line length offset (log2 16 bytes)
	ldr	r4, =0x3FF
	ands	r4, r4, r1, LSR #3   		@ R4 is the max number on the way size (right aligned)
	clz	r5, r4                		@ R5 is the bit position of the way size increment
	ldr	r7, =0x00007FFF
	ands	r7, r7, r1, LSR #13  		@ R7 is the max number of the index size (right aligned)
Loop2:         
	mov	r9, r4                      	@ R9 working copy of the max way size (right aligned)
Loop3:         
	orr	r11, r10, r9, LSL r5        	@ factor in the way number and cache number into R11
	orr	r11, r11, r7, LSL r2        	@ factor in the index number
	mcr	p15, 0, r11, c7, c6, 2 		@ invalidate by set/way
	subs	r9, r9, #1                 	@ decrement the way number
	bge	Loop3
	subs	r7, r7, #1                 	@ decrement the index
	bge	Loop2
Skip:          
	add	r10, r10, #2                	@ increment the cache number
	cmp	r3, r10
	bgt	Loop1
Finished:
	mov	pc, lr
	
       .align  5
.global disable_l2cache
disable_l2cache:
	mrc     p15, 0, r0, c1, c0, 1
	bic     r0, r0, #(1<<1)
	mcr     p15, 0, r0, c1, c0, 1
	mov	pc, lr


       .align  5
.global enable_l2cache
enable_l2cache:
	mrc     p15, 0, r0, c1, c0, 1
	orr     r0, r0, #(1<<1)
	mcr     p15, 0, r0, c1, c0, 1
	mov     pc, lr

       .align  5
.global set_l2cache_auxctrl
set_l2cache_auxctrl:
	mov	r0, #0x0
	mcr     p15, 1, r0, c9, c0, 2
	mov     pc, lr

       .align  5
.global set_l2cache_auxctrl_cycle
set_l2cache_auxctrl_cycle:
	mrc 	p15, 1, r0, c9, c0, 2
	bic 	r0, r0, #(0x1<<29)
	bic 	r0, r0, #(0x1<<21)
	bic 	r0, r0, #(0x7<<6)
	bic 	r0, r0, #(0x7<<0)
	mcr 	p15, 1, r0, c9, c0, 2
	mov     pc,lr

	.align 5
CoInvalidateDCacheIndex:
	;/* r0 = index */
	mcr     p15, 0, r0, c7, c6, 2
	mov     pc,lr

 
	.globl lowlevel_init
lowlevel_init:

	bl read_om

	ldr	sp, =0xd0036000 /* end of sram dedicated to u-boot */
	sub	sp, sp, #12	/* set stack */
	mov	fp, #0

	/* check reset status  */
	ldr     r0, =(ELFIN_CLOCK_POWER_BASE+RST_STAT_OFFSET)
	ldr     r1, [r0]
	/* Sleep wakeup reset */
	tst	r1, #(0x1<<16)
	bne	wakeup_reset_pre
	/* Deepidle wakeup reset */
	tst	r1, #(0x1<<19)
	bne	wakeup_reset_from_didle

	/* IO Retention release */
	ldr	r0, =(ELFIN_CLOCK_POWER_BASE + OTHERS_OFFSET)
	ldr	r1, [r0]
	ldr	r2, =IO_RET_REL
	orr	r1, r1, r2
	str	r1, [r0]

	/* PS_HOLD pin(GPH0_0) set to high */
	ldr	r0, =(ELFIN_CLOCK_POWER_BASE + PS_HOLD_CONTROL_OFFSET)
	ldr	r1, [r0]
	orr	r1, r1, #0x300	
	orr	r1, r1, #0x1	
	str	r1, [r0]
	
	/* when we already run in ram, we don't need to relocate U-Boot.
	 * and actually, memory controller must be configured before U-Boot
	 * is running in ram.
	 */
	ldr	r0, =0xff000fff
	bic	r1, pc, r0		/* r0 <- current base addr of code */
	ldr	r2, _TEXT_BASE		/* r1 <- original base addr in ram */
	bic	r2, r2, r0		/* r0 <- current base addr of code */
	cmp     r1, r2                  /* compare r0, r1                  */
	beq     1f			/* r0 == r1 then skip sdram init   */

	/* init system clock */
	bl system_clock_init

	/* Internal voltage set 1.1V */
	bl pmic_init

	/* Memory initialize */
	bl mem_ctrl_asm_init
	
1:
	/* for UART */
	bl uart_asm_init

	bl tzpc_init

	/* ABB disable */
	ldr	r0, =0xE010C300
	mov	r1, #0x800000
	str	r1, [r0]

	/* Print 'K' */
	ldr	r0, =ELFIN_UART_CONSOLE_BASE
	ldr	r1, =0x4b4b4b4b
	str	r1, [r0, #UTXH_OFFSET]

	bl load_uboot

#ifdef CONFIG_ENABLE_MMU
	bl enable_mmu
#endif

	ldr r0, _board_init_f
	mov pc, r0
	
_board_init_f:
	.word board_init_f


read_om:
	/* Read booting information */
	ldr	r0, =PRO_ID_BASE
	ldr	r1, [r0,#OMR_OFFSET]
	bic	r2, r1, #0xffffffc1

#ifdef CONFIG_VOGUES
	/* PS_HOLD(GPH0_0) set to output high */
	ldr	r0, =ELFIN_GPIO_BASE
	ldr	r1, =0x00000001
	str	r1, [r0, #GPH0CON_OFFSET]

	ldr	r1, =0x5500
	str	r1, [r0, #GPH0PUD_OFFSET]

	ldr	r1, =0x01
	str	r1, [r0, #GPH0DAT_OFFSET]
#endif

	/* NAND BOOT */
	cmp	r2, #0x0		@ 512B 4-cycle
	moveq	r3, #BOOT_NAND

	cmp	r2, #0x2		@ 2KB 5-cycle
	moveq	r3, #BOOT_NAND

	cmp	r2, #0x4		@ 4KB 5-cycle	8-bit ECC
	moveq	r3, #BOOT_NAND

	cmp	r2, #0x6		@ 4KB 5-cycle	16-bit ECC
	moveq	r3, #BOOT_NAND

	cmp	r2, #0x8		@ OneNAND Mux
	moveq	r3, #BOOT_ONENAND

	/* SD/MMC BOOT */
	cmp     r2, #0xC
	moveq   r3, #BOOT_MMCSD	

	/* eMMC BOOT */
	cmp     r2, #0xE
	moveq   r3, #BOOT_EMMC

	/* NOR BOOT */
	cmp     r2, #0x14
	moveq   r3, #BOOT_NOR	

#if 0	/* Android C110 BSP uses OneNAND booting! */
	/* For second device booting */
	/* OneNAND BOOTING failed */
	cmp     r2, #0x8
	moveq   r3, #BOOT_SEC_DEV
#endif

	/* Uart BOOTING failed */
	cmp     r2, #(0x1<<4)
	moveq   r3, #BOOT_SEC_DEV

	ldr	r0, =INF_REG_BASE
	str	r3, [r0, #INF_REG3_OFFSET]  

	mov	pc, lr

load_uboot:
	push {lr}
	
	/* when we already run in ram, we don't need to relocate U-Boot.
	 * and actually, memory controller must be configured before U-Boot
	 * is running in ram.
	 */
	ldr	r0, =0xff000fff
	bic	r1, pc, r0		/* r0 <- current base addr of code */
	ldr	r2, _TEXT_BASE		/* r1 <- original base addr in ram */
	bic	r2, r2, r0		/* r0 <- current base addr of code */
	cmp     r1, r2                  /* compare r0, r1                  */
	beq     after_copy		/* r0 == r1 then skip flash copy   */

#if defined(CONFIG_EVT1)
	/* If BL1 was copied from SD/MMC CH2 */
	ldr	r0, =0xD0037488
	ldr	r1, [r0]
	ldr	r2, =0xEB200000
	cmp	r1, r2
	beq     mmcsd_boot
#endif

	ldr	r0, =INF_REG_BASE
	ldr	r1, [r0, #INF_REG3_OFFSET]
	cmp	r1, #BOOT_NAND		/* 0x0 => boot device is nand */
	beq	nand_boot
	cmp	r1, #BOOT_ONENAND	/* 0x1 => boot device is onenand */
	beq	onenand_boot
	cmp     r1, #BOOT_MMCSD
	beq     mmcsd_boot
	cmp     r1, #BOOT_EMMC
	beq     emmc_boot
	cmp     r1, #BOOT_NOR
	beq     nor_boot
	cmp     r1, #BOOT_SEC_DEV
	beq     mmcsd_boot

nand_boot:
@	mov	r0, #0x1000
@	bl	copy_from_nand
	b	after_copy

onenand_boot:
	bl	onenand_bl2_copy
	b	after_copy

mmcsd_boot:
	bl      movi_bl2_copy
	b       after_copy

emmc_boot:
	bl      emmc_bl2_copy
	b       after_copy

nor_boot:
@	bl      read_hword
	b       after_copy

after_copy:
	pop {pc}

wakeup_reset_from_didle:
	/* Wait when APLL is locked */
	ldr	r0, =ELFIN_CLOCK_POWER_BASE
lockloop:
	ldr	r1, [r0, #APLL_CON0_OFFSET]
	tst	r1, #(1<<29)
	beq 	lockloop
	b	exit_wakeup

wakeup_reset_pre:
	mrc	p15, 0, r1, c1, c0, 1	@Read CP15 Auxiliary control register
	tst	r1, #(0x1<<31)		@Check L2RD is disable or not
	beq	wakeup_reset		@if L2RD is not disable jump to wakeup_reset 
	
	bl	disable_l2cache
	bl	v7_flush_dcache_all
	bl	enable_l2cache

wakeup_reset:
	/* init system clock */
	bl system_clock_init
	bl mem_ctrl_asm_init
	bl tzpc_init

exit_wakeup:
	/*Load return address and jump to kernel*/
	ldr	r0, =(INF_REG_BASE+INF_REG0_OFFSET)
	ldr	r1, [r0]	/* r1 = physical address of s5pc110_cpu_resume function*/

	mov	pc, r1		/*Jump to kernel */
	nop
	nop

/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */
system_clock_init:
	push	{lr}
	
	ldr	r0, =ELFIN_CLOCK_POWER_BASE	@0xe0100000

	/* Set OSC_FREQ value */
	ldr	r1, =0xF
	ldr	r2, =OSC_FREQ_OFFSET
	str	r1, [r0, r2]

	/* Set MTC_STABLE value */
	ldr	r1, =0xFFFFFFFF
	ldr	r2, =MTC_STABLE_OFFSET
	str	r1, [r0, r2]

	/* Set CLAMP_STABLE value */
	ldr	r1, =0x3FF03FF
	ldr	r2, =CLAMP_STABLE_OFFSET
	str	r1, [r0, r2]

	/* Set APLL lock value */
	ldr	r1, =0x2CF
	str	r1, [r0, #APLL_LOCK_OFFSET]
	
	/* Set Mux APLL to FINPLL */
	ldr	r1, [r0, #CLK_SRC0_OFFSET]
	bic	r1, r1, #0x1
	str	r1, [r0, #CLK_SRC0_OFFSET]

	/* Check source change state */
	bl	wait_mux_state0

	/* Clean divider0 value */
	ldr   	r1, [r0, #CLK_DIV0_OFFSET]
	ldr	r2, =0x7F7F7777
	bic	r1, r1, r2
	ldr	r2, =CLK_DIV0_VAL
	orr	r1, r1, r2
	str	r1, [r0, #CLK_DIV0_OFFSET]

#if defined(CONFIG_EVT1)
	ldr	r1, =AFC_ON
	str	r1, [r0, #APLL_CON1_OFFSET]
#endif

	ldr	r1, =APLL_VAL
	str	r1, [r0, #APLL_CON0_OFFSET]

	ldr	r1, =VPLL_VAL
	str	r1, [r0, #VPLL_CON_OFFSET]
	/* Wait until the APLL is locked */
wait_lock_apll:
	ldr	r1, =(ELFIN_CLOCK_POWER_BASE + APLL_CON0_OFFSET)
        ldr     r2, [r1]
	tst	r2, #(0x1<<29)
	beq	wait_lock_apll
	
	/* Check devider change state */
wait_div_state0:
	ldr	r1, =(ELFIN_CLOCK_POWER_BASE + CLK_DIV_STAT0_OFFSET)
        ldr     r2, [r1]
	tst	r2, #0xFF
	bne	wait_div_state0

	/* Change CLK source */
	ldr	r1, [r0, #CLK_SRC0_OFFSET]
	orr	r1, r1, #0x1
	str	r1, [r0, #CLK_SRC0_OFFSET]

	/* Check source change state */
	bl	wait_mux_state0


#if defined(CONFIG_MCP_AC) || defined(CONFIG_MCP_B) || defined(CONFIG_MCP_D)

	/* CLK_DIV6[31:28] -> 4=1/5, 3=1/4(166MHZ@667MHz), 2=1/3 */
	ldr	r1, [r0, #CLK_DIV6_OFFSET]
	bic	r1, r1, #(0xF<<28)
	bic	r1, r1, #(0x7<<12)
	orr	r1, r1, #(0x3<<28)
	str	r1, [r0, #CLK_DIV6_OFFSET]
	
	/* Check devider change state */
	bl	wait_div_state1

	/* CLK_SRC6[25:24] -> OneDRAM clock sel = MPLL */
	ldr	r1, [r0, #CLK_SRC6_OFFSET]
	bic	r1, r1, #(0x3<<24)
	orr	r1, r1, #(0x1<<24)
	str	r1, [r0, #CLK_SRC6_OFFSET]

	/* Check source change state */
	bl	wait_mux_state1

#elif defined (CONFIG_MCP_H)

	/* CLK_DIV6[31:28] -> 4=1/5, 3=1/4(166MHZ@667MHz), 2=1/3 */
	ldr	r1, [r0, #CLK_DIV6_OFFSET]
	bic	r1, r1, #(0xF<<28)
	bic	r1, r1, #(0x7<<12)
	str	r1, [r0, #CLK_DIV6_OFFSET]	

	/* Check devider change state */
	bl	wait_div_state1
	
	/* CLK_SRC6[25:24] -> OneDRAM clock sel = 00:SCLKA2M, 01:SCLKMPLL */
	ldr	r1, [r0, #CLK_SRC6_OFFSET]
	bic	r1, r1, #(0x3<<24)
	str	r1, [r0, #CLK_SRC6_OFFSET]

	/* Check source change state */
	bl	wait_mux_state1
#endif	
	pop	{pc}

/*
 *	Check clock until stable.
 */
	
	/* Check devider change state */
wait_div_state1:
	ldr	r1, =(ELFIN_CLOCK_POWER_BASE + CLK_DIV_STAT1_OFFSET)
        ldr     r2, [r1]
	tst	r2, #(0x1<<15)
	bne	wait_div_state1
	mov	pc, lr
	
	/* Check source change state */
wait_mux_state1:
	ldr	r1, =(ELFIN_CLOCK_POWER_BASE + CLK_MUX_STAT1_OFFSET)
        ldr     r2, [r1]
	tst	r2, #(0x1<<31)
	bne	wait_mux_state1
	mov	pc, lr
	
	/* Check source change state */
wait_mux_state0:
	ldr	r1, =(ELFIN_CLOCK_POWER_BASE + CLK_MUX_STAT0_OFFSET)
        ldr     r2, [r1]
	tst	r2, #(0x4)
	bne	wait_mux_state0
	mov	pc, lr


/*
 * uart_asm_init: Initialize UART in asm mode, 115200bps fixed.
 * void uart_asm_init(void)
 */
uart_asm_init:

	/* set GPIO(GPA) to enable UART */
	@ GPIO setting for UART
	ldr	r0, =ELFIN_GPIO_BASE
	ldr	r1, =0x22222222
	str   	r1, [r0, #GPA0CON_OFFSET]

	ldr     r1, =0x2222
	str     r1, [r0, #GPA1CON_OFFSET]

	// HP V210 use. SMDK not use.
#if defined(CONFIG_VOGUES)
	mov    r1, #(0x1<<8)
	str    r1, [r0, #GPC0CON_OFFSET]

	mov    r1, #0x4
	str    r1, [r0, #GPC0DAT_OFFSET]
#endif

	ldr	r0, =ELFIN_UART_CONSOLE_BASE		@0xEC000000
	mov	r1, #0x0
	str	r1, [r0, #UFCON_OFFSET]
	str	r1, [r0, #UMCON_OFFSET]

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

 	ldr 	r0, =ELFIN_TZPC1_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET] 	

 	ldr	r0, =ELFIN_TZPC2_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT3SET_OFFSET] 

 	ldr	r0, =ELFIN_TZPC3_BASE
 	str	r1, [r0, #TZPC_DECPROT0SET_OFFSET]
 	str	r1, [r0, #TZPC_DECPROT1SET_OFFSET]
	str	r1, [r0, #TZPC_DECPROT2SET_OFFSET] 	

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


	#ifdef CONFIG_MCP_SINGLE
/*
 * MMU Table for SMDKC110
 * 0x0000_0000 -- 0xBFFF_FFFF => Not Allowed
 * 0xB000_0000 -- 0xB7FF_FFFF => A:0xB000_0000 -- 0xB7FF_FFFF
 * 0xC000_0000 -- 0xC7FF_FFFF => A:0x3000_0000 -- 0x37FF_FFFF
 * 0xC800_0000 -- 0xDFFF_FFFF => Not Allowed
 * 0xE000_0000 -- 0xFFFF_FFFF => A:0xE000_0000 -- 0XFFFF_FFFF
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
	.rept 0x100
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

	// Not Allowed
	.rept 0x200 - 0x100
	.word 0x00000000
	.endr

	.set __base,0x200
	// should be accessed
	.rept 0x600 - 0x200
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	.rept 0x800 - 0x600
	.word 0x00000000
	.endr

	.set __base,0x800
	// should be accessed
	.rept 0xb00 - 0x800
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

/*	.rept 0xc00 - 0xb00
	.word 0x00000000
	.endr */

	.set __base,0xB00
	.rept 0xc00 - 0xb00
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

	.set __base,0x200
	// 256MB for SDRAM with cacheable
	.rept 0xD00 - 0xC00
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	// access is not allowed.
	@.rept 0xD00 - 0xC80
	@.word 0x00000000
	@.endr

	.set __base,0xD00
	// 1:1 mapping for debugging with non-cacheable
	.rept 0x1000 - 0xD00
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr	
	
	#else	// CONFIG_MCP_AC, CONFIG_MCP_H, CONFIG_MCP_B

/*
 * MMU Table for SMDKC110
 * 0x0000_0000 -- 0xBFFF_FFFF => Not Allowed
 * 0xB000_0000 -- 0xB7FF_FFFF => A:0xB000_0000 -- 0xB7FF_FFFF
 * 0xC000_0000 -- 0xC7FF_FFFF => A:0x3000_0000 -- 0x37FF_FFFF
 * 0xC800_0000 -- 0xDFFF_FFFF => Not Allowed
 * 0xE000_0000 -- 0xFFFF_FFFF => A:0xE000_0000 -- 0XFFFF_FFFF
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
	.rept 0x100
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

	// Not Allowed
	.rept 0x300 - 0x100
	.word 0x00000000
	.endr

#if defined(CONFIG_MCP_N)
	.set __base,0x300
	// should be accessed
	.rept 0x400 - 0x300
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr
#else
	.set __base,0x300
	// should be accessed
	.rept 0x350 - 0x300
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	// Not Allowed
	.rept 0x400 - 0x350
	.word 0x00000000
	.endr
#endif

	.set __base,0x400
	// should be accessed
	.rept 0x500 - 0x400
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	.rept 0x800 - 0x500
	.word 0x00000000
	.endr

	.set __base,0x800
	// should be accessed
	.rept 0xb00 - 0x800
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

	.set __base,0xB00
	.rept 0xc00 - 0xb00
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr

#if defined(CONFIG_MCP_N)
	.set __base,0x300
	// 256MB for SDRAM with cacheable
	.rept 0xD00 - 0xC00
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr
#else
	.set __base,0x300
	// 80MB for SDRAM with cacheable
	.rept 0xC50 - 0xC00
	FL_SECTION_ENTRY __base,3,0,1,1
	.set __base,__base+1
	.endr

	// Not Allowed
	.rept 0xD00 - 0xC50
	.word 0x00000000
	.endr
#endif

	.set __base,0xD00
	// 1:1 mapping for debugging with non-cacheable
	.rept 0x1000 - 0xD00
	FL_SECTION_ENTRY __base,3,0,0,0
	.set __base,__base+1
	.endr
	#endif
#endif

