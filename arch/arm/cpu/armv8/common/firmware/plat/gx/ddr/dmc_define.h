#define DMC_REG_BASE						0xc8838000

#define DMC_REQ_CTRL						(DMC_REG_BASE + (0x00 <<2 ))
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
#define DMC_SOFT_RST						(DMC_REG_BASE + (0x01 <<2 ))
#define DMC_SOFT_RST1						(DMC_REG_BASE + (0x02 <<2 ))
#define DMC_RST_STS							(DMC_REG_BASE + (0x03 <<2 ))
#define DMC_RST_STS1						(DMC_REG_BASE + (0x04 <<2 ))
#define DMC_VERSION							(DMC_REG_BASE + (0x05 <<2 ))
   //read only default = 1.

#define DMC_RAM_PD							(DMC_REG_BASE + (0x11 <<2 ))

#define DC_CAV_LUT_DATAL					(DMC_REG_BASE + (0x12 <<2 ))
  //low 32 bits of canvas data which need to be configured to canvas memory.
#define DC_CAV_LUT_DATAH					(DMC_REG_BASE + (0x13 <<2 ))
  //high 32bits of cavnas data which need to be configured to canvas memory.
#define DC_CAV_LUT_ADDR 					(DMC_REG_BASE + (0x14 <<2 ))
  //bit 9:8.   write 9:8 2'b10. the canvas data will saved in canvas memory with addres 7:0.
  //bit 7:0.   canvas address.
#define DC_CAV_LUT_RDATAL					(DMC_REG_BASE + (0x15 <<2 ))
#define DC_CAV_LUT_RDATAH					(DMC_REG_BASE + (0x16 <<2 ))
#define DMC_2ARB_CTRL						(DMC_REG_BASE + (0x20 <<2 ))

#define DMC_REFR_CTRL1						(DMC_REG_BASE + (0x23 <<2 ))
  //bit23:16   tRFC waiting time, when hold nif command after refresh.
  //bit 9      after refresh, hold nif command enable
  //bit 8      when refresh req,  hold nif command enable
  //bit 7      dmc to control auto_refresh enable
  //bit 6:4    refresh number per refresh cycle..
  //bit 3      pvt enable
  //bit 2      zqc enable
  //bit 1      ddr1 auto refresh dmc control select.
  //bit 0      ddr0 auto refresh dmc control select.

#define DMC_REFR_CTRL2						(DMC_REG_BASE + (0x24 <<2 ))
  //bit 31:24   tZQCI
  //bit 23:16   tPVTI
  //bit 15:8    tREFI
  //bit 7:0     t100ns

#define DMC_PARB_CTRL						(DMC_REG_BASE + (0x25 <<2 ))
  //bit 17.     default port1(MALI AXI port) urgent bit.
  //bit 16      default port0(A9 AXI port ) urgent bit.
  //bit 15:8    t_ugt_gap.   when the consecutive urgent request granted over the t_ugt_wd times, we allow the number of non urgent request was granted by the port arbiter.
  //bit 7:0.    t_ugt_wd.


#define DMC_MON_CTRL2						(DMC_REG_BASE + (0x26 <<2 ))
   //bit 31.   qos_mon_en.    write 1 to trigger the enable. polling this bit 0, means finished.  or use interrupt to check finish.
   //bit 30.   qos_mon interrupt clear.  clear the qos monitor result.  read 1 = qos mon finish interrupt.
   //bit 20.   qos_mon_trig_sel.  1 = vsync.  0 = timer.
   //bit 19:16.  qos monitor channel select.   select one at one time only.
   //bit 15:0.   port select for the selected channel.
#define DMC_MON_CTRL3						(DMC_REG_BASE + (0x27 <<2 ))
  // qos_mon_clk_timer.   How long to measure the bandwidth.


#define DMC_MON_ALL_REQ_CNT					(DMC_REG_BASE + (0x28 <<2 ))
  // at the test period,  the whole MMC request time.
#define DMC_MON_ALL_GRANT_CNT				(DMC_REG_BASE + (0x29 <<2 ))
  // at the test period,  the whole MMC granted data cycles. 64bits unit.
