// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <dm.h>
#include <ram.h>
#include <asm/io.h>
#include <asm/arch/rk_atags.h>
#include <asm/arch/param.h>

DECLARE_GLOBAL_DATA_PTR;

#if !defined(CONFIG_SPL_BUILD) && !defined(CONFIG_TPL_BUILD)
#define SDRAM_OFFSET(offset)		(CONFIG_SYS_SDRAM_BASE + (offset))
#define PARAM_DRAM_INFO_OFFSET		(SZ_32M)
#define PARAM_OPTEE_INFO_OFFSET		(SZ_32M + SZ_2M)

struct tos_param_t {
	u32 version;
	u32 checksum;
	struct {
		char name[8];
		s64 phy_addr;
		u32 size;
		u32 flags;
	} tee_mem;
	struct {
		char name[8];
		s64 phy_addr;
		u32 size;
		u32 flags;
	} drm_mem;
	s64 reserve[8];
};

static uint16_t trust_checksum(const uint8_t *buf, uint16_t len)
{
	uint16_t i, checksum = 0;

	for (i = 0; i < len; i++) {
		if (i % 2)
			checksum += buf[i] << 8;
		else
			checksum += buf[i];
	}
	checksum = ~checksum;

	return checksum;
}

struct memblock param_parse_atf_mem(void)
{
	struct memblock mem;

	mem.base = 0;
	mem.size = 0;

#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	struct tag *t = NULL;

	/*
	 * Get memory region of ATF
	 *
	 * 1. New way: atags info;
	 * 2. Leagcy way: 2MB size and start from ddr 0x0 offset;
	 */
	t = atags_get_tag(ATAG_ATF_MEM);
	if (t && t->u.atf_mem.size) {
		mem.base = t->u.atf_mem.phy_addr;
		mem.size = t->u.atf_mem.size;
		/* Sanity */
		if (mem.base + mem.size > SDRAM_OFFSET(SZ_1M)) {
			printf("%s: ATF reserved region is not within 0-1MB "
			       "offset(0x%08llx-0x%08llx)!\n",
			       __func__, (u64)mem.base, (u64)mem.base + mem.size);
			return mem;
		}
	}
#endif

	/* Legacy */
	if (!mem.size) {
		if (IS_ENABLED(CONFIG_ARM64) ||
		    IS_ENABLED(CONFIG_ARM64_BOOT_AARCH32)) {
			mem.base = SDRAM_OFFSET(0);
			mem.size = SZ_1M;
		}
	}

	debug("ATF: 0x%llx - 0x%llx\n", (u64)mem.base, (u64)mem.base + mem.size);

	return mem;
}

struct memblock param_parse_optee_mem(void)
{
	struct tos_param_t *tos_parameter;
	struct memblock mem;
	u32 checksum;

	mem.base = 0;
	mem.size = 0;

#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	struct tag *t = NULL;

	/*
	 * Get memory region of OP-TEE
	 *
	 * 1. New way: atags info;
	 * 2. Leagcy way: info in ddr 34M offset;
	 */
	t = atags_get_tag(ATAG_TOS_MEM);
	if (t && (t->u.tos_mem.tee_mem.flags == 1)) {
		mem.base = t->u.tos_mem.tee_mem.phy_addr;
		mem.size = t->u.tos_mem.tee_mem.size;
	}
#endif

	/* Legacy */
	if (!mem.size) {
		tos_parameter =
		(struct tos_param_t *)(SDRAM_OFFSET(PARAM_OPTEE_INFO_OFFSET));
		checksum =
		trust_checksum((uint8_t *)(unsigned long)tos_parameter + 8,
			       sizeof(struct tos_param_t) - 8);
		if ((checksum == tos_parameter->checksum) &&
		    (tos_parameter->tee_mem.flags == 1)) {
			mem.base = tos_parameter->tee_mem.phy_addr;
			mem.size = tos_parameter->tee_mem.size;
		}
	}

	if (mem.size)
		gd->flags |= GD_FLG_BL32_ENABLED;

	debug("TOS: 0x%llx - 0x%llx\n", (u64)mem.base, (u64)mem.base + mem.size);

	return mem;
}

struct memblock param_parse_common_resv_mem(void)
{
	struct memblock mem;

#ifdef CONFIG_ARM64
	mem.base = SDRAM_OFFSET(SZ_1M);
	mem.size = SZ_1M;
#else
	mem.size = 0;
#endif
	return mem;
}

int param_parse_bootdev(char **devtype, char **devnum)
{
#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	struct tag *t;

	t = atags_get_tag(ATAG_BOOTDEV);
	if (t) {
		switch (t->u.bootdev.devtype) {
		case BOOT_TYPE_EMMC:
			*devtype = "mmc";
			*devnum = "0";
			break;
		case BOOT_TYPE_SD0:
		case BOOT_TYPE_SD1:
			*devtype = "mmc";
			*devnum = "1";
			break;
		case BOOT_TYPE_NAND:
			*devtype = "rknand";
			*devnum = "0";
			break;
		case BOOT_TYPE_SPI_NAND:
			*devtype = "spinand";
			*devnum = "0";
			break;
		case BOOT_TYPE_SPI_NOR:
			*devtype = "spinor";
			*devnum = "1";
			break;
		case BOOT_TYPE_RAM:
			*devtype = "ramdisk";
			*devnum = "0";
			break;
		default:
			printf("Unknown bootdev type: 0x%x\n",
			       t->u.bootdev.devtype);
			return -EINVAL;
		}

		return 0;
	}
#endif

	return -ENOSYS;
}
#endif

struct memblock *param_parse_ddr_mem(int *out_count)
{
	struct udevice *dev;
	struct memblock *mem;
	struct ram_info ram;
	int i, ret, count;

	/*
	 * Get memory region of DDR
	 *
	 * 1. New: atags info;
	 * 2. Leagcy: os register;
	 */
#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	struct tag *t;

	t = atags_get_tag(ATAG_DDR_MEM);
	if (t && t->u.ddr_mem.count) {
		count = t->u.ddr_mem.count;
		mem = calloc(count, sizeof(*mem));
		if (!mem) {
			printf("Calloc ddr memory failed\n");
			return 0;
		}

		for (i = 0; i < count; i++) {
			mem[i].base = t->u.ddr_mem.bank[i];
			mem[i].size = t->u.ddr_mem.bank[i + count];
		}

		*out_count = count;
		return mem;
	}
#endif

	/* Leagcy */
	ret = uclass_get_device(UCLASS_RAM, 0, &dev);
	if (ret) {
		debug("DRAM init failed: %d\n", ret);
		return NULL;
	}
	ret = ram_get_info(dev, &ram);
	if (ret) {
		debug("Cannot get DRAM size: %d\n", ret);
		return NULL;
	}

	debug("SDRAM base=%lx, size=%lx\n",
	      (unsigned long)ram.base, (unsigned long)ram.size);

	count = 1;
	mem = calloc(1, sizeof(*mem));
	if (!mem) {
		printf("Calloc ddr memory failed\n");
		return 0;
	}

	for (i = 0; i < count; i++) {
		mem[i].base = CONFIG_SYS_SDRAM_BASE;
		mem[i].size = ram.size;
	}

	*out_count = count;
	return mem;
}
