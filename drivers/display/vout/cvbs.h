/*
 * drivers/display/vout/cvbs.h
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

#ifndef _AML_CVBS_H
#define _AML_CVBS_H
#include <amlogic/cvbs.h>
#include "cvbs_regs.h"

#define CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT	1

#define CONFIG_CVBS_CHINASARFT		0x0
#define CONFIG_CVBS_CHINATELECOM	0x1
#define CONFIG_CVBS_CHINAMOBILE		0x2
#define CONFIG_CVBS_PERFORMANCE_ACTIVED	CONFIG_CVBS_CHINASARFT

#define MREG_END_MARKER 0xFFFF

enum CVBS_MODE_e
{
	VMODE_PAL,
	VMODE_NTSC,
	VMODE_PAL_M,
	VMODE_PAL_N,
	VMODE_NTSC_M,
	VMODE_MAX
};

struct cvbs_vdac_data_s {
	unsigned int vdac_ctrl0_en;
	unsigned int vdac_ctrl0_dis;
	unsigned int vdac_ctrl1_en;
	unsigned int vdac_ctrl1_dis;
};

struct reg_s {
	unsigned int reg;
	unsigned int val;
};

#define CVBS_PERFORMANCE_CNT_MAX    20
struct performance_config_s {
	unsigned int reg_cnt;
	struct reg_s *reg_table;
};

struct cvbs_drv_s {
	struct cvbs_vdac_data_s *vdac_data;
	struct performance_config_s perf_conf_pal;
	struct performance_config_s perf_conf_ntsc;
};

#endif
