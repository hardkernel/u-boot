// SPDX-License-Identifier:     GPL-2.0+
/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <console.h>
#include <io-domain.h>

void io_domain_init(void)
{
	int ret;
	struct udevice *dev;

	ret = uclass_get_device(UCLASS_IO_DOMAIN, 0, &dev);
	if (ret)
		printf("Can't find UCLASS_IO_DOMAIN driver %d\n", ret);
}

UCLASS_DRIVER(io_domain) = {
	.id		= UCLASS_IO_DOMAIN,
	.name		= "io_domain",
};
