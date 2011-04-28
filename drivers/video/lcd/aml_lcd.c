#include <common.h>
#include <stdio_dev.h>
#include <amlogic/aml_lcd.h>
#include <video_fb.h>
#include <amlogic/vinfo.h>

/************************************************************************/
/* ** FONT DATA								*/
/************************************************************************/
#include <video_font.h>		/* Get font data, width and height	*/

extern vidinfo_t panel_info;

DECLARE_GLOBAL_DATA_PTR;

static unsigned long lcd_line_length = 0;
char lcd_is_enabled = 0;

int lcd_getbgcolor (void);
void lcd_setfgcolor (int color);
void lcd_setbgcolor (int color);
#ifdef LCD_TEST_PATTERN
static void test_pattern(void);
#endif

/************************************************************************/
/* ** LOGO DATA								*/
/************************************************************************/
#ifdef CONFIG_LCD_LOGO
# include <bmp_logo.h>		/* Get logo data, width and height	*/
# if (CONSOLE_COLOR_WHITE >= BMP_LOGO_OFFSET) && (LCD_BPP != LCD_COLOR16)
#  error Default Color Map overlaps with Logo Color Map
# endif
#endif

ulong lcd_setmem (ulong addr);

static inline void lcd_puts_xy (ushort x, ushort y, uchar *s);
static inline void lcd_putc_xy (ushort x, ushort y, uchar  c);


void *lcd_logo (void);

/***************************************************************************************/
/* LCD display driver */
/****************************************************************************************/
#if 0
int lcd_getfontwidth()
{
    return VIDEO_FONT_WIDTH;
}

int lcd_getfontheight()
{
    return VIDEO_FONT_HEIGHT;
}
#endif
/*----------------------------------------------------------------------*/

static void console_scrollup (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	/* Copy up rows ignoring the first one */
	memcpy (CONSOLE_ROW_FIRST, CONSOLE_ROW_SECOND, CONSOLE_SCROLL_SIZE);

	/* Clear the last one */
	memset (CONSOLE_ROW_LAST, COLOR_MASK(info->vd_color_bg), CONSOLE_ROW_SIZE);
}

/*----------------------------------------------------------------------*/

static inline void console_back (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	if (--(info->console_col) < 0) {
		info->console_col = CONSOLE_COLS-1 ;
		if (--info->console_row < 0) {
			info->console_row = 0;
		}
	}

	lcd_putc_xy (info->console_col * VIDEO_FONT_WIDTH,
		     info->console_row * VIDEO_FONT_HEIGHT,
		     ' ');
}

/*----------------------------------------------------------------------*/

static inline void console_newline (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	++info->console_row;
	info->console_col = 0;

	/* Check if we need to scroll the terminal */
	if (info->console_row >= CONSOLE_ROWS) {
		/* Scroll everything up */
		console_scrollup () ;
		--info->console_row;
	}
}

/*----------------------------------------------------------------------*/

void lcd_putc (const char c)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	if (!lcd_is_enabled) {
		serial_putc(c);
		return;
	}

	switch (c) {
	case '\r':	info->console_col = 0;
			return;

	case '\n':	console_newline();
			return;

	case '\t':	/* Tab (8 chars alignment) */
			info->console_col +=  8;
			info->console_col &= ~7;

			if (info->console_col >= CONSOLE_COLS) {
				console_newline();
			}
			return;

	case '\b':	console_back();
			return;

	default:	lcd_putc_xy (info->console_col * VIDEO_FONT_WIDTH,
				     info->console_row * VIDEO_FONT_HEIGHT,
				     c);
			if (++info->console_col >= CONSOLE_COLS) {
				console_newline();
			}
			return;
	}
	/* NOTREACHED */
}

/*----------------------------------------------------------------------*/

void lcd_puts (const char *s)
{
	if (!lcd_is_enabled) {
		serial_puts (s);
		return;
	}
	while (*s) {
		lcd_putc (*s++);
	}
}

/*----------------------------------------------------------------------*/

void lcd_printf(const char *fmt, ...)
{
	va_list args;
	char buf[CONFIG_SYS_PBSIZE];

	va_start(args, fmt);
	vsprintf(buf, fmt, args);
	va_end(args);

	lcd_puts(buf);
}

/************************************************************************/
/* ** Low-Level Graphics Routines					*/
/************************************************************************/

