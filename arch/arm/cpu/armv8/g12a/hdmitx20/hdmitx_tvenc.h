
/*
 * arch/arm/cpu/armv8/txl/hdmitx20/hdmitx_tvenc.h
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

#ifndef __HDMI_TX_TVENC_H__
#define __HDMI_TX_TVENC_H__

#include <common.h>
#include <amlogic/hdmi.h>

struct reg_t {
	unsigned int reg;
	unsigned int val;
};

struct enc_reg_set {
	unsigned int addr;
	unsigned int val;
};

struct enc_reg_map {
	enum hdmi_vic vic;
	struct enc_reg_set *set;
};

void set_vmode_enc_hw(enum hdmi_vic vic);

#endif
