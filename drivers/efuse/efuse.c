
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

ssize_t efuse_read(char *buf, size_t count, loff_t *ppos)
{
	unsigned pos = *ppos;

	struct efuse_hal_api_arg arg;
	unsigned int retcnt;
	int ret;
	arg.cmd = EFUSE_HAL_API_READ;
	arg.offset = pos;
	arg.size = count;
	arg.buffer_phy = (unsigned long)buf;
	arg.retcnt_phy = (unsigned long)&retcnt;
	ret = meson_trustzone_efuse(&arg);
	if (ret == 0) {
		*ppos += retcnt;
		return retcnt;
	} else{
		return ret;
	}
}

ssize_t efuse_write(const char *buf, size_t count, loff_t *ppos)
{
	unsigned pos = *ppos;

	if ((pos&0xffff) >= EFUSE_BYTES)
		return 0;	/* Past EOF */
	if (count > EFUSE_BYTES - pos)
		count = EFUSE_BYTES - pos;
	if (count > EFUSE_BYTES)
		return -1;

	struct efuse_hal_api_arg arg;
	unsigned int retcnt;
	arg.cmd = EFUSE_HAL_API_WRITE;
	arg.offset = pos;
	arg.size = count;
	arg.buffer_phy = (unsigned long)buf;
	arg.retcnt_phy = (unsigned long)&retcnt;
	int ret;
	ret = meson_trustzone_efuse(&arg);
	if (ret == 0) {
		*ppos = retcnt;
		return retcnt;
	} else{
		return ret;
	}
}

int efuse_read_usr(char *buf, size_t count, loff_t *ppos)
{
	char data[EFUSE_BYTES];
	char *pdata = NULL;
	int ret;
	loff_t pos;

	memset(data, 0, count);

	pdata = data;
	pos = *ppos;
	ret = efuse_read(pdata, count, (loff_t *)&pos);

	memcpy(buf, data, count);

	return ret;
}

int efuse_write_usr(char *buf, size_t count, loff_t *ppos)
{
	char data[EFUSE_BYTES];
	char *pdata = NULL;
	char *penc = NULL;
	int ret;
	loff_t pos;

	if (count == 0) {
		printf("data length: 0 is error!\n");
		return -1;
	}

	memset(data, 0, EFUSE_BYTES);
	memset(efuse_buf, 0, EFUSE_BYTES);

	memcpy(data, buf, count);
	pdata = data;
	penc = efuse_buf;

	memcpy(penc, pdata, count);
	pos = *ppos;

	ret = efuse_write(efuse_buf, count, (loff_t *)&pos);

	return ret;
}

uint32_t efuse_get_max(void)
{
	struct efuse_hal_api_arg arg;
	int ret;
	arg.cmd = EFUSE_HAL_API_USER_MAX;

	ret = meson_trustzone_efuse_get_max(&arg);
	if (ret == 0) {
		printf("ERROR: can not get efuse user max bytes!!!\n");
		return -1;
	} else{
		return ret;
	}
}
