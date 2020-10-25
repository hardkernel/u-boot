// SPDX-License-Identifier:     GPL-2.0+
/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd.
 *
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/bootrom.h>
#include <asm/arch/rk_atags.h>
#if CONFIG_IS_ENABLED(TINY_FRAMEWORK)
#include <debug_uart.h>
#endif

#define HASH_LEN	sizeof(u32)
#define tag_next(t)	((struct tag *)((u32 *)(t) + (t)->hdr.size))
#define tag_size(type)	((sizeof(struct tag_header) + sizeof(struct type)) >> 2)
#define for_each_tag(t, base)		\
	for (t = base; t->hdr.size; t = tag_next(t))

#if defined(CONFIG_SPL_BUILD) && !defined(CONFIG_TPL_BUILD)
/*
 * The array is used to transform rom bootsource type to rk atags boot type.
 */
static int bootdev_map[] = {
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_NAND,
	BOOT_TYPE_EMMC,
	BOOT_TYPE_SPI_NOR,
	BOOT_TYPE_SPI_NAND,
	BOOT_TYPE_SD0,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN
};

static int spl_bootdev_map[] = {
	BOOT_TYPE_RAM,
	BOOT_TYPE_EMMC,
	BOOT_TYPE_SD0,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_NAND,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_UNKNOWN,
	BOOT_TYPE_MTD_BLK_NAND,
	BOOT_TYPE_MTD_BLK_SPI_NAND,
	BOOT_TYPE_MTD_BLK_SPI_NOR
};
#endif

#if CONFIG_IS_ENABLED(TINY_FRAMEWORK) &&		\
	!CONFIG_IS_ENABLED(LIBGENERIC_SUPPORT) &&	\
	!CONFIG_IS_ENABLED(USE_ARCH_MEMSET)
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
#endif

#if CONFIG_IS_ENABLED(TINY_FRAMEWORK) &&		\
	!CONFIG_IS_ENABLED(LIBGENERIC_SUPPORT) &&	\
	!CONFIG_IS_ENABLED(USE_ARCH_MEMCPY)
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

static u32 js_hash(void *buf, u32 len)
{
	u32 i, hash = 0x47C6A7E6;
	char *data = buf;

	if (!buf || !len)
		return hash;

	for (i = 0; i < len; i++)
		hash ^= ((hash << 5) + data[i] + (hash >> 2));

	return hash;
}

static int bad_magic(u32 magic)
{
	bool bad;

	bad = ((magic != ATAG_CORE) &&
	       (magic != ATAG_NONE) &&
	       (magic < ATAG_SERIAL || magic > ATAG_MAX));
	if (bad) {
#if !CONFIG_IS_ENABLED(TINY_FRAMEWORK)
		printf("Magic(%x) is not support\n", magic);
#else
		printascii("Magic is not support\n");
#endif
	}

	return bad;
}

static int inline atags_size_overflow(struct tag *t, u32 tag_size)
{
	return (unsigned long)t + (tag_size << 2) - ATAGS_PHYS_BASE > ATAGS_SIZE;
}

static int atags_overflow(struct tag *t)
{
	bool overflow;

	overflow = atags_size_overflow(t, 0) ||
		   atags_size_overflow(t, t->hdr.size);
	if (overflow) {
#if !CONFIG_IS_ENABLED(TINY_FRAMEWORK)
		printf("Tag is overflow\n");
#else
		printascii("Tag is overflow\n");
#endif
	}

	return overflow;
}

int atags_is_available(void)
{
	struct tag *t = (struct tag *)ATAGS_PHYS_BASE;

	return (t->hdr.magic == ATAG_CORE);
}

int atags_set_tag(u32 magic, void *tagdata)
{
	u32 length, size = 0, hash;
	struct tag *t = (struct tag *)ATAGS_PHYS_BASE;

#if !defined(CONFIG_TPL_BUILD) && !defined(CONFIG_FPGA_ROCKCHIP)
	if (!atags_is_available())
		return -EPERM;
#endif

	if (!tagdata)
		return -ENODATA;

	if (bad_magic(magic))
		return -EINVAL;

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
			if (atags_overflow(t))
				return -EINVAL;

			if (bad_magic(t->hdr.magic))
				return -EINVAL;

			/* This is an old tag, override it */
			if (t->hdr.magic == magic)
				break;

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
	case ATAG_PUB_KEY:
		size = tag_size(tag_pub_key);
		break;
	case ATAG_SOC_INFO:
		size = tag_size(tag_soc_info);
		break;
	};

	if (!size)
		return -EINVAL;

	if (atags_size_overflow(t, size))
		return -ENOMEM;

	/* It's okay to setup a new tag */
	t->hdr.magic = magic;
	t->hdr.size = size;
	length = (t->hdr.size << 2) - sizeof(struct tag_header) - HASH_LEN;
	memcpy(&t->u, (char *)tagdata, length);
	hash = js_hash(t, (size << 2) - HASH_LEN);
	memcpy((char *)&t->u + length, &hash, HASH_LEN);

	/* Next tag */
	t = tag_next(t);

	/* Setup done */
	t->hdr.magic = ATAG_NONE;
	t->hdr.size = 0;

	return 0;
}

#ifndef CONFIG_TPL_BUILD
struct tag *atags_get_tag(u32 magic)
{
	u32 *hash, calc_hash, size;
	struct tag *t;

	if (!atags_is_available())
		return NULL;

	for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
		if (atags_overflow(t))
			return NULL;

		if (bad_magic(t->hdr.magic))
			return NULL;

		if (t->hdr.magic != magic)
			continue;