#if 0
int lcd_draw_point (ushort x, ushort y, int color)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

    uchar *dest;
	
	if((x > info->vl_col) || (y > info->vl_row)) {
		return	-1;
	}

	dest = (uchar *)(info->vd_base + y * lcd_line_length + x * (LCD_BPP / 8));
#if(LCD_BPP == LCD_COLOR24)
	*dest++ = color & 0xff;
	*dest++ = (color >> 8) & 0xff;
	*dest = (color >> 16) & 0xff;
#endif
	flush_cache((unsigned long)info->vd_base, info->vl_col*info->vl_row*info->vl_bpix/8);
	return	0;
}
int lcd_draw_rect (ushort x, ushort y, ushort w, ushort h, int color)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

    uchar *dest;
	ushort row, col;
	if((x > info->vl_col) || (y > info->vl_row)) {
		return	-1;
	}

	if((w < 0) || (h < 0)) {
		return -1;
	}

	dest = (uchar *)(info->vd_base + y * lcd_line_length + x * (LCD_BPP / 8));
	for(row=0; row<h; row++) {
		for(col=0; col<w; col++) {
#if(LCD_BPP == LCD_COLOR24)
			*dest++ = color & 0xff;
			*dest++ = (color >> 8) & 0xff;
			*dest++ = (color >> 16) & 0xff;
#endif
		}
		dest = (uchar *)(info->vd_base + (y + row) * lcd_line_length + x * (LCD_BPP / 8));
	}
	flush_cache((unsigned long)info->vd_base, info->vl_col*info->vl_row*info->vl_bpix/8);
	return	0;
}
#endif

int lcd_drawchars (ushort x, ushort y, uchar *str, int count)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	uchar *dest;
	ushort off, row;

	if((x > info->vl_col) || (y > info->vl_row))
	{
		return	-1;
	}

	dest = (uchar *)(info->vd_base + y * lcd_line_length + x * (LCD_BPP / 8));
	off  = x * LCD_BPP % 8;
	//printf("info->vd_base:0x%x; lcd_line_length:%d; LCD_BPP:%d; dest: 0x%x\n", info->vd_base, lcd_line_length, LCD_BPP, dest);
	for (row=0;  row < VIDEO_FONT_HEIGHT;  ++row, dest += lcd_line_length)  {
		uchar *s = str;
		int i;

#if(LCD_BPP == LCD_COLOR16)
		ushort *d = (ushort *)dest;
#else
		uchar *d = dest;
#endif

#if(LCD_BPP == LCD_MONOCHROME)
		uchar rest = *d & -(1 << (8-off));
		uchar sym;
#endif
		for (i=0; i<count; ++i) {
			uchar c, bits;

			c = *s++;
			bits = video_fontdata[c * VIDEO_FONT_HEIGHT + row];
			//printf("c: %d;	row: %d;	bits: 0x%x\n", c, row, bits);

#if(LCD_BPP == LCD_MONOCHROME)
			sym  = (COLOR_MASK(info->vd_color_fg) & bits) |
			       (COLOR_MASK(info->vd_color_bg) & ~bits);

			*d++ = rest | (sym >> off);
			rest = sym << (8-off);
#elif(LCD_BPP == LCD_COLOR8)
			for (c=0; c<8; ++c) {
				*d++ = (bits & 0x80) ?
						info->vd_color_fg : info->vd_color_bg;
				bits <<= 1;
			}
#elif(LCD_BPP == LCD_COLOR16)
			for (c=0; c<8; ++c) {
				*d++ = (bits & 0x80) ?
						info->vd_color_fg : info->vd_color_bg;
				bits <<= 1;
			}
#elif(LCD_BPP == LCD_COLOR24)
			for (c=0; c<8; ++c) {
				if(bits & 0x80)
				{
					*d++ = (info->vd_color_fg >> 16) & 0xff;
					*d++ = (info->vd_color_fg >> 8) & 0xff;
					*d++ = info->vd_color_fg & 0xff;
				}
				else
				{
					*d++ = (info->vd_color_bg >> 16) & 0xff;
					*d++ = (info->vd_color_bg >> 8) & 0xff;
					*d++ = info->vd_color_bg & 0xff;
				}
				bits <<= 1;
			}
#endif	

		}
		
#if LCD_BPP == LCD_MONOCHROME
		*d  = rest | (*d & ((1 << (8-off)) - 1));
#endif
	flush_cache((unsigned long)info->vd_base, info->vl_col*info->vl_row*info->vl_bpix/8);
	}
	return 0;
}

