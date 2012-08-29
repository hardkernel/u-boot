/*
 * Machine Specific Values for ODROIDX board based on Exynos4412
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

#ifndef _ODROIDX_SETUP_H
#define _ODROIDX_SETUP_H

#include <config.h>
#include <version.h>
#include <asm/arch/cpu.h>

/* Set PLL */
#define set_pll(mdiv, pdiv, sdiv)	(1<<31 | mdiv<<16 | pdiv<<8 | sdiv)

/* APLL */
#define	set_clk_div_cpu0(core2, apll, pclk_dbg, atb, periph, corem1, corem0, core) \
					((core2 << 28) \
					|(apll << 24) \
					|(pclk_dbg << 20) \
					|(atb << 16) \
					|(periph <<12) \
					|(corem1 << 8) \
					|(corem0 << 4) \
					|(core))
#define set_clk_div_cpu1(cores, hpm, copy) \
					((cores << 8) \
					|(hpm << 4) \
					|(copy))

#if	(CONFIG_CLK_APLL == 800)
#define APLL_CON0_VAL			set_pll(0x64, 0x3, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 1, 1, 3, 7, 5, 2, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(3, 0, 3)
#elif	(CONFIG_CLK_APLL == 1000)
#define APLL_CON0_VAL			set_pll(0x7D, 0x3, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 1, 1, 4, 7, 5, 2, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(3, 0, 4)
#elif	(CONFIG_CLK_APLL == 1100)
#define APLL_CON0_VAL			set_pll(0x113, 0x6, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 2, 1, 4, 7, 6, 3, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(4, 0, 4)
#elif	(CONFIG_CLK_APLL == 1200)
#define APLL_CON0_VAL			set_pll(0x96, 0x3, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 2, 1, 5, 7, 7, 3, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(4, 0, 4)
#elif	(CONFIG_CLK_APLL == 1300)
#define APLL_CON0_VAL			set_pll(0x145, 0x6, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 2, 1, 5, 7, 7, 3, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(5, 0, 5)
#elif	(CONFIG_CLK_APLL == 1400)
#define APLL_CON0_VAL			set_pll(0xAF, 0x3, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 2, 1, 6, 7, 7, 3, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(5, 0, 6)
#elif	(CONFIG_CLK_APLL == 1500)
#define APLL_CON0_VAL			set_pll(0xFA, 0x3, 0x0)
#define CLK_DIV_CPU0_VAL		set_clk_div_cpu0(0, 2, 1, 6, 7, 7, 4, 0)
#define CLK_DIV_CPU1_VAL		set_clk_div_cpu1(5, 0, 6)
#else
#error	Not supported APLL freq
#endif

#define APLL_CON1_VAL			(0x00803800)
#define APLL_LOCK_VAL			(((APLL_CON0_VAL >> 8) & 0x3F) * 270)

/* EPLL */
#define EPLL_CON0_VAL			set_pll(0x40, 0x2, 0x3)
#define EPLL_CON1_VAL			(0x66010000)
#define EPLL_CON2_VAL			(0x00000080)
#define EPLL_LOCK_VAL			(((EPLL_CON0_VAL >> 8) & 0x3F) * 3000)

/* MPLL */
#if	(CONFIG_CLK_MPLL == 200)
#define MPLL_CON0_VAL			set_pll(0x64, 0x3, 0x1)
#elif	(CONFIG_CLK_MPLL == 330)
#define MPLL_CON0_VAL			set_pll(0x116, 0x5, 0x1)
#elif	(CONFIG_CLK_MPLL == 400)
#define MPLL_CON0_VAL			set_pll(0x64, 0x3, 0x0)
#else
#error	Not supported MPLL freq
#endif
#define MPLL_CON1_VAL			(0x00803800)
#define MPLL_LOCK_VAL			(((MPLL_CON0_VAL >> 8) & 0x3F) * 270)

/* VPLL */
#define VPLL_CON0_VAL			set_pll(0x48, 0x2, 0x3)
#define VPLL_CON1_VAL			(0x66010000)
#define VPLL_CON2_VAL			(0x00000080)
#define VPLL_LOCK_VAL			(((EPLL_CON0_VAL >> 8) & 0x3F) * 3000)

