//the original file name is m6tv_mmc.h
//change all m6tv to m8

#ifndef __M8_MMC_H__
#define __M8_MMC_H__

#define MMC_Wr(addr,data) *(volatile unsigned long *) (addr) = data
#define MMC_Rd(addr) *(volatile unsigned long *) (addr)
//#define writel(v,c) *(volatile unsigned long *) (c) = v
//#define readl(c)    *(volatile unsigned long *) (c)

#define AM_DDR_PLL_CNTL     0xc8000400
#define AM_DDR_PLL_CNTL1    0xc8000404
#define AM_DDR_PLL_CNTL2    0xc8000408
#define AM_DDR_PLL_CNTL3    0xc800040c
#define AM_DDR_PLL_CNTL4    0xc8000410
#define AM_DDR_PLL_STS      0xc8000414
  //bit 31. DDR_PLL lock.
  // bit 6:0.  DDR_PLL analog output for test. 

#define P_DDR_CLK_CNTL     0xc8000418
  //bit 31     ddr_pll_clk enable. enable the clock from DDR_PLL to clock generateion. 
  // whenever change the DDR_PLL frequency, disable the clock, after the DDR_PLL locked, then enable it again. 
  //bit 30.    ddr_pll_prod_test_en.  enable the clock to clock/32 which to clock frequency measurement and production test pin.
  //bit 29.    clock setting update. becasue the register is in PCLK domain. use this pin to update the clock divider setting.
  //bit 28.    clock generation logic soft reset. 0 = reset.
  //bit 15:8   second level divider control.
  //bit 15.    second level divider clock selection. 0 : from first stage clock divider. 1: from second stage clock divider.
  //bit 14.    enable the  first stage clock output to the second stage clock output. 
  //bit 13.    second stage clock counter enable.
  //bit 12.    enable the second stage divider clock ouput. 
  //bit 11.    enable the 4xclk to DDR PHY. 
  //bit 8.     second stage divider selection. 0: /2.  1: /4.
  //bit 7:0.   first stage clock control.   
  //bit 7.     first stage clock selection. 0 : DDR_PLL clock output.  1: divider.
  //bit 6.     pll_clk_en.  enable the pll clock output to the first stage clock output selection.
  //bit 3.     first stage clock counter enable.
  //bit 2.     first stage clock divider output enable.
  //bit 1:0.   00:  /2.  01: /4. 10: /8. 11: /16.
  
#define P_DDR_CLK_STS      0xc800041c
  //not used.
  

#define  P_DDR0_CLK_CTRL    0xc8000800
//bit 9. invert the DDR PHY n_clk.   ( RF mode).
//bit 8. disable the DDR PHY n_clk.
//bit 7. not used. 
//bit 6. force to disable PUB n_clk. 
//bit 5. PUB auto clock gating enable. when the IP detected PCTL enter power down mode, use this bit to gating PUB n_clk.
//bit 4. force to disable PCTL n_clk.
//bit 3.  PCTL n_clk auto clock gating enable.  when the IP detected PCTL enter power down mode, use this bit to gating pctl n_clk.
//bit 2. force to disable PUB PCLK. 
//bit 1. PUB pclk auto clock gating enable.  when the IP detected PCTL enter power down mode,  use this bit to gating pub pclk. 
//bit 0   PCTL PCLK enable.   When never configure PCTL register, we need to enable the APB clock 24 cycles earlier. after finished configure PCTL, 24 cycles later, we should disable this bit to save power.
#define  P_DDR0_SOFT_RESET  0xc8000804
//bit 3. pub n_clk domain soft reset.  1 active.
//bit 2. pub p_clk domain soft reset.
//bit 1. pctl n_clk domain soft reset.
//bit 0. pctl p_clk domain soft reset.
#define  P_DDR0_APD_CTRL    0xc8000808
//bit 15:8.   power down enter latency. when IP checked the dfi_lp_req && dfi_lp_ack,  give PCTL and pub additional latency let them settle down, then gating the clock.
//bit 7:0.  no active latency.  after c_active_in become to low, wait additional latency to check the pctl low power state.  

