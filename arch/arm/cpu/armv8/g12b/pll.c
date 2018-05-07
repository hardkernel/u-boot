/*
 * rev history:
 * 2017.04.06 structure done
 *
 *
 *
 *
 */

#include <common.h>
#include <command.h>
#include <asm/cpu_id.h>
#include <malloc.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/timer.h>
#include <asm/arch/pll.h>

#define STR_PLL_TEST_ALL	"all"
#define STR_PLL_TEST_SYS	"sys"
#define STR_PLL_TEST_FIX	"fix"
#define STR_PLL_TEST_DDR	"ddr"
#define STR_PLL_TEST_HDMI	"hdmi"
#define STR_PLL_TEST_GP0	"gp0"

#define PLL_LOCK_CHECK_MAX		20

#define RET_PLL_LOCK_FAIL		0x1000
#define RET_CLK_NOT_MATCH		0x1
#define SYS_PLL_DIV16_CNTL		(1<<24)
#define SYS_CLK_DIV16_CNTL		(1)
#define SYS_PLL_TEST_DIV		4	/* div16 */
#define HDMI_PLL_DIV_CNTL		(1<<18)
#define HDMI_PLL_DIV_GATE		(1<<19)

#define PLL_DIV16_OFFSET		4	/* div2/2/4 */
#define GP0_PLL_TEST_DIV		0	/* div1 */

#define Wr(addr, data) writel(data, addr)
#define Rd(addr) readl(addr)

static int sys_pll_init(sys_pll_set_t * sys_pll_set);
static int sys_pll_test(sys_pll_set_t * sys_pll_set);
static int sys_pll_test_all(sys_pll_cfg_t * sys_pll_cfg);
static int fix_pll_test(void);
static int ddr_pll_test(void);
static int hdmi_pll_init(hdmi_pll_set_t * hdmi_pll_set);
static int hdmi_pll_test(hdmi_pll_set_t * hdmi_pll_set);
static int hdmi_pll_test_all(hdmi_pll_cfg_t * hdmi_pll_cfg);
static int gp0_pll_test(gp0_pll_set_t * gp0_pll);
static int gp0_pll_test_all(void);

#if 0
static unsigned int pll_range[PLL_ENUM][2] = {
	{101, 202}, //sys pll range
	{303, 404}, //fix pll range
	{505, 606}, //ddr pll range
	{707, 808}, //hdmi pll range
	{909, 999}, // pll range
};

static char pll_range_ind[PLL_ENUM][10] = {
	"sys",
	"fix",
	"ddr",
	"hdmi",
	"gp0",
};
#endif

static void update_bits(size_t reg, size_t mask, unsigned int val)
{
	unsigned int tmp, orig;
	orig = readl(reg);
	tmp = orig & ~mask;
	tmp |= val & mask;
	writel(tmp, reg);
}

hdmi_pll_cfg_t hdmi_pll_cfg = {
#if 0
	.hdmi_pll[0] = {
		.pll_clk   = 5940, /* MHz */
		.pll_cntl0 = 0x0b3a0400 | (0x7b & 0xff) | (0x3 << 28),
		.pll_cntl1 = 0x00018000,
		.pll_cntl2 = 0x00000000,
		.pll_cntl3 = 0x6a68dc00,
		.pll_cntl4 = 0x65771290,
		.pll_cntl5 = 0x39272000,
		.pll_cntl6 = 0x56540000
	},
#endif
	.hdmi_pll[0] = {
		.pll_clk   = 5405, /* MHz */
		.pll_cntl0 = 0x3b0004e1,
		.pll_cntl1 = 0x00007333,
		.pll_cntl2 = 0x00000000,
		.pll_cntl3 = 0x0a691c00,
		.pll_cntl4 = 0x33771290,
		.pll_cntl5 = 0x39270000,
		.pll_cntl6 = 0x50540000
	},
	.hdmi_pll[1] = {
		.pll_clk   = 4455,
		.pll_cntl0 = 0x3b0004b9,
		.pll_cntl1 = 0x00014000,
		.pll_cntl2 = 0x00000000,
		.pll_cntl3 = 0x0a691c00,
		.pll_cntl4 = 0x33771290,
		.pll_cntl5 = 0x39270000,
		.pll_cntl6 = 0x50540000
	},
#if 0
	.hdmi_pll[3] = {
		.pll_clk   = 3712,
		.pll_cntl0 = 0x3b00049a,
		.pll_cntl1 = 0x00016000,
		.pll_cntl2 = 0x00000000,
		.pll_cntl3 = 0x0a691c00,
		.pll_cntl4 = 0x33771290,
		.pll_cntl5 = 0x39270000,
		.pll_cntl6 = 0x50540000
	},
#endif
	.hdmi_pll[2] = {
		.pll_clk   = 3450,
		.pll_cntl0 = 0x3b00048f,
		.pll_cntl1 = 0x00018000,
		.pll_cntl2 = 0x00000000,
		.pll_cntl3 = 0x0a691c00,
		.pll_cntl4 = 0x33771290,
		.pll_cntl5 = 0x39270000,
		.pll_cntl6 = 0x50540000
	},
	.hdmi_pll[3] = {
		.pll_clk   = 2970,
		.pll_cntl0 = 0x3b00047b,
		.pll_cntl1 = 0x00018000,
		.pll_cntl2 = 0x00000000,
		.pll_cntl3 = 0x0a691c00,
		.pll_cntl4 = 0x33771290,
		.pll_cntl5 = 0x39270000,
		.pll_cntl6 = 0x50540000
	},
};

