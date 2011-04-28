#ifndef M6TV_MMC
#define M6TV_MMC

#define MMC_Wr(addr, data) *(volatile unsigned long *) addr = data
#define MMC_Rd(addr) *(volatile unsigned long *)  addr 
//#define writel(v,c) *(volatile unsigned long *) c = v
//#define readl(c)    *(volatile unsigned long *) c


//Please check UPCTL data sheet for UPCTL register spec.
#define P_UPCTL_STAT_ADDR 		    0xc8000008
#define P_UPCTL_INTRSTAT_ADDR 		0xc800000c
#define P_UPCTL_SCTL_ADDR 		    0xc8000004
#define P_UPCTL_SCFG_ADDR 		    0xc8000000
#define P_UPCTL_POWSTAT_ADDR 		0xc8000048
#define P_UPCTL_MRRSTAT0_ADDR 		0xc8000064
#define P_UPCTL_CMDTSTAT_ADDR 		0xc800004c
#define P_UPCTL_MCMD_ADDR 		    0xc8000040
#define P_UPCTL_MRRSTAT1_ADDR 		0xc8000068
#define P_UPCTL_MRRCFG0_ADDR 		0xc8000060
#define P_UPCTL_CMDTSTATEN_ADDR     0xc8000050
#define P_UPCTL_POWCTL_ADDR 		0xc8000044
#define P_UPCTL_LPDDR2ZQCFG_ADDR 	0xc800008c
#define P_UPCTL_PPCFG_ADDR 		0xc8000084
#define P_UPCTL_MCFG1_ADDR 		0xc800007c
#define P_UPCTL_MSTAT_ADDR 		0xc8000088
#define P_UPCTL_MCFG_ADDR 		0xc8000080
#define P_UPCTL_DTUAWDT_ADDR 		0xc80000b0
#define P_UPCTL_DTUPRD2_ADDR 		0xc80000a8
#define P_UPCTL_DTUPRD3_ADDR 		0xc80000ac
#define P_UPCTL_DTUNE_ADDR 		0xc800009c
#define P_UPCTL_DTUPDES_ADDR 		0xc8000094
#define P_UPCTL_DTUNA_ADDR 		0xc8000098
#define P_UPCTL_DTUPRD0_ADDR 		0xc80000a0
#define P_UPCTL_DTUPRD1_ADDR 		0xc80000a4
#define P_UPCTL_TCKSRE_ADDR 		0xc8000124
#define P_UPCTL_TZQCSI_ADDR 		0xc800011c
#define P_UPCTL_TINIT_ADDR 		0xc80000c4
#define P_UPCTL_TDPD_ADDR 		0xc8000144
#define P_UPCTL_TOGCNT1U_ADDR 		0xc80000c0
#define P_UPCTL_TCKE_ADDR 		0xc800012c
#define P_UPCTL_TMOD_ADDR 		0xc8000130
#define P_UPCTL_TEXSR_ADDR 		0xc800010c
#define P_UPCTL_TAL_ADDR 		0xc80000e4
#define P_UPCTL_TRTP_ADDR 		0xc8000100
#define P_UPCTL_TCKSRX_ADDR 		0xc8000128
#define P_UPCTL_TRTW_ADDR 		0xc80000e0
#define P_UPCTL_TCWL_ADDR 		0xc80000ec
#define P_UPCTL_TWR_ADDR 		0xc8000104
#define P_UPCTL_TCL_ADDR 		0xc80000e8
#define P_UPCTL_TDQS_ADDR 		0xc8000120
#define P_UPCTL_TRSTH_ADDR 		0xc80000c8
#define P_UPCTL_TRCD_ADDR 		0xc80000f8
#define P_UPCTL_TXP_ADDR 		0xc8000110
#define P_UPCTL_TOGCNT100N_ADDR 		0xc80000cc
#define P_UPCTL_TMRD_ADDR 		0xc80000d4
#define P_UPCTL_TRSTL_ADDR 		0xc8000134
#define P_UPCTL_TREFI_ADDR 		0xc80000d0
#define P_UPCTL_TRAS_ADDR 		0xc80000f0
#define P_UPCTL_TWTR_ADDR 		0xc8000108
#define P_UPCTL_TRC_ADDR 		0xc80000f4
#define P_UPCTL_TRFC_ADDR 		0xc80000d8
#define P_UPCTL_TMRR_ADDR 		0xc800013c
#define P_UPCTL_TCKESR_ADDR 		0xc8000140
#define P_UPCTL_TZQCL_ADDR 		0xc8000138
#define P_UPCTL_TRRD_ADDR 		0xc80000fc
#define P_UPCTL_TRP_ADDR 		0xc80000dc
#define P_UPCTL_TZQCS_ADDR 		0xc8000118
#define P_UPCTL_TXPDLL_ADDR 		0xc8000114
#define P_UPCTL_ECCCFG_ADDR 		0xc8000180
#define P_UPCTL_ECCLOG_ADDR 		0xc800018c
#define P_UPCTL_ECCCLR_ADDR 		0xc8000188
#define P_UPCTL_ECCTST_ADDR 		0xc8000184
#define P_UPCTL_DTUWD0_ADDR 		0xc8000210
#define P_UPCTL_DTUWD1_ADDR 		0xc8000214
#define P_UPCTL_DTUWACTL_ADDR 		0xc8000200
#define P_UPCTL_DTULFSRRD_ADDR 		0xc8000238
#define P_UPCTL_DTUWD2_ADDR 		0xc8000218
#define P_UPCTL_DTUWD3_ADDR 		0xc800021c
#define P_UPCTL_DTULFSRWD_ADDR 		0xc8000234
#define P_UPCTL_DTURACTL_ADDR 		0xc8000204
#define P_UPCTL_DTUWDM_ADDR 		0xc8000220
#define P_UPCTL_DTURD0_ADDR 		0xc8000224
#define P_UPCTL_DTURD1_ADDR 		0xc8000228
#define P_UPCTL_DTURD2_ADDR 		0xc800022c
#define P_UPCTL_DTURD3_ADDR 		0xc8000230
#define P_UPCTL_DTUCFG_ADDR 		0xc8000208
#define P_UPCTL_DTUEAF_ADDR 		0xc800023c
#define P_UPCTL_DTUECTL_ADDR 		0xc800020c
#define P_UPCTL_DFIODTCFG1_ADDR 		0xc8000248
#define P_UPCTL_DFITCTRLDELAY_ADDR 	0xc8000240
#define P_UPCTL_DFIODTRANKMAP_ADDR 	0xc800024c
#define P_UPCTL_DFIODTCFG_ADDR 		0xc8000244
#define P_UPCTL_DFITPHYWRLAT_ADDR 	0xc8000254
#define P_UPCTL_DFITPHYWRDATA_ADDR 	0xc8000250
#define P_UPCTL_DFITRDDATAEN_ADDR 	0xc8000260
#define P_UPCTL_DFITPHYRDLAT_ADDR 	0xc8000264
#define P_UPCTL_DFITREFMSKI_ADDR 	0xc8000294
#define P_UPCTL_DFITPHYUPDTYPE0_ADDR 	0xc8000270
#define P_UPCTL_DFITPHYUPDTYPE1_ADDR 	0xc8000274
#define P_UPCTL_DFITCTRLUPDDLY_ADDR 	0xc8000288
#define P_UPCTL_DFITPHYUPDTYPE2_ADDR 	0xc8000278
#define P_UPCTL_DFITCTRLUPDMIN_ADDR 	0xc8000280
#define P_UPCTL_DFITPHYUPDTYPE3_ADDR 	0xc800027c
#define P_UPCTL_DFIUPDCFG_ADDR 		0xc8000290
#define P_UPCTL_DFITCTRLUPDMAX_ADDR 	0xc8000284
#define P_UPCTL_DFITCTRLUPDI_ADDR 	0xc8000298
#define P_UPCTL_DFITRRDLVLEN_ADDR 	0xc80002b8
#define P_UPCTL_DFITRSTAT0_ADDR 		0xc80002b0
#define P_UPCTL_DFITRWRLVLEN_ADDR 	0xc80002b4
#define P_UPCTL_DFITRCFG0_ADDR 		0xc80002ac
#define P_UPCTL_DFITRRDLVLGATEEN_ADDR 	0xc80002bc
#define P_UPCTL_DFISTSTAT0_ADDR 		0xc80002c0
#define P_UPCTL_DFISTPARLOG_ADDR 	0xc80002e0
#define P_UPCTL_DFITDRAMCLKEN_ADDR 	0xc80002d0
#define P_UPCTL_DFISTPARCLR_ADDR 	0xc80002dc
#define P_UPCTL_DFISTCFG0_ADDR 		0xc80002c4
#define P_UPCTL_DFISTCFG1_ADDR 		0xc80002c8
#define P_UPCTL_DFISTCFG2_ADDR 		0xc80002d8
#define P_UPCTL_DFITDRAMCLKDIS_ADDR 	0xc80002d4
#define P_UPCTL_DFILPCFG0_ADDR 		0xc80002f0
#define P_UPCTL_DFITRWRLVLDELAY0_ADDR 	0xc8000318
#define P_UPCTL_DFITRWRLVLDELAY1_ADDR 	0xc800031c
#define P_UPCTL_DFITRWRLVLDELAY2_ADDR 	0xc8000320
#define P_UPCTL_DFITRRDLVLRESP0_ADDR 	0xc800030c
#define P_UPCTL_DFITRRDLVLRESP1_ADDR 	0xc8000310
#define P_UPCTL_DFITRRDLVLRESP2_ADDR 	0xc8000314
#define P_UPCTL_DFITRWRLVLRESP0_ADDR 	0xc8000300
#define P_UPCTL_DFITRRDLVLDELAY0_ADDR 	0xc8000324
#define P_UPCTL_DFITRRDLVLDELAY1_ADDR 	0xc8000328
#define P_UPCTL_DFITRWRLVLRESP1_ADDR 	0xc8000304
#define P_UPCTL_DFITRRDLVLDELAY2_ADDR 	0xc800032c
#define P_UPCTL_DFITRWRLVLRESP2_ADDR 	0xc8000308
#define P_UPCTL_DFITRRDLVLGATEDELAY0_ADDR 	0xc8000330
#define P_UPCTL_DFITRCMD_ADDR 			0xc800033c
#define P_UPCTL_DFITRRDLVLGATEDELAY1_ADDR 	0xc8000334
#define P_UPCTL_DFITRRDLVLGATEDELAY2_ADDR 	0xc8000338
#define P_UPCTL_IPTR_ADDR 		0xc80003fc
#define P_UPCTL_IPVR_ADDR 		0xc80003f8

