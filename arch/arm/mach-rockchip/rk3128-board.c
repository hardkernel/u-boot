/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <clk.h>
#include <dm.h>
#include <ram.h>
#include <syscon.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/periph.h>
#include <asm/arch/grf_rk3128.h>
#include <asm/arch/boot_mode.h>
#include <asm/arch/timer.h>
#include <power/charge_display.h>
#include <power/regulator.h>
#include <video_rockchip.h>

DECLARE_GLOBAL_DATA_PTR;

#define PMU_BASE	0x100a0000

static void setup_boot_mode(void)
{
	struct rk3128_pmu *const pmu = (void *)PMU_BASE;
	int boot_mode = readl(&pmu->sys_reg[0]);

	debug("boot mode %x.\n", boot_mode);

	/* Clear boot mode */
	writel(BOOT_NORMAL, &pmu->sys_reg[0]);

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
	}
}

#ifdef CONFIG_CHARGE_DISPLAY
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

__weak int rk_board_late_init(void)
{
	return 0;
}

int board_late_init(void)
{
	setup_boot_mode();

#ifdef CONFIG_CHARGE_DISPLAY
	charge_display();
#endif

#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_show_logo();
#endif

	return rk_board_late_init();
}

int board_init(void)
{
	int ret = 0;

	rockchip_timer_init();

	ret = regulators_enable_boot_on(false);
	if (ret) {
		debug("%s: Cannot enable boot on regulator\n", __func__);
		return ret;
	}

	return 0;
}

int dram_init_banksize(void)
{
	gd->bd->bi_dram[0].start = CONFIG_SYS_SDRAM_BASE;
	gd->bd->bi_dram[0].size = 0x8400000;
	/* Reserve 0xe00000(14MB) for OPTEE with TA enabled, otherwise 2MB */
	gd->bd->bi_dram[1].start = CONFIG_SYS_SDRAM_BASE
				+ gd->bd->bi_dram[0].size + 0xe00000;
	gd->bd->bi_dram[1].size = gd->bd->bi_dram[0].start
				+ gd->ram_size - gd->bd->bi_dram[1].start;

	return 0;
}

#ifndef CONFIG_SYS_DCACHE_OFF
void enable_caches(void)
{
	/* Enable D-cache. I-cache is already enabled in start.S */
	dcache_enable();
}
#endif

#if defined(CONFIG_USB_GADGET) && defined(CONFIG_USB_GADGET_DWC2_OTG)
#include <usb.h>
#include <usb/dwc2_udc.h>

static struct dwc2_plat_otg_data rk3128_otg_data = {
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
					"rockchip,rk3288-usb");

	while (node > 0) {
		mode = fdt_getprop(blob, node, "dr_mode", NULL);
		if (mode && strcmp(mode, "otg") == 0) {
			matched = true;
			break;
		}

		node = fdt_node_offset_by_compatible(blob, node,
					"rockchip,rk3288-usb");
	}
	if (!matched) {
		debug("Not found usb_otg device\n");
		return -ENODEV;
	}
	rk3128_otg_data.regs_otg = fdtdec_get_addr(blob, node, "reg");

	return dwc2_udc_probe(&rk3128_otg_data);
}

int board_usb_cleanup(int index, enum usb_init_type init)
{
	return 0;
}
#endif

#if defined(CONFIG_USB_FUNCTION_FASTBOOT)
int fb_set_reboot_flag(void)
{
	struct rk3128_grf *grf;

	printf("Setting reboot to fastboot flag ...\n");
	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	/* Set boot mode to fastboot */
	writel(BOOT_FASTBOOT, &grf->os_reg[0]);

	return 0;
}
#endif
