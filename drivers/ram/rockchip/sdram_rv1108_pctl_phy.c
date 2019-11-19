/*
 * Copyright (C) 2018 Rockchip Electronics Co., Ltd
 * Author: Zhihuan He <huan.he@rock-chips.com>
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <common.h>
#include <dm.h>
#include <dm/root.h>
#include <dt-structs.h>
#include <ram.h>
#include <regmap.h>
#include <asm/io.h>
#include <asm/types.h>
#include <asm/arch/hardware.h>
#include <asm/arch/sdram_rv1108_pctl_phy.h>
#include <asm/arch/timer.h>
#include <asm/arch/sdram.h>

#if defined(CONFIG_ROCKCHIP_RV1108)
#include <asm/arch/sdram_rv1108.h>
#elif defined(CONFIG_ROCKCHIP_RK3308)
#include <asm/arch/sdram_rk3308.h>
#endif

/*
 * we can not fit the code to access the device tree in SPL
 * (due to 6K SRAM size limits), so these are hard-coded
 */

static void copy_to_reg(u32 *dest, const u32 *src, u32 n)
{
	int i;

	for (i = 0; i < n / sizeof(u32); i++) {
		writel(*src, dest);
		src++;
		dest++;
	}
}

static void phy_pctrl_reset(struct dram_info *priv)
{
	phy_pctrl_reset_cru(priv);
	clrsetbits_le32(&priv->phy->phy_reg0,
			RESET_DIGITAL_CORE_MASK | RESET_ANALOG_LOGIC_MASK,
			RESET_DIGITAL_CORE_ACT << RESET_DIGITAL_CORE_SHIFT |
			RESET_ANALOG_LOGIC_ACT << RESET_ANALOG_LOGIC_SHIFT);
	udelay(1);
	clrsetbits_le32(&priv->phy->phy_reg0,
			RESET_ANALOG_LOGIC_MASK,
			RESET_ANALOG_LOGIC_DIS << RESET_ANALOG_LOGIC_SHIFT);
	udelay(5);
	clrsetbits_le32(&priv->phy->phy_reg0,
			RESET_DIGITAL_CORE_MASK,
			RESET_DIGITAL_CORE_DIS << RESET_DIGITAL_CORE_SHIFT);
	udelay(1);
}

static void phy_dll_bypass_set(struct dram_info *priv, unsigned int freq)
{
	clrsetbits_le32(&priv->phy->phy_reg13, CMD_DLL_BYPASS_MASK,
			CMD_DLL_BYPASS << CMD_DLL_BYPASS_SHIFT);

	writel(CK_DLL_BYPASS_DISABLE << CK_DLL_BYPASS_SHIFT,
	       &priv->phy->phy_reg14);

	clrsetbits_le32(&priv->phy->phy_reg26, LEFT_CHN_A_DQ_DLL_BYPASS_MASK,
			LEFT_CHN_A_DQ_DLL_BYPASS << LEFT_CHN_A_DQ_DLL_SHIFT);
	writel(LEFT_CHN_A_DQS_DLL_BYPASS_DIS <<
	       LEFT_CHN_A_DQS_DLL_SHIFT, &priv->phy->phy_reg27);

	clrsetbits_le32(&priv->phy->phy_reg36, RIGHT_CHN_A_DQ_DLL_BYPASS_MASK,
			RIGHT_CHN_A_DQ_DLL_BYPASS <<
			RIGHT_CHN_A_DQ_DLL_SHIFT);
	writel(RIGHT_CHN_A_DQS_DLL_BYPASS_DIS <<
	       RIGHT_CHN_A_DQS_DLL_SHIFT, &priv->phy->phy_reg37);

	if (freq <= PHY_LOW_SPEED_MHZ) {
		writel(RIGHT_CHN_A_TX_DQ_BYPASS_SET <<
		       RIGHT_CHN_A_TX_DQ_BYPASS_SHIFT |
		       LEFT_CHN_A_TX_DQ_BYPASS_SET <<
		       LEFT_CHN_A_TX_DQ_BYPASS_SHIFT |
		       CMD_CK_DLL_BYPASS_SET << CMD_CK_DLL_BYPASS_SHIFT,
		       &priv->phy->phy_regdll);
	} else {
		writel(RIGHT_CHN_A_TX_DQ_BYPASS_DIS <<
		       RIGHT_CHN_A_TX_DQ_BYPASS_SHIFT |
		       LEFT_CHN_A_TX_DQ_BYPASS_DIS <<
		       LEFT_CHN_A_TX_DQ_BYPASS_SHIFT |
		       CMD_CK_DLL_BYPASS_DIS << CMD_CK_DLL_BYPASS_SHIFT,
				&priv->phy->phy_regdll);
	}

	/* 45 degree delay */
	writel(LEFT_CHN_A_READ_DQS_45_DELAY, &priv->phy->phy_reg28);
	writel(RIGHT_CHN_A_READ_DQS_45_DELAY, &priv->phy->phy_reg38);
}

