/*
* this driver is written for the internal rtc for M1
*/


/*
 The bus of RTC is different between M1 and M3:
	 M1: connect to CBUS
	 M3: connect to AOBUS
 RTC driver use absolute RTC register address to avoid the difference.
 So need define RTC register absolute address separately  
 P_RTC_ADDRx
 */
 
#include <asm-generic/errno.h>
#include <common.h>
#include <asm/arch/io.h>
#include <aml_rtc.h>
#ifdef CONFIG_POST_AML
#include <post.h>
#endif

#define printk printf

extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
extern unsigned long get_rtc_static_reg_init_val(void);
extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);

int c_dbg_lvl = 0;
#define RTC_DBG(lvl, x...) do{ if(c_dbg_lvl & lvl) printk(x);} while(0)
#define RTC_DBG_VAL 1 << 0
#define RTC_DBG_WR 1 << 1

#ifdef CONFIG_MESON_TRUSTZONE
extern uint32_t meson_trustzone_rtc_read_reg32(uint32_t addr);
extern uint32_t meson_trustzone_rtc_write_reg32(uint32_t addr, uint32_t value);
#define WR_RTC(reg, val) meson_trustzone_rtc_write_reg32(P_##reg, val)
#define RD_RTC(reg) (meson_trustzone_rtc_read_reg32(P_##reg))
#else
#define WR_RTC(reg, val) __raw_writel(val, P_##reg)
#define RD_RTC(reg) (__raw_readl(P_##reg))
#endif

// Define register (AOBUS/CBUS) RTC_ADDR0 bit map
#define RTC_REG0_BIT_sclk_static     20
#define RTC_REG0_BIT_ildo_ctrl_1      7
#define RTC_REG0_BIT_ildo_ctrl_0      6
#define RTC_REG0_BIT_test_mode      5
#define RTC_REG0_BIT_test_clk           4
#define RTC_REG0_BIT_test_bypass    3
#define RTC_REG0_BIT_sdi                   2
#define RTC_REG0_BIT_sen                  1
#define RTC_REG0_BIT_sclk                 0

// Define register (AOBUS/CBUS) RTC_ADDR1 bit map
#define RTC_REG1_BIT_gpo_to_dig     3
#define RTC_REG1_BIT_gpi_to_dig      2
#define RTC_REG1_BIT_s_ready          1
#define RTC_REG1_BIT_sdo                  0

// Define register (AOBUS/CBUS) RTC_ADDR3 bit map
#define RTC_REG3_BIT_count_always   17

// Define RTC serial protocal
#define RTC_SER_DATA_BITS           32
#define RTC_SER_ADDR_BITS           3


#define s_ready                  1 << RTC_REG1_BIT_s_ready  
#define s_do                       1 << RTC_REG1_BIT_sdo
#define RESET_RETRY_TIMES           15

#define RTC_sbus_LOW(x)             WR_RTC(RTC_ADDR0, \
                                                                      (RD_RTC(RTC_ADDR0) & \
                                                                      ~((1<<RTC_REG0_BIT_sen)|(1<<RTC_REG0_BIT_sclk)|(1<<RTC_REG0_BIT_sdi))))
                                                                      
#define RTC_sdi_HIGH(x)             WR_RTC(RTC_ADDR0, \
                                                                  (RD_RTC(RTC_ADDR0) | (1<<RTC_REG0_BIT_sdi) ))
                                                                  
#define RTC_sdi_LOW(x)               WR_RTC(RTC_ADDR0, \
                                                                   (RD_RTC(RTC_ADDR0) & ~(1<<RTC_REG0_BIT_sdi) ))
                                                                   
#define RTC_sen_HIGH(x)             WR_RTC(RTC_ADDR0, \
                                                                   (RD_RTC(RTC_ADDR0) | (1<<RTC_REG0_BIT_sen) ))
                                                                   
#define RTC_sen_LOW(x)               WR_RTC(RTC_ADDR0, \
                                                                    (RD_RTC(RTC_ADDR0) & ~(1<<RTC_REG0_BIT_sen) ))
                                                                    
#define RTC_sclk_HIGH(x)             WR_RTC(RTC_ADDR0, \
                                                                    (RD_RTC(RTC_ADDR0) |(1<<RTC_REG0_BIT_sclk)))
                                                                    
#define RTC_sclk_LOW(x)               WR_RTC(RTC_ADDR0, \
                                                                      (RD_RTC(RTC_ADDR0) & ~(1<<RTC_REG0_BIT_sclk)))
                                                                      
#define RTC_sdo_READBIT             (RD_RTC(RTC_ADDR1)&(1<<RTC_REG1_BIT_sdo))

