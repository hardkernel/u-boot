/*
 * \file        optimus_simg2img.c
 * \brief       sparse image to ext4 image in optimus system
 *              a sparse image consit of "file_header + chunk_num * (chunk_header + [chunk_data]),
 *              chunk data can be empty when chunk type is CHUNK_TYPE_DONT_CARE"
 *
 * \version     1.0.0
 * \date        2013/5/6
 * \author      Sam.Wu <yihui.wu@Amlogic.com>
 *
 * Copyright (c) 2013 Amlogic Inc. All Rights Reserved.
 *
 */
#include "../v2_burning_i.h"
#include <partition_table.h>

#define sperr               DWN_ERR
#define spmsg(fmt ...)      //printf("[spmsg]"fmt)
#define spdbg(fmt ...)      //printf("[spdbg]"fmt)

#define  SPARSE_HEADER_MAJOR_VER 1
#define  CHUNK_HEAD_SIZE        sizeof(chunk_header_t)
#define  FILE_HEAD_SIZE         sizeof(sparse_header_t)

//states for a sparse packet, initialized when sparse packet probed
static struct
{
    unsigned leftChunkNum;//chunks that not parsed yet
    unsigned chunksBufLen;//>=OPTIMUS_DOWNLOAD_SPARSE_TRANSFER_SZ

    unsigned sparseBlkSz;//block size of sparse format packet
    unsigned parsedPacketCrc;//crc value for packet that already parsed

    s32      pktHeadLen;
    u32      reservetoAlign64;

    //If long chunk data sz > write back size(e.g. 64M), write it at next write back time, This can't reduce copy and use less buffer
    u32      notWrBackSz4LongChunk;
    u32      nextFlashAddr4LastLongChunk; //flash start Addr not write back chunk data , in sector

    //back up infomation for verify
    u32      chunkInfoBackAddr;//file header and chunk info back address
    u32      backChunkNum;      //chunk number backed
    u64      chunkOffset;

}_spPacketStates;

//0 is not sparse packet header, else is sparse packet_header
int optimus_simg_probe(const u8* source, const u32 length)
{
	sparse_header_t *header = (sparse_header_t*) source;

    if (length < sizeof(sparse_header_t)) {
        sperr("length %d < sparse_header_t len %d\n", length, (int)FILE_HEAD_SIZE);
        return 0;
    }
	if (header->magic != SPARSE_HEADER_MAGIC) {
		spmsg("sparse bad magic, expect 0x%x but 0x%x\n", SPARSE_HEADER_MAGIC, header->magic);
		return 0;
	}

    if(!(SPARSE_HEADER_MAJOR_VER == header->major_version
                && FILE_HEAD_SIZE == header->file_hdr_sz
                && CHUNK_HEAD_SIZE == header->chunk_hdr_sz))
    {
        sperr("want 0x [%x, %x, %x], but [%x, %x, %x]\n",
                SPARSE_HEADER_MAJOR_VER,    (unsigned)FILE_HEAD_SIZE,             (unsigned)CHUNK_HEAD_SIZE,
                header->major_version,      header->file_hdr_sz,        header->chunk_hdr_sz);
        return 0;
    }


	return 1;
}

int optimus_simg_parser_init(const u8* source)
{
	sparse_header_t *header = (sparse_header_t*) source;

    memset(&_spPacketStates, 0, sizeof(_spPacketStates));
    _spPacketStates.leftChunkNum    = header->total_chunks;
    _spPacketStates.parsedPacketCrc = 0;
    _spPacketStates.pktHeadLen      = header->file_hdr_sz;
    _spPacketStates.sparseBlkSz     = header->blk_sz;//often 4k
    spmsg("totalChunkNum %d, fileHeadSz 0x%x, chunkHeadSz 0x%zx\n", _spPacketStates.leftChunkNum, _spPacketStates.pktHeadLen, CHUNK_HEAD_SIZE);

    //for verify
    _spPacketStates.chunkInfoBackAddr = OPTIMUS_DOWNLOAD_SPARSE_INFO_FOR_VERIFY;
    _spPacketStates.backChunkNum      = 0;
    memcpy((void*)(u64)_spPacketStates.chunkInfoBackAddr, header, sizeof(sparse_header_t));
    spmsg("back header addr 0x%x\n", _spPacketStates.chunkInfoBackAddr);

	return OPT_DOWN_OK;
}

