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

#define SYSMEM_I(fmt, args...)	printf("Sysmem: "fmt, ##args)
#define SYSMEM_W(fmt, args...)	printf("Sysmem Warn: "fmt, ##args)
#define SYSMEM_E(fmt, args...)	printf("Sysmem Error: "fmt, ##args)
#define SYSMEM_D(fmt, args...)	 debug("Sysmem Debug: "fmt, ##args)

struct memcheck {
	uint32_t magic;
};

/* Global for platform, must in data section */
struct sysmem plat_sysmem __section(".data") = {
	.has_initf = false,
	.has_initr = false,
};

bool sysmem_has_init(void)
{
	return gd->flags & GD_FLG_RELOC ?
	       plat_sysmem.has_initr : plat_sysmem.has_initf;
}

void sysmem_dump(void)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct lmb *lmb = &sysmem->lmb;
	struct memblock *mem;
	struct memcheck *check;
	struct list_head *node;
	ulong memory_size = 0;
	ulong reserved_size = 0;
	ulong allocated_size = 0;
	bool overflow = false;
	ulong i;

	if (!sysmem_has_init())
		return;

	printf("\nsysmem_dump_all:\n");

	/* Memory pool */
	printf("    --------------------------------------------------------------------\n");
	for (i = 0; i < lmb->memory.cnt; i++) {
		memory_size += lmb->memory.region[i].size;
		printf("    memory.rgn[%ld].addr     = 0x%08lx - 0x%08lx (size: 0x%08lx)\n", i,
		       (ulong)lmb->memory.region[i].base,
		       (ulong)lmb->memory.region[i].base +
		       (ulong)lmb->memory.region[i].size,
		       (ulong)lmb->memory.region[i].size);
	}
	printf("\n    memory.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)memory_size,
	       SIZE_MB((ulong)memory_size),
	       SIZE_KB((ulong)memory_size));

	/* Allocated */
	i = 0;
	printf("    --------------------------------------------------------------------\n");
	list_for_each(node, &sysmem->allocated_head) {
		mem = list_entry(node, struct memblock, node);
		allocated_size += mem->size;
		if (mem->attr.flags & M_ATTR_OFC) {
			check = (struct memcheck *)
				(mem->base + mem->size - sizeof(*check));
			overflow = (check->magic != SYSMEM_MAGIC);
		} else if (mem->attr.flags & M_ATTR_HOFC) {
			check = (struct memcheck *)
				(mem->base - sizeof(*check));
			overflow = (check->magic != SYSMEM_MAGIC);
		} else {
			overflow = false;
		}

		printf("    allocated.rgn[%ld].name  = \"%s\" %s\n",
		       i, mem->attr.name, overflow ? "	   <Overflow!>" : "");
		printf("		    .addr  = 0x%08lx - 0x%08lx (size: 0x%08lx)\n",
		       (ulong)mem->base, (ulong)(mem->base + mem->size),
		       (ulong)mem->size);
		i++;
	}

	printf("\n    malloc_r: %d MiB, malloc_f: %d KiB\n",
	       SIZE_MB(CONFIG_SYS_MALLOC_LEN), SIZE_KB(CONFIG_SYS_MALLOC_F_LEN));
	printf("\n    allocated.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)allocated_size,
	       SIZE_MB((ulong)allocated_size),
	       SIZE_KB((ulong)allocated_size));

	/* LMB core reserved */
	printf("    --------------------------------------------------------------------\n");
	reserved_size = 0;
	for (i = 0; i < lmb->reserved.cnt; i++) {
		reserved_size += lmb->reserved.region[i].size;
		printf("    LMB.reserved[%ld].addr   = 0x%08lx - 0x%08lx (size: 0x%08lx)\n", i,
		       (ulong)lmb->reserved.region[i].base,
		       (ulong)lmb->reserved.region[i].base +
		       (ulong)lmb->reserved.region[i].size,
		       (ulong)lmb->reserved.region[i].size);
	}

	printf("\n    reserved.core.total	   = 0x%08lx (%ld MiB. %ld KiB)\n",
	       (ulong)reserved_size,
	       SIZE_MB((ulong)reserved_size),
	       SIZE_KB((ulong)reserved_size));
	printf("    --------------------------------------------------------------------\n\n");
}