#define RTC_sclk_static_HIGH(x)   WR_RTC(RTC_ADDR0, \
                                                                      (RD_RTC(RTC_ADDR0) |(1<<RTC_REG0_BIT_sclk_static)))
                                                                      
#define RTC_sclk_static_LOW(x)      WR_RTC(RTC_ADDR0, \
                                                                        (RD_RTC(RTC_ADDR0) & ~(1<<RTC_REG0_BIT_sclk_static)))

#define RTC_count_always_HIGH(x)     WR_RTC(RTC_ADDR3, \
                                                                             (RD_RTC(RTC_ADDR3) |(1<<RTC_REG3_BIT_count_always)))
#define RTC_count_always_LOW(x)      WR_RTC(RTC_ADDR3, \
                                                                              (RD_RTC(RTC_ADDR3) & ~(1<<RTC_REG3_BIT_count_always)))

#define RTC_Sdo_READBIT                       RD_RTC(RTC_ADDR1)&s_do`


#define RTC_SER_REG_DATA_NOTIFIER   0xb41b// Define RTC register address mapping

//#define P_ISA_TIMERE                (volatile unsigned long *)0xc1109954

// Define RTC register address mapping
#define RTC_COUNTER_ADDR            0
#define RTC_GPO_COUNTER_ADDR        1
#define RTC_SEC_ADJUST_ADDR         2
#define RTC_UNUSED_ADDR_0           3
#define RTC_REGMEM_ADDR_0           4
#define RTC_REGMEM_ADDR_1           5
#define RTC_REGMEM_ADDR_2           6
#define RTC_REGMEM_ADDR_3           7

/*struct aml_rtc_priv{
	struct rtc_device *rtc;
       unsigned long base_addr;
	
};*/

static void delay_us(int us)
{
	udelay(us);
}

static void rtc_comm_delay(void)
{
	delay_us(5);
}

static void rtc_sclk_pulse(void)
{
	//unsigned flags;
	
	//local_irq_save(flags);

	rtc_comm_delay();
	RTC_sclk_HIGH(1);
	rtc_comm_delay();
	RTC_sclk_LOW(0);

	//local_irq_restore(flags);
}


static int  check_osc_clk(void)
{
	unsigned long   osc_clk_count1; 
	unsigned long   osc_clk_count2; 

	WR_RTC(RTC_ADDR3, RD_RTC(RTC_ADDR3) | (1 << 17));   // Enable count always    

	RTC_DBG(RTC_DBG_VAL, "aml_rtc -- check os clk_1\n");
	osc_clk_count1 = RD_RTC(RTC_ADDR2);    // Wait for 50uS.  32.768khz is 30.5uS.  This should be long   
										// enough for one full cycle of 32.768 khz   
	RTC_DBG(RTC_DBG_VAL, "the aml_rtc os clk 1 is %d\n", (unsigned int)osc_clk_count1);									
	delay_us( 50 );   
	osc_clk_count2 = RD_RTC(RTC_ADDR2);    
	RTC_DBG(RTC_DBG_VAL, "the aml_rtc os clk 2 is %d\n", (unsigned int)osc_clk_count2);

	RTC_DBG(RTC_DBG_VAL, "aml_rtc -- check os clk_2\n");
	WR_RTC(RTC_ADDR3, RD_RTC(RTC_ADDR3) & ~(1 << 17));  // disable count always    

	if( osc_clk_count1 == osc_clk_count2 ) { 
	       RTC_DBG(RTC_DBG_VAL, "The osc_clk is not running now! need to invcrease the power!\n");
		return(-1); 
	}

       RTC_DBG(RTC_DBG_VAL, "aml_rtc : check_os_clk\n");
	   
	return(0);

}

void rtc_ser_static_write_auto (unsigned long static_reg_data_in)
{
    unsigned long data32;
    
    // Program MSB 15-8    
    data32  = (static_reg_data_in >> 8) & 0xff;    
    WR_RTC(RTC_ADDR4,data32);
	
    // Program LSB 7-0, and start serializing
    data32  = RD_RTC(RTC_ADDR0);
    data32 |= 1                           << 17; // auto_serialize_start 
    data32 &= ~(0xff << 24);
    data32 |= (static_reg_data_in & 0xff) << 24; // auto_static_reg
    WR_RTC(RTC_ADDR0,data32);
    // Poll auto_serializer_busy bit until it's low (IDLE)
    while ((RD_RTC(RTC_ADDR0)) & 1<<22) {}    
}


static void rtc_reset_s_ready(void)
{
	//RTC_RESET_BIT_HIGH(1);
	delay_us(100);
	return;
}