#define  P_DDR0_PCTL_SCFG           0xc8000000
#define  P_DDR0_PCTL_SCTL           0xc8000004
#define  P_DDR0_PCTL_STAT           0xc8000008
#define  P_DDR0_PCTL_INTRSTAT       0xc800000c
#define  P_DDR0_PCTL_POWSTAT        0xc8000048
#define  P_DDR0_PCTL_MRRSTAT0       0xc8000064
#define  P_DDR0_PCTL_CMDTSTAT       0xc800004c
#define  P_DDR0_PCTL_MCMD           0xc8000040
#define  P_DDR0_PCTL_MRRSTAT1       0xc8000068
#define  P_DDR0_PCTL_MRRCFG0       0xc8000060
#define  P_DDR0_PCTL_CMDTSTATEN       0xc8000050
#define  P_DDR0_PCTL_POWCTL       0xc8000044
#define  P_DDR0_PCTL_PPCFG       0xc8000084
#define  P_DDR0_PCTL_LPDDR23ZQCFG       0xc800008c
#define  P_DDR0_PCTL_MCFG1       0xc800007c
#define  P_DDR0_PCTL_MSTAT       0xc8000088
#define  P_DDR0_PCTL_MCFG       0xc8000080
#define  P_DDR0_PCTL_DTUAWDT       0xc80000b0
#define  P_DDR0_PCTL_DTUPRD2       0xc80000a8
#define  P_DDR0_PCTL_DTUPRD3       0xc80000ac
#define  P_DDR0_PCTL_DTUNE       0xc800009c
#define  P_DDR0_PCTL_DTUPDES       0xc8000094
#define  P_DDR0_PCTL_DTUNA       0xc8000098
#define  P_DDR0_PCTL_DTUPRD0       0xc80000a0
#define  P_DDR0_PCTL_DTUPRD1       0xc80000a4
#define  P_DDR0_PCTL_TCKSRE       0xc8000124
#define  P_DDR0_PCTL_TZQCSI       0xc800011c
#define  P_DDR0_PCTL_TINIT       0xc80000c4
#define  P_DDR0_PCTL_TDPD       0xc8000144
#define  P_DDR0_PCTL_TOGCNT1U       0xc80000c0
#define  P_DDR0_PCTL_TCKE       0xc800012c
#define  P_DDR0_PCTL_TMOD       0xc8000130
#define  P_DDR0_PCTL_TEXSR       0xc800010c
#define  P_DDR0_PCTL_TAL       0xc80000e4
#define  P_DDR0_PCTL_TRTP       0xc8000100
#define  P_DDR0_PCTL_TCKSRX       0xc8000128
#define  P_DDR0_PCTL_TRTW       0xc80000e0
#define  P_DDR0_PCTL_TCWL       0xc80000ec
#define  P_DDR0_PCTL_TWR       0xc8000104
#define  P_DDR0_PCTL_TCL       0xc80000e8
#define  P_DDR0_PCTL_TDQS       0xc8000120
#define  P_DDR0_PCTL_TRSTH       0xc80000c8
#define  P_DDR0_PCTL_TRCD       0xc80000f8
#define  P_DDR0_PCTL_TXP       0xc8000110
#define  P_DDR0_PCTL_TOGCNT100N       0xc80000cc
#define  P_DDR0_PCTL_TMRD       0xc80000d4
#define  P_DDR0_PCTL_TRSTL       0xc8000134
#define  P_DDR0_PCTL_TREFI       0xc80000d0
#define  P_DDR0_PCTL_TRAS       0xc80000f0
#define  P_DDR0_PCTL_TREFI_MEM_DDR3       0xc8000148
#define  P_DDR0_PCTL_TWTR       0xc8000108
#define  P_DDR0_PCTL_TRC       0xc80000f4
#define  P_DDR0_PCTL_TRFC       0xc80000d8
#define  P_DDR0_PCTL_TMRR       0xc800013c
#define  P_DDR0_PCTL_TCKESR       0xc8000140
#define  P_DDR0_PCTL_TZQCL       0xc8000138
#define  P_DDR0_PCTL_TRRD       0xc80000fc
#define  P_DDR0_PCTL_TRP       0xc80000dc
#define  P_DDR0_PCTL_TZQCS       0xc8000118
#define  P_DDR0_PCTL_TXPDLL       0xc8000114
#define  P_DDR0_PCTL_ECCCFG       0xc8000180
#define  P_DDR0_PCTL_ECCLOG       0xc800018c
#define  P_DDR0_PCTL_ECCCLR       0xc8000188
#define  P_DDR0_PCTL_ECCTST       0xc8000184
#define  P_DDR0_PCTL_DTUWD0       0xc8000210
#define  P_DDR0_PCTL_DTUWD1       0xc8000214
#define  P_DDR0_PCTL_DTUWACTL       0xc8000200
#define  P_DDR0_PCTL_DTULFSRRD       0xc8000238
#define  P_DDR0_PCTL_DTUWD2       0xc8000218
#define  P_DDR0_PCTL_DTUWD3       0xc800021c
#define  P_DDR0_PCTL_DTULFSRWD       0xc8000234
#define  P_DDR0_PCTL_DTURACTL       0xc8000204
#define  P_DDR0_PCTL_DTUWDM       0xc8000220
#define  P_DDR0_PCTL_DTURD0       0xc8000224
#define  P_DDR0_PCTL_DTURD1       0xc8000228
#define  P_DDR0_PCTL_DTURD2       0xc800022c
#define  P_DDR0_PCTL_DTURD3       0xc8000230
#define  P_DDR0_PCTL_DTUCFG       0xc8000208
#define  P_DDR0_PCTL_DTUEAF       0xc800023c
#define  P_DDR0_PCTL_DTUECTL       0xc800020c
#define  P_DDR0_PCTL_DFIODTCFG1       0xc8000248
#define  P_DDR0_PCTL_DFITCTRLDELAY       0xc8000240
#define  P_DDR0_PCTL_DFIODTRANKMAP       0xc800024c
#define  P_DDR0_PCTL_DFIODTCFG       0xc8000244
#define  P_DDR0_PCTL_DFITPHYWRLAT       0xc8000254
#define  P_DDR0_PCTL_DFITPHYWRDATA       0xc8000250
#define  P_DDR0_PCTL_DFITRDDATAEN       0xc8000260
#define  P_DDR0_PCTL_DFITPHYRDLAT       0xc8000264
#define  P_DDR0_PCTL_DFITREFMSKI       0xc8000294
#define  P_DDR0_PCTL_DFITPHYUPDTYPE0       0xc8000270
#define  P_DDR0_PCTL_DFITPHYUPDTYPE1       0xc8000274
#define  P_DDR0_PCTL_DFITCTRLUPDDLY       0xc8000288
#define  P_DDR0_PCTL_DFITPHYUPDTYPE2       0xc8000278
#define  P_DDR0_PCTL_DFITCTRLUPDMIN       0xc8000280
#define  P_DDR0_PCTL_DFITPHYUPDTYPE3       0xc800027c
#define  P_DDR0_PCTL_DFIUPDCFG       0xc8000290
#define  P_DDR0_PCTL_DFITCTRLUPDMAX       0xc8000284
#define  P_DDR0_PCTL_DFITCTRLUPDI       0xc8000298
#define  P_DDR0_PCTL_DFITRRDLVLEN       0xc80002b8
#define  P_DDR0_PCTL_DFITRSTAT0       0xc80002b0
#define  P_DDR0_PCTL_DFITRWRLVLEN       0xc80002b4
#define  P_DDR0_PCTL_DFITRCFG0       0xc80002ac
#define  P_DDR0_PCTL_DFITRRDLVLGATEEN       0xc80002bc
#define  P_DDR0_PCTL_DFISTSTAT0       0xc80002c0
#define  P_DDR0_PCTL_DFISTPARLOG       0xc80002e0
#define  P_DDR0_PCTL_DFITDRAMCLKEN       0xc80002d0
#define  P_DDR0_PCTL_DFISTPARCLR       0xc80002dc
#define  P_DDR0_PCTL_DFISTCFG0       0xc80002c4
#define  P_DDR0_PCTL_DFISTCFG1       0xc80002c8
#define  P_DDR0_PCTL_DFISTCFG2       0xc80002d8
#define  P_DDR0_PCTL_DFITDRAMCLKDIS       0xc80002d4
#define  P_DDR0_PCTL_DFILPCFG0       0xc80002f0
#define  P_DDR0_PCTL_DFITRWRLVLDELAY0       0xc8000318
#define  P_DDR0_PCTL_DFITRWRLVLDELAY1       0xc800031c
#define  P_DDR0_PCTL_DFITRWRLVLDELAY2       0xc8000320
#define  P_DDR0_PCTL_DFITRRDLVLRESP0       0xc800030c
#define  P_DDR0_PCTL_DFITRRDLVLRESP1       0xc8000310
#define  P_DDR0_PCTL_DFITRRDLVLRESP2       0xc8000314
#define  P_DDR0_PCTL_DFITRWRLVLRESP0       0xc8000300
#define  P_DDR0_PCTL_DFITRRDLVLDELAY0       0xc8000324
#define  P_DDR0_PCTL_DFITRRDLVLDELAY1       0xc8000328
#define  P_DDR0_PCTL_DFITRWRLVLRESP1       0xc8000304
#define  P_DDR0_PCTL_DFITRRDLVLDELAY2       0xc800032c
#define  P_DDR0_PCTL_DFITRWRLVLRESP2       0xc8000308
#define  P_DDR0_PCTL_DFITRRDLVLGATEDELAY0       0xc8000330
#define  P_DDR0_PCTL_DFITRCMD       0xc800033c
#define  P_DDR0_PCTL_DFITRRDLVLGATEDELAY1       0xc8000334
#define  P_DDR0_PCTL_DFITRRDLVLGATEDELAY2       0xc8000338
#define  P_DDR0_PCTL_IPTR       0xc80003fc
#define  P_DDR0_PCTL_IPVR       0xc80003f8

 
#define  P_DDR0_PUB_RIDR               0xc8001000 + (0x00 << 2)
#define  P_DDR0_PUB_PIR                0xc8001000 + (0x01 << 2)
#define  P_DDR0_PUB_PGCR0              0xc8001000 + (0x02 << 2)
#define  P_DDR0_PUB_PGCR1              0xc8001000 + (0x03 << 2)
#define  P_DDR0_PUB_PGCR2              0xc8001000 + (0x04 << 2)
#define  P_DDR0_PUB_PGCR3              0xc8001000 + (0x05 << 2)
#define  P_DDR0_PUB_PGSR0              0xc8001000 + (0x06 << 2) 
#define  P_DDR0_PUB_PGSR1              0xc8001000 + (0x07 << 2) 
#define  P_DDR0_PUB_PLLCR              0xc8001000 + (0x08 << 2) 
#define  P_DDR0_PUB_PTR0               0xc8001000 + (0x09 << 2) 
#define  P_DDR0_PUB_PTR1               0xc8001000 + (0x0A << 2) 
#define  P_DDR0_PUB_PTR2               0xc8001000 + (0x0B << 2) 
#define  P_DDR0_PUB_PTR3               0xc8001000 + (0x0C << 2) 
#define  P_DDR0_PUB_PTR4               0xc8001000 + (0x0D << 2) 
#define  P_DDR0_PUB_ACMDLR             0xc8001000 + (0x0E << 2) 
#define  P_DDR0_PUB_ACLCDLR            0xc8001000 + (0x0F << 2)
#define  P_DDR0_PUB_ACBDLR0            0xc8001000 + (0x10 << 2)
#define  P_DDR0_PUB_ACBDLR1            0xc8001000 + (0x11 << 2)
#define  P_DDR0_PUB_ACBDLR2            0xc8001000 + (0x12 << 2)
#define  P_DDR0_PUB_ACBDLR3            0xc8001000 + (0x13 << 2)
#define  P_DDR0_PUB_ACBDLR4            0xc8001000 + (0x14 << 2)
#define  P_DDR0_PUB_ACBDLR5            0xc8001000 + (0x15 << 2)
#define  P_DDR0_PUB_ACBDLR6            0xc8001000 + (0x16 << 2)
#define  P_DDR0_PUB_ACBDLR7            0xc8001000 + (0x17 << 2)
#define  P_DDR0_PUB_ACBDLR8            0xc8001000 + (0x18 << 2)
#define  P_DDR0_PUB_ACBDLR9            0xc8001000 + (0x19 << 2)
#define  P_DDR0_PUB_ACIOCR0            0xc8001000 + (0x1A << 2)
#define  P_DDR0_PUB_ACIOCR1            0xc8001000 + (0x1B << 2)
#define  P_DDR0_PUB_ACIOCR2            0xc8001000 + (0x1C << 2)
#define  P_DDR0_PUB_ACIOCR3            0xc8001000 + (0x1D << 2)
#define  P_DDR0_PUB_ACIOCR4            0xc8001000 + (0x1E << 2)
#define  P_DDR0_PUB_ACIOCR5            0xc8001000 + (0x1F << 2)
#define  P_DDR0_PUB_DXCCR              0xc8001000 + (0x20 << 2) 
#define  P_DDR0_PUB_DSGCR              0xc8001000 + (0x21 << 2) 
#define  P_DDR0_PUB_DCR                0xc8001000 + (0x22 << 2) 
#define  P_DDR0_PUB_DTPR0              0xc8001000 + (0x23 << 2) 
#define  P_DDR0_PUB_DTPR1              0xc8001000 + (0x24 << 2) 
#define  P_DDR0_PUB_DTPR2              0xc8001000 + (0x25 << 2) 
#define  P_DDR0_PUB_DTPR3              0xc8001000 + (0x26 << 2)
#define  P_DDR0_PUB_MR0                0xc8001000 + (0x27 << 2) 
#define  P_DDR0_PUB_MR1                0xc8001000 + (0x28 << 2) 
#define  P_DDR0_PUB_MR2                0xc8001000 + (0x29 << 2) 
#define  P_DDR0_PUB_MR3                0xc8001000 + (0x2A << 2) 
#define  P_DDR0_PUB_ODTCR              0xc8001000 + (0x2B << 2) 
#define  P_DDR0_PUB_DTCR               0xc8001000 + (0x2C << 2) 
#define  P_DDR0_PUB_DTAR0              0xc8001000 + (0x2D << 2) 
#define  P_DDR0_PUB_DTAR1              0xc8001000 + (0x2E << 2) 
#define  P_DDR0_PUB_DTAR2              0xc8001000 + (0x2F << 2) 
#define  P_DDR0_PUB_DTAR3              0xc8001000 + (0x30 << 2) 
#define  P_DDR0_PUB_DTDR0              0xc8001000 + (0x31 << 2) 
#define  P_DDR0_PUB_DTDR1              0xc8001000 + (0x32 << 2) 
#define  P_DDR0_PUB_DTEDR0             0xc8001000 + (0x33 << 2) 
#define  P_DDR0_PUB_DTEDR1             0xc8001000 + (0x34 << 2) 
#define  P_DDR0_PUB_RDIMMGCR0          0xc8001000 + (0x35 << 2) 
#define  P_DDR0_PUB_RDIMMGCR1          0xc8001000 + (0x36 << 2) 
#define  P_DDR0_PUB_RDIMMCR0           0xc8001000 + (0x37 << 2) 
#define  P_DDR0_PUB_RDIMMCR1           0xc8001000 + (0x38 << 2) 
#define  P_DDR0_PUB_GPR0               0xc8001000 + (0x39 << 2) 
#define  P_DDR0_PUB_GPR1               0xc8001000 + (0x3A << 2) 
#define  P_DDR0_PUB_CATR0              0xc8001000 + (0x3B << 2) 
#define  P_DDR0_PUB_CATR1              0xc8001000 + (0x3C << 2) 
//0x3D-0x5F reserved
#define  P_DDR0_PUB_DCUAR              0xc8001000 + (0x60 << 2) 
#define  P_DDR0_PUB_DCUDR              0xc8001000 + (0x61 << 2) 
#define  P_DDR0_PUB_DCURR              0xc8001000 + (0x62 << 2) 
#define  P_DDR0_PUB_DCULR              0xc8001000 + (0x63 << 2) 
#define  P_DDR0_PUB_DCUGCR             0xc8001000 + (0x64 << 2) 
#define  P_DDR0_PUB_DCUTPR             0xc8001000 + (0x65 << 2) 
#define  P_DDR0_PUB_DCUSR0             0xc8001000 + (0x66 << 2) 
#define  P_DDR0_PUB_DCUSR1             0xc8001000 + (0x67 << 2)
//0x68-0x6F reserved 
#define  P_DDR0_PUB_BISTRR             0xc8001000 + (0x70 << 2) 
#define  P_DDR0_PUB_BISTWCR            0xc8001000 + (0x71 << 2) 
#define  P_DDR0_PUB_BISTMSKR0          0xc8001000 + (0x72 << 2) 
#define  P_DDR0_PUB_BISTMSKR1          0xc8001000 + (0x73 << 2) 
#define  P_DDR0_PUB_BISTMSKR2          0xc8001000 + (0x74 << 2) 
#define  P_DDR0_PUB_BISTLSR            0xc8001000 + (0x75 << 2) 
#define  P_DDR0_PUB_BISTAR0            0xc8001000 + (0x76 << 2) 
#define  P_DDR0_PUB_BISTAR1            0xc8001000 + (0x77 << 2) 
#define  P_DDR0_PUB_BISTAR2            0xc8001000 + (0x78 << 2) 
#define  P_DDR0_PUB_BISTUDPR           0xc8001000 + (0x79 << 2) 
#define  P_DDR0_PUB_BISTGSR            0xc8001000 + (0x7A << 2) 
#define  P_DDR0_PUB_BISTWER            0xc8001000 + (0x7B << 2) 
#define  P_DDR0_PUB_BISTBER0           0xc8001000 + (0x7C << 2) 
#define  P_DDR0_PUB_BISTBER1           0xc8001000 + (0x7D << 2) 
#define  P_DDR0_PUB_BISTBER2           0xc8001000 + (0x7E << 2) 
#define  P_DDR0_PUB_BISTBER3           0xc8001000 + (0x7F << 2) 
#define  P_DDR0_PUB_BISTWCSR           0xc8001000 + (0x80 << 2) 
#define  P_DDR0_PUB_BISTFWR0           0xc8001000 + (0x81 << 2) 
#define  P_DDR0_PUB_BISTFWR1           0xc8001000 + (0x82 << 2) 
#define  P_DDR0_PUB_BISTFWR2           0xc8001000 + (0x83 << 2)
//0x84-0x8D reserved 
#define  P_DDR0_PUB_IOVCR0             0xc8001000 + (0x8E << 2)
#define  P_DDR0_PUB_IOVCR1             0xc8001000 + (0x8F << 2)
#define  P_DDR0_PUB_ZQCR               0xc8001000 + (0x90 << 2)
#define  P_DDR0_PUB_ZQ0PR              0xc8001000 + (0x91 << 2)
#define  P_DDR0_PUB_ZQ0DR              0xc8001000 + (0x92 << 2)
#define  P_DDR0_PUB_ZQ0SR              0xc8001000 + (0x93 << 2)
//0x94 reserved
#define  P_DDR0_PUB_ZQ1PR              0xc8001000 + (0x95 << 2)
#define  P_DDR0_PUB_ZQ1DR              0xc8001000 + (0x96 << 2)
#define  P_DDR0_PUB_ZQ1SR              0xc8001000 + (0x97 << 2)
//0x98 reserved
#define  P_DDR0_PUB_ZQ2PR              0xc8001000 + (0x99 << 2)
#define  P_DDR0_PUB_ZQ2DR              0xc8001000 + (0x9A << 2)
#define  P_DDR0_PUB_ZQ2SR              0xc8001000 + (0x9B << 2)
//0x9c reserved
#define  P_DDR0_PUB_ZQ3PR              0xc8001000 + (0x9D << 2)
#define  P_DDR0_PUB_ZQ3DR              0xc8001000 + (0x9E << 2)
#define  P_DDR0_PUB_ZQ3SR              0xc8001000 + (0x9F << 2)
#define  P_DDR0_PUB_DX0GCR0            0xc8001000 + (0xA0 << 2) 
#define  P_DDR0_PUB_DX0GCR1            0xc8001000 + (0xA1 << 2) 
#define  P_DDR0_PUB_DX0GCR2            0xc8001000 + (0xA2 << 2) 
#define  P_DDR0_PUB_DX0GCR3            0xc8001000 + (0xA3 << 2) 
#define  P_DDR0_PUB_DX0GSR0            0xc8001000 + (0xA4 << 2) 
#define  P_DDR0_PUB_DX0GSR1            0xc8001000 + (0xA5 << 2) 
#define  P_DDR0_PUB_DX0GSR2            0xc8001000 + (0xA6 << 2)
#define  P_DDR0_PUB_DX0BDLR0           0xc8001000 + (0xA7 << 2) 
#define  P_DDR0_PUB_DX0BDLR1           0xc8001000 + (0xA8 << 2) 
#define  P_DDR0_PUB_DX0BDLR2           0xc8001000 + (0xA9 << 2) 
#define  P_DDR0_PUB_DX0BDLR3           0xc8001000 + (0xAA << 2) 
#define  P_DDR0_PUB_DX0BDLR4           0xc8001000 + (0xAB << 2) 
#define  P_DDR0_PUB_DX0BDLR5           0xc8001000 + (0xAC << 2)
#define  P_DDR0_PUB_DX0BDLR6           0xc8001000 + (0xAD << 2)
#define  P_DDR0_PUB_DX0LCDLR0          0xc8001000 + (0xAE << 2) 
#define  P_DDR0_PUB_DX0LCDLR1          0xc8001000 + (0xAF << 2) 
#define  P_DDR0_PUB_DX0LCDLR2          0xc8001000 + (0xB0 << 2) 
#define  P_DDR0_PUB_DX0MDLR            0xc8001000 + (0xB1 << 2) 
#define  P_DDR0_PUB_DX0GTR             0xc8001000 + (0xB2 << 2) 
//0xB4-0xBF reserved
#define  P_DDR0_PUB_DX1GCR0           0xc8001000 + (0xC0 << 2) 
#define  P_DDR0_PUB_DX1GCR1           0xc8001000 + (0xC1 << 2) 
#define  P_DDR0_PUB_DX1GCR2           0xc8001000 + (0xC2 << 2) 
#define  P_DDR0_PUB_DX1GCR3           0xc8001000 + (0xC3 << 2) 
#define  P_DDR0_PUB_DX1GSR0           0xc8001000 + (0xC4 << 2) 
#define  P_DDR0_PUB_DX1GSR1           0xc8001000 + (0xC5 << 2) 
#define  P_DDR0_PUB_DX1GSR2           0xc8001000 + (0xC6 << 2)
#define  P_DDR0_PUB_DX1BDLR0          0xc8001000 + (0xC7 << 2) 
#define  P_DDR0_PUB_DX1BDLR1          0xc8001000 + (0xC8 << 2) 
#define  P_DDR0_PUB_DX1BDLR2          0xc8001000 + (0xC9 << 2) 
#define  P_DDR0_PUB_DX1BDLR3          0xc8001000 + (0xCA << 2) 
#define  P_DDR0_PUB_DX1BDLR4          0xc8001000 + (0xCB << 2) 
#define  P_DDR0_PUB_DX1BDLR5           0xc8001000 + (0xCC << 2)
#define  P_DDR0_PUB_DX1BDLR6           0xc8001000 + (0xCD << 2)
#define  P_DDR0_PUB_DX1LCDLR0         0xc8001000 + (0xCE << 2) 
#define  P_DDR0_PUB_DX1LCDLR1         0xc8001000 + (0xCF << 2) 
#define  P_DDR0_PUB_DX1LCDLR2         0xc8001000 + (0xD0 << 2) 
#define  P_DDR0_PUB_DX1MDLR           0xc8001000 + (0xD1 << 2) 
#define  P_DDR0_PUB_DX1GTR            0xc8001000 + (0xD2 << 2) 
#define  P_DDR0_PUB_DX2GCR0           0xc8001000 + (0xE0 << 2) 
#define  P_DDR0_PUB_DX2GCR1           0xc8001000 + (0xE1 << 2) 
#define  P_DDR0_PUB_DX2GCR2           0xc8001000 + (0xE2 << 2) 
#define  P_DDR0_PUB_DX2GCR3           0xc8001000 + (0xE3 << 2) 
#define  P_DDR0_PUB_DX2GSR0           0xc8001000 + (0xE4 << 2) 
#define  P_DDR0_PUB_DX2GSR1           0xc8001000 + (0xE5 << 2) 
#define  P_DDR0_PUB_DX2GSR2           0xc8001000 + (0xE6 << 2)
#define  P_DDR0_PUB_DX2BDLR0          0xc8001000 + (0xE7 << 2) 
#define  P_DDR0_PUB_DX2BDLR1          0xc8001000 + (0xE8 << 2) 
#define  P_DDR0_PUB_DX2BDLR2          0xc8001000 + (0xE9 << 2) 
#define  P_DDR0_PUB_DX2BDLR3          0xc8001000 + (0xEA << 2) 
#define  P_DDR0_PUB_DX2BDLR4          0xc8001000 + (0xEB << 2) 
#define  P_DDR0_PUB_DX2BDLR5          0xc8001000 + (0xEC << 2)
#define  P_DDR0_PUB_DX2BDLR6          0xc8001000 + (0xED << 2)
#define  P_DDR0_PUB_DX2LCDLR0         0xc8001000 + (0xEE << 2) 
#define  P_DDR0_PUB_DX2LCDLR1         0xc8001000 + (0xEF << 2) 
#define  P_DDR0_PUB_DX2LCDLR2         0xc8001000 + (0xF0 << 2) 
#define  P_DDR0_PUB_DX2MDLR           0xc8001000 + (0xF1 << 2) 
#define  P_DDR0_PUB_DX2GTR            0xc8001000 + (0xF2 << 2) 
#define  P_DDR0_PUB_DX3GCR0           0xc8001000 + (0x100 << 2) 
#define  P_DDR0_PUB_DX3GCR1           0xc8001000 + (0x101 << 2) 
#define  P_DDR0_PUB_DX3GCR2           0xc8001000 + (0x102 << 2) 
#define  P_DDR0_PUB_DX3GCR3           0xc8001000 + (0x103 << 2) 
#define  P_DDR0_PUB_DX3GSR0           0xc8001000 + (0x104 << 2) 
#define  P_DDR0_PUB_DX3GSR1           0xc8001000 + (0x105 << 2) 
#define  P_DDR0_PUB_DX3GSR2           0xc8001000 + (0x106 << 2)
#define  P_DDR0_PUB_DX3BDLR0          0xc8001000 + (0x107 << 2) 
#define  P_DDR0_PUB_DX3BDLR1          0xc8001000 + (0x108 << 2) 
#define  P_DDR0_PUB_DX3BDLR2          0xc8001000 + (0x109 << 2) 
#define  P_DDR0_PUB_DX3BDLR3          0xc8001000 + (0x10A << 2) 
#define  P_DDR0_PUB_DX3BDLR4          0xc8001000 + (0x10B << 2) 
#define  P_DDR0_PUB_DX3BDLR5          0xc8001000 + (0x10C << 2)
#define  P_DDR0_PUB_DX3BDLR6          0xc8001000 + (0x10D << 2)
#define  P_DDR0_PUB_DX3LCDLR0         0xc8001000 + (0x10E << 2) 
#define  P_DDR0_PUB_DX3LCDLR1         0xc8001000 + (0x10F << 2) 
#define  P_DDR0_PUB_DX3LCDLR2         0xc8001000 + (0x110 << 2) 
#define  P_DDR0_PUB_DX3MDLR           0xc8001000 + (0x111 << 2) 
#define  P_DDR0_PUB_DX3GTR            0xc8001000 + (0x112 << 2) 
#define  P_DDR0_PUB_DX4GCR0           0xc8001000 + (0x120 << 2) 
#define  P_DDR0_PUB_DX4GCR1           0xc8001000 + (0x121 << 2) 
#define  P_DDR0_PUB_DX4GCR2           0xc8001000 + (0x122 << 2) 
#define  P_DDR0_PUB_DX4GCR3           0xc8001000 + (0x123 << 2) 
#define  P_DDR0_PUB_DX4GSR0           0xc8001000 + (0x124 << 2) 
#define  P_DDR0_PUB_DX4GSR1           0xc8001000 + (0x125 << 2) 
#define  P_DDR0_PUB_DX4GSR2           0xc8001000 + (0x126 << 2)
#define  P_DDR0_PUB_DX4BDLR0          0xc8001000 + (0x127 << 2) 
#define  P_DDR0_PUB_DX4BDLR1          0xc8001000 + (0x128 << 2) 
#define  P_DDR0_PUB_DX4BDLR2          0xc8001000 + (0x129 << 2) 
#define  P_DDR0_PUB_DX4BDLR3          0xc8001000 + (0x12A << 2) 
#define  P_DDR0_PUB_DX4BDLR4          0xc8001000 + (0x12B << 2) 
#define  P_DDR0_PUB_DX4BDLR5          0xc8001000 + (0x12C << 2)
#define  P_DDR0_PUB_DX4BDLR6          0xc8001000 + (0x12D << 2)
#define  P_DDR0_PUB_DX4LCDLR0         0xc8001000 + (0x12E << 2) 
#define  P_DDR0_PUB_DX4LCDLR1         0xc8001000 + (0x12F << 2) 
#define  P_DDR0_PUB_DX4LCDLR2         0xc8001000 + (0x130 << 2) 
#define  P_DDR0_PUB_DX4MDLR           0xc8001000 + (0x131 << 2) 
#define  P_DDR0_PUB_DX4GTR            0xc8001000 + (0x132 << 2) 
#define  P_DDR0_PUB_DX5GCR0           0xc8001000 + (0x140 << 2) 
#define  P_DDR0_PUB_DX5GCR1           0xc8001000 + (0x141 << 2) 
#define  P_DDR0_PUB_DX5GCR2           0xc8001000 + (0x142 << 2) 
#define  P_DDR0_PUB_DX5GCR3           0xc8001000 + (0x143 << 2) 
#define  P_DDR0_PUB_DX5GSR0           0xc8001000 + (0x144 << 2) 
#define  P_DDR0_PUB_DX5GSR1           0xc8001000 + (0x145 << 2) 
#define  P_DDR0_PUB_DX5GSR2           0xc8001000 + (0x146 << 2)
#define  P_DDR0_PUB_DX5BDLR0          0xc8001000 + (0x147 << 2) 
#define  P_DDR0_PUB_DX5BDLR1          0xc8001000 + (0x148 << 2) 
#define  P_DDR0_PUB_DX5BDLR2          0xc8001000 + (0x149 << 2) 
#define  P_DDR0_PUB_DX5BDLR3          0xc8001000 + (0x14A << 2) 
#define  P_DDR0_PUB_DX5BDLR4          0xc8001000 + (0x14B << 2) 
#define  P_DDR0_PUB_DX5BDLR5          0xc8001000 + (0x14C << 2)
#define  P_DDR0_PUB_DX5BDLR6          0xc8001000 + (0x14D << 2)
#define  P_DDR0_PUB_DX5LCDLR0         0xc8001000 + (0x14E << 2) 
#define  P_DDR0_PUB_DX5LCDLR1         0xc8001000 + (0x14F << 2) 
#define  P_DDR0_PUB_DX5LCDLR2         0xc8001000 + (0x150 << 2) 
#define  P_DDR0_PUB_DX5MDLR           0xc8001000 + (0x151 << 2) 
#define  P_DDR0_PUB_DX5GTR            0xc8001000 + (0x152 << 2) 
#define  P_DDR0_PUB_DX6GCR0           0xc8001000 + (0x160 << 2) 
#define  P_DDR0_PUB_DX6GCR1           0xc8001000 + (0x161 << 2) 
#define  P_DDR0_PUB_DX6GCR2           0xc8001000 + (0x162 << 2) 
#define  P_DDR0_PUB_DX6GCR3           0xc8001000 + (0x163 << 2) 
#define  P_DDR0_PUB_DX6GSR0           0xc8001000 + (0x164 << 2) 
#define  P_DDR0_PUB_DX6GSR1           0xc8001000 + (0x165 << 2) 
#define  P_DDR0_PUB_DX6GSR2           0xc8001000 + (0x166 << 2)
#define  P_DDR0_PUB_DX6BDLR0          0xc8001000 + (0x167 << 2) 
#define  P_DDR0_PUB_DX6BDLR1          0xc8001000 + (0x168 << 2) 
#define  P_DDR0_PUB_DX6BDLR2          0xc8001000 + (0x169 << 2) 
#define  P_DDR0_PUB_DX6BDLR3          0xc8001000 + (0x16A << 2) 
#define  P_DDR0_PUB_DX6BDLR4          0xc8001000 + (0x16B << 2) 
#define  P_DDR0_PUB_DX6BDLR5          0xc8001000 + (0x16C << 2)
#define  P_DDR0_PUB_DX6BDLR6          0xc8001000 + (0x16D << 2)
#define  P_DDR0_PUB_DX6LCDLR0         0xc8001000 + (0x16E << 2) 
#define  P_DDR0_PUB_DX6LCDLR1         0xc8001000 + (0x16F << 2) 
#define  P_DDR0_PUB_DX6LCDLR2         0xc8001000 + (0x170 << 2) 
#define  P_DDR0_PUB_DX6MDLR           0xc8001000 + (0x171 << 2) 
#define  P_DDR0_PUB_DX6GTR            0xc8001000 + (0x172 << 2) 
#define  P_DDR0_PUB_DX7GCR0           0xc8001000 + (0x180 << 2) 
#define  P_DDR0_PUB_DX7GCR1           0xc8001000 + (0x181 << 2) 
#define  P_DDR0_PUB_DX7GCR2           0xc8001000 + (0x182 << 2) 
#define  P_DDR0_PUB_DX7GCR3           0xc8001000 + (0x183 << 2) 
#define  P_DDR0_PUB_DX7GSR0           0xc8001000 + (0x184 << 2) 
#define  P_DDR0_PUB_DX7GSR1           0xc8001000 + (0x185 << 2) 
#define  P_DDR0_PUB_DX7GSR2           0xc8001000 + (0x186 << 2)
#define  P_DDR0_PUB_DX7BDLR0          0xc8001000 + (0x187 << 2) 
#define  P_DDR0_PUB_DX7BDLR1          0xc8001000 + (0x188 << 2) 
#define  P_DDR0_PUB_DX7BDLR2          0xc8001000 + (0x189 << 2) 
#define  P_DDR0_PUB_DX7BDLR3          0xc8001000 + (0x18A << 2) 
#define  P_DDR0_PUB_DX7BDLR4          0xc8001000 + (0x18B << 2) 
#define  P_DDR0_PUB_DX7BDLR5          0xc8001000 + (0x18C << 2)
#define  P_DDR0_PUB_DX7BDLR6          0xc8001000 + (0x18D << 2)
#define  P_DDR0_PUB_DX7LCDLR0         0xc8001000 + (0x18E << 2) 
#define  P_DDR0_PUB_DX7LCDLR1         0xc8001000 + (0x18F << 2) 
#define  P_DDR0_PUB_DX7LCDLR2         0xc8001000 + (0x190 << 2) 
#define  P_DDR0_PUB_DX7MDLR           0xc8001000 + (0x191 << 2) 
#define  P_DDR0_PUB_DX7GTR            0xc8001000 + (0x192 << 2) 
#define  P_DDR0_PUB_DX8GCR0           0xc8001000 + (0x1A0 << 2) 
#define  P_DDR0_PUB_DX8GCR1           0xc8001000 + (0x1A1 << 2) 
#define  P_DDR0_PUB_DX8GCR2           0xc8001000 + (0x1A2 << 2) 
#define  P_DDR0_PUB_DX8GCR3           0xc8001000 + (0x1A3 << 2) 
#define  P_DDR0_PUB_DX8GSR0           0xc8001000 + (0x1A4 << 2) 
#define  P_DDR0_PUB_DX8GSR1           0xc8001000 + (0x1A5 << 2) 
#define  P_DDR0_PUB_DX8GSR2           0xc8001000 + (0x1A6 << 2)
#define  P_DDR0_PUB_DX8BDLR0          0xc8001000 + (0x1A7 << 2)
#define  P_DDR0_PUB_DX8BDLR1          0xc8001000 + (0x1A8 << 2)
#define  P_DDR0_PUB_DX8BDLR2          0xc8001000 + (0x1A9 << 2)
#define  P_DDR0_PUB_DX8BDLR3          0xc8001000 + (0x1AA << 2)
#define  P_DDR0_PUB_DX8BDLR4          0xc8001000 + (0x1AB << 2)
#define  P_DDR0_PUB_DX8BDLR5          0xc8001000 + (0x1AC << 2)
#define  P_DDR0_PUB_DX8BDLR6          0xc8001000 + (0x1AD << 2)
#define  P_DDR0_PUB_DX8LCDLR0         0xc8001000 + (0x1AE << 2)
#define  P_DDR0_PUB_DX8LCDLR1         0xc8001000 + (0x1AF << 2)
#define  P_DDR0_PUB_DX8LCDLR2         0xc8001000 + (0x1B0 << 2)
#define  P_DDR0_PUB_DX8MDLR           0xc8001000 + (0x1B1 << 2)
#define  P_DDR0_PUB_DX8GTR            0xc8001000 + (0x1B2 << 2)



