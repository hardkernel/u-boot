/*
 * Copyright@ Samsung Electronics Co. LTD
 *
 * This software is proprietary of Samsung Electronics.
 * No part of this software, either material or conceptual may be copied or distributed, transmitted,
 * transcribed, stored in a retrieval system or translated into any human or computer language in any form by any means,
 * electronic, mechanical, manual or otherwise, or disclosed
 * to third parties without the express written permission of Samsung Electronics.


 * Alternatively, this program is free software in case of open source projec;
 * you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.

 */

#include <common.h>
#include <config.h>
#include <asm/arch/cpu.h>
#include <asm/arch/smc.h>

#define Outp32(addr, data)	(*(volatile u32 *)(addr) = (data))
#define Inp32(addr)		(*(volatile u32 *)(addr))
#define SetBits(uAddr, uBaseBit, uMaskValue, uSetValue) \
		Outp32(uAddr, (Inp32(uAddr) & ~((uMaskValue)<<(uBaseBit))) \
		| (((uMaskValue)&(uSetValue))<<(uBaseBit)))

#define CA_SWAP			1
#define NUM_CHIP		1
#define ZQ_MODE_DDS		6
#define PERFORM_LEVELING	0
#define PHY0_BASE		0x10C00000
#define PHY1_BASE		0x10C10000
#define DREX1_0			0x10C20000
#define DREX1_1			0x10C30000
#define CMU_COREPART		0x10010000
#define CMU_TOPPART		0x10020000
#define CMU_MEMPART		0x10030000
#define TZASC_0			0x10D40000
#define TZASC_1			0x10D50000

#define USED_DYNAMIC_AUTO_CLOCK_GATING		1

#define __REG(x) (*(unsigned int *)(x))

u32 nMEMCLK = 800;
u32 gEvtNum = 0;

enum DMC_SFR
{
	CONCONTROL	= 0x0000,
	MEMCONTROL	= 0x0004,
	MEMCONFIG0	= 0x0008,
	MEMCONFIG1	= 0x000c,
	DIRECTCMD	= 0x0010,
	PRECHCONFIG	= 0x0014,
	PHYCONTROL0	= 0x0018,
	PHYCONTROL1	= 0x001c,
	PHYCONTROL2	= 0x0020,
	PHYCONTROL3	= 0x0024,
	PWRDNCONFIG	= 0x0028,
	TIMINGPZQ	= 0x002c,
	TIMINGAREF	= 0x0030,
	TIMINGROW	= 0x0034,
	TIMINGDATA	= 0x0038,
	TIMINGPOWER	= 0x003c,
	PHYSTATUS	= 0x0040,
	PHYZQCONTROL	= 0x0044,
	CHIP0STATUS	= 0x0048,
	CHIP1STATUS	= 0x004c,
	AREFSTATUS	= 0x0050,
	MRSTATUS	= 0x0054,
	IVCONTROL	= 0x00f0,
};

typedef enum
{
	IRAMOFF_COREOFF_TOPOFF,
}BOOT_STAT;

#define EVT1_POP_2GB_D25	0x1010
#define EVT1_POP_2GB_D35	0x1011
#define EVT1_POP_3GB_D25	0x1020
#define EVT1_SCP		0x1030
#define EVT2_POP_2GB_D25	0x2010
#define EVT2_POP_3GB_D25	0x2020


#define PRODUCT_ID	(0x10000000 + 0x000)
#define PKG_ID		(0x10000000 + 0x004)
#define OPR_MODE	(0x10000000 + 0x008)

#define GetBits(uAddr, uBaseBit, uMaskValue) \
		((Inp32(uAddr)>>(uBaseBit))&(uMaskValue))
#define GetEvtNum()	(GetBits(PRODUCT_ID, 4, 0xf))
#define GetEvtSubNum()	(GetBits(PRODUCT_ID, 0, 0xf))
#define GetPopOption()	(GetBits(PKG_ID, 4, 0x3))
#define GetDdrType()	(GetBits(PKG_ID, 14, 0x1))

void DMC_Delay(u32 x)
{
	while (--x)
		__asm ("NOP");
}

void CA_swap_lpddr3(u32 DREX_address)
{
	u32 data;

	data = Inp32(DREX_address+0x0000);
	data = data&(~0x00000001);
	data = data|(0x00000001);
	Outp32(DREX_address+0x0000, data);

	return;
}

