/*
 * \file        sdc_keysprovider.c
 * \brief       Parse users' nankey/efusekey like PC's keysprovider.dll in sdcard burning mode
 *
 * \version     1.0.0
 * \date        2014/12/25
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2014 Amlogic. All Rights Reserved.
 *
 */
#include "../optimus_sdc_burn_i.h"
#include "sdc_bootPart_license.h"

#define _KEYS_PRV_DBG(fmt...) //DWN_MSG(fmt)
#define _KEYS_PRV_ITEM_INF_ADDR_4_CONSIST     (OPTIMUS_DOWNLOAD_DISPLAY_BUF + 48 * 1024)
#define _KEYS_PRV_ITEM_INF_ADDR_MISC          (OPTIMUS_DOWNLOAD_DISPLAY_BUF + 52 * 1024)

#define _KEY_VAL_TMP_BUF            (OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR - OPTIMUS_DOWNLOAD_SLOT_SZ)
static struct {
        char*                   keyBuf;
        unsigned                keySize;
}_currentKey = {0};

//Note: keys which read only is not need to update license, and so not need stored in boot partition
//Typedef for keys structs in sdcard boot partition
#if 1
#define AML_BOOT_PART_KEY_IMG_OFFSET            (0X2U<<20)
#define AML_BOOT_PART_KEY_IMG_MAGIC_LEN         8
#define AML_BOOT_PART_KEY_IMG_MAGIC_V1          "AML_KEY!"
#define AML_BOOT_PART_KEY_IMG_ALIGN_SZ          512
#define AML_BOOT_PART_KEY_IMG_HEAD_SZ           (64)

#define AML_BOOT_PART_KEY_ITEM_INF_LEN          (64)
#define AML_BOOT_PART_KEY_ITEM_NAME_LEN_MAX     (16)

//struct for the keys head which stored in boot partition
#pragma pack(push, 4)
typedef struct {
        __u32           crc;
        __s32           version;

        __u8            magic[AML_BOOT_PART_KEY_IMG_MAGIC_LEN];

        __u32           imgSz;
        __u32           imgItemNum;

        __u32           alignSz;//512
        __u8            resrv[AML_BOOT_PART_KEY_IMG_HEAD_SZ - 8 * 3 - 4];

}AmlBootPartKeysHead_t;
#pragma pack(pop)

#pragma pack(push, 4)
typedef struct {
        __u8            keyName[AML_BOOT_PART_KEY_ITEM_NAME_LEN_MAX];

        __u32           itemIndex;
        __u32           itemSz;         //equl to sizeof of each key

        __u32           itemBodyOffset;
        __u32           itemHasConf;//this item name is configured in keys.conf

        __u8            resrv[32];

}KeyInfo_t;
#pragma pack(pop)

#define MAX_KEY_INF_NUM                 5       //the max key numbers supported at the same time

typedef struct {
        AmlBootPartKeysHead_t           bootPartKeyHead;
        KeyInfo_t                       keysInf[MAX_KEY_INF_NUM];
}BootPartKeyInf_t;

#endif//image for keys END #if 1

#define debugP(fmt...) //printf("L%d:", __LINE__),printf(fmt)
#define errorP(fmt...) printf("Err[keyspr]L%d:", __LINE__),printf(fmt)
#define wrnP(fmt...)   printf("Wrn[keyspr]L%d:", __LINE__),printf(fmt)
#define MsgP(fmt...)   printf("Msg[keyspr]L%d:", __LINE__),printf(fmt)

#define KEY_MAP_MAGIC   0xeeffaa00

enum {
        KEY_FMT__MAC            = 0XBB,         //string format like 00:01:02:03:04:05
        KEY_FMT__ONLEYONE             ,         //only one format means read the total license file as key value
        KEY_FMT__HDCP                 ,
        KEY_FMT__HDCP2                ,
};

//Different keyNames can have the same key format
typedef int (*pFunc_getKeyValByLic)(const char* licensePath, u8* keyVal, unsigned* keyValLen, const char* keyName);
typedef int (*pFunc_updateLic)(const char* keyName, const char* licensePath);//update the licnese file when burn succeed

