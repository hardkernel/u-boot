
/*
 * arch/arm/include/asm/arch-txl/nand.h
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

#ifndef __NAND_H__
#define __NAND_H__
#include <asm/arch/cpu_config.h>

#ifndef SD_EMMC_BASE_C
#define SD_EMMC_BASE_C 0xd0074000
#endif

#define P_NAND_BASE (SD_EMMC_BASE_C | (1<<11))
#define P_CLK_CNTL	(volatile uint32_t *)(SD_EMMC_BASE_C)
#define P_NAND_CMD  (volatile uint32_t *)(P_NAND_BASE + 0x00)
#define P_NAND_CFG  (volatile uint32_t *)(P_NAND_BASE + 0x04)
#define P_NAND_DADR (volatile uint32_t *)(P_NAND_BASE + 0x08)
#define P_NAND_IADR (volatile uint32_t *)(P_NAND_BASE + 0x0c)
#define P_NAND_BUF  (volatile uint32_t *)(P_NAND_BASE + 0x10)
#define P_NAND_INFO (volatile uint32_t *)(P_NAND_BASE + 0x14)
#define P_NAND_DC   (volatile uint32_t *)(P_NAND_BASE + 0x18)
#define P_NAND_ADR  (volatile uint32_t *)(P_NAND_BASE + 0x1c)
#define P_NAND_DL   (volatile uint32_t *)(P_NAND_BASE + 0x20)
#define P_NAND_DH   (volatile uint32_t *)(P_NAND_BASE + 0x24)
#define P_NAND_CADR (volatile uint32_t *)(P_NAND_BASE + 0x28)
#define P_NAND_SADR (volatile uint32_t *)(P_NAND_BASE + 0x2c)

#define CEF (0xf<<10)
#define CE0 (0xe<<10)
#define CE1 (0xd<<10)
#define CE2 (0xb<<10)
#define CE3 (0x7<<10)

#define IO4 ((0xe<<10)|(1<<18))
#define IO5 ((0xd<<10)|(1<<18))
#define IO6 ((0xb<<10)|(1<<18))

#define CLE  (0x5<<14)
#define ALE  (0x6<<14)
#define DWR  (0x4<<14)
#define DRD  (0x8<<14)
#define IDLE (0xc<<14)
#define RB   (1<<20)

#define M2N  ((0<<17) | (2<<20) | (1<<19))
#define N2M  ((1<<17) | (2<<20) | (1<<19))
#define STS  ((3<<17) | (2<<20))
#define ADL  ((0<<16) | (3<<20))
#define ADH  ((1<<16) | (3<<20))
#define AIL  ((2<<16) | (3<<20))
#define AIH  ((3<<16) | (3<<20))
#define ASL  ((4<<16) | (3<<20))
#define ASH  ((5<<16) | (3<<20))
#define SEED ((8<<16) | (3<<20))

// NAND Flash Manufacturer ID Codes
#define NAND_MFR_TOSHIBA	0x98
#define NAND_MFR_SAMSUNG	0xec
#define NAND_MFR_FUJITSU	0x04
#define NAND_MFR_NATIONAL	0x8f
#define NAND_MFR_RENESAS	0x07
#define NAND_MFR_STMICRO	0x20
#define NAND_MFR_HYNIX		0xad
#define NAND_MFR_MICRON		0x2c
#define NAND_MFR_AMD		0x01
#define NAND_MFR_INTEL		0x89
#define NAND_MFR_SANDISK    	0x45
#define NAND_MFR_USER          0x100
#define NAND_MFR_EFUSE         0x101

typedef struct nand_setup {
    union {
        uint32_t d32;
        struct {
            unsigned cmd:22;
            unsigned large_page:1; // 22
            unsigned no_rb:1;      // 23 from efuse
            unsigned a2:1;         // 24
            unsigned reserved25:1; // 25
            unsigned page_list:1;  // 26
            unsigned sync_mode:2;  // 27 from efuse
            unsigned size:2;       // 29 from efuse
            unsigned active:1;     // 31
        } b;
    } cfg;
    uint16_t id;
    uint16_t max; // id:0x100 user, max:0 disable.
} nand_setup_t;

typedef struct _nand_cmd{
    unsigned char type;
    unsigned char val;
} nand_cmd_t;

typedef struct _ext_info{
	uint32_t read_info;		//nand_read_info;
	uint32_t new_type;		//new_nand_type;
	uint32_t page_per_blk;	//pages_in_block;
	uint32_t xlc;			//slc=1, mlc=2, tlc=3.
	uint32_t rsv1[5];
} ext_info_t;

typedef struct _nand_page0 {
	nand_setup_t nand_setup;		//8
	unsigned char page_list[16]; 	//16
	nand_cmd_t retry_usr[32];		//64 (32 cmd max I/F)
	ext_info_t ext_info;			//64
} nand_page0_t;	//384 bytes max.

//#define NAND_PAGE0_BUF	  BL1_NAND_BUFF
#define NAND_PAGE0_BUF  (0x1800000)
#define NAND_PAGE_LIST	  (NAND_PAGE0_BUF + sizeof(nand_setup_t))
#define NAND_RETRY_USER	  (NAND_PAGE_LIST + 16)
#define NAND_INFO_BUF     (NAND_PAGE0_BUF + 512)
#define DEFAULT_ECC_MODE  ((1<<23) |(1<<22) | (2<<20) |(1<<19) |(1<<17)|(7<<14)|(1<<13)|(48<<6)|1)
//#define DEFAULT_ECC_MODE  ((1<<23) |(1<<22) | (2<<20) |(1<<19) |(1<<17)|(7<<14)|(1<<13)|(48<<6)|1)

#define ERROR_MOD(mod,num) ((uint32_t)(((mod<<6)|num)))
#define ERROR_NAND_TIMEOUT          ERROR_MOD(2,1)      //
#define ERROR_NAND_ECC              ERROR_MOD(2,2)      //
#define ERROR_NAND_MAGIC_WORD       ERROR_MOD(2,3)      //
#define ERROR_NAND_INIT_READ        ERROR_MOD(2,4)      //
#define ERROR_NAND_BLANK_PAGE       ERROR_MOD(2,5)      //
#define ERROR_NAND_UNALIGN_SRC      ERROR_MOD(2,6)      //

#define NAND_SECTOR_SIZE		(512)
#define NAND_MAX_PAGESIZE		(0x4000)	//16K
#define SRC_ALIGN_SIZE			(NAND_MAX_PAGESIZE)

#define INFO_BYTE_PER_ECCPAGE	(8)
uint32_t nfio_init(void);
uint32_t nf_read(uint32_t boot_device, uint32_t src, uint32_t des, uint32_t size);
#endif /* __NAND_H__ */

