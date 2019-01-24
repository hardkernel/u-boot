
/*
 * board/amlogic/txl_skt_v1/firmware/timing.c
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

#include <asm/arch/secure_apb.h>
#include <asm/arch/timing.h>
#include <asm/arch/ddr_define.h>



/* ddr config support multiple configs for boards which use same bootloader:
 * config steps:
 * 1. add a new data struct in __ddr_setting[]
 * 2. config correct board_id, ddr_type, freq, etc..
 */


/* CAUTION!! */
/* Confirm ddr configs with hardware designer,
 * if you don't know how to config, then don't edit it
 */

/* Key configs */
/*
 * board_id: check hardware adc config
 * dram_rank_config:
 *            #define CONFIG_DDR_CHL_AUTO					0xF
 *            #define CONFIG_DDR0_16BIT_CH0					0x1
 *            #define CONFIG_DDR0_16BIT_RANK01_CH0			0x4
 *            #define CONFIG_DDR0_32BIT_RANK0_CH0			0x2
 *            #define CONFIG_DDR0_32BIT_RANK01_CH01			0x3
 *            #define CONFIG_DDR0_32BIT_16BIT_RANK0_CH0		0x5
 *            #define CONFIG_DDR0_32BIT_16BIT_RANK01_CH0	0x6
 * DramType:
 *            #define CONFIG_DDR_TYPE_DDR3					0
 *            #define CONFIG_DDR_TYPE_DDR4					1
 *            #define CONFIG_DDR_TYPE_LPDDR4				2
 *            #define CONFIG_DDR_TYPE_LPDDR3				3
 * DRAMFreq:
 *            {pstate0, pstate1, pstate2, pstate3} //more than one pstate means use dynamic freq
 *
 */

