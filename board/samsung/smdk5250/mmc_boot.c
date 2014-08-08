/*
 * Copyright (C) 2012 Samsung Electronics
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <config.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/mmc.h>
#include <asm/arch/clock.h>
#include <asm/arch/power.h>
#include <asm/arch/clk.h>
#include <asm/arch/smc.h>
#include "setup.h"

#define SECOND_BOOT_MODE	0xFEED0002
#define SDMMC_SECOND_DEV	0x101
#define USB_SECOND_DEV		0x100

/*
* Copy U-boot from mmc to RAM:
* COPY_BL2_FNPTR_ADDR: Address in iRAM, which Contains
* Pointer to API (Data transfer from mmc to ram)
*/
void copy_uboot_to_ram(unsigned int boot_dev)
{
#if 0
	u32 (*copy_bl2)(u32, u32, u32) = (void *) *(u32 *)COPY_BL2_FNPTR_ADDR;

	copy_bl2(BL2_START_OFFSET, BL2_SIZE_BLOC_COUNT, CONFIG_SYS_TEXT_BASE);
#else
	switch(boot_dev) {
		case BOOT_MMCSD:
		case BOOT_SEC_DEV:
			boot_dev = SDMMC_CH2;
			/* Set SCLK_MMC2 */
			set_mmc_clk(PERIPH_ID_SDMMC2, 40);
			break;
		case BOOT_EMMC_4_4:
			boot_dev = EMMC;
			/* Set SCLK_MMC0 */
			set_mmc_clk(PERIPH_ID_SDMMC0, 10);
			break;
		case BOOT_USB:
			boot_dev = USB;

			break;

	}
	/* TODO : add functions for loading image */
	/* Load u-boot image to ram */
	load_uboot_image(boot_dev);

	/* Load tzsw image & U-Boot boot */
	coldboot(boot_dev);
#endif
}

/* find boot device for secondary booting */
static int find_second_boot_dev(void)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	unsigned int dev =  readl(&pmu->irom_data_reg0);

	writel(0x1, CONFIG_SECONDARY_BOOT_INFORM_BASE);

	if (dev == SDMMC_SECOND_DEV)
		return BOOT_SEC_DEV;
	else if (dev == USB_SECOND_DEV)
		return BOOT_USB;
	else return 0;
}

void load_uboot(void)
{
	unsigned int om_status = readl(EXYNOS5_POWER_BASE + INFORM3_OFFSET);
	unsigned int boot_dev = 0;

	/* TODO : find second boot function */
	if (find_second_boot() == SECOND_BOOT_MODE)
		boot_dev = find_second_boot_dev();

	if (!boot_dev)
		boot_dev = om_status;

	copy_uboot_to_ram(boot_dev);

}

void board_init_f(unsigned long bootflag)
{
	__attribute__((noreturn)) void (*uboot)(void);
	load_uboot();

	/* Jump to U-Boot image */
	uboot = (void *)CONFIG_SYS_TEXT_BASE;
	(*uboot)();
	/* Never returns Here */
}

/* Place Holders */
void board_init_r(gd_t *id, ulong dest_addr)
{
	/* Function attribute is no-return */
	/* This Function never executes */
	while (1)
		;
}

void save_boot_params(u32 r0, u32 r1, u32 r2, u32 r3) {}
