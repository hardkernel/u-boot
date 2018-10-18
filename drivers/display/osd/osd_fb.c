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
#include <asm/cpu_id.h>
#include <asm/arch/cpu.h>
#include <asm/arch/timer.h>

/* Local Headers */
#include <amlogic/fb.h>
#include <amlogic/color.h>
#include <amlogic/vinfo.h>
#include <amlogic/vout.h>

/* Local Headers */
#include "osd.h"
#include "osd_log.h"
#include "osd_hw.h"
#include "osd_fb.h"

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
typedef struct pic_info_t {
	unsigned int mode;
	unsigned int type;
	unsigned int pic_width;
	unsigned int pic_height;
	unsigned int bpp;
	ulong pic_image;
}pic_info_t;
static pic_info_t g_pic_info;
static int img_video_init = 0;
static int fb_index = -1;

#if defined(CONFIG_AML_MINUI)
extern int in_fastboot_mode;
#endif

static void osd_layer_init(GraphicDevice *gdev, int layer)
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
	u32 fbmem = gdev->frameAdrs;
	const struct color_bit_define_s *color =
			&default_color_format_array[gdev->gdfIndex];

#ifdef CONFIG_OSD_SCALE_ENABLE
	xres = gdev->fb_width;
	yres = gdev->fb_height;
	xres_virtual = gdev->fb_width;
	yres_virtual = gdev->fb_height * 2;
	disp_end_x = gdev->fb_width - 1;
	disp_end_y = gdev->fb_height - 1;
#else
	xres = gdev->winSizeX;
	yres = gdev->winSizeY;
	xres_virtual = gdev->winSizeX;
	yres_virtual = gdev->winSizeY * 2;
	disp_end_x = gdev->winSizeX - 1;
	disp_end_y = gdev->winSizeY - 1;
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

static int get_dts_node(char *dt_addr, char *dtb_node)
{
#ifdef CONFIG_OF_LIBFDT
	int parent_offset = 0;
	char *propdata = NULL;

	parent_offset = fdt_path_offset(dt_addr, dtb_node);
	if (parent_offset < 0) {
		/* not found */
		return -1;
	} else {
		propdata = (char *)fdt_getprop(dt_addr, parent_offset, "status", NULL);
		if (propdata == NULL) {
			osd_logi("not find status, default to disabled\n");
			return -1;
		} else {
			if (strncmp(propdata, "okay", 2)) {
				osd_logi("status disabled\n");
				return -1;
			}
		}
	}
	return parent_offset;
#else
	return -1;
#endif
}

unsigned long get_fb_addr(void)
{
	char *dt_addr = NULL;
	unsigned long fb_addr = 0;
	static int initrd_set = 0;
	char str_fb_addr[32];
	char fdt_node[32];
#ifdef CONFIG_OF_LIBFDT
	int parent_offset = 0;
	char *propdata = NULL;
#endif

	fb_addr = env_strtoul("fb_addr", 16);
#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DTB_MEM_ADDR
	dt_addr = (char *)CONFIG_DTB_MEM_ADDR;
#else
	dt_addr = (char *)0x01000000;
#endif

#if defined(CONFIG_AML_MINUI)
	if (in_fastboot_mode == 1) {
		osd_logi("in fastboot mode, load default fb_addr parameters \n");
	} else
#endif
	{
		if (fdt_check_header(dt_addr) < 0) {
			osd_logi("check dts: %s, load default fb_addr parameters\n",
				fdt_strerror(fdt_check_header(dt_addr)));
		} else {
			strcpy(fdt_node, "/meson-fb");
			osd_logi("load fb addr from dts:%s\n", fdt_node);
			parent_offset = get_dts_node(dt_addr, fdt_node);
			if (parent_offset < 0) {
				strcpy(fdt_node, "/drm-vpu");
				osd_logi("load fb addr from dts:%s\n", fdt_node);
				parent_offset = get_dts_node(dt_addr, fdt_node);
				if (parent_offset < 0) {
					osd_logi("not find node: %s\n",fdt_strerror(parent_offset));
					osd_logi("use default fb_addr parameters\n");
				} else {
					/* check fb_addr */
					propdata = (char *)fdt_getprop(dt_addr, parent_offset, "logo_addr", NULL);
					if (propdata == NULL) {
						osd_logi("failed to get fb addr for logo\n");
						osd_logi("use default fb_addr parameters\n");
					} else {
						fb_addr = simple_strtoul(propdata, NULL, 16);
					}
				}
			} else {
				/* check fb_addr */
				propdata = (char *)fdt_getprop(dt_addr, parent_offset, "logo_addr", NULL);
				if (propdata == NULL) {
					osd_logi("failed to get fb addr for logo\n");
					osd_logi("use default fb_addr parameters\n");
				} else {
					fb_addr = simple_strtoul(propdata, NULL, 16);
				}
			}
		}
	}
#endif
	if ((!initrd_set) && (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_AXG)) {
		sprintf(str_fb_addr,"%lx",fb_addr);
		setenv("initrd_high", str_fb_addr);
		initrd_set = 1;
		osd_logi("set initrd_high: 0x%s\n", str_fb_addr);
	}

	osd_logi("fb_addr for logo: 0x%lx\n", fb_addr);
	return fb_addr;
}

