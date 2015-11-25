
/*
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
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/io.h>
#endif
#ifdef CONFIG_AML_VPU
#include <vpu.h>
#endif
#ifdef CONFIG_AML_V2_FACTORY_BURN
#include <amlogic/aml_v2_burning.h>
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN
#ifdef CONFIG_AML_HDMITX20
#include <amlogic/hdmi.h>
#endif
#include <asm/arch/eth_setup.h>

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

static void setup_net_chip(void)
{
	eth_aml_reg0_t eth_reg0;

	//setup ethernet clk need calibrate to configre
	setbits_le32(P_PERIPHS_PIN_MUX_6, 0x3fff);

	eth_reg0.d32 = 0;
	eth_reg0.b.phy_intf_sel = 1;
	eth_reg0.b.data_endian = 0;
	eth_reg0.b.desc_endian = 0;
	eth_reg0.b.rx_clk_rmii_invert = 0;
	eth_reg0.b.rgmii_tx_clk_src = 0;
	eth_reg0.b.rgmii_tx_clk_phase = 1;
	eth_reg0.b.rgmii_tx_clk_ratio = 4;
	eth_reg0.b.phy_ref_clk_enable = 1;
	eth_reg0.b.clk_rmii_i_invert = 0;
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
	setbits_le32(P_PREG_ETH_REG0, eth_reg0.d32);// rgmii mode

	setbits_le32(HHI_GCLK_MPEG1,1<<3);

	/* power on memory */
	clrbits_le32(HHI_MEM_PD_REG0, (1 << 3) | (1<<2));

	/* hardware reset ethernet phy : gpioz14 connect phyreset pin*/
	clrbits_le32(PREG_PAD_GPIO3_EN_N, 1 << 14);
	clrbits_le32(PREG_PAD_GPIO3_O, 1 << 14);
	udelay(10000);
	setbits_le32(PREG_PAD_GPIO3_O, 1 << 14);
}

