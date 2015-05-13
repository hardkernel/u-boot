
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/ddr/ddr.c
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

#include "ddr_pctl_define.h"
#include "ddr_pub_define.h"
#include "dmc_define.h"
#include "mmc_define.h"
#include "sec_mmc_define.h"
#include <serial.h>

#define SRAM_BASE				0xd9000000
#define SCRATCH0				0xC1107D3C
#define AMR_SCRATCH1			0xC1107D40
#define AMR_SCRATCH2			0xC1107D44
#define AMR_SCRATCH3			0xC1107D48

#define P_AM_ANALOG_TOP_REG1		0xC11081BC
#define P_HHI_MPLL_CNTL5			0xC883C290
#define P_HHI_SYS_PLL_CNTL			0xC883C300

#define wr_reg(addr, data)	(*((volatile unsigned *)addr))=(data)
#define rd_reg(addr)		(*((volatile unsigned *)addr))

/*clear [mask] 0 bits in [addr], set these 0 bits with [value] corresponding bits*/
#define modify_reg(addr, value, mask) wr_reg(addr, ((rd_reg(addr) & (mask)) | (value)))

#define wait_set(addr, loc) do{}while(0 == (rd_reg(addr) & (1<<loc)));
#define wait_clr(addr, loc) do{}while(1 == (rd_reg(addr) & (1<<loc)));

unsigned int ddr_init(void);
unsigned int ddr_init_pll(void);
unsigned int ddr_init_dmc(void);
unsigned int ddr_init_pctl(void);
unsigned int hot_boot(void);
unsigned int ddr_test(void);
void ddr_print_info(void);

extern int console_puts(const char *s);
extern void console_put_hex(unsigned long data,unsigned int bitlen);
extern void console_put_dec(unsigned long data);

unsigned int ddr_init(void){
	/*detect hot boot or cold boot*/
	//if(hot_boot()){
	//	printf("hot boot, skip ddr init!\n");
	//	return 0;
	//}

	ddr_init_pll();
	ddr_init_pctl();
	ddr_init_dmc();
	ddr_print_info();
	return ddr_test();
}

unsigned int ddr_init_pll(void){
	console_puts("ddr pll init start\n");
	wr_reg(P_AM_ANALOG_TOP_REG1, rd_reg(P_AM_ANALOG_TOP_REG1) | (1<<0));
	//wr_reg(P_HHI_MPLL_CNTL5, rd_reg(P_HHI_MPLL_CNTL5) | (1<<0));
	wr_reg(AM_DDR_PLL_CNTL1, 0x1);
	wr_reg(AM_DDR_PLL_CNTL, (0x1 << 29) | (0x1 <<30 ));     // RESET   AND POWER DOWN.
	//wait_set(AM_DDR_PLL_STS, 31);
	wr_reg(AM_DDR_PLL_CNTL, 0x00010885);
	// ENABLE THE DDR DLL CLOCK INPUT FROM PLL.
	wr_reg(DDR_CLK_CNTL, 0xb0000000);
	wr_reg(DDR_CLK_CNTL, 0xb0000000);
	console_puts("ddr pll init done\n");
	return 0;
}

unsigned int ddr_init_dmc(void){
	console_puts("ddr dmc init start\n");

	////CONFIG DMC DDR3 ROW ADDRESS 10 = A13~A0. COL ADDRESS 10 = A9~A0. 2 RANK SUPPORT
	//WR_REG DMC_DDR_CTRL, 0x0002e2e
	wr_reg(DMC_DDR_CTRL, ( (1 << 21) | (1<<6) | (0x4 << 3)|0x4));

	//// ENABLE THE DMC AUTO REFRESH FUNCTION
	wr_reg(DMC_REFR_CTRL2, 0x20109A27);
	wr_reg(DMC_REFR_CTRL1, 0x80389F);

	wr_reg(DMC_PCTL_LP_CTRL, 0x44062);
	wr_reg(DDR0_APD_CTRL, 0x45);
	wr_reg(DDR0_CLK_CTRL, 0x5);

	//CONFIG DMC security register to enable the all reqeust can access all DDR region.
	wr_reg(DMC_SEC_RANGE_CTRL, 0x0 );
	wr_reg(DMC_SEC_CTRL, 0x80000000 );
	wr_reg(DMC_SEC_AXI_PORT_CTRL, 0x55555555);
	wr_reg(DMC_DEV_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_DEV_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_GE2D_SEC_CTRL, 0x15);
	wr_reg(DMC_PARSER_SEC_CTRL, 0x5);
	wr_reg(DMC_VPU_SEC_CFG, 0xffffffff);
	wr_reg(DMC_VPU_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_VPU_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_VDEC_SEC_CFG, 0xffffffff);
	wr_reg(DMC_VDEC_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_VDEC_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_HCODEC_SEC_CFG, 0xffffffff);
	wr_reg(DMC_HCODEC_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_HCODEC_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_HEVC_SEC_CFG, 0xffffffff);
	wr_reg(DMC_HEVC_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_HEVC_SEC_READ_CTRL, 0x55555555 );

	//// ENABLE THE DC_REQS.
	wr_reg(DMC_REQ_CTRL, 0xFFFF);

	// SCRATCH1
	wr_reg(0xC1107d40, 0xbaadf00d);

	// PUT SOME CODE HERE TO TRY TO STOP BUS TRAFFIC
	__asm__ volatile("NOP");
	__asm__ volatile("DMB SY");
	__asm__ volatile("ISB");

	//  REMAP THE ADDRESS SPACE BY WRITING TO NIC400 REMAP REGISTER
/*
	wr_reg(0xC1300000, 0x00000001);
	__asm__ volatile("ISB");
	__asm__ volatile("DMB SY");
*/
	//change PL310 address filtering to allow DRAM reads to go to M1
	//writel(0xbff00000, 0xc4200c04);
	//writel(0x00000001, 0xc4200c00);

	//remap_zero_address();
	//console_puts("skip remap\n");
	console_puts("ddr dmc init done\n");
	return 0;
}