/* CLK_SRC_CPU */
#define MUX_MPLL_USER_SEL		1
#define MUX_HPM_SEL			0
#define MUX_CORE_SEL			0
#define MUX_APLL_SEL			1
#define CLK_SRC_CPU_VAL			((MUX_MPLL_USER_SEL << 24) \
					|(MUX_HPM_SEL << 20) \
					|(MUX_CORE_SEL << 16) \
					|(MUX_APLL_SEL))

/* CLK_SRC_TOP0	*/
#define MUX_ONENAND_SEL			0x0 /* 0 = DOUT133, 1 = DOUT166 */
#define MUX_ACLK_133_SEL		0x0 /* 0 = SCLKMPLL, 1 = SCLKAPLL	*/
#define MUX_ACLK_160_SEL		0x0
#define MUX_ACLK_100_SEL		0x0
#define MUX_ACLK_200_SEL		0x0
#define MUX_VPLL_SEL			0x1
#define MUX_EPLL_SEL			0x1
#define CLK_SRC_TOP0_VAL		((MUX_ONENAND_SEL << 28) \
					|(MUX_ACLK_133_SEL << 24) \
					|(MUX_ACLK_160_SEL << 20) \
					|(MUX_ACLK_100_SEL << 16) \
					|(MUX_ACLK_200_SEL << 12) \
					|(MUX_VPLL_SEL << 8) \
					|(MUX_EPLL_SEL << 4))

/* CLK_SRC_TOP1	*/
#define VPLLSRC_SEL			0x0 /* 0 = FINPLL, 1 = SCLKHDMI27M */
#define CLK_SRC_TOP1_VAL		(0x01111000)

/* CLK_DIV_TOP	*/
#define ACLK_400_MCUISP_RATIO		0x1
#define ACLK_266_GPS_RATIO		0x2
#define ONENAND_RATIO			0x1
#define ACLK_133_RATIO			0x5
#define ACLK_160_RATIO			0x4
#define ACLK_100_RATIO			0x7
#define ACLK_200_RATIO			0x4
#define CLK_DIV_TOP_VAL			((ACLK_400_MCUISP_RATIO << 24) \
					|(ACLK_266_GPS_RATIO << 20) \
					|(ONENAND_RATIO << 16) \
					|(ACLK_133_RATIO << 12) \
					|(ACLK_160_RATIO << 8) \
					|(ACLK_100_RATIO << 4) \
					|(ACLK_200_RATIO))

/* CLK_SRC_LEFTBUS */
#define CLK_SRC_LEFTBUS_VAL		(0x10)

/* CLK_DIV_LEFRBUS */
#define GPL_RATIO			0x1
#define GDL_RATIO			0x3
#define CLK_DIV_LEFTBUS_VAL		((GPL_RATIO << 4)|(GDL_RATIO))

/* CLK_SRC_RIGHTBUS */
#define CLK_SRC_RIGHTBUS_VAL		(0x10)

/* CLK_DIV_RIGHTBUS */
#define GPR_RATIO			0x1
#define GDR_RATIO			0x3
#define CLK_DIV_RIGHTBUS_VAL		((GPR_RATIO << 4)|(GDR_RATIO))

/* CLK_SRC_DMC	*/
#define MUX_PWI_SEL			0x1
#define MUX_CORE_TIMERS_SEL		0x1
#define MUX_DPHY_SEL			0x0
#define MUX_DMC_BUS_SEL			0x0
#define CLK_SRC_DMC_VAL			((MUX_PWI_SEL << 16) \
					|(MUX_CORE_TIMERS_SEL << 12) \
					|(MUX_DPHY_SEL << 8) \
					|(MUX_DMC_BUS_SEL << 4))