ddr_set_t __ddr_setting[] = {
{
	/* ddr4 */
	.board_id				= CONFIG_BOARD_ID_MASK,
	.version				= 1,
	.dram_rank_config		= CONFIG_DDR0_32BIT_RANK0_CH0,
	.DramType				= CONFIG_DDR_TYPE_DDR4,
	.DRAMFreq				= {1200, 0, 0, 0},
	.ddr_rfc_type			= DDR_RFC_TYPE_DDR4_2Gbx8,
	.ddr_base_addr			= CFG_DDR_BASE_ADDR,
	.ddr_start_offset		= CFG_DDR_START_OFFSET,
	.imem_load_addr			= 0xFFFC0000, //sram
	.dmem_load_size			= 0x1000, //4K

	.DisabledDbyte			= 0xf0,
	.Is2Ttiming				= 1,
	.HdtCtrl				= 0xC8,
	.dram_cs0_size_MB		= 0xffff,
	.dram_cs1_size_MB		= 0,
	.training_SequenceCtrl	= {0x31f,0x61}, //ddr3 0x21f 0x31f
	.phy_odt_config_rank	= {0x30,0x30,0x30,0x30}, // // Odt pattern for accesses //targeting rank 0. [3:0] is used //for write ODT [7:4] is used for //read ODT
	.dfi_odt_config			= 0x0808,
	.PllBypassEn			= 0, //bit0-ps0,bit1-ps1
	.ddr_rdbi_wr_enable		= 0,
	.clk_drv_ohm			= 40,
	.cs_drv_ohm				= 40,
	.ac_drv_ohm				= 40,
	.soc_data_drv_ohm_p		= 40,
	.soc_data_drv_ohm_n		= 40,
	.soc_data_odt_ohm_p		= 60,
	.soc_data_odt_ohm_n		= 0,
	.dram_data_drv_ohm		= 34,//48, //34, //ddr4 sdram only 34 or 48, skt board use 34 better
	.dram_data_odt_ohm		= 60, //60,
	.dram_ac_odt_ohm		= 0,
	.soc_clk_slew_rate		= 0x3ff,
	.soc_cs_slew_rate		= 0x3ff,
	.soc_ac_slew_rate		= 0x3ff,
	.soc_data_slew_rate		= 0x2ff,
	.vref_output_permil		= 500,
	.vref_receiver_permil	= 0,//700,
	.vref_dram_permil		= 0,//700,
	//.vref_reverse			= 0,
	//.ac_trace_delay		= {0x0,0x0},// {0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40},
	.ac_trace_delay			= {32,32,32,32,32,32,32,32,32,32},
	.ddr_dmc_remap			= {
							[0] = ( 5 |  7 << 5 |  8 << 10 |  9 << 15 | 10 << 20 | 11 << 25 ),
							[1] = ( 12|  0 << 5 |  0 << 10 | 14 << 15 | 15 << 20 | 16 << 25 ),
							[2] = ( 17| 18 << 5 | 19 << 10 | 21 << 15 | 22 << 20 | 23 << 25 ),
							[3] = ( 24| 25 << 5 | 26 << 10 | 27 << 15 | 28 << 20 | 29 << 25 ),
							[4] = ( 30| 13 << 5 | 20 << 10 |  6 << 15 |  0 << 20 |  0 << 25 ),
	},
	.ddr_lpddr34_ca_remap	= {00,00},
	.ddr_lpddr34_dq_remap	= {00,00},
	.dram_rtt_nom_wr_park	= {00,00},

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
	.pll_ssc_mode			= (1<<20) | (1<<8) | (2<<4) | 0,//center_ssc_1000ppm
	.ddr_func				= DDR_FUNC,
	.magic					= DRAM_CFG_MAGIC,
	.bitTimeControl_2d		= 1,
},
{
	/* ddr3 */
	.board_id				= CONFIG_BOARD_ID_MASK,
	.version				= 1,
	.dram_rank_config		= CONFIG_DDR0_32BIT_RANK01_CH0,
	.DramType				= CONFIG_DDR_TYPE_DDR3,
	.DRAMFreq				= {912, 0, 0, 0},
	.ddr_base_addr			= CFG_DDR_BASE_ADDR,
	.ddr_start_offset		= CFG_DDR_START_OFFSET,
	.imem_load_addr			= 0xFFFC0000, //sram
	.dmem_load_size			= 0x1000, //4K

	.DisabledDbyte			= 0xf0,
	.Is2Ttiming				= 1,
	.HdtCtrl				= 0xC8,
	.dram_cs0_size_MB		= 0xffff,
	.dram_cs1_size_MB		= 0xffff,
	.training_SequenceCtrl	= {0x31f,0}, //ddr3 0x21f 0x31f
	.phy_odt_config_rank	= {0x30,0x30,0x30,0x30}, // // Odt pattern for accesses //targeting rank 0. [3:0] is used //for write ODT [7:4] is used for //read ODT
	.dfi_odt_config			= 0x0c0c,
	.PllBypassEn			= 0, //bit0-ps0,bit1-ps1
	.ddr_rdbi_wr_enable		= 0,
	.clk_drv_ohm			= 40,
	.cs_drv_ohm				= 40,
	.ac_drv_ohm				= 40,
	.soc_data_drv_ohm_p		= 34,
	.soc_data_drv_ohm_n		= 34,
	.soc_data_odt_ohm_p		= 60, //48,
	.soc_data_odt_ohm_n		= 0,
	.dram_data_drv_ohm		= 34, //ddr4 sdram only 34 or 48, skt board use 34 better
	.dram_data_odt_ohm		= 60,
	.dram_ac_odt_ohm		= 0,
	.soc_clk_slew_rate		= 0x300,
	.soc_cs_slew_rate		= 0x300,
	.soc_ac_slew_rate		= 0x300,
	.soc_data_slew_rate		= 0x200,
	.vref_output_permil		= 500,
	.vref_receiver_permil	= 500, //700,
	.vref_dram_permil		= 500, //700,
	//.vref_reverse			= 0,
	.ac_trace_delay			= {32,32,32,32,32,32,32,32,32,32},
	//{00,00},
	.ac_pinmux				= {00,00},
#if 1
	.ddr_dmc_remap			= {
							[0] = ( 5 |  7 << 5 |  8 << 10 |  9 << 15 | 10 << 20 | 11 << 25 ),
							[1] = ( 12|  0 << 5 |  0 << 10 | 14 << 15 | 15 << 20 | 16 << 25 ),
							[2] = ( 17| 18 << 5 | 19 << 10 | 21 << 15 | 22 << 20 | 23 << 25 ),
							[3] = ( 24| 25 << 5 | 26 << 10 | 27 << 15 | 28 << 20 | 29 << 25 ),
							[4] = ( 30| 13 << 5 | 20 << 10 |  6 << 15 |  0 << 20 |  0 << 25 ),
	},
#else
	//16bit
	.ddr_dmc_remap			= {
							[0] = ( 0 |  5 << 5 |  6<< 10 |  7 << 15 | 8 << 20 | 9 << 25 ),
							[1] = ( 10|  0 << 5 |  0 << 10 | 14 << 15 | 15 << 20 | 16 << 25 ),
							[2] = ( 17|( 18 << 5) |( 19 << 10) |( 20 << 15) |( 21 << 20) | (22 << 25 )),
							[3] = ( 23| 24 << 5 | 25 << 10 | 26 << 15 | 27 << 20 | 28 << 25 ),
							[4] = ( 29| 11<< 5 | 12 << 10 |  13<< 15 |  0 << 20 |  0 << 25 ),
	},
#endif
	.ddr_lpddr34_ca_remap	= {00,00},
	.ddr_lpddr34_dq_remap	= {00,00},
	.dram_rtt_nom_wr_park	= {00,00},

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
	.pll_ssc_mode			= (1<<20) | (1<<8) | (2<<4) | 0,//center_ssc_1000ppm
	.ddr_func				= DDR_FUNC,
	.magic					= DRAM_CFG_MAGIC,
	.bitTimeControl_2d      = 1
},
{
	/* lpddr4 */
	.board_id				= CONFIG_BOARD_ID_MASK,
	.version				= 1,
	//.dram_rank_config		= CONFIG_DDR0_32BIT_RANK01_CH0,
	.dram_rank_config		= CONFIG_DDR0_32BIT_RANK01_CH01,
	.ddr_rfc_type			= DDR_RFC_TYPE_LPDDR4_8Gbx1,
	.DramType				= CONFIG_DDR_TYPE_LPDDR4,
	.DRAMFreq				= {1392, 0, 0, 0},
	.ddr_base_addr			= CFG_DDR_BASE_ADDR,
	.ddr_start_offset		= CFG_DDR_START_OFFSET,
	.imem_load_addr			= 0xFFFC0000, //sram
	.dmem_load_size			= 0x1000, //4K

	.DisabledDbyte			= 0xf0,
	.Is2Ttiming				= 0,
	.HdtCtrl				= 0xa,
	.dram_cs0_size_MB		= 0xffff,//1024,
	.dram_cs1_size_MB		= 0xffff,//1024,
	.training_SequenceCtrl	= {0x131f,0x61}, //ddr3 0x21f 0x31f
	.phy_odt_config_rank	= {0x30,0x30,0x30,0x30}, // // Odt pattern for accesses //targeting rank 0. [3:0] is used //for write ODT [7:4] is used for //read ODT
	.dfi_odt_config			= 0x0808,
	.PllBypassEn			= 0, //bit0-ps0,bit1-ps1
	.ddr_rdbi_wr_enable		= 0,
	.clk_drv_ohm			= 40,
	.cs_drv_ohm				= 40,
	.ac_drv_ohm				= 40,
	.soc_data_drv_ohm_p		= 40,
	.soc_data_drv_ohm_n		= 40,
	.soc_data_odt_ohm_p		= 0,
	.soc_data_odt_ohm_n		= 120,
	.dram_data_drv_ohm		= 40, //lpddr4 sdram only240/1-6
	.dram_data_odt_ohm		= 120,
	.dram_ac_odt_ohm		= 120,
	.lpddr4_dram_vout_voltage_1_3_2_5_setting = 1,///1, 1/3vddq     0 2/5 vddq
	.soc_clk_slew_rate		= 0x3ff,//0x253,
	.soc_cs_slew_rate		= 0x100,//0x253,
	.soc_ac_slew_rate		= 0x100,//0x253,
	.soc_data_slew_rate		= 0x1ff,
	.vref_output_permil		= 350,//200,
	.vref_receiver_permil	= 0,
	.vref_dram_permil		= 0,
	//.vref_reverse			= 0,
	.ac_trace_delay			= {00,0x0,0,0,0,0,0x0,00},
	//.ac_trace_delay		= {32,32,32,32,32,32,32,32,32,32},
	.ac_pinmux				= {00,00},
	.ddr_dmc_remap			= {
							[0] = ( 5 |  6 << 5 |  7 << 10 |  8<< 15 | 9<< 20 | 10 << 25 ),
							[1] = ( 11|  0 << 5 |  0 << 10 | 15 << 15 | 16 << 20 | 17 << 25 ),
							[2] = ( 18| 19 << 5 | 20 << 10 | 21 << 15 | 22 << 20 | 23 << 25 ),
							[3] = ( 24| 25 << 5 | 26 << 10 | 27 << 15 | 28 << 20 | 29 << 25 ),
							[4] = ( 30| 12 << 5 | 13 << 10 |  14<< 15 |  0 << 20 |  0 << 25 ),
	},
	.ddr_lpddr34_ca_remap	= {00,00},
	.ddr_lpddr34_dq_remap	= {3,2,0,1,7,6,5,4, 10,9,14,11,8,12,13,15, 20,21,23,22,18,17,19,16, 28,26,25,24,31,30,27,29},
	.dram_rtt_nom_wr_park	= {00,00},
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
	.pll_ssc_mode			= (1<<20) | (1<<8) | (2<<4) | 0,//center_ssc_1000ppm
	.ddr_func				= DDR_FUNC,
	.magic					= DRAM_CFG_MAGIC,
	.diagnose				= CONFIG_DIAGNOSE_DISABLE,
	.bitTimeControl_2d      = 1
},
{
	/* Y2 dongle */
	.board_id				= CONFIG_BOARD_ID_MASK,
	.version				= 1,
	//.dram_rank_config		= CONFIG_DDR0_32BIT_RANK01_CH0,
	.dram_rank_config		= CONFIG_DDR0_32BIT_RANK0_CH01,
	.ddr_rfc_type			= DDR_RFC_TYPE_LPDDR4_8Gbx1,
	.DramType				= CONFIG_DDR_TYPE_LPDDR4,
	.DRAMFreq				= {1392, 0, 0, 0},
	.ddr_base_addr			= CFG_DDR_BASE_ADDR,
	.ddr_start_offset		= CFG_DDR_START_OFFSET,
	.imem_load_addr			= 0xFFFC0000, //sram
	.dmem_load_size			= 0x1000, //4K

	.DisabledDbyte			= 0xf0,
	.Is2Ttiming				= 0,
	.HdtCtrl				= 0xa,
	.dram_cs0_size_MB		= 0xffff,//1024,
	.dram_cs1_size_MB		= 0,//1024,
	.training_SequenceCtrl	= {0x131f,0x61}, //ddr3 0x21f 0x31f
	.phy_odt_config_rank	= {0x30,0x30,0x30,0x30}, // // Odt pattern for accesses //targeting rank 0. [3:0] is used //for write ODT [7:4] is used for //read ODT
	.dfi_odt_config			= 0x0808,
	.PllBypassEn			= 0, //bit0-ps0,bit1-ps1
	.ddr_rdbi_wr_enable		= 0,
	.clk_drv_ohm			= 40,
	.cs_drv_ohm				= 40,
	.ac_drv_ohm				= 40,
	.soc_data_drv_ohm_p		= 40,
	.soc_data_drv_ohm_n		= 40,
	.soc_data_odt_ohm_p		= 0,
	.soc_data_odt_ohm_n		= 120,
	.dram_data_drv_ohm		= 40, //lpddr4 sdram only240/1-6
	.dram_data_odt_ohm		= 120,
	.dram_ac_odt_ohm		= 120,
	.lpddr4_dram_vout_voltage_1_3_2_5_setting = 1,///1, 1/3vddq     0 2/5 vddq
	.soc_clk_slew_rate		= 0x3ff,//0x253,
	.soc_cs_slew_rate		= 0x100,//0x253,
	.soc_ac_slew_rate		= 0x100,//0x253,
	.soc_data_slew_rate		= 0x1ff,
	.vref_output_permil		= 350,//200,
	.vref_receiver_permil	= 0,
	.vref_dram_permil		= 0,
	//.vref_reverse			= 0,
	.ac_trace_delay			= {00,0x0,0,0,0,0,0x0,00},
	.ac_pinmux				= {00,00},
	.ddr_dmc_remap			= {
							[0] = ( 5 |  6 << 5 |  7 << 10 |  8<< 15 | 9<< 20 | 10 << 25 ),
							[1] = ( 11|  0 << 5 |  0 << 10 | 15 << 15 | 16 << 20 | 17 << 25 ),
							[2] = ( 18| 19 << 5 | 20 << 10 | 21 << 15 | 22 << 20 | 23 << 25 ),
							[3] = ( 24| 25 << 5 | 26 << 10 | 27 << 15 | 28 << 20 | 29 << 25 ),
							[4] = ( 30| 12 << 5 | 13 << 10 |  14<< 15 |  0 << 20 |  0 << 25 ),
	},
	.ddr_lpddr34_ca_remap	= {00,00},
	.ddr_lpddr34_dq_remap	= {3,2,0,1,7,6,5,4, 10,9,14,11,8,12,13,15, 20,21,23,22,18,17,19,16, 28,26,25,24,31,30,27,29},
	.dram_rtt_nom_wr_park	= {00,00},
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
	.pll_ssc_mode			= (1<<20) | (1<<8) | (2<<4) | 0,//center_ssc_1000ppm
	.ddr_func				= DDR_FUNC,
	.magic					= DRAM_CFG_MAGIC,
	.bitTimeControl_2d      = 1
},
};

