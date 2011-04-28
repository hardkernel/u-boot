/*
 * Amlogic OSD
 * frame buffer driver
 *
 * Copyright (C) 2009 Amlogic, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 * Author:	Tim Yao <timyao@amlogic.com>
 *
 */

#ifndef OSD_H
#define OSD_H
#include <asm/arch/fb.h>

typedef  enum {
	COLOR_INDEX_NULL = 0,
		
	COLOR_INDEX_02_PAL4    = 2,  // 0
    	COLOR_INDEX_04_PAL16   = 4, // 0
	COLOR_INDEX_08_PAL256=8,
	COLOR_INDEX_16_655 =9,
	COLOR_INDEX_16_844 =10,
	COLOR_INDEX_16_6442 =11 ,
	COLOR_INDEX_16_4444_R = 12,
	COLOR_INDEX_16_4642_R = 13,
	COLOR_INDEX_16_1555_A=14,
	COLOR_INDEX_16_4444_A = 15,
	COLOR_INDEX_16_565 =16,
	
	COLOR_INDEX_24_6666_A=19,
	COLOR_INDEX_24_6666_R=20,
	COLOR_INDEX_24_8565 =21,
	COLOR_INDEX_24_5658 = 22,
	COLOR_INDEX_24_888_B = 23,
	COLOR_INDEX_24_RGB = 24,

	COLOR_INDEX_32_BGRA=29,
	COLOR_INDEX_32_ABGR = 30,
	COLOR_INDEX_32_RGBA=31,
	COLOR_INDEX_32_ARGB=32,

	COLOR_INDEX_YUV_422=33,
	
}color_index_t;



typedef  struct {
	color_index_t	color_index;
	u8	hw_colormat;
	u8	hw_blkmode;

	u8	red_offset ;
	u8	red_length;
	u8	red_msb_right;
	
	u8	green_offset;
	u8	green_length;
	u8	green_msb_right;

	u8	blue_offset;
	u8	blue_length;
	u8	blue_msb_right;

	u8	transp_offset;
	u8	transp_length;
	u8	transp_msb_right;

	u8	color_type;
	u8	bpp;

		
	
}color_bit_define_t;
typedef struct osd_ctl_s {
    u32  xres_virtual;
    u32  yres_virtual;
    u32  xres;
    u32  yres;
    u32  disp_start_x; //coordinate of screen 
    u32  disp_start_y;
    u32  disp_end_x;
    u32  disp_end_y;
    u32  addr;
    u32  index;
} osd_ctl_t;
#define  INVALID_BPP_ITEM    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