/* CLK_DIV_DMC0	*/
#define CORE_TIMERS_RATIO		0x0
#define COPY2_RATIO			0x0
#define DMCP_RATIO			0x1
#define DMCD_RATIO			0x1
#if	(CONFIG_CLK_MPLL == 200)
#define DMC_RATIO			0x3
#else
#define DMC_RATIO			0x1
#endif
#define DPHY_RATIO			0x1
#define ACP_PCLK_RATIO			0x1
#define ACP_RATIO			0x3

#define CLK_DIV_DMC0_VAL		((CORE_TIMERS_RATIO << 28) \
					|(COPY2_RATIO << 24) \
					|(DMCP_RATIO << 20) \
					|(DMCD_RATIO << 16) \
					|(DMC_RATIO << 12) \
					|(DPHY_RATIO << 8) \
					|(ACP_PCLK_RATIO << 4) \
					|(ACP_RATIO))

#define CLK_DIV_DMC1_VAL		(0x07071713)

/* CLK_SRC_PERIL0 */
#define UART4_SEL			1
#define UART3_SEL			1
#define UART2_SEL			1
#define UART1_SEL			1
#define UART0_SEL			1
#define CLK_SRC_PERIL0_VAL		((UART4_SEL << 16) \
					|(UART3_SEL << 12) \
					|(UART2_SEL<< 8) \
					|(UART1_SEL << 4) \
					|(UART0_SEL))

/* CLK_DIV_PERIL0	*/
#define UART4_RATIO			3
#define UART3_RATIO			3
#define UART2_RATIO			3
#define UART1_RATIO			3
#define UART0_RATIO			3
#define CLK_DIV_PERIL0_VAL		((UART4_RATIO << 16) \
					|(UART3_RATIO << 12) \
					|(UART2_RATIO << 8) \
					|(UART1_RATIO << 4) \
					|(UART0_RATIO))

/* Clock Source CAM/FIMC */
/* CLK_SRC_CAM */
#define CAM0_SEL_XUSBXTI	1
#define CAM1_SEL_XUSBXTI	1
#define CSIS0_SEL_XUSBXTI	1
#define CSIS1_SEL_XUSBXTI	1

#define FIMC_SEL_SCLKMPLL	6
#define FIMC0_LCLK_SEL		FIMC_SEL_SCLKMPLL
#define FIMC1_LCLK_SEL		FIMC_SEL_SCLKMPLL
#define FIMC2_LCLK_SEL		FIMC_SEL_SCLKMPLL
#define FIMC3_LCLK_SEL		FIMC_SEL_SCLKMPLL

#define CLK_SRC_CAM_VAL		((CSIS1_SEL_XUSBXTI << 28) \
				| (CSIS0_SEL_XUSBXTI << 24) \
				| (CAM1_SEL_XUSBXTI << 20) \
				| (CAM0_SEL_XUSBXTI << 16) \
				| (FIMC3_LCLK_SEL << 12) \
				| (FIMC2_LCLK_SEL << 8) \
				| (FIMC1_LCLK_SEL << 4) \
				| (FIMC0_LCLK_SEL << 0))

/* SCLK CAM */
/* CLK_DIV_CAM */
#define FIMC0_LCLK_RATIO	4
#define FIMC1_LCLK_RATIO	4
#define FIMC2_LCLK_RATIO	4
#define FIMC3_LCLK_RATIO	4
#define CLK_DIV_CAM_VAL		((FIMC3_LCLK_RATIO << 12) \
				| (FIMC2_LCLK_RATIO << 8) \
				| (FIMC1_LCLK_RATIO << 4) \
				| (FIMC0_LCLK_RATIO << 0))

/* SCLK MFC */
/* CLK_SRC_MFC */
#define MFC_SEL_MPLL		0
#define MOUTMFC_0		0
#define MFC_SEL			MOUTMFC_0
#define MFC_0_SEL		MFC_SEL_MPLL
#define CLK_SRC_MFC_VAL		((MFC_SEL << 8) | (MFC_0_SEL))


/* CLK_DIV_MFC */
#define MFC_RATIO		3
#define CLK_DIV_MFC_VAL		(MFC_RATIO)

