#ifndef __AML_BOOT_TIMING_H__
#define __AML_BOOT_TIMING_H__

#ifndef __ASSEMBLY__
struct ddr_set{
	unsigned       ddr_test;
	unsigned       phy_memory_start;
	unsigned       phy_memory_size;
	unsigned       t_pub0_dtar;
	unsigned       t_pub1_dtar;
	unsigned       t_ddr_apd_ctrl;	
	unsigned       t_ddr_clk_ctrl;	
	
	unsigned short t_pctl_1us_pck;   //PCTL TOGCNT1U
	unsigned short t_pctl_100ns_pck; //PCTL TOGCNT100N
	unsigned short t_pctl_init_us;   //PCTL TINIT
	unsigned short t_pctl_rsth_us;   //PCTL TRSTH
	unsigned short t_pctl_rstl_us;   //PCTL TRSTL

	unsigned short t_pad1;        //padding for 4 bytes alignment
	unsigned       t_pctl_mcfg;   //PCTL MCFG
	unsigned       t_pctl_mcfg1;  //PCTL MCFG1

	unsigned       t_pub_zq0pr;	  //PUB ZQ0PR
	unsigned       t_pub_dxccr;	  //PUB DXCCR

	unsigned       t_pub_acbdlr0; //PUB ACBDLR0

	unsigned       t_pub_dcr;     //PUB DCR
	unsigned short t_pub_mr[4];   //PUB MR0-3		
	unsigned       t_pub_dtpr[4]; //PUB DTPR0-3
	unsigned       t_pub_pgcr2;   //PUB PGCR2
	unsigned       t_pub_dtcr;    //PUB DTCR
	unsigned       t_pub_ptr[5];  //PUB PTR0-3	
	unsigned       t_pub_aciocr;  //PUB ACIOCR		
	unsigned       t_pub_dsgcr;   //PUB DSGCR

	unsigned short t_pctl_trefi;  //PCTL TREFI
	unsigned short t_pctl_trefi_mem_ddr3; //PCTL TREFI MEM DDR3
	unsigned short t_pctl_tmrd;   //PCTL TMRD 2..4
	unsigned short t_pctl_trfc;   //PCTL TRFC 36..374
	unsigned short t_pctl_trp;    //PCTL TRP  0
	unsigned short t_pctl_tal;    //PCTL TAL 0,CL-1,CL-2
	unsigned short t_pctl_tcwl;   //PCTL TCWL 
	unsigned short t_pctl_tcl;    //PCTL TCL
	unsigned short t_pctl_tras;   //PCTL TRAS 15..38
	unsigned short t_pctl_trc;    //PCTL TRC   20..52
	unsigned short t_pctl_trcd;   //PCTL TRCD 5..14
	unsigned short t_pctl_trrd;   //PCTL TRRD 4..8
	unsigned short t_pctl_trtp;   //PCTL TRTP 3..8
	unsigned short t_pctl_twr;    //PCTL TWR  6..16
	unsigned short t_pctl_twtr;   //PCTL TWTR 3..8
	unsigned short t_pctl_texsr;  //PCTL TEXSR 512
	unsigned short t_pctl_txp;    //PCTL TXP  1..7
	unsigned short t_pctl_tdqs;   //PCTL TDQS 1..12
	unsigned short t_pctl_trtw;   //PCTL TRTW 2..10
	unsigned short t_pctl_tcksre; //PCTL TCKSRE 5..15
	unsigned short t_pctl_tcksrx; //PCTL TCKSRX 5..15
	unsigned short t_pctl_tmod;   //PCTL TMOD 0..31
	unsigned short t_pctl_tcke;   //PCTL TCKE 3..6
	unsigned short t_pctl_tzqcs;  //PCTL TZQCS 64
	unsigned short t_pctl_tzqcl;  //PCTL TZQCL 0..1023
	unsigned short t_pctl_txpdll; //PCTL TXPDLL 3..63
	unsigned short t_pctl_tzqcsi; //PCTL TZQCSI 0..4294967295
	unsigned short t_pctl_scfg;   //PCTL 
	
