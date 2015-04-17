/*
 * Driver for the amlogic vpu controller
 *
 *
 */
#include <config.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include "aml_vpu_reg.h"
#include "aml_vpu.h"

#define VPU_VERION	"v01"

static char * dt_addr;
static int dts_ready = 0;

static struct VPU_Conf_t vpu_conf = {
	.chip_type = VPU_CHIP_MAX,
	.clk_level_dft = 0,
	.clk_level_max = 1,
	.clk_level = 0,
	.fclk_type = 0,
};

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
	unsigned int clk_freq;
	unsigned int fclk, clk_source;
	unsigned int mux, div;

	fclk = fclk_table[vpu_conf.fclk_type] * 100; /* 0.01M resolution */
	mux = vpu_reg_getb(HHI_VPU_CLK_CNTL, 9, 3);
	switch (mux) {
	case 0: /* fclk_div4 */
	case 1: /* fclk_div3 */
	case 2: /* fclk_div5 */
	case 3: /* fclk_div7, m8m2 gp_pll = fclk_div7 */
		clk_source = fclk / fclk_div_table[mux];
		break;
	case 7:
		if (vpu_conf.chip_type == VPU_CHIP_G9TV)
			clk_source = 696 * 100; /* 0.01MHz */
		else
			clk_source = 0;
		break;
	default:
		clk_source = 0;
		break;
	}

	div = vpu_reg_getb(HHI_VPU_CLK_CNTL, 0, 7) + 1;
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
		vpu_reg_write(HHI_GP_PLL_CNTL, 0x206b6);
		vpu_reg_setb(HHI_GP_PLL_CNTL, 1, 30, 1); /* enable */
		do {
			udelay(10);
			vpu_reg_setb(HHI_GP_PLL_CNTL, 1, 29, 1); /* reset */
			udelay(50);
			/* release reset */
			vpu_reg_setb(HHI_GP_PLL_CNTL, 0, 29, 1);
			udelay(50);
			cnt--;
			if (cnt == 0)
				break;
		} while (vpu_reg_getb(HHI_GP_PLL_CNTL, 31, 1) == 0);
		if (cnt == 0) {
			ret = 1;
			vpu_reg_setb(HHI_GP_PLL_CNTL, 0, 30, 1);
			printf("[error]: GP_PLL lock failed, can't use the clk source!\n");
		}
	} else { /* disable gp_pll */
		vpu_reg_setb(HHI_GP_PLL_CNTL, 0, 30, 1);
	}

	return ret;
}

static int switch_gp1_pll_g9tv(int flag)
{
	int cnt = 100;
	int ret = 0;

	if (flag) { /* enable gp1_pll */
		/* GP1 DPLL 696MHz output*/
		vpu_reg_write(HHI_GP1_PLL_CNTL, 0x6a01023a);
		vpu_reg_write(HHI_GP1_PLL_CNTL2, 0x69c80000);
		vpu_reg_write(HHI_GP1_PLL_CNTL3, 0x0a5590c4);
		vpu_reg_write(HHI_GP1_PLL_CNTL4, 0x0000500d);
		vpu_reg_write(HHI_GP1_PLL_CNTL, 0x4a01023a);
		do {
			udelay(10);
			vpu_reg_setb(HHI_GP1_PLL_CNTL, 1, 29, 1); /* reset */
			udelay(50);
			/* release reset */
			vpu_reg_setb(HHI_GP1_PLL_CNTL, 0, 29, 1);
			udelay(50);
			cnt--;
			if (cnt == 0)
				break;
		} while (vpu_reg_getb(HHI_GP1_PLL_CNTL, 31, 1) == 0);
		if (cnt == 0) {
			ret = 1;
			vpu_reg_setb(HHI_GP1_PLL_CNTL, 0, 30, 1);
			printf("[error]: GP_PLL lock failed, can't use the clk source!\n");
		}
	} else { /* disable gp1_pll */
		vpu_reg_setb(HHI_GP1_PLL_CNTL, 0, 30, 1);
	}

	return ret;
}

