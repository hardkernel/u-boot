/*
 * drivers/amlogic/display/osd/osd_hw.h
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

#ifndef _OSD_HW_H_
#define _OSD_HW_H_

#include "osd.h"

#define REG_OFFSET (0x20)
#define OSD_RELATIVE_BITS 0x33370

extern void osd_init_hw(void);
extern void osd_set_color_key_hw(u32 index, u32 bpp, u32 colorkey);
extern void osd_srckey_enable_hw(u32  index, u8 enable);
extern void osd_set_gbl_alpha_hw(u32 index, u32 gbl_alpha);
extern u32 osd_get_gbl_alpha_hw(u32  index);
extern int read_rdma_table(void);
extern void osd_set_color_mode(u32 index,
			       const struct color_bit_define_s *color);
extern void osd_update_disp_axis_hw(
	u32 index,
	u32 display_h_start,
	u32 display_h_end,
	u32 display_v_start,
	u32 display_v_end,
	u32 xoffset,
	u32 yoffset,
	u32 mode_change);
extern void osd_setup_hw(u32 index,
			 u32 xoffset,
			 u32 yoffset,
			 u32 xres,
			 u32 yres,
			 u32 xres_virtual ,
			 u32 yres_virtual,
			 u32 disp_start_x,
			 u32 disp_start_y,
			 u32 disp_end_x,
			 u32 disp_end_y,
			 u32 fbmem,
			 const struct color_bit_define_s *color);
extern void osd_set_order_hw(u32 index, u32 order);
extern void osd_get_order_hw(u32 index, u32 *order);
extern void osd_set_free_scale_enable_hw(u32 index, u32 enable);
extern void osd_get_free_scale_enable_hw(u32 index, u32 *free_scale_enable);
extern void osd_set_free_scale_mode_hw(u32 index, u32 freescale_mode);
extern void osd_get_free_scale_mode_hw(u32 index, u32 *freescale_mode);
extern void osd_set_4k2k_fb_mode_hw(u32 fb_for_4k2k);
extern void osd_get_free_scale_mode_hw(u32 index, u32 *freescale_mode);
extern void osd_set_free_scale_width_hw(u32 index, u32 width);
extern void osd_get_free_scale_width_hw(u32 index, u32 *free_scale_width);
extern void osd_set_free_scale_height_hw(u32 index, u32 height);
extern void osd_get_free_scale_height_hw(u32 index, u32 *free_scale_height);
extern void osd_get_free_scale_axis_hw(u32 index, s32 *x0, s32 *y0, s32 *x1,
				       s32 *y1);
extern void osd_set_free_scale_axis_hw(u32 index, s32 x0, s32 y0, s32 x1,
				       s32 y1);
extern void osd_get_scale_axis_hw(u32 index, s32 *x0, s32 *y0, s32 *x1,
				  s32 *y1);
extern void osd_get_window_axis_hw(u32 index, s32 *x0, s32 *y0, s32 *x1,
				   s32 *y1);
extern void osd_set_window_axis_hw(u32 index, s32 x0, s32 y0, s32 x1, s32 y1);
extern void osd_set_scale_axis_hw(u32 index, s32 x0, s32 y0, s32 x1, s32 y1);
extern void osd_get_block_windows_hw(u32 index, u32 *windows);
extern void osd_set_block_windows_hw(u32 index, u32 *windows);
extern void osd_get_block_mode_hw(u32 index, u32 *mode);
extern void osd_set_block_mode_hw(u32 index, u32 mode);
extern void osd_enable_3d_mode_hw(u32 index, u32 enable);
extern void osd_set_2x_scale_hw(u32 index, u16 h_scale_enable,
				u16 v_scale_enable);
extern void osd_get_flush_rate_hw(u32 *break_rate);
extern void osd_set_reverse_hw(u32 index, u32 reverse);
extern void osd_get_reverse_hw(u32 index, u32 *reverse);
extern void osd_set_rotate_on_hw(u32 index, u32 on_off);
extern void osd_get_rotate_on_hw(u32 index, u32 *on_off);
extern void osd_set_antiflicker_hw(u32 index, u32 vmode, u32 yres);
extern void osd_get_antiflicker_hw(u32 index, u32 *on_off);
extern void osd_set_update_state_hw(u32 index, u32 up_free);
extern void osd_get_update_state_hw(u32 index, u32 *up_free);
extern void osd_get_angle_hw(u32 index, u32 *angle);
extern void osd_set_angle_hw(u32 index, u32 angle, u32  virtual_osd1_yres,
			     u32 virtual_osd2_yres);
extern void osd_get_clone_hw(u32 index, u32 *clone);
extern void osd_set_clone_hw(u32 index, u32 clone);
extern void osd_set_update_pan_hw(u32 index);
extern void osd_set_rotate_angle_hw(u32 index, u32 angle);
extern void osd_get_rotate_angle_hw(u32 index, u32 *angle);
extern void osd_get_prot_canvas_hw(u32 index, s32 *x_start, s32 *y_start,
				   s32 *x_end, s32 *y_end);
extern void osd_set_prot_canvas_hw(u32 index, s32 x_start, s32 y_start,
				   s32 x_end, s32 y_end);
extern void osd_setpal_hw(u32 index, unsigned regno, unsigned red,
			  unsigned green, unsigned blue, unsigned transp);
extern void osd_enable_hw(u32 index, u32 enable);
extern void osd_pan_display_hw(u32 index, unsigned int xoffset,
			       unsigned int yoffset);
extern void osd_get_hw_para(struct hw_para_s **para);

#endif
