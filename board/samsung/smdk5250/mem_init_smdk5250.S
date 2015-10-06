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
@#define CONFIG_DMC_BRB

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:
	push	{lr}

	ldr	r0, =CHIP_ID_BASE
	ldr	r1, [r0, #0x0]
	and	r1, #0xf00
	mov	r2, #0x200
	mov	r0, #800	@nMEMCLK
	cmp	r1, r2
	beq	mem_ctrl_init_lpddr3
	b	mem_ctrl_init_ddr3

	.globl	mem_ctrl_init_done
mem_ctrl_init_done:

#if defined(CONFIG_DMC_BRB)
	/* DMC BRB QoS */
	ldr r0, =DMC_CTRL_BASE
	ldr r1, =0x66668666
	str r1, [r0, #DMC_BRBRSVCONFIG]
	ldr r1, =0xFF
	str r1, [r0, #DMC_BRBRSVCONTROL]
	ldr r1, =0x1
	str r1, [r0, #DMC_BRBQOSCONFIG]
#endif
	pop	{lr}
	mov	pc, lr

mem_ctrl_init_ddr3:

	@Outp32( 0x10030200, 0. );	//- rCLK_SRC_CDREX
	ldr r0, =0x10030200
	ldr r1, =0
	str r1, [r0]
	@Outp32( 0x10030500, 16777297. );	//- rCLK_DIV_CDREX
	ldr r0, =0x10030500
	ldr r1, =16777297
	str r1, [r0]
	@Outp32( 0x10014104, 2111488. );	// rMPLL_CON1
	ldr r0, =0x10014104
	ldr r1, =2111488
	str r1, [r0]
	@Outp32( 0x10014100, 2160591616. );	// rMPLL_CON0
	ldr r0, =0x10014100
	ldr r1, =2160591616
	str r1, [r0]
@DMC_Delay(0x10000); // wait 300ms
	bl	delay100
	bl	delay100
	bl	delay100
	@Outp32( 0x10014204, 256. );	//
	ldr r0, =0x10014204
	ldr r1, =256
	str r1, [r0]
@DMC_Delay(0x10000); // wait 300ms
	bl	delay100
	bl	delay100
	bl	delay100
	@Outp32( 0x10030A10, 0x00000000 );	//- PHY_RESET[0]=0
	ldr r0, =0x10030A10
	ldr r1, =0x00000000
	str r1, [r0]
@DMC_Delay(1ms);
	bl	delay
	@Outp32( 0x10030A10, 0x00000001 );	//- PHY_RESET[0]=1
	ldr r0, =0x10030A10
	ldr r1, =0x00000001
	str r1, [r0]
@DMC_Delay(1ms);
	bl	delay
	@Outp32( 0x10C00000+0x00a0, 0x000006db );	//- dds of CA = 0x3
	ldr r0, =(0x10C00000+0x00a0)
	ldr r1, =0x000006db
	str r1, [r0]
	@Outp32( 0x10C10000+0x00a0, 0x000006db );	//- dds of CA = 0x3
	ldr r0, =(0x10C10000+0x00a0)
	ldr r1, =0x000006db
	str r1, [r0]
	@Outp32( 0x10C00000+0x00ac, 0x0000080b );	//- ctrl_bstlen[12:8]=8, ctrl_rdlat[4:0]=11
	ldr r0, =(0x10C00000+0x00ac)
	ldr r1, =0x0000080b
	str r1, [r0]
	@Outp32( 0x10C10000+0x00ac, 0x0000080b );	//- ctrl_bstlen[12:8]=8, ctrl_rdlat[4:0]=11
	ldr r0, =(0x10C10000+0x00ac)
	ldr r1, =0x0000080b
	str r1, [r0]
	@Outp32( 0x10C00000+0x0040, 0xE240000|0x0304 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_clk_div_en[18]=1
	ldr r0, =(0x10C00000+0x0040)
	ldr r1, =(0xE240000|0x0304)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0040, 0xE240000|0x0304 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_clk_div_en[18]=1
	ldr r0, =(0x10C10000+0x0040)
	ldr r1, =(0xE240000|0x0304)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0040, 0xE240000|0x0304 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_mode_noterm[19]=0
	ldr r0, =(0x10C00000+0x0040)
	ldr r1, =(0xE240000|0x0304)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0040, 0xE240000|0x0304 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_mode_noterm[19]=0
	ldr r0, =(0x10C10000+0x0040)
	ldr r1, =(0xE240000|0x0304)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0040, 0xE240000|0x0306 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=1
	ldr r0, =(0x10C00000+0x0040)
	ldr r1, =(0xE240000|0x0306)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0040, 0xE240000|0x0306 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=1
	ldr r0, =(0x10C10000+0x0040)
	ldr r1, =(0xE240000|0x0306)
	str r1, [r0]
@DMC_Delay(1ms);
	bl	delay
	@Outp32( 0x10C00000+0x0040, 0xE240000|0x0304 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=0
	ldr r0, =(0x10C00000+0x0040)
	ldr r1, =(0xE240000|0x0304)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0040, 0xE240000|0x0304 );	//- zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=0
	ldr r0, =(0x10C10000+0x0040)
	ldr r1, =(0xE240000|0x0304)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0038, 0x0000000f );	//- ctrl_pulld_dq[11:8]=0xf, ctrl_pulld_dqs[3:0]=0xf
	ldr r0, =(0x10C00000+0x0038)
	ldr r1, =(0x0000000f)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0038, 0x0000000f );	//- ctrl_pulld_dq[11:8]=0xf, ctrl_pulld_dqs[3:0]=0xf
	ldr r0, =(0x10C10000+0x0038)
	ldr r1, =(0x0000000f)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0000, 0x1FFF0000|(0x3<<12.) );	//- dfi_init_start[28]=1, rd_fetch[14:12]=3
	ldr r0, =(0x10DD0000+0x0000)
	ldr r1, =(0x1FFF0000|(0x3<<12))
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0018, 0xe0000008 );	//- mem_term_en[31]=1, phy_term_en[30]=1, gate signal length[29]=1, fp_resync[3]=1
	ldr r0, =(0x10DD0000+0x0018)
	ldr r1, =(0xe0000008)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0018, 0xe0000000 );	//- mem_term_en[31]=1, phy_term_en[30]=1, gate signal length[29]=1, fp_resync[3]=0
	ldr r0, =(0x10DD0000+0x0018)
	ldr r1, =(0xe0000000)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0010, 0x8080808 );	//- ctrl_offsetr
	ldr r0, =(0x10C00000+0x0010)
	ldr r1, =(0x8080808)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0010, 0x8080808 );	//- ctrl_offsetr
	ldr r0, =(0x10C10000+0x0010)
	ldr r1, =(0x8080808)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0018, 0x8080808 );	//- ctrl_offsetw
	ldr r0, =(0x10C00000+0x0018)
	ldr r1, =(0x8080808)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0018, 0x8080808 );	//- ctrl_offsetw
	ldr r0, =(0x10C10000+0x0018)
	ldr r1, =(0x8080808)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0028, 0x8 );	//- ctrl_offsetd[7:0]=0x8
	ldr r0, =(0x10C00000+0x0028)
	ldr r1, =(0x8)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0028, 0x8 );	//- ctrl_offsetd[7:0]=0x8
	ldr r0, =(0x10C10000+0x0028)
	ldr r1, =(0x8)
	str r1, [r0]
	@Outp32( 0x10C00000+0x0030, 0x10100030 );	//- ctrl_force[14:8]=0x0, ctrl_start[6]=0, ctrl_dll_on[5]=1
	ldr r0, =(0x10C00000+0x0030)
	ldr r1, =(0x10100030)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0030, 0x10100030 );	//- ctrl_force[14:8]=0x0, ctrl_start[6]=0, ctrl_dll_on[5]=1
	ldr r0, =(0x10C10000+0x0030)
	ldr r1, =(0x10100030)
	str r1, [r0]
