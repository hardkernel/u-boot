/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * Copyright (C) 2020 Rockchip Electronics Co., Ltd
 */

#ifndef _ASM_ARCH_SDRAM_RK1126_H
#define _ASM_ARCH_SDRAM_RK1126_H

#include <asm/arch/dram_spec_timing.h>
#include <asm/arch/sdram.h>
#include <asm/arch/sdram_common.h>
#include <asm/arch/sdram_msch.h>
#include <asm/arch/sdram_pctl_px30.h>
#include <asm/arch/sdram_phy_rv1126.h>

#define AGINGX0_VAL			(4)
#define AGING_CPU_VAL			(0xff)
#define AGING_NPU_VAL			(0xff)
#define AGING_OTHER_VAL			(0x33)

#define PATTERN				(0x5aa5f00f)
#define PHY_PER_DE_SKEW_DELAY		(20)
#define PHY_RX_DQS_INNER_DELAY		(5)

#define PHY_DDR3_RON_DISABLE		(0)
#define PHY_DDR3_RON_506ohm		(1)
#define PHY_DDR3_RON_253ohm		(2)
#define PHY_DDR3_RON_169hm		(3)
#define PHY_DDR3_RON_127ohm		(4)
#define PHY_DDR3_RON_101ohm		(5)
#define PHY_DDR3_RON_84ohm		(6)
#define PHY_DDR3_RON_72ohm		(7)
#define PHY_DDR3_RON_63ohm		(16)
#define PHY_DDR3_RON_56ohm		(17)
#define PHY_DDR3_RON_51ohm		(18)
#define PHY_DDR3_RON_46ohm		(19)
#define PHY_DDR3_RON_42ohm		(20)
#define PHY_DDR3_RON_39ohm		(21)
#define PHY_DDR3_RON_36ohm		(22)
#define PHY_DDR3_RON_34ohm		(23)
#define PHY_DDR3_RON_32ohm		(24)
#define PHY_DDR3_RON_30ohm		(25)
#define PHY_DDR3_RON_28ohm		(26)
#define PHY_DDR3_RON_27ohm		(27)
#define PHY_DDR3_RON_25ohm		(28)
#define PHY_DDR3_RON_24ohm		(29)
#define PHY_DDR3_RON_23ohm		(30)
#define PHY_DDR3_RON_22ohm		(31)

#define PHY_DDR3_RTT_DISABLE		(0)
#define PHY_DDR3_RTT_953ohm		(1)
#define PHY_DDR3_RTT_483ohm		(2)
#define PHY_DDR3_RTT_320ohm		(3)
#define PHY_DDR3_RTT_241ohm		(4)
#define PHY_DDR3_RTT_193ohm		(5)
#define PHY_DDR3_RTT_161ohm		(6)
#define PHY_DDR3_RTT_138ohm		(7)
#define PHY_DDR3_RTT_121ohm		(16)
#define PHY_DDR3_RTT_107ohm		(17)
#define PHY_DDR3_RTT_97ohm		(18)
#define PHY_DDR3_RTT_88ohm		(19)
#define PHY_DDR3_RTT_80ohm		(20)
#define PHY_DDR3_RTT_74ohm		(21)
#define PHY_DDR3_RTT_69ohm		(22)
#define PHY_DDR3_RTT_64ohm		(23)
#define PHY_DDR3_RTT_60ohm		(24)
#define PHY_DDR3_RTT_57ohm		(25)
#define PHY_DDR3_RTT_54ohm		(26)
#define PHY_DDR3_RTT_51ohm		(27)
#define PHY_DDR3_RTT_48ohm		(28)
#define PHY_DDR3_RTT_46ohm		(29)
#define PHY_DDR3_RTT_44ohm		(30)
#define PHY_DDR3_RTT_42ohm		(31)

#define PHY_DDR4_LPDDR3_RON_DISABLE	(0)
#define PHY_DDR4_LPDDR3_RON_570ohm	(1)
#define PHY_DDR4_LPDDR3_RON_285ohm	(2)
#define PHY_DDR4_LPDDR3_RON_190ohm	(3)
#define PHY_DDR4_LPDDR3_RON_142ohm	(4)
#define PHY_DDR4_LPDDR3_RON_114ohm	(5)
#define PHY_DDR4_LPDDR3_RON_95ohm	(6)
#define PHY_DDR4_LPDDR3_RON_81ohm	(7)
#define PHY_DDR4_LPDDR3_RON_71ohm	(16)
#define PHY_DDR4_LPDDR3_RON_63ohm	(17)
#define PHY_DDR4_LPDDR3_RON_57ohm	(18)
#define PHY_DDR4_LPDDR3_RON_52ohm	(19)
#define PHY_DDR4_LPDDR3_RON_47ohm	(20)
#define PHY_DDR4_LPDDR3_RON_44ohm	(21)
#define PHY_DDR4_LPDDR3_RON_41ohm	(22)
#define PHY_DDR4_LPDDR3_RON_38ohm	(23)
#define PHY_DDR4_LPDDR3_RON_36ohm	(24)
#define PHY_DDR4_LPDDR3_RON_34ohm	(25)
#define PHY_DDR4_LPDDR3_RON_32ohm	(26)
#define PHY_DDR4_LPDDR3_RON_30ohm	(27)
#define PHY_DDR4_LPDDR3_RON_28ohm	(28)
#define PHY_DDR4_LPDDR3_RON_27ohm	(29)
#define PHY_DDR4_LPDDR3_RON_26ohm	(30)
#define PHY_DDR4_LPDDR3_RON_25ohm	(31)

