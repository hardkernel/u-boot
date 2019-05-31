
/*
 * arch/arm/cpu/armv8/txl/clock.c
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

#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/clock.h>
#include <asm/arch/mailbox.h>
#include <asm/cpu_id.h>

/*  !!must use nonzero value as default value. Otherwise it linked to bss segment,
    but this segment not cleared to zero while running "board_init_f" */
#define CLK_UNKNOWN (0xffffffff)

#define RING_PWM_VCCK 	(0xff802000 + (0x01 << 2))
#define RING_PWM_EE	(0xff807000 + (0x01 << 2))

#if 0
__u32 get_rate_xtal(void)
{
	unsigned long clk;
	clk = (readl(P_PREG_CTLREG0_ADDR) >> 4) & 0x3f;
	clk = clk * 1000 * 1000;
	return clk;
}


__u32 get_cpu_clk(void)
{
    static __u32 sys_freq=CLK_UNKNOWN;
    if (sys_freq == CLK_UNKNOWN)
    {
        sys_freq=(clk_util_clk_msr(SYS_PLL_CLK)*1000000);
    }
    return sys_freq;
}

__u32 get_clk_ddr(void)
{
   static __u32 freq=CLK_UNKNOWN;
	if (freq == CLK_UNKNOWN)
	{
	    freq=(clk_util_clk_msr(DDR_PLL_CLK)*1000000);
	}
    return freq;
}

__u32 get_clk_ethernet_pad(void)
{
    static __u32 freq=CLK_UNKNOWN;
    if (freq == CLK_UNKNOWN)
    {
        freq=(clk_util_clk_msr(MOD_ETH_CLK50_I)*1000000);
    }
    return freq;
}

__u32 get_clk_cts_eth_rmii(void)
{
    static __u32 freq=CLK_UNKNOWN;
    if (freq == CLK_UNKNOWN)
    {
        freq=(clk_util_clk_msr(CTS_ETH_RMII)*1000000);
    }
    return freq;
}

__u32 get_misc_pll_clk(void)
{
    static __u32 freq=CLK_UNKNOWN;
    if (freq == CLK_UNKNOWN)
    {
        freq=(clk_util_clk_msr(MISC_PLL_CLK)*1000000);
    }
    return freq;
}
#endif

__u32 get_clk81(void)
{
    static __u32 clk81_freq=CLK_UNKNOWN;
	if (clk81_freq == CLK_UNKNOWN)
    {
        clk81_freq=(clk_util_clk_msr(CLK81)*1000000);
    }
    return clk81_freq;
}

struct __clk_rate{
    unsigned clksrc;
    __u32 (*get_rate)(void);
};

struct __clk_rate clkrate[]={
    {
        .clksrc=CLK81,
        .get_rate=get_clk81,
    },
};

int clk_get_rate(unsigned clksrc)
{
	int i;
	for (i = 0; i < sizeof(clkrate)/sizeof(clkrate[0]); i++)
	{
		if (clksrc == clkrate[i].clksrc)
			return clkrate[i].get_rate();
	}
	return -1;
}

