/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <common.h>

#define Outp32(addr, data) (*(volatile u32 *)(addr) = (data))
#define Inp32(addr) ((*(volatile u32 *)(addr)))

#define CONFIG_DMC_CALIBRATION

void DMC_Delay(u32 x)
{
	dmc_delay(x);
}

void CMU_SetMemClk(u32 nMEMCLK)
{
	volatile u32 uBits;

	// MEM Clock = 800 MHz

	// MCLK_DPHY(0:8), MCLK_CDREX(0:4), BPLL(0:0)
	uBits = (0 << 8) | (0 << 4) | (0 << 0);
	Outp32(0x10030200, uBits);		// rCLK_SRC_CDREX

	// MCLK_DPHY  = 800 / 1 = 800
	// MCLK_CDREX = 800 / 1 = 800
	// ACLK_CDREX = MCLK_CDREX / 2 = 400
	// PCLK_CDREX = 800 / 1 / 6 = 133

	// MCLK_CDREX2(1/1:28), ACLK_SFRTZASCP(1/2:24), MCLK_DPHY(1/1:20), MCLK_CDREX(1/1:16), PCLK_CDREX(1/6:4), ACLK_CDREX(1/2:0)
	uBits = (0 << 28) | (1 << 24) | (0 << 20) | (0 << 16) | (5 << 4) | (1 << 0);
	Outp32(0x10030500, uBits);		// rCLK_DIV_CDREX

	// MPLL(0:8)
	uBits = (1 << 8);
	Outp32(0x10014204, Inp32(0x10014204) & ~uBits);	// rCLK_SRC_CORE1

	// Setting MPLL [P,M,S]
	//
	uBits = (1 << 21) | (3 << 12) | (8 << 8);
	Outp32(0x10014104, uBits);			// rMPLL_CON1

	// ENABLE(1), MDIV(200), PDIV(3), SDIV(0)
	uBits = (1 << 31) | (200 << 16) | (3 << 8) | (0 << 0);	// MPLL=1600MHz(3:200:0)
	Outp32(0x10014100, uBits);			// rMPLL_CON0

	while ((Inp32(0x10014100) & (1 << 29)) == 0);

	// MPLL(1:8)
	uBits = (1 << 8);
	Outp32(0x10014204, Inp32(0x10014204) | uBits);	// rCLK_SRC_CORE1

}

