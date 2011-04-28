#ifndef MMC_DEFINE
#define MMC_DEFINE

//#define APB_Wr(addr, data) *(volatile unsigned long *) (0xc8000000 + addr )=data
//#define APB_Rd(addr) *(volatile unsigned long *) (0xc8000000 + addr )

#define  UPCTL_STAT_ADDR 		0x0008
#define  UPCTL_INTRSTAT_ADDR 		0x000c
#define  UPCTL_SCTL_ADDR 		0x0004
#define  UPCTL_SCFG_ADDR 		0x0000
#define  UPCTL_POWSTAT_ADDR 		0x0048
#define  UPCTL_MRRSTAT0_ADDR 		0x0064
#define  UPCTL_CMDTSTAT_ADDR 		0x004c
#define  UPCTL_MCMD_ADDR 		0x0040
#define  UPCTL_MRRSTAT1_ADDR 		0x0068
#define  UPCTL_MRRCFG0_ADDR 		0x0060
#define  UPCTL_CMDTSTATEN_ADDR 		0x0050
#define  UPCTL_POWCTL_ADDR 		0x0044
#define  UPCTL_LPDDR2ZQCFG_ADDR 	0x008c
#define  UPCTL_PPCFG_ADDR 		0x0084
#define  UPCTL_MCFG1_ADDR 		0x007c
#define  UPCTL_MSTAT_ADDR 		0x0088
#define  UPCTL_MCFG_ADDR 		0x0080
#define  UPCTL_DTUAWDT_ADDR 		0x00b0
#define  UPCTL_DTUPRD2_ADDR 		0x00a8
#define  UPCTL_DTUPRD3_ADDR 		0x00ac
#define  UPCTL_DTUNE_ADDR 		0x009c
#define  UPCTL_DTUPDES_ADDR 		0x0094
#define  UPCTL_DTUNA_ADDR 		0x0098
#define  UPCTL_DTUPRD0_ADDR 		0x00a0
#define  UPCTL_DTUPRD1_ADDR 		0x00a4
#define  UPCTL_TCKSRE_ADDR 		0x0124
#define  UPCTL_TZQCSI_ADDR 		0x011c
#define  UPCTL_TINIT_ADDR 		0x00c4
#define  UPCTL_TDPD_ADDR 		0x0144
#define  UPCTL_TOGCNT1U_ADDR 		0x00c0
#define  UPCTL_TCKE_ADDR 		0x012c
#define  UPCTL_TMOD_ADDR 		0x0130
#define  UPCTL_TEXSR_ADDR 		0x010c
#define  UPCTL_TAL_ADDR 		0x00e4
#define  UPCTL_TRTP_ADDR 		0x0100
#define  UPCTL_TCKSRX_ADDR 		0x0128
#define  UPCTL_TRTW_ADDR 		0x00e0
#define  UPCTL_TCWL_ADDR 		0x00ec
#define  UPCTL_TWR_ADDR 		0x0104
#define  UPCTL_TCL_ADDR 		0x00e8
#define  UPCTL_TDQS_ADDR 		0x0120
#define  UPCTL_TRSTH_ADDR 		0x00c8
#define  UPCTL_TRCD_ADDR 		0x00f8
#define  UPCTL_TXP_ADDR 		0x0110
#define  UPCTL_TOGCNT100N_ADDR 		0x00cc
#define  UPCTL_TMRD_ADDR 		0x00d4
#define  UPCTL_TRSTL_ADDR 		0x0134
#define  UPCTL_TREFI_ADDR 		0x00d0
#define  UPCTL_TRAS_ADDR 		0x00f0
#define  UPCTL_TWTR_ADDR 		0x0108
#define  UPCTL_TRC_ADDR 		0x00f4
#define  UPCTL_TRFC_ADDR 		0x00d8
#define  UPCTL_TMRR_ADDR 		0x013c
#define  UPCTL_TCKESR_ADDR 		0x0140
#define  UPCTL_TZQCL_ADDR 		0x0138
#define  UPCTL_TRRD_ADDR 		0x00fc
#define  UPCTL_TRP_ADDR 		0x00dc
#define  UPCTL_TZQCS_ADDR 		0x0118
#define  UPCTL_TXPDLL_ADDR 		0x0114
#define  UPCTL_ECCCFG_ADDR 		0x0180
#define  UPCTL_ECCLOG_ADDR 		0x018c
#define  UPCTL_ECCCLR_ADDR 		0x0188
#define  UPCTL_ECCTST_ADDR 		0x0184
#define  UPCTL_DTUWD0_ADDR 		0x0210
#define  UPCTL_DTUWD1_ADDR 		0x0214
#define  UPCTL_DTUWACTL_ADDR 		0x0200
#define  UPCTL_DTULFSRRD_ADDR 		0x0238
#define  UPCTL_DTUWD2_ADDR 		0x0218
#define  UPCTL_DTUWD3_ADDR 		0x021c
#define  UPCTL_DTULFSRWD_ADDR 		0x0234
#define  UPCTL_DTURACTL_ADDR 		0x0204
#define  UPCTL_DTUWDM_ADDR 		0x0220
#define  UPCTL_DTURD0_ADDR 		0x0224
#define  UPCTL_DTURD1_ADDR 		0x0228
#define  UPCTL_DTURD2_ADDR 		0x022c
#define  UPCTL_DTURD3_ADDR 		0x0230
#define  UPCTL_DTUCFG_ADDR 		0x0208
#define  UPCTL_DTUEAF_ADDR 		0x023c
#define  UPCTL_DTUECTL_ADDR 		0x020c
#define  UPCTL_DFIODTCFG1_ADDR 		0x0248
#define  UPCTL_DFITCTRLDELAY_ADDR 	0x0240
#define  UPCTL_DFIODTRANKMAP_ADDR 	0x024c
#define  UPCTL_DFIODTCFG_ADDR 		0x0244
#define  UPCTL_DFITPHYWRLAT_ADDR 	0x0254
#define  UPCTL_DFITPHYWRDATA_ADDR 	0x0250
#define  UPCTL_DFITRDDATAEN_ADDR 	0x0260
#define  UPCTL_DFITPHYRDLAT_ADDR 	0x0264
#define  UPCTL_DFITREFMSKI_ADDR 	0x0294
#define  UPCTL_DFITPHYUPDTYPE0_ADDR 	0x0270
#define  UPCTL_DFITPHYUPDTYPE1_ADDR 	0x0274
#define  UPCTL_DFITCTRLUPDDLY_ADDR 	0x0288
#define  UPCTL_DFITPHYUPDTYPE2_ADDR 	0x0278
#define  UPCTL_DFITCTRLUPDMIN_ADDR 	0x0280
#define  UPCTL_DFITPHYUPDTYPE3_ADDR 	0x027c
#define  UPCTL_DFIUPDCFG_ADDR 		0x0290
#define  UPCTL_DFITCTRLUPDMAX_ADDR 	0x0284
#define  UPCTL_DFITCTRLUPDI_ADDR 	0x0298
#define  UPCTL_DFITRRDLVLEN_ADDR 	0x02b8
#define  UPCTL_DFITRSTAT0_ADDR 		0x02b0
#define  UPCTL_DFITRWRLVLEN_ADDR 	0x02b4
#define  UPCTL_DFITRCFG0_ADDR 		0x02ac
#define  UPCTL_DFITRRDLVLGATEEN_ADDR 	0x02bc
#define  UPCTL_DFISTSTAT0_ADDR 		0x02c0
#define  UPCTL_DFISTPARLOG_ADDR 	0x02e0
#define  UPCTL_DFITDRAMCLKEN_ADDR 	0x02d0
#define  UPCTL_DFISTPARCLR_ADDR 	0x02dc
#define  UPCTL_DFISTCFG0_ADDR 		0x02c4
#define  UPCTL_DFISTCFG1_ADDR 		0x02c8
#define  UPCTL_DFISTCFG2_ADDR 		0x02d8
#define  UPCTL_DFITDRAMCLKDIS_ADDR 	0x02d4
#define  UPCTL_DFILPCFG0_ADDR 		0x02f0
#define  UPCTL_DFITRWRLVLDELAY0_ADDR 	0x0318
#define  UPCTL_DFITRWRLVLDELAY1_ADDR 	0x031c
#define  UPCTL_DFITRWRLVLDELAY2_ADDR 	0x0320
#define  UPCTL_DFITRRDLVLRESP0_ADDR 	0x030c
#define  UPCTL_DFITRRDLVLRESP1_ADDR 	0x0310
#define  UPCTL_DFITRRDLVLRESP2_ADDR 	0x0314
#define  UPCTL_DFITRWRLVLRESP0_ADDR 	0x0300
#define  UPCTL_DFITRRDLVLDELAY0_ADDR 	0x0324
#define  UPCTL_DFITRRDLVLDELAY1_ADDR 	0x0328
#define  UPCTL_DFITRWRLVLRESP1_ADDR 	0x0304
#define  UPCTL_DFITRRDLVLDELAY2_ADDR 	0x032c
#define  UPCTL_DFITRWRLVLRESP2_ADDR 	0x0308
#define  UPCTL_DFITRRDLVLGATEDELAY0_ADDR 	0x0330
#define  UPCTL_DFITRCMD_ADDR 			0x033c
#define  UPCTL_DFITRRDLVLGATEDELAY1_ADDR 	0x0334
#define  UPCTL_DFITRRDLVLGATEDELAY2_ADDR 	0x0338
#define  UPCTL_IPTR_ADDR 		0x03fc
#define  UPCTL_IPVR_ADDR 		0x03f8