#define DMC_MON_ONE_GRANT_CNT				(DMC_REG_BASE + (0x2a <<2 ))
  // at the test period,  the granted data cycles for the selected channel and ports.

#define DMC_CLKG_CTRL0						(DMC_REG_BASE + (0x30 <<2 ))
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
#define DMC_CLKG_CTRL1						(DMC_REG_BASE + (0x31 <<2 ))
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

#define DMC_CHAN_STS						(DMC_REG_BASE + (0x32 <<2 ))

#define DMC_CMD_FILTER_CTRL1				(DMC_REG_BASE + (0x40 <<2 ))
   //bit 29:20  nugt read buf full access limit
   //bit 19:10.  ugt read access limit.
   //bit 9:0  nugt read access limit

#define DMC_CMD_FILTER_CTRL2				(DMC_REG_BASE + (0x41 <<2 ))
   //bit 29:20  ugt read buf full access limit
   //bit 9:0  nugt write access pending limit
   //bit 19:10.  ugt write access pending limit.

#define DMC_CMD_FILTER_CTRL3				(DMC_REG_BASE + (0x42 <<2 ))
  //bit 26:22  wbuf high level number
  //bit 21:17  wbuf mid  level number
  //bit 16:12  wbuf low level number
  //bit 11:8   rbuf high level number
  //bit 7:4    rbuf middle level number
  //bit 3:0    rbuf low level number

#define DMC_CMD_FILTER_CTRL4				(DMC_REG_BASE + (0x43 <<2 ))
  //bit 24:20.  tHIT latency.  page hit command latency for next same page not hit command.
  //bit 19:15.  tIDLE latency. page idle command latency for next same page not hit command.
  //bit 14:10.  tMISS latency. page miss command latency for next same page not hit command.
  //bit 9:0.    rbuf idle timer to let the wbuf output.
#define DMC_CMD_FILTER_CTRL5				(DMC_REG_BASE + ( 0x44 << 2))

#define DMC_CMD_BUFFER_CTRL					(DMC_REG_BASE + (0x45 <<2 ))
  //bit 30:25  total write buffer number. default 32.
  //bit 24:20  total read buffer number. default 16.
  //bit 19:10  ugt age limit. over this age limit, this read buffer would turn to super urgent.
  //bit 9:0  nugt age limit. over this age limit, this read buffer would turn to super urgent.
#define DMC_PCTL_LP_CTRL					(DMC_REG_BASE + ( 0x46 << 2))

#define DMC_AM0_CHAN_CTRL					(DMC_REG_BASE + (0x60 <<2 ))
#define DMC_AM0_HOLD_CTRL					(DMC_REG_BASE + (0x61 <<2 ))
#define DMC_AM0_QOS_INC						(DMC_REG_BASE + (0x62 <<2 ))
#define DMC_AM0_QOS_INCBK					(DMC_REG_BASE + (0x63 <<2 ))
#define DMC_AM0_QOS_DEC						(DMC_REG_BASE + (0x64 <<2 ))
#define DMC_AM0_QOS_DECBK					(DMC_REG_BASE + (0x65 <<2 ))
#define DMC_AM0_QOS_DIS						(DMC_REG_BASE + (0x66 <<2 ))
#define DMC_AM0_QOS_DISBK					(DMC_REG_BASE + (0x67 <<2 ))
#define DMC_AM0_QOS_CTRL0					(DMC_REG_BASE + (0x68 <<2 ))
#define DMC_AM0_QOS_CTRL1					(DMC_REG_BASE + (0x69 <<2 ))

