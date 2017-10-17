/*
 * Copyright 2014 Broadcom Corporation.
 * Copyright 2015 Free Electrons.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <config.h>
#include <common.h>

/* #include <fastboot.h> */
/*#include <image-sparse.h> */
#include <aboot.h>
#include <linux/mtd/mtd.h>
#include <jffs2/jffs2.h>
#include <nand.h>
#include <fb_fastboot.h>
#include <amlogic/aml_nand.h>

struct fb_nand_sparse {
	nand_info_t	*nand;
	struct part_info	*part;
};

__weak int board_fastboot_erase_partition_setup(char *name)
{
	return 0;
}

__weak int board_fastboot_write_partition_setup(char *name)
{
	return 0;
}

static int fb_nand_lookup(const char *partname,
			  nand_info_t **nand,
			  struct part_info **part)
{
#ifdef CONFIG_CMD_MTDPARTS
	struct mtd_device *dev;
	int ret;
	u8 pnum;

	ret = mtdparts_init();
	if (ret) {
		error("Cannot initialize MTD partitions\n");
		fastboot_fail("cannot init mtdparts");
		return ret;
	}

	if (strcmp(partname, "dtb") == 0)
		return 0;
	ret = find_dev_and_part(partname, &dev, &pnum, part);
	if (ret) {
		error("cannot find partition: '%s'", partname);
		fastboot_fail("cannot find partition");
		return ret;
	}
#ifndef CONFIFG_AML_MTDPART
	if (dev->id->type != MTD_DEV_TYPE_NAND) {
		error("partition '%s' is not stored on a NAND device",
		      partname);
		fastboot_fail("not a NAND device");
		return -EINVAL;
	}
	*nand = get_nand_dev_by_index(dev->id->num);
#else
	if (strcmp(partname, "bootloader") == 0)
		*nand = get_nand_dev_by_index(0);
	else
		*nand = get_nand_dev_by_index(1);
#endif
	return 0;
#else
	error("%s,\n");
	return -1;
#endif
}

static int _fb_nand_erase(nand_info_t *nand, struct part_info *part)
{
	nand_erase_options_t opts;
	int ret;

	memset(&opts, 0, sizeof(opts));
	opts.offset = part->offset;
	opts.length = part->size;
	opts.quiet = 1;

	printf("Erasing blocks 0x%llx to 0x%llx\n",
	       part->offset, part->offset + part->size);

	ret = nand_erase_opts(nand, &opts);
	if (ret)
		return ret;

	printf("........ erased 0x%llx bytes from '%s'\n",
	       part->size, part->name);

	return 0;
}

static int _fb_nand_write(nand_info_t *nand, struct part_info *part,
			  void *buffer, unsigned int offset,
			  unsigned int length, size_t *written)
{
	/* int flags = WITH_WR_VERIFY; */
	int flags = 0;
	size_t len = 0;

#ifdef CONFIG_FASTBOOT_FLASH_NAND_TRIMFFS
	flags |= WITH_DROP_FFS;
#endif

	len = length;
	return nand_write_skip_bad(nand, offset, &len, written,
				   part->size - (offset - part->offset),
				   (u_char *)buffer, flags);
}

static lbaint_t fb_nand_sparse_write(struct sparse_storage *info,
		lbaint_t blk, lbaint_t blkcnt, const void *buffer)
{
	struct fb_nand_sparse *sparse = info->priv;
	size_t written;
	int ret;

	ret = _fb_nand_write(sparse->nand, sparse->part, (void *)buffer,
			     blk * info->blksz,
			     blkcnt * info->blksz, &written);
	if (ret < 0) {
		printf("Failed to write sparse chunk\n");
		return ret;
	}

/* TODO - verify that the value "written" includes the "bad-blocks" ... */

	/*
	 * the return value must be 'blkcnt' ("good-blocks") plus the
	 * number of "bad-blocks" encountered within this space...
	 */
	return written / info->blksz;
}

static lbaint_t fb_nand_sparse_reserve(struct sparse_storage *info,
		lbaint_t blk, lbaint_t blkcnt)
{
	int bad_blocks = 0;

/*
 * TODO - implement a function to determine the total number
 * of blocks which must be used in order to reserve the specified
 * number ("blkcnt") of "good-blocks", starting at "blk"...
 * ( possibly something like the "check_skip_len()" function )
 */

	/*
	 * the return value must be 'blkcnt' ("good-blocks") plus the
	 * number of "bad-blocks" encountered within this space...
	 */
	return blkcnt + bad_blocks;
}