static int rtc_wait_s_ready(void)
{
	int i = 40000;
	int try_cnt = 0;
	/*
	while (i--){
		if((*(volatile unsigned *)RTC_ADDR1)&s_ready)
			break;
		}
	return i;
	*/
	while(!(RD_RTC(RTC_ADDR1)&s_ready)){
		i--;
		if(i == 0){
				if(try_cnt > RESET_RETRY_TIMES){
						break;
					}
			  rtc_reset_s_ready();
			  try_cnt++;
			  i = 40000;
			}
	}
	
	return i;
}


static int rtc_comm_init(void)
{
	RTC_sbus_LOW(0);
	if(rtc_wait_s_ready()>0){
		RTC_sen_HIGH(1);
		return 0;
	}
	return -1;
}


static void rtc_send_bit(unsigned val)
{
	if (val)
		RTC_sdi_HIGH(1);
	else
		RTC_sdi_LOW(0);
	rtc_sclk_pulse();
}

static void rtc_send_addr_data(unsigned type, unsigned val)
{
	unsigned cursor = (type? (1<<(RTC_SER_ADDR_BITS-1)) : (1<<(RTC_SER_DATA_BITS-1)));
		
	while(cursor)
	{
		rtc_send_bit(val&cursor);
		cursor >>= 1;
	}
}

static void rtc_get_data(unsigned *val)
{
	int i;
	RTC_DBG(RTC_DBG_VAL, "rtc-aml -- rtc get data \n");
	for (i=0; i<RTC_SER_DATA_BITS; i++)
	{
		rtc_sclk_pulse();
		*val <<= 1;
		*val  |= RTC_sdo_READBIT;
	}
}

static void rtc_set_mode(unsigned mode)
{
	RTC_sen_LOW(0);
	if (mode)
		RTC_sdi_HIGH (1);//WRITE
	else
		RTC_sdi_LOW(0);  //READ
	rtc_sclk_pulse();
	RTC_sdi_LOW(0);
}


unsigned int ser_access_read(unsigned long addr)
{
	unsigned val = 0;
	int s_nrdy_cnt = 0;

	RTC_DBG(RTC_DBG_VAL, "aml_rtc --ser_access_read_1\n");
	if(check_osc_clk() < 0){
		RTC_DBG(RTC_DBG_VAL, "aml_rtc -- the osc clk does not work\n");
		return val;
	}

	RTC_DBG(RTC_DBG_VAL, "aml_rtc -- ser_access_read_2\n");
	while(rtc_comm_init()<0){
		RTC_DBG(RTC_DBG_VAL, "aml_rtc -- rtc_common_init fail\n");
		if(s_nrdy_cnt>RESET_RETRY_TIMES)
			return val;
		rtc_reset_s_ready( );
		s_nrdy_cnt++;
	}

	RTC_DBG(RTC_DBG_VAL, "aml_rtc -- ser_access_read_3\n");
	rtc_send_addr_data(1,addr);
	rtc_set_mode(0); //Read
	rtc_get_data(&val);

	return val;
}

int ser_access_write(unsigned long addr, unsigned long data)
{
	int s_nrdy_cnt = 0;

	while(rtc_comm_init()<0){
		
		if(s_nrdy_cnt>RESET_RETRY_TIMES)
			return -1;
		rtc_reset_s_ready( );
		s_nrdy_cnt++;
	}
	rtc_send_addr_data(0,data);
	rtc_send_addr_data(1,addr);
	rtc_set_mode(1); //Write
	
	rtc_wait_s_ready();

	return 0;
}


// -----------------------------------------------------------------------------
//                    Function: rtc_ser_static_write_manual
// Use part of the serial bus: sclk_static, sdi and sen to shift
// in a 16-bit static data. Manual mode.
// -----------------------------------------------------------------------------
//static void rtc_ser_static_write_manual (unsigned int static_reg_data_in)
//{    
//	int i;        
//       RTC_DBG(RTC_DBG_VAL, "rtc_ser_static_write_manual: data=0x%04x\n", static_reg_data_in);   
//
//	// Initialize: sen low for 1 clock cycle   
//	RTC_sen_LOW(0);    
//	RTC_sclk_static_LOW(0);    
//	RTC_sclk_static_HIGH(1);    
//	RTC_sen_HIGH(1);    
//	RTC_sclk_static_LOW(0);   
//	  
//        // Shift in 16-bit known sequence    
//	 for (i = 15; i >= 0; i --) {    
//	 	
//	     if ((RTC_SER_REG_DATA_NOTIFIER >> i) & 0x1) {            
//		   RTC_sdi_HIGH(1);        
//	     }
//		 else {            
//		   RTC_sdi_LOW(0);        
//	     }     
//			
//	    RTC_sclk_static_HIGH(1);        
//	    RTC_sclk_static_LOW(0);   
//	 }    
//	 
//	  // 1 clock cycle turn around    
//	  RTC_sdi_LOW(0);    
//	  RTC_sclk_static_HIGH(1);    
//	  RTC_sclk_static_LOW(0);  
//	  
//	  // Shift in 16-bit static register data    
//	  for (i = 15; i >= 0; i --) {       
//	  	if ((static_reg_data_in >> i) & 0x1) {            
//		    RTC_sdi_HIGH(1);        
//		} 
//		else {            
//		    RTC_sdi_LOW(0);        
//		}        
//		RTC_sclk_static_HIGH(1);        
//		RTC_sclk_static_LOW(0);    
//	   }    
//	  
//	  // One more clock cycle to complete write    
//	  RTC_sen_LOW(0);    
//	  RTC_sdi_LOW(0);    
//	  RTC_sclk_static_HIGH(1);    
//	  RTC_sclk_static_LOW(0);
//} 


