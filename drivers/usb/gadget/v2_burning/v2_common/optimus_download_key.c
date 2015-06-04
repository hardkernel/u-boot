/*
 * =====================================================================================
 *
 *       Filename:  v2_download_key.c
 *
 *        Version:  1.0
 *        Created:  2013/9/4 14:10:07
 *       Compiler:  gcc
 *
 *         Author:  Sam Wu (yihui.wu@amlogic.com)
 *   Organization:  Amlogic Inc.
 *
 *       Revision:  none
 *    Description:  Funcitions and command to burn keys with key_unify driver
 *
 * =====================================================================================
 */
#include "../v2_burning_i.h"
#include <amlogic/keyunify.h>

extern ssize_t uboot_key_put(char *device,char *key_name, char *key_data,int key_data_len,int ascii_flag);
extern ssize_t uboot_key_get(char *device,char *key_name, char *key_data,int key_data_len,int ascii_flag);
extern ssize_t uboot_key_query(char *device,char *key_name,unsigned int *keystate);

#ifndef CMD_BUFF_SIZE
#define CMD_BUFF_SIZE (512)
#endif// #ifndef CMD_BUFF_SIZE

#define HDCP2_RX_LC128_LEN         (36)
#define HDCP2_RX_KEY_LEN           (862)
#pragma pack(push, 1)
typedef struct _Hdcp2RxKeyFmt{
        unsigned                version;
        char                    lc128[HDCP2_RX_LC128_LEN];
        char                    keyVal[HDCP2_RX_KEY_LEN];
}Hdcp2RxKeyFmt_t;
#pragma pack(pop)

#define HDCP2_RX_KEY_TOTAL_LEN        sizeof(Hdcp2RxKeyFmt_t)
#define HDCP2_RX_KEY_LC128_NAME       "hdcp2lc128"
#define HDCP2_RX_KEY_NAME             "hdcp2key"
#define HDCP2_RX_KEY_VERSION           (0x02000000U)

static char generalDataChange(const char input)
{
	int i;
	char result = 0;

	for (i=0; i<8; i++) {
         if ((input & (1<<i)) != 0)
            result |= (1<<(7-i));
         else
            result &= ~(1<<(7-i));
	}

	return result;
}

static void hdcp2DataEncryption(const unsigned len, const char *input, char *out)
{
     int i = 0;

     for (i=0; i<len; i++)
         *out++ = generalDataChange(*input++);
}

static void hdcp2DataDecryption(const unsigned len, const char *input, char *out)
{
     int i = 0;

     for (i=0; i<len; i++)
         *out++ = generalDataChange(*input++);
}

static int _hdcp2_rx_key_Encrypt_before_burn(const char* keyName, char* keyVal, const unsigned keyValLen,
                const u8** keyRealVal, unsigned* keyRealValLen, char* encryptBuf)
{
        Hdcp2RxKeyFmt_t* pHdcp2RxKey = (Hdcp2RxKeyFmt_t*)keyVal;

        if (HDCP2_RX_KEY_TOTAL_LEN != keyValLen) {
                DWN_ERR("hdcp2 rx len unsupported. want %d but get %d\n", HDCP2_RX_KEY_TOTAL_LEN, keyValLen);
                return __LINE__;
        }
        if (HDCP2_RX_KEY_VERSION != pHdcp2RxKey->version) {
                DWN_ERR("Version value 0x%x is error, should be 0x%x\n", pHdcp2RxKey->version, HDCP2_RX_KEY_VERSION);
                return __LINE__;
        }

        hdcp2DataEncryption(keyValLen, keyVal, encryptBuf);
        DWN_MSG("Ecnrypt hdcp2 END.\n");
        *keyRealVal     = (u8*)encryptBuf;
        *keyRealValLen  = keyValLen;

        return 0;
}