int get_osd_layer(void)
{
	char *layer_str;
	int osd_index = -1;

	if (fb_index < 0) {
		layer_str = getenv("display_layer");
		if (strcmp(layer_str, "osd0") == 0)
			osd_index = OSD1;
		else if (strcmp(layer_str, "osd1") == 0)
			osd_index = OSD2;
		fb_index = osd_index;
	}
	return fb_index;
}
static void *osd_hw_init(void)
{
	int osd_index = -1;
	u32 color_index = 0;

	color_index = env_strtoul("display_color_index", 10);

	if ((color_index < ARRAY_SIZE(default_color_format_array))
	    && (default_color_format_array[color_index].color_index !=
		COLOR_INDEX_NULL))
		fb_gdev.gdfIndex = color_index;
	else {
		osd_loge("color_index %d invalid\n", color_index);
		return NULL;
	}

	osd_index = get_osd_layer();
	if (osd_index < 0) {
		osd_loge("osd_hw_init: invalid osd_index\n");
		return NULL;
	}
	if (osd_index == OSD1)
		osd_layer_init(&fb_gdev, OSD1);
	else if (osd_index == OSD2) {
		if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_AXG) {
			osd_loge("AXG not support osd2\n");
			return NULL;
		}
		osd_layer_init(&fb_gdev, OSD2);
	}
	else {
		osd_loge("display_layer(%d) invalid\n", osd_index);
		return NULL;
	}
	return (void *)&fb_gdev;
}

void *video_hw_init(int display_mode)
{
	u32 fb_addr = 0;
	u32 display_width = 0;
	u32 display_height = 0;
	u32 display_bpp = 0;
	u32 fg = 0;
	u32 bg = 0;
	u32 fb_width = 0;
	u32 fb_height = 0;;

	vout_init();
	fb_addr = get_fb_addr();
	switch (display_mode) {
	case MIDDLE_MODE:
	case RECT_MODE:
#ifdef CONFIG_OSD_SCALE_ENABLE
		fb_width = env_strtoul("fb_width", 10);
		fb_height = env_strtoul("fb_height", 10);
#endif
		display_bpp = env_strtoul("display_bpp", 10);
		break;
	case FULL_SCREEN_MODE:
		fb_width = g_pic_info.pic_width;
		fb_height = g_pic_info.pic_height;
		display_bpp = g_pic_info.bpp;
		break;
	}
	display_width = env_strtoul("display_width", 10);
	display_height = env_strtoul("display_height", 10);
	fg = env_strtoul("display_color_fg", 10);
	bg = env_strtoul("display_color_bg", 10);

	/* fill in Graphic Device */
	fb_gdev.frameAdrs = fb_addr;
	fb_gdev.fb_width = fb_width;
	fb_gdev.fb_height = fb_height;
	fb_gdev.winSizeX = display_width;
	fb_gdev.winSizeY = display_height;
	fb_gdev.gdfBytesPP = display_bpp / 8;
	fb_gdev.fg = fg;
	fb_gdev.bg = bg;
	fb_gdev.mode = display_mode;
	return osd_hw_init();


}

