/*
 * \file        sysrecovery.c
 * \brief
 *
 * \version     1.0.0
 * \date        Friday,14/11/21
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2014 Amlogic. All Rights Reserved.
 *
 */
#include "../v2_burning_i.h"
#include "../v2_sdc_burn/optimus_sdc_burn_i.h"
#include "../v2_sdc_burn/optimus_led.h"

#define CONFIG_AML_SYS_RECOVERY_CLEAR_USR_DATA  1

static int optimus_sysrec_check_whole_img_before_burn(const char* partName)
{
        //TODO:
        return 0;
}

#if CONFIG_AML_SYS_RECOVERY_CLEAR_USR_DATA
//clear data parts then the parts will formatted when firtsboot
//As fill half parttition need so much time, I just clear 2M
static int optimus_sysrec_clear_usr_data_parts(void)
{
        const char* const _usrDataParts[] = {"data",};
        const int   dataPartsNum          = sizeof(_usrDataParts)/sizeof(const char*);
        const unsigned    BufSz = 1U<<20;//1MB
        unsigned char*    clearBuf= (unsigned char*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR;
        int partIndex = 0;
        int ret = 0;

        memset(clearBuf, 0xff, BufSz);
        for (partIndex = 0; partIndex < dataPartsNum; ++partIndex)
        {
                u64 partCap = 0;
                unsigned char* thePart = (unsigned char*)_usrDataParts[partIndex];
                int rcode = 0;
                u64 offset = 0;
                u64 ClearSz = 2U<<20;

                DWN_MSG("To clear data part[%s]\n", thePart);
                rcode = store_get_partititon_size(thePart, &partCap);
                if (rcode) {
                        DWN_ERR("Fail to get partSz for part[%s]\n", thePart);
                        return rcode;
                }
                partCap <<= 9;
                //FIXME: If there is fschk before firstboot, the 2MB to destroy the data if not enough
                /*ClearSz = partCap>>1;*/
                DWN_MSG("partCap 0x%llxMB, ClearSz=%llxMb\n", (partCap>>20), (ClearSz>>20));

                for (; offset < ClearSz; offset += BufSz)
                {
                        rcode = store_write_ops(thePart, clearBuf, offset, BufSz);
                        if (rcode) {
                                DWN_ERR("Failed when clear data part[%s], rcode=%d\n", thePart, rcode);
                                ret += rcode;
                        }
                }
        }

        return ret;
}
#endif//#if CONFIG_AML_SYS_RECOVERY_CLEAR_USR_DATA

/*
 *.partName: aml_sysrecovery
 *.needVerify: 1 then verify partitions that contain verify file; 0 then not to verify for faster burning
 */
static int optimus_sysrec_burn_package_from_partition(const char* partName, const unsigned needVerifyWhileBurn,
                const unsigned verifyPackageBeforeBurn)
{
        extern ConfigPara_t g_sdcBurnPara ;
        ConfigPara_t* pSdcCfgPara = &g_sdcBurnPara;
        __hdle hUiProgress = NULL;
        HIMAGE hImg = NULL;
        int ret = 0;

        ret = optimus_storage_init(0);//Init all partitions for burning

        if (verifyPackageBeforeBurn)
        {
                ret = optimus_sysrec_check_whole_img_before_burn(partName);
                if (ret) {
                        DWN_ERR("Failed in crc check the burning package.\n");
                        return __LINE__;
                }
        }

        hImg = image_open("store", "0", AML_SYS_RECOVERY_PART, "");
        if (!hImg) {
                DWN_ERR("Fail to open image in part %s\n", AML_SYS_RECOVERY_PART);
                ret = __LINE__; goto _finish;
        }

        if (video_res_prepare_for_upgrade(hImg)) {
                DWN_ERR("Fail when prepare bm res or init video for upgrade\n");
                ret = __LINE__; goto _finish;
        }
        show_logo_to_report_burning();

        hUiProgress = optimus_progress_ui_request_for_sdc_burn();
        if (!hUiProgress) {
                DWN_ERR("request progress handle failed!\n");
                ret = __LINE__; goto _finish;
        }
        optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STEPS_AFTER_DISK_INIT_OK);

        int hasBootloader = 0;
        u64 datapartsSz = optimus_img_decoder_get_data_parts_size(hImg, &hasBootloader);
        DWN_MSG("datapartsSz=[%8u]MB\n", (unsigned)(datapartsSz >> 20));
        ret = optimus_progress_ui_set_smart_mode(hUiProgress, datapartsSz,
                        UPGRADE_STEPS_FOR_BURN_DATA_PARTS_IN_PKG(!pSdcCfgPara->burnEx.bitsMap.mediaPath));
        if (ret) {
                DWN_ERR("Fail to set smart mode\n");
                ret = __LINE__; goto _finish;
        }

        pSdcCfgPara->burnParts.burn_num = 0;
        ret = optimus_sdc_burn_partitions(pSdcCfgPara, hImg, hUiProgress, needVerifyWhileBurn);
        if (ret) {
                DWN_ERR("Fail when burn partitions\n");
                ret = __LINE__; goto _finish;
        }

#if 0
        ret = optimus_sdc_burn_dtb_load(hImg);
        if (ITEM_NOT_EXIST != ret && ret) {
                DWN_ERR("Fail in load dtb for sdc_burn\n");
                ret = __LINE__; goto _finish;
        }
        ret = optimus_save_loaded_dtb_to_flash();
        if (ret) {
                DWN_ERR("FAiled in dtb wr\n");
                return __LINE__;
        }
#endif

        optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STPES_AFTER_BURN_DATA_PARTS_OK);

