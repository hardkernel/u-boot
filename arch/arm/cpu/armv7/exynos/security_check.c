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
#include <asm/arch/movi_partition.h>

#include "uboot_sb21.h"

void security_check(void)
{
	unsigned int secure_context_base;
	int ret;

	/* Set Secure Context Base Address*/
	secure_context_base = CONFIG_SYS_SDRAM_BASE + PART_SIZE_BL1 - 1024;

	/* Verify Kernel */
	ret = check_signature((SB20_CONTEXT *)secure_context_base,
			(unsigned char *)CONFIG_SECURE_KERNEL_BASE, CONFIG_SECURE_KERNEL_SIZE - 256,
			(unsigned char *)(CONFIG_SECURE_KERNEL_BASE +
			CONFIG_SECURE_KERNEL_SIZE - 256), 256);
	if (ret) {
		printf("Kernel Integrity check fail\nSystem Halt....");
		while (1);
	}
	printf("Kernel Integirty check success.\n");

#ifdef CONFIG_SECURE_ROOTFS
	/* Verify rootfs */
	ret = check_signature((SB20_CONTEXT *)secure_context_base,
			(unsigned char *)CONFIG_SECURE_ROOTFS_BASE, CONFIG_SECURE_ROOTFS_SIZE - 256,
			(unsigned char *)(CONFIG_SECURE_ROOTFS_BASE +
			CONFIG_SECURE_ROOTFS_SIZE - 256), 256);
	if (ret) {
		printf("rootfs Integrity check fail\nSystem Halt....");
		while (1);
	}
	printf("rootfs Integirty check success.\n");
#endif
}