uint32_t sys_pll_clk[PLL_TEST_SYS_TOTAL] = {960, 1056, 1152, 1248, 1344, 1440, 1536, 1632};
sys_pll_cfg_t sys_pll_cfg = {
	.sys_pll[0] = {
		.cpu_clk   = 960,
		.pll_cntl  = 0,
		.pll_cntl1 = 0x0,
		.pll_cntl2 = 0x0,
		.pll_cntl3 = 0x48681c00,
		.pll_cntl4 = 0x88770290,
		.pll_cntl5 = 0x39272000,
		.pll_cntl6 = 0x56540000
	},
};

#define GPLL0_RATE(_rate, _m, _n, _od) \
{							\
		.rate	=	(_rate),				\
		.m		=	(_m),					\
		.n		=	(_n),					\
		.od		=	(_od),					\
}

static gpll_rate_table_t gpll0_tbl[] = {
	GPLL0_RATE(408,  136, 1, 3), /*DCO=3264M*/
	GPLL0_RATE(600,  200, 1, 3), /*DCO=4800M*/
	GPLL0_RATE(696,  232, 1, 3), /*DCO=5568M*/
	GPLL0_RATE(792,  132, 1, 2), /*DCO=3168M*/
	GPLL0_RATE(846,  141, 1, 2), /*DCO=3384M*/
	GPLL0_RATE(912,  152, 1, 2), /*DCO=3648M*/
};

static void pll_report(unsigned int flag, char * name) {
	if (flag)
		printf("%s pll test failed!\n", name);
	else
		printf("%s pll test pass!\n", name);
	return;
}

static int clk_around(unsigned int clk, unsigned int cmp) {
	if (((cmp-2) <= clk) && (clk <= (cmp+2)))
		return 1;
	else
		return 0;
}

