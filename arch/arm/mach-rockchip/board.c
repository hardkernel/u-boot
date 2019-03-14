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
#include <sysmem.h>
#include <asm/io.h>
#include <asm/arch/vendor.h>
#include <misc.h>
#include <asm/gpio.h>
#include <asm/arch/clock.h>
#include <asm/arch/periph.h>
#include <asm/arch/boot_mode.h>
#include <asm/arch/rk_atags.h>
#include <asm/arch/param.h>
#ifdef CONFIG_DM_CHARGE_DISPLAY
#include <power/charge_display.h>
#endif
#ifdef CONFIG_DM_DVFS
#include <dvfs.h>
#endif
#ifdef CONFIG_ROCKCHIP_IO_DOMAIN
#include <io-domain.h>
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
#include <of_live.h>
#include <dm/root.h>
#include <console.h>

DECLARE_GLOBAL_DATA_PTR;
/* define serialno max length, the max length is 512 Bytes
 * The remaining bytes are used to ensure that the first 512 bytes
 * are valid when executing 'env_set("serial#", value)'.
 */
#define VENDOR_SN_MAX	513
#define CPUID_LEN       0x10
#define CPUID_OFF       0x7

static int rockchip_set_ethaddr(void)
{
#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
	int ret;
	u8 ethaddr[ARP_HLEN];
	char buf[ARP_HLEN_ASCII + 1];

	ret = vendor_storage_read(VENDOR_LAN_MAC_ID, ethaddr, sizeof(ethaddr));
	if (ret > 0 && is_valid_ethaddr(ethaddr)) {
		sprintf(buf, "%pM", ethaddr);
		env_set("ethaddr", buf);
	}
#endif
	return 0;
}

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
	rockchip_set_ethaddr();
	rockchip_set_serialno();
#if (CONFIG_ROCKCHIP_BOOT_MODE_REG > 0)
	setup_boot_mode();
#endif

#ifdef CONFIG_DM_CHARGE_DISPLAY
	charge_display();
#endif

#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_show_logo();
#endif

	soc_clk_dump();

	return rk_board_late_init();
}

#ifdef CONFIG_USING_KERNEL_DTB
#include <asm/arch/resource_img.h>

int init_kernel_dtb(void)
{
	int ret = 0;
	ulong fdt_addr = 0;

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

	/* Reserve 'reserved-memory' */
	ret = boot_fdt_add_sysmem_rsv_regions((void *)gd->fdt_blob);
	if (ret)
		return ret;

	return 0;
}
#endif

void board_env_fixup(void)
{
	ulong kernel_addr_r;

	if (gd->flags & GD_FLG_BL32_ENABLED)
		return;

	/* If bl32 is disabled, maybe kernel can be load to lower address. */
	kernel_addr_r = env_get_ulong("kernel_addr_no_bl32_r", 16, -1);
	if (kernel_addr_r != -1)
		env_set_hex("kernel_addr_r", kernel_addr_r);
}

static void early_bootrom_download(void)
{
	if (!tstc())
		return;

	gd->console_evt = getc();
#if (CONFIG_ROCKCHIP_BOOT_MODE_REG > 0)
	/* ctrl+b */
	if (gd->console_evt == CONSOLE_EVT_CTRL_B) {
		printf("Enter bootrom download...");
		mdelay(100);
		writel(BOOT_BROM_DOWNLOAD, CONFIG_ROCKCHIP_BOOT_MODE_REG);
		do_reset(NULL, 0, 0, NULL);
		printf("failed!\n");
	}
#endif
}

