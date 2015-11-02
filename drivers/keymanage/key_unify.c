/*
 * Unify interfaces for read/write nandkey/emmckey/efuse key
 */
#include "key_manage_i.h"
#include <amlogic/keyunify.h>
#include <linux/ctype.h>

#define KEY_NO_EXIST	0
#define KEY_BURNED		1

#define KEY_READ_PERMIT		10
#define KEY_READ_PROHIBIT	11

#define KEY_WRITE_MASK		(0x0f<<4)
#define KEY_WRITE_PERMIT	(10<<4)
#define KEY_WRITE_PROHIBIT	(11<<4)

typedef struct _devKeyOps{
    int     (*pInitFunc) (const char* buf, int len);
    int     (*pUninitFunc)(void);
    int     (*pWriteFunc)(const char *keyname, const void* keydata, unsigned int datalen);
    ssize_t (*pGetSize)(const char* keyname);
    int     (*pKeyExist)(const char* keyname);
    int     (*pKeyCanRead)(const char* keyname);
    int     (*pReadFunc)(const char* keyname, void* dataBuf,  unsigned buflen);

    //Fields:
    int     can_overwrite;//is OTP

}KmDevKeyOps;

static KmDevKeyOps _SecukeyOps = {
        .pInitFunc           = keymanage_securekey_init        ,
        .pUninitFunc         = keymanage_securekey_exit        ,
        .pWriteFunc          = keymanage_secukey_write         ,
        .pGetSize            = keymanage_secukey_size          ,
        .pKeyExist           = keymanage_secukey_exist         ,
        .pKeyCanRead         = keymanage_secukey_can_read      ,
        .pReadFunc           = keymanage_secukey_read          ,

        .can_overwrite       = 1                               ,
};

static KmDevKeyOps _efuseKeyOps = {
        .pInitFunc           = keymanage_efuse_init            ,
        .pUninitFunc         = keymange_efuse_exit             ,
        .pWriteFunc          = keymanage_efuse_write           ,
        .pGetSize            = keymanage_efuse_size            ,
        .pKeyExist           = keymanage_efuse_exist           ,
        .pKeyCanRead         = keymanage_efuse_query_can_read  ,
        .pReadFunc           = keymanage_efuse_read            ,

        .can_overwrite       = 0                               ,
};

#define _KM_DEV_INDEX_SECUREKEY         0
#define _KM_DEV_INDEX_EFUSE             1

static KmDevKeyOps* _km_devKeyOpsArr[] = {
            [_KM_DEV_INDEX_SECUREKEY]      = &_SecukeyOps,
            [_KM_DEV_INDEX_EFUSE]          = &_efuseKeyOps,
};

static const int _KM_DEVCNT = sizeof(_km_devKeyOpsArr) / sizeof(_km_devKeyOpsArr[0]);

int _keyman_hex_ascii_to_buf(const char* input, char* buf, const unsigned bufSz)
{
    int ret = 0;
    const char* tmpStr = input;
    const unsigned inputLen = strlen(input);
    int i = 0;

    if (!inputLen) {
        KM_ERR("err input len 0\n");
        return __LINE__;
    }
    if (inputLen & 1) {
        KM_ERR("inputLen %d not even\n", inputLen);
        return __LINE__;
    }
    if (bufSz * 2 > inputLen) {
        KM_ERR("bufSz %d not enough\n", bufSz);
        return __LINE__;
    }
    for (tmpStr = input; *tmpStr; ++tmpStr)
    {
        char c = *tmpStr;
        ret = isxdigit(c);
        if (!ret) {
            KM_ERR("input(%s) contain non xdigit, c=%c\n", input, c);
            return __LINE__;
        }
    }

    for (i = 0; i < inputLen; i += 2)
    {
        char tmpByte[8];
        tmpByte[2] = '\0';
        tmpByte[0] = input[i];
        tmpByte[1] = input[i + 1];

        const unsigned val = simple_strtoul(tmpByte, NULL, 16);
        if (val > 0xff) {
            KM_ERR("Exception: val 0x%x > 0xff\n", val);
            return __LINE__;
        }
        buf[i>>1] = val;
    }

    return 0;
}

