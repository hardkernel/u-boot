#ifndef M6_MMC
#define M6_MMC

#define MMC_Wr(addr, data) *(volatile unsigned long *) addr = data
#define MMC_Rd(addr) *(volatile unsigned long *)  addr 

#define  P_UPCTL_STAT_ADDR 		0xc8000008
	#define  UPCTL_STAT_INIT          0 
	#define  UPCTL_STAT_CONFIG        1 
	#define  UPCTL_STAT_ACCESS        3
	#define  UPCTL_STAT_LOW_POWER     5 

	#define  SCTL_CMD_INIT          0 
	#define  SCTL_CMD_CONFIG        1	
	#define  SCTL_CMD_GO            2 
	#define  SCTL_CMD_SLEEP         3 
	#define  SCTL_CMD_WAKEUP        4 

#define  P_UPCTL_INTRSTAT_ADDR 		0xc800000c
#define  P_UPCTL_SCTL_ADDR 		0xc8000004
#define  P_UPCTL_SCFG_ADDR 		0xc8000000
#define  P_UPCTL_POWSTAT_ADDR 		0xc8000048
#define  P_UPCTL_MRRSTAT0_ADDR 		0xc8000064
#define  P_UPCTL_CMDTSTAT_ADDR 		0xc800004c
#define  P_UPCTL_MCMD_ADDR 		0xc8000040
#define  P_UPCTL_MRRSTAT1_ADDR 		0xc8000068
#define  P_UPCTL_MRRCFG0_ADDR 		0xc8000060
#define  P_UPCTL_CMDTSTATEN_ADDR 		0xc8000050
#define  P_UPCTL_POWCTL_ADDR 		0xc8000044
#define  P_UPCTL_LPDDR2ZQCFG_ADDR 	0xc800008c
#define  P_UPCTL_PPCFG_ADDR 		0xc8000084
#define  P_UPCTL_MCFG1_ADDR 		0xc800007c
#define  P_UPCTL_MSTAT_ADDR 		0xc8000088
#define  P_UPCTL_MCFG_ADDR 		0xc8000080
#define  P_UPCTL_DTUAWDT_ADDR 		0xc80000b0
#define  P_UPCTL_DTUPRD2_ADDR 		0xc80000a8
#define  P_UPCTL_DTUPRD3_ADDR 		0xc80000ac
#define  P_UPCTL_DTUNE_ADDR 		0xc800009c
#define  P_UPCTL_DTUPDES_ADDR 		0xc8000094
#define  P_UPCTL_DTUNA_ADDR 		0xc8000098
#define  P_UPCTL_DTUPRD0_ADDR 		0xc80000a0
#define  P_UPCTL_DTUPRD1_ADDR 		0xc80000a4
#define  P_UPCTL_TCKSRE_ADDR 		0xc8000124
#define  P_UPCTL_TZQCSI_ADDR 		0xc800011c
#define  P_UPCTL_TINIT_ADDR 		0xc80000c4
#define  P_UPCTL_TDPD_ADDR 		0xc8000144
#define  P_UPCTL_TOGCNT1U_ADDR 		0xc80000c0
#define  P_UPCTL_TCKE_ADDR 		0xc800012c
#define  P_UPCTL_TMOD_ADDR 		0xc8000130
#define  P_UPCTL_TEXSR_ADDR 		0xc800010c
#define  P_UPCTL_TAL_ADDR 		0xc80000e4
#define  P_UPCTL_TRTP_ADDR 		0xc8000100
#define  P_UPCTL_TCKSRX_ADDR 		0xc8000128
#define  P_UPCTL_TRTW_ADDR 		0xc80000e0
#define  P_UPCTL_TCWL_ADDR 		0xc80000ec
#define  P_UPCTL_TWR_ADDR 		0xc8000104
#define  P_UPCTL_TCL_ADDR 		0xc80000e8
#define  P_UPCTL_TDQS_ADDR 		0xc8000120
#define  P_UPCTL_TRSTH_ADDR 		0xc80000c8
#define  P_UPCTL_TRCD_ADDR 		0xc80000f8
#define  P_UPCTL_TXP_ADDR 		0xc8000110
#define  P_UPCTL_TOGCNT100N_ADDR 		0xc80000cc
#define  P_UPCTL_TMRD_ADDR 		0xc80000d4
#define  P_UPCTL_TRSTL_ADDR 		0xc8000134
#define  P_UPCTL_TREFI_ADDR 		0xc80000d0
#define  P_UPCTL_TRAS_ADDR 		0xc80000f0
#define  P_UPCTL_TWTR_ADDR 		0xc8000108
#define  P_UPCTL_TRC_ADDR 		0xc80000f4
#define  P_UPCTL_TRFC_ADDR 		0xc80000d8
#define  P_UPCTL_TMRR_ADDR 		0xc800013c
#define  P_UPCTL_TCKESR_ADDR 		0xc8000140
#define  P_UPCTL_TZQCL_ADDR 		0xc8000138
#define  P_UPCTL_TRRD_ADDR 		0xc80000fc
#define  P_UPCTL_TRP_ADDR 		0xc80000dc
#define  P_UPCTL_TZQCS_ADDR 		0xc8000118
#define  P_UPCTL_TXPDLL_ADDR 		0xc8000114
#define  P_UPCTL_ECCCFG_ADDR 		0xc8000180
#define  P_UPCTL_ECCLOG_ADDR 		0xc800018c
#define  P_UPCTL_ECCCLR_ADDR 		0xc8000188
#define  P_UPCTL_ECCTST_ADDR 		0xc8000184
#define  P_UPCTL_DTUWD0_ADDR 		0xc8000210
#define  P_UPCTL_DTUWD1_ADDR 		0xc8000214
#define  P_UPCTL_DTUWACTL_ADDR 		0xc8000200
#define  P_UPCTL_DTULFSRRD_ADDR 		0xc8000238
#define  P_UPCTL_DTUWD2_ADDR 		0xc8000218
#define  P_UPCTL_DTUWD3_ADDR 		0xc800021c
#define  P_UPCTL_DTULFSRWD_ADDR 		0xc8000234
#define  P_UPCTL_DTURACTL_ADDR 		0xc8000204
#define  P_UPCTL_DTUWDM_ADDR 		0xc8000220
#define  P_UPCTL_DTURD0_ADDR 		0xc8000224
#define  P_UPCTL_DTURD1_ADDR 		0xc8000228
#define  P_UPCTL_DTURD2_ADDR 		0xc800022c
#define  P_UPCTL_DTURD3_ADDR 		0xc8000230
#define  P_UPCTL_DTUCFG_ADDR 		0xc8000208
#define  P_UPCTL_DTUEAF_ADDR 		0xc800023c
#define  P_UPCTL_DTUECTL_ADDR 		0xc800020c
#define  P_UPCTL_DFIODTCFG1_ADDR 		0xc8000248
#define  P_UPCTL_DFITCTRLDELAY_ADDR 	0xc8000240
#define  P_UPCTL_DFIODTRANKMAP_ADDR 	0xc800024c
#define  P_UPCTL_DFIODTCFG_ADDR 		0xc8000244
#define  P_UPCTL_DFITPHYWRLAT_ADDR 	0xc8000254
#define  P_UPCTL_DFITPHYWRDATA_ADDR 	0xc8000250
#define  P_UPCTL_DFITRDDATAEN_ADDR 	0xc8000260
#define  P_UPCTL_DFITPHYRDLAT_ADDR 	0xc8000264
#define  P_UPCTL_DFITREFMSKI_ADDR 	0xc8000294
#define  P_UPCTL_DFITPHYUPDTYPE0_ADDR 	0xc8000270
#define  P_UPCTL_DFITPHYUPDTYPE1_ADDR 	0xc8000274
#define  P_UPCTL_DFITCTRLUPDDLY_ADDR 	0xc8000288
#define  P_UPCTL_DFITPHYUPDTYPE2_ADDR 	0xc8000278
#define  P_UPCTL_DFITCTRLUPDMIN_ADDR 	0xc8000280
#define  P_UPCTL_DFITPHYUPDTYPE3_ADDR 	0xc800027c
#define  P_UPCTL_DFIUPDCFG_ADDR 		0xc8000290
#define  P_UPCTL_DFITCTRLUPDMAX_ADDR 	0xc8000284
#define  P_UPCTL_DFITCTRLUPDI_ADDR 	0xc8000298
#define  P_UPCTL_DFITRRDLVLEN_ADDR 	0xc80002b8
#define  P_UPCTL_DFITRSTAT0_ADDR 		0xc80002b0
#define  P_UPCTL_DFITRWRLVLEN_ADDR 	0xc80002b4
#define  P_UPCTL_DFITRCFG0_ADDR 		0xc80002ac
#define  P_UPCTL_DFITRRDLVLGATEEN_ADDR 	0xc80002bc
#define  P_UPCTL_DFISTSTAT0_ADDR 		0xc80002c0
#define  P_UPCTL_DFISTPARLOG_ADDR 	0xc80002e0
#define  P_UPCTL_DFITDRAMCLKEN_ADDR 	0xc80002d0
#define  P_UPCTL_DFISTPARCLR_ADDR 	0xc80002dc
#define  P_UPCTL_DFISTCFG0_ADDR 		0xc80002c4
#define  P_UPCTL_DFISTCFG1_ADDR 		0xc80002c8
#define  P_UPCTL_DFISTCFG2_ADDR 		0xc80002d8
#define  P_UPCTL_DFITDRAMCLKDIS_ADDR 	0xc80002d4
#define  P_UPCTL_DFILPCFG0_ADDR 		0xc80002f0
#define  P_UPCTL_DFITRWRLVLDELAY0_ADDR 	0xc8000318
#define  P_UPCTL_DFITRWRLVLDELAY1_ADDR 	0xc800031c
#define  P_UPCTL_DFITRWRLVLDELAY2_ADDR 	0xc8000320
#define  P_UPCTL_DFITRRDLVLRESP0_ADDR 	0xc800030c
#define  P_UPCTL_DFITRRDLVLRESP1_ADDR 	0xc8000310
#define  P_UPCTL_DFITRRDLVLRESP2_ADDR 	0xc8000314
#define  P_UPCTL_DFITRWRLVLRESP0_ADDR 	0xc8000300
#define  P_UPCTL_DFITRRDLVLDELAY0_ADDR 	0xc8000324
#define  P_UPCTL_DFITRRDLVLDELAY1_ADDR 	0xc8000328
#define  P_UPCTL_DFITRWRLVLRESP1_ADDR 	0xc8000304
#define  P_UPCTL_DFITRRDLVLDELAY2_ADDR 	0xc800032c
#define  P_UPCTL_DFITRWRLVLRESP2_ADDR 	0xc8000308
#define  P_UPCTL_DFITRRDLVLGATEDELAY0_ADDR 	0xc8000330
#define  P_UPCTL_DFITRCMD_ADDR 			0xc800033c
#define  P_UPCTL_DFITRRDLVLGATEDELAY1_ADDR 	0xc8000334
#define  P_UPCTL_DFITRRDLVLGATEDELAY2_ADDR 	0xc8000338
#define  P_UPCTL_IPTR_ADDR 		0xc80003fc
#define  P_UPCTL_IPVR_ADDR 		0xc80003f8

