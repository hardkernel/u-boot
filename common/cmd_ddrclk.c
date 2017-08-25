/*
 * Copyright (C) 2017 Hardkernel Co,. Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>

#define LOAD_ADDR	0x21000000
#define ACS_OFFSET	0x55
#define ACS_DDR_OFFSET	0xA

static int do_ddrclk(cmd_tbl_t *cmdtp, int flag, int argc,
		  char *const argv[])
{
	int ddrclk = 0;
	char str[128];

	/* dump acs structure in BL area */
	sprintf(str, "mmc read 0x%x 0x%x 0x1",
		(unsigned int)LOAD_ADDR, (unsigned int)ACS_OFFSET);
	run_command(str, 0);

	/* get ddr frequency value of acs structure */
	ddrclk = *(u16 *) (LOAD_ADDR + ACS_DDR_OFFSET);

	/* set env ddrclk */
	sprintf(str, "%d", ddrclk);
	setenv("ddrclk", str);

	return CMD_RET_SUCCESS;
}

#ifdef CONFIG_SYS_LONGHELP
static char ddrclk_help_text[] =
	"show current ddr clock";
#endif

U_BOOT_CMD(showddrclk, 1, 1, do_ddrclk, "show current ddr clock", ddrclk_help_text);
