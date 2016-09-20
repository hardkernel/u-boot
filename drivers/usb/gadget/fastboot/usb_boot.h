/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * USB top level defines
 */

#ifndef __USB_BOOT_H__
#define __USB_BOOT_H__
#include <common.h>

/* ISO C Standard Definitions */
typedef unsigned   char    u8_t;
typedef signed     char    s8_t;
typedef unsigned   short   u16_t;
typedef signed     short   s16_t;
typedef unsigned   int     u32_t;
typedef signed     int     s32_t;
typedef unsigned   long  long  u64_t;
typedef signed     long   long s64_t;

/* Linux definitions */
typedef u8_t     __u8;
typedef s8_t     __s8;
typedef u16_t    __u16;
typedef s16_t    __s16;
typedef u32_t    __u32;
typedef s32_t    __s32;
typedef u64_t    __u64;
typedef s64_t    __s64;

typedef u8_t     u_int8_t;
typedef u16_t    u_int16_t;
typedef u32_t    u_int32_t;
typedef u64_t    u_int64_t;

typedef s8_t     s8;
typedef u8_t     u8;
typedef s16_t    s16;
typedef u16_t    u16;
typedef s32_t    s32;
typedef u32_t    u32;
typedef u64_t    u64;

typedef __u16    __le16;
typedef __u16    __be16;
typedef __u32    __le32;
typedef __u32    __be32;
typedef __u64    __le64;
typedef __u64    __be64;

#endif
