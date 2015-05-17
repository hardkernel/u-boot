
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/ddr/sec_mmc_define.h
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

#define DMC_SEC_REG_BASE					0xda838400
#define DMC_SEC_CTRL						(DMC_SEC_REG_BASE + (0x00  <<2))

  //security range defination have to be atom option.  all the range controll register  will be shadowed.
  //write bit 31 to 1 to update the setting in shadow register to be used.
#define DMC_SEC_RANGE0_CTRL					(DMC_SEC_REG_BASE + (0x01      <<2))
  //bit 31:16   :   range 0 end address  higher 16bits.
  //bit 15:0    :   range 0 start address higher 16bits.
#define DMC_SEC_RANGE1_CTRL					(DMC_SEC_REG_BASE + (0x02      <<2))
  //bit 31:16   :   range 1 end address  higher 16bits.
  //bit 15:0    :   range 1 start address higher 16bits.
#define DMC_SEC_RANGE2_CTRL					(DMC_SEC_REG_BASE + (0x03      <<2))
  //bit 31:16   :   range 2 end address  higher 16bits.
  //bit 15:0    :   range 2 start address higher 16bits.
#define DMC_SEC_RANGE3_CTRL					(DMC_SEC_REG_BASE + (0x04      <<2))
  //bit 31:16   :   range 3 end address  higher 16bits.
  //bit 15:0    :   range 3 start address higher 16bits.
#define DMC_SEC_RANGE4_CTRL					(DMC_SEC_REG_BASE + (0x05      <<2))
  //bit 31:16   :   range 4 end address  higher 16bits.
  //bit 15:0    :   range 4 start address higher 16bits.
#define DMC_SEC_RANGE5_CTRL					(DMC_SEC_REG_BASE + (0x06      <<2))
  //bit 31:16   :   range 5 end address  higher 16bits.
  //bit 15:0    :   range 5 start address higher 16bits.
#define DMC_SEC_RANGE_CTRL					(DMC_SEC_REG_BASE + (0x07      <<2))
  //bit 31:7   :  not used
  //bit 6 :  default range security level.     1 : secure region. 0 : non secure region.
  //bit 5 :  range 5 security level. 1 : secure region. 0 : non secure region.
  //bit 4 :  range 4 security level. 1 : secure region. 0 : non secure region.
  //bit 3 :  range 3 security level. 1 : secure region. 0 : non secure region.
  //bit 2 :  range 2 security level. 1 : secure region. 0 : non secure region.
  //bit 1 :  range 1 security level. 1 : secure region. 0 : non secure region.
  //bit 0 :  range 0 security level. 1 : secure region. 0 : non secure region.

#define DMC_SEC_AXI_PORT_CTRL				(DMC_SEC_REG_BASE + (0x0e <<2))
  //bit 31~24.   not used.
  //bit 23. AXI port3 (HDCP )  secure region write access enable bit. 1: enable. 0 : disable.
  //bit 22. AXI port3 (HDCP )  non secure region write access enable bit.  1: enable.  0 : disable.
  //bit 21. AXI port2 (Mali 1) secure region write access enable bit. 1: enable. 0 : disable.
  //bit 20. AXI port2 (Mali 1) non secure region write access enable bit.  1: enable.  0 : disable.
  //bit 19. AXI port1 (Mali 0) secure region write access enable bit. 1: enable. 0 : disable.
  //bit 18. AXI port1 (Mali 0) non secure region write access enable bit.  1: enable.  0 : disable.
  //bit 17. AXI port0 (CPU)    secure region write access enable bit. 1: enable. 0 : disable.
  //bit 16. AXI port0 (CPU)    non secure region write access enable bit.  1: enable.  0 : disable.
  //bit 15~8.   not used.
  //bit 7. AXI port3 (HDCP )  secure region read access enable bit. 1: enable. 0 : disable.
  //bit 6. AXI port3 (HDCP )  non secure region read access enable bit.  1: enable.  0 : disable.
  //bit 5. AXI port2 (Mali 1) secure region read access enable bit. 1: enable. 0 : disable.
  //bit 4. AXI port2 (Mali 1) non secure region read access enable bit.  1: enable.  0 : disable.
  //bit 3. AXI port1 (Mali 0) secure region read access enable bit. 1: enable. 0 : disable.
  //bit 2. AXI port1 (Mali 0) non secure region read access enable bit.  1: enable.  0 : disable.
  //bit 1. AXI port0 (CPU)    secure region read access enable bit. 1: enable. 0 : disable.
  //bit 0. AXI port0 (CPU)    non secure region read access enable bit.  1: enable.  0 : disable.

#define DMC_VDEC_SEC_READ_CTRL				(DMC_SEC_REG_BASE + (0x10 <<2))
  //bit 31.  VDEC subID14 ( not used  )      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 30.  VDEC subID14 ( not used )  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 29.  VDEC subID14 ( not used  )      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 28.  VDEC subID14 ( not used )  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 27.  VDEC subID13 ( not used  )      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 26.  VDEC subID13 ( not used )  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 25.  VDEC subID12 ( not used  )      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 24.  VDEC subID12 ( not used )  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 23.  VDEC subID11 ( not used  )      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 22.  VDEC subID11 ( not used )  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 21.  VDEC subID10 ( mbbot )      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 20.  VDEC subID10 ( mbbot )  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 19.  VDEC subID9 ( not used.)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 18.  VDEC subID9 ( not used)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 17.  VDEC subID8 ( not used.)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 16.  VDEC subID8 ( not used)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 15.  VDEC subID7 (dw)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 14.  VDEC subID7 (dw)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 13.  VDEC subID6 (comb)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 12.  VDEC subID6 (comb)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 11.  VDEC subID5 (lmem)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 10.  VDEC subID5 (lmem)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 9.   VDEC subID4 (imem)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 8.   VDEC subID4 (imem)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 7.   VDEC subID3 (picdc)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 6.   VDEC subID3 (picdc)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 5.   VDEC subID2 (psc)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 4.   VDEC subID2 (psc)  non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 3.   VDEC subID1 (dcac)     secure region read access enable bit. 1: enable. 0 : disable.
  //bit 2.   VDEC subID1 (dcac) non secure region read access enable bit. 1: enable. 0 : disable.
  //bit 1.   VDEC subID0 (vld)      secure region read access enable bit. 1: enable. 0 : disable.
  //bit 0.   VDEC subID0 (vld)  non secure region read access enable bit. 1: enable. 0 : disable.