void Low_frequency_init_lpddr3(u32 PHY_address, u32 DREX_address)
{
	u32 data_RST_STAT;
	u32 eBootStat;

	eBootStat = __REG(EXYNOS5_POWER_BASE + INFORM1_OFFSET);

	// Reset Status Check
	data_RST_STAT = Inp32(0x10040404);
	data_RST_STAT = data_RST_STAT & (0x00000C00);

	// 1. To provide stable power for controller and memory device, the controller must assert
	// and hold CKE to a logic low level
	// 2. DRAM mode setting
	Outp32(PHY_address+0x0000, 0x17021A00);	// PHY_CON0 ctrl_ddr_mode[12:11]=3(LPDDR3), ctrl_atgate
						// (automatic gate control-controller drive gate signals)[6]=1

	if ((eBootStat != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	{
		// 3. Force lock values (DLL cannot be locked under 400MHz)
		Outp32(PHY_address+0x0030, 0x10107F50);	// PHY_CON12 ctrl_start_point[30:24]=0x10, ctrl_inc[22:16]=0x10
							// ctrl_force[14:8]=0x7F, ctrl_start[6]=1, ctrl_dll_on[5]=0
							// ctrl_ref[4:1]=0x8
		Outp32(PHY_address+0x0028, 0x0000007F);	// ctrl_offsetd[7:0]=0x7F

		// 4. Set ctrl_offsetr, crtrl_offsetw to 0x7F
		Outp32(PHY_address+0x0010, 0x7F7F7F7F);	// PHY_CON4 ctrl_offsetr, MEM1 Port 0, Read Leveling Manual Value
		Outp32(PHY_address+0x0018, 0x7F7F7F7F);	// PHY_CON6 ctrl_offsetw, MEM1 Port 0, Write Training Manual Value

		// 5. set CA deskew code to 7h'60
		Outp32(PHY_address+0x0080, 0x0C183060);	// PHY_CON31 DeSkew Code for CA
		Outp32(PHY_address+0x0084, 0x60C18306);	// PHY_CON32 DeSkew Code for CA
		Outp32(PHY_address+0x0088, 0x00000030);	// PHY_CON33 DeSkew Code for CA

		// 7. Issue dfi_ctrlupd_req for more than 10 cycles
		Outp32(DREX_address+0x0018, 0x00000008); // PHYCONTROL0 assert fp_resync[3]=1(Force DLL Resyncronization)
		// "dfi_ctrlupd_req" should be issued more than 10 cycles after ctrl_dll_on is disabled.
		DMC_Delay(100); // Wait for 10 PCLK cycles
		Outp32(DREX_address+0x0018, 0x00000000); // PHYCONTROL0 deassert fp_resync[3]=1(Force DLL Resyncronization)

		// 8. Set MemControl. At this moment, all power down modes should be off.
		Outp32(DREX_address+0x0004, 0x00312700);	// MEMCONTROL bl[22:20]=Memory Burst Length 0x3 = 8
								// mem_width[15:12]=Width of Memory Data Bus 0x2 = 32-bit
								// mem_type[11:8]=Type of Memory 0x7 = LPDDR3
	}

	if ((eBootStat != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	{
		// Start :: Adding option for handshaking between DREX and PHY
		// Deasserting the dfi_init_start
		// 2012.11.08 :: rd_fetch 3 -> 2
		// 2013.05.14 :: rd_fetch 3@933MHz
		if (gEvtNum == EVT1_POP_2GB_D25) {
			Outp32(DREX_address+0x0000, 0x1FFF3101); // CONCONTROL dfi_init_start[28]=0 auto refresh not yet.
		} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
				|| (gEvtNum == EVT2_POP_3GB_D25) || (gEvtNum == EVT2_POP_2GB_D25)) {
			Outp32(DREX_address+0x0000, 0x1FFF2101); // CONCONTROL dfi_init_start[28]=0 auto refresh not yet.
		} else {
			Outp32(DREX_address+0x0000, 0x1FFF3101); // CONCONTROL dfi_init_start[28]=0 auto refresh not yet.
		}
		// Disable DLL
		Outp32(PHY_address+0x0030, 0x10107F10); // PHY_CON12
		// End :: Adding option for handshaking between DREX and PHY

		// Direct Command P0 CH0
		// 9. CKE low for tINIT1 and CKE high for tINIT3
		Outp32(DREX_address+0x0010, 0x07000000); // 0x7 = NOP (exit from active/precharge power down or deep power down)
		DMC_Delay(53333); // MIN 200us

		// 10. RESET command to LPDDR3
		// Add :: 2012.11.01 :: Not send reset command when occured by wake-up
		Outp32(DREX_address+0x0010, 0x00071C00);	// 0x0 = MRS/EMRS (mode register setting)
								// MR63_Reset (MA<7:0> = 3FH): MRW only
		// 2013.04.15 :: Check DAI complete..!
		DMC_Delay(267);	// MIN 1us
		do{
			Outp32(DREX_address+0x0010, 0x09000000); // 0x9 = MRR (mode register reading), MR0_Device Information
		}while ((Inp32(DREX_address+0x0054) & (1 << 0)) != 0);  // OP0=DAI (Device Auto-Initialization Status)

		// 12. DRAM ZQ calibration
		Outp32(DREX_address+0x0010, 0x00010BFC);	// 0x0 = MRS/EMRS (mode register setting), MR10_Calibration
								// FFH: Calibration command after initialization
		DMC_Delay(267);	// MIN 1us

		// 13. DRAM parameter settings
		if (gEvtNum == EVT1_POP_2GB_D25) {
			Outp32(DREX_address+0x0010, 0x0000060C); // 0x0 = MRS/EMRS (mode register setting)
								 // MR1_Device Feature
		} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
				||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
			Outp32(DREX_address+0x0010, 0x0000050C); // 0x0 = MRS/EMRS (mode register setting)
								 // MR1_Device Feature
		} else {
			Outp32(DREX_address+0x0010, 0x0000050C); // 0x0 = MRS/EMRS (mode register setting)
								 // MR1_Device Feature
		}
		if (gEvtNum == EVT1_POP_2GB_D25) {
			Outp32(DREX_address+0x0010, 0x00000870); // 0x0 = MRS/EMRS (mode register setting)
								 // MR2_Device Feature
		} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
				||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25))	{
			Outp32(DREX_address+0x0010, 0x00000868); // 0x0 = MRS/EMRS (mode register setting)
								 // MR2_Device Feature
		} else {
			Outp32(DREX_address+0x0010, 0x00000868); // 0x0 = MRS/EMRS (mode register setting)
								 // MR2_Device Feature
		}

		// 14. I/O Configuration :: Drive Strength
		Outp32(DREX_address+0x0010, 0x00000C04);	// MR(3) OP(1)
		DMC_Delay(267);	// MIN 1us
	}

	// Initialization of second DRAM
	if (NUM_CHIP == 1)
	{
		if ((eBootStat != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
		{
			// 9. CKE low for tINIT1 and CKE high for tINIT3
			Outp32(DREX_address+0x0010, 0x07100000);	// 0x7 = NOP (exit from active/precharge power down or
									// deep power down)
			DMC_Delay(53333);	// MIN 200us

			// 10. RESET command to LPDDR3
			// Add :: 2012.11.01 :: Not send reset command when occured by wake-up
			Outp32(DREX_address+0x0010, 0x00171C00);	// 0x0 = MRS/EMRS (mode register setting)
									// MR63_Reset (MA<7:0> = 3FH): MRW only


			// 2013.04.15 :: Check DAI complete..!
			DMC_Delay(267);	// MIN 1us
			do{
				Outp32(DREX_address+0x0010, 0x09100000); // 0x9 = MRR(mode register reading),MR0_Device Information
			}while ((Inp32(DREX_address+0x0054) & (1 << 0)) != 0);  // OP0=DAI (Device Auto-Initialization Status)

			// 12. DRAM ZQ calibration
			Outp32(DREX_address+0x0010, 0x00110BFC);	// 0x0 = MRS/EMRS (mode register setting), MR10_Calibration
									// FFH: Calibration command after initialization
			// 13. Wait for minimum 1us (tZQINIT)
			DMC_Delay(267);	// MIN 1us

			// 13. DRAM parameter settings
			if (gEvtNum == EVT1_POP_2GB_D25) {
				Outp32(DREX_address+0x0010, 0x0010060C); 	// 0x0 = MRS/EMRS (mode register setting)
			} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
					||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25))	{
				Outp32(DREX_address+0x0010, 0x0010050C);	// 0x0 = MRS/EMRS (mode register setting)
			} else {
				Outp32(DREX_address+0x0010, 0x0010050C);	// 0x0 = MRS/EMRS (mode register setting)
			}
			if (gEvtNum == EVT1_POP_2GB_D25) {
				Outp32(DREX_address+0x0010, 0x00100870);	// 0x0 = MRS/EMRS (mode register setting)
			} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
					||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25))	{
				Outp32(DREX_address+0x0010, 0x00100868);	// 0x0 = MRS/EMRS (mode register setting)
			} else {
				Outp32(DREX_address+0x0010, 0x00100868);	// 0x0 = MRS/EMRS (mode register setting)
			}

			// 14. I/O Configuration :: Drive Strength
			Outp32(DREX_address+0x0010, 0x00100C04);	// MR(3) OP(1)
			DMC_Delay(267);	// MIN 1us
		}
	}

	if ((eBootStat != S5P_CHECK_SLEEP) && (data_RST_STAT == 0))
	{
		// Reset SDLL codes
		Outp32(PHY_address+0x0028, 0x00000008); // PHY_CON10 ctrl_offsetd[7:0]=0x8

		// Set ctrl_offsetr, crtrl_offsetw to 0x7F
		Outp32(PHY_address+0x0010, 0x08080808); // PHY_CON4 ctrl_offsetr, MEM1 Port 0, Read Leveling Manual Value
		Outp32(PHY_address+0x0018, 0x08080808); // PHY_CON5 ctrl_offsetw, MEM1 Port 0, Write Training Manual Value

		// set CA deskew code to 7h'60
		Outp32(PHY_address+0x0080, 0x00000000); // PHY_CON31 DeSkew Code for CA
		Outp32(PHY_address+0x0084, 0x00000000); // PHY_CON32 DeSkew Code for CA
		Outp32(PHY_address+0x0088, 0x00000000); // PHY_CON33 DeSkew Code for CA
	}

	return;
}