void DMC_CaTraining(int ch)
{
	unsigned char code;
	int find_vmw;
	unsigned int phyBase;
	unsigned int ioRdOffset;
	unsigned int temp, mr41, mr48, vwml, vwmr, vwmc;
	unsigned int lock;


	phyBase = 0x10c00000+(0x10000 * ch);
	ioRdOffset = 0x150 + (0x4 * ch);

	temp = Inp32( phyBase + 0x0000 );
	temp |= (1 << 16);
	Outp32( phyBase + 0x0000, temp );

	temp = Inp32( phyBase + 0x0008 );
	temp |= (1 << 23);
	Outp32( phyBase + 0x0008, temp );

	code = 0x8;
	find_vmw = 0;
	vwml = vwmr = vwmc = 0;

	while (1) {

		//- code update
		temp = Inp32( phyBase + 0x0028 );
		temp &= 0xFFFFFF00;
		temp |= code;
		Outp32( phyBase + 0x0028, temp );

		//- resync
		temp = Inp32( phyBase + 0x0028 );
		temp &= 0xFEFFFFFF;
		Outp32( phyBase + 0x0028, temp );
		temp |= 0x01000000;
		Outp32( phyBase + 0x0028, temp );
		temp &= 0xFEFFFFFF;
		Outp32( phyBase + 0x0028, temp );

		if(ch == 0) {
			Outp32( 0x10DD0000+0x0010, 0x50690 );	//- Send MRW: MA=0x29 OP=0xA4, 0x50690
			//Outp32( 0x10DD0000+0x0010, 0x001050690 );	//- Send MRW: MA=0x29 OP=0xA4, 0x50690
		} else {
			Outp32( 0x10DD0000+0x0010, 0x10050690 );	//- Send MRW: MA=0x29 OP=0xA4, 0x10050690
			//Outp32( 0x10DD0000+0x0010, 0x10150690 );	//- Send MRW: MA=0x29 OP=0xA4, 0x10050690
		}

		Outp32( 0x10DD0000+0x0160, 0x3FF011 );	//- Set DMC.CACAL_CONFIG0.deassert_cke=1
		Outp32( 0x10DD0000+0x0164, 0x1 );		//- Set DMC.CACAL_CONFIG1.cacal_csn=1
		DMC_Delay(0x100);

		mr41 = Inp32( 0x10DD0000 + ioRdOffset );
		mr41 &= 0xFFFF;

		Outp32( 0x10DD0000+0x0160, 0x3FF010 );	//- Set DMC.CACAL_CONFIG0.deassert_cke=0
		DMC_Delay(0x100);

		if( ch == 0 ) {
			Outp32( 0x10DD0000+0x0010, 0x60300 );	//- Send MRW: MA=0x30 OP=0xC0, 0x60300
			//Outp32( 0x10DD0000+0x0010, 0x001060300 );	//- Send MRW: MA=0x30 OP=0xC0, 0x60300
		} else {
			Outp32( 0x10DD0000+0x0010, 0x10060300 );	//- Send MRW: MA=0x30 OP=0xC0, 0x10060300
			//Outp32( 0x10DD0000+0x0010, 0x10160300 );	//- Send MRW: MA=0x30 OP=0xC0, 0x10060300
		}

		Outp32( 0x10DD0000+0x0160, 0x3FF011 );	//- Set DMC.CACAL_CONFIG0.deassert_cke=1
		Outp32( 0x10DD0000+0x0164, 0x1 );		//- Set DMC.CACAL_CONFIG1.cacal_csn=1
		DMC_Delay(0x100);

		mr48 = Inp32( 0x10DD0000 + ioRdOffset );
		mr48 &= 0x0303;

		Outp32( 0x10DD0000+0x0160, 0x3FF010 );	//- Set DMC.CACAL_CONFIG0.deassert_cke=0
		DMC_Delay(0x100);

		if( (find_vmw == 0) && (mr41 == 0x5555 ) && ( mr48 == 0x0101 ) ) {
			find_vmw = 0x1;
			vwml = code;
		}

		if( (find_vmw == 1) && ( (mr41 != 0x5555 ) || ( mr48 != 0x0101 ) ) ) {
			find_vmw = 0x3;
			vwmr = code - 1;

			if( ch == 0 ) {
				Outp32( 0x10DD0000+0x0010, 0x50AA0 );	//- Send MRW: MA=0x2A OP=0xA8, 0x50AA0
				//Outp32( 0x10DD0000+0x0010, 0x001050AA0 );	//- Send MRW: MA=0x2A OP=0xA8, 0x50AA0
			} else {
				Outp32( 0x10DD0000+0x0010, 0x10050AA0 );	//- Send MRW: MA=0x2A OP=0xA8, 0x50AA0
				//Outp32( 0x10DD0000+0x0010, 0x10150AA0 );	//- Send MRW: MA=0x2A OP=0xA8, 0x50AA0
			}
			//DMC_Delay(0x10000);
			break;
		}

		code++;

		if(code == 255) {
			while(1);
		}
	}

	vwmc = (vwml + vwmr) / 2;

#if 1
	{
		u32 lock_force;
		u32 temp = 0;

		lock_force = (Inp32( phyBase + 0x30 ) >> 8) & 0x7F;

		temp = ((vwml & 0xFF) << 16) |
			   ((vwmr & 0xFF) << 8) |
			   ((vwmc & 0xFF));

		if(ch == 0) {
			Outp32(0x10040818, temp);
		}
		else {
			Outp32(0x1004081C, temp);
		}
	}
#endif

	//- code update
	temp = Inp32( phyBase + 0x0028 );
	temp &= 0xFFFFFF00;
	temp |= vwmc;
	Outp32( phyBase + 0x0028, temp );

	//- resync
	temp = Inp32( phyBase + 0x0028 );
	temp &= 0xFEFFFFFF;
	Outp32( phyBase + 0x0028, temp );
	temp |= 0x01000000;
	Outp32( phyBase + 0x0028, temp );
	temp &= 0xFEFFFFFF;
	Outp32( phyBase + 0x0028, temp );

	temp = Inp32( phyBase+0x0000 );
	temp &= 0xFFFEFFFF;
	Outp32( phyBase + 0x0000, temp );

#if 1

	//- vmwc convert to offsetd value.

	lock = Inp32( phyBase + 0x0034 );
	lock &= 0x1FF00;
	lock >>= 8;

	if( (lock & 0x3) == 0x3 ) {
		lock++;
	}

	code = vwmc - (lock >> 2);

	temp = Inp32( phyBase + 0x0028 );
	temp &= 0xFFFFFF00;
	temp |= code;
	Outp32( phyBase + 0x0028, temp );

	temp = Inp32( phyBase + 0x0008 );
	temp &= 0xFF7FFFFF;
	Outp32( phyBase + 0x0008, temp );
#endif
}

