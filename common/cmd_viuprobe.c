/*
 * common/cmd_reboot.c
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

#include <common.h>
#include <command.h>
#include <asm/arch/bl31_apis.h>

static int do_viu_probe_enable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	set_viu_probe_enable();
	return 0;
}

U_BOOT_CMD(
	viu_probe,	2,	1,	do_viu_probe_enable,
	"enable viu probe in no secure chip",
	"enable viu probe in no secure chip"
);

