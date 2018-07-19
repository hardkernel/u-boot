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
#include <linux/usb/phy-rockchip-inno-usb2.h>
#include <key.h>

DECLARE_GLOBAL_DATA_PTR;

#if (CONFIG_ROCKCHIP_BOOT_MODE_REG == 0)

int setup_boot_mode(void)
{
	return 0;
}

#else

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
	int keyval = false;

/*
 * This is a generic interface to read key
 */
#if defined(CONFIG_DM_KEY)
	keyval = key_read(KEY_VOLUMEUP);

	return key_is_pressed(keyval);

#elif defined(CONFIG_ADC)
	const void *blob = gd->fdt_blob;
	unsigned int val;
	int channel = 1;
	int node;
	int ret;
	u32 chns[2];

	node = fdt_node_offset_by_compatible(blob, 0, "adc-keys");
	if (node >= 0) {
	       if (!fdtdec_get_int_array(blob, node, "io-channels", chns, 2))
		       channel = chns[1];
	}

	ret = adc_channel_single_shot("saradc", channel, &val);
	if (ret) {
		printf("%s adc_channel_single_shot fail! ret=%d\n", __func__, ret);
		return false;
	}

	if ((val >= KEY_DOWN_MIN_VAL) && (val <= KEY_DOWN_MAX_VAL))
		return true;
	else
		return false;
#endif

	return keyval;
}

void devtype_num_envset(void)
{
	static int done = 0;
	int ret = 0;

	if (done)
		return;

	const char *devtype_num_set = "run rkimg_bootdev";

	ret = run_command_list(devtype_num_set, -1, 0);
	if (ret) {
		/* Set default dev type/num if command not valid */
		env_set("devtype", "mmc");
		env_set("devnum", "0");
	}

	done = 1;
}

void rockchip_dnl_mode_check(void)
{
	if (rockchip_dnl_key_pressed()) {
		if (rockchip_u2phy_vbus_detect()) {
			printf("download key pressed, entering download mode...\n");
			/* If failed, we fall back to bootrom download mode */
			run_command_list("rockusb 0 ${devtype} ${devnum}", -1, 0);
			set_back_to_bootrom_dnl_flag();
			do_reset(NULL, 0, 0, NULL);
		} else {
			printf("recovery key pressed, entering recovery mode!\n");
			env_set("reboot_mode", "recovery");
		}
	}
}

int setup_boot_mode(void)
{
	int boot_mode = BOOT_MODE_NORMAL;
	char env_preboot[256] = {0};

	devtype_num_envset();
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
		env_set("preboot", "setenv preboot; rockusb 0 ${devtype} ${devnum}");
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

#endif
