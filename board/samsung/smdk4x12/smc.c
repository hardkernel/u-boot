/*
 * Copyright (c) 2012 Samsung Electronics Co., Ltd.
 *
 * "SMC CALL COMMAND"
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <asm/arch/smc.h>

static inline u32 exynos_smc(u32 cmd, u32 arg1, u32 arg2, u32 arg3)
{
	register u32 reg0 __asm__("r0") = cmd;
	register u32 reg1 __asm__("r1") = arg1;
	register u32 reg2 __asm__("r2") = arg2;
	register u32 reg3 __asm__("r3") = arg3;

	__asm__ volatile (
		"smc	0\n"
		: "+r"(reg0), "+r"(reg1), "+r"(reg2), "+r"(reg3)

	);

	return reg0;
}

static inline u32 exynos_smc_read(u32 cmd)
{
	register u32 reg0 __asm__("r0") = cmd;
	register u32 reg1 __asm__("r1") = 0;

	__asm__ volatile (
		"smc	0\n"
		: "+r"(reg0), "+r"(reg1)

	);

	return reg1;
}


unsigned int load_uboot_image(u32 boot_device)
{
	image_info *info_image;

	info_image = (image_info *) CONFIG_IMAGE_INFO_BASE;

	if (boot_device == SDMMC_CH2) {

		info_image->bootdev.sdmmc.image_pos = MOVI_UBOOT_POS;
		info_image->bootdev.sdmmc.blkcnt =  MOVI_UBOOT_BLKCNT;
		info_image->bootdev.sdmmc.base_addr = CONFIG_SYS_TEXT_BASE;

	} else if (boot_device == EMMC || boot_device == EMMC_4_4) {

		info_image->bootdev.emmc.blkcnt =  MOVI_UBOOT_BLKCNT;
		info_image->bootdev.emmc.base_addr = CONFIG_SYS_TEXT_BASE;

	}

	info_image->image_base_addr = CONFIG_SYS_TEXT_BASE;
	info_image->size = (MOVI_UBOOT_BLKCNT * MOVI_BLKSIZE);
	info_image->secure_context_base = SMC_SECURE_CONTEXT_BASE;
	info_image->signature_size = SMC_UBOOT_SIGNATURE_SIZE;

	return exynos_smc(SMC_CMD_LOAD_UBOOT,
			boot_device, CONFIG_IMAGE_INFO_BASE, 0);
}

unsigned int coldboot(u32 boot_device)
{
	image_info *info_image;
	int i;

	info_image = (image_info *) CONFIG_IMAGE_INFO_BASE;

	if (boot_device == SDMMC_CH2) {

		info_image->bootdev.sdmmc.image_pos = MOVI_TZSW_POS;
		info_image->bootdev.sdmmc.blkcnt =  MOVI_TZSW_BLKCNT;
		info_image->bootdev.sdmmc.base_addr = CONFIG_PHY_TZSW_BASE;

	} else if (boot_device == EMMC || boot_device == EMMC_4_4) {

		i = 100;		/* for EMMC 4.4 */
		while(i--);

		info_image->bootdev.emmc.blkcnt =  MOVI_TZSW_BLKCNT;
		info_image->bootdev.emmc.base_addr = CONFIG_PHY_TZSW_BASE;

	}

	info_image->image_base_addr = CONFIG_PHY_TZSW_BASE;
	info_image->size = (MOVI_TZSW_BLKCNT * MOVI_BLKSIZE);
	info_image->secure_context_base = SMC_SECURE_CONTEXT_BASE;
	info_image->signature_size = SMC_TZSW_SIGNATURE_SIZE;

	return exynos_smc(SMC_CMD_COLDBOOT,
			boot_device, CONFIG_IMAGE_INFO_BASE, CONFIG_SYS_TEXT_BASE);
}

void warmboot(void)
{
	exynos_smc(SMC_CMD_WARMBOOT, 0, 0, (EXYNOS4_POWER_BASE + INFORM0_OFFSET));
}

unsigned int find_second_boot(void)
{
	return exynos_smc_read(SMC_CMD_CHECK_SECOND_BOOT);
}

void emmc_endbootop(void)
{
	exynos_smc(SMC_CMD_EMMC_ENDBOOTOP, 0, 0, 0);
}

void sdmmc_enumerate(void)
{
	exynos_smc(SMC_CMD_SDMMC_ENUMERATE, 0, 0, 0);
}
