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


DECLARE_GLOBAL_DATA_PTR;


#if defined(CONFIG_CMD_NET)

/*************************************************
  * Amlogic Ethernet controller operation
  * 
  * Note: The LAN chip LAN8720 need to be reset
  *
  *************************************************/
static void setup_net_chip(void)
{
#ifdef CONFIG_NET_RGMII
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x309);
	/* setup ethernet pinmux */
	//WRITE_CBUS_REG(PERIPHS_PIN_MUX_6, 0x4007ffe0);
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x4007ffe0);
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x211);
#elif defined(CONFIG_NET_RMII_CLK_EXTERNAL)
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x130);
	/* setup ethernet pinmux */
	//WRITE_CBUS_REG(PERIPHS_PIN_MUX_6, 0x8007ffe0);
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x8007ffe0);
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x241);
#else
	/* setup ethernet clk */
	WRITE_CBUS_REG(HHI_ETH_CLK_CNTL, 0x702);
	/* setup ethernet pinmux */
	//WRITE_CBUS_REG(PERIPHS_PIN_MUX_6, 0x4007ffe0);
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x8007ffe0);
	/* setup ethernet mode */
	WRITE_CBUS_REG(PREG_ETHERNET_ADDR0, 0x241);
#endif

	/* setup ethernet interrupt */
	SET_CBUS_REG_MASK(SYS_CPU_0_IRQ_IN0_INTR_MASK, 1 << 8);
	SET_CBUS_REG_MASK(SYS_CPU_0_IRQ_IN1_INTR_STAT, 1 << 8);
	
	/* hardware reset ethernet phy */
	CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO5_EN_N, 1 << 15);
	//CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO5_O, 1 << 15);
	//udelay(2000);
	//SET_CBUS_REG_MASK(PREG_PAD_GPIO5_O, 1 << 15);
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

#ifdef CONFIG_SARADC
#include <asm/saradc.h>
/*following key value are test with board 
  [M6_SKT_V_1.0 20120112]
  ref doc:
  1. M6_SKT_V1.pdf
*/
/* adc_init(&g_adc_info, ARRAY_SIZE(g_adc_info)); */
/*following is test code to test ADC & key pad*/
static int do_adc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	if(argc > 2)
		goto usage;
	
	u32 nDelay = 0xffff;
	int nKeyVal = 0;
	int nCnt = 0;
	char *endp;
	int nMaxCnt;
	if(2 == argc)
		nMaxCnt	= simple_strtoul(argv[1], &endp, 10);
	else
		nMaxCnt = 10;

	saradc_enable();
	while(nCnt < nMaxCnt)
	{
		udelay(nDelay);
		nKeyVal = get_adc_sample(4);
		if(nKeyVal > 1000)
			continue;
		
		printf("SARADC CH-4 Get key : %d [%d]\n", nKeyVal,(100*nKeyVal)/1024);
		nCnt++;
	}
	saradc_disable();

	return 0;
	
usage:
	return cmd_usage(cmdtp);
}

U_BOOT_CMD(
	adc,	2,	1,	do_adc,
	"M6 ADC test",		
	"[times] -  read `times' adc key through channel-4, default to read 10 times\n"
	"		10bit ADC. key value: min=0; max=1024\n"
	"		SKT BOARD #20: Key1=13 Key2=149 key3=274 key4=393 key5=514\n"
);

