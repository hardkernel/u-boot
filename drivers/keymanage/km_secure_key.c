/*
 * \file        km_secure_key.c
 * \brief       secure storage key ops for key manage
 *
 * \version     1.0.0
 * \date        15/06/30
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#include "key_manage_i.h"
#include <amlogic/amlkey_if.h>
#include <u-boot/sha256.h>

int keymanage_securekey_init(const char* buf, int len)
{
	return amlkey_init((uint8_t*)buf, len);	//confirm
}

int keymanage_securekey_exit(void)
{
    return 0;
}

int keymanage_secukey_write(const char *keyname, const void* keydata, unsigned int datalen)
{
    int ret = 0;
    uint8_t origSum[SHA256_SUM_LEN];
    const int isSecure =  ( KEY_M_SECURE_KEY == keymanage_dts_get_key_device(keyname) ) ? 1 : 0;
    const int isEncrypt= strlen(keymanage_dts_get_enc_type(keyname)) ? 1 : 0;
    const unsigned int keyAttr = ( isSecure << 0 ) | ( isEncrypt << 8 );
    ssize_t writenLen = 0;

    if (isSecure)
    {
        sha256_context ctx;
        sha256_starts(&ctx);
        sha256_update(&ctx, keydata, datalen);
        sha256_finish(&ctx, origSum);
    }

    KM_MSG("isEncrypt=%s\n", keymanage_dts_get_enc_type(keyname));
    KM_DBG("%s, keyname=%s, keydata=%p, datalen=%d, isSecure=%d\n", __func__, keyname, keydata, datalen, isSecure);
    KM_MSG("keyAttr is 0x%08X\n", keyAttr);
    writenLen = amlkey_write((uint8_t*)keyname, (uint8_t*)keydata, datalen, keyAttr);
    if (writenLen != datalen) {
        KM_ERR("Want to write %u bytes, but only %zd Bytes\n", datalen, writenLen);
        return __LINE__;
    }

    if (isSecure)
    {
        uint8_t genSum[SHA256_SUM_LEN];

        ret = amlkey_hash_4_secure((uint8_t*)keyname, genSum);
        if (ret) {
            KM_ERR("Failed when gen hash for secure key[%s], ret=%d\n", keyname, ret);
            return __LINE__;
        }

        ret = memcmp(origSum, genSum, SHA256_SUM_LEN);
        if (ret)
        {
            int index = 0;
            char origSum_str[SHA256_SUM_LEN * 2 + 2];
            char genSum_str[SHA256_SUM_LEN * 2 + 2];

            origSum_str[0] = genSum_str[0] = '\0';
            for (index = 0; index < SHA256_SUM_LEN; ++index) {

                sprintf(origSum_str, "%s%02x", origSum_str, origSum[index]);
                sprintf(genSum_str, "%s%02x", genSum_str, genSum[index]);
            }

            KM_ERR("Failed in check hash, origSum[%s] != genSum[%s]\n", origSum_str, genSum_str);
            return __LINE__;
        }
        KM_MSG("OK in check sha1256 in burn key[%s]\n", keyname);
    }

    return ret;
}

ssize_t keymanage_secukey_size(const char* keyname)
{
	return amlkey_size((uint8_t*)keyname);	//actully size
}

int keymanage_secukey_exist(const char* keyname)
{
	return amlkey_isexsit((uint8_t*)keyname);	//exsit 1, non 0
}

int keymanage_secukey_can_read(const char* keyname)
{
	return !amlkey_issecure((uint8_t*)keyname);	//secure 1, non 0
}

int keymanage_secukey_read(const char* keyname, void* databuf,  unsigned buflen)
{
    int ret = 0;

    ret = keymanage_secukey_can_read(keyname);
    if (!ret) {
        KM_ERR("key[%s] can't read, is configured secured?\n", keyname);
        return __LINE__;
    }

	const ssize_t readLen = amlkey_read((uint8_t*)keyname, (uint8_t*)databuf, buflen);
    if (readLen != buflen) {
        KM_ERR("key[%s], want read %u Bytes, but %zd bytes\n", keyname, buflen, readLen);
        return __LINE__;
    }

    return 0;
}

