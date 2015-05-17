
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

/* DON'T OVER THESE RANGE */
#if (CONFIG_DDR_CLK >= 375) && (CONFIG_DDR_CLK < 750)
	#define CFG_DDR_PLL_OD 2
	#define CFG_DDR_PLL_N  1
	#define CFG_DDR_PLL_M  (((CONFIG_DDR_CLK/6)*6)/12)
#elif (CONFIG_DDR_CLK >= 750) && (CONFIG_DDR_CLK <= 1104)
	#define CFG_DDR_PLL_OD 1
	#define CFG_DDR_PLL_N  1
	#define CFG_DDR_PLL_M  (((CONFIG_DDR_CLK/12)*12)/24)
#else
	#error "Over DDR PLL range! Please check CONFIG_DDR_CLK in board header file! \n"
#endif

#if (CONFIG_DDR_CLK >= 375 ) && (CONFIG_DDR_CLK < 533)
	#define DDR_7_7_7
#elif  (CONFIG_DDR_CLK >= 533 ) && (CONFIG_DDR_CLK < 667)
	#define DDR_9_9_9
#elif  (CONFIG_DDR_CLK >= 667 ) && (CONFIG_DDR_CLK < 800)
	#define DDR_11_11_11
#elif  (CONFIG_DDR_CLK >= 800 ) && (CONFIG_DDR_CLK <= 1104)
	#define DDR_13_13_13
#endif

/* PLEASE FILL THESE TIMING CONFIG ACCORDING TO YOUR DDR SPEC*/

/////////////////////////////////////////////////////////////////////////////////
//Following setting for board XXXXXXX with DDR K4B4G1646B(SANSUNG)
#ifdef DDR_7_7_7
	//DTPR0
	#define CFG_DDR_RTP (6)
	#define CFG_DDR_WTR (6)
	#define CFG_DDR_RP  (7)
	#define CFG_DDR_RCD (7)
	#define CFG_DDR_RAS (20)
	#define CFG_DDR_RRD (6)
	#define CFG_DDR_RC  (27)

	//DTPR1
	#define CFG_DDR_MRD (4)
	#define CFG_DDR_MOD (12)
	#define CFG_DDR_FAW (27)
	#define CFG_DDR_RFC (139)
	#define CFG_DDR_WLMRD (40)
	#define CFG_DDR_WLO (6)

	//DTPR2
	#define CFG_DDR_XS   (512)
	#define CFG_DDR_XP   (5)
	#define CFG_DDR_CKE  (4)
	#define CFG_DDR_DLLK (512)
	#define CFG_DDR_RTODT (0)
	#define CFG_DDR_RTW   (4)

	#define CFG_DDR_REFI  (78)
	#define CFG_DDR_REFI_MDDR3  (4)

	#define CFG_DDR_CL    (7)
	#define CFG_DDR_WR    (12)
	#define CFG_DDR_CWL   (8)
	#define CFG_DDR_AL    (0)
	#define CFG_DDR_EXSR  (512)
	#define CFG_DDR_DQS   (4)
	#define CFG_DDR_CKSRE (8)
	#define CFG_DDR_CKSRX (8)
	#define CFG_DDR_ZQCS  (64)
	#define CFG_DDR_ZQCL  (512)
	#define CFG_DDR_XPDLL (20)
	#define CFG_DDR_ZQCSI (1000)
#endif

