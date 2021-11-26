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
#include "../../../drivers/video/drm/rockchip_display.h"

extern int do_cramfs_load(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[]);
extern struct rockchip_logo_cache *find_or_alloc_logo_cache(const char *bmp);
extern void *get_display_buffer(int size);

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

int rk_board_late_init(void)
{
	struct blk_desc *dev_desc;
	char buf[1024] = "run distro_bootcmd";

	/* Load SPI firmware when boot device is SPI flash memory
	 * and environment value 'skip_spiboot' is not 'true'
	 */
	if (strcmp(env_get("skip_spiboot"), "true")) {
		dev_desc = rockchip_get_bootdev();
		if (dev_desc && (dev_desc->if_type == IF_TYPE_MTD
					&& dev_desc->devnum == 2))
			snprintf(buf, sizeof(buf),
					"cramfsload $scriptaddr boot.scr;"
					"source $scriptaddr;"
					"%s", env_get("bootcmd"));
	}

	env_set("bootcmd", buf);

	return 0;
}

int board_early_init_r(void)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	if ((dev_desc->if_type == IF_TYPE_MTD) && (dev_desc->devnum == 2)) {
		run_command_list( "sf probe\n"
				"sf read $cramfsaddr 0x400000 0xc00000",
				-1, 0);
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

int misc_init_r(void)
{
	void *decomp;
	struct bmp_image *bmp;
	unsigned int loadaddr = (unsigned int)env_get_ulong("loadaddr", 16, 0);
	unsigned long len = 0x100000;
	char str[80];
	int ret;

	snprintf(str, sizeof(str),
			"mtd read nor0 0x%08x 0x300000 0x%08x",
			loadaddr, (unsigned int)len);
	ret = run_command(str, 0);
	if (ret)
		return 1;

	bmp = gunzip_bmp(loadaddr, &len, &decomp);
	if (bmp)
		set_bmp_logo("logo.bmp", bmp, 1);

	free(decomp);

	return 0;
}
#endif
