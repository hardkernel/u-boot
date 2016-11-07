/*
 * drivers/display/vout/cvbs.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * Author: jets.yan@amlogic.com
 *
*/
#include <common.h>
#include <asm/arch/io.h>
#include "cvbs_regs.h"
#include "cvbs_config.h"

/*----------------------------------------------------------------------------*/
// global variables
unsigned int cvbs_mode = 0xff; // default to 0xff as invalid vmode


/*----------------------------------------------------------------------------*/
// interface for registers of soc

static int cvbs_write_reg_linear(unsigned int addr_linear, unsigned int value)
{
	writel((unsigned long)value, (unsigned long)addr_linear);

	return 0;
}

static unsigned int cvbs_read_reg_linear(unsigned int addr_linear)
{
	return (unsigned int)readl((unsigned long)addr_linear);
}

static int cvbs_set_reg_bits(unsigned int addr_linear, unsigned int value, unsigned int start, unsigned int len)
{
	unsigned int data = 0;

	data = cvbs_read_reg_linear(addr_linear);
	data &= ~(((1<<len)-1)<<start);
	data |= (value & ((1<<len)-1)) << start;
	cvbs_write_reg_linear(addr_linear, data);

	return 0;
}

static unsigned int cvbs_get_reg_bits(unsigned int addr_linear, unsigned int start, unsigned int len)
{
	unsigned int data;

	data = cvbs_read_reg_linear(addr_linear);
	data = (data>>start) & ((1<<len)-1);

	return data;
}

static unsigned int cvbs_get_logic_addr(unsigned int bus, unsigned int addr_offset)
{
	unsigned int ret;

	if (bus == BUS_TYPE_HIU)
		ret = (HIU_BASE + ((addr_offset&0xff)<<2));
	else if (bus == BUS_TYPE_VCBUS)
		ret = (VCBUS_BASE + (addr_offset<<2));

	return ret;
}

static int cvbs_write_hiu(unsigned int addr_offset, unsigned int value)
{
	return cvbs_write_reg_linear(cvbs_get_logic_addr(BUS_TYPE_HIU, addr_offset), value);
}

static int cvbs_read_hiu(unsigned int addr_offset)
{
	return cvbs_read_reg_linear(cvbs_get_logic_addr(BUS_TYPE_HIU, addr_offset));
}

static int cvbs_set_hiu_bits(unsigned int addr_offset, unsigned int value, unsigned int start, unsigned int len)
{
	return cvbs_set_reg_bits(cvbs_get_logic_addr(BUS_TYPE_HIU, addr_offset), value, start, len);
}

static int cvbs_get_hiu_bits(unsigned int addr_offset, unsigned int start, unsigned int len)
{
	return cvbs_get_reg_bits(cvbs_get_logic_addr(BUS_TYPE_HIU, addr_offset), start, len);
}

static unsigned int cvbs_read_vcbus(unsigned int addr_offset)
{
	return cvbs_read_reg_linear(cvbs_get_logic_addr(BUS_TYPE_VCBUS, addr_offset));
}

static int cvbs_write_vcbus(unsigned int addr_offset, unsigned int value)
{
	return cvbs_write_reg_linear(cvbs_get_logic_addr(BUS_TYPE_VCBUS, addr_offset), value);
}

static int cvbs_set_vcbus_bits(unsigned int addr_offset, unsigned int value, unsigned int start, unsigned int len)
{
	return cvbs_set_reg_bits(cvbs_get_logic_addr(BUS_TYPE_VCBUS, addr_offset), value, start, len);
}
#if 0
static int cvbs_get_vcbus_bits(unsigned int addr_offset, unsigned int start, unsigned int len)
{
	return cvbs_get_reg_bits(cvbs_get_logic_addr(BUS_TYPE_VCBUS, addr_offset), start, len);
}
#endif

/*----------------------------------------------------------------------------*/
// configuration for enci bist
int cvbs_set_bist(char* bist_mode)
{
	if (!strcmp(bist_mode, "off"))
	{
		cvbs_write_vcbus(ENCI_VIDEO_MODE_ADV,	0x26);
		cvbs_write_vcbus(ENCI_TST_EN,			0x0);
	} else
	{
		unsigned int mode = 0;

		if (!strcmp(bist_mode, "fixval") || !strcmp(bist_mode, "0"))
			mode = 0;
		else if (!strcmp(bist_mode, "colorbar") || !strcmp(bist_mode, "1"))
			mode = 1;
		else if (!strcmp(bist_mode, "thinline") || !strcmp(bist_mode, "2"))
			mode = 2;
		else if (!strcmp(bist_mode, "dotgrid") || !strcmp(bist_mode, "3"))
			mode = 3;

		cvbs_write_vcbus(ENCI_VIDEO_MODE_ADV,	0x2);
		cvbs_write_vcbus(ENCI_TST_MDSEL, 		mode);
		cvbs_write_vcbus(ENCI_TST_CLRBAR_STRT,	0x112);
		cvbs_write_vcbus(ENCI_TST_CLRBAR_WIDTH,	0xb4);
		cvbs_write_vcbus(ENCI_TST_EN,			0x1);
	}

	return 0;
}