#define  P_PUB_RIDR_ADDR  		0xc8001000
#define  P_PUB_PIR_ADDR  			0xc8001004 
#define  P_PUB_PGCR_ADDR  		0xc8001008
#define  P_PUB_PGSR_ADDR  		0xc800100c
#define  P_PUB_DLLGCR_ADDR  		0xc8001010
#define  P_PUB_ACDLLCR_ADDR  		0xc8001014
#define  P_PUB_PTR0_ADDR  		0xc8001018
#define  P_PUB_PTR1_ADDR  		0xc800101c
#define  P_PUB_PTR2_ADDR  		0xc8001020
#define  P_PUB_ACIOCR_ADDR  		0xc8001024
#define  P_PUB_DXCCR_ADDR  		0xc8001028
#define  P_PUB_DSGCR_ADDR  		0xc800102c
#define  P_PUB_DCR_ADDR  			0xc8001030
#define  P_PUB_DTPR0_ADDR  		0xc8001034
#define  P_PUB_DTPR1_ADDR  		0xc8001038
#define  P_PUB_DTPR2_ADDR  		0xc800103c
#define  P_PUB_MR0_ADDR  		0xc8001040
#define  P_PUB_MR1_ADDR  		0xc8001044
#define  P_PUB_MR2_ADDR  		0xc8001048
#define  P_PUB_MR3_ADDR  		0xc800104c
#define  P_PUB_ODTCR_ADDR  		0xc8001050
#define  P_PUB_DTAR_ADDR  		0xc8001054
#define  P_PUB_DTDR0_ADDR  		0xc8001058
#define  P_PUB_DTDR1_ADDR  		0xc800105c
#define  P_PUB_DCUAR_ADDR  		0xc80010c0
#define  P_PUB_DCUDR_ADDR  		0xc80010c4
#define  P_PUB_DCURR_ADDR  		0xc80010c8
#define  P_PUB_DCULR_ADDR  		0xc80010cc
#define  P_PUB_DCUGCR_ADDR  		0xc80010d0
#define  P_PUB_DCUTPR_ADDR  		0xc80010d4
#define  P_PUB_DCUSR0_ADDR  		0xc80010d8
#define  P_PUB_DCUSR1_ADDR  		0xc80010dc
#define  P_PUB_BISTRR_ADDR  		0xc8001100
#define  P_PUB_BISTMSKR0_ADDR  	0xc8001104
#define  P_PUB_BISTMSKR1_ADDR  	0xc8001108
#define  P_PUB_BISTWCR_ADDR  	0xc800110c
#define  P_PUB_BISTLSR_ADDR  	0xc8001110
#define  P_PUB_BISTAR0_ADDR  	0xc8001114
#define  P_PUB_BISTAR1_ADDR  	0xc8001118
#define  P_PUB_BISTAR2_ADDR  	0xc800111c
#define  P_PUB_BISTUDPR_ADDR  	0xc8001120
#define  P_PUB_BISTGSR_ADDR  	0xc8001124
#define  P_PUB_BISTWER_ADDR  	0xc8001128
#define  P_PUB_BISTBER0_ADDR  	0xc800112c
#define  P_PUB_BISTBER1_ADDR  	0xc8001130
#define  P_PUB_BISTBER2_ADDR  	0xc8001134
#define  P_PUB_BISTWCSR_ADDR  	0xc8001138
#define  P_PUB_BISTFWR0_ADDR  	0xc800113c
#define  P_PUB_BISTFWR1_ADDR  	0xc8001140
#define  P_PUB_GPR0_ADDR  		0xc8001178
#define  P_PUB_GPR1_ADDR  		0xc800117c
#define  P_PUB_ZQ0CR0_ADDR		0xc8001180
#define  P_PUB_ZQ0CR1_ADDR		0xc8001184
#define  P_PUB_ZQ0SR0_ADDR		0xc8001188
#define  P_PUB_ZQ0SR1_ADDR		0xc800118c
#define  P_PUB_ZQ1CR0_ADDR		0xc8001190
#define  P_PUB_ZQ1CR1_ADDR		0xc8001194
#define  P_PUB_ZQ1SR0_ADDR		0xc8001198
#define  P_PUB_ZQ1SR1_ADDR		0xc800119c
#define  P_PUB_ZQ2CR0_ADDR		0xc80011a0
#define  P_PUB_ZQ2CR1_ADDR		0xc80011a4
#define  P_PUB_ZQ2SR0_ADDR		0xc80011a8
#define  P_PUB_ZQ2SR1_ADDR		0xc80011ac
#define  P_PUB_ZQ3CR0_ADDR		0xc80011b0
#define  P_PUB_ZQ3CR1_ADDR		0xc80011b4
#define  P_PUB_ZQ3SR0_ADDR		0xc80011b8
#define  P_PUB_ZQ3SR1_ADDR		0xc80011bc
#define  P_PUB_DX0GCR_ADDR		0xc80011c0
#define  P_PUB_DX0GSR0_ADDR		0xc80011c4
#define  P_PUB_DX0GSR1_ADDR		0xc80011c8
#define  P_PUB_DX0DLLCR_ADDR		0xc80011cc
#define  P_PUB_DX0DQTR_ADDR		0xc80011d0
#define  P_PUB_DX0DQSTR_ADDR		0xc80011d4
#define  P_PUB_DX1GCR_ADDR		0xc8001200
#define  P_PUB_DX1GSR0_ADDR		0xc8001204
#define  P_PUB_DX1GSR1_ADDR		0xc8001208
#define  P_PUB_DX1DLLCR_ADDR		0xc800120c
#define  P_PUB_DX1DQTR_ADDR		0xc8001210
#define  P_PUB_DX1DQSTR_ADDR		0xc8001214
#define  P_PUB_DX2GCR_ADDR		0xc8001240
#define  P_PUB_DX2GSR0_ADDR		0xc8001244
#define  P_PUB_DX2GSR1_ADDR		0xc8001248
#define  P_PUB_DX2DLLCR_ADDR		0xc800124c
#define  P_PUB_DX2DQTR_ADDR		0xc8001250
#define  P_PUB_DX2DQSTR_ADDR		0xc8001254
#define  P_PUB_DX3GCR_ADDR		0xc8001280
#define  P_PUB_DX3GSR0_ADDR		0xc8001284
#define  P_PUB_DX3GSR1_ADDR		0xc8001288
#define  P_PUB_DX3DLLCR_ADDR		0xc800128c
#define  P_PUB_DX3DQTR_ADDR		0xc8001290
#define  P_PUB_DX3DQSTR_ADDR		0xc8001294
#define  P_PUB_DX4GCR_ADDR		0xc80012c0
#define  P_PUB_DX4GSR0_ADDR		0xc80012c4
#define  P_PUB_DX4GSR1_ADDR		0xc80012c8
#define  P_PUB_DX4DLLCR_ADDR		0xc80012cc
#define  P_PUB_DX4DQTR_ADDR		0xc80012d0
#define  P_PUB_DX4DQSTR_ADDR		0xc80012d4
#define  P_PUB_DX5GCR_ADDR		0xc8001300
#define  P_PUB_DX5GSR0_ADDR		0xc8001304
#define  P_PUB_DX5GSR1_ADDR		0xc8001308
#define  P_PUB_DX5DLLCR_ADDR		0xc800130c
#define  P_PUB_DX5DQTR_ADDR		0xc8001310
#define  P_PUB_DX5DQSTR_ADDR		0xc8001314
#define  P_PUB_DX6GCR_ADDR		0xc8001340
#define  P_PUB_DX6GSR0_ADDR		0xc8001344
#define  P_PUB_DX6GSR1_ADDR		0xc8001348
#define  P_PUB_DX6DLLCR_ADDR		0xc800134c
#define  P_PUB_DX6DQTR_ADDR		0xc8001350
#define  P_PUB_DX6DQSTR_ADDR		0xc8001354
#define  P_PUB_DX7GCR_ADDR		0xc8001380
#define  P_PUB_DX7GSR0_ADDR		0xc8001384
#define  P_PUB_DX7GSR1_ADDR		0xc8001388
#define  P_PUB_DX7DLLCR_ADDR		0xc800138c
#define  P_PUB_DX7DQTR_ADDR		0xc8001390
#define  P_PUB_DX7DQSTR_ADDR		0xc8001394
#define  P_PUB_DX8GCR_ADDR		0xc80013c0
#define  P_PUB_DX8GSR0_ADDR		0xc80013c4
#define  P_PUB_DX8GSR1_ADDR		0xc80013c8
#define  P_PUB_DX8DLLCR_ADDR		0xc80013cc
#define  P_PUB_DX8DQTR_ADDR		0xc80013d0
#define  P_PUB_DX8DQSTR_ADDR		0xc80013d4


