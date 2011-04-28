#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>
#include <asm/arch/nand.h>

#if defined(CONFIG_CMD_NET)
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>
#include <asm/arch/pinmux.h>
#endif /*(CONFIG_CMD_NET)*/

#ifdef CONFIG_AML_I2C
#include <aml_i2c.h>
#endif /*CONFIG_AML_I2C*/

#ifdef CONFIG_SARADC
#include <asm/saradc.h>
#endif /*CONFIG_SARADC*/

/*board depend @AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf*/
#ifndef AML_MESON_BOARD_8726M_2010_11_18_V11
  #error "Please define AML_MESON_BOARD_8726M_2010_11_18_V11 before any operation!"
#endif /*AML_MESON_BOARD_8726M_2010_11_18_V11*/
  

DECLARE_GLOBAL_DATA_PTR;

static struct aml_nand_platform aml_nand_mid_platform[] = {
	{
		.name = NAND_BOOT_NAME,
		.chip_enable_pad = AML_NAND_CE0,
		.ready_busy_pad = AML_NAND_CE0,
		.platform_nand_data = {
			.chip =  {
				.nr_chips = 1,
				.options = (NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE),
			},
    	},
		.T_REA = 20,
		.T_RHOH = 15,
	},
	{
		.name = NAND_NORMAL_NAME,
		.chip_enable_pad = (AML_NAND_CE0 | (AML_NAND_CE1 << 4) | (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12)),
		.ready_busy_pad = (AML_NAND_CE0 | (AML_NAND_CE0 << 4) | (AML_NAND_CE1 << 8) | (AML_NAND_CE1 << 12)),
		.platform_nand_data = {
			.chip =  {
				.nr_chips = 4,
				.options = (NAND_TIMING_MODE5 | NAND_ECC_BCH16_MODE | NAND_TWO_PLANE_MODE),
			},
    	},
		.T_REA = 20,
		.T_RHOH = 15,
	}
};

struct aml_nand_device aml_nand_mid_device = {
	.aml_nand_platform = aml_nand_mid_platform,
	.dev_num = ARRAY_SIZE(aml_nand_mid_platform),
};


#ifdef CONFIG_AML_I2C
static void board_i2c_set_pinmux(void)
{
    //refer to AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
    //use GPIOD_12 for TCA6424 RESET
    /******************************************************************************************************************************/
    /*         | OEN(0:OUT,1:IN) | OUT_Level | IN_Level  | Stream In | FEC1:FEC_D_VALID_B | ITU601-IN:ITU601_FIR | WIFI:TX_PLC[0] */
    /******************************************************************************************************************************/
    /*GPIOD_12 | 0x2012:10       | 0x2013:10 | 0x2014:10 | [REG12:31]| [REG5:22]          | [REG5:16]            | [REG8:19]      */
    /******************************************************************************************************************************/
    //disable all other pins which share the GPIOD_12
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_5,((1<<22)|(1<<16))); //FEC1:FEC_D_VALID_B/ITU601-IN:ITU601_FIR
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_8,(1<<19));  //WIFI:TX_PLC[0]
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_12,(1<<31)); //Stream In:ENC_0
    //reset the TCA6424
    CLEAR_CBUS_REG_MASK(PREG_GGPIO_O,1<<10);    //EIO_RST -> 0
    CLEAR_CBUS_REG_MASK(PREG_GGPIO_EN_N,1<<10); //OUTPUT enable	
    udelay(20000);	
    SET_CBUS_REG_MASK(PREG_GGPIO_O,1<<10);      //EIO_RST -> 1	
    udelay(20000);	
    //#define PREG_GGPIO_EN_N   0x2012
    //#define PREG_GGPIO_O         0x2013
    //#define PREG_GGPIO_I           0x2014
    //refer to AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf & M1-Core-Pin-Mux.xls
    /*****************************************************************************************************/
    /*         | SPDIF_IN | SPDIF_OUT | SPI_B      | I2C_MASTER_B | I2C Slave |  UART_B   | REMOTE       */
    /*****************************************************************************************************/
    /*                                | SPI_HOLD_B | I2C_SCK_B    | I2C_SCK_A	|	UART_TX_B	| REMOTE       */
    /* GPIOB_0                        | [REG6:29]  | [REG2:5]     | [REG2:6]  | [REG2:7]  | [REG1:31]    */
    /*****************************************************************************************************/
    /*         | SPDIF_IN | SPDIF_OUT | SPI_W_B    | I2C_SDA_B    | I2C_SDA_A | UART_RX_B |              */
    /* GPIOB_1 | [REG2:0] | [REG2:1]  | [REG6:28]  | [REG2:2]     | [REG2:3]  | [REG2:4]  |              */
    /*****************************************************************************************************/
    //disable all other pins which share with I2C_SDA_B & I2C_SCK_B
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1,(1<<31));   //REMOTE
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_2,(0xFF<<0)); //SPI_IN/SPI_OUT/I2C_SDA_B/I2C_SDA_A/UART_RX_B/I2C_SCK_B/I2C_SCK_A/UART_TX_B
    CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6,(0x3<<28)); //SPI_W_B/SPI_HOLD_B
    //enable I2C MASTER B pins
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2,((1<<2)|(1<<5)));//I2C_SDA_B/I2C_SCK_A
    udelay(10000);
}

