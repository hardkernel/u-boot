
/*
 * drivers/vpu/aml_vpu.c
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <config.h>
#include <linux/kernel.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <vpu.h>
#include "aml_vpu_reg.h"
#include "aml_vpu.h"

#define VPU_VERION	"v02"

static char *dt_addr;
static int dts_ready = 0;

static struct vpu_conf_s vpu_conf = {
	.clk_level_dft = 0,
	.clk_level_max = 1,
	.clk_level = 0,
	.fclk_type = 0,
};

static void vpu_chip_detect(void)
{
#if 0
	unsigned int cpu_type;

	cpu_type = get_cpu_type();
	switch (cpu_type) {
	case MESON_CPU_MAJOR_ID_M8:
		vpu_chip_type = VPU_CHIP_M8;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_M8;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_M8;
		vpu_conf.fclk_type = FCLK_TYPE_M8;
		break;
	case MESON_CPU_MAJOR_ID_M8B:
		vpu_chip_type = VPU_CHIP_M8B;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_M8B;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_M8B;
		vpu_conf.fclk_type = FCLK_TYPE_M8B;
		break;
	case MESON_CPU_MAJOR_ID_M8M2:
		vpu_chip_type = VPU_CHIP_M8M2;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_M8M2;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_M8M2;
		vpu_conf.fclk_type = FCLK_TYPE_M8M2;
		break;
	case MESON_CPU_MAJOR_ID_MG9TV:
		vpu_chip_type = VPU_CHIP_G9TV;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_G9TV;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_G9TV;
		vpu_conf.fclk_type = FCLK_TYPE_G9TV;
		break;
	/* case MESON_CPU_MAJOR_ID_MG9BB:
		vpu_chip_type = VPU_CHIP_G9BB;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_G9BB;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_G9BB;
		vpu_conf.fclk_type = FCLK_TYPE_G9BB;
		break; */
	case MESON_CPU_MAJOR_ID_GXBB:
		vpu_chip_type = VPU_CHIP_GXBB;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_GXBB;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_GXBB;
		vpu_conf.fclk_type = FCLK_TYPE_GXBB;
		break;
	case MESON_CPU_MAJOR_ID_GXTVBB:
		vpu_chip_type = VPU_CHIP_GXTVBB;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_GXTVBB;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_GXTVBB;
		vpu_conf.fclk_type = FCLK_TYPE_GXTVBB;
		break;
	case MESON_CPU_MAJOR_ID_GXL:
		vpu_chip_type = VPU_CHIP_GXL;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_GXL;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_GXL;
		vpu_conf.fclk_type = FCLK_TYPE_GXL;
		break;
	default:
		vpu_chip_type = VPU_CHIP_MAX;
		vpu_conf.clk_level_dft = 0;
		vpu_conf.clk_level_max = 1;
	}
#else
	vpu_chip_type = VPU_CHIP_GXBB;
	vpu_conf.clk_level_dft = CLK_LEVEL_DFT_GXBB;
	vpu_conf.clk_level_max = CLK_LEVEL_MAX_GXBB;
	vpu_conf.fclk_type = FCLK_TYPE_GXBB;
#endif

#ifdef VPU_DEBUG_PRINT
	VPUPR("vpu: detect chip type: %d\n", vpu_chip_type);
	VPUPR("vpu: clk_level default: %d(%dHz), max: %d(%dHz)\n",
		vpu_conf.clk_level_dft,
		vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level_dft][0],
		vpu_conf.clk_level_max,
		vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level_max][0],);
#endif
}

static unsigned int get_vpu_clk_level(unsigned int video_clk)
{
	unsigned int video_bw;
	unsigned clk_level;
	int i;

	video_bw = video_clk + 1000000;

	for (i = 0; i < vpu_conf.clk_level_max; i++) {
		if (video_bw <= vpu_clk_table[vpu_conf.fclk_type][i][0])
			break;
	}
	clk_level = i;

	return clk_level;
}

