/*
 * (C) Copyright 2016 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <boot_rkimg.h>
#include <malloc.h>
#include <asm/io.h>
#include <asm/arch/boot_mode.h>

DECLARE_GLOBAL_DATA_PTR;

/*
 * Generally, we have 3 ways to get reboot mode:
 *
 * 1. from bootloader_message which is defined in MISC partition;
 * 2. from CONFIG_ROCKCHIP_BOOT_MODE_REG which supports "reboot xxx" commands;
 * 3. from env "reboot_mode" which is added by U-Boot code(currently only when
 *    recovery key pressed);
 *
 * 1st and 2nd cases are static determined at system start and we check it once,
 * while 3th case is dynamically added by U-Boot code, so we have to check it
 * everytime.
 *
 * Recovery mode from:
 *	- MISC partition;
 *	- "reboot recovery" command;
 *	- recovery key pressed without usb attach;
 */
int rockchip_get_boot_mode(void)
{
	struct bootloader_message *bmsg = NULL;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	uint32_t reg_boot_mode;
	char *env_reboot_mode;
	static int boot_mode = -1;	/* static */
	int clear_boot_reg = 0;
	int ret, cnt;
#ifdef CONFIG_ANDROID_BOOT_IMAGE
	u32 bcb_offset = android_bcb_msg_sector_offset();
#else
	u32 bcb_offset = BCB_MESSAGE_BLK_OFFSET;
#endif

	/*
	 * Here, we mainly check for:
	 * In rockusb_download(), that recovery key is pressed without
	 * USB attach will do env_set("reboot_mode", "recovery");
	 */
	env_reboot_mode = env_get("reboot_mode");
	if (env_reboot_mode) {
		if (!strcmp(env_reboot_mode, "recovery-key")) {
			boot_mode = BOOT_MODE_RECOVERY;
			printf("boot mode: recovery (key)\n");
		} else if (!strcmp(env_reboot_mode, "recovery-usb")) {
			boot_mode = BOOT_MODE_RECOVERY;
			printf("boot mode: recovery (usb)\n");
		} else if (!strcmp(env_reboot_mode, "recovery")) {
			boot_mode = BOOT_MODE_RECOVERY;
			printf("boot mode: recovery(env)\n");
		} else if (!strcmp(env_reboot_mode, "fastboot")) {
			boot_mode = BOOT_MODE_BOOTLOADER;
			printf("boot mode: fastboot\n");
		}
	}

	if (boot_mode != -1)
		return boot_mode;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -ENODEV;
	}

	ret = part_get_info_by_name(dev_desc, PART_MISC, &part_info);
	if (ret < 0) {
		printf("%s: Could not found misc partition\n", __func__);
		goto fallback;
	}

	cnt = DIV_ROUND_UP(sizeof(struct bootloader_message), dev_desc->blksz);
	bmsg = memalign(ARCH_DMA_MINALIGN, cnt * dev_desc->blksz);
	ret = blk_dread(dev_desc,
			part_info.start + bcb_offset,
			cnt, bmsg);
	if (ret != cnt) {
		free(bmsg);
		return -EIO;
	}

fallback:
	/*
	 * Boot mode priority
	 *
	 * Anyway, we should set download boot mode as the highest priority, so:
	 *
	 * reboot loader/bootloader/fastboot > misc partition "recovery" > reboot xxx.
	 */
	reg_boot_mode = readl((void *)CONFIG_ROCKCHIP_BOOT_MODE_REG);
	if (reg_boot_mode == BOOT_LOADER) {
		printf("boot mode: loader\n");
		boot_mode = BOOT_MODE_LOADER;
		clear_boot_reg = 1;
	} else if (reg_boot_mode == BOOT_FASTBOOT) {
		printf("boot mode: bootloader\n");
		boot_mode = BOOT_MODE_BOOTLOADER;
		clear_boot_reg = 1;
	} else if (bmsg && !strcmp(bmsg->command, "boot-recovery")) {
		printf("boot mode: recovery (misc)\n");
		boot_mode = BOOT_MODE_RECOVERY;
		clear_boot_reg = 1;
	} else {
		switch (reg_boot_mode) {
		case BOOT_NORMAL:
			printf("boot mode: normal\n");
			boot_mode = BOOT_MODE_NORMAL;
			clear_boot_reg = 1;
			break;
		case BOOT_RECOVERY:
			printf("boot mode: recovery (cmd)\n");
			boot_mode = BOOT_MODE_RECOVERY;
			clear_boot_reg = 1;
			break;
		case BOOT_UMS:
			printf("boot mode: ums\n");
			boot_mode = BOOT_MODE_UMS;
			clear_boot_reg = 1;
			break;
		case BOOT_CHARGING:
			printf("boot mode: charging\n");
			boot_mode = BOOT_MODE_CHARGING;
			clear_boot_reg = 1;
			break;
		case BOOT_PANIC:
			printf("boot mode: panic\n");
			boot_mode = BOOT_MODE_PANIC;
			break;
		case BOOT_WATCHDOG:
			printf("boot mode: watchdog\n");
			boot_mode = BOOT_MODE_WATCHDOG;
			break;
		default:
			printf("boot mode: None\n");
			boot_mode = BOOT_MODE_UNDEFINE;
		}
	}

	/*
	 * We don't clear boot mode reg when its value stands for the reboot
	 * reason or others(in the future), the kernel will need and clear it.
	 */
	if (clear_boot_reg)
		writel(BOOT_NORMAL, (void *)CONFIG_ROCKCHIP_BOOT_MODE_REG);

	return boot_mode;
}

int setup_boot_mode(void)
{
	char env_preboot[256] = {0};

	switch (rockchip_get_boot_mode()) {
	case BOOT_MODE_BOOTLOADER:
		printf("enter fastboot!\n");
#if defined(CONFIG_FASTBOOT_FLASH_MMC_DEV)
		snprintf(env_preboot, 256,
				"setenv preboot; mmc dev %x; fastboot usb 0; ",
				CONFIG_FASTBOOT_FLASH_MMC_DEV);
#elif defined(CONFIG_FASTBOOT_FLASH_NAND_DEV)
		snprintf(env_preboot, 256,
				"setenv preboot; fastboot usb 0; ");
#endif
		env_set("preboot", env_preboot);
		break;
	case BOOT_MODE_UMS:
		printf("enter UMS!\n");
		env_set("preboot", "setenv preboot; ums mmc 0");
		break;
	case BOOT_MODE_LOADER:
		printf("enter Rockusb!\n");
		env_set("preboot", "setenv preboot; rockusb 0 ${devtype} ${devnum}");
		break;
	case BOOT_MODE_CHARGING:
		printf("enter charging!\n");
		env_set("preboot", "setenv preboot; charge");
		break;
	}

	return 0;
}
