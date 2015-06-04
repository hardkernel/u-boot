/*
 * \file        optimus_usb_update.c
 * \brief       usb_update command to burn a parition image from usb host
 *              this update based on the burner is latest: (uboot for burnner can run from peripherals such as sdmmc/usb)
 *
 * \version     1.0.0
 * \date        2014-9-15
 * \author      Chunyu.Song<chunyu.song@amlogic.com>
 *		        Sam.Wu <yihui.wu@amlogic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#include "../v2_sdc_burn/optimus_sdc_burn_i.h"

typedef int __hFileHdl;

#define BURN_DBG 0
#if BURN_DBG
#define SDC_DBG(fmt...) printf(fmt)
#else
#define SDC_DBG(fmt...)
#endif//if BURN_DBG

#define SDC_MSG         DWN_MSG
#define SDC_ERR         DWN_ERR

//static char _errInfo[512] = "";
// count usb start,to reduce the time-consuming of excuting usb start
int usb_start_count = 0;

//step 1: get script file size, and get script file contents
//step 2: read image file
//"Usage: usb_update partiton image_file_path [imgFmt, verifyFile]\n"   //usage
int do_usb_update(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int rcode = 0;

    const char* partName    = argv[1];
    const char* imgItemPath = argv[2];
    const char* fileFmt     = argc > 3 ? argv[3] : NULL;
    const char* verifyFile  = argc > 4 ? argv[4] : NULL;

	setenv("usb_update", "1");
	printf("usb_start_count %d\n", usb_start_count);
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

if (usb_start_count == 0)
{
    //usb start to ensure usb host inserted and inited
    rcode = run_command("usb start", 0);
    usb_start_count++;
    if (rcode) {
        SDC_ERR("Fail in init usb, Does usb host not plugged in?\n");
        return __LINE__;
    }
}

#if 0
    if (!do_fat_get_fileSz(imgItemPath)) {
        SDC_ERR("file (%s) not existed\n", imgItemPath);
        return __LINE__;
    }
#else
    rcode = optimus_device_probe("usb", "0");
/*
	if (rcode) {
        SDC_ERR("Fail to detect device usb 0\n");
        return __LINE__;
    }
    */
#endif//#if 0

    if (!fileFmt)
    {
        rcode = do_fat_get_file_format(imgItemPath, (u8*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR, (8*1024));
        if (rcode < 0) {
            SDC_ERR("Fail when parse file format\n");
            return __LINE__;
        }
        fileFmt = rcode ? "sparse" : "normal";
    }

#if 0
    if (!getenv("disk_initial")) //if disk_initial command not executed for burning
    {
        rcode = optimus_storage_init(0);//can't erase as not full updating
        if (rcode) {
            SDC_ERR("Fail in init storage, rcode %d\n", rcode);
            return rcode;
        }
        setenv("disk_initial", "0");
    }
#endif//#if 0

    rcode = optimus_burn_partition_image(partName, imgItemPath, fileFmt, verifyFile, 0);
    if (rcode) {
        SDC_ERR("Fail to burn partition (%s) with image file (%s) in format (%s)\n", partName, imgItemPath, fileFmt);
    }

    return rcode;
}

U_BOOT_CMD(
   usb_update,      //command name
   5,               //maxargs
   0,               //repeatable
   do_usb_update,   //command function
   "Burning a partition with image file in usb host",           //description
   "    argv: <part_name> <image_file_path> <[,fileFmt]> <[,verify_file]> \n"   //usage
   "    - <fileFmt> parameter is optional, if you know it you can specify it.\n"
   "        for Android, system.img and data.img is \"sparse\" format, other is \"normal\"\n"   //usage
   "    - <verify_file> parameter is optional, if you have it you can specify it.\n"
   "    - e.g. \n"
   "        to burn partition boot with boot.img of usb 0 : \"usb_update boot boot.img\"\n"   //usage
   "        to burn partition system with system.img of usb 0 : \"usb_update system system.img\"\n"   //usage
);