//return value: flash address offset in sector in this time dispose
//call this method to parse sparse format data and write it to media
//@flashAddrInSec: flash write address of first chunk
//@simgPktHead   : buffered sparse image
//@pktLen        : buffered sparse data len
//@unParsedDataLen: data length need write at next write back time
//      Take care the size to align 64K for flash and and addres to align sector!!!!
int optimus_simg_to_media(char* simgPktHead, const u32 pktLen, u32* unParsedDataLen, const u32 flashAddrInSec)
{
    const unsigned notWrBackSz4LongChunk = _spPacketStates.notWrBackSz4LongChunk;
    unsigned unParsedBufLen = pktLen - _spPacketStates.pktHeadLen;
    u32 flashAddrStart = flashAddrInSec;
    chunk_header_t* pChunk = (chunk_header_t*)(simgPktHead + _spPacketStates.pktHeadLen);
    chunk_header_t* backChunkHead = (chunk_header_t*)(_spPacketStates.chunkInfoBackAddr + FILE_HEAD_SIZE) + _spPacketStates.backChunkNum;

    if (notWrBackSz4LongChunk && !_spPacketStates.pktHeadLen/*0 if head*/)
    {
        //const chunk_header_t* pLastLongChunk = backChunkHead - 1;////
        //const unsigned leftLongChunk_dataLen = pLastLongChunk->total_sz;
        const unsigned leftLongChunk_flashAddr = _spPacketStates.nextFlashAddr4LastLongChunk;
        unsigned writeLen = 0;
        unsigned thisWriteLen = 0;

        thisWriteLen = notWrBackSz4LongChunk >= pktLen ? pktLen : notWrBackSz4LongChunk;
        if (notWrBackSz4LongChunk > thisWriteLen) {
            //Align write size to 64K for flash write until last flash write
            //At least make sure align to sector as flashAddress in sector here!!!
            thisWriteLen >>= OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS; thisWriteLen <<= OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS;
            spmsg("pktLen(0x%08x) < long chunk leftLen 0x%x08\n", pktLen, notWrBackSz4LongChunk);
        }
        spmsg("notWrBackSz4LongChunk 0x%08x, thisWriteLen 0x%08x, flashAddr 0x%08xSec\n", notWrBackSz4LongChunk, thisWriteLen, leftLongChunk_flashAddr);

        writeLen = optimus_cb_simg_write_media(leftLongChunk_flashAddr, thisWriteLen, simgPktHead);
        if (thisWriteLen != writeLen) {
            sperr("Want to write left chunk sz 0x%x, but only 0x%x\n", thisWriteLen, writeLen);
            return -__LINE__;
        }

        unParsedBufLen -= thisWriteLen;
        _spPacketStates.notWrBackSz4LongChunk -= thisWriteLen;

        if (notWrBackSz4LongChunk >= pktLen) //packet data ended
        {
            _spPacketStates.nextFlashAddr4LastLongChunk += thisWriteLen>>9;//address needed next write time
            *unParsedDataLen = unParsedBufLen;
            return 0;//the long chunk not disposed all yet!
        }

        pChunk = (chunk_header_t*)(simgPktHead + notWrBackSz4LongChunk + _spPacketStates.pktHeadLen);
    }


    spdbg("headLen=0x%x, leftNum=%d, backNum %d\n", _spPacketStates.pktHeadLen, _spPacketStates.leftChunkNum, _spPacketStates.backChunkNum);
    for (;_spPacketStates.leftChunkNum && !_spPacketStates.notWrBackSz4LongChunk; _spPacketStates.leftChunkNum--)
    {
        //chunk data for ext4, but maybe empty in sparse, that is why called sparse format
        const unsigned chunkDataLen = pChunk->chunk_sz * _spPacketStates.sparseBlkSz;
        unsigned thisWriteLen = 0;

        if (CHUNK_HEAD_SIZE > unParsedBufLen) {//total size not enough for CHUNK_HEAD_SIZE yet!!
            spmsg("unParsedBufLen 0x%x < head sz 0x%zx\n", unParsedBufLen, CHUNK_HEAD_SIZE);
            break;
        }

        switch (pChunk->chunk_type)
        {
        case CHUNK_TYPE_RAW:
            {
                unsigned wantWrLen = chunkDataLen;

                if (CHUNK_HEAD_SIZE + chunkDataLen != pChunk->total_sz) {
                    sperr("sparse: bad chunk size: head 0x%x + data 0x%x != total 0x%x\n",
                            (unsigned)CHUNK_HEAD_SIZE, chunkDataLen, pChunk->total_sz);
                    return -__LINE__;
                }

                if (pChunk->total_sz > unParsedBufLen)//left data not enough for this chunk (chunk header + chunk data)
                {
                    const unsigned unParseChunkDataLen = unParsedBufLen - CHUNK_HEAD_SIZE;

                    wantWrLen = (unParseChunkDataLen >> OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS) << OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS;
                    _spPacketStates.notWrBackSz4LongChunk = chunkDataLen - wantWrLen;
                    _spPacketStates.nextFlashAddr4LastLongChunk = flashAddrStart + (wantWrLen>>9);
                    spmsg("Not enough one chunk: unParseChunkDataLen 0x%x ,chunk data len 0x%x, wantWrLen 0x%x, left 0x%08x\n",
                            unParseChunkDataLen, chunkDataLen, wantWrLen, _spPacketStates.notWrBackSz4LongChunk);
                }

                if (wantWrLen)
                {
                    thisWriteLen = optimus_cb_simg_write_media(flashAddrStart, wantWrLen, (char*)pChunk + CHUNK_HEAD_SIZE);
                    if (thisWriteLen != wantWrLen) {
                        sperr("Fail to write to flash, want to write %dB, but %dB\n", wantWrLen, thisWriteLen);
                        return -__LINE__;
                    }
                }
            }
            break;

        case CHUNK_TYPE_DONT_CARE:
            {
                DWN_DBG("don't care chunk\n");
                if (CHUNK_HEAD_SIZE != pChunk->total_sz) {
                    sperr("bogus DONT CARE chunk\n");
                    return -__LINE__;
                }

            }
            break;

        case CHUNK_TYPE_FILL:
            {
                    const unsigned fillVal = *(unsigned*)(pChunk + 1);
                    unsigned LeftDataLen   = chunkDataLen;
                    unsigned temp_flashAddrStart = flashAddrStart;
                    unsigned* pFillValBuf = (unsigned*)OPTIMUS_SPARSE_IMG_FILL_VAL_BUF;
                    const unsigned FillBufSz = OPTIMUS_SPARSE_IMG_FILL_BUF_SZ;
                    static unsigned _filledBufValidLen = 0;
                    const unsigned thisChunkFilledLen = min(chunkDataLen, FillBufSz);
                    int _NeedFillAsNotErasedYet = 0;

                    spdbg("CHUNK_TYPE_FILL,fillVal=0x%8x, chunkDataLen=0x%8x, thisChunkFilledLen=0x%x\n",
                                    fillVal, chunkDataLen, thisChunkFilledLen);
                    if (CHUNK_HEAD_SIZE + 4 != pChunk->total_sz) {
                            sperr("error FILL chunk\n");
                            return -__LINE__;
                    }
                    switch (device_boot_flag) {
                            case EMMC_BOOT_FLAG:
                            case SPI_EMMC_FLAG:
                                    _NeedFillAsNotErasedYet = (fillVal != 0);
                                    break;

                            case NAND_BOOT_FLAG:
                            case SPI_NAND_FLAG:
                                    _NeedFillAsNotErasedYet = (fillVal != 0XFFFFFFFFU);
                                    break;
                            default:
                                    _NeedFillAsNotErasedYet = 1;
                                    break;
                    }
                    //for, emmc, if fillVal is 0, then _NeedFillAsNotErasedYet = false if "disk_inital > 0"
                    if (!_NeedFillAsNotErasedYet)_NeedFillAsNotErasedYet = (is_optimus_storage_inited()>>16) == 0;// == 0 means 'disk_inital 0'

                    if (_NeedFillAsNotErasedYet)
                    {
                            if (!_filledBufValidLen) {
                                    DWN_MSG("CHUNK_TYPE_FILL\n");
                            }
                            if (fillVal != *pFillValBuf && _filledBufValidLen) {
                                    _filledBufValidLen = 0;
                            }
                            if (_filledBufValidLen < thisChunkFilledLen) {
                                    int i = _filledBufValidLen>>2;
                                    unsigned* temBuf = pFillValBuf + i;

                                    while (i++ < (thisChunkFilledLen>>2)) *temBuf++ = fillVal;
                                    _filledBufValidLen = thisChunkFilledLen;
                            }

                            DWN_DBG("LeftDataLen to fill:0x%x\n", LeftDataLen);
                            do {
                                    unsigned actualWrLen = 0;

                                    thisWriteLen = min(LeftDataLen, thisChunkFilledLen);

                                    actualWrLen = optimus_cb_simg_write_media(temp_flashAddrStart, thisWriteLen, (char*)pFillValBuf);
                                    if (actualWrLen != thisWriteLen) {
                                            sperr("FILL_CHUNK:Want write 0x%x Bytes, but 0x%x\n", thisWriteLen, actualWrLen);
                                            break;
                                    }

                                    temp_flashAddrStart += thisWriteLen >> 9;
                                    LeftDataLen -= thisWriteLen;
                            }while(LeftDataLen);
                    }
                    thisWriteLen = 4;///////////
            }
            break;
        case CHUNK_TYPE_CRC32:
            sperr("CHUNK_TYPE_CRC32 unsupported yet!\n");
            return -__LINE__;
        default:
            sperr("unknown chunk ID 0x%x at %p\n", pChunk->chunk_type, pChunk);
            return -__LINE__;
        }

        /////update for next chunk
        unParsedBufLen                  -= CHUNK_HEAD_SIZE + thisWriteLen;
        flashAddrStart                  += chunkDataLen>>9;
        memcpy(backChunkHead, pChunk, CHUNK_HEAD_SIZE);//back up verify chunk info
        spdbg("index %d ,tp 0x%x\n", _spPacketStates.backChunkNum, backChunkHead->chunk_type);
        ++_spPacketStates.backChunkNum;
        ++backChunkHead;

        pChunk                           =  (chunk_header_t*)((u64)pChunk + pChunk->total_sz);
    }

    spmsg("leftChunkNum %d, bak num %d\n", _spPacketStates.leftChunkNum, _spPacketStates.backChunkNum);

    _spPacketStates.pktHeadLen      = 0;//>0 only when first time

    *unParsedDataLen = unParsedBufLen;
    return (flashAddrStart - flashAddrInSec);
}

