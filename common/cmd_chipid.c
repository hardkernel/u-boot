/*
 * Copyright (C) 2014-2017 Amlogic, Inc. All rights reserved.
 *
 * Command to display Amlogic GX-family SoC Chip ID
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <asm/cpu_id.h>

static int do_chipid(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int i;
	uint8_t buff[16];

	printf("\nSerial\t\t: ");

	if (get_chip_id(&buff[0], sizeof(buff)) == 0) {
		for (i = 0; i < sizeof(buff); i++)
			printf("%02x", buff[i]);
		printf("\n");
	}
	else
		printf("error\n");

	return 0;
}

U_BOOT_CMD(
	chipid,		1,	1,	do_chipid,
	"Print Chip ID",
	""
);
