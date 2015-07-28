/*
 * \file        efuse_usr_space_api.c
 * \brief       support read/write user space using keyname mode
 *              mapping keyname to offset by looking /efusekey in dtb
 *
 * \version     1.0.0
 * \date        15/07/14
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#include <config.h>
#include <common.h>
#include <command.h>
#include <malloc.h>
#include <linux/ctype.h>

#define EFUSE_DBG(fmt...)   //printf("[EFUSE_DBG]"fmt)
#define EFUSE_MSG(fmt...)   printf("[EFUSE_MSG]"fmt)
#define EFUSE_ERR(fmt...)   printf("[EFUSE_ERR]f(%s)L%d:", __func__, __LINE__),printf(fmt)

extern uint32_t efuse_get_max(void);
extern int efuse_read_usr(char *buf, size_t count, loff_t *ppos);
extern int efuse_write_usr(char *buf, size_t count, loff_t *ppos);

struct efusekey_info{
	char keyname[32];
	unsigned offset;
	unsigned size;
};

static struct _efuseCfgInf{
    unsigned                initMaigc;//magic to indicate whether inited
    unsigned                totalCfgKeyNums;
    struct efusekey_info *  pKeyInf;
}
_efuseKeyInfos = {.totalCfgKeyNums = 0, .pKeyInf = NULL};

int efuse_usr_api_init_dtb(const char*  dt_addr)
{
	int nodeoffset, poffset = 0;
	char propname[32];
	const void* phandle;
	int ret;
	int index;
	uint32_t max_size;
    unsigned efusekeynum = 0;
    struct efusekey_info * efusekey_infos = NULL;

	ret = fdt_check_header(dt_addr);
	if (ret < 0) {
		EFUSE_ERR("fdt check failed [%s]\n", fdt_strerror(ret));
        return __LINE__;
    }
    _efuseKeyInfos.initMaigc = 0;

	nodeoffset = fdt_path_offset(dt_addr, "/efusekey");
	if (nodeoffset < 0) {
		EFUSE_ERR("not find /efusekey node [%s].\n", fdt_strerror(nodeoffset));
        return __LINE__;
    }

	phandle = fdt_getprop(dt_addr, nodeoffset, "keynum", NULL);
	efusekeynum = be32_to_cpup((u32 *)phandle);
	EFUSE_MSG("keynum is %x\n", efusekeynum);

    if (efusekey_infos) free(efusekey_infos) ;
    efusekey_infos = (struct efusekey_info *)malloc(sizeof (struct efusekey_info) *efusekeynum);
    if (!efusekey_infos) {
        EFUSE_ERR("malloc err\n");
        return __LINE__;
    }

	max_size = efuse_get_max();

	for (index = 0; index < efusekeynum; index++)
    {
        struct efusekey_info* theKeyInf = efusekey_infos + index;
		sprintf(propname, "key%d", index);
		/* printf("%s: propname: %s\n",__func__,propname); */
		phandle = fdt_getprop(dt_addr, nodeoffset, propname, NULL);
		if (!phandle) {
			EFUSE_ERR("don't find  match %s\n", propname);
			goto err;
		}
        poffset = fdt_node_offset_by_phandle(dt_addr,
                be32_to_cpup((u32 *)phandle));
        if (!poffset) {
            EFUSE_ERR("can't find device node for key[%s]\n", propname);
            goto err;
        }


		phandle = fdt_getprop(dt_addr, poffset, "keyname", NULL);
        if (!phandle) {
            EFUSE_ERR("Can't find keyname for key[%d]\n", index);
            goto err;
        }
		strcpy(theKeyInf->keyname, phandle);

		phandle = fdt_getprop(dt_addr, poffset, "offset", NULL);
        if (!phandle) {
            EFUSE_ERR("Can't find offset for key[%s]\n", theKeyInf->keyname);
            goto err;
        }
		theKeyInf->offset = be32_to_cpup((u32 *)phandle);

		phandle = fdt_getprop(dt_addr, poffset, "size", NULL);
        if (!phandle) {
            EFUSE_ERR("Can't find size for key[%s]\n", theKeyInf->keyname);
            goto err;
        }
		theKeyInf->size = be32_to_cpup((u32 *)phandle);

		EFUSE_DBG("key[%02d] name=%12s, offset=0x%04x, size=0x%04x\n",
                index, theKeyInf->keyname, theKeyInf->offset, theKeyInf->size);
        if (theKeyInf->offset + theKeyInf->size > max_size) {
            EFUSE_ERR("\n offset (0x%x) + size (0x%x) > max [0x%x]!\n", theKeyInf->offset, theKeyInf->size, max_size);
            return __LINE__;
        }
	}

    _efuseKeyInfos.totalCfgKeyNums = efusekeynum;
    _efuseKeyInfos.pKeyInf         = efusekey_infos;
    EFUSE_DBG("%s success!\n", __func__);
    _efuseKeyInfos.initMaigc = 0xee;
	return 0;

