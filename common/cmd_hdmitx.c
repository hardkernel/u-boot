/*
 * (C) Copyright 2012
 * Amlogic. Inc. zongdong.jiao@amlogic.com
 *
 * This file is used to prefetch/varify/compare HDCP keys
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
#include <amlogic/hdmi.h>

#undef DEBUG_DUMPEDID

extern void parse_edid(unsigned char *edid, unsigned int blk_len);
extern char *select_best_resolution(void);

static int do_hpd_detect(cmd_tbl_t *cmdtp, int flag, int argc,
	char *const argv[])
{
	int st = hdmitx_device.HWOp.get_hpd_state();
	printf("hpd_state=%c\n", st ? '1' : '0');

	if (st) {
		setenv("outputmode", getenv("hdmimode"));
	} else {
		setenv("outputmode", getenv("cvbsmode"));
	}
	return st;
}

/* max edid buffer : 512 bytes */
static unsigned char edid_raw_buf[512] = {0};
#ifdef DEBUG_DUMPEDID
static void dump_edid_raw(unsigned char *buf, unsigned int blk_len)
{
	int i;
	for (i = 0 ; i < (128 * blk_len); i++) {
		printf("%02x ", buf[i]);
		if (i % 8 == 7)	printf("\n");
	}
	printf("\n");
}
#endif

static int do_edid(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	unsigned int blk_len = 0;
	memset(edid_raw_buf, 0, ARRAY_SIZE(edid_raw_buf));
	if (argc < 1)
		return cmd_usage(cmdtp);
	/* read edid raw data */
	blk_len = hdmitx_device.HWOp.read_edid(edid_raw_buf);

	if (!blk_len)
		printf("edid read failed\n");
	else {
#ifdef DEBUG_DUMPEDID
		/* dump all raw data */
		dump_edid_raw(edid_raw_buf, blk_len);
#endif
		/* parsing edid data */
		parse_edid(edid_raw_buf, blk_len);
		/* select best resolution */
		setenv("m", select_best_resolution());
		setenv("hdmimode", getenv("m"));
		/* set hdmi csc config */
		run_command("hdmitx mode ${vout}", 0);
	}

	return CMD_RET_SUCCESS;
}

static int do_output(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	if (argc < 1)
		return cmd_usage(cmdtp);

	if (strcmp(argv[1], "list") == 0)
		hdmitx_device.HWOp.list_support_modes();
	else if (strcmp(argv[1], "bist") == 0) {
		unsigned int mode;
		mode = simple_strtoul(argv[2], NULL, 16);
		hdmitx_device.HWOp.test_bist(mode);
	} else { /* "output" */
		hdmitx_device.vic = hdmi_get_fmt_vic(argv[1]);
		if (hdmitx_device.vic == HDMI_unkown) {
			/* Not find VIC */
			printf("Not find '%s' mapped VIC\n", argv[1]);
			return CMD_RET_FAILURE;
		} else
			printf("set hdmitx VIC = %d\n", hdmitx_device.vic);

		if (strstr(argv[1], "hz420") != NULL)
			hdmitx_device.mode420 = 1;
		else
			hdmitx_device.mode420 = 0;
		hdmi_tx_set(&hdmitx_device);
	}
	return CMD_RET_SUCCESS;
}

static int do_off(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	hdmitx_device.vic = HDMI_unkown;
	hdmitx_device.HWOp.turn_off();
	printf("turn off hdmitx\n");
	return 1;
}

static int do_dump(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	hdmitx_device.HWOp.dump_regs();
	return 1;
}

static int do_mode(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	if (strstr(argv[1], "dvi") != NULL)
		hdmitx_device.dvimode = 1;
	else
		hdmitx_device.dvimode = 0;

	return 1;
}

static cmd_tbl_t cmd_hdmi_sub[] = {
	U_BOOT_CMD_MKENT(hpd, 1, 1, do_hpd_detect, "", ""),
	U_BOOT_CMD_MKENT(edid, 1, 1, do_edid, "", ""),
	U_BOOT_CMD_MKENT(output, 3, 1, do_output, "", ""),
	U_BOOT_CMD_MKENT(off, 1, 1, do_off, "", ""),
	U_BOOT_CMD_MKENT(dump, 1, 1, do_dump, "", ""),
	U_BOOT_CMD_MKENT(mode, 1, 1, do_mode, "", ""),
};

static int do_hdmitx(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
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

U_BOOT_CMD(hdmitx, CONFIG_SYS_MAXARGS, 1, do_hdmitx,
	   "HDMITX sub-system",
	"hdmitx hpd\n"
	"    Detect hdmi rx plug-in\n"
	"hdmitx edid\n"
	"    Read hdmi edid raw format\n"
	"hdmitx output [list | FORMAT | bist MODE]\n"
	"    list: list support formats\n"
	"    FORMAT can be 720p60/50hz, 1080i60/50hz, 1080p60hz, etc\n"
	"    bist MODE: 1 Color bar  2 Line  3 Dots  0 default\n"
	"hdmitx off\n"
	"    Turn off hdmitx output\n"
);
