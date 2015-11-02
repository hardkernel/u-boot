/*
 * drivers/osd/cpu_version.h
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

#ifndef CPU_VERSION_H
#define CPU_VERSION_H

#define MESON_CPU_MAJOR_ID_M6		0x16
#define MESON_CPU_MAJOR_ID_M6TV		0x17
#define MESON_CPU_MAJOR_ID_M6TVL	0x18
#define MESON_CPU_MAJOR_ID_M8		0x19
#define MESON_CPU_MAJOR_ID_MTVD		0x1A
#define MESON_CPU_MAJOR_ID_M8B		0x1B
#define MESON_CPU_MAJOR_ID_MG9TV	0x1C
#define MESON_CPU_MAJOR_ID_M8M2		0x1D
#define MESON_CPU_MAJOR_ID_GXBB		0x1F

#define MESON_CPU_VERSION_LVL_MAJOR	0
#define MESON_CPU_VERSION_LVL_MINOR	1
#define MESON_CPU_VERSION_LVL_PACK	2
#define MESON_CPU_VERSION_LVL_MISC	3
#define MESON_CPU_VERSION_LVL_MAX	MESON_CPU_VERSION_LVL_MISC

static inline int get_meson_cpu_version(int level)
{
	return MESON_CPU_MAJOR_ID_GXBB;
}
static inline bool is_meson_m8_cpu(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR) ==
	       MESON_CPU_MAJOR_ID_M8;
}

static inline bool is_meson_mtvd_cpu(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR) ==
	       MESON_CPU_MAJOR_ID_MTVD;
}

static inline bool is_meson_m8b_cpu(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR) ==
	       MESON_CPU_MAJOR_ID_M8B;
}

static inline bool is_meson_m8m2_cpu(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR) ==
	       MESON_CPU_MAJOR_ID_M8M2;
}

static inline bool is_meson_g9tv_cpu(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR) ==
	       MESON_CPU_MAJOR_ID_MG9TV;
}

static inline bool is_meson_gxbb_cpu(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR) ==
	       MESON_CPU_MAJOR_ID_GXBB;
}

static inline u32 get_cpu_type(void)
{
	return get_meson_cpu_version(MESON_CPU_VERSION_LVL_MAJOR);
}
#endif
