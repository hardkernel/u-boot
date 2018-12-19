/*
 * \file        optimus_sdc_burn.c
 * \brief       burning itself from Pheripheral tf/sdmmc card
 *
 * \version     1.0.0
 * \date        2013-7-11
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#include "optimus_sdc_burn_i.h"
#include "optimus_led.h"
#include <asm/arch/secure_apb.h>
#include <asm/io.h>

#include <amlogic/aml_efuse.h>

static int is_bootloader_old(void)
{
    int sdc_boot = is_tpl_loaded_from_ext_sdmmc();

    return !sdc_boot;
}

int get_burn_parts_from_img(HIMAGE hImg, ConfigPara_t* pcfgPara)
{
    BurnParts_t* pburnPartsCfg = &pcfgPara->burnParts;
    int i = 0;
    int ret = 0;
    int burnNum = 0;
    const int totalItemNum = get_total_itemnr(hImg);

    for (i = 0; i < totalItemNum; i++)
    {
        const char* main_type = NULL;
        const char* sub_type  = NULL;

        ret = get_item_name(hImg, i, &main_type, &sub_type);
        if (ret) {
            DWN_ERR("Exception:fail to get item name!\n");
            return __LINE__;
        }

        if (!strcmp("PARTITION", main_type))
        {
            char* partName = pburnPartsCfg->burnParts[burnNum];

            if (!strcmp("bootloader", sub_type)) continue;
            if (!strcmp(AML_SYS_RECOVERY_PART, sub_type))
            {
                    if (OPTIMUS_WORK_MODE_SYS_RECOVERY == optimus_work_mode_get()) continue;
            }

            strcpy(partName, sub_type);
            pburnPartsCfg->bitsMap4BurnParts |= 1U<<burnNum;
            burnNum += 1;
        }
    }

    if (burnNum)
    {
        pburnPartsCfg->burn_num = burnNum;

        ret = check_cfg_burn_parts(pcfgPara);
        if (ret) {
            DWN_ERR("Fail in check burn parts\n");
            return __LINE__;
        }
        print_burn_parts_para(pburnPartsCfg);
    }

    return OPT_DOWN_OK;
}

int optimus_verify_partition(const char* partName, HIMAGE hImg, char* _errInfo)
{
#define MaxSz (64 - 7) //verify file to at most 64B to corresponding to USB burn, strlen("verify ") == 7

    char* argv[4];
    int ret = 0;
    HIMAGEITEM hImgItem = NULL;
    int imgItemSz = 0;
    char CmdVerify[MaxSz + 7] = {0};

    hImgItem = image_item_open(hImg, "VERIFY", partName);
    if (!hImgItem) {
        DWN_ERR("Fail to open verify file for part (%s)\n", partName);
        return ITEM_NOT_EXIST;
    }

    imgItemSz = (int)image_item_get_size(hImgItem);
    if (imgItemSz > MaxSz || !imgItemSz) {
        DWN_ERR("verify file size %d for part %s invalid, max is %d\n", imgItemSz, partName, MaxSz);
        ret = __LINE__; goto _finish;
    }
    DWN_DBG("item sz %u\n", imgItemSz);

    ret = image_item_read(hImg, hImgItem, CmdVerify, imgItemSz);
    if (ret) {
        DWN_ERR("Fail to read verify item for part %s\n", partName);
        goto _finish;
    }
    CmdVerify[imgItemSz] = 0;
    DWN_DBG("verify[%s]\n", CmdVerify);

    argv[0] = "verify";
    ret = cli_simple_parse_line(CmdVerify, argv + 1);
    if (ret != 2) {
        DWN_ERR("verify cmd argc must be 2, but %d\n", ret);
        return __LINE__;
    }

    ret = optimus_media_download_verify(3, argv, _errInfo);
    if (ret) {
        DWN_ERR("Fail when verify\n");
        return __LINE__;
    }

_finish:
    image_item_close(hImgItem);
    return ret;
}

//.NeedVerify: Try to get verify file if .NeedVerify == 1
static int optimus_burn_one_partition(const char* partName, HIMAGE hImg, __hdle hUiProgress, int NeedVerify)
{
    int rcode = 0;
    s64 imgItemSz       = 0;
    s64 leftItemSz      = 0;
    u32 thisReadLen     = 0;
    __hdle hImgItem     = NULL;
    char* downTransBuf  = NULL;//get buffer from optimus_buffer_manager
    const unsigned ItemReadBufSz = OPTIMUS_DOWNLOAD_SLOT_SZ;//read this size from image item each time
    unsigned sequenceNo = 0;
    const char* fileFmt = NULL;
    /*static */char _errInfo[512];
    unsigned itemSizeNotAligned = 0;
    unsigned itemSizePreload = 0;

    printf("\n");
    DWN_MSG("=====>To burn part [%s]\n", partName);
    optimus_progress_ui_printf("Burning part[%s]\n", partName);
    hImgItem = image_item_open(hImg, "PARTITION", partName);
    if (!hImgItem) {
        DWN_ERR("Fail to open item for part (%s)\n", partName);
        return __LINE__;
    }

    imgItemSz = leftItemSz = image_item_get_size(hImgItem);
    if (!imgItemSz) {
        DWN_ERR("image size is 0 , image of part (%s) not exist ?\n", partName);
        return __LINE__;
    }

    fileFmt = (IMAGE_ITEM_TYPE_SPARSE == image_item_get_type(hImgItem)) ? "sparse" : "normal";

    itemSizeNotAligned = image_item_get_first_cluster_size(hImg, hImgItem);
    //need let 'leftItemSz > 0' to trigger optimus_buf_manager_report_transfer_complete
    if ( itemSizeNotAligned >= imgItemSz ) itemSizePreload = 0;
    else itemSizePreload = itemSizeNotAligned;
    leftItemSz        -= itemSizePreload;
    rcode = sdc_burn_buf_manager_init(partName, imgItemSz, fileFmt, itemSizePreload);
    if (rcode) {
        DWN_ERR("fail in sdc_burn_buf_manager_init, rcode %d\n", rcode);
        return __LINE__;
    }

    //for each loop:
    //1, get buffer from buffer_manager,
    //2, read item data to buffer,
    //3, report data ready to buffer_manager
    for (; leftItemSz > 0; leftItemSz -= thisReadLen, sequenceNo++)
    {
        thisReadLen = leftItemSz > ItemReadBufSz ? ItemReadBufSz: (u32)leftItemSz;

        rcode = optimus_buf_manager_get_buf_for_bulk_transfer(&downTransBuf, thisReadLen, sequenceNo, _errInfo);
        if (rcode) {
            DWN_ERR("fail in get buf, msg[%s]\n", _errInfo);
            goto _finish;
        }

		//If the item head is not alinged to FAT cluster, Read it firstly to speed up mmc read
        if (itemSizeNotAligned && !sequenceNo)
        {
            if ( itemSizeNotAligned >= imgItemSz ) {
                itemSizePreload = imgItemSz;
                if ( imgItemSz != thisReadLen ) {
                    DWN_ERR("itemSizeNotAligned 0x%x >= imgItemSz 0x%llx, but thisReadLen 0x%x\n",
                            itemSizeNotAligned, imgItemSz, thisReadLen);
                    rcode = __LINE__; goto _finish;
                }
            }
            DWN_MSG("itemSizeNotAligned 0x%x, itemSizePreload 0x%x\n", itemSizeNotAligned, itemSizePreload);
            rcode = image_item_read(hImg, hImgItem, downTransBuf - itemSizePreload, itemSizePreload);
            if (rcode) {
                DWN_ERR("fail in read data from item,rcode %d, len 0x%x, sequenceNo %d\n", rcode, itemSizePreload, sequenceNo);
                goto _finish;
            }
        }

        if ( itemSizePreload != imgItemSz )
        {
            rcode = image_item_read(hImg, hImgItem, downTransBuf, thisReadLen);
            if (rcode) {
                DWN_ERR("fail in read data from item,rcode %d\n", rcode);
                goto _finish;
            }
        } else {
            memmove(downTransBuf, downTransBuf - itemSizePreload, itemSizePreload);
        }
        rcode = optimus_buf_manager_report_transfer_complete(thisReadLen, _errInfo);
        if (rcode) {
            DWN_ERR("fail in report data ready, rcode %d\n", rcode);
            goto _finish;
        }
        if (hUiProgress)optimus_progress_ui_update_by_bytes(hUiProgress, thisReadLen) ;
    }

    DWN_DBG("BURN part %s %s!\n", partName, leftItemSz ? "FAILED" : "SUCCESS");

