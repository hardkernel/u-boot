/*
 * Memory setup for SMDK5410 board based on EXYNOS5
 *
 * Copyright (C) 2012 Samsung Electronics
 *
 * See file CREDITS for list of people who contributed to this
 * project.
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
 */

#include <common.h>
#include <config.h>
#include <asm/arch/cpu.h>

#define Outp32(addr, data)	(*(volatile u32 *)(addr) = (data))
#define Inp32(addr)		(*(volatile u32 *)(addr))
#define SetBits(uAddr, uBaseBit, uMaskValue, uSetValue) \
		Outp32(uAddr, (Inp32(uAddr) & ~((uMaskValue)<<(uBaseBit))) \
		| (((uMaskValue)&(uSetValue))<<(uBaseBit)))

#define CA_SWAP			1
#define NUM_CHIP 		1
#define ZQ_MODE_DDS		6
#define PERFORM_LEVELING	0
#define PHY0_BASE		0x10C00000
#define PHY1_BASE		0x10C10000
#define DREX1_0			0x10C20000
#define DREX1_1			0x10C30000
#define CMU_COREPART		0x10010000
#define CMU_TOPPART		0x10020000
#define CMU_MEMPART		0x10030000


void DMC_Delay(u32 x)
{
	while(--x)
		__asm ("NOP");
}

void Prepare_levelings_lpddr3(u32 PHY_address, u32 DREX_address)
{
	u32 data, w_data, r_data;

	// LPDDR3 Leveling and Calibration Test
	// Set the ConControl to turn off an auto refresh counter.
	data = Inp32(DREX_address+0x0000);
	data = data&(~0x00000020);
	Outp32( DREX_address+0x0000, data); // Auto-Refresh cnt disable

	// Turn off dynamic power down control
	// [5]dynamic self refresh enable
	// [1]dynamic power down enable
	// [0]clcok stop enable: 0-clock always runs, 1-clock stops during idle periods
	data = Inp32(DREX_address+0x0004);
	data = data&(~0x00000023);
	Outp32( DREX_address+0x0004, data); // Auto-Refresh cnt disable

	// Precharge ALL
	Outp32( DREX_address+0x0010, 0x01000000); // DirectCmd PALL

	// Initialize PHY
	data = Inp32(PHY_address+0x0000);
	data = data|(0x00004040);
	Outp32( PHY_address+0x0000, data); // ctrl_atgate[6]=1, p0_cmd_en[14]=1

	// r_data is used as w_data because w_data is used in below lines
	data = Inp32(PHY_address+0x0008);
	data = data&(~0x00000040);
	data = data|(0x00000040);
	Outp32( PHY_address+0x0008, data); // r_data[6]=1

	data = Inp32(PHY_address+0x0000);
	data = data&(~0x00002000);
	data = data|(0x00002000);
	Outp32( PHY_address+0x0000, data); // byte_rdlvl_en[13]=1

	data = Inp32(PHY_address+0x0030);
	data = data&(~0x00000020);
	Outp32( PHY_address+0x0030, data); // ctrl_dll_on=0

	// w_data[14:8]=r_data[16:10]
	data = Inp32(PHY_address+0x0034); // PHY_CON13 read lock value
	r_data = data>>10;

	// write lock value to ctrl_force
	data = Inp32(PHY_address+0x0000);
	w_data = data|(r_data << 8);
	Outp32( PHY_address+0x0000, w_data); // ctrl_force[14:8]

	return;
}

void Write_dq_leveling_lpddr3(u32 PHY_address, u32 DREX_address)
{
	u32 wrlvlTemp, data;

	// Set WL
	data = Inp32(PHY_address+0x006C); // PHY_CON26
	wrlvlTemp=data&(~0x001F0000);
	data=wrlvlTemp+(0x00070000);
	Outp32( PHY_address+0x006C, data); // T_wrdata_en[20:16]=0x7

	// RdlvlConfig1 --> RdlvlConfig
	// Enable WrtraConfig.write_training_en
	data = Inp32(DREX_address+0x00F8); // RdlvlConfig
	wrlvlTemp=data&(~0x00000001);
	data=wrlvlTemp|(0x00000001);
	Outp32( DREX_address+0x00F8, data); // RdlvlConfig  ctrl_rdlvl_gate_en[0]=1

	// Issue write command to DRAM base to make DRAM in active state
	// erased because active command is generated automatically after above setting wr_buffer[0]=0

	// store read command in PHY_CON22
	if (CA_SWAP==1)
		wrlvlTemp=data&(~0x000FFDFB);
	else
		wrlvlTemp=data&(~0x000FFFFA);
	Outp32( PHY_address+0x005C, wrlvlTemp); // PHY_CON22  lpddr2_addr[19:0]

	// set write leveling pattern
	data = Inp32(PHY_address+0x0004); // PHY_CON1
	data=data&(0xFFFF0000);
	data=data+(0x000000FF);
	Outp32( PHY_address+0x0004, data); // rdlvl_rddata_adj[15:0]=0x00FF

	// byte_rdlvl_en=0
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00002000);
	data=data|(0x00002000);
	Outp32( PHY_address+0x0000, data); // byte_rdlvl_en[13]=0

	// If read dq calibration is performed prior to write dq calibration, below step have to be performed
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00004000);
	data=data|(0x00004000);
	Outp32( PHY_address+0x0000, data); // p0_cmd_en [14]=1

	// write traning mode enter
	data = Inp32(PHY_address+0x0008); // PHY_CON2
	data=data&(~0x04000000);
	data=data|(0x04000000);
	Outp32( PHY_address+0x0008, data); // wr_deskew_con[26]=1

	// write traning start
	data = Inp32(PHY_address+0x0008); // PHY_CON2
	data=data&(~0x08000000);
	data=data|(0x08000000);
	Outp32( PHY_address+0x0008, data); // wr_deskew_en[27]=1

	// wait until write training done
	while( ( Inp32( DREX_address+0x0040 ) & 0x00004000 ) != 0x00004000 );	// PhyStatus rdlvl_complete[14]

	// RdlvlConfig0 --> RdlvlConfig,  27-bit = zero?
	// Enable WrtraConfig.write_training_en
	data = Inp32(DREX_address+0x00F8); // RdlvlConfig
	data=data&(~0x08000000);
	Outp32( DREX_address+0x00F8, data); // RdlvlConfig  ctrl_rdlvl_gate_en[27]=0
	Outp32( PHY_address+0x0008, data); 	// wr_deskew_en[27]=0
	return;
}

void Read_leveling_lpddr3(u32 PHY_address, u32 DREX_address)
{
	// u32 rPhyData, rPhySDLL_code;
	u32 rdlvlTemp, data;

	// Note that maximum wating time of read leveling is 20us
	// set read leveling pattern
	data = Inp32(PHY_address+0x0004); // PHY_CON1
	data=data&(0xFFFF0000);
	data=data+(0x000000FF);
	Outp32( PHY_address+0x0004, data); // rdlvl_rddata_adj[15:0]=0x00FF

	// byte_rdlvl_en=0
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00002000);
	Outp32( PHY_address+0x0000, data); // byte_rdlvl_en[13]=0

	// setting MR32 for dq calibration
	if (CA_SWAP==1)
		Outp32( PHY_address+0x005C, 0x00000041); // PHY_CON22 lpddr2_addr[19:0]
	else
		Outp32( PHY_address+0x005C, 0x00000208); // PHY_CON22 lpddr2_addr[19:0]

	// enable rdlvl_get_en
	data = Inp32(PHY_address+0x0008); // PHY_CON2
	data=data&(0xFF80FFFF);
	data=data+(0x00600000);
	Outp32( PHY_address+0x0008, data); // rdlvl_incr_adj[22:16]=7'b110_0000
	// rdlvl_en
	rdlvlTemp=data&(~0x02000000);
	data=rdlvlTemp|(0x02000000);
	Outp32( PHY_address+0x0008, data); // rdlvl_en[25]=1

	// RdlvlConfig0 --> RdlvlConfig
	// enable ctrl_rdlvl_en and ctrl_rdlvl_gate_en
	Outp32( DREX_address+0x00F8, 0x00000002); // RdlvlConfig  ctrl_rdlvl_data_en	[1]=1, ctrl_rdlvl_gate_en	[0]=0

	// wait for leveling done
	while( ( Inp32( DREX_address+0x0040 ) & 0x00004000 ) != 0x00004000 );	// PhyStatus rdlvl_complete[14]

	// disable ctrl_rdlvl_en and ctrl_rdlvl_gate_en - move FSM to IDLE state
	Outp32( DREX_address+0x00F8, 0x00000000); // RdlvlConfig  ctrl_rdlvl_data_en[1]=0, ctrl_rdlvl_gate_en	[0]=0
	return;
}

