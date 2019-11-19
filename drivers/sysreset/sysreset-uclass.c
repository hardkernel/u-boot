/*
 * Copyright (C) 2015 Google, Inc
 * Written by Simon Glass <sjg@chromium.org>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <sysreset.h>
#include <dm.h>
#include <errno.h>
#include <regmap.h>
#include <dm/device-internal.h>
#include <dm/lists.h>
#include <dm/root.h>
#include <linux/err.h>

int sysreset_request(struct udevice *dev, enum sysreset_t type)
{
	struct sysreset_ops *ops = sysreset_get_ops(dev);

	if (!ops->request)
		return -ENOSYS;

	return ops->request(dev, type);
}

int sysreset_walk(enum sysreset_t type)
{
	struct udevice *dev;
	int ret = -ENOSYS;

	/*
	 * Use psci sysreset as primary for rockchip platforms,
	 * "rockchip_reset" is applied if PSCI is disabled.
	 */
#if !defined(CONFIG_TPL_BUILD) && \
     defined(CONFIG_ARCH_ROCKCHIP) && defined(CONFIG_SYSRESET_PSCI)
	ret = uclass_get_device_by_driver(UCLASS_SYSRESET,
					  DM_GET_DRIVER(psci_sysreset), &dev);
	if (!ret)
		sysreset_request(dev, type);
	else
		printf("WARN: PSCI sysreset is disabled\n");
#endif

	while (ret != -EINPROGRESS && type < SYSRESET_COUNT) {
		for (uclass_first_device(UCLASS_SYSRESET, &dev);
		     dev;
		     uclass_next_device(&dev)) {
			ret = sysreset_request(dev, type);
			if (ret == -EINPROGRESS)
				break;
		}
		type++;
	}

	return ret;
}

void sysreset_walk_halt(enum sysreset_t type)
{
	int ret;

	ret = sysreset_walk(type);

	/* Wait for the reset to take effect */
	if (ret == -EINPROGRESS)
		mdelay(100);

	/* Still no reset? Give up */
	debug("System reset not supported on this platform\n");
	hang();
}

/**
 * reset_cpu() - calls sysreset_walk(SYSRESET_WARM)
 */
void reset_cpu(ulong addr)
{
	sysreset_walk_halt(SYSRESET_WARM);
}

void reboot(const char *mode)
{
#ifndef CONFIG_SPL_BUILD
	struct sysreset_ops *ops;
	struct udevice *dev;
	int ret;

	if (!mode)
		goto finish;

	ret = uclass_get_device_by_driver(UCLASS_SYSRESET,
					  DM_GET_DRIVER(sysreset_syscon_reboot),
					  &dev);
	if (!ret) {
		ops = sysreset_get_ops(dev);
		if (ops && ops->request_by_mode)
			ops->request_by_mode(dev, mode);
	}
finish:
#endif
	flushc();
	sysreset_walk_halt(SYSRESET_COLD);
}

int do_reset(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if (argc > 1)
		reboot(argv[1]);
	else
		reboot(NULL);

	return 0;
}

UCLASS_DRIVER(sysreset) = {
	.id		= UCLASS_SYSRESET,
	.name		= "sysreset",
};
