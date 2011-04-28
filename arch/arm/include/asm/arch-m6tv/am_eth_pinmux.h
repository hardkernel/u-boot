#ifndef ETH_PINMUX_HEADER_
#define ETH_PINMUX_HEADER_

/*Ethernet*/
/*
"RMII_MDIOREG6[8]"
"RMII_MDCREG6[9]"
"RMII_TX_DATA0REG6[10]"
"RMII_TX_DATA1REG6[11]"
"RMII_TX_ENREG6[12]"
"RMII_RX_DATA0REG6[13]"
"RMII_RX_DATA1REG6[14]"
"RMII_RX_CRS_DVREG6[15]"
"RMII_RX_ERRREG6[16]"
Bank0_GPIOY1-Y9
*/
#define ETH_BANK0_GPIOY1_Y9             0
#define ETH_BANK0_REG1                  6
#define ETH_BANK0_REG1_VAL              (0x1ff<<8)

#define ETH_CLK_IN_GPIOY0_REG6_18       0
#define ETH_CLK_OUT_GPIOY0_REG6_17      1
#endif