#define DMC_VDEC_SEC_WRITE_CTRL				(DMC_SEC_REG_BASE + (0x11 <<2))
  //bit 31.  VDEC subID14 ( not used  )      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 30.  VDEC subID14 ( not used )  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 29.  VDEC subID14 ( not used  )      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 28.  VDEC subID14 ( not used )  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 27.  VDEC subID13 ( not used  )      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 26.  VDEC subID13 ( not used )  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 25.  VDEC subID12 ( not used  )      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 24.  VDEC subID12 ( not used )  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 23.  VDEC subID11 ( not used  )      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 22.  VDEC subID11 ( not used )  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 21.  VDEC subID10 ( mbbot )      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 20.  VDEC subID10 ( mbbot )  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 19.  VDEC subID9 ( not used.)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 18.  VDEC subID9 ( not used)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 17.  VDEC subID8 ( not used.)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 16.  VDEC subID8 ( not used)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 15.  VDEC subID7 (dw)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 14.  VDEC subID7 (dw)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 13.  VDEC subID6 (comb)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 12.  VDEC subID6 (comb)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 11.  VDEC subID5 (lmem)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 10.  VDEC subID5 (lmem)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 9.   VDEC subID4 (imem)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 8.   VDEC subID4 (imem)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 7.   VDEC subID3 (picdc)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 6.   VDEC subID3 (picdc)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 5.   VDEC subID2 (psc)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 4.   VDEC subID2 (psc)  non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 3.   VDEC subID1 (dcac)     secure region write access enable bit. 1: enable. 0 : disable.
  //bit 2.   VDEC subID1 (dcac) non secure region write access enable bit. 1: enable. 0 : disable.
  //bit 1.   VDEC subID0 (vld)      secure region write access enable bit. 1: enable. 0 : disable.
  //bit 0.   VDEC subID0 (vld)  non secure region write access enable bit. 1: enable. 0 : disable.
#define DMC_VDEC_SEC_CFG					(DMC_SEC_REG_BASE + (0x12 <<2))
 //DWC_VDEC_SEC_READ_CTRL and DMC_VDEC_SEC_WRITE_CTRL register APB bus configuation enable.  2 bit for each port.  one for read, one for write.
  //bit 31.  VDEC subID15 ()  To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 30.  VDEC subID14 ()  To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 29.  VDEC subID13 ()  To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 28.  VDEC subID12 ()  To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 27.  VDEC subID11 ()  To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 26.  VDEC subID10 (mbbot)  To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 25.   VDEC subID9 ()        To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 24.   VDEC subID8 ()        To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 23.   VDEC subID7 (dw)      To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 22.   VDEC subID6 (comb)    To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 21.   VDEC subID5 (lmem)    To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 20.   VDEC subID4 (imem)    To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 19.   VDEC subID3 (picdc)   To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 18.   VDEC subID2 (psc)     To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 17.   VDEC subID1 (dcac)    To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 16.   VDEC subID0 (vld)     To enable APB bus modifiy the write security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 15.  VDEC subID15 ()  To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 14.  VDEC subID14 ()  To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 13.  VDEC subID13 ()  To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 12.  VDEC subID12 ()  To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 11.  VDEC subID11 ()  To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 10.  VDEC subID10 (mbbot)  To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 9.   VDEC subID9 ()        To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 8.   VDEC subID8 ()        To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 7.   VDEC subID7 (dw)      To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 6.   VDEC subID6 (comb)    To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 5.   VDEC subID5 (lmem)    To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 4.   VDEC subID4 (imem)    To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 3.   VDEC subID3 (picdc)   To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 2.   VDEC subID2 (psc)     To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 1.   VDEC subID1 (dcac)    To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.
  //bit 0.   VDEC subID0 (vld)     To enable APB bus modifiy the read security control bits. 1 : eable the APB modify. 0 : disable APB bus modify.

#define DMC_VDEC_EF_TRIG_CTRL				(DMC_SEC_REG_BASE + (0x13 <<2))
  // VDEC Electronic fence trigger selection and trigger secure type.  1 bit for trigger select for one read port. 1 bit for trigger type for one read port.
  //Electronic would be triggered by the read from  defined secure level from selected subIDs.
  //bit 31.   trigger type selection for subID15 ().  1 = secure access. 0 : non secure access.
  //bit 30.   trigger type selection for subID14 ().  1 = secure access. 0 : non secure access.
  //bit 29.   trigger type selection for subID13 ().  1 = secure access. 0 : non secure access.
  //bit 28.   trigger type selection for subID12 ().  1 = secure access. 0 : non secure access.
  //bit 27.   trigger type selection for subID11 ().  1 = secure access. 0 : non secure access.
  //bit 26.   trigger type selection for subID10 ().  1 = secure access. 0 : non secure access.
  //bit 25.   trigger type selection for subID9 ().  1 = secure access. 0 : non secure access.
  //bit 24.   trigger type selection for subID8 ().  1 = secure access. 0 : non secure access.
  //bit 23.   trigger type selection for subID7 (dw).  1 = secure access. 0 : non secure access.
  //bit 22.   trigger type selection for subID6 (comb).  1 = secure access. 0 : non secure access.
  //bit 21.   trigger type selection for subID5 (lmem).  1 = secure access. 0 : non secure access.
  //bit 20.   trigger type selection for subID4 (imem).  1 = secure access. 0 : non secure access.
  //bit 19.   trigger type selection for subID3 (picdc).  1 = secure access. 0 : non secure access.
  //bit 18.   trigger type selection for subID2 (psc).  1 = secure access. 0 : non secure access.
  //bit 17.   trigger type selection for subID1 (dcac).  1 = secure access. 0 : non secure access.
  //bit 16.   trigger type selection for subID0 (vld).  1 = secure access. 0 : non secure access.
  //bit 15.   trigger source selection for subID15 ().  1 = selected. 0 : not selected.
  //bit 14.   trigger source selection for subID14 ().  1 = selected. 0 : not selected.
  //bit 13.   trigger source selection for subID13 ().  1 = selected. 0 : not selected.
  //bit 12.   trigger source selection for subID12 ().  1 = selected. 0 : not selected.
  //bit 11.   trigger source selection for subID11 ().  1 = selected. 0 : not selected.
  //bit 10.   trigger source selection for subID10 ().  1 = selected. 0 : not selected.
  //bit 9.    trigger source selection for subID9 ().  1 = selected. 0 : not selected.
  //bit 8.    trigger source selection for subID8 ().  1 = selected. 0 : not selected.
  //bit 7.    trigger source selection for subID7 (dw).  1 = selected. 0 : not selected.
  //bit 6.    trigger source selection for subID6 (comb).  1 = selected. 0 : not selected.
  //bit 5.    trigger source selection for subID5 (lmem).  1 = selected. 0 : not selected.
  //bit 4.    trigger source selection for subID4 (imem).  1 = selected. 0 : not selected.
  //bit 3.    trigger source selection for subID3 (picdc).  1 = selected. 0 : not selected.
  //bit 2.    trigger source selection for subID2 (psc).  1 = selected. 0 : not selected.
  //bit 1.    trigger source selection for subID1 (dcac).  1 = selected. 0 : not selected.
  //bit 0.    trigger source selection for subID0 (vld).  1 = selected. 0 : not selected.

