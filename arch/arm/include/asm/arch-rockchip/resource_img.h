/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __RESC_IMG_H_
#define __RESC_IMG_H_

/*
 * read file from resource partition
 * @buf: destination buf to store file data;
 * @name: file name
 * @offset: blocks offset in the file, 1 block = 512 bytes
 * @len: the size(by bytes) of file to read.
 */
int rockchip_read_resource_file(void *buf, const char *name,
				int offset, int len);
int rockchip_get_resource_file(void *buf, const char *name);

int rockchip_read_dtb_file(void *fdt_addr);
#endif
