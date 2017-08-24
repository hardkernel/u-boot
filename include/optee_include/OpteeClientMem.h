/*
 * Copyright 2017, Rockchip Electronics Co., Ltd
 * hisping lin, <hisping.lin@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <linux/types.h>

void OpteeClientMemInit(void);

void *OpteeClientMemAlloc(uint32_t length);

void  OpteeClientMemFree(void *mem);