void High_frequency_init_lpddr3(u32 PHY_address, u32 DREX_address, u32 TZASC_address)
{
#if defined(CONFIG_SMC_CMD)
	reg_arr_t reg_arr;
#endif
	u32 data;
	u32 data_temp;
	u32 eBootStat;

	eBootStat = __REG(EXYNOS5_POWER_BASE + INFORM1_OFFSET);

	// Pulldn and Pullup enable
	// ctrl_pulld_dq[11:8]=Active HIGH signal to down DQ signals. For normal operation this field should be zero.
	// ctrl_pulld_dqs[3:0]=Active HIGH signal to pull-up or down PDQS/NDQS signals.
	Outp32(PHY_address+0x0038, 0x0000000F); // PHY_CON14 ctrl_pulld_dq[11:8]=0x0, ctrl_pulld_dqs[3:0]=0xf

	// ZQ calibration
	// PHY_CON39 :: Driver Strength
	if (ZQ_MODE_DDS == 7)
	{
		Outp32(PHY_address+0x0040, 0x0F040306);
		Outp32(PHY_address+0x00A0, 0x0FFF0FFF);
	}
	else if (ZQ_MODE_DDS == 6)
	{
		Outp32(PHY_address+0x0040, 0x0E040306);
		Outp32(PHY_address+0x00A0, 0x0DB60DB6);
	}
	else if (ZQ_MODE_DDS == 5)
	{
		Outp32(PHY_address+0x0040, 0x0D040306);
		Outp32(PHY_address+0x00A0, 0x0B6D0B6D);
	}
	else if (ZQ_MODE_DDS == 4)
	{
		Outp32(PHY_address+0x0040, 0x0C040306);
		Outp32(PHY_address+0x00A0, 0x09240924);
	}
	else
	{
		Outp32(PHY_address+0x0040, 0x0F040306);
		Outp32(PHY_address+0x00A0 , 0x0FFF0FFF);
	}

	// Checking the completion of ZQ calibration
	// GOSUB Delay 100ms; GOSUB read &PHY_address+0x0048; zq_done[0]=1
	// GOSUB Delay 100ms; GOSUB read &PHY1_BASE+0x0048; zq_done[0]=1
	while((Inp32(PHY_address+0x0048) & 0x00000001) != 0x00000001); // PHY_CON17 zq_done[0]=ZQ Calibration is finished

	// ZQ calibration exit
	data_temp = Inp32(PHY_address+0x0040);
	data_temp = data_temp&(~0x000FFFFF);
	data = data_temp|0x00040304;
	Outp32(PHY_address+0x0040, data); // PHY_CON16 zq_mode_dds[26:24], zq_mode_term[23:21], zq_manual_start[1]=0

	if (gEvtNum == EVT1_POP_2GB_D25) {
		// 1. Set DRAM burst length and READ latency
		Outp32(PHY_address+0x00AC, 0x0000080E); // PHY_CON42 ctrl_bstlen(Burst Length(BL))[12:8]=8
							// ctrl_rdlat(Read Latency(RL))[4:0]=14
		// 2. Set DRAM write latency
		Outp32(PHY_address+0x006C, 0x0009000F); // PHY_CON26 T_wrdata_en[20:16]=WL for DDR3
	} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
			||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
		// 1. Set DRAM burst length and READ latency
		Outp32(PHY_address+0x00AC, 0x0000080C);	// PHY_CON42 ctrl_bstlen(Burst Length(BL))[12:8]=8
							// ctrl_rdlat(Read Latency(RL))[4:0]=12
		// 2. Set DRAM write latency
		Outp32(PHY_address+0x006C, 0x0007000F); // PHY_CON26 T_wrdata_en[20:16]=WL for DDR3
	} else {
		// 1. Set DRAM burst length and READ latency
		Outp32(PHY_address+0x00AC, 0x0000080C); // PHY_CON42 ctrl_bstlen(Burst Length(BL))[12:8]=8
							// ctrl_rdlat(Read Latency(RL))[4:0]=12
		// 2. Set DRAM write latency
		Outp32(PHY_address+0x006C, 0x0007000F); // PHY_CON26 T_wrdata_en[20:16]=WL for DDR3
	}

	// DLL LOCK Setting..!
	// Set the DLL lock parameters
	// [31] ctrl_start_point	[30:24]=0x10 Reserved	[23] ctrl_inc	[22:16]=0x10 ctrl_force	[14:8] ctrl_star
	// [6]=0x1 ctrl_dll_on	[5]=0x1 ctrl_ref	[4:1]=0x8 Reserved	[0]
	Outp32(PHY_address+0x0030, 0x10100030); // PHY_CON12, "ctrl_dll_on[6] = 0"
	DMC_Delay(20); // PCLK 10 cycle.

	Outp32(PHY_address+0x0030, 0x10100070); // PHY_CON12, "ctrl_start[6] = 1"
	DMC_Delay(1);

	// 1. Set the Concontrol. At this moment, an auto refresh counter should be off.
	// 20120511 :: Change dll lock start point.
	// 2012.11.08 :: rd_fetch 3 -> 2
	// 2013.05.14 :: rd_fetch 3@933MHz
	if (gEvtNum == EVT1_POP_2GB_D25) {
		Outp32(DREX_address+0x0000, 0x1FFF3001); // CONCONTROL dfi_init_start[28] timeout_level0[27:16]
							 // rd_fetch[14:12] empty[8] aref_en[5] clk_ratio[2:1]
	} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
			||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
		Outp32(DREX_address+0x0000, 0x1FFF2001); // CONCONTROL dfi_init_start[28] timeout_level0[27:16]
							 // rd_fetch[14:12] empty[8] aref_en[5] clk_ratio[2:1]
	} else {
		Outp32(DREX_address+0x0000, 0x1FFF3001); // CONCONTROL dfi_init_start[28] timeout_level0[27:16]
							 // rd_fetch[14:12] empty[8] aref_en[5] clk_ratio[2:1]
	}
