/*
 * Copyright (C) 2014 The Android Open Source Project
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
#include "minui.h"
#include "graphics.h"
#include "minui_log.h"
#include "../osd/osd_hw.h"
#include <video_fb.h>

#define DOUBLE_BUFFER
/* Graphic Device */
static GraphicDevice *gdev = NULL;

static GRSurface* fbdev_init(void);
static GRSurface* fbdev_flip(void);
static void fbdev_blank(bool);
static void fbdev_exit(void);
extern int video_scale_bitmap(void);
static GRSurface gr_framebuffer[2];
static bool double_buffered;
static int displayed_buffer;
GRSurface* gr_draw = NULL;

static minui_backend my_backend = {
	.init = fbdev_init,
	.flip = fbdev_flip,
	.blank = fbdev_blank,
	.exit = fbdev_exit,
};

static unsigned long env_strtoul(const char *name, int base)
{
	unsigned long ret = 0;
	char *str = NULL;

	str = getenv(name);
	if (str)
		ret = simple_strtoul(str, NULL, base);

	if (base == 16)
		ui_logd("%s: 0x%lx\n", name, ret);
	else if (base == 10)
		ui_logd("%s: %ld\n", name, ret);

	return ret;
}

minui_backend* open_fbdev(void)
{
	return &my_backend;
}

static void fbdev_blank(bool blank)
{
	int osd_index;

	osd_index = get_osd_layer();
	osd_enable_hw(osd_index, blank);
}

static void set_displayed_framebuffer(unsigned n)
{
	int osd_index;

	if ( n > 1 || !double_buffered)
		return;
	osd_index = get_osd_layer();

	if (double_buffered) {
		osd_pan_display_hw(osd_index, 0, n * gr_framebuffer[0].height);
		ui_logd("pan display:yoffset=%d\n", n * gr_framebuffer[0].height);
	}
	displayed_buffer = n;
}

static GRSurface* fbdev_init(void)
{
	u32 color_index, display_bpp;
	char buf[16] = {};
	char *outputmode = NULL;
	char mode[64];

	outputmode = getenv("outputmode");
	if (!outputmode)
		return NULL;

	memset(mode, 0, sizeof(mode));
	sprintf(mode, "vout output %s", outputmode);
	run_command(mode, 0);

	color_index = env_strtoul("display_color_index", 10);
	display_bpp = env_strtoul("display_bpp", 10);

	setenv("display_color_index", "32");
	setenv("display_bpp", "32");
	gdev = video_hw_init(MIDDLE_MODE);
	if (gdev == NULL) {
		ui_loge("Initialize video device failed!\n");
		return NULL;
	}
	gr_framebuffer[0].width = gdev->fb_width;
	gr_framebuffer[0].height = gdev->fb_height;
	gr_framebuffer[0].row_bytes = gdev->fb_width * gdev->gdfBytesPP;
	gr_framebuffer[0].pixel_bytes = gdev->gdfBytesPP;
	gr_framebuffer[0].data = (unsigned char *)(long long)(gdev->frameAdrs);
	memset(gr_framebuffer[0].data, 0,
		gr_framebuffer[0].height * gr_framebuffer[0].row_bytes);

#ifdef DOUBLE_BUFFER
	double_buffered = true;
	memcpy(gr_framebuffer+1, gr_framebuffer, sizeof(GRSurface));
	gr_framebuffer[1].data = gr_framebuffer[0].data +
		gr_framebuffer[0].height * gr_framebuffer[0].row_bytes;
	gr_draw = gr_framebuffer+1;
#else
	double_buffered = false;
	// Without double-buffering, we allocate RAM for a buffer to
	// draw in, and then "flipping" the buffer consists of a
	// memcpy from the buffer we allocated to the framebuffer.

	gr_draw = (GRSurface*) malloc(sizeof(GRSurface));
	memcpy(gr_draw, gr_framebuffer, sizeof(GRSurface));
	gr_draw->data = (unsigned char*) malloc(gr_draw->height * gr_draw->row_bytes);
	if (!gr_draw->data) {
		ui_loge("failed to allocate in-memory surface");
		return NULL;
	}
#endif
	memset(gr_draw->data, 0, gr_draw->height * gr_draw->row_bytes);
	set_displayed_framebuffer(0);

	ui_logi("framebuffer: (%d x %d)\n", gr_draw->width, gr_draw->height);

	fbdev_blank(true);
	fbdev_blank(false);

#ifdef CONFIG_OSD_SCALE_ENABLE
	video_scale_bitmap();
#endif
	sprintf(buf, "%d", color_index);
	setenv("display_color_index", buf);
	sprintf(buf, "%d", display_bpp);
	setenv("display_bpp", buf);
	return gr_draw;
}

static GRSurface* fbdev_flip(void)
{
	if (double_buffered) {
		// Change gr_draw to point to the buffer currently displayed,
		// then flip the driver so we're displaying the other buffer
		// instead.
		ui_logd("fbdev_flip:gr_draw=0x%lx\n",
			(unsigned long)(unsigned char*)gr_draw->data);
		flush_cache((unsigned long)gr_draw->data, gr_draw->row_bytes * gr_draw->height);
		gr_draw = gr_framebuffer + displayed_buffer;
		set_displayed_framebuffer(1-displayed_buffer);
	} else {
		// Copy from the in-memory surface to the framebuffer.
		set_displayed_framebuffer(0);
		memcpy(gr_framebuffer[0].data, gr_draw->data,
			gr_draw->height * gr_draw->row_bytes);
		ui_logd("flip: \n");
	}
	return gr_draw;
}

static void fbdev_exit(void)
{
	if (!double_buffered && gr_draw) {
		free(gr_draw->data);
		free(gr_draw);
	}
	gr_draw = NULL;
}
