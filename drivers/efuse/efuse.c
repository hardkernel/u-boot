
/*
 * drivers/efuse/efuse.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <config.h>
#include <common.h>
#include <command.h>
#include <asm/arch/io.h>
#include <asm/arch/efuse.h>
#include "efuse_regs.h"


char efuse_buf[EFUSE_BYTES] = {0};

extern int efuseinfo_num;
extern efuseinfo_t efuseinfo[];
extern int efuse_active_version;
extern int efuse_active_customerid;
extern pfn efuse_getinfoex;
extern pfn_byPos efuse_getinfoex_byPos;
extern int printf(const char *fmt, ...);

struct efuse_hal_api_arg;
extern int32_t meson_trustzone_efuse(struct efuse_hal_api_arg* arg);
extern int32_t meson_trustzone_efuse_get_max(struct efuse_hal_api_arg *arg);

ssize_t efuse_read(char *buf, size_t count, loff_t *ppos )
{
	unsigned pos = *ppos;

	struct efuse_hal_api_arg arg;
	unsigned int retcnt;
	int ret;
	arg.cmd=EFUSE_HAL_API_READ;
	arg.offset=pos;
	arg.size=count;
	arg.buffer_phy = (unsigned long)buf;
	arg.retcnt_phy = (unsigned long)&retcnt;
	ret = meson_trustzone_efuse(&arg);
	if (ret == 0) {
		*ppos+=retcnt;
		return retcnt;
	}
	else
		return ret;
}

ssize_t efuse_write(const char *buf, size_t count, loff_t *ppos )
{
	unsigned pos = *ppos;

	if (pos >= EFUSE_BYTES)
		return 0;	/* Past EOF */
	if (count > EFUSE_BYTES - pos)
		count = EFUSE_BYTES - pos;
	if (count > EFUSE_BYTES)
		return -1;

	struct efuse_hal_api_arg arg;
	unsigned int retcnt;
	arg.cmd=EFUSE_HAL_API_WRITE;
	arg.offset = pos;
	arg.size=count;
	arg.buffer_phy=(unsigned long)buf;
	arg.retcnt_phy=(unsigned long)&retcnt;
	int ret;
	ret = meson_trustzone_efuse(&arg);
	if (ret == 0) {
		*ppos=retcnt;
		return retcnt;
	}
	else
		return ret;
}

struct efuse_chip_identify_t{
	unsigned int chiphw_mver;
	unsigned int chiphw_subver;
	unsigned int chiphw_thirdver;
	efuse_socchip_type_e type;
};

static const struct efuse_chip_identify_t efuse_chip_hw_info[]={
	{.chiphw_mver=0x1f, .chiphw_subver=0, .chiphw_thirdver=0, .type=EFUSE_SOC_CHIP_GXBB},      //GXBB ok
};

#define EFUSE_CHIP_HW_INFO_NUM  sizeof(efuse_chip_hw_info)/sizeof(efuse_chip_hw_info[0])

efuse_socchip_type_e efuse_get_socchip_type(void)
{
	efuse_socchip_type_e type;
	type = EFUSE_SOC_CHIP_UNKNOW;
	unsigned int regval;
	int i;
	struct efuse_chip_identify_t *pinfo = (struct efuse_chip_identify_t*)&efuse_chip_hw_info[0];
	regval = READ_CBUS_REG(ASSIST_HW_REV);
	//printf("chip ASSIST_HW_REV reg:%d \n",regval);
	for (i=0;i<EFUSE_CHIP_HW_INFO_NUM;i++) {
		if (pinfo->chiphw_mver == regval) {
			type = pinfo->type;
			break;
		}
		pinfo++;
	}
	//printf("%s \n",soc_chip[type]);
	return type;
}

static int efuse_checkversion(char *buf)
{
	efuse_socchip_type_e soc_type;
	int i;
	int ver = buf[0];
	for (i=0; i<efuseinfo_num; i++) {
		if (efuseinfo[i].version == ver) {
			soc_type = efuse_get_socchip_type();
			switch (soc_type) {
				case EFUSE_SOC_CHIP_GXBB:
					if (ver != GXBB_EFUSE_VERSION_SERIALNUM_V1) {
						ver = -1;
					}
					break;
				case EFUSE_SOC_CHIP_UNKNOW:
				default:
					printf("soc is unknow\n");
					ver = -1;
					break;
			}
			return ver;
		}
	}
	return -1;
}

