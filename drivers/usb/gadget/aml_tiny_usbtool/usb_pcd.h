
/*
 * drivers/usb/gadget/aml_tiny_usbtool/usb_pcd.h
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

#ifndef __USB_PCD_H__
#define __USB_PCD_H__
#include <asm/types.h>

#define CMD_BUFF_SIZE		512

int usb_pcd_init(void);
int usb_pcd_irq(void);

// Vendor request defines
#define AM_REQ_WRITE_MEM	0x01
#define AM_REQ_READ_MEM	0x02
#define AM_REQ_FILL_MEM	0x03
#define AM_REQ_MODIFY_MEM	0x04
#define AM_REQ_RUN_IN_ADDR	0x05
#define AM_REQ_WRITE_AUX	0x06
#define AM_REQ_READ_AUX		0x07

#define AM_REQ_WR_LARGE_MEM	0x11
#define AM_REQ_RD_LARGE_MEM	0x12
#define AM_REQ_IDENTIFY_HOST	0x20

#define AM_REQ_TPL_CMD	0x30
#define AM_REQ_TPL_STAT 0x31

#define AM_REQ_PASSWORD 0x35
#define AM_REQ_NOP		0x36

#define AM_RUNNING_FLAGS_KEEP_POWER_ON	0x10


void do_modify_memory(u16 opcode, char *inbuff);

#endif
