/*
 * Pinctrl driver for Rockchip 3066 SoCs
 * (C) Copyright 2017 Paweł Jarosz <paweljarosz3691@gmail.com>
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <dm/device.h>
#include <errno.h>
#include <syscon.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/grf_rk3066.h>
#include <asm/arch/hardware.h>
#include <asm/arch/periph.h>
#include <dm/pinctrl.h>

DECLARE_GLOBAL_DATA_PTR;

struct rk3066_pinctrl_priv {
	struct rk3066_grf *grf;
};

static void pinctrl_rk3066_pwm_config(struct rk3066_grf *grf, int pwm_id)
{
	switch (pwm_id) {
	case PERIPH_ID_PWM0:
		rk_clrsetreg(&grf->gpio0a_iomux, GPIO0A3_MASK,
			     GPIO0A3_PWM0 << GPIO0A3_SHIFT);
		break;
	case PERIPH_ID_PWM1:
		rk_clrsetreg(&grf->gpio0a_iomux, GPIO0A4_MASK,
			     GPIO0A4_PWM1 << GPIO0A4_SHIFT);
		break;
	case PERIPH_ID_PWM2:
		rk_clrsetreg(&grf->gpio0d_iomux, GPIO0D6_MASK,
			     GPIO0D6_PWM2 << GPIO0D6_SHIFT);
		break;
	case PERIPH_ID_PWM3:
		rk_clrsetreg(&grf->gpio0d_iomux, GPIO0D7_MASK,
			     GPIO0D7_PWM3 << GPIO0D7_SHIFT);
		break;
	default:
		debug("pwm id = %d iomux error!\n", pwm_id);
		break;
	}
}

static void pinctrl_rk3066_i2c_config(struct rk3066_grf *grf, int i2c_id)
{
	switch (i2c_id) {
	case PERIPH_ID_I2C0:
		rk_clrsetreg(&grf->gpio2d_iomux,
			     GPIO2D4_MASK | GPIO2D5_MASK,
			     GPIO2D4_I2C0_SDA << GPIO2D4_SHIFT |
			     GPIO2D5_I2C0_SCL << GPIO2D5_SHIFT);
		rk_clrsetreg(&grf->soc_con1, 1 << RKI2C0_SEL_SHIFT,
					     1 << RKI2C0_SEL_SHIFT);
		break;
	case PERIPH_ID_I2C1:
		rk_clrsetreg(&grf->gpio2d_iomux,
			     GPIO2D6_MASK | GPIO2D7_MASK,
			     GPIO2D6_I2C1_SDA << GPIO2D6_SHIFT |
			     GPIO2D7_I2C1_SCL << GPIO2D7_SHIFT);
		rk_clrsetreg(&grf->soc_con1, 1 << RKI2C1_SEL_SHIFT,
					     1 << RKI2C1_SEL_SHIFT);
		break;
	case PERIPH_ID_I2C2:
		rk_clrsetreg(&grf->gpio3a_iomux,
			     GPIO3A1_MASK | GPIO3A0_MASK,
			     GPIO3A1_I2C2_SCL << GPIO3A1_SHIFT |
			     GPIO3A0_I2C2_SDA << GPIO3A0_SHIFT);
		rk_clrsetreg(&grf->soc_con1, 1 << RKI2C2_SEL_SHIFT,
					     1 << RKI2C2_SEL_SHIFT);
	case PERIPH_ID_I2C3:
		rk_clrsetreg(&grf->gpio3a_iomux,
			     GPIO3A3_MASK | GPIO3A2_MASK,
			     GPIO3A3_I2C3_SCL << GPIO3A3_SHIFT |
			     GPIO3A2_I2C3_SDA << GPIO3A2_SHIFT);
		rk_clrsetreg(&grf->soc_con1, 1 << RKI2C3_SEL_SHIFT,
					     1 << RKI2C3_SEL_SHIFT);
	case PERIPH_ID_I2C4:
		rk_clrsetreg(&grf->gpio3a_iomux,
			     GPIO3A5_MASK | GPIO3A4_MASK,
			     GPIO3A5_I2C4_SCL << GPIO3A5_SHIFT |
			     GPIO3A4_I2C4_SDA << GPIO3A4_SHIFT);
		rk_clrsetreg(&grf->soc_con1, 1 << RKI2C4_SEL_SHIFT,
					     1 << RKI2C4_SEL_SHIFT);
		break;
	}
}

static void pinctrl_rk3066_spi_config(struct rk3066_grf *grf, int spi_id, int cs)
{
	switch (spi_id) {
	case PERIPH_ID_SPI0:
		rk_clrsetreg(&grf->gpio1a_iomux,
			     GPIO1A7_MASK | GPIO1A6_MASK | GPIO1A5_MASK,
			     GPIO1A7_SPI0_TXD << GPIO1A7_SHIFT |
			     GPIO1A6_SPI0_RXD << GPIO1A6_SHIFT |
			     GPIO1A5_SPI0_CLK << GPIO1A5_SHIFT);
		if(cs == 0)
			rk_clrsetreg(&grf->gpio1a_iomux,
				     GPIO1A4_MASK,
				     GPIO1A4_SPI0_CSN0 << GPIO1A4_SHIFT);
		else
			rk_clrsetreg(&grf->gpio4b_iomux,
				     GPIO4B7_MASK,
				     GPIO4B7_SPI0_CSN1 << GPIO4B7_SHIFT);
		break;
	case PERIPH_ID_SPI1:
		rk_clrsetreg(&grf->gpio2c_iomux,
			     GPIO2C5_MASK | GPIO2C6_MASK | GPIO2C3_MASK,
			     GPIO2C5_SPI1_TXD << GPIO2C5_SHIFT |
			     GPIO2C6_SPI1_RXD << GPIO2C6_SHIFT |
			     GPIO2C3_SPI1_CLK << GPIO2C3_SHIFT);
		if(cs == 0)
			rk_clrsetreg(&grf->gpio2c_iomux,
				     GPIO2C4_MASK,
				     GPIO2C4_SPI1_CSN0 << GPIO2C4_SHIFT);
		else
			rk_clrsetreg(&grf->gpio2c_iomux,
				     GPIO2C7_MASK,
				     GPIO2C7_SPI1_CSN1 << GPIO2C7_SHIFT);
		break;
	}
}

static void pinctrl_rk3066_uart_config(struct rk3066_grf *grf, int uart_id)
{
	switch (uart_id) {
	case PERIPH_ID_UART0:
		rk_clrsetreg(&grf->gpio1a_iomux,
			     GPIO1A2_MASK | GPIO1A3_MASK |
			     GPIO1A0_MASK | GPIO1A1_MASK,
			     GPIO1A2_UART0_CTS_N << GPIO1A2_SHIFT |
			     GPIO1A3_UART0_RTS_N << GPIO1A3_SHIFT |
			     GPIO1A0_UART0_SIN << GPIO1A0_SHIFT |
			     GPIO1A1_UART0_SOUT << GPIO1A1_SHIFT);
		break;
	case PERIPH_ID_UART1:
		rk_clrsetreg(&grf->gpio1a_iomux,
			     GPIO1A7_MASK | GPIO1A6_MASK |
			     GPIO1A5_MASK | GPIO1A4_MASK,
			     GPIO1A7_UART1_RTS_N << GPIO1A7_SHIFT |
			     GPIO1A6_UART1_CTS_N << GPIO1A6_SHIFT |
			     GPIO1A5_UART1_SOUT << GPIO1A5_SHIFT |
			     GPIO1A4_UART1_SIN << GPIO1A4_SHIFT);
		break;
	case PERIPH_ID_UART2:
		rk_clrsetreg(&grf->gpio1b_iomux,
			     GPIO1B1_MASK | GPIO1B0_MASK,
			     GPIO1B1_UART2_SOUT << GPIO1B1_SHIFT |
			     GPIO1B0_UART2_SIN << GPIO1B0_SHIFT);
		break;
	case PERIPH_ID_UART3:
		rk_clrsetreg(&grf->gpio3d_iomux,
			     GPIO3D6_MASK | GPIO3D5_MASK |
			     GPIO3D4_MASK | GPIO3D3_MASK,
			     GPIO3D6_UART3_RTS_N << GPIO3D6_SHIFT |
			     GPIO3D5_UART3_CTS_N << GPIO3D5_SHIFT |
			     GPIO3D4_UART3_SOUT << GPIO3D4_SHIFT |
			     GPIO3D3_UART3_SIN << GPIO3D3_SHIFT);
		break;
	}
}

static void pinctrl_rk3066_sdmmc_config(struct rk3066_grf *grf, int mmc_id)
{
	switch (mmc_id) {
	case PERIPH_ID_EMMC:
		rk_clrsetreg(&grf->soc_con0,
			     EMMC_FLASH_SEL_MASK,
			     1 << EMMC_FLASH_SEL_SHIFT);
		rk_clrsetreg(&grf->gpio3d_iomux,
			     GPIO3D7_MASK,
			     GPIO3D7_EMMC_CLKOUT << GPIO3D7_SHIFT);
		rk_clrsetreg(&grf->gpio4b_iomux,
			     GPIO4B2_MASK | GPIO4B1_MASK,
			     GPIO4B2_EMMC_RSTN_OUT << GPIO4B2_SHIFT |
			     GPIO4B1_EMMC_CMD << GPIO4B1_SHIFT);
		break;
	case PERIPH_ID_SDCARD:
		rk_clrsetreg(&grf->gpio3b_iomux, 0xffff,
			     GPIO3B7_SDMMC0_WRITE_PRT << GPIO3B7_SHIFT |
			     GPIO3B6_SDMMC0_DETECT_N << GPIO3B6_SHIFT |
			     GPIO3B5_SDMMC0_DATA3 << GPIO3B5_SHIFT |
			     GPIO3B4_SDMMC0_DATA2 << GPIO3B4_SHIFT |
			     GPIO3B3_SDMMC0_DATA1 << GPIO3B3_SHIFT |
			     GPIO3B2_SDMMC0_DATA0 << GPIO3B2_SHIFT |
			     GPIO3B1_SDMMC0_CMD << GPIO3B1_SHIFT |
			     GPIO3B0_SDMMC0_CLKOUT << GPIO3B0_SHIFT);
		break;
	}
}

static void pinctrl_rk3066_nand_config(struct rk3066_grf *grf)
{
	rk_clrsetreg(&grf->soc_con0,
		     EMMC_FLASH_SEL_MASK,
		     0 << EMMC_FLASH_SEL_SHIFT);
	rk_clrsetreg(&grf->gpio3d_iomux,
		     GPIO3D7_MASK,
		     GPIO3D7_FLASH_DQS << GPIO3D7_SHIFT);
}

static int rk3066_pinctrl_request(struct udevice *dev, int func, int flags)
{
	struct rk3066_pinctrl_priv *priv = dev_get_priv(dev);

	debug("%s: func=%x, flags=%x\n", __func__, func, flags);
	switch (func) {
	case PERIPH_ID_PWM0:
	case PERIPH_ID_PWM1:
	case PERIPH_ID_PWM2:
	case PERIPH_ID_PWM3:
		pinctrl_rk3066_pwm_config(priv->grf, func);
		break;
	case PERIPH_ID_I2C0:
	case PERIPH_ID_I2C1:
	case PERIPH_ID_I2C2:
	case PERIPH_ID_I2C3:
	case PERIPH_ID_I2C4:
		pinctrl_rk3066_i2c_config(priv->grf, func);
		break;
	case PERIPH_ID_SPI0:
	case PERIPH_ID_SPI1:
		pinctrl_rk3066_spi_config(priv->grf, func, flags);
		break;
	case PERIPH_ID_UART0:
	case PERIPH_ID_UART1:
	case PERIPH_ID_UART2:
	case PERIPH_ID_UART3:
		pinctrl_rk3066_uart_config(priv->grf, func);
		break;
	case PERIPH_ID_EMMC:
	case PERIPH_ID_SDCARD:
		pinctrl_rk3066_sdmmc_config(priv->grf, func);
		break;
	case PERIPH_ID_NAND:
		pinctrl_rk3066_nand_config(priv->grf);
		break;
	default:
		return -EINVAL;
	}

	return 0;
}

static int rk3066_pinctrl_get_periph_id(struct udevice *dev,
					struct udevice *periph)
{
#if !CONFIG_IS_ENABLED(OF_PLATDATA)
	u32 cell[3];
	int ret;

	ret = fdtdec_get_int_array(gd->fdt_blob, dev_of_offset(periph),
				   "interrupts", cell, ARRAY_SIZE(cell));
	if (ret < 0)
		return -EINVAL;

	switch (cell[1]) {
	case 23:
		return PERIPH_ID_SDCARD;
	case 25:
		return PERIPH_ID_EMMC;
	case 27:
		return PERIPH_ID_NAND;
	case 34:
		return PERIPH_ID_UART0;
	case 35:
		return PERIPH_ID_UART1;
	case 36:
		return PERIPH_ID_UART2;
	case 37:
		return PERIPH_ID_UART3;
	case 38:
		return PERIPH_ID_SPI0;
	case 39:
		return PERIPH_ID_SPI1;
	case 40:
		return PERIPH_ID_I2C0;
	case 41:
		return PERIPH_ID_I2C1;
	case 42:
		return PERIPH_ID_I2C2;
	case 43:
		return PERIPH_ID_I2C3;
	case 30:
		return PERIPH_ID_PWM0;
	}
#endif
	return -ENOENT;
}

static int rk3066_pinctrl_set_state_simple(struct udevice *dev,
					   struct udevice *periph)
{
	int func;

	func = rk3066_pinctrl_get_periph_id(dev, periph);
	if (func < 0)
		return func;
	return rk3066_pinctrl_request(dev, func, 0);
}

static struct pinctrl_ops rk3066_pinctrl_ops = {
	.set_state_simple	= rk3066_pinctrl_set_state_simple,
	.request	= rk3066_pinctrl_request,
	.get_periph_id	= rk3066_pinctrl_get_periph_id,
};

static int rk3066_pinctrl_probe(struct udevice *dev)
{
	struct rk3066_pinctrl_priv *priv = dev_get_priv(dev);

	priv->grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	if (IS_ERR(priv->grf))
		debug("%s: grf=%p\n", __func__, priv->grf);
	return 0;
}

static const struct udevice_id rk3066_pinctrl_ids[] = {
	{ .compatible = "rockchip,rk3066a-pinctrl" },
	{ }
};

U_BOOT_DRIVER(rockchip_rk3066a_pinctrl) = {
	.name		= "rockchip_rk3066a_pinctrl",
	.id		= UCLASS_PINCTRL,
	.of_match	= rk3066_pinctrl_ids,
	.priv_auto_alloc_size = sizeof(struct rk3066_pinctrl_priv),
	.ops		= &rk3066_pinctrl_ops,
#if !CONFIG_IS_ENABLED(OF_PLATDATA)
	.bind           = dm_scan_fdt_dev,
#endif
	.probe		= rk3066_pinctrl_probe,
};