int _keyman_buf_to_hex_ascii(const uint8_t* pdata, const unsigned dataLen, char* fmtStr/*pr if NULL*/)
{
    if (NULL == fmtStr) //Only print
    {
        int i = 0;
        KM_MSG("key len is %d, hex value in hexdump:", dataLen);
        for (; i < dataLen; ++i, ++pdata)
        {
            if (!(i & 0xf)) printf("\n\t[0x%04x]:\t\t", i);
            printf("%02x ", *pdata);
        }
        printf("\n");
    }
    else
    {
        int i = 0;

        *fmtStr = '\0';
        for (; i < dataLen; ++i, ++pdata)
        {
            sprintf(fmtStr, "%s%02x", fmtStr, *pdata);
        }
    }

    return 0;
}

/*
 * function name: key_unify_init
 * buf : input
 * len  : > 0
 * return : >=0: ok, other: fail
 * */
int key_unify_init(const char* seedStr, const char* dtbLoadaddr)
{
    int err=EINVAL;
    int i;
    uint64_t seedNum = 0;

    if (!dtbLoadaddr)
    {
        dtbLoadaddr = getenv("dtb_mem_addr");
        if (!dtbLoadaddr) {
            KM_ERR("env dtb_mem_addr not defined, pls set ir or asign dtbLoadaddr\n");
            return __LINE__;
        }
    }
    dtbLoadaddr = (char*)simple_strtoul(dtbLoadaddr, NULL, 0) ;

    if (keymanage_dts_parse(dtbLoadaddr)) {
        KM_DBG("Fail parse /unifykey at addr[0x%p]\n", dtbLoadaddr);
        return err;
    }

    seedNum = simple_strtoull(seedStr, NULL, 0);
    if (!seedNum) {
        KM_ERR("Seed is 0 err\n");
        return __LINE__;
    }
    for (i=0; i < _KM_DEVCNT; i++)
    {
        KmDevKeyOps* theDevOps = _km_devKeyOpsArr[i];
        err = theDevOps->pInitFunc((char*)&seedNum, sizeof(uint64_t)/sizeof(char));
        if (err) {
            KM_ERR("Device[%d] init failed, err=%d\n", i, err);
            return err;
        }
    }

    return 0;
}

/* function name: key_unify_uninit
 * functiion : uninit
 * return : >=0 ok, <0 fail
 * */
int key_unify_uninit(void)
{
    int err=-EINVAL;
    int i;

    for (i=0; i < _KM_DEVCNT; i++)
    {
        KmDevKeyOps* theDevOps = _km_devKeyOpsArr[i];
        err = theDevOps->pUninitFunc();
        if (err) {
            KM_ERR("device[%d] unini fail\n", i);
            /*return err;*/
        }
    }

    return 0;
}

static const KmDevKeyOps* _get_km_ops_by_name(const char* keyname)
{
    KmDevKeyOps* theDevOps  = NULL;

    //step 1: get device ops by configured key-device
    enum key_manager_dev_e theDevice = keymanage_dts_get_key_device(keyname);

    switch (theDevice)
    {
        case KEY_M_EFUSE_NORMAL:
            {
                theDevOps = _km_devKeyOpsArr[_KM_DEV_INDEX_EFUSE];
            }
            break;

        case KEY_M_NORAML_KEY:
        case KEY_M_SECURE_KEY:
            {
                theDevOps = _km_devKeyOpsArr[_KM_DEV_INDEX_SECUREKEY];
            }
            break;

        case KEY_M_UNKNOW_DEV:
        default:
            KM_ERR("key %s not know device %d\n", keyname, theDevice);
            return NULL;
    }

    return theDevOps;
}