/* SCLK G3D */
/* CLK_SRC_G3D */
#define G3D_SEL_MPLL		0
#define MOUTG3D_0		0
#define G3D_SEL			MOUTG3D_0
#define G3D_0_SEL		G3D_SEL_MPLL
#define CLK_SRC_G3D_VAL		((G3D_SEL << 8) | (G3D_0_SEL))

/* CLK_DIV_G3D */
#define G3D_RATIO		1
#define CLK_DIV_G3D_VAL		(G3D_RATIO)

/* SCLK LCD0 */
/* CLK_SRC_LCD0 */
#define FIMD_SEL_SCLKMPLL	6
#define MDNIE0_SEL_XUSBXTI	1
#define MDNIE_PWM0_SEL_XUSBXTI	1
#define MIPI0_SEL_XUSBXTI	1
#define CLK_SRC_LCD0_VAL	((MIPI0_SEL_XUSBXTI << 12) \
				| (MDNIE_PWM0_SEL_XUSBXTI << 8) \
				| (MDNIE0_SEL_XUSBXTI << 4) \
				| (FIMD_SEL_SCLKMPLL << 0))

/* CLK_DIV_LCD0 */
#define MIPI0_PRE_RATIO		7
#define FIMD0_RATIO		4
#define CLK_DIV_LCD0_VAL	((MIPI0_PRE_RATIO << 20) \
				| (FIMD0_RATIO))
/* Power Down Modes */
#define S5P_CHECK_SLEEP			0x00000BAD
#define S5P_CHECK_DIDLE			0xBAD00000
#define S5P_CHECK_LPA			0xABAD0000







/* Offsets of clock registers (sources and dividers) */
#define CLK_SRC_CPU_OFFSET	0x14200
#define CLK_DIV_CPU0_OFFSET	0x14500
#define CLK_DIV_CPU1_OFFSET	0x14504

#define CLK_SRC_DMC_OFFSET	0x10200
#define CLK_DIV_DMC0_OFFSET	0x10500
#define CLK_DIV_DMC1_OFFSET	0x10504

#define CLK_SRC_TOP0_OFFSET	0xC210
#define CLK_SRC_TOP1_OFFSET	0xC214
#define CLK_DIV_TOP_OFFSET	0xC510

#define CLK_SRC_LEFTBUS_OFFSET	0x4200
#define CLK_DIV_LEFTBUS_OFFSET	0x4500

#define CLK_SRC_RIGHTBUS_OFFSET	0x8200
#define CLK_DIV_RIGHTBUS_OFFSET	0x8500

#define CLK_SRC_FSYS_OFFSET	0xC240
#define CLK_DIV_FSYS1_OFFSET	0xC544
#define CLK_DIV_FSYS2_OFFSET	0xC548
#define CLK_DIV_FSYS3_OFFSET	0xC54C

#define CLK_SRC_PERIL0_OFFSET	0xC250
#define CLK_DIV_PERIL0_OFFSET	0xC550

#define CLK_SRC_LCD0_OFFSET	0xC234

#define APLL_LOCK_OFFSET	0x14000
#define MPLL_LOCK_OFFSET	0x14008
#define APLL_CON0_OFFSET	0x14100
#define APLL_CON1_OFFSET	0x14104
#define MPLL_CON0_OFFSET	0x10108
#define MPLL_CON1_OFFSET	0x1010C

#define EPLL_LOCK_OFFSET	0xC010
#define VPLL_LOCK_OFFSET	0xC020
#define EPLL_CON0_OFFSET	0xC110
#define EPLL_CON1_OFFSET	0xC114
#define EPLL_CON2_OFFSET	0xC118
#define VPLL_CON0_OFFSET	0xC120
#define VPLL_CON1_OFFSET	0xC124
#define VPLL_CON2_OFFSET	0xC128

