/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#ifndef _ASM_ARCH_CRU_RK3308_H
#define _ASM_ARCH_CRU_RK3308_H

#include <common.h>

#define MHz		1000000
#define OSC_HZ		(24 * MHz)

#define APLL_HZ		(816 * MHz)
#define GPLL_HZ		(600 * MHz)
#define CPLL_HZ		(594 * MHz)

#define CORE_PERI_HZ	204000000
#define CORE_ACLK_HZ	408000000

#define BUS_ACLK_HZ	148500000
#define BUS_HCLK_HZ	148500000
#define BUS_PCLK_HZ	74250000

#define PERI_ACLK_HZ	148500000
#define PERI_HCLK_HZ	148500000
#define PERI_PCLK_HZ	74250000

enum apll_frequencies {
	APLL_816_MHZ,
	APLL_600_MHZ,
};

/* Private data for the clock driver - used by rockchip_get_cru() */
struct rk3308_clk_priv {
	struct rk3308_cru *cru;
	ulong rate;
};

struct rk3308_cru {
	struct rk3308_pll {
		unsigned int con0;
		unsigned int con1;
		unsigned int con2;
		unsigned int con3;
		unsigned int con4;
		unsigned int reserved0[3];
	} pll[4];
	unsigned int reserved1[8];
	unsigned int mode;
	unsigned int misc;
	unsigned int reserved2[2];
	unsigned int glb_cnt_th;
	unsigned int glb_rst_st;
	unsigned int glb_srst_fst;
	unsigned int glb_srst_snd;
	unsigned int glb_rst_con;
	unsigned int pll_lock;
	unsigned int reserved3[6];
	unsigned int hwffc_con0;
	unsigned int reserved4;
	unsigned int hwffc_th;
	unsigned int hwffc_intst;
	unsigned int apll_con0_s;
	unsigned int apll_con1_s;
	unsigned int clksel_con0_s;
	unsigned int reserved5;
	unsigned int clksel_con[74];
	unsigned int reserved6[54];
	unsigned int clkgate_con[15];
	unsigned int reserved7[(0x380 - 0x338) / 4 - 1];
	unsigned int ssgtbl[32];
	unsigned int softrst_con[10];
	unsigned int reserved8[(0x480 - 0x424) / 4 - 1];
	unsigned int sdmmc_con[2];
	unsigned int sdio_con[2];
	unsigned int emmc_con[2];
};
check_member(rk3308_cru, emmc_con[1], 0x494);

#endif