	unsigned       t_mmc_ddr_ctrl;
	unsigned       t_ddr_pll_cntl;
	unsigned       t_ddr_clk;
	unsigned       t_mmc_ddr_timming0;
	unsigned       t_mmc_ddr_timming1;
	unsigned       t_mmc_ddr_timming2;
	unsigned       t_mmc_arefr_ctrl;
	int            (* init_pctl)(struct ddr_set *);
}__attribute__ ((packed));
struct pll_clk_settings{
	unsigned sys_pll_cntl;	//HHI_SYS_PLL_CNTL	       0x10c0
	unsigned sys_clk_cntl;	//HHI_SYS_CPU_CLK_CNTL0	0x1067
	unsigned sys_clk_cntl1;	//HHI_SYS_CPU_CLK_CNTL1	0x1057
	unsigned sys_clk;
	unsigned a9_clk;
	unsigned mpll_cntl;
	unsigned mpeg_clk_cntl;
	unsigned vid_pll_cntl;
	unsigned vid2_pll_cntl;
	unsigned spi_setting;
	unsigned nfc_cfg;
	unsigned sdio_cmd_clk_divide;
	unsigned sdio_time_short;
	unsigned uart;
	unsigned clk81;
	unsigned gp_pll_cntl;
	unsigned gp2_pll_cntl;
}__attribute__ ((packed));

//M8 pll controler use bit 29 as reset bit
#define PLL_ENTER_RESET(pll) \
	Wr_cbus(pll,Rd_cbus(pll)|(1<<29));

#define PLL_RELEASE_RESET(pll) \
	Wr_cbus(pll, Rd_cbus(pll)&(~(1<<29)));

#define PLL_DISABLE(pll) \
	Wr_cbus(pll, Rd_cbus(pll)&(~(1<<30)));

#define PLL_ENABLE(pll) \
	Wr_cbus(pll, Rd_cbus(pll)|(1<<30));

//M8 PLL enable: bit 30 ; 1-> enable;0-> disable
#define PLL_SETUP(pll,set) \
	Wr_cbus(pll,(set) |(1<<29) |(1<<30));\
	__udelay(1000); //wait 1ms for PLL lock

//wait for pll lock
//must wait first (100us+) then polling lock bit to check
#define PLL_WAIT_FOR_LOCK(pll) \
	do{\
		__udelay(1000);\
	}while((Rd_cbus(pll)&0x80000000)==0);


#define MAX_PLL_TRY_TIMES (4)

//m8 pll init retry check, it will do watch reset 
//after try MAX_PLL_TRY_TIMES times
#define PLL_LOCK_CHECK(counter,type) \
	    __udelay(500); \
		counter++; \
		if(counter > 1){ \
			serial_puts("\npll_times "); \
			serial_put_dec(type); \
			serial_puts(" : "); \
			serial_put_dec(counter); \
			if(counter>MAX_PLL_TRY_TIMES){ \
				serial_puts(__FILE__); \
				serial_puts(__FUNCTION__); \
				serial_put_dword(__LINE__); \				
				AML_WATCH_DOG_START(); \
			} \
		}


//M8 PLL control value 

//DDR PLL > 1G
#define CFG_DDR_PLL_CNTL_2 (0x59C88000)
#define CFG_DDR_PLL_CNTL_3 (0xCA463823)
#define CFG_DDR_PLL_CNTL_4 (0x0286A027)
#define CFG_DDR_PLL_CNTL_5 (0x00003800)
#define CFG_DDR_PLL_CNTL_5_M8M2 (0x00003000)


//DDR PLL < 1G
//#define CFG_DDR_PLL_CNTL_2 (0x59C88000)
//#define CFG_DDR_PLL_CNTL_3 (0xCA45B823)
//#define CFG_DDR_PLL_CNTL_4 (0x0286A023)
//#define CFG_DDR_PLL_CNTL_5 (0x00003800)

