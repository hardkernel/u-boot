/*
 * Copyright (c) 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <asm/io.h>
#include <asm/arch/hardware.h>

#define GRF_GPIO1C_IOMUX		0x200080c0
#define SDMMC_INTMASK			0x10214024
#define READLATENCY_VAL			0x3f
#define BUS_MSCH_QOS_BASE		0x10128014
#define	CPU_AXI_QOS_PRIORITY_BASE	0x1012f188
#define CPU_AXI_QOS_PRIORITY_LEVEL(h, l) \
	((((h) & 3) << 8) | (((h) & 3) << 2) | ((l) & 3))

int arch_cpu_init(void)
{
	/* We do some SoC one time setting here. */

	/* Read latency configure */
	writel(READLATENCY_VAL, BUS_MSCH_QOS_BASE);

	/* Set lcdc cpu axi qos priority level */
	writel(CPU_AXI_QOS_PRIORITY_LEVEL(3, 3), CPU_AXI_QOS_PRIORITY_BASE);

	/* Set GPIO1_C1 iomux to gpio, default sdcard_detn */
	writel(0x00040000, GRF_GPIO1C_IOMUX);

#ifdef CONFIG_ROCKCHIP_RK3126
	/*
	 * Disable interrupt, otherwise it always generates wakeup signal. This
	 * is an IC hardware issue.
	 */
	writel(0, SDMMC_INTMASK);
#endif

	return 0;
}

void board_debug_uart_init(void)
{
}
