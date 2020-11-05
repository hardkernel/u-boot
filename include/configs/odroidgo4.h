/*
 * include/configs/odroidgo4.h
 *
 * (C) Copyright 2020 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ODROID_GO4_H__
#define __ODROID_GO4_H__

#define CONFIG_DEVICE_PRODUCT		"odroidgo4"
#define ODROID_BOARD_UUID		"9098004a-a1dd-11e8-98d0-529269fb1459"

/* configs for CEC */
#define CONFIG_CEC_OSD_NAME		"ODROID-GO4"
#define CONFIG_CEC_WAKEUP

#include "odroid-g12-common.h"

#if defined(CONFIG_CMD_USB)
	/* USB OTG Power Enable */
	#define CONFIG_USB_GPIO_PWR		GPIOEE(GPIOAO_2)
	#define CONFIG_USB_GPIO_PWR_NAME	"GPIOAO_2"
#endif

#undef  CONFIG_VDDEE_INIT_VOLTAGE
#define CONFIG_VDDEE_INIT_VOLTAGE		880	/* VDDEE power up voltage */

#endif
