
/*
 * drivers/net/aml_eth_reg.h
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

#ifndef __AML_ETH_REG_H__
#define __AML_ETH_REG_H__
#include <asm/arch/eth_setup.h>
#define ETH_DMA_0_Bus_Mode                      (ETH_BASE + 0x1000)
#define ETH_DMA_1_Tr_Poll_Demand                (ETH_BASE + 0x1004)
#define ETH_DMA_2_Re_Poll_Demand                (ETH_BASE + 0x1008)
#define ETH_DMA_3_Re_Descriptor_List_Addr       (ETH_BASE + 0x100C)
#define ETH_DMA_4_Tr_Descriptor_List_Addr       (ETH_BASE + 0x1010)
#define ETH_DMA_5_Status                        (ETH_BASE + 0x1014)
#define ETH_DMA_6_Operation_Mode                (ETH_BASE + 0x1018)
#define ETH_DMA_7_Interrupt_Enable              (ETH_BASE + 0x101C)
#define ETH_DMA_8_Missed_Frame_and_Overflow     (ETH_BASE + 0x1020)
#define ETH_DMA_9_Reserved                      (ETH_BASE + 0x1024)
#define ETH_DMA_10_Reserved                     (ETH_BASE + 0x1028)
#define ETH_DMA_11_Reserved                     (ETH_BASE + 0x102c)
#define ETH_DMA_12_Reserved                     (ETH_BASE + 0x1030)
#define ETH_DMA_13_Reserved                     (ETH_BASE + 0x1034)
#define ETH_DMA_14_Reserved                     (ETH_BASE + 0x1038)
#define ETH_DMA_15_Reserved                     (ETH_BASE + 0x103c)
#define ETH_DMA_16_Reserved                     (ETH_BASE + 0x1040)
#define ETH_DMA_17_Reserved                     (ETH_BASE + 0x1044)
#define ETH_DMA_18_Curr_Host_Tr_Descriptor      (ETH_BASE + 0x1048)
#define ETH_DMA_19_Curr_Host_Re_Descriptor      (ETH_BASE + 0x104C)
#define ETH_DMA_20_Curr_Host_Tr_Buffer_Addr     (ETH_BASE + 0x1050)
#define ETH_DMA_21_Curr_Host_Re_Buffer_Addr     (ETH_BASE + 0x1054)
#define ETH_MAC_0_Configuration                 (ETH_BASE + 0x0000)
#define ETH_MAC_1_Frame_Filter                  (ETH_BASE + 0x0004)
#define ETH_MAC_2_Hash_Table_High               (ETH_BASE + 0x0008)
#define ETH_MAC_3_Hash_Table_Low                (ETH_BASE + 0x000C)
#define ETH_MAC_4_GMII_Addr                     (ETH_BASE + 0x0010)
#define ETH_MAC_5_GMII_Data                     (ETH_BASE + 0x0014)
#define ETH_MAC_6_Flow_Control                  (ETH_BASE + 0x0018)
#define ETH_MAC_7_VLAN_Tag                      (ETH_BASE + 0x001C)
#define ETH_MAC_8_Version                       (ETH_BASE + 0x0020)
#define ETH_MAC_9_Reserved                      (ETH_BASE + 0x0024)
#define ETH_MAC_Remote_Wake_Up_Frame_Filter     (ETH_BASE + 0x0028)
#define ETH_MAC_PMT_Control_and_Status          (ETH_BASE + 0x002C)
#define ETH_MAC_12_Reserved                     (ETH_BASE + 0x0030)
#define ETH_MAC_13_Reserved                     (ETH_BASE + 0x0034)
#define ETH_MAC_Interrupt                       (ETH_BASE + 0x0038)
#define ETH_MAC_Interrupt_Mask                  (ETH_BASE + 0x003C)
#define ETH_MAC_Addr0_High                      (ETH_BASE + 0x0040)
#define ETH_MAC_Addr0_Low                       (ETH_BASE + 0x0044)
#define ETH_MAC_Addr1_High                      (ETH_BASE + 0x0048)
#define ETH_MAC_Addr1_Low                       (ETH_BASE + 0x004C)
#define ETH_MAC_Addr2_High                      (ETH_BASE + 0x0050)
#define ETH_MAC_Addr2_Low                       (ETH_BASE + 0x0054)
#define ETH_MAC_Addr3_High                      (ETH_BASE + 0x0058)
#define ETH_MAC_Addr3_Low                       (ETH_BASE + 0x005C)
#define ETH_MAC_Addr4_High                      (ETH_BASE + 0x0060)
#define ETH_MAC_Addr4_Low                       (ETH_BASE + 0x0064)
#define ETH_MAC_Addr5_High                      (ETH_BASE + 0x0068)
#define ETH_MAC_Addr5_Low                       (ETH_BASE + 0x006C)
#define ETH_MAC_Addr6_High                      (ETH_BASE + 0x0070)
#define ETH_MAC_Addr6_Low                       (ETH_BASE + 0x0074)
#define ETH_MAC_Addr7_High                      (ETH_BASE + 0x0078)
#define ETH_MAC_Addr7_Low                       (ETH_BASE + 0x007C)
#define ETH_MAC_Addr8_High                      (ETH_BASE + 0x0080)
#define ETH_MAC_Addr8_Low                       (ETH_BASE + 0x0084)
#define ETH_MAC_Addr9_High                      (ETH_BASE + 0x0088)
#define ETH_MAC_Addr9_Low                       (ETH_BASE + 0x008C)
#define ETH_MAC_Addr10_High                     (ETH_BASE + 0x0090)
#define ETH_MAC_Addr10_Low                      (ETH_BASE + 0x0094)
#define ETH_MAC_Addr11_High                     (ETH_BASE + 0x0098)
#define ETH_MAC_Addr11_Low                      (ETH_BASE + 0x009C)
#define ETH_MAC_Addr12_High                     (ETH_BASE + 0x00A0)
#define ETH_MAC_Addr12_Low                      (ETH_BASE + 0x00A4)
#define ETH_MAC_Addr13_High                     (ETH_BASE + 0x00A8)
#define ETH_MAC_Addr13_Low                      (ETH_BASE + 0x00AC)
#define ETH_MAC_Addr14_High                     (ETH_BASE + 0x00B0)
#define ETH_MAC_Addr14_Low                      (ETH_BASE + 0x00B4)
#define ETH_MAC_Addr15_High                     (ETH_BASE + 0x00B8)
#define ETH_MAC_Addr15_Low                      (ETH_BASE + 0x00BC)
#define ETH_MAC_48_AN_Control                   (ETH_BASE + 0x00C0)
#define ETH_MAC_49_AN_Status                    (ETH_BASE + 0x00C4)
#define ETH_MAC_50_AN_Advertisement             (ETH_BASE + 0x00C8)
#define ETH_MAC_51_AN_Link_Partner_Ability      (ETH_BASE + 0x00CC)
#define ETH_MAC_52_AN_Expansion                 (ETH_BASE + 0x00D0)
#define ETH_MAC_53_TBI_Extended_Status          (ETH_BASE + 0x00D4)
#define ETH_MAC_54_SGMII_RGMII_Status           (ETH_BASE + 0x00D8)
#define ETH_MAC_55_Reserved                     (ETH_BASE + 0x00DC)
#define ETH_MAC_56_Reserved                     (ETH_BASE + 0x00E0)
#define ETH_MAC_57_Reserved                     (ETH_BASE + 0x00E4)
#define ETH_MAC_58_Reserved                     (ETH_BASE + 0x00E8)
#define ETH_MAC_59_Reserved                     (ETH_BASE + 0x00EC)
#define ETH_MAC_60_Reserved                     (ETH_BASE + 0x00F0)
#define ETH_MAC_61_Reserved                     (ETH_BASE + 0x00F4)
#define ETH_MAC_62_Reserved                     (ETH_BASE + 0x00F8)
#define ETH_MAC_63_Reserved                     (ETH_BASE + 0x00FC)
#define ETH_MMC_cntrl                           (ETH_BASE + 0x0100)
#define ETH_MMC_intr_rx                         (ETH_BASE + 0x0104)
#define ETH_MMC_intr_tx                         (ETH_BASE + 0x0108)
#define ETH_MMC_intr_mask_rx                    (ETH_BASE + 0x010C)
#define ETH_MMC_intr_mask_tx                    (ETH_BASE + 0x0110)
#define ETH_MMC_txoctetcount_gb                 (ETH_BASE + 0x0114)
#define ETH_MMC_txframecount_gb                 (ETH_BASE + 0x0118)
#define ETH_MMC_txbroadcastframes_g             (ETH_BASE + 0x011C)
#define ETH_MMC_txmulticastframes_g             (ETH_BASE + 0x0120)
#define ETH_MMC_tx64octets_gb                   (ETH_BASE + 0x0124)
#define ETH_MMC_tx65to127octets_gb              (ETH_BASE + 0x0128)
#define ETH_MMC_tx128to255octets_gb             (ETH_BASE + 0x012C)
#define ETH_MMC_tx256to511octets_gb             (ETH_BASE + 0x0130)
#define ETH_MMC_tx512to1023octets_gb            (ETH_BASE + 0x0134)
#define ETH_MMC_tx1024tomaxoctets_gb            (ETH_BASE + 0x0138)
#define ETH_MMC_txunicastframes_gb              (ETH_BASE + 0x013C)
#define ETH_MMC_txmulticastframes_gb            (ETH_BASE + 0x0140)
#define ETH_MMC_txbroadcastframes_gb            (ETH_BASE + 0x0144)
#define ETH_MMC_txunderflowerror                (ETH_BASE + 0x0148)
#define ETH_MMC_txsinglecol_g                   (ETH_BASE + 0x014C)
#define ETH_MMC_txmulticol_g                    (ETH_BASE + 0x0150)
#define ETH_MMC_txdeferred                      (ETH_BASE + 0x0154)
#define ETH_MMC_txlatecol                       (ETH_BASE + 0x0158)
#define ETH_MMC_txexesscol                      (ETH_BASE + 0x015C)
#define ETH_MMC_txcarriererror                  (ETH_BASE + 0x0160)
#define ETH_MMC_txoctetcount_g                  (ETH_BASE + 0x0164)
#define ETH_MMC_txframecount_g                  (ETH_BASE + 0x0168)
#define ETH_MMC_txexcessdef                     (ETH_BASE + 0x016C)
#define ETH_MMC_txpauseframes                   (ETH_BASE + 0x0170)
#define ETH_MMC_txvlanframes_g                  (ETH_BASE + 0x0174)
#define ETH_MMC_94_Reserved                     (ETH_BASE + 0x0178)
#define ETH_MMC_95_Reserved                     (ETH_BASE + 0x017C)
#define ETH_MMC_rxframecount_gb                 (ETH_BASE + 0x0180)
#define ETH_MMC_rxoctetcount_gb                 (ETH_BASE + 0x0184)
#define ETH_MMC_rxoctetcount_g                  (ETH_BASE + 0x0188)
#define ETH_MMC_rxbroadcastframes_g             (ETH_BASE + 0x018C)
#define ETH_MMC_rxmulticastframes_g             (ETH_BASE + 0x0190)
#define ETH_MMC_rxcrcerror                      (ETH_BASE + 0x0194)
#define ETH_MMC_rxalignmenterror                (ETH_BASE + 0x0198)
#define ETH_MMC_rxrunterror                     (ETH_BASE + 0x019C)
#define ETH_MMC_rxjabbererror                   (ETH_BASE + 0x01A0)
#define ETH_MMC_rxundersize_g                   (ETH_BASE + 0x01A4)
#define ETH_MMC_rxoversize_g                    (ETH_BASE + 0x01A8)
#define ETH_MMC_rx64octets_gb                   (ETH_BASE + 0x01AC)
#define ETH_MMC_rx65to127octets_gb              (ETH_BASE + 0x01B0)
#define ETH_MMC_rx128to255octets_gb             (ETH_BASE + 0x01B4)
#define ETH_MMC_rx256to511octets_gb             (ETH_BASE + 0x01B8)
#define ETH_MMC_rx512to1023octets_gb            (ETH_BASE + 0x01BC)
#define ETH_MMC_rx1024tomaxoctets_gb            (ETH_BASE + 0x01C0)
#define ETH_MMC_rxunicastframes_g               (ETH_BASE + 0x01C4)
#define ETH_MMC_rxlengtherror                   (ETH_BASE + 0x01C8)
#define ETH_MMC_rxoutofrangetype                (ETH_BASE + 0x01CC)
#define ETH_MMC_rxpauseframes                   (ETH_BASE + 0x01D0)
#define ETH_MMC_rxfifooverflow                  (ETH_BASE + 0x01D4)
#define ETH_MMC_rxvlanframes_gb                 (ETH_BASE + 0x01D8)
#define ETH_MMC_rxwatchdogerror                 (ETH_BASE + 0x01DC)
#define ETH_MMC_120_Reserved                    (ETH_BASE + 0x01E0)
#define ETH_MMC_121_Reserved                    (ETH_BASE + 0x01E4)
#define ETH_MMC_122_Reserved                    (ETH_BASE + 0x01E8)
#define ETH_MMC_123_Reserved                    (ETH_BASE + 0x01EC)
#define ETH_MMC_124_Reserved                    (ETH_BASE + 0x01F0)
#define ETH_MMC_125_Reserved                    (ETH_BASE + 0x01F4)
#define ETH_MMC_126_Reserved                    (ETH_BASE + 0x01F8)
#define ETH_MMC_127_Reserved                    (ETH_BASE + 0x01FC)
#define ETH_MMC_ipc_intr_mask_rx                (ETH_BASE + 0x0200)
#define ETH_MMC_129_Reserved                    (ETH_BASE + 0x0204)
#define ETH_MMC_ipc_intr_rx                     (ETH_BASE + 0x0208)
#define ETH_MMC_131_Reserved                    (ETH_BASE + 0x020C)
#define ETH_MMC_rxipv4_gd_frms                  (ETH_BASE + 0x0210)
#define ETH_MMC_rxipv4_hdrerr_frms              (ETH_BASE + 0x0214)
#define ETH_MMC_rxipv4_nopay_frms               (ETH_BASE + 0x0218)
#define ETH_MMC_rxipv4_frag_frms                (ETH_BASE + 0x021C)
#define ETH_MMC_rxipv4_udsbl_frms               (ETH_BASE + 0x0220)
#define ETH_MMC_rxipv6_gd_frms                  (ETH_BASE + 0x0224)
#define ETH_MMC_rxipv6_hdrerr_frms              (ETH_BASE + 0x0228)
#define ETH_MMC_rxipv6_nopay_frms               (ETH_BASE + 0x022C)
#define ETH_MMC_rxudp_gd_frms                   (ETH_BASE + 0x0230)
#define ETH_MMC_rxudp_err_frms                  (ETH_BASE + 0x0234)
#define ETH_MMC_rxtcp_gd_frms                   (ETH_BASE + 0x0238)
#define ETH_MMC_rxtcp_err_frms                  (ETH_BASE + 0x023C)
#define ETH_MMC_rxicmp_gd_frms                  (ETH_BASE + 0x0240)
#define ETH_MMC_rxicmp_err_frms                 (ETH_BASE + 0x0244)
#define ETH_MMC_146_Reserved                    (ETH_BASE + 0x0248)
#define ETH_MMC_147_Reserved                    (ETH_BASE + 0x024C)
#define ETH_MMC_rxipv4_gd_octets                (ETH_BASE + 0x0250)
#define ETH_MMC_rxipv4_hdrerr_octets            (ETH_BASE + 0x0254)
#define ETH_MMC_rxipv4_nopay_octets             (ETH_BASE + 0x0258)
#define ETH_MMC_rxipv4_frag_octets              (ETH_BASE + 0x025C)
#define ETH_MMC_rxipv4_udsbl_octets             (ETH_BASE + 0x0260)
#define ETH_MMC_rxipv6_gd_octets                (ETH_BASE + 0x0264)
#define ETH_MMC_rxipv6_hdrerr_octets            (ETH_BASE + 0x0268)
#define ETH_MMC_rxipv6_nopay_octets             (ETH_BASE + 0x026C)
#define ETH_MMC_rxudp_gd_octets                 (ETH_BASE + 0x0270)
#define ETH_MMC_rxudp_err_octets                (ETH_BASE + 0x0274)
#define ETH_MMC_rxtcp_gd_octets                 (ETH_BASE + 0x0278)
#define ETH_MMC_rxtcp_err_octets                (ETH_BASE + 0x027C)
#define ETH_MMC_rxicmp_gd_octets                (ETH_BASE + 0x0280)
#define ETH_MMC_rxicmp_err_octets               (ETH_BASE + 0x0284)

/*
 * ****************************************************************************
 *  A description of the NIKE Enthernet registers bit defination
 * ****************************************************************************
 */
