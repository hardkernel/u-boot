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

__weak void rk_meta_process(void) { }

int spl_load_meta(struct spl_image_info *spl_image, struct spl_load_info *info)
{
	const char *part_name = PART_META;
	disk_partition_t part_info;
	struct meta_head meta;
	struct meta_head *meta_p;
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

	if (meta.crc32 != crc32(0, (const unsigned char *)&meta, sizeof(struct meta_head) - 4 - 4)) {
		debug("Invalid meta crc32.\n");
		return -EINVAL;
	}

	data = (char *)meta.load;
	printf("Meta: 0x%08x - 0x%08x\n", meta.load, meta.load + meta.size);
	if (info->read(info, sector, meta.size / 512, data) != (meta.size / 512)) {
		debug("%s: Failed to read header\n", __func__);
		return -EIO;
	}

	meta_p = (struct meta_head *)meta.load;

	cmd = (struct cmdline_info *)(meta_p->load + CMDLINE_OFFSET);
	if (cmd->tag == RK_CMDLINE) {
		if (cmd->crc32 == crc32(0, (const unsigned char *)cmd, sizeof(struct cmdline_info) - 4))
			cmdline = (char *)cmd->data;
	}

	meta_p->meta_flags = META_READ_DONE_FLAG;
	flush_cache(meta_p->load, meta_p->size);
	rk_meta_process();

	return 0;
}

void rk_meta_bootargs_append(void *fdt)
{
	if (!cmdline || (!fdt || fdt_check_header(fdt)))
		return;

	fdt_bootargs_append(fdt, cmdline);
}