void mem_ctrl_init_lpddr3(u32 nMEMCLK)
{
	u32 lock, temp;

	//-
	//-PHASE 1 : PHY DLL Initialization
	//-
	//-2) Set the right value to PHY_CON0.ctrl_ddr_mode
	Outp32( 0x10C00000+0x0000, 0x17021A40 );	//- PHY0.CON0[12:11].ctrl_ddr_mode=LPDDR3
	Outp32( 0x10C10000+0x0000, 0x17021A40 );	//- PHY1.CON0[12:11].ctrl_ddr_mode=LPDDR3
	//-3) Enable CA swap when POP is used
	Outp32( 0x10C00000+0x0000, 0x17021A00 );	//- PHY0.CON0.ctrl_atgate=0x0
	Outp32( 0x10C10000+0x0000, 0x17021A00 );	//- PHY1.CON0.ctrl_atgate=0x0
	Outp32( 0x10030A20, 0x80000000 );	//- LPDDR3PHY_CON3[31]=1.
	Outp32( 0x10C00000+0x0064, 0x1 );	//- PHY0.CON24[0]=1
	Outp32( 0x10C10000+0x0064, 0x1 );	//- PHY0.CON24[0]=1
	//-4) Set PHY for DQS pull-down mode
	Outp32( 0x10C00000+0x0038, 0x0F );	//- PHY0.CON14.ctrl_pulld_dq=0x0, ctrl_pulld_dqs=0x0F
	Outp32( 0x10C10000+0x0038, 0x0F );	//- PHY1.CON14.ctrl_pulld_dq=0x0, ctrl_pulld_dqs=0x0F
	//-5) Set PHY_CON42.ctrl_bstlen and PHY_CON42.ctrl_rdlat
	Outp32( 0x10C00000+0x00ac, 0x80C );	//- PHY0.CON42.ctrl_bstlen[12:8]=0x8, ctrl_rdlat[4:0]=0x0C
	Outp32( 0x10C10000+0x00ac, 0x80C );	//- PHY1.CON42.ctrl_bstlen[12:8]=0x8, ctrl_rdlat[4:0]=0x0C
	Outp32( 0x10C00000+0x006C, 0x7107F );	//- PHY0.CON26.T_wrdata_en[20:16]=0x7
	Outp32( 0x10C10000+0x006C, 0x7107F );	//- PHY1.CON26.T_wrdata_en[20:16]=0x7
	Outp32( 0x10C00000+0x0000, 0x17021A00 );	//- Set PHY0.PHY_CON0.ctrl_read_disable=0x0
	Outp32( 0x10C00000+0x0040, 0x8080304 );	//- Set PHY0.PHY_CON16.zq_term.
	Outp32( 0x10C10000+0x0000, 0x17021A00 );	//- Set PHY1.PHY_CON0.ctrl_read_disable=0x0
	Outp32( 0x10C10000+0x0040, 0x8080304 );	//- Set PHY1.PHY_CON16.zq_term.
	Outp32( 0x10030B00, 0x1 );	//- Set 0x1003_0B00[0]=0x1
	//-6) ZQ calibration
	Outp32( 0x10C00000+0x0040, 0xE0C0304 );	//- Set PHY0.CON16.zq_mode_dds=0x6000000
	Outp32( 0x10C00000+0x0040, 0xE0C0304 );	//- Set PHY0.CON16.zq_manual_mode=1
	Outp32( 0x10C00000+0x0040, 0xE0C0306 );	//- Set PHY0.CON16.zq_manual_str
	while( ( Inp32( 0x10C00000+0x0048 ) & 0x1 ) != 0x1 );	//- Wait for PHY0.CON17.zq_done
	Outp32( 0x10C00000+0x0040, 0xE080304 );	//- Set PHY0.CON16.zq_clk_en=0
	Outp32( 0x10C10000+0x0040, 0xE0C0304 );	//- Set PHY1.CON16.zq_mode_dds=0x6000000
	Outp32( 0x10C10000+0x0040, 0xE0C0304 );	//- Set PHY1.CON16.zq_manual_mode=1
	Outp32( 0x10C10000+0x0040, 0xE0C0306 );	//- Set PHY1.CON16.zq_manual_str
	while( ( Inp32( 0x10C10000+0x0048 ) & 0x1 ) != 0x1 );	//- Wait for PHY1.CON17.zq_done
	Outp32( 0x10C10000+0x0040, 0xE080304 );	//- Set PHY1.CON16.zq_clk_en=0
	Outp32( 0x10C00000+0x00A0, 0xDB6 );	//- PHY0.CON39[11:0]=0xDB6
	Outp32( 0x10C10000+0x00A0, 0xDB6 );	//- PHY1.CON39[11:0]=0xDB6
	//-7) Set CONCONTROL. At this moment, assert the dfi_init_start field to high.
	Outp32( 0x10DD0000+0x0000, 0xFFF2100 );	//- rdfetch=0x2
	Outp32( 0x10DD0000+0x0000, 0x1FFF2100 );	//- assert dfi_init_start
	DMC_Delay(0x10000); //- wait 100ms
	Outp32( 0x10DD0000+0x0000, 0xFFF2100 );	//- deassert dfi_init_start
	//-
	//-PHASE 2 : Setting Controller Register
	//-
	//-8) Set MEMCONTROL. At this moment, switch OFF all low power feature.
	Outp32( 0x10DD0000+0x0004, 0x312700 );	//- memcontrol
	//-9) Set the MEMBASECONFIG0 register.
	//-   If there are two external memory chips set the MEMBASECONFIG1 register.
	Outp32( 0x10DD0000+0x010C, 0x4007C0 );	//- chipbase0=0x40, mask=0x7C0
	Outp32( 0x10DD0000+0x0110, 0x8007C0 );	//- chipbase1=0x80, mask=0x7C0
	Outp32( 0x10DD0000+0x0008, 0x1323 );	//- memconfig0
	Outp32( 0x10DD0000+0x000C, 0x1323 );	//- memconfig1
	//-10) Set the PRECHCONFIG register
	Outp32( 0x10DD0000+0x0014, 0xFF000000 );	//- DMC.PRECHCONFIG[15:0]=(0x0|0x0)
	//-11) Set the TIMINGAREF, TIMINGROW, TIMINGDATA, and TIMINGPOWER registers
	//-    according to memory AC parameters.
	Outp32( 0x10DD0000+0x00F0, 0x7 );	//- iv_size=0x7
	Outp32( 0x10DD0000+0x0030, 0x5D );	//- tREFI=0x5D
	Outp32( 0x10DD0000+0x0034, 0x34498692 );	//- DMC.TIMINGROW=0x34498692
	Outp32( 0x10DD0000+0x0038, 0x3630560C );	//- DMC.TIMINGDATA=0x3630560C
	Outp32( 0x10DD0000+0x003C, 0x50380336 );	//- DMC.TIMINGPOWER=0x50380336
	Outp32( 0x10DD0000+0x0004, 0x312700 );	//-
	//-12) Set the QOSCONTROL0~15 and BRBQOSCONFIG register if Qos Scheme is required.
	Outp32( 0x10DD0000+0x60, 0xFFF );	//- QOS#0.=0xFFF
	Outp32( 0x10DD0000+0x68, 0xFFF );	//- QOS#1.=0xFFF
	Outp32( 0x10DD0000+0x70, 0xFFF );	//- QOS#2.=0xFFF
	Outp32( 0x10DD0000+0x78, 0xFFF );	//- QOS#3.=0xFFF
	Outp32( 0x10DD0000+0x80, 0xFFF );	//- QOS#4.=0xFFF
	Outp32( 0x10DD0000+0x88, 0xFFF );	//- QOS#5.=0xFFF
	Outp32( 0x10DD0000+0x90, 0xFFF );	//- QOS#6.=0xFFF
	Outp32( 0x10DD0000+0x98, 0xFFF );	//- QOS#7.=0xFFF
	Outp32( 0x10DD0000+0xA0, 0xFFF );	//- QOS#8.=0xFFF
	Outp32( 0x10DD0000+0xA8, 0xFFF );	//- QOS#9.=0xFFF
	Outp32( 0x10DD0000+0xB0, 0xFFF );	//- QOS#10.=0xFFF
	Outp32( 0x10DD0000+0xB8, 0xFFF );	//- QOS#11.=0xFFF
	Outp32( 0x10DD0000+0xC0, 0xFFF );	//- QOS#12.=0xFFF
	Outp32( 0x10DD0000+0xC8, 0xFFF );	//- QOS#13.=0xFFF
	Outp32( 0x10DD0000+0xD0, 0xFFF );	//- QOS#14.=0xFFF
	Outp32( 0x10DD0000+0xD8, 0xFFF );	//- QOS#15.=0xFFF
	//-13) Set the PHY_CON4.ctrl_offsetr0~3 and PHY_CON6.ctrl_offsetw0~3 to 0x7F.
	Outp32( 0x10C00000+0x0010, 0x7F7F7F7F );	//- offsetr=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F
	Outp32( 0x10C10000+0x0010, 0x7F7F7F7F );	//- offsetr=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F
	Outp32( 0x10C00000+0x0018, 0x7F7F7F7F );	//- offsetw=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F
	Outp32( 0x10C10000+0x0018, 0x7F7F7F7F );	//- offsetw=0:0x7F, 1:0x7F, 2:0x7F, 3:0x7F
	//-14) Set the PHY_CON4.ctrl_offsetd value to 0x7F.
	Outp32( 0x10C00000+0x0028, 0x7F );	//- offsetd=0x7F
	Outp32( 0x10C10000+0x0028, 0x7F );	//- offsetd=0x7F
	//-15)
	//-16)
	Outp32( 0x10C00000+0x0030, 0x10107F70 );	//- lock forcing=0x7F
	Outp32( 0x10C10000+0x0030, 0x10107F70 );	//- lock forcing=0x7F
	Outp32( 0x10C00000+0x0030, 0x10107F50 );	//- disable ctrl_dll_on
	Outp32( 0x10C10000+0x0030, 0x10107F50 );	//- disable ctrl_dll_on
	DMC_Delay(0x100); //- wait 1ms
	//-18) Update the DLL information.
	Outp32( 0x10DD0000+0x0018, 0x8 );	//- fp_resync=1
	Outp32( 0x10DD0000+0x0018, 0x0 );	//- fp_resync=0
	//-
	//-PHASE 3 : Memory Initialization
	//-
	//-18)~26)
	Outp32( 0x10DD0000+0x0010, 0x7000000 );	//- port:0x0, cs:0x0 nop command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x71C00 );	//- port:0x0, cs:0x0 mr63 command
	DMC_Delay(0x10000); //- wait 100ms
	Outp32( 0x10DD0000+0x0010, 0x10BFC );	//- port:0x0, cs:0x0 mr10 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x50C );	//- port:0x0, cs:0x0 mr1 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x868 );	//- port:0x0, cs:0x0 mr2 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0xC04 );	//- port:0x0, cs:0x0 mr3 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x7100000 );	//- port:0x0, cs:0x1 nop command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x171C00 );	//- port:0x0, cs:0x1 mr63 command
	DMC_Delay(0x10000); //- wait 100ms
	Outp32( 0x10DD0000+0x0010, 0x110BFC );	//- port:0x0, cs:0x1 mr10 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10050C );	//- port:0x0, cs:0x1 mr1 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x100868 );	//- port:0x0, cs:0x1 mr2 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x100C04 );	//- port:0x0, cs:0x1 mr3 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x17000000 );	//- port:0x1, cs:0x0 nop command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10071C00 );	//- port:0x1, cs:0x0 mr63 command
	DMC_Delay(0x10000); //- wait 100ms
	Outp32( 0x10DD0000+0x0010, 0x10010BFC );	//- port:0x1, cs:0x0 mr10 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x1000050C );	//- port:0x1, cs:0x0 mr1 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10000868 );	//- port:0x1, cs:0x0 mr2 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10000C04 );	//- port:0x1, cs:0x0 mr3 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x17100000 );	//- port:0x1, cs:0x1 nop command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10171C00 );	//- port:0x1, cs:0x1 mr63 command
	DMC_Delay(0x10000); //- wait 100ms
	Outp32( 0x10DD0000+0x0010, 0x10110BFC );	//- port:0x1, cs:0x1 mr10 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x1010050C );	//- port:0x1, cs:0x1 mr1 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10100868 );	//- port:0x1, cs:0x1 mr2 command
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10DD0000+0x0010, 0x10100C04 );	//- port:0x1, cs:0x1 mr3 command
	DMC_Delay(0x100); //- wait 1ms
	//-27) Return to the memory operating frequency.
	CMU_SetMemClk(800);

	//-28) Set the PHY_CON4.ctrl_offsetr0~3 and PHY_CON6.ctrl_offsetw0~3 to 0x8.
	Outp32( 0x10C00000+0x0010, 0x8080808 );	//- offsetr=0:0x08, 1:0x08, 2:0x08, 3:0x08
	Outp32( 0x10C10000+0x0010, 0x8080808 );	//- offsetr=0:0x08, 1:0x08, 2:0x08, 3:0x08
	Outp32( 0x10C00000+0x0018, 0x8080808 );	//- offsetw=0:0x08, 1:0x08, 2:0x08, 3:0x08
	Outp32( 0x10C10000+0x0018, 0x8080808 );	//- offsetw=0:0x08, 1:0x08, 2:0x08, 3:0x08
	//-29) Set the PHY_CON4.ctrl_offsetd value to 0x8.
	Outp32( 0x10C00000+0x0028, 0x8 );	//- offsetd=0x08
	Outp32( 0x10C10000+0x0028, 0x8 );	//- offsetd=0x08
	//-30)~34)
	Outp32( 0x10C00000+0x0030, 0x10107F70 );	//- ctrl_dll_on[5] = 1
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10C00000+0x0030, 0x10107F30 );	//- ctrl_start[6] = 0
	Outp32( 0x10C00000+0x0030, 0x10107F70 );	//- ctrl_start[6] = 1
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10C10000+0x0030, 0x10107F70 );	//- ctrl_dll_on[5] = 1
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10C10000+0x0030, 0x10107F30 );	//- ctrl_start[6] = 0
	Outp32( 0x10C10000+0x0030, 0x10107F70 );	//- ctrl_start[6] = 1
	DMC_Delay(0x100); //- wait 1ms
	//-35)~36)
	Outp32( 0x10DD0000+0x0000, 0x1FFF2100 );	//- assert dfi_init_start
	while( ( Inp32( 0x10DD0000+0x0040 ) & 0xC ) != 0xC );	//- Wait for DMC.dfi_init_complete_ch0/1
	Outp32( 0x10DD0000+0x0000, 0xFFF2100 );	//- deassert dfi_init_start
	//-37) Update the DLL information.
	Outp32( 0x10DD0000+0x0018, 0x8 );	//- fp_resync=1
	Outp32( 0x10DD0000+0x0018, 0x0 );	//- fp_resync=0