/* ETH_DMA_0_Bus_Mode */
#define ETH_DMA_0_Bus_Mode_SWR_P                0
#define ETH_DMA_0_Bus_Mode_DA_P                 1
#define ETH_DMA_0_Bus_Mode_DSL_P                2
#define ETH_DMA_0_Bus_Mode_PBL_P                8
#define ETH_DMA_0_Bus_Mode_PR_P                 14
#define ETH_DMA_0_Bus_Mode_FB_P                 16
#define ETH_DMA_0_Bus_Mode_RPBL_P               17
#define ETH_DMA_0_Bus_Mode_USP_P                23
#define ETH_DMA_0_Bus_Mode_4xPBL_P              24
#define ETH_DMA_0_Bus_Mode_AAL_P                25

#define ETH_DMA_0_Bus_Mode_SWR                  (1<<ETH_DMA_0_Bus_Mode_SWR_P)
#define ETH_DMA_0_Bus_Mode_DA                   (1<<ETH_DMA_0_Bus_Mode_DA_P)
#define ETH_DMA_0_Bus_Mode_DSL                  (1<<ETH_DMA_0_Bus_Mode_DSL_P)
#define ETH_DMA_0_Bus_Mode_PBL                  (1<<ETH_DMA_0_Bus_Mode_PBL_P)
#define ETH_DMA_0_Bus_Mode_PR                   (1<<ETH_DMA_0_Bus_Mode_PR_P)
#define ETH_DMA_0_Bus_Mode_FB                   (1<<ETH_DMA_0_Bus_Mode_FB_P)
#define ETH_DMA_0_Bus_Mode_RPBL                 (1<<ETH_DMA_0_Bus_Mode_RPBL_P)
#define ETH_DMA_0_Bus_Mode_USP                  (1<<ETH_DMA_0_Bus_Mode_USP_P)
#define ETH_DMA_0_Bus_Mode_4xPBL                (1<<ETH_DMA_0_Bus_Mode_4xPBL_P)
#define ETH_DMA_0_Bus_Mode_AAL                  (1<<ETH_DMA_0_Bus_Mode_AAL_P)

