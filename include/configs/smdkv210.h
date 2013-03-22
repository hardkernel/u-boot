/*
 * (C) Copyright 2009 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 * HeungJun Kim <riverful.kim@samsung.com>
 * Inki Dae <inki.dae@samsung.com>
 *
 * Configuation settings for the SAMSUNG SMDKC100 board.
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

#ifndef __CONFIG_H
#define __CONFIG_H

/*
 * High Level Configuration Options
 * (easy to change)
 */
#define CONFIG_ARMV7		1	/* This is an ARM V7 CPU core */
#define CONFIG_SAMSUNG		1	/* in a SAMSUNG core */
#define CONFIG_S5P		1	/* which is in a S5P Family */
#define CONFIG_S5PC110		1	/* which is in a S5PC100 */
#define CONFIG_SMDKC110         1
#define CONFIG_EVT1		1	/* EVT1 */
//#define CONFIG_MCP_SINGLE	1
//#undef NAND_BOOTING         1
//#define CONFIG_SMDKC110_REV03	1	/* Rev 0.3 */

//#define CONFIG_EMMC_4_4		1

/* Memory type options (should be the belows one) */
#define CONFIG_MCP_B		1		/* OneDRAM + mDDR */
//#define CONFIG_MCP_D		1		/* OneDRAM + mDDR */

#define CONFIG_SECURE_BL1_ONLY
#ifdef CONFIG_SECURE_BL1_ONLY
#define CONFIG_FUSED		1		/* Fused chip */
#endif
//#define CONFIG_SECURE_BOOT
#ifdef CONFIG_SECURE_BOOT
#define CONFIG_FUSED		1		/* Fused chip */
#define CONFIG_S5PC210S
#define CONFIG_SECURE_ROOTFS
#define CONFIG_SECURE_KERNEL_BASE	0x30008000
#define CONFIG_SECURE_KERNEL_SIZE	0x300000
#define CONFIG_SECURE_ROOTFS_BASE	0x30a00000
#define CONFIG_SECURE_ROOTFS_SIZE	0x100000
#endif

//#include <asm/arch/cpu.h>		/* get chip and board defs */

#ifdef CONFIG_MCP_SINGLE
//#define CONFIG_CLK_667_166_166_133
//#define CONFIG_CLK_533_133_100_100
//#define CONFIG_CLK_800_200_166_133
//#define CONFIG_CLK_800_100_166_133
#define CONFIG_CLK_1000_200_166_133
//#define CONFIG_CLK_400_200_166_133
//#define CONFIG_CLK_400_100_166_133

#if defined(CONFIG_CLK_667_166_166_133)
#define APLL_MDIV       0xfa
#define APLL_PDIV       0x6
#define APLL_SDIV       0x1
#elif defined(CONFIG_CLK_533_133_100_100)
#define APLL_MDIV       0x215
#define APLL_PDIV       0x18
#define APLL_SDIV       0x1
#elif defined(CONFIG_CLK_800_200_166_133) || \
	defined(CONFIG_CLK_800_100_166_133) || \
	defined(CONFIG_CLK_400_200_166_133) || \
	defined(CONFIG_CLK_400_100_166_133)
#define APLL_MDIV       0x64
#define APLL_PDIV       0x3
#define APLL_SDIV       0x1
#elif defined(CONFIG_CLK_1000_200_166_133)
#define APLL_MDIV       0x7d
#define APLL_PDIV       0x3
#define APLL_SDIV       0x1
#endif

#define APLL_LOCKTIME_VAL	0x2cf

#if defined(CONFIG_EVT1)
/* Set AFC value */
#define AFC_ON		0x00000000
#define AFC_OFF		0x10000010
#endif

#if defined(CONFIG_CLK_533_133_100_100)
#define MPLL_MDIV	0x190
#define MPLL_PDIV	0x6
#define MPLL_SDIV	0x2
#else
#define MPLL_MDIV	0x29b
#define MPLL_PDIV	0xc
#define MPLL_SDIV	0x1
#endif

#define EPLL_MDIV	0x60
#define EPLL_PDIV	0x6
#define EPLL_SDIV	0x2

