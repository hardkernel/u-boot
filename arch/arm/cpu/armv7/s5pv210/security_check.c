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
#include <secure_boot.h>

void security_check(void)
{
	/* do security check */
	if(Check_Signature( (SecureBoot_CTX *)SECURE_BOOT_CONTEXT_ADDR,
			(unsigned char*)CONFIG_SECURE_KERNEL_BASE, 
			CONFIG_SECURE_KERNEL_SIZE-128,
			(unsigned char*)(CONFIG_SECURE_KERNEL_BASE+CONFIG_SECURE_KERNEL_SIZE-128),
			128 ) != 0) {
		printf("Kernel Integrity check fail\nSystem Halt....");
		while(1);
	}
	printf("Kernel Integirty check success.\n");

#ifdef CONFIG_SECURE_ROOTFS
	if(Check_Signature( (SecureBoot_CTX *)SECURE_BOOT_CONTEXT_ADDR,
			(unsigned char*)CONFIG_SECURE_ROOTFS_BASE,
			CONFIG_SECURE_ROOTFS_SIZE-128,
			(unsigned char*)(CONFIG_SECURE_ROOTFS_BASE+CONFIG_SECURE_ROOTFS_SIZE-128),
			128 ) != 0) {
		printf("rootfs Integrity check fail\nSystem Halt....");
		while(1);
	}
	printf("rootfs Integirty check success.\n");
#endif
}