static inline int sysmem_is_overlap(phys_addr_t base1, phys_size_t size1,
				    phys_addr_t base2, phys_size_t size2)
{
	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
}

static int sysmem_add(phys_addr_t base, phys_size_t size)
{
	struct sysmem *sysmem = &plat_sysmem;
	int ret;

	if (!size)
		return -EINVAL;

	ret = lmb_add(&sysmem->lmb, base, size);
	if (ret < 0)
		SYSMEM_E("Failed to add sysmem at 0x%08lx for 0x%08lx size\n",
			 (ulong)base, (ulong)size);

	return (ret >= 0) ? 0 : ret;
}

static const char *sysmem_alias2name(const char *name, int *id)
{
	const char *alias;
	int n, i, j;
	int match = 0;

	for (i = 0; i < MEMBLK_ID_MAX; i++) {
		/* Pirmary name */
		if (mem_attr[i].name && !strcasecmp(mem_attr[i].name, name)) {
			match = 1;
			goto finish;
		}

		/* Alias name */
		alias = mem_attr[i].alias[0];
		if (!alias)
			continue;

		n = ARRAY_SIZE(mem_attr[i].alias);
		for (j = 0; j < n; j++, alias++) {
			if (alias && !strcasecmp(alias, name)) {
				match = 1;
				goto finish;
			}
		}
	}

finish:
	if (match) {
		*id = i;
		return mem_attr[i].name;
	}

	return name;
}