/* DMC: DRAM Controllor Register offsets */
#define DMC_CONCONTROL		0x00
#define DMC_MEMCONTROL		0x04
#define DMC_MEMCONFIG0		0x08
#define DMC_MEMCONFIG1		0x0C
#define DMC_DIRECTCMD		0x10
#define DMC_PRECHCONFIG		0x14
#define DMC_PHYCONTROL0		0x18
#define DMC_PHYCONTROL1		0x1C
#define DMC_PHYCONTROL2		0x20
#define DMC_PHYCONTROL3		0x24
#define DMC_PWRDNCONFIG		0x18
#define DMC_TIMINGAREF		0x30
#define DMC_TIMINGROW		0x34
#define DMC_TIMINGDATA		0x38
#define DMC_TIMINGPOWER		0x3C
#define DMC_PHYZQCONTROL	0x44
#define DMC_IVCONTROL	    0xF0

#define C2C_CTRL_OFFSET     0x24
/* Bus Configuration Register Address */
#define ASYNC_CONFIG		0x10010350

/* MIU Config Register Offsets*/
#define APB_SFR_INTERLEAVE_CONF_OFFSET	0x400
#define APB_SFR_ARBRITATION_CONF_OFFSET		0xC00

/* Offset for inform registers */
#define INFORM0_OFFSET			0x800
#define INFORM1_OFFSET			0x804

/* GPIO Offsets for UART: GPIO Contol Register */
#define EXYNOS4_GPIO_A0_CON_OFFSET	0x00
#define EXYNOS4_GPIO_A1_CON_OFFSET	0x20

/* UART Register offsets */
#define ULCON_OFFSET		0x00
#define UCON_OFFSET		0x04
#define UFCON_OFFSET		0x08
#define UTXHN_OFFSET		0x20
#define UBRDIV_OFFSET		0x28
#define UFRACVAL_OFFSET		0x2C

/* TZPC : Register Offsets */
#define TZPC0_BASE		0x10110000
#define TZPC1_BASE		0x10120000
#define TZPC2_BASE		0x10130000
#define TZPC3_BASE		0x10140000
#define TZPC4_BASE		0x10150000
#define TZPC5_BASE		0x10160000

#define TZPC_DECPROT0SET_OFFSET	0x804
#define TZPC_DECPROT1SET_OFFSET	0x810
#define TZPC_DECPROT2SET_OFFSET	0x81C
#define TZPC_DECPROT3SET_OFFSET	0x828
 
/* CLK_SRS_FSYS: 6 = SCLKMPLL */
#define SATA_SEL_SCLKMPLL	0
#define SATA_SEL_SCLKAPLL	1

#define MMC_SEL_XXTI		0
#define MMC_SEL_XUSBXTI		1
#define MMC_SEL_SCLK_HDMI24M	2
#define MMC_SEL_SCLK_USBPHY0	3
#define MMC_SEL_SCLK_USBPHY1	4
#define MMC_SEL_SCLK_HDMIPHY	5
#define MMC_SEL_SCLKMPLL	6
#define MMC_SEL_SCLKEPLL	7
#define MMC_SEL_SCLKVPLL	8

/* SCLK_MMC[0-4] = MOUTMMC[0-4]/(MMC[0-4]_RATIO + 1)/(MMC[0-4]_PRE_RATIO +1) */
/* CLK_DIV_FSYS1 */
#define MMC0_RATIO		0xF
#define MMC0_PRE_RATIO		0x0
#define MMC1_RATIO		0xF
#define MMC1_PRE_RATIO		0x0
#define CLK_DIV_FSYS1_VAL	((MMC1_PRE_RATIO << 24) \
				| (MMC1_RATIO << 16) \
				| (MMC0_PRE_RATIO << 8) \
				| (MMC0_RATIO << 0))

/* CLK_DIV_FSYS2 */
#define MMC2_RATIO		0xF
#define MMC2_PRE_RATIO		0x0
#define MMC3_RATIO		0xF
#define MMC3_PRE_RATIO		0x0
#define CLK_DIV_FSYS2_VAL	((MMC3_PRE_RATIO << 24) \
				| (MMC3_RATIO << 16) \
				| (MMC2_PRE_RATIO << 8) \
				| (MMC2_RATIO << 0))

/* CLK_DIV_FSYS3 */
#define MMC4_RATIO		0xF
#define MMC4_PRE_RATIO		0x0
#define CLK_DIV_FSYS3_VAL	((MMC4_PRE_RATIO << 8) \
				| (MMC4_RATIO << 0))