#define I2C_TCA6424_ADDR   (0x22)

static void i2c_tca6424_write(unsigned char reg, unsigned char val)
{
    unsigned char buff[2];
    buff[0] = reg;
    buff[1] = val;

	struct i2c_msg msg[] = {
        {
        .addr  = I2C_TCA6424_ADDR,
        .flags = 0,
        .len   = 2,
        .buf   = buff,
        }
    };

    if (aml_i2c_xfer(msg, 1) < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }
}

static unsigned char i2c_tca6424_read(unsigned char reg)
{
    unsigned char val = 0;
    struct i2c_msg msgs[] = {
        {
            .addr = I2C_TCA6424_ADDR,
            .flags = 0,
            .len = 1,
            .buf = &reg,
        },
        {
            .addr = I2C_TCA6424_ADDR,
            .flags = I2C_M_RD,
            .len = 1,
            .buf = &val,
        }
    };

    if ( aml_i2c_xfer(msgs, 2)< 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }

    return val;
}

#define I2C_EIO_PORT0_CFG (0x0C)
#define I2C_EIO_PORT1_CFG (0x0D)
#define I2C_EIO_PORT2_CFG (0x0E)

#define I2C_EIO_PORT0_OUT (0x04)
#define I2C_EIO_PORT1_OUT (0x05)
#define I2C_EIO_PORT2_OUT (0x06)

#define I2C_EIO_PORT0_IN  (0x00)
#define I2C_EIO_PORT1_IN  (0x01)
#define I2C_EIO_PORT2_IN  (0x02)

#ifndef AML_MESON_BOARD_8726M_2010_11_18_V11
//Please refer board schematic for detail pin connection
//@AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
//port27-> Red	 (0x7F)
//port26-> Green (0xBF)
//port25-> Blue    (0xDF)
#define I2C_LED_RED       (0x7F)
#define I2C_LED_GREEN     (0xBF)
#define I2C_LED_BLUE      (0xDF)
#else
//above definition do exist in aml_i2c.h
//for I2C test feature, to light LEDs with TCA6424 port27/26/25
//Note: it is board depend feature
void board_i2c_led_set(unsigned char byLED, unsigned char byOn)
{
	if(I2C_LED_RED != byLED && I2C_LED_GREEN != byLED &&
		I2C_LED_BLUE != byLED)
		return;
	
	unsigned char byVal = i2c_tca6424_read(I2C_EIO_PORT2_OUT);

	byOn ? (byVal &= byLED)  : (byVal |= (~byLED));

	i2c_tca6424_write(I2C_EIO_PORT2_OUT,byVal);//LED: 0-> on, 1->off. 
}
#endif //AML_MESON_BOARD_8726M_2010_11_18_V11

