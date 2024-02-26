/*
 * Copyright (C) 2015 Google, Inc
 * Written by Simon Glass <sjg@chromium.org>
 *
 * Based on Rockchip's drivers/power/pmic/pmic_rk808.c:
 * Copyright (C) 2012 rockchips
 * zyw <zyw@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <errno.h>
#include <log.h>
#include <linux/delay.h>
#include <power/rk8xx_pmic.h>
#include <power/pmic.h>
#include <power/regulator.h>

#ifndef CONFIG_SPL_BUILD
#define ENABLE_DRIVER
#endif

/* Not used or exisit register and configure */
#define NA			-1

/* Field Definitions */
#define RK808_BUCK_VSEL_MASK	0x3f
#define RK808_BUCK4_VSEL_MASK	0xf
#define RK808_LDO_VSEL_MASK	0x1f

#define RK818_BUCK_VSEL_MASK		0x3f
#define RK818_BUCK4_VSEL_MASK		0x1f
#define RK818_LDO_VSEL_MASK		0x1f
#define RK818_LDO3_ON_VSEL_MASK	0xf
#define RK818_BOOST_ON_VSEL_MASK	0xe0
#define RK818_USB_ILIM_SEL_MASK		0x0f
#define RK818_USB_CHG_SD_VSEL_MASK	0x70

/* RK809 BUCK5 */
#define RK809_BUCK5_CONFIG(n)		(0xde + (n) * 1)
#define RK809_BUCK5_VSEL_MASK		0x07

/* RK817 BUCK */
#define RK817_BUCK_ON_VSEL(n)		(0xbb + 3 * (n - 1))
#define RK817_BUCK_SLP_VSEL(n)		(0xbc + 3 * (n - 1))
#define RK817_BUCK_VSEL_MASK		0x7f
#define RK817_BUCK_CONFIG(i)		(0xba + (i) * 3)

/* RK817 LDO */
#define RK817_LDO_ON_VSEL(n)		(0xcc + 2 * (n - 1))
#define RK817_LDO_SLP_VSEL(n)		(0xcd + 2 * (n - 1))
#define RK817_LDO_VSEL_MASK		0x7f

/* RK817 ENABLE */
#define RK817_POWER_EN(n)		(0xb1 + (n))
#define RK817_POWER_SLP_EN(n)		(0xb5 + (n))

/*
 * Ramp delay
 */
#define RK805_RAMP_RATE_OFFSET		3
#define RK805_RAMP_RATE_MASK		(3 << RK805_RAMP_RATE_OFFSET)
#define RK805_RAMP_RATE_3MV_PER_US	(0 << RK805_RAMP_RATE_OFFSET)
#define RK805_RAMP_RATE_6MV_PER_US	(1 << RK805_RAMP_RATE_OFFSET)
#define RK805_RAMP_RATE_12_5MV_PER_US	(2 << RK805_RAMP_RATE_OFFSET)
#define RK805_RAMP_RATE_25MV_PER_US	(3 << RK805_RAMP_RATE_OFFSET)

#define RK808_RAMP_RATE_OFFSET		3
#define RK808_RAMP_RATE_MASK		(3 << RK808_RAMP_RATE_OFFSET)
#define RK808_RAMP_RATE_2MV_PER_US	(0 << RK808_RAMP_RATE_OFFSET)
#define RK808_RAMP_RATE_4MV_PER_US	(1 << RK808_RAMP_RATE_OFFSET)
#define RK808_RAMP_RATE_6MV_PER_US	(2 << RK808_RAMP_RATE_OFFSET)
#define RK808_RAMP_RATE_10MV_PER_US	(3 << RK808_RAMP_RATE_OFFSET)

#define RK817_RAMP_RATE_OFFSET		6
#define RK817_RAMP_RATE_MASK		(0x3 << RK817_RAMP_RATE_OFFSET)
#define RK817_RAMP_RATE_3MV_PER_US	(0x0 << RK817_RAMP_RATE_OFFSET)
#define RK817_RAMP_RATE_6_3MV_PER_US	(0x1 << RK817_RAMP_RATE_OFFSET)
#define RK817_RAMP_RATE_12_5MV_PER_US	(0x2 << RK817_RAMP_RATE_OFFSET)
#define RK817_RAMP_RATE_25MV_PER_US	(0x3 << RK817_RAMP_RATE_OFFSET)

struct rk8xx_reg_info {
	uint min_uv;
	uint step_uv;
	u8 vsel_reg;
	u8 vsel_sleep_reg;
	u8 config_reg;
	u8 vsel_mask;
	u8 min_sel;
	/* only for buck now */
	u8 max_sel;
	u8 range_num;
};

static const struct rk8xx_reg_info rk806_buck[] = {
	/* buck 1 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(1), RK806_BUCK_SLP_VSEL(1), RK806_BUCK_CONFIG(1), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(1), RK806_BUCK_SLP_VSEL(1), RK806_BUCK_CONFIG(1), RK806_BUCK_VSEL_MASK, 0xa0, 0xec, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(1), RK806_BUCK_SLP_VSEL(1), RK806_BUCK_CONFIG(1), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 2 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(2), RK806_BUCK_SLP_VSEL(2), RK806_BUCK_CONFIG(2), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(2), RK806_BUCK_SLP_VSEL(2), RK806_BUCK_CONFIG(2), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(2), RK806_BUCK_SLP_VSEL(2), RK806_BUCK_CONFIG(2), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 3 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(3), RK806_BUCK_SLP_VSEL(3), RK806_BUCK_CONFIG(3), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(3), RK806_BUCK_SLP_VSEL(3), RK806_BUCK_CONFIG(3), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(3), RK806_BUCK_SLP_VSEL(3), RK806_BUCK_CONFIG(3), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 4 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(4), RK806_BUCK_SLP_VSEL(4), RK806_BUCK_CONFIG(4), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(4), RK806_BUCK_SLP_VSEL(4), RK806_BUCK_CONFIG(4), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(4), RK806_BUCK_SLP_VSEL(4), RK806_BUCK_CONFIG(4), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 5 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(5), RK806_BUCK_SLP_VSEL(5), RK806_BUCK_CONFIG(5), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(5), RK806_BUCK_SLP_VSEL(5), RK806_BUCK_CONFIG(5), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(5), RK806_BUCK_SLP_VSEL(5), RK806_BUCK_CONFIG(5), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 6 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(6), RK806_BUCK_SLP_VSEL(6), RK806_BUCK_CONFIG(6), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(6), RK806_BUCK_SLP_VSEL(6), RK806_BUCK_CONFIG(6), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(6), RK806_BUCK_SLP_VSEL(6), RK806_BUCK_CONFIG(6), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 7 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(7), RK806_BUCK_SLP_VSEL(7), RK806_BUCK_CONFIG(7), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(7), RK806_BUCK_SLP_VSEL(7), RK806_BUCK_CONFIG(7), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(7), RK806_BUCK_SLP_VSEL(7), RK806_BUCK_CONFIG(7), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 8 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(8), RK806_BUCK_SLP_VSEL(8), RK806_BUCK_CONFIG(8), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(8), RK806_BUCK_SLP_VSEL(8), RK806_BUCK_CONFIG(8), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(8), RK806_BUCK_SLP_VSEL(8), RK806_BUCK_CONFIG(8), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 9 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(9), RK806_BUCK_SLP_VSEL(9), RK806_BUCK_CONFIG(9), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(9), RK806_BUCK_SLP_VSEL(9), RK806_BUCK_CONFIG(9), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(9), RK806_BUCK_SLP_VSEL(9), RK806_BUCK_CONFIG(9), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
	/* buck 10 */
	{  500000,   6250, RK806_BUCK_ON_VSEL(10), RK806_BUCK_SLP_VSEL(10), RK806_BUCK_CONFIG(10), RK806_BUCK_VSEL_MASK, 0x00, 0x9f, 3},
	{  1500000, 25000, RK806_BUCK_ON_VSEL(10), RK806_BUCK_SLP_VSEL(10), RK806_BUCK_CONFIG(10), RK806_BUCK_VSEL_MASK, 0xa0, 0xed, 3},
	{  3400000,     0, RK806_BUCK_ON_VSEL(10), RK806_BUCK_SLP_VSEL(10), RK806_BUCK_CONFIG(10), RK806_BUCK_VSEL_MASK, 0xed, 0xff, 3},
};

