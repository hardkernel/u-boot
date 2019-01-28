
/*
 * board/amlogic/axg_s400_v1/axg_s400_v1_sbr.c
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
#include <asm/arch/secure_apb.h>
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#endif
#ifdef CONFIG_SYS_I2C_MESON
#include <amlogic/i2c.h>
#endif
#include <dm.h>
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
#include <asm/cpu_id.h>
#include <linux/mtd/partitions.h>
#include <linux/sizes.h>
#include <asm/arch/clock.h>
#include <asm-generic/gpio.h>
#include <asm/arch/board_id.h>
#ifdef CONFIG_SYS_I2C_AML_IS31F123XX
#include <amlogic/aml_is31fl32xx.h>
#endif

#include <storage.h>
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

#ifdef CONFIG_CMD_NET
static void setup_net_chip(void)
{
	eth_aml_reg0_t eth_reg0;
	writel(0x11111111, P_PERIPHS_PIN_MUX_8);
	writel(0x111111, P_PERIPHS_PIN_MUX_9);
	eth_reg0.d32 = 0;
	eth_reg0.b.phy_intf_sel = 1;
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
	setbits_le32(P_PREG_ETH_REG0, eth_reg0.d32);// rmii mode
	setbits_le32(HHI_GCLK_MPEG1,1<<3);
	/* power on memory */
	clrbits_le32(HHI_MEM_PD_REG0, (1 << 3) | (1<<2));

	/* hardware reset ethernet phy : gpioY15 connect phyreset pin*/
	udelay(1000);
	setbits_le32(P_PREG_PAD_GPIO1_EN_N, 1 << 15);

}

extern struct eth_board_socket* eth_board_setup(char *name);
extern int designware_initialize(ulong base_addr, u32 interface);

int board_eth_init(bd_t *bis)
{
	setup_net_chip();
	udelay(1000);
	designware_initialize(ETH_BASE, PHY_INTERFACE_MODE_RMII);
	return 0;
}
#endif

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
			/*axg skt using GPIOX_6 as CD, no debug board anymore*/
			clrbits_le32(P_PERIPHS_PIN_MUX_4, 0xF000000);
			setbits_le32(P_PREG_PAD_GPIO2_EN_N, 1 << 6);
			ret = readl(P_PREG_PAD_GPIO2_I) & (1 << 6) ? 0 : 1;
			printf("%s\n", ret ? "card in" : "card out");
		#if 0 /* no default card on board. */
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
		#endif
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
#endif

#ifdef CONFIG_SYS_I2C_AML
struct aml_i2c_platform g_aml_i2c_plat = {
};
/* multi i2c bus */
struct aml_i2c_platform g_aml_i2c_ports[] = {
	{
		.wait_count         = 1000000,
		.wait_ack_interval  = 5,
		.wait_read_interval = 5,
		.wait_xfer_interval = 5,
		.master_no          = AML_I2C_MASTER_AO,
		.use_pio            = 0,
		.master_i2c_speed   = CONFIG_SYS_I2C_SPEED,
		.master_ao_pinmux = {
			.scl_reg    = (unsigned long)MESON_I2C_MASTER_AO_GPIOAO_10_REG,
			.scl_bit    = MESON_I2C_MASTER_AO_GPIOAO_10_BIT,
			.sda_reg    = (unsigned long)MESON_I2C_MASTER_AO_GPIOAO_11_REG,
			.sda_bit    = MESON_I2C_MASTER_AO_GPIOAO_11_BIT,
		}
	},
	{
		.wait_count         = 1000000,
		.wait_ack_interval  = 5,
		.wait_read_interval = 5,
		.wait_xfer_interval = 5,
		.master_no          = AML_I2C_MASTER_B,
		.use_pio            = 0,
		.master_i2c_speed   = CONFIG_SYS_I2C_SPEED,
		.master_b_pinmux = {
			.scl_reg    = (unsigned long)MESON_I2C_MASTER_B_GPIOZ_8_REG,
			.scl_bit    = MESON_I2C_MASTER_B_GPIOZ_8_BIT,
			.sda_reg    = (unsigned long)MESON_I2C_MASTER_B_GPIOZ_9_REG,
			.sda_bit    = MESON_I2C_MASTER_B_GPIOZ_9_BIT,
		}
	},
	/* sign of end */
	{.master_i2c_speed=0},
};

