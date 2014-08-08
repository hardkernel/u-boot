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

#ifndef _VAL_SMDK5410_H
#define _VAL_SMDK5410_H

#include <config.h>
#include <version.h>


/*******************************************************************************
 * PLL LOCK
 ******************************************************************************/
#define APLL_LOCK_OFFSET		0x00000
#define KPLL_LOCK_OFFSET		0x28000
#define BPLL_LOCK_OFFSET		0x20010
#define CPLL_LOCK_OFFSET		0x10020
#define MPLL_LOCK_OFFSET		0x04000

#define APLL_LOCK_VAL			(0x320)
#define MPLL_LOCK_VAL			(0x258)
#define BPLL_LOCK_VAL			(0x258)
#define CPLL_LOCK_VAL			(0x258)
#define KPLL_LOCK_VAL			(0x258)


/*******************************************************************************
 * SRC
 ******************************************************************************/
#define CLK_SRC_CPU_OFFSET		0x00200
#define CLK_SRC_CORE0_OFFSET		0x04200
#define CLK_SRC_CORE1_OFFSET		0x04204
#define CLK_SRC_TOP0_OFFSET		0x10210
#define CLK_SRC_TOP1_OFFSET		0x10214
#define CLK_SRC_TOP2_OFFSET		0x10218
#define CLK_SRC_FSYS_OFFSET		0x10244
#define CLK_SRC_CDREX_OFFSET		0x20200
#define CLK_SRC_KFC_OFFSET		0x28200

#define CLK_SRC_CORE0_VAL		(0x00090000)
#define CLK_SRC_CORE1_VAL		(0x0)
#define CLK_SRC_TOP0_VAL		(0x00000000)
#define CLK_SRC_TOP1_VAL		(0x1 << 20)
#define CLK_SRC_TOP2_VAL		(0x01100000)
#define CLK_SRC_FSYS_VAL		(0x30000666)
#ifndef CONFIG_CPU_EXYNOS5410_EVT0
#define CLKDIV4_RATIO_VAL		(0x00000303)
#else
#define CLKDIV4_RATIO_VAL		(0x00000313)
#endif
#define CLK_SRC_CDREX_VAL		(0x00001000)


/*******************************************************************************
 * DIV
 ******************************************************************************/
#define CLK_DIV_CPU0_OFFSET		0x00500
#define CLK_DIV_CPU1_OFFSET		0x00504
#define CLK_DIV_CORE1_OFFSET		0x04504
#define CLK_DIV_G2D_OFFSET		0x08500
#define CLK_DIV_TOP0_OFFSET		0x10510
#define CLK_DIV_TOP1_OFFSET		0x10514
#define CLK_DIV_FSYS0_OFFSET		0x10548
#define CLK_DIV_FSYS1_OFFSET		0x1054C
#define CLK_DIV_FSYS2_OFFSET		0x10550
#define CLK_DIV_FSYS3_OFFSET		0x10554
#define CLKDIV4_RATIO_OFFSET		0x105A0
#define CLK_DIV_CDREX0_OFFSET		0x20500
#define CLK_DIV_CDREX1_OFFSET		0x20504
#define CLK_DIV_KFC0_OFFSET		0x28500