int rle8_decode(uchar *ptr, bmp_image_t *bmap_rle8, ulong width_bmp, ulong height_bmp) {
	uchar a;
	uchar cnt, runlen;
	int i;
	int decode;
	int pixels;
	uchar *pic;
	int limit;

	a = 0xFF;
	decode = 1;
	pixels = 0;
	limit = width_bmp * height_bmp;
	pic = (uchar *)bmap_rle8 + le32_to_cpu(bmap_rle8->header.data_offset);

	while (decode) {
		switch (pic[0]) {
		case 0:
			switch (pic[1]) {
			case 0:
				/* end of row */
				pic += 2;
				continue;
			case 1:
				/* end of bmp */
				decode = 0;
				break;
			case 2:
				/* 00 02 mode */
				pic += 4;
				break;

			default:
				/* 00 (03~FF) mode */
				cnt = pic[1];
				runlen = cnt;
				pixels += cnt;
				if (pixels > limit)
				{
					osd_loge("Error: Too much encoded pixel data, validate your bitmap\n");
					decode = 0;
					return -1;
				}
				pic += 2;
				for (i = 0; i < cnt; i++) {

					*ptr = bmap_rle8->color_table[*pic].blue;
					ptr += 1;
					*ptr = bmap_rle8->color_table[*pic].green;
					ptr += 1;
					*ptr = bmap_rle8->color_table[*pic].red;
					ptr += 1;
					*ptr = a;
					ptr += 1;
					pic += 1;
				}
				if (runlen & 1)
					pic += 1;	/* 0 padding if length is odd */
				break;
			}
			break;

		default:
			/* normal mode */
			cnt = pic[0];
			runlen = cnt;
			pixels += cnt;
			if (pixels > limit) {
				osd_loge("Error: Too much encoded pixel data, validate your bitmap\n");
				return -1;
			}
			pic += 1;
			for (i = 0; i < cnt; i++) {

				*ptr = bmap_rle8->color_table[*pic].blue;
				ptr += 1;
				*ptr = bmap_rle8->color_table[*pic].green;
				ptr += 1;
				*ptr = bmap_rle8->color_table[*pic].red;
				ptr += 1;
				*ptr = a;
				ptr += 1;
			}
			pic += 1;
			break;
		}
	}
	return (0);
}

static int parse_bmp_info(ulong bmp_image)
{
	bmp_image_t *bmp = (bmp_image_t *)bmp_image;

	if (!((bmp->header.signature[0] == 'B') &&
		  (bmp->header.signature[1] == 'M'))) {
		osd_loge("no valid bmp image at 0x%lx\n", bmp_image);
		return 1;
	}
	g_pic_info.pic_width = le32_to_cpu(bmp->header.width);
	g_pic_info.pic_height = le32_to_cpu(bmp->header.height);
	g_pic_info.bpp = le16_to_cpu(bmp->header.bit_count);
	return 0;
}