#define DMC_AM1_CHAN_CTRL					(DMC_REG_BASE + (0x6a <<2 ))
#define DMC_AM1_HOLD_CTRL					(DMC_REG_BASE + (0x6b <<2 ))
#define DMC_AM1_QOS_INC						(DMC_REG_BASE + (0x6c <<2 ))
#define DMC_AM1_QOS_INCBK					(DMC_REG_BASE + (0x6d <<2 ))
#define DMC_AM1_QOS_DEC						(DMC_REG_BASE + (0x6e <<2 ))
#define DMC_AM1_QOS_DECBK					(DMC_REG_BASE + (0x6f <<2 ))
#define DMC_AM1_QOS_DIS						(DMC_REG_BASE + (0x70 <<2 ))
#define DMC_AM1_QOS_DISBK					(DMC_REG_BASE + (0x71 <<2 ))
#define DMC_AM1_QOS_CTRL0					(DMC_REG_BASE + (0x72 <<2 ))
#define DMC_AM1_QOS_CTRL1					(DMC_REG_BASE + (0x73 <<2 ))

#define DMC_AM2_CHAN_CTRL					(DMC_REG_BASE + (0x74 <<2 ))
#define DMC_AM2_HOLD_CTRL					(DMC_REG_BASE + (0x75 <<2 ))
#define DMC_AM2_QOS_INC						(DMC_REG_BASE + (0x76 <<2 ))
#define DMC_AM2_QOS_INCBK					(DMC_REG_BASE + (0x77 <<2 ))
#define DMC_AM2_QOS_DEC						(DMC_REG_BASE + (0x78 <<2 ))
#define DMC_AM2_QOS_DECBK					(DMC_REG_BASE + (0x79 <<2 ))
#define DMC_AM2_QOS_DIS						(DMC_REG_BASE + (0x7a <<2 ))
#define DMC_AM2_QOS_DISBK					(DMC_REG_BASE + (0x7b <<2 ))
#define DMC_AM2_QOS_CTRL0					(DMC_REG_BASE + (0x7c <<2 ))
#define DMC_AM2_QOS_CTRL1					(DMC_REG_BASE + (0x7d <<2 ))

#define DMC_AM3_CHAN_CTRL					(DMC_REG_BASE + (0x7e <<2 ))
#define DMC_AM3_HOLD_CTRL					(DMC_REG_BASE + (0x7f <<2 ))
#define DMC_AM3_QOS_INC						(DMC_REG_BASE + (0x80 <<2 ))
#define DMC_AM3_QOS_INCBK					(DMC_REG_BASE + (0x81 <<2 ))
#define DMC_AM3_QOS_DEC						(DMC_REG_BASE + (0x82 <<2 ))
#define DMC_AM3_QOS_DECBK					(DMC_REG_BASE + (0x83 <<2 ))
#define DMC_AM3_QOS_DIS						(DMC_REG_BASE + (0x84 <<2 ))
#define DMC_AM3_QOS_DISBK					(DMC_REG_BASE + (0x85 <<2 ))
#define DMC_AM3_QOS_CTRL0					(DMC_REG_BASE + (0x86 <<2 ))
#define DMC_AM3_QOS_CTRL1					(DMC_REG_BASE + (0x87 <<2 ))

#define DMC_AM4_CHAN_CTRL					(DMC_REG_BASE + (0x88 <<2 ))
#define DMC_AM4_HOLD_CTRL					(DMC_REG_BASE + (0x89 <<2 ))
#define DMC_AM4_QOS_INC						(DMC_REG_BASE + (0x8a <<2 ))
#define DMC_AM4_QOS_INCBK					(DMC_REG_BASE + (0x8b <<2 ))
#define DMC_AM4_QOS_DEC						(DMC_REG_BASE + (0x8c <<2 ))
#define DMC_AM4_QOS_DECBK					(DMC_REG_BASE + (0x8d <<2 ))
#define DMC_AM4_QOS_DIS						(DMC_REG_BASE + (0x8e <<2 ))
#define DMC_AM4_QOS_DISBK					(DMC_REG_BASE + (0x8f <<2 ))
#define DMC_AM4_QOS_CTRL0					(DMC_REG_BASE + (0x90 <<2 ))
#define DMC_AM4_QOS_CTRL1					(DMC_REG_BASE + (0x91 <<2 ))

