
/*
 * board/amlogic/gxtvbb_skt_v1/gxtvbb_skt_v1.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <common.h>
#include <malloc.h>
#include <errno.h>
#include <environment.h>
#include <fdt_support.h>
#include <libfdt.h>
#include <asm/cpu_id.h>
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#include <asm/arch/secure_apb.h>
 #include <asm/arch/io.h>
#endif
#ifdef CONFIG_AML_VPU
#include <vpu.h>
#endif
#include <vpp.h>
#ifdef CONFIG_AML_V2_FACTORY_BURN
#include <amlogic/aml_v2_burning.h>
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN
#ifdef CONFIG_AML_HDMITX20
#include <amlogic/hdmi.h>
#endif
#include <asm/arch/eth_setup.h>
#include <phy.h>
#ifdef CONFIG_AML_LCD
#include <amlogic/aml_lcd.h>
#endif
#ifdef CONFIG_AML_LED
#include <asm/arch/mailbox.h>
#include <amlogic/aml_led.h>
#endif
DECLARE_GLOBAL_DATA_PTR;

//new static eth setup
struct eth_board_socket*  eth_board_skt;


int serial_set_pin_port(unsigned long port_base)
{
    //UART in "Always On Module"
    //GPIOAO_0==tx,GPIOAO_1==rx
    //setbits_le32(P_AO_RTI_PIN_MUX_REG,3<<11);
    return 0;
}

int dram_init(void)
{
	gd->ram_size = PHYS_SDRAM_1_SIZE;
	return 0;
}

/* secondary_boot_func
 * this function should be write with asm, here, is is only for compiling pass
 * */
void secondary_boot_func(void)
{
}

#ifdef CONFIG_AML_PMU4
#define AML1220_ADDR    0x35
#define AML1220_ANALOG_ADDR  0x20

unsigned int pmu4_analog_reg[15] = {
	0x00, 0x00, 0x00, 0x00, 0x00,	/* Reg   0x20 - 0x24 */
	0x00, 0x00, 0x00, 0x00, 0x51,	/* Reg  0x25 - 0x29 */
	0x42, 0x00, 0x42, 0x41, 0x02	/* Reg   0x2a - 0x2e */
};

#define PMU4_ANALOG_REG_LEN ARRAY_SIZE(pmu4_analog_reg)

int aml_pmu4_read(int add, uint8_t *val)
{
	int ret;
	uint8_t buf[2] = { };
	struct i2c_msg msg[] = {
		{
		 .addr = AML1220_ADDR,
		 .flags = 0,
		 .len = sizeof(buf),
		 .buf = buf,
		 }
		,
		{
		 .addr = AML1220_ADDR,
		 .flags = I2C_M_RD,
		 .len = 1,
		 .buf = val,
		 }
	};

	buf[0] = add & 0xff;
	buf[1] = (add >> 8) & 0x0f;
	ret = aml_i2c_xfer(msg, 2);
	if (ret < 0) {
		printf("%s: i2c transfer failed, ret:%d\n", __func__, ret);
		return ret;
	}
	return 0;
}

int aml_pmu4_write(int32_t add, uint8_t val)
{
	int ret;
	uint8_t buf[3] = { };
	struct i2c_msg msg[] = {
		{
		 .addr = AML1220_ADDR,
		 .flags = 0,
		 .len = sizeof(buf),
		 .buf = buf,
		 }
	};

	buf[0] = add & 0xff;
	buf[1] = (add >> 8) & 0x0f;
	buf[2] = val & 0xff;
	ret = aml_i2c_xfer(msg, 1);
	if (ret < 0) {
		printf("%s: i2c transfer failed, ret:%d\n", __func__, ret);
		return ret;
	}
	return 0;
}

