/*******************************************************************
 * 
 *  Copyright C 2011 by Amlogic, Inc. All Rights Reserved.
 *
 *  Description: Enthernet driver for LAN8700
 *
 *  Author: Min Chu
 *  Created: 2009-3-18
 *  
 *  Remark: 2011.08.02 merge by Hisun bao
 *                from /arch/arm/include/asm/arch-m1
 *
 *******************************************************************/


#ifndef __AML_EMAC_LAN8700_H__
#define __AML_EMAC_LAN8700_H__

#include <config.h>

struct _tx_desc {
    unsigned long tdes0;
    unsigned long tdes1;
    unsigned long tdes2;
    unsigned long tdes3;
    unsigned long reverse[4];//for 32 bytes cahce aligned
} ;

struct _rx_desc {
    unsigned long rdes0;
    unsigned long rdes1;
    unsigned long rdes2;
    unsigned long rdes3;
    unsigned long reverse[4];//for 32 bytes cahce aligned
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

/*-------------------------------------------
 .
 . A description of the SMSC LAN8700 regn order here
 . 
 ---------------------------------------------------*/
#define PHY_CR                  0
#define PHY_CR_RST              (1<<15)
#define PHY_CR_LOOPBACK         (1<<14)
#define PHY_CR_SPEED            (1<<13)
#define PHY_CR_AN               (1<<12)
#define PHY_CR_PWRDOWN          (1<<11)
#define PHY_CR_ISOLATE          (1<<10)
#define PHY_CR_RSTAN            (1<<9)
#define PHY_CR_DPLX             (1<<8)
#define PHY_CR_CT               (1<<7)

#define PHY_SR                  1
#define PHY_SR_100BT4           (1<<15)
#define PHY_SR_100BTF           (1<<14)
#define PHY_SR_100BTH           (1<<13)
#define PHY_SR_10BTF            (1<<12)
#define PHY_SR_10BTH            (1<<11)
#define PHY_SR_ANCOMPLETE       (1<<5)
#define PHY_SR_REMOTEFAULT      (1<<4)
#define PHY_SR_ANABILITY        (1<<3)
#define PHY_SR_LINKSTATUS       (1<<2)
#define PHY_JABBER              (1<<1)
#define PHY_EXTCAP              (1)

#define PHY_SPMD					18
#define PHY_SPMD_PHYAD_P			0
#define PHY_SPMD_MODE_P			5
#define PHY_SPMD_MIIMODE_P		14
#define PHY_SPMD_MIIMODE_MII		(0<<14)
#define PHY_SPMD_MIIMODE_RMII		(1<<14)

#define PHY_SPCT					31
#define PHY_SPCT_SCD_P				0
#define PHY_SPCT_SPD_P				2
#define PHY_SPCT_E4B5B_P			6
#define PHY_SPCT_GPO_P				7
#define PHY_SPCT_ATDW_P				12
#define PHY_SPCT_SCD				(1<<PHY_SPCT_SCD_P)
#define PHY_SPCT_SPD_10H			(1<<PHY_SPCT_SPD_P)
#define PHY_SPCT_SPD_10F			(5<<PHY_SPCT_SPD_P)
#define PHY_SPCT_SPD_100H			(2<<PHY_SPCT_SPD_P)
#define PHY_SPCT_SPD_100F			(6<<PHY_SPCT_SPD_P)
#define PHY_SPCT_E4B5B				(1<<PHY_SPCT_E4B5B_P)
#define PHY_SPCT_GPO				(1<<PHY_SPCT_GPO_P)
#define PHY_SPCT_ATDW				(1<<PHY_SPCT_ATDW_P)


#define ETH_MAC_0_TC                  (1<<24)
#define ETH_MAC_0_MIIPORT             (1<<15)
#define ETH_MAC_0_FES_100M            (1<<14)
#define ETH_MAC_0_DM                  (1<<11)
#define ETH_MAC_0_LM                  (1<<12)
#define ETH_MAC_0_LINK                (1<<8)
#define ETH_MAC_0_TE                  (1<<3)
#define ETH_MAC_0_RE                  (1<<2)

//MODE BUS
#define PHY_MODE_BUS_10HD_AD		0
#define PHY_MODE_BUS_10FD_AD		1
#define PHY_MODE_BUS_100HD_AD	2
#define PHY_MODE_BUS_100FD_AD	3
#define PHY_MODE_BUS_100HD_AE	4
#define PHY_MODE_BUS_RP_AE		5
#define PHY_MODE_BUS_PWDN		6
#define PHY_MODE_BUS_ALL_AE		7

//Normal Interrupts
#define NOR_INTR_EN 1<<16
#define TX_INTR_EN  1<<0
#define TX_BUF_UN_EN 1<<2
#define RX_INTR_EN  1<<6
#define EARLY_RX_INTR_EN 1<<14

//Abnormal Interrupts
#define ANOR_INTR_EN 1<<15
#define TX_STOP_EN 1<<1
#define TX_JABBER_TIMEOUT 1<<3
#define RX_FIFO_OVER 1<<4
#define TX_UNDERFLOW 1<<5
#define RX_BUF_UN 1<<7
#define RX_STOP_EN 1<<8
#define RX_WATCH_TIMEOUT 1<<9
#define EARLY_TX_INTR_EN 1<<10
#define FATAL_BUS_ERROR 1<<13

#define SEGMENT_FIRST 1<<29
#define SEGMENT_END 1<<30
#define SEGMENT_FIRST_END 3<<29

#define FIRST_BUFFER 1600;
#define MIDDLE_BUFFER 1601;
#define LAST_BUFFER 1602;
#define FIRST_LAST_BUFFER 1603; 

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

#define arc_read_uncached_32(ptr)                   \
({                                  \
    unsigned int __ret;                     \
    __asm__ __volatile__ ("ld.di %0, [%1]":"=r"(__ret):"r"(ptr));   \
    __ret;                              \
})

#define arc_write_uncached_32(ptr, data)                \
({                                  \
    __asm__ __volatile__ ("st.di %0, [%1]"::"r"(data), "r"(ptr));   \
})


#endif /* __AML_EMAC_LAN8700_H__ */