static void send_command(struct dram_info *priv,
			 u32 rank, u32 cmd, u32 arg)
{
	writel((START_CMD | (rank << RANK_SEL_SHIFT) | arg | cmd),
	       &priv->pctl->mcmd);
	while (readl(&priv->pctl->mcmd) & START_CMD)
		;
}

static void memory_init(struct dram_info *priv,
			struct sdram_params *params_priv)
{
	send_command(priv, RANK_SEL_CS0_CS1, DESELECT_CMD, 0);
	udelay(1);
	send_command(priv, RANK_SEL_CS0_CS1, PREA_CMD, 0);

	send_command(priv, RANK_SEL_CS0_CS1, DESELECT_CMD, 0);
	udelay(1);
	send_command(priv, RANK_SEL_CS0_CS1, MRS_CMD,
		     (MR2 & BANK_ADDR_MASK) << BANK_ADDR_SHIFT |
		     (params_priv->ddr_timing_t.phy_timing.mr[2] &
		     CMD_ADDR_MASK) << CMD_ADDR_SHIFT);

	send_command(priv, RANK_SEL_CS0_CS1, MRS_CMD,
		     (MR3 & BANK_ADDR_MASK) << BANK_ADDR_SHIFT |
		     (params_priv->ddr_timing_t.phy_timing.mr[3] &
		     CMD_ADDR_MASK) << CMD_ADDR_SHIFT);

	send_command(priv, RANK_SEL_CS0_CS1, MRS_CMD,
		     (MR1 & BANK_ADDR_MASK) << BANK_ADDR_SHIFT |
		     (params_priv->ddr_timing_t.phy_timing.mr[1] &
		     CMD_ADDR_MASK) << CMD_ADDR_SHIFT);

	send_command(priv, RANK_SEL_CS0_CS1, MRS_CMD,
		     (MR0 & BANK_ADDR_MASK) << BANK_ADDR_SHIFT |
		     (params_priv->ddr_timing_t.phy_timing.mr[0] &
		     CMD_ADDR_MASK) << CMD_ADDR_SHIFT | DDR3_DLL_RESET);

	send_command(priv, RANK_SEL_CS0_CS1, ZQCL_CMD, 0);
}

static void set_bw(struct dram_info *priv,
		   struct sdram_params *params_priv)
{
	if (readl(&params_priv->ddr_config.bw) == 1) {
		clrsetbits_le32(&priv->pctl->ppcfg, PPMEM_EN_MASK, PPMEM_EN);
		clrsetbits_le32(&priv->phy->phy_reg0, DQ_16BIT_EN_MASK,
				DQ_16BIT_EN);
		set_bw_grf(priv);
		clrsetbits_le32(&priv->service_msch->ddrtiming,
				BWRATIO_HALF_BW, BWRATIO_HALF_BW);
	}
}

static void move_to_config_state(struct dram_info *priv)
{
	unsigned int state;

	while (1) {
		state = readl(&priv->pctl->stat) & PCTL_CTL_STAT_MASK;
		switch (state) {
		case LOW_POWER:
			writel(WAKEUP_STATE, &priv->pctl->sctl);
			while ((readl(&priv->pctl->stat) & PCTL_CTL_STAT_MASK)
				!= ACCESS)
				;
			/*
			 * If at low power state, need wakeup first, and then
			 * enter the config, so fallthrough
			 */
		case ACCESS:
		case INIT_MEM:
			writel(CFG_STATE, &priv->pctl->sctl);
			while ((readl(&priv->pctl->stat) & PCTL_CTL_STAT_MASK)
				!= CONFIG)
				;
			break;
		case CONFIG:
			return;
		default:
			break;
		}
	}
}

