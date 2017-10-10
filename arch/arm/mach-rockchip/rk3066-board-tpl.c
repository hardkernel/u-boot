/*
 * (C) Copyright 2015 Google, Inc
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <clk.h>
#include <common.h>
#include <debug_uart.h>
#include <dm.h>
#include <ram.h>
#include <spl.h>
#include <asm/io.h>
#include <asm/arch/bootrom.h>
#include <asm/arch/clock.h>
#include <asm/arch/ddr_rk3188.h>
#include <asm/arch/hardware.h>
#include <asm/arch/grf_rk3066.h>
#include <asm/arch/pmu_rk3188.h>

DECLARE_GLOBAL_DATA_PTR;

#define RK3066_TIMER_CONTROL	0x8
#define GRF_BASE	0x20008000

static int setup_arm_clock(void)
{
	struct udevice *dev;
	struct clk clk;
	int ret;

	ret = rockchip_get_clk(&dev);
	if (ret)
		return ret;

	clk.id = CLK_ARM;
	ret = clk_request(dev, &clk);
	if (ret < 0)
		return ret;

	ret = clk_set_rate(&clk, 600000000);

	clk_free(&clk);
	return ret;
}

void board_init_f(ulong dummy)
{
	struct rk3066_grf * const grf = (void *)GRF_BASE;
	struct udevice *dev;
	int ret;

	/* Enable early UART on the RK3066 */
	rk_clrsetreg(&grf->gpio1b_iomux,
		     GPIO1B1_MASK | GPIO1B0_MASK,
		     GPIO1B1_UART2_SOUT << GPIO1B1_SHIFT |
		     GPIO1B0_UART2_SIN << GPIO1B0_SHIFT);

	debug_uart_init();

	printascii("U-Boot TPL board init\n");

	ret = spl_early_init();
	if (ret) {
		debug("spl_early_init() failed: %d\n", ret);
		hang();
	}

	/* Reset and enable Timer0 */
	writel(0, CONFIG_SYS_TIMER_BASE);
	rk_clrsetreg(CONFIG_SYS_TIMER_BASE + RK3066_TIMER_CONTROL, 0x1, 0x1);

	ret = uclass_get_device(UCLASS_RAM, 0, &dev);
	if (ret) {
		debug("DRAM init failed: %d\n", ret);
		return;
	}

	setup_arm_clock();
}

void board_return_to_bootrom(void)
{
	back_to_bootrom(BROM_BOOT_NEXTSTAGE);
}

u32 spl_boot_device(void)
{
	return BOOT_DEVICE_BOOTROM;
}