//SYS PLL	> 2g
//#define CFG_SYS_PLL_CNTL_2 (0x59C88000)
//#define CFG_SYS_PLL_CNTL_3 (0xCA463823)
//#define CFG_SYS_PLL_CNTL_4 (0x0001D407)
//#define CFG_SYS_PLL_CNTL_5 (0x00000870)

//SYS PLL	< 2g
#define CFG_SYS_PLL_CNTL_2 (0x5ac82000)
#define CFG_SYS_PLL_CNTL_3 (0x8e452015)
#define CFG_SYS_PLL_CNTL_4 (0x0001d40c)
#define CFG_SYS_PLL_CNTL_5 (0x00000870)

//VID PLL > 2.5g
//#define CFG_VID_PLL_CNTL_2 (0x59C8C000)
//#define CFG_VID_PLL_CNTL_3 (0xCE49C022)
//#define CFG_VID_PLL_CNTL_4 (0x0123B100)
//#define CFG_VID_PLL_CNTL_5 (0x00012385)

//VID PLL 1.7g < VID < 2.5g
//#define CFG_VID_PLL_CNTL_2 (0x59C8C000)
//#define CFG_VID_PLL_CNTL_3 (0xCA493822)
//#define CFG_VID_PLL_CNTL_4 (0x0123B100)
//#define CFG_VID_PLL_CNTL_5 (0x00012385)

//VID PLL < 1.7g
#define CFG_VID_PLL_CNTL_2 (0x59C8C000)
#define CFG_VID_PLL_CNTL_3 (0xCA49B022)
#define CFG_VID_PLL_CNTL_4 (0x0023B100)
#define CFG_VID_PLL_CNTL_5 (0x00012385)

//VID2 PLL > 2.5G
//#define CFG_VID2_PLL_CNTL_2 (0x0431A000)
//#define CFG_VID2_PLL_CNTL_3 (0xCE49C022)
//#define CFG_VID2_PLL_CNTL_4 (0xD4000D67)
//#define CFG_VID2_PLL_CNTL_5 (0x01700101)

//VID2 PLL 1.7G < VID2 < 2.5G
//#define CFG_VID2_PLL_CNTL_2 (0x0431A800)
//#define CFG_VID2_PLL_CNTL_3 (0xCA49B823)
//#define CFG_VID2_PLL_CNTL_4 (0xD4000D67)
//#define CFG_VID2_PLL_CNTL_5 (0x01700101)

//VID2 PLL < 1.7G
#define CFG_VID2_PLL_CNTL_2 (0x0431A800)
#define CFG_VID2_PLL_CNTL_3 (0xCA45B823)
#define CFG_VID2_PLL_CNTL_4 (0xD4000D67)
#define CFG_VID2_PLL_CNTL_5 (0x01700001)

//FIXED PLL/Multi-phase PLL	= 2.55g(FIXED)
#define CFG_MPLL_CNTL_2 (0x59C80000)
#define CFG_MPLL_CNTL_3 (0xCA45B822)
#define CFG_MPLL_CNTL_4 (0x00014007)
#define CFG_MPLL_CNTL_5 (0xB5500E1A)
#define CFG_MPLL_CNTL_6 (0xF4454545)
#define CFG_MPLL_CNTL_7 (0)
#define CFG_MPLL_CNTL_8 (0)
#define CFG_MPLL_CNTL_9 (0)

#define CFG_GP_PLL_CNTL_2 (CFG_DDR_PLL_CNTL_2)
#define CFG_GP_PLL_CNTL_3 (CFG_DDR_PLL_CNTL_3)
#define CFG_GP_PLL_CNTL_4 (CFG_DDR_PLL_CNTL_4)
#define CFG_GP_PLL_CNTL_5 (CFG_DDR_PLL_CNTL_5_M8M2)

#endif //__ASSEMBLY__
#endif //__AML_BOOT_TIMING_H__