static void board_i2c_init(void)
{		
	//set I2C pinmux with PCB board layout
	//refer AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	//must call aml_i2c_init(); before any I2C operation
	//set mode for port0/1/2: 0-> output, 1->input
	//please care other 
	i2c_tca6424_write(I2C_EIO_PORT0_CFG,0);   //TCA6424 port0: P00~P07 are all output
	i2c_tca6424_write(I2C_EIO_PORT1_CFG,0xF7);//TCA6424 port1: P13 is output for LAN8720 reset, others are input
	i2c_tca6424_write(I2C_EIO_PORT2_CFG,0x1F);//TCA6424 port2: P27~P25 are output(LED), others are input
    //set output level for port0/1/2 (without any effect for the input mode port)    
	i2c_tca6424_write(I2C_EIO_PORT0_OUT,0xFA);//port0 ->0xFA		
	i2c_tca6424_write(I2C_EIO_PORT1_OUT,0xFF);//port1 ->0xFF
	i2c_tca6424_write(I2C_EIO_PORT2_OUT,(I2C_LED_RED & I2C_LED_GREEN & I2C_LED_BLUE));//LED all on

#if 0
    //for I2C read function test
	printf("Hisun: I2C_EIO_PORT0_CFG = 0x%x\n",
		i2c_tca6424_read(I2C_EIO_PORT0_CFG));

	printf("Hisun: I2C_EIO_PORT1_CFG = 0x%x\n",
			i2c_tca6424_read(I2C_EIO_PORT1_CFG));
	
	printf("Hisun: I2C_EIO_PORT2_CFG = 0x%x\n",
		i2c_tca6424_read(I2C_EIO_PORT2_CFG));
	
	printf("Hisun: I2C_EIO_PORT0_OUT = 0x%x\n",
		i2c_tca6424_read(I2C_EIO_PORT0_OUT));
	
	printf("Hisun: I2C_EIO_PORT1_OUT = 0x%x\n",
		i2c_tca6424_read(I2C_EIO_PORT1_OUT));
	
	printf("Hisun: I2C_EIO_PORT2_OUT = 0x%x\n",
		i2c_tca6424_read(I2C_EIO_PORT2_OUT));
#endif 
	udelay(10000);	
	
}

//for sys_test only, not check yet
static struct i2c_board_info aml_i2c_info[] = {
    {
        I2C_BOARD_INFO("externio(TCA6424)", I2C_TCA6424_ADDR),
        .device_init = board_i2c_init,
    },
};

struct aml_i2c_device aml_i2c_devices={
	.aml_i2c_boards = aml_i2c_info,
	.dev_num = sizeof(aml_i2c_info)/sizeof(struct i2c_board_info)
};


//Amlogic I2C param setting for board "Meson board_AML8726-M 2010-11-18_V1.1"
//will be used by function:  int aml_i2c_init(void) @ drivers\i2c\aml_i2c.c
//refer following doc for detail:
//board schematic: AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
//pinmux setting: M1-Core-Pin-Mux.xls
struct aml_i2c_platform g_aml_i2c_plat = {
    .wait_count         = 1000000,
    .wait_ack_interval  = 5,
    .wait_read_interval = 5,
    .wait_xfer_interval = 5,
    .master_no          = AML_I2C_MASTER_B,
    .use_pio            = 0,
    .master_i2c_speed   = AML_I2C_SPPED_100K,
    .master_b_pinmux = {
        .scl_reg  = MESON_I2C_MASTER_B_GPIOB_0_REG,
        .scl_bit  = MESON_I2C_MASTER_B_GPIOB_0_BIT,
        .sda_reg  = MESON_I2C_MASTER_B_GPIOB_1_REG,
        .sda_bit  = MESON_I2C_MASTER_B_GPIOB_1_BIT,
    }
};
#endif /*#ifdef CONFIG_AML_I2C*/

