
/*
 * arch/arm/cpu/armv8/txl/firmware/acs/acs.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <asm/arch/acs.h>
#include <asm/arch/timing.h>
#include "timing.c"

//main acs struct
acs_set_t __acs_set={
					.acs_magic		= "acs__",
					.chip_type		= 0x0,
					.version 		= 1,
					.acs_set_length	= sizeof(__acs_set),

					.ddr_magic		= "ddrs_",
					.ddr_set_version= 1,
					.ddr_set_length	= sizeof(__ddr_setting),
					.ddr_set_addr	= (unsigned long)(&__ddr_setting),

					.ddr_reg_magic	= "ddrr_",
					.ddr_reg_version= 1,
					.ddr_reg_length	= sizeof(__ddr_reg),
					.ddr_reg_addr	= (unsigned long)(&__ddr_reg),

					.pll_magic		= "pll__",
					.pll_set_version= 1,
					.pll_set_length	= sizeof(__pll_setting),
					.pll_set_addr	= (unsigned long)(&__pll_setting),

					.sto_magic		= "store",
					.sto_set_version= 1,
					.sto_set_length	= 0,
					.sto_set_addr	= 0,

					.bl2_regs_magic	= "bl2r_",
					.bl2_regs_version = 1,
					.bl2_regs_length = sizeof(__bl2_reg),
					.bl2_regs_addr	= (unsigned long)(&__bl2_reg),

					.rsv_magic		= "rsv0_",
					.rsv_set_version= 1,
					.rsv_set_length	= 0,
					.rsv_set_addr	= 0,
};
