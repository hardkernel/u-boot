/*
 * Driver for the amlogic vpu controller
 *
 *
 */
#include <config.h>
#include <asm/arch/io.h> 
#include <asm/arch/clock.h>

#define VPU_VERION	"v02"

typedef struct {
	unsigned int h_res;
	unsigned int v_res;
	unsigned int refresh_rate;
	unsigned int clk_level;
}VPU_Conf_t;

static char * dt_addr;
static int dts_ready = 0;

//************************************************
// VPU is not supposed to run at 364MHz.  It was designed to max out around 225MHz in BABY.
// Please lower it to 364/2 = 182MHz.  This is super urgent.
//************************************************
#define CLK_LEVEL_DFT		3
#define CLK_LEVEL_MAX		5	//limit max clk to 212M
static unsigned int vpu_clk_setting[][3] = {
	//frequency		clk_mux		div
	{106250000,		1,			7},	//0
	{127500000,		2,			3},	//1
	{159375000,		0,			3},	//2
	{182150000,		3,			1},	//3
	{212500000,		1,			3},	//4
	{255000000,		2,			1},	//5
	{318750000,		0,			1},	//6
	{364300000,		3,			0},	//7
	{425000000,		1,			1},	//8
	{510000000,		2,			0},	//9
	{637500000,		0,			0},	//10
	//{850000000,		1,			0},	//11
};

static VPU_Conf_t vpu_config = {
	.h_res = 2048,
	.v_res = 1536,
	.refresh_rate = 60,	//Hz
	.clk_level = CLK_LEVEL_DFT,
};

static unsigned int get_vpu_clk_level(unsigned int video_clk)
{
	unsigned int video_bw;
	unsigned clk_level;
	int i;
	
	video_bw = video_clk + 2000000;

	for (i=0; i<CLK_LEVEL_MAX; i++) {
		if (video_bw <= vpu_clk_setting[i][0])			
			break;
	}
	clk_level = i;

	return clk_level;
}

static unsigned int get_vpu_clk(void)
{
	unsigned int clk_freq;
	unsigned int clk_source, clk_div;
	
	switch ((readl(P_HHI_VPU_CLK_CNTL) >> 9) & 0x7) {
		case 0:
			clk_source = 637500000;
			break;
		case 1:
			clk_source = 850000000;
			break;
		case 2:
			clk_source = 510000000;
			break;
		case 3:
			clk_source = 364300000;
			break;
		default:
			clk_source = 0;
			break;
	}
	
	clk_div = ((readl(P_HHI_VPU_CLK_CNTL) >> 0) & 0x7f) + 1;
	clk_freq = clk_source / clk_div;
	
	return clk_freq;
}

static int set_vpu_clk(unsigned int vclk)
{
	int ret = 0;
	unsigned clk_level;
	
	if (vclk >= 100) {	//regard as vpu_clk
		clk_level = get_vpu_clk_level(vclk);
	}
	else {	//regard as clk_level
		clk_level = vclk;
	}

	if (clk_level >= CLK_LEVEL_MAX) {
		ret = 1;
		clk_level = CLK_LEVEL_DFT;
		printf("vpu clk out of supported range, set to default\n");
	}
	
	writel(((1 << 8) | (vpu_clk_setting[clk_level][1] << 9) | (vpu_clk_setting[clk_level][2] << 0)), P_HHI_VPU_CLK_CNTL);
	vpu_config.clk_level = clk_level;
	printf("set vpu clk: %uHz, readback: %uHz(0x%x)\n", vpu_clk_setting[clk_level][0], get_vpu_clk(), (readl(P_HHI_VPU_CLK_CNTL)));

	return ret;
}

