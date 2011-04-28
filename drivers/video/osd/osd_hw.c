/*
 * Amlogic Apollo
 * frame buffer driver
 *
 * Copyright (C) 2009 Amlogic, Inc.
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
#include <asm/arch/osd.h>
#include <asm/arch/osd_hw.h>
#include <asm/arch/canvas.h>
#include <asm/arch/osd_hw_def.h>
#include <asm/arch/canvas_missed_define.h>
#include <asm/arch/vpp_misc_missed_define.h>

//#define __DBG__OSD_HW__
#ifdef __DBG__OSD_HW__
#define _debug(fmt,args...) do { printf("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)
#else
#define _debug(fmt,args...)
#endif

//#define  FIQ_VSYNC


//static DECLARE_WAIT_QUEUE_HEAD(osd_vsync_wq);
static bool vsync_hit = false;
static bool osd_vf_need_update = false;

/********************************************************************/
/***********		osd psedu frame provider 			*****************/
/********************************************************************/
static vframe_t *osd_vf_peek(void *arg)
{
	_debug("\n");
	return ((osd_vf_need_update && (vf.width > 0) && (vf.height > 0)) ? &vf : NULL);
}

static vframe_t *osd_vf_get(void *arg)
{
	_debug("\n");
	if (osd_vf_need_update) {
		osd_vf_need_update = false;
		return &vf;
	}
	return NULL;
}

#define PROVIDER_NAME   "osd"
static const struct vframe_operations_s osd_vf_provider =
{
    .peek = osd_vf_peek,
    .get  = osd_vf_get,
    .put  = NULL,
};

static struct vframe_provider_s osd_vf_prov;
static unsigned char osd_vf_prov_init = 0;

static inline void  osd_update_3d_mode(int enable_osd1,int enable_osd2)
{
	_debug("\n");
	if(enable_osd1)
	{
		osd1_update_disp_3d_mode();
	}
	if(enable_osd2)
	{
		osd2_update_disp_3d_mode();
	}
}

static inline void wait_vsync_wakeup(void)
{
	_debug("\n");
	vsync_hit = true;
	//wake_up_interruptible(&osd_vsync_wq);		//comment out by Elvis Yu
}
static inline void  walk_through_update_list(void)
{
	u32  i,j;
	_debug("\n");
	for(i=0;i<HW_OSD_COUNT;i++)
	{	
		j=0;
		while(osd_hw.updated[i] && j<32)
		{
			if(osd_hw.updated[i]&(1<<j))
			{
				osd_hw.reg[i][j].update_func();
				remove_from_update_list(i,j);
			}
		j++;
		}
	}
}


/**********************************************************************/
/**********          osd vsync irq handler              ***************/
/**********************************************************************/
#ifdef FIQ_VSYNC
static irqreturn_t vsync_isr(int irq, void *dev_id)
{
	wait_vsync_wakeup();

	return IRQ_HANDLED;
}
#endif

#ifdef __DBG__OSD_HW__
void osd_reg_debug(void)
{
	int i = 0;

	printf("P_VPP_MISC(0x%x): 0x%x\n", P_VPP_MISC, readl(P_VPP_MISC));
	printf("OSD1:\n");
	for(i=0x1a10; i<0x1a30; i++)
	{
#ifdef CONFIG_AML_MESON_8
		printf("0x%08x(0x%04x): 0x%x\n", VPU_REG_ADDR(i), i, readl(VPU_REG_ADDR(i)));
#else
		printf("0x%08x: 0x%x\n", CBUS_REG_ADDR(i), readl(CBUS_REG_ADDR(i)));
#endif
	}
	printf("OSD2:\n");
	for(i=0x1a30; i<0x1a50; i++)
	{
#ifdef CONFIG_AML_MESON_8
                printf("0x%08x(0x%04x): 0x%x\n", VPU_REG_ADDR(i), i, readl(VPU_REG_ADDR(i)));
#else
		printf("0x%x: 0x%x\n", CBUS_REG_ADDR(i), readl(CBUS_REG_ADDR(i)));
#endif
	}
}
#endif


#ifdef FIQ_VSYNC
static void osd_fiq_isr(void)
#else
//static irqreturn_t vsync_isr(int irq, void *dev_id)	//comment out by Elvis Yu
void vsync_isr(void)
#endif
{
	unsigned  int  fb0_cfg_w0,fb1_cfg_w0;
	unsigned  int  current_field;
	
	if (readl(P_ENCI_VIDEO_EN) & 1)
		osd_hw.scan_mode= SCAN_MODE_INTERLACE;
	else if (readl(P_ENCP_VIDEO_MODE) & (1 << 12))
		osd_hw.scan_mode= SCAN_MODE_INTERLACE;
	else
		osd_hw.scan_mode= SCAN_MODE_PROGRESSIVE;
	
	if(osd_hw.free_scale_enable[OSD1])
	{
		osd_hw.scan_mode= SCAN_MODE_PROGRESSIVE;
	}
	if (osd_hw.scan_mode== SCAN_MODE_INTERLACE)
	{
		fb0_cfg_w0=readl(P_VIU_OSD1_BLK0_CFG_W0);
		fb1_cfg_w0=readl(P_VIU_OSD2_BLK0_CFG_W0);
		if (readl(P_ENCP_VIDEO_MODE) & (1 << 12))
    	{
   		 	/* 1080I */
    		if (readl(P_VENC_ENCP_LINE) >= 562) {
       		 /* bottom field */
       			current_field = 0;
    		} else {
       			current_field = 1;
    		}
		} else {
    		current_field = readl(P_VENC_STATA) & 1;
		}

		_debug("current_field = 0x%x\n", current_field);
		
		fb0_cfg_w0 &=~1;
		fb1_cfg_w0 &=~1;
		fb0_cfg_w0 |=current_field;
		fb1_cfg_w0 |=current_field;
		writel(fb0_cfg_w0, P_VIU_OSD1_BLK0_CFG_W0);
		writel(fb0_cfg_w0, P_VIU_OSD1_BLK1_CFG_W0);
		writel(fb0_cfg_w0, P_VIU_OSD1_BLK2_CFG_W0);
		writel(fb0_cfg_w0, P_VIU_OSD1_BLK3_CFG_W0);
		writel(fb1_cfg_w0, P_VIU_OSD2_BLK0_CFG_W0);
		writel(fb1_cfg_w0, P_VIU_OSD2_BLK1_CFG_W0);
		writel(fb1_cfg_w0, P_VIU_OSD2_BLK2_CFG_W0);
		writel(fb1_cfg_w0, P_VIU_OSD2_BLK3_CFG_W0);
	}

	//go through update list
	walk_through_update_list();
	osd_update_3d_mode(osd_hw.mode_3d[OSD1].enable,osd_hw.mode_3d[OSD2].enable);
	
	if (!vsync_hit)
	{
#ifdef FIQ_VSYNC
		fiq_bridge_pulse_trigger(&osd_hw.fiq_handle_item);
#else
		wait_vsync_wakeup();
#endif
	}

#ifndef FIQ_VSYNC
//	return  IRQ_HANDLED;		//comment out by Elvis Yu
#endif
}

void osd_wait_vsync_hw(void)
{
	_debug("\n");
	vsync_hit = false;

	//wait_event_interruptible_timeout(osd_vsync_wq, vsync_hit, HZ);	//comment out by Elvis Yu
}

