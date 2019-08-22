/*
 * Copyright (c) 2013, Google Inc.
 *
 * Copyright (C) 2011
 * Corscience GmbH & Co. KG - Simon Schwarz <schwarz@corscience.de>
 *  - Added prep subcommand support
 *  - Reorganized source - modeled after powerpc version
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Marius Groeger <mgroeger@sysgo.de>
 *
 * Copyright (C) 2001  Erik Mouw (J.A.K.Mouw@its.tudelft.nl)
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <fdt_support.h>
#include <asm/armv7.h>
#if defined(CONFIG_ODROID_COMMON)
#include <asm/io.h>
#include <asm/arch/secure_apb.h>

#if (CONFIG_NR_DRAM_BANKS > 1)
#error CONFIG_NR_DRAM_BANKS must be 1 to set descent memory size
#endif
#endif

DECLARE_GLOBAL_DATA_PTR;

int arch_fixup_fdt(void *blob)
{
	bd_t *bd = gd->bd;
	int bank, ret;
	u64 start[CONFIG_NR_DRAM_BANKS];
	u64 size[CONFIG_NR_DRAM_BANKS];

	for (bank = 0; bank < CONFIG_NR_DRAM_BANKS; bank++) {
		start[bank] = bd->bi_dram[bank].start;
		size[bank] = bd->bi_dram[bank].size;
	}

#if defined(CONFIG_ODROID_COMMON)
	/*
	 * Since DRAM exceeds 3584MiB cannot be handled by U-boot due to cache problem,
	 * available memory is limited to 3584MiB for the board with 4096MiB DRAM.
	 * In order to use the rest of the memory, the memory size must be fixed to be
	 * appended to the device tree with decent memory size.
	 */
#if defined(CONFIG_SYS_MEM_TOP_HIDE)
	size[0] = (((readl(AO_SEC_GP_CFG0)) & 0xFFFF0000) << 4) - CONFIG_SYS_MEM_TOP_HIDE;
#else
	size[0] = (((readl(AO_SEC_GP_CFG0)) & 0xFFFF0000) << 4);
#endif
#endif

	ret = fdt_fixup_memory_banks(blob, start, size, CONFIG_NR_DRAM_BANKS);
#if defined(CONFIG_ARMV7_NONSEC) || defined(CONFIG_ARMV7_VIRT)
	if (ret)
		return ret;

	ret = armv7_update_dt(blob);
#endif
	return ret;
}