#define  P_DDR1_CLK_CTRL    0xc8002800
#define  P_DDR1_SOFT_RESET  0xc8002804
#define  P_DDR1_APD_CTRL    0xc8002808

#define P_DDR1_PCTL_SCFG      0xc8002000
#define P_DDR1_PCTL_SCTL      0xc8002004
#define P_DDR1_PCTL_STAT      0xc8002008
#define P_DDR1_PCTL_INTRSTAT      0xc800200c
#define P_DDR1_PCTL_POWSTAT      0xc8002048
#define P_DDR1_PCTL_MRRSTAT0      0xc8002064
#define P_DDR1_PCTL_CMDTSTAT      0xc800204c
#define P_DDR1_PCTL_MCMD      0xc8002040
#define P_DDR1_PCTL_MRRSTAT1      0xc8002068
#define P_DDR1_PCTL_MRRCFG0      0xc8002060
#define P_DDR1_PCTL_CMDTSTATEN      0xc8002050
#define P_DDR1_PCTL_POWCTL      0xc8002044
#define P_DDR1_PCTL_PPCFG      0xc8002084
#define P_DDR1_PCTL_LPDDR23ZQCFG      0xc800208c
#define P_DDR1_PCTL_MCFG1      0xc800207c
#define P_DDR1_PCTL_MSTAT      0xc8002088
#define P_DDR1_PCTL_MCFG      0xc8002080
#define P_DDR1_PCTL_DTUAWDT      0xc80020b0
#define P_DDR1_PCTL_DTUPRD2      0xc80020a8
#define P_DDR1_PCTL_DTUPRD3      0xc80020ac
#define P_DDR1_PCTL_DTUNE      0xc800209c
#define P_DDR1_PCTL_DTUPDES      0xc8002094
#define P_DDR1_PCTL_DTUNA      0xc8002098
#define P_DDR1_PCTL_DTUPRD0      0xc80020a0
#define P_DDR1_PCTL_DTUPRD1      0xc80020a4
#define P_DDR1_PCTL_TCKSRE      0xc8002124
#define P_DDR1_PCTL_TZQCSI      0xc800211c
#define P_DDR1_PCTL_TINIT      0xc80020c4
#define P_DDR1_PCTL_TDPD      0xc8002144
#define P_DDR1_PCTL_TOGCNT1U      0xc80020c0
#define P_DDR1_PCTL_TCKE      0xc800212c
#define P_DDR1_PCTL_TMOD      0xc8002130
#define P_DDR1_PCTL_TEXSR      0xc800210c
#define P_DDR1_PCTL_TAL      0xc80020e4
#define P_DDR1_PCTL_TRTP      0xc8002100
#define P_DDR1_PCTL_TCKSRX      0xc8002128
#define P_DDR1_PCTL_TRTW      0xc80020e0
#define P_DDR1_PCTL_TCWL      0xc80020ec
#define P_DDR1_PCTL_TWR      0xc8002104
#define P_DDR1_PCTL_TCL      0xc80020e8
#define P_DDR1_PCTL_TDQS      0xc8002120
#define P_DDR1_PCTL_TRSTH      0xc80020c8
#define P_DDR1_PCTL_TRCD      0xc80020f8
#define P_DDR1_PCTL_TXP      0xc8002110
#define P_DDR1_PCTL_TOGCNT100N      0xc80020cc
#define P_DDR1_PCTL_TMRD      0xc80020d4
#define P_DDR1_PCTL_TRSTL      0xc8002134
#define P_DDR1_PCTL_TREFI      0xc80020d0
#define P_DDR1_PCTL_TRAS      0xc80020f0
#define P_DDR1_PCTL_TREFI_MEM_DDR3      0xc8002148
#define P_DDR1_PCTL_TWTR      0xc8002108
#define P_DDR1_PCTL_TRC      0xc80020f4
#define P_DDR1_PCTL_TRFC      0xc80020d8
#define P_DDR1_PCTL_TMRR      0xc800213c
#define P_DDR1_PCTL_TCKESR      0xc8002140
#define P_DDR1_PCTL_TZQCL      0xc8002138
#define P_DDR1_PCTL_TRRD      0xc80020fc
#define P_DDR1_PCTL_TRP      0xc80020dc
#define P_DDR1_PCTL_TZQCS      0xc8002118
#define P_DDR1_PCTL_TXPDLL      0xc8002114
#define P_DDR1_PCTL_ECCCFG      0xc8002180
#define P_DDR1_PCTL_ECCLOG      0xc800218c
#define P_DDR1_PCTL_ECCCLR      0xc8002188
#define P_DDR1_PCTL_ECCTST      0xc8002184
#define P_DDR1_PCTL_DTUWD0      0xc8002210
#define P_DDR1_PCTL_DTUWD1      0xc8002214
#define P_DDR1_PCTL_DTUWACTL      0xc8002200
#define P_DDR1_PCTL_DTULFSRRD      0xc8002238
#define P_DDR1_PCTL_DTUWD2      0xc8002218
#define P_DDR1_PCTL_DTUWD3      0xc800221c
#define P_DDR1_PCTL_DTULFSRWD      0xc8002234
#define P_DDR1_PCTL_DTURACTL      0xc8002204
#define P_DDR1_PCTL_DTUWDM      0xc8002220
#define P_DDR1_PCTL_DTURD0      0xc8002224
#define P_DDR1_PCTL_DTURD1      0xc8002228
#define P_DDR1_PCTL_DTURD2      0xc800222c
#define P_DDR1_PCTL_DTURD3      0xc8002230
#define P_DDR1_PCTL_DTUCFG      0xc8002208
#define P_DDR1_PCTL_DTUEAF      0xc800223c
#define P_DDR1_PCTL_DTUECTL      0xc800220c
#define P_DDR1_PCTL_DFIODTCFG1      0xc8002248
#define P_DDR1_PCTL_DFITCTRLDELAY      0xc8002240
#define P_DDR1_PCTL_DFIODTRANKMAP      0xc800224c
#define P_DDR1_PCTL_DFIODTCFG      0xc8002244
#define P_DDR1_PCTL_DFITPHYWRLAT      0xc8002254
#define P_DDR1_PCTL_DFITPHYWRDATA      0xc8002250
#define P_DDR1_PCTL_DFITRDDATAEN      0xc8002260
#define P_DDR1_PCTL_DFITPHYRDLAT      0xc8002264
#define P_DDR1_PCTL_DFITREFMSKI      0xc8002294
#define P_DDR1_PCTL_DFITPHYUPDTYPE0      0xc8002270
#define P_DDR1_PCTL_DFITPHYUPDTYPE1      0xc8002274
#define P_DDR1_PCTL_DFITCTRLUPDDLY      0xc8002288
#define P_DDR1_PCTL_DFITPHYUPDTYPE2      0xc8002278
#define P_DDR1_PCTL_DFITCTRLUPDMIN      0xc8002280
#define P_DDR1_PCTL_DFITPHYUPDTYPE3      0xc800227c
#define P_DDR1_PCTL_DFIUPDCFG      0xc8002290
#define P_DDR1_PCTL_DFITCTRLUPDMAX      0xc8002284
#define P_DDR1_PCTL_DFITCTRLUPDI      0xc8002298
#define P_DDR1_PCTL_DFITRRDLVLEN      0xc80022b8
#define P_DDR1_PCTL_DFITRSTAT0      0xc80022b0
#define P_DDR1_PCTL_DFITRWRLVLEN      0xc80022b4
#define P_DDR1_PCTL_DFITRCFG0      0xc80022ac
#define P_DDR1_PCTL_DFITRRDLVLGATEEN      0xc80022bc
#define P_DDR1_PCTL_DFISTSTAT0      0xc80022c0
#define P_DDR1_PCTL_DFISTPARLOG      0xc80022e0
#define P_DDR1_PCTL_DFITDRAMCLKEN      0xc80022d0
#define P_DDR1_PCTL_DFISTPARCLR      0xc80022dc
#define P_DDR1_PCTL_DFISTCFG0      0xc80022c4
#define P_DDR1_PCTL_DFISTCFG1      0xc80022c8
#define P_DDR1_PCTL_DFISTCFG2      0xc80022d8
#define P_DDR1_PCTL_DFITDRAMCLKDIS      0xc80022d4
#define P_DDR1_PCTL_DFILPCFG0      0xc80022f0
#define P_DDR1_PCTL_DFITRWRLVLDELAY0      0xc8002318
#define P_DDR1_PCTL_DFITRWRLVLDELAY1      0xc800231c
#define P_DDR1_PCTL_DFITRWRLVLDELAY2      0xc8002320
#define P_DDR1_PCTL_DFITRRDLVLRESP0      0xc800230c
#define P_DDR1_PCTL_DFITRRDLVLRESP1      0xc8002310
#define P_DDR1_PCTL_DFITRRDLVLRESP2      0xc8002314
#define P_DDR1_PCTL_DFITRWRLVLRESP0      0xc8002300
#define P_DDR1_PCTL_DFITRRDLVLDELAY0      0xc8002324
#define P_DDR1_PCTL_DFITRRDLVLDELAY1      0xc8002328
#define P_DDR1_PCTL_DFITRWRLVLRESP1      0xc8002304
#define P_DDR1_PCTL_DFITRRDLVLDELAY2      0xc800232c
#define P_DDR1_PCTL_DFITRWRLVLRESP2      0xc8002308
#define P_DDR1_PCTL_DFITRRDLVLGATEDELAY0      0xc8002330
#define P_DDR1_PCTL_DFITRCMD      0xc800233c
#define P_DDR1_PCTL_DFITRRDLVLGATEDELAY1      0xc8002334
#define P_DDR1_PCTL_DFITRRDLVLGATEDELAY2      0xc8002338
#define P_DDR1_PCTL_IPTR      0xc80023fc
#define P_DDR1_PCTL_IPVR      0xc80023f8