extern void mdelay(unsigned long msec);
void  osd_set_gbl_alpha_hw(u32 index,u32 gbl_alpha)
{
	_debug("\n");
	if(osd_hw.gbl_alpha[index] != gbl_alpha)
	{
		
		osd_hw.gbl_alpha[index]=gbl_alpha;
		add_to_update_list(index,OSD_GBL_ALPHA);
		osd_wait_vsync_hw();
	}
}
u32  osd_get_gbl_alpha_hw(u32  index)
{
	_debug("\n");
	return osd_hw.gbl_alpha[index];
}
void  osd_set_colorkey_hw(u32 index,u32 color_index,u32 colorkey )
{
	u8  r=0,g=0,b=0,a=(colorkey&0xff000000)>>24;
	u32	data32;
	_debug("\n");
	colorkey&=0x00ffffff;
	switch(color_index)
	{
			case COLOR_INDEX_16_655:
		r=(colorkey>>10&0x3f)<<2;
		g=(colorkey>>5&0x1f)<<3;
		b=(colorkey&0x1f)<<3;
		break;	
		case COLOR_INDEX_16_844:
		r=colorkey>>8&0xff;
		g=(colorkey>>4&0xf)<<4;
		b=(colorkey&0xf)<<4;	
		break;	
		case COLOR_INDEX_16_565:
		r=(colorkey>>11&0x1f)<<3;
		g=(colorkey>>5&0x3f)<<2;
		b=(colorkey&0x1f)<<3;		
		break;	
		case COLOR_INDEX_24_888_B:
		b=colorkey>>16&0xff;
		g=colorkey>>8&0xff;
		r=colorkey&0xff;			
		break;
		case COLOR_INDEX_24_RGB:
		case COLOR_INDEX_YUV_422:	
		r=colorkey>>16&0xff;
		g=colorkey>>8&0xff;
		b=colorkey&0xff;			
		break;	
	}	
	data32=r<<24|g<<16|b<<8|a;
	if( osd_hw.color_key[index]!=data32)
	{
		 osd_hw.color_key[index]=data32;
		printf("bpp:%d--r:0x%x g:0x%x b:0x%x ,a:0x%x\r\n",color_index,r,g,b,a);
		add_to_update_list(index,OSD_COLOR_KEY);
		
		osd_wait_vsync_hw();
	}

	return ;
}
void  osd_srckey_enable_hw(u32  index,u8 enable)
{
	_debug("\n");
	if(enable != osd_hw.color_key_enable[index])
	{
		osd_hw.color_key_enable[index]=enable;
		add_to_update_list(index,OSD_COLOR_KEY_ENABLE);
		
		osd_wait_vsync_hw();
	}
	
}

void  osddev_update_disp_axis_hw(
					u32 display_h_start,
                  	u32 display_h_end,
                  	u32 display_v_start,
                  	u32 display_v_end,
					u32 xoffset,
                  	u32 yoffset,
                  	u32 mode_change,
                  	u32 index)
{
	dispdata_t   disp_data;
	pandata_t    pan_data;
	_debug("\n");
	if(NULL==osd_hw.color_info[index]) return ;
	if(mode_change)  //modify pandata .
	{
		add_to_update_list(index,OSD_COLOR_MODE);
	}
	disp_data.x_start=display_h_start;
	disp_data.y_start=display_v_start;
	disp_data.x_end=display_h_end;
	disp_data.y_end=display_v_end;

	pan_data.x_start=xoffset;
	pan_data.x_end=xoffset + (display_h_end - display_h_start);
	pan_data.y_start=yoffset;
	pan_data.y_end=yoffset + (display_v_end-display_v_start);
	
	//if output mode change then reset pan ofFfset.
	memcpy(&osd_hw.pandata[index],&pan_data,sizeof(pandata_t));
	memcpy(&osd_hw.dispdata[index],&disp_data,sizeof(dispdata_t));
	add_to_update_list(index,DISP_GEOMETRY);
	osd_wait_vsync_hw();
	
}
void osd_setup(	u32 xoffset,
				u32 yoffset,
				u32 xres,
				u32 yres,
				u32 xres_virtual,
				u32 yres_virtual,
				u32 disp_start_x,
				u32 disp_start_y,
				u32 disp_end_x,
				u32 disp_end_y,
				u32 fbmem,
				const color_bit_define_t *color,
				int index 
				)
{
    _debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
	_debug("xoffset = %d(0x%08x)\n", xoffset, xoffset);
	_debug("yoffset = %d(0x%08x)\n", yoffset, yoffset);
	_debug("xres = %d(0x%08x)\n", xres, xres);
	_debug("yres = %d(0x%08x)\n", yres, yres);
	_debug("xres_virtual = %d(0x%08x)\n", xres_virtual, xres_virtual);
	_debug("yres_virtual = %d(0x%08x)\n", yres_virtual, yres_virtual);
	_debug("disp_start_x = %d(0x%08x)\n", disp_start_x, disp_start_x);
	_debug("disp_start_y = %d(0x%08x)\n", disp_start_y, disp_start_y);
	_debug("disp_end_x = %d(0x%08x)\n", disp_end_x, disp_end_x);
	_debug("disp_end_y = %d(0x%08x)\n", disp_end_y, disp_end_y);
	_debug("fbmem = %d(0x%08x)\n", fbmem, fbmem);
	_debug("index = %d(0x%08x)\n", index, index);
	_debug("color->color_index, = %d(0x%08x)\n", color->color_index, color->color_index);
	_debug("color->hw_colormat, = %d(0x%08x)\n", color->hw_colormat, color->hw_colormat);
	_debug("color->hw_blkmode, = %d(0x%08x)\n", color->hw_blkmode, color->hw_blkmode);
	_debug("color->red_offset, = %d(0x%08x)\n", color->red_offset, color->red_offset);
	_debug("color->red_length, = %d(0x%08x)\n", color->red_length, color->red_length);
	_debug("color->red_msb_right, = %d(0x%08x)\n", color->red_msb_right, color->red_msb_right);
	_debug("color->green_offset, = %d(0x%08x)\n", color->green_offset, color->green_offset);
	_debug("color->green_length, = %d(0x%08x)\n", color->green_length, color->green_length);
	_debug("color->green_msb_right, = %d(0x%08x)\n", color->green_msb_right, color->green_msb_right);
	_debug("color->blue_offset, = %d(0x%08x)\n", color->blue_offset, color->blue_offset);
	_debug("color->blue_length, = %d(0x%08x)\n", color->blue_length, color->blue_length);
	_debug("color->blue_msb_right, = %d(0x%08x)\n", color->blue_msb_right, color->blue_msb_right);
	_debug("color->transp_offset, = %d(0x%08x)\n", color->transp_offset, color->transp_offset);
	_debug("color->transp_length, = %d(0x%08x)\n", color->transp_length, color->transp_length);
	_debug("color->transp_msb_right, = %d(0x%08x)\n", color->transp_msb_right, color->transp_msb_right);
	_debug("color->color_type, = %d(0x%08x)\n", color->color_type, color->color_type);
	_debug("color->bpp, = %d(0x%08x)\n", color->bpp, color->bpp);


    u32  w=(color->bpp * xres_virtual + 7) >> 3;
	dispdata_t   disp_data;
	pandata_t    pan_data;

	pan_data.x_start=xoffset;
	pan_data.x_end=xoffset + (disp_end_x-disp_start_x);
	pan_data.y_start=yoffset;
	pan_data.y_end=yoffset + (disp_end_y-disp_start_y);

	disp_data.x_start=disp_start_x;
	disp_data.y_start=disp_start_y;
	disp_data.x_end=disp_end_x;
	disp_data.y_end=disp_end_y;
	
       if( osd_hw.fb_gem[index].addr!=fbmem || osd_hw.fb_gem[index].width !=w ||  osd_hw.fb_gem[index].height !=yres_virtual)
       	{
		osd_hw.fb_gem[index].addr=fbmem;
		osd_hw.fb_gem[index].width=w;
		osd_hw.fb_gem[index].height=yres_virtual;
		canvas_config(osd_hw.fb_gem[index].canvas_idx, osd_hw.fb_gem[index].addr,
	              			osd_hw.fb_gem[index].width, osd_hw.fb_gem[index].height,
	              			CANVAS_ADDR_NOWRAP, CANVAS_BLKMODE_LINEAR);
       	}	
	
	if(color != osd_hw.color_info[index])
	{
		osd_hw.color_info[index]=color;
		add_to_update_list(index,OSD_COLOR_MODE);
	}
	if(osd_hw.enable[index] == DISABLE)
	{
		osd_hw.enable[index]=ENABLE;
		add_to_update_list(index,OSD_ENABLE);
		
	}
	if(memcmp(&pan_data,&osd_hw.pandata[index],sizeof(pandata_t))!= 0 ||
		memcmp(&disp_data,&osd_hw.dispdata[index],sizeof(dispdata_t))!=0)
	{
		if(!osd_hw.free_scale_enable[OSD1]) //in free scale mode ,adjust geometry para is abandoned.
		{
			memcpy(&osd_hw.pandata[index],&pan_data,sizeof(pandata_t));
			memcpy(&osd_hw.dispdata[index],&disp_data,sizeof(dispdata_t));
			add_to_update_list(index,DISP_GEOMETRY);
		}
	}

	osd_wait_vsync_hw();
#ifdef __DBG__OSD_HW__
	osd_reg_debug();
#endif
}

