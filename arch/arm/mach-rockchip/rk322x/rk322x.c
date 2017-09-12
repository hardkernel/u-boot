/*
 * Copyright (c) 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <asm/io.h>
#include <asm/arch/hardware.h>

#define GRF_SOC_CON2	0x11000408
#define GRF_CON_IOMUX	0x11000050
#define CRU_MISC_CON	0x110e0134

int arch_cpu_init(void)
{
	/* We do some SoC one time setting here. */

	/* PWMs select rkpwm clock source */
	rk_setreg(GRF_SOC_CON2, 1 << 0);

	/* PWM0~3 io select */
	rk_setreg(GRF_CON_IOMUX, 0xf << 0);

	/* UART1~2 io select */
	rk_setreg(GRF_CON_IOMUX, (1 << 11) | (1 << 8));

	/* HDMI phy clock source select HDMIPHY clock out */
	rk_clrreg(CRU_MISC_CON, 1 << 13);

	/* TODO: ECO version */

	return 0;
}