#define VPLL_MDIV	0x6c
#define VPLL_PDIV	0x6
#define VPLL_SDIV	0x3

/* CLK_DIV0 */
#define APLL_RATIO	0
#define A2M_RATIO	4
#define HCLK_MSYS_RATIO	8
#define PCLK_MSYS_RATIO	12
#define HCLK_DSYS_RATIO	16
#define PCLK_DSYS_RATIO 20
#define HCLK_PSYS_RATIO	24
#define PCLK_PSYS_RATIO 28

#define CLK_DIV0_MASK	0x7fffffff

#define set_pll(mdiv, pdiv, sdiv)	(1<<31 | mdiv<<16 | pdiv<<8 | sdiv)

#define APLL_VAL	set_pll(APLL_MDIV,APLL_PDIV,APLL_SDIV)
#define MPLL_VAL	set_pll(MPLL_MDIV,MPLL_PDIV,MPLL_SDIV)
#define EPLL_VAL	set_pll(EPLL_MDIV,EPLL_PDIV,EPLL_SDIV)
#define VPLL_VAL	set_pll(VPLL_MDIV,VPLL_PDIV,VPLL_SDIV)

#if defined(CONFIG_CLK_667_166_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(3<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_533_133_100_100)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(3<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(3<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_800_200_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(3<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_800_100_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(7<<A2M_RATIO)|(7<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_400_200_166_133)
#define CLK_DIV0_VAL    ((1<<APLL_RATIO)|(3<<A2M_RATIO)|(1<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_400_100_166_133)
#define CLK_DIV0_VAL    ((1<<APLL_RATIO)|(7<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))			
#elif defined(CONFIG_CLK_1000_200_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(4<<A2M_RATIO)|(4<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#endif

#define CLK_DIV1_VAL	((1<<16)|(1<<12)|(1<<8)|(1<<4))
#define CLK_DIV2_VAL	(1<<0)

#if defined(CONFIG_CLK_533_133_100_100)

#if defined(CONFIG_MCP_SINGLE)

#define DMC0_TIMINGA_REF	0x40e
#define DMC0_TIMING_ROW		0x10233206
#define DMC0_TIMING_DATA	0x12130005
#define	DMC0_TIMING_PWR		0x0E100222

#define DMC1_TIMINGA_REF	0x40e
#define DMC1_TIMING_ROW		0x10233206
#define DMC1_TIMING_DATA	0x12130005
#define	DMC1_TIMING_PWR		0x0E100222

#else

#error "You should define memory type (AC type or H type or B type)"

#endif

#elif defined(CONFIG_CLK_800_200_166_133) || \
	defined(CONFIG_CLK_1000_200_166_133) || \
	defined(CONFIG_CLK_800_100_166_133) || \
	defined(CONFIG_CLK_400_200_166_133) || \
	defined(CONFIG_CLK_400_100_166_133)

#if defined(CONFIG_MCP_SINGLE)

#define DMC0_MEMCONFIG_0	0x20E01323	// MemConfig0	256MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
#define DMC0_MEMCONFIG_1	0x40F01323	// MemConfig1
#define DMC0_TIMINGA_REF	0x00000618	// TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4E)
#define DMC0_TIMING_ROW		0x28233287	// TimingRow	for @200MHz
#define DMC0_TIMING_DATA	0x23240304	// TimingData	CL=3
#define	DMC0_TIMING_PWR		0x09C80232	// TimingPower

#define	DMC1_MEMCONTROL		0x00202400	// MemControl	BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
#define DMC1_MEMCONFIG_0	0x40C01323	// MemConfig0	512MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
#define DMC1_MEMCONFIG_1	0x00E01323	// MemConfig1
#define DMC1_TIMINGA_REF	0x00000618	// TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4
#define DMC1_TIMING_ROW		0x28233289	// TimingRow	for @200MHz
#define DMC1_TIMING_DATA	0x23240304	// TimingData	CL=3
#define	DMC1_TIMING_PWR		0x08280232	// TimingPower
#if defined(CONFIG_CLK_800_100_166_133) || defined(CONFIG_CLK_400_100_166_133)
#define DMC0_MEMCONFIG_0	0x20E01323	// MemConfig0	256MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
#define DMC0_MEMCONFIG_1	0x40F01323	// MemConfig1
#define DMC0_TIMINGA_REF	0x0000030C	// TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4E)
#define DMC0_TIMING_ROW		0x28233287	// TimingRow	for @200MHz
#define DMC0_TIMING_DATA	0x23240304	// TimingData	CL=3
#define	DMC0_TIMING_PWR		0x09C80232	// TimingPower