#define DMC_VDEC_EF_PROT					(DMC_SEC_REG_BASE + (0x14 <<2))
  //to define which subID would be affected if the EF got triggered.
  //bit 31.   EF would affect subID15 () write access secure control.  1 = selected. 0 : not selected.
  //bit 30.   EF would affect subID14 () write access secure control.  1 = selected. 0 : not selected.
  //bit 29.   EF would affect subID13 () write access secure control.  1 = selected. 0 : not selected.
  //bit 28.   EF would affect subID12 () write access secure control.  1 = selected. 0 : not selected.
  //bit 27.   EF would affect subID11 () write access secure control.  1 = selected. 0 : not selected.
  //bit 26.   EF would affect subID10 () write access secure control.  1 = selected. 0 : not selected.
  //bit 25.    EF would affect subID9 () write access secure control.  1 = selected. 0 : not selected.
  //bit 24.    EF would affect subID8 () write access secure control.  1 = selected. 0 : not selected.
  //bit 23.    EF would affect subID7 (dw) write access secure control.  1 = selected. 0 : not selected.
  //bit 22.    EF would affect subID6 (comb) write access secure control.  1 = selected. 0 : not selected.
  //bit 21.    EF would affect subID5 (lmem) write access secure control.  1 = selected. 0 : not selected.
  //bit 20.    EF would affect subID4 (imem) write access secure control.  1 = selected. 0 : not selected.
  //bit 19.    EF would affect subID3 (picdc) write access secure control.  1 = selected. 0 : not selected.
  //bit 18.    EF would affect subID2 (psc) write access secure control.  1 = selected. 0 : not selected.
  //bit 17.    EF would affect subID1 (dcac) write access secure control.  1 = selected. 0 : not selected.
  //bit 16.    EF would affect subID0 (vld) write access secure control.  1 = selected. 0 : not selected.
  //bit 15.   EF would affect subID15 () read access secure control.  1 = selected. 0 : not selected.
  //bit 14.   EF would affect subID14 () read access secure control.  1 = selected. 0 : not selected.
  //bit 13.   EF would affect subID13 () read access secure control.  1 = selected. 0 : not selected.
  //bit 12.   EF would affect subID12 () read access secure control.  1 = selected. 0 : not selected.
  //bit 11.   EF would affect subID11 () read access secure control.  1 = selected. 0 : not selected.
  //bit 10.   EF would affect subID10 () read access secure control.  1 = selected. 0 : not selected.
  //bit 9.    EF would affect subID9 () read access secure control.  1 = selected. 0 : not selected.
  //bit 8.    EF would affect subID8 () read access secure control.  1 = selected. 0 : not selected.
  //bit 7.    EF would affect subID7 (dw) read access secure control.  1 = selected. 0 : not selected.
  //bit 6.    EF would affect subID6 (comb) read access secure control.  1 = selected. 0 : not selected.
  //bit 5.    EF would affect subID5 (lmem) read access secure control.  1 = selected. 0 : not selected.
  //bit 4.    EF would affect subID4 (imem) read access secure control.  1 = selected. 0 : not selected.
  //bit 3.    EF would affect subID3 (picdc) read access secure control.  1 = selected. 0 : not selected.
  //bit 2.    EF would affect subID2 (psc) read access secure control.  1 = selected. 0 : not selected.
  //bit 1.    EF would affect subID1 (dcac) read access secure control.  1 = selected. 0 : not selected.
  //bit 0.    EF would affect subID0 (vld) read access secure control.  1 = selected. 0 : not selected.
#define DMC_VDEC_EF_READ					(DMC_SEC_REG_BASE + (0x15 <<2))
  //this register contains the vdec read security control bits after the EF got triggered.
  //if the DMC_VDEC_EF_PROT register bit 15:0 related bit was enable,  then the related secure control bits would be copied to DMC_VDEC_SEC_READ_CTRL related bits.

#define DMC_VDEC_EF_WRITE					(DMC_SEC_REG_BASE + (0x16 <<2))
  //this register contains the vdec write security control bits after the EF got triggered.
  //if the DMC_VDEC_EF_PROT register bit 15:0 related bit was enable,  then the related secure control bits would be copied to DMC_VDEC_SEC_READ_CTRL related bits.

 //HCODEC security and Electronic fence is same as VDEC with different SUBID define..
  //subID15:13 :  not used.
  //subID12 :  ME.
  //subID11 : mfdin
  //subID10 : mcmbot
  //subID9  : i_pred.
  //subID8  : qdct
  //subID7  : vlc
  //subID6  : comb
  //subID5  : LMEM
  //subID4  : IMEM.
  //subID3  : mcrcc
  //subID2  : PSC
  //subID1  : dcac
  //subID0  : vld
