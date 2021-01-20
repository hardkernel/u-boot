/*
 * (C) Copyright 2021 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <boot_rkimg.h>
#include <memalign.h>

#define CONFIG_SET_DFU_ALT_BUF_LEN	(SZ_1K)
static char *get_dfu_alt(char *interface, char *devstr)
{
	struct blk_desc *dev_desc;
	char *alt_boot;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return NULL;
	}

	switch (dev_desc->if_type) {
#ifdef CONFIG_MMC
	case IF_TYPE_MMC:
		alt_boot = DFU_ALT_BOOT_EMMC;
		break;
#endif
#ifdef CONFIG_MTD_BLK
	case IF_TYPE_MTD:
		alt_boot = DFU_ALT_BOOT_MTD;
		break;
#endif
	default:
		printf("[dfu ERROR]:Boot device type is invalid!\n");
		return NULL;
	}

	return alt_boot;
}

void set_dfu_alt_info(char *interface, char *devstr)
{
	size_t buf_size = CONFIG_SET_DFU_ALT_BUF_LEN;
	ALLOC_CACHE_ALIGN_BUFFER(char, buf, buf_size);
	char *alt_info = "Settings not found!";
	char *status = "error!\n";
	char *alt_setting;
	int offset = 0;

	puts("DFU alt info setting: ");

	alt_setting = get_dfu_alt(interface, devstr);
	if (alt_setting) {
		env_set("dfu_alt_boot", alt_setting);
		offset = snprintf(buf, buf_size, "%s", alt_setting);
	}

	if (offset) {
		alt_info = buf;
		status = "done\n";
	}

	env_set("dfu_alt_info", alt_info);
	puts(status);
}
