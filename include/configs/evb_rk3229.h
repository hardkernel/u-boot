/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#include <configs/rk322x_common.h>


/* Store env in emmc */
#undef CONFIG_ENV_SIZE
#define CONFIG_ENV_SIZE                 (32 << 10)
#define CONFIG_SYS_MMC_ENV_DEV          0
#define CONFIG_SYS_MMC_ENV_PART         0
#define CONFIG_SYS_REDUNDAND_ENVIRONMENT

#ifndef CONFIG_SPL_BUILD
/* Enable gpt partition table */
#define CONFIG_PREBOOT

#define CONFIG_SYS_BOOT_RAMDISK_HIGH

/* Enable atags */
#define CONFIG_SYS_BOOTPARAMS_LEN	(64*1024)
#define CONFIG_INITRD_TAG
#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG

#endif

#endif
