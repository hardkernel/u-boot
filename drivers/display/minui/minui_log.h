/*
 * drivers/amlogic/display/osd/osd_log.h
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
*/


#ifndef _MINUI_LOG_H_
#define _MINUI_LOG_H_

#include <common.h>

#define UI_LOG_TAG "[UI]"

#define UI_LOG_LEVEL_NULL 0
#define UI_LOG_LEVEL_DEBUG 1
#define UI_LOG_LEVEL_DEBUG2 2
#define UI_LOG_LEVEL_DEBUG3 3

extern unsigned int ui_log_level;

#define ui_logl() \
	printf(UI_LOG_TAG "%s:%d\n", __func__, __LINE__)

#define ui_logv(fmt, ...) \
	printf(UI_LOG_TAG "%s:%d " fmt, __func__, __LINE__, ##__VA_ARGS__)

#define ui_logi(fmt, ...) \
	printf(UI_LOG_TAG fmt, ##__VA_ARGS__)

#define ui_loge(fmt, ...) \
	printf(UI_LOG_TAG "ERR: " fmt, ##__VA_ARGS__)

#define ui_logd(fmt, ...) \
	do { \
		if (ui_log_level >= UI_LOG_LEVEL_DEBUG) { \
			printf(UI_LOG_TAG fmt, ##__VA_ARGS__); \
		} \
	} while (0)

#define ui_logd2(fmt, ...) \
	do { \
		if (ui_log_level >= UI_LOG_LEVEL_DEBUG2) { \
			printf(UI_LOG_TAG fmt, ##__VA_ARGS__); \
		} \
	} while (0)

#define ui_logd3(fmt, ...) \
	do { \
		if (ui_log_level >= UI_LOG_LEVEL_DEBUG3) { \
			printf(UI_LOG_TAG fmt, ##__VA_ARGS__); \
		} \
	} while (0)

#endif
