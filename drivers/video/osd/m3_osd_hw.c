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

//#define __DBG__OSD_HW__
#ifdef __DBG__OSD_HW__
#define _debug(fmt,args...) do { printf("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)
#else
#define _debug(fmt,args...)
#endif

//#define  FIQ_VSYNC

/**********************************************************************/
#if 0
static inline void  osd_update_3d_mode(int enable_osd1,int enable_osd2)
{
	if(enable_osd1)
	{
		osd1_update_disp_3d_mode();
	}
	if(enable_osd2)
	{
		osd2_update_disp_3d_mode();
	}
}

void  osd_set_gbl_alpha_hw(u32 index,u32 gbl_alpha)
{
	
	if(osd_hw.gbl_alpha[index] != gbl_alpha)
	{
		
		osd_hw.gbl_alpha[index]=gbl_alpha;
		add_to_update_list(index,OSD_GBL_ALPHA);
	}
}
u32  osd_get_gbl_alpha_hw(u32  index)
{
	return osd_hw.gbl_alpha[index];
}
void  osd_set_colorkey_hw(u32 index,u32 color_index,u32 colorkey )
{
	u8  r=0,g=0,b=0,a=(colorkey&0xff000000)>>24;
	u32	data32;

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
	}

	return ;
}
void  osd_srckey_enable_hw(u32  index,u8 enable)
{
	if(enable != osd_hw.color_key_enable[index])
	{
		osd_hw.color_key_enable[index]=enable;
		add_to_update_list(index,OSD_COLOR_KEY_ENABLE);
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
	if(memcmp(&pan_data,&osd_hw.pandata[index],sizeof(pandata_t))!= 0 ||
		memcmp(&disp_data,&osd_hw.dispdata[index],sizeof(dispdata_t))!=0)
	{
		memcpy(&osd_hw.pandata[index],&pan_data,sizeof(pandata_t));
		memcpy(&osd_hw.dispdata[index],&disp_data,sizeof(dispdata_t));
		add_to_update_list(index,DISP_GEOMETRY);
	}
}
#endif

void osd_setup(u32 xoffset,
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
		if(index == OSD1)
		{
                osd1_update_color_mode();
		}
		else
		{
                osd2_update_color_mode();
		}
	}
	if(osd_hw.enable[index] == DISABLE)
	{
		osd_hw.enable[index]=ENABLE;
		if(index == OSD1)
		{
			osd1_update_enable();
		}
		else
		{
			osd2_update_enable();
		}
		
	}
	if(memcmp(&pan_data,&osd_hw.pandata[index],sizeof(pandata_t))!= 0 ||
		memcmp(&disp_data,&osd_hw.dispdata[index],sizeof(dispdata_t))!=0)
	{
		memcpy(&osd_hw.pandata[index],&pan_data,sizeof(pandata_t));
		memcpy(&osd_hw.dispdata[index],&disp_data,sizeof(dispdata_t));
		if(index == OSD1)
		{
			osd1_update_disp_geometry();
		}
		else
		{
			osd2_update_disp_geometry();
		}
	}
}