static unsigned int get_vpu_clk(void)
{
	unsigned int reg;
	unsigned int clk_freq;
	unsigned int fclk, clk_source;
	unsigned int mux, div;

	if (vpu_chip_type == VPU_CHIP_GXBB)
		reg = HHI_VPU_CLK_CNTL_GX;
	else
		reg = HHI_VPU_CLK_CNTL;

	fclk = fclk_table[vpu_conf.fclk_type] * 100; /* 0.01M resolution */
	mux = vpu_hiu_getb(reg, 9, 3);
	switch (mux) {
	case 0: /* fclk_div4 */
	case 1: /* fclk_div3 */
	case 2: /* fclk_div5 */
	case 3: /* fclk_div7, m8m2 gp_pll = fclk_div7 */
		clk_source = fclk / fclk_div_table[mux];
		break;
	case 7:
		if (vpu_chip_type == VPU_CHIP_G9TV)
			clk_source = 696 * 100; /* 0.01MHz */
		else
			clk_source = 0;
		break;
	default:
		clk_source = 0;
		break;
	}

	div = vpu_hiu_getb(reg, 0, 7) + 1;
	clk_freq = (clk_source / div) * 10 * 1000; /* change to Hz */

	return clk_freq;
}

static int switch_gp_pll_m8m2(int flag)
{
	int cnt = 100;
	int ret = 0;

	if (flag) { /* enable gp_pll */
		/* M=182, N=3, OD=2. gp_pll=24*M/N/2^OD=364M */
		/* set gp_pll frequency fixed to 364M */
		vpu_cbus_write(HHI_GP_PLL_CNTL, 0x206b6);
		vpu_cbus_setb(HHI_GP_PLL_CNTL, 1, 30, 1); /* enable */
		do {
			udelay(10);
			vpu_cbus_setb(HHI_GP_PLL_CNTL, 1, 29, 1); /* reset */
			udelay(50);
			/* release reset */
			vpu_cbus_setb(HHI_GP_PLL_CNTL, 0, 29, 1);
			udelay(50);
			cnt--;
			if (cnt == 0)
				break;
		} while (vpu_cbus_getb(HHI_GP_PLL_CNTL, 31, 1) == 0);
		if (cnt == 0) {
			ret = 1;
			vpu_cbus_setb(HHI_GP_PLL_CNTL, 0, 30, 1);
			VPUERR("GP_PLL lock failed\n");
		}
	} else { /* disable gp_pll */
		vpu_cbus_setb(HHI_GP_PLL_CNTL, 0, 30, 1);
	}

	return ret;
}

static int switch_gp1_pll_g9tv(int flag)
{
	int cnt = 100;
	int ret = 0;

	if (flag) { /* enable gp1_pll */
		/* GP1 DPLL 696MHz output*/
		vpu_cbus_write(HHI_GP1_PLL_CNTL, 0x6a01023a);
		vpu_cbus_write(HHI_GP1_PLL_CNTL2, 0x69c80000);
		vpu_cbus_write(HHI_GP1_PLL_CNTL3, 0x0a5590c4);
		vpu_cbus_write(HHI_GP1_PLL_CNTL4, 0x0000500d);
		vpu_cbus_write(HHI_GP1_PLL_CNTL, 0x4a01023a);
		do {
			udelay(10);
			vpu_cbus_setb(HHI_GP1_PLL_CNTL, 1, 29, 1); /* reset */
			udelay(50);
			/* release reset */
			vpu_cbus_setb(HHI_GP1_PLL_CNTL, 0, 29, 1);
			udelay(50);
			cnt--;
			if (cnt == 0)
				break;
		} while (vpu_cbus_getb(HHI_GP1_PLL_CNTL, 31, 1) == 0);
		if (cnt == 0) {
			ret = 1;
			vpu_cbus_setb(HHI_GP1_PLL_CNTL, 0, 30, 1);
			VPUERR("GP_PLL lock failed\n");
		}
	} else { /* disable gp1_pll */
		vpu_cbus_setb(HHI_GP1_PLL_CNTL, 0, 30, 1);
	}

	return ret;
}