int key_unify_query_key_has_configure(const char* keyname)
{
    return _get_km_ops_by_name(keyname) ? 1 : 0;
}

/* funtion name: key_unify_write
 * keyname : key name is ascii string
 * keydata : key data buf
 * datalen : key buf len
 * return  0: ok, -0x1fe: no space, other fail
 *
 * Step 1: Get burn target from dtb
 * Step 2: check whether can burned, OTP can't burned twice
 *          2.1)check is programmed yet, burn directly if not programmed yet.
 *          2.2)if programmed yet, check if OTP
 * Step 3: burn the key to the target
 * */
int key_unify_write(const char *keyname, const void* keydata, const unsigned datalen)
{
    int err=0;
    const KmDevKeyOps* theDevOps  = NULL;

    theDevOps = _get_km_ops_by_name(keyname);
    if (!theDevOps) {
        KM_ERR("key[%s] no cfg in dts\n", keyname);
        return __LINE__;
    }

    if (!theDevOps->can_overwrite) {
        KM_DBG("can't overwrite\n");
        int ret = theDevOps->pKeyExist(keyname);
        if (ret) {
            KM_ERR("OTP key[%s] already existed, can't program twice!\n", keyname);
            return __LINE__;
        }
    }

    err = theDevOps->pWriteFunc(keyname, keydata, datalen);

    return err;
}

/*
 *function name: key_unify_read
 * keyname : key name is ascii string
 * keydata : key data buf
 * datalen : key buf len
 * reallen : key real len
 * return : <0 fail, >=0 ok
 * */
int key_unify_read(const char *keyname, void* keydata, const unsigned bufLen)
{
    int err=0;
    const KmDevKeyOps* theDevOps  = NULL;

    theDevOps = _get_km_ops_by_name(keyname);
    if (!theDevOps) {
        KM_ERR("key[%s] no cfg in dts\n", keyname);
        return __LINE__;
    }

    int ret = theDevOps->pKeyExist(keyname);
    if (!ret) {
        KM_ERR("key[%s] not programed yet\n", keyname);
        return __LINE__;
    }

    ret = theDevOps->pKeyCanRead(keyname);
    if (!ret) {
        KM_ERR("key[%s] can't read as it's secure\n", keyname);
        return __LINE__;
    }

    const ssize_t keySz = theDevOps->pGetSize(keyname);
    if (keySz > bufLen && bufLen) {
        KM_ERR("keySz[%lu] > bufLen[%d]\n", keySz, bufLen);
        return __LINE__;
    }

    err = theDevOps->pReadFunc(keyname, keydata, keySz);

    return err;
}

int key_unify_query_size(const char* keyname, ssize_t* keysize)
{
    int ret = 0;
    const KmDevKeyOps* theDevOps  = NULL;

    theDevOps = _get_km_ops_by_name(keyname);
    if (!theDevOps) {
        KM_ERR("key[%s] not cfg in dts\n", keyname);
        return __LINE__;
    }

    ret = theDevOps->pKeyCanRead(keyname);
    if (!ret) {
        KM_ERR("key[%s] can't read as it's secure\n", keyname);
        return __LINE__;
    }

    *keysize = theDevOps->pGetSize(keyname);

    return 0;
}

int key_unify_query_exist(const char* keyname, int* exist)
{
    const KmDevKeyOps* theDevOps  = NULL;

    theDevOps = _get_km_ops_by_name (keyname) ;
    if (!theDevOps) {
        KM_ERR("key[%s] not cfg in dts\n", keyname);
        return __LINE__;
    }

    *exist = theDevOps->pKeyExist(keyname);

    return 0;
}