static void board_i2c_init(void)
{
	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	extern void aml_i2c_set_ports(struct aml_i2c_platform *i2c_plat);
	aml_i2c_set_ports(g_aml_i2c_ports);

	udelay(10);
}

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

static void gpio_set_vbus_power(char is_power_on)
{
	if (is_power_on) {
		clrbits_le32(P_AO_GPIO_O_EN_N, (1<<5));
		setbits_le32(P_AO_GPIO_O_EN_N, (1<<21));
	} else {
		clrbits_le32(P_AO_GPIO_O_EN_N, (1<<5));
		clrbits_le32(P_AO_GPIO_O_EN_N, (1<<21));
	}
}

struct amlogic_usb_config g_usb_config_GXL_skt={
	CONFIG_GXL_XHCI_BASE,
	USB_ID_MODE_HARDWARE,
	gpio_set_vbus_power,
	CONFIG_GXL_USB_PHY2_BASE,
	CONFIG_GXL_USB_PHY3_BASE,
	CONFIG_GXL_USB_U2_PORT_NUM,
	CONFIG_GXL_USB_U3_PORT_NUM,
};
#endif /*CONFIG_USB_XHCI_AMLOGIC*/

#ifdef CONFIG_AML_PCIE
#include <asm/arch-axg/pci.h>

static void pcie_init_reset_pin(void)
{
	int ret;

	ret = gpio_request(CONFIG_AML_PCIEA_GPIO_RESET,
		CONFIG_AML_PCIEA_GPIO_RESET_NAME);
	if (ret && ret != -EBUSY) {
		printf("gpio: requesting pin %u failed\n", CONFIG_AML_PCIEA_GPIO_RESET);
		return;
	}
	gpio_direction_output(CONFIG_AML_PCIEA_GPIO_RESET, 0);

	ret = gpio_request(CONFIG_AML_PCIEB_GPIO_RESET,
		CONFIG_AML_PCIEB_GPIO_RESET_NAME);
	if (ret && ret != -EBUSY) {
		printf("gpio: requesting pin %u failed\n", CONFIG_AML_PCIEB_GPIO_RESET);
		return;
	}
	gpio_direction_output(CONFIG_AML_PCIEB_GPIO_RESET, 0);
}

void amlogic_pcie_init_reset_pin(int pcie_dev)
{
	int ret;

	if (pcie_dev == 0) {
		mdelay(5);
		ret = gpio_request(CONFIG_AML_PCIEA_GPIO_RESET,
			CONFIG_AML_PCIEA_GPIO_RESET_NAME);
		if (ret && ret != -EBUSY) {
			printf("gpio: requesting pin %u failed\n",
				CONFIG_AML_PCIEA_GPIO_RESET);
			return;
		}
		gpio_direction_output(CONFIG_AML_PCIEA_GPIO_RESET, 1);
	} else {
		mdelay(5);
		ret = gpio_request(CONFIG_AML_PCIEB_GPIO_RESET,
			CONFIG_AML_PCIEB_GPIO_RESET_NAME);
		if (ret && ret != -EBUSY) {
			printf("gpio: requesting pin %u failed\n",
				CONFIG_AML_PCIEB_GPIO_RESET);
			return;
		}
		gpio_direction_input(CONFIG_AML_PCIEB_GPIO_RESET);
	}
}