static void *sysmem_alloc_align_base(enum memblk_id id,
				     const char *mem_name,
				     phys_addr_t base,
				     phys_size_t size,
				     ulong align)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct memblk_attr attr;
	struct memblock *mem;
	struct memcheck *check;
	struct list_head *node;
	const char *name;
	phys_addr_t paddr;
	phys_addr_t alloc_base;
	phys_size_t alloc_size;
	phys_addr_t bank_base;
	phys_size_t bank_size;
	bool req_overlap = false; /* Only for kernel reserved-memory */
	int i;

	if (!sysmem_has_init())
		return NULL;

	if (id == MEMBLK_ID_BY_NAME || id == MEMBLK_ID_FDT_RESV) {
		if (!mem_name) {
			SYSMEM_E("NULL name for alloc sysmem\n");
			return NULL;
		} else if (id == MEMBLK_ID_FDT_RESV) {
			for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
				if (!gd->bd->bi_dram[i].size)
					continue;

				bank_base = gd->bd->bi_dram[i].start;
				bank_size = gd->bd->bi_dram[i].size;
				if (sysmem_is_overlap(base, size,
						      bank_base, bank_size)) {
					req_overlap = true;
					break;
				}
			}

			if (!req_overlap)
				return (void *)base;
		}
		name = sysmem_alias2name(mem_name, (int *)&id);
		attr = mem_attr[id];
		if (!attr.name)
			attr.name = strdup(name);
	} else if (id > MEMBLK_ID_UNK && id < MEMBLK_ID_MAX) {
		attr = mem_attr[id];
		name = attr.name;
	} else {
		SYSMEM_E("Unsupport memblk id %d for alloc sysmem\n", id);
		return NULL;
	}

	if (!size) {
		SYSMEM_E("\"%s\" size is 0 for alloc sysmem\n", name);
		return NULL;
	}

	if (!IS_ALIGNED(base, 4)) {
		SYSMEM_E("\"%s\" base=0x%08lx is not 4-byte aligned\n",
			 name, (ulong)base);
		return NULL;
	}

	/* Must be 4-byte aligned */
	size = ALIGN(size, 4);

	SYSMEM_D("Enter alloc: \"%s\" 0x%08lx - 0x%08lx\n",
		 name, (ulong)base, (ulong)(base + size));

	/* Already allocated ? */
	list_for_each(node, &sysmem->allocated_head) {
		mem = list_entry(node, struct memblock, node);
		SYSMEM_D("Has allcated: %s, 0x%08lx - 0x%08lx\n",
			 mem->attr.name, (ulong)mem->base,
			 (ulong)(mem->base + mem->size));
		if (!strcmp(mem->attr.name, name)) {
			if (mem->base <= base && mem->size >= size)
				return (void *)base;

			SYSMEM_E("Failed to double alloc for existence \"%s\"\n", name);
			return NULL;
		} else if (sysmem_is_overlap(mem->base, mem->size, base, size)) {
			if (req_overlap && mem->attr.flags & M_ATTR_OVERLAP) {
				if (lmb_reserve(&sysmem->lmb, base, size))
					SYSMEM_E("Failed to overlap alloc \"%s\" "
						 "at 0x%08lx - 0x%08lx\n",
						 name, (ulong)base,
						 (ulong)(base + size));
				return (void *)base;
			}

			SYSMEM_E("\"%s\" (0x%08lx - 0x%08lx) alloc is "
				 "overlap with existence \"%s\" (0x%08lx - "
				 "0x%08lx)\n",
				 name, (ulong)base, (ulong)(base + size),
				 mem->attr.name, (ulong)mem->base,
				 (ulong)(mem->base + mem->size));
			return NULL;
		}
	}

	/* Add overflow check magic ? */
	if (attr.flags & M_ATTR_OFC)
		alloc_size = size + sizeof(*check);
	else
		alloc_size = size;

	/* Alloc anywhere ? */
	if (base == SYSMEM_ALLOC_ANYWHERE)
		alloc_base = base;
	else
		alloc_base = base + alloc_size;	/* LMB is align down alloc mechanism */

	paddr = lmb_alloc_base(&sysmem->lmb, alloc_size, align, alloc_base);
	if (paddr) {
		if ((paddr == base) || (base == SYSMEM_ALLOC_ANYWHERE)) {
			mem = malloc(sizeof(*mem));
			if (!mem) {
				SYSMEM_E("No memory for \"%s\" alloc sysmem\n", name);
				return NULL;
			}

			mem->base = paddr;
			mem->size = alloc_size;
			mem->attr = attr;
			sysmem->allocated_cnt++;
			list_add_tail(&mem->node, &sysmem->allocated_head);

			if (mem->attr.flags & M_ATTR_OFC) {
				check = (struct memcheck *)(paddr + size);
				check->magic = SYSMEM_MAGIC;
			} else if (mem->attr.flags & M_ATTR_HOFC) {
				check = (struct memcheck *)(paddr - sizeof(*check));
				check->magic = SYSMEM_MAGIC;
			}
		} else {
			SYSMEM_E("Failed to alloc \"%s\" expect at 0x%08lx - 0x%08lx "
				 "but at 0x%08lx - x%08lx\n",
				 name, (ulong)base, (ulong)(base + size),
				 (ulong)paddr, (ulong)(paddr + size));
			if (lmb_free(&sysmem->lmb, paddr, alloc_size))
				SYSMEM_E("Failed to free \"%s\"\n", name);

			return NULL;
		}
	} else {
		SYSMEM_E("Failed to alloc \"%s\" at 0x%08lx - 0x%08lx\n",
			 name, (ulong)base, (ulong)(base + size));
	}

	SYSMEM_D("Exit alloc: \"%s\", paddr=0x%08lx, size=0x%08lx, align=0x%x, anywhere=%d\n",
		 name, (ulong)paddr, (ulong)size, (u32)align, !base);

	return (void *)paddr;
}

void *sysmem_alloc_base(enum memblk_id id, phys_addr_t base, phys_size_t size)
{
	void *paddr;

	paddr = sysmem_alloc_align_base(id,
					NULL,
					base,
					size,
					SYSMEM_ALLOC_NO_ALIGN);
	if (!paddr)
		sysmem_dump();

	return paddr;
}

void *sysmem_alloc_base_by_name(const char *name,
				phys_addr_t base, phys_size_t size)
{
	void *paddr;

	paddr = sysmem_alloc_align_base(MEMBLK_ID_BY_NAME,
					name,
					base,
					size,
					SYSMEM_ALLOC_NO_ALIGN);
	if (!paddr)
		sysmem_dump();

	return paddr;
}

void *sysmem_fdt_reserve_alloc_base(const char *name,
				    phys_addr_t base, phys_size_t size)
{
	void *paddr;

	paddr = sysmem_alloc_align_base(MEMBLK_ID_FDT_RESV,
					name,
					base,
					size,
					SYSMEM_ALLOC_NO_ALIGN);
	if (!paddr)
		sysmem_dump();

	return paddr;
}

