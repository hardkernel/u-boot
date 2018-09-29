 /*
  * common/cmd_hdmirx.c
  *
  * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
  * Author: hongmin hua <hongmin hua@amlogic.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the smems of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
  */

#include <common.h>
#include <command.h>
#include <malloc.h>
#include <asm/cpu_id.h>
#include <asm/arch/io.h>
#include <amlogic/aml_hdmirx.h>
#include "ini/ini_platform.h"

#define HDMIRX_VERSION "Ver 2018/09/29\n"

static int hdmirx_hpd(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	if (argc < 1)
		return cmd_usage(cmdtp);

	return CMD_RET_SUCCESS;
}

int hdmirx_read_edid(const char *filename,
					unsigned char **pedid_buf,
					int *pedid_size)
{
	int rd_cnt = 0, tmp_size = 0;
	unsigned char *tmp_buf = NULL;

	if ((filename == NULL) || (pedid_buf == NULL) || (pedid_size == NULL))
		return -1;
	if (!iniIsFileExist(filename)) {
		printf("%s, file \"%s\" is not exist!\n", __func__, filename);
		return -1;
	}

	tmp_size = iniGetFileSize(filename);
	if (tmp_size <= 0) {
		printf("%s, file \"%s\" size error!\n", __func__, filename);
		return -1;
	}
	tmp_buf = (unsigned char *)malloc(tmp_size);
	if (tmp_buf != NULL) {
		rd_cnt = iniReadFileToBuffer(filename, 0,  tmp_size, tmp_buf);
		if (rd_cnt <= 0) {
			free(tmp_buf);
				return -1;
		}
	}
	*pedid_size = tmp_size;
	*pedid_buf = tmp_buf;

	return 0;
}

static int hdmirx_edid(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int port_map;
	if (argc < 1)
		return cmd_usage(cmdtp);

	port_map = simple_strtoul(argv[1], NULL, 16);
	printf("port map %#x\n", port_map);
	port_map = simple_strtoul(argv[2], NULL, 16);
	printf("edid select %#x\n", port_map);
	printf("FILE:%s\n", argv[3]);
	printf("FILE:%s\n", argv[4]);


	return CMD_RET_SUCCESS;
}

static int hdmirx_init(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	unsigned int port_map;
	int error_code = CMD_RET_SUCCESS;
	unsigned char *edid_buf = NULL;
	int edid_size = 0;

	printf(HDMIRX_VERSION);
	if (argc < 1)
		return cmd_usage(cmdtp);

	if (argc >= 2) {
		port_map = simple_strtoul(argv[1], NULL, 16);
		/*get the edid from param 2*/
		if (argc >= 3) {
			if (strlen(argv[2]) > 0) {
				printf("FILE:%s\n", argv[2]);
				if (hdmirx_read_edid(argv[2],
					&edid_buf, &edid_size) != 0)
					printf("read edid file error\n");
			}
		}
		hdmirx_hw_init(port_map, edid_buf, edid_size);
		if (edid_buf != NULL)
			free(edid_buf);
		error_code = CMD_RET_SUCCESS;
	} else {
		printf("HDMIRX: Error! No port map param\n");
		error_code = CMD_RET_FAILURE;
	}

	return error_code;
}

static cmd_tbl_t cmd_hdmi_sub[] = {
	U_BOOT_CMD_MKENT(init, 1, 1, hdmirx_init, "", ""),
	U_BOOT_CMD_MKENT(hpd, 1, 1, hdmirx_hpd, "", ""),
	U_BOOT_CMD_MKENT(edid, 1, 1, hdmirx_edid, "", ""),
};

static int do_hdmirx(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	if (argc < 2)
		return cmd_usage(cmdtp);

	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_hdmi_sub[0], ARRAY_SIZE(cmd_hdmi_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return cmd_usage(cmdtp);
}

U_BOOT_CMD(hdmirx, CONFIG_SYS_MAXARGS, 0, do_hdmirx,
	   "hdmirx init function\n",
				"hdmirx init\n"
				"      param: port_map edid_patch\n"
				"\n"
);

