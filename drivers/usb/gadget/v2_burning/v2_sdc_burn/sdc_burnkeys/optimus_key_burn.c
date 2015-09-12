/*
 * \file        optimus_key_burn.c
 * \brief       burning keys from sdcard like update.exe
 *
 * \version     1.0.0
 * \date        2014/12/25
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2014 Amlogic. All Rights Reserved.
 *
 */

/*
 *
 * This cmd [aml_key_burn] aim to burn keys like 'update.exe', and mainly used for myself.
 * like update.exe, the key in here is single and not need to sperate
 * e.g, for comparison, here to burn a hdcp key using aml_key_burn and update.exe
 *     0. update.exe identify .                                 <-----> aml_key_burn probe vfat sdc
 *     1. update.exe mwrite meson.dtb mem dtb normal .          <-----> aml_key_burn meson_dtb meson.dtb
 *     2, update.exe bulkcmd "key init 0x1234"                  <-----> aml_key_burn init 0x1234
 *     3, update.exe mwrite key hdcp normal hdcp308.val         <-----> aml_key_burn burn hdcp hdcp308.val
 *              other keys
 *     4, update.exe bulkcmd "key uninit"                       <-----> aml_key_burn uninit
 *
 */
#include "../optimus_sdc_burn_i.h"
#include <amlogic/keyunify.h>

#define _AML_KEY_ERR(fmt...)    sprintf(_errInfo, fmt), DWN_ERR(_errInfo)

static char _errInfo[512] = "";


typedef enum{
        DEV_FILE_FMT_VFAT       = 0xee,
        DEV_FILE_FMT_EXT2
}DevFileFmt_e;

typedef enum{
        DEV_INTF_EXT_SDMMC      = 0xdd,
        DEV_INTF_EXT_UDISK            ,
}DevIntf_e;

static struct optKeyInfo_s{
        DevFileFmt_e            fileFmt;
        DevIntf_e               intf;//interface
} _optKeyInfo;
/*
 * <aml_key_burn probe> device_format interface
 */
static int do_opt_keysburn_probe(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;
        const char* device_format = argv[2];//vfat
        const char* device_interf = argv[3];//sdc/udisk

        if (4 > argc) {
                _AML_KEY_ERR("failed:argc: %d < 4\n", argc);
                return __LINE__;
        }
        if (!strcmp(device_format, "vfat")) {
                _optKeyInfo.fileFmt = DEV_FILE_FMT_VFAT;
        }
        else{
                _AML_KEY_ERR("failed:device_format %s unsupported yet\n", device_format);
                return __LINE__;
        }

        if (!strcmp("sdc", device_interf))
        {
                static int _mmcprobe = 0;

                if (!_mmcprobe)
                {
                        rc = run_command("mmcinfo", 0);
                        if (rc) {
                                _AML_KEY_ERR("failed: in mmcinfo\n");
                                return __LINE__;
                        }
                        rc = optimus_device_probe("mmc", "0");
                        if (rc) {
                                _AML_KEY_ERR("Fail to detect device mmc 0\n");
                                return __LINE__;
                        }
                        _mmcprobe = 1;
                }
                _optKeyInfo.intf = DEV_INTF_EXT_SDMMC;
        }
        else if(!strcmp("udisk", device_interf))
        {
                static int _udiskProbe = 0;

                if (!_udiskProbe)
                {
                        rc = run_command("usb start 0", 0);
                        if (rc) {
                                _AML_KEY_ERR("Fail in mmcinfo\n");
                                return __LINE__;
                        }
                        rc = optimus_device_probe("usb", "0");
                        if (rc) {
                                _AML_KEY_ERR("Fail to detect device mmc 0\n");
                                return __LINE__;
                        }
                        _udiskProbe = 1;
                }
                _optKeyInfo.intf = DEV_INTF_EXT_UDISK;
        }
        else{
                _AML_KEY_ERR("device_interf %s unsupported\n", device_interf);
                return -__LINE__;
        }

        return rc;
}

static int do_opt_keysburn_init(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;

        if (3 > argc)
        {
                cmd_usage(cmdtp);
                return __LINE__;
        }
        rc = v2_key_command(argc, argv, _errInfo);
        if (rc) {
                DWN_ERR("Fail to init key driver.\n");
                return -__LINE__;
        }

        return rc;
}

static int do_opt_keysburn_uninit(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;

        rc = v2_key_command(argc, argv, _errInfo);
        if (rc) {
                DWN_ERR("Fail to init key driver.\n");
                return -__LINE__;
        }
        return rc;
}

static int do_opt_keysburn_misc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;

        --argc, ++argv;//skip the misc subcmd
        rc = v2_key_command(argc, argv, _errInfo);
        if (rc < 0) {
                return -__LINE__;
        }

        return rc;
}

