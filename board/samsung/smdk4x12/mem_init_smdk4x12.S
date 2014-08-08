/*
 * (C) Copyright 2012 Samsung Electronics Co. Ltd
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

#define IV_SIZE					0x1D

#define APB_DMC_0_BASE			0x10600000
#define APB_DMC_1_BASE			0x10610000

#define DMC_CONCONTROL 			0x00
#define DMC_MEMCONTROL 			0x04
#define DMC_MEMCONFIG0 			0x08
#define DMC_MEMCONFIG1 			0x0C
#define DMC_DIRECTCMD 			0x10
#define DMC_PRECHCONFIG 		0x14
#define DMC_PHYCONTROL0 		0x18
#define DMC_PHYCONTROL1 		0x1C
#define DMC_PHYCONTROL2 		0x20
#define DMC_PWRDNCONFIG 		0x28
#define DMC_TIMINGAREF 			0x30
#define DMC_TIMINGROW 			0x34
#define DMC_TIMINGDATA 			0x38
#define DMC_TIMINGPOWER 		0x3C
#define DMC_PHYSTATUS 			0x40
#define DMC_PHYZQCONTROL 		0x44
#define DMC_CHIP0STATUS 		0x48
#define DMC_CHIP1STATUS 		0x4C
#define DMC_AREFSTATUS 			0x50
#define DMC_MRSTATUS 			0x54
#define DMC_PHYTEST0 			0x58
#define DMC_PHYTEST1 			0x5C
#define DMC_QOSCONTROL0 		0x60
#define DMC_QOSCONFIG0 			0x64
#define DMC_QOSCONTROL1 		0x68
#define DMC_QOSCONFIG1 			0x6C
#define DMC_QOSCONTROL2 		0x70
#define DMC_QOSCONFIG2 			0x74
#define DMC_QOSCONTROL3 		0x78
#define DMC_QOSCONFIG3 			0x7C
#define DMC_QOSCONTROL4 		0x80
#define DMC_QOSCONFIG4 			0x84
#define DMC_QOSCONTROL5 		0x88
#define DMC_QOSCONFIG5 			0x8C
#define DMC_QOSCONTROL6 		0x90
#define DMC_QOSCONFIG6 			0x94
#define DMC_QOSCONTROL7 		0x98
#define DMC_QOSCONFIG7 			0x9C
#define DMC_QOSCONTROL8 		0xA0
#define DMC_QOSCONFIG8 			0xA4
#define DMC_QOSCONTROL9 		0xA8
#define DMC_QOSCONFIG9 			0xAC
#define DMC_QOSCONTROL10 		0xB0
#define DMC_QOSCONFIG10 		0xB4
#define DMC_QOSCONTROL11 		0xB8
#define DMC_QOSCONFIG11 		0xBC
#define DMC_QOSCONTROL12 		0xC0
#define DMC_QOSCONFIG12 		0xC4
#define DMC_QOSCONTROL13 		0xC8
#define DMC_QOSCONFIG13 		0xCC
#define DMC_QOSCONTROL14 		0xD0
#define DMC_QOSCONFIG14 		0xD4
#define DMC_QOSCONTROL15 		0xD8
#define DMC_QOSCONFIG15 		0xDC
#define DMC_IVCONTROL	 		0xF0

/*
 * MIU
 */
#define MIU_BASE 			0x10600000 
#define MIU_INTLV_CONFIG		0x400
#define MIU_INTLV_START_ADDR		0x808
#define MIU_MAPPING_UPDATE  	        0x800
#define MIU_INTLV_END_ADDR		0x810

#define MIU_SINGLE_MAPPING0_START_ADDR	0x818
#define MIU_SINGLE_MAPPING0_END_ADDR	0x820
#define MIU_SINGLE_MAPPING1_START_ADDR	0x828
#define MIU_SINGLE_MAPPING1_END_ADDR	0x830


