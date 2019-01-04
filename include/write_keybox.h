/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#ifndef WRITE_KEYBOX_H_
#define	WRITE_KEYBOX_H_

#include <common.h>

/*
 * write_keybox_to_secure_storage
 *
 * @received_data:	the data received from usb
 * @len:		size of received_data
 *
 * @return a negative number in case of error, or 0 on success.
 */
uint32_t write_keybox_to_secure_storage(uint8_t *received_data, uint32_t len);
#endif

