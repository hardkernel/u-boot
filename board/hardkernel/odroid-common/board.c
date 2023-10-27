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
#include <mmc.h>
#include <boot_rkimg.h>
#include <jffs2/load_kernel.h>
#include <asm/unaligned.h>	/* get_unaligned() */
#include <asm/gpio.h>
#include "../../../drivers/video/drm/rockchip_display.h"
#include <environment.h>

#ifndef CONFIG_MTD_NOR_FLASH
# define OFFSET_ADJUSTMENT	0
#else
# define OFFSET_ADJUSTMENT	(flash_info[id.num].start[0])
#endif

DECLARE_GLOBAL_DATA_PTR;

static char *panel = NULL;

extern int cramfs_check (struct part_info *info);
extern int cramfs_load (char *loadoffset, struct part_info *info, char *filename);

extern struct rockchip_logo_cache *find_or_alloc_logo_cache(const char *bmp);
extern void *get_display_buffer(int size);

int odroid_gpio_init(unsigned gpio, int value)
{
	gpio_request(gpio, "odroid");
	gpio_direction_output(gpio, value);
	gpio_free(gpio);

	return 0;
}

int set_panel_name(const char *name)
{
	panel = (char *)name;

	return 0;
}

const char *getenv_raw(void *env, int size, const char *key)
{
	env_t *ep = (env_t *)env;
	uint32_t crc;

	size -= ENV_HEADER_SIZE;

	memcpy(&crc, &ep->crc, sizeof(crc));

	if (crc32(0, ep->data, size) == crc) {
		struct hsearch_data env_htab = {
			.change_ok = env_flags_validate,
		};

		if (himport_r(&env_htab, env, size, '\0', 0, 0, 0, NULL)) {
			ENTRY e, *ep;

			e.key = key;
			e.data = NULL;

			hsearch_r(e, FIND, &ep, &env_htab, 0);

			return ep->data;
		}
	}

	return NULL;
}

int load_from_mmc(unsigned long addr, int devnum, int partnum, char *filename)
{
	int ret;
	char buf[16];

	snprintf(buf, sizeof(buf), "%d:%d", devnum, partnum);

	ret = fs_set_blk_dev("mmc", buf, FS_TYPE_ANY);
	if (!ret) {
		loff_t len_read;
		ret = fs_read(filename, addr, 0, 0, &len_read);
		if (!ret) {
			printf("%llu bytes read\n", len_read);
			return 0;
		}
	}

	return ret;
}

int load_from_cramfs(unsigned long addr, char *filename)
{
	int size = 0;

	struct part_info part;
	struct mtd_device dev;
	struct mtdids id;

	ulong cramfsaddr;
	cramfsaddr = simple_strtoul(env_get("cramfsaddr"), NULL, 16);

	id.type = MTD_DEV_TYPE_NOR;
	id.num = 0;
	dev.id = &id;
	part.dev = &dev;
	part.offset = (u64)(uintptr_t) map_sysmem(cramfsaddr - OFFSET_ADJUSTMENT, 0);

	ulong offset = addr;
	char *offset_virt = map_sysmem(offset, 0);

	if (cramfs_check(&part))
		size = cramfs_load (offset_virt, &part, filename);

	if (size > 0) {
		printf("### CRAMFS load complete: %d bytes loaded to 0x%lx\n",
			size, offset);
		env_set_hex("filesize", size);
	}

	unmap_sysmem(offset_virt);
	unmap_sysmem((void *)(uintptr_t)part.offset);

	return !(size > 0);
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
	env_set("variant", BOARD_VARIANT);

	/* Delete device specific values if stored in U-Boot env area */
	run_command_list("setenv -f serial#;"
			"setenv -f ethaddr;"
			"setenv -f eth1addr", -1, 0);

#if defined(CONFIG_TARGET_ODROID_M1)
	const char *commands = "sf probe;"
		"sf secure on;"
		"sf read $loadaddr 0 0x100;"
		"sf secure off";

	run_command_list(commands, -1, 0);

	char *in = (char *)load_addr;

	snprintf(buf, sizeof(buf),
			/* 99999999-9999-9999-9999-999999999999 */
			"%c%c%c%c%c%c%c%c-%c%c%c%c-%c%c%c%c-%c%c%c%c-%c%c%c%c%c%c%c%c%c%c%c%c",
			in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7],
			in[8], in[9], in[10], in[11],
			in[12], in[13], in[14], in[15],
			in[16], in[17], in[18], in[19],
			in[20], in[21], in[22], in[23], in[24], in[25],
			in[26], in[27], in[28], in[29], in[30], in[31]);

	// Serial number
	env_set("serial#", (char *)buf);

	// MAC address
	unsigned long node = cpu_to_be64(simple_strtoul(
				(char *)buf + 24, NULL, 16)) >> 16;

	eth_env_set_enetaddr_by_index("eth", 0, (unsigned char*)&node);