/* ETH_DMA_1_Tr_Poll_Demand */
#define ETH_DMA_1_Tr_Poll_Demand_P              0

/* ETH_DMA_2_Re_Poll_Demand */
#define ETH_DMA_2_Re_Poll_Demand_P              0

/* ETH_DMA_3_Re_Descriptor_List_Addr */
#define ETH_DMA_3_Re_Descriptor_List_Addr_P     0

/* ETH_DMA_4_Tr_Descriptor_List_Addr */
#define ETH_DMA_4_Tr_Descriptor_List_Addr_P     0

/* ETH_DMA_5_Status */
#define ETH_DMA_5_Status_TI_P                   0
#define ETH_DMA_5_Status_TPS_P                  1
#define ETH_DMA_5_Status_TU_P                   2
#define ETH_DMA_5_Status_TJT_P                  3
#define ETH_DMA_5_Status_OVF_P                  4
#define ETH_DMA_5_Status_UNF_P                  5
#define ETH_DMA_5_Status_RI_P                   6
#define ETH_DMA_5_Status_RU_P                   7
#define ETH_DMA_5_Status_RPS_P                  8
#define ETH_DMA_5_Status_RWP_P                  9
#define ETH_DMA_5_Status_ETI_P                  10
#define ETH_DMA_5_Status_FBI_P                  13
#define ETH_DMA_5_Status_ERI_P                  14
#define ETH_DMA_5_Status_AIS_P                  15
#define ETH_DMA_5_Status_NIS_P                  16
#define ETH_DMA_5_Status_RS_P                   17
#define ETH_DMA_5_Status_TS_P                   20
#define ETH_DMA_5_Status_EB_P                   23
#define ETH_DMA_5_Status_GLI_P                  26
#define ETH_DMA_5_Status_GMI_P                  27
#define ETH_DMA_5_Status_GPI_P                  28