#if defined(CONFIG_DMC_CALIBRATION)
	//-38) Do leveing and calibration
	//-39) Perform these steps
	//- - a. Update PHYCON12.ctrl_force with by using PHY_CON13.ctrl_lock_value[9:2]
	lock = (Inp32(0x10c00034) >> 8) & 0xFF;
	if((lock & 0x3) == 0x3) {
		lock++;
	}

	temp = Inp32(0x10c00030) & 0xFFFF80FF;
	temp |= ((lock >> 2) << 8);
	Outp32( 0x10c00000 + 0x0030, temp);

	lock = (Inp32(0x10c10034) >> 8) & 0xFF;
	if((lock & 0x3) == 0x3) {
		lock++;
	}

	temp = Inp32(0x10c10030) & 0xFFFF80FF;
	temp |= ((lock >> 2) << 8);
	Outp32( 0x10c10000 + 0x0030, temp);

	//- - b. Enable PHY_CON0.ctrl_atgate
	Outp32( 0x10C00000+0x0000, 0x17021A40 );	//- PHY0.CON0.ctrl_atgate=1.
	Outp32( 0x10C10000+0x0000, 0x17021A40 );	//- PHY1.CON0.ctrl_atgate=1.
	//- - d. Enable PHY_CON0.p0_cmd_en
	Outp32( 0x10C00000+0x0000, 0x17025A40 );	//- PHY0.CON0.p0_cmd_en=1.
	Outp32( 0x10C10000+0x0000, 0x17025A40 );	//- PHY1.CON0.p0_cmd_en=1.
	//- - e. Enable PHY_CON2.InitDeskewEn
	Outp32( 0x10C00000+0x0008, 0x10044 );	//- PHY0.CON2.InitDeskewEn=1.
	Outp32( 0x10C10000+0x0008, 0x10044 );	//- PHY1.CON2.InitDeskewEn=1.
	//- - f. Enable PHY_CON0.byte_rdlvl_en
	Outp32( 0x10C00000+0x0000, 0x17027A40 );	//-
	Outp32( 0x10C10000+0x0000, 0x17027A40 );	//-

	//- - c. Disable PHY_CON12.ctrl_dll_on
	temp = Inp32(0x10c00030) & 0xFFFFFFDF;
	Outp32( 0x10c00030, temp );
	temp = Inp32(0x10c10030) & 0xFFFFFFDF;
	Outp32( 0x10c10030, temp );
	DMC_Delay(0x100); //- wait 1ms

	//-CA Training.
	DMC_CaTraining(0);
	DMC_CaTraining(1);

	//-Read DQ Calibration.
	Outp32( 0x10C00000+0x0004, 0x92100FF );	//- Set PHY0.CON1.rdlvl_rddata_adj
	Outp32( 0x10C10000+0x0004, 0x92100FF );	//- Set PHY1.CON1.rdlvl_rddata_adj
	Outp32( 0x10C00000+0x005C, 0x00000041 );	//- PHY0.CON22.lpddr2_addr=0x041
	Outp32( 0x10C10000+0x005C, 0x00000041 );	//- PHY1.CON22.lpddr2_addr=0x041
	Outp32( 0x10C00000+0x0008, 0x2010044 );	//- Set PHY0.CON2.rdlvl_en
	Outp32( 0x10C10000+0x0008, 0x2010044 );	//- Set PHY1.CON2.rdlvl_en
	Outp32( 0x10DD0000+0x00F8, 0x2 );	//- DMC.RDLVLCONFIG.ctrl_rdlvl_data_en=1
	while( ( Inp32( 0x10DD0000+0x0040 ) & 0xC000 ) != 0xC000 );	//- Wait DMC.rdlvl_complete_ch0/1
	Outp32( 0x10DD0000+0x00F8, 0x0 );	//- Set DMC.RDLVLCONFIG.ctrl_rdlvl_data_en=0

	Outp32(0x10C00000 + 0x0014, 0xC);
	while( Inp32(0x10C00000 + 0x0058) != 0);

	Outp32(0x10C10000 + 0x0014, 0xC);
	while( Inp32(0x10C00000 + 0x0058) != 0);

	Outp32(0x10C00000 + 0x0014, 0x0);
	Outp32(0x10C10000 + 0x0014, 0x0);

