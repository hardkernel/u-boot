/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <android_bootloader.h>
#include <android_bootloader_message.h>
#include <android_avb/avb_slot_verify.h>
#include <android_avb/avb_ops_user.h>
#include <android_avb/rk_avb_ops_user.h>

#include <cli.h>
#include <common.h>
#include <malloc.h>
#include <fs.h>
#include <boot_rkimg.h>
#include <attestation_key.h>
#include <optee_include/OpteeClientInterface.h>

#define ANDROID_PARTITION_BOOT "boot"
#define ANDROID_PARTITION_MISC "misc"
#define ANDROID_PARTITION_OEM  "oem"
#define ANDROID_PARTITION_RECOVERY  "recovery"
#define ANDROID_PARTITION_SYSTEM "system"

#define ANDROID_ARG_SLOT_SUFFIX "androidboot.slot_suffix="
#define ANDROID_ARG_ROOT "root="
#define ANDROID_ARG_SERIALNO "androidboot.serialno="
#ifdef CONFIG_ROCKCHIP_RESOURCE_IMAGE
#define ANDROID_ARG_FDT_FILENAME "rk-kernel.dtb"
#define BOOTLOADER_MESSAGE_OFFSET_IN_MISC	(16 * 1024)
#define BOOTLOADER_MESSAGE_BLK_OFFSET	(BOOTLOADER_MESSAGE_OFFSET_IN_MISC >> 9)
#else
#define ANDROID_ARG_FDT_FILENAME "kernel.dtb"
#endif
#define OEM_UNLOCK_ARG_SIZE 30

char *android_str_append(char *base_name, char *slot_suffix)
{
	char *part_name;
	size_t part_name_len;

	part_name_len = strlen(base_name) + 1;
	if (slot_suffix)
		part_name_len += strlen(slot_suffix);
	part_name = malloc(part_name_len);
	if (!part_name)
		return NULL;
	strcpy(part_name, base_name);
	if (slot_suffix && (slot_suffix[0] != '\0'))
		strcat(part_name, slot_suffix);

	return part_name;
}

int android_bootloader_message_load(
	struct blk_desc *dev_desc,
	const disk_partition_t *part_info,
	struct android_bootloader_message *message)
{
	ulong message_blocks = sizeof(struct android_bootloader_message) /
	    part_info->blksz;
	if (message_blocks > part_info->size) {
		printf("misc partition too small.\n");
		return -1;
	}

#ifdef CONFIG_RKIMG_BOOTLOADER
	if (blk_dread(dev_desc, part_info->start + BOOTLOADER_MESSAGE_BLK_OFFSET,
	     message_blocks, message) !=
#else
	if (blk_dread(dev_desc, part_info->start, message_blocks, message) !=
#endif
	    message_blocks) {
		printf("Could not read from misc partition\n");
		return -1;
	}
	debug("ANDROID: Loaded BCB, %lu blocks.\n", message_blocks);
	return 0;
}

static int android_bootloader_message_write(
	struct blk_desc *dev_desc,
	const disk_partition_t *part_info,
	struct android_bootloader_message *message)
{
#ifdef CONFIG_RKIMG_BOOTLOADER
	ulong message_blocks = sizeof(struct android_bootloader_message) /
	    part_info->blksz + BOOTLOADER_MESSAGE_BLK_OFFSET;
#else
	ulong message_blocks = sizeof(struct android_bootloader_message) /
	    part_info->blksz;
#endif
	if (message_blocks > part_info->size) {
		printf("misc partition too small.\n");
		return -1;
	}

