/*
 * Copyright (c) 2021 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <asm/io.h>
#include <asm/arch/cpu.h>
#include <asm/arch/hardware.h>
#include <asm/arch/ioc_rk3588.h>
#include <dt-bindings/clock/rk3588-cru.h>

DECLARE_GLOBAL_DATA_PTR;

#include <asm/armv8/mmu.h>

static struct mm_region rk3588_mem_map[] = {
	{
		.virt = 0x0UL,
		.phys = 0x0UL,
		.size = 0xf0000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_NORMAL) |
			 PTE_BLOCK_INNER_SHARE
	}, {
		.virt = 0xf0000000UL,
		.phys = 0xf0000000UL,
		.size = 0x10000000UL,
		.attrs = PTE_BLOCK_MEMTYPE(MT_DEVICE_NGNRNE) |
			 PTE_BLOCK_NON_SHARE |
			 PTE_BLOCK_PXN | PTE_BLOCK_UXN
	}, {
		/* List terminator */
		0,
	}
};

struct mm_region *mem_map = rk3588_mem_map;

/* GPIO4D_IOMUX_SEL_L */
enum {
	GPIO4D0_SHIFT		= 0,
	GPIO4D0_MASK		= GENMASK(3, 0),
	GPIO4D0_GPIO		= 0,
	GPIO4D0_SDMMC_D0	= 1,
	GPIO4D0_PDM1_SDI3_M0	= 2,
	GPIO4D0_JTAG_TCK_M1	= 5,
	GPIO4D0_I2C3_SCL_M4	= 9,
	GPIO4D0_UART2_TX_M1	= 10,
	GPIO4D0_PWM8_M1		= 12,

	GPIO4D1_SHIFT		= 4,
	GPIO4D1_MASK		= GENMASK(7, 4),
	GPIO4D1_GPIO		= 0,
	GPIO4D1_SDMMC_D1	= 1,
	GPIO4D1_PDM1_SDI2_M0	= 2,
	GPIO4D1_JTAG_TMS_M1	= 5,
	GPIO4D1_I2C3_SDA_M4	= 9,
	GPIO4D1_UART2_RX_M1	= 10,
	GPIO4D1_PWM9_M1		= 12,
};

#define GRF_BASE	0xfd58c000

void board_debug_uart_init(void)
{
	static struct rk3588_grf * const grf = (void *)GRF_BASE;

	/* UART2_M1 Switch iomux */
	rk_clrsetreg(&grf->gpio4d_iomux_sel_l,
		     GPIO4D0_MASK | GPIO4D1_MASK,
		     GPIO4D0_UART2_TX_M1 << GPIO4D0_SHIFT |
		     GPIO4D1_UART2_RX_M1 << GPIO4D1_SHIFT);

	/* TODO: M1 select ? */
}

#ifndef CONFIG_TPL_BUILD
int arch_cpu_init(void)
{
	return 0;
}
#endif