#define  PUB_RIDR_ADDR  		0x1000
#define  PUB_PIR_ADDR  			0x1004 
#define  PUB_PGCR_ADDR  		0x1008
#define  PUB_PGSR_ADDR  		0x100c
#define  PUB_DLLGCR_ADDR  		0x1010
#define  PUB_ACDLLCR_ADDR  		0x1014
#define  PUB_PTR0_ADDR  		0x1018
#define  PUB_PTR1_ADDR  		0x101c
#define  PUB_PTR2_ADDR  		0x1020
#define  PUB_ACIOCR_ADDR  		0x1024
#define  PUB_DXCCR_ADDR  		0x1028
#define  PUB_DSGCR_ADDR  		0x102c
#define  PUB_DCR_ADDR  			0x1030
#define  PUB_DTPR0_ADDR  		0x1034
#define  PUB_DTPR1_ADDR  		0x1038
#define  PUB_DTPR2_ADDR  		0x103c
#define  PUB_MR0_ADDR  		0x1040
#define  PUB_MR1_ADDR  		0x1044
#define  PUB_MR2_ADDR  		0x1048
#define  PUB_MR3_ADDR  		0x104c
#define  PUB_ODTCR_ADDR  		0x1050
#define  PUB_DTAR_ADDR  		0x1054
#define  PUB_DTDR0_ADDR  		0x1058
#define  PUB_DTDR1_ADDR  		0x105c
#define  PUB_DCUAR_ADDR  		0x10c0
#define  PUB_DCUDR_ADDR  		0x10c4
#define  PUB_DCURR_ADDR  		0x10c8
#define  PUB_DCULR_ADDR  		0x10cc
#define  PUB_DCUGCR_ADDR  		0x10d0
#define  PUB_DCUTPR_ADDR  		0x10d4
#define  PUB_DCUSR0_ADDR  		0x10d8
#define  PUB_DCUSR1_ADDR  		0x10dc
#define  PUB_BISTRR_ADDR  		0x1100
#define  PUB_BISTMSKR0_ADDR  	0x1104
#define  PUB_BISTMSKR1_ADDR  	0x1108
#define  PUB_BISTWCR_ADDR  	0x110c
#define  PUB_BISTLSR_ADDR  	0x1110
#define  PUB_BISTAR0_ADDR  	0x1114
#define  PUB_BISTAR1_ADDR  	0x1118
#define  PUB_BISTAR2_ADDR  	0x111c
#define  PUB_BISTUDPR_ADDR  	0x1120
#define  PUB_BISTGSR_ADDR  	0x1124
#define  PUB_BISTWER_ADDR  	0x1128
#define  PUB_BISTBER0_ADDR  	0x112c
#define  PUB_BISTBER1_ADDR  	0x1130
#define  PUB_BISTBER2_ADDR  	0x1134
#define  PUB_BISTWCSR_ADDR  	0x1138
#define  PUB_BISTFWR0_ADDR  	0x113c
#define  PUB_BISTFWR1_ADDR  	0x1140
#define  PUB_GPR0_ADDR  		0x1178
#define  PUB_GPR1_ADDR  		0x117c
#define  PUB_ZQ0CR0_ADDR		0x1180
#define  PUB_ZQ0CR1_ADDR		0x1184
#define  PUB_ZQ0SR0_ADDR		0x1188
#define  PUB_ZQ0SR1_ADDR		0x118c
#define  PUB_ZQ1CR0_ADDR		0x1190
#define  PUB_ZQ1CR1_ADDR		0x1194
#define  PUB_ZQ1SR0_ADDR		0x1198
#define  PUB_ZQ1SR1_ADDR		0x119c
#define  PUB_ZQ2CR0_ADDR		0x11a0
#define  PUB_ZQ2CR1_ADDR		0x11a4
#define  PUB_ZQ2SR0_ADDR		0x11a8
#define  PUB_ZQ2SR1_ADDR		0x11ac
#define  PUB_ZQ3CR0_ADDR		0x11b0
#define  PUB_ZQ3CR1_ADDR		0x11b4
#define  PUB_ZQ3SR0_ADDR		0x11b8
#define  PUB_ZQ3SR1_ADDR		0x11bc
#define  PUB_DX0GCR_ADDR		0x11c0
#define  PUB_DX0GSR0_ADDR		0x11c4
#define  PUB_DX0GSR1_ADDR		0x11c8
#define  PUB_DX0DLLCR_ADDR		0x11cc
#define  PUB_DX0DQTR_ADDR		0x11d0
#define  PUB_DX0DQSTR_ADDR		0x11d4
#define  PUB_DX1GCR_ADDR		0x1200
#define  PUB_DX1GSR0_ADDR		0x1204
#define  PUB_DX1GSR1_ADDR		0x1208
#define  PUB_DX1DLLCR_ADDR		0x120c
#define  PUB_DX1DQTR_ADDR		0x1210
#define  PUB_DX1DQSTR_ADDR		0x1214
#define  PUB_DX2GCR_ADDR		0x1240
#define  PUB_DX2GSR0_ADDR		0x1244
#define  PUB_DX2GSR1_ADDR		0x1248
#define  PUB_DX2DLLCR_ADDR		0x124c
#define  PUB_DX2DQTR_ADDR		0x1250
#define  PUB_DX2DQSTR_ADDR		0x1254
#define  PUB_DX3GCR_ADDR		0x1280
#define  PUB_DX3GSR0_ADDR		0x1284
#define  PUB_DX3GSR1_ADDR		0x1288
#define  PUB_DX3DLLCR_ADDR		0x128c
#define  PUB_DX3DQTR_ADDR		0x1290
#define  PUB_DX3DQSTR_ADDR		0x1294
#define  PUB_DX4GCR_ADDR		0x12c0
#define  PUB_DX4GSR0_ADDR		0x12c4
#define  PUB_DX4GSR1_ADDR		0x12c8
#define  PUB_DX4DLLCR_ADDR		0x12cc
#define  PUB_DX4DQTR_ADDR		0x12d0
#define  PUB_DX4DQSTR_ADDR		0x12d4
#define  PUB_DX5GCR_ADDR		0x1300
#define  PUB_DX5GSR0_ADDR		0x1304
#define  PUB_DX5GSR1_ADDR		0x1308
#define  PUB_DX5DLLCR_ADDR		0x130c
#define  PUB_DX5DQTR_ADDR		0x1310
#define  PUB_DX5DQSTR_ADDR		0x1314
#define  PUB_DX6GCR_ADDR		0x1340
#define  PUB_DX6GSR0_ADDR		0x1344
#define  PUB_DX6GSR1_ADDR		0x1348
#define  PUB_DX6DLLCR_ADDR		0x134c
#define  PUB_DX6DQTR_ADDR		0x1350
#define  PUB_DX6DQSTR_ADDR		0x1354
#define  PUB_DX7GCR_ADDR		0x1380
#define  PUB_DX7GSR0_ADDR		0x1384
#define  PUB_DX7GSR1_ADDR		0x1388
#define  PUB_DX7DLLCR_ADDR		0x138c
#define  PUB_DX7DQTR_ADDR		0x1390
#define  PUB_DX7DQSTR_ADDR		0x1394
#define  PUB_DX8GCR_ADDR		0x13c0
#define  PUB_DX8GSR0_ADDR		0x13c4
#define  PUB_DX8GSR1_ADDR		0x13c8
#define  PUB_DX8DLLCR_ADDR		0x13cc
#define  PUB_DX8DQTR_ADDR		0x13d0
#define  PUB_DX8DQSTR_ADDR		0x13d4


