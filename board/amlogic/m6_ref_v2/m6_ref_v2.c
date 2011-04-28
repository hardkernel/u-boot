#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>
#include <malloc.h>

#if defined(CONFIG_CMD_NET)
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>
#include <asm/arch/io.h>
#endif /*(CONFIG_CMD_NET)*/

#ifdef CONFIG_SARADC
#include <asm/saradc.h>
#endif /*CONFIG_SARADC*/

#if defined(CONFIG_AML_I2C)
#include <aml_i2c.h>
#include <asm/arch/io.h>
#endif /*CONFIG_AML_I2C*/

#ifdef CONFIG_PLATFORM_HAS_PMU
#include <amlogic/aml_pmu_common.h>
#endif

DECLARE_GLOBAL_DATA_PTR;

#ifdef CONFIG_UBOOT_BATTERY_PARAMETERS
#include <amlogic/battery_parameter.h>
/*
 * add board battery parameters, this is a backup option if uboot process 
 * battery parameters failed, each board shoud use your own battery parameters
 */
int config_battery_rdc = 87;
struct battery_curve config_battery_curve[] = { 
    {3132,      0,      0},  
    {3273,      0,      0},  
    {3414,      0,      0},  
    {3555,      0,      0},  
    {3625,      1,      3},  
    {3660,      2,      8},  
    {3696,      3,     16}, 
    {3731,     10,     24}, 
    {3766,     15,     38}, 
    {3801,     26,     48}, 
    {3836,     42,     56},
    {3872,     52,     63},
    {3942,     66,     74},
    {4012,     79,     85},
    {4083,     90,     94},
    {4153,    100,    100}
};
#endif

#if defined(CONFIG_CMD_NET)

/*************************************************
  * Amlogic Ethernet controller operation
  * 
  * Note: The LAN chip LAN8720 need to be reset by GPIOA_23
  *
  *************************************************/
static void setup_net_chip(void)
{
	//disable all other pins which share the GPIOA_23
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_0,(1<<6)); //LCDin_B7 R0[6]
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_7,(1<<11));//ENC_11 R7[11]
	//GPIOA_23 -> 0
    CLEAR_CBUS_REG_MASK(PREG_EGPIO_O,1<<23);    //RST -> 0
    //GPIOA_23 output enable
    CLEAR_CBUS_REG_MASK(PREG_EGPIO_EN_N,1<<23); //OUTPUT enable	
    udelay(2000);
	//GPIOA_23 -> 1
    SET_CBUS_REG_MASK(PREG_EGPIO_O,1<<23);      //RST -> 1
    udelay(2000);	
}

int board_eth_init(bd_t *bis)
{   	
	//set clock
    eth_clk_set(ETH_CLKSRC_MISC_PLL_CLK,800*CLK_1M,50*CLK_1M);	

	//set pinmux
    aml_eth_set_pinmux(ETH_BANK0_GPIOY1_Y9,ETH_CLK_OUT_GPIOY0_REG6_17,0);

	//ethernet pll control
    writel(readl(ETH_PLL_CNTL) & ~(0xF << 0), ETH_PLL_CNTL); // Disable the Ethernet clocks        
    writel(readl(ETH_PLL_CNTL) | (0 << 3), ETH_PLL_CNTL);    // desc endianess "same order"   
    writel(readl(ETH_PLL_CNTL) | (0 << 2), ETH_PLL_CNTL);    // data endianess "little"    
    writel(readl(ETH_PLL_CNTL) | (1 << 1), ETH_PLL_CNTL);    // divide by 2 for 100M     
    writel(readl(ETH_PLL_CNTL) | (1 << 0), ETH_PLL_CNTL);    // enable Ethernet clocks   
    
    udelay(1000);

	//reset LAN8720 with GPIOA_23
    setup_net_chip();

    udelay(1000);
	
extern int aml_eth_init(bd_t *bis);

    aml_eth_init(bis);

	return 0;
}
#endif /* (CONFIG_CMD_NET) */