static const struct rk8xx_reg_info rk806_nldo[] = {
	/* nldo1 */
	{  500000, 12500, RK806_NLDO_ON_VSEL(1), RK806_NLDO_SLP_VSEL(1), NA, RK806_NLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_NLDO_ON_VSEL(1), RK806_NLDO_SLP_VSEL(1), NA, RK806_NLDO_VSEL_MASK, 0xE8, },
	/* nldo2 */
	{  500000, 12500, RK806_NLDO_ON_VSEL(2), RK806_NLDO_SLP_VSEL(2), NA, RK806_NLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_NLDO_ON_VSEL(2), RK806_NLDO_SLP_VSEL(2), NA, RK806_NLDO_VSEL_MASK, 0xE8, },
	/* nldo3 */
	{  500000, 12500, RK806_NLDO_ON_VSEL(3), RK806_NLDO_SLP_VSEL(3), NA, RK806_NLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_NLDO_ON_VSEL(3), RK806_NLDO_SLP_VSEL(3), NA, RK806_NLDO_VSEL_MASK, 0xE8, },
	/* nldo4 */
	{  500000, 12500, RK806_NLDO_ON_VSEL(4), RK806_NLDO_SLP_VSEL(4), NA, RK806_NLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_NLDO_ON_VSEL(4), RK806_NLDO_SLP_VSEL(4), NA, RK806_NLDO_VSEL_MASK, 0xE8, },
	/* nldo5 */
	{  500000, 12500, RK806_NLDO_ON_VSEL(5), RK806_NLDO_SLP_VSEL(5), NA, RK806_NLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_NLDO_ON_VSEL(5), RK806_NLDO_SLP_VSEL(5), NA, RK806_NLDO_VSEL_MASK, 0xE8, },
};

static const struct rk8xx_reg_info rk806_pldo[] = {
	/* pldo1 */
	{  500000, 12500, RK806_PLDO_ON_VSEL(1), RK806_PLDO_SLP_VSEL(1), NA, RK806_PLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_PLDO_ON_VSEL(1), RK806_PLDO_SLP_VSEL(1), NA, RK806_PLDO_VSEL_MASK, 0xE8, },
	/* pldo2 */
	{  500000, 12500, RK806_PLDO_ON_VSEL(2), RK806_PLDO_SLP_VSEL(2), NA, RK806_PLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_PLDO_ON_VSEL(2), RK806_PLDO_SLP_VSEL(2), NA, RK806_PLDO_VSEL_MASK, 0xE8, },
	/* pldo3 */
	{  500000, 12500, RK806_PLDO_ON_VSEL(3), RK806_PLDO_SLP_VSEL(3), NA, RK806_PLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_PLDO_ON_VSEL(3), RK806_PLDO_SLP_VSEL(3), NA, RK806_PLDO_VSEL_MASK, 0xE8, },
	/* pldo4 */
	{  500000, 12500, RK806_PLDO_ON_VSEL(4), RK806_PLDO_SLP_VSEL(4), NA, RK806_PLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_PLDO_ON_VSEL(4), RK806_PLDO_SLP_VSEL(4), NA, RK806_PLDO_VSEL_MASK, 0xE8, },
	/* pldo5 */
	{  500000, 12500, RK806_PLDO_ON_VSEL(5), RK806_PLDO_SLP_VSEL(5), NA, RK806_PLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_PLDO_ON_VSEL(5), RK806_PLDO_SLP_VSEL(5), NA, RK806_PLDO_VSEL_MASK, 0xE8, },
	/* pldo6 */
	{  500000, 12500, RK806_PLDO_ON_VSEL(6), RK806_PLDO_SLP_VSEL(6), NA, RK806_PLDO_VSEL_MASK, 0x00, },
	{  3400000,    0, RK806_PLDO_ON_VSEL(6), RK806_PLDO_SLP_VSEL(6), NA, RK806_PLDO_VSEL_MASK, 0xE8, },
};

static const struct rk8xx_reg_info rk808_buck[] = {
	{ 712500,   12500, REG_BUCK1_ON_VSEL, REG_BUCK1_SLP_VSEL, REG_BUCK1_CONFIG, RK808_BUCK_VSEL_MASK, 0x00, 0x3f, 1},
	{ 712500,   12500, REG_BUCK2_ON_VSEL, REG_BUCK2_SLP_VSEL, REG_BUCK2_CONFIG, RK808_BUCK_VSEL_MASK, 0x00, 0x3f, 1},
	{ NA,       NA,    NA,		      NA,		  REG_BUCK3_CONFIG, NA,                   NA,   NA,   1},
	{ 1800000, 100000, REG_BUCK4_ON_VSEL, REG_BUCK4_SLP_VSEL, REG_BUCK4_CONFIG, RK808_BUCK4_VSEL_MASK,0x00, 0x0f, 1},
};

static const struct rk8xx_reg_info rk816_buck[] = {
	/* buck 1 */
	{  712500,  12500, REG_BUCK1_ON_VSEL, REG_BUCK1_SLP_VSEL, REG_BUCK1_CONFIG, RK818_BUCK_VSEL_MASK, 0x00, 0x3b, 3},
	{ 1800000, 200000, REG_BUCK1_ON_VSEL, REG_BUCK1_SLP_VSEL, REG_BUCK1_CONFIG, RK818_BUCK_VSEL_MASK, 0x3c, 0x3e, 3},
	{ 2300000,      0, REG_BUCK1_ON_VSEL, REG_BUCK1_SLP_VSEL, REG_BUCK1_CONFIG, RK818_BUCK_VSEL_MASK, 0x3f, 0x3f, 3},
	/* buck 2 */
	{  712500,  12500, REG_BUCK2_ON_VSEL, REG_BUCK2_SLP_VSEL, REG_BUCK2_CONFIG, RK818_BUCK_VSEL_MASK, 0x00, 0x3b, 3},
	{ 1800000, 200000, REG_BUCK2_ON_VSEL, REG_BUCK2_SLP_VSEL, REG_BUCK2_CONFIG, RK818_BUCK_VSEL_MASK, 0x3c, 0x3e, 3},
	{ 2300000,      0, REG_BUCK2_ON_VSEL, REG_BUCK2_SLP_VSEL, REG_BUCK2_CONFIG, RK818_BUCK_VSEL_MASK, 0x3f, 0x3f, 3},
	/* buck 3 */
	{  NA,     NA,     NA,		      NA,		  REG_BUCK3_CONFIG, NA,                   NA,   NA,   1},
	/* buck 4 */
	{  800000, 100000, REG_BUCK4_ON_VSEL, REG_BUCK4_SLP_VSEL, REG_BUCK4_CONFIG, RK818_BUCK4_VSEL_MASK,0x00, 0x1b, 1},
};

static const struct rk8xx_reg_info rk809_buck5[] = {
	/* buck 5 */
	{ 1500000,	0, RK809_BUCK5_CONFIG(0), RK809_BUCK5_CONFIG(1), NA, RK809_BUCK5_VSEL_MASK, 0x00, 0x00, 4},
	{ 1800000, 200000, RK809_BUCK5_CONFIG(0), RK809_BUCK5_CONFIG(1), NA, RK809_BUCK5_VSEL_MASK, 0x01, 0x03, 4},
	{ 2800000, 200000, RK809_BUCK5_CONFIG(0), RK809_BUCK5_CONFIG(1), NA, RK809_BUCK5_VSEL_MASK, 0x04, 0x05, 4},
	{ 3300000, 300000, RK809_BUCK5_CONFIG(0), RK809_BUCK5_CONFIG(1), NA, RK809_BUCK5_VSEL_MASK, 0x06, 0x07, 4},
};