static int optimus_read_keyfile_2_mem(const char* filePath, u8* buf, unsigned* keyValLen)
{
        int rc = 0;
        unsigned keySz = 0;

        if (DEV_FILE_FMT_VFAT == _optKeyInfo.fileFmt)
        {
                long hFile = -1;
                unsigned readSz = 0;

#if 1//FIXME: remove this mmcinfo
                /*rc = run_command("mmcinfo 0", 0);*/
                rc = optimus_sdc_burn_switch_to_extmmc();
                if (rc) {
                        DWN_ERR("Fail in mmcinfo\n");
                        return __LINE__;
                }
#endif//
                keySz = (unsigned)do_fat_get_fileSz(filePath);//can support both sdc and udisk
                if (!keySz) {
                        DWN_ERR("size is 0 of file [%s]\n", filePath);
                        return __LINE__;
                }

                hFile = do_fat_fopen(filePath);
                if (hFile < 0) {
                        DWN_ERR("Fail to open file[%s]\n", filePath);
                        return __LINE__;
                }

                readSz = do_fat_fread(hFile, buf, keySz);
                if (readSz != keySz) {
                        DWN_ERR("Want read %d bytes, but %d\n", keySz, readSz);
                        return __LINE__;
                }

                do_fat_fclose(hFile);
        }

        *keyValLen = keySz;
        return rc;
}

int optimus_keysburn_onekey(const char* keyName, u8* keyVal, unsigned keyValLen)
{
        int rc = 0;
        unsigned wrLen = 0;

        DWN_MSG("keyName[%s], keyValAddr=%p,len=%d\n", keyName, keyVal, keyValLen);
        wrLen = v2_key_burn(keyName, keyVal, keyValLen, _errInfo);
        DWN_MSG("writeLen=====%d\n", wrLen);
        rc = wrLen != keyValLen;
        DWN_MSG("%s in burn key[%s]\n", rc ? "failed" : "success", keyName);

        return rc;
}

static int do_opt_keysburn_burn(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;
        const char* keyName = argv[2];
        u8* keyVal = (u8*)OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR;
        unsigned keyValLen = 0;

        if (4 > argc) {
                _AML_KEY_ERR("argc=%d < 4\n", argc);
                return __LINE__;
        }
        if (argc > 4)
        {
                keyVal          = (u8*)simple_strtoul(argv[3], NULL, 16);
                keyValLen       = simple_strtoul(argv[4], NULL, 0);
        }
        else//The key is file in the specified device
        {
                const char* filePath = argv[3];

                rc = optimus_read_keyfile_2_mem(filePath, keyVal, &keyValLen);
                if (rc) {
                        _AML_KEY_ERR("Fail to read file[%s]\n", filePath);
                        return __LINE__;
                }
        }
        rc = optimus_keysburn_onekey(keyName, keyVal, keyValLen);

        return rc;
}


static cmd_tbl_t cmd_opt_key_burn[] = {
	U_BOOT_CMD_MKENT(probe,       4, 0, do_opt_keysburn_probe, "", ""),
	U_BOOT_CMD_MKENT(init,        3, 0, do_opt_keysburn_init, "", ""),
	U_BOOT_CMD_MKENT(uninit,      2, 0, do_opt_keysburn_uninit, "", ""),
	U_BOOT_CMD_MKENT(burn,        5, 0, do_opt_keysburn_burn, "", ""),
	U_BOOT_CMD_MKENT(misc,        6, 0, do_opt_keysburn_misc, "", ""),
};

static int do_aml_key_burn(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
        int rc = 0;
	cmd_tbl_t *c;

        sprintf(_errInfo, "success");
	c = find_cmd_tbl(argv[1], cmd_opt_key_burn, ARRAY_SIZE(cmd_opt_key_burn));

        if (!c) {
                DWN_ERR("Can't find subcmd[%s]\n", argv[1]);
		return 1;
        }

        rc = c->cmd(cmdtp, flag, argc, argv);
        DWN_MSG("[key]%s\n", _errInfo);
        if (rc < 0) {
                DWN_ERR("Fail in cmd[%s %s].ret=%d\n", argv[1], argv[2], rc);
                return -__LINE__;
        }
        rc = strncmp("success", _errInfo, 7);

        return rc;
}

U_BOOT_CMD(
   aml_key_burn,      //command name
   6,               //maxargs
   0,               //repeatable
   do_aml_key_burn,   //command function
   "Burning keys from external device(sdmmc/udisk/memory) other than usb device",           //description
   "argv: aml_key_burn ...\n"//usage
   "<probe> file_system interface --- init external device/interface\n"//usage
   "    - e.g.1, for fat sdcard  : <aml_key_burn probe> vfat sdc\n"
   "    - e.g.2, for fat udisk   : <aml_key_burn probe> vfat udisk\n"
   "\n"
   "<init/uninit> random_value --- init nandkey/efusekey driver\n"//usage
   "\n"
   "<burn> keyName keyFilePath(keyBufAddr keySize) --- init external device/interface\n"//usage
   "    - e.g.1, write hdcp key with hdcp308.key from sdcard: <aml_key_burn burn> hdcp hdcp308.key\n"
   "    - e.g.2, write hdcp key in addr 0x200000 : <aml_key_burn burn> hdcp 0x200000 308\n"
   "\n"
);

