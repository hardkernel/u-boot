/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 *
 * Amlogic FIP image relate defines
 * Author: xiaobo.gu@amlogic.com
 * Created Time: 2015.04.22
 *
 */

#include <bl_common.h>
#include <stdint.h>
#include <platform_def.h>
#include <storage.h>

#ifndef __BL2_FIP_H_
#define __BL2_FIP_H_

#define NEED_BL32 CONFIG_NEED_BL32

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
#if 0
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

#define FM_FIP_HEADER_LOAD_ADDR		SIZE_32M
#define FM_BL30_LOAD_ADDR			CONFIG_SYS_TEXT_BASE
#define FM_BL301_LOAD_ADDR			CONFIG_SYS_TEXT_BASE
#define FM_BL31_LOAD_ADDR			0x10100000
#define FM_BL32_LOAD_ADDR			0x10200000
#define FM_BL33_LOAD_ADDR			CONFIG_SYS_TEXT_BASE

/*fip defines*/
void bl2_load_image(void);

/*parse blx*/
void parse_blx(image_info_t *image_data,
				entry_point_info_t *entry_point_info,
				unsigned int addr,
				unsigned int length);

void process_bl30x(image_info_t *image_data,
				entry_point_info_t *entry_point_info,
				const char * name);

#endif /*__BL2_FIP_H_*/