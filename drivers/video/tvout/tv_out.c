
#include <common.h>

#define __typesafe_io
#include <asm/arch/io.h>

#include <amlogic/aml_tv.h>
#include <asm/arch/tvregs.h>
#include "tv_out.h"

static int tvmode = -1;
static int used_audio_pll=-1;
unsigned int system_serial_low=0xA;

static unsigned long get_xtal_clock(void)
{
	unsigned long clk;
	
	clk=READ_CBUS_REG_BITS(PREG_CTLREG0_ADDR,4,5);
	clk=clk*1000*1000;
	return clk;
}
typedef  enum{
	INTERALCE_COMPONENT=0,
	CVBS_SVIDEO,
	PROGRESSIVE,
	SIGNAL_SET_MAX
}video_signal_set_t;
typedef enum {
    VIDEO_SIGNAL_TYPE_INTERLACE_Y = 0, /**< Interlace Y signal */
    VIDEO_SIGNAL_TYPE_CVBS,            /**< CVBS signal */
    VIDEO_SIGNAL_TYPE_SVIDEO_LUMA,     /**< S-Video luma signal */
    VIDEO_SIGNAL_TYPE_SVIDEO_CHROMA,   /**< S-Video chroma signal */
    VIDEO_SIGNAL_TYPE_INTERLACE_PB,    /**< Interlace Pb signal */
    VIDEO_SIGNAL_TYPE_INTERLACE_PR,    /**< Interlace Pr signal */
    VIDEO_SIGNAL_TYPE_INTERLACE_R,     /**< Interlace R signal */
    VIDEO_SIGNAL_TYPE_INTERLACE_G,     /**< Interlace G signal */
    VIDEO_SIGNAL_TYPE_INTERLACE_B,     /**< Interlace B signal */
    VIDEO_SIGNAL_TYPE_PROGRESSIVE_Y,   /**< Progressive Y signal */
    VIDEO_SIGNAL_TYPE_PROGRESSIVE_PB,  /**< Progressive Pb signal */
    VIDEO_SIGNAL_TYPE_PROGRESSIVE_PR,  /**< Progressive Pr signal */
    VIDEO_SIGNAL_TYPE_PROGEESSIVE_R,   /**< Progressive R signal */
    VIDEO_SIGNAL_TYPE_PROGEESSIVE_G,   /**< Progressive G signal */
    VIDEO_SIGNAL_TYPE_PROGEESSIVE_B,   /**< Progressive B signal */
    VIDEO_SIGNAL_TYPE_MAX
} video_signal_type_t;


#define  SET_VDAC(index,val)   (WRITE_MPEG_REG((index+VENC_VDAC_DACSEL0),val))
static const unsigned int  signal_set[SIGNAL_SET_MAX][3]=
{
	{	VIDEO_SIGNAL_TYPE_INTERLACE_Y,     // component interlace
		VIDEO_SIGNAL_TYPE_INTERLACE_PB,
		VIDEO_SIGNAL_TYPE_INTERLACE_PR,
	},
	{
		VIDEO_SIGNAL_TYPE_CVBS,            	//cvbs&svideo
		VIDEO_SIGNAL_TYPE_SVIDEO_LUMA,    
    	VIDEO_SIGNAL_TYPE_SVIDEO_CHROMA,   
	},
	{	VIDEO_SIGNAL_TYPE_PROGRESSIVE_Y,     //progressive.
		VIDEO_SIGNAL_TYPE_PROGRESSIVE_PB,
		VIDEO_SIGNAL_TYPE_PROGRESSIVE_PR,
	},
};
static  const  char*   signal_table[]={
	"INTERLACE_Y ", /**< Interlace Y signal */
    	"CVBS",            /**< CVBS signal */
    	"SVIDEO_LUMA",     /**< S-Video luma signal */
    	"SVIDEO_CHROMA",   /**< S-Video chroma signal */
    	"INTERLACE_PB",    /**< Interlace Pb signal */
    	"INTERLACE_PR",    /**< Interlace Pr signal */
    	"INTERLACE_R",     /**< Interlace R signal */
         "INTERLACE_G",     /**< Interlace G signal */
         "INTERLACE_B",     /**< Interlace B signal */
         "PROGRESSIVE_Y",   /**< Progressive Y signal */
         "PROGRESSIVE_PB",  /**< Progressive Pb signal */
         "PROGRESSIVE_PR",  /**< Progressive Pr signal */
         "PROGEESSIVE_R",   /**< Progressive R signal */
         "PROGEESSIVE_G",   /**< Progressive G signal */
         "PROGEESSIVE_B",   /**< Progressive B signal */
		
	};