#define P_MMC_DDR_CTRL        0xc8006000
#define P_MMC_ARB_CTRL        0xc8006008 
#define P_MMC_ARB_CTRL1       0xc800600c 

#define P_MMC_QOS0_CTRL  0xc8006010
   //bit 31     qos enable.
   //bit 26     1 : danamic change the bandwidth percentage. 0 : fixed bandwidth.  all 64. 
   //bit 25       grant mode. 1 grant clock cycles. 0 grant data cycles.
   //bit 24       leakybucket counter goes to 0. When no req or no other request. 
   //bit 21:16    bankwidth requirement. unit 1/64. 
   //bit 15:0.    after stop the re_enable threadhold.

#define P_MMC_QOS0_MAX   0xc8006014
#define P_MMC_QOS0_MIN   0xc8006018
#define P_MMC_QOS0_LIMIT 0xc800601c
#define P_MMC_QOS0_STOP  0xc8006020
#define P_MMC_QOS1_CTRL  0xc8006024
#define P_MMC_QOS1_MAX   0xc8006028
#define P_MMC_QOS1_MIN   0xc800602c
#define P_MMC_QOS1_STOP  0xc8006030
#define P_MMC_QOS1_LIMIT 0xc8006034
#define P_MMC_QOS2_CTRL  0xc8006038
#define P_MMC_QOS2_MAX   0xc800603c
#define P_MMC_QOS2_MIN   0xc8006040
#define P_MMC_QOS2_STOP  0xc8006044
#define P_MMC_QOS2_LIMIT 0xc8006048
#define P_MMC_QOS3_CTRL  0xc800604c
#define P_MMC_QOS3_MAX   0xc8006050
#define P_MMC_QOS3_MIN   0xc8006054
#define P_MMC_QOS3_STOP  0xc8006058
#define P_MMC_QOS3_LIMIT 0xc800605c
#define P_MMC_QOS4_CTRL  0xc8006060
#define P_MMC_QOS4_MAX   0xc8006064
#define P_MMC_QOS4_MIN   0xc8006068
#define P_MMC_QOS4_STOP  0xc800606c
#define P_MMC_QOS4_LIMIT 0xc8006070
#define P_MMC_QOS5_CTRL  0xc8006074
#define P_MMC_QOS5_MAX   0xc8006078
#define P_MMC_QOS5_MIN   0xc800607c
#define P_MMC_QOS5_STOP  0xc8006080
#define P_MMC_QOS5_LIMIT 0xc8006084
#define P_MMC_QOS6_CTRL  0xc8006088
#define P_MMC_QOS6_MAX   0xc800608c
#define P_MMC_QOS6_MIN   0xc8006090
#define P_MMC_QOS6_STOP  0xc8006094
#define P_MMC_QOS6_LIMIT 0xc8006098
#define P_MMC_QOS7_CTRL  0xc800609c
#define P_MMC_QOS7_MAX   0xc80060a0
#define P_MMC_QOS7_MIN   0xc80060a4
#define P_MMC_QOS7_STOP  0xc80060a8
#define P_MMC_QOS7_LIMIT 0xc80060ac

