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

#define SCPI_CMD_OPEN_SCP_LOG 0xC4

#define LOW_PRIORITY	0
#define HIGH_PRIORITY 1

#define P_SHARE_SRAM_BASE    0xc8000000
#define MHU_HIGH_SCP_TO_AP_PAYLOAD		0x13400
#define MHU_HIGH_AP_TO_SCP_PAYLOAD		0x13600
#define MHU_LOW_SCP_TO_AP_PAYLOAD		0x13000
#define MHU_LOW_AP_TO_SCP_PAYLOAD		0x13200

void open_scp_log(void);

 #endif