static int adjust_vpu_clk_m8_g9(unsigned int clk_level)
{
	unsigned int mux, div;
	int ret = 0;

	switch (vpu_chip_type) {
	case VPU_CHIP_M8M2:
		if (clk_level == (CLK_LEVEL_MAX_M8M2 - 1)) {
			ret = switch_gp_pll_m8m2(1);
			if (ret)
				clk_level = CLK_LEVEL_MAX_M8M2 - 2;
		} else {
			ret = switch_gp_pll_m8m2(0);
		}
		break;
	case VPU_CHIP_G9TV:
		if (clk_level == (CLK_LEVEL_MAX_G9TV - 1)) {
			ret = switch_gp1_pll_g9tv(1);
			if (ret)
				clk_level = CLK_LEVEL_MAX_G9TV - 2;
		} else {
			ret = switch_gp1_pll_g9tv(0);
		}
		break;
	default:
		break;
	}
	vpu_conf.clk_level = clk_level;

	mux = vpu_clk_table[vpu_conf.fclk_type][clk_level][1];
	div = vpu_clk_table[vpu_conf.fclk_type][clk_level][2];
	vpu_hiu_write(HHI_VPU_CLK_CNTL, ((mux << 9) | (div << 0) | (1<<8)));

	VPUPR("set clk: %uHz, readback: %uHz(0x%x)\n",
		vpu_clk_table[vpu_conf.fclk_type][clk_level][0],
		get_vpu_clk(), (vpu_hiu_read(HHI_VPU_CLK_CNTL)));
	return ret;
}

/* unit: MHz */
#define VPU_CLKB_MAX    350
static int adjust_vpu_clk_gx(unsigned int clk_level)
{
	unsigned int vpu_clk;
	unsigned int mux, div;
	int ret = 0;

	vpu_conf.clk_level = clk_level;
	vpu_clk = vpu_clk_table[vpu_conf.fclk_type][clk_level][0];
	mux = vpu_clk_table[vpu_conf.fclk_type][clk_level][1];
	div = vpu_clk_table[vpu_conf.fclk_type][clk_level][2];

	vpu_hiu_write(HHI_VPU_CLK_CNTL_GX, ((mux << 9) | (div << 0)));
	vpu_hiu_setb(HHI_VPU_CLK_CNTL_GX, 1, 8, 1);

	if (vpu_clk >= (VPU_CLKB_MAX * 1000000))
		vpu_hiu_write(HHI_VPU_CLKB_CNTL_GX, ((1 << 8) | (1 << 0)));
	else
		vpu_hiu_write(HHI_VPU_CLKB_CNTL_GX, ((1 << 8) | (0 << 0)));

	vpu_hiu_write(HHI_VAPBCLK_CNTL_GX, (1 << 30) | /* turn on ge2d clock */
			(0 << 9)    |   /* clk_sel    //250Mhz */
			(1 << 0));      /* clk_div */
	vpu_hiu_setb(HHI_VAPBCLK_CNTL_GX, 1, 8, 1);

	VPUPR("set clk: %uHz, readback: %uHz(0x%x)\n",
		vpu_clk, get_vpu_clk(), (vpu_hiu_read(HHI_VPU_CLK_CNTL_GX)));
	return ret;
}

static int set_vpu_clk(unsigned int vclk)
{
	int ret = 0;
	unsigned int clk_level;

	if (vclk >= 100) /* regard as vpu_clk */
		clk_level = get_vpu_clk_level(vclk);
	else /* regard as clk_level */
		clk_level = vclk;

	if (clk_level >= vpu_conf.clk_level_max) {
		ret = 1;
		clk_level = vpu_conf.clk_level_dft;
		VPUPR("clk out of supported range, set to default\n");
	}

	if (vpu_chip_type == VPU_CHIP_GXBB)
		ret = adjust_vpu_clk_gx(clk_level);
	else
		ret = adjust_vpu_clk_m8_g9(clk_level);

	return ret;
}

static void vpu_power_on_m8_g9(void)
{
	unsigned int i;

	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 0, 8, 1); /* [8] power on */
	udelay(20);

	/* power up memories */
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG0, 0, i, 2);
		udelay(5);
	}
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG1, 0, i, 2);
		udelay(5);
	}
	for (i = 8; i < 16; i++) {
		vpu_hiu_setb(HHI_MEM_PD_REG0, 0, i, 1);
		udelay(5);
	}
	udelay(20);

	/* Reset VIU + VENC */
	/* Reset VENCI + VENCP + VADC + VENCL */
	/* Reset HDMI-APB + HDMI-SYS + HDMI-TX + HDMI-CEC */
	vpu_cbus_clr_mask(RESET0_MASK, ((1 << 5) | (1<<10)));
	vpu_cbus_clr_mask(RESET4_MASK, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_cbus_clr_mask(RESET2_MASK, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));
	vpu_cbus_write(RESET2_REGISTER, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));
	/* reset this will cause VBUS reg to 0 */
	vpu_cbus_write(RESET4_REGISTER, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_cbus_write(RESET0_REGISTER, ((1 << 5) | (1<<10)));
	vpu_cbus_write(RESET4_REGISTER, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_cbus_write(RESET2_REGISTER, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));
	vpu_cbus_set_mask(RESET0_MASK, ((1 << 5) | (1<<10)));
	vpu_cbus_set_mask(RESET4_MASK, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_cbus_set_mask(RESET2_MASK, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));

	/* Remove VPU_HDMI ISO */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 0, 9, 1); /* [9] VPU_HDMI */
}

