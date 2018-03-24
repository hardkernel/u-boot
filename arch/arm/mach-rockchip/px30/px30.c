/*
 * Copyright (c) 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <clk.h>
#include <dm.h>
#include <asm/io.h>
#include <asm/arch/grf_px30.h>
#include <asm/arch/hardware.h>
#include <asm/armv8/mmu.h>
#include <asm/arch/clock.h>
#include <asm/arch/cru_px30.h>
#include <dt-bindings/clock/px30-cru.h>

#define PMU_PWRDN_CON	0xff000018

static struct mm_region px30_mem_map[] = {
	{
		.virt = 0x0UL,
		.phys = 0x0UL,
		.size = 0xff000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_NORMAL) |
			 PTE_BLOCK_INNER_SHARE
	}, {
		.virt = 0xff000000UL,
		.phys = 0xff000000UL,
		.size = 0x01000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_DEVICE_NGNRNE) |
			 PTE_BLOCK_NON_SHARE |
			 PTE_BLOCK_PXN | PTE_BLOCK_UXN
	}, {
		/* List terminator */
		0,
	}
};

struct mm_region *mem_map = px30_mem_map;

int arch_cpu_init(void)
{
#ifdef CONFIG_SPL_BUILD
	/* We do some SoC one time setting here. */
	/* Disable the ddr secure region setting to make it non-secure */
#endif
	/* Enable PD_VO (default disable at reset) */
	rk_clrreg(PMU_PWRDN_CON, 1 << 13);

	return 0;
}
#define GRF_BASE	0xff140000
void board_debug_uart_init(void)
{
static struct px30_grf * const grf = (void *)GRF_BASE;
#ifdef CONFIG_SPL_BUILD
	/* Do not set the iomux in U-Boot proper because SD card may using it */
	/* Enable early UART2 channel m0 on the px30 */
	rk_clrsetreg(&grf->gpio1dl_iomux,
		     GPIO1D3_MASK | GPIO1D2_MASK,
		     GPIO1D3_UART2_RXM0 << GPIO1D3_SHIFT |
		     GPIO1D2_UART2_TXM0 << GPIO1D2_SHIFT);
#endif
	/* Set channel C as UART2 input */
	rk_clrsetreg(&grf->iofunc_con0,
		     CON_IOMUX_UART2SEL_MASK,
		     CON_IOMUX_UART2SEL_M0 << CON_IOMUX_UART2SEL_SHIFT);
}

int set_armclk_rate(void)
{
	struct px30_clk_priv *priv;
	struct clk clk;
	int ret;

	ret = rockchip_get_clk(&clk.dev);
	if (ret) {
		printf("Failed to get clk dev\n");
		return ret;
	}
	clk.id = ARMCLK;
	priv = dev_get_priv(clk.dev);
	ret = clk_set_rate(&clk, priv->armclk_hz);
	if (ret < 0) {
		printf("Failed to set armclk %lu\n", priv->armclk_hz);
		return ret;
	}

	return 0;
}