static int _hdcp2_rx_key_burn(const char* keyName, char* keyVal, const unsigned keyValLen)
{
	int err = -EINVAL;
        const char* keyDevice = NULL;
        int ascii_flag = 0;
        Hdcp2RxKeyFmt_t* pHdcp2RxKey = (Hdcp2RxKeyFmt_t*)keyVal;
        int flashKeyLen = 0;
        char* flashKeyVal = NULL;
        char* flashKeyName = NULL;

        keyDevice = key_unify_query_key_device((char*)keyName);
        if (strcmp(keyDevice, "nandkey")) {
                DWN_ERR("hdcp2 rx only support nandkey yet!\n");
                return __LINE__;
        }
#if 0//key value already ecnrypted!! in func '_hdcp2_rx_key_Encrypt_before_burn'
        if (HDCP2_RX_KEY_TOTAL_LEN != keyValLen) {
                DWN_ERR("hdcp2 rx len unsupported. want %d but get %d\n", HDCP2_RX_KEY_TOTAL_LEN, keyValLen);
                return __LINE__;
        }
        if (HDCP2_RX_KEY_VERSION != pHdcp2RxKey->version) {
                DWN_ERR("Version value 0x%x is error, should be 0x%x\n", pHdcp2RxKey->version, HDCP2_RX_KEY_VERSION);
                return __LINE__;
        }
#endif//

        ascii_flag = strcmp("hexascii", key_unify_query_key_format((char*)keyName)) ? 0 : 1 ;

        DWN_MSG("To Burn hdcp2 to flash\n");
        flashKeyLen = HDCP2_RX_LC128_LEN;
        flashKeyVal = (char*)&pHdcp2RxKey->lc128;
        flashKeyName = (char*)HDCP2_RX_KEY_LC128_NAME;
        err = uboot_key_put("auto", flashKeyName, flashKeyVal, flashKeyLen, ascii_flag);
        if (err < 0) {
                DWN_ERR("Fail to burn \"%s\" to flash\n", flashKeyName);
                return __LINE__;
        }
        DWN_MSG("Burn \"%s\" to flash OK.\n", flashKeyName);

        flashKeyLen = HDCP2_RX_KEY_LEN;
        flashKeyVal = (char*)&pHdcp2RxKey->keyVal;
        flashKeyName = (char*)HDCP2_RX_KEY_NAME;
        /*hdcp2DataEncryption(flashKeyLen, flashKeyVal, encryptBuf);*/
        err = uboot_key_put("auto", flashKeyName, flashKeyVal, flashKeyLen, ascii_flag);
        if (err < 0) {
                DWN_ERR("Fail to burn \"%s\" to flash\n", flashKeyName);
                return __LINE__;
        }
        DWN_MSG("Burn \"%s\" to flash OK.\n", flashKeyName);

        err = key_unify_write((char*)keyName, (u8*)&pHdcp2RxKey->version, 4);
        DWN_MSG("%s, ret 0x%x\n", __func__, err);
        err = err >=0 ? 0 : __LINE__;
        DWN_MSG("Write HDCP2 version end\n");

        return err;
}