void Write_leveling_lpddr3(u32 PHY_address, u32 DREX_address)
{
	u32 r_data_lvl0, r_data_lvl8, r_data_lvl16, r_data_lvl31;
	u32 wrlvl_byte0_done, wrlvl_byte1_done, wrlvl_byte2_done, wrlvl_byte3_done;
	u32 wrlvlSDLL_code;
	u32 wrlvlTemp, data;

	// Configure memory in write leveling mode
	Outp32( DREX_address+0x0010, 0x0000A28); // DirectCmd

	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00010000);
	data=data|(0x00010000);
	Outp32( PHY_address+0x0000, data); // ctrl_wrlvl_en [16]=1
	data = Inp32(DREX_address+0x0120); // WRLVLCONFIG0
	data=data&(~0x00000001);
	data=data|(0x00000001);
	Outp32( DREX_address+0x0120, data); // otd_on[0]=1

	// ///// Finding optimal SDLL code start /////
	wrlvl_byte0_done=0;
	wrlvl_byte1_done=0;
	wrlvl_byte2_done=0;
	wrlvl_byte3_done=0;
	wrlvlSDLL_code=0;
	wrlvlSDLL_code=0x08080808;

	while ((wrlvl_byte0_done==0)||(wrlvl_byte1_done==0)||(wrlvl_byte2_done==0)||(wrlvl_byte3_done==0))
	{
		// 1. set SDLL code
		Outp32( PHY_address+0x0030, wrlvlSDLL_code); // ctrl_wrlvl[16]

		// 2. resync command enable to SDLL
		data = Inp32(PHY_address+0x0030); // PHY_CON30
		data=data&(~0x00000001);
		data=data|(0x00000001);
		Outp32( PHY_address+0x0030, data); // ctrl_wrlvl[16]=1

		// 3. resync command disable
		data = Inp32(PHY_address+0x0030); // PHY_CON30
		data=data&(~0x00000001);
		Outp32( PHY_address+0x0030, data); // ctrl_wrlvl[16]=0

		// 4. dqs pulse generation
		Outp32( DREX_address+0x0124, 0x00000001); // wrlvl_wrdata_en[0]=1

		// 5. wait until write leveling data from LPDDR3
		while( ( Inp32( DREX_address+0x0128 ) & 0x0000001F ) != 0x0000001F );	// wrlvl_fsm[4:0]

		// 6. byte-by-byte update of SDLL codes
		data = Inp32(DREX_address+0x0150); // CTRL_IO_RDATA
		r_data_lvl0=data&(0x00000001);
		r_data_lvl8=data&(0x00000100);
		r_data_lvl16=data&(0x00010000);
		r_data_lvl31=data&(0x80000000);
		if ((wrlvl_byte0_done==1)||(r_data_lvl0==0x00000001))
			wrlvl_byte0_done=1;
		else
		{
			wrlvlTemp=wrlvlSDLL_code&(0x0000007F);
			wrlvlTemp=wrlvlTemp+0x00000001;
			wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x0000007F));
		}

		if ((wrlvl_byte1_done==1)||(r_data_lvl8==0x00000100))
			wrlvl_byte1_done=1;
		else
		{
			wrlvlTemp=wrlvlSDLL_code&(0x00007F00);
			wrlvlTemp=wrlvlTemp+0x00000100;
			wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x00007F00));
		}

		if ((wrlvl_byte2_done==1)||(r_data_lvl16==0x00010000))
			wrlvl_byte2_done=1;
		else
		{
			wrlvlTemp=wrlvlSDLL_code&(0x00FE0000);
			wrlvlTemp=wrlvlTemp+0x00020000;
			wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x00FE0000));
		}

		if ((wrlvl_byte3_done==1)||(r_data_lvl31==0x80000000))
			wrlvl_byte3_done=1;
		else
		{
			wrlvlTemp=wrlvlSDLL_code&(0x7F000000);
			wrlvlTemp=wrlvlTemp+0x01000000;
			wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x7F000000));
		}
	};

	// optimal SDLL code is current SDLL code - 1
	wrlvlTemp=(wrlvlSDLL_code&(0x0000007F))-0x00000001;
	wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x0000007F));
	wrlvlTemp=(wrlvlSDLL_code&(0x00007F00))-0x00000100;
	wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x00007F00));
	wrlvlTemp=(wrlvlSDLL_code&(0x00007F00))-0x00020000;
	wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x00007F00));
	wrlvlTemp=(wrlvlSDLL_code&(0x7F000000))-0x01000000;
	wrlvlSDLL_code=wrlvlSDLL_code|(wrlvlTemp&(0x7F000000));
	Outp32( PHY_address+0x0030, wrlvlSDLL_code);
	// resync enable
	wrlvlTemp=wrlvlSDLL_code&(~0x00010000);
	wrlvlSDLL_code=wrlvlTemp|(0x00010000);
	Outp32( PHY_address+0x0030, wrlvlSDLL_code); // ctrl_wrlvl[16]=1
	// resync disable
	wrlvlSDLL_code=wrlvlSDLL_code&(~0x00010000);
	Outp32( PHY_address+0x0030, wrlvlSDLL_code); // ctrl_wrlvl[16]=0

	// ///// Finding optimal SDLL code end /////
		// Check whether SDLL code is correct
	data = Inp32(PHY_address+0x0030); // PHY_CON30

	// Write level disable
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00010000);
	Outp32( PHY_address+0x0000, data); // ctrl_wrlvl_en[16]=0

	// commadn to DRAM to exit from write level state
	Outp32( DREX_address+0x0010, 0x0000828); // DirectCmd

	// ODT disable
	data = Inp32(DREX_address+0x0120); // WRLVLCONFIG0
	data=data&(~0x00000001);
	Outp32( DREX_address+0x0120, data); // otd_on[0]=0

	return;
}