err:
	free(efusekey_infos);
	EFUSE_ERR("%s error!\n", __func__);
	return -1;
}

static int _get_cfg_key_inf_byname(const char* keyname, const struct efusekey_info ** pKeyInf)
{
    int index = 0;
    struct efusekey_info* theKeyInf = _efuseKeyInfos.pKeyInf;
    int ret = 0;

    if (0xee != _efuseKeyInfos.initMaigc) {
        EFUSE_ERR("Pls init first.\n");
        return __LINE__;
    }
    for (; index < _efuseKeyInfos.totalCfgKeyNums; ++index, ++theKeyInf)
    {
        const char* theKeyname = theKeyInf->keyname;
        ret = strcmp(theKeyname, keyname);
        if (ret) continue;

        *pKeyInf = theKeyInf;
        return 0;
    }

    EFUSE_ERR("efuse keyname(%s) not configured\n", keyname);
    return __LINE__;//Not found the matched name
}

int efuse_usr_api_get_cfg_key_size(const char* keyname, unsigned* pSz)
{
    int ret = 0;
    const struct efusekey_info* theCfgKeyInf = NULL;

    ret = _get_cfg_key_inf_byname(keyname, &theCfgKeyInf);
    if (ret) {
        EFUSE_ERR("not name cfg in dts.\n");
        return __LINE__;
    }

    *pSz = theCfgKeyInf->size;
    return 0;
}

int efuse_usr_api_write_key(const char* keyname, const void* keydata, const unsigned dataSz)
{
    int ret = 0;
    const struct efusekey_info* theCfgKeyInf = NULL;

    ret = _get_cfg_key_inf_byname(keyname, &theCfgKeyInf);
    if (ret) {
        EFUSE_ERR("not name cfg in dts.\n");
        return __LINE__;
    }
    if (dataSz != theCfgKeyInf->size) {
        EFUSE_ERR("dataSz 0x%x != cfg size 0x%x\n", dataSz, theCfgKeyInf->size);
        return __LINE__;
    }

    ret = efuse_write_usr((char*)keydata, theCfgKeyInf->size, (loff_t*)&theCfgKeyInf->offset);
    if (ret < 0) {
        EFUSE_ERR("error: efuse write fail.\n");
        return __LINE__;
    }

    return 0;
}

//usrefuse read mac $loadaddr (size)
int efuse_usr_api_read_key(const char* keyname, void* databuf, const unsigned bufSz)
{
    int ret = 0;
    const struct efusekey_info* theCfgKeyInf = NULL;
    loff_t offset = 0;

    ret = _get_cfg_key_inf_byname(keyname, &theCfgKeyInf);
    if (ret) {
        EFUSE_ERR("not name cfg in dts.\n");
        return __LINE__;
    }
    const unsigned cfgCnt = theCfgKeyInf->size;
    if (cfgCnt > bufSz && bufSz) {
        EFUSE_ERR("cfg size 0x%x > bufsz 0x%x\n", cfgCnt, bufSz);
        return __LINE__;
    }
    EFUSE_DBG("keyname=%s, databuf=%p, bufSz=%d, cfgCnt=%u\n", keyname, databuf, bufSz, cfgCnt);

    offset = theCfgKeyInf->offset;
    memset(databuf, cfgCnt, 0);
    ret = efuse_read_usr((char*)databuf, cfgCnt, &offset);
    if (ret == -1) {
        EFUSE_ERR("ERROR: efuse read user data fail!, size=%u, offset=%llu\n", cfgCnt, offset);
        return __LINE__;
    }

    if (ret != cfgCnt) {
        EFUSE_ERR("ERROR: read %d byte(s) not wanted %d byte(s) data\n", ret, cfgCnt);
        return __LINE__;
    }

    return 0;
}

