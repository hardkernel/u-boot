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


#define MEM_DLL
#define MCLK_400


	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:

	/* CLK_DIV_DMC0 on iROM DMC=50MHz for Init DMC */
	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000
	ldr	r1, =0x00771711
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

/*****************************************************************/
/*DREX0***********************************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_0_BASE

	ldr	r1, =0xE3855D33
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

	ldr	r1, =0x40C01323
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =(0x80000000 | CONFIG_IV_SIZE)
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r1, =0x64000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0xFFFF00FF
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =0x0000005D
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

#ifdef MCLK_330
	ldr	r1, =0x2CA6650E
	str	r1, [r0, #DMC_TIMINGROW]
	ldr	r1, =0x35300306
	str	r1, [r0, #DMC_TIMINGDATA]
	ldr	r1, =0x448C0335
	str	r1, [r0, #DMC_TIMINGPOWER]
#else
	ldr	r1, =0x34488611
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x36300306
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x508C0335
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower
#endif

	mov	r2, #0x100000
2:	subs	r2, r2, #1
	bne	2b

	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
3:	subs	r2, r2, #1
	bne	3b

	ldr	r1, =0x00071C00
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
4:	subs	r2, r2, #1
	bne	4b

	ldr	r1, =0x00010BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
5:	subs	r2, r2, #1
	bne	5b

	ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000810
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000C08
	str	r1, [r0, #DMC_DIRECTCMD]

/*****************************************************************/
/*DREX1***********************************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0xE3855D33
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

	ldr	r1, =0x40C01323
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =(0x80000000 | CONFIG_IV_SIZE)
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r1, =0x64000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0xFFFF00FF
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =0x0000005D
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

#ifdef MCLK_330
	ldr	r1, =0x2CA6650E
	str	r1, [r0, #DMC_TIMINGROW]
	ldr	r1, =0x35300306
	str	r1, [r0, #DMC_TIMINGDATA]
	ldr	r1, =0x448C0335
	str	r1, [r0, #DMC_TIMINGPOWER]
#else
	ldr	r1, =0x34488611
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x36300306
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x508C0335
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower
#endif

	mov	r2, #0x100000
2:	subs	r2, r2, #1
	bne	2b

	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
3:	subs	r2, r2, #1
	bne	3b

	ldr	r1, =0x00071C00
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
4:	subs	r2, r2, #1
	bne	4b

	ldr	r1, =0x00010BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
5:	subs	r2, r2, #1
	bne	5b

	ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000810
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000C08
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	pc, lr