//Please check DDR_PHY PUB data sheet for PUB regsiter spec.
#define P_PUB_RIDR_ADDR                 0xc8001000
#define P_PUB_PIR_ADDR                  0xc8001004
#define P_PUB_PGCR0_ADDR                0xc8001008
#define P_PUB_PGCR1_ADDR                0xc800100c 
#define P_PUB_PGSR0_ADDR                0xc8001010
#define P_PUB_PGSR1_ADDR                0xc8001014
#define P_PUB_PLLCR_ADDR                0xc8001018
#define P_PUB_PTR0_ADDR                 0xc800101c
#define P_PUB_PTR1_ADDR                 0xc8001020
#define P_PUB_PTR2_ADDR                 0xc8001024
#define P_PUB_PTR3_ADDR                 0xc8001028
#define P_PUB_PTR4_ADDR                 0xc800102c
#define P_PUB_ACMDLR_ADDR               0xc8001030
#define P_PUB_ACBDLR_ADDR               0xc8001034  
#define P_PUB_ACIOCR_ADDR               0xc8001038
#define P_PUB_DXCCR_ADDR                0xc800103c
#define P_PUB_DSGCR_ADDR                0xc8001040
#define P_PUB_DCR_ADDR                  0xc8001044
#define P_PUB_DTPR0_ADDR                0xc8001048
#define P_PUB_DTPR1_ADDR                0xc800104c
#define P_PUB_DTPR2_ADDR                0xc8001050
#define P_PUB_MR0_ADDR                  0xc8001054
#define P_PUB_MR1_ADDR                  0xc8001058
#define P_PUB_MR2_ADDR                  0xc800105c
#define P_PUB_MR3_ADDR                  0xc8001060
#define P_PUB_ODTCR_ADDR                0xc8001064
#define P_PUB_DTCR_ADDR                 0xc8001068
#define P_PUB_DTAR0_ADDR                0xc800106c
#define P_PUB_DTAR1_ADDR                0xc8001070
#define P_PUB_DTAR2_ADDR                0xc8001074
#define P_PUB_DTAR3_ADDR                0xc8001078
#define P_PUB_DTDR0_ADDR                0xc800107c
#define P_PUB_DTDR1_ADDR                0xc8001080
#define P_PUB_DTEDR0_ADDR               0xc8001084
#define P_PUB_DTEDR1_ADDR               0xc8001088
#define P_PUB_PGCR2_ADDR                0xc800108c

