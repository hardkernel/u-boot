/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Very simple but very effective user-space memory tester.
 * Originally by Simon Kirby <sim@stormix.com> <sim@neato.org>
 * Version 2 by Charles Cazabon <charlesc-memtester@pyropus.ca>
 * Version 3 not publicly released.
 * Version 4 rewrite:
 * Copyright (C) 2004-2012 Charles Cazabon <charlesc-memtester@pyropus.ca>
 * Licensed under the terms of the GNU General Public License version 2 (only).
 * See the file COPYING for details.
 *
 * This file contains the functions for the actual tests, called from the
 * main routine in memtester.c.  See other comments in that file.
 *
 */
#include <common.h>
#include "io_map.h"

#define IO_TYPE_1_1_16	0
#define IO_TYPE_1_1_32	1
#define IO_TYPE_1_2		2
#define IO_TYPE_2		3

static u32 io_type;

/* len should be 16byte align */
int data_cpu_2_io(void *p, u32 len)
{
	uchar *val = p;
	uchar buf[16];
	u32 i, j;

	if ((len % sizeof(buf)) || !len)
		return -1;

	if (io_type == IO_TYPE_1_2) {
		len /= sizeof(buf);
		for (j = 0; j < len; j++) {
			memset(buf, 0, sizeof(buf));
			for (i = 0; i < sizeof(buf); i++)
				buf[i] = val[(i % 4) * 4 + i / 4 + j * sizeof(buf)];
			memcpy(&val[j * sizeof(buf)], buf, sizeof(buf));
		}
	} else if (io_type == IO_TYPE_1_1_32) {
		len /= 8;
		for (j = 0; j < len; j++) {
			memset(buf, 0, sizeof(buf));
			for (i = 0; i < 8; i++)
				buf[i] = val[(i % 4) * 2 + i / 4 + j * 8];
			memcpy(&val[j * 8], buf, 8);
		}
	}
	/* IO_TYPE_2 and IO_TYPE_1_1_16 do nothing*/
	return 0;
}

void data_cpu_2_io_init(void)
{
	u32 osreg = 0;
	u32 bw;

#if defined(CONFIG_ROCKCHIP_RK3036)
	io_type = IO_TYPE_1_1_16;
#elif defined(CONFIG_ROCKCHIP_RK3228) ||	\
	defined(CONFIG_ROCKCHIP_RV1108) ||	\
	defined(CONFIG_ROCKCHIP_RK3368) ||	\
	defined(CONFIG_ROCKCHIP_RK3366)
	io_type = IO_TYPE_1_2;
#elif defined(CONFIG_ROCKCHIP_RK3128)
	osreg = 0x200081cc;
#elif defined(CONFIG_ROCKCHIP_RK3288)
	osreg = 0xff73009c;
#elif defined(CONFIG_ROCKCHIP_RK3188)
	osreg = 0x20004048;
#elif defined(CONFIG_ROCKCHIP_RK3328) || \
	defined(CONFIG_ROCKCHIP_PX30) ||	\
	defined(CONFIG_ROCKCHIP_RK1808)
	io_type = IO_TYPE_2;
#else
	io_type = IO_TYPE_2;
#endif

	if (osreg) {
		bw = (2 >> ((osreg >> 2) & 0x3));
		if (bw == 2)
			io_type = IO_TYPE_1_1_32;
		else
			io_type = IO_TYPE_1_1_16;
	}
}

