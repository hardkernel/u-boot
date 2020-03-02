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
#define FW_DDR_BASE		FIREWALL_APB_BASE
#define FW_DDR_CON_REG		0x80
#define DDR_RGN(x)		(0x20 + (x) * 4)

void board_debug_uart_init(void)
{

}

#if defined(CONFIG_SPL_BUILD)
int arch_cpu_init(void)
{
	int i;

	/* Close the firewall, so that some devices can access to DDR */
	writel(0, FIREWALL_APB_BASE + FW_DDR_CON_REG);
	for (i = 0; i < 9; i++) {
		writel(0, FW_DDR_BASE + DDR_RGN(i));
	}

	return 0;
}
#endif