	if (blk_dwrite(dev_desc, part_info->start, message_blocks, message) !=
	    message_blocks) {
		printf("Could not write to misc partition\n");
		return -1;
	}
	debug("ANDROID: Wrote new BCB, %lu blocks.\n", message_blocks);
	return 0;
}

static enum android_boot_mode android_bootloader_load_and_clear_mode(
	struct blk_desc *dev_desc,
	const disk_partition_t *misc_part_info)
{
	struct android_bootloader_message bcb;

#ifdef CONFIG_FASTBOOT
	char *bootloader_str;

	/* Check for message from bootloader stored in RAM from a previous boot.
	 */
	bootloader_str = (char *)CONFIG_FASTBOOT_BUF_ADDR;
	if (!strcmp("reboot-bootloader", bootloader_str)) {
		bootloader_str[0] = '\0';
		return ANDROID_BOOT_MODE_BOOTLOADER;
	}
#endif

	/* Check and update the BCB message if needed. */
	if (android_bootloader_message_load(dev_desc, misc_part_info, &bcb) <
	    0) {
		printf("WARNING: Unable to load the BCB.\n");
		return ANDROID_BOOT_MODE_NORMAL;
	}

	if (!strcmp("bootonce-bootloader", bcb.command)) {
		/* Erase the message in the BCB since this value should be used
		 * only once.
		 */
		memset(bcb.command, 0, sizeof(bcb.command));
		android_bootloader_message_write(dev_desc, misc_part_info,
						 &bcb);
		return ANDROID_BOOT_MODE_BOOTLOADER;
	}

	if (!strcmp("boot-recovery", bcb.command))
		return ANDROID_BOOT_MODE_RECOVERY;

	return ANDROID_BOOT_MODE_NORMAL;
}

/**
 * Return the reboot reason string for the passed boot mode.
 *
 * @param mode	The Android Boot mode.
 * @return a pointer to the reboot reason string for mode.
 */
static const char *android_boot_mode_str(enum android_boot_mode mode)
{
	switch (mode) {
	case ANDROID_BOOT_MODE_NORMAL:
		return "(none)";
	case ANDROID_BOOT_MODE_RECOVERY:
		return "recovery";
	case ANDROID_BOOT_MODE_BOOTLOADER:
		return "bootloader";
	}
	return NULL;
}

static int android_part_get_info_by_name_suffix(struct blk_desc *dev_desc,
						const char *base_name,
						const char *slot_suffix,
						disk_partition_t *part_info)
{
	char *part_name;
	int part_num;
	size_t part_name_len;

	part_name_len = strlen(base_name) + 1;
	if (slot_suffix)
		part_name_len += strlen(slot_suffix);
	part_name = malloc(part_name_len);
	if (!part_name)
		return -1;
	strcpy(part_name, base_name);
	if (slot_suffix && (slot_suffix[0] != '\0'))
		strcat(part_name, slot_suffix);

	part_num = part_get_info_by_name(dev_desc, part_name, part_info);
	if (part_num < 0) {
		debug("ANDROID: Could not find partition \"%s\"\n", part_name);
		part_num = -1;
	}

	free(part_name);
	return part_num;
}

static int android_bootloader_boot_bootloader(void)
{
	const char *fastboot_cmd = env_get("fastbootcmd");

	if (fastboot_cmd == NULL) {
		printf("fastboot_cmd is null, run default fastboot_cmd!\n");
		fastboot_cmd = "fastboot usb 0";
	}

	return run_command(fastboot_cmd, CMD_FLAG_ENV);
}

#ifdef CONFIG_SUPPORT_OEM_DTB
static int android_bootloader_get_fdt(const char *part_name,
		const char *load_file_name)
{
	struct blk_desc *dev_desc;
	disk_partition_t boot_part_info;
	char *fdt_addr = NULL;
	char slot_suffix[5] = {0};
	char dev_part[3] = {0};
	loff_t bytes = 0;
	loff_t pos = 0;
	loff_t len_read;
	unsigned long addr = 0;
	int part_num = -1;
	int ret;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -1;
	}

	memset(&boot_part_info, 0, sizeof(boot_part_info));

#ifdef CONFIG_RK_AVB_LIBAVB_USER
	if (rk_avb_get_current_slot(slot_suffix)) {
		printf("ANDROID: Get Current Slot error.\n");
		return -1;
	}

	part_num = android_part_get_info_by_name_suffix(dev_desc,
					     part_name,
					     slot_suffix, &boot_part_info);
#else
	part_num = part_get_info_by_name(dev_desc, part_name, &boot_part_info);
	if (part_num < 0) {
		printf("ANDROID: Could not find partition \"%s\"\n", part_name);
		return -1;
	}
#endif

	snprintf(dev_part, ARRAY_SIZE(dev_part), ":%x", part_num);
	if (fs_set_blk_dev_with_part(dev_desc, part_num))
		return -1;

	fdt_addr = env_get("fdt_addr_r");
	if (!fdt_addr) {
		printf("ANDROID: No Found FDT Load Address.\n");
		return -1;
	}
	addr = simple_strtoul(fdt_addr, NULL, 16);

	ret = fs_read(load_file_name, addr, pos, bytes, &len_read);
	if (ret < 0)
		return -1;

	return 0;
}
#endif

