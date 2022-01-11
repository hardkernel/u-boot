/*
 * (C) Copyright 2022 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_RV1106_COMMON_H
#define __CONFIG_RV1106_COMMON_H

#include "rockchip-common.h"

#define COUNTER_FREQUENCY		24000000
#define CONFIG_SYS_MALLOC_LEN		(32 << 20)
#define CONFIG_SYS_CBSIZE		1024
#define CONFIG_SKIP_LOWLEVEL_INIT
#define CONFIG_SYS_NS16550_MEM32

#define CONFIG_SYS_TEXT_BASE		0x00200000
#define CONFIG_SYS_INIT_SP_ADDR		0x00400000
#define CONFIG_SYS_LOAD_ADDR		0x00e00800
#define CONFIG_SYS_BOOTM_LEN		(64 << 20)
#define GICD_BASE			0xff1f1000
#define GICC_BASE			0xff1f2000
#define CONFIG_SYS_SDRAM_BASE		0
#define SDRAM_MAX_SIZE			0xfd000000
#define CONFIG_SYS_NONCACHED_MEMORY    (1 << 20)       /* 1 MiB */

/* SPL */
#define CONFIG_SPL_FRAMEWORK
#define CONFIG_SPL_TEXT_BASE		0x00000000
#define CONFIG_SPL_MAX_SIZE		0x30000
#define CONFIG_SPL_BSS_START_ADDR	0x00600000
#define CONFIG_SPL_BSS_MAX_SIZE		0x20000
#define CONFIG_SPL_STACK		0x00600000

/* MMC/SD IP block */
#define CONFIG_BOUNCE_BUFFER

#ifndef CONFIG_SPL_BUILD
/* usb mass storage */
#define CONFIG_USB_FUNCTION_MASS_STORAGE
#define CONFIG_ROCKUSB_G_DNL_PID	0x110c

#define ENV_MEM_LAYOUT_SETTINGS		\
	"scriptaddr=0x00b00000\0"	\
	"pxefile_addr_r=0x00c00000\0"	\
	"fdt_addr_r=0x00a00000\0"	\
	"kernel_addr_c=0x00808000\0"	\
	"kernel_addr_r=0x00008000\0"	\
	"ramdisk_addr_r=0x00d00000\0"

#define CONFIG_EXTRA_ENV_SETTINGS	\
	ENV_MEM_LAYOUT_SETTINGS		\
	ROCKCHIP_DEVICE_SETTINGS	\
	RKIMG_DET_BOOTDEV

#undef RKIMG_BOOTCOMMAND
#ifdef CONFIG_FIT_SIGNATURE
#define RKIMG_BOOTCOMMAND		\
	"boot_fit;"
#else
#define RKIMG_BOOTCOMMAND		\
	"boot_fit;"			\
	"boot_android ${devtype} ${devnum};"
#endif
#endif
#define CONFIG_PREBOOT

#endif