void pmu4_phy_config(void)
{
#if 0
	int i;
	uint8_t value;
	int data;
	uint8_t data_lo;
	uint8_t data_hi;
#endif
	/* eth ldo */
	aml_pmu4_write(0x04, 0x01);
	aml_pmu4_write(0x05, 0x01);

	mdelay(10);

	/* pinmux */
	aml_pmu4_write(0x2c, 0x51);
	aml_pmu4_write(0x2d, 0x41);
	aml_pmu4_write(0x20, 0x0);
	aml_pmu4_write(0x21, 0x3);
#ifdef EXT_CLK
	aml_pmu4_write(0x14, 0x01);
#else
	aml_pmu4_write(0x14, 0x00);
#endif
	aml_pmu4_write(0x15, 0x3f);

	/* pll */
	aml_pmu4_write(0x78, 0x00);
	aml_pmu4_write(0x79, 0x05);
	aml_pmu4_write(0x7a, 0xa1);
	aml_pmu4_write(0x7b, 0xac);
	aml_pmu4_write(0x7c, 0x5b);
	aml_pmu4_write(0x7d, 0xa0);
	aml_pmu4_write(0x7e, 0x20);
	aml_pmu4_write(0x7f, 0x49);
	aml_pmu4_write(0x80, 0xd6);
	aml_pmu4_write(0x81, 0x0b);
	aml_pmu4_write(0x82, 0xd1);
	aml_pmu4_write(0x83, 0x00);
	/* 24M to 50M */
	aml_pmu4_write(0x84, 0x55);
	aml_pmu4_write(0x85, 0x0d);

	/*cfg4- --- cfg 45 */
	aml_pmu4_write(0x88, 0x0);
	aml_pmu4_write(0x89, 0x0);
	aml_pmu4_write(0x8A, 0x22);
	aml_pmu4_write(0x8B, 0x01);
	aml_pmu4_write(0x8C, 0xd0);
	aml_pmu4_write(0x8D, 0x01);
	aml_pmu4_write(0x8E, 0x00);
	aml_pmu4_write(0x93, 0x81);

	/* pmu4 phyid = 20142014 */
	aml_pmu4_write(0x94, 0x14);
	aml_pmu4_write(0x95, 0x20);

	aml_pmu4_write(0x96, 0x14);
	aml_pmu4_write(0x97, 0x20);

	/*phyadd & mode */
#ifdef EXT_CLK
	aml_pmu4_write(0x98, 0x73);
#else
	aml_pmu4_write(0x98, 0x47);
#endif

	aml_pmu4_write(0x99, 0x61);
	aml_pmu4_write(0x9a, 0x07);
	aml_pmu4_write(0x04, 0x01);
	aml_pmu4_write(0x05, 0x01);
#if 0
	value = 0;
	pr_info("--------> read 0x9c\n");
	while ((value & 0x01) == 0)
		aml_pmu4_read(0x9c, &value);
	pr_info("----2----> read 0x9c over!\n");
#endif
	aml_pmu4_write(0x9b, 0x00);
	aml_pmu4_write(0x9b, 0x80);
	aml_pmu4_write(0x9b, 0x00);
#if 0
	printf("phy init though i2c done\n");
	for (i = 0; i < 0xb0; i++) {
		aml_pmu4_read(i, &value);
		printf("  i2c[%x]=0x%x\n", i, value);
	}
	printf("phy reg dump though i2c:\n");
	for (i = 0; i < 0x20; i++) {
		aml_pmu4_write(0xa6, i);
		aml_pmu4_read(0xa7, &data_lo);
		aml_pmu4_read(0xa8, &data_hi);
		data = (data_hi << 8) | data_lo;
		printf("  phy[%x]=0x%x\n", i, data);
	}
#endif
}

static int aml_pmu4_reg_init(unsigned int reg_base, unsigned int *val,
			      unsigned int reg_len)
{
	int ret = 0;
	unsigned int i = 0;

	for (i = 0; i < reg_len; i++) {
		ret = aml_pmu4_write(reg_base + i, val[i]);
		if (ret < 0)
			return ret;
	}

	return 0;
}