static void clocks_set_sys_cpu_clk(uint32_t freq, uint32_t pclk_ratio, uint32_t aclkm_ratio, uint32_t atclk_ratio )
{
	uint32_t    control;
	uint32_t    dyn_pre_mux;
	uint32_t    dyn_post_mux;
	uint32_t    dyn_div;

	// Make sure not busy from last setting and we currently match the last setting
	do {
		control = Rd(HHI_SYS_CPU_CLK_CNTL);
	} while( (control & (1 << 28)) );

	control = control | (1 << 26);              // Enable

	// Switching to System PLL...just change the final mux
	if ( freq == 1 ) {
		// wire            cntl_final_mux_sel      = control[11];
		control = control | (1 << 11);
	} else {
		switch ( freq ) {
			case   0:       // If Crystal
				dyn_pre_mux     = 0;
				dyn_post_mux    = 0;
				dyn_div         = 0;    // divide by 1
				break;
			case 1000:      // fclk_div2
				dyn_pre_mux     = 1;
				dyn_post_mux    = 0;
				dyn_div         = 0;    // divide by 1
				break;
			case  667:      // fclk_div3
				dyn_pre_mux     = 2;
				dyn_post_mux    = 0;
				dyn_div         = 0;    // divide by 1
				break;
			case  500:      // fclk_div2/2
				dyn_pre_mux     = 1;
				dyn_post_mux    = 1;
				dyn_div         = 1;    // Divide by 2
				break;
			case  333:      // fclk_div3/2
				dyn_pre_mux     = 2;
				dyn_post_mux    = 1;
				dyn_div         = 1;    // divide by 2
				break;
			case  250:      // fclk_div2/4
				dyn_pre_mux     = 1;
				dyn_post_mux    = 1;
				dyn_div         = 3;    // divide by 4
				break;
			default:
				dyn_pre_mux     = 0;
				dyn_post_mux    = 0;
				dyn_div         = 0;    // divide by 1
				break;
		}
		if ( control & (1 << 10) ) {     // if using Dyn mux1, set dyn mux 0
			// Toggle bit[10] indicating a dynamic mux change
			control = (control & ~((1 << 10) | (0x3f << 4)  | (1 << 2)  | (0x3 << 0)))
			| ((0 << 10)
			| (dyn_div << 4)
			| (dyn_post_mux << 2)
			| (dyn_pre_mux << 0));
		} else {
			// Toggle bit[10] indicating a dynamic mux change
			control = (control & ~((1 << 10) | (0x3f << 20) | (1 << 18) | (0x3 << 16)))
			| ((1 << 10)
			| (dyn_div << 20)
			| (dyn_post_mux << 18)
			| (dyn_pre_mux << 16));
		}
		// Select Dynamic mux
		control = control & ~(1 << 11);
	}
	Wr(HHI_SYS_CPU_CLK_CNTL,control);
	//
	// Now set the divided clocks related to the System CPU
	//
	// This function changes the clock ratios for the
	// PCLK, ACLKM (AXI) and ATCLK
	//       .clk_clken0_i   ( {clk_div2_en,clk_div2}    ),
	//       .clk_clken1_i   ( {clk_div3_en,clk_div3}    ),
	//       .clk_clken2_i   ( {clk_div4_en,clk_div4}    ),
	//       .clk_clken3_i   ( {clk_div5_en,clk_div5}    ),
	//       .clk_clken4_i   ( {clk_div6_en,clk_div6}    ),
	//       .clk_clken5_i   ( {clk_div7_en,clk_div7}    ),
	//       .clk_clken6_i   ( {clk_div8_en,clk_div8}    ),

	uint32_t    control1 = Rd(HHI_SYS_CPU_CLK_CNTL1);

	//       .cntl_PCLK_mux              ( hi_sys_cpu_clk_cntl1[5:3]     ),
	if ( (pclk_ratio >= 2) && (pclk_ratio <= 8) ) {
		control1 = (control1 & ~(0x7 << 3)) | ((pclk_ratio-2) << 3);
	}
	//       .cntl_ACLKM_clk_mux         ( hi_sys_cpu_clk_cntl1[11:9]    ),  // AXI matrix
	if ( (aclkm_ratio >= 2) && (aclkm_ratio <= 8) ) {
		control1 = (control1 & ~(0x7 << 9)) | ((aclkm_ratio-2) << 9);
	}
	//       .cntl_ATCLK_clk_mux         ( hi_sys_cpu_clk_cntl1[8:6]     ),
	if ( (atclk_ratio >= 2) && (atclk_ratio <= 8) ) {
		control1 = (control1 & ~(0x7 << 6)) | ((atclk_ratio-2) << 6);
	}
	Wr( HHI_SYS_CPU_CLK_CNTL1, control1 );
}

static int sys_pll_init(sys_pll_set_t * sys_pll_set) {
	unsigned int lock_check = PLL_LOCK_CHECK_MAX;
	do {
		Wr(HHI_SYS_PLL_CNTL0, sys_pll_set->pll_cntl|(1<<29));
		Wr(HHI_SYS_PLL_CNTL1, sys_pll_set->pll_cntl1);
		Wr(HHI_SYS_PLL_CNTL2, sys_pll_set->pll_cntl2);
		Wr(HHI_SYS_PLL_CNTL3, sys_pll_set->pll_cntl3);
		Wr(HHI_SYS_PLL_CNTL4, sys_pll_set->pll_cntl4);
		Wr(HHI_SYS_PLL_CNTL5, sys_pll_set->pll_cntl5);
		Wr(HHI_SYS_PLL_CNTL0, ((1<<30)|(1<<29)|sys_pll_set->pll_cntl));
		Wr(HHI_SYS_PLL_CNTL0, Rd(HHI_SYS_PLL_CNTL0)&(~(1<<29)));
		_udelay(20);
		//printf("pll lock check %d\n", lock_check);
	} while((!((readl(HHI_SYS_PLL_CNTL0)>>31)&0x1)) && --lock_check);
	if (lock_check != 0)
		return 0;
	else
		return RET_PLL_LOCK_FAIL;
}

