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
#include <asm/arch/secure_apb.h>
#include <asm/arch/cpu.h>
#include <asm/cpu_id.h>
#include "cvbs_regs.h"
#include "cvbs_config.h"

/*----------------------------------------------------------------------------*/
// global variables
enum CVBS_MODE_e
{
	VMODE_PAL,
	VMODE_NTSC,
	VMODE_PAL_M,
	VMODE_PAL_N,
	VMODE_NTSC_M,
	VMODE_MAX
};

struct cvbs_vdac_data_s {
	unsigned int vdac_ctrl0_en;
	unsigned int vdac_ctrl0_dis;
	unsigned int vdac_ctrl1_en;
	unsigned int vdac_ctrl1_dis;
};

static struct cvbs_vdac_data_s vdac_data_default = {
	.vdac_ctrl0_en = 0x1,
	.vdac_ctrl0_dis = 0,
	.vdac_ctrl1_en = 0,
	.vdac_ctrl1_dis = 8,
};

static struct cvbs_vdac_data_s vdac_data_gxl = {
	.vdac_ctrl0_en = 0xb0001,
	.vdac_ctrl0_dis = 0,
	.vdac_ctrl1_en = 0,
	.vdac_ctrl1_dis = 8,
};

static struct cvbs_vdac_data_s vdac_data_txl = {
	.vdac_ctrl0_en = 0x620001,
	.vdac_ctrl0_dis = 0,
	.vdac_ctrl1_en = 8,
	.vdac_ctrl1_dis = 0,
};

static struct cvbs_vdac_data_s vdac_data_g12a = {
	.vdac_ctrl0_en = 0x906001,
	.vdac_ctrl0_dis = 0,
	.vdac_ctrl1_en = 0,
	.vdac_ctrl1_dis = 8,
};

static struct cvbs_vdac_data_s vdac_data_g12b = {
	.vdac_ctrl0_en = 0x8f6001,
	.vdac_ctrl0_dis = 0,
	.vdac_ctrl1_en = 0,
	.vdac_ctrl1_dis = 8,
};

static struct cvbs_vdac_data_s vdac_data_tl1 = {
	.vdac_ctrl0_en = 0x906001,
	.vdac_ctrl0_dis = 0,
	.vdac_ctrl1_en = 0,
	.vdac_ctrl1_dis = 8,
};

static struct cvbs_vdac_data_s *cvbs_vdac_data;
unsigned int cvbs_mode = VMODE_MAX;
/*bit[0]: 0=vid_pll, 1=gp0_pll*/
/*bit[1]: 0=vid2_clk, 1=vid1_clk*/
/*path 0:vid_pll vid2_clk*/
/*path 1:gp0_pll vid2_clk*/
/*path 2:vid_pll vid1_clk*/
/*path 3:gp0_pll vid1_clk*/
static unsigned int s_enci_clk_path = 0;

/*----------------------------------------------------------------------------*/
// interface for registers of soc

#define REG_OFFSET_VCBUS(reg)       (((reg) << 2))
#define REG_OFFSET_CBUS(reg)		(((reg) << 2))

/* memory mapping */
#define REG_ADDR_HIU(reg)           (reg + 0L)
#define REG_ADDR_VCBUS(reg)         (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))
#define REG_ADDR_CBUS(reg)			(REG_BASE_CBUS + REG_OFFSET_CBUS(reg))

static unsigned int cvbs_get_hiu_logic_addr(unsigned int addr_offset)
{
	return (REG_BASE_HIU + ((addr_offset&0xff)<<2));
}

static int cvbs_write_cbus(unsigned int addr_offset, unsigned int value)
{
	*(volatile unsigned int *)REG_ADDR_CBUS(addr_offset) = (value);
	return 0;
}

static int cvbs_read_cbus(unsigned int addr_offset)
{
	unsigned int val = 0;

	val = *(volatile unsigned int *)(REG_ADDR_CBUS(addr_offset));
	return val;
}

static int cvbs_write_hiu(unsigned int addr, unsigned int value)
{
	*(volatile unsigned int *)REG_ADDR_HIU(addr) = (value);
	return 0;
}