int key_unify_query_secure(const char* keyname, int* isSecure)
{
    const KmDevKeyOps* theDevOps  = NULL;

    theDevOps = _get_km_ops_by_name (keyname) ;
    if (!theDevOps) {
        KM_ERR("key[%s] no cfg in dts\n", keyname);
        return __LINE__;
    }

    int ret = theDevOps->pKeyExist (keyname) ;
    if (!ret) {
        KM_ERR("key[%s] not programed yet\n", keyname);
        return __LINE__;
    }

    *isSecure = !theDevOps->pKeyCanRead (keyname) ;
    if (!ret) {
        KM_ERR ("key[%s] can't read as it's secure\n", keyname) ;
        return __LINE__;
    }

    return 0;
}

int key_unify_query_canOverWrite(const char* keyname, int* canOverWrite)
{
    const KmDevKeyOps* theDevOps  = NULL;

    theDevOps = _get_km_ops_by_name(keyname);
    if (!theDevOps) {
        KM_ERR("key[%s] no cfg in dts\n", keyname);
        return __LINE__;
    }

    *canOverWrite = theDevOps->can_overwrite;
    return 0;
}

int do_keyunify (cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
    int err;
    char *cmd;
    int ret = 0;

    if (argc < 2) return CMD_RET_USAGE;

    cmd = argv[1];
    //keyman init seedNum <dtbLoadAddr>
    if (!strcmp(cmd,"init"))
    {
        if (argc < 3) {
            return CMD_RET_USAGE;
        }
        const char* seedNum     = argv[2];
        const char* dtbLoadaddr = argc > 3 ? argv[3] : NULL;
        err = key_unify_init(seedNum, dtbLoadaddr);
        return err ? CMD_RET_FAILURE : CMD_RET_SUCCESS;
    }

    //keyunify write keyname addr <size>
    //keyunify write keyname hexascii
    if (!strcmp(cmd,"write"))
    {
        if (argc < 4) return CMD_RET_USAGE;

        const char* keyname = argv[2];
        const char* keyData = (char*)simple_strtoul(argv[3], NULL, 16);
        unsigned len  = argc > 4 ? simple_strtoul(argv[4], NULL, 0) : 0;
        char*  dataBuf = NULL;

        if (argc == 4)
        {
            const char* hexascii = argv[3];

            len = strlen(hexascii) / 2;
            dataBuf = (char*)malloc(len);
            if (!dataBuf) {
                KM_ERR("Fail in malloc len %d\n", len);
                return CMD_RET_FAILURE;
            }

            err = _keyman_hex_ascii_to_buf(hexascii, dataBuf, len);
            if (err) {
                KM_ERR("Fail in decrypt hexascii to buf, err=%d\n", err);
                free(dataBuf);
                return CMD_RET_FAILURE;
            }
            keyData = dataBuf;
        }

        KM_DBG("write key[%s], addr=%p, len=%d\n", keyname, keyData, len);
        err = key_unify_write(keyname, keyData, len);
        if (err ) {
            KM_ERR("%s key write fail, err=%d\n", keyname, err);
            return CMD_RET_FAILURE;
        }
        if (dataBuf)free(dataBuf) ;

        return CMD_RET_SUCCESS;
    }

    //keyman query size/secure/exist keyname
    if (!strcmp(cmd,"query"))
    {
        if (argc < 4) return CMD_RET_USAGE;

        const char* subCmd  = argv[2];
        const char* keyname = argv[3];

        ret = CMD_RET_FAILURE;
        if (!strcmp("size", subCmd))
        {
            ssize_t keysize = 0;
            err = key_unify_query_size(keyname, &keysize);
            if (!err) {
                ret = CMD_RET_SUCCESS;
                KM_MSG("key[%s] is %u bytes\n", keyname, (unsigned)keysize);
            }
        }
        else if(!strcmp("secure", subCmd))
        {
            int isSecure = 0;

            err = key_unify_query_secure(keyname, &isSecure);
            if (!err) {
                ret = CMD_RET_SUCCESS;
                KM_MSG("key[%s] is %s Secure\n", keyname, isSecure ? "DO" : "NON");
            }
        }
        else if(!strcmp("exist", subCmd))
        {
            int exist = 0;
            err = key_unify_query_exist(keyname, &exist);
            if (!err) {
                ret = CMD_RET_SUCCESS;
                KM_MSG("key[%s] is %s existed\n", keyname, exist ? "DO" : "NON");
            }
        }
        else{
            return CMD_RET_USAGE;
        }

        return ret;
    }

    //keyman read keyname memAddr
    if (!strcmp(cmd,"read"))
    {
        if (argc < 4) return CMD_RET_USAGE;

        const char* keyname = argv[2];
        void* keydata = (void*)simple_strtoul(argv[3], NULL, 16);

        ssize_t keysize = 0;
        err = key_unify_query_size(keyname, &keysize);
        if (err) {
            KM_ERR("Fail in get keysz, err=%d\n", err);
            return __LINE__;
        }

        err = key_unify_read(keyname, keydata, (unsigned)keysize);
        if (err) {
            KM_ERR("%s key read fail\n", keyname);
            return CMD_RET_FAILURE;
        }
        _keyman_buf_to_hex_ascii(keydata, (unsigned)keysize, NULL);

        return err;
    }

    if (!strcmp(cmd,"uninit"))
    {
        return key_unify_uninit();
    }

    return CMD_RET_USAGE;
}