static void static_register_write(unsigned data)
{
     rtc_ser_static_write_auto(data);	
}

int aml_rtc_read_time(struct rtc_time *tm)
{
    unsigned int time_t;
    //struct aml_rtc_priv *priv;

    //priv = platform_get_drvdata(dev);
    RTC_DBG(RTC_DBG_VAL, "aml_rtc: read rtc time\n");
    //spin_lock(priv->lock);
    time_t = ser_access_read(RTC_COUNTER_ADDR);
    // spin_unlock(priv->lock);
    RTC_DBG(RTC_DBG_VAL, "aml_rtc: have read the rtc time, time is %d\n", time_t);
    if ((int)time_t < 0) {
        RTC_DBG(RTC_DBG_VAL, "aml_rtc: time(%d) < 0, reset to 0", time_t);
        time_t = 0;
    }   
    rtc_time_to_tm(time_t, tm);

    return 0;

}

int aml_rtc_write_time(struct rtc_time *tm)
{
      unsigned long time_t;
      //struct aml_rtc_priv *priv;

      //priv = platform_get_drvdata(dev);

      rtc_tm_to_time(tm, &time_t);
     
      //spin_lock(&priv->lock);  
      RTC_DBG(RTC_DBG_VAL, "aml_rtc : write the rtc time, time is %ld\n", time_t);
      ser_access_write(RTC_COUNTER_ADDR, time_t);
      RTC_DBG(RTC_DBG_VAL, "aml_rtc : the time has been written\n");
      //spin_unlock(&priv->lock);  

      return 0;
}

extern void mdelay(unsigned long usec);
int aml_rtc_init(void)
{
#ifdef CONFIG_AML_PMU
    printf("aml_rtc_init, rtc counter:%d\n", ser_access_read(RTC_COUNTER_ADDR));
#else
	printf("aml_rtc_init\n");
#endif
#ifdef CONFIG_AML_MESON_6
#ifdef CONFIG_MESON_TRUSTZONE
	//if(!(meson_trustzone_rtc_read_reg32(P_RTC_ADDR1) & (s_ready)))
#else
	//if(!(readl(P_RTC_ADDR1) & (s_ready)))
#endif		
	{
		printf("aml rtc init first time!\n");
		static_register_write(get_rtc_static_reg_init_val());
		mdelay(2);
		rtc_wait_s_ready(); 
		ser_access_write(RTC_GPO_COUNTER_ADDR, 0x500000);
		//changed GPI :RTC_ADDR1: GPI_LEVEL:  current level of the GPI signal from the RTC block
	}
#else
	static_register_write(get_rtc_static_reg_init_val());
	ser_access_write(RTC_GPO_COUNTER_ADDR,0x100000);
#endif	
	return 0;
}

#ifdef CONFIG_POST_AML
#if CONFIG_POST & CONFIG_SYS_POST_RTC
void aml_test_1s_clock(unsigned long* osc_clk_count1, unsigned long* osc_clk_count2)
{
	WR_RTC(RTC_ADDR3, RD_RTC(RTC_ADDR3) | (1 << 17));   // Enable count always    
	*osc_clk_count1 = RD_RTC(RTC_ADDR2);    // Wait for 50uS.  32.768khz is 30.5uS.  This should be long   
										// enough for one full cycle of 32.768 khz   	
	delay_us( 1000000 );   
	*osc_clk_count2 = RD_RTC(RTC_ADDR2);    		
	WR_RTC(RTC_ADDR3, RD_RTC(RTC_ADDR3) & ~(1 << 17));  // disable count always    	   	
}

unsigned aml_get_gpo_dig()
{
	return (RD_RTC(RTC_ADDR1) & 0x8);
}
#endif
#endif
