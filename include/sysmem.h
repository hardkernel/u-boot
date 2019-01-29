/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _SYSMEM_H
#define _SYSMEM_H

#include <asm/types.h>

#define	MAX_SYSMEM_REGIONS		64

#undef	MAX_LMB_REGIONS
#define	MAX_LMB_REGIONS			MAX_SYSMEM_REGIONS

/*
 * CONFIG_SYS_FDT_PAD default value is sync with bootm framework in:
 * common/image-fdt.c
 */
#ifndef CONFIG_SYS_FDT_PAD
#define CONFIG_SYS_FDT_PAD		0x3000
#endif

struct sysmem_property {
	const char *name;
	phys_addr_t base;
	phys_size_t size;
	struct list_head node;
};

struct sysmem {
	struct lmb lmb;
	struct list_head allocated_head;
	struct list_head reserved_head;
	ulong allocated_cnt;
	bool has_init;
};

/**
 * sysmem_init() - Sysmem initialization
 *
 * @return 0 on success, otherwise error
 */
int sysmem_init(void);

/**
 * sysmem_add() - Add sysmem region
 *
 * @base: region base address
 * @size: region size
 *
 * @return 0 on success, otherwise error
 */
int sysmem_add(phys_addr_t base, phys_size_t size);

/**
 * sysmem_reserve() - Reserve sysmem region
 *
 * @name: region name
 * @base: region base address
 * @size: region size
 *
 * @return 0 on success, otherwise error
 */
int sysmem_reserve(const char *name, phys_addr_t base, phys_size_t size);

/**
 * sysmem_alloc() - Alloc sysmem region at anywhere
 *
 * @name: region name
 * @size: region size
 *
 * @return NULL on error, otherwise the allocated region address ptr
 */
void *sysmem_alloc(const char *name, phys_size_t size);

/**
 * sysmem_alloc_align() - Alloc sysmem region at anywhere with addr align down
 *
 * @name: region name
 * @size: region size
 * @align: region base address align (down)
 *
 * @return NULL on error, otherwise the allocated region address ptr
 */
void *sysmem_alloc_align(const char *name, phys_size_t size, ulong align);

/**
 * sysmem_alloc_base() - Alloc sysmem region at the expect addr
 *
 * @name: region name
 * @base: region base
 * @size: region size
 *
 * @return NULL on error, otherwise the allocated region address ptr
 */
void *sysmem_alloc_base(const char *name, phys_addr_t base, phys_size_t size);

/**
 * sysmem_alloc_align_base() - Alloc sysmem region at the expect addr with align down
 *
 * @name: region name
 * @base: region base
 * @size: region size
 * @align: region base address align (down)
 *
 * @return NULL on error, otherwise the allocated region address ptr
 */
void *sysmem_alloc_align_base(const char *name, phys_addr_t base,
			      phys_size_t size, ulong align);

/**
 * sysmem_free() - Free sysmem region
 *
 * @base: region base
 *
 * @return 0 on success, otherwise error
 */
int sysmem_free(phys_addr_t base);

/**
 * sysmem_check() - Check sysmem regions
 *
 * @return 0 on okay, otherwise something wrong
 */
int sysmem_check(void);

/**
 * sysmem_dump_all() - Dump all sysmem stat
 */
void sysmem_dump(void);

/**
 * sysmem_dump_check() - Dump all sysmem stat and check overflow
 */
int sysmem_dump_check(void);

/**
 * board_sysmem_reserve() - Weak function for board to implement
 *
 * @sysmem: global sysmem point, ignored
 *
 * @return 0 on success, otherwise error
 */
int board_sysmem_reserve(struct sysmem *sysmem);

/**
 * arch_sysmem_reserve() - Weak function for arch to implement
 *
 * @sysmem: global sysmem point, ignored
 *
 * @return 0 on success, otherwise error
 */
int arch_sysmem_reserve(struct sysmem *sysmem);

#endif /* _SYSMEM_H */