#define	DMC1_MEMCONTROL		0x00202400	// MemControl	BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
#define DMC1_MEMCONFIG_0	0x40C01323	// MemConfig0	512MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
#define DMC1_MEMCONFIG_1	0x00E01323	// MemConfig1
#define DMC1_TIMINGA_REF	0x0000030C	// TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4
#define DMC1_TIMING_ROW		0x28233289	// TimingRow	for @200MHz
#define DMC1_TIMING_DATA	0x23240304	// TimingData	CL=3
#define	DMC1_TIMING_PWR		0x08280232	// TimingPower
#endif

#else

#error "You should define memory type (AC type or H type)"

#endif //

#else

#define DMC0_TIMINGA_REF	0x50e
#define DMC0_TIMING_ROW		0x14233287
#define DMC0_TIMING_DATA	0x12130005
#define	DMC0_TIMING_PWR		0x0E140222

#define DMC1_TIMINGA_REF	0x618
#define DMC1_TIMING_ROW		0x11344309
#define DMC1_TIMING_DATA	0x12130005
#define	DMC1_TIMING_PWR		0x0E190222

#endif

/* DRAM Base */
#define CONFIG_SYS_SDRAM_BASE	0x20000000

#define CONFIG_NR_DRAM_BANKS    2          /* we have 2 bank of DRAM */
#define SDRAM_BANK_SIZE         0x20000000    /* 512 MB */
#define PHYS_SDRAM_1            CONFIG_SYS_SDRAM_BASE /* SDRAM Bank #1 */
#define PHYS_SDRAM_1_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_2            (CONFIG_SYS_SDRAM_BASE + SDRAM_BANK_SIZE) /* SDRAM Bank #2 */
#define PHYS_SDRAM_2_SIZE       SDRAM_BANK_SIZE

#define CONFIG_IDENT_STRING	" for SMDKV210"

/*
 * machine type
 */
#define MACH_TYPE		2456

#else /* CONFIG_MCP_SINGLE */

//#define CONFIG_CLK_667_166_166_133
//#define CONFIG_CLK_533_133_100_100
//#define CONFIG_CLK_800_200_166_133
//#define CONFIG_CLK_800_100_166_133
#define CONFIG_CLK_1000_200_166_133
//#define CONFIG_CLK_400_200_166_133
//#define CONFIG_CLK_200_200_166_133
//#define CONFIG_CLK_400_100_166_133
//#define CONFIG_CLK_100_100_166_133

#if defined(CONFIG_CLK_667_166_166_133)
#define APLL_MDIV       0xfa
#define APLL_PDIV       0x6
#define APLL_SDIV       0x1
#elif defined(CONFIG_CLK_533_133_100_100)
#define APLL_MDIV       0x215
#define APLL_PDIV       0x18
#define APLL_SDIV       0x1
#elif defined(CONFIG_CLK_800_200_166_133) || \
	defined(CONFIG_CLK_800_100_166_133) || \
	defined(CONFIG_CLK_400_200_166_133) || \
	defined(CONFIG_CLK_400_100_166_133) || \
	defined(CONFIG_CLK_200_200_166_133) || \
	defined(CONFIG_CLK_100_100_166_133)
#define APLL_MDIV       100
#define APLL_PDIV       3
#define APLL_SDIV       1
#elif defined(CONFIG_CLK_1000_200_166_133)
#define APLL_MDIV       125
#define APLL_PDIV       3
#define APLL_SDIV       1
#endif

#if defined(CONFIG_EVT1)
/* Set AFC value */
#define AFC_ON		0x00000000
#define AFC_OFF		0x10000010
#endif