#ifdef CONFIG_SARADC
/*following key value are test with board 
  [M3_SKT_V1 20110622]
  ref doc:
  1. m3_skt_v1.pdf(2011.06.22)
  2. M3-Periphs-Registers.docx (Pg43-47)
*/
static struct adckey_info g_key_K1_info[] = {
    {"K1", 6, 60},
};
static struct adckey_info g_key_K2_info[] = {
    {"K2", 180, 60},
};
static struct adckey_info g_key_K3_info[] = {
    {"K3", 400, 60},
};
static struct adckey_info g_key_K4_info[] = {
    {"K4", 620, 60},
};
static struct adckey_info g_key_K5_info[] = {
    {"K5", 850, 60},
};

static struct adc_info g_adc_info[] = {
    {"Press Key K1", AML_ADC_CHAN_4, ADC_KEY,&g_key_K1_info},
    {"Press Key K2", AML_ADC_CHAN_4, ADC_KEY,&g_key_K2_info},
    {"Press Key K3", AML_ADC_CHAN_4, ADC_KEY,&g_key_K3_info},
    {"Press Key K4", AML_ADC_CHAN_4, ADC_KEY,&g_key_K4_info},
    {"Press Key K5", AML_ADC_CHAN_4, ADC_KEY,&g_key_K5_info},
    {"Press Key N/A",AML_ADC_CHAN_5, ADC_OTHER, NULL},
};

struct adc_device aml_adc_devices={
	.adc_device_info = g_adc_info,
	.dev_num = sizeof(g_adc_info)/sizeof(struct adc_info)
};

/* adc_init(&g_adc_info, ARRAY_SIZE(g_adc_info)); */
/* void adc_init(struct adc_info *adc_info, unsigned int len) 
     @trunk/common/sys_test.c */

/*following is test code to test ADC & key pad*/
/*
#ifdef CONFIG_SARADC
#include <asm/saradc.h>
	saradc_enable();	
	u32 nDelay = 0xffff;
	int nKeyVal = 0;
	int nCnt = 0;
	while(nCnt < 3)
	{
		udelay(nDelay);
		nKeyVal = get_adc_sample(4);
		if(nKeyVal > 1000)
			continue;
		
		printf("get_key(): %d\n", nKeyVal);
		nCnt++;
	}
	saradc_disable();
#endif
*/
#endif

u32 get_board_rev(void)
{
    /*
    @todo implement this function
    */
	return 0x20;
}

#if CONFIG_CMD_MMC
#include <mmc.h>
#include <asm/arch/sdio.h>
static int  sdio_init(unsigned port)
{	
    //todo add card detect 	
	setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6

    return cpu_sdio_init(port);
}
static int  sdio_detect(unsigned port)
{
	int ret;
	setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
	ret=readl(P_PREG_PAD_GPIO5_I)&(1<<29)?0:1;
	printf( " %s return %d\n",__func__,ret);
	return 0;
}
static void sdio_pwr_prepare(unsigned port)
{
    /// @todo NOT FINISH
	///do nothing here
	cpu_sdio_pwr_prepare(port);
}
static void sdio_pwr_on(unsigned port)
{
	clrbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
	clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
    /// @todo NOT FINISH
}
static void sdio_pwr_off(unsigned port)
{
	setbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
	clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
	/// @todo NOT FINISH
}
static void board_mmc_register(unsigned port)
{
    struct aml_card_sd_info *aml_priv=cpu_sdio_get(port);
    
    struct mmc *mmc = (struct mmc *)malloc(sizeof(struct mmc));
    if(aml_priv==NULL||mmc==NULL)
        return;
    memset(mmc,0,sizeof(*mmc));
    aml_priv->sdio_init=sdio_init;
	aml_priv->sdio_detect=sdio_detect;
	aml_priv->sdio_pwr_off=sdio_pwr_off;
	aml_priv->sdio_pwr_on=sdio_pwr_on;
	aml_priv->sdio_pwr_prepare=sdio_pwr_prepare;
	sdio_register(mmc,aml_priv);
#if 0    
    strncpy(mmc->name,aml_priv->name,31);
    mmc->priv = aml_priv;
	aml_priv->removed_flag = 1;
	aml_priv->inited_flag = 0;
	aml_priv->sdio_init=sdio_init;
	aml_priv->sdio_detect=sdio_detect;
	aml_priv->sdio_pwr_off=sdio_pwr_off;
	aml_priv->sdio_pwr_on=sdio_pwr_on;
	aml_priv->sdio_pwr_prepare=sdio_pwr_prepare;
	mmc->send_cmd = aml_sd_send_cmd;
	mmc->set_ios = aml_sd_cfg_swth;
	mmc->init = aml_sd_init;
	mmc->rca = 1;
	mmc->voltages = MMC_VDD_33_34;
	mmc->host_caps = MMC_MODE_4BIT | MMC_MODE_HS;
	//mmc->host_caps = MMC_MODE_4BIT;
	mmc->bus_width = 1;
	mmc->clock = 300000;
	mmc->f_min = 200000;
	mmc->f_max = 50000000;
	mmc_register(mmc);
#endif	
}
int board_mmc_init(bd_t	*bis)
{
//board_mmc_register(SDIO_PORT_A);
	board_mmc_register(SDIO_PORT_B);
//	board_mmc_register(SDIO_PORT_C);
//	board_mmc_register(SDIO_PORT_B1);
	return 0;
}
#endif

