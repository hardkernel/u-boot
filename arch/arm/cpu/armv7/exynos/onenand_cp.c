/*
 * Copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * Copy U-Boot code from OneNAND into DRAM (UBOOT_PHY_BASE).
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <common.h>
#include <asm/io.h>
#include <linux/mtd/onenand_regs.h>

#ifdef CONFIG_SECURE_BOOT
#include "UBOOT_SB20_S5PC210S.h"
#endif

#ifdef CONFIG_BOOT_ONENAND_IROM

#define ONENAND_BASE		(CFG_ONENAND_BASE)
#define CONFIG_EVT1
//#define CONFIG_SECURE_BOOT
#define CONFIG_SECURE_BL1_ONLY

#if defined(CONFIG_MCP_AC) || defined(CONFIG_MCP_B) || defined(CONFIG_MCP_D)
#define ONENAND_PAGE_SIZE	4096
#elif defined(CONFIG_MCP_H)
#define ONENAND_PAGE_SIZE	2048
#else	// default page size (for V210 daughter board)
#define ONENAND_PAGE_SIZE	2048
#endif

#if defined(CONFIG_FUSED)
#define FWBL1_SIZE		(4096)
#define UBOOT_START_BLOCK	(FWBL1_SIZE / ONENAND_PAGE_SIZE)
#else
#define UBOOT_START_BLOCK	(0)
#endif

#define READ_INTERRUPT()	\
	onenand_readw(ONENAND_BASE + ONENAND_REG_INTERRUPT)

#define onenand_block_address(block)		(block)
#define onenand_sector_address(page)		(page << ONENAND_FPA_SHIFT)
#define onenand_buffer_address()		((1 << 3) << 8)
//#define onenand_buffer_address()		((0 << 3) << 8)
#define onenand_bufferram_address(block)	(0)


#ifdef CONFIG_EVT1
#define SECURE_CONTEXT_BASE 0x02023000
#else
#define SECURE_CONTEXT_BASE 0x02023800
#endif

inline unsigned short onenand_readw (unsigned int addr)
{
	return *(unsigned short*)addr;
}

inline void onenand_writew (unsigned short value, unsigned int addr)
{
	*(unsigned short*)addr = value;
}

void onenand_loadpage (unsigned int block, unsigned int page)
{
	// Block Number
	onenand_writew(onenand_block_address(block),
			ONENAND_BASE + ONENAND_REG_START_ADDRESS1);

	// BufferRAM
	onenand_writew(onenand_bufferram_address(block),
			ONENAND_BASE + ONENAND_REG_START_ADDRESS2);

	// Page (Sector) Number Set: FPA, FSA
	onenand_writew(onenand_sector_address(page),
			ONENAND_BASE + ONENAND_REG_START_ADDRESS8);

	// BSA, BSC
	onenand_writew(onenand_buffer_address(),
			ONENAND_BASE + ONENAND_REG_START_BUFFER);

	// Interrupt clear
	onenand_writew(ONENAND_INT_CLEAR, ONENAND_BASE + ONENAND_REG_INTERRUPT);

	onenand_writew(ONENAND_CMD_READ, ONENAND_BASE + ONENAND_REG_COMMAND);

#if 1
	while (!(READ_INTERRUPT() & ONENAND_INT_READ))
		continue;
#else
	while (!(READ_INTERRUPT() & ONENAND_INT_MASTER))
		continue;
#endif
}

int onenand_isbad (unsigned int block)
{
	unsigned short* src;

	onenand_loadpage(block, 0);

	src = (unsigned short *)(ONENAND_BASE + ONENAND_SPARERAM);
	if (src[0] == (unsigned short)0xFFFF)
		return 0;
	else
		return 1;
}

void onenand_readpage (void* base, unsigned int block, unsigned int page)
{
	int len;
	unsigned short* dest;
	unsigned short* src;

	onenand_loadpage(block, page);

	len = ONENAND_PAGE_SIZE >> 1;
	dest = (unsigned short *)(base);
	src = (unsigned short *)(ONENAND_BASE + ONENAND_DATARAM);
	while (len-- > 0)
	{
		*dest++ = *src++;
	}
}

/*
 * Copy U-Boot from OneNAND to DRAM (512KB)
 */
void onenand_bl2_copy(void)
{
	unsigned int base = CFG_PHY_UBOOT_BASE;
	int download_size = 512 * 1024;		/* U-boot image size */
	//int block = 0;				/* Start block */
	//int page = UBOOT_START_BLOCK;		/* Start page */
	int block = 0;				/* Start block */

	int page = 16;		/* Start page */
#ifndef CONFIG_SECURE_BOOT
#ifndef CONFIG_SECURE_BL1_ONLY
#ifndef CONFIG_EVT1
	page = 8;		/* Start page */
#endif
#endif
#endif
	do {
		onenand_readpage((void *)base, block, page);

		base += ONENAND_PAGE_SIZE;
		download_size -= ONENAND_PAGE_SIZE;

		if (++page == 64) {
			page = 0;
			do {
				block++;
			} while (onenand_isbad(block));
		}
	} while (download_size > 0);

#ifdef CONFIG_SECURE_BOOT
	if(Check_Signature( (SB20_CONTEXT *)SECURE_CONTEXT_BASE, (unsigned char*)CFG_PHY_UBOOT_BASE, 
			1024*512-256, (unsigned char*)(CFG_PHY_UBOOT_BASE+1024*512-256), 256 ) != 0) {
		while(1);
	}
#endif


}

#endif /* CONFIG_BOOT_ONENAND_IROM */