#define P_MMC_QOSMON_CTRL     0xc80060b0
#define P_MMC_QOSMON_TIM      0xc80060b4
#define P_MMC_QOSMON_MST      0xc80060b8
#define P_MMC_MON_CLKCNT      0xc80060bc
#define P_MMC_ALL_REQCNT      0xc80060c0
#define P_MMC_ALL_GANTCNT     0xc80060c4
#define P_MMC_ONE_REQCNT      0xc80060c8
#define P_MMC_ONE_CYCLE_CNT   0xc80060cc
#define P_MMC_ONE_DATA_CNT    0xc80060d0



#define P_DC_CAV_CTRL               0xc8006300

#define P_DC_CAV_LVL3_GRANT         0xc8006304
#define P_DC_CAV_LVL3_GH            0xc8006308
  // this is a 32 bit grant regsiter.
  // each bit grant a thread ID for LVL3 use.

#define P_DC_CAV_LVL3_FLIP          0xc800630c
#define P_DC_CAV_LVL3_FH            0xc8006310
  // this is a 32 bit FLIP regsiter.
  // each bit to define  a thread ID for LVL3 use.

#define P_DC_CAV_LVL3_CTRL0         0xc8006314
#define P_DC_CAV_LVL3_CTRL1         0xc8006318
#define P_DC_CAV_LVL3_CTRL2         0xc800631c
#define P_DC_CAV_LVL3_CTRL3         0xc8006320
#define P_DC_CAV_LUT_DATAL          0xc8006324
	#define CANVAS_ADDR_LMASK       0x1fffffff
    #define CANVAS_WIDTH_LMASK		0x7
    #define CANVAS_WIDTH_LWID		3
    #define CANVAS_WIDTH_LBIT		29
	
