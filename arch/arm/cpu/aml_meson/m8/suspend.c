#include <common.h>
#include <linux/compiler.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>
#include <asm/arch/io.h>
#include <asm/arch/power_gate.h>
#include <asm/arch/gpio.h>
#include <asm/arch/clock.h>
#include <asm/cache-l2x0.h>

/*
 * Caution: Assembly code in sleep.S makes assumtion on the order
 * of the members of this structure.
 */
struct meson_pm_config {
    void __iomem *pctl_reg_base;
    void __iomem *mmc_reg_base;
    void __iomem *hiu_reg_base;
    unsigned power_key;
    unsigned ddr_clk;
    void __iomem *ddr_reg_backup;
    unsigned core_voltage_adjust;
    int sleepcount;
    void (*set_vccx2)(int power_on);
    void (*set_exgpio_early_suspend)(int power_on);
};



static void wait_uart_empty(void)
{
    do{
        if((readl(P_UART0_STATUS) & (1<<22)) == 0)
             udelay(4);
        else
            break;
    }while(1);

    do{
        if((readl(P_UART1_STATUS) & (1<<22)) == 0)
             udelay(4);
        else
            break;
    }while(1);

    do{
        if((readl(P_AO_UART_STATUS) & (1<<22)) == 0)
             udelay(4);
        else
            break;
    }while(1);
}





#define ADJUST_CORE_VOLTAGE
#define CONFIG_MESON_SUSPEND


static struct meson_pm_config *pdata;


#if 0

typedef struct {
    char name[32];
    unsigned reg_addr;
    unsigned set_bits;
    unsigned clear_bits;
    unsigned reg_value;
    unsigned enable; // 1:cbus 2:apb 3:ahb 0:disable
} analog_t;

#define ANALOG_COUNT    3
static analog_t analog_regs[ANALOG_COUNT] = {
    {"SAR_ADC",             P_SAR_ADC_REG3,       1 << 28, (1 << 30) | (1 << 21),    0,  1},
#ifdef ADJUST_CORE_VOLTAGE
    {"LED_PWM_REG0",        P_LED_PWM_REG0,       1 << 13,          1 << 12,              0,  0}, // needed for core voltage adjustment, so not off
#else
    {"LED_PWM_REG0",        P_LED_PWM_REG0,       1 << 13,          1 << 12,              0,  1},
#endif
    {"VGHL_PWM_REG0",       P_VGHL_PWM_REG0,      1 << 13,          1 << 12,              0,  1},
};



void analog_switch(int flag)
{
    int i;
    unsigned reg_value = 0;

    if (flag) {
        printf("analog on\n");
        setbits_le32(P_AM_ANALOG_TOP_REG0, 1 << 1); // set 0x206e bit[1] 1 to power on top analog
        for (i = 0; i < ANALOG_COUNT; i++) {
            if (analog_regs[i].enable && (analog_regs[i].set_bits || analog_regs[i].clear_bits)) {
                if (analog_regs[i].enable == 1) {
                	writel(analog_regs[i].reg_value, analog_regs[i].reg_addr);
                } else if (analog_regs[i].enable == 2) {
                    writel(analog_regs[i].reg_value, analog_regs[i].reg_addr);
                } else if (analog_regs[i].enable == 3) {
                    writel(analog_regs[i].reg_value, analog_regs[i].reg_addr);
                }
            }
        }
    } else {
        printf("analog off\n");
        for (i = 0; i < ANALOG_COUNT; i++) {
            if (analog_regs[i].enable && (analog_regs[i].set_bits || analog_regs[i].clear_bits)) {
                if (analog_regs[i].enable == 1) {
                    analog_regs[i].reg_value = readl(analog_regs[i].reg_addr);
                    printf("%s(0x%x):0x%x", analog_regs[i].name, analog_regs[i].reg_addr, analog_regs[i].reg_value);
                    if (analog_regs[i].clear_bits) {
                        clrbits_le32(analog_regs[i].reg_addr, analog_regs[i].clear_bits);
                        printf(" & ~0x%x", analog_regs[i].clear_bits);
                    }
                    if (analog_regs[i].set_bits) {
                        setbits_le32(analog_regs[i].reg_addr, analog_regs[i].set_bits);
                        printf(" | 0x%x", analog_regs[i].set_bits);
                    }
                    reg_value = readl(analog_regs[i].reg_addr);
                    printf(" = 0x%x\n", reg_value);
                } else if (analog_regs[i].enable == 2) {
                    analog_regs[i].reg_value = readl(analog_regs[i].reg_addr);
                    printf("%s(0x%x):0x%x", analog_regs[i].name, analog_regs[i].reg_addr, analog_regs[i].reg_value);
                    if (analog_regs[i].clear_bits) {
                    		clrbits_le32(analog_regs[i].reg_addr, analog_regs[i].clear_bits);
                        printf(" & ~0x%x", analog_regs[i].clear_bits);
                    }
                    if (analog_regs[i].set_bits) {
                    		setbits_le32(analog_regs[i].reg_addr, analog_regs[i].set_bits);
                        printf(" | 0x%x", analog_regs[i].set_bits);
                    }
                    reg_value = readl(analog_regs[i].reg_addr);
                    printf(" = 0x%x\n", reg_value);
                } else if (analog_regs[i].enable == 3) {
                    analog_regs[i].reg_value = readl(analog_regs[i].reg_addr);
                    printf("%s(0x%x):0x%x", analog_regs[i].name, analog_regs[i].reg_addr, analog_regs[i].reg_value);
                    if (analog_regs[i].clear_bits) {
                        clrbits_le32(analog_regs[i].reg_addr, analog_regs[i].clear_bits);
                        printf(" & ~0x%x", analog_regs[i].clear_bits);
                    }
                    if (analog_regs[i].set_bits) {
                        setbits_le32(analog_regs[i].reg_addr, analog_regs[i].set_bits);
                        printf(" | 0x%x", analog_regs[i].set_bits);
                    }
                    reg_value = readl(analog_regs[i].reg_addr);
                    printf(" = 0x%x\n", reg_value);
                }
            }
        }
        clrbits_le32(P_AM_ANALOG_TOP_REG0, 1 << 1); // set 0x206e bit[1] 0 to shutdown top analog
    }
}

