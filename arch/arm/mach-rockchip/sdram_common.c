/*
 * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <ram.h>
#include <asm/io.h>
#include <asm/arch/sdram_common.h>
#include <dm/uclass-internal.h>

DECLARE_GLOBAL_DATA_PTR;
struct ddr_param{
	u32 count;
	u32 reserved;
	u64 bank_addr;
	u64 bank_size;
};
#define PARAM_DRAM_INFO_OFFSET 0x2000000

#define TRUST_PARAMETER_OFFSET    (34 * 1024 * 1024)

struct tos_parameter_t {
	u32 version;
	u32 checksum;
	struct {
		char name[8];
		s64 phy_addr;
		u32 size;
		u32 flags;
	}tee_mem;
	struct {
		char name[8];
		s64 phy_addr;
		u32 size;
		u32 flags;
	}drm_mem;
	s64 reserve[8];
};

#if defined(CONFIG_SPL_FRAMEWORK) || !defined(CONFIG_SPL_OF_PLATDATA)
static uint16_t trust_checksum(const uint8_t *buf, uint16_t len)
{
	uint16_t i;
	uint16_t checksum = 0;

	for (i = 0; i < len; i++) {
		if (i % 2)
			checksum += buf[i] << 8;
		else
			checksum += buf[i];
	}
	checksum = ~checksum;

	return checksum;
}

int dram_init_banksize(void)
{
	size_t top = min((unsigned long)(gd->ram_size + CONFIG_SYS_SDRAM_BASE),
			 gd->ram_top);
	struct tos_parameter_t *tos_parameter;
	u32 checksum __maybe_unused;

	tos_parameter = (struct tos_parameter_t *)(CONFIG_SYS_SDRAM_BASE +
			TRUST_PARAMETER_OFFSET);

	checksum = trust_checksum((uint8_t *)(unsigned long)tos_parameter + 8,
				  sizeof(struct tos_parameter_t) - 8);

#if defined(CONFIG_ARM64) || defined(CONFIG_ARM64_BOOT_AARCH32)
	/* Reserve 0x200000 for ATF bl31 */
	gd->bd->bi_dram[0].start = CONFIG_SYS_SDRAM_BASE + 0x200000;
#else
	gd->bd->bi_dram[0].start = CONFIG_SYS_SDRAM_BASE;
#endif
	gd->bd->bi_dram[0].size = top - gd->bd->bi_dram[0].start;

/*
 * OP-TEE:
 *	ARM64(AArch32) 64-bit: enable dcache; (U-boot: map region dcache cachable)
 *	ARM 32-bit: disable dcache; (U-boot: map region dcache off)
 */

#if !defined(CONFIG_ARM64_BOOT_AARCH32)
	if ((checksum == tos_parameter->checksum) &&
	    (tos_parameter->tee_mem.flags == 1)) {
		gd->bd->bi_dram[0].size = tos_parameter->tee_mem.phy_addr
					- gd->bd->bi_dram[0].start;
		gd->bd->bi_dram[1].start = tos_parameter->tee_mem.phy_addr +
					tos_parameter->tee_mem.size;
		gd->bd->bi_dram[1].size = top - gd->bd->bi_dram[1].start;
	}
#endif

	return 0;
}

#if defined(CONFIG_ARM64_BOOT_AARCH32)
int dram_initr_banksize(void)
{
	size_t top = min((unsigned long)(gd->ram_size + CONFIG_SYS_SDRAM_BASE),
			 gd->ram_top);
	struct tos_parameter_t *tos_parameter;
	u32 checksum;

	tos_parameter = (struct tos_parameter_t *)(CONFIG_SYS_SDRAM_BASE +
			TRUST_PARAMETER_OFFSET);

	checksum = trust_checksum((uint8_t *)(unsigned long)tos_parameter + 8,
				  sizeof(struct tos_parameter_t) - 8);

	if ((checksum == tos_parameter->checksum) &&
	    (tos_parameter->tee_mem.flags == 1)) {
		gd->bd->bi_dram[0].size = tos_parameter->tee_mem.phy_addr
					- gd->bd->bi_dram[0].start;
		gd->bd->bi_dram[1].start = tos_parameter->tee_mem.phy_addr +
					tos_parameter->tee_mem.size;
		gd->bd->bi_dram[1].size = top - gd->bd->bi_dram[1].start;
	}

	return 0;
}
#endif
#endif

