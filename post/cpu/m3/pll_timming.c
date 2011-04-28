#include <asm/arch/clock.h>
#include <post.h>
#include "pll.h"

#if CONFIG_POST & CONFIG_SYS_POST_PLL

extern int test_sys_pll(void);
extern int test_other_pll(void);
extern int test_audio_pll(void);
extern int test_video_pll(void);
extern int test_viid_pll(void);

extern void set_sys_pll(unsigned n, unsigned m, unsigned od, unsigned xd);
extern void set_other_pll(unsigned n, unsigned m, unsigned od, unsigned xd);
extern void set_audio_pll(unsigned n, unsigned m, unsigned od, unsigned xd);
extern void set_video_pll(unsigned n, unsigned m, unsigned od, unsigned xd);
extern void set_viid_pll(unsigned n, unsigned m, unsigned od, unsigned xd);

// sys pll  unit: MHz
struct clk clk_sys_pll = {
	.middle	=	1000, 
	.N_range = {
		.min = 1,
		.max = 31,
	},
	.M_range = {
		.min = 2,
		.max = 511,
	},
	.OD_range = {
		.min = 0,
		.max = 2,
	},
	.XD_range = {
		.min = 1,
		.max = 1,
	},
	.Fref = {
		.min = 5,
		.max = 30,
	},
	.Fvco = {
		.min = 650,
		.max = 1300,
	},
	.pll_set = set_sys_pll,
};

// other pll  unit: MHz
struct clk clk_other_pll = {
	.middle	=	600, 
	.N_range = {
		.min = 1,
		.max = 31,
	},
	.M_range = {
		.min = 2,
		.max = 511,		
	},
	.OD_range = {
		.min = 0,
		.max = 1,
	},
	.XD_range = {
		.min = 1,
		.max = 1,
	},
	.Fref = {
		.min = 3,
		.max = 30,
	},
	.Fvco = {
		.min = 400,
		.max = 800,
	},
	.pll_set = set_other_pll,
};


// audio pll  unit: MHz
struct clk clk_audio_pll = {
	.middle  =	600, 
	.N_range = {
		.min = 1,
		.max = 31,
	},
	.M_range = {
		.min = 2,
		.max = 511,
	},
	.OD_range = {
		.min = 0,
		.max = 1,
	},
	.XD_range = {
		.min = 1,
		.max = 1,
	},
	.Fref = {
		.min = 3,
		.max = 30,
	},
	.Fvco = {
		.min = 400,
		.max = 800,
	},
	.pll_set = set_audio_pll,
};

// video pll  unit: MHz
struct clk clk_video_pll = {
	.middle  =	1000, 
	.N_range = {
		.min = 1,
		.max = 31,
	},
	.M_range = {
		.min = 2,
		.max = 1023,
	},
	.OD_range = {
		.min = 0,
		.max = 2,
	},
	.XD_range = {
		.min = 1,
		.max = 1,
	},
	.Fref = {
		.min = 5,
		.max = 30,
	},
	.Fvco = {
		.min = 750,
		.max = 1500,
	},
	.pll_set = set_video_pll,
};

// viid pll  unit: MHz
struct clk clk_viid_pll = {
	.middle  =	1000, 
	.N_range = {
		.min = 1,
		.max = 31,
	},
	.M_range = {
		.min = 2,
		.max = 511,
	},
	.OD_range = {
		.min = 0,
		.max = 2,
	},
	.XD_range = {
		.min = 1,
		.max = 1,
	},
	.Fref = {
		.min = 5,
		.max = 30,
	},
	.Fvco = {
		.min = 650,
		.max = 1300,
	},
	.pll_set = set_viid_pll,
};

struct clk_lookup lookups[] = {
   {
        .dev_id = "sys",
        .pclk    = &clk_sys_pll,
	   .pll_test = test_sys_pll,
    },	
    {
    		.dev_id = "other",
    		.pclk = &clk_other_pll,
    		.pll_test = test_other_pll,
    },
  	{
    		.dev_id = "audio",
    		.pclk = &clk_audio_pll,
    		.pll_test = test_audio_pll,
    	},
    	{
    		.dev_id = "viid",
    		.pclk = &clk_viid_pll,
    		.pll_test = test_viid_pll,
    	},
    	/*{
    		.dev_id = "video",
    		.pclk = &clk_video_pll,
    		.pll_test = test_video_pll,
    	},
    	*/
};

unsigned int clk_lookups_size = sizeof(lookups) / sizeof(struct clk_lookup);

 #endif /*CONFIG_POST*/