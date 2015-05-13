
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/include/mailbox.h
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

#ifndef __BL2_MAILBOX_H_
#define __BL2_MAILBOX_H_

#define MB_SRAM_BASE 0xd9013800

#define CMD_SHA         0xc0de0001
#define CMD_OP_SHA      0xc0de0002
#define CMD_DATA_LEN    0xc0dec0d0
#define CMD_DATA        0xc0dec0de
#define CMD_END         0xe00de00d

void *memcpy_t(void *dest, const void *src, size_t len);
void mb_send_data(uint32_t val, uint32_t port);
uint32_t mb_read_data(uint32_t port);
void mb_clear_data(uint32_t val, uint32_t port);
void send_bl30x(uint32_t addr, uint32_t size, const uint8_t * sha2,
	uint32_t sha2_length, const char * name);

#endif /*__BL2_MAILBOX_H_*/