#define DMC_AM5_CHAN_CTRL					(DMC_REG_BASE + (0x92 <<2 ))
#define DMC_AM5_HOLD_CTRL					(DMC_REG_BASE + (0x93 <<2 ))
#define DMC_AM5_QOS_INC						(DMC_REG_BASE + (0x94 <<2 ))
#define DMC_AM5_QOS_INCBK					(DMC_REG_BASE + (0x95 <<2 ))
#define DMC_AM5_QOS_DEC						(DMC_REG_BASE + (0x96 <<2 ))
#define DMC_AM5_QOS_DECBK					(DMC_REG_BASE + (0x97 <<2 ))
#define DMC_AM5_QOS_DIS						(DMC_REG_BASE + (0x98 <<2 ))
#define DMC_AM5_QOS_DISBK					(DMC_REG_BASE + (0x99 <<2 ))
#define DMC_AM5_QOS_CTRL0					(DMC_REG_BASE + (0x9a <<2 ))
#define DMC_AM5_QOS_CTRL1					(DMC_REG_BASE + (0x9b <<2 ))

#define DMC_AM6_CHAN_CTRL					(DMC_REG_BASE + (0x9c <<2 ))
#define DMC_AM6_HOLD_CTRL					(DMC_REG_BASE + (0x9d <<2 ))
#define DMC_AM6_QOS_INC						(DMC_REG_BASE + (0x9e <<2 ))
#define DMC_AM6_QOS_INCBK					(DMC_REG_BASE + (0x9f <<2 ))
#define DMC_AM6_QOS_DEC						(DMC_REG_BASE + (0xa0 <<2 ))
#define DMC_AM6_QOS_DECBK					(DMC_REG_BASE + (0xa1 <<2 ))
#define DMC_AM6_QOS_DIS						(DMC_REG_BASE + (0xa2 <<2 ))
#define DMC_AM6_QOS_DISBK					(DMC_REG_BASE + (0xa3 <<2 ))
#define DMC_AM6_QOS_CTRL0					(DMC_REG_BASE + (0xa4 <<2 ))
#define DMC_AM6_QOS_CTRL1					(DMC_REG_BASE + (0xa5 <<2 ))

#define DMC_AM7_CHAN_CTRL					(DMC_REG_BASE + (0xa6 <<2 ))
#define DMC_AM7_HOLD_CTRL					(DMC_REG_BASE + (0xa7 <<2 ))
#define DMC_AM7_QOS_INC						(DMC_REG_BASE + (0xa8 <<2 ))
#define DMC_AM7_QOS_INCBK					(DMC_REG_BASE + (0xa9 <<2 ))
#define DMC_AM7_QOS_DEC						(DMC_REG_BASE + (0xaa <<2 ))
#define DMC_AM7_QOS_DECBK					(DMC_REG_BASE + (0xab <<2 ))
#define DMC_AM7_QOS_DIS						(DMC_REG_BASE + (0xac <<2 ))
#define DMC_AM7_QOS_DISBK					(DMC_REG_BASE + (0xad <<2 ))
#define DMC_AM7_QOS_CTRL0					(DMC_REG_BASE + (0xae <<2 ))
#define DMC_AM7_QOS_CTRL1					(DMC_REG_BASE + (0xaf <<2 ))

#define DMC_AXI0_CHAN_CTRL					(DMC_REG_BASE + (0xb0 <<2 ))
#define DMC_AXI0_HOLD_CTRL					(DMC_REG_BASE + (0xb1 <<2 ))
#define DMC_AXI0_QOS_INC					(DMC_REG_BASE + (0xb2 <<2 ))
#define DMC_AXI0_QOS_INCBK					(DMC_REG_BASE + (0xb3 <<2 ))
#define DMC_AXI0_QOS_DEC					(DMC_REG_BASE + (0xb4 <<2 ))
#define DMC_AXI0_QOS_DECBK					(DMC_REG_BASE + (0xb5 <<2 ))
#define DMC_AXI0_QOS_DIS					(DMC_REG_BASE + (0xb6 <<2 ))
#define DMC_AXI0_QOS_DISBK					(DMC_REG_BASE + (0xb7 <<2 ))
#define DMC_AXI0_QOS_CTRL0					(DMC_REG_BASE + (0xb8 <<2 ))
#define DMC_AXI0_QOS_CTRL1					(DMC_REG_BASE + (0xb9 <<2 ))

