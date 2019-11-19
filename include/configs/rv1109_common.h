/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_RV1109_COMMON_H
#define __CONFIG_RV1109_COMMON_H

#include "rockchip-common.h"

#define COUNTER_FREQUENCY		24000000
#define CONFIG_SYS_MALLOC_LEN		(32 << 20)
#define CONFIG_SYS_CBSIZE		1024
#define CONFIG_SKIP_LOWLEVEL_INIT
#define CONFIG_SYS_NS16550_MEM32

#define CONFIG_SYS_TEXT_BASE		0x00600000
#define CONFIG_SYS_INIT_SP_ADDR		0x00800000
#define CONFIG_SYS_LOAD_ADDR		0x00C00800
#define CONFIG_SYS_BOOTM_LEN		(64 << 20)

#define GICD_BASE			0xfeff1000
#define GICC_BASE			0xfeff2000

/* MMC/SD IP block */
#define CONFIG_BOUNCE_BUFFER

#define CONFIG_SYS_SDRAM_BASE		0
#define SDRAM_MAX_SIZE			0xfd000000

#ifndef CONFIG_SPL_BUILD

/* usb mass storage */
#define CONFIG_USB_FUNCTION_MASS_STORAGE
#define CONFIG_ROCKUSB_G_DNL_PID        0x330d

#define ENV_MEM_LAYOUT_SETTINGS		\
	"scriptaddr=0x00000000\0"	\
	"pxefile_addr_r=0x00100000\0"	\
	"fdt_addr_r=0x08300000\0"	\
	"kernel_addr_r=0x02008000\0"	\
	"ramdisk_addr_r=0x0a200000\0"

#include <config_distro_bootcmd.h>
#define CONFIG_EXTRA_ENV_SETTINGS	\
	ENV_MEM_LAYOUT_SETTINGS		\
	"partitions=" PARTS_DEFAULT	\
	ROCKCHIP_DEVICE_SETTINGS	\
	RKIMG_DET_BOOTDEV		\
	BOOTENV_SHARED_RKNAND		\
	BOOTENV
#endif

#define CONFIG_PREBOOT

#endif