#define P_DDR1_PUB_RIDR               0xc8003000 + (0x00 << 2)
#define P_DDR1_PUB_PIR                0xc8003000 + (0x01 << 2)
#define P_DDR1_PUB_PGCR0              0xc8003000 + (0x02 << 2)
#define P_DDR1_PUB_PGCR1              0xc8003000 + (0x03 << 2)
#define P_DDR1_PUB_PGCR2              0xc8003000 + (0x04 << 2)
#define P_DDR1_PUB_PGCR3              0xc8003000 + (0x05 << 2)
#define P_DDR1_PUB_PGSR0              0xc8003000 + (0x06 << 2) 
#define P_DDR1_PUB_PGSR1              0xc8003000 + (0x07 << 2) 
#define P_DDR1_PUB_PLLCR              0xc8003000 + (0x08 << 2) 
#define P_DDR1_PUB_PTR0               0xc8003000 + (0x09 << 2) 
#define P_DDR1_PUB_PTR1               0xc8003000 + (0x0A << 2) 
#define P_DDR1_PUB_PTR2               0xc8003000 + (0x0B << 2) 
#define P_DDR1_PUB_PTR3               0xc8003000 + (0x0C << 2) 
#define P_DDR1_PUB_PTR4               0xc8003000 + (0x0D << 2) 
#define P_DDR1_PUB_ACMDLR             0xc8003000 + (0x0E << 2) 
#define P_DDR1_PUB_ACLCDLR            0xc8003000 + (0x0F << 2)
#define P_DDR1_PUB_ACBDLR0            0xc8003000 + (0x10 << 2)
#define P_DDR1_PUB_ACBDLR1            0xc8003000 + (0x11 << 2)
#define P_DDR1_PUB_ACBDLR2            0xc8003000 + (0x12 << 2)
#define P_DDR1_PUB_ACBDLR3            0xc8003000 + (0x13 << 2)
#define P_DDR1_PUB_ACBDLR4            0xc8003000 + (0x14 << 2)
#define P_DDR1_PUB_ACBDLR5            0xc8003000 + (0x15 << 2)
#define P_DDR1_PUB_ACBDLR6            0xc8003000 + (0x16 << 2)
#define P_DDR1_PUB_ACBDLR7            0xc8003000 + (0x17 << 2)
#define P_DDR1_PUB_ACBDLR8            0xc8003000 + (0x18 << 2)
#define P_DDR1_PUB_ACBDLR9            0xc8003000 + (0x19 << 2)
#define P_DDR1_PUB_ACIOCR0            0xc8003000 + (0x1A << 2)
#define P_DDR1_PUB_ACIOCR1            0xc8003000 + (0x1B << 2)
#define P_DDR1_PUB_ACIOCR2            0xc8003000 + (0x1C << 2)
#define P_DDR1_PUB_ACIOCR3            0xc8003000 + (0x1D << 2)
#define P_DDR1_PUB_ACIOCR4            0xc8003000 + (0x1E << 2)
#define P_DDR1_PUB_ACIOCR5            0xc8003000 + (0x1F << 2)
#define P_DDR1_PUB_DXCCR              0xc8003000 + (0x20 << 2) 
#define P_DDR1_PUB_DSGCR              0xc8003000 + (0x21 << 2) 
#define P_DDR1_PUB_DCR                0xc8003000 + (0x22 << 2) 
#define P_DDR1_PUB_DTPR0              0xc8003000 + (0x23 << 2) 
#define P_DDR1_PUB_DTPR1              0xc8003000 + (0x24 << 2) 
#define P_DDR1_PUB_DTPR2              0xc8003000 + (0x25 << 2) 
#define P_DDR1_PUB_DTPR3              0xc8003000 + (0x26 << 2)
#define P_DDR1_PUB_MR0                0xc8003000 + (0x27 << 2) 
#define P_DDR1_PUB_MR1                0xc8003000 + (0x28 << 2) 
#define P_DDR1_PUB_MR2                0xc8003000 + (0x29 << 2) 
#define P_DDR1_PUB_MR3                0xc8003000 + (0x2A << 2) 
#define P_DDR1_PUB_ODTCR              0xc8003000 + (0x2B << 2) 
#define P_DDR1_PUB_DTCR               0xc8003000 + (0x2C << 2) 
#define P_DDR1_PUB_DTAR0              0xc8003000 + (0x2D << 2) 
#define P_DDR1_PUB_DTAR1              0xc8003000 + (0x2E << 2) 
#define P_DDR1_PUB_DTAR2              0xc8003000 + (0x2F << 2) 
#define P_DDR1_PUB_DTAR3              0xc8003000 + (0x30 << 2) 
#define P_DDR1_PUB_DTDR0              0xc8003000 + (0x31 << 2) 
#define P_DDR1_PUB_DTDR1              0xc8003000 + (0x32 << 2) 
#define P_DDR1_PUB_DTEDR0             0xc8003000 + (0x33 << 2) 
#define P_DDR1_PUB_DTEDR1             0xc8003000 + (0x34 << 2) 
#define P_DDR1_PUB_RDIMMGCR0          0xc8003000 + (0x35 << 2) 
#define P_DDR1_PUB_RDIMMGCR1          0xc8003000 + (0x36 << 2) 
#define P_DDR1_PUB_RDIMMCR0           0xc8003000 + (0x37 << 2) 
#define P_DDR1_PUB_RDIMMCR1           0xc8003000 + (0x38 << 2) 
#define P_DDR1_PUB_GPR0               0xc8003000 + (0x39 << 2) 
#define P_DDR1_PUB_GPR1               0xc8003000 + (0x3A << 2) 
#define P_DDR1_PUB_CATR0              0xc8003000 + (0x3B << 2) 
#define P_DDR1_PUB_CATR1              0xc8003000 + (0x3C << 2) 
#define P_DDR1_PUB_DCUAR              0xc8003000 + (0x60 << 2) 
#define P_DDR1_PUB_DCUDR              0xc8003000 + (0x61 << 2) 
#define P_DDR1_PUB_DCURR              0xc8003000 + (0x62 << 2) 
#define P_DDR1_PUB_DCULR              0xc8003000 + (0x63 << 2) 
#define P_DDR1_PUB_DCUGCR             0xc8003000 + (0x64 << 2) 
#define P_DDR1_PUB_DCUTPR             0xc8003000 + (0x65 << 2) 
#define P_DDR1_PUB_DCUSR0             0xc8003000 + (0x66 << 2) 
#define P_DDR1_PUB_DCUSR1             0xc8003000 + (0x67 << 2) 
#define P_DDR1_PUB_BISTRR             0xc8003000 + (0x70 << 2) 
#define P_DDR1_PUB_BISTWCR            0xc8003000 + (0x71 << 2) 
#define P_DDR1_PUB_BISTMSKR0          0xc8003000 + (0x72 << 2) 
#define P_DDR1_PUB_BISTMSKR1          0xc8003000 + (0x73 << 2) 
#define P_DDR1_PUB_BISTMSKR2          0xc8003000 + (0x74 << 2) 
#define P_DDR1_PUB_BISTLSR            0xc8003000 + (0x75 << 2) 
#define P_DDR1_PUB_BISTAR0            0xc8003000 + (0x76 << 2) 
#define P_DDR1_PUB_BISTAR1            0xc8003000 + (0x77 << 2) 
#define P_DDR1_PUB_BISTAR2            0xc8003000 + (0x78 << 2) 
#define P_DDR1_PUB_BISTUDPR           0xc8003000 + (0x79 << 2) 
#define P_DDR1_PUB_BISTGSR            0xc8003000 + (0x7A << 2) 
#define P_DDR1_PUB_BISTWER            0xc8003000 + (0x7B << 2) 
#define P_DDR1_PUB_BISTBER0           0xc8003000 + (0x7C << 2) 
#define P_DDR1_PUB_BISTBER1           0xc8003000 + (0x7D << 2) 
#define P_DDR1_PUB_BISTBER2           0xc8003000 + (0x7E << 2) 
#define P_DDR1_PUB_BISTBER3           0xc8003000 + (0x7F << 2) 
#define P_DDR1_PUB_BISTWCSR           0xc8003000 + (0x80 << 2) 
#define P_DDR1_PUB_BISTFWR0           0xc8003000 + (0x81 << 2) 
#define P_DDR1_PUB_BISTFWR1           0xc8003000 + (0x82 << 2) 
#define P_DDR1_PUB_BISTFWR2           0xc8003000 + (0x83 << 2) 
#define P_DDR1_PUB_IOVCR0             0xc8003000 + (0x8E << 2)
#define P_DDR1_PUB_IOVCR1             0xc8003000 + (0x8F << 2)
#define P_DDR1_PUB_ZQCR               0xc8003000 + (0x90 << 2)
#define P_DDR1_PUB_ZQ0PR              0xc8003000 + (0x91 << 2)
#define P_DDR1_PUB_ZQ0DR              0xc8003000 + (0x92 << 2)
#define P_DDR1_PUB_ZQ0SR              0xc8003000 + (0x93 << 2)
#define P_DDR1_PUB_ZQ1PR              0xc8003000 + (0x95 << 2)
#define P_DDR1_PUB_ZQ1DR              0xc8003000 + (0x96 << 2)
#define P_DDR1_PUB_ZQ1SR              0xc8003000 + (0x97 << 2)
#define P_DDR1_PUB_ZQ2PR              0xc8003000 + (0x99 << 2)
#define P_DDR1_PUB_ZQ2DR              0xc8003000 + (0x9A << 2)
#define P_DDR1_PUB_ZQ2SR              0xc8003000 + (0x9B << 2)
#define P_DDR1_PUB_ZQ3PR              0xc8003000 + (0x9D << 2)
#define P_DDR1_PUB_ZQ3DR              0xc8003000 + (0x9E << 2)
#define P_DDR1_PUB_ZQ3SR              0xc8003000 + (0x9F << 2)
#define P_DDR1_PUB_DX0GCR0            0xc8003000 + (0xA0 << 2) 
#define P_DDR1_PUB_DX0GCR1            0xc8003000 + (0xA1 << 2) 
#define P_DDR1_PUB_DX0GCR2            0xc8003000 + (0xA2 << 2) 
#define P_DDR1_PUB_DX0GCR3            0xc8003000 + (0xA3 << 2) 
#define P_DDR1_PUB_DX0GSR0            0xc8003000 + (0xA4 << 2) 
#define P_DDR1_PUB_DX0GSR1            0xc8003000 + (0xA5 << 2) 
#define P_DDR1_PUB_DX0GSR2            0xc8003000 + (0xA6 << 2)
#define P_DDR1_PUB_DX0BDLR0           0xc8003000 + (0xA7 << 2) 
#define P_DDR1_PUB_DX0BDLR1           0xc8003000 + (0xA8 << 2) 
#define P_DDR1_PUB_DX0BDLR2           0xc8003000 + (0xA9 << 2) 
#define P_DDR1_PUB_DX0BDLR3           0xc8003000 + (0xAA << 2) 
#define P_DDR1_PUB_DX0BDLR4           0xc8003000 + (0xAB << 2) 
#define P_DDR1_PUB_DX0BDLR5           0xc8003000 + (0xAC << 2)
#define P_DDR1_PUB_DX0BDLR6           0xc8003000 + (0xAD << 2)
#define P_DDR1_PUB_DX0LCDLR0          0xc8003000 + (0xAE << 2) 
#define P_DDR1_PUB_DX0LCDLR1          0xc8003000 + (0xAF << 2) 
#define P_DDR1_PUB_DX0LCDLR2          0xc8003000 + (0xB0 << 2) 
#define P_DDR1_PUB_DX0MDLR            0xc8003000 + (0xB1 << 2) 
#define P_DDR1_PUB_DX0GTR             0xc8003000 + (0xB2 << 2) 
#define P_DDR1_PUB_DX1GCR0           0xc8003000 + (0xC0 << 2) 
#define P_DDR1_PUB_DX1GCR1           0xc8003000 + (0xC1 << 2) 
#define P_DDR1_PUB_DX1GCR2           0xc8003000 + (0xC2 << 2) 
#define P_DDR1_PUB_DX1GCR3           0xc8003000 + (0xC3 << 2) 
#define P_DDR1_PUB_DX1GSR0           0xc8003000 + (0xC4 << 2) 
#define P_DDR1_PUB_DX1GSR1           0xc8003000 + (0xC5 << 2) 
#define P_DDR1_PUB_DX1GSR2           0xc8003000 + (0xC6 << 2)
#define P_DDR1_PUB_DX1BDLR0          0xc8003000 + (0xC7 << 2) 
#define P_DDR1_PUB_DX1BDLR1          0xc8003000 + (0xC8 << 2) 
#define P_DDR1_PUB_DX1BDLR2          0xc8003000 + (0xC9 << 2) 
#define P_DDR1_PUB_DX1BDLR3          0xc8003000 + (0xCA << 2) 
#define P_DDR1_PUB_DX1BDLR4          0xc8003000 + (0xCB << 2) 
#define P_DDR1_PUB_DX1BDLR5           0xc8003000 + (0xCC << 2)
#define P_DDR1_PUB_DX1BDLR6           0xc8003000 + (0xCD << 2)
#define P_DDR1_PUB_DX1LCDLR0         0xc8003000 + (0xCE << 2) 
#define P_DDR1_PUB_DX1LCDLR1         0xc8003000 + (0xCF << 2) 
#define P_DDR1_PUB_DX1LCDLR2         0xc8003000 + (0xD0 << 2) 
#define P_DDR1_PUB_DX1MDLR           0xc8003000 + (0xD1 << 2) 
#define P_DDR1_PUB_DX1GTR            0xc8003000 + (0xD2 << 2) 
#define P_DDR1_PUB_DX2GCR0           0xc8003000 + (0xE0 << 2) 
#define P_DDR1_PUB_DX2GCR1           0xc8003000 + (0xE1 << 2) 
#define P_DDR1_PUB_DX2GCR2           0xc8003000 + (0xE2 << 2) 
#define P_DDR1_PUB_DX2GCR3           0xc8003000 + (0xE3 << 2) 
#define P_DDR1_PUB_DX2GSR0           0xc8003000 + (0xE4 << 2) 
#define P_DDR1_PUB_DX2GSR1           0xc8003000 + (0xE5 << 2) 
#define P_DDR1_PUB_DX2GSR2           0xc8003000 + (0xE6 << 2)
#define P_DDR1_PUB_DX2BDLR0          0xc8003000 + (0xE7 << 2) 
#define P_DDR1_PUB_DX2BDLR1          0xc8003000 + (0xE8 << 2) 
#define P_DDR1_PUB_DX2BDLR2          0xc8003000 + (0xE9 << 2) 
#define P_DDR1_PUB_DX2BDLR3          0xc8003000 + (0xEA << 2) 
#define P_DDR1_PUB_DX2BDLR4          0xc8003000 + (0xEB << 2) 
#define P_DDR1_PUB_DX2BDLR5          0xc8003000 + (0xEC << 2)
#define P_DDR1_PUB_DX2BDLR6          0xc8003000 + (0xED << 2)
#define P_DDR1_PUB_DX2LCDLR0         0xc8003000 + (0xEE << 2) 
#define P_DDR1_PUB_DX2LCDLR1         0xc8003000 + (0xEF << 2) 
#define P_DDR1_PUB_DX2LCDLR2         0xc8003000 + (0xF0 << 2) 
#define P_DDR1_PUB_DX2MDLR           0xc8003000 + (0xF1 << 2) 
#define P_DDR1_PUB_DX2GTR            0xc8003000 + (0xF2 << 2) 
#define P_DDR1_PUB_DX3GCR0           0xc8003000 + (0x100 << 2) 
#define P_DDR1_PUB_DX3GCR1           0xc8003000 + (0x101 << 2) 
#define P_DDR1_PUB_DX3GCR2           0xc8003000 + (0x102 << 2) 
#define P_DDR1_PUB_DX3GCR3           0xc8003000 + (0x103 << 2) 
#define P_DDR1_PUB_DX3GSR0           0xc8003000 + (0x104 << 2) 
#define P_DDR1_PUB_DX3GSR1           0xc8003000 + (0x105 << 2) 
#define P_DDR1_PUB_DX3GSR2           0xc8003000 + (0x106 << 2)
#define P_DDR1_PUB_DX3BDLR0          0xc8003000 + (0x107 << 2) 
#define P_DDR1_PUB_DX3BDLR1          0xc8003000 + (0x108 << 2) 
#define P_DDR1_PUB_DX3BDLR2          0xc8003000 + (0x109 << 2) 
#define P_DDR1_PUB_DX3BDLR3          0xc8003000 + (0x10A << 2) 
#define P_DDR1_PUB_DX3BDLR4          0xc8003000 + (0x10B << 2) 
#define P_DDR1_PUB_DX3BDLR5          0xc8003000 + (0x10C << 2)
#define P_DDR1_PUB_DX3BDLR6          0xc8003000 + (0x10D << 2)
#define P_DDR1_PUB_DX3LCDLR0         0xc8003000 + (0x10E << 2) 
#define P_DDR1_PUB_DX3LCDLR1         0xc8003000 + (0x10F << 2) 
#define P_DDR1_PUB_DX3LCDLR2         0xc8003000 + (0x110 << 2) 
#define P_DDR1_PUB_DX3MDLR           0xc8003000 + (0x111 << 2) 
#define P_DDR1_PUB_DX3GTR            0xc8003000 + (0x112 << 2) 
#define P_DDR1_PUB_DX4GCR0           0xc8003000 + (0x120 << 2) 
#define P_DDR1_PUB_DX4GCR1           0xc8003000 + (0x121 << 2) 
#define P_DDR1_PUB_DX4GCR2           0xc8003000 + (0x122 << 2) 
#define P_DDR1_PUB_DX4GCR3           0xc8003000 + (0x123 << 2) 
#define P_DDR1_PUB_DX4GSR0           0xc8003000 + (0x124 << 2) 
#define P_DDR1_PUB_DX4GSR1           0xc8003000 + (0x125 << 2) 
#define P_DDR1_PUB_DX4GSR2           0xc8003000 + (0x126 << 2)
#define P_DDR1_PUB_DX4BDLR0          0xc8003000 + (0x127 << 2) 
#define P_DDR1_PUB_DX4BDLR1          0xc8003000 + (0x128 << 2) 
#define P_DDR1_PUB_DX4BDLR2          0xc8003000 + (0x129 << 2) 
#define P_DDR1_PUB_DX4BDLR3          0xc8003000 + (0x12A << 2) 
#define P_DDR1_PUB_DX4BDLR4          0xc8003000 + (0x12B << 2) 
#define P_DDR1_PUB_DX4BDLR5          0xc8003000 + (0x12C << 2)
#define P_DDR1_PUB_DX4BDLR6          0xc8003000 + (0x12D << 2)
#define P_DDR1_PUB_DX4LCDLR0         0xc8003000 + (0x12E << 2) 
#define P_DDR1_PUB_DX4LCDLR1         0xc8003000 + (0x12F << 2) 
#define P_DDR1_PUB_DX4LCDLR2         0xc8003000 + (0x130 << 2) 
#define P_DDR1_PUB_DX4MDLR           0xc8003000 + (0x131 << 2) 
#define P_DDR1_PUB_DX4GTR            0xc8003000 + (0x132 << 2) 
#define P_DDR1_PUB_DX5GCR0           0xc8003000 + (0x140 << 2) 
#define P_DDR1_PUB_DX5GCR1           0xc8003000 + (0x141 << 2) 
#define P_DDR1_PUB_DX5GCR2           0xc8003000 + (0x142 << 2) 
#define P_DDR1_PUB_DX5GCR3           0xc8003000 + (0x143 << 2) 
#define P_DDR1_PUB_DX5GSR0           0xc8003000 + (0x144 << 2) 
#define P_DDR1_PUB_DX5GSR1           0xc8003000 + (0x145 << 2) 
#define P_DDR1_PUB_DX5GSR2           0xc8003000 + (0x146 << 2)
#define P_DDR1_PUB_DX5BDLR0          0xc8003000 + (0x147 << 2) 
#define P_DDR1_PUB_DX5BDLR1          0xc8003000 + (0x148 << 2) 
#define P_DDR1_PUB_DX5BDLR2          0xc8003000 + (0x149 << 2) 
#define P_DDR1_PUB_DX5BDLR3          0xc8003000 + (0x14A << 2) 
#define P_DDR1_PUB_DX5BDLR4          0xc8003000 + (0x14B << 2) 
#define P_DDR1_PUB_DX5BDLR5          0xc8003000 + (0x14C << 2)
#define P_DDR1_PUB_DX5BDLR6          0xc8003000 + (0x14D << 2)
#define P_DDR1_PUB_DX5LCDLR0         0xc8003000 + (0x14E << 2) 
#define P_DDR1_PUB_DX5LCDLR1         0xc8003000 + (0x14F << 2) 
#define P_DDR1_PUB_DX5LCDLR2         0xc8003000 + (0x150 << 2) 
#define P_DDR1_PUB_DX5MDLR           0xc8003000 + (0x151 << 2) 
#define P_DDR1_PUB_DX5GTR            0xc8003000 + (0x152 << 2) 
#define P_DDR1_PUB_DX6GCR0           0xc8003000 + (0x160 << 2) 
#define P_DDR1_PUB_DX6GCR1           0xc8003000 + (0x161 << 2) 
#define P_DDR1_PUB_DX6GCR2           0xc8003000 + (0x162 << 2) 
#define P_DDR1_PUB_DX6GCR3           0xc8003000 + (0x163 << 2) 
#define P_DDR1_PUB_DX6GSR0           0xc8003000 + (0x164 << 2) 
#define P_DDR1_PUB_DX6GSR1           0xc8003000 + (0x165 << 2) 
#define P_DDR1_PUB_DX6GSR2           0xc8003000 + (0x166 << 2)
#define P_DDR1_PUB_DX6BDLR0          0xc8003000 + (0x167 << 2) 
#define P_DDR1_PUB_DX6BDLR1          0xc8003000 + (0x168 << 2) 
#define P_DDR1_PUB_DX6BDLR2          0xc8003000 + (0x169 << 2) 
#define P_DDR1_PUB_DX6BDLR3          0xc8003000 + (0x16A << 2) 
#define P_DDR1_PUB_DX6BDLR4          0xc8003000 + (0x16B << 2) 
#define P_DDR1_PUB_DX6BDLR5          0xc8003000 + (0x16C << 2)
#define P_DDR1_PUB_DX6BDLR6          0xc8003000 + (0x16D << 2)
#define P_DDR1_PUB_DX6LCDLR0         0xc8003000 + (0x16E << 2) 
#define P_DDR1_PUB_DX6LCDLR1         0xc8003000 + (0x16F << 2) 
#define P_DDR1_PUB_DX6LCDLR2         0xc8003000 + (0x170 << 2) 
#define P_DDR1_PUB_DX6MDLR           0xc8003000 + (0x171 << 2) 
#define P_DDR1_PUB_DX6GTR            0xc8003000 + (0x172 << 2) 
#define P_DDR1_PUB_DX7GCR0           0xc8003000 + (0x180 << 2) 
#define P_DDR1_PUB_DX7GCR1           0xc8003000 + (0x181 << 2) 
#define P_DDR1_PUB_DX7GCR2           0xc8003000 + (0x182 << 2) 
#define P_DDR1_PUB_DX7GCR3           0xc8003000 + (0x183 << 2) 
#define P_DDR1_PUB_DX7GSR0           0xc8003000 + (0x184 << 2) 
#define P_DDR1_PUB_DX7GSR1           0xc8003000 + (0x185 << 2) 
#define P_DDR1_PUB_DX7GSR2           0xc8003000 + (0x186 << 2)
#define P_DDR1_PUB_DX7BDLR0          0xc8003000 + (0x187 << 2) 
#define P_DDR1_PUB_DX7BDLR1          0xc8003000 + (0x188 << 2) 
#define P_DDR1_PUB_DX7BDLR2          0xc8003000 + (0x189 << 2) 
#define P_DDR1_PUB_DX7BDLR3          0xc8003000 + (0x18A << 2) 
#define P_DDR1_PUB_DX7BDLR4          0xc8003000 + (0x18B << 2) 
#define P_DDR1_PUB_DX7BDLR5          0xc8003000 + (0x18C << 2)
#define P_DDR1_PUB_DX7BDLR6          0xc8003000 + (0x18D << 2)
#define P_DDR1_PUB_DX7LCDLR0         0xc8003000 + (0x18E << 2) 
#define P_DDR1_PUB_DX7LCDLR1         0xc8003000 + (0x18F << 2) 
#define P_DDR1_PUB_DX7LCDLR2         0xc8003000 + (0x190 << 2) 
#define P_DDR1_PUB_DX7MDLR           0xc8003000 + (0x191 << 2) 
#define P_DDR1_PUB_DX7GTR            0xc8003000 + (0x192 << 2) 
#define P_DDR1_PUB_DX8GCR0           0xc8003000 + (0x1A0 << 2) 
#define P_DDR1_PUB_DX8GCR1           0xc8003000 + (0x1A1 << 2) 
#define P_DDR1_PUB_DX8GCR2           0xc8003000 + (0x1A2 << 2) 
#define P_DDR1_PUB_DX8GCR3           0xc8003000 + (0x1A3 << 2) 
#define P_DDR1_PUB_DX8GSR0           0xc8003000 + (0x1A4 << 2) 
#define P_DDR1_PUB_DX8GSR1           0xc8003000 + (0x1A5 << 2) 
#define P_DDR1_PUB_DX8GSR2           0xc8003000 + (0x1A6 << 2)
#define P_DDR1_PUB_DX8BDLR0          0xc8003000 + (0x1A7 << 2)
#define P_DDR1_PUB_DX8BDLR1          0xc8003000 + (0x1A8 << 2)
#define P_DDR1_PUB_DX8BDLR2          0xc8003000 + (0x1A9 << 2)
#define P_DDR1_PUB_DX8BDLR3          0xc8003000 + (0x1AA << 2)
#define P_DDR1_PUB_DX8BDLR4          0xc8003000 + (0x1AB << 2)
#define P_DDR1_PUB_DX8BDLR5          0xc8003000 + (0x1AC << 2)
#define P_DDR1_PUB_DX8BDLR6          0xc8003000 + (0x1AD << 2)
#define P_DDR1_PUB_DX8LCDLR0         0xc8003000 + (0x1AE << 2)
#define P_DDR1_PUB_DX8LCDLR1         0xc8003000 + (0x1AF << 2)
#define P_DDR1_PUB_DX8LCDLR2         0xc8003000 + (0x1B0 << 2)
#define P_DDR1_PUB_DX8MDLR           0xc8003000 + (0x1B1 << 2)
#define P_DDR1_PUB_DX8GTR            0xc8003000 + (0x1B2 << 2)


