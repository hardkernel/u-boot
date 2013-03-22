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

#define GATE_LEVELING		1

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:
	push	{lr}

	/* CLK_DIV_DMC0 on iROM DMC=50MHz for Init DMC */
	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000

#if defined(MCLK_CDREX_800)
	ldr	r1, =0x01001151
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

	bl	delay_3

@ Set MPLL
	ldr	r1, =0x00203800
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x80640300
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]

#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x00000000
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x01001141
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

@ Set MPLL
	ldr	r1, =0x00203800
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x80640300
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]

@ Set BPLL
	ldr	r1, =0x00203800
	ldr	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x81850701
	ldr	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]

	bl	delay_3

	ldr	r1, =0x00000111
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x00000000
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

	ldr	r1, =0x01001131
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

@ Set MPLL
	ldr	r1, =0x00203800
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x80640300
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]

	bl	delay_3

	ldr	r1, =0x00000111
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]

#elif defined(MCLK_CDREX_400)
	ldr	r1, =0x11111121
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]

	bl	delay_3

@ Set MPLL
	ldr	r1, =0x00203800
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x80640300
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]

#endif

	bl	delay

	ldr	r1, =0x0
	ldr	r2, =LPDDR3PHY_CTRL
	str	r1, [r0, r2]

	bl	delay

	ldr	r1, =0x1
	ldr	r2, =LPDDR3PHY_CTRL
	str	r1, [r0, r2]

	bl	delay

