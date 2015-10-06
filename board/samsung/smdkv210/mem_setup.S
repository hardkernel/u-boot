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

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:

#ifndef CONFIG_EVT1

	ldr     r0, =ASYNC_MSYS_DMC0_BASE

	ldr     r1, =0x0
	str     r1, [r0, #0x0]

	/* This register is removed at EVT1 of C110. */
	ldr     r1, =0x0
	str     r1, [r0, #0xC]

#endif

#ifdef CONFIG_MCP_SINGLE

	/* DMC0 Drive Strength (Setting 2X) */
	
	ldr	r0, =ELFIN_GPIO_BASE

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_0DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_1DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_2DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_3DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_4DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_5DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_6DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP1_7DRV_SR_OFFSET]

	ldr	r1, =0x00002AAA
	str	r1, [r0, #MP1_8DRV_SR_OFFSET]


	/* DMC1 Drive Strength (Setting 2X) */
	
	ldr	r0, =ELFIN_GPIO_BASE
	
	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_0DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_1DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_2DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_3DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_4DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_5DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_6DRV_SR_OFFSET]

	ldr	r1, =0x0000AAAA
	str	r1, [r0, #MP2_7DRV_SR_OFFSET]

	ldr	r1, =0x00002AAA
	str	r1, [r0, #MP2_8DRV_SR_OFFSET]
	
	/* DMC0 initialization at single Type*/
	ldr	r0, =APB_DMC_0_BASE

	ldr	r1, =0x00101000				@PhyControl0 DLL parameter setting, manual 0x00101000
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000086				@PhyControl1 DLL parameter setting, LPDDR/LPDDR2 Case
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00101002				@PhyControl0 DLL on
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00101003				@PhyControl0 DLL start
	str	r1, [r0, #DMC_PHYCONTROL0]

find_lock_val:
	ldr	r1, [r0, #DMC_PHYSTATUS]		@Load Phystatus register value
	and	r2, r1, #0x7
	teq	r2, #0x7				@Loop until DLL is locked
	bne	find_lock_val
	
	and	r1, #0x3fc0 
	mov	r2, r1, LSL #18
	orr	r2, r2, #0x100000
	orr	r2, r2, #0x1000	
		
	orr	r1, r2, #0x3				@Force Value locking
	str	r1, [r0, #DMC_PHYCONTROL0]

#if 1	/* Memory margin test 10.01.05 */
	orr	r1, r2, #0x1				@DLL off
	str	r1, [r0, #DMC_PHYCONTROL0]
#endif
	/* setting DDR2 */
	ldr	r1, =0x0FFF1010				@ConControl auto refresh off
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00212400				@MemControl BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
	str	r1, [r0, #DMC_MEMCONTROL]
	
	ldr	r1, =DMC0_MEMCONFIG_0			@MemConfig0 256MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =DMC0_MEMCONFIG_1			@MemConfig1
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0xFF000000				@PrechConfig
	str	r1, [r0, #DMC_PRECHCONFIG]
	
	ldr	r1, =DMC0_TIMINGA_REF			@TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4E)
	str	r1, [r0, #DMC_TIMINGAREF]
	
	ldr	r1, =DMC0_TIMING_ROW			@TimingRow	for @200MHz
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =DMC0_TIMING_DATA			@TimingData	CL=3
	str	r1, [r0, #DMC_TIMINGDATA]
	
	ldr	r1, =DMC0_TIMING_PWR			@TimingPower
	str	r1, [r0, #DMC_TIMINGPOWER]

	ldr	r1, =0x07000000				@DirectCmd	chip0 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x01000000				@DirectCmd	chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00020000				@DirectCmd	chip0 EMRS2
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00030000				@DirectCmd	chip0 EMRS3
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00010400				@DirectCmd	chip0 EMRS1 (MEM DLL on, DQS# disable)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000542				@DirectCmd	chip0 MRS (MEM DLL reset) CL=4, BL=4
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01000000				@DirectCmd	chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@DirectCmd	chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@DirectCmd	chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000442				@DirectCmd	chip0 MRS (MEM DLL unreset)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00010780				@DirectCmd	chip0 EMRS1 (OCD default)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00010400				@DirectCmd	chip0 EMRS1 (OCD exit)
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x07100000				@DirectCmd	chip1 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01100000				@DirectCmd	chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x00120000				@DirectCmd	chip1 EMRS2
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x00130000				@DirectCmd	chip1 EMRS3
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x00110400				@DirectCmd	chip1 EMRS1 (MEM DLL on, DQS# disable)
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x00100542				@DirectCmd	chip1 MRS (MEM DLL reset) CL=4, BL=4
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x01100000				@DirectCmd	chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x05100000				@DirectCmd	chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x05100000				@DirectCmd	chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x00100442				@DirectCmd	chip1 MRS (MEM DLL unreset)
	str	r1, [r0, #DMC_DIRECTCMD]
	
	ldr	r1, =0x00110780				@DirectCmd	chip1 EMRS1 (OCD default)
	str	r1, [r0, #DMC_DIRECTCMD]
		
	ldr	r1, =0x00110400				@DirectCmd	chip1 EMRS1 (OCD exit)
	str	r1, [r0, #DMC_DIRECTCMD]
		
	ldr	r1, =0x0FF01030				@ConControl	auto refresh on
	str	r1, [r0, #DMC_CONCONTROL]
		
	ldr	r1, =0xFFFF00FF				@PwrdnConfig
	str	r1, [r0, #DMC_PWRDNCONFIG]
		
	ldr	r1, =0x00202400				@MemControl	BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
	str	r1, [r0, #DMC_MEMCONTROL]

	/* DMC1 initialization */
	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0x00101000				@Phycontrol0 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000086				@Phycontrol1 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00101002				@PhyControl0 DLL on
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00101003				@PhyControl0 DLL start
	str	r1, [r0, #DMC_PHYCONTROL0]
find_lock_val1:
	ldr	r1, [r0, #DMC_PHYSTATUS]		@Load Phystatus register value
	and	r2, r1, #0x7
	cmp	r2, #0x7				@Loop until DLL is locked
	bne	find_lock_val1
	
	and	r1, #0x3fc0 
	mov	r2, r1, LSL #18
	add	r2, r2, #0x100000
	orr	r2, r2, #0x1000
		
	orr	r1, r2, #0x3				@Force Value locking
	str	r1, [r0, #DMC_PHYCONTROL0]

#if 1	/* Memory margin test 10.01.05 */
	orr	r1, r2, #0x1				@DLL off
	str	r1, [r0, #DMC_PHYCONTROL0]
#endif

	/* settinf fot DDR2 */
	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0x0FFF1010				@auto refresh off
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =DMC1_MEMCONTROL			@MemControl	BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =DMC1_MEMCONFIG_0			@MemConfig0	512MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =DMC1_MEMCONFIG_1			@MemConfig1
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0xFF000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =DMC1_TIMINGA_REF			@TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4
	str	r1, [r0, #DMC_TIMINGAREF]

	ldr	r1, =DMC1_TIMING_ROW			@TimingRow	for @200MHz
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =DMC1_TIMING_DATA			@TimingData	CL=3
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =DMC1_TIMING_PWR			@TimingPower
	str	r1, [r0, #DMC_TIMINGPOWER]


	ldr	r1, =0x07000000				@DirectCmd	chip0 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01000000				@DirectCmd	chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00020000				@DirectCmd	chip0 EMRS2
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00030000				@DirectCmd	chip0 EMRS3
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00010400				@DirectCmd	chip0 EMRS1 (MEM DLL on, DQS# disable)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000542				@DirectCmd	chip0 MRS (MEM DLL reset) CL=4, BL=4
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01000000				@DirectCmd	chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@DirectCmd	chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@DirectCmd	chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000442				@DirectCmd	chip0 MRS (MEM DLL unreset)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00010780				@DirectCmd	chip0 EMRS1 (OCD default)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00010400				@DirectCmd	chip0 EMRS1 (OCD exit)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x07100000				@DirectCmd	chip1 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01100000				@DirectCmd	chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00120000				@DirectCmd	chip1 EMRS2
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00130000				@DirectCmd	chip1 EMRS3
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00110440				@DirectCmd	chip1 EMRS1 (MEM DLL on, DQS# disable)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00100542				@DirectCmd	chip1 MRS (MEM DLL reset) CL=4, BL=4
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01100000				@DirectCmd	chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@DirectCmd	chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@DirectCmd	chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00100442				@DirectCmd	chip1 MRS (MEM DLL unreset)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00110780				@DirectCmd	chip1 EMRS1 (OCD default)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00110400				@DirectCmd	chip1 EMRS1 (OCD exit)
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x0FF01030				@ConControl	auto refresh on
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0xFFFF00FF				@PwrdnConfig	
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =DMC1_MEMCONTROL			@MemControl	BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
	str	r1, [r0, #DMC_MEMCONTROL]
	
#else	/* End of CONFIG_MCP_SINGLE */

	/* DMC0 initialization */
	ldr	r0, =APB_DMC_0_BASE

	ldr	r1, =0x00101000				@Phycontrol0 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000084				@Phycontrol1 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00101002				@Phycontrol2 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00101003				@Dll on
	str	r1, [r0, #DMC_PHYCONTROL0]
	
find_lock_val:
	ldr	r1, [r0, #DMC_PHYSTATUS]		@Load Phystatus register value
	and	r2, r1, #0x7
	teq	r2, #0x7				@Loop until DLL is locked
	bne	find_lock_val
	
	and	r1, #0x3fc0 
	mov	r2, r1, LSL #18
	orr	r2, r2, #0x100000
	orr	r2, r2, #0x1000
			
	orr	r1, r2, #0x3				@Force Value locking
	str	r1, [r0, #DMC_PHYCONTROL0]
#if 1 /* DRAM margin test 10.01.06 */
	orr	r1, r2, #0x1				@DLL off
	str	r1, [r0, #DMC_PHYCONTROL0]
#endif
	ldr	r1, =0x02001010				@auto refresh off
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00212100				
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =DMC0_MEMCONFIG_0
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =DMC0_MEMCONFIG_1
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0xff000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =DMC0_TIMINGA_REF
	str	r1, [r0, #DMC_TIMINGAREF]

	ldr	r1, =DMC0_TIMING_ROW			@TimingRow	@133MHz
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =DMC0_TIMING_DATA
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =DMC0_TIMING_PWR			@Timing Power
	str	r1, [r0, #DMC_TIMINGPOWER]

	ldr	r1, =0x07000000				@chip0 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01000000				@chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000032				@chip0 MRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00020020				@chip0 EMRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x07100000				@chip1 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01100000				@chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00100032				@chip1 MRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00120020				@chip1 EMRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x020010B0			@ConControl auto refresh on
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0xFFFF00FF				@PwrdnConfig
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =0x00212113				@MemControl
	str	r1, [r0, #DMC_MEMCONTROL]	

/* DMC1 initialization */
	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0x00101000				@Phycontrol0 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000084				@Phycontrol1 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00101002				@Phycontrol2 DLL parameter setting
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00101003				@Dll on
	str	r1, [r0, #DMC_PHYCONTROL0]

find_lock_val1:
	ldr	r1, [r0, #DMC_PHYSTATUS]		@Load Phystatus register value
	and	r2, r1, #0x7
	teq	r2, #0x7				@Loop until DLL is locked
	bne	find_lock_val1
	
	and	r1, #0x3fc0 
	mov	r2, r1, LSL #18
	orr	r2, r2, #0x100000
	orr	r2, r2, #0x1000
	
	orr	r1, r2, #0x3				@Force Value locking
	str	r1, [r0, #DMC_PHYCONTROL0]

#if 1	/* Memory margin test 10.01.05 */
	orr	r1, r2, #0x1				@DLL off
	str	r1, [r0, #DMC_PHYCONTROL0]
#endif
	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0x02001010				@auto refresh off
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00212100				
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =DMC1_MEMCONFIG_0
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =DMC1_MEMCONFIG_1
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0xff000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =DMC1_TIMINGA_REF
	str	r1, [r0, #DMC_TIMINGAREF]

	ldr	r1, =DMC1_TIMING_ROW			@TimingRow	@133MHz
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =DMC1_TIMING_DATA
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =DMC1_TIMING_PWR			@Timing Power
	str	r1, [r0, #DMC_TIMINGPOWER]

	ldr	r1, =0x07000000				@chip0 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01000000				@chip0 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05000000				@chip0 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00000032				@chip0 MRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00020020				@chip0 EMRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x07100000				@chip1 Deselect
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x01100000				@chip1 PALL
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x05100000				@chip1 REFA
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00100032				@chip1 MRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x00120020				@chip1 EMRS
	str	r1, [r0, #DMC_DIRECTCMD]

	ldr	r1, =0x020010B0				@ConControl auto refresh on
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0xFFFF00FF				@PwrdnConfig
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =0x00212113				@MemControl
	str	r1, [r0, #DMC_MEMCONTROL]

#endif	/* CONFIG_MCP_AC / CONFIG_MCP_H / CONFIG_MCP_B / CONFIG_MCP_D */

	mov	pc, lr


/* Below code is for ARM926EJS and ARM1026EJS */
	.globl cleanDCache
cleanDCache:
	mrc	p15, 0, pc, c7, c10, 3	/* test/clean D-Cache */
	bne	cleanDCache
	mov	pc, lr

	.globl cleanFlushDCache
cleanFlushDCache:
	mrc	p15, 0, pc, c7, c14, 3	/* test/cleanflush D-Cache */
	bne	cleanFlushDCache
	mov	pc, lr

	.globl cleanFlushCache
cleanFlushCache:
	mrc	p15, 0, pc, c7, c14, 3	/* test/cleanflush D-Cache */
	bne	cleanFlushCache
	mcr	p15, 0, r0, c7, c5, 0	/* flush I-Cache */
	mov	pc, lr

	.ltorg