#ifndef DMC_REG_DEFINE
#define DMC_REG_DEFINE
#define DMC_REG_BASE       0xc8006000

#define MMC_Wr(addr,data) *(volatile unsigned long *) (addr ) = data
#define MMC_Rd(addr) *(volatile unsigned long *) (addr )
#define writel(v,c) *(volatile unsigned long *) (c ) = v
#define readl(c)    *(volatile unsigned long *) (c )

#define P_DMC_REQ_CTRL         DMC_REG_BASE + (0x00 << 2) 
  //bit 11.  enable dmc request of chan 11. Audio
  //bit 10.  enable dmc request of chan 10. Device.
  //bit 9.   enable dmc request of chan 9.  VDEC2
  //bit 8.   enable dmc request of chan 8.  HCODEC
  //bit 7.   enable dmc request of chan 7.  VDEC
  //bit 6.   enable dmc request of chan 6.  VDIN
  //bit 5.   enable dmc request of chan 5.  VDISP2
  //bit 4.   enable dmc request of chan 4.  VDISP
  //bit 3.   enable dmc request of chan 3.  Mali
  //bit 2.   enable dmc request of chan 2.  Mali
  //bit 1.   enable dmc request of chan 1.  Mali
  //bit 0.   enable dmc request of chan 0.  A9
