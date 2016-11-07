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

#ifdef CONFIG_AML_HDMITX20
#include <amlogic/hdmi.h>
#endif

#ifdef CONFIG_AML_CVBS
#include <amlogic/cvbs.h>
#endif

static int do_vout_list(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
#ifdef CONFIG_AML_HDMITX20
	printf("\nvalid hdmi mode:\n");
	hdmitx_device.HWOp.list_support_modes();
#endif

#ifdef CONFIG_AML_CVBS
	printf("\nvalid cvbs mode:\n");
	cvbs_show_valid_vmode();
	printf("\n");
#endif

	return CMD_RET_SUCCESS;
}

static int do_vout_output(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	if (argc != 2)
		return CMD_RET_FAILURE;

#ifdef CONFIG_AML_CVBS
	if (!strncmp(argv[1], "576cvbs", 7) || !strncmp(argv[1], "480cvbs", 7))
		cvbs_set_vmode(argv[1]);
#endif

#ifdef CONFIG_AML_HDMITX20
	hdmitx_device.vic = hdmi_get_fmt_vic(argv[1]);
	if (hdmitx_device.vic == HDMI_unkown) {
		/* Not find VIC */
		printf("Not find '%s' mapped VIC\n", argv[1]);
		return CMD_RET_SUCCESS;
	} else
		printf("set hdmitx VIC = %d\n", hdmitx_device.vic);

	if (strstr(argv[1], "hz420") != NULL)
		hdmitx_device.mode420 = 1;
	else
		hdmitx_device.mode420 = 0;
	hdmi_tx_set(&hdmitx_device);
#endif

	return CMD_RET_SUCCESS;
}


static cmd_tbl_t cmd_vout_sub[] = {
	U_BOOT_CMD_MKENT(list, 1, 1, do_vout_list, "", ""),
	U_BOOT_CMD_MKENT(output, 3, 1, do_vout_output, "", ""),
};

static int do_vout(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	if (argc < 2)
		return cmd_usage(cmdtp);

	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_vout_sub[0], ARRAY_SIZE(cmd_vout_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return cmd_usage(cmdtp);
}

U_BOOT_CMD(vout, CONFIG_SYS_MAXARGS, 1, do_vout,
	"VOUT sub-system",
	"vout output [list | format]\n"
	"    list : list for valid video mode names.\n"
	"    format : perfered output video mode\n"
);
