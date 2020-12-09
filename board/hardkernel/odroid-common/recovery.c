/*
 * Copyright (C) 2018 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 * Sangchul Go <sangch.go@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <asm/errno.h>
#include <asm/reboot.h>
#include <mmc.h>

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
#define MISC_OFFSET ((CONFIG_BOOTAREA_SIZE + CONFIG_PTABLE_SIZE) / 512)

struct bootloader_message {
    char command[32];
    char status[32];
    char recovery[1024];
};

static const char *misc_magic = "recovery";
static struct bootloader_message message;

int board_get_recovery_message(void)
{
	block_dev_desc_t *dev_desc;
	unsigned int offset;
	disk_partition_t info;
	int ret;

	dev_desc = mmc_get_dev(board_current_mmc());
	if (NULL == dev_desc)
		return AMLOGIC_REBOOT_UNKNOWN;

	ret = get_partition_info_mpt_by_name(dev_desc, "misc", &info);

	if (ret < 0) {
		offset = MISC_OFFSET;
	} else {
		offset = info.start;
	}

	dev_desc->block_read(dev_desc->dev, offset,
			(sizeof(struct bootloader_message)
			 + (dev_desc->blksz -1)) / dev_desc->blksz, &message);

	message.recovery[strlen(misc_magic)] = 0;
	if (0 == strncmp(message.recovery, misc_magic, strlen(misc_magic))) {
		return AMLOGIC_FACTORY_RESET_REBOOT;
	}

	return AMLOGIC_REBOOT_UNKNOWN;
}
