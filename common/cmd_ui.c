#include <common.h>
#include <command.h>
#include <malloc.h>
#include <video_fb.h>
#include <video.h>


int screen_init(void);
void screen_uninit(void);
int gr_init_ext_font(const char* font, GRFont** dest);
int surface_loadbmp(GRSurface** surface, const char* filename);
void surface_disaplay(GRSurface* surface, int sx, int sy, int dx, int dy);
void screen_setcolor(unsigned int color);
void screen_drawtextline(const GRFont* font, int x, int y, const char *s, bool bold);
void screen_fillrect(int x, int y, int w, int h);
void screen_update(void);
const GRFont* gr_sys_font(void);
void set_fastboot_flag(int flag);

static int ui_inited = 0;
extern unsigned int ui_log_level;

typedef struct {
	GRFont* font;
	const char *font_name;
} LIB_FONT;

typedef struct {
	GRSurface* surface;
	const char *pic_name;
} PIC_SURFACE;

LIB_FONT lib_font[] = {{NULL, "font"}};
PIC_SURFACE pic_surface[] = {{NULL, "bootup"}, {NULL, "upgrade_error"}, {NULL, "upgrade_fail"}, {NULL, "upgrade_success"}};

static int do_ui_init(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	int i;

	if (!ui_inited) {
		set_fastboot_flag(1);

		screen_init();

		for (i =0; i < ARRAY_SIZE(lib_font); i++) {
			gr_init_ext_font(lib_font[i].font_name, &lib_font[i].font);
		}

		for (i =0; i < ARRAY_SIZE(pic_surface); i++) {
			surface_loadbmp(&pic_surface[i].surface, pic_surface[i].pic_name);
		}
	}

	ui_inited = 1;

	return 0;
}

static int do_ui_pic(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	int i;

	if (!ui_inited) {
		printf("error: ui init first\n");
		return -1;
	} else if (argc != 6) {
		return -1;
	} else {
		for (i =0; i < ARRAY_SIZE(pic_surface); i++) {
			if (!strcmp(argv[1], pic_surface[i].pic_name))
				if (pic_surface[i].surface) {
					surface_disaplay(pic_surface[i].surface,
							simple_strtoul(argv[2], NULL, 10), simple_strtoul(argv[3], NULL, 10),
							simple_strtoul(argv[4], NULL, 10), simple_strtoul(argv[5], NULL, 10));
					break;
				}
		}
	}

	if (i == ARRAY_SIZE(pic_surface)) {
		printf("error: blit pic %s to framebuffer fail\n", argv[1]);
		return -1;
	}

	return 0;
}

static int do_ui_setcolor(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	if (!ui_inited) {
		printf("error: ui init first\n");
		return -1;
	} else {
		if (argc != 2)
			return -1;
		else
			screen_setcolor(simple_strtoul(argv[1], NULL, 16));
	}

	return 0;
}

static int do_ui_text(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	int i;

	if (!ui_inited) {
		printf("error: ui init first\n");
		return -1;
	} else if (argc < 5) {
			return -1;
	}	else {
		for (i =0; i < ARRAY_SIZE(lib_font); i++) {
			if (!strcmp(argv[1], lib_font[i].font_name))
				if (lib_font[i].font) {
					screen_drawtextline(lib_font[i].font,
								simple_strtoul(argv[3], NULL, 10), simple_strtoul(argv[4], NULL, 10),
								argv[2], (argc >= 6 ? (simple_strtoul(argv[5], NULL, 10) == 1 ? 1 : 0) : 0));
					break;
				}
		}
	}

	if (i == ARRAY_SIZE(lib_font)) {
		printf("error: use external font lib %s fail, use default font lib\n", argv[1]);
		screen_drawtextline(gr_sys_font(),
					simple_strtoul(argv[3], NULL, 10), simple_strtoul(argv[4], NULL, 10),
					argv[2], (argc >= 6 ? (simple_strtoul(argv[5], NULL, 10) == 1 ? 1 : 0) : 0));
	}

	return 0;
}

static int do_ui_rect(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	if (!ui_inited) {
		printf("error: ui init first\n");
		return -1;
	} else if (argc != 5){
		return -1;
	} else {
		screen_fillrect(simple_strtoul(argv[1], NULL, 10), simple_strtoul(argv[2], NULL, 10),
				simple_strtoul(argv[3], NULL, 10), simple_strtoul(argv[4], NULL, 10));
	}

	return 0;
}

static int do_ui_update(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	if (!ui_inited) {
		printf("error: ui init first\n");
		return -1;
	} else {
		screen_update();
	}

	return 0;
}

static int do_ui_uinit(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	int i;

	if (!ui_inited) {
		printf("error: ui init first\n");
		return -1;
	} else {
		for (i =0; i < ARRAY_SIZE(lib_font); i++) {
			if (lib_font[i].font) {
				if (lib_font[i].font->texture) {
					free(lib_font[i].font->texture);
					lib_font[i].font->texture = NULL;
				}
				free(lib_font[i].font);
				lib_font[i].font = NULL;
			}
		}

		for (i =0; i < ARRAY_SIZE(pic_surface); i++) {
			if (pic_surface[i].surface) {
				free(pic_surface[i].surface);
				pic_surface[i].surface = NULL;
			}
		}

		set_fastboot_flag(0);
		screen_uninit();

		ui_inited = 0;
	}

	return 0;
}

static int do_ui_debug(cmd_tbl_t *cmdtp, int flag, int argc,
		       char *const argv[])
{
	if (argc != 2)
		return -1;
	else
		ui_log_level = simple_strtoul(argv[1], NULL, 10);

	return 0;
}


static cmd_tbl_t cmd_ui_sub[] = {
	U_BOOT_CMD_MKENT(init, 2, 0, do_ui_init, "", ""),
	U_BOOT_CMD_MKENT(pic, 9, 0, do_ui_pic, "", ""),
	U_BOOT_CMD_MKENT(setcolor, 3, 0, do_ui_setcolor, "", ""),
	U_BOOT_CMD_MKENT(text, 7, 0, do_ui_text, "", ""),
	U_BOOT_CMD_MKENT(rect, 6, 0, do_ui_rect, "", ""),
	U_BOOT_CMD_MKENT(update, 2, 0, do_ui_update, "", ""),
	U_BOOT_CMD_MKENT(uinit, 2, 0, do_ui_uinit, "", ""),
	U_BOOT_CMD_MKENT(debug, 2, 0, do_ui_debug, "", ""),
};

static int do_ui(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'osd' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_ui_sub[0], ARRAY_SIZE(cmd_ui_sub));

	if (c)
		return  c->cmd(cmdtp, flag, argc, argv);
	else
		return CMD_RET_USAGE;
}

U_BOOT_CMD(
	ui,	9,	1,	do_ui,
	"ui sub-system",
	"init                                        - init device and init default font lib\n"
	"ui pic <name> <srcX srcY> <destX destY>        - blit pic to framebuffer\n"
	"ui setcolor  <color>                           - set color\n"
	"ui text <lib_font> <string> <x y> [bold]       - fill text to framebuffer\n"
	"ui rect <x y> <w h>                            - fill rect to framebuffer\n"
	"ui update                                      - update framebuffer to screen\n"
	"uinit                                          - uinit device and free space\n"
	"ui debug <level>                               - set log level\n"
);

