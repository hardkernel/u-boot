/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <blk.h>
#include <boot_rkimg.h>
#include <dm.h>
#include <errno.h>
#include <malloc.h>
#include <nand.h>
#include <part.h>
#include <dm/device-internal.h>

#define MTD_PART_NAND_HEAD		"mtdparts="
#define MTD_PART_INFO_MAX_SIZE		512
#define MTD_SINGLE_PART_INFO_MAX_SIZE	40

static int *mtd_map_blk_table;

int mtd_blk_map_table_init(struct blk_desc *desc,
			   loff_t offset,
			   size_t length)
{
	u32 blk_total, blk_begin, blk_cnt;
	struct mtd_info *mtd = NULL;
	int i, j;

	if (!desc)
		return -ENODEV;

	if (desc->devnum == BLK_MTD_NAND) {
#if defined(CONFIG_NAND) && !defined(CONFIG_SPL_BUILD)
		mtd = dev_get_priv(desc->bdev->parent);
#endif
	} else if (desc->devnum == BLK_MTD_SPI_NAND) {
#if defined(CONFIG_MTD_SPI_NAND) && !defined(CONFIG_SPL_BUILD)
		mtd = desc->bdev->priv;
#endif
	}

	if (!mtd) {
		return -ENODEV;
	} else {
		blk_total = (mtd->size + mtd->erasesize - 1) / mtd->erasesize;
		if (!mtd_map_blk_table) {
			mtd_map_blk_table = (int *)malloc(blk_total * 4);
			for (i = 0; i < blk_total; i++)
				mtd_map_blk_table[i] = i;
		}

		blk_begin = (u32)offset / mtd->erasesize;
		blk_cnt = ((u32)(offset % mtd->erasesize + length) / mtd->erasesize);
		if ((blk_begin + blk_cnt) > blk_total)
			blk_cnt = blk_total - blk_begin;
		j = 0;
		 /* should not across blk_cnt */
		for (i = 0; i < blk_cnt; i++) {
			if (j >= blk_cnt)
				mtd_map_blk_table[blk_begin + i] = -1;
			for (; j < blk_cnt; j++) {
				if (!mtd_block_isbad(mtd, (blk_begin + j) * mtd->erasesize)) {
					mtd_map_blk_table[blk_begin + i] = blk_begin + j;
					j++;
					if (j == blk_cnt)
						j++;
					break;
				}
			}
		}

		return 0;
	}
}

static __maybe_unused int mtd_map_read(struct mtd_info *mtd, loff_t offset,
				       size_t *length, size_t *actual,
				       loff_t lim, u_char *buffer)
{
	size_t left_to_read = *length;
	u_char *p_buffer = buffer;
	u32 erasesize = mtd->erasesize;
	int rval;

	while (left_to_read > 0) {
		size_t block_offset = offset & (erasesize - 1);
		size_t read_length;
		loff_t mapped_offset;
		bool mapped;

		if (offset >= mtd->size)
			return 0;

		mapped_offset = offset;
		mapped = false;
		if (mtd_map_blk_table)  {
			mapped = true;
			mapped_offset = (loff_t)((u32)mtd_map_blk_table[(u64)offset /
				erasesize] * erasesize + block_offset);
		}

		if (!mapped) {
			if (mtd_block_isbad(mtd, offset & ~(erasesize - 1))) {
				printf("Skip bad block 0x%08llx\n",
				       offset & ~(erasesize - 1));
				offset += erasesize - block_offset;
				continue;
			}
		}

		if (left_to_read < (erasesize - block_offset))
			read_length = left_to_read;
		else
			read_length = erasesize - block_offset;

		rval = mtd_read(mtd, mapped_offset, read_length, &read_length,
				p_buffer);
		if (rval && rval != -EUCLEAN) {
			printf("NAND read from offset %llx failed %d\n",
			       mapped_offset, rval);
			*length -= left_to_read;
			return rval;
		}

		left_to_read -= read_length;
		offset       += read_length;
		p_buffer     += read_length;
	}

	return 0;
}

