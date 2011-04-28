#ifndef __AML_BOOT_TIMING_H
#define __AML_BOOT_TIMING_H
#ifndef __ASSEMBLY__
struct ddr_set{
        unsigned short cl; // cas latency
        unsigned short t_faw;
        unsigned short t_mrd;
        unsigned short t_1us_pck;
        unsigned short t_100ns_pck;
        unsigned short t_init_us;
        unsigned short t_rsth_us;
		unsigned short t_rstl_us;
        unsigned short t_ras;
        unsigned short t_rc;
        unsigned short t_rcd;
        unsigned short t_refi_100ns;
        unsigned short t_rfc;
        unsigned short t_rp;
        unsigned short t_rrd;
        unsigned short t_rtp;
        unsigned short t_wr;
        unsigned short t_wtr;
        unsigned short t_xp;
		unsigned short t_xpdll;
        unsigned short t_xsrd;       // init to 0 so that if only one of them is defined, this is chosen
        unsigned short t_xsnr;
        unsigned short t_exsr;
        unsigned short t_al;     // Additive Latency
        unsigned short t_clr;    // cas_latency for DDR2 (nclk cycles)
        unsigned short t_dqs;    // distance between data phases to different ranks  
        unsigned short t_cwl;     // cas write latency.
        unsigned short t_mod;     // MRS command  
        unsigned short t_zqcl;    // ZQ calibration long period in clock cycles.
        unsigned short t_cksrx;   // CKE maintained high before issuing self refresh command. 
        unsigned short t_cksre;   // Time after Self Refresh Entry that CKE is heold high before going low. 
        unsigned short t_cke;     // CKE minimum pulse width in memory clock cycles. 
        unsigned short t_rtw;
        unsigned short t_ccd;
        unsigned short pad;  
        unsigned short mrs[4];
        unsigned       mcfg;      //PCTL mcfg
        unsigned       cmdzq;
        unsigned       zq0cr0;
        unsigned       zq0cr1;    //PUB_ZQ0CR1
        unsigned char  t_dxccr_dqsres; //PUB_DXCCR[8:5]: DQS resister. DQSRES[3]: 0 - pull down, 1-pull up;DQSRES[2:0]:odt resister
        unsigned char  t_dxccr_dqsnres;//PUB_DXCCR[12:9]: DQS# resiste
        unsigned char  t_acbdlr_ck0bd; //PUB_ACBDLR[5:0]: ck0 bit delay
        unsigned char  t_acbdlr_acbd;  //PUB_ACBDLR[23:18]: address/command bit delay
        unsigned       ddr_ctrl;
        unsigned       ddr_pll_cntl;
        unsigned       ddr_clk;
        int            (* init_pctl)(struct ddr_set *);  
}__attribute__ ((packed));
struct pll_clk_settings{
	/*
	 * SYS_PLL setting:
	 * 24MHz: [30]:PD=0, [29]:RESET=0, [17:16]OD=1, [13:9]N=1, [8:0]M=50, PLL_FOUT= (24*(50/1))/2 = 600MHz
	 * 25MHz: [30]:PD=0, [29]:RESET=0, [17:16]OD=1, [13:9]N=1, [8:0]M=48, PLL_FOUT= (25*(48/1))/2 = 600MHz
	 */
	unsigned sys_pll_cntl;	//sys_pll_cntl2,sys_pll_cntl23,sys_pll_cntl24 are fixed
	unsigned sys_clk_cntl;	//
	unsigned sys_clk;
	unsigned a9_clk;
	
	
	unsigned other_pll_cntl;
	unsigned mpeg_clk_cntl;
	unsigned other_clk;
	
	unsigned spi_setting;
	unsigned nfc_cfg;
	unsigned sdio_cmd_clk_divide;
	unsigned sdio_time_short;//0x90
	unsigned demod_pll400m_cntl;
	unsigned uart;

	unsigned clk81;	
	
}__attribute__ ((packed));

//M6 all pll controler use bit 29 as reset bit
#define M6TV_PLL_RESET(pll) \
	Wr(pll,Rd(pll) | (1<<29));

//wait for pll lock
//must wait first (100us+) then polling lock bit to check
#define M6TV_PLL_WAIT_FOR_LOCK(pll) \
	do{\
		__udelay(1000);\
	}while((Rd(pll)&0x80000000)==0);

//M6TV PLL control value 
#define M6TV_PLL_CNTL_CST2 (0x814d3928)
#define M6TV_PLL_CNTL_CST3 (0x6b425012)
#define M6TV_PLL_CNTL_CST4 (0x101)
#define M6TV_PLL_CNTL_CST5 (0x08550d20)
#define M6TV_PLL_CNTL_CST6 (0x04515400)

#define M6TV_PLL_CNTL_CST12 (0x04294000)
#define M6TV_PLL_CNTL_CST13 (0x026e1250)
#define M6TV_PLL_CNTL_CST14 (0x06278410)
#define M6TV_PLL_CNTL_CST15 (0xbf)
#define M6TV_PLL_CNTL_CST16 (0xacac10ac)
#define M6TV_PLL_CNTL_CST17 (0x0108c000)


//DDR PLL
#define M6TV_DDR_PLL_CNTL_2 (M6TV_PLL_CNTL_CST2)
#define M6TV_DDR_PLL_CNTL_3 (M6TV_PLL_CNTL_CST3)
#define M6TV_DDR_PLL_CNTL_4 (M6TV_PLL_CNTL_CST4)

//SYS PLL
#define M6TV_SYS_PLL_CNTL_2 (M6TV_PLL_CNTL_CST2)
#define M6TV_SYS_PLL_CNTL_3 (M6TV_PLL_CNTL_CST3)
#define M6TV_SYS_PLL_CNTL_4 (M6TV_PLL_CNTL_CST4)

//AUDIO PLL
#define M6TV_AUD_PLL_CNTL_2 (M6TV_PLL_CNTL_CST2)
#define M6TV_AUD_PLL_CNTL_3 (M6TV_PLL_CNTL_CST3)
#define M6TV_AUD_PLL_CNTL_4 (M6TV_PLL_CNTL_CST4)
#define M6TV_AUD_PLL_CNTL_5 (M6TV_PLL_CNTL_CST5)
#define M6TV_AUD_PLL_CNTL_6 (M6TV_PLL_CNTL_CST6)

//VID PLL
#define M6TV_VID_PLL_CNTL_2 (M6TV_PLL_CNTL_CST2)
#define M6TV_VID_PLL_CNTL_3 (M6TV_PLL_CNTL_CST3)
#define M6TV_VID_PLL_CNTL_4 (M6TV_PLL_CNTL_CST4)

//FIXED PLL/Multi-phase PLL
#define M6TV_MPLL_CNTL_2 (M6TV_PLL_CNTL_CST12)
#define M6TV_MPLL_CNTL_3 (M6TV_PLL_CNTL_CST13)
#define M6TV_MPLL_CNTL_4 (M6TV_PLL_CNTL_CST14)
#define M6TV_MPLL_CNTL_5 (M6TV_PLL_CNTL_CST15)
#define M6TV_MPLL_CNTL_6 (M6TV_PLL_CNTL_CST16)
#define M6TV_MPLL_CNTL_7 (M6TV_PLL_CNTL_CST17)
#define M6TV_MPLL_CNTL_8 (M6TV_PLL_CNTL_CST17)
#define M6TV_MPLL_CNTL_9 (M6TV_PLL_CNTL_CST17)
#define M6TV_MPLL_CNTL_10 (0)

#endif
#endif
