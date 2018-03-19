/*
 * Copyright 2018, Rockchip Electronics Co., Ltd
 * qiujian, <qiujian@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef ATTESTATION_KEY_H_
#define ATTESTATION_KEY_H_

#include <common.h>

typedef enum {
	ATAP_RESULT_OK,
	ATAP_RESULT_ERROR_DEVICE_NOT_FOUND,
	ATAP_RESULT_ERROR_PARTITION_NOT_FOUND,
	ATAP_RESULT_ERROR_BLOCK_READ,
	ATAP_RESULT_ERROR_BLOCK_WRITE,
	ATAP_RESULT_ERROR_INVALID_HEAD,
	ATAP_RESULT_ERROR_INVALID_BLOCK_NUM,
	ATAP_RESULT_ERROR_INVALID_DEVICE_ID,
	ATAP_RESULT_ERROR_BUF_COPY,
	ATAP_RESULT_ERROR_STORAGE,
} atap_result;

/* load attestation key from misc partition. */
atap_result load_attestation_key(struct blk_desc *dev_desc,
				disk_partition_t *misc_partition);

#endif	//ATTESTATION_KEY_H_