static int sys_pll_test_all(sys_pll_cfg_t * sys_pll_cfg) {
	unsigned int i=0;
	int ret=0;
/*
	for (i=0; i<(sizeof(sys_pll_cfg_t)/sizeof(sys_pll_set_t)); i++) {
		ret += sys_pll_test(&(sys_pll_cfg->sys_pll[i]));
	}
*/
	for (i=0; i<(sizeof(sys_pll_clk)/sizeof(uint32_t)); i++) {
		sys_pll_cfg->sys_pll[0].cpu_clk = sys_pll_clk[i];
		ret += sys_pll_test(&(sys_pll_cfg->sys_pll[0]));
	}
	return ret;
}

static int sys_pll_test(sys_pll_set_t * sys_pll_set) {
	unsigned int clk_msr_reg = 0;
	unsigned int clk_msr_val = 0;
	unsigned int sys_clk = 0;
	unsigned int sys_pll_cntl = 0;
	int ret=0;

	/* switch sys clk to oscillator */
	clocks_set_sys_cpu_clk( 0, 0, 0, 0);

	/* store current sys pll cntl */
	sys_pll_set_t sys_pll;
	sys_pll.pll_cntl = readl(HHI_SYS_PLL_CNTL0);
	sys_pll.pll_cntl1 = readl(HHI_SYS_PLL_CNTL1);
	sys_pll.pll_cntl2 = readl(HHI_SYS_PLL_CNTL2);
	sys_pll.pll_cntl3 = readl(HHI_SYS_PLL_CNTL3);
	sys_pll.pll_cntl4 = readl(HHI_SYS_PLL_CNTL4);
	sys_pll.pll_cntl5 = readl(HHI_SYS_PLL_CNTL5);

	if (sys_pll_set->cpu_clk == 0) {
		sys_clk = (24 / ((sys_pll_set->pll_cntl>>10)&0x1F) * (sys_pll_set->pll_cntl&0x1FF)) >> ((sys_pll_set->pll_cntl>>16)&0x3);
	}
	else {
		sys_clk = sys_pll_set->cpu_clk;
		if (sys_clk <= 750) {
			/* VCO/8, OD=3 */
			sys_pll_cntl = (3<<16/* OD */) | (1<<10/* N */) | (sys_clk / 3 /*M*/);
		}
		else if  (sys_clk <= 1500) {
			/* VCO/4, OD=2 */
			sys_pll_cntl = (2<<16/* OD */) | (1<<10/* N */) | (sys_clk / 6 /*M*/);
		}
		else {
			/* VCO/2, OD=1 */
			sys_pll_cntl = (1<<16/* OD */) | (1<<10/* N */) | (sys_clk / 12 /*M*/);
		}
		sys_pll_set->pll_cntl = 0x38000000 | sys_pll_cntl;
	}

	/* store CPU clk msr reg, restore it when test done */
	clk_msr_reg = readl(HHI_SYS_CPU_CLK_CNTL1);

	/* enable CPU clk msr cntl bit */
	writel(clk_msr_reg | SYS_PLL_DIV16_CNTL | SYS_CLK_DIV16_CNTL, HHI_SYS_CPU_CLK_CNTL1);

	//printf("HHI_SYS_CPU_CLK_CNTL: 0x%x\n", readl(HHI_SYS_CPU_CLK_CNTL));
	//printf("HHI_SYS_CPU_CLK_CNTL1: 0x%x\n", readl(HHI_SYS_CPU_CLK_CNTL1));

	if (0 == sys_pll_set->pll_cntl) {
		printf("sys pll cntl equal NULL, skip\n");
		return -1;
	}

	/* test sys pll */
	if (sys_pll_set->cpu_clk)
		sys_clk = sys_pll_set->cpu_clk;

	ret = sys_pll_init(sys_pll_set);
	_udelay(100);
	if (ret) {
		printf("SYS pll lock Failed! - %4d MHz\n", sys_clk);
	}
	else {
		printf("SYS pll lock OK! - %4d MHz. Div16 - %4d MHz. ", sys_clk, sys_clk>>PLL_DIV16_OFFSET);
		clk_msr_val = clk_util_clk_msr(17);
		printf("CLKMSR(17) - %4d MHz ", clk_msr_val);
		if (clk_around(clk_msr_val, sys_clk>>SYS_PLL_TEST_DIV)) {
			/* sys clk/pll div16 */
			printf(": Match\n");
		}
		else {
			ret = RET_CLK_NOT_MATCH;
			printf(": MisMatch\n");
		}
	}

	/* restore sys pll */
	sys_pll_init(&sys_pll);
	clocks_set_sys_cpu_clk( 1, 0, 0, 0);

	/* restore clk msr reg */
	writel(clk_msr_reg, HHI_SYS_CPU_CLK_CNTL1);
	return ret;
}

