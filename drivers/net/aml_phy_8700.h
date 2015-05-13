
/*
 * drivers/net/aml_phy_8700.h
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

#ifndef __AML_PHY_LAN8700_H__
#define __AML_PHY_LAN8700_H__

#include <config.h>


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


#endif /* __AML_EMAC_LAN8700_H__ */