static int aml_pmu4_power_init(void)
{
	int ret;
	int i = 0;
	uint8_t value;

	/* pmu4 analog register init */
	ret = aml_pmu4_reg_init(AML1220_ANALOG_ADDR, &pmu4_analog_reg[0],
			  PMU4_ANALOG_REG_LEN);
	if (ret < 0)
		return ret;

	pmu4_phy_config();

	/* enable input 24M clock */
	setbits_le32(0xc8100634, 0x93);

	do {
		aml_pmu4_read(0x9c, &value);
		mdelay(10);
	} while (((value & 0x01) == 0) && (i++ < 10));
	if(!(value&0x01)) {
		printf("WARING: PMU4 PLL not lock!");
	}

	return 0;

}

void setup_pmu4(void)
{
	aml_pmu4_power_init();
}
#endif
static void setup_net_chip(void)
{
	eth_aml_reg0_t eth_reg0;

	//setup ethernet clk need calibrate to configre
	setbits_le32(P_PERIPHS_PIN_MUX_8, 0x1fffc000);

	eth_reg0.d32 = 0;
	eth_reg0.b.phy_intf_sel = 0;
	eth_reg0.b.data_endian = 0;
	eth_reg0.b.desc_endian = 0;
	eth_reg0.b.rx_clk_rmii_invert = 0;
	eth_reg0.b.rgmii_tx_clk_src = 0;
	eth_reg0.b.rgmii_tx_clk_phase = 0;
	eth_reg0.b.rgmii_tx_clk_ratio = 0;
	eth_reg0.b.phy_ref_clk_enable = 0;
	eth_reg0.b.clk_rmii_i_invert = 1;
	eth_reg0.b.clk_en = 1;
	eth_reg0.b.adj_enable = 0;
	eth_reg0.b.adj_setup = 0;
	eth_reg0.b.adj_delay = 0;
	eth_reg0.b.adj_skew = 0;
	eth_reg0.b.cali_start = 0;
	eth_reg0.b.cali_rise = 0;
	eth_reg0.b.cali_sel = 0;
	eth_reg0.b.rgmii_rx_reuse = 0;
	eth_reg0.b.eth_urgent = 0;
	setbits_le32(P_PREG_ETH_REG0, eth_reg0.d32);// rmii mode

	setbits_le32(HHI_GCLK_MPEG1,1<<3);

	/* power on memory */
	clrbits_le32(HHI_MEM_PD_REG0, (1 << 3) | (1<<2));

#ifndef CONFIG_AML_PMU4
	/* hardware reset ethernet phy : gpioz14 connect phyreset pin*/
	clrbits_le32(PREG_PAD_GPIO3_EN_N, 1 << 14);
	clrbits_le32(PREG_PAD_GPIO3_O, 1 << 14);
	udelay(100000);
	setbits_le32(PREG_PAD_GPIO3_O, 1 << 14);
#endif
}

extern int designware_initialize(ulong base_addr, u32 interface);
int board_eth_init(bd_t *bis)
{
#ifdef CONFIG_AML_PMU4
	setup_pmu4();
#endif
	setup_net_chip();
	udelay(1000);
	designware_initialize(ETH_BASE, PHY_INTERFACE_MODE_RMII);
	return 0;
}

#if CONFIG_AML_SD_EMMC
#include <mmc.h>
#include <asm/arch/sd_emmc.h>
static int  sd_emmc_init(unsigned port)
{
    switch (port)
	{
		case SDIO_PORT_A:
			break;
		case SDIO_PORT_B:
			//todo add card detect
			//setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
			break;
		case SDIO_PORT_C:
			//enable pull up
			//clrbits_le32(P_PAD_PULL_UP_REG3, 0xff<<0);
			break;
		default:
			break;
	}

	return cpu_sd_emmc_init(port);
}

extern unsigned sd_debug_board_1bit_flag;
static int  sd_emmc_detect(unsigned port)
{
	int ret;
    switch (port) {

	case SDIO_PORT_A:
		break;
	case SDIO_PORT_B:
			setbits_le32(P_PREG_PAD_GPIO5_EN_N,1<<29);//CARD_6
			ret=readl(P_PREG_PAD_GPIO5_I)&(1<<29)?0:1;
			printf("ret = %d .",ret);
			if ((readl(P_PERIPHS_PIN_MUX_8)&(3<<9))) { //if uart pinmux set, debug board in
				if (!(readl(P_PREG_PAD_GPIO2_I)&(1<<24))) {
					printf("sdio debug board detected, sd card with 1bit mode\n");
					sd_debug_board_1bit_flag = 1;
				}
				else{
					printf("sdio debug board detected, no sd card in\n");
					sd_debug_board_1bit_flag = 0;
					return 1;
				}
			}

		break;
	default:
		break;
	}
	return 0;
}

