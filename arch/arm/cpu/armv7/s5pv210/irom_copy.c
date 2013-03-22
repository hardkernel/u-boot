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

#if defined(CONFIG_SECURE_BOOT)
#include <secure_boot.h>
#endif

extern raw_area_t raw_area_control;

typedef u32(*copy_sd_mmc_to_mem)
(u32 channel, u32 start_block, u16 block_size, u32 *trg, u32 init);


typedef u32(*copy_emmc_to_mem)
(u8 whthACK, u32 block_size, u32 *buffer, int buswidth);


//#define CopyMMC4_3toMem(a,b,c,d)        (((bool(*)(bool, unsigned int, unsigned int*, int))(*((unsigned int *)0xD0037F9C)))(a,b,c,d))

void movi_bl2_copy(void)
{
	ulong ch;
#if defined(CONFIG_EVT1)
	ch = *(volatile u32 *)(0xD0037488);
	copy_sd_mmc_to_mem copy_bl2 =
	    (copy_sd_mmc_to_mem) (*(u32 *) (0xD0037F98));

	#if defined(CONFIG_SECURE_BOOT)
	ulong rv;
	#endif
#else
	ch = *(volatile u32 *)(0xD003A508);
	copy_sd_mmc_to_mem copy_bl2 =
	    (copy_sd_mmc_to_mem) (*(u32 *) (0xD003E008));
#endif
	u32 ret;
	if (ch == 0xEB000000) {
		ret = copy_bl2(0, MOVI_BL2_POS, MOVI_BL2_BLKCNT,
			CONFIG_PHY_UBOOT_BASE, 0);

#if defined(CONFIG_SECURE_BOOT)
		/* do security check */
		rv = Check_Signature( (SecureBoot_CTX *)SECURE_BOOT_CONTEXT_ADDR,
				      (unsigned char *)CONFIG_PHY_UBOOT_BASE, (1024*512-128),
			              (unsigned char *)(CONFIG_PHY_UBOOT_BASE+(1024*512-128)), 128 );
		if (rv != 0){
				while(1);
			}
#endif
	}
	else if (ch == 0xEB200000) {
		ret = copy_bl2(2, MOVI_BL2_POS, MOVI_BL2_BLKCNT,
			CONFIG_PHY_UBOOT_BASE, 0);
		
#if defined(CONFIG_SECURE_BOOT)
		/* do security check */
		rv = Check_Signature( (SecureBoot_CTX *)SECURE_BOOT_CONTEXT_ADDR,
				      (unsigned char *)CONFIG_PHY_UBOOT_BASE, (1024*512-128),
			              (unsigned char *)(CONFIG_PHY_UBOOT_BASE+(1024*512-128)), 128 );
		if (rv != 0) {
			while(1);
		}
#endif
	}
	else
		return;

	if (ret == 0)
		while (1)
			;
	else
		return;
}

void emmc_bl2_copy(void)
{
	copy_emmc_to_mem copy_bl2 =
	    (copy_emmc_to_mem) (*(u32 *) (0xD0037F9C));

#if 0//defined(CONFIG_SECURE_BOOT)
	volatile u32 * pub_key;
	int secure_booting;
	int i;
	ulong rv;
#endif

	//u32 ret;
	copy_bl2(0, MOVI_BL2_BLKCNT, CONFIG_PHY_UBOOT_BASE, 4);

#if 0//defined(CONFIG_SECURE_BOOT)
		pub_key = (volatile u32 *)SECURE_KEY_ADDRESS;
			secure_booting = 0;

		for(i=0;i<33;i++){
			if( *(pub_key+i) != 0x0) secure_booting = 1;
		}
	
		if (secure_booting == 1) {
			/* do security check */
			rv = Check_IntegrityOfImage( (SecureBoot_CTX *)SECURE_KEY_ADDRESS, (unsigned char*)CFG_PHY_UBOOT_BASE,
			(1024*512-128), (unsigned char*)(CONFIG_PHY_UBOOT_BASE+(1024*512-128)), 128 );
			
			if (rv != 0){
				while(1);
			}
		}
#endif
	return;
}


/*
 * Copy zImage from SD/MMC to mem
 */
#ifdef CONFIG_MCP_SINGLE
#if 0
void movi_zImage_copy(void)
{
	copy_sd_mmc_to_mem copy_zImage =
	    (copy_sd_mmc_to_mem) (*(u32 *) COPY_SDMMC_TO_MEM);
	u32 ret;

	/*
	 * 0x3C6FCE is total size of 2GB SD/MMC card
	 * TODO : eMMC will be used as boot device on HP proto2 board
	 *        So, total size of eMMC will be re-defined next board.
	 */
	ret =
	    copy_zImage(0, 0x3C6FCE, MOVI_ZIMAGE_BLKCNT, CFG_PHY_KERNEL_BASE,
			1);

	if (ret == 0)
		while (1)
			;
	else
		return;
}
#endif
#endif

void print_movi_bl2_info(void)
{
	printf("%d, %d, %d\n", MOVI_BL2_POS, MOVI_BL2_BLKCNT, MOVI_ENV_BLKCNT);
}

void movi_write_env(ulong addr)
{
	movi_write(raw_area_control.image[2].start_blk,
		   raw_area_control.image[2].used_blk, addr);
}

void movi_read_env(ulong addr)
{
	movi_read(raw_area_control.image[2].start_blk,
		  raw_area_control.image[2].used_blk, addr);
}

void movi_write_bl1(ulong addr, u32 dev_num)
{
	int i;
	ulong checksum;
	ulong src;
	ulong tmp;

	src = addr;
#if defined(CONFIG_EVT1)
	addr += 16;
	for (i = 16, checksum = 0; i < SS_SIZE; i++) {
		checksum += *(u8 *) addr++;
	}
	printf("checksum : 0x%x\n", checksum);
	*(volatile u32 *)(src + 0x8) = checksum;
	movi_write(dev_num, raw_area_control.image[1].start_blk,
		   raw_area_control.image[1].used_blk, src);
#else
	for (i = 0, checksum = 0; i < SS_SIZE - 4; i++) {
		checksum += *(u8 *) addr++;
	}

	tmp = *(ulong *) addr;
	*(ulong *) addr = checksum;

	movi_write(dev_num, raw_area_control.image[0].start_blk,
		   raw_area_control.image[0].used_blk, src);

	*(ulong *) addr = tmp;
#endif
}

#if defined(CONFIG_VOGUES)
int movi_boot_src()
{
	ulong reg;
	ulong src;

	reg = (*(volatile u32 *)(INF_REG_BASE + INF_REG3_OFFSET));

	if (reg == BOOT_MMCSD)
		/* boot device is SDMMC */
		src = 0;
	else if (reg == BOOT_NOR)
		/* boot device is NOR */
		src = 1;

	return src;
}
#endif
