#ifndef __VPU_PARA_H__
#define __VPU_PARA_H__

enum VPU_Chip_e {
	VPU_CHIP_M8 = 0,
	VPU_CHIP_M8B,
	VPU_CHIP_M8M2,
	VPU_CHIP_G9TV,
	VPU_CHIP_G9BB,
	VPU_CHIP_GXBB,
	VPU_CHIP_MAX,
};

static char *vpu_chip_name[] = {
	"m8",
	"m8baby",
	"m8m2",
	"g9tv",
	"g9baby",
	"gxbaby",
	"invalid",
};

struct VPU_Conf_t {
	enum VPU_Chip_e  chip_type;
	unsigned int     clk_level_dft;
	unsigned int     clk_level_max;
	unsigned int     clk_level;
	unsigned int     fclk_type;
};

/* #define LIMIT_VPU_CLK_LOW */

/* ************************************************ */
/* VPU frequency table, important. DO NOT modify!! */
/* ************************************************ */
/* fixed pll frequency */
enum fclk_type_e {
	FCLK_2550M = 0,
	FCLK_2000M,
	FCLK_MAX,
};
static unsigned int fclk_table[] = { /* unit: MHz */
	2550,
	2000,
};

/* M8: */
/* freq Max=364M, default=255M */
#define CLK_LEVEL_DFT_M8       3
#define CLK_LEVEL_MAX_M8       5
#define FCLK_TYPE_M8           FCLK_2550M
/* M8M2: */
/* freq Max=364M, default=255M */
#define CLK_LEVEL_DFT_M8M2     3
#define CLK_LEVEL_MAX_M8M2     5
#define FCLK_TYPE_M8M2         FCLK_2550M
/* M8baby */
/* freq max=212MHz, default=212MHz. */
#define CLK_LEVEL_DFT_M8B      2
#define CLK_LEVEL_MAX_M8B      3
#define FCLK_TYPE_M8B          FCLK_2550M
/* G9TV */
/* freq max=696M, default=637M */
#define CLK_LEVEL_DFT_G9TV     7
#define CLK_LEVEL_MAX_G9TV     9
#define FCLK_TYPE_G9TV         FCLK_2550M
/* G9BB */
/* freq max=212M, default=212M */
#define CLK_LEVEL_DFT_G9BB     2
#define CLK_LEVEL_MAX_G9BB     3
#define FCLK_TYPE_G9BB         FCLK_2550M
/* GXBB */
/* freq max=200M, default=200M */
#define CLK_LEVEL_DFT_GXBB     2
#define CLK_LEVEL_MAX_GXBB     3
#define FCLK_TYPE_GXBB         FCLK_2000M

/* vpu clk setting */
enum VPU_mux_e {
	FCLK_DIV4 = 0,
	FCLK_DIV3,
	FCLK_DIV5,
	FCLK_DIV7,
	MPLL_CLK1,
	VID_PLL_CLK,
	VID2_PLL_CLK,
	GPLL_CLK,
};

static unsigned int fclk_div_table[] = {
	4, /* mux 0 */
	3, /* mux 1 */
	5, /* mux 2 */
	7, /* mux 3 */
	2, /* invalid */
};

static unsigned int vpu_clk_table[2][12][3] = {/* compatible for all chip */
	{ /* m8, m8m2, g9tv, g9bb, fpll=2550M */
		/* frequency   clk_mux       div */
		{106250000,    FCLK_DIV3,    7}, /* 0 */
		{159375000,    FCLK_DIV4,    3}, /* 1 */
		{212500000,    FCLK_DIV3,    3}, /* 2 */
		{255000000,    FCLK_DIV5,    1}, /* 3 */
		{364300000,    FCLK_DIV7,    0}, /* 4 */ /* M8M2 use gp_pll */
		{425000000,    FCLK_DIV3,    1}, /* 5 */
		{510000000,    FCLK_DIV5,    0}, /* 6 */
		{637500000,    FCLK_DIV4,    0}, /* 7 */
		{696000000,    GPLL_CLK,     0}, /* 8 */ /* G9TV use gp1_pll */
		{850000000,    FCLK_DIV3,    0}, /* 9 */
	},
	{ /* gxbb, fpll=2000M */
		/* frequency   clk_mux       div */
		{100000000,    FCLK_DIV5,    3}, /* 0 */
		{166667000,    FCLK_DIV3,    3}, /* 1 */
		{200000000,    FCLK_DIV5,    1}, /* 2 */
		{250000000,    FCLK_DIV4,    1}, /* 3 */
		{333333000,    FCLK_DIV3,    1}, /* 4 */
		{400000000,    FCLK_DIV5,    0}, /* 5 */
		{500000000,    FCLK_DIV4,    0}, /* 6 */
		{666667000,    FCLK_DIV3,    0}, /* 7 */
		{696000000,    GPLL_CLK,     0}, /* 8 */ /* invalid */
		{850000000,    GPLL_CLK,     0}, /* 9 */ /* invalid */
	},
};

/* ************************************************ */
/* extern function */
/* ************************************************ */
extern void udelay(unsigned long usec);
extern int printf(const char *fmt, ...);
/* ************************************************ */

#endif
