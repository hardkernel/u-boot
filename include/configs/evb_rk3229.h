/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __RK322X_CONFIG_H
#define __RK322X_CONFIG_H

#include <configs/rk322x_common.h>

#define ROCKCHIP_DEVICE_SETTINGS \
		"stdout=serial,vidconsole\0" \
		"stderr=serial,vidconsole\0"

/* Store env in emmc */
#define CONFIG_SYS_MMC_ENV_DEV          0
#define CONFIG_SYS_MMC_ENV_PART         0
#define CONFIG_SYS_REDUNDAND_ENVIRONMENT
#define CONFIG_SUPPORT_EMMC_RPMB

#ifndef CONFIG_SPL_BUILD
/* Enable gpt partition table */
#undef CONFIG_PREBOOT
#define CONFIG_PREBOOT \
	"mmc dev 0; " \
	"gpt guid mmc 0; " \
	"if test $? = 1; then " \
		"fastboot usb 0; " \
	"fi; "

#define CONFIG_SYS_BOOT_RAMDISK_HIGH

/* Enable atags */
#define CONFIG_SYS_BOOTPARAMS_LEN	(64*1024)
#define CONFIG_INITRD_TAG
#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG

#endif

#endif