#define MMC_DDR_CTRL        0x6000
#define MMC_ARB_CTRL        0x6008 
#define MMC_ARB_CTRL1       0x600c 

#define MMC_QOS0_CTRL  0x6010
   //bit 31     qos enable.
   //bit 26     1 : danamic change the bandwidth percentage. 0 : fixed bandwidth.  all 64. 
   //bit 25       grant mode. 1 grant clock cycles. 0 grant data cycles.
   //bit 24       leakybucket counter goes to 0. When no req or no other request. 
   //bit 21:16    bankwidth requirement. unit 1/64. 
   //bit 15:0.    after stop the re_enable threadhold.

#define MMC_QOS0_MAX   0x6014
#define MMC_QOS0_MIN   0x6018
#define MMC_QOS0_LIMIT 0x601c
#define MMC_QOS0_STOP  0x6020
#define MMC_QOS1_CTRL  0x6024
#define MMC_QOS1_MAX   0x6028
#define MMC_QOS1_MIN   0x602c
#define MMC_QOS1_STOP  0x6030
#define MMC_QOS1_LIMIT 0x6034
#define MMC_QOS2_CTRL  0x6038
#define MMC_QOS2_MAX   0x603c
#define MMC_QOS2_MIN   0x6040
#define MMC_QOS2_STOP  0x6044
#define MMC_QOS2_LIMIT 0x6048
#define MMC_QOS3_CTRL  0x604c
#define MMC_QOS3_MAX   0x6050
#define MMC_QOS3_MIN   0x6054
#define MMC_QOS3_STOP  0x6058
#define MMC_QOS3_LIMIT 0x605c
#define MMC_QOS4_CTRL  0x6060
#define MMC_QOS4_MAX   0x6064
#define MMC_QOS4_MIN   0x6068
#define MMC_QOS4_STOP  0x606c
#define MMC_QOS4_LIMIT 0x6070
#define MMC_QOS5_CTRL  0x6074
#define MMC_QOS5_MAX   0x6078
#define MMC_QOS5_MIN   0x607c
#define MMC_QOS5_STOP  0x6080
#define MMC_QOS5_LIMIT 0x6084
#define MMC_QOS6_CTRL  0x6088
#define MMC_QOS6_MAX   0x608c
#define MMC_QOS6_MIN   0x6090
#define MMC_QOS6_STOP  0x6094
#define MMC_QOS6_LIMIT 0x6098
#define MMC_QOS7_CTRL  0x609c
#define MMC_QOS7_MAX   0x60a0
#define MMC_QOS7_MIN   0x60a4
#define MMC_QOS7_STOP  0x60a8
#define MMC_QOS7_LIMIT 0x60ac

