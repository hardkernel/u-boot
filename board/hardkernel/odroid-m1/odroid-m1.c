/*
 * SPDX-License-Identifier:     GPL-2.0+
 *
 * (C) Copyright 2020 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <boot_rkimg.h>
#include <dwc3-uboot.h>
#include <usb.h>
#include <mmc.h>
#include <mtd_blk.h>

DECLARE_GLOBAL_DATA_PTR;

#ifdef CONFIG_USB_DWC3
static struct dwc3_device dwc3_device_data = {
	.maximum_speed = USB_SPEED_HIGH,
	.base = 0xfcc00000,
	.dr_mode = USB_DR_MODE_PERIPHERAL,
	.index = 0,
	.dis_u2_susphy_quirk = 1,
	.usb2_phyif_utmi_width = 16,
};

int usb_gadget_handle_interrupts(void)
{
	dwc3_uboot_handle_interrupt(0);
	return 0;
}

int board_usb_init(int index, enum usb_init_type init)
{
	return dwc3_uboot_init(&dwc3_device_data);
}
#endif

int rk_board_late_init(void)
{
	struct blk_desc *dev_desc;
	char buf[1024] = "run distro_bootcmd";

	/* Load SPI firmware when boot device is SPI flash memory
	 * and environment value 'skip_spiboot' is not 'true'
	 */
	if (strcmp(env_get("skip_spiboot"), "true")) {
		dev_desc = rockchip_get_bootdev();
		if (dev_desc && (dev_desc->if_type == IF_TYPE_MTD
					&& dev_desc->devnum == 2))
			snprintf(buf, sizeof(buf),
					"cramfsload $scriptaddr boot.scr;"
					"source $scriptaddr;"
					"%s", env_get("bootcmd"));
	}

	env_set("bootcmd", buf);

	return 0;
}

int board_early_init_r(void)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	if ((dev_desc->if_type == IF_TYPE_MTD) && (dev_desc->devnum == 2)) {
		run_command_list( "sf probe\n"
				"sf read $cramfsaddr 0x400000 0xc00000",
				-1, 0);
	}

	return 0;
}

int board_read_dtb_file(void *fdt_addr)
{
	char buf[32];
	char *argv[3] = {
		"cramfsload",
		buf,
		"rk3568-odroid-m1.dtb"
	};

	snprintf(buf, sizeof(buf), "0x%p", fdt_addr);

	if (do_cramfs_load(NULL, 0, ARRAY_SIZE(argv), argv))
		return 1;

	return fdt_check_header(fdt_addr);
}
