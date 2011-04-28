/*******************************************************************
 * 
 *  Copyright C 2011 by Amlogic, Inc. All Rights Reserved.
 *
 *  Description: header file of pinmux setting for Amlogic Ethernet
 *
 *  
 *  Remark: 2011.08.02 merge by Hisun bao
 *                from /arch/arm/include/asm/arch-m1
 *
 *******************************************************************/
#ifndef __AML_ETH_PINMUX_HEADER__
#define __AML_ETH_PINMUX_HEADER__

/*Ethernet*/
/*
"RMII_MDIO-------- REG6[8]"
"RMII_MDC---------REG6[9]"
"RMII_TX_DATA0---- REG6[10]"
"RMII_TX_DATA1---- REG6[11]"
"RMII_TX_EN------- REG6[12]"
"RMII_RX_DATA0---- REG6[13]"
"RMII_RX_DATA1---- REG6[14]"
"RMII_RX_CRS_DV--- REG6[15]"
"RMII_RX_ERR------ REG6[16]"

Bank0_GPIOY1-Y9
*/
#define ETH_BANK0_GPIOY1_Y9             (0)
#define ETH_BANK0_REG1                  (6)
#define ETH_BANK0_REG1_VAL              (0x1ff<<8)

#define ETH_CLK_IN_GPIOY0_REG6_18       (0)
#define ETH_CLK_OUT_GPIOY0_REG6_17      (1)


int aml_eth_clearall_pinmux(void);
int aml_eth_set_pinmux(int bank_id,int clk_in_out_id,unsigned long ext_msk);

#endif  /*__AML_ETH_PINMUX_HEADER__*/