//DCU Register
#define P_PUB_DCUAR_ADDR                0xc80010c0
#define P_PUB_DCUDR_ADDR                0xc80010c4
#define P_PUB_DCURR_ADDR                0xc80010c8
#define P_PUB_DCULR_ADDR                0xc80010cc
#define P_PUB_DCUGCR_ADDR               0xc80010d0
#define P_PUB_DCUTPR_ADDR               0xc80010d4
#define P_PUB_DCUSR0_ADDR               0xc80010d8
#define P_PUB_DCUSR1_ADDR               0xc80010dc
//BIST Registers
#define P_PUB_BISTRR_ADDR       0xc8001100
#define P_PUB_BISTMSKR0_ADDR    0xc8001104
#define P_PUB_BISTMSKR1_ADDR    0xc8001108
#define P_PUB_BISTWCR_ADDR      0xc800110c
#define P_PUB_BISTLSR_ADDR      0xc8001110
#define P_PUB_BISTAR0_ADDR      0xc8001114
#define P_PUB_BISTAR1_ADDR      0xc8001118
#define P_PUB_BISTAR2_ADDR      0xc800111c
#define P_PUB_BISTUDPR_ADDR     0xc8001120
#define P_PUB_BISTGSR_ADDR      0xc8001124
#define P_PUB_BISTWER_ADDR      0xc8001128
#define P_PUB_BISTBER0_ADDR     0xc800112c
#define P_PUB_BISTBER1_ADDR     0xc8001130
#define P_PUB_BISTBER2_ADDR     0xc8001134
#define P_PUB_BISTWCSR_ADDR     0xc8001138
#define P_PUB_BISTFWR0_ADDR     0xc800113c
#define P_PUB_BISTFWR1_ADDR     0xc8001140
#define P_PUB_GPR0_ADDR                 0xc8001178
#define P_PUB_GPR1_ADDR                 0xc800117c
#define P_PUB_ZQ0CR0_ADDR               0xc8001180
#define P_PUB_ZQ0CR1_ADDR               0xc8001184
#define P_PUB_ZQ0SR0_ADDR               0xc8001188
#define P_PUB_ZQ0SR1_ADDR               0xc800118c
#define P_PUB_ZQ1CR0_ADDR               0xc8001190
#define P_PUB_ZQ1CR1_ADDR               0xc8001194
#define P_PUB_ZQ1SR0_ADDR               0xc8001198
#define P_PUB_ZQ1SR1_ADDR               0xc800119c
#define P_PUB_ZQ2CR0_ADDR               0xc80011a0
#define P_PUB_ZQ2CR1_ADDR               0xc80011a4
#define P_PUB_ZQ2SR0_ADDR               0xc80011a8
#define P_PUB_ZQ2SR1_ADDR               0xc80011ac
#define P_PUB_ZQ3CR0_ADDR               0xc80011b0
#define P_PUB_ZQ3CR1_ADDR               0xc80011b4
#define P_PUB_ZQ3SR0_ADDR               0xc80011b8
#define P_PUB_ZQ3SR1_ADDR               0xc80011bc
#define P_PUB_DX0GCR_ADDR               0xc80011c0
#define P_PUB_DX0GSR0_ADDR              0xc80011c4
#define P_PUB_DX0GSR1_ADDR              0xc80011c8
#define P_PUB_DX0BDLR0_ADDR             0xc80011cc
#define P_PUB_DX0BDLR1_ADDR             0xc80011d0
#define P_PUB_DX0BDLR2_ADDR             0xc80011d4
#define P_PUB_DX0BDLR3_ADDR             0xc80011d8
#define P_PUB_DX0BDLR4_ADDR             0xc80011dc
#define P_PUB_DX0LCDLR0_ADDR            0xc80011e0
#define P_PUB_DX0LCDLR1_ADDR            0xc80011e4
#define P_PUB_DX0LCDLR2_ADDR            0xc80011e8
#define P_PUB_DX0MDLR_ADDR              0xc80011ec
#define P_PUB_DX0GTR_ADDR               0xc80011f0
#define P_PUB_DX0GSR2_ADDR              0xc80011f4
#define P_PUB_DX1GCR_ADDR               0xc8001200
#define P_PUB_DX1GSR0_ADDR              0xc8001204
#define P_PUB_DX1GSR1_ADDR              0xc8001208
#define P_PUB_DX1BDLR0_ADDR             0xc800120c
#define P_PUB_DX1BDLR1_ADDR             0xc8001210
#define P_PUB_DX1BDLR2_ADDR             0xc8001214
#define P_PUB_DX1BDLR3_ADDR             0xc8001218
#define P_PUB_DX1BDLR4_ADDR             0xc800121c
#define P_PUB_DX1LCDLR0_ADDR            0xc8001220
#define P_PUB_DX1LCDLR1_ADDR            0xc8001224
#define P_PUB_DX1LCDLR2_ADDR            0xc8001228
#define P_PUB_DX1MDLR_ADDR              0xc800122c
#define P_PUB_DX1GTR_ADDR               0xc8001230
#define P_PUB_DX1GSR2_ADDR              0xc8001234
#define P_PUB_DX2GCR_ADDR               0xc8001240
#define P_PUB_DX2GSR0_ADDR              0xc8001244
#define P_PUB_DX2GSR1_ADDR              0xc8001248
#define P_PUB_DX2BDLR0_ADDR             0xc800124c
#define P_PUB_DX2BDLR1_ADDR             0xc8001250
#define P_PUB_DX2BDLR2_ADDR             0xc8001254
#define P_PUB_DX2BDLR3_ADDR             0xc8001258
#define P_PUB_DX2BDLR4_ADDR             0xc800125c
#define P_PUB_DX2LCDLR0_ADDR            0xc8001260
#define P_PUB_DX2LCDLR1_ADDR            0xc8001264
#define P_PUB_DX2LCDLR2_ADDR            0xc8001268
#define P_PUB_DX2MDLR_ADDR              0xc800126c
#define P_PUB_DX2GTR_ADDR               0xc8001270
#define P_PUB_DX2GSR2_ADDR              0xc8001274
#define P_PUB_DX3GCR_ADDR               0xc8001280
#define P_PUB_DX3GSR0_ADDR              0xc8001284
#define P_PUB_DX3GSR1_ADDR              0xc8001288
#define P_PUB_DX3BDLR0_ADDR             0xc800128c
#define P_PUB_DX3BDLR1_ADDR             0xc8001290
#define P_PUB_DX3BDLR2_ADDR             0xc8001294
#define P_PUB_DX3BDLR3_ADDR             0xc8001298
#define P_PUB_DX3BDLR4_ADDR             0xc800129c
#define P_PUB_DX3LCDLR0_ADDR            0xc80012a0
#define P_PUB_DX3LCDLR1_ADDR            0xc80012a4
#define P_PUB_DX3LCDLR2_ADDR            0xc80012a8
#define P_PUB_DX3MDLR_ADDR              0xc80012ac
#define P_PUB_DX3GTR_ADDR               0xc80012b0
#define P_PUB_DX3GSR2_ADDR              0xc80012b4
#define P_PUB_DX4GCR_ADDR               0xc80012c0
#define P_PUB_DX4GSR0_ADDR              0xc80012c4
#define P_PUB_DX4GSR1_ADDR              0xc80012c8
#define P_PUB_DX4BDLR0_ADDR             0xc80012cc
#define P_PUB_DX4BDLR1_ADDR             0xc80012d0
#define P_PUB_DX4BDLR2_ADDR             0xc80012d4
#define P_PUB_DX4BDLR3_ADDR             0xc80012d8
#define P_PUB_DX4BDLR4_ADDR             0xc80012dc
#define P_PUB_DX4LCDLR0_ADDR            0xc80012e0
#define P_PUB_DX4LCDLR1_ADDR            0xc80012e4
#define P_PUB_DX4LCDLR2_ADDR            0xc80012e8
#define P_PUB_DX4MDLR_ADDR              0xc80012ec
#define P_PUB_DX4GTR_ADDR               0xc80012f0
#define P_PUB_DX4GSR2_ADDR              0xc80012f4
#define P_PUB_DX5GCR_ADDR               0xc8001300
#define P_PUB_DX5GSR0_ADDR              0xc8001304
#define P_PUB_DX5GSR1_ADDR              0xc8001308
#define P_PUB_DX5BDLR0_ADDR             0xc800130c
#define P_PUB_DX5BDLR1_ADDR             0xc8001310
#define P_PUB_DX5BDLR2_ADDR             0xc8001314
#define P_PUB_DX5BDLR3_ADDR             0xc8001318
#define P_PUB_DX5BDLR4_ADDR             0xc800131c
#define P_PUB_DX5LCDLR0_ADDR            0xc8001320
#define P_PUB_DX5LCDLR1_ADDR            0xc8001324
#define P_PUB_DX5LCDLR2_ADDR            0xc8001328
#define P_PUB_DX5MDLR_ADDR              0xc800132c
#define P_PUB_DX5GTR_ADDR               0xc8001330
#define P_PUB_DX5GSR2_ADDR              0xc8001334
#define P_PUB_DX6GCR_ADDR               0xc8001340
#define P_PUB_DX6GSR0_ADDR              0xc8001344
#define P_PUB_DX6GSR1_ADDR              0xc8001348
#define P_PUB_DX6BDLR0_ADDR             0xc800134c
#define P_PUB_DX6BDLR1_ADDR             0xc8001350
#define P_PUB_DX6BDLR2_ADDR             0xc8001354
#define P_PUB_DX6BDLR3_ADDR             0xc8001358
#define P_PUB_DX6BDLR4_ADDR             0xc800135c
#define P_PUB_DX6LCDLR0_ADDR            0xc8001360
#define P_PUB_DX6LCDLR1_ADDR            0xc8001364
#define P_PUB_DX6LCDLR2_ADDR            0xc8001368
#define P_PUB_DX6MDLR_ADDR              0xc800136c
#define P_PUB_DX6GTR_ADDR               0xc8001370
#define P_PUB_DX6GSR2_ADDR              0xc8001374
#define P_PUB_DX7GCR_ADDR               0xc8001380
#define P_PUB_DX7GSR0_ADDR              0xc8001384
#define P_PUB_DX7GSR1_ADDR              0xc8001388
#define P_PUB_DX7BDLR0_ADDR             0xc800138c
#define P_PUB_DX7BDLR1_ADDR             0xc8001390
#define P_PUB_DX7BDLR2_ADDR             0xc8001394
#define P_PUB_DX7BDLR3_ADDR             0xc8001398
#define P_PUB_DX7BDLR4_ADDR             0xc800139c
#define P_PUB_DX7LCDLR0_ADDR            0xc80013a0
#define P_PUB_DX7LCDLR1_ADDR            0xc80013a4
#define P_PUB_DX7LCDLR2_ADDR            0xc80013a8
#define P_PUB_DX7MDLR_ADDR              0xc80013ac
#define P_PUB_DX7GTR_ADDR               0xc80013b0
#define P_PUB_DX7GSR2_ADDR              0xc80013b4
#define P_PUB_DX8GCR_ADDR               0xc80013c0
#define P_PUB_DX8GSR0_ADDR              0xc80013c4
#define P_PUB_DX8GSR1_ADDR              0xc80013c8
#define P_PUB_DX8BDLR0_ADDR             0xc80013cc
#define P_PUB_DX8BDLR1_ADDR             0xc80013d0
#define P_PUB_DX8BDLR2_ADDR             0xc80013d4
#define P_PUB_DX8BDLR3_ADDR             0xc80013d8
#define P_PUB_DX8BDLR4_ADDR             0xc80013dc
#define P_PUB_DX8LCDLR0_ADDR            0xc80013e0
#define P_PUB_DX8LCDLR1_ADDR            0xc80013e4
#define P_PUB_DX8LCDLR2_ADDR            0xc80013e8
#define P_PUB_DX8MDLR_ADDR              0xc80013ec
#define P_PUB_DX8GTR_ADDR               0xc80013f0
#define P_PUB_DX8GSR2_ADDR              0xc80013f4

