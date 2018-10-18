/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "font_10x18.h"
#include "minui.h"
#include "graphics.h"
#include "minui_log.h"

#define UI_ARBG  1
unsigned int ui_log_level = 0;
GRFont* gr_font = NULL;
static minui_backend* gr_backend = NULL;

static int overscan_percent = 0; // OVERSCAN_PERCENT;
static int overscan_offset_x = 0;
static int overscan_offset_y = 0;

static unsigned char gr_current_r = 255;
static unsigned char gr_current_g = 255;
static unsigned char gr_current_b = 255;
static unsigned char gr_current_a = 255;

extern GRSurface* gr_draw;

void ui_set_log_level(int level)
{
	ui_log_level = level;
}

static bool outside(int x, int y)
{
	return x < 0 || x >= gr_draw->width || y < 0 || y >= gr_draw->height;
}

const GRFont* gr_sys_font(void)
{
	return gr_font;
}

int gr_measure(const GRFont* font, const char *s)
{
	return font->char_width * strlen(s);
}

void gr_font_size(const GRFont* font, int *x, int *y)
{
	*x = font->char_width;
	*y = font->char_height;
}

static void text_blend(unsigned char* src_p, int src_row_bytes,
                       unsigned char* dst_p, int dst_row_bytes,
                       int width, int height)
{
	int j = 0;

	for (j = 0; j < height; ++j) {
		int i = 0;
		unsigned char* sx = src_p;
		unsigned char* px = dst_p;

		for (i = 0; i < width; ++i) {
			unsigned char a = *sx++;
			if (gr_current_a < 255)
				a = ((int)a * gr_current_a) / 255;
			if (a == 255) {
				*px++ = gr_current_r;
				*px++ = gr_current_g;
				*px++ = gr_current_b;
				*px++ = 255;
			} else if (a > 0) {
				*px = (*px * (255-a) + gr_current_r * a) / 255;
				++px;
				*px = (*px * (255-a) + gr_current_g * a) / 255;
				++px;
				*px = (*px * (255-a) + gr_current_b * a) / 255;
				++px;
				*px++ = 255;
			} else {
				px += 3;
				*px++ = 255;
			}
		}
		src_p += src_row_bytes;
		dst_p += dst_row_bytes;
	}
}

void gr_text(const GRFont* font, int x, int y, const char *s, bool bold)
{
	unsigned char ch;

	if (!font->texture || gr_current_a == 0)
		return;

	bold = bold && (font->texture->height != font->char_height);

	x += overscan_offset_x;
	y += overscan_offset_y;

	while ((ch = *s++)) {
		if (outside(x, y) || outside(x+font->char_width-1, y+font->char_height-1))
			break;

		if (ch < ' ' || ch > '~') {
			ch = '?';
		}

		unsigned char* src_p = font->texture->data + ((ch - ' ') * font->char_width) +
				(bold ? font->char_height * font->texture->row_bytes : 0);
		unsigned char* dst_p = gr_draw->data + y*gr_draw->row_bytes + x*gr_draw->pixel_bytes;

		text_blend(src_p, font->texture->row_bytes,
			dst_p, gr_draw->row_bytes,
			font->char_width, font->char_height);

		x += font->char_width;
	}
}

void gr_texticon(int x, int y, GRSurface* icon) {
	if (icon == NULL)
		return;

	if (icon->pixel_bytes != 1) {
		ui_loge("gr_texticon: source has wrong format\n");
		return;
	}

	x += overscan_offset_x;
	y += overscan_offset_y;

	if (outside(x, y) || outside(x+icon->width-1, y+icon->height-1)) return;

	unsigned char* src_p = icon->data;
	unsigned char* dst_p = gr_draw->data + y*gr_draw->row_bytes + x*gr_draw->pixel_bytes;

	text_blend(src_p, icon->row_bytes,
		dst_p, gr_draw->row_bytes,
		icon->width, icon->height);
}

void gr_color(unsigned char r, unsigned char g, unsigned char b, unsigned char a)
{
#if UI_ARBG
	gr_current_r = b;
	gr_current_g = g;
	gr_current_b = r;
	gr_current_a = a;
#else
	gr_current_r = r;
	gr_current_g = g;
	gr_current_b = b;
	gr_current_a = a;
#endif
}

