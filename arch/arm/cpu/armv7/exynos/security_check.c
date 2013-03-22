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

#include <asm/arch/ace_sha1.h>
#include <asm/arch/movi_partition.h>

#include "uboot_sb21.h"

void security_check(void)
{
	unsigned char hash_code[20];
	unsigned int bl1_size = PART_SIZE_FWBL1;
	unsigned int secure_context_base;

	if(bl1_size == (15 * 1024)) {
		secure_context_base = 0x40003800;
	} else
		secure_context_base = 0x40001c00;

	ace_hash_sha1_digest(hash_code, (unsigned char *)CONFIG_SECURE_KERNEL_BASE, CONFIG_SECURE_KERNEL_SIZE-256);

	if(check_signature( (SB20_CONTEXT *)secure_context_base,
			hash_code, 20,
			(unsigned char*)(CONFIG_SECURE_KERNEL_BASE+CONFIG_SECURE_KERNEL_SIZE-256),
			256 ) != 0) {
		printf("Kernel Integrity check fail\nSystem Halt....");
		while(1);
	}
	printf("Kernel Integirty check success.\n");

#ifdef CONFIG_SECURE_ROOTFS
	ace_hash_sha1_digest(hash_code, (unsigned char *)CONFIG_SECURE_ROOTFS_BASE, CONFIG_SECURE_ROOTFS_SIZE-256);

	if(check_signature( (SB20_CONTEXT *)secure_context_base,
			hash_code, 20,
			(unsigned char*)(CONFIG_SECURE_ROOTFS_BASE+CONFIG_SECURE_ROOTFS_SIZE-256),
			256 ) != 0) {
		printf("rootfs Integrity check fail\nSystem Halt....");
		while(1);
	}
	printf("rootfs Integirty check success.\n");
#endif
}

