/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <asm/errno.h>
#include <usb/fastboot.h>

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
	block_dev_desc_t *dev_desc;
	fastboot_ptentry *ptn;
	unsigned int offset;

	dev_desc = mmc_get_dev(0);
	if (NULL == dev_desc)
		return ODROID_REBOOT_CMD_UNKNOWN;

	ptn = fastboot_flash_find_ptn(bcb_name);
	if (NULL == ptn)
		return ODROID_REBOOT_CMD_UNKNOWN;

	offset = ptn->start;

	dev_desc->block_read(dev_desc->dev, offset,
			(sizeof(struct bootloader_message)
			 + (dev_desc->blksz - 1)) / dev_desc->blksz, &bcb);

	bcb.recovery[strlen(bcb_magic)] = 0;
	if (0 == strncmp(bcb.recovery, bcb_magic, strlen(bcb_magic))) {
		do_format();
		printf("Default Android partition is created...\n");
		return ODROID_REBOOT_CMD_RECOVERY;
	}

	return ODROID_REBOOT_CMD_UNKNOWN;
}
