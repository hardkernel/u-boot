/*
 * (C) Copyright 2002
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 * Be sure to mark tests to be run before relocation as such with the
 * CONFIG_SYS_POST_PREREL flag so that logging is done correctly if the
 * logbuffer support is enabled.
 */

#include <common.h>
#include <config.h>

#include <post.h>

extern int memory_post_test(int flags);
extern int rtc_post_test(int flags);
extern int i2c_post_test(int flags);
extern int l2cache_post_test(int flags);
extern int l1cache_post_test(int flags);
extern int bist_post_test(int flags);
extern int pll_post_test(int flags);
extern int nand_post_test(int flags);
extern int sdcard_post_test(int flags);
extern int adc_post_test(int flags);

struct post_test post_list[] = {		
#if CONFIG_POST & CONFIG_SYS_POST_MEMORY
	{
	 "Memory test",
	 "memory",
	 "This test checks RAM.",
	 POST_ROM | POST_POWERON | POST_SLOWTEST | POST_PREREL,
	 //POST_RAM | POST_MANUAL,
	 &memory_post_test,
	 NULL,
	 NULL,
	 CONFIG_SYS_POST_MEMORY
	 },
#endif

#if CONFIG_POST & CONFIG_SYS_POST_CACHE
    {
	"Cache test",
	"l1cache",
	"This test verifies the CPU cache operation.",
	//POST_RAM | POST_ALWAYS,
	POST_RAM | POST_MANUAL,
	&l1cache_post_test,
	NULL,
	NULL,
	CONFIG_SYS_POST_CACHE
    },
#endif

/*BSPEC1 used for l2cache post*/
#if CONFIG_POST & CONFIG_SYS_POST_BSPEC1   
	CONFIG_POST_BSPEC1,
#endif

#if CONFIG_POST & CONFIG_SYS_POST_RTC
    {
	"RTC test",
	"rtc",
	"This test verifies the RTC operation.",
	POST_RAM | POST_MANUAL,
	&rtc_post_test,
	NULL,
	NULL,
	CONFIG_SYS_POST_RTC
    },
#endif

#if CONFIG_POST & CONFIG_SYS_POST_I2C
    {
	"I2C test",
	"i2c",
	"This test verifies the I2C operation.",
	POST_RAM | POST_ALWAYS,
	&i2c_post_test,
	NULL,
	NULL,
	CONFIG_SYS_POST_I2C
    },
#endif

/*bist test*/
#if CONFIG_POST & CONFIG_SYS_POST_BSPEC2
	CONFIG_POST_BSPEC2,
#endif

#if CONFIG_POST & CONFIG_SYS_POST_PLL
	{
		"PLL go through",
		"pll",
		"This test display each kind of pll min/max range",
		POST_RAM | POST_MANUAL,
		&pll_post_test,
		NULL,
		NULL,
		CONFIG_SYS_POST_PLL
	},
#endif

#if CONFIG_POST & CONFIG_SYS_POST_NAND
	{
		"NAND test",
		"nand",
		"This test check NAND information",
		POST_RAM | POST_ALWAYS,
		&nand_post_test,
		NULL,
		NULL,
		CONFIG_SYS_POST_NAND		
	},
#endif

#if CONFIG_POST & CONFIG_SYS_POST_SDCARD 
	{
		"SDCARD test",
		"sdcard",
		"This test check SDCARD information",
		POST_RAM | POST_ALWAYS,
		&sdcard_post_test,
		NULL,
		NULL,
		CONFIG_SYS_POST_SDCARD
	},
#endif

#if CONFIG_POST & CONFIG_SYS_POST_ADC
	{
		"SARADC test",
		"adc",
		"This test verifies the SARADC operation",
		POST_RAM | POST_MANUAL,
		&adc_post_test,
		NULL, 
		NULL,
		CONFIG_SYS_POST_ADC
	},
#endif
};

unsigned int post_list_size = sizeof(post_list) / sizeof(struct post_test);
