/*
* Copyright (C) 2017 Amlogic, Inc. All rights reserved.
* *
This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
* *
This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
* *
You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
* *
Description:
*/

#include "render_api.h"
#include "minui_log.h"
#include "graphics.h"
#include "minui.h"

int in_fastboot_mode = 0;

void set_fastboot_flag(int flag)
{
	/* 1: in fastboot mode, 0: in other mode */
	in_fastboot_mode = flag;
}

int screen_init(void)
{
	int ret = -1;
	ret = gr_init();
	if (ret < 0)
		ui_loge("screen_init: fail.\n");
	else
		ui_logd("screen_init: success.\n");

	return ret;
}

void screen_uninit(void)
{
	gr_exit();
}

int gr_init_ext_font(const char* font, GRFont** dest)
{
	int res = -1;

	if (!font)
		return -1;
	ui_logd("read font: %s\n", font);
	res = gr_init_bmp_font(font, dest);
	if (res < 0) {
		ui_loge("gr_init_ext_font: load font %s fail\n", font);
		return res;
	}

	ui_logd("font char_width=%d, char_height=%d\n",
			(*dest)->char_width, (*dest)->char_height);
	return 0;
}

int surface_loadbmp(GRSurface** surface, const char* filename)
{
	int ret = -1;

	ret = res_create_display_surface(filename, surface);
	if (ret < 0)
		ui_loge("surface_loadbmp: load %s fail.\n", filename);
	else
		ui_logd("surface_loadbmp: load %s success.\n", filename);

	return ret;
}

void surface_disaplay(GRSurface* surface, int sx, int sy, int dx, int dy)
{
	if (surface)
		gr_blit(surface, sx, sy, surface->width, surface->height, dx, dy);
}

void screen_setcolor(unsigned int color)
{
	gr_color(((color & 0xFF000000) >> 24), ((color & 0x00FF0000) >> 16),
			((color & 0x0000FF00) >> 8), ((color & 0x000000FF) >> 0));
}

void screen_drawtextline(const GRFont* font, int x, int y, const char *s, bool bold)
{
	gr_text(font, x, y, s, bold);
}

void screen_fillrect(int x, int y, int w, int h)
{
	gr_fill(x, y, x+w, y+h);
}

void screen_update(void)
{
	gr_flip();
}