///////////////////////////////////////////////////////////////

#ifdef CONFIG_USB_DWC_OTG_HCD

#include <asm/arch/usb.h>
static void set_usb_a_vbus_power(char is_power_on)
{
    //TCA6424 port0 control USB power:@ AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
    //               Port00 -> VCC5V_EN(0:enable, 1: disable)
    //               Port01 -> USB_PWR_CTL(0:disable, 1: enable)
	unsigned char byPP0 = 0xF9; //off
	
	if(is_power_on)
		byPP0 = 0xFA;
		
	i2c_tca6424_write(I2C_EIO_PORT0_OUT,byPP0);	
}

struct amlogic_usb_config g_usb_config={
	USB_PHY_CLOCK_SEL_XTAL_DIV2,
	0, // no use if clock sel == xtal or xtal/2
	CONFIG_M1_USBPORT_BASE,
	0,
	set_usb_a_vbus_power, //set_vbus_power
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/

#ifdef CONFIG_SARADC
/*following key value are test with board 
  [Meson Board_AML_8726-M 2010-11-18_V1.1]
  ref doc:
  1. AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
  2. M1-Periphs-Registers.docx (Pg49-53)
*/
static struct adckey_info g_key_menu_info[] = {
    {"menu", 0, 60},
};
static struct adckey_info g_key_up_info[] = {
    {"up",   177, 60},
};
static struct adckey_info g_key_down_info[] = {
    {"down", 284, 60},
};
static struct adckey_info g_key_left_info[] = {
    {"left", 399, 60},
};
static struct adckey_info g_key_right_info[] = {
    {"rigth",506, 60},
};
static struct adckey_info g_key_exit_info[] = {
    {"exit", 622, 60},
};
static struct adckey_info g_key_ok_info[] = {
    {"ok",   852, 60},
};

static struct adc_info g_adc_info[] = {
    {"Press Key menu", AML_ADC_CHAN_4, ADC_KEY,&g_key_menu_info},
    {"Press Key up",   AML_ADC_CHAN_4, ADC_KEY,&g_key_up_info},
    {"Press Key down", AML_ADC_CHAN_4, ADC_KEY,&g_key_down_info},
    {"Press Key left", AML_ADC_CHAN_4, ADC_KEY,&g_key_left_info},
    {"Press Key right",AML_ADC_CHAN_4, ADC_KEY,&g_key_right_info},
    {"Press Key exit", AML_ADC_CHAN_4, ADC_KEY,&g_key_exit_info},
    {"Press Key ok",   AML_ADC_CHAN_4, ADC_KEY,&g_key_ok_info},
    {"Press Key N/A",  AML_ADC_CHAN_5, ADC_OTHER, NULL},
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

#endif //CONFIG_SARADC

int board_init(void)
{
    gd->bd->bi_arch_number=MACH_TYPE_MESON_8626M;
    gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;

#ifdef CONFIG_AML_I2C  
	board_i2c_init();
#endif /*#ifdef CONFIG_AML_I2C*/

#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config);
#endif /*CONFIG_USB_DWC_OTG_HCD*/

    return 0;
}


#if defined(CONFIG_CMD_NET)

/********************************************************************************
  * Amlogic Ethernet controller operation
  * 
  * Note: The LAN chip LAN8720 need to be reset by TCA6424 which is one IO expander with I2C I/F
  *           then to use Ethernet must enable I2C feature at first
  *           define macro CONFIG_AML_I2C @ board\amlogic\configs\arm_8726m.h
  ********************************************************************************/
static void setup_net_chip(void)
{
	/*To reset LAN8720 with TCA6424 port13*/
	//TCA6424 P13 SET LOW
#ifdef CONFIG_AML_I2C
	i2c_tca6424_write(I2C_EIO_PORT1_OUT,0xF7); //RMII_nRST port13 output to low
#else
	#error "LAN8720 need TCA6424 reset first! Please define CONFIG_AML_I2C!"
#endif /*#ifdef CONFIG_AML_I2C*/
	
	udelay(100);
	
	//TCA6424 P13 SET HIGH
#ifdef CONFIG_AML_I2C
	i2c_tca6424_write(I2C_EIO_PORT1_OUT,0xFF); //RMII_nRST port13 output to high
#else
	#error "LAN8720 need TCA6424 reset first! Please define CONFIG_AML_I2C!"
#endif /*#ifdef CONFIG_AML_I2C*/

}

int board_eth_init(bd_t *bis)
{        
    eth_clk_set(ETH_CLKSRC_APLL_CLK,400*CLK_1M,50*CLK_1M);
        
    aml_eth_set_pinmux(ETH_BANK2_GPIOD15_D23,ETH_CLK_OUT_GPIOD24_REG5_1,0);
        
    writel(readl(ETH_PLL_CNTL) & ~(1 << 0), ETH_PLL_CNTL); // Disable the Ethernet clocks     
    
    writel(readl(ETH_PLL_CNTL) | (0 << 3), ETH_PLL_CNTL); // desc endianess "same order"   
    writel(readl(ETH_PLL_CNTL) | (0 << 2), ETH_PLL_CNTL); // data endianess "little"    
    writel(readl(ETH_PLL_CNTL) | (1 << 1), ETH_PLL_CNTL); // divide by 2 for 100M     
    writel(readl(ETH_PLL_CNTL) | (1 << 0), ETH_PLL_CNTL);  // enable Ethernet clocks   
    
    udelay(100);

    setup_net_chip();

    udelay(100);
	
extern int aml_eth_init(bd_t *bis);

    aml_eth_init(bis);

	return 0;
}
#endif /* (CONFIG_CMD_NET) */

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
#include <exports.h>
static int  sdio_init(unsigned port)
{
	//setbits_le32(P_PREG_CGPIO_EN_N,1<<5);
	setbits_le32(P_PREG_GGPIO_EN_N,1<<11);//GPIOD13

    return cpu_sdio_init(port);
}
static int  sdio_detect(unsigned port)
{
	//return (readl(P_PREG_CGPIO_I)&(1<<5))?1:0;
	return (readl(P_PREG_GGPIO_I)&(1<<11))?1:0;//GPIOD13
}
static void sdio_pwr_prepare(unsigned port)
{
    /// @todo NOT FINISH
	///do nothing here
}
static void sdio_pwr_on(unsigned port)
{
//	clrbits_le32(P_PREG_CGPIO_O,(1<<5));
//	clrbits_le32(P_PREG_CGPIO_EN_N,(1<<5));//test_n
	clrbits_le32(P_PREG_GGPIO_O,(1<<11));
	clrbits_le32(P_PREG_GGPIO_EN_N,(1<<11));//GPIOD13
    /// @todo NOT FINISH
}
static void sdio_pwr_off(unsigned port)
{
//	setbits_le32(P_PREG_CGPIO_O,(1<<5));
//	clrbits_le32(P_PREG_CGPIO_EN_N,(1<<5));//test_n
	setbits_le32(P_PREG_GGPIO_O,(1<<11));
	clrbits_le32(P_PREG_GGPIO_EN_N,(1<<11));//GPIOD13

	/// @todo NOT FINISH
}
static void board_mmc_register(unsigned port)
{
    struct aml_card_sd_info *aml_priv=cpu_sdio_get(port);
    
    struct mmc *mmc = (struct mmc *)malloc(sizeof(struct mmc));
    if(aml_priv==NULL||mmc==NULL)
        return;
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
	board_mmc_register(SDIO_PORT_A);
//	board_mmc_register(SDIO_PORT_B);
//	board_mmc_register(SDIO_PORT_C);
//	board_mmc_register(SDIO_PORT_B1);
	return 0;
}
#endif