#if defined(CONFIG_SMC_CMD)
	if ((gEvtNum == EVT1_POP_3GB_D25) || (gEvtNum == EVT2_POP_3GB_D25)) {
		reg_arr.set0.addr = TZASC_address+0x0F00;
		reg_arr.set0.val = 0x001007C0;
		reg_arr.set1.addr = TZASC_address+0x0F04;
		reg_arr.set1.val = 0x005007E0;
	} else {
		reg_arr.set0.addr = TZASC_address+0x0F00;
		reg_arr.set0.val = 0x001007E0;
		reg_arr.set1.addr = TZASC_address+0x0F04;
		reg_arr.set1.val = 0x003007E0;
	}

	if (gEvtNum == EVT1_POP_2GB_D25) {
		reg_arr.set2.addr = TZASC_address+0x0F10;
		reg_arr.set2.val = 0x00442323;
		reg_arr.set3.addr = TZASC_address+0x0F14;
		reg_arr.set3.val = 0x00442323;
	} else if (gEvtNum == EVT1_POP_2GB_D35)	{
		reg_arr.set2.addr = TZASC_address+0x0F10;
		reg_arr.set2.val = 0x00402323;
		reg_arr.set3.addr = TZASC_address+0x0F14;
		reg_arr.set3.val = 0x00402323;
	} else if (gEvtNum == EVT1_POP_3GB_D25) {
		reg_arr.set2.addr = TZASC_address+0x0F10;
		reg_arr.set2.val = 0x00402423;
		reg_arr.set3.addr = TZASC_address+0x0F14;
		reg_arr.set3.val = 0x00402323;
	} else if (gEvtNum == EVT2_POP_2GB_D25) {
		reg_arr.set2.addr = TZASC_address+0x0F10;
		reg_arr.set2.val = 0x00402323;
		reg_arr.set3.addr = TZASC_address+0x0F14;
		reg_arr.set3.val = 0x00402323;
	} else if (gEvtNum == EVT2_POP_3GB_D25) {
		reg_arr.set2.addr = TZASC_address+0x0F10;
		reg_arr.set2.val = 0x00402423;
		reg_arr.set3.addr = TZASC_address+0x0F14;
		reg_arr.set3.val = 0x00402323;
	}
	set_secure_reg((u32)&reg_arr, 4);
