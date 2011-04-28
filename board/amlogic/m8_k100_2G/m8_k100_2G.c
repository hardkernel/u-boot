#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>
#include <malloc.h>

#if defined(CONFIG_CMD_NET)
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>
#include <asm/arch/io.h>
#endif /*(CONFIG_CMD_NET)*/

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
int config_battery_rdc = 94;
struct battery_curve config_battery_curve[] = { 
    /* ocv, charge, discharge */
    {3132,     0,      0},  
    {3273,     0,      0},  
    {3414,     0,      0},  
    {3555,     0,      0},  
    {3625,     1,      3},  
    {3660,     2,      7},  
    {3696,     7,     14}, 
    {3731,    12,     22}, 
    {3766,    18,     37}, 
    {3801,    37,     49}, 
    {3836,    51,     57}, 
    {3872,    57,     63}, 
    {3942,    69,     73}, 
    {4012,    80,     82}, 
    {4083,    89,     90}, 
    {4153,   100,    100},
};
#endif

#if defined(CONFIG_CMD_NET)
/*************************************************
  * Amlogic Ethernet controller operation
  * 
  * Note: The LAN chip LAN8720 need to be reset
  *
  *************************************************/
static void setup_net_chip(void)
{
	//m8 only use externel clock
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x4f00); // clock Input 50 inverted : bit14 =1 Div : 6:0 = 0 En : bit8 = 1  Sel : bit 11:9 = 7
	/* setup ethernet pinmux use gpioz(5-14) */
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, (1 << 14) | (1 << 13) | (1 << 12) |
	(1 << 11) | (1 << 8 ) | (1 << 7 ) | (1 << 9 ) | (1 << 6 ) | (1 << 5 ));
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x211);//bit6-4 :001 rmii mode
	/* setup ethernet interrupt use num 8 */
	//SET_CBUS_REG_MASK(MEDIA_CPU_INTR_MASK, 1 << 8);
	//SET_CBUS_REG_MASK(MEDIA_CPU_INTR_STAT, 1 << 8);
	/* hardware reset ethernet phy : gpioz14 connect phyreset pin*/
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO1_EN_N, 1 << 31);
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO1_O, 1 << 31);
	udelay(2000);
	SET_CBUS_REG_MASK(PREG_PAD_GPIO1_O, 1 << 31);
}

int board_eth_init(bd_t *bis)
{   	
    setup_net_chip();
    udelay(1000);
	extern int aml_eth_init(bd_t *bis);
    aml_eth_init(bis);
	return 0;
}
#endif /* (CONFIG_CMD_NET) */

u32 get_board_rev(void)
{
 
	return 0x20;
}

#if CONFIG_CMD_MMC
#include <mmc.h>
#include <asm/arch/sdio.h>
static int  sdio_init(unsigned port)
{
    switch(port)
    {
        case SDIO_PORT_A:
            break;
        case SDIO_PORT_B:
            //todo add card detect 	
            setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
            break;
        case SDIO_PORT_C:    	
            //enable pull up
            clrbits_le32(P_PAD_PULL_UP_REG3, 0xff<<0);
            break;
        case SDIO_PORT_XC_A:
            break;
        case SDIO_PORT_XC_B:
            break;
        case SDIO_PORT_XC_C:
            break;
        default:
            break;
    }

    return cpu_sdio_init(port);
}

extern unsigned sdio_debug_1bit_flag;

