#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/uart.h>
#include <post.h>
#include "pll.h"

#if CONFIG_POST & CONFIG_SYS_POST_PLL

//#define CONFIG_POST_PLL_DEBUG 1

extern struct clk clk_sys_pll;
extern struct clk clk_other_pll;
extern struct clk clk_audio_pll;
extern struct clk clk_video_pll;
extern struct clk clk_viid_pll;
extern struct clk_lookup lookups[];
extern unsigned int clk_lookups_size;

extern void mdelay(unsigned long msec);

#define freq_resolution 10   // 10MHz
#define sys_pll_clk_mux  2
#define other_pll_clk_mux 4
#define aud_pll_clk_mux 5
#define vid_pll_clk_mux 6
#define vid2_pll_clk_mux 12
//======================================================================
static int clk81_switch_to_a9(void)
{
//	unsigned long clock = 600;
	int div = 4;
	//unsigned long clk81 = clock/div;
		
	//int baudrate = (clk81/(CONFIG_BAUDRATE*4))-1;
	unsigned clk81_back = READ_CBUS_REG(HHI_MPEG_CLK_CNTL);	
	udelay(1000);
	clk81_back &= (~((0x7<<12) | (0x7F<<0)));
	WRITE_CBUS_REG(HHI_MPEG_CLK_CNTL, clk81_back | 
					  (1<<12) | 
					  ((div-1)<<0) |
					  (1<<7) |
					  (1<<8));
	udelay(1000);
	return 0;
}

//======================================================================
static int a9_switch_to_osc(void)
{
	unsigned a9_clk = READ_CBUS_REG(HHI_A9_CLK_CNTL);
	a9_clk &= (~(1<<7));
	WRITE_CBUS_REG(HHI_A9_CLK_CNTL, a9_clk);
	udelay(1000);
	return 0;
}
//======================================================================
void set_sys_pll(unsigned n, unsigned m, unsigned od, unsigned xd)
{
	unsigned val = READ_CBUS_REG(HHI_SYS_PLL_CNTL);
	val &= (~((0x3<<16) | (0x1f<<9) | (0x1ff<<0)));
	val |= ((od<<16) | (n<<9) | (m<<0));
	WRITE_CBUS_REG(HHI_SYS_PLL_CNTL, val);
	udelay(100);
}
//===========================================================================
void set_other_pll(unsigned n, unsigned m, unsigned od, unsigned xd)
{
	unsigned val = READ_CBUS_REG(HHI_OTHER_PLL_CNTL);	
	val &= (~((0x3<<16) | (0x1f<<9) | (0x1ff<<0)));
	val |= ((od<<16) | (n<<9) | (m<<0));
	WRITE_CBUS_REG(HHI_OTHER_PLL_CNTL, val);	
	udelay(100);	
}

//===========================================================================
void set_audio_pll(unsigned n, unsigned m, unsigned od, unsigned xd)
{
	WRITE_CBUS_REG(HHI_AUD_PLL_CNTL, (m<<0)|(n<<9)|(od<<14));
	udelay(100);
}
//===========================================================================
void set_video_pll(unsigned n, unsigned m, unsigned od, unsigned xd)
{
	unsigned val = READ_CBUS_REG(HHI_VID_PLL_CNTL);		
	//val &= (~((0x3ff<<0)|(0x1f<<10)|(0x3<<20)));
	val = ((m<<0)|(n<<10)|(od<<20));
	WRITE_CBUS_REG(HHI_VID_PLL_CNTL, val);
	udelay(100);
}

