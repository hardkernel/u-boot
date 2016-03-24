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

#ifndef CMD_BUFF_SIZE
#define CMD_BUFF_SIZE (512)
#endif// #ifndef CMD_BUFF_SIZE


#ifndef __HDCP22_HEY_H__
#define __HDCP22_HEY_H__

typedef unsigned int    __u32;
typedef signed int      __s32;
typedef unsigned char   __u8;
typedef signed char     __s8;

#define IH_MAGIC	0x27051956	/* Image Magic Number		*/
#define IH_NMLEN		32	/* Image Name Length		*/


#define AML_RES_IMG_ITEM_ALIGN_SZ   16
#define AML_RES_IMG_V1_MAGIC_LEN    8
#define AML_RES_IMG_V1_MAGIC        "AML_HDK!"//8 chars
#define AML_RES_IMG_HEAD_SZ         (24)//64
#define AML_RES_ITEM_HEAD_SZ        (48)//64

#define AML_RES_IMG_VERSION_V1      (0x01)

#pragma pack(push, 1)
typedef struct pack_header{
	unsigned int	totalSz;/* Item Data total Size*/
	unsigned int	dataSz;	/* Item Data used  Size*/
	unsigned int	dataOffset;	/* Item data offset*/
	unsigned char   type;	/* Image Type, not used yet*/
	unsigned char 	comp;	/* Compression Type	*/
    unsigned short  reserv;
	char 	name[IH_NMLEN];	/* Image Name		*/
}AmlResItemHead_t;
#pragma pack(pop)

//typedef for amlogic resource image
#pragma pack(push, 4)
typedef struct {
    __u32   crc;    //crc32 value for the resouces image
    __s32   version;//0x01 means 'AmlResItemHead_t' attach to each item , 0x02 means all 'AmlResItemHead_t' at the head

    __u8    magic[AML_RES_IMG_V1_MAGIC_LEN];  //resources images magic

    __u32   imgSz;  //total image size in byte
    __u32   imgItemNum;//total item packed in the image

}AmlResImgHead_t;
#pragma pack(pop)

/*The Amlogic resouce image is consisted of a AmlResImgHead_t and many
 *
 * |<---AmlResImgHead_t-->|<--AmlResItemHead_t-->---...--|<--AmlResItemHead_t-->---...--|....
 *
 */
#endif//#ifndef __HDCP22_HEY_H__

#define _AML_HDCP22_RX_KEY_NAME     "aml_hdcp_key2.2"
static struct {
    const char* keyName;
    int         isEncrypt;
}
_amlHdcp22RxKeys[] = {
    [0] = {.keyName = "hdcp22_rx_private",  .isEncrypt = 1},
    [1] = {.keyName = "hdcp22_rx_fw",       .isEncrypt = 0},
    [2] = {.keyName = "hdcp2_rx",           .isEncrypt = 0},
};

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

