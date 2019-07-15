/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _MEMBLK_H
#define _MEMBLK_H

#define ALIAS_COUNT_MAX		2

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
	MEMBLK_ID_UNCOMP_KERNEL,
	MEMBLK_ID_ANDROID,
	MEMBLK_ID_AVB_ANDROID,

	/* Other */
	MEMBLK_ID_BY_NAME,
	MEMBLK_ID_KMEM_RESERVED,
	MEMBLK_ID_DEMO,
	MEMBLK_ID_MAX,
};

struct memblk_attr {
	const char *name;
	const char *alias[ALIAS_COUNT_MAX];
	u32 flags;
};

struct memblock {
	phys_addr_t base;
	phys_size_t size;
	phys_addr_t orig_base;
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
/* Memory can be overlap by fdt reserved memory, deprecated */
#define M_ATTR_OVERLAP		(1 << 2)
/* Just peek, always return success, deprecated */
#define M_ATTR_PEEK		(1 << 3)
/* The region start address should be aligned to cacheline size */
#define M_ATTR_CACHELINE_ALIGN	(1 << 4)
/* Kernel 'reserved-memory' */
#define M_ATTR_KMEM_RESERVED	(1 << 5)
/* The region can be overlap by kernel 'reserved-memory' */
#define M_ATTR_KMEM_CAN_OVERLAP	(1 << 6)
/* Ignore invisable region reserved by bidram */
#define M_ATTR_IGNORE_INVISIBLE	(1 << 7)


#endif /* _MEMBLK_H */