#if 1
	//-Write DQ Calibration.
	while( ( Inp32( 0x10DD0000+0x0048 ) & 0x3 ) != 0x0 );	//- Wait for DMC.chip_busy_state CH0
	while( ( Inp32( 0x10DD0000+0x004C ) & 0x3 ) != 0x0 );	//- Wait for DMC.chip_busy_state CH1
	Outp32( 0x10DD0000+0x00F4, 0x1 );	//- DMC.WRTRACONFIG
	Outp32( 0x10C00000+0x005C, 0x204 );	//-
	Outp32( 0x10C10000+0x005C, 0x204 );	//-
	Outp32( 0x10C00000+0x0004, 0x9210001 );	//-Set "rdlvl_rddata_adj" to 0x0001 or 0x0100 in PHY_CON1[15:0]
	Outp32( 0x10C10000+0x0004, 0x9210001 );	//-Set "rdlvl_rddata_adj" to 0x0001 or 0x0100 in PHY_CON1[15:0]
	Outp32( 0x10C00000+0x0008, 0x6010044 );	//-
	Outp32( 0x10C10000+0x0008, 0x6010044 );	//-
	Outp32( 0x10C00000+0x0008, 0xE010044 );	//-
	Outp32( 0x10C10000+0x0008, 0xE010044 );	//-
	while( ( Inp32( 0x10DD0000+0x0040 ) & 0xC000 ) != 0xC000 );	//- Wait DMC.rdlvl_complete_ch0/1
	Outp32( 0x10C00000+0x0008, 0x6010044 );	//-
	Outp32( 0x10C10000+0x0008, 0x6010044 );	//-

	Outp32(0x10C00000 + 0x0014, 0xC);
	while( Inp32(0x10C00000 + 0x0058) != 0);

	Outp32(0x10C10000 + 0x0014, 0xC);
	while( Inp32(0x10C10000 + 0x0058) != 0);

	Outp32(0x10C00000 + 0x0014, 0x0);
	Outp32(0x10C10000 + 0x0014, 0x0);
