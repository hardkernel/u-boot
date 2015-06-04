/*
 * \file        optimu_download.c
 * \brief
 *
 * \version     1.0.0
 * \date        2013/4/25
 * \author      Sam.Wu <yihui.wu@amlogic.com>
 *
 * Copyright (c) 2013 Amlogic Inc. All Rights Reserved.
 *
 */
#include "../v2_burning_i.h"
#include <libfdt.h>

#if defined(CONFIG_ACS)
#include <asm/arch/cpu.h>
#include <asm/arch/acs.h>
#include <partition_table.h>
#define MAGIC_ACS   "acs_"
#endif//#if defined(CONFIG_ACS)

extern unsigned int get_multi_dt_entry(unsigned int fdt_addr);
int is_optimus_storage_inited(void);

#ifndef CONFIG_UNIFY_KEY_MANAGE
int v2_key_read(const char* keyName, u8* keyVal, const unsigned keyValLen, char* errInfo, unsigned* fmtLen)
{
    DWN_ERR("burn key not supported as CONFIG_UNIFY_KEY_MANAGE undef!!");
    return OPT_DOWN_FAIL;
}

unsigned v2_key_burn(const char* keyName, const u8* keyVal, const unsigned keyValLen, char* errInfo)
{
    DWN_ERR("burn key not supported as CONFIG_UNIFY_KEY_MANAGE undef!!");
    return OPT_DOWN_FAIL;
}
#endif//#ifndef CONFIG_UNIFY_KEY_MANAGE


#define IMG_VERIFY_ALG_NONE     0 //not need to veryfy
#define IMG_VERIFY_ALG_SHA1SUM  1
#define IMG_VERIFY_ALG_CRC32    2
#define IMG_VERIFY_ALG_ADDSUM   3

#define OPTIMUS_IMG_STA_EMPTY           0
#define OPTIMUS_IMG_STA_PRE_BURN        1 //has get tplcmd load
#define OPTIMUS_IMG_STA_BURN_ING        2
#define OPTIMUS_IMG_STA_BURN_COMPLETE   3
#define OPTIMUS_IMG_STA_BURN_FAILED     4
#define OPTIMUS_IMG_STA_VERIFY_ING      5
#define OPTIMUS_IMG_STA_VERIFY_END      6

#define IMG_TYPE_SPARSE (0xfe)
#define IMG_TYPE_NORMAL 0
#define IMG_TYPE_BOOTLOADER (0xfd)

//Image info for burnning and verify
//FIXME: how to assert that image not larger than the partition
#define IMG_BURN_INFO_SZ    64
struct ImgBurnInfo{
    u8  imgType;    //0 normal, 1 sparse
    u8  verifyAlgorithm;//0--sha1sum, 1--crc32, 2--addsum
    u8  imgBurnSta;//
    u8  storageMediaType;//NAND default,
    u8  resrv4Align[4];

    u64 nextMediaOffset;//image size already  received
    u64 imgPktSz;//total size of the file image
    u64 imgSzDisposed;//total size alreay disposed
    u64 partBaseOffset;//start offset of this part

    void* devHdle;
    char partName[16];//

    u8  burnInfoPrivate[IMG_BURN_INFO_SZ - 16 - sizeof(void*) - sizeof(u64) * 5];//needed private info when verify, for example when we read ext4 to sparse file
};

static struct ImgBurnInfo OptimusImgBurnInfo = {0};

struct imgBurnInfo_sparse{

};

struct imgBurnInfo_normal{
};

struct imgBurnInfo_bootloader{
    u32     transferBufAddr;
    u32     transferBufSzTotal;

};

COMPILE_TIME_ASSERT(IMG_BURN_INFO_SZ == sizeof(struct ImgBurnInfo));

#if defined(CONFIG_ACS)
#if 0
static void _show_partition_table(const struct partitions* pPartsTab)
{
	int i=0;
	const struct partitions* partInfo = pPartsTab;

	for (i=0; i < MAX_PART_NUM; i++, ++partInfo)
    {
		if (partInfo->size == -1) {
			printf("part: %d, name : %10s, size : %-4s\n",i, partInfo->name, "end");
			break;
		}
        printf("part: %d, name : %10s, size : %-4llx\n",i, partInfo->name, partInfo->size);
	}

	return;
}
#endif

