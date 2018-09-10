/*
 * drivers/amlogic/display/osd/osd_fb.h
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

#ifndef _OSD_FB_H_
#define _OSD_FB_H_

void img_mode_set(u32 display_mode);
void img_addr_set(ulong pic_image);
void img_type_set(u32 type);
int img_osd_init(void);
int img_bmp_display(ulong bmp_image, int x, int y);
int img_raw_display(ulong raw_image, int x, int y);
int img_osd_clear(void);
void img_osd_uninit(void);
int img_display(ulong bmp_image, int x, int y);
int img_scale(void);
void img_raw_size_set(u32 raw_width, u32 raw_height, u32 raw_bpp);

#endif
