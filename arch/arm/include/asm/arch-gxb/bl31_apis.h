
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

#ifndef __GXBB_BL31_APIS_H
#define __GXBB_BL31_APIS_H

#include <asm/arch/io.h>

/*#define SRAM_READ				0x82000010
#define CORE_RD_REV1			0x82000011
#define SRAM_ACS_READ		0x82000012
#define SRAM_ACS_INDIRECT_READ		0x82000013*/

#define GET_SHARE_MEM_INPUT_BASE		0x82000020
#define GET_SHARE_MEM_OUTPUT_BASE		0x82000021

/* SECUREOS DEFINITION*/
/* SMC Identifiers for non-secure world functions */
#define CALL_TRUSTZONE_HAL_API                  0x5

/* EFUSE */
#define EFUSE_READ					0x82000030
#define EFUSE_WRITE				0x82000031
#define EFUSE_WRITE_PATTERN		0x82000032

#define DEBUG_EFUSE_WRITE_PATTERN	0x820000F0
#define DEBUG_EFUSE_READ_PATTERN	0x820000F1

/* JTAG*/
#define JTAG_ON                                0x82000040
#define JTAG_OFF                               0x82000041

/* Secure HAL APIs */
#define TRUSTZONE_HAL_API_SRAM                  0x400


#define SRAM_HAL_API_CHECK_EFUSE 0x403
struct sram_hal_api_arg {
	unsigned int cmd;
	unsigned int req_len;
	unsigned int res_len;
	unsigned long req_phy_addr;
	unsigned long res_phy_addr;
	unsigned long ret_phy_addr;
};

#define JTAG_STATE_ON  0
#define JTAG_STATE_OFF 1
#define JTAG_M3_AO     0
#define JTAG_M3_EE     1
#define JTAG_A53_AO    2
#define JTAG_A53_EE 3
void aml_set_jtag_state(unsigned state, unsigned select);

#endif