#ifdef DDR_9_9_9
	//DTPR0
	#define CFG_DDR_RTP (6)
	#define CFG_DDR_WTR (6)
	#define CFG_DDR_RP  (9)
	#define CFG_DDR_RCD (9)
	#define CFG_DDR_RAS (24)
	#define CFG_DDR_RRD (5)
	#define CFG_DDR_RC  (33)

	//DTPR1
	#define CFG_DDR_MRD (4)
	#define CFG_DDR_MOD (12)
	#define CFG_DDR_FAW (30)
	#define CFG_DDR_RFC (174)
	#define CFG_DDR_WLMRD (40)
	#define CFG_DDR_WLO (6)

	//DTPR2
	#define CFG_DDR_XS   (512)
	#define CFG_DDR_XP   (5)
	#define CFG_DDR_CKE  (4)
	#define CFG_DDR_DLLK (512)
	#define CFG_DDR_RTODT (0)
	#define CFG_DDR_RTW   (4)

	#define CFG_DDR_REFI  (78)
	#define CFG_DDR_REFI_MDDR3  (4)

	#define CFG_DDR_CL    (9)
	#define CFG_DDR_WR    (12)
	#define CFG_DDR_CWL   (8)
	#define CFG_DDR_AL    (0)
	#define CFG_DDR_EXSR  (512)
	#define CFG_DDR_DQS   (4)
	#define CFG_DDR_CKSRE (8)
	#define CFG_DDR_CKSRX (8)
	#define CFG_DDR_ZQCS  (64)
	#define CFG_DDR_ZQCL  (136)
	#define CFG_DDR_XPDLL (20)
	#define CFG_DDR_ZQCSI (1000)

#endif

#ifdef DDR_11_11_11
	//DTPR0
	#define CFG_DDR_RTP (6)
	#define CFG_DDR_WTR (6)
	#define CFG_DDR_RP  (10)
	#define CFG_DDR_RCD (10)
	#define CFG_DDR_RAS (28)
	#define CFG_DDR_RRD (6)
	#define CFG_DDR_RC  (38)

	//DTPR1
	#define CFG_DDR_MRD (4)
	#define CFG_DDR_MOD (12)
	#define CFG_DDR_FAW (32)
	#define CFG_DDR_RFC  128
	#define CFG_DDR_WLMRD (40)
	#define CFG_DDR_WLO  6

	//DTPR2
	#define CFG_DDR_XS   (512)
	#define CFG_DDR_XP   (5)
	#define CFG_DDR_CKE  (4)
	#define CFG_DDR_DLLK (512)
	#define CFG_DDR_RTODT (0)
	#define CFG_DDR_RTW   (4)

	#define CFG_DDR_REFI  (78)
	#define CFG_DDR_REFI_MDDR3  (4)
	#define CFG_DDR_CL    (10)
	#define CFG_DDR_WR    (12)
	#define CFG_DDR_CWL   (8)
	#define CFG_DDR_AL    (0)
	#define CFG_DDR_EXSR  (512)
	#define CFG_DDR_DQS   (4)
	#define CFG_DDR_CKSRE (8)
	#define CFG_DDR_CKSRX (8)
	#define CFG_DDR_ZQCS  (64)
	#define CFG_DDR_ZQCL  (136)
	#define CFG_DDR_XPDLL (20)
	#define CFG_DDR_ZQCSI (1000)
#endif

#ifdef DDR_13_13_13
	//DTPR0
	#define CFG_DDR_RTP (7)
	#define CFG_DDR_WTR (7)
	#define CFG_DDR_RP  (12)
	#define CFG_DDR_RCD (12)
	#define CFG_DDR_RAS (33)
	#define CFG_DDR_RRD (6)
	#define CFG_DDR_RC  (45)

	//DTPR1
	#define CFG_DDR_MRD (4)
	#define CFG_DDR_MOD (14)
	#define CFG_DDR_FAW (33)
	#define CFG_DDR_RFC  (150)
	#define CFG_DDR_WLMRD (40)
	#define CFG_DDR_WLO  (7)

	//DTPR2
	#define CFG_DDR_XS   (512)
	#define CFG_DDR_XP   (6)
	#define CFG_DDR_CKE  (5)
	#define CFG_DDR_DLLK (512)
	#define CFG_DDR_RTODT (0)
	#define CFG_DDR_RTW   (6)

	#define CFG_DDR_REFI  (78)
	#define CFG_DDR_REFI_MDDR3  (4)
	#define CFG_DDR_CL    (12)
	#define CFG_DDR_WR    (14)
	#define CFG_DDR_CWL   (9)
	#define CFG_DDR_AL    (0)
	#define CFG_DDR_EXSR  (512)
	#define CFG_DDR_DQS   (5)
	#define CFG_DDR_CKSRE (10)
	#define CFG_DDR_CKSRX (10)
	#define CFG_DDR_ZQCS  (64)
	#define CFG_DDR_ZQCL  (136)
	#define CFG_DDR_XPDLL (23)
	#define CFG_DDR_ZQCSI (1000)
