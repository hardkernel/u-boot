// SPDX-License-Identifier:     GPL-2.0+
/*
 * Copyright (C) 2020 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <dm.h>
#include <dm/uclass.h>
#include <misc.h>

struct udevice *misc_otp_get_device(u32 capability)
{
	const struct misc_ops *ops;
	struct udevice *dev;
	struct uclass *uc;
	int ret;
	u32 cap;

	ret = uclass_get(UCLASS_MISC, &uc);
	if (ret)
		return NULL;

	for (uclass_first_device(UCLASS_MISC, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		ops = device_get_ops(dev);
		if (!ops || !ops->ioctl)
			continue;

		cap = ops->ioctl(dev, IOCTL_REQ_CAPABILITY, NULL);
		if ((cap & capability) == capability)
			return dev;
	}

	return NULL;
}

int misc_otp_read(struct udevice *dev, int offset, void *buf, int size)
{
	return misc_read(dev, offset, buf, size);
}

int misc_otp_write(struct udevice *dev, int offset, const void *buf, int size)
{
	return misc_write(dev, offset, (void *)buf, size);
}