//120120
void  change_vdac_setting(unsigned int  vdec_setting,int  mode)
{
	unsigned  int  signal_set_index=0;
	unsigned int  idx=0,bit=5,i;
	switch(mode )
	{
		case TVOUT_480I:
		case TVOUT_576I:
		signal_set_index=0;
		bit=5;
		break;
		//case TVOUT_480CVBS:
		//case TVOUT_576CVBS:
		//signal_set_index=1;	
		//bit=2;
		//break;
		default :
		signal_set_index=2;
		bit=5;
		break;
	}
	for(i=0;i<3;i++)
	{
		idx=vdec_setting>>(bit<<2)&0xf;
		printf("dac index:%d ,signal:%s\n",idx,signal_table[signal_set[signal_set_index][i]]);
		SET_VDAC(idx,signal_set[signal_set_index][i]);
		bit--;
	}
	
}

static void enable_vsync_interrupt(void)
{
	
	if(used_audio_pll)
	{
		/* M1 chip test only, use audio PLL as video clock source */
		SET_CBUS_REG_MASK(HHI_MPEG_CLK_CNTL, 1<<11);
	}
	else
	{
	      /* M1 REVB , Video PLL bug fixed */
	        CLEAR_CBUS_REG_MASK(HHI_MPEG_CLK_CNTL, 1<<11);
	}
	
    if (READ_MPEG_REG(ENCP_VIDEO_EN) & 1) {
        WRITE_MPEG_REG(VENC_INTCTRL, 0x200);

        while ((READ_MPEG_REG(VENC_INTFLAG) & 0x200) == 0) {
            u32 line1, line2;

            line1 = line2 = READ_MPEG_REG(VENC_ENCP_LINE);

            while (line1 >= line2) {
                line2 = line1;
                line1 = READ_MPEG_REG(VENC_ENCP_LINE);
            }

            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            if (READ_MPEG_REG(VENC_INTFLAG) & 0x200) {
                break;
            }

            WRITE_MPEG_REG(ENCP_VIDEO_EN, 0);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);

            WRITE_MPEG_REG(ENCP_VIDEO_EN, 1);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
            READ_MPEG_REG(VENC_INTFLAG);
        }
    }
    else{
        WRITE_MPEG_REG(VENC_INTCTRL, 0x2);
    }
}

#if CONFIG_AML_MESON_8
static unsigned int vdac_cfg_valid = 0, vdac_cfg_value = 0;
static unsigned int cvbs_get_trimming_version(unsigned int flag)
{
	unsigned int version = 0xff;
	
	if( (flag&0xf0) == 0xa0 )
		version = 5;
	else if( (flag&0xf0) == 0x40 )
		version = 2;
	else if( (flag&0xc0) == 0x80 )
		version = 1;
	else if( (flag&0xc0) == 0x00 )
		version = 0;

	return version;
}

