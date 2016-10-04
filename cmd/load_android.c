/*
  * Copyright (C) 2008 The Android Open Source Project
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <common.h>
#include <command.h>
#include <mapmem.h>

static int do_load_android(cmd_tbl_t *cmdtp, int flag, int argc,
			   char * const argv[])
{
	int boot_partition;
	unsigned long load_address, blk_cnt, blk_read;
	int ret = CMD_RET_SUCCESS;
	char *addr_arg_endp, *addr_str;
	void *buf;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;

	if (argc < 2)
		return CMD_RET_USAGE;
	if (argc > 4)
		return CMD_RET_USAGE;

	if (argc >= 4) {
		load_address = simple_strtoul(argv[3], &addr_arg_endp, 16);
		if (addr_arg_endp == argv[3] || *addr_arg_endp != '\0')
			return CMD_RET_USAGE;
	} else {
		addr_str = env_get("loadaddr");
		if (addr_str != NULL)
			load_address = simple_strtoul(addr_str, NULL, 16);
		else
			load_address = CONFIG_SYS_LOAD_ADDR;
	}

	boot_partition = blk_get_device_part_str(argv[1],
	                                         (argc >= 3) ? argv[2] : NULL,
	                                         &dev_desc, &part_info, 1);
	if (boot_partition < 0)
		return CMD_RET_FAILURE;

	/* We don't know the size of the Android image before reading the header
	 * so we don't limit the size of the mapped memory. */
	buf = map_sysmem(load_address, 0 /* size */);

	/* Read the Android header first and then read the rest. */
	if (blk_dread(dev_desc, part_info.start, 1, buf) != 1) {
		ret = CMD_RET_FAILURE;
	}

	if (ret == CMD_RET_SUCCESS && android_image_check_header(buf) != 0) {
		printf("\n** Invalid Android Image header on %s %d:%d **\n",
		       argv[1], dev_desc->devnum, boot_partition);
		ret = CMD_RET_FAILURE;
	}
	if (ret == CMD_RET_SUCCESS) {
		blk_cnt = (android_image_get_end(buf) - (ulong)buf +
		           part_info.blksz - 1) / part_info.blksz;
		printf("\nLoading Android Image (%lu blocks) to 0x%lx... ",
		       blk_cnt, load_address);
		blk_read = blk_dread(dev_desc, part_info.start, blk_cnt, buf);
	}

	unmap_sysmem(buf);
	if (ret != CMD_RET_SUCCESS)
		return ret;

	printf("%lu blocks read: %s\n",
	       blk_read, (blk_read == blk_cnt) ? "OK" : "ERROR");
	return (blk_read == blk_cnt) ? CMD_RET_SUCCESS : CMD_RET_FAILURE;
}


#if defined(CONFIG_CMD_LOAD_ANDROID)
U_BOOT_CMD(
	load_android, 4, 0, do_load_android,
	"load Android Boot image from storage.",
	"<interface> [<dev[:part]> [<addr>]]\n"
	"    - Load a binary Android Boot image from the partition 'part' on\n"
	"      device type 'interface' instance 'dev' to address 'addr'."
);
#endif	/* CONFIG_CMD_LOAD_ANDROID */
