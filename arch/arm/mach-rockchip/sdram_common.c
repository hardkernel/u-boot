/*
 * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <ram.h>
#include <asm/io.h>
#include <asm/arch/param.h>
#include <asm/arch/rk_atags.h>
#include <asm/arch/sdram_common.h>
#include <dm/uclass-internal.h>

DECLARE_GLOBAL_DATA_PTR;
#define PARAM_DRAM_INFO_OFFSET 0x2000000
#define TRUST_PARAMETER_OFFSET    (34 * 1024 * 1024)

#if defined(CONFIG_SPL_FRAMEWORK) || !defined(CONFIG_SPL_OF_PLATDATA)

#define SDRAM_OFFSET(offset)	(CONFIG_SYS_SDRAM_BASE + (offset))
#define NOT_INITIAL		-1
static int __dram_init_banksize(int resv_tee)
{
	struct sysmem_property prop;
	size_t top = min((unsigned long)(gd->ram_size + CONFIG_SYS_SDRAM_BASE),
			 gd->ram_top);
	u64 start[CONFIG_NR_DRAM_BANKS], size[CONFIG_NR_DRAM_BANKS];
	u64 tos_addr, atf_addr;
	u64 tos_size, atf_size;
	int i, idx = NOT_INITIAL;

	prop = param_parse_atf_mem();
	atf_addr = prop.base;
	atf_size = prop.size;
	prop = param_parse_optee_mem();
	tos_addr = prop.base;
	tos_size = prop.size;

	/*
	 * Reserve region for ATF bl31
	 *
	 * What ever U-Boot runs on AArch64 or AArch32 mode, the bl31 is always
	 * present and AArch64 mode, let's reserve it.
	 *
	 * Maybe:
	 *	1. ATF region is from 0x0 offset and 1MB size(legacy);
	 *	2. ATF region is from 0x0 offset but not 1MB size;
	 *	3. ATF region is not from 0x0 offset but within 1MB;
	 *
	 * 1. The "*****" means visible region to kernel.
	 * 2. 1M~2M is always reserved in ARM64 for pstore, shmem, etc.
	 *
	 *
	 * Possible memory layout:
	 *
	 * Leagcy:
	 *	 |------------o-------o------------------------|
	 *	 |     ATF    | RES   |************************|
	 *	 |------------o-------o------------------------|
	 *	 0x0          1M      2M                      .....
	 *
	 *
	 * New:
	 *	 |-----|------o-------o------------------------|
	 *	 | ATF |******| RES   |************************|
	 *	 |-----|------o-------o------------------------|
	 *	 0x0          1M      2M                      .....
	 *
	 *
	 *	 |----|---|---o-------o------------------------|
	 *	 |****|ATF|***| RES   |************************|
	 *	 |----|---|---o-------o------------------------|
	 *	 0x0  64K     1M      2M                      .....
	 *
	 * Note: these are only initilized once from dram_init_banksize(),
	 *       which is before relocation.
	 */
	if (atf_size && !(gd->flags & GD_FLG_RELOC)) {
		idx = 0;
		memset(size, 0, sizeof(size));

		start[0] = SDRAM_OFFSET(0);
		 size[0] = atf_addr - start[0];
		start[1] = atf_addr + atf_size;
		 size[1] = SDRAM_OFFSET(SZ_1M) - start[1];
		start[2] = SDRAM_OFFSET(SZ_2M);
		 size[2] = top - start[2];

		for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
			if (!size[i])
				continue;

			gd->bd->bi_dram[idx].start = start[i];
			gd->bd->bi_dram[idx].size = size[i];
			idx++;
		}
	/* There is no bl31, fill whole ram size */
	} else if (!(gd->flags & GD_FLG_RELOC)) {
		gd->bd->bi_dram[0].start = SDRAM_OFFSET(0);
		gd->bd->bi_dram[0].size = top - gd->bd->bi_dram[0].start;
	} else {
		/*
		 * Do nothing for bl31 when called from dram_initr_banksize(),
		 * which is after relocation.
		 */
	}

	/*
	 * Reserve region for OP-TEE
	 *
	 * What ever U-Boot runs on AArch64 or AArch32 mode, the OP-TEE is
	 * AArch64 mode.
	 *
	 * For OP-TEE:
	 *	AArch64: dcache is enabled;
	 *	AArch32: dcache is disabled(due to some unknown issues);
	 *
	 * For the data coherence, U-Boot has to follow the OP-TEE dcache
	 * policy to map MMU attributes of OP-TEE region.
	 *
	 * For AArch64: MMU translate table is created manual by rkxxx.c file
	 * and all memory region is mapped, that's good to match OP-TEE policy.
	 * For AArch32: MMU translate table is setup according to bi_dram[..]
	 * that OP-TEE region has been reserved and would not be mapped,
	 * i.e. dcache is disabled, that's also good to match OP-TEE policy.
	 *
	 * When CONFIG_ARM64_BOOT_AARCH32 is enabled, U-Boot runs on AArch32
	 * while OP-TEE runs on AArch64. U-Boot shouldn't reserved OP-TEE region
	 * too early and should map MMU translate table of it(in intir_cache()).
	 * So we reserve the region in dram_initr_banksize() after MMU setup.
	 *
	 *
	 *	The are two kinds of OP-TEE memory layout
	 *
	 * legacy:
	 * 	|----|-------o---------------------------------|
	 * 	|....| OPTEE |*********************************|
	 * 	|----|-------o---------------------------------|
	 * 	0x0 2M      6M(or more)                 .....
	 *
	 * new:
	 * 	|----|-------------------o-------o-------------|
	 * 	|....|*******************| OPTEE |*************|
	 * 	|----|-------------------o-------o-------------|
	 * 	0x0  2M                132M     164M(or less) .....
	 */

	if (resv_tee && tos_size) {
		/* If idx is not initialized, calculate idx */
		if (idx == NOT_INITIAL) {
			for (idx = 0; idx < CONFIG_NR_DRAM_BANKS; idx++) {
				if (!gd->bd->bi_dram[idx].size)
					break;
			}
		}

		if (tos_addr == SZ_2M) {
			gd->bd->bi_dram[idx - 1].start = tos_addr + tos_size;
			gd->bd->bi_dram[idx - 1].size =
					top - gd->bd->bi_dram[idx - 1].start;
		} else {
			gd->bd->bi_dram[idx - 1].size = tos_addr -
					gd->bd->bi_dram[idx - 1].start;
			gd->bd->bi_dram[idx].start = tos_addr + tos_size;
			gd->bd->bi_dram[idx].size =
					top - gd->bd->bi_dram[idx].start;
		}
#ifdef DEBUG
		for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
			debug("%s: bank[%d]=0x%llx-0x%llx\n",
			      __func__, i, (u64)gd->bd->bi_dram[i].start,
			      (u64)gd->bd->bi_dram[i].start +
			      gd->bd->bi_dram[i].size);
		}