void cvbs_config_vdac(unsigned int flag, unsigned int cfg)
{
	unsigned char version = 0;
	
	vdac_cfg_value = cfg&0x7;

	version = cvbs_get_trimming_version(flag);

	// flag 1/0 for validity of vdac config
	if( (version==1) || (version==2) || (version==5) )
		vdac_cfg_valid = 1;
	else
		vdac_cfg_valid = 0;

	printf("cvbs trimming.%d.v%d: 0x%x, 0x%x\n", vdac_cfg_valid, version, flag, cfg);

	return ;

}
static void cvbs_cntl_output(unsigned int open)
{
	unsigned int cntl0=0, cntl1=0;
	
	if( open == 0 )// close
	{
		cntl0 = 0;
		cntl1 = 8;

		WRITE_MPEG_REG(HHI_VDAC_CNTL0, cntl0);
		WRITE_MPEG_REG(HHI_VDAC_CNTL1, cntl1);
	}
	else if( open == 1 )// open
	{
		cntl0 = 0x1;
		cntl1 = (vdac_cfg_valid==0)?0:vdac_cfg_value;

		printf("vdac open.%d = 0x%x, 0x%x\n", vdac_cfg_valid, cntl0, cntl1);

		WRITE_MPEG_REG(HHI_VDAC_CNTL1, cntl1);
		WRITE_MPEG_REG(HHI_VDAC_CNTL0, cntl0);
	}

	return ;
}

#if CONFIG_EFUSE
extern int efuse_read_intlItem(char *intl_item,char *buf,int size);

void cvbs_trimming(void)
{
	char cvbs_buf[2] = {0,0}, cvbs_value[8];
	int ret;
	int fake;

	ret = efuse_read_intlItem("cvbs_trimming", cvbs_buf, 2);

	cvbs_config_vdac(cvbs_buf[1], cvbs_buf[0]);

	sprintf(cvbs_value, "0x%x", (cvbs_buf[1]<<8)|cvbs_buf[0] );
	setenv("vdac_config",cvbs_value);

	return ;
}
#endif

#endif

#ifdef CONFIG_AML_MESON_6

enum aml_vdac_switch_type {
	VOUT_CVBS,
	VOUT_COMPONENT,
	VOUT_VGA,
	VOUT_MAX
};

static void vdac_hw_switch(unsigned type)
{
	// the control logic is based on the g18 board.
	switch( type )
	{
		case VOUT_CVBS:
			// set YPBR_EN# to high
			if((aml_read_reg32(P_PREG_PAD_GPIO2_O) & (1<<2)) == 0)
				aml_set_reg32_mask(P_PREG_PAD_GPIO2_O,(1<<2));

			// set CVBS_EN# to high
			if((aml_read_reg32(P_PREG_PAD_GPIO2_O) & (1<<3)) == 0)
				aml_set_reg32_mask(P_PREG_PAD_GPIO2_O,(1<<3));

			break;
		case VOUT_COMPONENT:
			// set YPBR_EN# to low
			if((aml_read_reg32(P_PREG_PAD_GPIO2_O) & (1<<2)) != 0)
			    aml_clr_reg32_mask(P_PREG_PAD_GPIO2_O,(1<<2));

			// set CVBS_EN# to low
			if((aml_read_reg32(P_PREG_PAD_GPIO2_O) & (1<<3)) != 0)
			    aml_clr_reg32_mask(P_PREG_PAD_GPIO2_O,(1<<3));

			break;
		case VOUT_VGA:
			// set YPBR_EN# to high
			if((aml_read_reg32(P_PREG_PAD_GPIO2_O) & (1<<2)) == 0)
				aml_set_reg32_mask(P_PREG_PAD_GPIO2_O,(1<<2));

			// set CVBS_EN# to low
			if((aml_read_reg32(P_PREG_PAD_GPIO2_O) & (1<<3)) != 0)
			    aml_clr_reg32_mask(P_PREG_PAD_GPIO2_O,(1<<3));

			break;
		default:
			break;
	}

    aml_clr_reg32_mask(P_PREG_PAD_GPIO2_EN_N,(1<<2));//GPIOC2
    aml_clr_reg32_mask(P_PREG_PAD_GPIO2_EN_N,(1<<3));//GPIOC3

	return ;
}

