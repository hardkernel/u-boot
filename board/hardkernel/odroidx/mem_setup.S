/*
 * Memory setup for ODROID-X board based on EXYNOS4412
 *
 * Copyright (C) 2013  Hardkernel Co.,LTD.
 * Hakjoo Kim <ruppi.kim@hardkernel.com>
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
#include "odroidx_setup.h"
#define SET_MIU

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:

    /* CLK_DIV_DMC0 on iROM DMC=50MHz for Init DMC */
	ldr	r0, =EXYNOS4_CLOCK_BASE
    ldr r1, =0x00117713
	ldr r2, =CLK_DIV_DMC0_OFFSET
	str r1, [r0, r2]

	/* DREX0 */
	ldr	r0, =EXYNOS4_DMC0_BASE

	/*
	 * ZQ Calibration
	 * Termination: Disable
	 * Auto Calibration Start: Enable
	 */
	ldr	r1, =0xe3855403
	str	r1, [r0, #DMC_PHYZQCONTROL]

    /*
	 * DLL Parameters Setting: 
	 */
	ldr	r1, =0x71101008
	str	r1, [r0, #DMC_PHYCONTROL0]
	
	ldr	r1, =0x7110100a
	str	r1, [r0, #DMC_PHYCONTROL0]
	
	/*
	 * Update DLL Information:
	 * Force DLL Resyncronization
	 */
	ldr	r1, =0x00000084
	str	r1, [r0, #DMC_PHYCONTROL1]

	/* Enable Differential DQS, DLL Off*/
	ldr	r1, =0x71101008
	str	r1, [r0, #DMC_PHYCONTROL0]

	/* DLL Start */
	ldr	r1, =0x0000008c
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00000084
	str	r1, [r0, #DMC_PHYCONTROL1]

	/* DLL Start */
	ldr	r1, =0x0000008c
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00000084				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x0FFF30CA
	str	r1, [r0, #DMC_CONCONTROL]

	/*
	 * Memor Burst length: 8
	 * Number of chips: 2
	 * Memory Bus width: 32 bit
	 * Memory Type: DDR2
	 * Additional Latancy for PLL: 1 Cycle
	 */
	ldr	r1, =0x00202500
	str	r1, [r0, #DMC_MEMCONTROL]

	/*
	 * Memory Configuration Chip 0
	 * Address Mapping: Interleaved
	 * Number of Column address Bits: 10 bits
	 * Number of Rows Address Bits: 14
	 * Number of Banks: 8
	 */
	ldr	r1, =0x40c01323
	str	r1, [r0, #DMC_MEMCONFIG0]

    /* Interleve on 128 byte */
	ldr	r1, =0x80000007
	str	r1, [r0, #DMC_IVCONTROL]

	/* Config Precharge Policy */
	ldr	r1, =0x64000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	/* Config Power Down  Policy */
@	ldr	r1, =0x9c4000FF
@	str	r1, [r0, #DMC_PWRDNCONFIG]

	/*
	 * TimingAref, TimingRow, TimingData, TimingPower Setting:
	 * Values as per Memory AC Parameters
	 */
	ldr	r1, =0x0000005d
	str	r1, [r0, #DMC_TIMINGAREF]
	ldr	r1, =0x34498691
	str	r1, [r0, #DMC_TIMINGROW]
	ldr	r1, =0x36330306
	str	r1, [r0, #DMC_TIMINGDATA]
	ldr	r1, =0x50380365
	str	r1, [r0, #DMC_TIMINGPOWER]

	/* Wait ?us*/
	mov	r2, #0x100000
2:	subs	r2, r2, #1
	bne	2b

	/* Chip0: NOP Command: Assert and Hold CKE to high level */
	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	/* Wait ?us*/
	mov	r2, #0x300000
3:	subs	r2, r2, #1
	bne	3b

	/* Chip0: ZQINIT */
	ldr	r1, =0x00071c00
	str	r1, [r0, #DMC_DIRECTCMD]

	/* Wait ?us*/
	mov	r2, #0x100000
4:	subs	r2, r2, #1
	bne	4b

	/* Chip0: NOP Command: Assert and Hold CKE to high level */
	ldr	r1, =0x00010bfc
	str	r1, [r0, #DMC_DIRECTCMD]

	/* Wait ?us*/
	mov	r2, #0x100000
5:	subs	r2, r2, #1
	bne	5b

	/* Chip0: EMRS2, EMRS3, EMRS, MRS Commands Using Direct Command */
	ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000810
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000c08
	str	r1, [r0, #DMC_DIRECTCMD]
#if 1
/* PS-Hold high */
	ldr	r0, =0x1002330c
	ldr	r1, [r0]
	orr	r1, r1, #0x300
	str	r1, [r0]
#endif


	/* DREX1 */
	ldr	r0, =EXYNOS4_DMC1_BASE	@0x10610000

	ldr	r1, =0xE3855403			
	str	r1, [r0, #DMC_PHYZQCONTROL]

	ldr	r1, =0x71101008				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x7110100A				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000084				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x71101008				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x0000008C				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00000084				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x0000008C				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x00000084				
	str	r1, [r0, #DMC_PHYCONTROL1]
	
	ldr	r1, =0x0FFF30CA
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00202500
	str	r1, [r0, #DMC_MEMCONTROL]

/*
	 * Memory Configuration Chip 0
	 * Address Mapping: Interleaved
	 * Number of Column address Bits: 10 bits
	 * Number of Rows Address Bits: 14
	 * Number of Banks: 8
	 */

	ldr	r1, =0x40c01323
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =0x80000007 
	str	r1, [r0, #DMC_IVCONTROL]

	/* Config Precharge Policy */
	ldr	r1, =0x64000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x9c4000ff
	str	r1, [r0, #DMC_PHYCONTROL0]

	/*
	 * TimingAref, TimingRow, TimingData, TimingPower Setting:
	 * Values as per Memory AC Parameters
	 */
	ldr	r1, =0x0000005D
	str	r1, [r0, #DMC_TIMINGAREF]
	ldr	r1, =0x34498691
	str	r1, [r0, #DMC_TIMINGROW]
	ldr	r1, =0x36330306
	str	r1, [r0, #DMC_TIMINGDATA]
	ldr	r1, =0x50380365
	str	r1, [r0, #DMC_TIMINGPOWER]

	/* Wait ?us*/
	mov	r2, #0x100000
6:	subs	r2, r2, #1
	bne	6b

	/* Chip0: NOP Command: Assert and Hold CKE to high level */
	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	/* Wait ?us*/
	mov	r2, #0x100000
7:	subs	r2, r2, #1
	bne	7b

	ldr	r1, =0x00071c00
	str	r1, [r0, #DMC_DIRECTCMD]

	/* Wait ?us*/
	mov	r2, #0x100000
8:	subs	r2, r2, #1
	bne	8b

	/* Chip1: ZQINIT */
	ldr	r1, =0x00010bfc
	str	r1, [r0, #DMC_DIRECTCMD]

	/* Wait ?us*/
	mov	r2, #0x100000
9:	subs	r2, r2, #1
	bne	9b

    ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000810
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000c08
	str	r1, [r0, #DMC_DIRECTCMD]

#if 1
/* PS-Hold high */
	ldr	r0, =0x1002330c
	ldr	r1, [r0]
	orr	r1, r1, #0x300
	str	r1, [r0]
#endif


	mov	pc, lr
