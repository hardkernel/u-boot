/*
 * common/cmd_rsvmem.c
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
*/

#include <common.h>
#include <command.h>
#include <asm/io.h>
#include <asm/arch/secure_apb.h>

#ifdef CONFIG_CMD_RSVMEM

//#define RSVMEM_DEBUG_ENABLE
#ifdef RSVMEM_DEBUG_ENABLE
#define rsvmem_dbg(fmt...)	printf("[rsvmem] "fmt)
#else
#define rsvmem_dbg(fmt...)
#endif
#define rsvmem_info(fmt...)	printf("[rsvmem] "fmt)
#define rsvmem_err(fmt...)	printf("[rsvmem] "fmt)

static int do_rsvmem_check(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	unsigned int data = 0;
	unsigned int bl31_rsvmem_size = 0;
	unsigned int bl32_rsvmem_size = 0;
	unsigned int bl31_rsvmem_start = 0;
	unsigned int bl32_rsvmem_start = 0;
	char cmdbuf[128];
	char *fdtaddr = NULL;
	int ret = 0;

	rsvmem_dbg("reserved memory check!\n");
	data = readl(P_AO_SEC_GP_CFG3);
	bl31_rsvmem_size =  ((data & 0xffff0000) >> 16) << 10;
	bl32_rsvmem_size =  (data & 0x0000ffff) << 10;
	bl31_rsvmem_start = readl(P_AO_SEC_GP_CFG5);
	bl32_rsvmem_start = readl(P_AO_SEC_GP_CFG4);

	fdtaddr = getenv("dtb_mem_addr");
	if (fdtaddr == NULL) {
		rsvmem_err("get fdtaddr NULL!\n");
		return -1;
	}

	memset(cmdbuf, 0, sizeof(cmdbuf));
	sprintf(cmdbuf, "fdt addr %s;", fdtaddr);
	rsvmem_dbg("CMD: %s\n", cmdbuf);
	ret = run_command(cmdbuf, 0);
	if (ret != 0 ) {
		rsvmem_err("fdt addr error.\n");
		return -2;
	}

	if ((bl31_rsvmem_size > 0) && (bl31_rsvmem_start > 0)) {
		memset(cmdbuf, 0, sizeof(cmdbuf));
		sprintf(cmdbuf, "fdt set /reserved-memory/linux,secmon reg <0x0 0x%x 0x0 0x%x>;",
				bl31_rsvmem_start, bl31_rsvmem_size);
		rsvmem_dbg("CMD: %s\n", cmdbuf);
		ret = run_command(cmdbuf, 0);
		if (ret != 0 ) {
			rsvmem_err("bl31 reserved memory set addr error.\n");
			return -3;
		}
	}

	if ((bl32_rsvmem_size > 0) && (bl32_rsvmem_start > 0)) {
		memset(cmdbuf, 0, sizeof(cmdbuf));
		sprintf(cmdbuf, "fdt set /reserved-memory/linux,secos status okay;");
		rsvmem_dbg("CMD: %s\n", cmdbuf);
		ret = run_command(cmdbuf, 0);
		if (ret != 0 ) {
			rsvmem_err("bl32 reserved memory set status error.\n");
			return -3;
		}
		memset(cmdbuf, 0, sizeof(cmdbuf));
		sprintf(cmdbuf, "fdt set /reserved-memory/linux,secos reg <0x0 0x%x 0x0 0x%x>;",
				bl32_rsvmem_start, bl32_rsvmem_size);
		rsvmem_dbg("CMD: %s\n", cmdbuf);
		ret = run_command(cmdbuf, 0);
		if (ret != 0 ) {
			rsvmem_err("bl32 reserved memory set addr error.\n");
			return -3;
		}
	}

	return ret;
}

static int do_rsvmem_dump(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	unsigned int data = 0;
	unsigned int bl31_rsvmem_size = 0;
	unsigned int bl32_rsvmem_size = 0;
	unsigned int bl31_rsvmem_start = 0;
	unsigned int bl32_rsvmem_start = 0;

	rsvmem_info("reserved memory:\n");
	data = readl(P_AO_SEC_GP_CFG3);
	bl31_rsvmem_size =  ((data & 0xffff0000) >> 16) << 10;
	bl32_rsvmem_size =  (data & 0x0000ffff) << 10;
	bl31_rsvmem_start = readl(P_AO_SEC_GP_CFG5);
	bl32_rsvmem_start = readl(P_AO_SEC_GP_CFG4);

	rsvmem_info("bl31 reserved memory start: 0x%08x\n", bl31_rsvmem_start);
	rsvmem_info("bl31 reserved memory size:  0x%08x\n", bl31_rsvmem_size);
	rsvmem_info("bl32 reserved memory start: 0x%08x\n", bl32_rsvmem_start);
	rsvmem_info("bl32 reserved memory size:  0x%08x\n", bl32_rsvmem_size);

	return 0;
}

static cmd_tbl_t cmd_rsvmem_sub[] = {
	U_BOOT_CMD_MKENT(check, 2, 0, do_rsvmem_check, "", ""),
	U_BOOT_CMD_MKENT(dump, 2, 0, do_rsvmem_dump, "", ""),
};

static int do_rsvmem(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'rsvmem' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_rsvmem_sub[0], ARRAY_SIZE(cmd_rsvmem_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return CMD_RET_USAGE;
}

U_BOOT_CMD(
	rsvmem, 2, 0,	do_rsvmem,
	"reserve memory",
	"check                   - check reserved memory\n"
	"rsvmem dump                    - dump reserved memory\n"
);
#endif