#if 0
int lcd_drawstring(uchar *text, unsigned len, unsigned short x, unsigned short y, int fg_color, int bg_color)
{
    lcd_setfgcolor(fg_color);
	lcd_setbgcolor(bg_color);
    return lcd_drawchars(x, y, text, len);
}
#endif
/*----------------------------------------------------------------------*/

static inline void lcd_puts_xy (ushort x, ushort y, uchar *s)
{
#if defined(CONFIG_LCD_LOGO) && !defined(CONFIG_LCD_INFO_BELOW_LOGO)
	lcd_drawchars (x, y+BMP_LOGO_HEIGHT, s, strlen ((char *)s));
#else
	lcd_drawchars (x, y, s, strlen ((char *)s));
#endif
}

/*----------------------------------------------------------------------*/

static inline void lcd_putc_xy (ushort x, ushort y, uchar c)
{
#if defined(CONFIG_LCD_LOGO) && !defined(CONFIG_LCD_INFO_BELOW_LOGO)
	lcd_drawchars (x, y+BMP_LOGO_HEIGHT, &c, 1);
#else
	lcd_drawchars (x, y, &c, 1);
#endif
}

int drv_lcd_init (void)
{
	struct stdio_dev lcddev;
	int rc;

	aml_lcd_init ();		/* LCD initialization */

	/* Device initialization */
	memset (&lcddev, 0, sizeof (lcddev));

	strcpy (lcddev.name, "lcd");
	lcddev.ext   = 0;			/* No extensions */
	lcddev.flags = DEV_FLAGS_OUTPUT;	/* Output only */
	lcddev.putc  = lcd_putc;		/* 'putc' function */
	lcddev.puts  = lcd_puts;		/* 'puts' function */

	rc = stdio_register (&lcddev);

#if defined(CONFIG_AML_MESON_8)	
	panel_oper.bl_on();
#endif
	
	return (rc == 0) ? 1 : rc;
}

/************************************************************************/
/**  Small utility to check that you got the colours right		*/
/************************************************************************/

#ifdef LCD_TEST_PATTERN

#define	N_BLK_VERT	2
#define	N_BLK_HOR	3

static int test_colors[N_BLK_HOR*N_BLK_VERT] = {
	CONSOLE_COLOR_RED,	CONSOLE_COLOR_GREEN,	CONSOLE_COLOR_YELLOW,
	CONSOLE_COLOR_BLUE,	CONSOLE_COLOR_MAGENTA,	CONSOLE_COLOR_CYAN,
};

static void test_pattern (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	ushort v_max  = info->vl_row;
	ushort h_max  = info->vl_col;
	ushort v_step = (v_max + N_BLK_VERT - 1) / N_BLK_VERT;
	ushort h_step = (h_max + N_BLK_HOR  - 1) / N_BLK_HOR;
	ushort v, h;
	uchar *pix = (uchar *)info->vd_base;

	printf ("[LCD] Test Pattern: %d x %d [%d x %d]\n",
		h_max, v_max, h_step, v_step);

	/* WARNING: Code silently assumes 8bit/pixel */
	for (v=0; v<v_max; ++v) {
		uchar iy = v / v_step;
		for (h=0; h<h_max; ++h) {
			uchar ix = N_BLK_HOR * iy + (h/h_step);
			*pix++ = ((test_colors[ix]>>16)&0xff);
			*pix++ = ((test_colors[ix]>>8)&0xff);
			*pix++ = ((test_colors[ix])&0xff);
		}
	}
}
#endif /* LCD_TEST_PATTERN */



/************************************************************************************************/
/* LCD command */
/************************************************************************************************/
#ifdef CONFIG_CMD_ADC_POWER_KEY

