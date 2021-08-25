// SPDX-License-Identifier:     GPL-2.0+
/*
 * (C) Copyright 2021 Rockchip Electronics Co., Ltd.
 */

#include <common.h>
#include <dm.h>
#include <syscon.h>
#include <asm/io.h>
#include <dm/of_access.h>
#include <asm/arch/clock.h>
#include <asm/arch/rockchip_smccc.h>
#include <asm/arch/sdram.h>
#include <asm/arch/sdram_common.h>

#define DDR2_PARAMS_PHANDLE_NAME		"ddr2_params"
#define DDR3_PARAMS_PHANDLE_NAME		"ddr3_params"
#define DDR4_PARAMS_PHANDLE_NAME		"ddr4_params"
#define LPDDR2_PARAMS_PHANDLE_NAME		"lpddr2_params"
#define LPDDR3_PARAMS_PHANDLE_NAME		"lpddr3_params"
#define LPDDR4_PARAMS_PHANDLE_NAME		"lpddr4_params"
#define LPDDR4X_PARAMS_PHANDLE_NAME		"lpddr4x_params"
#define LPDDR5_PARAMS_PHANDLE_NAME		"lpddr5_params"

#define DTS_PAR_OFFSET				(4096)
#define PARAMS_INVALID_VAL			(0xff00aa99)

#define PMUGRF_OS_REG(n)			(0x200 + (n) * 4)

/* there is a matching relationship, modify it with caution */
static char *dmc_fsp_params[] = {
	"debug_print_level",
	/* if need, add parameter after */
};

/* there is a matching relationship, modify it with caution */
static char *ddr_params_v1[] = {
	/* version information V1.00 */
	"version",
	"expanded_version",
	"reserved",
	/* freq info, freq_0 is final frequency, unit: MHz */
	"freq_0",
	"freq_1",
	"freq_2",
	"freq_3",
	"freq_4",
	"freq_5",
	/* power save setting */
	"pd_idle",
	"sr_idle",
	"sr_mc_gate_idle",
	"srpd_lite_idle",
	"standby_idle",
	"pd_dis_freq",
	"sr_dis_freq",
	"dram_dll_dis_freq",
	"phy_dll_dis_freq",
	/* drv when odt on */
	"phy_dq_drv_odten",
	"phy_ca_drv_odten",
	"phy_clk_drv_odten",
	"dram_dq_drv_odten",
	/* drv when odt off */
	"phy_dq_drv_odtoff",
	"phy_ca_drv_odtoff",
	"phy_clk_drv_odtoff",
	"dram_dq_drv_odtoff",
	/* odt info */
	"dram_odt",
	"phy_odt",
	"phy_odt_puup_en",
	"phy_odt_pudn_en",
	/* odt enable freq */
	"dram_dq_odt_en_freq",
	"phy_odt_en_freq",
	/* slew rate when odt enable */
	"phy_dq_sr_odten",
	"phy_ca_sr_odten",
	"phy_clk_sr_odten",
	/* slew rate when odt disable */
	"phy_dq_sr_odtoff",
	"phy_ca_sr_odtoff",
	"phy_clk_sr_odtoff",
	/* ssmod setting*/
	"ssmod_downspread",
	"ssmod_div",
	"ssmod_spread",
	/* 2T mode */
	"mode_2t",
	/* speed bin */
	"speed_bin",
	/* dram extended temperature support */
	"dram_ext_temp",
	/* byte map */
	"byte_map",
	/* dq map */
	"dq_map_cs0_dq_l",
	"dq_map_cs0_dq_h",
	"dq_map_cs1_dq_l",
	"dq_map_cs1_dq_h",
	/* for LPDDR4 and LPDDR4X */
	/* odt info */
	"lp4_ca_odt",
	"lp4_drv_pu_cal_odten",
	"lp4_drv_pu_cal_odtoff",
	"phy_lp4_drv_pulldown_en_odten",
	"phy_lp4_drv_pulldown_en_odtoff",
	/* odt enable freq */
	"lp4_ca_odt_en_freq",
	/* lp4 cs drv info and ca odt info */
	"phy_lp4_cs_drv_odten",
	"phy_lp4_cs_drv_odtoff",
	"lp4_odte_ck_en",
	"lp4_odte_cs_en",
	"lp4_odtd_ca_en",
	/* lp4 vref info when odt enable */
	"phy_lp4_dq_vref_odten",
	"lp4_dq_vref_odten",
	"lp4_ca_vref_odten",
	/* lp4 vref info when odt disable */
	"phy_lp4_dq_vref_odtoff",
	"lp4_dq_vref_odtoff",
	"lp4_ca_vref_odtoff",
	/* if need, add parameter after and change the minor version. */
};

static int get_atf_version(void)
{
	struct arm_smccc_res res;

	res = sip_smc_dram(0, 0, ROCKCHIP_SIP_CONFIG_DRAM_GET_VERSION);

	if (res.a0)
		return -ENOMEM;
	else
		return res.a1;
}

