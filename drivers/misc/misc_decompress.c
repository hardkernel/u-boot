// SPDX-License-Identifier:     GPL-2.0+
/*
 * Copyright (C) 2020 Rockchip Electronics Co., Ltd
 */
#include <common.h>
#include <dm.h>
#include <misc.h>
#include <dm/uclass.h>
#include <dm/uclass-internal.h>

#define HEAD_CRC		2
#define EXTRA_FIELD		4
#define ORIG_NAME		8
#define COMMENT			0x10
#define RESERVED		0xe0
#define DEFLATED		8

static u32 misc_decomp_async, misc_decomp_sync;

static void decomp_set_flags(u32 *flags, u8 comp)
{
	if (comp == IH_COMP_GZIP)
		*flags |= DECOM_GZIP;
	else if (comp == IH_COMP_LZ4)
		*flags |= DECOM_LZ4;
}

void misc_decompress_async(u8 comp)
{
	decomp_set_flags(&misc_decomp_async, comp);
}

void misc_decompress_sync(u8 comp)
{
	decomp_set_flags(&misc_decomp_sync, comp);
}

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

static u32 misc_get_data_size(unsigned long src, unsigned long len, u32 cap)
{
	if (cap == DECOM_GZIP)
		return *(u32 *)(src + len - 4);

	return 0;
}

struct udevice *misc_decompress_get_device(u32 capability)
{
	return misc_get_device_by_capability(capability);
}

int misc_decompress_start(struct udevice *dev, unsigned long dst,
			  unsigned long src, unsigned long src_len)
{
	struct decom_param param;

	param.addr_dst = dst;
	param.addr_src = src;
	if (misc_gzip_parse_header((unsigned char *)src, 0xffff) > 0) {
		param.mode = DECOM_GZIP;
	} else {
		printf("Unsupported decompression format.\n");
		return -EPERM;
	}

	param.size_src = src_len;
	param.size_dst = misc_get_data_size(src, src_len, param.mode);

	if (!param.size_src || !param.size_dst)
		return -EINVAL;

	return misc_ioctl(dev, IOCTL_REQ_START, &param);
}

int misc_decompress_stop(struct udevice *dev)
{
	return misc_ioctl(dev, IOCTL_REQ_STOP, NULL);
}

bool misc_decompress_is_complete(struct udevice *dev)
{
	if (misc_ioctl(dev, IOCTL_REQ_POLL, NULL))
		return false;
	else
		return true;
}

int misc_decompress_data_size(struct udevice *dev, u64 *size, u32 cap)
{
	struct decom_param param;
	int ret;

	param.mode = cap;
	param.size_dst = 0; /* clear */

	ret = misc_ioctl(dev, IOCTL_REQ_DATA_SIZE, &param);
	if (!ret)
		*size = param.size_dst;

	return ret;
}

static int misc_decompress_finish(struct udevice *dev, u32 cap)
{
	int timeout = 10000;

	while (!misc_decompress_is_complete(dev)) {
		if (timeout < 0)
			return -EIO;
		timeout--;
		udelay(10);
	}

	return misc_decompress_stop(dev);
}

int misc_decompress_cleanup(void)
{
	const struct misc_ops *ops;
	struct udevice *dev;
	struct uclass *uc;
	int ret;
	u32 cap;

	ret = uclass_get(UCLASS_MISC, &uc);
	if (ret)
		return 0;

	/* use "find_" */
	for (uclass_find_first_device(UCLASS_MISC, &dev);
	     dev;
	     uclass_find_next_device(&dev)) {
		ops = device_get_ops(dev);
		if (!ops || !ops->ioctl)
			continue;
		else if (ops->ioctl(dev, IOCTL_REQ_CAPABILITY, &cap))
			continue;
		else if (misc_decomp_async & cap)
			continue;

		if (misc_decomp_sync & cap) {
			ret = misc_decompress_finish(dev, cap);
			if (ret) {
				printf("Failed to stop decompress: %s, ret=%d\n",
				       dev->name, ret);
				return ret;
			}
		}
	}

	return 0;
}

int misc_decompress_process(unsigned long dst, unsigned long src,
			    unsigned long src_len, u32 cap, bool sync,
			    u64 *size)
{
	struct udevice *dev;
	int ret;

	dev = misc_decompress_get_device(cap);
	if (!dev)
		return -ENODEV;

	/* Wait last finish */
	ret = misc_decompress_finish(dev, cap);
	if (ret)
		return ret;

	ret = misc_decompress_start(dev, dst, src, src_len);
	if (ret)
		return ret;

	/*
	 * Wait this round finish ?
	 *
	 * If sync, return original data length after decompress done.
	 * otherwise return from compressed file information.
	 */
	if (sync) {
		ret = misc_decompress_finish(dev, cap);
		if (ret)
			return ret;
		if (size)
			ret = misc_decompress_data_size(dev, size, cap);
	} else {
		if (size)
			*size = misc_get_data_size(src, src_len, cap);
	}

	return ret;
}
