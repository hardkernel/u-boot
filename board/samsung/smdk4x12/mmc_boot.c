/*
 * Copyright (C) 2011 Samsung Electronics
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

#include<common.h>
#include<config.h>

#define SDMMC_SECOND_DEV	0x28 /* 1st_dev: eMMC, 2nd_dev: SD/MMC */
#define SECOND_BOOT_MODE	0xFEED0002
#define UBOOT			0x1
#define TZSW			0x2
#define SIGNATURE_CHECK_FAIL	-1

/* find boot device for secondary booting */
static int find_second_boot_dev(void)
{
	unsigned int om_status = readl(EXYNOS4_POWER_BASE + OM_STATUS_OFFSET);

	om_status &= 0x3E;

	writel(0x1, CONFIG_SECONDARY_BOOT_INFORM_BASE);

	if (om_status == SDMMC_SECOND_DEV)
		return BOOT_SEC_DEV;
	else
		return -1;
}

static unsigned int device(unsigned int dev)
{
	if ((dev == BOOT_MMCSD) || (dev == BOOT_SEC_DEV))
		return SDMMC_CH2;
	else if (dev == BOOT_EMMC_4_4)
		return EMMC_4_4;
	else
		while(1);
}

static int ld_image_from_2nd_dev(int image)
{
	int ret = 0;
	unsigned int boot_dev = 0;

	boot_dev = find_second_boot_dev();

	/* sdmmc enumerate */
	if (device(boot_dev) == SDMMC_CH2)
		sdmmc_enumerate();

	switch (image) {

	case UBOOT:
		/* load uboot from 2nd dev */
		ret = load_uboot_image(device(boot_dev));
		break;
	case TZSW:
		/* load uboot from 2nd dev */
		ret = coldboot(device(boot_dev));
		break;
	defalut:
		ret = SIGNATURE_CHECK_FAIL;
		break;
	}

	if (ret == SIGNATURE_CHECK_FAIL)
		while(1);

	return boot_dev;
}

void load_uboot(void)
{
	unsigned int om_status = readl(EXYNOS4_POWER_BASE + INFORM3_OFFSET);
	unsigned int boot_dev = 0;
	int ret = 0;

	/* verify recovery boot mode */
	if (find_second_boot() == SECOND_BOOT_MODE)
		boot_dev = find_second_boot_dev();

	if (!boot_dev)
		boot_dev = om_status;

	/* Load u-boot image to ram */
	ret = load_uboot_image(device(boot_dev));
	if (ret == SIGNATURE_CHECK_FAIL)
		boot_dev = ld_image_from_2nd_dev(UBOOT);

	/* Load tzsw image & U-Boot boot */
	ret = coldboot(device(boot_dev));
	if (ret == SIGNATURE_CHECK_FAIL)
		ld_image_from_2nd_dev(TZSW);

}

void board_init_f(unsigned long bootflag)
{
	__attribute__((noreturn)) void (*uboot)(void);

	/* Jump to U-Boot image */
	load_uboot();
	/* Never returns Here */
}

/* Place Holders */
void board_init_r(gd_t *id, ulong dest_addr)
{
	/*Function attribute is no-return*/
	/*This Function never executes*/
	while (1)
		;
}

void save_boot_params(u32 r0, u32 r1, u32 r2, u32 r3)
{
}