typedef struct _keyFmtMapping{
        unsigned                magic;
        const char* const       keyName;
        const char* const       licenseFile;
        const unsigned          keyFmt;
        pFunc_getKeyValByLic    get_key_val;
        pFunc_updateLic         update_license;
}KeyFmtMap_t;

static int get_key_val_for_fmt_mac(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName);
static int get_key_val_for_fmt_hdcp(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName);
static int get_key_val_for_fmt_hdcp2rx(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName);
static int get_key_val_for_fmt_onlyone(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName);

static int update_lic_for_fmt_mac(const char* keyName, const char* licenseName);
static int update_lic_for_fmt_hdcp(const char* keyName, const char* licenseName);
static int update_lic_for_fmt_hdcp2rx(const char* keyName, const char* licenseName);

static const KeyFmtMap_t _keysFmtMapping[] = {
        /*     magic,           keyname                  license file name      keyFmt*/
        [0] = {KEY_MAP_MAGIC,   "mac",                  "license/mac_ether.ini"  , KEY_FMT__MAC     , get_key_val_for_fmt_mac    , update_lic_for_fmt_mac    },
        [1] = {KEY_MAP_MAGIC,   "mac_bt",               "license/mac_bt.ini"     , KEY_FMT__MAC     , get_key_val_for_fmt_mac    , update_lic_for_fmt_mac    },
        [2] = {KEY_MAP_MAGIC,   "mac_wifi",             "license/mac_wifi.ini"   , KEY_FMT__MAC     , get_key_val_for_fmt_mac    , update_lic_for_fmt_mac    },
        [3] = {KEY_MAP_MAGIC,   "hdcp",                 "license/HDCP_LIENCE"    , KEY_FMT__HDCP    , get_key_val_for_fmt_hdcp   , update_lic_for_fmt_hdcp   },
        [4] = {KEY_MAP_MAGIC,   "hdcp2",                "license/HDCP2_LIENCE"   , KEY_FMT__HDCP2   , get_key_val_for_fmt_hdcp2rx, update_lic_for_fmt_hdcp2rx},
        [5] = {KEY_MAP_MAGIC,   "secure_boot_set",      "license/SECURE_BOOT_SET", KEY_FMT__ONLEYONE, get_key_val_for_fmt_onlyone, NULL},
};
#define _SupportKeysNum (sizeof(_keysFmtMapping)/sizeof(KeyFmtMap_t))

#if 1   //mac begin
static int optimus_sdc_burn_check_mac_ini_set_is_valid(const char* setName)
{
        const char* macSets[] = {"Group1", "Group2", "Group3"};
        const int   nSet      = sizeof(macSets)/sizeof(char*);
        int         index     = 0;
        int         rc        = 0;

        for (; index < nSet && !rc; ++index)
        {
                rc = !strcmp(setName, macSets[index]);
        }

        return rc;
}

typedef struct {
        char            startMac[17 + 3];       //+2 to align 4
        char            endMac[17 + 3];         //+2 to align 4
        unsigned        total;
        unsigned        used;
}MacGroup_t;

typedef struct {
        unsigned        actualGroup;
        MacGroup_t      groups[3];//max group is 3
}KeyInf_mac_t;

typedef struct {
        const char*             start;
        const char*             end;
        unsigned                used;
        unsigned                total;//total = end + 1 - start
}MacCfg_t;

/*static KeyInf_mac_t _bootPart_keyInf_Mac;//Mac key info stored in boot partition*/

static int optimus_update_mac_str_current_val(char* startVal, unsigned used)
{
        int i = 0;

        if (17 != strlen(startVal)) {
                DWN_ERR("start(%s) fmt error.\n", startVal);
                return __LINE__;
        }

        MsgP("start[%s], used=%d\n", startVal, used);
        for (i = 5; i >= 0 && used; --i, (used >>= 8))
        {
                char* grp2       = startVal + i * 3;
                unsigned grp2Val = simple_strtoul(grp2, NULL, 16);

                DWN_DBG("gpp2(%s)grep2=%d, used=%d\n", grp2, grp2Val, used);
                grp2Val += used & 0xff;
                if (grp2Val > 0xff)
                {
                        used    += 0x100;
                        grp2Val &= 0xff;
                }
                sprintf(grp2, "%02x", grp2Val);
                DWN_DBG("grp[%d]%s\n", i, grp2);
        }
        DWN_MSG("Update mac [%s]\n", startVal);

        return 0;
}