int optimus_sparse_back_info_probe(void)
{
    int ret = 0;

    if (_spPacketStates.leftChunkNum)
    {
        DWN_ERR("%d chunk left, image not burn completed!!\n", _spPacketStates.leftChunkNum);
        return OPT_DOWN_FALSE;
    }

    ret = optimus_simg_probe((u8*)(u64)_spPacketStates.chunkInfoBackAddr, FILE_HEAD_SIZE);
    DWN_DBG("back h addr 0x%x\n", _spPacketStates.chunkInfoBackAddr);

    return ret;
}

//get next chunk data to read from ext4 partition
int optimus_sparse_get_chunk_data(u8** head, u32* headSz, u32* dataSz, u64* dataOffset)
{
    chunk_header_t* pChunk = (chunk_header_t*)(_spPacketStates.chunkInfoBackAddr + FILE_HEAD_SIZE) + _spPacketStates.leftChunkNum;//chunk header

    *headSz = *dataOffset = *dataSz = 0;
    DWN_DBG("leftNum %d\n", _spPacketStates.backChunkNum);

    if (!_spPacketStates.leftChunkNum) //file header
    {
        *headSz = FILE_HEAD_SIZE;
        *head   = (u8*)(u64)_spPacketStates.chunkInfoBackAddr;
    }
    else
    {
        *head = (u8*)pChunk;
    }

    //parse until RAW chunk or no chunk left
    for (;_spPacketStates.leftChunkNum < _spPacketStates.backChunkNum;)
    {
        const unsigned chunkDataLen = pChunk->chunk_sz * _spPacketStates.sparseBlkSz;

        switch (pChunk->chunk_type)
        {
        case CHUNK_TYPE_RAW:
            {
                if (CHUNK_HEAD_SIZE + chunkDataLen != pChunk->total_sz) {
                    sperr("sparse: bad chunk size!\n");
                    return OPT_DOWN_FAIL;
                }

                *dataSz = chunkDataLen;
            }
            break;

        case CHUNK_TYPE_DONT_CARE:
            {
                spdbg("don't care chunk\n");
                if (CHUNK_HEAD_SIZE != pChunk->total_sz) {
                    sperr("bogus DONT CARE chunk\n");
                    return OPT_DOWN_FAIL;
                }
            }
            break;

        case CHUNK_TYPE_FILL:
            {
                spdbg("CHUNK_TYPE_FILL\n");
                if (CHUNK_HEAD_SIZE + 4 != pChunk->total_sz) {
                    sperr("bogus DONT CARE chunk\n");
                    return OPT_DOWN_FAIL;
                }
                *dataSz = 4;///////
            }
            break;


        default:
            sperr("unknown chunk ID 0x%x, parsed %d, total %d\n", pChunk->chunk_type, _spPacketStates.leftChunkNum, _spPacketStates.backChunkNum);
            return OPT_DOWN_FAIL;
        }

        //update backed chunk info
        *dataOffset = _spPacketStates.chunkOffset;//attention that offset < totalDataLen

        _spPacketStates.chunkOffset += chunkDataLen;;
        *headSz += CHUNK_HEAD_SIZE;
        ++pChunk;
        ++_spPacketStates.leftChunkNum;

        if (*dataSz) break;
    }

    spdbg("left %d, total %d\n", _spPacketStates.leftChunkNum, _spPacketStates.backChunkNum);
    return OPT_DOWN_OK;
}


