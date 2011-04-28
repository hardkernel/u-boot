/*
 * AMLOGIC Canvas management driver.
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
#include <asm/arch/canvas.h>
#include <asm/arch/canvas_missed_define.h>

//#define __DBG__CANVAS__
#ifdef __DBG__CANVAS__
#define _debug(fmt,args...) do { printf("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)
#else
#define _debug(fmt,args...)
#endif

#define CANVAS_NUM	192

static canvas_t canvasPool[CANVAS_NUM];

void canvas_config(u32 index, ulong addr, u32 width,
				  u32 height, u32 wrap, u32 blkmode)
{
    //ulong flags;
    canvas_t *canvasP = &canvasPool[index];

    if (index >= CANVAS_NUM)
		return;

    _debug("index=%d, addr=0x%08x width=%d, height=%d wrap=%d, blkmode=%d \n",
        index, addr, width, height, wrap, blkmode);

#ifdef CONFIG_M8
    if(IS_MESON_M8M2_CPU){
        writel((((addr + 7) >> 3) & CANVAS_ADDR_LMASK) |
    					((((width + 7) >> 3) & CANVAS_WIDTH_LMASK) << CANVAS_WIDTH_LBIT)
    					, M8M2_P_DC_CAV_LUT_DATAL);
        writel(((((width + 7) >> 3) >> CANVAS_WIDTH_LWID) << CANVAS_WIDTH_HBIT) |
    					((height & CANVAS_HEIGHT_MASK) << CANVAS_HEIGHT_BIT)	|
    					((wrap & CANVAS_XWRAP) ? CANVAS_XWRAP : 0)              |
    					((wrap & CANVAS_YWRAP) ? CANVAS_YWRAP : 0)              |
    					((blkmode & CANVAS_BLKMODE_MASK) << CANVAS_BLKMODE_BIT)
    					, M8M2_P_DC_CAV_LUT_DATAH);
        writel(CANVAS_LUT_WR_EN | index, M8M2_P_DC_CAV_LUT_ADDR);
    	// read a cbus to make sure last write finish.
        readl(M8M2_P_DC_CAV_LUT_DATAH);
    }
    else
#endif
    {
        writel((((addr + 7) >> 3) & CANVAS_ADDR_LMASK) |
                        ((((width + 7) >> 3) & CANVAS_WIDTH_LMASK) << CANVAS_WIDTH_LBIT)
                        , P_DC_CAV_LUT_DATAL);
        writel(((((width + 7) >> 3) >> CANVAS_WIDTH_LWID) << CANVAS_WIDTH_HBIT) |
                        ((height & CANVAS_HEIGHT_MASK) << CANVAS_HEIGHT_BIT)    |
                        ((wrap & CANVAS_XWRAP) ? CANVAS_XWRAP : 0)              |
                        ((wrap & CANVAS_YWRAP) ? CANVAS_YWRAP : 0)              |
                        ((blkmode & CANVAS_BLKMODE_MASK) << CANVAS_BLKMODE_BIT)
                        , P_DC_CAV_LUT_DATAH);
        writel(CANVAS_LUT_WR_EN | index, P_DC_CAV_LUT_ADDR);
        // read a cbus to make sure last write finish.
        readl(P_DC_CAV_LUT_DATAH);
    }
	
	canvasP->addr = addr;
	canvasP->width = width;
	canvasP->height = height;
	canvasP->wrap = wrap;
	canvasP->blkmode = blkmode;

}

void canvas_read(u32 index, canvas_t *p)
{
	if (index < CANVAS_NUM)
		*p = canvasPool[index];
}

void canvas_copy(u32 src, u32 dst)
{
    unsigned long addr;
    unsigned width, height, wrap, blkmode;
    //ulong flags;

    if ((src >= CANVAS_NUM) || (dst >= CANVAS_NUM))
        return;
    
    addr = canvasPool[src].addr;
    width = canvasPool[src].width;
    height = canvasPool[src].height;
    wrap = canvasPool[src].wrap;
    blkmode = canvasPool[src].blkmode;

#ifdef CONFIG_M8 /*M8 series unify code*/
    if(IS_MESON_M8M2_CPU){
        writel((((addr + 7) >> 3) & CANVAS_ADDR_LMASK) |
            ((((width + 7) >> 3) & CANVAS_WIDTH_LMASK) << CANVAS_WIDTH_LBIT)
            , M8M2_P_DC_CAV_LUT_DATAL);
        writel(((((width + 7) >> 3) >> CANVAS_WIDTH_LWID) << CANVAS_WIDTH_HBIT) |
            ((height & CANVAS_HEIGHT_MASK) << CANVAS_HEIGHT_BIT)    |
            ((wrap & CANVAS_XWRAP) ? CANVAS_XWRAP : 0)              | 
            ((wrap & CANVAS_YWRAP) ? CANVAS_YWRAP : 0)              | 
            ((blkmode & CANVAS_BLKMODE_MASK) << CANVAS_BLKMODE_BIT)
            , M8M2_P_DC_CAV_LUT_DATAH);
        writel(CANVAS_LUT_WR_EN | dst, M8M2_P_DC_CAV_LUT_ADDR);
        // read a cbus to make sure last write finish.
        readl(M8M2_P_DC_CAV_LUT_DATAH);
    }
    else
