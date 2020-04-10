/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2020 Rockchip Electronics Co., Ltd
 */

#ifndef _MISC_DECOMPRESS_H_
#define _MISC_DECOMPRESS_H_

enum decom_mod {
	LZ4_MOD,
	GZIP_MOD,
	ZLIB_MOD,
};

struct decom_param {
	unsigned long addr_src;
	unsigned long addr_dst;
	unsigned long size;
	enum decom_mod mode;
};

struct udevice *misc_decompress_get_device(u32 capability);
int misc_decompress_start(struct udevice *dev, unsigned long src,
			  unsigned long dst, unsigned long size);
int misc_decompress_stop(struct udevice *dev);
int misc_decompress_is_complete(struct udevice *dev);

#endif