static int _optimus_get_mac_diff(MacCfg_t* macCfg)
{
        const char* start       = macCfg->start;
        const char* end         = macCfg->end;
        __u64 startVal          = 0;
        __u64 endVal            = 0;
        int i                   = 0;

        for (i = 0; i < 6; ++i, start += 3, end += 3)
        {
                startVal += simple_strtoul(start, NULL, 16);
                endVal   += simple_strtoul(end, NULL, 16);

                startVal <<= 8;
                endVal   <<= 8;
        }
        startVal >>= 8;
        endVal   >>= 8;
        DWN_MSG("mac range[%04x%08x, %04x%08x]\n",
                        (unsigned)(startVal>>32), (unsigned)(startVal),
                        (unsigned)(endVal>>32),   (unsigned)endVal      );
        macCfg->total = (unsigned)(endVal + 1 - startVal);
        return 0;
}

//update the mac value extracted from mac.ini
//To simplest the case, currently one group is supported
static int optimus_sdc_burn_parse_mac_ini_key_value(const char* setName, const char* keyName, const char* usrKeyVal)
{
        int rc = 0;
        int grpN = 0;
        MacCfg_t* currentMacCfg = (MacCfg_t*)_KEYS_PRV_ITEM_INF_ADDR_MISC;
        char* keyBuf = (char*)_KEY_VAL_TMP_BUF;
        KeyInf_mac_t* pKeyInf4Consist = (KeyInf_mac_t*)_KEYS_PRV_ITEM_INF_ADDR_4_CONSIST;

        rc = strncmp("Group", setName, 5) || ( 6 != strlen(setName) );
        if (rc) {//mac.ini only care Groupn
                return 0;
        }
        grpN = setName[5] - '1'; //'1' not '0'
        if (grpN > 3) {
                DWN_ERR("Can only support grp1 ~ grp3 now!, grp[%s] not ok\n", setName);
                return __LINE__;
        }
        pKeyInf4Consist->actualGroup = grpN + 1;
        MacGroup_t* pKeyConsist = pKeyInf4Consist->groups + grpN;

        _KEYS_PRV_DBG("grp[%d]key=[%s], val=[%s]\n", grpN, keyName, usrKeyVal);
        //the mac cfg must be in the order: start + end (+used)
        if (!strcmp("start", keyName))
        {
                currentMacCfg->start = usrKeyVal;//value in memory
                _currentKey.keySize = strlen(usrKeyVal);
                strcpy(keyBuf, currentMacCfg->start);
                keyBuf[_currentKey.keySize] = 0;
                _currentKey.keyBuf = keyBuf;
                DWN_DBG("keybuf[%s]\n", keyBuf);
                memcpy(pKeyConsist->startMac, usrKeyVal, strlen(usrKeyVal));
        }
        else if (!strcmp("end", keyName))
        {
                currentMacCfg->end = usrKeyVal;
                _currentKey.keySize = strlen(usrKeyVal);
                _optimus_get_mac_diff(currentMacCfg);
                memcpy(pKeyConsist->endMac, usrKeyVal, strlen(usrKeyVal));
                pKeyConsist->total = currentMacCfg->total;
        }
        else if(!strcmp("used", keyName))
        {
                currentMacCfg->used = simple_strtoul(usrKeyVal, NULL, 0);
                if (currentMacCfg->used >= currentMacCfg->total) {
                        DWN_ERR("mac used(%d) >= total(%d)\n", currentMacCfg->used , currentMacCfg->total);
                        return __LINE__;
                }
                pKeyConsist->used = currentMacCfg->used;
        }

        if (17 != _currentKey.keySize) {
                errorP("key size %d of mac(%s) is error, must be 17\n", _currentKey.keySize, usrKeyVal);
                return __LINE__;
        }

        return 0;
}

