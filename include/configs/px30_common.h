/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_PX30_COMMON_H
#define __CONFIG_PX30_COMMON_H

#include "rockchip-common.h"

#define CONFIG_SYS_MALLOC_LEN		(32 << 20)
#define CONFIG_SYS_CBSIZE		1024
#define CONFIG_SKIP_LOWLEVEL_INIT

#define CONFIG_SPL_FRAMEWORK

#define CONFIG_SYS_NS16550_MEM32

#define CONFIG_SYS_TEXT_BASE		0x00200000
#define CONFIG_SYS_INIT_SP_ADDR		0x00300000
#define CONFIG_SYS_LOAD_ADDR		0x00800800
#define CONFIG_SPL_STACK		0x00400000
#define CONFIG_SPL_TEXT_BASE		0x00000000
#define CONFIG_SPL_MAX_SIZE		0x10000
#define CONFIG_SPL_BSS_START_ADDR	0x2000000
#define CONFIG_SPL_BSS_MAX_SIZE		0x2000
#define CONFIG_SYS_BOOTM_LEN		(64 << 20)	/* 64M */

#define COUNTER_FREQUENCY		24000000

#define GICD_BASE			0xFF811000
#define GICC_BASE			0xFF812000

#define CONFIG_SYS_BOOTM_LEN	(64 << 20)	/* 64M */

/* MMC/SD IP block */
#define CONFIG_BOUNCE_BUFFER

#define CONFIG_SYS_SDRAM_BASE		0
#define CONFIG_NR_DRAM_BANKS		1
#define SDRAM_MAX_SIZE			0xff000000
#define SDRAM_BANK_SIZE			(2UL << 30)


#ifndef CONFIG_SPL_BUILD

#define ENV_MEM_LAYOUT_SETTINGS \
	"scriptaddr=0x00500000\0" \
	"pxefile_addr_r=0x00600000\0" \
	"fdt_addr_r=0x01f00000\0" \
	"kernel_addr_r=0x02080000\0" \
	"ramdisk_addr_r=0x04000000\0"

#include <config_distro_bootcmd.h>
#define CONFIG_EXTRA_ENV_SETTINGS \
	ENV_MEM_LAYOUT_SETTINGS \
	"partitions=" PARTS_DEFAULT \
	BOOTENV

#endif

#endif