#endif

#if defined(CONFIG_TARGET_ODROID_M1S)
	int devnum = 0;	// MMC device number to access
	struct mmc *mmc = find_mmc_device(devnum);
	if (mmc) {
		// Access the first 'boot' partition and read first block
		// that stores an device identification number (UUID type 1).
		int ret = blk_select_hwpart_devnum(IF_TYPE_MMC, devnum, 1);
		if (!ret) {
			blk_dread(mmc_get_blk_desc(mmc), 0, 1, (void*)load_addr);

			*(char *)(load_addr + 36) = 0;

			// Serial number
			env_set("serial#", (char *)load_addr);

			// MAC address
			unsigned long node = cpu_to_be64(simple_strtoul(
						(char *)load_addr + 24, NULL, 16)) >> 16;

			eth_env_set_enetaddr_by_index("eth", 1, (unsigned char*)&node);
		}
	}
#endif

	return 0;
}

int dtoverlay_apply(void *fdt, const char *dtoverlay, struct blk_desc *dev_desc)
{
	char *paths[] = {
		"",
		"overlays/"CONFIG_BOARDNAME"/",
		"rockchip/overlays/"CONFIG_BOARDNAME"/",
	};
	char buf[1024];
	int ret;
	int i;

	if (!fdt)
		return -1;

	ulong fdt_dtbo = env_get_ulong("loadaddr", 16, 0);

	for (i = 0; i < ARRAY_SIZE(paths); i++) {
		snprintf(buf, sizeof(buf), "%s%s.dtbo", paths[i], dtoverlay);

		if (dev_desc)
			ret = load_from_mmc(fdt_dtbo, dev_desc->devnum, 1, buf);
		else
			ret = load_from_cramfs(fdt_dtbo, buf);

		if (!ret) {
			fdt_increase_size(fdt, fdt_totalsize(fdt_dtbo));
			fdt_overlay_apply_verbose(fdt, (void *)fdt_dtbo);

			return 0;
		}
	}

	return -1;
}

int board_read_dtb_file(void *fdt_addr)
{
	int ret;

	ret = load_from_cramfs((unsigned long)fdt_addr, CONFIG_ROCKCHIP_EARLY_DISTRO_DTB_PATH);
	if (!ret) {
		if (panel)
			ret = dtoverlay_apply(fdt_addr, panel, NULL);
	} else {
		char *paths[] = {
			"dtb",
			"rockchip/"CONFIG_ROCKCHIP_EARLY_DISTRO_DTB_PATH,
		};
		struct blk_desc *dev_desc = rockchip_get_bootdev();
		int i;

		for (i = 0; i < ARRAY_SIZE(paths); i++) {
			ret = load_from_mmc((unsigned long)fdt_addr, dev_desc->devnum, 1, paths[i]);
			if (!ret) {
				run_command_list(
						"load mmc 0:1 $loadaddr config.ini;"
						"ini generic $loadaddr",
						-1, 0);

				char *overlay_profile = env_get("overlay_profile");
				if (overlay_profile) {
					char buf[32];
					snprintf(buf, sizeof(buf), "ini overlay_%s $loadaddr", overlay_profile);
					run_command(buf, 0);
				}

				char *overlays = env_get("overlays");
				const char *token = strtok(overlays, " ");
				while (token != NULL) {
					if (!strncmp(token, "display_", 8)) {
						set_panel_name(token);
						break;
					}
					token = strtok(NULL, " ");
				}

				if (panel)
					ret = dtoverlay_apply(fdt_addr, panel, dev_desc);
				break;
			}
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

int misc_init_r(void)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	void *decomp;
	struct bmp_image *bmp;
	unsigned int loadaddr = (unsigned int)env_get_ulong("loadaddr", 16, 0);
	unsigned long len;
	char *logofile = "boot-logo.bmp.gz";

	int ret = load_from_mmc(loadaddr, dev_desc->devnum, 1, logofile);
	if (ret)
		ret = load_from_cramfs(load_addr, logofile);

	if (ret)
		return 0;	// No boot logo file in memory card

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

void board_env_fixup(void)
{
	env_save();
}

int mmc_get_env_dev(void)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	if (dev_desc)
		return dev_desc->devnum;
	return 0;
}
