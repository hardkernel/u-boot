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