/* CLK_SRC_PERIL0 */
#define UART_SEL_XXTI		0
#define UART_SEL_XUSBXTI	1
#define UART_SEL_SCLK_HDMI24M	2
#define UART_SEL_SCLK_USBPHY0	3
#define UART_SEL_SCLK_USBPHY1	4
#define UART_SEL_SCLK_HDMIPHY	5
#define UART_SEL_SCLKMPLL	6
#define UART_SEL_SCLKEPLL	7
#define UART_SEL_SCLKVPLL	8

#define UART0_SEL		UART_SEL_SCLKMPLL
#define UART1_SEL		UART_SEL_SCLKMPLL
#define UART2_SEL		UART_SEL_SCLKMPLL
#define UART3_SEL		UART_SEL_SCLKMPLL
#define UART4_SEL		UART_SEL_SCLKMPLL
#define CLK_SRC_PERIL0_VAL	((UART4_SEL << 16) \
				| (UART3_SEL << 12) \
				| (UART2_SEL << 8) \
				| (UART1_SEL << 4) \
				| (UART0_SEL << 0))

/* SCLK_UART[0-4] = MOUTUART[0-4]/(UART[0-4]_RATIO + 1) */
/* CLK_DIV_PERIL0 */
#define UART0_RATIO		7
#define UART1_RATIO		7
#define UART2_RATIO		7
#define UART3_RATIO		7
#define UART4_RATIO		7
#define CLK_DIV_PERIL0_VAL	((UART4_RATIO << 16) \
				| (UART3_RATIO << 12) \
				| (UART2_RATIO << 8) \
				| (UART1_RATIO << 4) \
				| (UART0_RATIO << 0))

/* CLK_SRC_LCD0 */
#define FIMD_SEL_SCLKMPLL	6
#define MDNIE0_SEL_XUSBXTI	1
#define MDNIE_PWM0_SEL_XUSBXTI	1
#define MIPI0_SEL_XUSBXTI	1
#define CLK_SRC_LCD0_VAL	((MIPI0_SEL_XUSBXTI << 12) \
				| (MDNIE_PWM0_SEL_XUSBXTI << 8) \
				| (MDNIE0_SEL_XUSBXTI << 4) \
				| (FIMD_SEL_SCLKMPLL << 0))

/* Required period to generate a stable clock output */
/* PLL_LOCK_TIME */
#define APLL_LOCK_VAL		0x3E8
#define MPLL_LOCK_VAL		0x2F1
#define EPLL_LOCK_VAL		0x2321
#define VPLL_LOCK_VAL		0x2321
#define PLL_LOCKTIME		0x1C20

/* PLL Values */
#define DISABLE			0
#define ENABLE			1
#define SET_PLL(mdiv, pdiv, sdiv)	((ENABLE << 31)\
					| (mdiv << 16) \
					| (pdiv << 8) \
					| (sdiv << 0))

/*
 * UART GPIO_A0/GPIO_A1 Control Register Value
 * 0x2: UART Function
 */
#define EXYNOS4_GPIO_A0_CON_VAL	0x22222222
#define EXYNOS4_GPIO_A1_CON_VAL	0x222222

/* ULCON: UART Line Control Value 8N1 */
#define WORD_LEN_5_BIT		0x00
#define WORD_LEN_6_BIT		0x01
#define WORD_LEN_7_BIT		0x02
#define WORD_LEN_8_BIT		0x03

#define STOP_BIT_1		0x00
#define STOP_BIT_2		0x01

#define NO_PARITY			0x00
#define ODD_PARITY			0x4
#define EVEN_PARITY			0x5
#define FORCED_PARITY_CHECK_AS_1	0x6
#define FORCED_PARITY_CHECK_AS_0	0x7

#define INFRAMODE_NORMAL		0x00
#define INFRAMODE_INFRARED		0x01

#define ULCON_VAL		((INFRAMODE_NORMAL << 6) \
				| (NO_PARITY << 3) \
				| (STOP_BIT_1 << 2) \
				| (WORD_LEN_8_BIT << 0))

