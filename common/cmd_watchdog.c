/*
 * common/cmd_watchdog.c
 *
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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


#include <common.h>
#include <command.h>
#include <asm/arch/watchdog.h>

static int do_watchdog(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	const char *cmd;
	char *endp;
	int timeout;

	if (argc != 2)
		return CMD_RET_USAGE;

	cmd = argv[1];

	if (strcmp(cmd, "off") == 0) {
		/* disable watchdog */
		watchdog_disable();
		return CMD_RET_SUCCESS;
	}

	timeout = simple_strtoul(cmd, &endp, 0);
	if (endp == cmd)
		return CMD_RET_USAGE;
	if (timeout < 0)
		return CMD_RET_USAGE;

	/* enable the watchdog and set timeout */
	timeout *= 1000;
	watchdog_init(timeout);

	return CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	watchdog, 2, 0,	do_watchdog,
	"enable or disable watchdog",
	"<timeout>	- enable watchdog with `timeout' seconds timeout\n"
	"watchdog off		- disable watchdog\n"
);

