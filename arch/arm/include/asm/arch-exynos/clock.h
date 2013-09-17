/*
 * (C) Copyright 2010 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 */

#ifndef __ASM_ARM_ARCH_CLOCK_H_
#define __ASM_ARM_ARCH_CLOCK_H_

#ifndef __ASSEMBLY__
struct exynos4_clock {
	unsigned char	res1[0x4200];			/* 0x1003_4200 */
	unsigned int	src_leftbus;
	unsigned char	res2[0x1fc];
	unsigned int	mux_stat_leftbus;
	unsigned char	res4[0xfc];
	unsigned int	div_leftbus;
	unsigned char	res5[0xfc];
	unsigned int	div_stat_leftbus;
	unsigned char	res6[0x1fc];
	unsigned int	gate_ip_leftbus;
	unsigned char	res7[0x1fc];
	unsigned int	clkout_leftbus;			/* 0x1003_4A00 */
	unsigned int	clkout_leftbus_div_stat;
	unsigned char	res8[0x37f8];
	unsigned int	src_rightbus;			/* 0x1003_8200 */
	unsigned char	res9[0x1fc];
	unsigned int	mux_stat_rightbus;
	unsigned char	res10[0xfc];
	unsigned int	div_rightbus;
	unsigned char	res11[0xfc];
	unsigned int	div_stat_rightbus;
	unsigned char	res12[0x1fc];
	unsigned int	gate_ip_rightbus;
	unsigned char	res13[0x1fc];
	unsigned int	clkout_rightbus;		/* 0x1003_8A00 */
	unsigned int	clkout_rightbus_div_stat;
	unsigned char	res14[0x3608];
	unsigned int	epll_lock;			/* 0x1003_C010 */
	unsigned char	res15[0xc];
	unsigned int	vpll_lock;
	unsigned char	res16[0xec];
	unsigned int	epll_con0;			/* 0x1003_C110 */
	unsigned int	epll_con1;
	unsigned char	res17[0x8];
	unsigned int	vpll_con0;			/* 0x1003_C120 */
	unsigned int	vpll_con1;
	unsigned char	res18[0xe8];
	unsigned int	src_top0;			/* 0x1003_C210 */
	unsigned int	src_top1;
	unsigned char	res19[0x8];
	unsigned int	src_cam;
	unsigned int	src_tv;
	unsigned int	src_mfc;
	unsigned int	src_g3d;
	unsigned int	src_image;
	unsigned int	src_lcd0;
	unsigned int	src_lcd1;
	unsigned int	src_maudio;
	unsigned int	src_fsys;
	unsigned char	res20[0xc];
	unsigned int	src_peril0;
	unsigned int	src_peril1;
	unsigned char	res21[0xb8];
	unsigned int	src_mask_top;			/* 0x1003_C310 */
	unsigned char	res22[0xc];
	unsigned int	src_mask_cam;
	unsigned int	src_mask_tv;
	unsigned char	res23[0xc];
	unsigned int	src_mask_lcd0;
	unsigned int	src_mask_lcd1;
	unsigned int	src_mask_maudio;
	unsigned int	src_mask_fsys;
	unsigned char	res24[0xc];
	unsigned int	src_mask_peril0;
	unsigned int	src_mask_peril1;
	unsigned char	res25[0xb8];
	unsigned int	mux_stat_top;			/* 0x1003_C410 */
	unsigned char	res26[0x14];
	unsigned int	mux_stat_mfc;
	unsigned int	mux_stat_g3d;
	unsigned int	mux_stat_image;
	unsigned char	res27[0xdc];
	unsigned int	div_top;
	unsigned char	res28[0xc];
	unsigned int	div_cam;
	unsigned int	div_tv;
	unsigned int	div_mfc;
	unsigned int	div_g3d;
	unsigned int	div_image;
	unsigned int	div_lcd0;
	unsigned int	div_lcd1;
	unsigned int	div_maudio;
	unsigned int	div_fsys0;
	unsigned int	div_fsys1;
	unsigned int	div_fsys2;
	unsigned int	div_fsys3;
	unsigned int	div_peril0;
	unsigned int	div_peril1;
	unsigned int	div_peril2;
	unsigned int	div_peril3;
	unsigned int	div_peril4;
	unsigned int	div_peril5;
	unsigned char	res29[0x18];
	unsigned int	div2_ratio;
	unsigned char	res30[0x8c];
	unsigned int	div_stat_top;			/* 0x1003_C610 */
	unsigned char	res31[0xc];
	unsigned int	div_stat_cam;
	unsigned int	div_stat_tv;
	unsigned int	div_stat_mfc;
	unsigned int	div_stat_g3d;
	unsigned int	div_stat_image;
	unsigned int	div_stat_lcd0;
	unsigned int	div_stat_lcd1;
	unsigned int	div_stat_maudio;
	unsigned int	div_stat_fsys0;
	unsigned int	div_stat_fsys1;
	unsigned int	div_stat_fsys2;
	unsigned int	div_stat_fsys3;
	unsigned int	div_stat_peril0;
	unsigned int	div_stat_peril1;
	unsigned int	div_stat_peril2;
	unsigned int	div_stat_peril3;
	unsigned int	div_stat_peril4;
	unsigned int	div_stat_peril5;
	unsigned char	res32[0x18];
	unsigned int	div2_stat;
	unsigned char	res33[0x29c];
	unsigned int	gate_ip_cam;			/* 0x1003_C920 */
	unsigned int	gate_ip_tv;
	unsigned int	gate_ip_mfc;
	unsigned int	gate_ip_g3d;
	unsigned int	gate_ip_image;
	unsigned int	gate_ip_lcd0;
	unsigned int	gate_ip_lcd1;
	unsigned char	res34[0x4];
	unsigned int	gate_ip_fsys;
	unsigned char	res35[0x8];
	unsigned int	gate_ip_gps;
	unsigned int	gate_ip_peril;
	unsigned char	res36[0xc];
	unsigned int	gate_ip_perir;
	unsigned char	res37[0xc];
	unsigned int	gate_block;
	unsigned char	res38[0x8c];
	unsigned int	clkout_cmu_top;			/* 0x1003_CA00 */
	unsigned int	clkout_cmu_top_div_stat;
#ifdef CONFIG_EXYNOS4X12
	unsigned char	res39[0x3700];
	unsigned int	mpll_con0;			/* 0x1004_0108 */
	unsigned int	mpll_con1;			/* 0x1004_010C */
	unsigned char	res65[0xf0];
#else
	unsigned char	res39[0x37f8];
#endif
	unsigned int	src_dmc;			/* 0x1004_0200 */
	unsigned char	res40[0xfc];
	unsigned int	src_mask_dmc;
	unsigned char	res41[0xfc];
	unsigned int	mux_stat_dmc;
	unsigned char	res42[0xfc];
	unsigned int	div_dmc0;
	unsigned int	div_dmc1;
	unsigned char	res43[0xf8];
	unsigned int	div_stat_dmc0;
	unsigned int	div_stat_dmc1;
	unsigned char	res44[0x2f8];
	unsigned int	gate_ip_dmc;
	unsigned char	res45[0xfc];
	unsigned int	clkout_cmu_dmc;
	unsigned int	clkout_cmu_dmc_div_stat;
	unsigned char	res46[0x5f8];
	unsigned int	dcgidx_map0;			/* 0x1004_1000 */
	unsigned int	dcgidx_map1;
	unsigned int	dcgidx_map2;
	unsigned char	res47[0x14];
	unsigned int	dcgperf_map0;
	unsigned int	dcgperf_map1;
	unsigned char	res48[0x18];
	unsigned int	dvcidx_map;
	unsigned char	res49[0x1c];
	unsigned int	freq_cpu;
	unsigned int	freq_dpm;
	unsigned char	res50[0x18];
	unsigned int	dvsemclk_en;
	unsigned int	maxperf;
	unsigned char	res51[0x2f78];
	unsigned int	apll_lock;			/* 0x1004_4000 */
	unsigned char	res52[0x4];
	unsigned int	mpll_lock;
	unsigned char	res53[0xf4];
	unsigned int	apll_con0;			/* 0x1004_4100 */
	unsigned int	apll_con1;
#ifdef CONFIG_EXYNOS4X12
	unsigned char	res54[0xf8];
#else
	unsigned int	mpll_con0;
	unsigned int	mpll_con1;
	unsigned char	res54[0xf0];
#endif
	unsigned int	src_cpu;
	unsigned char	res55[0x1fc];
	unsigned int	mux_stat_cpu;
	unsigned char	res56[0xfc];
	unsigned int	div_cpu0;
	unsigned int	div_cpu1;
	unsigned char	res57[0xf8];
	unsigned int	div_stat_cpu0;
	unsigned int	div_stat_cpu1;
	unsigned char	res58[0x3f8];
	unsigned int	clkout_cmu_cpu;
	unsigned int	clkout_cmu_cpu_div_stat;
	unsigned char	res59[0x5f8];
	unsigned int	armclk_stopctrl;		/* 0x1004_5000 */
	unsigned int	atclk_stopctrl;
	unsigned char	res60[0x8];
	unsigned int	parityfail_status;
	unsigned int	parityfail_clear;
	unsigned char	res61[0xe8];
	unsigned int	apll_con0_l8;
	unsigned int	apll_con0_l7;
	unsigned int	apll_con0_l6;
	unsigned int	apll_con0_l5;
	unsigned int	apll_con0_l4;
	unsigned int	apll_con0_l3;
	unsigned int	apll_con0_l2;
	unsigned int	apll_con0_l1;
	unsigned int	iem_control;
	unsigned char	res62[0xdc];
	unsigned int	apll_con1_l8;
	unsigned int	apll_con1_l7;
	unsigned int	apll_con1_l6;
	unsigned int	apll_con1_l5;
	unsigned int	apll_con1_l4;
	unsigned int	apll_con1_l3;
	unsigned int	apll_con1_l2;
	unsigned int	apll_con1_l1;
	unsigned char	res63[0xe0];
	unsigned int	div_iem_l8;
	unsigned int	div_iem_l7;
	unsigned int	div_iem_l6;
	unsigned int	div_iem_l5;
	unsigned int	div_iem_l4;
	unsigned int	div_iem_l3;
	unsigned int	div_iem_l2;
	unsigned int	div_iem_l1;
};

