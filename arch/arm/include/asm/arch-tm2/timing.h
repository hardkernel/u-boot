
/*
 * arch/arm/include/asm/arch-txl/timing.h
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

#ifndef __AML_TIMING_H_
#define __AML_TIMING_H_

#include <asm/arch/ddr_define.h>
#include <asm/arch/types.h>
#include <asm/arch/mnPmuSramMsgBlock_ddr3.h>
#include <asm/arch/mnPmuSramMsgBlock_ddr4.h>
#include <asm/arch/mnPmuSramMsgBlock_ddr4_2d.h>
#include <asm/arch/mnPmuSramMsgBlock_lpddr3.h>
#include <asm/arch/mnPmuSramMsgBlock_lpddr4.h>
#include <asm/arch/mnPmuSramMsgBlock_lpddr4_2d.h>

#define BL2_INIT_STAGE_0			0
#define BL2_INIT_STAGE_1			1
#define BL2_INIT_STAGE_2			2
#define BL2_INIT_STAGE_3			3
#define BL2_INIT_STAGE_4			4
#define BL2_INIT_STAGE_5			5
#define BL2_INIT_STAGE_6			6
#define BL2_INIT_STAGE_7			7
#define BL2_INIT_STAGE_8			8
#define BL2_INIT_STAGE_9			9

typedef struct bl2_reg {
	unsigned int	reg;
	unsigned int	value;
	unsigned int	mask;
	unsigned short	udelay;
	unsigned char	flag;
	unsigned char	rsv_0;
}__attribute__ ((packed)) bl2_reg_t;

typedef struct ddr_reg {
	unsigned int	reg;
	unsigned int	value;
	unsigned int	mask;
	unsigned short	udelay;
	unsigned char	flag;
	unsigned char	rsv_0;
}__attribute__ ((packed)) ddr_reg_t;

typedef struct ddr_set{
	unsigned	int		magic;
	unsigned	int		rsv_int0;
	unsigned	char	board_id;
	//board id reserve,,do not modify
	unsigned	char	version;
	// firmware reserve version,,do not modify
	unsigned	char	DramType;
	//support DramType should confirm with amlogic
	//#define CONFIG_DDR_TYPE_DDR3				0
	//#define CONFIG_DDR_TYPE_DDR4				1
	//#define CONFIG_DDR_TYPE_LPDDR4				2
	//#define CONFIG_DDR_TYPE_LPDDR3				3
	//#define CONFIG_DDR_TYPE_LPDDR2				4
	unsigned	char	DisabledDbyte;
	//use for dram bus 16bit or 32bit,if use 16bit mode ,should disable bit 2,3
	//bit 0 ---use byte 0 ,1 disable byte 0,
	//bit 1 ---use byte 1 ,1 disable byte 1,
	//bit 2 ---use byte 2 ,1 disable byte 2,
	//bit 3 ---use byte 3 ,1 disable byte 3,
	unsigned	char	Is2Ttiming;
	//ddr3/ddr3 use 2t timing,now only support 2t timming
	unsigned	char	HdtCtrl;
	//training information control,do not modify
	unsigned	char	dram_rank_config;
	//support Dram connection type should confirm with amlogic
	//#define CONFIG_DDR0_16BIT_CH0				0x1  //dram total bus width 16bit only use cs0
	//#define CONFIG_DDR0_16BIT_RANK01_CH0		0x4  //dram total bus width 16bit  use cs0 cs1
	//#define CONFIG_DDR0_32BIT_RANK0_CH0			0x2  //dram total bus width 32bit  use cs0
	//#define CONFIG_DDR0_32BIT_RANK01_CH01		0x3    //only for lpddr4,dram total bus width 32bit  use chanel a cs0 cs1 chanel b cs0 cs1
	//#define CONFIG_DDR0_32BIT_16BIT_RANK0_CH0		0x5    //dram total bus width 32bit only use cs0,but high address use 16bit mode
	//#define CONFIG_DDR0_32BIT_16BIT_RANK01_CH0	0x6   //dram total bus width 32bit  use cs0 cs1,but cs1 use 16bit mode ,current phy not support reserve
	//#define CONFIG_DDR0_32BIT_RANK01_CH0		0x7       //dram total bus width 32bit  use cs0 cs1
	//#define CONFIG_DDR0_32BIT_RANK0_CH01		0x8     //only for lpddr4,dram total bus width 32bit  use chanel a cs0  chanel b cs0

	/* rsv_char0. update for diagnose type define */
	unsigned	char	diagnose;

	/* imem/dmem define */
	unsigned	int		imem_load_addr;
	//system reserve,do not modify
	unsigned	int		dmem_load_addr;
	//system reserve,do not modify
	unsigned	short	imem_load_size;
	//system reserve,do not modify
	unsigned	short	dmem_load_size;
	//system reserve,do not modify
	unsigned	int		ddr_base_addr;
	//system reserve,do not modify
	unsigned	int		ddr_start_offset;
	//system reserve,do not modify

	unsigned	short	dram_cs0_size_MB;
	//config cs0 dram size ,like 1G DRAM ,setting 1024
	unsigned	short	dram_cs1_size_MB;
	//config cs1 dram size,like 512M DRAM ,setting 512
	/* align8 */

	unsigned	short	training_SequenceCtrl[2];
	//system reserve,do not modify
	unsigned	char	phy_odt_config_rank[4];
	//training odt config ,only use for training
	// [0]Odt pattern for accesses targeting rank 0. [3:0] is used for write ODT [7:4] is used for read ODT
	// [1]Odt pattern for accesses targeting rank 1. [3:0] is used for write ODT [7:4] is used for read ODT
	unsigned	int		dfi_odt_config;
	//normal go status od config,use for normal status
	//bit 12.  rank1 ODT default. default vulue for ODT[1] pins if theres no read/write activity.
	//bit 11.  rank1 ODT write sel.  enable ODT[1] if there's write occur in rank1.
	//bit 10.  rank1 ODT write nsel. enable ODT[1] if theres's write occur in rank0.
	//bit 9.   rank1 odt read sel.   enable ODT[1] if there's read occur in rank1.
	//bit 8.   rank1 odt read nsel.  enable ODT[1] if there's read occure in rank0.
	//bit 4.   rank0 ODT default.    default vulue for ODT[0] pins if theres no read/write activity.
	//bit 3.   rank0 ODT write sel.  enable ODT[0] if there's write occur in rank0.
	//bit 2.   rank0 ODT write nsel. enable ODT[0] if theres's write occur in rank1.
	//bit 1.   rank0 odt read sel.   enable ODT[0] if there's read occur in rank0.
	//bit 0.   rank0 odt read nsel.  enable ODT[0] if there's read occure in rank1.
	unsigned	short	DRAMFreq[4];
	//config dram frequency,use DRAMFreq[0],ohter reserve
	unsigned	char	PllBypassEn;
	//system reserve,do not modify
	unsigned	char	ddr_rdbi_wr_enable;
	//system reserve,do not modify
	unsigned	char	ddr_rfc_type;
	//config dram rfc type,according dram type,also can use same dram type max config
	//#define DDR_RFC_TYPE_DDR3_512Mbx1				0
	//#define DDR_RFC_TYPE_DDR3_512Mbx2				1
	//#define DDR_RFC_TYPE_DDR3_512Mbx4				2
	//#define DDR_RFC_TYPE_DDR3_512Mbx8				3
	//#define DDR_RFC_TYPE_DDR3_512Mbx16				4
	//#define DDR_RFC_TYPE_DDR4_2Gbx1					5
	//#define DDR_RFC_TYPE_DDR4_2Gbx2					6
	//#define DDR_RFC_TYPE_DDR4_2Gbx4					7
	//#define DDR_RFC_TYPE_DDR4_2Gbx8					8
	//#define DDR_RFC_TYPE_LPDDR4_2Gbx1				9
	//#define DDR_RFC_TYPE_LPDDR4_3Gbx1				10
	//#define DDR_RFC_TYPE_LPDDR4_4Gbx1				11
	unsigned	char	enable_lpddr4x_mode;
	//system reserve,do not modify
	/* align8 */

	unsigned	int		pll_ssc_mode;
	//
	/* pll ssc config:
	 *
	 *   pll_ssc_mode = (1<<20) | (1<<8) | ([strength] << 4) | [mode],
	 *      ppm = strength * 500
	 *      mode: 0=center, 1=up, 2=down
	 *
	 *   eg:
	 *     1. config 1000ppm center ss. then mode=0, strength=2
	 *        .pll_ssc_mode = (1<<20) | (1<<8) | (2 << 4) | 0,
	 *     2. config 3000ppm down ss. then mode=2, strength=6
	 *        .pll_ssc_mode = (1<<20) | (1<<8) | (6 << 4) | 2,
	 */
	unsigned	short	clk_drv_ohm;
	//config soc clk pin signal driver stength ,select 20,30,40,60ohm
	unsigned	short	cs_drv_ohm;
	//config soc cs0 cs1 pin signal driver stength ,select 20,30,40,60ohm
	unsigned	short	ac_drv_ohm;
	//config soc  normal address command pin driver stength ,select 20,30,40,60ohm
	unsigned	short	soc_data_drv_ohm_p;
	//config soc data pin pull up driver stength,select 0,28,30,32,34,37,40,43,48,53,60,68,80,96,120ohm
	unsigned	short	soc_data_drv_ohm_n;
	//config soc data pin pull down driver stength,select 0,28,30,32,34,37,40,43,48,53,60,68,80,96,120ohm
	unsigned	short	soc_data_odt_ohm_p;
	//config soc data pin odt pull up stength,select 0,28,30,32,34,37,40,43,48,53,60,68,80,96,120ohm
	unsigned	short	soc_data_odt_ohm_n;
	//config soc data pin odt pull down stength,select 0,28,30,32,34,37,40,43,48,53,60,68,80,96,120ohm
	unsigned	short	dram_data_drv_ohm;
	//config dram data pin pull up pull down driver stength,ddr3 select 34,40ohm,ddr4 select 34,48ohm,lpddr4 select 40,48,60,80,120,240ohm
	unsigned	short	dram_data_odt_ohm;
	//config dram data pin odt pull up down stength,ddr3 select 40,60,120ohm,ddr4 select 34,40,48,60,120,240ohm,lpddr4 select 40,48,60,80,120,240ohm
	unsigned	short	dram_ac_odt_ohm;
	//config dram ac pin odt pull up down stength,use for lpddr4, select 40,48,60,80,120,240ohm
	unsigned	short	soc_clk_slew_rate;
	//system reserve,do not modify
	unsigned	short	soc_cs_slew_rate;
	//system reserve,do not modify
	unsigned	short	soc_ac_slew_rate;
	//system reserve,do not modify
	unsigned	short	soc_data_slew_rate;
	//system reserve,do not modify
	unsigned	short	vref_output_permil; //phy
	//setting same with vref_dram_permil
	unsigned	short	vref_receiver_permil; //soc
	//soc init SOC receiver vref ,config like 500 means 0.5VDDQ,take care ,please follow SI
	unsigned	short	vref_dram_permil;
	//soc init DRAM receiver vref ,config like 500 means 0.5VDDQ,take care ,please follow SI
	unsigned	short	max_core_timmming_frequency;
	//use for limited ddr speed core timmming parameter,for some old dram maybe have no over speed register

	unsigned	char	ac_trace_delay[10];
	unsigned	char	lpddr4_dram_vout_voltage_1_3_2_5_setting;
	//use for lpddr4 read vout voltage  setting 0 --->2/5VDDQ ,1--->1/3VDDQ
	unsigned	char	lpddr4_x8_mode;
	//system reserve,do not modify ,take care ,please follow SI
	unsigned	char	ac_pinmux[DWC_AC_PINMUX_TOTAL];
	//use for lpddr3 /lpddr4 ca pinmux remap
	unsigned	char	dfi_pinmux[DWC_DFI_PINMUX_TOTAL];
	unsigned	char	slt_test_function[2];  //[0] slt test function enable,bit 0 enable 4 frequency scan,bit 1 enable force delay line offset ,[1],slt test parameter ,use for force delay line offset
		//system reserve,do not modify
	unsigned	short	dq_bdlr_org;
	unsigned	char  dram_data_wr_odt_ohm;
	unsigned	char	bitTimeControl_2d;
	//system reserve,do not modify
	/* align8 */

	unsigned	int		ddr_dmc_remap[5];
	//system reserve,do not modify
	/* align8 */
	unsigned char		ddr_lpddr34_ca_remap[4];
	////use for lpddr3 /lpddr4 ca training data byte lane remap
	unsigned	char	ddr_lpddr34_dq_remap[32];
	////use for lpddr3 /lpddr4 ca pinmux remap
	unsigned	int		dram_rtt_nom_wr_park[2];
	//system reserve,do not modify
	unsigned	int		ddr_func;
	//system reserve,do not modify
	/* align8 */

	unsigned	long	rsv_long0[2];
	/* v1 end */
	//unsigned	char	read_dqs_adjust[16]; //rank 0 --lane 0 1 2 3  rank 1--4 5 6 7 write  //rank 0 --lane 0 1 2 3  rank 1--4 5 6 7 read
	//unsigned	char	read_dq_bit_delay[72];
	//unsigned	char	write_dq_bit_delay[72];