void osd_setpal_hw(unsigned regno,
                 unsigned red,
                 unsigned green,
                 unsigned blue,
                 unsigned transp,
                 int index 
                 )
{
	_debug("\n");
    if (regno < 256) {
        u32 pal;
        pal = ((red   & 0xff) << 24) |
              ((green & 0xff) << 16) |
              ((blue  & 0xff) <<  8) |
              (transp & 0xff);

        writel(regno, P_VIU_OSD1_COLOR_ADDR+REG_OFFSET*index);
        writel(pal, P_VIU_OSD1_COLOR+REG_OFFSET*index);
    }
}
u32 osd_get_osd_order_hw(u32 index)
{
	_debug("\n");
	return (osd_hw.osd_order & 0x3);
}
void osd_change_osd_order_hw(u32 index,u32 order)
{
	_debug("\n");
	if((order != OSD_ORDER_01)&&(order != OSD_ORDER_10)) 
	return ;
	osd_hw.osd_order=order;
	add_to_update_list(index, OSD_CHANGE_ORDER);
	osd_wait_vsync_hw();
}
	
void osd_free_scale_enable_hw(u32 index,u32 enable)
{
	static  dispdata_t	save_disp_data={0,0,0,0};
	static  pandata_t	save_pan_data={0,0,0,0};

	_debug("\n");
#ifdef CONFIG_AM_VIDEO 
#ifdef CONFIG_POST_PROCESS_MANAGER
	int mode_changed = 0;
	if((index==OSD1)&&(osd_hw.free_scale_enable[index]!=enable))
		mode_changed = 1;
#endif
#endif

	_debug("osd%d free scale %s\r\n",index,enable?"ENABLE":"DISABLE");
	osd_hw.free_scale_enable[index]=enable;
	if (index==OSD1)
	{
		if(enable)
		{
			osd_vf_need_update = true;
			if ((osd_hw.free_scale_data[OSD1].x_end > 0) && (osd_hw.free_scale_data[OSD1].x_end > 0)) {
				vf.width = osd_hw.free_scale_data[index].x_end - osd_hw.free_scale_data[index].x_start + 1;
				vf.height = osd_hw.free_scale_data[index].y_end - osd_hw.free_scale_data[index].y_start + 1;
			} else {
				vf.width=osd_hw.free_scale_width[OSD1];
				vf.height=osd_hw.free_scale_height[OSD1];
			}
//			vf.type = (osd_hw.scan_mode==SCAN_MODE_INTERLACE ?VIDTYPE_INTERLACE:VIDTYPE_PROGRESSIVE) | VIDTYPE_VIU_FIELD;
			vf.type = (VIDTYPE_NO_VIDEO_ENABLE | VIDTYPE_PROGRESSIVE | VIDTYPE_VIU_FIELD);
			vf.ratio_control=DISP_RATIO_FORCECONFIG|DISP_RATIO_NO_KEEPRATIO;
#ifdef CONFIG_AM_VIDEO 			
      if(osd_vf_prov_init==0){
            vf_provider_init(&osd_vf_prov, PROVIDER_NAME, &osd_vf_provider, NULL);
            osd_vf_prov_init = 1;
        }
			vf_reg_provider(&osd_vf_prov);
#endif
			memcpy(&save_disp_data,&osd_hw.dispdata[OSD1],sizeof(dispdata_t));
			memcpy(&save_pan_data,&osd_hw.pandata[OSD1],sizeof(pandata_t));
			osd_hw.pandata[OSD1].x_end =osd_hw.pandata[OSD1].x_start + vf.width-1-osd_hw.dispdata[OSD1].x_start;
			osd_hw.pandata[OSD1].y_end =osd_hw.pandata[OSD1].y_start + vf.height-1;	
			osd_hw.dispdata[OSD1].x_end =osd_hw.dispdata[OSD1].x_start + vf.width-1;
			osd_hw.dispdata[OSD1].y_end =osd_hw.dispdata[OSD1].y_start + vf.height-1;
			add_to_update_list(OSD1,DISP_GEOMETRY);
			add_to_update_list(OSD1,OSD_COLOR_MODE);
		}
		else
		{
			osd_vf_need_update = false;
			if(save_disp_data.x_end <= save_disp_data.x_start ||  
				save_disp_data.y_end <= save_disp_data.y_start)
			{
				return ;
			}
			memcpy(&osd_hw.dispdata[OSD1],&save_disp_data,sizeof(dispdata_t));
			memcpy(&osd_hw.pandata[OSD1],&save_pan_data,sizeof(pandata_t));
			add_to_update_list(OSD1,DISP_GEOMETRY);
			add_to_update_list(OSD1,OSD_COLOR_MODE);
#ifdef CONFIG_AM_VIDEO  			
			vf_unreg_provider(&osd_vf_prov);
#endif
				
		}
	}
	else
	{
	     add_to_update_list(OSD2,DISP_GEOMETRY);  
         add_to_update_list(OSD2,OSD_COLOR_MODE);
	}
	osd_enable_hw(osd_hw.enable[index],index);
#ifdef CONFIG_AM_VIDEO  
#ifdef CONFIG_POST_PROCESS_MANAGER
	if(mode_changed){
        vf_notify_receiver(PROVIDER_NAME,VFRAME_EVENT_PROVIDER_RESET,NULL);
    }
#endif
#endif
}

void osd_free_scale_width_hw(u32 index,u32 width)
{
	_debug("\n");
	osd_hw.free_scale_width[index]=width;
	if (osd_hw.free_scale_enable[index]) {
		osd_vf_need_update = true;
		vf.width = osd_hw.free_scale_width[index];
		osd_hw.pandata[OSD1].x_end = osd_hw.pandata[OSD1].x_start + vf.width-1-osd_hw.dispdata[OSD1].x_start;
		osd_hw.dispdata[OSD1].x_end = osd_hw.dispdata[OSD1].x_start + vf.width-1;
		add_to_update_list(index, DISP_GEOMETRY);
		add_to_update_list(index, OSD_COLOR_MODE);
	}
}

void osd_free_scale_height_hw(u32 index,u32 height)
{
	_debug("\n");
	osd_hw.free_scale_height[index]=height;
	if (osd_hw.free_scale_enable[index]) {
		osd_vf_need_update = true;
		vf.height = osd_hw.free_scale_height[index];
		osd_hw.pandata[OSD1].y_end = osd_hw.pandata[OSD1].y_start + vf.height - 1;
		osd_hw.dispdata[OSD1].y_end = osd_hw.dispdata[OSD1].y_start + vf.height - 1;
		add_to_update_list(index, DISP_GEOMETRY);
		add_to_update_list(index, OSD_COLOR_MODE);
	}
}

void osd_get_free_scale_axis_hw(u32 index, s32 *x0, s32 *y0, s32 *x1, s32 *y1)
{
	_debug("\n");
	*x0 = osd_hw.free_scale_data[index].x_start;
	*y0 = osd_hw.free_scale_data[index].y_start;
	*x1 = osd_hw.free_scale_data[index].x_end;
	*y1 = osd_hw.free_scale_data[index].y_end;
}

void osd_set_free_scale_axis_hw(u32 index, s32 x0, s32 y0, s32 x1, s32 y1)
{
	_debug("\n");
	osd_hw.free_scale_data[index].x_start = x0;
	osd_hw.free_scale_data[index].y_start = y0;
	osd_hw.free_scale_data[index].x_end = x1;
	osd_hw.free_scale_data[index].y_end = y1;

	if (osd_hw.free_scale_enable[index]) {
		osd_vf_need_update = true;
		vf.width = osd_hw.free_scale_data[index].x_end - osd_hw.free_scale_data[index].x_start + 1;
		vf.height = osd_hw.free_scale_data[index].y_end - osd_hw.free_scale_data[index].y_start + 1;
		osd_hw.pandata[OSD1].x_end = osd_hw.pandata[OSD1].x_start + vf.width - 1 - osd_hw.dispdata[OSD1].x_start;
		osd_hw.pandata[OSD1].y_end = osd_hw.pandata[OSD1].y_start + vf.height - 1;
		osd_hw.dispdata[OSD1].x_end = osd_hw.dispdata[OSD1].x_start + vf.width - 1;
		osd_hw.dispdata[OSD1].y_end = osd_hw.dispdata[OSD1].y_start + vf.height - 1;

		add_to_update_list(index, DISP_GEOMETRY);
		add_to_update_list(index, OSD_COLOR_MODE);
	}
}

void osd_get_scale_axis_hw(u32 index, s32 *x0, s32 *y0, s32 *x1, s32 *y1)
{
	_debug("\n");
	*x0 = osd_hw.scaledata[index].x_start;
	*x1 = osd_hw.scaledata[index].x_end;
	*y0 = osd_hw.scaledata[index].y_start;
	*y1 = osd_hw.scaledata[index].y_end;
}

