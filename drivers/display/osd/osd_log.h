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


#ifndef _OSD_LOG_H_
#define _OSD_LOG_H_

#include <common.h>

#define OSD_LOG_TAG "[OSD]"

#define OSD_LOG_LEVEL_NULL 0
#define OSD_LOG_LEVEL_DEBUG 1
#define OSD_LOG_LEVEL_DEBUG2 2
#define OSD_LOG_LEVEL_DEBUG3 3

extern unsigned int osd_log_level;

#define osd_logl() \
	printf(OSD_LOG_TAG "%s:%d\n", __func__, __LINE__)

#define osd_logv(fmt, ...) \
	printf(OSD_LOG_TAG "%s:%d " fmt, __func__, __LINE__, ##__VA_ARGS__)

#define osd_logi(fmt, ...) \
	printf(OSD_LOG_TAG fmt, ##__VA_ARGS__)

#define osd_loge(fmt, ...) \
	printf(OSD_LOG_TAG "ERR: " fmt, ##__VA_ARGS__)

#define osd_logd(fmt, ...) \
	do { \
		if (osd_log_level >= OSD_LOG_LEVEL_DEBUG) { \
			printf(OSD_LOG_TAG fmt, ##__VA_ARGS__); \
		} \
	} while (0)

#define osd_logd2(fmt, ...) \
	do { \
		if (osd_log_level >= OSD_LOG_LEVEL_DEBUG2) { \
			printf(OSD_LOG_TAG fmt, ##__VA_ARGS__); \
		} \
	} while (0)

#define osd_logd3(fmt, ...) \
	do { \
		if (osd_log_level >= OSD_LOG_LEVEL_DEBUG3) { \
			printf(OSD_LOG_TAG fmt, ##__VA_ARGS__); \
		} \
	} while (0)

#endif
