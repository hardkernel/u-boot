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

/*  !!must use nonzero value as default value. Otherwise it linked to bss segment,
    but this segment not cleared to zero while running "board_init_f" */
#define CLK_UNKNOWN (0xffffffff)

__u32 get_rate_xtal(void)
{
	unsigned long clk;
	clk = (readl(P_PREG_CTLREG0_ADDR) >> 4) & 0x3f;
	clk = clk * 1000 * 1000;
	return clk;
}


__u32 get_cpu_clk(void)
{
    static __u32 sys_freq=CLK_UNKNOWN;
    if(sys_freq==CLK_UNKNOWN)
    {
        sys_freq=(clk_util_clk_msr(SYS_PLL_CLK)*1000000);
    }
    return sys_freq;
}
__u32 get_clk81(void)
{
	static __u32 clk81_freq=CLK_UNKNOWN;
	if(clk81_freq==CLK_UNKNOWN)
	{
	    clk81_freq=(clk_util_clk_msr(CLK81)*1000000);
	}
    return clk81_freq;
}
__u32 get_clk_ddr(void)
{
   static __u32 freq=CLK_UNKNOWN;
	if(freq==CLK_UNKNOWN)
	{
	    freq=(clk_util_clk_msr(DDR_PLL_CLK)*1000000);
	}
    return freq;
}

__u32 get_clk_ethernet_pad(void)
{
    static __u32 freq=CLK_UNKNOWN;
    if(freq==CLK_UNKNOWN)
    {
        freq=(clk_util_clk_msr(MOD_ETH_CLK50_I)*1000000);
    }
    return freq;
}

__u32 get_clk_cts_eth_rmii(void)
{
    static __u32 freq=CLK_UNKNOWN;
    if(freq==CLK_UNKNOWN)
    {
        freq=(clk_util_clk_msr(CTS_ETH_RMII)*1000000);
    }
    return freq;
}

__u32 get_misc_pll_clk(void)
{
    static __u32 freq=CLK_UNKNOWN;
    if(freq==CLK_UNKNOWN)
    {
        freq=(clk_util_clk_msr(MISC_PLL_CLK)*1000000);
    }
    return freq;
}

unsigned long    clk_util_clk_msr( unsigned long   clk_mux )
{

	writel(0,P_MSR_CLK_REG0);
    // Set the measurement gate to 64uS
	clrsetbits_le32(P_MSR_CLK_REG0,0xffff,64-1);
    // Disable continuous measurement
    // disable interrupts
    clrbits_le32(P_MSR_CLK_REG0,((1 << 18) | (1 << 17)));
	clrsetbits_le32(P_MSR_CLK_REG0,(0xf<<20),(clk_mux<<20)|(1<<19)|(1<<16));

	readl(P_MSR_CLK_REG0); 
    // Wait for the measurement to be done
    while( readl(P_MSR_CLK_REG0) & (1 << 31))  {};
    // disable measuring
	clrbits_le32(P_MSR_CLK_REG0,(1 << 16));
	__u32 msr=(readl(P_MSR_CLK_REG2)+31)&0x000FFFFF;
    // Return value in MHz*measured_val
    return (msr>>6);
}
struct __clk_rate{
    unsigned clksrc;
    __u32 (*get_rate)(void);
};
struct __clk_rate clkrate[]={
    {
        .clksrc=SYS_PLL_CLK,
        .get_rate=get_cpu_clk,
    },    
    {
        .clksrc=CLK81,
        .get_rate=get_clk81,
    },
    {
        .clksrc=DDR_PLL_CLK,
        .get_rate=get_clk_ddr,
    },
    {
        .clksrc=MOD_ETH_CLK50_I,
        .get_rate=get_clk_ethernet_pad,
    },
    {
        .clksrc=CTS_ETH_RMII,
        .get_rate=get_clk_cts_eth_rmii,
    },
    {
        .clksrc=MISC_PLL_CLK,
        .get_rate=get_misc_pll_clk,
    }
};

int clk_get_rate(unsigned clksrc)
{
	int i;
	for(i = 0; i < sizeof(clkrate)/sizeof(clkrate[0]); i++)
	{
		  if(clksrc == clkrate[i].clksrc)
	 	    return clkrate[i].get_rate();
   }
	 return -1;
}



