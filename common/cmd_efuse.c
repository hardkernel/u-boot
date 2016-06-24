
/*
 * common/cmd_efuse.c
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
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <asm/arch/efuse.h>
#include <asm/arch/bl31_apis.h>

#define CMD_EFUSE_WRITE            0
#define CMD_EFUSE_READ             1
#define CMD_EFUSE_SECURE_BOOT_SET  6
#define CMD_EFUSE_PASSWORD_SET     7
#define CMD_EFUSE_CUSTOMER_ID_SET  8

#define CMD_EFUSE_AMLOGIC_SET      20


int cmd_efuse(int argc, char * const argv[], char *buf)
{
	int i, action = -1;
	uint32_t offset;
	uint32_t size, max_size;
	char *end;
	char *s;
	int ret;
	long lAddr1, lAddr2;

	if (strncmp(argv[1], "read", 4) == 0) {
		action = CMD_EFUSE_READ;
	} else if (strncmp(argv[1], "write", 5) == 0) {
		action = CMD_EFUSE_WRITE;
	} else if (strncmp(argv[1], "secure_boot_set", 15) == 0) {
		action = CMD_EFUSE_SECURE_BOOT_SET;
		goto efuse_action;
	} else if (strncmp(argv[1], "password_set", 12) == 0) {
		action = CMD_EFUSE_PASSWORD_SET;
		goto efuse_action;
	} else if (strncmp(argv[1], "customer_id_set", 15) == 0) {
		action = CMD_EFUSE_CUSTOMER_ID_SET;
		goto efuse_action;
	} else if (strncmp(argv[1], "amlogic_set", 11) == 0) {
		action = CMD_EFUSE_AMLOGIC_SET;
		goto efuse_action;
	} else{
		printf("%s arg error\n", argv[1]);
		return CMD_RET_USAGE;
	}

	if (argc < 4)
		return CMD_RET_USAGE;
	/*check efuse user data max size*/
	offset = simple_strtoul(argv[2], &end, 16);
	size = simple_strtoul(argv[3], &end, 16);
	printf("%s: offset is %d  size is  %d\n", __func__, offset, size);
	max_size = efuse_get_max();
	if (!size) {
		printf("\n error: size is zero!!!\n");
		return -1;
	}
	if (offset > max_size) {
		printf("\n error: offset is too large!!!\n");
		printf("\n offset should be less than %d!\n", max_size);
		return -1;
	}
	if (offset+size > max_size) {
		printf("\n error: offset + size is too large!!!\n");
		printf("\n offset + size should be less than %d!\n", max_size);
		return -1;
	}

