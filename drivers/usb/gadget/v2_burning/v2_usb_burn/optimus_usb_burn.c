/*
 * \file        optimus_usb_burn.c
 * \brief       burning itself from Pheripheral usb host
 *
 * \version     1.0.0
 * \date        2014-9-15
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *				Chunyu.Song <chunyu.song@amlogic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#include "../v2_sdc_burn/optimus_sdc_burn_i.h"
#include "../v2_sdc_burn/optimus_led.h"

extern int optimus_burn_with_cfg_file(const char* cfgFile);

// added by scy
int optimus_burn_package_in_usb(const char* sdc_cfg_file)
{
    int rcode = 0;

    DWN_MSG("usb start\n");
    rcode = run_command("usb start", 0);
    if (rcode) {
        DWN_ERR("Fail in init usb host, Does usb host not plugged in?\n");
        return __LINE__;
    }

#if 1//this asserted by 'run update' and 'aml_check_is_ready_for_sdc_produce'
    rcode = do_fat_get_fileSz(sdc_cfg_file);
    if (!rcode) {
        DWN_ERR("The [%s] not exist in udisk\n", sdc_cfg_file);
        return __LINE__;
    }
#endif//#if 0

    rcode = optimus_device_probe("usb", "0");
    if (rcode) {
        DWN_ERR("Fail to detect device usb 0\n");
        return __LINE__;
    }

    rcode = optimus_burn_with_cfg_file(sdc_cfg_file);

    return rcode;
}


// added by scy
int do_usb_burn(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{

    int rcode = 0;
    const char* sdc_cfg_file = argv[1];

	setenv("usb_update","1");

    if (argc < 2 ) {
        cmd_usage(cmdtp);
        return __LINE__;
    }

    optimus_work_mode_set(OPTIMUS_WORK_MODE_SDC_UPDATE);
    show_logo_to_report_burning();//indicate enter flow of burning! when 'run update'
    if (optimus_led_open(LED_TYPE_PWM)) {
        DWN_ERR("Fail to open led for burn\n");
        return __LINE__;
    }
    optimus_led_show_in_process_of_burning();

    rcode = optimus_burn_package_in_usb(sdc_cfg_file);

    return rcode;
}

// added by scy
U_BOOT_CMD(
   usb_burn,      //command name
   5,               //maxargs
   0,               //repeatable
   do_usb_burn,   //command function
   "Burning with amlogic format package in usb ",           //description
   "argv: [sdc_burn_cfg_file]\n"//usage
   "    -aml_sdc_burn.ini is usually used configure file\n"
);