static int adjust_vpu_clk(unsigned int clk_level)
{
	unsigned int mux, div;
	int ret = 0;

	vpu_conf.clk_level = clk_level;
	switch (vpu_conf.chip_type) {
	case VPU_CHIP_M8M2:
		if (clk_level == (CLK_LEVEL_MAX_M8M2 - 1)) {
			ret = switch_gp_pll_m8m2(1);
			if (ret) {
				clk_level = CLK_LEVEL_MAX_M8M2 - 2;
				vpu_conf.clk_level = clk_level;
			}
		} else {
			ret = switch_gp_pll_m8m2(0);
		}
		break;
	case VPU_CHIP_G9TV:
		if (clk_level == (CLK_LEVEL_MAX_G9TV - 1)) {
			ret = switch_gp1_pll_g9tv(1);
			if (ret) {
				clk_level = CLK_LEVEL_MAX_G9TV - 2;
				vpu_conf.clk_level = clk_level;
			}
		} else {
			ret = switch_gp1_pll_g9tv(0);
		}
		break;
	default:
		break;
	}

	mux = vpu_clk_table[vpu_conf.fclk_type][clk_level][1];
	div = vpu_clk_table[vpu_conf.fclk_type][clk_level][2];
	vpu_reg_write(HHI_VPU_CLK_CNTL, ((mux << 9) | (div << 0) | (1<<8)));

	printf("set vpu clk: %uHz, readback: %uHz(0x%x)\n",
		vpu_clk_table[vpu_conf.fclk_type][clk_level][0],
		get_vpu_clk(), (vpu_reg_read(HHI_VPU_CLK_CNTL)));
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
		printf("vpu clk out of supported range, set to default\n");
	}

	ret = adjust_vpu_clk(clk_level);

	return ret;
}

static void vpu_power_on(void)
{
	set_vpu_clk(vpu_conf.clk_level);

	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 0, 8, 1); /* [8] power on */
	vpu_reg_write(HHI_VPU_MEM_PD_REG0, 0x00000000);
	vpu_reg_write(HHI_VPU_MEM_PD_REG1, 0x00000000);
	vpu_reg_setb(HHI_MEM_PD_REG0, 0, 8, 8); /* MEM-PD */
	udelay(2);

	/* Reset VIU + VENC */
	/* Reset VENCI + VENCP + VADC + VENCL */
	/* Reset HDMI-APB + HDMI-SYS + HDMI-TX + HDMI-CEC */
	vpu_clr_mask(RESET0_MASK, ((1 << 5) | (1<<10)));
	vpu_clr_mask(RESET4_MASK, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_clr_mask(RESET2_MASK, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));
	vpu_reg_write(RESET2_REGISTER, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));
	/* reset this will cause VBUS reg to 0 */
	vpu_reg_write(RESET4_REGISTER, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_reg_write(RESET0_REGISTER, ((1 << 5) | (1<<10)));
	vpu_reg_write(RESET4_REGISTER, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_reg_write(RESET2_REGISTER, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));
	vpu_set_mask(RESET0_MASK, ((1 << 5) | (1<<10)));
	vpu_set_mask(RESET4_MASK, ((1 << 6) | (1<<7) | (1<<9) | (1<<13)));
	vpu_set_mask(RESET2_MASK, ((1 << 2) | (1<<3) | (1<<11) | (1<<15)));

	/* Remove VPU_HDMI ISO */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 0, 9, 1); /* [9] VPU_HDMI */
}

static void vpu_power_off(void)
{
	/* Power down VPU_HDMI */
	/* Enable Isolation */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 1, 9, 1); /* ISO */
	/* Power off memory */
	vpu_reg_write(HHI_VPU_MEM_PD_REG0, 0xffffffff);
	vpu_reg_write(HHI_VPU_MEM_PD_REG1, 0xffffffff);
	vpu_reg_setb(HHI_MEM_PD_REG0, 0xff, 8, 8); /* HDMI MEM-PD */

	/* Power down VPU domain */
	vpu_ao_setb(AO_RTI_GEN_PWR_SLEEP0, 1, 8, 1); /* PDN */

	vpu_reg_setb(HHI_VPU_CLK_CNTL, 0, 8, 1);
}

