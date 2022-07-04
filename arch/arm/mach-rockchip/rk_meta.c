/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2022 Rockchip Electronics Co., Ltd
 *
 */

#include <common.h>
#include <boot_rkimg.h>
#include <crc.h>
#include <errno.h>
#include <fdt_support.h>
#include <image.h>
#include <spl.h>
#include <asm/arch/rk_meta.h>

static char *cmdline;

int spl_load_meta(struct spl_image_info *spl_image, struct spl_load_info *info)
{
	const char *part_name = PART_META;
	disk_partition_t part_info;
	struct meta_head meta;
	struct rk_amp_info *amp_info;
	struct cmdline_info *cmd;
	ulong sector;
	char *data;

	if (part_get_info_by_name(info->dev, part_name, &part_info) <= 0) {
		debug("%s: no partition\n", __func__);
		return -EINVAL;
	}
	sector = part_info.start;

	memset(&meta, 0, sizeof(struct meta_head));
	if (info->read(info, sector, 1, &meta) != 1) {
		debug("%s: Failed to read header\n", __func__);
		return -EIO;
	}

	if (meta.tag != RK_META) {
		debug("Invalid meta tag is %x.\n", meta.tag);
		return -EINVAL;
	}

	if (meta.crc32 != crc32(0, (const unsigned char *)&meta, sizeof(struct meta_head) - 4)) {
		debug("Invalid meta crc32.\n");
		return -EINVAL;
	}

	sector += RK_META_DATA_OFFSET;
	data = (char *)meta.load + 512;
	debug("Meta: load addr is %x, size is %x\n", meta.load, meta.size);
	if (info->read(info, sector, meta.size / 512, data) != (meta.size / 512)) {
		debug("%s: Failed to read header\n", __func__);
		return -EIO;
	}

	cmd = (struct cmdline_info *)(data + CMDLINE_OFFSET - META_INFO_SIZE);
	if (cmd->tag == RK_CMDLINE) {
		if (cmd->crc32 == crc32(0, (const unsigned char *)cmd, sizeof(struct cmdline_info) - 4))
			cmdline = (char *)cmd->data;
	}

	amp_info = (struct rk_amp_info *)meta.load;
	memset(amp_info, 0, sizeof(struct rk_amp_info));
	amp_info->tag = RK_AMP;
	amp_info->flags = RK_AMP_DATA_READY;
	amp_info->crc32 = crc32(0, (const unsigned char *)&amp_info, sizeof(struct rk_amp_info) - 4);
	flush_cache(meta.load, meta.size);

	return 0;
}

void rk_meta_bootargs_append(void *fdt)
{
	fdt_bootargs_append(fdt, cmdline);
}