#if CONFIG_AML_SYS_RECOVERY_CLEAR_USR_DATA
        optimus_sysrec_clear_usr_data_parts();
#endif// #if CONFIG_AML_SYS_RECOVERY_CLEAR_USR_DATA
#if 1
        if (hasBootloader)
        {//burn bootloader
                ret = optimus_burn_bootlader(hImg);
                if (ret) {
                        DWN_ERR("Fail in burn bootloader\n");
                        goto _finish;
                }
                ret = optimus_set_burn_complete_flag();
                if (ret) {
                        DWN_ERR("Fail in set_burn_complete_flag\n");
                        ret = __LINE__; goto _finish;
                }
        }
#endif
        optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STEPS_AFTER_BURN_BOOTLOADER_OK);

_finish:
        image_close(hImg);
        optimus_progress_ui_report_upgrade_stat(hUiProgress, !ret);
        optimus_report_burn_complete_sta(ret, 1/*pSdcCfgPara->custom.rebootAfterBurn*/);
        optimus_progress_ui_release(hUiProgress);
        //optimus_storage_exit();//temporary not exit storage driver when failed as may continue burning after burn
        return ret;
}

static int do_aml_sysrecovery(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int rcode = 0;
    unsigned needVerify         = (1 < argc) ? simple_strtoul(argv[1], NULL, 0) : 0;
    unsigned verifyPackageBeforeBurn = (2 < argc) ? simple_strtoul(argv[2], NULL, 0) : 0;

    if (argc < 2 ) {
        cmd_usage(cmdtp);
        return __LINE__;
    }

    show_logo_to_report_burning();//indicate enter flow of burning! when 'run update'
    if (optimus_led_open(LED_TYPE_PWM)) {
        DWN_ERR("Fail to open led for burn\n");
        return __LINE__;
    }
    optimus_led_show_in_process_of_burning();

    optimus_work_mode_set(OPTIMUS_WORK_MODE_SYS_RECOVERY);
    rcode = optimus_sysrec_burn_package_from_partition(AML_SYS_RECOVERY_PART, needVerify, verifyPackageBeforeBurn);

    return rcode;
}

U_BOOT_CMD(
   aml_sysrecovery,     //command name
   3,                   //maxargs
   0,                   //repeatable
   do_aml_sysrecovery,         //command function
   "Burning with amlogic format package from partition sysrecovery",           //description
   "argv: needVerify [,checkWholeImgBeforeBurn]\n"//usage
   "    --@needVerify: 0 then skip to verify the partition even have verify file."
   "    --@checkWholeImgBeforeBurn: 1 then crc32 check the burn package in partition sysrecovery before actual burn"
   "   eg:'aml_sysrecovery 0': burn from partition aml_sysrecovery without verify"
);