#define P_DC_CAV_LUT_DATAH          0xc8006328
	#define CANVAS_WIDTH_HMASK		0x1ff
	#define CANVAS_WIDTH_HBIT		0
	#define CANVAS_HEIGHT_MASK		0x1fff
	#define CANVAS_HEIGHT_BIT		9
	#define CANVAS_YWRAP			(1<<23)
	#define CANVAS_XWRAP			(1<<22)
    #define CANVAS_ADDR_NOWRAP      0x00
    #define CANVAS_ADDR_WRAPX       0x01
    #define CANVAS_ADDR_WRAPY       0x02
    #define CANVAS_BLKMODE_MASK     3
    #define CANVAS_BLKMODE_BIT      24
    #define CANVAS_BLKMODE_LINEAR   0x00
    #define CANVAS_BLKMODE_32X32    0x01
    #define CANVAS_BLKMODE_64X32    0x02

#define P_DC_CAV_LUT_ADDR           0xc800632c
	#define CANVAS_LUT_INDEX_BIT    0
    #define CANVAS_LUT_INDEX_MASK   0x7
    #define CANVAS_LUT_WR_EN        (0x2 << 8)
    #define CANVAS_LUT_RD_EN        (0x1 << 8)
	
#define P_DC_CAV_LVL3_MODE          0xc8006330
#define P_MMC_PROT_ADDR             0xc8006334 
#define P_MMC_PROT_SELH             0xc8006338 
#define P_MMC_PROT_SELL             0xc800633c 
#define P_MMC_PROT_CTL_STS          0xc8006340 
#define P_MMC_INT_STS               0xc8006344 


