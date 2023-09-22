/*
 * SPDX-License-Identifier:     GPL-2.0+
 *
 * (C) Copyright 2023 Hardkernel Co., Ltd
 */

#include <common.h>
#include <fs.h>
#include <lcd.h>
#include <malloc.h>
#include <mapmem.h>
#include <asm/unaligned.h>	/* get_unaligned() */
#include "../../../drivers/video/drm/rockchip_display.h"

extern int do_cramfs_load(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[]);
extern struct rockchip_logo_cache *find_or_alloc_logo_cache(const char *bmp);
extern void *get_display_buffer(int size);

DECLARE_GLOBAL_DATA_PTR;

static char *panel = NULL;

int set_panel_name(const char *name)
{
	panel = (char *)name;

	return 0;
}

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

#if defined(CONFIG_TARGET_ODROID_M1)
	env_set("variant", "m1");
#elif defined(CONFIG_TARGET_ODROID_M1S)
	env_set("variant", "m1s");
#endif

	return 0;
}

int board_read_dtb_file(void *fdt_addr)
{
	char buf[32];
	char *argv[3] = {
		"cramfsload",
		buf,
		CONFIG_ROCKCHIP_EARLY_DISTRO_DTB_PATH,
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

	int ret = load_bootsplash_from_mmc(0, loadaddr);	// eMMC
	if (ret)
		ret = load_bootsplash_from_mmc(1, loadaddr);	// SD

	if (ret) {	// SPI
#if defined(CONFIG_TARGET_ODROID_M1)
		char str[80];

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
#else
		return 0;
#endif
	}

	bmp = (struct bmp_image *)map_sysmem(loadaddr, 0);

	/* Check if splash image is uncompressed */
	if (!((bmp->header.signature[0] == 'B')
				&& (bmp->header.signature[1] == 'M')))
		bmp = gunzip_bmp(loadaddr, &len, &decomp);

	if (bmp) {
		set_bmp_logo("logo.bmp", bmp, 1);
		set_bmp_logo("logo_kernel.bmp", bmp, 1);
	}

	if (decomp)
		free(decomp);

	return 0;
}
#endif
