/*
 * \file        optimus_sdc_update.c
 * \brief       sdc_update command to burn a parition image from mmc
 *              this update based on the burner is latest: (uboot for burnner can run from peripherals such as sdmmc/usb)
 *
 * \version     1.0.0
 * \date        2014-9-15
 * \author      Sam.Wu <yihui.wu@amlogic.com>
 *				Chunyu.Song <chunyu.song@amlogic.com>
 * Copyright (c) 2014 Amlogic. All Rights Reserved.
 *
 */
#include "optimus_sdc_burn_i.h"
#include <partition_table.h>

typedef int __hFileHdl;

#define BURN_DBG 0
#if BURN_DBG
#define SDC_DBG(fmt...) printf(fmt)
#else
#define SDC_DBG(fmt...)
#endif//if BURN_DBG

#define SDC_MSG         DWN_MSG
#define SDC_ERR         DWN_ERR

static char _errInfo[512] = "";

//default is mmc 0:1, i.e, part 1 of first registered mmc device
int optimus_device_probe(const char* interface, const char* inPart)
{
	block_dev_desc_t *dev_desc=NULL;
	int dev=0;
	int part=1;
	char *ep;

	dev = (int)simple_strtoul(inPart, &ep, 16);
	dev_desc = get_dev((char*)interface,dev);
	if (dev_desc == NULL) {
		puts("\n** Invalid boot device **\n");
		return 1;
	}
	if (*ep) {
		if (*ep != ':') {
			puts("\n** Invalid boot device, use `dev[:part]' **\n");
			return 1;
		}
		part = (int)simple_strtoul(++ep, NULL, 16);
	}
	if (optimus_fat_register_device(dev_desc,part) != 0) {
		printf("\n** Unable to use %s %d:%d for device probe **\n",
			interface, dev, part);
		return 1;
	}

    return 0;
}


__hFileHdl opt_file_open(const char* imgItemPath)
{
    __hFileHdl hFile = 0;

#if 0
    //FIXME: Check this probe needed!!!
    if (device_probe("mmc", "0")) {
        SDC_ERR("Fail to probe mmc 0");
        return -1;
    }
#endif//#if 0

    hFile = do_fat_fopen(imgItemPath);

    return hFile;
}

int opt_file_read(__hFileHdl hFile, u8* buffer, const unsigned size)
{
    unsigned readSz = do_fat_fread(hFile, buffer, size);
    if (readSz != size) {
        SDC_ERR("Want to read 0x%x, but 0x%x\n", size, readSz);
        return __LINE__;
    }

    return 0;
}

int opt_file_close(__hFileHdl hFile)
{
    do_fat_fclose(hFile);

    return 0;
}

//part size 0 if failed
s64 storage_get_partition_size_in_byte(const char* partName)
{
    int ret = 0;
    u64 size = 0;

    if ( !strcmp("_aml_dtb", partName) )
    {
        return AML_DTB_IMG_MAX_SZ;
    }

    ret = store_get_partititon_size((u8*)partName, &size);
    if (ret) {
        SDC_ERR("Fail to get size for part %s\n", partName);
        return 0;
    }
    size <<= 9;//trans sector to byte

    return size;
}

//0 is OK, others failed
int sdc_burn_buf_manager_init(const char* partName, s64 imgItemSz, const char* fileFmt,
        const unsigned itemSizeNotAligned /* if item offset 3 and bytepercluste 4k, then it's 4k -3 */)
{
    int rcode = 0;
    s64 partCapInByte   = 0;
    const char* destMediaType = "store";
    const u64 partBaseOffset = 0;

    //TODO:bootloader size can't get yet!
    if (strcmp("bootloader", partName))
    {
        partCapInByte = storage_get_partition_size_in_byte(partName);
        if (partCapInByte < imgItemSz || !partCapInByte) {
            SDC_ERR("partCapInByte 0x[%x, %x] < imgItemSz 0x[%x, %x]\n",
                    (u32)(partCapInByte>>32), (u32)partCapInByte, (u32)(imgItemSz>>32), (u32)imgItemSz);
            return __LINE__;
        }
    }

    rcode = optimus_parse_img_download_info(partName, imgItemSz, fileFmt, destMediaType, partBaseOffset);
    if (rcode) {
        SDC_ERR("fail in init down info, rcode %d\n", rcode);
        return __LINE__;
    }
    rcode = optimus_buf_manager_tplcmd_init(destMediaType, partName, 0, fileFmt, imgItemSz, 0, itemSizeNotAligned);
    if (rcode) {
        SDC_ERR("Fail in buf manager init\n");
        return __LINE__;
    }

    return rcode;
}