unsigned int ddr_init_pctl(void){
console_puts("ddr pctl init start\n");
	// RELEASE THE DDR DLL RESET PIN.
	wr_reg(DMC_SOFT_RST, 0xFFFFFFFF);
	wr_reg(DMC_SOFT_RST1, 0xFFFFFFFF);

	// ENABLE UPCTL AND PUB CLOCK AND RESET.
	//@@@ enable UPCTL and PUB clock and reset.
	wr_reg(DMC_PCTL_LP_CTRL, 0x550620);
	wr_reg(DDR0_SOFT_RESET, 0xf);

	// INITIALIZATION PHY.
	// FOR SIMULATION TO REDUCE THE INIT TIME.
	wr_reg(DDR0_PUB_PTR0, ( 6 | (320 << 6) | (80 << 21)));
	wr_reg(DDR0_PUB_PTR1, (120 | (1000 << 16)));
	wr_reg(DDR0_PUB_PTR3, (20000 | (136 << 20)));
	wr_reg(DDR0_PUB_PTR4, (1000 | (80 << 16)));

	// CONFIGURE DDR PHY PUBL REGISTERS.
	wr_reg(DDR0_PUB_ODTCR, 0xfd0a58da);

	// PROGRAM PUB MRX REGISTERS.
	wr_reg(DDR0_PUB_MR0, (0x0 | (0x0 << 2) | (0x0 << 3) | (0x6 << 4) | (0x0 << 7) | (0x0 << 8) | (0x6 << 9) | (1 << 12)));
	wr_reg(DDR0_PUB_MR1, (0x6|(1<<6)));
	wr_reg(DDR0_PUB_MR2, 0x18);
	wr_reg(DDR0_PUB_MR3, 0x0);

	// PROGRAM DDR SDRAM TIMING PARAMETER.
	                     //TRTP  TWTR          TRP          TRAS         TRRD        TRCD
    wr_reg(DDR0_PUB_DTPR0, (6 | (6 << 4) | ( 10 << 8) | (28 << 16) | (6 << 22) | (10 << 26)) );
                         //TMOD        TFAW         TRFC         TWLMRD        TWLO     TAOND
    wr_reg(DDR0_PUB_DTPR1, ( 4 | (0 << 2) | (32 << 5) | (128 << 11) | (40 << 20) | (6 << 26)  | ( 0 << 30) ) );

	wr_reg(DDR0_PUB_PGCR2, 0xf05f97);
	wr_reg(DDR0_PUB_PGCR3, 0xc0aaf860);
	wr_reg(DDR0_PUB_DXCCR, 0x00181884);

                         //TXS     TXP          TDLLK        TRTODT ADDITIONAL TRTW ADDITIONAL. TCCD ADDITIONAL.
	wr_reg(DDR0_PUB_DTPR2, ( 512 | ( 5 << 10) | ( 512 << 19) | ( 0<<29 ) | ( 0 << 30 )  | ( 0 << 31 )));
                                           //tRC       //tCKE         //tMRD      //tAOFDx
	wr_reg(DDR0_PUB_DTPR3, (0 | 0 << 3 | ( 38 << 6) |  ( 4 << 13) | ( 512 << 18) | ( 0<<29 ) ));
	wr_reg(DDR0_PUB_DTCR, 0x43003087);

	//DDR0_DLL_LOCK_WAIT
	wait_set(DDR0_PUB_PGSR0, 0);

	wr_reg(DDR0_PUB_PGCR1, 0x0380c6a0);
	wr_reg(DDR0_PUB_DTCR, 0x430030c7);
	wr_reg(DDR0_PUB_DTPR3, 0x2010a902);
	wr_reg(DDR0_PUB_ACIOCR1, 0);
	wr_reg(DDR0_PUB_ACIOCR2, 0);
	wr_reg(DDR0_PUB_ACIOCR3, 0);
	wr_reg(DDR0_PUB_ACIOCR4, 0);
	wr_reg(DDR0_PUB_ACIOCR5, 0);
	wr_reg(DDR0_PUB_DX0GCR1, 0);
	wr_reg(DDR0_PUB_DX0GCR2, 0);
	wr_reg(DDR0_PUB_DX0GCR3, 0);
	wr_reg(DDR0_PUB_DX1GCR1, 0);
	wr_reg(DDR0_PUB_DX1GCR2, 0);
	wr_reg(DDR0_PUB_DX1GCR3, 0);
	wr_reg(DDR0_PUB_DX2GCR1, 0);
	wr_reg(DDR0_PUB_DX2GCR2, 0);
	wr_reg(DDR0_PUB_DX2GCR3, 0);
	wr_reg(DDR0_PUB_DX3GCR1, 0);
	wr_reg(DDR0_PUB_DX3GCR2, 0);
	wr_reg(DDR0_PUB_DX3GCR3, 0);

	//   2:0   011: DDR0_ MODE.   100:   LPDDR2 MODE.
	//   3:    8 BANK.
	//   7;    MPR FOR DATA TRAINING.
	wr_reg(DDR0_PUB_DCR, 0X8B);

	wr_reg(DDR0_PUB_DTAR0, (0X0 | (0X0 <<12) | (7 << 28)));
	wr_reg(DDR0_PUB_DTAR1, (0X8 | (0X0 <<12) | (7 << 28)));
	wr_reg(DDR0_PUB_DTAR2, (0X10 | (0X0 <<12) | (7 << 28)));
	wr_reg(DDR0_PUB_DTAR3, (0X18 | (0X0 <<12) | (7 << 28)));

	//// DDR PHY INITIALIZATION
	wr_reg(DDR0_PUB_PIR, 0X581);
	wr_reg(DDR0_PUB_DSGCR, 0x020641f);

	//DDR0_SDRAM_INIT_WAIT :
	wait_set(DDR0_PUB_PGSR0, 0);
	//DDR0_SDRAM_INIT_WAIT1 :
	wait_set(DDR0_PUB_PGSR0, 0);
	//DDR0_SDRAM_INIT_WAIT2 :
	wait_set(DDR0_PUB_PGSR0, 0);

	// configure DDR0 IP.
	wr_reg(DDR0_PCTL_TOGCNT1U, 400);
	wr_reg(DDR0_PCTL_TOGCNT100N, 40);
	wr_reg(DDR0_PCTL_TINIT, 2); //20
	wr_reg(DDR0_PCTL_TRSTH, 2); //50
#ifdef CONFIG_1T
	wr_reg(DDR0_PCTL_MCFG, 0XA2F21);
#else
	wr_reg(DDR0_PCTL_MCFG, 0XA2F29);
#endif
	wr_reg(DDR0_PCTL_MCFG1, 0X80000000);

	// MONITOR DFI INITIALIZATION STATUS.
	//DDR0_DFI_INIT_WAIT
	wait_set(DDR0_PCTL_DFISTSTAT0, 0);
	wr_reg(DDR0_PCTL_POWCTL, 1);

	//DDR0_POWER_UP_WAIT
	wait_set(DDR0_PCTL_POWSTAT, 0);
	wr_reg(DDR0_PCTL_TRFC, 128);
	wr_reg(DDR0_PCTL_TREFI_MEM_DDR3, 4);
	wr_reg(DDR0_PCTL_TMRD, 4);
	wr_reg(DDR0_PCTL_TRP, 10);
	wr_reg(DDR0_PCTL_TAL, 0);
	wr_reg(DDR0_PCTL_TCWL, 8);
	wr_reg(DDR0_PCTL_TCL, 10);
	wr_reg(DDR0_PCTL_TRAS, 28);
	wr_reg(DDR0_PCTL_TRC, 38);
	wr_reg(DDR0_PCTL_TRCD, 10);
	wr_reg(DDR0_PCTL_TRRD, 6);
	wr_reg(DDR0_PCTL_TRTP, 6);
	wr_reg(DDR0_PCTL_TWR, 12);
	wr_reg(DDR0_PCTL_TWTR, 6);
	wr_reg(DDR0_PCTL_TEXSR, 512);
	wr_reg(DDR0_PCTL_TXP, 5);
	wr_reg(DDR0_PCTL_TDQS, 4);
	wr_reg(DDR0_PCTL_TRTW, 4);
	wr_reg(DDR0_PCTL_TCKSRE, 8);
	wr_reg(DDR0_PCTL_TCKSRX, 8);
	wr_reg(DDR0_PCTL_TMOD, 12);
	wr_reg(DDR0_PCTL_TCKE, 4);
	wr_reg(DDR0_PCTL_TZQCS, 64);
	wr_reg(DDR0_PCTL_TZQCL, 136);
	wr_reg(DDR0_PCTL_TXPDLL, 20);
	wr_reg(DDR0_PCTL_TZQCSI, 1000);
	wr_reg(DDR0_PCTL_SCFG, 0xF01);
	wr_reg(DDR0_PCTL_SCTL, 1);

	// SCRATCH1
	wr_reg(0xC1107d40, 0xdeadbeef);

	// NEW HIU
	wr_reg(0xC883c010, 0x88776655);

	//DDR0_STAT_CONFIG_WAIT
	wait_set(DDR0_PCTL_STAT, 0);

	wr_reg(DDR0_PCTL_PPCFG, (0xF0 << 1));
	wr_reg(DDR0_PCTL_DFISTCFG0, 0x4 );
	wr_reg(DDR0_PCTL_DFISTCFG1, 0x1 );
	wr_reg(DDR0_PCTL_DFITCTRLDELAY, 2);
	wr_reg(DDR0_PCTL_DFITPHYWRDATA, 1);
	wr_reg(DDR0_PCTL_DFITPHYWRLAT, 2 );

	wr_reg(DDR0_PCTL_DFITRDDATAEN, 3 );
	wr_reg(DDR0_PCTL_DFITPHYRDLAT, 16);
	wr_reg(DDR0_PCTL_DFITDRAMCLKDIS, 1);
	wr_reg(DDR0_PCTL_DFITDRAMCLKEN, 1);
	wr_reg(DDR0_PCTL_DFITCTRLUPDMIN, 0x4000);
	wr_reg(DDR0_PCTL_DFILPCFG0, ( 1 | (3 << 4) | (1 << 8) | (3 << 12) | (7 <<16) | (1 <<24) | ( 3 << 28)) );
	wr_reg(DDR0_PCTL_DFITPHYUPDTYPE1, 0x200);

	wr_reg(DDR0_PCTL_DFIODTCFG, 8 );
	wr_reg(DDR0_PCTL_DFIODTCFG1, ( 0x0 | (0x6 << 16)) );

	wr_reg(DDR0_PCTL_CMDTSTATEN, 1);

	//DDR0_CMD_TIMER_WAIT
	wait_set(DDR0_PCTL_CMDTSTAT, 0);

	////APB_WR(PCTL_PCTL_SCTL, 2); // INIT: 0, CFG: 1, GO: 2, SLEEP: 3, WAKEUP: 4
	wr_reg(DDR0_PCTL_SCTL, 2);

	////WHILE ((APB_RD(DDR0_PCTL_STAT) & 0x7 ) != 3 ) {}
	//DDR0_STAT_GO_WAIT:
	wait_set(DDR0_PCTL_STAT, 1);

	console_puts("ddr pctl init done\n");
	return 0;
}

