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
#include <mapmem.h>
#include <fs.h>
#if defined(CONFIG_RKSFC_NOR)
#include <rksfc.h>
#endif
#include <environment.h>
#include <fdt_support.h>
#include <odroid-common.h>

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

int board_early_init_r(void)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	int ret = -EINVAL;
	char buf[16];
	char cmd[256];
	char env[CONFIG_ENV_SIZE];
	int n;

#if defined(CONFIG_RKSFC_NOR)
	if (dev_desc->if_type == IF_TYPE_MMC)
		rksfc_scan_namespace();
#endif

	/* Clear memory at $crarmfsaddr */
	memset((void*)addr, 0, 256);

	for (n = 1; n <= 3; n++) {
		snprintf(buf, sizeof(buf), "%d:%d", dev_desc->devnum, n);

		if (file_exists("mmc", buf, "ODROIDBIOS.BIN", FS_TYPE_ANY)) {
			snprintf(cmd, sizeof(cmd),
					"load mmc %s $cramfsaddr ODROIDBIOS.BIN", buf);
			ret = run_command(cmd, 0);
			if (!ret)
				break;
		}
	}

	run_command("sf probe", 0);
	if (ret)
		run_command("sf read $cramfsaddr 0x400000 0xc00000", 0);

	snprintf(cmd, sizeof(cmd), "sf read 0x%p 0x%p 0x%p\n",
			env, (void*)CONFIG_ENV_OFFSET, (void*)CONFIG_ENV_SIZE);
	if (run_command(cmd, 0) == 0) {
		env_t *ep = (env_t *)env;
		uint32_t crc;

		memcpy(&crc, &ep->crc, sizeof(crc));
		if (crc32(0, ep->data, ENV_SIZE) == crc) {
			struct hsearch_data env_htab = {
				.change_ok = env_flags_validate,
			};

			if (himport_r(&env_htab, env, ENV_SIZE, '\0', 0, 0, 0, NULL)) {
				ENTRY e, *ep;

				e.key = "panel";
				e.data = NULL;

				hsearch_r(e, FIND, &ep, &env_htab, 0);
				set_panel_name(ep->data);
			}
		}
	}

	return 0;
}