static void vpu_driver_init(void)
{
    set_vpu_clk(vpu_config.clk_level);

    clrbits_le32(P_AO_RTI_GEN_PWR_SLEEP0, (0x1<<8)); // [8] power on
    writel(0x00000000, P_HHI_VPU_MEM_PD_REG0);
    writel(0x00000000, P_HHI_VPU_MEM_PD_REG1);
    clrbits_le32(P_HHI_MEM_PD_REG0, (0xff << 8)); // MEM-PD

    writel(0x00000000, P_VPU_MEM_PD_REG0);
    writel(0x00000000, P_VPU_MEM_PD_REG1);
    
    // Powerup VPU_HDMI
    clrbits_le32(P_RESET0_MASK, ((0x1 << 5) | (0x1<<10)));
    clrbits_le32(P_RESET4_MASK, ((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)));
    clrbits_le32(P_RESET2_MASK, ((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)));
    writel(((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)), P_RESET2_REGISTER);
    writel(((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)), P_RESET4_REGISTER);    // reset this will cause VBUS reg to 0
    writel(((0x1 << 5) | (0x1<<10)), P_RESET0_REGISTER);
    writel(((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)), P_RESET4_REGISTER);
    writel(((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)), P_RESET2_REGISTER);
    setbits_le32(P_RESET0_MASK, ((0x1 << 5) | (0x1<<10)));
    setbits_le32(P_RESET4_MASK, ((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)));
    setbits_le32(P_RESET2_MASK, ((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)));

    clrbits_le32(P_AO_RTI_GEN_PWR_SLEEP0, (0x1<<9)); // [9] VPU_HDMI
}

static void vpu_driver_disable(void)
{
    // Power down VPU_HDMI
    // Enable Isolation
    setbits_le32(P_AO_RTI_GEN_PWR_SLEEP0, (0x1 << 9)); //ISO
    writel(0xffffffff, P_VPU_MEM_PD_REG0);
    writel(0xffffffff, P_VPU_MEM_PD_REG1);
    setbits_le32(P_HHI_MEM_PD_REG0, (0xff << 8)); //HDMI MEM-PD

    writel(0xffffffff, P_HHI_VPU_MEM_PD_REG0);
    writel(0xffffffff, P_HHI_VPU_MEM_PD_REG1);

    // Power down VPU domain
    clrbits_le32(P_AO_RTI_GEN_PWR_SLEEP0, (0x1 << 8)); //PDN
    clrbits_le32(P_HHI_VPU_CLK_CNTL, (1 << 8));
}

static int get_vpu_config(void)
{
	int ret=0;
	int nodeoffset;
	char * propdata;
	
	if (dts_ready == 1) {
#ifdef CONFIG_OF_LIBFDT
		nodeoffset = fdt_path_offset(dt_addr, "/vpu");
		if(nodeoffset < 0) {
			printf("vpu preset: not find /vpu node in dts %s.\n",fdt_strerror(nodeoffset));
			return ret;
		}
		
		propdata = fdt_getprop(dt_addr, nodeoffset, "clk_level", NULL);
		if(propdata == NULL){
			vpu_config.clk_level = CLK_LEVEL_DFT;
			printf("don't find to match clk_level in dts, use default setting.\n");
		}
		else {
			vpu_config.clk_level = (unsigned short)(be32_to_cpup((u32*)propdata));
			printf("vpu clk_level in dts: %u\n", vpu_config.clk_level);
		}
#endif
	}
	else {
		vpu_config.clk_level = CLK_LEVEL_DFT;
		printf("vpu clk_level = %u\n", vpu_config.clk_level);
	}
	return ret;
}

int vpu_probe(void)
{
	int ret;

	dts_ready = 0;
#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DT_PRELOAD
#ifdef CONFIG_DTB_LOAD_ADDR
	dt_addr = CONFIG_DTB_LOAD_ADDR;
#else
	dt_addr = 0x0f000000;
#endif
	ret = fdt_check_header(dt_addr);
	if(ret < 0) {
		printf("check dts: %s, load default vpu parameters\n", fdt_strerror(ret));
	}
	else {
		dts_ready = 1;
	}
#endif
#endif
	
	get_vpu_config();
	vpu_driver_init();

	return 0;
}

int vpu_remove(void)
{
	vpu_driver_disable();
	return 0;
}
