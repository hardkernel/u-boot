/*
 * Clock setup for SMDK5422 board based on EXYNOS5
 *
 * Copyright (C) 2013 Samsung Electronics
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#ifndef __TYPEDEF_H__
#define __TYPEDEF_H__

typedef unsigned long long  u64;
typedef unsigned int        u32;
typedef unsigned short      u16;
typedef unsigned char       u8;
typedef signed   int        s32;
typedef signed   short      s16;
typedef signed   char       s8;

typedef unsigned int        U32;
typedef unsigned short      U16;
typedef unsigned char       U8;
typedef signed   int        S32;
typedef signed   short      S16;
typedef signed   char       S8;

#ifndef __cplusplus
typedef unsigned char        bool;
#endif
typedef unsigned char		BOOL;

typedef enum {
	TX, RX
} DIR;

#undef FALSE
#undef TRUE

#define FALSE 0
#define TRUE 1
#define false 0
#define true 1
#define NULL 0

#endif //__TYPEDEF_H__