/* DIV CPU0 VAL	*/
#if defined(CONFIG_CPU_EXYNOS5410_EVT2)
#if defined(CONFIG_CLK_ARM_2000)
#define CLK_DIV_CPU0_VAL		(0x03770040)
#elif defined(CONFIG_CLK_ARM_1900)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1800)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1700)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1600)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1500)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1400)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1300)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1200)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1100)
#define CLK_DIV_CPU0_VAL		(0x03770030)
#elif defined(CONFIG_CLK_ARM_1000)
#define CLK_DIV_CPU0_VAL		(0x03660030)
#elif defined(CONFIG_CLK_ARM_900)
#define CLK_DIV_CPU0_VAL		(0x03660070)
#elif defined(CONFIG_CLK_ARM_800)
#define CLK_DIV_CPU0_VAL		(0x03550030)
#elif defined(CONFIG_CLK_ARM_700)
#define CLK_DIV_CPU0_VAL		(0x03550030)
#elif defined(CONFIG_CLK_ARM_600)
#define CLK_DIV_CPU0_VAL		(0x03440020)
#elif defined(CONFIG_CLK_ARM_500)
#define CLK_DIV_CPU0_VAL		(0x03330020)
#elif defined(CONFIG_CLK_ARM_400)
#define CLK_DIV_CPU0_VAL		(0x03330010)
#elif defined(CONFIG_CLK_ARM_300)
#define CLK_DIV_CPU0_VAL		(0x03330010)
#elif defined(CONFIG_CLK_ARM_200)
#define CLK_DIV_CPU0_VAL		(0x03330010)
#endif
#elif defined(CONFIG_CPU_EXYNOS5410_EVT1)
#if defined(CONFIG_CLK_ARM_1200)
#define CLK_DIV_CPU0_VAL		(0x03660030)
#elif defined(CONFIG_CLK_ARM_1100)
#define CLK_DIV_CPU0_VAL		(0x02660030)
#elif defined(CONFIG_CLK_ARM_1000)
#define CLK_DIV_CPU0_VAL		(0x02660030)
#elif defined(CONFIG_CLK_ARM_900)
#define CLK_DIV_CPU0_VAL		(0x02660020)
#elif defined(CONFIG_CLK_ARM_800)
#define CLK_DIV_CPU0_VAL		(0x01550020)
#elif defined(CONFIG_CLK_ARM_600)
#define CLK_DIV_CPU0_VAL		(0x01440020)
#elif defined(CONFIG_CLK_ARM_533)
#define CLK_DIV_CPU0_VAL		(0x00230010)
#elif defined(CONFIG_CLK_ARM_400)
#define CLK_DIV_CPU0_VAL		(0x01330010)
#elif defined(CONFIG_CLK_ARM_333)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#elif defined(CONFIG_CLK_ARM_300)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#elif defined(CONFIG_CLK_ARM_200)
#define CLK_DIV_CPU0_VAL		(0x01330010)
#elif defined(CONFIG_CLK_ARM_100)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#endif
#else /* CONFIG_CPU_EXYNOS5410_EVT0 */
#if defined(CONFIG_CLK_ARM_1200)
#define CLK_DIV_CPU0_VAL		(0x03460030)
#elif defined(CONFIG_CLK_ARM_1100)
#define CLK_DIV_CPU0_VAL		(0x02460030)
#elif defined(CONFIG_CLK_ARM_1000)
#define CLK_DIV_CPU0_VAL		(0x02460030)
#elif defined(CONFIG_CLK_ARM_900)
#define CLK_DIV_CPU0_VAL		(0x02360030)
#elif defined(CONFIG_CLK_ARM_800)
#define CLK_DIV_CPU0_VAL		(0x01340020)
#elif defined(CONFIG_CLK_ARM_600)
#define CLK_DIV_CPU0_VAL		(0x00240020)
#elif defined(CONFIG_CLK_ARM_533)
#define CLK_DIV_CPU0_VAL		(0x00230010)
#elif defined(CONFIG_CLK_ARM_400)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#elif defined(CONFIG_CLK_ARM_333)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#elif defined(CONFIG_CLK_ARM_300)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#elif defined(CONFIG_CLK_ARM_200)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#elif defined(CONFIG_CLK_ARM_100)
#define CLK_DIV_CPU0_VAL		(0x00130010)
#endif
#endif