/*----------------------------------------------------------------------------*/
// configuration for vdac pin of the soc.
// config vdac path:
//	0 : close
//	1 : enci
//	2 : atv
//	3 : passthrough
int cvbs_set_vdac(int status)
{
	switch (status)
	{
	case 0:// close vdac
		cvbs_write_hiu(HHI_VDAC_CNTL0, 0);
		cvbs_write_hiu(HHI_VDAC_CNTL1, 8);
		break;
	case 1:// from enci to vdac
		cvbs_set_vcbus_bits(VENC_VDAC_DACSEL0, 5, 1, 0);
		cvbs_write_hiu(HHI_VDAC_CNTL0, 1);
		cvbs_write_hiu(HHI_VDAC_CNTL1, 0);
		break;
	case 2:// from atv to vdac
		cvbs_set_vcbus_bits(VENC_VDAC_DACSEL0, 5, 1, 1);
		cvbs_write_hiu(HHI_VDAC_CNTL0, 1);
		cvbs_write_hiu(HHI_VDAC_CNTL1, 0);
		break;
	case 3:// from cvbs_in passthrough to cvbs_out with vdac disabled
		cvbs_write_hiu(HHI_VDAC_CNTL0, 0x400);
		cvbs_write_hiu(HHI_VDAC_CNTL1, 8);
		break;
	default:
		break;
	}

	return 0;
}

/*----------------------------------------------------------------------------*/
// interface for debug
static void cvbs_dump_cvbs_regs(void)
{
	struct reg_s *p = NULL;

	if (0 == cvbs_mode) {
		// 576cvbs
		p = (struct reg_s*)&tvregs_576cvbs_enc[0];

	} else if (1 == cvbs_mode) {
		// 480cvbs
		p = (struct reg_s*)&tvregs_480cvbs_enc[0];
	}

	if (NULL == p) {
		printf("it's not in cvbs mode!\n");
		return;
	}

	if (MREG_END_MARKER != p->reg)
		printf("cvbs enci registers:\n");
	while (MREG_END_MARKER != p->reg) {
		printf("    vcbus[0x%.2x] = 0x%.4x\n", p->reg, cvbs_read_vcbus(p->reg));
		p ++;
	}

	return;
}

unsigned int cvbs_clk_regs[] = {
	HHI_HDMI_PLL_CNTL,
	HHI_HDMI_PLL_CNTL2,
	HHI_HDMI_PLL_CNTL3,
	HHI_HDMI_PLL_CNTL4,
	HHI_HDMI_PLL_CNTL5,
	HHI_HDMI_PLL_CNTL6,
	HHI_VID_PLL_CLK_DIV,
	HHI_VIID_CLK_DIV,
	HHI_VIID_CLK_CNTL,
	HHI_VID_CLK_DIV,
	HHI_VID_CLK_CNTL2,
	MREG_END_MARKER
};

static void cvbs_dump_clock_regs(void)
{
	unsigned int *p = &cvbs_clk_regs[0];

	if (MREG_END_MARKER != *p)
		printf("cvbs clock registers:\n");
	while (MREG_END_MARKER != *p) {
		printf("    hiu[0x%.2x] = 0x%.4x\n", *p, cvbs_read_hiu(*p));
		p ++;
	}

	return;
}

