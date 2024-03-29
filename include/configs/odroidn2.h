/*
 * include/configs/odroidn2.h
 *
 * (C) Copyright 2018 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */


#ifndef __ODROIDN2_H__
#define __ODROIDN2_H__

#define CONFIG_DEVICE_PRODUCT		"odroidn2"
#define ODROID_BOARD_UUID		"909802f2-a1dd-11e8-98d0-529269fb1459"

/* configs for CEC */
#define CONFIG_CEC_OSD_NAME		"ODROID-N2"
#define CONFIG_CEC_WAKEUP

#include "odroid-g12-common.h"

#if defined(CONFIG_CMD_USB)
	/* USB OTG Power Enable */
	#define CONFIG_USB_GPIO_PWR		GPIOEE(GPIOH_6)
	#define CONFIG_USB_GPIO_PWR_NAME	"GPIOH_6"
#endif

#if defined(CONFIG_ODROID_N2L)
#define CONFIG_ETHERNET_NONE
#undef ETHERNET_EXTERNAL_PHY
#undef ETHERNET_INTERNAL_PHY

#undef CONFIG_AML_CVBS
#endif

#endif