#define PHY_DDR4_LPDDR3_RTT_DISABLE	(0)
#define PHY_DDR4_LPDDR3_RTT_973ohm	(1)
#define PHY_DDR4_LPDDR3_RTT_493ohm	(2)
#define PHY_DDR4_LPDDR3_RTT_327ohm	(3)
#define PHY_DDR4_LPDDR3_RTT_247ohm	(4)
#define PHY_DDR4_LPDDR3_RTT_197ohm	(5)
#define PHY_DDR4_LPDDR3_RTT_164ohm	(6)
#define PHY_DDR4_LPDDR3_RTT_141ohm	(7)
#define PHY_DDR4_LPDDR3_RTT_123ohm	(16)
#define PHY_DDR4_LPDDR3_RTT_109ohm	(17)
#define PHY_DDR4_LPDDR3_RTT_99ohm	(18)
#define PHY_DDR4_LPDDR3_RTT_90ohm	(19)
#define PHY_DDR4_LPDDR3_RTT_82ohm	(20)
#define PHY_DDR4_LPDDR3_RTT_76ohm	(21)
#define PHY_DDR4_LPDDR3_RTT_70ohm	(22)
#define PHY_DDR4_LPDDR3_RTT_66ohm	(23)
#define PHY_DDR4_LPDDR3_RTT_62ohm	(24)
#define PHY_DDR4_LPDDR3_RTT_58ohm	(25)
#define PHY_DDR4_LPDDR3_RTT_55ohm	(26)
#define PHY_DDR4_LPDDR3_RTT_52ohm	(27)
#define PHY_DDR4_LPDDR3_RTT_49ohm	(28)
#define PHY_DDR4_LPDDR3_RTT_47ohm	(29)
#define PHY_DDR4_LPDDR3_RTT_45ohm	(30)
#define PHY_DDR4_LPDDR3_RTT_43ohm	(31)

#define PHY_LPDDR4_RON_DISABLE		(0)
#define PHY_LPDDR4_RON_606ohm		(1)
#define PHY_LPDDR4_RON_303ohm		(2)
#define PHY_LPDDR4_RON_202ohm		(3)
#define PHY_LPDDR4_RON_152ohm		(4)
#define PHY_LPDDR4_RON_121ohm		(5)
#define PHY_LPDDR4_RON_101ohm		(6)
#define PHY_LPDDR4_RON_87ohm		(7)
#define PHY_LPDDR4_RON_76ohm		(16)
#define PHY_LPDDR4_RON_67ohm		(17)
#define PHY_LPDDR4_RON_61ohm		(18)
#define PHY_LPDDR4_RON_55ohm		(19)
#define PHY_LPDDR4_RON_51ohm		(20)
#define PHY_LPDDR4_RON_47ohm		(21)
#define PHY_LPDDR4_RON_43ohm		(22)
#define PHY_LPDDR4_RON_40ohm		(23)
#define PHY_LPDDR4_RON_38ohm		(24)
#define PHY_LPDDR4_RON_36ohm		(25)
#define PHY_LPDDR4_RON_34ohm		(26)
#define PHY_LPDDR4_RON_32ohm		(27)
#define PHY_LPDDR4_RON_30ohm		(28)
#define PHY_LPDDR4_RON_29ohm		(29)
#define PHY_LPDDR4_RON_28ohm		(30)
#define PHY_LPDDR4_RON_26ohm		(31)