void osd_set_scale_axis_hw(u32 index, s32 x0, s32 y0, s32 x1, s32 y1)
{
	_debug("\n");
	osd_hw.scaledata[index].x_start = x0;
	osd_hw.scaledata[index].x_end = x1;
	osd_hw.scaledata[index].y_start = y0;
	osd_hw.scaledata[index].y_end = y1;
}

void osd_get_block_windows_hw(u32 index, u32 *windows)
{
	_debug("\n");
	memcpy(windows, osd_hw.block_windows[index], sizeof(osd_hw.block_windows[index]));
}

void osd_set_block_windows_hw(u32 index, u32 *windows)
{
	_debug("\n");
	memcpy(osd_hw.block_windows[index], windows, sizeof(osd_hw.block_windows[index]));
	add_to_update_list(index, DISP_GEOMETRY);
	osd_wait_vsync_hw();
}

void osd_get_block_mode_hw(u32 index, u32 *mode)
{
	_debug("\n");
	*mode = osd_hw.block_mode[index];
}

void osd_set_block_mode_hw(u32 index, u32 mode)
{
	_debug("\n");
	osd_hw.block_mode[index] = mode;
	add_to_update_list(index, DISP_GEOMETRY);
	osd_wait_vsync_hw();
}

void osd_enable_3d_mode_hw(int index,int enable)
{
	_debug("\n");
	//spin_lock_irqsave(&osd_lock, lock_flags);		//comment out by Elvis Yu
	osd_hw.mode_3d[index].enable=enable;
	//spin_unlock_irqrestore(&osd_lock, lock_flags);	//comment out by Elvis Yu
	if(enable)  //when disable 3d mode ,we should return to stardard state.
	{
		osd_hw.mode_3d[index].left_right=LEFT;
		osd_hw.mode_3d[index].l_start=osd_hw.pandata[index].x_start;
		osd_hw.mode_3d[index].l_end= (osd_hw.pandata[index].x_end +  osd_hw.pandata[index].x_start)>>1;
		osd_hw.mode_3d[index].r_start=osd_hw.mode_3d[index].l_end + 1;
		osd_hw.mode_3d[index].r_end=osd_hw.pandata[index].x_end;
		osd_hw.mode_3d[index].origin_scale.h_enable=osd_hw.scale[index].h_enable;
		osd_hw.mode_3d[index].origin_scale.v_enable=osd_hw.scale[index].v_enable;
		osd_set_2x_scale_hw(index,1,0);
	}
	else
	{
		
		osd_set_2x_scale_hw(index,osd_hw.mode_3d[index].origin_scale.h_enable,
								osd_hw.mode_3d[index].origin_scale.v_enable);
	}
}
void osd_enable_hw(int enable ,int index )
{
	_debug("\n");
	osd_hw.enable[index]=enable;
	add_to_update_list(index,OSD_ENABLE);
		
	osd_wait_vsync_hw();
}

void osd_set_2x_scale_hw(u32 index,u16 h_scale_enable,u16 v_scale_enable)
{
	_debug("osd[%d] set scale, h_scale: %s, v_scale: %s\r\n", 
	index, h_scale_enable ? "ENABLE" : "DISABLE", v_scale_enable ? "ENABLE" : "DISABLE");
	_debug("osd[%d].scaledata: %d %d %d %d\n", 
			index,
			osd_hw.scaledata[index].x_start, 
			osd_hw.scaledata[index].x_end, 
			osd_hw.scaledata[index].y_start, 
			osd_hw.scaledata[index].y_end);
	_debug("osd[%d].pandata: %d %d %d %d\n", 
			index,
			osd_hw.pandata[index].x_start, 
			osd_hw.pandata[index].x_end, 
			osd_hw.pandata[index].y_start, 
			osd_hw.pandata[index].y_end);
	
	osd_hw.scale[index].h_enable = h_scale_enable;
	osd_hw.scale[index].v_enable = v_scale_enable;
	add_to_update_list(index, DISP_SCALE_ENABLE);
	add_to_update_list(index, DISP_GEOMETRY);

	osd_wait_vsync_hw();
}

void osd_pan_display_hw(unsigned int xoffset, unsigned int yoffset,int index )
{
	long diff_x, diff_y;
	_debug("\n");
#if defined(CONFIG_FB_OSD2_CURSOR)
	if (index >= 1)
#else
	if (index >= 2)
#endif
		return;
    	
    	if(xoffset!=osd_hw.pandata[index].x_start || yoffset !=osd_hw.pandata[index].y_start)
    	{
    		diff_x = xoffset - osd_hw.pandata[index].x_start;
		diff_y = yoffset - osd_hw.pandata[index].y_start;

		osd_hw.pandata[index].x_start += diff_x;
		osd_hw.pandata[index].x_end   += diff_x;
		osd_hw.pandata[index].y_start += diff_y;
		osd_hw.pandata[index].y_end   += diff_y;
		add_to_update_list(index,DISP_GEOMETRY);
		
		osd_wait_vsync_hw();
		
		_debug("offset[%d-%d]x[%d-%d]y[%d-%d]\n", \
				xoffset,yoffset,osd_hw.pandata[index].x_start ,osd_hw.pandata[index].x_end , \
				osd_hw.pandata[index].y_start ,osd_hw.pandata[index].y_end );
    	}
}
static  void  osd1_update_disp_scale_enable(void)
{
	_debug("\n");
	if(osd_hw.scale[OSD1].h_enable)
	{
		setbits_le32(P_VIU_OSD1_BLK0_CFG_W0, 3<<12);
	}
	else
	{
		clrbits_le32(P_VIU_OSD1_BLK0_CFG_W0, 3<<12);
	}
	if(osd_hw.scan_mode != SCAN_MODE_INTERLACE)
	{
		if(osd_hw.scale[OSD1].v_enable)
		{
			setbits_le32(P_VIU_OSD1_BLK0_CFG_W0, 1<<14);
		}
		else
		{
			clrbits_le32(P_VIU_OSD1_BLK0_CFG_W0, 1<<14);
		}
	}	
}
static  void  osd2_update_disp_scale_enable(void)
{
	_debug("\n");
	if(osd_hw.scale[OSD2].h_enable)
	{
#if defined(CONFIG_FB_OSD2_CURSOR)
		clrbits_le32(P_VIU_OSD2_BLK0_CFG_W0, 3<<12);
#else
		setbits_le32(P_VIU_OSD2_BLK0_CFG_W0, 3<<12);
#endif
	}
	else
	{
		clrbits_le32(P_VIU_OSD2_BLK0_CFG_W0, 3<<12);
	}
	if(osd_hw.scan_mode != SCAN_MODE_INTERLACE)
	{
		if(osd_hw.scale[OSD2].v_enable)
		{
#if defined(CONFIG_FB_OSD2_CURSOR)
			clrbits_le32(P_VIU_OSD2_BLK0_CFG_W0, 1<<14);
#else
			setbits_le32(P_VIU_OSD2_BLK0_CFG_W0, 1<<14);
#endif
		}
		else
		{
			clrbits_le32(P_VIU_OSD2_BLK0_CFG_W0, 1<<14);
		}
	}
	
}
static   void  osd1_update_color_mode(void)
{
	u32  data32;
	data32= (osd_hw.scan_mode== SCAN_MODE_INTERLACE) ? 2 : 0;
	data32 |=readl(P_VIU_OSD1_BLK0_CFG_W0)&0x7040;
	data32 |= osd_hw.fb_gem[OSD1].canvas_idx << 16 ;
	data32 |= OSD_DATA_LITTLE_ENDIAN	 <<15 ;
    	data32 |= osd_hw.color_info[OSD1]->hw_colormat<< 2;	
	if(osd_hw.color_info[OSD1]->color_index < COLOR_INDEX_YUV_422)
	data32 |= 1                      << 7; /* rgb enable */
	data32 |=  osd_hw.color_info[OSD1]->hw_blkmode<< 8; /* osd_blk_mode */
	writel(data32, P_VIU_OSD1_BLK0_CFG_W0);
	writel(data32, P_VIU_OSD1_BLK1_CFG_W0);
	writel(data32, P_VIU_OSD1_BLK2_CFG_W0);
	writel(data32, P_VIU_OSD1_BLK3_CFG_W0);
	remove_from_update_list(OSD1, OSD_COLOR_MODE);
    _debug("---VIU_OSD1_BLK0_CFG_W0 = %d(0x%08x)\n", data32, data32);
}
static  inline void  osd2_update_color_mode(void)
{
	u32  data32;
	data32= (osd_hw.scan_mode== SCAN_MODE_INTERLACE)? 2 : 0;
	data32 |=readl(P_VIU_OSD2_BLK0_CFG_W0)&0x7040;
	data32 |= osd_hw.fb_gem[OSD2].canvas_idx << 16 ;
	data32 |= OSD_DATA_LITTLE_ENDIAN	 <<15 ;
    	data32 |= osd_hw.color_info[OSD2]->hw_colormat<< 2;	
	if(osd_hw.color_info[OSD2]->color_index < COLOR_INDEX_YUV_422)
	data32 |= 1                      << 7; /* rgb enable */
	data32 |=  osd_hw.color_info[OSD2]->hw_blkmode<< 8; /* osd_blk_mode */
    _debug("---VIU_OSD2_BLK0_CFG_W0 = %d(0x%08x)\n", data32, data32);
	writel(data32, P_VIU_OSD2_BLK0_CFG_W0);
	writel(data32, P_VIU_OSD2_BLK1_CFG_W0);
	writel(data32, P_VIU_OSD2_BLK2_CFG_W0);
	writel(data32, P_VIU_OSD2_BLK3_CFG_W0);
	remove_from_update_list(OSD2, OSD_COLOR_MODE);
}