struct exynos5_clock {
	unsigned int	apll_lock;
	unsigned char	res1[0xfc];
	unsigned int	apll_con0;
	unsigned int	apll_con1;
	unsigned char	res2[0xf8];
	unsigned int	src_cpu;
	unsigned char	res3[0x1fc];
	unsigned int	mux_stat_cpu;
	unsigned char	res4[0xfc];
	unsigned int	div_cpu0;
	unsigned int	div_cpu1;
	unsigned char	res5[0xf8];
	unsigned int	div_stat_cpu0;
	unsigned int	div_stat_cpu1;
	unsigned char	res6[0x1f8];
	unsigned int	gate_sclk_cpu;
	unsigned char	res7[0x1fc];
	unsigned int	clkout_cmu_cpu;
	unsigned int	clkout_cmu_cpu_div_stat;
	unsigned char	res8[0x5f8];
	unsigned int	armclk_stopctrl;
	unsigned char	res9[0xc];
	unsigned int	parityfail_status;
	unsigned int	parityfail_clear;
	unsigned char	res10[0x8];
	unsigned int	pwr_ctrl;
	unsigned int	pwr_ctr2;
	unsigned char	res11[0xd8];
	unsigned int	apll_con0_l8;
	unsigned int	apll_con0_l7;
	unsigned int	apll_con0_l6;
	unsigned int	apll_con0_l5;
	unsigned int	apll_con0_l4;
	unsigned int	apll_con0_l3;
	unsigned int	apll_con0_l2;
	unsigned int	apll_con0_l1;
	unsigned int	iem_control;
	unsigned char	res12[0xdc];
	unsigned int	apll_con1_l8;
	unsigned int	apll_con1_l7;
	unsigned int	apll_con1_l6;
	unsigned int	apll_con1_l5;
	unsigned int	apll_con1_l4;
	unsigned int	apll_con1_l3;
	unsigned int	apll_con1_l2;
	unsigned int	apll_con1_l1;
	unsigned char	res13[0xe0];
	unsigned int	div_iem_l8;
	unsigned int	div_iem_l7;
	unsigned int	div_iem_l6;
	unsigned int	div_iem_l5;
	unsigned int	div_iem_l4;
	unsigned int	div_iem_l3;
	unsigned int	div_iem_l2;
	unsigned int	div_iem_l1;
	unsigned char	res14[0x2ce0];
	unsigned int	mpll_lock;
	unsigned char	res15[0xfc];
	unsigned int	mpll_con0;
	unsigned int	mpll_con1;
	unsigned char	res16[0xf8];
	unsigned int	src_core0;
	unsigned int	src_core1;
	unsigned char	res17[0xf8];
	unsigned int	src_mask_core;
	unsigned char	res18[0x100];
	unsigned int	mux_stat_core1;
	unsigned char	res19[0xf8];
	unsigned int	div_core0;
	unsigned int	div_core1;
	unsigned int	div_sysrgt;
	unsigned char	res20[0xf4];
	unsigned int	div_stat_core0;
	unsigned int	div_stat_core1;
	unsigned int	div_stat_sysrgt;
	unsigned char	res21[0x2f4];
	unsigned int	gate_ip_core;
	unsigned int	gate_ip_sysrgt;
	unsigned char	res22[0xf8];
	unsigned int	clkout_cmu_core;
	unsigned int	clkout_cmu_core_div_stat;
	unsigned char	res23[0x5f8];
	unsigned int	dcgidx_map0;
	unsigned int	dcgidx_map1;
	unsigned int	dcgidx_map2;
	unsigned char	res24[0x14];
	unsigned int	dcgperf_map0;
	unsigned int	dcgperf_map1;
	unsigned char	res25[0x18];
	unsigned int	dvcidx_map;
	unsigned char	res26[0x1c];
	unsigned int	freq_cpu;
	unsigned int	freq_dpm;
	unsigned char	res27[0x18];
	unsigned int	dvsemclk_en;
	unsigned int	maxperf;
	unsigned char	res28[0xf78];
	unsigned int	c2c_config;
	unsigned char	res29[0x24fc];
	unsigned int	div_acp;
	unsigned char	res30[0xfc];
	unsigned int	div_stat_acp;
	unsigned char	res31[0x1fc];
	unsigned int	gate_ip_acp;
	unsigned char	res32[0xfc];
	unsigned int	div_syslft;
	unsigned char	res33[0xc];
	unsigned int	div_stat_syslft;
	unsigned char	res34[0x1c];
	unsigned int	gate_ip_syslft;
	unsigned char	res35[0xcc];
	unsigned int	clkout_cmu_acp;
	unsigned int	clkout_cmu_acp_div_stat;
	unsigned char	res36[0x8];
	unsigned int	ufmc_config;
	unsigned char	res37[0x38ec];
	unsigned int	div_isp0;
	unsigned int	div_isp1;
	unsigned int	div_isp2;
	unsigned char	res38[0xf4];
	unsigned int	div_stat_isp0;
	unsigned int	div_stat_isp1;
	unsigned int	div_stat_isp2;
	unsigned char	res39[0x3f4];
	unsigned int	gate_ip_isp0;
	unsigned int	gate_ip_isp1;
	unsigned char	res40[0xf8];
	unsigned int	gate_sclk_isp;
	unsigned char	res41[0xc];
	unsigned int	mcuisp_pwr_ctrl;
	unsigned char	res42[0xec];
	unsigned int	clkout_cmu_isp;
	unsigned int	clkout_cmu_isp_div_stat;
	unsigned char	res43[0x3618];
	unsigned int	cpll_lock;
	unsigned char	res44[0xc];
	unsigned int	epll_lock;
	unsigned char	res45[0xc];
	unsigned int	vpll_lock;
	unsigned char	res46[0xc];
	unsigned int	gpll_lock;
	unsigned char	res47[0xcc];
	unsigned int	cpll_con0;
	unsigned int	cpll_con1;
	unsigned char	res48[0x8];
	unsigned int	epll_con0;
	unsigned int	epll_con1;
	unsigned int	epll_con2;
	unsigned char	res49[0x4];
	unsigned int	vpll_con0;
	unsigned int	vpll_con1;
	unsigned int	vpll_con2;
	unsigned char	res50[0x4];
	unsigned int	gpll_con0;
	unsigned int	gpll_con1;
	unsigned char	res51[0xb8];
	unsigned int	src_top0;
	unsigned int	src_top1;
	unsigned int	src_top2;
	unsigned int	src_top3;
	unsigned int	src_gscl;
	unsigned char	res52[0x8];
	unsigned int	src_disp1_0;
	unsigned char	res53[0x10];
	unsigned int	src_mau;
	unsigned int	src_fsys;
	unsigned int	src_gen;
	unsigned char	res54[0x4];
	unsigned int	src_peric0;
	unsigned int	src_peric1;
	unsigned char	res55[0x18];
	unsigned int	sclk_src_isp;
	unsigned char	res56[0x9c];
	unsigned int	src_mask_top;
	unsigned char	res57[0xc];
	unsigned int	src_mask_gscl;
	unsigned char	res58[0x8];
	unsigned int	src_mask_disp1_0;
	unsigned char	res59[0x4];
	unsigned int	src_mask_maudio;
	unsigned char	res60[0x8];
	unsigned int	src_mask_fsys;
	unsigned int	src_mask_gen;
	unsigned char	res61[0x8];
	unsigned int	src_mask_peric0;
	unsigned int	src_mask_peric1;
	unsigned char	res62[0x18];
	unsigned int	src_mask_isp;
	unsigned char	res63[0x9c];
	unsigned int	mux_stat_top0;
	unsigned int	mux_stat_top1;
	unsigned int	mux_stat_top2;
	unsigned int	mux_stat_top3;
	unsigned char	res64[0xf0];
	unsigned int	div_top0;
	unsigned int	div_top1;
	unsigned char	res65[0x8];
	unsigned int	div_gscl;
	unsigned char	res66[0x8];
	unsigned int	div_disp1_0;
	unsigned char	res67[0xc];
	unsigned int	div_gen;
	unsigned char	res68[0x4];
	unsigned int	div_mau;
	unsigned int	div_fsys0;
	unsigned int	div_fsys1;
	unsigned int	div_fsys2;
	unsigned char	res69[0x4];
	unsigned int	div_peric0;
	unsigned int	div_peric1;
	unsigned int	div_peric2;
	unsigned int	div_peric3;
	unsigned int	div_peric4;
	unsigned int	div_peric5;
	unsigned char	res70[0x10];
	unsigned int	sclk_div_isp;
	unsigned char	res71[0xc];
	unsigned int	div2_ratio0;
	unsigned int	div2_ratio1;
	unsigned char	res72[0x8];
	unsigned int	div4_ratio;
	unsigned char	res73[0x6c];
	unsigned int	div_stat_top0;
	unsigned int	div_stat_top1;
	unsigned char	res74[0x8];
	unsigned int	div_stat_gscl;
	unsigned char	res75[0x8];
	unsigned int	div_stat_disp1_0;
	unsigned char	res76[0xc];
	unsigned int	div_stat_gen;
	unsigned char	res77[0x4];
	unsigned int	div_stat_maudio;
	unsigned int	div_stat_fsys0;
	unsigned int	div_stat_fsys1;
	unsigned int	div_stat_fsys2;
	unsigned char	res78[0x4];
	unsigned int	div_stat_peric0;
	unsigned int	div_stat_peric1;
	unsigned int	div_stat_peric2;
	unsigned int	div_stat_peric3;
	unsigned int	div_stat_peric4;
	unsigned int	div_stat_peric5;
	unsigned char	res79[0x10];
	unsigned int	sclk_div_stat_isp;
	unsigned char	res80[0xc];
	unsigned int	div2_stat0;
	unsigned int	div2_stat1;
	unsigned char	res81[0x8];
	unsigned int	div4_stat;
	unsigned char	res82[0x184];
	unsigned int	gate_top_sclk_disp1;
	unsigned int	gate_top_sclk_gen;
	unsigned char	res83[0xc];
	unsigned int	gate_top_sclk_mau;
	unsigned int	gate_top_sclk_fsys;
	unsigned char	res84[0xc];
	unsigned int	gate_top_sclk_peric;
	unsigned char	res85[0x1c];
	unsigned int	gate_top_sclk_isp;
	unsigned char	res86[0xac];
	unsigned int	gate_ip_gscl;
	unsigned char	res87[0x4];
	unsigned int	gate_ip_disp1;
	unsigned int	gate_ip_mfc;
	unsigned int	gate_ip_g3d;
	unsigned int	gate_ip_gen;
	unsigned char	res88[0xc];
	unsigned int	gate_ip_fsys;
	unsigned char	res89[0x8];
	unsigned int	gate_ip_peric;
	unsigned char	res90[0xc];
	unsigned int	gate_ip_peris;
	unsigned char	res91[0x1c];
	unsigned int	gate_block;
	unsigned char	res92[0x1c];
	unsigned int	mcuiop_pwr_ctrl;
	unsigned char	res93[0x5c];
	unsigned int	clkout_cmu_top;
	unsigned int	clkout_cmu_top_div_stat;
	unsigned char	res94[0x37f8];
	unsigned int	src_lex;
	unsigned char	res95[0x1fc];
	unsigned int	mux_stat_lex;
	unsigned char	res96[0xfc];
	unsigned int	div_lex;
	unsigned char	res97[0xfc];
	unsigned int	div_stat_lex;
	unsigned char	res98[0x1fc];
	unsigned int	gate_ip_lex;
	unsigned char	res99[0x1fc];
	unsigned int	clkout_cmu_lex;
	unsigned int	clkout_cmu_lex_div_stat;
	unsigned char	res100[0x3af8];
	unsigned int	div_r0x;
	unsigned char	res101[0xfc];
	unsigned int	div_stat_r0x;
	unsigned char	res102[0x1fc];
	unsigned int	gate_ip_r0x;
	unsigned char	res103[0x1fc];
	unsigned int	clkout_cmu_r0x;
	unsigned int	clkout_cmu_r0x_div_stat;
	unsigned char	res104[0x3af8];
	unsigned int	div_r1x;
	unsigned char	res105[0xfc];
	unsigned int	div_stat_r1x;
	unsigned char	res106[0x1fc];
	unsigned int	gate_ip_r1x;
	unsigned char	res107[0x1fc];
	unsigned int	clkout_cmu_r1x;
	unsigned int	clkout_cmu_r1x_div_stat;
	unsigned char	res108[0x3608];
	unsigned int	bpll_lock;
	unsigned char	res109[0xfc];
	unsigned int	bpll_con0;
	unsigned int	bpll_con1;
	unsigned char	res110[0xe8];
	unsigned int	src_cdrex;
	unsigned char	res111[0x1fc];
	unsigned int	mux_stat_cdrex;
	unsigned char	res112[0xfc];
	unsigned int	div_cdrex;
	unsigned char	res113[0xfc];
	unsigned int	div_stat_cdrex;
	unsigned char	res114[0x2fc];
	unsigned int	gate_ip_cdrex;
	unsigned char	res115[0x10];
	unsigned int	dmc_freq_ctrl;
	unsigned char	res116[0x4];
	unsigned int	drex2_pause;
	unsigned char	res117[0xe0];
	unsigned int	clkout_cmu_cdrex;
	unsigned int	clkout_cmu_cdrex_div_stat;
	unsigned char	res118[0x8];
	unsigned int	lpddr3phy_ctrl;
	unsigned char	res119[0xc];
	unsigned int	lpddr3phy_con3;
	unsigned int	pll_div2_sel;
	unsigned char	res120[0xf5d8];
};