#define P_MMC_REQ0_CTRL             0xc8006388
   // bit 31,            request in enable.
   // 30:24:             cmd fifo counter when request generate to dmc arbitor if there's no lbrst.
   // 23:16:             waiting time when request generate to dmc arbitor if there's o lbrst.
   // 15:8:              how many write rsp can hold in the whole dmc pipe lines.
   // 7:0:               how many read data can hold in the whole dmc pipe lines.

#define P_MMC_REQ1_CTRL             0xc800638c
#define P_MMC_REQ2_CTRL             0xc8006390
#define P_MMC_REQ3_CTRL             0xc8006394
#define P_MMC_REQ4_CTRL             0xc8006398
#define P_MMC_REQ5_CTRL             0xc800639c
#define P_MMC_REQ6_CTRL             0xc80063a0
#define P_MMC_REQ7_CTRL             0xc80063a4
                                           

#define P_MMC_REQ_CTRL        0xc8006400 
#define P_MMC_SOFT_RST        0xc8006404
  // bit 23.    reset no hold for chan7.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 22.    reset no hold for chan6.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 21.    reset no hold for chan5.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 20.    reset no hold for chan4.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 19.    reset no hold for chan3.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 18.    reset no hold for chan2.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 17.    reset no hold for chan1.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 16.    reset no hold for chan0.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 12.    write 1 to reset the whole MMC module(not include the APB3 interface).  read =0 means the reset finished. 
  // bit 10.    write 1 to reset DDR PHY only.    read 0 means the reset finished.
  // bit 9.     write 1 to reset the whole PCTL module.   read 0 means the reset finished.
  // bit 8.     write 1 to reset the whole DMC module.    read 0 means the reset finished.
  // bit 7.     write 1 to reset dmc request channel 7.   read 0 means the reset finished.
  // bit 6.     write 1 to reset dmc request channel 6.   read 0 means the reset finished.
  // bit 5.     write 1 to reset dmc request channel 5.   read 0 means the reset finished.
  // bit 4.     write 1 to reset dmc request channel 4.   read 0 means the reset finished.
  // bit 3.     write 1 to reset dmc request channel 3.   read 0 means the reset finished.
  // bit 2.     write 1 to reset dmc request channel 2.   read 0 means the reset finished.
  // bit 1.     write 1 to reset dmc request channel 1.   read 0 means the reset finished.
  // bit 0.     write 1 to reset dmc request channel 0.   read 0 means the reset finished.

#define P_MMC_RST_STS        0xc8006408
  // bit 23.    reset no hold for chan7.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 22.    reset no hold for chan6.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 21.    reset no hold for chan5.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 20.    reset no hold for chan4.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 19.    reset no hold for chan3.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 18.    reset no hold for chan2.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 17.    reset no hold for chan1.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 16.    reset no hold for chan0.   when do mmc/dmc reset, don't wait chan7 reset finished. maybe there's no clock. active high. 
  // bit 12.    write 1 to reset the whole MMC module(not include the APB3 interface).  read =0 means the reset finished. 
  // bit 10.    write 1 to reset DDR PHY only.    read 0 means the reset finished.
  // bit 9.     write 1 to reset the whole PCTL module.   read 0 means the reset finished.
  // bit 8.     write 1 to reset the whole DMC module.    read 0 means the reset finished.
  // bit 7.     write 1 to reset dmc request channel 7.   read 0 means the reset finished.
  // bit 6.     write 1 to reset dmc request channel 6.   read 0 means the reset finished.
  // bit 5.     write 1 to reset dmc request channel 5.   read 0 means the reset finished.
  // bit 4.     write 1 to reset dmc request channel 4.   read 0 means the reset finished.
  // bit 3.     write 1 to reset dmc request channel 3.   read 0 means the reset finished.
  // bit 2.     write 1 to reset dmc request channel 2.   read 0 means the reset finished.
  // bit 1.     write 1 to reset dmc request channel 1.   read 0 means the reset finished.
  // bit 0.     write 1 to reset dmc request channel 0.   read 0 means the reset finished.

#define P_MMC_APB3_CTRL             0xc800640c

#define P_MMC_CHAN_STS        0xc8006410
  //bit15    chan7 request bit.    1 means there's request for chan7.
  //bit14    chan6 request bit.    1 means there's request for chan6.
  //bit13    chan5 request bit.    1 means there's request for chan5.
  //bit12    chan4 request bit.    1 means there's request for chan4.
  //bit11    chan3 request bit.    1 means there's request for chan3.
  //bit10    chan2 request bit.    1 means there's request for chan2.
  //bit9     chan1 request bit.    1 means there's request for chan1.
  //bit8     chan0 request bit.    1 means there's request for chan0.
  //bit 7    chan7 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 6    chan6 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 5    chan5 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 4    chan4 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 3    chan3 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 2    chan2 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 1    chan1 status. 1 : idle.  0 busy.     it show idle only after disable this channel.
  //bit 0    chan0 status. 1 : idle.  0 busy.     it show idle only after disable this channel.


