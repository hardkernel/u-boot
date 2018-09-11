
/*
 * drivers/vpu/aml_vpu.h
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

#ifndef __VPU_PARA_H__
#define __VPU_PARA_H__

//#define VPU_DEBUG_PRINT
#define VPUPR(fmt, args...)     printf("vpu: "fmt"", ## args)
#define VPUERR(fmt, args...)    printf("vpu: error: "fmt"", ## args)

enum vpu_chip_e {
	VPU_CHIP_GXBB = 0,
	VPU_CHIP_GXTVBB, /* 1 */
	VPU_CHIP_GXL, /* 2 */
	VPU_CHIP_GXM, /* 3 */
	VPU_CHIP_TXL, /* 4 */
	VPU_CHIP_TXLX, /* 5 */
	VPU_CHIP_AXG, /* 6 */
	VPU_CHIP_TXHD, /* 7 */
	VPU_CHIP_G12A, /* 8 */
	VPU_CHIP_G12B, /* 9 */
	VPU_CHIP_TL1, /* 10 */
	VPU_CHIP_MAX,
};

//extern enum vpu_chip_e vpu_chip_type;

#define VPU_REG_END            0xffff
#define VPU_MEM_PD_CNT_MAX     10
#define VPU_RESET_CNT_MAX      10

struct fclk_div_s {
	unsigned int fclk_id;
	unsigned int fclk_mux;
	unsigned int fclk_div;
};

struct vpu_clk_s {
	unsigned int freq;
	unsigned int mux;
	unsigned int div;
};

struct vpu_ctrl_s {
	unsigned int reg;
	unsigned int val;
	unsigned int bit;
	unsigned int len;
};

struct vpu_reset_s {
	unsigned int reg;
	unsigned int mask;
};

struct vpu_data_s {
	enum vpu_chip_e chip_type;
	const char *chip_name;
	unsigned char clk_level_dft;
	unsigned char clk_level_max;
	unsigned char gp_pll_valid;

	struct fclk_div_s *fclk_div_table;
	struct vpu_clk_s  *vpu_clk_table;

	struct vpu_ctrl_s *mem_pd_table;
	struct vpu_reset_s *reset_table;

	unsigned int module_init_table_cnt;
	struct vpu_ctrl_s *module_init_table;
};

struct vpu_conf_s {
	struct vpu_data_s *data;
	char drv_version[20];

	unsigned int clk_level;
	unsigned int fclk_freq; /* unit: MHz */
};

extern struct vpu_conf_s vpu_conf;

/* ************************************************ */
/* extern function */
/* ************************************************ */
extern void udelay(unsigned long usec);
extern int printf(const char *fmt, ...);
/* ************************************************ */

extern void vpu_mem_pd_init_off(void);
extern void vpu_module_init_config(void);

extern void vpu_power_on(void);
extern void vpu_power_off(void);

#endif