static void vpu_power_on_gx(void)
{
	unsigned int i;

	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 0, 8, 1); /* [8] power on */
	udelay(20);

	/* power up memories */
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG0_GX, 0, i, 2);
		udelay(5);
	}
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG1_GX, 0, i, 2);
		udelay(5);
	}
	for (i = 8; i < 16; i++) {
		vpu_hiu_setb(HHI_MEM_PD_REG0_GX, 0, i, 1);
		udelay(5);
	}
	udelay(20);

	/* Reset VIU + VENC */
	/* Reset VENCI + VENCP + VADC + VENCL */
	/* Reset HDMI-APB + HDMI-SYS + HDMI-TX + HDMI-CEC */
	vpu_cbus_clr_mask(RESET0_LEVEL, ((1<<5) | (1<<10) | (1<<19) | (1<<13)));
	vpu_cbus_clr_mask(RESET1_LEVEL, (1<<5));
	vpu_cbus_clr_mask(RESET2_LEVEL, (1<<15));
	vpu_cbus_clr_mask(RESET4_LEVEL, ((1<<6) | (1<<7) | (1<<13) | (1<<5) | (1<<9) | (1<<4) | (1<<12)));
	vpu_cbus_clr_mask(RESET7_LEVEL, (1<<7));

	/* Remove VPU_HDMI ISO */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 0, 9, 1); /* [9] VPU_HDMI */

	/* release Reset */
	vpu_cbus_set_mask(RESET0_LEVEL, ((1 << 5) | (1<<10) | (1<<19) | (1<<13)));
	vpu_cbus_set_mask(RESET1_LEVEL, (1<<5));
	vpu_cbus_set_mask(RESET2_LEVEL, (1<<15));
	vpu_cbus_set_mask(RESET4_LEVEL, ((1<<6) | (1<<7) | (1<<13) | (1<<5) | (1<<9) | (1<<4) | (1<<12)));
	vpu_cbus_set_mask(RESET7_LEVEL, (1<<7));
}

static void vpu_power_off_m8_g9(void)
{
	unsigned int i;

	/* Power down VPU_HDMI */
	/* Enable Isolation */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 1, 9, 1); /* ISO */
	udelay(20);

	/* power down memories */
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG0, 0x3, i, 2);
		udelay(5);
	}
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG1, 0x3, i, 2);
		udelay(5);
	}
	for (i = 8; i < 16; i++) {
		vpu_hiu_setb(HHI_MEM_PD_REG0, 0x1, i, 1);
		udelay(5);
	}
	udelay(20);

	/* Power down VPU domain */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 1, 8, 1); /* PDN */

	vpu_hiu_setb(HHI_VPU_CLK_CNTL, 0, 8, 1);
}

static void vpu_power_off_gx(void)
{
	unsigned int i;

	/* Power down VPU_HDMI */
	/* Enable Isolation */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 1, 9, 1); /* ISO */
	udelay(20);

	/* power down memories */
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG0_GX, 0x3, i, 2);
		udelay(5);
	}
	for (i = 0; i < 32; i+=2) {
		vpu_hiu_setb(HHI_VPU_MEM_PD_REG1_GX, 0x3, i, 2);
		udelay(5);
	}
	for (i = 8; i < 16; i++) {
		vpu_hiu_setb(HHI_MEM_PD_REG0_GX, 0x1, i, 1);
		udelay(5);
	}
	udelay(20);

	/* Power down VPU domain */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 1, 8, 1); /* PDN */

	vpu_hiu_setb(HHI_VAPBCLK_CNTL_GX, 0, 8, 1);
	vpu_hiu_setb(HHI_VPU_CLKB_CNTL_GX, 0, 8, 1);
	vpu_hiu_setb(HHI_VPU_CLK_CNTL_GX, 0, 8, 1);
}