#if	0
void osd_setpal_hw(unsigned regno,
                 unsigned red,
                 unsigned green,
                 unsigned blue,
                 unsigned transp,
                 int index 
                 )
{

    if (regno < 256) {
        u32 pal;
        pal = ((red   & 0xff) << 24) |
              ((green & 0xff) << 16) |
              ((blue  & 0xff) <<  8) |
              (transp & 0xff);

        WRITE_MPEG_REG(VIU_OSD1_COLOR_ADDR+REG_OFFSET*index, regno);
        WRITE_MPEG_REG(VIU_OSD1_COLOR+REG_OFFSET*index, pal);
    }
}
void osd_enable_3d_mode_hw(int index,int enable)
{
	spin_lock_irqsave(&osd_lock, lock_flags);
	osd_hw.mode_3d[index].enable=enable;
	spin_unlock_irqrestore(&osd_lock, lock_flags);
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
   	if(osd_hw.enable[index] != enable)
	{
		osd_hw.enable[index]=enable;
		add_to_update_list(index,OSD_ENABLE);
	}
}
void osd_set_2x_scale_hw(u32 index,u16 h_scale_enable,u16 v_scale_enable)
{
	osd_hw.scale[index].h_enable=h_scale_enable;
	osd_hw.scale[index].v_enable=v_scale_enable;
	add_to_update_list(index,DISP_SCALE_ENABLE);	
}
void osd_pan_display_hw(unsigned int xoffset, unsigned int yoffset,int index )
{
	long diff_x, diff_y;

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
		amlog_mask_level(LOG_MASK_HARDWARE,LOG_LEVEL_LOW,"offset[%d-%d]x[%d-%d]y[%d-%d]\n", \
				xoffset,yoffset,osd_hw.pandata[index].x_start ,osd_hw.pandata[index].x_end , \
				osd_hw.pandata[index].y_start ,osd_hw.pandata[index].y_end );
    	}
}
static  void  osd1_update_disp_scale_enable(void)
{
	if(osd_hw.scale[OSD1].h_enable)
	{
		SET_MPEG_REG_MASK(VIU_OSD1_BLK0_CFG_W0, 3<<12);
	}
	else
	{
		CLEAR_MPEG_REG_MASK(VIU_OSD1_BLK0_CFG_W0, 3<<12);
	}
	if(osd_hw.scan_mode != SCAN_MODE_INTERLACE)
	{
		if(osd_hw.scale[OSD1].v_enable)
		{
			SET_MPEG_REG_MASK(VIU_OSD1_BLK0_CFG_W0, 1<<14);
		}
		else
		{
			CLEAR_MPEG_REG_MASK(VIU_OSD1_BLK0_CFG_W0, 1<<14);
		}
	}	
}
static  void  osd2_update_disp_scale_enable(void)
{
	if(osd_hw.scale[OSD2].h_enable)
	{
		SET_MPEG_REG_MASK(VIU_OSD2_BLK0_CFG_W0, 3<<12);
	}
	else
	{
		CLEAR_MPEG_REG_MASK(VIU_OSD2_BLK0_CFG_W0, 3<<12);
	}
	if(osd_hw.scan_mode != SCAN_MODE_INTERLACE)
	{
		if(osd_hw.scale[OSD2].v_enable)
		{
			SET_MPEG_REG_MASK(VIU_OSD2_BLK0_CFG_W0, 1<<14);
		}
		else
		{
			CLEAR_MPEG_REG_MASK(VIU_OSD2_BLK0_CFG_W0, 1<<14);
		}
	}
	
}
#endif

static  inline void  osd1_update_color_mode(void)
{
	u32  data32;

	data32= (osd_hw.scan_mode== SCAN_MODE_INTERLACE) ? 2 : 0;
	data32 |=READ_MPEG_REG(VIU_OSD1_BLK0_CFG_W0)&0x40;
	data32 |= osd_hw.fb_gem[OSD1].canvas_idx << 16 ;
	data32 |= OSD_DATA_LITTLE_ENDIAN	 <<15 ;
    	data32 |= osd_hw.color_info[OSD1]->hw_colormat<< 2;	
	if(osd_hw.color_info[OSD1]->hw_colormat < COLOR_INDEX_YUV_422)
	data32 |= 1                      << 7; /* rgb enable */
	data32 |=  osd_hw.color_info[OSD1]->hw_blkmode<< 8; /* osd_blk_mode */
    _debug("osd1_update_color_mode---VIU_OSD1_BLK0_CFG_W0 = %d(0x%08x)\n", data32, data32);
    WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W0, data32);
	//remove_from_update_list(OSD1,OSD_COLOR_MODE);
	
}
static  inline void  osd2_update_color_mode(void)
{
	u32  data32;
	_debug("osd2 update color mode\n") ;
	data32= (osd_hw.scan_mode== SCAN_MODE_INTERLACE) ? 2 : 0;
	data32 |=READ_MPEG_REG(VIU_OSD2_BLK0_CFG_W0)&0x40;
	data32 |= osd_hw.fb_gem[OSD2].canvas_idx << 16 ;
	data32 |= OSD_DATA_LITTLE_ENDIAN	 <<15 ;
    	data32 |= osd_hw.color_info[OSD2]->hw_colormat<< 2;	
	if(osd_hw.color_info[OSD2]->hw_colormat < COLOR_INDEX_YUV_422)
	data32 |= 1                      << 7; /* rgb enable */
	data32 |=  osd_hw.color_info[OSD2]->hw_blkmode<< 8; /* osd_blk_mode */
    _debug("osd2_update_color_mode---VIU_OSD2_BLK0_CFG_W0 = %d(0x%08x)\n", data32, data32);
    WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W0, data32);
	//remove_from_update_list(OSD2,OSD_COLOR_MODE);
}