#define ETH_DMA_5_Status_TI                     (1<<ETH_DMA_5_Status_TI_P)
#define ETH_DMA_5_Status_TPS                    (1<<ETH_DMA_5_Status_TPS_P)
#define ETH_DMA_5_Status_TU                     (1<<ETH_DMA_5_Status_TU_P)
#define ETH_DMA_5_Status_TJT                    (1<<ETH_DMA_5_Status_TJT_P)
#define ETH_DMA_5_Status_OVF                    (1<<ETH_DMA_5_Status_OVF_P)
#define ETH_DMA_5_Status_UNF                    (1<<ETH_DMA_5_Status_UNF_P)
#define ETH_DMA_5_Status_RI                     (1<<ETH_DMA_5_Status_RI_P)
#define ETH_DMA_5_Status_RU                     (1<<ETH_DMA_5_Status_RU_P)
#define ETH_DMA_5_Status_RPS                    (1<<ETH_DMA_5_Status_RPS_P)
#define ETH_DMA_5_Status_RWP                    (1<<ETH_DMA_5_Status_RWP_P)
#define ETH_DMA_5_Status_ETI                    (1<<ETH_DMA_5_Status_ETI_P)
#define ETH_DMA_5_Status_FBI                    (1<<ETH_DMA_5_Status_FBI_P)
#define ETH_DMA_5_Status_ERI                    (1<<ETH_DMA_5_Status_ERI_P)
#define ETH_DMA_5_Status_AIS                    (1<<ETH_DMA_5_Status_AIS_P)
#define ETH_DMA_5_Status_NIS                    (1<<ETH_DMA_5_Status_NIS_P)
#define ETH_DMA_5_Status_RS                     (1<<ETH_DMA_5_Status_RS_P)
#define ETH_DMA_5_Status_TS_STOP                (0<<ETH_DMA_5_Status_TS_P)
#define ETH_DMA_5_Status_TS_FETCH               (1<<ETH_DMA_5_Status_TS_P)
#define ETH_DMA_5_Status_TS_WAIT                (2<<ETH_DMA_5_Status_TS_P)
#define ETH_DMA_5_Status_TS_READ                (3<<ETH_DMA_5_Status_TS_P)
#define ETH_DMA_5_Status_TS_SUSP                (6<<ETH_DMA_5_Status_TS_P)
#define ETH_DMA_5_Status_TS_CLS                 (7<<ETH_DMA_5_Status_TS_P)
#define ETH_DMA_5_Status_EB_TX                  (1<<ETH_DMA_5_Status_EB_P)
#define ETH_DMA_5_Status_EB_RD                  (1<<(ETH_DMA_5_Status_EB_P+1))
#define ETH_DMA_5_Status_EB_DES                 (1<<(ETH_DMA_5_Status_EB_P+2))
#define ETH_DMA_5_Status_GLI                    (1<<ETH_DMA_5_Status_GLI_P)
#define ETH_DMA_5_Status_GMI                    (1<<ETH_DMA_5_Status_GMI_P)
#define ETH_DMA_5_Status_GPI                    (1<<ETH_DMA_5_Status_GPI_P)

