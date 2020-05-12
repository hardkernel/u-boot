/*
 * Copyright (c) 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <asm/io.h>
#include <asm/arch/hardware.h>

DECLARE_GLOBAL_DATA_PTR;

#define FIREWALL_APB_BASE	0xffa60000
#define FW_DDR_CON_REG		0x80

#define USB_HOST_PRIORITY_REG	0xfe810008
#define USB_OTG_PRIORITY_REG	0xfe810088
#define DECOM_PRIORITY_REG	0xfe820088
#define DMA_PRIORITY_REG	0xfe820108
#define MCU_DM_PRIORITY_REG	0xfe820188
#define MCU_IM_PRIORITY_REG	0xfe820208
#define A7_PRIORITY_REG		0xfe830008
#define GMAC_PRIORITY_REG	0xfe840008
#define NPU_PRIORITY_REG	0xfe850008
#define EMMC_PRIORITY_REG	0xfe860008
#define NANDC_PRIORITY_REG	0xfe860088
#define SFC_PRIORITY_REG	0xfe860208
#define SDMMC_PRIORITY_REG	0xfe868008
#define SDIO_PRIORITY_REG	0xfe86c008
#define VEPU_RD0_PRIORITY_REG	0xfe870008
#define VEPU_RD1_PRIORITY_REG	0xfe870088
#define VEPU_WR_PRIORITY_REG	0xfe870108
#define ISPP_M0_PRIORITY_REG	0xfe880008
#define ISPP_M1_PRIORITY_REG	0xfe880088
#define ISP_PRIORITY_REG	0xfe890008
#define CIF_LIFE_PRIORITY_REG	0xfe890088
#define CIF_PRIORITY_REG	0xfe890108
#define IEP_PRIORITY_REG	0xfe8a0008
#define RGA_RD_PRIORITY_REG	0xfe8a0088
#define RGA_WR_PRIORITY_REG	0xfe8a0108
#define VOP_PRIORITY_REG	0xfe8a0188
#define VDPU_PRIORITY_REG	0xfe8b0008
#define JPEG_PRIORITY_REG	0xfe8c0008
#define CRYPTO_PRIORITY_REG	0xfe8d0008

#define PMU_BASE_ADDR		0xff3e0000

#define PMU_BUS_IDLE_SFTCON(n)	(0xc0 + (n) * 4)
#define PMU_BUS_IDLE_ACK	(0xd0)
#define PMU_BUS_IDLE_ST		(0xd8)
#define PMU_PWR_DWN_ST		(0x108)
#define PMU_PWR_GATE_SFTCON	(0x110)

#define CRU_BASE		0xFF490000
#define CRU_SOFTRST_CON02	0x308
#define SGRF_BASE		0xFE0A0000
#define SGRF_CON_SCR1_BOOT_ADDR	0x0b0
#define SGRF_SOC_CON3		0x00c
#define SCR1_START_ADDR		0x208000

void board_debug_uart_init(void)
{

}

int arch_cpu_init(void)
{
#if defined(CONFIG_SPL_BUILD) && !defined(CONFIG_TPL_BUILD)
	/* Just set region 0 to unsecure */
	writel(0, FIREWALL_APB_BASE + FW_DDR_CON_REG);
#endif

#if !defined(CONFIG_TPL_BUILD)
	int delay;

	/* enable all pd */
	writel(0xffff0000, PMU_BASE_ADDR + PMU_PWR_GATE_SFTCON);
	delay = 1000;
	do {
		udelay(1);
		delay--;
		if (delay == 0)
			break;
	} while (readl(PMU_BASE_ADDR + PMU_PWR_DWN_ST));

	/* release all idle request */
	writel(0xffff0000, PMU_BASE_ADDR + PMU_BUS_IDLE_SFTCON(0));
	writel(0xffff0000, PMU_BASE_ADDR + PMU_BUS_IDLE_SFTCON(1));

	delay = 1000;
	/* wait ack status */
	do {
		udelay(1);
		delay--;
		if (delay == 0)
			break;
	} while (readl(PMU_BASE_ADDR + PMU_BUS_IDLE_ACK));

	delay = 1000;
	/* wait idle status */
	do {
		udelay(1);
		delay--;
		if (delay == 0)
			break;
	} while (readl(PMU_BASE_ADDR + PMU_BUS_IDLE_ST));

	writel(0x303, USB_HOST_PRIORITY_REG);
	writel(0x303, USB_OTG_PRIORITY_REG);
	writel(0x101, DECOM_PRIORITY_REG);
	writel(0x303, DMA_PRIORITY_REG);
	writel(0x101, MCU_DM_PRIORITY_REG);
	writel(0x101, MCU_IM_PRIORITY_REG);
	writel(0x101, A7_PRIORITY_REG);
	writel(0x303, GMAC_PRIORITY_REG);
	writel(0x101, NPU_PRIORITY_REG);
	writel(0x303, EMMC_PRIORITY_REG);
	writel(0x303, NANDC_PRIORITY_REG);
	writel(0x303, SFC_PRIORITY_REG);
	writel(0x303, SDMMC_PRIORITY_REG);
	writel(0x303, SDIO_PRIORITY_REG);
	writel(0x101, VEPU_RD0_PRIORITY_REG);
	writel(0x101, VEPU_RD1_PRIORITY_REG);
	writel(0x101, VEPU_WR_PRIORITY_REG);
	writel(0x202, ISPP_M0_PRIORITY_REG);
	writel(0x202, ISPP_M1_PRIORITY_REG);
	writel(0x303, ISP_PRIORITY_REG);
	writel(0x202, CIF_LIFE_PRIORITY_REG);
	writel(0x202, CIF_PRIORITY_REG);
	writel(0x101, IEP_PRIORITY_REG);
	writel(0x101, RGA_RD_PRIORITY_REG);
	writel(0x101, RGA_WR_PRIORITY_REG);
	writel(0x202, VOP_PRIORITY_REG);
	writel(0x101, VDPU_PRIORITY_REG);
	writel(0x101, JPEG_PRIORITY_REG);
	writel(0x101, CRYPTO_PRIORITY_REG);
#endif

	return 0;
}

#ifdef CONFIG_SPL_BUILD
int spl_fit_standalone_release(void)
{
	/* Reset the scr1 */
	writel(0x04000400, CRU_BASE + CRU_SOFTRST_CON02);
	udelay(100);
	/* set the scr1 addr */
	writel(SCR1_START_ADDR, SGRF_BASE + SGRF_CON_SCR1_BOOT_ADDR);
	writel(0x00ff00bf, SGRF_BASE + SGRF_SOC_CON3);
	/* release the scr1 */
	writel(0x04000000, CRU_BASE + CRU_SOFTRST_CON02);

	return 0;
}
#endif