#ifdef CONFIG_AML_I2C 
/*I2C module is board depend*/
static void board_i2c_set_pinmux(void){
	/*@AML9726-MX-MAINBOARD_V1.0.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
    /*********************************************/
    /*                | I2C_Master_AO        |I2C_Slave            |       */
    /*********************************************/
    /*                | I2C_SCK                | I2C_SCK_SLAVE  |      */
    /* GPIOAO_4  | [AO_PIN_MUX: 6]     | [AO_PIN_MUX: 2]   |     */
    /*********************************************/
    /*                | I2C_SDA                 | I2C_SDA_SLAVE  |     */
    /* GPIOAO_5  | [AO_PIN_MUX: 5]     | [AO_PIN_MUX: 1]   |     */
    /*********************************************/	

	//disable all other pins which share with I2C_SDA_AO & I2C_SCK_AO
    clrbits_le32(P_AO_RTI_PIN_MUX_REG, ((1<<2)|(1<<24)|(1<<1)|(1<<23)));
    //enable I2C MASTER AO pins
	setbits_le32(P_AO_RTI_PIN_MUX_REG,
	(MESON_I2C_MASTER_AO_GPIOAO_4_BIT | MESON_I2C_MASTER_AO_GPIOAO_5_BIT));
	
    udelay(10000);
	
};
struct aml_i2c_platform g_aml_i2c_plat = {
    .wait_count         = 1000000,
    .wait_ack_interval  = 5,
    .wait_read_interval = 5,
    .wait_xfer_interval = 5,
    .master_no          = AML_I2C_MASTER_AO,
    .use_pio            = 0,
    .master_i2c_speed   = AML_I2C_SPPED_400K,
    .master_ao_pinmux = {
        .scl_reg    = MESON_I2C_MASTER_AO_GPIOAO_4_REG,
        .scl_bit    = MESON_I2C_MASTER_AO_GPIOAO_4_BIT,
        .sda_reg    = MESON_I2C_MASTER_AO_GPIOAO_5_REG,
        .sda_bit    = MESON_I2C_MASTER_AO_GPIOAO_5_BIT,
    }
};

#ifdef CONFIG_PLATFORM_HAS_PMU
static void board_pmu_init(void)
{
    struct aml_pmu_driver *driver = aml_pmu_get_driver();
    if (driver && driver->pmu_init) {
        driver->pmu_init();
    }
}
#endif

static void board_i2c_init(void)
{		
	//set I2C pinmux with PCB board layout
	/*@AML9726-MX-MAINBOARD_V1.0.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	//must call aml_i2c_init(); before any I2C operation	
	/*M6 board*/
	//udelay(10000);	

	udelay(10000);
#ifdef CONFIG_PLATFORM_HAS_PMU
    board_pmu_init();
#endif
}
#endif /*CONFIG_AML_I2C*/