static   void  osd1_update_enable(void)
{
	u32  video_enable;
    _debug("---osd_hw.enable[OSD1] = %d(0x%08x)\n", osd_hw.enable[OSD1], osd_hw.enable[OSD1]);
	video_enable=readl(P_VPP_MISC)&VPP_VD1_PREBLEND;
	if(osd_hw.enable[OSD1]==ENABLE)
	{
		if(osd_hw.free_scale_enable[OSD1])
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD1_POSTBLEND);
			setbits_le32(P_VPP_MISC,VPP_OSD1_PREBLEND);
			setbits_le32(P_VPP_MISC,VPP_VD1_POSTBLEND);
			setbits_le32(P_VPP_MISC,VPP_PREBLEND_EN);
		}
		else
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD1_PREBLEND);
			if(!video_enable)
			{
				clrbits_le32(P_VPP_MISC,VPP_VD1_POSTBLEND);
			}
			setbits_le32(P_VPP_MISC,VPP_OSD1_POSTBLEND);
		}
		
	}
	else
	{	
		if(osd_hw.free_scale_enable[OSD1])
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD1_PREBLEND);
		}
		else
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD1_POSTBLEND);
		}
	}
	remove_from_update_list(OSD1,OSD_ENABLE);
}
static   void  osd2_update_enable(void)
{
	u32  video_enable;
    _debug("---osd_hw.enable[OSD2] = %d(0x%08x)\n", osd_hw.enable[OSD2], osd_hw.enable[OSD2]);
	video_enable=readl(P_VPP_MISC)&VPP_VD1_PREBLEND;
	if(osd_hw.enable[OSD2]==ENABLE)
	{
		if(osd_hw.free_scale_enable[OSD2])
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD2_POSTBLEND);
			setbits_le32(P_VPP_MISC,VPP_OSD2_PREBLEND);
			setbits_le32(P_VPP_MISC,VPP_VD1_POSTBLEND);
		}
		else
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD2_PREBLEND);
			if(!video_enable)
			{
				clrbits_le32(P_VPP_MISC,VPP_VD1_POSTBLEND);
			}
			setbits_le32(P_VPP_MISC,VPP_OSD2_POSTBLEND);
		}
		
	}
	else
	{	
		if(osd_hw.free_scale_enable[OSD2])
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD2_PREBLEND);
		}
		else
		{
			clrbits_le32(P_VPP_MISC,VPP_OSD2_POSTBLEND);
		}
	}
	remove_from_update_list(OSD2,OSD_ENABLE);
}
static  void  osd1_update_color_key(void)
{
	_debug("\n");
	writel(osd_hw.color_key[OSD1], P_VIU_OSD1_TCOLOR_AG0);
	remove_from_update_list(OSD1, OSD_COLOR_KEY);
}
static   void  osd2_update_color_key(void)
{
	writel(osd_hw.color_key[OSD2], P_VIU_OSD2_TCOLOR_AG0);
	remove_from_update_list(OSD2, OSD_COLOR_KEY);
}
static  void  osd1_update_color_key_enable(void)
{
	u32  data32;
	_debug("\n");
	data32=readl(P_VIU_OSD1_BLK0_CFG_W0);
	data32&=~(1<<6);
	data32|=(osd_hw.color_key_enable[OSD1]<<6);
	writel(data32, P_VIU_OSD1_BLK0_CFG_W0);
	writel(data32, P_VIU_OSD1_BLK1_CFG_W0);
	writel(data32, P_VIU_OSD1_BLK2_CFG_W0);
	writel(data32, P_VIU_OSD1_BLK3_CFG_W0);
	remove_from_update_list(OSD1,OSD_COLOR_KEY_ENABLE);
}
static  void  osd2_update_color_key_enable(void)
{
	u32  data32;
	_debug("\n");
	data32=readl(P_VIU_OSD2_BLK0_CFG_W0);
	data32&=~(1<<6);
	data32|=(osd_hw.color_key_enable[OSD2]<<6);
	writel(data32, P_VIU_OSD2_BLK0_CFG_W0);
	remove_from_update_list(OSD2,OSD_COLOR_KEY_ENABLE);
}
static   void  osd1_update_gbl_alpha(void)
{
	_debug("\n");
	u32  data32=readl(P_VIU_OSD1_CTRL_STAT);
	data32&=~(0x1ff<<12);
	data32|=osd_hw.gbl_alpha[OSD1] <<12;
	writel(data32, P_VIU_OSD1_CTRL_STAT);
	remove_from_update_list(OSD1,OSD_GBL_ALPHA);
}
static   void  osd2_update_gbl_alpha(void)
{
	_debug("\n");
	u32  data32=readl(P_VIU_OSD2_CTRL_STAT);
	data32&=~(0x1ff<<12);
	data32|=osd_hw.gbl_alpha[OSD2] <<12;
	writel(data32, P_VIU_OSD2_CTRL_STAT);
	remove_from_update_list(OSD2,OSD_GBL_ALPHA);
}
static   void  osd2_update_order(void)
{
	_debug("\n");
	switch(osd_hw.osd_order)
	{
		case  OSD_ORDER_01:
		clrbits_le32(P_VPP_MISC,VPP_POST_FG_OSD2|VPP_PRE_FG_OSD2);
		break;
		case  OSD_ORDER_10:
		setbits_le32(P_VPP_MISC,VPP_POST_FG_OSD2|VPP_PRE_FG_OSD2);	
		break;
		default:
		break;
	}
	remove_from_update_list(OSD2, OSD_CHANGE_ORDER);
}
static   void  osd1_update_order(void)
{
	_debug("\n");
	switch(osd_hw.osd_order)
	{
		case  OSD_ORDER_01:
		clrbits_le32(P_VPP_MISC,VPP_POST_FG_OSD2|VPP_PRE_FG_OSD2);
		break;
		case  OSD_ORDER_10:
		setbits_le32(P_VPP_MISC,VPP_POST_FG_OSD2|VPP_PRE_FG_OSD2);	
		break;
		default:
		break;
	}
	remove_from_update_list(OSD1, OSD_CHANGE_ORDER);
}