#if defined(CONFIG_CLK_533_133_100_100)
#define MPLL_MDIV	0x190
#define MPLL_PDIV	0x6
#define MPLL_SDIV	0x2
#else
#define MPLL_MDIV	0x29b
#define MPLL_PDIV	0xc
#define MPLL_SDIV	0x1
#endif

#define EPLL_MDIV	0x60
#define EPLL_PDIV	0x6
#define EPLL_SDIV	0x2

#define VPLL_MDIV	0x6c
#define VPLL_PDIV	0x6
#define VPLL_SDIV	0x3

/* CLK_DIV0 */
#define APLL_RATIO	0
#define A2M_RATIO	4
#define HCLK_MSYS_RATIO	8
#define PCLK_MSYS_RATIO	12
#define HCLK_DSYS_RATIO	16
#define PCLK_DSYS_RATIO 20
#define HCLK_PSYS_RATIO	24
#define PCLK_PSYS_RATIO 28

#define CLK_DIV0_MASK	0x7fffffff

#define set_pll(mdiv, pdiv, sdiv)	(1<<31 | mdiv<<16 | pdiv<<8 | sdiv)

#define APLL_VAL	set_pll(APLL_MDIV,APLL_PDIV,APLL_SDIV)
#define MPLL_VAL	set_pll(MPLL_MDIV,MPLL_PDIV,MPLL_SDIV)
#define EPLL_VAL	set_pll(EPLL_MDIV,EPLL_PDIV,EPLL_SDIV)
#define VPLL_VAL	set_pll(VPLL_MDIV,VPLL_PDIV,VPLL_SDIV)

#if defined(CONFIG_CLK_667_166_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(3<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_533_133_100_100)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(3<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(3<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_800_200_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(3<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_800_100_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(7<<A2M_RATIO)|(7<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_400_200_166_133)
#define CLK_DIV0_VAL    ((1<<APLL_RATIO)|(3<<A2M_RATIO)|(1<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_200_200_166_133)
#define CLK_DIV0_VAL    ((3<<APLL_RATIO)|(3<<A2M_RATIO)|(0<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_100_100_166_133)
#define CLK_DIV0_VAL    ((7<<APLL_RATIO)|(7<<A2M_RATIO)|(0<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#elif defined(CONFIG_CLK_400_100_166_133)
#define CLK_DIV0_VAL    ((1<<APLL_RATIO)|(7<<A2M_RATIO)|(3<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))			
#elif defined(CONFIG_CLK_1000_200_166_133)
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(4<<A2M_RATIO)|(4<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))
#endif
/* End CLK_DIV0 */

#define CLK_DIV1_VAL	((1<<16)|(1<<12)|(1<<8)|(1<<4))
#if defined(CONFIG_MCP_D)
/* Set G3D/MFC divider */
#if defined(CONFIG_CLK_1000_200_166_133)
#define CLK_DIV2_VAL	(4<<0) | (4<<4)
#elif defined(CONFIG_CLK_800_200_166_133)
#define CLK_DIV2_VAL	(3<<0) | (3<<4)
#else
#define CLK_DIV2_VAL	(1<<0)
#endif
#else //CONFIG_MCP_D
#define CLK_DIV2_VAL	(1<<0)
#endif


#if defined(CONFIG_CLK_533_133_100_100)

#if defined(CONFIG_MCP_D)
#define DMC0_TIMINGA_REF	0x40e
#define DMC0_TIMING_ROW		0x10233206
#define DMC0_TIMING_DATA	0x12130005
#define	DMC0_TIMING_PWR		0x0E100222

#define DMC1_TIMINGA_REF	0x40e
#define DMC1_TIMING_ROW		0x10233206
#define DMC1_TIMING_DATA	0x12130005
#define	DMC1_TIMING_PWR		0x0E100222

#else
#define DMC0_TIMINGA_REF	0x40e
#define DMC0_TIMING_ROW		0x14233206
#define DMC0_TIMING_DATA	0x12130005
#define	DMC0_TIMING_PWR		0x0E100222