const char* clk_table[] = {
	[144] = "ts_pll_clk",
	[143] = "mainclk",
	[142] = "demode_ts_clk",
	[141] = "ts_ddr_clk",
	[140] = "audio_toacodec_bclk",
	[139] = "aud_adc_clk_g128x",
	[138] = "dsu_pll_clk_cpu",
	[137] = "atv_dmd_i2c_sclk",
	[136] = "sys_pll_clk",
	[135] = "tvfe_sample_clk",
	[134] = "adc_extclk_in",
	[133] = "atv_dmd_mono_clk_32",
	[132] = "audio_toacode_mclk",
	[131] = "ts_sar_clk",
	[130] = "au_dac2_clk_gf128x",
	[129] = "lvds_fifo_clk",
	[128] = "cts_tcon_pll_clk",
	[127] = "hdmirx_vid_clk",
	[126] = "sar_ring_osc_clk",
	[125] = "cts_hdmi_axi_clk",
	[124] =	"cts_demod_core_clk",
	[123] =	"mod_audio_pdm_dclk_o",
	[122] =	"audio_spdifin_mst_clk",
	[121] = "audio_spdifout_mst_clk",
	[120] = "audio_spdifout_b_mst_clk",
	[119] = "audio_pdm_sysclk",
	[118] = "audio_resamplea_clk",
	[117] = "audio_resampleb_clk",
	[116] = "audio_tdmin_a_sclk",
	[115] = "audio_tdmin_b_sclk",
	[114] = "audio_tdmin_c_sclk",
	[113] = "audio_tdmin_lb_sclk",
	[112] = "audio_tdmout_a_sclk",
	[111] = "audio_tdmout_b_sclk",
	[110] = "audio_tdmout_c_sclk",
	[109] = "o_vad_clk",
	[108] = "acodec_i2sout_bclk",
	[107] = "au_dac_clk_g128x",
	[106] = "ephy_test_clk",
	[105] = "am_ring_osc_clk_out_ee[9]",
	[104] = "am_ring_osc_clk_out_ee[8]",
	[103] = "am_ring_osc_clk_out_ee[7]",
	[102] = "am_ring_osc_clk_out_ee[6]",
	[101] = "am_ring_osc_clk_out_ee[5]",
	[100] = "am_ring_osc_clk_out_ee[4]",
	[99] = "am_ring_osc_clk_out_ee[3]",
	[98] = "cts_ts_clk",
	[97] = "cts_vpu_clkb_tmp",
	[96] = "cts_vpu_clkb",
	[95] = "eth_phy_plltxclk",
	[94] = "eth_phy_exclk",
	[93] = "sys_cpu_ring_osc_clk[3]",
	[92] = "sys_cpu_ring_osc_clk[2]",
	[91] = "hdmirx_audmeas_clk",
	[90] = "am_ring_osc_clk_out_ee[11]",
	[89] = "am_ring_osc_clk_out_ee[10]",
	[88] = "cts_hdmirx_meter_clk",
	[87] = "1'b0",
	[86] = "cts_hdmirx_modet_clk",
	[85] = "cts_hdmirx_acr_ref_clk",
	[84] = "co_tx_cl",
	[83] = "co_rx_clk",
	[82] = "cts_ge2d_clk",
	[81] = "cts_vapbclk",
	[80] = "rng_ring_osc_clk[3]",
	[79] = "rng_ring_osc_clk[2]",
	[78] = "rng_ring_osc_clk[1]",
	[77] = "rng_ring_osc_clk[0]",
	[76] = "hdmix_aud_clk",
	[75] = "cts_hevcf_clk",
	[74] = "hdmirx_aud_pll_clk",
	[73] = "cts_pwm_C_clk",
	[72] = "cts_pwm_D_clk",
	[71] = "cts_pwm_E_clk",
	[70] = "cts_pwm_F_clk",
	[69] = "cts_hdcp22_skpclk",
	[68] = "cts_hdcp22_esmclk",
	[67] = "hdmirx_apll_clk_audio",
	[66] = "cts_vid_lock_clk",
	[65] = "cts_spicc_0_clk",
	[64] = "cts_spicc_1_clk",
	[63] = "hdmirx_tmds_clk",
	[62] = "cts_hevcb_clk",
	[61] = "gpio_clk_msr",
	[60] = "cts_hdmirx_aud_pll_clk",
	[59] = "cts_hcodec_clk",
	[58] = "cts_vafe_datack",
	[57] = "cts_atv_dmd_vdac_clk",
	[56] = "cts_atv_dmd_sys_clk",
	[55] = "vid_pll_div_clk_out",
	[54] = "cts_vpu_clkc",
	[53] = "ddr_2xclk",
	[52] = "cts_sd_emmc_clk_B",
	[51] = "cts_sd_emmc_clk_C",
	[50] = "mp3_clk_out",
	[49] = "mp2_clk_out",
	[48] = "mp1_clk_out",
	[47] = "ddr_dpll_pt_clk",
	[46] = "cts_vpu_clk",
	[45] = "cts_pwm_A_clk",
	[44] = "cts_pwm_B_clk",
	[43] = "fclk_div5",
	[42] = "mp0_clk_out",
	[41] = "mac_eth_rx_clk_rmii",
	[40] = "cts_hdmirx_cfg_clk",
	[39] = "cts_bt656_clk0",
	[38] = "cts_vdin_meas_clk",
	[37] = "cts_cdac_clk_c",
	[36] = "cts_hdmi_tx_pixel_clk",
	[35] = "cts_mali_clk",
	[34] = "eth_mppll_50m_ckout",
	[33] = "sys_cpu_ring_osc_clk[1]",
	[32] = "cts_vdec_clk",
	[31] = "mpll_clk_test_out",
	[30] = "hdmirx_cable_clk",
	[29] = "hdmirx_apll_clk_out_div",
	[28] = "cts_sar_adc_clk",
	[27] = "co_clkin_to_mac",
	[26] = "sc_clk_int",
	[25] = "cts_eth_clk_rmii",
	[24] = "cts_eth_clk125Mhz",
	[23] = "mpll_clk_50m",
	[22] = "mac_eth_phy_ref_clk",
	[21] = "lcd_an_clk_ph3",
	[20] = "rtc_osc_clk_out",
	[19] = "lcd_an_clk_ph2",
	[18] = "sys_cpu_clk_div16",
	[17] = "sys_pll_div16",
	[16] = "cts_FEC_CLK_2",
	[15] = "cts_FEC_CLK_1",
	[14] = "cts_FEC_CLK_0",
	[13] = "mod_tcon_clko",
	[12] = "hifi_pll_clk",
	[11] = "mac_eth_tx_clk",
	[10] = "cts_vdac_clk",
	[9] = "cts_encl_clk",
	[8] = "cts_encp_clk",
	[7] = "clk81",
	[6] = "cts_enci_clk",
	[5] = "gp1_pll_clk",
	[4] = "gp0_pll_clk",
	[3] = "sys_cpu_ring_osc_clk[0]",
	[2] = "am_ring_osc_clk_out_ee[2]",
	[1] = "am_ring_osc_clk_out_ee[1]",
	[0] = "am_ring_osc_clk_out_ee[0]",
};