_finish:
    image_item_close(hImgItem);

    if (rcode) {
        DWN_ERR("Fail to burn part(%s) with in format (%s) before verify\n", partName, fileFmt);
        optimus_progress_ui_printf("Failed at burn part[%s] befor VERIFY\n", partName);
        return rcode;
    }

#if 1
    if (!NeedVerify) {
            return rcode;
    }
    rcode = optimus_verify_partition(partName, hImg, _errInfo);
    if (ITEM_NOT_EXIST == rcode)
    {
        printf("WRN:part(%s) NOT verified\n", partName);
        return 0;
    }
    if (rcode) {
        printf("Fail in verify part(%s)\n", partName);
        optimus_progress_ui_printf("Failed at VERIFY part[%s]\n", partName);
        return __LINE__;
    }
#endif//#fi 0

    return rcode;
}

int optimus_sdc_burn_partitions(ConfigPara_t* pCfgPara, HIMAGE hImg, __hdle hUiProgress, int NeedVerify)
{
    BurnParts_t* cfgParts = &pCfgPara->burnParts;
    int burnNum       = cfgParts->burn_num;
    int i = 0;
    int rcode = 0;

    //update burn_parts para if burnNum is 0, i.e, not configured
    if (!burnNum)
    {
        rcode = get_burn_parts_from_img(hImg, pCfgPara);
        if (rcode) {
            DWN_ERR("Fail to get burn parts from image\n");
            return __LINE__;
        }
        burnNum = cfgParts->burn_num;
        DWN_DBG("Data part num %d\n", burnNum);
    }
    if (!burnNum) {
        DWN_ERR("Data part num is 0!!\n");
        return __LINE__;
    }

    for (i = 0; i < burnNum; i++)
    {
        const char* partName = cfgParts->burnParts[i];

        rcode = optimus_burn_one_partition(partName, hImg, hUiProgress, NeedVerify);
        if (rcode) {
            DWN_ERR("Fail in burn part %s\n", partName);
            return __LINE__;
        }
    }

    return rcode;
}