int android_bootloader_boot_kernel(unsigned long kernel_address)
{
	char kernel_addr_str[12];
	char *fdt_addr = env_get("fdt_addr");
	char *bootm_args[] = {
		"bootm", kernel_addr_str, kernel_addr_str, fdt_addr, NULL };

	sprintf(kernel_addr_str, "0x%lx", kernel_address);

	printf("Booting kernel at %s with fdt at %s...\n\n\n",
	       kernel_addr_str, fdt_addr);
	do_bootm(NULL, 0, 4, bootm_args);

	return -1;
}

static char *strjoin(const char **chunks, char separator)
{
	int len, joined_len = 0;
	char *ret, *current;
	const char **p;

	for (p = chunks; *p; p++)
		joined_len += strlen(*p) + 1;

	if (!joined_len) {
		ret = malloc(1);
		if (ret)
			ret[0] = '\0';
		return ret;
	}

	ret = malloc(joined_len);
	current = ret;
	if (!ret)
		return ret;

	for (p = chunks; *p; p++) {
		len = strlen(*p);
		memcpy(current, *p, len);
		current += len;
		*current = separator;
		current++;
	}
	/* Replace the last separator by a \0. */
	current[-1] = '\0';
	return ret;
}

/** android_assemble_cmdline - Assemble the command line to pass to the kernel
 * @return a newly allocated string
 */
char *android_assemble_cmdline(const char *slot_suffix,
				      const char *extra_args)
{
	const char *cmdline_chunks[16];
	const char **current_chunk = cmdline_chunks;
	char *env_cmdline, *cmdline, *rootdev_input, *serialno;
	char *allocated_suffix = NULL;
	char *allocated_serialno = NULL;
	char *allocated_rootdev = NULL;
	unsigned long rootdev_len;

	env_cmdline = env_get("bootargs");
	if (env_cmdline)
		*(current_chunk++) = env_cmdline;

	/* The |slot_suffix| needs to be passed to the kernel to know what
	 * slot to boot from.
	 */
	if (slot_suffix) {
		allocated_suffix = malloc(strlen(ANDROID_ARG_SLOT_SUFFIX) +
					  strlen(slot_suffix) + 1);
		memset(allocated_suffix, 0, strlen(ANDROID_ARG_SLOT_SUFFIX)
		       + strlen(slot_suffix) + 1);
		strcpy(allocated_suffix, ANDROID_ARG_SLOT_SUFFIX);
		strcat(allocated_suffix, slot_suffix);
		*(current_chunk++) = allocated_suffix;
	}

	serialno = env_get("serial#");
	if (serialno) {
		allocated_serialno = malloc(strlen(ANDROID_ARG_SERIALNO) +
					  strlen(serialno) + 1);
		memset(allocated_serialno, 0, strlen(ANDROID_ARG_SERIALNO) +
				strlen(serialno) + 1);
		strcpy(allocated_serialno, ANDROID_ARG_SERIALNO);
		strcat(allocated_serialno, serialno);
		*(current_chunk++) = allocated_serialno;
	}

	rootdev_input = env_get("android_rootdev");
	if (rootdev_input) {
		rootdev_len = strlen(ANDROID_ARG_ROOT) + CONFIG_SYS_CBSIZE + 1;
		allocated_rootdev = malloc(rootdev_len);
		strcpy(allocated_rootdev, ANDROID_ARG_ROOT);
		cli_simple_process_macros(rootdev_input,
					  allocated_rootdev +
					  strlen(ANDROID_ARG_ROOT));
		/* Make sure that the string is null-terminated since the
		 * previous could not copy to the end of the input string if it
		 * is too big.
		 */
		allocated_rootdev[rootdev_len - 1] = '\0';
		*(current_chunk++) = allocated_rootdev;
	}

	if (extra_args)
		*(current_chunk++) = extra_args;

	*(current_chunk++) = NULL;
	cmdline = strjoin(cmdline_chunks, ' ');
	free(allocated_suffix);
	free(allocated_rootdev);
	return cmdline;
}

#ifdef CONFIG_ANDROID_AVB
static void slot_set_unbootable(AvbABSlotData* slot)
{
	slot->priority = 0;
	slot->tries_remaining = 0;
	slot->successful_boot = 0;
}