/* ETH_DMA_6_Operation_Mode */
#define ETH_DMA_6_Operation_Mode_SR_P           1
#define ETH_DMA_6_Operation_Mode_OSF_P          2
#define ETH_DMA_6_Operation_Mode_RTC_P          3
#define ETH_DMA_6_Operation_Mode_FUF_P          6
#define ETH_DMA_6_Operation_Mode_FEF_P          7
#define ETH_DMA_6_Operation_Mode_EFC_P          8
#define ETH_DMA_6_Operation_Mode_RFA_P          9
#define ETH_DMA_6_Operation_Mode_RFD_P          11
#define ETH_DMA_6_Operation_Mode_ST_P           13
#define ETH_DMA_6_Operation_Mode_TTC_P          14
#define ETH_DMA_6_Operation_Mode_FTF_P          20
#define ETH_DMA_6_Operation_Mode_TSF_P          21
#define ETH_DMA_6_Operation_Mode_RFD2_P         22
#define ETH_DMA_6_Operation_Mode_RFA2_P         23
#define ETH_DMA_6_Operation_Mode_DFF_P          24
#define ETH_DMA_6_Operation_Mode_RSF_P          25
#define ETH_DMA_6_Operation_Mode_DT_P           26

#define ETH_DMA_6_Operation_Mode_SR             (1<<ETH_DMA_6_Operation_Mode_SR_P)
#define ETH_DMA_6_Operation_Mode_OSF            (1<<ETH_DMA_6_Operation_Mode_OSF_P)
#define ETH_DMA_6_Operation_Mode_RTC_64         (0<<ETH_DMA_6_Operation_Mode_RTC_P)
#define ETH_DMA_6_Operation_Mode_RTC_32         (1<<ETH_DMA_6_Operation_Mode_RTC_P)
#define ETH_DMA_6_Operation_Mode_RTC_96         (2<<ETH_DMA_6_Operation_Mode_RTC_P)
#define ETH_DMA_6_Operation_Mode_RTC_128        (3<<ETH_DMA_6_Operation_Mode_RTC_P)
#define ETH_DMA_6_Operation_Mode_FUF            (1<<ETH_DMA_6_Operation_Mode_FUF_P)
#define ETH_DMA_6_Operation_Mode_FEF            (1<<ETH_DMA_6_Operation_Mode_FEF_P)
#define ETH_DMA_6_Operation_Mode_EFC            (1<<ETH_DMA_6_Operation_Mode_EFC_P)
#define ETH_DMA_6_Operation_Mode_RFA_1K         (0<<ETH_DMA_6_Operation_Mode_RFA_P)
#define ETH_DMA_6_Operation_Mode_RFA_2K         (1<<ETH_DMA_6_Operation_Mode_RFA_P)
#define ETH_DMA_6_Operation_Mode_RFA_3K         (2<<ETH_DMA_6_Operation_Mode_RFA_P)
#define ETH_DMA_6_Operation_Mode_RFA_4K         (3<<ETH_DMA_6_Operation_Mode_RFA_P)
#define ETH_DMA_6_Operation_Mode_RFD_1K         (0<<ETH_DMA_6_Operation_Mode_RFD_P)
#define ETH_DMA_6_Operation_Mode_RFD_2K         (1<<ETH_DMA_6_Operation_Mode_RFD_P)
#define ETH_DMA_6_Operation_Mode_RFD_3K         (2<<ETH_DMA_6_Operation_Mode_RFD_P)
#define ETH_DMA_6_Operation_Mode_RFD_4K         (3<<ETH_DMA_6_Operation_Mode_RFD_P)
#define ETH_DMA_6_Operation_Mode_ST             (1<<ETH_DMA_6_Operation_Mode_ST_P)
#define ETH_DMA_6_Operation_Mode_TTC_64         (0<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_128        (1<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_192        (2<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_256        (3<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_40         (4<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_32         (5<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_24         (6<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_TTC_16         (7<<ETH_DMA_6_Operation_Mode_TTC_P)
#define ETH_DMA_6_Operation_Mode_FTF            (1<<ETH_DMA_6_Operation_Mode_FTF_P)
#define ETH_DMA_6_Operation_Mode_TSF            (1<<ETH_DMA_6_Operation_Mode_TSF_P)
#define ETH_DMA_6_Operation_Mode_RFD2           (1<<ETH_DMA_6_Operation_Mode_RFD2_P)
#define ETH_DMA_6_Operation_Mode_RFA2           (1<<ETH_DMA_6_Operation_Mode_RFA2_P)
#define ETH_DMA_6_Operation_Mode_DFF            (1<<ETH_DMA_6_Operation_Mode_DFF_P)
#define ETH_DMA_6_Operation_Mode_RSF            (1<<ETH_DMA_6_Operation_Mode_RSF_P)
#define ETH_DMA_6_Operation_Mode_DT             (1<<ETH_DMA_6_Operation_Mode_DT_P)

/* ETH_DMA_7_Interrupt_Enable */
#define ETH_DMA_7_Interrupt_Enable_TIE_P        0
#define ETH_DMA_7_Interrupt_Enable_TSE_P        1
#define ETH_DMA_7_Interrupt_Enable_TUE_P        2
#define ETH_DMA_7_Interrupt_Enable_TJE_P        3
#define ETH_DMA_7_Interrupt_Enable_OVE_P        4
#define ETH_DMA_7_Interrupt_Enable_UNE_P        5
#define ETH_DMA_7_Interrupt_Enable_RIE_P        6
#define ETH_DMA_7_Interrupt_Enable_RUE_P        7
#define ETH_DMA_7_Interrupt_Enable_RSE_P        8
#define ETH_DMA_7_Interrupt_Enable_RWE_P        9
#define ETH_DMA_7_Interrupt_Enable_ETE_P        10
#define ETH_DMA_7_Interrupt_Enable_FBE_P        13
#define ETH_DMA_7_Interrupt_Enable_ERE_P        14
#define ETH_DMA_7_Interrupt_Enable_AIE_P        15
#define ETH_DMA_7_Interrupt_Enable_NIE_P        16