		size = t->hdr.size;
		hash = (u32 *)((ulong)t + (size << 2) - HASH_LEN);
		if (!*hash) {
			debug("No hash, magic(%x)\n", magic);
			return t;
		} else {
			calc_hash = js_hash(t, (size << 2) - HASH_LEN);
			if (calc_hash == *hash) {
				debug("Hash okay, magic(%x)\n", magic);
				return t;
			} else {
				debug("Hash bad, magic(%x), orgHash=%x, nowHash=%x\n",
				      magic, *hash, calc_hash);
				return NULL;
			}
		}
	}

	return NULL;
}
#else
struct tag *atags_get_tag(u32 magic) { return NULL; }
#endif

#if defined(CONFIG_SPL_BUILD) && !defined(CONFIG_TPL_BUILD)
int get_bootdev_by_brom_bootsource(void)
{
	int bootsource = 0;

	bootsource = readl(BROM_BOOTSOURCE_ID_ADDR);
	if (bootsource > ARRAY_SIZE(bootdev_map) - 1 || bootsource < 0)
		return 0;
	else
		return bootdev_map[bootsource];
}

int atags_set_bootdev_by_brom_bootsource(void)
{
	struct tag_bootdev boot_dev;

	memset(&boot_dev, 0, sizeof(struct tag_bootdev));
	boot_dev.devtype = get_bootdev_by_brom_bootsource();

	return atags_set_tag(ATAG_BOOTDEV, &boot_dev);
}

int get_bootdev_by_spl_bootdevice(int bootdevice)
{
	if (bootdevice > ARRAY_SIZE(spl_bootdev_map) - 1)
		return -ENODEV;

	return spl_bootdev_map[bootdevice];
}

int atags_set_bootdev_by_spl_bootdevice(int bootdevice)
{
	struct tag_bootdev boot_dev;

	memset(&boot_dev, 0, sizeof(struct tag_bootdev));
	boot_dev.devtype = get_bootdev_by_spl_bootdevice(bootdevice);
	if (boot_dev.devtype < 0)
		boot_dev.devtype = BOOT_TYPE_UNKNOWN;

	return atags_set_tag(ATAG_BOOTDEV, &boot_dev);
}
#endif

void atags_destroy(void)
{
	if (atags_is_available())
		memset((char *)ATAGS_PHYS_BASE, 0, sizeof(struct tag));
}

#ifndef CONFIG_SPL_BUILD
void atags_stat(void)
{
	u32 start = ATAGS_PHYS_BASE, end = ATAGS_PHYS_BASE + ATAGS_SIZE;
	u32 in_use = 0, in_available = 0;
	struct tag *t;

	if (!atags_is_available())
		return;

	for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
		if (atags_overflow(t))
			return;

		if (bad_magic(t->hdr.magic))
			return;

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
		printf("      hash = 0x%x\n", t->u.serial.hash);
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
		printf("      hash = 0x%x\n", t->u.bootdev.hash);
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
		printf("     res1 = 0x%x\n", t->u.tos_mem.reserved1);
		printf("     hash = 0x%x\n", t->u.tos_mem.hash);
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
		printf("      hash = 0x%x\n", t->u.ddr_mem.hash);
		break;
	case ATAG_RAM_PARTITION:
		printf("[ram_partition]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("   version = 0x%x\n", t->u.ram_part.version);
		printf("     count = 0x%x\n", t->u.ram_part.count);
		for (i = 0; i < ARRAY_SIZE(t->u.ram_part.reserved); i++)
			printf("    res[%d] = 0x%x\n", i, t->u.ram_part.reserved[i]);

		printf("    Part:  Name       Start Addr      Size\t\n");
		for (i = 0; i < ARRAY_SIZE(t->u.ram_part.part); i++)
			printf("%16s      0x%08llx      0x%08llx\n",
			       t->u.ram_part.part[i].name,
			       t->u.ram_part.part[i].start,
			       t->u.ram_part.part[i].size);
		for (i = 0; i < ARRAY_SIZE(t->u.ram_part.reserved1); i++)
			printf("   res1[%d] = 0x%x\n", i, t->u.ram_part.reserved1[i]);
		printf("      hash = 0x%x\n", t->u.ram_part.hash);
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
		printf("      hash = 0x%x\n", t->u.atf_mem.hash);
		break;
	case ATAG_PUB_KEY:
		printf("[pub_key_mem]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("   version = 0x%x\n", t->u.pub_key.version);
		printf("      hash = 0x%x\n", t->u.pub_key.hash);
		break;
	case ATAG_SOC_INFO:
		printf("[soc_info]:\n");
		printf("     magic = 0x%x\n", t->hdr.magic);
		printf("      size = 0x%x\n\n", t->hdr.size << 2);
		printf("   version = 0x%x\n", t->u.soc.version);
		printf("      name = 0x%x\n", t->u.soc.name);
		printf("     flags = 0x%x\n", t->u.soc.flags);
		for (i = 0; i < ARRAY_SIZE(t->u.soc.reserved); i++)
			printf("    res[%d] = 0x%x\n", i, t->u.soc.reserved[i]);
		printf("      hash = 0x%x\n", t->u.soc.hash);
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

	if (!atags_is_available())
		return;

	for_each_tag(t, (struct tag *)ATAGS_PHYS_BASE) {
		if (atags_overflow(t))
			return;

		if (bad_magic(t->hdr.magic))
			return;

		atags_print_tag(t);
	}
}

static int do_dump_atags(cmd_tbl_t *cmdtp, int flag,
			 int argc, char * const argv[])
{
	atags_print_all_tags();
	atags_stat();

	return 0;
}

U_BOOT_CMD(
	dump_atags, 1, 1, do_dump_atags,
	"Dump the content of the atags",
	""
);
#endif