#else
	// 2. Set the MemConfig0 register. If there are two external memory chips, also set the MemConfig1 register.
	// LPDDR2_P0_CS0 : 32'h2000_000 ~ 32'h27FF_FFFF (4Gbit)
	if ((gEvtNum == EVT1_POP_3GB_D25) || (gEvtNum == EVT2_POP_3GB_D25)) {
		Outp32(TZASC_address+0x0F00, 0x001007C0); // MemBaseConfig0 chip_base[26:16]=0x10, chip_mask[10:0]=0x7C0
		Outp32(TZASC_address+0x0F04, 0x005007E0); // MemBaseConfig1 chip_base[26:16]=0x50, chip_mask[10:0]=0x7E0
	} else {
		Outp32(TZASC_address+0x0F00, 0x001007E0); // MemBaseConfig0 chip_base[26:16]=0x10, chip_mask[10:0]=0x7E0
		Outp32(TZASC_address+0x0F04, 0x003007E0); // MemBaseConfig1 chip_base[26:16]=0x30, chip_mask[10:0]=0x7E0
	}

	// 3. Set the MemConfig0
	// chip_map	[15:12]	Address Mapping Method (AXI to Memory). 0x1 = Interleaved ({row, bank, column, width})
	// chip_col	[11:8]	Number of Column Address Bits. 0x3 = 10 bits
	// chip_row	[7:4]	Number of Row Address Bits. 0x2 = 14 bits
	// chip_bank	[3:0]	Number of Banks. 0x3 = 8 banks
	if (gEvtNum == EVT1_POP_2GB_D25) {
		Outp32(TZASC_address+0x0F10, 0x00442323); // MemConfig0 chip_map[15:12], chip_col[11:8], chip_row[7:4]
		Outp32(TZASC_address+0x0F14, 0x00442323); // MemConfig1 chip_map[15:12], chip_col[11:8], chip_row[7:4]
	} else if (gEvtNum == EVT1_POP_2GB_D35)	{
		Outp32(TZASC_address+0x0F10, 0x00402323); // MemConfig0 chip_map[15:12], chip_col[11:8], chip_row[7:4]
		Outp32(TZASC_address+0x0F14, 0x00402323); // MemConfig1 chip_map[15:12], chip_col[11:8], chip_row[7:4]
	} else if (gEvtNum == EVT1_POP_3GB_D25) {
		Outp32(TZASC_address+0x0F10, 0x00402423); // MemConfig0 chip_map[15:12], chip_col[11:8], chip_row[7:4]
		Outp32(TZASC_address+0x0F14, 0x00402323); // MemConfig1 chip_map[15:12], chip_col[11:8], chip_row[7:4]
	} else if (gEvtNum == EVT2_POP_2GB_D25) {
		Outp32(TZASC_address+0x0F10, 0x00402323); // MemConfig0 chip_map[15:12], chip_col[11:8], chip_row[7:4]
		Outp32(TZASC_address+0x0F14, 0x00402323); // MemConfig1 chip_map[15:12], chip_col[11:8], chip_row[7:4]
	} else if (gEvtNum == EVT2_POP_3GB_D25) {
		Outp32(TZASC_address+0x0F10, 0x00402423); // MemConfig0 chip_map[15:12], chip_col[11:8], chip_row[7:4]
		Outp32(TZASC_address+0x0F14, 0x00402323); // MemConfig1 chip_map[15:12], chip_col[11:8], chip_row[7:4]
	}
