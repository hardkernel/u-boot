/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * This driver has been modified to support ODROID-N1
 * based on Rockchip RK3399.
 *     Modified by Joy Cho <joycho78@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <linux/errno.h>
#include <disk.h>

/* Bootloader Message
 *
 * This structure describes the content of a block in flash
 * that is used for recovery and the bootloader to talk to
 * each other.
 *
 * The command field is updated by linux when it wants to
 * reboot into recovery or to update radio or bootloader firmware.
 * It is also updated by the bootloader when firmware update
 * is complete (to boot into recovery for any final cleanup)
 *
 * The status field is written by the bootloader after the
 * completion of an "update-radio" or "update-hboot" command.
 *
 * The recovery field is only written by linux and used
 * for the system to send a message to recovery or the
 * other way around.
 */
struct bootloader_message {
        char command[32];
        char status[32];
        char recovery[1024];
};

static const char *bcb_name = "bcb";
static const char *bcb_magic = "recovery";
static struct bootloader_message bcb;

int board_get_recovery_message(void)
{
	struct mmc *mmc;
	struct blk_desc *dev_desc;
	disk_ptentry *ptn;
	unsigned int offset;
	unsigned int size;
	u32 dev_no;

	/* get mmc device */
	dev_no = getenv_ulong("bootdev", 10, 0);
	mmc = find_mmc_device(dev_no);
	if (NULL == mmc) {
		printf("recovery: get mmc dev fail\n");
		return -EIO;
	}

	dev_desc = blk_get_dev("mmc", dev_no);
	if (!dev_desc || dev_desc->type == DEV_TYPE_UNKNOWN) {
		error("recovery: invalid mmc device");
		return -EIO;
	}

	/* find bcb partition */
	ptn = disk_flash_find_ptn(bcb_name);
	if (NULL == ptn) {
		printf("recovery: get bcb ptn fail\n");
		return -EIO;
	}

	offset = ptn->start;
	size = (sizeof(struct bootloader_message) + (dev_desc->blksz - 1)) / dev_desc->blksz;

	/* read and check bootloader message */
	if (blk_dread(dev_desc, offset, size, &bcb) != size) {
		printf("recovery: block read fail\n");
		return -EIO;
	}

	bcb.recovery[strlen(bcb_magic)] = 0;

	if (0 == strncmp(bcb.recovery, bcb_magic, strlen(bcb_magic))) {
		do_format();
		printf("recovery: default Android partition is created...\n");
		return 0;
	}

	return -EIO;
}

void board_enter_recovery_mode(void)
{
	char cmd[128];
	u32 dev_no;

	dev_no = getenv_ulong("bootdev", 10, 0);
	sprintf(cmd, "mmc dev %d", dev_no);
	run_command(cmd, 0);

	run_command("movi read kernel 0 $kernel_addr_r", 0);
	run_command("movi read recovery 0 $ramdisk_addr_r", 0);
	run_command("movi read dtb 0 $fdt_addr_r", 0);

	printf("Now, recovery routine will be started\n");
	run_command("booti $kernel_addr_r $ramdisk_addr_r $fdt_addr_r", 0);
}
