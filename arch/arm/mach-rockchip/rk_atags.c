// SPDX-License-Identifier:     GPL-2.0+
/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd.
 *
 */

#include <common.h>
#include <asm/arch/rk_atags.h>
#if CONFIG_IS_ENABLED(TINY_FRAMEWORK)
#include <debug_uart.h>
#endif

#define tag_next(t)	((struct tag *)((u32 *)(t) + (t)->hdr.size))
#define tag_size(type)	((sizeof(struct tag_header) + sizeof(struct type)) >> 2)
#define for_each_tag(t, base)		\
	for (t = base; t->hdr.size; t = tag_next(t))

#if CONFIG_IS_ENABLED(TINY_FRAMEWORK) &&		\
	!CONFIG_IS_ENABLED(LIBGENERIC_SUPPORT) &&	\
	defined(CONFIG_ARM64)
/**
 * memset - Fill a region of memory with the given value
 * @s: Pointer to the start of the area.
 * @c: The byte to fill the area with
 * @count: The size of the area.
 *
 * Do not use memset() to access IO space, use memset_io() instead.
 */
void *memset(void *s, int c, size_t count)
{
	unsigned long *sl = (unsigned long *)s;
	char *s8;

	s8 = (char *)sl;
	while (count--)
		*s8++ = c;

	return s;
}

/**
 * memcpy - Copy one area of memory to another
 * @dest: Where to copy to
 * @src: Where to copy from
 * @count: The size of the area.
 *
 * You should not use this function to access IO space, use memcpy_toio()
 * or memcpy_fromio() instead.
 */
void *memcpy(void *dest, const void *src, size_t count)
{
	unsigned long *dl = (unsigned long *)dest, *sl = (unsigned long *)src;
	char *d8, *s8;

	if (src == dest)
		return dest;

	/* while all data is aligned (common case), copy a word at a time */
	if ((((ulong)dest | (ulong)src) & (sizeof(*dl) - 1)) == 0) {
		while (count >= sizeof(*dl)) {
			*dl++ = *sl++;
			count -= sizeof(*dl);
		}
	}
	/* copy the reset one byte at a time */
	d8 = (char *)dl;
	s8 = (char *)sl;
	while (count--)
		*d8++ = *s8++;

	return dest;
}
#endif

static int inline bad_magic(u32 magic)
{
	return ((magic != ATAG_CORE) &&
		(magic != ATAG_NONE) &&
		(magic < ATAG_SERIAL || magic > ATAG_MAX));
}

static int inline atags_size_overflow(struct tag *t, u32 tag_size)
{
	return (unsigned long)t + (tag_size << 2) - ATAGS_PHYS_BASE > ATAGS_SIZE;
}

int atags_is_available(void)
{
	struct tag *t = (struct tag *)ATAGS_PHYS_BASE;

	return (t->hdr.magic == ATAG_CORE);
}

int atags_set_tag(u32 magic, void *tagdata)
{
	u32 length, size = 0;
	struct tag *t = (struct tag *)ATAGS_PHYS_BASE;

	if (!tagdata)
		return -ENODATA;

	if (bad_magic(magic)) {
#if !CONFIG_IS_ENABLED(TINY_FRAMEWORK)
		printf("%s: magic(%x) is not support\n", __func__, magic);
#else
		printascii("magic is not support\n");
#endif

		return -EINVAL;
	}

	/* Not allowed to be set by user directly, so do nothing */
	if ((magic == ATAG_CORE) || (magic == ATAG_NONE))
		return -EPERM;

	/* If not initialized, setup now! */
	if (t->hdr.magic != ATAG_CORE) {
		t->hdr.magic = ATAG_CORE;
		t->hdr.size = tag_size(tag_core);
		t->u.core.flags = 0;
		t->u.core.pagesize = 0;
		t->u.core.rootdev = 0;

		t = tag_next(t);
	} else {
		/* Find the end, and use it as a new tag */
		for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
			/*
			 * We had better check magic to avoid traversing an
			 * unknown tag, in case of atags has been damaged by
			 * some unknown reason.
			 */
			if (bad_magic(t->hdr.magic)) {
#if !CONFIG_IS_ENABLED(TINY_FRAMEWORK)
				printf("%s: find unknown magic(%x)\n",
				       __func__, t->hdr.magic);
#else
				printascii("find unknown magic\n");
#endif

				return -EINVAL;
			}

			if (t->hdr.magic == ATAG_NONE)
				break;
		}
	}

	/* Initialize new tag */
	switch (magic) {
	case ATAG_SERIAL:
		size = tag_size(tag_serial);
		break;
	case ATAG_BOOTDEV:
		size = tag_size(tag_bootdev);
		break;
	case ATAG_TOS_MEM:
		size = tag_size(tag_tos_mem);
		break;
	case ATAG_DDR_MEM:
		size = tag_size(tag_ddr_mem);
		break;
	case ATAG_RAM_PARTITION:
		size = tag_size(tag_ram_partition);
		break;
	case ATAG_ATF_MEM:
		size = tag_size(tag_atf_mem);
		break;
	};

	if (atags_size_overflow(t, size)) {
#if !CONFIG_IS_ENABLED(TINY_FRAMEWORK)
		printf("%s: failed! no memory to setup magic(%x), max_mem=0x%x\n",
		       __func__, magic, ATAGS_SIZE);
#else
		printascii("no memory to setup magic\n");
#endif

		return -ENOMEM;
	}

	/* It's okay to setup a new tag */
	t->hdr.magic = magic;
	t->hdr.size = size;
	length = (t->hdr.size << 2) - sizeof(struct tag_header);
	memcpy(&t->u, (char *)tagdata, length);

	/* Next tag */
	t = tag_next(t);

	/* Setup done */
	t->hdr.magic = ATAG_NONE;
	t->hdr.size = 0;

	return 0;
}