static void vpu_power_on(void)
{
	switch (vpu_chip_type) {
	case VPU_CHIP_GXBB:
	case VPU_CHIP_GXTVBB:
	case VPU_CHIP_GXL:
		vpu_power_on_gx();
		break;
	case VPU_CHIP_M8:
	case VPU_CHIP_M8B:
	case VPU_CHIP_M8M2:
	case VPU_CHIP_G9TV:
	case VPU_CHIP_G9BB:
		vpu_power_on_m8_g9();
		break;
	default:
		break;
	}
}

static void vpu_power_off(void)
{
	switch (vpu_chip_type) {
	case VPU_CHIP_GXBB:
	case VPU_CHIP_GXTVBB:
	case VPU_CHIP_GXL:
		vpu_power_off_gx();
		break;
	case VPU_CHIP_M8:
	case VPU_CHIP_M8B:
	case VPU_CHIP_M8M2:
	case VPU_CHIP_G9TV:
	case VPU_CHIP_G9BB:
		vpu_power_off_m8_g9();
		break;
	default:
		break;
	}
}

static int get_vpu_config(void)
{
	int nodeoffset;
	char * propdata;


	if (dts_ready == 1) {
#ifdef CONFIG_OF_LIBFDT
		nodeoffset = fdt_path_offset(dt_addr, "/vpu");
		if (nodeoffset < 0) {
			VPUERR("not find /vpu node in dts %s\n", fdt_strerror(nodeoffset));
			return -1;
		}

		propdata = (char *)fdt_getprop(dt_addr, nodeoffset, "clk_level", NULL);
		if (propdata == NULL) {
			vpu_conf.clk_level = vpu_conf.clk_level_dft;
			VPUERR("don't find clk_level in dts, set to default\n");
		} else {
			vpu_conf.clk_level = (unsigned short)(be32_to_cpup((u32*)propdata));
			if (vpu_conf.clk_level >= vpu_conf.clk_level_max) {
				VPUERR("clk_level in dts is out of support, set to default\n");
				vpu_conf.clk_level = vpu_conf.clk_level_dft;
			}
		}
		VPUPR("clk_level in dts: %u\n", vpu_conf.clk_level);
#endif
	} else {
		vpu_conf.clk_level = vpu_conf.clk_level_dft;
		VPUPR("clk_level = %u\n", vpu_conf.clk_level);
	}

	return 0;
}

int vpu_probe(void)
{
	int ret;

	dts_ready = 0;
#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DTB_MEM_ADDR
	dt_addr = (char *)CONFIG_DTB_MEM_ADDR;
#else
	dt_addr = (char *)0x01000000;
#endif
	ret = fdt_check_header((const void *)dt_addr);
	if (ret < 0) {
		VPUERR("vpu: check dts: %s, load default parameters\n",
			fdt_strerror(ret));
	} else {
		dts_ready = 1;
	}
#endif

	vpu_chip_detect();
	ret = get_vpu_config();
	vpu_power_on();
	set_vpu_clk(vpu_conf.clk_level);
	//vpu_power_on();

	return ret;
}

int vpu_remove(void)
{
	VPUPR("vpu remove\n");
	vpu_power_off();
	return 0;
}

static void vpu_clk_switch(unsigned int clk_reg)
{
	unsigned int mux, div;

	/* step 1: switch to 2nd vpu clk patch */
	mux = vpu_clk_table[vpu_conf.fclk_type][0][1];
	vpu_hiu_setb(clk_reg, mux, 25, 3);
	div = vpu_clk_table[vpu_conf.fclk_type][0][2];
	vpu_hiu_setb(clk_reg, div, 16, 7);
	vpu_hiu_setb(clk_reg, 1, 24, 1);
	vpu_hiu_setb(clk_reg, 1, 31, 1);
	udelay(10);
	/* step 2: adjust 1st vpu clk frequency */
	vpu_hiu_setb(clk_reg, 0, 8, 1);
	mux = vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level][1];
	vpu_hiu_setb(clk_reg, mux, 9, 3);
	div = vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level][2];
	vpu_hiu_setb(clk_reg, div, 0, 7);
	vpu_hiu_setb(clk_reg, 1, 8, 1);
	udelay(20);
	/* step 3: switch back to 1st vpu clk patch */
	vpu_hiu_setb(clk_reg, 0, 31, 1);
	vpu_hiu_setb(clk_reg, 0, 24, 1);
}