#define DMC_AXI1_CHAN_CTRL					(DMC_REG_BASE + (0xba <<2 ))
#define DMC_AXI1_HOLD_CTRL					(DMC_REG_BASE + (0xbb <<2 ))
#define DMC_AXI1_QOS_INC					(DMC_REG_BASE + (0xbc <<2 ))
#define DMC_AXI1_QOS_INCBK					(DMC_REG_BASE + (0xbd <<2 ))
#define DMC_AXI1_QOS_DEC					(DMC_REG_BASE + (0xbe <<2 ))
#define DMC_AXI1_QOS_DECBK					(DMC_REG_BASE + (0xbf <<2 ))
#define DMC_AXI1_QOS_DIS					(DMC_REG_BASE + (0xc0 <<2 ))
#define DMC_AXI1_QOS_DISBK					(DMC_REG_BASE + (0xc1 <<2 ))
#define DMC_AXI1_QOS_CTRL0					(DMC_REG_BASE + (0xc2 <<2 ))
#define DMC_AXI1_QOS_CTRL1					(DMC_REG_BASE + (0xc3 <<2 ))

#define DMC_AXI2_CHAN_CTRL					(DMC_REG_BASE + (0xc4 <<2 ))
#define DMC_AXI2_HOLD_CTRL					(DMC_REG_BASE + (0xc5 <<2 ))
#define DMC_AXI2_QOS_INC					(DMC_REG_BASE + (0xc6 <<2 ))
#define DMC_AXI2_QOS_INCBK					(DMC_REG_BASE + (0xc7 <<2 ))
#define DMC_AXI2_QOS_DEC					(DMC_REG_BASE + (0xc8 <<2 ))
#define DMC_AXI2_QOS_DECBK					(DMC_REG_BASE + (0xc9 <<2 ))
#define DMC_AXI2_QOS_DIS					(DMC_REG_BASE + (0xca <<2 ))
#define DMC_AXI2_QOS_DISBK					(DMC_REG_BASE + (0xcb <<2 ))
#define DMC_AXI2_QOS_CTRL0					(DMC_REG_BASE + (0xcc <<2 ))
#define DMC_AXI2_QOS_CTRL1					(DMC_REG_BASE + (0xcd <<2 ))

#define DMC_AXI3_CHAN_CTRL					(DMC_REG_BASE + (0xce <<2 ))
#define DMC_AXI3_HOLD_CTRL					(DMC_REG_BASE + (0xcf <<2 ))
#define DMC_AXI3_QOS_INC					(DMC_REG_BASE + (0xd0 <<2 ))
#define DMC_AXI3_QOS_INCBK					(DMC_REG_BASE + (0xd1 <<2 ))
#define DMC_AXI3_QOS_DEC					(DMC_REG_BASE + (0xd2 <<2 ))
#define DMC_AXI3_QOS_DECBK					(DMC_REG_BASE + (0xd3 <<2 ))
#define DMC_AXI3_QOS_DIS					(DMC_REG_BASE + (0xd4 <<2 ))
#define DMC_AXI3_QOS_DISBK					(DMC_REG_BASE + (0xd5 <<2 ))
#define DMC_AXI3_QOS_CTRL0					(DMC_REG_BASE + (0xd6 <<2 ))
#define DMC_AXI3_QOS_CTRL1					(DMC_REG_BASE + (0xd7 <<2 ))

