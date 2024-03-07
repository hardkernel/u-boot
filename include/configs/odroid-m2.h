/*
 * SPDX-License-Identifier:     GPL-2.0+
 *
 * Copyright (c) 2024 Hardkernel Co., Ltd
 */

#ifndef __CONFIGS_ODROID_M2_H
#define __CONFIGS_ODROID_M2_H

#include <configs/rk3588_common.h>

#define CONFIG_MISC_INIT_R

#undef RKIMG_BOOTCOMMAND

#ifndef CONFIG_SPL_BUILD

#undef ROCKCHIP_DEVICE_SETTINGS
#define ROCKCHIP_DEVICE_SETTINGS \
		"stdout=serial,vidconsole\0" \
		"stderr=serial,vidconsole\0"

#define CONFIG_SYS_MMC_ENV_DEV		0

#define CONFIG_SET_DFU_ALT_INFO
#define DFU_ALT_BOOT_EMMC \
	"gpt raw 0x0 0x20000;" \
	"loader raw 0x20000 0xE0000;"\
	"uboot part uboot;" \
	"boot part boot;" \
	"rootfs partubi rootfs;" \
	"userdata partubi userdata\0"

#define DFU_ALT_BOOT_MTD \
	"gpt raw 0x0 0x20000;" \
	"loader raw 0x20000 0xE0000;"\
	"vnvm part vnvm;" \
	"uboot part uboot;" \
	"boot part boot;" \
	"rootfs partubi rootfs;" \
	"userdata partubi userdata\0"

#undef CONFIG_EXTRA_ENV_SETTINGS
#define CONFIG_EXTRA_ENV_SETTINGS \
	ENV_MEM_LAYOUT_SETTINGS \
	"partitions=" PARTS_RKIMG \
	ROCKCHIP_DEVICE_SETTINGS \
	RKIMG_DET_BOOTDEV \
	BOOTENV

#define ENV_MEM_LAYOUT_SETTINGS1 \
	"cramfsaddr=0x0c000000\0" \
	"splashimage=0x05000000\0" \
	"loadaddr=0x02000000\0"

#define CONFIG_BMP_16BPP
#define CONFIG_BMP_24BPP
#define CONFIG_BMP_32BPP
#define CONFIG_VIDEO_BMP_GZIP
#define CONFIG_SYS_VIDEO_LOGO_MAX_SIZE	((1920 * 1080 * 4) + 54)

#endif

#define CONFIG_BOARDNAME	"odroidm2"
#define BOARD_VARIANT		"m2"

#endif
