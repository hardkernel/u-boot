
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/dvfs.h
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

#ifndef __SCP_DVFS_H__
#define __SCP_DVFS_H__

struct scpi_opp_entry {
	unsigned int freq_hz;
	unsigned int volt_mv;
};
#define DVFS(_freq, _volt) \
{ \
	.freq_hz = _freq, \
	.volt_mv = _volt, \
}

#define SCPI_SUCCESS 0
#define MAX_DVFS_OPPS		16
#define DVFS_LATENCY(hdr)	((hdr) << 16)
#define DVFS_OPP_COUNT(hdr)	((hdr) << 8)
struct scpi_opp {
	unsigned int latency; /* in usecs */
	int count;
	struct scpi_opp_entry opp[MAX_DVFS_OPPS];
} buf_opp;

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#endif

