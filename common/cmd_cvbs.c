/*
 * (C) Copyright 2012
 * Amlogic. Inc. jets.yan@amlogic.com
 *
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <command.h>
#include <environment.h>
#include <malloc.h>
#include <asm/byteorder.h>
#include <amlogic/cvbs.h>

static int do_cvbs_init(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	cvbs_init();

	return CMD_RET_SUCCESS;
}

static int do_cvbs_debug(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	if ((argc != 2) && (argc != 4) && (argc != 5)) {
		printf("cvbs debug command format as:\n"
		"    r h/v address\n"
		"    w value h/v address\n"
		"    dump h/v addr_start addr_end\n"
		"    enci\n"
		"    clock\n");
		return CMD_RET_FAILURE;
	}

	cvbs_reg_debug(argc, argv);

	return CMD_RET_SUCCESS;
}

static int do_cvbs_output(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	if (argc < 1)
		return cmd_usage(cmdtp);

	if ((argc != 2) && (argc != 3)) {
		printf("cvbs output mode can be:\n"
			"    576cvbs\n"
			"    480cvbs\n"
			"    bist [off|1 or colorbar|2 or thinline|3 or dotgrid|0 or fixval]\n");
		return CMD_RET_FAILURE;
	}

	if (strcmp(argv[1], "list") == 0) {
		cvbs_show_valid_vmode();
	} else if (strcmp(argv[1], "bist") == 0) {
		if (argc != 3)
			printf("bist mode can be: [off|1 or colorbar|2 or thinline|3 or dotgrid|0 or fixval]\n");
		else
			cvbs_set_bist(argv[2]);
	} else { /* "output" */
			cvbs_set_vmode(argv[1]);
	}
	return CMD_RET_SUCCESS;
}

static int do_vdac(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	cvbs_set_vdac(simple_strtoul(argv[1], NULL, 16));
	return 1;
}

static cmd_tbl_t cmd_cvbs_sub[] = {
	U_BOOT_CMD_MKENT(init, 1, 1, do_cvbs_init, "", ""),
	U_BOOT_CMD_MKENT(debug, 1, 1, do_cvbs_debug, "", ""),
	U_BOOT_CMD_MKENT(output, 3, 1, do_cvbs_output, "", ""),
	U_BOOT_CMD_MKENT(vdac, 1, 1, do_vdac, "", ""),
};

static int do_cvbs(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	if (argc < 2)
		return cmd_usage(cmdtp);

	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_cvbs_sub[0], ARRAY_SIZE(cmd_cvbs_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return cmd_usage(cmdtp);
}

U_BOOT_CMD(cvbs, CONFIG_SYS_MAXARGS, 1, do_cvbs,
	"CVBS sub-system",
	"cvbs init\n"
	"    init of cvbs\n"
	"cvbs debug\n"
	"    r h/v address\n"
	"    w value h/v address\n"
	"    dump h/v addr_start addr_end\n"
	"    enci\n"
	"    clock\n"
	"cvbs output [FORMAT | bist MODE]\n"
	"    FORMAT : [576cvbs|480cvbs]\n"
	"    bist mode : [off|1 or colorbar|2 or thinline|3 or dotgrid|0 or fixval]\n"
	"cvbs vdac\n"
	"    0 for off, 1 for enci, 2 for atv, 3 for analog-cvbs passthrough\n"
);