static const struct rk8xx_reg_info rk817_buck[] = {
	/* buck 1 */
	{  500000,  12500, RK817_BUCK_ON_VSEL(1), RK817_BUCK_SLP_VSEL(1), RK817_BUCK_CONFIG(1), RK817_BUCK_VSEL_MASK, 0x00, 0x4f, 3},
	{ 1500000, 100000, RK817_BUCK_ON_VSEL(1), RK817_BUCK_SLP_VSEL(1), RK817_BUCK_CONFIG(1), RK817_BUCK_VSEL_MASK, 0x50, 0x58, 3},
	{ 2400000,	0, RK817_BUCK_ON_VSEL(1), RK817_BUCK_SLP_VSEL(1), RK817_BUCK_CONFIG(1), RK817_BUCK_VSEL_MASK, 0x59, 0x59, 3},
	/* buck 2 */
	{  500000,  12500, RK817_BUCK_ON_VSEL(2), RK817_BUCK_SLP_VSEL(2), RK817_BUCK_CONFIG(2), RK817_BUCK_VSEL_MASK, 0x00, 0x4f, 3},
	{ 1500000, 100000, RK817_BUCK_ON_VSEL(2), RK817_BUCK_SLP_VSEL(2), RK817_BUCK_CONFIG(2), RK817_BUCK_VSEL_MASK, 0x50, 0x58, 3},
	{ 2400000,	0, RK817_BUCK_ON_VSEL(2), RK817_BUCK_SLP_VSEL(2), RK817_BUCK_CONFIG(2), RK817_BUCK_VSEL_MASK, 0x59, 0x59, 3},
	/* buck 3 */
	{  500000,  12500, RK817_BUCK_ON_VSEL(3), RK817_BUCK_SLP_VSEL(3), RK817_BUCK_CONFIG(3), RK817_BUCK_VSEL_MASK, 0x00, 0x4f, 3},
	{ 1500000, 100000, RK817_BUCK_ON_VSEL(3), RK817_BUCK_SLP_VSEL(3), RK817_BUCK_CONFIG(3), RK817_BUCK_VSEL_MASK, 0x50, 0x58, 3},
	{ 2400000,	0, RK817_BUCK_ON_VSEL(3), RK817_BUCK_SLP_VSEL(3), RK817_BUCK_CONFIG(3), RK817_BUCK_VSEL_MASK, 0x59, 0x59, 3},
	/* buck 4 */
	{  500000,  12500, RK817_BUCK_ON_VSEL(4), RK817_BUCK_SLP_VSEL(4), RK817_BUCK_CONFIG(4), RK817_BUCK_VSEL_MASK, 0x00, 0x4f, 3},
	{ 1500000, 100000, RK817_BUCK_ON_VSEL(4), RK817_BUCK_SLP_VSEL(4), RK817_BUCK_CONFIG(4), RK817_BUCK_VSEL_MASK, 0x50, 0x62, 3},
	{ 3400000,	0, RK817_BUCK_ON_VSEL(4), RK817_BUCK_SLP_VSEL(4), RK817_BUCK_CONFIG(4), RK817_BUCK_VSEL_MASK, 0x63, 0x63, 3},
};

static const struct rk8xx_reg_info rk818_buck[] = {
	{ 712500,   12500, REG_BUCK1_ON_VSEL, REG_BUCK1_SLP_VSEL, REG_BUCK1_CONFIG, RK818_BUCK_VSEL_MASK, 0x00, 0x3f, 1},
	{ 712500,   12500, REG_BUCK2_ON_VSEL, REG_BUCK2_SLP_VSEL, REG_BUCK2_CONFIG, RK818_BUCK_VSEL_MASK, 0x00, 0x3f, 1},
	{ NA,       NA,    NA,		      NA,		  REG_BUCK3_CONFIG, NA,                   NA,   NA,   1},
	{ 1800000, 100000, REG_BUCK4_ON_VSEL, REG_BUCK4_SLP_VSEL, REG_BUCK4_CONFIG, RK818_BUCK4_VSEL_MASK,0x00, 0x10, 1},
};