unsigned char GCLK_ref[GCLK_IDX_MAX];

#define GATE_OFF(_MOD) do {power_gate_flag[GCLK_IDX_##_MOD] = IS_CLK_GATE_ON(_MOD);CLK_GATE_OFF(_MOD);} while(0)
#define GATE_ON(_MOD) do {if (power_gate_flag[GCLK_IDX_##_MOD]) CLK_GATE_ON(_MOD);} while(0)
#define GATE_SWITCH(flag, _MOD) do {if (flag) GATE_ON(_MOD); else GATE_OFF(_MOD);} while(0)
static int power_gate_flag[GCLK_IDX_MAX];



void power_gate_switch(int flag)
{
#ifndef ADJUST_CORE_VOLTAGE
    GATE_SWITCH(flag, LED_PWM);
#endif
    //GATE_SWITCH(flag, DDR);
    GATE_SWITCH(flag, DOS);
    GATE_SWITCH(flag,MIPI_APB_CLK);
    GATE_SWITCH(flag,MIPI_SYS_CLK);
    //GATE_SWITCH(flag, AHB_BRIDGE);
    //GATE_SWITCH(flag, ISA);
    //GATE_SWITCH(flag, APB_CBUS);
    //GATE_SWITCH(flag, _1200XXX);
    GATE_SWITCH(flag, SPICC);
    GATE_SWITCH(flag, I2C);
    GATE_SWITCH(flag, SAR_ADC);
    GATE_SWITCH(flag, SMART_CARD_MPEG_DOMAIN);
    GATE_SWITCH(flag, RANDOM_NUM_GEN);
    GATE_SWITCH(flag, UART0);
    GATE_SWITCH(flag, SDHC);
    GATE_SWITCH(flag, STREAM);
    GATE_SWITCH(flag, ASYNC_FIFO);
    GATE_SWITCH(flag, SDIO);
    GATE_SWITCH(flag, AUD_BUF);
    //GATE_SWITCH(flag, HIU_PARSER);
    //GATE_SWITCH(flag, AMRISC);
    GATE_SWITCH(flag, BT656_IN);
    //GATE_SWITCH(flag, ASSIST_MISC);
    GATE_SWITCH(flag, VI_CORE);
    GATE_SWITCH(flag, SPI2);
    //GATE_SWITCH(flag, MDEC_CLK_ASSIST);
    //GATE_SWITCH(flag, MDEC_CLK_PSC);
    GATE_SWITCH(flag, SPI1);
    //GATE_SWITCH(flag, AUD_IN);
    GATE_SWITCH(flag, ETHERNET);
    GATE_SWITCH(flag, AIU_AI_TOP_GLUE);
    GATE_SWITCH(flag, AIU_IEC958);
    GATE_SWITCH(flag, AIU_I2S_OUT);
    GATE_SWITCH(flag, AIU_AMCLK_MEASURE);
    GATE_SWITCH(flag, AIU_AIFIFO2);
    GATE_SWITCH(flag, AIU_AUD_MIXER);
    GATE_SWITCH(flag, AIU_MIXER_REG);
    GATE_SWITCH(flag, AIU_ADC);
    GATE_SWITCH(flag, BLK_MOV);
    //GATE_SWITCH(flag, UART1);
    GATE_SWITCH(flag, VGHL_PWM);
    GATE_SWITCH(flag, GE2D);
    GATE_SWITCH(flag, USB0);
    GATE_SWITCH(flag, USB1);
    //GATE_SWITCH(flag, RESET);
    GATE_SWITCH(flag, NAND);
    GATE_SWITCH(flag, HIU_PARSER_TOP);
    //GATE_SWITCH(flag, MDEC_CLK_DBLK);
    GATE_SWITCH(flag, MIPI_PHY);
    GATE_SWITCH(flag, VIDEO_IN);
    //GATE_SWITCH(flag, AHB_ARB0);
    GATE_SWITCH(flag, EFUSE);
    GATE_SWITCH(flag, ROM_CLK);
    //GATE_SWITCH(flag, AHB_DATA_BUS);
    //GATE_SWITCH(flag, AHB_CONTROL_BUS);
    GATE_SWITCH(flag, MISC_USB1_TO_DDR);
    GATE_SWITCH(flag, MISC_USB0_TO_DDR);
    //GATE_SWITCH(flag, AIU_PCLK);
    //GATE_SWITCH(flag, MMC_PCLK);
    GATE_SWITCH(flag, UART2);
    GATE_SWITCH(flag, DAC_CLK);
    GATE_SWITCH(flag, AIU_AOCLK);
    GATE_SWITCH(flag, AIU_AMCLK);
    GATE_SWITCH(flag, AIU_ICE958_AMCLK);
    GATE_SWITCH(flag, AIU_AUDIN_SCLK);
    GATE_SWITCH(flag, DEMUX);
}
#endif

