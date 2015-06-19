/*
 * drivers/osd/osd_fb.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
*/

/* System Headers */
#include <common.h>
#include <video_fb.h>
#include <stdio_dev.h>
#include <malloc.h>
#include <bmp_layout.h>

/* Local Headers */
#include <amlogic/fb.h>
#include <amlogic/color.h>
#include <amlogic/vinfo.h>
#include <amlogic/vout.h>

/* Local Headers */
#include "osd.h"
#include "osd_log.h"
#include "osd_hw.h"

#define INVALID_BPP_ITEM {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
static const struct color_bit_define_s default_color_format_array[] = {
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{
		COLOR_INDEX_02_PAL4, 0, 0,
		0, 2, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0,
		FB_VISUAL_PSEUDOCOLOR, 2,
	},
	INVALID_BPP_ITEM,
	{
		COLOR_INDEX_04_PAL16, 0, 1,
		0, 4, 0, 0, 4, 0, 0, 4, 0, 0, 0, 0,
		FB_VISUAL_PSEUDOCOLOR, 4,
	},
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{
		COLOR_INDEX_08_PAL256, 0, 2,
		0, 8, 0, 0, 8, 0, 0, 8, 0, 0, 0, 0,
		FB_VISUAL_PSEUDOCOLOR, 8,
	},
	/*16 bit color*/
	{
		COLOR_INDEX_16_655, 0, 4,
		10, 6, 0, 5, 5, 0, 0, 5, 0, 0, 0, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_844, 1, 4,
		8, 8, 0, 4, 4, 0, 0, 4, 0, 0, 0, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_6442, 2, 4,
		10, 6, 0, 6, 4, 0, 2, 4, 0, 0, 2, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_4444_R, 3, 4,
		12, 4, 0, 8, 4, 0, 4, 4, 0, 0, 4, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_4642_R, 7, 4,
		12, 4, 0, 6, 6, 0, 2, 4, 0, 0, 2, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_1555_A, 6, 4,
		10, 5, 0, 5, 5, 0, 0, 5, 0, 15, 1, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_4444_A, 5, 4,
		8, 4, 0, 4, 4, 0, 0, 4, 0, 12, 4, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	{
		COLOR_INDEX_16_565, 4, 4,
		11, 5, 0, 5, 6, 0, 0, 5, 0, 0, 0, 0,
		FB_VISUAL_TRUECOLOR, 16
	},
	/*24 bit color*/
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{
		COLOR_INDEX_24_6666_A, 4, 7,
		12, 6, 0, 6, 6, 0, 0, 6, 0, 18, 6, 0,
		FB_VISUAL_TRUECOLOR, 24
	},
	{
		COLOR_INDEX_24_6666_R, 3, 7,
		18, 6, 0, 12, 6, 0, 6, 6, 0, 0, 6, 0,
		FB_VISUAL_TRUECOLOR, 24
	},
	{
		COLOR_INDEX_24_8565, 2, 7,
		11, 5, 0, 5, 6, 0, 0, 5, 0, 16, 8, 0,
		FB_VISUAL_TRUECOLOR, 24
	},
	{
		COLOR_INDEX_24_5658, 1, 7,
		19, 5, 0, 13, 6, 0, 8, 5, 0, 0, 8, 0,
		FB_VISUAL_TRUECOLOR, 24
	},
	{
		COLOR_INDEX_24_888_B, 5, 7,
		0, 8, 0, 8, 8, 0, 16, 8, 0, 0, 0, 0,
		FB_VISUAL_TRUECOLOR, 24
	},
	{
		COLOR_INDEX_24_RGB, 0, 7,
		16, 8, 0, 8, 8, 0, 0, 8, 0, 0, 0, 0,
		FB_VISUAL_TRUECOLOR, 24
	},
	/*32 bit color*/
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	INVALID_BPP_ITEM,
	{
		COLOR_INDEX_32_BGRA, 3, 5,
		8, 8, 0, 16, 8, 0, 24, 8, 0, 0, 8, 0,
		FB_VISUAL_TRUECOLOR, 32
	},
	{
		COLOR_INDEX_32_ABGR, 2, 5,
		0, 8, 0, 8, 8, 0, 16, 8, 0, 24, 8, 0,
		FB_VISUAL_TRUECOLOR, 32
	},
	{
		COLOR_INDEX_32_RGBA, 0, 5,
		24, 8, 0, 16, 8, 0, 8, 8, 0, 0, 8, 0,
		FB_VISUAL_TRUECOLOR, 32
	},
	{
		COLOR_INDEX_32_ARGB, 1, 5,
		16, 8, 0, 8, 8, 0, 0, 8, 0, 24, 8, 0,
		FB_VISUAL_TRUECOLOR, 32
	},
	/*YUV color*/
	{COLOR_INDEX_YUV_422, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16},
};

GraphicDevice fb_gdev;

static void osd_layer_init(GraphicDevice gdev, int layer)
{
	u32 index = layer;
	u32 xoffset = 0;
	u32 yoffset = 0;
	u32 xres = 0;
	u32 yres = 0;
	u32 xres_virtual = 0;
	u32 yres_virtual = 0;
	u32 disp_start_x = 0;
	u32 disp_start_y = 0;
	u32 disp_end_x = 0;
	u32 disp_end_y = 0;
	u32 fbmem = gdev.frameAdrs;
	const struct color_bit_define_s *color =
			&default_color_format_array[gdev.gdfIndex];

#ifdef CONFIG_OSD_SCALE_ENABLE
	xres = gdev.fb_width;
	yres = gdev.fb_height;
	xres_virtual = gdev.fb_width;
	yres_virtual = gdev.fb_height * 2;
	disp_end_x = gdev.fb_width - 1;
	disp_end_y = gdev.fb_height - 1;
#else
	xres = gdev.winSizeX;
	yres = gdev.winSizeY;
	xres_virtual = gdev.winSizeX;
	yres_virtual = gdev.winSizeY * 2;
	disp_end_x = gdev.winSizeX - 1;
	disp_end_y = gdev.winSizeY - 1;
#endif

	osd_init_hw();
	osd_setup_hw(index,
		     xoffset,
		     yoffset,
		     xres,
		     yres,
		     xres_virtual ,
		     yres_virtual,
		     disp_start_x,
		     disp_start_y,
		     disp_end_x,
		     disp_end_y,
		     fbmem,
		     color);
}

static unsigned long env_strtoul(const char *name, int base)
{
	unsigned long ret = 0;
	char *str = NULL;

	str = getenv(name);
	if (str)
		ret = simple_strtoul(str, NULL, base);

	if (base == 16)
		osd_logd("%s: 0x%lx\n", name, ret);
	else if (base == 10)
		osd_logd("%s: %ld\n", name, ret);

	return ret;
}

void *video_hw_init(void)
{
	u32 fb_addr = 0;
	u32 display_width = 0;
	u32 display_height = 0;
	u32 display_bpp = 0;
	u32 color_index = 0;
	u32 fg = 0;
	u32 bg = 0;
	u32 fb_width = 0;
	u32 fb_height = 0;;
	char *layer_str;

	fb_addr = env_strtoul("fb_addr", 16);
#ifdef CONFIG_OSD_SCALE_ENABLE
	fb_width = env_strtoul("fb_width", 10);
	fb_height = env_strtoul("fb_height", 10);
#endif
	display_width = env_strtoul("display_width", 10);
	display_height = env_strtoul("display_height", 10);
	display_bpp = env_strtoul("display_bpp", 10);
	color_index = env_strtoul("display_color_index", 10);
	fg = env_strtoul("display_color_fg", 10);
	bg = env_strtoul("display_color_bg", 10);
	layer_str = getenv("display_layer");

	/* fill in Graphic Device */
	fb_gdev.frameAdrs = fb_addr;
	fb_gdev.fb_width = fb_width;
	fb_gdev.fb_height = fb_height;
	fb_gdev.winSizeX = display_width;
	fb_gdev.winSizeY = display_height;
	fb_gdev.gdfBytesPP = display_bpp / 8;
	fb_gdev.fg = fg;
	fb_gdev.bg = bg;

	if ((color_index < ARRAY_SIZE(default_color_format_array))
	    && (default_color_format_array[color_index].color_index !=
		COLOR_INDEX_NULL))
		fb_gdev.gdfIndex = color_index;
	else {
		osd_loge("color_index %d invalid\n", color_index);
		return NULL;
	}

	if (strcmp(layer_str, "osd1") == 0)
		osd_layer_init(fb_gdev, OSD1);
	else if (strcmp(layer_str, "osd2") == 0)
		osd_layer_init(fb_gdev, OSD2);
	else {
		osd_loge("display_layer(%s) invalid\n", layer_str);
		return NULL;
	}

	return (void *)&fb_gdev;
}

int video_display_bitmap(ulong bmp_image, int x, int y)
{
	vidinfo_t *info = NULL;
#if defined CONFIG_AML_VOUT
	info = vout_get_current_vinfo();
#endif
	ushort *cmap_base = NULL;
	unsigned long byte_width;
	ushort i, j;
	uchar *fb;
	bmp_image_t *bmp = (bmp_image_t *)bmp_image;
	uchar *bmap;
	ushort padded_line;
	unsigned long width, height;
#ifdef CONFIG_OSD_SCALE_ENABLE
	unsigned long pheight = fb_gdev.fb_height;
	unsigned long pwidth = fb_gdev.fb_width;
#else
	unsigned long pwidth = info->vl_col;
#endif
	unsigned colors, bpix, bmp_bpix;
	int lcd_line_length = (pwidth * NBITS(info->vl_bpix)) / 8;
	char *layer_str = NULL;
	int osd_index = -1;

	layer_str = getenv("display_layer");
	if (strcmp(layer_str, "osd1") == 0)
		osd_index = 0;
	else if (strcmp(layer_str, "osd2") == 0)
		osd_index = 1;

	if (!((bmp->header.signature[0] == 'B') &&
	      (bmp->header.signature[1] == 'M'))) {
		osd_loge("no valid bmp image at 0x%lx\n", bmp_image);
		return 1;
	}

	width = le32_to_cpu(bmp->header.width);
	height = le32_to_cpu(bmp->header.height);
	bmp_bpix = le16_to_cpu(bmp->header.bit_count);
	colors = 1 << bmp_bpix;

	bpix = NBITS(info->vl_bpix);

#ifdef CONFIG_OSD_SCALE_ENABLE
	if ((x == -1) && (y == -1)) {
		if ((width > pwidth) || (height > pheight)) {
			x = 0;
			y = 0;
		} else {
			x = (pwidth - width) / 2;
			y = (pheight - height) / 2;
		}
	}
#else
	if ((x == -1) && (y == -1)) {
		if ((width > info->vl_col) || (height > info->vl_row)) {
			x = 0;
			y = 0;
		} else {
			x = (info->vl_col - width) / 2;
			y = (info->vl_row - height) / 2;
		}
	}
#endif

	if ((bpix != 1) && (bpix != 8) && (bpix != 16) && (bpix != 24) &&
	    (bpix != 32)) {
		osd_loge("%d bit/pixel mode, but BMP has %d bit/pixel\n",
			 bpix, bmp_bpix);
		return 1;
	}

	/* We support displaying 8bpp BMPs on 16bpp LCDs */
	if (bpix != bmp_bpix && (bmp_bpix != 8 || bpix != 16)) {
		osd_loge("%d bit/pixel mode, but BMP has %d bit/pixel\n",
			 bpix,
			 le16_to_cpu(bmp->header.bit_count));
		return 1;
	}

	osd_logd("Display-bmp: %d x %d  with %d colors\n",
		 (int)width, (int)height, (int)colors);

	/*
	 *  BMP format for Monochrome assumes that the state of a
	 * pixel is described on a per Bit basis, not per Byte.
	 *  So, in case of Monochrome BMP we should align widths
	 * on a byte boundary and convert them from Bit to Byte
	 * units.
	 *  Probably, PXA250 and MPC823 process 1bpp BMP images in
	 * their own ways, so make the converting to be MCC200
	 * specific.
	 */
	padded_line = (width & 0x3) ? ((width & ~0x3) + 4) : (width);

#ifdef CONFIG_SPLASH_SCREEN_ALIGN
	if (x == BMP_ALIGN_CENTER)
		x = max(0, (pwidth - width) / 2);
	else if (x < 0)
		x = max(0, pwidth - width + x + 1);

	if (y == BMP_ALIGN_CENTER)
		y = max(0, (info->vl_row - height) / 2);
	else if (y < 0)
		y = max(0, info->vl_row - height + y + 1);
#endif /* CONFIG_SPLASH_SCREEN_ALIGN */

#ifdef CONFIG_OSD_SCALE_ENABLE
	if ((x + width) > pwidth)
		width = pwidth - x;
	if ((y + height) > pheight)
		height = pheight - y;
#else
	if ((x + width) > pwidth)
		width = pwidth - x;
	if ((y + height) > info->vl_row)
		height = info->vl_row - y;
#endif

	osd_enable_hw(osd_index, 1);

	bmap = (uchar *)bmp + le32_to_cpu(bmp->header.data_offset);
	fb   = (uchar *)(info->vd_base +
			 (y + height - 1) * lcd_line_length + x * fb_gdev.gdfBytesPP);

	osd_logd("fb=0x%p; bmap=0x%p, width=%ld, height= %ld, lcd_line_length=%d, padded_line=%d\n",
		 fb, bmap, width, height, lcd_line_length, padded_line);
	switch (bmp_bpix) {
	case 8:
		if (bpix != 16)
			byte_width = width;
		else
			byte_width = width * 2;

		for (i = 0; i < height; ++i) {
			for (j = 0; j < width; j++) {
				if (bpix != 16)
					*(fb++) = *(bmap++);
				else {
					*(uint16_t *)fb = cmap_base[*(bmap++)];
					fb += sizeof(uint16_t) / sizeof(*fb);
				}
			}
			bmap += (width - padded_line);
			fb   -= (byte_width + lcd_line_length);
		}
		break;
	case 16:
		for (i = 0; i < height; ++i) {
			for (j = 0; j < width; j++) {

				*(fb++) = *(bmap++);
				*(fb++) = *(bmap++);
			}
			bmap += (padded_line - width) * 2;
			fb   -= (width * 2 + lcd_line_length);
		}
		break;
	case 24:
		for (i = 0; i < height; ++i) {
			for (j = 0; j < width; j++) {

				*(fb++) = *(bmap++);
				*(fb++) = *(bmap++);
				*(fb++) = *(bmap++);
			}
			bmap += (padded_line - width);
			fb   -= (width * 3 + lcd_line_length);
		}
		break;
	case 32:
		for (i = 0; i < height; ++i) {
			for (j = 0; j < width; j++) {

				*(fb++) = *(bmap++);
				*(fb++) = *(bmap++);
				*(fb++) = *(bmap++);
				*(fb++) = *(bmap++);
			}
			bmap += (padded_line - width);
			fb   -= (width * 4 + lcd_line_length);
		}
		break;
	default:
		osd_loge("error: gdev.bpp %d, but bmp.bpp %d\n", fb_gdev.gdfBytesPP, bmp_bpix);
		return (-1);
	}
	flush_cache((unsigned long)info->vd_base,
		    info->vl_col * info->vl_row * info->vl_bpix / 8);

	return (0);
}

#ifdef CONFIG_OSD_SCALE_ENABLE
static int my_atoi(const char *str)
{
	int result = 0;
	int signal = 1;

	if ((*str >= '0' && *str <= '9') || *str == '-' || *str == '+') {
		if (*str == '-' || *str == '+') {
			if (*str == '-')
				signal = -1;
			str++;
		}
	} else
		return 0;

	while (*str >= '0' && *str <= '9')
		result = result * 10 + (*str++ -'0');

	return signal * result;
}

static int getenv_int(char *env, int def)
{
	if (getenv(env) == NULL)
		return def;
	else
		return my_atoi(getenv(env));
}

static int get_window_axis(int *axis)
{
	int ret = 0;
	char *mode = getenv("outputmode");

	if (strcmp(mode, "480i") == 0 || strcmp(mode, "480cvbs") == 0) {
		axis[0] = getenv_int("480i_x", 0);
		axis[1] = getenv_int("480i_y", 0);
		axis[2] = getenv_int("480i_w", 720);
		axis[3] = getenv_int("480i_h", 480);
	} else if (strcmp(mode, "480p") == 0) {
		axis[0] = getenv_int("480p_x", 0);
		axis[1] = getenv_int("480p_y", 0);
		axis[2] = getenv_int("480p_w", 720);
		axis[3] = getenv_int("480p_h", 480);
	} else if (strcmp(mode, "576i") == 0 || strcmp(mode, "576cvbs") == 0) {
		axis[0] = getenv_int("576i_x", 0);
		axis[1] = getenv_int("576i_y", 0);
		axis[2] = getenv_int("576i_w", 720);
		axis[3] = getenv_int("576i_h", 576);
	} else if (strcmp(mode, "576p") == 0) {
		axis[0] = getenv_int("576p_x", 0);
		axis[1] = getenv_int("576p_y", 0);
		axis[2] = getenv_int("576p_w", 720);
		axis[3] = getenv_int("576p_h", 576);
	} else if (strcmp(mode, "720p") == 0 || strcmp(mode, "720p50hz") == 0) {
		axis[0] = getenv_int("720p_x", 0);
		axis[1] = getenv_int("720p_y", 0);
		axis[2] = getenv_int("720p_w", 1280);
		axis[3] = getenv_int("720p_h", 720);
	} else if (strcmp(mode, "1080i") == 0 || strcmp(mode, "1080i50hz") == 0) {
		axis[0] = getenv_int("1080i_x", 0);
		axis[1] = getenv_int("1080i_y", 0);
		axis[2] = getenv_int("1080i_w", 1920);
		axis[3] = getenv_int("1080i_h", 1080);
	} else if (strcmp(mode, "4k2k24hz") == 0) {
		axis[0] = getenv_int("4k2k24hz_x", 0);
		axis[1] = getenv_int("4k2k24hz_y", 0);
		axis[2] = getenv_int("4k2k24hz_w", 3840);
		axis[3] = getenv_int("4k2k24hz_h", 2160);
	} else if (strcmp(mode, "4k2k25hz") == 0) {
		axis[0] = getenv_int("4k2k25hz_x", 0);
		axis[1] = getenv_int("4k2k25hz_y", 0);
		axis[2] = getenv_int("4k2k25hz_w", 3840);
		axis[3] = getenv_int("4k2k25hz_h", 2160);
	} else if (strcmp(mode, "4k2k30hz") == 0) {
		axis[0] = getenv_int("4k2k30hz_x", 0);
		axis[1] = getenv_int("4k2k30hz_y", 0);
		axis[2] = getenv_int("4k2k30hz_w", 3840);
		axis[3] = getenv_int("4k2k30hz_h", 2160);
	}  else if (strcmp(mode, "4k2k50hz420") == 0) {
		axis[0] = getenv_int("4k2k420_x", 0);
		axis[1] = getenv_int("4k2k420_y", 0);
		axis[2] = getenv_int("4k2k420_w", 3840);
		axis[3] = getenv_int("4k2k420_h", 2160);
	} else if (strcmp(mode, "4k2k60hz420") == 0) {
		axis[0] = getenv_int("4k2k420_x", 0);
		axis[1] = getenv_int("4k2k420_y", 0);
		axis[2] = getenv_int("4k2k420_w", 3840);
		axis[3] = getenv_int("4k2k420_h", 2160);
	} else if (strcmp(mode, "4k2ksmpte") == 0) {
		axis[0] = getenv_int("4k2ksmpte_x", 0);
		axis[1] = getenv_int("4k2ksmpte_y", 0);
		axis[2] = getenv_int("4k2ksmpte_w", 4096);
		axis[3] = getenv_int("4k2ksmpte_h", 2160);
	} else if (strcmp(mode, "1080p") == 0 || strcmp(mode, "1080p50hz") == 0 ||
		   strcmp(mode, "1080p24hz") == 0) {
		axis[0] = getenv_int("1080p_x", 0);
		axis[1] = getenv_int("1080p_y", 0);
		axis[2] = getenv_int("1080p_w", 1920);
		axis[3] = getenv_int("1080p_h", 1080);
	} else {
		axis[0] = getenv_int("1080p_x", 0);
		axis[1] = getenv_int("1080p_y", 0);
		axis[2] = getenv_int("1080p_w", 1920);
		axis[3] = getenv_int("1080p_h", 1080);
	}
	osd_logd2("bmp scale: mode=%s , x=%d, y=%d, w=%d, h=%d\n", mode, axis[0], axis[1], axis[2], axis[3]);

	return ret;
}

int video_scale_bitmap(void)
{
	char *layer_str = NULL;
	int osd_index = -1;
	int axis[4] = {};

	osd_logd2("video_scale_bitmap src w=%d, h=%d, dst w=%d, dst h=%d\n",
		fb_gdev.fb_width, fb_gdev.fb_height, fb_gdev.winSizeX, fb_gdev.winSizeY);

	layer_str = getenv("display_layer");
	get_window_axis(axis);
	if (strcmp(layer_str, "osd1") == 0)
		osd_index = 0;
	else if (strcmp(layer_str, "osd2") == 0)
		osd_index = 1;
#ifdef CONFIG_OSD_SUPERSCALE_ENABLE
	if ((fb_gdev.fb_width * 2 != fb_gdev.winSizeX) ||
	    (fb_gdev.fb_height * 2 != fb_gdev.winSizeY)) {
		osd_enable_hw(osd_index, 1);
		return (-1);
	}
	osd_set_free_scale_mode_hw(osd_index, 2);
#else
	osd_set_free_scale_mode_hw(osd_index, 1);
#endif
	osd_set_free_scale_axis_hw(osd_index, 0, 0, fb_gdev.fb_width - 1,
				   fb_gdev.fb_height - 1);
	osd_set_window_axis_hw(osd_index, axis[0], axis[1], axis[0] + axis[2] - 1,
			       axis[1] + axis[3] - 1);
	osd_set_free_scale_enable_hw(osd_index, 0x10001);
	osd_enable_hw(osd_index, 1);

	return (1);
}
#endif
