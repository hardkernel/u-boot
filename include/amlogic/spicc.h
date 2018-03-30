/*
 * Amlogic Meson SPI communication controller(SPICC)
 *
 * Copyright (C) 2017 Amlogic Corporation
 *
 * Licensed under the GPL-2 or later.
 *
 */

#ifndef __SPICC_H__
#define __SPICC_H__

#define SPICC_DEFAULT_CLK_RATE 166666666
#define CS_GPIO_MAX 2

/*
 * @compatible:
 * @reg: controller registers address.
 * @mem_map: memory_mapped for read operations.
 * @clk_rate:
 * @clk_set_rate:
 * @pinctrl_enable:
 * @num_chipselect:
 * @cs_gpios:
 */
struct spicc_platdata {
#ifndef CONFIG_OF_CONTROL
	char *compatible;
	int clk_rate;
	int (*clk_set_rate)(int rate);
	int (*clk_enable)(bool enable);
	int (*pinctrl_enable)(bool enable);
#endif
	void __iomem *reg;
	const char *cs_gpio_names[CS_GPIO_MAX];
	unsigned int clk_cs_delay;
	unsigned int mo_delay;
	unsigned int mi_delay;
	unsigned int mi_capture_delay;
	unsigned int tt_delay;
	unsigned int ti_delay;
};

#endif /* __SPICC_H__ */