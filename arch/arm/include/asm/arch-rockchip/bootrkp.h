/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __BOOTRKP_H_
#define __BOOTRKP_H_

enum android_boot_mode {
	ANDROID_BOOT_MODE_NORMAL = 0,

	/* "recovery" mode is triggered by the "reboot recovery" command or
	 * equivalent adb/fastboot command. It can also be triggered by writing
	 * "boot-recovery" in the BCB message. This mode should boot the
	 * recovery kernel.
	 */
	ANDROID_BOOT_MODE_RECOVERY,

	/* "bootloader" mode is triggered by the "reboot bootloader" command or
	 * equivalent adb/fastboot command. It can also be triggered by writing
	 * "bootonce-bootloader" in the BCB message. This mode should boot into
	 * fastboot.
	 */
	ANDROID_BOOT_MODE_BOOTLOADER,
};

int rockchip_get_boot_mode(void);

#endif
