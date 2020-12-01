/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <amp.h>
#include <android_bootloader.h>
#include <android_image.h>
#include <bidram.h>
#include <boot_rkimg.h>
#include <cli.h>
#include <clk.h>
#include <console.h>
#include <debug_uart.h>
#include <dm.h>
#include <dvfs.h>
#include <io-domain.h>
#include <image.h>
#include <key.h>
#include <memblk.h>
#include <misc.h>
#include <of_live.h>
#include <mtd_blk.h>
#include <ram.h>
#include <rockchip_debugger.h>
#include <syscon.h>
#include <sysmem.h>
#include <video_rockchip.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <dm/uclass-internal.h>
#include <dm/root.h>
#include <power/charge_display.h>
#include <power/regulator.h>
#include <optee_include/OpteeClientInterface.h>
#include <optee_include/OpteeClientApiLib.h>
#include <optee_include/tee_api_defines.h>
#include <asm/arch/boot_mode.h>
#include <asm/arch/clock.h>
#include <asm/arch/cpu.h>
#include <asm/arch/hotkey.h>
#include <asm/arch/param.h>
#include <asm/arch/periph.h>
#include <asm/arch/resource_img.h>
#include <asm/arch/rk_atags.h>
#include <asm/arch/vendor.h>

DECLARE_GLOBAL_DATA_PTR;

__weak int rk_board_late_init(void)
{
	return 0;
}

__weak int rk_board_fdt_fixup(void *blob)
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

__weak int rk_board_init(void)
{
	return 0;
}

/*
 * define serialno max length, the max length is 512 Bytes
 * The remaining bytes are used to ensure that the first 512 bytes
 * are valid when executing 'env_set("serial#", value)'.
 */
#define VENDOR_SN_MAX	513
#define CPUID_LEN	0x10
#define CPUID_OFF	0x07

#define MAX_ETHERNET	0x2

static int rockchip_set_ethaddr(void)
{
#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
	char buf[ARP_HLEN_ASCII + 1], mac[16];
	u8 ethaddr[ARP_HLEN * MAX_ETHERNET] = {0};
	int ret, i;
	bool need_write = false;

	ret = vendor_storage_read(VENDOR_LAN_MAC_ID, ethaddr, sizeof(ethaddr));
	for (i = 0; i < MAX_ETHERNET; i++) {
		if (ret <= 0 || !is_valid_ethaddr(&ethaddr[i * ARP_HLEN])) {
			net_random_ethaddr(&ethaddr[i * ARP_HLEN]);
			need_write = true;
		}

		if (is_valid_ethaddr(&ethaddr[i * ARP_HLEN])) {
			sprintf(buf, "%pM", &ethaddr[i * ARP_HLEN]);
			if (i == 0)
				memcpy(mac, "ethaddr", sizeof("ethaddr"));
			else
				sprintf(mac, "eth%daddr", i);
			env_set(mac, buf);
		}
	}

	if (need_write) {
		ret = vendor_storage_write(VENDOR_LAN_MAC_ID,
					   ethaddr, sizeof(ethaddr));
		if (ret < 0)
			printf("%s: vendor_storage_write failed %d\n",
			       __func__, ret);
	}
#endif

	return 0;
}

