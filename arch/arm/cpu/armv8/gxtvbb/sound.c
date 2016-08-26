/*
 * arch/arm/cpu/armv8/gxtvbb/sound.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 */

#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <common.h>
#include <malloc.h>
#include <amlogic/sound.h>

static int reg_update_bits(unsigned long reg, unsigned int mask, unsigned int value)
{
	bool change;
	unsigned int old, new;

	old = readl(reg);

	new = (old & ~mask) | (value & mask);
	change = old != new;
	if (change)
		writel(new, reg);

	return change;
}

struct aiu_958_channel_status {
	unsigned short chstat0_l;
	unsigned short chstat1_l;
	unsigned short chstat0_r;
	unsigned short chstat1_r;
};

struct aiu_958_raw_setting {
	unsigned short int_flag;
	unsigned short bpf;
	unsigned short brst;
	unsigned short length;
	unsigned short paddsize;
	struct aiu_958_channel_status *chan_stat;
};

static void aml_set_audio_spdif_clk(void)
{
	int i;
	// gate the clock off
	reg_update_bits(HHI_AUD_CLK_CNTL, 1 << 8, 0);

	/*--- IEC958 clock  configuration, use MPLL1--- */
	//IEC958_USE_CNTL
	reg_update_bits(HHI_AUD_CLK_CNTL2, 1 << 27, 1 << 27);
	// Select clk source, 0=ddr_pll; 1=Multi-Phase PLL0; 2=Multi-Phase PLL1; 3=Multi-Phase PLL2.
	reg_update_bits(HHI_AUD_CLK_CNTL2, 3 << 25, 2 << 25);

	// Configure Multi-Phase PLL1
	writel(0x14d616, HHI_MPLL_CNTL8);
	// Set the XD value
	reg_update_bits(HHI_AUD_CLK_CNTL2, 0xff << 16, (4-1) << 16);
	reg_update_bits(HHI_AUD_CLK_CNTL2, 1 << 24, 1 << 24);

	// delay 5uS
	//udelay(5);
	for (i = 0; i < 500000; i++) ;

	// gate the clock on
	reg_update_bits(HHI_AUD_CLK_CNTL, 1 << 8, 1 << 8);
	/* 958 divisor more, if true, divided by 2, 4, 6, 8 */
	WRITE_CBUS_REG_BITS(AIU_CLK_CTRL, 0, 12, 1);
	WRITE_CBUS_REG_BITS(AIU_CLK_CTRL, 3, 4, 2);
	/* enable 958 divider */
	WRITE_CBUS_REG_BITS(AIU_CLK_CTRL, 1, 1, 1);
}

static void audio_hw_958_enable(unsigned flag)
{
	WRITE_CBUS_REG(AIU_RST_SOFT, 0x04);
	WRITE_CBUS_REG(AIU_958_FORCE_LEFT, 0);
	if (flag) {
		WRITE_CBUS_REG_BITS(AIU_958_DCU_FF_CTRL, 1, 0, 1);
		WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 3, 1, 2);
	} else {
		WRITE_CBUS_REG(AIU_958_DCU_FF_CTRL, 0);
		WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 0, 1, 2);
	}
}

static void audio_set_958outbuf(long addr, size_t size)
{
	WRITE_CBUS_REG(AIU_MEM_IEC958_START_PTR, addr & 0xffffffc0);
	WRITE_CBUS_REG(AIU_MEM_IEC958_RD_PTR, addr & 0xffffffc0);

	/* this is for 16bit 2 channel */
	WRITE_CBUS_REG(AIU_MEM_IEC958_END_PTR,
				(addr & 0xffffffc0) +
				(size & 0xffffffc0) - 8);

	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_MASKS, 0xffff, 0, 16);
	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 1, 1, 1);
	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 0, 1, 1);

	WRITE_CBUS_REG(AIU_MEM_IEC958_BUF_CNTL, 1);
	WRITE_CBUS_REG(AIU_MEM_IEC958_BUF_CNTL, 0);
}
static void set_958_channel_status(struct aiu_958_channel_status *set)
{
	if (set) {
		WRITE_CBUS_REG(AIU_958_CHSTAT_L0, set->chstat0_l);
		WRITE_CBUS_REG(AIU_958_CHSTAT_L1, set->chstat1_l);
		WRITE_CBUS_REG(AIU_958_CHSTAT_R0, set->chstat0_r);
		WRITE_CBUS_REG(AIU_958_CHSTAT_R1, set->chstat1_r);
	}
}

static void audio_hw_set_958_pcm24(struct aiu_958_raw_setting *set)
{
	if (set) {
		/* in pcm mode, set bpf to 128 */
		WRITE_CBUS_REG(AIU_958_BPF, 0x80);
		set_958_channel_status(set->chan_stat);
	}
}

static void audio_hw_958_reset(unsigned slow_domain, unsigned fast_domain)
{
	WRITE_CBUS_REG(AIU_958_DCU_FF_CTRL, 0);
	WRITE_CBUS_REG(AIU_RST_SOFT, (slow_domain << 3) | (fast_domain << 2));
}

static void audio_set_958_mode(struct aiu_958_raw_setting *set)
{
	if (!set) {
		printf("ERR, NULL set ptr!");
		return;
	}

	WRITE_CBUS_REG(AIU_958_VALID_CTRL, 0);

	audio_hw_set_958_pcm24(set);
	WRITE_CBUS_REG(AIU_958_MISC, 0x2042);
	/* pcm */
#ifdef CONFIG_SND_AML_SPLIT_MODE
	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 1, 8, 1);
#else
	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 0, 8, 1);
#endif
	/* 16bit */
	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 1, 7, 1);
	/* endian */
	WRITE_CBUS_REG_BITS(AIU_MEM_IEC958_CONTROL, 0, 3, 3);
	audio_hw_958_reset(0, 1);

#ifdef CONFIG_SND_AML_SPLIT_MODE
	if (0)
		WRITE_CBUS_REG_BITS(AIU_958_DCU_FF_CTRL, 1, 8, 1);
#endif

	WRITE_CBUS_REG(AIU_958_FORCE_LEFT, 1);
}

static void aml_spdif_play(void)
{
	struct aiu_958_raw_setting set;
	struct aiu_958_channel_status chstat;
	static long iec958buf[32 + 16];

	set.chan_stat = &chstat;
	set.chan_stat->chstat0_l = 0x0100;
	set.chan_stat->chstat0_r = 0x0100;
	set.chan_stat->chstat1_l = 0X200;
	set.chan_stat->chstat1_r = 0X200;
	audio_hw_958_enable(0);

	memset(iec958buf, 0, sizeof(iec958buf));
	audio_set_958outbuf(((long)iec958buf+ 63) & (~63), 128);
	audio_set_958_mode(&set);

	audio_hw_958_enable(1);
}

int aml_audio_init(void)
{
	aml_set_audio_spdif_clk();
	aml_spdif_play();

	return 0;
}

