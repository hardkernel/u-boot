
/*
 * arch/arm/cpu/armv8/gxtvbb/clock.c
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

/*  !!must use nonzero value as default value. Otherwise it linked to bss segment,
    but this segment not cleared to zero while running "board_init_f" */
#define CLK_UNKNOWN (0xffffffff)
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

static const char* clk_table[] = {
	[82] = "Cts_ge2d_clk ",
	[81] = "Cts_vapbclk ",
	[80] = "Rng_ring_osc_clk[3] ",
	[79] = "Rng_ring_osc_clk[2] ",
	[78] = "Rng_ring_osc_clk[1] ",
	[77] = "Rng_ring_osc_clk[0] ",
	[76] = "cts_aoclk_int ",
	[75] = "cts_aoclkx2_int ",
	[74] = "0 ",
	[73] = "cts_pwm_C_clk ",
	[72] = "cts_pwm_D_clk ",
	[71] = "cts_pwm_E_clk ",
	[70] = "cts_pwm_F_clk ",
	[69] = "Cts_hdcp22_skp ",
	[68] = "Cts_hdcp22_esm ",
	[67] = "Cts_tvfe_mclk ",
	[66] = "cts_vid_lock_clk ",
	[65] = "0 ",
	[64] = "Cts_hdmirx_cfg_clk ",
	[63] = "0 ",
	[62] = "cts_hevc_clk ",
	[61] = "gpio_clk_msr ",
	[60] = "alt_32k_clk ",
	[59] = "cts_hcodec_clk ",
	[58] = "Hdmirx_aud_clk ",
	[57] = "Cts_hdmirx_audmeas ",
	[56] = "Cts_hdmirx_modet_clk ",
	[55] = "vid_pll_div_clk_out ",
	[54] = "Cts_hdmirx_arc_ref_clk ",
	[53] = "Sd_emmc_clk_A ",
	[52] = "Sd_emmc_clk_B ",
	[51] = "Cts_emmc_clk_C ",
	[50] = "Mp3_clk_out ",
	[49] = "mp2_clk_out ",
	[48] = "mp1_clk_out ",
	[47] = "ddr_dpll_pt_clk ",
	[46] = "cts_vpu_clk ",
	[45] = "cts_pwm_A_clk ",
	[44] = "cts_pwm_B_clk ",
	[43] = "fclk_div5 ",
	[42] = "mp0_clk_out ",
	[41] = "eth_rx_clk_or_clk_rmii ",
	[40] = "cts_pcm_mclk ",
	[39] = "cts_pcm_sclk ",
	[38] = "Cts_vdin_meas_clk ",
	[37] = "cts_clk_i958 ",
	[36] = "cts_hdmi_tx_pixel_clk ",
	[35] = "cts_mali_clk ",
	[34] = "0 ",
	[33] = "0 ",
	[32] = "cts_vdec_clk ",
	[31] = "MPLL_CLK_TEST_OUT ",
	[30] = "Hdmirx_audmeas_clk ",
	[29] = "Hdmirx_pix_clk ",
	[28] = "Cts_sar_adc_clk ",
	[27] = "Hdmirx_mpll_div_clk ",
	[26] = "sc_clk_int ",
	[25] = "Hdmirx_tmds_clk ",
	[24] = "Hdmirx_aud_pll_clk ",
	[23] = "HDMI_CLK_TODIG ",
	[22] = "eth_phy_ref_clk ",
	[21] = "i2s_clk_in_src0 ",
	[20] = "rtc_osc_clk_out ",
	[19] = "cts_hdmitx_sys_clk ",
	[18] = "A53_clk_div16 ",
	[17] = "0 ",
	[16] = "cts_FEC_CLK_2 ",
	[15] = "cts_FEC_CLK_1 ",
	[14] = "cts_FEC_CLK_0 ",
	[13] = "cts_amclk ",
	[12] = "0 ",
	[11] = "rgmii_tx_clk_to_phy ",
	[10] = "cts_vdac_clk ",
	[9] = "cts_encl_clk " ,
	[8] = "cts_encp_clk " ,
	[7] = "clk81 " ,
	[6] = "cts_enci_clk " ,
	[5] = "Gp1_pll_clk " ,
	[4] = "gp0_pll_clk " ,
	[3] = "A53_ring_osc_clk " ,
	[2] = "am_ring_osc_clk_out_ee[2] " ,
	[1] = "am_ring_osc_clk_out_ee[1] " ,
	[0] = "am_ring_osc_clk_out_ee[0] " ,
};

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
	unsigned int index_total = sizeof(clk_table) / sizeof(char *);

	int i;
	if (index == 0xff) {
		for (i = 0; i < index_total; i++)
			printf("[%4d][%4ld MHz] %s\n", i, clk_util_clk_msr(i), clk_table[i]);
	}
	else {
		if (index >= index_total) {
			printf("clk msr legal range: [0-%d]\n", index_total-1);
			return -1;
		}
		printf("[%4d][%4ld MHz] %s\n", index, clk_util_clk_msr(index), clk_table[index]);
	}

	return 0;
}