#endif

	// 4. Set the PrechConfig and PwrdnConfig registers.
	// 2013.04.18 :: DREX1_0_3 adding..!
	Outp32(DREX_address+0x0014, 0xF0000000); // PrechConfig tp_en[31:28]=Timeout Precharge per Port
	Outp32(DREX_address+0x001C, 0xFFFFFFFF);
	// 2013.05.30 :: Dynamic PD & Dynamic Self Change..!
	Outp32(DREX_address+0x0028, 0x1FFF000D); // PwrdnConfig dsref_cyc[31:16]=Number of Cycles for dynamic self refresh entry.
						 // 0xn = n aclk cycles. Refer to chapter 1.5.3 . Dynamic self refresh

	// 5. Set the TimingAref, TimingRow, TimingData and TimingPower registers.
	// according to memory AC parameters. At this moment, TimingData.w1 and TimingData.r1
	// registers must be programmed according to initial clock frequency.
	// 2012.12.20 :: 3.875 us * 8192 row = 250us
	// 2013.08.08 Hot Temp SW Reset.!
	Outp32(DREX_address+0x0030, 0x0000002E); // TimingAref autorefresh counter @24MHz

	// TimingAref autorefresh counter @24MHz
	if (nMEMCLK==933) {
		Outp32(DREX_address+0x0034, 0x3D6BA815); // TimingRow

		if (gEvtNum == EVT1_POP_2GB_D25)	{
			Outp32(DREX_address+0x0038, 0x4740085E); // TimingData
		} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
				||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
			Outp32(DREX_address+0x0038, 0x4642065C); // TimingData
		} else {
			Outp32(DREX_address+0x0038, 0x4642065C); // TimingData
		}

		Outp32(DREX_address+0x003C, 0x60420447); // TimingPower
	} else if (nMEMCLK==800) {
		Outp32(DREX_address+0x0034, 0x345A96D3); // TimingRow

		if (gEvtNum == EVT1_POP_2GB_D25)	{
			Outp32(DREX_address+0x0038, 0x3730085E); // TimingData
		} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
				||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
			Outp32(DREX_address+0x0038, 0x3630065C); // TimingData
		} else {
			Outp32(DREX_address+0x0038, 0x3630065C); // TimingData
		}

		Outp32(DREX_address+0x003C, 0x50380336); // TimingPower
	} else {
		Outp32(DREX_address+0x0034, 0x3D6BA815); // TimingRow

		if (gEvtNum == EVT1_POP_2GB_D25)	{
			Outp32(DREX_address+0x0038, 0x4740085E); // TimingData
		} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
				||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
			Outp32(DREX_address+0x0038, 0x4642065C); // TimingData
		} else {
			Outp32(DREX_address+0x0038, 0x4642065C); // TimingData
		}

		Outp32(DREX_address+0x003C, 0x60420447); // TimingPower
	}

	// 6. Wait until dfi_init_complete become 1.
	while((Inp32(DREX_address+0x0040) & 0x00000008) != 0x00000008);	// PhyStatus dfi_init_complete[3]=1

	// Deasserting the dfi_init_start
	// 2012.11.08 :: rd_fetch 3 -> 2
	// 2013.05.14 :: rd_fetch 3@933MHz
	if (gEvtNum == EVT1_POP_2GB_D25) {
		Outp32(DREX_address+0x0000, 0x0FFF3001);	// CONCONTROL dfi_init_start[0]=0
	} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
			||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25))	{
		Outp32(DREX_address+0x0000, 0x0FFF2001 );	// CONCONTROL dfi_init_start[0]=0
	} else {
		Outp32(DREX_address+0x0000, 0x0FFF2001);	// CONCONTROL dfi_init_start[0]=0
	}

	// 7. Forcing DLL resynchronization - dfi_ctrlupd_req
	Outp32(DREX_address+0x0018, 0x00000008);	// PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=1
	DMC_Delay(20); // Wait for 10 PCLK cycles, PCLK(200MHz=10clock=50ns), DMC_Delay(40us)
	Outp32(DREX_address+0x0018, 0x00000000);	// PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=0

	//-----------------------------------------------
	//- end_levelings_lpddr3_l
	//-----------------------------------------------
	// ctrl_atgate = 0
	// T_WrWrCmd	[30:24]
	// T_WrRdCmd	[19:17]
	// ctrl_ddr_mode[12:11]		2'b11: LPDDR3
	// ctrl_dfdqs[9]		1'b1: differential DQS
	Outp32(PHY_address+0x0000, 0x17021A00);	// PHY_CON0 byte_rdlvl_en[13]=1, ctrl_ddr_mode[12:11]=01
							//ctrl_atgate[6]=1, Bit Leveling

	if (PERFORM_LEVELING == 1)
	{
		// dfi_ctrlupd_req to make sure ALL SDLL is updated
		// forcing DLL resynchronization - dfi_ctrlupd_req
		Outp32(DREX_address+0x0018, 0x00000008); // PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=1
		DMC_Delay(20); // Wait for 10 PCLK cycles, PCLK(200MHz=10clock=50ns), DMC_Delay(40us)
		Outp32(DREX_address+0x0018, 0x00000000); // PhyControl0 ctrl_shgate[29]=1, fp_resync[3]=0
	}

	// 27. If power down modes are required, set the MemControl register.
	// bl[22:20]=Memory Burst Length 0x3 = 8
	// mem_width[15:12]=Width of Memory Data Bus 0x2 = 32-bit
	// mem_type[11:8]=Type of Memory 0x7 = LPDDR3
	// dsref_en[5]=Dynamic Self Refresh. 0x1 = Enable
	// dpwrdn_en[1]=Dynamic Power Down. 0x1 = Enable
	// clk_stop_en[0]=Dynamic Clock Control. 0x1 = Stops during idle periods.
	#ifdef USED_DYNAMIC_AUTO_CLOCK_GATING
	Outp32(DREX_address+0x0004, 0x00312722); // MemControl bl[22:20]=8, mem_type[11:8]=7, two chip selection
	#else
	Outp32(DREX_address+0x0004, 0x00312723); // MemControl bl[22:20]=8, mem_type[11:8]=7, two chip selection
	#endif

	return;
}