static const  color_bit_define_t   default_color_format_array[]={
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{COLOR_INDEX_02_PAL4,0,0,/*red*/ 0,2,0,/*green*/0,2,0,/*blue*/0,2,0,/*trans*/0,0,0,FB_VISUAL_PSEUDOCOLOR,2},
	INVALID_BPP_ITEM,	
	{COLOR_INDEX_04_PAL16,0,1,/*red*/ 0,4,0,/*green*/0,4,0,/*blue*/0,4,0,/*trans*/0,0,0,FB_VISUAL_PSEUDOCOLOR,4},
	INVALID_BPP_ITEM,	
	INVALID_BPP_ITEM,	
	INVALID_BPP_ITEM,	
	{COLOR_INDEX_08_PAL256,0,2,/*red*/ 0,8,0,/*green*/0,8,0,/*blue*/0,8,0,/*trans*/0,0,0,FB_VISUAL_PSEUDOCOLOR,8},
/*16 bit color*/
	{COLOR_INDEX_16_655,0,4,/*red*/ 10,6,0,/*green*/5,5,0,/*blue*/0,5,0,/*trans*/0,0,0,FB_VISUAL_TRUECOLOR,16},
	{COLOR_INDEX_16_844,1,4,/*red*/ 8,8,0,/*green*/4,4,0,/*blue*/0,4,0,/*trans*/0,0,0,FB_VISUAL_TRUECOLOR,16},
	{COLOR_INDEX_16_6442,2,4,/*red*/ 10,6,0,/*green*/6,4,0,/*blue*/2,4,0,/*trans*/0,2,0,FB_VISUAL_TRUECOLOR,16},
	{COLOR_INDEX_16_4444_R,3,4,/*red*/ 12,4,0,/*green*/8,4,0,/*blue*/4,4,0,/*trans*/0,4,0,FB_VISUAL_TRUECOLOR,16,},
	{COLOR_INDEX_16_4642_R,7,4,/*red*/ 12,4,0,/*green*/6,6,0,/*blue*/2,4,0,/*trans*/0,2,0,FB_VISUAL_TRUECOLOR,16},
	{COLOR_INDEX_16_1555_A,6,4,/*red*/ 10,5,0,/*green*/5,5,0,/*blue*/0,5,0,/*trans*/15,1,0,FB_VISUAL_TRUECOLOR,16},
	{COLOR_INDEX_16_4444_A,5,4,/*red*/ 8,4,0,/*green*/4,4,0,/*blue*/0,4,0,/*trans*/12,4,0,FB_VISUAL_TRUECOLOR,16},
	{COLOR_INDEX_16_565,4,4,/*red*/ 11,5,0,/*green*/5,6,0,/*blue*/0,5,0,/*trans*/0,0,0,FB_VISUAL_TRUECOLOR,16},
/*24 bit color*/
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{COLOR_INDEX_24_6666_A,4,7,/*red*/ 12,6,0,/*green*/6,6,0,/*blue*/0,6,0,/*trans*/18,6,0,FB_VISUAL_TRUECOLOR,24},
	{COLOR_INDEX_24_6666_R,3,7,/*red*/ 18,6,0,/*green*/12,6,0,/*blue*/6,6,0,/*trans*/0,6,0,FB_VISUAL_TRUECOLOR,24},
	{COLOR_INDEX_24_8565,2,7,/*red*/ 11,5,0,/*green*/5,6,0,/*blue*/0,5,0,/*trans*/16,8,0,FB_VISUAL_TRUECOLOR,24},
	{COLOR_INDEX_24_5658,1,7,/*red*/ 19,5,0,/*green*/13,6,0,/*blue*/8,5,0,/*trans*/0,8,0,FB_VISUAL_TRUECOLOR,24},
	{COLOR_INDEX_24_888_B,5,7,/*red*/ 0,8,0,/*green*/8,8,0,/*blue*/16,8,0,/*trans*/0,0,0,FB_VISUAL_TRUECOLOR,24},
	{COLOR_INDEX_24_RGB,0,7,/*red*/ 16,8,0,/*green*/8,8,0,/*blue*/0,8,0,/*trans*/0,0,0,FB_VISUAL_TRUECOLOR,24},
/*32 bit color*/
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{COLOR_INDEX_32_BGRA,3,5,/*red*/ 8,8,0,/*green*/16,8,0,/*blue*/24,8,0,/*trans*/0,8,0,FB_VISUAL_TRUECOLOR,32},
	{COLOR_INDEX_32_ABGR,2,5,/*red*/ 0,8,0,/*green*/8,8,0,/*blue*/16,8,0,/*trans*/24,8,0,FB_VISUAL_TRUECOLOR,32},
	{COLOR_INDEX_32_RGBA,0,5,/*red*/ 24,8,0,/*green*/16,8,0,/*blue*/8,8,0,/*trans*/0,8,0,FB_VISUAL_TRUECOLOR,32},
	{COLOR_INDEX_32_ARGB,1,5,/*red*/ 16,8,0,/*green*/8,8,0,/*blue*/0,8,0,/*trans*/24,8,0,FB_VISUAL_TRUECOLOR,32},
/*YUV color*/
	{COLOR_INDEX_YUV_422,0,3,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,16},
};

typedef struct reg_val_pair{
    uint reg;
    uint val;
} reg_val_pair_t;	
	
#define OSD_TYPE_32_RGBA    0
#define OSD_TYPE_32_ARGB    1
#define OSD_TYPE_24_RGB     2
#define OSD_TYPE_16_RGB565  3

int osd_create(unsigned osd_addr, unsigned type, int left, int top, int width, int height);
void osd_close(void);

/* osd draw function */
void osd_draw_pixel(int x, int y, unsigned color);
void osd_draw_hline(int x, int y, int w, unsigned color);
void osd_draw_vline(int x, int y, int h, unsigned color);
void osd_draw_line(int x1, int y1, int x2, int y2, unsigned color);
void osd_draw_rect(int x, int y, int w, int h, unsigned color);
void osd_fill_rect(int x, int y, int w, int h, unsigned color);
void osd_clear_rect(int x, int y, int w, int h);
void osd_draw_font(int x, int y, int width, int height, int font_height, int font_width, int actual_width, void *font_data, unsigned font_color);
void osd_draw_bitmap(int x, int y, int width, int height, int bmp_left, int bmp_top, int bmp_width, int bmp_height, unsigned char *bmp_data);

#endif /* OSD1_H */
