
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
#include <asm/reboot.h>
#include <asm/arch/secure_apb.h>
#include <asm/io.h>
#include <asm/arch/bl31_apis.h>
#include <asm/arch/watchdog.h>

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
		case AMLOGIC_FASTBOOT_REBOOT:
		{
			setenv("reboot_mode","fastboot");
			break;
		}
		case AMLOGIC_BOOTLOADER_REBOOT:
		{
			setenv("reboot_mode","bootloader");
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
		case AMLOGIC_KERNEL_PANIC:
		{
			setenv("reboot_mode","kernel_panic");
			break;
		}
		case AMLOGIC_WATCHDOG_REBOOT:
		{
			setenv("reboot_mode","watchdog_reboot");
			break;
		}
		default:
		{
			setenv("reboot_mode","charging");
			break;
		}
	}

#ifdef CONFIG_CMD_FASTBOOT
	switch (reboot_mode_val) {
		case AMLOGIC_FASTBOOT_REBOOT: {
			run_command("fastboot", 0);
			break;
		}
		case AMLOGIC_BOOTLOADER_REBOOT: {
			setenv("bootdelay","-1");
			break;
		}
	}
#endif

	return 0;
}

int do_reboot (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	uint32_t reboot_mode_val = AMLOGIC_NORMAL_BOOT;
	if (argc <= 1) {
		printf("reboot use default mode: normal\n");
	}
	else {
		printf("reboot mode: %s\n", argv[1]);
		char * mode = argv[1];
		if (strcmp(mode, "cold_boot") == 0)
			reboot_mode_val = AMLOGIC_COLD_BOOT;
		else if (strcmp(mode, "normal") == 0)
			reboot_mode_val = AMLOGIC_NORMAL_BOOT;
		else if (strcmp(mode, "recovery") == 0 || strcmp(mode, "factory_reset") == 0)
			reboot_mode_val = AMLOGIC_FACTORY_RESET_REBOOT;
		else if (strcmp(mode, "update") == 0)
			reboot_mode_val = AMLOGIC_UPDATE_REBOOT;
		else if (strcmp(mode, "fastboot") == 0)
			reboot_mode_val = AMLOGIC_FASTBOOT_REBOOT;
		else if (strcmp(mode, "bootloader") == 0)
			reboot_mode_val = AMLOGIC_BOOTLOADER_REBOOT;
		else if (strcmp(mode, "suspend_off") == 0)
			reboot_mode_val = AMLOGIC_SUSPEND_REBOOT;
		else if (strcmp(mode, "hibernate") == 0)
			reboot_mode_val = AMLOGIC_HIBERNATE_REBOOT;
		else if (strcmp(mode, "crash_dump") == 0)
			reboot_mode_val = AMLOGIC_CRASH_REBOOT;
		else if (strcmp(mode, "kernel_panic") == 0)
			reboot_mode_val = AMLOGIC_KERNEL_PANIC;
		else {
			printf("Can not find match reboot mode, use normal by default\n");
			reboot_mode_val = AMLOGIC_NORMAL_BOOT;
		}
	}
	aml_reboot (PSCI_SYS_REBOOT, reboot_mode_val, 0, 0);
	return 0;
}

/* USB BOOT FUNC sub command list*/
#define CLEAR_USB_BOOT			1
#define FORCE_USB_BOOT			2
#define RUN_COMD_USB_BOOT		3
#define PANIC_DUMP_USB_BOOT		4

int do_set_usb_boot(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	unsigned int usb_mode = 0;
	if (argc <= 1) {
		printf("usb flag default 0\n");
	}
	else {
		usb_mode = simple_strtoul(argv[1], NULL, 16);
	}
	printf("usb flag: %d\n", usb_mode);
	set_usb_boot_function(usb_mode);

	return 0;
}

U_BOOT_CMD(
	get_rebootmode,	1,	0,	do_get_rebootmode,
	"get reboot mode",
	"/N\n"
	"  This command will get and setenv 'reboot_mode'\n"
	"get_rebootmode\n"
);

U_BOOT_CMD(
	reboot,	2,	0,	do_reboot,
	"set reboot mode and reboot system",
	"[rebootmode]/N\n"
	"  This command will set reboot mode and reboot system\n"
	"\n"
	"  support following [rebootmode]:\n"
	"    cold_boot\n"
	"    normal[default]\n"
	"    factory_reset/recovery\n"
	"    update\n"
	"    fastboot\n"
	"    bootloader\n"
	"    suspend_off\n"
	"    hibernate\n"
	"    crash_dump\n"
);

U_BOOT_CMD(
	set_usb_boot,	2,	0,	do_set_usb_boot,
	"set usb boot mode",
	"[usb boot mode]/N\n"
	"  support following [usb boot mode]:\n"
	"    1: CLEAR_USB_BOOT\n"
	"    2: FORCE_USB_BOOT[default]\n"
	"    3: RUN_COMD_USB_BOOT/recovery\n"
	"    4: PANIC_DUMP_USB_BOOT\n"
);

int do_systemoff(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	aml_system_off();
	return 0;
}


U_BOOT_CMD(
	systemoff,	2,	1,	do_systemoff,
	"system off ",
	"systemoff "
);