#endif

static ddr_set_t __ddr_setting = {
	/* common and function defines */
	.ddr_channel_set		= CONFIG_DDR_CHANNEL_SET,
	.ddr_base_addr			= CFG_DDR_BASE_ADDR,
	.ddr_start_offset		= CFG_DDR_START_OFFSET,
	.ddr_size				= CONFIG_DDR_SIZE,
	.ddr_pll_ctrl			= (CFG_DDR_PLL_OD << 16)|(CFG_DDR_PLL_N<<9)|(CFG_DDR_PLL_M<<0),
	.ddr_dmc_ctrl			= 0,
	.ddr0_addrmap			= {0},
	.ddr1_addrmap			= {0},
	.ddr_2t_mode			= 1,
	.ddr_full_test			= CONFIG_DDR_FULL_TEST,

	/* pub defines */
	.t_pub_ptr				= {
							[0] = ( 6 | (320 << 6) | (80 << 21)),
							[1] = (120 | (1000 << 16)),
							[2] = 0,
							[3] = (20000 | (136 << 20)),
							[4] = (1000 | (180 << 16)),
	},  //PUB PTR0-3
	.t_pub_odtcr			= 0x00210000,
	.t_pub_mr				= {
							[0] = (0x0 | (0x0 << 2) | (0x0 << 3) | (0x6 << 4) | (0x0 << 7) | (0x0 << 8) | (0x6 << 9) | (1 << 12)),
							[1] = (0x6|(1<<6)|(1<<7)),
							[2] = 0x18,
							[3] = 0x0,
	},   //PUB MR0-3
	.t_pub_dtpr				= {
							[0] = (CFG_DDR_RTP			|
								(CFG_DDR_WTR << 4)		|
								(CFG_DDR_RP << 8)		|
								(CFG_DDR_RAS << 16)		|
								(CFG_DDR_RRD << 22)		|
								(CFG_DDR_RCD << 26)),
							[1] = ((CFG_DDR_MOD << 2)	|
								(CFG_DDR_FAW << 5)		|
								(CFG_DDR_RFC << 11)		|
								(CFG_DDR_WLMRD << 20)	|
								(CFG_DDR_WLO << 26)		|
								(0 << 30) ), //TAOND
							[2] = (CFG_DDR_XS			|
								(CFG_DDR_XP << 10)		|
								(CFG_DDR_DLLK << 19)	|
								(0 << 29)				| //TRTODT ADDITIONAL
								(0 << 30)				| //TRTW ADDITIONAL
								(0 << 31 )), //TCCD ADDITIONAL
							[3] = (0 | (0 << 3)			|
								(CFG_DDR_RC << 6)		|
								(CFG_DDR_CKE << 13)		|
								(CFG_DDR_MRD << 18)		|
								(0 << 29)), //tAOFDx
	}, //PUB DTPR0-3
	.t_pub_pgcr1			= 0x0380c6a0,   //PUB PGCR1
	.t_pub_pgcr2			= 0x00f05f97,   //PUB PGCR2
	.t_pub_pgcr3			= 0xc0aaf860,   //PUB PGCR3
	.t_pub_dxccr			= 0x00181884,   //PUB DXCCR
	.t_pub_dtcr				= 0x43003087,    //PUB DTCR
	.t_pub_aciocr			= {0},  //PUB ACIOCRx
	.t_pub_dx0gcr			= {0},  //PUB DX0GCRx
	.t_pub_dx1gcr			= {0},  //PUB DX1GCRx
	.t_pub_dx2gcr			= {0},  //PUB DX2GCRx
	.t_pub_dx3gcr			= {0},  //PUB DX3GCRx
	.t_pub_dcr				= 0X8B,     //PUB DCR
	.t_pub_dtar				= (0X0 | (0X0 <<12) | (7 << 28)),
	.t_pub_dsgcr			= 0x020641a,
	.t_pub_zq0pr			= 0x7b,   //PUB ZQ0PR
	.t_pub_zq1pr			= 0x7b,   //PUB ZQ1PR
	.t_pub_zq2pr			= 0x7b,   //PUB ZQ2PR
	.t_pub_zq3pr			= 0x7b,   //PUB ZQ3PR

	/* pctl0 defines */
	.t_pctl0_1us_pck		= CONFIG_DDR_CLK / 2,   //PCTL TOGCNT1U
	.t_pctl0_100ns_pck		= CONFIG_DDR_CLK / 20, //PCTL TOGCNT100N
	.t_pctl0_init_us		= 2,   //PCTL TINIT
	.t_pctl0_rsth_us		= 2,   //PCTL TRSTH
	.t_pctl0_mcfg			= 0XA2F21,   //PCTL MCFG default 1T
	.t_pctl0_mcfg1			= 0X80000000,  //PCTL MCFG1
	.t_pctl0_trfc			= CFG_DDR_RFC,   //PCTL TRFC 36..374
	.t_pctl0_trefi_mem_ddr3	= CFG_DDR_REFI_MDDR3, //PCTL TREFI MEM DDR3
	.t_pctl0_tmrd			= CFG_DDR_MRD,   //PCTL TMRD 2..4
	.t_pctl0_trp			= CFG_DDR_RP,    //PCTL TRP  0
	.t_pctl0_tal			= CFG_DDR_AL,    //PCTL TAL 0,CL-1,CL-2
	.t_pctl0_tcwl			= CFG_DDR_CWL,   //PCTL TCWL
	.t_pctl0_tcl			= CFG_DDR_CL,    //PCTL TCL
	.t_pctl0_tras			= CFG_DDR_RAS,   //PCTL TRAS 15..38
	.t_pctl0_trc			= CFG_DDR_RC,    //PCTL TRC   20..52
	.t_pctl0_trcd			= CFG_DDR_RCD,   //PCTL TRCD 5..14
	.t_pctl0_trrd			= CFG_DDR_RRD,   //PCTL TRRD 4..8
	.t_pctl0_trtp			= CFG_DDR_RTP,   //PCTL TRTP 3..8
	.t_pctl0_twr			= CFG_DDR_WR,    //PCTL TWR  6..16
	.t_pctl0_twtr			= CFG_DDR_WTR,   //PCTL TWTR 3..8
	.t_pctl0_texsr			= CFG_DDR_EXSR,  //PCTL TEXSR 512
	.t_pctl0_txp			= CFG_DDR_XP,    //PCTL TXP  1..7
	.t_pctl0_tdqs			= CFG_DDR_DQS,   //PCTL TDQS 1..12
	.t_pctl0_trtw			= CFG_DDR_RTW,   //PCTL TRTW 2..10
	.t_pctl0_tcksre			= CFG_DDR_CKSRE, //PCTL TCKSRE 5..15
	.t_pctl0_tcksrx			= CFG_DDR_CKSRX, //PCTL TCKSRX 5..15
	.t_pctl0_tmod			= CFG_DDR_MOD,   //PCTL TMOD 0..31
	.t_pctl0_tcke			= CFG_DDR_CKE,   //PCTL TCKE 3..6
	.t_pctl0_tzqcs			= CFG_DDR_ZQCS,  //PCTL TZQCS 64
	.t_pctl0_tzqcl			= CFG_DDR_ZQCL,  //PCTL TZQCL 0..1023
	.t_pctl0_txpdll			= CFG_DDR_XPDLL, //PCTL TXPDLL 3..63
	.t_pctl0_tzqcsi			= CFG_DDR_ZQCSI, //PCTL TZQCSI 0..4294967295
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
	.t_pctl0_dfiodtcfg1		= ( 0x0 | (0x6 << 16) ),
	.t_pctl0_dfilpcfg0		= ( 1 | (3 << 4) | (1 << 8) | (3 << 12) | (7 <<16) | (1 <<24) | ( 3 << 28)),

	/* pctl1 defines */
	.t_pctl1_1us_pck		= CONFIG_DDR_CLK / 2,   //PCTL TOGCNT1U
	.t_pctl1_100ns_pck		= CONFIG_DDR_CLK / 20, //PCTL TOGCNT100N
	.t_pctl1_init_us		= 2,   //PCTL TINIT
	.t_pctl1_rsth_us		= 2,   //PCTL TRSTH
	.t_pctl1_mcfg			= 0XA2F21,   //PCTL MCFG default 1T
	.t_pctl1_mcfg1			= 0X80000000,  //PCTL MCFG1
	.t_pctl1_trfc			= CFG_DDR_RFC,   //PCTL TRFC 36..374
	.t_pctl1_trefi_mem_ddr3	= CFG_DDR_REFI_MDDR3, //PCTL TREFI MEM DDR3
	.t_pctl1_tmrd			= CFG_DDR_MRD,   //PCTL TMRD 2..4
	.t_pctl1_trp			= CFG_DDR_RP,    //PCTL TRP  0
	.t_pctl1_tal			= CFG_DDR_AL,    //PCTL TAL 0,CL-1,CL-2
	.t_pctl1_tcwl			= CFG_DDR_CWL,   //PCTL TCWL
	.t_pctl1_tcl			= CFG_DDR_CL,    //PCTL TCL
	.t_pctl1_tras			= CFG_DDR_RAS,   //PCTL TRAS 15..38
	.t_pctl1_trc			= CFG_DDR_RC,    //PCTL TRC   20..52
	.t_pctl1_trcd			= CFG_DDR_RCD,   //PCTL TRCD 5..14
	.t_pctl1_trrd			= CFG_DDR_RRD,   //PCTL TRRD 4..8
	.t_pctl1_trtp			= CFG_DDR_RTP,   //PCTL TRTP 3..8
	.t_pctl1_twr			= CFG_DDR_WR,    //PCTL TWR  6..16
	.t_pctl1_twtr			= CFG_DDR_WTR,   //PCTL TWTR 3..8
	.t_pctl1_texsr			= CFG_DDR_EXSR,  //PCTL TEXSR 512
	.t_pctl1_txp			= CFG_DDR_XP,    //PCTL TXP  1..7
	.t_pctl1_tdqs			= CFG_DDR_DQS,   //PCTL TDQS 1..12
	.t_pctl1_trtw			= CFG_DDR_RTW,   //PCTL TRTW 2..10
	.t_pctl1_tcksre			= CFG_DDR_CKSRE, //PCTL TCKSRE 5..15
	.t_pctl1_tcksrx			= CFG_DDR_CKSRX, //PCTL TCKSRX 5..15
	.t_pctl1_tmod			= CFG_DDR_MOD,   //PCTL TMOD 0..31
	.t_pctl1_tcke			= CFG_DDR_CKE,   //PCTL TCKE 3..6
	.t_pctl1_tzqcs			= CFG_DDR_ZQCS,  //PCTL TZQCS 64
	.t_pctl1_tzqcl			= CFG_DDR_ZQCL,  //PCTL TZQCL 0..1023
	.t_pctl1_txpdll			= CFG_DDR_XPDLL, //PCTL TXPDLL 3..63
	.t_pctl1_tzqcsi			= CFG_DDR_ZQCSI, //PCTL TZQCSI 0..4294967295
	.t_pctl1_scfg			= 0xF01,   //PCTL SCFG
	.t_pctl1_sctl			= 0x1,   //PCTL SCTL
	//.t_pctl1_ppcfg			= (0xF0 << 1),
	.t_pctl1_dfistcfg0		= 0x4,
	.t_pctl1_dfistcfg1		= 0x1,
	.t_pctl1_dfitctrldelay	= 2,
	.t_pctl1_dfitphywrdata	= 1,
	.t_pctl1_dfitphywrlta	= 2,
	.t_pctl1_dfitrddataen	= 3,
	.t_pctl1_dfitphyrdlat	= 16,
	.t_pctl1_dfitdramclkdis	= 1,
	.t_pctl1_dfitdramclken	= 1,
	.t_pctl1_dfitphyupdtype1 = 0x200,
	.t_pctl1_dfitctrlupdmin	= 16,
	.t_pctl1_cmdtstaten		= 1,
	//.t_pctl1_dfiodtcfg		= 8,
	.t_pctl1_dfiodtcfg1		= ( 0x0 | (0x6 << 16) ),
	.t_pctl1_dfilpcfg0		= ( 1 | (3 << 4) | (1 << 8) | (3 << 12) | (7 <<16) | (1 <<24) | ( 3 << 28)),
};