#define DMC1_TIMINGA_REF	0x40e
#define DMC1_TIMING_ROW		0x10233206
#define DMC1_TIMING_DATA	0x12130005
#define	DMC1_TIMING_PWR		0x0E100222
#endif

#elif defined(CONFIG_CLK_800_200_166_133) || \
	defined(CONFIG_CLK_1000_200_166_133) || \
	defined(CONFIG_CLK_800_100_166_133) || \
	defined(CONFIG_CLK_400_200_166_133) || \
	defined(CONFIG_CLK_200_200_166_133) || \
	defined(CONFIG_CLK_100_100_166_133) || \
	defined(CONFIG_CLK_400_100_166_133)

#if defined(CONFIG_MCP_B) || defined(CONFIG_MCP_D)

#define DMC0_MEMCONFIG_0	0x30F82222
#define DMC0_MEMCONFIG_1	0x40F82222
#define DMC0_TIMINGA_REF	0x0000050E
#define DMC0_TIMING_ROW		0x14233287
#define DMC0_TIMING_DATA	0x12130005
#define	DMC0_TIMING_PWR		0x0E140222

#define	DMC1_MEMCONTROL		0x00212100
#define DMC1_MEMCONFIG_0	0x40F01322
#define DMC1_MEMCONFIG_1	0x50F81312
#define DMC1_TIMINGA_REF	0x00000618
#define DMC1_TIMING_ROW		0x182332C8
#define DMC1_TIMING_DATA	0x23130005
#define	DMC1_TIMING_PWR		0x0E180222
#if defined(CONFIG_CLK_800_100_166_133) || defined(CONFIG_CLK_400_100_166_133) || defined(CONFIG_CLK_100_100_166_133)
#define DMC0_MEMCONFIG_0	0x30F82222	// MemConfig0	256MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
#define DMC0_MEMCONFIG_1	0x40F82222	// MemConfig1
#define DMC0_TIMINGA_REF	0x0000030C	// TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4E)
#define DMC0_TIMING_ROW		0x14233287	// TimingRow	for @200MHz
#define DMC0_TIMING_DATA	0x12130005	// TimingData	CL=3
#define	DMC0_TIMING_PWR		0x0E140222	// TimingPower

#define	DMC1_MEMCONTROL		0x00212100	// MemControl	BL=4, 2 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
#define DMC1_MEMCONFIG_0	0x40F01322	// MemConfig0	512MB config, 8 banks,Mapping Method[12:15]0:linear, 1:linterleaved, 2:Mixed
#define DMC1_MEMCONFIG_1	0x50F81312	// MemConfig1
#define DMC1_TIMINGA_REF	0x0000030C	// TimingAref	7.8us*133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4
#define DMC1_TIMING_ROW		0x11344309	// TimingRow	for @200MHz
#define DMC1_TIMING_DATA	0x12130005	// TimingData	CL=3
#define	DMC1_TIMING_PWR		0x0E190222	// TimingPower
#endif

#else

#error "You should define memory type"

#endif // CONFIG_MCP_B

#else

#define DMC0_TIMINGA_REF	0x50e
#define DMC0_TIMING_ROW		0x14233287
#define DMC0_TIMING_DATA	0x12130005
#define	DMC0_TIMING_PWR		0x0E140222

#define DMC1_TIMINGA_REF	0x618
#define DMC1_TIMING_ROW		0x11344309
#define DMC1_TIMING_DATA	0x12130005
#define	DMC1_TIMING_PWR		0x0E190222

#endif

/* DRAM Base */
#define CONFIG_SYS_SDRAM_BASE	0x30000000

#define CONFIG_NR_DRAM_BANKS	4
#define PHYS_SDRAM_1		CONFIG_SYS_SDRAM_BASE 	/* SDRAM Bank #1 */
#define PHYS_SDRAM_1_SIZE	0x5000000 	/* 80 MB */