#define PHY_LPDDR4_RTT_DISABLE		(0)
#define PHY_LPDDR4_RTT_998ohm		(1)
#define PHY_LPDDR4_RTT_506ohm		(2)
#define PHY_LPDDR4_RTT_336ohm		(3)
#define PHY_LPDDR4_RTT_253ohm		(4)
#define PHY_LPDDR4_RTT_202ohm		(5)
#define PHY_LPDDR4_RTT_169ohm		(6)
#define PHY_LPDDR4_RTT_144ohm		(7)
#define PHY_LPDDR4_RTT_127ohm		(16)
#define PHY_LPDDR4_RTT_112ohm		(17)
#define PHY_LPDDR4_RTT_101ohm		(18)
#define PHY_LPDDR4_RTT_92ohm		(19)
#define PHY_LPDDR4_RTT_84ohm		(20)
#define PHY_LPDDR4_RTT_78ohm		(21)
#define PHY_LPDDR4_RTT_72ohm		(22)
#define PHY_LPDDR4_RTT_67ohm		(23)
#define PHY_LPDDR4_RTT_63ohm		(24)
#define PHY_LPDDR4_RTT_60ohm		(25)
#define PHY_LPDDR4_RTT_56ohm		(26)
#define PHY_LPDDR4_RTT_53ohm		(27)
#define PHY_LPDDR4_RTT_51ohm		(28)
#define PHY_LPDDR4_RTT_48ohm		(29)
#define PHY_LPDDR4_RTT_46ohm		(30)
#define PHY_LPDDR4_RTT_44ohm		(31)

#define ADD_CMD_CA			(0x150)
#define ADD_GROUP_CS0_A			(0x170)
#define ADD_GROUP_CS0_B			(0x1d0)
#define ADD_GROUP_CS1_A			(0x1a0)
#define ADD_GROUP_CS1_B			(0x200)

/* PMUGRF */
#define PMUGRF_OS_REG0			(0x200)
#define PMUGRF_OS_REG(n)		(PMUGRF_OS_REG0 + (n) * 4)
#define PMUGRF_CON_DDRPHY_BUFFEREN_MASK		(0x3 << (12 + 16))
#define PMUGRF_CON_DDRPHY_BUFFEREN_EN		(0x1 << 12)
#define PMUGRF_CON_DDRPHY_BUFFEREN_DIS	(0x2 << 12)

/* DDR GRF */
#define DDR_GRF_CON(n)			(0 + (n) * 4)
#define DDR_GRF_STATUS_BASE		(0X100)
#define DDR_GRF_STATUS(n)		(DDR_GRF_STATUS_BASE + (n) * 4)
#define DDR_GRF_LP_CON			(0x20)

#define SPLIT_MODE_32_L16_VALID		(0)
#define SPLIT_MODE_32_H16_VALID		(1)
#define SPLIT_MODE_16_L8_VALID		(2)
#define SPLIT_MODE_16_H8_VALID		(3)

#define DDR_GRF_SPLIT_CON		(0x10)
#define SPLIT_MODE_MASK			(0x3)
#define SPLIT_MODE_OFFSET		(9)
#define SPLIT_BYPASS_MASK		(1)
#define SPLIT_BYPASS_OFFSET		(8)
#define SPLIT_SIZE_MASK			(0xff)
#define SPLIT_SIZE_OFFSET		(0)

/* SGRF SOC_CON13 */
#define UPCTL2_ASRSTN_REQ(n)		(((0x1 << 0) << 16) | ((n) << 0))
#define UPCTL2_PSRSTN_REQ(n)		(((0x1 << 1) << 16) | ((n) << 1))
#define UPCTL2_SRSTN_REQ(n)		(((0x1 << 2) << 16) | ((n) << 2))

/* CRU define */
/* CRU_PLL_CON0 */
#define PB(n)				((0x1 << (15 + 16)) | ((n) << 15))
#define POSTDIV1(n)			((0x7 << (12 + 16)) | ((n) << 12))
#define FBDIV(n)			((0xFFF << 16) | (n))

/* CRU_PLL_CON1 */
#define RSTMODE(n)			((0x1 << (15 + 16)) | ((n) << 15))
#define RST(n)				((0x1 << (14 + 16)) | ((n) << 14))
#define PD(n)				((0x1 << (13 + 16)) | ((n) << 13))
#define DSMPD(n)			((0x1 << (12 + 16)) | ((n) << 12))
#define LOCK(n)				(((n) >> 10) & 0x1)
#define POSTDIV2(n)			((0x7 << (6 + 16)) | ((n) << 6))
#define REFDIV(n)			((0x3F << 16) | (n))

/* CRU_MODE */
#define CLOCK_FROM_XIN_OSC		(0)
#define CLOCK_FROM_PLL			(1)
#define CLOCK_FROM_RTC_32K		(2)
#define DPLL_MODE(n)			((0x3 << (2 + 16)) | ((n) << 2))

/* CRU_SOFTRESET_CON1 */
#define DDRPHY_PSRSTN_REQ(n)		(((0x1 << 14) << 16) | ((n) << 14))
#define DDRPHY_SRSTN_REQ(n)		(((0x1 << 15) << 16) | ((n) << 15))
/* CRU_CLKGATE_CON2 */
#define DDR_MSCH_EN_MASK		((0x1 << 10) << 16)
#define DDR_MSCH_EN_SHIFT		(10)

