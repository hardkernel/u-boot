/*
 * \file        sdc_bootPart_license.c
 * \brief
 *
 * \version     1.0.0
 * \date        2015/3/10
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#include "../optimus_sdc_burn_i.h"
#include "sdc_bootPart_license.h"
#include <crc.h>

COMPILE_TYPE_CHK(AML_BOOT_PART_KEY_HEAD_SZ == sizeof(BootPartKeyInf_head_t), _aa1);
COMPILE_TYPE_CHK(AML_BOOT_PART_KEY_ITEM_SZ == sizeof(BootPartKeyInf_Item_t), _aa2);

#define _OPT_BOOT_PART_LIC_INFO_LOADADDR        (OPTIMUS_DOWNLOAD_SPARSE_INFO_FOR_VERIFY)
#define _pOptBootPartLicHeadInf                 (BootPartKeyInf_head_t*)(_OPT_BOOT_PART_LIC_INFO_LOADADDR)

//Load boot part license info from external emmc to memory
//As "mmc read" is slow, I load it from external mmc only once
int optimus_sdc_bootPart_lic_download(void)
{
        const unsigned maxLen = 2U<<20;//
        const unsigned firstReadLen = 2U<<10;//2K
        const char* _cmdStr =  "mmc read 1 0x%x, 0x%x 0x%x";
        BootPartKeyInf_head_t* pBootPartKeyInfHead      = _pOptBootPartLicHeadInf;
        char _cmdBuf[96];
        int rc = 0;

//1, Read from _OPT_BOOT_PART_LIC_INFO_LOADADDR
        rc = run_command("mmcinfo", 0);
        if (rc) {
                DWN_ERR("Fail to init external sdcard\n");
                return __LINE__;
        }

        memset(pBootPartKeyInfHead, 0, AML_BOOT_PART_KEY_HEAD_SZ + AML_BOOT_PART_KEY_ITEM_SZ * 64);
        sprintf(_cmdBuf, _cmdStr, _OPT_BOOT_PART_LIC_INFO_LOADADDR, AML_BOOT_PART_KEY_HEAD_OFFSET, firstReadLen);
        DWN_MSG("cmd[%s]\n", _cmdBuf);
        rc = run_command(_cmdBuf, 0);
        if (rc) {
                DWN_ERR("Fail in cmd[%s]\n", _cmdBuf);
                return __LINE__;
        }

        rc = (AML_BOOT_PART_KEY_HEAD_VERSION == pBootPartKeyInfHead->version)
                && (AML_BOOT_PART_KEY_HEAD_MAGIC == pBootPartKeyInfHead->magic);
        if (!rc)
        {
                DWN_MSG("Ver[0x%x] or magic[0x%8x] error\n",
                                pBootPartKeyInfHead->version, pBootPartKeyInfHead->magic);
                //Create the image header
                pBootPartKeyInfHead->magic      = AML_BOOT_PART_KEY_HEAD_MAGIC;
                pBootPartKeyInfHead->version    = AML_BOOT_PART_KEY_HEAD_VERSION;
                pBootPartKeyInfHead->alignSz    = AML_BOOT_PART_ALIGN_SZ;
                pBootPartKeyInfHead->imgSz      = sizeof(BootPartKeyInf_head_t);
                pBootPartKeyInfHead->imgItemNum = 0;

                return 0;
        }
        const unsigned totalLen = pBootPartKeyInfHead->imgSz;
        if (totalLen > maxLen) {
                DWN_ERR("totalLen=0x%x > max=0x%x\n", totalLen, maxLen);
                return __LINE__;
        }

        DWN_MSG("totalLen=0x%x\n", totalLen);
        const unsigned genCrc = crc32(0, (u8*)&pBootPartKeyInfHead->magic,
                        totalLen - sizeof(unsigned int));
        if (genCrc != pBootPartKeyInfHead->hcrc) {
                DWN_ERR("genCrc(0x%x) != savedCrc(0x%x), pls clear the card using tool\n",
                                genCrc, pBootPartKeyInfHead->hcrc);
                return __LINE__;
        }
        DWN_MSG("genCrc=0x%x\n", genCrc);

        if (totalLen > firstReadLen)
        {
                const unsigned leftLen  = totalLen - firstReadLen;
                sprintf(_cmdBuf, _cmdStr, _OPT_BOOT_PART_LIC_INFO_LOADADDR,
                                AML_BOOT_PART_KEY_HEAD_OFFSET + firstReadLen, leftLen);
                DWN_MSG("cmd[%s]\n", _cmdBuf);
                rc = run_command(_cmdBuf, 0);
                if (rc) {
                        DWN_ERR("Fail in cmd[%s]\n", _cmdBuf);
                        return __LINE__;
                }
        }

        return 0;
}

int optimus_sdc_bootPart_lic_upload(void)
{
        const char* _cmdStr =  "mmc write 1 0x%x, 0x%x 0x%x";
        BootPartKeyInf_head_t* pBootPartKeyInfHead      = _pOptBootPartLicHeadInf;
        char _cmdBuf[96];
        int rc = 0;

        rc = (AML_BOOT_PART_KEY_HEAD_VERSION == pBootPartKeyInfHead->version)
                && (AML_BOOT_PART_KEY_HEAD_MAGIC == pBootPartKeyInfHead->magic);
        if (!rc) {
                DWN_MSG("Ver[0x%x] or magic[0x%8x] error\n",
                                pBootPartKeyInfHead->version, pBootPartKeyInfHead->magic);
                return __LINE__;
        }

        rc = run_command("mmcinfo", 0);
        if (rc) {
                DWN_ERR("Fail to init external sdcard\n");
                return __LINE__;
        }
        DWN_MSG("imgSz=0x%x\n", pBootPartKeyInfHead->imgSz);
        //Update crc32 in image header
        const unsigned genCrc = crc32(0, (u8*)&pBootPartKeyInfHead->magic,
                        pBootPartKeyInfHead->imgSz - sizeof(unsigned int));
        pBootPartKeyInfHead->hcrc = genCrc;
        DWN_MSG("genCrc=0x%x\n", genCrc);

        const unsigned totalLen = pBootPartKeyInfHead->imgSz;
        sprintf(_cmdBuf, _cmdStr, _OPT_BOOT_PART_LIC_INFO_LOADADDR, AML_BOOT_PART_KEY_HEAD_OFFSET, totalLen);
        rc = run_command(_cmdBuf, 0);
        if (rc) {
                DWN_ERR("Fail in cmd[%s]\n", _cmdBuf);
                return __LINE__;
        }

        return 0;
}

//* keyInfAddr is sizeof the key info
//
//*/
int optimus_sdc_bootPart_lic_get_key_infdata(const char* keyName, void** keyInfAddr)
{
        BootPartKeyInf_head_t* pBootPartKeyInfHead      = _pOptBootPartLicHeadInf;
        BootPartKeyInf_Item_t* pBootPartKeyItemInf      = (BootPartKeyInf_Item_t*)(pBootPartKeyInfHead + 1);
        const unsigned itemCnt                          = pBootPartKeyInfHead->imgItemNum;
        int rc                                          = 0;
        int itemIndex                                   = 0;

        *keyInfAddr = NULL;

        DWN_MSG("Get lic info for key[%s]\n", keyName);
        //2, check _pOptBootPartLicHeadInf
        rc = (AML_BOOT_PART_KEY_HEAD_VERSION == pBootPartKeyInfHead->version)
                && (AML_BOOT_PART_KEY_HEAD_MAGIC == pBootPartKeyInfHead->magic);
        if (!rc) {
                DWN_MSG("Ver[0x%x] or magic[0x%8x]\n",
                                pBootPartKeyInfHead->version, pBootPartKeyInfHead->magic);
                return 0;
        }

        //3, find the item and return the count, return 0 if not found
        for(itemIndex = 0; itemIndex < itemCnt; ++itemIndex,
                        pBootPartKeyItemInf = (BootPartKeyInf_Item_t*)(pBootPartKeyItemInf->nextItemInfOffset + _OPT_BOOT_PART_LIC_INFO_LOADADDR))
        {
                const unsigned char* theKeyName = pBootPartKeyItemInf->keyName;

                rc = memcmp(keyName, theKeyName, strlen(keyName));
                if (rc) continue;
                *keyInfAddr = ++pBootPartKeyItemInf;
                return 0;
        }

        return 0;
}