//DMC register.
#ifndef P_MMC_DDR_CTRL
#define P_MMC_DDR_CTRL        0xc8006000
#endif
  //bit 25:16.   ddr command filter bank and read write over timer limit.
  //bit 7        ddr command filter bank policy. 1 = keep open. 0 : close bank if no request.
  //bit 6.       ddr address map bank mode  1 =  address switch between 4 banks. 0 = address switch between 2 banks.    
  //bit 5:4      ddr rank size.  0, 1, one rank.  2 : 2 ranks.   
  //bit 3:2      ddr row size.  2'b01 : A0~A12.   2'b10 : A0~A13.  2'b11 : A0~A14.  2'b00 : A0~A15. 
  //bit 1:0      ddr col size.  2'b01 : A0~A8,    2'b10 : A0~A9.  

#define P_MMC_QOS0_CTRL0      0xc8006010
   //channel 0 qos control register 0
   //bit 31   enable  channel qos control
   //bit 30   enable the function that increase current request urgent level when inc_ugt_limit meet. 
   //bit 29   enable the function that decrease current request urgent level when dec_ugt_limit meet. 
   //bit 28   enable the function that increase the whole channel request urgent level 
             //when bandwidth requirement is not met and the difference of bandwidth requrement and real bandwidth granted  is larger than inc_qos_limit.
   //bit 27   enable the function that decrease the whole channel request urgent level 
             //when the bandwidth requirement is met and the difference of bandwidth requirement and read bankwidth granged is larger than dec_qos_limit.
   //bit 26   force all requests of this channel to be super urgent request.
   //bit 25   force all requests of this channel increase ungent level. 
   //bit 24   1 : qos control use Vsync and hsync as timing reference.
              //0 : qos control use regular timer as timing reference.
   //bit 23   when FIQ asserted, force this channel to be super urgent request.
   //bit 22   when FIQ asserted, force this channel to be urgent request. 
   //bit 21   when IRQ asserted, force this channel to be super urgent request.
   //bit 20   when IRQ asserted, force this channel to be  urgent requst. 
   //bit 19:18.  not used.
   //bit 17    to clean QOS timers. 
   //bit 15:0.  min_ticker  minimum timer ticker to control if we need increase the current request based on inc_ugt_limit.
              // if timer = min_ticker and granted data < inc_ugt_limit, then current requests of this channels  urgent level + 1 
              // if timer = min_ticker and granted data > dec_ugt_limit, then current requests of this channels  urgent level - 1; 
