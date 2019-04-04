/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 *  This driver has been modified to support ODROID-N2.
 *      Modified by Joy Cho <joy.cho@hardkernel.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <asm/errno.h>
#include <vsprintf.h>
#include <linux/kernel.h>
#include <../board/hardkernel/odroid-common/odroid-common.h>

static struct odroid_resolution {
	const char *name;
	int display_width;
	int display_height;
} odroid_res_list[] = {
	{"480cvbs", 720, 480},
	{"576cvbs", 720, 576},
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
	{"480x320p60hz", 480, 320},
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
	{"1600x1200p60hz", 1600, 1200},
	{"1680x1050p60hz", 1680, 1050},
	{"1920x1200p60hz", 1920, 1200},
	{"2560x1440p60hz", 2560, 1440},
	{"2560x1080p60hz", 2560, 1080},
	/* for custombuilt, default size is supported on uboot */
	{"custombuilt", 1920, 1080},
};

static int boot_partition(void)
{
	int dev = get_boot_device();

	if (dev == BOOT_DEVICE_EMMC)
		return 1;
	else if (dev == BOOT_DEVICE_SD)
		return 0;

	return -1;
}

static int display_logo(const char* mode, const char* bmp_width, const char* bmp_height, const char* bmp_filename)
{
	int ret = 0;
	int i = 0;
	char str[64];
	int bootdev;

	for (i = 0; i < ARRAY_SIZE(odroid_res_list); ++i) {
		if (!strcmp(odroid_res_list[i].name, mode)) {
			if (!strcmp(mode, "custombuilt")) {
				setenv("display_width", getenv("customwidth"));
				setenv("display_height", getenv("customheight"));
			} else {
				setenv("display_width", simple_itoa(odroid_res_list[i].display_width));
				setenv("display_height", simple_itoa(odroid_res_list[i].display_height));
			}
			break;
		}
	}

	/* If hdmimode is set by invalid mode, u-boot set the default mode(1080p60hz). */
	if (i == ARRAY_SIZE(odroid_res_list)) {
		printf("error: '%s' is invalid resolution.\n", mode);
		printf("Set the default resolution. => 1080p60hz.\n");
		mode = "1080p60hz";
		setenv("display_width", "1920");
		setenv("display_height", "1080");
		setenv("hdmimode", "1080p60hz");
		run_command("save", 0);
	}

	/* check boot device */
	bootdev = boot_partition();

	setenv("bootlogo_addr", "0x20000000");
#ifdef CONFIG_VIDEO_BMP_GZIP
	sprintf(str, "load mmc %d ${bootlogo_addr} %s", bootdev, bmp_filename);
	ret = run_command(str, 0);
	if (!ret)	goto display_logo;
#endif
	/* set indispensable display initialization only */
	run_command("osd open; osd clear", 0);
	sprintf(str, "vout output %s", mode);
	run_command(str, 0);

	return 1;

display_logo:
	/* for video_hw_init in osd_fb.c */
	setenv("fb_addr", "0x3d800000");
	setenv("display_bpp", "24");
	setenv("display_color_index", "24");
	setenv("display_layer", "osd1");
	setenv("display_color_fg", "0xffff");
	setenv("display_color_bg", "0");
	setenv("cvbsmode", "576cvbs");
	setenv("hdmimode", mode);
	setenv("outputmode", mode);

	/* bmp scale */
	setenv("fb_width", bmp_width);
	setenv("fb_height", bmp_height);

	run_command("osd open; osd clear", 0);
	run_command("vout output ${outputmode}; hdmitx output ${outputmode}", 0);
	run_command("bmp display ${bootlogo_addr}", 0);
	run_command("bmp scale", 0);

	return 0;
}

static int do_showlogo(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	char *mode;

	if (argc <= 1) {
		mode = getenv("hdmimode");
		/* ODROID default logo size 1280x720 */
		display_logo((NULL == mode) ? "1080p60hz" : mode, "1280", "720", "boot-logo.bmp.gz");
	} else if (argc == 5) {
		display_logo(argv[1], argv[2], argv[3], argv[4]);
	} else {
		display_logo(argv[1], "1280", "720", "boot-logo.bmp.gz");
	}

	return 0;
}

U_BOOT_CMD(
		showlogo,		5,		0,	do_showlogo,
		"Displaying BMP logo file to HDMI screen with the specified resolution",
		"<resolution> [<bmp_width> <bmp_height> <bmp_filename>]\n"
		"	resolution - screen resoltuion on HDMI screen\n"
		"		'1080p60hz' will be used by default if missing\n"
		"	bmp_width (optional) - width of logo bmp file\n"
		"		'1280' will be used by default if missing\n"
		"	bmp_height (optional) - height of logo bmp file\n"
		"		'720' will be used by default if missing"
		"	bmp_filename (optional) - name of the logo bmp file\n"
		"		'boot-logo.bmp.gz' will be used by default if missing"
);