#endif
	}

	return 0;
}

/*
 * !defined(CONFIG_ARM64_BOOT_AARCH32) means: U-Boot and OP-TEE both run
 * on AArch32 or AArch64, they are same mode. Otherwise OP-TEE is AArch64
 * while U-Boot is AArch32. There is data cache coherence issue to fix.
 */
int dram_init_banksize(void)
{
	return __dram_init_banksize(!IS_ENABLED(CONFIG_ARM64_BOOT_AARCH32));
}

int dram_initr_banksize(void)
{
	return __dram_init_banksize(IS_ENABLED(CONFIG_ARM64_BOOT_AARCH32));
}
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

static unsigned int get_ddr_os_reg(void)
{
	u32 os_reg = 0;

#if defined(CONFIG_ROCKCHIP_PX30)
	os_reg = readl(0xff010208);
#elif defined(CONFIG_ROCKCHIP_RK3328)
	os_reg = readl(0xff1005d0);
#elif defined(CONFIG_ROCKCHIP_RK3399)
	os_reg = readl(0xff320308);
#elif defined(CONFIG_ROCKCHIP_RK322X)
	os_reg = readl(0x110005d0);
#elif defined(CONFIG_ROCKCHIP_RK3368)
	os_reg = readl(0xff738208);
#elif defined(CONFIG_ROCKCHIP_RK3288)
	os_reg = readl(0x20004048);
#elif defined(CONFIG_ROCKCHIP_RK3036)
	os_reg = readl(0x200081cc);
#elif defined(CONFIG_ROCKCHIP_RK3308)
	os_reg = readl(0xff000508);
#elif defined(CONFIG_ROCKCHIP_RK1808)
	os_reg = readl(0xfe020208);
#else
	printf("unsupported chip type, get page size fail\n");
#endif

	return os_reg;
}

unsigned int get_page_size(void)
{
	u32 os_reg;
	u32 col, bw;
	int page_size;

	os_reg = get_ddr_os_reg();
	if (!os_reg)
		return 0;

	col = 9 + (os_reg >> SYS_REG_COL_SHIFT(0) & SYS_REG_COL_MASK);
	bw = (2 >> ((os_reg >> SYS_REG_BW_SHIFT(0)) & SYS_REG_BW_MASK));
	page_size = 1u << (col + bw);

	return page_size;
}

unsigned int get_ddr_bw(void)
{
	u32 os_reg;
	u32 bw = 2;

	os_reg = get_ddr_os_reg();
	if (os_reg)
		bw = 2 >> ((os_reg >> SYS_REG_BW_SHIFT(0)) & SYS_REG_BW_MASK);
	return bw;
}

#if defined(CONFIG_SPL_FRAMEWORK) || !defined(CONFIG_SPL_OF_PLATDATA)
int dram_init(void)
{
	struct ram_info ram;
	struct udevice *dev;
	int ret;

	/* New way: atags info */
#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	struct tag *t = NULL;
	int i, count;

	t = atags_get_tag(ATAG_DDR_MEM);
	if (t && t->u.ddr_mem.count) {
		gd->ram_size = 0;
		count = t->u.ddr_mem.count;

		for (i = 0; i < count; i++) {
			gd->ram_size += t->u.ddr_mem.bank[i + count];
			debug("%s: ram[%d] start=0x%08llx, size=0x%08llx, sum=0x%08llx\n",
			      __func__, i, (u64)gd->bd->bi_dram[i].start,
			      (u64)gd->bd->bi_dram[i].size, (u64)gd->ram_size);
		}

		return 0;
	}
#endif

	/* Legacy way: os registers */
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

int rockchip_setup_ddr_param(struct ddr_param *info)
{
	u32 i;
	struct ddr_param *dinfo = (struct ddr_param *)(CONFIG_SYS_SDRAM_BASE +
					PARAM_DRAM_INFO_OFFSET);

	dinfo->count = info->count;
	for (i = 0; i < (info->count * 2); i++)
		dinfo->para[i] = info->para[i];

	return 0;
}