static void m6_enable_vdac_hw_switch(int mode)
{
	char *str;
	int switch_mode = 0;

	if( (mode!=VMODE_480CVBS) && (mode!=VMODE_576CVBS) )
		return ;

	str = strdup(getenv("vdacswitchmode"));
	if( !strcmp(str, "cvbs") )
		switch_mode = VOUT_CVBS;
	else if( !strcmp(str, "component") )
		switch_mode = VOUT_COMPONENT;
	else if( !strcmp(str, "vga") )
		switch_mode = VOUT_VGA;

	vdac_hw_switch(switch_mode);

	return ;
}

#endif // end of CONFIG_AML_MESON_6

#ifdef CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT
void cvbs_performance_config(void)
{
	int actived = CONFIG_CVBS_PERFORMANCE_ACTIVED;
	char buf[8];

	sprintf(buf, "%d", actived);
	setenv("cvbs_drv", buf);

	return ;
}

static const reg_t tvregs_576cvbs_china_sarft[] =
{
	{MREG_END_MARKER,            	0      }
};

static const reg_t tvregs_576cvbs_china_telecom[] =
{
	{P_ENCI_SYNC_ADJ,				0x8060	},
    {P_ENCI_VIDEO_SAT,              0xfe	},
    {P_VENC_VDAC_DAC0_FILT_CTRL1,   0xf850	},
	{MREG_END_MARKER,            	0		}
};

static const reg_t tvregs_576cvbs_china_mobile[] =
{
	{P_ENCI_SYNC_ADJ,				0x8060	},
    {P_ENCI_VIDEO_SAT,              0xfe	},
    {P_VENC_VDAC_DAC0_FILT_CTRL1,   0xf850	},
	{MREG_END_MARKER,            	0       }
};

static const reg_t *tvregs_576cvbs_performance[] =
{
	tvregs_576cvbs_china_sarft,
	tvregs_576cvbs_china_telecom,
	tvregs_576cvbs_china_mobile
};

static void cvbs_performance_enhancement(int mode)
{
	const reg_t *s;
	unsigned int index = CONFIG_CVBS_PERFORMANCE_ACTIVED;
	unsigned int max = sizeof(tvregs_576cvbs_performance)/sizeof(reg_t*);

	if( VMODE_576CVBS != mode )
		return ;

	index = (index>=max)?0:index;
	printf("cvbs performance use table = %d\n", index);
	s = tvregs_576cvbs_performance[index];
	while (MREG_END_MARKER != s->reg)
	{
    	setreg(s++);
	}
	return ;
}

#endif // end of CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT

int tv_out_open(int mode)
{
#if CONFIG_AML_HDMI_TX
    extern void set_disp_mode(int);
#endif
    const  reg_t *s;

    if (TVOUT_VALID(mode))
    {
        tvmode = mode;

#if CONFIG_AML_MESON_6
		m6_enable_vdac_hw_switch(mode);
#endif

#if CONFIG_AML_MESON_8
		cvbs_cntl_output(0);
#endif

        s = tvregsTab[mode];
        while (MREG_END_MARKER != s->reg)
            setreg(s++);

#ifdef CONFIG_CVBS_PERFORMANCE_COMPATIBILITY_SUPPORT
		cvbs_performance_enhancement(mode);
#endif

#if CONFIG_AML_MESON_8
		if( (mode==VMODE_480CVBS) || (mode==VMODE_576CVBS) )
		{
			WRITE_MPEG_REG(HHI_GCLK_OTHER, READ_MPEG_REG(HHI_GCLK_OTHER) | (0x1<<10) | (0x1<<8)); //enable CVBS GATE, DAC_CLK:bit[10] = 1;VCLK2_ENCI:bit[8] = 1;
			cvbs_cntl_output(1);
		}
#endif

//	tvoutc_setclk(mode);
//	enable_vsync_interrupt();
#if CONFIG_AML_MESON_6
        WRITE_MPEG_REG(VPP_POSTBLEND_H_SIZE, tvinfoTab[mode].xres);
#endif
#if CONFIG_AML_MESON_8
        __raw_writel(tvinfoTab[mode].xres, P_VPP_POSTBLEND_H_SIZE);
#endif
#if CONFIG_AML_HDMI_TX
    if( (mode==VMODE_480CVBS) || (mode==VMODE_576CVBS) )
    {
        extern void set_vmode_clk(vmode_t mode);
        set_vmode_clk(mode);
    }
    else
	   set_disp_mode(mode);
#endif
        return 0;
    }

    return -1;
}

