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
#include <asm/arch/mailbox.h>
#define LOADER_BL40_ADDR 0x20000000
static int do_load_send_bl40(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	unsigned long addr, length;

	if (argc <= 1) {
		printf("plese input bl40 args: addrss and size !\n");
		return CMD_RET_USAGE;
	}

	addr = simple_strtoul(argv[1], NULL, 16);
	length = simple_strtoul(argv[2], NULL, 16);
	if (addr < LOADER_BL40_ADDR) {
		printf("LOAD bl40 addr must greater than or equal to 0x20000000!\n");
		return CMD_RET_USAGE;
	}

	printf("bl40 start address:0x%lx,size:0x%lx\n",addr, length);
	bl40_wait_unlock();
	return send_bl40(addr, length);
}

U_BOOT_CMD(
	ld_bl40,	3,	1,	do_load_send_bl40,
	"load bl40 and run bl40.bin from bl33",
	"load bl40 format:\n"
	"	ld_bl40 address size!\n"
	"	load bl40 address must greater than or equal to 0x20000000!\n"
);
