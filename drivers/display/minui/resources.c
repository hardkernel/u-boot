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

#include "minui.h"
#include "bmp.h"
#include "minui_log.h"

#define SURFACE_DATA_ALIGNMENT 8

static GRSurface* malloc_surface(size_t data_size)
{
	size_t size;
	unsigned char* temp;
	GRSurface* surface;

	size = sizeof(GRSurface) + data_size + SURFACE_DATA_ALIGNMENT;
	temp = (unsigned char*)(malloc(size));
	memset(temp, 0x0, size);
	if (temp == NULL)
		return NULL;
	surface = (GRSurface*)(temp);
	surface->data = temp + sizeof(GRSurface) +
		(SURFACE_DATA_ALIGNMENT - (sizeof(GRSurface) % SURFACE_DATA_ALIGNMENT));
	return surface;
}

#if 0
// "display" surfaces are transformed into the framebuffer's required
// pixel format (currently only RGBX is supported) at load time, so
// gr_blit() can be nothing more than a memcpy() for each row.  The
// next two functions are the only ones that know anything about the
// framebuffer pixel format; they need to be modified if the
// framebuffer format changes (but nothing else should).

// Allocate and return a GRSurface* sufficient for storing an image of
// the indicated size in the framebuffer pixel format.
static GRSurface* init_display_surface(unsigned int width, unsigned int height) {
	GRSurface* surface = malloc_surface(width * height * 4);
	if (surface == NULL)
		return NULL;

	surface->width = width;
	surface->height = height;
	surface->row_bytes = width * 4;
	surface->pixel_bytes = 4;

	return surface;
}

// Copy 'input_row' to 'output_row', transforming it to the
// framebuffer pixel format.  The input format depends on the value of
// 'channels':
//
//   1 - input is 8-bit grayscale
//   3 - input is 24-bit RGB
//   4 - input is 32-bit RGBA/RGBX
//
// 'width' is the number of pixels in the row.
static void transform_rgb_to_draw(unsigned char* input_row,
                                  unsigned char* output_row,
                                  int channels, int width) {
	int x;
	unsigned char* ip = input_row;
	unsigned char* op = output_row;

	switch (channels) {
		case 1:
			// expand gray level to RGBX
			for (x = 0; x < width; ++x) {
				*op++ = *ip;
				*op++ = *ip;
				*op++ = *ip;
				*op++ = 0xff;
				ip++;
			}
			break;

		case 3:
			// expand RGBA to RGBX
			for (x = 0; x < width; ++x) {
				*op++ = *ip++;
				*op++ = *ip++;
				*op++ = *ip++;
				*op++ = 0xff;
			}
			break;

		case 4:
			// copy RGBA to RGBX
			memcpy(output_row, input_row, width*4);
			break;
		default:
			ui_logd("wrong channels.\n");
			break;
	}
}
#endif

int res_create_display_surface(const char* name, GRSurface** pSurface)
{
	GRSurface* surface = NULL;
	BITMAPINFOHEADER stBmpInfoHeader = {0};
	BmpInfo_t stBmpinfo = {0};
	unsigned int width = 0, height = 0;
	unsigned char *buffer = NULL;
	int ret = 0;

	*pSurface = NULL;
	ret = read_bmp(name, &stBmpInfoHeader, &buffer);
	if (ret < 0) {
		ui_loge("res_create_display_surface failed\n");
		return ret;
	}

	ui_logd("res_create_display_surface,name = %s, buffer=%p\n", name, buffer);
	ui_logd("stBmpInfoHeader.biBitCount =%d\n", stBmpInfoHeader.biBitCount);

	stBmpinfo.bgcolor = 0xff0000;
	stBmpinfo.fgcolor = 0xffff00;
	stBmpinfo.width = stBmpInfoHeader.biWidth;
	stBmpinfo.height = stBmpInfoHeader.biHeight;
	stBmpinfo.bmpformat = stBmpInfoHeader.biBitCount;
	stBmpinfo.bmpbuf = buffer;
	if (stBmpInfoHeader.biBitCount < 32)
		stBmpInfoHeader.biBitCount = 32;
	width = stBmpInfoHeader.biWidth * stBmpInfoHeader.biBitCount >> 3;
	height = stBmpInfoHeader.biHeight;

	surface = malloc_surface(width * height);
	if (surface == NULL) {
		ret = -2;
		goto exit;
	}

	surface->width = stBmpInfoHeader.biWidth;
	surface->height = height;
	surface->row_bytes = width;
	surface->pixel_bytes = stBmpInfoHeader.biBitCount >> 3;

	ret = load_bmp(&stBmpinfo, surface->data);
	if (ret < 0) {
		ret = -3;
		goto exit;
	}

	*pSurface = surface;

exit:
	if (ret < 0 && surface != NULL) {
		free(surface);
	}
	return ret;
}

int res_create_alpha_surface(const char* name, GRSurface** pSurface)
{
	GRSurface* surface = NULL;
	BITMAPINFOHEADER stBmpInfoHeader = {0};
	BmpInfo_t stBmpinfo = {0};
	unsigned int width = 0, height = 0;
	unsigned char *buffer = NULL;
	int ret = 0;

	*pSurface = NULL;
	ret = read_bmp(name, &stBmpInfoHeader, &buffer);
	if (ret < 0) {
		return ret;
	}

	stBmpinfo.bgcolor = 0xfffffff;
	stBmpinfo.fgcolor = 0xfffffff;
	stBmpinfo.width = stBmpInfoHeader.biWidth;
	stBmpinfo.height = stBmpInfoHeader.biHeight;
	stBmpinfo.bmpformat = stBmpInfoHeader.biBitCount;
	stBmpinfo.bmpbuf = buffer;
	width = stBmpInfoHeader.biWidth * stBmpInfoHeader.biBitCount;
	height = stBmpInfoHeader.biHeight;
	ui_logd("width=%d, height =%d stBmpInfoHeader.biWidth=%d, stBmpInfoHeader.biBitCount=%d\n",
		width, height,stBmpInfoHeader.biWidth,stBmpInfoHeader.biBitCount);

	surface = malloc_surface(width * height);
	if (surface == NULL) {
		ret = -2;
		goto exit;
	}

	surface->width = stBmpInfoHeader.biWidth;
	surface->height = height;
	surface->row_bytes = width;
	surface->pixel_bytes = 1;

	ret = load_bmp(&stBmpinfo, surface->data);
	if (ret < 0) {
		ret = -3;
		goto exit;
	}

	*pSurface = surface;

exit:
	if (ret < 0 && surface != NULL) {
		free(surface);
	}
	return ret;
}

void res_free_surface(GRSurface* surface)
{
	if (surface) {
		free(surface);
		surface = NULL;
	}
}