void gr_clear(void)
{
	int x, y;

	if (gr_current_r == gr_current_g && gr_current_r == gr_current_b) {
		memset(gr_draw->data, gr_current_r, gr_draw->height * gr_draw->row_bytes);
	} else {
		unsigned char* px = gr_draw->data;
		for (y = 0; y < gr_draw->height; ++y) {
			for (x = 0; x < gr_draw->width; ++x) {
				*px++ = gr_current_r;
				*px++ = gr_current_g;
				*px++ = gr_current_b;
				px++;
			}
			px += gr_draw->row_bytes - (gr_draw->width * gr_draw->pixel_bytes);
		}
	}
}

void gr_fill(int x1, int y1, int x2, int y2)
{
	unsigned char* p;
	int x, y;
	unsigned char* px;

	x1 += overscan_offset_x;
	y1 += overscan_offset_y;

	x2 += overscan_offset_x;
	y2 += overscan_offset_y;

	if (outside(x1, y1) || outside(x2-1, y2-1))
		return;
	p = gr_draw->data + y1 * gr_draw->row_bytes + x1 * gr_draw->pixel_bytes;
	if (gr_current_a == 255) {
		for (y = y1; y < y2; ++y) {
			px = p;
			for (x = x1; x < x2; ++x) {
				*px++ = gr_current_r;
				*px++ = gr_current_g;
				*px++ = gr_current_b;
				*px++ = 255;
			}
			p += gr_draw->row_bytes;
		}
	} else if (gr_current_a > 0) {
		for (y = y1; y < y2; ++y) {
			px = p;
			for (x = x1; x < x2; ++x) {
				*px = (*px * (255-gr_current_a) + gr_current_r * gr_current_a) / 255;
				++px;
				*px = (*px * (255-gr_current_a) + gr_current_g * gr_current_a) / 255;
				++px;
				*px = (*px * (255-gr_current_a) + gr_current_b * gr_current_a) / 255;
				++px;
				*px++ = 255;
			}
			p += gr_draw->row_bytes;
		}
	}
}

void gr_blit(GRSurface* source, int sx, int sy, int w, int h, int dx, int dy)
{
	int i;
	int j;
	unsigned char* src_p;
	unsigned char* dst_p;

	if (source == NULL)
		return;

	if (gr_draw->pixel_bytes != source->pixel_bytes) {
		ui_loge("gr_blit: source has wrong format\n");
		return;
	}

	dx += overscan_offset_x;
	dy += overscan_offset_y;

	if (outside(dx, dy) || outside(dx+w-1, dy+h-1))
		return;

	src_p = source->data + sy*source->row_bytes + sx*source->pixel_bytes;
	dst_p = gr_draw->data + dy*gr_draw->row_bytes + dx*gr_draw->pixel_bytes;

	for (i = 0; i < h; ++i) {
		if (source->pixel_bytes == 4) {
			unsigned char *p0 = src_p;
			unsigned char *p1 = dst_p;
			unsigned char alpha = 255;
			for (j = 0; j < w; j++) {
				alpha = *(p0+3);
				*p1 = (*p1 * (255-alpha) + *p0++ * alpha) / 255;
				++p1;
				*p1 = (*p1 * (255-alpha) + *p0++ * alpha) / 255;
				++p1;
				*p1 = (*p1 * (255-alpha) + *p0++ * alpha) / 255;
				++p1;
				*p1++ = 255;
				++p0;
			}
		} else {
			memcpy(dst_p, src_p, w * source->pixel_bytes);
		}
		src_p += source->row_bytes;
		dst_p += gr_draw->row_bytes;
	}
}

unsigned int gr_get_width(GRSurface* surface)
{
	if (surface == NULL) {
		return 0;
	}
	return surface->width;
}

unsigned int gr_get_height(GRSurface* surface)
{
	if (surface == NULL) {
		return 0;
	}
	return surface->height;
}

int gr_init_bmp_font(const char* name, GRFont** dest)
{
	GRFont* font = (GRFont*)(calloc(1, sizeof(*gr_font)));
	int res = 0;

	if (font == NULL) {
		return -1;
	}

	res = res_create_alpha_surface(name, &(font->texture));
	if (res < 0) {
		free(font);
		return res;
	}

	// The font image should be a 96x2 array of character images.  The
	// columns are the printable ASCII characters 0x20 - 0x7f.  The
	// top row is regular text; the bottom row is bold.
	font->char_width = font->texture->width / 96;
	font->char_height = font->texture->height / 2;

	*dest = font;

	return 0;
}

