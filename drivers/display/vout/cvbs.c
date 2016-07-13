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
#include <asm/cpu_id.h>
#include "cvbs_regs.h"
#include "cvbs_config.h"

/*----------------------------------------------------------------------------*/
// global variables
enum CVBS_MODE_e
{
	VMODE_PAL,
	VMODE_NTSC,
	VMODE_MAX
};

unsigned int cvbs_mode = VMODE_MAX;

static cpu_id_t cpu_id;
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

	if (bus == BUS_TYPE_CBUS)
		ret = (CBUS_BASE + (addr_offset<<2));
	else if (bus == BUS_TYPE_HIU)
		ret = (HIU_BASE + ((addr_offset&0xff)<<2));
	else if (bus == BUS_TYPE_VCBUS)
		ret = (VCBUS_BASE + (addr_offset<<2));

	return ret;
}

static int cvbs_write_cbus(unsigned int addr_offset, unsigned int value)
{
	return cvbs_write_reg_linear(cvbs_get_logic_addr(BUS_TYPE_CBUS, addr_offset), value);
}

static int cvbs_read_cbus(unsigned int addr_offset)
{
	return cvbs_read_reg_linear(cvbs_get_logic_addr(BUS_TYPE_CBUS, addr_offset));
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
// interface for cpu id checking

static int check_cpu_type(unsigned int cpu_type)
{
	return (cvbs_read_cbus(ASSIST_HW_REV)==cpu_type);
}

static bool inline is_equal_after_meson_cpu(unsigned int id)
{
	return (cpu_id.family_id >= id)?1:0;
}

static bool inline is_meson_gxl_cpu(void)
{
	return (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL)?
		1:0;
}

static bool inline is_meson_gxm_cpu(void)
{
	return (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXM)?
		1:0;

}
static bool inline is_meson_gxl_package_905X(void)
{
	return ((cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL) &&
		(cpu_id.package_id == MESON_CPU_PACKAGE_ID_905X))?
		1:0;
}

static bool inline is_meson_gxl_package_905L(void)
{
	return ((cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL) &&
		(cpu_id.package_id == MESON_CPU_PACKAGE_ID_905L))?
		1:0;
}

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
		if (is_meson_gxl_cpu() || is_meson_gxm_cpu())
			cvbs_write_hiu(HHI_VDAC_CNTL0, 0xf0001);
		else
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

	if (VMODE_PAL == cvbs_mode) {
		// 576cvbs
		p = (struct reg_s*)&tvregs_576cvbs_enc[0];

	} else if (VMODE_NTSC == cvbs_mode) {
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

		addr = simple_strtoul(argv[3], NULL, 16);
		if (!strcmp(argv[2], "c"))
			printf("cvbs read cbus[0x%.2x] = 0x%.4x\n", addr, cvbs_read_cbus(addr));
		else if (!strcmp(argv[2], "h"))
			printf("cvbs read hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(addr));
		else if (!strcmp(argv[2], "v"))
			printf("cvbs read vcbus[0x%.2x] = 0x%.4x\n", addr, cvbs_read_vcbus(addr));
	} else if (!strcmp(argv[1], "w")) {
		if (argc != 5)
			goto fail_cmd;

		addr = simple_strtoul(argv[4], NULL, 16);
		value = simple_strtoul(argv[2], NULL, 16);
		if (!strcmp(argv[3], "c")) {
			cvbs_write_cbus(addr, value);
			printf("cvbs write cbus[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(addr));
		} else if (!strcmp(argv[3], "h")) {
			cvbs_write_hiu(addr, value);
			printf("cvbs write hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(addr));
		} else if (!strcmp(argv[3], "v")) {
			cvbs_write_vcbus(addr, value);
			printf("cvbs write hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_vcbus(addr));
		}
	} else if (!strcmp(argv[1], "dump")) {
		unsigned int i = 0;
		unsigned int type = 0xff;

		if (argc != 5)
			goto fail_cmd;

		if (!strcmp(argv[2], "h"))
			type = BUS_TYPE_CBUS;
		if (!strcmp(argv[2], "h"))
			type = BUS_TYPE_HIU;
		else if (!strcmp(argv[2], "v"))
			type = BUS_TYPE_VCBUS;

		if (type == 0xff)
			goto fail_cmd;

		start = simple_strtoul(argv[3], NULL, 16);
		end = simple_strtoul(argv[4], NULL, 16);

		if (type == BUS_TYPE_CBUS) {
			for (i=start; i<=end; i++)
				printf("cvbs read cbus[0x%.2x] = 0x%.4x\n", i, cvbs_read_cbus(i));
		} if (type == BUS_TYPE_HIU) {
			for (i=start; i<=end; i++)
				printf("cvbs read hiu[0x%.2x] = 0x%.4x\n", i, cvbs_read_hiu(i));
		} else if (type == BUS_TYPE_VCBUS) {
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

static void cvbs_config_hdmipll_gxb(void)
{
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x5800023d);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2,	0x00404e00);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3,	0x0d5c5091);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4,	0x801da72c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5,	0x71486980);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6,	0x00000e55);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x4800023d);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);

	return;
}