static int _hdcp2_rx_key_read(char* keyName, char* keyValBuf, const unsigned keyValBufCap, unsigned* pKeyLen)
{
        int err = -EINVAL;
        const char* keyDevice = NULL;
        int ascii_flag = 0;
        Hdcp2RxKeyFmt_t* pHdcp2RxKey = (Hdcp2RxKeyFmt_t*)keyValBuf;
        unsigned flashKeyLen = 0;
        char* flashKeyVal = NULL;
        const char* flashKeyName = NULL;

        DWN_MSG("To read hdcp2.\n");
        keyDevice = key_unify_query_key_device(keyName);
        if (strcmp(keyDevice, "nandkey")) {
                DWN_ERR("hdcp2 rx only support nandkey yet!\n");
                return __LINE__;
        }
        if (HDCP2_RX_KEY_TOTAL_LEN > keyValBufCap) {
                DWN_ERR("BufSz for hdcp2 rx len %d < least len %d\n", keyValBufCap, HDCP2_RX_KEY_TOTAL_LEN);
                return __LINE__;
        }
        ascii_flag = strcmp("hexascii", key_unify_query_key_format(keyName)) ? 0 : 1 ;

        flashKeyLen = HDCP2_RX_LC128_LEN;
        flashKeyName = HDCP2_RX_KEY_LC128_NAME;
        flashKeyVal = (char*)&pHdcp2RxKey->lc128;
        err = uboot_key_get("auto", (char*)flashKeyName, flashKeyVal, flashKeyLen, ascii_flag);
        if (err < 0) {
                DWN_ERR("Fail to read \"%s\" from flash\n", flashKeyName);
                return __LINE__;
        }
        *pKeyLen = flashKeyLen;

        flashKeyLen = HDCP2_RX_KEY_LEN;
        flashKeyName = HDCP2_RX_KEY_NAME;
        flashKeyVal = (char*)&pHdcp2RxKey->keyVal;
        err = uboot_key_get("auto", (char*)flashKeyName, flashKeyVal, flashKeyLen, ascii_flag);
        if (err < 0) {
                DWN_ERR("Fail to read \"%s\" from flash\n", flashKeyName);
                return __LINE__;
        }
        *pKeyLen += flashKeyLen;

        err = key_unify_read(keyName, (u8*)&pHdcp2RxKey->version, 4, &flashKeyLen);
        if (err < 0) {
                DWN_ERR("Fail to read \"%s\" from flash\n", keyName);
                return __LINE__;
        }
        *pKeyLen += 4;

        return 0;
}

int decrypt_hdcp_license_to_raw_value(const char* keyName, const u8* keyVal, const unsigned keyValLen, char* errInfo,
                              const u8** keyRealVal, unsigned* keyRealValLen,
                              char* decryptBuf, const unsigned decryptBufSz)
{
    int ret = 0;
    decryptBuf = decryptBuf;//avoid compiler warning as not used

    DWN_MSG("hdcp down in len %d\n", keyValLen);
    if (288 == keyValLen) //288 means license data is raw, not including the 20Bytes sha value
    {
        return 0;//ok, it's raw data if size is 288
    }
    else if(308 == keyValLen)
    {
        const unsigned shaSumLen = 20;
        const unsigned licLen = keyValLen - shaSumLen;
        const u8* orgSum = keyVal + licLen;
        u8 genSum[shaSumLen];

        sha1_csum((u8*)keyVal, licLen, genSum);

        ret = memcmp(orgSum, genSum, shaSumLen);
        if (ret) {
            const unsigned fmtStrLen = shaSumLen * 2 + 2;
            char org_sha1Str[fmtStrLen];
            char gen_sha1Str[fmtStrLen];

            optimus_hex_data_2_ascii_str(orgSum, shaSumLen, org_sha1Str, fmtStrLen);
            optimus_hex_data_2_ascii_str(genSum, shaSumLen, gen_sha1Str, fmtStrLen);
            sprintf(errInfo, "failed:hdcp, orgSum[%s] != genSum[%s]\n", org_sha1Str, gen_sha1Str);
            DWN_ERR(errInfo);

            return EINVAL;
        }
        DWN_MSG("Verify hdcp key with sha1sum OK\n");

        *keyRealValLen = licLen;
        return 0;
    }
    else
    {
        sprintf(errInfo, "failed:hdcp len %d is invalid\n", keyValLen);
        DWN_ERR(errInfo);
        return -EINVAL;
    }

    return 0;
}