static int _update_mac_with_cfg_and_bootpart(KeyInf_mac_t* pKeyInf4Consist, KeyInf_mac_t* pKeyInfInBootPart,
                u8* keyVal, unsigned* keyValLen)
{
        const int grpNum = pKeyInf4Consist->actualGroup;
        MacGroup_t* theMacGrpCfg        = NULL;
        MacGroup_t* theMacGrpInBootPart = NULL;
        unsigned    currentUsed         = 0;
        int i = 0;

        theMacGrpCfg = pKeyInf4Consist->groups;
        currentUsed  = theMacGrpCfg->used;
        for (; i < grpNum; ++i, ++theMacGrpCfg)
        {
                const unsigned leftInCfg = theMacGrpCfg->total - theMacGrpCfg->used;
                unsigned leftCnt         = leftInCfg;
                if (pKeyInfInBootPart)
                {
                        theMacGrpInBootPart             = pKeyInfInBootPart->groups + i;
                        const unsigned leftInBoot       = theMacGrpInBootPart->total - theMacGrpInBootPart->used;
                        DWN_MSG("leftInCfg=%u, leftInBoot=%u, used=%u\n", leftCnt, leftInBoot, theMacGrpInBootPart->used);
                        if (leftCnt < leftInBoot) {
                                DWN_ERR("Excp:leftInCfg[%u] < leftInBoot[%u]\n", leftCnt, leftInBoot);
                                return __LINE__;
                        }
                        if (theMacGrpInBootPart->total != theMacGrpCfg->total) {
                                DWN_ERR("Excp:cfg total[%u] != boot total[%u]\n",
                                                theMacGrpCfg->total, theMacGrpInBootPart->total);
                                return __LINE__;
                        }
                        currentUsed = ++theMacGrpInBootPart->used;//used is saved by prev burned
                }
                if (currentUsed < theMacGrpCfg->total) {//Find it
                        DWN_MSG("Found available at grp[%d], total=%u, used=%u\n",
                                        i, theMacGrpCfg->total, currentUsed);
                        break;
                }
        }

        if (i == grpNum) {
                DWN_ERR("Can't find available grp,i=%d\n", i);
                return __LINE__;
        }

        *keyValLen = strlen(theMacGrpCfg->startMac);
        memcpy(keyVal, theMacGrpCfg->startMac, *keyValLen);
        i = optimus_update_mac_str_current_val((char*)keyVal, currentUsed);
        return i;
}

//step 1: parsing license/mac.ini to get 'start' and 'used'
//step 2: search the key info in the boot key, if not existed , then append the keyinfo and update total count
//step 3: check the 'start' and 'used' is same as which in the boot partition if existed
//step 3: get the count recorded in the uboot partition
static int get_key_val_for_fmt_mac(const char* licPath, u8* keyVal, unsigned* keyValLen, const char* keyName)
{
        const int MaxLines = 256;//
        char* lines[MaxLines];
        int rc = __LINE__;
        int validLineNum = 0;
        KeyInf_mac_t* pKeyInfInBootPart = NULL;
        KeyInf_mac_t* pKeyInf4Consist = (KeyInf_mac_t*)_KEYS_PRV_ITEM_INF_ADDR_4_CONSIST;

        memset(pKeyInf4Consist, 0, sizeof(KeyInf_mac_t));
        validLineNum = parse_ini_file_2_valid_lines(licPath, (char*)keyVal, *keyValLen, lines);
        if (!validLineNum) {
                DWN_ERR("error in parse ini file\n");
                return __LINE__;
        }

        rc = optimus_ini_trans_lines_2_usr_params((const char* *)lines, validLineNum,
                        optimus_sdc_burn_check_mac_ini_set_is_valid,
                        optimus_sdc_burn_parse_mac_ini_key_value);
        if (rc) {
                DWN_ERR("Fail in get cfg from %s\n", licPath);
                return __LINE__;
        }
        *keyValLen = _currentKey.keySize;
        memcpy(keyVal, _currentKey.keyBuf, _currentKey.keySize);
        keyVal[_currentKey.keySize] = 0;

#if 1
        rc = optimus_sdc_bootPart_lic_get_key_infdata(keyName, (void**)&pKeyInfInBootPart);
        if (rc) {
                DWN_ERR("Fail in get key inf from boot part\n");
                return __LINE__;
        }
#endif
        rc = _update_mac_with_cfg_and_bootpart(pKeyInf4Consist, pKeyInfInBootPart, keyVal, keyValLen);

        return rc;
}

