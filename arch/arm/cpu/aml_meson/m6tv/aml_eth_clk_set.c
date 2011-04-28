/*******************************************************************
 * 
 *  Copyright C 2011 by Amlogic, Inc. All Rights Reserved.
 *
 *  Description: pinmux setting implementation for Amlogic Ethernet
 *
 *  
 *  Remark: 2011.08.02 merge by Hisun bao
 *                from /arch/arm/cpu/aml_meson/m1
 *
 *******************************************************************/

#include <asm/arch/io.h>

extern void udelay(unsigned long usec);
extern int printf(const char *fmt, ...);


/*
	please refer following doc for detail
	@AppNote-M3-ClockTrees.docx
	
	select clk: -> CBUS_REG(0x1076)
	
	7-sys_pll_div2
	6-vid2_pll_clk
	5-vid_pll_clk
	4-aud_pll_clk
	3-ddr_pll_clk
	2-misc_pll_clk
	1-sys_pll_clk
	0-XTAL

	clk_freq:800MHz
	output_clk:50MHz
	aways,maybe changed for others?	
*/

int  eth_clk_set(int selectclk,unsigned long clk_freq,unsigned long out_clk)
{
	int n;
	printf("select eth clk-%d,source=%d,out=%d\n",selectclk,clk_freq,out_clk);
	if(((clk_freq)%out_clk)!=0)
		{
			printf("ERROR:source clk must n times of out_clk ,source clk=%d\n",out_clk,clk_freq);
			return -1;
		}
	else
		{
			n=(int)((clk_freq)/out_clk);
		}
	
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL,
		(n-1)<<0 |
		selectclk<<9 |
		1<<8//enable clk
		); 
	udelay(100);
	return 0;
}

int auto_select_eth_clk(void)
{
	return -1;
}