static int rockchip_set_serialno(void)
{
	u8 low[CPUID_LEN / 2], high[CPUID_LEN / 2];
	u8 cpuid[CPUID_LEN] = {0};
	char serialno_str[VENDOR_SN_MAX];
	int ret = 0, i;
	u64 serialno;

	/* Read serial number from vendor storage part */
	memset(serialno_str, 0, VENDOR_SN_MAX);

#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
	ret = vendor_storage_read(VENDOR_SN_ID, serialno_str, (VENDOR_SN_MAX-1));
	if (ret > 0) {
		i = strlen(serialno_str);
		for (; i > 0; i--) {
			if ((serialno_str[i] >= 'a' && serialno_str[i] <= 'z') ||
			    (serialno_str[i] >= 'A' && serialno_str[i] <= 'Z') ||
			    (serialno_str[i] >= '0' && serialno_str[i] <= '9'))
				break;
		}

		serialno_str[i + 1] = 0x0;
		env_set("serial#", serialno_str);
	} else {
#endif
#if defined(CONFIG_ROCKCHIP_EFUSE) || defined(CONFIG_ROCKCHIP_OTP)
		struct udevice *dev;

		/* retrieve the device */
		if (IS_ENABLED(CONFIG_ROCKCHIP_EFUSE))
			ret = uclass_get_device_by_driver(UCLASS_MISC,
							  DM_GET_DRIVER(rockchip_efuse),
							  &dev);
		else
			ret = uclass_get_device_by_driver(UCLASS_MISC,
							  DM_GET_DRIVER(rockchip_otp),
							  &dev);

		if (ret) {
			printf("%s: could not find efuse/otp device\n", __func__);
			return ret;
		}

		/* read the cpu_id range from the efuses */
		ret = misc_read(dev, CPUID_OFF, &cpuid, sizeof(cpuid));
		if (ret) {
			printf("%s: read cpuid from efuse/otp failed, ret=%d\n",
			       __func__, ret);
			return ret;
		}
#else
		/* generate random cpuid */
		for (i = 0; i < CPUID_LEN; i++)
			cpuid[i] = (u8)(rand());
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
	writel(BOOT_FASTBOOT, CONFIG_ROCKCHIP_BOOT_MODE_REG);

	return 0;
}
#endif

#ifdef CONFIG_ROCKCHIP_USB_BOOT
static int boot_from_udisk(void)
{
	struct blk_desc *desc;
	char *devtype;
	char *devnum;

	devtype = env_get("devtype");
	devnum = env_get("devnum");

	/* Booting priority: mmc1 > udisk */
	if (!strcmp(devtype, "mmc") && !strcmp(devnum, "1"))
		return 0;

	if (!run_command("usb start", -1)) {
		desc = blk_get_devnum_by_type(IF_TYPE_USB, 0);
		if (!desc) {
			printf("No usb device found\n");
			return -ENODEV;
		}

		if (!run_command("rkimgtest usb 0", -1)) {
			rockchip_set_bootdev(desc);
			env_set("devtype", "usb");
			env_set("devnum", "0");
			printf("Boot from usb 0\n");
		} else {
			printf("No usb dev 0 found\n");
			return -ENODEV;
		}
	}

	return 0;
}
#endif

static void env_fixup(void)
{
	struct memblock mem;
	ulong u_addr_r;
	phys_size_t end;
	char *addr_r;

#ifdef ENV_MEM_LAYOUT_SETTINGS1
	const char *env_addr0[] = {
		"scriptaddr", "pxefile_addr_r",
		"fdt_addr_r", "kernel_addr_r", "ramdisk_addr_r",
	};
	const char *env_addr1[] = {
		"scriptaddr1", "pxefile_addr1_r",
		"fdt_addr1_r", "kernel_addr1_r", "ramdisk_addr1_r",
	};
	int i;

	/* 128M is a typical ram size for most platform, so as default here */
	if (gd->ram_size <= SZ_128M) {
		/* Replace orignal xxx_addr_r */
		for (i = 0; i < ARRAY_SIZE(env_addr1); i++) {
			addr_r = env_get(env_addr1[i]);
			if (addr_r)
				env_set(env_addr0[i], addr_r);
		}
	}
#endif
	/* If BL32 is disabled, move kernel to lower address. */
	if (!(gd->flags & GD_FLG_BL32_ENABLED)) {
		addr_r = env_get("kernel_addr_no_bl32_r");
		if (addr_r)
			env_set("kernel_addr_r", addr_r);

		/*
		 * 0x0a200000 and 0x08400000 are rockchip traditional address
		 * of BL32 and ramdisk:
		 *
		 * |------------|------------|
		 * |    BL32    |  ramdisk   |
		 * |------------|------------|
		 *
		 * Move ramdisk to BL32 address to fix sysmem alloc failed
		 * issue on the board with critical memory(ie. 256MB).
		 */
		if (gd->ram_size > SZ_128M && gd->ram_size <= SZ_256M) {
			u_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
			if (u_addr_r == 0x0a200000)
				env_set("ramdisk_addr_r", "0x08400000");
		}

	/* If BL32 is enlarged, move ramdisk right behind it */
	} else {
		mem = param_parse_optee_mem();
		end = mem.base + mem.size;
		u_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
		if (u_addr_r >= mem.base && u_addr_r < end)
			env_set_hex("ramdisk_addr_r", end);
	}
}

static void cmdline_handle(void)
{
#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	struct tag *t;

	t = atags_get_tag(ATAG_PUB_KEY);
	if (t) {
		/* Pass if efuse/otp programmed */
		if (t->u.pub_key.flag == PUBKEY_FUSE_PROGRAMMED)
			env_update("bootargs", "fuse.programmed=1");
		else
			env_update("bootargs", "fuse.programmed=0");
	}
#endif
}

int board_late_init(void)
{
	rockchip_set_ethaddr();
	rockchip_set_serialno();
	setup_download_mode();
#if (CONFIG_ROCKCHIP_BOOT_MODE_REG > 0)
	setup_boot_mode();
#endif
#ifdef CONFIG_ROCKCHIP_USB_BOOT
	boot_from_udisk();
#endif
#ifdef CONFIG_DM_CHARGE_DISPLAY
	charge_display();
#endif
#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_show_logo();
#endif
	env_fixup();
	soc_clk_dump();
	cmdline_handle();

	return rk_board_late_init();
}

static void early_download(void)
{
#if defined(CONFIG_PWRKEY_DNL_TRIGGER_NUM) && \
		(CONFIG_PWRKEY_DNL_TRIGGER_NUM > 0)
	if (pwrkey_download_init())
		printf("Pwrkey download init failed\n");
#endif

#if (CONFIG_ROCKCHIP_BOOT_MODE_REG > 0)
	if (is_hotkey(HK_BROM_DNL)) {
		printf("Enter bootrom download...");
		flushc();
		writel(BOOT_BROM_DOWNLOAD, CONFIG_ROCKCHIP_BOOT_MODE_REG);
		do_reset(NULL, 0, 0, NULL);
		printf("failed!\n");
	}
#endif
}

static void board_debug_init(void)
{
	if (!gd->serial.using_pre_serial &&
	    !(gd->flags & GD_FLG_DISABLE_CONSOLE))
		debug_uart_init();

	if (tstc()) {
		gd->console_evt = getc();
		if (gd->console_evt <= 0x1a) /* 'z' */
			printf("Hotkey: ctrl+%c\n", gd->console_evt + 'a' - 1);
	}

	if (IS_ENABLED(CONFIG_CONSOLE_DISABLE_CLI))
		printf("Cmd interface: disabled\n");
}

#ifdef CONFIG_MTD_BLK
static void board_mtd_blk_map_partitions(void)
{
	struct blk_desc *dev_desc;

	dev_desc = rockchip_get_bootdev();
	if (dev_desc)
		mtd_blk_map_partitions(dev_desc);
}
#endif

int board_init(void)
{
	board_debug_init();

#ifdef DEBUG
	soc_clk_dump();
#endif

#ifdef CONFIG_USING_KERNEL_DTB
#ifdef CONFIG_MTD_BLK
	board_mtd_blk_map_partitions();
#endif
	init_kernel_dtb();
#endif
	early_download();

	/*
	 * pmucru isn't referenced on some platforms, so pmucru driver can't
	 * probe that the "assigned-clocks" is unused.
	 */
	clks_probe();
#ifdef CONFIG_DM_REGULATOR
	if (regulators_enable_boot_on(is_hotkey(HK_REGULATOR)))
		debug("%s: Can't enable boot on regulator\n", __func__);
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
#ifdef CONFIG_ROCKCHIP_DEBUGGER
	return rockchip_debugger_init();
#else
	return 0;
#endif
}

int board_fdt_fixup(void *blob)
{
	/* Common fixup for DRM */
#ifdef CONFIG_DRM_ROCKCHIP
	rockchip_display_fixup(blob);
#endif

	return rk_board_fdt_fixup(blob);
}

#if defined(CONFIG_ARM64_BOOT_AARCH32) || !defined(CONFIG_ARM64)
/*
 * Common for OP-TEE:
 *	64-bit & 32-bit mode: share memory dcache is always enabled;
 *
 * Common for U-Boot:
 *	64-bit mode: MMU table is static defined in rkxxx.c file, all memory
 *		     regions are mapped. That's good to match OP-TEE MMU policy.
 *
 *	32-bit mode: MMU table is setup according to gd->bd->bi_dram[..] where
 *		     the OP-TEE region has been reserved, so it can not be
 *		     mapped(i.e. dcache is disabled). That's *NOT* good to match
 *		     OP-TEE MMU policy.
 *
 * For the data coherence when communication between U-Boot and OP-TEE, U-Boot
 * should follow OP-TEE MMU policy.
 *
 * So 32-bit mode U-Boot should map OP-TEE share memory as dcache enabled.
 */
int board_initr_caches_fixup(void)
{
#ifdef CONFIG_OPTEE_CLIENT
	struct memblock mem;

	mem.base = 0;
	mem.size = 0;

	optee_get_shm_config(&mem.base, &mem.size);
	if (mem.size)
		mmu_set_region_dcache_behaviour(mem.base, mem.size,
						DCACHE_WRITEBACK);
#endif
	return 0;
}
#endif

void arch_preboot_os(uint32_t bootm_state)
{
	if (bootm_state & BOOTM_STATE_OS_PREP)
		hotkey_run(HK_CLI_OS_PRE);
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
	char bootm_mapsize[32];
	char bootm_low[32];
	u64 start, size;
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

#ifdef CONFIG_BIDRAM
int board_bidram_reserve(struct bidram *bidram)
{
	struct memblock mem;
	int ret;

	/* ATF */
	mem = param_parse_atf_mem();
	ret = bidram_reserve(MEM_ATF, mem.base, mem.size);
	if (ret)
		return ret;

	/* PSTORE/ATAGS/SHM */
	mem = param_parse_common_resv_mem();
	ret = bidram_reserve(MEM_SHM, mem.base, mem.size);
	if (ret)
		return ret;

	/* OP-TEE */
	mem = param_parse_optee_mem();
	ret = bidram_reserve(MEM_OPTEE, mem.base, mem.size);
	if (ret)
		return ret;

	return 0;
}

parse_fn_t board_bidram_parse_fn(void)
{
	return param_parse_ddr_mem;
}
#endif

#ifdef CONFIG_ROCKCHIP_AMP
void cpu_secondary_init_r(void)
{
	amp_cpus_on();
}
#endif

int board_init_f_boot_flags(void)
{
	int boot_flags = 0;

	/* pre-loader serial */
#if defined(CONFIG_ROCKCHIP_PRELOADER_SERIAL) && \
    defined(CONFIG_ROCKCHIP_PRELOADER_ATAGS)
	struct tag *t;

	t = atags_get_tag(ATAG_SERIAL);
	if (t) {
		gd->serial.using_pre_serial = 1;
		gd->serial.enable = t->u.serial.enable;
		gd->serial.baudrate = t->u.serial.baudrate;
		gd->serial.addr = t->u.serial.addr;
		gd->serial.id = t->u.serial.id;
		gd->baudrate = CONFIG_BAUDRATE;
		if (!t->u.serial.enable)
			boot_flags |= GD_FLG_DISABLE_CONSOLE;
		debug("preloader: enable=%d, addr=0x%lx, baudrate=%d, id=%d\n",
		      gd->serial.enable, gd->serial.addr,
		      gd->serial.baudrate, gd->serial.id);
	} else
#endif
	{
		gd->baudrate = CONFIG_BAUDRATE;
		gd->serial.baudrate = CONFIG_BAUDRATE;
		gd->serial.addr = CONFIG_DEBUG_UART_BASE;
	}

	/* The highest priority to turn off (override) console */
#if defined(CONFIG_DISABLE_CONSOLE)
	boot_flags |= GD_FLG_DISABLE_CONSOLE;
#endif

	return boot_flags;
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
	const void *blob = gd->fdt_blob;
	const fdt32_t *reg;
	fdt_addr_t addr;
	int node;

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

static void bootm_no_reloc(void)
{
	char *ramdisk_high;
	char *fdt_high;

	if (!env_get_yesno("bootm-no-reloc"))
		return;

	ramdisk_high = env_get("initrd_high");
	fdt_high = env_get("fdt_high");

	if (!fdt_high) {
		env_set_hex("fdt_high", -1UL);
		printf("Fdt ");
	}

	if (!ramdisk_high) {
		env_set_hex("initrd_high", -1UL);
		printf("Ramdisk ");
	}

	if (!fdt_high || !ramdisk_high)
		printf("skip relocation\n");
}

int bootm_board_start(void)
{
	/*
	 * print console record data
	 *
	 * On some rockchip platforms, uart debug and sdmmc pin are multiplex.
	 * If boot from sdmmc mode, the console data would be record in buffer,
	 * we switch to uart debug function in order to print it after loading
	 * images.
	 */
#if defined(CONFIG_CONSOLE_RECORD)
	if (!strcmp("mmc", env_get("devtype")) &&
	    !strcmp("1", env_get("devnum"))) {
		printf("IOMUX: sdmmc => uart debug");
		pinctrl_select_state(gd->cur_serial_dev, "default");
		console_record_print_purge();
	}
#endif
	/* disable bootm relcation to save boot time */
	bootm_no_reloc();

	/* sysmem */
	hotkey_run(HK_SYSMEM);
	sysmem_overflow_check();

	return 0;
}

/*
 * Implement it to support CLI command:
 *   - Android: bootm [aosp addr]
 *   - FIT:     bootm [fit addr]
 *   - uImage:  bootm [uimage addr]
 *
 * Purpose:
 *   - The original bootm command args require fdt addr on AOSP,
 *     which is not flexible on rockchip boot/recovery.img.
 *   - Take Android/FIT/uImage image into sysmem management to avoid image
 *     memory overlap.
 */
#if defined(CONFIG_ANDROID_BOOTLOADER) ||	\
	defined(CONFIG_ROCKCHIP_FIT_IMAGE) ||	\
	defined(CONFIG_ROCKCHIP_UIMAGE)
int board_do_bootm(int argc, char * const argv[])
{
	int format;
	void *img;

	if (argc != 2)
		return 0;

	img = (void *)simple_strtoul(argv[1], NULL, 16);
	format = (genimg_get_format(img));

	/* Android */
#ifdef CONFIG_ANDROID_BOOT_IMAGE
	if (format == IMAGE_FORMAT_ANDROID) {
		struct andr_img_hdr *hdr;
		ulong load_addr;
		ulong size;
		int ret;

		hdr = (struct andr_img_hdr *)img;
		printf("BOOTM: transferring to board Android\n");

#ifdef CONFIG_USING_KERNEL_DTB
		sysmem_free((phys_addr_t)gd->fdt_blob);
		/* erase magic */
		fdt_set_magic((void *)gd->fdt_blob, ~0);
		gd->fdt_blob = NULL;
#endif
		load_addr = env_get_ulong("kernel_addr_r", 16, 0);
		load_addr -= hdr->page_size;
		size = android_image_get_end(hdr) - (ulong)hdr;

		if (!sysmem_alloc_base(MEM_ANDROID, (ulong)hdr, size))
			return -ENOMEM;

		ret = android_image_memcpy_separate(hdr, &load_addr);
		if (ret) {
			printf("board do bootm failed, ret=%d\n", ret);
			return ret;
		}

		return android_bootloader_boot_kernel(load_addr);
	}
#endif

	/* FIT */
#if IMAGE_ENABLE_FIT
	if (format == IMAGE_FORMAT_FIT) {
		char boot_cmd[64];

		printf("BOOTM: transferring to board FIT\n");
		snprintf(boot_cmd, sizeof(boot_cmd), "boot_fit %s", argv[1]);
		return run_command(boot_cmd, 0);
	}
#endif

	/* uImage */
#if defined(CONFIG_IMAGE_FORMAT_LEGACY)
	if (format == IMAGE_FORMAT_LEGACY &&
	    image_get_type(img) == IH_TYPE_MULTI) {
		char boot_cmd[64];

		printf("BOOTM: transferring to board uImage\n");
		snprintf(boot_cmd, sizeof(boot_cmd), "boot_uimage %s", argv[1]);
		return run_command(boot_cmd, 0);
	}
#endif

	return 0;
}
#endif

void autoboot_command_fail_handle(void)
{
#ifdef CONFIG_AVB_VBMETA_PUBLIC_KEY_VALIDATE
#ifdef CONFIG_ANDROID_AB
	run_command("fastboot usb 0;", 0);  /* use fastboot to ative slot */
#else
	run_command("rockusb 0 ${devtype} ${devnum}", 0);
	run_command("fastboot usb 0;", 0);
#endif
#endif
}

#ifdef CONFIG_FIT_ROLLBACK_PROTECT

#define FIT_ROLLBACK_INDEX_LOCATION	0x66697472	/* "fitr" */

int fit_read_otp_rollback_index(uint32_t fit_index, uint32_t *otp_index)
{
#ifdef CONFIG_OPTEE_CLIENT
	u64 index;
	int ret;

	ret = trusty_read_rollback_index(FIT_ROLLBACK_INDEX_LOCATION, &index);
	if (ret) {
		if (ret != TEE_ERROR_ITEM_NOT_FOUND)
			return ret;

		*otp_index = fit_index;
		printf("Initial otp index as %d\n", fit_index);
	}

	*otp_index = index;
#else
	*otp_index = 0;
#endif

	return 0;
}

static int fit_write_trusty_rollback_index(u32 trusty_index)
{
	if (!trusty_index)
		return 0;

	return trusty_write_rollback_index(FIT_ROLLBACK_INDEX_LOCATION,
					   (u64)trusty_index);
}
#endif

void board_quiesce_devices(void *images)
{
	hotkey_run(HK_CMDLINE);
	hotkey_run(HK_CLI_OS_GO);

#ifdef CONFIG_ROCKCHIP_PRELOADER_ATAGS
	/* Destroy atags makes next warm boot safer */
	atags_destroy();
#endif

#ifdef CONFIG_FIT_ROLLBACK_PROTECT
	int ret;

	ret = fit_write_trusty_rollback_index(gd->rollback_index);
	if (ret) {
		panic("Failed to write fit rollback index %d, ret=%d",
		      gd->rollback_index, ret);
	}
#endif

#ifdef CONFIG_ROCKCHIP_HW_DECOMPRESS
	misc_decompress_cleanup();
#endif
}
