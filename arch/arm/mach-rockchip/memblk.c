// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <memblk.h>

const static struct memblk_attr plat_mem_attr[MEMBLK_ID_MAX] = {
	[MEMBLK_ID_DEMO]     =	{
		.name = "DEMO",
		.flags = M_ATTR_NONE,
	},
	[MEMBLK_ID_ATF]      =	{
		.name = "ATF",
		.flags = M_ATTR_NONE,
	},
	[MEMBLK_ID_OPTEE]    =	{
		.name = "OP-TEE",
		.flags = M_ATTR_NONE,
	},
	[MEMBLK_ID_SHM]      =	{
		.name = "SHM",
		.flags = M_ATTR_NONE,
	},
	[MEMBLK_ID_UBOOT]    =	{
		.name = "U-Boot",
		.flags = M_ATTR_OVERLAP,
	},
	[MEMBLK_ID_FASTBOOT] =	{
		.name = "FASTBOOT",
		.flags = M_ATTR_OVERLAP,
	},
	[MEMBLK_ID_STACK]    =	{
		.name = "STACK",
		.flags = M_ATTR_HOFC | M_ATTR_OVERLAP,
	},
	[MEMBLK_ID_FDT]      =	{
		.name = "FDT",
		.flags = M_ATTR_OFC,
	},
	[MEMBLK_ID_FDT_DTBO] =	{
		.name = "FDT_DTBO",
		.flags = M_ATTR_OFC,
	},
	[MEMBLK_ID_FDT_AOSP] =	{
		.name = "FDT_AOSP",
		.flags = M_ATTR_OFC,
	},
	[MEMBLK_ID_RAMDISK]  =	{
		.name = "RAMDISK",
		.alias[0] = "BOOT",
		.alias[1] = "RECOVERY",
		.flags = M_ATTR_OFC,
	},
	[MEMBLK_ID_KERNEL]   =	{
		.name = "KERNEL",
		.flags = M_ATTR_OFC,
	},
	[MEMBLK_ID_ANDROID]  =	{
		.name = "ANDROID",
		.flags = M_ATTR_OFC,
	},
};

const struct memblk_attr *mem_attr = plat_mem_attr;
