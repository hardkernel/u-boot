// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <sysmem.h>
#include <lmb.h>
#include <malloc.h>
#include <asm/io.h>

DECLARE_GLOBAL_DATA_PTR;

#define SYSMEM_MAGIC		0x4D454D53	/* "SMEM" */
#define SYSMEM_ALLOC_ANYWHERE	0
#define SYSMEM_ALLOC_NO_ALIGN	1

#ifndef CONFIG_SYS_STACK_SIZE
#define CONFIG_SYS_STACK_SIZE	SZ_2M
#endif

#define SIZE_MB(len)		((len) >> 20)
#define SIZE_KB(len)		(((len) % (1 << 20)) >> 10)

#define SYSMEM_I(fmt, args...)	printf("Sysmem: "fmt, ##args)
#define SYSMEM_W(fmt, args...)	printf("Sysmem Warn: "fmt, ##args)
#define SYSMEM_E(fmt, args...)	printf("Sysmem Error: "fmt, ##args)
#define SYSMEM_D(fmt, args...)	 debug("Sysmem Debug: "fmt, ##args)

static struct sysmem plat_sysmem;	/* Global for platform */

struct sysmem_check {
	uint32_t magic;
};

static int sysmem_has_init(void)
{
	if (!plat_sysmem.has_init) {
		SYSMEM_E("Framework is not initialized\n");
		return 0;
	}

	return 1;
}

void sysmem_dump(void)
{
#ifdef DEBUG
	struct sysmem *sysmem = &plat_sysmem;
	struct lmb *lmb = &sysmem->lmb;
	struct sysmem_property *prop;
	struct sysmem_check *check;
	struct list_head *node;
	ulong memory_size = 0;
	ulong reserved_size = 0;
	ulong allocated_size = 0;
	ulong i;

	if (!sysmem_has_init())
		return;

	printf("\nsysmem_dump_all:\n");

	/* Memory pool */
	printf("    ------------------------------------------------------\n");
	for (i = 0; i < lmb->memory.cnt; i++) {
		memory_size += lmb->memory.region[i].size;
		printf("    memory.rgn[%ld].base     = 0x%08lx\n", i,
		       (ulong)lmb->memory.region[i].base);
		printf("		 .size     = 0x%08lx\n",
		       (ulong)lmb->memory.region[i].size);
	}
	printf("\n    memory.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)memory_size,
	       SIZE_MB((ulong)memory_size),
	       SIZE_KB((ulong)memory_size));

	/* Reserved */
	i = 0;
	printf("    ------------------------------------------------------\n");
	list_for_each(node, &sysmem->reserved_head) {
		prop = list_entry(node, struct sysmem_property, node);
		reserved_size += prop->size;
		printf("    reserved.rgn[%ld].name   = \"%s\"\n", i, prop->name);
		printf("		   .base   = 0x%08lx\n",
		       (ulong)prop->base);
		printf("		   .size   = 0x%08lx\n",
		       (ulong)prop->size);
		i++;
	}
	printf("\n    reserved.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)reserved_size,
	       SIZE_MB((ulong)reserved_size),
	       SIZE_KB((ulong)reserved_size));

	/* Allocated */
	i = 0;
	printf("    ------------------------------------------------------\n");
	list_for_each(node, &sysmem->allocated_head) {
		prop = list_entry(node, struct sysmem_property, node);
		allocated_size += prop->size;
		check = (struct sysmem_check *)
				(prop->base + prop->size - sizeof(*check));
		printf("    allocated.rgn[%ld].name  = \"%s\"%s\n",
		       i, prop->name,
		       check->magic != SYSMEM_MAGIC ? "	(Overflow)" : "");
		printf("		    .base  = 0x%08lx\n",
		       (ulong)prop->base);
		printf("		    .size  = 0x%08lx\n",
		       (ulong)prop->size);
		i++;
	}
	printf("\n    allocated.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)allocated_size,
	       SIZE_MB((ulong)allocated_size),
	       SIZE_KB((ulong)allocated_size));

	/* LMB core reserved */
	printf("    ------------------------------------------------------\n");
	reserved_size = 0;
	for (i = 0; i < lmb->reserved.cnt; i++) {
		reserved_size += lmb->reserved.region[i].size;
		printf("    LMB.reserved[%ld].base   = 0x%08lx\n", i,
		       (ulong)lmb->reserved.region[i].base);
		printf("		   .size   = 0x%08lx\n",
		       (ulong)lmb->reserved.region[i].size);
	}

	printf("\n    reserved.core.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)reserved_size,
	       SIZE_MB((ulong)reserved_size),
	       SIZE_KB((ulong)reserved_size));
	printf("    ------------------------------------------------------\n\n");
#endif
}