#define DMC_HCODEC_SEC_READ_CTRL			(DMC_SEC_REG_BASE + (0x17 <<2))
 //each subID with 2bits. one for secure region. one for unsecure region.

#define DMC_HCODEC_SEC_WRITE_CTRL			(DMC_SEC_REG_BASE + (0x18 <<2))
 //each subID with 2bits. one for secure region. one for unsecure region.

#define DMC_HCODEC_SEC_CFG					(DMC_SEC_REG_BASE + (0x19 <<2))
 //DWC_HCODEC_SEC_READ_CTRL and DMC_HCODEC_SEC_WRITE_CTRL register APB bus configuation enable.  2 bit for each port.  one for read, one for write.

#define DMC_HCODEC_EF_TRIG_CTRL				(DMC_SEC_REG_BASE + (0x1a <<2))
  // HCODEC Electronic fence trigger selection and trigger secure type.  1 bit for trigger select for one read port. 1 bit for trigger type for one read port.

#define DMC_HCODEC_EF_PROT					(DMC_SEC_REG_BASE + (0x1b <<2))
  // HCODEC EF protected access control.  each subID 2 bits. one for read one for write.
#define DMC_HCODEC_EF_READ					(DMC_SEC_REG_BASE + (0x1c <<2))
  //the DWC_HCODEC_SEC_READ_CTRL value need to be changed after HCODEC EF fence triggered. once the trigger happens, the DMC_HCODEC_EF_PROT[15:0] bit enabled subIDs value will be copied to   DWC_HCODEC_SEC_READ_CTRL register.
#define DMC_HCODEC_EF_WRITE					(DMC_SEC_REG_BASE + (0x1d <<2))
  //the DWC_HCODEC_SEC_WRITE_CTRL value need to be changed after HCODEC EF fence triggered. once the trigger happens, the DMC_HCODEC_EF_PROT[31:16] bit enabled subIDs value will be copied to   DWC_HCODEC_SEC_WRITE_CTRL register.

//HEVC security and electronic fence control is similar with VDEC/HCODE.  only difference is in HEVC, the LMEM/IMEM are shared in one SUBID. so we need to have seperate seting for them.
  //subID 7 : mpred.
  //subID 6 : dblk_d
  //subID 5 : dblk_p
  //subID 4 : ipp
  //subID 3 : mpp
  //subID 2 : SAO
  //subID 1 : stream.
  //subID 0 : AMRISC CPU.  include IMEM and LMEM.  AR/WID[3:0] == 0 IMEM.  LMEM.
  //HEVC ID 7.  [6:4] for subID.
#define DMC_HEVC_SEC_READ_CTRL				(DMC_SEC_REG_BASE + (0x1e <<2))
   //bit 31:18. not used.
   //bit 17. READ secure area eable bit for HEVC subID0 CPU with IDbits 3:0 != 4'h0 read access.      1 : enable. 0 : disable.
   //bit 16. READ non secure area eable bit for HEVC subID 0 CPU with IDbits 3:0 != 4'h0 read access.  1 : enable. 0 : disable.
   //bit 15. READ secure area eable bit for HEVC subID 7 mpred read access.      1 : enable. 0 : disable.
   //bit 14. READ non secure area eable bit for HEVC subID 7  mpred read access.  1 : enable. 0 : disable.
   //bit 13. READ secure area eable bit for HEVC subID 6 dblk_d read access.      1 : enable. 0 : disable.
   //bit 12. READ non secure area eable bit for HEVC subID 6  dblk_d read access.  1 : enable. 0 : disable.
   //bit 11. READ secure area eable bit for HEVC subID 5 dblk_p read access.      1 : enable. 0 : disable.
   //bit 10. READ non secure area eable bit for HEVC subID 5  dblk_p read access.  1 : enable. 0 : disable.
   //bit 9.  READ secure area eable bit for HEVC subID 4 ipp read access.      1 : enable. 0 : disable.
   //bit 8.  READ non secure area eable bit for HEVC subID 4  ipp read access.  1 : enable. 0 : disable.
   //bit 7.  READ secure area eable bit for HEVC subID 3 mpp read access.      1 : enable. 0 : disable.
   //bit 6.  READ non secure area eable bit for HEVC subID 3  mpp read access.  1 : enable. 0 : disable.
   //bit 5.  READ secure area eable bit for HEVC subID 2 SAO read access.      1 : enable. 0 : disable.
   //bit 4.  READ non secure area eable bit for HEVC subID 2  SAO read access.  1 : enable. 0 : disable.
   //bit 3.  READ secure area eable bit for HEVCsubID 1  stream read access.      1 : enable. 0 : disable.
   //bit 2.  READ non secure area eable bit for HEVC subID 1  stream read access.  1 : enable. 0 : disable.
   //bit 1.  READ secure area eable bit for HEVC CPU access with ID bit 3:0 = 4'h0.  1 : enable. 0 : disable.
   //bit 0.  READ non secure area eable bit for HEVC CPU access with ID bit 3:0 = 4'h0.  1 : enable. 0 : disable.