static int cvbs_read_hiu(unsigned int addr)
{
	unsigned int val = 0;

	val = *(volatile unsigned int *)(REG_ADDR_HIU(addr));
	return val;
}

static int cvbs_set_hiu_bits(unsigned int addr, unsigned int value, unsigned int start, unsigned int len)
{
	cvbs_write_hiu(addr, ((cvbs_read_hiu(addr) &
			~(((1L << (len))-1) << (start))) |
			(((value)&((1L<<(len))-1)) << (start))));
	return 0;
}

static int cvbs_get_hiu_bits(unsigned int addr, unsigned int start, unsigned int len)
{
	return (cvbs_read_hiu(addr) >> (start)) & ((1L << (len)) - 1);
}

static unsigned int cvbs_read_vcbus(unsigned int addr_offset)
{
	unsigned int val = 0;

	val = *(volatile unsigned int *)(REG_ADDR_VCBUS(addr_offset));
	return val;
}

static int cvbs_write_vcbus(unsigned int addr_offset, unsigned int value)
{
	*(volatile unsigned int *)REG_ADDR_VCBUS(addr_offset) = (value);
	return 0;
}

static int cvbs_set_vcbus_bits(unsigned int addr_offset, unsigned int value, unsigned int start, unsigned int len)
{
	cvbs_write_vcbus(addr_offset, ((cvbs_read_vcbus(addr_offset) &
		~(((1L << (len))-1) << (start))) |
		(((value)&((1L<<(len))-1)) << (start))));
	return 0;
}
#if 0
static int cvbs_get_vcbus_bits(unsigned int addr_offset, unsigned int start, unsigned int len)
{
	return (cvbs_read_vcbus(addr_offset) >> (start)) & ((1L << (len)) - 1);}
#endif

/*----------------------------------------------------------------------------*/
// interface for cpu id checking

static int check_cpu_type(unsigned int cpu_type)
{
	return (cvbs_read_cbus(ASSIST_HW_REV)==cpu_type);
}

static bool inline is_equal_after_meson_cpu(unsigned int id)
{
	return (get_cpu_id().family_id >= id)?1:0;
}

static bool inline is_meson_gxl_cpu(void)
{
	return (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXL)?
		1:0;
}

static bool inline is_meson_gxlx_cpu(void)
{
	return (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXLX)?
		1:0;
}

static bool inline is_meson_g12a_cpu(void)
{
	return (get_cpu_id().family_id ==
		MESON_CPU_MAJOR_ID_G12A) ? 1 : 0;
}

static inline bool is_meson_g12b_cpu(void)
{
	return (get_cpu_id().family_id ==
		MESON_CPU_MAJOR_ID_G12B) ? 1 : 0;
}

static inline bool is_meson_tl1_cpu(void)
{
	return (get_cpu_id().family_id ==
		MESON_CPU_MAJOR_ID_TL1) ? 1 : 0;
}

static bool inline is_meson_txl_cpu(void)
{
	return (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_TXL)?
		1:0;
}

static bool inline is_meson_gxm_cpu(void)
{
	return (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXM)?
		1:0;

}
static bool inline is_meson_gxl_package_905X(void)
{
	return ((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXL) &&
		(get_cpu_id().package_id == MESON_CPU_PACKAGE_ID_905X))?
		1:0;
}