#define HHI_DEMOD_PLL_CNTL                         0x106d	//Elvis Fool!


#define CLK_COUNT 1
static char clk_flag[CLK_COUNT];
static unsigned clks[CLK_COUNT] = {
//    P_HHI_ETH_CLK_CNTL,
//    P_HHI_VID_CLK_CNTL,
//    P_HHI_VIID_CLK_CNTL,
//    P_HHI_AUD_CLK_CNTL,
//    P_HHI_MALI_CLK_CNTL,
//    P_HHI_HDMI_CLK_CNTL,
    P_HHI_MPEG_CLK_CNTL,
//    P_HHI_DEMOD_PLL_CNTL,
};

static char clks_name[CLK_COUNT][32] = {
//    "HHI_ETH_CLK_CNTL",
//    "HHI_VID_CLK_CNTL",
//    "HHI_VIID_CLK_CNTL",
//    "HHI_AUD_CLK_CNTL",
//    "HHI_MALI_CLK_CNTL",
//    "HHI_HDMI_CLK_CNTL",
    "HHI_MPEG_CLK_CNTL",
//    "HHI_VDEC_CLK_CNTL",
};

__u32 get_clk81_(void)
{
	__u32 fixed_div_src;
	__u32 parent_clk = 2550000000;//2.55G
	
	fixed_div_src = (readl(P_HHI_MPEG_CLK_CNTL) >> 12) & 0x7;

	if(7 == fixed_div_src)
		parent_clk/=5;
	else if(6 == fixed_div_src)
		parent_clk/=3;
	else if(5 == fixed_div_src)
		parent_clk/=4;
	else{
		printf("Error: clk81 not in fixed_pll seleting.\n");
		return 0;
	}

	parent_clk/=((readl(P_HHI_MPEG_CLK_CNTL) & 0x3f))+1;
	
	return parent_clk;	
}