#ifdef ENABLE_DRIVER
static const struct rk8xx_reg_info rk808_ldo[] = {
	{ 1800000, 100000, REG_LDO1_ON_VSEL, REG_LDO1_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO2_ON_VSEL, REG_LDO2_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
	{  800000, 100000, REG_LDO3_ON_VSEL, REG_LDO3_SLP_VSEL, NA, RK808_BUCK4_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO4_ON_VSEL, REG_LDO4_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO5_ON_VSEL, REG_LDO5_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
	{  800000, 100000, REG_LDO6_ON_VSEL, REG_LDO6_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
	{  800000, 100000, REG_LDO7_ON_VSEL, REG_LDO7_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO8_ON_VSEL, REG_LDO8_SLP_VSEL, NA, RK808_LDO_VSEL_MASK, },
};

static const struct rk8xx_reg_info rk816_ldo[] = {
	{ 800000, 100000, REG_LDO1_ON_VSEL, REG_LDO1_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 800000, 100000, REG_LDO2_ON_VSEL, REG_LDO2_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 800000, 100000, REG_LDO3_ON_VSEL, REG_LDO3_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 800000, 100000, REG_LDO4_ON_VSEL, REG_LDO4_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 800000, 100000, REG_LDO5_ON_VSEL, REG_LDO5_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 800000, 100000, REG_LDO6_ON_VSEL, REG_LDO6_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
};

static const struct rk8xx_reg_info rk817_ldo[] = {
	/* ldo1 */
	{  600000, 25000, RK817_LDO_ON_VSEL(1), RK817_LDO_SLP_VSEL(1), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(1), RK817_LDO_SLP_VSEL(1), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo2 */
	{  600000, 25000, RK817_LDO_ON_VSEL(2), RK817_LDO_SLP_VSEL(2), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(2), RK817_LDO_SLP_VSEL(2), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo3 */
	{  600000, 25000, RK817_LDO_ON_VSEL(3), RK817_LDO_SLP_VSEL(3), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(3), RK817_LDO_SLP_VSEL(3), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo4 */
	{  600000, 25000, RK817_LDO_ON_VSEL(4), RK817_LDO_SLP_VSEL(4), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(4), RK817_LDO_SLP_VSEL(4), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo5 */
	{  600000, 25000, RK817_LDO_ON_VSEL(5), RK817_LDO_SLP_VSEL(5), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(5), RK817_LDO_SLP_VSEL(5), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo6 */
	{  600000, 25000, RK817_LDO_ON_VSEL(6), RK817_LDO_SLP_VSEL(6), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(6), RK817_LDO_SLP_VSEL(6), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo7 */
	{  600000, 25000, RK817_LDO_ON_VSEL(7), RK817_LDO_SLP_VSEL(7), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(7), RK817_LDO_SLP_VSEL(7), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo8 */
	{  600000, 25000, RK817_LDO_ON_VSEL(8), RK817_LDO_SLP_VSEL(8), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(8), RK817_LDO_SLP_VSEL(8), NA, RK817_LDO_VSEL_MASK, 0x70, },
	/* ldo9 */
	{  600000, 25000, RK817_LDO_ON_VSEL(9), RK817_LDO_SLP_VSEL(9), NA, RK817_LDO_VSEL_MASK, 0x00, },
	{ 3400000,     0, RK817_LDO_ON_VSEL(9), RK817_LDO_SLP_VSEL(9), NA, RK817_LDO_VSEL_MASK, 0x70, },
};

static const struct rk8xx_reg_info rk818_ldo[] = {
	{ 1800000, 100000, REG_LDO1_ON_VSEL, REG_LDO1_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO2_ON_VSEL, REG_LDO2_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{  800000, 100000, REG_LDO3_ON_VSEL, REG_LDO3_SLP_VSEL, NA, RK818_LDO3_ON_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO4_ON_VSEL, REG_LDO4_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO5_ON_VSEL, REG_LDO5_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{  800000, 100000, REG_LDO6_ON_VSEL, REG_LDO6_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{  800000, 100000, REG_LDO7_ON_VSEL, REG_LDO7_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
	{ 1800000, 100000, REG_LDO8_ON_VSEL, REG_LDO8_SLP_VSEL, NA, RK818_LDO_VSEL_MASK, },
};
#endif

static const u16 rk818_chrg_cur_input_array[] = {
	450, 800, 850, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000
};

static const uint rk818_chrg_shutdown_vsel_array[] = {
	2780000, 2850000, 2920000, 2990000, 3060000, 3130000, 3190000, 3260000
};

static const struct rk8xx_reg_info *get_buck_reg(struct udevice *pmic,
						 int num, int uvolt)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);

	switch (priv->variant) {
	case RK806_ID:
		switch (num) {
		case 0 ... 9:
			if (uvolt < 1500000)
				return &rk806_buck[num * 3 + 0];
			else if (uvolt < 3400000)
				return &rk806_buck[num * 3 + 1];
			else
				return &rk806_buck[num * 3 + 2];
		}
	case RK805_ID:
	case RK816_ID:
		switch (num) {
		case 0:
		case 1:
			if (uvolt <= 1450000)
				return &rk816_buck[num * 3 + 0];
			else if (uvolt <= 2200000)
				return &rk816_buck[num * 3 + 1];
			else
				return &rk816_buck[num * 3 + 2];
		default:
			return &rk816_buck[num + 4];
		}

	case RK809_ID:
	case RK817_ID:
		switch (num) {
		case 0 ... 2:
			if (uvolt < 1500000)
				return &rk817_buck[num * 3 + 0];
			else if (uvolt < 2400000)
				return &rk817_buck[num * 3 + 1];
			else
				return &rk817_buck[num * 3 + 2];
		case 3:
			if (uvolt < 1500000)
				return &rk817_buck[num * 3 + 0];
			else if (uvolt < 3400000)
				return &rk817_buck[num * 3 + 1];
			else
				return &rk817_buck[num * 3 + 2];
		/* BUCK5 for RK809 */
		default:
			if (uvolt < 1800000)
				return &rk809_buck5[0];
			else if (uvolt < 2800000)
				return &rk809_buck5[1];
			else if (uvolt < 3300000)
				return &rk809_buck5[2];
			else
				return &rk809_buck5[3];
		}
	case RK818_ID:
		return &rk818_buck[num];
	default:
		return &rk808_buck[num];
	}
}

static int _buck_set_value(struct udevice *pmic, int buck, int uvolt)
{
	const struct rk8xx_reg_info *info = get_buck_reg(pmic, buck, uvolt);
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	int mask = info->vsel_mask;
	int val;

	if (info->vsel_reg == NA)
		return -ENOSYS;

	if (info->step_uv == 0)	/* Fixed voltage */
		val = info->min_sel;
	else
		val = ((uvolt - info->min_uv) / info->step_uv) + info->min_sel;

	debug("%s: volt=%d, buck=%d, reg=0x%x, mask=0x%x, val=0x%x\n",
	      __func__, uvolt, buck + 1, info->vsel_reg, mask, val);

	if (priv->variant == RK816_ID) {
		pmic_clrsetbits(pmic, info->vsel_reg, mask, val);
		return pmic_clrsetbits(pmic, RK816_REG_DCDC_EN2, 1 << 7, 1 << 7);
	} else {
		return pmic_clrsetbits(pmic, info->vsel_reg, mask, val);
	}
}

static int _buck_set_enable(struct udevice *pmic, int buck, bool enable)
{
	uint mask, value, en_reg;
	int ret;
	struct rk8xx_priv *priv = dev_get_priv(pmic);

	switch (priv->variant) {
	case RK806_ID:
		en_reg = RK806_POWER_EN(buck / 4);
		if (enable)
			value = ((1 << buck % 4) | (1 << (buck % 4 + 4)));
		else
			value = ((0 << buck % 4) | (1 << (buck % 4 + 4)));

		ret = pmic_reg_write(pmic, en_reg, value);
		break;
	case RK805_ID:
	case RK816_ID:
		if (buck >= 4) {
			buck -= 4;
			en_reg = RK816_REG_DCDC_EN2;
		} else {
			en_reg = RK816_REG_DCDC_EN1;
		}
		if (enable)
			value = ((1 << buck) | (1 << (buck + 4)));
		else
			value = ((0 << buck) | (1 << (buck + 4)));
		ret = pmic_reg_write(pmic, en_reg, value);
		break;

	case RK808_ID:
	case RK818_ID:
		mask = 1 << buck;
		if (enable) {
			ret = pmic_clrsetbits(pmic, REG_DCDC_ILMAX,
					      0, 3 << (buck * 2));
			if (ret)
				return ret;
		}
		ret = pmic_clrsetbits(pmic, REG_DCDC_EN, mask,
				      enable ? mask : 0);
		break;
	case RK809_ID:
	case RK817_ID:
		if (buck < 4) {
			if (enable)
				value = ((1 << buck) | (1 << (buck + 4)));
			else
				value = ((0 << buck) | (1 << (buck + 4)));
			ret = pmic_reg_write(pmic, RK817_POWER_EN(0), value);
		/* BUCK5 for RK809 */
		} else {
			if (enable)
				value = ((1 << 1) | (1 << 5));
			else
				value = ((0 << 1) | (1 << 5));
			ret = pmic_reg_write(pmic, RK817_POWER_EN(3), value);
		}
		break;
	default:
		ret = -EINVAL;
	}

	return ret;
}

#ifdef ENABLE_DRIVER
static int _buck_set_suspend_value(struct udevice *pmic, int buck, int uvolt)
{
	const struct rk8xx_reg_info *info = get_buck_reg(pmic, buck, uvolt);
	int mask = info->vsel_mask;
	int val;

	if (info->vsel_sleep_reg == NA)
		return -ENOSYS;

	if (info->step_uv == 0)
		val = info->min_sel;
	else
		val = ((uvolt - info->min_uv) / info->step_uv) + info->min_sel;

	debug("%s: volt=%d, buck=%d, reg=0x%x, mask=0x%x, val=0x%x\n",
	      __func__, uvolt, buck + 1, info->vsel_sleep_reg, mask, val);

	return pmic_clrsetbits(pmic, info->vsel_sleep_reg, mask, val);
}

static int _buck_get_enable(struct udevice *pmic, int buck)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	uint mask = 0;
	int ret = 0;

	switch (priv->variant) {
	case RK806_ID:
		mask = 1 << buck % 4;
		ret = pmic_reg_read(pmic, RK806_POWER_EN(buck / 4));
		break;
	case RK805_ID:
	case RK816_ID:
		if (buck >= 4) {
			mask = 1 << (buck - 4);
			ret = pmic_reg_read(pmic, RK816_REG_DCDC_EN2);
		} else {
			mask = 1 << buck;
			ret = pmic_reg_read(pmic, RK816_REG_DCDC_EN1);
		}
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << buck;
		ret = pmic_reg_read(pmic, REG_DCDC_EN);
		if (ret < 0)
			return ret;
		break;
	case RK809_ID:
	case RK817_ID:
		if (buck < 4) {
			mask = 1 << buck;
			ret = pmic_reg_read(pmic, RK817_POWER_EN(0));
		/* BUCK5 for RK809 */
		} else {
			mask = 1 << 1;
			ret = pmic_reg_read(pmic, RK817_POWER_EN(3));
		}
		break;
	}

	if (ret < 0)
		return ret;

	return ret & mask ? true : false;
}

static int _buck_set_ramp_delay(struct udevice *pmic, int buck, u32 ramp_delay)
{
	const struct rk8xx_reg_info *info = get_buck_reg(pmic, buck, 0);
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	u32 ramp_value, ramp_mask;
	int reg_value, ramp_reg1, ramp_reg2;

	if (info->config_reg == NA)
		return -ENOSYS;

	switch (priv->variant) {
	case RK805_ID:
		ramp_mask = RK805_RAMP_RATE_MASK;
		ramp_value = RK805_RAMP_RATE_12_5MV_PER_US;
		switch (ramp_delay) {
		case 0 ... 3000:
			ramp_value = RK805_RAMP_RATE_3MV_PER_US;
			break;
		case 3001 ... 6000:
			ramp_value = RK805_RAMP_RATE_6MV_PER_US;
			break;
		case 6001 ... 12500:
			ramp_value = RK805_RAMP_RATE_12_5MV_PER_US;
			break;
		case 12501 ... 25000:
			ramp_value = RK805_RAMP_RATE_25MV_PER_US;
			break;
		default:
			printf("buck%d ramp_delay: %d not supported\n",
			       buck, ramp_delay);
		}
		break;
	case RK806_ID:
		switch (ramp_delay) {
		case 1 ... 390:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_32CLK;
			break;
		case 391 ... 961:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_13CLK;
			break;
		case 962 ... 1560:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_8CLK;
			break;
		case 1561 ... 3125:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_4CLK;
			break;
		case 3126 ... 6250:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_2CLK;
			break;
		case 6251 ... 12500:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_1CLK;
			break;
		case 12501 ... 25000:
			ramp_value = RK806_RAMP_RATE_2LSB_PER_1CLK;
			break;
		case 25001 ... 50000: /* 50mV/us */
			ramp_value = RK806_RAMP_RATE_4LSB_PER_1CLK;
			break;
		default:
			ramp_value = RK806_RAMP_RATE_1LSB_PER_32CLK;
			printf("buck%d ramp_delay: %d not supported\n",
			       buck, ramp_delay);
			return -EINVAL;
		}
		ramp_reg1 = RK806_RAMP_RATE_REG1(buck);
		if (buck < 8)
			ramp_reg2 = RK806_RAMP_RATE_REG1_8;
		else
			ramp_reg2 = RK806_RAMP_RATE_REG9_10;

		reg_value = pmic_reg_read(pmic, ramp_reg1);
		if (reg_value < 0) {
			printf("buck%d read ramp reg(0x%x) error: %d", buck, ramp_reg1, reg_value);
			return reg_value;
		}
		reg_value &= 0x3f;

		pmic_reg_write(pmic,
			       ramp_reg1,
			       reg_value | (ramp_value & 0x03) << 0x06);

		reg_value = pmic_reg_read(pmic, ramp_reg2);
		if (reg_value < 0) {
			printf("buck%d read ramp reg(0x%x) error: %d", buck, ramp_reg2, reg_value);
			return reg_value;
		}

		return pmic_reg_write(pmic,
				      ramp_reg2,
				      reg_value | (ramp_value & 0x04) << (buck % 8));
	case RK808_ID:
	case RK816_ID:
	case RK818_ID:
		ramp_value = RK808_RAMP_RATE_6MV_PER_US;
		ramp_mask = RK808_RAMP_RATE_MASK;
		switch (ramp_delay) {
		case 1 ... 2000:
			ramp_value = RK808_RAMP_RATE_2MV_PER_US;
			break;
		case 2001 ... 4000:
			ramp_value = RK808_RAMP_RATE_4MV_PER_US;
			break;
		case 4001 ... 6000:
			ramp_value = RK808_RAMP_RATE_6MV_PER_US;
			break;
		case 6001 ... 10000:
			ramp_value = RK808_RAMP_RATE_6MV_PER_US;
			break;
		default:
			printf("buck%d ramp_delay: %d not supported\n",
			       buck, ramp_delay);
		}
		break;
	case RK809_ID:
	case RK817_ID:
		ramp_mask = RK817_RAMP_RATE_MASK;
		ramp_value = RK817_RAMP_RATE_12_5MV_PER_US;
		switch (ramp_delay) {
		case 0 ... 3000:
			ramp_value = RK817_RAMP_RATE_3MV_PER_US;
			break;
		case 3001 ... 6300:
			ramp_value = RK817_RAMP_RATE_6_3MV_PER_US;
			break;
		case 6301 ... 12500:
			ramp_value = RK817_RAMP_RATE_12_5MV_PER_US;
			break;
		case 12501 ... 25000:
			ramp_value = RK817_RAMP_RATE_12_5MV_PER_US;
			break;
		default:
			printf("buck%d ramp_delay: %d not supported\n",
			       buck, ramp_delay);
		}
		break;
	default:
		return -EINVAL;
	}

	return pmic_clrsetbits(pmic, info->config_reg, ramp_mask, ramp_value);
}

static int _buck_set_suspend_enable(struct udevice *pmic, int buck, bool enable)
{
	uint mask;
	int ret;
	struct rk8xx_priv *priv = dev_get_priv(pmic);

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		mask = 1 << buck;
		ret = pmic_clrsetbits(pmic, RK816_REG_DCDC_SLP_EN, mask,
				      enable ? mask : 0);
		break;
	case RK806_ID:
		if (buck <= 7) {
			mask = 1 << buck;
			ret = pmic_clrsetbits(pmic, RK806_BUCK_SUSPEND_EN, mask,
					      enable ? mask : 0);
		} else {
			if (buck == 8)
				mask = 0x40;
			else
				mask = 0x80;
			ret = pmic_clrsetbits(pmic, RK806_NLDO_SUSPEND_EN, mask,
					      enable ? mask : 0);
		}
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << buck;
		ret = pmic_clrsetbits(pmic, REG_SLEEP_SET_OFF1, mask,
				      enable ? 0 : mask);
		break;
	case RK809_ID:
	case RK817_ID:
		if (buck < 4)
			mask = 1 << buck;
		else
			mask = 1 << 5;	/* BUCK5 for RK809 */
		ret = pmic_clrsetbits(pmic, RK817_POWER_SLP_EN(0), mask,
				      enable ? mask : 0);
		break;
	default:
		ret = -EINVAL;
	}

	return ret;
}

static int _buck_get_suspend_enable(struct udevice *pmic, int buck)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	int ret, val;
	uint mask;

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		mask = 1 << buck;
		val = pmic_reg_read(pmic, RK816_REG_DCDC_SLP_EN);
		if (val < 0)
			return val;
		ret = val & mask ? 1 : 0;
		break;
	case RK806_ID:
		if (buck <= 7) {
			mask = 1 << buck % 7;
			val = pmic_reg_read(pmic, RK806_BUCK_SUSPEND_EN);
		} else {
			mask = 1 << ((buck - 7) + 6);
			val = pmic_reg_read(pmic, RK806_NLDO_SUSPEND_EN);
		}

		if (val < 0)
			return val;
		ret = val & mask ? 1 : 0;
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << buck;
		val = pmic_reg_read(pmic, REG_SLEEP_SET_OFF1);
		if (val < 0)
			return val;
		ret = val & mask ? 0 : 1;
		break;
	case RK809_ID:
	case RK817_ID:
		if (buck < 4)
			mask = 1 << buck;
		else
			mask = 1 << 5;	/* BUCK5 for RK809 */

		val = pmic_reg_read(pmic, RK817_POWER_SLP_EN(0));
		if (val < 0)
			return val;
		ret = val & mask ? 1 : 0;
		break;
	default:
		ret = -EINVAL;
	}

	return ret;
}

static const struct rk8xx_reg_info *get_ldo_reg(struct udevice *pmic,
						int num, int uvolt)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		return &rk816_ldo[num];
	case RK806_ID:
		if (uvolt < 3400000)
			return &rk806_nldo[num * 2];
		else
			return &rk806_nldo[num * 2 + 1];
	case RK809_ID:
	case RK817_ID:
		if (uvolt < 3400000)
			return &rk817_ldo[num * 2 + 0];
		else
			return &rk817_ldo[num * 2 + 1];
	case RK818_ID:
		return &rk818_ldo[num];
	default:
		return &rk808_ldo[num];
	}
}

static int _ldo_get_enable(struct udevice *pmic, int ldo)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	uint mask = 0;
	int ret = 0;

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		if (ldo >= 4) {
			mask = 1 << (ldo - 4);
			ret = pmic_reg_read(pmic, RK816_REG_LDO_EN2);
		} else {
			mask = 1 << ldo;
			ret = pmic_reg_read(pmic, RK816_REG_LDO_EN1);
		}
		break;
	case RK806_ID:
		if (ldo < 4) {
			mask = 1 << ldo % 4;
			ret = pmic_reg_read(pmic, RK806_NLDO_EN(ldo / 4));
		} else {
			mask = 1 << 2;
			ret = pmic_reg_read(pmic, RK806_NLDO_EN(2));
		}
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << ldo;
		ret = pmic_reg_read(pmic, REG_LDO_EN);
		if (ret < 0)
			return ret;
		break;
	case RK809_ID:
	case RK817_ID:
		if (ldo < 4) {
			mask = 1 << ldo;
			ret = pmic_reg_read(pmic, RK817_POWER_EN(1));
		} else if (ldo < 8) {
			mask = 1 << (ldo - 4);
			ret = pmic_reg_read(pmic, RK817_POWER_EN(2));
		} else if (ldo == 8) {
			mask = 1 << 0;
			ret = pmic_reg_read(pmic, RK817_POWER_EN(3));
		} else {
			return false;
		}
		break;
	}

	if (ret < 0)
		return ret;

	return ret & mask ? true : false;
}

static int _ldo_set_enable(struct udevice *pmic, int ldo, bool enable)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	uint mask, value, en_reg;
	int ret = 0;

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		if (ldo >= 4) {
			ldo -= 4;
			en_reg = RK816_REG_LDO_EN2;
		} else {
			en_reg = RK816_REG_LDO_EN1;
		}
		if (enable)
			value = ((1 << ldo) | (1 << (ldo + 4)));
		else
			value = ((0 << ldo) | (1 << (ldo + 4)));

		ret = pmic_reg_write(pmic, en_reg, value);
		break;
	case RK806_ID:
		if (ldo < 4) {
			en_reg = RK806_NLDO_EN(0);
			if (enable)
				value = ((1 << ldo % 4) | (1 << (ldo % 4 + 4)));
			else
				value = ((0 << ldo % 4) | (1 << (ldo % 4 + 4)));
			ret = pmic_reg_write(pmic, en_reg, value);
		} else {
			en_reg = RK806_NLDO_EN(2);
			if (enable)
				value = 0x44;
			else
				value = 0x40;
			ret = pmic_reg_write(pmic, en_reg, value);
		}
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << ldo;
		ret = pmic_clrsetbits(pmic, REG_LDO_EN, mask,
				      enable ? mask : 0);
		break;
	case RK809_ID:
	case RK817_ID:
		if (ldo < 4) {
			en_reg = RK817_POWER_EN(1);
		} else if (ldo < 8) {
			ldo -= 4;
			en_reg = RK817_POWER_EN(2);
		} else if (ldo == 8) {
			ldo = 0;	/* BIT 0 */
			en_reg = RK817_POWER_EN(3);
		} else {
			return -EINVAL;
		}
		if (enable)
			value = ((1 << ldo) | (1 << (ldo + 4)));
		else
			value = ((0 << ldo) | (1 << (ldo + 4)));
		ret = pmic_reg_write(pmic, en_reg, value);
		break;
	}

	if (enable)
		udelay(500);

	return ret;
}

static int _ldo_set_suspend_enable(struct udevice *pmic, int ldo, bool enable)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	uint mask;
	int ret = 0;

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		mask = 1 << ldo;
		ret = pmic_clrsetbits(pmic, RK816_REG_LDO_SLP_EN, mask,
				      enable ? mask : 0);
		break;
	case RK806_ID:
		mask = 1 << ldo;
		ret = pmic_clrsetbits(pmic, RK806_NLDO_SUSPEND_EN, mask,
				      enable ? mask : 0);
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << ldo;
		ret = pmic_clrsetbits(pmic, REG_SLEEP_SET_OFF2, mask,
				      enable ? 0 : mask);
		break;
	case RK809_ID:
	case RK817_ID:
		if (ldo == 8) {
			mask = 1 << 4;	/* LDO9 */
			ret = pmic_clrsetbits(pmic, RK817_POWER_SLP_EN(0), mask,
					      enable ? mask : 0);
		} else {
			mask = 1 << ldo;
			ret = pmic_clrsetbits(pmic, RK817_POWER_SLP_EN(1), mask,
					      enable ? mask : 0);
		}
		break;
	}

	return ret;
}

static int _ldo_get_suspend_enable(struct udevice *pmic, int ldo)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	int val, ret = 0;
	uint mask;

	switch (priv->variant) {
	case RK805_ID:
	case RK816_ID:
		mask = 1 << ldo;
		val = pmic_reg_read(pmic, RK816_REG_LDO_SLP_EN);
		if (val < 0)
			return val;
		ret = val & mask ? 1 : 0;
		break;
	case RK806_ID:
		mask = 1 << ldo;
		val = pmic_reg_read(pmic, RK806_NLDO_SUSPEND_EN);

		if (val < 0)
			return val;
		ret = val & mask ? 1 : 0;
		break;
	case RK808_ID:
	case RK818_ID:
		mask = 1 << ldo;
		val = pmic_reg_read(pmic, REG_SLEEP_SET_OFF2);
		if (val < 0)
			return val;
		ret = val & mask ? 0 : 1;
		break;
	case RK809_ID:
	case RK817_ID:
		if (ldo == 8) {
			mask = 1 << 4;	/* LDO9 */
			val = pmic_reg_read(pmic, RK817_POWER_SLP_EN(0));
			if (val < 0)
				return val;
			ret = val & mask ? 1 : 0;
		} else {
			mask = 1 << ldo;
			val = pmic_reg_read(pmic, RK817_POWER_SLP_EN(1));
			if (val < 0)
				return val;
			ret = val & mask ? 1 : 0;
		}
		break;
	}

	return ret;
}