static int efuse_readversion(void)
{
	char ver_buf[4], buf[4];
	efuseinfo_item_t info;
	int ret;

	#if defined(CONFIG_VLSI_EMULATOR)
        efuse_active_version = 2;
	#endif //#if defined(CONFIG_VLSI_EMULATOR)

	if (efuse_active_version != -1)
		return efuse_active_version;

	//efuse_init();
	ret = efuse_set_versioninfo(&info);
	if (ret < 0) {
		return ret;
	}
	memset(ver_buf, 0, sizeof(ver_buf));
	memset(buf, 0, sizeof(buf));

	efuse_read(buf, info.enc_len, (loff_t *)(&info.offset));
	memcpy(ver_buf, buf, sizeof(buf));

	ret = efuse_checkversion(ver_buf);   //m3,m6,m8
	if ((ret > 0) && (ver_buf[0] != 0)) {
		efuse_active_version = ver_buf[0];
		return ver_buf[0];  // version right
	}
	return -1; //version err
}

static int efuse_getinfo_byPOS(unsigned pos, efuseinfo_item_t *info)
{
	int ver;
	int i;
	efuseinfo_t *vx = NULL;
	efuseinfo_item_t *item = NULL;
	int size;
	int ret = -1;

	ver = efuse_readversion();
		if (ver < 0) {
			printf("efuse version is not selected.\n");
			return -1;
		}

		for (i=0; i<efuseinfo_num; i++) {
			if (efuseinfo[i].version == ver) {
				vx = &(efuseinfo[i]);
				break;
			}
		}
		if (!vx) {
			printf("efuse version %d is not supported.\n", ver);
			return -1;
		}

		item = vx->efuseinfo_version;
		size = vx->size;
		ret = -1;
		for (i=0; i<size; i++, item++) {
			if (pos == item->offset) {
				strcpy(info->title, item->title);
				info->offset = item->offset;
				info->data_len = item->data_len;
				info->enc_len = item->enc_len;
				info->we=item->we;
				ret = 0;
				break;
			}
		}

		if (ret < 0)
			printf("POS:%d is not found.\n", pos);

		return ret;
}

int efuse_chk_written(loff_t pos, size_t count)
{
	loff_t local_pos = pos;
	int i;

	char buf[EFUSE_BYTES];
	efuseinfo_item_t info;
	unsigned enc_len ;

	if (pos < 320) {
		printf("pos is error! pos is less than 320, amlogic part can not read\n");
		return -1;
	}

	if (efuse_getinfo_byPOS(pos, &info) < 0) {
		printf("not found the position:%d.\n", (int)pos);
		return -1;
	}

	 if (count > info.data_len) {
		printf("data length: %lu is out of EFUSE layout!\n", (unsigned long)count);
		return -1;
	}
	if (count == 0) {
		printf("data length: 0 is error!\n");
		return -1;
	}

	enc_len = info.enc_len;
	if (efuse_read(buf, enc_len, &local_pos) == enc_len) {
		for (i = 0; i < enc_len; i++) {
			if (buf[i]) {
				printf("pos %lu value is %d", (size_t)(pos + i), buf[i]);
				return 1;
			}
		}
	}
	return 0;
}

int efuse_read_usr(char *buf, size_t count, loff_t *ppos)
{
	char data[EFUSE_BYTES];
	char *pdata = NULL;

	memset(data, 0, count);

	pdata = data;
	efuse_read(pdata, count, ppos);

	memcpy(buf, data, count);

	return count;
}