extern __u32 get_rate_xtal(void);
static unsigned uart_rate_backup;
static unsigned xtal_uart_rate_backup;
void clk_switch(int flag)
{
    int i;

    if (flag) {
        for (i = CLK_COUNT - 1; i >= 0; i--) {
            if (clk_flag[i]) {
                if ((clks[i] == P_HHI_VID_CLK_CNTL)||(clks[i] == P_HHI_VIID_CLK_CNTL)) {
                    clrsetbits_le32(clks[i], 0x3<<19, clk_flag[i]);
                }
				else if (clks[i] == P_HHI_MPEG_CLK_CNTL)
				{
            		if(uart_rate_backup == 0){
						uart_rate_backup = get_clk81_();
      				}
					wait_uart_empty();
					setbits_le32(clks[i], (1<<7));//gate on pll
                    udelay(10);
                    setbits_le32(clks[i], (1<<8));//switch to pll
                    udelay(10);
					clrbits_le32(P_UART0_CONTROL, (1 << 19) | 0xFFF);
                  	setbits_le32(P_UART0_CONTROL, (((uart_rate_backup / (115200 * 4)) - 1) & 0xfff));
                    clrbits_le32(P_UART1_CONTROL, (1 << 19) | 0xFFF);
                    setbits_le32(P_UART1_CONTROL, (((uart_rate_backup / (115200 * 4)) - 1) & 0xfff));
                    clrbits_le32(P_AO_UART_CONTROL, (1 << 19) | 0xFFF);
                    clrsetbits_le32(P_AO_UART_CONTROL, 0xfff, ((uart_rate_backup / (115200 * 4)) - 1) & 0xfff);
				}
				else
				{
	                	setbits_le32(clks[i], (1<<8));
				}
                clk_flag[i] = 0;
                printf("clk %s(%x) on\n", clks_name[i], clks[i]);
            }
        }
    } else {
        for (i = 0; i < CLK_COUNT; i++) {
            if ((clks[i] == P_HHI_VID_CLK_CNTL)||(clks[i] == P_HHI_VIID_CLK_CNTL)) {
                clk_flag[i] = (readl(clks[i])>>19)&0x3;
                if (clk_flag[i]) {
                    clrbits_le32(clks[i], (1<<19)|(1<<20));
                }
            } else if (clks[i] == P_HHI_MPEG_CLK_CNTL) {
                if (readl(clks[i]) & (1 << 8))
				{
	              	if(xtal_uart_rate_backup == 0)
					{//if no early suspend supported
						xtal_uart_rate_backup = get_rate_xtal();
                	}
               		wait_uart_empty();
                    clk_flag[i] = 1;
                    clrbits_le32(clks[i], (1 << 8)); // 24M
                    udelay(10);
                    clrbits_le32(clks[i], (1 << 7)); // 24M
                    udelay(10);
                    clrbits_le32(P_UART0_CONTROL, (1 << 19) | 0xFFF);
                    setbits_le32(P_UART0_CONTROL, (((xtal_uart_rate_backup / (115200 * 4)) - 1) & 0xfff));
                    clrbits_le32(P_UART1_CONTROL, (1 << 19) | 0xFFF);
                    setbits_le32(P_UART1_CONTROL, (((xtal_uart_rate_backup / (115200 * 4)) - 1) & 0xfff));
                    clrbits_le32(P_AO_UART_CONTROL, (1 << 19) | 0xFFF);
                    clrsetbits_le32(P_AO_UART_CONTROL, 0xfff, ((xtal_uart_rate_backup / (115200 * 4)) - 1) & 0xfff);
                }
            } else {
                clk_flag[i] = (readl(clks[i])>>8)&1 ? 1 : 0;
                if (clk_flag[i]) {
                    clrbits_le32(clks[i], (1 << 8));
                }
            }
            if (clk_flag[i]) {
                printf("clk %s(%x) off\n", clks_name[i], clks[i]);
             		wait_uart_empty();
             }
        }
    }
}



#if 0

#define PLL_COUNT 1
static char pll_flag[PLL_COUNT];
static unsigned plls[PLL_COUNT] = {
//    P_HHI_VID_PLL_CNTL,
//    P_HHI_VIID_PLL_CNTL,
//    P_HHI_AUD_PLL_CNTL,
    P_HHI_MPLL_CNTL,
};

static char plls_name[PLL_COUNT][32] = {
//    "HHI_VID_PLL_CNTL",
//    "HHI_VIID_PLL_CNTL",
//    "HHI_AUD_PLL_CNTL",
    "HHI_MPLL_CNTL",
};

#define EARLY_PLL_COUNT 2
#if 0
static char early_pll_flag[EARLY_PLL_COUNT];
static unsigned early_plls[EARLY_PLL_COUNT] = {
    P_HHI_VID_PLL_CNTL,
    P_HHI_VIID_PLL_CNTL,
};

