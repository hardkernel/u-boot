/*
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 	yonghui.yu@amlogic.com
 */


#ifndef __AML_MMC_H__
#define __AML_MMC_H__

#include <common.h>


/* bootloader operation */
#define AML_BL_USER		(0x1 << 0)
#define AML_BL_BOOT0	(0x1 << 1)
#define AML_BL_BOOT1	(0x1 << 2)
#define AML_BL_ALL		(0x7)

int amlmmc_write_bootloader(int dev, int map,
		unsigned int size, const void *src);
int amlmmc_erase_bootloader(int dev, int map);


/* interface on reserved area. */
void mmc_write_cali_mattern(void *addr);

/* dtb operation */
int dtb_write(void *addr);

/* emmc key operation */
int mmc_key_read(unsigned char *buf,
		unsigned int size, uint32_t *actual_lenth);
int mmc_key_write(unsigned char *buf,
		unsigned int size, uint32_t *actual_lenth);
int mmc_key_erase(void);

/* partition operation */
int renew_partition_tbl(unsigned char *buffer);
int find_dev_num_by_partition_name (char *name);

#ifdef CONFIG_AML_PARTITION
int emmc_update_mbr(unsigned char *buffer);
#endif


#endif /* __AML_MMC_H__ */