//not need to verify as not config ??
int optimus_sdc_burn_media_partition(const char* mediaImgPath, const char* verifyFile)
{
    //TODO:change configure to 'partName = image' and work it using cmd 'sdc_update'
    return optimus_burn_partition_image("media", mediaImgPath, "normal", verifyFile, 0);
}

int optimus_burn_bootlader(HIMAGE hImg)
{
    int rcode = 0;
    int NeedVerify = 1;

    rcode = optimus_burn_one_partition("bootloader", hImg, NULL, NeedVerify);
    if (rcode) {
        DWN_ERR("Fail when burn bootloader\n");
        return __LINE__;
    }

    return rcode;
}

//flag, 0 is burn completed, else burn failed
int optimus_report_burn_complete_sta(int isFailed, int rebootAfterBurn)
{
    if (isFailed)
    {
        DWN_MSG("=====Burn Failed!!!!!\n");
        DWN_MSG("PLS long-press power key to shut down\n");
        optimus_led_show_burning_failure();
        while (1) {
            /*if(ctrlc())run_command("reset", 0);*/
        }

        return __LINE__;
    }

    DWN_MSG("======sdc burn SUCCESS.\n");
    optimus_led_show_burning_success();
    optimus_burn_complete(rebootAfterBurn ? rebootAfterBurn : OPTIMUS_BURN_COMPLETE__POWEROFF_AFTER_POWERKEY);//set complete flag and poweroff if burn successful
    return 0;
}