static char early_plls_name[EARLY_PLL_COUNT][32] = {
    "HHI_VID_PLL_CNTL",
    "HHI_VIID_PLL_CNTL",
};
#endif

void pll_switch(int flag)
{
    int i;
    if (flag) {
         for (i = PLL_COUNT - 1; i >= 0; i--) {
            if (pll_flag[i])
			{
                if ((plls[i]==P_HHI_VID_PLL_CNTL)||(plls[i]==P_HHI_VIID_PLL_CNTL)||(plls[i]==P_HHI_MPLL_CNTL)){
                    clrbits_le32(plls[i],(1<<30));
                    pll_flag[i] = 0;
                }
                else{                
                    clrbits_le32(plls[i],(1<<15));//bit15 PD:power down
                    pll_flag[i] = 0;
                }
                udelay(10);
             }                
        }
        udelay(1000);
	     } else {
        for (i = 0; i < PLL_COUNT; i++) {
        	  if ((plls[i] == P_HHI_VID_PLL_CNTL)||(plls[i]==P_HHI_VIID_PLL_CNTL)||(plls[i]==P_HHI_MPLL_CNTL))
        	  	pll_flag[i]= (readl(plls[i])>>30)&1 ? 0 : 1;
        	  else	
        	  	pll_flag[i]= (readl(plls[i])>>15)&1 ? 0:1;
            if (pll_flag[i]) {
                printf("pll %s(%x) off\n", plls_name[i], plls[i]);
                if ((plls[i] == P_HHI_VID_PLL_CNTL)||(plls[i]==P_HHI_VIID_PLL_CNTL)){
                    setbits_le32(plls[i], (1<<30));
                }
                else{            
                    setbits_le32(plls[i], (1<<15));
                }
            }
        }
    }
}




#define         MODE_DELAYED_WAKE       0
#define         MODE_IRQ_DELAYED_WAKE   1
#define         MODE_IRQ_ONLY_WAKE      2

static void auto_clk_gating_setup(
    unsigned long sleep_dly_tb, unsigned long mode, unsigned long clear_fiq, unsigned long clear_irq,
    unsigned long   start_delay, unsigned long   clock_gate_dly, unsigned long   sleep_time, unsigned long   enable_delay)
{
}
#endif


#define ON  1
#define OFF 0

//appf functions
#define APPF_INITIALIZE             0
#define APPF_POWER_DOWN_CPU         1
#define APPF_POWER_UP_CPUS          2

/***********************************************
*** appf flag bit map:
*** bit0~bit15 for appf flag
*** bit16~bit31 for l2cache base address
************************************************/
#define APPF_SAVE_PMU          (1<<0)
#define APPF_SAVE_TIMERS       (1<<1)
#define APPF_SAVE_VFP          (1<<2)
#define APPF_SAVE_DEBUG        (1<<3)
#define APPF_SAVE_L2           (1<<4)

#define APPF_UBOOT_FLAG        (1<<15) //call from uboot

#ifdef CONFIG_MESON_TRUSTZONE
int meson_power_suspend(void)
{
	return meson_trustzone_suspend_uboot();
}
#else

//extern void free(void*);
int meson_power_suspend(void)
{
	static int test_flag = 0;
	unsigned addr;
	void	(*pwrtest_entry)(unsigned,unsigned,unsigned,unsigned);

//	flush_cache(0x00000000, 0x40000000);

	addr = 0x04F04400;
	pwrtest_entry = (void (*)(unsigned,unsigned,unsigned,unsigned))addr;
	if(1){
		test_flag = 1234;
		printf("initial appf~\n");
		pwrtest_entry(APPF_INITIALIZE,0,0,APPF_UBOOT_FLAG |  (L2X0_BASE & 0xffff0000));
	}

	printf("power down cpu --\n");
	pwrtest_entry(APPF_POWER_DOWN_CPU,0,0,APPF_UBOOT_FLAG |  (L2X0_BASE & 0xffff0000));

	return 0;
}
#endif