/*
 * UCON: UART Control Value
 * Tx_interrupt Type: Level
 * Rx_interrupt Type: Level
 * Rx Timeout Enabled: Yes
 * Rx-Error Atatus_Int Enable: Yes
 * Loop_Back: No
 * Break Signal: No
 * Transmit mode : Interrupt request/polling
 * Receive mode : Interrupt request/polling
 */
#define TX_PULSE_INTERRUPT	0
#define TX_LEVEL_INTERRUPT	1
#define RX_PULSE_INTERRUPT	0
#define RX_LEVEL_INTERRUPT	1

#define RX_TIME_OUT		ENABLE
#define RX_ERROR_STATE_INT_ENB	ENABLE
#define LOOP_BACK		DISABLE
#define BREAK_SIGNAL		DISABLE

#define TX_MODE_DISABLED	0X00
#define TX_MODE_IRQ_OR_POLL	0X01
#define TX_MODE_DMA		0X02

#define RX_MODE_DISABLED	0X00
#define RX_MODE_IRQ_OR_POLL	0X01
#define RX_MODE_DMA		0X02

#define UCON_VAL		((TX_LEVEL_INTERRUPT << 9) \
				| (RX_LEVEL_INTERRUPT << 8) \
				| (RX_TIME_OUT << 7) \
				| (RX_ERROR_STATE_INT_ENB << 6) \
				| (LOOP_BACK << 5) \
				| (BREAK_SIGNAL << 4) \
				| (TX_MODE_IRQ_OR_POLL << 2) \
				| (RX_MODE_IRQ_OR_POLL << 0))

/*
 * UFCON: UART FIFO Control Value
 * Tx FIFO Trigger LEVEL: 2 Bytes (001)
 * Rx FIFO Trigger LEVEL: 2 Bytes (001)
 * Tx Fifo Reset: No
 * Rx Fifo Reset: No
 * FIFO Enable: Yes
 */
#define TX_FIFO_TRIGGER_LEVEL_0_BYTES	0x00
#define TX_FIFO_TRIGGER_LEVEL_2_BYTES	0x1
#define TX_FIFO_TRIGGER_LEVEL_4_BYTES	0x2
#define TX_FIFO_TRIGGER_LEVEL_6_BYTES	0x3
#define TX_FIFO_TRIGGER_LEVEL_8_BYTES	0x4
#define TX_FIFO_TRIGGER_LEVEL_10_BYTES	0x5
#define TX_FIFO_TRIGGER_LEVEL_12_BYTES	0x6
#define TX_FIFO_TRIGGER_LEVEL_14_BYTES	0x7

#define RX_FIFO_TRIGGER_LEVEL_2_BYTES	0x0
#define RX_FIFO_TRIGGER_LEVEL_4_BYTES	0x1
#define RX_FIFO_TRIGGER_LEVEL_6_BYTES	0x2
#define RX_FIFO_TRIGGER_LEVEL_8_BYTES	0x3
#define RX_FIFO_TRIGGER_LEVEL_10_BYTES	0x4
#define RX_FIFO_TRIGGER_LEVEL_12_BYTES	0x5
#define RX_FIFO_TRIGGER_LEVEL_14_BYTES	0x6
#define RX_FIFO_TRIGGER_LEVEL_16_BYTES	0x7

#define TX_FIFO_TRIGGER_LEVEL		TX_FIFO_TRIGGER_LEVEL_2_BYTES
#define RX_FIFO_TRIGGER_LEVEL		RX_FIFO_TRIGGER_LEVEL_4_BYTES
#define TX_FIFO_RESET			DISABLE
#define RX_FIFO_RESET			DISABLE
#define FIFO_ENABLE			ENABLE
#define UFCON_VAL			((TX_FIFO_TRIGGER_LEVEL << 8) \
					| (RX_FIFO_TRIGGER_LEVEL << 4) \
					| (TX_FIFO_RESET << 2) \
					| (RX_FIFO_RESET << 1) \
					| (FIFO_ENABLE << 0))