#if CONFIG_JERRY_NAND_TEST //temp test
#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <linux/mtd/partitions.h>
static void claim_bus(uint32_t get)
{
	if(get==NAND_BUS_RELEASE)
	{
		NAND_IO_DISABLE(0);
	}else{
		NAND_IO_ENABLE(0);
	}
}
static struct aml_nand_platform nand_plat={
/*
		uint32_t        reg_base;
		    uint32_t        delay;
		    uint32_t        rbmod;
		    uint32_t        t_rea;
		    uint32_t        t_rhoh;
		    uint32_t        ce_num;
		    uint32_t        clk_src;
		    claim_bus_t     claim_bus;
*/
		.ce_num=4,
		.rbmod=1,
};
void    board_nand_init(void)
{
	nanddebug("NAND is inited\n");
	nand_probe(&nand_plat);
//	cntl_init(&nand_plat);
//	amlnand_probe();
}
#elif CONFIG_NAND_AML_M3 //temp test
//#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <linux/mtd/partitions.h>


static struct aml_nand_platform aml_nand_mid_platform[] = {
    {
        .name = NAND_BOOT_NAME,
        .chip_enable_pad = AML_NAND_CE0,
        .ready_busy_pad = AML_NAND_CE0,
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 1,
                .options = (NAND_TIMING_MODE5 | NAND_ECC_BCH60_1K_MODE),
            },
        },
	.rbpin_detect=1,
        .T_REA = 20,
        .T_RHOH = 15,
    },
    {
        .name = NAND_NORMAL_NAME,
        .chip_enable_pad =((AML_NAND_CE0) | (AML_NAND_CE1 << 4)| (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12)),
        .ready_busy_pad = (AML_NAND_CE0) | (AML_NAND_CE1 << 4), //| (AML_NAND_CE1 << 8) | (AML_NAND_CE1 << 12)),
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 2,
                .options = (NAND_TIMING_MODE5 | NAND_ECC_BCH60_1K_MODE | NAND_TWO_PLANE_MODE),
            },
        },
	.rbpin_detect=1,
        .T_REA = 20,
        .T_RHOH = 15,
    }
    
};

struct aml_nand_device aml_nand_mid_device = {
    .aml_nand_platform = aml_nand_mid_platform,
    .dev_num = ARRAY_SIZE(aml_nand_mid_platform),
};
#endif

#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
//@board schematic: m3_skt_v1.pdf
//@pinmax: AppNote-M3-CorePinMux.xlsx
//GPIOA_26 used to set VCCX2_EN: 0 to enable power and 1 to disable power
static void gpio_set_vbus_power(char is_power_on)
{
#if 0
	if(is_power_on)
	{
		//@WA-AML8726-M3_REF_V1.0.pdf
	    //GPIOA_26 -- VCCX2_EN
		set_gpio_mode(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), 0);
	
		//@WA-AML8726-M3_REF_V1.0.pdf
		//GPIOD_9 -- USB_PWR_CTL
		set_gpio_mode(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), 1);
		
		udelay(100000);
	}
	else
	{
		set_gpio_mode(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOD_bank_bit0_9(9), GPIOD_bit_bit0_9(9), 0);

		set_gpio_mode(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), GPIO_OUTPUT_MODE);
		set_gpio_val(GPIOA_bank_bit0_27(26), GPIOA_bit_bit0_27(26), 1);		
	}