void amlogic_pcie_disable(void)
{
	int ret;

	ret = gpio_request(CONFIG_AML_PCIEA_GPIO_RESET,
		CONFIG_AML_PCIEA_GPIO_RESET_NAME);
	if (ret && ret != -EBUSY) {
		printf("gpio: requesting pin %u failed\n",
			CONFIG_AML_PCIEA_GPIO_RESET);
		return;
	}
	gpio_direction_output(CONFIG_AML_PCIEA_GPIO_RESET, 0);

	ret = gpio_request(CONFIG_AML_PCIEB_GPIO_RESET,
		CONFIG_AML_PCIEB_GPIO_RESET_NAME);
	if (ret && ret != -EBUSY) {
		printf("gpio: requesting pin %u failed\n",
			CONFIG_AML_PCIEB_GPIO_RESET);
		return;
	}
	gpio_direction_output(CONFIG_AML_PCIEB_GPIO_RESET, 0);
}
#endif

#ifdef CONFIG_AML_WIFI_EN_INIT
static void wifi_init_enable_pin(void)
{
	int ret;

	ret = gpio_request(CONFIG_AML_GPIO_WIFI_EN_1,
		CONFIG_AML_GPIO_WIFI_EN_1_NAME);
	if (ret && ret != -EBUSY) {
		printf("gpio: requesting pin %u failed\n", CONFIG_AML_GPIO_WIFI_EN_1);
		return;
	}
	gpio_direction_output(CONFIG_AML_GPIO_WIFI_EN_1, 1);

	ret = gpio_request(CONFIG_AML_GPIO_WIFI_EN_2,
		CONFIG_AML_GPIO_WIFI_EN_2_NAME);
	if (ret && ret != -EBUSY) {
		printf("gpio: requesting pin %u failed\n", CONFIG_AML_GPIO_WIFI_EN_2);
		return;
	}
	gpio_direction_output(CONFIG_AML_GPIO_WIFI_EN_2, 1);
}
#endif

#ifdef CONFIG_AML_HDMITX20
static void hdmi_tx_set_hdmi_5v(void)
{
}
#endif

/*
 * mtd nand partition table, only care the size!
 * offset will be calculated by nand driver.
 */
#ifdef CONFIG_AML_MTD
static struct mtd_partition normal_partition_info[] = {
#ifdef CONFIG_DISCRETE_BOOTLOADER
    /* MUST NOT CHANGE this part unless u know what you are doing!
     * inherent parition for descrete bootloader to store fip
     * size is determind by TPL_SIZE_PER_COPY*TPL_COPY_NUM
     * name must be same with TPL_PART_NAME
     */
    {
        .name = "tpl",
        .offset = 0,
        .size = 0,
    },
#endif
    {
        .name = "misc",
        .offset = 0,
        .size = 2*SZ_1M,
    },
    {
        .name = "logo",
        .offset = 0,
        .size = 2*SZ_1M,
    },
#ifdef CONFIG_AB_SYSTEM
    {
        .name = "boot_a",
        .offset = 0,
        .size = 15*SZ_1M,
    },
    {
        .name = "boot_b",
        .offset = 0,
        .size = 15*SZ_1M,
    },
    {
        .name = "system_a",
        .offset = 0,
        .size = 150*SZ_1M,
    },
    {
        .name = "system_b",
        .offset = 0,
        .size = 150*SZ_1M,
    },
 #else
    {
        .name = "recovery",
        .offset = 0,
        .size = 16*SZ_1M,
    },
    {
        .name = "boot",
        .offset = 0,
        .size = 15*SZ_1M,
    },
    {
        .name = "system",
        .offset = 0,
        .size = 280*SZ_1M,
    },
#endif
	/* last partition get the rest capacity */
    {
        .name = "data",
        .offset = MTDPART_OFS_APPEND,
        .size = MTDPART_SIZ_FULL,
    },
};
struct mtd_partition *get_aml_mtd_partition(void)
{
	return normal_partition_info;
}
int get_aml_partition_count(void)
{
	return ARRAY_SIZE(normal_partition_info);
}
#endif /* CONFIG_AML_MTD */
void power_save_pre(void)
{
	/*Close MIPI clock*/
	clrbits_le32(P_HHI_MIPI_CNTL0, 0xffffffff);
	clrbits_le32(P_HHI_MIPI_CNTL1, 0xffffffff);
	clrbits_le32(P_HHI_MIPI_CNTL2, 0xffdfffff);
}

