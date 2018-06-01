/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

#ifndef _RKFLASH_DEBUG_H
#define _RKFLASH_DEBUG_H

#include <common.h>
#include <dm.h>

/*
 * Test switch
 */
#define BLK_STRESS_TEST_EN	0

/*
 * Print switch, set to 1 if needed
 * I - info
 * E - error
 * HEX - multiline print
 */

#define	PRINT_SWI_SFC_I		0
#define	PRINT_SWI_SFC_E		1
#define PRINT_SWI_SFC_HEX	1

#define	PRINT_SWI_NANDC_I	0
#define	PRINT_SWI_NANDC_E	1
#define PRINT_SWI_NANDC_HEX	1

#if (PRINT_SWI_SFC_I)
#define PRINT_SFC_I(...) printf(__VA_ARGS__)
#else
#define PRINT_SFC_I(...)
#endif

#if (PRINT_SWI_SFC_E)
#define PRINT_SFC_E(...) printf(__VA_ARGS__)
#else
#define PRINT_SFC_E(...)
#endif

#if (PRINT_SWI_SFC_HEX)
#define PRINT_SFC_HEX(s, buf, width, len)\
		rkflash_print_hex(s, buf, width, len)
#else
#define PRINT_SFC_HEX(s, buf, width, len)
#endif

#if (PRINT_SWI_NANDC_I)
#define PRINT_NANDC_I(...) printf(__VA_ARGS__)
#else
#define PRINT_NANDC_I(...)
#endif

#if (PRINT_SWI_NANDC_E)
#define PRINT_NANDC_E(...) printf(__VA_ARGS__)
#else
#define PRINT_NANDC_E(...)
#endif

#if (PRINT_SWI_NANDC_HEX)
#define PRINT_NANDC_HEX(s, buf, width, len)\
		rkflash_print_hex(s, buf, width, len)
#else
#define PRINT_NANDC_HEX(s, buf, width, len)
#endif

void rkflash_print_hex(char *s, void *buf, u32 width, u32 len);
void rkflash_test(struct udevice *p_dev);

#endif