static void move_to_access_state(struct dram_info *priv)
{
	unsigned int state;

	while (1) {
		state = readl(&priv->pctl->stat) & PCTL_CTL_STAT_MASK;
		switch (state) {
		case LOW_POWER:
			writel(WAKEUP_STATE, &priv->pctl->sctl);
			while ((readl(&priv->pctl->stat) &
				PCTL_CTL_STAT_MASK) != ACCESS)
				;
			break;
		case INIT_MEM:
			writel(CFG_STATE, &priv->pctl->sctl);
			while ((readl(&priv->pctl->stat) &
				PCTL_CTL_STAT_MASK) != CONFIG)
				;
			/* fallthrough */
		case CONFIG:
			writel(GO_STATE, &priv->pctl->sctl);
			while ((readl(&priv->pctl->stat) &
				PCTL_CTL_STAT_MASK) != ACCESS)
				;
			break;
		case ACCESS:
			return;
		default:
			break;
		}
	}
}

static void pctl_cfg(struct dram_info *priv,
		     struct sdram_params *params_priv)
{
	u32 reg;

	/* DFI config */
	writel(DFI_DATA_BYTE_DISABLE_EN << DFI_DATA_BYTE_DISABLE_EN_SHIFT |
	       DFI_INIT_START_EN << DFI_INIT_START_SHIFT,
	       &priv->pctl->dfistcfg0);
	writel(DFI_DRAM_CLK_DISABLE_EN_DPD <<
	       DFI_DRAM_CLK_DISABLE_EN_DPD_SHIFT |
	       DFI_DRAM_CLK_DISABLE_EN << DFI_DRAM_CLK_DISABLE_EN_SHIFT,
	       &priv->pctl->dfistcfg1);
	writel(PARITY_EN << PARITY_EN_SHIFT |
	       PARITY_INTR_EN << PARITY_INTR_EN_SHIFT, &priv->pctl->dfistcfg2);
	writel(DFI_LP_EN_SR << DFI_LP_EN_SR_SHIFT |
	       DFI_LP_WAKEUP_SR_32_CYCLES << DFI_LP_WAKEUP_SR_SHIFT |
	       DFI_TLP_RESP << DFI_TLP_RESP_SHIFT,
	       &priv->pctl->dfilpcfg0);

	writel(TPHYUPD_TYPE0, &priv->pctl->dfitphyupdtype0);
	writel(TPHY_RDLAT, &priv->pctl->dfitphyrdlat);
	writel(TPHY_WRDATA, &priv->pctl->dfitphywrdata);

	writel(DFI_PHYUPD_DISABLE | DFI_CTRLUPD_DISABLE,
	       &priv->pctl->dfiupdcfg);

	copy_to_reg(&priv->pctl->togcnt1u,
		    &(params_priv->ddr_timing_t.pctl_timing.togcnt1u),
		    sizeof(struct pctl_timing));

	writel((RANK0_ODT_WRITE_SEL << RANK0_ODT_WRITE_SEL_SHIFT |
	       RANK1_ODT_WRITE_SEL << RANK1_ODT_WRITE_SEL_SHIFT),
	       &priv->pctl->dfiodtcfg);

	writel(ODT_LEN_BL8_W << ODT_LEN_BL8_W_SHIFT,
	       &priv->pctl->dfiodtcfg1);

	reg = readl(&priv->pctl->tcl);
	writel((reg - 1) / 2 - 1, &priv->pctl->dfitrddataen);
	reg = readl(&priv->pctl->tcwl);
	writel((reg - 1) / 2 - 1, &priv->pctl->dfitphywrlat);

	writel(params_priv->ddr_timing_t.pctl_timing.trsth, &priv->pctl->trsth);
	writel(MDDR_LPDDR23_CLOCK_STOP_IDLE_DIS | DDR3_EN | MEM_BL_8 |
	       TFAW_CFG_5_TDDR | PD_EXIT_SLOW_EXIT_MODE |
	       PD_TYPE_ACT_PD | PD_IDLE_DISABLE, &priv->pctl->mcfg);

	pctl_cfg_grf(priv);
	setbits_le32(&priv->pctl->scfg, HW_LOW_POWER_EN);
}