static int _check_partition_table_consistency(const unsigned uboot_bin)
{
    int rc = 0;
    unsigned partitionTableSz = 0;
    const int acsOffsetInSpl   = START_ADDR - AHB_SRAM_BASE;
    const int addrMapFromAhb2Bin = AHB_SRAM_BASE - uboot_bin;

    const struct acs_setting* acsSettingInBin   = NULL;
    unsigned partTabAddrInBin             = 0;
    const struct partitions*  partsTabInBin     = NULL;

    const struct acs_setting* acsSettingInSram  = NULL;
    const struct partitions*  partsTabInSram    = NULL;

    DWN_DBG("uboot_bin 0x%p, acsOffsetInSpl 0x%x, addrMapFromAhb2Bin 0x%x\n", uboot_bin, acsOffsetInSpl, addrMapFromAhb2Bin);
    acsSettingInBin   = (struct acs_setting*)(*(unsigned*)(uboot_bin + acsOffsetInSpl) - addrMapFromAhb2Bin);

    if ( (unsigned)acsSettingInBin >= uboot_bin + 64*1024 || (unsigned)acsSettingInBin <= uboot_bin) {//acs not in the spl
        DWN_MSG("Acs not in the spl of uboot_bin\n");
        return 0;
    }

    if (memcmp(MAGIC_ACS, acsSettingInBin->acs_magic, strlen(MAGIC_ACS))
        || memcmp(TABLE_MAGIC_NAME, acsSettingInBin->partition_table_magic, strlen(TABLE_MAGIC_NAME)))
    {
        DWN_MSG("acs magic OR part magic in ubootin not match\n");
        return 0;//Not to check partTable as acs magic or part magic not match in u-boot.bin, maybe encrypted by AMLETOOL
    }
    partTabAddrInBin  = acsSettingInBin->partition_table_addr - addrMapFromAhb2Bin;
    partsTabInBin     = (const struct partitions*)partTabAddrInBin;

#ifndef CONFIG_MESON_TRUSTZONE
    acsSettingInSram  = (struct acs_setting*)(*(unsigned*)START_ADDR);
#else
    //twice eget value at sram address and copy 1K to memory
    acsSettingInSram  = (struct acs_setting*)meson_trustzone_acs_addr(START_ADDR);
    DWN_MSG("[Trust]acsSettingInSram=0x%p\n", acsSettingInSram);
#endif// #ifndef CONFIG_MESON_TRUSTZONE
    partsTabInSram    = (const struct partitions*)acsSettingInSram->partition_table_addr;
    DWN_MSG("partsTabInSram=0x%p\n", partsTabInSram);

    if (memcmp(MAGIC_ACS, acsSettingInSram->acs_magic, strlen(MAGIC_ACS))
       || memcmp(TABLE_MAGIC_NAME, acsSettingInSram->partition_table_magic, strlen(TABLE_MAGIC_NAME)))
    {
        DWN_MSG("acs magic OR part magic in SPL not match\n");
        return __LINE__;//Not to check partTable as acs magic or part magic not match in SRAM, assert this!!
    }

#ifdef CONFIG_MESON_TRUSTZONE
    partsTabInSram    = (const struct partitions*)meson_trustzone_acs_addr((unsigned)&acsSettingInSram->partition_table_addr);
#endif// #ifndef CONFIG_MESON_TRUSTZONE

    partitionTableSz = acsSettingInBin->partition_table_length;
    DWN_MSG("acsSettingInBin=0x%x, partTabSz=0x%x\n", (unsigned int)acsSettingInBin, partitionTableSz);

    rc = memcmp(partsTabInSram, partsTabInBin, partitionTableSz);
    DWN_MSG("Check parts table %s\n", !rc ? "OK." : "FAILED!");
#if 0//I comment print as str-prefix function (strcmp, strcmp, and .etc) are all not reliable in uboot
    if (rc)
    {
        DWN_MSG("acs_setting    0x%p, 0x%p\n", acsSettingInBin, acsSettingInSram);
        DWN_MSG("partitions     0x%08x, 0x%p\n", partTabAddrInBin, partsTabInSram);
        DWN_MSG("partition_table_addr 0x%x, 0x%x\n", acsSettingInSram->partition_table_addr, acsSettingInBin->partition_table_addr);

        DWN_MSG("part in ubootbin:\n");
        _show_partition_table(partsTabInBin);

        DWN_MSG("part in spl:\n");
        _show_partition_table(partsTabInSram);
        return __LINE__;
    }
#endif//#if 0

    return rc;
}
#else
#define _check_partition_table_consistency(a)   0
#endif//#if defined(CONFIG_ACS)

#if 0
//asset nand logical partition size equals CFG size in storage.c
//nand often make mistake this size, emmc should always ok
static int _assert_logic_partition_cap(const char* thePartName, const uint64_t nandPartCap)
{
	extern struct partitions * part_table;

	struct partitions * thePart = NULL;

        for (thePart = part_table; NAND_PART_SIZE_FULL != thePart->size; ++thePart)
        {
                const uint64_t partSzInBytes = thePart->size;
                if (strcmp(thePartName, thePart->name)) continue;
                if (partSzInBytes != nandPartCap) {
                        DWN_ERR("partSz in ACS %llx != flash Sz %llx\n", partSzInBytes, nandPartCap);
                        return __LINE__;
                }

                break;
        }

	return 0;
}
#else
#define _assert_logic_partition_cap(...)        0
#endif

//return value is the actual size it write
static int optimus_download_bootloader_image(struct ImgBurnInfo* pDownInfo, u32 dataSzReceived, const u8* data)
{
    int ret = OPT_DOWN_OK;
    uint64_t size = dataSzReceived;

    if (dataSzReceived < pDownInfo->imgPktSz) {
        DWN_ERR("please write back bootloader after all data rx end.0x(%x, %x)\n", dataSzReceived, (u32)pDownInfo->imgPktSz);
        return 0;
    }

    ret = _check_partition_table_consistency((unsigned)data);
    if (ret) {
        DWN_ERR("Fail in _check_partition_table_consistency\n");
        return 0;
    }
    if (size > (1U<<20)) {
        DWN_ERR("uboot.bin size 0x%llx > 1M unsupported\n", size);
        return 0;
    }

    size = size <= 0x60000 ? 0x60000 : (1U<<20);//384K when non-secure_os, 1M when secure_os
    ret = store_boot_write((unsigned char*)data, 0, size);

    return ret ? 0 : dataSzReceived;
}