/* DIV KFC VAL	*/
#if defined(CONFIG_CPU_EXYNOS5410_EVT2)
#if defined(CONFIG_CLK_KFC_1300)
#define CLK_DIV_KFC0_VAL		(0x03600130)
#elif defined(CONFIG_CLK_KFC_1200)
#define CLK_DIV_KFC0_VAL		(0x03500130)
#elif defined(CONFIG_CLK_KFC_1100)
#define CLK_DIV_KFC0_VAL		(0x03500130)
#elif defined(CONFIG_CLK_KFC_1000)
#define CLK_DIV_KFC0_VAL		(0x03500130)
#elif defined(CONFIG_CLK_KFC_900)
#define CLK_DIV_KFC0_VAL		(0x03500120)
#elif defined(CONFIG_CLK_KFC_800)
#define CLK_DIV_KFC0_VAL		(0x03500120)
#elif defined(CONFIG_CLK_KFC_700)
#define CLK_DIV_KFC0_VAL		(0x03400120)
#elif defined(CONFIG_CLK_KFC_600)
#define CLK_DIV_KFC0_VAL		(0x03400170)
#elif defined(CONFIG_CLK_KFC_500)
#define CLK_DIV_KFC0_VAL		(0x03400120)
#elif defined(CONFIG_CLK_KFC_400)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_300)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_200)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#endif
#elif defined(CONFIG_CPU_EXYNOS5410_EVT1)
#if defined(CONFIG_CLK_KFC_1200)
#define CLK_DIV_KFC0_VAL		(0x01500120)
#elif defined(CONFIG_CLK_KFC_1000)
#define CLK_DIV_KFC0_VAL		(0x01400120)
#elif defined(CONFIG_CLK_KFC_800)
#define CLK_DIV_KFC0_VAL		(0x01300120)
#elif defined(CONFIG_CLK_KFC_600)
#define CLK_DIV_KFC0_VAL		(0x01300010)
#elif defined(CONFIG_CLK_KFC_432)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_400)
#define CLK_DIV_KFC0_VAL		(0x00300110)
#elif defined(CONFIG_CLK_KFC_350)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_330)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_300)
#define CLK_DIV_KFC0_VAL		(0x00300110)
#elif defined(CONFIG_CLK_KFC_200)
#define CLK_DIV_KFC0_VAL		(0x00300110)
#elif defined(CONFIG_CLK_KFC_100)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#endif
#else /* CONFIG_CPU_EXYNOS5410_EVT0 */
#if defined(CONFIG_CLK_KFC_1200)
#define CLK_DIV_KFC0_VAL		(0x03300120)
#elif defined(CONFIG_CLK_KFC_1000)
#define CLK_DIV_KFC0_VAL		(0x03300120)
#elif defined(CONFIG_CLK_KFC_800)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_600)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_432)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_400)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_350)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_330)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_300)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_200)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#elif defined(CONFIG_CLK_KFC_100)
#define CLK_DIV_KFC0_VAL		(0x03300110)
#endif
#endif

/* DIV values */
#define CLK_DIV_CORE1_VAL		(0x00000F00)
#if defined(CONFIG_CPU_EXYNOS5410_EVT2)
#define CLK_DIV_TOP0_VAL		(0x02112303)
#define CLK_DIV_TOP1_VAL		(0x71700000)
#elif defined(CONFIG_CPU_EXYNOS5410_EVT1)
#define CLK_DIV_TOP0_VAL		(0x03123303)
#define CLK_DIV_TOP1_VAL		(0x32700000)
#else
#define CLK_DIV_TOP0_VAL		(0x01123305)
#define CLK_DIV_TOP1_VAL		(0x31100000)
#endif
#define CLK_DIV_G2D_VAL			(0x00000011)
#define CLK_DIV_FSYS0_VAL		(0x0)
#define CLK_DIV_FSYS1_VAL		(0x000A000A)
#define CLK_DIV_FSYS2_VAL		(0x0000000A)
#define CLK_DIV_CDREX0_VAL		(0x31010100)
#define CLK_DIV_CDREX1_VAL		(0x00000011)


/*******************************************************************************
 * PLL CON
 ******************************************************************************/
/* APLL	*/
#define APLL_CON0_OFFSET		0x00100
#define APLL_CON1_OFFSET		0x00104

