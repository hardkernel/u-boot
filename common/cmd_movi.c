/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <common.h>
#include <command.h>
#include <mmc.h>
#include <asm/arch/movi_partition.h>

int do_movi(cmd_tbl_t * cmdtp, int flag, int argc, char *argv[])
{
	char *cmd;
	ulong addr, start_blk, blkcnt;
	uint rfs_size;
	char run_cmd[100];
	uint rw = 0, attribute = -1;
	int i;
	member_t *image;
	struct mmc *mmc;
	int dev_num = 0;
	int location = 1;

	cmd = argv[1];

	switch (cmd[0]) {
	case 'i':
		if(argv[2]==NULL)
		{
			dev_num = 0;
		} else {
			dev_num = simple_strtoul(argv[2], NULL, 10);
		}

		sprintf(run_cmd,"mmcinfo %d", dev_num);
		run_command(run_cmd, dev_num);
		return 1;
	case 'r':
		rw = 0;	/* read case */
		break;
	case 'w':
		rw = 1; /* write case */
		break;
	default:
		goto usage;
	}

	cmd = argv[2];

	switch (cmd[0]) {
	case 'z':
		location = 0;
		break;
	default:
		location = 1;
		break;
	}

	dev_num = simple_strtoul(argv[4 - location], NULL, 10);
	cmd = argv[3 - location];

	switch (cmd[0]) {

	case 'f':
		if (argc != (6 - location))
			goto usage;
		attribute = 0x0;
		break;
	case 'b':
		if (argc != (6 - location))
			goto usage;
		attribute = 0x1;
		break;
	case 'u':
		if (argc != (6 - location))
			goto usage;
		attribute = 0x2;
		break;
	case 't':
		if (argc != (6 - location))
			goto usage;
		attribute = 0x3;
		break;
	case 'k':
		if (argc != 5)
			goto usage;
		attribute = 0x5;
		break;
	case 'r':
		if (argc != 6)
			goto usage;
		attribute = 0x6;
		break;
	default:
		goto usage;
	}

	addr = simple_strtoul(argv[5 - location], NULL, 16);

	mmc = find_mmc_device(dev_num);

	init_raw_area_table(&mmc->block_dev, location);

	/* firmware BL1 r/w */
	if (attribute == 0x0) {
		for (i=0, image = raw_area_control.image; i<15; i++) {
			if (image[i].attribute == attribute)
				break;
		}

		start_blk = image[i].start_blk;
		blkcnt = image[i].used_blk;
		printf("%s FWBL1 ..device %d Start %ld, Count %ld ", rw ? "writing":"reading",
			dev_num, start_blk, blkcnt);
		sprintf(run_cmd,"mmc %s %d 0x%lx 0x%lx 0x%lx",
			rw ? "write":"read", dev_num,
			addr, start_blk, blkcnt);
		run_command(run_cmd, dev_num);
		printf("completed\n");
		return 1;
	}
	/* BL2 r/w */
	if (attribute == 0x1) {
		for (i=0, image = raw_area_control.image; i<15; i++) {
			if (image[i].attribute == attribute)
				break;
		}
		start_blk = image[i].start_blk;
		blkcnt = image[i].used_blk;
		printf("%s BL2 ..device %d Start %ld, Count %ld ", rw ? "writing":"reading",
			dev_num, start_blk, blkcnt);
		sprintf(run_cmd,"mmc %s %d 0x%lx 0x%lx 0x%lx",
			rw ? "write":"read", dev_num,
			addr, start_blk, blkcnt);
		run_command(run_cmd, dev_num);
		printf("completed\n");
		return 1;
	}
	/* u-boot r/w */
	if (attribute == 0x2) {
		for (i=0, image = raw_area_control.image; i<15; i++) {
			if (image[i].attribute == attribute)
				break;
		}
		start_blk = image[i].start_blk;
		blkcnt = image[i].used_blk;
		printf("%s bootloader..device %d Start %ld, Count %ld ", rw ? "writing":"reading",
			dev_num, start_blk, blkcnt);
		sprintf(run_cmd,"mmc %s %d 0x%lx 0x%lx 0x%lx",
			rw ? "write":"read", dev_num,
			addr, start_blk, blkcnt);
		run_command(run_cmd, dev_num);
		printf("completed\n");
		return 1;
	}

	/* TrustZone S/W */
	if (attribute == 0x3) {
		for (i=0, image = raw_area_control.image; i<15; i++) {
			if (image[i].attribute == attribute)
				break;
		}
		start_blk = image[i].start_blk;
		blkcnt = image[i].used_blk;
		printf("%s %d TrustZone S/W.. Start %ld, Count %ld ", rw ? "writing" : "reading",
		       dev_num, start_blk, blkcnt);
		sprintf(run_cmd, "mmc %s %d 0x%lx 0x%lx 0x%lx",
			rw ? "write" : "read", dev_num,
			addr, start_blk, blkcnt);
		run_command(run_cmd, dev_num);
		printf("completed\n");
		return 1;
	}

	/* kernel r/w */
	if (attribute == 0x5) {
		for (i=0, image = raw_area_control.image; i<15; i++) {
			if (image[i].attribute == attribute)
				break;
		}
		start_blk = image[i].start_blk;
		blkcnt = image[i].used_blk;
		printf("%s kernel..device %d Start %ld, Count %ld ", rw ? "writing" : "reading",
			dev_num, start_blk, blkcnt);
		sprintf(run_cmd, "mmc %s %d 0x%lx 0x%lx 0x%lx",
			rw ? "write" : "read", dev_num,
			addr, start_blk, blkcnt);
		run_command(run_cmd, dev_num);
		printf("completed\n");
		return 1;
	}

	/* root file system r/w */
	if (attribute == 0x6) {
		rfs_size = simple_strtoul(argv[5], NULL, 16);

		for (i=0, image = raw_area_control.image; i<15; i++) {
			if (image[i].attribute == attribute)
				break;
		}
		start_blk = image[i].start_blk;
		blkcnt = rfs_size/MOVI_BLKSIZE +
			((rfs_size&(MOVI_BLKSIZE-1)) ? 1 : 0);
		image[i].used_blk = blkcnt;
		printf("%s RFS..device %d Start %ld, Count %ld ", rw ? "writing":"reading",
			dev_num, start_blk, blkcnt);
		sprintf(run_cmd,"mmc %s %d 0x%lx 0x%lx 0x%lx",
			rw ? "write":"read", dev_num,
			addr, start_blk, blkcnt);
		run_command(run_cmd, dev_num);
		printf("completed\n");
		return 1;
	}

	return 1;

usage:
	printf("Usage:\n%s\n", cmdtp->usage);
	return -1;
}

