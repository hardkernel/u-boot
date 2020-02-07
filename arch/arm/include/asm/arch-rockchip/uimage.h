/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ROCKCHIP_UIMAGE_H_
#define __ROCKCHIP_UIMAGE_H_

#define UIMG_I(fmt, args...)	printf("uImage: "fmt, ##args)

void *uimage_load_bootables(void);
int uimage_sysmem_free_each(image_header_t *img);
int uimage_sysmem_reserve_each(image_header_t *hdr);
int rockchip_read_uimage_dtb(void *fdt_addr, char **hash, int *hash_size);

#endif