int optimus_sdc_burn_dtb_load(HIMAGE hImg)
{
    s64 itemSz = 0;
    HIMAGEITEM hImgItem = NULL;
    int rc = 0;
    const char* partName = "dtb";
    u64 partBaseOffset = OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR;
    unsigned char* dtbTransferBuf     = (unsigned char*)partBaseOffset;

    //meson1.dtb but not meson.dtb for m8 compatible
    if (IS_FEAT_BOOT_VERIFY()) {
        DWN_MSG("SecureEnabled, use meson1_ENC\n");
        hImgItem = image_item_open(hImg, partName, "meson1_ENC");
    }
    else {
        hImgItem = image_item_open(hImg, partName, "meson1");
    }
    if (!hImgItem) {
        DWN_WRN("Fail to open item [meson1,%s]\n", partName);
        return ITEM_NOT_EXIST;
    }

    itemSz = image_item_get_size(hImgItem);
    if (!itemSz) {
        DWN_ERR("Item size 0\n");
        image_item_close(hImgItem); return __LINE__;
    }

#if 1
    const unsigned itemSzNotAligned = image_item_get_first_cluster_size(hImg, hImgItem);
    if (itemSzNotAligned /*& 0x7*/) {//Not Aligned 8bytes/64bits, mmc dma read will failed
        DWN_MSG("align 4 mmc read...\t");//Assert Make 'DDR' buffer addr align 8
        dtbTransferBuf += image_get_cluster_size(hImg) - itemSzNotAligned;
        partBaseOffset += image_get_cluster_size(hImg) - itemSzNotAligned;
    }
#endif

    rc = image_item_read(hImg, hImgItem, dtbTransferBuf, (unsigned)itemSz);
    if (rc) {
        DWN_ERR("Failed at item read, rc = %d\n", rc);
        image_item_close(hImgItem); return __LINE__;
    }
    image_item_close(hImgItem);

    rc = optimus_parse_img_download_info(partName, itemSz, "normal", "mem", partBaseOffset);
    if (rc) {
        DWN_ERR("Failed in init down info\n"); return __LINE__;
    }

    {
        unsigned wrLen = 0;
        char errInfo[512];

        wrLen = optimus_download_img_data(dtbTransferBuf, (unsigned)itemSz, errInfo);
        rc = (wrLen == itemSz) ? 0 : __LINE__;
    }

    return rc;
}

#if CONFIG_SUPPORT_SDC_KEYBURN
//fetch the keys names which need be burned from item[conf, keys]
static int sdc_burn_get_user_key_names(HIMAGE hImg, const char* **pKeysName, unsigned* keysNum)
{
        int rc = 0;
        HIMAGEITEM hImgItem = NULL;
        unsigned itemSz = 0;
        unsigned char* thisReadBuf     = (unsigned char*)OPTIMUS_SPARSE_IMG_FILL_VAL_BUF;//This buf is not used and not need reuse when burning keys
        const unsigned thisReadBufSz   = (OPTIMUS_SPARSE_IMG_FILL_BUF_SZ >> 1);
        const char* *keysName = (const char**)(thisReadBuf + thisReadBufSz);

        hImgItem = image_item_open(hImg, "conf", "keys");
        if (!hImgItem) {
                DWN_ERR("Fail to open keys.conf\n");
                return ITEM_NOT_EXIST;
        }

        itemSz = (unsigned)image_item_get_size(hImgItem);
        if (!itemSz) {
                DWN_ERR("Item size 0\n");
                image_item_close(hImgItem); return __LINE__;
        }

        const unsigned itemSzNotAligned = image_item_get_first_cluster_size(hImg, hImgItem);
        if (itemSzNotAligned /*& 0x7*/) {//Not Aligned 8bytes/64bits, mmc dma read will failed
            DWN_MSG("align 4 mmc read...\t");//Assert Make 'DDR' buffer addr align 8
            thisReadBuf += image_get_cluster_size(hImg);
            thisReadBuf -= itemSzNotAligned;
        }
        rc = image_item_read(hImg, hImgItem, thisReadBuf, itemSz);
        if (rc) {
                DWN_ERR("Failed at item read, rc = %d\n", rc);
                image_item_close(hImgItem); return __LINE__;
        }
        image_item_close(hImgItem);

        if (itemSz >= thisReadBufSz) {
                DWN_ERR("itemSz(0x%x) of keys.conf too large, > max 0x%x.\n", itemSz, thisReadBufSz);
                return __LINE__;
        }

        rc = _optimus_parse_buf_2_lines((char*)thisReadBuf, itemSz, keysName, keysNum, 16);
        if (rc) {
                DWN_ERR("Fail in parse buf_2_lines\n");
                return __LINE__;
        }

        rc = _optimus_abandon_ini_comment_lines((char**)keysName, *keysNum);

        *pKeysName = keysName;
        return rc;
}