#define DMC_HEVC_SEC_WRITE_CTRL				(DMC_SEC_REG_BASE + (0x1f <<2))
   //bit 31:18. not used.
   //bit 17. WRITE secure area eable bit for HEVC subID0 CPU with IDbits[7:4] == 4'h1 write access.      1 : enable. 0 : disable.
   //bit 16. WRITE non secure area eable bit for HEVC subID 0 CPU IDbits[7:4] == 4'h1 write access.  1 : enable. 0 : disable.
   //bit 15. WRITE secure area eable bit for HEVC subID  [7:5] ==7 mpred write access.      1 : enable. 0 : disable.
   //bit 14. WRITE non secure area eable bit for HEVC subID 7  mpred write access.  1 : enable. 0 : disable.
   //bit 13. WRITE secure area eable bit for HEVC subID [7:5] == 6 dblk_d write access.      1 : enable. 0 : disable.
   //bit 12. WRITE non secure area eable bit for HEVC subID [7:5] == 6  dblk_d write access.  1 : enable. 0 : disable.
   //bit 11. WRITE secure area eable bit for HEVC subID [7:5] == 5 dblk_p write access.      1 : enable. 0 : disable.
   //bit 10. WRITE non secure area eable bit for HEVC subID [7:5] == 5  dblk_p write access.  1 : enable. 0 : disable.
   //bit 9.  WRITE secure area eable bit for HEVC subID [7:5] == 4 ipp write access.      1 : enable. 0 : disable.
   //bit 8.  WRITE non secure area eable bit for HEVC subID [7:5] == 4  ipp write access.  1 : enable. 0 : disable.
   //bit 7.  WRITE secure area eable bit for HEVC subID [7:5] == 3 mpp write access.      1 : enable. 0 : disable.
   //bit 6.  WRITE non secure area eable bit for HEVC subID [7:5] == 3  mpp write access.  1 : enable. 0 : disable.
   //bit 5.  WRITE secure area eable bit for HEVC subID [7:5] == 2 SAO write access.      1 : enable. 0 : disable.
   //bit 4.  WRITE non secure area eable bit for HEVC subID 2  SAO write access.  1 : enable. 0 : disable.
   //bit 3.  WRITE secure area eable bit for HEVCsubID [7:5] == 1  stream write access.      1 : enable. 0 : disable.
   //bit 2.  WRITE non secure area eable bit for HEVC subID [7:5] == 1  stream write access.  1 : enable. 0 : disable.
   //bit 1.  WRITE secure area eable bit for HEVC CPU access with ID bit 7 :4 = 4'h0.  1 : enable. 0 : disable.
   //bit 0.  WRITE non secure area eable bit for HEVC CPU access with ID bit 7:4 = 4'h0.  1 : enable. 0 : disable.

#define DMC_HEVC_SEC_CFG					(DMC_SEC_REG_BASE + (0x20 <<2))
  //24:16  9 CBUS modfiy enable bit for 9 write secure cotnrol SUBIDs
  // 8:0.  9 CBUS modify enable bit for 9 READ secure control SUBIDs.
#define DMC_HEVC_EF_TRIG_CTRL				(DMC_SEC_REG_BASE + (0x21 <<2))
  //bit 24:16. 9 HEVC EF trigger selection type for 9 SUBID read access.
  //bit 8:0.  9 HEVC EF trigger selection for 9 SUBID read acess.

#define DMC_HEVC_EF_PROT					(DMC_SEC_REG_BASE + (0x22 <<2))
  //bit 24:16.   9 HEVC EF controlled write subID selection.
  //bit 8:0.   9 HEVC EF controlled  read subIDs selection.

#define DMC_HEVC_EF_READ					(DMC_SEC_REG_BASE + (0x23 <<2))
 //bit 17:0.   DWC_HEVC_SEC_READ_CTRL value need to be changed after HEVC EF fence triggered.
#define DMC_HEVC_EF_WRITE					(DMC_SEC_REG_BASE + (0x24 <<2))
 //bit 17:0.   DWC_HEVC_SEC_WRITE_CTRL value need to be changed after HEVC EF fence triggered.



//there are upto 16 read subID inside VPU and dynamic allocated 3 VPU read ports.
//there are upto 16 write subIDs insdie VPU and dynamic allocated 2 VPU write ports
//there are 3 electronic fences for VPU domain. we can allocated any of those 16 read ports as the trigger of the 3 EF.
//the 3 EF also can control any of those read ports and write ports security levels.
//the Software should make sure there's no conflit setting between these 3 EFs.
#define DMC_VPU_SEC_READ_CTRL				(DMC_SEC_REG_BASE + (0x32 <<2))
//bit 31:0.  each read subID have 2 bits securty control.  one is for seucre area access. one is for unsecure aread access.

#define DMC_VPU_SEC_WRITE_CTRL				(DMC_SEC_REG_BASE + (0x33 <<2))
//bit 31:0.  each write subID have 2 bits securty control.  one is for seucre area access. one is for unsecure aread access.

#define DMC_VPU_SEC_CFG						(DMC_SEC_REG_BASE + (0x25 <<2))
 //31:16  enable APB bus configure VPU write SubIDs security contrl register DMC_VPU_SEC_WRITE_CTRL.
 //15:0  enable APB bus configure for VPU read SubIDs security control register. DMC_VPU_SEC_READ_CTRL
#define DMC_VPU_EF0_TRIG_CTRL				(DMC_SEC_REG_BASE + (0x26 <<2))
  //31:16. VPU EF0 trigger selection read source type.
  //15:0.  VPU EF0 trigger selection read source select.
#define DMC_VPU_EF0_PROT					(DMC_SEC_REG_BASE + (0x27 <<2))
  //bit 24:16.  16 VPU EF0 controlled  write subIDs selection.
  //bit 15:0.   16 VPU EF0 controlled  read subIDs selection.
#define DMC_VPU_EF0_READ					(DMC_SEC_REG_BASE + (0x28 <<2))
  //EF0 controlled DMC_VPU_SEC_READ_CTRL.
#define DMC_VPU_EF0_WRITE					(DMC_SEC_REG_BASE + (0x29 <<2))
  //EF0 controlled DMC_VPU_SEC_WRITE_CTRL.

#define DMC_VPU_EF1_TRIG_CTRL				(DMC_SEC_REG_BASE + (0x2a <<2))
  //31:16. VPU EF1 trigger selection read source type.
  //15:0.  VPU EF1 trigger selection read source select.
#define DMC_VPU_EF1_PROT					(DMC_SEC_REG_BASE + (0x2b <<2))
  //bit 24:16.  16 VPU EF1 controlled  write subIDs selection.
  //bit 15:0.   16 VPU EF1 controlled  read subIDs selection.
#define DMC_VPU_EF1_READ					(DMC_SEC_REG_BASE + (0x2c <<2))
  //EF1 controlled DMC_VPU_SEC_READ_CTRL.
