// SPDX-License-Identifier:     GPL-2.0+
/*
 * Copyright (c) 2018 Rockchip Electronics Co., Ltd
 *
 */
#include <common.h>
#include <asm/io.h>
#include <asm/arch/grf_rk1808.h>
#include <asm/arch/hardware.h>
#include <asm/gpio.h>
#include <debug_uart.h>

#include <asm/armv8/mmu.h>
static struct mm_region rk1808_mem_map[] = {
	{
		.virt = 0x0UL,
		.phys = 0x0UL,
		.size = 0xff000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_NORMAL) |
			 PTE_BLOCK_INNER_SHARE
	}, {
		.virt = 0xf8000000UL,
		.phys = 0xf8000000UL,
		.size = 0x08000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_DEVICE_NGNRNE) |
			 PTE_BLOCK_NON_SHARE |
			 PTE_BLOCK_PXN | PTE_BLOCK_UXN
	}, {
		/* List terminator */
		0,
	}
};

struct mm_region *mem_map = rk1808_mem_map;

#define GRF_BASE	0xfe000000

enum {
	GPIO4A3_SHIFT           = 12,
	GPIO4A3_MASK            = GENMASK(15, 12),
	GPIO4A3_GPIO            = 0,
	GPIO4A3_SDMMC0_D1,
	GPIO4A3_UART2_RX_M0,

	GPIO4A2_SHIFT           = 8,
	GPIO4A2_MASK            = GENMASK(11, 8),
	GPIO4A2_GPIO            = 0,
	GPIO4A2_SDMMC0_D0,
	GPIO4A2_UART2_TX_M0,

	UART2_IO_SEL_SHIFT	= 14,
	UART2_IO_SEL_MASK	= GENMASK(15, 14),
	UART2_IO_SEL_M0		= 0,
	UART2_IO_SEL_M1,
	UART2_IO_SEL_M2,
	UART2_IO_SEL_USB,
};

/*
 * Default use UART2_TX/RX_M0(TX: GPIO4_A2, RX: GPIO4_A3)
 */
void board_debug_uart_init(void)
{
	static struct rk1808_grf * const grf = (void *)GRF_BASE;

	/* Enable early UART2 channel m0 on the rk1808 */
	rk_clrsetreg(&grf->iofunc_con0, UART2_IO_SEL_MASK,
		     UART2_IO_SEL_M0 << UART2_IO_SEL_SHIFT);

	/* Switch iomux */
	rk_clrsetreg(&grf->gpio4a_iomux_l,
		     GPIO4A3_MASK | GPIO4A2_MASK,
		     GPIO4A2_UART2_TX_M0 << GPIO4A2_SHIFT |
		     GPIO4A3_UART2_RX_M0 << GPIO4A3_SHIFT);
}