static void osd_block_update_disp_geometry(u32 index)
{
	u32 data32;
	u32 data_w1, data_w2, data_w3, data_w4;
	u32 coef[4][2] = {{0, 0}, {1, 0}, {0, 1}, {1, 1}};
	u32 xoff, yoff;
	u32 i;
	_debug("\n");
	switch (osd_hw.block_mode[index] & HW_OSD_BLOCK_LAYOUT_MASK) {
		case HW_OSD_BLOCK_LAYOUT_HORIZONTAL:
			yoff = ((osd_hw.pandata[index].y_end & 0x1fff) - (osd_hw.pandata[index].y_start & 0x1fff) + 1) >> 2;
			data_w1 = (osd_hw.pandata[index].x_start & 0x1fff) | (osd_hw.pandata[index].x_end & 0x1fff) << 16 ;
			data_w3 = (osd_hw.dispdata[index].x_start & 0xfff) | (osd_hw.dispdata[index].x_end & 0xfff) << 16;
			for (i = 0; i < 4; i++) {
				if (i == 3) {
					data_w2 = ((osd_hw.pandata[index].y_start + yoff * i) & 0x1fff) 
						| (osd_hw.pandata[index].y_end & 0x1fff) << 16;
					data_w4 = ((osd_hw.dispdata[index].y_start + yoff * i) & 0xfff) 
						| (osd_hw.dispdata[index].y_end & 0xfff) << 16;
				} else {
					data_w2 = ((osd_hw.pandata[index].y_start + yoff * i) & 0x1fff) 
						| ((osd_hw.pandata[index].y_start + yoff * (i + 1) - 1) & 0x1fff) << 16;
					data_w4 = ((osd_hw.dispdata[index].y_start + yoff * i) & 0xfff) 
						| ((osd_hw.dispdata[index].y_start + yoff * (i + 1) - 1) & 0xfff) << 16;
				}
				if (osd_hw.scan_mode == SCAN_MODE_INTERLACE) {
					data32 = data_w4;
					data_w4 = ((data32 & 0xfff) >> 1) | ((((((data32 >> 16) & 0xfff) + 1) >> 1) - 1) << 16);
				}

				writel(data_w1, P_VIU_OSD1_BLK0_CFG_W1 + (i << 4));
				writel(data_w2, P_VIU_OSD1_BLK0_CFG_W2 + (i << 4));
				writel(data_w3, P_VIU_OSD1_BLK0_CFG_W3 + (i << 4));
				writel(data_w4, P_VIU_OSD1_BLK0_CFG_W4 + (i<<2));

				osd_hw.block_windows[index][i << 1] = data_w1;
				osd_hw.block_windows[index][(i << 1) + 1] = data_w2;
			}
			break;
		case HW_OSD_BLOCK_LAYOUT_VERTICAL:
			xoff = ((osd_hw.pandata[index].x_end & 0x1fff) - (osd_hw.pandata[index].x_start & 0x1fff) + 1) >> 2;
			data_w2 = (osd_hw.pandata[index].y_start & 0x1fff) | (osd_hw.pandata[index].y_end & 0x1fff) << 16 ;
			data_w4 = (osd_hw.dispdata[index].y_start & 0xfff) | (osd_hw.dispdata[index].y_end & 0xfff) << 16;
			if (osd_hw.scan_mode == SCAN_MODE_INTERLACE) {
				data32 = data_w4;
				data_w4 = ((data32 & 0xfff) >> 1) | ((((((data32 >> 16) & 0xfff) + 1) >> 1) - 1) << 16);
			}
			for (i = 0; i < 4; i++) {
				data_w1 = ((osd_hw.pandata[index].x_start  + xoff * i) & 0x1fff) 
					| ((osd_hw.pandata[index].x_start + xoff * (i + 1) - 1) & 0x1fff) << 16;
				data_w3 = ((osd_hw.dispdata[index].x_start + xoff * i) & 0xfff) 
					| ((osd_hw.dispdata[index].x_start + xoff * (i + 1) - 1) & 0xfff) << 16;

				writel(data_w1, P_VIU_OSD1_BLK0_CFG_W1 + (i << 4));
				writel(data_w2, P_VIU_OSD1_BLK0_CFG_W2 + (i << 4));
				writel(data_w3, P_VIU_OSD1_BLK0_CFG_W3 + (i << 4));
				writel(data_w4, P_VIU_OSD1_BLK0_CFG_W4 + (i<<2));

				osd_hw.block_windows[index][i << 1] = data_w1;
				osd_hw.block_windows[index][(i << 1) + 1] = data_w2;
			}
			break;
		case HW_OSD_BLOCK_LAYOUT_GRID:
			xoff = ((osd_hw.pandata[index].x_end & 0x1fff) - (osd_hw.pandata[index].x_start & 0x1fff) + 1) >> 1;
			yoff = ((osd_hw.pandata[index].y_end & 0x1fff) - (osd_hw.pandata[index].y_start & 0x1fff) + 1) >> 1;
			for (i = 0; i < 4; i++) {
				data_w1 = ((osd_hw.pandata[index].x_start + xoff * coef[i][0]) & 0x1fff) 
					| ((osd_hw.pandata[index].x_start + xoff * (coef[i][0] + 1) - 1) & 0x1fff) << 16;
				data_w2 = ((osd_hw.pandata[index].y_start + yoff * coef[i][1]) & 0x1fff) 
					| ((osd_hw.pandata[index].y_start + yoff * (coef[i][1] + 1) - 1) & 0x1fff) << 16;
				data_w3 = ((osd_hw.dispdata[index].x_start + xoff * coef[i][0]) & 0xfff) 
					| ((osd_hw.dispdata[index].x_start + xoff * (coef[i][0] + 1) - 1) & 0xfff) << 16;
				data_w4 = ((osd_hw.dispdata[index].y_start + yoff * coef[i][1]) & 0xfff) 
					| ((osd_hw.dispdata[index].y_start + yoff * (coef[i][1] + 1) - 1) & 0xfff) << 16;

				if (osd_hw.scan_mode == SCAN_MODE_INTERLACE) {
					data32 = data_w4;
					data_w4 = ((data32 & 0xfff) >> 1) | ((((((data32 >> 16) & 0xfff) + 1) >> 1) - 1) << 16);
				}
				writel(data_w1, P_VIU_OSD1_BLK0_CFG_W1 + (i << 4));
				writel(data_w2, P_VIU_OSD1_BLK0_CFG_W2 + (i << 4));
				writel(data_w3, P_VIU_OSD1_BLK0_CFG_W3 + (i << 4));
				writel(data_w4, P_VIU_OSD1_BLK0_CFG_W4 + (i<<2));

				osd_hw.block_windows[index][i << 1] = data_w1;
				osd_hw.block_windows[index][(i << 1) + 1] = data_w2;
			}
			break;
		case HW_OSD_BLOCK_LAYOUT_CUSTOMER:
			for (i = 0; i < 4; i++) {
				if (((osd_hw.block_windows[index][i << 1] >> 16) & 0x1fff) > osd_hw.pandata[index].x_end) {
					osd_hw.block_windows[index][i << 1] = (osd_hw.block_windows[index][i << 1] & 0x1fff)
						| ((osd_hw.pandata[index].x_end & 0x1fff) << 16);
				}
				data_w1 = osd_hw.block_windows[index][i << 1] & 0x1fff1fff;
				data_w2 = ((osd_hw.pandata[index].y_start & 0x1fff) + (osd_hw.block_windows[index][(i << 1) + 1] & 0x1fff))
					| (((osd_hw.pandata[index].y_start & 0x1fff) << 16) + (osd_hw.block_windows[index][(i << 1) + 1] & 0x1fff0000));
				data_w3 = (osd_hw.dispdata[index].x_start + (data_w1 & 0xfff)) 
					| (((osd_hw.dispdata[index].x_start & 0xfff) << 16) + (data_w1 & 0xfff0000));
				data_w4 = (osd_hw.dispdata[index].y_start + (osd_hw.block_windows[index][(i << 1) + 1] & 0xfff)) 
					| (((osd_hw.dispdata[index].y_start & 0xfff) << 16) + (osd_hw.block_windows[index][(i << 1) + 1] & 0xfff0000));
				if (osd_hw.scan_mode == SCAN_MODE_INTERLACE) {
					data32 = data_w4;
					data_w4 = ((data32 & 0xfff) >> 1) | ((((((data32 >> 16) & 0xfff) + 1) >> 1) - 1) << 16);
				}
				writel(data_w1, P_VIU_OSD1_BLK0_CFG_W1 + (i << 4));
				writel(data_w2, P_VIU_OSD1_BLK0_CFG_W2 + (i << 4));
				writel(data_w3, P_VIU_OSD1_BLK0_CFG_W3 + (i << 4));
				writel(data_w4, P_VIU_OSD1_BLK0_CFG_W4 + (i<<2));
			}
			break;

		default:
			_debug("ERROR block_mode: 0x%x\n", osd_hw.block_mode[index]);
			break;
	}
}