void fb_nand_flash_write(const char *cmd, void *download_buffer,
			unsigned int download_bytes)
{
	struct part_info *part;
	nand_info_t *nand = NULL;
	int ret, err;
	int copy_num = 0, i = 0;
	u64 off = 0;
	size_t rwsize = 0, limit = 0;

	ret = fb_nand_lookup(cmd, &nand, &part);

	if (ret) {
		error(" invalid NAND device");
		fastboot_fail(" invalid NAND device");
		return;
	}

	if (strcmp(cmd, "bootloader") == 0) {
#ifdef CONFIG_DISCRETE_BOOTLOADER
		rwsize = download_bytes;
		copy_num = CONFIG_BL2_COPY_NUM;
		limit = nand->size / CONFIG_BL2_COPY_NUM;
#else
		rwsize = download_bytes;
		copy_num = get_boot_num(nand, rwsize);
		limit = nand->size / copy_num;
#endif
		for (i = 0; i < copy_num; i++) {
			printf("off = 0x%llx,wsize = 0x%lx\n", off, rwsize);
			err = nand_write_skip_bad(nand, off, &rwsize,
						NULL, limit,
						(u_char *)download_buffer, 0);
			if (err) {
				rwsize = download_bytes;
				error("bootloader write err,code = %d\n",err);
			}
			off += nand->size / copy_num;
		}
		fastboot_okay("write bootloader");
		return;
	}
#ifdef CONFIG_DISCRETE_BOOTLOADER
	if (strcmp(cmd, "tpl") == 0) {
		copy_num = CONFIG_TPL_COPY_NUM;
		rwsize = download_bytes;
		limit = CONFIG_TPL_SIZE_PER_COPY;
		off = 1024 * nand->writesize +
			RESERVED_BLOCK_NUM * nand->erasesize;

		for (i = 0; i < copy_num; i++) {
			printf("off = 0x%llx,wsize = 0x%lx\n", off, rwsize);
			err = nand_write_skip_bad(nand, off, &rwsize,
						NULL, limit,
						(u_char *)download_buffer, 0);
			if (err) {
				rwsize = download_bytes;
				error("tpl write err,code = %d\n",err);
			}
			off += CONFIG_TPL_SIZE_PER_COPY;
		}
		fastboot_okay("write tpl");
		return;
	}
#endif
	if (strcmp(cmd, "dtb") == 0) {
		ret = amlnf_dtb_save((u8 *)download_buffer, download_bytes);
		printf("Flashing dtb...len:0x%x\n", download_bytes);
		if (ret) {
			printf("write dtb fail,result code %d\n", ret);
			fastboot_fail("write dtb");
		} else {
			fastboot_okay("write dtb");
		}
		return;
	}
	ret = board_fastboot_write_partition_setup(part->name);
	if (ret)
		return;

	if (is_sparse_image(download_buffer)) {
		struct fb_nand_sparse sparse_priv;
		struct sparse_storage sparse;

		sparse_priv.nand = nand;
		sparse_priv.part = part;

		sparse.blksz = nand->writesize;
		sparse.start = part->offset / sparse.blksz;
		sparse.size = part->size / sparse.blksz;
		sparse.write = fb_nand_sparse_write;
		sparse.reserve = fb_nand_sparse_reserve;

		printf("Flashing sparse image at offset " LBAFU "\n",
		       sparse.start);

		sparse.priv = &sparse_priv;
		ret = write_sparse_image(&sparse, cmd, download_buffer,
				   download_bytes);
	} else {
		printf("Flashing raw image at offset 0x%llx\n",
		       part->offset);

		ret = _fb_nand_write(nand, part, download_buffer, part->offset,
				     download_bytes, NULL);

		printf("........ wrote %u bytes to '%s'\n",
		       download_bytes, part->name);
	}

	if (ret) {
		fastboot_fail("error writing the image");
		return;
	}

	fastboot_okay("");
}

void fb_nand_erase(const char *cmd, void *download_buffer)
{
	struct part_info *part;
	nand_info_t *nand = NULL;
	int ret;

	ret = fb_nand_lookup(cmd, &nand, &part);
	if (ret) {
		error("invalid NAND device");
		fastboot_fail("invalid NAND device");
		return;
	}

	if (strcmp(cmd, "dtb") == 0) {
		ret = amlnf_dtb_erase();
		if (ret) {
			printf("erase dtb fail,result code %d\n", ret);
			fastboot_fail("erase dtb");
		} else {
			fastboot_okay("erase dtb");
		}
		return;
	}

	ret = board_fastboot_erase_partition_setup(part->name);
	if (ret)
		return;

	ret = _fb_nand_erase(nand, part);
	if (ret) {
		error("failed erasing from device %s", nand->name);
		fastboot_fail("failed erasing from device");
		return;
	}

	fastboot_okay("");
}