#define P_DMC_SOFT_RST         DMC_REG_BASE + (0x01 << 2)
#define P_DMC_SOFT_RST1        DMC_REG_BASE + (0x02 << 2)
#define P_DMC_RST_STS          DMC_REG_BASE + (0x03 << 2)
#define P_DMC_RST_STS1         DMC_REG_BASE + (0x04 << 2)
#define P_DMC_VERSION          DMC_REG_BASE + (0x05 << 2)
   //read only default = 1.

#define P_DMC_DDR_CTRL         DMC_REG_BASE + (0x10  << 2)
// in M8baby chip, There's only one DDR Channel.  So we used ddr channel 1 control bits for DDR       second rank control.
  // But since they shared same PCTL/PHY. they have to be either 32bits or 16bits but not mixed.
  //bit 27:24.   ddr chanel selection.
                 //bit 27: 26 :
                     //2'b00 : address switch between 2 ddr channel using address bit 12.
                            //bit12 = 0 : ddr channel 0.  bit 12 = 1 : ddr channel 1.
                            //if 2 ddr channel size is different, only switch the lower parts.
                     //2'b01 : address switch between 2 ddr channel using address bit 8.
                           //bit8 = 0 : ddr channel 0.  bit 8 = 1 : ddr channel 1.
                           //if 2 ddr channel size is different, only switch the lower parts.
                    // 2'b10 : no switch between the 2 channels. use bit 24 as selection which one put  lower address.
                              //bit 24 = 0:   channel 0 put to the lower address.
                              //bit 24 = 1:   channel 1 put to the lower address.
                    // 2'b11 :  all address goes to one DDR channel. use bit 24 to select which one.
                              //bit 24 = 0:   use channel 0;
                              //bit 24 = 1:   use channel 1;
//fake  //bit 18.       ddr channel 1 PCTL/PHY physical bits.  0 = 32bits. 1 = 16bits.
//fake  //bit 17.       ddr channel 0 PCTL/PHY physical bits.  0 = 32bits. 1 = 16bits.
  //bit 16.       bank page policy.
  //bit 15.       ddr1 channel 1 is in 16bits mode.  0 : 32bits mode. 1: 16bits mode.
  //bit 14:13.    ddr1 address map bank mode
                    // 00 = address switch between 2 banks  bank[0] selection bits [12].
                    // 01 = address switch between 4 banks  bank[1:0] selection bits [13:12].
                    // 10 = address switch between 2 banks  bank[0] selection bits [8].
                    // 11 = address switch between 4 banks  bank[1:0] selection bits [9:8].
  //bit 12        ddr1 rank size.  0, 1, one rank.  2 : 2 ranks.
  //bit 11:10      ddr1 row size.  2'b01 : A0~A12.   2'b10 : A0~A13.  2'b11 : A0~A14.  2'b00 : A0~A15.
  //bit 9:8      ddr1 col size.  2'b01 : A0~A8,    2'b10 : A0~A9.
  //bit 7        ddr channel 0  is in 16bits mode.  0: 32bits mode. 1 : 16bits mode.
  //bit 6:5.     ddr0 address map bank mode
                    // 00 = address switch between 2 banks  bank[0] selection bits [12].
                    // 01 = address switch between 4 banks  bank[1:0] selection bits [13:12].
                    // 10 = address switch between 2 banks  bank[0] selection bits [8].
                    // 11 = address switch between 4 banks  bank[1:0] selection bits [9:8].
  //bit 4        ddr0 rank size.  0, 1, one rank.  2 : 2 ranks.
  //bit 3:2      ddr0 row size.  2'b01 : A0~A12.   2'b10 : A0~A13.  2'b11 : A0~A14.  2'b00 : A0~A15.
  //bit 1:0      ddr0 col size.  2'b01 : A0~A8,    2'b10 : A0~A9.