static int  sdio_detect(unsigned port)
{	
    int ret;
    switch(port)
    {
        case SDIO_PORT_A:
            break;
        case SDIO_PORT_B:
            setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
            ret=readl(P_PREG_PAD_GPIO5_I)&(1<<29)?0:1;
            printf( " %s return %d\n",__func__,ret);
            
			if(!(readl(P_PREG_PAD_GPIO0_I)&(1<<26))){ //sd_d3 low, debug board in
				if(!(readl(P_PREG_PAD_GPIO0_I)&(1<<22))){
					printf("sdio debug board detected, sd card with 1bit mode\n");
		 			sdio_debug_1bit_flag = 1;
		 		}
		 		else{ 
		 			printf("sdio debug board detected, no sd card in\n");
		 			sdio_debug_1bit_flag = 0;
		 			return 1;
		 		}
		 	}
		 	            
            break;
        case SDIO_PORT_C:    	
            break;
        case SDIO_PORT_XC_A:
            break;
        case SDIO_PORT_XC_B:
            break;
        case SDIO_PORT_XC_C:
            break;
        default:
            break;
    }

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
    switch(port)
    {
        case SDIO_PORT_A:
            break;
        case SDIO_PORT_B:
            clrbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
			/// @todo NOT FINISH
            break;
        case SDIO_PORT_C:    	
            break;
        case SDIO_PORT_XC_A:
            break;
        case SDIO_PORT_XC_B:
            break;
        case SDIO_PORT_XC_C:
            break;
        default:
            break;
    }
    return;
}
static void sdio_pwr_off(unsigned port)
{
    /// @todo NOT FINISH
    switch(port)
    {
        case SDIO_PORT_A:
            break;
        case SDIO_PORT_B:
            setbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
            break;
        case SDIO_PORT_C:
            break;
        case SDIO_PORT_XC_A:
            break;
        case SDIO_PORT_XC_B:
            break;
        case SDIO_PORT_XC_C:
            break;
        default:
            break;
    }
    return;
}

// #define CONFIG_TSD      1
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
    
// #ifdef CONFIG_TSD
    // // if(mmc->block_dev.dev > 0)//tsd
          // mmc->block_dev.if_type = IF_TYPE_SD;
// #else
    // // if(mmc->block_dev.dev > 0)//emmc
          // mmc->block_dev.if_type = IF_TYPE_MMC;
// #endif

	sdio_register(mmc, aml_priv);

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
	board_mmc_register(SDIO_PORT_C);
//	board_mmc_register(SDIO_PORT_B1);
	return 0;
}
#endif


