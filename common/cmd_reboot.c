
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
#include <asm/arch/reboot.h>
#include <asm/arch/secure_apb.h>
#include <asm/io.h>

/*
run get_rebootmode  //set reboot_mode env with current mode
*/

int do_get_rebootmode (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	uint32_t reboot_mode_val;
	reboot_mode_val = ((readl(AO_SEC_SD_CFG15) >> 12) & 0xf);

	debug("reboot_mode(0x%x)=0x%x\n", AO_SEC_SD_CFG15, reboot_mode_val);

	switch (reboot_mode_val)
	{
		case AMLOGIC_COLD_BOOT:
		{
			setenv("reboot_mode","cold_boot");
			break;
		}
		case AMLOGIC_NORMAL_BOOT:
		{
			setenv("reboot_mode","normal");
			break;
		}
		case AMLOGIC_FACTORY_RESET_REBOOT:
		{
			setenv("reboot_mode","factory_reset");
			break;
		}
		case AMLOGIC_UPDATE_REBOOT:
		{
			setenv("reboot_mode","update");
			break;
		}
		case AMLOGIC_USB_BURNING_REBOOT:
		{
			setenv("reboot_mode","usb_burning");
			break;
		}
		case AMLOGIC_SUSPEND_REBOOT:
		{
			setenv("reboot_mode","suspend_off");
			break;
		}
		case AMLOGIC_HIBERNATE_REBOOT:
		{
			setenv("reboot_mode","hibernate");
			break;
		}
		case AMLOGIC_CRASH_REBOOT:
		{
			setenv("reboot_mode","crash_dump");
			break;
		}
		default:
		{
			setenv("reboot_mode","charging");
			break;
		}
	}

	return 0;
}

U_BOOT_CMD(
	get_rebootmode,	1,	0,	do_get_rebootmode,
	"get reboot mode",
	"/N\n"
	"This command will set 'reboot_mode'\n"
);