static int do_lcdoptcmd(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{

	if (argc  < 2){
		printf("too fill args\n");
	}
	if(strcmp(argv[0], "enable") == 0)
	{
		lcd_is_enabled = 1;
		panel_oper.enable();
	}
	else if(strcmp(argv[0], "disable") == 0)
	{
		lcd_is_enabled = 0;
		panel_oper.disable();
	}
	else if(strcmp(argv[0], "bl_on") == 0)
	{
		panel_oper.bl_on();
	}
	else if(strcmp(argv[0], "bl_off") == 0)
	{
		panel_oper.bl_off();
	}
	else if(strcmp(argv[0], "set_bl_level") == 0)
	{
		panel_oper.set_bl_level(simple_strtoul(argv[1], NULL, 10));
	}
	else if(strcmp(argv[0], "test") == 0)
	{
#ifdef LCD_TEST_PATTERN
		test_pattern();
#endif
		printf("LCD Test!\n");    
		lcd_printf("\n");
		lcd_printf("   D   \n");
		lcd_printf("lcd_test: FILE:%s:%d, FUNC:%s\n",\
                                                     __FILE__,__LINE__,__func__);
	}
	else if (strcmp(argv[0], "info") == 0)
	{
		panel_oper.info();
	}
	else
	{
		printf("Current device is panel.\n");
		panel_oper.bl_on();
		//opt_cmd_help();
		return 1;
	}
	return 0;
}

U_BOOT_CMD(
	lcdctl, 3, 1, do_lcdoptcmd,
	"Help:\n",
	"enable	-enable lcd\n"
	"bl_on	-lcd backlight on"
	"bl_off	-lcd backlight off\n"
);
/*
U_BOOT_CMD(
	lcdctl, 3, 1, do_lcdoptcmd,
	"Help:\n"
	"enable	-enable lcd\n"
	"disable	-disable lcd\n"
	"bl_on	-lcd backlight on\n"
	"bl_off	-lcd backlight off\n"
	"set_bl_level <level>	-set backlight level\n"
	"test	-test lcd display\n"
);
*/
#endif

static void opt_cmd_help(void)
{
	printf("Help:\n");
	printf("enable	-enable lcd\n");
	printf("disable	-disable lcd\n");
	printf("bl_on	-lcd backlight on\n");
	printf("bl_off	-lcd backlight off\n");
	printf("set_bl_level <level>	-set backlight level\n");
	printf("test	-test lcd display\n");
	printf("info	-print lcd driver info\n");
}

int lcd_opt_cmd(int argc, char * const argv[])
{
	if(strcmp(argv[0], "enable") == 0)
	{
		lcd_is_enabled = 1;
		panel_oper.enable();
	}
	else if(strcmp(argv[0], "disable") == 0)
	{
		lcd_is_enabled = 0;
		panel_oper.disable();
	}
	else if(strcmp(argv[0], "bl_on") == 0)
	{
		panel_oper.bl_on();
	}
	else if(strcmp(argv[0], "bl_off") == 0)
	{
		panel_oper.bl_off();
	}
	else if(strcmp(argv[0], "set_bl_level") == 0)
	{
		panel_oper.set_bl_level(simple_strtoul(argv[1], NULL, 10));
	}
	else if(strcmp(argv[0], "test") == 0)
	{
#ifdef LCD_TEST_PATTERN
		test_pattern();

		printf("LCD Test!\n");    
		lcd_printf("\n");
		lcd_printf("   D   \n");
		lcd_printf("lcd_test: FILE:%s:%d, FUNC:%s\n",\
                                                     __FILE__,__LINE__,__func__);
#else
		panel_oper.test(simple_strtoul(argv[1], NULL, 10));
#endif
	}
	else if (strcmp(argv[0], "info") == 0)
	{
		panel_oper.info();
	}
	else
	{
		printf("Current device is panel.\n");
		opt_cmd_help();
		return 1;
	}
	return 0;
}

/*=================================================================================
// LCD initialize
=================================================================================*/
int aml_lcd_init(void)
{	
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

		panel_oper.enable();
		lcd_line_length = (info->vl_col * NBITS (info->vl_bpix)) / 8;
		lcd_is_enabled = 1;		
		/* lcd clear*/
		memset ((char *)info->vd_base,	COLOR_MASK(lcd_getbgcolor()),
									lcd_line_length*info->vl_row);
		flush_cache((unsigned long)info->vd_base, lcd_line_length*info->vl_row);					
					
		/* Initialize the console */
	info->console_col = 0;
#ifdef CONFIG_LCD_INFO_BELOW_LOGO
	info->console_row = 7 + BMP_LOGO_HEIGHT / VIDEO_FONT_HEIGHT;
#else
	info->console_row = 1;	/* leave 1 blank line below logo */
#endif
	printf("LCD:	%dx%d %dbbp\n", info->vl_col, info->vl_row, info->vl_bpix);
	return 0;
}
/************************************************************************/
/* ** ROM capable initialization part - needed to reserve FB memory	*/
/************************************************************************/
/*
 * This is called early in the system initialization to grab memory
 * for the LCD controller.
 * Returns new address for monitor, after reserving LCD buffer memory
 *
 * Note that this is running from ROM, so no write access to global data.
 */
ulong lcd_setmem (ulong addr)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	ulong size;
	int line_length = (info->vl_col * NBITS (info->vl_bpix)) / 8;

	debug ("LCD panel info: %d x %d, %d bit/pix\n",
		info->vl_col, info->vl_row, NBITS (info->vl_bpix) );

	size = line_length * info->vl_row;

	/* Round up to nearest full page */
	size = (size + (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);

	/* Allocate pages for the frame buffer. */
	addr -= size;

	debug ("Reserving %ldk for LCD Framebuffer at: %08lx\n", size>>10, addr);
	info->vd_base = (void*)addr;
	info->vd_console_address=(void*)addr;
	
	return (addr);
}

/*----------------------------------------------------------------------*/

void lcd_setfgcolor (int color)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	info->vd_color_fg = color;
}