static int buck_get_value(struct udevice *dev)
{
	int buck = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_buck_reg(dev->parent, buck, 0);
	int mask = info->vsel_mask;
	int i, ret, val;

	if (info->vsel_reg == NA)
		return -ENOSYS;

	ret = pmic_reg_read(dev->parent, info->vsel_reg);
	if (ret < 0)
		return ret;

	val = ret & mask;
	if (val >= info->min_sel && val <= info->max_sel)
		goto finish;

	/* unlucky to try */
	for (i = 1; i < info->range_num; i++) {
		info++;
		if (val <= info->max_sel && val >= info->min_sel)
			break;
	}

finish:
	return info->min_uv + (val - info->min_sel) * info->step_uv;
}

static int buck_set_value(struct udevice *dev, int uvolt)
{
	int buck = dev->driver_data - 1;

	return _buck_set_value(dev->parent, buck, uvolt);
}

static int buck_get_suspend_value(struct udevice *dev)
{
	int buck = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_buck_reg(dev->parent, buck, 0);
	int mask = info->vsel_mask;
	int i, ret, val;

	if (info->vsel_sleep_reg == NA)
		return -ENOSYS;

	ret = pmic_reg_read(dev->parent, info->vsel_sleep_reg);
	if (ret < 0)
		return ret;

	val = ret & mask;
	if (val <= info->max_sel && val >= info->min_sel)
		goto finish;

	/* unlucky to try */
	for (i = 1; i < info->range_num; i++) {
		info++;
		if (val <= info->max_sel && val >= info->min_sel)
			break;
	}

finish:
	return info->min_uv + (val - info->min_sel) * info->step_uv;
}

