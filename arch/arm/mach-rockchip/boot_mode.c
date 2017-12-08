/*
 * (C) Copyright 2016 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <adc.h>
#include <asm/io.h>
#include <asm/arch/boot_mode.h>
#include <cli.h>
#include <dm.h>
#include <fdtdec.h>
#include <boot_rkimg.h>

DECLARE_GLOBAL_DATA_PTR;

void set_back_to_bootrom_dnl_flag(void)
{
	writel(BOOT_BROM_DOWNLOAD, CONFIG_ROCKCHIP_BOOT_MODE_REG);
}

/*
 * detect download key status by adc, most rockchip
 * based boards use adc sample the download key status,
 * but there are also some use gpio. So it's better to
 * make this a weak function that can be override by
 * some special boards.
 */
#define KEY_DOWN_MIN_VAL	0
#define KEY_DOWN_MAX_VAL	30

__weak int rockchip_dnl_key_pressed(void)
{
	const void *blob = gd->fdt_blob;
	unsigned int val;
	int channel = 1;
	int node;
	u32 chns[2];

	node = fdt_node_offset_by_compatible(blob, 0, "adc-keys");
	if (node >= 0) {
	       if (!fdtdec_get_int_array(blob, node, "io-channels", chns, 2))
		       channel = chns[1];
	}

	if (adc_channel_single_shot("saradc", channel, &val)) {
		printf("%s adc_channel_single_shot fail!\n", __func__);
		return false;
	}

	if ((val >= KEY_DOWN_MIN_VAL) && (val <= KEY_DOWN_MAX_VAL))
		return true;
	else
		return false;
}

void rockchip_dnl_mode_check(void)
{
	if (rockchip_dnl_key_pressed()) {
		printf("download key pressed, entering download mode...\n");
		/* If failed, we fall back to bootrom download mode */
		cli_simple_run_command("rockusb 0 mmc 0", 0);
		set_back_to_bootrom_dnl_flag();
		do_reset(NULL, 0, 0, NULL);
	}
}

int setup_boot_mode(void)
{
	int boot_mode = BOOT_MODE_NORMAL;
	char env_preboot[256] = {0};

	rockchip_dnl_mode_check();
#ifdef CONFIG_RKIMG_BOOTLOADER
	boot_mode = rockchip_get_boot_mode();
#endif
	switch (boot_mode) {
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
		env_set("preboot", "setenv preboot; rockusb 0 mmc 0");
		break;
	case BOOT_MODE_CHARGING:
		printf("enter charging!\n");
		env_set("preboot", "setenv preboot; charge");
		break;
	case BOOT_MODE_RECOVERY:
		printf("enter Recovery mode!\n");
		env_set("reboot_mode", "recovery");
		break;
	}

	return 0;
}
