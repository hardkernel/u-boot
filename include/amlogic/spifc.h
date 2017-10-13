/*
 * Amlogic SPI flash controller(SPIFC)
 *
 * Copyright (C) 2017 Amlogic Corporation
 *
 * Licensed under the GPL-2 or later.
 *
 */

#ifndef __SPIFC_H__
#define __SPIFC_H__

#define SPIFC_DEFAULT_CLK_RATE 166666666
/*
 * @reg: controller registers address.
 * @mem_map: memory_mapped for read operations.
 * @clk_get(): callback to get spifc clk pointer.
 *   ret: should be "struct clk *"
 *   dev: should be "struct udevice *"
 * @clk_get_rate():
 * @clk_enable():
 * @pinctrl_get(): callback to get spifc pinctrl pointer.
 *   ret: should be "struct pinctrl *"
 *   dev: should be "struct udevice *"
 * @num_chipselect:
 * @cs_gpios:
 */

/*
 * spifc driver will use the default clk81 rate 1666666666
 * if without following platform callbacks.
	static void* spifc_clk_get(void *dev, char *name)
	{ return NULL; }
	static int spifc_clk_get_rate(void *clk)
	{ return 1666666666; }
	static int spifc_clk_enable(void *clk, bool enable)
	{ return 0; }
	static void* spifc_pinctrl_get(void *dev, char *name)
	{ return NULL; }
 */

struct spifc_platdata {
	ulong reg;
	ulong mem_map;
	void *(*clk_get)(void *dev, char *name);
	int (*clk_get_rate)(void *clk);
	int (*clk_enable)(void *clk, bool enable);
	void *(*pinctrl_get)(void *dev, char *name);
	int (*pinctrl_enable)(void *pinctrl, bool enable);
	int num_chipselect;
	int *cs_gpios;
};

#endif /* __SPIFC_H__ */