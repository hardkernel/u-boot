
/*
 * arch/arm/include/asm/arch-txl/mailbox.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

 /*
  *
 * Copyright (C) 2012 Amlogic, Inc.
 *
 * Author: Platform-SH@amlogic.com
 *
 */

#ifndef __GXBB_MAILBOX_H_
#define __GXBB_MAILBOX_H_

#define SCPI_CMD_SENSOR_VALUE 0x1C
#define SCPI_CMD_SET_USR_DATA 0x20
#define SCPI_CMD_OPEN_SCP_LOG 0xC4
#define SCPI_CMD_THERMAL_CALIB 0xC5

#define SCPI_CMD_USB_BOOT 0xB0
#define SCPI_CMD_USB_UNBOOT 0xB1
#define SCPI_CMD_SDCARD_BOOT 0xB2
#define SCPI_CMD_CLEAR_BOOT 0xB3

#define SCPI_CMD_REV_PWM_DELT 0x42
#ifdef CONFIG_RING
#define SCPI_CMD_OSCRING_VALUE 0x43
#endif
#define LOW_PRIORITY	0
#define HIGH_PRIORITY 1

#define P_SHARE_SRAM_BASE	0xfffa0000
#define SRAM_SIZE		0x38000
#define MHU_HIGH_SCP_TO_AP_PAYLOAD		(SRAM_SIZE - 0xc00)
#define MHU_HIGH_AP_TO_SCP_PAYLOAD		(MHU_HIGH_SCP_TO_AP_PAYLOAD + 0x200)
#define MHU_LOW_SCP_TO_AP_PAYLOAD		(SRAM_SIZE - 0x1000)
#define MHU_LOW_AP_TO_SCP_PAYLOAD		(MHU_LOW_SCP_TO_AP_PAYLOAD + 0x200)

enum scpi_client_id {
	SCPI_CL_NONE,
	SCPI_CL_CLOCKS,
	SCPI_CL_DVFS,
	SCPI_CL_POWER,
	SCPI_CL_THERMAL,
	SCPI_CL_REMOTE,
	SCPI_CL_LED_TIMER,
	SCPI_MAX = 0xff,
};

enum scpi_error_codes {
	SCPI_SUCCESS = 0, /* Success */
	SCPI_ERR_PARAM = 1, /* Invalid parameter(s) */
	SCPI_ERR_ALIGN = 2, /* Invalid alignment */
	SCPI_ERR_SIZE = 3, /* Invalid size */
	SCPI_ERR_HANDLER = 4, /* Invalid handler/callback */
	SCPI_ERR_ACCESS = 5, /* Invalid access/permission denied */
	SCPI_ERR_RANGE = 6, /* Value out of range */
	SCPI_ERR_TIMEOUT = 7, /* Timeout has occurred */
	SCPI_ERR_NOMEM = 8, /* Invalid memory area or pointer */
	SCPI_ERR_PWRSTATE = 9, /* Invalid power state */
	SCPI_ERR_SUPPORT = 10, /* Not supported or disabled */
	SCPI_ERR_DEVICE = 11, /* Device error */
	SCPI_ERR_MAX
};

void open_scp_log(unsigned int channel);
int thermal_calibration(unsigned int type, unsigned int data);
int thermal_get_value(unsigned int sensor_id, unsigned int *value);
int send_usr_data(unsigned int clinet_id, unsigned int *val, unsigned int size);
void send_pwm_delt(int32_t vcck_delt, int32_t ee_delt);
void set_boot_first_timeout(unsigned int command);
#ifdef CONFIG_RING
int efuse_get_value(unsigned char *efuseinfo);
#endif
#endif