/* CRU register */
#define CRU_PLL_CON(pll_id, n)		((pll_id)  * 0x20 + (n) * 4)
#define CRU_MODE			(0xa0)
#define CRU_GLB_CNT_TH			(0xb0)
#define CRU_CLKSEL_CON_BASE		0x100
#define CRU_CLKSELS_CON(i)		(CRU_CLKSEL_CON_BASE + ((i) * 4))
#define CRU_CLKGATE_CON_BASE		0x230
#define CRU_CLKGATE_CON(i)		(CRU_CLKGATE_CON_BASE + ((i) * 4))
#define CRU_CLKSFTRST_CON_BASE		0x300
#define CRU_CLKSFTRST_CON(i)		(CRU_CLKSFTRST_CON_BASE + ((i) * 4))

/* SGRF_SOC_CON12 */
#define CLK_DDR_UPCTL_EN_MASK		((0x1 << 2) << 16)
#define CLK_DDR_UPCTL_EN_SHIFT		(2)
#define ACLK_DDR_UPCTL_EN_MASK		((0x1 << 0) << 16)
#define ACLK_DDR_UPCTL_EN_SHIFT		(0)

/* DDRGRF DDR CON2 */
#define DFI_FREQ_CHANGE_ACK		BIT(10)
/* DDRGRF status8 */
#define DFI_FREQ_CHANGE_REQ		BIT(19)

struct rv1126_ddrgrf {
	u32 ddr_grf_con[4];
	u32 grf_ddrsplit_con;
	u32 reserved1[(0x20 - 0x10) / 4 - 1];
	u32 ddr_grf_lp_con;
	u32 reserved2[(0x40 - 0x20) / 4 - 1];
	u32 grf_ddrphy_con[6];
	u32 reserved3[(0x100 - 0x54) / 4 - 1];
	u32 ddr_grf_status[18];
	u32 reserved4[(0x150 - 0x144) / 4 - 1];
	u32 grf_ddrhold_status;
	u32 reserved5[(0x160 - 0x150) / 4 - 1];
	u32 grf_ddrphy_status[2];
};

struct rv1126_ddr_phy_regs {
	u32 phy[8][2];
};

struct msch_regs {
	u32 coreid;
	u32 revisionid;
	u32 deviceconf;
	u32 devicesize;
	u32 ddrtiminga0;
	u32 ddrtimingb0;
	u32 ddrtimingc0;
	u32 devtodev0;
	u32 reserved1[(0x110 - 0x20) / 4];
	u32 ddrmode;
	u32 ddr4timing;
	u32 reserved2[(0x1000 - 0x118) / 4];
	u32 agingx0;
	u32 reserved3[(0x1040 - 0x1004) / 4];
	u32 aging0;
	u32 aging1;
	u32 aging2;
	u32 aging3;
};

struct sdram_msch_timings {
	union noc_ddrtiminga0 ddrtiminga0;
	union noc_ddrtimingb0 ddrtimingb0;
	union noc_ddrtimingc0 ddrtimingc0;
	union noc_devtodev0 devtodev0;
	union noc_ddrmode ddrmode;
	union noc_ddr4timing ddr4timing;
	u32 agingx0;
	u32 aging0;
	u32 aging1;
	u32 aging2;
	u32 aging3;
};

struct rv1126_sdram_channel {
	struct sdram_cap_info cap_info;
	struct sdram_msch_timings noc_timings;
};

struct rv1126_sdram_params {
	struct rv1126_sdram_channel ch;
	struct sdram_base_params base;
	struct ddr_pctl_regs pctl_regs;
	struct rv1126_ddr_phy_regs phy_regs;
};

struct rv1126_fsp_param {
	u32 flag;
	u32 freq_mhz;

	/* dram size */
	u32 dq_odt;
	u32 ca_odt;
	u32 ds_pdds;
	u32 vref_ca[2];
	u32 vref_dq[2];

	/* phy side */
	u32 wr_dq_drv;
	u32 wr_ca_drv;
	u32 wr_ckcs_drv;
	u32 rd_odt;
	u32 rd_odt_up_en;
	u32 rd_odt_down_en;
	u32 vref_inner;
	u32 vref_out;
	u32 lp4_drv_pd_en;

	struct sdram_msch_timings noc_timings;
};

#define MAX_IDX			(4)
#define FSP_FLAG		(0xfead0001)
#define SHARE_MEM_BASE		(0x100000)
/*
 * Borrow share memory space to temporarily store FSP parame.
 * In the stage of DDR init write FSP parame to this space.
 * In the stage of trust init move FSP parame to SRAM space
 * from share memory space.
 */
#define FSP_PARAM_STORE_ADDR	(SHARE_MEM_BASE)

#endif /* _ASM_ARCH_SDRAM_RK1126_H */