#define DMC_VPU_EF1_WRITE					(DMC_SEC_REG_BASE + (0x2d <<2))
  //EF1 controlled DMC_VPU_SEC_WRITE_CTRL.
#define DMC_VPU_EF2_TRIG_CTRL				(DMC_SEC_REG_BASE + (0x2e <<2))
  //31:16. VPU EF2 trigger selection read source type.
  //15:0.  VPU EF2 trigger selection read source select.
#define DMC_VPU_EF2_PROT					(DMC_SEC_REG_BASE + (0x2f <<2))
  //bit 24:16.  16 VPU EF2 controlled  write subIDs selection.
  //bit 15:0.   16 VPU EF2 controlled  read subIDs selection.
#define DMC_VPU_EF2_READ					(DMC_SEC_REG_BASE + (0x30 <<2))
  //EF2 controlled DMC_VPU_SEC_READ_CTRL.
#define DMC_VPU_EF2_WRITE					(DMC_SEC_REG_BASE + (0x31 <<2))
  //EF2 controlled DMC_VPU_SEC_WRITE_CTRL.

 //GE2D is seperated port in GX.
#define DMC_GE2D_SEC_CTRL					(DMC_SEC_REG_BASE + (0x34 <<2))
  //bit 31:22 NOT USED.
  //bit 21:16.  GE2D secure control after EF triggered.
  //bit 14:12   GE2D EF proection selection after EF triggered..
  //bit 11:10   GE2D Electronic fence  trigger  read source secure type selection.
  //bit 9:8   GE2D Electronic fence  trigger  read source selection.
  //bit 5:4.  GE2D write destination 2 secruity control bits.
  //bit 3:2.  GE2D read source 2 secruity control bits.
  //bit 1:0.  GE2D read source 1 secruity control bits.

#define DMC_PARSER_SEC_CTRL					(DMC_SEC_REG_BASE + (0x35 <<2))
  //bit 11:8.  Pasrese write and read security contrl bits after EF triggered.
  //bit 7:6.  Parser EF trigger protection enable.
  //bit 5.    Parser EF trigger read source type.
  //bit 4     Pasrer EF trigger read source enable.
  //bit 3:2.  Parser write security control bits.
  //bit 1:0.  Parser read security control bits.
#define DMC_DEV_SEC_READ_CTRL				(DMC_SEC_REG_BASE + (0x36 <<2))
  //16 device subID read access security control bits.  each subID 2 bits.
#define DMC_DEV_SEC_WRITE_CTRL				(DMC_SEC_REG_BASE + (0x37 <<2))
  //16 device subID write access security control bits.  each subID 2 bits.


//2 DES key one for secure region and one for non-secure region.
#define DMC_DES_KEY0_H						(DMC_SEC_REG_BASE + (0x90 <<2))
#define DMC_DES_KEY0_L						(DMC_SEC_REG_BASE + (0x91 <<2))
  //64bits data descrable key for security level 0 ( DES key)

#define DMC_DES_KEY1_H						(DMC_SEC_REG_BASE + (0x92 <<2))
#define DMC_DES_KEY1_L						(DMC_SEC_REG_BASE + (0x93 <<2))
  //64bits data descrable key for security level 1( DES key)

#define DMC_DES_PADDING						(DMC_SEC_REG_BASE + (0x9a <<2))
  //32bits address padding used for DES data generation.

#define DMC_CA_REMAP_L						(DMC_SEC_REG_BASE + (0x9b <<2))
#define DMC_CA_REMAP_H						(DMC_SEC_REG_BASE + (0x9c <<2))
  //This is a 16x4 address remap look up table.
  //the column address bit 7:4 would be the index input and be replace with the value stored in these register.
  //{DMC_CA_REMAP_H, DMC_CA_REMAP_L}
  //bit 63:60: new address for index 15
  //bit 59:56: new address for index 14
  //bit 55:52: new address for index 13
  //bit 51:48: new address for index 12
  //bit 47:44: new address for index 11
  //bit 43:40: new address for index 10
  //bit 39:36: new address for index 9
  //bit 35:32: new address for index 8
  //bit 31:28: new address for index 7
  //bit 27:24: new address for index 6
  //bit 23:20: new address for index 5
  //bit 19:16: new address for index 4
  //bit 15:12: new address for index 3
  //bit 11:8: new address for index 2
  //bit 7:4: new address for index 1
  //bit 3:0: new address for index 0


// two range protection function.
#define DMC_PROT0_RANGE						(DMC_SEC_REG_BASE + (0xa0           <<2))
  //protection 0 address range. the range define is 64Kbyte boundary.  current address [31:16] >= start address && current address [31:16] <= end address.
  //bit 31:16 :   range end address.
  //bit 15:0  :   range start address
#define DMC_PROT0_CTRL						(DMC_SEC_REG_BASE + (0xa1           <<2))
  //bit 19.  protection 0 for write access enable bit.
  //bit 18.  protection 0 for read access enable bit.
  //bit 17.  protection 0  write access block function. if enabled, the access wouldn't write to the DDR SDRAM.  if not enabled only generate a interrupt, but the access still wrote to DDR.
 //bit 16. not used.
 //bit 15:0  each bit to enable one of the 15 channel input for the protection function.

#define DMC_PROT1_RANGE						(DMC_SEC_REG_BASE + (0xa2           <<2))
  //protection 1 address range. the range define is 64Kbyte boundary.  current address [31:16] >= start address && current address [31:16] <= end address.
  //bit 31:16 :   range end address.
  //bit 15:0  :   range start address
#define DMC_PROT1_CTRL						(DMC_SEC_REG_BASE + (0xa3           <<2))
  //bit 19.  protection 1 for write access enable bit.
  //bit 18.  protection 1 for read access enable bit.
  //bit 17.  protection 1  write access block function. if enabled, the access wouldn't write to the DDR SDRAM.  if not enabled only generate a interrupt, but the access still wrote to DDR.
//two data point
#define DMC_WTCH0_D0						(DMC_SEC_REG_BASE + (0xa4 <<2))
  //WTCH0 will watch upto 128bits data access.
