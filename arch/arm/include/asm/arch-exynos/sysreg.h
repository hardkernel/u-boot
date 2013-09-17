/*
 * Copyright (c) 2012 Samsung Electronics Co., Ltd.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#ifndef __ASM_ARM_ARCH_SYSREG_H_
#define __ASM_ARM_ARCH_SYSREG_H_

#ifndef __ASSEMBLY__
struct exynos5_sysreg {
	unsigned char	res1[0x0214];
	unsigned int	disp1blk_cfg;
	unsigned int	dispblk_cfg2;
	unsigned int	hdcp_e_fuse_mem_cfg;
	unsigned int	gsclblk_cfg0;
	unsigned int	gsclblk_cfg1;
	unsigned char   res2[0x4];
	unsigned int	ispblk_cfg;
	unsigned int	usb20phy_cfg;
	unsigned int	i2c_cfg;
	unsigned int	mipi_dphy;
	unsigned int	dptx_phy;
	unsigned int	phyclk_sel;
	unsigned int	gsclblk_cfg2;
	unsigned char	res3[0xdffc];
};
#endif

#endif