static const char * const tm2_table[] = {
	[171] = "pcie1_clk_inn",
	[170] = "pcie1_clk_inp",
	[169] = "pcie0_phy_bs_clk",
	[168] = "pcie1_phy_bs_clk",
	[167] = "au_dac1l_en_dac_clk",
	[166] = "au_dac1r_en_dac_clk",
	[165] = "au_dac2l_en_dac_clk",
	[164] = "au_dac2r_en_dac_clk",
	[163] = "hdmirx_aud_sck",
	[162] = "audio_t0_hdmitx_bclk",
	[161] = "audio_t0_hdmitx_spdif_clk",
	[160] = "dspb_clk",
	[159] = "dspa_clk",
	[157] = "vpu_dmc_clk",
	[156] = "p22_usb2_clkout",
	[155] = "p21_usb2_clkout",
	[154] = "p20_usb2_clkout",
	[153] = "c_alocker_out_clk",
	[152] = "c_alocker_in_clk",
	[151] = "dpll_intclk",
	[150] = "dpll_clk_a2",
	[149] = "dpll_clk_b2",
	[148] = "dpll_clk_b3",
	[147] = "pcie0_clk_inp",
	[146] = "pcie0_clk_inn",
	[145] = "hdmitx_sys_clk",
	[144] = "ts_pll_clk",
	[143] = "mainclk",
	[142] = "demode_ts_clk",
	[141] = "ts_ddr_clk",
	[140] = "audio_toacodec_bclk",
	[139] = "aud_adc_clk_g128x",
	[138] = "vipnanoq_core_clk",
	[137] = "atv_dmd_i2c_sclk",
	[136] = "vipnanoq_axi_clk",
	[135] = "tvfe_sample_clk",
	[134] = "adc_extclk_in",
	[133] = "atv_dmd_mono_clk_32",
	[132] = "audio_toacode_mclk",
	[131] = "ts_sar_clk",
	[130] = "au_dac2_clk_gf128x",
	[129] = "lvds_fifo_clk",
	[128] = "cts_tcon_pll_clk",
	[127] = "hdmirx_vid_clk",
	[126] = "sar_ring_osc_clk",
	[125] = "cts_hdmi_axi_clk",
	[124] =	"cts_demod_core_clk",
	[123] =	"mod_audio_pdm_dclk_o",
	[122] =	"audio_spdifin_mst_clk",
	[121] = "audio_spdifout_mst_clk",
	[120] = "audio_spdifout_b_mst_clk",
	[119] = "audio_pdm_sysclk",
	[118] = "audio_resamplea_clk",
	[117] = "audio_resampleb_clk",
	[116] = "audio_tdmin_a_sclk",
	[115] = "audio_tdmin_b_sclk",
	[114] = "audio_tdmin_c_sclk",
	[113] = "audio_tdmin_lb_sclk",
	[112] = "audio_tdmout_a_sclk",
	[111] = "audio_tdmout_b_sclk",
	[110] = "audio_tdmout_c_sclk",
	[109] = "o_vad_clk",
	[108] = "acodec_i2sout_bclk",
	[107] = "au_dac_clk_g128x",
	[106] = "ephy_test_clk",
	[105] = "am_ring_osc_clk_out_ee[9]",
	[104] = "am_ring_osc_clk_out_ee[8]",
	[103] = "am_ring_osc_clk_out_ee[7]",
	[102] = "am_ring_osc_clk_out_ee[6]",
	[101] = "am_ring_osc_clk_out_ee[5]",
	[100] = "am_ring_osc_clk_out_ee[4]",
	[99] = "am_ring_osc_clk_out_ee[3]",
	[98] = "cts_ts_clk",
	[97] = "cts_vpu_clkb_tmp",
	[96] = "cts_vpu_clkb",
	[95] = "eth_phy_plltxclk",
	[94] = "eth_phy_exclk",
	[93] = "sys_cpu_ring_osc_clk[3]",
	[92] = "sys_cpu_ring_osc_clk[2]",
	[91] = "hdmirx_audmeas_clk",
	[90] = "am_ring_osc_clk_out_ee[11]",
	[89] = "am_ring_osc_clk_out_ee[10]",
	[88] = "cts_hdmirx_meter_clk",
	[87] = "hdmitx_tmds_clk",
	[86] = "cts_hdmirx_modet_clk",
	[85] = "cts_hdmirx_acr_ref_clk",
	[84] = "co_tx_cl",
	[83] = "co_rx_clk",
	[82] = "cts_ge2d_clk",
	[81] = "cts_vapbclk",
	[80] = "rng_ring_osc_clk[3]",
	[79] = "rng_ring_osc_clk[2]",
	[78] = "rng_ring_osc_clk[1]",
	[77] = "rng_ring_osc_clk[0]",
	[76] = "hdmix_aud_clk",
	[75] = "cts_hevcf_clk",
	[74] = "hdmirx_aud_pll_clk",
	[73] = "cts_pwm_C_clk",
	[72] = "cts_pwm_D_clk",
	[71] = "cts_pwm_E_clk",
	[70] = "cts_pwm_F_clk",
	[69] = "cts_hdcp22_skpclk",
	[68] = "cts_hdcp22_esmclk",
	[67] = "hdmirx_apll_clk_audio",
	[66] = "cts_vid_lock_clk",
	[65] = "cts_spicc_0_clk",
	[64] = "cts_spicc_1_clk",
	[63] = "hdmirx_tmds_clk",
	[62] = "cts_hevcb_clk",
	[61] = "gpio_clk_msr",
	[60] = "cts_hdmirx_aud_pll_clk",
	[59] = "cts_hcodec_clk",
	[58] = "cts_vafe_datack",
	[57] = "cts_atv_dmd_vdac_clk",
	[56] = "cts_atv_dmd_sys_clk",
	[55] = "vid_pll_div_clk_out",
	[54] = "cts_vpu_clkc",
	[53] = "ddr_2xclk",
	[52] = "cts_sd_emmc_clk_B",
	[51] = "cts_sd_emmc_clk_C",
	[50] = "mp3_clk_out",
	[49] = "mp2_clk_out",
	[48] = "mp1_clk_out",
	[47] = "ddr_dpll_pt_clk",
	[46] = "cts_vpu_clk",
	[45] = "cts_pwm_A_clk",
	[44] = "cts_pwm_B_clk",
	[43] = "fclk_div5",
	[42] = "mp0_clk_out",
	[41] = "mac_eth_rx_clk_rmii",
	[40] = "cts_hdmirx_cfg_clk",
	[39] = "cts_bt656_clk0",
	[38] = "cts_vdin_meas_clk",
	[37] = "cts_cdac_clk_c",
	[36] = "cts_hdmi_tx_pixel_clk",
	[35] = "cts_mali_clk",
	[34] = "eth_mppll_50m_ckout",
	[33] = "sys_cpu_ring_osc_clk[1]",
	[32] = "cts_vdec_clk",
	[31] = "mpll_clk_test_out",
	[30] = "hdmirx_cable_clk",
	[29] = "hdmirx_apll_clk_out_div",
	[28] = "cts_sar_adc_clk",
	[27] = "co_clkin_to_mac",
	[26] = "sc_clk_int",
	[25] = "cts_eth_clk_rmii",
	[24] = "cts_eth_clk125Mhz",
	[23] = "mpll_clk_50m",
	[22] = "mac_eth_phy_ref_clk",
	[21] = "lcd_an_clk_ph3",
	[20] = "rtc_osc_clk_out",
	[19] = "lcd_an_clk_ph2",
	[18] = "sys_cpu_clk_div16",
	[17] = "sys_pll_div16",
	[16] = "cts_FEC_CLK_2",
	[15] = "cts_FEC_CLK_1",
	[14] = "cts_FEC_CLK_0",
	[13] = "mod_tcon_clko",
	[12] = "hifi_pll_clk",
	[11] = "mac_eth_tx_clk",
	[10] = "cts_vdac_clk",
	[9] = "cts_encl_clk",
	[8] = "cts_encp_clk",
	[7] = "clk81",
	[6] = "cts_enci_clk",
	[5] = "gp1_pll_clk",
	[4] = "gp0_pll_clk",
	[3] = "sys_cpu_ring_osc_clk[0]",
	[2] = "am_ring_osc_clk_out_ee[2]",
	[1] = "am_ring_osc_clk_out_ee[1]",
	[0] = "am_ring_osc_clk_out_ee[0]",
};

