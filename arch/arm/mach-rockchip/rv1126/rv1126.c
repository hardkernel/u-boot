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

void board_debug_uart_init(void)
{

}

#if defined(CONFIG_SPL_BUILD)
int arch_cpu_init(void)
{
	/* Just set region 0 to unsecure */
	writel(0, FIREWALL_APB_BASE + FW_DDR_CON_REG);

	return 0;
}
#endif