static inline  void  osd1_update_enable(void)
{
    _debug("osd1_update_enable---osd_hw.enable[OSD1] = %d(0x%08x)\n", osd_hw.enable[OSD1], osd_hw.enable[OSD1]);
    if(osd_hw.enable[OSD1]==ENABLE)
	{
		SET_MPEG_REG_MASK(VPP_MISC,VPP_OSD1_POSTBLEND);
	}
	else
	{
		CLEAR_MPEG_REG_MASK(VPP_MISC,VPP_OSD1_POSTBLEND);
	}
	//remove_from_update_list(OSD1,OSD_ENABLE);
}
static inline  void  osd2_update_enable(void)
{
    _debug("osd2_update_enable---osd_hw.enable[OSD2] = %d(0x%08x)\n", osd_hw.enable[OSD2], osd_hw.enable[OSD2]);
    if(osd_hw.enable[OSD2]==ENABLE)
	{
		SET_MPEG_REG_MASK(VPP_MISC,VPP_OSD2_POSTBLEND);
	}
	else
	{
		CLEAR_MPEG_REG_MASK(VPP_MISC,VPP_OSD2_POSTBLEND);
	}
	//remove_from_update_list(OSD2,OSD_ENABLE);
}

#if	0
static inline void  osd1_update_color_key(void)
{
	WRITE_MPEG_REG(VIU_OSD1_TCOLOR_AG0,osd_hw.color_key[OSD1]);
	remove_from_update_list(OSD1,OSD_COLOR_KEY);
}
static inline  void  osd2_update_color_key(void)
{
	WRITE_MPEG_REG(VIU_OSD2_TCOLOR_AG0,osd_hw.color_key[OSD2]);
	remove_from_update_list(OSD2,OSD_COLOR_KEY);
}
static inline void  osd1_update_color_key_enable(void)
{
	u32  data32;

	data32=READ_MPEG_REG(VIU_OSD1_BLK0_CFG_W0);
	data32&=~(1<<6);
	data32|=(osd_hw.color_key_enable[OSD1]<<6);
	WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W0,data32);
	remove_from_update_list(OSD1,OSD_COLOR_KEY_ENABLE);
}
static inline void  osd2_update_color_key_enable(void)
{
	u32  data32;

	data32=READ_MPEG_REG(VIU_OSD2_BLK0_CFG_W0);
	data32&=~(1<<6);
	data32|=(osd_hw.color_key_enable[OSD2]<<6);
	WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W0,data32);
	remove_from_update_list(OSD2,OSD_COLOR_KEY_ENABLE);
}
static inline  void  osd1_update_gbl_alpha(void)
{

	u32  data32=READ_MPEG_REG(VIU_OSD1_CTRL_STAT);
	data32&=~(0x1ff<<12);
	data32|=osd_hw.gbl_alpha[OSD1] <<12;
	WRITE_MPEG_REG(VIU_OSD1_CTRL_STAT,data32);
	remove_from_update_list(OSD1,OSD_GBL_ALPHA);
}
static inline  void  osd2_update_gbl_alpha(void)
{

	u32  data32=READ_MPEG_REG(VIU_OSD2_CTRL_STAT);
	data32&=~(0x1ff<<12);
	data32|=osd_hw.gbl_alpha[OSD2] <<12;
	WRITE_MPEG_REG(VIU_OSD2_CTRL_STAT,data32);
	remove_from_update_list(OSD2,OSD_GBL_ALPHA);
}
#endif