#define ETH_DMA_7_Interrupt_Enable_TIE          (1<<ETH_DMA_7_Interrupt_Enable_TIE_P)
#define ETH_DMA_7_Interrupt_Enable_TSE          (1<<ETH_DMA_7_Interrupt_Enable_TSE_P)
#define ETH_DMA_7_Interrupt_Enable_TUE          (1<<ETH_DMA_7_Interrupt_Enable_TUE_P)
#define ETH_DMA_7_Interrupt_Enable_TJE          (1<<ETH_DMA_7_Interrupt_Enable_TJE_P)
#define ETH_DMA_7_Interrupt_Enable_OVE          (1<<ETH_DMA_7_Interrupt_Enable_OVE_P)
#define ETH_DMA_7_Interrupt_Enable_UNE          (1<<ETH_DMA_7_Interrupt_Enable_UNE_P)
#define ETH_DMA_7_Interrupt_Enable_RIE          (1<<ETH_DMA_7_Interrupt_Enable_RIE_P)
#define ETH_DMA_7_Interrupt_Enable_RUE          (1<<ETH_DMA_7_Interrupt_Enable_RUE_P)
#define ETH_DMA_7_Interrupt_Enable_RSE          (1<<ETH_DMA_7_Interrupt_Enable_RSE_P)
#define ETH_DMA_7_Interrupt_Enable_RWE          (1<<ETH_DMA_7_Interrupt_Enable_RWE_P)
#define ETH_DMA_7_Interrupt_Enable_ETE          (1<<ETH_DMA_7_Interrupt_Enable_ETE_P)
#define ETH_DMA_7_Interrupt_Enable_FBE          (1<<ETH_DMA_7_Interrupt_Enable_FBE_P)
#define ETH_DMA_7_Interrupt_Enable_ERE          (1<<ETH_DMA_7_Interrupt_Enable_ERE_P)
#define ETH_DMA_7_Interrupt_Enable_AIE          (1<<ETH_DMA_7_Interrupt_Enable_AIE_P)
#define ETH_DMA_7_Interrupt_Enable_NIE          (1<<ETH_DMA_7_Interrupt_Enable_NIE_P)

/* ETH_MAC_0_Configuration */
#define ETH_MAC_0_Configuration_RE_P            2
#define ETH_MAC_0_Configuration_TE_P            3
#define ETH_MAC_0_Configuration_DC_P            4
#define ETH_MAC_0_Configuration_BL_P            5
#define ETH_MAC_0_Configuration_ACS_P           7
#define ETH_MAC_0_Configuration_LUD_P           8
#define ETH_MAC_0_Configuration_DR_P            9
#define ETH_MAC_0_Configuration_IPC_P           10
#define ETH_MAC_0_Configuration_DM_P            11
#define ETH_MAC_0_Configuration_LM_P            12
#define ETH_MAC_0_Configuration_DO_P            13
#define ETH_MAC_0_Configuration_FES_P           14
#define ETH_MAC_0_Configuration_PS_P            15
#define ETH_MAC_0_Configuration_DCRS_P          16
#define ETH_MAC_0_Configuration_IFG_P           17
#define ETH_MAC_0_Configuration_JE_P            20
#define ETH_MAC_0_Configuration_BE_P            21
#define ETH_MAC_0_Configuration_JD_P            22
#define ETH_MAC_0_Configuration_WD_P            23
#define ETH_MAC_0_Configuration_TC_P            24

#define ETH_MAC_0_Configuration_RE              (1<<ETH_MAC_0_Configuration_RE_P)
#define ETH_MAC_0_Configuration_TE              (1<<ETH_MAC_0_Configuration_TE_P)
#define ETH_MAC_0_Configuration_DC              (1<<ETH_MAC_0_Configuration_DC_P)
#define ETH_MAC_0_Configuration_BL              (1<<ETH_MAC_0_Configuration_BL_P)
#define ETH_MAC_0_Configuration_ACS             (1<<ETH_MAC_0_Configuration_ACS_P)
#define ETH_MAC_0_Configuration_LUD             (1<<ETH_MAC_0_Configuration_LUD_P)
#define ETH_MAC_0_Configuration_DR              (1<<ETH_MAC_0_Configuration_DR_P)
#define ETH_MAC_0_Configuration_IPC             (1<<ETH_MAC_0_Configuration_IPC_P)
#define ETH_MAC_0_Configuration_DM              (1<<ETH_MAC_0_Configuration_DM_P)
#define ETH_MAC_0_Configuration_LM              (1<<ETH_MAC_0_Configuration_LM_P)
#define ETH_MAC_0_Configuration_DO              (1<<ETH_MAC_0_Configuration_DO_P)
#define ETH_MAC_0_Configuration_FES_10M         (0<<ETH_MAC_0_Configuration_FES_P)
#define ETH_MAC_0_Configuration_FES_100M        (1<<ETH_MAC_0_Configuration_FES_P)
#define ETH_MAC_0_Configuration_PS_GMII         (0<<ETH_MAC_0_Configuration_PS_P)
#define ETH_MAC_0_Configuration_PS_MII          (1<<ETH_MAC_0_Configuration_PS_P)
#define ETH_MAC_0_Configuration_DCRS            (1<<ETH_MAC_0_Configuration_DCRS_P)
#define ETH_MAC_0_Configuration_IFG             (1<<ETH_MAC_0_Configuration_IFG_P)
#define ETH_MAC_0_Configuration_JE              (1<<ETH_MAC_0_Configuration_JE_P)
#define ETH_MAC_0_Configuration_BE              (1<<ETH_MAC_0_Configuration_BE_P)
#define ETH_MAC_0_Configuration_JD              (1<<ETH_MAC_0_Configuration_JD_P)
#define ETH_MAC_0_Configuration_WD              (1<<ETH_MAC_0_Configuration_WD_P)
#define ETH_MAC_0_Configuration_TC              (1<<ETH_MAC_0_Configuration_TC_P)