int video_display_bitmap(ulong bmp_image, int x, int y)
{
	struct vinfo_s *info = NULL;
#if defined CONFIG_AML_VOUT
	info = vout_get_current_vinfo();
#endif
	// ushort *cmap_base = NULL;
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
	unsigned long pheight = info->width;
	unsigned long pwidth = info->height;
#endif
	unsigned colors, bpix, bmp_bpix;
	int lcd_line_length = (pwidth * NBITS(info->vl_bpix)) / 8;
	int osd_index = -1;

	osd_index = get_osd_layer();
	if (osd_index < 0) {
		osd_loge("video_display_bitmap: invalid osd_index\n");
		return (-1);
	}

	if (fb_gdev.mode != FULL_SCREEN_MODE)
		if (parse_bmp_info(bmp_image))
			return -1;
	width = g_pic_info.pic_width;
	height = g_pic_info.pic_height;
	bmp_bpix = g_pic_info.bpp;
	colors = 1 << bmp_bpix;
	uchar *buffer_rgb = NULL;
	bpix = NBITS(info->vl_bpix);
	if ((bpix != 1) && (bpix != 8) && (bpix != 16) && (bpix != 24) &&
	    (bpix != 32)) {
		osd_loge("%d bit/pixel mode1, but BMP has %d bit/pixel\n",
			 bpix, bmp_bpix);
		return 1;
	}
	/* We support displaying 8bpp BMPs on 16bpp LCDs */
	/*if (bpix != bmp_bpix && (bmp_bpix != 8 || bpix != 16)) {
		osd_loge("%d bit/pixel mode2, but BMP has %d bit/pixel\n",
			 bpix,
			 le16_to_cpu(bmp->header.bit_count));
		return 1;
	}*/

	osd_logd("Display-bmp: %d x %d  with %d colors\n",
		 (int)width, (int)height, (int)colors);

	if ((x == -1) && (y == -1)) {
		/* use MIDDLE_MODE */
		if ((width > pwidth) || (height > pheight)) {
			x = 0;
			y = 0;
		} else {
			x = (pwidth - width) / 2;
			y = (pheight - height) / 2;
		}
	} else {
		switch (fb_gdev.mode) {
		case MIDDLE_MODE:
			if ((width > pwidth) || (height > pheight)) {
				x = 0;
				y = 0;
			} else {
				x = (pwidth - width) / 2;
				y = (pheight - height) / 2;
			}
			break;
		case RECT_MODE:
			break;
		case FULL_SCREEN_MODE:
			x = 0;
			y = 0;
			break;
		}
	}
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

	if ((x + width) > pwidth)
		width = pwidth - x;
	if ((y + height) > pheight)
		height = pheight - y;

	osd_enable_hw(osd_index, 1);

	bmap = (uchar *)bmp + le32_to_cpu(bmp->header.data_offset);
	fb   = (uchar *)(info->vd_base +
			 (y + height - 1) * lcd_line_length + x * fb_gdev.gdfBytesPP);

	osd_logd("fb=0x%p; bmap=0x%p, width=%ld, height= %ld, lcd_line_length=%d, padded_line=%d, fb_gdev.fb_width=%d, fb_gdev.fb_height=%d \n",
		 fb, bmap, width, height, lcd_line_length, padded_line,fb_gdev.fb_width,fb_gdev.fb_height);

	if (bmp_bpix == 8) {
		/* decode of RLE8 */
		buffer_rgb = (uchar *)malloc(height * width * 4 * sizeof(uchar) + 1);
		if (buffer_rgb == NULL) {
			printf("Error:fail to malloc the memory!");
			return (-1);
		}
	}
	uchar *ptr_rgb = buffer_rgb;
	switch (bmp_bpix) {
	case 8:
		if (bpix != 16)
			byte_width = width;
		else
			byte_width = width * 2;
		rle8_decode(ptr_rgb, bmp, width, height);
		for (i = 0; i < height; ++i) {
			for (j = 0; j < width; j++) {
				if (bpix != 16) {
					*(fb++) = *buffer_rgb;
					buffer_rgb += 1;
					*(fb++) = *buffer_rgb;
					buffer_rgb += 1;
					*(fb++) = *buffer_rgb;
					buffer_rgb += 1;
					*(fb++) = *buffer_rgb;
					buffer_rgb += 1;
				}
				// else {
				// 	*(uint16_t *)fb = cmap_base[*buffer_rgb++];
				// 	fb += sizeof(uint16_t) / sizeof(*fb);
				// }
			}
			buffer_rgb += (padded_line - width);
			fb -= (byte_width * 4 + lcd_line_length);
		}
		buffer_rgb -= width*height*4;
		free(buffer_rgb);
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
		if (bpix == 32) {
			for (i = 0; i < height; ++i) {
				for (j = 0; j < width; j++) {

					*(fb++) = *(bmap++);
					*(fb++) = *(bmap++);
					*(fb++) = *(bmap++);
					*(fb++) = 0xff;
				}
				bmap += (padded_line - width);
				fb   -= (width * 4 + lcd_line_length);
			}
		} else {
			for (i = 0; i < height; ++i) {
				for (j = 0; j < width; j++) {

					*(fb++) = *(bmap++);
					*(fb++) = *(bmap++);
					*(fb++) = *(bmap++);
				}
				bmap += (padded_line - width);
				fb   -= (width * 3 + lcd_line_length);
			}
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
	buffer_rgb = NULL;
	ptr_rgb = NULL;

	flush_cache((unsigned long)info->vd_base,
		    pheight * pwidth * info->vl_bpix / 8);
	return (0);
}

int video_display_raw(ulong raw_image, int x, int y)
{
	struct vinfo_s *info = NULL;
#if defined CONFIG_AML_VOUT
	info = vout_get_current_vinfo();
#endif
	ushort i, j;
	uchar *fb;
	uchar *bmap = (uchar *)raw_image;
	ushort padded_line;
	unsigned long width, height;
#ifdef CONFIG_OSD_SCALE_ENABLE
	unsigned long pheight = fb_gdev.fb_height;
	unsigned long pwidth = fb_gdev.fb_width;
#else
	unsigned long pheight = info->width;
	unsigned long pwidth = info->height;
#endif
	unsigned colors, bpix, bmp_bpix;
	int lcd_line_length = (pwidth * NBITS(info->vl_bpix)) / 8;
	int osd_index = -1;

	osd_index = get_osd_layer();
	if (osd_index < 0) {
		osd_loge("video_display_raw: invalid osd_index\n");
		return (-1);
	}

	width = g_pic_info.pic_width;
	height = g_pic_info.pic_height;
	bmp_bpix = g_pic_info.bpp;
	colors = 1 << bmp_bpix;
	bpix = NBITS(info->vl_bpix);
	if ((bpix != 1) && (bpix != 8) && (bpix != 16) && (bpix != 24) &&
	    (bpix != 32)) {
		osd_loge("%d bit/pixel mode1, but BMP has %d bit/pixel\n",
			 bpix, bmp_bpix);
		return 1;
	}
	/* We support displaying 8bpp BMPs on 16bpp LCDs */
	/*if (bpix != bmp_bpix && (bmp_bpix != 8 || bpix != 16)) {
		osd_loge("%d bit/pixel mode2, but BMP has %d bit/pixel\n",
			 bpix,
			 le16_to_cpu(bmp->header.bit_count));
		return 1;
	}*/

	osd_logd("Display-bmp: %d x %d  with %d colors\n",
		 (int)width, (int)height, (int)colors);

	if ((x == -1) && (y == -1)) {
		/* use MIDDLE_MODE */
		if ((width > pwidth) || (height > pheight)) {
			x = 0;
			y = 0;
		} else {
			x = (pwidth - width) / 2;
			y = (pheight - height) / 2;
		}
	} else {
		switch (fb_gdev.mode) {
		case MIDDLE_MODE:
			if ((width > pwidth) || (height > pheight)) {
				x = 0;
				y = 0;
			} else {
				x = (pwidth - width) / 2;
				y = (pheight - height) / 2;
			}
			break;
		case RECT_MODE:
			break;
		case FULL_SCREEN_MODE:
			x = 0;
			y = 0;
			break;
		}
	}
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

	if ((x + width) > pwidth)
		width = pwidth - x;
	if ((y + height) > pheight)
		height = pheight - y;

	osd_enable_hw(osd_index, 1);

	fb   = (uchar *)(info->vd_base + y * lcd_line_length + x * fb_gdev.gdfBytesPP);

	osd_logd("fb=0x%p; bmap=0x%p, width=%ld, height= %ld, lcd_line_length=%d, padded_line=%d, fb_gdev.fb_width=%d, fb_gdev.fb_height=%d \n",
		 fb, bmap, width, height, lcd_line_length, padded_line,fb_gdev.fb_width,fb_gdev.fb_height);

	if (FULL_SCREEN_MODE == fb_gdev.mode) {
		memcpy(fb, bmap, height * width * bmp_bpix / 8);
	} else {
		switch (bmp_bpix) {
		case 16:
			for (i = 0; i < height; ++i) {
				for (j = 0; j < width; j++) {

					*(fb++) = *(bmap++);
					*(fb++) = *(bmap++);
				}
				bmap += (padded_line - width) * 2;
				fb   += (lcd_line_length - width * 2);
			}
			break;
		case 24:
			if (bpix == 32) {
				for (i = 0; i < height; ++i) {
					for (j = 0; j < width; j++) {

						*(fb++) = *(bmap++);
						*(fb++) = *(bmap++);
						*(fb++) = *(bmap++);
						*(fb++) = 0xff;
					}
					bmap += (padded_line - width) * 4;
					fb   += (lcd_line_length - width * 4);
				}
			} else {
				for (i = 0; i < height; ++i) {
					for (j = 0; j < width; j++) {

						*(fb++) = *(bmap++);
						*(fb++) = *(bmap++);
						*(fb++) = *(bmap++);
					}
					bmap += (padded_line - width) * 3;
					fb   += (lcd_line_length - width * 3);
				}
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
				bmap += (padded_line - width) * 4;
				fb   += (lcd_line_length - width * 4);
			}
			break;
		default:
			osd_loge("error: gdev.bpp %d, but raw.bpp %d\n", fb_gdev.gdfBytesPP, bmp_bpix);
			return (-1);
		}
	}
	flush_cache((unsigned long)info->vd_base,
		    pheight * pwidth * info->vl_bpix / 8);
	return (0);
}

#ifdef CONFIG_OSD_SCALE_ENABLE
int video_scale_bitmap(void)
{
	char *layer_str = NULL;
	int osd_index = -1;
	int axis[4] = {};
#ifdef CONFIG_AML_MESON_G12A
	struct pandata_s disp_data;
#endif

	osd_logd2("video_scale_bitmap src w=%d, h=%d, dst w=%d, dst h=%d\n",
		fb_gdev.fb_width, fb_gdev.fb_height, fb_gdev.winSizeX, fb_gdev.winSizeY);

	layer_str = getenv("display_layer");
	vout_get_current_axis(axis);
	if (strcmp(layer_str, "osd0") == 0)
		osd_index = 0;
	else if (strcmp(layer_str, "osd1") == 0)
		osd_index = 1;
	else {
		osd_logd2("video_scale_bitmap: invalid display_layer\n");
		return (-1);
	}
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
#ifdef CONFIG_AML_MESON_G12A
	disp_data.x_start = axis[0];
	disp_data.y_start = axis[1];
	disp_data.x_end = axis[0] + axis[2] - 1;
	disp_data.y_end = axis[1] + axis[3] - 1;
	if (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_G12A)
		osd_update_blend(&disp_data);
#endif
	osd_enable_hw(osd_index, 1);

	return (1);
}
#endif

/*
MIDDLE_MODE,RECT_MODE:
	fixed framebuffer size get from uboot env.
	bmp_image can be 0.
FULL_SCREEN_MODE:
	usd bmp size as framebuffer size;
	 must set bmp_image;
*/
void img_mode_set(u32 display_mode)
{
	fb_gdev.mode = display_mode;
}

void img_addr_set(ulong pic_image)
{
	g_pic_info.pic_image = pic_image;
}

void img_type_set(u32 type)
{
	g_pic_info.type = type;
}

void img_raw_size_set(u32 raw_width, u32 raw_height, u32 raw_bpp)
{
		g_pic_info.pic_width = raw_width;
		g_pic_info.pic_height = raw_height;
		g_pic_info.bpp = raw_bpp;
}

static int img_raw_init(void)
{
	unsigned int display_mode;

	if (img_video_init)
		return 0;

	display_mode = fb_gdev.mode;
#if 0
	if (display_mode == FULL_SCREEN_MODE) {
		g_pic_info.pic_width = env_strtoul("pic_width", 10);
		g_pic_info.pic_height = env_strtoul("pic_height", 10);
		g_pic_info.bpp = env_strtoul("pic_bpp", 10);
	}
#endif
	if (NULL == video_hw_init(display_mode)) {
		printf("Initialize video device failed!\n");
		return -1;
	}
	osd_logd2("raw_width=%d, raw_height=%d, raw_bpp=%d\n", g_pic_info.pic_width, g_pic_info.pic_height, g_pic_info.bpp);
	img_video_init = 1;
	return 0;
}

static int img_bmp_init(void)
{
	unsigned int display_mode;

	if (img_video_init)
		return 0;
	display_mode = fb_gdev.mode;
	if (display_mode == FULL_SCREEN_MODE) {
		if (g_pic_info.pic_image != 0)
			if (parse_bmp_info(g_pic_info.pic_image))
				return -1;
	}
	if (NULL == video_hw_init(display_mode)) {
		printf("Initialize video device failed!\n");
		return -1;
	}
	img_video_init = 1;
	return 0;
}

int img_osd_init(void)
{
	int ret = -1;

	if (g_pic_info.type == BMP_PIC)
		ret = img_bmp_init();
	else if(g_pic_info.type == RAW_PIC)
		ret = img_raw_init();
	return ret;
}

int img_bmp_display(ulong bmp_image, int x, int y)
{
	return video_display_bitmap(bmp_image, x, y);
}

int img_raw_display(ulong raw_image, int x, int y)
{
	return video_display_raw(raw_image, x, y);
}

int img_display(ulong bmp_image, int x, int y)
{
	int ret = -1;
	if (g_pic_info.type == BMP_PIC)
		ret = img_bmp_display(bmp_image, x, y);
	else if(g_pic_info.type == RAW_PIC)
		ret = img_raw_display(bmp_image, x, y);
	return ret;
}

int img_scale(void)
{
	int ret = -1;

	if (!img_video_init) {
		printf("fastboot osd not enabled!\n");
	}
#ifdef CONFIG_OSD_SCALE_ENABLE
	ret = video_scale_bitmap();
#endif
	return ret;
}

int img_osd_clear(void)
{
	if (!img_video_init) {
		printf("Please enable osd device first!\n");
		return 1;
	}

#ifdef CONFIG_OSD_SCALE_ENABLE
	memset((void *)(long long)(fb_gdev.frameAdrs), 0,
	       (fb_gdev.fb_width * fb_gdev.fb_height)*fb_gdev.gdfBytesPP);

	flush_cache(fb_gdev.frameAdrs,
		    ((fb_gdev.fb_width * fb_gdev.fb_height)*fb_gdev.gdfBytesPP));
#else
	memset((void *)(long long)(fb_gdev.frameAdrs), 0,
	       (fb_gdev.winSizeX * fb_gdev.winSizeY)*fb_gdev.gdfBytesPP);

	flush_cache(fb_gdev.frameAdrs,
		    ((fb_gdev.winSizeX * fb_gdev.winSizeY)*fb_gdev.gdfBytesPP));
#endif
	return 0;
}

void img_osd_uninit(void)
{
	img_video_init = 0;
}

static int _osd_hw_init(void)
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

	vout_init();
	fb_addr = get_fb_addr();
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
		return -1;
	}
	return 0;
}

