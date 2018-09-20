
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
	[127] = "1'b0                        ",
	[126] = "1'b0                        ",
	[125] = "1'b0                        ",
	[124] = "1'b0                        ",
	[123] = "1'b0                        ",
	[122] = "mod_audio_pdm_dclk_o        ",
	[121] = "audio_spdifin_mst_clk       ",
	[120] = "audio_spdifout_mst_clk      ",
	[119] = "audio_spdifout_b_mst_clk    ",
	[118] = "audio_pdm_sysclk            ",
	[117] = "audio_resample_sclk         ",
	[116] = "audio_tdmin_a_sclk          ",
	[115] = "audio_tdmin_b_sclk          ",
	[114] = "audio_tdmin_c_sclk          ",
	[113] = "audio_tdmin_lb_sclk         ",
	[112] = "audio_tdmout_a_sclk         ",
	[111] = "audio_tdmout_b_sclk         ",
	[110] = "audio_tdmout_c_sclk         ",
	[109] = "c_alocker_out_clk           ",
	[108] = "c_alocker_in_clk            ",
	[107] = "au_dac_clk_g128x            ",
	[106] = "ephy_test_clk               ",
	[105] = "am_ring_osc_clk_out_ee[9]   ",
	[104] = "am_ring_osc_clk_out_ee[8]   ",
	[103] = "am_ring_osc_clk_out_ee[7]   ",
	[102] = "am_ring_osc_clk_out_ee[6]   ",
	[101] = "am_ring_osc_clk_out_ee[5]   ",
	[100] = "am_ring_osc_clk_out_ee[4]   ",
	[99]  = "am_ring_osc_clk_out_ee[3]   ",
	[98]  = "cts_ts_clk                  ",
	[97]  = "cts_vpu_clkb_tmp            ",
	[96]  = "cts_vpu_clkb                ",
	[95]  = "eth_phy_plltxclk            ",
	[94]  = "eth_phy_rxclk               ",
	[93]  = "1'b0                        ",
	[92]  = "1'b0                        ",
	[91]  = "1'b0                        ",
	[90]  = "cts_hdmitx_sys_clk          ",
	[89]  = "HDMI_CLK_TODIG              ",
	[88]  = "1'b0                        ",
	[87]  = "1'b0                        ",
	[86]  = "1'b0                        ",
	[85]  = "1'b0                        ",
	[84]  = "co_tx_clk                   ",
	[83]  = "co_rx_clk                   ",
	[82]  = "Cts_ge2d_clk                ",
	[81]  = "Cts_vapbclk                 ",
	[80]  = "Rng_ring_osc_clk[3]         ",
	[79]  = "Rng_ring_osc_clk[2]         ",
	[78]  = "Rng_ring_osc_clk[1]         ",
	[77]  = "Rng_ring_osc_clk[0]         ",
	[76]  = "1'b0                        ",
	[75]  = "cts_hevcf_clk               ",
	[74]  = "1'b0                        ",
	[73]  = "cts_pwm_C_clk               ",
	[72]  = "cts_pwm_D_clk               ",
	[71]  = "cts_pwm_E_clk               ",
	[70]  = "cts_pwm_F_clk               ",
	[69]  = "Cts_hdcp22_skpclk           ",
	[68]  = "Cts_hdcp22_esmclk           ",
	[67]  = "cts_dsi_phy_clk             ",
	[66]  = "cts_vid_lock_clk            ",
	[65]  = "cts_spicc_0_clk             ",
	[64]  = "Cts_spicc_1_clk             ",
	[63]  = "cts_dsi_meas_clk            ",
	[62]  = "cts_hevcb_clk               ",
	[61]  = "gpio_clk_msr                ",
	[60]  = "1'b0                        ",
	[59]  = "cts_hcodec_clk              ",
	[58]  = "cts_wave4201_bclk           ",
	[57]  = "cts_wave4201_cclk           ",
	[56]  = "cts_wave4201_aclk           ",
	[55]  = "vid_pll_div_clk_out         ",
	[54]  = "cts_vpu_clkc                ",
	[53]  = "sd_emmc_clk_A               ",
	[52]  = "sd_emmc_clk_B               ",
	[51]  = "sd_emmc_clk_C               ",
	[50]  = "mp3_clk_out                 ",
	[49]  = "mp2_clk_out                 ",
	[48]  = "mp1_clk_out                 ",
	[47]  = "ddr_dpll_pt_clk             ",
	[46]  = "cts_vpu_clk                 ",
	[45]  = "cts_pwm_A_clk               ",
	[44]  = "cts_pwm_B_clk               ",
	[43]  = "fclk_div5                   ",
	[42]  = "mp0_clk_out                 ",
	[41]  = "mac_eth_rx_clk_rmii         ",
	[40]  = "1'b0                        ",
	[39]  = "cts_bt656_clk0              ",
	[38]  = "Cts_vdin_meas_clk           ",
	[37]  = "cts_cdac_clk_c              ",
	[36]  = "cts_hdmi_tx_pixel_clk       ",
	[35]  = "cts_mali_clk                ",
	[34]  = "eth_mppll_50m_ckout         ",
	[33]  = "sys_cpu_ring_osc_clk[1]     ",
	[32]  = "cts_vdec_clk                ",
	[31]  = "MPLL_CLK_TEST_OUT           ",
	[30]  = "pcie_clk_inn                ",
	[29]  = "pcie_clk_inp                ",
	[28]  = "Cts_sar_adc_clk             ",
	[27]  = "co_clkin_to_mac             ",
	[26]  = "sc_clk_int                  ",
	[25]  = "cts_eth_clk_rmii            ",
	[24]  = "cts_eth_clk125Mhz           ",
	[23]  = "mpll_clk_50m                ",
	[22]  = "mac_eth_phy_ref_clk         ",
	[21]  = "lcd_an_clk_ph3              ",
	[20]  = "rtc_osc_clk_out             ",
	[19]  = "lcd_an_clk_ph2              ",
	[18]  = "sys_cpu_clk_div16           ",
	[17]  = "sys_pll_div16               ",
	[16]  = "cts_FEC_CLK_2               ",
	[15]  = "cts_FEC_CLK_1               ",
	[14]  = "cts_FEC_CLK_0               ",
	[13]  = "mod_tcon_clko               ",
	[12]  = "hifi_pll_clk                ",
	[11]  = "mac_eth_tx_clk              ",
	[10]  = "cts_vdac_clk                ",
	[9]   = "cts_encl_clk                ",
	[8]   = "cts_encp_clk                ",
	[7]   = "clk81                       ",
	[6]   = "cts_enci_clk                ",
	[5]   = "1'b0                        ",
	[4]   = "gp0_pll_clk                 ",
	[3]   = "A53_ring_osc_clk            ",
	[2]   = "am_ring_osc_clk_out_ee[2]   ",
	[1]   = "am_ring_osc_clk_out_ee[1]   ",
	[0]   = "am_ring_osc_clk_out_ee[0]   ",
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

