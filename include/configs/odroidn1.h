/*
 * (C) Copyright 2016 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __EVB_RK3399_H
#define __EVB_RK3399_H

#include <configs/rk3399_common.h>

#define CONFIG_ENV_IS_IN_MMC
#define CONFIG_SYS_MMC_ENV_DEV 0
/*
 * SPL @ 32k for ~128k
 * ENV @ 240k
 * u-boot @ 256K
 */
#undef CONFIG_ENV_OFFSET
#define CONFIG_ENV_OFFSET (240 * 1024)

#define SDRAM_BANK_SIZE			(2UL << 30)

#define CONFIG_BOOTP_BOOTPATH
#define CONFIG_BOOTP_DNS
#define CONFIG_BOOTP_GATEWAY
#define CONFIG_BOOTP_HOSTNAME
#define CONFIG_BOOTP_PXE
#define CONFIG_BOOTP_SUBNETMASK

#define CONFIG_CMDLINE_EDITING
#define CONFIG_AUTO_COMPLETE
#define CONFIG_SYS_LONGHELP
#define CONFIG_SUPPORT_RAW_INITRD
#define CONFIG_ENV_VARS_UBOOT_CONFIG

#undef CONFIG_EXTRA_ENV_SETTINGS
#define MTDPARTS_DOS	\
	"mtdparts=rk29xxnand:0x00040000@0x00513800(fat),0x00300000@0x00213800(system),"		\
	"0x00200000@0x00013800(cache),-@0x00553800(userdata)"
#define ANDROID_OPT	\
	"androidboot.baseband=N/A androidboot.selinux=disabled androidboot.hardware=odroidn1 "	\
	"androidboot.console=ttyFIQ0"

#define CONFIG_EXTRA_ENV_SETTINGS \
	"fdt_addr_r=0x04800000\0" \
	"kernel_addr_r=0x02000000\0" \
	"ramdisk_addr_r=0x04000000\0" \
	"storagemedia=na\0" \
	"setbootargs=setenv bootargs earlycon=uart8250,mmio32,0xff1a0000 swiotlb=1"	\
		" storagemedia=${storagemedia} "ANDROID_OPT	\
		" root=/dev/mmcblk0p2 rw rootfstype=ext4 init=/init "	\
		MTDPARTS_DOS" SecureBootCheckOk=0\0"	\
	"bootcmd=cfgload; run setbootargs; mmc dev ${bootdev}; movi read kernel 0 ${kernel_addr_r}; "	\
		"movi read dtb 0 ${fdt_addr_r}; "	\
		"booti ${kernel_addr_r} - ${fdt_addr_r}\0"

#define CONFIG_BOARD_LATE_INIT

#endif