size_t rockchip_sdram_size(phys_addr_t reg)
{
	u32 rank, cs0_col, bk, cs0_row, cs1_row, bw, row_3_4;
	size_t chipsize_mb = 0;
	size_t size_mb = 0;
	u32 ch;
	u32 cs1_col = 0;
	u32 bg = 0;
	u32 dbw, dram_type;
	u32 sys_reg = readl(reg);
	u32 sys_reg1 = readl(reg + 4);
	u32 ch_num = 1 + ((sys_reg >> SYS_REG_NUM_CH_SHIFT)
		       & SYS_REG_NUM_CH_MASK);

	dram_type = (sys_reg >> SYS_REG_DDRTYPE_SHIFT) & SYS_REG_DDRTYPE_MASK;
	debug("%s %x %x\n", __func__, (u32)reg, sys_reg);
	for (ch = 0; ch < ch_num; ch++) {
		rank = 1 + (sys_reg >> SYS_REG_RANK_SHIFT(ch) &
			SYS_REG_RANK_MASK);
		cs0_col = 9 + (sys_reg >> SYS_REG_COL_SHIFT(ch) & SYS_REG_COL_MASK);
		cs1_col = cs0_col;
		bk = 3 - ((sys_reg >> SYS_REG_BK_SHIFT(ch)) & SYS_REG_BK_MASK);
		if ((sys_reg1 >> SYS_REG1_VERSION_SHIFT &
		     SYS_REG1_VERSION_MASK) == 0x2) {
			cs1_col = 9 + (sys_reg1 >> SYS_REG1_CS1_COL_SHIFT(ch) &
				  SYS_REG1_CS1_COL_MASK);
			if (((sys_reg1 >> SYS_REG1_EXTEND_CS0_ROW_SHIFT(ch) &
			    SYS_REG1_EXTEND_CS0_ROW_MASK) << 2) + (sys_reg >>
			    SYS_REG_CS0_ROW_SHIFT(ch) &
			    SYS_REG_CS0_ROW_MASK) == 7)
				cs0_row = 12;
			else
				cs0_row = 13 + (sys_reg >>
					  SYS_REG_CS0_ROW_SHIFT(ch) &
					  SYS_REG_CS0_ROW_MASK) +
					  ((sys_reg1 >>
					  SYS_REG1_EXTEND_CS0_ROW_SHIFT(ch) &
					  SYS_REG1_EXTEND_CS0_ROW_MASK) << 2);
			if (((sys_reg1 >> SYS_REG1_EXTEND_CS1_ROW_SHIFT(ch) &
			    SYS_REG1_EXTEND_CS1_ROW_MASK) << 2) + (sys_reg >>
			    SYS_REG_CS1_ROW_SHIFT(ch) &
			    SYS_REG_CS1_ROW_MASK) == 7)
				cs1_row = 12;
			else
				cs1_row = 13 + (sys_reg >>
					  SYS_REG_CS1_ROW_SHIFT(ch) &
					  SYS_REG_CS1_ROW_MASK) +
					  ((sys_reg1 >>
					  SYS_REG1_EXTEND_CS1_ROW_SHIFT(ch) &
					  SYS_REG1_EXTEND_CS1_ROW_MASK) << 2);
		}
		else {
			cs0_row = 13 + (sys_reg >> SYS_REG_CS0_ROW_SHIFT(ch) &
				SYS_REG_CS0_ROW_MASK);
			cs1_row = 13 + (sys_reg >> SYS_REG_CS1_ROW_SHIFT(ch) &
				SYS_REG_CS1_ROW_MASK);
		}
		bw = (2 >> ((sys_reg >> SYS_REG_BW_SHIFT(ch)) &
			SYS_REG_BW_MASK));
		row_3_4 = sys_reg >> SYS_REG_ROW_3_4_SHIFT(ch) &
			SYS_REG_ROW_3_4_MASK;
		if (dram_type == DDR4) {
			dbw = (sys_reg >> SYS_REG_DBW_SHIFT(ch)) &
				SYS_REG_DBW_MASK;
			bg = (dbw == 2) ? 2 : 1;
		}
		chipsize_mb = (1 << (cs0_row + cs0_col + bk + bg + bw - 20));

		if (rank > 1)
			chipsize_mb += chipsize_mb >> ((cs0_row - cs1_row) +
				       (cs0_col - cs1_col));
		if (row_3_4)
			chipsize_mb = chipsize_mb * 3 / 4;
		size_mb += chipsize_mb;
		if (rank > 1)
			debug("rank %d cs0_col %d cs1_col %d bk %d cs0_row %d\
			       cs1_row %d bw %d row_3_4 %d\n",
			       rank, cs0_col, cs1_col, bk, cs0_row,
			       cs1_row, bw, row_3_4);
		else
			debug("rank %d cs0_col %d bk %d cs0_row %d\
                               bw %d row_3_4 %d\n",
                               rank, cs0_col, bk, cs0_row,
                               bw, row_3_4);
	}

	/* Handle 4GB size, or else size will be 0 after <<20 in 32bit system */
	if (size_mb > (SDRAM_MAX_SIZE >> 20))
		size_mb = (SDRAM_MAX_SIZE >> 20);

	return (size_t)size_mb << 20;
}

#if defined(CONFIG_SPL_FRAMEWORK) || !defined(CONFIG_SPL_OF_PLATDATA)
int dram_init(void)
{
	struct ram_info ram;
	struct udevice *dev;
	int ret;

	ret = uclass_get_device(UCLASS_RAM, 0, &dev);
	if (ret) {
		debug("DRAM init failed: %d\n", ret);
		return ret;
	}
	ret = ram_get_info(dev, &ram);
	if (ret) {
		debug("Cannot get DRAM size: %d\n", ret);
		return ret;
	}
	gd->ram_size = ram.size;
	debug("SDRAM base=%lx, size=%lx\n",
	      (unsigned long)ram.base, (unsigned long)ram.size);

	return 0;
}
#endif

ulong board_get_usable_ram_top(ulong total_size)
{
	unsigned long top = CONFIG_SYS_SDRAM_BASE + SDRAM_MAX_SIZE;

	return (gd->ram_top > top) ? top : gd->ram_top;
}

int rockchip_setup_ddr_param(struct ram_info *info)
{
	struct ddr_param *dinfo = (struct ddr_param *)(CONFIG_SYS_SDRAM_BASE +
					PARAM_DRAM_INFO_OFFSET);

	dinfo->count = 1;
	dinfo->bank_addr = info->base;
	dinfo->bank_size = info->size;

	return 0;
}
