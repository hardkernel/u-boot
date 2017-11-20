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
#include <asm/gpio.h>
#include <asm/arch/clock.h>
#include <asm/arch/periph.h>
#include <asm/arch/timer.h>
#include <asm/arch/grf_rk322x.h>
#include <asm/arch/boot_mode.h>

DECLARE_GLOBAL_DATA_PTR;

#define TRUST_PARAMETER_OFFSET    (34 * 1024 * 1024)

struct tos_parameter_t {
	u32 version;
	u32 checksum;
	struct {
		char name[8];
		s64 phy_addr;
		u32 size;
		u32 flags;
	}tee_mem;
	struct {
		char name[8];
		s64 phy_addr;
		u32 size;
		u32 flags;
	}drm_mem;
	s64 reserve[8];
};

#if defined(CONFIG_USB_FUNCTION_FASTBOOT)
int fb_set_reboot_flag(void)
{
	struct rk322x_grf *grf;

	printf("Setting reboot to fastboot flag ...\n");
	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	/* Set boot mode to fastboot */
	writel(BOOT_FASTBOOT, &grf->os_reg[0]);

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

	setup_boot_mode();

	return rk_board_late_init();
}

int board_init(void)
{
#include <asm/arch/grf_rk322x.h>
	/* Enable early UART2 channel 1 on the RK322x */
#define GRF_BASE	0x11000000
	struct rk322x_grf * const grf = (void *)GRF_BASE;

	rk_clrsetreg(&grf->gpio1b_iomux,
		     GPIO1B1_MASK | GPIO1B2_MASK,
		     GPIO1B2_UART21_SIN << GPIO1B2_SHIFT |
		     GPIO1B1_UART21_SOUT << GPIO1B1_SHIFT);
	/* Set channel C as UART2 input */
	rk_clrsetreg(&grf->con_iomux,
		     CON_IOMUX_UART2SEL_MASK,
		     CON_IOMUX_UART2SEL_21 << CON_IOMUX_UART2SEL_SHIFT);

	/*
	* The integrated macphy is enabled by default, disable it
	* for saving power consuming.
	*/
	rk_clrsetreg(&grf->macphy_con[0],
		     MACPHY_CFG_ENABLE_MASK,
		     0 << MACPHY_CFG_ENABLE_SHIFT);

	rockchip_timer_init();

	return 0;
}

int dram_init_banksize(void)
{
	struct tos_parameter_t *tos_parameter;
	tos_parameter = (struct tos_parameter_t *)(CONFIG_SYS_SDRAM_BASE +
			TRUST_PARAMETER_OFFSET);
	if (tos_parameter->tee_mem.flags == 1) {
		gd->bd->bi_dram[0].start = CONFIG_SYS_SDRAM_BASE;
		gd->bd->bi_dram[0].size = tos_parameter->tee_mem.phy_addr
					- CONFIG_SYS_SDRAM_BASE;
		gd->bd->bi_dram[1].start = tos_parameter->tee_mem.phy_addr +
					tos_parameter->tee_mem.size;
		gd->bd->bi_dram[1].size = gd->bd->bi_dram[0].start
					+ gd->ram_size - gd->bd->bi_dram[1].start;
	} else {
		gd->bd->bi_dram[0].start = CONFIG_SYS_SDRAM_BASE;
		gd->bd->bi_dram[0].size = 0x8400000;
		/* Reserve 32M for OPTEE with TA */
		gd->bd->bi_dram[1].start = CONFIG_SYS_SDRAM_BASE
				+ gd->bd->bi_dram[0].size + 0x2000000;
		gd->bd->bi_dram[1].size = gd->bd->bi_dram[0].start
				+ gd->ram_size - gd->bd->bi_dram[1].start;
	}

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

static struct dwc2_plat_otg_data rk322x_otg_data = {
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
	rk322x_otg_data.regs_otg = fdtdec_get_addr(blob, node, "reg");

	return dwc2_udc_probe(&rk322x_otg_data);
}

int board_usb_cleanup(int index, enum usb_init_type init)
{
	return 0;
}
#endif

