// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <memblk.h>

const static struct memblk_attr plat_mem_attr[MEMBLK_ID_MAX] = {
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
		.alias[0] = "ramoops",
	},
	[MEMBLK_ID_UBOOT]    =	{
		.name = "U-Boot",
		.flags = M_ATTR_KMEM_CAN_OVERLAP,
	},
	[MEMBLK_ID_FASTBOOT] =	{
		.name = "FASTBOOT",
		.flags = M_ATTR_KMEM_CAN_OVERLAP,
	},
	[MEMBLK_ID_STACK]    =	{
		.name = "STACK",
		.flags = M_ATTR_HOFC | M_ATTR_KMEM_CAN_OVERLAP,
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
/*
 * Here is a workarund:
 *	ATF reserves 0~1MB when kernel is aarch32 mode(follow the ATF for
 *	aarch64 kernel, but it actually occupies 0~192KB, so we allow kernel
 *	to alloc the region within 0~1MB address.
 */
#if defined(CONFIG_ROCKCHIP_RK3308) && defined(CONFIG_ARM64_BOOT_AARCH32)
		.flags = M_ATTR_OFC | M_ATTR_IGNORE_INVISIBLE,
#else
		.flags = M_ATTR_OFC,
#endif
	},
	[MEMBLK_ID_UNCOMP_KERNEL] = {
		.name = "UNCOMPRESS-KERNEL",
		.flags = M_ATTR_IGNORE_INVISIBLE,
	},
	[MEMBLK_ID_ANDROID]  =	{
		.name = "ANDROID",
		.flags = M_ATTR_OFC | M_ATTR_KMEM_CAN_OVERLAP,
	},
	[MEMBLK_ID_AVB_ANDROID]  =	{
		.name = "AVB_ANDROID",
		.flags = M_ATTR_OFC | M_ATTR_CACHELINE_ALIGN |
			 M_ATTR_KMEM_CAN_OVERLAP,
	},
};

const struct memblk_attr *mem_attr = plat_mem_attr;