@DMC_Delay(1ms);
bl	delay
	@Outp32( 0x10C00000+0x0030, 0x10100070 );	//- ctrl_dll_start[6]=1
	ldr r0, =(0x10C00000+0x0030)
	ldr r1, =(0x10100070)
	str r1, [r0]
	@Outp32( 0x10C10000+0x0030, 0x10100070 );	//- ctrl_dll_start[6]=1
	ldr r0, =(0x10C10000+0x0030)
	ldr r1, =(0x10100070)
	str r1, [r0]
@DMC_Delay(1ms);
bl	delay
@DMC_Delay(1ms);
bl	delay
	@Outp32( 0x10DD0000+0x0018, 0xe0000008 );	//- mem_term_en[31]=1, phy_term_en[30]=1, gate signal length[29]=1, fp_resync[3]=1
	ldr r0, =(0x10DD0000+0x0018)
	ldr r1, =(0xe0000008)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0018, 0xe0000000 );	//- mem_term_en[31]=1, phy_term_en[30]=1, gate signal length[29]=1, fp_resync[3]=0
	ldr r0, =(0x10DD0000+0x0018)
	ldr r1, =(0xe0000000)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0018, 0xe0000008 );	//- mem_term_en[31]=1, phy_term_en[30]=1, gate signal length[29]=1, fp_resync[3]=1
	ldr r0, =(0x10DD0000+0x0018)
	ldr r1, =(0xe0000008)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0018, 0xe0000000 );	//- mem_term_en[31]=1, phy_term_en[30]=1, gate signal length[29]=1, fp_resync[3]=0
	ldr r0, =(0x10DD0000+0x0018)
	ldr r1, =(0xe0000000)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0000, 0x0FFF0000|(0x3<<12.) );	//- dfi_init_start[28]=0, rd_fetch[14:12]=3
	ldr r0, =(0x10DD0000+0x0000)
	ldr r1, =(0x0FFF0000|(0x3<<12))
	str r1, [r0]
	@Outp32( 0x10DD0000+0x00F0, 0x3 );	//- channel interleaving
	ldr r0, =(0x10DD0000+0x00F0)
	ldr r1, =(0x3)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0008, 0x00001333 );	//- bank interleaving
	ldr r0, =(0x10DD0000+0x0008)
	ldr r1, =(0x00001333)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x000C, 0x00001333 );	//- bank interleaving
	ldr r0, =(0x10DD0000+0x000C)
	ldr r1, =(0x00001333)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x010C, 0x00400780 );	//- chip_base[26:16]=40, chip_mask[10:0]=780
	ldr r0, =(0x10DD0000+0x010C)
	ldr r1, =(0x00400780)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0110, 0x00800780 );	//- chip_base[26:16]=80, chip_mask[10:0]=780
	ldr r0, =(0x10DD0000+0x0110)
	ldr r1, =(0x00800780)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0014, 0xFF000000 );	//- precharge policy counter
	ldr r0, =(0x10DD0000+0x0014)
	ldr r1, =(0xFF000000)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0028, 0xFFFF00FF );	//- low power counter
	ldr r0, =(0x10DD0000+0x0028)
	ldr r1, =(0xFFFF00FF)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0030, 0x000000bb );	//- refresh counter
	ldr r0, =(0x10DD0000+0x0030)
	ldr r1, =(0x000000bb)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0034, 0x8C36650E );	//- timing row
	ldr r0, =(0x10DD0000+0x0034)
	ldr r1, =(0x8C36650E)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0038, 0x3630580B );	//- timing data
	ldr r0, =(0x10DD0000+0x0038)
	ldr r1, =(0x3630580B)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x003C, 0x41000A44 );	//- timing power
	ldr r0, =(0x10DD0000+0x003C)
	ldr r1, =(0x41000A44)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0010, 0x01000000 );	//- Issue PALL
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x01000000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x01100000 );	//- Issue PALL
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x01100000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x11000000 );	//- Issue PALL
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x11000000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x11100000 );	//- Issue PALL
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x11100000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x07000000 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x07000000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x00020000|0x18 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x00020000|0x18)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x00030000 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x00030000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x00010000|0x42 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x00010000|0x42)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x00000000|0xD70 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x00000000|0xD70)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x0a000000 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x0a000000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x17000000 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x17000000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x10020000|0x18 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x10020000|0x18)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x10030000 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x10030000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x10010000|0x42 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x10010000|0x42)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x10000000|0xD70 );
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x10000000|0xD70)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0010, 0x1a000000 );	//- ZQInit
	ldr r0, =(0x10DD0000+0x0010)
	ldr r1, =(0x1a000000)
	str r1, [r0]
@DMC_Delay(100ms);
bl	delay100
	@Outp32( 0x10DD0000+0x0004, 0x00302620 );	//- bl[22:20]=8, mem_type[11:8]=7, dsref_en[5]=1, dpwrdn_en[1]=1, clk_stop_en[0]=1
	ldr r0, =(0x10DD0000+0x0004)
	ldr r1, =(0x00302620)
	str r1, [r0]
	@Outp32( 0x10DD0000+0x0000, 0x0FFF0020|(0x3<<12.) );	//- dfi_init_start[28]=1, rd_fetch[14:12]=3, aref_en[5]=1
	ldr r0, =(0x10DD0000+0x0000)
	ldr r1, =(0x0FFF0020|(0x3<<12))
	str r1, [r0]

	b	mem_ctrl_init_done

	.globl dmc_delay
dmc_delay:
	subs	r0, r0, #1
	bne	dmc_delay
	mov	pc, lr

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
