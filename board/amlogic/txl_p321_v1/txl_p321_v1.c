
/*
 * board/amlogic/txl_skt_v1/txl_skt_v1.c
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
#ifdef CONFIG_AML_LCD
#include <amlogic/aml_lcd.h>
#endif
#include <asm/arch/eth_setup.h>
#include <phy.h>
#include <asm-generic/gpio.h>

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
void internalPhyConfig(struct phy_device *phydev)
{
	/*Enable Analog and DSP register Bank access by*/
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x0000);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x0400);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x0000);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x0400);
	/*Write Analog register 23*/
	phy_write(phydev, MDIO_DEVAD_NONE, 0x17, 0x8E0D);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x4417);
	/*Enable fractional PLL*/
	phy_write(phydev, MDIO_DEVAD_NONE, 0x17, 0x0005);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x5C1B);
	//Programme fraction FR_PLL_DIV1
	phy_write(phydev, MDIO_DEVAD_NONE, 0x17, 0x029A);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x5C1D);
	//## programme fraction FR_PLL_DiV1
	phy_write(phydev, MDIO_DEVAD_NONE, 0x17, 0xAAAA);
	phy_write(phydev, MDIO_DEVAD_NONE, 0x14, 0x5C1C);
}


static void setup_net_chip(void)
{
	eth_aml_reg0_t eth_reg0;

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
	*P_PREG_ETH_REG2 = 0x10110181;
	*P_PREG_ETH_REG3 = 0xe409087f;
	setbits_le32(HHI_GCLK_MPEG1,1<<3);
	/* power on memory */
	clrbits_le32(HHI_MEM_PD_REG0, (1 << 3) | (1<<2));

}

extern struct eth_board_socket* eth_board_setup(char *name);
extern int designware_initialize(ulong base_addr, u32 interface);
#define P_RESET1_LEVEL (volatile unsigned int *)((0x21<< 2) + 0xc1104400)

