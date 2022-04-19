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
#include <malloc.h>
#include <mapmem.h>
#include <lcd.h>
#include <fs.h>
#if defined(CONFIG_RKSFC_NOR)
#include <rksfc.h>
#endif
#include "../../../drivers/video/drm/rockchip_display.h"
#include <environment.h>
#include <fdt_support.h>

extern int do_cramfs_load(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[]);
extern struct rockchip_logo_cache *find_or_alloc_logo_cache(const char *bmp);
extern void *get_display_buffer(int size);

DECLARE_GLOBAL_DATA_PTR;

static char *panel = NULL;

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
	char buf[1024] = "run distro_bootcmd";

	/* Load SPI firmware when boot device is SPI flash memory
	 * and environment value 'skip_spiboot' is not 'true'
	 */
	if (strcmp(env_get("skip_spiboot"), "true")) {
		snprintf(buf, sizeof(buf),
				"cramfsload $scriptaddr boot.scr;"
				"source $scriptaddr;"
				"%s", env_get("bootcmd"));
	}

	env_set("bootcmd", buf);
	env_set("variant", "m1");	/* FIXME: if we have variant model */

	return 0;
}

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
				panel = ep->data;
			}
		}
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

	if (panel) {
		snprintf(buf, sizeof(buf), "%s.dtbo", panel);

		argv[1] = env_get("loadaddr");
		argv[2] = buf;

		if (do_cramfs_load(NULL, 0, ARRAY_SIZE(argv), argv) == 0) {
			ulong fdt_dtbo = env_get_ulong("loadaddr", 16, 0);

			fdt_increase_size(fdt_addr, fdt_totalsize((void *)fdt_dtbo));
			fdt_overlay_apply_verbose(fdt_addr, (void *)fdt_dtbo);
		}
	}

	return fdt_check_header(fdt_addr);
}

#ifdef CONFIG_MISC_INIT_R
static int set_bmp_logo(const char *bmp_name, void *addr, int flip)
{
	struct logo_info *logo;
	struct rockchip_logo_cache *logo_cache;
	struct bmp_image *bmp = (struct bmp_image *)map_sysmem((ulong)addr, 0);
	struct bmp_header *header = (struct bmp_header *)bmp;
	void *src;
	void *dst;
	int stride;
	int i;

	if (!bmp_name || !addr)
		return -EINVAL;

	if (!((bmp->header.signature[0]=='B') &&
	      (bmp->header.signature[1]=='M')))
		return -EINVAL;

	logo_cache = find_or_alloc_logo_cache(bmp_name);
	if (!logo_cache)
		return -ENOMEM;

	logo = &logo_cache->logo;
	logo->bpp = get_unaligned_le16(&header->bit_count);
	if (logo->bpp != 24) {
		printf("Unsupported bpp=%d\n", logo->bpp);
		return -EINVAL;
	}

	logo->width = get_unaligned_le32(&header->width);
	logo->height = get_unaligned_le32(&header->height);
	logo->offset = get_unaligned_le32(&header->data_offset);
	logo->ymirror = 0;

	logo->mem = get_display_buffer(get_unaligned_le32(&header->file_size));
	if (!logo->mem)
		return -ENOMEM;

	src = addr + logo->offset;
	dst = logo->mem + logo->offset;
	stride = ALIGN(logo->width * 3, 4);

	if (flip)
		src += stride * (logo->height - 1);

	for (i = 0; i < logo->height; i++) {
		memcpy(dst, src, 3 * logo->width);
		dst += stride;
		src += stride;

		if (flip)
			src -= stride * 2;
	}

	flush_dcache_range((ulong)logo->mem,
			ALIGN((ulong)logo->mem
				+ (logo->width * logo->height * logo->bpp >> 3),
				CONFIG_SYS_CACHELINE_SIZE));

	return 0;
}

static int load_bootsplash_from_mmc(int devnum, unsigned int loadaddr)
{
	char buf[16];
	int n;

	for (n = 1; n <= 2; n++) {
		snprintf(buf, sizeof(buf), "%d:%d", devnum, n);
		if (file_exists("mmc", buf, "boot-logo.bmp.gz", FS_TYPE_ANY)) {
			char cmd[128];
			snprintf(cmd, sizeof(cmd),
					"load mmc %s 0x%08x boot-logo.bmp.gz", buf, loadaddr);
			if (run_command(cmd, 0) == 0)
				return 0;
		}
	}

	return -ENODEV;
}

int misc_init_r(void)
{
	void *decomp;
	struct bmp_image *bmp;
	unsigned int loadaddr = (unsigned int)env_get_ulong("loadaddr", 16, 0);
	unsigned long len;
	char str[80];

	int ret = load_bootsplash_from_mmc(0, loadaddr);	// eMMC
	if (ret)
		ret = load_bootsplash_from_mmc(1, loadaddr);	// SD

	if (ret) {	// SPI
		/* Try to load splash image from SPI flash memory */
		snprintf(str, sizeof(str),
				"sf read 0x%08x 0x300000 0x100000", loadaddr);
		ret = run_command(str, 0);
		if (ret) {
			/* Try to load splash image from CRAMFS */
			snprintf(str, sizeof(str),
					"cramfsload 0x%08x boot-logo.bmp.gz", loadaddr);
			ret = run_command(str, 0);
			if (ret)
				return 0;
		}
	}

	bmp = (struct bmp_image *)map_sysmem(loadaddr, 0);

	/* Check if splash image is uncompressed */
	if (!((bmp->header.signature[0] == 'B')
				&& (bmp->header.signature[1] == 'M')))
		bmp = gunzip_bmp(loadaddr, &len, &decomp);

	if (bmp)
		set_bmp_logo("logo.bmp", bmp, 1);

	if (decomp)
		free(decomp);

	return 0;
}
#endif