int vpu_clk_change(int level)
{
	unsigned int vpu_clk;
	unsigned int mux, div;
	unsigned int reg;

	if (level >= 100) /* regard as vpu_clk */
		level = get_vpu_clk_level(level);

	if (level >= vpu_conf.clk_level_max) {
		VPUPR("clk out of supported range\n");
		VPUPR("clk max level: %u(&uHz)\n",
			vpu_conf.clk_level_max,
			vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level_max][0]);
		return -1;
	}

	vpu_conf.clk_level = level;
	vpu_clk = vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level][0];

	switch (vpu_chip_type) {
	case VPU_CHIP_GXBB:
	case VPU_CHIP_GXTVBB:
	case VPU_CHIP_GXL:
		reg = HHI_VPU_CLK_CNTL_GX;
		vpu_clk_switch(reg);

		if (vpu_clk >= (VPU_CLKB_MAX * 1000000))
			div = 2;
		else
			div = 1;
		vpu_hiu_setb(HHI_VPU_CLKB_CNTL_GX, (div - 1), 0, 8);
		break;
	case VPU_CHIP_M8:
		reg = HHI_VPU_CLK_CNTL;
		mux = vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level][1];
		div = vpu_clk_table[vpu_conf.fclk_type][vpu_conf.clk_level][2];
		vpu_hiu_write(reg, ((mux << 9) | (div << 0) | (1<<8)));
		break;
	case VPU_CHIP_M8B:
	case VPU_CHIP_M8M2:
	case VPU_CHIP_G9TV:
	case VPU_CHIP_G9BB:
		reg = HHI_VPU_CLK_CNTL;
		vpu_clk_switch(reg);
		break;
	default:
		reg = HHI_VPU_CLK_CNTL;
		break;
	}

	VPUPR("set clk: %uHz, readback: %uHz(0x%x)\n",
		vpu_clk, get_vpu_clk(), vpu_hiu_read(reg));
	return 0;
}

void vpu_clk_get(void)
{
	unsigned int reg;

	switch (vpu_chip_type) {
	case VPU_CHIP_GXBB:
	case VPU_CHIP_GXTVBB:
	case VPU_CHIP_GXL:
		reg = HHI_VPU_CLK_CNTL_GX;
		break;
	default:
		reg = HHI_VPU_CLK_CNTL;
		break;
	}

	VPUPR("clk_level: %u, clk: %uHz, reg: 0x%x\n",
		vpu_conf.clk_level, get_vpu_clk(), vpu_hiu_read(reg));
}

static unsigned int vcbus_reg[] = {
	0x1d00, /* VPP_DUMMY_DATA */
	0x1702, /* DI_POST_SIZE */
	0x1c30, /* ENCP_DVI_HSO_BEGIN */
	0x1b78, /* VENC_VDAC_DACSEL0 */
};

void vcbus_test(void)
{
	unsigned int val;
	unsigned int temp;
	int i,j;

	VPUPR("vcbus test:\n");
	for (i = 0; i < ARRAY_SIZE(vcbus_reg); i++) {
		for (j = 0; j < 24; j++) {
			val = vpu_vcbus_read(vcbus_reg[i]);
			printf("%02d read 0x%04x=0x%08x\n", j, vcbus_reg[i], val);
		}
		printf("\n");
	}
	temp = 0x5a5a5a5a;
	for (i = 0; i < ARRAY_SIZE(vcbus_reg); i++) {
		vpu_vcbus_write(vcbus_reg[i], temp);
		val = vpu_vcbus_read(vcbus_reg[i]);
		printf("write 0x%04x=0x%08x, readback: 0x%08x\n", vcbus_reg[i], temp, val);
	}
	for (i = 0; i < ARRAY_SIZE(vcbus_reg); i++) {
		for (j = 0; j < 24; j++) {
			val = vpu_vcbus_read(vcbus_reg[i]);
			printf("%02d read 0x%04x=0x%08x\n", j, vcbus_reg[i], val);
		}
		printf("\n");
	}
}
