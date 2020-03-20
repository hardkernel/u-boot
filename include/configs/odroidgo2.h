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
#ifdef CONFIG_SD_BOOT
#define CONFIG_ENV_SIZE		(32 * SZ_1K)
#define CONFIG_ENV_OFFSET	(1024 * SZ_1K)
#define ENV_DEV_TYPE \
		"devtype=mmc\0"
#define ENV_DEV_NUM \
		"devnum=1\0"
#else
/* SPI Flash boot */
#define CONFIG_ENV_SIZE		(32 * SZ_1K)
#define CONFIG_ENV_OFFSET	(32 * SZ_1K)
#define ENV_DEV_TYPE \
		"devtype=spinor\0"
#define ENV_DEV_NUM \
		"devnum=1\0"
#endif

/* default env of spi flash layout */
#define SPI_FLASH_LAYOUT \
		"st_boot1=0x0\0" \
		"sz_boot1=0x800\0" \
		"st_uboot=0x800\0" \
		"sz_uboot=0x800\0" \
		"st_trust=0x1000\0" \
		"sz_trust=0x1000\0" \
		"st_dtb=0x2000\0" \
		"sz_dtb=0xC8\0" \
		"sz_logo=0x190\0" \
		"st_logo_hardkernel=0x20C8\0" \
		"st_logo_lowbatt=0x2258\0" \
		"st_logo_recovery=0x23E8\0" \
		"st_logo_err=0x2578\0" \
		"st_logo_nosdcard=0x2708\0" \
		"st_battery_0=0x2898\0" \
		"st_battery_1=0x2A28\0" \
		"st_battery_2=0x2BB8\0" \
		"st_battery_3=0x2D48 \0" \
		"st_battery_fail=0x2ED8\0" \
		"sz_total=0x3068\0"

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
	ENV_DEV_TYPE \
	ENV_DEV_NUM \
	SPI_FLASH_LAYOUT \
	"spi_upgrade_from_sd="\
		"rksfc scan; "\
		"rksfc dev 1; "\
		"fatload mmc 1 ${loadaddr} spi_recovery.img; rksfc write ${loadaddr} 0x0 $sz_total\0"\
	"setbootargs=setenv bootargs earlyprintk swiotlb=1 "		\
		"console=ttyFIQ0,115200n8 "				\
		"rw root=/dev/mmcblk0p2 rootwait rw fsck.repair=yes "	\
		"net.iframes=0 fbcon=rotate:3\0"	\
	"bootcmd=mmc dev 1; cfgload; run setbootargs;"	\
		"load mmc 1:1 0x02000000 Image; "		\
		"if test ${hwrev} = 'v11'; then " \
			"load mmc 1:1 0x01f00000 rk3326-odroidgo2-linux-v11.dtb; "	\
		"else " \
			"load mmc 1:1 0x01f00000 rk3326-odroidgo2-linux.dtb; "	\
		"fi; "\
		"booti 0x02000000 - 0x01f00000\0"

#undef CONFIG_BOOTDELAY
#define CONFIG_BOOTDELAY	1

#endif