static int fix_pll_test(void) {
	return 0;
}

static int ddr_pll_test(void) {
	return 0;
}

static int hdmi_pll_init(hdmi_pll_set_t * hdmi_pll_set) {
	unsigned int lock_check = PLL_LOCK_CHECK_MAX;
	do {
		Wr(P_HHI_HDMI_PLL_CNTL0, hdmi_pll_set->pll_cntl0);
		Wr(P_HHI_HDMI_PLL_CNTL1, hdmi_pll_set->pll_cntl1);
		Wr(P_HHI_HDMI_PLL_CNTL2, hdmi_pll_set->pll_cntl2);
		Wr(P_HHI_HDMI_PLL_CNTL3, hdmi_pll_set->pll_cntl3);
		Wr(P_HHI_HDMI_PLL_CNTL4, hdmi_pll_set->pll_cntl4);
		Wr(P_HHI_HDMI_PLL_CNTL5, hdmi_pll_set->pll_cntl5);
		Wr(P_HHI_HDMI_PLL_CNTL6, hdmi_pll_set->pll_cntl6);
		Wr(P_HHI_HDMI_PLL_CNTL0, Rd(P_HHI_HDMI_PLL_CNTL0) | (1<<29));
		Wr(P_HHI_HDMI_PLL_CNTL0, Rd(P_HHI_HDMI_PLL_CNTL0) & (~(1<<29)));
		//printf("lock_check: %d\n", lock_check);
		_udelay(20);
	} while ((!(0x3==((readl(P_HHI_HDMI_PLL_CNTL0)>>30)&0x3))) && --lock_check);
	if (lock_check != 0)
		return 0;
	else
		return RET_PLL_LOCK_FAIL;
}

static int hdmi_pll_test_all(hdmi_pll_cfg_t * hdmi_pll_cfg) {
	unsigned int i=0;
	int ret=0;
	for (i=0; i<(sizeof(hdmi_pll_cfg_t)/sizeof(hdmi_pll_set_t)); i++) {
		ret += hdmi_pll_test(&(hdmi_pll_cfg->hdmi_pll[i]));
	}
	return ret;
}

static int hdmi_pll_test(hdmi_pll_set_t * hdmi_pll_set) {
	unsigned int i=0;
	unsigned int pll_clk = 0;
	unsigned int pll_clk_div = 0;
	unsigned int clk_msr_val = 0;
	unsigned int clk_msr_reg = 0;
	int ret = 0;

#if 0
	/* store current pll cntl */
	hdmi_pll_set_t hdmi_pll;
	hdmi_pll.pll_cntl = readl(P_HHI_HDMI_PLL_CNTL0);
	hdmi_pll.pll_cntl1 = readl(P_HHI_HDMI_PLL_CNTL1);
	hdmi_pll.pll_cntl2 = readl(P_HHI_HDMI_PLL_CNTL2);
	hdmi_pll.pll_cntl3 = readl(P_HHI_HDMI_PLL_CNTL3);
	hdmi_pll.pll_cntl4 = readl(P_HHI_HDMI_PLL_CNTL4);
	hdmi_pll.pll_cntl5 = readl(P_HHI_HDMI_PLL_CNTL5);
#endif

	/* store pll div setting */
	clk_msr_reg = readl(HHI_VID_PLL_CLK_DIV);
	/* connect vid_pll_div to HDMIPLL directly */
	//writel(clk_msr_reg | HDMI_PLL_DIV_CNTL | HDMI_PLL_DIV_GATE, HHI_VID_PLL_CLK_DIV);
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 1<<19);
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 1<<15);

#if 0
	/* div1 */
	setbits_le32(HHI_VID_PLL_CLK_DIV, 1<<18);
#else
	/* div14 */
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 1<<18);
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 0x3<<16);
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 1<<15);
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 0x7fff);
	setbits_le32(HHI_VID_PLL_CLK_DIV, 1<<16);
	setbits_le32(HHI_VID_PLL_CLK_DIV, 1<<15);
	setbits_le32(HHI_VID_PLL_CLK_DIV, 0x3f80);
	clrbits_le32(HHI_VID_PLL_CLK_DIV, 1<<15);