unsigned long clk_util_ring_msr(unsigned long clk_mux)
{
	unsigned int regval = 0;

	WRITE_CBUS_REG(MSR_CLK_REG0, 0);
	/* Set the measurement gate to 64uS */
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, 0xffff);
	/* 64uS is enough for measure the frequence? */
	SET_CBUS_REG_MASK(MSR_CLK_REG0, (10000 - 1));
	/* Disable continuous measurement */
	/* Disable interrupts */
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, ((1 << 18) | (1 << 17)));
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, (0x7f << 20));
	SET_CBUS_REG_MASK(MSR_CLK_REG0, (clk_mux << 20) | /* Select MUX */
			(1 << 19) |       /* enable the clock */
			(1 << 16));       /* enable measuring */
	/* Wait for the measurement to be done */
	regval = READ_CBUS_REG(MSR_CLK_REG0);
	do {
		regval = READ_CBUS_REG(MSR_CLK_REG0);
	} while (regval & (1 << 31));

	/* Disable measuring */
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, (1 << 16));
	regval = (READ_CBUS_REG(MSR_CLK_REG2) + 31) & 0x000FFFFF;

	return (regval / 10);
}

unsigned long clk_util_clk_msr(unsigned long clk_mux)
{
	unsigned int regval = 0;

	WRITE_CBUS_REG(MSR_CLK_REG0, 0);
	/* Set the measurement gate to 64uS */
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, 0xffff);
	/* 64uS is enough for measure the frequence? */
	SET_CBUS_REG_MASK(MSR_CLK_REG0, (64 - 1));
	/* Disable continuous measurement */
	/* Disable interrupts */
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, ((1 << 18) | (1 << 17)));
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, (0x7f << 20));
	SET_CBUS_REG_MASK(MSR_CLK_REG0, (clk_mux << 20) | /* Select MUX */
			(1 << 19) |       /* enable the clock */
			(1 << 16));       /* enable measuring */
	/* Wait for the measurement to be done */
	regval = READ_CBUS_REG(MSR_CLK_REG0);
	do {
		regval = READ_CBUS_REG(MSR_CLK_REG0);
	} while (regval & (1 << 31));

	/* Disable measuring */
	CLEAR_CBUS_REG_MASK(MSR_CLK_REG0, (1 << 16));
	regval = (READ_CBUS_REG(MSR_CLK_REG2) + 31) & 0x000FFFFF;

	return (regval >> 6);
}