int board_init(void)
{
	int ret;

	board_debug_uart_init();
	early_bootrom_download();

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

#ifdef CONFIG_ROCKCHIP_IO_DOMAIN
	io_domain_init();
#endif

	set_armclk_rate();

#ifdef CONFIG_DM_DVFS
	dvfs_init(true);
#endif

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

#if defined(CONFIG_ROCKCHIP_RK1808) && !defined(CONFIG_COPROCESSOR_RK1808)
#define PINCTRL_EMMC_BUS8_PATH		"/pinctrl/emmc/emmc-bus8"
#define PINCTRL_EMMC_CMD_PATH		"/pinctrl/emmc/emmc-cmd"
#define PINCTRL_EMMC_CLK_PATH		"/pinctrl/emmc/emmc-clk"
#define PINCTRL_PCFG_PU_2MA_PATH	"/pinctrl/pcfg-pull-up-2ma"
#define MAX_ROCKCHIP_PINS_ENTRIES	12

static int rockchip_pinctrl_cfg_fdt_fixup(const char *path, u32 new_phandle)
{
	u32 cells[MAX_ROCKCHIP_PINS_ENTRIES * 4];
	const u32 *data;
	int i, count;
	int node;

	node = fdt_path_offset(gd->fdt_blob, path);
	if (node < 0) {
		debug("%s: can't find: %s\n", __func__, path);
		return node;
	}

	data = fdt_getprop(gd->fdt_blob, node, "rockchip,pins", &count);
	if (!data) {
		debug("%s: can't find prop \"rockchip,pins\"\n", __func__);
		return -ENODATA;
	}

	count /= sizeof(u32);
	if (count > MAX_ROCKCHIP_PINS_ENTRIES * 4) {
		debug("%s: %d is over max count\n", __func__, count);
		return -EINVAL;
	}

	for (i = 0; i < count; i++)
		cells[i] = data[i];

	for (i = 0; i < (count >> 2); i++)
		cells[4 * i + 3] = cpu_to_fdt32(new_phandle);

	fdt_setprop((void *)gd->fdt_blob, node, "rockchip,pins",
		    &cells, count * sizeof(u32));

	return 0;
}
#endif

int board_fdt_fixup(void *blob)
{
	int ret = 0;

	/*
	 * Common fixup for DRM
	 */
#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_display_fixup(blob);
#endif

	/*
	 * Platform fixup:
	 *
	 * - RK3288: Recognize RK3288W by HDMI Revision ID is 0x1A;
	 * - RK1808: MMC strength 2mA;
	 */
#ifdef CONFIG_ROCKCHIP_RK3288
	if (readl(0xff980004) == 0x1A) {
		ret = fdt_setprop_string(blob, 0,
					 "compatible", "rockchip,rk3288w");
		if (ret)
			printf("fdt set compatible failed: %d\n", ret);
	}
#elif defined(CONFIG_ROCKCHIP_RK1808) && !defined(CONFIG_COPROCESSOR_RK1808)
	struct tag *t;
	u32 ph_pu_2ma;

	t = atags_get_tag(ATAG_SOC_INFO);
	if (!t)
		return 0;

	debug("soc=0x%x, flags=0x%x\n", t->u.soc.name, t->u.soc.flags);

	if (t->u.soc.flags != SOC_FLAGS_ET00)
		return 0;

	ph_pu_2ma = fdt_get_phandle(gd->fdt_blob,
		    fdt_path_offset(gd->fdt_blob, PINCTRL_PCFG_PU_2MA_PATH));
	if (!ph_pu_2ma) {
		debug("Can't find: %s\n", PINCTRL_PCFG_PU_2MA_PATH);
		return -EINVAL;
	}

	ret |= rockchip_pinctrl_cfg_fdt_fixup(PINCTRL_EMMC_BUS8_PATH, ph_pu_2ma);
	ret |= rockchip_pinctrl_cfg_fdt_fixup(PINCTRL_EMMC_CMD_PATH, ph_pu_2ma);
	ret |= rockchip_pinctrl_cfg_fdt_fixup(PINCTRL_EMMC_CLK_PATH, ph_pu_2ma);
#endif

	return ret;
}

void board_quiesce_devices(void)
{
#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	/* Destroy atags makes next warm boot safer */
	atags_destroy();
#endif
}

void enable_caches(void)
{
	icache_enable();
	dcache_enable();
}

#ifdef CONFIG_LMB
/*
 * Using last bi_dram[...] to initialize "bootm_low" and "bootm_mapsize".
 * This makes lmb_alloc_base() always alloc from tail of sdram.
 * If we don't assign it, bi_dram[0] is used by default and it may cause
 * lmb_alloc_base() fail when bi_dram[0] range is small.
 */
void board_lmb_reserve(struct lmb *lmb)
{
	u64 start, size;
	char bootm_low[32];
	char bootm_mapsize[32];
	int i;

	for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		if (!gd->bd->bi_dram[i].size)
			break;
	}

	start = gd->bd->bi_dram[i - 1].start;
	size = gd->bd->bi_dram[i - 1].size;

	/*
	 * 32-bit kernel: ramdisk/fdt shouldn't be loaded to highmem area(768MB+),
	 * otherwise "Unable to handle kernel paging request at virtual address ...".
	 *
	 * So that we hope limit highest address at 768M, but there comes the the
	 * problem: ramdisk is a compressed image and it expands after descompress,
	 * so it accesses 768MB+ and brings the above "Unable to handle kernel ...".
	 *
	 * We make a appointment that the highest memory address is 512MB, it
	 * makes lmb alloc safer.
	 */
#ifndef CONFIG_ARM64
	if (start >= ((u64)CONFIG_SYS_SDRAM_BASE + SZ_512M)) {
		start = gd->bd->bi_dram[i - 2].start;
		size = gd->bd->bi_dram[i - 2].size;
	}

	if ((start + size) > ((u64)CONFIG_SYS_SDRAM_BASE + SZ_512M))
		size = (u64)CONFIG_SYS_SDRAM_BASE + SZ_512M - start;
#endif
	sprintf(bootm_low, "0x%llx", start);
	sprintf(bootm_mapsize, "0x%llx", size);
	env_set("bootm_low", bootm_low);
	env_set("bootm_mapsize", bootm_mapsize);
}
#endif

