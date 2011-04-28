#include <common.h>
#include <asm/mach-types.h>
#include <asm/arch/memory.h>

#ifdef CONFIG_SARADC
#include <asm/saradc.h>
#endif /*CONFIG_SARADC*/

#ifdef CONFIG_AML_I2C
#include <aml_i2c.h>
#include <asm/arch/io.h>
#endif /*CONFIG_AML_I2C*/


DECLARE_GLOBAL_DATA_PTR;

#ifdef CONFIG_AML_I2C
static void board_i2c_set_pinmux(void)
{
    //refer to WA-AML8726-M3_REF_V1.0.pdf & AppNote-M3-CorePinMux.xlsx
    /*********************************************/
    /*          | AO I2C_Master | AO I2C_Slave |                 */
    /*********************************************/
    /*          | I2C_SCK       | I2C_SCK_SLAVE|*/
    /* GPIOAO_4 | [AO_REG:6]    | [AO_REG:2]   |*/
    /*********************************************/
    /*          | I2C_SDA       | I2C_SDA_SLAVE|*/
    /* GPIOAO_5 | [AO_REG:5]    | [AO_REG:1]   | */
    /*********************************************/
    //disable all other pins which share with I2C_SDA_B & I2C_SCK_B
    clrbits_le32(P_AO_RTI_PIN_MUX_REG,((1<<1)|(1<<2)));
    //enable I2C MASTER B pins
	setbits_le32(P_AO_RTI_PIN_MUX_REG,((1<<5)|(1<<6)));
	
    udelay(10000);
}

#define I2C_ACT8942QJ233_ADDR   (0x5B)

void i2c_act8942_write(unsigned char reg, unsigned char val)
{
    unsigned char buff[2];
    buff[0] = reg;
    buff[1] = val;

	struct i2c_msg msg[] = {
        {
        .addr  = I2C_ACT8942QJ233_ADDR,
        .flags = 0,
        .len   = 2,
        .buf   = buff,
        }
    };

    if (aml_i2c_xfer(msg, 1) < 0) {
        printf("%s: i2c transfer failed\n", __FUNCTION__);
    }
}

