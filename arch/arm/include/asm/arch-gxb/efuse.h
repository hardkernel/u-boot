
/*
 * arch/arm/include/asm/arch-gxb/efuse.h
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

#ifndef __EFUSE_H
#define __EFUSE_H

#include <config.h>
#include <common.h>

typedef struct efuseinfo_item{
	char title[40];
	unsigned offset;    // write offset
	unsigned enc_len;
	unsigned data_len;
	int we;    // write enable
} efuseinfo_item_t;

typedef struct efuseinfo{
	struct efuseinfo_item *efuseinfo_version;
	int size;
	int version;
}efuseinfo_t;

typedef int (*pfn) (char *title, efuseinfo_item_t *info);
typedef int(*pfn_byPos)(unsigned pos, efuseinfo_item_t *info);

//char *efuse_dump(void);
unsigned efuse_readcustomerid(void);
int efuse_set_versioninfo(efuseinfo_item_t *info);

int efuse_getinfo(char *title, efuseinfo_item_t *info);
int efuse_read_usr(char *buf, size_t count, loff_t *ppos);
int efuse_write_usr(char* buf, size_t count, loff_t* ppos);

/*EFUSE_BYTES,EFUSE_DWORDS move to cpu.h in arch/arm/include/asm/arch-mxx/cpu.h */
// for m6 and after efuse length
#define EFUSE_BYTES				512   //(EFUSE_BITS/8)
//#define EFUSE_DWORDS		128   //(EFUSE_BITS/32)

// efuse HAL_API arg
struct efuse_hal_api_arg{
	unsigned int cmd;		// R/W
	unsigned int offset;
	unsigned int size;
	unsigned long buffer_phy;
	unsigned long retcnt_phy;
};

#define EFUSE_HAL_API_READ	0
#define EFUSE_HAL_API_WRITE 1
#define EFUSE_HAL_API_WRITE_PATTERN 2

#define ASSIST_HW_REV                              0x1f53

#endif