static int dmc_fsp_probe(struct udevice *dev)
{
	struct device_node *np_params;
	struct arm_smccc_res res;
	void *pmugrf_base;
	int *p = NULL;
	char *phandle_name = NULL;
	char **ddr_params;
	int ddr_params_version;
	u32 dram_type, os_reg2_val, os_reg3_val;
	u32 i = 0, count = 0, size = 0;
	ulong atf_version_limit;

	atf_version_limit = dev_get_driver_data(dev);
	if (get_atf_version() < atf_version_limit) {
		printf("%s: trusted firmware need to update or is invalid!\n", __func__);
		printf("%s: current ATF version 0x%x, required version 0x%lx\n",
		       __func__, get_atf_version(), atf_version_limit);
		return 0;
	}

	pmugrf_base = syscon_get_first_range(ROCKCHIP_SYSCON_PMUGRF);
	os_reg2_val = readl(pmugrf_base + PMUGRF_OS_REG(2));
	os_reg3_val = readl(pmugrf_base + PMUGRF_OS_REG(3));
	dram_type = SYS_REG_DEC_DDRTYPE_V3(os_reg2_val, os_reg3_val);

	if (dram_type == DDR2)
		phandle_name = DDR2_PARAMS_PHANDLE_NAME;
	else if (dram_type == DDR3)
		phandle_name = DDR3_PARAMS_PHANDLE_NAME;
	else if (dram_type == DDR4)
		phandle_name = DDR4_PARAMS_PHANDLE_NAME;
	else if (dram_type == LPDDR2)
		phandle_name = LPDDR2_PARAMS_PHANDLE_NAME;
	else if (dram_type == LPDDR3)
		phandle_name = LPDDR3_PARAMS_PHANDLE_NAME;
	else if (dram_type == LPDDR4)
		phandle_name = LPDDR4_PARAMS_PHANDLE_NAME;
	else if (dram_type == LPDDR4X)
		phandle_name = LPDDR4X_PARAMS_PHANDLE_NAME;
	else if (dram_type == LPDDR5)
		phandle_name = LPDDR5_PARAMS_PHANDLE_NAME;
	else
		printf("%s: dram_type unsupported\n", __func__);

	np_params = of_parse_phandle(ofnode_to_np(dev_ofnode(dev)), phandle_name, 0);
	if (!np_params) {
		printf("%s: of_parse_phandle %s error!\n", __func__, phandle_name);
		return -EINVAL;
	}

	ddr_params_version = ofnode_read_u32_default(np_to_ofnode(np_params), "version", -1);
	if (ddr_params_version < 0) {
		printf("%s: get ddr_params_version error\n", __func__);
		return -EINVAL;
	}

	if ((ddr_params_version & 0xff00) == 0x100 &&
	    (ddr_params_version & 0xffff) <= 0x100) {
		count = ARRAY_SIZE(ddr_params_v1);
		ddr_params = ddr_params_v1;
	} else {
		printf("%s: ddr_params_version=0x%x unsupported\n", __func__, ddr_params_version);
		return -EINVAL;
	}

	size = count * 4;
	res = sip_smc_request_share_mem(DIV_ROUND_UP(size, 4096) + 1, SHARE_PAGE_TYPE_DDRFSP);
	if (res.a0 != 0) {
		printf("%s:no share memory for init\n", __func__);
		return -ENOMEM;
	}

	/* fill share memory and pass to the atf */
	p = (int *)(res.a1);
	for (i = 0; i < ARRAY_SIZE(dmc_fsp_params); i++)
		p[i] = dev_read_u32_default(dev, dmc_fsp_params[i], PARAMS_INVALID_VAL);

	p = (int *)(res.a1 + DTS_PAR_OFFSET / 4);
	for (i = 0; i < count; i++) {
		p[i] = ofnode_read_u32_default(np_to_ofnode(np_params), ddr_params[i],
					       PARAMS_INVALID_VAL);
	}

	flush_cache((unsigned long)(res.a1), (DIV_ROUND_UP(size, 4096) + 1) * 0x1000);
	res = sip_smc_dram(SHARE_PAGE_TYPE_DDRFSP, 0, ROCKCHIP_SIP_CONFIG_DRAM_FSP_INIT);
	if (res.a0) {
		printf("%s: rockchip_sip_config_dram_fsp_init error:%lx\n", __func__, res.a0);
		return -ENOMEM;
	}

	return 0;
}

static const struct udevice_id rockchip_dmc_fsp_ids[] = {
	{ .compatible = "rockchip,rk3568-dmc-fsp", .data = 0x102},
	{ }
};

U_BOOT_DRIVER(dmc_fsp) = {
	.name = "rockchip_dmc_fsp",
	.id = UCLASS_DMC,
	.probe = dmc_fsp_probe,
	.of_match = rockchip_dmc_fsp_ids,
};