unsigned char i2c_act8942_read(unsigned char reg)
{
    unsigned char val = 0;
    struct i2c_msg msgs[] = {
        {
            .addr = I2C_ACT8942QJ233_ADDR,
            .flags = 0,
            .len = 1,
            .buf = &reg,
        },
        {
            .addr = I2C_ACT8942QJ233_ADDR,
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
void board_wa_aml8726_m3_ref_v10_i2c_test(void)
{
	/*@WA-AML8726-M3_REF_V1.0.pdf*/
	/*@DS_ACT8942_PrA_22Jun11_M.pdf*/
	unsigned char act8942_reg_id_lst[] = {
	0x00,0x01,0x20,0x21,0x22,0x30,
	0x31,0x32,0x40,0x41,0x42,0x50,
	0x51,0x54,0x55,0x60,0x61,0x64,
	0x65,0x70,0x71,0x78,0x79,0x7A,
	};
	int nIdx = 0;
	printf("[M3 board]-[WA-AML8726-M3_REF_V1.0]-[AO-I2C]-[ACT8942QJ233-T] dump begin:\n");
	for(nIdx = 0;nIdx < sizeof(act8942_reg_id_lst)/sizeof(act8942_reg_id_lst[0]);++nIdx)
		printf("Reg addr=0x%02x Val=0x%02x\n",
		act8942_reg_id_lst[nIdx],
		i2c_act8942_read(act8942_reg_id_lst[nIdx]));

	printf("[M3 board]-[WA-AML8726-M3_REF_V1.0]-[AO-I2C]-[ACT8942QJ233-T] dump end.\n\n");
}

//Amlogic I2C param setting for board "WA-AML8726-M3_REF_V1.0.pdf"
//will be used by function:  int aml_i2c_init(void) @ drivers\i2c\aml_i2c.c
//refer following doc for detail:
//board schematic: WA-AML8726-M3_REF_V1.0.pdf.pdf
//pinmux setting: AppNote-M3-CorePinMux.xlsx
struct aml_i2c_platform g_aml_i2c_plat = {
    .wait_count         = 1000000,
    .wait_ack_interval  = 5,
    .wait_read_interval = 5,
    .wait_xfer_interval = 5,
    .master_no          = AML_I2C_MASTER_AO,
    .use_pio            = 0,
    .master_i2c_speed   = AML_I2C_SPPED_400K,
    .master_ao_pinmux = {
        .scl_reg  = MESON_I2C_MASTER_AO_GPIOAO_4_REG,
        .scl_bit  = MESON_I2C_MASTER_AO_GPIOAO_4_BIT,
        .sda_reg  = MESON_I2C_MASTER_AO_GPIOAO_5_REG,
        .sda_bit  = MESON_I2C_MASTER_AO_GPIOAO_5_BIT,
    }
};

static void board_i2c_init(void)
{		
	//set I2C pinmux with PCB board layout
	//refer AML8726-M_ARM_DEV_BOARD_2DDR_V1R1.pdf
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	//must call aml_i2c_init(); before any I2C operation	

	/*M3 MID board*/
	//board_wa_aml8726_m3_ref_v10_i2c_test();	
	//udelay(10000);	
	
}
//for sys_test only, not check yet
static struct i2c_board_info aml_i2c_info[] = {
    {
        I2C_BOARD_INFO("I2C PMU(ACT8942)", I2C_ACT8942QJ233_ADDR),
        .device_init = board_i2c_init,
    },
};

struct aml_i2c_device aml_i2c_devices={
	.aml_i2c_boards = aml_i2c_info,
	.dev_num = sizeof(aml_i2c_info)/sizeof(struct i2c_board_info)
};
#endif /*CONFIG_AML_I2C*/

int logo_display(void)
{
    int ret = 0;
    run_command ("nand read ${loadaddr} ${aml_logo_start} ${aml_logo_size}", 0);
    ret = run_command ("bmp display ${loadaddr}", 0);
    run_command ("video dev bl_on", 0);
    return ret;

}

inline void display_messge(char *msg)
{
#ifdef ENABLE_FONT_RESOURCE    
    run_command ("video clear", 0);
    //AsciiPrintf(msg, 250, 200, 0x80ff80);
    AsciiPrintf(msg, 0, 0, 0x00ff00);
    run_command ("video dev bl_on", 0);
#else
	printf("%s\n",msg);
#endif    
}


#if CONFIG_JERRY_NAND_TEST //temp test
#include <amlogic/nand/platform.h>
#include <asm/arch/nand.h>
#include <asm/arch/clock.h>
#include <linux/mtd/partitions.h>
#include <amlogic/debug.h>
static void claim_bus(uint32_t get)
{
	if(get==NAND_BUS_RELEASE)
	{
		NAND_IO_DISABLE(0);
	}else{
		NAND_IO_ENABLE(1);
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
		.clk_src=CLK81,
		.claim_bus=claim_bus
};
void    board_mynand_init(void)
{
	nanddebug(1,"NAND is inited\n");
	nand_plat.clk_src=CLK81;
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
                .options = (NAND_TIMING_MODE5 | NAND_ECC_SHORT_MODE),
            },
        },
        .rbpin_mode=1,
        .short_pgsz=384,
        .ran_mode=0,
        .T_REA = 20,
        .T_RHOH = 15,
    },
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
    .dev_num = 2,
};
#endif


#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
//@board schematic: WA-AML8726-M3_REF_V1.0.pdf
//@pinmax: AppNote-M3-CorePinMux.xlsx
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


//note: try with some M3 pll but only following can work
//USB_PHY_CLOCK_SEL_M3_XTAL @ 1 (24MHz)
//USB_PHY_CLOCK_SEL_M3_XTAL_DIV2 @ 0 (12MHz)
//USB_PHY_CLOCK_SEL_M3_DDR_PLL @ 43 (528MHz)
struct amlogic_usb_config g_usb_config_m3_wa={
	USB_PHY_CLOCK_SEL_M3_XTAL_DIV2,
	0, //PLL divider: (clock/12 -1)
	CONFIG_M3_USBPORT_BASE,
	USB_ID_MODE_SW_HOST,
	gpio_set_vbus_power, //set_vbus_power
};
#endif //CONFIG_USB_DWC_OTG_HCD


int board_init(void)
{
	gd->bd->bi_arch_number=2958; //MACH_TYPE_MESON_8626M;
	gd->bd->bi_boot_params=BOOT_PARAMS_OFFSET;

#ifdef CONFIG_AML_I2C  
	board_i2c_init();
#endif /*CONFIG_AML_I2C*/

#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m3_wa);
#endif /*CONFIG_USB_DWC_OTG_HCD*/
	
	return 0;
}

#ifdef CONFIG_SARADC
/*following key value are test with board 
  [M3_SKT_V1 20110622]
  ref doc:
  1. m3_skt_v1.pdf(2011.06.22)
  2. M3-Periphs-Registers.docx (Pg43-47)
*/
static struct adckey_info g_key_K1_info[] = {
    {"K1", 0, 60},
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
//	board_mmc_register(SDIO_PORT_A);
	board_mmc_register(SDIO_PORT_B);
//	board_mmc_register(SDIO_PORT_C);
//	board_mmc_register(SDIO_PORT_B1);
	return 0;
}
#endif
