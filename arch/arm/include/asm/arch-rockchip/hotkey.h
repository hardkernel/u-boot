/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _ROCKCHIP_HOTKEY_H_
#define _ROCKCHIP_HOTKEY_H_

enum hotkey_t {
	HK_INVAL,
	HK_BROM_DNL,
	HK_FASTBOOT,
	HK_ROCKUSB_DNL,
	HK_SYSMEM,
};

bool is_hotkey(enum hotkey_t id);
void hotkey_run(enum hotkey_t id);
#endif
