/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __BOOT_ROCKCHIP_H_
#define __BOOT_ROCKCHIP_H_

/* This is a copy from Android boot loader */
enum _boot_mode {
	BOOT_MODE_NORMAL = 0,
	BOOT_MODE_RECOVERY,
	BOOT_MODE_BOOTLOADER,	/* Android: Fastboot mode */
	BOOT_MODE_LOADER,	/* Rockchip: Rockusb download mode */
	BOOT_MODE_CHARGING,
	BOOT_MODE_UMS,
	BOOT_MODE_BROM_DOWNLOAD,
	BOOT_MODE_UNDEFINE,
};

#define PART_MISC			"misc"
#define PART_KERNEL			"kernel"
#define PART_BOOT			"boot"
#define PART_RECOVERY			"recovery"
#define PART_DTBO			"dtbo"

#define RK_BLK_SIZE 512

int rockchip_get_boot_mode(void);
int boot_rockchip_image(struct blk_desc *dev, disk_partition_t *boot_part);
int read_rockchip_image(struct blk_desc *dev_desc,
			disk_partition_t *part_info, void *dst);

struct blk_desc *rockchip_get_bootdev(void);

/*
 * reboot into recovery and wipe data
 */
void board_run_recovery_wipe_data(void);

/*
 * reboot into recovery
 */
void board_run_recovery(void);

#endif
