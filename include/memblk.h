/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _MEMBLK_H
#define _MEMBLK_H

enum memblk_id {
	MEMBLK_ID_UNK,

	/* Preloader */
	MEMBLK_ID_ATF,
	MEMBLK_ID_OPTEE,
	MEMBLK_ID_SHM,

	/* U-Boot self */
	MEMBLK_ID_UBOOT,
	MEMBLK_ID_STACK,
	MEMBLK_ID_FASTBOOT,

	/* Image */
	MEMBLK_ID_RAMDISK,
	MEMBLK_ID_FDT,
	MEMBLK_ID_FDT_DTBO,
	MEMBLK_ID_FDT_AOSP,
	MEMBLK_ID_KERNEL,
	MEMBLK_ID_ANDROID,

	/* Other */
	MEMBLK_ID_BY_NAME,
	MEMBLK_ID_FDT_RESV,
	MEMBLK_ID_DEMO,
	MEMBLK_ID_MAX,
};

struct memblk_attr {
	const char *name;
	const char *alias[2];
	u32 flags;
};

struct memblock {
	phys_addr_t base;
	phys_size_t size;
	struct memblk_attr attr;
	struct list_head node;
};

extern const struct memblk_attr *mem_attr;

#define SIZE_MB(len)		((len) >> 20)
#define SIZE_KB(len)		(((len) % (1 << 20)) >> 10)

#define M_ATTR_NONE		0
/* Over-Flow-Check for region tail */
#define M_ATTR_OFC		(1 << 0)
/* Over-Flow-Check for region Head, only for U-Boot stack */
#define M_ATTR_HOFC		(1 << 1)
/* Memory can be overlap by fdt reserved memory */
#define M_ATTR_OVERLAP		(1 << 2)

#endif /* _MEMBLK_H */
