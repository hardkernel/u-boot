/*
 * \file        usb_bl2_cmd.c
 * \brief
 *
 * \version     1.0.0
 * \date        15/08/21
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#include <arch.h>
#include <arch_helpers.h>
#include <assert.h>
#include <bl_common.h>
#include <fip.h>
#include <debug.h>
#include <platform.h>
#include <platform_def.h>
#include <stdio.h>
#include "bl2_private.h"
#include <serial.h>
#include <plat_init.h>
#include <common.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/cpu_config.h>
#include <string.h>

extern unsigned int ddr_init(void);

static unsigned _fipDownloadedAddr = FM_USB_MODE_LOAD_ADDR;//default loadded addr

uint64_t usb_boot(uint64_t src, uint64_t des, uint64_t size)
{
        src += _fipDownloadedAddr - BL2_SIZE;//storage_load in bl2_main using offset in u-boot.bin

	/* data is ready in ddr, just need memcpy */
	memcpy((void *)des, (void *)(src), size);
	return 0;
}


#if 1//usb bl2 para start
//As sram area will not cleared before poweroff, the result maigc must not be equal to para magic and clear before run
#define USB_BL2_RUN_CMD_RESULT_MAGIC                    (0X7856EFABU)//after run
#define USB_BL2_RUN_CMD_INFO_MAGIC                      (0X3412CDABU)//before run
#define USB_BL2_RUN_CMD_INFO_VERSION                    (0x0200)
enum USB_BL2_RUN_CMD_RESULT_ERR_TYPE {
        USB_BL2_RUN_CMD_RESULT_ERR_PARA                 = 0xe2          ,//magic or version error
        USB_BL2_RUN_CMD_RESULT_ERR_RUNTYPE_UNDEFINED                    ,//runtype not defined
        USB_BL2_RUN_CMD_RESULT_ERR_NOT_IMPLEMENTED                      ,//run cmd handle not implemented

        USB_BL2_RUN_CMD_RESULT_ERR_DDR_INIT                             ,//fail in DDR init

        USB_BL2_RUN_CMD_RESULT_ERR_DATACHECK_GENCRC                     ,//fail in data check, generated crc != crc from pc
        USB_BL2_RUN_CMD_RESULT_ERR_DATACHECK_NOT_IMPLEMENTED            ,//not implemented data check type
        USB_BL2_RUN_CMD_RESULT_ERR_DATACHECK_UNDEFINED                  ,//data check type not defined


        USB_BL2_RUN_CMD_RESULT_ERR_RUN_IMAGE_TYPE_NOT_IMPLEMENTED      ,//image type not implemented
};


enum USB_BL2_RUN_CMD_TYPE_enum{
        USB_BL2_RUN_CMD_TYPE_DECOMPRESS             = 0X0000C0DE  , //ucl decompress
        USB_BL2_RUN_CMD_TYPE_DDR_INIT                             , //init ddr
        USB_BL2_RUN_CMD_TYPE_DATA_CHECK                           , //crc32 check, or simple addsum check
        USB_BL2_RUN_CMD_TYPE_RUN_IMG                              , //run fip image
};

#pragma pack(push, 4)
//UsbBl2RunCmdPara_t: common para header for u-boot.bin.usb.bl2 when usb mode
typedef struct _usbbl2_run_cmd_para_s{
        unsigned int                    paraMagic;//USB_BL2_RUN_CMD_INFO_MAGIC, USB_BL2_RUN_CMD_RESULT_MAGIC
        unsigned int                    paraVersion;
        unsigned int                    runType;//USB_BL2_RUN_CMD_RUN_IN_ADDR,USB_BL2_RUN_CMD_DDR_INSPECT
        unsigned int                    runResult;//running result, 0 is no err, others error

        unsigned int                    errInfoAddr;//sram addr for save error messages
        unsigned int                    errInfoSz;  //error messages length

}UsbBl2RunCmdPara_t;

//parameters for ddr init
typedef struct _usbbl2_run_cmd_DDR_INIT{
        UsbBl2RunCmdPara_t      runParaHeader;
        unsigned int            ddrCapacity;//after run, saved the ddr capacity in MB

}UsbBl2RunCmdPara_DdrInit;

//parameters for ucl decompress
typedef struct  _usbbl2_run_cmd_DECOMPRESS{
        UsbBl2RunCmdPara_t      runParaHeader;
        unsigned int            decompressType;//ucl decompress, others ...
        unsigned int            srcDataAddr;   //data for decompress
        unsigned int            srcDataLen;
        unsigned int            decompressedAddr;//data addr after ucl decompress
        unsigned int            decompressedLen; //data size after ucl decompress
}UsbBl2RunCmdPara_Decompress;

//parameters for running a image, support normal/fip fomrat/and etc..
typedef struct _usbbl2_run_cmd_RunImage{
        UsbBl2RunCmdPara_t      runParaHeader;
        unsigned int            runImageType;//2 normal bin, 1 fip image, others reserved
        unsigned int            imageDataAddr;//
        unsigned int            imageDataLen;

}UsbBl2RunCmdPara_RunImage;

