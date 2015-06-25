/*
 * \file        optimus_img_decoder.c
 * \brief
 *
 * \version     1.0.0
 * \date        2013-7-8
 * \author      Sam.Wu <yihui.wu@amlogic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#include "../v2_sdc_burn/optimus_sdc_burn_i.h"

//FIMXE:
COMPILE_TYPE_CHK(128 == sizeof(ItemInfo_V1), _op_a);
COMPILE_TYPE_CHK(576 == sizeof(ItemInfo_V2), __op_a2);
COMPILE_TYPE_CHK(64  == sizeof(AmlFirmwareImg_t), __op_b);

typedef struct _ImgSrcIf{
        unsigned        devIf;             //mmc/usb/store
        unsigned        devNo;          //0/1/2
        unsigned        devAlignSz;     //64K for store
        unsigned        reserv2Align64;
        uint64_t        itemCurSeekOffsetInImg;//fread will auto seek the @readSz, but for STORE we must do it

        char            partName[28];       //partIndex <= 28 (+4 if partIndex not used)
        unsigned        partIndex;      //partIndex and part
        unsigned char   resrv[512 - 32 - 24];
}ImgSrcIf_t;

COMPILE_TYPE_CHK(512  == sizeof(ImgSrcIf_t), bb);
#define MAX_ITEM_NUM 48

typedef struct _ImgInfo_s
{
        ImgSrcIf_t          imgSrcIf;
        AmlFirmwareImg_t    imgHead;//Must begin align 512, or store read wiill exception
        union               ItemInfo_u{
                            ItemInfo_V1 v1[MAX_ITEM_NUM];
                            ItemInfo_V2 v2[MAX_ITEM_NUM];
        }itemInfo;

}ImgInfo_t;

typedef struct _AmlFirmwareItem0_s
{
    __u32           itemId;
    __u32           fileType;           //image file type, sparse and normal
    __u64           curoffsetInItem;    //current offset in the item
    __u64           offsetInImage;      //item offset in the image
    __u64           itemSz;             //item size in the image
    const char*     itemMainType;
    const char*     itemSubType;
}ItemInfo;

static int _hFile = -1;

//open a Amlogic firmware image
//return value is a handle
HIMAGE image_open(const char* interface, const char* device, const char* part, const char* imgPath)
{
    const int HeadSz = sizeof(ImgInfo_t) - sizeof(ImgSrcIf_t);
    ImgInfo_t* hImg = (ImgInfo_t*)OPTIMUS_BURN_PKG_HEAD_BUF_ADDR;
    int ret = 0;
    ImgSrcIf_t* pImgSrcIf = NULL;
    unsigned imgVer = 0;

    pImgSrcIf = &hImg->imgSrcIf;
    memset(pImgSrcIf, 0, sizeof(ImgSrcIf_t));

    if (!strcmp("store", interface))
    {
            DWN_DBG("imgHead=0x%p, hImg=%p\n", &hImg->imgHead, hImg);
            ret = store_read_ops((u8*)part, (u8*)&hImg->imgHead, IMG_OFFSET_IN_PART, HeadSz);
            if (ret) {
                    DWN_ERR("Fail to read image header.\n");
                    ret = __LINE__; goto _err;
            }

            pImgSrcIf->devIf = IMAGE_IF_TYPE_STORE;
            pImgSrcIf->devAlignSz = 4*1024;//512;//OPTIMUS_DOWNLOAD_SLOT_SZ;
            strcpy(pImgSrcIf->partName, part);
    }
    else
    {
            int pFile = do_fat_fopen(imgPath);
            if (pFile < 0) {
                    DWN_ERR("Fail to open file %s\n", imgPath);
                    goto _err;
            }
            _hFile = pFile;

            ret = do_fat_fread(pFile, (u8*)&hImg->imgHead, HeadSz);
            if (ret != HeadSz) {
                    DWN_ERR("want to read %d, but %d\n", HeadSz, ret);
                    goto _err;
            }

            pImgSrcIf->devAlignSz = do_fat_get_bytesperclust(pFile);
    }

    if (IMAGE_MAGIC != hImg->imgHead.magic) {
        DWN_ERR("error magic 0x%x\n", hImg->imgHead.magic);
        goto _err;
    }
    imgVer = hImg->imgHead.version;
    if (AML_FRMWRM_VER_V1 !=  imgVer && AML_FRMWRM_VER_V2 != imgVer) {
        DWN_ERR("error verison 0x%x\n", hImg->imgHead.version);
        goto _err;
    }
    DWN_MSG("image version [0x%08x]\n", imgVer);
    if (MAX_ITEM_NUM < hImg->imgHead.itemNum) {
            DWN_ERR("max itemNum(%d)<actual itemNum (%d)\n", MAX_ITEM_NUM, hImg->imgHead.itemNum);
            goto _err;
    }

    return hImg;
_err:
    return NULL;
}


//close a Amlogic firmware image
int image_close(HIMAGE hImg)
{
    DWN_MSG("to close image\n");

    if (_hFile >= 0)do_fat_fclose(_hFile) , _hFile = -1;

    if (hImg) {
        hImg = NULL;
    }
    return 0;
}

static const ItemInfo* image_item_get_item_info_byid(HIMAGE hImg, const int itemIndex)
{
        ImgInfo_t* imgInfo = (ImgInfo_t*)hImg;
        const unsigned imgVer = imgInfo->imgHead.version;
        static ItemInfo theItem;

        switch (imgVer)
        {
                case AML_FRMWRM_VER_V2:
                        {
                                ItemInfo_V2* pItem = &imgInfo->itemInfo.v2[itemIndex];
                                theItem.itemMainType    = pItem->itemMainType;
                                theItem.itemSubType     = pItem->itemSubType;
                                theItem.itemSz          = pItem->itemSz;
                                theItem.offsetInImage   = pItem->offsetInImage;
                                theItem.curoffsetInItem = pItem->curoffsetInItem;
                                theItem.fileType        = pItem->fileType;
                                theItem.itemId          = pItem->itemId;
                        }
                        break;

                case AML_FRMWRM_VER_V1:
                        {
                                ItemInfo_V1* pItem = &imgInfo->itemInfo.v1[itemIndex];
                                theItem.itemMainType    = pItem->itemMainType;
                                theItem.itemSubType     = pItem->itemSubType;
                                theItem.itemSz          = pItem->itemSz;
                                theItem.offsetInImage   = pItem->offsetInImage;
                                theItem.curoffsetInItem = pItem->curoffsetInItem;
                                theItem.fileType        = pItem->fileType;
                                theItem.itemId          = pItem->itemId;
                        }
                        break;

                default:
                        DWN_ERR("Exception, imgVer=0x%x\n", imgVer);
                        return NULL;
        }

        return &theItem;
}

//open a item in the image
//@hImage: image handle;
//@mainType, @subType: main type and subtype to index the item, such as ["IMAGE", "SYSTEM"]
HIMAGEITEM image_item_open(HIMAGE hImg, const char* mainType, const char* subType)
{
    ImgInfo_t* imgInfo          = (ImgInfo_t*)hImg;
    const int itemNr            = imgInfo->imgHead.itemNum;
    const ItemInfo*      pItem  = NULL;
    int i = 0;

    for (; i < itemNr ;i++)
    {
            pItem = image_item_get_item_info_byid(hImg, i);
            if (!pItem) {
                    DWN_ERR("Fail to get item at index %d\n", i);
                    return NULL;
            }

            if (!strcmp(mainType, pItem->itemMainType) && !strcmp(subType, pItem->itemSubType))
            {
                    break;
            }
    }
    if (i >= itemNr) {
        DWN_WRN("Can't find item [%s, %s]\n", mainType, subType);
        return NULL;
    }

    if (i != pItem->itemId) {
        DWN_ERR("itemid %d err, should %d\n", pItem->itemId, i);
        return NULL;
    }

    if (IMAGE_IF_TYPE_STORE != imgInfo->imgSrcIf.devIf)
    {
            DWN_DBG("Item offset 0x%llx\n", pItem->offsetInImage);
            i = do_fat_fseek(_hFile, pItem->offsetInImage, 0);
            if (i) {
                    DWN_ERR("fail to seek, offset is 0x%x\n", (u32)pItem->offsetInImage);
                    return NULL;
            }
    }
    imgInfo->imgSrcIf.itemCurSeekOffsetInImg = pItem->offsetInImage;

    return (HIMAGEITEM)pItem;
}

//Need this if item offset in the image file is not aligned to bytesPerCluster of FAT
unsigned image_item_get_first_cluster_size(HIMAGE hImg, HIMAGEITEM hItem)
{
    const ImgInfo_t* imgInfo = (ImgInfo_t*)hImg;
    ItemInfo* pItem = (ItemInfo*)hItem;
    unsigned itemSizeNotAligned = 0;
    const unsigned fat_bytesPerCluste = imgInfo->imgSrcIf.devAlignSz;

    itemSizeNotAligned = pItem->offsetInImage & (fat_bytesPerCluste - 1);
    itemSizeNotAligned = fat_bytesPerCluste - itemSizeNotAligned;

    DWN_MSG("itemSizeNotAligned 0x%x\n", itemSizeNotAligned);
    return itemSizeNotAligned;
}

unsigned image_get_cluster_size(HIMAGEITEM hImg)
{
    const ImgInfo_t* imgInfo = (ImgInfo_t*)hImg;
    const unsigned fat_bytesPerCluste = imgInfo->imgSrcIf.devAlignSz;

    return fat_bytesPerCluste;
}

//close a item
int image_item_close(HIMAGEITEM hItem)
{
    return 0;
}

__u64 image_item_get_size(HIMAGEITEM hItem)
{
    ItemInfo* pItem = (ItemInfo*)hItem;

    return pItem->itemSz;
}


//get image item type, current used type is normal or sparse
int image_item_get_type(HIMAGEITEM hItem)
{
    ItemInfo* pItem = (ItemInfo*)hItem;

    return pItem->fileType;
}

//read item data, like standard fread
int image_item_read(HIMAGE hImg, HIMAGEITEM hItem, void* pBuf, const __u32 wantSz)
{
    ImgInfo_t* imgInfo = (ImgInfo_t*)hImg;
    unsigned readSz = 0;

    if (IMAGE_IF_TYPE_STORE == imgInfo->imgSrcIf.devIf)
    {
            unsigned char* part = (unsigned char*)imgInfo->imgSrcIf.partName;
            const uint64_t offsetInPart = imgInfo->imgSrcIf.itemCurSeekOffsetInImg + IMG_OFFSET_IN_PART;
            int rc = 0;
            const unsigned storeBlkSz      = imgInfo->imgSrcIf.devAlignSz;
            const unsigned offsetNotAlign = offsetInPart & (storeBlkSz - 1);
            const unsigned sizeNotAlignInFirstBlk = storeBlkSz - offsetNotAlign;//in the the first block and its offset not aligned

            //Attention: deal with the align issue in "optimus_burn_one_partition", then not need to modify "do_fat_fread"
            if (offsetNotAlign)
            {
                    unsigned char* bufInABlk = NULL;
                    const uint64_t readOffset = offsetInPart - offsetNotAlign;
                    const unsigned bufLen = sizeNotAlignInFirstBlk < wantSz ? sizeNotAlignInFirstBlk : (wantSz);
                    unsigned thisTotalReadSz = wantSz;

                    DWN_MSG("offsetInPart %llx, wantSz=%x\n", offsetInPart, wantSz);
                    bufInABlk = (u8*)malloc(storeBlkSz);
                    rc = store_read_ops(part, bufInABlk, readOffset, storeBlkSz);
                    if (rc) {
                            DWN_ERR("Fail to read: readOffset=%llx, storeBlkSz=%x\n", readOffset, storeBlkSz);
                            free(bufInABlk);
                            return __LINE__;
                    }
                    memcpy(pBuf, bufInABlk + offsetNotAlign, bufLen);
                    thisTotalReadSz -= bufLen;
                    pBuf            += bufLen/sizeof(void);
                    free(bufInABlk);

                    if (sizeNotAlignInFirstBlk < wantSz && offsetNotAlign)
                    {
                            rc = store_read_ops(part, (u8*)pBuf, (offsetInPart + sizeNotAlignInFirstBlk), thisTotalReadSz);
                            if (rc) {
                                    DWN_ERR("Fail in store_read_ops to read %u at offset %llx.\n", wantSz,
                                                    offsetInPart + sizeNotAlignInFirstBlk);
                                    return __LINE__;
                            }
                    }
            }
            else
            {
                    rc = store_read_ops(part, (u8*)pBuf, offsetInPart, wantSz);
                    if (rc) {
                            DWN_ERR("Fail in store_read_ops to read %u at offset %llx.\n", wantSz, offsetInPart);
                            return __LINE__;
                    }
            }

            imgInfo->imgSrcIf.itemCurSeekOffsetInImg += wantSz;
    }
    else
    {
            readSz = do_fat_fread(_hFile, pBuf, wantSz);
            if (readSz != wantSz) {
                    DWN_ERR("want to read 0x%x, but 0x%x\n", wantSz, readSz);
                    return __LINE__;
            }
    }

    return 0;
}

int get_total_itemnr(HIMAGE hImg)
{
    ImgInfo_t* imgInfo = (ImgInfo_t*)hImg;

    return imgInfo->imgHead.itemNum;
}

HIMAGEITEM get_item(HIMAGE hImg, int itemId)
{
    int ret = 0;
    ImgInfo_t* imgInfo = (ImgInfo_t*)hImg;
    const ItemInfo* pItem    = NULL;

    pItem = image_item_get_item_info_byid(hImg, itemId);
    if (!pItem) {
            DWN_ERR("Fail to get item at index %d\n", itemId);
            return NULL;
    }
    if (itemId != pItem->itemId) {
        DWN_ERR("itemid %d err, should %d\n", pItem->itemId, itemId);
        return NULL;
    }
    DWN_MSG("get item [%s, %s] at %d\n", pItem->itemMainType, pItem->itemSubType, itemId);

    if (IMAGE_IF_TYPE_STORE != imgInfo->imgSrcIf.devIf)
    {
            ret = do_fat_fseek(_hFile, pItem->offsetInImage, 0);
            if (ret) {
                    DWN_ERR("fail to seek, offset is 0x%x, ret=%d\n", (u32)pItem->offsetInImage, ret);
                    return NULL;
            }
    }
    imgInfo->imgSrcIf.itemCurSeekOffsetInImg = pItem->offsetInImage;

    return (HIMAGEITEM)pItem;
}

int get_item_name(HIMAGE hImg, int itemId, const char** main_type, const char** sub_type)
{
    const ItemInfo* pItem    = NULL;

    pItem = image_item_get_item_info_byid(hImg, itemId);
    if (!pItem) {
            DWN_ERR("Fail to get item at index %d\n", itemId);
            return __LINE__;
    }
    if (itemId != pItem->itemId) {
        DWN_ERR("itemid %d err, should %d\n", pItem->itemId, itemId);
        return __LINE__;
    }
    DWN_DBG("get item [%s, %s] at %d\n", pItem->itemMainType, pItem->itemSubType, itemId);

    *main_type = pItem->itemMainType;
    *sub_type  = pItem->itemSubType;

    return OPT_DOWN_OK;
}

__u64 image_get_item_size_by_index(HIMAGE hImg, const int itemId)
{
    const ItemInfo* pItem    = NULL;

    pItem = image_item_get_item_info_byid(hImg, itemId);
    if (!pItem) {
            DWN_ERR("Fail to get item at index %d\n", itemId);
            return 0;
    }
    if (itemId != pItem->itemId) {
        DWN_ERR("itemid %d err, should %d\n", pItem->itemId, itemId);
        return __LINE__;
    }
    DWN_DBG("get item [%s, %s] at %d\n", pItem->itemMainType, pItem->itemSubType, itemId);

    return pItem->itemSz;
}

u64 optimus_img_decoder_get_data_parts_size(HIMAGE hImg, int* hasBootloader)
{
    int i = 0;
    int ret = 0;
    u64 dataPartsSz = 0;
    const int totalItemNum = get_total_itemnr(hImg);

    *hasBootloader = 0;
    for (i = 0; i < totalItemNum; i++)
    {
        const char* main_type = NULL;
        const char* sub_type  = NULL;

        ret = get_item_name(hImg, i, &main_type, &sub_type);
        if (ret) {
            DWN_ERR("Exception:fail to get item name!\n");
            return __LINE__;
        }

        if (strcmp("PARTITION", main_type)) { continue; }
        if (!strcmp("bootloader", sub_type)) {
                *hasBootloader = 1;
                continue;
        }
        if (!strcmp(AML_SYS_RECOVERY_PART, sub_type))
        {
                if (OPTIMUS_WORK_MODE_SYS_RECOVERY == optimus_work_mode_get()) continue;
        }

        dataPartsSz += image_get_item_size_by_index(hImg, i);
    }

    return dataPartsSz;
}

#define MYDBG 0
#if MYDBG
static int test_item(HIMAGE hImg, const char* main_type, const char* sub_type, char* pBuf, const int sz)
{
    HIMAGEITEM hItem = NULL;
    int ret = 0;

    hItem = image_item_open(hImg, main_type, sub_type);
    if (!hItem) {
        DWN_ERR("fail to open %s, %s\n", main_type, sub_type);
        return __LINE__;
    }

    ret = image_item_read(hImg, hItem, pBuf, sz);
    if (ret) {
        DWN_ERR("fail to read\n");
        goto _err;
    }
    if (64 >= sz)DWN_MSG("%s\n", pBuf) ;

_err:
    image_item_close(hItem);
    return ret;
}

static int test_pack(const char* interface, const char* device, const char* part, const char* imgPath)
{
    const int ImagBufLen = OPTIMUS_DOWNLOAD_SLOT_SZ;
    char* pBuf = (char*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR + ImagBufLen;
    int ret = 0;
    int i = 0;
    HIMAGEITEM hItem = NULL;

    if (!strcmp("store", interface))
    {
            ret = run_command("store init 1", 0);
            if (ret) {
                    DWN_ERR("Fail in init mmc, Does sdcard not plugged in?\n");
                    return __LINE__;
            }
    }
    else
    {
            s64 fileSz = 0;

            ret = run_command("mmcinfo", 0);
            if (ret) {
                    DWN_ERR("Fail in init mmc, Does sdcard not plugged in?\n");
                    return __LINE__;
            }

            fileSz = do_fat_get_fileSz(imgPath);
            if (!fileSz) {
                    DWN_ERR("file %s not exist\n", imgPath);
                    return __LINE__;
            }
    }

    HIMAGE hImg = image_open(interface, device, part, imgPath);
    if (!hImg) {
        DWN_ERR("Fail to open image\n");
        return __LINE__;
    }

    const int itemNr = get_total_itemnr(hImg);
    for (i = 0; i < itemNr ; i++)
    {
        __u64 itemSz = 0;
        int fileType = 0;

        hItem = get_item(hImg, i);
        if (!hItem) {
            DWN_ERR("Fail to open item at id %d\n", i);
            break;
        }

        itemSz = image_item_get_size(hItem);
        DWN_MSG("Item Sz is 0x%llx\n", itemSz);

        unsigned wantSz = ImagBufLen > itemSz ? (unsigned)itemSz : ImagBufLen;
        unsigned itemSizeNotAligned = 0;
        char* readBuf = pBuf;
        unsigned readSz = wantSz;

        itemSizeNotAligned = image_item_get_first_cluster_size(hImg, hItem);
        if (itemSizeNotAligned)
        {
                ret = image_item_read(hImg, hItem, readBuf, itemSizeNotAligned);
                readSz = (wantSz > itemSizeNotAligned) ? (wantSz - itemSizeNotAligned) : 0;
        }

        if (readSz)
        {
                ret = image_item_read(hImg, hItem, readBuf + itemSizeNotAligned, readSz);
                if (ret) {
                        DWN_ERR("fail to read item data\n");
                        break;
                }
        }

        fileType = image_item_get_type(hItem);
        if (IMAGE_ITEM_TYPE_SPARSE == fileType)
        {
                DWN_MSG("sparse packet\n");
                ret = optimus_simg_probe((const u8*)pBuf, wantSz);
                if (!ret) {
                        DWN_ERR("item data error, should sparse, but no\n");
                        break;
                }
        }
    }

#if 1
    test_item(hImg, "PARTITION", "logo", pBuf, ImagBufLen);
    test_item(hImg, "VERIFY", "logo", pBuf, 50);
#endif

    image_close(hImg);
    return 0;
}

static int do_unpack(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int rcode = 0;
    const char* imgPath = "a";

#if 1
    if (2 > argc) imgPath = "dt.img";
#else
    if (2 > argc) {
        cmd_usage(cmdtp);
        return -1;
    }
#endif//#if MYDBG
    DWN_MSG("argc %d, %s, %s\n", argc, argv[0], argv[1]);

    rcode = test_pack("mmc", "0", "aml_sysrecovery", imgPath);

    DWN_MSG("rcode %d\n", rcode);
    return rcode;
}

U_BOOT_CMD(
   unpack,      //command name
   5,               //maxargs
   1,               //repeatable
   do_unpack,   //command function
   "unpack the image in sdmmc ",           //description
   "Usage: unpack imagPath\n"   //usage
);
#endif//#if MYDBG