#define P_MMC_CLKG_CNTL0      0xc8006414
  // bit 18. 1: enable dmc cbus auto clock gating 
  // bit 17. 1: enable rdfifo auto clock gating 
  // bit 16. 1: enable pending read auto clock gating 
  // bit 15. 1: enable wdfifo auto clock gating 
  // bit 14. 1: enable pending wrte auto clock gating 
  // bit 13. 1: enalbe mgr auto clock gating 
  // bit 12. 1: enalbe cmdenc auto clock gating 
  // bit 11. 1: enable canvas cbus auto clock gating 
  // bit 10. 1: enable canvas auto clock gating 
  // bit 9.  1: enable pipefifo auto clock gating 
  // bit 8.  1: enable qos auto clock gating   
  // bit 7.  1: enable chan7 auto clock gating 
  // bit 6.  1: enable chan6 auto clock gating 
  // bit 5.  1: enable chan5 auto clock gating 
  // bit 4.  1: enable chan4 auto clock gating 
  // bit 3.  1: enable chan3 auto clock gating 
  // bit 2.  1: enable chan2 auto clock gating 
  // bit 1.  1: enable chan1 auto clock gating 
  // bit 0.  1: enable chan0 auto clock gating 

#define P_MMC_CLKG_CNTL1      0xc8006418
  // bit 22. 1: disable ddr_phy reading clock.
  // bit 21. 1: disable the PCTL APB2 clock.
  // bit 20. 1: disable the PCTL clock.
  // bit 19. 1: disable the whole dmc clock
  // bit 18. 1: disable the dmc cbus clock
  // bit 17. 1: disable rdfifo  clock  
  // bit 16. 1: disable pending read  clock  
  // bit 15. 1: disable wdfifo  clock  
  // bit 14. 1: disable pending wrte  clock  
  // bit 13. 1: disable mgr  clock  
  // bit 12. 1: disable cmdenc  clock  
  // bit 11. 1: disable canvas cbus  clock  
  // bit 10. 1: disable canvas  clock  
  // bit 9.  1: disable pipefifo  clock  
  // bit 8.  1: disable qos  clock    
  // bit 7.  1: disable chan7  clock  
  // bit 6.  1: disable chan6  clock  
  // bit 5.  1: disable chan5  clock  
  // bit 4.  1: disable chan4  clock  
  // bit 3.  1: disable chan3  clock  
  // bit 2.  1: disable chan2  clock  
  // bit 1.  1: disable chan1  clock  
  // bit 0.  1: disable chan0  clock  

#define P_MMC_CLK_CNTL      0xc800641c
   //bit 31     1 disabel all clock.
   //bit 30.    1 enable  auto clock gating. 0 : enable all clock if bit 31 = 0;
   //bit 29.    DDR PLL lock signal.   DDR PLL locked = 1.  
   //bit  7.    dll_clk_sel. 1 : the DLL input is directly from DDR PLL.  0: the DLL input is from slow clock or from DDR PLL clock divider. 
   //bit  6.    pll_clk_en.  1 : enable the DDR PLL clock to DDR DLL path. 0 : disable the DDR PLL clock to DDR PLL path.
   //bit  5.    divider/slow clock selection.   1 = slow clock.  0 = DDR PLL clock divider.  
   //bit  4.    slow clock enable.     1 = slow clock en.  0 : disalbe slow clock.
   //bit  3.    PLL clk divider enable. 1 = enable. 0 disable.
   //bit  2.    divider clock output enalbe.
   //bit 1:0    divider:    00 : /2.   01: /4. 10 : /8. 11: /16. 
   
#define P_MMC_DDR_PHY_GPR0   0xc8006420
#define P_MMC_DDR_PHY_GPR1   0xc8006424
#define P_MMC_LP_CTRL1       0xc8006428
   //bit 31.      enable mmc low power mode.
   //bit 30.      set low power request to UPCTL  this bit is low active. 
   //bit 29.      set low power active_in to UPCTL. this bit is low active.
   //bit 28.      enable PCTL auto power down mode. 
   //bit 27.      enable DMC auto gate control. 
   //bit 26.      enable DMC auto gate fast mode.
   //bit 25.      when mmc low power mode, the DDR PHY DLL is bypassed or not. 
   //bit 24.      dmc module exit from low power mode before PCTL and DDR PHY wakeup.
   //bit 23.      force dmc clock enabled. 
   //bit 22.      disable the dmc clock.  bit 23 and bit 22 can't be 1 same time.
   //bit 21.      force UPCTL clock enabled. 
   //bit 20.      disable UPCTL clock. 
   //bit 19.      force DDR PHY PUBL clock enabled. 
   //bit 18.      disable DDR PHY PUBL clock. 
   //bit 17.      for low power request and active to UPCTL use bit 30 29 instead of auto ctrol.
   //bit 16.      desable the low power request and active to UPCTL from auto controller. 
   //bit 15:0.    the number of system clock cycles of IDLE state, the system will enter LP mode.
