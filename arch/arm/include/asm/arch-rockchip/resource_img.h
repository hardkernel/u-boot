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
 * rockchip_get_resource_file_offset() - read file offset of partition
 *
 * @resc_img_hdr: resource file hdr
 * @name: file name
 *
 * @return negative on error, otherwise file offset
 */
int rockchip_get_resource_file_offset(void *resc_hdr, const char *name);

/*
 * rockchip_get_resource_file_size() - read file size
 *
 * @resc_img_hdr: resource file hdr
 * @name: file name
 *
 * @return negative on error, otherwise file size
 */
int rockchip_get_resource_file_size(void *resc_hdr, const char *name);

/*
 * rockchip_get_resource_file_size() - read file size
 *
 * @fdt_addr: destination buf to store dtb file
 *
 * @return 0 on success, othwise on error
 */
int rockchip_read_dtb_file(void *fdt_addr);
#endif