//add an key info item if any, or update it
int optimus_sdc_bootPart_lic_update_key_inf(const char* keyName, unsigned char* keyVal, unsigned int keyLen)
{
        BootPartKeyInf_head_t* pBootPartKeyInfHead      = _pOptBootPartLicHeadInf;
        BootPartKeyInf_Item_t* pBootPartKeyItemInf      = (BootPartKeyInf_Item_t*)(pBootPartKeyInfHead + 1);
        const unsigned itemCnt                          = pBootPartKeyInfHead->imgItemNum;
        int rc                                          = 0;
        int itemIndex                                   = 0;

        DWN_MSG("update lic info for key[%s]\n", keyName);
        //2, check _pOptBootPartLicHeadInf
        rc = (AML_BOOT_PART_KEY_HEAD_VERSION == pBootPartKeyInfHead->version)
                && (AML_BOOT_PART_KEY_HEAD_MAGIC == pBootPartKeyInfHead->magic);
        if (!rc) {
                DWN_MSG("Ver[0x%x] or magic[0x%8x]\n",
                                pBootPartKeyInfHead->version, pBootPartKeyInfHead->magic);
                return __LINE__;
        }

        BootPartKeyInf_Item_t* prevItemInf = NULL;
        //3, find the item and return the count, return 0 if not found
        for(itemIndex = 0; itemIndex < itemCnt; ++itemIndex,
                        prevItemInf     = pBootPartKeyItemInf,
                        pBootPartKeyItemInf = (BootPartKeyInf_Item_t*)(pBootPartKeyItemInf->itemSz + (unsigned long)pBootPartKeyItemInf))
        {
                const unsigned char* theKeyName = pBootPartKeyItemInf->keyName;

                rc = memcmp(keyName, theKeyName, strlen(keyName));
                if (rc) continue;

                if (AML_BOOT_PART_KEY_ITEM_MAGIC != pBootPartKeyItemInf->magic) {
                        DWN_ERR("Excp: item magic 0x%x eror, must be 0x%x\n",
                                        pBootPartKeyItemInf->magic, AML_BOOT_PART_KEY_ITEM_MAGIC);
                        return __LINE__;
                }
                //write key founded, update the total data
                DWN_MSG("Find item at index %d\n", itemIndex);
                if (pBootPartKeyItemInf->itemSz != keyLen + sizeof(BootPartKeyInf_Item_t)) {
                        DWN_ERR("Excp: oldlen %d != newlen %d\n", pBootPartKeyItemInf->itemSz, keyLen);
                        return __LINE__;
                }
                return 0;//To simple it just return
        }
        if (prevItemInf)
        {
                prevItemInf->nextItemInfOffset = (unsigned long)pBootPartKeyItemInf - _OPT_BOOT_PART_LIC_INFO_LOADADDR;
        }

        if (itemIndex != itemCnt) {
                DWN_ERR("Exp:itemIndex[%d] != itemCnt[%d]\n", itemIndex, itemCnt);
                return __LINE__;
        }
        memcpy(pBootPartKeyItemInf + 1, keyVal, keyLen);
        //update item info
        pBootPartKeyItemInf->itemIndex  = itemIndex;
        pBootPartKeyItemInf->itemSz     = keyLen + sizeof(BootPartKeyInf_Item_t);
        memcpy(pBootPartKeyItemInf->keyName, keyName, strlen(keyName));
        pBootPartKeyItemInf->version    = AML_BOOT_PART_KEY_ITEM_VERSION;
        pBootPartKeyItemInf->magic      = AML_BOOT_PART_KEY_ITEM_MAGIC;
        //
        //Update head info
        pBootPartKeyInfHead->imgSz += keyLen;
        ++pBootPartKeyInfHead->imgItemNum;

        return 0;

}