#define P_MMC_LP_CTRL2       0xc800642c
   //bit 31:24    t_cross, the cross clock domain latency. 
   //bit 23:16    t_lp_min,  minmum time for hold in LOW POWER state, then UCPTL can hanle the request correctly. 
   //bit 15:8.    t_clk_stable,   how long to wait the DDR_PHY clock stable, when we can send new request.
   //bit 7:0.     t_lp_settle.  the time need to wait after sending wakeup request to UPCTL.

#define P_MMC_LP_CTRL3       0xc8006430
  //bit 31:24.    t_100ns.    100ns ticker.
  //bit 23:16.    t_apb_hold.   whenever there's apb3 request, hold the apb clock for some time.
  //bit 15:8.     t_auto_gate.  in PCTL auto power down mode, ilde counter number to enter power down mode. 
  //bit 7:0.      t_dmc_gate.   in DMC auto gate fast mode. idle counter number to enter dmc clock gating.
#define P_MMC_LP_CTRL4       0xc8006434
  //bit 31.    PVT enable. use MMC Low power controller to controll DDR PHY PVT update.
  //bit 30.    ZQC enable. use MMC Low power cont
  //bit 23:16. PVT timing interval.  unit 100ns.
  //bit 15:8.  ZQC timing interval.  unit 100ns.
  //bit 7:0.   REFI timing interval.  unit 100ns.
#define P_MMC_LP_STS         0xc8006438
  //bit 30.    UPCTL sysack bit value.
  //bit 29.    UPCTL active bit value.
  //bit 3:0    LP controller status.
#define P_MMC_PCTL_STAT      0xc800643c
#define P_MMC_CMDZQ_CTRL     0xc8006440
   //bit 20.   force comamnd lane ZQ use register value.
   //bit 19:0.  register value for command lane ZQ.


#define sec_mmc_wr(addr, data) *(volatile unsigned long *) (addr)=data
#define sec_mmc_rd(addr) *(volatile unsigned long *) (addr )

#define P_DMC_SEC_RANGE0_ST   		0xda002000
#define P_DMC_SEC_RANGE0_END  		0xda002004
#define P_DMC_SEC_RANGE1_ST   		0xda002008
#define P_DMC_SEC_RANGE1_END  		0xda00200c
#define P_DMC_SEC_RANGE2_ST   		0xda002010
#define P_DMC_SEC_RANGE2_END  		0xda002014
#define P_DMC_SEC_RANGE3_ST   		0xda002018
#define P_DMC_SEC_RANGE3_END  		0xda00201c
#define P_DMC_SEC_PORT0_RANGE0		0xda002020
#define P_DMC_SEC_PORT1_RANGE0		0xda002024
#define P_DMC_SEC_PORT2_RANGE0		0xda002028
#define P_DMC_SEC_PORT3_RANGE0		0xda00202c
#define P_DMC_SEC_PORT4_RANGE0		0xda002030
#define P_DMC_SEC_PORT5_RANGE0		0xda002034
#define P_DMC_SEC_PORT6_RANGE0		0xda002038
#define P_DMC_SEC_PORT7_RANGE0		0xda00203c
#define P_DMC_SEC_PORT0_RANGE1		0xda002040
#define P_DMC_SEC_PORT1_RANGE1		0xda002044
#define P_DMC_SEC_PORT2_RANGE1		0xda002048
#define P_DMC_SEC_PORT3_RANGE1		0xda00204c
#define P_DMC_SEC_PORT4_RANGE1		0xda002050
#define P_DMC_SEC_PORT5_RANGE1		0xda002054
#define P_DMC_SEC_PORT6_RANGE1		0xda002058
#define P_DMC_SEC_PORT7_RANGE1		0xda00205c
#define P_DMC_SEC_PORT0_RANGE2		0xda002060
#define P_DMC_SEC_PORT1_RANGE2		0xda002064
#define P_DMC_SEC_PORT2_RANGE2		0xda002068
#define P_DMC_SEC_PORT3_RANGE2		0xda00206c
#define P_DMC_SEC_PORT4_RANGE2		0xda002070
#define P_DMC_SEC_PORT5_RANGE2		0xda002074
#define P_DMC_SEC_PORT6_RANGE2		0xda002078
#define P_DMC_SEC_PORT7_RANGE2		0xda00207c
#define P_DMC_SEC_PORT0_RANGE3		0xda002080
#define P_DMC_SEC_PORT1_RANGE3		0xda002084
#define P_DMC_SEC_PORT2_RANGE3		0xda002088
#define P_DMC_SEC_PORT3_RANGE3		0xda00208c
#define P_DMC_SEC_PORT4_RANGE3		0xda002090
#define P_DMC_SEC_PORT5_RANGE3		0xda002094
#define P_DMC_SEC_PORT6_RANGE3		0xda002098
#define P_DMC_SEC_PORT7_RANGE3		0xda00209c
#define P_DMC_SEC_BAD_ACCESS  		0xda0020a0
#define P_DMC_SEC_CTRL     		0xda0020a4


#endif