#endif
	setbits_le32(HHI_VID_PLL_CLK_DIV, 1<<19);

	/* test pll */
	for (i=0; i<(sizeof(hdmi_pll_cfg_t)/sizeof(hdmi_pll_set_t)); i++) {
		if (hdmi_pll_set->pll_cntl0 == hdmi_pll_cfg.hdmi_pll[i].pll_cntl0) {
			pll_clk = hdmi_pll_cfg.hdmi_pll[i].pll_clk;
		}
	}
	_udelay(100);
	ret = hdmi_pll_init(hdmi_pll_set);
	_udelay(100);
	if (ret) {
		printf("HDMI pll lock Failed! - %4d MHz\n", pll_clk);
	}
	else {
		pll_clk_div = pll_clk/14;
		printf("HDMI pll lock OK! - %4d MHz. Div14 - %4d MHz. ", pll_clk, pll_clk_div);
		/* get [  55][1485 MHz] vid_pll_div_clk_out */
		clk_msr_val = clk_util_clk_msr(55);
		printf("CLKMSR(55) - %4d MHz ", clk_msr_val);
		if (clk_around(clk_msr_val, pll_clk_div)) {
			printf(": Match\n");
		}
		else {
			ret = RET_CLK_NOT_MATCH;
			printf(": MisMatch\n");
		}
	}

	/* restore pll */
	//hdmi_pll_init(hdmi_pll);
	//hdmi_pll_init(hdmi_pll_cfg->hdmi_pll[0]);

	/* restore div cntl bit */
	writel(clk_msr_reg, HHI_VID_PLL_CLK_DIV);

	return ret;
}

static int gp0_pll_test(gp0_pll_set_t * gp0_pll) {
	int ret=0;
	unsigned int i=0, pll_clk=0;
	unsigned int lock_check = PLL_LOCK_CHECK_MAX;
	unsigned int clk_msr_val = 0, od=0;

	for (i=0; i<(sizeof(gpll0_tbl)/sizeof(gpll0_tbl[0])); i++) {
		if ((gp0_pll->pll_cntl0 & 0xFF) == gpll0_tbl[i].m) {
			pll_clk = gpll0_tbl[i].rate;
			od = gpll0_tbl[i].od;
		}
	}

	writel(gp0_pll->pll_cntl0, HHI_GP0_PLL_CNTL0);
	writel(gp0_pll->pll_cntl1, HHI_GP0_PLL_CNTL1);
	writel(gp0_pll->pll_cntl2, HHI_GP0_PLL_CNTL2);
	writel(gp0_pll->pll_cntl3, HHI_GP0_PLL_CNTL3);
	writel(gp0_pll->pll_cntl4, HHI_GP0_PLL_CNTL4);
	writel(gp0_pll->pll_cntl5, HHI_GP0_PLL_CNTL5);
	writel(gp0_pll->pll_cntl6, HHI_GP0_PLL_CNTL6);
	lock_check = PLL_LOCK_CHECK_MAX;
	do {
		update_bits(HHI_GP0_PLL_CNTL0, 1<<29, 1 << 29);
		_udelay(10);
		update_bits(HHI_GP0_PLL_CNTL0, 1<<29, 0);
		_udelay(100);
		//printf("gp0 lock_check: %4d\n", lock_check);
	} while ((!((readl(HHI_GP0_PLL_CNTL0)>>31)&0x1)) && --lock_check);
	if (0 == lock_check) {
		printf("GP0 pll lock Failed! - %4d MHz\n", pll_clk);
		ret = RET_PLL_LOCK_FAIL;
	}
	else {
		printf("GP0 pll lock OK! - %4d MHz. ", pll_clk);
		/* get gp0_pll_clk */
		clk_msr_val = clk_util_clk_msr(4) << (5-od);
		printf("CLKMSR(4) - %4d MHz ", clk_msr_val);
		if (clk_around(clk_msr_val, pll_clk)) {
			printf(": Match\n");
		}
		else {
			printf(": MisMatch\n");
			ret = RET_CLK_NOT_MATCH;
		}
	}
	return ret;
}

