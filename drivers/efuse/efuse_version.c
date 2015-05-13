
/*
 * drivers/efuse/efuse_version.c
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

#include <config.h>
#include <asm/arch/efuse.h>
#include "efuse_regs.h"

/** efuse layout
http://wiki-sh.amlogic.com/index.php/How_To_burn_the_info_into_E-Fuse
0~3					licence					1 check byte				4 bytes(in total)
4~10				mac						1 check byte				7 bytes(in total)
12~322			hdcp					10 check byte				310 bytes(in total)
322~328 			mac_bt				1 check byte				7 bytes(in total)
330~336 			mac_wifi				1 check byte				7 bytes(in total)
337~384  		usid						2 check byte		 		48 bytes(in total)
*/

/**
 * efuse version 0.2 (after M6 )
*/
/**
0~2					licence					3bytes ( some basic feature control)
3						version 				1byte  ( must be 2)
4~7					customerid			4bytes (0 , keep , should not be 0)
8~135				rsa key					128bytes (if Secure Boot enable )
136~435			hdcp 					300bytes
436~441			mac0					6bytes for the main network interface
442~447			mac1					6bytes for the second network interface or bt
448~453			mac2					6bytes for the second network interface or bt
454~511			userid 					58bytes (not used)
*/

/* efuse gxbaby
0~319      amlogic        320byte
320~511		 user           192byte
*/

/*gxbb efuse layout*/
static efuseinfo_item_t efuseinfo_gxbb_v1[] =
{
	{
		.title = "user",
		.offset = 320,
		.enc_len = 192,
		.data_len = 192,
		.we = 1,
	},
	{
		.title = "version",
		.offset = GXBB_EFUSE_VERSION_OFFSET, //509
		.enc_len = GXBB_EFUSE_VERSION_ENC_LEN, //1
		.data_len = GXBB_EFUSE_VERSION_DATA_LEN,//1
		.we = 1,
	},
};


efuseinfo_t efuseinfo[] =
{
	{
		.efuseinfo_version = efuseinfo_gxbb_v1,
		.size = sizeof(efuseinfo_gxbb_v1)/sizeof(efuseinfo_gxbb_v1),
		.version = GXBB_EFUSE_VERSION_SERIALNUM_V1,
	},
};

int efuseinfo_num = sizeof(efuseinfo)/sizeof(efuseinfo_t);
int efuse_active_version = -1;
unsigned efuse_active_customerid = 0;
pfn efuse_getinfoex = 0;
pfn_byPos efuse_getinfoex_byPos=0;