//check key is burned yet --> need  keyOverWrite -->can_write
static int sdc_check_key_need_to_burn(const char* keyName, const int keyOverWrite)
{
        int rc = 0;
        char _cmd[96];

        sprintf(_cmd, "aml_key_burn misc is_burned %s", keyName);
        rc = run_command(_cmd, 0);
        if (rc < 0) {
                DWN_ERR("Fail in check key is_burned\n");
                return -__LINE__;
        }
        DWN_MSG("key[%s] is %s burned\n", keyName, rc ? "NOT" : "DO");
        if (rc) {//not success
                return 1;//need burn as not burned yet.
        }
        if (!keyOverWrite) {
                DWN_MSG("User choose not to overwrite the key\n");
                return 0;
        }

        sprintf(_cmd, "aml_key_burn misc can_write %s", keyName);
        rc = run_command(_cmd, 0);
        if (rc) {
                DWN_ERR("Fail in check key[%s] is_burned\n", keyName);
                return -__LINE__;
        }
        DWN_MSG("key[%s] is %s can_write\n", keyName, rc ? "NOT" : "DO");
        return !rc;
}

//burn the amlogic keys like USB_Burning_Tool
static int sdc_burn_aml_keys(HIMAGE hImg, const int keyOverWrite)
{
        int rc = 0;
        const char* *keysName = NULL;
        unsigned keysNum = 0;
        const char** pCurKeysName = NULL;
        unsigned index = 0;

        rc = run_command("aml_key_burn probe vfat sdc", 0);
        if (rc) {
                DWN_ERR("Fail in probe for aml_key_burn\n");
                return __LINE__;
        }

        {
                unsigned random32 = 0;
                unsigned seed = 0;
                char cmd[96];

                random32 = seed = get_timer(0) + 12345;//FIXME:make it random
                /*random32 = random_u32(seed);*/
                DWN_MSG("random value is 0x%x\n", random32);
                sprintf(cmd, "aml_key_burn init 0x%x", random32);

                rc = run_command(cmd, 0);
                if (rc) {
                        DWN_ERR("Fail in cmd[%s]\n", cmd);
                        return __LINE__;
                }
        }

        rc = sdc_burn_get_user_key_names(hImg, &keysName, &keysNum);
        if (ITEM_NOT_EXIST != rc && rc) {
                DWN_ERR("Fail to parse keys.conf, rc =%d\n", rc);
                return __LINE__;
        }
        DWN_MSG("keys.conf:\n");
        for (index = 0; index < keysNum; ++index)printf("\tkey[%d]\t%s\n", index, keysName[index]) ;

        rc =  optimus_sdc_keysprovider_init();
        if (rc) {
                DWN_ERR("Fail in optimus_sdc_keysprovider_init\n");
                return __LINE__;
        }

        pCurKeysName = keysName;
        for (index = 0; index < keysNum; ++index)
        {
                const char* const keyName = *pCurKeysName++;

                if (!keyName) continue;
                DWN_MSG("\n");
                DWN_MSG("Now to burn key <---- [%s] ----> %d \n", keyName, index);
                rc = sdc_check_key_need_to_burn(keyName, keyOverWrite);
                if (rc < 0) {
                        DWN_ERR("Fail when when check stauts for key(%s)\n", keyName);
                        /*return __LINE__;*/
                }
                if (!rc) continue;//not need to burn this key

                //0, init the key license parser
                const void* pHdle = NULL;
                rc = optimus_sdc_keysprovider_open(keyName, &pHdle);
                if (rc) {
                        DWN_ERR("Fail in init license for key[%s]\n", keyName);
                        return __LINE__;
                }

                //1,using cmd_keysprovider to read a key to memory
                u8* keyValue = (u8*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR;
                unsigned keySz = OPTIMUS_DOWNLOAD_SLOT_SZ;//buffer size
                rc = optimus_sdc_keysprovider_get_keyval(pHdle, keyValue, &keySz);
                if (rc) {
                        DWN_ERR("Fail to get value for key[%s]\n", keyName);
                        return __LINE__;
                }

                //3, burn the key
                rc = optimus_keysburn_onekey(keyName, (u8*)keyValue, keySz);
                if (rc) {
                        DWN_ERR("Fail in burn the key[%s] at addr=%p, sz=%d\n", keyName, keyValue, keySz);
                        return __LINE__;
                }

                //3,report burn result to cmd_keysprovider
                rc = optimus_sdc_keysprovider_update_license(pHdle);
                if (rc) {
                        DWN_ERR("Fail in update license for key[%s]\n", keyName);
                        return __LINE__;
                }
        }

        rc = optimus_sdc_keysprovider_exit();
        if (rc) {
                DWN_ERR("Fail in optimus_sdc_keysprovider_exit\n");
                return __LINE__;
        }

        rc = run_command("aml_key_burn uninit", 0);
        if (rc) {
                DWN_ERR("Fail in uninit for aml_key_burn\n");
                return __LINE__;
        }

        return 0;
}
#else
#define sdc_burn_aml_keys(fmt...)     0
#endif// #if CONFIG_SUPPORT_SDC_KEYBURN

int optimus_burn_with_cfg_file(const char* cfgFile)
{
    extern ConfigPara_t g_sdcBurnPara ;

    int ret = 0;
    HIMAGE hImg = NULL;
    ConfigPara_t* pSdcCfgPara = &g_sdcBurnPara;
    const char* pkgPath = pSdcCfgPara->burnEx.pkgPath;
    __hdle hUiProgress = NULL;

    ret = parse_ini_cfg_file(cfgFile);
    if (ret) {
        DWN_ERR("Fail to parse file %s\n", cfgFile);
        ret = __LINE__; goto _finish;
    }

    if (pSdcCfgPara->custom.eraseBootloader && strcmp("1", getenv("usb_update")))
    {
        if (is_bootloader_old())
        {
            DWN_MSG("To erase OLD bootloader !\n");
            ret = optimus_erase_bootloader("sdc");
            if (ret) {
                DWN_ERR("Fail to erase bootloader\n");
                ret = __LINE__; goto _finish;
            }

#if defined(CONFIG_VIDEO_AMLLCD)
            //axp to low power off LCD, no-charging
            DWN_MSG("To close LCD\n");
            ret = run_command("video dev disable", 0);
            if (ret) {
                printf("Fail to close back light\n");
                /*return __LINE__;*/
            }
#endif// #if defined(CONFIG_VIDEO_AMLLCD)

            DWN_MSG("Reset to load NEW uboot from ext-mmc!\n");
            optimus_reset(OPTIMUS_BURN_COMPLETE__REBOOT_SDC_BURN);
            return __LINE__;//should never reach here!!
        }
    }

    if (OPTIMUS_WORK_MODE_SDC_PRODUCE == optimus_work_mode_get()) //led not depend on image res, can init early
    {
        if (optimus_led_open(LED_TYPE_PWM)) {
            DWN_ERR("Fail to open led for sdc_produce\n");
            return __LINE__;
        }
        optimus_led_show_in_process_of_burning();
    }

    hImg = image_open("mmc", "0", "1", pkgPath);
    if (!hImg) {
        DWN_ERR("Fail to open image %s\n", pkgPath);
        ret = __LINE__; goto _finish;
    }

    //update dtb for burning drivers
    ret = optimus_sdc_burn_dtb_load(hImg);
    if (ITEM_NOT_EXIST != ret && ret) {
        DWN_ERR("Fail in load dtb for sdc_burn\n");
        ret = __LINE__; goto _finish;
    }

    if (video_res_prepare_for_upgrade(hImg)) {
        DWN_ERR("Fail when prepare bm res or init video for upgrade\n");
        image_close(hImg);
        return __LINE__;
    }
    show_logo_to_report_burning();

    hUiProgress = optimus_progress_ui_request_for_sdc_burn();
    if (!hUiProgress) {
        DWN_ERR("request progress handle failed!\n");
        ret = __LINE__; goto _finish;
    }
    optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STEPS_AFTER_IMAGE_OPEN_OK);

    int hasBootloader = 0;
    u64 datapartsSz = optimus_img_decoder_get_data_parts_size(hImg, &hasBootloader);

    int eraseFlag = pSdcCfgPara->custom.eraseFlash;
    if (!datapartsSz) {
            eraseFlag = 0;
            DWN_MSG("Disable erase as data parts size is 0\n");
    }
    ret = optimus_storage_init(eraseFlag);
    if (ret) {
        DWN_ERR("Fail to init stoarge for sdc burn\n");
        return __LINE__;
    }

    optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STEPS_AFTER_DISK_INIT_OK);

    if (datapartsSz)
    {
            ret = optimus_progress_ui_set_smart_mode(hUiProgress, datapartsSz,
                            UPGRADE_STEPS_FOR_BURN_DATA_PARTS_IN_PKG(!pSdcCfgPara->burnEx.bitsMap.mediaPath));
            if (ret) {
                    DWN_ERR("Fail to set smart mode\n");
                    ret = __LINE__; goto _finish;
            }

            ret = optimus_sdc_burn_partitions(pSdcCfgPara, hImg, hUiProgress, 1);
            if (ret) {
                    DWN_ERR("Fail when burn partitions\n");
                    ret = __LINE__; goto _finish;
            }
    }

    if (pSdcCfgPara->burnEx.bitsMap.mediaPath) //burn media image
    {
        const char* mediaPath = pSdcCfgPara->burnEx.mediaPath;

        ret = optimus_sdc_burn_media_partition(mediaPath, NULL);//no progress bar info if have partition image not in package
        if (ret) {
            DWN_ERR("Fail to burn media partition with image %s\n", mediaPath);
            optimus_storage_exit();
            ret = __LINE__;goto _finish;
        }
    }
    optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STPES_AFTER_BURN_DATA_PARTS_OK);

    //TO burn nandkey/securekey/efusekey
    ret = sdc_burn_aml_keys(hImg, pSdcCfgPara->custom.keyOverwrite);
    if (ret) {
            DWN_ERR("Fail in sdc_burn_aml_keys\n");
            ret = __LINE__;goto _finish;
    }