static inline  void  osd1_update_disp_geometry(void)
{
	u32 data32;
   	data32 = (osd_hw.dispdata[OSD1].x_start& 0xfff) | (osd_hw.dispdata[OSD1].x_end & 0xfff) <<16 ;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W3 = %d(0x%08x)\n", data32, data32);
    WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W3 , data32);
    data32 = (osd_hw.dispdata[OSD1].y_start & 0xfff) | (osd_hw.dispdata[OSD1].y_end & 0xfff) <<16 ;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W4 = %d(0x%08x)\n", data32, data32);
    WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W4, data32);

    data32=(osd_hw.pandata[OSD1].x_start & 0x1fff) | (osd_hw.pandata[OSD1].x_end & 0x1fff) << 16;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W1 = %d(0x%08x)\n", data32, data32);
    WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W1,data32);
    data32=(osd_hw.pandata[OSD1].y_start & 0x1fff) | (osd_hw.pandata[OSD1].y_end & 0x1fff) << 16 ;
    _debug("osd1_update_disp_geometry---VIU_OSD1_BLK0_CFG_W2 = %d(0x%08x)\n", data32, data32);
    WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W2,data32);
	//remove_from_update_list(OSD1,DISP_GEOMETRY);
}
static inline  void  osd2_update_disp_geometry(void)
{
	u32 data32;
   	data32 = (osd_hw.dispdata[OSD2].x_start& 0xfff) | (osd_hw.dispdata[OSD2].x_end & 0xfff) <<16 ;
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W3 = %d(0x%08x)\n", data32, data32);
	WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W3 , data32);
   	data32 = (osd_hw.dispdata[OSD2].y_start & 0xfff) | (osd_hw.dispdata[OSD2].y_end & 0xfff) <<16 ;
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W4 = %d(0x%08x)\n", data32, data32);
   	WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W4, data32);

	data32=(osd_hw.pandata[OSD2].x_start & 0x1fff) | (osd_hw.pandata[OSD2].x_end & 0x1fff) << 16;
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W1 = %d(0x%08x)\n", data32, data32);
	WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W1,data32);
	data32=(osd_hw.pandata[OSD2].y_start & 0x1fff) | (osd_hw.pandata[OSD2].y_end & 0x1fff) << 16 ;
	_debug("osd2_update_disp_geometry---VIU_OSD2_BLK0_CFG_W2 = %d(0x%08x)\n", data32, data32);
	WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W2,data32);
	//remove_from_update_list(OSD2,DISP_GEOMETRY);
}

#if	0
static  void  osd1_update_disp_3d_mode(void)
{
	/*step 1 . set pan data */
	u32  data32;
	
	if(osd_hw.mode_3d[OSD1].left_right==LEFT)
	{
		data32=(osd_hw.mode_3d[OSD1].l_start& 0x1fff) | (osd_hw.mode_3d[OSD1].l_end& 0x1fff) << 16;
		WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W1,data32);
	}
	else
	{
		data32=(osd_hw.mode_3d[OSD1].r_start& 0x1fff) | (osd_hw.mode_3d[OSD1].r_end& 0x1fff) << 16;
		WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W1,data32);		
	}
	osd_hw.mode_3d[OSD1].left_right^=1;
}
static  void  osd2_update_disp_3d_mode(void)
{
	u32  data32;
	
	if(osd_hw.mode_3d[OSD2].left_right==LEFT)
	{
		data32=(osd_hw.mode_3d[OSD2].l_start& 0x1fff) | (osd_hw.mode_3d[OSD2].l_end& 0x1fff) << 16;
		WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W1,data32);
	}
	else
	{
		data32=(osd_hw.mode_3d[OSD2].r_start& 0x1fff) | (osd_hw.mode_3d[OSD2].r_end& 0x1fff) << 16;
		WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W1,data32);		
	}
	osd_hw.mode_3d[OSD2].left_right^=1;
}
#endif

