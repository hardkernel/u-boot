/*
 * Command for video.
 *
 * Copyright (C) 2011 Amlogic.
 * Elvis Yu
 */
#include <common.h>
#include <video_fb.h>
#include <amlogic/aml_lcd.h>

/********************************************************************************************
*
*										Video
*
*********************************************************************************************/
extern void reset_console(void);

static GraphicDevice *gdev = NULL;	/* Graphic Device */

static int dump_video_info(void)
{
	if(gdev == NULL)
	{
		printf("Please initialize video device first!\n");
		return 1;
	}
	
	printf("frame buffer address is 0x%08x\n", gdev->frameAdrs);
	printf("video size is %d X %d\n", gdev->winSizeX, gdev->winSizeY);
	printf("video bbp is %d\n", gdev->gdfBytesPP*8);

	return 0;
}
static int do_video_open(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
//	printf("Video initializing...\n");
	gdev = video_hw_init();
	if(gdev == NULL)
	{
		printf("Initialize video device failed!\n");
		return 1;
	}
//	dump_video_info();
	return 0;
}

static int do_video_close(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])										  
{
	printf("Unuse!\n");
	gdev = NULL;
	return 0;
}

static int do_video_clear(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if(gdev == NULL)
	{
		printf("Please initialize video device first!\n");
		return 1;
	}
//	printf("LCD screen clear!\n");
#ifdef CONFIG_OSD_SCALE_ENABLE
	memset ((char *)gdev->frameAdrs, 0,
		(gdev->fb_width*gdev->fb_height)*gdev->gdfBytesPP);

	flush_cache(gdev->frameAdrs, ((gdev->fb_width*gdev->fb_height)*gdev->gdfBytesPP));
#else
	memset ((char *)gdev->frameAdrs, 0,
		(gdev->winSizeX*gdev->winSizeY)*gdev->gdfBytesPP);

	flush_cache(gdev->frameAdrs, ((gdev->winSizeX*gdev->winSizeY)*gdev->gdfBytesPP));
#endif
	reset_console();
	return 0;	
}

static int do_video_dev(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	//int i;
	char *video_dev;

	video_dev = getenv ("video_dev");
#ifdef CONFIG_VIDEO_AMLLCD
	if(strcmp(video_dev, "panel") == 0)
	{
		return lcd_opt_cmd(--argc, ++argv);
	}
#endif
#ifdef CONFIG_VIDEO_AMLTVOUT
	if(strcmp(video_dev, "tvout") == 0)
	{
		return tvout_opt_cmd(--argc, ++argv);
	}
#endif
	printf("ERROR:env video_dev invalid! video_dev is %s\n", video_dev);
	return 1;
}


static cmd_tbl_t cmd_video_sub[] = {
	U_BOOT_CMD_MKENT(open, 2, 0, do_video_open, "", ""),
	U_BOOT_CMD_MKENT(close, 2, 0, do_video_close, "", ""),
	U_BOOT_CMD_MKENT(clear, 2, 0, do_video_clear, "", ""),
	U_BOOT_CMD_MKENT(dev, 3, 0, do_video_dev, "", ""),
};


static int do_video(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_video_sub[0], ARRAY_SIZE(cmd_video_sub));

	if (c) {
		return	c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
	video,	8,	0,	do_video,
	"video sub-system",
	"video open		- open an display layer\n"
	"video close	- close the display layer\n"
	"video clear	- clear the display layer\n"
	"video dev <opt>	- operate on the display device, opt=? for help\n"
);