#ifdef CONFIG_SYSMEM
int board_sysmem_reserve(struct sysmem *sysmem)
{
	struct sysmem_property prop;
	int ret;

	/* ATF */
	prop = param_parse_atf_mem();
	ret = sysmem_reserve(prop.name, prop.base, prop.size);
	if (ret)
		return ret;

	/* PSTORE/ATAGS/SHM */
	prop = param_parse_common_resv_mem();
	ret = sysmem_reserve(prop.name, prop.base, prop.size);
	if (ret)
		return ret;

	/* OP-TEE */
	prop = param_parse_optee_mem();
	ret = sysmem_reserve(prop.name, prop.base, prop.size);
	if (ret)
		return ret;

	return 0;
}
#endif

#if defined(CONFIG_ROCKCHIP_PRELOADER_SERIAL) && \
    defined(CONFIG_ROCKCHIP_PRELOADER_ATAGS)
int board_init_f_init_serial(void)
{
	struct tag *t = atags_get_tag(ATAG_SERIAL);

	if (t) {
		gd->serial.using_pre_serial = t->u.serial.enable;
		gd->serial.addr = t->u.serial.addr;
		gd->serial.baudrate = t->u.serial.baudrate;
		gd->serial.id = t->u.serial.id;

		debug("%s: enable=%d, addr=0x%lx, baudrate=%d, id=%d\n",
		      __func__, gd->serial.using_pre_serial,
		      gd->serial.addr, gd->serial.baudrate,
		      gd->serial.id);
	}

	return 0;
}
#endif

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
	fdt_addr_t addr;
	const fdt32_t *reg;
	const void *blob = gd->fdt_blob;

	/* find the usb_otg node */
	node = fdt_node_offset_by_compatible(blob, -1, "snps,dwc2");

retry:
	if (node > 0) {
		reg = fdt_getprop(blob, node, "reg", NULL);
		if (!reg)
			return -EINVAL;

		addr = fdt_translate_address(blob, node, reg);
		if (addr == OF_BAD_ADDR) {
			pr_err("Not found usb_otg address\n");
			return -EINVAL;
		}

#if defined(CONFIG_ROCKCHIP_RK3288)
		if (addr != 0xff580000) {
			node = fdt_node_offset_by_compatible(blob, node,
							     "snps,dwc2");
			goto retry;
		}
#endif
	} else {
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
			goto retry;
		} else {
			pr_err("Not found usb_otg device\n");
			return -ENODEV;
		}
	}

	otg_data.regs_otg = (uintptr_t)addr;

	return dwc2_udc_probe(&otg_data);
}

int board_usb_cleanup(int index, enum usb_init_type init)
{
	return 0;
}
#endif
