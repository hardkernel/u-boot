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
        unsigned       dllcr;
        unsigned       iocr;
        unsigned       ddr_ctrl;
        unsigned       ddr_pll_cntl;//400M for DDR 800 , 333M for DDR667
        unsigned       ddr_clk;
        int            (* init_pctl)(struct ddr_set *);
}__attribute__ ((packed));
struct pll_clk_settings{
	unsigned sys_pll_cntl;//0x7c
	unsigned sys_clk_cntl;//0x7c
	unsigned sys_clk;//0x80
	
	
	unsigned other_pll_cntl;
	unsigned mpeg_clk_cntl;
	unsigned other_clk;
	
	unsigned spi_setting;
	unsigned nfc_cfg;
	unsigned sdio_cmd_clk_divide;
	unsigned sdio_time_short;//0x90
	unsigned demod_pll400m_cntl;
	unsigned uart;

}__attribute__ ((packed));

//extern struct ddr_set __ddr_setting;
//extern struct pll_clk_settings __plls;
//extern void ddr_pll_init(struct ddr_set * ddr_setting) ;
//extern unsigned ddr_init (struct ddr_set * ddr_setting);
#endif
#endif