static void osd1_update_disp_geometry(void)
{
	u32 data32;
	_debug("\n");
	/* enable osd multi block */
	if (osd_hw.block_mode[OSD1]) {
		osd_block_update_disp_geometry(OSD1);
		data32 = readl(P_VIU_OSD1_CTRL_STAT);
		data32 &= 0xfffffff0;
		data32 |= (osd_hw.block_mode[OSD1] & HW_OSD_BLOCK_ENABLE_MASK);
		writel(data32, P_VIU_OSD1_CTRL_STAT);
	} else {
		data32 = (osd_hw.dispdata[OSD1].x_start& 0xfff) | (osd_hw.dispdata[OSD1].x_end & 0xfff) <<16 ;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W3 = %d(0x%08x)\n", data32, data32);
		writel(data32, P_VIU_OSD1_BLK0_CFG_W3);
		if (osd_hw.scan_mode == SCAN_MODE_INTERLACE) {
			data32 = ((osd_hw.dispdata[OSD1].y_start >> 1) & 0xfff) | ((((osd_hw.dispdata[OSD1].y_end+1) >> 1) - 1) & 0xfff) << 16 ;
		} else {
			data32 = (osd_hw.dispdata[OSD1].y_start & 0xfff) | (osd_hw.dispdata[OSD1].y_end & 0xfff) <<16 ;
		}
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W4 = %d(0x%08x)\n", data32, data32);
		writel(data32, P_VIU_OSD1_BLK0_CFG_W4);

		/* enable osd 2x scale */
		if (osd_hw.scale[OSD1].h_enable || osd_hw.scale[OSD1].v_enable) {
			data32 = (osd_hw.scaledata[OSD1].x_start & 0x1fff) | (osd_hw.scaledata[OSD1].x_end & 0x1fff) << 16;
			writel(data32, P_VIU_OSD1_BLK0_CFG_W1);
			data32 = ((osd_hw.scaledata[OSD1].y_start + osd_hw.pandata[OSD1].y_start) & 0x1fff)
					| ((osd_hw.scaledata[OSD1].y_end  + osd_hw.pandata[OSD1].y_start) & 0x1fff) << 16 ;
			writel(data32, P_VIU_OSD1_BLK0_CFG_W2);
		} else if (osd_hw.free_scale_enable[OSD1]
				&& (osd_hw.free_scale_data[OSD1].x_end > 0)
				&& (osd_hw.free_scale_data[OSD1].y_end > 0)) {
			/* enable osd free scale */
			data32 = (osd_hw.free_scale_data[OSD1].x_start & 0x1fff) | (osd_hw.free_scale_data[OSD1].x_end & 0x1fff) << 16;
			writel(data32, P_VIU_OSD1_BLK0_CFG_W1);
			data32 = ((osd_hw.free_scale_data[OSD1].y_start + osd_hw.pandata[OSD1].y_start) & 0x1fff)
					| ((osd_hw.free_scale_data[OSD1].y_end  + osd_hw.pandata[OSD1].y_start) & 0x1fff) << 16 ;
			writel(data32, P_VIU_OSD1_BLK0_CFG_W2);
		} else { 
			/* normal mode */
			data32 = (osd_hw.pandata[OSD1].x_start & 0x1fff) | (osd_hw.pandata[OSD1].x_end & 0x1fff) << 16;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W1 = %d(0x%08x)\n", data32, data32);
			writel(data32, P_VIU_OSD1_BLK0_CFG_W1);
			data32 = (osd_hw.pandata[OSD1].y_start & 0x1fff) | (osd_hw.pandata[OSD1].y_end & 0x1fff) << 16 ;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W2 = %d(0x%08x)\n", data32, data32);
			writel(data32, P_VIU_OSD1_BLK0_CFG_W2);
		}
		data32 = readl(P_VIU_OSD1_CTRL_STAT);
		data32 &= 0xfffffff0;
		data32 |= HW_OSD_BLOCK_ENABLE_0;
		writel(data32, P_VIU_OSD1_CTRL_STAT);
	}

	remove_from_update_list(OSD1,DISP_GEOMETRY);
}

static   void  osd2_update_disp_geometry(void)
{
	u32 data32;
   	data32 = (osd_hw.dispdata[OSD2].x_start& 0xfff) | (osd_hw.dispdata[OSD2].x_end & 0xfff) <<16 ;
	_debug("---VIU_OSD2_BLK0_CFG_W3 = %d(0x%08x)\n", data32, data32);
      	writel(data32, P_VIU_OSD2_BLK0_CFG_W3);
	if(osd_hw.scan_mode== SCAN_MODE_INTERLACE)
	{
		data32=((osd_hw.dispdata[OSD2].y_start >>1) & 0xfff) | ((((osd_hw.dispdata[OSD2].y_end+1)>>1)-1) & 0xfff) <<16 ;
	}
	else
	{
   		data32 = (osd_hw.dispdata[OSD2].y_start & 0xfff) | (osd_hw.dispdata[OSD2].y_end & 0xfff) <<16 ;
	}	
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W4 = %d(0x%08x)\n", data32, data32);
   	writel(data32, P_VIU_OSD2_BLK0_CFG_W4);

	if (osd_hw.scale[OSD2].h_enable || osd_hw.scale[OSD2].v_enable) {
#if defined(CONFIG_FB_OSD2_CURSOR)
		data32=(osd_hw.pandata[OSD2].x_start & 0x1fff) | (osd_hw.pandata[OSD2].x_end & 0x1fff) << 16;
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W1 = %d(0x%08x)\n", data32, data32);
		writel(data32, P_VIU_OSD2_BLK0_CFG_W1);
		data32=(osd_hw.pandata[OSD2].y_start & 0x1fff) | (osd_hw.pandata[OSD2].y_end & 0x1fff) << 16 ;
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W2 = %d(0x%08x)\n", data32, data32);
		writel(data32, P_VIU_OSD2_BLK0_CFG_W2);
#else
		data32 = (osd_hw.scaledata[OSD2].x_start & 0x1fff) | (osd_hw.scaledata[OSD2].x_end & 0x1fff) << 16;
		writel(data32, P_VIU_OSD2_BLK0_CFG_W1);
		data32 = ((osd_hw.scaledata[OSD2].y_start + osd_hw.pandata[OSD2].y_start) & 0x1fff)
				| ((osd_hw.scaledata[OSD2].y_end  + osd_hw.pandata[OSD2].y_start) & 0x1fff) << 16 ;
		writel(data32, P_VIU_OSD2_BLK0_CFG_W2);
#endif
	} else {
		data32=(osd_hw.pandata[OSD2].x_start & 0x1fff) | (osd_hw.pandata[OSD2].x_end & 0x1fff) << 16;
		writel(data32, P_VIU_OSD2_BLK0_CFG_W1);
		data32=(osd_hw.pandata[OSD2].y_start & 0x1fff) | (osd_hw.pandata[OSD2].y_end & 0x1fff) << 16 ;
		writel(data32, P_VIU_OSD2_BLK0_CFG_W2);
	}
	remove_from_update_list(OSD2,DISP_GEOMETRY);
}
static void osd1_update_disp_3d_mode(void)
{
	/*step 1 . set pan data */
	u32  data32;
	_debug("\n");
	if(osd_hw.mode_3d[OSD1].left_right==LEFT)
	{
		data32=(osd_hw.mode_3d[OSD1].l_start& 0x1fff) | (osd_hw.mode_3d[OSD1].l_end& 0x1fff) << 16;
		writel(data32, P_VIU_OSD1_BLK0_CFG_W1);
	}
	else
	{
		data32=(osd_hw.mode_3d[OSD1].r_start& 0x1fff) | (osd_hw.mode_3d[OSD1].r_end& 0x1fff) << 16;
		writel(data32, P_VIU_OSD1_BLK0_CFG_W1);		
	}
	osd_hw.mode_3d[OSD1].left_right^=1;
}
static  void  osd2_update_disp_3d_mode(void)
{
	u32  data32;
	_debug("\n");
	if(osd_hw.mode_3d[OSD2].left_right==LEFT)
	{
		data32=(osd_hw.mode_3d[OSD2].l_start& 0x1fff) | (osd_hw.mode_3d[OSD2].l_end& 0x1fff) << 16;
		writel(data32, P_VIU_OSD2_BLK0_CFG_W1);
	}
	else
	{
		data32=(osd_hw.mode_3d[OSD2].r_start& 0x1fff) | (osd_hw.mode_3d[OSD2].r_end& 0x1fff) << 16;
		writel(data32, P_VIU_OSD2_BLK0_CFG_W1);		
	}
	osd_hw.mode_3d[OSD2].left_right^=1;
}