#define P_MMC_QOS0_CTRL1      0xc8006014
  //31:16     dec_ugt_limit.
  //15:0      inc_ugt_limit.
#define P_MMC_QOS0_CTRL2      0xc8006018
  //31:16    use any ports(upto 16) of this channel as the bandwidth control. 1 = use. 0 = not use. 
  //15:8     bd_ticker.
  //7:0      qos_ticker.  the bandwidth requirement =  bd_ticker/qos_ticker  * 100%.
#define P_MMC_QOS0_CTRL3      0xc800601c
  //inc_qos_limit.
#define P_MMC_QOS0_CTRL4      0xc8006020
  //dec_qos_limit.
#define P_MMC_QOS1_CTRL0      0xc8006024
#define P_MMC_QOS1_CTRL1      0xc8006028
#define P_MMC_QOS1_CTRL2      0xc800602c
#define P_MMC_QOS1_CTRL3      0xc8006030
#define P_MMC_QOS1_CTRL4      0xc8006034
#define P_MMC_QOS2_CTRL0      0xc8006038
#define P_MMC_QOS2_CTRL1      0xc800603c
#define P_MMC_QOS2_CTRL2      0xc8006040
#define P_MMC_QOS2_CTRL3      0xc8006044
#define P_MMC_QOS2_CTRL4      0xc8006048
#define P_MMC_QOS3_CTRL0      0xc800604c
#define P_MMC_QOS3_CTRL1      0xc8006050
#define P_MMC_QOS3_CTRL2      0xc8006054
#define P_MMC_QOS3_CTRL3      0xc8006058
#define P_MMC_QOS3_CTRL4      0xc800605c
#define P_MMC_QOS4_CTRL0      0xc8006060
#define P_MMC_QOS4_CTRL1      0xc8006064
#define P_MMC_QOS4_CTRL2      0xc8006068
#define P_MMC_QOS4_CTRL3      0xc800606c
#define P_MMC_QOS4_CTRL4      0xc8006070
#define P_MMC_QOS5_CTRL0      0xc8006074
#define P_MMC_QOS5_CTRL1      0xc8006078
#define P_MMC_QOS5_CTRL2      0xc800607c
#define P_MMC_QOS5_CTRL3      0xc8006080
#define P_MMC_QOS5_CTRL4      0xc8006084
#define P_MMC_QOS6_CTRL0      0xc8006088
#define P_MMC_QOS6_CTRL1      0xc800608c
#define P_MMC_QOS6_CTRL2      0xc8006090
#define P_MMC_QOS6_CTRL3      0xc8006094
#define P_MMC_QOS6_CTRL4      0xc8006098
#define P_MMC_QOS7_CTRL0      0xc800609c
#define P_MMC_QOS7_CTRL1      0xc80060a0
#define P_MMC_QOS7_CTRL2      0xc80060a4
#define P_MMC_QOS7_CTRL3      0xc80060a8
#define P_MMC_QOS7_CTRL4      0xc80060ac
#define P_MMC_QOS8_CTRL0      0xc80060b0
#define P_MMC_QOS8_CTRL1      0xc80060b4
#define P_MMC_QOS8_CTRL2      0xc80060b8
#define P_MMC_QOS8_CTRL3      0xc80060bc
#define P_MMC_QOS8_CTRL4      0xc80060e0
#define P_MMC_VDMODE_CTRL     0xc80060e4
//31:12.  vsync and hsync selection for each channel.
//31:30.  not used in m6tv.
//29:28.  channel 8 vd reference selection.  2'b00 : Use viu display 1 vysnc and hsync as qos timing reference.
                                // 2'b01 : Use viu vdin 0 vsync and hsync as qos timing reference.
                                // 2'b10 : Use viu vdin 1 vsync and hsync as qos timing reference. 
//27:26.  channel 7 vd reference selection. 
//25:24.  channel 6 vd reference selection. 
//23:22.  channel 5 vd reference selection. 
//21:20.  channel 4 vd reference selection. 
//19:18.  channel 3 vd reference selection. 
//17:16.  channel 2 vd reference selection. 
//15:14.  channel 1 vd reference selection. 
//13:12.  channel 0 vd reference selection. 
//11:0    viu hold line. setting.   suppose there's no traffic from line counter number 0 to this hold line number. 
 
#define P_MMC_VDMODE_CTRL1    0xc80060e8
//27:16.   video display line end number.   
//11:0.    video display line start number.

#define P_DC_CAV_LUT_DATAL    0xc80060c0
  //low 32 bits of canvas data which need to be configured to canvas memory. 
#define P_DC_CAV_LUT_DATAH    0xc80060c4
  //high 32bits of cavnas data which need to be configured to canvas memory.
#define P_DC_CAV_LUT_ADDR     0xc80060c8
  //bit 9:8.   write 9:8 2'b10. the canvas data will saved in canvas memory with addres 7:0.
  //bit 7:0.   canvas address.

#define P_MMC_CHAN0_CTRL            0xc8006100
   //bit 18.  arm_irq_low    1 : irq is low active. 0 : irq is high active if use irq as qos control. 
   //bit 17.  arm_fiq_low    1 : fiq is low active. 0 : fiq is high active if use fiq as qos control.
   //bit 15:12.  arbiter weight used in bank arbiter and canvas arbiter. 
   //bit 11.   read/write reorder control.  1 : no read/write reordering if the read/write is same ID. 
               //this bit is not used for AXI channels, for example channel 0 and channel1.  
   //bit 10.   reorder control.  1 : no reorder for this channel.  this bit is not used for AXI channels. 
   //bit 9:0.  chan0_age_limit.  if the command buffer is pending there over this age limits. it will turned to super urgent request. So it woundn't stay there forever.

#define P_MMC_CHAN1_CTRL            0xc8006104
#define P_MMC_CHAN2_CTRL            0xc8006108
#define P_MMC_CHAN3_CTRL            0xc800610c
#define P_MMC_CHAN4_CTRL            0xc8006110
#define P_MMC_CHAN5_CTRL            0xc8006114
#define P_MMC_CHAN6_CTRL            0xc8006118
#define P_MMC_CHAN7_CTRL            0xc800611c
#define P_MMC_CHAN8_CTRL            0xc8006120
#define P_MMC_CHAN9_CTRL            0xc8006124
   //not used in m6tv.
#define P_MMC_DDR_TIMING0           0xc8006128
  // DDR timing register is used for ddr command filter to generate better performace. 
  // In M6TV we only support HDR mode, that means this timing counnter is half of the real DDR clock cycles.
  // bit 31:28.  tCWL.
  // bit 27:24.  tRP.
  // bit 23:20.  tRTP.
  // bit 19:16.  tRTW.
  // bit 15:12.  tCCD.
  // bit 11:8.   tRCD.
  // bit 7:4.    tCL.
  // bit 3:0.    Burst length.   
