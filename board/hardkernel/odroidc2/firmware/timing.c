
/*
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

#include <asm/arch/timing.h>
#include <asm/arch/ddr_define.h>

/* DDR freq range */
#define CONFIG_DDR_CLK_LOW  375
#define CONFIG_DDR_CLK_HIGH 1500
/* DON'T OVER THESE RANGE */
#if (CONFIG_DDR_CLK < CONFIG_DDR_CLK_LOW) || (CONFIG_DDR_CLK > CONFIG_DDR_CLK_HIGH)
	#error "Over DDR PLL range! Please check CONFIG_DDR_CLK in board header file! \n"
#endif

/* CPU freq range */
#define CONFIG_CPU_CLK_LOW  600
#define CONFIG_CPU_CLK_HIGH 2000
/* DON'T OVER THESE RANGE */
#if (CONFIG_CPU_CLK < CONFIG_CPU_CLK_LOW) || (CONFIG_CPU_CLK > CONFIG_CPU_CLK_HIGH)
	#error "Over CPU PLL range! Please check CONFIG_CPU_CLK in board header file! \n"
#endif

#define DDR3_DRV_40OHM		0
#define DDR3_DRV_34OHM		1
#define DDR3_ODT_0OHM		0
#define DDR3_ODT_60OHM		1
#define DDR3_ODT_120OHM		2
#define DDR3_ODT_40OHM		3
#define DDR3_ODT_20OHM		4
#define DDR3_ODT_30OHM		5

#define CFG_DDR3_DRV  DDR3_DRV_40OHM
#define CFG_DDR3_ODT  DDR3_ODT_120OHM

/*
 * these parameters are corresponding to the pcb layout,
 * please don't enable this function unless these signals
 * has been measured by oscilloscope.
 */
#ifdef CONFIG_DDR_CMD_BDL_TUNE
#define DDR_AC_LCDLR   0
#define	DDR_CK0_BDL	18
#define	DDR_RAS_BDL	18
#define	DDR_CAS_BDL	24
#define	DDR_WE_BDL	21
#define	DDR_BA0_BDL	16
#define	DDR_BA1_BDL	2
#define	DDR_BA2_BDL	13
#define	DDR_ACPDD_BDL	27
#define	DDR_CS0_BDL	27
#define	DDR_CS1_BDL	27
#define	DDR_ODT0_BDL	27
#define	DDR_ODT1_BDL	27
#define	DDR_CKE0_BDL	27
#define	DDR_CKE1_BDL	27
#define	DDR_A0_BDL	14
#define	DDR_A1_BDL	9
#define	DDR_A2_BDL	5
#define	DDR_A3_BDL	18
#define	DDR_A4_BDL	4
#define	DDR_A5_BDL	16
#define	DDR_A6_BDL	1
#define	DDR_A7_BDL	10
#define	DDR_A8_BDL	4
#define	DDR_A9_BDL	7
#define	DDR_A10_BDL	10
#define	DDR_A11_BDL	9
#define	DDR_A12_BDL	6
#define	DDR_A13_BDL	16
#define	DDR_A14_BDL	8
#define	DDR_A15_BDL	27
#endif

/* CAUTION!! */
/*
 * For DDR3:
 *     7-7-7:    CONFIG_DDR_CLK range  375~ 533
 *     9-9-9:    CONFIG_DDR_CLK range  533~ 667
 *     11-11-11: CONFIG_DDR_CLK range  667~ 800
 *     12-12-12: CONFIG_DDR_CLK range  800~ 933
 *     13-13-13: CONFIG_DDR_CLK range  933~1066
 *     14-14-14: CONFIG_DDR_CLK range 1066~1200
 */