static void gr_init_default_font(void)
{
	unsigned char* bits;

	ui_logd("read font: default\n");


	// fall back to the compiled-in font.
	gr_font = (GRFont*)(calloc(1, sizeof(*gr_font)));
	gr_font->texture = (GRSurface*)(malloc(sizeof(*gr_font->texture)));
	gr_font->texture->width = font.width;
	gr_font->texture->height = font.height;
	gr_font->texture->row_bytes = font.width;
	gr_font->texture->pixel_bytes = 1;

	bits = (unsigned char*)(malloc(font.width * font.height));
	gr_font->texture->data = (unsigned char*)(bits);

	unsigned char data;
	unsigned char* in = font.rundata;
	while ((data = *in++)) {
		memset(bits, (data & 0x80) ? 255 : 0, data & 0x7f);
		bits += (data & 0x7f);
	}

	gr_font->char_width = font.char_width;
	gr_font->char_height = font.char_height;

	ui_logd("font char_width=%d, char_height=%d\n",
		gr_font->char_width,
		gr_font->char_height);
}

void gr_flip(void)
{
	gr_draw = gr_backend->flip();
}

int gr_init(void)
{
	gr_init_default_font();

	if (!gr_draw) {
		gr_backend = open_fbdev();
		gr_draw = gr_backend->init();
		if (gr_draw == NULL) {
			return -1;
		}
	}

	overscan_offset_x = gr_draw->width * overscan_percent / 100;
	overscan_offset_y = gr_draw->height * overscan_percent / 100;

	gr_flip();
	gr_flip();

	return 0;
}

void gr_exit(void)
{
	gr_backend->exit();

	if (gr_font) {
		if (gr_font->texture) {
			if (gr_font->texture->data) {
				free(gr_font->texture->data);
				gr_font->texture->data = NULL;
			}
			free(gr_font->texture);
			gr_font->texture = NULL;
		}
		free(gr_font);
		gr_font = NULL;
	}
}

int gr_fb_width(void)
{
	return gr_draw->width - 2*overscan_offset_x;
}

int gr_fb_height(void)
{
	return gr_draw->height - 2*overscan_offset_y;
}

void gr_fb_blank(bool blank)
{
	gr_backend->blank(blank);
}

void osd_render_test(int mode)
{
	int x;
	int width = 0;

	gr_init();
	width = gr_fb_width();

	switch (mode) {
	case 1:
		for (x = 0; x <= 1200; x++) {
			gr_color(0, 0, 0, 0);
			gr_clear();
			if (x < 400) {
				gr_color(255, 0, 0, 255);
			} else {
				gr_color(255, (x-400)%128, 0, 255);
			}
			gr_fill(400, 150, 600, 350);

			if ((x%2 )== 0) {
				if (x < 400) {
					gr_color(255, 0, 255, 128);
				} else {
					gr_color(255, (x-400)%128, 255, 128);
				}

				gr_fill(width - 200 - x, 300, width - 200 - x + 100, 500);
			} else {
				if (x < 400) {
					gr_color(0, 0, 255, 128);
				} else {
					gr_color(0, (x-400)%128, 255, 128);
				}
				gr_fill(width - 200 - x, 600, width - 200 - x + 100, 800);
			}

			gr_flip();
		}
		break;
	case 2:
		for (x = 0; x <= 1200; ++x) {
			if (x < 400) {
				gr_color(255, 0, 0, 255);
			} else {
				gr_color(255, (x-400)%128, 0, 255);
			}
			gr_fill(400, 150, 600, 350);

			gr_color(255, 255, 255, 255);
			gr_text(gr_sys_font(), 500, 225, "hello, world!", 0);
			gr_color(255, 255, 0, 128);
			gr_text(gr_sys_font(), 300+x, 275, "pack my box with five dozen liquor jugs", 1);

			gr_color(0, 0, 255, 128);
			gr_fill(width - 200 - x, 300, width - 200 - x + 100, 500);

			gr_flip();
		}
		break;
	case 3:
		for (x = 0; x <= 1200; ++x) {
			gr_clear();
			if (x < 400) {
				gr_color(0, 0, 0, 255);
			} else {
				gr_color(0, (x-400)%128, 0, 255);
			}
			gr_clear();
			gr_fill(400, 150, 600, 350);

			gr_color(255, 255, 255, 255);
			gr_text(gr_sys_font(), 500, 225, "hello, world!", 0);
			gr_color(255, 255, 0, 128);
			gr_text(gr_sys_font(), 300+x, 275, "pack my box with five dozen liquor jugs", 1);

			gr_color(0, 0, 255, 128);
			gr_fill(width - 200 - x, 300, width - 200 - x + 100, 500);

			gr_flip();
		}
		break;
	default:
		gr_color(255, 0, 0, 255);
		gr_fill(0, 0, 600, 600);

		gr_color(0, 255, 0, 255);
		gr_fill(700, 700, 1300, 1000);
		gr_flip();
		break;
	}
}

