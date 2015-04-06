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
#include <malloc.h>
#include <asm/arch/gpio.h>
#include <asm/arch/memory.h>
#include <asm/arch/usb.h>
#include <asm/mach-types.h>

DECLARE_GLOBAL_DATA_PTR;

extern void hdmi_tx_power_init(void);
extern void board_ir_init(void);
extern struct amlogic_usb_config g_usb_config_m6_skt_b;
extern struct amlogic_usb_config g_usb_config_m6_skt_h;

u32 get_board_rev(void)
{
	return 0x00001000;
}

int serial_set_pin_port(unsigned port_base)
{
	// GPIOAO_0 : tx, GPIOAO_1 : rx
	setbits_le32(P_AO_RTI_PIN_MUX_REG, 3 << 11);

        amlogic_set_pull_up(GPIOAO_0, 1, 1);
        amlogic_set_pull_up(GPIOAO_1, 1, 1);

	return 0;
}

int board_init(void)
{
	gd->bd->bi_arch_number = MACH_TYPE_MESON6_SKT;
	gd->bd->bi_boot_params = BOOT_PARAMS_OFFSET;

#ifdef CONFIG_IR_REMOTE
	board_ir_init();
#endif
#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m6_skt_b,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_h,BOARD_USB_MODE_CHARGER);
#endif

	amlogic_gpio_direction_output(GPIOAO_4, 0);	// USB HOST : Off
	amlogic_gpio_direction_output(GPIOAO_5, 0);	// USB OTG : Off
	amlogic_gpio_direction_output(GPIOAO_13, 0);	// BLUELED : On

	return 0;
}

/* Returns the reboot command bypassed by Linux kernel.
 * The register, P_AO_RTI_STATUS_REG1, must be changed since the register value
 * will be kept until power off or updated. Otherwise same reboot command will
 * be invoked.
 */
static u32 board_reboot_command()
{
        static u32 command = -1;

        if (command == -1) {
                command = readl(P_AO_RTI_STATUS_REG1);
                writel(0, P_AO_RTI_STATUS_REG1);
        }

        return command;
}

#if defined(CONFIG_BOARD_EARLY_INIT_F)
int board_early_init_f(void)
{
        /* Get into suspend state if LINUX_REBOOT_CMD_POWER_OFF is signed by
         * O/S, so that system stop here. Otherwise system will restart again
         */
        if (LINUX_REBOOT_CMD_POWER_OFF == board_reboot_command()) {
                amlogic_gpio_direction_output(GPIOAO_13, 1);    // BLUELED : Off
                amlogic_gpio_direction_output(GPIOAO_3, 0);  // TF_3V3N_1V8
                amlogic_gpio_direction_output(GPIOAO_4, 1);  // USB Host
                amlogic_gpio_direction_output(GPIOAO_5, 0);  // USB OTG
                amlogic_gpio_direction_output(GPIOY_12, 1);  // TFLASH_VDD_EN
                amlogic_gpio_direction_output(GPIOH_4, 0);   // ETHERNET
                meson_pm_suspend();
                while (1);
        }

        return 0;
}
#endif

#if defined(BOARD_LATE_INIT)
int board_late_init(void)
{
        block_dev_desc_t *dev_desc;

        dev_desc = get_dev_by_name("mmc0");
        if (dev_desc) {
                printf("============================================================\n");
                dev_print(dev_desc);
                printf("------------------------------------------------------------\n");
                print_part_dos(dev_desc);
                printf("============================================================\n");
        }

        u32 boot_mode = board_get_recovery_message();
        if (0 == boot_mode) {
                boot_mode = board_reboot_command();
        }

        if (boot_mode == LINUX_REBOOT_CMD_FASTBOOT) {
                run_command("fastboot", 0);
        } else if (boot_mode == LINUX_REBOOT_CMD_RECOVERY) {
                run_command("movi read recovery 0 12000000; bootm", 0);
        }
}
#endif
