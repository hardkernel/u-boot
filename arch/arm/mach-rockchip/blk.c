/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <mmc.h>
#include "rockchip_blk.h"

static struct mmc *mmc;

struct mmc *mmcblk_dev_init(int dev)
{
	struct mmc *mmcdev;

	mmcdev = find_mmc_device(dev);
	if (!mmcdev) {
		printf("no mmc device at slot %x\n", dev);
		return NULL;
	}

	if (mmc_init(mmcdev))
		return NULL;

	return mmcdev;
}

static int mmcblk_read(struct mmc *mmcdev, void *buffer, u32 blk, u32 cnt)
{
	u32 n;
	ulong start = (ulong)buffer;

	debug("\nMMC read: block # 0x%x, count 0x%x  to %p... ", blk, cnt, buffer);

	n = blk_dread(mmc_get_blk_desc(mmcdev), blk, cnt, buffer);
	/* invalidate cache after read via dma */
	invalidate_dcache_range(start, start + cnt * 512);
	debug("%d blocks read: %s\n", n, (n == cnt) ? "OK" : "ERROR");

	return (n == cnt) ? 0 : -EIO;
}


int blkdev_read(void *buffer, u32 blk, u32 cnt)
{
	if (!mmc) {
		mmc = mmcblk_dev_init(env_get_ulong("mmcdev", 10, 0));
		if (!mmc)
			return -ENODEV;
	}

	return mmcblk_read(mmc, buffer, blk, cnt);
}

static int mmcblk_write(struct mmc *mmcdev, void *buffer, u32 blk, u32 cnt)
{
	u32 n;

	debug("\nMMC write: block # 0x%x, count 0x%x  from %p... ",
	      blk, cnt, buffer);

	n = blk_dwrite(mmc_get_blk_desc(mmcdev), blk, cnt, buffer);
	debug("%d blocks write: %s\n", n, (n == cnt) ? "OK" : "ERROR");

	return (n == cnt) ? 0 : -EIO;
}

int blkdev_write(void *buffer, u32 blk, u32 cnt)
{
	if (!mmc) {
		mmc = mmcblk_dev_init(env_get_ulong("mmcdev", 10, 0));
		if (!mmc)
			return -ENODEV;
	}

	return mmcblk_write(mmc, buffer, blk, cnt);
}

/* Gets the storage type of the current device */
int get_bootdev_type(void)
{
	int type = 0;

	#ifdef CONFIG_EMMC_BOOT
		type = BOOT_FROM_EMMC;
	#endif /* CONFIG_EMMC_BOOT */
	#ifdef CONFIG_QSPI_BOOT
		type = BOOT_FROM_SPI_NAND;
	#endif /* CONFIG_QSPI_BOOT */
	#ifdef CONFIG_NAND_BOOT
		typpe = BOOT_FROM_FLASH;
	#endif /* CONFIG_NAND_BOOT */
	#ifdef CONFIG_NOR_BOOT
		type = BOOT_FROM_SPI_NOR;
	#endif /* CONFIG_NOR_BOOT */

	/* For current use(Only EMMC support!) */
	if (!type)
		type = BOOT_FROM_EMMC;

	return type;
}

