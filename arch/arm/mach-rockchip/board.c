/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <clk.h>
#include <dm.h>
#include <debug_uart.h>
#include <ram.h>
#include <syscon.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <asm/arch/clock.h>
#include <asm/arch/periph.h>
#include <asm/arch/boot_mode.h>
#ifdef CONFIG_DM_CHARGE_DISPLAY
#include <power/charge_display.h>
#endif
#ifdef CONFIG_DM_REGULATOR
#include <power/regulator.h>
#endif
#ifdef CONFIG_DRM_ROCKCHIP
#include <video_rockchip.h>
#endif
#include <mmc.h>
#include <of_live.h>
#include <dm/root.h>

DECLARE_GLOBAL_DATA_PTR;

#if defined(CONFIG_USB_FUNCTION_FASTBOOT)
int fb_set_reboot_flag(void)
{
	printf("Setting reboot to fastboot flag ...\n");
	/* Set boot mode to fastboot */
	writel(BOOT_FASTBOOT, CONFIG_ROCKCHIP_BOOT_MODE_REG);

	return 0;
}

#define FASTBOOT_KEY_GPIO 43 /* GPIO1_B3 */
static int fastboot_key_pressed(void)
{
	gpio_request(FASTBOOT_KEY_GPIO, "fastboot_key");
	gpio_direction_input(FASTBOOT_KEY_GPIO);
	return !gpio_get_value(FASTBOOT_KEY_GPIO);
}
#endif

#ifdef CONFIG_DM_CHARGE_DISPLAY
static int charge_display(void)
{
	int ret;
	struct udevice *dev;

	ret = uclass_get_device(UCLASS_CHARGE_DISPLAY, 0, &dev);
	if (ret) {
		if (ret != -ENODEV) {
			printf("Get UCLASS CHARGE DISPLAY failed: %d\n", ret);
			return ret;
		}
		return 0;
	}

	return charge_display_show(dev);
}
#endif

__weak int rk_board_init(void)
{
	return 0;
}

__weak int rk_board_late_init(void)
{
	return 0;
}

int board_late_init(void)
{
#if defined(CONFIG_USB_FUNCTION_FASTBOOT)
	if (fastboot_key_pressed()) {
		printf("fastboot key pressed!\n");
		fb_set_reboot_flag();
	}
#endif

#if (CONFIG_ROCKCHIP_BOOT_MODE_REG > 0)
	setup_boot_mode();
#endif

#ifdef CONFIG_DM_CHARGE_DISPLAY
	charge_display();
#endif

#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_show_logo();
#endif

	return rk_board_late_init();
}

#ifdef CONFIG_USING_KERNEL_DTB
#include <asm/arch/resource_img.h>

int init_kernel_dtb(void)
{
	int ret = 0;
	struct mmc *mmc;
	struct udevice *dev;
	ulong fdt_addr = 0;

	ret = mmc_initialize(gd->bd);
	if (ret)
		goto scan_nand;
	mmc = find_mmc_device(0);
	if (!mmc) {
		printf("no mmc device at slot 0\n");
		goto scan_nand;
	}
	ret = mmc_init(mmc);
	if (!ret)
		goto init_dtb;
	printf("%s mmc init fail %d\n", __func__, ret);
scan_nand:
	ret = uclass_get_device(UCLASS_RKNAND, 0, &dev);
	if (ret) {
		printf("%s: Cannot find rknand device\n", __func__);
		return -1;
	}

init_dtb:
	fdt_addr = env_get_ulong("fdt_addr_r", 16, 0);
	if (!fdt_addr) {
		printf("No Found FDT Load Address.\n");
		return -1;
	}

	ret = rockchip_read_dtb_file((void *)fdt_addr);
	if (ret < 0) {
		printf("%s dtb in resource read fail\n", __func__);
		return 0;
	}

	of_live_build((void *)fdt_addr, (struct device_node **)&gd->of_root);

	dm_scan_fdt((void *)fdt_addr, false);

	gd->fdt_blob = (void *)fdt_addr;

	return 0;
}
#endif


int board_init(void)
{
	int ret;

#if !defined(CONFIG_SUPPORT_SPL)
	board_debug_uart_init();
#endif
#ifdef CONFIG_USING_KERNEL_DTB
	init_kernel_dtb();
#endif
#ifdef CONFIG_DM_REGULATOR
	ret = regulators_enable_boot_on(false);
	if (ret)
		debug("%s: Cannot enable boot on regulator\n", __func__);
#endif

	return rk_board_init();
}

#if !defined(CONFIG_SYS_DCACHE_OFF) && !defined(CONFIG_ARM64)
void enable_caches(void)
{
	/* Enable D-cache. I-cache is already enabled in start.S */
	dcache_enable();
}
#endif

#if defined(CONFIG_USB_GADGET) && defined(CONFIG_USB_GADGET_DWC2_OTG)
#include <usb.h>
#include <usb/dwc2_udc.h>

static struct dwc2_plat_otg_data otg_data = {
	.rx_fifo_sz	= 512,
	.np_tx_fifo_sz	= 16,
	.tx_fifo_sz	= 128,
};

int board_usb_init(int index, enum usb_init_type init)
{
	int node;
	const char *mode;
	bool matched = false;
	const void *blob = gd->fdt_blob;

	/* find the usb_otg node */
	node = fdt_node_offset_by_compatible(blob, -1,
					"snps,dwc2");

	while (node > 0) {
		mode = fdt_getprop(blob, node, "dr_mode", NULL);
		if (mode && strcmp(mode, "otg") == 0) {
			matched = true;
			break;
		}

		node = fdt_node_offset_by_compatible(blob, node,
					"snps,dwc2");
	}
	if (!matched) {
		debug("Not found usb_otg device\n");
		return -ENODEV;
	}
	otg_data.regs_otg = fdtdec_get_addr(blob, node, "reg");

	return dwc2_udc_probe(&otg_data);
}

int board_usb_cleanup(int index, enum usb_init_type init)
{
	return 0;
}
#endif