static AvbSlotVerifyResult android_slot_verify(char *boot_partname,
			       unsigned long load_address,
			       char *slot_suffix)
{
	const char *requested_partitions[1] = {NULL};
	uint8_t unlocked = true;
	AvbOps *ops;
	AvbSlotVerifyFlags flags;
	AvbSlotVerifyData *slot_data[1] = {NULL};
	AvbSlotVerifyResult verify_result;
	AvbABData ab_data, ab_data_orig;
	size_t slot_index_to_boot = 0;

	requested_partitions[0] = boot_partname;
	ops = avb_ops_user_new();
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return AVB_SLOT_VERIFY_RESULT_ERROR_OOM;
	}

	if (ops->read_is_device_unlocked(ops, (bool *)&unlocked) != AVB_IO_RESULT_OK)
		printf("Error determining whether device is unlocked.\n");

	printf("read_is_device_unlocked() ops returned that device is %s\n",
	       (unlocked & LOCK_MASK)? "UNLOCKED" : "LOCKED");

	flags = AVB_SLOT_VERIFY_FLAGS_NONE;
	if (unlocked & LOCK_MASK)
		flags |= AVB_SLOT_VERIFY_FLAGS_ALLOW_VERIFICATION_ERROR;

	if(load_metadata(ops->ab_ops, &ab_data, &ab_data_orig)) {
		printf("Can not load metadata\n");
		return AVB_SLOT_VERIFY_RESULT_ERROR_IO;
	}

	if (strncmp(slot_suffix, "_a", 2))
		slot_index_to_boot = 0;
	else if(strncmp(slot_suffix, "_b", 2))
		slot_index_to_boot = 1;
	else
		slot_index_to_boot = 0;

	verify_result =
	avb_slot_verify(ops,
			requested_partitions,
			slot_suffix,
			flags,
			AVB_HASHTREE_ERROR_MODE_RESTART_AND_INVALIDATE,
			&slot_data[0]);

	if (verify_result != AVB_SLOT_VERIFY_RESULT_OK && !(unlocked & LOCK_MASK)) {
		slot_set_unbootable(&ab_data.slots[slot_index_to_boot]);
		goto out;
	}

	memcpy((uint8_t*)load_address,
	       slot_data[0]->loaded_partitions->data,
	       slot_data[0]->loaded_partitions->data_size);
	env_set("bootargs", slot_data[0]->cmdline);

	/* ... and decrement tries remaining, if applicable. */
	if (!ab_data.slots[slot_index_to_boot].successful_boot &&
		ab_data.slots[slot_index_to_boot].tries_remaining > 0) {
		ab_data.slots[slot_index_to_boot].tries_remaining -= 1;
	}
out:
	if (save_metadata_if_changed(ops->ab_ops, &ab_data, &ab_data_orig)) {
		printf("Can not save metadata\n");
		verify_result = AVB_SLOT_VERIFY_RESULT_ERROR_IO;
	}

	if (slot_data[0] != NULL)
		avb_slot_verify_data_free(slot_data[0]);

	if (unlocked & LOCK_MASK)
		return 0;
	else
		return verify_result;
}
#endif