//===========================================================================
void set_viid_pll(unsigned n, unsigned m, unsigned od, unsigned xd)
{
		unsigned vid_div_reg = 0x0018803; //0x0018803 0x0010803
		unsigned pll_reg = ((m<<0) | (n<<9) | (od<<16));
	   WRITE_MPEG_REG( HHI_VIID_PLL_CNTL, pll_reg|(1<<30) );
//       WRITE_MPEG_REG( HHI_VIID_PLL_CNTL2, 0x65e31ff );
 //       WRITE_MPEG_REG( HHI_VIID_PLL_CNTL3, 0x9649a941 );
        WRITE_MPEG_REG( HHI_VIID_PLL_CNTL, pll_reg );
		WRITE_MPEG_REG( HHI_VIID_DIVIDER_CNTL,   vid_div_reg);
		
	//udelay(100);
	mdelay(10);
}
//===========================================================================
#define clk_util_clk_msr(clk) clk_util_msr(clk,64)
unsigned    clk_util_msr( unsigned  clk_mux,unsigned time )
{
	unsigned long dummy_rd;
	writel(0,P_MSR_CLK_REG0);
    // Set the measurement gate to 64uS
	clrsetbits_le32(P_MSR_CLK_REG0,0xffff,time-1);
    // Disable continuous measurement
    // disable interrupts
    clrbits_le32(P_MSR_CLK_REG0,((1 << 18) | (1 << 17)));
	clrsetbits_le32(P_MSR_CLK_REG0,
    				    (0xf << 20)|(1<<19)|(1<<16),
        				(clk_mux<<20) |(1<<19)|(1<<16));
	{ dummy_rd = readl(P_MSR_CLK_REG0); }
    // Wait for the measurement to be done
    while( readl(P_MSR_CLK_REG0) & (1 << 31))  {};
    // disable measuring
	clrbits_le32(P_MSR_CLK_REG0,(1 << 16));
    // Return value in Hz*measured_val
    //return (readl(P_MSR_CLK_REG2)>>6);
    unsigned long test = readl(P_MSR_CLK_REG2)&0x000FFFFF;     
    return (test>>6);
}
//======================================================================
unsigned test_clk_util_msr(unsigned clk_mux, unsigned dest)
{
	int count = 5;
	unsigned cur;
#ifdef CONFIG_POST_PLL_DEBUG		
	printf("cur: ");
#endif	
	while(count > 0)
	{
		cur = clk_util_clk_msr(clk_mux);
#ifdef CONFIG_POST_PLL_DEBUG		
		printf("%d  ", cur);
#endif		
		if((cur>=dest-1) && (cur<=dest+1))
		{
#ifdef CONFIG_POST_PLL_DEBUG			
			printf("\n");
#endif			
			return cur;
		}
		udelay(2000);
		count--;
	}
#ifdef CONFIG_POST_PLL_DEBUG				
	printf("\n");
#endif	
	return 0;
}

//======================================================================
static int get_max_common_divisor(int a, int b)
{
	while(b){
		int temp = b;
		b = a%b;
		a = temp;
		}
		return a;
}
//======================================================================
static int get_pll_param( unsigned fout, struct clk *clk,  struct pll_param *param)
{
	unsigned od;
	unsigned xd;
	struct range *OD, *XD, *M, *N;
	unsigned fin = CONFIG_CRYSTAL_MHZ;
	unsigned middle;
	int n, m;
	int ret;
	unsigned fout_t;
	OD = &(clk->OD_range);
	XD = &(clk->XD_range);	
	N = &(clk->N_range);
	M = &(clk->M_range);
		
	ret = -1;
	for(od=OD->min; (od<=OD->max)&&(ret==-1); od++){
		for(xd=XD->min; xd<=XD->max; xd++){			
			fout_t = fout*(1<<od)*xd;
			middle = get_max_common_divisor(fin, fout_t);
			n = fin/middle;
			m= fout_t/middle;
			if((n>=N->min) && (n<=N->max) && (m>=M->min) && (m<=M->max)){								
				param->N = n;
				param->M = m;
				param->OD = od;
				param->XD = xd;
				ret = 1;
				break;				
			}			
		}
	}
	return ret;
}

