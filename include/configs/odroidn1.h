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
#define MTDPARTS_BOOT	\
	"mtdparts_boot=rk29xxnand:0x00002000@0x00002000(uboot),0x00002000@0x00004000(trust),"		\
	"0x00000008@0x00006000(bcb),0x00008000@0x00006008(resource),0x0000C000@0x0000E008(kernel),"	\
	"0x00010000@0x0001A008(boot),0x00010000@0x0002A008(recovery),0x000007F8@0x0003A008(reserved)"
#define MTDPARTS_DOS	\
	"mtdparts=rk29xxnand:0x00040000@0x0053A800(fat),0x00300000@0x0023A800(system),"		\
	"0x00200000@0x0003A800(cache),-@0x0057A800(userdata)"
#define ANDROID_OPT	\
	"androidboot.baseband=N/A androidboot.selinux=disabled androidboot.hardware=odroidn1 "	\
	"androidboot.console=ttyFIQ0"

#define CONFIG_EXTRA_ENV_SETTINGS \
	"fdt_addr_r=0x04800000\0" \
	"kernel_addr_r=0x02000000\0" \
	"ramdisk_addr_r=0x04000000\0" \
	"bootargs=earlycon=uart8250,mmio32,0xff1a0000 swiotlb=1 "ANDROID_OPT" root=/dev/mmcblk0p2 rw rootfstype=ext4 init=/init "	\
		MTDPARTS_BOOT" " MTDPARTS_DOS" storagemedia=emmc uboot_logo=0x02000000@0x7dc00000 "	\
		"loader.timestamp=2017-10-12_13:49:27 SecureBootCheckOk=0\0" \
	"bootcmd=cfgload; movi read kernel 0 ${kernel_addr_r}; "	\
		"movi read dtb 0 ${fdt_addr_r}; "	\
		"booti ${kernel_addr_r} - ${fdt_addr_r}\0"

#define CONFIG_FASTBOOT_FLASH_MMC_DEV   0

#define CONFIG_BOARD_LATE_INIT

#endif
