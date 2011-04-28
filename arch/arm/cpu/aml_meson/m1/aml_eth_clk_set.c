/*
Linux pllset.C
#include <asm/arch
*/
#include <asm/arch/io.h> //Hisun 2011.07.19
/*
	select clk:
	5,6,7 sata
	4-extern pad
	3-other_pll_clk
	2-ddr_pll_clk
	1-APLL_CLK_OUT_400M
	0----sys_pll_div3 (333~400Mhz)

	clk_freq:50M=50000000
	output_clk:50000000;
	aways,maybe changed for others?
	
*/

extern void udelay(unsigned long usec);
extern int printf(const char *fmt, ...);

int  eth_clk_set(int selectclk,unsigned long clk_freq,unsigned long out_clk)
{
	int n;
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

