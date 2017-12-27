/*
 * Copyright (C) 2017 Hardkernel Co,. Ltd
 * 	Joy Cho <joy.cho@hardkernel.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <linux/sizes.h>
#include <linux/string.h>
#include <mmc.h>

/*
 * Scan all of boot devices and check magic pattern
 * magic1 : 6 chars of fixed uboot header pattern
 * magic2 : 4 chars of fixed trust header pattern
 */
#define MMC_DEV_SDHCI	0	/* sdhci@fe330000 */
#define MMC_DEV_DWMMC	1	/* sdmmc@fe320000 */
#define MAGIC_OFFSET1	16384
#define MAGIC_OFFSET2	24576
static const char *magic1 = "LOADER";
static const char *magic2 = "BL3X";

int board_check_magic(struct blk_desc *dev_desc)
{
	char pattern[512];

	/* Check magic1 */
	if (blk_dread(dev_desc, MAGIC_OFFSET1, 1, pattern) != 1) {
		printf("scan boot: block read fail\n");
		return -EIO;
	}

	if (0 != strncmp(pattern, magic1, strlen(magic1))) {
		printf("scan boot: magic1 fail");
		return -EIO;
	}

	/* Check magic2 */
	if (blk_dread(dev_desc, MAGIC_OFFSET2, 1, pattern) != 1) {
		printf("scan boot: block read fail\n");
		return -EIO;
	}

	if (0 != strncmp(pattern, magic2, strlen(magic2))) {
		printf("scan boot: magic2 fail");
		return -EIO;
	}

	return 0;
}

int board_scan_boot_storage(void)
{
	struct mmc *mmc;
	struct blk_desc *dev_desc;

	/* First, try checking eMMC */
	mmc = find_mmc_device(MMC_DEV_SDHCI);
	if (!mmc) {
		printf("no sdhci device\n");
	} else {
		dev_desc = blk_get_dev("mmc", MMC_DEV_SDHCI);
		if (dev_desc) {
			if (0 == board_check_magic(dev_desc)) {
				/* Two magic patterns are available
				 * on eMMC, so related env is set
				 * and then exit this routine.
				 */
				char *s = getenv("storagemedia");
				if ((s == 0) || (strcmp(s, "emmc") != 0)) {
					setenv("storagemedia", "emmc");
					setenv("bootdev", "0");
					saveenv();
				}

				return 0;
			}
		}
	}

	/* No emmc magic, now try sdmmc */
	mmc = find_mmc_device(MMC_DEV_DWMMC);
	if (!mmc) {
		printf("no sdmmc device, no way...\n");
	} else {
		dev_desc = blk_get_dev("mmc", MMC_DEV_DWMMC);
		if (dev_desc) {
			if (0 == board_check_magic(dev_desc)) {
				char *s = getenv("storagemedia");
				if ((s == 0) || (strcmp(s, "sd") != 0)) {
					setenv("storagemedia", "sd");
					setenv("bootdev", "1");
					saveenv();
				}

				return 0;
			}
		}
	}

	return -EIO;
}