#define DMC_WTCH0_D1						(DMC_SEC_REG_BASE + (0xa5 <<2))
#define DMC_WTCH0_D2						(DMC_SEC_REG_BASE + (0xa6 <<2))
#define DMC_WTCH0_D3						(DMC_SEC_REG_BASE + (0xa7 <<2))
  // the watch point 0 data {d3, d2,d1,d0}
#define DMC_WTCH0_RANGE						(DMC_SEC_REG_BASE + (0xa8 <<2))
  //address range. 64Kbyte boundary.
  // 31:16  start address high 16.
  // 15:0  start address high 16.
#define DMC_WTCH0_CTRL						(DMC_SEC_REG_BASE + (0xa9 <<2))
  //bit 31:16.  16bits write data strb.
  //bit 15:0.   16bits input channels select.
#define DMC_WTCH0_CTRL1						(DMC_SEC_REG_BASE + (0xaa <<2))
  //bit 2. watch point 0 enable.
  //bit 1:0. watch point0 type.   2'b00 : double bytes. only watchpoint data 15:0 and data strb 1:0 is valid. 2'b01: 4 bytes.  2'b10: 8 bytes. 2'b11, all 16bytes.

#define DMC_WTCH1_D0						(DMC_SEC_REG_BASE + (0xab <<2))
#define DMC_WTCH1_D1						(DMC_SEC_REG_BASE + (0xac <<2))
#define DMC_WTCH1_D2						(DMC_SEC_REG_BASE + (0xad <<2))
#define DMC_WTCH1_D3						(DMC_SEC_REG_BASE + (0xae <<2))
  // the watch point 1 data {d3, d2,d1,d0}
#define DMC_WTCH1_RANGE						(DMC_SEC_REG_BASE + (0xaf <<2))
  //address range. 64Kbyte boundary.
  // 31:16  start address high 16.
  // 15:0  start address high 16.
#define DMC_WTCH1_CTRL						(DMC_SEC_REG_BASE + (0xb0 <<2))
  //bit 31:16.  16bits write data strb.
  //bit 15:0.   16bits input channels select.
#define DMC_WTCH1_CTRL1						(DMC_SEC_REG_BASE + (0xb1 <<2))
  //bit 2. watch point 0 enable.
  //bit 1:0. watch point0 type.   2'b00 : double bytes. only watchpoint data 15:0 and data strb 1:0 is valid. 2'b01: 4 bytes.  2'b10: 8 bytes. 2'b11, all 16bytes.


//trap function: all the enable the port ID read access or enable PORT ID and subID read access must be in the predefine range. otherwire the read access would be blocked.
// and an error will be generated.
#define DMC_TRAP0_RANGE						(DMC_SEC_REG_BASE + (0xb2 <<2))
  // address trap0 range register.
  //31:16.  trap0  end address
  //15:0    start0 address.
#define DMC_TRAP0_CTRL						(DMC_SEC_REG_BASE + (0xb3 <<2))
  //bit 30 trap0 port ID 2 enable.
  //bit 29 trap0 port ID 1 enable.
  //bit 28 trap0 port ID 0 enable.
  //bit 27 trap0 port ID 2 subid enable.
  //bit 26 trap0 port ID 1 subid enable.
  //bit 25 trap0 port ID 0 subid enable.
  //bit 23:20. trap0 port port ID 2  channel ID number.
  //bit 19:16. trap0 port port ID 2  subID ID number.
  //bit 15:12. trap0 port ID 1 ID number.
  //bit 11:8.  trap0 port ID 1 subID ID number.
  //bit 7:4.   trap0 port ID 0 ID number.
  //bit 3:0.   trap0 port ID 0 subID ID number.

#define DMC_TRAP1_RANGE						(DMC_SEC_REG_BASE + (0xb4 <<2))
  //address trap range register.
  //31:16.  trap end address
  //15:0    start address.
#define DMC_TRAP1_CTRL						(DMC_SEC_REG_BASE + (0xb5 <<2))
  //bit 30 trap1 port ID 2 enable.
  //bit 29 trap1 port ID 1 enable.
  //bit 28 trap1 port ID 0 enable.
  //bit 27 trap1 port ID 2 subid enable.
  //bit 26 trap1 port ID 1 subid enable.
  //bit 25 trap1 port ID 0 subid enable.
  //bit 23:20. trap1 port port ID 2  channel ID number.
  //bit 19:16. trap1 port port ID 2  subID ID number.
  //bit 15:12. trap1 port ID 1 ID number.
  //bit 11:8.  trap1 port ID 1 subID ID number.
  //bit 7:4.   trap1 port ID 0 ID number.
  //bit 3:0.   trap1 port ID 0 subID ID number.



//registers to check the security protection and watch point error information.
#define DMC_SEC_STATUS						(DMC_SEC_REG_BASE + (0xb6 <<2))

#define DMC_VIO_ADDR0						(DMC_SEC_REG_BASE + (0xb7 <<2))
  //ddr0 write secure violation address.
#define DMC_VIO_ADDR1						(DMC_SEC_REG_BASE + (0xb8 <<2))
  //22     secure check violation.
  //21     protection 1 vilation.
  //20     protection 0 vilation.
   //19:18. not use.d
  //17     ddr0 write address overflow. write out of DDR size.
  //16:14. ddr0 write violation AWPROT bits.
  //13:0   ddr0_write violation ID.
#define DMC_VIO_ADDR2						(DMC_SEC_REG_BASE + (0xb9 <<2))
  //ddr1 write seure violation address
#define DMC_VIO_ADDR3						(DMC_SEC_REG_BASE + (0xba <<2))
  //22     ddr1 write secure check violation.
  //21     ddr1 write protection 1 vilation.
  //20     ddr1 write protection 0 vilation.
  //19     ddr1 watch 1 catch
  //18.    ddr1 watch 0 catch.
  //17     ddr1 write address overflow. write out of DDR size.
  //16:14. ddr1 write violation AWPROT bits.
  //13:0   ddr1_write violation ID.

#define DMC_VIO_ADDR4						(DMC_SEC_REG_BASE + (0xbb <<2))
  //ddr0 read seure violation address
