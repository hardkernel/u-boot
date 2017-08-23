/*
 * Set LPDDR3 frequency and DMC for Exynos5422
 *
 * Copyright (C) 2017 Joy Cho <joy.cho@hardkernel.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/clock.h>

#define DREXI_0		0x10C20000
#define DREXI_1		0x10C30000

static int set_cmu(int freq)
{
	struct exynos5420_clock *clk =
		(struct exynos5420_clock *)EXYNOS5_CLOCK_BASE;

	/* set BPLL_LOCK, BPLL_CON1 and BPLL_CON0 */
	switch (freq) {
	case 933:
		writel(0x00000320, &clk->bpll_lock);
		writel(0x0020F300, &clk->bpll_con1);
		writel(0x81370401, &clk->bpll_con0);
		break;
	case 825:
		writel(0x00000320, &clk->bpll_lock);
		writel(0x0020F300, &clk->bpll_con1);
		writel(0x81130401, &clk->bpll_con0);
		break;
	case 728:
		writel(0x00000258, &clk->bpll_lock);
		writel(0x0020F300, &clk->bpll_con1);
		writel(0x80B60301, &clk->bpll_con0);
		break;
	case 633:
		writel(0x00000320, &clk->bpll_lock);
		writel(0x0020F300, &clk->bpll_con1);
		writel(0x80D30401, &clk->bpll_con0);
		break;
	default:
		printf("no available frequency - %dMHz\n", freq);
		return 0;
	}

	/* check the 29th bit (LOCKED) to confirm PLL locking */
	while(!(readl(&clk->bpll_con0) & (0x1 << 29)));

	return 1;
}

static void set_dmc(int freq, u32 drex_addr)
{
	/* set TIMINGROW0, TIMINGDATA0 and TIMINGPOWER0 */
	switch (freq) {
	case 933:
		writel(0x3D6BA816, drex_addr+0x0034);
		writel(0x4742086E, drex_addr+0x0038);
		writel(0x60670447, drex_addr+0x003C);
		break;
	case 825:
		writel(0x365A9713, drex_addr+0x0034);
		writel(0x4740085E, drex_addr+0x0038);
		writel(0x543A0446, drex_addr+0x003C);
		break;
	case 728:
		writel(0x30598651, drex_addr+0x0034);
		writel(0x3730085E, drex_addr+0x0038);
		writel(0x4C330336, drex_addr+0x003C);
		break;
	case 633:
		writel(0x2A48758F, drex_addr+0x0034);
		writel(0x3730085E, drex_addr+0x0038);
		writel(0x402D0335, drex_addr+0x003C);
		break;
	default:
		printf("no available frequency - %dMHz\n", freq);
		break;
	}
}

static int do_dmc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int freq;

	if (argc != 2)
		return cmd_usage(cmdtp);
	else
		freq = simple_strtoul(argv[1], NULL, 10);

	if (!set_cmu(freq))
		return cmd_usage(cmdtp);

	set_dmc(freq, DREXI_0);
	set_dmc(freq, DREXI_1);

	return 0;
}

U_BOOT_CMD(
	dmc,	2,	0,	do_dmc,
	"Set LPDDR3 clock",
	"dmc <lpddr3 frequency>\n"
	"ex) dmc 933\n"
	"lpddr3 frequency list - 933/825/728/633\n");