static void sd_emmc_pwr_prepare(unsigned port)
{
	cpu_sd_emmc_pwr_prepare(port);
}

static void sd_emmc_pwr_on(unsigned port)
{
    switch (port)
	{
		case SDIO_PORT_A:
			break;
		case SDIO_PORT_B:
//            clrbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
//            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
			/// @todo NOT FINISH
			break;
		case SDIO_PORT_C:
			break;
		default:
			break;
	}
	return;
}
static void sd_emmc_pwr_off(unsigned port)
{
	/// @todo NOT FINISH
    switch (port)
	{
		case SDIO_PORT_A:
			break;
		case SDIO_PORT_B:
//            setbits_le32(P_PREG_PAD_GPIO5_O,(1<<31)); //CARD_8
//            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,(1<<31));
			break;
		case SDIO_PORT_C:
			break;
				default:
			break;
	}
	return;
}

// #define CONFIG_TSD      1
static void board_mmc_register(unsigned port)
{
	struct aml_card_sd_info *aml_priv=cpu_sd_emmc_get(port);
    if (aml_priv == NULL)
		return;

	aml_priv->sd_emmc_init=sd_emmc_init;
	aml_priv->sd_emmc_detect=sd_emmc_detect;
	aml_priv->sd_emmc_pwr_off=sd_emmc_pwr_off;
	aml_priv->sd_emmc_pwr_on=sd_emmc_pwr_on;
	aml_priv->sd_emmc_pwr_prepare=sd_emmc_pwr_prepare;
	aml_priv->desc_buf = malloc(NEWSD_MAX_DESC_MUN*(sizeof(struct sd_emmc_desc_info)));

	if (NULL == aml_priv->desc_buf)
		printf(" desc_buf Dma alloc Fail!\n");
	else
		printf("aml_priv->desc_buf = 0x%p\n",aml_priv->desc_buf);

	sd_emmc_register(aml_priv);
}
int board_mmc_init(bd_t	*bis)
{
#ifdef CONFIG_VLSI_EMULATOR
	//board_mmc_register(SDIO_PORT_A);
#else
	//board_mmc_register(SDIO_PORT_B);
#endif
	board_mmc_register(SDIO_PORT_B);
	board_mmc_register(SDIO_PORT_C);
//	board_mmc_register(SDIO_PORT_B1);
	return 0;
}

#ifdef CONFIG_SYS_I2C_AML
#if 1
static void board_i2c_set_pinmux(void){
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
	clrbits_le32(PERIPHS_PIN_MUX_7, (1<<19)|(1<<20));
	//enable I2C MASTER AO pins
	setbits_le32(PERIPHS_PIN_MUX_7,
	((MESON_I2C_MASTER_B_GPIOH_3_BIT) | (MESON_I2C_MASTER_B_GPIOH_4_BIT)));

	udelay(10);
};
#endif
struct aml_i2c_platform g_aml_i2c_plat = {
	.wait_count         = 1000000,
	.wait_ack_interval  = 5,
	.wait_read_interval = 5,
	.wait_xfer_interval = 5,
	.master_no          = AML_I2C_MASTER_B,
	.use_pio            = 0,
	.master_i2c_speed   = AML_I2C_SPPED_400K,
	.master_b_pinmux = {
		.scl_reg    = (unsigned long)MESON_I2C_MASTER_B_GPIOH_4_REG,
		.scl_bit    = MESON_I2C_MASTER_B_GPIOH_4_BIT,
		.sda_reg    = (unsigned long)MESON_I2C_MASTER_B_GPIOH_3_REG,
		.sda_bit    = MESON_I2C_MASTER_B_GPIOH_3_BIT,
	}
};
#if 1
static void board_i2c_init(void)
{
	//set I2C pinmux with PCB board layout
	board_i2c_set_pinmux();

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	udelay(10);
}
#endif
#endif
#endif

