#ifndef __M3_MLVDS_REGS_H
#define __M3_MLVDS_REGS_H

#define MLVDS_TCON0 0
#define MLVDS_TCON1 1
#define MLVDS_TCON2 2
#define MLVDS_TCON3 3
#define MLVDS_TCON4 4
#define MLVDS_TCON5 5
#define MLVDS_TCON6 6
#define MLVDS_TCON7 7

//the following register function is a little different as before
//but the address is same
//MTCON0-3 is full function, and MTCON4-7 is reduced.
#define MTCON0_1ST_HS_ADDR                         0x1410  //L_STH1_HS_ADDR
#define MTCON0_1ST_HE_ADDR                         0x1411  //L_STH1_HE_ADDR
#define MTCON0_1ST_VS_ADDR                         0x1412  //L_STH1_VS_ADDR
#define MTCON0_1ST_VE_ADDR                         0x1413  //L_STH1_VE_ADDR
#define MTCON0_2ND_HS_ADDR                         0x1414  //L_STH2_HS_ADDR
#define MTCON0_2ND_HE_ADDR                         0x1415  //L_STH2_HE_ADDR
#define MTCON0_2ND_VS_ADDR                         0x1416  //L_STH2_VS_ADDR
#define MTCON0_2ND_VE_ADDR                         0x1417  //L_STH2_VE_ADDR

#define MTCON1_1ST_HS_ADDR                         0x141f  //L_CPV1_HS_ADDR
#define MTCON1_1ST_HE_ADDR                         0x1420  //L_CPV1_HE_ADDR
#define MTCON1_1ST_VS_ADDR                         0x1421  //L_CPV1_VS_ADDR
#define MTCON1_1ST_VE_ADDR                         0x1422  //L_CPV1_VE_ADDR
#define MTCON1_2ND_HS_ADDR                         0x1423  //L_CPV2_HS_ADDR
#define MTCON1_2ND_HE_ADDR                         0x1424  //L_CPV2_HE_ADDR
#define MTCON1_2ND_VS_ADDR                         0x1425  //L_CPV2_VS_ADDR
#define MTCON1_2ND_VE_ADDR                         0x1426  //L_CPV2_VE_ADDR

#define MTCON2_1ST_HS_ADDR                         0x1427  //L_STV1_HS_ADDR
#define MTCON2_1ST_HE_ADDR                         0x1428  //L_STV1_HE_ADDR
#define MTCON2_1ST_VS_ADDR                         0x1429  //L_STV1_VS_ADDR
#define MTCON2_1ST_VE_ADDR                         0x142a  //L_STV1_VE_ADDR
#define MTCON2_2ND_HS_ADDR                         0x142b  //L_STV2_HS_ADDR
#define MTCON2_2ND_HE_ADDR                         0x142c  //L_STV2_HE_ADDR
#define MTCON2_2ND_VS_ADDR                         0x142d  //L_STV2_VS_ADDR
#define MTCON2_2ND_VE_ADDR                         0x142e  //L_STV2_VE_ADDR

#define MTCON3_1ST_HS_ADDR                         0x142f  //L_OEV1_HS_ADDR
#define MTCON3_1ST_HE_ADDR                         0x1430  //L_OEV1_HE_ADDR
#define MTCON3_1ST_VS_ADDR                         0x1431  //L_OEV1_VS_ADDR
#define MTCON3_1ST_VE_ADDR                         0x1432  //L_OEV1_VE_ADDR
#define MTCON3_2ND_HS_ADDR                         0x1433  //L_OEV2_HS_ADDR
#define MTCON3_2ND_HE_ADDR                         0x1434  //L_OEV2_HE_ADDR
#define MTCON3_2ND_VS_ADDR                         0x1435  //L_OEV2_VS_ADDR
#define MTCON3_2ND_VE_ADDR                         0x1436  //L_OEV2_VE_ADDR

#define MTCON4_1ST_HS_ADDR                         0x1455  //L_HSYNC_HS_ADDR
#define MTCON4_1ST_HE_ADDR                         0x1456  //L_HSYNC_HE_ADDR
#define MTCON4_1ST_VS_ADDR                         0x1457  //L_HSYNC_VS_ADDR
#define MTCON4_1ST_VE_ADDR                         0x1458  //L_HSYNC_VE_ADDR

#define MTCON5_1ST_HS_ADDR                         0x1459  //L_VSYNC_HS_ADDR
#define MTCON5_1ST_HE_ADDR                         0x145a  //L_VSYNC_HE_ADDR
#define MTCON5_1ST_VS_ADDR                         0x145b  //L_VSYNC_VS_ADDR
#define MTCON5_1ST_VE_ADDR                         0x145c  //L_VSYNC_VE_ADDR

#define MTCON6_1ST_HS_ADDR                         0x1418  //L_OEH_HS_ADDR
#define MTCON6_1ST_HE_ADDR                         0x1419  //L_OEH_HE_ADDR
#define MTCON6_1ST_VS_ADDR                         0x141a  //L_OEH_VS_ADDR
#define MTCON6_1ST_VE_ADDR                         0x141b  //L_OEH_VE_ADDR

#define MTCON7_1ST_HS_ADDR                         0x1437  //L_OEV3_HS_ADDR
#define MTCON7_1ST_HE_ADDR                         0x1438  //L_OEV3_HE_ADDR
#define MTCON7_1ST_VS_ADDR                         0x1439  //L_OEV3_VS_ADDR
#define MTCON7_1ST_VE_ADDR                         0x143a  //L_OEV3_VE_ADDR

#endif

