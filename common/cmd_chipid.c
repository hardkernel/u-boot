/*
 * Copyright 2000-2009
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <version.h>
#include <linux/compiler.h>
#include <asm/arch/bl31_apis.h>

const char __weak version_string[] = U_BOOT_VERSION_STRING;

static int do_chipid(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	unsigned int low0, low1, high0, high1;
	bl31_get_chipid(&low0, &low1, &high0, &high1);
	printf("\nSerial\t\t: %08x%08x%08x%08x\n", high1, high0, low1, low0);
	return 0;
}

U_BOOT_CMD(
	chipid,	1,		1,	do_chipid,
	"print chipid and cpuversion",
	""
);