pll_set_t __pll_setting = {
	.cpu_clk				= CONFIG_CPU_CLK / 24 * 24,
#ifdef CONFIG_PXP_EMULATOR
	.pxp					= 1,
#else
	.pxp					= 0,
#endif
	.spi_ctrl				= 0,
	.lCustomerID			= CONFIG_AML_CUSTOMER_ID,
#ifdef CONFIG_DEBUG_MODE
	.debug_mode				= CONFIG_DEBUG_MODE,
	.ddr_clk_debug			= CONFIG_DDR_CLK_DEBUG,
	.cpu_clk_debug			= CONFIG_CPU_CLK_DEBUG,
#endif
};

ddr_reg_t __ddr_reg[] = {
	/* demo, user defined override register */
	{0xaabbccdd, 0, 0, 0, 0, 0},
	{0x11223344, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
};

#define VCCK_VAL				CONFIG_VCCK_INIT_VOLTAGE
#define VDDEE_VAL				CONFIG_VDDEE_INIT_VOLTAGE
/* VCCK PWM table */
#if   (VCCK_VAL == 800)
	#define VCCK_VAL_REG	0x00150007
#elif (VCCK_VAL == 810)
	#define VCCK_VAL_REG	0x00140008
#elif (VCCK_VAL == 820)
	#define VCCK_VAL_REG	0x00130009
#elif (VCCK_VAL == 830)
	#define VCCK_VAL_REG	0x0012000a
#elif (VCCK_VAL == 840)
	#define VCCK_VAL_REG	0x0011000b
#elif (VCCK_VAL == 850)
	#define VCCK_VAL_REG	0x0010000c
#elif (VCCK_VAL == 860)
	#define VCCK_VAL_REG	0x000f000d
#elif (VCCK_VAL == 870)
	#define VCCK_VAL_REG	0x000e000e
#elif (VCCK_VAL == 880)
	#define VCCK_VAL_REG	0x000d000f
#elif (VCCK_VAL == 890)
	#define VCCK_VAL_REG	0x000c0010
#elif (VCCK_VAL == 900)
	#define VCCK_VAL_REG	0x000b0011
#elif (VCCK_VAL == 910)
	#define VCCK_VAL_REG	0x000a0012
#elif (VCCK_VAL == 920)
	#define VCCK_VAL_REG	0x00090013
#elif (VCCK_VAL == 930)
	#define VCCK_VAL_REG	0x00080014
#elif (VCCK_VAL == 940)
	#define VCCK_VAL_REG	0x00070015
#elif (VCCK_VAL == 950)
	#define VCCK_VAL_REG	0x00060016
#elif (VCCK_VAL == 960)
	#define VCCK_VAL_REG	0x00050017
#elif (VCCK_VAL == 970)
	#define VCCK_VAL_REG	0x00040018
#elif (VCCK_VAL == 980)
	#define VCCK_VAL_REG	0x00030019
#elif (VCCK_VAL == 990)
	#define VCCK_VAL_REG	0x0002001a
#elif (VCCK_VAL == 1000)
	#define VCCK_VAL_REG	0x0001001b
#elif (VCCK_VAL == 1010)
	#define VCCK_VAL_REG	0x0000001c
#else
	#error "VCCK val out of range\n"
#endif

/* VDDEE PWM table */
#if (VDDEE_VAL == 680)
	#define VDDEE_VAL_REG	0x001c0000
#elif (VDDEE_VAL == 690)
	#define VDDEE_VAL_REG	0x001b0001
#elif (VDDEE_VAL == 700)
	#define VDDEE_VAL_REG	0x001a0002
#elif (VDDEE_VAL == 710)
	#define VDDEE_VAL_REG	0x00190003
#elif (VDDEE_VAL == 720)
	#define VDDEE_VAL_REG	0x00180004
#elif (VDDEE_VAL == 730)
	#define VDDEE_VAL_REG	0x00170005
#elif (VDDEE_VAL == 740)
	#define VDDEE_VAL_REG	0x00160006
#elif (VDDEE_VAL == 750)
	#define VDDEE_VAL_REG	0x00150007
#elif (VDDEE_VAL == 760)
	#define VDDEE_VAL_REG	0x00140008
#elif (VDDEE_VAL == 770)
	#define VDDEE_VAL_REG	0x00130009
#elif (VDDEE_VAL == 780)
	#define VDDEE_VAL_REG	0x0012000a
#elif (VDDEE_VAL == 790)
	#define VDDEE_VAL_REG	0x0011000b
#elif    (VDDEE_VAL == 800)
	#define VDDEE_VAL_REG	0x0010000c
#elif (VDDEE_VAL == 810)
	#define VDDEE_VAL_REG	0x000f000d
#elif (VDDEE_VAL == 820)
	#define VDDEE_VAL_REG	0x000e000e
#elif (VDDEE_VAL == 830)
	#define VDDEE_VAL_REG	0x000d000f
#elif (VDDEE_VAL == 840)
	#define VDDEE_VAL_REG	0x000c0010
#elif (VDDEE_VAL == 850)
	#define VDDEE_VAL_REG	0x000b0011
#elif (VDDEE_VAL == 860)
	#define VDDEE_VAL_REG	0x000a0012
#elif (VDDEE_VAL == 870)
	#define VDDEE_VAL_REG	0x00090013
#elif (VDDEE_VAL == 880)
	#define VDDEE_VAL_REG	0x00080014
#elif (VDDEE_VAL == 890)
	#define VDDEE_VAL_REG	0x00070015
#elif (VDDEE_VAL == 900)
	#define VDDEE_VAL_REG	0x00060016
#elif (VDDEE_VAL == 910)
	#define VDDEE_VAL_REG	0x00050017
#elif (VDDEE_VAL == 920)
	#define VDDEE_VAL_REG	0x00040018
#elif (VDDEE_VAL == 930)
	#define VDDEE_VAL_REG	0x00030019
#elif (VDDEE_VAL == 940)
	#define VDDEE_VAL_REG	0x0002001a
#elif (VDDEE_VAL == 950)
	#define VDDEE_VAL_REG	0x0001001b
#elif (VDDEE_VAL == 960)
	#define VDDEE_VAL_REG	0x0000001c
#else
	#error "VDDEE val out of range\n"
#endif

/* for PWM use */
/* PWM driver check http://scgit.amlogic.com:8080/#/c/38093/ */
#define GPIO_O_EN_N_REG3	((0xff634400 + (0x19 << 2)))
#define GPIO_O_REG3		((0xff634400 + (0x1a << 2)))
#define GPIO_I_REG3		((0xff634400 + (0x1b << 2)))
#define AO_PIN_MUX_REG0	((0xff800000 + (0x05 << 2)))
#define AO_PIN_MUX_REG1	((0xff800000 + (0x06 << 2)))

bl2_reg_t __bl2_reg[] = {
	/* demo, user defined override register */
	/* eg: PWM init */

	/* PWM_AO_D */
	/* VCCK_VAL_REG: check PWM table */
	{AO_PWM_PWM_D,        VCCK_VAL_REG,            0xffffffff,   0, BL2_INIT_STAGE_1, 0},
	{AO_PWM_MISC_REG_CD,  ((1 << 23) | (1 << 1)),  (0x7f << 16), 0, BL2_INIT_STAGE_1, 0},
	{AO_PIN_MUX_REG1,     (3 << 20),               (0xF << 20),  0, BL2_INIT_STAGE_1, 0},
	/* PWM_AO_B */
	/* VDDEE_VAL_REG: check PWM table */
	{AO_PWM_PWM_B,        VDDEE_VAL_REG,           0xffffffff,   0, BL2_INIT_STAGE_1, 0},
	{AO_PWM_MISC_REG_AB,  ((1 << 23) | (1 << 1)),  (0x7f << 16), 0, BL2_INIT_STAGE_1, 0},
	{AO_PIN_MUX_REG1,     (3 << 16),               (0xF << 16),  0, BL2_INIT_STAGE_1, 0},
	/* Enable 5V_EN */
	{GPIO_O_EN_N_REG3,    (1 << 8),                (1 << 8),     0, BL2_INIT_STAGE_1, 0},
	{GPIO_O_REG3,         (1 << 8),                (1 << 8),   0, BL2_INIT_STAGE_1, 0},
	/* Enable CPUA ,control by GPIOAO_4 */
	{AO_GPIO_O_EN_N,    (0 << 4),                (1 << 4),     0, BL2_INIT_STAGE_1, 0},
	{AO_GPIO_O,         (1 << 4),                (1 << 4),   0, BL2_INIT_STAGE_1, 0},
	/* Enable VCCK */
	{AO_SEC_REG0,         (1 << 0),                (1 << 0),     0, BL2_INIT_STAGE_1, 0},
	{AO_GPIO_O,           (1 << 31),               (1 << 31),    0, BL2_INIT_STAGE_1, 0},
};
