/*
 *  Copyright (C) 2010 AMLOGIC, INC.
 *
 *  Y:\arch\arm\cpu\aml_meson\m1\clock.c
 * 
 *
 * License terms: GNU General Public License (GPL) version 2
 * Basic register address definitions in physical memory and
 * some block defintions for core devices like the timer.
 * 03/06/10
 *
 * author : jerry.yu
 */
#include <config.h>
#include <asm/arch/io.h> 
#include <asm/arch/clock.h>

/*
	romboot_info->sys_clk=500000000;
    romboot_info->arm_clk=500000000;
    romboot_info->mpeg_clk=200000000;
*/
//T_ROM_BOOT_RETURN_INFO * romboot_info=(const T_ROM_BOOT_RETURN_INFO *)C_ROM_BOOT_DEBUG;
#define CLK_UNKNOWN (0xffffffff)
static unsigned msrclk[32]={
    [CLK_OTHER_PLL_CLK]=CLK_UNKNOWN,
};
static unsigned long    clk_util_clk_msr( unsigned long   clk_mux )
{

	writel(0,P_MSR_CLK_REG0);
    // Set the measurement gate to 64uS
	clrsetbits_le32(P_MSR_CLK_REG0,0xffff,64-1);
    // Disable continuous measurement
    // disable interrupts
    clrbits_le32(P_MSR_CLK_REG0,((1 << 18) | (1 << 17)));
	clrsetbits_le32(P_MSR_CLK_REG0,(0xf<<20),(clk_mux<<20)|(1<<19)|(1<<16));

	{ readl(P_MSR_CLK_REG0); }
    // Wait for the measurement to be done
    while( readl(P_MSR_CLK_REG0) & (1 << 31))  {};
    // disable measuring
	clrbits_le32(P_MSR_CLK_REG0,(1 << 16));
    // Return value in MHz
    return (readl(P_MSR_CLK_REG2)>>6);
}
static unsigned do_get_clk_rate(unsigned clksrc)
{
    if(msrclk[clksrc]==CLK_UNKNOWN)
        msrclk[clksrc]=clk_util_clk_msr(clksrc);
    
    return msrclk[clksrc]*1000000;
}
struct __clk_rate{
    unsigned clksrc;
    unsigned long(*get_rate)(void);
};

unsigned long get_clk81(void)
{
	if((readl(P_HHI_MPEG_CLK_CNTL)&(1<<8))==0)
	{
		return CONFIG_CRYSTAL_MHZ*1000000;
	}
    return (do_get_clk_rate(CLK_OTHER_PLL_CLK))/((readl(P_HHI_MPEG_CLK_CNTL)&0x7f)+1);
}
struct __clk_rate clkrate[]={
    {
        .clksrc=CLK_CLK81,
        .get_rate=get_clk81
    }
    
};
#if 0
unsigned long get_cpu_clk()
{
     /*
    @todo implement this function
    */
    return romboot_info->a9_clk;
}
#endif

int clk_get_rate(unsigned clksrc)
{
    int i;
    if(clksrc<32)
    {
        if(msrclk[clksrc])
            return do_get_clk_rate(clksrc);
        return -1;
    }
    for(i=0;sizeof(clkrate)/sizeof(clkrate[0]);i++)
    {
        return clkrate[i].get_rate();
    }
    
    return -1;
}