#if defined(CONFIG_CLK_ARM_2000)
#define APLL_CON0_VAL			(0x80FA0300)
#elif defined(CONFIG_CLK_ARM_1900)
#define APLL_CON0_VAL			(0x81DB0600)
#elif defined(CONFIG_CLK_ARM_1800)
#define APLL_CON0_VAL			(0x80E10300)
#elif defined(CONFIG_CLK_ARM_1700)
#define APLL_CON0_VAL			(0x81A90600)
#elif defined(CONFIG_CLK_ARM_1600)
#define APLL_CON0_VAL			(0x80C80300)
#elif defined(CONFIG_CLK_ARM_1500)
#define APLL_CON0_VAL			(0x80FA0400)
#elif defined(CONFIG_CLK_ARM_1400)
#define APLL_CON0_VAL			(0x80AF0300)
#elif defined(CONFIG_CLK_ARM_1300)
#define APLL_CON0_VAL			(0x81450600)
#elif defined(CONFIG_CLK_ARM_1200)
#define APLL_CON0_VAL			(0x80C80201)
#elif defined(CONFIG_CLK_ARM_1100)
#define APLL_CON0_VAL			(0x81130301)
#elif defined(CONFIG_CLK_ARM_1000)
#define APLL_CON0_VAL			(0x80FA0301)
#elif defined(CONFIG_CLK_ARM_900)
#define APLL_CON0_VAL			(0x80960201)
#elif defined(CONFIG_CLK_ARM_800)
#define APLL_CON0_VAL			(0x80C80301)
#elif defined(CONFIG_CLK_ARM_700)
#define APLL_CON0_VAL			(0x80AF0301)
#elif defined(CONFIG_CLK_ARM_600)
#define APLL_CON0_VAL			(0x80C80202)
#elif defined(CONFIG_CLK_ARM_533)
#define APLL_CON0_VAL			(0x810A0302)
#elif defined(CONFIG_CLK_ARM_500)
#define APLL_CON0_VAL			(0x80FA0302)
#elif defined(CONFIG_CLK_ARM_400)
#define APLL_CON0_VAL			(0x80C80302)
#elif defined(CONFIG_CLK_ARM_333)
#define APLL_CON0_VAL			(0x80DE0402)
#elif defined(CONFIG_CLK_ARM_300)
#define APLL_CON0_VAL			(0x81900403)
#elif defined(CONFIG_CLK_ARM_200)
#define APLL_CON0_VAL			(0x80C80303)
#elif defined(CONFIG_CLK_ARM_100)
#define APLL_CON0_VAL			(0x80C80304)
#endif

#define APLL_CON1_VAL			(0x0020F300)

/* KPLL */
#define KPLL_CON0_OFFSET		0x28100
#define KPLL_CON1_OFFSET		0x28104

#if defined(CONFIG_CLK_KFC_1300)
#define KPLL_CON0_VAL			(0x81450600)
#elif defined(CONFIG_CLK_KFC_1200)
#define KPLL_CON0_VAL			(0x80C80201)
#elif defined(CONFIG_CLK_KFC_1100)
#define KPLL_CON0_VAL			(0x81130301)
#elif defined(CONFIG_CLK_KFC_1000)
#define KPLL_CON0_VAL			(0x80FA0301)
#elif defined(CONFIG_CLK_KFC_900)
#define KPLL_CON0_VAL			(0x80960201)
#elif defined(CONFIG_CLK_KFC_800)
#define KPLL_CON0_VAL			(0x80C80301)
#elif defined(CONFIG_CLK_KFC_700)
#define KPLL_CON0_VAL			(0x80AF0301)
#elif defined(CONFIG_CLK_KFC_600)
#define KPLL_CON0_VAL			(0x80C80202)
#elif defined(CONFIG_CLK_KFC_500)
#define KPLL_CON0_VAL			(0x80FA0302)
#elif defined(CONFIG_CLK_KFC_432)
#define KPLL_CON0_VAL			(0x81200402)
#elif defined(CONFIG_CLK_KFC_400)
#define KPLL_CON0_VAL			(0x80C80302)
#elif defined(CONFIG_CLK_KFC_350)
#define KPLL_CON0_VAL			(0x80AF0302)
#elif defined(CONFIG_CLK_KFC_330)
#define KPLL_CON0_VAL			(0x806E0202)
#elif defined(CONFIG_CLK_KFC_300)
#define KPLL_CON0_VAL			(0x80C80203)
#elif defined(CONFIG_CLK_KFC_200)
#define KPLL_CON0_VAL			(0x80C80303)
#elif defined(CONFIG_CLK_KFC_100)
#define KPLL_CON0_VAL			(0x80C80304)
#endif

