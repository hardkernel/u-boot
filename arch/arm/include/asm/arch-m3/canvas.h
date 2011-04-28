/*
 * AMLOGIC Canvas management driver.
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
 * Author:  Tim Yao <timyao@amlogic.com>
 *
 */

#ifndef CANVAS_H
#define CANVAS_H

typedef struct {
    ulong addr;
    u32 width;
    u32 height;
    u32 wrap;
    u32 blkmode;
} canvas_t;

#define OSD1_CANVAS_INDEX 0x40
#define OSD2_CANVAS_INDEX 0x43
#define ALLOC_CANVAS_INDEX  0x46

#define GE2D_MAX_CANVAS_INDEX   0x5f

#define DISPLAY_CANVAS_BASE_INDEX   0x60
#define DISPLAY_CANVAS_MAX_INDEX    0x62 

#define DEINTERLACE_CANVAS_BASE_INDEX	0x63
#define DEINTERLACE_CANVAS_MAX_INDEX	0x6a

extern void canvas_config(u32 index, ulong addr, u32 width,
                          u32 height, u32 wrap, u32 blkmode);

extern void canvas_read(u32 index, canvas_t *p);

extern void canvas_copy(unsigned src, unsigned dst);

extern void canvas_update_addr(u32 index, u32 addr);

extern unsigned int canvas_get_addr(u32 index);

#endif /* CANVAS_H */