#define P_MMC_DDR_TIMING1           0xc800612c
  //bit 23:20.  tBRW.   
  //bit 19:16.  tWAKE. wake time for uPCTL.  
  //bit 15:8.   tRFC.  refresh to other command time.
  //bit 7:4.    tWTR.
  //bit 3:0.    tWR.
#define P_MMC_MON_CH0_REQ_CNT       0xc8006130
  //Channel 0 BAND WIDTH monitor request counter.
#define P_MMC_MON_CH0_ACK_CNT       0xc8006134
  //Channel 0 BAND WIDTH monitor  bankwidth counter(64bits per cycles). 
#define P_MMC_MON_CH1_REQ_CNT       0xc8006138
#define P_MMC_MON_CH1_ACK_CNT       0xc800613c
#define P_MMC_MON_CH2_REQ_CNT       0xc8006140
#define P_MMC_MON_CH2_ACK_CNT       0xc8006144
#define P_MMC_MON_CH3_REQ_CNT       0xc8006148
#define P_MMC_MON_CH3_ACK_CNT       0xc800614c
#define P_MMC_MON_CH4_REQ_CNT       0xc8006150
#define P_MMC_MON_CH4_ACK_CNT       0xc8006154
#define P_MMC_MON_CH5_REQ_CNT       0xc8006158
#define P_MMC_MON_CH5_ACK_CNT       0xc800615c
#define P_MMC_MON_CH6_REQ_CNT       0xc8006160
#define P_MMC_MON_CH6_ACK_CNT       0xc8006164
#define P_MMC_MON_CH7_REQ_CNT       0xc8006168
#define P_MMC_MON_CH7_ACK_CNT       0xc800616c
#define P_MMC_MON_CH8_REQ_CNT       0xc8006170
#define P_MMC_MON_CH8_ACK_CNT       0xc8006174
#define P_MMC_MON_CH9_REQ_CNT       0xc8006178
#define P_MMC_MON_CH9_ACK_CNT       0xc800617c
#define P_MMC_MON_CTRL0             0xc8006180
   //bit 31.  channel 3 monitor enable.
   //bit 30.  channel 3 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 29.  channel 3 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 28.  channel 3 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 27:24. if not all ID selected by bit 30.  you can select one port of the channel 3 to monitor. 
   //bit 23.  channel 2 monitor enable.
   //bit 22.  channel 2 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 21.  channel 2 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 20.  channel 2 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 19:16. if not all ID selected by bit 22.  you can select one port of the channel 2 to monitor. 
   //bit 15.  channel 1 monitor enable.
   //bit 14.  channel 1 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 13.  channel 1 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 12.  channel 1 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 11:8. if not all ID selected by bit 22.  you can select one port of the channel 1 to monitor. 
   //bit 7.  channel 0 monitor enable.
   //   channel 0 is ARM AXI port. no ID selection supports.
#define P_MMC_MON_CTRL1             0xc8006184
   //bit 31.  channel 7 monitor enable.
   //bit 30.  channel 7 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 29.  channel 7 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 28.  channel 7 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 27:24. if not all ID selected by bit 30.  you can select one port of the channel 7 to monitor. 
   //bit 23.  channel 6 monitor enable.
   //bit 22.  channel 6 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 21.  channel 6 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 20.  channel 6 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 19:16. if not all ID selected by bit 22.  you can select one port of the channel 6 to monitor. 
   //bit 15.  channel 5 monitor enable.
   //bit 14.  channel 5 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 13.  channel 5 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 12.  channel 5 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 11:8. if not all ID selected by bit 22.  you can select one port of the channel 5 to monitor. 
   //bit 7.  channel 4 monitor enable.
   //bit 6.  channel 4 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 5.  channel 4 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 4.  channel 4 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 3:0. if not all ID selected by bit 22.  you can select one port of the channel 4 to monitor. 
#define P_MMC_MON_CTRL2             0xc8006188
   //bit 31. qos monitor enable.
   //bit 30. qos monitor clean.
   //bit 16. Monitor trigger select.  0 : use moniter clock timer as timer to montior the bankwidth. 
        // 1 : use video display vsync as the timer to monitor the bandwidth.
   //bit 7.  channel 8 monitor enable.
   //bit 6.  channel 8 montior all transcation selection.  1 = select all ports access in this channel. 0 : check bit 27:24. 
   //bit 5.  channel 8 montior read selection. 1 = monitor read access. 0: not monitor read access. 
   //bit 4.  channel 8 montior write selection. 1 = monitor write access. 0 : not monitor write access.
   //bit 3:0. if not all ID selected by bit 22.  you can select one port of the channel 8 to monitor. 
#define P_MMC_MON_CTRL3             0xc800618c
  // qos_mon_clk_timer.   How long to measure the bandwidth.
#define P_MMC_MON_ALL_REQ_CNT       0xc8006190
  // at the test period,  the whole MMC request time.
#define P_MMC_MON_ALL_GRANT_CNT     0xc8006194
  // at the test period,  the whole MMC granted data cycles. 64bits unit. 

#ifndef P_MMC_REQ_CTRL
#define P_MMC_REQ_CTRL        0xc8006400 
#endif
//bit 8:0.      enable bit for the 9 channel request.   1 = enable.
//bit 8.   HCODEC.
//bit 7.   AUDIO.
//bit 6.   DEVICE.
//bit 5.   VDIN
//bit 4.   VPUARB2
//bit 3.   VDISP.
//bit 2.   VDEC.
//bit 1.   MALI.
//bit 0.   A9 CPU.

#ifndef P_MMC_SOFT_RST
#define P_MMC_SOFT_RST        0xc8006404
#endif
  // level reset.  0 = reset.  1 = deassert reset.
  // bit 30.  lower power control module reset bit.
  // bit 29.  PHY IP reset bit.
  // bit 28.  uPCTL APB bus interface reset bit.
  // bit 27.  uPCTL IP reset bit.
  // bit 26.  PUBL  APB bus interface reset bit.
  // bit 25.  PUBL IP reset bit.
  // bit 24.  QOS control reset bit. 
  // bit 23.  DMC register reset bit.
  // bit 22.  DMC canvas reset bit.
  // bit 21.  DMC command filter reset bit.
  // bit 19.  chan9 async fifo n_clk domain reset bit.
  // bit 18.  chan8 async fifo n_clk domain reset bit.
  // bit 17.  chan7 async fifo n_clk domain reset bit.
  // bit 16.  chan6 async fifo n_clk domain reset bit.
  // bit 15.  chan5 async fifo n_clk domain reset bit.
  // bit 14.  chan4 async fifo n_clk domain reset bit.
  // bit 13.  chan3 async fifo n_clk domain reset bit.
  // bit 12.  chan2 async fifo n_clk domain reset bit.
  // bit 11.  chan1 async fifo n_clk domain reset bit.
  // bit 10.  chan0 async fifo n_clk domain reset bit.
  // bit 9.   chan9 command buffer reset bit.
  // bit 8.   chan8 command buffer reset bit.
  // bit 7.   chan7 command buffer reset bit.
  // bit 6.   chan6 command buffer reset bit.
  // bit 5.   chan5 command buffer reset bit.
  // bit 4.   chan4 command buffer reset bit.
  // bit 3.   chan3 command buffer reset bit.
  // bit 2.   chan2 command buffer reset bit.
  // bit 1.   chan1 command buffer reset bit.
  // bit 0.   chan0 command buffer reset bit.
