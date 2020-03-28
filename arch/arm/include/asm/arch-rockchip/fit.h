/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ROCKCHIP_FIT_H_
#define __ROCKCHIP_FIT_H_

#define FIT_I(fmt, args...)	printf("FIT: "fmt, ##args)

void *fit_image_load_bootables(ulong *size);
ulong fit_image_get_bootable_size(void *fit);
int fit_sysmem_free_each(void *fit);
int fit_image_fixup_and_sysmem_rsv(void *fit);
int rockchip_read_fit_dtb(void *fdt_addr, char **hash, int *hash_size);

#endif