#endif

#if 1
	//-43) Enable PHY_CON12.ctrl_dll_on
	temp = Inp32( 0x10c00030) | 0x20;
	Outp32( 0x10c00030, temp );
	//while( ( Inp32(0x10c00030) & 0x1 ) != 0x1 );

	temp = Inp32( 0x10c10030) | 0x20;
	Outp32( 0x10c10030, temp );
	//while( ( Inp32(0x10c10030) & 0x1 ) != 0x1 );

#else
	Outp32( 0x10C00000+0x0030, 0x10101A70 );	//- ctrl_dll_on[5] = 1
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10C00000+0x0030, 0x10101A30 );	//- ctrl_start[6] = 0
	Outp32( 0x10C00000+0x0030, 0x10101A70 );	//- ctrl_start[6] = 1
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10C10000+0x0030, 0x10101B70 );	//- ctrl_dll_on[5] = 1
	DMC_Delay(0x100); //- wait 1ms
	Outp32( 0x10C10000+0x0030, 0x10101B30 );	//- ctrl_start[6] = 0
	Outp32( 0x10C10000+0x0030, 0x10101B70 );	//- ctrl_start[6] = 1
	DMC_Delay(0x100); //- wait 1ms
#endif

	//-44) Disable PHY_CON.ctrl_atgate when POP is used
	Outp32( 0x10C00000+0x0000, 0x17027A00 );	//- PHY0.CON0.ctrl_atgate=0x0
	Outp32( 0x10C10000+0x0000, 0x17027A00 );	//- PHY1.CON0.ctrl_atgate=0x0
	Outp32( 0x10C00000+0x0000, 0x17127A00 );	//- Set PHY0.CON0.ctrl_upd_range=0x1
	Outp32( 0x10C10000+0x0000, 0x17127A00 );	//- Set PHY1.CON0.ctrl_upd_range=0x1

	//-45) Enable PHY_CON2.DLLDeSkewEn
	Outp32( 0x10C00000+0x0008, 0x6011044 );	//- PHY0.CON2.DllDeskewEn=1.
	Outp32( 0x10C10000+0x0008, 0x6011044 );	//- PHY1.CON2.DllDeskewEn=1.
	//-46) Update the DLL information
	Outp32( 0x10DD0000+0x0018, 0x8 );	//- fp_resync=1
	Outp32( 0x10DD0000+0x0018, 0x0 );	//- fp_resync=0
