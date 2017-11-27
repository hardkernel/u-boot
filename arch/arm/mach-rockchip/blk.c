/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <blk.h>
#include <dm.h>
#include <mmc.h>
#include <rknand.h>
#include <spi.h>
#include <spi_flash.h>
#include "rockchip_blk.h"

struct blkdev {
	int if_type;
	int devnum;
	ulong (*write)(struct blkdev *blkdev, lbaint_t start, lbaint_t blkcnt, const void *buffer);
	ulong (*read)(struct blkdev *blkdev, lbaint_t start, lbaint_t blkcnt, void *buffer);
	void *priv;
};

static struct blkdev *blkdev;

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

static struct spi_flash *spi_flash_init(int dev)
{
	struct spi_flash *flash;
	struct udevice *udev;
	int ret;

	ret = spi_flash_probe_bus_cs(0, 0, 0, 0, &udev);
	if (ret) {
		printf("Failed to initialize SPI flash(error %d)\n", ret);
		return NULL;
	}

	flash = dev_get_uclass_priv(udev);

	return flash;
}

ulong blk_read(struct blkdev* blkdev, lbaint_t start, lbaint_t blkcnt, void *buffer)
{
	struct blk_desc *desc;
	const char *if_name;
	ulong n;

	if_name = blk_get_if_type_name(blkdev->if_type);
	desc = blk_get_dev(if_name, blkdev->devnum);
	n = blk_dread(desc, start, blkcnt, buffer);

	return n == blkcnt ? 0 : 1;
}

ulong blk_write(struct blkdev *blkdev, lbaint_t start, lbaint_t blkcnt, const void *buffer)
{
	struct blk_desc *desc;
	const char *if_name;
	ulong n;

	if_name = blk_get_if_type_name(blkdev->if_type);
	desc = blk_get_dev(if_name, blkdev->devnum);
	n = blk_dwrite(desc, start, blkcnt, buffer);

	return n == blkcnt ? 0 : 1;
}

ulong sf_read(struct blkdev *blkdev, lbaint_t start, lbaint_t blkcnt, void *buffer)
{
	struct spi_flash *flash = (struct spi_flash *)blkdev->priv;
	u32 offset = start << 9;
	size_t len = blkcnt << 9;

	return spi_flash_read(flash, offset, len, buffer);
}

ulong sf_write(struct blkdev *blkdev, lbaint_t start, lbaint_t blkcnt, const void *buffer)
{
	struct spi_flash *flash = (struct spi_flash *)blkdev->priv;
	u32 offset = start << 9;
	size_t len = blkcnt << 9;

	return spi_flash_write(flash, offset, len, buffer);
}

static int get_bootdev_if_type(int dev)
{
	int if_type;

	switch (dev) {
	case BOOT_FROM_EMMC:
		if_type = IF_TYPE_MMC;
		break;
	case BOOT_FROM_FLASH:
		if_type = IF_TYPE_RKNAND;
		break;
	default:
		if_type = dev;
		break;
	}

	return if_type;
}

static struct blkdev *blkdev_init(void)
{
	struct blkdev *blkdev;
	int dev;
	int if_type;
	void *priv;


	dev = get_bootdev_type();
	if_type = get_bootdev_if_type(dev);

	if (if_type == IF_TYPE_MMC) {
		priv = mmcblk_dev_init(0);
	} else if (if_type == IF_TYPE_RKNAND) {
		priv = (void *)rknand_scan_namespace();
	} else if (if_type == BOOT_FROM_SPI_NOR) {
		priv = spi_flash_init(0);
	}

	blkdev = malloc(sizeof(*blkdev));
	if (!blkdev) {
		printf("out of memory for blkdev\n");
		return NULL;
	}

	blkdev->if_type = if_type;
	blkdev->devnum = 0;
	blkdev ->priv = priv;
	if ((if_type == IF_TYPE_MMC) || (if_type == IF_TYPE_RKNAND)) {
		blkdev->read = blk_read;
		blkdev->write = blk_write;
	} else if (if_type == BOOT_FROM_SPI_NOR) {
		blkdev->read = sf_read;
		blkdev->write = sf_write;
	}

	return blkdev;
}

int blkdev_read(void *buffer, u32 blk, u32 cnt)
{
	if (!blkdev) {
		blkdev = blkdev_init();
		if (!blkdev)
			return -ENODEV;
	}

	return blkdev->read(blkdev, blk, cnt, buffer);
}


int blkdev_write(void *buffer, u32 blk, u32 cnt)
{
	if (!blkdev) {
		blkdev = blkdev_init();
		if (!blkdev)
			return -ENODEV;
	}

	return blkdev->write(blkdev, blk, cnt, buffer);
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
		type = BOOT_FROM_FLASH;
	#endif /* CONFIG_NAND_BOOT */
	#ifdef CONFIG_NOR_BOOT
		type = BOOT_FROM_SPI_NOR;
	#endif /* CONFIG_NOR_BOOT */

	/* For current use(Only EMMC support!) */
	if (!type)
		type = BOOT_FROM_EMMC;

	return type;
}
