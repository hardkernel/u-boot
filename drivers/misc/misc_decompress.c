// SPDX-License-Identifier:     GPL-2.0+
/*
 * Copyright (C) 2020 Rockchip Electronics Co., Ltd
 */
#include <common.h>
#include <dm.h>
#include <dm/uclass.h>
#include <misc.h>

#define HEAD_CRC		2
#define EXTRA_FIELD		4
#define ORIG_NAME		8
#define COMMENT			0x10
#define RESERVED		0xe0
#define DEFLATED		8

static int misc_gzip_parse_header(const unsigned char *src, unsigned long len)
{
	int i, flags;

	/* skip header */
	i = 10;
	flags = src[3];
	if (src[2] != DEFLATED || (flags & RESERVED) != 0) {
		debug("Error: Bad gzipped data\n");
		return (-1);
	}
	if ((flags & EXTRA_FIELD) != 0)
		i = 12 + src[10] + (src[11] << 8);
	if ((flags & ORIG_NAME) != 0)
		while (src[i++] != 0)
			;
	if ((flags & COMMENT) != 0)
		while (src[i++] != 0)
			;
	if ((flags & HEAD_CRC) != 0)
		i += 2;
	if (i >= len) {
		puts("Error: gunzip out of data in header\n");
		return (-1);
	}
	return i;
}

struct udevice *misc_decompress_get_device(u32 capability)
{
	return misc_get_device_by_capability(capability);
}

int misc_decompress_start(struct udevice *dev, unsigned long src,
			  unsigned long dst, unsigned long size)
{
	struct decom_param param;

	param.addr_dst = dst;
	param.addr_src = src;
	param.size = size;
	if (misc_gzip_parse_header((unsigned char *)src, 0xffff) > 0) {
		param.mode = DECOM_GZIP;
	} else {
		printf("Unsupported decompression format.\n");
		return -EPERM;
	}

	return misc_ioctl(dev, IOCTL_REQ_START, &param);
}

int misc_decompress_stop(struct udevice *dev)
{
	return misc_ioctl(dev, IOCTL_REQ_STOP, NULL);
}

int misc_decompress_is_complete(struct udevice *dev)
{
	return misc_ioctl(dev, IOCTL_REQ_POLL, NULL);
}