int android_bootloader_boot_flow(struct blk_desc *dev_desc,
				 unsigned long load_address)
{
	enum android_boot_mode mode;
	disk_partition_t misc_part_info;
	int part_num;
	int ret;
	char *command_line;
	char slot_suffix[3] = {0};
	const char *mode_cmdline = NULL;
	char *boot_partname = ANDROID_PARTITION_BOOT;
	ulong fdt_addr;

	/*
	 * 1. Load MISC partition and determine the boot mode
	 *   clear its value for the next boot if needed.
	 */
	part_num = part_get_info_by_name(dev_desc, ANDROID_PARTITION_MISC,
					 &misc_part_info);
	if (part_num < 0)
		printf("%s Could not find misc partition\n", __func__);

#ifdef CONFIG_OPTEE_CLIENT
	/* load attestation key from misc partition. */
	load_attestation_key(dev_desc, &misc_part_info);
#endif

	mode = android_bootloader_load_and_clear_mode(dev_desc, &misc_part_info);
#ifdef CONFIG_RKIMG_BOOTLOADER
	if (mode == ANDROID_BOOT_MODE_NORMAL) {
		if (rockchip_get_boot_mode() == BOOT_MODE_RECOVERY)
			mode = ANDROID_BOOT_MODE_RECOVERY;
	}
#endif
	printf("ANDROID: reboot reason: \"%s\"\n", android_boot_mode_str(mode));

	switch (mode) {
	case ANDROID_BOOT_MODE_NORMAL:
		/* In normal mode, we load the kernel from "boot" but append
		 * "skip_initramfs" to the cmdline to make it ignore the
		 * recovery initramfs in the boot partition.
		 */
#ifdef CONFIG_ANDROID_AB
		mode_cmdline = "skip_initramfs";
#endif
		break;
	case ANDROID_BOOT_MODE_RECOVERY:
		/* In recovery mode we still boot the kernel from "boot" but
		 * don't skip the initramfs so it boots to recovery.
		 */
#ifndef CONFIG_ANDROID_AB
		boot_partname = ANDROID_PARTITION_RECOVERY;
#endif
		break;
	case ANDROID_BOOT_MODE_BOOTLOADER:
		/* Bootloader mode enters fastboot. If this operation fails we
		 * simply return since we can't recover from this situation by
		 * switching to another slot.
		 */
		return android_bootloader_boot_bootloader();
	}

#ifdef CONFIG_ANDROID_AB
	/*TODO: get from pre-loader or misc partition*/
	if (rk_avb_get_current_slot(slot_suffix))
		return -1;

	if (slot_suffix[0] != '_') {
		printf("There is no bootable slot!\n");
		return -1;
	}
#endif

#ifdef CONFIG_ANDROID_AVB
	if (android_slot_verify(boot_partname, load_address, slot_suffix))
		return -1;
#else
	/*
	 * 2. Load the boot/recovery from the desired "boot" partition.
	 * Determine if this is an AOSP image.
	 */
	disk_partition_t boot_part_info;
	part_num =
	    android_part_get_info_by_name_suffix(dev_desc,
						 boot_partname,
						 slot_suffix, &boot_part_info);
	if (part_num < 0) {
		printf("%s Could not found bootable partition %s\n", __func__,
		       boot_partname);
		return -1;
	}
	debug("ANDROID: Loading kernel from \"%s\", partition %d.\n",
	      boot_part_info.name, part_num);

	ret = android_image_load(dev_desc, &boot_part_info, load_address,
				 -1UL);
	if (ret < 0) {
		printf("%s %s part load fail\n", __func__, boot_part_info.name);
		return ret;
	}
	load_address = ret;
#endif

	/* Set Android root variables. */
	env_set_ulong("android_root_devnum", dev_desc->devnum);
	env_set("android_slotsufix", slot_suffix);

#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
	/* read oem unlock status and attach to bootargs */
	uint8_t unlock = 0;
	TEEC_Result result;
	char oem_unlock[OEM_UNLOCK_ARG_SIZE] = {0};
	result = trusty_read_oem_unlock(&unlock);
	if (result) {
		printf("read oem unlock status with error : 0x%x\n", result);
	} else {
		snprintf(oem_unlock, OEM_UNLOCK_ARG_SIZE, "androidboot.oem_unlocked=%d", unlock);
		env_update("bootargs", oem_unlock);
	}
#endif

	/* Assemble the command line */
	command_line = android_assemble_cmdline(slot_suffix, mode_cmdline);
	env_update("bootargs", command_line);

	debug("ANDROID: bootargs: \"%s\"\n", command_line);

#ifdef CONFIG_SUPPORT_OEM_DTB
	if (android_bootloader_get_fdt(ANDROID_PARTITION_OEM,
				       ANDROID_ARG_FDT_FILENAME)) {
		printf("Can not get the fdt data from oem!\n");
	}
#else
	ret = android_image_get_fdt((void *)load_address, &fdt_addr);
	if (!ret)
		env_set_hex("fdt_addr", fdt_addr);
#endif
	android_bootloader_boot_kernel(load_address);

	/* TODO: If the kernel doesn't boot mark the selected slot as bad. */
	return -1;
}

int android_avb_boot_flow(char *slot_suffix, unsigned long kernel_address)
{
	struct blk_desc *dev_desc;
	disk_partition_t boot_part_info;
	int ret;
	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -1;
	}
	/* Load the kernel from the desired "boot" partition. */
	android_part_get_info_by_name_suffix(dev_desc,
					     ANDROID_PARTITION_BOOT,
					     slot_suffix, &boot_part_info);
	ret = android_image_load(dev_desc, &boot_part_info, kernel_address,
				 -1UL);
	if (ret < 0)
		return ret;
	android_bootloader_boot_kernel(kernel_address);

	/* TODO: If the kernel doesn't boot mark the selected slot as bad. */
	return -1;
}

int android_boot_flow(unsigned long kernel_address)
{
	struct blk_desc *dev_desc;
	disk_partition_t boot_part_info;
	int ret;
	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -1;
	}
	/* Load the kernel from the desired "boot" partition. */
	part_get_info_by_name(dev_desc, ANDROID_PARTITION_BOOT, &boot_part_info);
	ret = android_image_load(dev_desc, &boot_part_info, kernel_address,
				 -1UL);
	if (ret < 0)
		return ret;
	android_bootloader_boot_kernel(kernel_address);

	/* TODO: If the kernel doesn't boot mark the selected slot as bad. */
	return -1;
}