static bool inline is_meson_gxl_package_905L(void)
{
	return ((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXL) &&
		(get_cpu_id().package_id == MESON_CPU_PACKAGE_ID_905L))?
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
	if (cvbs_vdac_data) {
		cvbs_write_hiu(HHI_VDAC_CNTL0, cvbs_vdac_data->vdac_ctrl0_dis);
		cvbs_write_hiu(HHI_VDAC_CNTL1, cvbs_vdac_data->vdac_ctrl1_dis);
	} else {
		printf("cvbs ERROR:need run cvbs init.\n");
	}
	break;
	case 1:// from enci to vdac
		cvbs_set_vcbus_bits(VENC_VDAC_DACSEL0, 0, 5, 1);
	if (cvbs_vdac_data) {
		cvbs_write_hiu(HHI_VDAC_CNTL0, cvbs_vdac_data->vdac_ctrl0_en);
		cvbs_write_hiu(HHI_VDAC_CNTL1, cvbs_vdac_data->vdac_ctrl1_en);
	} else {
		printf("cvbs ERROR:need run cvbs init.\n");
	}
		break;
	case 2:// from atv to vdac
		cvbs_set_vcbus_bits(VENC_VDAC_DACSEL0, 1, 5, 1);
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
#if (defined(CONFIG_AML_MESON_G12A))
	HHI_HDMI_PLL_CNTL0,
#else
	HHI_HDMI_PLL_CNTL,
#endif
#if (!defined(CONFIG_CHIP_AML_GXB) && \
		!defined(CONFIG_AML_MESON_GXTVBB))
	HHI_HDMI_PLL_CNTL1,
#endif
	HHI_HDMI_PLL_CNTL2,
	HHI_HDMI_PLL_CNTL3,
	HHI_HDMI_PLL_CNTL4,
	HHI_HDMI_PLL_CNTL5,
#if (defined(CONFIG_CHIP_AML_GXB) || \
		defined(CONFIG_AML_MESON_GXTVBB) || \
		defined(CONFIG_AML_MESON_G12A))
	HHI_HDMI_PLL_CNTL6,
#endif
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
			printf("cvbs read hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(cvbs_get_hiu_logic_addr(addr)));
		else if (!strcmp(argv[2], "v"))
			printf("cvbs read vcbus[0x%.2x] = 0x%.4x\n", addr, cvbs_read_vcbus(addr));
	} else if (!strcmp(argv[1], "w")) {
		if (argc != 5)
			goto fail_cmd;

		addr = simple_strtoul(argv[4], NULL, 16);
		value = simple_strtoul(argv[2], NULL, 16);
		if (!strcmp(argv[3], "c")) {
			cvbs_write_cbus(addr, value);
			printf("cvbs write cbus[0x%.2x] = 0x%.4x\n", addr, cvbs_read_cbus(addr));
		} else if (!strcmp(argv[3], "h")) {
			cvbs_write_hiu(cvbs_get_hiu_logic_addr(addr), value);
			printf("cvbs write hiu[0x%.2x] = 0x%.4x\n", addr, cvbs_read_hiu(cvbs_get_hiu_logic_addr(addr)));
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
				printf("cvbs read hiu[0x%.2x] = 0x%.4x\n", i, cvbs_read_hiu(cvbs_get_hiu_logic_addr(i)));
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
	} else if (!strcmp(argv[1], "set_clkpath")) {
		if (argc != 3)
			goto fail_cmd;
		value = simple_strtoul(argv[2], NULL, 0);
		if (check_cpu_type(MESON_CPU_MAJOR_ID_G12A) ||
			check_cpu_type(MESON_CPU_MAJOR_ID_G12B) ||
			is_meson_tl1_cpu()) {
			if (value == 1 || value == 2 ||
				value == 3 || value == 0) {
				s_enci_clk_path = value;
				printf("path 0:vid_pll vid2_clk\n");
				printf("path 1:gp0_pll vid2_clk\n");
				printf("path 2:vid_pll vid1_clk\n");
				printf("path 3:gp0_pll vid1_clk\n");
				printf("you select path %d\n", s_enci_clk_path);
			} else {
				printf("invalid value, only 0/1/2/3\n");
				printf("bit[0]: 0=vid_pll, 1=gp0_pll\n");
				printf("bit[1]: 0=vid2_clk, 1=vid1_clk\n");
			}
		} else
			printf("only support G12A chip");
	}

	return 0;

fail_cmd:
	return 1;
}

/*----------------------------------------------------------------------------*/
// configuration for clock
#define WAIT_FOR_PLL_LOCKED(reg)                \
	do {                                    \
		unsigned int pll_lock;          \
		unsigned int time_out = 0;      \
		do {                            \
			udelay(20);             \
			pll_lock = cvbs_get_hiu_bits(reg, 31, 1);  \
			time_out ++;                               \
		} while ((pll_lock == 0) && (time_out < 10000));   \
		if (pll_lock == 0)                                 \
			printf("[error]: cvbs pll lock failed\n"); \
	} while(0);

