/* usb pcd driver header */
/*
 * (C) Copyright 2010 Amlogic, Inc
 *
 * Victor Wan, victor.wan@amlogic.com,
 * 2010-03-24 @ Shanghai
 *
 */
#ifndef __USB_PCD_H__
#define __USB_PCD_H__
#include <asm/types.h>

#define CMD_BUFF_SIZE		512

int usb_pcd_init(void);
int usb_pcd_irq(void);
extern int optimus_working (const char *cmd, char* buff);

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
void do_modify_memory(u16 opcode, char *inbuff);

#define AM_REQ_DOWNLOAD     0X32
#define AM_REQ_UPLOAD       0X33
#define AM_REQ_BULKCMD      0X34
#define AM_BULK_REPLY_LEN   CMD_BUFF_SIZE

#endif