static void phy_cfg(struct dram_info *priv,
		    struct sdram_params *params_priv)
{
	writel((readl(&priv->service_msch->ddrtiming) & BWRATIO_HALF_BW)|
	       params_priv->ddr_timing_t.noc_timing,
	       &priv->service_msch->ddrtiming);
	writel(params_priv->ddr_timing_t.readlatency,
	       &priv->service_msch->readlatency);
	writel(params_priv->ddr_timing_t.activate,
	       &priv->service_msch->activate);
	writel(params_priv->ddr_timing_t.devtodev,
	       &priv->service_msch->devtodev);

	writel(MEMORY_SELECT_DDR3 | PHY_BL_8, &priv->phy->phy_reg1);

	writel(params_priv->ddr_timing_t.phy_timing.cl_al,
	       &priv->phy->phy_regb);
	writel(params_priv->ddr_timing_t.pctl_timing.tcwl,
	       &priv->phy->phy_regc);

	writel(PHY_RON_RTT_34OHM, &priv->phy->phy_reg11);
	clrsetbits_le32(&priv->phy->phy_reg12, CMD_PRCOMP_MASK,
			PHY_RON_RTT_34OHM << CMD_PRCOMP_SHIFT);
	writel(PHY_RON_RTT_45OHM, &priv->phy->phy_reg16);
	writel(PHY_RON_RTT_45OHM, &priv->phy->phy_reg18);
	writel(PHY_RON_RTT_34OHM, &priv->phy->phy_reg20);
	writel(PHY_RON_RTT_34OHM, &priv->phy->phy_reg2f);
	writel(PHY_RON_RTT_34OHM, &priv->phy->phy_reg30);
	writel(PHY_RON_RTT_34OHM, &priv->phy->phy_reg3f);
	writel(PHY_RON_RTT_225OHM, &priv->phy->phy_reg21);
	writel(PHY_RON_RTT_225OHM, &priv->phy->phy_reg2e);
	writel(PHY_RON_RTT_225OHM, &priv->phy->phy_reg31);
	writel(PHY_RON_RTT_225OHM, &priv->phy->phy_reg3e);
}

static void dram_cfg_rbc(struct dram_info *priv,
			 struct sdram_params *params_priv)
{
	int i = 0;

	move_to_config_state(priv);
#if defined(CONFIG_ROCKCHIP_RV1108)
	if (params_priv->ddr_config.col == 10)
		i = 2;
	else
		i = 3;
#elif defined(CONFIG_ROCKCHIP_RK3308)

#endif
	writel(i, &priv->service_msch->ddrconf);
	move_to_access_state(priv);
}

static void enable_low_power(struct dram_info *priv)
{
	move_to_config_state(priv);

	clrsetbits_le32(&priv->pctl->mcfg, PD_IDLE_MASK,
			PD_IDLE << PD_IDLE_SHIFT);
	clrsetbits_le32(&priv->pctl->mcfg1, SR_IDLE_MASK | HW_EXIT_IDLE_EN_MASK,
			SR_IDLE | HW_EXIT_IDLE_EN);

	/* uPCTL in low_power status because of auto self-refreh */
	writel(GO_STATE, &priv->pctl->sctl);
}

static void data_training(struct dram_info *priv)
{
	u32 value;
	u32 tmp = 0;

	/* disable auto refresh */
	value = readl(&priv->pctl->trefi);
	writel(UPD_REF, &priv->pctl->trefi);

	writel(DQS_GATE_TRAINING_SEL_CS0 | DQS_GATE_TRAINING_DIS,
	       &priv->phy->phy_reg2);
	writel(DQS_GATE_TRAINING_SEL_CS0 | DQS_GATE_TRAINING_ACT,
	       &priv->phy->phy_reg2);

	/* delay untill data training done */
	while (tmp != (CHN_A_HIGH_8BIT_TRAINING_DONE |
	       CHN_A_LOW_8BIT_TRAINING_DONE)) {
		udelay(1);
		tmp = (readl(&priv->phy->phy_regff) & CHN_A_TRAINING_DONE_MASK);
	}

	writel(DQS_GATE_TRAINING_SEL_CS0 | DQS_GATE_TRAINING_DIS,
	       &priv->phy->phy_reg2);

	send_command(priv, RANK_SEL_CS0_CS1, PREA_CMD, 0);

	writel(value | UPD_REF, &priv->pctl->trefi);
}