#if 1
    if (hasBootloader)
    {//burn bootloader
            ret = optimus_burn_bootlader(hImg);
            if (ret) {
                    DWN_ERR("Fail in burn bootloader\n");
                    goto _finish;
            }
            else
            {//update bootloader ENV only when bootloader image is burned
                    ret = optimus_set_burn_complete_flag();
                    if (ret) {
                            DWN_ERR("Fail in set_burn_complete_flag\n");
                            ret = __LINE__; goto _finish;
                    }
            }
    }
#endif
    optimus_progress_ui_direct_update_progress(hUiProgress, UPGRADE_STEPS_AFTER_BURN_BOOTLOADER_OK);

_finish:
    image_close(hImg);
    optimus_progress_ui_report_upgrade_stat(hUiProgress, !ret);
    optimus_report_burn_complete_sta(ret, pSdcCfgPara->custom.rebootAfterBurn);
    optimus_progress_ui_release(hUiProgress);
    //optimus_storage_exit();//temporary not exit storage driver when failed as may continue burning after burn
    return ret;
}

int optimus_burn_package_in_sdmmc(const char* sdc_cfg_file)
{
    int rcode = 0;

#if 0//this asserted by 'run update' and 'aml_check_is_ready_for_sdc_produce'
    rcode = do_fat_get_fileSz(sdc_cfg_file);
    if (!rcode) {
        printf("The [%s] not exist in bootable mmc card\n", sdc_cfg_file);
        return __LINE__;
    }
#endif//#if 0

    rcode = optimus_device_probe("mmc", "0");
    if (rcode) {
        DWN_ERR("Fail to detect device mmc 0\n");
        return __LINE__;
    }

    setenv("usb_update","0");
    rcode = optimus_burn_with_cfg_file(sdc_cfg_file);

    return rcode;
}

int do_sdc_burn(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int rcode = 0;
    const char* sdc_cfg_file = argv[1];

    if (argc < 2 ) {
        return CMD_RET_USAGE;
    }

    if ( !aml_check_is_ready_for_sdc_produce() ) {
        DWN_DBG("Not ready\n");
        return __LINE__;
    }

    optimus_work_mode_set(OPTIMUS_WORK_MODE_SDC_UPDATE);
    run_command("osd clear", 0);
    show_logo_to_report_burning();//indicate enter flow of burning! when 'run update'
    if (optimus_led_open(LED_TYPE_PWM)) {
        DWN_ERR("Fail to open led for burn\n");
        return __LINE__;
    }
    optimus_led_show_in_process_of_burning();

    rcode = optimus_burn_package_in_sdmmc(sdc_cfg_file);

    return rcode;
}

U_BOOT_CMD(
   sdc_burn,      //command name
   5,               //maxargs
   0,               //repeatable
   do_sdc_burn,   //command function
   "Burning with amlogic format package in sdmmc ",           //description
   "argv: [sdc_burn_cfg_file]\n"//usage
   "    -aml_sdc_burn.ini is usually used configure file\n"
);