#endif //CONFIG_SARADC

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
	//setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
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
			clrbits_le32(P_PAD_PULL_UP_REG3, 0x3ff<<0);
			break;
		default:
			break;
	}
    return cpu_sdio_init(port);
}
static int  sdio_detect(unsigned port)
{
	int ret;
	//setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
	//ret=readl(P_PREG_PAD_GPIO5_I)&(1<<29)?0:1;
	//printf( " %s return %d\n",__func__,ret);
	switch(port)
	{
		case SDIO_PORT_A:
			break;
		case SDIO_PORT_B:
			setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
			ret=readl(P_PREG_PAD_GPIO5_I)&(1<<29)?0:1;
			printf( " %s return %d\n",__func__,ret);
			break;
		case SDIO_PORT_C:
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
}
static void sdio_pwr_on(unsigned port)
{
	//clrbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
	//clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
	switch(port)
	{
		case SDIO_PORT_A:
			break;
		case SDIO_PORT_B:
			clrbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
			clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
			break;
		case SDIO_PORT_C:
			break;
		default:
			break;
	}
    /// @todo NOT FINISH
}
static void sdio_pwr_off(unsigned port)
{
	//setbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
	//clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
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
		default:
			break;
	}
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
    
#ifdef CONFIG_TSD
    // if(mmc->block_dev.dev > 0)//tsd
          mmc->block_dev.if_type = IF_TYPE_SD;
#else
    // if(mmc->block_dev.dev > 0)//emmc
          mmc->block_dev.if_type = IF_TYPE_MMC;
#endif

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

#ifdef CONFIG_AML_I2C 
/*I2C module is board depend*/
static void board_i2c_set_pinmux(void){
	/*@M6_SKT_V1.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
    /*********************************************/
    /*                | I2C_Master_B        |I2C_Slave            |       */
    /*********************************************/
    /*                | I2C_SCK                | I2C_SCK_SLAVE  |      */
    /* GPIOX28  | [PIM_MUX5:30]     | [PIM_MUX5:28]   |     */
    /*********************************************/
    /*                | I2C_SDA                 | I2C_SDA_SLAVE  |     */
    /* GPIOX27  | [PIM_MUX5:31]     | [PIM_MUX5:29]   |     */
    /*********************************************/	
	//Wr(PAD_PULL_UP_REG4,Rd(PAD_PULL_UP_REG4) | (1 << 27)| (1 << 28) );

	//disable all other pins which share with I2C_SDA_B & I2C_SCK_B
    clrbits_le32(MESON_I2C_MASTER_B_GPIOX_27_REG,((1<<28)|(1<<29)));
    //enable I2C MASTER B pins
	setbits_le32(MESON_I2C_MASTER_B_GPIOX_27_REG,
	(MESON_I2C_MASTER_B_GPIOX_27_BIT|MESON_I2C_MASTER_B_GPIOX_28_BIT));
	
    udelay(10000);
	
};
struct aml_i2c_platform g_aml_i2c_plat = {
    .wait_count         = 1000000,
    .wait_ack_interval  = 5,
    .wait_read_interval = 5,
    .wait_xfer_interval = 5,
    .master_no          = AML_I2C_MASTER_B,
    .use_pio            = 0,
    .master_i2c_speed   = AML_I2C_SPPED_400K,
    .master_b_pinmux = {
        .scl_reg    = MESON_I2C_MASTER_B_GPIOX_28_REG,
        .scl_bit    = MESON_I2C_MASTER_B_GPIOX_28_BIT,
        .sda_reg    = MESON_I2C_MASTER_B_GPIOX_27_REG,
        .sda_bit    = MESON_I2C_MASTER_B_GPIOX_27_BIT,
    }
};

#define I2C_ALC5631Q_ADDR   (0x1A)

void i2c_ALC5631Q_write(unsigned char reg, unsigned short val)
{
    unsigned char buff[3];
    buff[0] = reg;
    buff[1] = (val >> 8) & 0xFF; //MSB
	buff[2] = (val & 0xFF); //LSB

	struct i2c_msg msg[] = {
        {
        .addr  = I2C_ALC5631Q_ADDR,
        .flags = 0,
        .len   = 3,
        .buf   = buff,
        }
    };

    if (aml_i2c_xfer(msg, 1) < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }
}

unsigned short i2c_ALC5631Q_read(unsigned char reg)
{
    unsigned short val = 0;
    struct i2c_msg msgs[] = {
        {
            .addr = I2C_ALC5631Q_ADDR,
            .flags = 0,
            .len = 1,
            .buf = &reg,
        },
        {
            .addr = I2C_ALC5631Q_ADDR,
            .flags = I2C_M_RD,
            .len = 2,
            .buf = &val,
        },		
    };

    if ( aml_i2c_xfer(msgs, 2)< 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }

	/*@ALC5631Q-VE DataSheet_0.91.pdf Page31*/
    return (val & 0xFF)<< 8 | ((val >> 8) & 0xFF);
}
void board_M6_SKT_V1_i2c_test(void)
{
	/*@M6_SKT_V1.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	/*@ALC5631Q-VE DataSheet_0.91.pdf*/
	int nMaxID = 0x20;
	int nIdx = 0;
	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump begin:\n");
	for(nIdx = 0;nIdx <= nMaxID;nIdx+=2)
		printf("Reg addr=0x%02x Val=0x%04x\n",
		nIdx,i2c_ALC5631Q_read(nIdx));

	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump end.\n\n");

	//try to write some reg
	/*
	i2c_ALC5631Q_write(0x02,0xAA55);
	i2c_ALC5631Q_write(0x04,0x0);

	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump begin:\n");
	for(nIdx = 0;nIdx <= nMaxID;nIdx+=2)
		printf("Reg addr=0x%02x Val=0x%04x\n",
		nIdx,i2c_ALC5631Q_read(nIdx));
	
	printf("[M6_SKT_V1.0]-[I2C-B]-[ALC5631Q] dump end.\n\n");
	*/
		
}

static void board_i2c_init(void)
{		
	//set I2C pinmux with PCB board layout
	/*@M6_SKT_V1.pdf*/
	/*@AL5631Q+3G_AUDIO_V1.pdf*/
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	//must call aml_i2c_init(); before any I2C operation	
	/*M6 socket board*/
	board_M6_SKT_V1_i2c_test();	
	//udelay(10000);	

	udelay(10000);		
}

//for sys_test only, not check yet
static struct i2c_board_info aml_i2c_info[] = {
    {
        I2C_BOARD_INFO("I2C ALC5631Q", 000),
        .device_init = board_i2c_init,
    },
};

struct aml_i2c_device aml_i2c_devices={
	.aml_i2c_boards = aml_i2c_info,
	.dev_num = sizeof(aml_i2c_info)/sizeof(struct i2c_board_info)
};
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
#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE
    {
        .name = NAND_BOOT_NAME,
        .chip_enable_pad = AML_NAND_CE0,
        .ready_busy_pad = AML_NAND_CE0,
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 1,
                .options = (NAND_TIMING_MODE5 | NAND_ECC_BCH30_1K_MODE),
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
        .chip_enable_pad = (AML_NAND_CE0) ,  //| (AML_NAND_CE1 << 4) | (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12)),
        .ready_busy_pad = (AML_NAND_CE0) ,  //| (AML_NAND_CE0 << 4) | (AML_NAND_CE1 << 8) | (AML_NAND_CE1 << 12)),
        .platform_nand_data = {
            .chip =  {
                .nr_chips = 1,
                .options = (NAND_TIMING_MODE5| NAND_ECC_BCH30_1K_MODE),
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
    //.dev_num = 2,
    .dev_num = ARRAY_SIZE(aml_nand_mid_platform),
};
#endif

#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
//@board schematic: m3_skt_v1.pdf
//@pinmax: AppNote-M3-CorePinMux.xlsx
//GPIOA_26 used to set VCCX2_EN: 0 to enable power and 1 to disable power
#if 0
static void gpio_set_vbus_power(char is_power_on)
{
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
}
#endif

static int usb_charging_detect_call_back(char bc_mode)
{
	switch(bc_mode){
		case BC_MODE_DCP:
		case BC_MODE_CDP:
			//Pull up chargging current > 500mA
			break;

		case BC_MODE_UNKNOWN:
		case BC_MODE_SDP:
		default:
			//Limit chargging current <= 500mA
			//Or detet dec-charger
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
	CONFIG_M6_USBPORT_BASE,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_a={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M6_USBPORT_BASE_A,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/

int board_init(void)
{
	gd->bd->bi_arch_number=MACH_TYPE_MESON6_SKT;
	gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;
#if CONFIG_JERRY_NAND_TEST //temp test	
    nand_init();
    
#endif    
    
#ifdef CONFIG_AML_I2C  
	board_i2c_init();
#endif /*CONFIG_AML_I2C*/

#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m6_skt,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_a,BOARD_USB_MODE_CHARGER);
#endif /*CONFIG_USB_DWC_OTG_HCD*/


#ifdef CONFIG_M6_TEST_CPU_SWITCH
	extern int get_cup_id(void);
	printf("\n*************************************\n");
	printf("CPU switch : CPU #%d is running\n",get_cpu_id());
	printf("*************************************\n\n");	
#endif //CONFIG_M6_TEST_CPU_SWITCH
	return 0;
}