static void cvbs_config_hdmipll_gxb(void)
{
#if (defined(CONFIG_CHIP_AML_GXB) || \
	defined(CONFIG_AML_MESON_GXTVBB))
	printf("%s\n", __func__);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x5800023d);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2,	0x00404e00);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3,	0x0d5c5091);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4,	0x801da72c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5,	0x71486980);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6,	0x00000e55);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x4800023d);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);
#endif
	return;
}

static void cvbs_config_hdmipll_gxl(void)
{
#if (!defined(CONFIG_AML_MESON_G12A))
	printf("%s\n", __func__);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL, 0x4000027b);
#if (!defined(CONFIG_CHIP_AML_GXB) && \
		!defined(CONFIG_AML_MESON_GXTVBB))
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL1, 0x800cb300);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2, 0xa6212844);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3, 0x0c4d000c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4, 0x001fa729);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5, 0x01a31500);
#endif
	cvbs_set_hiu_bits(HHI_HDMI_PLL_CNTL, 0x1, 28, 1);
	cvbs_set_hiu_bits(HHI_HDMI_PLL_CNTL, 0x0, 28, 1);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);
#endif
	return;
}

static void cvbs_config_hdmipll_gxtvbb(void)
{
#if (defined(CONFIG_CHIP_AML_GXB) || \
	defined(CONFIG_AML_MESON_GXTVBB))
	printf("%s\n", __func__);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x5800023d);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2,	0x00404380);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3,	0x0d5c5091);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4,	0x801da72c);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5,	0x71486980);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6,	0x00000e55);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL,	0x4800023d);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL);
#endif
	return;
}

static void cvbs_config_hdmipll_g12a(void)
{
#if (defined(CONFIG_AML_MESON_G12A))
	printf("%s\n", __func__);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL0,	0x1a0504f7);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL1,	0x00010000);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL2,	0x00000000);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL3,	0x6a28dc00);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL4,	0x65771290);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL5,	0x39272000);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL6,	0x56540000);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL0,	0x3a0504f7);
	udelay(100);
	cvbs_write_hiu(HHI_HDMI_PLL_CNTL0,	0x1a0504f7);
	WAIT_FOR_PLL_LOCKED(HHI_HDMI_PLL_CNTL0);
#endif
	return;
}

static void cvbs_config_gp0pll_g12a(void)
{
#if (defined(CONFIG_AML_MESON_G12A))
	printf("%s\n", __func__);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL0,	0x180204f7);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL1,	0x00010000);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL2,	0x00000000);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL3,	0x6a28dc00);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL4,	0x65771290);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL5,	0x39272000);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL6,	0x56540000);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL0,	0x380204f7);
	udelay(100);
	cvbs_write_hiu(HHI_GP0_PLL_CNTL0,	0x180204f7);
	WAIT_FOR_PLL_LOCKED(HHI_GP0_PLL_CNTL0);
#endif
	return;
}

static void cvbs_config_tcon_pll(void)
{
	printf("%s\n", __func__);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL0,	0x202f04f7);
	udelay(100);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL0,	0x302f04f7);
	udelay(100);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL1,	0x10110000);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL2,	0x00001108);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL3,	0x10051400);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL4,	0x010100c0);
	udelay(100);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL4,	0x038300c0);
	udelay(100);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL0,	0x342f04f7);
	udelay(100);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL0,	0x142f04f7);
	udelay(100);
	cvbs_write_hiu(HHI_TCON_PLL_CNTL2,	0x00003008);
	udelay(100);
	WAIT_FOR_PLL_LOCKED(HHI_TCON_PLL_CNTL0);

	return;
}