#if defined(CONFIG_MCP_B)
#define PHYS_SDRAM_2		CONFIG_SYS_SDRAM_BASE + 0x10000000	/* SDRAM Bank #2 */
#define PHYS_SDRAM_2_SIZE	0x10000000 	/* 256 MB */
#define CONFIG_IDENT_STRING	" for SMDKC110 B Type"
#elif defined(CONFIG_MCP_D)
#define PHYS_SDRAM_2		CONFIG_SYS_SDRAM_BASE + 0x10000000	/* SDRAM Bank #2 */
#define PHYS_SDRAM_2_SIZE	0x10000000 	/* 256 MB */
#define PHYS_SDRAM_3		PHYS_SDRAM_2 + 0x10000000	/* SDRAM Bank #3 */
#define PHYS_SDRAM_3_SIZE	0x08000000 	/* 128 MB */
#define CONFIG_IDENT_STRING	" for SMDKC110 D Type"
#endif

/*
 * machine type
 */
#define MACH_TYPE		2193

#endif /* CONFIG_MCP_SINGLE */


#if defined(CONFIG_CLK_533_133_100_100)
#define UART_UBRDIV_VAL		26
#define UART_UDIVSLOT_VAL	0x0808
#else
#define UART_UBRDIV_VAL		34
#define UART_UDIVSLOT_VAL	0xDDDD
#endif

/* eMMC booting */
//#define CONFIG_EMMC		1	/* eMMC 4.3 booting */

#define CONFIG_L2_OFF

//#define CONFIG_ARCH_CPU_INIT

//#define CONFIG_DISPLAY_CPUINFO
//#define CONFIG_DISPLAY_BOARDINFO
//#define BOARD_LATE_INIT

/* input clock of PLL: SMDKV310 has 24MHz input clock */
#define CONFIG_SYS_CLK_FREQ	24000000

/* Sparsemem for 32 kernel */
#define CONFIG_SPARSEMEM	1

#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/*
 * Size of malloc() pool
 * 1MB = 0x100000, 0x100000 = 1024 * 1024
 */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + (1 << 20))

/*
 * select serial console configuration
 */
#define CONFIG_SERIAL2			1	/* use UART CH2 on SMDKC110 */
#define CONFIG_SERIAL_MULTI		1

/* Set UART baudrate */
#if defined(CONFIG_CLK_533_133_100_100)
#define UART_UBRDIV_VAL		26
#define UART_UDIVSLOT_VAL	0x0808
#else
#define UART_UBRDIV_VAL		34
#define UART_UDIVSLOT_VAL	0xDDDD
#endif

#define CONFIG_USB_OHCI
#undef CONFIG_USB_STORAGE
#define CONFIG_S3C_USBD

#define USBD_DOWN_ADDR		0xc0000000

/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE
#define CONFIG_BAUDRATE			115200

/***********************************************************
 * Command definition
 ***********************************************************/
#define CONFIG_SYS_NO_FLASH		1

#include <config_cmd_default.h>

#define CONFIG_CMD_PING
#define CONFIG_CMD_RARP

#define CONFIG_CMD_USB

//#undef CONFIG_CMD_FLASH
//#undef CONFIG_CMD_IMLS
//#undef CONFIG_CMD_FAT
//efine CONFIG_CMD_NAND

//#define CONFIG_CMD_CACHE
//#define CONFIG_CMD_REGINFO
#define CONFIG_CMD_ONENAND
//#define CONFIG_ONENAND
#define CONFIG_CMD_MMC
#define CONFIG_CMD_MOVI
#define CONFIG_CMD_MOVINAND
//#define CONFIG_CMD_ELF
//#define CONFIG_CMD_FAT
//#define CONFIG_CMD_MTDPARTS
//#define CONFIG_MTD_DEVICE

#define CONFIG_CMD_EXT2
#define CONFIG_CMD_FAT

//#define CONFIG_SYS_NAND_QUIET_TEST
//#define CONFIG_SYS_ONENAND_QUIET_TEST

#define CONFIG_MMC
#define CONFIG_GENERIC_MMC
#define CONFIG_S3C_HSMMC
/* The macro for MMC channel 0 is defined by default and can't be undefined */
#define USE_MMC0
#define USE_MMC2
#define MMC_MAX_CHANNEL		4

/*
 * BOOTP options
 */
#define CONFIG_BOOTP_SUBNETMASK
#define CONFIG_BOOTP_GATEWAY
#define CONFIG_BOOTP_HOSTNAME
#define CONFIG_BOOTP_BOOTPATH