U_BOOT_CMD(
        keyunify, CONFIG_SYS_MAXARGS, 1, do_keyunify,
        "key unify sub-system",
        "init seedNum [dtbAddr] --init the drivers\n"
        "keyunify uninit - init key in device\n"
        "keyunify write keyname data <len>  ---- wirte key data. len non-exist if data is ascii str\n"
        "keyunify read keyname data-addr <len> \n"
);


#if !defined(CONFIG_AML_SECURITY_KEY)
int keymanage_securekey_init(const char* buf, int len) { return -EINVAL; }
int keymanage_securekey_exit(void){ return -EINVAL; }
int keymanage_secukey_write(const char *keyname, const void* keydata, unsigned int datalen){ return -EINVAL; }
ssize_t keymanage_secukey_size(const char* keyname){ return 0; }
int keymanage_secukey_exist(const char* keyname){ return 0; }
int keymanage_secukey_can_read(const char* keyname){ return 0; }
int keymanage_secukey_read(const char* keyname, void* dataBuf,  unsigned buflen){ return -EINVAL; }
#endif// #if CONFIG_AML_SECURITY_KEY

#if !defined(CONFIG_EFUSE)
int keymanage_efuse_init(const char *buf, int len) { return -EINVAL; }
int keymange_efuse_exit(void) {return -EINVAL;}
int keymanage_efuse_write(const char *keyname, const void* keydata, unsigned int datalen) { return -EINVAL; }
int keymanage_efuse_exist(const char* keyname) { return -EINVAL; }
ssize_t keymanage_efuse_size(const char* keyname) { return 0; }
int keymanage_efuse_query_can_read(const char* keyname){ return 0; }
int keymanage_efuse_read(const char *keyname, void* dataBuf, const unsigned bufsz) { return -EINVAL; }
int keymanage_efuse_query_is_burned(const char* keyname) { return -EINVAL; }
int keymanage_efuse_query_can_read(const char* keyname) { return -EINVAL; }
#endif// #ifdef CONFIG_EFUSE

#if !defined(CONFIG_OF_LIBFDT)
int keymanage_dts_parse(const void* dt_addr){ return -EINVAL; }
enum key_manager_df_e keymanage_dts_get_key_fmt(const char *keyname){ return -EINVAL; }
enum key_manager_dev_e keymanage_dts_get_key_device(const char *keyname){ return -EINVAL; }
char unifykey_get_efuse_version(void) { return -1; }
#endif//#ifdef CONFIG_OF_LIBFDT


