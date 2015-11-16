/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <asm/errno.h>

#ifdef CONFIG_DISPLAY_LOGO
static int display_logo(const char* mode)
{
	int ret;

	if (!strncmp("720", mode, 3)) {
		setenv("fb_width", "1280");
		setenv("fb_height", "720");
	} else if (!strncmp("1080", mode, 4)) {
		setenv("fb_width", "1920");
		setenv("fb_height", "1080");
	} else if (!strncmp("2160", mode, 4)) {
		setenv("fb_width", "3840");
		setenv("fb_height", "2160");
	} else {
		printf("error: '%s' is invalid resolution.\n", mode);
		return 1;
	}

	setenv("bootlogo_addr", "0x20000000"); /* initrd load address + 0xD0000000 */
#ifdef CONFIG_VIDEO_BMP_GZIP
	ret = run_command("fatload mmc 0 ${bootlogo_addr} boot-logo.bmp.gz", 1);
	if (!ret)	goto display_logo;
#endif
	ret = run_command("fatload mmc 0 ${bootlogo_addr} boot-logo.bmp", 1);
	if (!ret)	goto display_logo;

	ret = run_command("movi read logo 0 ${bootlogo_addr}", 1);
	if (!ret)
		goto display_logo;

	return 1;

display_logo:
	/* for video_hw_init in osd_fb.c */
	setenv("fb_addr", "0x3f800000");
	setenv("display_bpp", "24");
	setenv("display_color_index", "24");
	setenv("display_layer", "osd1");
	setenv("display_color_fg", "0xffff");
	setenv("display_color_bg", "0");
	setenv("cvbsmode", "576cvbs");
	setenv("hdmimode", mode);
	setenv("outputmode", mode);

	setenv("display_width", getenv("fb_width"));
	setenv("display_height", getenv("fb_height"));

	run_command("hdmitx hpd; osd open; osd clear", 0);
	run_command("vout output ${outputmode}; hdmitx output ${outputmode}", 0);
	run_command("bmp display ${bootlogo_addr}", 0);
	run_command("setenv logoopt ${display_layer},loaded,${fb_addr},${hdmimode}", 0);

	return 0;
}

static int do_showlogo(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	char *mode;

	if (argc <= 1) {
		mode = getenv("hdmimode");
		display_logo((NULL == mode) ? "720p60hz" : mode);
	} else {
		display_logo(argv[1]);
	}

	return 0;
}

U_BOOT_CMD(
		showlogo,		2,		0,	do_showlogo,
		"Displaying BMP logo file to HDMI screen with the specified resolution",
		"<resolution>\n"
		"    resolution - screen resoltuion on HDMI screen\n"
		"                 '720p60hz' will be used by default if missing"
);
#endif  /* CONFIG_DISPLAY_LOGO */

/* vim: set ts=4 sw=4 tw=80: */
