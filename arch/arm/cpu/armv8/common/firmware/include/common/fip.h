
/*
 * arch/arm/cpu/armv8/common/firmware/include/common/fip.h
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

#include <bl_common.h>
#include <stdint.h>
#include <platform_def.h>
#include <storage.h>
#include <config.h>

#ifndef __BL2_FIP_H_
#define __BL2_FIP_H_

#define NEED_BL32 CONFIG_NEED_BL32
#define NEED_BL301 CONFIG_NEED_BL301

#define TOC_HEADER_NAME             (0xAA640001)
#define TOC_HEADER_SERIAL_NUMBER    (0x12345678)

#define	_UUID_NODE_LEN		6

struct uuid {
	uint32_t	time_low;
	uint16_t	time_mid;
	uint16_t	time_hi_and_version;
	uint8_t		clock_seq_hi_and_reserved;
	uint8_t		clock_seq_low;
	uint8_t		node[_UUID_NODE_LEN];
};

typedef struct uuid uuid_t;

typedef struct fip_toc_header {
	uint32_t	name;
	uint32_t	serial_number;
	uint64_t	flags;
} fip_toc_header_t;

typedef struct fip_toc_entry {
	uuid_t		uuid;
	uint64_t	offset;
	uint64_t	size;
	uint64_t	flags;
} fip_toc_entry_t;

/*amlogic fip structure: bl30+bl31+(bl32)+bl33*/
typedef struct aml_fip_header {
	fip_toc_header_t	fip_header; /*16byte*/
	fip_toc_entry_t		bl30_entry; /*40byte*/
#if (NEED_BL301)
	fip_toc_entry_t		bl301_entry; /*40byte*/
#endif
	fip_toc_entry_t		bl31_entry; /*40byte*/
#if (NEED_BL32)
	fip_toc_entry_t		bl32_entry; /*40byte*/
#endif
	fip_toc_entry_t		bl33_entry; /*40byte*/
} aml_fip_header_t;

/*aml defines*/
#define FIP_HEADER_SIZE_OFFSET		0x20
#define TPL_LOAD_ADDR				CONFIG_SYS_TEXT_BASE
#define TPL_GET_BL_ADDR(offset)		(TPL_LOAD_ADDR + (*((volatile unsigned *)(TPL_LOAD_ADDR + (offset)))))
#define TPL_GET_BL_SIZE(offset)		(*((volatile unsigned *)(TPL_LOAD_ADDR + offset)))

/*aml fip.bin doesn't have bl2.bin*/
//#define FM_BIN_BL2_OFFSET			0x20
//#define FM_BIN_BL2_SIZE			0x28
#define FM_BIN_BL30_OFFSET			0x20 //0x48(when have bl2.bin)
#define FM_BIN_BL30_SIZE			0x28 //0x50
#define FM_BIN_BL31_OFFSET			0x48 //0x70
#define FM_BIN_BL31_SIZE			0x50 //0x78
#if (NEED_BL32)
#define FM_BIN_BL32_OFFSET			0x70 //0x98
#define FM_BIN_BL32_SIZE			0x78 //0xA0
#define FM_BIN_BL33_OFFSET			0x98 //0xC0
#define FM_BIN_BL33_SIZE			0xA0 //0xC8
#else
#define FM_BIN_BL33_OFFSET			0x70 //0x98
#define FM_BIN_BL33_SIZE			0x78 //0xA0
#endif

#define FM_FIP_HEADER_LOAD_ADDR		0x01400000
#define FM_BL30_LOAD_ADDR			CONFIG_SYS_TEXT_BASE
#define FM_BL301_LOAD_ADDR			CONFIG_SYS_TEXT_BASE
#define FM_BL31_LOAD_ADDR			0x10100000
#define FM_BL32_LOAD_ADDR			0x10200000
#define FM_BL33_LOAD_ADDR			CONFIG_SYS_TEXT_BASE

/*usb burning func*/
#define USB_BL2_RETURN_ROM_ADDR			0xd9044504
#define FM_USB_MODE_LOAD_ADDR			0x02000000

#define BL2_MMU_TABLE_BASE				0x01500000
#define BL2_MMU_TABLE_SIZE				(sizeof(uint64_t) * MAX_XLAT_TABLES * XLAT_TABLE_ENTRIES)
#define BL2_MMAP_BASE					0x01600000
#define BL2_MMAP_NUM					(MAX_MMAP_REGIONS + 1)
#define BL2_SEC_BOOT_BUF_BASE			0x01700000
#define BL2_SEC_BOOT_BUF_SIZE			0x00100000
#define BL2_NAND_BUF_BASE				0x01800000
#define BL2_NAND_BUF_SIZE				0x00100000

/*fip defines*/
void bl2_load_image(void);

/*parse blx*/
void parse_blx(image_info_t *image_data,
				entry_point_info_t *entry_point_info,
				unsigned int addr,
				unsigned int length,
				unsigned int);
void process_bl30x(image_info_t *image_data,
				entry_point_info_t *entry_point_info,
				const char * name);
void bl2_to_romcode(uintptr_t entry);
void check_handler(void);

#endif /*__BL2_FIP_H_*/