void DMC_InitForLPDDR3()
{
	u32 data;
	u32 eBootStat;
	u32 nLoop;

	eBootStat = __REG(EXYNOS5_POWER_BASE + INFORM1_OFFSET);
	gEvtNum = (GetEvtNum()<<12)|(GetEvtSubNum()<<8)|(GetPopOption()<<4)|(GetDdrType()); // added by plspapa

	if (gEvtNum == EVT1_POP_3GB_D25)
		gEvtNum = EVT1_POP_3GB_D25;
	else if (gEvtNum == EVT2_POP_3GB_D25)
		gEvtNum = EVT2_POP_3GB_D25;
	else if (gEvtNum == EVT2_POP_2GB_D25)
		gEvtNum = EVT2_POP_2GB_D25;
	else
		gEvtNum = EVT1_POP_2GB_D35;

	if (CA_SWAP == 1)
	{
		CA_swap_lpddr3(DREX1_0);
		CA_swap_lpddr3(DREX1_1);
	}

	/* CLOCK SETTTING */

	// DREX Pause Enable
	data = Inp32(0x1003091C);
	data = data | (0x1<<0);
	Outp32(0x1003091C, data);

	// uBits = (1 << 21) | (3 << 14) | (3 << 12) | (3 << 8);
	Outp32(CMU_MEMPART+0x0114, 0x0020F300);	// rBPLL_CON1

	if (nMEMCLK == 800) {
		// Lock Time Setting
		Outp32(0x10030010, 0x00000258);	// PDIV*200 = 3*200
		// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x80C80301);	// rBPLL_CON0
	} else if (nMEMCLK == 933) {
		// Lock Time Setting
		Outp32(0x10030010, 0x00000320);	// PDIV*200 = 4*200
		// uBits = (1 << 31) | (311 << 16) | (3 << 8) | (1 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x81370401);	// rBPLL_CON0
	} else {
		// Lock Time Setting
		Outp32(0x10030010, 0x00000258);	// PDIV*200 = 3*200
		// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x80C80301);	// rBPLL_CON0
	}

	// PLL locking indication
	// 0 = Unlocked
	// 1 = Locked
	while ((Inp32(0x10030110) & (1 << 29)) == 0);

	// ByPass :: BYPASS = 1, bypass mode is enabled - FOUT=FIN
	SetBits(CMU_MEMPART+0x0114, 22, 0x1, 0x1);

	// MUX_MCLK_CDREX(0), BPLL(1)
	// uBits =  (0 << 4) | (1 << 0);
	Outp32(CMU_MEMPART+0x0200, 0x00000001);	// rCLK_SRC_CDREX

	// CLK_MUX_STAT_CDREX Check
	do {
		data = Inp32(0x10030400) & (7 << 0);
	}while (data != 0x2);

	// ByPass :: BYPASS = 1, bypass mode is Disabled - FOUT=BPLL FOUT
	SetBits(0x10030114, 22, 0x1, 0x0);
	DMC_Delay(200);

	// Add CLK_DIV_CDREX0, PCLK_CDREX(28:1/2),SCLK_CDREX(24:1/8)
	// ACLK_CDREX1(16:1/2),CCLK_DREX(8:1/2),CLK2X_PHY0(3:1/1)
	data= (1<<28)|(15<<24)|(1<<16)|(1<<8)|(0<<3);
	Outp32(0x10030500, data);

	/* LOW FREQUENCY */
	Low_frequency_init_lpddr3(PHY0_BASE, DREX1_0);
	Low_frequency_init_lpddr3(PHY1_BASE, DREX1_1);

	/* CLOCK SETTTING */
	if (nMEMCLK==400)
	{
		// Lock Time Setting
		Outp32(0x10030010, 0x00000258);	// PDIV*200 = 3*200

		// ENABLE(1), MDIV(200), PDIV(3), SDIV(1)
		// uBits = (1 << 31) | (200 << 16) | (3 << 8) | (1 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x80C80302); // rBPLL_CON0	BPLL=400MHz(3:200:2)
		DMC_Delay(100);
	}
	else if (nMEMCLK==533)
	{
		// Lock Time Setting
		Outp32(0x10030010, 0x00000258);	// PDIV*200 = 3*200

		// ENABLE(1), MDIV(266), PDIV(3), SDIV(2)
		// uBits = (1 << 31) | (266 << 16) | (3 << 8) | (2 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x810A0302);	// rBPLL_CON0	BPLL=532MHz(3:266:2)
		DMC_Delay(100);
	}
	else if (nMEMCLK==667)
	{
		// Lock Time Setting
		Outp32(0x10030010, 0x00000190);	// PDIV*200 = 2*200

		// ENABLE(1), MDIV(111), PDIV(2), SDIV(1)
		// uBits = (1 << 31) | (111 << 16) | (2 << 8) | (1 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x806F0201);	// rBPLL_CON0	BPLL=666MHz(2:111:1)
		DMC_Delay(100);
	}
	else if (nMEMCLK==733)
	{
		// Lock Time Setting
		Outp32(0x10030010, 0x00000190);	// PDIV*200 = 2*200

		// ENABLE(1), MDIV(122), PDIV(2), SDIV(1)
		// uBits = (1 << 31) | (122 << 16) | (2 << 8) | (1 << 0);
		Outp32(CMU_MEMPART+0x0110, 0x807A0201);	// rBPLL_CON0	  BPLL=732MHz(2:122:1)
		DMC_Delay(100);
	}
	else if (nMEMCLK==800)
	{
		// used previous setting
	}
	else if (nMEMCLK==933)
	{
		// used previous setting
	}
	else if (nMEMCLK==1065)
	{
		// used previous setting
	}
	else
	{
		// used previous setting
	}

	// PLL locking indication
	// 0 = Unlocked
	// 1 = Locked
	while ((Inp32(0x10030110) & (1 << 29)) == 0);

	// ACLK_CDREX1_RATIO and CCLK_DREX0_RATIO should always have same
	// value to keep synchronization between two DREXs and BUS.
	// PCLK_CDREX(1/4), SCLK_CDREX(1/1), ACLK_CDREX1(1/2), CCLK_DREX0(1/2), CLK2X_PHY0(1/1)
	// uBits = (3 << 28) | (0 << 24) | (1 << 16) | (1 << 8) | (0 << 3) ;
	Outp32(CMU_MEMPART+0x0500, 0x30010100); // rCLK_DIV_CDREX0
	DMC_Delay(100);

	/* HIGH FREQUENCY */
	High_frequency_init_lpddr3(PHY0_BASE, DREX1_0, TZASC_0);
	High_frequency_init_lpddr3(PHY1_BASE, DREX1_1, TZASC_1);

	if (eBootStat == S5P_CHECK_SLEEP)
	{
		// (5) DRAM PAD Retention Release
		//  - PAD_RETENTION_DRAM_CONFIGURATION
		//  0x1004_3000[0] = 0x1
		Outp32(0x100431E8, 0x10000000);
		while ((Inp32(0x10043004) & (0x1)) == 0);
	}

	// 26. Set the ConControl to turn on an auto refresh counter.
	// aref_en[5]=Auto Refresh Counter. 0x1 = Enable
	// 2012.11.08 :: rd_fetch 3 -> 2
	// 2013.04.12 :: Automatic control for ctrl_pd in none read state
	// 2013.05.08 :: update_mode[3] :: 0x1 = MC initiated update/acknowledge mode
	// 2013.05.14 :: rd_fetch 3@933MHz
	if (gEvtNum == EVT1_POP_2GB_D25) {
		Outp32(DREX1_0+0x0000, 0x0FFF31A9); // CONCONTROL aref_en[5]=1
		Outp32(DREX1_1+0x0000, 0x0FFF31A9); // CONCONTROL aref_en[5]=1
	} else if ((gEvtNum == EVT1_POP_2GB_D35) || (gEvtNum == EVT1_POP_3GB_D25)
			||(gEvtNum == EVT2_POP_2GB_D25)||(gEvtNum == EVT2_POP_3GB_D25)) {
		Outp32(DREX1_0+0x0000, 0x0FFF31A9); // CONCONTROL aref_en[5]=1
		Outp32(DREX1_1+0x0000, 0x0FFF31A9); // CONCONTROL aref_en[5]=1
	} else {
		Outp32(DREX1_0+0x0000, 0x0FFF31A9); // CONCONTROL aref_en[5]=1
		Outp32(DREX1_1+0x0000, 0x0FFF31A9); // CONCONTROL aref_en[5]=1
	}


	#ifdef USED_DYNAMIC_AUTO_CLOCK_GATING
	// Clock Gating Control Register..!
	Outp32(DREX1_0+0x0008, 0x0000001F);
	Outp32(DREX1_1+0x0008, 0x0000001F);
	#endif

	// BTS DREX1_0 setup
	Outp32(DREX1_0+0x00D8, 0x00000000);
	Outp32(DREX1_0+0x00C0, 0x00000080);
	Outp32(DREX1_0+0x00A0, 0x00000FFF);
	Outp32(DREX1_0+0x0100, 0x00000000);
	Outp32(DREX1_0+0x0104, 0x88588858);
	Outp32(DREX1_0+0x0214, 0x01000604);
	Outp32(DREX1_0+0x0224, 0x01000604);
	Outp32(DREX1_0+0x0234, 0x01000604);
	Outp32(DREX1_0+0x0244, 0x01000604);
	Outp32(DREX1_0+0x0218, 0x01000604);
	Outp32(DREX1_0+0x0228, 0x01000604);
	Outp32(DREX1_0+0x0238, 0x01000604);
	Outp32(DREX1_0+0x0248, 0x01000604);
	Outp32(DREX1_0+0x0210, 0x00000000);
	Outp32(DREX1_0+0x0220, 0x00000000);
	Outp32(DREX1_0+0x0230, 0x00000000);
	Outp32(DREX1_0+0x0240, 0x00000000);

	// BTS DREX1_1 setup
	Outp32(DREX1_1+0x00D8, 0x00000000);
	Outp32(DREX1_1+0x00C0, 0x00000080);
	Outp32(DREX1_1+0x00A0, 0x00000FFF);
	Outp32(DREX1_1+0x0100, 0x00000000);
	Outp32(DREX1_1+0x0104, 0x88588858);
	Outp32(DREX1_1+0x0214, 0x01000604);
	Outp32(DREX1_1+0x0224, 0x01000604);
	Outp32(DREX1_1+0x0234, 0x01000604);
	Outp32(DREX1_1+0x0244, 0x01000604);
	Outp32(DREX1_1+0x0218, 0x01000604);
	Outp32(DREX1_1+0x0228, 0x01000604);
	Outp32(DREX1_1+0x0238, 0x01000604);
	Outp32(DREX1_1+0x0248, 0x01000604);
	Outp32(DREX1_1+0x0210, 0x00000000);
	Outp32(DREX1_1+0x0220, 0x00000000);
	Outp32(DREX1_1+0x0230, 0x00000000);
	Outp32(DREX1_1+0x0240, 0x00000000);

	return;
}

void mem_ctrl_init()
{
	DMC_InitForLPDDR3();
}