int sysmem_free(phys_addr_t base)
{
	struct sysmem *sysmem = &plat_sysmem;
	struct memblock *mem;
	struct list_head *node;
	int ret, found = 0;

	if (!sysmem_has_init())
		return -ENOSYS;

	/* Find existence */
	list_for_each(node, &sysmem->allocated_head) {
		mem = list_entry(node, struct memblock, node);
		if (mem->base == base) {
			found = 1;
			break;
		}
	}

	if (!found) {
		SYSMEM_E("Failed to free no allocated sysmem at 0x%08lx\n",
			 (ulong)base);
		return -EINVAL;
	}

	ret = lmb_free(&sysmem->lmb, mem->base, mem->size);
	if (ret >= 0) {
		SYSMEM_D("Free: \"%s\" 0x%08lx - 0x%08lx\n",
			 mem->attr.name, (ulong)mem->base,
			 (ulong)(mem->base + mem->size));
		sysmem->allocated_cnt--;
		list_del(&mem->node);
		free(mem);
	} else {
		SYSMEM_E("Failed to free \"%s\" at 0x%08lx\n",
			 mem->attr.name, (ulong)base);
	}

	return (ret >= 0) ? 0 : ret;
}

int sysmem_initr(void)
{
	return sysmem_init();
}

int sysmem_init(void)
{
	struct sysmem *sysmem = &plat_sysmem;
	phys_addr_t mem_start;
	phys_size_t mem_size;
	int ret;

	lmb_init(&sysmem->lmb);
	INIT_LIST_HEAD(&sysmem->allocated_head);
	sysmem->allocated_cnt = 0;
	if (gd->flags & GD_FLG_RELOC) {
		sysmem->has_initr = true;
	} else {
		SYSMEM_I("init\n");
		sysmem->has_initf = true;
	}

	/* Add all available system memory */
#ifdef CONFIG_NR_DRAM_BANKS
	int i;

	for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		if (!gd->bd->bi_dram[i].size)
			continue;

		ret = sysmem_add(gd->bd->bi_dram[i].start,
				 gd->bd->bi_dram[i].size);
		if (ret) {
			SYSMEM_E("Failed to add sysmem from bi_dram[%d]\n", i);
			goto fail;
		}
	}
#else
	mem_start = env_get_bootm_low();
	mem_size = env_get_bootm_size();
	ret = sysmem_add(mem_start, mem_size);
	if (ret) {
		SYSMEM_E("Failed to add sysmem from bootm_low/size\n");
		goto fail;
	}
#endif
	/* Reserved for board */
	ret = board_sysmem_reserve(sysmem);
	if (ret) {
		SYSMEM_E("Failed to reserve sysmem for board\n");
		goto fail;
	}

	/* Reserved for U-boot framework: 'reserve_xxx()' */
	mem_start = gd->start_addr_sp;
	mem_size = gd->ram_top - mem_start;
	if (!sysmem_alloc_base(MEMBLK_ID_UBOOT, mem_start, mem_size)) {
		SYSMEM_E("Failed to reserve sysmem for U-Boot framework\n");
		ret = -ENOMEM;
		goto fail;
	}

	/* Reserved for U-Boot stack */
	mem_start = gd->start_addr_sp - CONFIG_SYS_STACK_SIZE;
	mem_size = CONFIG_SYS_STACK_SIZE;
	if (!sysmem_alloc_base(MEMBLK_ID_STACK, mem_start, mem_size)) {
		SYSMEM_E("Failed to reserve sysmem for stack\n");
		ret = -ENOMEM;
		goto fail;
	}

	return 0;

fail:
	if (ret && !(gd->flags & GD_FLG_RELOC)) {
		sysmem_dump();
		SYSMEM_W("Maybe malloc size %d MiB is too large?\n\n",
			 SIZE_MB(CONFIG_SYS_MALLOC_LEN));
	}

	return ret;
}

__weak int board_sysmem_reserve(struct sysmem *sysmem)
{
	/* please define platform specific board_sysmem_reserve() */
	return 0;
}

static int do_dump_sysmem(cmd_tbl_t *cmdtp, int flag,
			  int argc, char *const argv[])
{
	sysmem_dump();
	return 0;
}

U_BOOT_CMD(
	dump_sysmem, 1, 1, do_dump_sysmem,
	"Dump sysmem layout",
	""
);