int clk_msr(int index)
{
	unsigned int index_total = 0;
	int i;
	int chip_id = get_cpu_id().family_id;

	if (chip_id == MESON_CPU_MAJOR_ID_TL1)
		index_total = sizeof(clk_table) / sizeof(char *);
	else if (chip_id == MESON_CPU_MAJOR_ID_TM2)
		index_total = sizeof(tm2_table) / sizeof(char *);
	else
		index_total = 256;

	if (index == 0xff) {
		for (i = 0; i < index_total; i++)
			printf("[%4d][%4ld MHz] %s\n", i, clk_util_clk_msr(i),
			(chip_id == MESON_CPU_MAJOR_ID_TL1)? clk_table[i]: tm2_table[i]);
	}
	else {
		if (index >= index_total) {
			printf("clk msr legal range: [0-%d]\n", index_total-1);
			return -1;
		}
		printf("[%4d][%4ld MHz] %s\n", index, clk_util_clk_msr(index),
			(chip_id == MESON_CPU_MAJOR_ID_TL1) ? clk_table[index]: tm2_table[index]);
	}

	return 0;
}

void ring_powerinit(void)
{
	writel(0x150007, RING_PWM_VCCK);/*set vcck 0.8v*/
	writel(0x000c0006, RING_PWM_EE);/*set ee 0.8v*/
}