void osd_init_hw(void)
{
	u32 group,idx,data32 = 0;
	_debug("\n");
	for(group=0;group<HW_OSD_COUNT;group++)
	{
		for(idx=0;idx<HW_REG_INDEX_MAX;idx++)
		{
			osd_hw.reg[group][idx].update_func = hw_func_array[group][idx];
		}
	}

	osd_hw.updated[OSD1]=0;
	osd_hw.updated[OSD2]=0;
	//here we will init default value ,these value only set once .
    #if defined (CONFIG_M6TVD)||defined(CONFIG_M6TV)
	setbits_le32(P_VPU_OSD1_MMC_CTRL, 1<<12); // set OSD to vdisp2
	writel(0xc01f,P_MMC_CHAN4_CTRL); // adjust vdisp weight and age limit
    #endif
	#if defined (CONFIG_M6TVD)||defined(CONFIG_M6TV)
	data32 |= 18  << 5;  // hold_fifo_lines
	#else
	data32 |= 4   << 5;  // hold_fifo_lines
	#endif
	data32 |= 3   << 10; // burst_len_sel: 3=64
	data32 |= 32  << 12; // fifo_depth_val: 32*8=256
	data32 |= 1 << 0;
	
	writel(data32, P_VIU_OSD1_FIFO_CTRL_STAT);
	writel(data32, P_VIU_OSD2_FIFO_CTRL_STAT);

	setbits_le32(P_VPP_MISC,VPP_OUT_SATURATE);
	
	setbits_le32(P_VPP_MISC,VPP_POSTBLEND_EN);
	clrbits_le32(P_VPP_MISC, VPP_PREBLEND_EN);  
	clrbits_le32(P_VPP_MISC,VPP_OSD1_POSTBLEND|VPP_OSD2_POSTBLEND );
	//data32  = 0x1          << 0; // osd_blk_enable
	#if defined (CONFIG_M6TVD)||defined(CONFIG_M6TV)
	data32 = 0x0 << 0; // osd_blk_enable
	#else
	data32 = 0x1 << 0;
	#endif
	data32 |= OSD_GLOBAL_ALPHA_DEF<< 12;
	data32 |= (1<<21)	;
	writel(data32, P_VIU_OSD1_CTRL_STAT);
	writel(data32, P_VIU_OSD2_CTRL_STAT);

	data32 = readl(P_VPP_OFIFO_SIZE);
	#ifdef CONFIG_M8
        data32 &= 0xffffe000; //0~13bit
        data32 |= 0x77f;
        #else
        data32 |= 0x300;  //0~12bit
        #endif
	writel(data32, P_VPP_OFIFO_SIZE);

#if defined(CONFIG_FB_OSD2_CURSOR)    
	setbits_le32(P_VPP_MISC, VPP_POST_FG_OSD2|VPP_PRE_FG_OSD2);
	osd_hw.osd_order=OSD_ORDER_10;
#else   
	clrbits_le32(P_VPP_MISC,VPP_POST_FG_OSD2|VPP_PRE_FG_OSD2);
	osd_hw.osd_order=OSD_ORDER_01;
#endif	
	//changed by Elvis Yu
	//CLEAR_MPEG_REG_MASK(VPP_MISC,VPP_OSD1_POSTBLEND|VPP_OSD2_POSTBLEND );
	clrbits_le32(P_VPP_MISC,
		VPP_OSD1_POSTBLEND|VPP_OSD2_POSTBLEND|VPP_VD1_POSTBLEND|VPP_VD2_POSTBLEND);
	_debug("READ_MPEG_REG(VPP_MISC) = 0x%08x\n", READ_MPEG_REG(VPP_MISC));
	
	osd_hw.enable[OSD2]=osd_hw.enable[OSD1]=DISABLE;
	osd_hw.fb_gem[OSD1].canvas_idx=OSD1_CANVAS_INDEX;
	osd_hw.fb_gem[OSD2].canvas_idx=OSD2_CANVAS_INDEX;
	osd_hw.gbl_alpha[OSD1]=OSD_GLOBAL_ALPHA_DEF;
	osd_hw.gbl_alpha[OSD2]=OSD_GLOBAL_ALPHA_DEF;
	osd_hw.color_info[OSD1]=NULL;
	osd_hw.color_info[OSD2]=NULL;
	vf.width =vf.height=0;
	osd_hw.color_key[OSD1]=osd_hw.color_key[OSD2]=0xffffffff;
	osd_hw.free_scale_enable[OSD1]=osd_hw.free_scale_enable[OSD2]=0;
	osd_hw.scale[OSD1].h_enable=osd_hw.scale[OSD1].v_enable=0;
	osd_hw.scale[OSD2].h_enable=osd_hw.scale[OSD2].v_enable=0;
	osd_hw.mode_3d[OSD2].enable=osd_hw.mode_3d[OSD1].enable=0;
	osd_hw.block_mode[OSD1] = osd_hw.block_mode[OSD2] = 0;

#if defined(CONFIG_AML_MESON_8)
	writel(0x00000000, P_HHI_VPU_MEM_PD_REG0);	
	writel(0x00000000, P_HHI_VPU_MEM_PD_REG1);
	writel(0x00000000, P_VPU_MEM_PD_REG0);
	writel(0x00000000, P_VPU_MEM_PD_REG1);
#endif
	
#ifdef FIQ_VSYNC
	osd_hw.fiq_handle_item.handle=vsync_isr;
	osd_hw.fiq_handle_item.key=(u32)vsync_isr;
	osd_hw.fiq_handle_item.name="osd_vsync";
	if(register_fiq_bridge_handle(&osd_hw.fiq_handle_item))	
#else
//	if ( request_irq(INT_VIU_VSYNC, &vsync_isr,
//		IRQF_SHARED , "am_osd_vsync", osd_setup))		comment out by Elvis Yu
#endif
	{
		_debug("can't request irq for vsync\r\n");
	}

#ifdef FIQ_VSYNC
    request_fiq(INT_VIU_VSYNC, &osd_fiq_isr);
#endif

	return ;
}


#if defined(CONFIG_FB_OSD2_CURSOR)
void osd_cursor_hw(s16 x, s16 y, s16 xstart, s16 ystart, u32 osd_w, u32 osd_h, int index)
{
	_debug("\n");
	if (index != 1) return;

	if (osd_hw.scale[OSD2].h_enable)
		x *= 2;
	if (osd_hw.scale[OSD2].v_enable)
		y *= 2;
	x += xstart;
	y += ystart;
	/**
	 * Use pandata to show a partial cursor when it is at the edge because the
	 * registers can't have negative values and because we need to manually
	 * clip the cursor when it is past the edge.  The edge is hardcoded
	 * to the OSD0 area.
	 */
	osd_hw.dispdata[OSD2].x_start = x;
	osd_hw.dispdata[OSD2].y_start = y;
	if (x < osd_hw.dispdata[OSD1].x_start) {
		// if negative position, set osd to 0,y and pan.
		if ((osd_hw.dispdata[OSD1].x_start - x) < osd_w) {
			osd_hw.pandata[OSD2].x_start = osd_hw.dispdata[OSD1].x_start - x;
			osd_hw.pandata[OSD2].x_end = osd_w - 1;
		}
		osd_hw.dispdata[OSD2].x_start = 0;
	} else {
		osd_hw.pandata[OSD2].x_start = 0;
		if (x + osd_w > osd_hw.dispdata[OSD1].x_end) {
			// if past positive edge, set osd to inside of the edge and pan.
			if (x < osd_hw.dispdata[OSD1].x_end)
				osd_hw.pandata[OSD2].x_end = osd_hw.dispdata[OSD1].x_end - x;
		} else {
			osd_hw.pandata[OSD2].x_end = osd_w - 1;
		}
	}
	if (y < osd_hw.dispdata[OSD1].y_start) {
		if ((osd_hw.dispdata[OSD1].y_start - y) < osd_h) {
			osd_hw.pandata[OSD2].y_start = osd_hw.dispdata[OSD1].y_start - y;
			osd_hw.pandata[OSD2].y_end = osd_h - 1;
		}
		osd_hw.dispdata[OSD2].y_start = 0;
	} else {
		osd_hw.pandata[OSD2].y_start = 0;
		if (y + osd_h > osd_hw.dispdata[OSD1].y_end) {
			if (y < osd_hw.dispdata[OSD1].y_end)
				osd_hw.pandata[OSD2].y_end = osd_hw.dispdata[OSD1].y_end - y;
		} else {
			osd_hw.pandata[OSD2].y_end = osd_h - 1;
		}
	}
	osd_hw.dispdata[OSD2].x_end = osd_hw.dispdata[OSD2].x_start + osd_hw.pandata[OSD2].x_end - osd_hw.pandata[OSD2].x_start;
	osd_hw.dispdata[OSD2].y_end = osd_hw.dispdata[OSD2].y_start + osd_hw.pandata[OSD2].y_end - osd_hw.pandata[OSD2].y_start;
	add_to_update_list(OSD2,DISP_GEOMETRY);
}
#endif //CONFIG_FB_OSD2_CURSOR

void  osd_suspend_hw(void)
{
	_debug("\n");
	osd_hw.reg_status_save = readl(P_VPP_MISC) & OSD_RELATIVE_BITS;

	clrbits_le32(P_VPP_MISC, OSD_RELATIVE_BITS);

	return ;
	
}
void osd_resume_hw(void)
{
	_debug("\n");
	setbits_le32(P_VPP_MISC, osd_hw.reg_status_save);
	
	return ;
}