#define P_MMC_SOFT_RST1       0xc8006408
  //level reset. 0 = reset. 1 = dessert reset.
  // bit 9.  chan9 async fifo master clock domain reset bit.
  // bit 8.  chan8 async fifo master clock domain reset bit.
  // bit 7.  chan7 async fifo master clock domain reset bit.
  // bit 6.  chan6 async fifo master clock domain reset bit.
  // bit 5.  chan5 async fifo master clock domain reset bit.
  // bit 4.  chan4 async fifo master clock domain reset bit.
  // bit 3.  chan3 async fifo master clock domain reset bit.
  // bit 2.  chan2 async fifo master clock domain reset bit.
  // bit 1.  chan1 async fifo master clock domain reset bit.
  // bit 0.  chan0 async fifo master clock domain reset bit.
#ifndef P_MMC_RST_STS
#define P_MMC_RST_STS         0xc800640c
#endif
  //MMC_SOFT_RST reset bits return.  For example, if you write one bit to 0, you can check the related return bit became to 0.  that means the 0 is propagated to that module correctly. 
#define P_MMC_RST_STS1        0xc8006410
  //MMC_SOFT_RST1  reset bits returns.
#ifndef P_MMC_CLK_CNTL
#define P_MMC_CLK_CNTL        0xc800641c
#endif
  //bit 9:8.  PUBL, uPCTL and DMC APB clock control. 
          //2'b00:  disable APB  
          //2'b01:  ddr pll clock /2. 
          //2'b10:  ddr pll clock /4. 
          //2'b11:  ddr pll clock /8. 
  //bit 7.  pll_clk_sel. 1 = cts_ddr_slow_clock or divider clock.  0 : DDR PLL direct output. by default.  
  //bit 6.  pll_clk_en.  enable the DDR PLL output clock.
  //bit 5.  divider slow clock select.  1 = use cts_ddr_slow_clk. 0 = use divider clock. 
  //bit 4.  slow_clk_en.  1 = enable the slow clock.
  //bit 3.  clock divider counter enable.
  //bit 2.  enable output of the clock divider clock.
  //bit 1:0.  clock divider selection.2'b00 = /2. 2'b01 = /4. 2'b10 = /8. 2'b11 = /16.


   
#define P_MMC_LP_CTRL1       0xc8006440
  //bit 30   auto self refresh enable bit
  //bit 29.  hw_wakeup_en.  use c_active_in to wake up upctl early in pctl auto gate mode.
  //bit 28.  PCTL auto gate mode enable bit. 
  //bit 27.  send auto refresh signal after refresh ready from DMC command filter module.
  //bit 26.  enable auto refresh holds the nif command function.
             //wehn do auto refresh,  keep the nif command buffer clean. so if auto refresh finished, the urgent request can come directroy to nif command buffer.
  //bit 24. force dmc clock enable.
  //bit 23. force dmc clock disable.
  //bit 22. force uPCTL clock enable. 
  //bit 21. force uPCTL clock disable.
  //bit 20. force PUBL clock enable.
  //bit 19. force PUBL clock disable.
  //bit 18. force PHY clock disable.
  //bit 17:8.  idle clock cycles to enter self refresh mode.
  //bit 7:0.  tRFC cycles in n_clk  domain. keep the dmc buffer clean in that period. 
#define P_MMC_LP_CTRL2       0xc8006444
  //MMC low power status register.
  //bit 16.   UPCTL c_sysack bit output bits.
  //bit 15.   am_refr_sel.   refresh controller selection. 1 : from mmc low power contrl. 0: UPCTL.
  //bit 14:11. lower power state. 0: not in low power state. 0xa : in low power state.
  //bit 10.    all DMC channels are in idle state.
  //bit 9:0.   idle state for each channel.  

#define P_MMC_LP_CTRL3       0xc8006448
   //bit 31:24.  100ns timer ticker. cycles in n_clk. 
   //bit 23:16.  apb hold time.  if there's any apb operation. keep the clock period.
   //bit 15:8.   self refresh wait time.
   //bit 7:0.    Power down waiting. after checked the uPCTL enter power mode. waiting this clock cycles to let this power mode propogated to PUBL.

#define P_MMC_LP_CTRL4       0xc800644c
   //bit 31.   enable auto pvt  update founction.
   //bit 30.   enable auto ZQ calbration function.
   //bit 29.   1: force c_sysreq_in use register value. 0 : auto generated by MMC low power control logic.
   //bit 28.   value used to control c_sysreq in force mode.
   //bit 23:16. pvt timer.
   //bit 15:8.  zq timer.
   //bit 7:0.   trefi timer.
#define P_MMC_CLKG_CNTL0     0xc8006450
  //auto gated clock enable regsiter.
  //bit 17.  async inteface master clock auto gated clock enable.  1: enable auto clock gating function. 0: disable auto clock gating function.
  //bit 16.  PCTL APB clock auto clock gating enable.
  //bit 15.  PUB APB clock auto clock gating enable.
  //bit 14.  DMC APB clock auto clock gating enable.
  //bit 13.  QOS monitor clock auto clock gating enable.
  //bit 12.  QOS clock auto clock gating enable. 
  //bit 11.  CMD filter clock auto clock gating enable. 
  //bit 10.  canvas clock auto clock gating enable. 
  //bit 9.   channel 9 clock auto clock gating enable. not used in m6tv. 
  //bit 8.   channel 8 clock auto clock gating enable.
  //bit 7.   channel 7 clock auto clock gating enable.
  //bit 6.   channel 6 clock auto clock gating enable.
  //bit 5.   channel 5 clock auto clock gating enable.
  //bit 4.   channel 4 clock auto clock gating enable.
  //bit 3.   channel 3 clock auto clock gating enable.
  //bit 2.   channel 2 clock auto clock gating enable.
  //bit 1.   channel 1 clock auto clock gating enable.
  //bit 0.   channel 0 clock auto clock gating enable.