static void cvbs_set_vid1_clk(unsigned int src_pll)
{
	int sel = 0;

	printf("%s\n", __func__);
	if (src_pll == 0) { /* hpll */
		/* divider: 1 */
		/* Disable the div output clock */
		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 0, 19, 1);
		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 0, 15, 1);

		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 1, 18, 1);
		/* Enable the final output clock */
		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 1, 19, 1);
		sel = 0;
	} else { /* gp0_pll */
		sel = 1;
	}

	/* xd: 55 */
	/* setup the XD divider value */
	cvbs_set_hiu_bits(HHI_VID_CLK_DIV, (55 - 1), VCLK_XD0, 8);
	//udelay(5);
	/*0x59[16]/0x5f[19]/0x5f[20]*/
	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL, sel, VCLK_CLK_IN_SEL, 3);
	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL, 1, VCLK_EN0, 1);
	//udelay(2);

	/* vclk: 27M */
	/* [31:28]=0 enci_clk_sel, select vclk_div1 */
	cvbs_set_hiu_bits(HHI_VID_CLK_DIV, 0, 28, 4);
	cvbs_set_hiu_bits(HHI_VIID_CLK_DIV, 0, 28, 4);
	/* release vclk_div_reset and enable vclk_div */
	cvbs_set_hiu_bits(HHI_VID_CLK_DIV, 1, VCLK_XD_EN, 2);
	//udelay(5);

	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL, 1, VCLK_DIV1_EN, 1);

	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL, 1, VCLK_SOFT_RST, 1);
	//udelay(10);
	cvbs_set_hiu_bits(HHI_VID_CLK_CNTL, 0, VCLK_SOFT_RST, 1);
	//udelay(5);
}

static void cvbs_set_vid2_clk(unsigned int src_pll)
{
	int sel = 0;

	printf("%s\n", __func__);
	if (src_pll == 0) { /* hpll */
		/* divider: 1 */
		/* Disable the div output clock */
		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 0, 19, 1);
		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 0, 15, 1);

		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 1, 18, 1);
		/* Enable the final output clock */
		cvbs_set_hiu_bits(HHI_VID_PLL_CLK_DIV, 1, 19, 1);
		sel = 0;
	} else { /* gp0_pll */
		sel = 1;
	}

	/* xd: 55 */
	/* setup the XD divider value */
	cvbs_set_hiu_bits(HHI_VIID_CLK_DIV, (55 - 1), VCLK2_XD, 8);
	//udelay(5);
	/* Bit[18:16] - v2_cntl_clk_in_sel: vid_pll */
	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, sel, VCLK2_CLK_IN_SEL, 3);
	cvbs_set_hiu_bits(HHI_VIID_CLK_CNTL, 1, VCLK2_EN, 1);
	//udelay(2);

	/* vclk: 27M */
	/* [31:28]=8 enci_clk_sel, select vclk2_div1 */
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
}