#if defined(CONFIG_BOARD_EARLY_INIT_F)
int board_early_init_f(void){
	/*add board early init function here*/
	return 0;
}
#endif

#ifdef CONFIG_USB_XHCI_AMLOGIC
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>
struct amlogic_usb_config g_usb_config_GXTVBB_skt={
	CONFIG_GXTVBB_XHCI_BASE,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	CONFIG_GXTVBB_USB_PHY2_BASE,
	CONFIG_GXTVBB_USB_PHY3_BASE,
};
#endif /*CONFIG_USB_XHCI_AMLOGIC*/

#ifdef CONFIG_AML_HDMITX20
static void hdmi_tx_set_hdmi_5v(void)
{
}
#endif

#ifdef CONFIG_AML_LED
static enum led_workmode lwm_get_workmode(char *str)
{
	if (!str)
		return LWM_NULL;
	else if (!strncmp(str, "off", 3))
		return LWM_OFF;
	else if (!strncmp(str, "on", 2))
		return LWM_ON;
	else if (!strncmp(str, "flash", 5))
		return LWM_FLASH;
	else if (!strncmp(str, "breath", 6))
		return LWM_BREATH;
	else
		return LWM_NULL;
}

/* options example:
 * ledmode=standby:on,booting:flash,working:breath
 */
static unsigned int lwm_parse_workmode(char *options)
{
	char *option;
	enum led_workmode mode;
	unsigned int ledmode = 0;

	while ((option = strsep(&options, ",")) != NULL) {
		if (!strncmp(option, "standby:", 8)) {
			option += 8;
			mode = lwm_get_workmode(option);
			lwm_set_standby(ledmode, mode);
		}

		if (!strncmp(option, "booting:", 8)) {
			option += 8;
			mode = lwm_get_workmode(option);
			lwm_set_booting(ledmode, mode);
		}

		if (!strncmp(option, "working:", 8)) {
			option += 8;
			mode = lwm_get_workmode(option);
			lwm_set_working(ledmode, mode);
		}
	}

	return ledmode;
}

/*Need add build config here.*/
static int send_led_timer_data(void)
{
	struct led_timer_strc{
		unsigned int expires;
		unsigned int expires_count;
		unsigned int led_mode;
	} led_val;
	char *env, env_buf[64];

	env = getenv("jtag");
	if (strcmp(env, "disable")) {
		printf("mux to jtag %s, led unavailable\n", env);
		return -1;
	}
	env = getenv("ledmode");
	if (!env)
		return -1;
	strcpy(env_buf, env);
	env = env_buf;
	printf("ledmode=%s\n", env);
	led_val.led_mode = lwm_parse_workmode(env);
	lwm_set_suspend(led_val.led_mode, SHUTDOWN_MODE);
	printf("ledmode=0x%x\n", led_val.led_mode);
	led_val.expires = 350*1000;
	if (lwm_get_booting(led_val.led_mode) == LWM_ON)
		led_val.expires_count = 8; //off-on-off-on-off-on-off-on...
	else
		led_val.expires_count = 7; //off-on-off-on-off-on-off...

	if (send_usr_data(SCPI_CL_LED_TIMER,(unsigned int *)&led_val,sizeof(led_val))) {
		printf("send_led_timer_data send error!...\n");
		return 0;
	}
	return 0;
}
#endif

/*USE_HDMI_UART_FUNC*/
#define HDMI_UART_PORT_NUM   3

struct hdmi_uart_date_io {
	char *power;
	char *scl;
	volatile uint32_t * hdmi_sda_reg;
	unsigned int hdmi_sda_bit;
	volatile uint32_t * uart_tx_reg;
	unsigned int uart_tx_bit;
	volatile uint32_t * hdmi_scl_reg;
	unsigned int hdmi_scl_bit;
	volatile uint32_t * uart_rx_reg;
	unsigned int uart_rx_bit;
};