ddr_timing_t __ddr_timming[] = {
	//ddr3_7_7_7
	{
		.identifier				= CONFIG_DDR_TIMMING_DDR3_7,
		.cfg_ddr_rtp			= (6),
		.cfg_ddr_wtr			= (7),
		.cfg_ddr_rp				= (7),
		.cfg_ddr_rcd			= (7),
		.cfg_ddr_ras			= (20),
		.cfg_ddr_rrd			= (6),
		.cfg_ddr_rc				= (27),
		.cfg_ddr_mrd			= (4),
		.cfg_ddr_mod			= (12),
		.cfg_ddr_faw			= (27),
		.cfg_ddr_rfc			= (160),
		.cfg_ddr_wlmrd			= (40),
		.cfg_ddr_wlo			= (6),
		.cfg_ddr_xs				= (512),
		.cfg_ddr_xp				= (7),
		.cfg_ddr_cke			= (4),
		.cfg_ddr_dllk			= (512),
		.cfg_ddr_rtodt			= (0),
		.cfg_ddr_rtw			= (4),
		.cfg_ddr_refi			= (78),
		.cfg_ddr_refi_mddr3		= (4),
		.cfg_ddr_cl				= (7),
		.cfg_ddr_wr				= (12),
		.cfg_ddr_cwl			= (5),
		.cfg_ddr_al				= (0),
		.cfg_ddr_exsr			= (512),
		.cfg_ddr_dqs			= (4),
		.cfg_ddr_cksre			= (15),
		.cfg_ddr_cksrx			= (15),
		.cfg_ddr_zqcs			= (64),
		.cfg_ddr_zqcl			= (512),
		.cfg_ddr_xpdll			= (20),
		.cfg_ddr_zqcsi			= (1000),
	},
	//ddr3_9_9_9
	{
		.identifier				= CONFIG_DDR_TIMMING_DDR3_9,
		.cfg_ddr_rtp			= (6),
		.cfg_ddr_wtr			= (7),
		.cfg_ddr_rp				= (9),
		.cfg_ddr_rcd			= (9),
		.cfg_ddr_ras			= (27),
		.cfg_ddr_rrd			= (6),
		.cfg_ddr_rc				= (33),
		.cfg_ddr_mrd			= (4),
		.cfg_ddr_mod			= (12),
		.cfg_ddr_faw			= (30),
		.cfg_ddr_rfc			= (196),
		.cfg_ddr_wlmrd			= (40),
		.cfg_ddr_wlo			= (6),
		.cfg_ddr_xs				= (512),
		.cfg_ddr_xp				= (7),
		.cfg_ddr_cke			= (4),
		.cfg_ddr_dllk			= (512),
		.cfg_ddr_rtodt			= (0),
		.cfg_ddr_rtw			= (6),
		.cfg_ddr_refi			= (78),
		.cfg_ddr_refi_mddr3		= (4),
		.cfg_ddr_cl				= (9),
		.cfg_ddr_wr				= (12),
		.cfg_ddr_cwl			= (7),
		.cfg_ddr_al				= (0),
		.cfg_ddr_exsr			= (512),
		.cfg_ddr_dqs			= (23),
		.cfg_ddr_cksre			= (15),
		.cfg_ddr_cksrx			= (15),
		.cfg_ddr_zqcs			= (64),
		.cfg_ddr_zqcl			= (136),
		.cfg_ddr_xpdll			= (20),
		.cfg_ddr_zqcsi			= (1000),
	},
	//ddr3_11_11_11
	{
		.identifier				= CONFIG_DDR_TIMMING_DDR3_11,
		.cfg_ddr_rtp			= (7),
		.cfg_ddr_wtr			= (7),
		.cfg_ddr_rp				= (11),
		.cfg_ddr_rcd			= (11),
		.cfg_ddr_ras			= (35),
		.cfg_ddr_rrd			= (7),
		.cfg_ddr_rc				= (45),
		.cfg_ddr_mrd			= (6),
		.cfg_ddr_mod			= (4),
		.cfg_ddr_faw			= (33),
		.cfg_ddr_rfc			= (280),
		.cfg_ddr_wlmrd			= (40),
		.cfg_ddr_wlo			= (7),
		.cfg_ddr_xs				= (512),
		.cfg_ddr_xp				= (5),
		.cfg_ddr_cke			= (4),
		.cfg_ddr_dllk			= (512),
		.cfg_ddr_rtodt			= (0),
		.cfg_ddr_rtw			= (7),
		.cfg_ddr_refi			= (78),
		.cfg_ddr_refi_mddr3		= (4),
		.cfg_ddr_cl				= (11),
		.cfg_ddr_wr				= (12),
		.cfg_ddr_cwl			= (8),
		.cfg_ddr_al				= (0),
		.cfg_ddr_exsr			= (512),
		.cfg_ddr_dqs			= (23),
		.cfg_ddr_cksre			= (15),
		.cfg_ddr_cksrx			= (15),
		.cfg_ddr_zqcs			= (64),
		.cfg_ddr_zqcl			= (136),
		.cfg_ddr_xpdll			= (23),
		.cfg_ddr_zqcsi			= (1000),
	},
	//ddr3_13_13_13
	{
		.identifier				= CONFIG_DDR_TIMMING_DDR3_13,
		.cfg_ddr_rtp			= (7),
		.cfg_ddr_wtr			= (7),
		.cfg_ddr_rp				= (13),
		.cfg_ddr_rcd			= (13),
		.cfg_ddr_ras			= (37),
		.cfg_ddr_rrd			= (7),
		.cfg_ddr_rc				= (52),
		.cfg_ddr_mrd			= (6),
		.cfg_ddr_mod			= (4),
		.cfg_ddr_faw			= (33),
		.cfg_ddr_rfc			= (280),
		.cfg_ddr_wlmrd			= (40),
		.cfg_ddr_wlo			= (7),
		.cfg_ddr_xs				= (512),
		.cfg_ddr_xp				= (7),
		.cfg_ddr_cke			= (5),
		.cfg_ddr_dllk			= (512),
		.cfg_ddr_rtodt			= (0),
		.cfg_ddr_rtw			= (7),
		.cfg_ddr_refi			= (78),
		.cfg_ddr_refi_mddr3		= (4),
		.cfg_ddr_cl				= (13),
		.cfg_ddr_wr				= (16),
		.cfg_ddr_cwl			= (9),
		.cfg_ddr_al				= (0),
		.cfg_ddr_exsr			= (512),
		.cfg_ddr_dqs			= (23),
		.cfg_ddr_cksre			= (15),
		.cfg_ddr_cksrx			= (15),
		.cfg_ddr_zqcs			= (64),
		.cfg_ddr_zqcl			= (136),
		.cfg_ddr_xpdll			= (23),
		.cfg_ddr_zqcsi			= (1000),
	},
	{
		.identifier				= CONFIG_DDR_TIMMING_DDR3_14,
		.cfg_ddr_rtp			= (7),
		.cfg_ddr_wtr			= (7),
		.cfg_ddr_rp				= (14),
		.cfg_ddr_rcd			= (14),
		.cfg_ddr_ras			= (37),
		.cfg_ddr_rrd			= (7),
		.cfg_ddr_rc				= (52),
		.cfg_ddr_mrd			= (6),
		.cfg_ddr_mod			= (4),
		.cfg_ddr_faw			= (33),
		.cfg_ddr_rfc			= (280),
		.cfg_ddr_wlmrd			= (40),
		.cfg_ddr_wlo			= (7),
		.cfg_ddr_xs				= (512),
		.cfg_ddr_xp				= (7),
		.cfg_ddr_cke			= (5),
		.cfg_ddr_dllk			= (512),
		.cfg_ddr_rtodt			= (0),
		.cfg_ddr_rtw			= (7),
		.cfg_ddr_refi			= (78),
		.cfg_ddr_refi_mddr3		= (4),
		.cfg_ddr_cl				= (14),
		.cfg_ddr_wr				= (16),
		.cfg_ddr_cwl			= (10),
		.cfg_ddr_al				= (0),
		.cfg_ddr_exsr			= (512),
		.cfg_ddr_dqs			= (23),
		.cfg_ddr_cksre			= (15),
		.cfg_ddr_cksrx			= (15),
		.cfg_ddr_zqcs			= (64),
		.cfg_ddr_zqcl			= (136),
		.cfg_ddr_xpdll			= (23),
		.cfg_ddr_zqcsi			= (1000),
	}
};

