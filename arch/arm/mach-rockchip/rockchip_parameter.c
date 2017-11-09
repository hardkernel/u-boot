/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <malloc.h>
#include "rockchip_parameter.h"
#include "rockchip_blk.h"

#define MAX_PARAM_SIZE			(1024 * 64)

struct rockchip_param {
	u32 tag;
	u32 length;
	char params[1];
	u32 crc;
};

static LIST_HEAD(parts_head);

static int rockchip_param_parse(char *param)
{
	struct blk_part *part;
	const char *cmdline = strstr(param, "CMDLINE:");
	char *cmdline_end = strstr(cmdline, "\n"); /* end by '\n' */
	const char *blkdev_parts = strstr(cmdline, "mtdparts");
	const char *blkdev_def = strchr(blkdev_parts, ':') + 1;
	char *next = (char *)blkdev_def;
	char *pend;
	int len;
	unsigned long size, from;

	if (!cmdline) {
		printf("invalid parameter\n");
		return -EINVAL;
	}

	*cmdline_end = '\0';
	debug("%s", cmdline);
	/* skip "CMDLINE:" */
	env_update("bootargs", cmdline + strlen("CMDLINE:"));

	while (*next) {
		if (*next == '-') {
			size = (~0UL);
			next++;
		} else {
			size = simple_strtoul(next, &next, 16);
		}
		next++;
		from = simple_strtoul(next, &next, 16);
		next++;
		pend =  strchr(next, ')');
		if (!pend)
			break;
		len = min_t(int, pend - next, PART_NAME_SIZE);
		part = malloc(sizeof(*part));
		if (!part) {
			printf("out of memory\n");
			break;
		}
		part->from = from;
		part->size = size;
		strncpy(part->name, next, len);
		part->name[len] = '\0';
		next = strchr(next, ',');
		next++;
		list_add_tail(&part->node, &parts_head);
		debug("0x%lx@0x%lx(%s)\n", part->size, part->from, part->name);
	}

	return 0;
}

static int rockchip_init_param(void)
{
	struct rockchip_param *param;

	param = memalign(ARCH_DMA_MINALIGN, MAX_PARAM_SIZE);
	if (!param) {
		printf("out of memory\n");
		return -ENOMEM;
	}

	blkdev_read(param, RK_PARAM_OFFSET, MAX_PARAM_SIZE >> 9);

	return rockchip_param_parse(param->params);

}

struct blk_part *rockchip_get_blk_part(const char *name)
{
	struct blk_part *part;
	struct list_head *node;

	if (list_empty(&parts_head))
		rockchip_init_param();

	list_for_each(node, &parts_head) {
		part = list_entry(node, struct blk_part, node);
		if (!strcmp(part->name, name))
			return part;
	}

	return NULL;
}


