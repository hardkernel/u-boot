/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <malloc.h>
#include <errno.h>
#include <environment.h>
#include <fdt_support.h>
#include <libfdt.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/eth_setup.h>
#include <asm/arch-gxb/gpio.h>
#include <asm-generic/gpio.h>
#include <usb/fastboot.h>

#ifdef CONFIG_AML_VPU
#include <vpu.h>
#endif

#ifdef CONFIG_AML_HDMITX20
#include <amlogic/hdmi.h>
#endif

DECLARE_GLOBAL_DATA_PTR;

extern int board_get_recovery_message(void);

#define GPIO_SW_UMS		28	/* GPIOY_5 */
#define GPIO_BLUELED		132
#define GPIO_USB_PWREN		123
#define GPIO_OTG_PWREN		124

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

void secondary_boot_func(void)
{
	/*
	 * TODO: should be written in ASM if necessary
	 */
}


/*
 * Discover the boot reason:
 *   1. check if the board is started with Android Self-Installation.
 *   2. if rebooted by 'reboot' command in previous kernel boot.
 *   3. Otherwise returns normal boot response by power cycle.
 */
int board_reboot_reason(void)
{
	static int __reboot_reason = ODROID_REBOOT_CMD_UNKNOWN;

	if (ODROID_REBOOT_CMD_UNKNOWN == __reboot_reason) {
		__reboot_reason = board_get_recovery_message();
		if (ODROID_REBOOT_CMD_UNKNOWN == __reboot_reason)
			__reboot_reason = (readl(AO_SEC_SD_CFG15) >> 12) & 0xf;
	}

	return __reboot_reason;
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

#if defined(CONFIG_SYS_I2C_AML)
#include <aml_i2c.h>

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

static void board_i2c_init(void)
{
	//disable all other pins which share with I2C_SDA_AO & I2C_SCK_AO
	clrbits_le32(P_AO_RTI_PIN_MUX_REG,
			(1 << 2) | (1 << 24) | (1 << 1) | (1 << 23));

	//enable I2C MASTER AO pins
	setbits_le32(P_AO_RTI_PIN_MUX_REG,
			(MESON_I2C_MASTER_AO_GPIOAO_4_BIT
			 | MESON_I2C_MASTER_AO_GPIOAO_5_BIT));

	udelay(10);

	//Amlogic I2C controller initialized
	//note: it must be call before any I2C operation
	aml_i2c_init();

	udelay(10);
}
#endif

#if defined(CONFIG_BOARD_EARLY_INIT_F)
int board_early_init_f(void)
{
	return 0;
}
#endif

static void board_run_fastboot(void)
{
	run_command("fastboot", 0);
}

static void board_run_recovery(void)
{
	run_command("movi read dtb 0 ${dtb_mem_addr}", 0);
	run_command("movi read recovery 0 ${loadaddr}", 0);
	run_command("bootm ${load_addr}", 0);
}

#ifdef CONFIG_BOARD_LATE_INIT
int board_late_init(void)
{
	int reboot_reason;

	/*
	 * If UMS SW is 'on', the device will run as USB Mass Storage
	 */
	if (1 == gpio_get_value(GPIO_SW_UMS))
		run_command("ums 0 mmc 0", 0);

	board_partition_init();

	reboot_reason = board_reboot_reason();
	if (ODROID_REBOOT_CMD_FASTBOOT == reboot_reason)
		board_run_fastboot();
	else if (ODROID_REBOOT_CMD_RECOVERY == reboot_reason)
		board_run_recovery();

	return 0;
}
#endif

#if defined(CONFIG_USB_DWC_OTG_HCD)
#include <asm/arch/usb.h>

static void callback_otg_power(char power)
{
	gpio_direction_output(GPIO_OTG_PWREN, power);
}

static void callback_host_power(char power)
{
	gpio_direction_output(GPIO_USB_PWREN, power);
}

static struct amlogic_usb_config usb_config0 = {
	.clk_selecter	= USB_PHY_CLK_SEL_XTAL,
	.pll_divider	= 1,
	.base_addr	= CONFIG_M8_USBPORT_BASE_A,
	.id_mode	= USB_ID_MODE_SW_HOST,
	.set_vbus_power	= callback_otg_power,
};

static struct amlogic_usb_config usb_config1= {
	.clk_selecter	= USB_PHY_CLK_SEL_XTAL,
	.pll_divider	= 1,
	.base_addr	= CONFIG_M8_USBPORT_BASE_B,
	.id_mode	= USB_ID_MODE_SW_HOST,
	.set_vbus_power	= callback_host_power,
};

struct amlogic_usb_config *amlogic_usb_config(int port)
{
	if (0 == port)
		return &usb_config0;
	else if (1 == port)
		return &usb_config1;

	return NULL;
}
#endif

int board_init(void)
{
	/* LED: SYSLED (Blue color) */
	gpio_request(GPIO_BLUELED, "blueled");
	gpio_direction_output(GPIO_BLUELED, 0);

	/*
	 * USB Host: RST_N for GL852
	 * Off by default, On when USB HOST is activated
	 */
	gpio_request(GPIO_USB_PWREN, "usb_pwren");
	gpio_direction_output(GPIO_USB_PWREN, 0);

	/*
	 * USB OTG: Power 
	 * Off by default, On when USB OTG is activated
	 */
	gpio_request(GPIO_OTG_PWREN, "otg_pwren");
	gpio_direction_output(GPIO_OTG_PWREN, 0);

	/*
	 * GPIO: USB MassStorage
	 * Low  - Normal boot
	 * High - Act as USB Mass Storage Device
	 */
	gpio_request(GPIO_SW_UMS, "sw_ums");
	gpio_direction_input(GPIO_SW_UMS);

#if defined(CONFIG_USB_DWC_OTG_HCD)
	amlogic_usb_init(&usb_config0, BOARD_USB_MODE_SLAVE);
	amlogic_usb_init(&usb_config1, BOARD_USB_MODE_HOST);
#endif

#ifdef CONFIG_AML_VPU
	vpu_probe();
#endif

#ifdef CONFIG_AML_HDMITX20
	hdmi_tx_init();
#endif

	return 0;
}

phys_size_t get_effective_memsize(void)
{
	phys_size_t phys_size = (readl(AO_SEC_GP_CFG0) & 0xFFFF0000) << 4;

#if defined(CONFIG_SYS_MEM_TOP_HIDE)
	phys_size -= CONFIG_SYS_MEM_TOP_HIDE;
#endif

	return phys_size;
}

#ifdef CONFIG_MULTI_DTB
int checkhw(char * name)
{
	unsigned int ddr_size=0;
	char loc_name[64] = {0};
	int i;

	for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		ddr_size += gd->bd->bi_dram[i].size;
	}

#if defined(CONFIG_SYS_MEM_TOP_HIDE)
	ddr_size += CONFIG_SYS_MEM_TOP_HIDE;
#endif

	switch (ddr_size) {
	case 0x80000000:
		strcpy(loc_name, "odroidc2_2g\0");
		break;
	case 0x40000000:
		strcpy(loc_name, "odroidc2_1g\0");
		break;
	case 0x2000000:
		strcpy(loc_name, "odroidc2_512m\0");
		break;
	default:
		//printf("DDR size: 0x%x, multi-dt doesn't support\n", ddr_size);
		strcpy(loc_name, "odroidc2_unsupport");
		break;
	}

	strcpy(name, loc_name);
	setenv("aml_dt", loc_name);

	return 0;
}
#endif