static int hex_ascii_to_buf(const char* input, uint8_t* buf, const unsigned bufSz)
{
    int ret = 0;
    const char* tmpStr = input;
    const unsigned inputLen = strlen(input);
    int i = 0;

    if (!inputLen) {
        EFUSE_ERR("err input len 0\n");
        return __LINE__;
    }
    if ( ((inputLen>>1)<<1) != inputLen ) {
        EFUSE_ERR("inputLen %d not even\n", inputLen);
        return __LINE__;
    }
    if (bufSz * 2 > inputLen) {
        EFUSE_ERR("bufSz %d not enough\n", bufSz);
        return __LINE__;
    }
    for (tmpStr = input; *tmpStr; ++tmpStr)
    {
        char c = *tmpStr;
        ret = isxdigit(c);
        if (!ret) {
            EFUSE_ERR("input(%s) contain non xdigit, c=%c\n", input, c);
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
            EFUSE_ERR("Exception: val 0x%x > 0xff\n", val);
            return __LINE__;
        }
        buf[i>>1] = val;
    }

    return 0;
}

static int do_usr_efuse_api(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
    int ret = 0;
    const char* subcmd = argv[1];
    if (argc < 2) return CMD_RET_USAGE;

    if (!strcmp("init", subcmd))
    {
        const char* dtbLoadAddr = NULL;
        if (argc > 2)
        {
            dtbLoadAddr = (char*)simple_strtoul(argv[2], NULL, 0);
        }
        else
        {
            dtbLoadAddr = getenv("dtb_mem_addr");
            if (!dtbLoadAddr) {
                setenv("dtb_mem_addr", simple_itoa(CONFIG_SYS_SDRAM_BASE + (16U<<20)));
            }
            dtbLoadAddr = (char*)simple_strtoul(dtbLoadAddr, NULL, 0);
        }
        ret = efuse_usr_api_init_dtb(dtbLoadAddr);
    }
    else if(!strcmp("size", subcmd))
    {
        const char* keyname = argv[2];
        unsigned keysize = argc > 3 ? simple_strtoul(argv[3], NULL, 0) : 0;

        ret = efuse_usr_api_get_cfg_key_size(keyname, &keysize);
        EFUSE_MSG("keysize=%d\n", keysize);
    }
    else if(!strcmp("read", subcmd))
    {
        if (argc < 4) return CMD_RET_USAGE;
        const char* keyname = argv[2];
        char* databuf = (char*)simple_strtoul(argv[3], NULL, 16);
        unsigned bufSz = argc > 4 ? simple_strtoul(argv[4], NULL, 0) : 0;

        if (!bufSz)
        {
            ret =  efuse_usr_api_get_cfg_key_size(keyname, &bufSz);
            if (ret) {
                EFUSE_ERR("Fail in get sz for key[%s]\n", keyname);
                return __LINE__;
            }
        }

        ret = efuse_usr_api_read_key(keyname, databuf, bufSz);
        if (!ret)
        {
            int i = 0;
            printf("efuse read data");
            for (i = 0; i < bufSz; i++) {
                if (i%8 == 0) printf("\n[0x%02x]:", i);
                printf("%02x ", databuf[i]);
            }
            printf("\n");
        }
    }
    else if(!strcmp("write", subcmd))
    {
        if (argc < 4) return CMD_RET_USAGE;
        const char* keyname = argv[2];
        char* keydata = (char*)simple_strtoul(argv[3], NULL, 16);
        unsigned bufSz = argc > 4 ? simple_strtoul(argv[4], NULL, 0) : 0;
        uint8_t* tmpBuf = NULL;

        if (!bufSz)
        {
            const char* input = argv[3];
            bufSz = ( strlen(input) >> 1 );
            tmpBuf = malloc(bufSz);

            ret = hex_ascii_to_buf(input, tmpBuf, bufSz);
            if (ret) {
                EFUSE_ERR("Failed in change hex ascii to buf\n");
                return __LINE__;
            }
            keydata = (char*)tmpBuf;
        }
        ret = efuse_usr_api_write_key(keyname, keydata, bufSz);
        if (tmpBuf) free(tmpBuf) ;
    }

    return ret ? CMD_RET_FAILURE : CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	efuse_user,
    5,  //max argc
    1,	//repeatable
    do_usr_efuse_api,
	"efuse user space read write ops",
	"init <dtbAddr>  --- init efuse user space\n"
	"size keyname <addr>  --- get key size configured in dts\n"
	"read keyname addr <size> --- read key value to mem addr \n"
	"write --- write key value\n"
	"       efuse_user write keyname hexstring --- write key value in hex string\n"
	"       efuse_user write keyname addr size --- write key value, U need load you key value into mem addr first\n"
);