///*
	unsigned	char	read_dqs_delay[16];
	unsigned	char	read_dq_bit_delay[72];
	unsigned	short	write_dqs_delay[16];
//*/
	unsigned	short	write_dq_bit_delay[72];
	unsigned	short	read_dqs_gate_delay[16];
//		/*
	unsigned	char	dq_dqs_delay_flag; //read_dqs  read_dq,write_dqs, write_dq
	unsigned	char	dfi_mrl;
	unsigned	char	dfi_hwtmrl;
	unsigned	char	ARdPtrInitVal;
//	*/
	//override read bit delay
}__attribute__ ((packed)) ddr_set_t;

typedef struct ddr_timing{
	//Identifier
	unsigned char  identifier;

	//DTPR0
	unsigned char  cfg_ddr_rtp;
	unsigned char  cfg_ddr_wtr;
	unsigned char  cfg_ddr_rp;
	unsigned char  cfg_ddr_rcd;
	unsigned char  cfg_ddr_ras;
	unsigned char  cfg_ddr_rrd;
	unsigned char  cfg_ddr_rc;

	//DTPR1
	unsigned char  cfg_ddr_mrd;
	unsigned char  cfg_ddr_mod;
	unsigned char  cfg_ddr_faw;
	unsigned char  cfg_ddr_wlmrd;
	unsigned char  cfg_ddr_wlo;

	//DTPR2
	unsigned char  cfg_ddr_xp;

	//DTPR1
	unsigned short cfg_ddr_rfc;

	//DTPR2
	unsigned short cfg_ddr_xs;
	unsigned short cfg_ddr_dllk;
	unsigned char  cfg_ddr_cke;
	unsigned char  cfg_ddr_rtodt;
	unsigned char  cfg_ddr_rtw;

	unsigned char  cfg_ddr_refi;
	unsigned char  cfg_ddr_refi_mddr3;
	unsigned char  cfg_ddr_cl;
	unsigned char  cfg_ddr_wr;
	unsigned char  cfg_ddr_cwl;
	unsigned char  cfg_ddr_al;
	unsigned char  cfg_ddr_dqs;
	unsigned char  cfg_ddr_cksre;
	unsigned char  cfg_ddr_cksrx;
	unsigned char  cfg_ddr_zqcs;
	unsigned char  cfg_ddr_xpdll;
	unsigned short cfg_ddr_exsr;
	unsigned short cfg_ddr_zqcl;
	unsigned short cfg_ddr_zqcsi;

	unsigned char  cfg_ddr_tccdl;
	unsigned char  cfg_ddr_tdqsck;
	unsigned char  cfg_ddr_tdqsckmax;
	unsigned char  rsv_char;

	/* reserved */
	unsigned int   rsv_int;
}__attribute__ ((packed)) ddr_timing_t;

typedef struct pll_set{
	unsigned short    cpu_clk;
	unsigned short    pxp;
	unsigned int      spi_ctrl;
	unsigned short    vddee;
	unsigned short    vcck;
	unsigned char     szPad[4];

	unsigned long     lCustomerID;
	unsigned short    debug_mode;
	unsigned short    rsv1;
	unsigned int      nCFGTAddr;
	/* align 8Byte */

	unsigned int      sys_pll_cntl[8];
	unsigned int      ddr_pll_cntl[8];
	unsigned int      fix_pll_cntl[8];
}__attribute__ ((packed)) pll_set_t;

typedef struct dmem_cfg {
	PMU_SMB_DDR3U_1D_t ddr3u;
	PMU_SMB_DDR4U_1D_t ddr4u;
	PMU_SMB_DDR4U_2D_t ddr4u_2d;
	PMU_SMB_LPDDR3_1D_t lpddr3u;
	PMU_SMB_LPDDR4_1D_t lpddr4u;
	PMU_SMB_LPDDR4_2D_t lpddr4u_2d;
} dmem_cfg_t;

#endif //__AML_TIMING_H_