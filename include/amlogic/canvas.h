/*
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

#ifndef CANVAS_H
#define CANVAS_H

#define DMC_REG_BASE            0xc8838000
#define DC_CAV_LUT_DATAL        (0x12 << 2)
#define DC_CAV_LUT_DATAH        (0x13 << 2)
#define DC_CAV_LUT_ADDR         (0x14 << 2)
#define DC_CAV_LUT_RDATAL       (0x15 << 2)
#define DC_CAV_LUT_RDATAH       (0x16 << 2)

#define CANVAS_ADDR_LMASK       0x1fffffff
#define CANVAS_WIDTH_LMASK      0x7
#define CANVAS_WIDTH_LWID       3
#define CANVAS_WIDTH_LBIT       29

#define CANVAS_WIDTH_HMASK      0x1ff
#define CANVAS_WIDTH_HBIT       0
#define CANVAS_HEIGHT_MASK      0x1fff
#define CANVAS_HEIGHT_BIT       9
#define CANVAS_YWRAP            (1<<23)
#define CANVAS_XWRAP            (1<<22)
#define CANVAS_ADDR_NOWRAP      0x00
#define CANVAS_ADDR_WRAPX       0x01
#define CANVAS_ADDR_WRAPY       0x02
#define CANVAS_BLKMODE_MASK     3
#define CANVAS_BLKMODE_BIT      24
#define CANVAS_BLKMODE_LINEAR   0x00
#define CANVAS_BLKMODE_32X32    0x01
#define CANVAS_BLKMODE_64X32    0x02

#define CANVAS_LUT_INDEX_BIT    0
#define CANVAS_LUT_INDEX_MASK   0x7
#define CANVAS_LUT_WR_EN        (0x2 << 8)
#define CANVAS_LUT_RD_EN        (0x1 << 8)

typedef struct {
	ulong addr;
	u32 width;
	u32 height;
	u32 wrap;
	u32 blkmode;
} canvas_t;

#define OSD1_CANVAS_INDEX 0x40
#define OSD2_CANVAS_INDEX 0x43

extern void canvas_init(void);

extern void canvas_config(u32 index, ulong addr, u32 width,
			  u32 height, u32 wrap, u32 blkmode);

extern void canvas_read(u32 index, canvas_t *p);

extern void canvas_copy(unsigned src, unsigned dst);

extern void canvas_update_addr(u32 index, u32 addr);

extern unsigned int canvas_get_addr(u32 index);

#endif /* CANVAS_H */