int sysmem_check(void)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct sysmem_property *prop;
	struct sysmem_check *check;
	struct list_head *node;
	int ret = 0;

	if (!sysmem_has_init())
		return -ENOSYS;

	/* Check allocated */
	list_for_each(node, &sysmem->allocated_head) {
		prop = list_entry(node, struct sysmem_property, node);
		check = (struct sysmem_check *)
				(prop->base + prop->size - sizeof(*check));
		if (check->magic != SYSMEM_MAGIC) {
			ret = -EOVERFLOW;
			SYSMEM_E("\"%s\" (base=0x%08lx, size=0x%lx) is Overflow!\n",
				 prop->name, (ulong)prop->base, (ulong)prop->size);
		}
	}

	/* Check stack */
	check = (struct sysmem_check *)(gd->start_addr_sp - CONFIG_SYS_STACK_SIZE);
	if (check->magic != SYSMEM_MAGIC) {
		ret = -EOVERFLOW;
		SYSMEM_E("Runtime stack is Overflow!\n");
	}

	return ret;
}

int sysmem_dump_check(void)
{
	sysmem_dump();

	return sysmem_check();
}

static int sysmem_is_overlap(phys_addr_t base1, phys_size_t size1,
			     phys_addr_t base2, phys_size_t size2)
{
	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
}

int sysmem_add(phys_addr_t base, phys_size_t size)
{
	struct sysmem *sysmem = &plat_sysmem;
	int ret;

	if (!sysmem_has_init())
		return -ENOSYS;

	ret = lmb_add(&sysmem->lmb, base, size);
	if (ret < 0)
		SYSMEM_E("Failed to add sysmem at 0x%lx for 0x%lx size\n",
			 (ulong)base, (ulong)size);

	return (ret >= 0) ? 0 : ret;
}

int sysmem_reserve(const char *name, phys_addr_t base, phys_size_t size)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct sysmem_property *prop;
	struct list_head *node;
	int ret = 0;

	if (!sysmem_has_init())
		return -ENOSYS;

	if (!name) {
		SYSMEM_E("NULL name for reserved sysmem\n");
		return -EINVAL;
	}

	/* Check overlap */
	list_for_each(node, &sysmem->reserved_head) {
		prop = list_entry(node, struct sysmem_property, node);
		if (!strcmp(prop->name, name)) {
			SYSMEM_E("Failed to double reserve for existence \"%s\"\n", name);
			return -EEXIST;
		} else if (sysmem_is_overlap(prop->base, prop->size, base, size)) {
			SYSMEM_D("\"%s\" (base=0x%08lx, size=0x%lx) reserve is "
				 "overlap with existence \"%s\" (base=0x%08lx, size=0x%lx)\n",
				 name, (ulong)base, (ulong)size, prop->name,
				 (ulong)prop->base, (ulong)prop->size);
		}
	}

	ret = lmb_reserve(&sysmem->lmb, base, size);
	if (ret >= 0) {
		prop = malloc(sizeof(*prop));
		if (!prop) {
			SYSMEM_E("No memory for \"%s\" reserve sysmem\n", name);
			return -ENOMEM;
		}

		prop->name = name;
		prop->base = base;
		prop->size = size;
		list_add_tail(&prop->node, &sysmem->reserved_head);
	} else {
		SYSMEM_E("Failed to reserve \"%s\" at 0x%lx\n", name, (ulong)base);
		return -EINVAL;
	}

	return 0;
}

void *sysmem_alloc_align_base(const char *name,
			      phys_addr_t base,
			      phys_size_t size,
			      ulong align)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct sysmem_property *prop;
	struct sysmem_check *check;
	struct list_head *node;
	phys_addr_t paddr;
	phys_addr_t alloc_base;
	phys_size_t alloc_size;

	if (!sysmem_has_init())
		return NULL;

	if (!name) {
		SYSMEM_E("NULL name for alloc sysmem\n");
		return NULL;
	}

	if (!IS_ALIGNED(base, 4)) {
		SYSMEM_E("\"%s\" base=0x%08lx is not 4-byte aligned\n", name, (ulong)base);
		return NULL;
	}

	/* Must be 4-byte aligned */
	size = ALIGN(size, 4);

	/* Already allocated ? */
	list_for_each(node, &sysmem->allocated_head) {
		prop = list_entry(node, struct sysmem_property, node);
		if (!strcmp(prop->name, name)) {
			SYSMEM_E("Failed to double alloc for existence \"%s\"\n", name);
			return NULL;
		} else if (sysmem_is_overlap(prop->base, prop->size, base, size)) {
			SYSMEM_E("\"%s\" (base=0x%08lx, size=0x%lx) alloc is "
				 "overlap with existence \"%s\" (base=0x%08lx, size=0x%lx)\n",
				 name, (ulong)base, (ulong)size,
				 prop->name, (ulong)prop->base,
				 (ulong)prop->size);
			return NULL;
		}
	}

	alloc_size = size + sizeof(*check);
	if (base == SYSMEM_ALLOC_ANYWHERE)
		alloc_base = base;
	else
		alloc_base = base + alloc_size;	/* LMB is align down alloc mechanism */

	paddr = lmb_alloc_base(&sysmem->lmb, alloc_size, align, alloc_base);
	if (paddr) {
		if  ((paddr == base) || (base == SYSMEM_ALLOC_ANYWHERE)) {
			prop = malloc(sizeof(*prop));
			if (!prop) {
				SYSMEM_E("No memory for \"%s\" alloc sysmem\n", name);
				return NULL;
			}

			prop->name = name;
			prop->base = paddr;
			prop->size = alloc_size;
			sysmem->allocated_cnt++;

			check = (struct sysmem_check *)(paddr + size);
			check->magic = SYSMEM_MAGIC;

			list_add_tail(&prop->node, &sysmem->allocated_head);
		} else {
			SYSMEM_E("Failed to alloc \"%s\" at expect 0x%lx but "
				 "alloc at 0x%lx\n",
				 name, (ulong)base, (ulong)paddr);
			return NULL;
		}
	} else {
		SYSMEM_E("Failed to alloc \"%s\" at 0x%lx\n", name, (ulong)base);
	}

	SYSMEM_D("Alloc: \"%s\", paddr=0x%lx, size=0x%lx, align=0x%x, anywhere=%d\n",
		 name, (ulong)paddr, (ulong)size, (u32)align, !base);

	return (void *)paddr;
}

