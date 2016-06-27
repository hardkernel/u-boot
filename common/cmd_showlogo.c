/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <asm/errno.h>
#include <vsprintf.h>
#include <linux/kernel.h>

#ifdef CONFIG_DISPLAY_LOGO
static struct c2_resolution {
	const char *name;
	int fb_width;
	int fb_height;
} c2_res_list[] = {
	{"480p60hz", 720, 480},
	{"576p50hz", 720, 576},
	{"720p60hz", 1280, 720},
	{"720p50hz", 1280, 720},
	{"1080p60hz", 1920, 1080},
	{"1080p50hz", 1920, 1080},
	{"1080p30hz", 1920, 1080},
	{"1080p24hz", 1920, 1080},
	{"1080i60hz", 1920, 1080},
	{"1080i50hz", 1920, 1080},
	{"2160p60hz", 3840, 2160},
	{"2160p50hz", 3840, 2160},
	{"2160p30hz", 3840, 2160},
	{"2160p25hz", 3840, 2160},
	{"2160p24hz", 3840, 2160},
	{"2160p60hz420", 3840, 2160},
	{"2160p50hz420", 3840, 2160},
	{"640x480p60hz", 640, 480},
	{"800x480p60hz", 800, 480},
	{"800x600p60hz", 800, 600},
	{"1024x600p60hz", 1024, 600},
	{"1024x768p60hz", 1024, 768},
	{"1280x800p60hz", 1280, 800},
	{"1280x1024p60hz", 1280, 1024},
	{"1360x768p60hz", 1360, 768},
	{"1440x900p60hz", 1440, 900},
	{"1600x900p60hz", 1600, 900},
	{"1680x1050p60hz", 1680, 1050},
	{"1920x1200p60hz", 1920, 1200},
	{"2560x1600p60hz", 2560, 1600},
	{"2560x1440p60hz", 2560, 1440},
	{"2560x1080p60hz", 2560, 1080},
	{"3440x1440p60hz", 3440, 1440},
};

static int display_logo(const char* mode)
{
	int ret = 0;
	int i = 0;

	for (i = 0; i < ARRAY_SIZE(c2_res_list); ++i) {
		if (!strcmp(c2_res_list[i].name, mode)) {
			setenv("fb_width", simple_itoa(c2_res_list[i].fb_width));
			setenv("fb_height", simple_itoa(c2_res_list[i].fb_height));
			break;
		}
	}

	/* If hdmimode is set by invalid mode, u-boot set the default mode(1080p60hz). */
	if (i == ARRAY_SIZE(c2_res_list)) {
		printf("error: '%s' is invalid resolution.\n", mode);
		printf("Set the default resolution. => 1080p60hz.\n");
		mode = "1080p60hz";
		setenv("fb_width", "1920");
		setenv("fb_height", "1080");
		setenv("hdmimode", "1080p60hz");
		run_command("save", 0);
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

	if (NULL == getenv("vout_mode"))
		setenv("vout_mode", "hdmi");

	run_command("hdmitx hpd; osd open; osd clear", 0);
	run_command("vout output ${outputmode}; hdmitx mode ${vout_mode}; hdmitx output ${outputmode}", 0);
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
		display_logo((NULL == mode) ? "1080p60hz" : mode);
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
		"                 '1080p60hz' will be used by default if missing"
);
#endif  /* CONFIG_DISPLAY_LOGO */

/* vim: set ts=4 sw=4 tw=80: */