static int optimus_verify_bootloader(struct ImgBurnInfo* pDownInfo, u8* genSum)
{
    int ret = OPT_DOWN_OK;
    unsigned char* pBuf = (unsigned char*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR;
    uint64_t size = 0;

    /*size = 0x60000;////////////TODO:hardcode len!!*/
    size=pDownInfo->imgPktSz;
    ret = store_boot_read(pBuf, (u64)0, size);
    if (ret) {
        DWN_ERR("Fail to read bootloader\n");
        return __LINE__;
    }

    sha1_csum(pBuf, (u32)pDownInfo->imgPktSz, genSum);

    return ret;
}


u32 optimus_cb_simg_write_media(const unsigned destAddrInSec, const unsigned dataSzInBy, const char* data)
{
    int ret = OPT_DOWN_OK;
    unsigned char* partName = (unsigned char*)OptimusImgBurnInfo.partName;

    if (OPTIMUS_MEDIA_TYPE_STORE < OptimusImgBurnInfo.storageMediaType) {
        DWN_ERR("storage type %d not supported yet!\n", OptimusImgBurnInfo.storageMediaType);
        return OPT_DOWN_FAIL;
    }

    DWN_DBG("1addrOffset=0x%llx, dataSz=0x%x, data = 0x%p\t", (((u64)destAddrInSec)<<9), dataSzInBy, (void*)data);
    //FIXME:why dirty value if not convert to u64
    ret = store_write_ops(partName, (u8*)data, (((u64)destAddrInSec)<<9), (u64)dataSzInBy);
    if (ret) {
        DWN_ERR("Fail to write to media, ret = %d\n", ret);
        return 0;
    }

    return dataSzInBy;
}

//return value: the data size disposed
static u32 optimus_download_sparse_image(struct ImgBurnInfo* pDownInfo, u32 dataSz, const u8* data)
{
    u32 unParsedDataLen = 0;
    int flashOffset = 0;
    const u64 addrOffset = pDownInfo->nextMediaOffset;

    flashOffset = optimus_simg_to_media((char*)data, dataSz, &unParsedDataLen, ((u32)(addrOffset>>9)));
    if (flashOffset < 0) {
        DWN_ERR("Fail in parse simg. src 0x%p, size 0x%x, unParsedDataLen 0x%x, ret %d\n", data, dataSz, unParsedDataLen, flashOffset);
        return 0;
    }
    pDownInfo->nextMediaOffset += ((u64)flashOffset)<<9;

    return dataSz - unParsedDataLen;
}

//Normal image can write directly to NAND, best aligned to 16K when write
//FIXME: check it aligned to 16K when called
//1, write to media     2 -- save the verify info
static u32 optimus_download_normal_image(struct ImgBurnInfo* pDownInfo, u32 dataSz, const u8* data)
{
    int ret = 0;
    u64 addrOrOffsetInBy = pDownInfo->nextMediaOffset;

    DWN_DBG("addrOffset=0x%llx, dataSz=0x%x, data = 0x%p\n", addrOrOffsetInBy, dataSz, data);

    ret = store_write_ops((u8*)pDownInfo->partName, (u8*)data, addrOrOffsetInBy, (u64)dataSz);
    if (ret) {
        DWN_ERR("Fail to write to media\n");
        return 0;
    }

    pDownInfo->nextMediaOffset += dataSz;

    return dataSz;
}

static int optimus_storage_open(struct ImgBurnInfo* pDownInfo, const u8* data, const u32 dataSz)
{
    int ret = OPT_DOWN_OK;
    const char* partName = (const char*)pDownInfo->partName;
    const int imgType = pDownInfo->imgType;
    const int MediaType = pDownInfo->storageMediaType;

    if (!pDownInfo->imgSzDisposed && OPTIMUS_IMG_STA_PRE_BURN == pDownInfo->imgBurnSta)
    {
        DWN_MSG("Burn Start...\n");
        pDownInfo->imgBurnSta = OPTIMUS_IMG_STA_BURN_ING;
    }
    else if(pDownInfo->imgSzDisposed == pDownInfo->imgPktSz && OPTIMUS_IMG_STA_BURN_COMPLETE == pDownInfo->imgBurnSta)
    {
        DWN_MSG("Verify Start...\n");
        pDownInfo->imgBurnSta = OPTIMUS_IMG_STA_VERIFY_ING;
    }

    switch (MediaType)
    {
        case OPTIMUS_MEDIA_TYPE_NAND:
        case OPTIMUS_MEDIA_TYPE_SDMMC:
        case OPTIMUS_MEDIA_TYPE_STORE:
            {
                if (IMG_TYPE_BOOTLOADER != pDownInfo->imgType && !pDownInfo->devHdle) //if not bootloader and device not open
                {
                    /*pDownInfo->devHdle = aml_nftl_get_dev(partName);*/
                    pDownInfo->devHdle = (void*)1;
                    if (!pDownInfo->devHdle) {
                        DWN_ERR("Fail to open nand part %s\n", partName);
                        return OPT_DOWN_FAIL;
                    }

                    if (IMG_TYPE_SPARSE == imgType)
                    {
                        ret = optimus_simg_probe(data, dataSz);
                        if (!ret) {
                            DWN_ERR("Fail in sparse format probe,ret=%d\n", ret);
                            return OPT_DOWN_FAIL;
                        }
                        return optimus_simg_parser_init(data);
                    }
                }
                else//is bootloader, than do nothing
                {
                    return OPT_DOWN_OK;
                }
            }
            break;

        case OPTIMUS_MEDIA_TYPE_KEY_UNIFY:
            break;

        case OPTIMUS_MEDIA_TYPE_MEM:
            break;

        default:
            DWN_MSG("Error MediaType %d\n", MediaType);
            return OPT_DOWN_FAIL;
    }

    return ret;
}

static int optimus_storage_close(struct ImgBurnInfo* pDownInfo)
{
    if (pDownInfo->imgSzDisposed == pDownInfo->imgPktSz && OPTIMUS_IMG_STA_BURN_ING == pDownInfo->imgBurnSta)
    {
        pDownInfo->imgBurnSta = OPTIMUS_IMG_STA_BURN_COMPLETE;
        DWN_MSG("Burn complete\n");

        return OPT_DOWN_OK;
    }

    if (!pDownInfo->imgSzDisposed && OPTIMUS_IMG_STA_VERIFY_ING == pDownInfo->imgBurnSta)
    {
        pDownInfo->imgBurnSta = OPTIMUS_IMG_STA_VERIFY_END;
        DWN_MSG("Verify End\n");
        return OPT_DOWN_OK;
    }

    return OPT_DOWN_OK;
}


//return value is the data size that actual dealed
static u32 optimus_storage_write(struct ImgBurnInfo* pDownInfo, u64 addrOrOffsetInBy, unsigned dataSz, const u8* data, char* errInfo)
{
    u32 burnSz = 0;
    const u32 imgType = pDownInfo->imgType;
    const int MediaType = pDownInfo->storageMediaType;

    addrOrOffsetInBy += pDownInfo->partBaseOffset;
    DWN_DBG("[0x]Data %p, addrOrOffsetInBy %llx, dataSzInBy %x\n", data, addrOrOffsetInBy, dataSz);

    if (OPTIMUS_IMG_STA_BURN_ING != pDownInfo->imgBurnSta) {
        sprintf(errInfo, "Error burn sta %d\n", pDownInfo->imgBurnSta);
        DWN_ERR(errInfo);
        return 0;
    }

    switch (MediaType)
    {
        case OPTIMUS_MEDIA_TYPE_NAND:
        case OPTIMUS_MEDIA_TYPE_SDMMC:
        case OPTIMUS_MEDIA_TYPE_STORE:
            {
                switch (imgType)
                {
                    case IMG_TYPE_NORMAL:
                        burnSz = optimus_download_normal_image(pDownInfo, dataSz, data);
                        break;

                    case IMG_TYPE_BOOTLOADER:
                        burnSz = optimus_download_bootloader_image(pDownInfo, dataSz, data);
                        break;

                    case IMG_TYPE_SPARSE:
                        burnSz = optimus_download_sparse_image(pDownInfo, dataSz, data);
                        break;

                    default:
                        DWN_ERR("error image type %d\n", imgType);
                }
            }
            break;

        case OPTIMUS_MEDIA_TYPE_KEY_UNIFY:
            {
                burnSz = v2_key_burn(pDownInfo->partName, data, dataSz, errInfo);
                if (burnSz != dataSz) {//return value is write size
                    DWN_ERR("burn key failed\n");
                    return 0;
                }
            }
            break;

        case OPTIMUS_MEDIA_TYPE_MEM:
        {
            u8* buf = (u8*)addrOrOffsetInBy;
            if (buf != data) {
                DWN_ERR("buf(%llx) != data(%p)\n", addrOrOffsetInBy, data);
                return 0;
            }
            if (!strcmp("dtb", pDownInfo->partName)) //as memory write back size = min[fileSz, 2G], so reach here if downloaded ok!
            {
                int rc = 0;
                char* dtbLoadAddr = NULL;//(char*)CONFIG_DTB_LOAD_ADDR;
                const int DtbMaxSz = (2U<<20);
                unsigned fdtSz = 0;
                unsigned char* destDtb = (unsigned char*)data;

                //Make sure flash already inited before 'run aml_dt'
                //old tool will download dtb before 'disk_initial', but new tool will 'disk_initial' first
                if (is_optimus_storage_inited() ||
                                (OPTIMUS_WORK_MODE_USB_PRODUCE != optimus_work_mode_get()))
                {
                        /*destDtb = (unsigned char*)(uint64_t)get_multi_dt_entry((unsigned int)data);*/
                        destDtb = NULL;
                }
                rc = fdt_check_header(destDtb);
                if (rc) {
                    sprintf(errInfo, "failed at fdt_check_header\n");
                    DWN_ERR(errInfo);
                    return 0;
                }
                fdtSz = fdt_totalsize(destDtb);
                if (DtbMaxSz <= fdtSz) {
                    sprintf(errInfo, "failed: fdt header ok but sz 0%x > max 0x%x\n", fdtSz, DtbMaxSz);
                    DWN_ERR(errInfo);
                    return 0;
                }

                DWN_MSG("load dtb to 0x%p\n", dtbLoadAddr);
                memcpy(dtbLoadAddr, destDtb, fdtSz);
            }

            burnSz = dataSz;
        }
        break;

        default:
            sprintf(errInfo, "Error MediaType %d\n", MediaType);
            DWN_ERR(errInfo);
    }

    return burnSz;
}

//TODO: to consist with optimus_storage_write, return value should be readSzInBy
static int optimus_storage_read(struct ImgBurnInfo* pDownInfo, u64 addrOrOffsetInBy,
                            unsigned readSzInBy, unsigned char* buff, char* errInfo)
{
    int ret = 0;
    const int MediaType = pDownInfo->storageMediaType;
    unsigned char* partName = (unsigned char*)pDownInfo->partName;

    addrOrOffsetInBy += pDownInfo->partBaseOffset;

    switch (MediaType)
    {
        case OPTIMUS_MEDIA_TYPE_NAND:
        case OPTIMUS_MEDIA_TYPE_SDMMC:
        case OPTIMUS_MEDIA_TYPE_STORE:
            {
                if (IMG_TYPE_BOOTLOADER == pDownInfo->imgType)
                {
                    ret = store_boot_read(buff, addrOrOffsetInBy, (u64)readSzInBy);
                }
                else
                {
                    ret = store_read_ops(partName, buff, addrOrOffsetInBy, (u64)readSzInBy);
                }
                if (ret) {
                    if (errInfo) sprintf(errInfo, "Read failed\n") ;
                    DWN_ERR("Read failed\n");
                    return OPT_DOWN_FAIL;
                }

            }
            break;

        case OPTIMUS_MEDIA_TYPE_KEY_UNIFY:
            {
                unsigned fmtLen = 0;
                if (addrOrOffsetInBy) {
                    DWN_ERR("OH NO, IS key len > 64K!!? addrOrOffsetInBy is 0x%llx not 0\n", addrOrOffsetInBy);
                    return OPT_DOWN_FAIL;
                }
                ret = v2_key_read(pDownInfo->partName, buff, readSzInBy, errInfo, &fmtLen);
            }
            break;

        case OPTIMUS_MEDIA_TYPE_MEM:
        {
            u8* buf = (u8*)addrOrOffsetInBy;
            if (addrOrOffsetInBy >> 32) {
                DWN_ERR("mem addr 0x%llx too large\n", addrOrOffsetInBy);
            }
            if (buf != buff) {
                DWN_ERR("buf(%llx) != buff(%p)\n", addrOrOffsetInBy, buff);
            }
        }
        break;

        default:
            DWN_MSG("Error MediaType %d\n", MediaType);
            return OPT_DOWN_FAIL;
    }

    return ret;
}

//return value is the size actual write to media
//Paras: const char* partName, const char* imgType, const char* verifyAlgorithm
static u32 optimus_func_download_image(struct ImgBurnInfo* pDownInfo, u32 dataSz, const u8* data, char* errInfo)
{
    int burnSz = 0;
    int ret = 0;
    u64 nextMediaOffset = pDownInfo->nextMediaOffset;

    DWN_DBG("data=0x%p, sz=0x%x, offset=%llx\n", data, dataSz, nextMediaOffset);

    ret = optimus_storage_open(pDownInfo, data, dataSz);
    if (OPT_DOWN_OK != ret) {
        sprintf(errInfo, "Fail to open stoarge\n");
        DWN_ERR(errInfo);
        return 0;
    }

    burnSz = optimus_storage_write(pDownInfo, nextMediaOffset, dataSz, data, errInfo);
    if (!burnSz) {
        DWN_ERR("Fail in optimus_storage_write, data 0x%p, wantSz 0x%x\n", data, dataSz);
        goto _err;
    }
    pDownInfo->imgSzDisposed += burnSz;

    ret = optimus_storage_close(pDownInfo);
    if (ret) {
        DWN_ERR("Fail to close media\n");
        return 0;
    }

    return burnSz;

_err:
    optimus_storage_close(pDownInfo);
    pDownInfo->imgBurnSta = OPTIMUS_IMG_STA_BURN_FAILED;////
    return 0;
}

//TODO: add _errInfo as argument to pass more info
static int _parse_img_download_info(struct ImgBurnInfo* pDownInfo, const char* partName,
                                     const u64 imgSz, const char* imgType, const char* mediaType, const u64 partBaseOffset)
{
    u64 partCap = 0;
    int ret = 0;

    memset(pDownInfo, 0, sizeof(struct ImgBurnInfo));//clear burnning info

    //TODO: check format is normal/bootloader if upload!!

    if (!strcmp("sparse", imgType))
    {
        pDownInfo->imgType = IMG_TYPE_SPARSE;
    }
    else if(!strcmp("bootloader", partName))
    {
        pDownInfo->imgType = IMG_TYPE_BOOTLOADER;
    }
    else if(!strcmp("normal", imgType))
    {
        pDownInfo->imgType = IMG_TYPE_NORMAL;
    }
    else{
        DWN_ERR("err image type %s\n", imgType);
        return __LINE__;
    }

    if (!strcmp("store", mediaType))
    {
        pDownInfo->storageMediaType = OPTIMUS_MEDIA_TYPE_STORE;
    }
    else if(!strcmp("nand", mediaType))
    {
        pDownInfo->storageMediaType = OPTIMUS_MEDIA_TYPE_NAND;
    }
    else if(!strcmp("sdmmc", mediaType))
    {
        pDownInfo->storageMediaType = OPTIMUS_MEDIA_TYPE_SDMMC;
    }
    else if(!strcmp("spiflash", mediaType))
    {
        pDownInfo->storageMediaType = OPTIMUS_MEDIA_TYPE_SPIFLASH;
    }
    else if(!strcmp("key", mediaType))
    {
        pDownInfo->storageMediaType = OPTIMUS_MEDIA_TYPE_KEY_UNIFY;

        if (OPTIMUS_DOWNLOAD_SLOT_SZ <= imgSz) {
            DWN_ERR("size (0x%llx) for key %s invalid!!\n", imgSz, partName);
            return __LINE__;
        }
    }
    else if(!strcmp("mem", mediaType))
    {
        pDownInfo->storageMediaType = OPTIMUS_MEDIA_TYPE_MEM;
    }
    else{
        DWN_ERR("error mediaType %s\n", mediaType);
        return __LINE__;
    }

    pDownInfo->partBaseOffset   = partBaseOffset;
    memcpy(pDownInfo->partName, partName, strlen(partName));

    if (OPTIMUS_MEDIA_TYPE_MEM > pDownInfo->storageMediaType) //if command for burning partition
    {
        if (strcmp("bootloader", partName)) //get size if not bootloader
        {
            ret = store_get_partititon_size((u8*)partName, &partCap);
            if (ret) {
                DWN_ERR("Fail to get size for part %s\n", partName);
                return __LINE__;
            }
            partCap <<= 9;//trans sector to byte
            DWN_MSG("flash LOGIC partCap 0x%llxB\n", partCap);
            if (imgSz > partCap) {
                DWN_ERR("imgSz 0x%llx out of cap 0x%llx\n", imgSz, partCap);
                return __LINE__;
            }
            ret = _assert_logic_partition_cap(partName, partCap);
            if (ret) {
                    DWN_ERR("Fail in _assert_logic_partition_cap\n");
                    return __LINE__;
            }
        }
    }

    pDownInfo->nextMediaOffset  = pDownInfo->imgSzDisposed = 0;
    pDownInfo->imgPktSz         = imgSz;
    pDownInfo->imgBurnSta       = OPTIMUS_IMG_STA_PRE_BURN;

    DWN_MSG("Down(%s) part(%s) sz(0x%llx) fmt(%s)\n", mediaType, partName, pDownInfo->imgPktSz, imgType);

    return 0;
}

int optimus_download_init(void)
{
    memset(&OptimusImgBurnInfo, 0, sizeof(struct ImgBurnInfo));
    return 0;
}

int optimus_download_exit(void)
{
    return 0;
}

int optimus_parse_img_download_info(const char* partName, const u64 imgSz, const char* imgType, const char* mediaType, const u64 partBaseOffset)
{
    return _parse_img_download_info(&OptimusImgBurnInfo, partName, imgSz, imgType, mediaType, partBaseOffset);
}

static int _disk_intialed_ok = 0;

int is_optimus_storage_inited(void)
{
        return _disk_intialed_ok;
}

int optimus_storage_init(int toErase)
{
    int ret = 0;
    char* cmd = NULL;

    if (_disk_intialed_ok) {//To assert only actual disk intialed once
        DWN_MSG("Disk inited again.\n");
        return 0;
    }

    if (OPTIMUS_WORK_MODE_USB_PRODUCE != optimus_work_mode_get()) //Already inited in other work mode
    {
        DWN_MSG("Exit before re-init\n");
        store_exit();
    }

    switch (toErase)
    {
        case 0://NO erase
            ret = store_init(1);
            break;

        case 3://erase all(with key)
            {
                cmd = "store disprotect key";
                DWN_MSG("run cmd [%s]\n", cmd);
                ret = run_command(cmd, 0);
                if (ret) {
                    DWN_ERR("Fail when run cmd[%s], ret %d\n", cmd, ret);
                    break;
                }
            }
        case 1://normal erase, store init 3
            ret = store_init(3);
            break;

        case 4://force erase all
            {
                cmd = "store disprotect key; store disprotect hynix";
                DWN_MSG("run cmd [%s]\n", cmd);
                ret = run_command(cmd, 0);
                if (ret) {
                    DWN_ERR("Fail when run cmd[%s], ret %d\n", cmd, ret);
                    break;
                }
            }
        case 2:
            ret = store_init(4);
            break;

        default:
            DWN_ERR("Unsupported erase flag %d\n", toErase); ret = -__LINE__;
            break;
    }

    if (!ret)
    {
        _disk_intialed_ok  = 1;
        _disk_intialed_ok += toErase <<16;

        if (OPTIMUS_WORK_MODE_USB_PRODUCE == optimus_work_mode_get()) //env not relocated in this case
        {
            DWN_MSG("usb producing env_relocate\n");
            env_relocate();
        }
    }

    return ret;
}

int optimus_storage_exit(void)
{
    _disk_intialed_ok = 0;
    DWN_MSG("store_exit yet!!\n");
    return store_exit();
}

int is_optimus_on_burn(void)//is now transfering image
{
    return (OPTIMUS_IMG_STA_BURN_ING == OptimusImgBurnInfo.imgBurnSta);
}

int is_optimus_pre_burn(void)    //is now has get "download command"
{
    return (OPTIMUS_IMG_STA_PRE_BURN == OptimusImgBurnInfo.imgBurnSta);
}

int is_optimus_to_burn_ready(void)
{
    return (OPTIMUS_IMG_STA_PRE_BURN == OptimusImgBurnInfo.imgBurnSta);
}

int is_optimus_burn_complete(void)
{
    int is_burn_completed = 0;

    is_burn_completed = (OPTIMUS_IMG_STA_BURN_COMPLETE == OptimusImgBurnInfo.imgBurnSta);
    if (!is_burn_completed) {
        DWN_MSG("imgSzDisposed 0x%llx != imgPktSz 0x%llx\n", OptimusImgBurnInfo.imgSzDisposed, OptimusImgBurnInfo.imgPktSz);
    }

    return is_burn_completed;
}

u32 optimus_download_img_data(const u8* data, const u32 size, char* errInfo)
{
    return optimus_func_download_image(&OptimusImgBurnInfo, size, data, errInfo);
}

static int optimus_sha1sum_verify_partition(const char* partName, const u64 verifyLen, const u8 imgType, u8* genSum)
{
    int ret = 0;
    u8* buff = (u8*) OPTIMUS_SHA1SUM_BUFFER_ADDR;
    const u32 buffSz = OPTIMUS_SHA1SUM_BUFFER_LEN;
    sha1_context ctx;
    u64 leftLen = verifyLen;

    if (strcmp(partName, OptimusImgBurnInfo.partName)) {
        DWN_ERR("partName %s err, must %s\n", partName, OptimusImgBurnInfo.partName);
        return OPT_DOWN_FAIL;
    }

    if (!is_optimus_burn_complete()) {
        return OPT_DOWN_FAIL;
    }

    memset(buff, 0xde, 1024);//clear 1kb data before verfiy, in case read buffer not overlapped
    if (IMG_TYPE_BOOTLOADER == imgType)
    {
        return optimus_verify_bootloader(&OptimusImgBurnInfo, genSum);
    }
    else if(IMG_TYPE_SPARSE == imgType)//sparse image
    {
        ret = optimus_sparse_back_info_probe();
        if (OPT_DOWN_TRUE != ret) {
            DWN_ERR("Fail to probe back sparse info\n");
            return OPT_DOWN_FAIL;
        }
    }

    ret = optimus_storage_open(&OptimusImgBurnInfo, NULL, 0);
    if (ret) {
        DWN_ERR("Fail to open storage for read\n");
        return OPT_DOWN_FAIL;
    }

    sha1_starts(&ctx);

    DWN_MSG("To verify part %s in fmt %s\n", partName, (IMG_TYPE_SPARSE == imgType) ? "sparse": "normal");
    if (IMG_TYPE_SPARSE == imgType) //sparse image
    {
        for (; leftLen;)
        {
            u32 spHeadSz   = 0;
            u32 chunkDataLen    = 0;
            u64 chunkDataOffset = 0;
            u8* head = NULL;

            ret = optimus_sparse_get_chunk_data(&head, &spHeadSz, &chunkDataLen, &chunkDataOffset);
            if (ret) {
                DWN_ERR("Fail to get chunk data\n");
                goto _finish;
            }

            sha1_update(&ctx, head, spHeadSz);

            leftLen -= spHeadSz + chunkDataLen;//update image read info

            for (;chunkDataLen;)
            {
                const int thisReadLen = (chunkDataLen > buffSz) ? buffSz : chunkDataLen;

                ret = optimus_storage_read(&OptimusImgBurnInfo, chunkDataOffset, thisReadLen, buff, NULL);
                if (ret) {
                    DWN_ERR("Fail to read at offset 0x[%x, %8x], len=0x%8x\n", ((u32)(chunkDataOffset>>32)), (u32)chunkDataOffset, thisReadLen);
                    goto _finish;
                }

                sha1_update(&ctx, buff, thisReadLen);

                chunkDataLen    -= thisReadLen;
                chunkDataOffset += thisReadLen;
            }

            if (leftLen && !spHeadSz) {
                DWN_ERR("Fail to read when pkt len left 0x%x\n", (u32)leftLen);
                break;
            }
        }
    }
    else//normal image
    {
        for (; leftLen;)
        {
            int thisReadLen = (leftLen > buffSz) ? buffSz : ((u32)leftLen);
            u64 addrOffset = verifyLen - leftLen;

            ret = optimus_storage_read(&OptimusImgBurnInfo, addrOffset, thisReadLen, buff, NULL);
            if (ret) {
                DWN_ERR("Fail to read at offset 0x[%x, %8x], len=0x%8x\n", ((u32)(addrOffset>>32)), (u32)addrOffset, thisReadLen);
                goto _finish;
            }

            sha1_update(&ctx, buff, thisReadLen);

            leftLen -= thisReadLen;
        }

    }

_finish:
    OptimusImgBurnInfo.imgSzDisposed = leftLen;
    sha1_finish(&ctx, genSum);
    optimus_storage_close(&OptimusImgBurnInfo);

    return ret;
}

//usage: verify sha1sum nand srcSum part_name size imgType
int optimus_media_download_verify(const int argc, char * const argv[], char *info)
{
    const char* verifyType      = argv[1];
    const char* srcSum          = argv[2];
    static u8  verifyResult[20];
    static char sha1Result[42];
    const u8 srcImgType = OptimusImgBurnInfo.imgType;
    const char* partName = OptimusImgBurnInfo.partName;
    u64 verifyLen = OptimusImgBurnInfo.imgPktSz;
    int ret = 0;

	if (argc != 3) {
		strcpy(info, "failed:need 3 args\n");
        printf(info);
		return -1;
	}

    if (strcmp(verifyType, "sha1sum")) {
        ret = __LINE__;
        sprintf(info, "verifyType [%s] err, ret %d!\n", verifyType, ret);
        DWN_ERR(info);
        return ret;
    }

    ret = optimus_sha1sum_verify_partition(partName, verifyLen, srcImgType, verifyResult);
    if (ret) {
        DWN_ERR("Fail to gen check sum\n");
        return __LINE__;
    }

    ret = optimus_hex_data_2_ascii_str(verifyResult, 20, sha1Result, 42);
    if (ret) {
        DWN_ERR("Failed when format sha1 to string\n");
        return __LINE__;
    }

    /*DWN_MSG("%s %s\n", verifyType, sha1Result);*/
    ret = strcmp(sha1Result, srcSum);
    if (ret) {
        sprintf(info, "failed:Verify Failed with %s, origin sum \"%s\" != gen sum \"%s\"\n", verifyType, srcSum, sha1Result);
        DWN_ERR(info);
        return __LINE__;
    }

    DWN_MSG("VERIFY OK \n");
    return ret;
}

int optimus_key_burn_init(const char* keyType)
{
    int ret = 0;

    if (!strcmp("efuse", keyType))
    {
        return ret;
    }

    if (!strcmp("secure", keyType))
    {
        return ret;
    }

    DWN_ERR("unsported key type %s\n", keyType);
    return OPT_DOWN_FAIL;
}

//update tplcmd dev0 "download nand part_name imageType imgSz"
//update tplcmd dev0 "download get_status"
int optimus_parse_download_cmd(int argc, char* argv[])
{
    const int isUpload = !strcmp("upload", argv[0]);
    const char* mediaType   = argv[1];
    const char* part_name   = argv[2];
    const char* imgType     = argv[3];
    const char* imgSzStr    = argv[4];
    u64   imgSzInBy   = 0;
    u64   partBaseOffset = 0;
    int ret = 0;

    if (!strcmp("get_status", mediaType))
    {
        return !is_optimus_burn_complete();
    }

    if (!strcmp("is_ready", mediaType))
    {
        return !is_optimus_to_burn_ready();
    }

    if (5 > argc) {
        printf("argc[%d] too few, use \"download nand part_name imageType imgSz\"\n", argc);
        return  __LINE__;
    }

    imgSzInBy = simple_strtoull(imgSzStr, NULL, 0);

    if (!strcmp("mem", mediaType))
    {
        char* endp = NULL;
        partBaseOffset = simple_strtoull(part_name, &endp, 0);
        if (0 != *endp) //not a valid 0-terminated c string
        {
            if (!strcmp("dtb", part_name))
            {
                partBaseOffset = OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR;
                DWN_MSG("dtb boot down to %llx\n", partBaseOffset);
            }
        }
    }

    ret = optimus_parse_img_download_info(part_name, imgSzInBy, imgType, mediaType, partBaseOffset);
    if (ret) {
        DWN_ERR("Fail in init download info\n");
        return __LINE__;
    }

    ret = optimus_buf_manager_tplcmd_init(mediaType, part_name, partBaseOffset, imgType, imgSzInBy, isUpload, 0);
    if (ret) {
        DWN_ERR("Fail in init download info\n");
        return __LINE__;
    }

    return OPT_DOWN_OK;
}

u32 optimus_dump_storage_data(u8* pBuf, const u32 wantSz, char* errInfo)
{
    struct ImgBurnInfo* pDownInfo = &OptimusImgBurnInfo;
    u64 nextMediaOffset = pDownInfo->nextMediaOffset;
    int ret = 0;

    DWN_DBG("pBuf=0x%p, wantSz=0x%x, nextMediaOffset=%x\n", pBuf, wantSz, (u32)nextMediaOffset);

    ret = optimus_storage_open(pDownInfo, pBuf, wantSz);
    if (OPT_DOWN_OK != ret) {
        sprintf(errInfo, "Fail to open stoarge\n");
        DWN_ERR(errInfo);
        return 0;
    }

    ret = optimus_storage_read(pDownInfo, nextMediaOffset, wantSz, pBuf, errInfo);
    if (ret) {
        DWN_ERR("Failed \n");
        goto _err;
    }
    pDownInfo->imgSzDisposed    += wantSz;
    pDownInfo->nextMediaOffset  += wantSz;

    ret = optimus_storage_close(pDownInfo);
    if (ret) {
        DWN_ERR("Fail to close media\n");
        return 0;
    }

    return wantSz;

_err:
    optimus_storage_close(pDownInfo);
    pDownInfo->imgBurnSta = OPTIMUS_IMG_STA_BURN_FAILED;////
    return 0;
}

static int _optimusWorkMode = OPTIMUS_WORK_MODE_NONE;

int optimus_work_mode_get(void)
{
    return _optimusWorkMode;
}

int optimus_work_mode_set(int workmode)
{
    _optimusWorkMode = workmode;
    return 0;
}

int is_the_flash_first_burned(void)
{
    const char* s = getenv("upgrade_step");

    DWN_MSG("====>upgrade_step=%s<=====\n", s ? s : "<UNDEFINED>");

    return !strcmp(s, "0");//"0" indicate first boot
}

//FIXME: check whether 'saveenv' failed and exception when usb prodcing mode from code boot mode if without env_relocate
int optimus_set_burn_complete_flag(void)
{
    int rc = 0;
    const int IsTplLoadedFromBurningPackage = aml_burn_check_uboot_loaded_for_burn(0);
    const char* const upgrade_step = IsTplLoadedFromBurningPackage ? "2" : "1";

    if (IsTplLoadedFromBurningPackage)
    {
        extern int device_boot_flag;

        char str_store[8];

        sprintf(str_store, "%d", device_boot_flag);
        DWN_MSG("store=%s\n", str_store);
        /*rc = run_command("defenv", 0);//use new env directly if uboot is new !!!*/
        set_default_env("## save_setting ##\n");//use new env directly if uboot is new !!!
        setenv("store", str_store);
        setenv("firstboot", "1");
        if (!strstr(getenv("initargs"), "storage") && getenv("initargs") && 0) {
                rc = run_command("setenv initargs ${initargs} storage=${store}", 0);
                DWN_MSG("[initargs=%s]\n", getenv("initargs"));
        }
        else if(!strstr(getenv("bootargs"), "storage") && getenv("bootargs") && 0){//user not configure storage in 'bootargs' of default env
                rc = run_command("setenv bootargs ${bootargs} storage=${store}", 0);
                DWN_MSG("[bootargs=%s]\n", getenv("bootargs"));
        }
    }

    DWN_MSG("Set upgrade_step to %s\n", upgrade_step);
    rc = setenv("upgrade_step", (char*)upgrade_step);
    if (rc) {
        DWN_ERR("Fail to set upgraded_step to 1\n");
    }
    rc = run_command("saveenv", 0);
    if (rc) {
        DWN_ERR("Fail to saveenv to flash\n");
    }
    udelay(200);

    return rc;
}

static int _optimus_set_reboot_mode(const int cfgFlag)
{
    switch (cfgFlag)
    {
    case OPTIMUS_BURN_COMPLETE__REBOOT_UPDATE:
            /*reboot_mode = AMLOGIC_UPDATE_REBOOT;  */
            break;

    case OPTIMUS_BURN_COMPLETE__REBOOT_SDC_BURN:
            /*reboot_mode = MESON_SDC_BURNER_REBOOT;  */
            break;

    case OPTIMUS_BURN_COMPLETE__REBOOT_NORMAL:
    default:
            /*reboot_mode = AMLOGIC_NORMAL_BOOT;  */
            break;
    }

    return 0;
}

void optimus_reset(const int cfgFlag)
{
    unsigned i = 0x100;

    //writel(0, CONFIG_TPL_BOOT_ID_ADDR);//clear boot_id

    //set reboot mode
    _optimus_set_reboot_mode(cfgFlag);

#if defined(CONFIG_M6) || defined(CONFIG_M6TV)
    //if not clear, uboot command reset will fail -> blocked
    *((volatile unsigned long *)P_AO_RTI_STATUS_REG0) = 0;
#endif//#if defined(CONFIG_M6) || defined(CONFIG_M6TV)
    printf("Burn Reboot...\n");//Add printf to delay to save env
    while (--i) ;

    /*disable_interrupts();*/
	reset_cpu(0);

    while (i++)
    {
        unsigned ret = i;
        unsigned mask = 1U<<20;

        mask -= 1;
        ret &= mask;
        if (!ret) {
            printf("To reseting...\n");
        }
    }
}

void optimus_poweroff(void)
{
    //writel(0, CONFIG_TPL_BOOT_ID_ADDR);//clear boot_id
	/*reboot_mode_clear();*/

#if CONFIG_POWER_KEY_NOT_SUPPORTED_FOR_BURN
    DWN_MSG("stop here as poweroff and powerkey not supported in platform!\n");
    DWN_MSG("You can <Ctrl-c> to reboot\n");
    while (!ctrlc()) continue;
    optimus_reset(OPTIMUS_BURN_COMPLETE__REBOOT_NORMAL);
#else
    printf("To poweroff\n");
    run_command("poweroff", 0);
    printf("!!!After run command poweroff!!\n");
#endif// #if CONFIG_POWER_KEY_NOT_SUPPORTED_FOR_BURN

    return;
}

//use choice = 0xfu to query is_burn_completed
int optimus_burn_complete(const int choice)
{
    static unsigned _isBurnComplete = 0;
    int rc = 0;

    switch (choice)
    {
        case OPTIMUS_BURN_COMPLETE__POWEROFF_AFTER_POWERKEY://wait power key to power off, for sdc_burn
            {
#if CONFIG_POWER_KEY_NOT_SUPPORTED_FOR_BURN
                DWN_MSG("stop here as poweroff and powerkey not supported in platform!\n");
                DWN_MSG("You can <Ctrl-c> to reboot\n");

                while (!ctrlc()) continue;
                optimus_reset(OPTIMUS_BURN_COMPLETE__REBOOT_NORMAL);
#endif// #if CONFIG_POWER_KEY_NOT_SUPPORTED_FOR_BURN
                DWN_MSG("PLS short-press power key to shut down\n");
                do
                {
                    rc = run_command("getkey", 0);
                }while(rc);
            }
        case OPTIMUS_BURN_COMPLETE__POWEROFF_DIRECT:
            optimus_poweroff();
            break;

        case OPTIMUS_BURN_COMPLETE__POWEROFF_AFTER_DISCONNECT:
            DWN_MSG("Pls un-plug USB line to poweroff\n");
            _isBurnComplete = 0xefe;
            break;
        case OPTIMUS_BURN_COMPLETE__QUERY:
            return (0xefe == _isBurnComplete);

        case OPTIMUS_BURN_COMPLETE__REBOOT_UPDATE:
        case OPTIMUS_BURN_COMPLETE__REBOOT_NORMAL:
            {
                optimus_reset(choice);
            }
            break;


        default:
            rc = 1;
            DWN_ERR("Error burn_complete flag %d\n", choice);
    }

    return rc;
}

#if ROM_BOOT_SKIP_BOOT_ENABLED
int optimus_enable_romboot_skip_boot(void)
{
#ifdef CONFIG_MESON_TRUSTZONE
	writel(meson_trustzone_sram_read_reg32(SKIP_BOOT_REG_BACK_ADDR), P_AO_RTI_STATUS_REG0); //disable watchdog
#else
	/*writel(readl(SKIP_BOOT_REG_BACK_ADDR), P_AO_RTI_STATUS_REG0); //disable watchdog*/
#endif// #ifdef CONFIG_MESON_TRUSTZONE

	//enable romboot skip_boot function to jump to usb boot
    /*DWN_MSG("Skip boot flag[%x]\n", (unsigned int)readl(P_AO_RTI_STATUS_REG0));*/
    return 0;
}
#endif// #if ROM_BOOT_SKIP_BOOT_ENABLED
