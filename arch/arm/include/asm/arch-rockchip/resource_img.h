/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __RESC_IMG_H_
#define __RESC_IMG_H_

/*
 * rockchip_read_resource_file - read file from resource partition
 *
 * @buf: destination buf to store file data
 * @name: file name
 * @offset: blocks offset in the file, 1 block = 512 bytes
 * @len: the size(by bytes) of file to read.
 *
 * return negative num on failed, otherwise the file size
 */
int rockchip_read_resource_file(void *buf, const char *name, int offset, int len);

/*
 * rockchip_read_resource_dtb() - read dtb file
 *
 * @fdt_addr: destination buf to store dtb file
 * @hash: hash value buffer
 * @hash_size: hash value length
 */
int rockchip_read_resource_dtb(void *fdt_addr, char **hash, int *hash_size);
#endif
