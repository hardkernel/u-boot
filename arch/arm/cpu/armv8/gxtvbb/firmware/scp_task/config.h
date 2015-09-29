
/*
 * arch/arm/cpu/armv8/gxtvbb/firmware/scp_task/config.h
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

#define CONFIG_RAM_BASE        (0x10000000 + 40 * 1024)
#define CONFIG_RAM_SIZE         (13 * 1024)
#define CONFIG_RAM_END		(CONFIG_RAM_BASE+CONFIG_RAM_SIZE)

#define CONFIG_TASK_STACK_SIZE	1024
#define TASK_SHARE_MEM_SIZE	1024

#define SECURE_TASK_SHARE_MEM_BASE		0x1000D400
#define SECURE_TASK_RESPONSE_MEM_BASE 0x1000D600
#define HIGH_TASK_SHARE_MEM_BASE			0x1000D800
#define HIGH_TASK_RESPONSE_MEM_BASE		0x1000DA00
#define LOW_TASK_SHARE_MEM_BASE			0x1000DC00
#define LOW_TASK_RESPONSE_MEM_BASE		0x1000DE00

/*
  * BL30/BL301 share memory command list
*/
#define COMMAND_SUSPEND_ENTER			0x1
#define HIGH_TASK_SET_CLOCK	0x2
#define LOW_TASK_GET_DVFS_INFO 0x3
#define HIGH_TASK_GET_DVFS 0x4
#define HIGH_TASK_SET_DVFS 0x5

	/*bl301 resume to BL30*/
#define RESPONSE_SUSPEND_LEAVE			0x1
