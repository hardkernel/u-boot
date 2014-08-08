/*
 * Copyright (C) 2013 Samsung Electronics
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

#define SDMMC_SECOND_DEV	0x28
#define SIGNATURE_CHECK_FAIL	-1
#define SECOND_BOOT_MODE	0xFEED0002

/*
* Copy U-boot from mmc to RAM:
* COPY_BL2_FNPTR_ADDR: Address in iRAM, which Contains
* Pointer to API (Data transfer from mmc to ram)
*/

static int find_second_boot_dev(void)
{
	unsigned int om_status = readl(EXYNOS5_POWER_BASE + OM_STATUS_OFFSET);

	om_status &= 0x3E;

	writel(0x1, CONFIG_SECONDARY_BOOT_INFORM_BASE);

	if (om_status == SDMMC_SECOND_DEV)
		return BOOT_SEC_DEV;
	else
		while (1);

	return 0;
}

void copy_uboot_to_ram(unsigned int boot_dev)
{
	int ret = 0;

	switch (boot_dev) {
		case BOOT_MMCSD:
		case BOOT_SEC_DEV:
			boot_dev = SDMMC_CH2;
			break;
		case BOOT_EMMC_4_4:
			boot_dev = EMMC;
			break;
		case BOOT_USB:
			boot_dev = USB;
			break;
	}
	/* Load u-boot image to ram */
	ret = load_uboot_image(boot_dev);
	if (ret == SIGNATURE_CHECK_FAIL) {
		sdmmc_enumerate();
		if (find_second_boot_dev() == BOOT_SEC_DEV)
			boot_dev = SDMMC_CH2;
		ret = load_uboot_image(boot_dev);
		if (ret == SIGNATURE_CHECK_FAIL)
			while (1);
	}

	/* Load tzsw image & U-Boot boot */
	ret = coldboot(boot_dev);
	if (ret == SIGNATURE_CHECK_FAIL) {
		sdmmc_enumerate();
		if (find_second_boot_dev() == BOOT_SEC_DEV)
			boot_dev = SDMMC_CH2;
		ret = coldboot(boot_dev);
		if (ret == SIGNATURE_CHECK_FAIL)
			while (1);
	}
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