#if defined(MCLK_CDREX_400)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000806
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000806
	str	r1, [r0, #DMC_PHY_CON42]
#elif defined(MCLK_CDREX_533)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000807
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000807
	str	r1, [r0, #DMC_PHY_CON42]
#elif defined(MCLK_CDREX_667)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000809
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000809
	str	r1, [r0, #DMC_PHY_CON42]
#elif defined(MCLK_CDREX_800)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0000080B
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0000080B
	str	r1, [r0, #DMC_PHY_CON42]
#endif

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0d240304
	str	r1, [r0,#DMC_PHY_CON16]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x0d240304
        str     r1, [r0, #DMC_PHY_CON16]
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0d240304
	str	r1, [r0,#DMC_PHY_CON16]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x0d240304
        str     r1, [r0, #DMC_PHY_CON16]
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0d240306
	str	r1, [r0, #DMC_PHY_CON16]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x0d240306
        str     r1, [r0, #DMC_PHY_CON16]

	bl	delay
	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0d240304
	str	r1, [r0, #DMC_PHY_CON16]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x0d240304
        str     r1, [r0, #DMC_PHY_CON16]


	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17022a40
	str	r1, [r0, #DMC_PHY_CON0]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x17022a40
        str     r1, [r0, #DMC_PHY_CON0]


	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000f0f
	str	r1, [r0, #DMC_PHY_CON14]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x00000f0f
        str     r1, [r0, #DMC_PHY_CON14]

#if defined(MCLK_CDREX_800)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1FFF3000
	str	r1, [r0,#DMC_CONCONTROL]
#else
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1FFF2000
	str	r1, [r0,#DMC_CONCONTROL]
#endif

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xe0000008
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xe0000000
	str	r1, [r0,#DMC_PHYCONTROL0]


#if defined(MCLK_CDREX_800)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0f0f0f0f
	str	r1, [r0, #DMC_PHY_CON4]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x1f1f1f1f
        str     r1, [r0, #DMC_PHY_CON4]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON6]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x08080808
        str     r1, [r0, #DMC_PHY_CON6]
#elif defined(MCLK_CDREX_667)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON4]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x08080808
        str     r1, [r0, #DMC_PHY_CON4]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON6]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x08080808
        str     r1, [r0, #DMC_PHY_CON6]
#else
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON4]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x08080808
        str     r1, [r0, #DMC_PHY_CON4]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON6]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x08080808
        str     r1, [r0, #DMC_PHY_CON6]
#endif

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHY_CON10]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x00000008
        str     r1, [r0, #DMC_PHY_CON10]


	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10100030
	str	r1, [r0, #DMC_PHY_CON12]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x10100030
        str     r1, [r0, #DMC_PHY_CON12]

	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10100070
	str	r1, [r0, #DMC_PHY_CON12]
        ldr     r0, =PHY1_CTRL_BASE
        ldr     r1, =0x10100070
        str     r1, [r0, #DMC_PHY_CON12]

	bl	delay
	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000008
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000000
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000008
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000000
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00302600
	str	r1, [r0,#DMC_MEMCONTROL]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00001333
	str	r1, [r0,#DMC_MEMCONFIG0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00001333
	str	r1, [r0,#DMC_MEMCONFIG1]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00400780
	str	r1, [r0,#DMC_MEMBASECONFIG0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00800780
	str	r1, [r0,#DMC_MEMBASECONFIG1]

#if defined(MCLK_CDREX_800)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000007
	str	r1, [r0,#DMC_IVCONTROL]
#else
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000007
	str	r1, [r0,#DMC_IVCONTROL]
#endif

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xFF000000
	str	r1, [r0,#DMC_PRECHCONFIG]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xFFFF00FF
	str	r1, [r0,#DMC_PWRDNCONFIG]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x000000bb
	str	r1, [r0,#DMC_TIMINGAREF]

#if defined(MCLK_CDREX_400)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x46434288
	str	r1, [r0,#DMC_TIMINGROW]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x43413506
	str	r1, [r0,#DMC_TIMINGDATA]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x22000a3c
	str	r1, [r0,#DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_533)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x5e44534a
	str	r1, [r0,#DMC_TIMINGROW]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x44413607
	str	r1, [r0,#DMC_TIMINGDATA]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x2e000a3c
	str	r1, [r0,#DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_667)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x7645644d
	str	r1, [r0,#DMC_TIMINGROW]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x45414709
	str	r1, [r0,#DMC_TIMINGDATA]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x3a000a3c
	str	r1, [r0,#DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_800)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x8c46650f
	str	r1, [r0,#DMC_TIMINGROW]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x4641580b
	str	r1, [r0,#DMC_TIMINGDATA]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x42000a3c
	str	r1, [r0,#DMC_TIMINGPOWER]
#endif

# ---------------------
# Direct Command P0 CH0
# ---------------------
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x07000000
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
#if defined(MCLK_CDREX_400)
	ldr	r1, =0x00020000
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x00020008
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x00020010
#elif defined(MCLK_CDREX_800)
	ldr	r1, =0x00020018
#endif
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00030000
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00010042
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
#if defined(MCLK_CDREX_400)
	ldr	r1, =0x00000520
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x00000930
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x00000b50
#elif defined(MCLK_CDREX_800)
	ldr	r1, =0x00000d70
#endif
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x0a000000
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

# ---------------------
# Direct Command P1 CH0
# ---------------------
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x17000000
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
#if defined(MCLK_CDREX_400)
	ldr	r1, =0x10020000
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x10020008
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x10020010
#elif defined(MCLK_CDREX_800)
	ldr	r1, =0x10020018
#endif
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x10030000
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x10010042
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
#if defined(MCLK_CDREX_400)
	ldr	r1, =0x10000520
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x10000930
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x10000b50
#elif defined(MCLK_CDREX_800)
	ldr	r1, =0x10000d70
#endif
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1a000000
	str	r1, [r0,#DMC_DIRECTCMD]

	bl	delay

#if defined(GATE_LEVELING)
/*clock0*/
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, [r0,#DMC_PHY_CON13]	/*Reading 0x34*/
	and	r2, r1, #0xfc00 /*Logical AND*/
	lsr	r3, r2, #2 /*Right Shift 2 bits*/

	ldr	r4, =0x10100050
	add	r2, r3, r4
	str	r2, [r0, #DMC_PHY_CON12]

/*clock1*/
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, [r0,#DMC_PHY_CON13]	/*Reading 0x34*/
	and	r2, r1, #0xfc00 /*Logical AND*/
	lsr	r3, r2, #2 /*Right Shift 2 bits*/

	ldr	r4, =0x10100050
	add	r2, r3, r4
	str	r2, [r0, #DMC_PHY_CON12]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000008
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000000
	str	r1, [r0,#DMC_PHYCONTROL0]

	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x01010004
	str	r1, [r0,#DMC_PHY_CON2]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x01010004
	str	r1, [r0,#DMC_PHY_CON2]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17022b40
	str	r1, [r0,#DMC_PHY_CON0]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17022b40
	str	r1, [r0,#DMC_PHY_CON0]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0901ff00
	str	r1, [r0,#DMC_PHY_CON1]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0901ff00
	str	r1, [r0,#DMC_PHY_CON1]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000001
	str	r1, [r0,#DMC_RDLVL_CONFIG]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000003
	str	r1, [r0,#DMC_RDLVL_CONFIG]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000001
	str	r1, [r0,#DMC_RDLVL_CONFIG]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0,#DMC_RDLVL_CONFIG]
	bl	delay

#endif						/*GATE_LEVELING if ends here*/

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17022a40
	str	r1, [r0,#DMC_PHY_CON0]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17022a40
	str	r1, [r0,#DMC_PHY_CON0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000008
	str	r1, [r0,#DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x20000000
	str	r1, [r0,#DMC_PHYCONTROL0]

	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0901ff00
	str	r1, [r0,#DMC_PHY_CON1]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0901ff00
	str	r1, [r0,#DMC_PHY_CON1]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00302600
	str	r1, [r0,#DMC_MEMCONTROL]

#if defined(MCLK_CDREX_800)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x0FFF3020
	str	r1, [r0,#DMC_CONCONTROL]
#else
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x0FFF2020
	str	r1, [r0,#DMC_CONCONTROL]
#endif

	pop	{lr}
	mov	pc, lr

delay:
	mov	r2, #0x130000
delayloop:
	subs	r2, r2, #1
	bne	delayloop
	mov	pc, lr


delay_3:
	mov	r2, #0x390000
delayloop_1:
	subs	r2, r2, #1
	bne	delayloop_1
	mov	pc, lr