void CA_calibration_lpddr3(u32 PHY_address, u32 DREX_address)
{
	u32 w_data, data;
	u32 r_data0_1, r_data0_2, r_data1_1, r_data1_2, r_data2_1, r_data2_2, r_data3_1, r_data3_2, r_data4_1, r_data4_2, r_data5_1, r_data5_2;
	u32 r_data6_1, r_data6_2, r_data7_1, r_data7_2, r_data8_1, r_data8_2, r_data9_1, r_data9_2;
	u32 cal_temp1, cal_temp2, cal_temp3;
	u32 calibration_done_ca,	 left_code_found_ca, calibbration_done_ca_ca4, calibbration_done_ca_ca9;
	u32 SDLL_code_ca3,	SDLL_code_ca2,	SDLL_code_ca1,	SDLL_code_ca0;
	u32 SDLL_code_ca8,	SDLL_code_ca7,	SDLL_code_ca6,	SDLL_code_ca5;
	u32 SDLL_code_ca4,	SDLL_code_ca9;
	u32 left_code_ca0, left_code_ca1, left_code_ca2, left_code_ca3, left_code_ca4;
	u32 left_code_ca5, left_code_ca6, left_code_ca7, left_code_ca8, left_code_ca9;
	u32 wrlvl_byte0_done, wrlvl_byte1_done, wrlvl_byte2_done, wrlvl_byte3_done;
	u32 wrSDLL_code;

	// 1. CA calibration mode enable to LPDDR3 (CA[3:0] and CA[8:5] will be calibrated)
	Outp32( DREX_address+0x0010, 0x00050690); // DirectCmd cmd_type[27:24], cmd_chip[20], cmd_bank[18:16], cmd_addr[15:0]

	// Deasserting CKE and set t_adr
	data = Inp32(DREX_address+0x0160);
	data = data|(0x00000031);
	Outp32( DREX_address+0x0160, data); // t_adr[7:4]=4'h3, deassert_cke[0]=1

	// 2. Configure PHY in CA calibration mode
	data = Inp32(PHY_address+0x0000);
	data = data&(~0x00010000);
	data = data|(0x00010000);
	Outp32( PHY_address+0x0000, data); // wrlvl_en[16]=1
	data = Inp32(PHY_address+0x0008);
	data = data&(~0x00800000);
	data = data|(0x00800000);
	Outp32( PHY_address+0x0008, data); // rdlvl_ca_en[23]=1

	// 3. Finding optimal CA SDLL code
	// set the initial CA SDLL codes
	left_code_found_ca=0;
	calibration_done_ca=0;
	SDLL_code_ca0=0x8;
	SDLL_code_ca1=0x8;
	SDLL_code_ca2=0x8;
	SDLL_code_ca3=0x8;
	SDLL_code_ca5=0x8;
	SDLL_code_ca6=0x8;
	SDLL_code_ca7=0x8;
	SDLL_code_ca8=0x8;
	// ca4 and ca9 will be calibrated in separate step
	calibration_done_ca=0x00000210;

	// left_code_ca is zero?
	left_code_ca0=0;
	left_code_ca1=0;
	left_code_ca2=0;
	left_code_ca3=0;
	left_code_ca4=0;
	left_code_ca5=0;
	left_code_ca6=0;
	left_code_ca7=0;
	left_code_ca8=0;
	left_code_ca9=0;
	while (calibration_done_ca != 0x3FF)
	{
		cal_temp1=((left_code_ca0<<0)&0x0000007E)|((left_code_ca1<<7)&0x0000007E)|((left_code_ca2<<14)&0x001FC000)|((left_code_ca3<<21)&0x0FE00000);
		Outp32( PHY_address+0x0080, cal_temp1); // PHY_CON31
		cal_temp1=((left_code_ca5<<3)&0x000003F8)|((left_code_ca6<<10)&0x0001FC00)|((left_code_ca7<<17)&0x00FE0000)|((left_code_ca8<<24)&0x7F000000);
		Outp32( PHY_address+0x0084, cal_temp1);

		// asserting ctrl_resync to update SDLL code
		data = Inp32(PHY_address+0x0028);
		data=data&(~0x01000000);
		data=data|(0x01000000);
		Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=1
		data=data&(~0x01000000);
		Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=0

		// generating dfi_cs_n_p0 pulse
		data = Inp32(DREX_address+0x0164);
		data=data&(~0x00000001);
		data=data|(0x00000001);
		Outp32( DREX_address+0x0164, data); // calcal_csn[0]=1

		// wait for valid ctrl_io_rdata
		while( ( Inp32( DREX_address+0x0168 ) & 0x0000001F ) != 0x0000001F );	// PHY_CON17 zq_done[0]=ZQ Calibration is finished.

		data = Inp32(DREX_address+0x0150); // CTRL_IO_RDATA ctrl_io_rdata[31:0]
		r_data0_1=data&(0x00000001);
		r_data0_2=data&(0x00000002);
		r_data1_1=data&(0x00000004);
		r_data1_2=data&(0x00000008);
		r_data2_1=data&(0x00000010);
		r_data2_2=data&(0x00000020);
		r_data3_1=data&(0x00000040);
		r_data3_2=data&(0x00000080);
		r_data5_1=data&(0x00000100);
		r_data5_2=data&(0x00000200);
		r_data6_1=data&(0x00000400);
		r_data6_2=data&(0x00000800);
		r_data7_1=data&(0x00001000);
		r_data7_2=data&(0x00002000);
		r_data8_1=data&(0x00004000);
		r_data8_2=data&(0x00008000);

		// test CA[0]
		cal_temp1=calibration_done_ca&(0x00000001);
		if (cal_temp1==0)
		{
			if ((r_data0_1==0x00000001)&&(r_data0_2==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca0==0x60)
				{
					SDLL_code_ca0=(SDLL_code_ca0+left_code_ca0)/2;
					cal_temp3=calibration_done_ca&(~0x00000001);
					calibration_done_ca=cal_temp3|(0x00000001);
				}
				SDLL_code_ca0=SDLL_code_ca0+1;
				cal_temp2=left_code_found_ca&(0x00000001);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000001);
					left_code_found_ca=cal_temp3|(0x00000001);
					left_code_ca0=SDLL_code_ca0;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000001);
				if  (cal_temp2==1)
				{
					SDLL_code_ca0=(SDLL_code_ca0+left_code_ca0)/2;
					cal_temp3=calibration_done_ca&(~0x00000001);
					calibration_done_ca=cal_temp3|(0x00000001);
				}
				else
				{
					SDLL_code_ca0=SDLL_code_ca0+1;
				}
			}
		}
		// test CA[1]
		cal_temp1=calibration_done_ca&(0x00000002);
		if (cal_temp1==0)
		{
			if ((r_data1_1==0x00000004)&&(r_data1_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca1==0x60)
				{
					SDLL_code_ca1=(SDLL_code_ca1+left_code_ca1)/2;
					cal_temp3=calibration_done_ca&(~0x00000002);
					calibration_done_ca=cal_temp3|(0x00000002);
				}
				SDLL_code_ca1=SDLL_code_ca1+1;
				cal_temp2=left_code_found_ca&(0x00000002);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000002);
					left_code_found_ca=cal_temp3|(0x00000002);
					left_code_ca1=SDLL_code_ca1;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000002);
				if (cal_temp2==1)
				{
					SDLL_code_ca1=(SDLL_code_ca1+left_code_ca1)/2;
					cal_temp3=calibration_done_ca&(~0x00000002);
					calibration_done_ca=cal_temp3|(0x00000002);
				}
				else
				{
					SDLL_code_ca1=SDLL_code_ca1+1;
				}
			}
		}
		// test CA[2]
		cal_temp1=calibration_done_ca&(0x00000004);
		if (cal_temp1==0)
		{
			if ((r_data2_1==0x00000010)&&(r_data2_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca2==0x60)
				{
					SDLL_code_ca2=(SDLL_code_ca2+left_code_ca2)/2;
					cal_temp3=calibration_done_ca&(~0x00000004);
					calibration_done_ca=cal_temp3|(0x00000004);
				}
				SDLL_code_ca2=SDLL_code_ca2+1;
				cal_temp2=left_code_found_ca&(0x00000004);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000004);
					left_code_found_ca=cal_temp3|(0x00000004);
					left_code_ca2=SDLL_code_ca2;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000004);
				if (cal_temp2==1)
				{
					SDLL_code_ca2=(SDLL_code_ca2+left_code_ca2)/2;
					cal_temp3=calibration_done_ca&(~0x00000004);
					calibration_done_ca=cal_temp3|(0x00000004);
				}
				else
				{
					SDLL_code_ca2=SDLL_code_ca2+1;
				}
			}
		}
		// test CA[3]
		cal_temp1=calibration_done_ca&(0x00000008);
		if (cal_temp1==0)
		{
			if ((r_data3_1==0x00000010)&&(r_data3_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca3==0x60)
				{
					SDLL_code_ca3=(SDLL_code_ca3+left_code_ca3)/2;
					cal_temp3=calibration_done_ca&(~0x00000008);
					calibration_done_ca=cal_temp3|(0x00000008);
				}
				SDLL_code_ca3=SDLL_code_ca3+1;
				cal_temp2=left_code_found_ca&(0x00000008);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000008);
					left_code_found_ca=cal_temp3|(0x00000008);
					left_code_ca3=SDLL_code_ca3;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000008);
				if (cal_temp2==1)
				{
					SDLL_code_ca3=(SDLL_code_ca3+left_code_ca3)/2;
					cal_temp3=calibration_done_ca&(~0x00000008);
					calibration_done_ca=cal_temp3|(0x00000008);
				}
				else
				{
					SDLL_code_ca3=SDLL_code_ca3+1;
				}
			}
		}
		// test CA[5]
		cal_temp1=calibration_done_ca&(0x00000020);
		if (cal_temp1==0)
		{
			if ((r_data5_1==0x00000100)&&(r_data5_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca5==0x60)
				{
					SDLL_code_ca5=(SDLL_code_ca5+left_code_ca5)/2;
					cal_temp3=calibration_done_ca&(~0x00000020);
					calibration_done_ca=cal_temp3|(0x00000020);
				}
				SDLL_code_ca5=SDLL_code_ca5+1;
				cal_temp2=left_code_found_ca&(0x00000020);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000020);
					left_code_found_ca=cal_temp3|(0x00000020);
					left_code_ca5=SDLL_code_ca5;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000020);
				if (cal_temp2==1)
				{
					SDLL_code_ca5=(SDLL_code_ca5+left_code_ca5)/2;
					cal_temp3=calibration_done_ca&(~0x00000020);
					calibration_done_ca=cal_temp3|(0x00000020);
				}
				else
				{
					SDLL_code_ca5=SDLL_code_ca5+1;
				}
			}
		}
		// test CA[6]
		cal_temp1=calibration_done_ca&(0x00000040);
		if (cal_temp1==0)
		{
			if ((r_data6_1==0x00000400)&&(r_data6_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca6==0x60)
				{
					SDLL_code_ca6=(SDLL_code_ca6+left_code_ca6)/2;
					cal_temp3=calibration_done_ca&(~0x00000040);
					calibration_done_ca=cal_temp3|(0x00000040);
				}
				SDLL_code_ca6=SDLL_code_ca6+1;
				cal_temp2=left_code_found_ca&(0x00000040);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000040);
					left_code_found_ca=cal_temp3|(0x00000040);
					left_code_ca6=SDLL_code_ca6;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000040);
				if  (cal_temp2==1)
				{
					SDLL_code_ca6=(SDLL_code_ca6+left_code_ca6)/2;
					cal_temp3=calibration_done_ca&(~0x00000040);
					calibration_done_ca=cal_temp3|(0x00000040);
				}
				else
				{
					SDLL_code_ca6=SDLL_code_ca6+1;
				}
			}
		}
		// test CA[7]
		cal_temp1=calibration_done_ca&(0x00000080);
		if (cal_temp1==0)
		{
			if ((r_data7_1==0x00000800)&&(r_data7_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca7==0x60)
				{
					SDLL_code_ca7=(SDLL_code_ca7+left_code_ca7)/2;
					cal_temp3=calibration_done_ca&(~0x00000080);
					calibration_done_ca=cal_temp3|(0x00000080);
				}
				SDLL_code_ca7=SDLL_code_ca7+1;
				cal_temp2=left_code_found_ca&(0x00000080);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000080);
					left_code_found_ca=cal_temp3|(0x00000080);
					left_code_ca7=SDLL_code_ca7;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000080);
				if  (cal_temp2==1)
				{
					SDLL_code_ca7=(SDLL_code_ca7+left_code_ca7)/2;
					cal_temp3=calibration_done_ca&(~0x00000080);
					calibration_done_ca=cal_temp3|(0x00000080);
				}
				else
				{
					SDLL_code_ca7=SDLL_code_ca7+1;
				}
			}
		}
		// test CA[8]
		cal_temp1=calibration_done_ca&(0x00000100);
		if (cal_temp1==0)
		{
			if ((r_data8_1==0x00000800)&&(r_data8_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca8==0x60)
				{
					SDLL_code_ca8=(SDLL_code_ca8+left_code_ca8)/2;
					cal_temp3=calibration_done_ca&(~0x00000100);
					calibration_done_ca=cal_temp3|(0x00000100);
				}
				SDLL_code_ca8=SDLL_code_ca8+1;
				cal_temp2=left_code_found_ca&(0x00000100);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000100);
					left_code_found_ca=cal_temp3|(0x00000100);
					left_code_ca8=SDLL_code_ca8;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000100);
				if  (cal_temp2==1)
				{
					SDLL_code_ca8=(SDLL_code_ca8+left_code_ca8)/2;
					cal_temp3=calibration_done_ca&(~0x00000100);
					calibration_done_ca=cal_temp3|(0x00000100);
				}
				else
				{
					SDLL_code_ca8=SDLL_code_ca8+1;
				}
			}
		}
	}

	// Update CA SDLL codes
	cal_temp1=(SDLL_code_ca0&0x0000007E)|((SDLL_code_ca1<<7)&0x0000007E)|((SDLL_code_ca2<<14)&0x001FC000)|((SDLL_code_ca3<<21)&0x0FE00000);
	Outp32( PHY_address+0x0080, cal_temp1); // PHY_CON31
	cal_temp1=((SDLL_code_ca5<<3)&0x000003F8)|((SDLL_code_ca6<<10)&0x0001FC00)|((SDLL_code_ca7<<17)&0x00FE0000)|((SDLL_code_ca8<<24)&0x7F000000);
	Outp32( PHY_address+0x0084, cal_temp1); // PHY_CON32

	// asserting ctrl_resync to update SDLL code
	data = Inp32(PHY_address+0x0028); // PHY_CON10
	data=data&(~0x01000000);
	data=data|(0x01000000);
	Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=1
	data=data&(~0x01000000);
	Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=0

	// Set PHY to normal mode
	data = Inp32(PHY_address+0x0008); // PHY_CON2
	data=data&(~0x00800000);
	Outp32( PHY_address+0x0008, data); // rdlvl_ca_en[23]=0
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00010000);
	Outp32( PHY_address+0x0000, data); // ctrl_wrlvl_en[16]=0

	// asserting CKE for MRS command below
	data = Inp32(DREX_address+0x0160); // CACAL_CONFIG0
	data=data&(~0x00000001);
	Outp32( DREX_address+0x0160, data); // deassert_cke[0]=0

	// 1. CA calibration mode enable to LPDDR3 (CA4 and CA9 will be calibrated)
	Outp32( DREX_address+0x0010, 0x00050AA0); // DirectCmd
	Outp32( DREX_address+0x0010, 0x00060300); // DirectCmd

	// 2. Deasserting CKE and set t_adr
	data = Inp32(DREX_address+0x0160); // CACAL_CONFIG0
	data=data|(0x00000031);
	Outp32( DREX_address+0x0160, data); // t_adr[7:4]=4'h3, deassert_cke[0]=1

	// 3. Configure PHY in CA calibration mode
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00010000);
	data=data|(0x00010000);
	Outp32( PHY_address+0x0000, data); // wrlvl_en[16]=1
	data = Inp32(PHY_address+0x0008); // PHY_CON2
	data=data&(~0x00800000);
	data=data|(0x00800000);
	Outp32( PHY_address+0x0008, data); // rdlvl_ca_en[23]=1

	// 4. Set the initial CA SDLL codes
	SDLL_code_ca4=0x8;
	SDLL_code_ca9=0x8;
	calibration_done_ca=0;
	left_code_found_ca=0;
	calibbration_done_ca_ca4=0xF;
	calibbration_done_ca_ca9=0xF;

	// 5. Finding optimal CS SDLL code
	while (calibration_done_ca != 0x3FF)
	{
		Outp32( PHY_address+0x0080, SDLL_code_ca4<<28); // PHY_CON31
		cal_temp1=((SDLL_code_ca9&(0x00000001))<<31)&(0x80000000);
		cal_temp1=cal_temp1&(((SDLL_code_ca4&0x00000070)>>4)&0x00000007);
		Outp32( PHY_address+0x0084, cal_temp1); // PHY_CON32

		// asserting ctrl_resync to update SDLL code
		data = Inp32(PHY_address+0x0028); // PHY_CON10
		data=data&(~0x01000000);
		data=data|(0x01000000);
		Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=1
		data=data&(~0x01000000);
		Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=0

		// generating dfi_cs_n_p0 pulse
		data = Inp32(DREX_address+0x0164); // CACAL_CONFIG1
		data=data&(~0x00000001);
		data=data|(0x00000001);
		Outp32( DREX_address+0x0164, data); // calcal_csn[0]=1

		// wait for valid ctrl_io_rdata
		while( ( Inp32( DREX_address+0x0168 ) & 0x0000001F ) != 0x0000001F ); // CACAL_STATUS cacal_fsm[4:0]

		data = Inp32(DREX_address+0x0150); // CTRL_IO_RDATA ctrl_io_rdata[31:0]
		r_data4_1=data&(0x00000001);
		r_data4_2=data&(0x00000002);
		r_data9_1=data&(0x00000004);
		r_data9_2=data&(0x00000008);

		// test CA[4]
		cal_temp1=calibration_done_ca&(0x00000010);
		if (cal_temp1==0)
		{
			if ((r_data4_1==0x00000001)&&(r_data4_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca4==0x60)
				{
					SDLL_code_ca4=(SDLL_code_ca4+left_code_ca4)/2;
					cal_temp3=calibration_done_ca&(~0x00000010);
					calibration_done_ca=cal_temp3|(0x00000010);
				}
				SDLL_code_ca4=SDLL_code_ca4+1;
				cal_temp2=left_code_found_ca&(0x00000010);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000010);
					left_code_found_ca=cal_temp3|(0x00000010);
					left_code_ca8=SDLL_code_ca4;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000010);
				if  (cal_temp2==1)
				{
					SDLL_code_ca4=(SDLL_code_ca4+left_code_ca4)/2;
					cal_temp3=calibration_done_ca&(~0x00000010);
					calibration_done_ca=cal_temp3|(0x00000010);
				}
				else
				{
					SDLL_code_ca4=SDLL_code_ca4+1;
				}
			}
		}
		// test CA[9]
		cal_temp1=calibration_done_ca&(0x00000200);
		if (cal_temp1==0)
		{
			if ((r_data9_1==0x00000001)&&(r_data9_1==0))
			{
				// CA calibration fail - valid code not found
				if (SDLL_code_ca9==0x60)
				{
					SDLL_code_ca9=(SDLL_code_ca9+left_code_ca4)/2;
					cal_temp3=calibration_done_ca&(~0x00000200);
					calibration_done_ca=cal_temp3|(0x00000200);
				}
				SDLL_code_ca9=SDLL_code_ca9+1;
				cal_temp2=left_code_found_ca&(0x00000200);
				if (cal_temp2==0)
				{
					cal_temp3=left_code_found_ca&(~0x00000200);
					left_code_found_ca=cal_temp3|(0x00000200);
					left_code_ca8=SDLL_code_ca9;
				}
			}
			else
			{
				// left code not found yet or right code just found
				cal_temp2=left_code_found_ca&(0x00000200);
				if  (cal_temp2==1)
				{
					SDLL_code_ca9=(SDLL_code_ca9+left_code_ca4)/2;
					cal_temp3=calibration_done_ca&(~0x00000200);
					calibration_done_ca=cal_temp3|(0x00000200);
				}
				else
				{
					SDLL_code_ca9=SDLL_code_ca9+1;
				}
			}
		}
	}

	// Update CA SDLL codes
	cal_temp1=(SDLL_code_ca0&0x0000007E)|((SDLL_code_ca1<<7)&0x0000007E)|((SDLL_code_ca2<<14)&0x001FC000)|((SDLL_code_ca3<<21)&0x0FE00000)|((SDLL_code_ca4<<28)&0xF0000000);
	Outp32( PHY_address+0x0080, cal_temp1); // PHY_CON31
	w_data=((SDLL_code_ca5<<3)&0x000003F8)|((SDLL_code_ca6<<10)&0x0001FC00)|((SDLL_code_ca7<<17)&0x00FE0000)|((SDLL_code_ca8<<24)&0x7F000000)|((SDLL_code_ca9<<31)&0x80000000)|((SDLL_code_ca4>>4)&0x00000007);
	Outp32( PHY_address+0x0084, w_data); // PHY_CON32
	w_data=0;
	w_data=SDLL_code_ca9>>1;
	Outp32( PHY_address+0x0088, w_data); // PHY_CON33

	// asserting ctrl_resync to update SDLL code
	data = Inp32(PHY_address+0x0028); // PHY_CON10
	data=data&(~0x01000000);
	data=data|(0x01000000);
	Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=1
	data=data&(~0x01000000);
	Outp32( PHY_address+0x0028, data); // ctrl_resync[24]=0

	// Set PHY to normal mode
	data = Inp32(PHY_address+0x0000); // PHY_CON0
	data=data&(~0x00010000);
	Outp32( PHY_address+0x0000, data); // ctrl_wrlvl_en[16]=0

	// asserting CKE for MRS command below
	data = Inp32(DREX_address+0x0160); // CACAL_CONFIG0
	data=data&(~0x00000001);
	Outp32( DREX_address+0x0160, data); // deassert_cke[0]=0

	// 1. CA calibration mode enable to LPDDR3 (CA4 and CA9 will be calibrated)
	Outp32( DREX_address+0x0010, 0x00050AA0); // DirectCmd
}