int cvbs_reg_debug(int argc, char* const argv[])
{
	unsigned int addr, start, end, value;

	if (!strcmp(argv[1], "r"))
	{
		if (argc != 4)
			goto fail_cmd;

		if (!strcmp(argv[2], "h"))
		{
			addr = simple_strtoul(argv[3], NULL, 16);
			printf("cvbs read hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(addr));
		} else if (!strcmp(argv[2], "v"))
		{
			addr = simple_strtoul(argv[3], NULL, 16);
			printf("cvbs read vcbus[0x%.2x] = 0x%.4x\n", addr, cvbs_read_vcbus(addr));
		}
	} else if (!strcmp(argv[1], "w")) {
		if (argc != 5)
			goto fail_cmd;

		if (!strcmp(argv[3], "h"))
		{
			addr = simple_strtoul(argv[4], NULL, 16);
			value = simple_strtoul(argv[2], NULL, 16);
			cvbs_write_hiu(addr, value);
			printf("cvbs write hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(addr));
		} else if (!strcmp(argv[3], "v"))
		{
			addr = simple_strtoul(argv[4], NULL, 16);
			value = simple_strtoul(argv[2], NULL, 16);
			cvbs_write_vcbus(addr, value);
			printf("cvbs write hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_vcbus(addr));
		}
	} else if (!strcmp(argv[1], "dump")) {
		unsigned int i = 0;
		unsigned int type = 0xff;

		if (argc != 5)
			goto fail_cmd;

		if (!strcmp(argv[2], "h"))
			type = 0;
		else if (!strcmp(argv[2], "v"))
			type = 1;

		if (type == 0xff)
			goto fail_cmd;

		start = simple_strtoul(argv[3], NULL, 16);
		end = simple_strtoul(argv[4], NULL, 16);

		if (type == 0) {
			for (i=start; i<=end; i++)
				printf("cvbs read hiu[0x%.2x] = 0x%.4x\n", i, cvbs_read_hiu(i));
		} else if (type == 1) {
			for (i=start; i<=end; i++)
				printf("cvbs read vcbus[0x%.2x] = 0x%.4x\n", i, cvbs_read_vcbus(i));
		}
	} else if (!strcmp(argv[1], "clock")) {
		if (argc != 2)
			goto fail_cmd;

		cvbs_dump_clock_regs();
	} else if (!strcmp(argv[1], "enci")) {
		if (argc != 2)
			goto fail_cmd;

		cvbs_dump_cvbs_regs();
	}

	return 0;

fail_cmd:
	return 1;
}

/*----------------------------------------------------------------------------*/
// configuration for clock
#define WAIT_FOR_PLL_LOCKED(reg)                \
	do {                                        \
		unsigned int cnt = 10;                  \
		unsigned int time_out = 0;              \
		while (cnt --) {                        \
		time_out = 0;                           \
		while (!cvbs_get_hiu_bits(reg, 31, 1)	\
			& (time_out < 10000))               \
			time_out ++;                        \
		}                                       \
		if (cnt < 9)                            \
			printf("pll[0x%x] reset %d times\n", reg, 9 - cnt);\
	} while(0);

static int cvbs_config_clock(void)
{
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x5800023d);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2,	0x00404e00);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3,	0x0d5c5091);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4,	0x801da72c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5,	0x71486980);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6,	0x00000e55);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x4800023d);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);

	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 0, VCLK2_EN, 1);
	//udelay(5);

	/* Disable the div output clock */
	cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 0, 19, 1);
	cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 0, 15, 1);

	cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 1, 18, 1);
	/* Enable the final output clock */
	cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 1, 19, 1);

	/* setup the XD divider value */
	cvbs_set_hiu_bits(HHI_VIID_CLK_DIV, (55 - 1), VCLK2_XD, 8);
	//udelay(5);
	/* Bit[18:16] - v2_cntl_clk_in_sel */
	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 4, VCLK2_CLK_IN_SEL, 3);
	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 1, VCLK2_EN, 1);
	//udelay(2);

	/* [15:12] encl_clk_sel, select vclk2_div1 */
	cvbs_set_hiu_bits(HHI_VID_CLK_DIV, 8, 28, 4);
	cvbs_set_hiu_bits(HHI_VIID_CLK_DIV, 8, 28, 4);
	/* release vclk2_div_reset and enable vclk2_div */
	cvbs_set_hiu_bits(HHI_VIID_CLK_DIV, 1, VCLK2_XD_EN, 2);
	//udelay(5);

	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 1, VCLK2_DIV1_EN, 1);
	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 1, VCLK2_SOFT_RST, 1);
	//udelay(10);
	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 0, VCLK2_SOFT_RST, 1);
	//udelay(5);

	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL2, 1, 0, 1);
	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL2, 1, 4, 1);

	return 0;
}

/*----------------------------------------------------------------------------*/
// configuration for enci
static void cvbs_write_vcbus_array(struct reg_s *s)
{
	if (s == NULL)
		return ;

	while (s && (MREG_END_MARKER != s->reg))
	{
		cvbs_write_vcbus(s->reg, s->val);
		//printf("reg[0x%.2x] = 0x%.4x\n", s->reg, s->val);
		s ++;
	}
	return ;
}

static int cvbs_config_enci(int vmode)
{
	if (0 == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_576cvbs_enc[0]);
	else if (1 == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_480cvbs_enc[0]);

	return 0;
}

/*----------------------------------------------------------------------------*/
// configuration for output
// output vmode: 576cvbs, 480cvbs
int cvbs_set_vmode(char* vmode_name)
{
	if (!strncmp(vmode_name, "576cvbs", strlen("576cvbs"))) {
		cvbs_mode = 0;
		cvbs_config_enci(0);
		cvbs_config_clock();
		cvbs_set_vdac(1);
	} else if (!strncmp(vmode_name, "480cvbs", strlen("480cvbs"))) {
		cvbs_mode = 1;
		cvbs_config_enci(1);
		cvbs_config_clock();
		cvbs_set_vdac(1);
	}

	return 0;
}

/*----------------------------------------------------------------------------*/
// list for valid video mode
void cvbs_show_valid_vmode(void)
{
	printf("576cvbs\n""480cvbs\n");
	return;
}

