/*
 * (C) Copyright 2017 Paweł Jarosz <paweljarosz3691@gmail.com>
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
#include <asm/arch/grf_rk3066.h>
#include <asm/arch/periph.h>
#include <asm/arch/pmu_rk3188.h>
#include <asm/arch/boot_mode.h>
#include <asm/gpio.h>
#include <dm/pinctrl.h>

DECLARE_GLOBAL_DATA_PTR;

int board_late_init(void)
{
	struct rk3066_grf *grf;

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	if (IS_ERR(grf)) {
		debug("grf syscon returned %ld\n", PTR_ERR(grf));
		return PTR_ERR(grf);
	}
	/* enable noc remap to mimic legacy loaders */
	rk_clrsetreg(&grf->soc_con0, NOC_REMAP_MASK, NOC_REMAP_MASK);

	return 0;
}

int board_init(void)
{
#if defined(CONFIG_ROCKCHIP_SPL_BACK_TO_BROM)
	struct udevice *pinctrl;
	int ret;

	/*
	 * We need to implement sdcard iomux here for the further
	 * initialization, otherwise, it'll hit sdcard command sending
	 * timeout exception.
	 */
	ret = uclass_get_device(UCLASS_PINCTRL, 0, &pinctrl);
	if (ret) {
		debug("%s: Cannot find pinctrl device\n", __func__);
		goto err;
	}
	ret = pinctrl_request_noflags(pinctrl, PERIPH_ID_SDCARD);
	if (ret) {
		debug("%s: Failed to set up SD card\n", __func__);
		goto err;
	}

	return 0;
err:
	debug("board_init: Error %d\n", ret);

	/* No way to report error here */
	hang();

	return -1;
#else
	return 0;
#endif
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

static struct dwc2_plat_otg_data rk3066_otg_data = {
	.rx_fifo_sz	= 275,
	.np_tx_fifo_sz	= 16,
	.tx_fifo_sz	= 256,
};

int board_usb_init(int index, enum usb_init_type init)
{
	ofnode otg_node;
	u32 reg;

	otg_node = ofnode_path("/usb@10180000");
	if (!ofnode_valid(otg_node)) {
		debug("Not found usb otg device\n");
		return -ENODEV;
	}

	ofnode_read_u32(otg_node, "reg", &reg);
	rk3066_otg_data.regs_otg = reg;

	return dwc2_udc_probe(&rk3066_otg_data);
}

int board_usb_cleanup(int index, enum usb_init_type init)
{
	return 0;
}
#endif
