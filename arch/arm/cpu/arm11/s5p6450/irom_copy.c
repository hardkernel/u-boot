/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <common.h>
#include <asm/arch/movi_partition.h>

extern ulong movi_read(int dev, ulong start, lbaint_t blkcnt, void *dst);
extern ulong movi_write(int dev, ulong start, lbaint_t blkcnt, void *src);

typedef u32 (*copy_sd_mmc_to_mem) \
	(u32 start_block, u32 block_count, u32* dest_addr);

typedef u32 (*copy_emmc43_to_mem) \
	(u32 block_size, u32* dest_addr);

typedef u32 (*copy_emmc44_to_mem) \
	(u32 block_size, u32* dest_addr);

typedef u32 (*emmc43_endbootop) \
	(void);

typedef u32 (*emmc44_endbootop) \
	(void);

#if defined(CONFIG_EVT0)
#define COPY_MOVI_TO_MEM_FUNC		(0x00001908)
#define COPY_EMMC43_CH1_TO_MEM_FUNC	(0x00002E64)
#define COPY_EMMC44_CH3_TO_MEM_FUNC	(0x00003FA4)
#elif defined(CONFIG_EVT1)
	#if defined(CONFIG_S5P6460)
		#define COPY_MOVI_TO_MEM_FUNC		(0xD0020038)
	#else
		#define COPY_MOVI_TO_MEM_FUNC		(0x00002360)
	#endif
#define COPY_EMMC43_CH1_TO_MEM_FUNC	(0x00003824)
#define COPY_EMMC44_CH3_LOAD_DRAM_FUNC	(0x0000653C)
#define SDMMC_ENDBOOTOP_EMMC_FUNC	(0x00001C5C)
#define MSH_ENDBOOTOP_EMMC_FUNC	(0x000040B0)
#else
#define COPY_MOVI_TO_MEM_FUNC		(0x00001908)
#define COPY_EMMC43_CH1_TO_MEM_FUNC	(0x00002E64)
#define COPY_EMMC44_CH3_TO_MEM_FUNC	(0x00003FA4)
#endif

#define EXTERNAL_FUNC_ADDRESS		(0xD0020038)

#define SDMMC_ReadBlocks(uStartBlk, uNumOfBlks, uDstAddr)	\
	(((void(*)(u32, u32, u32*))(*((u32 *)EXTERNAL_FUNC_ADDRESS)))(uStartBlk, uNumOfBlks, uDstAddr))


void movi_uboot_copy(void)
{
#if defined(CONFIG_S5P6460)
	SDMMC_ReadBlocks(MOVI_UBOOT_POS, MOVI_UBOOT_BLKCNT, CONFIG_PHY_UBOOT_BASE);
#else
	copy_sd_mmc_to_mem copy_uboot = (copy_sd_mmc_to_mem)(COPY_MOVI_TO_MEM_FUNC);

	copy_uboot(MOVI_UBOOT_POS, MOVI_UBOOT_BLKCNT, CONFIG_PHY_UBOOT_BASE);
#endif
}

void emmc_uboot_copy(void)
{
	copy_emmc43_to_mem copy_uboot = (copy_emmc43_to_mem)(COPY_EMMC43_CH1_TO_MEM_FUNC);

	copy_uboot(MOVI_UBOOT_BLKCNT, CONFIG_PHY_UBOOT_BASE);
}

void emmc_4_4_uboot_copy(void)
{
	copy_emmc44_to_mem copy_uboot = (copy_emmc44_to_mem)(COPY_EMMC44_CH3_LOAD_DRAM_FUNC);

	copy_uboot(MOVI_UBOOT_BLKCNT, CONFIG_PHY_UBOOT_BASE);

}

void emmc_4_3_endbootOp_eMMC(void)
{
	emmc43_endbootop endbootop_emmc43 = (emmc43_endbootop)(SDMMC_ENDBOOTOP_EMMC_FUNC);
	endbootop_emmc43();
}

void emmc_4_4_endbootOp_eMMC(void)
{
	emmc44_endbootop endbootop_emmc44 = (emmc44_endbootop)(MSH_ENDBOOTOP_EMMC_FUNC);
	endbootop_emmc44();
}

void movi_write_env(ulong addr)
{
	movi_write(1, raw_area_control.image[2].start_blk,
		raw_area_control.image[2].used_blk, addr);
}

void movi_read_env(ulong addr)
{
	movi_read(1, raw_area_control.image[2].start_blk,
		raw_area_control.image[2].used_blk, addr);
}

void movi_write_bl1(ulong addr, int dev_num)
{
	int i;
	ulong checksum;
	ulong src;
	ulong tmp;

	src = addr;

	for(i = 0, checksum = 0;i < (14 * 1024) - 4;i++)
	{
		checksum += *(u8*)addr++;
	}

	tmp = *(ulong*)addr;
	*(ulong*)addr = checksum;

	movi_write(dev_num, raw_area_control.image[1].start_blk,
		raw_area_control.image[1].used_blk, src);

	*(ulong*)addr = tmp;
}