struct tag *atags_get_tag(u32 magic)
{
	struct tag *t;

	if (!atags_is_available())
		return NULL;

	for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
		if (bad_magic(t->hdr.magic)) {
#if !CONFIG_IS_ENABLED(TINY_FRAMEWORK)
			printf("%s: find unknown magic(%x)\n",
			       __func__, t->hdr.magic);
#else
			printascii("find unknown magic\n");
#endif
			return NULL;
		}

		if (t->hdr.magic == magic)
			return t;
	}

	return NULL;
}

void atags_destroy(void)
{
	if (atags_is_available())
		memset((char *)ATAGS_PHYS_BASE, 0, sizeof(struct tag));
}

#if (defined(CONFIG_DEBUG_ATAGS) || defined(DEBUG)) && \
    !defined(CONFIG_SPL_BUILD) && !defined(CONFIG_TPL_BUILD)
void atags_stat(void)
{
	u32 in_use = 0, in_available = 0;
	u32 start = ATAGS_PHYS_BASE, end = ATAGS_PHYS_BASE + ATAGS_SIZE;
	struct tag *t;

	for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
		if (bad_magic(t->hdr.magic)) {
			printf("%s: find unknown magic(%x)\n",
			       __func__, t->hdr.magic);
			return;
		}

		in_use += (t->hdr.size << 2);
	}

	in_available = ATAGS_SIZE - in_use;

	printf("ATAGS state:\n");
	printf("              addr = 0x%08x ~ 0x%08x\n", start, end);
	printf("        Total size = 0x%08x\n", ATAGS_SIZE);
	printf("       in use size = 0x%08x\n", in_use);
	printf("    available size = 0x%08x\n", in_available);
}

