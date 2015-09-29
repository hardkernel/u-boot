
/*
 * arch/arm/cpu/armv8/gxtvbb/firmware/scp_task/dvfs.c
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "config.h"
#include "registers.h"
#include "task_apis.h"

#include "dvfs.h"
#include <dvfs_board.c>

void get_dvfs_info(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out)
{
	unsigned int cnt = ARRAY_SIZE(cpu_dvfs_tbl);
	buf_opp.latency = 200;
	buf_opp.count = cnt;
	memset(&buf_opp.opp[0], 0,
	       MAX_DVFS_OPPS * sizeof(struct scpi_opp_entry));
	memcpy(&buf_opp.opp[0], cpu_dvfs_tbl ,
	       cnt * sizeof(struct scpi_opp_entry));

	memcpy(info_out, &buf_opp, sizeof(struct scpi_opp));
	*size_out = sizeof(struct scpi_opp);
	return;
}
