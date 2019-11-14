/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ODROIDGO2_H
#define __ODROIDGO2_H

#include <configs/px30_common.h>

#define CONFIG_SYS_MMC_ENV_DEV	1 /* SDMMC default */

#undef CONFIG_ENV_SIZE
#undef CONFIG_ENV_OFFSET
#define CONFIG_ENV_SIZE		(32 * SZ_1K)
#define CONFIG_ENV_OFFSET	(1024 * SZ_1K)

#define ROCKCHIP_DEVICE_SETTINGS \
		"stdout=serial,vidconsole\0" \
		"stderr=serial,vidconsole\0"

#undef CONFIG_CONSOLE_SCROLL_LINES
#define CONFIG_CONSOLE_SCROLL_LINES		10
#define CONFIG_SUPPORT_EMMC_RPMB

#ifndef CONFIG_SPL_BUILD
#undef CONFIG_BOOTCOMMAND
#define CONFIG_BOOTCOMMAND RKIMG_BOOTCOMMAND
#endif

#undef CONFIG_EXTRA_ENV_SETTINGS
#define CONFIG_EXTRA_ENV_SETTINGS	\
	"fdt_addr_r=0x01f00000\0" \
	"dtb_name=rk3326-odroidgo2-linux.dtb\0" \
	"loadaddr=0x100000\0" \
	"spi_upgrade_from_sd="\
		"rksfc scan; "\
		"rksfc dev 1; "\
		"fatload mmc 1 ${loadaddr} mbr.img; rksfc write ${loadaddr} 0x0 0x1; "\
		"fatload mmc 1 ${loadaddr} gpt.img; rksfc write ${loadaddr} 0x1 0x21; "\
		"fatload mmc 1 ${loadaddr} rk3326_miniloader_spiboot.img; rksfc write ${loadaddr} 0x80 0x780; "\
		"fatload mmc 1 ${loadaddr} uboot.img; rksfc write ${loadaddr} 0x800 0x800; "\
		"fatload mmc 1 ${loadaddr} trust.img; rksfc write ${loadaddr} 0x1000 0x1000\0"\
	"setbootargs=setenv bootargs earlyprintk swiotlb=1 "		\
		"console=ttyFIQ0,115200n8 "				\
		"rw root=/dev/mmcblk0p2 rootfstype=ext4 rootwait\0"	\
	"bootcmd=cfgload; run setbootargs;"	\
		"load mmc 1:1 0x02000000 Image; "		\
		"load mmc 1:1 0x01f00000 rk3326-odroidgo2-linux.dtb; "	\
		"booti 0x02000000 - 0x01f00000\0"

#undef CONFIG_BOOTDELAY
#define CONFIG_BOOTDELAY	3

#endif
