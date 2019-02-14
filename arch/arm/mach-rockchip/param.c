// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/rk_atags.h>
#include <asm/arch/param.h>

DECLARE_GLOBAL_DATA_PTR;

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

struct sysmem_property param_parse_atf_mem(void)
{
	struct sysmem_property prop;

	prop.name = "ATF";
	prop.base = 0;
	prop.size = 0;

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
		prop.base = t->u.atf_mem.phy_addr;
		prop.size = t->u.atf_mem.size;
		/* Sanity */
		if (prop.base + prop.size > SDRAM_OFFSET(SZ_1M)) {
			printf("%s: ATF reserved region is not within 0-1MB "
			       "offset(0x%08llx-0x%08llx)!\n",
			       __func__, (u64)prop.base, (u64)prop.base + prop.size);
			return prop;
		}
	}
#endif

	/* Legacy */
	if (!prop.size) {
		if (IS_ENABLED(CONFIG_ARM64) ||
		    IS_ENABLED(CONFIG_ARM64_BOOT_AARCH32)) {
			prop.base = SDRAM_OFFSET(0);
			prop.size = SZ_1M;
		}
	}

	debug("ATF: 0x%llx - 0x%llx\n", (u64)prop.base, (u64)prop.base + prop.size);

	return prop;
}

struct sysmem_property param_parse_optee_mem(void)
{
	struct tos_param_t *tos_parameter;
	struct sysmem_property prop;
	u32 checksum;

	prop.name = "OP-TEE";
	prop.base = 0;
	prop.size = 0;

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
		prop.base = t->u.tos_mem.tee_mem.phy_addr;
		prop.size = t->u.tos_mem.tee_mem.size;
	}
#endif

	/* Legacy */
	if (!prop.size) {
		tos_parameter =
		(struct tos_param_t *)(SDRAM_OFFSET(PARAM_OPTEE_INFO_OFFSET));
		checksum =
		trust_checksum((uint8_t *)(unsigned long)tos_parameter + 8,
			       sizeof(struct tos_param_t) - 8);
		if ((checksum == tos_parameter->checksum) &&
		    (tos_parameter->tee_mem.flags == 1)) {
			prop.base = tos_parameter->tee_mem.phy_addr;
			prop.size = tos_parameter->tee_mem.size;
		}
	}

	if (prop.size)
		gd->flags |= GD_FLG_BL32_ENABLED;

	debug("TOS: 0x%llx - 0x%llx\n", (u64)prop.base, (u64)prop.base + prop.size);

	return prop;
}

struct sysmem_property param_parse_common_resv_mem(void)
{
	struct sysmem_property prop;

	prop.name = "PSTORE/ATAGS/SHM";
	prop.base = SDRAM_OFFSET(SZ_1M);
	prop.size = SZ_1M;

	return prop;
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
