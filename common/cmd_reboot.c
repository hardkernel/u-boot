/*
 * (C) Copyright 2012
 * Elvis Yu, Amlogic Software Engineering, elvis.yu@amlogic.com.
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
#include <asm/arch/reboot.h>

#ifdef CONFIG_RESET_TO_SYSTEM
#include <amlogic/aml_pmu_common.h>
#endif

int do_get_rebootmode (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	uint32_t reboot_mode_val;
#ifdef CONFIG_RESET_TO_SYSTEM
    struct aml_pmu_driver *pmu_driver = NULL;
    int     reboot_flag;
#endif
	reboot_mode_val = reboot_mode;

	debug("reboot_mode(0x%x)=0x%x\n", &reboot_mode, reboot_mode);
#ifdef CONFIG_RESET_TO_SYSTEM
    pmu_driver = aml_pmu_get_driver();
    if (pmu_driver && pmu_driver->pmu_reset_flag_operation) {
        reboot_flag = pmu_driver->pmu_reset_flag_operation(RESET_FLAG_GET);
        printf("reboot flag = %d\n", reboot_flag);
        if (reboot_flag) {
            printf("abnormal reboot, direct boot to Kernel now\n");
            run_command("run prepare; bmp display ${poweron_offset}; run bootcmd;", 0); 
        }
    }
#endif
	switch(reboot_mode_val)
	{
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
		case MESON_USB_BURNER_REBOOT:
		{
			setenv("reboot_mode","usb_burning");
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

int do_clear_rebootmode (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	reboot_mode_clear();
	return 0;
}


U_BOOT_CMD(
	get_rebootmode,	1,	0,	do_get_rebootmode,
	"get reboot mode",
	"/N\n"
	"This command will set 'reboot_mode'\n"
);

U_BOOT_CMD(
	clear_rebootmode,	1,	0,	do_clear_rebootmode,
	"clear rebootmode",
	"This command will clear reboot_mode\n"
);