U_BOOT_CMD(
	movi,	7,	0,	do_movi,
	"movi\t- sd/mmc r/w sub system for SMDK board",
	"init - Initialize moviNAND and show card info\n"
	"#eMMC#\n"
	"movi read zero {fwbl1 | bl2 | u-boot | tzsw} {device_number} {addr} - Read data from emmc\n"
	"movi write zero {fwbl1 | bl2 | u-boot | tzsw} {device_number} {addr} - Read data from emmc\n"
	"#SD/MMC#\n"
	"movi read {fwbl1 | bl2 | u-boot | tzsw} {device_number} {addr} - Read data from sd/mmc\n"
	"movi write {fwbl1 | bl2 | u-boot | tzsw} {device_number} {addr} - Read data from sd/mmc\n"
	"#COMMON#\n"
	"movi read kernel {device_number} {addr} - Read data from device\n"
	"movi write kernel {device_number} {addr} - Write data to device\n"
	"movi read rootfs {device_number} {addr} [bytes(hex)] - Read rootfs data from device by size\n"
	"movi write rootfs {device_number} {addr} [bytes(hex)] - Write rootfs data to device by size\n"
	"movi read {sector#} {device_number} {bytes(hex)} {addr} - instead of this, you can use \"mmc read\"\n"
	"movi write {sector#} {device_number} {bytes(hex)} {addr} - instead of this, you can use \"mmc write\"\n"
);