int decrypt_mac_str_fmt_4_media(const char* keyName, const u8* keyVal, const unsigned keyValLen, char* errInfo,
                              const u8** keyRealVal, unsigned* keyRealValLen,
                              char* decryptBuf, const unsigned decryptBufSz)
{
    int index = 0;
    const char* keyDevice = NULL;

    if (17 != keyValLen) //288 means license data is raw, not including the 20Bytes sha value
    {
        sprintf(errInfo, "failed:mac len %d is invalid, must be 17\n", keyValLen);
        DWN_ERR(errInfo);
        return -EINVAL;
    }

    for (index = 2; index < 17; index += 3) {
        const char c = keyVal[index];
        if (':' != c) {
            sprintf(errInfo, "failed:L%d:mac str(%s) fmt err at index[%d]\n", __LINE__, keyVal, index);
            DWN_ERR(errInfo);
            return -EINVAL;
        }
    }

    for (index = 0; index < 17; index += 3) {
        int k = 0;
        for (k = 0; k < 2; ++k) {
            const char c = keyVal[index + k];
            if (!( (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F') )) {
                sprintf(errInfo, "failed:L%d:mac str(%s) fmt err at index[%d]\n", __LINE__, keyVal, index);
                DWN_ERR(errInfo);
                return -EINVAL;
            }
        }
    }

    keyDevice = key_unify_query_key_device((char*)keyName);
    DWN_MSG("write %s as %s\n", keyName, keyDevice);
    if (strcmp("efusekey", keyDevice)) //not efusekey, not need to decrypt
    {
        return 0;
    }

    *keyRealVal     = (u8*)decryptBuf;//change the keyRealVal to decryptBuf
    *keyRealValLen  = 6;

    for (index = 0; index < 17; index += 3) {
        const char *theByteStr = (const char*)keyVal + index;
        int k = 0;
        unsigned byteSum = 0;

        for (k = 0; k < 2; ++k) {
            const char c    = *theByteStr++;

            if (c >= '0' && c <= '9') {
                byteSum += c - '0' + 0x0;
            }
            else if (c >= 'a' && c <= 'f'){
                byteSum += c - 'a' + 0xa;
            }
            else if (c >= 'A' && c <= 'F'){
                byteSum += c - 'A' + 0XA;
            }
            else{
                sprintf(errInfo, "failed:Exception when burn key for efuse, c=%x\n", c);
                return -EINVAL;
            }
            byteSum <<= 4 * (1 - k);
        }
        DWN_DBG("byteSum=0x%x\n", byteSum);
        *decryptBuf++ = byteSum;
    }

    return 0;
}

/*
 * Check or Decrypt the key from usb to real key value before burn to device
 *Only depending the keyName to decide whether the key value needed special disposed !!
 * */
int check_or_decrypt_raw_usb_key_value(const char* keyName, const u8* keyVal, const unsigned keyValLen, char* errInfo,
                              const u8** keyRealVal, unsigned* keyRealValLen)
{
    int ret = 0;
    char* keyDecryptBuf             = (char*)OPTIMUS_KEY_DECRYPT_BUF;
    const unsigned keyDecryptBufSz  = OPTIMUS_KEY_DECRYPT_BUF_SZ;

    *keyRealVal = keyVal;
    *keyRealValLen = keyValLen;

    //do with the special key value
    if (!strcmp("hdcp", keyName))
    {
        ret = decrypt_hdcp_license_to_raw_value(keyName, keyVal, keyValLen, errInfo,
                                keyRealVal, keyRealValLen, keyDecryptBuf, keyDecryptBufSz);
    }
    else if (!strcmp("mac", keyName) || !strcmp("mac_bt", keyName) || !strcmp("mac_wifi", keyName))
    {
        ret = decrypt_mac_str_fmt_4_media(keyName, keyVal, keyValLen, errInfo,
                                keyRealVal, keyRealValLen, keyDecryptBuf, keyDecryptBufSz);
    }
    else if(!strcmp("hdcp2", keyName))
    {
            ret = _hdcp2_rx_key_Encrypt_before_burn(keyName, (char*)keyVal, keyValLen, keyRealVal, keyRealValLen, keyDecryptBuf);
    }
    else if(!strcmp("your_key_name", keyName))
    {
        //TODO:Add your key decrypt or check code here
    }

    return ret;
}

/*
 *This fucntion called by mwrite command, mread= bulkcmd "download key .." + n * download transfer, for key n==1
 *Attentions: "return value is the key length" if burn sucess

 *@keyName: key name in null-terminated c style string
 *@keyVal: key value download from USB, "the value for sepecial keyName" may need de-encrypt by user code
 *@keyValLen: the key value downloaded from usb transfer!
 *@errInfo: start it with success if burned ok, or format error info into it tell pc burned failed
 */
unsigned v2_key_burn(const char* keyName, const u8* keyVal, const unsigned keyValLen, char* errInfo)
{
        int ret = 0;
        unsigned writtenLen = 0;
        const u8* keyRealVal = NULL;//the real value to burn to flash/efuse
        unsigned keyRealValLen = 0;

        ret = check_or_decrypt_raw_usb_key_value(keyName, keyVal, keyValLen, errInfo,
                        &keyRealVal, &keyRealValLen);
        if (ret) {
                DWN_ERR("Fail to check_or_decrypt_raw_usb_key_value, writtenLen=0x%x\n", writtenLen);
                return 0;
        }

        if (!strcmp("hdcp2", keyName))
        {
                ret = _hdcp2_rx_key_burn(keyName, (char*)keyRealVal, keyValLen);
        }
        else{//not hdcp2
                ret = key_unify_write((char*)keyName, (unsigned char*)keyRealVal, keyRealValLen);
        }
        DWN_MSG("%s, ret 0x%x\n", __func__, ret);
        writtenLen = ret >=0 ? keyValLen : 0;

        return writtenLen;
}

//Trnasform data format after read, To make data read back equal to write
static int _key_read_fmt_transform_4_usr(const char* keyName,
        const unsigned keyValBufCap, u8* keyVal, const unsigned keyLenInDevice, unsigned* fmtLen)
{
    int rc = 0;
    char* decryptBuf = (char*)OPTIMUS_KEY_DECRYPT_BUF;

    if (keyValBufCap < keyLenInDevice) {
        DWN_ERR("bufsz %d < real sz %d\n", keyValBufCap, keyLenInDevice);
        return __LINE__;
    }
    //keyValBufCap > keyLenInDevice
    if (!strcmp("mac", keyName) || !strcmp("mac_bt", keyName) || !strcmp("mac_wifi", keyName))
    {
            if (6 == keyLenInDevice)
            {
                    int i = 0;

                    rc = optimus_hex_data_2_ascii_str(keyVal, keyLenInDevice, decryptBuf, keyValBufCap);
                    if (rc) {
                            DWN_ERR("Fail to format mac hex data to str, rc=%d\n", rc);
                            return __LINE__;
                    }
                    for (i = 0; i < keyLenInDevice; ++i) {
                            *keyVal++ = decryptBuf[i * 2];
                            *keyVal++ = decryptBuf[i * 2 + 1];
                            *keyVal++ = ':';
                    }
                    *--keyVal = 0;
                    *fmtLen = keyLenInDevice * 3 - 1;

                    return 0;
            }
            else if(17 != keyLenInDevice){
                    DWN_ERR("mac/bt/wifi len in device must be 17 or 6, but %d\n", keyLenInDevice);
                    return __LINE__;
            }
    }
    else if(!strcmp("hdcp2", keyName))
    {
            //Decrypt hdcp2_rx key for miracast
            hdcp2DataDecryption(keyLenInDevice, (char*)keyVal, decryptBuf);
            memcpy(keyVal, decryptBuf, keyLenInDevice);
    }
    else{

    }

    return rc;
}

/*
 *This fucntion called by mread command, mread= bulkcmd "upload key .." + n * upload transfer, for key n==1
 *Attentions: return 0 if success, else failed
 *@keyName: key name in null-terminated c style string
 *@keyVal: the buffer to read back the key value
 *@keyValLen: keyVal len is strict when read, i.e, user must know the length of key he/she wnat to read!!
 *@errInfo: start it with success if burned ok, or format error info into it tell pc burned failed
 */
int v2_key_read(const char* keyName, u8* keyVal, const unsigned keyValLen, char* errInfo, unsigned* fmtLen)
{
    unsigned reallen = 0;
    unsigned keyIsBurned = -1;
    unsigned keypermit = -1;
    int rc = 0;

    rc = key_unify_query((char*)keyName, &keyIsBurned, &keypermit);
    if (rc < 0 || 1 != keyIsBurned) {
        sprintf(errInfo, "failed to query key state, rc %d, keyIsBurned=%d\n", rc, keyIsBurned);
        DWN_ERR(errInfo);
        return __LINE__;
    }

    if (!strcmp("hdcp2", keyName))
    {
            rc = _hdcp2_rx_key_read((char*)keyName, (char*)keyVal, keyValLen, &reallen);
            if (rc) {
                    sprintf(errInfo, "failed:key_read rc %d\n", rc);
                    DWN_ERR(errInfo);
                    return __LINE__;
            }
    }
    else
    {
            rc = key_unify_read((char*)keyName, keyVal, keyValLen, &reallen);
            if (rc < 0 || !reallen) {
                    sprintf(errInfo, "failed:key_read rc %d, reallen(%d), want len(%d)\n", rc, reallen, keyValLen);
                    DWN_ERR(errInfo);
                    return __LINE__;
            }
    }

    *fmtLen = reallen;
    rc = _key_read_fmt_transform_4_usr(keyName, keyValLen, keyVal, reallen, fmtLen);

    return rc;
}

//key command: 1, key init seed_in_str; 2, key uninit
//argv[0] can be 'key' from usb tool, or 'aml_key_burn/misc' from sdc_burn
int v2_key_command(const int argc, char * const argv[], char *info)
{
    const char* keyCmd = argv[1];
    int rcode = 0;
    int subCmd_argc = argc - 1;
    char* const * subCmd_argv = argv + 1;

    DWN_DBG("argc=%d, argv[%s, %s, %s, %s]\n", argc, argv[0], argv[1], argv[2], argv[3]);
    if (argc < 2) {
        sprintf(info, "argc < 2, need key subcmd\n");
        DWN_ERR(info);
        return __LINE__;
    }

    if (!strcmp("init", keyCmd))
    {
        if (argc < 3) {
            sprintf(info, "failed:cmd [key init] must take argument (seedNum)\n");
            DWN_ERR(info);
            return __LINE__;
        }

        u64 seedNum = simple_strtoull(subCmd_argv[1], NULL, 16);
        if (!seedNum) {
            sprintf(info, "failed:seedNum %s illegal\n", argv[2]);
            DWN_ERR(info);
            return __LINE__;
        }

        rcode = key_unify_init((char*)&seedNum, sizeof(seedNum));

        DWN_MSG("seedNum is 0x%llx, rcode %d\n", seedNum, rcode);
    }
    else if(!strcmp("uninit", keyCmd))
    {
        rcode = key_unify_uninit();
    }
    else if(!strcmp("is_burned", keyCmd))
    {
        if (subCmd_argc < 2) {
            sprintf(info, "failed: %s %s need a keyName\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }
        const char* queryKey = subCmd_argv[1];
        unsigned keyIsBurned = -1;
        unsigned keypermit = -1;
        rcode = key_unify_query((char*)queryKey, &keyIsBurned, &keypermit);
        if (rcode < 0) {
            sprintf(info, "failed to query key state, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        rcode = (1 == keyIsBurned) ? 0 : __LINE__;
        sprintf(info, "%s:key[%s] was %s burned yet(keystate %d, keypermit 0x%x)\n",
                rcode ? "failed" : "success", queryKey, rcode ? "NOT" : "DO", keyIsBurned, keypermit);
    }
    else if(!strcmp("can_write", keyCmd) || !strcmp("can_read", keyCmd))
    {
        if (subCmd_argc < 2) {
            sprintf(info, "failed: %s %s need a keyName\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }
        const char* queryKey = subCmd_argv[1];
        unsigned keyIsBurned = -1;
        unsigned keypermit = -1;
        rcode = key_unify_query((char*)queryKey, &keyIsBurned, &keypermit);
        if (rcode < 0) {
            sprintf(info, "failed to query key state, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        int writeCmd = !strcmp("can_write", keyCmd);
        unsigned canWrite = ( 0xa == ( (keypermit>>4) & 0xfu ) );
        unsigned canRead  = ( 0xa == ( keypermit & 0xfu ) );
        rcode = writeCmd ? !canWrite : !canRead;
        sprintf(info, "%s:key[%s] %s %s (keystate %d, keypermit 0x%x)\n",
                rcode ? "failed" : "success", queryKey, rcode ? "NOT" : "DO", keyCmd, keyIsBurned, keypermit);
    }
    else if(!strcmp("write", keyCmd))
    {
        /*
         *
         *key write [keyName keyValueInStr]
         *write direct, not support to deencrypt or verify, debug pipe, don't use to in PC tools
         *Attentions it support at most 512-6 Bytes!
         */

        const char* keyName = subCmd_argv[1];
        const char* keyValInStr = subCmd_argv[2];

        if (subCmd_argc < 3) {
            sprintf(info, "failed: %s %s need a keyName and keyValInStr\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }

        rcode = v2_key_burn(keyName, (u8*)keyValInStr, strlen(keyValInStr), info);
        rcode = (strlen(keyValInStr) == rcode) ? 0 : __LINE__;
    }
    else if(!strcmp("read", keyCmd) || !strcmp("get_len", keyCmd))
    {
        /*
         *key read [keyName], read directly to info buffer
         *debug pipe, support at most 512-6 bytes, and PLS DON'T use in PC tools
         *
         *
         */
        unsigned actualLen = 0;
        const int cswBufLen = CMD_BUFF_SIZE - sizeof("success") + 1;
        const char* keyName = subCmd_argv[1];
        unsigned char* keyValBuf = (unsigned char*)info + CMD_BUFF_SIZE - cswBufLen;
        unsigned ReadBufLen = cswBufLen;

        if (subCmd_argc < 2) {
            sprintf(info, "failed: %s %s need a keyName\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }

        const int is_query = !strcmp("get_len", keyCmd) ;
        if (is_query) {
            keyValBuf  = (u8*)OPTIMUS_KEY_DECRYPT_BUF;
            ReadBufLen = OPTIMUS_KEY_DECRYPT_BUF_SZ;
        }

        rcode = v2_key_read((char*)keyName, keyValBuf, ReadBufLen, info, &actualLen);
        if (is_query)
        {
            if (!rcode)
                sprintf(info, "success%u", actualLen);
            else
                sprintf(info, "failed:at get_len rc %d\n", rcode);
        }
        DWN_MSG("key[%s] len(%d), rc(%d)\n", keyName, actualLen, rcode);

        rcode = rcode >=0 ? 0 : rcode;
    }
    else if(!strcmp("get_fmt", keyCmd))
    {
        const char* fmt = NULL;
        fmt = key_unify_query_key_format((char*)subCmd_argv[1]);
        sprintf(info, "success:%s\n", fmt);
    }
    else{
        sprintf(info, "failed:Error keyCmd[%s]\n", keyCmd);
        DWN_ERR(info);
        rcode = __LINE__;
    }

    DWN_DBG("rcode 0x%x\n", rcode);
    return rcode;
}