efuse_action:

	/* efuse read */
	if (action == CMD_EFUSE_READ) {
		memset(buf, 0, size);
		ret = efuse_read_usr(buf, size, (loff_t *)&offset);
		if (ret == -1) {
			printf("ERROR: efuse read user data fail!\n");
			return -1;
		}

		if (ret != size)
			printf("ERROR: read %d byte(s) not %d byte(s) data\n",
			       ret, size);
		printf("efuse read data");
		for (i = 0; i < size; i++) {
			if (i%16 == 0)
				printf("\n");
			printf(":%02x", buf[i]);
		}
		printf("\n");
	}

	/* efuse write */
	else if (action == CMD_EFUSE_WRITE) {
		if (argc < 5) {
			printf("arg count error\n");
			return CMD_RET_USAGE;
		}
		memset(buf, 0, size);

		s = argv[4];
		memcpy(buf, s, strlen(s));
		if (efuse_write_usr(buf, size, (loff_t *)&offset) < 0) {
			printf("error: efuse write fail.\n");
			return -1;
		} else {
			printf("%s written done.\n", __func__);
		}
	} else if (CMD_EFUSE_SECURE_BOOT_SET == action) {
		/*efuse secure_boot_set*/

		lAddr1 = GXB_IMG_LOAD_ADDR;

		if (argc > 2)
			lAddr1 = simple_strtoul(argv[2], &end, 16);

		lAddr2 = get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
		memcpy((void *)lAddr2, (void *)lAddr1, GXB_EFUSE_PATTERN_SIZE);
		flush_cache(lAddr2,GXB_EFUSE_PATTERN_SIZE);

		ret = aml_sec_boot_check(AML_D_P_W_EFUSE_SECURE_BOOT, lAddr2,
			GXB_EFUSE_PATTERN_SIZE, 0);

		if (ret)
			printf("aml log : Secure boot EFUSE pattern programming fail [%d]!\n",
			       ret);
		else
			printf("aml log : Secure boot EFUSE pattern programming success!\n");

		return ret;
	} else if (CMD_EFUSE_AMLOGIC_SET == action) {
		/*efuse amlogic_set*/

		lAddr1 = GXB_IMG_LOAD_ADDR;

		if (argc > 2)
			lAddr1 = simple_strtoul(argv[2], &end, 16);

		lAddr2 = get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
		memcpy((void *)lAddr2, (void *)lAddr1, GXB_EFUSE_PATTERN_SIZE);
		flush_cache(lAddr2,GXB_EFUSE_PATTERN_SIZE);

		ret = aml_sec_boot_check(AML_D_P_W_EFUSE_AMLOGIC, lAddr2,
			GXB_EFUSE_PATTERN_SIZE, 0);

		if (ret)
			printf("aml log : Amlogic EFUSE pattern programming fail [%d]!\n",
			       ret);
		else
			printf("aml log : Amlogic EFUSE pattern programming success!\n");

		return ret;
	} else if(CMD_EFUSE_PASSWORD_SET == action)	{
		/*efuse password_set*/

		lAddr1 = GXB_IMG_LOAD_ADDR;

		if (argc > 2)
			lAddr1 = simple_strtoul(argv[2], &end, 16);

		lAddr2 = get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
		memcpy((void *)lAddr2, (void *)lAddr1, GXB_EFUSE_PATTERN_SIZE);
		flush_cache(lAddr2,GXB_EFUSE_PATTERN_SIZE);

		ret = aml_sec_boot_check(AML_D_P_W_EFUSE_PASSWORD, lAddr2,
			GXB_EFUSE_PATTERN_SIZE, 0);

		if (ret)
			printf("aml log : Password EFUSE pattern programming fail [%d]!\n",
			       ret);
		else
			printf("aml log : Password EFUSE pattern programming success!\n");

		return ret;
	}else if(CMD_EFUSE_CUSTOMER_ID_SET == action)	{
		/*efuse customer_id_set*/

		lAddr1 = GXB_IMG_LOAD_ADDR;

		if (argc > 2)
			lAddr1 = simple_strtoul(argv[2], &end, 16);

		lAddr2 = get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
		memcpy((void *)lAddr2, (void *)lAddr1, GXB_EFUSE_PATTERN_SIZE);
		flush_cache(lAddr2,GXB_EFUSE_PATTERN_SIZE);

		ret = aml_sec_boot_check(AML_D_P_W_EFUSE_CUSTOMER_ID, lAddr2,
			GXB_EFUSE_PATTERN_SIZE, 0);

		if (ret)
			printf("aml log : Customer ID EFUSE pattern programming fail [%d]!\n",
			       ret);
		else
			printf("aml log : Customer ID EFUSE pattern programming success!\n");

		return ret;
	}
	else
	{
		printf("arg error\n");
		return CMD_RET_USAGE;
	}

	return 0;
}


int do_efuse(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char buf[EFUSE_BYTES];

	memset(buf, 0, sizeof(buf));

	if (argc < 2)
		return CMD_RET_USAGE;

	return cmd_efuse(argc, argv, buf);
}

static char efuse_help_text[] =
	"[read/write offset size [data]]\n"
	"  [read/wirte]  - read or write 'size' data from\n"
	"                  'offset' from efuse user data ;\n"
	"  [offset]      - the offset byte from the beginning\n"
	"                  of efuse user data zone;\n"
	"  [size]        - data size\n"
	"  [data]        - the optional argument for 'write',\n"
	"                  data is treated as characters\n"
	"  examples: efuse write 0xc 0xd abcdABCD1234\n";

U_BOOT_CMD(
	efuse,	5,	1,	do_efuse,
	"efuse read/write data commands", efuse_help_text
);


/****************************************************/
