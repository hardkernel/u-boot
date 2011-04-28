#ifdef DDR_DMC
#else

#define DDR_DMC
#define MMC_DDR_CTRL        0x1000 
#define MMC_REQ_CTRL        0x1004 
#define MMC_ARB_CTRL        0x1008 
#define MMC_ARB_CTRL1       0x100c 

#define MMC_QOS0_CTRL  0x1010
   //bit 31     qos enable.
   //bit 26     1 : danamic change the bandwidth percentage. 0 : fixed bandwidth.  all 64. 
   //bit 25       grant mode. 1 grant clock cycles. 0 grant data cycles.
   //bit 24       leakybucket counter goes to 0. When no req or no other request. 
   //bit 21:16    bankwidth requirement. unit 1/64. 
   //bit 15:0.    after stop the re_enable threadhold.

#define MMC_QOS0_MAX   0x1014
#define MMC_QOS0_MIN   0x1018
#define MMC_QOS0_LIMIT 0x101c
#define MMC_QOS0_STOP  0x1020
#define MMC_QOS1_CTRL  0x1024
#define MMC_QOS1_MAX   0x1028
#define MMC_QOS1_MIN   0x102c
#define MMC_QOS1_STOP  0x1030
#define MMC_QOS1_LIMIT 0x1034
#define MMC_QOS2_CTRL  0x1038
#define MMC_QOS2_MAX   0x103c
#define MMC_QOS2_MIN   0x1040
#define MMC_QOS2_STOP  0x1044
#define MMC_QOS2_LIMIT 0x1048
#define MMC_QOS3_CTRL  0x104c
#define MMC_QOS3_MAX   0x1050
#define MMC_QOS3_MIN   0x1054
#define MMC_QOS3_STOP  0x1058
#define MMC_QOS3_LIMIT 0x105c
#define MMC_QOS4_CTRL  0x1060
#define MMC_QOS4_MAX   0x1064
#define MMC_QOS4_MIN   0x1068
#define MMC_QOS4_STOP  0x106c
#define MMC_QOS4_LIMIT 0x1070
#define MMC_QOS5_CTRL  0x1074
#define MMC_QOS5_MAX   0x1078
#define MMC_QOS5_MIN   0x107c
#define MMC_QOS5_STOP  0x1080
#define MMC_QOS5_LIMIT 0x1084
#define MMC_QOS6_CTRL  0x1088
#define MMC_QOS6_MAX   0x108c
#define MMC_QOS6_MIN   0x1090
#define MMC_QOS6_STOP  0x1094
#define MMC_QOS6_LIMIT 0x1098
#define MMC_QOS7_CTRL  0x109c
#define MMC_QOS7_MAX   0x10a0
#define MMC_QOS7_MIN   0x10a4
#define MMC_QOS7_STOP  0x10a8
#define MMC_QOS7_LIMIT 0x10ac

#define MMC_QOSMON_CTRL     0x10b0
#define MMC_QOSMON_TIM      0x10b4
#define MMC_QOSMON_MST      0x10b8
#define MMC_MON_CLKCNT      0x10bc
#define MMC_ALL_REQCNT      0x10c0
#define MMC_ALL_GANTCNT     0x10c4
#define MMC_ONE_REQCNT      0x10c8
#define MMC_ONE_CYCLE_CNT   0x10cc
#define MMC_ONE_DATA_CNT    0x10d0

#define MMC_CHAN_RST        0x1120
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
#define MMC_CHAN_STS        0x1124
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
#define MMC_CLKG_CNTL0      0x1128
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

#define MMC_CLKG_CNTL1      0x112c
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

#define DC_CAV_CTRL               0x1300

#define DC_CAV_LVL3_GRANT         0x1304
#define DC_CAV_LVL3_GH            0x1308
  // this is a 32 bit grant regsiter.
  // each bit grant a thread ID for LVL3 use.

#define DC_CAV_LVL3_FLIP          0x130c
#define DC_CAV_LVL3_FH            0x1310
  // this is a 32 bit FLIP regsiter.
  // each bit to define  a thread ID for LVL3 use.

#define DC_CAV_LVL3_CTRL0         0x1314
#define DC_CAV_LVL3_CTRL1         0x1318
#define DC_CAV_LVL3_CTRL2         0x131c
#define DC_CAV_LVL3_CTRL3         0x1320
#define DC_CAV_LUT_DATAL          0x1324
    #define CANVAS_ADDR_LMASK       0x1fffffff
    #define CANVAS_WIDTH_LMASK		0x7
    #define CANVAS_WIDTH_LWID		3
    #define CANVAS_WIDTH_LBIT		29
#define DC_CAV_LUT_DATAH          0x1328
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
#define DC_CAV_LUT_ADDR           0x132c
    #define CANVAS_LUT_INDEX_BIT    0
    #define CANVAS_LUT_INDEX_MASK   0x7
    #define CANVAS_LUT_WR_EN        (0x2 << 8)
    #define CANVAS_LUT_RD_EN        (0x1 << 8)
#define DC_CAV_LVL3_MODE          0x1330
#define MMC_PROT_ADDR             0x1334 
#define MMC_PROT_SELH             0x1338 
#define MMC_PROT_SELL             0x133c 
#define MMC_PROT_CTL_STS          0x1340 
#define MMC_INT_STS               0x1344 
#define MMC_PHY_CTRL              0x1380
#define MMC_APB3_CTRL             0x1384

#define MMC_REQ0_CTRL             0x1388
   // bit 31,            request in enable.
   // 30:24:             cmd fifo counter when request generate to dmc arbitor if there's no lbrst.
   // 23:16:             waiting time when request generate to dmc arbitor if there's o lbrst.
   // 15:8:              how many write rsp can hold in the whole dmc pipe lines.
   // 7:0:               how many read data can hold in the whole dmc pipe lines.

#define MMC_REQ1_CTRL             0x138c
#define MMC_REQ2_CTRL             0x1390
#define MMC_REQ3_CTRL             0x1394
#define MMC_REQ4_CTRL             0x1398
#define MMC_REQ5_CTRL             0x139c
#define MMC_REQ6_CTRL             0x13a0
#define MMC_REQ7_CTRL             0x13a4
                                           

#define P_MMC_DDR_CTRL        APB_REG_ADDR(MMC_DDR_CTRL)
#define P_MMC_REQ_CTRL        APB_REG_ADDR(MMC_REQ_CTRL)
#define P_MMC_ARB_CTRL        APB_REG_ADDR(MMC_ARB_CTRL)
#define P_MMC_ARB_CTRL1       APB_REG_ADDR(MMC_ARB_CTRL1)

#define P_MMC_CHAN_RST       APB_REG_ADDR(MMC_CHAN_RST)
#define P_MMC_CHAN_STS       APB_REG_ADDR(MMC_CHAN_STS)
#define P_MMC_INT_STS        APB_REG_ADDR(MMC_INT_STS)
#define P_MMC_PHY_CTRL       APB_REG_ADDR(MMC_PHY_CTRL)

#endif
