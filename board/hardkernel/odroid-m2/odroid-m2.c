/*
 * SPDX-License-Identifier:     GPL-2.0+
 *
 * (C) Copyright 2024 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <asm/io.h>
#include <boot_rkimg.h>
#include <dwc3-uboot.h>
#include <environment.h>
#include <linux/usb/phy-rockchip-usbdp.h>
#include <rockusb.h>
#include <usb.h>
#include <odroid-common.h>

DECLARE_GLOBAL_DATA_PTR;

#ifdef CONFIG_USB_DWC3
#define CRU_BASE		0xfd7c0000
#define CRU_SOFTRST_CON42	0x0aa8

static struct dwc3_device dwc3_device_data = {
	.maximum_speed = USB_SPEED_SUPER,
	.base = 0xfc000000,
	.dr_mode = USB_DR_MODE_PERIPHERAL,
	.index = 0,
	.dis_u2_susphy_quirk = 1,
	.dis_u1u2_quirk = 1,
	.usb2_phyif_utmi_width = 16,
};

int usb_gadget_handle_interrupts(int index)
{
	dwc3_uboot_handle_interrupt(0);
	return 0;
}

bool rkusb_usb3_capable(void)
{
	return true;
}

static void usb_reset_otg_controller(void)
{
	writel(0x00100010, CRU_BASE + CRU_SOFTRST_CON42);
	mdelay(1);
	writel(0x00100000, CRU_BASE + CRU_SOFTRST_CON42);
	mdelay(1);
}

int board_usb_init(int index, enum usb_init_type init)
{
	u32 ret = 0;

	usb_reset_otg_controller();

#if defined(CONFIG_SUPPORT_USBPLUG)
	dwc3_device_data.maximum_speed = USB_SPEED_HIGH;

	if (rkusb_switch_usb3_enabled()) {
		dwc3_device_data.maximum_speed = USB_SPEED_SUPER;
		ret = rockchip_u3phy_uboot_init();
		if (ret) {
			rkusb_force_to_usb2(true);
			dwc3_device_data.maximum_speed = USB_SPEED_HIGH;
		}
	}
#else
	ret = rockchip_u3phy_uboot_init();
	if (ret) {
		rkusb_force_to_usb2(true);
		dwc3_device_data.maximum_speed = USB_SPEED_HIGH;
	}
#endif

	return dwc3_uboot_init(&dwc3_device_data);
}

#if defined(CONFIG_SUPPORT_USBPLUG)
int board_usb_cleanup(int index, enum usb_init_type init)
{
	dwc3_uboot_exit(index);
	return 0;
}
#endif

#endif

int board_early_init_r(void)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	unsigned long addr = simple_strtoul(env_get("cramfsaddr"), NULL, 16);
#if defined(CONFIG_ENV_SIZE) && defined(CONFIG_ENV_OFFSET)
	char env[CONFIG_ENV_SIZE];
#endif
	int ret = -EINVAL;
	int n;

	/* GPIO Init */
	odroid_gpio_init(74, 0); // 'gpiochip2/gpio10'

#if defined(CONFIG_ENV_SIZE) && defined(CONFIG_ENV_OFFSET)
	/* Load environment value for display panel at very early stage */
	int sectors = CONFIG_ENV_SIZE / 512;
	int count = blk_dread(dev_desc, CONFIG_ENV_OFFSET / 512, sectors, (void*)env);
	if (count == sectors) {
		const char *panel = getenv_raw(env, CONFIG_ENV_SIZE, "panel");
		if (panel)
			set_panel_name(panel);
	}
#endif
	/* Clear memory at $crarmfsaddr */
	memset((void*)addr, 0, 256);

	for (n = 1; n <= 3; n++) {
		ret = load_from_mmc(addr, dev_desc->devnum, n, "ODROIDBIOS.BIN");
		if (!ret)
			return 0;
	}

	return 0;
}