void ring_powerinit(void)
{
	writel(0x150007, RING_PWM_VCCK);/*set vcck 0.8v*/
	writel(0x10000c, RING_PWM_EE);/*set ee 0.8v*/
}

int ring_msr(int index)
{
	const char* clk_table[] = {
			[11] = "sys_cpu_ring_osc_clk[1] " ,
			[10] = "sys_cpu_ring_osc_clk[0] " ,
			[9] = "am_ring_osc_clk_out_ee[9] " ,
			[8] = "am_ring_osc_clk_out_ee[8] " ,
			[7] = "am_ring_osc_clk_out_ee[7] " ,
			[6] = "am_ring_osc_clk_out_ee[6] " ,
			[5] = "am_ring_osc_clk_out_ee[5] " ,
			[4] = "am_ring_osc_clk_out_ee[4] " ,
			[3] = "am_ring_osc_clk_out_ee[3] " ,
			[2] = "am_ring_osc_clk_out_ee[2] " ,
			[1] = "am_ring_osc_clk_out_ee[1] " ,
			[0] = "am_ring_osc_clk_out_ee[0] " ,
		};
	const int tb[] = {0, 1, 2, 99, 100, 101, 102, 103, 104, 105, 3, 33};
	unsigned long i;
	unsigned char ringinfo[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	ring_powerinit();
	/*RING_OSCILLATOR       0x7f: set slow ring*/
	writel(0x555555, 0xff6345fc);
	for (i = 0; i < 12; i++) {
		printf("%s      :",clk_table[i]);
		printf("%ld     KHz",clk_util_ring_msr(tb[i]));
		printf("\n");
	}

	if (oscring_get_value(ringinfo) != 0) {
		printf("fail get osc ring efuse info\n");
		return 0;
	}

	printf("osc ring efuse info:\n");
	for (i = 0; i <= 7; i++)
		printf("0x%x, ", ringinfo[i]);
	printf("\n");

	/*efuse to test value*/
	printf("ee[9], ee[1], ee[0], cpu[1], cpu[0], iddee, iddcpu\n");
	for (i = 1; i <= 5; i++)
		printf("%d KHz ", (ringinfo[i] * 20));

	for (i = 6; i <= 7; i++)
		printf("%d uA ", (ringinfo[i] * 200));

	printf("\n");

	return 0;
}

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
