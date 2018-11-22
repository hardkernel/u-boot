/*
 * \file        optimus_buffer_manager.c
 * \brief       buffer manager for download data: A thin layer between receiving partition data and writing flash
 *
 * \version     1.0.0
 * \date        2013/5/2
 * \author      Sam.Wu <yihui.wu@Amlogic.com>
 *
 * Copyright (c) 2013 Amlogic Inc.. All Rights Reserved.
 *
 */
#include "../v2_burning_i.h"

#define OPTIMUS_SLOT_STA_FREE               (0)//buffer slot not used yet
#define OPTIMUS_SLOT_STA_USED               (0xee)//buffer slot current used for download
#define OPTIMUS_SLOT_STA_LEFT               (0xdd)//buffer slot not disposed over

#define PKT_TRANSFER_STA_EMPTY              0
#define PKT_TRANSFER_STA_WORKING            1
#define PKT_TRANSFER_STA_END                2

typedef struct bufManager{
    const u8*       transferBuf;//transfer buffer address
    const u32       transferBufSz;//transfer buffer size to

    const u32       transferUnitSz;//64k
    u32             writeBackUnitSz;//for NAND is transferSz, for sparse is transferUnitSz

    u64             tplcmdTotalSz;//total size of a file-system packet

    u32             totalSlotNum;//total slot number that already tranfferred
    u32             mediaAlignSz;//nand write align size, 16K/32k

    u32             nextWriteBackSlot;//when reach n* (writeBackUnitSz/transferUnitSz), then write back the recevied data to media
    u32             leftDataSz;//left data size, Assert that 'leftDataInBackBuf + leftDataSz == transferBuf'

    s16             isUpload;
    s16             pktTransferSta;
    u32             destMediaType;

    u32             partBaseOffset;//TODO: change it to memory address when dest media type is memory
    u32             itemOffsetNotAlignClusterSz_f;//For sdcard burning, item offset of aml_upgrade_package.img is not aligned to bytespercluster of FAT fs(_f means not changed inited)

}BufManager;

