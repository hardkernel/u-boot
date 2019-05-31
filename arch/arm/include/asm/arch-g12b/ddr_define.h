
/*
 * arch/arm/include/asm/arch-txl/ddr_define.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#define CONFIG_BOARD_ID_MASK				0xFF
#define CONFIG_DDR_TYPE_DDR3				0
#define CONFIG_DDR_TYPE_DDR4				1
#define CONFIG_DDR_TYPE_LPDDR4				2
#define CONFIG_DDR_TYPE_LPDDR3				3
#define CONFIG_DDR_TYPE_LPDDR2				4
#define CONFIG_DDR_TYPE_AUTO				0xf

/* ddr channel defines */
#define CONFIG_DDR0_16BIT					1
#define CONFIG_DDR0_RANK0					2
#define CONFIG_DDR0_RANK01					3
#define CONFIG_DDR0_16BIT_2					4
/* CONFIG_DDR_CHL_AUTO mode support RANK0 and RANK0+1 mode auto detect */
#define CONFIG_DDR_CHL_AUTO					0xF
#define CONFIG_DDR0_16BIT_CH0				0x1
#define CONFIG_DDR0_16BIT_RANK01_CH0		0x4
#define CONFIG_DDR0_32BIT_RANK0_CH0			0x2
#define CONFIG_DDR0_32BIT_RANK01_CH01		0x3
#define CONFIG_DDR0_32BIT_16BIT_RANK0_CH0	0x5
#define CONFIG_DDR0_32BIT_16BIT_RANK01_CH0	0x6
#define CONFIG_DDR0_32BIT_RANK01_CH0		0x7
#define CONFIG_DDR0_32BIT_RANK0_CH01		0x8

#define CFG_DDR_BASE_ADDR					0X0
#define CFG_DDR_START_OFFSET				0X00000000 //TXLX SKIP 0MB

/* ddr type identifier */
#define CONFIG_DDR_TIMMING_LPDDR2			0x02
#define CONFIG_DDR_TIMMING_LPDDR3			0x03
#define CONFIG_DDR_TIMMING_DDR3_7			0x07
#define CONFIG_DDR_TIMMING_DDR3_9			0x09
#define CONFIG_DDR_TIMMING_DDR3_11			0x0B
#define CONFIG_DDR_TIMMING_DDR3_12			0x0C
#define CONFIG_DDR_TIMMING_DDR3_13			0x0D
#define CONFIG_DDR_TIMMING_DDR3_14			0x0E

#define CONFIG_DDR_TIMMING_DDR4_1600		0x0F
#define CONFIG_DDR_TIMMING_DDR4_1866		0x10
#define CONFIG_DDR_TIMMING_DDR4_2133		0x11
#define CONFIG_DDR_TIMMING_DDR4_2400		0x12
#define CONFIG_DDR_TIMMING_DDR4_2666		0x13
#define CONFIG_DDR_TIMMING_DDR4_3200		0x14

#define LPDDR_DIE_ROW_COL_R13_C9		0
#define LPDDR_DIE_ROW_COL_R14_C9		1
#define LPDDR_DIE_ROW_COL_R14_C10		2
#define LPDDR_DIE_ROW_COL_R13_C10		3
#define LPDDR_DIE_ROW_COL_R14_C11		4

#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE0		0
#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE1		1
#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE2		2
#define CONFIG_LPDDR3_CA_TRAINING_USE_LANE3		3

#define CONFIG_DDR_FUNC_TEST				(1<<0)

#define CONFIG_DDR_INIT_RETRY_TOTAL			(10)
#define CONFIG_DDR_PCTL_RETRY_TOTAL			(100)

#define DDR_USE_1_RANK(chl_set)	((chl_set == CONFIG_DDR0_RANK0) || \
				(chl_set == CONFIG_DDR0_16BIT))
#define DDR_USE_2_RANK(chl_set)	((chl_set == CONFIG_DDR0_RANK01))