int tv_out_close(void)
{

    if (TVOUT_VALID(tvmode))
    {
        /* VENC_VDAC_SETTING */
        WRITE_MPEG_REG(VENC_VDAC_SETTING, 0xff);

        return 0;
    }

    return -1;
}

int tv_out_cur_mode(void)
{
    return tvmode;
}

int tv_out_get_info(int mode, unsigned *width, unsigned *height)
{
    if (TVOUT_VALID(mode))
    {
        *width = tvinfoTab[mode].xres;
        *height = tvinfoTab[mode].yres;

        return 0;
    }

    return -1;
}

enum tv_test_mode{
	TV_TST_DISABLE,
	TV_TST_FIX,
	TV_TST_COLORBAR,
	TV_TST_THINLINE,
	TV_TST_DOTGRID,
	TV_TST_MAX
};

#define TVTST_VALID(x) ((x)>=0 && (x)<TV_TST_MAX)
static const  reg_t tvregs_dis_tst[]={
	{VENC_VIDEO_TST_EN,	                                0},
	{MREG_END_MARKER,                                   0}
};
static const  reg_t tvregs_fix[]={
	{VENC_VIDEO_TST_MDSEL,                          0},
	{VENC_VIDEO_TST_Y,                              512},
	{VENC_VIDEO_TST_CR,                            512},
	{VENC_VIDEO_TST_CB,                            512},
	{VENC_VIDEO_TST_EN,	                                1},
	{MREG_END_MARKER,                                   0}
};
static const  reg_t tvregs_colorbar[]={
	{VENC_VIDEO_TST_MDSEL,                          1},
	{VENC_VIDEO_TST_CLRBAR_STRT,             74},
	{VENC_VIDEO_TST_CLRBAR_WIDTH,         180},
	{VENC_VIDEO_TST_EN,	                                1},
	{MREG_END_MARKER,                                   0}
};
static const  reg_t tvregs_thinline[]={
	{VENC_VIDEO_TST_MDSEL,                          2},
	{VENC_VIDEO_TST_Y,                              512},
	{VENC_VIDEO_TST_CR,                            512},
	{VENC_VIDEO_TST_CB,                            512},
	{VENC_VIDEO_TST_EN,	                                1},
	{MREG_END_MARKER,                                   0}
};
static const  reg_t tvregs_dotgrid[]={
	{VENC_VIDEO_TST_MDSEL,                          3},
	{VENC_VIDEO_TST_Y,                              512},
	{VENC_VIDEO_TST_CR,                            512},
	{VENC_VIDEO_TST_CB,                            512},
	{VENC_VIDEO_TST_EN,	                                1},
	{MREG_END_MARKER,                                   0}
};

static const reg_t *tvregsTab_tst[] = {
    tvregs_dis_tst,
    tvregs_fix,
    tvregs_colorbar,
    tvregs_thinline,
    tvregs_dotgrid
};

int tv_out_test(int mode)
{
    const  reg_t *s;

    if (TVTST_VALID(mode))
    {
	s = tvregsTab_tst[mode];

        while (MREG_END_MARKER != s->reg)
            setreg(s++);

        return 0;
    }

    return -1;
}