ddr_set_t __ddr_setting = {
	/* common and function defines */
	.ddr_channel_set		= CONFIG_DDR_CHANNEL_SET,
	.ddr_type				= CONFIG_DDR_TYPE,
	.ddr_clk				= CONFIG_DDR_CLK,
	.ddr_base_addr			= CFG_DDR_BASE_ADDR,
	.ddr_start_offset		= CFG_DDR_START_OFFSET,
	.ddr_timing_ind			= 0,
	.ddr_size				= CONFIG_DDR_SIZE,
	.ddr_pll_ctrl			= (0),
	.ddr_dmc_ctrl			= 0,
	.ddr0_addrmap			= {0},
	.ddr1_addrmap			= {0},
	.ddr_2t_mode			= 1,
	.ddr_full_test			= CONFIG_DDR_FULL_TEST,
	.ddr_size_detect		= CONFIG_DDR_SIZE_AUTO_DETECT,
	.ddr_drv				= CFG_DDR3_DRV,
	.ddr_odt				= CFG_DDR3_ODT,

	/* pub defines */
	.t_pub_ptr				= {
							[0] = ( 6 | (320 << 6) | (80 << 21)),
							[1] = (120 | (1000 << 16)),
							[2] = 0,
							[3] = (20000 | (136 << 20)),
							[4] = (1000 | (180 << 16)),
	},  //PUB PTR0-3
	.t_pub_odtcr			= 0x00210000,
	.t_pub_mr				= {0},
	.t_pub_dtpr				= {0},
	.t_pub_pgcr0			= 0x07d81e3f,   //PUB PGCR0
	.t_pub_pgcr1			= 0x0380c6a0,   //PUB PGCR1
	//.t_pub_pgcr2			= 0x00f05f97,   //PUB PGCR2
	.t_pub_pgcr2			= 0x01f12480,   //PUB PGCR2
	.t_pub_pgcr3			= 0xc0aafe60,   //PUB PGCR3
	.t_pub_dxccr			= 0x00181884,   //PUB DXCCR
	.t_pub_dtcr				= 0x43003087,    //PUB DTCR
	.t_pub_aciocr			= {0},  //PUB ACIOCRx
	.t_pub_dx0gcr			= {0},  //PUB DX0GCRx
	.t_pub_dx1gcr			= {0},  //PUB DX1GCRx
	.t_pub_dx2gcr			= {0},  //PUB DX2GCRx
	.t_pub_dx3gcr			= {0},  //PUB DX3GCRx
	.t_pub_dcr				= 0XB,     //PUB DCR
	.t_pub_dtar				= (0X0 | (0X0 <<12) | (0 << 28)),
	.t_pub_dsgcr			= 0x020645a,
	//.t_pub_zq0pr			= 0x7b,   //PUB ZQ0PR
	//.t_pub_zq1pr			= 0x7b,   //PUB ZQ1PR
	//.t_pub_zq2pr			= 0x7b,   //PUB ZQ2PR
	//.t_pub_zq3pr			= 0x7b,   //PUB ZQ3PR
	.t_pub_zq0pr			= 0x69,   //PUB ZQ0PR
	.t_pub_zq1pr			= 0x69,   //PUB ZQ1PR
	.t_pub_zq2pr			= 0x69,   //PUB ZQ2PR
	.t_pub_zq3pr			= 0x69,   //PUB ZQ3PR

	/* pctl0 defines */
	/* pctl1 use same define as pctl0 */
	.t_pctl0_1us_pck		= CONFIG_DDR_CLK / 2,   //PCTL TOGCNT1U
	.t_pctl0_100ns_pck		= CONFIG_DDR_CLK / 20, //PCTL TOGCNT100N
	.t_pctl0_init_us		= 2,   //PCTL TINIT
	.t_pctl0_rsth_us		= 2,   //PCTL TRSTH
	.t_pctl0_mcfg			= 0XA2F21,   //PCTL MCFG default 1T
	//.t_pctl0_mcfg1			= 0X80000000,  //PCTL MCFG1
	.t_pctl0_mcfg1			=  (1<<31)|(0x20<<16)|(0x0<<0)//[B31]hw_exit_idle_en
								|( 0<<8), //[B10,B9,B8] tfaw_cfg_offset:
								//tFAW= (4 + MCFG.tfaw_cfg)*tRRD - tfaw_cfg_offset,  //PCTL MCFG1
	.t_pctl0_scfg			= 0xF01,   //PCTL SCFG
	.t_pctl0_sctl			= 0x1,   //PCTL SCTL
	//.t_pctl0_ppcfg			= (0xF0 << 1),
	.t_pctl0_dfistcfg0		= 0x4,
	.t_pctl0_dfistcfg1		= 0x1,
	.t_pctl0_dfitctrldelay	= 2,
	.t_pctl0_dfitphywrdata	= 1,
	.t_pctl0_dfitphywrlta	= 2,
	.t_pctl0_dfitrddataen	= 3,
	.t_pctl0_dfitphyrdlat	= 16,
	.t_pctl0_dfitdramclkdis	= 1,
	.t_pctl0_dfitdramclken	= 1,
	.t_pctl0_dfitphyupdtype1 = 0x200,
	.t_pctl0_dfitctrlupdmin	= 16,
	.t_pctl0_cmdtstaten		= 1,
	//.t_pctl0_dfiodtcfg		= 8,
	//.t_pctl0_dfiodtcfg1		= ( 0x0 | (0x6 << 16) ),
	.t_pctl0_dfiodtcfg		= (1<<3)|(1<<11),
	.t_pctl0_dfiodtcfg1		= (0x0 | (0x6 << 16)),
	.t_pctl0_dfilpcfg0		= ( 1 | (3 << 4) | (1 << 8) | (3 << 12) | (7 <<16) | (1 <<24) | ( 3 << 28)),

	.t_pub_acbdlr0          = 0x10,  //2015.09.21 add for  CK0 delay fine tune
};

pll_set_t __pll_setting = {
	.cpu_clk				= CONFIG_CPU_CLK / 24 * 24,
	.spi_ctrl				= 0,
	.vddee					= CONFIG_VDDEE_INIT_VOLTAGE,
	.vcck					= CONFIG_VCCK_INIT_VOLTAGE,
	.lCustomerID				= CONFIG_CUSTOMER_ID,
};