#define MMC_QOSMON_CTRL     0x60b0
#define MMC_QOSMON_TIM      0x60b4
#define MMC_QOSMON_MST      0x60b8
#define MMC_MON_CLKCNT      0x60bc
#define MMC_ALL_REQCNT      0x60c0
#define MMC_ALL_GANTCNT     0x60c4
#define MMC_ONE_REQCNT      0x60c8
#define MMC_ONE_CYCLE_CNT   0x60cc
#define MMC_ONE_DATA_CNT    0x60d0



#define DC_CAV_CTRL               0x6300

#define DC_CAV_LVL3_GRANT         0x6304
#define DC_CAV_LVL3_GH            0x6308
  // this is a 32 bit grant regsiter.
  // each bit grant a thread ID for LVL3 use.

#define DC_CAV_LVL3_FLIP          0x630c
#define DC_CAV_LVL3_FH            0x6310
  // this is a 32 bit FLIP regsiter.
  // each bit to define  a thread ID for LVL3 use.

#define DC_CAV_LVL3_CTRL0         0x6314
#define DC_CAV_LVL3_CTRL1         0x6318
#define DC_CAV_LVL3_CTRL2         0x631c
#define DC_CAV_LVL3_CTRL3         0x6320
#define DC_CAV_LUT_DATAL          0x6324
#define DC_CAV_LUT_DATAH          0x6328
#define DC_CAV_LUT_ADDR           0x632c
#define DC_CAV_LVL3_MODE          0x6330
#define MMC_PROT_ADDR             0x6334 
#define MMC_PROT_SELH             0x6338 
#define MMC_PROT_SELL             0x633c 
#define MMC_PROT_CTL_STS          0x6340 
#define MMC_INT_STS               0x6344 


