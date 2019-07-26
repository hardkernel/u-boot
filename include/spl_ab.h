/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _SPL_AB_H_
#define _SPL_AB_H_

#include <android_avb/libavb_ab.h>
#include <android_avb/avb_ab_flow.h>

#define AB_METADATA_OFFSET 4

/*
 * spl_get_current_slot
 *
 * @dev_desc: block description
 * @partition: partition name
 * @slot: A/B slot
 *
 * return: 0 success, others fail.
 */
int spl_get_current_slot(struct blk_desc *dev_desc, char *partition,
			 char *slot);

/*
 * spl_get_partitions_sector
 *
 * @dev_desc: block description
 * @partition: partition name
 * @sectors: firmware load address
 */
int spl_get_partitions_sector(struct blk_desc *dev_desc, char *partition,
			       u32 *sectors);

 #endif