char *mtd_part_parse(void)
{
	char mtd_part_info_temp[MTD_SINGLE_PART_INFO_MAX_SIZE] = {0};
	u32 length, data_len = MTD_PART_INFO_MAX_SIZE;
	struct blk_desc *dev_desc;
	disk_partition_t info;
	char *mtd_part_info_p;
	struct mtd_info *mtd;
	char *mtd_part_info;
	int ret;
	int p;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc)
		return NULL;

	mtd = (struct mtd_info *)dev_desc->bdev->priv;
	if (!mtd)
		return NULL;

	mtd_part_info = (char *)calloc(MTD_PART_INFO_MAX_SIZE, sizeof(char));
	if (!mtd_part_info) {
		printf("%s: Fail to malloc!", __func__);
		return NULL;
	}

	mtd_part_info_p = mtd_part_info;
	snprintf(mtd_part_info_p, data_len - 1, "%s%s:",
		 MTD_PART_NAND_HEAD,
		 dev_desc->product);
	data_len -= strlen(mtd_part_info_p);
	mtd_part_info_p = mtd_part_info_p + strlen(mtd_part_info_p);

	for (p = 1; p < MAX_SEARCH_PARTITIONS; p++) {
		ret = part_get_info(dev_desc, p, &info);
		if (ret)
			break;

		debug("name is %s, start addr is %x\n", info.name,
		      (int)(size_t)info.start);

		snprintf(mtd_part_info_p, data_len - 1, "0x%x@0x%x(%s)",
			 (int)(size_t)info.size << 9,
			 (int)(size_t)info.start << 9,
			 info.name);
		snprintf(mtd_part_info_temp, MTD_SINGLE_PART_INFO_MAX_SIZE - 1,
			 "0x%x@0x%x(%s)",
			 (int)(size_t)info.size << 9,
			 (int)(size_t)info.start << 9,
			 info.name);
		strcat(mtd_part_info, ",");
		if (part_get_info(dev_desc, p + 1, &info)) {
			/* Nand flash is erased by block and gpt table just
			 * resserve 33 sectors for the last partition. This
			 * will erase the backup gpt table by user program,
			 * so reserve one block.
			 */
			snprintf(mtd_part_info_p, data_len - 1, "0x%x@0x%x(%s)",
				 (int)(size_t)(info.size -
				 (info.size - 1) %
				 (mtd->erasesize >> 9) - 1) << 9,
				 (int)(size_t)info.start << 9,
				 info.name);
			break;
		}
		length = strlen(mtd_part_info_temp);
		data_len -= length;
		mtd_part_info_p = mtd_part_info_p + length + 1;
		memset(mtd_part_info_temp, 0, MTD_SINGLE_PART_INFO_MAX_SIZE);
	}

	return mtd_part_info;
}

ulong mtd_dread(struct udevice *udev, lbaint_t start,
		lbaint_t blkcnt, void *dst)
{
	struct blk_desc *desc = dev_get_uclass_platdata(udev);
#if defined(CONFIG_NAND) || defined(CONFIG_MTD_SPI_NAND) || defined(CONFIG_SPI_FLASH_MTD)
	loff_t off = (loff_t)(start * 512);
	size_t rwsize = blkcnt * 512;
#endif
	struct mtd_info *mtd;
	int ret = 0;

	if (!desc)
		return ret;

	mtd = desc->bdev->priv;
	if (!mtd)
		return 0;

	if (blkcnt == 0)
		return 0;

	if (desc->devnum == BLK_MTD_NAND) {
#if defined(CONFIG_NAND) && !defined(CONFIG_SPL_BUILD)
		mtd = dev_get_priv(udev->parent);
		if (!mtd)
			return 0;

		ret = nand_read_skip_bad(mtd, off, &rwsize,
					 NULL, mtd->size,
					 (u_char *)(dst));
#else
		ret = mtd_map_read(mtd, off, &rwsize,
				   NULL, mtd->size,
				   (u_char *)(dst));
#endif
		if (!ret)
			return blkcnt;
		else
			return 0;
	} else if (desc->devnum == BLK_MTD_SPI_NAND) {
		ret = mtd_map_read(mtd, off, &rwsize,
				   NULL, mtd->size,
				   (u_char *)(dst));
		if (!ret)
			return blkcnt;
		else
			return 0;
	} else if (desc->devnum == BLK_MTD_SPI_NOR) {
#if defined(CONFIG_SPI_FLASH_MTD) || defined(CONFIG_SPL_BUILD)
		size_t retlen_nor;

		mtd_read(mtd, off, rwsize, &retlen_nor, dst);
		if (retlen_nor == rwsize)
			return blkcnt;
		else
#endif
			return 0;
	} else {
		return 0;
	}
}

ulong mtd_dwrite(struct udevice *udev, lbaint_t start,
		 lbaint_t blkcnt, const void *src)
{
	/* Not implemented */
	return 0;
}

ulong mtd_derase(struct udevice *udev, lbaint_t start,
		 lbaint_t blkcnt)
{
	/* Not implemented */
	return 0;
}

static int mtd_blk_probe(struct udevice *udev)
{
	struct mtd_info *mtd = dev_get_uclass_priv(udev->parent);
	struct blk_desc *desc = dev_get_uclass_platdata(udev);
	int ret, i;

	desc->bdev->priv = mtd;
	sprintf(desc->vendor, "0x%.4x", 0x2207);
	memcpy(desc->product, mtd->name, strlen(mtd->name));
	memcpy(desc->revision, "V1.00", sizeof("V1.00"));
	if (mtd->type == MTD_NANDFLASH) {
		if (desc->devnum == BLK_MTD_NAND)
			mtd = dev_get_priv(udev->parent);
		/*
		 * Find the first useful block in the end,
		 * and it is the end lba of the nand storage.
		 */
		for (i = 0; i < (mtd->size / mtd->erasesize); i++) {
			ret =  mtd_block_isbad(mtd,
					       mtd->size - mtd->erasesize * (i + 1));
			if (!ret) {
				desc->lba = (mtd->size >> 9) -
					(mtd->erasesize >> 9) * i;
				break;
			}
		}
	} else {
		desc->lba = mtd->size >> 9;
	}

	debug("MTD: desc->lba is %lx\n", desc->lba);

	return 0;
}

static const struct blk_ops mtd_blk_ops = {
	.read	= mtd_dread,
#ifndef CONFIG_SPL_BUILD
	.write	= mtd_dwrite,
	.erase	= mtd_derase,
#endif
};

U_BOOT_DRIVER(mtd_blk) = {
	.name		= "mtd_blk",
	.id		= UCLASS_BLK,
	.ops		= &mtd_blk_ops,
	.probe		= mtd_blk_probe,
};
