/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <android_bootloader.h>
#include <android_cmds.h>
#include <common.h>
#include <command.h>

static int do_boot_android(cmd_tbl_t *cmdtp, int flag, int argc,
			   char * const argv[])
{
	unsigned long load_address;
	int ret = CMD_RET_SUCCESS;
	char *addr_arg_endp, *addr_str;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;

	if (argc < 4)
		return CMD_RET_USAGE;
	if (argc > 5)
		return CMD_RET_USAGE;

	if (argc >= 5) {
		load_address = simple_strtoul(argv[4], &addr_arg_endp, 16);
		if (addr_arg_endp == argv[4] || *addr_arg_endp != '\0')
			return CMD_RET_USAGE;
	} else {
		addr_str = env_get("loadaddr");
		if (addr_str)
			load_address = simple_strtoul(addr_str, NULL, 16);
		else
			load_address = CONFIG_SYS_LOAD_ADDR;
	}

	if (part_get_info_by_dev_and_name_or_num(argv[1], argv[2],
						 &dev_desc, &part_info) < 0) {
		return CMD_RET_FAILURE;
	}

	ret = android_bootloader_boot_flow(dev_desc, &part_info, argv[3],
					   load_address);
	if (ret < 0) {
		printf("Android boot failed, error %d.\n", ret);
		return CMD_RET_FAILURE;
	}
	return CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	boot_android, 5, 0, do_boot_android,
	"Execute the Android Bootloader flow.",
	"<interface> <dev[:part|;part_name]> <slot> [<kernel_addr>]\n"
	"    - Load the Boot Control Block (BCB) from the partition 'part' on\n"
	"      device type 'interface' instance 'dev' to determine the boot\n"
	"      mode, and load and execute the appropriate kernel.\n"
	"      In normal and recovery mode, the kernel will be loaded from\n"
	"      the corresponding \"boot\" partition. In bootloader mode, the\n"
	"      command defined in the \"fastbootcmd\" variable will be\n"
	"      executed.\n"
	"      On Android devices with multiple slots, the pass 'slot' is\n"
	"      used to load the appropriate kernel. The standard slot names\n"
	"      are 'a' and 'b'.\n"
	"    - If 'part_name' is passed, preceded with a ; instead of :, the\n"
	"      partition name whose label is 'part_name' will be looked up in\n"
	"      the partition table. This is commonly the \"misc\" partition.\n"
);