void *sysmem_alloc_align(const char *name, phys_size_t size, ulong align)
{
	return sysmem_alloc_align_base(name,
				       SYSMEM_ALLOC_ANYWHERE,
				       size,
				       align);
}

void *sysmem_alloc_base(const char *name, phys_addr_t base, phys_size_t size)
{
	return sysmem_alloc_align_base(name,
				       base,
				       size,
				       SYSMEM_ALLOC_NO_ALIGN);
}

void *sysmem_alloc(const char *name, phys_size_t size)
{
	return sysmem_alloc_align_base(name,
				       SYSMEM_ALLOC_ANYWHERE,
				       size,
				       SYSMEM_ALLOC_NO_ALIGN);
}

int sysmem_free(phys_addr_t base)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct sysmem_property *prop;
	struct list_head *node;
	int found = 0;
	int ret;

	if (!sysmem_has_init())
		return -ENOSYS;

	/* Find existence */
	list_for_each(node, &sysmem->allocated_head) {
		prop = list_entry(node, struct sysmem_property, node);
		if (prop->base == base) {
			found = 1;
			break;
		}
	}

	if (!found) {
		SYSMEM_E("Failed to free no allocated sysmem at 0x%lx\n", (ulong)base);
		return -EINVAL;
	}

	ret = lmb_free(&sysmem->lmb, prop->base, prop->size);
	if (ret >= 0) {
		SYSMEM_D("Free: \"%s\", paddr=0x%lx, size=0x%lx\n",
			 prop->name, (ulong)prop->base, (ulong)prop->size);
		sysmem->allocated_cnt--;
		list_del(&prop->node);
		free(prop);
	} else {
		SYSMEM_E("Failed to free \"%s\" at 0x%lx\n", prop->name, (ulong)base);
	}

	return (ret >= 0) ? 0 : ret;
}

int sysmem_init(void)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct sysmem_check *check;
	phys_addr_t mem_start;
	phys_size_t mem_size;
	int ret;

	SYSMEM_I("init\n");

	lmb_init(&sysmem->lmb);
	INIT_LIST_HEAD(&sysmem->allocated_head);
	INIT_LIST_HEAD(&sysmem->reserved_head);
	sysmem->allocated_cnt = 0;
	sysmem->has_init = true;

	/* Add all available system memory */
#ifdef CONFIG_NR_DRAM_BANKS
	int i;

	for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		ret = sysmem_add(gd->bd->bi_dram[i].start,
				 gd->bd->bi_dram[i].size);
		if (ret) {
			SYSMEM_E("Failed to add sysmem from bi_dram[%d]\n", i);
			return ret;
		}
	}
#else
	mem_start = env_get_bootm_low();
	mem_size = env_get_bootm_size();
	ret = sysmem_add(mem_start, mem_size);
	if (ret) {
		SYSMEM_E("Failed to add sysmem from bootm_low/size\n");
		return ret;
	}
#endif

	/* Reserved for arch */
	ret = arch_sysmem_reserve(sysmem);
	if (ret) {
		SYSMEM_E("Failed to reserve sysmem for arch\n");
		return ret;
	}

	/* Reserved for board */
	ret = board_sysmem_reserve(sysmem);
	if (ret) {
		SYSMEM_E("Failed to reserve sysmem for board\n");
		return ret;
	}

	/* Reserved for U-boot framework 'reserve_xxx()' */
	mem_start = gd->start_addr_sp - CONFIG_SYS_STACK_SIZE;
	mem_size = gd->ram_top - mem_start;
	check = (struct sysmem_check *)mem_start;
	check->magic = SYSMEM_MAGIC;

	ret = sysmem_reserve("U-Boot", mem_start, mem_size);
	if (ret) {
		SYSMEM_E("Failed to reserve sysmem for U-Boot framework\n");
		return ret;
	}

	sysmem_dump();

	return 0;
}

__weak int board_sysmem_reserve(struct sysmem *sysmem)
{
	/* please define platform specific board_sysmem_reserve() */
	return 0;
}

__weak int arch_sysmem_reserve(struct sysmem *sysmem)
{
	/* please define platform specific arch_sysmem_reserve() */
	return 0;
}