#if 1//for data check
struct _UsbBl2DataCheck_sha1sum{//check data using sha1sum algorithm
        unsigned char           srcDataCheckValue[20];//for crc and addsum, only 4 bytes used
        unsigned char           generatedCheckValue[20];
};
struct _UsbBl2DataCheck_sha256sum{//check data using sha256sum algorithm
        unsigned char           srcDataCheckValue[32];//for crc and addsum, only 4 bytes used
        unsigned char           generatedCheckValue[32];
};
struct _UsbBl2DataCheck_sha2sum{//check data using sha2 algorithm
        unsigned char           srcDataCheckValue[32];//for crc and addsum, only 4 bytes used
        unsigned char           generatedCheckValue[32];
};
struct _UsbBl2DataCheck_addsum{//check data using simple addsum algorithm
        unsigned int            srcAddSum;
        unsigned int            generatedAddSum;
};
struct _UsbBl2DataCheck_crc32{//check data using crc32 algorithm
        unsigned int            srcAddSum;
        unsigned int            generatedAddSum;
};

//parameters for ddr init
typedef struct _usbbl2_run_cmd_DataCheck{
        UsbBl2RunCmdPara_t      runParaHeader;
        unsigned int            dataCheckAlgorithm;//check algorithm, 1 is addsum, 2 is sha2, 3 is crc32, and other
        unsigned int            srcDataAddr;       //data addr for check
        unsigned int            srcDataLen;        //data length for check

        union {
                struct _UsbBl2DataCheck_addsum          addsum;
                struct _UsbBl2DataCheck_crc32           crc32;
                struct _UsbBl2DataCheck_sha256sum       sha256sum;
                struct _UsbBl2DataCheck_sha2sum         sha2sum;
                struct _UsbBl2DataCheck_sha1sum         sha1sum;
        }dataCheckVal;

}UsbBl2RunCmdPara_DataCheck;

#endif//#if 1//for data check

#pragma pack(pop) // #pragma pack(push, 4)

#define DATA_CHECK_TYPE_ADDSUM                          1
#define DATA_CHECK_TYPE_CRC32                           2
#define DATA_CHECK_TYPE_SHA1                            3
#define DATA_CHECK_TYPE_SHA2                            4
#define DATA_CHECK_TYPE_SHA256                          5

#define RUN_IMAGE_TYPE_FIP                              1
#define RUN_IMAGE_TYPE_RAW                              2

#endif//#if 1 usb bl2 para

// simple add sum data check
static unsigned int usb_add_sum(const unsigned int *data, int size)
{
	unsigned int cksum		= 0;
	unsigned int wordLen 	        = size>>2;
	unsigned int rest 		= size & 3;

	while (wordLen--)
	{
		cksum += *data++;
	}

	if (rest == 1)
	{
		cksum += (*data) & 0xff;
	}
	else if(rest == 2)
	{
		cksum += (*data) & 0xffff;
	}
	else if(rest == 3)
	{
		cksum += (*data) & 0xffffff;
	}

	return cksum;
}
// end
//
static int usb_bl2_cmd_run_image(UsbBl2RunCmdPara_RunImage* pRunImgPara)
{
        const int imageType                     = pRunImgPara->runImageType;
        const unsigned srcDataAddr              = pRunImgPara->imageDataAddr;
        int runResult                           = 0;

        switch (imageType)
        {
                case RUN_IMAGE_TYPE_FIP:
                {
                        _fipDownloadedAddr = srcDataAddr;//update fip image loaded addr

                        /* Perform platform setup in BL1 */
                        bl2_platform_setup();

                        /* Load images */
                        bl2_load_image();
                }
                break;

                case RUN_IMAGE_TYPE_RAW://raw image bin
                {
                        typedef int (*pfunc_t)(void) ;
                        pfunc_t entry = (pfunc_t)(unsigned long)srcDataAddr;
                        entry();
                }
                break;

                default:
                        runResult = USB_BL2_RUN_CMD_RESULT_ERR_RUN_IMAGE_TYPE_NOT_IMPLEMENTED;
                        break;
        }

        return runResult;
}

