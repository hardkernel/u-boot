/*
 * (C) Copyright 2022 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef _ASM_ARCH_GRF_RV1106_H
#define _ASM_ARCH_GRF_RV1106_H

#include <common.h>

struct rv1106_grf {
	unsigned int reserved0[0x060000 / 4];
	unsigned int gmac_con0;
	unsigned int gmac_clk_con;
	unsigned int gmac_st;
	unsigned int tsadc_con;
	unsigned int otp_con;
	unsigned int rga_noc;
	unsigned int vo_mem;
	unsigned int sdio_con0;
	unsigned int sdio_co1;
	unsigned int sdio_ram_clhgat_dis;
	unsigned int macphy_con0;
	unsigned int macphy_con1;
	unsigned int vop_qos;
	unsigned int vop_pipe_bypass;
};

check_member(rv1106_grf, vop_pipe_bypass, 0x60034);
#endif
