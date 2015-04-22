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

#ifndef __BL2_FIP_H_
#define __BL2_FIP_H_

/*amlogic fip structure: bl30+bl31+(bl32)+bl33*/
typedef struct aml_fip_header {
	unsigned long fip_header1;
	unsigned long fip_header2;
	unsigned long fip_header3;
	unsigned long fip_header4;
	unsigned long bl30_offset;
	unsigned long bl30_size;
	unsigned long bl30_attr1;
	unsigned long bl30_attr2;
	unsigned long bl30_attr3;
	unsigned long bl31_offset;
	unsigned long bl31_size;
	unsigned long bl31_attr1;
	unsigned long bl31_attr2;
	unsigned long bl31_attr3;
#ifdef BL32_BASE
	unsigned long bl32_offset;
	unsigned long bl32_size;
	unsigned long bl32_attr1;
	unsigned long bl32_attr2;
	unsigned long bl32_attr3;
#endif
	unsigned long bl33_offset;
	unsigned long bl33_size;
	unsigned long bl33_attr1;
	unsigned long bl33_attr2;
	unsigned long bl33_attr3;
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
#ifdef BL32_BASE
#define FM_BIN_BL32_OFFSET			0x70 //0x98
#define FM_BIN_BL32_SIZE			0x78 //0xA0
#define FM_BIN_BL33_OFFSET			0x98 //0xC0
#define FM_BIN_BL33_SIZE			0xA0 //0xC8
#else
#define FM_BIN_BL33_OFFSET			0x70 //0x98
#define FM_BIN_BL33_SIZE			0x78 //0xA0
#endif

#define FM_BL30_LOAD_ADDR			CONFIG_SYS_TEXT_BASE
#define FM_BL31_LOAD_ADDR			0x10100000
#define FM_BL32_LOAD_ADDR			0x0
#define FM_BL33_LOAD_ADDR			CONFIG_SYS_TEXT_BASE

/*fip defines*/
void bl2_load_image(void);

/*parse blx*/
void parse_blx(image_info_t *image_data,
				entry_point_info_t *entry_point_info,
				unsigned int addr,
				unsigned int length);

void process_bl30(image_info_t *image_data,
				entry_point_info_t *entry_point_info);

#endif /*__BL2_FIP_H_*/