#if 0
int do_timestamp(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
/*const char* optimus_time_stamp(void)*/
{
    const char* _formatStr = "[%5d.%03d]";
    static char TimeStr[32] ;
    int timeMSec = 0;
    ulong curTimeInUSec = 0;
static ulong timeInUSec = 0;

    if (!timeInUSec)
    {
        timeInUSec = get_timer(timeInUSec);
        return 0;
    }
    timeInUSec = curTimeInUSec = get_timer(timeInUSec);//timer unit is in uS

    /*printf("time %x, %x\n", (u32)(timeInUSec>>32), (u32)timeInUSec);*/
    /*if(!timeInUSec) return "";//As eFG_printf and uart_printf use while(*str) to determin whether to print, here make use it to not to print*/

    /*curTimeInUSec    /= 1000;//time to mSec*/
    timeMSec   = curTimeInUSec % 1000;
    curTimeInUSec    /= 1000;//time to Second

    sprintf(TimeStr, _formatStr, (u32)curTimeInUSec, timeMSec);
    printf(TimeStr);
    printf("\n");

    /*return TimeStr;*/
    return 0;
}

U_BOOT_CMD(
   timestamp,      //command name
   5,               //maxargs
   1,               //repeatable
   do_timestamp,   //command function
   "Burning a partition from sdmmc ",           //description
   "Usage: sdc_update partiton image_file_path fileFmt(sparse or normal)\n"   //usage
);
#endif//#if 0

