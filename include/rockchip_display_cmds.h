/*----------------------------------------------------------------------------*/
/*
	ODROIDGO2 LCD control commands
*/
/*----------------------------------------------------------------------------*/
#ifndef _ROCKCHIP_DISPLAY_CMDS_H_
#define _ROCKCHIP_DISPLAY_CMDS_H_

/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
#define LCD_COLOR_RED		0x00ff0000
#define LCD_COLOR_GREEN		0x0000ff00
#define LCD_COLOR_YELLOW	0x00ffff00
#define LCD_COLOR_BLUE		0x000000ff
#define LCD_COLOR_MAGENTA	0x00ff00ff
#define LCD_COLOR_CYAN		0x0000ffff
#define LCD_COLOR_GREY		0x00aaaaaa
#define LCD_COLOR_BLACK		0x00000000
#define LCD_COLOR_WHITE		0x00ffffff	/* Must remain last / highest */
/*----------------------------------------------------------------------------*/
#define	LCD_ROTATE_0		0
#define	LCD_ROTATE_90		1
#define	LCD_ROTATE_180		2
#define	LCD_ROTATE_270		3

#define	DEFAULT_LCD_ROTATE	LCD_ROTATE_270

/*----------------------------------------------------------------------------*/
/* Max logo bmp file is 1M bytes, only support format is 320x480x24bpp bitmap */
/*----------------------------------------------------------------------------*/
#define	LCD_LOGO_FILENAME	"logo.bmp"
#define	LCD_LOGO_SIZE		(1024 * 1024)

/*----------------------------------------------------------------------------*/
/* LCD frame buffer is bgr format (24 bits) */
/*----------------------------------------------------------------------------*/
struct lcd_fb_bit {
	unsigned char b;
	unsigned char g;
	unsigned char r;
};

/*----------------------------------------------------------------------------*/
/* VIDEO Frame buffer is ARGB Format (32 bits) */
/*----------------------------------------------------------------------------*/
struct video_fb_bit {
	unsigned char b;
	unsigned char g;
	unsigned char r;
	unsigned char a;
};

/*----------------------------------------------------------------------------*/
struct lcd {
	struct udevice *udev_video;
	struct udevice *udev_vidcon;
	struct display_state *s;
	unsigned long drm_fb_mem;
	unsigned long drm_fb_size;
	unsigned int w;
	unsigned int h;
	unsigned int bpp;
	struct lcd_fb_bit fg_color;
	struct lcd_fb_bit bg_color;
	unsigned char rot;
	bool bgr;
	bool transp;
};

/*----------------------------------------------------------------------------*/
int lcd_getrot(void);
int lcd_init(void);
int lcd_onoff(bool onoff);
int lcd_setcur(unsigned long x, unsigned long y);
int lcd_setline(unsigned long line);
int lcd_putstr(const char *str);
int lcd_clear(void);
int lcd_clrline(unsigned long line);
int lcd_setfg(unsigned long r, unsigned long g, unsigned long b);
int lcd_setbg(unsigned long r, unsigned long g, unsigned long b);
void lcd_sync(void);
int lcd_printf(unsigned long x, unsigned long y, unsigned char align,
	const char *fmt, ...);
int show_bmp(unsigned long bmp_mem);
struct lcd_fb_bit *lcd_getfg(void);
struct lcd_fb_bit *lcd_getbg(void);
int lcd_setfg_color(const char *color);
int lcd_setbg_color(const char *color);
int lcd_settransp(unsigned long transp);
int lcd_gettransp(void);
int lcd_show_logo(void);
unsigned long lcd_get_mem(void);

/*----------------------------------------------------------------------------*/
#endif	// #define _ROCKCHIP_DISPLAY_CMDS_H_
/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