static void hdcp2DataDecryption(const unsigned len, const char *input, char *out)
{
    int i = 0;
    for (i=0; i<len; i++)
        out[i] = generalDataChange(input[i]);
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

    DWN_DBG("to write key[%s] in len=%d\n", keyName, keyValLen);
    if (!strcmp(keyName, _AML_HDCP22_RX_KEY_NAME))
    {
        const AmlResImgHead_t*  packedImgHead = (AmlResImgHead_t*)keyVal;
        const AmlResItemHead_t* packedImgItem = (AmlResItemHead_t*)(packedImgHead + 1);
        int i = 0;

        const unsigned gensum = add_sum(keyVal + 4, keyValLen - 4);
        if (packedImgHead->crc != gensum) {
            DWN_ERR("crc chcked failed, origsum[%8x] != gensum[%8x]\n", packedImgHead->crc, gensum);
            return 0;
        }

        for (i = 0; i < packedImgHead->imgItemNum; ++i)
        {
            const AmlResItemHead_t* pItem = packedImgItem + i;
            const char* itemN = _amlHdcp22RxKeys[i].keyName;
            u8*         itembuf = (u8*)keyVal + pItem->dataOffset;
            int       itemSz  = pItem->dataSz;

            if (_amlHdcp22RxKeys[i].isEncrypt) {
                DWN_MSG("key[%s] at[%d] isEncrypted\n", itemN, i);
                hdcp2DataDecryption(itemSz, (char*)itembuf, (char*)itembuf);
            }
            DWN_MSG("burnkey[%s] at sz[%d]\n", itemN, itemSz);
            ret = key_manage_write(itemN, itembuf, itemSz);
            if (ret) {
                DWN_ERR("Fail to write key[%s] in len=%d\n", itemN, itemSz);
                return 0;
            }
        }
    }
    else
    {
        ret = key_manage_write(keyName, keyVal, keyValLen);
        if (ret) {
            DWN_ERR("Fail to write key[%s] in len=%d\n", keyName, keyValLen);
            return 0;
        }
    }

    writtenLen = ret >=0 ? keyValLen : 0;
    return writtenLen;
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
    ssize_t keysize = 0;
    int rc = 0;

    rc = key_manage_query_size(keyName, &keysize);
    if (rc) {
        sprintf(errInfo, "failed to query key size, err=%d\n", rc);
        DWN_ERR(errInfo);
        return __LINE__;
    }

    rc = key_manage_read(keyName, keyVal, keyValLen);

    *fmtLen = (unsigned)keysize;
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

        rcode = key_manage_init(subCmd_argv[1], subCmd_argv[2]);
    }
    else if(!strcmp("uninit", keyCmd))
    {
        rcode = key_manage_exit();
    }
    else if(!strcmp("is_burned", keyCmd))
    {
        if (subCmd_argc < 2) {
            sprintf(info, "failed: %s %s need a keyName\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }
        const char* queryKey = subCmd_argv[1];
        int keyIsBurned = 0;

        if (!strcmp(_AML_HDCP22_RX_KEY_NAME, queryKey)) queryKey = _amlHdcp22RxKeys[0].keyName;

        rcode = key_manage_query_exist(queryKey, &keyIsBurned);
        if (rcode) {
            sprintf(info, "failed to query key state, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        sprintf(info, "%s:key[%s] was %s burned", keyIsBurned ? "success" : "failed",
                        queryKey, keyIsBurned ? "" : "NOT");
        rcode = !keyIsBurned;
    }
    else if(!strcmp("can_write", keyCmd))
    {
        if (subCmd_argc < 2) {
            sprintf(info, "failed: %s %s need a keyName\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }
        const char* queryKey = subCmd_argv[1];
        int exist = 0;
        int canOverWrite = 0;

        if (!strcmp(_AML_HDCP22_RX_KEY_NAME, queryKey)) queryKey = _amlHdcp22RxKeys[0].keyName;

        rcode = key_manage_query_canOverWrite(queryKey, &canOverWrite);
        if (rcode) {
            sprintf(info, "failed in query key over write, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        rcode = key_manage_query_exist(queryKey, &exist);
        if (rcode) {
            sprintf(info, "failed in query key exist, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }

        int canWrite = ! (exist && !canOverWrite);
        sprintf(info, "%s:key[%s] %s can write(exist=%d, canOverWrite=%d)\n",
                canWrite ? "success" : "failed", queryKey, canWrite ? "" : "NOT", exist, canOverWrite);
        rcode = !canWrite;
    }
    else if(!strcmp("can_read", keyCmd))
    {
        int isSecure    = 0;
        int exist       = 0;
        const char* queryKey = subCmd_argv[1];

        rcode = key_manage_query_exist(queryKey, &exist);
        if (rcode) {
            sprintf(info, "failed in query key exist, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        rcode = key_manage_query_secure(queryKey,&isSecure);
        if (rcode) {
            sprintf(info, "failed in query key secure, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        sprintf(info, "%s:key[%s] %s can read\n",
                isSecure ? "failed" : "success", queryKey, isSecure ? "NOT" : "");
        rcode = isSecure;
    }
    else if(!strcmp("write", keyCmd))
    {
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
    else if(!strcmp("read", keyCmd))
    {
        const char* keyName = subCmd_argv[1];
        const int cswBufLen = CMD_BUFF_SIZE - sizeof("success") + 1;
        unsigned char* keyValBuf = (unsigned char*)info + CMD_BUFF_SIZE - cswBufLen;

        if (subCmd_argc < 2) {
            sprintf(info, "failed: %s %s need a keyName\n", argv[0], argv[1]);
            DWN_ERR(info);
            return __LINE__;
        }

        sprintf(info, "keyman read %s 0x%p str", keyName, keyValBuf);
        rcode = run_command(info, 0);
        if (!rcode)
            sprintf(info, "success:%s=[%s]", keyName, getenv(keyName));
        else
            sprintf(info, "failed in read key");
    }
    else if(!strcmp("get_len", keyCmd))
    {
        ssize_t keySz       = 0;
        const char* queryKey = subCmd_argv[1];

        rcode = key_manage_query_size(queryKey,&keySz);
        if (rcode) {
            sprintf(info, "failed in query key size, rcode %d\n", rcode);
            DWN_ERR(info);
            return __LINE__;
        }
        sprintf(info, "success%zd\n", keySz);
        rcode = !keySz;
    }
    else{
        sprintf(info, "failed:Error keyCmd[%s]\n", keyCmd);
        DWN_ERR(info);
        rcode = __LINE__;
    }

    DWN_DBG("rcode 0x%x\n", rcode);
    return rcode;
}