/* DMC_DDR_CTRL defines */
#define DDR_DDR4_ENABLE						(1<<22)
#define DDR_RANK1_ENABLE					(1<<21)
#define DDR_DDR4_BG_ENABLE					(1<<20)
#define DDR_16BIT_ENABLE					(1<<16)

#define DDR_RANK1_SIZE_CTRL					(3)
#define DDR_RANK0_SIZE_CTRL					(0)

/* dram cfg magic */
#define DRAM_CFG_MAGIC							0x2e676663

#define DMC_TEST_SLT_SCAN_FREQUENCY				1
#define DMC_TEST_SLT_OFFSET_DELAY				(1<<1)
#define DMC_TEST_SLT_ENABLE_DDR_SKIP_TRAINING	(1<<6)
#define DMC_TEST_SLT_ENABLE_DDR_DVFS			(1<<7)

/* ddr configs */
#define DDR_RFC_TYPE_DDR3_512Mbx1				0
#define DDR_RFC_TYPE_DDR3_512Mbx2				1
#define DDR_RFC_TYPE_DDR3_512Mbx4				2
#define DDR_RFC_TYPE_DDR3_512Mbx8				3
#define DDR_RFC_TYPE_DDR3_512Mbx16				4
#define DDR_RFC_TYPE_DDR4_2Gbx1					5
#define DDR_RFC_TYPE_DDR4_2Gbx2					6
#define DDR_RFC_TYPE_DDR4_2Gbx4					7
#define DDR_RFC_TYPE_DDR4_2Gbx8					8

#define DDR_RFC_TYPE_LPDDR4_2Gbx1				9
#define DDR_RFC_TYPE_LPDDR4_3Gbx1				10
#define DDR_RFC_TYPE_LPDDR4_4Gbx1				11
#define DDR_RFC_TYPE_LPDDR4_6Gbx1				12
#define DDR_RFC_TYPE_LPDDR4_8Gbx1				13

#define DDR_ENABLE_FINE_TUNE_FLAG_AC_DELAY				(1<<0)
#define DDR_ENABLE_FINE_TUNE_FLAG_WRITE_DQS				(1<<1)
#define DDR_ENABLE_FINE_TUNE_FLAG_READ_DQS				(1<<2)
#define DDR_ENABLE_FINE_TUNE_FLAG_WRITE_DQ				(1<<3)
#define DDR_ENABLE_FINE_TUNE_FLAG_READ_DQ				(1<<4)

/* lpddr3 defines */
#ifndef CONFIG_LPDDR_REMAP_SET
#define CONFIG_LPDDR_REMAP_SET				LPDDR_DIE_ROW_COL_R14_C9
#endif

/* how to add a new ddr function?
   1. add CONFIG_DDR_FUNC_XXX in (config).h file
   2. add define in this file.
      2.1 add
        #ifndef CONFIG_DDR_FUNC_XXX
        #define CONFIG_DDR_FUNC_XXX 0
        #endif
      2.2 add
        #define DDR_FUNC_XXX (CONFIG_FUNC_XXX<<X)
      2.3 add DDR_FUNC_XXX |\ in DDR_FUNC
   3. add same define and parser in bl2 code
   */
/* 2.1, 2,2, 2,3 example */
/*
#ifndef CONFIG_CMD_DDR_D2PLL
#define CONFIG_CMD_DDR_D2PLL				0
#endif
#define DDR_FUNC_D2PLL						(CONFIG_CMD_DDR_D2PLL<<0)
#define DDR_FUNC							(EXISTING_FUNCTIONS) |\
											(DDR_FUNC_D2PLL)
*/

/* d2pll support */
#ifndef CONFIG_CMD_DDR_D2PLL
#define CONFIG_CMD_DDR_D2PLL				0
#endif
#define DDR_FUNC_D2PLL						(CONFIG_CMD_DDR_D2PLL<<0)