wait_phy_state:
	ldr r1, [r0, #DMC_PHYSTATUS]
	tst r1, #(1<<2)
	beq wait_phy_state
	mov pc, lr

dmc_delay:
	push {lr}
1:	subs r2, r2, #1
	bne 1b
	pop {pc}

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:
	push	{lr}

	/* CLK_DIV_DMC0 on iROM DMC=50MHz for Init DMC */
	ldr	r0, =0x10030000
	ldr	r1, =0x00117713
	ldr	r2, =0x10500 /* CLK_DIV_DMC0_OFFSET */
	str	r1, [r0, r2]

/*****************************************************************/
/*DREX0***********************************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_0_BASE 

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

#ifdef USE_2G_DRAM
	ldr	r1, =0x00212500
#else
	ldr	r1, =0x00202500				
#endif
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x40C01323	
	str	r1, [r0, #DMC_MEMCONFIG0]

#ifdef USE_2G_DRAM
	ldr	r1, =0x80C01323
	str     r1, [r0, #DMC_MEMCONFIG1]
#endif

	ldr	r1, =(0x80000000 | IV_SIZE)
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r1, =0x64000000			
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x9C4000FF			
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x0000005D    				
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

#if defined(CONFIG_CLK_BUS_DMC_200_400)
	ldr	r1, =0x34498691  
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x36330306    				
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x50380365    				
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower
#elif defined(CONFIG_CLK_BUS_DMC_220_440)
	ldr	r1, =0x3A5A8713
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x47400407
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x583E0475
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower
#endif

	/* minimum wait time is 100 nano seconds */
	/* 0x64: wait 250 nano seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x64
	bl dmc_delay

	ldr	r1, =0x07000000       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	/* minimum wait time is 200 micro seconds */
	/* 0x19000: wait 250 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x19000
	bl dmc_delay

	ldr	r1, =0x00071C00       				
	str	r1, [r0, #DMC_DIRECTCMD]

	/* minimum wait time is 20 micro seconds */
	/* 0x2700: wait 25 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x2700
	bl dmc_delay

	ldr	r1, =0x00010BFC       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	/* minimum wait time is 1 micro seconds */
	/* 0x3f0: wait 2.5 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x3f0
	bl dmc_delay

#if defined(CONFIG_CLK_BUS_DMC_200_400)
	ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD] 
	ldr	r1, =0x00000810       				
	str	r1, [r0, #DMC_DIRECTCMD] 
#elif defined(CONFIG_CLK_BUS_DMC_220_440)
	ldr	r1, =0x00000808
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000814
	str	r1, [r0, #DMC_DIRECTCMD]
#endif
	ldr	r1, =0x00000C08       				
	str	r1, [r0, #DMC_DIRECTCMD] 

#ifdef USE_2G_DRAM
	mov	r2, #0x64
	bl dmc_delay

	ldr	r1, =0x07100000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x19000
	bl dmc_delay

	ldr	r1, =0x00171C00
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x2700
	bl dmc_delay

	ldr	r1, =0x00110BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x3f0
	bl dmc_delay

#if defined(CONFIG_CLK_BUS_DMC_200_400)
	ldr	r1, =0x00100608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00100810
	str	r1, [r0, #DMC_DIRECTCMD]
#elif defined(CONFIG_CLK_BUS_DMC_220_440)
	ldr	r1, =0x00100808
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00100814
	str	r1, [r0, #DMC_DIRECTCMD]
#endif
	ldr	r1, =0x00100C08
	str	r1, [r0, #DMC_DIRECTCMD]
#endif

/*****************************************************************/
/*DREX1***********************************************************/
/*****************************************************************/
	ldr	r0, =APB_DMC_1_BASE

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

#ifdef USE_2G_DRAM
	ldr	r1, =0x00212500
#else
	ldr	r1, =0x00202500
#endif
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x40C01323
	str	r1, [r0, #DMC_MEMCONFIG0]

#ifdef USE_2G_DRAM
	ldr	r1, =0x80C01323
	str	r1, [r0, #DMC_MEMCONFIG1]
#endif
	ldr	r1, =(0x80000000 | IV_SIZE)
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r1, =0x64000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x9C4000FF			
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x0000005D
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

#if defined(CONFIG_CLK_BUS_DMC_200_400)
	ldr	r1, =0x34498691  
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x36330306
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x50380365
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower
#elif defined(CONFIG_CLK_BUS_DMC_220_440)
	ldr	r1, =0x3A5A8713
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x47400407
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x583E0475
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower
#endif

	/* minimum wait time is 100 nano seconds */
	/* 0x64: wait 250 nano seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x64
	bl dmc_delay

	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	/* minimum wait time is 200 micro seconds */
	/* 0x19000: wait 250 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x19000
	bl dmc_delay

	ldr	r1, =0x00071C00
	str	r1, [r0, #DMC_DIRECTCMD]

	/* minimum wait time is 20 micro seconds */
	/* 0x2700: wait 25 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x2700
	bl dmc_delay

	ldr	r1, =0x00010BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	/* minimum wait time is 1 micro seconds */
	/* 0x3f0: wait 2.5 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x3f0
	bl dmc_delay

#if defined(CONFIG_CLK_BUS_DMC_200_400)
	ldr	r1, =0x00000608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000810
	str	r1, [r0, #DMC_DIRECTCMD]
#elif defined(CONFIG_CLK_BUS_DMC_220_440)
	ldr	r1, =0x00000808
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000814
	str	r1, [r0, #DMC_DIRECTCMD]
#endif
	ldr	r1, =0x00000C08
	str	r1, [r0, #DMC_DIRECTCMD]

#ifdef USE_2G_DRAM
	mov	r2, #0x64
	bl dmc_delay

	ldr	r1, =0x07100000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x19000
	bl dmc_delay

	ldr	r1, =0x00171C00
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x2700
	bl dmc_delay

	ldr	r1, =0x00110BFC
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x3f0
	bl dmc_delay

#if defined(CONFIG_CLK_BUS_DMC_200_400)
	ldr	r1, =0x00100608
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00100810
	str	r1, [r0, #DMC_DIRECTCMD]
#elif defined(CONFIG_CLK_BUS_DMC_220_440)
	ldr	r1, =0x00100808
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00100814
	str	r1, [r0, #DMC_DIRECTCMD]
#endif
	ldr	r1, =0x00100C08
	str	r1, [r0, #DMC_DIRECTCMD]
#endif

	pop	{pc}

	.globl mem_ctrl_asm_init_ddr3
mem_ctrl_asm_init_ddr3:
	push {lr}

/*****************************************************************/
/*DREX0***********************************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_0_BASE 

	ldr	r1, =0x0
	str	r1, [r0, #DMC_PHYCONTROL2]

	ldr	r1, =0x0
	str	r1, [r0, #0x24]

	ldr	r1, =0xE3855503
	str	r1, [r0, #DMC_PHYZQCONTROL]

	ldr	r1, =0x71101008				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x7110100A				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x20000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x71101008				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x2000008E				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x20000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x2000008E				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x20000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x0FFF30CA
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00302600				
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x40C01323	
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =(0x80000000 | IV_SIZE)
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r1, =0x64000000			
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x9C4000FF			
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x000000BB    				
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

	ldr	r1, =0x4046654F  
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x46400506    				
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x52000A3C    				
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower

	/* minimum wait time is 100 nano seconds */
	/* 0x64: wait 250 nano seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x64
	bl dmc_delay

	ldr	r1, =0x07000000       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	/* minimum wait time is 200 micro seconds */
	/* 0x19000: wait 250 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x19000
	bl dmc_delay

	ldr	r1, =0x00020000       				
	str	r1, [r0, #DMC_DIRECTCMD]

	/* minimum wait time is 20 micro seconds */
	/* 0x2700: wait 25 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x2700
	bl dmc_delay

	ldr	r1, =0x00030000       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	/* minimum wait time is 1 micro seconds */
	/* 0x3f0: wait 2.5 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x3f0
	bl dmc_delay

	ldr	r1, =0x00010000
	str	r1, [r0, #DMC_DIRECTCMD] 
	ldr	r1, =0x00000100       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	mov	r2, #0x3f0
	bl dmc_delay

	ldr	r1, =0x00000420       				
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x3f0
	bl dmc_delay

	ldr	r1, =0x0A000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x3f0
	bl dmc_delay

/*****************************************************************/
/*DREX1***********************************************************/
/*****************************************************************/
	ldr	r0, =APB_DMC_1_BASE 

	ldr	r1, =0x0
	str	r1, [r0, #DMC_PHYCONTROL2]

	ldr	r1, =0x0
	str	r1, [r0, #0x24]

	ldr	r1, =0xE3855503
	str	r1, [r0, #DMC_PHYZQCONTROL]

	ldr	r1, =0x71101008				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x7110100A				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x20000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x71101008				
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x2000008E				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x20000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x2000008E				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x20000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x0FFF30CA
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r1, =0x00302600				
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x40C01323	
	str	r1, [r0, #DMC_MEMCONFIG0]

	ldr	r1, =(0x80000000 | IV_SIZE)
	str	r1, [r0, #DMC_IVCONTROL]

	ldr	r1, =0x64000000			
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x9C4000FF			
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x000000BB    				
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

	ldr	r1, =0x4046654F  
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x46400506    				
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x52000A3C    				
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower

	/* minimum wait time is 100 nano seconds */
	/* 0x64: wait 250 nano seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x64
	bl dmc_delay

	ldr	r1, =0x07000000       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	/* minimum wait time is 200 micro seconds */
	/* 0x19000: wait 250 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x19000
	bl dmc_delay

	ldr	r1, =0x00020000       				
	str	r1, [r0, #DMC_DIRECTCMD]

	/* minimum wait time is 20 micro seconds */
	/* 0x2700: wait 25 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x2700
	bl dmc_delay

	ldr	r1, =0x00030000       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	/* minimum wait time is 1 micro seconds */
	/* 0x3f0: wait 2.5 micro seconds at ARMCLK 1.5 Ghz */
	mov	r2, #0x3f0
	bl dmc_delay

	ldr	r1, =0x00010000
	str	r1, [r0, #DMC_DIRECTCMD] 
	ldr	r1, =0x00000100       				
	str	r1, [r0, #DMC_DIRECTCMD] 

	mov	r2, #0x3f0
	bl dmc_delay

	ldr	r1, =0x00000420       				
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x3f0
	bl dmc_delay

	ldr	r1, =0x0A000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x3f0
	bl dmc_delay


	ldr	r0, =APB_DMC_0_BASE

	ldr	r1, =0x7110100A
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	ldr	r1, =0x20000086
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	ldr	r1, =0x7110100B
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	bl wait_phy_state

	ldr	r1, =0x2000008E
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x20000086
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	bl wait_phy_state

	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0x7110100A
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	ldr	r1, =0x20000086
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	ldr	r1, =0x7110100B
	ldr	r2, =DMC_PHYCONTROL0
	str	r1, [r0, r2]

	bl wait_phy_state

	ldr	r1, =0x2000008E
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]
	ldr	r1, =0x20000086
	ldr	r2, =DMC_PHYCONTROL1
	str	r1, [r0, r2]

	bl wait_phy_state

	ldr	r0, =APB_DMC_0_BASE
	ldr	r2, =DMC_CONCONTROL
	ldr	r1, [r0, r2]
	orr r1, r1, #(1 << 5)
	str r1, [r0, r2]

	ldr	r0, =APB_DMC_1_BASE
	ldr	r2, =DMC_CONCONTROL
	ldr	r1, [r0, r2]
	orr r1, r1, #(1 << 5)
	str r1, [r0, r2]

	ldr	r0, =APB_DMC_0_BASE
	ldr	r2, =DMC_MEMCONTROL
	ldr	r1, [r0, r2]
	orr	r1, r1, #((1 << 4) | (1 << 1) | (1 << 0))
	str	r1, [r0, r2]

	ldr	r0, =APB_DMC_1_BASE
	ldr	r2, =DMC_MEMCONTROL
	ldr	r1, [r0, r2]
	orr	r1, r1, #((1 << 4) | (1 << 1) | (1 << 0))
	str	r1, [r0, r2]

	pop {pc}