static int osd_hw_init_by_index(u32 osd_index)
{
	if (_osd_hw_init() < 0)
		return -1;
	if (osd_index == OSD1)
		osd_layer_init(&fb_gdev, OSD1);
	else if ( osd_index == OSD2) {
		if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_AXG) {
			osd_loge("AXG not support osd2\n");
			return -1;
		}
		osd_layer_init(&fb_gdev, OSD2);
	}
	else {
		osd_loge("display_layer(%d) invalid\n", osd_index);
		return -1;
	}

	return 0;
}





static int video_display_osd(u32 osd_index)
{
	struct vinfo_s *info = NULL;
#if defined CONFIG_AML_VOUT
	info = vout_get_current_vinfo();
#endif
	ushort i, j;
	uchar *fb;
	unsigned long width, height;
#ifdef CONFIG_OSD_SCALE_ENABLE
	unsigned long pheight = fb_gdev.fb_height;
	unsigned long pwidth = fb_gdev.fb_width;
#else
	unsigned long pheight = info->width;
	unsigned long pwidth = info->height;
#endif
	int bpp;

	if (fb_gdev.gdfBytesPP != 2) {
		osd_loge("%d bit/pixel mode1, not support now\n",
			fb_gdev.gdfBytesPP);
		return -1;
	}
	bpp = fb_gdev.gdfBytesPP;
	width = fb_gdev.fb_width;
	height = fb_gdev.fb_height;
	osd_set_free_scale_enable_hw(osd_index, 0x0);  // disable free_scale
	osd_enable_hw(osd_index, 1);

	fb   = (uchar *)(info->vd_base);
	osd_logd("fb=0x%p; width=%ld, height= %ld, bpp=%d\n",
		 fb, width, height, bpp);

	for (j = 0; j < height; j++) {
		for (i = 0; i < width; i++ ) {
			*(fb++) = 0x0;
			*(fb++) = 0xf8;
		}
	}

	flush_cache((unsigned long)info->vd_base, pheight * pwidth * bpp);

	return (0);
}