/* ddr low power function support */
#ifndef CONFIG_DDR_LOW_POWER
#define CONFIG_DDR_LOW_POWER				0
#endif
#define DDR_FUNC_LP							(CONFIG_DDR_LOW_POWER<<1)

/* ddr zq power down support */
#ifndef CONFIG_DDR_ZQ_PD
#define CONFIG_DDR_ZQ_PD					0
#endif
#define DDR_FUNC_ZQ_PD						(CONFIG_DDR_ZQ_PD<<2)

/* ddr vref function */
#ifndef CONFIG_DDR_USE_EXT_VREF
#define CONFIG_DDR_USE_EXT_VREF				0
#endif
#define DDR_FUNC_EXT_VREF					(CONFIG_DDR_USE_EXT_VREF<<3)

/* ddr4 timing test function */
#ifndef CONFIG_DDR4_TIMING_TEST
#define CONFIG_DDR4_TIMING_TEST				0
#endif
#define DDR_FUNC_DDR4_TIMING_TEST			(CONFIG_DDR4_TIMING_TEST<<4)

/* ddr pll bypass */
#ifndef CONFIG_DDR_PLL_BYPASS
#define CONFIG_DDR_PLL_BYPASS				0
#endif
#define DDR_FUNC_DDR_PLL_BYPASS				(CONFIG_DDR_PLL_BYPASS<<5)

/* ddr rdbi function */
#ifndef CONFIG_DDR_FUNC_RDBI
#define CONFIG_DDR_FUNC_RDBI				0
#endif
#define DDR_FUNC_RDBI						(CONFIG_DDR_FUNC_RDBI<<6)

/* lpddr3 ca trainingi function */
#ifndef CONFIG_DDR_FUNC_LPDDR3_CA
#define CONFIG_DDR_FUNC_LPDDR3_CA				0
#endif
#define DDR_FUNC_LPDDR3_CA					(CONFIG_DDR_FUNC_LPDDR3_CA<<7)

/* print ddr training window */
#ifndef CONFIG_DDR_FUNC_PRINT_WINDOW
#define CONFIG_DDR_FUNC_PRINT_WINDOW		0
#endif
#define DDR_FUNC_PRINT_WINDOW				(CONFIG_DDR_FUNC_PRINT_WINDOW<<8)


/* print ddr training window */
#ifndef CONFIG_DDR_FULL_TEST
#define CONFIG_DDR_FULL_TEST				0
#endif
#define DDR_FULL_TEST						(CONFIG_DDR_FULL_TEST<<10)

/* non-sec region scramble function */
#ifndef CONFIG_DDR_NONSEC_SCRAMBLE
#define CONFIG_DDR_NONSEC_SCRAMBLE			0
#endif
#define DDR_NONSEC_SCRAMBLE					(CONFIG_DDR_NONSEC_SCRAMBLE<<11)

#if(CONFIG_DDR_FUNC_LPDDR3_CA==1)
#if (CONFIG_LPDDR3_CA_TRAINING_CA0==CONFIG_LPDDR3_CA_TRAINING_USE_LANE0)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT0					(0<<20)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT1						(0<<21)
#elif (CONFIG_LPDDR3_CA_TRAINING_CA0==CONFIG_LPDDR3_CA_TRAINING_USE_LANE1)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT0					(1<<20)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT1						(0<<21)
#elif (CONFIG_LPDDR3_CA_TRAINING_CA0==CONFIG_LPDDR3_CA_TRAINING_USE_LANE2)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT0					(0<<20)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT1						(1<<21)
#elif (CONFIG_LPDDR3_CA_TRAINING_CA0==CONFIG_LPDDR3_CA_TRAINING_USE_LANE3)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT0					(1<<20)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT1						(1<<21)
#endif
#if (CONFIG_LPDDR3_CA_TRAINING_CA1==CONFIG_LPDDR3_CA_TRAINING_USE_LANE0)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT0					(0<<22)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT1						(0<<23)
#elif (CONFIG_LPDDR3_CA_TRAINING_CA1==CONFIG_LPDDR3_CA_TRAINING_USE_LANE1)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT0					(1<<22)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT1						(0<<23)
#elif (CONFIG_LPDDR3_CA_TRAINING_CA1==CONFIG_LPDDR3_CA_TRAINING_USE_LANE2)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT0					(0<<22)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT1						(1<<23)
#elif (CONFIG_LPDDR3_CA_TRAINING_CA1==CONFIG_LPDDR3_CA_TRAINING_USE_LANE3)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT0					(1<<22)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT1						(1<<23)
#endif
#else /* CONFIG_DDR_FUNC_LPDDR3_CA != 1 */
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT0					(0<<20)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT1						(0<<21)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT0						(0<<22)
#define DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT1						(0<<23)
#endif /* CONFIG_DDR_FUNC_LPDDR3_CA */

