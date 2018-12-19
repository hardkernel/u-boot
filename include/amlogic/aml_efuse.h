
/*
 *
 * Copyright (C) 2018 Amlogic, Inc. All rights reserved.
*/

#ifndef __BL2_EFUSE_H__
#define __BL2_EFUSE_H__

#if 0
//just keep following CFG10/9 for new API implement
#define IS_FEAT_USB_PD_CHK_ENABLE()   (readl(AO_SEC_SD_CFG10) & (1 << 1))
#define IS_FEAT_THERMAL_CALIBRATED()  (readl(AO_SEC_SD_CFG10) & (1 << 2))
#define IS_FEAT_BOOT_VERIFY()         (readl(AO_SEC_SD_CFG10) & (1 << 4))
#define IS_FEAT_ROOT_KEY_BURNED()     (readl(AO_SEC_SD_CFG10) & (1 << 5))
#define IS_FEAT_PLL_SET_BURNED()      (readl(AO_SEC_SD_CFG10) & (1 << 6))
#define IS_FEAT_M3_PLL_ENABLE()       (readl(AO_SEC_SD_CFG10) & (1 << 7))
#define IS_FEAT_M4_PLL_ENABLE()       (readl(AO_SEC_SD_CFG10) & (1 << 7))
#define IS_FEAT_A53_PLL_ENABLE()      (readl(AO_SEC_SD_CFG10) & (1 << 8))
#define IS_FEAT_NAMD_EXT_CMD_BURNED() (readl(AO_SEC_SD_CFG10) & (1 << 9))
#define IS_FEAT_JTG_PD_CHK_ENABLE()   (readl(AO_SEC_SD_CFG10) & (1 << 11))
#define IS_FEAT_JTG_ENABLE()          (readl(AO_SEC_SD_CFG10) & (1 << 12))
#define IS_FEAT_CHIP_ID_BURNED        (readl(AO_SEC_SD_CFG10) & (1 << 13))
#define IS_FEAT_DTS_ENABLE            (readl(AO_SEC_SD_CFG10) & (1 << 14))
#define IS_FEAT_DISK_ENC_ENABLE       (readl(AO_SEC_SD_CFG10) & (1 << 15))
#define IS_FEAT_DOLBY_AUDIO_ENABLE    (readl(AO_SEC_SD_CFG10) & (1 << 16))
#define IS_FEAT_SCN_PD_CHK_ENABLE     (readl(AO_SEC_SD_CFG10) & (1 << 17))
#define IS_FEAT_USB_BOOT_ENABLE       (readl(AO_SEC_SD_CFG10) & (1 << 19))
#define IS_FEAT_SPI_BOOT_ENABLE       (readl(AO_SEC_SD_CFG10) & (1 << 20))
#define IS_FEAT_RECOVERY_BOOT_ENABLE  (readl(AO_SEC_SD_CFG10) & (1 << 21))
#define IS_FEAT_SD_BOOT_ENABLE        (readl(AO_SEC_SD_CFG10) & (1 << 22))
#define IS_FEAT_NAND_EMMC_BOOT_ENABLE (readl(AO_SEC_SD_CFG10) & (1 << 23))
#define IS_FEAT_ANTIROLLBACK_ENABLE   (readl(AO_SEC_SD_CFG10) & (1 << 25))
#define IS_FEAT_BOOT_ENCRYPT()        (readl(AO_SEC_SD_CFG10) & (1 << 28))
#define IS_FEAT_A53_L1_ENABLE()       (readl(AO_SEC_SD_CFG10) & (1 << 29))
#define IS_FEAT_KEY_LDR_INIT()        (readl(AO_SEC_SD_CFG10) & (1 << 30))
#define IS_FEAT_AP_COLD_BOOT_LOCK()   (readl(AO_SEC_SD_CFG10) & (1 << 31))
#define IS_FEAT_BOOT_M3_ENCRYPT()     (readl(AO_SEC_SD_CFG9) & (1 << 5))
#define IS_FEAT_BOOT_M4_ENCRYPT()     (readl(AO_SEC_SD_CFG9) & (1 << 6))
#define IS_FEAT_NAND_BL2_BKP_RETRY()  (readl(AO_SEC_SD_CFG9) & (1 << 10))
#define IS_FEAT_EMMC_BL2_BKP_RETRY()  (readl(AO_SEC_SD_CFG9) & (1 << 11))
#define IS_FEAT_SCAN_DISABLE()        (readl(AO_SEC_SD_CFG9) & (1 << 12))
#define IS_FEAT_NAND_128P_DISABLE()   (readl(AO_SEC_SD_CFG9) & (1 << 13))
#define IS_FEAT_EMMC_LAST_ENABLE()    (readl(AO_SEC_SD_CFG9) & (1 << 14))
#define IS_FEAT_HIGH_USB_ENABLE()     (readl(AO_SEC_SD_CFG9) & (1 << 15))
#define IS_FEAT_BOOT_M3_VERIFY()      (readl(AO_SEC_SD_CFG9) & (1 << 16))
#define IS_FEAT_BOOT_M4_VERIFY()      (readl(AO_SEC_SD_CFG9) & (1 << 17))
#define IS_FEAT_CORNOR_INFO_BURNED()  (readl(AO_SEC_SD_CFG9) & (1 << 19))
#define IS_FEAT_SCK_BURNED()          (readl(AO_SEC_SD_CFG9) & (1 << 20))
#define IS_FEAT_BLK0_WR_LOCKED()      (readl(AO_SEC_SD_CFG9) & (1 << 21))
#define IS_FEAT_M4_DISABLE()          (readl(AO_SEC_SD_CFG9) & (1 << 22))
#define IS_FEAT_M4_SP_MODE_ENABLE()   (readl(AO_SEC_SD_CFG9) & (1 << 23))
#define IS_FEAT_A53_CLK_12G()         (readl(AO_SEC_SD_CFG9) & (1 << 24))
#define IS_FEAT_A53_CLK_15G()         (readl(AO_SEC_SD_CFG9) & (1 << 25))
#define IS_FEAT_A53_CLK_20G()         (readl(AO_SEC_SD_CFG9) & (1 << 26))
#define IS_FEAT_USB_PLL_ENABLE()      (readl(AO_SEC_SD_CFG9) & (1 << 27))
#define IS_FEAT_RMA_ENABLE()          (readl(AO_SEC_SD_CFG9) & (1 << 28))
#define IS_FEAT_OPS_CLI_BURNED()      (readl(AO_SEC_SD_CFG9) & (1 << 29))
#define IS_FEAT_M4_UNLOCK_ENABLE()    (readl(AO_SEC_SD_CFG9) & (1 << 31))
#define IS_FEAT_DISABLE_PRINT()       (readl(EFUSE_LIC0) & (1 << 22)))
#endif

//weak function for each SoC implement
//Unify EFUSE license query API
//all following functions are defined with "weak" for customization of each SoC
//EFUSE_LICX	--> AO_SEC_SD_CFG10/9 --> EFUSE mirror
int IS_FEAT_BOOT_VERIFY(void);
int IS_FEAT_BOOT_ENCRYPT(void);

#endif /* __BL2_EFUSE_H__ */
