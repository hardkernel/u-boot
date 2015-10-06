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

#define CONFIG_LOW_POWER_CTRL	1

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:
	push	{lr}

	@ PHY RESET[0] = 1
	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000
	ldr	r1, =0x1
	ldr	r2, =LPDDR3PHY_CTRL
	str	r1, [r0, r2]
	bl	delay

	@ PHY RESET[1] = 0
	ldr	r1, =0x0
	ldr	r2, =LPDDR3PHY_CTRL
	str	r1, [r0, r2]
	bl	delay

	@ PHY0: memtype=0x1800
	@ PHY1: memtype=0x1800
#if defined(MCLK_CDREX_800)
	ldr	r0, =PHY0_CTRL_BASE
	ldr 	r1, =0x17021A00
	str	r1, [r0, #DMC_PHY_CON0]

	ldr	r0, =PHY1_CTRL_BASE
	ldr 	r1, =0x17021A00
	str	r1, [r0, #DMC_PHY_CON0]
#else
	ldr	r0, =PHY0_CTRL_BASE
	ldr 	r1, =0x17021A40
	str	r1, [r0, #DMC_PHY_CON0]

	ldr	r0, =PHY1_CTRL_BASE
	ldr 	r1, =0x17021A40
	str	r1, [r0, #DMC_PHY_CON0]
#endif

	@ PHY0: dq & dqs pulldown
	@ PHY1: dq & dqs pulldown
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0xF
	str	r1, [r0, #DMC_PHY_CON14]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0xF
	str	r1, [r0, #DMC_PHY_CON14]

	@ PHY0: ctrl_bstlen[12:8]=0x8, ctrl_rdlat[4:0]=0x8
	@ PHY1: ctrl_bstlen[12:8]=0x8, ctrl_rdlat[4:0]=0x8
#if defined(MCLK_CDREX_800)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x80C
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x80C
	str	r1, [r0, #DMC_PHY_CON42]
#elif defined(MCLK_CDREX_733)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x80B
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x80B
	str	r1, [r0, #DMC_PHY_CON42]
#elif defined(MCLK_CDREX_667)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x80A
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x80A
	str	r1, [r0, #DMC_PHY_CON42]
#elif defined(MCLK_CDREX_533)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x808
	str	r1, [r0, #DMC_PHY_CON42]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x808
	str	r1, [r0, #DMC_PHY_CON42]
#endif

	@ dds=0x4000000, term=0x200000
	@ long cal
	@ manual zq cal. start
#if defined(MCLK_CDREX_800) || defined(MCLK_CDREX_533)
	ldr	r0, =PHY0_CTRL_BASE
	ldr 	r1, =0xC240304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC240304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC240306
	str	r1, [r0, #DMC_PHY_CON16]
#else
	ldr	r0, =PHY0_CTRL_BASE
	ldr 	r1, =0xC0C0304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC0C0304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC0C0306
	str	r1, [r0, #DMC_PHY_CON16]
#endif
	@ PHY0: wait for zq_done
repeat_phy0_con17:
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, [r0, #DMC_PHY_CON17]
	and	r1, r1, #0x1
	cmp	r1, #0x1
	bne	repeat_phy0_con17

#if defined(MCLK_CDREX_800) || defined(MCLK_CDREX_533)
	@ clk div disable
	ldr	r0, =PHY0_CTRL_BASE
	ldr 	r1, =0xC200304
	str	r1, [r0, #DMC_PHY_CON16]

	@ dds=0x4000000, term=0x200000
	@ long cal
	@ manual zq cal. start
	ldr	r0, =PHY1_CTRL_BASE
	ldr 	r1, =0xC240304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC240304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC240306
	str	r1, [r0, #DMC_PHY_CON16]
#else
	ldr	r0, =PHY0_CTRL_BASE
	ldr 	r1, =0xC080304
	str	r1, [r0, #DMC_PHY_CON16]

	ldr	r0, =PHY1_CTRL_BASE
	ldr 	r1, =0xC0C0304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC0C0304
	str	r1, [r0, #DMC_PHY_CON16]
	ldr 	r1, =0xC0C0306
	str	r1, [r0, #DMC_PHY_CON16]
#endif

	@ PHY1: wait for zq_done
repeat_phy1_con17:
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, [r0, #DMC_PHY_CON17]
	and	r1, r1, #0x1
	cmp	r1, #0x1
	bne	repeat_phy1_con17
#if defined(MCLK_CDREX_800) || defined(MCLK_CDREX_533)
	@ clk div disable
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0xC200304
	str	r1, [r0, #DMC_PHY_CON16]
#else
	@ clk div disable
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0xC080304
	str	r1, [r0, #DMC_PHY_CON16]
#endif
	@ mem_odt=0x0, ap_odt=0x0
	ldr	r0, =DMC_CTRL_BASE
	ldr 	r1, =0x0
	str	r1, [r0, #DMC_PHYCONTROL0]

#if defined(MCLK_CDREX_800)
	@ set_rd_fetch
	ldr	r1, =0x0FFF3100
	str	r1, [r0, #DMC_CONCONTROL]
	@ dfi_init_start
	ldr 	r1, =0x1FFF3100
	str	r1, [r0, #DMC_CONCONTROL]
	bl	delay100

	ldr	r1, =0xFFF3100
	str	r1, [r0, #DMC_CONCONTROL]
#else
	ldr	r1, =0x0FFF2100
	str	r1, [r0, #DMC_CONCONTROL]
	ldr 	r1, =0x1FFF2100
	str	r1, [r0, #DMC_CONCONTROL]
	bl	delay100

	ldr	r1, =0xFFF2100
	str	r1, [r0, #DMC_CONCONTROL]
#endif
	@ fp_resync = 1
	mov 	r1, #0x8
	str	r1, [r0, #DMC_CONCONTROL]
	@ fp_resync = 0
	mov 	r1, #0x0
	str	r1, [r0, #DMC_CONCONTROL]

	@ memcontrol
#if defined(MCLK_CDREX_533)
	ldr	r1, =0x312700
	str	r1, [r0, #DMC_MEMCONTROL]
#else
	ldr	r1, =0x312723
	str	r1, [r0, #DMC_MEMCONTROL]
#endif

	@ dmc_memconfig0
	ldr	r1, =0x00001323
	str	r1, [r0, #DMC_MEMCONFIG0]
	@ dmc_memconfig1
	ldr	r1, =0x00001323
	str	r1, [r0, #DMC_MEMCONFIG1]
	@ chipbase0=0x40, mask=0x7C0
	ldr	r1, =0x4007C0
	str	r1, [r0, #DMC_MEMBASECONFIG0]
	@ chipbase1=0x80, mask=0x7C0
	ldr	r1, =0x8007C0
	str	r1, [r0, #DMC_MEMBASECONFIG1]
	@ iv_size
	ldr	r1, =CONFIG_IV_SIZE
	str	r1, [r0, #DMC_IVCONTROL]

	@ dmc_refresh_interval
	ldr	r1, =0x0000005D
	str	r1, [r0, #DMC_TIMINGAREF]

	@ set_timing_parameter
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x34488612
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x3630560C
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x50380336
	str	r1, [r0, #DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_733)
	ldr	r1, =0x30478590
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x3630560B
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x4C340336
	str	r1, [r0, #DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x2C47754F
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x3630460A
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x442F0336
	str	r1, [r0, #DMC_TIMINGPOWER]
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x2335640C
	str	r1, [r0, #DMC_TIMINGROW]

	ldr	r1, =0x24203509
	str	r1, [r0, #DMC_TIMINGDATA]

	ldr	r1, =0x38260224
	str	r1, [r0, #DMC_TIMINGPOWER]
#endif

	@ offsetr=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON4]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON4]

	@ offsetw=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON6]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x7F7F7F7F
	str	r1, [r0, #DMC_PHY_CON6]

	@ offsetd=0x7F
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x7F
	str	r1, [r0, #DMC_PHY_CON10]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x7F
	str	r1, [r0, #DMC_PHY_CON10]

	@ lock forcing=0x7F
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]

	@ disable ctrl_dll_on
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F50
	str	r1, [r0, #DMC_PHY_CON12]

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F50
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay

	ldr	r0, =DMC_CTRL_BASE
	@fp_resync = 1
	mov	r1, #0x8
	str	r1, [r0, #DMC_PHYCONTROL0]
	@fp_resync = 0
	mov	r1, #0x0
	str	r1, [r0, #DMC_PHYCONTROL0]

	@ Direct Command P0 CH0
	ldr	r1, =0x7000000
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x71C00
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay100
	ldr	r1, =0x10BFC
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x50C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x868
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#elif defined(MCLK_CDREX_733)
	ldr	r1, =0x48C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x864
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x40C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x860
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x70C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x81C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#endif
	ldr	r1, =0xC04
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay

	ldr	r1, =0x7100000
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x171C00
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay100
	ldr	r1, =0x110BFC
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x10050C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x100868
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_733)
	ldr	r1, =0x10048C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x100864
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x10040C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x100860
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x10070C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10081C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#endif
	ldr	r1, =0x100C04
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay

	ldr	r1, =0x17000000
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x10071C00
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay100
	ldr	r1, =0x10010BFC
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x1000050C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10000868
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_733)
	ldr	r1, =0x1000048C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10000864
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x1000040C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10000860
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x1000070C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x1000081C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#endif
	ldr	r1, =0x10000C04
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay

	ldr	r1, =0x17100000
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
	ldr	r1, =0x10171C00
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay100
	ldr	r1, =0x10110BFC
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x1010050C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10100868
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_733)
	ldr	r1, =0x1010048C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10100864
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x1010040C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x10100860
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x1010070C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay
	ldr	r1, =0x1010081C
	str	r1, [r0, #DMC_DIRECTCMD]
	bl	delay
#endif
	ldr	r1, =0x10100C04
	str	r1, [r0, #DMC_DIRECTCMD]
	bl 	delay

	@ set_mem_clock
	ldr	r0, =ELFIN_CLOCK_BASE	@0x1001_0000
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x01001151
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr 	r1, =0x00203800
	ldr 	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]
	ldr 	r1, =0x80640300
	ldr 	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock
#elif defined(MCLK_CDREX_733)
	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011111
	bl	wait_mux_state

	ldr	r1, =0x01001151
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr 	r1, =0x00203800
	ldr 	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]

	ldr 	r1, =0x80640300
	ldr 	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

	ldr 	r1, =0x00203800
	ldr 	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]

	ldr 	r1, =0x81500B00
	ldr 	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock
#elif defined(MCLK_CDREX_667)
	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011111
	bl	wait_mux_state

	ldr	r1, =0x01001141
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr 	r1, =0x00203800
	ldr 	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]

	ldr 	r1, =0x80640300
	ldr 	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

	ldr 	r1, =0x00203800
	ldr 	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]

	ldr 	r1, =0x81850701
	ldr 	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock
#elif defined(MCLK_CDREX_533)
	ldr	r1, =0x0
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011111
	bl	wait_mux_state

	ldr	r1, =0x01001131
	ldr	r2, =CLK_DIV_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x0
	bl	wait_div_state

	ldr 	r1, =0x00203800
	ldr 	r2, =MPLL_CON1_OFFSET
	str	r1, [r0, r2]

	ldr 	r1, =0x80640300
	ldr 	r2, =MPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock

	ldr 	r1, =0x00203800
	ldr 	r2, =BPLL_CON1_OFFSET
	str	r1, [r0, r2]

	ldr 	r1, =0x82150C01
	ldr 	r2, =BPLL_CON0_OFFSET
	str	r1, [r0, r2]
	bl	wait_pll_lock
#endif

	@ [16~4] 1: BPLL, 0 : MPLL
	@ [16] MCLK_EFPHY(0), [12]C2C_CLK_400(1), [8]MCLK_DPHY(1), [4]MCLK_CDREX(1)
	@ [0]  BPLL(1-FOUTBPLL)
#if defined(MCLK_CDREX_800)
	ldr	r1, =0x1
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011112
	bl	wait_mux_state
#else
	ldr	r1, =0x00000111
	ldr	r2, =CLK_SRC_CDREX_OFFSET
	str	r1, [r0, r2]
	ldr	r3, =0x00011222
	bl	wait_mux_state
#endif

	@ offsetr=0:0x08, 1:0x08, 2:0x08, 3:0x08
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x8080808
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

	@ offsetd=0x08
	ldr	r0, =PHY0_CTRL_BASE
	mov 	r1, #0x8
	str	r1, [r0, #DMC_PHY_CON10]
	ldr	r0, =PHY1_CTRL_BASE
	mov 	r1, #0x8
	str	r1, [r0, #DMC_PHY_CON10]

	@ dll_on_start
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]
	bl	delay
	ldr	r1, =0x10107F30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]
	bl	delay

	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]
	bl	delay
	ldr	r1, =0x10107F30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10107F70
	str	r1, [r0, #DMC_PHY_CON12]
	bl	delay

	@ dfi_init_start
#if defined(MCLK_CDREX_800)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1FFF2108
	str	r1, [r0, #DMC_CONCONTROL]
#else
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1FFF2100
	str	r1, [r0, #DMC_CONCONTROL]
#endif

check_phystatus1:
	ldr	r0, =DMC_CTRL_BASE
	ldr	r2, [r0, #DMC_PHYSTATUS]
	and	r2, r2, #0xC
	cmp	r2, #0xC
	bne	check_phystatus1

#if defined(MCLK_CDREX_800)
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xFFF2108
	str	r1, [r0, #DMC_CONCONTROL]
#else
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xFFF2100
	str	r1, [r0, #DMC_CONCONTROL]
#endif

#if !defined(MCLK_CDREX_533)
	@ fp_resync
	mov	r1, #0x8
	str	r1, [r0, #DMC_PHYCONTROL0]
	mov	r1, #0x0
	str	r1, [r0, #DMC_PHYCONTROL0]

#if defined(MCLK_CDREX_800)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102570
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102670
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102550
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102650
	str	r1, [r0, #DMC_PHY_CON12]
#elif defined(MCLK_CDREX_733)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102B70
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102C70
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102B50
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102C50
	str	r1, [r0, #DMC_PHY_CON12]
#elif defined(MCLK_CDREX_667)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102E70
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102F70
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102E50
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102F50
	str	r1, [r0, #DMC_PHY_CON12]
#endif
	bl 	delay

	@ fp_resync
	ldr	r0, =DMC_CTRL_BASE
	mov	r1, #0x8
	str	r1, [r0, #DMC_PHYCONTROL0]
	mov	r1, #0x0
	str	r1, [r0, #DMC_PHYCONTROL0]

	@ ctrl_atgate=0x0
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17021A40
	str	r1, [r0, #DMC_PHY_CON0]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17021A40
	str	r1, [r0, #DMC_PHY_CON0]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x92F00FF
	str	r1, [r0, #DMC_PHY_CON1]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x92F00FF
	str	r1, [r0, #DMC_PHY_CON1]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x00000208
	str	r1, [r0, #DMC_PHY_CON22]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x00000208
	str	r1, [r0, #DMC_PHY_CON22]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x2010004
	str	r1, [r0, #DMC_PHY_CON2]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x2010004
	str	r1, [r0, #DMC_PHY_CON2]

	ldr	r0, =DMC_CTRL_BASE
	mov	r1, #0x2
	str	r1, [r0, #DMC_RDLVL_CONFIG]
	mov	r1, #0x0
	str	r1, [r0, #DMC_RDLVL_CONFIG]

#if defined(MCLK_CDREX_800)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102570
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r1, =0x10102530
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10102570
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102670
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r1, =0x10102630
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10102670
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
#elif defined(MCLK_CDREX_733)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102B70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r1, =0x10102B30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10102B70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102C70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r1, =0x10102C30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10102C70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
#elif defined(MCLK_CDREX_667)
	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x10102E70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r1, =0x10102E30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10102E70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x10102F70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
	ldr	r1, =0x10102F30
	str	r1, [r0, #DMC_PHY_CON12]
	ldr	r1, =0x10102F70
	str	r1, [r0, #DMC_PHY_CON12]
	bl 	delay
#endif
#endif
	@fp_resync = 1
	ldr	r0, =DMC_CTRL_BASE
	mov	r1, #0x8
	str	r1, [r0, #DMC_PHYCONTROL0]
	@fp_resync = 0
	mov	r1, #0x0
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r0, =PHY0_CTRL_BASE
	ldr	r1, =0x17021A00
	str	r1, [r0, #DMC_PHY_CON0]
	ldr	r0, =PHY1_CTRL_BASE
	ldr	r1, =0x17021A00
	str	r1, [r0, #DMC_PHY_CON0]

#if defined(CONFIG_LOW_POWER_CTRL)
	@dynamic self reflesh
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0xFFFF00FF
	str	r1, [r0, #DMC_PWRDNCONFIG]
	ldr	r1, [r0, #DMC_MEMCONTROL]
	orr	r1, r1, #0x20
	str	r1, [r0, #DMC_MEMCONTROL]
	@dynamic power down
	ldr	r1, =0xFFFF00FF
	str	r1, [r0, #DMC_PWRDNCONFIG]
	ldr	r1, [r0, #DMC_MEMCONTROL]
	orr	r1, r1, #0x2
	str	r1, [r0, #DMC_MEMCONTROL]
	@dynamic clock stop
	ldr	r1, [r0, #DMC_MEMCONTROL]
	orr	r1, r1, #0x1
	str	r1, [r0, #DMC_MEMCONTROL]
#endif
	ldr	r0, =DMC_CTRL_BASE
	ldr	r1, =0x1000000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x1100000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x11000000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x11100000
	str	r1, [r0, #DMC_DIRECTCMD]

#if defined(MCLK_CDREX_733)
	@ io_pd_con
	ldr	r1, =0xFFF3108
	str	r1, [r0, #DMC_CONCONTROL]
	@ aref enabled
	ldr	r1, =0xFFF3128
	str	r1, [r0, #DMC_CONCONTROL]
#else
	ldr	r1, =0xFFF2108
	str	r1, [r0, #DMC_CONCONTROL]
	ldr	r1, =0xFFF2128
	str	r1, [r0, #DMC_CONCONTROL]
#endif
	pop	{lr}
	mov 	pc, lr

delay100:
	mov	r2, #0x10000
delayloop100:
	subs	r2, r2, #1
	bne	delayloop100
	mov	pc, lr

delay:
	mov	r2, #0x100
delayloop:
	subs	r2, r2, #1
	bne	delayloop
	mov	pc, lr

wait_pll_lock:
	ldr     r1, [r0, r2]
	tst     r1, #(1<<29)
	beq     wait_pll_lock
	mov     pc, lr

wait_mux_state:
	add     r2, r2, #0x200
check_mux_state:
	ldr     r1, [r0, r2]
	cmp     r1, r3
	bne     check_mux_state
	mov     pc, lr

wait_div_state:
	add     r2, r2, #0x100
check_div_state:
	ldr     r1, [r0, r2]
	cmp     r1, r3
	bne     check_div_state
	mov     pc, lr
