/*
 * AMLOGIC T13 LCD panel driver.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 * Author:  Elvis Yu <elvis.yu@amlogic.com>
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/gpio.h>
//#include <asm/arch/lcdoutc.h>
#include <asm/arch/osd.h>
#include <asm/arch/osd_hw.h>
#include <aml_i2c.h>
//#include <amlogic/aml_lcd.h>
#include <sn7325.h>
#include <video_fb.h>
#include <amlogic/aml_tv.h>
#include <amlogic/vinfo.h>

#ifdef CONFIG_AW_AXP20
#include <axp-gpio.h>
#endif

#define DEBUG

extern GraphicDevice aml_gdev;
vidinfo_t tv_info;

#define H_ACTIVE		800
#define V_ACTIVE		1280 
#define H_PERIOD		960 
#define V_PERIOD		1320 
#define VIDEO_ON_PIXEL  80
#define VIDEO_ON_LINE   32

int  video_dac_enable(unsigned char enable_mask)
{
//	debug("%s\n", __FUNCTION__);
	CLEAR_CBUS_REG_MASK(VENC_VDAC_SETTING, enable_mask&0x1f);
	return 0;
}

int  video_dac_disable(void)
{
//	debug("%s\n", __FUNCTION__);
	SET_CBUS_REG_MASK(VENC_VDAC_SETTING, 0x1f);
    return 0;    
}   

//\\temp
//static void tv_sync_duration(Lcd_Config_t *pConf)
//{
//	unsigned m, n, od, div, xd;
//	unsigned pre_div;
//	unsigned sync_duration;
//	
//	m = ((pConf->lcd_timing.pll_ctrl) >> 0) & 0x1ff;
//	n = ((pConf->lcd_timing.pll_ctrl) >> 9) & 0x1f;
//	od = ((pConf->lcd_timing.pll_ctrl) >> 16) & 0x3;
//	div = ((pConf->lcd_timing.div_ctrl) >> 4) & 0x7;
//	xd = ((pConf->lcd_timing.clk_ctrl) >> 0) & 0xf;
//	
//	od = (od == 0) ? 1:((od == 1) ? 2:4);
//	switch(pConf->lcd_basic.lcd_type)
//	{
//		case LCD_DIGITAL_TTL:
//			pre_div = 1;
//			break;
//		case LCD_DIGITAL_LVDS:
//			pre_div = 7;
//			break;
//		default:
//			pre_div = 1;
//			break;
//	}
//	
//	sync_duration = m*24*100/(n*od*(div+1)*xd*pre_div);	
//	sync_duration = ((sync_duration * 100000 / H_PERIOD) * 10) / V_PERIOD;
//	sync_duration = (sync_duration + 5) / 10;	
//	
//	pConf->lcd_timing.sync_duration_num = sync_duration;
//	pConf->lcd_timing.sync_duration_den = 10;
//}

static void tv_power_on(void)
{
//	debug("%s\n", __FUNCTION__);
	video_dac_disable();    
    //power_on_lcd();      
}
static void tv_power_off(void)
{
//	debug("%s\n", __FUNCTION__);
    //power_off_lcd();
}

static int tv_enable(void)
{
//	debug("%s\n", __FUNCTION__);

	tv_info.vd_base = simple_strtoul(getenv("fb_addr"), NULL, NULL);
	tv_info.vl_col = simple_strtoul(getenv("display_width"), NULL, NULL);
	tv_info.vl_row = simple_strtoul(getenv("display_height"), NULL, NULL);
	tv_info.vl_bpix = simple_strtoul(getenv("display_bpp"), NULL, 10);
	tv_info.vd_color_fg = simple_strtoul(getenv("display_color_fg"), NULL, NULL);
	tv_info.vd_color_bg = simple_strtoul(getenv("display_color_bg"), NULL, NULL);
	
//\\temp
//	tv_sync_duration(&lcd_config);
	
    return 0;
}

void tv_disable(void)
{
//	debug("%s\n", __FUNCTION__);
    //power_off_lcd();
}

vidinfo_t tv_info = 
{
	.vl_col	=	0,		/* Number of columns (i.e. 160) */
	.vl_row	=	0,		/* Number of rows (i.e. 100) */

	.vl_bpix	=	24,				/* Bits per pixel */

	.vd_console_address	=	NULL,	/* Start of console buffer	*/
	.console_col	=	0,
	.console_row	=	0,
	
	.vd_color_fg	=	0,
	.vd_color_bg	=	0,
	.max_bl_level	=	255,

	.cmap	=	NULL,		/* Pointer to the colormap */

	.priv		=	NULL,			/* Pointer to driver-specific data */
};

struct tv_operations tv_oper =
{
	.enable     = tv_enable,
	.disable	= tv_disable,
	.power_on   = tv_power_on,
    .power_off  = tv_power_off,
};