void CA_swap_lpddr3(u32 PHY_address)
{
	// u32 data;

	Outp32( CMU_MEMPART+0x0A20, 0xC0000000 );	// DREX1 CA swap [30] : DREX0 CA swap

	Outp32( PHY_address+0x0064, 0x00000001 );	// ca_swap_mode[0]=1
	return;
}

void Low_frequency_init_lpddr3(u32 PHY_address, u32 DREX_address)
{
	u32 data;
	u32 *testbit;
	u32 nLoop;
	u32 data_RST_STAT;
	u32 status = __REG(EXYNOS5_POWER_BASE + INFORM1_OFFSET);

	// Reset Status Check..!
	data_RST_STAT = Inp32(0x10040404);
	data_RST_STAT = data_RST_STAT & (0x00000C00);

	// 1. To provide stable power for controller and memory device, the controller must assert and hold CKE to a logic low level
	// 2. DRAM mode setting
	Outp32( PHY_address+0x0000, 0x17021A00 );	// PHY_CON0 ctrl_ddr_mode[12:11]=3(LPDDR3), ctrl_atgate	(automatic gate control-controller drive gate signals)[6]=1

	// Closed by cju,2013.01.16
	//if((status != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	{
		// 3. Force lock values (DLL cannot be locked under 400MHz)
		Outp32( PHY_address+0x0030, 0x10107F50 );	// PHY_CON12 ctrl_start_point	[30:24]=0x10, ctrl_inc[22:16]=0x10, ctrl_force[14:8]=0x7F, ctrl_start[6]=1, ctrl_dll_on[5]=0, ctrl_ref	[4:1]=0x8 
		Outp32( PHY_address+0x0028, 0x0000007F );	// ctrl_offsetd[7:0]=0x7F

		// 4. Set ctrl_offsetr, crtrl_offsetw to 0x7F
		Outp32( PHY_address+0x0010, 0x7F7F7F7F );	// PHY_CON4 ctrl_offsetr, MEM1 Port 0, Read Leveling Manual Value
		Outp32( PHY_address+0x0018, 0x7F7F7F7F );	// PHY_CON6 ctrl_offsetw, MEM1 Port 0, Write Training Manual Value

		// 5. set CA deskew code to 7h'60
		Outp32( PHY_address+0x0080, 0x0C183060 );	// PHY_CON31 DeSkew Code for CA
		Outp32( PHY_address+0x0084, 0x60C18306 );	// PHY_CON32 DeSkew Code for CA
		Outp32( PHY_address+0x0088, 0x00000030 );	// PHY_CON33 DeSkew Code for CA

		// Setting PHY_CON12 later
		// 6. Set ctrl_dll_on to 0
		// Outp32( PHY_address+0x0030, 0x10107F50); // PHY_CON12 ctrl_start_point	[30:24]=0x10, ctrl_inc[22:16]=0x10, ctrl_force[14:8]=0x7F, ctrl_start[6]=1, ctrl_dll_on[5]=0, ctrl_ref	[4:1]=0x8 
		// DMC_Delay(100); // Wait for 10 PCLK cycles

		// 7. Issue dfi_ctrlupd_req for more than 10 cycles
		Outp32( DREX_address+0x0018, 0x00000008); // PHYCONTROL0 assert fp_resync[3]=1(Force DLL Resyncronization)
		// "dfi_ctrlupd_req" should be issued more than 10 cycles after ctrl_dll_on is disabled.
		DMC_Delay(100); // Wait for 10 PCLK cycles
		Outp32( DREX_address+0x0018, 0x00000000); // PHYCONTROL0 deassert fp_resync[3]=1(Force DLL Resyncronization)

		// 8. Set MemControl. At this moment, all power down modes should be off.
		Outp32( DREX_address+0x0004, 0x00312700); // MEMCONTROL bl[22:20]=Memory Burst Length 0x3 = 8, mem_width[15:12]=Width of Memory Data Bus 0x2 = 32-bit, mem_type	[11:8]=Type of Memory 0x7 = LPDDR3
	}
	// Closed by cju,2013.01.16
	#if 0
	else
	{
		// 8. Set MemControl. At this moment, all power down modes should be off.
		Outp32( DREX_address+0x0004, 0x00312700); // MEMCONTROL bl[22:20]=Memory Burst Length 0x3 = 8, mem_width[15:12]=Width of Memory Data Bus 0x2 = 32-bit, mem_type	[11:8]=Type of Memory 0x7 = LPDDR3
	}
	#endif

	// Closed by cju,2013.01.16 ***Check if sleep mode is right.
	//if((status != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	// Opened by cju,2013.01.16 ***Check if sleep mode is right.
	if (status == S5P_CHECK_SLEEP) {
		// (5) DRAM PAD Retention Release
		// - PAD_RETENTION_DRAM_CONFIGURATION
		// 0x1004_3000[0] = 0x1
		testbit = (u32 *)(0x10043000);
		*testbit = 0x1;
		while(*(testbit+1) != 0x00001);

		// (6) setup CMU for DDR self-refresh Exit
		// - CLK_GATE_BUS_CDREX
		// 0x10030700[7:6] = 0x3
		data = Inp32( 0x10030700 );
		data = data & (~0x00000C0);
		data = data | 0x00000C0;
		Outp32( 0x10030700, data);

		// (7) LPI Masking ¼³Á¤
		// LPI_MASK0[0x1004_0004] = 0x7000
		// LPI_MASK1[0x1004_0008] = 0x30
		// LPI_MASK2[0x1004_000C] = 0x0
		// LPI_NOC_MASK0[0x1004_159C] = 0x0
		// LPI_NOC_MASK1[0x1004_15A0] = 0x0
		// LPI_NOC_MASK1[0x1004_15A4] = 0x0
		Outp32( 0x10040004, 0x00007000);
		Outp32( 0x10040008, 0x00000030);
		Outp32( 0x1004000C, 0x00000000);
		Outp32( 0x1004159C, 0x00000000);
		Outp32( 0x100415A0, 0x00000000);
		Outp32( 0x100415A4, 0x00000000);

		// Adding..! 2012.11.30
		Outp32( DREX1_0+0x0010, 0x07000000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		Outp32( DREX1_1+0x0010, 0x07000000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		if(NUM_CHIP == 1)	{
			Outp32( DREX1_0+0x0010, 0x07100000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
			Outp32( DREX1_1+0x0010, 0x07100000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		}

		// Added by cju,13.01.16
		for(nLoop=0;nLoop<8192;nLoop++)	{
			Outp32( DREX1_0+0x0010, 0x05000000);	// 0x5 = REFA (auto refresh),
			Outp32( DREX1_1+0x0010, 0x05000000);	// 0x5 = REFA (auto refresh),
			if(NUM_CHIP == 1)	{
				Outp32( DREX1_0+0x0010, 0x05100000); // 0x5 = REFA (auto refresh),
				Outp32( DREX1_1+0x0010, 0x05100000); // 0x5 = REFA (auto refresh),
			}
		}

	}

	// if((status != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	{
		// Start :: Adding option for handshaking between DREX and PHY
		// Deasserting the dfi_init_start
		// 2012.11.08 :: rd_fetch 3 -> 2
		Outp32( DREX_address+0x0000, 0x1FFF2100); // CONCONTROL dfi_init_start[28]=0 auto refresh not yet.
		// Disable DLL
		Outp32( PHY_address+0x0030, 0x10107F10); // PHY_CON12
		// End :: Adding option for handshaking between DREX and PHY

		// Direct Command P0 CH0..!
		// 9. CKE low for tINIT1 and CKE high for tINIT3
		Outp32( DREX_address+0x0010, 0x07000000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		DMC_Delay(53333); // MIN 200us

		// 10. RESET command to LPDDR3
		// Add :: 2012.11.01 :: Not send reset command when occured by wake-up
		Outp32( DREX_address+0x0010, 0x00071C00); // 0x0 = MRS/EMRS (mode register setting), MR63_Reset (MA<7:0> = 3FH): MRW only

		// tINIT4(MIN 1us), tINIT5(MAX 10us)

		// 12. DRAM ZQ calibration
		Outp32( DREX_address+0x0010, 0x00010BFC); // 0x0 = MRS/EMRS (mode register setting), MR10_Calibration, FFH: Calibration command after initialization
		// 13. Wait for minimum 1us (tZQINIT).
		DMC_Delay(267);	// MIN 1us
		// 13. DRAM parameter settings
		Outp32( DREX_address+0x0010, 0x0000050C); // 0x0 = MRS/EMRS (mode register setting), MR1_Device Feature, 011B: BL8, 010B: nWR=12

		// 2012.10.11
		// Outp32( DREX_address+0x0010, 0x00000828); // 0x0 = MRS/EMRS (mode register setting), MR2_Device Feature, 1B : Enable nWR programming > 9,Write Leveling(0)
		Outp32( DREX_address+0x0010, 0x00000868); // 0x0 = MRS/EMRS (mode register setting), MR2_Device Feature, 1B : Enable nWR programming > 9,Write Leveling(0)

		// Add 20120501..!
		// 14. I/O Configuration :: Drive Strength
		Outp32( DREX_address+0x0010, 0x00000C04); // MR(3) OP(1)
		DMC_Delay(267);	// MIN 1us
	}

	// Initialization of second DRAM
	if(NUM_CHIP == 1)
	{
		// if((status != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
		{
			// 9. CKE low for tINIT1 and CKE high for tINIT3
			Outp32( DREX_address+0x0010, 0x07100000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
			DMC_Delay(53333);	// MIN 200us

			// 10. RESET command to LPDDR3
			// Add :: 2012.11.01 :: Not send reset command when occured by wake-up
			Outp32( DREX_address+0x0010, 0x00171C00); // 0x0 = MRS/EMRS (mode register setting), MR63_Reset (MA<7:0> = 3FH): MRW only

			// tINIT4(MIN 1us), tINIT5(MAX 10us)

			// 12. DRAM ZQ calibration
			Outp32( DREX_address+0x0010, 0x00110BFC); // 0x0 = MRS/EMRS (mode register setting), MR10_Calibration, FFH: Calibration command after initialization
			// 13. Wait for minimum 1us (tZQINIT).
			DMC_Delay(267);	// MIN 1us

			// 13. DRAM parameter settings
			Outp32( DREX_address+0x0010, 0x0010050C); // 0x0 = MRS/EMRS (mode register setting), MR1_Device Feature, 011B: BL8, 010B: nWR=12

			// 2012.10.11
			//	Outp32( DREX_address+0x0010, 0x00100828); // 0x0 = MRS/EMRS (mode register setting), MR2_Device Feature, 1B : Enable nWR programming > 9,Write Leveling(0)
			Outp32( DREX_address+0x0010, 0x00100868); // 0x0 = MRS/EMRS (mode register setting), MR2_Device Feature, 1B : Enable nWR programming > 9,Write Leveling(0)

			// Add 20120501..!
			// 14. I/O Configuration :: Drive Strength
			Outp32( DREX_address+0x0010, 0x00100C04); // MR(3) OP(1)
			DMC_Delay(267);	// MIN 1us
		}
	}

	// if((status != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	{
		// Reset SDLL codes
		// 2012.10.11
		// Outp32( PHY_address+0x0028, 0x00000000); // PHY_CON10 ctrl_offsetd[7:0]=0x8
		Outp32( PHY_address+0x0028, 0x00000008); // PHY_CON10 ctrl_offsetd[7:0]=0x8

		// 4. Set ctrl_offsetr, crtrl_offsetw to 0x7F
		Outp32( PHY_address+0x0010, 0x08080808); // PHY_CON4 ctrl_offsetr, MEM1 Port 0, Read Leveling Manual Value
		Outp32( PHY_address+0x0018, 0x08080808); // PHY_CON5 ctrl_offsetw, MEM1 Port 0, Write Training Manual Value

		// 5. set CA deskew code to 7h'60
		Outp32( PHY_address+0x0080, 0x00000000); // PHY_CON31 DeSkew Code for CA
		Outp32( PHY_address+0x0084, 0x00000000); // PHY_CON32 DeSkew Code for CA
		Outp32( PHY_address+0x0088, 0x00000000); // PHY_CON33 DeSkew Code for CA
	}

	return;
}

void High_frequency_init_lpddr3(u32 PHY_address, u32 DREX_address, u32 nMEMCLK)
{
	u32 data;
	u32 data_temp;
	u32 status = __REG(EXYNOS5_POWER_BASE + INFORM1_OFFSET);

	// Pulldn and Pullup enable
	// ctrl_pulld_dq[11:8]=Active HIGH signal to down DQ signals. For normal operation this field should be zero.
	// ctrl_pulld_dqs[3:0]=Active HIGH signal to pull-up or down PDQS/NDQS signals.
	Outp32( PHY_address+0x0038, 0x001F000F); // PHY_CON14 ctrl_pulld_dq[11:8]=0xf, ctrl_pulld_dqs[3:0]=0xf

	// ZQ calibration
	// zq_mode_dds :: Driver strength selection. . It recommends one of the following settings instead of 3'h0
	// Outp32( PHY_address+0x0040, 0x0F040306); // PHY_CON16 zq_clk_en[27]=ZQ I/O Clock enable, zq_manual_mode[3:2]=Manual calibration mode selection 2'b01: long calibration, zq_manual_str[1]=Manual calibration start
	// PHY_CON39 :: Driver Strength
	// Outp32( PHY_address+0x00A0 , 0x0FFF0FFF); // PHY_CON39
	if (ZQ_MODE_DDS == 7)
	{
		Outp32( PHY_address+0x0040, 0x0F040306);
		Outp32( PHY_address+0x00A0, 0x0FFF0FFF);
	}
	else if  (ZQ_MODE_DDS == 6)
	{
		Outp32( PHY_address+0x0040, 0x0E040306);
		Outp32( PHY_address+0x00A0, 0x0DB60DB6);
	}
	else if  (ZQ_MODE_DDS == 5)
	{
		Outp32( PHY_address+0x0040, 0x0D040306);
		Outp32( PHY_address+0x00A0, 0x0B6D0B6D);
	}
	else if  (ZQ_MODE_DDS == 4)
	{
		Outp32( PHY_address+0x0040, 0x0C040306);
		Outp32( PHY_address+0x00A0, 0x09240924);
	}
	else
	{
			Outp32( PHY_address+0x0040, 0x0F040306);
			Outp32( PHY_address+0x00A0 , 0x0FFF0FFF);
	}

	// Checking the completion of ZQ calibration
	// GOSUB Delay 100ms; GOSUB read &PHY_address+0x0048; zq_done[0]=1
	// GOSUB Delay 100ms; GOSUB read &PHY1_BASE+0x0048; zq_done[0]=1
	while( ( Inp32( PHY_address+0x0048 ) & 0x00000001 ) != 0x00000001 );	// PHY_CON17 zq_done[0]=ZQ Calibration is finished.

	// ZQ calibration exit
	data_temp = Inp32( PHY_address+0x0040 );
	data_temp = data_temp&(~0x000FFFFF);
	data = data_temp|0x00040304;
	Outp32( PHY_address+0x0040, data); // PHY_CON16 zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=0

	// 1. Set DRAM burst length and READ latency
	Outp32( PHY_address+0x00AC, 0x0000080C); // PHY_CON42 ctrl_bstlen(Burst Length(BL))[12:8]=8, ctrl_rdlat(Read Latency(RL))[4:0]=12

	// 2. Set DRAM write latency
	Outp32( PHY_address+0x006C, 0x0007000F); // PHY_CON26 T_wrdata_en[20:16]=WL for DDR3

	// DLL LOCK Setting..!
	// Set the DLL lock parameters
	// Reserved	[31] ctrl_start_point	[30:24]=0x10 Reserved	[23] ctrl_inc	[22:16]=0x10 ctrl_force	[14:8] ctrl_start	[6]=0x1 ctrl_dll_on	[5]=0x1 ctrl_ref	[4:1]=0x8 Reserved	[0]
	// Next Step : Same Operation "CONCONTROL dfi_init_start[28]=1"
	// 2012.10.11
	// Outp32( PHY_address+0x0030, 0x10100070); // PHY_CON12
	Outp32( PHY_address+0x0030, 0x10100030); // PHY_CON12, "ctrl_dll_on[6] = 0"
	DMC_Delay(20); // PCLK 10 cycle.
	Outp32( PHY_address+0x0030, 0x10100070); // PHY_CON12, "ctrl_start[6] = 1"

	// 1. Set the Concontrol. At this moment, an auto refresh counter should be off.
	// 20120511 :: Change dll lock start point.
	// 2012.11.08 :: rd_fetch 3 -> 2
	Outp32( DREX_address+0x0000, 0x1FFF2000); // CONCONTROL dfi_init_start	[28], timeout_level0	[27:16], rd_fetch	[14:12], empty	[8], aref_en	[5], clk_ratio	[2:1]

	// 2. Set the MemConfig0 register. If there are two external memory chips, also set the MemConfig1 register.
	// LPDDR2_P0_CS0 : 32'h2000_000 ~ 32'h27FF_FFFF (4Gbit)
	Outp32( DREX_address+0x010C, 0x002007E0); // MemBaseConfig0 chip_base[26:16]=0x10, chip_mask[10:0]=0x7E0
	Outp32( DREX_address+0x0110, 0x004007E0); // MemBaseConfig1 chip_base[26:16]=0x30, chip_mask[10:0]=0x7E0

	// 3. Set the MemConfig0
	// chip_map	[15:12]	Address Mapping Method (AXI to Memory). 0x1 = Interleaved ({row, bank, column, width})
	// chip_col	[11:8]	Number of Column Address Bits. 0x3 = 10 bits
	// chip_row	[7:4]	Number of Row Address Bits. 0x2 = 14 bits
	// chip_bank	[3:0]	Number of Banks. 0x3 = 8 banks
	Outp32( DREX_address+0x0008, 0x00001323); // MemConfig0 chip_map	[15:12],chip_col	[11:8],chip_row	[7:4],chip_bank	[3:0]
	Outp32( DREX_address+0x000C, 0x00001323); // MemConfig1 chip_map	[15:12],chip_col	[11:8],chip_row	[7:4],chip_bank	[3:0]

	// 4. Set the PrechConfig and PwrdnConfig registers.
	Outp32( DREX_address+0x0014, 0xFF000000); // PrechConfig tp_cnt[31:24]=Timeout Precharge Cycles. 0xn = n cclk cycles. Refer to chapter 1.6.2 .Timeout precharge
	Outp32( DREX_address+0x0028, 0xFFFF00FF); // PwrdnConfig dsref_cyc[31:16]=Number of Cycles for dynamic self refresh entry. 0xn = n aclk cycles. Refer to chapter 1.5.3 . Dynamic self refresh

	// 5. Set the TimingAref, TimingRow, TimingData and TimingPower registers.
	//     according to memory AC parameters. At this moment, TimingData.w1 and TimingData.r1
	//     registers must be programmed according to initial clock frequency.
	// 2012.10.10
	// Outp32( DREX_address+0x0030, 0x000000BB); // TimingAref autorefresh counter @24MHz
	// Outp32( DREX_address+0x0030, 0x0000005E); // TimingAref autorefresh counter @24MHz
	// 2013.01.14
	Outp32( DREX_address+0x0030, 0x0000005D); // TimingAref autorefresh counter @24MHz

	// TimingAref autorefresh counter @24MHz
	// 2012.10.11
	// Outp32( DREX_address+0x0034, 0x34498611); // TimingRow
	// 2012.11.08 :: tRC : 0x18(24) ---> 0x1A(26), tRAS : 0x12(18) ---> 0x11(17)
	Outp32( DREX_address+0x0034, 0x34498691); // TimingRow
	Outp32( DREX_address+0x0038, 0x3630560C); // TimingData
	Outp32( DREX_address+0x003C, 0x50380336); // TimingPower

	// If QoS scheme is required, set the QosControl10~15 and QosConfig0~15 registers.

	// 6. Wait until dfi_init_complete become 1.
	while( ( Inp32( DREX_address+0x0040 ) & 0x00000008 ) != 0x00000008 );	// PhyStatus dfi_init_complete[3]=1

	// Outp32( DREX_address+0x0040, 0x00000008); // PhyStatus dfi_init_complete[3]=1

	// Deasserting the dfi_init_start
	// 2012.11.08 :: rd_fetch 3 -> 2
	Outp32( DREX_address+0x0000, 0x0FFF2000 );	// CONCONTROL dfi_init_start[0]=0

	// Forcing DLL 2013.01.19
	if (status != S5P_CHECK_SLEEP) {
//		while( ( Inp32( PHY_address+0x0034 ) & 0x00000001 ) != 0x00000001 );	// Wait lock status
//		data = ((Inp32( PHY_address+0x0034 ) & (0x7f << 10)) >> 10);
//		Outp32( PHY_address+0x0030, ((Inp32(PHY_address+0x0030) & ~(0x7f << 8))) | (data << 8)); // forcing dll lock value
//		Outp32( PHY_address+0x0030, (Inp32(PHY_address+0x0030) & ~(1 << 5)));	// dll off
//		Outp32( EXYNOS5_POWER_BASE + 0x0904, data);
	} else {
		Outp32( PHY_address+0x0030, (Inp32(PHY_address+0x0030) & ~(1 << 5)));	// dll off
		data = Inp32( EXYNOS5_POWER_BASE + 0x0904 );
		if ( PHY_address == PHY0_BASE )
			data = (data & 0x7f);
		else
			data = ((data & (0x7f << 16)) >> 16);
		Outp32( PHY_address+0x0030, ((Inp32(PHY_address+0x0030) & ~(0x7f << 8))) | (data << 8)); // forcing dll lock value
	}

	// 7. Forcing DLL resynchronization - dfi_ctrlupd_req
	Outp32( DREX_address+0x0018, 0x00000008); 	// PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=1
	DMC_Delay(20); // Wait for 10 PCLK cycles, PCLK(200MHz=10clock=50ns), DMC_Delay(40us)
	Outp32( DREX_address+0x0018, 0x00000000); 	// PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=0

	// 8. calibration & levelings
	if( PERFORM_LEVELING == 1)
	{
		Prepare_levelings_lpddr3( PHY_address, DREX_address);
		CA_calibration_lpddr3( PHY_address, DREX_address);
		Write_leveling_lpddr3( PHY_address, DREX_address);
		Read_leveling_lpddr3( PHY_address, DREX_address);
		Write_dq_leveling_lpddr3( PHY_address, DREX_address);
	}

	//-----------------------------------------------
	//- end_levelings_lpddr3_l
	//-----------------------------------------------

	// ctrl_atgate = 0
	// T_WrWrCmd	[30:24] 	It controls the interval between Write and Write during DQ Calibration. This value should be always kept by 5'h17. It will be used for debug purpose.
	// T_WrRdCmd	[19:17] 	It controls the interval between Write and Read by cycle unit during Write Calibration. It will be used for debug purpose. 3'b111 : tWTR = 6 cycles (=3'b001)
	// ctrl_ddr_mode[12:11] 	2'b11: LPDDR3
	// ctrl_dfdqs[9] 	1¡¯b1: differential DQS
	Outp32( PHY_address+0x0000, 0x17021A00); // PHY_CON0 byte_rdlvl_en[13]=1, ctrl_ddr_mode[12:11]=01, ctrl_atgate[6]=1, Bit Leveling

	if(PERFORM_LEVELING == 1) {
		// dfi_ctrlupd_req to make sure ALL SDLL is updated
		// forcing DLL resynchronization - dfi_ctrlupd_req
		Outp32( DREX_address+0x0018, 0x00000008); // PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=1
		DMC_Delay(20); // Wait for 10 PCLK cycles, PCLK(200MHz=10clock=50ns), DMC_Delay(40us)
		Outp32( DREX_address+0x0018, 0x00000000); // PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=0
	}

	#if 0	// Move..! 2012.11.30
	// 26. Set the ConControl to turn on an auto refresh counter.
	// aref_en[5]=Auto Refresh Counter. 0x1 = Enable
	// 2012.11.08 :: rd_fetch 3 -> 2
	Outp32( DREX_address+0x0000, 0x0FFF2128); // CONCONTROL aref_en[5]=1
	#endif

	// 27. If power down modes are required, set the MemControl register.
	// bl[22:20]=Memory Burst Length 0x3 = 8
	// mem_width[15:12]=Width of Memory Data Bus 0x2 = 32-bit
	// mem_type[11:8]=Type of Memory 0x7 = LPDDR3
	// dsref_en[5]=Dynamic Self Refresh. 0x1 = Enable.
	// dpwrdn_en[1]=Dynamic Power Down. 0x1 = Enable
	// clk_stop_en[0]=Dynamic Clock Control. 0x1 = Stops during idle periods.
	Outp32( DREX_address+0x0004, 0x00312723); // MemControl bl[22:20]=8, mem_type[11:8]=7, two chip selection


	if(nMEMCLK==100)
	{
		// 3. Force lock values (DLL cannot be locked under 400MHz)
		Outp32( PHY_address+0x0030, 0x10107F30 );	// PHY_CON12 ctrl_start_point	[30:24]=0x10, ctrl_inc[22:16]=0x10, ctrl_force[14:8]=0x7F, ctrl_start[6]=1, ctrl_dll_on[5]=0, ctrl_ref	[4:1]=0x8
		Outp32( PHY_address+0x0028, 0x0000007F );	// ctrl_offsetd[7:0]=0x7F

		// 4. Set ctrl_offsetr, crtrl_offsetw to 0x7F
		Outp32( PHY_address+0x0010, 0x7F7F7F7F );	// PHY_CON4 ctrl_offsetr, MEM1 Port 0, Read Leveling Manual Value, ¡Ú Best Tuning Value
		Outp32( PHY_address+0x0018, 0x7F7F7F7F );	// PHY_CON6 ctrl_offsetw, MEM1 Port 0, Write Training Manual Value

		// 5. set CA deskew code to 7h'60
		Outp32( PHY_address+0x0080, 0x0C183060 );	// PHY_CON31 DeSkew Code for CA
		Outp32( PHY_address+0x0084, 0x60C18306 );	// PHY_CON32 DeSkew Code for CA
		Outp32( PHY_address+0x0088, 0x00000030 );	// PHY_CON33 DeSkew Code for CA

		Outp32( PHY_address+0x0030, 0x10107F10 );	// PHY_CON12 ctrl_start_point	[30:24]=0x10, ctrl_inc[22:16]=0x10, ctrl_force[14:8]=0x7F, ctrl_start[6]=1, ctrl_dll_on[5]=0, ctrl_ref	[4:1]=0x8

		// Setting PHY_CON12 later
		// 6. Set ctrl_dll_on to 0
		// Outp32( PHY_address+0x0030, 0x10107F50); // PHY_CON12 ctrl_start_point	[30:24]=0x10, ctrl_inc[22:16]=0x10, ctrl_force[14:8]=0x7F, ctrl_start[6]=1, ctrl_dll_on[5]=0, ctrl_ref	[4:1]=0x8
		// DMC_Delay(100); // Wait for 10 PCLK cycles

		// 7. Issue dfi_ctrlupd_req for more than 10 cycles
		Outp32( DREX_address+0x0018, 0x00000008); // PHYCONTROL0 assert fp_resync[3]=1(Force DLL Resyncronization)
		// "dfi_ctrlupd_req" should be issued more than 10 cycles after ctrl_dll_on is disabled.
		DMC_Delay(100); // Wait for 10 PCLK cycles
		Outp32( DREX_address+0x0018, 0x00000000); // PHYCONTROL0 deassert fp_resync[3]=1(Force DLL Resyncronization)
	}

	return;
}

void DMC_InitForLPDDR3(u32 nMEMCLK)
{
	u32 data;
	u32 status = __REG(EXYNOS5_POWER_BASE + INFORM1_OFFSET);
	u32 *testbit;
	u32 nLoop;

	/****************************************/
	/*****	        CA SWAP                   *****/
	/****************************************/
	if (CA_SWAP == 1)
	{
		CA_swap_lpddr3(PHY0_BASE);
		CA_swap_lpddr3(PHY1_BASE);
	}

	// Remove because handshaking between DREX and PHY when operate in low frequency(24MHz)
	// DLL LOCK Setting..!
	// DLL_lock_lpddr3(PHY0_BASE, DREX1_0);
	// DLL_lock_lpddr3(PHY1_BASE, DREX1_1);

	// Remove because handshaking between DREX and PHY when operate in low frequency(24MHz)
	// CMU Setting..!
	// Clock = 50MHz
	// Outp32( CMU_MEMPART+0x0114, 0x0020F300); // BPLL_CON1
	// Outp32( CMU_MEMPART+0x0110, 0x80C80305); // BPLL_CON0
	// DMC_Delay(100);

	/****************************************/
	/*****	       CLOCK SETTTING         *****/
	/****************************************/
	//* DREX Pause Disable
	data = Inp32( 0x1003091C );
	data = data&~(0x1<<0);
	Outp32(0x1003091C, data);
	// Lock Time Setting : PDIV * 200
	Outp32( 0x10030010, 0x00000258 );

	// ENABLE(1), MDIV(200), PDIV(3), SDIV(1)
	// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
	// rBPLL_CON0	BPLL=800MHz(3:200:1)
	Outp32( CMU_MEMPART+0x0110, 0x80C80301);

	// PLL locking indication
	// 0 = Unlocked
	// 1 = Locked
	while ((Inp32(0x10030110) & (1 << 29)) == 0);

	// ByPass :: BYPASS = 1, bypass mode is enabled - FOUT=FIN
	SetBits(CMU_MEMPART+0x0114, 22, 0x1, 0x1);

	// C2C_CLK_400(1), BPLL(1)
	// uBits =  (1 << 12) | (1 << 0);
	Outp32( CMU_MEMPART+0x0200, 0x00001001);	// rCLK_SRC_CDREX

	// CLK_MUX_STAT_CDREX Check
	// Opened by cju, 13.01.16
	do {
		data = Inp32(0x10030400) & (7 << 0);
	} while (data != 0x2);

	// Opened by cju
	#if 1
	// ByPass :: BYPASS = 1, bypass mode is Disabled - FOUT=BPLL FOUT
	SetBits(0x10030114, 22, 0x1, 0x0);
	DMC_Delay(200);

	//* Add CLK_DIV_CDREX0, PCLK_CDREX(28:1/2),SCLK_CDREX(24:1/8),ACLK_CDREX1(16:1/2),CCLK_DREX(8:1/2),CLK2X_PHY0(3:1/1)
	data=(1<<28)|(7<<24)|(1<<16)|(1<<8)|(0<<3);
	Outp32(0x10030500, data);
	#else
	//* Add CLK_DIV_CDREX0, PCLK_CDREX(28:1/2),SCLK_CDREX(24:1/8),ACLK_CDREX1(16:1/2),CCLK_DREX(8:1/2),CLK2X_PHY0(3:1/1)
	data=(1<<28)|(7<<24)|(1<<16)|(1<<8)|(0<<3);
	Outp32(0x10030500, data);
	#endif

	/****************************************/
	/*****	     LOW FREQUENCY            *****/
	/****************************************/
	// PHY0+DREX1_0
	Low_frequency_init_lpddr3(PHY0_BASE, DREX1_0);
	// PHY1+DREX1_1
	Low_frequency_init_lpddr3(PHY1_BASE, DREX1_1);

	/****************************************/
	/*****	  CLOCK SETTTING              *****/
	/****************************************/
	if (nMEMCLK==400)
	{
		// ENABLE(1), MDIV(200), PDIV(3), SDIV(1)
		// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
		Outp32( CMU_MEMPART+0x0110, 0x80C80301); // rBPLL_CON0	BPLL=800MHz(3:200:1)
		DMC_Delay(100);

		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(1/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (1 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x31010100);		// rCLK_DIV_CDREX0
		DMC_Delay(100);
	}
	else if (nMEMCLK==533)
	{
		// ENABLE(1), MDIV(266), PDIV(3), SDIV(2)
		// uBits = (1 << 31) | (266 << 16) | (3 << 8) | (2 << 0);
		Outp32( CMU_MEMPART+0x0110, 0x810A0302);		// rBPLL_CON0	BPLL=533MHz(3:266:2)
		DMC_Delay(100);

		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}
	else if (nMEMCLK==666)
	{
		// ENABLE(1), MDIV(222), PDIV(4), SDIV(1)
		// uBits = (1 << 31) | (266 << 16) | (4 << 8) | (1 << 0);
		Outp32( CMU_MEMPART+0x0110, 0x80DE0401);	// rBPLL_CON0	BPLL=666MHz(4:222:1)
		DMC_Delay(100);

		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}
	else if (nMEMCLK==732)
	{
		// ENABLE(1), MDIV(122), PDIV(2), SDIV(1)
		// uBits = (1 << 31) | (122 << 16) | (2 << 8) | (1 << 0);
		Outp32( CMU_MEMPART+0x0110, 0x807A0201);	// rBPLL_CON0	  BPLL=732MHz(2:122:1)
		DMC_Delay(100);

		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}
	else if (nMEMCLK==800)
	{
		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}
#ifdef CONFIG_CPU_EXYNOS5410_EVT2
	else if (nMEMCLK==933)
	{
		// ENABLE(1), MDIV(200), PDIV(3), SDIV(1)
		// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
		Outp32( CMU_MEMPART+0x0110, 0x80E90301);	// rBPLL_CON0	BPLL=933MHz(3:233:1)
		DMC_Delay(100);

		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}
	else if (nMEMCLK==1065)
	{
		// ENABLE(1), MDIV(200), PDIV(3), SDIV(1)
		// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
		Outp32( CMU_MEMPART+0x0110, 0x81630401);	// rBPLL_CON0	BPLL=1065MHz(4:355:1)
		DMC_Delay(100);

		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}
#endif
	else
	{
		// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
		// value to keep synchronization between two DREXs and BUS.
		// PCLK_CDREX(1/4), SCLK_CDREX(0/2), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
		// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
		Outp32( CMU_MEMPART+0x0500, 0x30010100);	// rCLK_DIV_CDREX0

		DMC_Delay(100);
	}


	/****************************************/
	/*****	       HIGH FREQUENCY         *****/
	/****************************************/
	// PHY0+DREX1_0
	High_frequency_init_lpddr3(PHY0_BASE, DREX1_0,nMEMCLK);
	// PHY1+DREX1_1
	High_frequency_init_lpddr3(PHY1_BASE, DREX1_1,nMEMCLK);

	#if 0
	if (status == S5P_CHECK_SLEEP) {
		// (5) DRAM PAD Retention Release
		// - PAD_RETENTION_DRAM_CONFIGURATION
		// 0x1004_3000[0] = 0x1
		testbit = (u32 *)(0x10043000);
		*testbit = 0x1;
		while(*(testbit+1) != 0x00001);

		// (6) setup CMU for DDR self-refresh Exit
		// - CLK_GATE_BUS_CDREX
		// 0x10030700[7:6] = 0x3
		data = Inp32( 0x10030700 );
		data = data & (~0x00000C0);
		data = data | 0x00000C0;
		Outp32( 0x10030700, data);

		// (7) LPI Masking ¼³Á¤
		// LPI_MASK0[0x1004_0004] = 0x7000
		// LPI_MASK1[0x1004_0008] = 0x30
		// LPI_MASK2[0x1004_000C] = 0x0
		// LPI_NOC_MASK0[0x1004_159C] = 0x0
		// LPI_NOC_MASK1[0x1004_15A0] = 0x0
		// LPI_NOC_MASK1[0x1004_15A4] = 0x0
		Outp32( 0x10040004, 0x00007000);
		Outp32( 0x10040008, 0x00000030);
		Outp32( 0x1004000C, 0x00000000);
		Outp32( 0x1004159C, 0x00000000);
		Outp32( 0x100415A0, 0x00000000);
		Outp32( 0x100415A4, 0x00000000);

		#if 1	// Adding..! 2012.11.30
		Outp32( DREX1_0+0x0010, 0x07000000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		Outp32( DREX1_1+0x0010, 0x07000000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		if(NUM_CHIP == 1)	{
			Outp32( DREX1_0+0x0010, 0x07100000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
			Outp32( DREX1_1+0x0010, 0x07100000); // 0x7 = NOP (exit from active/precharge power down or deep power down,
		}
		#endif

		#if 0
		DMC_Delay(1000);

		for(nLoop=0;nLoop<10;nLoop++)	{
			Outp32( DREX1_0+0x0010, 0x05000000);	// 0x5 = REFA (auto refresh),
			Outp32( DREX1_1+0x0010, 0x05000000);	// 0x5 = REFA (auto refresh),
			if(NUM_CHIP == 1)	{
				Outp32( DREX1_0+0x0010, 0x05100000); // 0x5 = REFA (auto refresh),
				Outp32( DREX1_1+0x0010, 0x05100000); // 0x5 = REFA (auto refresh),
			}
		}
		#endif
	}
	#endif

	#if 1	// Move..! 2012.11.30
	// 26. Set the ConControl to turn on an auto refresh counter.
	// aref_en[5]=Auto Refresh Counter. 0x1 = Enable
	// 2012.11.08 :: rd_fetch 3 -> 2
	Outp32( DREX1_0+0x0000, 0x0FFF2128); // CONCONTROL aref_en[5]=1
	Outp32( DREX1_1+0x0000, 0x0FFF2128); // CONCONTROL aref_en[5]=1
	#endif

	// For 100MHz & 200MHz..!
	if(nMEMCLK == 100)
	{
		Outp32( CMU_MEMPART+0x0500, 0x37010100); //CLK_DIV_CDREX0 SCLK_CDREX_RATIO[26:24]=2
		DMC_Delay(100);
	}
	else if (nMEMCLK == 200)
	{
		Outp32( CMU_MEMPART+0x0500, 0x33010100); //CLK_DIV_CDREX0 SCLK_CDREX_RATIO[26:24]=7
		DMC_Delay(100);
	}

	// BRB Space Reservation Setting..!
#if defined(CONFIG_BTS_SUPPORT)
	Outp32( DREX1_0+0x0100, 0x00000033);	// BRBRSVCONTROL
	Outp32( DREX1_0+0x0104, 0x88588858); 	// BRBRSVCONFIG
	Outp32( DREX1_1+0x0100, 0x00000033); 	// BRBRSVCONTROL
	Outp32( DREX1_1+0x0104, 0x88588858); 	// BRBRSVCONFIG
	Outp32( DREX1_0+0x00D8, 0x00000000); 	// QOSCONTROL
	Outp32( DREX1_0+0x00C0, 0x00000080); 	// QOSCONTROL
	Outp32( DREX1_0+0x0108, 0x00000001); 	// BRBQOSCONFIG
	Outp32( DREX1_1+0x00D8, 0x00000000); 	// QOSCONTROL
	Outp32( DREX1_1+0x00C0, 0x00000080); 	// QOSCONTROL
	Outp32( DREX1_1+0x0108, 0x00000001); 	// BRBQOSCONFIG
#else
	Outp32( DREX1_0+0x0100, 0x00000033);	// BRBRSVCONTROL
	Outp32( DREX1_0+0x0104, 0x88778877);	// BRBRSVCONFIG
	Outp32( DREX1_1+0x0100, 0x00000033);	// BRBRSVCONTROL
	Outp32( DREX1_1+0x0104, 0x88778877);	// BRBRSVCONFIG
#endif
	{
			u32 nLockR, nLockW;

			// ;; Pause Enable...!
			// Closed by cju, 13.01.16
			#if 0
			Outp32( 0x1003091C, 0xFFF8FFFF);
			#endif
#if 0
			// ;; Lock value..!
			nLockR = Inp32(PHY0_BASE+0x0034);
			nLockW = (nLockR & 0x0001FC00) >> 2;
			nLockR = Inp32(PHY0_BASE+0x0030);
			nLockR = nLockR & (~0x00007F00);
			nLockW = nLockW | nLockR;
			Outp32( PHY0_BASE+0x0030, nLockW);

			nLockR = Inp32(PHY1_BASE+0x0034);
			nLockW = (nLockR & 0x0001FC00) >> 2;
			nLockR = Inp32(PHY1_BASE+0x0030);
			nLockR = nLockR & (~0x00007F00);
			nLockW = nLockW | nLockR;
			Outp32( PHY1_BASE+0x0030, nLockW);
#endif
			// ;; SDLL Power..!
			// ;; Phycontrol0.sl_dll_dyn_con
			Outp32( DREX1_0+0x0018, 0x00000002);
			Outp32( DREX1_1+0x0018, 0x00000002);
	}

	return;
}


void mem_ctrl_init()
{
	u32 nMEMCLK;
#if defined(MCLK_CDREX_800)
	nMEMCLK = 800;
#elif defined(MCLK_CDREX_400)
	nMEMCLK = 400;
#endif

	/* CMU_MEMPART reset */
	// Outp32( CMU_MEMPART+0x0A10, 0x00000001);
	// DMC_Delay(10000);
	// Outp32( CMU_MEMPART+0x0A10, 0x00000000);
	// DMC_Delay(10000);



#if defined(CONFIG_LPDDR3)
	DMC_InitForLPDDR3(nMEMCLK);
#elif defined(CONFIG_LPDDR2)
	DMC_InitForLPDDR2(nMEMCLK);
#elif defined(CONFIG_DDR3)
	DMC_InitForDDR3(nMEMCLK);
#endif

}

