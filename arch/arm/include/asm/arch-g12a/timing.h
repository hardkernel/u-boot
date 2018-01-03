
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

typedef struct ddr_set{ //total 34 short
	unsigned	char	board_id;
	unsigned	char	version;
	unsigned	char	DramType;
	unsigned	char	DisabledDbyte;
	unsigned	char	Is2Ttiming;
	unsigned	char	HdtCtrl;
	unsigned	char	dram_rank_config;
	unsigned	char	rsv_char0;
	/* imem/dmem define */
	unsigned	int		imem_load_addr;
	unsigned	int		dmem_load_addr;
	unsigned	short	imem_load_size;
	unsigned	short	dmem_load_size;
	unsigned	int		ddr_base_addr;
	unsigned	int		ddr_start_offset;

	unsigned	short	dram_cs0_size_MB;
	unsigned	short	dram_cs1_size_MB;
	/* align8 */

	unsigned	short	training_SequenceCtrl[2];
	unsigned	char	phy_odt_config_rank[4];
	unsigned	int		dfi_odt_config;
	unsigned	short	DRAMFreq[4];
	unsigned	char	PllBypassEn;
	unsigned	char	ddr_rdbi_wr_enable;
	unsigned	char	ddr_rfc_type;
	unsigned	char	reverse_3;
	/* align8 */

	unsigned	int		pll_ssc_mode;
	unsigned	short	clk_drv_ohm;
	unsigned	short	cs_drv_ohm;
	unsigned	short	ac_drv_ohm;
	unsigned	short	soc_data_drv_ohm_p;
	unsigned	short	soc_data_drv_ohm_n;
	unsigned	short	soc_data_odt_ohm_p;
	unsigned	short	soc_data_odt_ohm_n;
	unsigned	short	dram_data_drv_ohm;
	unsigned	short	dram_data_odt_ohm;
	unsigned	short	dram_ac_odt_ohm;

	unsigned	short	soc_clk_slew_rate;
	unsigned	short	soc_cs_slew_rate;
	unsigned	short	soc_ac_slew_rate;
	unsigned	short	soc_data_slew_rate;
	unsigned	short	vref_output_permil; //phy
	unsigned	short	vref_receiver_permil; //soc

	unsigned	short	vref_dram_permil;
	unsigned	short	vref_reverse;
	/* align8 */

	unsigned	char	ac_trace_delay[12];
	unsigned	char	ac_pinmux[DWC_AC_PINMUX_TOTAL];
	unsigned	char	dfi_pinmux[DWC_DFI_PINMUX_TOTAL];
	unsigned	char	rsv_char1[6];
	/* align8 */

	unsigned	int		ddr_dmc_remap[5];
	unsigned	char	ddr_lpddr34_ca_remap[4];
	/* align8 */

	unsigned	char	ddr_lpddr34_dq_remap[16];
	unsigned	int		dram_rtt_nom_wr_park[2];
	unsigned	int		ddr_func;
	/* align8 */

	/* v1 end */

	/* v2 start */

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
	unsigned short    rsv2;
	unsigned short    rsv3;
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