/* ETH_MAC_1_Frame_Filter */
#define ETH_MAC_1_Frame_Filter_PR_P             0
#define ETH_MAC_1_Frame_Filter_HUC_P            1
#define ETH_MAC_1_Frame_Filter_HMC_P            2
#define ETH_MAC_1_Frame_Filter_DAIF_P           3
#define ETH_MAC_1_Frame_Filter_PM_P             4
#define ETH_MAC_1_Frame_Filter_DBF_P            5
#define ETH_MAC_1_Frame_Filter_PCF_P            6
#define ETH_MAC_1_Frame_Filter_SAIF_P           8
#define ETH_MAC_1_Frame_Filter_SAF_P            9
#define ETH_MAC_1_Frame_Filter_HPF_P            10
#define ETH_MAC_1_Frame_Filter_RA_P             31

#define ETH_MAC_1_Frame_Filter_PR               (1<<ETH_MAC_1_Frame_Filter_PR_P)
#define ETH_MAC_1_Frame_Filter_HUC              (1<<ETH_MAC_1_Frame_Filter_HUC_P)
#define ETH_MAC_1_Frame_Filter_HMC              (1<<ETH_MAC_1_Frame_Filter_HMC_P)
#define ETH_MAC_1_Frame_Filter_DAIF             (1<<ETH_MAC_1_Frame_Filter_DAIF_P)
#define ETH_MAC_1_Frame_Filter_PM               (1<<ETH_MAC_1_Frame_Filter_PM_P)
#define ETH_MAC_1_Frame_Filter_DBF              (1<<ETH_MAC_1_Frame_Filter_DBF_P)
#define ETH_MAC_1_Frame_Filter_PCF              (1<<ETH_MAC_1_Frame_Filter_PCF_P)
#define ETH_MAC_1_Frame_Filter_SAIF             (1<<ETH_MAC_1_Frame_Filter_SAIF_P)
#define ETH_MAC_1_Frame_Filter_SAF              (1<<ETH_MAC_1_Frame_Filter_SAF_P)
#define ETH_MAC_1_Frame_Filter_HPF              (1<<ETH_MAC_1_Frame_Filter_HPF_P)
#define ETH_MAC_1_Frame_Filter_RA               (1<<ETH_MAC_1_Frame_Filter_RA_P)

/* ETH_MAC_4_GMII_Addr */
#define ETH_MAC_4_GMII_Addr_GB_P                0
#define ETH_MAC_4_GMII_Addr_GW_P                1
#define ETH_MAC_4_GMII_Addr_CR_P                2
#define ETH_MAC_4_GMII_Addr_GR_P                6
#define ETH_MAC_4_GMII_Addr_PA_P                11

#define ETH_MAC_4_GMII_Addr_GB                  (1<<ETH_MAC_4_GMII_Addr_GB_P)
#define ETH_MAC_4_GMII_Addr_GW                  (1<<ETH_MAC_4_GMII_Addr_GW_P)
#define ETH_MAC_4_GMII_Addr_CR_60_100           (0<<ETH_MAC_4_GMII_Addr_CR_P)
#define ETH_MAC_4_GMII_Addr_CR_100_150          (1<<ETH_MAC_4_GMII_Addr_CR_P)
#define ETH_MAC_4_GMII_Addr_CR_20_35            (2<<ETH_MAC_4_GMII_Addr_CR_P)
#define ETH_MAC_4_GMII_Addr_CR_35_60            (3<<ETH_MAC_4_GMII_Addr_CR_P)
#define ETH_MAC_4_GMII_Addr_CR_150_250          (4<<ETH_MAC_4_GMII_Addr_CR_P)
#define ETH_MAC_4_GMII_Addr_CR_250_300          (5<<ETH_MAC_4_GMII_Addr_CR_P)










struct _tx_desc {
    unsigned int tdes0;
    unsigned int tdes1;
    unsigned int tdes2;
    unsigned int tdes3;
    unsigned int reverse[4];//for 32 bytes cahce aligned
} ;

struct _rx_desc {
    unsigned int rdes0;
    unsigned int rdes1;
    unsigned int rdes2;
    unsigned int rdes3;
    unsigned int reverse[4];//for 32 bytes cahce aligned
} ;


struct _gStruct{
  // struct netif e8218_netif;
   struct _rx_desc* rx;
   struct _tx_desc* tx;
   int current_rx_des;
   int current_tx_des;
   int rx_len;  //64desc
   int tx_len;  //64desc
   int buffer_len; //64bytes
   unsigned long tx_buf_addr;//0x00C21000
   unsigned long rx_buf_addr;//0x00C23000
   unsigned long rx_addr; //0x00C20100
   unsigned long tx_addr; //0x00C20000
   int rx_frame_num;
   int current_tx_ready;
   int last_tx_sent;
   int last_tx_desc_num;
   int irq_handle;
   int  linked;
};


/* Mtu */

#define ETH_MTU				1500

#define CTX_BUFFER_NUM		32
#define CRX_BUFFER_NUM		48
#define CBUFFER_SIZE		1536

/* Size of RX buffers, min = 0 (pointless) max = 2048 (MAX_RX_BUFFER_LEN)
 * MAC reference manual recommends a value slightly greater than the
 * maximum size of the packet expected other wise it will chain
 * a zero size buffer desc if a packet of exactly RX_BUFFER_LEN comes.
 * VMAC will chain buffers if a packet bigger than this arrives.
 */
#define RX_BUFFER_LEN	(ETH_FRAME_LEN + 4)

#define MAX_RX_BUFFER_LEN	0x800	/* 2^11 = 2048 = 0x800 */
#define MAX_TX_BUFFER_LEN	0x800	/* 2^11 = 2048 = 0x800 */