#define DMC_AXI4_CHAN_CTRL					(DMC_REG_BASE + (0xd8 <<2 ))
#define DMC_AXI4_HOLD_CTRL					(DMC_REG_BASE + (0xd9 <<2 ))
#define DMC_AXI4_QOS_INC					(DMC_REG_BASE + (0xda <<2 ))
#define DMC_AXI4_QOS_INCBK					(DMC_REG_BASE + (0xdb <<2 ))
#define DMC_AXI4_QOS_DEC					(DMC_REG_BASE + (0xdc <<2 ))
#define DMC_AXI4_QOS_DECBK					(DMC_REG_BASE + (0xdd <<2 ))
#define DMC_AXI4_QOS_DIS					(DMC_REG_BASE + (0xde <<2 ))
#define DMC_AXI4_QOS_DISBK					(DMC_REG_BASE + (0xdf <<2 ))
#define DMC_AXI4_QOS_CTRL0					(DMC_REG_BASE + (0xe0 <<2 ))
#define DMC_AXI4_QOS_CTRL1					(DMC_REG_BASE + (0xe1 <<2 ))

#define DMC_AXI5_CHAN_CTRL					(DMC_REG_BASE + (0xe2 <<2 ))
#define DMC_AXI5_HOLD_CTRL					(DMC_REG_BASE + (0xe3 <<2 ))
#define DMC_AXI5_QOS_INC					(DMC_REG_BASE + (0xe4 <<2 ))
#define DMC_AXI5_QOS_INCBK					(DMC_REG_BASE + (0xe5 <<2 ))
#define DMC_AXI5_QOS_DEC					(DMC_REG_BASE + (0xe6 <<2 ))
#define DMC_AXI5_QOS_DECBK					(DMC_REG_BASE + (0xe7 <<2 ))
#define DMC_AXI5_QOS_DIS					(DMC_REG_BASE + (0xe8 <<2 ))
#define DMC_AXI5_QOS_DISBK					(DMC_REG_BASE + (0xe9 <<2 ))
#define DMC_AXI5_QOS_CTRL0					(DMC_REG_BASE + (0xea <<2 ))
#define DMC_AXI5_QOS_CTRL1					(DMC_REG_BASE + (0xeb <<2 ))

#define DMC_AXI6_CHAN_CTRL					(DMC_REG_BASE + (0xec <<2 ))
#define DMC_AXI6_HOLD_CTRL					(DMC_REG_BASE + (0xed <<2 ))
#define DMC_AXI6_QOS_INC					(DMC_REG_BASE + (0xee <<2 ))
#define DMC_AXI6_QOS_INCBK					(DMC_REG_BASE + (0xef <<2 ))
#define DMC_AXI6_QOS_DEC					(DMC_REG_BASE + (0xf0 <<2 ))
#define DMC_AXI6_QOS_DECBK					(DMC_REG_BASE + (0xf1 <<2 ))
#define DMC_AXI6_QOS_DIS					(DMC_REG_BASE + (0xf2 <<2 ))
#define DMC_AXI6_QOS_DISBK					(DMC_REG_BASE + (0xf3 <<2 ))
#define DMC_AXI6_QOS_CTRL0					(DMC_REG_BASE + (0xf4 <<2 ))
#define DMC_AXI6_QOS_CTRL1					(DMC_REG_BASE + (0xf5 <<2 ))

#define DMC_AXI7_CHAN_CTRL					(DMC_REG_BASE + (0xf6 <<2 ))
#define DMC_AXI7_HOLD_CTRL					(DMC_REG_BASE + (0xf7 <<2 ))
#define DMC_AXI7_QOS_INC					(DMC_REG_BASE + (0xf8 <<2 ))
#define DMC_AXI7_QOS_INCBK					(DMC_REG_BASE + (0xf9 <<2 ))
#define DMC_AXI7_QOS_DEC					(DMC_REG_BASE + (0xfa <<2 ))
#define DMC_AXI7_QOS_DECBK					(DMC_REG_BASE + (0xfb <<2 ))
#define DMC_AXI7_QOS_DIS					(DMC_REG_BASE + (0xfc <<2 ))
#define DMC_AXI7_QOS_DISBK					(DMC_REG_BASE + (0xfd <<2 ))
#define DMC_AXI7_QOS_CTRL0					(DMC_REG_BASE + (0xfe <<2 ))
#define DMC_AXI7_QOS_CTRL1					(DMC_REG_BASE + (0xff <<2 ))