int sdc_burn_verify(const char* verifyFile)
{
    int rcode = 0;
    char* argv[8];
    char  verifyCmd[64] = "";
    char cmdBuf[64];
    char *usb_update = getenv("usb_update");

    run_command("mmcinfo", 0);
    if (!strcmp(usb_update,"1")) {
          sprintf(cmdBuf, "%s 0x%p %s",  "fatload usb 0 ", verifyCmd, verifyFile);
    }
    else{
          sprintf(cmdBuf, "%s 0x%p %s",  "fatload mmc 0 ", verifyCmd, verifyFile);
    }
    SDC_DBG("To run cmd [%s]\n", cmdBuf);
    rcode = run_command(cmdBuf, 0);
    if (rcode < 0) {
        SDC_ERR("Fail in cmd fatload\n");
        return __LINE__;
    }
    SDC_MSG("cmd verify[%s]\n", verifyCmd);

    rcode = cli_simple_parse_line(verifyCmd, argv + 1);
    if (rcode != 2) {
        SDC_ERR("verify cmd argc must be 2, but %d\n", rcode);
        return __LINE__;
    }
    argv[0] = "verify";

    rcode = optimus_media_download_verify(3, argv, _errInfo);
    if (rcode) {
        SDC_ERR("Fail to verify\n");
        return __LINE__;
    }
    return 0;
}

int optimus_burn_partition_image(const char* partName, const char* imgItemPath, const char* fileFmt, const char* verifyFile, const unsigned itemSizeNotAligned)
{
    int rcode = 0;
    s64 imgItemSz       = 0;
    s64 leftItemSz      = 0;
    u32 thisReadLen     = 0;
    __hFileHdl hImgItem     = 0;
    char* downTransBuf  = NULL;//get buffer from optimus_buffer_manager
    const unsigned ItemReadBufSz = OPTIMUS_DOWNLOAD_SLOT_SZ;//read this size from image item each time
    unsigned sequenceNo = 0;

    imgItemSz = leftItemSz = do_fat_get_fileSz(imgItemPath);
    if (!imgItemSz) {
        SDC_ERR("Fail to get image %s from mmc\n", imgItemPath);
        return __LINE__;
    }

    rcode = sdc_burn_buf_manager_init(partName, imgItemSz, fileFmt, itemSizeNotAligned);
    if (rcode) {
        SDC_ERR("fail in sdc_burn_buf_manager_init, rcode %d\n", rcode);
        return __LINE__;
    }

    hImgItem = opt_file_open(imgItemPath);
    if (hImgItem < 0) {
        SDC_ERR("Fail to open the item %s\n", imgItemPath);
        return __LINE__;
    }

    /*optimus_progress_init((u32)(imgItemSz>>32), (u32)imgItemSz, 0, 100);*/

    //for each loop:
    //1, get buffer from buffer_manager,
    //2, read item data to buffer,
    //3, report data ready to buffer_manager
    for (; leftItemSz > 0; leftItemSz -= thisReadLen, sequenceNo++)
    {
        thisReadLen = leftItemSz > ItemReadBufSz ? ItemReadBufSz: (u32)leftItemSz;

        rcode = optimus_buf_manager_get_buf_for_bulk_transfer(&downTransBuf, thisReadLen, sequenceNo, _errInfo);
        if (rcode) {
            SDC_ERR("fail in get buf, msg[%s]\n", _errInfo);
            goto _finish;
        }

        rcode = opt_file_read(hImgItem, (u8*)downTransBuf, thisReadLen);
        if (rcode) {
            SDC_ERR("fail in read data from item,rcode %d\n", rcode);
            goto _finish;
        }

        rcode = optimus_buf_manager_report_transfer_complete(thisReadLen, _errInfo);
        if (rcode) {
            SDC_ERR("fail in report data ready, rcode %d\n", rcode);
            goto _finish;
        }

        /*optimus_update_progress(thisReadLen);//report burning steps*/
    }

    if (leftItemSz <= 0) {
        printf("BURN %s to part %s OK!\n", imgItemPath, partName);
    }

_finish:
    opt_file_close(hImgItem);

    if (!rcode && verifyFile)
    {
        rcode = sdc_burn_verify(verifyFile);
    }

    printf("=====>Burn part %s in fmt %s %s<======\n\n", partName, fileFmt, rcode ? "FAILED!!": "OK");
    return rcode;
}