void osd_init_hw(void)
{
	u32 group,idx,data32;
	
	for(group=0;group<HW_OSD_COUNT;group++)
	for(idx=0;idx<HW_REG_INDEX_MAX;idx++)
	{
		osd_hw.reg[group][idx].update_func=hw_func_array[group][idx];
	}
	//here we will init default value ,these value only set once .
    	data32  = 4   << 5;  // hold_fifo_lines
    	data32 |= 3   << 10; // burst_len_sel: 3=64
    	data32 |= 32  << 12; // fifo_depth_val: 32*8=256
    	
    	WRITE_MPEG_REG(VIU_OSD1_FIFO_CTRL_STAT, data32);
	WRITE_MPEG_REG(VIU_OSD2_FIFO_CTRL_STAT, data32);

	SET_MPEG_REG_MASK(VPP_MISC,VPP_POSTBLEND_EN);
	CLEAR_MPEG_REG_MASK(VPP_MISC, VPP_PREBLEND_EN);  
#if defined(CONFIG_FB_OSD2_CURSOR)    
	SET_MPEG_REG_MASK(VPP_MISC, VPP_POST_FG_OSD2);
#else   
	CLEAR_MPEG_REG_MASK(VPP_MISC,VPP_POST_FG_OSD2);
#endif	
	//changed by Elvis Yu
	//CLEAR_MPEG_REG_MASK(VPP_MISC,VPP_OSD1_POSTBLEND|VPP_OSD2_POSTBLEND );
	CLEAR_MPEG_REG_MASK(VPP_MISC,VPP_OSD1_POSTBLEND|VPP_OSD2_POSTBLEND
		|VPP_VD1_POSTBLEND|VPP_VD2_POSTBLEND);
	_debug("READ_MPEG_REG(VPP_MISC) = 0x%08x\n", READ_MPEG_REG(VPP_MISC));
	
	osd_hw.enable[OSD2]=osd_hw.enable[OSD1]=DISABLE;
	osd_hw.fb_gem[OSD1].canvas_idx=OSD1_CANVAS_INDEX;
	osd_hw.fb_gem[OSD2].canvas_idx=OSD2_CANVAS_INDEX;
	osd_hw.gbl_alpha[OSD1]=OSD_GLOBAL_ALPHA_DEF;
	osd_hw.gbl_alpha[OSD2]=OSD_GLOBAL_ALPHA_DEF;
	osd_hw.color_info[OSD1]=NULL;
	osd_hw.color_info[OSD2]=NULL;
	osd_hw.color_key[OSD1]=osd_hw.color_key[OSD2]=0xffffffff;
	osd_hw.scale[OSD1].h_enable=osd_hw.scale[OSD1].v_enable=0;
	osd_hw.scale[OSD2].h_enable=osd_hw.scale[OSD2].v_enable=0;
	osd_hw.mode_3d[OSD2].enable=osd_hw.mode_3d[OSD1].enable=0;
	osd_hw.scan_mode = SCAN_MODE_PROGRESSIVE;	//you should best add define---Elvis
	data32  = 0x1          << 0; // osd_blk_enable
    	data32 |= OSD_GLOBAL_ALPHA_DEF<< 12;
	data32 |= (1<<21)	;
    	WRITE_MPEG_REG(VIU_OSD1_CTRL_STAT , data32);
	WRITE_MPEG_REG(VIU_OSD2_CTRL_STAT , data32);

	return;
	
}