static int gp0_pll_test_all(void) {
	unsigned int i=0;
	unsigned int lock_check = PLL_LOCK_CHECK_MAX;
	unsigned int clk_msr_val = 0;
	int ret=0;

	for (i=0; i<(sizeof(gpll0_tbl)/sizeof(gpll0_tbl[0])); i++) {
		writel(0x380404e9, HHI_GP0_PLL_CNTL0);
		writel(0x00000000, HHI_GP0_PLL_CNTL1);
		writel(0x00000000, HHI_GP0_PLL_CNTL2);
		writel(0x48681c00, HHI_GP0_PLL_CNTL3);
		writel(0x33771290, HHI_GP0_PLL_CNTL4);
		writel(0x39272000, HHI_GP0_PLL_CNTL5);
		writel(0x56540000, HHI_GP0_PLL_CNTL6);
		update_bits(HHI_GP0_PLL_CNTL0, (0x1ff << 0), (gpll0_tbl[i].m)<<0);
		update_bits(HHI_GP0_PLL_CNTL0, (0x1f << 10), (gpll0_tbl[i].n)<<10);
		update_bits(HHI_GP0_PLL_CNTL0, (0x3 << 16), (gpll0_tbl[i].od)<<16);
/* dump paras */
#if 0
		printf("gp0 %d:\n", gpll0_tbl[i].rate);
		printf("HHI_GP0_PLL_CNTL0: 0x%8x\n", readl(HHI_GP0_PLL_CNTL0));
		//printf("HHI_GP0_PLL_CNTL2: 0x%8x\n", readl(HHI_GP0_PLL_CNTL2));
		//printf("HHI_GP0_PLL_CNTL3: 0x%8x\n", readl(HHI_GP0_PLL_CNTL3));
		//printf("HHI_GP0_PLL_CNTL4: 0x%8x\n", readl(HHI_GP0_PLL_CNTL4));
		//printf("HHI_GP0_PLL_CNTL5: 0x%8x\n", readl(HHI_GP0_PLL_CNTL5));
#endif
		lock_check = PLL_LOCK_CHECK_MAX;
		do {
			update_bits(HHI_GP0_PLL_CNTL0, 1<<29, 1 << 29);
			_udelay(10);
			update_bits(HHI_GP0_PLL_CNTL0, 1<<29, 0);
			_udelay(100);
			//printf("gp0 lock_check: %4d\n", lock_check);
		} while ((!((readl(HHI_GP0_PLL_CNTL0)>>31)&0x1)) && --lock_check);
		if (0 == lock_check) {
			printf("GP0 pll lock Failed! - %4d MHz\n", gpll0_tbl[i].rate);
			ret += RET_PLL_LOCK_FAIL;
		}
		else {
			printf("GP0 pll lock OK! - %4d MHz. ", gpll0_tbl[i].rate);
			/* get gp0_pll_clk */
			clk_msr_val = clk_util_clk_msr(4) << (5-gpll0_tbl[i].od);
			printf("CLKMSR(4) - %4d MHz ", clk_msr_val);
			if (clk_around(clk_msr_val, gpll0_tbl[i].rate)) {
				printf(": Match\n");
			}
			else {
				printf(": MisMatch\n");
				ret += RET_CLK_NOT_MATCH;
			}
		}
	}

	return ret;
}

static int pll_test_all(unsigned char * pll_list) {
	int ret = 0;
	unsigned char i=0;
	for (i=0; i<PLL_ENUM; i++) {
		switch (pll_list[i]) {
			case PLL_SYS:
				ret = sys_pll_test_all(&sys_pll_cfg);
				pll_report(ret, STR_PLL_TEST_SYS);
				break;
			case PLL_FIX:
				ret = fix_pll_test();
				pll_report(ret, STR_PLL_TEST_FIX);
				break;
			case PLL_DDR:
				ret = ddr_pll_test();
				pll_report(ret, STR_PLL_TEST_DDR);
				break;
			case PLL_HDMI:
				ret = hdmi_pll_test_all(&hdmi_pll_cfg);
				pll_report(ret, STR_PLL_TEST_HDMI);
				break;
			case PLL_GP0:
				ret = gp0_pll_test_all();
				pll_report(ret, STR_PLL_TEST_GP0);
				break;
			default:
				break;
		}
	}
	return ret;
}