static int cvbs_config_clock(void)
{
	/* pll output 1485M */
	if (check_cpu_type(MESON_CPU_MAJOR_ID_GXBB))
		cvbs_config_hdmipll_gxb();
	else if (check_cpu_type(MESON_CPU_MAJOR_ID_GXTVBB))
		cvbs_config_hdmipll_gxtvbb();
	else if (check_cpu_type(MESON_CPU_MAJOR_ID_G12A) ||
			check_cpu_type(MESON_CPU_MAJOR_ID_G12B)) {
		if (s_enci_clk_path & 0x1)
			cvbs_config_gp0pll_g12a();
		else
			cvbs_config_hdmipll_g12a();
	} else if (is_meson_tl1_cpu()) {
		cvbs_config_tcon_pll();
	} else if (is_equal_after_meson_cpu(MESON_CPU_MAJOR_ID_GXL))
		cvbs_config_hdmipll_gxl();

	if (check_cpu_type(MESON_CPU_MAJOR_ID_G12A) ||
		check_cpu_type(MESON_CPU_MAJOR_ID_G12B)) {
		if (s_enci_clk_path & 0x2)
			cvbs_set_vid1_clk(s_enci_clk_path & 0x1);
		else
			cvbs_set_vid2_clk(s_enci_clk_path & 0x1);
	} else if (is_meson_tl1_cpu()) {
		if (s_enci_clk_path & 0x2)
			cvbs_set_vid1_clk(0);
		else
			cvbs_set_vid2_clk(0);
	} else {
		cvbs_set_vid2_clk(0);
	}

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

	if (VMODE_PAL != mode && VMODE_PAL_M != mode && VMODE_PAL_N != mode)
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
	} else if (is_meson_g12a_cpu() || is_meson_g12b_cpu()) {
		max = sizeof(tvregs_576cvbs_performance_g12a)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_g12a[index];
		type = 9;
	} else if (is_meson_gxlx_cpu()) {
		max = sizeof(tvregs_576cvbs_performance_905l)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_905l[index];
		type = 7;
	} else if (is_equal_after_meson_cpu(MESON_CPU_MAJOR_ID_TXL)) {
		max = sizeof(tvregs_576cvbs_performance_txl)
			/ sizeof(struct reg_s *);
		index = (index >= max) ? 0 : index;
		s = tvregs_576cvbs_performance_txl[index];
		type = 8;
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
	else if (VMODE_NTSC_M == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_480cvbs_enc[0]);
	else if (VMODE_PAL_M == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_pal_m_enc[0]);
	else if (VMODE_PAL_N == vmode)
		cvbs_write_vcbus_array((struct reg_s*)&tvregs_pal_n_enc[0]);

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
	} else if (!strncmp(vmode_name, "ntsc_m", strlen("ntsc_m"))) {
		cvbs_mode = VMODE_NTSC_M;
		cvbs_config_enci(VMODE_NTSC_M);
		cvbs_config_clock();
		cvbs_set_vdac(1);
		return 0;
	} else if (!strncmp(vmode_name, "pal_m", strlen("pal_m"))) {
		cvbs_mode = VMODE_PAL_M;
		cvbs_config_enci(VMODE_PAL_M);
		cvbs_config_clock();
		cvbs_set_vdac(1);
		return 0;
	} else if (!strncmp(vmode_name, "pal_n", strlen("pal_n"))) {
		cvbs_mode = VMODE_PAL_N;
		cvbs_config_enci(VMODE_PAL_N);
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
// check for valid video mode
int cvbs_outputmode_check(char *vmode_name)
{
	if ((!strncmp(vmode_name, "576cvbs", strlen("576cvbs"))) ||
		(!strncmp(vmode_name, "480cvbs", strlen("480cvbs"))) ||
		(!strncmp(vmode_name, "ntsc_m", strlen("ntsc_m"))) ||
		(!strncmp(vmode_name, "pal_m", strlen("pal_m"))) ||
		(!strncmp(vmode_name, "pal_n", strlen("pal_n")))) {
		return 0;
	}

	printf("cvbs: outputmode[%s] is invalid\n", vmode_name);
	return -1;
}

/*----------------------------------------------------------------------------*/
// list for valid video mode
void cvbs_show_valid_vmode(void)
{
	printf("576cvbs\n""480cvbs\n""ntsc_m\n""pal_m\n""pal_n\n");
	return;
}

void vdac_data_config(void)
{
	printf("cvbs: cpuid:0x%x\n", get_cpu_id().family_id);
	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXL:
	case MESON_CPU_MAJOR_ID_GXM:
	case MESON_CPU_MAJOR_ID_GXLX:
		cvbs_vdac_data = &vdac_data_gxl;
		break;
	case MESON_CPU_MAJOR_ID_TXL:
	case MESON_CPU_MAJOR_ID_TXHD:
	case MESON_CPU_MAJOR_ID_TXLX:
		cvbs_vdac_data = &vdac_data_txl;
		break;
	case MESON_CPU_MAJOR_ID_G12A:
		cvbs_vdac_data = &vdac_data_g12a;
		break;
	case MESON_CPU_MAJOR_ID_G12B:
		cvbs_vdac_data = &vdac_data_g12b;
		break;
	case MESON_CPU_MAJOR_ID_TL1:
		cvbs_vdac_data = &vdac_data_tl1;
		break;
	default:
		cvbs_vdac_data = &vdac_data_default;
		break;
	}

	return;
}

void cvbs_init(void)
{
	vdac_data_config();
#ifdef CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT
	cvbs_performance_config();
#endif

	return;
}