struct hdmi_uart_date_io txl_hdmi_uart_date_io[HDMI_UART_PORT_NUM+1]=
{
	{"GPIOW_5" ,"GPIOW_7" ,P_PERIPHS_PIN_MUX_5,25,P_PERIPHS_PIN_MUX_5,13,P_PERIPHS_PIN_MUX_5 ,24 ,P_PERIPHS_PIN_MUX_5,12,},
	{"GPIOW_9", "GPIOW_11",P_PERIPHS_PIN_MUX_5,21,P_PERIPHS_PIN_MUX_5,11,P_PERIPHS_PIN_MUX_5 ,20 ,P_PERIPHS_PIN_MUX_5,10,},
	{"GPIOW_13","GPIOW_15",P_PERIPHS_PIN_MUX_5,17,P_PERIPHS_PIN_MUX_5,9, P_PERIPHS_PIN_MUX_5 ,16 ,P_PERIPHS_PIN_MUX_5,8,},
	{NULL,      NULL,      0,                   0,P_AO_RTI_PIN_MUX_REG,12,0 ,                   0 ,P_AO_RTI_PIN_MUX_REG,11,},
};

struct hdmi_uart_date_io gxtvbb_hdmi_uart_date_io[HDMI_UART_PORT_NUM+1]=
{
	{"GPIOW_6" ,"GPIOW_5" ,P_PERIPHS_PIN_MUX_6 ,9  ,P_PERIPHS_PIN_MUX_10,1,P_PERIPHS_PIN_MUX_6 ,10 ,P_PERIPHS_PIN_MUX_6,11,},
	{"GPIOW_10","GPIOW_9" ,P_PERIPHS_PIN_MUX_6 ,14 ,P_PERIPHS_PIN_MUX_10,2,P_PERIPHS_PIN_MUX_6 ,15 ,P_PERIPHS_PIN_MUX_6,16,},
	{"GPIOW_14","GPIOW_13",P_PERIPHS_PIN_MUX_6 ,19 ,P_PERIPHS_PIN_MUX_10,3,P_PERIPHS_PIN_MUX_6 ,20 ,P_PERIPHS_PIN_MUX_6,21,},
	{NULL,      NULL,      0,                   0  ,P_AO_RTI_PIN_MUX_REG,0,0 ,                   0 ,P_AO_RTI_PIN_MUX_REG,1,},
};

struct hdmi_uart_det_io {
	char *power;
	char *scl;
	volatile uint32_t * uart_det_power_reg;
	unsigned int uart_det_power_bit;
	unsigned int uart_det_power_need_level;
	volatile uint32_t * uart_det_scl_reg;
	unsigned int uart_det_scl_bit;
	unsigned int uart_det_scl_need_level;
};

struct hdmi_uart_det_io txl_hdmi_uart_det_io[HDMI_UART_PORT_NUM]=
{
	{"GPIOW_5" , "GPIOW_7" ,  P_PREG_PAD_GPIO4_I , 5 , 0, P_PREG_PAD_GPIO4_I ,7 , 1,},
	{"GPIOW_9",  "GPIOW_11",  P_PREG_PAD_GPIO4_I , 9 , 0, P_PREG_PAD_GPIO4_I ,11, 1,},
	{"GPIOW_13", "GPIOW_15" , P_PREG_PAD_GPIO4_I , 13, 0, P_PREG_PAD_GPIO4_I ,15, 1,},
};

/* in gxtvbb,use hpd port as (txl)scl port */
struct hdmi_uart_det_io gxtvbb_hdmi_uart_det_io[HDMI_UART_PORT_NUM]=
{
	{"GPIOW_6" ,"GPIOW_5" , P_PREG_PAD_GPIO0_I, 6 , 0, P_PREG_PAD_GPIO0_I ,5 , 1,},
	{"GPIOW_10","GPIOW_9" , P_PREG_PAD_GPIO0_I, 10, 0, P_PREG_PAD_GPIO0_I ,9 , 1,},
	{"GPIOW_14","GPIOW_13", P_PREG_PAD_GPIO0_I, 14, 0, P_PREG_PAD_GPIO0_I ,13, 1,},
};