int pll_test(int argc, char * const argv[])
{
	int ret = 0;

	sys_pll_set_t sys_pll_set = {0};
	hdmi_pll_set_t hdmi_pll_set = {0};
	gp0_pll_set_t gp0_pll_set = {0};

	unsigned char plls[PLL_ENUM] = {
		PLL_SYS,
		0xff,//	PLL_FIX, //0xff will skip this pll
		0xff,//	PLL_DDR,
		PLL_HDMI,
		PLL_GP0,
	};

	if (0 == strcmp(STR_PLL_TEST_ALL, argv[1])) {
		printf("Test all plls\n");
		pll_test_all(plls);
	}
	else if(0 == strcmp(STR_PLL_TEST_SYS, argv[1])) {
		if (argc == 2) {
			ret = sys_pll_test_all(&sys_pll_cfg);
			pll_report(ret, STR_PLL_TEST_SYS);
		}
		else if (argc != 9){
			printf("%s pll test: args error\n", STR_PLL_TEST_SYS);
			return -1;
		}
		else {
			sys_pll_set.pll_cntl = simple_strtoul(argv[2], NULL, 16);
			sys_pll_set.pll_cntl1 = simple_strtoul(argv[3], NULL, 16);
			sys_pll_set.pll_cntl2 = simple_strtoul(argv[4], NULL, 16);
			sys_pll_set.pll_cntl3 = simple_strtoul(argv[5], NULL, 16);
			sys_pll_set.pll_cntl4 = simple_strtoul(argv[6], NULL, 16);
			sys_pll_set.pll_cntl5 = simple_strtoul(argv[7], NULL, 16);
			ret = sys_pll_test(&sys_pll_set);
			pll_report(ret, STR_PLL_TEST_SYS);
		}
	}
	else if (0 == strcmp(STR_PLL_TEST_HDMI, argv[1])) {
		if (argc == 2) {
			ret = hdmi_pll_test_all(&hdmi_pll_cfg);
			pll_report(ret, STR_PLL_TEST_HDMI);
		}
		else if (argc != 9){
			printf("%s pll test: args error\n", STR_PLL_TEST_HDMI);
			return -1;
		}
		else {
			hdmi_pll_set.pll_cntl0 = simple_strtoul(argv[2], NULL, 16);
			hdmi_pll_set.pll_cntl1 = simple_strtoul(argv[3], NULL, 16);
			hdmi_pll_set.pll_cntl2 = simple_strtoul(argv[4], NULL, 16);
			hdmi_pll_set.pll_cntl3 = simple_strtoul(argv[5], NULL, 16);
			hdmi_pll_set.pll_cntl4 = simple_strtoul(argv[6], NULL, 16);
			hdmi_pll_set.pll_cntl5 = simple_strtoul(argv[7], NULL, 16);
			hdmi_pll_set.pll_cntl6 = simple_strtoul(argv[8], NULL, 16);
			ret = hdmi_pll_test(&hdmi_pll_set);
			pll_report(ret, STR_PLL_TEST_HDMI);
		}
	}
	else if (0 == strcmp(STR_PLL_TEST_GP0, argv[1])) {
		if (argc == 2) {
			ret = gp0_pll_test_all();
			pll_report(ret, STR_PLL_TEST_GP0);
		}
		else if (argc != 9){
			printf("%s pll test: args error\n", STR_PLL_TEST_GP0);
			return -1;
		}
		else {
			gp0_pll_set.pll_cntl0 = simple_strtoul(argv[2], NULL, 16);
			gp0_pll_set.pll_cntl1 = simple_strtoul(argv[3], NULL, 16);
			gp0_pll_set.pll_cntl2 = simple_strtoul(argv[4], NULL, 16);
			gp0_pll_set.pll_cntl3 = simple_strtoul(argv[5], NULL, 16);
			gp0_pll_set.pll_cntl4 = simple_strtoul(argv[6], NULL, 16);
			gp0_pll_set.pll_cntl5 = simple_strtoul(argv[7], NULL, 16);
			gp0_pll_set.pll_cntl6 = simple_strtoul(argv[8], NULL, 16);
			ret = gp0_pll_test(&gp0_pll_set);
			pll_report(ret, STR_PLL_TEST_GP0);
		}
	}
	else if (0 == strcmp(STR_PLL_TEST_DDR, argv[1])) {
		printf("%s pll not support now\n", STR_PLL_TEST_DDR);
		return -1;
	}
	else if (0 == strcmp(STR_PLL_TEST_FIX, argv[1])) {
		printf("%s pll not support now\n", STR_PLL_TEST_FIX);
		return -1;
	}

#if 0
	unsigned char * pll_list = NULL;
	switch (get_cpu_id().family_id) {
		case MESON_CPU_MAJOR_ID_GXTVBB:
			pll_list = gxtvbb_plls;
			break;
		case MESON_CPU_MAJOR_ID_GXL:
			pll_list = gxl_plls;
			break;
		default:
			printf("un-support chip\n");
			break;
	}
	if (pll_list) {
		return plltest(pll_list);
	}
#endif

	return 0;
}
