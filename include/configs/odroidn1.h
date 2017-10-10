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
#define CONFIG_EXTRA_ENV_SETTINGS \
	"fdt_addr_r=0x01f00000\0" \
	"kernel_addr_r=0x02000000\0" \
	"ramdisk_addr_r=0x04000000\0" \
	"bootargs=earlycon=uart8250,mmio32,0xff1a0000 swiotlb=1 androidboot.baseband=N/A androidboot.selinux=permissive androidboot.hardware=odroidn1 androidboot.console=ttyFIQ0 init=/init\0" \
	"bootcmd=cfgload; fatload mmc 0 ${kernel_addr} Image; fatload mmc 0 ${ramdisk_addr_r} ramdisk.img; fatload mmc 0 ${fdt_addr_r} rk3399-odroidn1-rev0.dtb; booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr_r}\0"

#define CONFIG_FASTBOOT_FLASH_MMC_DEV   0
#endif