#if(CONFIG_DDR_FUNC_LPDDR3_SOC_ODT_ONLY_UP==1)
#define DDR_FUNC_LPDDR3_SOC_ODT_ONLY_UP						(1<<25)
#else
#define DDR_FUNC_LPDDR3_SOC_ODT_ONLY_UP						(0<<25)
#endif

#define DDR_FUNC							(DDR_FUNC_D2PLL					| \
											DDR_FUNC_LP						| \
											DDR_FUNC_ZQ_PD					| \
											DDR_FUNC_EXT_VREF				| \
											DDR_FUNC_DDR4_TIMING_TEST		| \
											DDR_FUNC_DDR_PLL_BYPASS			| \
											DDR_FUNC_RDBI					| \
											DDR_FUNC_LPDDR3_CA				| \
											DDR_FUNC_PRINT_WINDOW			| \
											DDR_FULL_TEST					| \
											DDR_NONSEC_SCRAMBLE				| \
											DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT0| \
											DDR_FUNC_LPDDR3_CA_TRAINING_CA0_BIT1| \
											DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT0| \
											DDR_FUNC_LPDDR3_CA_TRAINING_CA1_BIT1| \
											DDR_FUNC_LPDDR3_SOC_ODT_ONLY_UP	| \
											(1 << 31) 						\
											)




/* bl2 reg override stages define */
#define BL2_INIT_STAGE_0							0
#define BL2_INIT_STAGE_1							1
#define BL2_INIT_STAGE_2							2
#define BL2_INIT_STAGE_3							3
#define BL2_INIT_STAGE_4							4
#define BL2_INIT_STAGE_5							5
#define BL2_INIT_STAGE_6							6
#define BL2_INIT_STAGE_7							7
#define BL2_INIT_STAGE_8							8
#define BL2_INIT_STAGE_9							9


/* ddr reg override stages define */
#define DDR_OVERRIDE_STAGE_DDR3_PRE_INIT			0x10
#define DDR_OVERRIDE_STAGE_DDR3_DMC_INIT			0x11

#define DDR_OVERRIDE_STAGE_DDR4_PRE_INIT			0x20
#define DDR_OVERRIDE_STAGE_DDR4_DMC_INIT			0x21

#define DDR_OVERRIDE_STAGE_LPDDR3_PRE_INIT			0x30
#define DDR_OVERRIDE_STAGE_LPDDR3_DMC_INIT			0x31

#define DDR_OVERRIDE_STAGE_LPDDR4_PRE_INIT			0x40
#define DDR_OVERRIDE_STAGE_LPDDR4_DMC_INIT			0x41


#define DWC_AC_PINMUX_TOTAL						28
#define DWC_DFI_PINMUX_TOTAL					26
#define DWC_DQ_PINMUX_TOTAL						32

/* diagnose function defines */
#define CONFIG_DIAGNOSE_DISABLE					0x0
#define CONFIG_DIAGNOSE_1D						0x1
#define CONFIG_DIAGNOSE_2D						0x2
#define CONFIG_DIAGNOSE_1D_2D					0x3
