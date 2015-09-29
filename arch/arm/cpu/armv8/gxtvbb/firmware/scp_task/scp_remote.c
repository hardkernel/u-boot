
/*
 * arch/arm/cpu/armv8/gxtvbb/firmware/scp_task/scp_remote.c
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

#include "config.h"
#include "registers.h"
#include "task_apis.h"

enum{
	DECODEMODE_NEC = 0,
	DECODEMODE_DUOKAN = 1,
	DECODEMODE_RCMM ,
	DECODEMODE_SONYSIRC,
	DECODEMODE_SKIPLEADER ,
	DECODEMODE_MITSUBISHI,
	DECODEMODE_THOMSON,
	DECODEMODE_TOSHIBA,
	DECODEMODE_RC5,
	DECODEMODE_RC6,
	DECODEMODE_COMCAST,
	DECODEMODE_SANYO,
	DECODEMODE_MAX
};

#define IR_POWER_KEY_MASK 0xffffffff
static unsigned int kk[] = {
	0xe51afb04,
};
static int init_remote(void)
{
	uart_put_hex(readl(AO_IR_DEC_STATUS), 32);
	uart_put_hex(readl(AO_IR_DEC_FRAME), 32);
	return 0;
}

static int remote_detect_key(void)
{
	unsigned power_key;
	if (((readl(AO_IR_DEC_STATUS))>>3) & 0x1) {
		power_key = readl(AO_IR_DEC_FRAME);
		if ((power_key&IR_POWER_KEY_MASK) == kk[DECODEMODE_NEC])
			return 1;

	}
	return 0;
}
