/*
 * board/hardkernel/odroidn2/odroidn2.c
 *
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <asm/saradc.h>

int get_adc_value(int channel)
{
	int val;

	saradc_enable();
	(void)get_adc_sample_gxbb(channel);	/* THROW AWAY !! */
	val = get_adc_sample_gxbb(channel);
	saradc_disable();

	return val;
}
