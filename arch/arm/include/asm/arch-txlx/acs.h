
/*
 * arch/arm/include/asm/arch-txl/acs.h
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

#ifndef __ACS_H
#define __ACS_H

#ifndef __ASSEMBLY__
struct acs_setting{
		char				acs_magic[5];	//acs setting magic word, make sure this piece of data was right.
		unsigned char		chip_type;		//chip type
		unsigned short		version;		//version of acs_setting struct, for PC tool use.
		unsigned long		acs_set_length;	//length of current struct.

		//ddr setting part, 16 bytes
		char				ddr_magic[5];		//magic word to indicate that following 12 bytes was ddr setting.
		unsigned char		ddr_set_version;	//struct version, for PC tool use.
		unsigned short		ddr_set_length;		//length of ddr struct.
		unsigned long		ddr_set_addr;		//address of ddr setting.

		//ddr timing part, 16 bytes
		char				ddrt_magic[5];
		unsigned char		ddrt_set_version;
		unsigned short		ddrt_set_length;
		unsigned long		ddrt_set_addr;

		char				pll_magic[5];
		unsigned char		pll_set_version;
		unsigned short		pll_set_length;
		unsigned long		pll_set_addr;
}__attribute__ ((packed));

#endif
#endif