/* 14 bytes of ethernet header, 8 bytes pad to prevent buffer chaining
 * of maximum sized ethernet packets (1514 bytes)
 */
#define	VMAC_BUFFER_PAD ETH_HLEN + 8






/*
 * ********************************************************
 *	A description of the Enthernet DMA Dtion
 * ********************************************************
 */
/* Receive Descriptor 0 */
#define RDES0_MCE_P						0
#define RDES0_CE_P						1
#define RDES0_DBE_P						2
#define RDES0_RE_P						3
#define RDES0_RWT_P						4
#define RDES0_FT_P						5
#define RDES0_LC_P						6
#define RDES0_IPC_P						7
#define RDES0_LS_P						8
#define RDES0_FS_P						9
#define RDES0_VLAN_P					10
#define RDES0_OE_P						11
#define RDES0_LE_P						12
#define RDES0_SAF_P						13
#define RDES0_DE_P						14
#define RDES0_ES_P						15
#define RDES0_FL_P						16
#define RDES0_AFM_P						30
#define RDES0_OWN_P						31

#define RDES0_MCE						(1<<RDES0_MCE_P)
#define RDES0_CE						(1<<RDES0_CE_P)
#define RDES0_DBE						(1<<RDES0_DBE_P)
#define RDES0_RE						(1<<RDES0_RE_P)
#define RDES0_RWT   					(1<<RDES0_RWT_P)
#define RDES0_FT						(1<<RDES0_FT_P)
#define RDES0_LC						(1<<RDES0_LC_P)
#define RDES0_IPC   					(1<<RDES0_IPC_P)
#define RDES0_LS						(1<<RDES0_LS_P)
#define RDES0_FS						(1<<RDES0_FS_P)
#define RDES0_VLAN  					(1<<RDES0_VLAN_P)
#define RDES0_OE						(1<<RDES0_OE_P)
#define RDES0_LE						(1<<RDES0_LE_P)
#define RDES0_SAF   					(1<<RDES0_SAF_P)
#define RDES0_DE						(1<<RDES0_DE_P)
#define RDES0_ES						(1<<RDES0_ES_P)
#define RDES0_FL_MASK					(0x3fff<<RDES0_FL_P)
#define RDES0_AFM   					(1<<RDES0_AFM_P)
#define RDES0_OWN   					(1<<RDES0_OWN_P)

/* Receive Descriptor 1 */
#define RDES1_RBS1_P					0
#define RDES1_RBS2_P					11
#define RDES1_RCH_P						24
#define RDES1_RER_P						25
#define RDES1_DIC_P						31

#define RDES1_RBS1_MASK					(0x7ff<<RDES1_RBS1_P)
#define RDES1_RBS2_MASK					(0x7ff<<RDES1_RBS2_P)
#define RDES1_RCH						(1<<RDES1_RCH_P)
#define RDES1_RER						(1<<RDES1_RER_P)
#define RDES1_DIC						(1<<RDES1_DIC_P)

/* Receive Descriptor 2: Buffer 1 Address Pointer */
/* Receive Descriptor 3: Buffer 2 Address Pointer */

/* Transmit Descriptor 0 */
#define TDES0_DB_P						0
#define TDES0_UF_P						1
#define TDES0_ED_P						2
#define TDES0_CC_P						3
#define TDES0_VF_P						7
#define TDES0_EC_P						8
#define TDES0_LTC_P						9
#define TDES0_NC_P						10
#define TDES0_LOC_P						11
#define TDES0_PCE_P						12
#define TDES0_FF_P						13
#define TDES0_JT_P						14
#define TDES0_ES_P						15
#define TDES0_IHE_P						16
#define TDES0_OWN_P						31

#define TDES0_DB						(1<<TDES0_DB_P)
#define TDES0_UF						(1<<TDES0_UF_P)
#define TDES0_ED						(1<<TDES0_ED_P)
#define TDES0_CC_MASK					(0xf<<TDES0_CC_P)
#define TDES0_VF						(1<<TDES0_VF_P)
#define TDES0_EC						(1<<TDES0_EC_P)
#define TDES0_LTC						(1<<TDES0_LTC_P)
#define TDES0_NC						(1<<TDES0_NC_P)
#define TDES0_LOC						(1<<TDES0_LOC_P)
#define TDES0_PCE						(1<<TDES0_PCE_P)
#define TDES0_FF						(1<<TDES0_FF_P)
#define TDES0_JT						(1<<TDES0_JT_P)
#define TDES0_ES						(1<<TDES0_ES_P)
#define TDES0_IHE						(1<<TDES0_IHE_P)
#define TDES0_OWN						(1<<TDES0_OWN_P)

/* Transmit Descriptor 1 */
#define TDES1_TBS1_P					0
#define TDES1_TBS2_P					11
#define TDES1_DP_P						23
#define TDES1_TCH_P						24
#define TDES1_TER_P						25
#define TDES1_DC_P						26
#define TDES1_CIC_P						27
#define TDES1_FS_P						29
#define TDES1_LS_P						30
#define TDES1_IC_P						31

#define TDES1_TBS1_MASK					(0x7ff<<TDES1_TBS1_P)
#define TDES1_TBS2_MASK					(0x7ff<<TDES1_TBS2_P)
#define TDES1_DP						(1<<TDES1_DP_P)
#define TDES1_TCH						(1<<TDES1_TCH_P)
#define TDES1_TER						(1<<TDES1_TER_P)
#define TDES1_DC						(1<<TDES1_DC_P)
#define TDES1_CIC						(1<<TDES1_CIC_P)
#define TDES1_FS						(1<<TDES1_FS_P)
#define TDES1_LS						(1<<TDES1_LS_P)
#define TDES1_IC						(1<<TDES1_IC_P)

/* Transmit Descriptor 2: Buffer 1 Address Pointer */
/* Transmit Descriptor 3: Buffer 2 Address Pointer */

#define CACHE_LINE_LENGTH 0x20
#define CACHE_LINE_MASK   0xffffffe0



#endif /*__AML_ETH_REG_H__*/
