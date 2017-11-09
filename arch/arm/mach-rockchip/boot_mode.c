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
	void *reg;
	int boot_mode;

	rockchip_dnl_mode_check();

	if (of_machine_is_compatible("rockchip,rk3128"))
		reg = (void *)0x100a0038;
	else
		reg = (void *)CONFIG_ROCKCHIP_BOOT_MODE_REG;

	boot_mode = readl(reg);

	debug("boot mode %x.\n", boot_mode);

	/* Clear boot mode */
	writel(BOOT_NORMAL, reg);

	switch (boot_mode) {
	case BOOT_FASTBOOT:
		printf("enter fastboot!\n");
		env_set("preboot", "setenv preboot; fastboot usb0");
		break;
	case BOOT_UMS:
		printf("enter UMS!\n");
		env_set("preboot", "setenv preboot; ums mmc 0");
		break;
	case BOOT_LOADER:
		printf("enter Rockusb!\n");
		env_set("preboot", "setenv preboot; rockusb 0 mmc 0");
		break;
	case BOOT_CHARGING:
		printf("enter charging!\n");
		env_set("preboot", "setenv preboot; charge");
		break;
	}

	return 0;
}
