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

#define RD_LVL		1

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:
	push	{lr}

	/* CLK_DIV_DMC0 on iROM DMC=50MHz for Init DMC */
	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000

	ldr	r1, =0x0
	ldr	r2, =LPDDR3PHY_CTRL
	str	r1, [r0, r2]

	bl	delay

#if defined(MCLK_CDREX_400)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x406
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x406
	str	r1, [r0, #DMC_PHY_CON42]
#else
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x408
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x408
	str	r1, [r0, #DMC_PHY_CON42]
#endif

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0DA40304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0DA40304
	str	r1, [r0, #DMC_PHY_CON16]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0DAC0304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0DAC0304
	str	r1, [r0, #DMC_PHY_CON16]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0DAC0306
	str	r1, [r0, #DMC_PHY_CON16]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0DAC0306
	str	r1, [r0, #DMC_PHY_CON16]

	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0DAC0304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0DAC0304
	str	r1, [r0, #DMC_PHY_CON16]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17021240
	str	r1, [r0, #DMC_PHY_CON0]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17021240
	str	r1, [r0, #DMC_PHY_CON0]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000F0F
	str	r1, [r0, #DMC_PHY_CON14]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000F0F
	str	r1, [r0, #DMC_PHY_CON14]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1FFF1000
	str	r1, [r0, #DMC_CONCONTROL]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x0FFF1000
	str	r1, [r0, #DMC_CONCONTROL]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00212500
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x00001323
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =0x00001323
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0x004007C0
	str	r1, [r0, #DMC_MEMBASECONFIG0]

	ldr	r1, =0x008007C0
	str	r1, [r0, #DMC_MEMBASECONFIG1]

	ldr	r1, =0xFF000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0xFFFF00FF
	str	r1, [r0, #DMC_PWRDNCONFIG]

	ldr	r1, =0x0000005D
	str	r1, [r0, #DMC_TIMINGAREF]

@ MCLK_CDREX_800
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x34498691
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x36303408
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x50380335
	str	r1, [r0, #DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x2C48758F
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x36302408
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x442F0335
	str	r1, [r0, #DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x2336544C
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x24202408
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x38260235
	str	r1, [r0, #DMC_TIMINGPOWER]
#else
	ldr	r1, =0x1A354349
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x23202306
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x281C0235
	str	r1, [r0, #DMC_TIMINGPOWER]
#endif

	ldr	r1, =CONFIG_IV_SIZE
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON4]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON4]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON6]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON6]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x0000007F
	str	r1, [r0, #DMC_PHY_CON10]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x0000007F
	str	r1, [r0, #DMC_PHY_CON10]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F50
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F50
	str	r1, [r0, #DMC_PHY_CON12]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL0]

@ Direct Command P0 CH0

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00071C00
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00010BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

#if defined(MCLK_CDREX_400)
@ MCLK_CDREX_400
	ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00000810
	str	r1, [r0, #DMC_DIRECTCMD]
#else
	ldr	r1, =0x00000708
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00000818
	str	r1, [r0, #DMC_DIRECTCMD]
#endif

	bl	delay

#if !defined(MCLK_CDREX_400)
	ldr	r1, =0x00000C08
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay
#endif


@ Direct Command P0 CH1

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x07100000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00171C00
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00110BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

#if defined(MCLK_CDREX_400)
@ MCLK_CDREX_400
	ldr	r1, =0x00100608
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00100810
	str	r1, [r0, #DMC_DIRECTCMD]
#else
	ldr	r1, =0x00100708
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x00100818
	str	r1, [r0, #DMC_DIRECTCMD]
#endif

	bl	delay

#if !defined(MCLK_CDREX_400)
	ldr	r1, =0x00100C08
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay
#endif

@ Direct Command P1 CH0

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x17000000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10071C00
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10010BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

#if defined(MCLK_CDREX_400)
@ MCLK_CDREX_400
	ldr	r1, =0x10000608
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10000810
	str	r1, [r0, #DMC_DIRECTCMD]
#else
	ldr	r1, =0x10000708
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10000818
	str	r1, [r0, #DMC_DIRECTCMD]
#endif

	bl	delay

#if !defined(MCLK_CDREX_400)
	ldr	r1, =0x10000C08
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay
#endif

@ Direct Command P1 CH1

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x17100000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10171C00
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10110BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

#if defined(MCLK_CDREX_400)
@ MCLK_CDREX_400
	ldr	r1, =0x10100608
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10100810
	str	r1, [r0, #DMC_DIRECTCMD]
#else
	ldr	r1, =0x10100708
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r1, =0x10100818
	str	r1, [r0, #DMC_DIRECTCMD]
#endif

	bl	delay

#if !defined(MCLK_CDREX_400)
	ldr	r1, =0x10100C08
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay
#endif

	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000

#if defined(MCLK_CDREX_667) || defined(MCLK_CDREX_533)
	ldr	r1, =0x110
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011221
	bl	wait_mux_state
#endif

#if defined(MCLK_CDREX_667)
	ldr	r1, =0x01001141
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x01001131
#elif defined(MCLK_CDREX_400)
	ldr	r1, =0x10111121
#endif
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

@ Set MPLL
	ldr	r1, =0x00203800
	ldr	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x80640300
	ldr	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

#if defined(MCLK_CDREX_667)
@ Set BPLL
	ldr	r1, =0x00203800
	ldr	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr	r1, =0x81850701
	ldr	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock
#endif

#if defined(MCLK_CDREX_667) || defined(MCLK_CDREX_533)
	ldr	r1, =0x111
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011222
	bl	wait_mux_state
#endif

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON4]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON4]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON6]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x08080808
	str	r1, [r0, #DMC_PHY_CON6]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHY_CON10]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHY_CON10]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F30
	str	r1, [r0, #DMC_PHY_CON12]

	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL0]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL0]

	bl	delay

#if defined(RD_LVL)

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102D50
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102D50
	str	r1, [r0, #DMC_PHY_CON12]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x09210001
	str	r1, [r0, #DMC_PHY_CON1]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x09210001
	str	r1, [r0, #DMC_PHY_CON1]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000208
	str	r1, [r0, #DMC_PHY_CON22]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000208
	str	r1, [r0, #DMC_PHY_CON22]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17023240
	str	r1, [r0, #DMC_PHY_CON0]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17023240
	str	r1, [r0, #DMC_PHY_CON0]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x02010004
	str	r1, [r0, #DMC_PHY_CON2]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x02010004
	str	r1, [r0, #DMC_PHY_CON2]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000002
	str	r1, [r0, #DMC_RDLVL_CONFIG]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_RDLVL_CONFIG]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x02012004
	str	r1, [r0, #DMC_PHY_CON2]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x02012004
	str	r1, [r0, #DMC_PHY_CON2]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000008
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL0]

	bl	delay

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17023200
	str	r1, [r0, #DMC_PHY_CON0]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17023200
	str	r1, [r0, #DMC_PHY_CON0]

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x01000000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x01100000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x11000000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x11100000
	str	r1, [r0, #DMC_DIRECTCMD]

	bl	delay
#endif

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x00212523
	str	r1, [r0, #DMC_MEMCONTROL]

@ Start Auto-refresh

	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x0FFF10E0
	str	r1, [r0, #DMC_CONCONTROL]

	pop	{lr}
	mov	pc, lr

delay:
	mov	r2, #0x10000
delayloop:
	subs	r2, r2, #1
	bne	delayloop
	mov	pc, lr

wait_pll_lock:
	ldr	r1, [r0, r2]
	tst	r1, #(1<<29)
	beq	wait_pll_lock
	mov	pc, lr

wait_mux_state:
	add	r2, r2, #0x200
check_mux_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_mux_state
	mov	pc, lr

wait_div_state:
	add	r2, r2, #0x100
check_div_state:
	ldr	r1, [r0, r2]
	cmp	r1, r3
	bne	check_div_state
	mov	pc, lr