static int buck_set_suspend_value(struct udevice *dev, int uvolt)
{
	int buck = dev->driver_data - 1;

	return _buck_set_suspend_value(dev->parent, buck, uvolt);
}

static int buck_set_enable(struct udevice *dev, bool enable)
{
	int buck = dev->driver_data - 1;

	return _buck_set_enable(dev->parent, buck, enable);
}

static int buck_set_suspend_enable(struct udevice *dev, bool enable)
{
	int buck = dev->driver_data - 1;

	return _buck_set_suspend_enable(dev->parent, buck, enable);
}

static int buck_get_suspend_enable(struct udevice *dev)
{
	int buck = dev->driver_data - 1;

	return _buck_get_suspend_enable(dev->parent, buck);
}

static int buck_set_ramp_delay(struct udevice *dev, u32 ramp_delay)
{
	int buck = dev->driver_data - 1;

	return _buck_set_ramp_delay(dev->parent, buck, ramp_delay);
}

static int buck_get_enable(struct udevice *dev)
{
	int buck = dev->driver_data - 1;

	return _buck_get_enable(dev->parent, buck);
}

static int ldo_get_value(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_ldo_reg(dev->parent, ldo, 0);
	int mask = info->vsel_mask;
	int ret, val;

	if (info->vsel_reg == NA)
		return -ENOSYS;
	ret = pmic_reg_read(dev->parent, info->vsel_reg);
	if (ret < 0)
		return ret;
	val = ret & mask;

	return info->min_uv + val * info->step_uv;
}

static int ldo_set_value(struct udevice *dev, int uvolt)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_ldo_reg(dev->parent, ldo, uvolt);
	int mask = info->vsel_mask;
	int val;

	if (info->vsel_reg == NA)
		return -ENOSYS;

	if (info->step_uv == 0)
		val = info->min_sel;
	else
		val = ((uvolt - info->min_uv) / info->step_uv) + info->min_sel;

	debug("%s: volt=%d, ldo=%d, reg=0x%x, mask=0x%x, val=0x%x\n",
	      __func__, uvolt, ldo + 1, info->vsel_reg, mask, val);

	return pmic_clrsetbits(dev->parent, info->vsel_reg, mask, val);
}

static int ldo_set_suspend_value(struct udevice *dev, int uvolt)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_ldo_reg(dev->parent, ldo, uvolt);
	int mask = info->vsel_mask;
	int val;

	if (info->vsel_sleep_reg == NA)
		return -ENOSYS;

	if (info->step_uv == 0)
		val = info->min_sel;
	else
		val = ((uvolt - info->min_uv) / info->step_uv) + info->min_sel;

	debug("%s: volt=%d, ldo=%d, reg=0x%x, mask=0x%x, val=0x%x\n",
	      __func__, uvolt, ldo + 1, info->vsel_sleep_reg, mask, val);

	return pmic_clrsetbits(dev->parent, info->vsel_sleep_reg, mask, val);
}

static int ldo_get_suspend_value(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_ldo_reg(dev->parent, ldo, 0);
	int mask = info->vsel_mask;
	int val, ret;

	if (info->vsel_sleep_reg == NA)
		return -ENOSYS;

	ret = pmic_reg_read(dev->parent, info->vsel_sleep_reg);
	if (ret < 0)
		return ret;

	val = ret & mask;

	return info->min_uv + val * info->step_uv;
}