static int update_lic_for_fmt_mac(const char* keyName, const char* licenseName)
{
        int rc = 0;

        rc = optimus_sdc_bootPart_lic_update_key_inf(keyName, (u8*)_KEYS_PRV_ITEM_INF_ADDR_4_CONSIST, sizeof(KeyInf_mac_t));

        return rc;
}
#endif//MAC


static int get_key_val_for_fmt_hdcp(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName)
{
        int rc = __LINE__;


        return rc;
}

static int get_key_val_for_fmt_hdcp2rx(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName)
{
        int rc = __LINE__;


        return rc;
}

static int get_key_val_for_fmt_onlyone(const char* licenseName, u8* keyVal, unsigned* keyValLen, const char* keyName)
{
        int rc = 0;
        char _cmd[96];

        optimus_sdc_burn_switch_to_extmmc();

        sprintf(_cmd, "fatload mmc 0:1 0x%p %s", keyVal, licenseName);
        rc = run_command(_cmd, 0);
        if (rc) {
                errorP("failed in cmd[%s]\n", _cmd);
                return __LINE__;
        }

        *keyValLen = simple_strtoul(getenv("filesize"), NULL, 16);

        return rc;
}

static int update_lic_for_fmt_hdcp(const char* keyName, const char* licenseName)
{
        int rc = 0;


        return rc;
}

static int update_lic_for_fmt_hdcp2rx(const char* keyName, const char* licenseName)
{
        int rc = 0;


        return rc;
}

int optimus_sdc_keysprovider_init(void)
{
        /*return optimus_sdc_bootPart_lic_download();*/
        return 0;
}

int optimus_sdc_keysprovider_exit(void)
{
        /*return optimus_sdc_bootPart_lic_upload();*/
        return 0;
}

//check whether the key license is existed and supported
//keyName is getted from keys.conf in package like PC burning tool
int optimus_sdc_keysprovider_open(const char* keyName, const void** pHdle)
{
        int i = 0;
        int rc = __LINE__;

        const KeyFmtMap_t* pMappedKey = &_keysFmtMapping[0];
        for (i=0; i < _SupportKeysNum; ++i, ++pMappedKey) {
                rc = strcmp(keyName, pMappedKey->keyName);
                if (rc) continue;//keyName not mapped
                *pHdle = pMappedKey;
                return 0;
        }

        return rc;
}

int optimus_sdc_keysprovider_get_keyval(const void* pHdle, u8* pBuf, unsigned* keySz)
{
        const KeyFmtMap_t* pMappedKey = (const KeyFmtMap_t*)pHdle;
        const char* const  keyName    = pMappedKey->keyName;
        const char*        licPath    = pMappedKey->licenseFile;
        int rc = 0;

        if (KEY_MAP_MAGIC != pMappedKey->magic) {
                errorP("magic should be %x, but %x\n", KEY_MAP_MAGIC, pMappedKey->magic);
                return __LINE__;
        }
        rc = pMappedKey->get_key_val(licPath, pBuf, keySz, keyName);
        if (rc) {
                errorP("Fail in getKeyVal for key[%s] at lic path[%s]\n", keyName, licPath);
                return __LINE__;
        }

        return rc;
}

int optimus_sdc_keysprovider_update_license(const void* pHdle)
{
        const KeyFmtMap_t* pMappedKey = (const KeyFmtMap_t*)pHdle;
        const char* const  keyName    = pMappedKey->keyName;
        const char*        licPath    = pMappedKey->licenseFile;
        int rc = 0;

        if (KEY_MAP_MAGIC != pMappedKey->magic) {
                errorP("magic should be %x, but %x\n", KEY_MAP_MAGIC, pMappedKey->magic);
                return __LINE__;
        }
        if (!pMappedKey->update_license) return 0;

        rc = pMappedKey->update_license(keyName, licPath);
        if (rc) {
                errorP("Fail in getKeyVal for key[%s] at lic path[%s]\n", keyName, licPath);
                return __LINE__;
        }

        return 0;
}

