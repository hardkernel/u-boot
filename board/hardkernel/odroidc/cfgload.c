/*
 * (C) Copyright 2014 Hardkernel Co,.Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <command.h>

int do_fat_cfgload(cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{
	int ret;

	ret = run_command("fatload mmc 0:1 $loadaddr boot.ini", 0);
	if (ret)
		goto load_err;

	printf("boot.ini is loaded from FAT to 0x%s\n", getenv("loadaddr"));

	ret = run_command("ini boot $loadaddr $filesize", 0);

load_err:
	return ret;
}

U_BOOT_CMD(
	cfgload, 1, 0, do_fat_cfgload,
	"cfgload - Load boot.ini from FAT/EXT4 partitioin in a memory card\n",
	"    Loads boot.ini in FAT/EXT4 partition of one of below\n"
	"        1. /boot.ini in the 1st partition (FAT)\n"
	"        2. /boot/boot.ini in the 1st partiton (EXT4)\n"
	"        3. /boot/boot.ini in the 2nd partiton (EXT4)\n"
);
