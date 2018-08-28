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
#include <asm/arch/vendor.h>
#include <misc.h>
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
#ifdef CONFIG_ROCKCHIP_DEBUGGER
#include <rockchip_debugger.h>
#endif
#include <mmc.h>
#include <of_live.h>
#include <dm/root.h>

DECLARE_GLOBAL_DATA_PTR;
/* define serialno max length, the max length is 512 Bytes
 * The remaining bytes are used to ensure that the first 512 bytes
 * are valid when executing 'env_set("serial#", value)'.
 */
#define VENDOR_SN_MAX	513
#define CPUID_LEN       0x10
#define CPUID_OFF       0x7

static int rockchip_set_serialno(void)
{
	char serialno_str[VENDOR_SN_MAX];
	int ret = 0, i;
	u8 cpuid[CPUID_LEN] = {0};
	u8 low[CPUID_LEN / 2], high[CPUID_LEN / 2];
	u64 serialno;

	/* Read serial number from vendor storage part */
	memset(serialno_str, 0, VENDOR_SN_MAX);
#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
	ret = vendor_storage_read(VENDOR_SN_ID, serialno_str, (VENDOR_SN_MAX-1));
	if (ret > 0) {
		env_set("serial#", serialno_str);
	} else {
#endif
#ifdef CONFIG_ROCKCHIP_EFUSE
		struct udevice *dev;

		/* retrieve the device */
		ret = uclass_get_device_by_driver(UCLASS_MISC,
						  DM_GET_DRIVER(rockchip_efuse), &dev);
		if (ret) {
			printf("%s: could not find efuse device\n", __func__);
			return ret;
		}
		/* read the cpu_id range from the efuses */
		ret = misc_read(dev, CPUID_OFF, &cpuid, sizeof(cpuid));
		if (ret) {
			printf("%s: reading cpuid from the efuses failed\n", __func__);
			return ret;
		}
#else
		/* generate random cpuid */
		for (i = 0; i < CPUID_LEN; i++) {
			cpuid[i] = (u8)(rand());
		}
#endif
		/* Generate the serial number based on CPU ID */
		for (i = 0; i < 8; i++) {
			low[i] = cpuid[1 + (i << 1)];
			high[i] = cpuid[i << 1];
		}
		serialno = crc32_no_comp(0, low, 8);
		serialno |= (u64)crc32_no_comp(serialno, high, 8) << 32;
		snprintf(serialno_str, sizeof(serialno_str), "%llx", serialno);

		env_set("serial#", serialno_str);
#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
	}
#endif
	return ret;
}

#if defined(CONFIG_USB_FUNCTION_FASTBOOT)
int fb_set_reboot_flag(void)
{
	printf("Setting reboot to fastboot flag ...\n");
	/* Set boot mode to fastboot */
	writel(BOOT_FASTBOOT, CONFIG_ROCKCHIP_BOOT_MODE_REG);

	return 0;
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
			debug("Get UCLASS CHARGE DISPLAY failed: %d\n", ret);
			return ret;
		} else {
			debug("Can't find charge display driver\n");
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

__weak int soc_clk_dump(void)
{
	return 0;
}

__weak int set_armclk_rate(void)
{
	return 0;
}

int board_late_init(void)
{
#if (CONFIG_ROCKCHIP_BOOT_MODE_REG > 0)
	setup_boot_mode();
#endif

#ifdef CONFIG_DM_CHARGE_DISPLAY
	charge_display();
#endif

#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_show_logo();
#endif
	rockchip_set_serialno();

	soc_clk_dump();

	return rk_board_late_init();
}

#ifdef CONFIG_USING_KERNEL_DTB
#include <asm/arch/resource_img.h>

int init_kernel_dtb(void)
{
	int ret = 0;
	ulong fdt_addr = 0;

	ret = mmc_initialize(gd->bd);
	if (ret)
		debug("%s mmc initialized fail\n", __func__);

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

	printf("Using kernel dtb\n");

	return 0;
}
#endif


int board_init(void)
{
	int ret;

	board_debug_uart_init();

#ifdef CONFIG_USING_KERNEL_DTB
	init_kernel_dtb();
#endif
	/*
	 * pmucru isn't referenced on some platforms, so pmucru driver can't
	 * probe that the "assigned-clocks" is unused.
	 */
	clks_probe();
#ifdef CONFIG_DM_REGULATOR
	ret = regulators_enable_boot_on(false);
	if (ret)
		debug("%s: Cannot enable boot on regulator\n", __func__);
#endif
	set_armclk_rate();

	return rk_board_init();
}

int interrupt_debugger_init(void)
{
	int ret = 0;

#ifdef CONFIG_ROCKCHIP_DEBUGGER
	ret = rockchip_debugger_init();
#endif
	return ret;
}

int board_fdt_fixup(void *blob)
{
	__maybe_unused int ret = 0;

#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_display_fixup(blob);
#endif

#ifdef CONFIG_ROCKCHIP_RK3288
	/* RK3288W HDMI Revision ID is 0x1A */
	if (readl(0xff980004) == 0x1A) {
		ret = fdt_setprop_string(blob, 0,
					 "compatible", "rockchip,rk3288w");
		if (ret)
			printf("fdt set compatible failed: %d\n", ret);
	}
#endif

	return ret;
}

void enable_caches(void)
{
	icache_enable();
	dcache_enable();
}

#if defined(CONFIG_USB_GADGET) && defined(CONFIG_USB_GADGET_DWC2_OTG)
#include <fdt_support.h>
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
	fdt_addr_t addr;
	const fdt32_t *reg;
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
		/*
		 * With kernel dtb support, rk3288 dwc2 otg node
		 * use the rockchip legacy dwc2 driver "dwc_otg_310"
		 * with the compatible "rockchip,rk3288_usb20_otg",
		 * and rk3368 also use the "dwc_otg_310" driver with
		 * the compatible "rockchip,rk3368-usb".
		 */
#if defined(CONFIG_ROCKCHIP_RK3288)
		node = fdt_node_offset_by_compatible(blob, -1,
				"rockchip,rk3288_usb20_otg");
#elif defined(CONFIG_ROCKCHIP_RK3368)
		node = fdt_node_offset_by_compatible(blob, -1,
				"rockchip,rk3368-usb");
#endif

		if (node > 0) {
			matched = true;
		} else {
			pr_err("Not found usb_otg device\n");
			return -ENODEV;
		}
	}

	reg = fdt_getprop(blob, node, "reg", NULL);
	if (!reg)
		return -EINVAL;

	addr = fdt_translate_address(blob, node, reg);
	if (addr == OF_BAD_ADDR) {
		pr_err("Not found usb_otg address\n");
		return -EINVAL;
	}

	otg_data.regs_otg = (uintptr_t)addr;

	return dwc2_udc_probe(&otg_data);
}

int board_usb_cleanup(int index, enum usb_init_type init)
{
	return 0;
}
#endif