#define KPLL_CON1_VAL			(0x00200000)

/* BPLL */
#define BPLL_CON0_OFFSET		0x20110
#define BPLL_CON1_OFFSET		0x20114

#define BPLL_CON0_VAL			(0x80C80301)
#define BPLL_CON1_VAL			(0x0020F300)

/* CPLL */
#define CPLL_CON0_OFFSET		0x10120
#define CPLL_CON1_OFFSET		0x10124

#define CPLL_CON0_VAL			(0x80A00301)
#define CPLL_CON1_VAL			(0x0020F300)

/* MPLL */
#define MPLL_CON0_OFFSET		0x04100
#define MPLL_CON1_OFFSET		0x04104

#define MPLL_CON0_VAL			(0x810A0302)
#define MPLL_CON1_VAL			(0x0020F300)


/*******************************************************************************
 * UART
 ******************************************************************************/
#define CLK_SRC_PERIC0_OFFSET		0x10250
#define CLK_DIV_PERIC0_OFFSET		0x10558

#define UART0_OFFSET			0x00000
#define UART1_OFFSET			0x10000
#define UART2_OFFSET			0x20000
#define UART3_OFFSET			0x30000

#define EXYNOS5410_UART_BASE       	0x12C00000

#if defined(CONFIG_SERIAL0)
#define UART_CONSOLE_BASE (EXYNOS5410_UART_BASE + UART0_OFFSET)
#elif defined(CONFIG_SERIAL1)
#define UART_CONSOLE_BASE (EXYNOS5410_UART_BASE + UART1_OFFSET)
#elif defined(CONFIG_SERIAL2)
#define UART_CONSOLE_BASE (EXYNOS5410_UART_BASE + UART2_OFFSET)
#elif defined(CONFIG_SERIAL3)
#define UART_CONSOLE_BASE (EXYNOS5410_UART_BASE + UART3_OFFSET)
#else
#define UART_CONSOLE_BASE (EXYNOS5410_UART_BASE + UART0_OFFSET)
#endif

#define ULCON_OFFSET			0x00
#define UCON_OFFSET			0x04
#define UFCON_OFFSET			0x08
#define UMCON_OFFSET			0x0C
#define UTRSTAT_OFFSET			0x10
#define UERSTAT_OFFSET			0x14
#define UFSTAT_OFFSET			0x18
#define UMSTAT_OFFSET			0x1C
#define UTXH_OFFSET			0x20
#define URXH_OFFSET			0x24
#define UBRDIV_OFFSET			0x28
#define UDIVSLOT_OFFSET			0x2C
#define UINTP_OFFSET			0x30
#define UINTSP_OFFSET			0x34
#define UINTM_OFFSET			0x38
#define UART_ERR_MASK			0xF

/* (SCLK_UART/(115200*16) -1) */
#define UART_UBRDIV_VAL			0x21

/*((((SCLK_UART*10/(115200*16) -10))%10)*16/10)*/
#define UART_UDIVSLOT_VAL		0xb


/*******************************************************************************
 * CLOCK OUT
 ******************************************************************************/
#define CLKOUT_CMU_CPU_OFFSET		0x00A00
#define CLKOUT_CMU_CORE_OFFSET		0x04A00
#define CLKOUT_CMU_TOP_OFFSET		0x10A00
#define CLKOUT_CMU_CDREX_OFFSET		0x20A00


/*******************************************************************************
 * End of smdk5410_val.h
 ******************************************************************************/
#endif