int efuse_write_usr(char* buf, size_t count, loff_t* ppos)
{
	char data[EFUSE_BYTES];
	char *pdata = NULL;
	char *penc = NULL;
	unsigned enc_len;
	unsigned pos = (unsigned)*ppos;
	efuseinfo_item_t info;

	if (pos < 320) {
		printf("pos is error! pos is less than 320, amlogic part can not read\n");
		return -1;
	}

	if (efuse_getinfo_byPOS(pos, &info) < 0) {
		printf("not found the position:%d.\n", pos);
		return -1;
	}
	if (count>info.data_len) {
		printf("data length: %lu is out of EFUSE layout!\n", count);
		return -1;
	}
	if (count == 0) {
		printf("data length: 0 is error!\n");
		return -1;
	}
	if (strcmp(info.title, "version") == 0) {
		if (efuse_checkversion(buf) < 0) {
			printf("efuse version NO. error\n");
			return -1;
		}
	}

	if (efuse_chk_written(pos, info.data_len)) {
		printf("error: efuse has written.\n");
		return -1;
	}

	memset(data, 0, EFUSE_BYTES);
	memset(efuse_buf, 0, EFUSE_BYTES);

	memcpy(data, buf, count);
	pdata = data;
	penc = efuse_buf;
	enc_len=info.enc_len;

	memcpy(penc, pdata, enc_len);

	efuse_write(efuse_buf, enc_len, ppos);

	return enc_len;
}

uint32_t efuse_get_max(void)
{
	struct efuse_hal_api_arg arg;
	int ret;
	arg.cmd=EFUSE_HAL_API_USER_MAX;

	ret = meson_trustzone_efuse_get_max(&arg);
	if (ret == 0) {
		printf("ERROR: can not get efuse user max bytes!!!\n");
		return -1;
	} else
		return ret;
}

int efuse_set_versioninfo(efuseinfo_item_t *info)
{
	efuse_socchip_type_e soc_type;
	int ret=-1;
	strcpy(info->title, "version");

	soc_type = efuse_get_socchip_type();
	switch (soc_type) {
		case EFUSE_SOC_CHIP_GXBB:
			info->offset = GXBB_EFUSE_VERSION_OFFSET;
			info->data_len = GXBB_EFUSE_VERSION_DATA_LEN;
			info->enc_len = GXBB_EFUSE_VERSION_ENC_LEN;
			info->we = 1;
			ret = 0;
			break;
		case EFUSE_SOC_CHIP_UNKNOW:
		default:
			printf("efuse: soc is error\n");
			ret = -1;
			break;
	}
	return ret;
}


int efuse_getinfo(char *title, efuseinfo_item_t *info)
{
	int ver;
	int i;
	efuseinfo_t *vx = NULL;
	efuseinfo_item_t *item = NULL;
	int size;
	int ret = -1;

	if (strcmp(title, "version") == 0) {
		ret = efuse_set_versioninfo(info);
		return ret;
	}

		ver = efuse_readversion();
		if (ver < 0) {
			printf("efuse version is not selected.\n");
			return -1;
		}
		for (i=0; i<efuseinfo_num; i++) {
			if (efuseinfo[i].version == ver) {
				vx = &(efuseinfo[i]);
				break;
			}
		}
		if (!vx) {
			printf("efuse version %d is not supported.\n", ver);
			return -1;
		}

		item = vx->efuseinfo_version;
		size = vx->size;
		ret = -1;
		for (i=0; i<size; i++, item++) {
			if (strcmp(item->title, title) == 0) {
				strcpy(info->title, item->title);
				info->offset = item->offset;
				info->enc_len = item->enc_len;
				info->data_len = item->data_len;
				info->we = item->we;
				ret = 0;
				break;
			}
		}

		if (ret < 0)
			printf("%s is not found.\n", title);
		return ret;
}

/* function: efuse_read_intlItem
 * intl_item: item name,name is [temperature,cvbs_trimming,temper_cvbs]
 *            [temperature: 2byte]
 *            [cvbs_trimming: 2byte]
 *            [temper_cvbs: 4byte]
 * buf:  output para
 * size: buf size
 * */
int efuse_read_intlItem(char *intl_item,char *buf,int size)
{
	efuse_socchip_type_e soc_type;
	int ret=-1;

	soc_type = efuse_get_socchip_type();
	switch (soc_type) {
		case EFUSE_SOC_CHIP_GXBB:
			/* To do*/
			break;
		case EFUSE_SOC_CHIP_UNKNOW:
		default:
			printf("%s:%d chip is unkow\n",__func__,__LINE__);
			break;
	}
	return ret;
}