static int usb_bl2_cmd_run_datacheck(UsbBl2RunCmdPara_DataCheck* pDataCheckPara)
{
        int runResult = 0;
        switch (pDataCheckPara->dataCheckAlgorithm)
        {
                case DATA_CHECK_TYPE_ADDSUM://addsum
                        {
                                const unsigned originAddsum = pDataCheckPara->dataCheckVal.addsum.srcAddSum;
                                const unsigned* srcData   = (const unsigned*)(unsigned long)pDataCheckPara->srcDataAddr;
                                const unsigned srcDataLen = pDataCheckPara->srcDataLen;
                                unsigned generatedAddSum  = 0;

                                generatedAddSum = usb_add_sum(srcData, srcDataLen);
                                pDataCheckPara->dataCheckVal.addsum.generatedAddSum = generatedAddSum;
                                if (generatedAddSum != originAddsum) runResult = USB_BL2_RUN_CMD_RESULT_ERR_DATACHECK_GENCRC;
                        }
                        break;
                case DATA_CHECK_TYPE_CRC32://crc32
                case DATA_CHECK_TYPE_SHA1://sha1
                case DATA_CHECK_TYPE_SHA2://sha2
                case DATA_CHECK_TYPE_SHA256://sha256
                        runResult = USB_BL2_RUN_CMD_RESULT_ERR_DATACHECK_NOT_IMPLEMENTED;
                default:
                        runResult = USB_BL2_RUN_CMD_RESULT_ERR_DATACHECK_UNDEFINED;
                        break;
        }

        return runResult;
}

//usb burning tool must compatibe for old/new code,
//new code not need to support old usb burning tool
static int usb_bl2_run_cmd(void* usbBl2Para)
{
        UsbBl2RunCmdPara_t* pBl2RunPara = (UsbBl2RunCmdPara_t*)usbBl2Para;
        const unsigned int paraMagic    = pBl2RunPara->paraMagic;
        const unsigned int paraVersion  = pBl2RunPara->paraVersion;
        const unsigned int runType      = pBl2RunPara->runType;
        int   runResult                 = 0;//no error

        pBl2RunPara->paraMagic = USB_BL2_RUN_CMD_RESULT_MAGIC;
        if (paraMagic != USB_BL2_RUN_CMD_INFO_MAGIC || paraVersion != USB_BL2_RUN_CMD_INFO_VERSION) {
                pBl2RunPara->runResult = USB_BL2_RUN_CMD_RESULT_ERR_PARA;
                return __LINE__;
        }

        switch (runType)
        {
                case USB_BL2_RUN_CMD_TYPE_DDR_INIT:
                        {
                                UsbBl2RunCmdPara_DdrInit* pRunDdrPara = (UsbBl2RunCmdPara_DdrInit*)pBl2RunPara;
                                ddr_init();
                                pRunDdrPara->ddrCapacity = (unsigned)get_ddr_size();
                                runResult   = pRunDdrPara->ddrCapacity ? 0: USB_BL2_RUN_CMD_RESULT_ERR_DDR_INIT;
                        }
                        break;

                case USB_BL2_RUN_CMD_TYPE_RUN_IMG:
                        {
                                /*
                                 *unsigned int* skipBootReg = (unsigned int*)SEC_AO_RTI_STATUS_REG3;
                                 *const unsigned skipBootRegVal =  readl(skipBootReg);
                                 *writel(skipBootRegVal & ( ~( 0XFU << 12 )) , skipBootReg );//clear skip boot flag
                                 */
                                writel((readl(SEC_AO_SEC_GP_CFG7) | (1U<<31)), SEC_AO_SEC_GP_CFG7);

                                UsbBl2RunCmdPara_RunImage* pRunImgPara  = (UsbBl2RunCmdPara_RunImage*)pBl2RunPara;
                                runResult = usb_bl2_cmd_run_image(pRunImgPara);
                        }
                        break;

                case USB_BL2_RUN_CMD_TYPE_DATA_CHECK:
                        {
                                UsbBl2RunCmdPara_DataCheck* pDataCheckPara = (UsbBl2RunCmdPara_DataCheck*)pBl2RunPara;
                                runResult = usb_bl2_cmd_run_datacheck(pDataCheckPara);
                        }
                        break;

                case USB_BL2_RUN_CMD_TYPE_DECOMPRESS:
                        runResult = USB_BL2_RUN_CMD_RESULT_ERR_NOT_IMPLEMENTED;
                        break;
                default:
                        runResult = USB_BL2_RUN_CMD_RESULT_ERR_RUNTYPE_UNDEFINED;
                        break;

        }

        pBl2RunPara->runResult = runResult;
        return runResult;
}

int bl2_usb_handler(void)
{
        unsigned int* skipBootReg       = (unsigned int*)SEC_AO_RTI_STATUS_REG3;
        unsigned skipBootRegVal         =  readl(skipBootReg);
        const unsigned usbBootFlag      = ( skipBootRegVal>>12 ) & 0xF;

        /* process usb burning case */
        if (BOOT_DEVICE_USB == get_boot_device() || 2 == usbBootFlag )
        {
                serial_puts("BL2 USB \n");
                usb_bl2_run_cmd(USB_BL2_RUN_CMD_PARA_ADDR);
                bl2_to_romcode(USB_BL2_RETURN_ROM_ADDR);
        }
        else if( 1 == usbBootFlag )
        {
                serial_puts("Skip usb!\n");
                skipBootRegVal &= ~(0XFU<<12);
                writel(skipBootRegVal | ( 2<<12 ), skipBootReg);
                bl2_to_romcode(BL2_RETURN_ROM_USB_ADDR);
        }

        return 0;
}