#endif
    {
        writel((((addr + 7) >> 3) & CANVAS_ADDR_LMASK) |
            ((((width + 7) >> 3) & CANVAS_WIDTH_LMASK) << CANVAS_WIDTH_LBIT)
            , P_DC_CAV_LUT_DATAL);
        writel(((((width + 7) >> 3) >> CANVAS_WIDTH_LWID) << CANVAS_WIDTH_HBIT) |
            ((height & CANVAS_HEIGHT_MASK) << CANVAS_HEIGHT_BIT)    |
            ((wrap & CANVAS_XWRAP) ? CANVAS_XWRAP : 0)              | 
            ((wrap & CANVAS_YWRAP) ? CANVAS_YWRAP : 0)              | 
            ((blkmode & CANVAS_BLKMODE_MASK) << CANVAS_BLKMODE_BIT)
            , P_DC_CAV_LUT_DATAH);
        writel(CANVAS_LUT_WR_EN | dst, P_DC_CAV_LUT_ADDR);
        // read a cbus to make sure last write finish.
        readl(P_DC_CAV_LUT_DATAH);
    }
    
    canvasPool[dst].addr = addr;
    canvasPool[dst].width = width;
    canvasPool[dst].height = height;
    canvasPool[dst].wrap = wrap;
    canvasPool[dst].blkmode = blkmode;
    
    return;
}

void canvas_update_addr(u32 index, u32 addr)
{
    //ulong flags;
    
    if (index >= CANVAS_NUM)
        return;

    canvasPool[index].addr = addr;

#ifdef CONFIG_M8
    if(IS_MESON_M8M2_CPU){
        writel((((canvasPool[index].addr + 7) >> 3) & CANVAS_ADDR_LMASK) |
            ((((canvasPool[index].width + 7) >> 3) & CANVAS_WIDTH_LMASK) << CANVAS_WIDTH_LBIT)
            , M8M2_P_DC_CAV_LUT_DATAL);
        writel(((((canvasPool[index].width + 7) >> 3) >> CANVAS_WIDTH_LWID) << CANVAS_WIDTH_HBIT) |
            ((canvasPool[index].height & CANVAS_HEIGHT_MASK) << CANVAS_HEIGHT_BIT)   |
            ((canvasPool[index].wrap & CANVAS_XWRAP) ? CANVAS_XWRAP : 0)             | 
            ((canvasPool[index].wrap & CANVAS_YWRAP) ? CANVAS_YWRAP : 0)             | 
            ((canvasPool[index].blkmode & CANVAS_BLKMODE_MASK) << CANVAS_BLKMODE_BIT)
            , M8M2_P_DC_CAV_LUT_DATAH);
        writel(CANVAS_LUT_WR_EN | index, M8M2_P_DC_CAV_LUT_ADDR);
        // read a cbus to make sure last write finish.
        readl(M8M2_P_DC_CAV_LUT_DATAH);
    }
    else
#endif
    {
        writel((((canvasPool[index].addr + 7) >> 3) & CANVAS_ADDR_LMASK) |
            ((((canvasPool[index].width + 7) >> 3) & CANVAS_WIDTH_LMASK) << CANVAS_WIDTH_LBIT)
            , P_DC_CAV_LUT_DATAL);
        writel(((((canvasPool[index].width + 7) >> 3) >> CANVAS_WIDTH_LWID) << CANVAS_WIDTH_HBIT) |
            ((canvasPool[index].height & CANVAS_HEIGHT_MASK) << CANVAS_HEIGHT_BIT)   |
            ((canvasPool[index].wrap & CANVAS_XWRAP) ? CANVAS_XWRAP : 0)             | 
            ((canvasPool[index].wrap & CANVAS_YWRAP) ? CANVAS_YWRAP : 0)             | 
            ((canvasPool[index].blkmode & CANVAS_BLKMODE_MASK) << CANVAS_BLKMODE_BIT)
            , P_DC_CAV_LUT_DATAH);
        writel(CANVAS_LUT_WR_EN | index, P_DC_CAV_LUT_ADDR);
        // read a cbus to make sure last write finish.
        readl(P_DC_CAV_LUT_DATAH);
    }

    return;
}

unsigned int canvas_get_addr(u32 index)
{
    return canvasPool[index].addr;
}
