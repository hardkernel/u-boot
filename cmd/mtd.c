/*
 * Copyright (C) (C) Copyright 2016-2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <dm.h>

static int mtd_curr_dev = -1;

static int do_mtd(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if (argc == 2) {
		return CMD_RET_FAILURE;
	}

	return blk_common_cmd(argc, argv, IF_TYPE_MTD, &mtd_curr_dev);
}

U_BOOT_CMD(
	mtd, 8, 1, do_mtd,
	"MTD device sub-system",
	"mtd dev [dev] - show or set current MTD device\n"
	"mtd part [dev] - print partition table of one or all MTD devices\n"
	"mtd read addr blk# cnt - read `cnt' blocks starting at block\n"
	"     `blk#' to memory address `addr'\n"
	"mtd write addr blk# cnt - write `cnt' blocks starting at block\n"
	"     `blk#' from memory address `addr'"
);
