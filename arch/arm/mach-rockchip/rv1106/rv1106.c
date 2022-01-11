/*
 * Copyright (c) 2022 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <asm/io.h>
#include <asm/arch/hardware.h>
#include <asm/arch/grf_rv1106.h>
#include <asm/arch/ioc_rv1106.h>

DECLARE_GLOBAL_DATA_PTR;

#define PERI_SGRF_BASE			0xff070000
#define PERI_SGRF_FIREWALL_CON0		0x0020
#define PERI_SGRF_FIREWALL_CON1		0x0024
#define PERI_SGRF_FIREWALL_CON2		0x0028
#define PERI_SGRF_FIREWALL_CON3		0x002c
#define PERI_SGRF_FIREWALL_CON4		0x0030
#define PERI_SGRF_SOC_CON3		0x00bc

#define CORE_SGRF_BASE			0xff076000
#define CORE_SGRF_FIREWALL_CON0		0x0020
#define CORE_SGRF_FIREWALL_CON1		0x0024
#define CORE_SGRF_FIREWALL_CON2		0x0028
#define CORE_SGRF_FIREWALL_CON3		0x002c
#define CORE_SGRF_FIREWALL_CON4		0x0030
#define CORE_SGRF_CPU_CTRL_CON		0x0040

#define PMU_SGRF_BASE			0xff080000

#define FW_DDR_BASE			0xff900000
#define FW_DDR_MST3_REG			0x4c
#define FW_SHRM_BASE			0xff910000
#define FW_SHRM_MST1_REG		0x44

void board_debug_uart_init(void)
{

}

int arch_cpu_init(void)
{
#ifdef CONFIG_SPL_BUILD
	/* Set all devices to Non-secure */
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON0);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON1);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON2);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON3);
	writel(0xffff0000, PERI_SGRF_BASE + PERI_SGRF_FIREWALL_CON4);
	writel(0x000f0000, PERI_SGRF_BASE + PERI_SGRF_SOC_CON3);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON0);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON1);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON2);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON3);
	writel(0xffff0000, CORE_SGRF_BASE + CORE_SGRF_FIREWALL_CON4);
	writel(0x00030002, CORE_SGRF_BASE + CORE_SGRF_CPU_CTRL_CON);
	writel(0x20000000, PMU_SGRF_BASE);

	/* Set the emmc to access secure area */
	writel(0xffff0000, FW_DDR_BASE + FW_DDR_MST3_REG);
	writel(0xff00ffff, FW_SHRM_BASE + FW_SHRM_MST1_REG);
#endif
	return 0;
}