//step 1: get script file size, and get script file contents
//step 2: read image file
//"Usage: sdc_update partiton image_file_path [imgFmt, verifyFile]\n"   //usage
int do_sdc_update(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int rcode = 0;
    const char* partName    = argv[1];
    const char* imgItemPath = argv[2];
    const char* fileFmt     = argc > 3 ? argv[3] : NULL;
    const char* verifyFile  = argc > 4 ? argv[4] : NULL;

    setenv("usb_update","0");
#if BURN_DBG
    printf("argc %d, %s, %s\n", argc, argv[0], argv[1]);
    if (argc < 3)
    {
        partName    = "system";
        imgItemPath = "rec.img";
        fileFmt     = "normal";
        verifyFile  = "recovery.verify";
    }
#else
	if (argc < 3) {
        cmd_usage(cmdtp);
		return __LINE__;
	}
#endif//#if BURN_DBG

    //mmc info to ensure sdcard inserted and inited
    rcode = run_command("mmcinfo", 0);
    if (rcode) {
        SDC_ERR("Fail in init mmc, Does sdcard not plugged in?\n");
        return __LINE__;
    }

    rcode = optimus_device_probe("mmc", "0");
    if (rcode) {
        SDC_ERR("Fail to detect device mmc 0\n");
        return __LINE__;
    }

    if (!fileFmt)
    {
        rcode = do_fat_get_file_format(imgItemPath, (u8*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR, (8*1024));
        if (rcode < 0) {
            SDC_ERR("Fail when parse file format\n");
            return __LINE__;
        }
        fileFmt = rcode ? "sparse" : "normal";
    }

    rcode = optimus_burn_partition_image(partName, imgItemPath, fileFmt, verifyFile, 0);
    if (rcode) {
        SDC_ERR("Fail to burn partition (%s) with image file (%s) in format (%s)\n", partName, imgItemPath, fileFmt);
    }

    return rcode;
}

U_BOOT_CMD(
   sdc_update,      //command name
   5,               //maxargs
   0,               //repeatable
   do_sdc_update,   //command function
   "Burning a partition with image file in sdmmc card",           //description
   "    argv: <part_name> <image_file_path> <[,fileFmt]> <[,verify_file]> \n"   //usage
   "    - <fileFmt> parameter is optional, if you know it you can specify it.\n"
   "        for Android, system.img and data.img is \"sparse\" format, other is \"normal\"\n"   //usage
   "    - <verify_file> parameter is optional, if you have it you can specify it.\n"
   "    - e.g. \n"
   "        to burn partition boot with boot.img of mmc 0 : \"sdc_update boot boot.img\"\n"   //usage
   "        to burn partition system with system.img of mmc 0 : \"sdc_update system system.img\"\n"   //usage
);