#define MMC_REQ0_CTRL             0x6388
   // bit 31,            request in enable.
   // 30:24:             cmd fifo counter when request generate to dmc arbitor if there's no lbrst.
   // 23:16:             waiting time when request generate to dmc arbitor if there's o lbrst.
   // 15:8:              how many write rsp can hold in the whole dmc pipe lines.
   // 7:0:               how many read data can hold in the whole dmc pipe lines.

#define MMC_REQ1_CTRL             0x638c
#define MMC_REQ2_CTRL             0x6390
#define MMC_REQ3_CTRL             0x6394
#define MMC_REQ4_CTRL             0x6398
#define MMC_REQ5_CTRL             0x639c
#define MMC_REQ6_CTRL             0x63a0
#define MMC_REQ7_CTRL             0x63a4
                                           

#define MMC_REQ_CTRL        0x6400 
#define MMC_SOFT_RST        0x6404
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

#define MMC_RST_STS        0x6408
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

#define MMC_APB3_CTRL             0x640c

#define MMC_CHAN_STS        0x6410
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


#define MMC_CLKG_CNTL0      0x6414
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

#define MMC_CLKG_CNTL1      0x6418
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

#define MMC_CLK_CNTL      0x641c
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
   
#define MMC_DDR_PHY_GPR0   0x6420
#define MMC_DDR_PHY_GPR1   0x6424
#define MMC_LP_CTRL1       0x6428
#define MMC_LP_CTRL2       0x642c
#define MMC_LP_CTRL3       0x6430
#define MMC_PCTL_STAT      0x6434 
#define MMC_CMDZQ_CTRL     0x6438 

#endif


