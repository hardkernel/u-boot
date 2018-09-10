#include <common.h>
#include <lcd.h>
#include <command.h>
#include <asm/byteorder.h>
#include <malloc.h>
#include <splash.h>
#include <video_fb.h>
#include <video.h>
#include <asm/arch/timer.h>

extern void img_mode_set(u32 display_mode);
extern void img_addr_set(ulong pic_image);
extern void img_type_set(u32 type);
extern int img_osd_init(void);
extern int img_bmp_display(ulong bmp_image, int x, int y);
extern int img_raw_display(ulong raw_image, int x, int y);
extern int img_osd_clear(void);
extern void img_osd_uninit(void);
extern int img_display(ulong bmp_image, int x, int y);
extern int img_scale(void);
extern void img_raw_size_set(u32 raw_width, u32 raw_height, u32 raw_bpp);

static int do_mode_set(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	int mode = 0;

	switch (argc) {
		case 1:
			img_mode_set(MIDDLE_MODE); // default mode
			break;
		case 2:
			mode = simple_strtoul(argv[1], NULL, 10);
			switch (mode) {
				case MIDDLE_MODE:
				case RECT_MODE:
				case FULL_SCREEN_MODE:
					img_mode_set(mode);
					break;
				default:
					return CMD_RET_USAGE;
			}
			break;
		default:
			return CMD_RET_USAGE;
		}
	return 0;
}

static int do_addr_set(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	ulong pic_image;

	switch (argc) {
		case 1:		/* use load_addr as default address */
			pic_image = load_addr;
			break;
		case 2:		/* use argument */
			pic_image = simple_strtoul(argv[1], NULL, 16);
			break;
		default:
			return CMD_RET_USAGE;
	}
	img_addr_set(pic_image);
	return 0;
}

static int do_type_set(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	u32 type;

	switch (argc) {
		case 1:
			img_type_set(BMP_PIC); // default type
			break;
		case 2:
			type = simple_strtoul(argv[1], NULL, 10);
			switch (type) {
				case BMP_PIC:
				case RAW_PIC:
					img_type_set(type);
					break;
				default:
					return CMD_RET_USAGE;
			}
			break;
		default:
			return CMD_RET_USAGE;
		}

	return 0;
}

static int do_img_init(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	int raw_width= 1920, raw_height = 1080, raw_bpp = 24; // default 1080p bpp24

	switch (argc) {
		case 1:
			break;
		case 4:
			raw_width = simple_strtoul(argv[1], NULL, 10);
			raw_height = simple_strtoul(argv[2], NULL, 10);
			raw_bpp = simple_strtoul(argv[3], NULL, 10);
			img_raw_size_set(raw_width, raw_height, raw_bpp);
			break;
		default:
			return CMD_RET_USAGE;
	}
	if (img_osd_init()) {
		printf("img_osd_init failed.\n");
		return -1;
	} else {
		printf("img_osd_init successfully.\n");
		return 0;
	}
}

static int do_img_clear(cmd_tbl_t *cmdtp, int flag, int argc,
			char *const argv[])
{
	img_osd_clear();

	return 0;
}

static int do_img_uninit(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	img_osd_uninit();
	return 0;
}

static int do_img_display(cmd_tbl_t *cmdtp, int flag, int argc,
			  char *const argv[])
{
	int ret = -1;
	int x = 0, y = 0;
	ulong pic_image;
	ulong start = get_time();

	switch (argc) {
		case 1:		/* use load_addr as default address */
			pic_image = load_addr;
			break;
		case 2:		/* use argument */
			pic_image = simple_strtoul(argv[1], NULL, 16);
			break;
		case 4:
			pic_image = simple_strtoul(argv[1], NULL, 16);
			x = simple_strtoul(argv[2], NULL, 10);
			y = simple_strtoul(argv[3], NULL, 10);
			break;
		default:
			return CMD_RET_USAGE;
	}

	ret = img_display(pic_image, x, y);
	printf("bmp display time = %ld\n", get_time() - start);

	return ret;
}

static int do_img_scale(cmd_tbl_t *cmdtp, int flag, int argc,
			  char *const argv[])
{
	return img_scale();
}
static cmd_tbl_t cmd_img_osd_sub[] = {
	U_BOOT_CMD_MKENT(mode_set, 2, 0, do_mode_set, "", ""),
	U_BOOT_CMD_MKENT(addr_set, 2, 0, do_addr_set, "", ""),
	U_BOOT_CMD_MKENT(type_set, 2, 0, do_type_set, "", ""),
	U_BOOT_CMD_MKENT(init, 2, 0, do_img_init, "", ""),
	U_BOOT_CMD_MKENT(clear, 2, 0, do_img_clear, "", ""),
	U_BOOT_CMD_MKENT(uninit, 2, 0, do_img_uninit, "", ""),
	U_BOOT_CMD_MKENT(display, 5, 0, do_img_display, "", ""),
	U_BOOT_CMD_MKENT(scale, 5, 0, do_img_scale, "", ""),
};

static int do_img_osd(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'osd' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_img_osd_sub[0], ARRAY_SIZE(cmd_img_osd_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return CMD_RET_USAGE;
}

U_BOOT_CMD(
	img_osd,	5,	1,	do_img_osd,
	"image osd sub-system",
	"mode_set <mode>                       - set img load mode(middle:0, rect:1, full_screen:2)\n"
	"img_osd addr_set <addr>                       - set img addr\n"
	"img_osd type_set <type>                       - set img type(bmp:0, raw:1)\n"
	"img_osd init [raw_width raw_height raw_bpp]   - init osd device\n"
	"img_osd clear                                 - clear osd framebuffer\n"
	"img_osd uninit                                - uninit osd device\n"
	"img_osd display <imageAddr> [x y]             - display image\n"
	"img_osd scale                                 - scale image\n"
);

