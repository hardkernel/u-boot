/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 */

#include <common.h>
#include <command.h>
#include <dm.h>
#include <rksfc.h>

static int rksfc_curr_dev;
static int do_rksfc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int ret;

	if (argc == 2) {
		if (strncmp(argv[1], "scan", 4) == 0) {
			ret = rksfc_scan_namespace();
			if (ret)
				return CMD_RET_FAILURE;

			return ret;
		}
	}

	return blk_common_cmd(argc, argv, IF_TYPE_RKSFC, &rksfc_curr_dev);
}

U_BOOT_CMD(
	rksfc, 8, 1, do_rksfc,
	"rockchip sfc sub-system",
	"scan - scan Sfc devices\n"
	"rksfc info - show all available Sfc devices\n"
	"rksfc device [dev] - show or set current Sfc device\n"
	"rksfc part [dev] - print partition table of one or all Sfc devices\n"
	"rksfc read addr blk# cnt - read `cnt' blocks starting at block\n"
	"     `blk#' to memory address `addr'\n"
	"rksfc write addr blk# cnt - write `cnt' blocks starting at block\n"
	"     `blk#' from memory address `addr'"
);
