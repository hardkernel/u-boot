/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __EVB_PX30_H
#define __EVB_PX30_H

#include <configs/px30_common.h>

#define CONFIG_SYS_MMC_ENV_DEV 0


#define CONFIG_CONSOLE_SCROLL_LINES		10

#undef CONFIG_BOOTCOMMAND
#define CONFIG_BOOTCOMMAND RKIMG_BOOTCOMMAND

#endif