#define P_DMC_DDR_CTRL1         DMC_REG_BASE + (0x11 << 2) 

#define P_DC_CAV_LUT_DATAL           DMC_REG_BASE + (0x12 << 2)
  //low 32 bits of canvas data which need to be configured to canvas memory. 
#define P_DC_CAV_LUT_DATAH           DMC_REG_BASE + (0x13 << 2)
  //high 32bits of cavnas data which need to be configured to canvas memory.
#define P_DC_CAV_LUT_ADDR            DMC_REG_BASE + (0x14 << 2)
  //bit 9:8.   write 9:8 2'b10. the canvas data will saved in canvas memory with addres 7:0.
  //bit 7:0.   canvas address.
#define P_DC_CAV_LUT_RDATAL           DMC_REG_BASE + (0x15 << 2)
#define P_DC_CAV_LUT_RDATAH           DMC_REG_BASE + (0x16 << 2)
#define P_DMC_2ARB_CTRL       DMC_REG_BASE + (0x20 << 2)

#define P_DMC_REFR_CTRL1             DMC_REG_BASE + (0x23 << 2)
  //bit23:15   tRFC waiting time, when hold nif command after refresh.
  //bit 9      after refresh, hold nif command enable 
  //bit 8      when refresh req,  hold nif command enable 
  //bit 7      dmc to control auto_refresh enable
  //bit 6:4    refresh number per refresh cycle..
  //bit 3      pvt enable
  //bit 2      zqc enable
  //bit 1      ddr1 auto refresh dmc control select.
  //bit 0      ddr0 auto refresh dmc control select.

#define P_DMC_REFR_CTRL2              DMC_REG_BASE + (0x24 << 2) 
  //bit 31:24   tZQCI
  //bit 23:16   tPVTI
  //bit 15:8    tREFI
  //bit 7:0     t100ns

#define P_DMC_PARB_CTRL              DMC_REG_BASE + (0x25 << 2) 
  //bit 17.     default port1(MALI AXI port) urgent bit.
  //bit 16      default port0(A9 AXI port ) urgent bit.
  //bit 15:8    t_ugt_gap.   when the consecutive urgent request granted over the t_ugt_wd times, we allow the number of non urgent request was granted by the port arbiter.
  //bit 7:0.    t_ugt_wd. 


#define P_DMC_MON_CTRL2              DMC_REG_BASE + (0x26 << 2)
   //bit 31.   qos_mon_en.    write 1 to trigger the enable. polling this bit 0, means finished.  or use interrupt to check finish. 
   //bit 30.   qos_mon interrupt clear.  clear the qos monitor result.  read 1 = qos mon finish interrupt.
   //bit 20.   qos_mon_trig_sel.  1 = vsync.  0 = timer. 
   //bit 19:16.  qos monitor channel select.   select one at one time only.
   //bit 15:0.   port select for the selected channel.
#define P_DMC_MON_CTRL3              DMC_REG_BASE + (0x27 << 2)
  // qos_mon_clk_timer.   How long to measure the bandwidth.


#define P_DMC_MON_ALL_REQ_CNT        DMC_REG_BASE + (0x28 << 2)
  // at the test period,  the whole MMC request time.
#define P_DMC_MON_ALL_GRANT_CNT      DMC_REG_BASE + (0x29 << 2)
  // at the test period,  the whole MMC granted data cycles. 64bits unit. 
#define P_DMC_MON_ONE_GRANT_CNT      DMC_REG_BASE + (0x2a << 2)
  // at the test period,  the granted data cycles for the selected channel and ports.

#define P_DMC_CLKG_CTRL0       DMC_REG_BASE + (0x30 << 2)
  //bit 28.  enalbe auto clock gating for qos monitor control. 
  //bit 27.  enalbe auto clock gating for qos control. 
  //bit 26.  enalbe auto clock gating for ddr1 write rsp generation. 
  //bit 25.  enalbe auto clock gating for ddr0 write rsp generation. 
  //bit 24.  enalbe auto clock gating for read rsp generation. 
  //bit 23.  enalbe auto clock gating for ddr1 read back data buffer. 
  //bit 22.  enalbe auto clock gating for ddr0 read back data buffer. 
  //bit 21.  enalbe auto clock gating for ddr1 command filter. 
  //bit 20.  enalbe auto clock gating for ddr0 command filter. 
  //bit 19.  enalbe auto clock gating for ddr1 write reorder buffer. 
  //bit 18.  enalbe auto clock gating for ddr0 write reorder buffer. 
  //bit 17.  enalbe auto clock gating for ddr1 write data buffer. 
  //bit 16.  enalbe auto clock gating for ddr0 write data buffer. 
  //bit 15.  enalbe auto clock gating for ddr1 read reorder buffer. 
  //bit 14.  enalbe auto clock gating for ddr0 read reorder buffer. 
  //bit 13.  enalbe auto clock gating for read canvas. 
  //bit 12.  enalbe auto clock gating for write canvas. 
  //bit 11.  enalbe auto clock gating for chan 11.
  //bit 10.  enalbe auto clock gating for chan 11.
  //bit 9.   enalbe auto clock gating for chan 11.
  //bit 8.   enalbe auto clock gating for chan 11.
  //bit 7.   enalbe auto clock gating for chan 11.
  //bit 6.   enalbe auto clock gating for chan 11.
  //bit 5.   enalbe auto clock gating for chan 11.
  //bit 4.   enalbe auto clock gating for chan 11.
  //bit 3.   enalbe auto clock gating for chan 11.
  //bit 2.   enalbe auto clock gating for chan 11.
  //bit 1.   enalbe auto clock gating for chan 11.
  //bit 0.   enalbe auto clock gating for chan 11.
#define P_DMC_CLKG_CTRL1       DMC_REG_BASE + (0x31 << 2)
  //bit 28.  force to disalbe the clock of qos monitor control. 
  //bit 27.  force to disalbe the clock of qos control. 
  //bit 26.  force to disalbe the clock of ddr1 write rsp generation. 
  //bit 25.  force to disalbe the clock of ddr0 write rsp generation. 
  //bit 24.  force to disalbe the clock of read rsp generation. 
  //bit 23.  force to disalbe the clock of ddr1 read back data buffer. 
  //bit 22.  force to disalbe the clock of ddr0 read back data buffer. 
  //bit 21.  force to disalbe the clock of ddr1 command filter. 
  //bit 20.  force to disalbe the clock of ddr0 command filter. 
  //bit 19.  force to disalbe the clock of ddr1 write reorder buffer. 
  //bit 18.  force to disalbe the clock of ddr0 write reorder buffer. 
  //bit 17.  force to disalbe the clock of ddr1 write data buffer. 
  //bit 16.  force to disalbe the clock of ddr0 write data buffer. 
  //bit 15.  force to disalbe the clock of ddr1 read reorder buffer. 
  //bit 14.  force to disalbe the clock of ddr0 read reorder buffer. 
  //bit 13.  force to disalbe the clock of read canvas. 
  //bit 12.  force to disalbe the clock of write canvas. 
  //bit 11.  force to disalbe the clock of chan 11.
  //bit 10.  force to disalbe the clock of chan 11.
  //bit 9.   force to disalbe the clock of chan 11.
  //bit 8.   force to disalbe the clock of chan 11.
  //bit 7.   force to disalbe the clock of chan 11.
  //bit 6.   force to disalbe the clock of chan 11.
  //bit 5.   force to disalbe the clock of chan 11.
  //bit 4.   force to disalbe the clock of chan 11.
  //bit 3.   force to disalbe the clock of chan 11.
  //bit 2.   force to disalbe the clock of chan 11.
  //bit 1.   force to disalbe the clock of chan 11.
  //bit 0.   force to disalbe the clock of chan 11.

#define P_DMC_CHAN_STS             DMC_REG_BASE + (0x32 << 2)

#define P_DMC_CMD_FILTER_CTRL1  DMC_REG_BASE + (0x40 << 2)
   //bit 29:20  nugt read buf full access limit
   //bit 19:10.  ugt read access limit.
   //bit 9:0  nugt read access limit 

#define P_DMC_CMD_FILTER_CTRL2  DMC_REG_BASE + (0x41 << 2)
   //bit 29:20  ugt read buf full access limit
   //bit 9:0  nugt write access pending limit 
   //bit 19:10.  ugt write access pending limit.

#define P_DMC_CMD_FILTER_CTRL3  DMC_REG_BASE + (0x42 << 2)
  //bit 27.    force wbuf empty.
  //bit 26:22  wbuf high level number
  //bit 21:17  wbuf mid  level number
  //bit 16:12  wbuf low level number
  //bit 11:8   rbuf high level number
  //bit 7:4    rbuf middle level number
  //bit 3:0    rbuf low level number

#define P_DMC_CMD_FILTER_CTRL4  DMC_REG_BASE + (0x43 << 2)
  //bit 24:20.  tHIT latency.  page hit command latency for next same page not hit command.
  //bit 19:15.  tIDLE latency. page idle command latency for next same page not hit command.
  //bit 14:10.  tMISS latency. page miss command latency for next same page not hit command.
  //bit 9:0.    rbuf idle timer to let the wbuf output.

#define P_DMC_CMD_BUFFER_CTRL   DMC_REG_BASE + (0x44 << 2)
  //bit 30:25  total write buffer number. default 32.
  //bit 24:20  total read buffer number. default 16.
  //bit 19:10  ugt age limit. over this age limit, this read buffer would turn to super urgent.
  //bit 9:0  nugt age limit. over this age limit, this read buffer would turn to super urgent.

#define P_DMC_AM0_CHAN_CTRL                DMC_REG_BASE + (0x60 << 2)
#define P_DMC_AM0_HOLD_CTRL                DMC_REG_BASE + (0x61 << 2)
#define P_DMC_AM0_QOS_INC    		 DMC_REG_BASE + (0x62 << 2)
#define P_DMC_AM0_QOS_INCBK  		 DMC_REG_BASE + (0x63 << 2)
#define P_DMC_AM0_QOS_DEC    		 DMC_REG_BASE + (0x64 << 2)
#define P_DMC_AM0_QOS_DECBK  		 DMC_REG_BASE + (0x65 << 2)
#define P_DMC_AM0_QOS_DIS    		 DMC_REG_BASE + (0x66 << 2)
#define P_DMC_AM0_QOS_DISBK  		 DMC_REG_BASE + (0x67 << 2)
#define P_DMC_AM0_QOS_CTRL0  		 DMC_REG_BASE + (0x68 << 2)
#define P_DMC_AM0_QOS_CTRL1  		 DMC_REG_BASE + (0x69 << 2)

#define P_DMC_AM1_CHAN_CTRL                DMC_REG_BASE + (0x6a << 2)
#define P_DMC_AM1_HOLD_CTRL                DMC_REG_BASE + (0x6b << 2)
#define P_DMC_AM1_QOS_INC    		 DMC_REG_BASE + (0x6c << 2)
#define P_DMC_AM1_QOS_INCBK  		 DMC_REG_BASE + (0x6d << 2)
#define P_DMC_AM1_QOS_DEC    		 DMC_REG_BASE + (0x6e << 2)
#define P_DMC_AM1_QOS_DECBK  		 DMC_REG_BASE + (0x6f << 2)
#define P_DMC_AM1_QOS_DIS    		 DMC_REG_BASE + (0x70 << 2)
#define P_DMC_AM1_QOS_DISBK  		 DMC_REG_BASE + (0x71 << 2)
#define P_DMC_AM1_QOS_CTRL0  		 DMC_REG_BASE + (0x72 << 2)
#define P_DMC_AM1_QOS_CTRL1  		 DMC_REG_BASE + (0x73 << 2)

#define P_DMC_AM2_CHAN_CTRL                DMC_REG_BASE + (0x74 << 2)
#define P_DMC_AM2_HOLD_CTRL                DMC_REG_BASE + (0x75 << 2)
#define P_DMC_AM2_QOS_INC    		 DMC_REG_BASE + (0x76 << 2)
#define P_DMC_AM2_QOS_INCBK  		 DMC_REG_BASE + (0x77 << 2)
#define P_DMC_AM2_QOS_DEC    		 DMC_REG_BASE + (0x78 << 2)
#define P_DMC_AM2_QOS_DECBK  		 DMC_REG_BASE + (0x79 << 2)
#define P_DMC_AM2_QOS_DIS    		 DMC_REG_BASE + (0x7a << 2)
#define P_DMC_AM2_QOS_DISBK  		 DMC_REG_BASE + (0x7b << 2)
#define P_DMC_AM2_QOS_CTRL0  		 DMC_REG_BASE + (0x7c << 2)
#define P_DMC_AM2_QOS_CTRL1  		 DMC_REG_BASE + (0x7d << 2)