/*----------------------------------------------------------------------*/

void lcd_setbgcolor (int color)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	info->vd_color_bg = color;
}

/*----------------------------------------------------------------------*/

int lcd_getfgcolor (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	return info->vd_color_fg;
}

/*----------------------------------------------------------------------*/

int lcd_getbgcolor (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

	return info->vd_color_bg;
}

#if	0
/************************************************************************/
/* ** Chipset depending Bitmap / Logo stuff...                          */
/************************************************************************/
#ifdef CONFIG_LCD_LOGO
void bitmap_plot (int x, int y)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

#ifdef CONFIG_ATMEL_LCD
	uint *cmap;
#else
	ushort *cmap;
#endif
	ushort i, j;
	uchar *bmap;
	uchar *fb;
	ushort *fb16;
#if defined(CONFIG_PXA250)
	struct pxafb_info *fbi = &info->pxa;
#elif defined(CONFIG_MPC823)
	volatile immap_t *immr = (immap_t *) CONFIG_SYS_IMMR;
	volatile cpm8xx_t *cp = &(immr->im_cpm);
#endif

	debug ("Logo: width %d  height %d  colors %d  cmap %d\n",
		BMP_LOGO_WIDTH, BMP_LOGO_HEIGHT, BMP_LOGO_COLORS,
		(int)(sizeof(bmp_logo_palette)/(sizeof(ushort))));

	bmap = &bmp_logo_bitmap[0];
	fb   = (uchar *)(vd_base + y * lcd_line_length + x);

	if (NBITS(info->vl_bpix) < 12) {
		/* Leave room for default color map */
#if defined(CONFIG_PXA250)
		cmap = (ushort *)fbi->palette;
#elif defined(CONFIG_MPC823)
		cmap = (ushort *)&(cp->lcd_cmap[BMP_LOGO_OFFSET*sizeof(ushort)]);
#elif defined(CONFIG_ATMEL_LCD)
		cmap = (uint *) (info->mmio + ATMEL_LCDC_LUT(0));
#else
		/*
		 * default case: generic system with no cmap (most likely 16bpp)
		 * We set cmap to the source palette, so no change is done.
		 * This avoids even more ifdef in the next stanza
		 */
		cmap = bmp_logo_palette;
#endif

		WATCHDOG_RESET();

		/* Set color map */
		for (i=0; i<(sizeof(bmp_logo_palette)/(sizeof(ushort))); ++i) {
			ushort colreg = bmp_logo_palette[i];
#ifdef CONFIG_ATMEL_LCD
			uint lut_entry;
#ifdef CONFIG_ATMEL_LCD_BGR555
			lut_entry = ((colreg & 0x000F) << 11) |
				    ((colreg & 0x00F0) <<  2) |
				    ((colreg & 0x0F00) >>  7);
#else /* CONFIG_ATMEL_LCD_RGB565 */
			lut_entry = ((colreg & 0x000F) << 1) |
				    ((colreg & 0x00F0) << 3) |
				    ((colreg & 0x0F00) << 4);
#endif
			*(cmap + BMP_LOGO_OFFSET) = lut_entry;
			cmap++;
#else /* !CONFIG_ATMEL_LCD */
#ifdef  CONFIG_SYS_INVERT_COLORS
			*cmap++ = 0xffff - colreg;
#else
			*cmap++ = colreg;
#endif
#endif /* CONFIG_ATMEL_LCD */
		}

		WATCHDOG_RESET();

		for (i=0; i<BMP_LOGO_HEIGHT; ++i) {
			memcpy (fb, bmap, BMP_LOGO_WIDTH);
			bmap += BMP_LOGO_WIDTH;
			fb   += info->vl_col;
		}
	}
	else { /* true color mode */
		u16 col16;
		fb16 = (ushort *)(vd_base + y * lcd_line_length + x);
		for (i=0; i<BMP_LOGO_HEIGHT; ++i) {
			for (j=0; j<BMP_LOGO_WIDTH; j++) {
				col16 = bmp_logo_palette[(bmap[j]-16)];
				fb16[j] =
					((col16 & 0x000F) << 1) |
					((col16 & 0x00F0) << 3) |
					((col16 & 0x0F00) << 4);
				}
			bmap += BMP_LOGO_WIDTH;
			fb16 += info->vl_col;
		}
	}

	WATCHDOG_RESET();
}
#endif /* CONFIG_LCD_LOGO */
#endif

