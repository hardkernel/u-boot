/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 */

#ifndef __RKFLASH_API_H
#define __RKFLASH_API_H

#ifdef CONFIG_RKSFC_NOR
#include "sfc_nor.h"
#include "sfc.h"

int rk_snor_init(struct udevice *udev);
u32 rk_snor_get_capacity(struct udevice *udev);
int rk_snor_read(struct udevice *udev, u32 sec, u32 n_sec, void *p_data);
int rk_snor_write(struct udevice *udev, u32 sec, u32 n_sec, const void *p_data);
#endif

#endif