//TODO: if want to speed-up such as soft PING-PONG buffer, use multiple BufManager
static BufManager _bufManager =
{
//constant members
    .transferBuf        = (const u8*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR,
    .transferBufSz      = OPTIMUS_DOWNLOAD_TRANSFER_BUF_TOTALSZ,
    .transferUnitSz     = OPTIMUS_DOWNLOAD_SLOT_SZ,

//different for each command, note a command corresponding to a download file
//must create/destroy for a command
    .writeBackUnitSz    = OPTIMUS_DOWNLOAD_SLOT_SZ,

    .totalSlotNum      = 0,//not slot data recevied yet!

    .leftDataSz         = 0,
    .tplcmdTotalSz      = 0,
    .nextWriteBackSlot  = 0,//always 0 when upload??

    .isUpload           = 0,
    .pktTransferSta     = PKT_TRANSFER_STA_EMPTY,

    .itemOffsetNotAlignClusterSz_f  = 0,
};

int optimus_buf_manager_init(const unsigned mediaAlignSz)
{
    if (OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR != (uint64_t)_bufManager.transferBuf) {
        DWN_ERR("Fatal fail in init-express, init here instead!\n");
        return OPT_DOWN_FAIL;
    }
    _bufManager.mediaAlignSz = mediaAlignSz;

    DWN_DBG("transfer=0x%p, transferBufSz=0x%x, transferUnitSz=0x%x, writeBackUnitSz=0x%x, totalSlotNum=%d\n", _bufManager.transferBuf,
            _bufManager.transferBufSz,  _bufManager.transferUnitSz,     _bufManager.writeBackUnitSz,        _bufManager.totalSlotNum);

    return OPT_DOWN_OK;
}

int optimus_buf_manager_exit(void)
{
    return 0;
}

int optimus_buf_manager_tplcmd_init(const char* mediaType,  const char* partName,   const u64 partBaseOffset,
                            const char* imgType, const u64 pktTotalSz, const int isUpload,
                            const unsigned itemSizeNotAligned /* if item offset 3 and bytepercluste 4k, then it's 4k -3 */)
{
    u32 writeBackUnitSz = OPTIMUS_VFAT_IMG_WRITE_BACK_SZ;
    const u64 pktSz4BufManager = pktTotalSz - itemSizeNotAligned;

    int cacheAll2Mem = 0;
#if OPTIMUS_BURN_TARGET_SUPPORT_UBIFS
    if ( !strcmp(imgType, "ubifs") ) cacheAll2Mem = 1;
#endif // #if OPTIMUS_BURN_TARGET_SUPPORT_UBIFS

    if (!strcmp("sparse", imgType)
            || itemSizeNotAligned/* use max memory if item 'itemOffset % bytespercluster != 0'*/)
    {
        writeBackUnitSz = OPTIMUS_SIMG_WRITE_BACK_SZ;
    }

    if (!strcmp("bootloader", partName) || !strcmp("_aml_dtb", partName)
#if defined(CONFIG_AML_MTD) && defined(CONFIG_TPL_PART_NAME)
        || ( !strcmp(CONFIG_TPL_PART_NAME, partName) )
#endif//#if defined(CONFIG_AML_MTD)
       )
    {
        if (pktSz4BufManager > _bufManager.transferBufSz) {
            DWN_ERR("packet size 0x%x too large, max is 0x%x\n", (u32)pktSz4BufManager, _bufManager.transferBufSz);
            return OPT_DOWN_FAIL;
        }
        /*writeBackUnitSz = OPTIMUS_BOOTLOADER_MAX_SZ;*/
        writeBackUnitSz             = pktSz4BufManager + _bufManager.transferUnitSz - 1;
        writeBackUnitSz             >>= OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS;
        writeBackUnitSz             <<= OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS;
    }

    _bufManager.destMediaType   = !strcmp("mem", mediaType) ? OPTIMUS_MEDIA_TYPE_MEM : OPTIMUS_MEDIA_TYPE_STORE ;
    if ( !cacheAll2Mem ) cacheAll2Mem = !strcmp("mem", mediaType) ;
    if (cacheAll2Mem)
    {
            writeBackUnitSz             = pktSz4BufManager + _bufManager.transferUnitSz - 1;
            writeBackUnitSz             >>= OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS;
            writeBackUnitSz             <<= OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS;

        if (partBaseOffset>>32) {
            DWN_ERR("partBaseOffset 0x%llx more than 4G!!\n", partBaseOffset);
            return OPT_DOWN_FAIL;
        }
        _bufManager.partBaseOffset = (u32)partBaseOffset;
    }

    if (_bufManager.transferBufSz < writeBackUnitSz && !cacheAll2Mem) {
        DWN_ERR("write back size 0x%x > max size 0x%x\n", writeBackUnitSz, _bufManager.transferBufSz);
        return OPT_DOWN_FAIL;
    }
    if (_bufManager.transferUnitSz > writeBackUnitSz) {
        DWN_ERR("write back size %d < align size %d\n", writeBackUnitSz, _bufManager.mediaAlignSz);
        return OPT_DOWN_FAIL;
    }
    DWN_DBG("writeBackUnitSz = 0x%x, pktSz4BufManager = %lld\n", writeBackUnitSz, pktSz4BufManager);

    _bufManager.writeBackUnitSz     = writeBackUnitSz;
    _bufManager.totalSlotNum        = 0;
    _bufManager.isUpload            = isUpload;
    _bufManager.pktTransferSta      = PKT_TRANSFER_STA_EMPTY;

    if (_bufManager.isUpload)
    {
        _bufManager.nextWriteBackSlot = 0;//always 0 if upload
    }
    else//has write back if download
    {
        if (pktSz4BufManager < writeBackUnitSz)
        {
            _bufManager.nextWriteBackSlot  = ((u32)pktSz4BufManager + _bufManager.transferUnitSz - 1)/_bufManager.transferUnitSz;//first slot index to write back to media
        }
        else
        {
            _bufManager.nextWriteBackSlot  = writeBackUnitSz/_bufManager.transferUnitSz;//first slot index to write back to media
        }

    }

    _bufManager.itemOffsetNotAlignClusterSz_f = itemSizeNotAligned;
    _bufManager.leftDataSz                  = itemSizeNotAligned;//data size in the buffer that not write back to media yet in previous transfer
    _bufManager.tplcmdTotalSz               = pktSz4BufManager;

    optimus_progress_init((u32)(_bufManager.tplcmdTotalSz>>32), (u32)_bufManager.tplcmdTotalSz, 0, 100);
    DWN_MSG("totalSlotNum = %d, nextWriteBackSlot %d\n", _bufManager.totalSlotNum, _bufManager.nextWriteBackSlot);

    return OPT_DOWN_OK;
}

int optimus_buf_manager_get_buf_for_bulk_transfer(char** pBuf, const unsigned wantSz, const unsigned sequenceNo, char* errInfo)
{
    const unsigned totalSlotNum      = _bufManager.totalSlotNum;
    const u64 totalTransferSz        = ((u64)totalSlotNum) * _bufManager.transferUnitSz;//data size already transferred
    const u64 leftPktSz              = (totalTransferSz > _bufManager.tplcmdTotalSz) ? 0 :(_bufManager.tplcmdTotalSz - totalTransferSz);
    const int isLastTransfer         = (leftPktSz == wantSz);//totalTransferSz + wantSz >= _bufManager.tplcmdTotalSz;
    const u32 bufSzNotDisposed       = ((u32)totalTransferSz)% _bufManager.writeBackUnitSz;//buffer data not disposed, bufSz is always writeBackUnitSz
    const u8* BufBase = (OPTIMUS_MEDIA_TYPE_MEM != _bufManager.destMediaType)  ? _bufManager.transferBuf :
                        (u8*)(u64)_bufManager.partBaseOffset ;

    if (wantSz < _bufManager.transferUnitSz && !isLastTransfer) {
        DWN_ERR("only last transfer can less 64K, this index %d at size 0x%u illegle\n", totalSlotNum + 1, wantSz);
        return OPT_DOWN_FAIL;
    }

    //TODO: totalSlotNum + 1 == sequenceNo
    if (totalSlotNum + 1 != sequenceNo) {//ASSERT it ??

    }

    *pBuf  = (char*)(bufSzNotDisposed + BufBase);
    DWN_DBG("bufSzNotDisposed 0x%x, _bufManager.transferBuf 0x%p, _bufManager.partBaseOffset 0x%x, *pBuf 0x%p\n",
            bufSzNotDisposed, _bufManager.transferBuf, _bufManager.partBaseOffset, *pBuf);

    _bufManager.pktTransferSta      = PKT_TRANSFER_STA_WORKING;

    //prepare data for upload
    if (!bufSzNotDisposed && _bufManager.isUpload)
    {
        u32 wantSz = (leftPktSz > _bufManager.writeBackUnitSz) ? _bufManager.writeBackUnitSz : ((u32)leftPktSz);
        DWN_DBG("want size 0x%x\n", wantSz);

        u32 readSz = optimus_dump_storage_data((u8*)BufBase, wantSz, errInfo);
        if (readSz != wantSz) {
            DWN_ERR("Want read %u, but %u\n", wantSz, readSz);
            return OPT_DOWN_FAIL;
        }
    }

    return OPT_DOWN_OK;
}

int optimus_buf_manager_report_transfer_complete(const u32 transferSz, char* errInfo)
{
    const unsigned totalSlotNum      = _bufManager.totalSlotNum;
    const u64 totalTransferSz        = ((u64)totalSlotNum) * _bufManager.transferUnitSz + transferSz;
    const u64 leftPktSz              = (totalTransferSz > _bufManager.tplcmdTotalSz) ? 0 :(_bufManager.tplcmdTotalSz - totalTransferSz);
    const u32 thisWriteBackSz        = (_bufManager.transferUnitSz == transferSz) ? _bufManager.writeBackUnitSz : ((u32)totalTransferSz % _bufManager.writeBackUnitSz);
    const u8* BufBase = (OPTIMUS_MEDIA_TYPE_MEM != _bufManager.destMediaType)  ? _bufManager.transferBuf :
                        (u8*)(u64)_bufManager.partBaseOffset ;

    DWN_DBG("transferSz=0x%x\n", transferSz);
    //state fileds to update
    _bufManager.totalSlotNum += 1;
    if (_bufManager.totalSlotNum == _bufManager.nextWriteBackSlot)
    {
        u32   burnSz   = 0;
        u32   leftSz   = _bufManager.leftDataSz;//data size not write to media in previous write back, > 0 only when not normal packet
        const u32 size = leftSz + thisWriteBackSz;
        const u8* data = (u8*)BufBase -leftSz;
        const unsigned reserveNotAlignSz = leftPktSz ? _bufManager.itemOffsetNotAlignClusterSz_f : 0;//reserve

        //itemOffsetNotAlignClusterSz_f is from sdcard/usb local package
        //emmc write need align cluster to make next write offset align clusterm
        DWN_DBG("size 0x%x, reserveNotAlignSz 0x%x\n", size, reserveNotAlignSz);
#if CONFIG_AML_LOCAL_BURN_BUFF_NOT_ALIGN
        //As aml_upgrade_package.img is aligned 4,so data from pkg may not align 8 in sdc/usb disk burn case
        //data not align will invoke emmc write error (may dma issue ?)
        //Need Macro as newer chip family such as u200 has not this failure
        if ((uint64_t)data & 0x7) {
            DWN_MSG("data %p not align 64bit\n", data);
            u8* alignBuf = (u8*)(((uint64_t)data>>3) << 3);
            memmove(alignBuf, data, size);
            data = alignBuf;
        }
#endif//#if CONFIG_AML_LOCAL_BURN_BUFF_NOT_ALIGN
        burnSz = optimus_download_img_data(data, size - reserveNotAlignSz, errInfo);
        if (burnSz <= leftSz || !burnSz) {
            DWN_ERR("this burn size %d <= last left size %d, data 0x%p\n", burnSz, leftSz, data);
            return OPT_DOWN_FAIL;
        }
        if (size - reserveNotAlignSz < burnSz) {
            DWN_ERR("Exception:siz 0x%x < burnSz 0x%x\n", size - reserveNotAlignSz, burnSz);
            return OPT_DOWN_FAIL;
        }

        leftSz = size - burnSz;
        if (leftSz)
        {
            const u8* src = data + burnSz;
            u8* dest = (u8*)BufBase - leftSz;

            if (totalTransferSz >= _bufManager.tplcmdTotalSz) {
                DWN_ERR("Exception:packet end but data left 0x%x, totalTransferSz 0x%llx, cmd sz 0x%llx!\n",
                        leftSz, totalTransferSz, _bufManager.tplcmdTotalSz);
                return OPT_DOWN_FAIL;
            }

            if (leftSz > OPTIMUS_SPARSE_IMG_LEFT_DATA_MAX_SZ) {
                DWN_ERR("Exception, left data sz 0x%x > back buf sz 0x%x!\n", leftSz, OPTIMUS_SPARSE_IMG_LEFT_DATA_MAX_SZ);
                return OPT_DOWN_FAIL;
            }
            if (leftSz & 0x03) {
                DWN_ERR("Exception, copy size not align to 4! May will copy fail!\n");
                return OPT_DOWN_FAIL;
            }

            DWN_DBG("MV:left size 0x%08x, src %p, dest %p\n", leftSz, src, dest);
            memcpy(dest, src, leftSz);
        }

        //update _bufManager.leftDataSz and _bufManager.nextWriteBackSlot
        _bufManager.leftDataSz = leftSz;
        if (leftPktSz >= _bufManager.writeBackUnitSz)
        {
            _bufManager.nextWriteBackSlot += _bufManager.writeBackUnitSz/_bufManager.transferUnitSz;
        }
        else
        {
            _bufManager.nextWriteBackSlot += ((u32)leftPktSz + _bufManager.transferUnitSz - 1)/_bufManager.transferUnitSz;
        }
    }

    optimus_update_progress(transferSz);//report burning steps
    return OPT_DOWN_OK;
}

int is_largest_data_transferring(void)
{
    const unsigned totalSlotNum      = _bufManager.totalSlotNum;
    const u64 totalTransferSz        = ((u64)totalSlotNum) * _bufManager.transferUnitSz;//data size already transferred

    return (PKT_TRANSFER_STA_WORKING == _bufManager.pktTransferSta)
        && (_bufManager.tplcmdTotalSz > totalTransferSz);//as last packet may less than 64k, var totalSlotNum may > _bufManager.tplcmdTotalSz
}

int set_largest_data_transfer_sta_end(void)
{
    _bufManager.pktTransferSta = PKT_TRANSFER_STA_END;
    return 0;
}

//command data format: [0-3]reserver, [4-7]dataLen, [8-11]sequence number, [12-15]check sum
int optimus_buf_manager_get_command_data_for_upload_transfer(u8* cmdDataBuf, const unsigned bufLen)
{
    const unsigned totalSlotNum      = _bufManager.totalSlotNum;
    const u64 totalTransferSz        = ((u64)totalSlotNum) * _bufManager.transferUnitSz;
    const u64 leftPktSz              = (totalTransferSz > _bufManager.tplcmdTotalSz) ? 0 :(_bufManager.tplcmdTotalSz - totalTransferSz);
    const unsigned thisTransDataLen = (leftPktSz > _bufManager.transferUnitSz) ? _bufManager.transferUnitSz : ((u32)leftPktSz);

    DWN_DBG("thisTransDataLen 0x%x, left 0x%x, total 0x%x\n", thisTransDataLen, (u32)leftPktSz, (u32)totalTransferSz);
    DWN_DBG("totalSlotNum %d, totalTransferSz 0x%x\n", totalSlotNum, (u32)totalTransferSz);
    memset(cmdDataBuf, bufLen, 0);
    *(unsigned*)(cmdDataBuf + 0) = 0xefe8;
    *(unsigned*)(cmdDataBuf + 4) = thisTransDataLen;//Fill transfer data length of this bulk transfer

    _bufManager.pktTransferSta      = PKT_TRANSFER_STA_WORKING;
    return 0;
}