#ifdef CONFIG_RING
int ring_msr(int index)
{
	const char* clk_table[] = {
			[15] = "cpu[3]_A55_LVT16 " ,
			[14] = "cpu[2]_A55_ULVT16 " ,
			[13] = "cpu[1]_A55_ULVT20 " ,
			[12] = "cpu[0]_A55_ULVT16 " ,
			[11] = "ee[11]_ddrtop_LVT16 " ,
			[10] = "ee[10]_dos_ULVT20 " ,
			[9] = "ee[9]_dos_LVT16 " ,
			[8] = "ee[8]_dos_SVT16 " ,
			[7] = "ee[7]_dos_SVT24 " ,
			[6] = "ee[6]_vpu_LVT16 " ,
			[5] = "ee[5]_vpu_ULVT20 " ,
			[4] = "ee[4]_vpu_SVT24 " ,
			[3] = "ee[3]_mali_SVT16 " ,
			[2] = "ee[2]_mali_ULVT16 " ,
			[1] = "ee[1]_mali_LVT16 " ,
			[0] = "ee[0]_dmctop_LVT16 " ,
		};
	const int tb[] = {0, 1, 2, 99, 100, 101, 102, 103, 104, 105, 89, 90, 3, 33, 92, 93};
	unsigned long i;
	unsigned char efuseinfo[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	if ((index != 0xff) && (index != 0)) {
		if (efuse_get_value(efuseinfo) != 0) {
			printf("fail get efuse info\n");
			return 0;
		}
		if ((index >= 1) && (index <= 4))
			printf("%d\n", (efuseinfo[index] * 20));
		printf("%d\n", (efuseinfo[5] * 400));
		printf("%d\n", efuseinfo[6]);
		printf("%d\n", (efuseinfo[7] * 400));
		if ((index >= 8) && (index <= 11))
			printf("%d\n", efuseinfo[index]);
		if ((index < 0) || (index >= 12))
			printf("input data not support!\n");
		return 0;
	}
	ring_powerinit();
	/*RING_OSCILLATOR       0x7f: set slow ring*/
	writel(0x51555555, 0xff6345fc);
	for (i = 0; i < 16; i++) {
		printf("%s      :",clk_table[i]);
		printf("%ld     KHz",clk_util_ring_msr(tb[i]));
		printf("\n");
	}

	if (efuse_get_value(efuseinfo) != 0) {
		printf("fail get osc ring efuse info\n");
		return 0;
	}

	printf("osc ring efuse info:\n");
	for (i = 0; i <= 11; i++)
		printf("0x%x, ", efuseinfo[i]);
	printf("\n");

	/*efuse to test value*/

	printf("cpu[0]_A55_ring0, ee[2]_mail_ring1, ee[0]_dmc_ring, cpu[0]_A55_ring2, iddee, reserve, iddcpu_A55, sltver, fta53, fta73, slt\n");
	for (i = 1; i <= 4; i++)
		printf("%d KHz, ", (efuseinfo[i] * 20));

	printf("%d uA, ", (efuseinfo[5] * 400));
	printf("%d, ", efuseinfo[6]);
	printf("%d uA, ", (efuseinfo[7] * 400));

	for (i = 8; i <= 11; i++)
		printf("%d,  ", efuseinfo[i]);

	printf("\n");

	return 0;
}
#endif

#ifdef CONFIG_AML_SPICC
/* generic clock control for spicc1.
 * if deleted, you have to add it into all g12a board files as necessary.
 */
static int spicc_clk_rate[] = {
	24000000,	/* XTAL */
	166666666,	/* CLK81 */
	500000000,	/* FCLK_DIV4 */
	666666666,	/* FCLK_DIV3 */
	1000000000,	/* FCLK_DIV2 */
	400000000,	/* FCLK_DIV5 */
	285700000,	/* FCLK_DIV7 */
};

static int spicc_clk_set_rate(int id, int rate)
{
	u32 regv;
	u8 mux, div = 0;
	u8 shift = (id == 0) ? 0 : 16;

	for (mux = 0; mux < ARRAY_SIZE(spicc_clk_rate); mux++)
		if (rate == spicc_clk_rate[mux])
			break;
	if (mux == ARRAY_SIZE(spicc_clk_rate))
		return -EINVAL;

	regv = readl(P_HHI_SPICC_CLK_CNTL);
	regv &= ~ (0x3ff << shift);
	regv |= div << (0 + shift);
	regv |= 1 << (6 + shift);
	regv |= mux << (7 + shift);
	writel(regv, P_HHI_SPICC_CLK_CNTL);

	return 0;
}

int spicc0_clk_set_rate(int rate)
{
	return spicc_clk_set_rate(0, rate);
}

static int spicc_clk_enable(int id, bool enable)
{
	u32 regv;
	u8 shift = (id == 0) ? 8: 14;

	regv = readl(P_HHI_GCLK_MPEG0);
	if (enable)
		regv |= 1 << shift;
	else
		regv &= ~(1 << shift);
	writel(regv, P_HHI_GCLK_MPEG0);

	return 0;
}

int spicc0_clk_enable(bool enable)
{
	return spicc_clk_enable(0, enable);
}
#endif /* CONFIG_AML_SPICC */