#ifdef CONFIG_SYS_I2C_MESON
static const struct meson_i2c_platdata i2c_data[] = {
	{ 0, 0xffd1f000, 166666666, 3, 15, 100000 },
	{ 1, 0xffd1e000, 166666666, 3, 15, 100000 },
	{ 2, 0xffd1d000, 166666666, 3, 15, 100000 },
	{ 3, 0xffd1c000, 166666666, 3, 15, 100000 },
	{ 4, 0xff805000, 166666666, 3, 15, 100000 },
};

U_BOOT_DEVICES(meson_i2cs) = {
	{ "i2c_meson", &i2c_data[0] },
	{ "i2c_meson", &i2c_data[1] },
	{ "i2c_meson", &i2c_data[2] },
	{ "i2c_meson", &i2c_data[3] },
	{ "i2c_meson", &i2c_data[4] },
};

/*
 *GPIOAO_10//I2C_SDA_AO
 *GPIOAO_11//I2C_SCK_AO
 *pinmux configuration seperated with i2c controller configuration
 * config it when you use
 */
void set_i2c_ao_pinmux(void)
{
	clrbits_le32(P_AO_RTI_PINMUX_REG1, 0xf << 8 | 0xf << 12);
	setbits_le32(P_AO_RTI_PINMUX_REG1, 0x2 << 8 | 0x2 << 12);
}
#endif /*end CONFIG_SYS_I2C_MESON*/

int board_init(void)
{
#ifdef CONFIG_AML_PCIE
	pcie_init_reset_pin();
#endif

#ifdef CONFIG_AML_WIFI_EN_INIT
	wifi_init_enable_pin();
#endif

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
#ifdef CONFIG_SYS_I2C_AML
	board_i2c_init();
#endif
#ifdef CONFIG_SYS_I2C_MESON
	set_i2c_ao_pinmux();
#endif
#ifdef CONFIG_SYS_I2C_AML_IS31F123XX
	board_is31fl32xx_init();
	board_is31fl32xx_light_on();
#endif
	if (get_cpu_id().package_id == MESON_CPU_PACKAGE_ID_A113X)
		power_save_pre();
	return 0;
}

void aml_config_dtb(void)
{
	run_command("fdt address $dtb_mem_addr", 0);
	printf("%s %d\n", __func__, __LINE__);
	run_command("fdt set /mtd_nand status disable", 0);
	run_command("fdt set /emmc@ffe07000 status okay", 0);
}
#ifdef CONFIG_BOARD_LATE_INIT
int board_late_init(void){
	//update env before anyone using it
	run_command("get_rebootmode; echo reboot_mode=${reboot_mode}; "\
			"if test ${reboot_mode} = factory_reset; then "\
			"defenv_reserv;save; fi;", 0);
	run_command("if itest ${upgrade_step} == 1; then "\
				"defenv_reserv; setenv upgrade_step 2; saveenv; fi;", 0);
	/*add board late init function here*/
	int ret;
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
	//run_command("keyunify init 0x1234", 0);

#ifdef CONFIG_AML_VPU
	vpu_probe();
#endif
	//vpp_init();
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

	/**/
	extern int amlmmc_is_inited(void);
	if (amlmmc_is_inited() == EMMC_BOOT_FLAG) {
		aml_config_dtb();
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
	unsigned int b_id = 0;
	char loc_name[64] = {0};

	b_id = get_board_id();

	printf("%s board adc:%d\n", __func__, b_id);

	switch (b_id) {
	case 0:
	case 1:
	case 2:
		strcpy(loc_name, "axg_s400_1g\0");
		break;
	case 3:
		strcpy(loc_name, "axg_s400_v03sbr\0");
		break;
	default:
		strcpy(loc_name, "axg_s400_1g");
		break;
	}
	if (name != NULL)
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