static u32 sdram_detect(struct dram_info *priv,
			struct sdram_params *params_priv)
{
	u32 row, col, row_max, col_max;
	u32 test_addr;

	move_to_config_state(priv);
#if defined(CONFIG_ROCKCHIP_RV1108)
	writel(1, &priv->service_msch->ddrconf);
	col_max = 11;
	row_max = 16;
#elif defined(CONFIG_ROCKCHIP_RK3308)

#endif
	move_to_access_state(priv);

	/* detect col */
	for (col = col_max; col >= 10; col--) {
		writel(0, SDRAM_BEGIN_ADDR);
		test_addr = SDRAM_BEGIN_ADDR + (1u << (col +
				params_priv->ddr_config.bw - 1u));
		writel(PATTERN, test_addr);
		if ((readl(test_addr) == PATTERN) &&
		    (readl(SDRAM_BEGIN_ADDR) == 0))
				break;
	}
	if (col <= 8)
		goto cap_err;
	params_priv->ddr_config.col = col;

	/* detect row */
	col = col_max;
	for (row = row_max; row >= 12; row--) {
		writel(0, SDRAM_BEGIN_ADDR);
		test_addr = SDRAM_BEGIN_ADDR + (1u << (row +
				params_priv->ddr_config.bank + col +
				params_priv->ddr_config.bw - 1u));
		writel(PATTERN, test_addr);
		if ((readl(test_addr) == PATTERN) &&
		    (readl(SDRAM_BEGIN_ADDR) == 0))
			break;
	}
	if (row <= 11)
		goto cap_err;
	params_priv->ddr_config.cs0_row = row;
	return 0;
cap_err:
	return 1;
}

static void sdram_all_config(struct dram_info *priv,
			     struct sdram_params *params_priv)
{
	u32 os_reg = 0;
	u32 cs1_row = 0;

	if (params_priv->ddr_config.rank > 1)
		cs1_row = params_priv->ddr_config.cs1_row - 13;

	os_reg = params_priv->ddr_config.ddr_type << SYS_REG_DDRTYPE_SHIFT |
		 params_priv->ddr_config.chn_cnt << SYS_REG_NUM_CH_SHIFT |
		 (params_priv->ddr_config.rank - 1) << SYS_REG_RANK_SHIFT(0) |
		 (params_priv->ddr_config.col - 9) << SYS_REG_COL_SHIFT(0) |
		 (params_priv->ddr_config.bank == 3 ? 0 : 1) <<
		 SYS_REG_BK_SHIFT(0) |
		 (params_priv->ddr_config.cs0_row - 13) <<
		 SYS_REG_CS0_ROW_SHIFT(0) |
		 cs1_row << SYS_REG_CS1_ROW_SHIFT(0) |
		 params_priv->ddr_config.bw << SYS_REG_BW_SHIFT(0) |
		 params_priv->ddr_config.dbw << SYS_REG_DBW_SHIFT(0);

	writel(os_reg, &priv->grf->os_reg2);
}

int rv1108_sdram_init(struct dram_info *sdram_priv,
		      struct sdram_params *params_priv)
{
	/* pmu enable ddr io retention */
	enable_ddr_io_ret(sdram_priv);
	rkdclk_init(sdram_priv, params_priv);
	phy_pctrl_reset(sdram_priv);
	phy_dll_bypass_set(sdram_priv, params_priv->ddr_timing_t.freq);
	pctl_cfg(sdram_priv, params_priv);
	phy_cfg(sdram_priv, params_priv);

	writel(POWER_UP_START, &sdram_priv->pctl->powctl);
	while (!(readl(&sdram_priv->pctl->powstat) & POWER_UP_DONE))
		;

	memory_init(sdram_priv, params_priv);
	move_to_config_state(sdram_priv);
	set_bw(sdram_priv, params_priv);
	data_training(sdram_priv);
	move_to_access_state(sdram_priv);
	if (sdram_detect(sdram_priv, params_priv)) {
		while (1)
			;
	}
	dram_cfg_rbc(sdram_priv, params_priv);
	sdram_all_config(sdram_priv, params_priv);
	enable_low_power(sdram_priv);

	return 0;
}