#define DMC_VIO_ADDR5						(DMC_SEC_REG_BASE + (0xbc <<2))
  //22     ddr0 read secure check violation.
  //21     ddr0 read protection 1 violation.
  //20     ddr0 read protection 0 violation.
  //19     ddr0 read trap1 violation
  //18     ddr0 read trap0 violation
  //17     ddr 0 read address overflow. write out of DDR size.
  //16:14. ddr 0 read violation ARPROT bits.
  //13:0   ddr 0 read violation ID.

#define DMC_VIO_ADDR6						(DMC_SEC_REG_BASE + (0xbd <<2))
  //ddr1 read seure violation address

#define DMC_VIO_ADDR7						(DMC_SEC_REG_BASE + (0xbe <<2))
  //22     ddr1 read secure check violation.
  //21     ddr1 read protection 1 violation.
  //20     ddr1 read protection 0 violation.
  //19     ddr1 read trap1 violation
  //18     ddr1 read trap0 violation
  //17     ddr 1 read address overflow. write out of DDR size.
  //16:14. ddr 1 read violation ARPROT bits.
  //13:0   ddr 1 read violation ID.


//each row bank and rank address can be selected from any address.
#define DDR0_ADDRMAP_4						(DMC_SEC_REG_BASE + (0xd4 <<2))
  //29:25 rank select.
  //24:20 ba3    //for bank group or 16banks..
  //19:15 ba2.
  //14:10 ba1.
  //9:5   ba0.
  //4:0   ra15.
#define DDR0_ADDRMAP_3						(DMC_SEC_REG_BASE + (0xd3 <<2))
  //29:25 ra14.
  //24:20 ra13.
  //19:15 ra12.
  //14:10 ra11.
  //9:5   ra10.
  //4:0   ra9.
#define DDR0_ADDRMAP_2						(DMC_SEC_REG_BASE + (0xd2 <<2))
  //29:25 ra8.
  //24:20 ra7.
  //19:15 ra6.
  //14:10 ra5.
  //9:5   ra4.
  //4:0   ra3.
#define DDR0_ADDRMAP_1						(DMC_SEC_REG_BASE + (0xd1 <<2))
  //29:25 ra2.
  //24:20 ra1.
  //19:15 ra0.
  //14:10 ca11.
  //9:5   ca10.
  //4:0   ca9.

#define DDR0_ADDRMAP_0						(DMC_SEC_REG_BASE + (0xd0 <<2))
  //29:25 ca8.
  //24:20 ca7.
  //19:15 ca6.
  //14:10 ca5.
  //9:5   ca4.
  //4:0   ca3.

#define DDR1_ADDRMAP_4						(DMC_SEC_REG_BASE + (0xd9 <<2))
  //29:25 rank select.
  //24:20 ba3    //for bank group or 16banks..
  //19:15 ba2.
  //14:10 ba1.
  //9:5   ba0.
  //4:0   ra15.
#define DDR1_ADDRMAP_3						(DMC_SEC_REG_BASE + (0xd8 <<2))
  //29:25 ra14.
  //24:20 ra13.
  //19:15 ra12.
  //14:10 ra11.
  //9:5   ra10.
  //4:0   ra9.
#define DDR1_ADDRMAP_2						(DMC_SEC_REG_BASE + (0xd7 <<2))
  //29:25 ra8.
  //24:20 ra7.
  //19:15 ra6.
  //14:10 ra5.
  //9:5   ra4.
  //4:0   ra3.
#define DDR1_ADDRMAP_1						(DMC_SEC_REG_BASE + (0xd6 <<2))
  //29:25 ra2.
  //24:20 ra1.
  //19:15 ra0.
  //14:10 ca11.
  //9:5   ca10.
  //4:0   ca9.
#define DDR1_ADDRMAP_0						(DMC_SEC_REG_BASE + (0xd5 <<2))
  //29:25 ca8.
  //24:20 ca7.
  //19:15 ca6.
  //14:10 ca5.
  //9:5   ca4.
  //4:0   ca3.


#define DMC_DDR_CTRL 						(DMC_SEC_REG_BASE + (0xda <<2))
  //bit 22.  rank1 is same as rank0.  only in not shared-AC mdoe. and chan0 second rank not selected. that's means still in rank0 32bits mode.
  //bit 21.  channel0 second rank selection enable. only in not shared-AC mode.
  //bit 20.  Shared AC mode.
  //bit 19 :18 must be 0 always. becasue we'll use 32bits PHY data.
  //bit 19:    DDR channel 1 16bits data interface. 1 : 16bits data inteface. 0 : 32bits data interface
  //bit 18:    DDR channel 0 16bits data interface. 1 : 16bits data inteface. 0 : 32bits data interface

  //bit 17:     for DDR channel 1. 1: only use 16bits data in a 32bits phy data interface. 0: normal 32bits data interface.
  //bit 16.     for DDR channel 0. 1: only use 16bits data in a 32bits phy data interface. 0: normal 32bits data interface.
  //bit 10:8 channel bit selection in shared range.
  //bit 7.  DDR1_ONLY.  1: DDR channel 1 only. when both channel 0 and 1 in the design. 0 : normal.
  //bit 6.  DDR0_ONLY.  1: DDR channel 0 only. when both channel 0 and 1 in the design. 0 : normal.
  //bit 5:3 :  DDR channel 1 size.
     //3'b000 : DDR channel 1 is 128MB.
     //3'b001 : DDR channel 1 is 256MB.
     //3'b010 : DDR channel 1 is 512MB.
     //3'b011 : DDR channel 1 is 1GB.
     //3'b100 : DDR channel 1 is 2GB.
     //3'b101 : DDR channel 1 is 4GB.
     //others :  reserved.
  //bit 2:0  :  DDR channel 0 size.
     //3'b000 : DDR channel 0 is 128MB.
     //3'b001 : DDR channel 0 is 256MB.
     //3'b010 : DDR channel 0 is 512MB.
     //3'b011 : DDR channel 0 is 1GB.
     //3'b100 : DDR channel 0 is 2GB.
     //3'b101 : DDR channel 0 is 4GB.
     //others :  reserved.