/*----------------------------------------------------------------------*/
#if defined(CONFIG_CMD_BMP) || defined(CONFIG_SPLASH_SCREEN)
/*
 * Display the BMP file located at address bmp_image.
 * Only uncompressed.
 */

#ifdef CONFIG_SPLASH_SCREEN_ALIGN
#define BMP_ALIGN_CENTER	0x7FFF
#endif

void *lcd_logo (void)
{
    vidinfo_t * info = NULL;
#if defined CONFIG_VIDEO_AMLLCD
    extern vidinfo_t panel_info;
    info = & panel_info;
#endif
#if defined CONFIG_VIDEO_AMLTVOUT
    extern vidinfo_t tv_info;
    info = & tv_info;
#endif

#ifdef CONFIG_SPLASH_SCREEN
	char *s;
	ulong addr;
	static int do_splash = 1;

	if (do_splash && (s = getenv("splashimage")) != NULL) {
		int x = 0, y = 0;
		do_splash = 0;

		addr = simple_strtoul (s, NULL, 16);
#ifdef CONFIG_SPLASH_SCREEN_ALIGN
		if ((s = getenv ("splashpos")) != NULL) {
			if (s[0] == 'm')
				x = BMP_ALIGN_CENTER;
			else
				x = simple_strtol (s, NULL, 0);

			if ((s = strchr (s + 1, ',')) != NULL) {
				if (s[1] == 'm')
					y = BMP_ALIGN_CENTER;
				else
					y = simple_strtol (s + 1, NULL, 0);
			}
		}
#endif /* CONFIG_SPLASH_SCREEN_ALIGN */

#ifdef CONFIG_VIDEO_BMP_GZIP
		bmp_image_t *bmp = (bmp_image_t *)addr;
		unsigned long len;

		if (!((bmp->header.signature[0]=='B') &&
		      (bmp->header.signature[1]=='M'))) {
			addr = (ulong)gunzip_bmp(addr, &len);
		}
#endif

		if (lcd_display_bitmap (addr, x, y) == 0) {
			return ((void *)info->vd_base);
		}
	}
#endif /* CONFIG_SPLASH_SCREEN */

#ifdef CONFIG_LCD_LOGO
	bitmap_plot (0, 0);
#endif /* CONFIG_LCD_LOGO */

#ifdef CONFIG_LCD_INFO
	info->console_col = LCD_INFO_X / VIDEO_FONT_WIDTH;
	info->console_row = LCD_INFO_Y / VIDEO_FONT_HEIGHT;
	lcd_show_board_info();
#endif /* CONFIG_LCD_INFO */

#if defined(CONFIG_LCD_LOGO) && !defined(CONFIG_LCD_INFO_BELOW_LOGO)
	return ((void *)((ulong)info->vd_base + BMP_LOGO_HEIGHT * lcd_line_length));
#else
	return ((void *)info->vd_base);
#endif /* CONFIG_LCD_LOGO && !CONFIG_LCD_INFO_BELOW_LOGO */
}
#endif


