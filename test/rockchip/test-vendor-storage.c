/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/vendor.h>

int board_vendor_storage_test(int argc, char * const argv[])
{
	return vendor_storage_test();
}