#endif	
}
static int usb_charging_detect_call_back(char bc_mode)
{
#ifdef CONFIG_PLATFORM_HAS_PMU
    struct aml_pmu_driver    *driver = aml_pmu_get_driver();
    struct battery_parameter *battery;
#endif
	switch(bc_mode){
		case BC_MODE_DCP:
		case BC_MODE_CDP:
			//Pull up chargging current > 500mA
        #ifdef CONFIG_PLATFORM_HAS_PMU
            /*
             * Policy:
             * for charger and PC + charger, don't limit usb current
             */
            if (driver && driver->pmu_set_usb_current_limit) {
                driver->pmu_set_usb_current_limit(-1);                  // -1 means do not limit usb current
            }
        #endif
			break;

		case BC_MODE_UNKNOWN:
		case BC_MODE_SDP:
		default:
			//Limit chargging current <= 500mA
			//Or detet dec-charger
        #ifdef CONFIG_PLATFORM_HAS_PMU 
            /* 
             * for PC: 
             * If pmu_usbcur_limit is 1 in dts, then set usb current by  
             * value pmu_usbcur set in dts. If pmu_usbcur_limit is 0, then don't  
             * limit  usb current. If not find battery parameters, set usb current 
             * to 500mA as default 
             */ 
            battery = get_battery_para(); 
            if (driver && battery && driver->pmu_set_usb_current_limit) { 
                if (battery->pmu_usbcur_limit) { 
                    driver->pmu_set_usb_current_limit(battery->pmu_usbcur); 
                } else { 
                    driver->pmu_set_usb_current_limit(-1); 
                } 
            } else { 
                driver->pmu_set_usb_current_limit(500); 
            } 
        #endif 
			break;
	}
	return 0;
}
//note: try with some M3 pll but only following can work
//USB_PHY_CLOCK_SEL_M3_XTAL @ 1 (24MHz)
//USB_PHY_CLOCK_SEL_M3_XTAL_DIV2 @ 0 (12MHz)
//USB_PHY_CLOCK_SEL_M3_DDR_PLL @ 27(336MHz); @Rev2663 M3 SKT board DDR is 336MHz
//                                                            43 (528MHz); M3 SKT board DDR not stable for 528MHz
struct amlogic_usb_config g_usb_config_m6_skt={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_A,
	USB_ID_MODE_SW_HOST,
	gpio_set_vbus_power, //set_vbus_power
	usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/

int board_init(void)
{
	gd->bd->bi_arch_number=MACH_TYPE_MESON6_REF;
	gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;
#if CONFIG_JERRY_NAND_TEST //temp test	
    nand_init();
    
#endif    
    
	return 0;
}

#ifdef	BOARD_LATE_INIT
int board_late_init(void)
{
	unsigned char val;
#ifdef CONFIG_AML_I2C  
	board_i2c_init();
#endif /*CONFIG_AML_I2C*/

#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m6_skt,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt,BOARD_USB_MODE_CHARGER);
#endif /*CONFIG_USB_DWC_OTG_HCD*/

	return 0;
}
#endif




//POWER key
inline void key_init(void)
{
#ifdef CONFIG_MESON_TRUSTZONE
	unsigned temp = meson_trustzone_rtc_read_reg32(P_RTC_ADDR0);
	temp &= (~(1<<11));
	meson_trustzone_rtc_write_reg32(P_RTC_ADDR0, temp);
	
	temp = meson_trustzone_rtc_read_reg32(P_RTC_ADDR1);
	temp &= (~(1<<3));
	meson_trustzone_rtc_write_reg32(P_RTC_ADDR1, temp);
#else	
	clrbits_le32(P_RTC_ADDR0, (1<<11));
	clrbits_le32(P_RTC_ADDR1, (1<<3));
#endif	
}

inline int get_key(void)
{
#ifdef CONFIG_MESON_TRUSTZONE
	unsigned temp = meson_trustzone_rtc_read_reg32(P_RTC_ADDR1);
	return (((temp >> 2) & 1) ? 0 : 1);
#else	
	return (((readl(P_RTC_ADDR1) >> 2) & 1) ? 0 : 1);
#endif		
}


#ifdef CONFIG_AML_TINY_USBTOOL
int usb_get_update_result(void)
{
	unsigned long upgrade_step;
	upgrade_step = simple_strtoul (getenv ("upgrade_step"), NULL, 16);
	printf("upgrade_step = %d\n", upgrade_step);
	if(upgrade_step == 1)
	{
		run_command("defenv", 1);
		run_command("setenv upgrade_step 2", 1);
		run_command("saveenv", 1);
		return 0;
	}
	else
	{
		return -1;
	}
}
#endif


