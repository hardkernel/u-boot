/*
 * \file        aml_v2_burning.h
 * \brief       common interfaces for version burning
 *
 * \version     1.0.0
 * \date        09/15/2013
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */

//is the uboot loaded from usb otg
int is_tpl_loaded_from_usb(void);

//is the uboot loaded from sdcard mmc 0
//note only sdmmc supported by romcode when external device boot
int is_tpl_loaded_from_ext_sdmmc(void);

//Check if uboot loaded from external sdmmc or usb otg
int aml_burn_check_uboot_loaded_for_burn(int flag);

int aml_burn_factory_producing(int flag, bd_t* bis);

//usb producing mode, if tpl loaded from usb pc tool and auto enter producing mode
int aml_try_factory_usb_burning(int flag, bd_t* bis);

//Auto enter sdcard burning if booted from sdcard and aml_sdc_burn.ini existed
int aml_try_factory_sdcard_burning(int flag, bd_t* bis);