#if 1
extern void *malloc (size_t len);
extern int get_adc_sample(int chan);
void meson_pm_suspend(void)
{
//    unsigned ddr_clk_N;
//	uint32_t elvis_array[10]={0};
#if 0
	//Elvis Fool!
	pdata = (struct meson_pm_config *)malloc(sizeof(struct meson_pm_config));
	pdata->set_vccx2 = NULL;
	pdata->set_exgpio_early_suspend = NULL;

	
#ifdef ADJUST_CORE_VOLTAGE
     unsigned vcck_backup = readl(P_LED_PWM_REG0) & 0xf;
    printf("current vcck is 0x%x!\n", vcck_backup);
#endif

    printf("enter meson_pm_suspend!\n");
#ifdef CONFIG_SUSPEND_WATCHDOG
		extern void enable_watchdog(void);
		enable_watchdog();
#endif

    // Disable MMC_LP_CTRL. Will be re-enabled at resume by kreboot.S
    //printf("MMC_LP_CTRL1 before=%#x\n", readl(P_MMC_LP_CTRL1));
    //writel(0x60a80000, P_MMC_LP_CTRL1);
    //printf("MMC_LP_CTRL1 after=%#x\n", readl(P_MMC_LP_CTRL1));
	
    pdata->ddr_clk = readl(P_HHI_DDR_PLL_CNTL);

    ddr_clk_N = (pdata->ddr_clk >> 9) & 0x1f;
    ddr_clk_N = ddr_clk_N * 4; // N*4
    if (ddr_clk_N > 0x1f) {
        ddr_clk_N = 0x1f;
    }
    pdata->ddr_clk &= ~(0x1f << 9);
    pdata->ddr_clk |= ddr_clk_N << 9;

    printf("target ddr clock 0x%x!\n", pdata->ddr_clk);
	
	elvis_array[0] = get_adc_sample(4);
	printf("0:0x%x\n", elvis_array[0]);

#ifndef SUSPEND_WITH_SARADC_ON	
//    analog_switch(OFF);
#endif

    //usb_switch(OFF, 0);
    //usb_switch(OFF, 1);

    if (pdata->set_vccx2) {
        pdata->set_vccx2(OFF);
    }
#endif

	printf("a\n");
    
	printf("b\n");
    clk_switch(OFF);
	printf("c\n");
//	elvis_array[2] = get_adc_sample(4);
//	printf("2:0x%x\n", elvis_array[2]);
//    pll_switch(OFF);

//	power_gate_switch(OFF);

    printf("sleep ...\n");


	//switch A9 clock to xtal 24MHz
	clrbits_le32(P_HHI_SYS_CPU_CLK_CNTL, 1 << 7);
//	setbits_le32(P_HHI_SYS_PLL_CNTL, 1 << 30);//power down sys pll
		


#ifdef CONFIG_MESON_SUSPEND

	writel(0x87654321, P_AO_RTI_STATUS_REG2);//set flag for u-boot suspend cmd
    meson_power_suspend();

#endif


//		clrbits_le32(P_HHI_SYS_PLL_CNTL, (1 << 30)); //turn on sys pll

    printf("... wake up\n");

    if ((*(volatile unsigned *)(P_AO_RTC_ADDR1)) & (1<<12)) {
        // Woke from alarm, not power button. Set flag to inform key_input driver.
        writel(0x12345678, P_AO_RTI_STATUS_REG2);
    }
    // clear RTC interrupt
    *(volatile unsigned *)(P_AO_RTC_ADDR1)=(*(volatile unsigned *)(P_AO_RTC_ADDR1))|(0xf000);
	printf("RTCADD3=0x%x\n",*(volatile unsigned *)(P_AO_RTC_ADDR3));
	if((*(volatile unsigned *)(P_AO_RTC_ADDR3))|(1<<29))
	{
		*(volatile unsigned *)(P_AO_RTC_ADDR3)=(*(volatile unsigned *)(P_AO_RTC_ADDR3))&(~(1<<29));
		udelay(1000);
	}
	printf("RTCADD3=0x%x\n",*(volatile unsigned *)P_AO_RTC_ADDR3);

//    if (pdata->set_vccx2) {
//        pdata->set_vccx2(ON);
//    }
    wait_uart_empty();
	setbits_le32(P_HHI_SYS_CPU_CLK_CNTL , (1 << 7)); //a9 use pll

//    pll_switch(ON);
	    
    clk_switch(ON);

//    power_gate_switch(ON);

    //usb_switch(ON, 0);
    //usb_switch(ON, 1);
#ifndef SUSPEND_WITH_SARADC_ON	
//    analog_switch(ON);
#endif

//	free(pdata);
	//aml_lcd_init();
//	printf("0:0x%x; 1:0x%x; 2:0x%x; 3:0x%x\n", elvis_array[0], elvis_array[1], elvis_array[2], elvis_array[3]);
}
#endif
