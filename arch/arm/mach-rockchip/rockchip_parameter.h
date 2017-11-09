/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _ROCKCHIP_PARAMS_H_
#define _ROCKCHIP_PARAMS_H_

#include <linux/list.h>

#define RK_PARAM_OFFSET			0x2000
#define PART_NAME_SIZE			32
#define RK_BLK_SIZE			(1 << 9)

struct blk_part {
	char name[PART_NAME_SIZE];
	unsigned long from;
	unsigned long size;
	struct list_head node;
};

struct blk_part *rockchip_get_blk_part(const char *name);

#endif
