/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2020 Rockchip Electronics Co., Ltd
 */

#ifndef __MISC_OTP_H__
#define __MISC_OTP_H__

struct udevice *misc_otp_get_device(u32 capability);
int misc_otp_read(struct udevice *dev, int offset, void *buf, int size);
int misc_otp_write(struct udevice *dev, int offset, const void *buf, int size);

#endif