/*
 * Baud Rate Division Value
 * 115200 BAUD:
 * UBRDIV_VAL = (SCLK_UART/DIVUART)/((115200 * 16) - 1)
 * UBRDIV_VAL = (800 MHz/8)/((115200 * 16) - 1)
 */
//#define UBRDIV_VAL		0x2B
#define UBRDIV_VAL		0x35

/*
 * Fractional Part of Baud Rate Divisor:
 * 115200 BAUD:
 * UBRFRACVAL = ((((SCLK_UART/DIVUART*10/(115200*16) -10))%10)*16/10)
 * UBRFRACVAL = ((((800MHz/8*10/(115200*16) -10))%10)*16/10)
 */
//#define UFRACVAL_VAL		0xC
#define UFRACVAL_VAL		0x4

/*
 * TZPC Register Value :
 * R0SIZE: 0x0 : Size of secured ram
 */
#define R0SIZE			0x0

/*
 * TZPC Decode Protection Register Value :
 * DECPROTXSET: 0xFF : Set Decode region to non-secure
 */
#define DECPROTXSET		0xFF

/* PS_HOLD: Data Hight, Output En */
#define BIT_DAT             8
#define BIT_EN              9
#define EXYNOS4_PS_HOLD_CON_VAL     (0x1 << BIT_DAT | 0x1 << BIT_EN)

/* IMAGE SIZE (BYTE) */
#define	MBR_BYTE_COUNT			CONFIG_MBR_SIZE
#define	SBL_BYTE_COUNT			CONFIG_SBL_SIZE
#define	BL1_BYTE_COUNT			CONFIG_BL1_SIZE
#define	BL2_BYTE_COUNT			CONFIG_BL2_SIZE
#define	ENV_BYTE_COUNT			CONFIG_ENV_SIZE

/* IMAGE OFFSET (BYTE) */
#define	MBR_BYTE_OFFSET			(0)
#define	SBL_BYTE_OFFSET			(MBR_BYTE_OFFSET + MBR_BYTE_COUNT)
#define	BL1_BYTE_OFFSET			(SBL_BYTE_OFFSET + SBL_BYTE_COUNT)
#define	BL2_BYTE_OFFSET			(BL1_BYTE_OFFSET + BL1_BYTE_COUNT)
#define	ENV_BYTE_OFFSET			(Bl2_BYTE_OFFSET + BL2_BYTE_COUNT)

#define SDMMC_BLK_SIZE			(512)

/* IMAGE SIZE (BLOCK) */
#define	SBL_BLK_COUNT			(SBL_BYTE_COUNT / SDMMC_BLK_SIZE)
#define	BL1_BLK_COUNT			(BL1_BYTE_COUNT / SDMMC_BLK_SIZE)
#define	BL2_BLK_COUNT			(BL2_BYTE_COUNT / SDMMC_BLK_SIZE)
#define	ENV_BLK_COUNT			(ENV_BYTE_COUNT / SDMMC_BLK_SIZE)

/* IMAGE OFFSET (BLOCK) */
#define	SBL_BLK_OFFSET			(SBL_BYTE_OFFSET / SDMMC_BLK_SIZE)
#define	BL1_BLK_OFFSET			(BL1_BYTE_OFFSET / SDMMC_BLK_SIZE)
#define	BL2_BLK_OFFSET			(BL2_BYTE_OFFSET / SDMMC_BLK_SIZE)
#define	ENV_BLK_OFFSET			(ENV_BYTE_OFFSET / SDMMC_BLK_SIZE)

/* UART */
#if	defined(CONFIG_SERIAL0)
#define PERIPH_ID_UART			PERIPH_ID_UART0
#elif	defined(CONFIG_SERIAL1)
#define PERIPH_ID_UART			PERIPH_ID_UART1
#elif	defined(CONFIG_SERIAL2)
#define PERIPH_ID_UART			PERIPH_ID_UART2
#elif	defined(CONFIG_SERIAL3)
#define PERIPH_ID_UART			PERIPH_ID_UART3
#endif

#endif