int board_eth_init(bd_t *bis)
{
	*P_RESET1_LEVEL |= (1<<11);
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
			setbits_le32(P_PREG_PAD_GPIO2_EN_N, 1 << 26);//CARD_6
			ret = readl(P_PREG_PAD_GPIO2_I) & (1 << 26) ? 0 : 1;
			printf("%s\n", ret ? "card in" : "card out");
			if ((readl(P_PERIPHS_PIN_MUX_6) & (3 << 8))) { //if uart pinmux set, debug board in
				if (!(readl(P_PREG_PAD_GPIO2_I) & (1 << 24))) {
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
#if 0
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
	clrbits_le32(P_AO_RTI_PIN_MUX_REG, ((1<<2)|(1<<24)|(1<<1)|(1<<23)));
	//enable I2C MASTER AO pins
	setbits_le32(P_AO_RTI_PIN_MUX_REG,
	(MESON_I2C_MASTER_AO_GPIOAO_4_BIT | MESON_I2C_MASTER_AO_GPIOAO_5_BIT));

	udelay(10);
};
#endif
struct aml_i2c_platform g_aml_i2c_plat = {
	.wait_count         = 1000000,
	.wait_ack_interval  = 5,
	.wait_read_interval = 5,
	.wait_xfer_interval = 5,
	.master_no          = AML_I2C_MASTER_AO,
	.use_pio            = 0,
	.master_i2c_speed   = AML_I2C_SPPED_400K,
	.master_ao_pinmux = {
		.scl_reg    = (unsigned long)MESON_I2C_MASTER_AO_GPIOAO_4_REG,
		.scl_bit    = MESON_I2C_MASTER_AO_GPIOAO_4_BIT,
		.sda_reg    = (unsigned long)MESON_I2C_MASTER_AO_GPIOAO_5_REG,
		.sda_bit    = MESON_I2C_MASTER_AO_GPIOAO_5_BIT,
	}
};
#if 0
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

#ifdef CONFIG_USB_XHCI_AMLOGIC_GXL
#include <asm/arch/usb-new.h>
#include <asm/arch/gpio.h>
#define CONFIG_GXL_USB_U2_PORT_NUM	4
#define CONFIG_GXL_USB_U3_PORT_NUM	0

struct amlogic_usb_config g_usb_config_GXL_skt={
	CONFIG_GXL_XHCI_BASE,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	CONFIG_GXL_USB_PHY2_BASE,
	CONFIG_GXL_USB_PHY3_BASE,
	CONFIG_GXL_USB_U2_PORT_NUM,
	CONFIG_GXL_USB_U3_PORT_NUM,
};
#endif /*CONFIG_USB_XHCI_AMLOGIC*/

#ifdef CONFIG_AML_HDMITX20
static void hdmi_tx_set_hdmi_5v(void)
{
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
	if ((0x1b8ec003 != readl(P_PREG_STICKY_REG2)) && (0x1b8ec004 != readl(P_PREG_STICKY_REG2))) {
		aml_try_factory_usb_burning(0, gd->bd);
	}
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN

#ifdef CONFIG_USB_XHCI_AMLOGIC_GXL
	board_usb_init(&g_usb_config_GXL_skt,BOARD_USB_MODE_HOST);
#endif /*CONFIG_USB_XHCI_AMLOGIC*/

#ifdef CONFIG_AML_NAND
	extern int amlnf_init(unsigned char flag);
	amlnf_init(0);
#endif
	return 0;
}

#ifdef CONFIG_BOARD_LATE_INIT
int board_late_init(void)
{
	int ret;
	char* env;
	unsigned int hwid = 1;

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
			"defenv_reserv;save; fi;", 0);
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
	vpp_init();

	run_command("ini_model", 0);
#ifdef CONFIG_AML_HDMITX20
	hdmi_tx_set_hdmi_5v();
	hdmi_tx_init();
#endif
#ifdef CONFIG_AML_LCD
	lcd_probe();
#endif

#ifdef CONFIG_AML_V2_FACTORY_BURN
	if (0x1b8ec003 == readl(P_PREG_STICKY_REG2))
		aml_try_factory_usb_burning(1, gd->bd);
	/*aml_try_factory_sdcard_burning(0, gd->bd);*/
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN

	//CLEAR PINMUX
	clrbits_le32(P_AO_RTI_PIN_MUX_REG,(1<<23)|(1<<5)|(1<<1));//AO_5
	clrbits_le32(P_PERIPHS_PIN_MUX_2, (1<<13)|(1<<5)|(1<<28));//DV_9
	//SET GPIOAO_5 OUTPUT 1
	clrbits_le32(P_AO_GPIO_O_EN_N, 1 << 5);
	setbits_le32(P_AO_GPIO_O_EN_N, 1 << 21);
	//SET GPIODV_9 OUTPUT 1
	clrbits_le32(P_PREG_PAD_GPIO0_EN_N, 1 << 9);
	setbits_le32(P_PREG_PAD_GPIO0_O, 1 << 9);

	/* enable 5V for USB, panel, wifi */
	hwid = (readl(P_AO_SEC_GP_CFG0) >> 8) & 0xFF;
	switch (hwid) {
		case 1:
			run_command("gpio set GPIOAO_4", 0);
			break;
		case 2:
			/* set output mode for GPIOAO_10 */
			clrbits_le32(P_AO_GPIO_O_EN_N, (1<<10));
			/* set output level to high for GPIOAO_10 */
			setbits_le32(P_AO_GPIO_O_EN_N, (1<<26));
			break;
		default:
			/* set output mode for GPIOAO_10 */
			clrbits_le32(P_AO_GPIO_O_EN_N, (1<<10));
			/* set output level to high for GPIOAO_10 */
			setbits_le32(P_AO_GPIO_O_EN_N, (1<<26));
			printf("invalid hwid = %d\n", hwid);
			break;
	}

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
	/*
	 * read board hw id
	 * set and select the dts according the board hw id.
	 *
	 * hwid = 1	p321 v1
	 * hwid = 2	p321 v2
	 */
	unsigned int ddr_size=0;
	unsigned int hwid = 1;
	char loc_name[64] = {0};
	int i;

	/* read ddr size */
	for (i=0; i<CONFIG_NR_DRAM_BANKS; i++) {
		ddr_size += gd->bd->bi_dram[i].size;
	}
#if defined(CONFIG_SYS_MEM_TOP_HIDE)
	ddr_size += CONFIG_SYS_MEM_TOP_HIDE;
#endif

	/* read hwid */
	hwid = (readl(P_AO_SEC_GP_CFG0) >> 8) & 0xFF;

	printf("checkhw:  hwid = %d\n", hwid);


	switch (hwid) {
		case 1:
			strcpy(loc_name, "txl_p321_v1\0");
			break;
		case 2:
			switch (ddr_size) {
				case 0x80000000:
					strcpy(loc_name, "txl_p321_v2-2g\0");
					break;
				case 0x40000000:
					strcpy(loc_name, "txl_p321_v2-1g\0");
					break;
				default:
					strcpy(loc_name, "txl_p321_unsupport");
					break;
				}
			break;
		default:
			strcpy(loc_name, "txl_p321_v1");
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
		"lock",
		"upgrade_step",

		NULL//Keep NULL be last to tell END
};