static int ldo_set_enable(struct udevice *dev, bool enable)
{
	int ldo = dev->driver_data - 1;

	return _ldo_set_enable(dev->parent, ldo, enable);
}

static int ldo_set_suspend_enable(struct udevice *dev, bool enable)
{
	int ldo = dev->driver_data - 1;

	return _ldo_set_suspend_enable(dev->parent, ldo, enable);
}

static int ldo_get_suspend_enable(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;

	return _ldo_get_suspend_enable(dev->parent, ldo);
}

static int ldo_get_enable(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;

	return _ldo_get_enable(dev->parent, ldo);
}

static int switch_set_enable(struct udevice *dev, bool enable)
{
	struct rk8xx_priv *priv = dev_get_priv(dev->parent);
	int ret = 0, sw = dev->driver_data - 1;
	uint mask = 0;

	switch (priv->variant) {
	case RK808_ID:
		mask = 1 << (sw + 5);
		ret = pmic_clrsetbits(dev->parent, REG_DCDC_EN, mask,
				      enable ? mask : 0);
		break;
	case RK809_ID:
		mask = (1 << (sw + 2)) | (1 << (sw + 6));
		ret = pmic_clrsetbits(dev->parent, RK817_POWER_EN(3), mask,
				      enable ? mask : (1 << (sw + 6)));
		break;
	case RK818_ID:
		mask = 1 << 6;
		ret = pmic_clrsetbits(dev->parent, REG_DCDC_EN, mask,
				      enable ? mask : 0);
		break;
	}

	debug("%s: switch%d, enable=%d, mask=0x%x\n",
	      __func__, sw + 1, enable, mask);

	return ret;
}

static int switch_get_enable(struct udevice *dev)
{
	struct rk8xx_priv *priv = dev_get_priv(dev->parent);
	int ret = 0, sw = dev->driver_data - 1;
	uint mask = 0;

	switch (priv->variant) {
	case RK808_ID:
		mask = 1 << (sw + 5);
		ret = pmic_reg_read(dev->parent, REG_DCDC_EN);
		break;
	case RK809_ID:
		mask = 1 << (sw + 2);
		ret = pmic_reg_read(dev->parent, RK817_POWER_EN(3));
		break;
	case RK818_ID:
		mask = 1 << 6;
		ret = pmic_reg_read(dev->parent, REG_DCDC_EN);
		break;
	}

	if (ret < 0)
		return ret;

	return ret & mask ? true : false;
}

static int switch_set_suspend_value(struct udevice *dev, int uvolt)
{
	return 0;
}

static int switch_get_suspend_value(struct udevice *dev)
{
	return 0;
}

static int switch_set_suspend_enable(struct udevice *dev, bool enable)
{
	struct rk8xx_priv *priv = dev_get_priv(dev->parent);
	int ret = 0, sw = dev->driver_data - 1;
	uint mask = 0;

	switch (priv->variant) {
	case RK808_ID:
		mask = 1 << (sw + 5);
		ret = pmic_clrsetbits(dev->parent, REG_SLEEP_SET_OFF1, mask,
				      enable ? 0 : mask);
		break;
	case RK809_ID:
		mask = 1 << (sw + 6);
		ret = pmic_clrsetbits(dev->parent, RK817_POWER_SLP_EN(0), mask,
				      enable ? mask : 0);
		break;
	case RK818_ID:
		mask = 1 << 6;
		ret = pmic_clrsetbits(dev->parent, REG_SLEEP_SET_OFF1, mask,
				      enable ? 0 : mask);
		break;
	}

	debug("%s: switch%d, enable=%d, mask=0x%x\n",
	      __func__, sw + 1, enable, mask);

	return ret;
}

static int switch_get_suspend_enable(struct udevice *dev)
{
	struct rk8xx_priv *priv = dev_get_priv(dev->parent);
	int val, ret = 0, sw = dev->driver_data - 1;
	uint mask = 0;

	switch (priv->variant) {
	case RK808_ID:
		mask = 1 << (sw + 5);
		val = pmic_reg_read(dev->parent, REG_SLEEP_SET_OFF1);
		if (val < 0)
			return val;
		ret = val & mask ? 0 : 1;
		break;
	case RK809_ID:
		mask = 1 << (sw + 6);
		val = pmic_reg_read(dev->parent, RK817_POWER_SLP_EN(0));
		if (val < 0)
			return val;
		ret = val & mask ? 1 : 0;
		break;
	case RK818_ID:
		mask = 1 << 6;
		val = pmic_reg_read(dev->parent, REG_SLEEP_SET_OFF1);
		if (val < 0)
			return val;
		ret = val & mask ? 0 : 1;
		break;
	}

	return ret;
}

/*
 * RK8xx switch does not need to set the voltage,
 * but if dts set regulator-min-microvolt/regulator-max-microvolt,
 * will cause regulator set value fail and not to enable this switch.
 * So add an empty function to return success.
 */
static int switch_get_value(struct udevice *dev)
{
	const char *supply_name[] = { "vcc9-supply", "vcc8-supply", };
	struct rk8xx_priv *priv = dev_get_priv(dev->parent);
	struct udevice *supply;
	int id = dev->driver_data - 1;

	if (!switch_get_enable(dev))
		return 0;

	/* note: rk817 only contains switch0 */
	if ((priv->variant == RK809_ID) || (priv->variant == RK817_ID)) {
		if (!uclass_get_device_by_phandle(UCLASS_REGULATOR,
						  dev_get_parent(dev),
						  supply_name[id],
						  &supply))
			return regulator_get_value(supply);
	}

	return 0;
}

static int switch_set_value(struct udevice *dev, int uvolt)
{
	return 0;
}

static const struct rk8xx_reg_info *get_pldo_reg(struct udevice *pmic,
						 int num, int uvolt)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);

	switch (priv->variant) {
	case RK806_ID:
		if (uvolt < 3400000)
			return &rk806_pldo[num * 2];
		else
			return &rk806_pldo[num * 2 + 1];
	default:
		return &rk806_pldo[num * 2];
	}
}

static int _pldo_get_enable(struct udevice *pmic, int pldo)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	uint mask = 0, en_reg;
	int ret = 0;

	switch (priv->variant) {
	case RK806_ID:
		if ((pldo < 3) || (pldo == 5)) {
			en_reg = RK806_PLDO_EN(0);
			mask = RK806_PLDO0_2_SET(pldo);
			if (pldo == 5)
				mask = (1 << 0);
			ret = pmic_reg_read(pmic, en_reg);
		} else if ((pldo == 3) || (pldo == 4)) {
			en_reg = RK806_PLDO_EN(1);
			if (pldo == 3)
				mask = (1 << 0);
			else
				mask = (1 << 1);
			ret = pmic_reg_read(pmic, en_reg);
		}
		break;

	default:
		return -EINVAL;
	}

	if (ret < 0)
		return ret;

	return ret & mask ? true : false;
}

static int _pldo_set_enable(struct udevice *pmic, int pldo, bool enable)
{
	struct rk8xx_priv *priv = dev_get_priv(pmic);
	uint value, en_reg;
	int ret = 0;

	switch (priv->variant) {
	case RK806_ID:
		if (pldo < 3) {
			en_reg = RK806_PLDO_EN(0);
			if (enable)
				value = RK806_PLDO0_2_SET(pldo);
			else
				value = RK806_PLDO0_2_CLR(pldo);
			ret = pmic_reg_write(pmic, en_reg, value);
		} else if (pldo == 3) {
			en_reg = RK806_PLDO_EN(1);
			if (enable)
				value = ((1 << 0) | (1 << 4));
			else
				value = (1 << 4);
			ret = pmic_reg_write(pmic, en_reg, value);
		} else if (pldo == 4) {
			en_reg = RK806_PLDO_EN(1);
			if (enable)
				value = ((1 << 1) | (1 << 5));
			else
				value = ((0 << 1) | (1 << 5));
			ret = pmic_reg_write(pmic, en_reg, value);
		} else if (pldo == 5) {
			en_reg = RK806_PLDO_EN(0);
			if (enable)
				value = ((1 << 0) | (1 << 4));
			else
				value = ((0 << 0) | (1 << 4));
			ret = pmic_reg_write(pmic, en_reg, value);
		}

		break;
	default:
		return -EINVAL;
	}

	return ret;
}

