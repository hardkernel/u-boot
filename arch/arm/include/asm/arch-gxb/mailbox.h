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
  *
 * Copyright (C) 2012 Amlogic, Inc.
 *
 * Author: Platform-SH@amlogic.com
 *
 */

#ifndef __GXBB_MAILBOX_H_
#define __GXBB_MAILBOX_H_

#define SCPI_CMD_SENSOR_VALUE 0x1C
#define SCPI_CMD_OPEN_SCP_LOG 0xC4
#define SCPI_CMD_THERMAL_CALIB 0xC5

#define LOW_PRIORITY	0
#define HIGH_PRIORITY 1

#define P_SHARE_SRAM_BASE    0xc8000000
#define MHU_HIGH_SCP_TO_AP_PAYLOAD		0x13400
#define MHU_HIGH_AP_TO_SCP_PAYLOAD		0x13600
#define MHU_LOW_SCP_TO_AP_PAYLOAD		0x13000
#define MHU_LOW_AP_TO_SCP_PAYLOAD		0x13200

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

void open_scp_log(void);
int thermal_calibration(unsigned int type, unsigned int data);
int thermal_get_value(unsigned int sensor_id, unsigned int *value);

 #endif
