#include <common.h>
#include <lcd.h>
#include <command.h>
#include <asm/byteorder.h>
#include <malloc.h>
#include <splash.h>
#include <video_fb.h>
#include <video.h>

/* Graphic Device */
static GraphicDevice *gdev = NULL;

extern void osd_debug(void);
extern void osd_set_log_level(int);
extern void osd_test(void);
extern void osd_enable_hw(u32 index, u32 enable);
extern void osd_set_free_scale_enable_hw(u32 index, u32 enable);

static int do_osd_open(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	gdev = video_hw_init();
	if (gdev == NULL) {
		printf("Initialize video device failed!\n");
		return 1;
	}
	return 0;
}

static int do_osd_enable(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	ulong index = 0;

	index = simple_strtoul(getenv("display_layer"), NULL, 0);
	osd_enable_hw(index, 0);

	return 0;
}

static int do_osd_close(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	gdev = NULL;
	osd_enable_hw(0, 0);
	osd_enable_hw(1, 0);
	osd_set_free_scale_enable_hw(0, 0);
	osd_set_free_scale_enable_hw(1, 0);

	return 0;
}

static int do_osd_clear(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	if (gdev == NULL) {
		printf("Please enable osd device first!\n");
		return 1;
	}

#ifdef CONFIG_OSD_SCALE_ENABLE
	memset((void *)(long long)(gdev->frameAdrs), 0,
	       (gdev->fb_width * gdev->fb_height)*gdev->gdfBytesPP);

	flush_cache(gdev->frameAdrs,
		    ((gdev->fb_width * gdev->fb_height)*gdev->gdfBytesPP));
#else
	memset((void *)(long long)(gdev->frameAdrs), 0,
	       (gdev->winSizeX * gdev->winSizeY)*gdev->gdfBytesPP);

	flush_cache(gdev->frameAdrs,
		    ((gdev->winSizeX * gdev->winSizeY)*gdev->gdfBytesPP));
#endif
	return 0;
}

static int do_osd_debug(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	int ret = 0;
	int level = 0;

	switch (argc) {
	case 1:
		osd_debug();
		break;
	case 2:
		level = simple_strtoul(argv[1], NULL, 10);
		osd_set_log_level(level);
		break;
	default:
		return CMD_RET_USAGE;
	}

	return ret;
}

static int do_osd_test(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = 0;

	osd_test();

	return ret;
}

static int do_osd_display(cmd_tbl_t *cmdtp, int flag, int argc,
			  char *const argv[])
{
	int ret = 0;
	int x = 0, y = 0;
	ulong addr;

	splash_get_pos(&x, &y);

	switch (argc) {
	case 1:		/* use load_addr as default address */
		addr = load_addr;
		break;
	case 2:		/* use argument */
		addr = simple_strtoul(argv[1], NULL, 16);
		break;
	case 4:
		addr = simple_strtoul(argv[1], NULL, 16);
		x = simple_strtoul(argv[2], NULL, 10);
		y = simple_strtoul(argv[3], NULL, 10);
		break;
	default:
		return CMD_RET_USAGE;
	}

	ret = video_display_bitmap((unsigned long)addr, x, y);

	return ret;
}

static cmd_tbl_t cmd_osd_sub[] = {
	U_BOOT_CMD_MKENT(open, 2, 0, do_osd_open, "", ""),
	U_BOOT_CMD_MKENT(enable, 2, 0, do_osd_enable, "", ""),
	U_BOOT_CMD_MKENT(close, 2, 0, do_osd_close, "", ""),
	U_BOOT_CMD_MKENT(clear, 2, 0, do_osd_clear, "", ""),
	U_BOOT_CMD_MKENT(debug, 2, 0, do_osd_debug, "", ""),
	U_BOOT_CMD_MKENT(test, 2, 0, do_osd_test, "", ""),
	U_BOOT_CMD_MKENT(display, 5, 0, do_osd_display, "", ""),
};

static int do_osd(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'osd' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_osd_sub[0], ARRAY_SIZE(cmd_osd_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return CMD_RET_USAGE;
}

U_BOOT_CMD(
	osd,	5,	1,	do_osd,
	"osd sub-system",
	"open                      - open osd device\n"
	"osd enable                    - enable osd device\n"
	"osd close                     - close osd device\n"
	"osd clear                     - clear osd framebuffer\n"
	"osd debug                     - debug osd device\n"
	"osd test                      - test osd device\n"
	"osd display <imageAddr> [x y] - display image\n"
);