u32 hist_max_min[3][100], hist_spl_val[3][100],
	hist_spl_pix_cnt[3][100], hist_cheoma_sum[3][100];

void hist_set_golden_data(void)
{
	u32 i = 0;
	u32 family_id = get_cpu_id().family_id;
	char *str = NULL;
	char *hist_env_key[12] =
			{"hist_max_min_osd0","hist_spl_val_osd0","hist_spl_pix_cnt_osd0","hist_cheoma_sum_osd0",
			"hist_max_min_osd1","hist_spl_val_osd1","hist_spl_pix_cnt_osd1","hist_cheoma_sum_osd1",
			"hist_max_min_osd2","hist_spl_val_osd2","hist_spl_pix_cnt_osd2","hist_cheoma_sum_osd2"};
	// GXL
	hist_max_min[OSD1][MESON_CPU_MAJOR_ID_GXL] = 0x3d3d;
	hist_spl_val[OSD1][MESON_CPU_MAJOR_ID_GXL] = 0xc4dad1;
	hist_spl_pix_cnt[OSD1][MESON_CPU_MAJOR_ID_GXL] = 0x33a25;
	hist_cheoma_sum[OSD1][MESON_CPU_MAJOR_ID_GXL] = 0xd4fd8a;

	hist_max_min[OSD2][MESON_CPU_MAJOR_ID_GXL] = 0x4f4f;
	hist_spl_val[OSD2][MESON_CPU_MAJOR_ID_GXL] = 0xfef16b;
	hist_spl_pix_cnt[OSD2][MESON_CPU_MAJOR_ID_GXL] = 0x33a25;
	hist_cheoma_sum[OSD2][MESON_CPU_MAJOR_ID_GXL] = 0xe85a68;

	// TXL
	hist_max_min[OSD1][MESON_CPU_MAJOR_ID_TXL] = 0x3d3d;
	hist_spl_val[OSD1][MESON_CPU_MAJOR_ID_TXL] = 0x78a1400;
	hist_spl_pix_cnt[OSD1][MESON_CPU_MAJOR_ID_TXL] = 0x1fa400;
	hist_cheoma_sum[OSD1][MESON_CPU_MAJOR_ID_TXL] = 0x8284800;

	hist_max_min[OSD2][MESON_CPU_MAJOR_ID_TXL] = 0x4f4f;
	hist_spl_val[OSD2][MESON_CPU_MAJOR_ID_TXL] = 0x9c39c00;
	hist_spl_pix_cnt[OSD2][MESON_CPU_MAJOR_ID_TXL] = 0x1fa400;
	hist_cheoma_sum[OSD2][MESON_CPU_MAJOR_ID_TXL] = 0x8e62000;

	// G12A
	hist_max_min[OSD1][MESON_CPU_MAJOR_ID_G12A]
						= hist_max_min[OSD2][MESON_CPU_MAJOR_ID_G12A]
						= 0x3d3d;
	hist_spl_val[OSD1][MESON_CPU_MAJOR_ID_G12A]
						= hist_spl_val[OSD2][MESON_CPU_MAJOR_ID_G12A]
						= 0xc4dcf6;
	hist_spl_pix_cnt[OSD1][MESON_CPU_MAJOR_ID_G12A]
						= hist_spl_pix_cnt[OSD2][MESON_CPU_MAJOR_ID_G12A]
						= 0x33a2e;
	hist_cheoma_sum[OSD1][MESON_CPU_MAJOR_ID_G12A]
						= hist_cheoma_sum[OSD2][MESON_CPU_MAJOR_ID_G12A]
						= 0xd4ffdc;

	for (i = 0; i < 12; i++) {
		str = getenv(hist_env_key[i]);
		if (str) {
			switch (i%4) {
				case 0:
					hist_max_min[i/4][family_id] = simple_strtoul(str, NULL, 16);
					break;
				case 1:
					hist_spl_val[i/4][family_id] = simple_strtoul(str, NULL, 16);
					break;
				case 2:
					hist_spl_pix_cnt[i/4][family_id] = simple_strtoul(str, NULL, 16);
					break;
				case 3:
					hist_cheoma_sum[i/4][family_id] = simple_strtoul(str, NULL, 16);
					break;
			}
		}
	}
}

