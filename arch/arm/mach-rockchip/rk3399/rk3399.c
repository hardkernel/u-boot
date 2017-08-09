/*
 * Copyright (c) 2016 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <syscon.h>
#include <asm/armv8/mmu.h>
#include <asm/arch/boot_mode.h>
#include <asm/arch/clock.h>
#include <asm/arch/grf_rk3399.h>
#include <asm/arch/hardware.h>
#include <asm/io.h>

DECLARE_GLOBAL_DATA_PTR;

#define GRF_EMMCCORE_CON11 0xff77f02c

static struct mm_region rk3399_mem_map[] = {
	{
		.virt = 0x0UL,
		.phys = 0x0UL,
		.size = 0xf8000000UL,
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

struct mm_region *mem_map = rk3399_mem_map;

int dram_init_banksize(void)
{
	size_t max_size = min((unsigned long)gd->ram_size, gd->ram_top);

	/* Reserve 0x200000 for ATF bl31 */
	gd->bd->bi_dram[0].start = 0x200000;
	gd->bd->bi_dram[0].size = max_size - gd->bd->bi_dram[0].start;

	return 0;
}

int arch_cpu_init(void)
{
	/* We do some SoC one time setting here. */

	/* Emmc clock generator: disable the clock multipilier */
	rk_clrreg(GRF_EMMCCORE_CON11, 0x0ff);

	return 0;
}

static void setup_boot_mode(void)
{
	struct rk3399_pmugrf_regs *pmugrf;
	int boot_mode;

	pmugrf = syscon_get_first_range(ROCKCHIP_SYSCON_PMUGRF);;
	boot_mode = readl(&pmugrf->os_reg0);
	debug("boot mode %x\n", boot_mode);

	/* Clear boot mode */
	writel(BOOT_NORMAL, &pmugrf->os_reg0);

	switch (boot_mode) {
	case BOOT_FASTBOOT:
		printf("enter fastboot!\n");
		env_set("preboot", "setenv preboot; fastboot usb0");
		break;
	case BOOT_UMS:
		printf("enter UMS!\n");
		env_set("preboot", "setenv preboot; if mmc dev 0;"
		       "then ums mmc 0; else ums mmc 1;fi");
		break;
	case BOOT_LOADER:
		printf("enter Rockusb!\n");
		env_set("preboot", "setenv preboot; rockusb 0 mmc 0");
		break;
	}
}

int board_late_init(void)
{
	setup_boot_mode();

	return 0;
}

#if defined(CONFIG_USB_FUNCTION_FASTBOOT)
int fb_set_reboot_flag(void)
{
	struct rk3399_pmugrf_regs *pmugrf;

	printf("Setting reboot to fastboot flag ...\n");
	pmugrf = syscon_get_first_range(ROCKCHIP_SYSCON_PMUGRF);
	/* Clear boot mode */
	writel(BOOT_FASTBOOT, &pmugrf->os_reg0);

	return 0;
}
#endif