extern struct eth_board_socket* eth_board_setup(char *name);
extern int aml_eth_init(bd_t *bis);
int board_eth_init(bd_t *bis)
{
	setup_net_chip();
	udelay(1000);
	aml_eth_init(bis);

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
#if 0
static void board_i2c_set_pinmux(void){
	/*********************************************/
	/*                | I2C_Master_B        |I2C_Slave            |       */
	/*********************************************/
	/*                | I2C_SCK                | I2C_SCK_SLAVE  |      */
	/* GPIODV_26  | [AO_PIN_MUX: 6]     | [AO_PIN_MUX: 2]   |     */
	/*********************************************/
	/*                | I2C_SDA                 | I2C_SDA_SLAVE  |     */
	/* GPIODV_27  | [AO_PIN_MUX: 5]     | [AO_PIN_MUX: 1]   |     */
	/*********************************************/

	//disable all other pins which share with I2C_SDA_B & I2C_SCK_B
	clrbits_le32(P_PERIPHS_PIN_MUX_0, ((1<<9)|(1<<10)));
	clrbits_le32(P_PERIPHS_PIN_MUX_2, ((1<<26)|(1<<27)));
	clrbits_le32(P_PERIPHS_PIN_MUX_5, ((1<<8)|(1<<9)|(1<<10)));
	//enable I2C MASTER B pins
	setbits_le32(P_PERIPHS_PIN_MUX_7,
	(MESON_I2C_MASTER_B_GPIODV_26_BIT | MESON_I2C_MASTER_B_GPIODV_27_BIT));

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
	.scl_reg    = (unsigned long)MESON_I2C_MASTER_B_GPIODV_27_REG,
	.scl_bit    = MESON_I2C_MASTER_B_GPIODV_27_BIT,
	.sda_reg    = (unsigned long)MESON_I2C_MASTER_B_GPIODV_26_REG,
	.sda_bit    = MESON_I2C_MASTER_B_GPIODV_26_BIT,
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

#ifdef CONFIG_USB_DWC_OTG_HCD
#include <asm/arch/usb.h>

static void gpio_set_vbus_power(char is_power_on)
{
	if (is_power_on) {
		setbits_le32(PREG_PAD_GPIO0_EN_N, 1<<24);
		setbits_le32(PREG_PAD_GPIO0_O, 1<<24);
	} else {
	}
}

static int usb_charging_detect_call_back(char bc_mode)
{
	switch (bc_mode) {
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

struct amlogic_usb_config g_usb_config_gx_skt_a={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_A,
	USB_ID_MODE_SW_HOST,
	gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_gx_skt_b={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_B,
	USB_ID_MODE_SW_HOST,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	NULL,
};
struct amlogic_usb_config g_usb_config_gx_skt_h={
	USB_PHY_CLK_SEL_XTAL,
	1, //PLL divider: (clock/12 -1)
	CONFIG_M8_USBPORT_BASE_A,
	USB_ID_MODE_HARDWARE,
	NULL,//gpio_set_vbus_power, //set_vbus_power
	usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/

#ifdef CONFIG_AML_HDMITX20
static void hdmi_tx_set_hdmi_5v(void)
{
	/*Power on VCC_5V for HDMI_5V*/
	clrbits_le32(P_AO_GPIO_O_EN_N, ((1<<2)|(1<<18)));
}
#endif

int board_init(void)
{
    //Please keep CONFIG_AML_V2_FACTORY_BURN at first place of board_init
#ifdef CONFIG_AML_V2_FACTORY_BURN
	aml_try_factory_usb_burning(0, gd->bd);
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN
		/*for LED*/
	//clear pinmux
	clrbits_le32(AO_RTI_PIN_MUX_REG, ((1<<3)|(1<<4)));
	clrbits_le32(AO_RTI_PIN_MUX_REG2, ((1<<1)|(1<<31)));
	//set output mode
	clrbits_le32(P_AO_GPIO_O_EN_N, (1<<13));
	//set output 1
	setbits_le32(P_AO_GPIO_O_EN_N, (1<<29));
	/*Power on GPIOAO_2 for VCC_5V*/
	clrbits_le32(P_AO_GPIO_O_EN_N, ((1<<2)|(1<<18)));
	#ifdef CONFIG_USB_DWC_OTG_HCD
	amlogic_usb_init(&g_usb_config_gx_skt_a,BOARD_USB_MODE_HOST);
	amlogic_usb_init(&g_usb_config_gx_skt_b,BOARD_USB_MODE_HOST);
	amlogic_usb_init(&g_usb_config_gx_skt_h,BOARD_USB_MODE_CHARGER);
#endif /*CONFIG_USB_DWC_OTG_HCD*/
#ifdef CONFIG_AML_VPU
	vpu_probe();
#endif
#ifdef CONFIG_AML_HDMITX20
	hdmi_tx_set_hdmi_5v();
	hdmi_tx_init();
#endif
#ifdef CONFIG_AML_NAND
	extern int amlnf_init(unsigned char flag);
	amlnf_init(0);
#endif
	return 0;
}

#ifdef CONFIG_BOARD_LATE_INIT
int board_late_init(void){
	int ret;
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
#ifdef CONFIG_AML_V2_FACTORY_BURN
	aml_try_factory_sdcard_burning(0, gd->bd);
#endif// #ifdef CONFIG_AML_V2_FACTORY_BURN

	return 0;
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
	unsigned int ddr_size=0;
	char loc_name[64] = {0};
	int i;
	for (i=0; i<CONFIG_NR_DRAM_BANKS; i++) {
		ddr_size += gd->bd->bi_dram[i].size;
	}
#if defined(CONFIG_SYS_MEM_TOP_HIDE)
	ddr_size += CONFIG_SYS_MEM_TOP_HIDE;
#endif
	switch (ddr_size) {
		case 0x80000000:
			strcpy(loc_name, "gxb_p200_2g\0");
			break;
		case 0x40000000:
			strcpy(loc_name, "gxb_p200_1g\0");
			break;
		case 0x2000000:
			strcpy(loc_name, "gxb_p200_512m\0");
			break;
		default:
			//printf("DDR size: 0x%x, multi-dt doesn't support\n", ddr_size);
			strcpy(loc_name, "gxb_p200_unsupport");
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

		NULL//Keep NULL be last to tell END
};