static int pldo_get_value(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_pldo_reg(dev->parent, ldo, 0);
	int mask = info->vsel_mask;
	int ret, val;

	if (info->vsel_reg == NA)
		return -EINVAL;

	ret = pmic_reg_read(dev->parent, info->vsel_reg);
	if (ret < 0)
		return ret;
	val = ret & mask;

	return info->min_uv + val * info->step_uv;
}

static int pldo_set_value(struct udevice *dev, int uvolt)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_pldo_reg(dev->parent, ldo, uvolt);
	int mask = info->vsel_mask;
	int val;

	if (info->vsel_reg == NA)
		return -EINVAL;

	if (info->step_uv == 0)
		val = info->min_sel;
	else
		val = ((uvolt - info->min_uv) / info->step_uv) + info->min_sel;

	debug("%s: volt=%d, ldo=%d, reg=0x%x, mask=0x%x, val=0x%x\n",
	      __func__, uvolt, ldo + 1, info->vsel_reg, mask, val);

	return pmic_clrsetbits(dev->parent, info->vsel_reg, mask, val);
}

static int pldo_set_enable(struct udevice *dev, bool enable)
{
	int ldo = dev->driver_data - 1;

	return _pldo_set_enable(dev->parent, ldo, enable);
}

static int pldo_get_enable(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;

	return _pldo_get_enable(dev->parent, ldo);
}

static int pldo_set_suspend_value(struct udevice *dev, int uvolt)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_pldo_reg(dev->parent, ldo, uvolt);;
	int mask = info->vsel_mask;
	int val;

	if (info->vsel_sleep_reg == NA)
		return -EINVAL;

	if (info->step_uv == 0)
		val = info->min_sel;
	else
		val = ((uvolt - info->min_uv) / info->step_uv) + info->min_sel;

	return pmic_clrsetbits(dev->parent, info->vsel_sleep_reg, mask, val);
}

static int pldo_get_suspend_value(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;
	const struct rk8xx_reg_info *info = get_pldo_reg(dev->parent, ldo, 0);
	int mask = info->vsel_mask;
	int val, ret;

	if (info->vsel_sleep_reg == NA)
		return -EINVAL;

	ret = pmic_reg_read(dev->parent, info->vsel_sleep_reg);
	if (ret < 0)
		return ret;

	val = ret & mask;

	return info->min_uv + val * info->step_uv;
}

static int _pldo_set_suspend_enable(struct udevice *pmic, int ldo, bool enable)
{
	uint mask;
	int ret;

	if (ldo < 5)
		mask = 1 << (ldo + 1);
	else
		mask = 1;
	ret = pmic_clrsetbits(pmic, RK806_PLDO_SUSPEND_EN, mask,
			      enable ? mask : 0);

	return ret;
}

static int _pldo_get_suspend_enable(struct udevice *pmic, int ldo)
{
	uint mask, val;
	int ret;

	if (ldo < 5)
		mask = 1 << (ldo + 1);
	else
		mask = 1;
	val = pmic_reg_read(pmic, RK806_PLDO_SUSPEND_EN);

	if (val < 0)
		return val;
	ret = val & mask ? 1 : 0;

	return ret;
}
static int pldo_set_suspend_enable(struct udevice *dev, bool enable)
{
	int ldo = dev->driver_data - 1;

	return _pldo_set_suspend_enable(dev->parent, ldo, enable);
}

static int pldo_get_suspend_enable(struct udevice *dev)
{
	int ldo = dev->driver_data - 1;

	return _pldo_get_suspend_enable(dev->parent, ldo);
}

static int rk8xx_buck_probe(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;

	uc_pdata = dev_get_uclass_platdata(dev);

	uc_pdata->type = REGULATOR_TYPE_BUCK;
	uc_pdata->mode_count = 0;

	return 0;
}

static int rk8xx_ldo_probe(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;

	uc_pdata = dev_get_uclass_platdata(dev);

	uc_pdata->type = REGULATOR_TYPE_LDO;
	uc_pdata->mode_count = 0;

	return 0;
}

static int rk8xx_switch_probe(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;

	uc_pdata = dev_get_uclass_platdata(dev);

	uc_pdata->type = REGULATOR_TYPE_FIXED;
	uc_pdata->mode_count = 0;

	return 0;
}

static int rk8xx_pldo_probe(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;

	uc_pdata = dev_get_uclass_platdata(dev);
	uc_pdata->type = REGULATOR_TYPE_LDO;
	uc_pdata->mode_count = 0;

	return 0;
}

static const struct dm_regulator_ops rk8xx_buck_ops = {
	.get_value  = buck_get_value,
	.set_value  = buck_set_value,
	.set_suspend_value = buck_set_suspend_value,
	.get_suspend_value = buck_get_suspend_value,
	.get_enable = buck_get_enable,
	.set_enable = buck_set_enable,
	.set_suspend_enable = buck_set_suspend_enable,
	.get_suspend_enable = buck_get_suspend_enable,
	.set_ramp_delay = buck_set_ramp_delay,
};

static const struct dm_regulator_ops rk8xx_ldo_ops = {
	.get_value  = ldo_get_value,
	.set_value  = ldo_set_value,
	.set_suspend_value = ldo_set_suspend_value,
	.get_suspend_value = ldo_get_suspend_value,
	.get_enable = ldo_get_enable,
	.set_enable = ldo_set_enable,
	.set_suspend_enable = ldo_set_suspend_enable,
	.get_suspend_enable = ldo_get_suspend_enable,
};

static const struct dm_regulator_ops rk8xx_switch_ops = {
	.get_value  = switch_get_value,
	.set_value  = switch_set_value,
	.get_enable = switch_get_enable,
	.set_enable = switch_set_enable,
	.set_suspend_enable = switch_set_suspend_enable,
	.get_suspend_enable = switch_get_suspend_enable,
	.set_suspend_value = switch_set_suspend_value,
	.get_suspend_value = switch_get_suspend_value,
};

static const struct dm_regulator_ops rk8xx_pldo_ops = {
	.get_value  = pldo_get_value,
	.set_value  = pldo_set_value,
	.set_suspend_value = pldo_set_suspend_value,
	.get_suspend_value = pldo_get_suspend_value,
	.get_enable = pldo_get_enable,
	.set_enable = pldo_set_enable,
	.set_suspend_enable = pldo_set_suspend_enable,
	.get_suspend_enable = pldo_get_suspend_enable,
};

U_BOOT_DRIVER(rk8xx_buck) = {
	.name = "rk8xx_buck",
	.id = UCLASS_REGULATOR,
	.ops = &rk8xx_buck_ops,
	.probe = rk8xx_buck_probe,
};

U_BOOT_DRIVER(rk8xx_ldo) = {
	.name = "rk8xx_ldo",
	.id = UCLASS_REGULATOR,
	.ops = &rk8xx_ldo_ops,
	.probe = rk8xx_ldo_probe,
};

U_BOOT_DRIVER(rk8xx_switch) = {
	.name = "rk8xx_switch",
	.id = UCLASS_REGULATOR,
	.ops = &rk8xx_switch_ops,
	.probe = rk8xx_switch_probe,
};

U_BOOT_DRIVER(rk8xx_spi_pldo) = {
	.name = "rk8xx_pldo",
	.id = UCLASS_REGULATOR,
	.ops = &rk8xx_pldo_ops,
	.probe = rk8xx_pldo_probe,
};
#endif

int rk8xx_spl_configure_buck(struct udevice *pmic, int buck, int uvolt)
{
	int ret;

	ret = _buck_set_value(pmic, buck, uvolt);
	if (ret)
		return ret;

	return _buck_set_enable(pmic, buck, true);
}

int rk818_spl_configure_usb_input_current(struct udevice *pmic, int current_ma)
{
	uint i;

	for (i = 0; i < ARRAY_SIZE(rk818_chrg_cur_input_array); i++)
		if (current_ma <= rk818_chrg_cur_input_array[i])
			break;

	return pmic_clrsetbits(pmic, REG_USB_CTRL, RK818_USB_ILIM_SEL_MASK, i);
}

int rk818_spl_configure_usb_chrg_shutdown(struct udevice *pmic, int uvolt)
{
	uint i;

	for (i = 0; i < ARRAY_SIZE(rk818_chrg_shutdown_vsel_array); i++)
		if (uvolt <= rk818_chrg_shutdown_vsel_array[i])
			break;

	return pmic_clrsetbits(pmic, REG_USB_CTRL, RK818_USB_CHG_SD_VSEL_MASK,
			       i);
}