#define P_MMC_CLKG_CNTL1     0xc8006454
  //force disable clock tree. used for power consumption test.
  //bit 17.   force disable Async interface master clock. 
  //bit 16.  force disable  PCTL APB clock. 
  //bit 15.  force disable PUB APB clock. 
  //bit 14.  force disable DMC APB clock. 
  //bit 13. force disable QOS monitor clock. 
  //bit 12. force disable QOS clock. 
  //bit 11. force disable cmd filter clock. 
  //bit 10. force disable canvas clock. 
  //bit 9.  force disable  channel 9 clock. 
  //bit 8.  force disable  channel 8 clock. 
  //bit 7.  force disable  channel 7 clock. 
  //bit 6.  force disable  channel 6 clock. 
  //bit 5.  force disable  channel 5 clock. 
  //bit 4.  force disable  channel 4 clock. 
  //bit 3.  force disable  channel 3 clock. 
  //bit 2.  force disable  channel 2 clock. 
  //bit 1.  force disable  channel 1 clock. 
  //bit 0.  force disable  channel 0 clock. 
#ifndef MMC_CMDZQ_CTRL
#define MMC_CMDZQ_CTRL       0xc8006458 
#endif
  //bit 20.   force command lane ZQ CTRL use register bit 19:0 value
  //bit 19:0. the value used for command lane ZQ CTRL. 

#define P_DMC_SEC_RANGE0_ST   		0xda002000
//bit 15 :0.   secuicty range0 start address
#define P_DMC_SEC_RANGE0_END  		0xda002004
//bit 15 :0.   secuicty range0 end address
#define P_DMC_SEC_RANGE1_ST   		0xda002008
#define P_DMC_SEC_RANGE1_END  		0xda00200c
#define P_DMC_SEC_RANGE2_ST   		0xda002010
#define P_DMC_SEC_RANGE2_END  		0xda002014
#define P_DMC_SEC_RANGE3_ST   		0xda002018
#define P_DMC_SEC_RANGE3_END  		0xda00201c
#define P_DMC_SEC_PORT0_RANGE0		0xda002020
//bit 0.  channel 0 range 0  enable.
#define P_DMC_SEC_PORT1_RANGE0		0xda002024
//bit 1.  channel 1 range 0 enable.
#define P_DMC_SEC_PORT2_RANGE0		0xda002028
//bit 15:0.   channel 2 range 0 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT3_RANGE0		0xda00202c
//bit 15:0.   channel 3 range 0 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT4_RANGE0		0xda002030
//bit 15:0.   channel 4 range 0 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT5_RANGE0		0xda002034
//bit 15:0.   channel 5 range 0 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT6_RANGE0		0xda002038
//bit 15:0.   channel 6 range 0 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT7_RANGE0		0xda00203c
//bit 15:0.   channel 7 range 0 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT0_RANGE1		0xda002040
//bit 0.  channel 0 range 1  enable.
#define P_DMC_SEC_PORT1_RANGE1		0xda002044
//bit 0.  channel 1 range 1  enable.
#define P_DMC_SEC_PORT2_RANGE1		0xda002048
//bit 15:0.   channel 2 range 1 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT3_RANGE1		0xda00204c
//bit 15:0.   channel 3 range 1 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT4_RANGE1		0xda002050
//bit 15:0.   channel 4 range 1 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT5_RANGE1		0xda002054
//bit 15:0.   channel 5 range 1 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT6_RANGE1		0xda002058
//bit 15:0.   channel 6 range 1 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT7_RANGE1		0xda00205c
//bit 15:0.   channel 7 range 1 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT0_RANGE2		0xda002060
//bit 0.  channel 0 range 2  enable.
#define P_DMC_SEC_PORT1_RANGE2		0xda002064
//bit 0.  channel 1 range 2  enable.
#define P_DMC_SEC_PORT2_RANGE2		0xda002068
//bit 15:0.   channel 2 range 2 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT3_RANGE2		0xda00206c
//bit 15:0.   channel 3 range 2 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT4_RANGE2		0xda002070
//bit 15:0.   channel 4 range 2 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT5_RANGE2		0xda002074
//bit 15:0.   channel 5 range 2 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT6_RANGE2		0xda002078
//bit 15:0.   channel 6 range 2 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT7_RANGE2		0xda00207c
//bit 15:0.   channel 7 range 2 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT0_RANGE3		0xda002080
//bit 0.  channel 0 range 3  enable.
#define P_DMC_SEC_PORT1_RANGE3		0xda002084
//bit 0.  channel 1 range 3  enable.
#define P_DMC_SEC_PORT2_RANGE3		0xda002088
//bit 15:0.   channel 2 range 3 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT3_RANGE3		0xda00208c
//bit 15:0.   channel 3 range 3 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT4_RANGE3		0xda002090
//bit 15:0.   channel 4 range 3 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT5_RANGE3		0xda002094
//bit 15:0.   channel 5 range 3 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT6_RANGE3		0xda002098
//bit 15:0.   channel 6 range 3 enable.  one bit for each port ID  
#define P_DMC_SEC_PORT7_RANGE3		0xda00209c
//bit 15:0.   channel 7 range 3 enable.  one bit for each port ID  
#define P_DMC_SEC_BAD_ACCESS  		0xda0020a0

#define P_DMC_SEC_CTRL     	        0xda0020a4

#define P_DMC_SEC_CHAN0_VIO0            0xda0020a8 
#define P_DMC_SEC_CHAN0_VIO1            0xda0020ac
#define P_DMC_SEC_CHAN1_VIO0            0xda0020b0
#define P_DMC_SEC_CHAN1_VIO1            0xda0020b4
#define P_DMC_SEC_CHAN2_VIO0            0xda0020b8
#define P_DMC_SEC_CHAN2_VIO1            0xda0020bc
#define P_DMC_SEC_CHAN3_VIO0            0xda0020c0
#define P_DMC_SEC_CHAN3_VIO1            0xda0020c4
#define P_DMC_SEC_CHAN4_VIO0            0xda0020c8
#define P_DMC_SEC_CHAN4_VIO1            0xda0020cc
#define P_DMC_SEC_CHAN5_VIO0            0xda0020d0
#define P_DMC_SEC_CHAN5_VIO1            0xda0020d4
#define P_DMC_SEC_CHAN6_VIO0            0xda0020d8
#define P_DMC_SEC_CHAN6_VIO1            0xda0020dc
#define P_DMC_SEC_CHAN7_VIO0            0xda0020e0
#define P_DMC_SEC_CHAN7_VIO1            0xda0020e4
#define P_DMC_SEC_CHAN8_VIO0            0xda0020e8
#define P_DMC_SEC_CHAN8_VIO1            0xda0020ec
#define P_DMC_SEC_CHAN9_VIO0            0xda0020f0 
#define P_DMC_SEC_CHAN9_VIO1            0xda0020f4

#define P_DMC_SEC_PORT8_RANGE0          0xda002100
#define P_DMC_SEC_PORT9_RANGE0          0xda002104
#define P_DMC_SEC_PORT8_RANGE1          0xda002108
#define P_DMC_SEC_PORT9_RANGE1          0xda00210c
#define P_DMC_SEC_PORT8_RANGE2          0xda002110
#define P_DMC_SEC_PORT9_RANGE2          0xda002114
#define P_DMC_SEC_PORT8_RANGE3          0xda002118
#define P_DMC_SEC_PORT9_RANGE3          0xda00211c
#endif