#endif
	//-47) ODT is not supported in LPDDR2/LPDDR3
	Outp32( 0x10C00000+0x0000, 0x17127A00 );	//- Set PHY0.PHY_CON0.ctrl_read_disable=0x0
	Outp32( 0x10C00000+0x0040, 0xE080304 );	//- Set PHY0.PHY_CON16.zq_term.
	Outp32( 0x10C10000+0x0000, 0x17127A00 );	//- Set PHY1.PHY_CON0.ctrl_read_disable=0x0
	Outp32( 0x10C10000+0x0040, 0xE080304 );	//- Set PHY1.PHY_CON16.zq_term.
	//-48) Issue the PALL command to memory
	Outp32( 0x10DD0000+0x0010, 0x1000000 );	//- send PALL to port=0x0, cs=0x0
	Outp32( 0x10DD0000+0x0010, 0x1100000 );	//- send PALL to port=0x0, cs=0x1
	Outp32( 0x10DD0000+0x0010, 0x11000000 );	//- send PALL to port=0x1, cs=0x0
	Outp32( 0x10DD0000+0x0010, 0x11100000 );	//- send PALL to port=0x1, cs=0x1
	//-49) Set the MEMCONTROL if power-down modes are required.
	Outp32( 0x10DD0000+0x0004, 0x312710 );	//- DMC.MEMCONTROL.tp_en=1.
	Outp32( 0x10DD0000+0x0014, 0xFF000000 );	//- DMC.PRECHCONFIG.tp_cnt=0xFF
	Outp32( 0x10DD0000+0x0028, 0xFFFF00FF );	//- DMC.PWRDNCONFIG.dsref_cyc=0xFFFF0000
	Outp32( 0x10DD0000+0x0004, 3221296 );	//- Set DMC.MEMCONTROL.dsref_en=32.
	Outp32( 0x10DD0000+0x0028, 0xFFFF00FF );	//- Set DMC.PWRDNCONFIG.dpwrdn_cyc=0xFF
	Outp32( 0x10DD0000+0x0004, 3221298 );	//- Set DMC.MEMCONTROL.dpwrdn_en=2., dpwrdn_type=0x0
	Outp32( 0x10DD0000+0x0004, 3221299 );	//- DMC.MEMCONTROL.clk_stop_en=1.
	Outp32( 0x10DD0000+0x0000, 268378376 );	//- Set DMC.PHYCONTROL.io_pd_con=1.
	Outp32( 0x10DD0000+0x0018, 2 );	//- DMC.PHYCONTROL.sl_dll_dyn_con=1.
	//-50) Set the CONCONTROL to turn on an auto refresh counter.
	Outp32( 0x10DD0000+0x0000, 0xFFF2128 );	//- aref enabled

	mem_ctrl_init_done();

}