#define P_DMC_AM3_CHAN_CTRL                DMC_REG_BASE + (0x7e << 2)
#define P_DMC_AM3_HOLD_CTRL                DMC_REG_BASE + (0x7f << 2)
#define P_DMC_AM3_QOS_INC    		 DMC_REG_BASE + (0x80 << 2)
#define P_DMC_AM3_QOS_INCBK  		 DMC_REG_BASE + (0x81 << 2)
#define P_DMC_AM3_QOS_DEC    		 DMC_REG_BASE + (0x82 << 2)
#define P_DMC_AM3_QOS_DECBK  		 DMC_REG_BASE + (0x83 << 2)
#define P_DMC_AM3_QOS_DIS    		 DMC_REG_BASE + (0x84 << 2)
#define P_DMC_AM3_QOS_DISBK  		 DMC_REG_BASE + (0x85 << 2)
#define P_DMC_AM3_QOS_CTRL0  		 DMC_REG_BASE + (0x86 << 2)
#define P_DMC_AM3_QOS_CTRL1  		 DMC_REG_BASE + (0x87 << 2)

#define P_DMC_AM4_CHAN_CTRL                DMC_REG_BASE + (0x88 << 2)
#define P_DMC_AM4_HOLD_CTRL                DMC_REG_BASE + (0x89 << 2)
#define P_DMC_AM4_QOS_INC    		 DMC_REG_BASE + (0x8a << 2)
#define P_DMC_AM4_QOS_INCBK  		 DMC_REG_BASE + (0x8b << 2)
#define P_DMC_AM4_QOS_DEC    		 DMC_REG_BASE + (0x8c << 2)
#define P_DMC_AM4_QOS_DECBK  		 DMC_REG_BASE + (0x8d << 2)
#define P_DMC_AM4_QOS_DIS    		 DMC_REG_BASE + (0x8e << 2)
#define P_DMC_AM4_QOS_DISBK  		 DMC_REG_BASE + (0x8f << 2)
#define P_DMC_AM4_QOS_CTRL0  		 DMC_REG_BASE + (0x90 << 2)
#define P_DMC_AM4_QOS_CTRL1  		 DMC_REG_BASE + (0x91 << 2)

#define P_DMC_AM5_CHAN_CTRL  	         DMC_REG_BASE + (0x92 << 2)
#define P_DMC_AM5_HOLD_CTRL                DMC_REG_BASE + (0x93 << 2)
#define P_DMC_AM5_QOS_INC    		 DMC_REG_BASE + (0x94 << 2)
#define P_DMC_AM5_QOS_INCBK  		 DMC_REG_BASE + (0x95 << 2)
#define P_DMC_AM5_QOS_DEC    		 DMC_REG_BASE + (0x96 << 2)
#define P_DMC_AM5_QOS_DECBK  		 DMC_REG_BASE + (0x97 << 2)
#define P_DMC_AM5_QOS_DIS    		 DMC_REG_BASE + (0x98 << 2)
#define P_DMC_AM5_QOS_DISBK  		 DMC_REG_BASE + (0x99 << 2)
#define P_DMC_AM5_QOS_CTRL0  		 DMC_REG_BASE + (0x9a << 2)
#define P_DMC_AM5_QOS_CTRL1  		 DMC_REG_BASE + (0x9b << 2)

#define P_DMC_AM6_CHAN_CTRL                DMC_REG_BASE + (0x9c << 2)
#define P_DMC_AM6_HOLD_CTRL                DMC_REG_BASE + (0x9d << 2)
#define P_DMC_AM6_QOS_INC    		 DMC_REG_BASE + (0x9e << 2)
#define P_DMC_AM6_QOS_INCBK  		 DMC_REG_BASE + (0x9f << 2)
#define P_DMC_AM6_QOS_DEC    		 DMC_REG_BASE + (0xa0 << 2)
#define P_DMC_AM6_QOS_DECBK  		 DMC_REG_BASE + (0xa1 << 2)
#define P_DMC_AM6_QOS_DIS    		 DMC_REG_BASE + (0xa2 << 2)
#define P_DMC_AM6_QOS_DISBK  		 DMC_REG_BASE + (0xa3 << 2)
#define P_DMC_AM6_QOS_CTRL0  		 DMC_REG_BASE + (0xa4 << 2)
#define P_DMC_AM6_QOS_CTRL1  		 DMC_REG_BASE + (0xa5 << 2)

#define P_DMC_AM7_CHAN_CTRL                DMC_REG_BASE + (0xa6 << 2)
#define P_DMC_AM7_HOLD_CTRL                DMC_REG_BASE + (0xa7 << 2)
#define P_DMC_AM7_QOS_INC    		 DMC_REG_BASE + (0xa8 << 2)
#define P_DMC_AM7_QOS_INCBK  		 DMC_REG_BASE + (0xa9 << 2)
#define P_DMC_AM7_QOS_DEC    		 DMC_REG_BASE + (0xaa << 2)
#define P_DMC_AM7_QOS_DECBK  		 DMC_REG_BASE + (0xab << 2)
#define P_DMC_AM7_QOS_DIS    		 DMC_REG_BASE + (0xac << 2)
#define P_DMC_AM7_QOS_DISBK  		 DMC_REG_BASE + (0xad << 2)
#define P_DMC_AM7_QOS_CTRL0  		 DMC_REG_BASE + (0xae << 2)
#define P_DMC_AM7_QOS_CTRL1  		 DMC_REG_BASE + (0xaf << 2)

#define P_DMC_AXI0_CHAN_CTRL               DMC_REG_BASE + (0xb0 << 2)
#define P_DMC_AXI0_HOLD_CTRL               DMC_REG_BASE + (0xb1 << 2)
#define P_DMC_AXI0_QOS_INC    		 DMC_REG_BASE + (0xb2 << 2) 
#define P_DMC_AXI0_QOS_INCBK  		 DMC_REG_BASE + (0xb3 << 2)
#define P_DMC_AXI0_QOS_DEC    		 DMC_REG_BASE + (0xb4 << 2)
#define P_DMC_AXI0_QOS_DECBK  		 DMC_REG_BASE + (0xb5 << 2)
#define P_DMC_AXI0_QOS_DIS    		 DMC_REG_BASE + (0xb6 << 2)
#define P_DMC_AXI0_QOS_DISBK  		 DMC_REG_BASE + (0xb7 << 2)
#define P_DMC_AXI0_QOS_CTRL0  		 DMC_REG_BASE + (0xb8 << 2)
#define P_DMC_AXI0_QOS_CTRL1  		 DMC_REG_BASE + (0xb9 << 2)

#define P_DMC_AXI1_CHAN_CTRL               DMC_REG_BASE + (0xba << 2)
#define P_DMC_AXI1_HOLD_CTRL               DMC_REG_BASE + (0xbb << 2)
#define P_DMC_AXI1_QOS_INC    		 DMC_REG_BASE + (0xbc << 2) 
#define P_DMC_AXI1_QOS_INCBK  		 DMC_REG_BASE + (0xbd << 2)
#define P_DMC_AXI1_QOS_DEC    		 DMC_REG_BASE + (0xbe << 2)
#define P_DMC_AXI1_QOS_DECBK  		 DMC_REG_BASE + (0xbf << 2)
#define P_DMC_AXI1_QOS_DIS    		 DMC_REG_BASE + (0xc0 << 2)
#define P_DMC_AXI1_QOS_DISBK  		 DMC_REG_BASE + (0xc1 << 2)
#define P_DMC_AXI1_QOS_CTRL0  		 DMC_REG_BASE + (0xc2 << 2)
#define P_DMC_AXI1_QOS_CTRL1  		 DMC_REG_BASE + (0xc3 << 2)

#define P_DMC_AXI2_CHAN_CTRL               DMC_REG_BASE + (0xc4<<2) 
#define P_DMC_AXI2_HOLD_CTRL               DMC_REG_BASE + (0xc5<<2)
#define P_DMC_AXI2_QOS_INC    		 DMC_REG_BASE + (0xc6 << 2) 
#define P_DMC_AXI2_QOS_INCBK  		 DMC_REG_BASE + (0xc7 << 2)
#define P_DMC_AXI2_QOS_DEC    		 DMC_REG_BASE + (0xc8 << 2)
#define P_DMC_AXI2_QOS_DECBK  		 DMC_REG_BASE + (0xc9 << 2)
#define P_DMC_AXI2_QOS_DIS    		 DMC_REG_BASE + (0xca << 2)
#define P_DMC_AXI2_QOS_DISBK  		 DMC_REG_BASE + (0xcb << 2)
#define P_DMC_AXI2_QOS_CTRL0  		 DMC_REG_BASE + (0xcc << 2)
#define P_DMC_AXI2_QOS_CTRL1  		 DMC_REG_BASE + (0xcd << 2)

#define P_DMC_AXI3_CHAN_CTRL               DMC_REG_BASE + (0xce << 2) 
#define P_DMC_AXI3_HOLD_CTRL               DMC_REG_BASE + (0xcf << 2)
#define P_DMC_AXI3_QOS_INC    		 DMC_REG_BASE + (0xd0 << 2) 
#define P_DMC_AXI3_QOS_INCBK  		 DMC_REG_BASE + (0xd1 << 2)
#define P_DMC_AXI3_QOS_DEC    		 DMC_REG_BASE + (0xd2 << 2)
#define P_DMC_AXI3_QOS_DECBK  		 DMC_REG_BASE + (0xd3 << 2)
#define P_DMC_AXI3_QOS_DIS    		 DMC_REG_BASE + (0xd4 << 2)
#define P_DMC_AXI3_QOS_DISBK  		 DMC_REG_BASE + (0xd5 << 2)
#define P_DMC_AXI3_QOS_CTRL0  		 DMC_REG_BASE + (0xd6 << 2)
#define P_DMC_AXI3_QOS_CTRL1  		 DMC_REG_BASE + (0xd7 << 2)

#define P_DMC_AXI4_CHAN_CTRL               DMC_REG_BASE + (0xd8  << 2)
#define P_DMC_AXI4_HOLD_CTRL               DMC_REG_BASE + (0xd9 << 2)
#define P_DMC_AXI4_QOS_INC    		 DMC_REG_BASE + (0xda << 2) 
#define P_DMC_AXI4_QOS_INCBK  		 DMC_REG_BASE + (0xdb << 2)
#define P_DMC_AXI4_QOS_DEC    		 DMC_REG_BASE + (0xdc << 2)
#define P_DMC_AXI4_QOS_DECBK  		 DMC_REG_BASE + (0xdd << 2)
#define P_DMC_AXI4_QOS_DIS    		 DMC_REG_BASE + (0xde << 2)
#define P_DMC_AXI4_QOS_DISBK  		 DMC_REG_BASE + (0xdf << 2)
#define P_DMC_AXI4_QOS_CTRL0  		 DMC_REG_BASE + (0xe0 << 2)
#define P_DMC_AXI4_QOS_CTRL1  		 DMC_REG_BASE + (0xe1 << 2)

#define P_DMC_AXI5_CHAN_CTRL               DMC_REG_BASE + (0xe2 << 2)
#define P_DMC_AXI5_HOLD_CTRL               DMC_REG_BASE + (0xe3 << 2)
#define P_DMC_AXI5_QOS_INC    		 DMC_REG_BASE + (0xe4 << 2) 
#define P_DMC_AXI5_QOS_INCBK  		 DMC_REG_BASE + (0xe5 << 2)
#define P_DMC_AXI5_QOS_DEC    		 DMC_REG_BASE + (0xe6 << 2)
#define P_DMC_AXI5_QOS_DECBK  		 DMC_REG_BASE + (0xe7 << 2)
#define P_DMC_AXI5_QOS_DIS    		 DMC_REG_BASE + (0xe8 << 2)
#define P_DMC_AXI5_QOS_DISBK  		 DMC_REG_BASE + (0xe9 << 2)
#define P_DMC_AXI5_QOS_CTRL0  		 DMC_REG_BASE + (0xea << 2)
#define P_DMC_AXI5_QOS_CTRL1  		 DMC_REG_BASE + (0xeb << 2)

#define P_DMC_AXI6_CHAN_CTRL               DMC_REG_BASE + (0xec << 2) 
#define P_DMC_AXI6_HOLD_CTRL               DMC_REG_BASE + (0xed << 2)
#define P_DMC_AXI6_QOS_INC    		 DMC_REG_BASE + (0xee << 2) 
#define P_DMC_AXI6_QOS_INCBK  		 DMC_REG_BASE + (0xef << 2)
#define P_DMC_AXI6_QOS_DEC    		 DMC_REG_BASE + (0xf0 << 2)
#define P_DMC_AXI6_QOS_DECBK  		 DMC_REG_BASE + (0xf1 << 2)
#define P_DMC_AXI6_QOS_DIS    		 DMC_REG_BASE + (0xf2 << 2)
#define P_DMC_AXI6_QOS_DISBK  		 DMC_REG_BASE + (0xf3 << 2)
#define P_DMC_AXI6_QOS_CTRL0  		 DMC_REG_BASE + (0xf4 << 2)
#define P_DMC_AXI6_QOS_CTRL1  		 DMC_REG_BASE + (0xf5 << 2)

#define P_DMC_AXI7_CHAN_CTRL               DMC_REG_BASE + (0xf6 << 2) 
#define P_DMC_AXI7_HOLD_CTRL               DMC_REG_BASE + (0xf7 << 2)
#define P_DMC_AXI7_QOS_INC    		 DMC_REG_BASE + (0xf8 << 2) 
#define P_DMC_AXI7_QOS_INCBK  		 DMC_REG_BASE + (0xf9 << 2)
#define P_DMC_AXI7_QOS_DEC    		 DMC_REG_BASE + (0xfa << 2)
#define P_DMC_AXI7_QOS_DECBK  		 DMC_REG_BASE + (0xfb << 2)
#define P_DMC_AXI7_QOS_DIS    		 DMC_REG_BASE + (0xfc << 2)
#define P_DMC_AXI7_QOS_DISBK  		 DMC_REG_BASE + (0xfd << 2)
#define P_DMC_AXI7_QOS_CTRL0  		 DMC_REG_BASE + (0xfe << 2)
#define P_DMC_AXI7_QOS_CTRL1  		 DMC_REG_BASE + (0xff << 2)

#endif

#endif //__M8_MMC_H__