#define CONFIG_ETHADDR		00:40:5c:26:0a:5b
#define CONFIG_NETMASK          255.255.255.0
#define CONFIG_IPADDR		192.168.0.20
#define CONFIG_SERVERIP		192.168.0.10
#define CONFIG_GATEWAYIP	192.168.0.1

#define CONFIG_BOOTDELAY	3
#define CONFIG_BOOTCOMMAND	"run ubifsboot"
#define CONFIG_BOOTARGS	""

/*
 * Miscellaneous configurable options
 */
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT_HUSH_PS2	"> "
#define CONFIG_SYS_PROMPT		"SMDKV210 # "
#define CONFIG_SYS_CBSIZE	256	/* Console I/O Buffer Size */
#define CONFIG_SYS_PBSIZE	384	/* Print Buffer Size */
#define CONFIG_SYS_MAXARGS	16	/* max number of command args */
/* Boot Argument Buffer Size */
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
/* memtest works on */
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_SDRAM_BASE + 0x3e00000)

#define CONFIG_SYS_HZ			1000

/* the PWM TImer 4 uses a counter of 41687 for 10 ms, so we need */
/* it to wrap 100 times (total 4168750) to get 1 sec. */
#define CONFIG_SYS_TINEOUT_HZ			4168750		// at PCLK 66MHz
#define CONFIG_TFTP_TIMEOUT		(5 * CONFIG_SYS_TINEOUT_HZ)
#define CONFIG_ARP_TIMEOUT		(5 * CONFIG_SYS_TINEOUT_HZ)

/* valid baudrates */
#define CONFIG_SYS_BAUDRATE_TABLE	{ 9600, 19200, 38400, 57600, 115200 }

/*-----------------------------------------------------------------------
 * Stack sizes
 *
 * The stack sizes are set up in start.S using the settings below
 */
#define CONFIG_STACKSIZE	(256 << 10)	/* 256 KiB */

#define CONFIG_SYS_MONITOR_BASE	0x00000000

/*-----------------------------------------------------------------------
 * FLASH and environment organization
 */

#define CONFIG_SYS_MONITOR_LEN		(256 << 10)	/* 256 KiB */

#define CONFIG_ENABLE_MMU

#ifdef CONFIG_ENABLE_MMU
#define CONFIG_SYS_MAPPED_RAM_BASE	0xc0000000
#define virt_to_phys(x)	virt_to_phy_s5pc110(x)
#else
#define CONFIG_SYS_MAPPED_RAM_BASE	CONFIG_SYS_SDRAM_BASE
#define virt_to_phys(x)	(x)
#endif

#define CONFIG_SYS_LOAD_ADDR		CONFIG_SYS_MAPPED_RAM_BASE + 0x3e00000
#define CONFIG_PHY_UBOOT_BASE		CONFIG_SYS_SDRAM_BASE + 0x3e00000

/*
 *  Fast Boot 
*/
/* Fastboot variables */
#define CFG_FASTBOOT_TRANSFER_BUFFER            (0x40000000)
#define CFG_FASTBOOT_TRANSFER_BUFFER_SIZE       (0x10000000)   /* 256MB */
#define CFG_FASTBOOT_ADDR_KERNEL                (0x30008000)
#define CFG_FASTBOOT_ADDR_RAMDISK               (0x30A00000)
#define CFG_FASTBOOT_PAGESIZE                   (4096)  // Page size of booting device
#define CFG_FASTBOOT_SDMMC_BLOCKSIZE            (512)   // Block size of sdmmc
#define CFG_PARTITION_START			(0x4000000)

/* Just one BSP type should be defined. */
#if defined(CONFIG_CMD_ONENAND) | defined(CONFIG_CMD_NAND) | defined(CONFIG_CMD_MOVINAND)
#define CONFIG_FASTBOOT
#endif

#if defined(CONFIG_CMD_NAND)
#define CFG_FASTBOOT_NANDBSP
#endif
#if defined(CONFIG_CMD_ONENAND)
#define CFG_FASTBOOT_ONENANDBSP
#endif
#if defined(CONFIG_CMD_MOVINAND)
#define CFG_FASTBOOT_SDMMCBSP
#endif