static void cvbs_config_hdmipll_gxl(void)
{
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL, 0x4000027b);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2, 0x800cb300);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3, 0xa6212844);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4, 0x0c4d000c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5, 0x001fa729);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6, 0x01a31500);
	cvbs_set_hiu_bits(HHI_HDMI_PLL_CNTL, 0x1, 28, 1);
	cvbs_set_hiu_bits(HHI_HDMI_PLL_CNTL, 0x0, 28, 1);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);

	return;
}

static void cvbs_config_hdmipll_gxtvbb(void)
{
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x5800023d);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2,	0x00404380);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3,	0x0d5c5091);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4,	0x801da72c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5,	0x71486980);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6,	0x00000e55);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x4800023d);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);

	return;
}

static int cvbs_config_clock(void)
{
	if (check_cpu_type(MESON_CPU_MAJOR_ID_GXBB))
		cvbs_config_hdmipll_gxb();
	else if (check_cpu_type(MESON_CPU_MAJOR_ID_GXTVBB))
		cvbs_config_hdmipll_gxtvbb();
	else if (is_equal_after_meson_cpu(MESON_CPU_MAJOR_ID_GXL))
		cvbs_config_hdmipll_gxl();

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

#ifdef CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT

void cvbs_performance_config(void)
{
	int actived = CONFIG_CVBS_PERFORMANCE_ACTIVED;
	char buf[8];

	sprintf(buf, "%d", actived);
	setenv("cvbs_drv", buf);

	return ;
}

static void cvbs_performance_enhancement(int mode)
{
	unsigned int index = CONFIG_CVBS_PERFORMANCE_ACTIVED;
	unsigned int max = 0;
	unsigned int type = 0;
	const struct reg_s *s = NULL;

	if (VMODE_PAL != mode)
		return;

	if (0xff == index)
		return;

	if (check_cpu_type(MESON_CPU_MAJOR_ID_M8B)) {
		max = sizeof(tvregs_576cvbs_performance_m8b)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_m8b[index];
		type = 1;
	} else if (check_cpu_type(MESON_CPU_MAJOR_ID_M8M2)) {
		max = sizeof(tvregs_576cvbs_performance_m8m2)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_m8m2[index];
		type = 2;
	} else if (check_cpu_type(MESON_CPU_MAJOR_ID_M8)) {
		max = sizeof(tvregs_576cvbs_performance_m8)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_m8[index];
		type = 3;
	} else if (check_cpu_type(MESON_CPU_MAJOR_ID_GXBB)) {
		max = sizeof(tvregs_576cvbs_performance_gxbb)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_gxbb[index];
		type = 4;
	} else if (check_cpu_type(MESON_CPU_MAJOR_ID_GXTVBB)) {
		max = sizeof(tvregs_576cvbs_performance_gxtvbb)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_gxtvbb[index];
		type = 5;
	} else if (is_equal_after_meson_cpu(MESON_CPU_MAJOR_ID_GXL)) {
		if (is_meson_gxl_package_905L()) {
			max = sizeof(tvregs_576cvbs_performance_905l)
				/ sizeof(struct reg_s *);
			index = (index >= max) ? 0 : index;
			s = tvregs_576cvbs_performance_905l[index];
			type = 7;
		} else {
			max = sizeof(tvregs_576cvbs_performance_905x)
				/ sizeof(struct reg_s *);
			index = (index >= max) ? 0 : index;
			s = tvregs_576cvbs_performance_905x[index];
			type = 6;
		}
	}

	printf("cvbs performance type = %d, table = %d\n", type, index);
	cvbs_write_vcbus_array((struct reg_s*)s);

	return;
}

#endif

static int cvbs_config_enci(int vmode)
{
	if (VMODE_PAL == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_576cvbs_enc[0]);
	else if (VMODE_NTSC == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_480cvbs_enc[0]);

	cvbs_performance_enhancement(vmode);

	return 0;
}

/*----------------------------------------------------------------------------*/
// configuration for output
// output vmode: 576cvbs, 480cvbs
int cvbs_set_vmode(char* vmode_name)
{
	if (!strncmp(vmode_name, "576cvbs", strlen("576cvbs"))) {
		cvbs_mode = VMODE_PAL;
		cvbs_config_enci(0);
		cvbs_config_clock();
		cvbs_set_vdac(1);
		return 0;
	} else if (!strncmp(vmode_name, "480cvbs", strlen("480cvbs"))) {
		cvbs_mode = VMODE_NTSC;
		cvbs_config_enci(1);
		cvbs_config_clock();
		cvbs_set_vdac(1);
		return 0;
	} else {
		printf("[%s] is invalid for cvbs.\n", vmode_name);
		return -1;
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

void cvbs_init(void)
{
	cpu_id = get_cpu_id();

#ifdef CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT
	cvbs_performance_config();
#endif

	return;
}