#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
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
struct amlogic_usb_config g_usb_config_m6_skt_a={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_A,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_b={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_B,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_h={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_A,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/
#ifdef CONFIG_IR_REMOTE
void board_ir_init(void)
{
	writel(0x00005801,P_AO_RTI_PIN_MUX_REG);
	writel(0x30fa0013,P_AO_IR_DEC_REG0);
	writel(0x0ee8be40,P_AO_IR_DEC_REG1);
	writel(0x01d801ac,P_AO_IR_DEC_LDR_ACTIVE);
	writel(0x00f800ca,P_AO_IR_DEC_LDR_IDLE);
	writel(0x0044002c,P_AO_IR_DEC_BIT_0);
	printf("IR init done!\n");

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
#endif

#ifdef CONFIG_PLATFORM_HAS_PMU
static void board_pmu_init(void)
{
    struct aml_pmu_driver *driver = aml_pmu_get_driver();
    if (driver && driver->pmu_init) {
        driver->pmu_init(); 
    }
}
#endif

inline void key_init(void)
{
    setbits_le32(P_AO_GPIO_O_EN_N, (1 << 3));                           // GPIOAO_3 as power key input
    clrbits_le32(P_AO_RTI_PIN_MUX_REG, (1 << 9));                       // clear pinmux as gpio function 
    setbits_le32(P_AO_RTI_PULL_UP_REG, ((1 << 3) | (1 << 19)));         // enable pull up/down of gpio3
}

inline int get_key(void)
{
    return (readl(P_AO_GPIO_I) & (1 << 3)) ? 0 : 1;
}

int power_key_num = 0;
int update_key_num = 0;

void magic_checkstatus(int saveEnvFlag){
	static int adc_init = 0;

	if(!adc_init){
		run_command("saradc open 0", 0);
		adc_init = 1;
	}
	
	if( 0 == run_command("getkey", 0)){
		power_key_num++;
	}
	if( 0 == run_command("saradc get_in_range 0x95 0x150 1", 0)){
		update_key_num++;
	}

	printf("magic_checkstatus power(%d) adc(%d)\n", power_key_num, update_key_num);

	if(saveEnvFlag){
		if(power_key_num >= 2 && update_key_num >= 2){
			setenv("magic_key_status", "update");
			return;
		}

		if(power_key_num >= 2){
			setenv("magic_key_status", "poweron");
			return;
		}
	}
}


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
#ifdef TEST_UBOOT_BOOT_SPEND_TIME
	unsigned int before_pmu_init =  get_utimer(0);
#endif

#ifdef CONFIG_PLATFORM_HAS_PMU
    board_pmu_init();
#endif
#ifdef TEST_UBOOT_BOOT_SPEND_TIME
	unsigned int after_pmu_init =  get_utimer(0);
	printf("\nPMU init time %d\n", after_pmu_init-before_pmu_init);
#endif
}

int board_init(void)
{
	gd->bd->bi_arch_number=MACH_TYPE_MESON6_SKT;
	gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;
#if CONFIG_JERRY_NAND_TEST //temp test	
    nand_init();
    
#endif    
  run_command("magic_checkstatus", 0);
#ifdef CONFIG_AML_I2C  
	board_i2c_init();
#endif /*CONFIG_AML_I2C*/
#ifdef CONFIG_IR_REMOTE
	board_ir_init();
#endif
#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m6_skt_b,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_h,BOARD_USB_MODE_CHARGER);
#endif /*CONFIG_USB_DWC_OTG_HCD*/
	return 0;
}

#ifdef CONFIG_NAND_AML_M3 //temp test
//#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <linux/mtd/partitions.h>


static struct aml_nand_platform aml_nand_mid_platform[] = {
#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE
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
        .rbpin_mode=1,
        .short_pgsz=384,
        .ran_mode=0,
        .T_REA = 20,
        .T_RHOH = 15,
    },
#endif
    {
        .name = NAND_NORMAL_NAME,
        .chip_enable_pad = (AML_NAND_CE0) | (AML_NAND_CE1 << 4),// | (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12)),
        .ready_busy_pad = (AML_NAND_CE0) | (AML_NAND_CE1 << 4),// | (AML_NAND_CE1 << 8) | (AML_NAND_CE1 << 12)),
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 2,
                .options = (NAND_TIMING_MODE5 | NAND_ECC_BCH60_1K_MODE | NAND_TWO_PLANE_MODE),
            },
        },
        .rbpin_mode = 1,
        .short_pgsz = 0,
        .ran_mode = 0,
        .T_REA = 20,
        .T_RHOH = 15,
    }
    
};

struct aml_nand_device aml_nand_mid_device = {
    .aml_nand_platform = aml_nand_mid_platform,
    .dev_num = ARRAY_SIZE(aml_nand_mid_platform),
};
#endif

static int do_msr(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	const char *cmd;

	/* need at least two arguments */
	if (argc > 2)
		goto usage;

	int nIndex = 0;
	int nCounter = 64;
	
	if( 2 == argc)
	{
		cmd = argv[1];
		char *endp;
		nIndex = simple_strtoul(argv[1], &endp, 10);
		if(nIndex < 0 || nIndex > 63)
			goto usage;
		nCounter = 1;
	}	
	
	extern unsigned long    clk_util_clk_msr(unsigned long clk_mux);

	//printf("\n");
	for(;((nIndex < 64) && nCounter);nCounter--,nIndex++)
		printf("MSR clock[%d] = %dMHz\n",nIndex,clk_util_clk_msr(nIndex));

	return 0;
	
usage:
	return cmd_usage(cmdtp);
}

U_BOOT_CMD(
	msr,	2, 	1,	do_msr,
	"Meson msr sub-system",
	" [0...63] - measure clock frequency\n"
	"          - no clock index will measure all clock"
);

