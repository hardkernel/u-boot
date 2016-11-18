#include <common.h>
#include <asm/arch/secure_apb.h>
//#include<stdio.h>

//#include <asm/io.h>
//#include <asm/arch/io.h>
//#include <asm/arch/register.h>
//#include <asm/arch-g9tv/mmc.h>  //jiaxing debug

//extern  void aml_cache_disable(void);
//#ifndef   char* itoa(intnum,char*str,intradix)



char* itoa_ddr_test(int num,char*str,int radix)
{/*索引表*/
printf("\nitoa_ddr_test 1\n");
char index[]="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
unsigned unum;/*中间变量*/
int i=0,j,k;
/*确定unum的值*/
if (radix == 10 && num<0) /*十进制负数*/
{
unum=(unsigned)-num;
str[i++]='-';
}
else unum=(unsigned)num;/*其他情况*/
/*转换*/
printf("\nitoa_ddr_test 2\n");
printf("\nunum=0x%08x\n",unum);
printf("\nunum2=0x%08x\n",(unum%(unsigned)radix));
printf("\nradix=0x%08x\n",radix);
str[0]=index[0];
printf("\nitoa_ddr_test 22\n");
unum/=radix;
printf("\nitoa_ddr_test 23\n");
do {
str[i++]=index[unum%(unsigned)radix];
unum/=radix;
}while(unum);
printf("\nitoa_ddr_test 3\n");
str[i]='\0';
/*逆序*/
if (str[0] == '-') k=1;/*十进制负数*/
else k=0;
char temp;
printf("\nitoa_ddr_test 4\n");
for (j=k;j<=(i-1)/2;j++)
{
temp=str[j];
str[j]=str[i-1+k-j];
str[i-1+k-j]=temp;
}
return str;
}
//#endif

#define TDATA32F 0xffffffff
#define TDATA32A 0xaaaaaaaa
#define TDATA325 0x55555555

//#define DDR_TEST_ACLCDLR

unsigned int global_ddr_clk=1;
  unsigned int   error_count =0;
 unsigned int  error_outof_count_flag=0;
 unsigned int  copy_test_flag = 0;
  unsigned int  training_pattern_flag = 0;
  unsigned int test_start_addr=0x1080000;

   unsigned int  dq_lcd_bdl_value_wdq_org_a[4];
   unsigned int  dq_lcd_bdl_value_rdqs_org_a[4];
   unsigned int  dq_lcd_bdl_value_wdq_min_a[4];
   unsigned int  dq_lcd_bdl_value_wdq_max_a[4];
   unsigned int  dq_lcd_bdl_value_rdqs_min_a[4];
   unsigned int  dq_lcd_bdl_value_rdqs_max_a[4];

   unsigned int  dq_lcd_bdl_value_wdq_org_b[4];
   unsigned int  dq_lcd_bdl_value_rdqs_org_b[4];
   unsigned int  dq_lcd_bdl_value_wdq_min_b[4];
   unsigned int  dq_lcd_bdl_value_wdq_max_b[4];
   unsigned int  dq_lcd_bdl_value_rdqs_min_b[4];
   unsigned int  dq_lcd_bdl_value_rdqs_max_b[4];
   unsigned int  acbdlr0_9_reg_org[10];
   unsigned int  acbdlr0_9_reg_setup_max[40];
   unsigned int  acbdlr0_9_reg_hold_max[40];
      unsigned int  acbdlr0_9_reg_setup_time[40];
   unsigned int  acbdlr0_9_reg_hold_time[40];
   //    unsigned int  data_bdlr0_5_reg_org[6];
      unsigned int  data_bdlr0_5_reg_org[28];//4//4lane
   unsigned int  bdlr0_9_reg_setup_max[24*4];//4//4 lane 96 bdlr
   unsigned int  bdlr0_9_reg_hold_max[24*4];
    unsigned int  bdlr0_9_reg_setup_time[24*4];
   unsigned int  bdlr0_9_reg_hold_time[24*4];

#define readl(addr)    (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
#define writel(data ,addr)  (*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)

#define wr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rd_reg(addr)		 (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)



//#define ddr_udelay(a)  do{}while((a<<5)--);
#define P_EE_TIMER_E1                                 ((0x2662  << 2) + 0xc1100000)
void ddr_udelay(unsigned int us)
{
//#ifndef CONFIG_PXP_EMULATOR
	unsigned int t0 = (*((volatile unsigned *)(P_EE_TIMER_E1)));

	while ((*((volatile unsigned *)(P_EE_TIMER_E1))) - t0 <= us)
		;
//#endif
}

void ddr_test_watchdog_init(uint32_t msec)
{
#define P_WATCHDOG_CNTL              0xc11098d0
#define P_WATCHDOG_CNTL1            0xc11098d4
#define P_WATCHDOG_TCNT             0xc11098d8
#define P_WATCHDOG_RESET            0xc11098dc
	// src: 24MHz
	// div: 24000 for 1ms
	// reset ao-22 and ee-21
	writel( (1<<24)|(1<<25)|(1<<23)|(1<<21)|(24000-1),P_WATCHDOG_CNTL);

	// set timeout
	//*P_WATCHDOG_TCNT = msec;
	writel(msec,P_WATCHDOG_TCNT); //bit0-15
	writel(0,P_WATCHDOG_RESET);
	//*P_WATCHDOG_RESET = 0;

	// enable
	writel((readl(P_WATCHDOG_CNTL))|(1<<18),P_WATCHDOG_CNTL);
	//*P_WATCHDOG_CNTL |= (1<<18);
}

void ddr_test_watchdog_reset_system(void)
{
#define P_WATCHDOG_CNTL              0xc11098d0
#define P_WATCHDOG_CNTL1            0xc11098d4
#define P_WATCHDOG_TCNT             0xc11098d8
#define P_WATCHDOG_RESET            0xc11098dc
		int i;

		while (1) {
		writel(	0x3	| (1 << 21) // sys reset en  ao ee 3
				| (1 << 23) // interrupt en
				| (1 << 24) // clk en
				| (1 << 25) // clk div en
				| (1 << 26) // sys reset now  ao ee 3
			, P_WATCHDOG_CNTL);
		printf("\nP_WATCHDOG_CNTL==%x08",readl(P_WATCHDOG_CNTL));
		printf("\nP_WATCHDOG_CNTL==%x08",readl(P_WATCHDOG_CNTL));
		printf("\nP_WATCHDOG_CNTL==%x08",readl(P_WATCHDOG_CNTL));
				writel(0, P_WATCHDOG_RESET);

				writel(readl(P_WATCHDOG_CNTL) | (1<<18), // watchdog en
			P_WATCHDOG_CNTL);
				for (i=0; i<100; i++)
						readl(P_WATCHDOG_CNTL);/*Deceive gcc for waiting some cycles */
	}
}

//#define CONFIG_DDR_CMD_BDL_TUNE
//#define  CONFIG_CMD_DDR_TEST
#define P_DDR_PHY_DEFAULT           0
#define P_DDR_PHY_GX_BABY             1
#define  P_DDR_PHY_GX_TV_BABY     2
#define  P_DDR_PHY_905X        3

#define CONFIG_DDR_PHY    P_DDR_PHY_905X//P_DDR_PHY_GX_BABY//P_DDR_PHY_905X// P_DDR_PHY_GX_BABY

#define PATTERN_USE_DDR_DES
#define  USE_64BIT_POINTER
//#define  USE_32BIT_POINTER
#ifdef USE_64BIT_POINTER
#define p_convter_int(a)  ( unsigned int )( unsigned long )(a)
#define int_convter_p(a)  ( unsigned long )(a)

 #else
 #define p_convter_int(a)  ( unsigned int )(a)
 #define int_convter_p(a)  ( unsigned int )(a)
 #endif

#ifdef PATTERN_USE_DDR_DES
#define des_pattern(a,b,c,d)  (des[a]^pattern_##b[c][d])
#define des_inv_pattern(a,b,c,d)   ( des[a]^(~(pattern_##b[c][d])))
#define des_xor_pattern(a,b)   ( a^b)
//des[temp_i]^pattern_2[temp_k][temp_i]

 #else
#define des_pattern(a,b,c,d)  (des[a]&0)+pattern_##b[c][d]
#define des_inv_pattern(a,b,c,d)  (des[a]&0)+~(pattern_##b[c][d])
#define des_xor_pattern(a,b)  (a&0+b)
 #endif


#define  DDR_LCDLR_CK_USE_FAST_PATTERN

#define  DDR_PREFETCH_CACHE
#ifdef DDR_PREFETCH_CACHE
#define ddr_pld_cache(P)   asm ("prfm PLDL1KEEP, [%0, #376]"::"r" (P))
#else
#define ddr_pld_cache(P)
#endif

#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_BABY)
	  #define DDR0_PUB_REG_BASE			0xc8836000
          #define DDR1_PUB_REG_BASE			0xc8836000
	 #define  CHANNEL_A_REG_BASE  0
	  #define  CHANNEL_B_REG_BASE  0x2000
	  #define P_DDR0_CLK_CTRL   0xc8836c00
         #define P_DDR1_CLK_CTRL  0xc8836c00
	  #define OPEN_CHANNEL_A_PHY_CLK()      (writel((0), 0xc8836c00))
	  #define OPEN_CHANNEL_B_PHY_CLK()     (writel((0), 0xc8836c00))
	  #define CLOSE_CHANNEL_A_PHY_CLK()      (writel((5), 0xc8836c00))
	  #define CLOSE_CHANNEL_B_PHY_CLK()     (writel((5), 0xc8836c00))
	  #define P_ISA_TIMERE                0xc1109988
	   #define get_us_time()    (readl(P_ISA_TIMERE))
       #define AM_DDR_PLL_CNTL						0xc8836800
	   #define DDR0_PUB_ZQCR						(DDR0_PUB_REG_BASE+(0x90<<2))
	#define DDR0_PUB_ZQ0PR						(DDR0_PUB_REG_BASE+(0x91<<2))
	#define DDR0_PUB_ZQ0DR						(DDR0_PUB_REG_BASE+(0x92<<2))

	   #define DDR1_PUB_ZQCR						(DDR1_PUB_REG_BASE+(0x90<<2))
	#define DDR1_PUB_ZQ0PR						(DDR1_PUB_REG_BASE+(0x91<<2))
	#define DDR1_PUB_ZQ0DR						(DDR1_PUB_REG_BASE+(0x92<<2))

	#define DDR0_PUB_ZQ1PR						(DDR0_PUB_REG_BASE+(0x95<<2))
#define DDR0_PUB_ZQ1DR						(DDR0_PUB_REG_BASE+(0x96<<2))
#define DDR0_PUB_ZQ1SR						(DDR0_PUB_REG_BASE+(0x97<<2))
//0x98 reserved)
#define DDR0_PUB_ZQ2PR						(DDR0_PUB_REG_BASE+(0x99<<2))
#define DDR0_PUB_ZQ2DR						(DDR0_PUB_REG_BASE+(0x9A<<2))
#define DDR0_PUB_ZQ2SR						(DDR0_PUB_REG_BASE+(0x9B<<2))
//0x9c reserved)
#define DDR0_PUB_ZQ3PR						(DDR0_PUB_REG_BASE+(0x9D<<2))
#define DDR0_PUB_ZQ3DR						(DDR0_PUB_REG_BASE+(0x9E<<2))
#define DDR0_PUB_ZQ3SR						(DDR0_PUB_REG_BASE+(0x9F<<2))
    #define ACBDLR_MAX   0X1F
    #define ACLCDLR_MAX   0XFF
    #define DQBDLR_MAX   0X1F
    #define DQLCDLR_MAX   0XFF
    #define DXNGTR_MAX   0X7
    #define ACBDLR_NUM   10



#define DMC_REG_BASE						0xc8838000
#define DMC_MON_CTRL2						(DMC_REG_BASE + (0x26 <<2 ))
   //bit 31.   qos_mon_en.    write 1 to trigger the enable. polling this bit 0, means finished.  or use interrupt to check finish.
   //bit 30.   qos_mon interrupt clear.  clear the qos monitor result.  read 1 = qos mon finish interrupt.
   //bit 20.   qos_mon_trig_sel.  1 = vsync.  0 = timer.
   //bit 19:16.  qos monitor channel select.   select one at one time only.
   //bit 15:0.   port select for the selected channel.
#define DMC_MON_CTRL3						(DMC_REG_BASE + (0x27 <<2 ))
  // qos_mon_clk_timer.   How long to measure the bandwidth.


#define DMC_MON_ALL_REQ_CNT					(DMC_REG_BASE + (0x28 <<2 ))
  // at the test period,  the whole MMC request time.
#define DMC_MON_ALL_GRANT_CNT				(DMC_REG_BASE + (0x29 <<2 ))
  // at the test period,  the whole MMC granted data cycles. 64bits unit.
#define DMC_MON_ONE_GRANT_CNT				(DMC_REG_BASE + (0x2a <<2 ))


#elif (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_TV_BABY)


	  #define DDR0_PUB_REG_BASE			0xc8836000
          #define DDR1_PUB_REG_BASE			0xc8837000
	 #define  CHANNEL_A_REG_BASE  0
	  #define  CHANNEL_B_REG_BASE  0x1000
		#define P_DDR0_CLK_CTRL   0xc8836c00
         #define P_DDR1_CLK_CTRL  0xc8836c00
	  #define OPEN_CHANNEL_A_PHY_CLK()      (writel((0), 0xc8836c00))
	   #define OPEN_CHANNEL_B_PHY_CLK()      (writel((0), 0xc8837c00))
	    #define CLOSE_CHANNEL_A_PHY_CLK()      (writel((0x12a), 0xc8836c00))
		 #define CLOSE_CHANNEL_B_PHY_CLK()    (writel((0x12a), 0xc8837c00))
		#define P_ISA_TIMERE                 0xc1109988
	   #define get_us_time()   (readl(P_ISA_TIMERE) )
	   #define AM_DDR_PLL_CNTL						0xc8836800
	   #define DDR0_PUB_ZQCR						(DDR0_PUB_REG_BASE+(0x90<<2))
	   #define DDR0_PUB_ZQ0PR						(DDR0_PUB_REG_BASE+(0x91<<2))
	   #define DDR0_PUB_ZQ0DR						(DDR0_PUB_REG_BASE+(0x92<<2))
		#define DDR1_PUB_ZQCR						(DDR1_PUB_REG_BASE+(0x90<<2))
	#define DDR1_PUB_ZQ0PR						(DDR1_PUB_REG_BASE+(0x91<<2))
	#define DDR1_PUB_ZQ0DR						(DDR1_PUB_REG_BASE+(0x92<<2))



#define DDR0_PUB_ZQ0SR						(DDR0_PUB_REG_BASE+(0x93<<2))
//0x94 reserved)
#define DDR0_PUB_ZQ1PR						(DDR0_PUB_REG_BASE+(0x95<<2))
#define DDR0_PUB_ZQ1DR						(DDR0_PUB_REG_BASE+(0x96<<2))
#define DDR0_PUB_ZQ1SR						(DDR0_PUB_REG_BASE+(0x97<<2))
//0x98 reserved)
#define DDR0_PUB_ZQ2PR						(DDR0_PUB_REG_BASE+(0x99<<2))
#define DDR0_PUB_ZQ2DR						(DDR0_PUB_REG_BASE+(0x9A<<2))
#define DDR0_PUB_ZQ2SR						(DDR0_PUB_REG_BASE+(0x9B<<2))
//0x9c reserved)
#define DDR0_PUB_ZQ3PR						(DDR0_PUB_REG_BASE+(0x9D<<2))
#define DDR0_PUB_ZQ3DR						(DDR0_PUB_REG_BASE+(0x9E<<2))
#define DDR0_PUB_ZQ3SR						(DDR0_PUB_REG_BASE+(0x9F<<2))
    #define ACBDLR_MAX   0X1F
    #define ACLCDLR_MAX   0XFF
    #define DQBDLR_MAX   0X1F
    #define DQLCDLR_MAX   0XFF
	  #define DXNGTR_MAX   0X7

#define DMC_REG_BASE						0xc8838000
#define DMC_MON_CTRL2						(DMC_REG_BASE + (0x26 <<2 ))
   //bit 31.   qos_mon_en.    write 1 to trigger the enable. polling this bit 0, means finished.  or use interrupt to check finish.
   //bit 30.   qos_mon interrupt clear.  clear the qos monitor result.  read 1 = qos mon finish interrupt.
   //bit 20.   qos_mon_trig_sel.  1 = vsync.  0 = timer.
   //bit 19:16.  qos monitor channel select.   select one at one time only.
   //bit 15:0.   port select for the selected channel.
#define DMC_MON_CTRL3						(DMC_REG_BASE + (0x27 <<2 ))
  // qos_mon_clk_timer.   How long to measure the bandwidth.


#define DMC_MON_ALL_REQ_CNT					(DMC_REG_BASE + (0x28 <<2 ))
  // at the test period,  the whole MMC request time.
#define DMC_MON_ALL_GRANT_CNT				(DMC_REG_BASE + (0x29 <<2 ))
  // at the test period,  the whole MMC granted data cycles. 64bits unit.
#define DMC_MON_ONE_GRANT_CNT				(DMC_REG_BASE + (0x2a <<2 ))
  // at the test period,  the granted data cycles for the selected channel and ports.

#elif (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)

	   #define P_ISA_TIMERE                 0xc1109988
	   #define get_us_time()   (readl(P_ISA_TIMERE) )

	   #define DDR0_PUB_REG_BASE			0xc8836000
          #define DDR1_PUB_REG_BASE			0xc8836000
	   #define  CHANNEL_A_REG_BASE  0
	   #define  CHANNEL_B_REG_BASE  0//0x1000
	   #define MMC_REG_BASE   0xc8837000
	   #define   DDR_CLK_CNTL   (MMC_REG_BASE + ( 0x7	<< 2 ))
	   #define P_DDR0_CLK_CTRL   DDR_CLK_CNTL
          #define P_DDR1_CLK_CTRL  DDR_CLK_CNTL
	   #define OPEN_CHANNEL_A_PHY_CLK()      (writel((0Xb000a000), DDR_CLK_CNTL))
	   #define OPEN_CHANNEL_B_PHY_CLK()      (writel((0Xb000a000), DDR_CLK_CNTL))
	   #define CLOSE_CHANNEL_A_PHY_CLK()     (writel((0Xb000a005), DDR_CLK_CNTL))
	   #define CLOSE_CHANNEL_B_PHY_CLK()     (writel((0Xb000a005), DDR_CLK_CNTL))



	   #define AM_DDR_PLL_CNTL0     	       (MMC_REG_BASE + ( 0x0	<< 2 ))
	   #define AM_DDR_PLL_CNTL						AM_DDR_PLL_CNTL0
	   #define  DDR0_PUB_ZQCR               (DDR0_PUB_REG_BASE + ( 0x1a0 << 2 ))
          #define  DDR0_PUB_ZQ0PR              (DDR0_PUB_REG_BASE + ( 0x1a1 << 2 ))
          #define  DDR0_PUB_ZQ0DR              (DDR0_PUB_REG_BASE + ( 0x1a2 << 2 ))
          #define  DDR0_PUB_ZQ0SR             ( DDR0_PUB_REG_BASE + ( 0x1a3 << 2 ))

          #define  DDR0_PUB_ZQ1PR              (DDR0_PUB_REG_BASE + ( 0x1a5 << 2 ))
          #define  DDR0_PUB_ZQ1DR              (DDR0_PUB_REG_BASE + ( 0x1a6 << 2 ))
          #define  DDR0_PUB_ZQ1SR              (DDR0_PUB_REG_BASE + ( 0x1a7 << 2 ))

          #define  DDR0_PUB_ZQ2PR             ( DDR0_PUB_REG_BASE + ( 0x1a9 << 2 ))
          #define  DDR0_PUB_ZQ2DR              (DDR0_PUB_REG_BASE + ( 0x1aA << 2 ))
          #define  DDR0_PUB_ZQ2SR             ( DDR0_PUB_REG_BASE + ( 0x1aB << 2 ))

	   #define DDR1_PUB_ZQCR					DDR0_PUB_ZQ0PR
	   #define DDR1_PUB_ZQ0PR					DDR0_PUB_ZQ0PR
	   #define DDR1_PUB_ZQ0DR					DDR0_PUB_ZQ0DR

    #define ACBDLR_MAX   0X3F
    #define ACLCDLR_MAX   0X1FF
    #define DQBDLR_MAX   0X3F
    #define DQLCDLR_MAX   0X1FF
  #define DXNGTR_MAX   0X1F

          #define DMC_REG_BASE						MMC_REG_BASE
          #define DMC_MON_CTRL2						(DMC_REG_BASE + (0x26 <<2 ))
   //bit 31.   qos_mon_en.    write 1 to trigger the enable. polling this bit 0, means finished.  or use interrupt to check finish.
   //bit 30.   qos_mon interrupt clear.  clear the qos monitor result.  read 1 = qos mon finish interrupt.
   //bit 20.   qos_mon_trig_sel.  1 = vsync.  0 = timer.
   //bit 19:16.  qos monitor channel select.   select one at one time only.
   //bit 15:0.   port select for the selected channel.
         #define DMC_MON_CTRL3						(DMC_REG_BASE + (0x27 <<2 ))
  // qos_mon_clk_timer.   How long to measure the bandwidth.


#define DMC_MON_ALL_REQ_CNT					(DMC_REG_BASE + (0x28 <<2 ))
  // at the test period,  the whole MMC request time.
#define DMC_MON_ALL_GRANT_CNT				(DMC_REG_BASE + (0x29 <<2 ))
  // at the test period,  the whole MMC granted data cycles. 64bits unit.
#define DMC_MON_ONE_GRANT_CNT				(DMC_REG_BASE + (0x2a <<2 ))
  // at the test period,  the granted data cycles for the selected channel and ports.

#elif (CONFIG_DDR_PHY ==  P_DDR_PHY_DEFAULT)

           #define DDR0_PUB_REG_BASE			0xc8001000		//0xc8836000
          #define DDR1_PUB_REG_BASE			0xc8001000		//	0xc8836000
          #define  CHANNEL_A_REG_BASE  0
	  #define  CHANNEL_B_REG_BASE  0x2000
	  #define P_DDR0_CLK_CTRL   0xc8000800
         #define P_DDR1_CLK_CTRL  0xc8002800
	   #define OPEN_CHANNEL_A_PHY_CLK()      (writel((0x12b), 0xc8000800))
	   #define OPEN_CHANNEL_B_PHY_CLK()      (writel((0x12b), 0xc8002800))
		#define CLOSE_CHANNEL_A_PHY_CLK()      (writel((0x12a), 0xc8000800))
	   #define CLOSE_CHANNEL_B_PHY_CLK()      (writel((0x12a), 0xc8002800))
		#define P_ISA_TIMERE                 0xc1109988
	   #define get_us_time()   (readl(P_ISA_TIMERE))
	#define AM_DDR_PLL_CNTL  0xc8000400
	#define DDR0_PUB_ZQCR						(DDR0_PUB_REG_BASE+(0x90<<2))
	#define DDR0_PUB_ZQ0PR						(DDR0_PUB_REG_BASE+(0x91<<2))
	#define DDR0_PUB_ZQ0DR						(DDR0_PUB_REG_BASE+(0x92<<2))
		   #define DDR1_PUB_ZQCR						(DDR1_PUB_REG_BASE+(0x90<<2))
	#define DDR1_PUB_ZQ0PR						(DDR1_PUB_REG_BASE+(0x91<<2))
	#define DDR1_PUB_ZQ0DR						(DDR1_PUB_REG_BASE+(0x92<<2))
    #define ACBDLR_MAX   0X1F
    #define ACLCDLR_MAX   0XFF
    #define DQBDLR_MAX   0X1F
    #define DQLCDLR_MAX   0XFF
    #define DXNGTR_MAX   0X7

	#define DMC_REG_BASE      0xc8006000
#define DMC_MON_CTRL2						(DMC_REG_BASE + (0x26 <<2 ))
   //bit 31.   qos_mon_en.    write 1 to trigger the enable. polling this bit 0, means finished.  or use interrupt to check finish.
   //bit 30.   qos_mon interrupt clear.  clear the qos monitor result.  read 1 = qos mon finish interrupt.
   //bit 20.   qos_mon_trig_sel.  1 = vsync.  0 = timer.
   //bit 19:16.  qos monitor channel select.   select one at one time only.
   //bit 15:0.   port select for the selected channel.
#define DMC_MON_CTRL3						(DMC_REG_BASE + (0x27 <<2 ))
  // qos_mon_clk_timer.   How long to measure the bandwidth.


#define DMC_MON_ALL_REQ_CNT					(DMC_REG_BASE + (0x28 <<2 ))
  // at the test period,  the whole MMC request time.
#define DMC_MON_ALL_GRANT_CNT				(DMC_REG_BASE + (0x29 <<2 ))
  // at the test period,  the whole MMC granted data cycles. 64bits unit.
#define DMC_MON_ONE_GRANT_CNT				(DMC_REG_BASE + (0x2a <<2 ))
  // at the test period,  the granted data cycles for the selected channel and ports.
   #endif



 #if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)

  #define DDR0_PUB_PIR						(DDR0_PUB_REG_BASE+(0x01<<2))
#define DDR0_PUB_PGCR0         (DDR0_PUB_REG_BASE + ( 0x004 << 2  ))// R/W - PHY General Configuration Register 0
#define DDR0_PUB_PGCR1        ( DDR0_PUB_REG_BASE + ( 0x005 << 2 )) // R/W - PHY General Configuration Register 1
#define DDR0_PUB_PGCR2         (DDR0_PUB_REG_BASE + ( 0x006 << 2 )) // R/W - PHY General Configuration Register 2
#define DDR0_PUB_PGCR3        ( DDR0_PUB_REG_BASE + ( 0x007 << 2 )) // R/W - PHY General Configuration Register 3
#define DDR0_PUB_PGCR4        ( DDR0_PUB_REG_BASE + ( 0x008 << 2 )) // R/W - PHY General Configuration Register 4
#define DDR0_PUB_PGCR5         (DDR0_PUB_REG_BASE + ( 0x009 << 2 )) // R/W - PHY General Configuration Register 5
#define DDR0_PUB_PGCR6         (DDR0_PUB_REG_BASE + ( 0x00A << 2 )) // R/W - PHY General Configuration Register 6
#define DDR0_PUB_PGCR7         (DDR0_PUB_REG_BASE + ( 0x00B << 2 )) // R/W - PHY General Configuration Register 7
#define DDR0_PUB_PGCR8         (DDR0_PUB_REG_BASE + ( 0x00C << 2 )) // R/W - PHY General Configuration Register 8

#define DDR1_PUB_PIR						(DDR1_PUB_REG_BASE+(0x01<<2))
#define DDR1_PUB_PGCR0         (DDR0_PUB_REG_BASE + ( 0x004 << 2 )) // R/W - PHY General Configuration Register 0
#define DDR1_PUB_PGCR1         (DDR0_PUB_REG_BASE + ( 0x005 << 2 )) // R/W - PHY General Configuration Register 1
#define DDR1_PUB_PGCR2        ( DDR0_PUB_REG_BASE + ( 0x006 << 2 )) // R/W - PHY General Configuration Register 2
#define DDR1_PUB_PGCR3         (DDR0_PUB_REG_BASE + ( 0x007 << 2 )) // R/W - PHY General Configuration Register 3
#define DDR1_PUB_PGCR4         (DDR0_PUB_REG_BASE + ( 0x008 << 2 ) )// R/W - PHY General Configuration Register 4
#define DDR1_PUB_PGCR5         (DDR0_PUB_REG_BASE + ( 0x009 << 2 )) // R/W - PHY General Configuration Register 5
#define DDR1_PUB_PGCR6         (DDR0_PUB_REG_BASE + ( 0x00A << 2 )) // R/W - PHY General Configuration Register 6
#define DDR1_PUB_PGCR7         (DDR0_PUB_REG_BASE + ( 0x00B << 2 )) // R/W - PHY General Configuration Register 7
#define DDR1_PUB_PGCR8         (DDR0_PUB_REG_BASE + ( 0x00C << 2 ) )// R/W - PHY General Configuration Register 8

#define DDR0_PUB_DX0BDLR0     (DDR0_PUB_REG_BASE + ( 0x1d0  << 2 ))
#define DDR0_PUB_DX0BDLR1     (DDR0_PUB_REG_BASE + ( 0x1d1  << 2 ))
#define DDR0_PUB_DX0BDLR2    ( DDR0_PUB_REG_BASE + ( 0x1d2  << 2 ))
#define DDR0_PUB_DX0BDLR3     (DDR0_PUB_REG_BASE + ( 0x1d4  << 2 ))
#define DDR0_PUB_DX0BDLR4     (DDR0_PUB_REG_BASE + ( 0x1d5  << 2 ))
#define DDR0_PUB_DX0BDLR5     (DDR0_PUB_REG_BASE + ( 0x1d6  << 2 ))
#define DDR0_PUB_DX0BDLR6     (DDR0_PUB_REG_BASE + ( 0x1d8  << 2 ))
#define DDR0_PUB_DX0LCDLR0    (DDR0_PUB_REG_BASE + ( 0x1e0  << 2 ))
#define DDR0_PUB_DX0LCDLR1    (DDR0_PUB_REG_BASE + ( 0x1e1  << 2 ))
#define DDR0_PUB_DX0LCDLR2    (DDR0_PUB_REG_BASE + ( 0x1e2  << 2 ))
#define DDR0_PUB_DX0LCDLR3    (DDR0_PUB_REG_BASE + ( 0x1e3  << 2 ))
#define DDR0_PUB_DX0LCDLR4    (DDR0_PUB_REG_BASE + ( 0x1e4  << 2 ))
#define DDR0_PUB_DX0LCDLR5    (DDR0_PUB_REG_BASE + ( 0x1e5  << 2 ))
#define DDR0_PUB_DX0MDLR0     (DDR0_PUB_REG_BASE + ( 0x1e8  << 2 ))
#define DDR0_PUB_DX0MDLR1     (DDR0_PUB_REG_BASE + ( 0x1e9  << 2) )
#define DDR0_PUB_DX0GTR0      (DDR0_PUB_REG_BASE + ( 0x1f0  << 2 ))
#define DDR0_PUB_DX0GTR1      (DDR0_PUB_REG_BASE + ( 0x1f1  << 2) )
#define DDR0_PUB_DX0GTR2      (DDR0_PUB_REG_BASE + ( 0x1f2  << 2) )
#define DDR0_PUB_DX0GTR3      (DDR0_PUB_REG_BASE + ( 0x1f3  << 2))

#define DDR0_PUB_DX1BDLR0     (DDR0_PUB_REG_BASE + ( 0x210  << 2) )
#define DDR0_PUB_DX1BDLR1     (DDR0_PUB_REG_BASE + ( 0x211  << 2) )
#define DDR0_PUB_DX1BDLR2     (DDR0_PUB_REG_BASE + ( 0x212  << 2) )
#define DDR0_PUB_DX1BDLR3     (DDR0_PUB_REG_BASE + ( 0x214  << 2) )
#define DDR0_PUB_DX1BDLR4     (DDR0_PUB_REG_BASE + ( 0x215  << 2) )
#define DDR0_PUB_DX1BDLR5    ( DDR0_PUB_REG_BASE + ( 0x216  << 2) )
#define DDR0_PUB_DX1BDLR6    ( DDR0_PUB_REG_BASE + ( 0x218  << 2) )
#define DDR0_PUB_DX1LCDLR0    (DDR0_PUB_REG_BASE + ( 0x220  << 2) )
#define DDR0_PUB_DX1LCDLR1    (DDR0_PUB_REG_BASE + ( 0x221  << 2) )
#define DDR0_PUB_DX1LCDLR2    (DDR0_PUB_REG_BASE + ( 0x222  << 2) )
#define DDR0_PUB_DX1LCDLR3    (DDR0_PUB_REG_BASE + ( 0x223  << 2) )
#define DDR0_PUB_DX1LCDLR4    (DDR0_PUB_REG_BASE + ( 0x224  << 2) )
#define DDR0_PUB_DX1LCDLR5    (DDR0_PUB_REG_BASE + ( 0x225  << 2) )
#define DDR0_PUB_DX1MDLR0     (DDR0_PUB_REG_BASE + ( 0x228  << 2) )
#define DDR0_PUB_DX1MDLR1     (DDR0_PUB_REG_BASE + ( 0x229  << 2) )
#define DDR0_PUB_DX1GTR0      (DDR0_PUB_REG_BASE + ( 0x230  << 2 ))
#define DDR0_PUB_DX1GTR1      (DDR0_PUB_REG_BASE + ( 0x231  << 2) )
#define DDR0_PUB_DX1GTR2      (DDR0_PUB_REG_BASE + ( 0x232  << 2) )
#define DDR0_PUB_DX1GTR3      (DDR0_PUB_REG_BASE + ( 0x233  << 2) )

#define DDR0_PUB_DX2BDLR0     (DDR0_PUB_REG_BASE + ( 0x250  << 2) )
#define DDR0_PUB_DX2BDLR1     (DDR0_PUB_REG_BASE + ( 0x251  << 2) )
#define DDR0_PUB_DX2BDLR2     (DDR0_PUB_REG_BASE + ( 0x252  << 2) )
#define DDR0_PUB_DX2BDLR3     (DDR0_PUB_REG_BASE + ( 0x254  << 2) )
#define DDR0_PUB_DX2BDLR4     (DDR0_PUB_REG_BASE + ( 0x255  << 2) )
#define DDR0_PUB_DX2BDLR5     (DDR0_PUB_REG_BASE + ( 0x256  << 2) )
#define DDR0_PUB_DX2BDLR6     (DDR0_PUB_REG_BASE + ( 0x258  << 2) )
#define DDR0_PUB_DX2LCDLR0   ( DDR0_PUB_REG_BASE + ( 0x260  << 2) )
#define DDR0_PUB_DX2LCDLR1    (DDR0_PUB_REG_BASE + ( 0x261  << 2) )
#define DDR0_PUB_DX2LCDLR2   ( DDR0_PUB_REG_BASE + ( 0x262  << 2) )
#define DDR0_PUB_DX2LCDLR3    (DDR0_PUB_REG_BASE + ( 0x263  << 2) )
#define DDR0_PUB_DX2LCDLR4    (DDR0_PUB_REG_BASE + ( 0x264  << 2) )
#define DDR0_PUB_DX2LCDLR5   ( DDR0_PUB_REG_BASE + ( 0x265  << 2) )
#define DDR0_PUB_DX2MDLR0     (DDR0_PUB_REG_BASE + ( 0x268  << 2) )
#define DDR0_PUB_DX2MDLR1     (DDR0_PUB_REG_BASE + ( 0x269  << 2) )
#define DDR0_PUB_DX2GTR0     ( DDR0_PUB_REG_BASE + ( 0x270  << 2 ))
#define DDR0_PUB_DX2GTR1      (DDR0_PUB_REG_BASE + ( 0x271  << 2) )
#define DDR0_PUB_DX2GTR2      (DDR0_PUB_REG_BASE + ( 0x272  << 2) )
#define DDR0_PUB_DX2GTR3      (DDR0_PUB_REG_BASE + ( 0x273  << 2) )

#define DDR0_PUB_DX3BDLR0     (DDR0_PUB_REG_BASE + ( 0x290  << 2) )
#define DDR0_PUB_DX3BDLR1     (DDR0_PUB_REG_BASE + ( 0x291  << 2) )
#define DDR0_PUB_DX3BDLR2     (DDR0_PUB_REG_BASE + ( 0x292  << 2) )
#define DDR0_PUB_DX3BDLR3     (DDR0_PUB_REG_BASE + ( 0x294  << 2) )
#define DDR0_PUB_DX3BDLR4     (DDR0_PUB_REG_BASE + ( 0x295  << 2) )
#define DDR0_PUB_DX3BDLR5     (DDR0_PUB_REG_BASE + ( 0x296  << 2) )
#define DDR0_PUB_DX3BDLR6     (DDR0_PUB_REG_BASE + ( 0x298  << 2) )
#define DDR0_PUB_DX3LCDLR0    (DDR0_PUB_REG_BASE + ( 0x2a0  << 2) )
#define DDR0_PUB_DX3LCDLR1    (DDR0_PUB_REG_BASE + ( 0x2a1  << 2) )
#define DDR0_PUB_DX3LCDLR2    (DDR0_PUB_REG_BASE + ( 0x2a2  << 2) )
#define DDR0_PUB_DX3LCDLR3    (DDR0_PUB_REG_BASE + ( 0x2a3  << 2) )
#define DDR0_PUB_DX3LCDLR4    (DDR0_PUB_REG_BASE + ( 0x2a4  << 2) )
#define DDR0_PUB_DX3LCDLR5    (DDR0_PUB_REG_BASE + ( 0x2a5  << 2) )
#define DDR0_PUB_DX3MDLR0     (DDR0_PUB_REG_BASE + ( 0x2a8  << 2) )
#define DDR0_PUB_DX3MDLR1     (DDR0_PUB_REG_BASE + ( 0x2a9  << 2) )
#define DDR0_PUB_DX3GTR0      (DDR0_PUB_REG_BASE + ( 0x2b0  << 2 ))
#define DDR0_PUB_DX3GTR1     ( DDR0_PUB_REG_BASE + ( 0x2b1  << 2) )
#define DDR0_PUB_DX3GTR2    (  DDR0_PUB_REG_BASE + ( 0x2b2  << 2) )
#define DDR0_PUB_DX3GTR3    (  DDR0_PUB_REG_BASE + ( 0x2b3  << 2) )

#define DDR1_PUB_DX0BDLR0 (	DDR0_PUB_REG_BASE + ( 0x1d0  << 2) )
#define DDR1_PUB_DX0BDLR1 (	DDR0_PUB_REG_BASE + ( 0x1d1  << 2) )
#define DDR1_PUB_DX0BDLR2	(DDR0_PUB_REG_BASE + ( 0x1d2  << 2 ))
#define DDR1_PUB_DX0BDLR3	(DDR0_PUB_REG_BASE + ( 0x1d4  << 2 ))
#define DDR1_PUB_DX0BDLR4	(DDR0_PUB_REG_BASE + ( 0x1d5  << 2) )
#define DDR1_PUB_DX0BDLR5	(DDR0_PUB_REG_BASE + ( 0x1d6  << 2) )
#define DDR1_PUB_DX0BDLR6	(DDR0_PUB_REG_BASE + ( 0x1d8  << 2) )
#define DDR1_PUB_DX0LCDLR0  (	DDR0_PUB_REG_BASE + ( 0x1e0  << 2) )
#define DDR1_PUB_DX0LCDLR1	  (DDR0_PUB_REG_BASE + ( 0x1e1  << 2 ))
#define DDR1_PUB_DX0LCDLR2  (	DDR0_PUB_REG_BASE + ( 0x1e2  << 2) )
#define DDR1_PUB_DX0LCDLR3	  (DDR0_PUB_REG_BASE + ( 0x1e3  << 2 ))
#define DDR1_PUB_DX0LCDLR4  (	DDR0_PUB_REG_BASE + ( 0x1e4  << 2) )
#define DDR1_PUB_DX0LCDLR5	  (DDR0_PUB_REG_BASE + ( 0x1e5  << 2 ))
#define DDR1_PUB_DX0MDLR0	  (DDR0_PUB_REG_BASE + ( 0x1e8  << 2 ))
#define DDR1_PUB_DX0MDLR1	 (DDR0_PUB_REG_BASE + ( 0x1e9  << 2 ))
#define DDR1_PUB_DX0GTR0	(DDR0_PUB_REG_BASE + ( 0x1f0  << 2 ))
#define DDR1_PUB_DX0GTR1	(DDR0_PUB_REG_BASE + ( 0x1f1  << 2) )
#define DDR1_PUB_DX0GTR2	(DDR0_PUB_REG_BASE + ( 0x1f2  << 2) )
#define DDR1_PUB_DX0GTR3	(DDR0_PUB_REG_BASE + ( 0x1f3  << 2))

#define DDR1_PUB_DX1BDLR0	(DDR0_PUB_REG_BASE + ( 0x210  << 2 ))
#define DDR1_PUB_DX1BDLR1	(DDR0_PUB_REG_BASE + ( 0x211  << 2 ))
#define DDR1_PUB_DX1BDLR2	(DDR0_PUB_REG_BASE + ( 0x212  << 2 ))
#define DDR1_PUB_DX1BDLR3	(DDR0_PUB_REG_BASE + ( 0x214  << 2 ))
#define DDR1_PUB_DX1BDLR4	(DDR0_PUB_REG_BASE + ( 0x215  << 2 ))
#define DDR1_PUB_DX1BDLR5	(DDR0_PUB_REG_BASE + ( 0x216  << 2 ))
#define DDR1_PUB_DX1BDLR6	(DDR0_PUB_REG_BASE + ( 0x218  << 2 ))
#define DDR1_PUB_DX1LCDLR0	 (DDR0_PUB_REG_BASE + ( 0x220  << 2 ))
#define DDR1_PUB_DX1LCDLR1	 (DDR0_PUB_REG_BASE + ( 0x221  << 2 ))
#define DDR1_PUB_DX1LCDLR2 (	DDR0_PUB_REG_BASE + ( 0x222  << 2 ))
#define DDR1_PUB_DX1LCDLR3	 (DDR0_PUB_REG_BASE + ( 0x223  << 2 ))
#define DDR1_PUB_DX1LCDLR4 (	DDR0_PUB_REG_BASE + ( 0x224  << 2 ))
#define DDR1_PUB_DX1LCDLR5	 (DDR0_PUB_REG_BASE + ( 0x225  << 2 ))
#define DDR1_PUB_DX1MDLR0	 (DDR0_PUB_REG_BASE + ( 0x228  << 2 ))
#define DDR1_PUB_DX1MDLR1	 (DDR0_PUB_REG_BASE + ( 0x229  << 2 ))
#define DDR1_PUB_DX1GTR0	(DDR0_PUB_REG_BASE + ( 0x230  << 2 ))
#define DDR1_PUB_DX1GTR1	(DDR0_PUB_REG_BASE + ( 0x231  << 2 ))
#define DDR1_PUB_DX1GTR2	(DDR0_PUB_REG_BASE + ( 0x232  << 2 ))
#define DDR1_PUB_DX1GTR3	(DDR0_PUB_REG_BASE + ( 0x233  << 2 ))

#define DDR1_PUB_DX2BDLR0	(DDR0_PUB_REG_BASE + ( 0x250  << 2 ))
#define DDR1_PUB_DX2BDLR1	(DDR0_PUB_REG_BASE + ( 0x251  << 2 ))
#define DDR1_PUB_DX2BDLR2	(DDR0_PUB_REG_BASE + ( 0x252  << 2 ))
#define DDR1_PUB_DX2BDLR3	(DDR0_PUB_REG_BASE + ( 0x254  << 2 ))
#define DDR1_PUB_DX2BDLR4	(DDR0_PUB_REG_BASE + ( 0x255  << 2 ))
#define DDR1_PUB_DX2BDLR5	(DDR0_PUB_REG_BASE + ( 0x256  << 2 ))
#define DDR1_PUB_DX2BDLR6	(DDR0_PUB_REG_BASE + ( 0x258  << 2 ))
#define DDR1_PUB_DX2LCDLR0	 (DDR0_PUB_REG_BASE + ( 0x260  << 2 ))
#define DDR1_PUB_DX2LCDLR1	 (DDR0_PUB_REG_BASE + ( 0x261  << 2 ))
#define DDR1_PUB_DX2LCDLR2 (	DDR0_PUB_REG_BASE + ( 0x262  << 2 ))
#define DDR1_PUB_DX2LCDLR3	 (DDR0_PUB_REG_BASE + ( 0x263  << 2 ))
#define DDR1_PUB_DX2LCDLR4	 (DDR0_PUB_REG_BASE + ( 0x264  << 2 ))
#define DDR1_PUB_DX2LCDLR5	 (DDR0_PUB_REG_BASE + ( 0x265  << 2 ))
#define DDR1_PUB_DX2MDLR0	 (DDR0_PUB_REG_BASE + ( 0x268  << 2 ))
#define DDR1_PUB_DX2MDLR1	 (DDR0_PUB_REG_BASE + ( 0x269  << 2 ))
#define DDR1_PUB_DX2GTR0	(DDR0_PUB_REG_BASE + ( 0x270  << 2 ))
#define DDR1_PUB_DX2GTR1	(DDR0_PUB_REG_BASE + ( 0x271  << 2 ))
#define DDR1_PUB_DX2GTR2	(DDR0_PUB_REG_BASE + ( 0x272  << 2 ))
#define DDR1_PUB_DX2GTR3	(DDR0_PUB_REG_BASE + ( 0x273  << 2 ))

#define DDR1_PUB_DX3BDLR0	(DDR0_PUB_REG_BASE + ( 0x290  << 2 ))
#define DDR1_PUB_DX3BDLR1	(DDR0_PUB_REG_BASE + ( 0x291  << 2 ))
#define DDR1_PUB_DX3BDLR2	(DDR0_PUB_REG_BASE + ( 0x292  << 2 ))
#define DDR1_PUB_DX3BDLR3	(DDR0_PUB_REG_BASE + ( 0x294  << 2 ))
#define DDR1_PUB_DX3BDLR4	(DDR0_PUB_REG_BASE + ( 0x295  << 2 ))
#define DDR1_PUB_DX3BDLR5	(DDR0_PUB_REG_BASE + ( 0x296  << 2 ))
#define DDR1_PUB_DX3BDLR6	(DDR0_PUB_REG_BASE + ( 0x298  << 2 ))
#define DDR1_PUB_DX3LCDLR0	 (DDR0_PUB_REG_BASE + ( 0x2a0  << 2 ))
#define DDR1_PUB_DX3LCDLR1	 (DDR0_PUB_REG_BASE + ( 0x2a1  << 2 ))
#define DDR1_PUB_DX3LCDLR2 (	DDR0_PUB_REG_BASE + ( 0x2a2  << 2 ))
#define DDR1_PUB_DX3LCDLR3	 (DDR0_PUB_REG_BASE + ( 0x2a3  << 2 ))
#define DDR1_PUB_DX3LCDLR4	 (DDR0_PUB_REG_BASE + ( 0x2a4  << 2 ))
#define DDR1_PUB_DX3LCDLR5 (	DDR0_PUB_REG_BASE + ( 0x2a5  << 2 ))
#define DDR1_PUB_DX3MDLR0	 (DDR0_PUB_REG_BASE + ( 0x2a8  << 2 ))
#define DDR1_PUB_DX3MDLR1	(DDR0_PUB_REG_BASE + ( 0x2a9  << 2 ))
#define DDR1_PUB_DX3GTR0	(DDR0_PUB_REG_BASE + ( 0x2b0  << 2 ))
#define DDR1_PUB_DX3GTR1	(DDR0_PUB_REG_BASE + ( 0x2b1  << 2 ))
#define DDR1_PUB_DX3GTR2	(DDR0_PUB_REG_BASE + ( 0x2b2  << 2 ))
#define DDR1_PUB_DX3GTR3	(DDR0_PUB_REG_BASE + ( 0x2b3  << 2 ))


#define DDR0_PUB_ACLCDLR       (DDR0_PUB_REG_BASE + ( 0x160 << 2 )) // R/W - LC Delay Line Present Register
#define DDR0_PUB_ACMDLR0      ( DDR0_PUB_REG_BASE + ( 0x168 << 2 )) // R/W - AC Master Delay Line Register 0
#define DDR0_PUB_ACMDLR1     (  DDR0_PUB_REG_BASE + ( 0x169 << 2 )) // R/W - Master Delay Line Register 1
#define DDR0_PUB_ACBDLR0       (DDR0_PUB_REG_BASE + ( 0x150 << 2 )) // R/W - AC Bit Delay Line Register 0
#define DDR0_PUB_ACBDLR3       ( DDR0_PUB_REG_BASE + ( 0x153 << 2 ) ) // R/W - AC Bit Delay Line Register 3

#define DDR1_PUB_ACLCDLR       (DDR0_PUB_REG_BASE + ( 0x160 << 2 ) )// R/W - LC Delay Line Present Register
#define DDR1_PUB_ACMDLR0      ( DDR0_PUB_REG_BASE + ( 0x168 << 2 )) // R/W - AC Master Delay Line Register 0
#define DDR1_PUB_ACMDLR1      ( DDR0_PUB_REG_BASE + ( 0x169 << 2 )) // R/W - Master Delay Line Register 1
#define DDR1_PUB_ACBDLR0      ( DDR0_PUB_REG_BASE + ( 0x150 << 2 ) )// R/W - AC Bit Delay Line Register 0


 #define DDR0_PUB_ACMDLR					DDR0_PUB_ACMDLR0
 #define DDR1_PUB_ACMDLR					DDR1_PUB_ACMDLR0
 #define DDR0_PUB_DX0GTR	                            DDR0_PUB_DX0GTR0
 #define DDR0_PUB_DX1GTR	                            DDR0_PUB_DX1GTR0
 #define DDR0_PUB_DX2GTR	                            DDR0_PUB_DX2GTR0
 #define DDR0_PUB_DX3GTR	                            DDR0_PUB_DX3GTR0
 #define DDR1_PUB_DX0GTR	                            DDR0_PUB_DX0GTR0
 #define DDR1_PUB_DX1GTR	                            DDR0_PUB_DX1GTR0
 #define DDR1_PUB_DX2GTR	                            DDR0_PUB_DX2GTR0
 #define DDR1_PUB_DX3GTR	                            DDR0_PUB_DX3GTR0


#define DDR0_PUB_IOVCR0       (  DDR0_PUB_REG_BASE + ( 0x148 << 2 )) // R/W - IO VREF Control Register 0
#define DDR0_PUB_IOVCR1      (   DDR0_PUB_REG_BASE + ( 0x149 << 2 )) // R/W - IO VREF Control Register 1
#define DDR0_PUB_VTCR0        (  DDR0_PUB_REG_BASE + ( 0x14A << 2 ) )// R/W - VREF Training Control Register 0
#define DDR0_PUB_VTCR1        (  DDR0_PUB_REG_BASE + ( 0x14B << 2 )) // R/W - VREF Training Control Register 1
#define DDR1_PUB_IOVCR0     (    DDR0_PUB_REG_BASE + ( 0x148 << 2 )) // R/W - IO VREF Control Register 0
#define DDR1_PUB_IOVCR1      (   DDR0_PUB_REG_BASE + ( 0x149 << 2 )) // R/W - IO VREF Control Register 1
#define DDR1_PUB_VTCR0        (  DDR0_PUB_REG_BASE + ( 0x14A << 2 )) // R/W - VREF Training Control Register 0
#define DDR1_PUB_VTCR1        (  DDR0_PUB_REG_BASE + ( 0x14B << 2 )) // R/W - VREF Training Control Register 1

#define DDR0_PUB_MR6           ( DDR0_PUB_REG_BASE + ( 0x066 << 2 ) ) // R/W - Extended Mode Register 6
#define DDR1_PUB_MR6           ( DDR0_PUB_REG_BASE + ( 0x066 << 2 ) ) // R/W - Extended Mode Register 6
#define DDR0_PUB_DX0GCR6      ( DDR0_PUB_REG_BASE + ( 0x1c6  << 2 ) )
#define DDR0_PUB_DX1GCR6      ( DDR0_PUB_REG_BASE + ( 0x206  << 2 ) )
#define DDR0_PUB_DX2GCR6      ( DDR0_PUB_REG_BASE + ( 0x246  << 2 ) )
#define DDR0_PUB_DX3GCR6      ( DDR0_PUB_REG_BASE + ( 0x286  << 2 ) )
 #else

 #define DDR0_PUB_PIR						(DDR0_PUB_REG_BASE+(0x01<<2))
#define DDR0_PUB_PGCR0						(DDR0_PUB_REG_BASE+(0x02<<2))
#define DDR0_PUB_PGCR1						(DDR0_PUB_REG_BASE+(0x03<<2))

#define DDR1_PUB_PIR						(DDR1_PUB_REG_BASE+(0x01<<2))
#define DDR1_PUB_PGCR0						(DDR1_PUB_REG_BASE+(0x02<<2))
#define DDR1_PUB_PGCR1						(DDR1_PUB_REG_BASE+(0x03<<2))

	 #define  DDR0_PUB_DX0BDLR0   (DDR0_PUB_REG_BASE+(0xA7<<2))
	 #define  DDR0_PUB_DX1BDLR0    (DDR0_PUB_REG_BASE+(0xC7<<2))
	 #define  DDR0_PUB_DX2BDLR0   (DDR0_PUB_REG_BASE+(0xE7<<2))
	 #define  DDR0_PUB_DX3BDLR0    (DDR0_PUB_REG_BASE+(0x107<<2))

#define DDR0_PUB_DX0BDLR1					(DDR0_PUB_REG_BASE+(0xA8<<2))
#define DDR0_PUB_DX0BDLR2					(DDR0_PUB_REG_BASE+(0xA9<<2))
#define DDR0_PUB_DX0BDLR3					(DDR0_PUB_REG_BASE+(0xAA<<2))
#define DDR0_PUB_DX0BDLR4					(DDR0_PUB_REG_BASE+(0xAB<<2))
#define DDR0_PUB_DX0BDLR5					(DDR0_PUB_REG_BASE+(0xAC<<2))
#define DDR0_PUB_DX0BDLR6					(DDR0_PUB_REG_BASE+(0xAD<<2))

#define DDR0_PUB_DX0LCDLR0					(DDR0_PUB_REG_BASE+(0xAE<<2))
#define DDR0_PUB_DX0LCDLR1					(DDR0_PUB_REG_BASE+(0xAF<<2))
#define DDR0_PUB_DX0LCDLR2					(DDR0_PUB_REG_BASE+(0xB0<<2))
#define DDR0_PUB_DX0MDLR					(DDR0_PUB_REG_BASE+(0xB1<<2))
#define DDR0_PUB_DX0GTR						(DDR0_PUB_REG_BASE+(0xB2<<2))
#define DDR0_PUB_DX1LCDLR0					(DDR0_PUB_REG_BASE+(0xCE<<2))
#define DDR0_PUB_DX1LCDLR1					(DDR0_PUB_REG_BASE+(0xCF<<2))
#define DDR0_PUB_DX1LCDLR2					(DDR0_PUB_REG_BASE+(0xD0<<2))
#define DDR0_PUB_DX1MDLR					(DDR0_PUB_REG_BASE+(0xD1<<2))
#define DDR0_PUB_DX1GTR						(DDR0_PUB_REG_BASE+(0xD2<<2))
#define DDR0_PUB_DX2LCDLR0					(DDR0_PUB_REG_BASE+(0xEE<<2))
#define DDR0_PUB_DX2LCDLR1					(DDR0_PUB_REG_BASE+(0xEF<<2))
#define DDR0_PUB_DX2LCDLR2					(DDR0_PUB_REG_BASE+(0xF0<<2))
#define DDR0_PUB_DX2MDLR					(DDR0_PUB_REG_BASE+(0xF1<<2))
#define DDR0_PUB_DX3LCDLR0					(DDR0_PUB_REG_BASE+(0x10E<<2))
#define DDR0_PUB_DX3LCDLR1					(DDR0_PUB_REG_BASE+(0x10F<<2))
#define DDR0_PUB_DX3LCDLR2					(DDR0_PUB_REG_BASE+(0x110<<2))
#define DDR0_PUB_DX3MDLR					(DDR0_PUB_REG_BASE+(0x111<<2))
#define DDR0_PUB_DX3GTR						(DDR0_PUB_REG_BASE+(0x112<<2))

#define DDR1_PUB_DX0LCDLR0					(DDR1_PUB_REG_BASE+(0xAE<<2))
#define DDR1_PUB_DX0LCDLR1					(DDR1_PUB_REG_BASE+(0xAF<<2))
#define DDR1_PUB_DX0LCDLR2					(DDR1_PUB_REG_BASE+(0xB0<<2))
#define DDR1_PUB_DX0MDLR					(DDR1_PUB_REG_BASE+(0xB1<<2))
#define DDR1_PUB_DX0GTR						(DDR1_PUB_REG_BASE+(0xB2<<2))
#define DDR1_PUB_DX1LCDLR0					(DDR1_PUB_REG_BASE+(0xCE<<2))
#define DDR1_PUB_DX1LCDLR1					(DDR1_PUB_REG_BASE+(0xCF<<2))
#define DDR1_PUB_DX1LCDLR2					(DDR1_PUB_REG_BASE+(0xD0<<2))
#define DDR1_PUB_DX1MDLR					(DDR1_PUB_REG_BASE+(0xD1<<2))
#define DDR1_PUB_DX1GTR						(DDR1_PUB_REG_BASE+(0xD2<<2))
#define DDR1_PUB_DX2LCDLR0					(DDR1_PUB_REG_BASE+(0xEE<<2))
#define DDR1_PUB_DX2LCDLR1					(DDR1_PUB_REG_BASE+(0xEF<<2))
#define DDR1_PUB_DX2LCDLR2					(DDR1_PUB_REG_BASE+(0xF0<<2))
#define DDR1_PUB_DX2MDLR					(DDR1_PUB_REG_BASE+(0xF1<<2))
#define DDR1_PUB_DX3LCDLR0					(DDR1_PUB_REG_BASE+(0x10E<<2))
#define DDR1_PUB_DX3LCDLR1					(DDR1_PUB_REG_BASE+(0x10F<<2))
#define DDR1_PUB_DX3LCDLR2					(DDR1_PUB_REG_BASE+(0x110<<2))
#define DDR1_PUB_DX3MDLR					(DDR1_PUB_REG_BASE+(0x111<<2))
#define DDR1_PUB_DX3GTR						(DDR1_PUB_REG_BASE+(0x112<<2))


	 #define DDR0_PUB_ACMDLR						(DDR0_PUB_REG_BASE+(0x0E<<2))
#define DDR0_PUB_ACLCDLR					(DDR0_PUB_REG_BASE+(0x0F<<2))
#define DDR0_PUB_ACBDLR0					(DDR0_PUB_REG_BASE+(0x10<<2))
#define DDR0_PUB_ACBDLR3					(DDR0_PUB_REG_BASE+(0x13<<2))
	 #define DDR1_PUB_ACMDLR						(DDR1_PUB_REG_BASE+(0x0E<<2))
#define DDR1_PUB_ACLCDLR					(DDR1_PUB_REG_BASE+(0x0F<<2))
#define DDR1_PUB_ACBDLR0					(DDR1_PUB_REG_BASE+(0x10<<2))

 #define DDR0_PUB_ACMDLR0	DDR0_PUB_ACMDLR
 #define DDR1_PUB_ACMDLR0	DDR1_PUB_ACMDLR
 #define DDR0_PUB_DX0MDLR0 DDR0_PUB_DX0MDLR
 #define DDR0_PUB_DX1MDLR0 DDR0_PUB_DX1MDLR
 #define DDR0_PUB_DX2MDLR0 DDR0_PUB_DX2MDLR
 #define DDR0_PUB_DX3MDLR0 DDR0_PUB_DX3MDLR
#define DDR1_PUB_DX0MDLR0 DDR0_PUB_DX0MDLR
#define DDR1_PUB_DX1MDLR0 DDR0_PUB_DX1MDLR
#define DDR1_PUB_DX2MDLR0 DDR0_PUB_DX2MDLR
#define DDR1_PUB_DX3MDLR0 DDR0_PUB_DX3MDLR

#ifndef  P_DDR0_CLK_CTRL
#define P_DDR0_CLK_CTRL   0xc8000800
#endif
#ifndef  P_DDR1_CLK_CTRL
#define P_DDR1_CLK_CTRL  0xc8002800
#endif

#define DDR0_PUB_IOVCR0						(DDR0_PUB_REG_BASE+(0x8E<<2))
#define DDR0_PUB_IOVCR1						(DDR0_PUB_REG_BASE+(0x8F<<2))
#endif

#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_BABY)
//unsigned int des[8];
/*
	unsigned int pattern_1[4][8]=
	{
	0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,
0xff00ff00	,

	};
	unsigned int pattern_2[4][8]={
0x0001fe00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x0002fd00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x0004fb00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x0008f700	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x0010ef00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x0020df00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x0040bf00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,
0x00807f00	,
0x0000ff00	,
0x0000ff00	,
0x0000ff00	,

	};
	unsigned int pattern_3[4][8]={
		0x00010000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00020000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00040000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00080000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00100000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00200000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00400000	,
0x00000000	,
0x00000000	,
0x00000000	,
0x00800000	,
0x00000000	,
0x00000000	,
0x00000000	,
};
	unsigned int pattern_4[4][8]={
		0x51c8c049	,
0x2d43592c	,
0x0777b50b	,
0x9cd2ebe5	,
0xc04199d5	,
0xdc968dc0	,
0xb8ba8a33	,
0x35e4327f	,
0x51c8c049	,
0x2d43592c	,
0x0777b50b	,
0x9cd2ebe5	,
0xc04199d5	,
0xdc968dc0	,
0xb8ba8a33	,
0x35e4327f	,
0x51c8c049	,
0x2d43592c	,
0x0777b50b	,
0x9cd2ebe5	,
0xc04199d5	,
0xdc968dc0	,
0xb8ba8a33	,
0x35e4327f	,
0x51c8c049	,
0x2d43592c	,
0x0777b50b	,
0x9cd2ebe5	,
0xc04199d5	,
0xdc968dc0	,
0xb8ba8a33	,
0x35e4327f	,
};
	unsigned int pattern_5[4][8]={
		0xaec9c149	,
0xd243592c	,
0xf877b50b	,
0x63d2ebe5	,
0x3f439bd5	,
0x23968dc0	,
0x47ba8a33	,
0xcae4327f	,
0xaeccc449	,
0xd243592c	,
0xf877b50b	,
0x63d2ebe5	,
0x3f4991d5	,
0x23968dc0	,
0x47ba8a33	,
0xcae4327f	,
0xaed8d049	,
0xd243592c	,
0xf877b50b	,
0x63d2ebe5	,
0x3f61b9d5	,
0x23968dc0	,
0x47ba8a33	,
0xcae4327f	,
0xae888049	,
0xd243592c	,
0xf877b50b	,
0x63d2ebe5	,
0x3fc119d5	,
0x23968dc0	,
0x47ba8a33	,
0xcae4327f	,
};
	unsigned int pattern_6[4][8]={
0xaec9c149	,
0xd243a62c	,
0xf8774a0b	,
0x63d214e5	,
0x3f4366d5	,
0x239672c0	,
0x47ba7533	,
0xcae4cd7f	,
0xaecc3f49	,
0xd243a62c	,
0xf8774a0b	,
0x63d214e5	,
0x3f4966d5	,
0x239672c0	,
0x47ba7533	,
0xcae4cd7f	,
0xaed83f49	,
0xd243a62c	,
0xf8774a0b	,
0x63d214e5	,
0x3f6166d5	,
0x239672c0	,
0x47ba7533	,
0xcae4cd7f	,
0xae883f49	,
0xd243a62c	,
0xf8774a0b	,
0x63d214e5	,
0x3fc166d5	,
0x239672c0	,
0x47ba7533	,
0xcae4cd7f	,

	};
  unsigned int  des[8] ={
	0xaec83f49,
	   0xd243a62c,
	   0xf8774a0b,
	   0x63d214e5,
	   0x3f4166d5,
	   0x239672c0,
	   0x47ba7533,
	   0xcae4cd7f,
	};
  */
  /*
	unsigned int  des[8] ;
  des[0] = 	0xaec83f49;
   des[1] =      0xd243a62c;
   des[2] =      0xf8774a0b;
  des[3] =       0x63d214e5;
   des[4] =      0x3f4166d5;
	des[5] =     0x239672c0;
   des[6] =      0x47ba7533;
   des[7] =      0xcae4cd7f;
	pattern_1[0][0] = 0xff00ff00;
	pattern_1[0][1] = 0xff00ff00;
	pattern_1[0][2] = 0xff00ff00;
	pattern_1[0][3] = 0xff00ff00;
	pattern_1[0][4] = 0xff00ff00;
	pattern_1[0][5] = 0xff00ff00;
	pattern_1[0][6] = 0xff00ff00;
	pattern_1[0][7] = 0xff00ff00;

	pattern_1[1][0] = 0xff00ff00;
	pattern_1[1][1] = 0xff00ff00;
	pattern_1[1][2] = 0xff00ff00;
	pattern_1[1][3] = 0xff00ff00;
	pattern_1[1][4] = 0xff00ff00;
	pattern_1[1][5] = 0xff00ff00;
	pattern_1[1][6] = 0xff00ff00;
	pattern_1[1][7] = 0xff00ff00;

	pattern_1[2][0] = 0xff00ff00;
	pattern_1[2][1] = 0xff00ff00;
	pattern_1[2][2] = 0xff00ff00;
	pattern_1[2][3] = 0xff00ff00;
	pattern_1[2][4] = 0xff00ff00;
	pattern_1[2][5] = 0xff00ff00;
	pattern_1[2][6] = 0xff00ff00;
	pattern_1[2][7] = 0xff00ff00;

	pattern_1[3][0] = 0xff00ff00;
	pattern_1[3][1] = 0xff00ff00;
	pattern_1[3][2] = 0xff00ff00;
	pattern_1[3][3] = 0xff00ff00;
	pattern_1[3][4] = 0xff00ff00;
	pattern_1[3][5] = 0xff00ff00;
	pattern_1[3][6] = 0xff00ff00;
	pattern_1[3][7] = 0xff00ff00;

	pattern_2[0][0] = 0x0001fe00;
	pattern_2[0][1] = 0x0000ff00;
	pattern_2[0][2] = 0x0000ff00;
	pattern_2[0][3] = 0x0000ff00;
	pattern_2[0][4] = 0x0002fd00;
	pattern_2[0][5] = 0x0000ff00;
	pattern_2[0][6] = 0x0000ff00;
	pattern_2[0][7] = 0x0000ff00;

	pattern_2[1][0] = 0x0004fb00;
	pattern_2[1][1] = 0x0000ff00;
	pattern_2[1][2] = 0x0000ff00;
	pattern_2[1][3] = 0x0000ff00;
	pattern_2[1][4] = 0x0008f700;
	pattern_2[1][5] = 0x0000ff00;
	pattern_2[1][6] = 0x0000ff00;
	pattern_2[1][7] = 0x0000ff00;

	pattern_2[2][0] = 0x0010ef00;
	pattern_2[2][1] = 0x0000ff00;
	pattern_2[2][2] = 0x0000ff00;
	pattern_2[2][3] = 0x0000ff00;
	pattern_2[2][4] = 0x0020df00;
	pattern_2[2][5] = 0x0000ff00;
	pattern_2[2][6] = 0x0000ff00;
	pattern_2[2][7] = 0x0000ff00;

	pattern_2[3][0] = 0x0040bf00;
	pattern_2[3][1] = 0x0000ff00;
	pattern_2[3][2] = 0x0000ff00;
	pattern_2[3][3] = 0x0000ff00;
	pattern_2[3][4] = 0x00807f00;
	pattern_2[3][5] = 0x0000ff00;
	pattern_2[3][6] = 0x0000ff00;
	pattern_2[3][7] = 0x0000ff00;

	pattern_3[0][0] = 0x00010000;
	pattern_3[0][1] = 0x00000000;
	pattern_3[0][2] = 0x00000000;
	pattern_3[0][3] = 0x00000000;
	pattern_3[0][4] = 0x00020000;
	pattern_3[0][5] = 0x00000000;
	pattern_3[0][6] = 0x00000000;
	pattern_3[0][7] = 0x00000000;

	pattern_3[1][0] = 0x00040000;
	pattern_3[1][1] = 0x00000000;
	pattern_3[1][2] = 0x00000000;
	pattern_3[1][3] = 0x00000000;
	pattern_3[1][4] = 0x00080000;
	pattern_3[1][5] = 0x00000000;
	pattern_3[1][6] = 0x00000000;
	pattern_3[1][7] = 0x00000000;

	pattern_3[2][0] = 0x00100000;
	pattern_3[2][1] = 0x00000000;
	pattern_3[2][2] = 0x00000000;
	pattern_3[2][3] = 0x00000000;
	pattern_3[2][4] = 0x00200000;
	pattern_3[2][5] = 0x00000000;
	pattern_3[2][6] = 0x00000000;
	pattern_3[2][7] = 0x00000000;

	pattern_3[3][0] = 0x00400000;
	pattern_3[3][1] = 0x00000000;
	pattern_3[3][2] = 0x00000000;
	pattern_3[3][3] = 0x00000000;
	pattern_3[3][4] = 0x00800000;
	pattern_3[3][5] = 0x00000000;
	pattern_3[3][6] = 0x00000000;
	pattern_3[3][7] = 0x00000000;

pattern_4[0][0] =	0x51c8c049	;
pattern_4[0][1] =	0x2d43592c	;
pattern_4[0][2] =	0x0777b50b	;
pattern_4[0][3] =	0x9cd2ebe5	;
pattern_4[0][4] =	0xc04199d5	;
pattern_4[0][5] =	0xdc968dc0	;
pattern_4[0][6] =	0xb8ba8a33	;
pattern_4[0][7] =	0x35e4327f	;

pattern_4[1][0] =	0x51c8c049	;
pattern_4[1][1] =	0x2d43592c	;
pattern_4[1][2] =	0x0777b50b	;
pattern_4[1][3] =	0x9cd2ebe5	;
pattern_4[1][4] =	0xc04199d5	;
pattern_4[1][5] =	0xdc968dc0	;
pattern_4[1][6] =	0xb8ba8a33	;
pattern_4[1][7] =	0x35e4327f	;

pattern_4[2][0] =	0x51c8c049	;
pattern_4[2][1] =	0x2d43592c	;
pattern_4[2][2] =	0x0777b50b	;
pattern_4[2][3] =	0x9cd2ebe5	;
pattern_4[2][4] =	0xc04199d5	;
pattern_4[2][5] =	0xdc968dc0	;
pattern_4[2][6] =	0xb8ba8a33	;
pattern_4[2][7] =	0x35e4327f	;

pattern_4[3][0] =	0x51c8c049	;
pattern_4[3][1] =	0x2d43592c	;
pattern_4[3][2] =	0x0777b50b	;
pattern_4[3][3] =	0x9cd2ebe5	;
pattern_4[3][4] =	0xc04199d5	;
pattern_4[3][5] =	0xdc968dc0	;
pattern_4[3][6] =	0xb8ba8a33	;
pattern_4[3][7] =	0x35e4327f	;

pattern_5[0][0] =	0xaec9c149	;
pattern_5[0][1] =	0xd243592c	;
pattern_5[0][2] =	0xf877b50b	;
pattern_5[0][3] =	0x63d2ebe5	;
pattern_5[0][4] =	0x3f439bd5	;
pattern_5[0][5] =	0x23968dc0	;
pattern_5[0][6] =	0x47ba8a33	;
pattern_5[0][7] =	0xcae4327f	;
pattern_5[1][0] =	0xaeccc449	;
pattern_5[1][1] =	0xd243592c	;
pattern_5[1][2] =	0xf877b50b	;
pattern_5[1][3] =	0x63d2ebe5	;
pattern_5[1][4] =	0x3f4991d5	;
pattern_5[1][5] =	0x23968dc0	;
pattern_5[1][6] =	0x47ba8a33	;
pattern_5[1][7] =	0xcae4327f	;
pattern_5[2][0] =	0xaed8d049	;
pattern_5[2][1] =	0xd243592c	;
pattern_5[2][2] =	0xf877b50b	;
pattern_5[2][3] =	0x63d2ebe5	;
pattern_5[2][4] =	0x3f61b9d5	;
pattern_5[2][5] =	0x23968dc0	;
pattern_5[2][6] =	0x47ba8a33	;
pattern_5[2][7] =	0xcae4327f	;
pattern_5[3][0] =	0xae888049	;
pattern_5[3][1] =	0xd243592c	;
pattern_5[3][2] =	0xf877b50b	;
pattern_5[3][3] =	0x63d2ebe5	;
pattern_5[3][4] =	0x3fc119d5	;
pattern_5[3][5] =	0x23968dc0	;
pattern_5[3][6] =	0x47ba8a33	;
pattern_5[3][7] =	0xcae4327f	;

pattern_6[0][1] =	0xd243a62c	;
pattern_6[0][2] =	0xf8774a0b	;
pattern_6[0][3] =	0x63d214e5	;
pattern_6[0][4] =	0x3f4366d5	;
pattern_6[0][5] =	0x239672c0	;
pattern_6[0][6] =	0x47ba7533	;
pattern_6[0][7] =	0xcae4cd7f	;
pattern_6[1][0] =	0xaecc3f49	;
pattern_6[1][1] =	0xd243a62c	;
pattern_6[1][2] =	0xf8774a0b	;
pattern_6[1][3] =	0x63d214e5	;
pattern_6[1][4] =	0x3f4966d5	;
pattern_6[1][5] =	0x239672c0	;
pattern_6[1][6] =	0x47ba7533	;
pattern_6[1][7] =	0xcae4cd7f	;
pattern_6[2][0] =	0xaed83f49	;
pattern_6[2][1] =	0xd243a62c	;
pattern_6[2][2] =	0xf8774a0b	;
pattern_6[2][3] =	0x63d214e5	;
pattern_6[2][4] =	0x3f6166d5	;
pattern_6[2][5] =	0x239672c0	;
pattern_6[2][6] =	0x47ba7533	;
pattern_6[2][7] =	0xcae4cd7f	;
pattern_6[3][0] =	0xae883f49	;
pattern_6[3][1] =	0xd243a62c	;
pattern_6[3][2] =	0xf8774a0b	;
pattern_6[3][3] =	0x63d214e5	;
pattern_6[3][4] =	0x3fc166d5	;
pattern_6[3][5] =	0x239672c0	;
pattern_6[3][6] =	0x47ba7533	;
pattern_6[3][7] =	0xcae4cd7f	;
*/
#endif

#define DDR_TEST_START_ADDR  0x1080000//  0x10000000 //CONFIG_SYS_MEMTEST_START
#define DDR_TEST_SIZE 0x2000000
//#define DDR_TEST_SIZE 0x2000

static void ddr_write(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
	 unsigned int  i, j, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
        for (j=0;j<32;j++)
		{

            if (m_len >= 128)
				n = 32;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
                switch (i)
				{
					case 0:
					case 9:
					case 14:
					case 25:
					case 30:
						*(p+i) = TDATA32F;
						break;
					case 1:
					case 6:
					case 8:
					case 17:
					case 22:
						*(p+i) = 0;
						break;
					case 16:
					case 23:
					case 31:
						*(p+i) = TDATA32A;
						break;
					case 7:
					case 15:
					case 24:
						*(p+i) = TDATA325;
						break;
					case 2:
					case 4:
					case 10:
					case 12:
					case 19:
					case 21:
					case 27:
					case 29:
						*(p+i) = 1<<j;
						break;
					case 3:
					case 5:
					case 11:
					case 13:
					case 18:
					case 20:
					case 26:
					case 28:
						*(p+i) = ~(1<<j);
						break;
				}
			}

            if (m_len > 128)
			{
				m_len -= 128;
				p += 32;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}





static void ddr_read(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
	 unsigned int  i, j, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
        for (j=0;j<32;j++)
		{

            if (m_len >= 128)
				n = 32;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
               if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				 break;
				}
                switch (i)
				{

					case 0:
					case 9:
					case 14:
					case 25:
					case 30:
                        if (*(p+i) != TDATA32F)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;
					case 1:
					case 6:
					case 8:
					case 17:
					case 22:
                        if (*(p+i) != 0) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0);
						}break;
					case 16:
					case 23:
					case 31:
                        if (*(p+i) != TDATA32A) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32A);
					   } break;
					case 7:
					case 15:
					case 24:
                        if (*(p+i) != TDATA325) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA325);
					   } break;
					case 2:
					case 4:
					case 10:
					case 12:
					case 19:
					case 21:
					case 27:
					case 29:
                        if (*(p+i) != 1<<j) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 1<<j);
					   } break;
					case 3:
					case 5:
					case 11:
					case 13:
					case 18:
					case 20:
					case 26:
					case 28:
                        if (*(p+i) != ~(1<<j)) {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~(1<<j));
					   } break;
				}
			}

            if (m_len > 128)
			{
				m_len -= 128;
				p += 32;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}




static void ddr_write4(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
	 unsigned int  i, j, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
        for (j=0;j<32;j++)
		{

            if (m_len >= 128)
				n = 32;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
                switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:

						*(p+i) = 0xff00ff00;
						break;
					case 4:
					case 5:
					case 6:
					case 7:

						*(p+i) = ~0xff00ff00;
						break;
					case 8:
					case 9:
					case 10:
		      case 11:
						*(p+i) = 0xaa55aa55;
						break;
					case 12:
					case 13:
					case 14:
		      case 15:
						*(p+i) = ~0xaa55aa55;
						break;
					case 16:
					case 17:
					case 18:
					case 19:

			 case 24:
					case 25:
					case 26:
					case 27:

				   *(p+i) = 1<<j;
						break;

					 case 20:
					case 21:
					case 22:
					case 23:
					case 28:
					case 29:
					case 30:
					case 31:
						*(p+i) = ~(1<<j);
						break;
				}
			}

            if (m_len > 128)
			{
				m_len -= 128;
				p += 32;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}







static void ddr_read4(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
	 unsigned int  i, j, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
        for (j=0;j<32;j++)
		{

            if (m_len >= 128)
				n = 32;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
               if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				 break;
				}
                switch (i)
				{

					case 0:
					case 1:
					case 2:
					case 3:

					 //   *(p+i) = 0xff00ff00;
                       if (*(p+i) != 0xff00ff00)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;
					case 4:
					case 5:
					case 6:
					case 7:

				  //      *(p+i) = ~0xff00ff00;
                    if (*(p+i) != ~0xff00ff00)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;
					case 8:
					case 9:
					case 10:
		      case 11:
					//    *(p+i) = 0xaa55aa55;
                      if (*(p+i) != 0xaa55aa55)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;
					case 12:
					case 13:
					case 14:
		      case 15:
					 //   *(p+i) = ~0xaa55aa55;
                       if (*(p+i) != ~0xaa55aa55)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;
					case 16:
					case 17:
					case 18:
					case 19:

			 case 24:
					case 25:
					case 26:
					case 27:

				//   *(p+i) = 1<<j;
				  if (*(p+i) != (1<<j))
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;

					 case 20:
					case 21:
					case 22:
					case 23:
					case 28:
					case 29:
					case 30:
					case 31:
					  //  *(p+i) = ~(1<<j);
                        if (*(p+i) !=~( 1<<j))
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							}
						break;
				}
			}

            if (m_len > 128)
			{
				m_len -= 128;
				p += 32;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}

///*
static void ddr_test_copy(void *addr_dest,void *addr_src,unsigned int memcpy_size)
{
	 unsigned int  *p_dest;
	 unsigned int  *p_src;

	 unsigned int  m_len = memcpy_size;

	p_dest = ( unsigned int  *)addr_dest;
	p_src = ( unsigned int  *)addr_src;
m_len = m_len/4; //assume it's multiple of 4
while (m_len--) {
		ddr_pld_cache(p_src)  ;//#define ddr_pld_cache(P)   asm ("prfm PLDL1KEEP, [%0, #376]"::"r" (P))
	*p_dest++ = *p_src++;
	*p_dest++ = *p_src++;
	*p_dest++ = *p_src++;
	*p_dest++ = *p_src++;
}
}
//*/
/*
static void ddr_test_copy(void *addr_dest,void *addr_src,unsigned int memcpy_size)
{
   //  unsigned int  *p_dest;
	// unsigned int  *p_src;

	 unsigned int  m_len = memcpy_size;
	 unsigned int  temp3 = 0;
	 unsigned int  temp4 = 0;

	asm ("mov %0,%1"::"r" (temp4),"r" (addr_dest));
	asm ("subs %0,%0,#8"::"r" (m_len));
	 asm ("1: ldr %0,[%1],#8"::"r" (temp3),"r" (addr_src));
	  asm ("subs %0,%0,#8"::"r" (m_len));
	   asm ("str %0,[%1],#8"::"r" (temp3),"r" (temp4));
		asm ("prfm PLDL1KEEP, [%0, #376]"::"r" (addr_src));
		asm ("b.pl 1b"::);
		asm ("ret"::);





}
*/
int do_ddr_test_copy(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *endp;
	 unsigned long   loop = 1;
	unsigned int   print_flag =1;
	// unsigned int  start_addr = DDR_TEST_START_ADDR;
	 unsigned int  src_addr = DDR_TEST_START_ADDR;
	 unsigned int  dec_addr = DDR_TEST_START_ADDR+0x8000000;
	      unsigned int  test_size = DDR_TEST_SIZE;


print_flag=1;

		   printf("\nargc== 0x%08x\n", argc);
			int i ;
	for (i = 0;i<argc;i++)
		{
		printf("\nargv[%d]=%s\n",i,argv[i]);
		}



		//    printf("\nLINE== 0x%08x\n", __LINE__);
		    if (argc ==1) {
	//    start_addr = simple_strtoul(argv[2], &endp, 16);
	//    if (*argv[2] == 0 || *endp != 0)
			src_addr = DDR_TEST_START_ADDR;
	  loop = 1;

	}
    if (argc > 2) {
	//    start_addr = simple_strtoul(argv[2], &endp, 16);
        if (*argv[2] == 0 || *endp != 0)
			src_addr = DDR_TEST_START_ADDR;

	}
	    if (argc > 3) {

	src_addr = simple_strtoul(argv[1], &endp, 16);
	   dec_addr = simple_strtoul(argv[2], &endp, 16);
	    test_size = simple_strtoul(argv[3], &endp, 16);
		   loop = 1;
        if (*argv[3] == 0 || *endp != 0)
			test_size = DDR_TEST_SIZE;

	}
		if (test_size<0x1000)
			test_size = DDR_TEST_SIZE;
	   if (argc > 4) {
		loop = simple_strtoul(argv[4], &endp, 16);
		       if (*argv[4] == 0 || *endp != 0)
			loop = 1;
		}
			   if (argc > 5) {
		print_flag = simple_strtoul(argv[5], &endp, 16);
		       if (*argv[5] == 0 || *endp != 0)
			print_flag = 1;
		}
//COPY_TEST_START:

///*
	  unsigned long time_start, time_end,test_loops;
test_loops=loop;
unsigned long size_count=0;
size_count=loop*test_size;
time_start = get_us_time();//us

	do {

	  //     loop = 1;


ddr_test_copy((void *)(int_convter_p(dec_addr)),(void *)(int_convter_p(src_addr)),test_size);
//bcopy((void *)(int_convter_p(src_addr)),(void *)(int_convter_p(dec_addr)),test_size);
//mcopy((void *)(int_convter_p(src_addr)),(void *)(int_convter_p(dec_addr)),test_size);
if (print_flag)
{
		  printf("\nloop==0x%08x", ( unsigned int )loop);
		   printf("\n      \n");
}
	  }while(--loop);
//*/
	time_end = get_us_time();//us
	printf("\ncopy %d times use %dus\n                             \n",( unsigned int )test_loops,( unsigned int )(time_end-time_start));

	printf("\nddr copy bandwidth==%d MBYTE/S \n                             \n",(unsigned int)(size_count/(time_end-time_start)));
 printf("\rEnd ddr test.                              \n");

unsigned int m_len=0,counter=0;
   unsigned int  *p_dest;
 p_dest=  (void *)(int_convter_p(dec_addr));
m_len = test_size/4; //assume it's multiple of 4
counter=(unsigned int)test_loops;
size_count=counter*test_size;
time_start = get_us_time();//us
do {
	 loop = 1;
	m_len = test_size/4;
while (m_len--) {
		ddr_pld_cache(p_dest)  ;
	*p_dest++ = 0x12345678;
	*p_dest++ = 0x12345678;
	*p_dest++ = 0x12345678;
	*p_dest++ = 0x12345678;
}
  }while(--counter);
   time_end = get_us_time();//us
	printf("\nwrite %d bytes use %dus\n                             \n",( unsigned int )test_size,( unsigned int )(time_end-time_start));

	printf("\nddr write bandwidth==%d MBYTE/S \n                             \n",(unsigned int)(size_count/(time_end-time_start)));

unsigned int  *p_src;
 p_src=  (void *)(int_convter_p(src_addr));
m_len = test_size/4; //assume it's multiple of 4
unsigned int temp0=0;
//unsigned int temp1=0;
//unsigned int temp2=0;
//unsigned int temp3=0;
counter=(unsigned int)test_loops;
size_count=counter*test_size;

//  #define OPEN_CHANNEL_A_PHY_CLK()      (writel((0), 0xc8836c00))
//writel((1000000<<0), DMC_MON_CTRL1);
//writel((0<<31)|(1<<30)|(0<<20)|(1<<16)|(1<<0), DMC_MON_CTRL2);
//writel((1<<31)|(0<<30)|(0<<20)|(1<<16)|(1<<0), DMC_MON_CTRL2);
time_start = get_us_time();//us
do {
	 loop = 1;
	m_len = test_size/4;
while (m_len--) {
	  //  ddr_pld_cache(p_src++)  ;
	#ifdef DDR_PREFETCH_CACHE
	  __asm__ __volatile__ ("prfm PLDL1KEEP, [%0, #376]"::"r" (p_src));
	#endif
	    p_src++;
		 temp0 =( *p_src);
m_len--;
m_len--;
m_len--;
m_len--;
m_len--;
m_len--;
m_len--;
}
  }while(--counter);
	*p_dest++ = temp0;
	*p_dest++ = *p_src;
	*p_dest++ = *p_src;
	*p_dest++ = *p_src;
   time_end = get_us_time();//us



	printf("\nread %d Kbytes use %dus\n                             \n",(unsigned int)(size_count/1000),( unsigned int )(time_end-time_start));
	printf("\nddr read bandwidth==%d MBYTE/S \n                             \n",(unsigned int)(size_count/(time_end-time_start)));

	  return 0;

//usage:
//	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(
	ddr_test_copy,	7,	1,	do_ddr_test_copy,
	"ddr_test_copy function",
	"ddr_test_copy  0x08000000 0x10000000 0x02000000 1 0 ? \n"
);

///*
#define DDR_PATTERN_LOOP_1 32
#define DDR_PATTERN_LOOP_2 64
#define DDR_PATTERN_LOOP_3 96
/*
__asm
{
.Global memcpy_pld
.type memcpy_pld ,%function
.align 8
memcpy_pld:
mov x4,x0
subs x2,x2,#8
b.mi 2f
1: ldr x3,[x1],#8
	subs x2,x2,#8
	str x3,[x4],#8
	prfm PLDL1KEEP,[x1,#376]
	b.pl  1b

2: adds x2,x2,#4
	b.mi 3f
	ldr w3,[x1],#4
	sub x2,x2,#4
	str w3,[x4],#4

3: adds x2,x2,#2
	b.mi 4f
	ldr w3,[x1],#2
	sub x2,x2,#4
	str w3,[x4],#4

4: adds x2,x2,#1
	b.mi 5f
	ldr w3,[x1],#2
	sub x2,x2,#4
	str w3,[x4],#4

5: ret
}
*/
//static void ddr_memcpy_pld(void *addr_dest,  void *addr_src, unsigned int  m_length)
//{
/*
asm
{
//.Global memcpy_pld
.type memcpy_pld ,%function
.align 8
memcpy_pld:
mov x4,x0
subs x2,x2,#8
b.mi 2f
1: ldr x3,[x1],#8
	subs x2,x2,#8
	str x3,[x4],#8
	prfm PLDL1KEEP,[x1,#376]
	b.pl  1b

2: adds x2,x2,#4
	b.mi 3f
	ldr w3,[x1],#4
	sub x2,x2,#4
	str w3,[x4],#4

3: adds x2,x2,#2
	b.mi 4f
	ldr w3,[x1],#2
	sub x2,x2,#4
	str w3,[x4],#4

4: adds x2,x2,#1
	b.mi 5f
	ldr w3,[x1],#2
	sub x2,x2,#4
	str w3,[x4],#4

5: ret
}
memcpy_pld(addr_dest,addr_src,m_length);
*/
//}



#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_BABY)

///*

int ddr_test_gx_cross_talk_pattern(int ddr_test_size)
{
 unsigned int  start_addr = 0x10000000;
	error_outof_count_flag=1;
		error_count=0;

	 unsigned int  des[8] ;
 unsigned int  pattern_1[4][8] ;
 unsigned int  pattern_2[4][8] ;
 unsigned int  pattern_3[4][8] ;
 unsigned int  pattern_4[4][8] ;
 unsigned int  pattern_5[4][8] ;
  unsigned int  pattern_6[4][8] ;

  des[0] = 	0xaec83f49;
   des[1] =      0xd243a62c;
   des[2] =      0xf8774a0b;
  des[3] =       0x63d214e5;
   des[4] =      0x3f4166d5;
	des[5] =     0x239672c0;
   des[6] =      0x47ba7533;
   des[7] =      0xcae4cd7f;
	pattern_1[0][0] = 0xff00ff00;
	pattern_1[0][1] = 0xff00ff00;
	pattern_1[0][2] = 0xff00ff00;
	pattern_1[0][3] = 0xff00ff00;
	pattern_1[0][4] = 0xff00ff00;
	pattern_1[0][5] = 0xff00ff00;
	pattern_1[0][6] = 0xff00ff00;
	pattern_1[0][7] = 0xff00ff00;

	 pattern_1[1][0] = 0x00ffff00;
	pattern_1[1][1] = 0x00ffff00;
	pattern_1[1][2] = 0x00ffff00;
	pattern_1[1][3] = 0x00ffff00;
	pattern_1[1][4] = 0x00ffff00;
	pattern_1[1][5] = 0x00ffff00;
	pattern_1[1][6] = 0x00ffff00;
	pattern_1[1][7] = 0x00ffff00;

	pattern_1[2][0] = 0xffff0000;
	pattern_1[2][1] = 0xffff0000;
	pattern_1[2][2] = 0xffff0000;
	pattern_1[2][3] = 0xffff0000;
	pattern_1[2][4] = 0xffff0000;
	pattern_1[2][5] = 0xffff0000;
	pattern_1[2][6] = 0xffff0000;
	pattern_1[2][7] = 0xffff0000;
	pattern_1[3][0] = 0xff00ff00;
	pattern_1[3][1] = 0xff00ff00;
	pattern_1[3][2] = 0xff00ff00;
	pattern_1[3][3] = 0xff00ff00;
	pattern_1[3][4] = 0xff00ff00;
	pattern_1[3][5] = 0xff00ff00;
	pattern_1[3][6] = 0xff00ff00;
	pattern_1[3][7] = 0xff00ff00;

	pattern_2[0][0] = 0x0001fe00;
	pattern_2[0][1] = 0x0000ff00;
	pattern_2[0][2] = 0x0000ff00;
	pattern_2[0][3] = 0x0000ff00;
	pattern_2[0][4] = 0x0002fd00;
	pattern_2[0][5] = 0x0000ff00;
	pattern_2[0][6] = 0x0000ff00;
	pattern_2[0][7] = 0x0000ff00;

	pattern_2[1][0] = 0x0004fb00;
	pattern_2[1][1] = 0x0000ff00;
	pattern_2[1][2] = 0x0000ff00;
	pattern_2[1][3] = 0x0000ff00;
	pattern_2[1][4] = 0x0008f700;
	pattern_2[1][5] = 0x0000ff00;
	pattern_2[1][6] = 0x0000ff00;
	pattern_2[1][7] = 0x0000ff00;

	pattern_2[2][0] = 0x0010ef00;
	pattern_2[2][1] = 0x0000ff00;
	pattern_2[2][2] = 0x0000ff00;
	pattern_2[2][3] = 0x0000ff00;
	pattern_2[2][4] = 0x0020df00;
	pattern_2[2][5] = 0x0000ff00;
	pattern_2[2][6] = 0x0000ff00;
	pattern_2[2][7] = 0x0000ff00;

	pattern_2[3][0] = 0x0040bf00;
	pattern_2[3][1] = 0x0000ff00;
	pattern_2[3][2] = 0x0000ff00;
	pattern_2[3][3] = 0x0000ff00;
	pattern_2[3][4] = 0x00807f00;
	pattern_2[3][5] = 0x0000ff00;
	pattern_2[3][6] = 0x0000ff00;
	pattern_2[3][7] = 0x0000ff00;

	pattern_3[0][0] = 0x00010000;
	pattern_3[0][1] = 0x00000000;
	pattern_3[0][2] = 0x00000000;
	pattern_3[0][3] = 0x00000000;
	pattern_3[0][4] = 0x00020000;
	pattern_3[0][5] = 0x00000000;
	pattern_3[0][6] = 0x00000000;
	pattern_3[0][7] = 0x00000000;

	pattern_3[1][0] = 0x00040000;
	pattern_3[1][1] = 0x00000000;
	pattern_3[1][2] = 0x00000000;
	pattern_3[1][3] = 0x00000000;
	pattern_3[1][4] = 0x00080000;
	pattern_3[1][5] = 0x00000000;
	pattern_3[1][6] = 0x00000000;
	pattern_3[1][7] = 0x00000000;

	pattern_3[2][0] = 0x00100000;
	pattern_3[2][1] = 0x00000000;
	pattern_3[2][2] = 0x00000000;
	pattern_3[2][3] = 0x00000000;
	pattern_3[2][4] = 0x00200000;
	pattern_3[2][5] = 0x00000000;
	pattern_3[2][6] = 0x00000000;
	pattern_3[2][7] = 0x00000000;

	pattern_3[3][0] = 0x00400000;
	pattern_3[3][1] = 0x00000000;
	pattern_3[3][2] = 0x00000000;
	pattern_3[3][3] = 0x00000000;
	pattern_3[3][4] = 0x00800000;
	pattern_3[3][5] = 0x00000000;
	pattern_3[3][6] = 0x00000000;
	pattern_3[3][7] = 0x00000000;

///*
pattern_4[0][0] =	0x51c8c049	;
pattern_4[0][1] =	0x2d43592c	;
pattern_4[0][2] =	0x0777b50b	;
pattern_4[0][3] =	0x9cd2ebe5	;
pattern_4[0][4] =	0xc04199d5	;
pattern_4[0][5] =	0xdc968dc0	;
pattern_4[0][6] =	0xb8ba8a33	;
pattern_4[0][7] =	0x35e4327f	;

pattern_4[1][0] =	0xae37c049	;
pattern_4[1][1] =	0xd2bc592c	;
pattern_4[1][2] =	0xf888b50b	;
pattern_4[1][3] =	0x632debe5	;
pattern_4[1][4] =	0x3fbe99d5	;
pattern_4[1][5] =	0x23698dc0	;
pattern_4[1][6] =	0x47458a33	;
pattern_4[1][7] =	0xca1b327f	;

pattern_4[2][0] =	0x51373f49	;
pattern_4[2][1] =	0x2dbca62c	;
pattern_4[2][2] =	0x07884a0b	;
pattern_4[2][3] =	0x9c2d14e5	;
pattern_4[2][4] =	0xc0be66d5	;
pattern_4[2][5] =	0xdc6972c0	;
pattern_4[2][6] =	0xb8457533	;
pattern_4[2][7] =	0x351bcd7f	;


pattern_4[3][0] =	0x51c8c049	;
pattern_4[3][1] =	0x2d43592c	;
pattern_4[3][2] =	0x0777b50b	;
pattern_4[3][3] =	0x9cd2ebe5	;
pattern_4[3][4] =	0xc04199d5	;
pattern_4[3][5] =	0xdc968dc0	;
pattern_4[3][6] =	0xb8ba8a33	;
pattern_4[3][7] =	0x35e4327f	;

pattern_5[0][0] =	0xaec9c149	;
pattern_5[0][1] =	0xd243592c	;
pattern_5[0][2] =	0xf877b50b	;
pattern_5[0][3] =	0x63d2ebe5	;
pattern_5[0][4] =	0x3f439bd5	;
pattern_5[0][5] =	0x23968dc0	;
pattern_5[0][6] =	0x47ba8a33	;
pattern_5[0][7] =	0xcae4327f	;
pattern_5[1][0] =	0xaeccc449	;
pattern_5[1][1] =	0xd243592c	;
pattern_5[1][2] =	0xf877b50b	;
pattern_5[1][3] =	0x63d2ebe5	;
pattern_5[1][4] =	0x3f4991d5	;
pattern_5[1][5] =	0x23968dc0	;
pattern_5[1][6] =	0x47ba8a33	;
pattern_5[1][7] =	0xcae4327f	;
pattern_5[2][0] =	0xaed8d049	;
pattern_5[2][1] =	0xd243592c	;
pattern_5[2][2] =	0xf877b50b	;
pattern_5[2][3] =	0x63d2ebe5	;
pattern_5[2][4] =	0x3f61b9d5	;
pattern_5[2][5] =	0x23968dc0	;
pattern_5[2][6] =	0x47ba8a33	;
pattern_5[2][7] =	0xcae4327f	;
pattern_5[3][0] =	0xae888049	;
pattern_5[3][1] =	0xd243592c	;
pattern_5[3][2] =	0xf877b50b	;
pattern_5[3][3] =	0x63d2ebe5	;
pattern_5[3][4] =	0x3fc119d5	;
pattern_5[3][5] =	0x23968dc0	;
pattern_5[3][6] =	0x47ba8a33	;
pattern_5[3][7] =	0xcae4327f	;

pattern_6[0][0] =   0xaec93f49   ;
pattern_6[0][1] =	0xd243a62c	;
pattern_6[0][2] =	0xf8774a0b	;
pattern_6[0][3] =	0x63d214e5	;
pattern_6[0][4] =	0x3f4366d5	;
pattern_6[0][5] =	0x239672c0	;
pattern_6[0][6] =	0x47ba7533	;
pattern_6[0][7] =	0xcae4cd7f	;
pattern_6[1][0] =	0xaecc3f49	;
pattern_6[1][1] =	0xd243a62c	;
pattern_6[1][2] =	0xf8774a0b	;
pattern_6[1][3] =	0x63d214e5	;
pattern_6[1][4] =	0x3f4966d5	;
pattern_6[1][5] =	0x239672c0	;
pattern_6[1][6] =	0x47ba7533	;
pattern_6[1][7] =	0xcae4cd7f	;
pattern_6[2][0] =	0xaed83f49	;
pattern_6[2][1] =	0xd243a62c	;
pattern_6[2][2] =	0xf8774a0b	;
pattern_6[2][3] =	0x63d214e5	;
pattern_6[2][4] =	0x3f6166d5	;
pattern_6[2][5] =	0x239672c0	;
pattern_6[2][6] =	0x47ba7533	;
pattern_6[2][7] =	0xcae4cd7f	;
pattern_6[3][0] =	0xae883f49	;
pattern_6[3][1] =	0xd243a62c	;
pattern_6[3][2] =	0xf8774a0b	;
pattern_6[3][3] =	0x63d214e5	;
pattern_6[3][4] =	0x3fc166d5	;
pattern_6[3][5] =	0x239672c0	;
pattern_6[3][6] =	0x47ba7533	;
pattern_6[3][7] =	0xcae4cd7f	;
//*/
//*/
	start_addr=0x10000000;
unsigned int			test_size = 0x20;
unsigned int test_addr;
unsigned int temp_i=0;
unsigned int temp_k=0;
unsigned int pattern_o[8];
unsigned int pattern_d[8];
{
	  //  if(lflag)
	  //      loop = 888;

		//if(old_pattern_flag==1)
			{

		printf("\nStart writing at 0x%08x - 0x%08x...\n", start_addr, start_addr + test_size);

/*
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{

		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
	  flush_dcache_range(start_addr,start_addr + test_size);

	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_5[temp_k][temp_i])
	{error_count++;
							printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
*/
		//if(pattern_flag1==1)
			{
		  for ((temp_k=0);(temp_k<4);(temp_k++))
			{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_4[temp_k][temp_i])
	{error_count++;
							printf("p4Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_4[temp_k][temp_i],pattern_1[temp_k][temp_i]);
							}

		}
			}
		}
		  for ((temp_k=0);(temp_k<4);(temp_k++))
		  {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
	if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
							printf("p4 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_4[temp_k][temp_i]),pattern_d[temp_i]);
						}

		}
			}
		}
		  }
		//if(pattern_flag2==1)
			{
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_5[temp_k][temp_i])
	{error_count++;
							printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
	  for ((temp_k=0);(temp_k<4);(temp_k++))
{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
		if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
							printf("p5 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_5[temp_k][temp_i]),pattern_d[temp_i]);
						}
	  }
			}
		}

			}

	//	if(pattern_flag3==1)
			{
	for ((temp_k=0);(temp_k<4);(temp_k++)) {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,3,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_3[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
// printf("\n0x%08x",pattern_6[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_6[temp_k][temp_i])
	{error_count++;
							printf("p6Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_6[temp_k][temp_i],pattern_3[temp_k][temp_i]);
							}
	  }
			}
		}
	 for ((temp_k=0);(temp_k<4);(temp_k++))
	 {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,3,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_3[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
// printf("\n0x%08x",pattern_6[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
		if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
							printf("p6 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_6[temp_k][temp_i]),pattern_d[temp_i]);
						}
	  }
			}
		}
			}



}

		  printf("\Error count==0x%08x", error_count);
		   printf("\n      \n");
	  }







if (error_count)
	return 1;
else
	return 0;
}

int ddr_test_gx_training_pattern(int ddr_test_size)
{
 unsigned int  start_addr = 0x10000000;
	error_outof_count_flag=1;
		error_count=0;

	 unsigned int  des[8] ;
 unsigned int  pattern_1[4][8] ;
// unsigned int  pattern_2[4][8] ;
// unsigned int  pattern_3[4][8] ;
// unsigned int  pattern_4[4][8] ;
// unsigned int  pattern_5[4][8] ;
  //unsigned int  pattern_6[4][8] ;

  des[0] = 	0xaec83f49;
   des[1] =      0xd243a62c;
   des[2] =      0xf8774a0b;
  des[3] =       0x63d214e5;
   des[4] =      0x3f4166d5;
	des[5] =     0x239672c0;
   des[6] =      0x47ba7533;
   des[7] =      0xcae4cd7f;
   /*
	pattern_1[0][0] = 0x55005500;
	pattern_1[0][1] = 0xaa00aa00;
	pattern_1[0][2] = 0x55005500;
	pattern_1[0][3] = 0xaa00aa00;
	pattern_1[0][4] = 0x55005500;
	pattern_1[0][5] = 0xaa00aa00;
	pattern_1[0][6] = 0x55005500;
	pattern_1[0][7] = 0xaa00aa00;

	pattern_1[1][0] = 0x55005500;
	pattern_1[1][1] = 0xaa00aa00;
	pattern_1[1][2] = 0x55005500;
	pattern_1[1][3] = 0xaa00aa00;
	pattern_1[1][4] = 0x55005500;
	pattern_1[1][5] = 0xaa00aa00;
	pattern_1[1][6] = 0x55005500;
	pattern_1[1][7] = 0xaa00aa00;

	pattern_1[2][0] = 0x55005500;
	pattern_1[2][1] = 0xaa00aa00;
	pattern_1[2][2] = 0x55005500;
	pattern_1[2][3] = 0xaa00aa00;
	pattern_1[2][4] = 0x55005500;
	pattern_1[2][5] = 0xaa00aa00;
	pattern_1[2][6] = 0x55005500;
	pattern_1[2][7] = 0xaa00aa00;

	pattern_1[3][0] = 0x55005500;
	pattern_1[3][1] = 0xaa00aa00;
	pattern_1[3][2] = 0x55005500;
	pattern_1[3][3] = 0xaa00aa00;
	pattern_1[3][4] = 0x55005500;
	pattern_1[3][5] = 0xaa00aa00;
	pattern_1[3][6] = 0x55005500;
	pattern_1[3][7] = 0xaa00aa00;
	*/
   // /*
	 pattern_1[0][0] = 0x55aa5500;
	pattern_1[0][1] = 0x55aa5500;
	pattern_1[0][2] = 0x55aa5500;
	pattern_1[0][3] = 0x55aa5500;
	pattern_1[0][4] = 0xaa00ff00;
	pattern_1[0][5] = 0xaa00ff00;
	pattern_1[0][6] = 0xaa00ff00;
	pattern_1[0][7] = 0xaa00ff00;

	pattern_1[1][0] = 0x55005500;
	pattern_1[1][1] = 0xaa00aa00;
	pattern_1[1][2] = 0x55005500;
	pattern_1[1][3] = 0xaa00aa00;
	pattern_1[1][4] = 0x55005500;
	pattern_1[1][5] = 0xaa00aa00;
	pattern_1[1][6] = 0x55005500;
	pattern_1[1][7] = 0xaa00aa00;

	pattern_1[2][0] = 0x0001fe00;
	pattern_1[2][1] = 0x0000ff00;
	pattern_1[2][2] = 0x0000ff00;
	pattern_1[2][3] = 0x0000ff00;
	pattern_1[2][4] = 0x0002fd00;
	pattern_1[2][5] = 0x0000ff00;
	pattern_1[2][6] = 0x0000ff00;
	pattern_1[2][7] = 0x0000ff00;

	pattern_1[3][0] = 0x0004fb00;
	pattern_1[3][1] = 0x0000ff00;
	pattern_1[3][2] = 0x0000ff00;
	pattern_1[3][3] = 0x0000ff00;
	pattern_1[3][4] = 0x0008f700;
	pattern_1[3][5] = 0x0000ff00;
	pattern_1[3][6] = 0x0000ff00;
	pattern_1[3][7] = 0x0000ff00;
//*/
	/*
	pattern_2[0][0] = 0x0001fe00;
	pattern_2[0][1] = 0x0000ff00;
	pattern_2[0][2] = 0x0000ff00;
	pattern_2[0][3] = 0x0000ff00;
	pattern_2[0][4] = 0x0002fd00;
	pattern_2[0][5] = 0x0000ff00;
	pattern_2[0][6] = 0x0000ff00;
	pattern_2[0][7] = 0x0000ff00;

	pattern_2[1][0] = 0x0004fb00;
	pattern_2[1][1] = 0x0000ff00;
	pattern_2[1][2] = 0x0000ff00;
	pattern_2[1][3] = 0x0000ff00;
	pattern_2[1][4] = 0x0008f700;
	pattern_2[1][5] = 0x0000ff00;
	pattern_2[1][6] = 0x0000ff00;
	pattern_2[1][7] = 0x0000ff00;

	pattern_2[2][0] = 0x0010ef00;
	pattern_2[2][1] = 0x0000ff00;
	pattern_2[2][2] = 0x0000ff00;
	pattern_2[2][3] = 0x0000ff00;
	pattern_2[2][4] = 0x0020df00;
	pattern_2[2][5] = 0x0000ff00;
	pattern_2[2][6] = 0x0000ff00;
	pattern_2[2][7] = 0x0000ff00;

	pattern_2[3][0] = 0x0040bf00;
	pattern_2[3][1] = 0x0000ff00;
	pattern_2[3][2] = 0x0000ff00;
	pattern_2[3][3] = 0x0000ff00;
	pattern_2[3][4] = 0x00807f00;
	pattern_2[3][5] = 0x0000ff00;
	pattern_2[3][6] = 0x0000ff00;
	pattern_2[3][7] = 0x0000ff00;

	pattern_3[0][0] = 0x00010000;
	pattern_3[0][1] = 0x00000000;
	pattern_3[0][2] = 0x00000000;
	pattern_3[0][3] = 0x00000000;
	pattern_3[0][4] = 0x00020000;
	pattern_3[0][5] = 0x00000000;
	pattern_3[0][6] = 0x00000000;
	pattern_3[0][7] = 0x00000000;

	pattern_3[1][0] = 0x00040000;
	pattern_3[1][1] = 0x00000000;
	pattern_3[1][2] = 0x00000000;
	pattern_3[1][3] = 0x00000000;
	pattern_3[1][4] = 0x00080000;
	pattern_3[1][5] = 0x00000000;
	pattern_3[1][6] = 0x00000000;
	pattern_3[1][7] = 0x00000000;

	pattern_3[2][0] = 0x00100000;
	pattern_3[2][1] = 0x00000000;
	pattern_3[2][2] = 0x00000000;
	pattern_3[2][3] = 0x00000000;
	pattern_3[2][4] = 0x00200000;
	pattern_3[2][5] = 0x00000000;
	pattern_3[2][6] = 0x00000000;
	pattern_3[2][7] = 0x00000000;

	pattern_3[3][0] = 0x00400000;
	pattern_3[3][1] = 0x00000000;
	pattern_3[3][2] = 0x00000000;
	pattern_3[3][3] = 0x00000000;
	pattern_3[3][4] = 0x00800000;
	pattern_3[3][5] = 0x00000000;
	pattern_3[3][6] = 0x00000000;
	pattern_3[3][7] = 0x00000000;


pattern_4[0][0] =	0x51c8c049	;
pattern_4[0][1] =	0x2d43592c	;
pattern_4[0][2] =	0x0777b50b	;
pattern_4[0][3] =	0x9cd2ebe5	;
pattern_4[0][4] =	0xc04199d5	;
pattern_4[0][5] =	0xdc968dc0	;
pattern_4[0][6] =	0xb8ba8a33	;
pattern_4[0][7] =	0x35e4327f	;

pattern_4[1][0] =	0xae37c049	;
pattern_4[1][1] =	0xd2bc592c	;
pattern_4[1][2] =	0xf888b50b	;
pattern_4[1][3] =	0x632debe5	;
pattern_4[1][4] =	0x3fbe99d5	;
pattern_4[1][5] =	0x23698dc0	;
pattern_4[1][6] =	0x47458a33	;
pattern_4[1][7] =	0xca1b327f	;

pattern_4[2][0] =	0x51373f49	;
pattern_4[2][1] =	0x2dbca62c	;
pattern_4[2][2] =	0x07884a0b	;
pattern_4[2][3] =	0x9c2d14e5	;
pattern_4[2][4] =	0xc0be66d5	;
pattern_4[2][5] =	0xdc6972c0	;
pattern_4[2][6] =	0xb8457533	;
pattern_4[2][7] =	0x351bcd7f	;


pattern_4[3][0] =	0x51c8c049	;
pattern_4[3][1] =	0x2d43592c	;
pattern_4[3][2] =	0x0777b50b	;
pattern_4[3][3] =	0x9cd2ebe5	;
pattern_4[3][4] =	0xc04199d5	;
pattern_4[3][5] =	0xdc968dc0	;
pattern_4[3][6] =	0xb8ba8a33	;
pattern_4[3][7] =	0x35e4327f	;

pattern_5[0][0] =	0xaec9c149	;
pattern_5[0][1] =	0xd243592c	;
pattern_5[0][2] =	0xf877b50b	;
pattern_5[0][3] =	0x63d2ebe5	;
pattern_5[0][4] =	0x3f439bd5	;
pattern_5[0][5] =	0x23968dc0	;
pattern_5[0][6] =	0x47ba8a33	;
pattern_5[0][7] =	0xcae4327f	;
pattern_5[1][0] =	0xaeccc449	;
pattern_5[1][1] =	0xd243592c	;
pattern_5[1][2] =	0xf877b50b	;
pattern_5[1][3] =	0x63d2ebe5	;
pattern_5[1][4] =	0x3f4991d5	;
pattern_5[1][5] =	0x23968dc0	;
pattern_5[1][6] =	0x47ba8a33	;
pattern_5[1][7] =	0xcae4327f	;
pattern_5[2][0] =	0xaed8d049	;
pattern_5[2][1] =	0xd243592c	;
pattern_5[2][2] =	0xf877b50b	;
pattern_5[2][3] =	0x63d2ebe5	;
pattern_5[2][4] =	0x3f61b9d5	;
pattern_5[2][5] =	0x23968dc0	;
pattern_5[2][6] =	0x47ba8a33	;
pattern_5[2][7] =	0xcae4327f	;
pattern_5[3][0] =	0xae888049	;
pattern_5[3][1] =	0xd243592c	;
pattern_5[3][2] =	0xf877b50b	;
pattern_5[3][3] =	0x63d2ebe5	;
pattern_5[3][4] =	0x3fc119d5	;
pattern_5[3][5] =	0x23968dc0	;
pattern_5[3][6] =	0x47ba8a33	;
pattern_5[3][7] =	0xcae4327f	;

pattern_6[0][0] =   0xaec93f49   ;
pattern_6[0][1] =	0xd243a62c	;
pattern_6[0][2] =	0xf8774a0b	;
pattern_6[0][3] =	0x63d214e5	;
pattern_6[0][4] =	0x3f4366d5	;
pattern_6[0][5] =	0x239672c0	;
pattern_6[0][6] =	0x47ba7533	;
pattern_6[0][7] =	0xcae4cd7f	;
pattern_6[1][0] =	0xaecc3f49	;
pattern_6[1][1] =	0xd243a62c	;
pattern_6[1][2] =	0xf8774a0b	;
pattern_6[1][3] =	0x63d214e5	;
pattern_6[1][4] =	0x3f4966d5	;
pattern_6[1][5] =	0x239672c0	;
pattern_6[1][6] =	0x47ba7533	;
pattern_6[1][7] =	0xcae4cd7f	;
pattern_6[2][0] =	0xaed83f49	;
pattern_6[2][1] =	0xd243a62c	;
pattern_6[2][2] =	0xf8774a0b	;
pattern_6[2][3] =	0x63d214e5	;
pattern_6[2][4] =	0x3f6166d5	;
pattern_6[2][5] =	0x239672c0	;
pattern_6[2][6] =	0x47ba7533	;
pattern_6[2][7] =	0xcae4cd7f	;
pattern_6[3][0] =	0xae883f49	;
pattern_6[3][1] =	0xd243a62c	;
pattern_6[3][2] =	0xf8774a0b	;
pattern_6[3][3] =	0x63d214e5	;
pattern_6[3][4] =	0x3fc166d5	;
pattern_6[3][5] =	0x239672c0	;
pattern_6[3][6] =	0x47ba7533	;
pattern_6[3][7] =	0xcae4cd7f	;
*/
//*/
//*/
	start_addr=0x10000000;
unsigned int			test_size = 0x20;
unsigned int test_addr;
unsigned int temp_i=0;
unsigned int temp_k=0;
unsigned int pattern_o[8];
unsigned int pattern_d[8];
{
	  //  if(lflag)
	  //      loop = 888;

		//if(old_pattern_flag==1)
			{

		printf("\nStart writing at 0x%08x - 0x%08x...\n", start_addr, start_addr + test_size);

/*
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{

		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
	  flush_dcache_range(start_addr,start_addr + test_size);

	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_5[temp_k][temp_i])
	{error_count++;
							printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
*/
		//if(pattern_flag1==1)
			{
		  for ((temp_k=0);(temp_k<4);(temp_k++))
			{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	if ((pattern_o[temp_i]) != (des_pattern(temp_i,1,temp_k,temp_i)))
	{error_count++;
			//                printf("p4Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_4[temp_k][temp_i],pattern_1[temp_k][temp_i]);
					  printf("p4Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), des_pattern(temp_i,1,temp_k,temp_i),pattern_1[temp_k][temp_i]);
							}


		}
			}
		}

		  for ((temp_k=0);(temp_k<4);(temp_k++))
		  {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
	if ((des_xor_pattern((des[temp_i]),des_inv_pattern(temp_i,1,temp_k,temp_i))) != pattern_d[temp_i])
	{error_count++;
							printf("p4 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",
								pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_1[temp_k][temp_i]),pattern_d[temp_i]);
						}

		}
			}
		}

		  }
		//if(pattern_flag2==1)


	//	if(pattern_flag3==1)




}

		  printf("\Error count==0x%08x", error_count);
		   printf("\n      \n");
	  }







if (error_count)
	return 1;
else
	return 0;
}


#endif

static void ddr_write_pattern4_cross_talk_p(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
 //    unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;
//#define ddr_pattern_loop 32
	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
                switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
		      case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //   case 30:
						*(p+i) = TDATA32F;
						break;
					case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
		      case 20:
					case 21:
					case 22:
					case 23:
		      case 28:
					case 29:
					case 30:
					case 31:
				 //   case 22:
						*(p+i) = 0;
						break;
		      case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
		      case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //   case 30:
						  *(p+i) = TDATA32A;
						break;
					case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
		      case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
		      case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
				*(p+i) = TDATA325;


						break;
			   case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
				*(p+i) =0xfe01fe01;
				  break;
			   case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
				*(p+i) =0xfd02fd02;
				  break;
			   case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
				*(p+i) =0xfb04fb04;
				  break;
			   case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
				*(p+i) =0xf708f708;
				  break;
			   case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
				*(p+i) =0xef10ef10;
				  break;
			   case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
				*(p+i) =0xdf20df20;
				  break;
			   case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
				*(p+i) =0xbf40bf40;
				  break;
			   case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
				*(p+i) =0x7f807f80;
				  break;
			   case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
				*(p+i) =0x00000100;
				  break;
			   case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
				*(p+i) =0x00000200;
				  break;
			   case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
				*(p+i) =0x00000400;
				  break;
			   case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
				*(p+i) =0x00000800;
				  break;
			   case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
				*(p+i) =0x00001000;
				  break;
			   case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
				*(p+i) =0x00002000;
				  break;
			   case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
				*(p+i) =0x00004000;
				  break;
			   case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
				*(p+i) =0x00008000;
				  break;


				}
			}

            if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}

static void ddr_write_pattern4_cross_talk_p2(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
 //    unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;
//#define ddr_pattern_loop 32
	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
	#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif

                switch (i)
				{

					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
							*(p+i) = 0xfe01fe01;
							break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
						   *(p+i) = 0xfd02fd02;
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
						   *(p+i) = 0xfb04fb04;
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
						   *(p+i) = 0xf708f708;
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
						   *(p+i) = 0xef10ef10;
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
						   *(p+i) = 0xdf20df20;
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
						   *(p+i) = 0xbf40bf40;
			 break;

					   case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
						   *(p+i) = 0x7f807f80;
						break;


			   default:

						  *(p+i) = 0xff00ff00;
						break;

						break;


				}
			}

            if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}
static void ddr_read_pattern4_cross_talk_p(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
  //   unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
            if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				 break;
				}

                switch (i)
				{

					 case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
		      case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //   case 30:
				  //      *(p+i) = TDATA32F;
                        if (*(p+i) != TDATA32F)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32F);
							                        break;
							}
						 break;
					 case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
		      case 20:
					case 21:
					case 22:
					case 23:
		      case 28:
					case 29:
					case 30:
					case 31:
				 //   case 22:
					 //   *(p+i) = 0;
                        if (*(p+i) != 0)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0);
						break;}
						 break;
					case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
		      case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //   case 30:
				  //        *(p+i) = TDATA32A;
                        if (*(p+i) != TDATA32A)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA32A);
						break;
							}
						 break;
					   case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
		      case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
		      case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
			//	*(p+i) = TDATA325;
                        if (*(p+i) != TDATA325)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), TDATA325);
						break;
							}
						 break;
					 case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
			//   	*(p+i) =0xfe01fe01;
                        if (*(p+i) !=0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xfe01fe01);
						break;
							}
						 break;
					case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
			  // 	*(p+i) =0xfd02fd02;
                        if (*(p+i) != 0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xfd02fd02);
						break;
							}
						 break;
			   case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
			   //	*(p+i) =0xfb04fb04;
			     if (*(p+i) != 0xfb04fb04)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xfb04fb04);
				  break;
					}
				  break;
			   case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
			   //	*(p+i) =0xf7b08f708;
				  if (*(p+i) != 0xf708f708)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xf708f708);
				  break;
					}
				   break;
			   case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
			   //	*(p+i) =0xef10ef10;
				  if (*(p+i) != 0xef10ef10)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xef10ef10);
				  break;
					}
				   break;
			   case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
			   //	*(p+i) =0xdf20df20;
				  if (*(p+i) != 0xdf20df20)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xdf20df20);
				  break;
					}
				   break;
			   case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
			 //  	*(p+i) =0xbf40bf40;
				  if (*(p+i) != 0xbf40bf40)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xbf40bf40);
				  break;
					}
				   break;
			   case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
			//   	*(p+i) =0x7f807f80;
				  if (*(p+i) != 0x7f807f80)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x7f807f80);
				  break;

					}
				   break;
			   case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
			   //	*(p+i) =0x00000100;
					  if (*(p+i) != 0x00000100)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00000100);
				  break;
						}
					   break;
			   case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
			 //  	*(p+i) =0x00000100;
				  if (*(p+i) != 0x00000200)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00000200);
				  break;
					}
				   break;
			   case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
			   //	*(p+i) =0x00000100;
				 if (*(p+i) != 0x00000400)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00000400);
				  break;
					}
				  break;
			   case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
			   //	*(p+i) =0x00000100;
				 if (*(p+i) != 0x00000800)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00000800);
				  break;
					}
				  break;
			   case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
			   //	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00001000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00001000);
				  break;
					}
				  break;
			   case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
			  // 	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00002000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00002000);

					} break;
			   case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
			   //	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00004000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00004000);
				  break;
					}
				  break;
			   case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
			   //	*(p+i) =0xfffffeff;
				 if (*(p+i) != 0x00008000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00008000);
				  break;
					}
				  break;



				}
			}

            if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}
//*/
static void ddr_read_pattern4_cross_talk_p2(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
  //   unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
            if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				 break;
				}

                switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
							//   *(p+i) = 0xfe01fe01;
							   if (*(p+i) != 0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xfe01fe01);
							                        break;
							}
							break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
					//	   *(p+i) = 0xfd02fd02;
						      if (*(p+i) != 0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xfd02fd02);
							                        break;
							}
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
						//   *(p+i) = 0xfb04fb04;
						      if (*(p+i) != 0xfb04fb04)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xfb04fb04);
							                        break;
							}
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
					//	   *(p+i) = 0xf708f708;
						      if (*(p+i) != 0xf708f708)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xf708f708);
							                        break;
							}
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
					//	   *(p+i) = 0xef10ef10;
						      if (*(p+i) != 0xef10ef10)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xef10ef10);
							                        break;
							}
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
						//   *(p+i) = 0xdf20df20;
						      if (*(p+i) != 0xdf20df20)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xdf20df20);
							                        break;
							}
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
					//	   *(p+i) = 0xbf40bf40;
						      if (*(p+i) != 0xbf40bf40)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xbf40bf40);
							                        break;
							}
											break;
					   case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
					//	   *(p+i) = 0x7f807f80;
						      if (*(p+i) != 0x7f807f80)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x7f807f80);
							                        break;
							}
						break;


			   default:

						//  *(p+i) = 0xff00ff00;
						     if (*(p+i) != 0xff00ff00)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ff00);
							                        break;
							}
						break;

						break;


				}
			}

            if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}

static void ddr_write_pattern4_cross_talk_n(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
 //    unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;
//#define ddr_pattern_loop 32
	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
                switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
		      case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //   case 30:
						*(p+i) = ~TDATA32F;
						break;
					case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
		      case 20:
					case 21:
					case 22:
					case 23:
		      case 28:
					case 29:
					case 30:
					case 31:
				 //   case 22:
						*(p+i) = ~0;
						break;
		      case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
		      case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //   case 30:
						  *(p+i) = ~TDATA32A;
						break;
					case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
		      case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
		      case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
				*(p+i) =~TDATA325;


						break;
			   case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
				*(p+i) =~0xfe01fe01;
				  break;
			   case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
				*(p+i) =~0xfd02fd02;
				  break;
			   case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
				*(p+i) =~0xfb04fb04;
				  break;
			   case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
				*(p+i) =~0xf708f708;
				  break;
			   case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
				*(p+i) =~0xef10ef10;
				  break;
			   case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
				*(p+i) =~0xdf20df20;
				  break;
			   case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
				*(p+i) =~0xbf40bf40;
				  break;
			   case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
				*(p+i) =~0x7f807f80;
				  break;
			   case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
				*(p+i) =~0x00000100;
				  break;
			   case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
				*(p+i) =~0x00000200;
				  break;
			   case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
				*(p+i) =~0x00000400;
				  break;
			   case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
				*(p+i) =~0x00000800;
				  break;
			   case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
				*(p+i) =~0x00001000;
				  break;
			   case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
				*(p+i) =~0x00002000;
				  break;
			   case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
				*(p+i) =~0x00004000;
				  break;
			   case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
				*(p+i) =~0x00008000;
				  break;


				}
			}

            if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}


static void ddr_write_pattern4_cross_talk_n2(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
 //    unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;
//#define ddr_pattern_loop 32
	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
	#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif

                switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
							*(p+i) = ~0xfe01fe01;
							break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
						   *(p+i) = ~0xfd02fd02;
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
						   *(p+i) = ~0xfb04fb04;
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
						   *(p+i) = ~0xf708f708;
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
						   *(p+i) = ~0xef10ef10;
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
						   *(p+i) = ~0xdf20df20;
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
						   *(p+i) =~0xbf40bf40;
							break;
					   case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
						   *(p+i) = ~0x7f807f80;
						break;


			   default:

						  *(p+i) = ~0xff00ff00;
						break;

						break;


				}
			}

            if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}

static void ddr_read_pattern4_cross_talk_n(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
  //   unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
               if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				  break;
				}
                switch (i)
				{
					 case 0:
					case 1:
					case 2:
					case 3:
					case 8:
					case 9:
					case 10:
					case 11:
		      case 16:
					case 17:
					case 18:
					case 19:
					case 24:
					case 25:
					case 26:
					case 27:
				 //   case 30:
				  //      *(p+i) = TDATA32F;
                        if (*(p+i) !=~TDATA32F)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~TDATA32F);
						break;
							}
						 break;
					 case 4:
					case 5:
					case 6:
					case 7:
					case 12:
					case 13:
					case 14:
					case 15:
		      case 20:
					case 21:
					case 22:
					case 23:
		      case 28:
					case 29:
					case 30:
					case 31:
				 //   case 22:
					 //   *(p+i) = 0;
                        if (*(p+i) !=~0)
				   {error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0);
							}
						break;
					case DDR_PATTERN_LOOP_1+0:
					case DDR_PATTERN_LOOP_1+1:
					case DDR_PATTERN_LOOP_1+2:
					case DDR_PATTERN_LOOP_1+3:
					case DDR_PATTERN_LOOP_1+8:
					case DDR_PATTERN_LOOP_1+9:
					case DDR_PATTERN_LOOP_1+10:
					case DDR_PATTERN_LOOP_1+11:
		      case DDR_PATTERN_LOOP_1+16:
					case DDR_PATTERN_LOOP_1+17:
					case DDR_PATTERN_LOOP_1+18:
					case DDR_PATTERN_LOOP_1+19:
					case DDR_PATTERN_LOOP_1+24:
					case DDR_PATTERN_LOOP_1+25:
					case DDR_PATTERN_LOOP_1+26:
					case DDR_PATTERN_LOOP_1+27:
				 //   case 30:
				  //        *(p+i) = TDATA32A;
                        if (*(p+i) != ~TDATA32A)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i),~TDATA32A);
							}
						break;
					   case DDR_PATTERN_LOOP_1+4:
					case DDR_PATTERN_LOOP_1+5:
					case DDR_PATTERN_LOOP_1+6:
					case DDR_PATTERN_LOOP_1+7:
					case DDR_PATTERN_LOOP_1+12:
					case DDR_PATTERN_LOOP_1+13:
					case DDR_PATTERN_LOOP_1+14:
					case DDR_PATTERN_LOOP_1+15:
		      case DDR_PATTERN_LOOP_1+20:
					case DDR_PATTERN_LOOP_1+21:
					case DDR_PATTERN_LOOP_1+22:
					case DDR_PATTERN_LOOP_1+23:
		      case DDR_PATTERN_LOOP_1+28:
					case DDR_PATTERN_LOOP_1+29:
					case DDR_PATTERN_LOOP_1+30:
					case DDR_PATTERN_LOOP_1+31:
			//	*(p+i) = TDATA325;
                        if (*(p+i) != ~TDATA325)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~TDATA325);
							}
						break;
					 case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
			//   	*(p+i) =0xfe01fe01;
                        if (*(p+i) !=~0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xfe01fe01);
							}
						break;
					case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
			  // 	*(p+i) =0xfd02fd02;
                        if (*(p+i) != ~0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xfd02fd02);
							}
						break;

			   case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
			   //	*(p+i) =0xfb04fb04;
			     if (*(p+i) != ~0xfb04fb04)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xfb04fb04);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
			   //	*(p+i) =0xf7b08f708;
				  if (*(p+i) != ~0xf708f708)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xf708f708);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
			   //	*(p+i) =0xef10ef10;
				  if (*(p+i) != ~0xef10ef10)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xef10ef10);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
			   //	*(p+i) =0xdf20df20;
				  if (*(p+i) != ~0xdf20df20)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xdf20df20);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
			 //  	*(p+i) =0xbf40bf40;
				  if (*(p+i) != ~0xbf40bf40)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xbf40bf40);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
			//   	*(p+i) =0x7f807f80;
				  if (*(p+i) != ~0x7f807f80)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x7f807f80);
					}
				  break;
				  break;
			   case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
			   //	*(p+i) =0x00000100;
					  if (*(p+i) != ~0x00000100)
						{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00000100);
						}
				  break;
			   case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
			 //  	*(p+i) =0x00000100;
				  if (*(p+i) != ~0x00000200)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00000200);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
			   //	*(p+i) =0x00000100;
				 if (*(p+i) != ~0x00000400)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00000400);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
			   //	*(p+i) =0x00000100;
				 if (*(p+i) != ~0x00000800)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00000800);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
			   //	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00001000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00001000);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
			  // 	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00002000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00002000);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
			   //	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00004000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00004000);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
			   //	*(p+i) =0xfffffeff;
				 if (*(p+i) != ~0x00008000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00008000);
					}
				  break;



				}
			}

            if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}


//*/
static void ddr_read_pattern4_cross_talk_n2(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
  //   unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
            if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				 break;
				}

                switch (i)
				{
					 case 0:
			case DDR_PATTERN_LOOP_1+1:
			case DDR_PATTERN_LOOP_2+2:
			case DDR_PATTERN_LOOP_3+3:
							//   *(p+i) = 0xfe01fe01;
							   if (*(p+i) != ~0xfe01fe01)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xfe01fe01);
							                        break;
							}
							break;
					 case 4:
			case DDR_PATTERN_LOOP_1+5:
			case DDR_PATTERN_LOOP_2+6:
			case DDR_PATTERN_LOOP_3+7:
					//	   *(p+i) = 0xfd02fd02;
						      if (*(p+i) != ~0xfd02fd02)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xfd02fd02);
							                        break;
							}
									 break;

					 case 8:
			case DDR_PATTERN_LOOP_1+9:
			case DDR_PATTERN_LOOP_2+10:
			case DDR_PATTERN_LOOP_3+11:
						//   *(p+i) = 0xfb04fb04;
						      if (*(p+i) != ~0xfb04fb04)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xfb04fb04);
							                        break;
							}
						break;

					 case 12:
			case DDR_PATTERN_LOOP_1+13:
			case DDR_PATTERN_LOOP_2+14:
			case DDR_PATTERN_LOOP_3+15:
					//	   *(p+i) = 0xf708f708;
						      if (*(p+i) != ~0xf708f708)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xf708f708);
							                        break;
							}
						break;

					 case 16:
			case DDR_PATTERN_LOOP_1+17:
			case DDR_PATTERN_LOOP_2+18:
			case DDR_PATTERN_LOOP_3+19:
					//	   *(p+i) = 0xef10ef10;
						      if (*(p+i) != ~0xef10ef10)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xef10ef10);
							                        break;
							}
						break;

					 case 20:
			case DDR_PATTERN_LOOP_1+21:
			case DDR_PATTERN_LOOP_2+22:
			case DDR_PATTERN_LOOP_3+23:
						//   *(p+i) = 0xdf20df20;
						      if (*(p+i) != ~0xdf20df20)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xdf20df20);
							                        break;
							}
						break;

					 case 24:
			case DDR_PATTERN_LOOP_1+25:
			case DDR_PATTERN_LOOP_2+26:
			case DDR_PATTERN_LOOP_3+27:
					//	   *(p+i) = 0xbf40bf40;
						      if (*(p+i) != ~0xbf40bf40)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xbf40bf40);
							                        break;
							}
							break;
					   case 28:
			case DDR_PATTERN_LOOP_1+29:
			case DDR_PATTERN_LOOP_2+30:
			case DDR_PATTERN_LOOP_3+31:
					//	   *(p+i) = 0x7f807f80;
						      if (*(p+i) != ~0x7f807f80)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x7f807f80);
							                        break;
							}
						break;


			   default:

						//  *(p+i) = 0xff00ff00;
						     if (*(p+i) != ~0xff00ff00)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ff00);
							                        break;
							}
						break;

						break;


				}
			}

            if (m_len > 128*4)
			{
				m_len -= 128*4;
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}

static void ddr_write_pattern4_no_cross_talk(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
 //    unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;
//#define ddr_pattern_loop 32
	p = ( unsigned int  *)buff;

    while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
                switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
				 *(p+i) = 0xff00ff00;
				     break;
		      case 4:
					case 5:
					case 6:
					case 7:
				 *(p+i) = 0xffff0000;
				     break;

					case 8:
					case 9:
					case 10:
					case 11:
				 *(p+i) = 0xff000000;
				     break;
		      case 12:
					case 13:
					case 14:
					case 15:
				 *(p+i) = 0xff00ffff;
				     break;

		      case 16:
					case 17:
					case 18:
					case 19:
				 *(p+i) = 0xff00ffff;
				     break;
		      case 20:
					case 21:
					case 22:
					case 23:
				  *(p+i) = 0xff0000ff;
						   break;
					case 24:
					case 25:
					case 26:
					case 27:
				  *(p+i) = 0xffff0000;
					   break;

		      case 28:
					case 29:
					case 30:
					case 31:
								 *(p+i) = 0x00ff00ff;
						   break;
			   case DDR_PATTERN_LOOP_1+0:
		 case DDR_PATTERN_LOOP_1+1:
		 case DDR_PATTERN_LOOP_1+2:
		 case DDR_PATTERN_LOOP_1+3:
				*(p+i) =~0xff00ff00;
				  break;
			   case DDR_PATTERN_LOOP_1+4:
		 case DDR_PATTERN_LOOP_1+5:
		 case DDR_PATTERN_LOOP_1+6:
		 case DDR_PATTERN_LOOP_1+7:
				*(p+i) =~0xffff0000;
				  break;
			   case DDR_PATTERN_LOOP_1+8:
		 case DDR_PATTERN_LOOP_1+9:
		 case DDR_PATTERN_LOOP_1+10:
		 case DDR_PATTERN_LOOP_1+11:
				*(p+i) =~0xff000000;
				  break;
			   case DDR_PATTERN_LOOP_1+12:
		 case DDR_PATTERN_LOOP_1+13:
		 case DDR_PATTERN_LOOP_1+14:
		 case DDR_PATTERN_LOOP_1+15:
				*(p+i) =~0xff00ffff;
				  break;
			   case DDR_PATTERN_LOOP_1+16:
		 case DDR_PATTERN_LOOP_1+17:
		 case DDR_PATTERN_LOOP_1+18:
		 case DDR_PATTERN_LOOP_1+19:
				*(p+i) =~0xff00ffff;
				  break;
			   case DDR_PATTERN_LOOP_1+20:
		 case DDR_PATTERN_LOOP_1+21:
		 case DDR_PATTERN_LOOP_1+22:
		 case DDR_PATTERN_LOOP_1+23:
				*(p+i) =~0xff00ffff;
				  break;
			   case DDR_PATTERN_LOOP_1+24:
		 case DDR_PATTERN_LOOP_1+25:
		 case DDR_PATTERN_LOOP_1+26:
		 case DDR_PATTERN_LOOP_1+27:
				*(p+i) =~0xffff0000;
				  break;
			   case DDR_PATTERN_LOOP_1+28:
		 case DDR_PATTERN_LOOP_1+29:
		 case DDR_PATTERN_LOOP_1+30:
		 case DDR_PATTERN_LOOP_1+31:
				*(p+i) =~0x00ff00ff;
				  break;

			   case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
				*(p+i) =0x00ff0000;
				  break;
			   case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
				*(p+i) =0xff000000;
				  break;
			   case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
				*(p+i) =0x0000ffff;
				  break;
			   case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
				*(p+i) =0x000000ff;
				  break;
			   case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
				*(p+i) =0x00ff00ff;
				  break;
			   case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
				*(p+i) =0xff00ff00;
				  break;
			   case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
				*(p+i) =0xff00ffff;
				  break;
			   case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
				*(p+i) =0xff00ff00;
				  break;
			   case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
				*(p+i) =~0x00ff0000;
				  break;
			   case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
				*(p+i) =~0xff000000;
				  break;
			   case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
				*(p+i) =~0x0000ffff;
				  break;
			   case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
				*(p+i) =~0x000000ff;
				  break;
			   case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
				*(p+i) =~0x00ff00ff;
				  break;
			   case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
				*(p+i) =~0xff00ff00;
				  break;
			   case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
				*(p+i) =~0xff00ffff;
				  break;
			   case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
				*(p+i) =~0xff00ff00;
				  break;


				}
			}

            if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}

static void ddr_read_pattern4_no_cross_talk(void *buff,  unsigned int  m_length)
{
	 unsigned int  *p;
  //   unsigned int  i, j, n;
	  unsigned int  i, n;
	 unsigned int  m_len = m_length;

	p = ( unsigned int  *)buff;
  while (m_len)
	{
	  //  for(j=0;j<32;j++)
		{
            if (m_len >= 128*4)
				n = 32*4;
			else
				n = m_len>>2;

            for (i = 0; i < n; i++)
			{
				#ifdef DDR_PREFETCH_CACHE
		   ddr_pld_cache(p)  ;
		#endif
               if ((error_outof_count_flag) && (error_count))
				{
				printf("Error data out of count");
				 m_len=0;
				  break;
				}
                switch (i)
				{
					case 0:
					case 1:
					case 2:
					case 3:
					//	  if(*(p+i) !=~TDATA32F)

				if ( *(p+i) != 0xff00ff00)
					{error_count++;
					printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ff00);
					}
									break;
		      case 4:
					case 5:
					case 6:
					case 7:
						if ( *(p+i) != 0xffff0000)
							{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xffff0000);
							}
				     break;

					case 8:
					case 9:
					case 10:
					case 11:
				// *(p+i) = 0xff000000;
				 if ( *(p+i) != 0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff000000);
					}
				     break;
		      case 12:
					case 13:
					case 14:
					case 15:
				// *(p+i) = 0xff00ffff;
				 if ( *(p+i) != 0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ffff);
					}
				     break;

		      case 16:
					case 17:
					case 18:
					case 19:
			//	 *(p+i) = 0xff00ffff;
				 if ( *(p+i) != 0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ffff);
					}
				     break;
		      case 20:
					case 21:
					case 22:
					case 23:
				//  *(p+i) = 0xff0000ff;
				  if ( *(p+i) != 0xff0000ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff0000ff);
					}
						   break;
					case 24:
					case 25:
					case 26:
					case 27:
				//  *(p+i) = 0xffff0000;
				  if ( *(p+i) != 0xffff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xffff0000);
					}
					   break;

		      case 28:
					case 29:
					case 30:
					case 31:
							   //  *(p+i) = 0x00ff00ff;
								 if ( *(p+i) != 0x00ff00ff)
									{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00ff00ff);
									}
						   break;
			   case DDR_PATTERN_LOOP_1+0:
		 case DDR_PATTERN_LOOP_1+1:
		 case DDR_PATTERN_LOOP_1+2:
		 case DDR_PATTERN_LOOP_1+3:
			 //  	*(p+i) =~0xff00ff00;
				if ( *(p+i) != ~0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ff00);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+4:
		 case DDR_PATTERN_LOOP_1+5:
		 case DDR_PATTERN_LOOP_1+6:
		 case DDR_PATTERN_LOOP_1+7:
			  // 	*(p+i) =~0xffff0000;
				if ( *(p+i) != ~0xffff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xffff0000);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+8:
		 case DDR_PATTERN_LOOP_1+9:
		 case DDR_PATTERN_LOOP_1+10:
		 case DDR_PATTERN_LOOP_1+11:
			  // 	*(p+i) =~0xff000000;
				if ( *(p+i) != ~0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff000000);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+12:
		 case DDR_PATTERN_LOOP_1+13:
		 case DDR_PATTERN_LOOP_1+14:
		 case DDR_PATTERN_LOOP_1+15:
			   //	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+16:
		 case DDR_PATTERN_LOOP_1+17:
		 case DDR_PATTERN_LOOP_1+18:
		 case DDR_PATTERN_LOOP_1+19:
			   //	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+20:
		 case DDR_PATTERN_LOOP_1+21:
		 case DDR_PATTERN_LOOP_1+22:
		 case DDR_PATTERN_LOOP_1+23:
			   //	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+24:
		 case DDR_PATTERN_LOOP_1+25:
		 case DDR_PATTERN_LOOP_1+26:
		 case DDR_PATTERN_LOOP_1+27:
			   //	*(p+i) =~0xffff0000;
				if ( *(p+i) != ~0xffff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xffff0000);
					}
				  break;
			   case DDR_PATTERN_LOOP_1+28:
		 case DDR_PATTERN_LOOP_1+29:
		 case DDR_PATTERN_LOOP_1+30:
		 case DDR_PATTERN_LOOP_1+31:
			 //  	*(p+i) =~0x00ff00ff;
				if ( *(p+i) != ~0x00ff00ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00ff00ff);
					}
				  break;

			   case DDR_PATTERN_LOOP_2+0:
		 case DDR_PATTERN_LOOP_2+1:
		 case DDR_PATTERN_LOOP_2+2:
		 case DDR_PATTERN_LOOP_2+3:
			 //  	*(p+i) =0x00ff0000;
				if ( *(p+i) != 0x00ff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00ff0000);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+4:
		 case DDR_PATTERN_LOOP_2+5:
		 case DDR_PATTERN_LOOP_2+6:
		 case DDR_PATTERN_LOOP_2+7:
			//   	*(p+i) =0xff000000;
				if ( *(p+i) != 0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff000000);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+8:
		 case DDR_PATTERN_LOOP_2+9:
		 case DDR_PATTERN_LOOP_2+10:
		 case DDR_PATTERN_LOOP_2+11:
			  // 	*(p+i) =0x0000ffff;
				if ( *(p+i) != 0x0000ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x0000ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+12:
		 case DDR_PATTERN_LOOP_2+13:
		 case DDR_PATTERN_LOOP_2+14:
		 case DDR_PATTERN_LOOP_2+15:
			//   	*(p+i) =0x000000ff;
				if ( *(p+i) != 0x000000ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x000000ff);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+16:
		 case DDR_PATTERN_LOOP_2+17:
		 case DDR_PATTERN_LOOP_2+18:
		 case DDR_PATTERN_LOOP_2+19:
			//   	*(p+i) =0x00ff00ff;
				if ( *(p+i) != 0x00ff00ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0x00ff00ff);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+20:
		 case DDR_PATTERN_LOOP_2+21:
		 case DDR_PATTERN_LOOP_2+22:
		 case DDR_PATTERN_LOOP_2+23:
			   //	*(p+i) =0xff00ff00;
				if ( *(p+i) != 0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ff00);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+24:
		 case DDR_PATTERN_LOOP_2+25:
		 case DDR_PATTERN_LOOP_2+26:
		 case DDR_PATTERN_LOOP_2+27:
			//   	*(p+i) =0xff00ffff;
				if ( *(p+i) != 0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_2+28:
		 case DDR_PATTERN_LOOP_2+29:
		 case DDR_PATTERN_LOOP_2+30:
		 case DDR_PATTERN_LOOP_2+31:
		//	   	*(p+i) =0xff00ff00;
				if ( *(p+i) != 0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), 0xff00ff00);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+0:
		 case DDR_PATTERN_LOOP_3+1:
		 case DDR_PATTERN_LOOP_3+2:
		 case DDR_PATTERN_LOOP_3+3:
			   //	*(p+i) =~0x00ff0000;
				if ( *(p+i) != ~0x00ff0000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00ff0000);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+4:
		 case DDR_PATTERN_LOOP_3+5:
		 case DDR_PATTERN_LOOP_3+6:
		 case DDR_PATTERN_LOOP_3+7:
			//   	*(p+i) =~0xff000000;
				if ( *(p+i) != ~0xff000000)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff000000);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+8:
		 case DDR_PATTERN_LOOP_3+9:
		 case DDR_PATTERN_LOOP_3+10:
		 case DDR_PATTERN_LOOP_3+11:
			 //  	*(p+i) =~0x0000ffff;
				if ( *(p+i) != ~0x0000ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x0000ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+12:
		 case DDR_PATTERN_LOOP_3+13:
		 case DDR_PATTERN_LOOP_3+14:
		 case DDR_PATTERN_LOOP_3+15:
			//   	*(p+i) =~0x000000ff;
				if ( *(p+i) != ~0x000000ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x000000ff);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+16:
		 case DDR_PATTERN_LOOP_3+17:
		 case DDR_PATTERN_LOOP_3+18:
		 case DDR_PATTERN_LOOP_3+19:
			//   	*(p+i) =~0x00ff00ff;
				if ( *(p+i) != ~0x00ff00ff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0x00ff00ff);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+20:
		 case DDR_PATTERN_LOOP_3+21:
		 case DDR_PATTERN_LOOP_3+22:
		 case DDR_PATTERN_LOOP_3+23:
			   //	*(p+i) =~0xff00ff00;
				if ( *(p+i) != ~0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ff00);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+24:
		 case DDR_PATTERN_LOOP_3+25:
		 case DDR_PATTERN_LOOP_3+26:
		 case DDR_PATTERN_LOOP_3+27:
			 //  	*(p+i) =~0xff00ffff;
				if ( *(p+i) != ~0xff00ffff)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ffff);
					}
				  break;
			   case DDR_PATTERN_LOOP_3+28:
		 case DDR_PATTERN_LOOP_3+29:
		 case DDR_PATTERN_LOOP_3+30:
		 case DDR_PATTERN_LOOP_3+31:
			//   	*(p+i) =~0xff00ff00;
				if ( *(p+i) != ~0xff00ff00)
					{error_count++;
							printf("Error data [0x%08x] at offset 0x%08x[0x%08x]\n", *(p+i), p_convter_int(p + i), ~0xff00ff00);
					}
				  break;


				}
			}

            if (m_len >( 128*4))
			{
				m_len -=( 128*4);
				p += 32*4;
			}
			else
			{
				p += (m_len>>2);
				m_len = 0;
				break;
			}
		}
	}
}



int do_ddr_test(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *endp;
	 unsigned int   loop = 1;
	 unsigned int   lflag = 0;
	 unsigned int  start_addr = DDR_TEST_START_ADDR;
	      unsigned int  test_size = DDR_TEST_SIZE;
	  unsigned int   simple_pattern_flag = 1;
	     unsigned int   cross_talk_pattern_flag = 1;
		  unsigned int   old_pattern_flag = 1;

		  unsigned int   print_flag = 1;
	//	  copy_test_flag = 0;
		  print_flag = 1;
		   error_outof_count_flag =0;
		 error_count =0;
		   printf("\nargc== 0x%08x\n", argc);
			int i ;
	for (i = 0;i<argc;i++)
		{
		printf("\nargv[%d]=%s\n",i,argv[i]);
		}
    if (!argc)
		goto DDR_TEST_START;
if (argc > 1) {
    if (strcmp(argv[1], "l") == 0) {
		lflag = 1;
	}
	else if (strcmp(argv[1], "h") == 0){
		goto usage;
	}
	else{
		loop = simple_strtoul(argv[1], &endp, 10);
        if (*argv[1] == 0 || *endp != 0)
			loop = 1;
	}
}
		//    printf("\nLINE== 0x%08x\n", __LINE__);
		    if (argc ==1) {
	//    start_addr = simple_strtoul(argv[2], &endp, 16);
	//    if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;
	  loop = 1;

	}
    if (argc > 2) {
		start_addr = simple_strtoul(argv[2], &endp, 16);
        if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;

	}
	    if (argc > 3) {
	   test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			test_size = DDR_TEST_SIZE;

	}
		if (test_size<0x1000)
			test_size = DDR_TEST_SIZE;

	old_pattern_flag = 1;
	  simple_pattern_flag = 1;
	    cross_talk_pattern_flag = 1;
//printf("\nLINE== 0x%08x\n", __LINE__);
 if (argc ==2) {
    if ( (strcmp(argv[1], "s") == 0))
		{
		simple_pattern_flag = 1;
		old_pattern_flag=0;
		 cross_talk_pattern_flag = 0;
	}
 else if ((strcmp(argv[1], "c") == 0))
		{
	   simple_pattern_flag = 0;
		old_pattern_flag=0;
		 cross_talk_pattern_flag = 1;
	}
else  if ( (strcmp(argv[1], "e") == 0))
	{
	error_outof_count_flag=1;
	}
	}
 if (argc >2) {
	if ( (strcmp(argv[1], "n") == 0) || (strcmp(argv[2], "n") == 0))
		{
		print_flag = 0;
		}
		if ( (strcmp(argv[1], "p") == 0) || (strcmp(argv[2], "p") == 0))
		{
		copy_test_flag = 1;
		}
    if ( (strcmp(argv[1], "s") == 0) || (strcmp(argv[2], "s") == 0))
		{
		simple_pattern_flag = 1;
		old_pattern_flag=0;
		 cross_talk_pattern_flag = 0;
	}
 else if ((strcmp(argv[1], "c") == 0)||(strcmp(argv[2], "c") == 0))
		{
	   simple_pattern_flag = 0;
		old_pattern_flag=0;
		 cross_talk_pattern_flag = 1;
	}
else  if ( (strcmp(argv[1], "e") == 0)||(strcmp(argv[2], "e") == 0))
	{
	error_outof_count_flag=1;
	}
	}
//printf("\nLINE1== 0x%08x\n", __LINE__);
		 if (argc > 3) {
					if ( (strcmp(argv[1], "p") == 0) || (strcmp(argv[2], "p") == 0) || (strcmp(argv[3], "p") == 0))
		{
		copy_test_flag = 1;
		}
			if ( (strcmp(argv[1], "n") == 0) || (strcmp(argv[2], "n") == 0) || (strcmp(argv[3], "n") == 0))
		{
		print_flag = 0;
		}
    if ( (strcmp(argv[1], "s") == 0) || (strcmp(argv[2], "s") == 0) || (strcmp(argv[3], "s") == 0))
		{
		simple_pattern_flag = 1;
		old_pattern_flag=0;
		 cross_talk_pattern_flag = 0;
	}
  if ((strcmp(argv[1], "c") == 0) || (strcmp(argv[2], "c") == 0) || (strcmp(argv[3], "c") == 0))
		{
	   simple_pattern_flag = 0;
		old_pattern_flag=0;
		 cross_talk_pattern_flag = 1;
	}
  if ( (strcmp(argv[1], "e") == 0) || (strcmp(argv[2], "e") == 0) || (strcmp(argv[3], "e") == 0))
	{
	error_outof_count_flag=1;
	}
			}

		//    printf("\nLINE2== 0x%08x\n", __LINE__);
		//	printf("\nLINE3== 0x%08x\n", __LINE__);
		//	printf("\nLINE== 0x%08x\n", __LINE__);

DDR_TEST_START:

///*
	do {
        if (lflag)
			loop = 888;

		if (old_pattern_flag == 1)
			{
			{
		//	printf("\nLINE== 0x%08x\n", __LINE__);
//printf("\nLINE== 0x%08x\n", __LINE__);
//printf("\nLINE== 0x%08x\n", __LINE__);
if (print_flag)
		printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);
		ddr_write((void *)(int_convter_p(start_addr)), test_size);
	//	 flush_dcache_range(start_addr,start_addr + test_size);
	if (print_flag) {
	    printf("\nEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");
		}
	    ddr_read((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\nEnd 1st read.                              ");
	    printf("\nStart 2nd reading...                       ");}
	    ddr_read((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\nEnd 2nd read.                              ");
	    printf("\nStart 3rd reading...                       ");}
	    ddr_read((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag)
	    printf("\nEnd 3rd read.                              \n");

if (copy_test_flag)
{if(print_flag)
	    printf("\n copy_test_flag = 1,start copy test.                              \n");
 ddr_test_copy((void *)(int_convter_p(start_addr+test_size/2)),(void *)(int_convter_p(start_addr)), test_size/2 );
  ddr_read((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
   ddr_read((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
}

			}
		{
		//	printf("\nLINE== 0x%08x\n", __LINE__);
//printf("\nLINE== 0x%08x\n", __LINE__);
//printf("\nLINE== 0x%08x\n", __LINE__);
if (print_flag) {
 printf("\nStart *4 normal pattern.                                 ");
		printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);
}
		ddr_write4((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\nEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");}
	    ddr_read4((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\nEnd 1st read.                              ");
	    printf("\nStart 2nd reading...                       ");}
	    ddr_read4((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\nEnd 2nd read.                              ");
	    printf("\nStart 3rd reading...                       ");}
	    ddr_read4((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag)
	    printf("\rEnd 3rd read.                              \n");
if (copy_test_flag)
{

 ddr_test_copy((void *)(int_convter_p(start_addr+test_size/2)),(void *)(int_convter_p(start_addr)), test_size/2 );
  ddr_read4((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
   ddr_read4((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
}


			}
			}

if (simple_pattern_flag == 1)
{
if (print_flag) {
		    printf("\nStart *4 no cross talk pattern.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);
}
		ddr_write_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");}
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");}
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 2nd read.                              ");
	    printf("\rStart 3rd reading...                       ");}
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag)
	    printf("\rEnd 3rd read.                              \n");

		if (copy_test_flag)
{
  ddr_test_copy((void *)(int_convter_p(start_addr+test_size/2)),(void *)(int_convter_p(start_addr)), test_size/2 );
  ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
   ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
}

}

if (cross_talk_pattern_flag == 1)
{if(print_flag){
		    printf("\nStart *4  cross talk pattern p.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);
}
		ddr_write_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");}
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");}
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 2nd read.                              ");
	    printf("\rStart 3rd reading...                       ");}
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 3rd read.                              \n");

			    printf("\nStart *4  cross talk pattern n.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);}
		ddr_write_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");}
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");}
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 2nd read.                              ");
	    printf("\rStart 3rd reading...                       ");}
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 3rd read.                              \n");

///*
				    printf("\nStart *4  cross talk pattern p2.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);}
		ddr_write_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");}
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");}
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 2nd read.                              ");
	    printf("\rStart 3rd reading...                       ");}
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 3rd read.                              \n");

			    printf("\nStart *4  cross talk pattern n2.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + test_size);}
		ddr_write_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");}
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");}
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag) {
	    printf("\rEnd 2nd read.                              ");
	    printf("\rStart 3rd reading...                       ");}
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), test_size);
		if (print_flag)
	    printf("\rEnd 3rd read.                              \n");

				if (copy_test_flag)
{
  ddr_test_copy((void *)(int_convter_p(start_addr+test_size/2)),(void *)(int_convter_p(start_addr)), test_size/2 );
  ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
   ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr+test_size/2)), test_size/2);
}
	//    */

}

	if (print_flag)
		  printf("\nError count==0x%08x", error_count);

	  }while(--loop);
//*/

 printf("\rEnd ddr test.                              \n");

	  return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
}

U_BOOT_CMD(
	ddrtest,	5,	1,	do_ddr_test,
	"DDR test function",
	"ddrtest [LOOP] [ADDR].Default address is 0x8d000000\n"
);

int do_ddr_special_test(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *endp;
	 unsigned int   loop = 1;
	 unsigned int   lflag = 0;
	 unsigned int  start_addr = DDR_TEST_START_ADDR;
	    unsigned int test_addr = DDR_TEST_START_ADDR;
	      unsigned int  test_size = DDR_TEST_SIZE;
	  unsigned int   write_times = 1;
	     unsigned int  read_times = 3;
		//  unsigned int   old_pattern_flag = 1;

		  unsigned int   print_flag = 1;
	//	  copy_test_flag = 0;
		  print_flag = 1;
		   error_outof_count_flag =0;
		 error_count =0;
		   printf("\nargc== 0x%08x\n", argc);
			int i ;
	for (i = 0;i<argc;i++)
		{
		printf("\nargv[%d]=%s\n",i,argv[i]);
		}

    if (strcmp(argv[1], "l") == 0) {
		lflag = 1;
	}
	else if (strcmp(argv[1], "h") == 0){
		goto usage;
	}
	else{
		loop = simple_strtoul(argv[1], &endp, 10);
        if (*argv[1] == 0 || *endp != 0)
			loop = 1;
	}

		//    printf("\nLINE== 0x%08x\n", __LINE__);
		    if (argc ==1) {
	//    start_addr = simple_strtoul(argv[2], &endp, 16);
	//    if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;
	  loop = 1;

	}
    if (argc > 2) {
		start_addr = simple_strtoul(argv[2], &endp, 16);
        if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;

	}
	    if (argc > 3) {
	   test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			test_size = DDR_TEST_SIZE;

	}
		if (test_size<0x1000)
			test_size = DDR_TEST_SIZE;
		    if (argc > 4) {
	   write_times = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			write_times = 0;

	}
				    if (argc > 5) {
	   read_times = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			read_times = 0;

	}
					unsigned int  base_pattern = 1;
					unsigned int  inc_flag = 1;
		 if (argc > 6) {
	   base_pattern = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			base_pattern = 0;

	}
	    if (argc > 7) {
	   inc_flag = simple_strtoul(argv[7], &endp, 16);
        if (*argv[7] == 0 || *endp != 0)
			inc_flag = 0;

	}


//printf("\nLINE== 0x%08x\n", __LINE__);

//printf("\nLINE1== 0x%08x\n", __LINE__);


		//    printf("\nLINE2== 0x%08x\n", __LINE__);
		//	printf("\nLINE3== 0x%08x\n", __LINE__);
		//	printf("\nLINE== 0x%08x\n", __LINE__);


unsigned int  count    = 1;
unsigned int   test_val = 1;

///*
	do {
        if (lflag)
			loop = 888;

		if (1)
			{

				for (i=0;i<write_times;)
			{i++;

printf("\nwrite_times==0x%08x \n",((unsigned int)i));
//  serial_put_hex(((unsigned long)i),32);
	//	count=count_max;
	//	reg=reg_base;
	//       val=val_base;
	test_addr=start_addr;
test_val=base_pattern;
count=(test_size>>2);
		do
			{
			 writel(test_val,(unsigned long)test_addr);
			test_addr=test_addr+4;
		if (inc_flag)
			test_val=test_val+1;

			}
		while (count--) ;
					}

		for (i=0;i<read_times;)
			{i++;
		printf("\nread_times==0x%08x \n",((unsigned int)i));
//serial_puts("\nread_times= ");
 //   serial_put_hex(((unsigned long)i),32);
	test_addr=start_addr;
test_val=base_pattern;
count=(test_size>>2);

				do
			{

			//writel(val,(unsigned long)reg);
			if (test_val != (readl((unsigned long)test_addr))) {

printf("\nadd==0x%08x,pattern==0x%08x,read==0x%08x \n",((unsigned int)test_addr),((unsigned int)test_val),(readl((unsigned int)test_addr)));
				}
		test_addr=test_addr+4;
		if (inc_flag)
			test_val=test_val+1;
			}
		while (count--) ;
			}
		}



	if (print_flag)
		  printf("\nError count==0x%08x", error_count);

	  }while(--loop);
//*/

 printf("\rEnd ddr test.                              \n");

	  return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
}
U_BOOT_CMD(
	ddr_spec_test,	8,	1,	do_ddr_special_test,
	"DDR test function",
	"ddrtest [LOOP] [ADDR] [size] [write_times] [read times] [pattern] [inc].ddr_spec_test 1 0x1080000 0x200000 1  3 1 1 \n"
);
/*
int do_mw_mask(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	 char *endp;
unsigned int   reg_add=0;
 unsigned int   wr_reg_value=0;
 unsigned int   rd_reg_value=0;
  unsigned int   wr_reg_and_mask_1=0xffffffff;
 if (argc == 1)
	{  printf("\nplease read help\n");
		   printf("\nexample only change 0xc8836800 0x8c010226 0x000fffff bit20-bit31,no change pll od oc \n");
		   printf("\nmwm 0xc8836800 0x8c010226 0x000fffff\n");
	}
 else{
	if (argc >= 2)
			{
		reg_add = simple_strtoul(argv[1], &endp, 10);
		}
		if (argc >= 3)
			{
		wr_reg_value = simple_strtoul(argv[2], &endp, 10);
		}
				if (argc >= 4)
			{
		wr_reg_and_mask_1 = simple_strtoul(argv[3], &endp, 10);

		}
	              rd_reg_value= (rd_reg(reg_add));
		wr_reg(reg_add,(rd_reg_value&wr_reg_and_mask_1)|(wr_reg_value&(~wr_reg_and_mask_1)) );

	printf("\nmodify ok read==0x%08x\n",(rd_reg(reg_add)));

	}
return 1;
}
U_BOOT_CMD(
	mwm,	30,	1,	do_mw_mask,
	"mw mask function",
	"mw 0xc8836800 0x8c82022c 0x000fffff\n"
);
*/

///*

int ddr_test_s_cross_talk_pattern(int ddr_test_size)
{
#define TEST_OFFSET  0//0X40000000
// unsigned int  start_addr = DDR_TEST_START_ADDR+TEST_OFFSET;
unsigned int  start_addr=test_start_addr;

	error_outof_count_flag=1;

		error_count=0;

#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
training_pattern_flag=0;
#endif
///*
if (training_pattern_flag)
			{
			#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_BABY)
		ddr_test_gx_training_pattern(ddr_test_size);
			#endif
		if (error_count)
	return 1;
else
	return 0;
				}
else
	{
	#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_BABY)
		ddr_test_gx_training_pattern(ddr_test_size);
	#endif

				}
	//			*/
/*
ddr_test_gx_cross_talk_pattern( ddr_test_size);
if (error_count)
	return 1;
else
	return 0;
	*/

{
 printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");
	    ddr_read((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd 1st read.                              ");
	    printf("\nStart 2nd reading...                       ");
	    ddr_read((void *)(int_convter_p(start_addr)), ddr_test_size);

		printf("\nStart writing pattern4 at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write4((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");
	    ddr_read4((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd 1st read.                              ");
	    printf("\nStart 2nd reading...                       ");
	    ddr_read4((void *)(int_convter_p(start_addr)), ddr_test_size);

 printf("\nStart *4 no cross talk pattern.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd 1st read.                              ");
	    printf("\nStart 2nd reading...                       ");
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), ddr_test_size);
}
//if(cross_talk_pattern_flag==1)
{
		    printf("\nStart *4  cross talk pattern p.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");

	 //   printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_p((void *)start_addr, ddr_test_size);
	//    printf("\rEnd 3rd read.                              \n");

			    printf("\nStart *4  cross talk pattern n.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");
	//    printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_n((void *)start_addr, ddr_test_size);
	 //   printf("\rEnd 3rd read.                              \n");


}

{
		    printf("\nStart *4  cross talk pattern p2.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");

	 //   printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_p((void *)start_addr, ddr_test_size);
	//    printf("\rEnd 3rd read.                              \n");

			    printf("\nStart *4  cross talk pattern n.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");
	//    printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_n((void *)start_addr, ddr_test_size);
	 //   printf("\rEnd 3rd read.                              \n");
if (copy_test_flag)
{
 printf("\n start copy test  ...                            ");
 ddr_test_copy((void *)(int_convter_p(start_addr+ddr_test_size/2)),(void *)(int_convter_p(start_addr)), ddr_test_size/2 );
  ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr+ddr_test_size/2)), ddr_test_size/2);
   ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr+ddr_test_size/2)), ddr_test_size/2);
}

}

if (error_count)
	return 1;
else
	return 0;
}


int do_ddr_test_fine_tune_dqs(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Tune ddr dqs function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 //  unsigned int   loop = 1;
   unsigned int   temp_count_i = 1;
   unsigned int   temp_count_j= 1;
	unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;

	 #define  DATX8_DQ_LCD_BDL_REG_WIDTH  12

	 #define  DATX8_DQ_LANE_WIDTH  4
	 #define  CHANNEL_CHANNEL_WIDTH  2

	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1



	#define  DATX8_DQ_LANE_LANE00  0
	#define  DATX8_DQ_LANE_LANE01  1
	#define  DATX8_DQ_LANE_LANE02  2
	#define  DATX8_DQ_LANE_LANE03  3

	 #define  DATX8_DQ_BDLR0  0
	 #define  DATX8_DQ_BDLR1  1
	 #define  DATX8_DQ_BDLR2  2
	 #define  DATX8_DQ_BDLR3  3
	 #define  DATX8_DQ_BDLR4  4
	 #define  DATX8_DQ_BDLR5  5
	 #define  DATX8_DQ_BDLR6  6
	 #define  DATX8_DQ_DXNLCDLR0     7
	 #define  DATX8_DQ_DXNLCDLR1     8
	 #define  DATX8_DQ_DXNLCDLR2     9
	 #define  DATX8_DQ_DXNMDLR        10
	 #define  DATX8_DQ_DXNGTR          11


	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

	 #define  DQ_LCD_BDL_REG_NUM_PER_CHANNEL  DATX8_DQ_LCD_BDL_REG_WIDTH*DATX8_DQ_LANE_WIDTH
		#define  DQ_LCD_BDL_REG_NUM    DQ_LCD_BDL_REG_NUM_PER_CHANNEL*CHANNEL_CHANNEL_WIDTH

	  unsigned int   dq_lcd_bdl_reg_org[DQ_LCD_BDL_REG_NUM];
	  unsigned int   dq_lcd_bdl_reg_left[DQ_LCD_BDL_REG_NUM];
	  unsigned int   dq_lcd_bdl_reg_right[DQ_LCD_BDL_REG_NUM];
	   unsigned int   dq_lcd_bdl_reg_index[DQ_LCD_BDL_REG_NUM];

	  unsigned int   dq_lcd_bdl_reg_left_min[DQ_LCD_BDL_REG_NUM];
	  unsigned int   dq_lcd_bdl_reg_right_min[DQ_LCD_BDL_REG_NUM];

	   unsigned int   dq_lcd_bdl_temp_reg_value;
	   unsigned int   dq_lcd_bdl_temp_reg_value_dqs;
	  unsigned int   dq_lcd_bdl_temp_reg_value_wdqd;
	   unsigned int   dq_lcd_bdl_temp_reg_value_rdqsd;
	  //  unsigned int   dq_lcd_bdl_temp_reg_value_rdqsnd;
	   unsigned int   dq_lcd_bdl_temp_reg_lef_min_value;
	     unsigned int   dq_lcd_bdl_temp_reg_rig_min_value;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_dqs;
	//  unsigned int   dq_lcd_bdl_temp_reg_value_wdqd;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_rdqsd;

	   unsigned int   dq_lcd_bdl_temp_reg_lef;
	   unsigned int   dq_lcd_bdl_temp_reg_rig;
	    unsigned int   dq_lcd_bdl_temp_reg_center;
	    unsigned int   dq_lcd_bdl_temp_reg_windows;
	      unsigned int   dq_lcd_bdl_temp_reg_center_min;
	    unsigned int   dq_lcd_bdl_temp_reg_windows_min;

	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;



	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}
	    if (argc >5) {
	training_pattern_flag = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_pattern_flag = 0;
			}
		else if(training_pattern_flag)
			training_pattern_flag = 1;


	}


		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_loop== 0x%08x\n", test_loop);
		    printf("\training_pattern_flag== 0x%08x\n", training_pattern_flag);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}


//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
   {

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1BDLR0+reg_base_adj;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2BDLR0+reg_base_adj;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3BDLR0+reg_base_adj;}



       for ((temp_count_j=0);(temp_count_j<DATX8_DQ_LCD_BDL_REG_WIDTH);(temp_count_j++))
	   {
		dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=readl(reg_add+4*temp_count_j);
dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=reg_add+4*temp_count_j;
		printf("\n org add  0x%08x reg== 0x%08x\n",(reg_add+4*temp_count_j), (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]));
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]
 =dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j];
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]
 =dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j];

	   }
	}

}

}

}////save and print org training dqs value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
   { printf("\ntest lane==0x%08x\n ",temp_count_i);

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1BDLR0+reg_base_adj;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2BDLR0+reg_base_adj;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3BDLR0+reg_base_adj;}
}

  for ((temp_count_k=0);(temp_count_k<2);(temp_count_k++))
	   {

if (temp_count_k == 0)
{
#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
  dq_lcd_bdl_temp_reg_value_dqs=(readl(reg_add+DDR0_PUB_DX0LCDLR1-DDR0_PUB_DX0BDLR0));
	   dq_lcd_bdl_temp_reg_value_wdqd=(readl(reg_add+DDR0_PUB_DX0LCDLR1-DDR0_PUB_DX0BDLR0))&DQLCDLR_MAX;
	   dq_lcd_bdl_temp_reg_value_rdqsd=(readl(reg_add+DDR0_PUB_DX0LCDLR3-DDR0_PUB_DX0BDLR0))&DQLCDLR_MAX;
	 //  dq_lcd_bdl_temp_reg_value_rdqsnd=((dq_lcd_bdl_temp_reg_value_dqs&0xff0000))>>16;
#else
  dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;
	 //  dq_lcd_bdl_temp_reg_value_rdqsnd=((dq_lcd_bdl_temp_reg_value_dqs&0xff0000))>>16;
#endif

while (dq_lcd_bdl_temp_reg_value_wdqd>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_wdqd--;
printf("\nwdqd left temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
writel(dq_lcd_bdl_temp_reg_value_wdqd,(reg_add+DDR0_PUB_DX0LCDLR1-DDR0_PUB_DX0BDLR0));
#else
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
#endif
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value_wdqd++;
		break;
		}
}
printf("\nwdqd left edge detect \n");
printf("\nwdqd left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_wdqd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x00)|dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_lef_min_value=dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_wdqd>(dq_lcd_bdl_temp_reg_lef_min_value&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_lef_min_value&0xffff00)|dq_lcd_bdl_temp_reg_value_wdqd)	;
}


writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;


while (dq_lcd_bdl_temp_reg_value_wdqd<0xff)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_wdqd++;
printf("\nwdqd rig temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nwdqd right edge detect \n");
		dq_lcd_bdl_temp_reg_value_wdqd--;
		break;
		}
}
printf("\nwdqd right edge detect \n");
printf("\nwdqd right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_wdqd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x00)|dq_lcd_bdl_temp_reg_value_wdqd);

dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;

dq_lcd_bdl_temp_reg_rig_min_value=dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_wdqd<(dq_lcd_bdl_temp_reg_rig_min_value&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_rig_min_value&0xffff00)|dq_lcd_bdl_temp_reg_value_wdqd)	;
}



writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));


}
else if(temp_count_k==1)
{

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;

while (dq_lcd_bdl_temp_reg_value_rdqsd>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_rdqsd--;
printf("\nrdqsd left temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nrdqsd left edge detect \n");
		dq_lcd_bdl_temp_reg_value_rdqsd++;
		break;
		}
}
printf("\nrdqsd left edge detect \n");
printf("\nrdqsd left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_rdqsd rdqsnd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x0000ff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));

dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_lef_min_value=dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_rdqsd>((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_lef_min_value&0xff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16))	;
}


writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;

while (dq_lcd_bdl_temp_reg_value_rdqsd<0xff)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_rdqsd++;
printf("\nrdqsd right temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nrdqsd right edge detect \n");
		dq_lcd_bdl_temp_reg_value_rdqsd--;
		break;
		}
}
printf("\nrdqsd right edge detect \n");
printf("\nrdqsd right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_rdqsd rdqsnd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x0000ff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_rig_min_value=dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_rdqsd<((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_rig_min_value&0xff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16))	;
}



writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));




   }

 }
}

}
}

////tune and save training dqs value




////calculate and print  dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }
reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;


  for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
	   {
	 //  dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=reg_add+4*temp_count_j;

		printf("\n org add  0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
	   }

  for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
	   {
		printf("\n lef add  0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
	   }

  for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
	   {
		printf("\n rig add  0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
	   }

printf("\n ddrtest size ==0x%08x, test times==0x%08x,test_loop==0x%08x\n",ddr_test_size,(test_times+1),test_loop);
printf("\n add  0x00000000 reg==    org           lef           rig           center        win           lef_m         rig_m         min_c         min_win        \n");
for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
   {

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}
}

dq_lcd_bdl_temp_reg_lef=(dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);
dq_lcd_bdl_temp_reg_rig=(dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);

if (test_times == 0)
{
(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1])=dq_lcd_bdl_temp_reg_lef;
(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1])=dq_lcd_bdl_temp_reg_rig;

}
dq_lcd_bdl_temp_reg_lef_min_value=(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);
dq_lcd_bdl_temp_reg_rig_min_value=(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);


//dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value&0x0000ff);
   dq_lcd_bdl_temp_reg_center=( (((dq_lcd_bdl_temp_reg_lef&0xff)+(dq_lcd_bdl_temp_reg_rig&0xff))/2)
   |(((((dq_lcd_bdl_temp_reg_lef>>8)&0xff)+((dq_lcd_bdl_temp_reg_rig>>8)&0xff))/2)<<8)
	|(((((dq_lcd_bdl_temp_reg_lef>>16)&0xff)+((dq_lcd_bdl_temp_reg_rig>>8)&0xff))/2)<<16) );

   dq_lcd_bdl_temp_reg_windows=( (((dq_lcd_bdl_temp_reg_rig&0xff)-(dq_lcd_bdl_temp_reg_lef&0xff)))
   |(((((dq_lcd_bdl_temp_reg_rig>>8)&0xff)-((dq_lcd_bdl_temp_reg_lef>>8)&0xff)))<<8)
	|(((((dq_lcd_bdl_temp_reg_rig>>16)&0xff)-((dq_lcd_bdl_temp_reg_lef>>8)&0xff)))<<16) );


	  dq_lcd_bdl_temp_reg_center_min=( (((dq_lcd_bdl_temp_reg_lef_min_value&0xff)+(dq_lcd_bdl_temp_reg_rig_min_value&0xff))/2)
   |(((((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)+((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))/2)<<8)
	|(((((dq_lcd_bdl_temp_reg_lef_min_value>>16)&0xff)+((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))/2)<<16) );

   dq_lcd_bdl_temp_reg_windows_min=( (((dq_lcd_bdl_temp_reg_rig_min_value&0xff)-(dq_lcd_bdl_temp_reg_lef_min_value&0xff)))
   |(((((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff)-((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)))<<8)
	|(((((dq_lcd_bdl_temp_reg_rig_min_value>>16)&0xff)-((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)))<<16) );

printf("\n add  0x%08x reg==    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x\n",
	(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   dq_lcd_bdl_temp_reg_center,dq_lcd_bdl_temp_reg_windows,
		(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		dq_lcd_bdl_temp_reg_center_min,dq_lcd_bdl_temp_reg_windows_min
);
	   }


}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}




U_BOOT_CMD(
	ddr_tune_dqs,	6,	1,	do_ddr_test_fine_tune_dqs,
	"DDR tune dqs function",
	"ddr_tune_dqs a 0 0x80000 3 or ddr_tune_dqs b 0 0x80000 5 or ddr_tune_dqs a b 0x80000 l\n dcache off ? \n"
);



int do_ddr_test_dqs_window_step(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter test ddr dqs window step function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);

   unsigned int   temp_test_error= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_lane_step=0;
 unsigned int   testing_lane=0;
 unsigned int   test_lane_step_rdqs_flag=0;
  unsigned int   test_min_max_flag=0;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;


	  unsigned int   dq_lcd_bdl_reg_org=0;
	  unsigned int   dq_lcd_bdl_reg_left=0;
	  unsigned int   dq_lcd_bdl_reg_right=0;


	  unsigned int   dq_lcd_bdl_reg_left_min=0;
	  unsigned int   dq_lcd_bdl_reg_right_min=0;

	   unsigned int   dq_lcd_bdl_temp_reg_value=0;


	 //  unsigned int   dq_lcd_bdl_temp_reg_lef_min_value;
	//     unsigned int   dq_lcd_bdl_temp_reg_rig_min_value;


	//   unsigned int   dq_lcd_bdl_temp_reg_lef;
	//   unsigned int   dq_lcd_bdl_temp_reg_rig;


	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;



	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
		 test_lane_step = 0;
	test_lane_step = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_lane_step = 0;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_lane_step = 0;
			}
	}
	if (test_lane_step >7)
		test_lane_step = 0;
	 unsigned int   test_loop=1;
	    if (argc >5) {

	test_min_max_flag = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			test_min_max_flag = 0;
			}
		 else
			test_min_max_flag =1;
	}

		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_lane_step== 0x%08x\n", test_lane_step);
		    printf("\ntest_min_max_flag== 0x%08x\n", test_min_max_flag);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}



//save and print org training dqs value
if (channel_a_en || channel_b_en)
{
	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

}////save and print org training dqs value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{

{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
 reg_base_adj=CHANNEL_A_REG_BASE;
  }



{
	printf("\nshould pause ddl pir== 0x%08x,if no pause ddl ,write lcdlr some time may occour error\n", readl(DDR0_PUB_REG_BASE+4));
 writel((readl(DDR0_PUB_REG_BASE+4))|(1<<29),(DDR0_PUB_REG_BASE+4));
printf("\n pause ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
if (test_lane_step>8)
	test_lane_step=0;
printf("\ntest_lane_step==0x%08x\n ",test_lane_step);

  reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_lane_step>>1);
test_lane_step_rdqs_flag=test_lane_step%2;
testing_lane=(test_lane_step>>1);
 if (!test_lane_step_rdqs_flag)
	{reg_add=reg_add+DDR0_PUB_DX0LCDLR1-DDR0_PUB_DX0BDLR0;
	}
 else
	{
	#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
	reg_add=reg_add+DDR0_PUB_DX0LCDLR1-DDR0_PUB_DX0BDLR0;
	#else
	reg_add=reg_add+DDR0_PUB_DX0LCDLR3-DDR0_PUB_DX0BDLR0;
	#endif

	}

dq_lcd_bdl_temp_reg_value=readl(reg_add);
dq_lcd_bdl_reg_org=dq_lcd_bdl_temp_reg_value;
printf("\nreg_add_0x%08x==0x%08x\n ",reg_add,dq_lcd_bdl_temp_reg_value);
#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
 if (test_lane_step_rdqs_flag)
	{dq_lcd_bdl_temp_reg_value=(((readl(reg_add))&0xff00)>>8);
dq_lcd_bdl_reg_org=dq_lcd_bdl_temp_reg_value;
	}
 else
	{dq_lcd_bdl_temp_reg_value=(((readl(reg_add))&0x00ff)>>0);
dq_lcd_bdl_reg_org=dq_lcd_bdl_temp_reg_value;
	}
#endif

if (test_min_max_flag == 0)
{
while (dq_lcd_bdl_temp_reg_value>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value--;
printf("\n left temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value);
	 if (!test_lane_step_rdqs_flag)
		{
			#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_temp_reg_value<<0)|(((readl(reg_add))&0xffff00)),reg_add);
			#else
	 writel(dq_lcd_bdl_temp_reg_value,reg_add);
			#endif
		}
	 else
		{
		#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_temp_reg_value<<8)|(dq_lcd_bdl_temp_reg_value<<16)|(((readl(reg_add))&0xff)),reg_add);
		#else
		writel(dq_lcd_bdl_temp_reg_value,reg_add);
		  writel(dq_lcd_bdl_temp_reg_value,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		  #endif
		}
	 printf("\n rmin read reg==0x%08x\n ",(readl(reg_add)));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value++;
		break;
		}
}
printf("\n left edge detect \n");
printf("\nleft edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value);


dq_lcd_bdl_reg_left=dq_lcd_bdl_temp_reg_value;
if (test_times == 0)
dq_lcd_bdl_reg_left_min=dq_lcd_bdl_reg_left;
if (dq_lcd_bdl_reg_left>dq_lcd_bdl_reg_left_min)  //update wdqd min value
{
dq_lcd_bdl_reg_left_min=dq_lcd_bdl_reg_left	;
}
} else
{
printf("\n left edge skip \n");
}

	 if (!test_lane_step_rdqs_flag)
		{
				#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_reg_org<<0)|(((readl(reg_add))&0xffff00)),reg_add);
			#else
	 writel(dq_lcd_bdl_reg_org,reg_add);
			#endif
   //  writel(dq_lcd_bdl_reg_org,reg_add);
		}
	 else
		{
				#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_reg_org<<8)|(dq_lcd_bdl_reg_org<<16)|(((readl(reg_add))&0xff)),reg_add);
		#else
		writel(dq_lcd_bdl_reg_org,reg_add);
		  writel(dq_lcd_bdl_reg_org,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		  #endif
	 //	  writel(dq_lcd_bdl_reg_org,reg_add);
	//	  writel(dq_lcd_bdl_reg_org,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		}

dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_org;

printf("\n read reg==0x%08x\n ",(readl(reg_add)));

while (dq_lcd_bdl_temp_reg_value<DQLCDLR_MAX)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value++;
printf("\n rig temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value);
 if (!test_lane_step_rdqs_flag)
		{
	 //writel(dq_lcd_bdl_temp_reg_value,reg_add);
				#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_temp_reg_value<<0)|(((readl(reg_add))&0xffff00)),reg_add);
			#else
	 writel(dq_lcd_bdl_temp_reg_value,reg_add);
			#endif
		}
	 else
		{
				#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_temp_reg_value<<8)|(dq_lcd_bdl_temp_reg_value<<16)|(((readl(reg_add))&0xff)),reg_add);
		#else
		writel(dq_lcd_bdl_temp_reg_value,reg_add);
		  writel(dq_lcd_bdl_temp_reg_value,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		  #endif
	 //	  writel(dq_lcd_bdl_temp_reg_value,reg_add);
	//	  writel(dq_lcd_bdl_temp_reg_value,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		}
printf("\n r max read reg==0x%08x\n ",(readl(reg_add)));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nwdqd right edge detect \n");
		dq_lcd_bdl_temp_reg_value--;
		break;
		}
}
printf("\n right edge detect \n");
printf("\n right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value);

dq_lcd_bdl_reg_right=dq_lcd_bdl_temp_reg_value;
if (test_times == 0)
dq_lcd_bdl_reg_right_min=dq_lcd_bdl_reg_right;
if (dq_lcd_bdl_reg_right<dq_lcd_bdl_reg_right_min)  //update wdqd min value
{
dq_lcd_bdl_reg_right_min=dq_lcd_bdl_reg_right	;
}
	 if (!test_lane_step_rdqs_flag)
		{
	// writel(dq_lcd_bdl_reg_org,reg_add);
					#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_reg_org<<0)|(((readl(reg_add))&0xffff00)),reg_add);
			#else
	 writel(dq_lcd_bdl_reg_org,reg_add);
			#endif
		}
	 else
		{
						#if ( CONFIG_DDR_PHY<P_DDR_PHY_905X)
		 writel((dq_lcd_bdl_reg_org<<8)|(dq_lcd_bdl_reg_org<<16)|(((readl(reg_add))&0xff)),reg_add);
		#else
		writel(dq_lcd_bdl_reg_org,reg_add);
		  writel(dq_lcd_bdl_reg_org,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		  #endif
	// 	  writel(dq_lcd_bdl_reg_org,reg_add);
	//	  writel(dq_lcd_bdl_reg_org,reg_add+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR3);
		}

 printf("\n read reg==0x%08x\n ",(readl(reg_add)));
	printf("\nend pause ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
 writel(((readl(DDR0_PUB_REG_BASE+4))&(~(1<<29))),(DDR0_PUB_REG_BASE+4));
printf("\n resume ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
}



 }
}

}

dq_lcd_bdl_temp_reg_value=(dq_lcd_bdl_reg_right_min<<16)|dq_lcd_bdl_reg_left_min;
 if (!test_lane_step_rdqs_flag)
	{if(channel_a_en){
	dq_lcd_bdl_value_wdq_org_a[testing_lane]=dq_lcd_bdl_reg_org;
	 dq_lcd_bdl_value_wdq_min_a[testing_lane]=dq_lcd_bdl_reg_left_min;
	 dq_lcd_bdl_value_wdq_max_a[testing_lane]=dq_lcd_bdl_reg_right_min;
	}
if (channel_b_en)
	{
		dq_lcd_bdl_value_wdq_org_b[testing_lane]=dq_lcd_bdl_reg_org;
	dq_lcd_bdl_value_wdq_min_b[testing_lane]=dq_lcd_bdl_reg_left_min;
	 dq_lcd_bdl_value_wdq_max_b[testing_lane]=dq_lcd_bdl_reg_right_min;
	}
	}
 else
	{
	if (channel_a_en) {
	 dq_lcd_bdl_value_rdqs_org_a[testing_lane]=dq_lcd_bdl_reg_org;
	dq_lcd_bdl_value_rdqs_min_a[testing_lane]=dq_lcd_bdl_reg_left_min;
	 dq_lcd_bdl_value_rdqs_max_a[testing_lane]=dq_lcd_bdl_reg_right_min;
		}
		if (channel_b_en) {
	 dq_lcd_bdl_value_rdqs_org_b[testing_lane]=dq_lcd_bdl_reg_org;
	dq_lcd_bdl_value_rdqs_min_b[testing_lane]=dq_lcd_bdl_reg_left_min;
	 dq_lcd_bdl_value_rdqs_max_b[testing_lane]=dq_lcd_bdl_reg_right_min;
		}
	}

 return dq_lcd_bdl_temp_reg_value;

usage:
	cmd_usage(cmdtp);
	return 1;

}

///*
U_BOOT_CMD(
	ddr_tune_dqs_step,	6,	1,	do_ddr_test_dqs_window_step,
	"ddr_tune_dqs_step function",
	"ddr_tune_dqs_step a 0 0x80000 3 or ddr_tune_dqs_step b 0 0x80000 5 \n dcache off ? \n"
);


int do_ddr_test_dqs_window(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
 printf("\nEnterddr_test_dqs_window function\n");
		   unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
  // unsigned int   reg_add=0;
  // unsigned int   reg_base_adj=0;

	  unsigned int   lane_step= 0;
	  unsigned int   reg_value= 0;
//int argc2;
//char     *  argv2[30];
char *endp;

		if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}


		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}
	}
//argc2=5;
	//for(i = 1;i<(argc);i++)
		{
		//argv2[i-1]=argv[i];
		}

//argv2[0]=argv[1];
//argv2[1]=argv[2];
//argv2[2]=argv[3];
char str[100];

if (channel_a_en)
{

//*(char     *)(argv2[0])="a";
	//	run_command("ddr_test_cmd 11 a 0 0x80000  ",0);
	 printf("\ntest dqs window lane a\n");
for ((lane_step=0);(lane_step<8);(lane_step++))
{
//sprintf(argv2[3],"d%",( lane_step));
//itoa_ddr_test(lane_step,(argv2[3]),10);
//printf("\nargv2[%d]=%s\n",0,argv2[0]);
//	printf("\nargv2[%d]=%s\n",3,argv2[3]);
	// reg_value=do_ddr_test_dqs_window_step((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
	sprintf(str,"ddr_tune_dqs_step  a 0 0x%08x %d",ddr_test_size,( lane_step));
	printf("\nstr=%s\n",str);
	//sprintf(str,"ddr_tune_dqs_step  b 0 0x80000 %d",( lane_step));
	//printf("\nstr=%s\n",str);
	run_command(str,0);

}
}


if (channel_b_en)
{//*(char     *)(argv2[0])="b";
	//	run_command("ddr_test_cmd 11 a 0 0x80000  ",0);
	 printf("\ntest dqs window lane b\n");
for ((lane_step=0);(lane_step<8);(lane_step++))
{
	//sprintf(str,"ddr_tune_dqs_step  a 0 0x80000 %d",( lane_step));
	//printf("\nstr=%s\n",str);
	sprintf(str,"ddr_tune_dqs_step  b 0 0x%08x %d",ddr_test_size,( lane_step));
	printf("\nstr=%s\n",str);
	run_command(str,0);

}
}

if (channel_a_en)
{
for ((lane_step=0);(lane_step<4);(lane_step++))
{
printf("\n a_lane_0x%08x|wdq_org 0x%08x  |wdq_min 0x%08x |wdq_max 0x%08x ::|rdqs_org  0x%08x  |rdqs_min 0x%08x |rdqs_max 0x%08x  \n",
lane_step,
dq_lcd_bdl_value_wdq_org_a[lane_step],
dq_lcd_bdl_value_wdq_min_a[lane_step],dq_lcd_bdl_value_wdq_max_a[lane_step],
dq_lcd_bdl_value_rdqs_org_a[lane_step],
dq_lcd_bdl_value_rdqs_min_a[lane_step],dq_lcd_bdl_value_rdqs_max_a[lane_step]);
}}
if (channel_b_en)
{
for ((lane_step=0);(lane_step<4);(lane_step++))
{
printf("\n b_lane_0x%08x|wdq_org 0x%08x  |wdq_min 0x%08x |wdq_max 0x%08x ::|rdqs_org  0x%08x  |rdqs_min 0x%08x |rdqs_max 0x%08x  \n",
lane_step,
dq_lcd_bdl_value_wdq_org_b[lane_step],
dq_lcd_bdl_value_wdq_min_b[lane_step],dq_lcd_bdl_value_wdq_max_b[lane_step],
dq_lcd_bdl_value_rdqs_org_b[lane_step],
dq_lcd_bdl_value_rdqs_min_b[lane_step],dq_lcd_bdl_value_rdqs_max_b[lane_step]);
}}

return reg_value;
}

/*
U_BOOT_CMD(
	ddr_tune_dqs_step,	5,	1,	do_ddr_test_fine_tune_dqs_step,
	"ddr_tune_dqs_step function",
	"ddr_tune_dqs_step a 0 0x800000 3 or ddr_tune_dqs_step b 0 0x800000 5 or ddr_tune_dqs_step a b 0x800000 l\n dcache off ? \n"
);
*/

int do_ddr_test_fine_tune_dqs_step(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Tune ddr dqs step function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 //  unsigned int   loop = 1;
   unsigned int   temp_count_i = 1;
   unsigned int   temp_count_j= 1;
	unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
   unsigned int   test_lane_step=0;
 unsigned int   test_lane_step_rdqs_flag=0;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;

	 #define  DATX8_DQ_LCD_BDL_REG_WIDTH  12

	 #define  DATX8_DQ_LANE_WIDTH  4
	 #define  CHANNEL_CHANNEL_WIDTH  2

	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1



	#define  DATX8_DQ_LANE_LANE00  0
	#define  DATX8_DQ_LANE_LANE01  1
	#define  DATX8_DQ_LANE_LANE02  2
	#define  DATX8_DQ_LANE_LANE03  3

	 #define  DATX8_DQ_BDLR0  0
	 #define  DATX8_DQ_BDLR1  1
	 #define  DATX8_DQ_BDLR2  2
	 #define  DATX8_DQ_BDLR3  3
	 #define  DATX8_DQ_BDLR4  4
	 #define  DATX8_DQ_BDLR5  5
	 #define  DATX8_DQ_BDLR6  6
	 #define  DATX8_DQ_DXNLCDLR0     7
	 #define  DATX8_DQ_DXNLCDLR1     8
	 #define  DATX8_DQ_DXNLCDLR2     9
	 #define  DATX8_DQ_DXNMDLR        10
	 #define  DATX8_DQ_DXNGTR          11


	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

	 #define  DQ_LCD_BDL_REG_NUM_PER_CHANNEL  DATX8_DQ_LCD_BDL_REG_WIDTH*DATX8_DQ_LANE_WIDTH
		#define  DQ_LCD_BDL_REG_NUM    DQ_LCD_BDL_REG_NUM_PER_CHANNEL*CHANNEL_CHANNEL_WIDTH

	  unsigned int   dq_lcd_bdl_reg_org[DQ_LCD_BDL_REG_NUM];
	  unsigned int   dq_lcd_bdl_reg_left[DQ_LCD_BDL_REG_NUM];
	  unsigned int   dq_lcd_bdl_reg_right[DQ_LCD_BDL_REG_NUM];
	   unsigned int   dq_lcd_bdl_reg_index[DQ_LCD_BDL_REG_NUM];

	  unsigned int   dq_lcd_bdl_reg_left_min[DQ_LCD_BDL_REG_NUM];
	  unsigned int   dq_lcd_bdl_reg_right_min[DQ_LCD_BDL_REG_NUM];

	   unsigned int   dq_lcd_bdl_temp_reg_value;
	   unsigned int   dq_lcd_bdl_temp_reg_value_dqs;
	  unsigned int   dq_lcd_bdl_temp_reg_value_wdqd;
	   unsigned int   dq_lcd_bdl_temp_reg_value_rdqsd;
	  //  unsigned int   dq_lcd_bdl_temp_reg_value_rdqsnd;
	   unsigned int   dq_lcd_bdl_temp_reg_lef_min_value;
	     unsigned int   dq_lcd_bdl_temp_reg_rig_min_value;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_dqs;
	//  unsigned int   dq_lcd_bdl_temp_reg_value_wdqd;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_rdqsd;

	   unsigned int   dq_lcd_bdl_temp_reg_lef;
	   unsigned int   dq_lcd_bdl_temp_reg_rig;
	    unsigned int   dq_lcd_bdl_temp_reg_center;
	    unsigned int   dq_lcd_bdl_temp_reg_windows;
	      unsigned int   dq_lcd_bdl_temp_reg_center_min;
	    unsigned int   dq_lcd_bdl_temp_reg_windows_min;

	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;



	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
		 test_lane_step = 0;
	test_lane_step = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_lane_step = 0;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_lane_step = 0;
			}
	}
	test_loop=1;

		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_lane_step== 0x%08x\n", test_lane_step);
		    printf("\ntest_loop== 0x%08x\n", test_loop);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}



//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
   {

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1BDLR0+reg_base_adj;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2BDLR0+reg_base_adj;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3BDLR0+reg_base_adj;}



       for ((temp_count_j=0);(temp_count_j<DATX8_DQ_LCD_BDL_REG_WIDTH);(temp_count_j++))
	   {
		dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=readl(reg_add+4*temp_count_j);
dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=reg_add+4*temp_count_j;
		printf("\n org add  0x%08x reg== 0x%08x\n",(reg_add+4*temp_count_j), (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]));
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]
 =dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j];
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]
 =dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j];

	   }
	}

}

}

}////save and print org training dqs value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
if (test_lane_step>8)
	test_lane_step=0;
if (test_lane_step)
{
printf("\ntest_lane_step==0x%08x\n ",test_lane_step);
temp_count_i=(test_lane_step>>1);
test_lane_step_rdqs_flag=test_lane_step-(temp_count_i<<1);
test_lane_step=0;
}
   {
   printf("\ntest lane==0x%08x\n ",temp_count_i);
   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1BDLR0+reg_base_adj;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2BDLR0+reg_base_adj;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3BDLR0+reg_base_adj;}
}

  for ((temp_count_k=0);(temp_count_k<2);(temp_count_k++))
	   {
     if (test_lane_step_rdqs_flag)
		{
		temp_count_k=1;
	test_lane_step_rdqs_flag=0;
		}
if (temp_count_k == 0)
{
  dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;
	 //  dq_lcd_bdl_temp_reg_value_rdqsnd=((dq_lcd_bdl_temp_reg_value_dqs&0xff0000))>>16;

while (dq_lcd_bdl_temp_reg_value_wdqd>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_wdqd--;
printf("\nwdqd left temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value_wdqd++;
		break;
		}
}
printf("\nwdqd left edge detect \n");
printf("\nwdqd left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_wdqd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x00)|dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_lef_min_value=dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_wdqd>(dq_lcd_bdl_temp_reg_lef_min_value&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_lef_min_value&0xffff00)|dq_lcd_bdl_temp_reg_value_wdqd)	;
}


writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;


while (dq_lcd_bdl_temp_reg_value_wdqd<0xff)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_wdqd++;
printf("\nwdqd rig temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nwdqd right edge detect \n");
		dq_lcd_bdl_temp_reg_value_wdqd--;
		break;
		}
}
printf("\nwdqd right edge detect \n");
printf("\nwdqd right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_wdqd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_wdqd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x00)|dq_lcd_bdl_temp_reg_value_wdqd);

dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;

dq_lcd_bdl_temp_reg_rig_min_value=dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_wdqd<(dq_lcd_bdl_temp_reg_rig_min_value&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_rig_min_value&0xffff00)|dq_lcd_bdl_temp_reg_value_wdqd)	;
}



writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));


}
else if(temp_count_k==1)
{

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;

while (dq_lcd_bdl_temp_reg_value_rdqsd>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_rdqsd--;
printf("\nrdqsd left temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nrdqsd left edge detect \n");
		dq_lcd_bdl_temp_reg_value_rdqsd++;
		break;
		}
}
printf("\nrdqsd left edge detect \n");
printf("\nrdqsd left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_rdqsd rdqsnd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x0000ff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));

dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_lef_min_value=dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_rdqsd>((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_lef_min_value&0xff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16))	;
}


writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));

 dq_lcd_bdl_temp_reg_value_dqs=readl(reg_add+4*DATX8_DQ_DXNLCDLR1);
	   dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value_dqs&0xff);
	   dq_lcd_bdl_temp_reg_value_rdqsd=((dq_lcd_bdl_temp_reg_value_dqs&0xff00))>>8;

while (dq_lcd_bdl_temp_reg_value_rdqsd<0xff)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value_rdqsd++;
printf("\nrdqsd right temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
	dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
	 writel(dq_lcd_bdl_temp_reg_value_dqs,(reg_add+4*DATX8_DQ_DXNLCDLR1));
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		//printf("\nrdqsd right edge detect \n");
		dq_lcd_bdl_temp_reg_value_rdqsd--;
		break;
		}
}
printf("\nrdqsd right edge detect \n");
printf("\nrdqsd right edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value_rdqsd);
dq_lcd_bdl_temp_reg_value_dqs=(dq_lcd_bdl_temp_reg_value_wdqd|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
//only update dq_lcd_bdl_temp_reg_value_rdqsd rdqsnd
dq_lcd_bdl_temp_reg_value=dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
dq_lcd_bdl_temp_reg_value_dqs=((dq_lcd_bdl_temp_reg_value&0x0000ff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16));
dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]=dq_lcd_bdl_temp_reg_value_dqs;


dq_lcd_bdl_temp_reg_rig_min_value=dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1];
if (dq_lcd_bdl_temp_reg_value_rdqsd<((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))  //update wdqd min value
{
dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]
=((dq_lcd_bdl_temp_reg_rig_min_value&0xff)|(dq_lcd_bdl_temp_reg_value_rdqsd<<8)|(dq_lcd_bdl_temp_reg_value_rdqsd<<16))	;
}



writel(dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1],(reg_add+4*DATX8_DQ_DXNLCDLR1));




   }

 }
}

}
}

////tune and save training dqs value




////calculate and print  dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }
reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;


  for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
	   {
	 //  dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+temp_count_j]=reg_add+4*temp_count_j;

		printf("\n org add  0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
	   }

  for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
	   {
		printf("\n lef add  0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
	   }

  for ((temp_count_j=0);(temp_count_j<DQ_LCD_BDL_REG_NUM_PER_CHANNEL);(temp_count_j++))
	   {
		printf("\n rig add  0x%08x reg== 0x%08x\n",(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]), (dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_j]));
	   }

printf("\n ddrtest size ==0x%08x, test times==0x%08x,test_loop==0x%08x\n",ddr_test_size,(test_times+1),test_loop);
printf("\n add  0x00000000 reg==    org           lef           rig           center        win           lef_m         rig_m         min_c         min_win        \n");
for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
   {

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3BDLR0+reg_base_adj+DATX8_DQ_DXNLCDLR1*4;}
}

dq_lcd_bdl_temp_reg_lef=(dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);
dq_lcd_bdl_temp_reg_rig=(dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);

if (test_times == 0)
{
(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1])=dq_lcd_bdl_temp_reg_lef;
(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1])=dq_lcd_bdl_temp_reg_rig;

}
dq_lcd_bdl_temp_reg_lef_min_value=(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);
dq_lcd_bdl_temp_reg_rig_min_value=(dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]);


//dq_lcd_bdl_temp_reg_value_wdqd=(dq_lcd_bdl_temp_reg_value&0x0000ff);
   dq_lcd_bdl_temp_reg_center=( (((dq_lcd_bdl_temp_reg_lef&0xff)+(dq_lcd_bdl_temp_reg_rig&0xff))/2)
   |(((((dq_lcd_bdl_temp_reg_lef>>8)&0xff)+((dq_lcd_bdl_temp_reg_rig>>8)&0xff))/2)<<8)
	|(((((dq_lcd_bdl_temp_reg_lef>>16)&0xff)+((dq_lcd_bdl_temp_reg_rig>>8)&0xff))/2)<<16) );

   dq_lcd_bdl_temp_reg_windows=( (((dq_lcd_bdl_temp_reg_rig&0xff)-(dq_lcd_bdl_temp_reg_lef&0xff)))
   |(((((dq_lcd_bdl_temp_reg_rig>>8)&0xff)-((dq_lcd_bdl_temp_reg_lef>>8)&0xff)))<<8)
	|(((((dq_lcd_bdl_temp_reg_rig>>16)&0xff)-((dq_lcd_bdl_temp_reg_lef>>8)&0xff)))<<16) );


	  dq_lcd_bdl_temp_reg_center_min=( (((dq_lcd_bdl_temp_reg_lef_min_value&0xff)+(dq_lcd_bdl_temp_reg_rig_min_value&0xff))/2)
   |(((((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)+((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))/2)<<8)
	|(((((dq_lcd_bdl_temp_reg_lef_min_value>>16)&0xff)+((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff))/2)<<16) );

   dq_lcd_bdl_temp_reg_windows_min=( (((dq_lcd_bdl_temp_reg_rig_min_value&0xff)-(dq_lcd_bdl_temp_reg_lef_min_value&0xff)))
   |(((((dq_lcd_bdl_temp_reg_rig_min_value>>8)&0xff)-((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)))<<8)
	|(((((dq_lcd_bdl_temp_reg_rig_min_value>>16)&0xff)-((dq_lcd_bdl_temp_reg_lef_min_value>>8)&0xff)))<<16) );

printf("\n add  0x%08x reg==    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x\n",
	(dq_lcd_bdl_reg_index[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_org[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_left[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_right[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   dq_lcd_bdl_temp_reg_center,dq_lcd_bdl_temp_reg_windows,
		(dq_lcd_bdl_reg_left_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
	   (dq_lcd_bdl_reg_right_min[testing_channel*DQ_LCD_BDL_REG_NUM_PER_CHANNEL+temp_count_i*DATX8_DQ_LCD_BDL_REG_WIDTH+DATX8_DQ_DXNLCDLR1]),
		dq_lcd_bdl_temp_reg_center_min,dq_lcd_bdl_temp_reg_windows_min
);
	   }


}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}

U_BOOT_CMD(
	ddr_dqs_window_step,	5,	1,	do_ddr_test_dqs_window_step,
	"DDR tune dqs function",
	"ddr_dqs_window_step a 0 0x800000 1 or ddr_dqs_window_step b 0 0x800000 5\n dcache off ? \n"
);

///*


int do_ddr2pll_cmd(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{

#define DDR_TEST_CMD_TEST_ZQ     0
#define DDR_TEST_CMD_TEST_AC_BIT_SETUP      1
#define DDR_TEST_CMD_TEST_AC_BIT_HOLD     2
#define DDR_TEST_CMD_TEST_DATA_WRITE_BIT_SETUP      3
#define DDR_TEST_CMD_TEST_DATA_WRITE_BIT_HOLD      4
#define DDR_TEST_CMD_TEST_DATA_READ_BIT_SETUP      5
#define DDR_TEST_CMD_TEST_DATA_READ_BIT_HOLD     6
#define DDR_TEST_CMD_TEST_DATA_VREF     7
#define DDR_TEST_CMD_TEST_CLK_INVETER     8
	char *endp;
	unsigned int pll, zqcr;
unsigned int ddr_test_cmd_type=0;
 unsigned int ddr_test_cmd_soc_vref=0;
unsigned int ddr_test_cmd_dram_vref=0;//0x3f;
unsigned int ddr_test_cmd_zq_vref=0;//0x3f;
	/* need at least two arguments */
	if (argc < 2)
		goto usage;

	pll = simple_strtoul(argv[1], &endp,0);
	if (*argv[1] == 0 || *endp != 0) {
		printf ("Error: Wrong format parament!\n");
		return 1;
	}
if (argc >2)
{
	zqcr = simple_strtoul(argv[2], &endp, 16);
	if (*argv[2] == 0 || *endp != 0) {
		zqcr = 0;
	}
}
else
{
	  zqcr = 0;
}
if (argc >3)
{
	ddr_test_cmd_type = simple_strtoul(argv[3], &endp, 16);
	if (*argv[3] == 0 || *endp != 0) {
		ddr_test_cmd_type = 0;
	}
}
else
{
	  ddr_test_cmd_type = 0;
}

if (argc >4)
{
	ddr_test_cmd_soc_vref = simple_strtoul(argv[4], &endp, 16);
	if (*argv[4] == 0 || *endp != 0) {
		ddr_test_cmd_soc_vref = 0;
	}
}
else
{
	  ddr_test_cmd_soc_vref = 0;
}
if (argc >5)
{
	ddr_test_cmd_dram_vref = simple_strtoul(argv[5], &endp, 16);
	if (*argv[5] == 0 || *endp != 0) {
		ddr_test_cmd_dram_vref = 0;
	}
}
unsigned int soc_dram_hex_dec=0;
if (argc >6)
{
	soc_dram_hex_dec = simple_strtoul(argv[6], &endp, 16);
	if (*argv[6] == 0 || *endp != 0) {
		soc_dram_hex_dec = 0;
	}
}
if (argc >7)
{
	ddr_test_cmd_zq_vref = simple_strtoul(argv[7], &endp, 16);
	if (*argv[7] == 0 || *endp != 0) {
		ddr_test_cmd_zq_vref = 0;
	}
}

if (soc_dram_hex_dec)
{
if (argc >4)
{
	ddr_test_cmd_soc_vref = simple_strtoul(argv[4], &endp, 0);
	if (*argv[4] == 0 || *endp != 0) {
		ddr_test_cmd_soc_vref = 0;
	}
}
else
{
	  ddr_test_cmd_soc_vref = 0;
}
if (argc >5)
{
	ddr_test_cmd_dram_vref = simple_strtoul(argv[5], &endp, 0);
	if (*argv[5] == 0 || *endp != 0) {
		ddr_test_cmd_dram_vref = 0;
	}
}
if (argc >7)
{
	ddr_test_cmd_zq_vref = simple_strtoul(argv[7], &endp, 0);
	if (*argv[7] == 0 || *endp != 0) {
		ddr_test_cmd_zq_vref = 0;
	}
}
if (ddr_test_cmd_soc_vref)
{
if (ddr_test_cmd_soc_vref<45)
	ddr_test_cmd_soc_vref=45;
if (ddr_test_cmd_soc_vref>88)
	ddr_test_cmd_soc_vref=88;
ddr_test_cmd_soc_vref=(ddr_test_cmd_soc_vref*100-4407)/70;
}

if (ddr_test_cmd_dram_vref)
{
if (ddr_test_cmd_dram_vref<45)
	ddr_test_cmd_dram_vref=45;
if (ddr_test_cmd_dram_vref>92)
	ddr_test_cmd_dram_vref=92;
if (ddr_test_cmd_dram_vref>60) {
ddr_test_cmd_dram_vref=(ddr_test_cmd_dram_vref*100-6000)/65;
}
else{
ddr_test_cmd_dram_vref=((ddr_test_cmd_dram_vref*100-4500)/65)|(1<<6);
}
}


printf("\nSet ddr_test_cmd_dram_vref [0x%08x]\n",ddr_test_cmd_dram_vref);
if (ddr_test_cmd_zq_vref == 0)
	ddr_test_cmd_zq_vref=0;
if (ddr_test_cmd_zq_vref) {
if (ddr_test_cmd_zq_vref<45)
	ddr_test_cmd_zq_vref=45;
if (ddr_test_cmd_zq_vref>88)
	ddr_test_cmd_zq_vref=88;
ddr_test_cmd_zq_vref=(ddr_test_cmd_zq_vref*100-4407)/70;
}
}

//if(ddr_test_cmd_type==DDR_TEST_CMD_TEST_AC_BIT_HOLD)
//{if (ddr_test_cmd_clk_seed ==0)
//ddr_test_cmd_clk_seed = 0x3f;
//if (ddr_test_cmd_acbdl_x_seed ==0)
//ddr_test_cmd_acbdl_x_seed = 0x3f;
//}

#if defined(CONFIG_M6TV) || defined(CONFIG_M6TVD)
	writel(zqcr | (0x3c << 24), PREG_STICKY_REG0);
#else
	writel((ddr_test_cmd_type<<16)|zqcr | (0xf13 << 20), PREG_STICKY_REG0);
#endif
#if ( CONFIG_DDR_PHY>=P_DDR_PHY_905X)
	  writel((ddr_test_cmd_zq_vref<<24)|(ddr_test_cmd_soc_vref<<8)|ddr_test_cmd_dram_vref , PREG_STICKY_REG9);
#endif
	writel(pll, PREG_STICKY_REG1);
	printf("Set pll done [0x%08x]\n", readl(PREG_STICKY_REG1));
	printf("Set STICKY_REG0 [0x%08x]\n", readl(PREG_STICKY_REG0));
	#if ( CONFIG_DDR_PHY>=P_DDR_PHY_905X)
	printf("Set STICKY_REG9 [0x%08x]\n", readl(PREG_STICKY_REG9));
	printf("Set STICKY_REG8 [0x%08x]\n", readl(PREG_STICKY_REG8));
	#endif
	printf("\nbegin reset 111...........\n");
	printf("\nbegin reset 2...........\n");
	printf("\nbegin reset 3...........\n");

#ifdef CONFIG_M8B
	writel(0xf080000 | 2000, WATCHDOG_TC);
#else
  //  writel(WATCHDOG_TC, 0xf400000 | 2000);
 // *P_WATCHDOG_RESET = 0;
 ddr_test_watchdog_reset_system();
#endif

	return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
}
int do_ddr_test_ac_bit_setup_hold_window(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter test ddr ac bit window  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 unsigned int   ddl_100step_ps= 0;

   unsigned int   temp_test_error= 0;
	 unsigned int   temp_count= 0;
 unsigned int   temp_reg_value[40];

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_ac_setup_hold=0;
//unsigned int   testing_seed=0;
// unsigned int   test_lane_step_rdqs_flag=0;
  unsigned int   test_acbdl=0;
//   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;


	  unsigned int   acbdlr0_reg_org=0;
	  unsigned int   acbdlr_x_reg_org=0;
	   unsigned int   acbdlr_x_reg_hold_min=0;
	    //  unsigned int   acbdlr_x_reg_hold_min=0;
	   unsigned int   acbdlr_x_reg_setup_max=0;
	//    unsigned int   acbdlr_x_reg_setup_max=0;
	//  unsigned int   dq_lcd_bdl_reg_left=0;
	//  unsigned int   dq_lcd_bdl_reg_right=0;


	//  unsigned int   dq_lcd_bdl_reg_left_min=0;
	//  unsigned int   dq_lcd_bdl_reg_right_min=0;

	   unsigned int   dq_lcd_bdl_temp_reg_value=0;


	 //  unsigned int   dq_lcd_bdl_temp_reg_lef_min_value;
	//     unsigned int   dq_lcd_bdl_temp_reg_rig_min_value;


	//   unsigned int   dq_lcd_bdl_temp_reg_lef;
	//   unsigned int   dq_lcd_bdl_temp_reg_rig;


	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;


		{
	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
		 test_ac_setup_hold = 0;
	test_ac_setup_hold = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_ac_setup_hold = 0;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_ac_setup_hold = 0;
			}
	}
	if (test_ac_setup_hold >1)
		test_ac_setup_hold = 2;
		    if (argc >5) {

	test_acbdl= simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			test_acbdl = 0;
			}
	if (test_acbdl>39)
		 test_acbdl =12;//default test cs0 pin
	}
}
		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_ac_setup_hold== 0x%08x\n", test_ac_setup_hold);
		    printf("\ntest_acbdl== 0x%08x\n", test_acbdl);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}



//save and print org training dqs value
if (channel_a_en || channel_b_en)
{
	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

}////save and print org training dqs value



{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{

{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
 reg_base_adj=CHANNEL_A_REG_BASE;
  }
printf("\nshould pause ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
 writel((readl(DDR0_PUB_REG_BASE+4))|(1<<29),(DDR0_PUB_REG_BASE+4));
printf("\n pause ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));


			for ((temp_count=0);(temp_count<10);(temp_count++))
				{
				acbdlr0_9_reg_org[temp_count]=(readl(DDR0_PUB_ACBDLR0+(temp_count<<2)+reg_base_adj));

				};


{
   ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_ACMDLR0+reg_base_adj)))>>16)&0xff);
   printf("\nddl_100step_ps== %08d,0_5cycle_ps== %08d,0_5cycle==0x%08x\n", ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)),
	((((readl(DDR0_PUB_ACMDLR0+reg_base_adj)))>>16)&0xff));

  reg_add=DDR0_PUB_ACBDLR0+reg_base_adj;
   acbdlr0_reg_org=readl(DDR0_PUB_ACBDLR0+reg_base_adj);
  acbdlr_x_reg_org=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
  printf("\ntest_acbdl %08x | ac_setup_hold==0x%08x\n ",test_acbdl,test_ac_setup_hold);
  printf("\nacbdlr0_reg_0x%08x_org==0x%08x  |  acbdlr_x_reg_0x%08x_org==0x%08x\n ",(DDR0_PUB_ACBDLR0+reg_base_adj),
	acbdlr0_reg_org,(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj),acbdlr_x_reg_org);
if (test_ac_setup_hold == 0)
{
printf("\ntest_ac_setup\n ");


//writel(0,(DDR0_PUB_ACBDLR0+reg_base_adj));
 dq_lcd_bdl_temp_reg_value=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);


//{writel((dq_lcd_bdl_temp_reg_value&(~(0xff<<(8*(test_acbdl%4))))),((test_acbdl/4)*4+DDR0_PUB_ACBDLR0+reg_base_adj));
//}



reg_add=(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
acbdlr_x_reg_org=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
dq_lcd_bdl_temp_reg_value=((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff);
while (dq_lcd_bdl_temp_reg_value<ACBDLR_MAX)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value++;
printf("\n reg_add==0x%08x,right temp==0x%08x\n,value==0x%08x",reg_add,dq_lcd_bdl_temp_reg_value,
	((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))));

		{
 writel(((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))),reg_add);

		}
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value--;
		break;
		}
}
printf("\n right edge detect ,reg==0x%08x\n",(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));
printf("\n org==0x%08x,right edge==0x%08x,value==0x%08x\n ",((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff),dq_lcd_bdl_temp_reg_value,
	((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))));

	{acbdlr_x_reg_setup_max=dq_lcd_bdl_temp_reg_value;}

dq_lcd_bdl_temp_reg_value=0;
 //writel(((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))),reg_add);
	 writel(((acbdlr_x_reg_org)),reg_add);
//test_ac_setup_hold=1;
{
 printf("\ntest_acbdl %08x | ac_setup_hold==0x%08x acmdlr==0x%08x  ddl_100step_ps==%08d\n",test_acbdl,test_ac_setup_hold,
	readl(DDR0_PUB_ACMDLR0+reg_base_adj),ddl_100step_ps);
   printf("\nacbdlr0_reg_org==0x%08x  |  acbdlr_x_reg_org==0x%08x\n ",acbdlr0_reg_org,acbdlr_x_reg_org);
printf("acbdlr_x_reg_setup_max 0x%08x  \
	setup time==0x%08x, %08d ps \n ",
	acbdlr_x_reg_setup_max,(acbdlr_x_reg_setup_max-
	((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)),((acbdlr_x_reg_setup_max-
	((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)) *ddl_100step_ps)/100
	);
acbdlr0_9_reg_setup_max[test_acbdl]=(acbdlr_x_reg_setup_max-
	((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff));
acbdlr0_9_reg_setup_time[test_acbdl]=((acbdlr_x_reg_setup_max-
	((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)) *ddl_100step_ps)/100;
			for ((temp_count=0);(temp_count<10);(temp_count++))
				{
				 writel(((acbdlr0_9_reg_org[temp_count])),(DDR0_PUB_ACBDLR0+(temp_count<<2)+reg_base_adj));

				};

}

}

if (test_ac_setup_hold == 1)
{
printf("\ntest_ac_hold 1\n ");
  acbdlr0_reg_org=readl(DDR0_PUB_ACBDLR0+reg_base_adj);
  acbdlr_x_reg_org=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
  printf("\ntest_acbdl %08x | ac_setup_hold==0x%08x\n ",test_acbdl,test_ac_setup_hold);
  printf("\nacbdlr0_reg_org==0x%08x  |  acbdlr_x_reg_org==0x%08x\n ",acbdlr0_reg_org,acbdlr_x_reg_org);


 printf("\nacbdlr0_reg==0x%08x  |  acbdlr_x_reg==0x%08x\n ",
	readl(DDR0_PUB_ACBDLR0+reg_base_adj),readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));

reg_add=(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
dq_lcd_bdl_temp_reg_value=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
dq_lcd_bdl_temp_reg_value=((dq_lcd_bdl_temp_reg_value>>(8*(test_acbdl%4)))&0xff);
while (dq_lcd_bdl_temp_reg_value>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value--;
printf("\n reg==0x%08x, left temp==0x%08x\n ,value==0x%08x ",reg_add,dq_lcd_bdl_temp_reg_value,
	((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))));

		{
 writel(((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))),reg_add);

		}
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value++;
		break;
		}
}
printf("\n left edge detect ,reg==0x%08x\n",(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));
printf("\n org==0x%08x,left edge==0x%08x\n ",((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff),dq_lcd_bdl_temp_reg_value);

	{acbdlr_x_reg_hold_min=dq_lcd_bdl_temp_reg_value;}


//test_ac_setup_hold=1;
//writel(acbdlr0_reg_org,(DDR0_PUB_ACBDLR0+reg_base_adj));
writel(acbdlr_x_reg_org,(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));
//dq_lcd_bdl_temp_reg_value=0;
// writel(((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))),reg_add);
{


 printf("\ntest_acbdl %08x | ac_setup_hold==0x%08x acmdlr==0x%08x  ddl_100step_ps==%08d\n",test_acbdl,test_ac_setup_hold,
	readl(DDR0_PUB_ACMDLR0+reg_base_adj),ddl_100step_ps);
   printf("\nacbdlr0_reg_org==0x%08x  |  acbdlr_x_reg_org==0x%08x\n ",acbdlr0_reg_org,acbdlr_x_reg_org);
printf("acbdlr_x_reg_hold_min==0x%08x \
	holdup time==0x%08x, %08d ps\n ",
	acbdlr_x_reg_hold_min,
	(((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)-acbdlr_x_reg_hold_min),
	((((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)-acbdlr_x_reg_hold_min)*ddl_100step_ps)/100);

}
acbdlr0_9_reg_hold_max[test_acbdl]=(((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)-acbdlr_x_reg_hold_min);
acbdlr0_9_reg_hold_time[test_acbdl]=((((acbdlr_x_reg_org>>(8*(test_acbdl%4)))&0xff)-acbdlr_x_reg_hold_min)*ddl_100step_ps)/100;

			for ((temp_count=0);(temp_count<10);(temp_count++))
				{
				 writel(((acbdlr0_9_reg_org[temp_count])),(DDR0_PUB_ACBDLR0+(temp_count<<2)+reg_base_adj));

				};

}

if (test_ac_setup_hold == 2)
{
printf("\ntest_ac_hold 2 method\n ");
  acbdlr0_reg_org=readl(DDR0_PUB_ACBDLR0+reg_base_adj);
  acbdlr_x_reg_org=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
  printf("\ntest_acbdl %08x | ac_setup_hold==0x%08x\n ",test_acbdl,test_ac_setup_hold);
  printf("\nacbdlr0_reg_org==0x%08x  |  acbdlr_x_reg_org==0x%08x\n ",acbdlr0_reg_org,acbdlr_x_reg_org);


 printf("\nacbdlr0_reg==0x%08x  |  acbdlr_x_reg==0x%08x\n ",
	readl(DDR0_PUB_ACBDLR0+reg_base_adj),readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));

reg_add=(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
//dq_lcd_bdl_temp_reg_value=readl(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj);
//dq_lcd_bdl_temp_reg_value=((dq_lcd_bdl_temp_reg_value>>(8*(test_acbdl%4)))&0xff);
dq_lcd_bdl_temp_reg_value=(readl(DDR0_PUB_ACBDLR0+reg_base_adj)&0xff);
while (dq_lcd_bdl_temp_reg_value<0x3f)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value++;
printf("\n reg==0x%08x, right temp==0x%08x,value==0x%08x\n ",(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj),dq_lcd_bdl_temp_reg_value,
	((dq_lcd_bdl_temp_reg_value|(dq_lcd_bdl_temp_reg_value<<(8))|(dq_lcd_bdl_temp_reg_value<<(16))
		|(dq_lcd_bdl_temp_reg_value<<(24)))&(~(0xff<<(8*(test_acbdl%4)))))|(acbdlr_x_reg_org&((0xff<<(8*(test_acbdl%4))))));
/*
		{
			for ((temp_count=0);(temp_count<10);(temp_count++))
				{
	 writel((dq_lcd_bdl_temp_reg_value|(dq_lcd_bdl_temp_reg_value<<(8))|(dq_lcd_bdl_temp_reg_value<<(16))
		|(dq_lcd_bdl_temp_reg_value<<(24))),(DDR0_PUB_ACBDLR0+(temp_count<<2)+reg_base_adj));
				};

 writel(((dq_lcd_bdl_temp_reg_value|(dq_lcd_bdl_temp_reg_value<<(8))|(dq_lcd_bdl_temp_reg_value<<(16))
		|(dq_lcd_bdl_temp_reg_value<<(24)))&(~(0xff<<(8*(test_acbdl%4)))))|(acbdlr_x_reg_org&((0xff<<(8*(test_acbdl%4))))),
		(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));

		}
*/

{
			for ((temp_count=0);(temp_count<40);(temp_count++))
				{if(temp_count==(test_acbdl))
				{
				temp_reg_value[temp_count]=((readl(DDR0_PUB_ACBDLR0+(((temp_count)>>2)<<2)+
	reg_base_adj))>>(8*(temp_count%4)))&0xff;
				}else
				{
				temp_reg_value[temp_count]=(((readl(DDR0_PUB_ACBDLR0+(((temp_count)>>2)<<2)+
	reg_base_adj))>>(8*(temp_count%4)))&0xff)+1;
					}
				temp_reg_value[temp_count]=((temp_reg_value[temp_count]>ACBDLR_MAX)?(ACBDLR_MAX):(temp_reg_value[temp_count]));

					};
			for ((temp_count=0);(temp_count<40);(temp_count++))
				{
				 writel((((temp_reg_value[(temp_count)])|((temp_reg_value[temp_count+1])<<(8))|(((temp_reg_value[temp_count+2])<<(16)))
		|((temp_reg_value[temp_count+3])<<(24)))),
		(DDR0_PUB_ACBDLR0+(((temp_count)>>2)<<2)+
	reg_base_adj));
			 temp_count=temp_count+3;
					};
			printf("\n reg_bdlr_ck==0x%08x,right temp==0x%08x\n,ck_value==0x%08x",(DDR0_PUB_ACBDLR0+
	reg_base_adj),(dq_lcd_bdl_temp_reg_value),
	(readl(DDR0_PUB_ACBDLR0+
	reg_base_adj)));
			printf("\n reg_bdlr_x==0x%08x,right temp==0x%08x\n,x_value==0x%08x",(DDR0_PUB_ACBDLR0+(((test_acbdl)>>2)<<2)+
	reg_base_adj),(dq_lcd_bdl_temp_reg_value),
	(readl(DDR0_PUB_ACBDLR0+(((test_acbdl)>>2)<<2)+
	reg_base_adj)));

}



	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value--;
		break;
		}
}
printf("\n right edge detect ,reg==0x%08x\n",(((test_acbdl>>2)<<2)+DDR0_PUB_ACBDLR0+reg_base_adj));
printf("\norg==0x%08x, right edge==0x%08x\n ",acbdlr0_reg_org&0xff,dq_lcd_bdl_temp_reg_value);

	{acbdlr_x_reg_hold_min=dq_lcd_bdl_temp_reg_value;}


//test_ac_setup_hold=1;
dq_lcd_bdl_temp_reg_value=0;

		{


 printf("\ntest_acbdl %08x | ac_setup_hold==0x%08x acmdlr==0x%08x  ddl_100step_ps==%08d\n",test_acbdl,test_ac_setup_hold,
	readl(DDR0_PUB_ACMDLR0+reg_base_adj),ddl_100step_ps);
   printf("\nacbdlr0_reg_org==0x%08x  |  acbdlr_x_reg_org==0x%08x\n ",acbdlr0_reg_org,acbdlr_x_reg_org);
printf("acbdlr_x_reg_hold_max==0x%08x \
	holdup time==0x%08x, %08d ps\n ",
	acbdlr_x_reg_hold_min,
	((acbdlr_x_reg_hold_min-(acbdlr0_reg_org&0xff))),((acbdlr_x_reg_hold_min-(acbdlr0_reg_org&0xff))*ddl_100step_ps)/100);

}
				acbdlr0_9_reg_hold_max[test_acbdl]=((acbdlr_x_reg_hold_min-(acbdlr0_reg_org&0xff)));
				acbdlr0_9_reg_hold_time[test_acbdl]=((acbdlr_x_reg_hold_min-(acbdlr0_reg_org&0xff))*ddl_100step_ps)/100;
							for ((temp_count=0);(temp_count<10);(temp_count++))
				{
				 writel(((acbdlr0_9_reg_org[temp_count])),(DDR0_PUB_ACBDLR0+(temp_count<<2)+reg_base_adj));

				};

}





 }
}

}

 //  ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_ACMDLR0+reg_base_adj)))>>16)&0xff);



printf("\nddl_100step_ps== %08d,0_5cycle_ps== %08d\n", ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)));

printf("\nresume  ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
 writel((readl(DDR0_PUB_REG_BASE+4))&(~(1<<29)),(DDR0_PUB_REG_BASE+4));
printf("\n resume ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));

 return dq_lcd_bdl_temp_reg_value;

usage:
	cmd_usage(cmdtp);
	return 1;

}}

U_BOOT_CMD(
	ddr_test_ac_bit_setup_hold_window,	6,	1,	do_ddr_test_ac_bit_setup_hold_window,
	"DDR test ac bit margin function",
	"do_ddr_test_ac_bit_setup_hold_window a 0 0x8000000 0 c or do_ddr_test_ac_bit_setup_hold_window a 0 0x8000000 2 c  \n dcache off ? \n"
	//do_ddr_test_ac_bit_setup_hold_window a 0 0x8000000 setup/hold pin_id //c --- cs ,,8 --- ba0
);

int do_ddr_test_data_bit_setup_hold_window(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
///*

   printf("\nEnter test ddr data bit window  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 unsigned int   ddl_100step_ps= 0;

   unsigned int   temp_test_error= 0;
	 unsigned int   temp_count= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_data_setup_hold=0;
//unsigned int   testing_seed=0;
// unsigned int   test_lane_step_rdqs_flag=0;
  unsigned int  open_vt=0;
  unsigned int  test_bdl=0;
//   unsigned int   test_times=1;
  // unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
   unsigned int   reg_bdlrck=0;
   unsigned int   reg_bdlr_x=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;


	  unsigned int   bdlrck_reg_org=0;
	  unsigned int   bdlr_x_reg_org=0;
	//   unsigned int   bdlr_x_reg_hold_min=0;
	    //  unsigned int   acbdlr_x_reg_hold_min=0;
	   unsigned int   bdlr_x_reg_setup_max=0;
		unsigned int   bdlr_x_reg_hold_max=0;
	//    unsigned int   acbdlr_x_reg_setup_max=0;
	//  unsigned int   dq_lcd_bdl_reg_left=0;
	//  unsigned int   dq_lcd_bdl_reg_right=0;


	//  unsigned int   dq_lcd_bdl_reg_left_min=0;
	//  unsigned int   dq_lcd_bdl_reg_right_min=0;

	   unsigned int   dq_lcd_bdl_temp_reg_value=0;
	 unsigned int   temp_reg_value[24];


	 //  unsigned int   dq_lcd_bdl_temp_reg_lef_min_value;
	//     unsigned int   dq_lcd_bdl_temp_reg_rig_min_value;


	//   unsigned int   dq_lcd_bdl_temp_reg_lef;
	//   unsigned int   dq_lcd_bdl_temp_reg_rig;


	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;


		{
	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
		 test_data_setup_hold = 0;
	test_data_setup_hold = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_data_setup_hold = 0;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_data_setup_hold = 0;
			}
	}
	if (test_data_setup_hold >1)
		test_data_setup_hold = 1;
		    if (argc >5) {

	test_bdl= simple_strtoul(argv[5], &endp, 0);
        if (*argv[5] == 0 || *endp != 0)
			{
			test_bdl = 0;
			}
	if (test_bdl>96)
		 test_bdl =0;
	}
			    if (argc >6) {

	open_vt= simple_strtoul(argv[6], &endp, 0);
        if (*argv[6] == 0 || *endp != 0)
			{
			open_vt = 0;
			}
	//if(open_vt)
	//	 open_vt =1;
	}
}
		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_data_setup_hold== 0x%08x\n", test_data_setup_hold);
		    printf("\ntest_bdl== 0x%08x\n", test_bdl);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}



//save and print org training dqs value
if (channel_a_en || channel_b_en)
{
	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

}////save and print org training dqs value



{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{

{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
 reg_base_adj=CHANNEL_A_REG_BASE;
  }

printf("\nshould pause ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
 writel((readl(DDR0_PUB_REG_BASE+4))|(1<<29),(DDR0_PUB_REG_BASE+4));
printf("\n pause ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
			for ((temp_count=0);(temp_count<28);(temp_count++))
				{
//data_bdlr0_5_reg_org[temp_count]=(((readl(((temp_count>>2)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/6)+reg_base_adj))
//	>>(8*(test_bdl%4)))&0xff);
data_bdlr0_5_reg_org[temp_count]=((readl(((temp_count%7)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/7)+reg_base_adj))
	);
				};


{
   ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_DX0MDLR0+reg_base_adj)))>>16)&0xff);
   printf("\nddl_100step_ps== %08d,0_5cycle_ps== %08d,0_5cycle==0x%08x\n", ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)),
	((((readl(DDR0_PUB_DX0MDLR0+reg_base_adj)))>>16)&0xff));

  //reg_add=DDR0_PUB_DX0BDLR0+reg_base_adj;
  reg_bdlrck=((((test_bdl%24)>11)?(DDR0_PUB_DX0BDLR5):(DDR0_PUB_DX0BDLR2))+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj);
   reg_bdlr_x= (DDR0_PUB_DX0BDLR0+((((test_bdl%24)>>2)<<2))+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj);
if ((test_bdl%24)>11)
	{reg_bdlr_x=reg_bdlr_x+4;//dxnbdlr345 register add have a gap with dxnbdlr012
	}
   bdlrck_reg_org=readl(reg_bdlrck)  ;
  bdlr_x_reg_org=readl(reg_bdlr_x);
  printf("\ntest_bdl %08x | data_setup_hold==0x%08x\n ",test_bdl,test_data_setup_hold);
  printf("\nbdlr0_reg_0x%08x_org==0x%08x  |  bdlr_x_reg_0x%08x_org==0x%08x\n ",reg_bdlrck,
	bdlrck_reg_org,reg_bdlr_x,bdlr_x_reg_org);
if (test_data_setup_hold == 0)
{
printf("\ntest_data_setup\n ");



 reg_bdlrck=((((test_bdl%24)>11)?(DDR0_PUB_DX0BDLR5):(DDR0_PUB_DX0BDLR2))+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj);
   reg_bdlr_x= (DDR0_PUB_DX0BDLR0+((((test_bdl%24)>>2)<<2))+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj);
 if ((test_bdl%24)>11)
	{reg_bdlr_x=reg_bdlr_x+4;//dxnbdlr345 register add have a gap with dxnbdlr012
	}
	  bdlrck_reg_org=readl(reg_bdlrck)  ;
  bdlr_x_reg_org=readl(reg_bdlr_x);

dq_lcd_bdl_temp_reg_value=((bdlr_x_reg_org>>(8*(test_bdl%4)))&0xff);
while (dq_lcd_bdl_temp_reg_value<ACBDLR_MAX)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value++;
printf("\n reg_bdlr_x==0x%08x,right temp==0x%08x\n,value==0x%08x",reg_bdlr_x,dq_lcd_bdl_temp_reg_value,
	((bdlr_x_reg_org)&(~(0xff<<(8*(test_bdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_bdl%4))));

		{
 writel(((bdlr_x_reg_org)&(~(0xff<<(8*(test_bdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_bdl%4))),reg_bdlr_x);

		}
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value--;
		break;
		}
}
printf("\n right edge detect ,reg==0x%08x\n",(reg_bdlr_x));
printf("\n org==0x%08x,right edge==0x%08x,value==0x%08x\n ",((bdlr_x_reg_org>>(8*(test_bdl%4)))&0xff),dq_lcd_bdl_temp_reg_value,
	((bdlr_x_reg_org)&(~(0xff<<(8*(test_bdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_bdl%4))));

	{bdlr_x_reg_setup_max=dq_lcd_bdl_temp_reg_value;}

dq_lcd_bdl_temp_reg_value=0;
 //writel(((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))),reg_add);
	 writel(((bdlr_x_reg_org)),reg_bdlr_x);
//test_ac_setup_hold=1;
{
 printf("\ntest_bdl %08x | data_setup_hold==0x%08x mdlr==0x%08x  ddl_100step_ps==%08d\n",test_bdl,test_data_setup_hold,
	readl(DDR0_PUB_DX0MDLR0+reg_base_adj),ddl_100step_ps);
   printf("\nbdlr_ck_reg_org==0x%08x  |  bdlr_x_reg_org==0x%08x\n ",bdlrck_reg_org,bdlr_x_reg_org);
printf("acbdlr_x_reg_setup_max 0x%08x  \
	setup time==0x%08x, %08d ps \n ",
	bdlr_x_reg_setup_max,(bdlr_x_reg_setup_max-
	((bdlr_x_reg_org>>(8*(test_bdl%4)))&0xff)),((bdlr_x_reg_setup_max-
	((bdlr_x_reg_org>>(8*(test_bdl%4)))&0xff)) *ddl_100step_ps)/100
	);
bdlr0_9_reg_setup_max[test_bdl]=(bdlr_x_reg_setup_max-
	((bdlr_x_reg_org>>(8*(test_bdl%4)))&0xff));
bdlr0_9_reg_setup_time[test_bdl]=((bdlr_x_reg_setup_max-
	((bdlr_x_reg_org>>(8*(test_bdl%4)))&0xff)) *ddl_100step_ps)/100;
			for ((temp_count=0);(temp_count<28);(temp_count++))
				{
				 writel(((data_bdlr0_5_reg_org[temp_count])),
					(((temp_count%7)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/7)+reg_base_adj));

				};

}

}




if (test_data_setup_hold)
{
printf("\ntest_data_hold\n ");



 reg_bdlrck=((((test_bdl%24)>11)?(DDR0_PUB_DX0BDLR5):(DDR0_PUB_DX0BDLR2))+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj);
   reg_bdlr_x= (DDR0_PUB_DX0BDLR0+((((test_bdl%24)>>2)<<2))+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj);
    if ((test_bdl%24)>11)
	{reg_bdlr_x=reg_bdlr_x+4;//dxnbdlr345 register add have a gap with dxnbdlr012
	}
	  bdlrck_reg_org=readl(reg_bdlrck)  ;
  bdlr_x_reg_org=readl(reg_bdlr_x);

dq_lcd_bdl_temp_reg_value=((bdlrck_reg_org>>(8*(1)))&0xff);
while (dq_lcd_bdl_temp_reg_value<ACBDLR_MAX)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value++;
printf("\n reg_bdlr_ck==0x%08x,right temp==0x%08x\n,value==0x%08x",reg_bdlrck,dq_lcd_bdl_temp_reg_value,
	(((bdlrck_reg_org)&(~(0xffff<<(8*(1)))))|(dq_lcd_bdl_temp_reg_value<<(8*(1)))|(dq_lcd_bdl_temp_reg_value<<(8*(2)))));

		{
// writel((((bdlrck_reg_org)&(~(0xffff<<(8*(1)))))|(dq_lcd_bdl_temp_reg_value<<(8*(1)))|(dq_lcd_bdl_temp_reg_value<<(8*(2)))),reg_bdlrck);

		}



if (((test_bdl%24)<12))
{
			for ((temp_count=0);(temp_count<12);(temp_count++))
				{if(temp_count==(test_bdl%24))
				{
				temp_reg_value[temp_count]=((readl(DDR0_PUB_DX0BDLR0+(((test_bdl%24)>>2)<<2)+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj))>>(8*(temp_count%4)))&0xff;
				}else
				{
				temp_reg_value[temp_count]=(((readl(DDR0_PUB_DX0BDLR0+(((test_bdl%24)>>2)<<2)+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj))>>(8*(temp_count%4)))&0xff)+1;
					}
				temp_reg_value[temp_count]=((temp_reg_value[temp_count]>ACBDLR_MAX)?(ACBDLR_MAX):(temp_reg_value[temp_count]));

					};
			for ((temp_count=0);(temp_count<12);(temp_count++))
				{
				 writel((((temp_reg_value[(temp_count)])|((temp_reg_value[temp_count+1])<<(8))|(((temp_reg_value[temp_count+2])<<(16)))
		|((temp_reg_value[temp_count+3])<<(24)))),
		(DDR0_PUB_DX0BDLR0+(((temp_count%24)>>2)<<2)+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj));
			 temp_count=temp_count+3;
					};
			printf("\n reg_bdlr_x==0x%08x,right temp==0x%08x\n,x_value==0x%08x",reg_bdlr_x,dq_lcd_bdl_temp_reg_value,
	(readl(DDR0_PUB_DX0BDLR0+(((test_bdl%24)>>2)<<2)+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj)));

}


if (((test_bdl%24) >= 12))
{
			for ((temp_count=12);(temp_count<24);(temp_count++))
				{if(temp_count==(test_bdl%24))
				{
				temp_reg_value[temp_count]=((readl(DDR0_PUB_DX0BDLR0+(((test_bdl%24)>>2)<<2)+4+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj))>>(8*(temp_count%4)))&0xff;
				}else
				{
				temp_reg_value[temp_count]=(((readl(DDR0_PUB_DX0BDLR0+(((test_bdl%24)>>2)<<2)+4+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj))>>(8*(temp_count%4)))&0xff)+1;
					}
				temp_reg_value[temp_count]=((temp_reg_value[temp_count]>ACBDLR_MAX)?(ACBDLR_MAX):(temp_reg_value[temp_count]));

					};
			for ((temp_count=12);(temp_count<24);(temp_count++))
				{
				 writel((((temp_reg_value[(temp_count)])|((temp_reg_value[temp_count+1])<<(8))|(((temp_reg_value[temp_count+2])<<(16)))
		|((temp_reg_value[temp_count+3])<<(24)))),
		(DDR0_PUB_DX0BDLR0+(((temp_count%24)>>2)<<2)+4+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj));
				 temp_count=temp_count+3;
					};
						printf("\n reg_bdlr_x==0x%08x,right temp==0x%08x\n,x_value==0x%08x",reg_bdlr_x,dq_lcd_bdl_temp_reg_value,
	(readl(DDR0_PUB_DX0BDLR0+(((test_bdl%24)>>2)<<2)+4+
	(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(test_bdl/24)+reg_base_adj)));
}

	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);

	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		dq_lcd_bdl_temp_reg_value--;
		break;
		}
}

printf("\n right edge detect ,reg==0x%08x\n",(reg_bdlrck));
printf("\n org==0x%08x,right edge==0x%08x,value==0x%08x\n ",((bdlrck_reg_org>>(8*(1)))&0xff),dq_lcd_bdl_temp_reg_value,
	(((bdlrck_reg_org)&(~(0xffff<<(8*(1)))))|(dq_lcd_bdl_temp_reg_value<<(8*(1)))|(dq_lcd_bdl_temp_reg_value<<(8*(2)))));

	{bdlr_x_reg_hold_max=dq_lcd_bdl_temp_reg_value;}

dq_lcd_bdl_temp_reg_value=0;
 //writel(((acbdlr_x_reg_org)&(~(0xff<<(8*(test_acbdl%4)))))|(dq_lcd_bdl_temp_reg_value<<(8*(test_acbdl%4))),reg_add);
	 writel(((bdlrck_reg_org)),reg_bdlrck);
//test_ac_setup_hold=1;
{
 printf("\ntest_bdl %08x | data_setup_hold==0x%08x mdlr==0x%08x  ddl_100step_ps==%08d\n",test_bdl,test_data_setup_hold,
	readl(DDR0_PUB_DX0MDLR0+reg_base_adj),ddl_100step_ps);
   printf("\nbdlr_ck_reg_org==0x%08x  |  bdlr_x_reg_org==0x%08x\n ",bdlrck_reg_org,bdlr_x_reg_org);
printf("acbdlr_x_reg_hold_max 0x%08x  \
	hold time==0x%08x, %08d ps \n ",
	bdlr_x_reg_hold_max,(bdlr_x_reg_hold_max-
	((bdlrck_reg_org>>(8*(1)))&0xff)),((bdlr_x_reg_hold_max-
	((bdlrck_reg_org>>(8*(1)))&0xff)) *ddl_100step_ps)/100
	);
bdlr0_9_reg_hold_max[test_bdl]=(bdlr_x_reg_hold_max-
	((bdlrck_reg_org>>(8*(1)))&0xff));
bdlr0_9_reg_hold_time[test_bdl]=((bdlr_x_reg_hold_max-
	((bdlrck_reg_org>>(8*(1)))&0xff)) *ddl_100step_ps)/100;
			for ((temp_count=0);(temp_count<28);(temp_count++))
				{
				 writel(((data_bdlr0_5_reg_org[temp_count])),
					(((temp_count%7)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/7)+reg_base_adj));

				};

}

}





 }
}

}

 //  ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_ACMDLR0+reg_base_adj)))>>16)&0xff);



printf("\nddl_100step_ps== %08d,0_5cycle_ps== %08d\n", ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)));

printf("\nresume  ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));
if (open_vt)
{
 writel((readl(DDR0_PUB_REG_BASE+4))&(~(1<<29)),(DDR0_PUB_REG_BASE+4));
}
printf("\n resume ddl pir== 0x%08x\n", readl(DDR0_PUB_REG_BASE+4));

 return dq_lcd_bdl_temp_reg_value;



}

usage:
	cmd_usage(cmdtp);
	//*/
	return 1;
}
U_BOOT_CMD(
	ddr_test_data_bit_setup_hold_window,	6,	1,	do_ddr_test_data_bit_setup_hold_window,
	"DDR test data bit margin function",
	"ddr_test_data_bit_setup_hold_window a 0 0x8000000 0 3 or ddr_test_data_bit_setup_hold_window a 0 0x8000000 1 3  \n dcache off ? \n"
);

unsigned int
do_test_address_bus(volatile unsigned int * baseAddress, unsigned int nBytes)
{
	unsigned int addressMask = (nBytes/sizeof(unsigned int) - 1);
	unsigned int offset;
	unsigned int testOffset;

	unsigned int pattern	 = (unsigned int) 0xAAAAAAAA;
	unsigned int antipattern = (unsigned int) 0x55555555;

	unsigned int data1, data2;

	unsigned int ret = 0;

	/*
	 * Write the default pattern at each of the power-of-two offsets.
	 */
	for (offset = 1; (offset & addressMask) != 0; offset <<= 1)
	{
		baseAddress[offset] = pattern;
	}

	/*
	 * Check for address bits stuck high.
	 */
	testOffset = 0;
	baseAddress[testOffset] = antipattern;

	for (offset = 1; (offset & addressMask) != 0; offset <<= 1)
	{
		data1 = baseAddress[offset];
		data2 = baseAddress[offset];
		if (data1 != data2)
		{
			printf("  memTestAddressBus - read twice different[offset]: 0x%8x-0x%8x\n", data1, data2);
			ret = 1;
		}
		if (data1 != pattern)
		{
			printf("  memTestAddressBus - write[0x%8x]: 0x%8x, read[0x%8x]: 0x%8x\n", \
				offset, pattern, offset, data1);
			ret = 1;
			//return ((unsigned int) &baseAddress[offset]);
		}
	}

	baseAddress[testOffset] = pattern;

	/*
	 * Check for address bits stuck low or shorted.
	 */
	for (testOffset = 1; (testOffset & addressMask) != 0; testOffset <<= 1)
	{
		baseAddress[testOffset] = antipattern;

		if (baseAddress[0] != pattern)
		{
			printf("  memTestAddressBus2 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0]: 0x%8x\n", \
				testOffset, antipattern, baseAddress[0]);
			ret = 1;
			//return ((unsigned int) &baseAddress[testOffset]);
		}

		for (offset = 1; (offset & addressMask) != 0; offset <<= 1)
		{
			data1 = baseAddress[offset];
			if ((data1 != pattern) && (offset != testOffset))
			{
				printf("  memTestAddressBus3 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
					testOffset, antipattern, testOffset, data1);
				ret = 1;
				//return ((unsigned int) &baseAddress[testOffset]);
			}
		}

		baseAddress[testOffset] = pattern;
	}


for (offset = 0x1; (offset <=addressMask) ; offset++)
	{
	if (((~offset) <= addressMask) )
		{
		baseAddress[offset] = pattern;
		baseAddress[(~offset)] = antipattern;
		}
	}

for (offset = 0x1; (offset <=addressMask); offset++)
	{
	if (((~offset) <= addressMask) )
		{
		if (baseAddress[offset] != pattern)
			{
			printf("  memTestAddressBus4 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
					offset, pattern, offset, baseAddress[offset]);

			ret = 1;
			break;
			}

			if (baseAddress[(~offset)] != antipattern)
			{
			printf("  memTestAddressBus5 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
					((~offset)), antipattern, ((~offset)), baseAddress[((~offset))]);
			ret = 1;
			break;
			}
		}
	}

if (ret)
{return (ret);
}
//unsigned int suq_value;
for (offset = 0x1; (offset <=addressMask) ; offset++)
	{

		{
		pattern=((offset<<2)-offset);
		baseAddress[offset] = pattern;
		//baseAddress[(~offset)] = antipattern;
		}
	}

for (offset = 0x1; (offset <=addressMask); offset++)
	{

		{
		pattern=((offset<<2)-offset);
		if (baseAddress[offset] != pattern)
			{
			printf("  memTestAddressBus6 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
					offset,pattern, offset, baseAddress[offset]);
			ret = 1;
			break;
			}


		}
	}
if (ret)
{return (ret);
}
for (offset = 0x1; (offset <=addressMask) ; offset++)
	{

		{
		pattern=~((offset<<2)-offset);
		baseAddress[offset] = pattern;
		//baseAddress[(~offset)] = antipattern;
		}
	}

for (offset = 0x1; (offset <=addressMask); offset++)
	{

		{
		pattern=~((offset<<2)-offset);
		if (baseAddress[offset] != pattern)
			{
			printf("  memTestAddressBus7 - write baseAddress[0x%8x]: 0x%8x, read baseAddress[0x%8x]: 0x%8x\n", \
					offset,pattern, offset, baseAddress[offset]);
			ret = 1;
			break;
			}


		}
	}


	return (ret);
}   /* memTestAddressBus() */

int ddr_test_s_add_cross_talk_pattern(int ddr_test_size)
{
// unsigned int  start_addr = DDR_TEST_START_ADDR;
 unsigned int  start_addr=test_start_addr;
	error_outof_count_flag=1;
		error_count=0;

 printf("\rStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");
	    ddr_read((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	   printf("\rStart 2nd reading...                       ");
	    ddr_read((void *)(int_convter_p(start_addr)), ddr_test_size);

		printf("\rStart writing pattern4 at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write4((void *)(int_convter_p(start_addr)), ddr_test_size);
	   printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read4((void *)(int_convter_p(start_addr)), ddr_test_size);
	   printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read4((void *)(int_convter_p(start_addr)), ddr_test_size);

printf("\rStart writing add pattern                                 ");
if (do_test_address_bus((void *)(int_convter_p(start_addr)), ddr_test_size))
{error_count++;
}

/*
 printf("\nStart *4 no cross talk pattern.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd write.                                 ");
	    printf("\nStart 1st reading...                       ");
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\nEnd 1st read.                              ");
	    printf("\nStart 2nd reading...                       ");
	    ddr_read_pattern4_no_cross_talk((void *)(int_convter_p(start_addr)), ddr_test_size);

//if(cross_talk_pattern_flag==1)
{
		    printf("\nStart *4  cross talk pattern p.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");

	 //   printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	//    printf("\rEnd 3rd read.                              \n");

			    printf("\nStart *4  cross talk pattern n.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");
	//    printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	 //   printf("\rEnd 3rd read.                              \n");


}

{
		    printf("\nStart *4  cross talk pattern p2.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_p2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");

	 //   printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_p((void *)(int_convter_p(start_addr)), ddr_test_size);
	//    printf("\rEnd 3rd read.                              \n");

			    printf("\nStart *4  cross talk pattern n.                                 ");
		  printf("\nStart writing at 0x%08x - 0x%08x...", start_addr, start_addr + ddr_test_size);
		ddr_write_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd write.                                 ");
	    printf("\rStart 1st reading...                       ");
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 1st read.                              ");
	    printf("\rStart 2nd reading...                       ");
	    ddr_read_pattern4_cross_talk_n2((void *)(int_convter_p(start_addr)), ddr_test_size);
	    printf("\rEnd 2nd read.                              ");
	//    printf("\rStart 3rd reading...                       ");
	//    ddr_read_pattern4_cross_talk_n((void *)(int_convter_p(start_addr)), ddr_test_size);
	 //   printf("\rEnd 3rd read.                              \n");


}
*/
if (error_count)
	return 1;
else
	return 0;
}

int do_ddr_test_ac_windows_aclcdlr(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr ac windows function\n");
   printf("\nset ddr  test test_start_addr==0x%08x \n",test_start_addr);
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 //  unsigned int   loop = 1;
   //unsigned int   temp_count_i = 1;
 //  unsigned int   temp_count_j= 1;
  //  unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;



	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

		   unsigned int  ac_mdlr_a_org=0;
	   unsigned int  ac_mdlr_b_org=0;

	  unsigned int  ac_lcdlr_a_org=0;
	  unsigned int   ac_bdlr0_a_org=0;
	  unsigned int  ac_lcdlr_b_org=0;
	  unsigned int   ac_bdlr0_b_org=0;
	  unsigned int  ac_lcdlr_a_rig=0;
	  unsigned int   ac_bdlr0_a_rig=0;
	  unsigned int  ac_lcdlr_b_rig=0;
	  unsigned int   ac_bdlr0_b_rig=0;
	  unsigned int  ac_lcdlr_a_lef=0;
	  unsigned int   ac_bdlr0_a_lef=0;
	  unsigned int  ac_lcdlr_b_lef=0;
	  unsigned int   ac_bdlr0_b_lef=0;

		unsigned int  ac_lcdlr_a_rig_min=0;
	  unsigned int   ac_bdlr0_a_rig_min=0;
	  unsigned int  ac_lcdlr_b_rig_min=0;
	  unsigned int   ac_bdlr0_b_rig_min=0;
	  unsigned int  ac_lcdlr_a_lef_min=0;
	  unsigned int   ac_bdlr0_a_lef_min=0;
	  unsigned int  ac_lcdlr_b_lef_min=0;
	  unsigned int   ac_bdlr0_b_lef_min=0;
	    unsigned int  ac_lcdlr_temp=0;
	  unsigned int   ac_bdlr0_temp=0;



	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}


		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_loop== 0x%08x\n", test_loop);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}


//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
 }

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;

printf("\ntest A channel AC110\n");
if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel 0x%08x\n",reg_add);
 ac_mdlr_a_org=(unsigned int )(readl((unsigned int )reg_add));//readl(reg_add);//0xc8836000
	   ac_lcdlr_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR)));//readl(reg_add+4);
	ac_bdlr0_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR)));//readl(reg_add+8);
	printf("\ntest A channel AC113\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);
}
if (reg_base_adj == CHANNEL_B_REG_BASE)
{
printf("\ntest A channel AC112\n");
  ac_mdlr_b_org=readl(reg_add);
	   ac_lcdlr_b_org=readl(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR);
	ac_bdlr0_b_org=readl(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR);
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);
}


}

}

}////save and print org training  value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel AC\n");
}
else
{
printf("\ntest B channel AC\n");
}

{
{
	//#ifdef DDR_TEST_ACLCDLR

 reg_add=DDR0_PUB_ACLCDLR+reg_base_adj;

ac_lcdlr_temp=readl(reg_add);

while (ac_lcdlr_temp>0)
{
temp_test_error=0;
ac_lcdlr_temp--;

printf("\nlcdlr test value==0x%08x\n ",ac_lcdlr_temp);
	 writel(ac_lcdlr_temp,(reg_add));
	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		ac_lcdlr_temp++;
		break;
		}
}

printf("\nlcdlr left edge detect \n");
printf("\nlcdlr left edge==0x%08x\n ",ac_lcdlr_temp);
if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_lcdlr_a_lef=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_a_org;
}
else
{
ac_lcdlr_b_lef=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_b_org;

}
 writel(ac_lcdlr_temp,(reg_add));

 while (ac_lcdlr_temp<ACLCDLR_MAX)
{
temp_test_error=0;
ac_lcdlr_temp++;
printf("\nlcdlr test value==0x%08x\n ",ac_lcdlr_temp);
	 writel(ac_lcdlr_temp,(reg_add));
	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nlcdlr right edge detect \n");
		ac_lcdlr_temp--;
		break;
		}
}
printf("\nlcdlrright edge detect \n");
printf("\nlcdlr right edge==0x%08x\n ",ac_lcdlr_temp);



if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_lcdlr_a_rig=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_a_org;
}
else
{
ac_lcdlr_b_rig=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_b_org;

}
writel(ac_lcdlr_temp,(reg_add));



//#endif

{
   reg_add=DDR0_PUB_ACBDLR0+reg_base_adj;

ac_bdlr0_temp=readl(reg_add);
while (ac_bdlr0_temp>0)
{
temp_test_error=0;
ac_bdlr0_temp--;
	printf("\nbdlr0 test value==0x%08x\n ",ac_bdlr0_temp);
	 writel(ac_bdlr0_temp,(reg_add));
	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		ac_bdlr0_temp++;
		break;
		}
}
printf("\nacbdlr0 left edge detect \n");
printf("\nacbdlr0 left edge==0x%08x\n ",ac_bdlr0_temp);

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_bdlr0_a_lef=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_a_org;
}
else
{
ac_bdlr0_b_lef=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_b_org;

}

  writel(ac_bdlr0_temp,(reg_add));

 while (ac_bdlr0_temp<ACBDLR_MAX)
{
temp_test_error=0;
ac_bdlr0_temp++;
printf("\nbdlr0 test value==0x%08x\n ",ac_bdlr0_temp);
	 writel(ac_bdlr0_temp,(reg_add));
	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nacbdlr0 right edge detect \n");
		ac_bdlr0_temp--;
		break;
		}
}
printf("\nacbdlr0 right edge detect \n");
printf("\nacbdlr0 right edge==0x%08x\n ",ac_bdlr0_temp);

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_bdlr0_a_rig=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_a_org;
}
else
{
ac_bdlr0_b_rig=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_b_org;

}

  writel(ac_bdlr0_temp,(reg_add));

}
}

}
}

////tune and save training dqs value




////calculate and print  dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }
reg_add=DDR0_PUB_ACMDLR+reg_base_adj;

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
if (test_times)
{
if (ac_lcdlr_a_lef>ac_lcdlr_a_lef_min)
ac_lcdlr_a_lef_min=ac_lcdlr_a_lef;

if (ac_lcdlr_a_rig<ac_lcdlr_a_rig_min)
ac_lcdlr_a_rig_min=ac_lcdlr_a_rig;

if (ac_bdlr0_a_lef>ac_bdlr0_a_lef_min)
ac_bdlr0_a_lef_min=ac_bdlr0_a_lef;

if (ac_bdlr0_a_rig<ac_bdlr0_a_rig_min)
ac_bdlr0_a_rig_min=ac_bdlr0_a_rig;
}
	else
		{
ac_lcdlr_a_lef_min=ac_lcdlr_a_lef;
ac_lcdlr_a_rig_min=ac_lcdlr_a_rig;
ac_bdlr0_a_lef_min=ac_bdlr0_a_lef;
ac_bdlr0_a_rig_min=ac_bdlr0_a_rig;
		}
	   printf("\ntest A channel AC result\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);

	printf("\n ac_acmdlr_org  0x%08x reg== 0x%08x   lcdlr_lef   lcdlr_rig   lcdlr_lmin  lcdlr_rmin\n",(reg_add),ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org,ac_lcdlr_a_lef,ac_lcdlr_a_rig,ac_lcdlr_a_lef_min,ac_lcdlr_a_rig_min);
	printf("\n ac_bdlr0_a_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org,ac_bdlr0_a_lef,ac_bdlr0_a_rig,ac_bdlr0_a_lef_min,ac_bdlr0_a_rig_min);



}

if (reg_base_adj == CHANNEL_B_REG_BASE)
{
if (test_times)
{
if (ac_lcdlr_b_lef>ac_lcdlr_b_lef_min)
ac_lcdlr_b_lef_min=ac_lcdlr_b_lef;

if (ac_lcdlr_b_rig<ac_lcdlr_b_rig_min)
ac_lcdlr_b_rig_min=ac_lcdlr_b_rig;

if (ac_bdlr0_b_lef>ac_bdlr0_b_lef_min)
ac_bdlr0_b_lef_min=ac_bdlr0_b_lef;

if (ac_bdlr0_b_rig<ac_bdlr0_b_rig_min)
ac_bdlr0_b_rig_min=ac_bdlr0_b_rig;
}
	else
		{
ac_lcdlr_b_lef_min=ac_lcdlr_b_lef;
ac_lcdlr_b_rig_min=ac_lcdlr_b_rig;
ac_bdlr0_b_lef_min=ac_bdlr0_b_lef;
ac_bdlr0_b_rig_min=ac_bdlr0_b_rig;
		}
	   printf("\ntest B channel AC result\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);

	printf("\n ac_acmdlr_org  0x%08x reg== 0x%08x   lcdlr_lef   lcdlr_rig   lcdlr_lmin  lcdlr_rmin\n",(reg_add),ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org,ac_lcdlr_b_lef,ac_lcdlr_b_rig,ac_lcdlr_b_lef_min,ac_lcdlr_b_rig_min);
	printf("\n ac_bdlr0_a_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org,ac_bdlr0_b_lef,ac_bdlr0_b_rig,ac_bdlr0_b_lef_min,ac_bdlr0_b_rig_min);



}



	   }


}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}




U_BOOT_CMD(
	ddr_tune_ddr_ac_aclcdlr,	5,	1,	do_ddr_test_ac_windows_aclcdlr,
	"DDR tune dqs function",
	"ddr_tune_ddr_ac_aclcdlr a 0 0x8000000 3 or ddr_tune_ddr_ac_aclcdlr b 0 0x80000 5 or ddr_tune_ddr_ac_aclcdlr a b 0x80000 l\n dcache off ? \n"
);


int do_ddr_test_ac_windows_acbdlr_ck(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr ac windows function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 //  unsigned int   loop = 1;
//   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;



	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

		   unsigned int  ac_mdlr_a_org=0;
	   unsigned int  ac_mdlr_b_org=0;

	  unsigned int  ac_lcdlr_a_org=0;
	  unsigned int   ac_bdlr0_a_org=0;
	  unsigned int  ac_lcdlr_b_org=0;
	  unsigned int   ac_bdlr0_b_org=0;
	  unsigned int  ac_lcdlr_a_rig=0;
	  unsigned int   ac_bdlr0_a_rig=0;
	  unsigned int  ac_lcdlr_b_rig=0;
	  unsigned int   ac_bdlr0_b_rig=0;
	  unsigned int  ac_lcdlr_a_lef=0;
	  unsigned int   ac_bdlr0_a_lef=0;
	  unsigned int  ac_lcdlr_b_lef=0;
	  unsigned int   ac_bdlr0_b_lef=0;

		unsigned int  ac_lcdlr_a_rig_min=0;
	  unsigned int   ac_bdlr0_a_rig_min=0;
	  unsigned int  ac_lcdlr_b_rig_min=0;
	  unsigned int   ac_bdlr0_b_rig_min=0;
	  unsigned int  ac_lcdlr_a_lef_min=0;
	  unsigned int   ac_bdlr0_a_lef_min=0;
	  unsigned int  ac_lcdlr_b_lef_min=0;
	  unsigned int   ac_bdlr0_b_lef_min=0;
	 //   unsigned int  ac_lcdlr_temp;
	  unsigned int   ac_bdlr0_temp=0;



	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;


//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}


		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_loop== 0x%08x\n", test_loop);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}


//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
 }

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;


if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel 0x%08x\n",reg_add);
 ac_mdlr_a_org=(unsigned int )(readl((unsigned int )reg_add));//readl(reg_add);//0xc8836000
	   ac_lcdlr_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR)));//readl(reg_add+4);
	ac_bdlr0_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR)));//readl(reg_add+8);

	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);
}
if (reg_base_adj == CHANNEL_B_REG_BASE)
{

  ac_mdlr_b_org=readl(reg_add);
	   ac_lcdlr_b_org=readl(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR);
	ac_bdlr0_b_org=readl(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR);
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);
}


}

}

}////save and print org training  value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel AC\n");
}
else
{
printf("\ntest B channel AC\n");
}

{
{
	#ifdef DDR_TEST_ACLCDLR

 reg_add=DDR0_PUB_ACLCDLR+reg_base_adj;

ac_lcdlr_temp=readl(reg_add);

while (ac_lcdlr_temp>0)
{
temp_test_error=0;
ac_lcdlr_temp--;

printf("\nlcdlr test value==0x%08x\n ",ac_lcdlr_temp);
	 writel(ac_lcdlr_temp,(reg_add));
	#ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		ac_lcdlr_temp++;
		break;
		}
}

printf("\nlcdlr left edge detect \n");
printf("\nlcdlr left edge==0x%08x\n ",ac_lcdlr_temp);
if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_lcdlr_a_lef=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_a_org;
}
else
{
ac_lcdlr_b_lef=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_b_org;

}
 writel(ac_lcdlr_temp,(reg_add));

 while (ac_lcdlr_temp<ACLCDLR_MAX)
{
temp_test_error=0;
ac_lcdlr_temp++;
printf("\nlcdlr test value==0x%08x\n ",ac_lcdlr_temp);
	 writel(ac_lcdlr_temp,(reg_add));
	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nlcdlr right edge detect \n");
		ac_lcdlr_temp--;
		break;
		}
}
printf("\nlcdlrright edge detect \n");
printf("\nlcdlr right edge==0x%08x\n ",ac_lcdlr_temp);



if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_lcdlr_a_rig=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_a_org;
}
else
{
ac_lcdlr_b_rig=ac_lcdlr_temp;
ac_lcdlr_temp=ac_lcdlr_b_org;

}
writel(ac_lcdlr_temp,(reg_add));



#endif

{
   reg_add=DDR0_PUB_ACBDLR0+reg_base_adj;

ac_bdlr0_temp=readl(reg_add);
while (ac_bdlr0_temp>0)
{
temp_test_error=0;
ac_bdlr0_temp--;
	printf("\nbdlr0 test value==0x%08x\n ",ac_bdlr0_temp);
	 writel(ac_bdlr0_temp,(reg_add));
		 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nwdqd left edge detect \n");
		ac_bdlr0_temp++;
		break;
		}
}
printf("\nacbdlr0 left edge detect \n");
printf("\nacbdlr0 left edge==0x%08x\n ",ac_bdlr0_temp);

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_bdlr0_a_lef=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_a_org;
}
else
{
ac_bdlr0_b_lef=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_b_org;

}

  writel(ac_bdlr0_temp,(reg_add));

 while (ac_bdlr0_temp<ACBDLR_MAX)
{
temp_test_error=0;
ac_bdlr0_temp++;
printf("\nbdlr0 test value==0x%08x\n ",ac_bdlr0_temp);
	 writel(ac_bdlr0_temp,(reg_add));
	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		//printf("\nacbdlr0 right edge detect \n");
		ac_bdlr0_temp--;
		break;
		}
}
printf("\nacbdlr0 right edge detect \n");
printf("\nacbdlr0 right edge==0x%08x\n ",ac_bdlr0_temp);

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
ac_bdlr0_a_rig=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_a_org;
}
else
{
ac_bdlr0_b_rig=ac_bdlr0_temp;
ac_bdlr0_temp=ac_bdlr0_b_org;

}

  writel(ac_bdlr0_temp,(reg_add));

}
}

}
}

////tune and save training dqs value




////calculate and print  dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }
reg_add=DDR0_PUB_ACMDLR+reg_base_adj;

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
if (test_times)
{
if (ac_lcdlr_a_lef>ac_lcdlr_a_lef_min)
ac_lcdlr_a_lef_min=ac_lcdlr_a_lef;

if (ac_lcdlr_a_rig<ac_lcdlr_a_rig_min)
ac_lcdlr_a_rig_min=ac_lcdlr_a_rig;

if (ac_bdlr0_a_lef>ac_bdlr0_a_lef_min)
ac_bdlr0_a_lef_min=ac_bdlr0_a_lef;

if (ac_bdlr0_a_rig<ac_bdlr0_a_rig_min)
ac_bdlr0_a_rig_min=ac_bdlr0_a_rig;
}
	else
		{
ac_lcdlr_a_lef_min=ac_lcdlr_a_lef;
ac_lcdlr_a_rig_min=ac_lcdlr_a_rig;
ac_bdlr0_a_lef_min=ac_bdlr0_a_lef;
ac_bdlr0_a_rig_min=ac_bdlr0_a_rig;
		}
	   printf("\ntest A channel AC result\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);

printf("\n ac_acmdlr_org  0x%08x reg== 0x%08x   lcdlr_lef   lcdlr_rig   lcdlr_lmin  lcdlr_rmin\n",(reg_add),ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org,ac_lcdlr_a_lef,ac_lcdlr_a_rig,ac_lcdlr_a_lef_min,ac_lcdlr_a_rig_min);
	printf("\n ac_bdlr0_a_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org,ac_bdlr0_a_lef,ac_bdlr0_a_rig,ac_bdlr0_a_lef_min,ac_bdlr0_a_rig_min);



}

if (reg_base_adj == CHANNEL_B_REG_BASE)
{
if (test_times)
{
if (ac_lcdlr_b_lef>ac_lcdlr_b_lef_min)
ac_lcdlr_b_lef_min=ac_lcdlr_b_lef;

if (ac_lcdlr_b_rig<ac_lcdlr_b_rig_min)
ac_lcdlr_b_rig_min=ac_lcdlr_b_rig;

if (ac_bdlr0_b_lef>ac_bdlr0_b_lef_min)
ac_bdlr0_b_lef_min=ac_bdlr0_b_lef;

if (ac_bdlr0_b_rig<ac_bdlr0_b_rig_min)
ac_bdlr0_b_rig_min=ac_bdlr0_b_rig;
}
	else
		{
ac_lcdlr_b_lef_min=ac_lcdlr_b_lef;
ac_lcdlr_b_rig_min=ac_lcdlr_b_rig;
ac_bdlr0_b_lef_min=ac_bdlr0_b_lef;
ac_bdlr0_b_rig_min=ac_bdlr0_b_rig;
		}
	   printf("\ntest B channel AC result\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);

	printf("\n ac_acmdlr_org  0x%08x reg== 0x%08x   lcdlr_lef   lcdlr_rig   lcdlr_lmin  lcdlr_rmin\n",(reg_add),ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org,ac_lcdlr_b_lef,ac_lcdlr_b_rig,ac_lcdlr_b_lef_min,ac_lcdlr_b_rig_min);
	printf("\n ac_bdlr0_a_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org,ac_bdlr0_b_lef,ac_bdlr0_b_rig,ac_bdlr0_b_lef_min,ac_bdlr0_b_rig_min);




}



	   }


}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}




U_BOOT_CMD(
	ddr_tune_ddr_ac_acbdlr_ck,	5,	1,	do_ddr_test_ac_windows_acbdlr_ck,
	"DDR tune dqs function",
	"ddr_tune_ddr_ac_acbdlr_ck a 0 0x8000000 3 or ddr_tune_ddr_ac_acbdlr_ck b 0 0x80000 5 or ddr_tune_ddr_ac_acbdlr_ck a b 0x80000 l\n dcache off ? \n"
);


int do_ddr_test_ac_bit_margin(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
 printf("\nEnterddr_test_ac_window function\n");
		   unsigned int   channel_a_en = 0;
//	   unsigned int   channel_b_en = 0;
  // unsigned int   reg_add=0;
  // unsigned int   reg_base_adj=0;

	  unsigned int   lane_step= 0;
	  unsigned int   reg_value= 0;
	 unsigned int   test_ac_setup_hold= 0;
//int argc2;
//char     *  argv2[30];
//  unsigned int  acbdlr0_9_reg_org[10];
//   unsigned int  acbdlr0_9_reg_setup_max[40];
 //  unsigned int  acbdlr0_9_reg_hold_max[40];
 //     unsigned int  acbdlr0_9_reg_setup_time[40];
  // unsigned int  acbdlr0_9_reg_hold_time[40];

char *endp;

		if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{//channel_b_en = 1;
	}


		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{//channel_b_en = 1;
	}
			}
unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}
	}
//argc2=5;
	//for(i = 1;i<(argc);i++)
		{
		//argv2[i-1]=argv[i];
		}

//argv2[0]=argv[1];
//argv2[1]=argv[2];
//argv2[2]=argv[3];
char str[100];
test_ac_setup_hold=0;
if (channel_a_en)
{

//*(char     *)(argv2[0])="a";
	//	run_command("ddr_test_cmd 11 a 0 0x80000  ",0);
	 printf("\ntest ac window  a\n");
for ((lane_step=4);(lane_step<40);(lane_step++))
{
if (lane_step == 7)
{lane_step=8;
}
if (lane_step == 12)
{lane_step=16;
}
if (lane_step == 14)
{lane_step=16;
}
if (lane_step == 18)
{lane_step=20;
}
if (lane_step == 22)
{lane_step=24;
}
//sprintf(argv2[3],"d%",( lane_step));
//itoa_ddr_test(lane_step,(argv2[3]),10);
//printf("\nargv2[%d]=%s\n",0,argv2[0]);
//	printf("\nargv2[%d]=%s\n",3,argv2[3]);//a 0 0x8000000 0 c
	// reg_value=do_ddr_test_dqs_window_step((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
	sprintf(str,"ddr_test_ac_bit_setup_hold_window  a 0  0x%08x  %d  0x%08x",ddr_test_size,test_ac_setup_hold,( lane_step));
	printf("\nstr=%s\n",str);
	//sprintf(str,"ddr_tune_dqs_step  b 0 0x80000 %d",( lane_step));
	//printf("\nstr=%s\n",str);
	run_command(str,0);

   test_ac_setup_hold=2;
		sprintf(str,"ddr_test_ac_bit_setup_hold_window  a 0  0x%08x  %d  0x%08x",ddr_test_size,test_ac_setup_hold,( lane_step));
	printf("\nstr=%s\n",str);
	//sprintf(str,"ddr_tune_dqs_step  b 0 0x80000 %d",( lane_step));
	//printf("\nstr=%s\n",str);
	run_command(str,0);
	  test_ac_setup_hold=0;

}
}





if (channel_a_en)
{
			for ((lane_step=0);(lane_step<10);(lane_step++))
				{
			printf("acbdlr0_9_reg_org[%d]0x%08x==0x%08x\n",	lane_step,(DDR0_PUB_ACBDLR0+(lane_step<<2)),acbdlr0_9_reg_org[lane_step]);

				};

for ((lane_step=0);(lane_step<40);(lane_step++))
{
printf("\n a_ac_lane_0x%08x|setup_max 0x%08x  |hold_max 0x%08x |setup_time %08d ps ::|hold_time %08d ps  \n",
lane_step,
acbdlr0_9_reg_setup_max[lane_step],
acbdlr0_9_reg_hold_max[lane_step],
acbdlr0_9_reg_setup_time[lane_step],
acbdlr0_9_reg_hold_time[lane_step]);

}}



return reg_value;
}

int do_ddr_test_data_bit_margin(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
 printf("\nEnterddr_test_data_window function\n");
		   unsigned int   channel_a_en = 0;
//	   unsigned int   channel_b_en = 0;
  // unsigned int   reg_add=0;
  // unsigned int   reg_base_adj=0;

	  unsigned int   lane_step= 0;
	  unsigned int   reg_value= 0;
	 unsigned int   test_ac_setup_hold= 0;
//int argc2;
//char     *  argv2[30];
//  unsigned int  acbdlr0_9_reg_org[10];
//   unsigned int  acbdlr0_9_reg_setup_max[40];
 //  unsigned int  acbdlr0_9_reg_hold_max[40];
 //     unsigned int  acbdlr0_9_reg_setup_time[40];
  // unsigned int  acbdlr0_9_reg_hold_time[40];

char *endp;

		if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{//channel_b_en = 1;
	}


		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{//channel_b_en = 1;
	}
			}
unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}
	}
  unsigned int   ddr_test_type=0;
  unsigned int   ddr_test_type_para1=0;
  unsigned int   ddr_test_type_para2=0;
    if (argc >4) {
	ddr_test_type = simple_strtoul(argv[4], &endp, 0);
        if (*argv[4] == 0 || *endp != 0)
			{
			ddr_test_type = 0;
			}
	}
	if (ddr_test_type) {
	    if (argc >5) {
	ddr_test_type_para1 = simple_strtoul(argv[5], &endp, 0);
        if (*argv[5] == 0 || *endp != 0)
			{
			ddr_test_type_para1 = 0;
			}
	}
		    if (argc >6) {
	ddr_test_type_para2 = simple_strtoul(argv[6], &endp, 0);
        if (*argv[6] == 0 || *endp != 0)
			{
			ddr_test_type_para2 = 96;
			}
	}
		}else
			{ ddr_test_type_para1 = 0;
		        ddr_test_type_para2 = 96;
			}
//argc2=5;
	//for(i = 1;i<(argc);i++)
		{
		//argv2[i-1]=argv[i];
		}

//argv2[0]=argv[1];
//argv2[1]=argv[2];
//argv2[2]=argv[3];
	 printf("\ntest data window ddr_test_type==0x%08x, ddr_test_type_para1==0x%08x,ddr_test_type_para2==0x%08x\n",
	 ddr_test_type,ddr_test_type_para1,ddr_test_type_para2);
char str[100];
unsigned int   temp_count=0;
test_ac_setup_hold=0;
if (channel_a_en)
{
			for ((temp_count=0);(temp_count<28);(temp_count++))
				{
//data_bdlr0_5_reg_org[temp_count]=(((readl(((temp_count>>2)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/6)+reg_base_adj))
//	>>(8*(test_bdl%4)))&0xff);
data_bdlr0_5_reg_org[temp_count]=((readl(((temp_count%7)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/7)))
	);
				};

//*(char     *)(argv2[0])="a";
	//	run_command("ddr_test_cmd 11 a 0 0x80000  ",0);
	 printf("\ntest data window  a\n");
for ((lane_step=ddr_test_type_para1);(lane_step<ddr_test_type_para2);(lane_step++))
{
if (lane_step == 9)
{lane_step=12;
}
if (lane_step == 21)
{lane_step=24;
}
if (lane_step == 33)
{lane_step=36;
}
if (lane_step == 45)
{lane_step=48;
}
if (lane_step == 33+24)
{lane_step=36+24;
}
if (lane_step == 45+24)
{lane_step=48+24;
}
if (lane_step == 33+48)
{lane_step=36+48;
}
if (lane_step == 44+48)
{lane_step=48+48;
}

//sprintf(argv2[3],"d%",( lane_step));
//itoa_ddr_test(lane_step,(argv2[3]),10);
//printf("\nargv2[%d]=%s\n",0,argv2[0]);
//	printf("\nargv2[%d]=%s\n",3,argv2[3]);//a 0 0x8000000 0 c
	// reg_value=do_ddr_test_dqs_window_step((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
	sprintf(str,"ddr_test_data_bit_setup_hold_window  a 0  0x%08x  %d  0x%08x",ddr_test_size,test_ac_setup_hold,( lane_step));
	printf("\nstr=%s\n",str);
	//sprintf(str,"ddr_tune_dqs_step  b 0 0x80000 %d",( lane_step));
	//printf("\nstr=%s\n",str);
	run_command(str,0);

   test_ac_setup_hold=1;
		sprintf(str,"ddr_test_data_bit_setup_hold_window  a 0  0x%08x  %d  0x%08x",ddr_test_size,test_ac_setup_hold,( lane_step));
	printf("\nstr=%s\n",str);
	//sprintf(str,"ddr_tune_dqs_step  b 0 0x80000 %d",( lane_step));
	//printf("\nstr=%s\n",str);
	run_command(str,0);
	  test_ac_setup_hold=0;
			for ((temp_count=0);(temp_count<28);(temp_count++))
				{
				 writel(((data_bdlr0_5_reg_org[temp_count])),
					(((temp_count%7)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(temp_count/7)));

				};


}
}





if (channel_a_en)
{
			for ((lane_step=0);(lane_step<28);(lane_step++))
				{
			printf("data_bdlr0_5_reg_org[%d]0x%08x==0x%08x\n",	lane_step,
				(((lane_step%7)<<2)+DDR0_PUB_DX0BDLR0+(DDR0_PUB_DX1BDLR0-DDR0_PUB_DX0BDLR0)*(lane_step/7)),
				data_bdlr0_5_reg_org[lane_step]);

				};

for ((lane_step=0);(lane_step<96);(lane_step++))
{
printf("\n a_ac_lane_0x%08x|setup_max 0x%08x  |hold_max 0x%08x |setup_time %08d ps ::|hold_time %08d ps  \n",
lane_step,
bdlr0_9_reg_setup_max[lane_step],
bdlr0_9_reg_hold_max[lane_step],
bdlr0_9_reg_setup_time[lane_step],
bdlr0_9_reg_hold_time[lane_step]);

}}



return reg_value;
}

//#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_BABY)
int do_ddr_gx_crosstalk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
///*
	unsigned int  des[8] ;
 unsigned int  pattern_1[4][8] ;
 unsigned int  pattern_2[4][8] ;
 unsigned int  pattern_3[4][8] ;
 unsigned int  pattern_4[4][8] ;
 unsigned int  pattern_5[4][8] ;
  unsigned int  pattern_6[4][8] ;


  des[0] = 	0xaec83f49;
   des[1] =      0xd243a62c;
   des[2] =      0xf8774a0b;
  des[3] =       0x63d214e5;
   des[4] =      0x3f4166d5;
	des[5] =     0x239672c0;
   des[6] =      0x47ba7533;
   des[7] =      0xcae4cd7f;
	pattern_1[0][0] = 0xff00ff00;
	pattern_1[0][1] = 0xff00ff00;
	pattern_1[0][2] = 0xff00ff00;
	pattern_1[0][3] = 0xff00ff00;
	pattern_1[0][4] = 0xff00ff00;
	pattern_1[0][5] = 0xff00ff00;
	pattern_1[0][6] = 0xff00ff00;
	pattern_1[0][7] = 0xff00ff00;

	pattern_1[1][0] = 0x00ffff00;
	pattern_1[1][1] = 0x00ffff00;
	pattern_1[1][2] = 0x00ffff00;
	pattern_1[1][3] = 0x00ffff00;
	pattern_1[1][4] = 0x00ffff00;
	pattern_1[1][5] = 0x00ffff00;
	pattern_1[1][6] = 0x00ffff00;
	pattern_1[1][7] = 0x00ffff00;

	pattern_1[2][0] = 0xffff0000;
	pattern_1[2][1] = 0xffff0000;
	pattern_1[2][2] = 0xffff0000;
	pattern_1[2][3] = 0xffff0000;
	pattern_1[2][4] = 0xffff0000;
	pattern_1[2][5] = 0xffff0000;
	pattern_1[2][6] = 0xffff0000;
	pattern_1[2][7] = 0xffff0000;

	pattern_1[3][0] = 0xff00ff00;
	pattern_1[3][1] = 0xff00ff00;
	pattern_1[3][2] = 0xff00ff00;
	pattern_1[3][3] = 0xff00ff00;
	pattern_1[3][4] = 0xff00ff00;
	pattern_1[3][5] = 0xff00ff00;
	pattern_1[3][6] = 0xff00ff00;
	pattern_1[3][7] = 0xff00ff00;

	pattern_2[0][0] = 0x0001fe00;
	pattern_2[0][1] = 0x0000ff00;
	pattern_2[0][2] = 0x0000ff00;
	pattern_2[0][3] = 0x0000ff00;
	pattern_2[0][4] = 0x0002fd00;
	pattern_2[0][5] = 0x0000ff00;
	pattern_2[0][6] = 0x0000ff00;
	pattern_2[0][7] = 0x0000ff00;

	pattern_2[1][0] = 0x0004fb00;
	pattern_2[1][1] = 0x0000ff00;
	pattern_2[1][2] = 0x0000ff00;
	pattern_2[1][3] = 0x0000ff00;
	pattern_2[1][4] = 0x0008f700;
	pattern_2[1][5] = 0x0000ff00;
	pattern_2[1][6] = 0x0000ff00;
	pattern_2[1][7] = 0x0000ff00;

	pattern_2[2][0] = 0x0010ef00;
	pattern_2[2][1] = 0x0000ff00;
	pattern_2[2][2] = 0x0000ff00;
	pattern_2[2][3] = 0x0000ff00;
	pattern_2[2][4] = 0x0020df00;
	pattern_2[2][5] = 0x0000ff00;
	pattern_2[2][6] = 0x0000ff00;
	pattern_2[2][7] = 0x0000ff00;

	pattern_2[3][0] = 0x0040bf00;
	pattern_2[3][1] = 0x0000ff00;
	pattern_2[3][2] = 0x0000ff00;
	pattern_2[3][3] = 0x0000ff00;
	pattern_2[3][4] = 0x00807f00;
	pattern_2[3][5] = 0x0000ff00;
	pattern_2[3][6] = 0x0000ff00;
	pattern_2[3][7] = 0x0000ff00;

	pattern_3[0][0] = 0x00010000;
	pattern_3[0][1] = 0x00000000;
	pattern_3[0][2] = 0x00000000;
	pattern_3[0][3] = 0x00000000;
	pattern_3[0][4] = 0x00020000;
	pattern_3[0][5] = 0x00000000;
	pattern_3[0][6] = 0x00000000;
	pattern_3[0][7] = 0x00000000;

	pattern_3[1][0] = 0x00040000;
	pattern_3[1][1] = 0x00000000;
	pattern_3[1][2] = 0x00000000;
	pattern_3[1][3] = 0x00000000;
	pattern_3[1][4] = 0x00080000;
	pattern_3[1][5] = 0x00000000;
	pattern_3[1][6] = 0x00000000;
	pattern_3[1][7] = 0x00000000;

	pattern_3[2][0] = 0x00100000;
	pattern_3[2][1] = 0x00000000;
	pattern_3[2][2] = 0x00000000;
	pattern_3[2][3] = 0x00000000;
	pattern_3[2][4] = 0x00200000;
	pattern_3[2][5] = 0x00000000;
	pattern_3[2][6] = 0x00000000;
	pattern_3[2][7] = 0x00000000;

	pattern_3[3][0] = 0x00400000;
	pattern_3[3][1] = 0x00000000;
	pattern_3[3][2] = 0x00000000;
	pattern_3[3][3] = 0x00000000;
	pattern_3[3][4] = 0x00800000;
	pattern_3[3][5] = 0x00000000;
	pattern_3[3][6] = 0x00000000;
	pattern_3[3][7] = 0x00000000;

///*
pattern_4[0][0] =	0x51c8c049	;
pattern_4[0][1] =	0x2d43592c	;
pattern_4[0][2] =	0x0777b50b	;
pattern_4[0][3] =	0x9cd2ebe5	;
pattern_4[0][4] =	0xc04199d5	;
pattern_4[0][5] =	0xdc968dc0	;
pattern_4[0][6] =	0xb8ba8a33	;
pattern_4[0][7] =	0x35e4327f	;

pattern_4[1][0] =	0xae37c049	;
pattern_4[1][1] =	0xd2bc592c	;
pattern_4[1][2] =	0xf888b50b	;
pattern_4[1][3] =	0x632debe5	;
pattern_4[1][4] =	0x3fbe99d5	;
pattern_4[1][5] =	0x23698dc0	;
pattern_4[1][6] =	0x47458a33	;
pattern_4[1][7] =	0xca1b327f	;

pattern_4[2][0] =	0x51373f49	;
pattern_4[2][1] =	0x2dbca62c	;
pattern_4[2][2] =	0x07884a0b	;
pattern_4[2][3] =	0x9c2d14e5	;
pattern_4[2][4] =	0xc0be66d5	;
pattern_4[2][5] =	0xdc6972c0	;
pattern_4[2][6] =	0xb8457533	;
pattern_4[2][7] =	0x351bcd7f	;


pattern_4[3][0] =	0x51c8c049	;
pattern_4[3][1] =	0x2d43592c	;
pattern_4[3][2] =	0x0777b50b	;
pattern_4[3][3] =	0x9cd2ebe5	;
pattern_4[3][4] =	0xc04199d5	;
pattern_4[3][5] =	0xdc968dc0	;
pattern_4[3][6] =	0xb8ba8a33	;
pattern_4[3][7] =	0x35e4327f	;

pattern_5[0][0] =	0xaec9c149	;
pattern_5[0][1] =	0xd243592c	;
pattern_5[0][2] =	0xf877b50b	;
pattern_5[0][3] =	0x63d2ebe5	;
pattern_5[0][4] =	0x3f439bd5	;
pattern_5[0][5] =	0x23968dc0	;
pattern_5[0][6] =	0x47ba8a33	;
pattern_5[0][7] =	0xcae4327f	;
pattern_5[1][0] =	0xaeccc449	;
pattern_5[1][1] =	0xd243592c	;
pattern_5[1][2] =	0xf877b50b	;
pattern_5[1][3] =	0x63d2ebe5	;
pattern_5[1][4] =	0x3f4991d5	;
pattern_5[1][5] =	0x23968dc0	;
pattern_5[1][6] =	0x47ba8a33	;
pattern_5[1][7] =	0xcae4327f	;
pattern_5[2][0] =	0xaed8d049	;
pattern_5[2][1] =	0xd243592c	;
pattern_5[2][2] =	0xf877b50b	;
pattern_5[2][3] =	0x63d2ebe5	;
pattern_5[2][4] =	0x3f61b9d5	;
pattern_5[2][5] =	0x23968dc0	;
pattern_5[2][6] =	0x47ba8a33	;
pattern_5[2][7] =	0xcae4327f	;
pattern_5[3][0] =	0xae888049	;
pattern_5[3][1] =	0xd243592c	;
pattern_5[3][2] =	0xf877b50b	;
pattern_5[3][3] =	0x63d2ebe5	;
pattern_5[3][4] =	0x3fc119d5	;
pattern_5[3][5] =	0x23968dc0	;
pattern_5[3][6] =	0x47ba8a33	;
pattern_5[3][7] =	0xcae4327f	;

pattern_6[0][0] =   0xaec93f49   ;
pattern_6[0][1] =	0xd243a62c	;
pattern_6[0][2] =	0xf8774a0b	;
pattern_6[0][3] =	0x63d214e5	;
pattern_6[0][4] =	0x3f4366d5	;
pattern_6[0][5] =	0x239672c0	;
pattern_6[0][6] =	0x47ba7533	;
pattern_6[0][7] =	0xcae4cd7f	;
pattern_6[1][0] =	0xaecc3f49	;
pattern_6[1][1] =	0xd243a62c	;
pattern_6[1][2] =	0xf8774a0b	;
pattern_6[1][3] =	0x63d214e5	;
pattern_6[1][4] =	0x3f4966d5	;
pattern_6[1][5] =	0x239672c0	;
pattern_6[1][6] =	0x47ba7533	;
pattern_6[1][7] =	0xcae4cd7f	;
pattern_6[2][0] =	0xaed83f49	;
pattern_6[2][1] =	0xd243a62c	;
pattern_6[2][2] =	0xf8774a0b	;
pattern_6[2][3] =	0x63d214e5	;
pattern_6[2][4] =	0x3f6166d5	;
pattern_6[2][5] =	0x239672c0	;
pattern_6[2][6] =	0x47ba7533	;
pattern_6[2][7] =	0xcae4cd7f	;
pattern_6[3][0] =	0xae883f49	;
pattern_6[3][1] =	0xd243a62c	;
pattern_6[3][2] =	0xf8774a0b	;
pattern_6[3][3] =	0x63d214e5	;
pattern_6[3][4] =	0x3fc166d5	;
pattern_6[3][5] =	0x239672c0	;
pattern_6[3][6] =	0x47ba7533	;
pattern_6[3][7] =	0xcae4cd7f	;
//*/
//*/

 char *endp;
	 unsigned int   loop = 1;
	 unsigned int   lflag = 0;
	 unsigned int  start_addr = DDR_TEST_START_ADDR;
	      unsigned int  test_size = DDR_TEST_SIZE;
		  unsigned int   test_addr;

		   error_outof_count_flag =0;
		 error_count =0;
		   printf("\nargc== 0x%08x\n", argc);
			int i ;
	for (i = 0;i<argc;i++)
		{
		printf("\nargv[%d]=%s\n",i,argv[i]);
		}
if (argc == 1)
 goto usage;
if (argc>1)
{
    if (strcmp(argv[1], "l") == 0) {
		lflag = 1;
	}

	else{
		loop = simple_strtoul(argv[1], &endp, 10);
        if (*argv[1] == 0 || *endp != 0)
			loop = 1;
	}

		//    printf("\nLINE== 0x%08x\n", __LINE__);
		    if (argc ==1) {
	//    start_addr = simple_strtoul(argv[2], &endp, 16);
	//    if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;
	  loop = 1;

	}
}



    if (argc >= 2) {
		loop = simple_strtoul(argv[1], &endp, 16);
        if (*argv[1] == 0 || *endp != 0)
			loop = 1;

	}
	unsigned int pattern_flag1=1;
	unsigned int pattern_flag2=1;
	unsigned int pattern_flag3=1;
	       pattern_flag1 = 1;
		pattern_flag2=1;
		 pattern_flag3 = 1;


	 if (argc >= 3  ) {
    if ( (strcmp(argv[2], "s") == 0))
		{
		pattern_flag1 = 1;
		pattern_flag2=0;
		 pattern_flag3 = 0;
	}
 else if ((strcmp(argv[2], "c") == 0))
		{
		pattern_flag1 = 0;
		pattern_flag2=1;
		 pattern_flag3 = 0;
	}
else  if ( (strcmp(argv[2], "d") == 0))
	{
		  pattern_flag1 = 0;
		pattern_flag2=0;
		 pattern_flag3 = 1;
	}
	}

	//	if(test_size<0x20)
	start_addr=0x10000000;
			test_size = 0x20;
unsigned int temp_i=0;
unsigned int temp_k=0;
unsigned int pattern_o[8];
unsigned int pattern_d[8];


//DDR_TEST_START:

///*
error_count=0;
	do {
        if (lflag)
			loop = 888;

		//if(old_pattern_flag==1)
			{

		printf("\nStart writing at 0x%08x - 0x%08x...\n", start_addr, start_addr + test_size);

/*
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{

		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
	  flush_dcache_range(start_addr,start_addr + test_size);

	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_5[temp_k][temp_i])
	{error_count++;
							printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
*/
		if (pattern_flag1 == 1) {
		  for ((temp_k=0);(temp_k<4);(temp_k++))
			{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_4[temp_k][temp_i])
	{error_count++;
							printf("p4Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_4[temp_k][temp_i],pattern_1[temp_k][temp_i]);
							}

		}
			}
		}
		  for ((temp_k=0);(temp_k<4);(temp_k++))
		  {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
	if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
							printf("p4 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_4[temp_k][temp_i]),pattern_d[temp_i]);
						}

		}
			}
		}
		  }
		if (pattern_flag2 == 1) {
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_5[temp_k][temp_i])
	{error_count++;
							printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
	  for ((temp_k=0);(temp_k<4);(temp_k++))
{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
		if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
							printf("p5 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_5[temp_k][temp_i]),pattern_d[temp_i]);
						}
	  }
			}
		}

			}

		if (pattern_flag3 == 1) {
	for ((temp_k=0);(temp_k<4);(temp_k++)) {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,3,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_3[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
// printf("\n0x%08x",pattern_6[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_6[temp_k][temp_i])
	{error_count++;
							printf("p6Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_6[temp_k][temp_i],pattern_3[temp_k][temp_i]);
							}
	  }
			}
		}
	 for ((temp_k=0);(temp_k<4);(temp_k++))
	 {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,3,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_3[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
// printf("\n0x%08x",pattern_6[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
		if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
							printf("p6 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_6[temp_k][temp_i]),pattern_d[temp_i]);
						}
	  }
			}
		}
			}



}

		  printf("\Error count==0x%08x", error_count);
		   printf("\n      \n");
	  }while(--loop);
//*/

 printf("\rEnd ddr test.                              \n");

	  return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
			}


U_BOOT_CMD(
	ddrtest_gx_crosstalk,	5,	1,	do_ddr_gx_crosstalk,
	"DDR test function",
	"ddrtest [LOOP] [ADDR].Default address is 0x10000000\n"
);



//#if (CONFIG_DDR_PHY ==  P_DDR_PHY_GX_TV_BABY)
int do_ddr_gxtvbb_crosstalk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
///*
	unsigned int  a_des[8],b_des[8],des[8] ;
 unsigned int  pattern_1[4][8] ;
 unsigned int  pattern_2[4][8] ;
 unsigned int  pattern_3[4][8] ;
// unsigned int  pattern_4[4][8] ;
// unsigned int  pattern_5[4][8] ;
//  unsigned int  pattern_6[4][8] ;


   a_des[0] =      0x7ea09b52;
   a_des[1] =      0xbc57bb23;
   a_des[2] =      0x8d2b6e65;
   a_des[3] =      0x15fdcdc4;
   a_des[4] =      0xbc1df453;
   a_des[5] =      0x21bcbcdf;
   a_des[6] =      0x267b7ac1;
   a_des[7] =      0x6af03d72;


   b_des[0] =      0xdfc2ee12;
   b_des[1] =      0x4f58da43;
   b_des[2] =      0x87809557;
   b_des[3] =      0xb87ddbf4;
   b_des[4] =      0x667fb021;
   b_des[5] =      0x64593586;
   b_des[6] =      0xee73d8d5;
   b_des[7] =      0xe65f972d;
	pattern_1[0][0] = 0xff00ff00;
	pattern_1[0][1] = 0xff00ff00;
	pattern_1[0][2] = 0xff00ff00;
	pattern_1[0][3] = 0xff00ff00;
	pattern_1[0][4] = 0xff00ff00;
	pattern_1[0][5] = 0xff00ff00;
	pattern_1[0][6] = 0xff00ff00;
	pattern_1[0][7] = 0xff00ff00;

	pattern_1[1][0] = 0x00ffff00;
	pattern_1[1][1] = 0x00ffff00;
	pattern_1[1][2] = 0x00ffff00;
	pattern_1[1][3] = 0x00ffff00;
	pattern_1[1][4] = 0x00ffff00;
	pattern_1[1][5] = 0x00ffff00;
	pattern_1[1][6] = 0x00ffff00;
	pattern_1[1][7] = 0x00ffff00;

	pattern_1[2][0] = 0xffff0000;
	pattern_1[2][1] = 0xffff0000;
	pattern_1[2][2] = 0xffff0000;
	pattern_1[2][3] = 0xffff0000;
	pattern_1[2][4] = 0xffff0000;
	pattern_1[2][5] = 0xffff0000;
	pattern_1[2][6] = 0xffff0000;
	pattern_1[2][7] = 0xffff0000;

	pattern_1[3][0] = 0xff00ff00;
	pattern_1[3][1] = 0xff00ff00;
	pattern_1[3][2] = 0xff00ff00;
	pattern_1[3][3] = 0xff00ff00;
	pattern_1[3][4] = 0xff00ff00;
	pattern_1[3][5] = 0xff00ff00;
	pattern_1[3][6] = 0xff00ff00;
	pattern_1[3][7] = 0xff00ff00;

	pattern_2[0][0] = 0x0001fe00;
	pattern_2[0][1] = 0x0000ff00;
	pattern_2[0][2] = 0x0000ff00;
	pattern_2[0][3] = 0x0000ff00;
	pattern_2[0][4] = 0x0002fd00;
	pattern_2[0][5] = 0x0000ff00;
	pattern_2[0][6] = 0x0000ff00;
	pattern_2[0][7] = 0x0000ff00;

	pattern_2[1][0] = 0x0004fb00;
	pattern_2[1][1] = 0x0000ff00;
	pattern_2[1][2] = 0x0000ff00;
	pattern_2[1][3] = 0x0000ff00;
	pattern_2[1][4] = 0x0008f700;
	pattern_2[1][5] = 0x0000ff00;
	pattern_2[1][6] = 0x0000ff00;
	pattern_2[1][7] = 0x0000ff00;

	pattern_2[2][0] = 0x0010ef00;
	pattern_2[2][1] = 0x0000ff00;
	pattern_2[2][2] = 0x0000ff00;
	pattern_2[2][3] = 0x0000ff00;
	pattern_2[2][4] = 0x0020df00;
	pattern_2[2][5] = 0x0000ff00;
	pattern_2[2][6] = 0x0000ff00;
	pattern_2[2][7] = 0x0000ff00;

	pattern_2[3][0] = 0x0040bf00;
	pattern_2[3][1] = 0x0000ff00;
	pattern_2[3][2] = 0x0000ff00;
	pattern_2[3][3] = 0x0000ff00;
	pattern_2[3][4] = 0x00807f00;
	pattern_2[3][5] = 0x0000ff00;
	pattern_2[3][6] = 0x0000ff00;
	pattern_2[3][7] = 0x0000ff00;

	pattern_3[0][0] = 0x00010000;
	pattern_3[0][1] = 0x00000000;
	pattern_3[0][2] = 0x00000000;
	pattern_3[0][3] = 0x00000000;
	pattern_3[0][4] = 0x00020000;
	pattern_3[0][5] = 0x00000000;
	pattern_3[0][6] = 0x00000000;
	pattern_3[0][7] = 0x00000000;

	pattern_3[1][0] = 0x00040000;
	pattern_3[1][1] = 0x00000000;
	pattern_3[1][2] = 0x00000000;
	pattern_3[1][3] = 0x00000000;
	pattern_3[1][4] = 0x00080000;
	pattern_3[1][5] = 0x00000000;
	pattern_3[1][6] = 0x00000000;
	pattern_3[1][7] = 0x00000000;

	pattern_3[2][0] = 0x00100000;
	pattern_3[2][1] = 0x00000000;
	pattern_3[2][2] = 0x00000000;
	pattern_3[2][3] = 0x00000000;
	pattern_3[2][4] = 0x00200000;
	pattern_3[2][5] = 0x00000000;
	pattern_3[2][6] = 0x00000000;
	pattern_3[2][7] = 0x00000000;

	pattern_3[3][0] = 0x00400000;
	pattern_3[3][1] = 0x00000000;
	pattern_3[3][2] = 0x00000000;
	pattern_3[3][3] = 0x00000000;
	pattern_3[3][4] = 0x00800000;
	pattern_3[3][5] = 0x00000000;
	pattern_3[3][6] = 0x00000000;
	pattern_3[3][7] = 0x00000000;

/*
pattern_4[0][0] =	0x51c8c049	;
pattern_4[0][1] =	0x2d43592c	;
pattern_4[0][2] =	0x0777b50b	;
pattern_4[0][3] =	0x9cd2ebe5	;
pattern_4[0][4] =	0xc04199d5	;
pattern_4[0][5] =	0xdc968dc0	;
pattern_4[0][6] =	0xb8ba8a33	;
pattern_4[0][7] =	0x35e4327f	;

pattern_4[1][0] =	0xae37c049	;
pattern_4[1][1] =	0xd2bc592c	;
pattern_4[1][2] =	0xf888b50b	;
pattern_4[1][3] =	0x632debe5	;
pattern_4[1][4] =	0x3fbe99d5	;
pattern_4[1][5] =	0x23698dc0	;
pattern_4[1][6] =	0x47458a33	;
pattern_4[1][7] =	0xca1b327f	;

pattern_4[2][0] =	0x51373f49	;
pattern_4[2][1] =	0x2dbca62c	;
pattern_4[2][2] =	0x07884a0b	;
pattern_4[2][3] =	0x9c2d14e5	;
pattern_4[2][4] =	0xc0be66d5	;
pattern_4[2][5] =	0xdc6972c0	;
pattern_4[2][6] =	0xb8457533	;
pattern_4[2][7] =	0x351bcd7f	;


pattern_4[3][0] =	0x51c8c049	;
pattern_4[3][1] =	0x2d43592c	;
pattern_4[3][2] =	0x0777b50b	;
pattern_4[3][3] =	0x9cd2ebe5	;
pattern_4[3][4] =	0xc04199d5	;
pattern_4[3][5] =	0xdc968dc0	;
pattern_4[3][6] =	0xb8ba8a33	;
pattern_4[3][7] =	0x35e4327f	;

pattern_5[0][0] =	0xaec9c149	;
pattern_5[0][1] =	0xd243592c	;
pattern_5[0][2] =	0xf877b50b	;
pattern_5[0][3] =	0x63d2ebe5	;
pattern_5[0][4] =	0x3f439bd5	;
pattern_5[0][5] =	0x23968dc0	;
pattern_5[0][6] =	0x47ba8a33	;
pattern_5[0][7] =	0xcae4327f	;
pattern_5[1][0] =	0xaeccc449	;
pattern_5[1][1] =	0xd243592c	;
pattern_5[1][2] =	0xf877b50b	;
pattern_5[1][3] =	0x63d2ebe5	;
pattern_5[1][4] =	0x3f4991d5	;
pattern_5[1][5] =	0x23968dc0	;
pattern_5[1][6] =	0x47ba8a33	;
pattern_5[1][7] =	0xcae4327f	;
pattern_5[2][0] =	0xaed8d049	;
pattern_5[2][1] =	0xd243592c	;
pattern_5[2][2] =	0xf877b50b	;
pattern_5[2][3] =	0x63d2ebe5	;
pattern_5[2][4] =	0x3f61b9d5	;
pattern_5[2][5] =	0x23968dc0	;
pattern_5[2][6] =	0x47ba8a33	;
pattern_5[2][7] =	0xcae4327f	;
pattern_5[3][0] =	0xae888049	;
pattern_5[3][1] =	0xd243592c	;
pattern_5[3][2] =	0xf877b50b	;
pattern_5[3][3] =	0x63d2ebe5	;
pattern_5[3][4] =	0x3fc119d5	;
pattern_5[3][5] =	0x23968dc0	;
pattern_5[3][6] =	0x47ba8a33	;
pattern_5[3][7] =	0xcae4327f	;

pattern_6[0][0] =   0xaec93f49   ;
pattern_6[0][1] =	0xd243a62c	;
pattern_6[0][2] =	0xf8774a0b	;
pattern_6[0][3] =	0x63d214e5	;
pattern_6[0][4] =	0x3f4366d5	;
pattern_6[0][5] =	0x239672c0	;
pattern_6[0][6] =	0x47ba7533	;
pattern_6[0][7] =	0xcae4cd7f	;
pattern_6[1][0] =	0xaecc3f49	;
pattern_6[1][1] =	0xd243a62c	;
pattern_6[1][2] =	0xf8774a0b	;
pattern_6[1][3] =	0x63d214e5	;
pattern_6[1][4] =	0x3f4966d5	;
pattern_6[1][5] =	0x239672c0	;
pattern_6[1][6] =	0x47ba7533	;
pattern_6[1][7] =	0xcae4cd7f	;
pattern_6[2][0] =	0xaed83f49	;
pattern_6[2][1] =	0xd243a62c	;
pattern_6[2][2] =	0xf8774a0b	;
pattern_6[2][3] =	0x63d214e5	;
pattern_6[2][4] =	0x3f6166d5	;
pattern_6[2][5] =	0x239672c0	;
pattern_6[2][6] =	0x47ba7533	;
pattern_6[2][7] =	0xcae4cd7f	;
pattern_6[3][0] =	0xae883f49	;
pattern_6[3][1] =	0xd243a62c	;
pattern_6[3][2] =	0xf8774a0b	;
pattern_6[3][3] =	0x63d214e5	;
pattern_6[3][4] =	0x3fc166d5	;
pattern_6[3][5] =	0x239672c0	;
pattern_6[3][6] =	0x47ba7533	;
pattern_6[3][7] =	0xcae4cd7f	;
*/
//*/

 char *endp;
	 unsigned int   loop = 1;
	 unsigned int   lflag = 0;
	 unsigned int  start_addr = DDR_TEST_START_ADDR;
	      unsigned int  test_size = DDR_TEST_SIZE;
		  unsigned int   test_addr;

		   error_outof_count_flag =0;
		 error_count =0;

		   printf("\nargc== 0x%08x\n", argc);
			int i ;
	for (i = 0;i<argc;i++)
		{
		printf("\nargv[%d]=%s\n",i,argv[i]);
		}
if (argc == 1)
 goto usage;
if (argc>1)
{
    if (strcmp(argv[1], "l") == 0) {
		lflag = 1;
	}

	else{
		loop = simple_strtoul(argv[1], &endp, 10);
        if (*argv[1] == 0 || *endp != 0)
			loop = 1;
	}

		//    printf("\nLINE== 0x%08x\n", __LINE__);
		    if (argc ==1) {
	//    start_addr = simple_strtoul(argv[2], &endp, 16);
	//    if (*argv[2] == 0 || *endp != 0)
			start_addr = DDR_TEST_START_ADDR;
	  loop = 1;

	}
}



    if (argc >= 2) {
		loop = simple_strtoul(argv[1], &endp, 16);
        if (*argv[1] == 0 || *endp != 0)
			loop = 1;

	}
	unsigned int pattern_flag1=1;
	unsigned int pattern_flag2=1;
	unsigned int pattern_flag3=1;
	       pattern_flag1 = 1;
		pattern_flag2=1;
		 pattern_flag3 = 1;


	 if (argc >= 3  ) {
    if ( (strcmp(argv[2], "s") == 0))
		{
		pattern_flag1 = 1;
		pattern_flag2=0;
		 pattern_flag3 = 0;
	}
 else if ((strcmp(argv[2], "c") == 0))
		{
		pattern_flag1 = 0;
		pattern_flag2=1;
		 pattern_flag3 = 0;
	}
else  if ( (strcmp(argv[2], "d") == 0))
	{
		  pattern_flag1 = 0;
		pattern_flag2=0;
		 pattern_flag3 = 1;
	}
	}

	//	if(test_size<0x20)
	start_addr=0x10000000;
			test_size = 0x20;
unsigned int temp_i=0;
unsigned int temp_k=0;
unsigned int pattern_o[8];
unsigned int pattern_d[8];
//unsigned int i=0;

 printf("\nloop should >2 and now loop== 0x%08x\n", loop);
//DDR_TEST_START:

///*

error_count=0;
	do {
        if (lflag)
			loop = 888;
if (loop%2)
{
		start_addr=0x10000000;
			test_size = 0x20;
			for ((i=0);(i<8);(i++))
				{
			des[i]=  a_des[i];
				}
}
else
{
		start_addr=0x10000400;
			test_size = 0x20;
				for ((i=0);(i<8);(i++))
				{
			des[i]=  b_des[i];
				}
}
		//if(old_pattern_flag==1)
			{

		printf("\nStart writing at 0x%08x - 0x%08x...\n", start_addr, start_addr + test_size);

/*
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{

		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
	  flush_dcache_range(start_addr,start_addr + test_size);

	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	if (pattern_o[temp_i] != pattern_5[temp_k][temp_i])
	{error_count++;
							printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
*/
		if (pattern_flag1 == 1) {
		  for ((temp_k=0);(temp_k<4);(temp_k++))
			{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
#ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
  #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
//	if(pattern_o[temp_i]!=pattern_4[temp_k][temp_i])
if ((pattern_o[temp_i]) != (des_pattern(temp_i,1,temp_k,temp_i)))
	{error_count++;
			//                printf("p4Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_4[temp_k][temp_i],pattern_1[temp_k][temp_i]);
					  printf("p4Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), des_pattern(temp_i,1,temp_k,temp_i),pattern_1[temp_k][temp_i]);
							}

		}
			}
		}
		  for ((temp_k=0);(temp_k<4);(temp_k++))
		  {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,1,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_1[temp_k][temp_i]);
		//  printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
	//	  printf("\n0x%08x",pattern_4[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
	if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
	   //                     printf("p4 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_4[temp_k][temp_i]),pattern_d[temp_i]);
							 printf("p4 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(des_pattern(temp_i,1,temp_k,temp_i)),pattern_d[temp_i]);
						}

		}
			}
		}
		  }
		if (pattern_flag2 == 1) {
	 for ((temp_k=0);(temp_k<4);(temp_k++)) {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
 //	if(pattern_o[temp_i]!=pattern_5[temp_k][temp_i])
		if ((pattern_o[temp_i]) != (des_pattern(temp_i,2,temp_k,temp_i)))
	{error_count++;
				 //           printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_5[temp_k][temp_i],pattern_2[temp_k][temp_i]);
						   printf("p5Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), des_pattern(temp_i,2,temp_k,temp_i),pattern_2[temp_k][temp_i]);
							}
	  }
			}
		}
	  for ((temp_k=0);(temp_k<4);(temp_k++))
{
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,2,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_2[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
 //printf("\n0x%08x",pattern_5[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
		if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
				  //          printf("p5 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_5[temp_k][temp_i]),pattern_d[temp_i]);
					printf("p5 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(des_inv_pattern(temp_i,2,temp_k,temp_i)),pattern_d[temp_i]);
								}
	  }
			}
		}

			}

		if (pattern_flag3 == 1) {
	for ((temp_k=0);(temp_k<4);(temp_k++)) {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_pattern(temp_i,3,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_3[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
// printf("\n0x%08x",pattern_6[temp_k][temp_i]);
	//if(pattern_o[temp_i]!=pattern_6[temp_k][temp_i])
		if ((pattern_o[temp_i]) != (des_pattern(temp_i,3,temp_k,temp_i)))
	{error_count++;
					 //       printf("p6Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), pattern_6[temp_k][temp_i],pattern_3[temp_k][temp_i]);
							 printf("p6Error data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), des_pattern(temp_i,3,temp_k,temp_i),pattern_3[temp_k][temp_i]);
							}
	  }
			}
		}
	 for ((temp_k=0);(temp_k<4);(temp_k++))
	 {
{
ddr_udelay(10000);
		  for ((temp_i=0);(temp_i<8);(temp_i++))
			{
		test_addr=start_addr+(temp_i<<2);
		*(volatile uint32_t *)(int_convter_p(test_addr))=des_inv_pattern(temp_i,3,temp_k,temp_i);//des[temp_i]^pattern_2[temp_k][temp_i];
	//	#define des_pattern(a,b,c,d)  des[a]^pattern_##b[c][d]
//des[temp_i]^pattern_2[temp_k][temp_i]
		}
   //   _clean_dcache_addr(0x10000000);
   #ifdef DDR_PREFETCH_CACHE
	  flush_dcache_range(start_addr,start_addr + test_size);
   #endif
	  for ((temp_i=0);(temp_i<8);(temp_i++)) {
		test_addr=start_addr+(temp_i<<2);
		pattern_o[temp_i]=*(volatile uint32_t *)(int_convter_p(test_addr));
	//	 printf("\n test_addr pattern_o pattern_d  0x%08x - 0x%08x - 0x%08x", test_addr,pattern_o[temp_i], pattern_3[temp_k][temp_i]);
 //printf("\n0x%08x",(pattern_o[temp_i])^(des[temp_i]));
// printf("\n0x%08x",pattern_6[temp_k][temp_i]);
	pattern_d[temp_i]=des_xor_pattern((des[temp_i]),(pattern_o[temp_i]));
		if ((des_xor_pattern((des[temp_i]),(pattern_o[temp_i]))) != pattern_d[temp_i])
	{error_count++;
					 //       printf("p6 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(pattern_6[temp_k][temp_i]),pattern_d[temp_i]);
						 printf("p6 invError data [0x%08x] at offset 0x%08x[0x%08x]-D0x%08x\n",pattern_o[temp_i], p_convter_int(test_addr), ~(des_inv_pattern(temp_i,3,temp_k,temp_i)),pattern_d[temp_i]);
							}
	  }
			}
		}
			}



}

		  printf("\Error count==0x%08x", error_count);
		   printf("\n      \n");
	  }while(--loop);
//*/

 printf("\rEnd ddr test.                              \n");

	  return 0;

usage:
	cmd_usage(cmdtp);
	return 1;
			}


U_BOOT_CMD(
	ddrtest_gxtvbb_crosstalk,	5,	1,	do_ddr_gxtvbb_crosstalk,
	"DDR test function",
	"ddrtest [LOOP] [ADDR].Default address is 0x10000000\n"
);

int do_ddrtest_find_gate_wind(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Tune ddr dqs function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 //  unsigned int   loop = 1;
   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;


	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;

	// /*
	// #define  DATX8_DQ_LCD_BDL_REG_WIDTH  12

	 #define  DATX8_DQ_LANE_WIDTH  4
	 #define  CHANNEL_CHANNEL_WIDTH  2

	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1



	#define  DATX8_DQ_LANE_LANE00  0
	#define  DATX8_DQ_LANE_LANE01  1
	#define  DATX8_DQ_LANE_LANE02  2
	#define  DATX8_DQ_LANE_LANE03  3

	 #define  DATX8_DQ_BDLR0  0
	 #define  DATX8_DQ_BDLR1  1
	 #define  DATX8_DQ_BDLR2  2
	 #define  DATX8_DQ_BDLR3  3
	 #define  DATX8_DQ_BDLR4  4
	 #define  DATX8_DQ_BDLR5  5
	 #define  DATX8_DQ_BDLR6  6
	 #define  DATX8_DQ_DXNLCDLR0     7
	 #define  DATX8_DQ_DXNLCDLR1     8
	 #define  DATX8_DQ_DXNLCDLR2     9
	 #define  DATX8_DQ_DXNMDLR        10
	 #define  DATX8_DQ_DXNGTR          11


	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

	// #define  DQ_LCD_BDL_REG_NUM_PER_CHANNEL  5//DATX8_DQ_LCD_BDL_REG_WIDTH*DATX8_DQ_LANE_WIDTH
	//    #define  DQ_LCD_BDL_REG_NUM    DQ_LCD_BDL_REG_NUM_PER_CHANNEL*CHANNEL_CHANNEL_WIDTH
//*/


	//  unsigned int   dq_lcd_bdl_reg_org[DQ_LCD_BDL_REG_NUM];
	//  unsigned int   dq_lcd_bdl_reg_left[DQ_LCD_BDL_REG_NUM];
	//  unsigned int   dq_lcd_bdl_reg_right[DQ_LCD_BDL_REG_NUM];
	 //  unsigned int   dq_lcd_bdl_reg_index[DQ_LCD_BDL_REG_NUM];

	//  unsigned int   dq_lcd_bdl_reg_left_min[DQ_LCD_BDL_REG_NUM];
	//  unsigned int   dq_lcd_bdl_reg_right_min[DQ_LCD_BDL_REG_NUM];

	   unsigned int   dq_lcd_bdl_temp_reg_value;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_min;
	//  unsigned int   dq_lcd_bdl_temp_reg_value_max;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_rdqsd;
	  //  unsigned int   dq_lcd_bdl_temp_reg_value_rdqsnd;
	//   unsigned int   dq_lcd_bdl_temp_reg_lef_min_value;
	//     unsigned int   dq_lcd_bdl_temp_reg_rig_min_value;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_dqs;
	//  unsigned int   dq_lcd_bdl_temp_reg_value_wdqd;
	//   unsigned int   dq_lcd_bdl_temp_reg_value_rdqsd;

	//   unsigned int   dq_lcd_bdl_temp_reg_lef;
	//   unsigned int   dq_lcd_bdl_temp_reg_rig;
	//    unsigned int   dq_lcd_bdl_temp_reg_center;
	//    unsigned int   dq_lcd_bdl_temp_reg_windows;
	//      unsigned int   dq_lcd_bdl_temp_reg_center_min;
	//    unsigned int   dq_lcd_bdl_temp_reg_windows_min;

		 unsigned int   dqgtr_org[4],dqlcdlr2_org[4],dqgtr_l[4],dqlcdlr2_l[4],dqgtr_r[4],dqlcdlr2_r[4],dqmdlr[4];
	 unsigned int dqgtr_temp;
	  unsigned int dqlcdlr2_temp;
	  unsigned int dqqsgate_org[4],dqqsgate_l[4], dqqsgate_r[4];
	    unsigned int   ddr_gate_up_down=0;
		 unsigned int   ddr_gate_init_lane=0;

	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;



	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}


		     if (argc >5) {
	ddr_gate_up_down = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			ddr_gate_up_down = 0;
			}
		 if   ((strcmp(argv[5], "l") == 0) || (strcmp(argv[5], "L") == 0))
			{
			ddr_gate_up_down = 00000;
			}
	}
						if (argc >6) {
	ddr_gate_init_lane = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			{
			ddr_gate_init_lane = 0;
			}
		 if   ((strcmp(argv[6], "l") == 0) || (strcmp(argv[6], "L") == 0))
			{
			ddr_gate_init_lane = 00000;
			}
	}


		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_loop== 0x%08x\n", test_loop);
		   printf("\nddr_gate_up_down== 0x%08x\n", ddr_gate_up_down);
		   printf("\nddr_gate_init_lane== 0x%08x\n", ddr_gate_init_lane);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}


//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
   {

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0LCDLR0+reg_base_adj;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1LCDLR0+reg_base_adj;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2LCDLR0+reg_base_adj;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3LCDLR0+reg_base_adj;}





	}

}

}

}////save and print org training dqs value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
   { printf("\ntest lane==0x%08x\n ",temp_count_i);
          if (ddr_gate_init_lane)
		{
		temp_count_i=ddr_gate_init_lane;
		printf("\ntest lane change==0x%08x\n ",temp_count_i);
		}


   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0LCDLR0+reg_base_adj;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1LCDLR0+reg_base_adj;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2LCDLR0+reg_base_adj;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3LCDLR0+reg_base_adj;}
}

 // for((temp_count_k=0);(temp_count_k<2);(temp_count_k++))
	   {

//if(temp_count_k==0)
{
  dqlcdlr2_org[temp_count_i]=readl(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0);
	   dqgtr_org[temp_count_i]=readl(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0);
	   dqmdlr[temp_count_i]=readl(reg_add+DDR0_PUB_ACMDLR-DDR0_PUB_DX0LCDLR0);
	   dq_lcd_bdl_temp_reg_value=(((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2*((dqgtr_org[temp_count_i])&(DXNGTR_MAX))+(((dqlcdlr2_org[temp_count_i]))&ACLCDLR_MAX);
dqqsgate_org[temp_count_i]=dq_lcd_bdl_temp_reg_value;

printf("\ngate org==0x%08x  0x%08x   0x%08x 0x%08x\n ",dqqsgate_org[temp_count_i],dqgtr_org[temp_count_i],dqlcdlr2_org[temp_count_i], dqmdlr[temp_count_i]);

if (ddr_gate_up_down == 0)
{
while (dq_lcd_bdl_temp_reg_value>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value--;
printf("\ngate left temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value);
dqgtr_temp=dq_lcd_bdl_temp_reg_value/((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);
dqlcdlr2_temp=dq_lcd_bdl_temp_reg_value-dqgtr_temp*((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);

	   writel((dqlcdlr2_temp),(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0));
	 writel((((readl((reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0)))&0xfffff000)|(dqgtr_temp)),(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0));
	 printf("\n (reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0) 0x%08x gtr==0x%08x\n ",(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0),(readl((reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0))));
	 printf("\nlcdlr2==0x%08x\n ",readl(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0));
	 printf("\ndqgtr_temp==0x%08x\n ",dqgtr_temp);
	 printf("\ngatedqlcdlr2_temp==0x%08x\n ",dqlcdlr2_temp);
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		printf("\ngateleft edge detect \n");
		dq_lcd_bdl_temp_reg_value++;
		break;
		}
}
printf("\ngate left edge detect \n");
printf("\ngate left edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value);
//dq_lcd_bdl_temp_reg_value_min=dq_lcd_bdl_temp_reg_value;
dqqsgate_l[temp_count_i]=dq_lcd_bdl_temp_reg_value;
	   writel(dqlcdlr2_org[temp_count_i],(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0));
	 writel( dqgtr_org[temp_count_i],(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0));

 dq_lcd_bdl_temp_reg_value=(((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2*((dqgtr_org[temp_count_i])&DXNGTR_MAX)+(((dqlcdlr2_org[temp_count_i]))&ACLCDLR_MAX);
}
while (dq_lcd_bdl_temp_reg_value>0)
{
temp_test_error=0;
dq_lcd_bdl_temp_reg_value++;
printf("\ngate rig temp==0x%08x\n ",dq_lcd_bdl_temp_reg_value);
dqgtr_temp=dq_lcd_bdl_temp_reg_value/((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);
dqlcdlr2_temp=dq_lcd_bdl_temp_reg_value-dqgtr_temp*((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);

	   writel((dqlcdlr2_temp),(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0));
	 writel(((readl((reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0)))&0xfffff000)|(dqgtr_temp),(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0));
	  printf("\n (reg_addDDR0_PUB_DX0GTR) 0x%08x gtr==0x%08x\n ",(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0),(readl((reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0))));
	 printf("\nlcdlr2==0x%08x\n ",readl(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0));
	 printf("\ndqgtr_temp==0x%08x\n ",dqgtr_temp);
	 printf("\ngatedqlcdlr2_temp==0x%08x\n ",dqlcdlr2_temp);
	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		printf("\ngaterig edge detect \n");
		dq_lcd_bdl_temp_reg_value++;
		break;
		}
}
printf("\ngate rig edge detect \n");
printf("\ngate rig edge==0x%08x\n ",dq_lcd_bdl_temp_reg_value);
//dq_lcd_bdl_temp_reg_value_max=dq_lcd_bdl_temp_reg_value;
dqqsgate_r[temp_count_i]=dq_lcd_bdl_temp_reg_value;
	   writel(dqlcdlr2_org[temp_count_i],(reg_add+DDR0_PUB_DX0LCDLR2-DDR0_PUB_DX0LCDLR0));
	 writel( dqgtr_org[temp_count_i],(reg_add+DDR0_PUB_DX0GTR-DDR0_PUB_DX0LCDLR0));






}



 }
}

}
}

////tune and save training dqs value




////calculate and print  dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }
reg_add=DDR0_PUB_DX0LCDLR0+reg_base_adj;




printf("\n ddrtest size ==0x%08x, test times==0x%08x,test_loop==0x%08x\n",ddr_test_size,(test_times+1),test_loop);
printf("\n add  0x00000000 reg==    org           lef           rig           center        win           lef_m         rig_m         min_c         min_win        \n");

for ((temp_count_i=0);(temp_count_i<DATX8_DQ_LANE_WIDTH);(temp_count_i++))
{
{

   if (temp_count_i == DATX8_DQ_LANE_LANE00)
	{
   reg_add=DDR0_PUB_DX0LCDLR0+reg_base_adj+0*4;}

	  else    if(temp_count_i==DATX8_DQ_LANE_LANE01)
	{
   reg_add=DDR0_PUB_DX1LCDLR0+reg_base_adj+0*4;}

	else   	 if(temp_count_i==DATX8_DQ_LANE_LANE02)
	{
   reg_add=DDR0_PUB_DX2LCDLR0+reg_base_adj+0*4;}
	 else    if(temp_count_i==DATX8_DQ_LANE_LANE03)
	{
   reg_add=DDR0_PUB_DX3LCDLR0+reg_base_adj+0*4;}
}

//unsigned int   dqgtr_org[4],dqlcdlr2_org[4],dqgtr_l[4],dqlcdlr2_l[4],dqgtr_r[4],dqlcdlr2_r[4],dqmdlr[4];
//	 unsigned int dqgtr_temp;
//	  unsigned int dqlcdlr2_temp;
//	  unsigned int dqqsgate_l[4], dqqsgate_r[4];
(dqgtr_l[temp_count_i])=(dqqsgate_l[temp_count_i])/((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);
(dqlcdlr2_l[temp_count_i])=(dqqsgate_l[temp_count_i])-(dqgtr_l[temp_count_i])*((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);
(dqgtr_r[temp_count_i])=(dqqsgate_r[temp_count_i])/((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);
(dqlcdlr2_r[temp_count_i])=(dqqsgate_r[temp_count_i])-(dqgtr_r[temp_count_i])*((((dqmdlr[temp_count_i]))&ACLCDLR_MAX)*2);
printf("\n add  reg==    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x    0x%08x\n",
(dqqsgate_org[temp_count_i]),
	(dqqsgate_l[temp_count_i]),
	   (dqqsgate_r[temp_count_i]),
		(dqgtr_org[temp_count_i]),
		 (dqlcdlr2_org[temp_count_i]),
		   (dqgtr_l[temp_count_i]),
		 (dqgtr_r[temp_count_i]),
		   (dqlcdlr2_l[temp_count_i]),
		 (dqlcdlr2_r[temp_count_i])
	   );


}





}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}


U_BOOT_CMD(
	ddrtest_gate,	7,	1,	do_ddrtest_find_gate_wind,
	"DDR test function should dcache off ddrtest_gate a 0 0x80000 1 0 3",
	"ddrtest_gate [LOOP] [ADDR].Default address is 0x10000000\n"
);


//#endif

///*
int do_ddr_test_ac_windows_bdlr(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr ac bdlr windows function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);
 //  unsigned int   loop = 1;
//   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;
static unsigned int soft_ca_training_seed=0;
static unsigned int soft_ca_training_step=0;

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;



	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

		   unsigned int  ac_mdlr_a_org=0;
	   unsigned int  ac_mdlr_b_org=0;

	  unsigned int  ac_lcdlr_a_org=0;
	  unsigned int   ac_bdlr0_a_org=0;
	  unsigned int  ac_lcdlr_b_org=0;
	  unsigned int   ac_bdlr0_b_org=0;
	  unsigned int  ac_lcdlr_a_rig=0;
	  unsigned int   ac_bdlr0_a_rig=0;
	  unsigned int  ac_lcdlr_b_rig=0;
	  unsigned int   ac_bdlr0_b_rig=0;
	  unsigned int  ac_lcdlr_a_lef=0;
	  unsigned int   ac_bdlr0_a_lef=0;
	  unsigned int  ac_lcdlr_b_lef=0;
	  unsigned int   ac_bdlr0_b_lef=0;

		unsigned int  ac_lcdlr_a_rig_min=0;
	  unsigned int   ac_bdlr0_a_rig_min=0;
	  unsigned int  ac_lcdlr_b_rig_min=0;
	  unsigned int   ac_bdlr0_b_rig_min=0;
	  unsigned int  ac_lcdlr_a_lef_min=0;
	  unsigned int   ac_bdlr0_a_lef_min=0;
	  unsigned int  ac_lcdlr_b_lef_min=0;
	  unsigned int   ac_bdlr0_b_lef_min=0;
	 //   unsigned int  ac_lcdlr_temp;
	//  unsigned int   ac_bdlr0_temp=0;



	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

	   unsigned int   ac_bdlr_lef[10];
	   unsigned int   ac_bdlr_rig[10];
	   unsigned int   ac_bdlr_temp_value;
	    unsigned int   ac_bdlr_reg_seed_value;
	   unsigned int   ac_bdlr_temp_reg_value;
	  //  unsigned int   temp_test_error;
		unsigned int temp_i=0;
		unsigned int temp_j=0;
		//unsigned int reg_add=0;
//		static unsigned int soft_ca_training_enabled=1;

//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}

	    if (argc >5) {
	soft_ca_training_seed = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			soft_ca_training_seed = 0x1f;
			}


	}
		    if (argc >6) {
	soft_ca_training_step = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			{
			soft_ca_training_step = 0;
			}


	}
		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_loop== 0x%08x\n", test_loop);
		    printf("\nsoft_ca_training_seed== 0x%08x\n", soft_ca_training_seed);
			printf("\nsoft_ca_training_step== 0x%08x\n", soft_ca_training_step);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
 }

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;


if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel 0x%08x\n",reg_add);
 ac_mdlr_a_org=(unsigned int )(readl((unsigned int )reg_add));//readl(reg_add);//0xc8836000
	   ac_lcdlr_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR)));//readl(reg_add+4);
	ac_bdlr0_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR)));//readl(reg_add+8);

	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);
}
if (reg_base_adj == CHANNEL_B_REG_BASE)
{

  ac_mdlr_b_org=readl(reg_add);
	   ac_lcdlr_b_org=readl(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR);
	ac_bdlr0_b_org=readl(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR);
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);
}


}

}

}////save and print org training  value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel AC\n");
}
else
{
printf("\ntest B channel AC\n");
}


{


#define wrr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rdr_reg(addr)		 (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
	//wr_reg(DDR0_PUB_ACBDLR3, 0x0808);  //cs0 cs1
	//wr_reg(DDR0_PUB_ACBDLR0, 0x1f);  //ck0
	 //	wr_reg(DDR0_PUB_ACBDLR4, 0x0808); //odt0 odt1
	//wr_reg(DDR0_PUB_ACBDLR5, 0x0808);  //cke0 cke1


	//wr_reg(DDR0_PUB_ACBDLR1, 0x181818); //ras cas we
	//wr_reg(DDR0_PUB_ACBDLR2, 0x181818); //ba0 ba1 ba2
	//wr_reg(DDR0_PUB_ACBDLR6, 0x12121212); //a0 a1 a2 a3
	//wr_reg(DDR0_PUB_ACBDLR7, 0x0d0d0d0d); //a4 a5 a6 a7
	//wr_reg(DDR0_PUB_ACBDLR8, 0x10101010);  //a8 a9 a10 a11
	//wr_reg(DDR0_PUB_ACBDLR9, 0x18181818);  //a12 a13 a14 a15
	reg_add=DDR0_PUB_ACBDLR0;
	ac_bdlr_reg_seed_value=(soft_ca_training_seed|(soft_ca_training_seed<<8)|(soft_ca_training_seed<<16)|(soft_ca_training_seed<<24));
for ((  temp_i=0);(temp_i<10);( temp_i++))
{
//wr_reg((DDR0_PUB_ACBDLR0+temp_i*4),
//ac_bdlr_reg_seed_value);  //cs0 cs1
//reg_add=reg_add+temp_i*4;

//reg_add=DDR0_PUB_ACMDLR+reg_base_adj;
reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
wrr_reg((reg_add),
ac_bdlr_reg_seed_value);  //cs0 cs1
ac_bdlr_lef[temp_i]=ac_bdlr_reg_seed_value;
ac_bdlr_rig[temp_i]=ac_bdlr_reg_seed_value;
}

printf("\nbdl  soft_ca_training_step==0x%08x\n ",soft_ca_training_step);
for (( temp_i=0);(temp_i<10);( temp_i++))
{

//ac_bdlr_temp_value=rdr_reg((unsigned int )reg_add);

if ((  temp_i == 1))
{
//temp_i=3;
}


for (( temp_j=0);(temp_j<4);( temp_j++))
{

if (soft_ca_training_step)
{temp_i=(soft_ca_training_step>>2);
temp_j=soft_ca_training_step-((soft_ca_training_step>>2)<<2);
soft_ca_training_step=0;
}
if ((temp_i*4+temp_j) == 1)
{
temp_i=1;
temp_j=0;
}
if ((temp_i*4+temp_j) == 7)
{
temp_i=2;
temp_j=0;
}
if ((temp_i*4+temp_j) == 14)
{
temp_i=4;
temp_j=0;
}
if ((temp_i*4+temp_j) == 18)
{
temp_i=5;
temp_j=0;
}
if ((temp_i*4+temp_j) == 22)
{
temp_i=6;
temp_j=0;
}
//printf("\nbdl  temp_i==0x%08x\n ",temp_i);
printf("\nbdl  temp_ij==0x%08x\n ",(temp_i*4+temp_j));
reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
ac_bdlr_temp_reg_value=rdr_reg((unsigned int )reg_add);
ac_bdlr_temp_value=((ac_bdlr_temp_reg_value>>(temp_j<<3))&ACBDLR_MAX);
while (ac_bdlr_temp_value>0)
{
temp_test_error=0;
ac_bdlr_temp_value--;

printf("\nbdl  temp_ij==0x%08x lef temp==0x%08x\n ",(temp_i*4+temp_j),ac_bdlr_temp_value);

ac_bdlr_temp_reg_value=(((~(0xff<<(temp_j<<3)))&ac_bdlr_reg_seed_value)|((ac_bdlr_temp_value)<<(temp_j<<3)));
reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
wrr_reg((unsigned int )reg_add,
ac_bdlr_temp_reg_value);
printf("\nbdl reg_add 0x%08x== 0x%08x\n ",reg_add,ac_bdlr_temp_reg_value);

	 #ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		printf("\nbdl left edge detect \n");
		ac_bdlr_temp_value++;
		break;
		}
}

printf("\nbdl left edge detect \n");
printf("\n\nbdl  temp_ij==0x%08x          bdl left edge==0x%08x\n ",(temp_i*4+temp_j),ac_bdlr_temp_value);
reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
wrr_reg((unsigned int )reg_add,
ac_bdlr_reg_seed_value);

ac_bdlr_temp_reg_value=(((~(0xff<<(temp_j<<3)))&ac_bdlr_lef[temp_i])|((ac_bdlr_temp_value)<<(temp_j<<3)));
ac_bdlr_lef[temp_i]=ac_bdlr_temp_reg_value;

ac_bdlr_temp_value=((ac_bdlr_reg_seed_value>>(temp_j<<3))&ACBDLR_MAX);
while (ac_bdlr_temp_value<ACBDLR_MAX)
{
temp_test_error=0;
ac_bdlr_temp_value++;
printf("\ntemp_ij==0x%08x rig temp==0x%08x\n ",(temp_i*4+temp_j),ac_bdlr_temp_value);

ac_bdlr_temp_reg_value=(((~(0xff<<(temp_j<<3)))&ac_bdlr_reg_seed_value)|((ac_bdlr_temp_value)<<(temp_j<<3)));
reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
wrr_reg((unsigned int )reg_add,
ac_bdlr_temp_reg_value);
printf("\nbdl reg_add 0x%08x== 0x%08x\n ",reg_add,ac_bdlr_temp_reg_value);
	#ifdef DDR_LCDLR_CK_USE_FAST_PATTERN
	temp_test_error=ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	 #else
   temp_test_error= ddr_test_s_add_cross_talk_pattern(ddr_test_size);
  temp_test_error= temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
  #endif
	if (temp_test_error)
		{
		printf("\nbdl rig edge detect \n");
		ac_bdlr_temp_value--;
		break;
		}
}



printf("\nbdl rig edge detect \n");
//printf("\n\nbdl rig edge==0x%08x\n ",ac_bdlr_temp_value);
printf("\n\nbdl  temp_ij==0x%08x          bdl righ edge==0x%08x\n ",(temp_i*4+temp_j),ac_bdlr_temp_value);
reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
wrr_reg((unsigned int )reg_add,
ac_bdlr_reg_seed_value);

ac_bdlr_temp_reg_value=(((~(0xff<<(temp_j<<3)))&ac_bdlr_rig[temp_i])|((ac_bdlr_temp_value)<<(temp_j<<3)));
ac_bdlr_rig[temp_i]=ac_bdlr_temp_reg_value;
}
}

printf("\nbdl lef edge==bdlr0     bdlr1     bdlr2     bdlr3     bdlr4     bdlr5     bdlr6     bdlr7     bdlr8     bdlr9     \n ");
printf("\nbdl lef edge==\n");
for (( temp_i=0);(temp_i<10);( temp_i++))
{

printf("0x%08x\n ",ac_bdlr_lef[temp_i]);

}

printf("\n ");
for (( temp_i=0);(temp_i<10);( temp_i++))
{

printf("0x%08x\n ",ac_bdlr_rig[temp_i]);

}
printf("\nbdl rig edge===========\n");
printf("\n===================\n");

printf("\nbdl lef edge==\n");
for (( temp_i=0);(temp_i<10);( temp_i++))
{
for (( temp_j=0);(temp_j<4);( temp_j++))
{
if ((temp_i*4+temp_j) == 1)
{
temp_i=1;
temp_j=0;
}
if ((temp_i*4+temp_j) == 7)
{
temp_i=2;
temp_j=0;
}
if ((temp_i*4+temp_j) == 14)
{
temp_i=4;
temp_j=0;
}
if ((temp_i*4+temp_j) == 18)
{
temp_i=5;
temp_j=0;
}
if ((temp_i*4+temp_j) == 22)
{
temp_i=6;
temp_j=0;
}
ac_bdlr_temp_reg_value=((((0xff<<(temp_j<<3)))&ac_bdlr_lef[temp_i])>>(temp_j<<3));
printf("\ntempi_j0x%08x==0x%08x",((temp_i<<2)+temp_j),ac_bdlr_temp_reg_value);
}
}

printf("\n ");
printf("\nbdl rig edge==\n");
for (( temp_i=0);(temp_i<10);( temp_i++))
{
for (( temp_j=0);(temp_j<4);( temp_j++))
{
if ((temp_i*4+temp_j) == 1)
{
temp_i=1;
temp_j=0;
}
if ((temp_i*4+temp_j) == 7)
{
temp_i=2;
temp_j=0;
}
if ((temp_i*4+temp_j) == 14)
{
temp_i=4;
temp_j=0;
}
if ((temp_i*4+temp_j) == 18)
{
temp_i=5;
temp_j=0;
}
if ((temp_i*4+temp_j) == 22)
{
temp_i=6;
temp_j=0;
}
ac_bdlr_temp_reg_value=((((0xff<<(temp_j<<3)))&ac_bdlr_rig[temp_i])>>(temp_j<<3));
printf("\ntempi_j0x%08x==0x%08x",((temp_i<<2)+temp_j),ac_bdlr_temp_reg_value);
}
}




		}



}

////tune and save training dqs value




////calculate and print  dqs value
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }
reg_add=DDR0_PUB_ACMDLR+reg_base_adj;

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
if (test_times)
{
if (ac_lcdlr_a_lef>ac_lcdlr_a_lef_min)
ac_lcdlr_a_lef_min=ac_lcdlr_a_lef;

if (ac_lcdlr_a_rig<ac_lcdlr_a_rig_min)
ac_lcdlr_a_rig_min=ac_lcdlr_a_rig;

if (ac_bdlr0_a_lef>ac_bdlr0_a_lef_min)
ac_bdlr0_a_lef_min=ac_bdlr0_a_lef;

if (ac_bdlr0_a_rig<ac_bdlr0_a_rig_min)
ac_bdlr0_a_rig_min=ac_bdlr0_a_rig;
}
	else
		{
ac_lcdlr_a_lef_min=ac_lcdlr_a_lef;
ac_lcdlr_a_rig_min=ac_lcdlr_a_rig;
ac_bdlr0_a_lef_min=ac_bdlr0_a_lef;
ac_bdlr0_a_rig_min=ac_bdlr0_a_rig;
		}
	   printf("\ntest A channel AC result\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);

printf("\n ac_acmdlr_org  0x%08x reg== 0x%08x   lcdlr_lef   lcdlr_rig   lcdlr_lmin  lcdlr_rmin\n",(reg_add),ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org,ac_lcdlr_a_lef,ac_lcdlr_a_rig,ac_lcdlr_a_lef_min,ac_lcdlr_a_rig_min);
	printf("\n ac_bdlr0_a_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org,ac_bdlr0_a_lef,ac_bdlr0_a_rig,ac_bdlr0_a_lef_min,ac_bdlr0_a_rig_min);



}

if (reg_base_adj == CHANNEL_B_REG_BASE)
{
if (test_times)
{
if (ac_lcdlr_b_lef>ac_lcdlr_b_lef_min)
ac_lcdlr_b_lef_min=ac_lcdlr_b_lef;

if (ac_lcdlr_b_rig<ac_lcdlr_b_rig_min)
ac_lcdlr_b_rig_min=ac_lcdlr_b_rig;

if (ac_bdlr0_b_lef>ac_bdlr0_b_lef_min)
ac_bdlr0_b_lef_min=ac_bdlr0_b_lef;

if (ac_bdlr0_b_rig<ac_bdlr0_b_rig_min)
ac_bdlr0_b_rig_min=ac_bdlr0_b_rig;
}
	else
		{
ac_lcdlr_b_lef_min=ac_lcdlr_b_lef;
ac_lcdlr_b_rig_min=ac_lcdlr_b_rig;
ac_bdlr0_b_lef_min=ac_bdlr0_b_lef;
ac_bdlr0_b_rig_min=ac_bdlr0_b_rig;
		}
	   printf("\ntest B channel AC result\n");
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);

	printf("\n ac_acmdlr_org  0x%08x reg== 0x%08x   lcdlr_lef   lcdlr_rig   lcdlr_lmin  lcdlr_rmin\n",(reg_add),ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org,ac_lcdlr_b_lef,ac_lcdlr_b_rig,ac_lcdlr_b_lef_min,ac_lcdlr_b_rig_min);
	printf("\n ac_bdlr0_a_org  0x%08x reg== 0x%08x  0x%08x  0x%08x  0x%08x  0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org,ac_bdlr0_b_lef,ac_bdlr0_b_rig,ac_bdlr0_b_lef_min,ac_bdlr0_b_rig_min);




}



	   }


}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}


U_BOOT_CMD(
	ddr_tune_ddr_ac_bdlr,	7,	1,	do_ddr_test_ac_windows_bdlr,
	"DDR tune ac bdl function",
	"ddr_tune_ddr_ac_bdlr a 0 0x8000000 1 seed step or ddr_tune_ddr_ac_bdlr b 0 0x800000 1 seed step or ddr_tune_ddr_ac_acbdlr_ck a b 0x80000 l\n dcache off ? \n"
);

int do_ddr_test_vref(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr vref function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);


 //  unsigned int   loop = 1;
//   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;
static unsigned int training_seed=0;
static unsigned int training_step=0;

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;



	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

		   unsigned int  ac_mdlr_a_org=0;
	   unsigned int  ac_mdlr_b_org=0;

	  unsigned int  ac_lcdlr_a_org=0;
	  unsigned int   ac_bdlr0_a_org=0;
	  unsigned int  ac_lcdlr_b_org=0;
	  unsigned int   ac_bdlr0_b_org=0;
	//  unsigned int  ac_lcdlr_a_rig=0;
	//  unsigned int   ac_bdlr0_a_rig=0;
	//  unsigned int  ac_lcdlr_b_rig=0;
	//  unsigned int   ac_bdlr0_b_rig=0;
	//  unsigned int  ac_lcdlr_a_lef=0;
	//  unsigned int   ac_bdlr0_a_lef=0;
	//  unsigned int  ac_lcdlr_b_lef=0;
	//  unsigned int   ac_bdlr0_b_lef=0;

	  //	  unsigned int  ac_lcdlr_a_rig_min=0;
	//  unsigned int   ac_bdlr0_a_rig_min=0;
	//  unsigned int  ac_lcdlr_b_rig_min=0;
	//  unsigned int   ac_bdlr0_b_rig_min=0;
	//  unsigned int  ac_lcdlr_a_lef_min=0;
	//  unsigned int   ac_bdlr0_a_lef_min=0;
	//  unsigned int  ac_lcdlr_b_lef_min=0;
	//  unsigned int   ac_bdlr0_b_lef_min=0;
	 //   unsigned int  ac_lcdlr_temp;
	//  unsigned int   ac_bdlr0_temp=0;



	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

	//   unsigned int   ac_bdlr_lef[10];
	//   unsigned int   ac_bdlr_rig[10];
	   unsigned int   iovref_temp_value;
	    unsigned int   iovref_temp_reg_value;
	    unsigned int  reg_seed_value;
//	   unsigned int   temp_reg_value;
	     unsigned int   iovref_lef;
		  unsigned int   iovref_rig;
	  //  unsigned int   temp_test_error;
	//	unsigned int temp_i=0;
	//	unsigned int temp_j=0;
		//unsigned int reg_add=0;
//		static unsigned int training_enabled=1;

//	 iovref_lef=0x49;
// printf("\n\n iovref  org                     ==0x%08x   %08dmV\n",iovref_lef,(((((iovref_lef&0X3F)*7)+440)*3)/2)+1);
//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_loop = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_loop = 1;
			}
		 if   ((strcmp(argv[4], "l") == 0) || (strcmp(argv[4], "L") == 0))
			{
			test_loop = 100000;
			}
	}
	training_seed = 0x49;
	    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed = 0x49;
			}


	}

 printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,(((((training_seed&0X3F)*7)+440)*3)/2)+1);

 training_step = 0;
			if (argc >6) {
	training_step = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			{
			training_step = 0;
			}



	}
		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_loop== 0x%08x\n", test_loop);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

//save and print org training dqs value
if (channel_a_en || channel_b_en)
{


	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{
if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;



   }
 }

 reg_add=DDR0_PUB_ACMDLR+reg_base_adj;


if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel 0x%08x\n",reg_add);
 ac_mdlr_a_org=(unsigned int )(readl((unsigned int )reg_add));//readl(reg_add);//0xc8836000
	   ac_lcdlr_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR)));//readl(reg_add+4);
	ac_bdlr0_a_org=(unsigned int )(readl((unsigned int )(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR)));//readl(reg_add+8);

	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_a_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_a_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_a_org);
}
if (reg_base_adj == CHANNEL_B_REG_BASE)
{

  ac_mdlr_b_org=readl(reg_add);
	   ac_lcdlr_b_org=readl(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR);
	ac_bdlr0_b_org=readl(reg_add+8);
	printf("\n ac_mdlr_org  0x%08x reg== 0x%08x\n",(reg_add), ac_mdlr_b_org);
	printf("\n ac_lcdlr_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACLCDLR-DDR0_PUB_ACMDLR), ac_lcdlr_b_org);
	printf("\n ac_bdlr0_org  0x%08x reg== 0x%08x\n",(reg_add+DDR0_PUB_ACBDLR0-DDR0_PUB_ACMDLR), ac_bdlr0_b_org);
}


}

}

}////save and print org training  value


for (test_times=0;(test_times<test_loop);(test_times++))
{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel AC\n");
}
else
{
printf("\ntest B channel AC\n");
}


{


#define wrr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rdr_reg(addr)		 (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
	//wr_reg(DDR0_PUB_ACBDLR3, 0x0808);  //cs0 cs1
	//wr_reg(DDR0_PUB_ACBDLR0, 0x1f);  //ck0
	 //	wr_reg(DDR0_PUB_ACBDLR4, 0x0808); //odt0 odt1
	//wr_reg(DDR0_PUB_ACBDLR5, 0x0808);  //cke0 cke1


	//wr_reg(DDR0_PUB_ACBDLR1, 0x181818); //ras cas we
	//wr_reg(DDR0_PUB_ACBDLR2, 0x181818); //ba0 ba1 ba2
	//wr_reg(DDR0_PUB_ACBDLR6, 0x12121212); //a0 a1 a2 a3
	//wr_reg(DDR0_PUB_ACBDLR7, 0x0d0d0d0d); //a4 a5 a6 a7
	//wr_reg(DDR0_PUB_ACBDLR8, 0x10101010);  //a8 a9 a10 a11
	//wr_reg(DDR0_PUB_ACBDLR9, 0x18181818);  //a12 a13 a14 a15
	reg_add=DDR0_PUB_IOVCR0;
	reg_seed_value=(training_seed|(training_seed<<8)|(training_seed<<16)|(training_seed<<24));
//for((  temp_i=0);(temp_i<10);( temp_i++))
{
//wr_reg((DDR0_PUB_ACBDLR0+temp_i*4),
//ac_bdlr_reg_seed_value);  //cs0 cs1
//reg_add=reg_add+temp_i*4;

//reg_add=DDR0_PUB_ACMDLR+reg_base_adj;
//reg_add=(DDR0_PUB_ACBDLR0+temp_i*4);
reg_add=reg_add+reg_base_adj;
iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);
//	 iovref_lef=0x49;
if (iovref_temp_value)
{
 printf("\n\n iovref  org                     ==0x%08x   %08dmV\n",iovref_temp_value,(((((iovref_temp_value&0X3F)*7)+440)*3)/2)+1);
}
else
{
printf("\nio vref power down ,use external resister \n ");
}

wrr_reg((reg_add),
reg_seed_value);  //

wrr_reg((reg_add+4),
reg_seed_value);  //
iovref_lef=training_seed;
iovref_rig=training_seed;
}

printf("\ntraining_step==0x%08x\n ",training_step);
{

{


iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);
while (iovref_temp_value>0x40)
{
temp_test_error=0;
iovref_temp_value--;

printf("\niovref lef temp==0x%08x\n ",iovref_temp_value);

iovref_temp_reg_value=(iovref_temp_value|(iovref_temp_value<<8)|(iovref_temp_value<<16)|(iovref_temp_value<<24));;
wrr_reg((reg_add),
iovref_temp_reg_value);  //

wrr_reg((reg_add+DDR0_PUB_IOVCR1-DDR0_PUB_IOVCR0),
iovref_temp_reg_value);  //
printf("\n reg_add 0x%08x== 0x%08x\n ",reg_add,iovref_temp_reg_value);
temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		printf("\nvref down edge detect \n");
		iovref_temp_value++;
		break;
		}
}

printf("\n down edge detect \n");
printf("\n\n iovref                       down edge==0x%08x\n ",iovref_temp_value);
iovref_lef=iovref_temp_value;

wrr_reg((reg_add),
reg_seed_value);  //

wrr_reg((reg_add+DDR0_PUB_IOVCR1-DDR0_PUB_IOVCR0),
reg_seed_value);  //

iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);


while (iovref_temp_value<0x7f)
{
temp_test_error=0;
iovref_temp_value++;

printf("\niovref lef temp==0x%08x\n ",iovref_temp_value);

iovref_temp_reg_value=(iovref_temp_value|(iovref_temp_value<<8)|(iovref_temp_value<<16)|(iovref_temp_value<<24));;
wrr_reg((reg_add),
iovref_temp_reg_value);  //

wrr_reg((reg_add+DDR0_PUB_IOVCR1-DDR0_PUB_IOVCR0),
iovref_temp_reg_value);  //
printf("\n reg_add 0x%08x== 0x%08x\n ",reg_add,iovref_temp_reg_value);

   temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (temp_test_error)
		{
		printf("\nvref up edge detect \n");
		iovref_temp_value--;
		break;
		}
}

printf("\n up edge detect \n");
printf("\n\n iovref                       up edge==0x%08x\n ",iovref_temp_value);
iovref_rig=iovref_temp_value;

//reg_seed_value=0x49494949
wrr_reg((reg_add),
0x49494949);  //

wrr_reg((reg_add+DDR0_PUB_IOVCR1-DDR0_PUB_IOVCR0),
0x49494949);  //




}
}

printf("\n\n iovref                       down edge==0x%08x   %08dmV\n",iovref_lef,(((((iovref_lef&0X3F)*7)+440)*3)/2)+1);
printf("\n\n iovref                         up edge==0x%08x   %08dmV\n",iovref_rig,(((((iovref_rig&0X3F)*7)+440)*3)/2)+1);
printf("\n\n iovref                            mid ==0x%08x   %08dmV\n",
	(iovref_lef+iovref_rig)/2,(((((((iovref_lef+iovref_rig)/2)&0X3F)*7)+440)*3)/2)+1);
if (iovref_lef == 0x40)
{
printf("\n\n iovref   down edge reach  reg limited\n");
}















		}



}






}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	return 1;

}
U_BOOT_CMD(
	ddr_tune_ddr_vref,	7,	1,	do_ddr_test_vref,
	"DDR tune vref function ddr_tune_ddr_vref  a 0 0x8000000  1 48 1",
	"ddr_tune_ddr_vref  a 0 0x8000000  1 seed step \n dcache off ? \n"
);


int do_ddr4_test_phy_vref(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{

	#if ( CONFIG_DDR_PHY>=P_DDR_PHY_905X)
// unsigned int  start_addr=test_start_addr;
   printf("\nEnter Test ddr4 phy vref function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);


 //  unsigned int   loop = 1;
//   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;
  int training_seed=0;
  int training_step=0;

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_soc_dram=0;
 //  unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;
	   unsigned int   dxnlcdlr3[4];
	   unsigned int   dxnlcdlr4[4];


	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000
   #define DDR0_PUB_REG_BASE					0xc8836000
   #define DDR0_PUB_DX0GCR4      ( DDR0_PUB_REG_BASE + ( 0x1c4  << 2 ) )
   #define DDR0_PUB_DX1GCR4     ( DDR0_PUB_REG_BASE + ( 0x204  << 2 ) )
   #define DDR0_PUB_DX2GCR4      ( DDR0_PUB_REG_BASE + ( 0x244  << 2 ) )
   #define DDR0_PUB_DX3GCR4      ( DDR0_PUB_REG_BASE + ( 0x284  << 2 ) )
   #define DDR0_PUB_DX0GCR5      ( DDR0_PUB_REG_BASE + ( 0x1c5  << 2 ) )
   #define DDR0_PUB_DX1GCR5      ( DDR0_PUB_REG_BASE + ( 0x205  << 2 ) )
   #define DDR0_PUB_DX2GCR5      ( DDR0_PUB_REG_BASE + ( 0x245  << 2 ) )
   #define DDR0_PUB_DX3GCR5      ( DDR0_PUB_REG_BASE + ( 0x285  << 2 ) )



	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

	//   unsigned int   ac_bdlr_lef[10];
	//   unsigned int   ac_bdlr_rig[10];
	    int   iovref_temp_value;
	     int   iovref_temp_reg_value;
	//    unsigned int  reg_seed_value;
//	   unsigned int   temp_reg_value;
 int   iovref_org[4];
	      int   iovref_lef[4];
		   int   iovref_rig[4];
	  //  unsigned int   temp_test_error;
	//	unsigned int temp_i=0;
	//	unsigned int temp_j=0;
		//unsigned int reg_add=0;
//		static unsigned int training_enabled=1;

//	 iovref_lef=0x49;
// printf("\n\n iovref  org                     ==0x%08x   %08dmV\n",iovref_lef,(((((iovref_lef&0X3F)*7)+440)*3)/2)+1);
//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_soc_dram = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_soc_dram = 0;
			}
	if (  test_soc_dram )
		  test_soc_dram = 1;

	}
	training_seed = 0;
	    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed =0;// 0x2e;
			}


	}

if (training_seed>0x3f)
	training_seed=0x3f;

 printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,((((((training_seed&0X3F)*7)+440)*3)/2)+1)*12/15);

 training_step = 0;
			if (argc >6) {
	training_step = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			{
			training_step = 0;
			}



	}
			 int vref_all=0;
			    if (argc >7) {
   vref_all = simple_strtoul(argv[7], &endp, 16);
        if (*argv[7] == 0 || *endp != 0)
			{
			vref_all =0;// 0x2e;
			}}
					 int vref_lcdlr_offset=0;
			    if (argc >8) {
   vref_lcdlr_offset = simple_strtoul(argv[8], &endp, 16);
        if (*argv[8] == 0 || *endp != 0)
		{
			vref_lcdlr_offset =0;
			}}
	 int vref_set_test_step=0;
			    if (argc >9) {
   vref_set_test_step = simple_strtoul(argv[9], &endp, 16);
        if (*argv[9] == 0 || *endp != 0)
		{
			vref_set_test_step =0;
			}}

		unsigned int soc_dram_hex_dec=0;
if (argc >10)
{
	soc_dram_hex_dec = simple_strtoul(argv[10], &endp, 0);
	if (*argv[10] == 0 || *endp != 0) {
		soc_dram_hex_dec = 0;
	}
}
if (soc_dram_hex_dec)
{
    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 0);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed =0;// 0x2e;
			}
 printf("\ntraining_seed== 0x%08x\n", training_seed);

	}
if (training_seed<45)
	training_seed=45;
if (training_seed>88)
	training_seed=88;
training_seed =(((training_seed*1000-44070)/698));


 printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,((((((training_seed&0X3F)*7)+440)*3)/2)+1)*12/15);
}
		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_soc_dram== 0x%08x\n", test_soc_dram);
		      printf("\nvref_all== 0x%08x\n", vref_all);
			    printf("\nvref_lcdlr_offset== 0x%08x\n", vref_lcdlr_offset);
					    printf("\nsoc_dram_hex_dec== 0x%08x\n", soc_dram_hex_dec);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

//save and print org training dqs value
if (channel_a_en || channel_b_en)
{
	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");
}////save and print org training  value



{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel data lane\n");
}
else
{
printf("\ntest B channel data lane\n");
}


{


#define wrr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rdr_reg(addr)		 (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
	   unsigned int   dxnmdlr=0;
	reg_add=DDR0_PUB_DX0MDLR0+reg_base_adj;
	dxnmdlr=((rdr_reg((unsigned int )reg_add))>>16)&0x1ff;
//	reg_seed_value=(training_seed|(0x0<<8)|(0x0<<16)|(0x0<<24));
wrr_reg((((DDR0_PUB_DX0GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX0GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX1GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX1GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX2GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX2GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX3GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX3GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
printf("\nDDR0_PUB_DX0GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX0GCR4))));
printf("\nDDR0_PUB_DX1GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX1GCR4))));
printf("\nDDR0_PUB_DX2GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX2GCR4))));
printf("\nDDR0_PUB_DX3GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX3GCR4))));

printf("\ndxnmdlr==0x%08x\n ",dxnmdlr);
	   unsigned int   temp_i=0;
unsigned int   temp_i_max=4;
for ((  temp_i=0);(temp_i<4);( temp_i++))
{
dxnlcdlr3[temp_i]=(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+temp_i*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))));
dxnlcdlr4[temp_i]=(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+temp_i*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))));
reg_add=DDR0_PUB_DX0GCR5+reg_base_adj+temp_i*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5);
iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_org[temp_i]=iovref_temp_value;
iovref_temp_value=((iovref_temp_value)&0xff);
printf("\ndxnlcdlr3[%08x]==0x%08x,dxnlcdlr4[%08x]==0x%08x\n ",temp_i,dxnlcdlr3[temp_i],temp_i,dxnlcdlr4[temp_i]);
//	 iovref_lef=0x49;
if (iovref_temp_value)
{
 printf("reg_add==0x%08x,value==0x%08x, iovref  org ==0x%08x   %08dmV\n",reg_add,
	iovref_org[temp_i],iovref_temp_value,((((((iovref_temp_value&0X3F)*7)+440)*3)/2)+1)*12/15);
}
else
{
printf("\nio vref power down ,use external resister \n ");
}

wrr_reg((reg_add),
iovref_org[temp_i]);  //
iovref_lef[temp_i]=(iovref_org[temp_i])&0xff;
iovref_rig[temp_i]=(iovref_org[temp_i])&0xff;
if (training_seed)
{iovref_lef[temp_i]=training_seed;
iovref_rig[temp_i]=training_seed;

}
}

printf("\ntraining_step==0x%08x\n ",training_step);
if (vref_all)
{temp_i_max=1;
}
for ((  temp_i=0);(temp_i<temp_i_max);( temp_i++))
{
reg_add=DDR0_PUB_DX0GCR5+reg_base_adj+temp_i*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5);


if (training_seed)
{
wrr_reg((reg_add),
(training_seed|((iovref_org[temp_i])&0xffffff00)));
if (vref_all) {
	wrr_reg(((reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
(training_seed|((iovref_org[temp_i+1])&0xffffff00)));  //
wrr_reg(((reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
(training_seed|((iovref_org[temp_i+2])&0xffffff00)));  //
wrr_reg(((reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
(training_seed|((iovref_org[temp_i+3])&0xffffff00)));  //
}
}

{

iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);

while (iovref_temp_value>0x0)
{
if (vref_set_test_step)
{
printf("\nvref_set_test_step==0x%08x,skip test left edge\n ",vref_set_test_step);
break;
}
temp_test_error=0;
iovref_temp_value=iovref_temp_value-training_step;
if (iovref_temp_value<training_step)
	iovref_temp_value=0;
printf("\niovref lef temp==0x%08x\n ",iovref_temp_value);

iovref_temp_reg_value=(iovref_temp_value|((iovref_org[temp_i])&0xffffff00));
wrr_reg((reg_add),
iovref_temp_reg_value);  //
if (vref_all) {
wrr_reg((reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),
iovref_temp_reg_value);  //
wrr_reg((reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),
iovref_temp_reg_value);  //
wrr_reg((reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),
iovref_temp_reg_value);  //
}
printf("\n reg_add 0x%08x== 0x%08x\n ",reg_add,iovref_temp_reg_value);
printf("\n reg_add 0x%08x== 0x%08x\n ",(reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),iovref_temp_reg_value);
printf("\n reg_add 0x%08x== 0x%08x\n ",(reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),iovref_temp_reg_value);
printf("\n reg_add 0x%08x== 0x%08x\n ",(reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),iovref_temp_reg_value);
temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR3+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR4+reg_base_adj)))+vref_lcdlr_offset));  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))))+vref_lcdlr_offset));  //
}
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
		printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),dxnlcdlr3[0]);  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),dxnlcdlr4[0]);  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[3]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[3]);  //
}

		}
		}

		}

		}

	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),(dxnlcdlr3[0]-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),(dxnlcdlr4[0]-vref_lcdlr_offset));  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
(dxnlcdlr3[1]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
(dxnlcdlr3[2]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
(dxnlcdlr3[3]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
(dxnlcdlr4[1]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
(dxnlcdlr4[2]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
(dxnlcdlr4[3]-vref_lcdlr_offset));  //
}
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
		printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),dxnlcdlr3[0]);  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),dxnlcdlr4[0]);  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[3]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[3]);  //
}

		}
		}

		}

		}
	if (temp_test_error)
		{
		printf("\nvref down edge detect \n");
		iovref_temp_value=iovref_temp_value+training_step;
		break;
		}
}

printf("\n down edge detect \n");
printf("\n\n iovref                       down edge==0x%08x\n ",iovref_temp_value);
iovref_lef[temp_i]=iovref_temp_value;

wrr_reg((reg_add),
iovref_org[temp_i]);  //
if (vref_all) {
	wrr_reg(((reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
iovref_org[temp_i+1]);  //
wrr_reg(((reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
iovref_org[temp_i+2]);  //
wrr_reg(((reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
iovref_org[temp_i+3]);  //
}

if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),dxnlcdlr3[0]);  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),dxnlcdlr4[0]);  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[3]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[3]);  //
}

		}
		}
}


{
if (training_seed)
{
wrr_reg((reg_add),
(training_seed|((iovref_org[temp_i])&0xffffff00)));
if (vref_all) {
	wrr_reg(((reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
(training_seed|((iovref_org[temp_i+1])&0xffffff00)));  //
wrr_reg(((reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
(training_seed|((iovref_org[temp_i+2])&0xffffff00)));  //
wrr_reg(((reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
(training_seed|((iovref_org[temp_i+3])&0xffffff00)));  //
}
}

iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);


while (iovref_temp_value<0x3f)
{
temp_test_error=0;
iovref_temp_value=iovref_temp_value+training_step;
if (iovref_temp_value>0x3f)
	iovref_temp_value=0x3f;
printf("\niovref rig temp==0x%08x\n ",iovref_temp_value);

iovref_temp_reg_value=(iovref_temp_value|((iovref_org[temp_i])&0xffffff00));
wrr_reg((reg_add),
iovref_temp_reg_value);  //
if (vref_all) {
wrr_reg((reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),
iovref_temp_reg_value);  //
wrr_reg((reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),
iovref_temp_reg_value);  //
wrr_reg((reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),
iovref_temp_reg_value);  //
}

printf("\n reg_add 0x%08x== 0x%08x\n ",reg_add,iovref_temp_reg_value);
printf("\n reg_add 0x%08x== 0x%08x\n ",(reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),iovref_temp_reg_value);
printf("\n reg_add 0x%08x== 0x%08x\n ",(reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),iovref_temp_reg_value);
printf("\n reg_add 0x%08x== 0x%08x\n ",(reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5)),iovref_temp_reg_value);

   temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR3+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR4+reg_base_adj)))+vref_lcdlr_offset));  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))))+vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
((rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4))))+vref_lcdlr_offset));  //
}
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
		printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),dxnlcdlr3[0]);  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),dxnlcdlr4[0]);  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[3]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[3]);  //
}

		}
		}

		}

		}

		if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),(dxnlcdlr3[0]-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),(dxnlcdlr4[0]-vref_lcdlr_offset));  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
(dxnlcdlr3[1]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
(dxnlcdlr3[2]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
(dxnlcdlr3[3]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
(dxnlcdlr4[1]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
(dxnlcdlr4[2]-vref_lcdlr_offset));  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
(dxnlcdlr4[3]-vref_lcdlr_offset));  //
}
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)))));
		printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+0*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
	printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)))));
 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),dxnlcdlr3[0]);  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),dxnlcdlr4[0]);  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[3]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[3]);  //
}

		}
		}

		}

		}

	if (temp_test_error)
		{
		printf("\nvref up edge detect \n");
		iovref_temp_value=iovref_temp_value-training_step;
		break;
		}
}

printf("\n up edge detect \n");
printf("\n\n iovref                       up edge==0x%08x\n ",iovref_temp_value);
iovref_rig[temp_i]=iovref_temp_value;

wrr_reg((reg_add),
iovref_org[temp_i]);  //
if (vref_all) {
	wrr_reg(((reg_add+1*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
iovref_org[temp_i+1]);  //
wrr_reg(((reg_add+2*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
iovref_org[temp_i+2]);  //
wrr_reg(((reg_add+3*(DDR0_PUB_DX1GCR5-DDR0_PUB_DX0GCR5))),
iovref_org[temp_i+3]);  //
}

if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR3+reg_base_adj),dxnlcdlr3[0]);  //
wrr_reg((DDR0_PUB_DX0LCDLR4+reg_base_adj),dxnlcdlr4[0]);  //
if (vref_all) {
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR3+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR3-DDR0_PUB_DX0LCDLR3)),
dxnlcdlr3[3]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+1*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[1]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+2*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[2]);  //
wrr_reg(((DDR0_PUB_DX0LCDLR4+reg_base_adj)+3*(DDR0_PUB_DX1LCDLR4-DDR0_PUB_DX0LCDLR4)),
dxnlcdlr4[3]);  //
}

		}
		}


}
}// vddq=1.5v
printf("\n\n iovref  vddq=1.2v,if use other vddq ,please recount\n");
for ((  temp_i=0);(temp_i<4);( temp_i++))
{
printf("\n\n iovref  lane_x=0x%08x,     org==0x%08x   %08dmV\n",temp_i,iovref_org[temp_i],((((((iovref_org[temp_i]&0X3F)*7)+440)*3)/2)+1)*12/15);
printf("\n\n iovref  lane_x=0x%08x,     down edge==0x%08x   %08dmV\n",temp_i,iovref_lef[temp_i],((((((iovref_lef[temp_i]&0X3F)*7)+440)*3)/2)+1)*12/15);
printf("\n\n iovref  lane_x=0x%08x,     up edge==0x%08x   %08dmV\n",temp_i,iovref_rig[temp_i],((((((iovref_rig[temp_i]&0X3F)*7)+440)*3)/2)+1)*12/15);
printf("\n\n iovref  lane_x=0x%08x,     mid ==0x%08x   %08dmV\n",temp_i,
	(iovref_lef[temp_i]+iovref_rig[temp_i])/2,((((((((iovref_lef[temp_i]+iovref_rig[temp_i])/2)&0X3F)*7)+440)*3)/2)+1)*12/15);
if (iovref_lef[temp_i] == 0x0)
{
printf("\n\n iovref   down edge reach  reg limited\n");
}
if (iovref_rig[temp_i] == 0x3f)
{
printf("\n\n iovref   up edge reach  reg limited\n");
}
}














		}



}






}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	#endif
	return 1;

}
//*/

int do_ddr4_test_dram_vref(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#if ( CONFIG_DDR_PHY>=P_DDR_PHY_905X)
// unsigned int  start_addr=test_start_addr;
   printf("\nEnter Test ddr4 dram vref function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);


 //  unsigned int   loop = 1;
//   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;
  int training_seed=0;
  int training_step=0;

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_clear=0;
 //  unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;
	   unsigned int   dxnlcdlr1[4];
	 //  unsigned int   dxnlcdlr4[4];


	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1


	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000
   #define DDR0_PUB_REG_BASE					0xc8836000
   #define DDR0_PUB_DX0GCR4      ( DDR0_PUB_REG_BASE + ( 0x1c4  << 2 ) )
   #define DDR0_PUB_DX1GCR4     ( DDR0_PUB_REG_BASE + ( 0x204  << 2 ) )
   #define DDR0_PUB_DX2GCR4      ( DDR0_PUB_REG_BASE + ( 0x244  << 2 ) )
   #define DDR0_PUB_DX3GCR4      ( DDR0_PUB_REG_BASE + ( 0x284  << 2 ) )
   #define DDR0_PUB_DX0GCR5      ( DDR0_PUB_REG_BASE + ( 0x1c5  << 2 ) )
   #define DDR0_PUB_DX1GCR5      ( DDR0_PUB_REG_BASE + ( 0x205  << 2 ) )
   #define DDR0_PUB_DX2GCR5      ( DDR0_PUB_REG_BASE + ( 0x245  << 2 ) )
   #define DDR0_PUB_DX3GCR5      ( DDR0_PUB_REG_BASE + ( 0x285  << 2 ) )



	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

	//   unsigned int   ac_bdlr_lef[10];
	//   unsigned int   ac_bdlr_rig[10];
	    int   iovref_temp_value;
	//     int   iovref_temp_reg_value;
	//    unsigned int  reg_seed_value;
//	   unsigned int   temp_reg_value;
 int   iovref_org;
 int   iovref_lef;
 int   iovref_rig;
 int   iovref_mid;
 int   iovref_test_read;
 int   iovref_test_step;
	  //  unsigned int   temp_test_error;
	//	unsigned int temp_i=0;
	//	unsigned int temp_j=0;
		//unsigned int reg_add=0;
//		static unsigned int training_enabled=1;

//	 iovref_lef=0x49;
// printf("\n\n iovref  org                     ==0x%08x   %08dmV\n",iovref_lef,(((((iovref_lef&0X3F)*7)+440)*3)/2)+1);
//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_clear = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_clear = 0;
			}
	if (  test_clear )
		  test_clear = 1;

	}
	training_seed = 0;
	    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed =0;// 0x2e;
			}


	}





 training_step = 0;
			if (argc >6) {
	training_step = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			{
			training_step = 0;
			}

	}
			if (!training_step)
				training_step=1;
			 int vref_all=0;
			    if (argc >7) {
   vref_all = simple_strtoul(argv[7], &endp, 16);
        if (*argv[7] == 0 || *endp != 0)
			{
			vref_all =0;// 0x2e;
			}}
					 int vref_lcdlr_offset=0;
			    if (argc >8) {
   vref_lcdlr_offset = simple_strtoul(argv[8], &endp, 16);
        if (*argv[8] == 0 || *endp != 0)
		{
			vref_lcdlr_offset =0;
			}}
							 int vref_set_test_step=0;
			    if (argc >9) {
   vref_set_test_step = simple_strtoul(argv[9], &endp, 16);
        if (*argv[9] == 0 || *endp != 0)
		{
			vref_set_test_step =0;
			}}
									 int vref_dram_range=0;
			    if (argc >10) {
   vref_dram_range = simple_strtoul(argv[10], &endp, 16);
        if (*argv[10] == 0 || *endp != 0)
		{
			vref_dram_range =0;
			}}


		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_clear== 0x%08x\n", test_clear);
		      printf("\nvref_all== 0x%08x\n", vref_all);
			    printf("\nvref_lcdlr_offset== 0x%08x\n", vref_lcdlr_offset);
				  printf("\nvref_dram_range== 0x%08x\n", vref_dram_range);

						unsigned int soc_dram_hex_dec=0;
if (argc >11)
{
	soc_dram_hex_dec = simple_strtoul(argv[11], &endp, 16);
	if (*argv[11] == 0 || *endp != 0) {
		soc_dram_hex_dec = 0;
	}
}
if (soc_dram_hex_dec)
{
    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 0);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed =0;// 0x2e;
			}


	}

}
 if (training_seed)
{
if (soc_dram_hex_dec)
{
if (vref_dram_range)
{
if (training_seed<45)
	training_seed=45;
if (training_seed>77)
	training_seed=77;
training_seed =(((((training_seed*1000-45000)/650)>0X32)?(0X32):(((training_seed*1000-45000)/650))));
}
if (vref_dram_range == 0)
{
if (training_seed<60)
	training_seed=60;
if (training_seed>92)
	training_seed=92;
training_seed =(((((training_seed*1000-60000)/650)>0X32)?(0X32):(((training_seed*1000-60000)/650))));
}
}
if (vref_dram_range == 0)
 printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,(((((training_seed&0X3F)*65)+6000)*1200)/10000));
else
printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,(((((training_seed&0X3F)*65)+4500)*1200)/10000));
}
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

//save and print org training dqs value
if (channel_a_en || channel_b_en)
{
	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");
}////save and print org training  value



{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel data lane\n");
}
else
{
printf("\ntest B channel data lane\n");
}


{


#define wrr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rdr_reg(addr)		 (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
	   unsigned int   dxnmdlr=0;
	reg_add=DDR0_PUB_DX0MDLR0+reg_base_adj;
	dxnmdlr=((rdr_reg((unsigned int )reg_add))>>16)&0x1ff;
//	reg_seed_value=(training_seed|(0x0<<8)|(0x0<<16)|(0x0<<24));
printf("\ndxnmdlr==0x%08x\n ",dxnmdlr);
//turn off ddr4 phy read vref gate,only output ac lane vref
wrr_reg((((DDR0_PUB_DX0GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX0GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX1GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX1GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX2GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX2GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX3GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX3GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_IOVCR0))),0x00090909|(0x0f<<24));
wrr_reg((((DDR0_PUB_IOVCR1))),0x109);
printf("\nDDR0_PUB_DX0GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX0GCR4))));
printf("\nDDR0_PUB_DX1GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX1GCR4))));
printf("\nDDR0_PUB_DX2GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX2GCR4))));
printf("\nDDR0_PUB_DX3GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX3GCR4))));
printf("\nDDR0_PUB_IOVCR0==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_IOVCR0))));
printf("\nDDR0_PUB_IOVCR1==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_IOVCR1))));
	   unsigned int   temp_i=0;
//unsigned int   temp_i_max=4;//DDR0_PUB_MR6
for ((  temp_i=0);(temp_i<4);( temp_i++))
{
dxnlcdlr1[temp_i]=(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)+temp_i*(DDR0_PUB_DX1LCDLR1-DDR0_PUB_DX0LCDLR1))));

printf("\nreg==0x%08x,dxnlcdlr1[%08x]==0x%08x\n ",
	((DDR0_PUB_DX0LCDLR1+reg_base_adj)+temp_i*(DDR0_PUB_DX1LCDLR1-DDR0_PUB_DX0LCDLR1)),
	temp_i,dxnlcdlr1[temp_i]);

}


iovref_temp_value=rdr_reg((unsigned int )(DDR0_PUB_DX0GCR6));
if ((iovref_temp_value&0x3f) == 0x09)
{
//iovref_temp_value=rdr_reg((unsigned int )(DDR0_PUB_MR6));
}
iovref_org=(rdr_reg((unsigned int )((PREG_STICKY_REG8))))&0xff;
iovref_test_read=(rdr_reg((unsigned int )((DDR0_PUB_MR6))))&0x3f;
printf("PREG_STICKY_REG8==0x%08x\n ",(rdr_reg((unsigned int )((PREG_STICKY_REG8)))));
printf("DDR0_PUB_MR6==0x%08x\n ",(rdr_reg((unsigned int )((DDR0_PUB_MR6)))));
printf("DDR0_PUB_DX0GCR6==0x%08x\n ",(rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6)))));
if (((iovref_org) == 0) || (test_clear))
{

iovref_org=iovref_temp_value&0x3f;
iovref_lef=iovref_org;
iovref_rig=iovref_org;
iovref_test_step=0;

if (training_seed)
{
iovref_org=training_seed&0x3f;
iovref_lef=iovref_org;
iovref_rig=iovref_org;
iovref_test_step=0;

}
if (vref_dram_range == 0)
 printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,(((((training_seed&0X3F)*65)+6000)*1200)/10000));
else
printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,(((((training_seed&0X3F)*65)+4500)*1200)/10000));
wrr_reg((PREG_STICKY_REG8),iovref_org|(iovref_lef<<8)|((iovref_rig<<16))|(iovref_test_step<<24));
}

printf("PREG_STICKY_REG8==0x%08x\n ",(rdr_reg((unsigned int )((PREG_STICKY_REG8)))));
{
	if ((((rdr_reg((unsigned int )((DDR0_PUB_MR6))))>>6)&1) == 0)
		{
 printf("reg_add==0x%08x,value==0x%08x, iovref  org ==0x%08x   %08dmV\n",DDR0_PUB_MR6,
	iovref_temp_value,iovref_org,((((((iovref_org&0X3F)*65)+6000)*1200)/10000)));
   printf("reg_add==0x%08x,value==0x%08x, iovref_dx0gcr6 ==0x%08x   %08dmV\n",DDR0_PUB_DX0GCR6,
	(rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6)))),(rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6)))),
	(((((((rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6))))&0X3F)*65)+6000)*1200)/10000)));

		}
		if (((rdr_reg((unsigned int )((DDR0_PUB_MR6))))>>6)&1)
		{
 printf("reg_add==0x%08x,value==0x%08x, iovref  org ==0x%08x   %08dmV\n",DDR0_PUB_MR6,
	iovref_temp_value,iovref_org,((((((iovref_org&0X3F)*65)+4500)*1200)/10000)));
   printf("reg_add==0x%08x,value==0x%08x, iovref_dx0gcr6 ==0x%08x   %08dmV\n",DDR0_PUB_DX0GCR6,
	(rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6)))),(rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6)))),
	(((((((rdr_reg((unsigned int )((DDR0_PUB_DX0GCR6))))&0X3F)*65)+4500)*1200)/10000)));

		}

}

iovref_org=(rdr_reg((unsigned int )((PREG_STICKY_REG8))))&0x3f;  //
iovref_lef=((rdr_reg((unsigned int )((PREG_STICKY_REG8))))>>8)&0x3f;
iovref_rig=((rdr_reg((unsigned int )((PREG_STICKY_REG8))))>>16)&0x3f;
iovref_test_step=((rdr_reg((unsigned int )((PREG_STICKY_REG8))))>>24)&0x3f;



printf("\ntraining_step==0x%08x\n ",training_step);
printf("\niovref_test_step==0x%08x\n ",iovref_test_step);
printf("\niovref_lef==0x%08x\n ",iovref_lef);
printf("\niovref_rig==0x%08x\n ",iovref_rig);
if (vref_set_test_step)
{if(iovref_test_step==0)
	iovref_test_step=vref_set_test_step;
}
if (iovref_test_step<2)
{
if (iovref_test_step == 0)
{
iovref_temp_value=iovref_lef;

}
if (iovref_test_step == 1)
{
iovref_temp_value=iovref_rig;
}
//iovref_temp_value=iovref_lef-training_step;
printf("\niovref  temp==0x%08x\n ",iovref_temp_value);
printf("\niovref_test_read==0x%08x\n ",iovref_test_read);
temp_test_error=0;
if ((iovref_org == iovref_lef) && (iovref_org == iovref_rig)) {
	printf("\nfirst test");
}
else if(iovref_test_read!=iovref_temp_value)
{temp_test_error=1;
}
temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (vref_lcdlr_offset)
{
{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX1LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX2LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX3LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //


printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX1LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX1LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX2LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX2LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX3LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX3LCDLR1+reg_base_adj)))));

 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);

{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //

}
}

//	/*
{
{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX1LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX2LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX3LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //


printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX1LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX1LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX2LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX2LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX3LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX3LCDLR1+reg_base_adj)))));

 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);

{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //

}
}


		}
	//*/
		}


	if (temp_test_error)
		{
		printf("\nvref  edge detect \n");
		if (iovref_test_step == 0)
			{

		iovref_lef=((iovref_temp_value+training_step)<0x32)?((iovref_temp_value+training_step)):(0x32);
		iovref_temp_value=iovref_org;
			}
		if (iovref_test_step == 1)
			{

		iovref_rig=(iovref_temp_value>training_step)?((iovref_temp_value-training_step)):(0);
		iovref_temp_value=iovref_org;
			}
		iovref_test_step++;
	//	break;
		}
	else
		{
		printf("\niovref_lef1=%x\n",iovref_lef);
		printf("\niovref_test_step=%x\n",iovref_test_step);
		if (iovref_test_step == 0)
			{
	printf("\niovref_lef1_2=%x\n",(iovref_temp_value-training_step));
		iovref_lef=(iovref_temp_value>training_step)?((iovref_temp_value-training_step)):(0);
		iovref_temp_value=iovref_lef;
		if (iovref_lef == 0)
			{
			iovref_test_step++;
			iovref_temp_value=iovref_org;
			}
			}
		if (iovref_test_step == 1)
			{
		iovref_rig=((iovref_temp_value+training_step)<0x32)?(iovref_temp_value+training_step):(0x32);
		iovref_temp_value=iovref_rig;
			if (iovref_rig == 0x32)
			iovref_test_step++;
			}
		printf("\niovref_lef2=%x\n",iovref_lef);
		}
	{


wrr_reg((PREG_STICKY_REG8),iovref_org|(iovref_lef<<8)|((iovref_rig<<16))|(iovref_test_step<<24));
printf("\nddr4ram vref test will reboot use new dram vref setting==0x%08x\n ",(rdr_reg((unsigned int )(PREG_STICKY_REG8))));
char str[100];
sprintf(str,"ddr_test_cmd 0x17 %d 0 0 0 0x%x",global_ddr_clk,iovref_temp_value|((vref_dram_range&1)<<6));
printf("\nstr=%s\n",str);
run_command(str,0);
//run_command("ddr_test_cmd 0x17 1100 0 0 0xsoc 0xdram ",0);//
}
}
if (iovref_test_step >= 2)
{
printf("\n\n iovref  vddq=1.2v,if use other vddq ,please recount\n");
printf("\nddr4ram vref test finish iovref_test_step==0x%08x\n ",iovref_test_step);
iovref_org=(rdr_reg((unsigned int )((PREG_STICKY_REG8))))&0x3f;  //
iovref_lef=((rdr_reg((unsigned int )((PREG_STICKY_REG8))))>>8)&0x3f;
iovref_rig=((rdr_reg((unsigned int )((PREG_STICKY_REG8))))>>16)&0x3f;
iovref_test_step=((rdr_reg((unsigned int )((PREG_STICKY_REG8))))>>24)&0x3f;
iovref_mid=(iovref_lef+iovref_rig)/2;
if (vref_dram_range == 0)
{
 printf("iovref_org==0x%08x,%08dmV||iovref_lef==0x%08x,%08dmV||iovref_rig==0x%08x,%08dmV||iovref_mid0x%08x,%08dmV\n",
	iovref_org,((((((iovref_org&0X3F)*65)+6000)*1200)/10000)),iovref_lef,((((((iovref_lef&0X3F)*65)+6000)*1200)/10000)),
	iovref_rig,((((((iovref_rig&0X3F)*65)+6000)*1200)/10000)),iovref_mid,((((((iovref_mid&0X3F)*65)+6000)*1200)/10000)));
}
if (vref_dram_range)
{
 printf("iovref_org==0x%08x,%08dmV||iovref_lef==0x%08x,%08dmV||iovref_rig==0x%08x,%08dmV||iovref_mid0x%08x,%08dmV\n",
	iovref_org,((((((iovref_org&0X3F)*65)+4500)*1200)/10000)),iovref_lef,((((((iovref_lef&0X3F)*65)+4500)*1200)/10000)),
	iovref_rig,((((((iovref_rig&0X3F)*65)+4500)*1200)/10000)),iovref_mid,((((((iovref_mid&0X3F)*65)+4500)*1200)/10000)));
}
if (iovref_rig == 0x32)
{
printf("\n\n iovref  rig reach reg max\n");
}
if (iovref_rig == 0x0)
{
printf("\n\n iovref  lef reach reg min\n");
}
//char str2[100];
//sprintf(str2,"ddr_test_cmd 0x17 %d 0 0 0 0x%x",global_ddr_clk,iovref_org);
//printf("\nstr2=%s\n",str2);
//run_command(str2,0);
}


















		}



}






}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	#endif
	return 1;

}


int do_ddr4_test_dram_ac_vref(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
#if ( CONFIG_DDR_PHY>=P_DDR_PHY_905X)
///*
// unsigned int  start_addr=test_start_addr;
   printf("\nEnter Test ddr4 phy_ac or ddr3 dram data vref function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);


 //  unsigned int   loop = 1;
//   unsigned int   temp_count_i = 1;
//   unsigned int   temp_count_j= 1;
//    unsigned int   temp_count_k= 1;
   unsigned int   temp_test_error= 0;
  int training_seed=0;
  int training_step=0;

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_dram_ac_data=0;
 //  unsigned int   test_times=1;
   unsigned int   reg_add=0;
   unsigned int   reg_base_adj=0;
		  unsigned int   channel_a_en = 0;
	   unsigned int   channel_b_en = 0;
	   unsigned int   testing_channel = 0;
	   unsigned int   dxnlcdlr1[4];
	  // unsigned int   dxnlcdlr4[4];


	  #define  CHANNEL_A  0
	  #define  CHANNEL_B  1






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000
   #define DDR0_PUB_REG_BASE					0xc8836000
   #define DDR0_PUB_DX0GCR4      ( DDR0_PUB_REG_BASE + ( 0x1c4  << 2 ) )
   #define DDR0_PUB_DX1GCR4     ( DDR0_PUB_REG_BASE + ( 0x204  << 2 ) )
   #define DDR0_PUB_DX2GCR4      ( DDR0_PUB_REG_BASE + ( 0x244  << 2 ) )
   #define DDR0_PUB_DX3GCR4      ( DDR0_PUB_REG_BASE + ( 0x284  << 2 ) )
   #define DDR0_PUB_DX0GCR5      ( DDR0_PUB_REG_BASE + ( 0x1c5  << 2 ) )
   #define DDR0_PUB_DX1GCR5      ( DDR0_PUB_REG_BASE + ( 0x205  << 2 ) )
   #define DDR0_PUB_DX2GCR5      ( DDR0_PUB_REG_BASE + ( 0x245  << 2 ) )
   #define DDR0_PUB_DX3GCR5      ( DDR0_PUB_REG_BASE + ( 0x285  << 2 ) )

//#define DDR0_PUB_IOVCR0        ( DDR0_PUB_REG_BASE + ( 0x148 << 2 ) ) // R/W - IO VREF Control Register 0
//#define DDR0_PUB_IOVCR1        ( DDR0_PUB_REG_BASE + ( 0x149 << 2 ) ) // R/W - IO VREF Control Register 1


	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

	//   unsigned int   ac_bdlr_lef[10];
	//   unsigned int   ac_bdlr_rig[10];
	    int   iovref_temp_value;
	 //    int   iovref_temp_reg_value;
	//    unsigned int  reg_seed_value;
//	   unsigned int   temp_reg_value;
 int   iovref_org;
	      int   iovref_lef;
		   int   iovref_rig;
	  //  unsigned int   temp_test_error;
	//	unsigned int temp_i=0;
	//	unsigned int temp_j=0;
		//unsigned int reg_add=0;
//		static unsigned int training_enabled=1;

//	 iovref_lef=0x49;
// printf("\n\n iovref  org                     ==0x%08x   %08dmV\n",iovref_lef,(((((iovref_lef&0X3F)*7)+440)*3)/2)+1);
//#define DDR_TEST_ACLCDLR


	 if (argc == 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0))

	{channel_a_en = 1;
	}
	else if   ((strcmp(argv[1], "b") == 0)||(strcmp(argv[1], "B") == 0))

	{channel_b_en = 1;
	}
	else
		{
	goto usage;
		}
		}
		if (argc > 2)
		{
    if ((strcmp(argv[1], "a") == 0) || (strcmp(argv[1], "A") == 0) || (strcmp(argv[2], "a") == 0) || (strcmp(argv[2], "A") == 0))

	{channel_a_en = 1;
	}
     if   ((strcmp(argv[1], "b") == 0) || (strcmp(argv[1], "B") == 0) || (strcmp(argv[2], "b") == 0) || (strcmp(argv[2], "B") == 0))

	{channel_b_en = 1;
	}
			}
		   ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
  if (argc >3) {
	ddr_test_size = simple_strtoul(argv[3], &endp, 16);
        if (*argv[3] == 0 || *endp != 0)
			{
			ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
			}

	}
    if (argc >4) {
	test_dram_ac_data = simple_strtoul(argv[4], &endp, 16);
        if (*argv[4] == 0 || *endp != 0)
			{
			test_dram_ac_data = 0;
			}
	if (  test_dram_ac_data )
		  test_dram_ac_data = 1;

	}
	training_seed = 0;
	    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 16);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed =0;// 0x2e;
			}


	}


 training_step = 0;
			if (argc >6) {
	training_step = simple_strtoul(argv[6], &endp, 16);
        if (*argv[6] == 0 || *endp != 0)
			{
			training_step = 0;
			}



	}
			 int vref_all=0;
			    if (argc >7) {
   vref_all = simple_strtoul(argv[7], &endp, 16);
        if (*argv[7] == 0 || *endp != 0)
			{
			vref_all =0;// 0x2e;
			}}
					 int vref_lcdlr_offset=0;
			    if (argc >8) {
   vref_lcdlr_offset = simple_strtoul(argv[8], &endp, 16);
        if (*argv[8] == 0 || *endp != 0)
		{
			vref_lcdlr_offset =0;
			}}
 int soc_dram_hex_dec=0;
if (argc >9)
{
	soc_dram_hex_dec = simple_strtoul(argv[9], &endp, 16);
	if (*argv[9] == 0 || *endp != 0) {
		soc_dram_hex_dec = 0;
	}
}
if (training_seed ==0) // 0x2e;
{training_seed=0x9;
}
if (soc_dram_hex_dec)
{
    if (argc >5) {
   training_seed = simple_strtoul(argv[5], &endp, 0);
        if (*argv[5] == 0 || *endp != 0)
			{
			training_seed =0;// 0x2e;
			}


	}
	if (training_seed ==0) // 0x2e;
{training_seed=50;
}
	if (training_seed<45)
	training_seed=45;
if (training_seed>88)
	training_seed=88;
training_seed =(((training_seed*1000-44070)/698));

}



 printf("\n\n iovref  training_seed             ==0x%08x   %08dmV\n",training_seed,(((((training_seed&0X3F)*7)+440)*3)/2)+1);
		 printf("\nchannel_a_en== 0x%08x\n", channel_a_en);
		 printf("\nchannel_b_en== 0x%08x\n", channel_b_en);
		  printf("\nddr_test_size== 0x%08x\n", ddr_test_size);
		   printf("\ntest_dram_ac_data== 0x%08x\n", test_dram_ac_data);
		      printf("\nvref_all== 0x%08x\n", vref_all);
			    printf("\nvref_lcdlr_offset== 0x%08x\n", vref_lcdlr_offset);
if ( channel_a_en)
{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}
if ( channel_b_en)
{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

//save and print org training dqs value
if (channel_a_en || channel_b_en)
{
	//dcache_disable();
 //serial_puts("\ndebug for ddrtest ,jiaxing disable dcache");
}////save and print org training  value



{
////tune and save training dqs value
if (channel_a_en || channel_b_en)

{
for ((testing_channel=0);(testing_channel<(channel_a_en+channel_b_en));(testing_channel++))
{

if (( channel_a_en) && ( channel_b_en == 0))
{
reg_base_adj=CHANNEL_A_REG_BASE;
}
else if(( channel_b_en)&&( channel_a_en==0))
{
reg_base_adj=CHANNEL_B_REG_BASE;
}
else if ((channel_a_en+channel_b_en)==2)
 {
if ( testing_channel == CHANNEL_A)
   {
reg_base_adj=CHANNEL_A_REG_BASE;
   }
else if( testing_channel==CHANNEL_B)
   {
reg_base_adj=CHANNEL_B_REG_BASE;
   }
 }

if (reg_base_adj == CHANNEL_A_REG_BASE)
{
printf("\ntest A channel data lane\n");
}
else
{
printf("\ntest B channel data lane\n");
}


{


#define wrr_reg(addr, data)	(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))=(data)  //wr_reg(addr, data)
#define rdr_reg(addr)		 (unsigned int )(*((volatile  unsigned int  *)((unsigned long)(unsigned int )addr)))  //rd_reg(addr)
	   unsigned int   dxnmdlr=0;
	reg_add=DDR0_PUB_DX0MDLR0+reg_base_adj;
	dxnmdlr=((rdr_reg((unsigned int )reg_add))>>16)&0x1ff;
//	reg_seed_value=(training_seed|(0x0<<8)|(0x0<<16)|(0x0<<24));
printf("\ndxnmdlr==0x%08x\n ",dxnmdlr);
//turn off ddr4 phy read vref gate,only output ac lane vref
wrr_reg((((DDR0_PUB_DX0GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX0GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX1GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX1GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX2GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX2GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_DX3GCR4))),((rdr_reg((unsigned int )(DDR0_PUB_DX3GCR4)))&(~(1<<28)))|(7<<25)|(0xf<<2));
wrr_reg((((DDR0_PUB_IOVCR0))),0x00090909|(0x1f<<24));
wrr_reg((((DDR0_PUB_IOVCR1))),0x109);
printf("\nDDR0_PUB_DX0GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX0GCR4))));
printf("\nDDR0_PUB_DX1GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX1GCR4))));
printf("\nDDR0_PUB_DX2GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX2GCR4))));
printf("\nDDR0_PUB_DX3GCR4==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_DX3GCR4))));
printf("\nDDR0_PUB_IOVCR0==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_IOVCR0))));
printf("\nDDR0_PUB_IOVCR1==0x%08x\n ",(rdr_reg((unsigned int )(DDR0_PUB_IOVCR1))));
	   unsigned int   temp_i=0;

for ((  temp_i=0);(temp_i<4);( temp_i++))
{
{
dxnlcdlr1[temp_i]=(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)+temp_i*(DDR0_PUB_DX1LCDLR1-DDR0_PUB_DX0LCDLR1))));

printf("\ndxnlcdlr1[%08x]==0x%08x,dxnlcdlr1[%08x]==0x%08x\n ",temp_i,dxnlcdlr1[temp_i],temp_i,dxnlcdlr1[temp_i]);

}
}
reg_add=DDR0_PUB_IOVCR0+reg_base_adj;
iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_org=((iovref_temp_value)&0xff);
//	 iovref_lef=0x49;

{
 printf("reg_add==0x%08x,value==0x%08x, iovref  org ==0x%08x   %08dmV\n",reg_add,
	iovref_temp_value,iovref_org,((((((iovref_temp_value&0X3F)*7)+440)*3)/2)+1)*15/15);
}


wrr_reg((reg_add),iovref_temp_value);  //
iovref_lef=(iovref_org)&0xff;
iovref_rig=(iovref_org)&0xff;

}

printf("\ntraining_step==0x%08x\n ",training_step);


{






{

iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);

while (iovref_temp_value>0x0)
{
temp_test_error=0;
iovref_temp_value=iovref_temp_value-training_step;
if (iovref_temp_value<training_step)
	iovref_temp_value=0;
printf("\niovref lef temp==0x%08x\n ",iovref_temp_value);


wrr_reg((reg_add),(0x1f000000|iovref_temp_value|(iovref_temp_value<<8)|(iovref_temp_value<<16)));

printf("\n reg_add 0x%08x== 0x%08x\n ",reg_add,rdr_reg((unsigned int )reg_add));

temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX1LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX2LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX3LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //


printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX1LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX1LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX2LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX2LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX3LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX3LCDLR1+reg_base_adj)))));

 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //

		}

		}

		}

	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX1LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX2LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX3LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //


printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX1LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX1LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX2LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX2LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX3LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX3LCDLR1+reg_base_adj)))));

 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //

		}

		}

		}
	if (temp_test_error)
		{
		printf("\nvref down edge detect \n");
		iovref_temp_value=iovref_temp_value+training_step;
		break;
		}
}

printf("\n down edge detect \n");
printf("\n\n iovref                       down edge==0x%08x\n ",iovref_temp_value);
iovref_lef=iovref_temp_value;

wrr_reg((reg_add),iovref_org);  //
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //



}

{

iovref_temp_value=rdr_reg((unsigned int )reg_add);
iovref_temp_value=((iovref_temp_value)&0xff);

while (iovref_temp_value<0x3f)
{
temp_test_error=0;
iovref_temp_value=iovref_temp_value+training_step;
if (iovref_temp_value>0x3f)
	iovref_temp_value=0x3f;
printf("\niovref rig temp==0x%08x\n ",iovref_temp_value);

wrr_reg((reg_add),(0x1f000000|iovref_temp_value|(iovref_temp_value<<8)|(iovref_temp_value<<16)));

printf("\n reg_add 0x%08x== 0x%08x\n ",reg_add,rdr_reg((unsigned int )reg_add));

temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX1LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX2LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX3LCDLR1+reg_base_adj)))+vref_lcdlr_offset));  //


printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX1LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX1LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX2LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX2LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX3LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX3LCDLR1+reg_base_adj)))));

 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //

		}

		}

		}

	if (vref_lcdlr_offset)
		{
{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX0LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX1LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX2LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),((rdr_reg((unsigned int )(DDR0_PUB_DX3LCDLR1+reg_base_adj)))-vref_lcdlr_offset));  //


printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX0LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX0LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX1LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX1LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX2LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX2LCDLR1+reg_base_adj)))));
printf("\n reg_add 0x%08x== 0x%08x\n ",((DDR0_PUB_DX3LCDLR1+reg_base_adj)),
		(rdr_reg((unsigned int )((DDR0_PUB_DX3LCDLR1+reg_base_adj)))));

 temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);


		{
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //

		}

		}

		}
	if (temp_test_error)
		{
		printf("\nvref up edge detect \n");
		iovref_temp_value=iovref_temp_value-training_step;
		break;
		}
}

printf("\n up edge detect \n");
printf("\n\n iovref                       up edge==0x%08x\n ",iovref_temp_value);
iovref_rig=iovref_temp_value;

wrr_reg((reg_add),iovref_org);  //
wrr_reg((DDR0_PUB_DX0LCDLR1+reg_base_adj),dxnlcdlr1[0]);  //
wrr_reg((DDR0_PUB_DX1LCDLR1+reg_base_adj),dxnlcdlr1[1]);  //
wrr_reg((DDR0_PUB_DX2LCDLR1+reg_base_adj),dxnlcdlr1[2]);  //
wrr_reg((DDR0_PUB_DX3LCDLR1+reg_base_adj),dxnlcdlr1[3]);  //



}



{
	printf("\n\n iovref  vddq=1.5v,if use other vddq ,please recount\n");
printf("\n vddq=1.5v iovref  ac+dram_data org==0x%08x   %08dmV||down edge==0x%08x %08dmV||up edge==0x%08x %08dmV||mid==0x%08x   %08dmV\n",
	iovref_org,(((((((iovref_org&0X3F)*7)+440)*3)/2)+1)*15/15),iovref_lef,(((((((iovref_lef&0X3F)*7)+440)*3)/2)+1)*15/15),
	iovref_rig,(((((((iovref_rig&0X3F)*7)+440)*3)/2)+1)*15/15),((iovref_lef+iovref_rig)/2),
	(((((((((iovref_lef+iovref_rig)/2)&0X3F)*7)+440)*3)/2)+1)*15/15)
	);

if (iovref_lef == 0x0)
{
printf("\n\n iovref   down edge reach  reg limited\n");
}
if (iovref_rig == 0x3f)
{
printf("\n\n iovref   up edge reach  reg limited\n");
}
}














		}



}






}

}




 return 0;

usage:
	cmd_usage(cmdtp);
	//*/
	#endif
	return 1;

}
//

int pll_convert_to_ddr_clk(unsigned int ddr_pll)
{
ddr_pll=ddr_pll&0xfffff;
#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
//unsigned int ddr_clk = 2*((((24 * ((ddr_pll>>4)&0x1ff))/((ddr_pll>>16)&0x1f))>>((((ddr_pll>>0)&0x3)==3)?(2):(((ddr_pll>>0)&0x3))))/(((ddr_pll>>2)&0x3)+1));
unsigned int ddr_clk = 2*((((24 * ((ddr_pll>>4)&0x1ff))/((ddr_pll>>16)&0x1f))>>((((ddr_pll>>0)&0x3)==3)?(2):(((ddr_pll>>0)&0x3))))>>((((ddr_pll>>2)&0x3)==3)?(2):(((ddr_pll>>2)&0x3))));

	#else
unsigned int ddr_clk = 2*(((24 * (ddr_pll&0x1ff))/((ddr_pll>>9)&0x1f))>>((ddr_pll>>16)&0x3));
	#endif
return ddr_clk;
}

int ddr_clk_convert_to_pll(unsigned int ddr_clk)
{
unsigned int ddr_pll=0x10221;
		/* set ddr pll reg */
	if ((ddr_clk >= 40) && (ddr_clk < 750)) {
		//							OD			N					M
		ddr_pll= (2 << 16) | (1 << 9) | ((((ddr_clk/6)*6)/12) << 0);
	}
	else if((ddr_clk >= 750) && (ddr_clk < 2000)) {
		//							OD			N					M
		ddr_pll= (1 << 16) | (1 << 9) | ((((ddr_clk/12)*12)/24) << 0);
	}

	#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
	 ddr_pll=0x00104c5;
		/* set ddr pll reg */
		/*
	if ((ddr_clk >= 40) && (ddr_clk < 750)) {
		//							OD			N					M
		ddr_pll= (2 << 2) | (1 << 16) | ((((ddr_clk/6)*6)/12) << 4);
	}
	else if((ddr_clk >= 750) && (ddr_clk < 2000)) {
		//							OD			N					M
		ddr_pll= (1 << 2) | (1 << 16) | ((((ddr_clk/12)*12)/24) << 4);
	}
*/
	if ((ddr_clk < 200)) {
		//							OD1			OD			N					M
		ddr_pll= (2 << 0) | (3 << 2) | (1 << 16) | ((((ddr_clk*6)/6)/3) << 4);
	}
	else if ((ddr_clk>= 200) && (ddr_clk< 400)) {
		//							OD1			OD			N					M
		ddr_pll= (2 << 0) | (1 << 2) | (1 << 16) | ((((ddr_clk*6)/6)/6) << 4);
	}
	else if ((ddr_clk>= 400) && (ddr_clk < 800)) {
		//							OD1			OD			N					M
		ddr_pll= (1 << 0) | (1 << 2) | (1 << 16) | ((((ddr_clk*12)/12)/12) << 4);
	}
	else if ((ddr_clk >= 800) && (ddr_clk < 2000)) {
		//							OD1			OD			N					M
		ddr_pll= (0 << 0) | (1 << 2) | (1 << 16) | ((((ddr_clk*12)/12)/24) << 4);
	}
	#endif
return ddr_pll;
}

int do_ddr4_test_dram_clk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
///*
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }
	 char *endp;

 #define TEST_DRAM_CLK_USE_ENV  1


//return 1;



printf("\ntune ddr CLK use uboot env\n");

	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000
	   #define  DDR_TEST_MIN_FREQ_LIMITED  50
	  #define  DDR_TEST_MIN_FREQ  300
	    #define  DDR_TEST_MAX_FREQ  1500

	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;
unsigned int start_freq=DDR_TEST_MIN_FREQ;
unsigned int end_freq=DDR_TEST_MAX_FREQ;
unsigned int test_loops=1;
	 if (argc == 1)
		{
		printf("\nplease read help\n");
		ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
		start_freq=DDR_TEST_MIN_FREQ;
				 end_freq=DDR_TEST_MAX_FREQ;

		}

	  if (argc == 2)
		{
		ddr_test_size = simple_strtoul(argv[1], &endp, 0);
		start_freq=DDR_TEST_MIN_FREQ;
				 end_freq=DDR_TEST_MAX_FREQ;
		}
		if (argc== 3)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 0);
		start_freq= simple_strtoul(argv[2], &endp, 0);
				 end_freq=DDR_TEST_MAX_FREQ;

		}
			if (argc== 4)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 0);
		start_freq= simple_strtoul(argv[2], &endp, 0);
				 end_freq=simple_strtoul(argv[3], &endp, 0);

		}
						if (argc> 4)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 0);
		start_freq= simple_strtoul(argv[2], &endp, 0);
				 end_freq=simple_strtoul(argv[3], &endp, 0);
				 test_loops=simple_strtoul(argv[4], &endp, 0);
		}
unsigned int temp_test_error=0x0;
	   unsigned int ddr_pll=0;
	unsigned int ddr_clk_org=0;
	unsigned int ddr_clk_hope_test=0;
	 ddr_pll = rd_reg(AM_DDR_PLL_CNTL);
	//ddr_pll=ddr_pll_org;
	unsigned int ddr_clk = pll_convert_to_ddr_clk(ddr_pll);
	ddr_clk_org=ddr_clk;
	   printf("\nddr_clk== %dMHz\n", ddr_clk);
	   printf("\nstart_freq== %dMHz\n", start_freq);
	   printf("\nend_freq== %dMHz\n", end_freq);
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
  //	{
	//	wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
	//	ddr_udelay(2000);
	//}


unsigned int freq_table_test_value[(DDR_TEST_MAX_FREQ)/12]; // step =0 init  ,1 test fail, ,2 test pass,3 test skip;
//  char char_freq_name_table[30];
 //  const char *p_char_freq_table;

 const char *p_char_ddr_test_step;
 const char * p_char_freq_org;
 char char_freq_org[30];
 int  ddr_feq_test_step=0; // step =0 init ,1 going ,2 done;

 const char * p_char_freq_name_table;
  char char_freq_name_table[30];
  char char_cmd_table[100];
	char * p_char_store_boot;
//  char char_freq_store_boot[200];

 //const char *p_freq_table_int;
//char char_ddr_feq_test_step[]="ddr_feq_test_step";
// const char *varname;
// const char *varvalue;
unsigned int temp_count=0;
 unsigned int temp_count_sub=0;


//
p_char_ddr_test_step= getenv("ddr_feq_test_step");
 if (p_char_ddr_test_step)
	{
	printf("%s",p_char_ddr_test_step);

  ddr_feq_test_step = simple_strtoul(p_char_ddr_test_step, &endp, 0);
	printf("ddr_feq_test_step=%d\n",ddr_feq_test_step);
	}
 if (ddr_feq_test_step) {
p_char_freq_org= getenv("ddr_feq_org");
 if (p_char_freq_org)
	{
	printf("%s",p_char_freq_org);

  ddr_clk_org = simple_strtoul(p_char_freq_org, &endp, 10); //must use 10 ,freq  0792 maybe not read sussceful use 0 auto read
	printf("ddr_clk_org=%d\n",ddr_clk_org);
	}
 }
  if (ddr_feq_test_step == 0)
	{
	ddr_feq_test_step=1;
	ddr_clk_org=ddr_clk;
	   sprintf(char_freq_org,"%04d",ddr_clk);
  printf("\nddr_org_freq=%s\n",char_freq_org);
	setenv("ddr_feq_org", char_freq_org);



  temp_count=(DDR_TEST_MIN_FREQ_LIMITED/12);
  while (temp_count<(DDR_TEST_MAX_FREQ/12)) {

  // sprintf(freq_table,"%s%04d %01d %01d  ",freq_table,(temp_count*12),0,0);
   sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);
	setenv(char_freq_name_table, "0");
	setenv("ddr_feq_test_step", "1");
	temp_count++;
	}
	temp_count=(DDR_TEST_MIN_FREQ_LIMITED/12);
  while (temp_count<((start_freq)/12)) {

  // sprintf(freq_table,"%s%04d %01d %01d  ",freq_table,(temp_count*12),0,0);
   sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);
	setenv(char_freq_name_table, "3");
	setenv("ddr_feq_test_step", "1");
	temp_count++;
	}
    while (temp_count>((end_freq)/12)) {

  // sprintf(freq_table,"%s%04d %01d %01d  ",freq_table,(temp_count*12),0,0);
   sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);
	setenv(char_freq_name_table, "3");
	setenv("ddr_feq_test_step", "1");
	temp_count++;
	}

p_char_store_boot= getenv("storeboot");
if (p_char_store_boot)
printf("storeboot   %s\n",p_char_store_boot);
	sprintf(char_cmd_table,"ddr_test_cmd 0x1c  0x%08x %d %d %d;%s;",ddr_test_size,start_freq,end_freq,test_loops,p_char_store_boot);
	setenv("storeboot", char_cmd_table);

	 run_command("save",0);


//run_command("save",0);
//temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
//temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
//if(temp_test_error)
{
}

	}

    if (ddr_feq_test_step == 1)
	{

	 temp_count=(DDR_TEST_MIN_FREQ_LIMITED/12);
  while (temp_count<((DDR_TEST_MAX_FREQ)/12)) {

	sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);

		p_char_freq_name_table= getenv(char_freq_name_table);
	 if (p_char_freq_name_table)
	{
	printf("%s\n",p_char_freq_name_table);

  freq_table_test_value[temp_count] = simple_strtoul(p_char_freq_name_table, &endp, 0);
	printf("%s | %d\n",char_freq_name_table,freq_table_test_value[temp_count]);
	}
temp_count++;
	}

temp_count=(DDR_TEST_MIN_FREQ_LIMITED/12);
  while (temp_count<((DDR_TEST_MAX_FREQ)/12)) {
		ddr_clk_hope_test=(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12)));
		if (freq_table_test_value[temp_count] ==1)
			{
			temp_count_sub=temp_count+1;
			while ((pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count_sub*12))) ==
			(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))))
				{temp_count_sub=temp_count_sub+1;
				}
			 while (temp_count_sub<((DDR_TEST_MAX_FREQ)/12)) {
				sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count_sub*12))));
				  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);
				  // freq_table_test_value[temp_count_sub] =1;
								setenv(char_freq_name_table, "3");
								temp_count_sub++;
				}
				{
ddr_feq_test_step++;
setenv("ddr_feq_test_step", "2");
 run_command("save",0);

				}
					{ddr_clk_hope_test=ddr_clk_org;
	}
sprintf(char_cmd_table,"ddr_test_cmd 0x17 %d 0 0 0",ddr_clk_hope_test);
printf("\nchar_cmd_table=%s\n",char_cmd_table);
run_command(char_cmd_table,0);

		}
		if (freq_table_test_value[temp_count] ==0)
			{
			if ((ddr_clk_hope_test) != (ddr_clk))
				{
sprintf(char_cmd_table,"ddr_test_cmd 0x17 %d 0 0 0",ddr_clk_hope_test);
printf("\nchar_cmd_table=%s\n",char_cmd_table);
run_command(char_cmd_table,0);
			}
			if ((ddr_clk_hope_test) == (ddr_clk))
				{

 sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);
   freq_table_test_value[temp_count] =1;
 setenv(char_freq_name_table, "1");
 run_command("save",0);

	temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
	while (test_loops--) {
		temp_test_error=temp_test_error+ddr_test_s_cross_talk_pattern(ddr_test_size);
		}
//temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);

   sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);
  if (temp_test_error)
{
 freq_table_test_value[temp_count] =1;
 setenv(char_freq_name_table, "1");
}
else
{
 freq_table_test_value[temp_count] =2;
 setenv(char_freq_name_table, "2");
}
 run_command("save",0);

ddr_clk_hope_test=(temp_count*12)+12;
while ((pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(ddr_clk_hope_test))) ==
			(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))))
{ddr_clk_hope_test=ddr_clk_hope_test+12;
}
 if (temp_test_error)
	{ddr_clk_hope_test=ddr_clk_org;
	}
sprintf(char_cmd_table,"ddr_test_cmd 0x17 %d 0 0 0",ddr_clk_hope_test);
printf("\nchar_cmd_table=%s\n",char_cmd_table);
run_command(char_cmd_table,0);
				}

		}





		temp_count++;
	}
ddr_feq_test_step++;
setenv("ddr_feq_test_step", "2");
run_command("save",0);

	}

	   if (ddr_feq_test_step >= 2)
	{
	printf("\nfinish test ddr_feq_test_step=%d\n",ddr_feq_test_step);
		temp_count=(DDR_TEST_MIN_FREQ_LIMITED/12);
  while (temp_count<((DDR_TEST_MAX_FREQ)/12)) {

	sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
  printf("\nchar_freq_name_table=%s\n",char_freq_name_table);

		p_char_freq_name_table= getenv(char_freq_name_table);
	 if (p_char_freq_name_table)
	{
	printf("%s\n",p_char_freq_name_table);

  freq_table_test_value[temp_count] = simple_strtoul(p_char_freq_name_table, &endp, 0);
	printf("%s | %d\n",char_freq_name_table,freq_table_test_value[temp_count]);
	}
temp_count++;
	}

printf("\nprint test ddr_feq_test_result!!!\n");
   temp_count=(DDR_TEST_MIN_FREQ_LIMITED/12);
  while (temp_count<((DDR_TEST_MAX_FREQ)/12)) {

	sprintf(char_freq_name_table,"ddr_fre_%04d",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))));
		p_char_freq_name_table= getenv(char_freq_name_table);
	 if (p_char_freq_name_table)
	{
 //	printf("%s\n",p_char_freq_name_table);

  freq_table_test_value[temp_count] = simple_strtoul(p_char_freq_name_table, &endp, 0);
 //printf("%d\n",freq_table_test_value[temp_count]);
 if ( (freq_table_test_value[temp_count]) == 0) {
	printf("%04d  no init     %d \n",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))),freq_table_test_value[temp_count]);
	}
	  if ( (freq_table_test_value[temp_count]) == 1) {
	printf("%04d  fail      %d\n",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))),freq_table_test_value[temp_count]);
	}
   if ( (freq_table_test_value[temp_count]) == 2) {
	printf("%04d  pass      %d\n",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))),freq_table_test_value[temp_count]);
	}
	    if ( (freq_table_test_value[temp_count]) >= 3) {
	printf("%04d  skip test %d \n",(pll_convert_to_ddr_clk(ddr_clk_convert_to_pll(temp_count*12))),freq_table_test_value[temp_count]);
	}
temp_count++;
	}
		}

		}
 //sprintf(str,"ddr_test_ac_bit_setup_hold_window  a 0  0x%08x  %d  0x%08x",ddr_test_size,test_ac_setup_hold,( lane_step));
//	printf("\nstr=%s\n",str);




 //sprintf(str, "%lx", value);
//  setenv("env_ddrtest", str);


//run_command("save",0);





//*/
  return 1;

}
int update_ddr_zq(unsigned int zq0pr)
{

wr_reg( DDR0_PUB_ZQ0PR,zq0pr);
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2)|(1<<27));
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))&(~((1<<2)|(1<<27))));
	 printf("\nupdate zq zq0pr=0x%08x,zq0dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ0PR),rd_reg(DDR0_PUB_ZQ0DR));
return rd_reg(DDR0_PUB_ZQ0PR);
}

int do_ddr_test_ddr_max_freq(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr max frequency  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);



{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   add_freq=1;
   unsigned int   sub_freq=1;
	 unsigned int   max_freq=792;
	 unsigned int   min_freq=792;
	unsigned int   loop_max_freq=792;
	 unsigned int    loop_min_freq=792;

	   unsigned int ddr_pll=0x10221;
	unsigned int ddr_clk_org=792;
	unsigned int ddr_pll_org = rd_reg(AM_DDR_PLL_CNTL);
	ddr_pll=ddr_pll_org;
	unsigned int ddr_clk = pll_convert_to_ddr_clk(ddr_pll);
	ddr_clk_org=ddr_clk;
		printf("\nddr_clk_org== %dMHz\n", ddr_clk_org);

	unsigned int zq0pr = rd_reg(DDR0_PUB_ZQ0PR);
	printf("\nddr_zq0pr== 0x%08x\n", zq0pr);

	   ddr_pll = ddr_clk_convert_to_pll(ddr_clk);


	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}






	     max_freq=ddr_clk_org;
	     min_freq=ddr_clk_org;




	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;




	 if (argc == 1)
		{
		ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
		test_loop=1;
				 add_freq=1;
				  sub_freq=1;
		}

	  if (argc == 2)
		{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop=1;
				 add_freq=1;
				  sub_freq=1;
		}
		if (argc== 3)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);
				 add_freq=1;
				  sub_freq=1;
		}
		if (argc >= 4)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);
				add_freq=1;
			        sub_freq=1;
                    if ((simple_strtoul(argv[3], &endp, 16)) == 1)
						{
				 add_freq=1;
			        sub_freq=0;
						}
		     else if((simple_strtoul(argv[3], &endp, 16))==0)
				{
					add_freq=0;
			        sub_freq=1;
				}
		}




	unsigned int  	temp_test_error=0;
while (test_times<(test_loop+1))
{
printf("\ntest_times== %d times\n", test_times);

 if (add_freq)
	{

	while (ddr_clk<1500)
		{
			temp_test_error=0;
	ddr_clk=ddr_clk+12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
		 printf("\ntesting_ddr_clk== %dMHz\n", ddr_clk);
	}

temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
max_freq=ddr_clk-12;
  printf("\nmax_ddr_clk== %dMHz\n", max_freq);
	temp_test_error=0;
  break;
}

		}

	while (ddr_clk>ddr_clk_org)
		{
	ddr_clk=ddr_clk-12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}
		}
printf("\nback to  org_ddr_clk== %dMHz\n", ddr_clk);


	}

 if (sub_freq)
	{

	while (ddr_clk>24)
		{
			temp_test_error=0;
	ddr_clk=ddr_clk-12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
		 printf("\ntesting_ddr_clk== %dMHz\n", ddr_clk);
	}

temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
min_freq=ddr_clk+12;
  printf("\nmin_ddr_clk== %dMHz\n", min_freq);
	temp_test_error=0;
  break;
}

		}

	while (ddr_clk<ddr_clk_org)
		{
	ddr_clk=ddr_clk+12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}
		}
printf("\nback to  org_ddr_clk== %dMHz\n", ddr_clk);


	}

if (test_times == 1)
{

	  loop_max_freq=max_freq;
	  loop_min_freq=min_freq;
}
else
{
if (loop_max_freq>max_freq)
{
loop_max_freq=max_freq;
}
if (min_freq>loop_min_freq)
{
loop_min_freq=min_freq;
}
}
test_times++;

}

 printf("\nloop_min_freq== %dMHz,pll==0x%08x\n", loop_min_freq,ddr_clk_convert_to_pll(loop_min_freq));
 printf("\nloop_max_freq== %dMHz,pll==0x%08x\n", loop_max_freq,ddr_clk_convert_to_pll(loop_max_freq));





 return loop_max_freq;



}


int do_ddr_test_ddr_zq(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr zq  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);



{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int   add_freq=1;
   unsigned int   sub_freq=1;
	 unsigned int   max_freq=792;
	 unsigned int   min_freq=792;
	unsigned int   loop_max_freq=792;
	 unsigned int    loop_min_freq=792;

	   unsigned int ddr_pll=0x10221;
	unsigned int ddr_clk_org=792;
	unsigned int ddr_pll_org = rd_reg(AM_DDR_PLL_CNTL);
	ddr_pll=ddr_pll_org;
	unsigned int ddr_clk = pll_convert_to_ddr_clk(ddr_pll);
	ddr_clk_org=ddr_clk;
		printf("\nddr_clk_org== %dMHz\n", ddr_clk_org);

	unsigned int zq0pr_org = rd_reg(DDR0_PUB_ZQ0PR);
//	unsigned int zq0pr_best;
	unsigned int zq0pr= rd_reg(DDR0_PUB_ZQ0PR);
//	zq0pr_best=zq0pr_org;
	unsigned int zq0pr_drv_max;
	unsigned int zq0pr_drv_min;
	unsigned int zq0pr_odt_max;
	unsigned int zq0pr_odt_min;
	unsigned int zq0pr_drv_flag=1;
	unsigned int zq0pr_odt_flag=1;


	printf("\nzq0pr_org== 0x%08x\n", zq0pr_org);

	   ddr_pll = ddr_clk_convert_to_pll(ddr_clk);


	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}






	     max_freq=ddr_clk_org;
	     min_freq=ddr_clk_org;





	  #define  DDR_CORSS_TALK_TEST_SIZE   0x20000
	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;




	 if (argc == 1)
		{
		ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
		test_loop=1;
				 add_freq=1;
				  sub_freq=1;
		}

	  if (argc == 2)
		{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop=1;
				 add_freq=1;
				  sub_freq=1;
		}
		if (argc== 3)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);
				 add_freq=1;
				  sub_freq=1;
		}
		if (argc >= 4)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);
				add_freq=1;
			        sub_freq=1;
                    if ((simple_strtoul(argv[3], &endp, 16)) == 1)
						{
				 add_freq=1;
			        sub_freq=0;
						}
		     else if((simple_strtoul(argv[3], &endp, 16))==0)
				{
					add_freq=0;
			        sub_freq=1;
				}
		}

      if (argc>4)
		{
                          if ((simple_strtoul(argv[4], &endp, 16)) == 1)
						{
				 zq0pr_drv_flag=0;
			        zq0pr_odt_flag=1;
						}
		     else if((simple_strtoul(argv[4], &endp, 16))==0)
				{
					zq0pr_drv_flag=1;
			        zq0pr_odt_flag=0;
				}

		}


	unsigned int  	temp_test_error=0;


	test_times=1;
	temp_test_error=0;
while (test_times<(test_loop+1))
{
printf("\ntest_times== %d times\n", test_times);

 if (add_freq)
	{

	while (ddr_clk<1500)
		{
			temp_test_error=0;
	ddr_clk=ddr_clk+12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
		 printf("\ntesting_ddr_clk== %dMHz\n", ddr_clk);
	}

temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
max_freq=ddr_clk-12;
  printf("\nmax_ddr_clk== %dMHz\n", max_freq);
	temp_test_error=0;
  break;
}

		}

	while (ddr_clk>ddr_clk_org)
		{
	ddr_clk=ddr_clk-12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}
		}
printf("\nback to  org_ddr_clk== %dMHz\n", ddr_clk);


	}

 if (sub_freq)
	{

	while (ddr_clk>24)
		{
			temp_test_error=0;
	ddr_clk=ddr_clk-12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
		 printf("\ntesting_ddr_clk== %dMHz\n", ddr_clk);
	}

temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
min_freq=ddr_clk+12;
  printf("\nmin_ddr_clk== %dMHz\n", min_freq);
	temp_test_error=0;
  break;
}

		}

	while (ddr_clk<ddr_clk_org)
		{
	ddr_clk=ddr_clk+12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}
		}
printf("\nback to  org_ddr_clk== %dMHz\n", ddr_clk);


	}

if (test_times == 1)
{

	  loop_max_freq=max_freq;
	  loop_min_freq=min_freq;
}
else
{
if (loop_max_freq>max_freq)
{
loop_max_freq=max_freq;
}
if (min_freq>loop_min_freq)
{
loop_min_freq=min_freq;
}
}
test_times++;

}

 printf("\nloop_min_freq== %dMHz,pll==0x%08x\n", loop_min_freq,ddr_clk_convert_to_pll(loop_min_freq));
 printf("\nloop_max_freq== %dMHz,pll==0x%08x\n", loop_max_freq,ddr_clk_convert_to_pll(loop_max_freq));


	while (ddr_clk<loop_max_freq)
		{
	ddr_clk=ddr_clk+12;
	ddr_pll = ddr_clk_convert_to_pll(ddr_clk);
	{

		wr_reg(AM_DDR_PLL_CNTL, (((rd_reg(AM_DDR_PLL_CNTL))&(~(0xfffff)))|(ddr_pll)));
		ddr_udelay(2000);
	}
		}
printf("\nset to  loop_max_freq== %dMHz\n", loop_max_freq);

update_ddr_zq(zq0pr);

	 zq0pr_drv_max=(zq0pr&0xf);
	 zq0pr_drv_min=(zq0pr&0xf);
	 zq0pr_odt_max=(zq0pr&0xf0);
	 zq0pr_odt_min=(zq0pr&0xf0);

if (zq0pr_drv_flag)
{
while ((zq0pr&0xf)<0xf)
{
zq0pr++;
update_ddr_zq(zq0pr);
temp_test_error=0;
temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
zq0pr--;
update_ddr_zq(zq0pr);
break;


}
}
zq0pr_drv_max=(zq0pr&0xf);
printf("\nzq0pr_drv_max== 0x%08x\n", zq0pr_drv_max);

update_ddr_zq(zq0pr_org);

while ((zq0pr&0xf)>0x0)
{
zq0pr--;
update_ddr_zq(zq0pr);
temp_test_error=0;
temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
zq0pr++;
update_ddr_zq(zq0pr);
break;


}
}


zq0pr_drv_min=(zq0pr&0xf);
printf("\nzq0pr_drv_max== 0x%08x\n", zq0pr_drv_min);
}

if (zq0pr_odt_flag)
{
while ((zq0pr&0xf0)<0xf0)
{
zq0pr=zq0pr+0x10;
update_ddr_zq(zq0pr);
temp_test_error=0;
temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
zq0pr=zq0pr-0x10;
update_ddr_zq(zq0pr);
break;


}
}
zq0pr_odt_max=(zq0pr&0xf0);
printf("\nzq0pr_odt_max== 0x%08x\n", zq0pr_odt_max);

update_ddr_zq(zq0pr_org);


while ((zq0pr&0xf0)>0x0)
{
zq0pr=zq0pr-0x10;
update_ddr_zq(zq0pr);
temp_test_error=0;
temp_test_error=ddr_test_s_cross_talk_pattern(ddr_test_size);
temp_test_error=temp_test_error+ddr_test_s_add_cross_talk_pattern(ddr_test_size);
if (temp_test_error)
{
zq0pr=zq0pr+0x10;
update_ddr_zq(zq0pr);
break;


}
}
zq0pr_odt_min=(zq0pr&0xf0);
printf("\nzq0pr_odt_min== 0x%08x\n", zq0pr_odt_min);
}
update_ddr_zq(zq0pr_org);

printf("\nzq0pr_drv_max== 0x%08x\n", zq0pr_drv_max);
printf("\nzq0pr_drv_min== 0x%08x\n", zq0pr_drv_min);
printf("\nzq0pr_odt_max== 0x%08x\n", zq0pr_odt_max);
printf("\nzq0pr_odt_min== 0x%08x\n", zq0pr_odt_min);

 return loop_max_freq;



}

int clear_ddr_band_monitor(unsigned int port,unsigned int port_id,unsigned int timer_counter)
{
wr_reg(DMC_MON_CTRL3, timer_counter);
wr_reg(DMC_MON_CTRL2, (port_id<<0)|(port<<16)|(0<<20)|(1<<30));
ddr_udelay(1);
if (((rd_reg(DMC_MON_CTRL2))>>30) == 1)
	return 1;
else
	return 0;


}
int open_ddr_band_monitor(unsigned int port,unsigned int port_id,unsigned int timer_counter)
{
wr_reg(DMC_MON_CTRL3, timer_counter);
wr_reg(DMC_MON_CTRL2, ((rd_reg(DMC_MON_CTRL2))&(1<<30))|(port_id<<0)|(port<<16)|(0<<20)|(1<<31));

	return 1;


}

int finish_ddr_band_monitor(unsigned int port,unsigned int port_id,unsigned int timer_counter)
{
//wr_reg(DMC_MON_CTRL3, timer_time);
if (((rd_reg(DMC_MON_CTRL2))>>31) == 0)
{
printf("\nddr bandwidth timer finish count and print result\n");
printf("\nDMC_MON_port	== 0x%08x port_id==0x%08x timer_time==0x%08x",port,port_id,timer_counter);
printf("\nDMC_MON_ALL_REQ_CNT	== 0x%08x",(rd_reg(DMC_MON_ALL_REQ_CNT)));

printf("\nDMC_MON_ALL_GRANT_CNT	== 0x%08x",(rd_reg(DMC_MON_ALL_GRANT_CNT)));
printf("\nDMC_MON_ALL_GRANT_CNT_band	== 0x%08x kbyte,dec== %d Mbyte",((rd_reg(DMC_MON_ALL_GRANT_CNT))*(8))/1024,((rd_reg(DMC_MON_ALL_GRANT_CNT))*(8))/(1024*1024));
printf("\nDMC_MON_ONE _GRANT_CNT for selected port and subids	== 0x%08x",(rd_reg(DMC_MON_ONE_GRANT_CNT)));
printf("\nDMC_MON_ONE _GRANT_CNT_band for selected port and subids	== 0x%08x,dec== %dMbyte",((rd_reg(DMC_MON_ONE_GRANT_CNT))*(8))/1024,((rd_reg(DMC_MON_ONE_GRANT_CNT))*(8))/(1024*1024));
}
//wr_reg(DMC_MON_CTRL2, ((rd_reg(DMC_MON_CTRL2))&(1<<30))|(port_id<<0)|(port<<16)|(0<<20)|(1<<31));

	return 1;


}



int do_ddr_test_bandwidth(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter Test ddr bandwidth  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
  printf("\nargc== 0x%08x\n", argc);



{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;
 //  unsigned int   *p_start_addr;
  unsigned int   test_loop=1;
   unsigned int   test_times=1;
   unsigned int timer_time_ms=1000;


	   unsigned int ddr_pll=0x10221;
	unsigned int ddr_clk_org=792;
	unsigned int ddr_pll_org = rd_reg(AM_DDR_PLL_CNTL)&(~(1<<29));
	ddr_pll=ddr_pll_org;
	unsigned int ddr_clk = pll_convert_to_ddr_clk(ddr_pll);
	ddr_clk_org=ddr_clk;
		printf("\nddr_clk_org== %dMHz\n", ddr_clk_org);

	unsigned int zq0pr = rd_reg(DDR0_PUB_ZQ0PR);
	printf("\nddr_zq0pr== 0x%08x\n", zq0pr);

	   ddr_pll = ddr_clk_convert_to_pll(ddr_clk);






	 #define  DDR_CORSS_TALK_TEST_SIZE   0x20000

	    unsigned int   ddr_test_size= DDR_CORSS_TALK_TEST_SIZE;

unsigned int test_port=0;
unsigned int test_port_sub_id=1;


	 if (argc == 1)
		{
		ddr_test_size = DDR_CORSS_TALK_TEST_SIZE;
		test_loop=1;

		}

	  if (argc == 2)
		{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop=1;

		}
		if (argc== 3)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);

		}
		if (argc >= 4)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);
			test_port= simple_strtoul(argv[3], &endp, 16);


		}
	if (argc >= 5)
			{
		ddr_test_size = simple_strtoul(argv[1], &endp, 16);
		test_loop= simple_strtoul(argv[2], &endp, 16);
			test_port= simple_strtoul(argv[3], &endp, 16);
				  test_port_sub_id= simple_strtoul(argv[4], &endp, 16);

		}
	if (argc >5)
			{

				  timer_time_ms= simple_strtoul(argv[5], &endp, 16);

		}




	//unsigned int  	temp_test_error=0;
	unsigned int timer_counter=0;
	timer_counter=(timer_time_ms*1000*ddr_clk/2);
//while(test_times<(test_loop+1))
{



	{
	clear_ddr_band_monitor( test_port, test_port_sub_id, timer_counter);
	 open_ddr_band_monitor( test_port, test_port_sub_id, timer_counter);
	 while (test_times<(test_loop+1))
		{
		printf("\ntest_times== %d times\n", test_times);
	 ddr_test_s_cross_talk_pattern(ddr_test_size);
	 test_times++;
		}
	 finish_ddr_band_monitor( test_port, test_port_sub_id, timer_counter);
 printf("\ntimer_time_ms== %d ms\n", timer_time_ms);

 printf("\nddr_clk== %dMHz\n", ddr_clk);


	}






}







 return 1;



}

int do_ddr_fine_tune_lcdlr_env(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter ddr_fine_tune_lcdlr_env  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }


{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;
 //  unsigned int   *p_start_addr;




	   #define WR_RD_ADJ_USE_ENV  1
	     #define WR_RD_ADJ_USE_UART_INPUT 2
unsigned int   wr_rd_adj_input_src=1;
 {

int wr_adj_per[12]={
	100	,
	1000	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,
	100	,

};
int rd_adj_per[12]={
100	,
100	,
80	,
80	,
80	,
80	,
100	,
100	,
100	,
100	,
100	,
100	,
};
 if (argc == 1)
	{  printf("\nplease read help\n");
	}
	if (argc >= 2)
			{
		wr_rd_adj_input_src = simple_strtoul(argv[1], &endp, 10);

	 unsigned int i=0;
if (wr_rd_adj_input_src == WR_RD_ADJ_USE_UART_INPUT)
{
printf("\ntune ddr lcdlr use uart input\n");
if (argc>24+2)
		{argc=24+2;}
{

	for (i = 2;i<argc;i++)
		{
		if (i<(2+12)) {
		wr_adj_per[i-2]=simple_strtoul(argv[i], &endp, 10);
		}
	else
		{
		rd_adj_per[i-14]=simple_strtoul(argv[i], &endp, 10);
		}
		}
}

}
if (wr_rd_adj_input_src == WR_RD_ADJ_USE_ENV)
{printf("\ntune ddr lcdlr use uboot env\n");
{
//char str[24];
 const char *s;

 // char *varname;
 int value=0;

//*varname="env_ddrtest";
 s = getenv("env_wr_lcdlr_pr");
 if (s)
	{//i=0;
	//while(s_temp)
	{
	printf("%s",s);
	//sscanf(s,"d%,",wr_adj_per);
	//sprintf(str,"d%",s);
	//getc

	}
  value = simple_strtoul(s, &endp, 16);
	printf("%d",value);
	}
 s = getenv("env_rd_lcdlr_pr");

 if (s)
	{//i=0;
	//while(s_temp)
	{
	printf("%s",s);
	//sscanf(s,"d%,",rd_adj_per);

	}
  //value = simple_strtoul(s, &endp, 16);
	}

 //sprintf(str, "%lx", value);
//  setenv("env_ddrtest", str);


//run_command("save",0);
}

if (argc>24+2)
	argc=24+2;
	for (i = 2;i<argc;i++)
		{
		if (i<(2+12)) {
		wr_adj_per[i-2]=simple_strtoul(argv[i], &endp, 16);
		}
	else
		{
		rd_adj_per[i-14]=simple_strtoul(argv[i], &endp, 16);
		}
		}


}
printf(" int wr_adj_per[12]={\n");
	for (i = 0;i<12;i++)
		{
		printf("%04d ,\n",wr_adj_per[i]);
		}
	printf("};\n");
	printf(" int rd_adj_per[12]={\n");
	for (i = 0;i<12;i++)
		{
		printf("%04d ,\n",rd_adj_per[i]);
		}
	   printf("};\n");


#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
wr_reg(DDR0_PUB_PIR, (rd_reg(DDR0_PUB_PIR))|(1<<29));
wr_reg(DDR0_PUB_PGCR6, (rd_reg(DDR0_PUB_PGCR6))|(1<<0));
wr_reg(DDR1_PUB_PIR, (rd_reg(DDR1_PUB_PIR))|(1<<29));
wr_reg(DDR1_PUB_PGCR6, (rd_reg(DDR1_PUB_PGCR6))|(1<<0));
#else
wr_reg(DDR0_PUB_PIR, (rd_reg(DDR0_PUB_PIR))|(1<<29));
wr_reg(DDR0_PUB_PGCR1, (rd_reg(DDR0_PUB_PGCR1))|(1<<26));
wr_reg(DDR1_PUB_PIR, (rd_reg(DDR1_PUB_PIR))|(1<<29));
wr_reg(DDR1_PUB_PGCR1, (rd_reg(DDR1_PUB_PGCR1))|(1<<26));
#endif

int lcdlr_w=0,lcdlr_r=0;
unsigned temp_reg=0;
int temp_count=0;
for ( temp_count=0;temp_count<2;temp_count++)
{     temp_reg=(unsigned)(DDR0_PUB_ACLCDLR+(temp_count<<2));
	   lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&ACLCDLR_MAX);
	   lcdlr_w=lcdlr_w?lcdlr_w:1;
	lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
	if (temp_count == 1)
		lcdlr_w=lcdlr_w&ACBDLR_MAX;
	wr_reg(((uint64_t)(temp_reg)),((lcdlr_w)&ACLCDLR_MAX));
}
#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
for ( temp_count=2;temp_count<6;temp_count++)
{     temp_reg=(unsigned)(DDR0_PUB_DX0LCDLR1+(DDR0_PUB_DX1LCDLR1-DDR0_PUB_DX0LCDLR1)*(temp_count-2));
	   lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&DQLCDLR_MAX);
	lcdlr_w=lcdlr_w?lcdlr_w:1;
	lcdlr_r=(int)(((rd_reg((uint64_t)(temp_reg+DDR0_PUB_DX0LCDLR3-DDR0_PUB_DX0LCDLR1))))&DQLCDLR_MAX);
	lcdlr_r=lcdlr_r?lcdlr_r:1;
	lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
	lcdlr_r=(lcdlr_r*(rd_adj_per[temp_count]))/100;
	wr_reg(((uint64_t)(temp_reg)),(lcdlr_w));
	wr_reg(((uint64_t)(temp_reg+DDR0_PUB_DX0LCDLR3-DDR0_PUB_DX0LCDLR1)),(lcdlr_r));
	wr_reg(((uint64_t)(temp_reg+DDR0_PUB_DX0LCDLR4-DDR0_PUB_DX0LCDLR1)),(lcdlr_r));
}
#else
for ( temp_count=2;temp_count<6;temp_count++)
{     temp_reg=(unsigned)(DDR0_PUB_DX0LCDLR1+(DDR0_PUB_DX1LCDLR1-DDR0_PUB_DX0LCDLR1)*(temp_count-2));
	   lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&DQLCDLR_MAX);
	lcdlr_w=lcdlr_w?lcdlr_w:1;
	lcdlr_r=(int)(((rd_reg((uint64_t)(temp_reg)))>>8)&DQLCDLR_MAX);
	lcdlr_r=lcdlr_r?lcdlr_r:1;
	lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
	lcdlr_r=(lcdlr_r*(rd_adj_per[temp_count]))/100;
	wr_reg(((uint64_t)(temp_reg)),(((lcdlr_r<<16)|(lcdlr_r<<8)|(lcdlr_w))));
}
#endif
for ( temp_count=6;temp_count<8;temp_count++)
{     temp_reg=(unsigned)(DDR1_PUB_ACLCDLR+((temp_count-6)<<2));

	   lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&ACLCDLR_MAX);
	   lcdlr_w=lcdlr_w?lcdlr_w:1;
	lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
		if (temp_count == 7)
		lcdlr_w=lcdlr_w&ACBDLR_MAX;
	wr_reg(((uint64_t)(temp_reg)),((lcdlr_w)&ACLCDLR_MAX));
}
#if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)
for ( temp_count=8;temp_count<12;temp_count++)
{     temp_reg=(unsigned)(DDR1_PUB_DX0LCDLR1+(DDR1_PUB_DX1LCDLR1-DDR1_PUB_DX0LCDLR1)*(temp_count-2));
	   lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&DQLCDLR_MAX);
	lcdlr_w=lcdlr_w?lcdlr_w:1;
	lcdlr_r=(int)(((rd_reg((uint64_t)(temp_reg+DDR1_PUB_DX0LCDLR3-DDR1_PUB_DX0LCDLR1))))&DQLCDLR_MAX);
	lcdlr_r=lcdlr_r?lcdlr_r:1;
	lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
	lcdlr_r=(lcdlr_r*(rd_adj_per[temp_count]))/100;
	wr_reg(((uint64_t)(temp_reg)),(lcdlr_w));
	wr_reg(((uint64_t)(temp_reg+DDR1_PUB_DX0LCDLR3-DDR1_PUB_DX0LCDLR1)),(lcdlr_r));
	wr_reg(((uint64_t)(temp_reg+DDR1_PUB_DX0LCDLR4-DDR1_PUB_DX0LCDLR1)),(lcdlr_r));
}
#else
for ( temp_count=8;temp_count<12;temp_count++)
{     temp_reg=(unsigned)(DDR1_PUB_DX0LCDLR1+(DDR1_PUB_DX1LCDLR1-DDR1_PUB_DX0LCDLR1)*(temp_count-8));
	   lcdlr_w=(int)((rd_reg((uint64_t)(temp_reg)))&0xff);
	   lcdlr_w=lcdlr_w?lcdlr_w:1;
	lcdlr_r=(int)(((rd_reg((uint64_t)(temp_reg)))>>8)&0xff);
	lcdlr_r=lcdlr_r?lcdlr_r:1;
	lcdlr_w=(lcdlr_w*(wr_adj_per[temp_count]))/100;
	lcdlr_r=(lcdlr_r*(rd_adj_per[temp_count]))/100;
	wr_reg(((uint64_t)(temp_reg)),(((lcdlr_r<<16)|(lcdlr_r<<8)|(lcdlr_w))));
}
 #endif

 #if (CONFIG_DDR_PHY ==  P_DDR_PHY_905X)


  wr_reg(DDR0_PUB_PGCR6, (rd_reg(DDR0_PUB_PGCR6))&(~(1<<0)));
  wr_reg(DDR0_PUB_PIR, (rd_reg(DDR0_PUB_PIR))&(~(1<<29)));

  wr_reg(DDR1_PUB_PGCR6, (rd_reg(DDR1_PUB_PGCR6))&(~(1<<0)));
  wr_reg(DDR1_PUB_PIR, (rd_reg(DDR1_PUB_PIR))&(~(1<<29)));


 #else
 wr_reg(DDR0_PUB_PGCR1, (rd_reg(DDR0_PUB_PGCR1))&(~(1<<26)));
 wr_reg(DDR0_PUB_PIR, (rd_reg(DDR0_PUB_PIR))&(~(1<<29)));

 wr_reg(DDR1_PUB_PGCR1, (rd_reg(DDR1_PUB_PGCR1))&(~(1<<26)));
 wr_reg(DDR1_PUB_PIR, (rd_reg(DDR1_PUB_PIR))&(~(1<<29)));
#endif
	printf("\nend adjust lcdlr\n");

	 CLOSE_CHANNEL_A_PHY_CLK();
	 CLOSE_CHANNEL_B_PHY_CLK();







		}



	}
  return 1;

}
//*/
int do_ddr_modify_reg_use_mask(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter ddr_modify_reg_use_mask  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }


{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;
 //  unsigned int   *p_start_addr;



unsigned int   reg_add=0;
 unsigned int   wr_reg_value=0;
 unsigned int   rd_reg_value=0;
  unsigned int   wr_reg_and_mask_1=0xffffffff;
 // unsigned int   wr_reg_or_mask_2=0x0;


 {



 if (argc == 1)
	{  printf("\nplease read help\n");
		   printf("\nexample only change 0xc8836800 0x8c010226 0x000fffff bit20-bit31,no change pll od oc \n");
		   printf("\nddr_test_cmd 9 0xc8836800 0x8c010226 0x000fffff\n");
	}
 else{
	if (argc >= 2)
			{
		reg_add = simple_strtoul(argv[1], &endp, 10);
		}
		if (argc >= 3)
			{
		wr_reg_value = simple_strtoul(argv[2], &endp, 10);
		}
				if (argc >= 4)
			{
		wr_reg_and_mask_1 = simple_strtoul(argv[3], &endp, 10);

		}
			//	 		 	   	 if(argc >= 5)
		//	{
	 //	 wr_reg_or_mask_2= simple_strtoul(argv[4], &endp, 10);

	//	}



			  rd_reg_value= (rd_reg(reg_add));
		wr_reg(reg_add,(rd_reg_value&wr_reg_and_mask_1)|(wr_reg_value&(~wr_reg_and_mask_1)) );
		//rd_reg_value= (rd_reg(reg_add));
		//wr_reg(reg_add,(rd_reg_value&(~wr_reg_or_mask_2))|(wr_reg_value&(wr_reg_or_mask_2)) );

	printf("\nmodify ok read==0x%08x\n",(rd_reg(reg_add)));


	 CLOSE_CHANNEL_A_PHY_CLK();
	 CLOSE_CHANNEL_B_PHY_CLK();









	}

	}
  return 1;

}
int do_ddr_set_zq(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter set ddr zq  function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }


{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;

	unsigned int zq0pr_org = rd_reg(DDR0_PUB_ZQ0PR);
	unsigned int zq1pr_org = rd_reg(DDR0_PUB_ZQ1PR);
	unsigned int zq2pr_org = rd_reg(DDR0_PUB_ZQ2PR);
//	unsigned int zq0pr_best;
unsigned int zq0pr0= rd_reg(DDR0_PUB_ZQ0PR);
unsigned int zq1pr0= rd_reg(DDR0_PUB_ZQ1PR);
unsigned int zq2pr0= rd_reg(DDR0_PUB_ZQ2PR);

	{
		{



 if (argc == 1)
	{  printf("\nplease read help\n");
		   printf("\nexample only change zq \n");
		   printf("\nddr_test_cmd 10 0x19\n");
	}
 else{
	if (argc >= 2)
			{
		// zq0pr0 = argv[1];
		zq0pr0= simple_strtoul(argv[1], &endp, 0);
		}

	if (argc >= 3)
			{
		// zq1pr0 = argv[2];
		 zq1pr0= simple_strtoul(argv[2], &endp, 0);
		}

	if (argc >= 4)
			{
		// zq2pr0 =argv[3];
		 zq2pr0= simple_strtoul(argv[3], &endp, 0);

		}}

	printf("\nzq0pr_org== 0x%08x\n", zq0pr_org);
	printf("\nzq1pr_org== 0x%08x\n", zq1pr_org);
	printf("\nzq2pr_org== 0x%08x\n", zq2pr_org);
wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2)|(1<<27));
 printf("\norg channel 0 zq zq0pr=0x%08x,zq0dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ0PR),rd_reg(DDR0_PUB_ZQ0DR));
 printf("\norg channel 0 zq zq1pr=0x%08x,zq1dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ1PR),rd_reg(DDR0_PUB_ZQ1DR));
 printf("\norg channel 0 zq zq2pr=0x%08x,zq2dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ2PR),rd_reg(DDR0_PUB_ZQ2DR));

wr_reg( DDR0_PUB_ZQ0PR,zq0pr0);
wr_reg( DDR0_PUB_ZQ1PR,zq1pr0);
wr_reg( DDR0_PUB_ZQ2PR,zq2pr0);
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2)|(1<<27));
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))&(~((1<<2)|(1<<27))));
 printf("\nupdate channel 0 zq zq0pr=0x%08x,zq0dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ0PR),rd_reg(DDR0_PUB_ZQ0DR));
 printf("\nupdate channel 0 zq zq1pr=0x%08x,zq1dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ1PR),rd_reg(DDR0_PUB_ZQ1DR));
 printf("\nupdate channel 0 zq zq2pr=0x%08x,zq2dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ2PR),rd_reg(DDR0_PUB_ZQ2DR));

wr_reg( DDR0_PUB_ZQ0PR,zq0pr0);
wr_reg( DDR0_PUB_ZQ1PR,zq1pr0);
wr_reg( DDR0_PUB_ZQ2PR,zq2pr0);
 printf("\nupdate channel 0 zq zq0pr=0x%08x,zq0dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ0PR),rd_reg(DDR0_PUB_ZQ0DR));
 printf("\nupdate channel 0 zq zq1pr=0x%08x,zq1dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ1PR),rd_reg(DDR0_PUB_ZQ1DR));
 printf("\nupdate channel 0 zq zq2pr=0x%08x,zq2dr=0x%08x,\n",rd_reg(DDR0_PUB_ZQ2PR),rd_reg(DDR0_PUB_ZQ2DR));

	//wr_reg( DDR1_PUB_ZQCR,(rd_reg(DDR1_PUB_ZQCR))|(1<<2)|(1<<27));
	//wr_reg( DDR1_PUB_ZQCR,(rd_reg(DDR1_PUB_ZQCR))&(~((1<<2)|(1<<27))));





	 CLOSE_CHANNEL_A_PHY_CLK();
	 CLOSE_CHANNEL_B_PHY_CLK();









	}

	}
  return 1;

}





int ddr_ee_pwm_voltage_table[31][2] = {
	{ 0x1c0000,  860},
	{ 0x1b0001,  870},
	{ 0x1a0002,  880},
	{ 0x190003,  890},
	{ 0x180004,  900},
	{ 0x170005,  910},
	{ 0x160006,  920},
	{ 0x150007,  930},
	{ 0x140008,  940},
	{ 0x130009,  950},
	{ 0x12000a,  960},
	{ 0x11000b,  970},
	{ 0x10000c,  980},
	{ 0x0f000d,  990},
	{ 0x0e000e, 1000},
	{ 0x0d000f, 1010},
	{ 0x0c0010, 1020},
	{ 0x0b0011, 1030},
	{ 0x0a0012, 1040},
	{ 0x090013, 1050},
	{ 0x080014, 1060},
	{ 0x070015, 1070},
	{ 0x060016, 1080},
	{ 0x050017, 1090},
	{ 0x040018, 1100},
	{ 0x030019, 1110},
	{ 0x02001a, 1120},
	{ 0x01001b, 1130},
	{ 0x00001c, 1140}
};



void ddr_test_pwm_set_voltage(unsigned int id, unsigned int voltage)
{
	int to;



#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))




#define P_PIN_MUX_REG1         (*((volatile unsigned *)(0xda834400 + (0x2d << 2))))
#define P_PIN_MUX_REG2         (*((volatile unsigned *)(0xda834400 + (0x2e << 2))))
#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))


#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2192 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2191 << 2))))

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

enum pwm_id {
	pwm_a = 0,
	pwm_b,
	pwm_c,
	pwm_d,
	pwm_e,
	pwm_f,
};


//printf("test ddr init pwm  id %08d \n",id);

	unsigned int reg;

	/*
	 * TODO: support more pwm controllers, right now only support
	 * PWM_B, PWM_D
	 */

	switch (id) {
	case pwm_b:
		reg = P_PWM_MISC_REG_AB;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_AB = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_B = ddr_ee_pwm_voltage_table[ARRAY_SIZE(ddr_ee_pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG1;
		reg &= ~(1 << 10);
		P_PIN_MUX_REG1 = reg;

		reg  = P_PIN_MUX_REG2;
		reg &= ~(1 << 5);
		reg |=  (1 << 11);		// enable PWM_B
		P_PIN_MUX_REG2 = reg;
		break;

	case pwm_d:
		reg = P_PWM_MISC_REG_CD;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_CD = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_D = ddr_ee_pwm_voltage_table[ARRAY_SIZE(ddr_ee_pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG1;
		reg &= ~(1 << 9);
		reg &= ~(1 << 11);
		P_PIN_MUX_REG1 = reg;

		reg  = P_PIN_MUX_REG2;
		reg |=  (1 << 12);		// enable PWM_D
		P_PIN_MUX_REG2 = reg;
		break;
	default:
		break;
	}

	ddr_udelay(200);

	//printf("test ddr set vddee to  %08d mv\n",voltage);

	for (to = 0; to < ARRAY_SIZE(ddr_ee_pwm_voltage_table); to++) {
		if (ddr_ee_pwm_voltage_table[to][1] >= voltage) {
			break;
		}
	}
	if (to >= ARRAY_SIZE(ddr_ee_pwm_voltage_table)) {
		to = ARRAY_SIZE(ddr_ee_pwm_voltage_table) - 1;
	}
	switch (id) {
	case pwm_b:
		P_PWM_PWM_B = ddr_ee_pwm_voltage_table[to][0];
		break;

	case pwm_d:
		P_PWM_PWM_D = ddr_ee_pwm_voltage_table[to][0];
		break;
	default:
		break;
	}
	ddr_udelay(200);
}

int do_ddr_test_pwm_cmd (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter do_ddr_test_pwm_cmd function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }


{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;


  unsigned int id=0;
//  unsigned int voltage=1000;
	unsigned int pwm_low=0x1f;
	  unsigned int pwm_high=0;


		{



 if (argc == 1)
	{  printf("\nplease read help\n");

	}
 else{
	if (argc >= 2)
			{
		// zq0pr0 = argv[1];
			// zq1pr0 = argv[2];
		 id= simple_strtoul(argv[1], &endp, 0);
		//voltage= simple_strtoul(argv[1], &endp, 0);
		}

	if (argc >= 3)
			{

	pwm_low= simple_strtoul(argv[2], &endp, 0);
		}
			if (argc >= 4)
			{

	pwm_high= simple_strtoul(argv[3], &endp, 0);
		}
	pwm_low=(pwm_low>0x1f)?(0x1f):(pwm_low);
	 pwm_high=(pwm_high>0x1f)?(0x1f):(pwm_high);

	printf("\npwm_low== 0x%08d 0-1f\n", pwm_low);
	printf("\npwm_high== 0x%08d  0-1f\n", pwm_high);
	printf("\npwm_id== 0x%08d\n", id);
	printf("\npwm_id 0== pwm_a\n");
	printf("\npwm_id 1== pwm_b\n");
	printf("\npwm_id 2== pwm_c\n");
	printf("\npwm_id 3== pwm_d\n");
	printf("\npwm_id 4== pwm_e\n");
	printf("\npwm_id 5== pwm_f\n");
//ddr_test_pwm_set_voltage(id,voltage);

{




#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))




#define P_PIN_MUX_REG1         (*((volatile unsigned *)(0xda834400 + (0x2d << 2))))
#define P_PIN_MUX_REG2         (*((volatile unsigned *)(0xda834400 + (0x2e << 2))))
#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))


#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2192 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2191 << 2))))

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

enum pwm_id {
	pwm_a = 0,
	pwm_b,
	pwm_c,
	pwm_d,
	pwm_e,
	pwm_f,
};


//printf("test ddr init pwm  id %08d \n",id);

	unsigned int reg;

	/*
	 * TODO: support more pwm controllers, right now only support
	 * PWM_B, PWM_D
	 */

	switch (id) {
	case pwm_b:
		reg = P_PWM_MISC_REG_AB;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_AB = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_B =0x00001f;//pwm_low|(pwm_high<<16);// ddr_ee_pwm_voltage_table[ARRAY_SIZE(ddr_ee_pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG1;
		reg &= ~(1 << 10);
		P_PIN_MUX_REG1 = reg;

		reg  = P_PIN_MUX_REG2;
		reg &= ~(1 << 5);
		reg |=  (1 << 11);		// enable PWM_B
		P_PIN_MUX_REG2 = reg;
		break;

	case pwm_d:
		reg = P_PWM_MISC_REG_CD;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_CD = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_D = 0x00001f;//pwm_low|(pwm_high<<16);//ddr_ee_pwm_voltage_table[ARRAY_SIZE(ddr_ee_pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG1;
		reg &= ~(1 << 9);
		reg &= ~(1 << 11);
		P_PIN_MUX_REG1 = reg;

		reg  = P_PIN_MUX_REG2;
		reg |=  (1 << 12);		// enable PWM_D
		P_PIN_MUX_REG2 = reg;
		break;
	default:
		break;
	}

	ddr_udelay(200);

	//printf("test ddr set vddee to  %08d mv\n",voltage);

	//for (to = 0; to < ARRAY_SIZE(ddr_ee_pwm_voltage_table); to++) {
	//	if (ddr_ee_pwm_voltage_table[to][1] >= voltage) {
	//		break;
	//	}
	//}
	//if (to >= ARRAY_SIZE(ddr_ee_pwm_voltage_table)) {
	//	to = ARRAY_SIZE(ddr_ee_pwm_voltage_table) - 1;
	//}

	switch (id) {
	case pwm_b:
		P_PWM_PWM_B = pwm_low|(pwm_high<<16);//ddr_ee_pwm_voltage_table[to][0];
		break;

	case pwm_d:
		P_PWM_PWM_D = pwm_low|(pwm_high<<16);//ddr_ee_pwm_voltage_table[to][0];
		break;
	default:
		break;
	}
	ddr_udelay(200);
}

 unsigned int   ddl_100step_ps= 0;
   ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_ACMDLR0)))>>16)&0xff);
   printf("\nddl_100step_ps== %08d,0_5cycle_ps== %08d,0_5cycle==0x%08x\n", ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)),
	((((readl(DDR0_PUB_ACMDLR0)))>>16)&0xff));

	 CLOSE_CHANNEL_A_PHY_CLK();
	 CLOSE_CHANNEL_B_PHY_CLK();


	}

	}
  return 1;

}
int do_ddr_test_pwm_ddl (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter do_ddr_test_pwm_ddl function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }


{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;


  unsigned int id=0;
  unsigned int voltage=1000;
	unsigned int loop=0;
	int to;
		{



 if (argc == 1)
	{  printf("\nplease read help\n");

	}
 else{
	if (argc >= 2)
			{
		// zq0pr0 = argv[1];
		voltage= simple_strtoul(argv[1], &endp, 0);
		}

	if (argc >= 3)
			{
		// zq1pr0 = argv[2];
		 id= simple_strtoul(argv[2], &endp, 0);
		}
	if (argc >= 4)
			{
		// zq1pr0 = argv[2];
		 loop= simple_strtoul(argv[3], &endp, 0);
		}

	printf("\nvoltage== 0x%08d\n", voltage);
	printf("\npwm_id== 0x%08d\n", id);
	printf("\npwm_id 0== pwm_a\n");
	printf("\npwm_id 1== pwm_b\n");
	printf("\npwm_id 2== pwm_c\n");
	printf("\npwm_id 3== pwm_d\n");
	printf("\npwm_id 4== pwm_e\n");
	printf("\npwm_id 5== pwm_f\n");
ddr_test_pwm_set_voltage(id,voltage);
 unsigned int   ddl_100step_ps= 0;
   ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_ACMDLR0)))>>16)&0xff);
   printf("\nvoltage ==%08d,ddl_100step_ps== %08d,0_5cycle_ps== %08d,0_5cycle==0x%08x\n",voltage, ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)),
	((((readl(DDR0_PUB_ACMDLR0)))>>16)&0xff));

if (loop)
{

	for (to = 0; to < ARRAY_SIZE(ddr_ee_pwm_voltage_table); to++) {

			ddr_test_pwm_set_voltage(id,(ddr_ee_pwm_voltage_table[to][1]));
			  ddl_100step_ps=((100*1000*1000)/(2*global_ddr_clk))/((((readl(DDR0_PUB_ACMDLR0)))>>16)&0xff);
   printf("\nvoltage ==%08d,ddl_100step_ps== %08d,0_5cycle_ps== %08d,0_5cycle==0x%08x\n",
	(ddr_ee_pwm_voltage_table[to][1]),ddl_100step_ps,((1000*1000)/(2*global_ddr_clk)),
	((((readl(DDR0_PUB_ACMDLR0)))>>16)&0xff));
	}
}


	 CLOSE_CHANNEL_A_PHY_CLK();
	 CLOSE_CHANNEL_B_PHY_CLK();


	}

	}
  return 1;

}

int do_ddr_test_shift_ddr_clk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
   printf("\nEnter test shift ddr clk function\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }

 int test_app_pra[4] = {0,0,0,0};

	 char *endp;


	{
		{



 if (argc == 1)
	{  printf("\nplease read help\n");

	}
 else{
	if (argc >= 2)
			{
		// zq0pr0 = argv[1];
		test_app_pra[0]= simple_strtoul(argv[1], &endp, 0);
		}

	if (argc >= 3)
			{
		// zq1pr0 = argv[2];
		 test_app_pra[1]= simple_strtoul(argv[2], &endp, 0);
		}

	if (argc >= 4)
			{
		// zq2pr0 =argv[3];
		 test_app_pra[2]= simple_strtoul(argv[3], &endp, 0);

		}}


	}

	}

	{

//shift ddr frequency test
	printf("test_app_pra[0]==0x%08x\n",test_app_pra[0] );
	   printf("test_app_pra[1]==0x%08x\n",test_app_pra[1] );
	   printf("test_app_pra[2]==0x%08x\n",test_app_pra[2] );
	   unsigned int reg_value[4] = {0};
	unsigned int delay_ms_time=30;
	unsigned int test_times=0xffff;
	unsigned int test_count=0;
	unsigned int test_loop_flag=0;
	reg_value[0]=0xc4aae860 ;
	wr_reg( 0xc883601c,(reg_value[0]));
	//update_reg_debug_value(&(reg_value[0]),0xc883601c );
	reg_value[1]=0x000ea203  ;
	wr_reg( 0xc8837004,(reg_value[1]));
	//update_reg_debug_value(&(reg_value[1]),0xc8837004  );

	reg_value[3]=0x03e3b740  ;
	if ((test_app_pra[1]))
		{delay_ms_time=(test_app_pra[1]);
		}
	if ((test_app_pra[2]))
		{test_times=(test_app_pra[2]);
	if (test_times == 0xffffffff)
		test_loop_flag=1;
		}
	     printf("delay_ms_time==%d\n",delay_ms_time );
	     printf("test_times==%d\n",test_times );
	if (test_app_pra[0] ==0)
		reg_value[2]=0x03e3b750  ;
	if (test_app_pra[0] ==1)
		reg_value[2]=0x03e3b754  ;
	if (test_app_pra[0] ==2)
		reg_value[2]=0x03e3b758  ;
	if (test_app_pra[0] ==3)
		reg_value[2]=0x03e3b75c  ;

		if (test_app_pra[0] ==4)
			{
		reg_value[2]=0x03e3b750  ;
		reg_value[3]=0x03e3b754  ;
			}
		if (test_app_pra[0] ==5)
			{
		reg_value[2]=0x03e3b750  ;
		reg_value[3]=0x03e3b758  ;
			}
		if (test_app_pra[0] ==6)
			{
		reg_value[2]=0x03e3b750  ;
		reg_value[3]=0x03e3b75c  ;
			}
		if (test_app_pra[0] ==7)
			{
		reg_value[2]=0x03e3b754  ;
		reg_value[3]=0x03e3b758  ;
			}
		if (test_app_pra[0] ==8)
			{
		reg_value[2]=0x03e3b754  ;
		reg_value[3]=0x03e3b75c  ;
			}
		if (test_app_pra[0] ==9)
			{
		reg_value[2]=0x03e3b758  ;
		reg_value[3]=0x03e3b75c  ;
			}
	while (1) {test_count++;
		//	reg_value[2]=0x03e3b750  ;
	//update_reg_debug_value(&(reg_value[2]),0xc883700c  );

	wr_reg( 0xc8837010,(0x001c0101));
	 ddr_udelay(delay_ms_time * 1000);
	wr_reg( 0xc883700c,(reg_value[2]));
	printf("\nupdate  reg 0xc883700c=0x%08x\n",rd_reg(0xc883700c));
	 ddr_udelay(delay_ms_time * 1000);
		wr_reg( 0xc8837010,(0x000c0101));
	 ddr_udelay(delay_ms_time * 1000);
		wr_reg( 0xc8837010,(0x001c0101));
	 ddr_udelay(delay_ms_time * 1000);
	 //usleep(1000 * 1000);
	//reg_value[3]=0x03e3b740  ;
	//update_reg_debug_value(&(reg_value[3]),0xc883700c   );
	 wr_reg( 0xc883700c,(reg_value[3]));
	 printf("\nupdate  reg 0xc883700c=0x%08x\n",rd_reg(0xc883700c));
	 ddr_udelay(delay_ms_time * 1000);
		wr_reg( 0xc8837010,(0x000c0101));
	 ddr_udelay(delay_ms_time * 1000);
	  printf("\ntesting %d times\n",(test_count));
	  if (!test_loop_flag)
		{
		if (test_count == test_times)
			break;
		}
		}



}
  return 1;

}

int do_ddr_test_write_read (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
//turn 1;
///*
{
   printf("\nEnter do_ddr_test_ddr_write_read_current\n");
 //   if(!argc)
	//    goto DDR_TUNE_DQS_START;
	int i=0;
  printf("\nargc== 0x%08x\n", argc);
 for (i = 0;i<argc;i++)
  {
  printf("\nargv[%d]=%s\n",i,argv[i]);
  }


{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}

	 char *endp;

  unsigned int pattern_id=1;
  unsigned int pattern[4] ={0};
  unsigned int write_read=0;
  unsigned int read_pattern[4]={0} ;
  unsigned int loop=1;
  unsigned int  start_addr = DDR_TEST_START_ADDR;
  unsigned int  test_size = DDR_TEST_SIZE;
  unsigned int  copy_offset= DDR_TEST_SIZE;




 if (argc == 1)
	{  printf("\nplease read help\n");

	}
 else{
	if (argc >= 2)
			{
		// zq0pr0 = argv[1];
		write_read= simple_strtoul(argv[1], &endp, 0);
		}

	if (argc >= 3)
			{
		// zq1pr0 = argv[2];
		pattern_id= simple_strtoul(argv[2], &endp, 0);
		}
	if (argc >= 4)
			{
		// zq1pr0 = argv[2];
	loop= simple_strtoul(argv[3], &endp, 0);
		}
	 if (argc >=5)
			{
		// zq1pr0 = argv[2];
		 start_addr= simple_strtoul(argv[4], &endp, 0);
		}
		if (argc >=6)
			{
		// zq1pr0 = argv[2];
		 test_size= simple_strtoul(argv[5], &endp, 0);
		}
	}
	printf("\nwrite_read== 0x%08d\n", write_read);
	printf("\npattern_id== 0x%08d\n", pattern_id);
	printf("\nloop== 0x%08d\n", loop);
	printf("\nstart_addr== 0x%08x\n", start_addr);
	printf("\ntest_size== 0x%08x\n", test_size);
	  copy_offset=test_size;

   unsigned int  *p;
	 unsigned int   j;


	p = (unsigned int  * )(int_convter_p(start_addr));

		if (pattern_id == 0)
			{
		pattern[0]=0;
		pattern[1]=0;
		pattern[2]=0;
		pattern[3]=0;
			}
		if (pattern_id == 1)
			{
		pattern[0]=0xffffffff;
		pattern[1]=0xffffffff;
		pattern[2]=0xffffffff;
		pattern[3]=0xffffffff;
			}


do
{

	if (write_read == 0)
	{   printf("\nloop:0x%08x:Start writing at 0x%08x - 0x%08x...", loop,start_addr, start_addr + test_size);
	for (j=0;j<test_size/4;)
		{
			 *(p+j)=(pattern[0]);
			 *(p+j+1)=(pattern[1]);
			 *(p+j+2)=(pattern[2]);
			 *(p+j+3)=(pattern[3]);
			 j=j+4;
		}
	}
	if (write_read == 1)
	{   printf("\nloop:0x%08x:Start reading at 0x%08x - 0x%08x...", loop,start_addr, start_addr + test_size);
	for (j=0;j<test_size/4;)
		{
			read_pattern[0]= *(p+j);
			read_pattern[1]= *(p+j+1);
			read_pattern[2]=*(p+j+2);
			read_pattern[3]= *(p+j+3);
			 j=j+4;
		}
	if (loop == 1) {
	printf(" \nloop:0x%08x:Start reading read_pattern[0] 0x%08x, pattern[1] 0x%08x,pattern[2] 0x%08x,pattern[3] 0x%08x",
		loop,read_pattern[0], read_pattern[1],read_pattern[2],read_pattern[3]
		);  }
	}
	if (write_read == 2)
	{   printf("\nloop:0x%08x:Start copying at 0x%08x - 0x%08x...", loop,start_addr, start_addr + test_size);
	for (j=0;j<test_size/4;)
		{
			*(p+j+copy_offset/4)= *(p+j);
			*(p+j+1+copy_offset/4)= *(p+j+1);
			*(p+j+2+copy_offset/4)= *(p+j+2);
			*(p+j+3+copy_offset/4)= *(p+j+3);
			 j=j+4;
		}
	}








}while(loop--);


	 CLOSE_CHANNEL_A_PHY_CLK();
	 CLOSE_CHANNEL_B_PHY_CLK();



  printf("\ntest end\n");

  return 1;
}
//*/
}
int do_ddr_test_cmd(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
//ddr_test_watchdog_init(4000);
//printf("\nopen watchdog %dms\n",4000);
		   printf("\nargc== 0x%08x\n", argc);
			int i ;
	for (i = 0;i<argc;i++)
		{
		printf("\nargv[%d]=%s\n",i,argv[i]);
		}

	/* need at least two arguments */
	if (argc < 2)
		goto usage;
	if ((strcmp(argv[1], "h") == 0))
		goto usage;



{
//writel((0), 0xc8836c00);
OPEN_CHANNEL_A_PHY_CLK();
}

{
OPEN_CHANNEL_B_PHY_CLK();
//writel((0), 0xc8836c00);
}


	unsigned int ddr_pll = rd_reg(AM_DDR_PLL_CNTL);
	unsigned int ddr_clk =pll_convert_to_ddr_clk(ddr_pll);
		///2*(((24 * (ddr_pll&0x1ff))/((ddr_pll>>9)&0x1f))>>((ddr_pll>>16)&0x3));

		printf("\nddr_clk== %dMHz\n", ddr_clk);
global_ddr_clk=ddr_clk;
	unsigned int zq0pr = rd_reg(DDR0_PUB_ZQ0PR);
	printf("\nddr_zq0pr== 0x%08x\n", zq0pr);

#define  DDR_TEST_CMD__NONE   0
#define  DDR_TEST_CMD__DDR_TEST         1
#define  DDR_TEST_CMD__DDR_TUNE_ACLCDLR        2
#define  DDR_TEST_CMD__DDR_TUNE_MAX_CLK     3   //ddr_test_cmd 3 0x8000000 3 1
#define  DDR_TEST_CMD__DDR_TUNE_ZQ     4
#define  DDR_TEST_CMD__DDR_TUNE_VREF    5
#define  DDR_TEST_CMD__DDR_GXTVBB_CROSSTALK    6
#define  DDR_TEST_CMD__DDR_BANDWIDTH_TEST   7
#define  DDR_TEST_CMD__DDR_LCDLR_ENV_TUNE   8
#define  DDR_TEST_CMD__DDR_MODIFY_REG_USE_MASK   9
#define  DDR_TEST_CMD__DDR_DDR_TUNE_AC_CLK   0xa

#define  DDR_TEST_CMD__DDR_SETZQ   0x10
#define  DDR_TEST_CMD__DDR_TUNE_DQS  0x11
#define  DDR_TEST_CMD__DDR_SET_TEST_START_ADD  0x12
#define  DDR_TEST_CMD__DDR_TEST_AC_BIT_SETUP_HOLD_MARGIN  0x13
#define  DDR_TEST_CMD__DDR_TEST_DATA_BIT_SETUP_HOLD_MARGIN  0x14
#define  DDR_TEST_CMD__DDR_TEST_AC_LANE_BIT_MARGIN  0x15
#define  DDR_TEST_CMD__DDR_TEST_EE_VOLTAGE_MDLR_STEP  0x16
#define  DDR_TEST_CMD__DDR_TEST_D2PLL_CMD  0x17
#define  DDR_TEST_CMD__DDR_TEST_DATA_LANE_BIT_MARGIN  0x18
#define  DDR_TEST_CMD__DDR4_TUNE_PHY_VREF   0x19
#define  DDR_TEST_CMD__DDR4_TUNE_DRAM_VREF   0x1A
#define  DDR_TEST_CMD__DDR4_TUNE_AC_VREF   0x1b
#define  DDR_TEST_CMD__DDR4_SWEEP_DRAM_CLK_USE_D2PLL   0x1c
#define  DDR_TEST_CMD__DDR4_TEST_SHIFT_DDR_FREQUENCY  0x1d
#define  DDR_TEST_CMD__DDR4_TEST_DATA_WRTIE_READ  0x1e
#define  DDR_TEST_CMD__DDR_TEST_PWM_CMD              0x1f
#define  DDR_TEST_CMD__DDR_TEST_EE_SI             0x20
#define  DDR_TEST_CMD__DDR_TEST_VDDQ_SI             0x21


 unsigned int  ddr_test_cmd=0;
 unsigned int  arg[30]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
 char *endp;
 ddr_test_cmd = simple_strtoul(argv[1], &endp, 0);
	for (i = 2;i<argc;i++)
		{
		arg[i-2]=simple_strtoul(argv[i], &endp, 0);
		}
		   printf("\nddr_test_cmd== 0x%08x\n", ddr_test_cmd);

	for (i = 0;i<(argc-2);i++)
		{
		printf("\narg[%08x]=%08x\n",i,arg[i]);
		}
//int argc2_length;
//argc2_length=(argc-2);
//cmd_tbl_t *cmdtp2;
//int flag2;
int argc2;
char     *  argv2[30];


argc2=argc-1;
	for (i = 1;i<(argc);i++)
		{
		argv2[i-1]=argv[i];
		}
//argv2=(char    *)argv++;
{
switch (ddr_test_cmd)
{case(DDR_TEST_CMD__NONE):
{
	 printf("\n  0x0 help\n");
	 printf("\n  0x1 ddrtest                             ddr_test_cmd 0x1 start_add test_size loops  ");
	 printf("\n  0x2 test aclcdlr                        ddr_test_cmd 0x2 start_add test_size loops    ddr_test_cmd 0x2 a 0 0x8000000  1");
	 printf("\n  0x3 test max_pllclk                  ddr_test_cmd 0x3  test_size loops add_freq sub_freq ");
	 printf("\n  0x4 test zq                              ddr_test_cmd 0x4  test_size loops add_freq sub_freq drv_odt_flag ");
	 printf("\n  0x5 test vref                            ddr_test_cmd 0x5   ");
	 printf("\n  0x6 test gxtvbb_crosstalk         ddr_test_cmd 0x6  loops pattern_flag ");
	 printf("\n  0x7 test bandwidth                   ddr_test_cmd 0x7 size loops port sub_id timer_ms ");
	 printf("\n  0x8 test lcdlr_use_env_uart      ddr_test_cmd 0x8 input_src wr_adj_per[] rd_adj_per[][] ");
	 printf("\n  0x9 test_reg_use_mask            ddr_test_cmd 0x9 reg_add value mask  ");
	 printf("\n  0xa test ac_clk                        ddr_test_cmd 0xa start_add test_size loops   ddr_test_cmd 0xa a 0 0x8000000  1  ");
	 printf("\n  0xb ...  ");
	 printf("\n  0xc ...  ");
	 printf("\n  0xd ...  ");
	 printf("\n  0xe ...  ");
	 printf("\n  0xf ...  ");
	 printf("\n  0x10 test set zq                                 ddr_test_cmd 0x10 zq0pr0 zq1pr0 zq2pr0   ");
	 printf("\n  0x11 test tune dqs                             ddr_test_cmd 0x11 a 0 test_size   ddr_test_cmd 0x11 a 0 0x80000");
	 printf("\n  0x12 test set start_add                       ddr_test_cmd 0x12 start_add   ");
	 printf("\n  0x13 test ac_bit_setup_hold time        ddr_test_cmd 0x13 a 0 size method  pin_id   ddr_test_cmd 0x13 a 0 0x8000000 0  0xc");
	 printf("\n  0x14 test data_bit_setup_hold time      ddr_test_cmd 0x14 a 0 size setup/hold pin_id   ddr_test_cmd 0x14 a 0 0x80000 0 3 ");
	 printf("\n  0x15 test ac_lane_setup_hold             ddr_test_cmd 0x15 a 0 size   ");
	 printf("\n  0x16 test ee mdlr                              ddr_test_cmd 0x16  voltage pwm_id loops   ");
		printf("\n  0x17 d2pll                                         ddr_test_cmd 0x17 clk zq cmd_type soc_vref dram_vref hex_dec zq_vref   \
			ddr_test_cmd 0x17 1420  0  0 56 0 1 0 ");
	 printf("\n  0x18 test data_lane_setup_hold          ddr_test_cmd 0x18 a 0 size range start_pin_id end_pin_id  ddr_test_cmd 0x18 a 0 0x80000 1 0 96 ");
	 printf("\n  0x19 test phy vref                             ddr_test_cmd 0x19 a 0 0x80000  1 seed step vref_all vref_lcdlr_offset test_down_up_step seed_hex_dec  \
		ddr_test_cmd 0x19 a 0 0x1000000  1  63  1 1  0x8 0 1 ");
	 printf("\n  0x1a test dram vref                           ddr_test_cmd 0x1A a 0 0x80000  clear seed step vref_all vref_lcdlr_offset test_down_up_step vref_range seed_hex_dec \
	\n setenv  ddr_test_ddr4ram_vref ddr_test_cmd 0x1A a 0 0x0800000  0  0x14 1  0  0x8 0 0 0  setenv  storeboot  run ddr_test_ddr4ram_vref  ");
	 printf("\n  0x1b test ac vref                               ddr_test_cmd 0x1B a 0 0x80000  clear seed step vref_all vref_lcdlr_offset seed_hex_dec");
		printf("\n  0x1c sweep dram clk use d2pll_env     ddr_test_cmd 0x1c  test_size start_freq end_freq test_loops  ddr_test_cmd 0x1c 0x8000000 800 1500 1");
		printf("\n  0x1d test shift clk                               ddr_test_cmd 0x1d type delay_ms times");
	 printf("\n  0x1e test write_read                          ddr_test_cmd 0x1e write_read pattern_id loop start_add test_size");
	 printf("\n  0x1f test pwm_cmd                           ddr_test_cmd 0x1f pwmid   pwm_low pwm_high");
}
	return 1;
  case(DDR_TEST_CMD__DDR_TEST):
		{
	//	run_command("ddrtest 0x10000000 0x8000000 3",0);
	//ddr_test_cmd 0x1 star_add test_size loops
	// do_ddr_test(cmdtp,  flag, argc2,argv);
	 do_ddr_test((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2,(argv2));
	break;
		}
  case(DDR_TEST_CMD__DDR_TUNE_ACLCDLR):
		{
	//	run_command("ddr_tune_ddr_ac_aclcdlr a 0  0x8000000 3",0);
	//ddr_test_cmd 0x2 a 0 0x8000000  1
	 do_ddr_test_ac_windows_aclcdlr((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
  case(DDR_TEST_CMD__DDR_DDR_TUNE_AC_CLK):
		{
	//	run_command("ddr_tune_ddr_ac_acbdlr_ck a 0 0x8000000 3",0);
	//ddr_test_cmd 0xA a 0 0x8000000  1
	 do_ddr_test_ac_windows_acbdlr_ck((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;


  case(DDR_TEST_CMD__DDR_TUNE_MAX_CLK):
		{
	//	run_command("ddr_test_cmd 3 0x8000000 0",0);
	 printf("\nTest ddr max frequency should use max timming ,such as 14-14-14\n");

	 do_ddr_test_ddr_max_freq((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	  case(DDR_TEST_CMD__DDR_TUNE_ZQ):
		{
	//	run_command("ddr_tune_ddr_ac_aclcdlr 0x10000000 0x8000000 3",0);
	 printf("\nTest zq,should first test max ddr frequency use default zq value\n");

	 do_ddr_test_ddr_zq((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
		case(DDR_TEST_CMD__DDR_GXTVBB_CROSSTALK):
		{
	//	run_command("ddr_tune_ddr_ac_aclcdlr 0x10000000 0x8000000 3",0);
	 printf("\nTest GXTVBB cross talk,test only channel 0 --0x10000000 channel 1 --0x10000400 32byte\n");

	 do_ddr_gxtvbb_crosstalk((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
			case(DDR_TEST_CMD__DDR_BANDWIDTH_TEST):
		{
	//	run_command("ddr_tune_ddr_ac_aclcdlr 0x10000000 0x8000000 3",0);
	 printf("\nNOTE test DDR bandwidth in uboot limited by cpu speed \n");

	 do_ddr_test_bandwidth((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
				case(DDR_TEST_CMD__DDR_LCDLR_ENV_TUNE):
		{
	//	run_command("ddr_tune_ddr_ac_aclcdlr 0x10000000 0x8000000 3",0);
	 printf("\ntune ddr lcdlr use uboot env or uart input \n");

	 do_ddr_fine_tune_lcdlr_env((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
			case(DDR_TEST_CMD__DDR_MODIFY_REG_USE_MASK):
		{
	//	run_command("ddr_tune_ddr_ac_aclcdlr 0x10000000 0x8000000 3",0);
	 printf("\nmodify ddr reg use mask \n");

	 do_ddr_modify_reg_use_mask((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
			case(DDR_TEST_CMD__DDR_SETZQ):
		{
	//	run_command("ddr_test_cmd 0x10  0x59 0x5d 0x5b  ",0);
	 printf("\nset ddr zq \n");

	 do_ddr_set_zq((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	             case(DDR_TEST_CMD__DDR_TUNE_DQS):
		{
	//	run_command("ddr_test_cmd 0x11 a 0 0x80000  ",0);
	 printf("\ntest dqs window \n");

	 do_ddr_test_dqs_window((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	 case(DDR_TEST_CMD__DDR_SET_TEST_START_ADD):
		{
	//	run_command("ddr_test_cmd 12  0x41080000  ",0);


	 test_start_addr=arg[0];
	 if (test_start_addr == 0)
		test_start_addr=0x1080000;
	  printf("\nset ddr  test test_start_addr==0x%08x \n",test_start_addr);
		}
	break;
	  case(DDR_TEST_CMD__DDR_TEST_AC_BIT_SETUP_HOLD_MARGIN):
		{  //clk seed use for clk too early,clk must delay
	//	run_command("ddr_test_cmd 0x13 a 0 0x8000000 0  0xc  ",0); cs0 setup
	//	run_command("ddr_test_cmd 0x13 a 0 0x8000000 1  0xc  ",0); cs0 hold
	//	run_command("ddr_test_cmd 0x13 a 0 0x8000000 2  0xc  ",0); cs0 hold   //some times ddr frequency too high cannot move clk delay.then should only move cmd bdl
	//so shouldt test hold time use method 1 and method 2----test hold time take care--20160804-jiaxing
	//	run_command("ddr_test_cmd 0x13 a 0 0x8000000 0  0xd  ",0); cs1 setup
	//	run_command("ddr_test_cmd 0x13 a 0 0x8000000 1  0xd   ",0); cs1 hold
	 printf("\ntest AC bit window \n");

	 do_ddr_test_ac_bit_setup_hold_window((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
	 //do_ddr_test_ac_bit_setup_hold_window a 0 0x8000000 0 c
		}
	break;
		  case(DDR_TEST_CMD__DDR_TEST_D2PLL_CMD):
		{
	//ddr_test_cmd 0x17 1420  0  0 56 0 1 0
	 printf("\ntest d2pll cmd \n");

	 do_ddr2pll_cmd((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
		 case(DDR_TEST_CMD__DDR_TEST_EE_VOLTAGE_MDLR_STEP):
		{
	//	run_command("ddr_test_cmd 0x16 1000 1 1",0);//test EE 1000mV ddl step pwmb  -1 211    212--pwmd--3
	//1000 1 1  ---1000mv  pwmid  loop ,if loop then test all pwm voltage
	//ddr_test_cmd 0x16 1000 1   set to 1000mv
	 printf("\ntest ee voltage ddl step \n");

	 do_ddr_test_pwm_ddl((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
			 case(DDR_TEST_CMD__DDR_TEST_AC_LANE_BIT_MARGIN):
		{
	//	run_command("ddr_test_cmd 0x15 a 0 0x800000 0",0);
	 printf("\ntest ac lane bit margin not include cs pin \n");

	 do_ddr_test_ac_bit_margin((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
	 //do_ddr_test_ac_bit_setup_hold_window a 0 0x8000000 0 c
		}
	break;
	case(DDR_TEST_CMD__DDR_TEST_DATA_BIT_SETUP_HOLD_MARGIN):
		{
	//	run_command("ddr_test_cmd 0x14 a 0 0x80000 setup/hold pin_id",0);
	//	run_command("ddr_test_cmd 0x14 a 0 0x80000 0 3",0);
	 printf("\ntest data lane bit setup hold \n");

	 do_ddr_test_data_bit_setup_hold_window((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	case(DDR_TEST_CMD__DDR_TEST_DATA_LANE_BIT_MARGIN):
		{
	//	run_command("ddr_test_cmd 0x18 a 0 0x80000 0",0);
		//	run_command("ddr_test_cmd 0x18 a 0 0x80000 1 0 96",0);
	 printf("\ntest data lane bit margin  \n");

	 do_ddr_test_data_bit_margin((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	case(DDR_TEST_CMD__DDR4_TUNE_PHY_VREF):
		{
	//	run_command("ddr_test_cmd 0x19 a 0 0x80000  1 seed step vref_all vref_lcdlr_offset test_down_up_step seed_hex_dec",0);
	//ddr_test_cmd 0x19 a 0 0x1000000  1  0x1a  1 1  0x8 0 0
	//ddr_test_cmd 0x19 a 0 0x1000000  1  63  1 1  0x8 0 1
	 printf("\ntest ddr4 phy vref  \n");

	 do_ddr4_test_phy_vref((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	case(DDR_TEST_CMD__DDR4_TUNE_DRAM_VREF):
		{
	//	run_command("ddr_test_cmd 0x1A a 0 0x80000  clear seed step vref_all vref_lcdlr_offset test_down_up_step vref_range seed_hex_dec",0);
	//ddr_test_cmd 0x1A a 0 0x1000000  0  0 3  0  0x10
	//setenv  ddr_test_ddr4ram_vref "ddr_test_cmd 0x1A a 0 0x0800000  0  0x14 0  0  0x8 0 0 0"
	//setenv storeboot "run ddr_test_ddr4ram_vref"
	 printf("\ntest ddr4 DRAM vref  \n");

	 do_ddr4_test_dram_vref((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
		case(DDR_TEST_CMD__DDR4_TUNE_AC_VREF):
		{
	//	run_command("ddr_test_cmd 0x1B a 0 0x80000  clear seed step vref_all vref_lcdlr_offset seed_hex_dec",0);
	//ddr_test_cmd 0x1B a 0 0x1000000  0  0 1  0  0x10 0
	 printf("\ntest ddr4 AC or dd3 dram ac_data vref  \n");

	 do_ddr4_test_dram_ac_vref((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;

	//DDR_TEST_CMD__DDR4_SWEEP_DRAM_CLK_USE_D2PLL
		case(DDR_TEST_CMD__DDR4_SWEEP_DRAM_CLK_USE_D2PLL):
		{
	//	run_command("ddr_test_cmd 0x1c  test_size start_freq end_freq test_loops",0);
	//ddr_test_cmd 0x1c 0x8000000 800 1500 3
	 printf("\ntest ddr4 sweep ddr clk use d2pll \n");

	 do_ddr4_test_dram_clk((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
		case(DDR_TEST_CMD__DDR4_TEST_SHIFT_DDR_FREQUENCY):
		{
	//	run_command("ddr_test_cmd 0x1d ",0);
	//ddr_test_cmd 0x1d type delay_ms times //ddr_test_cmd 0x1d 0 1000 100000
	//times =0xffffffff will auto loop
	 printf("\ntest ddr shift ddr clk  \n");

	 do_ddr_test_shift_ddr_clk((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
	//DDR_TEST_CMD__DDR4_TEST_DATA_WRTIE_READ
			case(DDR_TEST_CMD__DDR4_TEST_DATA_WRTIE_READ):
		{
	//	run_command("ddr_test_cmd 0x1e  write_read  pattern_id loop start_addr test_size",0);
	//ddr_test_cmd 0x1d type delay_ms times //ddr_test_cmd 0x1e 1 2 10 0x40000000 0x10000000
	//times =0xffffffff will auto loop
	 printf("\ntest ddr write read  \n");

	 do_ddr_test_write_read((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
		 case(DDR_TEST_CMD__DDR_TEST_PWM_CMD):
		{
	//	run_command("ddr_test_cmd 0x1f 0x1 0x2 0x1A ",0);//test EE   pwmb  --1 211    212--pwmd--3
	//1000 1 1  ---pwmid   pwm_low pwm_high   pwm_low+pwm_high==normal=28
	 printf("\npwmid   pwm_low pwm_high \n");

	 do_ddr_test_pwm_cmd((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
		 case(DDR_TEST_CMD__DDR_TEST_EE_SI):
		{
	//	run_command("ddr_test_cmd 0x20 0x1 0x2 0x1A ",0);//test EE   pwmb  --1 211    212--pwmd--3
	//1000 1 1  ---pwmid   pwm_low pwm_high   pwm_low+pwm_high==normal=28
		// do_ddr_test_ee_si((cmd_tbl_t * )cmdtp, (int) flag,( int) argc2, (argv2));
		}
	break;
}
  return 1;//test_start_addr
}

usage:
	cmd_usage(cmdtp);
	return 1;

}
U_BOOT_CMD(
	ddr_test_cmd,	30,	1,	do_ddr_test_cmd,
	"ddr_test_cmd cmd arg1 arg2 arg3...",
	"ddr_test_cmd cmd arg1 arg2 arg3... \n dcache off ? \n"
	);


