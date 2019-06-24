/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _MTD_BLK_H_
#define _MTD_BLK_H_

/**
 * mtd_part_parse() - Parse the block part info to mtd part info
 *
 * @return mtd part info. If fail, return NULL
 */
char *mtd_part_parse(void);

#endif
