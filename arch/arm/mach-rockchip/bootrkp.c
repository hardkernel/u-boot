/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <config.h>
#include <linux/list.h>
#include <malloc.h>
#include <asm/arch/resource_img.h>
#include "rockchip_parameter.h"
#include "rockchip_blk.h"

#define TAG_KERNEL			0x4C4E524B

#define PART_MISC			"misc"
#define PART_KERNEL			"kernel"
#define PART_BOOT			"boot"
#define PART_RECOVERY			"recovery"

#define DTB_FILE			"rk-kernel.dtb"

#define BOOTLOADER_MESSAGE_OFFSET_IN_MISC	(16 * 1024)
#define BOOTLOADER_MESSAGE_BLK_OFFSET		(BOOTLOADER_MESSAGE_OFFSET_IN_MISC >> 9)

enum android_boot_mode {
	ANDROID_BOOT_MODE_NORMAL = 0,

	/* "recovery" mode is triggered by the "reboot recovery" command or
	 * equivalent adb/fastboot command. It can also be triggered by writing
	 * "boot-recovery" in the BCB message. This mode should boot the
	 * recovery kernel.
	 */
	ANDROID_BOOT_MODE_RECOVERY,

	/* "bootloader" mode is triggered by the "reboot bootloader" command or
	 * equivalent adb/fastboot command. It can also be triggered by writing
	 * "bootonce-bootloader" in the BCB message. This mode should boot into
	 * fastboot.
	 */
	ANDROID_BOOT_MODE_BOOTLOADER,
};

struct bootloader_message {
	char command[32];
	char status[32];
	char recovery[768];

	/*
         * The 'recovery' field used to be 1024 bytes.  It has only ever
	 * been used to store the recovery command line, so 768 bytes
	 * should be plenty.  We carve off the last 256 bytes to store the
	 * stage string (for multistage packages) and possible future
	 * expansion.
         */
	char stage[32];
	char slot_suffix[32];
	char reserved[192];
};

struct rockchip_image {
	uint32_t tag;
	uint32_t size;
	int8_t image[1];
	uint32_t crc;
};

static int read_boot_mode_from_misc(struct blk_part *misc)
{
	struct bootloader_message *bmsg;
	int size = DIV_ROUND_UP(sizeof(struct bootloader_message),
				RK_BLK_SIZE) * RK_BLK_SIZE;
	int ret = 0;

	bmsg = memalign(ARCH_DMA_MINALIGN, size);
	ret = blkdev_read(bmsg, misc->from + BOOTLOADER_MESSAGE_BLK_OFFSET,
			  size >> 9);
	if (ret < 0)
		goto out;

	if (!strcmp(bmsg->command, "boot-recovery")) {
		printf("boot mode: recovery\n");
		ret = ANDROID_BOOT_MODE_RECOVERY;
	} else {
		printf("boot mode: normal\n");
		ret = ANDROID_BOOT_MODE_NORMAL;
	}

out:
	free(bmsg);
	return ret;
}

/*
 * non-OTA packaged kernel.img & boot.img
 * return the image size on success, and a
 * negative value on error.
 */
static int read_rockchip_image(struct blk_part *part, void *dst)
{
	struct rockchip_image *img;
	int header_len = 8;
	int cnt;
	int ret;

	img = memalign(ARCH_DMA_MINALIGN, RK_BLK_SIZE);
	if (!img) {
		printf("out of memory\n");
		return -ENOMEM;
	}

	/* read first block with header imformation */
	ret = blkdev_read(img, part->from, 1);
	if (ret < 0)
		goto err;
	if (img->tag != TAG_KERNEL) {
		printf("%s: invalid image tag\n", part->name);
		goto err;
	}

	memcpy(dst, img->image, RK_BLK_SIZE - header_len);
	/*
	 * read the rest blks
	 * total size  = image size + 8 bytes header + 4 bytes crc32
	 */
	cnt = DIV_ROUND_UP(img->size + 8 + 4, RK_BLK_SIZE);
	ret = blkdev_read(dst + RK_BLK_SIZE - header_len,
			  part->from + 1, cnt - 1);
	if (!ret)
		ret = img->size;
err:
	free(img);
	return ret;
}

static int do_bootrkp(cmd_tbl_t *cmdtp, int flag, int argc,
		      char * const argv[])
{
	ulong fdt_addr_r = env_get_ulong("fdt_addr_r", 16, 0);
	ulong ramdisk_addr_r = env_get_ulong("ramdisk_addr_r", 16, 0);
	ulong kernel_addr_r = env_get_ulong("kernel_addr_r", 16, 0x480000);
	struct blk_part *boot;
	struct blk_part *kernel;
	struct blk_part *misc;
	int ramdisk_size;
	int kernel_size;
	int fdt_size;
	int boot_mode;
	int ret = 0;
	char cmdbuf[64];

	misc = rockchip_get_blk_part(PART_MISC);
	if (misc)
		boot_mode = read_boot_mode_from_misc(misc);
	else
		boot_mode = ANDROID_BOOT_MODE_RECOVERY;

	if (boot_mode == ANDROID_BOOT_MODE_RECOVERY)
		boot = rockchip_get_blk_part(PART_RECOVERY);
	else
		boot = rockchip_get_blk_part(PART_BOOT);
	kernel = rockchip_get_blk_part(PART_KERNEL);

	if (!kernel || !boot) {
		ret = CMD_RET_FAILURE;
		goto out;
	}

	kernel_size = read_rockchip_image(kernel, (void *)kernel_addr_r);
	if (kernel_size < 0) {
		ret = CMD_RET_FAILURE;
		goto out;
	}

	ramdisk_size = read_rockchip_image(boot, (void *)ramdisk_addr_r);
	if (ramdisk_size < 0) {
		ret = CMD_RET_FAILURE;
		goto out;
	}

	fdt_size = rockchip_read_resource_file((void *)fdt_addr_r, DTB_FILE, 0, 0);
	if (fdt_size < 0) {
		ret = CMD_RET_FAILURE;
		goto out;
	}

	printf("kernel_size:0x%ulx ramdisk_size:0x%x\n", kernel_size, ramdisk_size);
	sprintf(cmdbuf, "booti 0x%lx 0x%lx:0x%x 0x%lx",
		kernel_addr_r, ramdisk_addr_r, ramdisk_size, fdt_addr_r);
	run_command(cmdbuf, 0);
out:
	return ret;
}

U_BOOT_CMD(
	bootrkp,  CONFIG_SYS_MAXARGS,     1,      do_bootrkp,
	"boot Linux Image image from rockchip partition storage",
	""
);
