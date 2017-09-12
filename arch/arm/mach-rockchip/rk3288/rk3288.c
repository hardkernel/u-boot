/*
 * Copyright (c) 2016 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <asm/io.h>
#include <asm/arch/hardware.h>

#define GRF_SOC_CON2 0xff77024c
#define GRF_SOC_CON7 0xff770260

#define VIO0_VOP_QOS_BASE	0xffad0408
#define VIO1_VOP_QOS_BASE	0xffad0008
#define BUS_MSCH0_QOS_BASE	0xffac0014
#define BUS_MSCH1_QOS_BASE	0xffac0094

#define READLATENCY_VAL		0x34
#define CRU_CLKSEL_CON28	0Xff7600d0

#define CPU_AXI_QOS_PRIORITY_LEVEL(h, l) \
	((((h) & 3) << 8) | (((h) & 3) << 2) | ((l) & 3))

int arch_cpu_init(void)
{
	/* We do some SoC one time setting here. */

	/* Use rkpwm by default */
	rk_setreg(GRF_SOC_CON2, 1 << 0);

	/* Disable LVDS phy */
	rk_setreg(GRF_SOC_CON7, 1 << 15);

	/* Select EDP clock source 24M */
	rk_setreg(CRU_CLKSEL_CON28, 1 << 15);

	/* Read latency configure */
	writel(READLATENCY_VAL, BUS_MSCH0_QOS_BASE);
	writel(READLATENCY_VAL, BUS_MSCH1_QOS_BASE);

	/* Set vop qos to highest priority */
	writel(CPU_AXI_QOS_PRIORITY_LEVEL(2, 2), VIO0_VOP_QOS_BASE);
	writel(CPU_AXI_QOS_PRIORITY_LEVEL(2, 2), VIO1_VOP_QOS_BASE);

	return 0;
}
