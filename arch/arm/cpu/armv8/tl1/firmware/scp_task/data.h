
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/data.h
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

#define TASK_COMMAND_OFFSET 0
#define TASK_RESPONSE_OFFSET  0x200

unsigned char
	*secure_task_share_mem = (unsigned char *)SECURE_TASK_SHARE_MEM_BASE;
unsigned char *high_task_share_mem = (unsigned char *)HIGH_TASK_SHARE_MEM_BASE;
unsigned char *low_task_share_mem = (unsigned char *)LOW_TASK_SHARE_MEM_BASE;

struct resume_param {
/* wakeup method: remote, ..., */
	unsigned int method;
};
struct resume_param resume_data;