int osd_rma_test(u32 osd_index)
{
	u32 i = osd_index, osd_max = 1;
	u32 hist_result[4];
	u32 family_id = get_cpu_id().family_id;

	if (family_id == MESON_CPU_MAJOR_ID_AXG) {
		osd_max = 0;
#ifdef CONFIG_AML_MESON_G12A
	} else if (family_id >= MESON_CPU_MAJOR_ID_G12A) {
		osd_max = 1; // osd3 not supported now
#endif
	}
	if (osd_index > osd_max) {
		osd_loge("=== osd%d is not supported, osd_max is %d ===\n", osd_index, osd_max);
		return (-1);
	}

	hist_set_golden_data();
	osd_logi("=== osd_rma_test for osd%d ===\n", i);
	osd_hw_init_by_index(i);
	if (-1 == video_display_osd(i)) {
		return (-1);
	}
	osd_hist_enable(osd_index);
	_udelay(50000);
	osd_get_hist_stat(hist_result);
	_udelay(50000);
	osd_get_hist_stat(hist_result);

	if ((hist_result[0] == hist_max_min[osd_index][family_id]) && (hist_result[1] == hist_spl_val[osd_index][family_id]) &&
	    (hist_result[2] == hist_spl_pix_cnt[osd_index][family_id]) && (hist_result[3] == hist_cheoma_sum[osd_index][family_id])) {
			osd_logi("=== osd%d, osd_rma_test pass. ===\n", osd_index);
			return (0);
	} else {
			osd_loge("osd hist stat result:0x%x, 0x%x, 0x%x, 0x%x\n",
					hist_result[0], hist_result[1], hist_result[2], hist_result[3]);
			osd_loge("osd hist golden data:0x%x, 0x%x, 0x%x, 0x%x\n",
					hist_max_min[osd_index][family_id], hist_spl_val[osd_index][family_id],
					hist_spl_pix_cnt[osd_index][family_id], hist_cheoma_sum[osd_index][family_id]);
			osd_loge("=== osd%d, osd_rma_test failed. ===\n", osd_index);
			return (-1);
	}
}
