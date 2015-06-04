/*
 * \file        sdc_bootPart_license.h
 * \brief       Interfaces to read/update license in boot part
 *
 * \version     1.0.0
 * \date        2015/3/10
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#ifndef __V2_SDC_BURN_SDC_BOOTPART_LICENSE_H__
#define __V2_SDC_BURN_SDC_BOOTPART_LICENSE_H__

#define AML_BOOT_PART_KEY_HEAD_OFFSET           (0x4U<<20)
#define AML_BOOT_PART_KEY_HEAD_MAGIC            0X2143494C  //"LIC!"
#define AML_BOOT_PART_KEY_HEAD_VERSION          0x01
#define AML_BOOT_PART_KEY_HEAD_SZ               (128)
#define AML_BOOT_PART_ALIGN_SZ                  (16)

#define AML_BOOT_PART_KEY_ITEM_MAGIC            0X4D455449  //"ITEM!"
#define AML_BOOT_PART_KEY_ITEM_VERSION          0x01
#define AML_BOOT_PART_KEY_ITEM_SZ               (128)
#define AML_BOOT_PART_KEY_ITEM_NAME_LEN         16

#pragma pack(push, 4)
typedef struct _bootPartKeyInf_head{
        unsigned int    hcrc;
        unsigned int    magic;

        unsigned int    version;
        unsigned int    alignSz;

        unsigned int    imgSz;
        unsigned int    imgItemNum;

        unsigned char   reserv[AML_BOOT_PART_KEY_HEAD_SZ - sizeof(unsigned int) * 6];
}BootPartKeyInf_head_t;
#pragma pack(pop)

#pragma pack(push, 4)
typedef struct _bootPartKeyInf_Item{
        unsigned int    magic;
        unsigned int    version;

        unsigned int    itemIndex;
        unsigned int    itemSz;//including this inf head

        unsigned int    nextItemInfOffset;
        unsigned int    reserv;

        unsigned char   keyName[AML_BOOT_PART_KEY_ITEM_NAME_LEN];

        unsigned char   resv1[AML_BOOT_PART_KEY_ITEM_SZ - sizeof(unsigned) * 6 - AML_BOOT_PART_KEY_ITEM_NAME_LEN];
}BootPartKeyInf_Item_t;
#pragma pack(pop)

//Read license inf from external emmc boot part
int optimus_sdc_bootPart_lic_download(void);

//update the license inf to external mmc boot part
int optimus_sdc_bootPart_lic_upload(void);

int optimus_sdc_bootPart_lic_get_key_infdata(const char* keyName, void** keyInfAddr);

//add an key info item if any, or update it
int optimus_sdc_bootPart_lic_update_key_inf(const char* keyName, unsigned char* keyVal, unsigned int keyLen);

#endif//ifndef __V2_SDC_BURN_SDC_BOOTPART_LICENSE_H__