unsigned int ddr_test(void){
	console_puts("ddr test start\n");
	unsigned long addr = 0;
	unsigned int tmp_data = 0;
	//for(addr = 0x0; addr < 0x80000000; addr+=0x1000000){
	for (addr = 0x30000000; addr < 0x40000000; addr+=0x1000000) {
		//console_put_hex(addr, 32);
		//console_puts("\n");
		wr_reg(addr, 0xabcdef00);
		tmp_data = rd_reg(addr);
		if (tmp_data != (unsigned int)0xabcdef00) {
			console_puts("ddr test error!!\n");
			return -1;
		}
	}
	console_puts("ddr test done. pass.\n");
	return 0;
}

void ddr_print_info(void){
	unsigned int dmc_reg = rd_reg(DMC_DDR_CTRL);
	unsigned int chl0_size = (dmc_reg & 0x7) << 9;
	console_puts("ddr0 size: ");
	console_put_dec(chl0_size);
	console_puts("MB\n");
	//unsigned int chl1_size = ((dmc_reg >> 3) & 0x7) << 9;
	//console_puts("ddr1 size: ");
	//console_put_dec(chl0_size);
	//console_puts("MB\n");
}

unsigned int hot_boot(void){
	if (((rd_reg(SCRATCH0) >> 24) & 0xFF) == 0x11) {
		/*hot boot*/
		return 0;
	}
	else{
		return 1;
	}
}