void atags_print_tag(struct tag *t)
{
	u32 i;

	if (!t)
		return;

	switch (t->hdr.magic) {
	case ATAG_SERIAL:
		printf("[serial]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("   version = 0x%x\n", t->u.serial.version);
		printf("    enable = 0x%x\n", t->u.serial.enable);
		printf("      addr = 0x%llx\n", t->u.serial.addr);
		printf("  baudrate = %d\n", t->u.serial.baudrate);
		printf("    m_mode = 0x%x\n", t->u.serial.m_mode);
		printf("        id = 0x%x\n", t->u.serial.id);
		for (i = 0; i < ARRAY_SIZE(t->u.serial.reserved); i++)
			printf("    res[%d] = 0x%x\n", i, t->u.serial.reserved[i]);
		break;
	case ATAG_BOOTDEV:
		printf("[bootdev]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("   version = 0x%x\n", t->u.bootdev.version);
		printf("   devtype = 0x%x\n", t->u.bootdev.devtype);
		printf("    devnum = 0x%x\n", t->u.bootdev.devnum);
		printf("      mode = 0x%x\n", t->u.bootdev.mode);
		for (i = 0; i < ARRAY_SIZE(t->u.bootdev.reserved); i++)
			printf("    res[%d] = 0x%x\n",
			       i, t->u.bootdev.reserved[i]);
		break;
	case ATAG_TOS_MEM:
		printf("[tos_mem]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("   version = 0x%x\n", t->u.tos_mem.version);
		printf("   tee_mem:\n");
		printf("            name = %s\n", t->u.tos_mem.tee_mem.name);
		printf("        phy_addr = 0x%llx\n", t->u.tos_mem.tee_mem.phy_addr);
		printf("            size = 0x%x\n", t->u.tos_mem.tee_mem.size);
		printf("           flags = 0x%x\n", t->u.tos_mem.tee_mem.flags);
		printf("   drm_mem:\n");
		printf("            name = %s\n", t->u.tos_mem.drm_mem.name);
		printf("        phy_addr = 0x%llx\n", t->u.tos_mem.drm_mem.phy_addr);
		printf("            size = 0x%x\n", t->u.tos_mem.drm_mem.size);
		printf("           flags = 0x%x\n", t->u.tos_mem.drm_mem.flags);
		for (i = 0; i < ARRAY_SIZE(t->u.tos_mem.reserved); i++)
			printf("   res[%d] = 0x%llx\n", i, t->u.tos_mem.reserved[i]);
		break;
	case ATAG_DDR_MEM:
		printf("[ddr_mem]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("     count = 0x%x\n", t->u.ddr_mem.count);
		printf("   version = 0x%x\n", t->u.ddr_mem.version);
		for (i = 0; i < ARRAY_SIZE(t->u.ddr_mem.bank); i++)
			printf("  bank[%d] = 0x%llx\n", i, t->u.ddr_mem.bank[i]);
		for (i = 0; i < ARRAY_SIZE(t->u.ddr_mem.reserved); i++)
			printf("    res[%d] = 0x%x\n", i, t->u.ddr_mem.reserved[i]);
		break;
	case ATAG_RAM_PARTITION:
		printf("[ram_partition]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("   version = 0x%x\n", t->u.ram_part.version);
		printf("     count = 0x%x\n", t->u.ram_part.count);
		for (i = 0; i < ARRAY_SIZE(t->u.ram_part.reserved); i++)
			printf("    res[%d] = 0x%x\n", i, t->u.ram_part.reserved[i]);

		printf("    Part:  Name       Start Addr      Size\t\n");
		for (i = 0; i < t->u.ram_part.count; i++)
			printf("%16s      0x%08llx      0x%08llx\n",
			       t->u.ram_part.part[i].name,
			       t->u.ram_part.part[i].start,
			       t->u.ram_part.part[i].size);
		break;
	case ATAG_ATF_MEM:
		printf("[atf_mem]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("   version = 0x%x\n", t->u.atf_mem.version);
		printf("  phy_addr = 0x%llx\n", t->u.atf_mem.phy_addr);
		printf("      size = 0x%x\n", t->u.atf_mem.size);
		for (i = 0; i < ARRAY_SIZE(t->u.atf_mem.reserved); i++)
			printf("    res[%d] = 0x%x\n", i, t->u.atf_mem.reserved[i]);
		break;
	case ATAG_CORE:
		printf("[core]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("     flags = 0x%x\n", t->u.core.flags);
		printf("  pagesize = 0x%x\n", t->u.core.pagesize);
		printf("   rootdev = 0x%x\n", t->u.core.rootdev);
		break;
	default:
		printf("%s: magic(%x) is not support\n", __func__, t->hdr.magic);
	}

	printf("\n");
}

void atags_print_all_tags(void)
{
	struct tag *t;

	for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
		if (bad_magic(t->hdr.magic)) {
			printf("%s: find unknown magic(%x)\n",
			       __func__, t->hdr.magic);
			return;
		}

		atags_print_tag(t);
	}
}

void atags_test(void)
{
	struct tag_serial t_serial;
	struct tag_bootdev t_bootdev;
	struct tag_ddr_mem t_ddr_mem;
	struct tag_tos_mem t_tos_mem;
	struct tag_ram_partition t_ram_param;
	struct tag_atf_mem t_atf_mem;

	memset(&t_serial,  0x1, sizeof(t_serial));
	memset(&t_bootdev, 0x2, sizeof(t_bootdev));
	memset(&t_ddr_mem, 0x3, sizeof(t_ddr_mem));
	memset(&t_tos_mem, 0x4, sizeof(t_tos_mem));
	memset(&t_ram_param, 0x0, sizeof(t_ram_param));
	memset(&t_atf_mem, 0x5, sizeof(t_atf_mem));

	memcpy(&t_tos_mem.tee_mem.name, "tee_mem", 8);
	memcpy(&t_tos_mem.drm_mem.name, "drm_mem", 8);

	t_ram_param.count = 4;
	memcpy(&t_ram_param.part[0].name, "misc", 9);
	t_ram_param.part[0].start = 0x00600000;
	t_ram_param.part[0].size =  0x00200000;

	memcpy(&t_ram_param.part[1].name, "resource", 9);
	t_ram_param.part[1].start = 0x00800000;
	t_ram_param.part[1].size =  0x00200000;

	memcpy(&t_ram_param.part[2].name, "kernel", 7);
	t_ram_param.part[2].start = 0x00a00000;
	t_ram_param.part[2].size =  0x02000000;

	memcpy(&t_ram_param.part[3].name, "boot", 5);
	t_ram_param.part[3].start = 0x04000000;
	t_ram_param.part[3].size =  0x02000000;

	/* First pre-loader must call it before atags_set_tag() */
	atags_destroy();

	atags_set_tag(ATAG_SERIAL,  &t_serial);
	atags_set_tag(ATAG_BOOTDEV, &t_bootdev);
	atags_set_tag(ATAG_DDR_MEM, &t_ddr_mem);
	atags_set_tag(ATAG_TOS_MEM, &t_tos_mem);
	atags_set_tag(ATAG_RAM_PARTITION, &t_ram_param);
	atags_set_tag(ATAG_ATF_MEM, &t_atf_mem);

	atags_print_all_tags();
	atags_stat();
}

static int dump_atags(cmd_tbl_t *cmdtp, int flag,
		      int argc, char * const argv[])
{
	atags_print_all_tags();
	return 0;
}

U_BOOT_CMD(
	atags, 1, 1, dump_atags,
	"Dump the content of the atags",
	""
);
#else
void inline atags_print_tag(struct tag *t) {}
void inline atags_print_all_tags(void) {}
void inline atags_test(void) {}
void atags_stat(void) {};
#endif