static void init_hdmi_uart_board(void)
{
	int i=0;
	int pwr_value=0,scl_value=0;
	int flag=0;
	struct hdmi_uart_date_io *hdmi_uart_date_io;
	struct hdmi_uart_det_io  *hdmi_uart_det_io;

	if (get_cpu_id().family_id <= MESON_CPU_MAJOR_ID_GXTVBB) {
		hdmi_uart_det_io  = gxtvbb_hdmi_uart_det_io;
		hdmi_uart_date_io = gxtvbb_hdmi_uart_date_io;
		/*printf("choose gxtvbb board.\n");*/
	} else {
		hdmi_uart_det_io  = txl_hdmi_uart_det_io;
		hdmi_uart_date_io = txl_hdmi_uart_date_io;
		/*printf("choose txl board.\n");*/
	}

	for (i=0; i<HDMI_UART_PORT_NUM; i++) {
		pwr_value = readl(hdmi_uart_det_io[i].uart_det_power_reg) >> hdmi_uart_det_io[i].uart_det_power_bit;
		pwr_value &= 1;
		scl_value = readl(hdmi_uart_det_io[i].uart_det_scl_reg) >> hdmi_uart_det_io[i].uart_det_scl_bit;
		scl_value &= 1;

		if ((pwr_value == hdmi_uart_det_io[i].uart_det_power_need_level)
			&& (scl_value == hdmi_uart_det_io[i].uart_det_scl_need_level)) {
			flag = 1;
			break;
		}
	}

	if (flag == 1) {
		printf("switch to %d hdmirx_uart port\n",i);
		/* clean default uart pinmux */
		writel(readl(hdmi_uart_date_io[3].uart_tx_reg)&~(1 << hdmi_uart_date_io[3].uart_tx_bit),
			(volatile void *)hdmi_uart_date_io[3].uart_tx_reg);
		writel(readl(hdmi_uart_date_io[3].uart_rx_reg)&~(1 << hdmi_uart_date_io[3].uart_rx_bit),
			(volatile void *)hdmi_uart_date_io[3].uart_rx_reg);

		/* set hdmi_uart pinmux */
		writel(readl(hdmi_uart_date_io[i].hdmi_sda_reg)&~(1 << hdmi_uart_date_io[i].hdmi_sda_bit),
			(volatile void *)hdmi_uart_date_io[i].hdmi_sda_reg);
		writel(readl(hdmi_uart_date_io[i].uart_tx_reg)|(1 << hdmi_uart_date_io[i].uart_tx_bit),
			(volatile void *)hdmi_uart_date_io[i].uart_tx_reg);

		writel(readl(hdmi_uart_date_io[i].hdmi_scl_reg)&~(1 << hdmi_uart_date_io[i].hdmi_scl_bit),
			(volatile void *)hdmi_uart_date_io[i].hdmi_scl_reg);
		writel(readl(hdmi_uart_date_io[i].uart_rx_reg)|(1 << hdmi_uart_date_io[i].uart_rx_bit),
			(volatile void *)hdmi_uart_date_io[i].uart_rx_reg);
	}
}
/*endif*/

int board_init(void)
{
#ifdef CONFIG_AML_V2_FACTORY_BURN
	aml_try_factory_usb_burning(0, gd->bd);
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN

#ifdef CONFIG_USB_XHCI_AMLOGIC
	board_usb_init(&g_usb_config_GXTVBB_skt,BOARD_USB_MODE_HOST);
#endif /*CONFIG_USB_XHCI_AMLOGIC*/

#ifdef CONFIG_SYS_I2C_AML
// #ifdef 1
	board_i2c_init();
// #endif /*CONFIG_AML_I2C*/
#endif

	//temp  for p301, usb 5V power
	//run_command("mw 0xc8100024 BFFF3FDF", 0);
	run_command("gpio s GPIOAO_5", 0);

	return 0;
}