static void detect_vpu_chip(void)
{
/* for gxbb bring up */
#if 0
	unsigned int cpu_type;

	cpu_type = get_cpu_type();
	switch (cpu_type) {
	case MESON_CPU_MAJOR_ID_M8:
		vpu_conf.chip_type = VPU_CHIP_M8;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_M8;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_M8;
		vpu_conf.fclk_type = FCLK_TYPE_M8;
		break;
	case MESON_CPU_MAJOR_ID_M8B:
		vpu_conf.chip_type = VPU_CHIP_M8B;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_M8B;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_M8B;
		vpu_conf.fclk_type = FCLK_TYPE_M8B;
		break;
	case MESON_CPU_MAJOR_ID_M8M2:
		vpu_conf.chip_type = VPU_CHIP_M8M2;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_M8M2;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_M8M2;
		vpu_conf.fclk_type = FCLK_TYPE_M8M2;
		break;
	case MESON_CPU_MAJOR_ID_MG9TV:
		vpu_conf.chip_type = VPU_CHIP_G9TV;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_G9TV;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_G9TV;
		vpu_conf.fclk_type = FCLK_TYPE_G9TV;
		break;
	/* case MESON_CPU_MAJOR_ID_MG9BB:
		vpu_conf.chip_type = VPU_CHIP_G9BB;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_G9BB;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_G9BB;
		vpu_conf.fclk_type = FCLK_TYPE_G9BB;
		break; */
	case MESON_CPU_MAJOR_ID_GXBB:
		vpu_conf.chip_type = VPU_CHIP_GXBB;
		vpu_conf.clk_level_dft = CLK_LEVEL_DFT_GXBB;
		vpu_conf.clk_level_max = CLK_LEVEL_MAX_GXBB;
		vpu_conf.fclk_type = FCLK_TYPE_GXBB;
		break;
	default:
		vpu_conf.chip_type = VPU_CHIP_MAX;
		vpu_conf.clk_level_dft = 0;
		vpu_conf.clk_level_max = 1;
	}
#else
	vpu_conf.chip_type = VPU_CHIP_GXBB;
	vpu_conf.clk_level_dft = CLK_LEVEL_DFT_GXBB;
	vpu_conf.clk_level_max = CLK_LEVEL_MAX_GXBB;
	vpu_conf.fclk_type = FCLK_TYPE_GXBB;
#endif

	printf("vpu driver detect cpu type: %s\n",
			vpu_chip_name[vpu_conf.chip_type]);
}

static int get_vpu_config(void)
{
	int ret = 0;
	int nodeoffset;
	char * propdata;

#ifdef CONFIG_OF_LIBFDT
	if (dts_ready == 1) {
		nodeoffset = fdt_path_offset(dt_addr, "/vpu");
		if (nodeoffset < 0) {
			printf("vpu preset: not find /vpu node in dts %s.\n",fdt_strerror(nodeoffset));
			return -1;
		}

		propdata = (char *)fdt_getprop(dt_addr, nodeoffset, "clk_level", NULL);
		if (propdata == NULL) {
			vpu_conf.clk_level = vpu_conf.clk_level_dft;
			printf("don't find to match clk_level in dts, use default setting.\n");
		} else {
			vpu_conf.clk_level = (unsigned short)(be32_to_cpup((u32*)propdata));
			printf("vpu clk_level in dts: %u\n", vpu_conf.clk_level);
		}
		return 0;
	}
#endif
	vpu_conf.clk_level = vpu_conf.clk_level_dft;
	printf("vpu clk_level = %u\n", vpu_conf.clk_level);
	return ret;
}

int vpu_probe(void)
{
	int ret;

	dts_ready = 0;
#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DT_PRELOAD
#ifdef CONFIG_DTB_LOAD_ADDR
	dt_addr = (char *)CONFIG_DTB_LOAD_ADDR;
#else
	dt_addr = (char *)0x0f000000;
#endif
	ret = fdt_check_header((const void *)dt_addr);
	if (ret < 0) {
		printf("check dts: %s, load default vpu parameters\n",
			fdt_strerror(ret));
	} else {
		dts_ready = 1;
	}
#endif
#endif

	detect_vpu_chip();
	ret = get_vpu_config();
	vpu_power_on();

	return ret;
}

int vpu_remove(void)
{
	vpu_power_off();
	return 0;
}