//#define CONFIG_ENV_OFFSET		0x0007C000

/*-----------------------------------------------------------------------
 * Boot configuration
 */
//#define CONFIG_FASTBOOT

#define BOOT_ONENAND		0x1
#define BOOT_NAND		0x2
#define BOOT_MMCSD		0x3
#define BOOT_NOR		0x4
#define BOOT_SEC_DEV		0x5
#define BOOT_EMMC		0x6
#define BOOT_EMMC_4_4		0x7 //SMDKC110/V210 does not exist.

/* nand copy size from nand to DRAM.*/
//#define	COPY_BL2_SIZE		0x80000
//#define CONFIG_SYS_MAX_NAND_DEVICE     1
//#define CFG_NAND_SKIP_BAD_DOT_I	1  /* ".i" read skips bad blocks   */
//#define	CFG_NAND_WP		1
//#define CFG_NAND_YAFFS_WRITE	1  /* support yaffs write */
//#define CFG_NAND_HWECC
//#define CONFIG_NAND_BL1_16BIT_ECC
//#undef	CFG_NAND_FLASH_BBT

//#define CONFIG_SYS_NAND_BASE           (0x0CE00000)
//#define NAND_MAX_CHIPS          1

//#define NAND_DISABLE_CE()	(NFCONT_REG |= (1 << 1))
//#define NAND_ENABLE_CE()	(NFCONT_REG &= ~(1 << 1))
//#define NF_TRANSRnB()		do { while(!(NFSTAT_REG & (1 << 0))); } while(0)

//#define CFG_NAND_SKIP_BAD_DOT_I	1  /* ".i" read skips bad blocks   */
//#define	CFG_NAND_WP		1
//#define CFG_NAND_YAFFS_WRITE	1  /* support yaffs write */

//#define CFG_NAND_HWECC
//#define CONFIG_NAND_BL1_16BIT_ECC
//#undef	CFG_NAND_FLASH_BBT

#define CONFIG_ZIMAGE_BOOT

#define CONFIG_ENV_IS_IN_AUTO	1
#define CONFIG_ENV_SIZE		0x4000

#define CONFIG_DOS_PARTITION	1

//#define CONFIG_SYS_INIT_SP_ADDR	(CONFIG_SYS_LOAD_ADDR - 0x1000000)
#define CONFIG_SYS_INIT_SP_ADDR	(0x33e00000 - 0x1000000)

/*
 * Ethernet Contoller driver
 */
#ifdef CONFIG_CMD_NET
#define CONFIG_NET_MULTI
#define CONFIG_DRIVER_DM9000	1
#define DM9000_16BIT_DATA

#ifdef CONFIG_DRIVER_DM9000
#define CONFIG_DM9000_BASE		(0xA8000000)
#define DM9000_IO			(CONFIG_DM9000_BASE)
#if defined(DM9000_16BIT_DATA)
#define DM9000_DATA			(CONFIG_DM9000_BASE+2)
#else
#define DM9000_DATA			(CONFIG_DM9000_BASE+1)
#endif
#endif

#endif /* CONFIG_CMD_NET */

/* GPIO */
//#define GPIO_BASE	0x11000000

//define CONFIG_SAMSUNG_ONENAND		1

#if defined(CONFIG_CMD_ONENAND)
  #define CONFIG_C110_ONENAND
#endif

#define CFG_ONENAND_BASE 	(0xB0000000)
//#define CFG_ONENANDXL_BASE 	(0x0C600000)
#define CONFIG_SYS_ONENAND_BASE	CFG_ONENAND_BASE
#define CONFIG_SYS_MAX_ONENAND_DEVICE     1

#define CONFIG_BOOT_ONENAND_IROM

#define CFG_PHY_UBOOT_BASE	MEMORY_BASE_ADDRESS + 0x3e00000
//#define CFG_PHY_KERNEL_BASE	MEMORY_BASE_ADDRESS + 0x8000

#define MEMORY_BASE_ADDRESS	0x30000000

#endif	/* __CONFIG_H */