struct exynos5410_clock {
	unsigned int	apll_lock;			/* 0x1001_0000 */
	unsigned char	res1[0xfc];
	unsigned int	apll_con0;			/* 0x1001_0100 */
	unsigned int	apll_con1;			/* 0x1001_0104 */
	unsigned char	res2[0xf8];
	unsigned int	src_cpu;			/* 0x1001_0200 */
	unsigned char	res3[0x2fc];
	unsigned int	div_cpu0;			/* 0x1001_0500 */
	unsigned int	div_cpu1;			/* 0x1001_0504 */
	unsigned char	res4[0x4f8];
	unsigned int	clkout_cmu_cpu;			/* 0x1001_0A00 */
	unsigned char	res5[0x35fc];
	unsigned int	mpll_lock;			/* 0x1001_4000 */
	unsigned char	res6[0xfc];
	unsigned int	mpll_con0;			/* 0x1001_4100 */
	unsigned int	mpll_con1;			/* 0x1001_4104 */
	unsigned char	res7[0xf8];
	unsigned int	src_core0;			/* 0x1001_4200 */
	unsigned int	src_core1;			/* 0x1001_4204 */
	unsigned char	res8[0x2fc];
	unsigned int	div_core1;			/* 0x1001_4504 */
	unsigned char	res9[0x4f8];
	unsigned int	clkout_cmu_core;		/* 0x1001_4A00 */
	unsigned char	res10[0xb71c];
	unsigned int	cpll_con0;			/* 0x1002_0120 */
	unsigned int	cpll_con1;			/* 0x1002_0124 */
	unsigned int	dpll_con0;			/* 0x1002_0128 */
	unsigned int	dpll_con1;			/* 0x1002_012C */
	unsigned int	epll_con0;			/* 0x1002_0130 */
	unsigned int	epll_con1;			/* 0x1002_0134 */
	unsigned int	epll_con2;			/* 0x1002_0138 */
	unsigned char	res11[0x4];
	unsigned int	vpll_con0;			/* 0x1002_0140 */
	unsigned int	vpll_con1;			/* 0x1002_0144 */
	unsigned int	vpll_con2;			/* 0x1002_0148 */
	unsigned char	res12[0xc4];
	unsigned int	src_top0;			/* 0x1002_0210 */
	unsigned int	src_top1;			/* 0x1002_0214 */
	unsigned int	src_top2;			/* 0x1002_0218 */
	unsigned int	src_top3;			/* 0x1002_021C */
	unsigned char	res13[0x20];
	unsigned int	src_mau;			/* 0x1002_0240 */
	unsigned int	src_fsys;			/* 0x1002_0244 */
	unsigned char	res14[0x8];
	unsigned int	src_peric0;			/* 0x1002_0250 */
	unsigned int	src_peric1;			/* 0x1002_0254 */
	unsigned char	res15[0x2b8];
	unsigned int	div_top0;			/* 0x1002_0510 */
	unsigned int	div_top1;			/* 0x1002_0514 */
	unsigned int	div_top2;			/* 0x1002_0518 */
	unsigned int	div_top3;			/* 0x1002_051C */
	unsigned char	res16[0x28];
	unsigned int	div_fsys0;			/* 0x1002_0548 */
	unsigned int	div_fsys1;			/* 0x1002_054C */
	unsigned int	div_fsys2;			/* 0x1002_0550 */
	unsigned int	div_fsys3;			/* 0x1002_0554 */
	unsigned int	div_peric0;			/* 0x1002_0558 */
	unsigned char	res17[0x44];
	unsigned int	div4_ratio;			/* 0x1002_05A0 */
	unsigned char	res18[0x45c];
	unsigned int	clkout_cmu_top;			/* 0x1002_0A00 */
	unsigned char	res19[0xf60c];
	unsigned int	bpll_lock;			/* 0x1003_0010 */
	unsigned char	res20[0xfc];
	unsigned int	bpll_con0;			/* 0x1003_0110 */
	unsigned int	bpll_con1;			/* 0x1003_0114 */
	unsigned char	res21[0xe8];
	unsigned int	src_cdrex;			/* 0x1003_0200 */
	unsigned char	res22[0x1fc];
	unsigned int	mux_stat_cdrex;			/* 0x1003_0400 */
	unsigned char	res23[0xfc];
	unsigned int	div_cdrex0;			/* 0x1003_0500 */
	unsigned int	div_cdrex1;			/* 0x1003_0504 */
	unsigned char	res24[0x4f8];
	unsigned int	clkout_cmu_cdrex;		/* 0x1003_0A00 */
	unsigned char	res25[0x75fc];
	unsigned int	kpll_lock;			/* 0x1003_8000 */
	unsigned char	res26[0xfc];
	unsigned int	kpll_con0;			/* 0x1003_8100 */
	unsigned int	kpll_con1;			/* 0x1003_8104 */
	unsigned char	res27[0xf8];
	unsigned int	src_kfc;			/* 0x1003_8200 */
	unsigned char	res28[0x2fc];
	unsigned int	div_kfc;			/* 0x1003_8500 */
};
#endif

#endif
