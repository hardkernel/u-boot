
/*
 *  Copyright (C) 2002 ARM Ltd.
 *  All Rights Reserved
 *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/*
 * Trustzone API
 *
 * Copyright (C) 2012 Amlogic, Inc.
 *
 * Author: Platform-SH@amlogic.com
 *
 */

#ifndef __MESON8_TRUSTZONE_H
#define __MESON8_TRUSTZONE_H

#include <asm/arch/io.h>

/* SMC Identifiers for non-secure world functions */
#define CALL_TRUSTZONE_API                      0x1
#define CALL_TRUSTZONE_MON                      0x4
#define CALL_TRUSTZONE_HAL_API                  0x5

/* Secure Monitor mode APIs */
#define TRUSTZONE_MON_TYPE_MASK                 0xF00
#define TRUSTZONE_MON_FUNC_MASK                 0x0FF
#define TRUSTZONE_MON_L2X0                      0x100
#define TRUSTZONE_MON_L2X0_CTRL_INDEX           0x101
#define TRUSTZONE_MON_L2X0_AUXCTRL_INDEX        0x102
#define TRUSTZONE_MON_L2X0_PREFETCH_INDEX       0x103

#define TRUSTZONE_MON_CORE                      0x200
#define TRUSTZONE_MON_CORE_RD_CTRL_INDEX        0x201
#define TRUSTZONE_MON_CORE_WR_CTRL_INDEX        0x202
#define TRUSTZONE_MON_CORE_RD_STATUS0_INDEX     0x203
#define TRUSTZONE_MON_CORE_WR_STATUS0_INDEX     0x204
#define TRUSTZONE_MON_CORE_RD_STATUS1_INDEX     0x205
#define TRUSTZONE_MON_CORE_WR_STATUS1_INDEX     0x206
#define TRUSTZONE_MON_CORE_BOOTADDR_INDEX       0x207
#define TRUSTZONE_MON_CORE_DDR_INDEX            0x208
#define TRUSTZONE_MON_CORE_RD_SOC_REV1          0x209
#define TRUSTZONE_MON_CORE_RD_SOC_REV2          0x20A

#define TRUSTZONE_MON_SUSPNED_FIRMWARE          0x300
#define TRUSTZONE_MON_SUSPNED_FIRMWARE_INIT     0x301
#define TRUSTZONE_MON_SUSPNED_FIRMWARE_UBOOT    0x302

#define TRUSTZONE_MON_SAVE_CPU_GIC              0x400

#define TRUSTZONE_MON_RTC                       0x500
#define TRUSTZONE_MON_RTC_RD_REG_INDEX          0x501
#define TRUSTZONE_MON_RTC_WR_REG_INDEX          0x502

/* Secure HAL APIs */
#define TRUSTZONE_HAL_TYPE_MASK                 0xF00
#define TRUSTZONE_HAL_API_EFUSE                 0x100
#define TRUSTZONE_HAL_API_STORAGE               0x200
#define TRUSTZONE_HAL_API_MEMCONFIG             0x300
#define TRUSTZONE_HAL_API_SRAM                  0x400


/* Secure OS defines */
#define SECURE_OS_COMPRESS_ADDR                 0x0E000000
#define SECURE_OS_ACS_SRAM_ADDR                 0xD9000200
#define SECURE_OS_ACS_DRAM_ADDR                 0x0E400000
#define SECURE_OS_ACS_LEN                       0x00000400

#define SECURE_OS_SRAM_BASE (512+32)
#define SECURE_OS_OFFSET_POSITION_IN_SRAM       (SECURE_OS_SRAM_BASE-4)
#define SECURE_OS_SIZE_POSITION_IN_SRAM         (SECURE_OS_SRAM_BASE-4-4)
// secure arguments address in SRAM
#define SECUREARGS_ADDRESS_IN_SRAM              (SECURE_OS_SRAM_BASE-4-4-4)


#ifdef CONFIG_MESON_STORAGE_BURN
struct storage_hal_api_arg{
	unsigned int cmd;
	unsigned int namelen;
	unsigned int name_phy_addr;
	unsigned int datalen;
	unsigned int data_phy_addr;	
	unsigned int retval_phy_addr;
};

#define STORAGE_HAL_API_INIT            0
#define STORAGE_HAL_API_WRITE           1
#define STORAGE_HAL_API_QUERY           2
#ifdef CONFIG_MESON_STORAGE_DEBUG
#define STORAGE_HAL_API_READ            3
#endif

#endif

#define SRAM_HAL_API_CAS 0x401
#define SRAM_HAL_API_CHECK 0x402
#define SRAM_HAL_API_CHECK_EFUSE 0x403
struct sram_hal_api_arg {
	unsigned int cmd;
	unsigned int req_len;
	unsigned int res_len;
	unsigned int req_phy_addr;
	unsigned int res_phy_addr;
	unsigned int ret_phy_addr;
};

uint32_t meson_trustzone_rtc_read_reg32(uint32_t addr);
uint32_t meson_trustzone_rtc_write_reg32(uint32_t addr, uint32_t value);
uint32_t meson_trustzone_sram_read_reg32(uint32_t addr);
uint32_t meson_trustzone_acs_addr(uint32_t addr);
uint32_t meson_trustzone_boot_check(unsigned char *addr);

#endif