//======================================================================
int test_pll_max(struct clk *pclk, unsigned clk_mux, struct test_info *max_info)
{
	unsigned freq, freq_t;
	unsigned freq_max = pclk->Fvco.max;
	struct pll_param param;
	unsigned test;
	
	get_pll_param(pclk->middle, pclk, &param);
	max_info->freq = pclk->middle;
	max_info->N = param.N;
	max_info->M = param.M;
	max_info->OD = param.OD;
	max_info->XD = param.XD;
	
	for(freq=pclk->middle; freq<=freq_max; freq+=freq_resolution){
		if(get_pll_param(freq, pclk, &param) < 0)
			continue;		
		freq_t = (CONFIG_CRYSTAL_MHZ*param.M)/(param.N * (1<< param.OD)*param.XD);
#ifdef CONFIG_POST_PLL_DEBUG					
		printf("freq=%d, freq_t=%d, N=%d, M=%d, OD=%d, XD=%d\n", freq, freq_t, param.N, param.M, param.OD, param.XD);
#endif		
		if((freq_t<freq-5) || (freq_t>freq+5))
			continue;
		pclk->pll_set(param.N, param.M, param.OD, param.XD);		
		if((test = test_clk_util_msr(clk_mux, freq) != 0)){			
#ifdef CONFIG_POST_PLL_DEBUG						
			printf("test=%d\n", test);
#endif			
			max_info->freq = freq;
			max_info->N = param.N;
			max_info->M = param.M;
			max_info->OD = param.OD;
			max_info->XD = param.XD;		
		}		
		else{			
#ifdef CONFIG_POST_PLL_DEBUG						
			printf("test=%d\n", test);
#endif			
			//break;			
		}
	}
	return 0;
}
//======================================================================
int test_pll_min(struct clk *pclk, unsigned clk_mux, struct test_info *max_info)
{
	unsigned freq, freq_t, test;
	unsigned freq_min = pclk->Fvco.min;
	struct pll_param param;
	
	get_pll_param(pclk->middle, pclk, &param);
	max_info->freq = pclk->middle;
	max_info->N = param.N;
	max_info->M = param.M;
	max_info->OD = param.OD;
	max_info->XD = param.XD;
	
	for(freq=pclk->middle; freq>=freq_min; freq-=freq_resolution){
		if(get_pll_param(freq, pclk, &param) < 0)			
			continue;		
		freq_t = (CONFIG_CRYSTAL_MHZ*param.M)/(param.N * (1<< param.OD)*param.XD);
#ifdef CONFIG_POST_PLL_DEBUG					
		printf("freq=%d, freq_t=%d, N=%d, M=%d, OD=%d, XD=%d\n", freq, freq_t, param.N, param.M, param.OD, param.XD);
#endif		
		if((freq_t<freq-5) || (freq_t>freq+5))
			continue;
		pclk->pll_set(param.N, param.M, param.OD, param.XD);				
		if((test=test_clk_util_msr(clk_mux, freq)) != 0){
#ifdef CONFIG_POST_PLL_DEBUG						
			printf("test=%d\n", test);
#endif			
			max_info->freq = freq;
			max_info->N = param.N;
			max_info->M = param.M;
			max_info->OD = param.OD;
			max_info->XD = param.XD;
		}
		else{
#ifdef CONFIG_POST_PLL_DEBUG						
			printf("test=%d\n", test);
#endif			
			//break;			
		}
	}
	return 0;
}
//======================================================================
int test_sys_pll(void)
{
	unsigned a9clk_backup = READ_CBUS_REG(HHI_A9_CLK_CNTL);
	unsigned sys_pll_backup = READ_CBUS_REG(HHI_SYS_PLL_CNTL);
	struct test_info min_info, max_info;	
		
	a9_switch_to_osc();
	udelay(1000);
	
	test_pll_max(&clk_sys_pll, sys_pll_clk_mux, &max_info );
	test_pll_min(&clk_sys_pll, sys_pll_clk_mux, &min_info);
	
	WRITE_CBUS_REG(HHI_SYS_PLL_CNTL, sys_pll_backup);
	udelay(1000);
	WRITE_CBUS_REG(HHI_A9_CLK_CNTL, a9clk_backup);
	udelay(1000);
	
	post_log("sys pll test info: \n");
	post_log("      |	Fin	|	N		M	|	OD	FOUT	| \n");
	post_log("min:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												min_info.N, min_info.M, min_info.OD, min_info.freq);	
	post_log("max:  |	%d	|	%d		%d	|	%d	%ld	|\n",  CONFIG_CRYSTAL_MHZ,
												max_info.N, max_info.M, max_info.OD, max_info.freq);	
	return 0;	
}

//======================================================================================================
int test_other_pll(void)
{
	unsigned other_pll_backup = READ_CBUS_REG(HHI_OTHER_PLL_CNTL);
	unsigned clk81_backup = READ_CBUS_REG(HHI_MPEG_CLK_CNTL);	
	
	struct test_info min_info, max_info;
	
	clk81_switch_to_a9();
	udelay(1000);
		
	test_pll_max(&clk_other_pll, other_pll_clk_mux, &max_info);
	test_pll_min(&clk_other_pll, other_pll_clk_mux, &min_info);
		
	 while ((readl(P_UART_STATUS(UART_PORT_CONS)) & UART_STAT_MASK_TFIFO_EMPTY)==0);
	 udelay(1000);
	WRITE_CBUS_REG(HHI_OTHER_PLL_CNTL, other_pll_backup);
	udelay(3000);
	WRITE_CBUS_REG(HHI_MPEG_CLK_CNTL, clk81_backup);				
	udelay(3000);
	while ((readl(P_UART_STATUS(UART_PORT_CONS)) & UART_STAT_MASK_TFIFO_EMPTY)==0);
	udelay(3000);	

	serial_init();	
	while ((readl(P_UART_STATUS(UART_PORT_CONS)) & UART_STAT_MASK_TFIFO_EMPTY)==0);
	udelay(3000);
	
	post_log("other pll test info: \n");
	post_log("      |	Fin	|	N		M	|	OD	FOUT	| \n");
	post_log("min:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												min_info.N, min_info.M, min_info.OD, min_info.freq);	
	post_log("max:  |	%d	|	%d		%d	|	%d	%ld	|\n",  CONFIG_CRYSTAL_MHZ,
												max_info.N, max_info.M, max_info.OD, max_info.freq);
	return 0;	
}

//======================================================================================================
int test_audio_pll(void)
{
	unsigned audio_pll_backup = READ_CBUS_REG(HHI_AUD_PLL_CNTL);
	struct test_info min_info, max_info;
	
	test_pll_max(&clk_audio_pll, aud_pll_clk_mux, &max_info);
	test_pll_min(&clk_audio_pll, aud_pll_clk_mux, &min_info);
	
	WRITE_CBUS_REG(HHI_AUD_PLL_CNTL, audio_pll_backup);
	udelay(1000);
	
	post_log("audio:  pll test info: \n");
	post_log("      |	Fin	|	N		M	|	OD	FOUT	| \n");
	post_log("min:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												min_info.N, min_info.M, min_info.OD, min_info.freq);	
	post_log("max:  |	%d	|	%d		%d	|	%d	%ld	|\n",  CONFIG_CRYSTAL_MHZ,
												max_info.N, max_info.M, max_info.OD, max_info.freq);
	return 0;	
}
//======================================================================================================
int test_video_pll(void)
{
	unsigned video_pll_backup = READ_CBUS_REG(HHI_VID_PLL_CNTL);
	struct test_info min_info, max_info;	
	
	test_pll_max(&clk_video_pll, vid_pll_clk_mux, &max_info);
	test_pll_min(&clk_video_pll, vid_pll_clk_mux, &min_info);
	
	WRITE_CBUS_REG(HHI_VID_PLL_CNTL, video_pll_backup);
	udelay(1000);
	
	post_log("video:  pll test info: \n");
	post_log("      |	Fin	|	N		M	|	OD	FOUT	| \n");
	post_log("min:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												min_info.N, min_info.M, min_info.OD, min_info.freq);
	post_log("max:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												max_info.N, max_info.M, max_info.OD, max_info.freq);
	return 0;	
}

//======================================================================================================
int test_viid_pll(void)
{
	unsigned viid_pll_backup = READ_CBUS_REG(HHI_VIID_PLL_CNTL);
	struct test_info min_info, max_info;	
	
	test_pll_max(&clk_viid_pll, vid2_pll_clk_mux, &max_info);
	test_pll_min(&clk_viid_pll, vid2_pll_clk_mux, &min_info);
	
	WRITE_CBUS_REG(HHI_VIID_PLL_CNTL, viid_pll_backup);
	udelay(1000);
	
	post_log("viid:  pll test info: \n");
	post_log("      |	Fin	|	N		M	|	OD	FOUT	| \n");
	post_log("min:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												min_info.N, min_info.M, min_info.OD, min_info.freq);
	post_log("max:  |	%d	|	%d		%d	|	%d	%ld	|\n", CONFIG_CRYSTAL_MHZ,
												max_info.N, max_info.M, max_info.OD, max_info.freq);
	return 0;	
}
//======================================================================================================
int pll_post_test(int flags)
{
	int i;	
	int ret;
	
	ret = 0;
	for(i=0; i<clk_lookups_size; i++){
		if(lookups[i].pll_test() < 0){			
			post_log("<%d>pll: %s: test fail.\n", SYSTEST_INFO_L2, lookups[i].dev_id);				
			ret = -1;
		}
		else
			post_log("<%d>pll: %s: test pass.\n", SYSTEST_INFO_L2, lookups[i].dev_id);
	}	
				
	return ret;
}

#endif /*CONFIG_POST*/
//======================================================================================================