#if	0
#if defined(CONFIG_FB_OSD2_CURSOR)
void osd_cursor_hw(s16 x, s16 y, u32 osd_w, u32 osd_h, int index)
{
	if (index != 1) return;

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
	u32 i,j;
	u32 data;
	u32  *preg;
	
	//save all status
	osd_hw.reg_status=(u32*)kmalloc(sizeof(u32)*RESTORE_MEMORY_SIZE,GFP_KERNEL);
	if(IS_ERR (osd_hw.reg_status))
	{
		amlog_level(LOG_LEVEL_HIGH,"can't alloc restore memory\r\n");
		return ;
	}
	preg=osd_hw.reg_status;
	for(i=0;i<ARRAY_SIZE(reg_index);i++)
	{
		switch(reg_index[i])
		{
			case VPP_MISC:
			data=READ_MPEG_REG(VPP_MISC);
			*preg=data&OSD_RELATIVE_BITS; //0x333f0 is osd0&osd1 relative bits
			WRITE_MPEG_REG(VPP_MISC,data&(~OSD_RELATIVE_BITS));
			break;
			case VIU_OSD1_BLK0_CFG_W4:
			data=READ_MPEG_REG(VIU_OSD1_BLK0_CFG_W4);
			*preg=data;
			data=READ_MPEG_REG(VIU_OSD2_BLK0_CFG_W4);
			*(preg+OSD1_OSD2_SOTRE_OFFSET)=data;
			break;
			case VIU_OSD1_COLOR_ADDR: //resotre palette value
			for(j=0;j<256;j++)
			{
				WRITE_MPEG_REG(VIU_OSD1_COLOR_ADDR, 1<<8|j);
				*preg=READ_MPEG_REG(VIU_OSD1_COLOR);
				WRITE_MPEG_REG(VIU_OSD1_COLOR_ADDR+REG_OFFSET, 1<<8|j);
				*(preg+OSD1_OSD2_SOTRE_OFFSET)=READ_MPEG_REG(VIU_OSD1_COLOR+REG_OFFSET);
				preg++;
			}
			break;
			default :
			data=READ_MPEG_REG(reg_index[i]);
			*preg=data;
			break;
		}
		preg++;
	}
	//disable osd relative clock
	return ;
	
}
void osd_resume_hw(void)
{
	u32 i,j;
	u32  *preg;

	// enable osd relative clock	
	//restore status
	if(osd_hw.reg_status)
	{
		preg=osd_hw.reg_status;
		for(i=0;i<ARRAY_SIZE(reg_index);i++)
		{
			switch(reg_index[i])
			{
	       			case VPP_MISC:
	       			SET_MPEG_REG_MASK(VPP_MISC,*preg);
				break;
				case VIU_OSD1_BLK0_CFG_W4:
				WRITE_MPEG_REG(VIU_OSD1_BLK0_CFG_W4,*preg);
				WRITE_MPEG_REG(VIU_OSD2_BLK0_CFG_W4,*(preg+OSD1_OSD2_SOTRE_OFFSET));
				break;
				case VIU_OSD1_COLOR_ADDR: //resotre palette value
				for(j=0;j<256;j++)
				{
					WRITE_MPEG_REG(VIU_OSD1_COLOR_ADDR, j);
					WRITE_MPEG_REG(VIU_OSD1_COLOR,*preg);
					WRITE_MPEG_REG(VIU_OSD1_COLOR_ADDR+REG_OFFSET, j);
					WRITE_MPEG_REG(VIU_OSD1_COLOR+REG_OFFSET,*(preg+OSD1_OSD2_SOTRE_OFFSET));
					preg++;
				}
				break;
				default :
				WRITE_MPEG_REG(reg_index[i],*preg);
				break;
			}
			preg++;
		}
		kfree(osd_hw.reg_status);
		// osd relative clock	
	}
	
	return ;
}
#endif