#ifdef CONFIG_BOARD_LATE_INIT
int board_late_init(void)
{
	int ret;
	char* env;

	/*USE_HDMI_UART_FUNC*/
	env = getenv("hdmiuart_mode");
	/*printf("hdmiuart_mode env:%s\n",env);*/
	if (env) {
		if (!strcmp(env,"open")) {
		printf("CONFIG_HDMI_UART_BOARD\n");
		init_hdmi_uart_board();
		}
	}
	/*endif*/

	//update env before anyone using it
	run_command("get_rebootmode; echo reboot_mode=${reboot_mode}; "\
			"if test ${reboot_mode} = factory_reset; then "\
			"defenv_reserv aml_dt;setenv upgrade_step 2;save; fi;", 0);
	run_command("if itest ${upgrade_step} == 1; then "\
				"defenv_reserv; setenv upgrade_step 2; saveenv; fi;", 0);

	/*add board late init function here*/
	ret = run_command("store dtb read $dtb_mem_addr", 1);
	if (ret) {
		printf("%s(): [store dtb read $dtb_mem_addr] fail\n", __func__);
		#ifdef CONFIG_DTB_MEM_ADDR
		char cmd[64];
		printf("load dtb to %x\n", CONFIG_DTB_MEM_ADDR);
		sprintf(cmd, "store dtb read %x", CONFIG_DTB_MEM_ADDR);
		ret = run_command(cmd, 1);
		if (ret) {
			printf("%s(): %s fail\n", __func__, cmd);
		}
		#endif
	}

	/* load unifykey */
	run_command("keyunify init 0x1234", 0);
#ifdef CONFIG_AML_VPU
	vpu_probe();
#endif
#ifdef CONFIG_AML_HDMITX20
	hdmi_tx_set_hdmi_5v();
	hdmi_tx_init();
#endif
#ifdef CONFIG_AML_LCD
	lcd_probe();
#endif
	vpp_init();

#ifdef CONFIG_AML_V2_FACTORY_BURN
	aml_try_factory_sdcard_burning(0, gd->bd);
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN
#ifdef CONFIG_AML_LED
	send_led_timer_data();
#endif
	return 0;
}
#endif

#ifdef CONFIG_AML_TINY_USBTOOL
int usb_get_update_result(void)
{
	unsigned long upgrade_step;
	upgrade_step = simple_strtoul (getenv ("upgrade_step"), NULL, 16);
	printf("upgrade_step = %d\n", (int)upgrade_step);
	if (upgrade_step == 1)
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

phys_size_t get_effective_memsize(void)
{
	// >>16 -> MB, <<20 -> real size, so >>16<<20 = <<4
#if defined(CONFIG_SYS_MEM_TOP_HIDE)
	return (((readl(AO_SEC_GP_CFG0)) & 0xFFFF0000) << 4) - CONFIG_SYS_MEM_TOP_HIDE;
#else
	return (((readl(AO_SEC_GP_CFG0)) & 0xFFFF0000) << 4);
#endif
}

#ifdef CONFIG_MULTI_DTB
int checkhw(char * name)
{
	unsigned int boardid = 0;
	char loc_name[64] = {0};
	boardid = (readl(AO_SEC_GP_CFG0)>>8)&0xff;
	printf("%s: boardid = 0x%x\n", __func__,boardid);

	switch (boardid) {
		case 0:
			strcpy(loc_name, "gxtvbb_p301_1g\0");
			break;
		case 8:
			strcpy(loc_name, "gxtvbb_p300_2g\0");
			break;
		case 12:
			strcpy(loc_name, "gxtvbb_skt_2g\0");
			break;
		default:
			printf("boardid: 0x%x, multi-dt doesn't support\n", boardid);
			//strcpy(loc_name, "gxb_p200_unsupport");
			break;
	}
	strcpy(name, loc_name);
	setenv("aml_dt", loc_name);
	return 0;
}
#endif

const char * const _env_args_reserve_[] =
{
	"aml_dt",
	"firstboot",

	NULL//Keep NULL be last to tell END
};

