
/*
 * arch/arm/cpu/armv8/txl/gate_init.c
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

#include "power_gate.h"

#define SECUREBOOT_FLAG_ADDR 0xc8100228

#ifdef CONFIG_AML_CVBS
extern unsigned int cvbs_mode;
#endif
void ee_gate_off(void)
{
	printf("ee_gate_off ...\n");
	return;
/*	int secureboot = readl(SECUREBOOT_FLAG_ADDR)&(1<<5);*/

#ifdef CONFIG_AML_CVBS
	unsigned int cvbs_opened = 0;
#endif

#ifdef CONFIG_AML_CVBS
	if ((cvbs_mode == 0) || (cvbs_mode == 1))
		cvbs_opened = 1;
#endif

	/*
	//if close , audio maybe have noise
	CLK_GATE_OFF(AUD);
	CLK_GATE_OFF(AUD2);
	CLK_GATE_OFF(AUD_CLK_2);
	CLK_GATE_OFF(AUD_CLK_3);
	*/
	CLK_GATE_OFF(AUD_IN);
	CLK_GATE_OFF(AIU_AUD_MIXER);
	CLK_GATE_OFF(SANA);

	/*kernel will reopen */
	CLK_GATE_OFF(CTS_ENCL);
	/* CLK_GATE_OFF(CTS_ENCT); */
#if 0    /* HDMITX 480i60hz/576i50hz need this gate */
#ifdef CONFIG_AML_CVBS
	if (cvbs_opened == 0)
		CLK_GATE_OFF(CTS_ENCI);
#else
	CLK_GATE_OFF(CTS_ENCI);
#endif
#endif
	/* CLK_GATE_OFF(CTS_ENCP); */

	/*close cvbs clock*/
#ifdef CONFIG_AML_CVBS
	if (cvbs_opened == 0) {
		CLK_GATE_OFF(DAC_CLK);
		CLK_GATE_OFF(CTS_VDAC);
	}
#else
	CLK_GATE_OFF(DAC_CLK);
	CLK_GATE_OFF(CTS_VDAC);
#endif

	/* usb clock close */
	CLK_GATE_OFF(USB0);
	CLK_GATE_OFF(USB1);
	//CLK_GATE_OFF(USB_CLK); //g12a no reg
	CLK_GATE_OFF(MISC_USB0_TO_DDR);
	CLK_GATE_OFF(MISC_USB1_TO_DDR);

	/* uarts close */
	CLK_GATE_OFF(UART0);
	CLK_GATE_OFF(UART1);
	CLK_GATE_OFF(UART2);
	CLK_GATE_OFF(UART3);

	CLK_GATE_OFF(VCLK2_VENCP);
	CLK_GATE_OFF(VCLK2_VENCT);
	CLK_GATE_OFF(VCLK2_VENCT1);
	CLK_GATE_OFF(VCLK2_OTHER);
#if 0    /* HDMITX 480i60hz/576i50hz need HHI_GCLK_OTHER[8][2] */
#ifdef CONFIG_AML_CVBS
	if (cvbs_opened == 0) {
		CLK_GATE_OFF(VCLK2_VENCI);
		CLK_GATE_OFF(VCLK2_VENCI1);
	}
#else
	CLK_GATE_OFF(VCLK2_VENCI);
	CLK_GATE_OFF(VCLK2_VENCI1);
#endif
#endif
	CLK_GATE_OFF(VCLK2_VENCL);
	CLK_GATE_OFF(VCLK2_OTHER1);
#if 0    /* HDMITX 480i60hz/576i50hz need HHI_GCLK_OTHER[8][2] */
#ifdef CONFIG_AML_CVBS
	if (cvbs_opened == 0)
		CLK_GATE_OFF(VCLK2_ENCI);
#else
	CLK_GATE_OFF(VCLK2_ENCI);
#endif
#endif
	CLK_GATE_OFF(VCLK2_ENCL);
	CLK_GATE_OFF(VCLK2_ENCT);

	CLK_GATE_OFF(VDEC_CLK_1);
	CLK_GATE_OFF(VDEC_CLK_2);
	CLK_GATE_OFF(VDEC2_CLK_1);
	CLK_GATE_OFF(VDEC2_CLK_2);
	CLK_GATE_OFF(HCODEC_CLK_1);
	CLK_GATE_OFF(HCODEC_CLK_2);
	/* CLK_GATE_OFF(HEVC_CLK_1 ); */
	/* CLK_GATE_OFF(HEVC_CLK_2 ); */

	//CLK_GATE_OFF(MMC_A_PCLK); //g12a no reg
	//CLK_GATE_OFF(MMC_B_PCLK); //g12a no reg
	//CLK_GATE_OFF(MMC_C_PCLK); //g12a no reg

	CLK_GATE_OFF(LCD_AN_PHY2);
	CLK_GATE_OFF(LCD_AN_PHY3);

	CLK_GATE_OFF(ETHERNET);
	//CLK_GATE_OFF(ETH_CLK); //g12a no reg

	CLK_GATE_OFF(GE2D);
	CLK_GATE_OFF(GEN_CLK);
	//CLK_GATE_OFF(PCM_MCLK); //g12a no reg
	//CLK_GATE_OFF(PCM_SCLK); //g12a no reg


	CLK_GATE_OFF(HIU_PARSER_TOP);


	/* can not off nand_clk */
	/* CLK_GATE_OFF(NAND_CLK); */
	/*
	//HDMI no output
	CLK_GATE_OFF(VCLK2_VENCP1);
	CLK_GATE_OFF(VCLK2_ENCP);
	*/

	/*
	//if OFF, HDMI will report error!
	CLK_GATE_OFF(HDMI_PCLK);
	CLK_GATE_OFF(HDMI_PLL_CNTL);
	CLK_GATE_OFF(HDMITX_CLK);
	*/

	/*
	//PWM B used for VCCK,PWM D used for VDDEE,ignoring
	CLK_GATE_OFF(PWM_A_CLK);
	CLK_GATE_OFF(PWM_B_CLK);
	CLK_GATE_OFF(PWM_C_CLK);
	CLK_GATE_OFF(PWM_D_CLK);
	CLK_GATE_OFF(PWM_E_CLK);
	CLK_GATE_OFF(PWM_F_CLK);
	*/


	/*  can not close
	    CLK_GATE_OFF(VPU_CLK_1);
	    CLK_GATE_OFF(VPU_CLK_2);
	    CLK_GATE_OFF(VPU_CLKB);
	    CLK_GATE_OFF(MALI_CLK_1);
	    CLK_GATE_OFF(MALI_CLK_2);
	    CLK_GATE_OFF(ATV_DEMO_VDAC);
	    CLK_GATE_OFF(EMMC_A);
	    CLK_GATE_OFF(EMMC_B);
	    CLK_GATE_OFF(EMMC_C);
	    CLK_GATE_OFF(EMMC_A_CLK);
	    CLK_GATE_OFF(EMMC_B_CLK);

	    CLK_GATE_OFF(MSR_CLK);
	    CLK_GATE_OFF(MSR_HS_CLK);
	    CLK_GATE_OFF(32K_CLK);
	    CLK_GATE_OFF(VAPB_CLK_1);
	    CLK_GATE_OFF(VAPB_CLK_2);
	    CLK_GATE_OFF(GIC);
	    CLK_GATE_OFF(I2C_AO); //no close for to use
	    CLK_GATE_OFF(AO_CPU);
	    CLK_GATE_OFF(ASSIST_MISC);
	    CLK_GATE_OFF(HIU_PARSER);
	    CLK_GATE_OFF(PERIPHS_TOP);
	    CLK_GATE_OFF(PL310_CBUS);
	    CLK_GATE_OFF(ISA);
	    CLK_GATE_OFF(SECURE_AHP_APB3);
	    CLK_GATE_OFF(VPU_INTR);
	    CLK_GATE_OFF(MMC_PCLK); //can not close
	    CLK_GATE_OFF(AIU_PCLK);
	//can not connect pc
	CLK_GATE_OFF(USB_GENERAL);
	CLK_GATE_OFF(AHB_DATA_BUS);
	CLK_GATE_OFF(AHB_CONTROL_BUS);
	CLK_GATE_OFF(HDMI_INTR_SYNC); //should open
	//can't suspend @ 2nd time
	//CLK_GATE_OFF(RESET);

	// close rom
	//disable this bit will make other cpu can not be booted.
	//CLK_GATE_OFF(ROM_CLK);

*/
	/*************************/
	CLK_GATE_OFF(AHB_ARB0);
	CLK_GATE_OFF(ASYNC_FIFO);
	CLK_GATE_OFF(STREAM);
	CLK_GATE_OFF(RANDOM_NUM_GEN);
	CLK_GATE_OFF(RANDOM_NUM_GEN1);
	CLK_GATE_OFF(SMART_CARD_MPEG_DOMAIN);
	CLK_GATE_OFF(I2C);
	CLK_GATE_OFF(SPI);
	CLK_GATE_OFF(SPICC);
	CLK_GATE_OFF(DOS);
	CLK_GATE_OFF(SAR_ADC);
	CLK_GATE_OFF(MISC_DVIN);
	CLK_GATE_OFF(BT656);
	CLK_GATE_OFF(BT656_2);
	CLK_GATE_OFF(PDM);

	/* close AIU */
	CLK_GATE_OFF(AIU_IEC958);
	CLK_GATE_OFF(AIU_ICE958_AMCLK);

	CLK_GATE_OFF(AIU_AMCLK_MEASURE);
	CLK_GATE_OFF(AIU_AIFIFO2);
	CLK_GATE_OFF(AIU_MIXER_REG);
	CLK_GATE_OFF(AIU_ADC);
	CLK_GATE_OFF(AIU_TOP_LEVEL);
	CLK_GATE_OFF(AIU_AOCLK);
	CLK_GATE_OFF(AIU_AI_TOP_GLUE);
	CLK_GATE_OFF(AIU_I2S_OUT);

	CLK_GATE_OFF(ENC480P);

	CLK_GATE_OFF(DEMUX);
/*
*	EFUSE/BLK_MOV clock gate must be on,
	kernel storage ops depend on them.
	it can be reference PD#112732
*/
/*
	if (secureboot) {
		printf("secure boot ignore [ BLK_MOV, efuse ] clk gate\n");
	} else {
		CLK_GATE_OFF(EFUSE);
		CLK_GATE_OFF(BLK_MOV);
	}
*/
}

void ee_gate_on(void)
{

	printf("ee_gate_on ...\n");

	/*
	//if close , audio maybe have noise
	CLK_GATE_ON(AUD);
	CLK_GATE_ON(AUD2);
	CLK_GATE_ON(AUD_CLK_2);
	CLK_GATE_ON(AUD_CLK_3);
	*/
	CLK_GATE_ON(AUD_IN);
	CLK_GATE_ON(AIU_AUD_MIXER);
	CLK_GATE_ON(SANA);

	/*kernel will reopen */
	CLK_GATE_ON(CTS_ENCL);
	/* CLK_GATE_ON(CTS_ENCT); */
	CLK_GATE_ON(CTS_ENCI);
	/* CLK_GATE_ON(CTS_ENCP); */

	/*close cvbs clock*/
	CLK_GATE_ON(DAC_CLK);
	CLK_GATE_ON(CTS_VDAC);

	/* usb clock close */
	CLK_GATE_ON(USB0);
	CLK_GATE_ON(USB1);
	//CLK_GATE_ON(USB_CLK); //g12a no reg
	CLK_GATE_ON(MISC_USB0_TO_DDR);
	CLK_GATE_ON(MISC_USB1_TO_DDR);

	/* uarts close */
	CLK_GATE_ON(UART0);
	CLK_GATE_ON(UART1);
	CLK_GATE_ON(UART2);
	CLK_GATE_ON(UART3);

	CLK_GATE_ON(VCLK2_VENCP);
	CLK_GATE_ON(VCLK2_VENCT);
	CLK_GATE_ON(VCLK2_VENCT1);
	CLK_GATE_ON(VCLK2_OTHER);
	CLK_GATE_ON(VCLK2_VENCI);
	CLK_GATE_ON(VCLK2_VENCI1);
	CLK_GATE_ON(VCLK2_VENCL);
	CLK_GATE_ON(VCLK2_OTHER1);


	CLK_GATE_ON(VCLK2_ENCI);
	CLK_GATE_ON(VCLK2_ENCL);
	CLK_GATE_ON(VCLK2_ENCT);

	CLK_GATE_ON(VDEC_CLK_1);
	CLK_GATE_ON(VDEC_CLK_2);
	CLK_GATE_ON(VDEC2_CLK_1);
	CLK_GATE_ON(VDEC2_CLK_2);
	CLK_GATE_ON(HCODEC_CLK_1);
	CLK_GATE_ON(HCODEC_CLK_2);
	/* CLK_GATE_ON(HEVC_CLK_1 ); */
	/* CLK_GATE_ON(HEVC_CLK_2 ); */

	//CLK_GATE_ON(MMC_A_PCLK); //g12a no reg
	//CLK_GATE_ON(MMC_B_PCLK); //g12a no reg
	//CLK_GATE_ON(MMC_C_PCLK); //g12a no reg

	CLK_GATE_ON(LCD_AN_PHY2);
	CLK_GATE_ON(LCD_AN_PHY3);

	CLK_GATE_ON(ETHERNET);
	//CLK_GATE_ON(ETH_CLK); //g12a no reg

	CLK_GATE_ON(GE2D);
	CLK_GATE_ON(GEN_CLK);
	//CLK_GATE_ON(PCM_MCLK); //g12a no reg
	//CLK_GATE_ON(PCM_SCLK); //g12a no reg


	CLK_GATE_ON(HIU_PARSER_TOP);

	/*************************/
	CLK_GATE_ON(AHB_ARB0);
	CLK_GATE_ON(ASYNC_FIFO);
	CLK_GATE_ON(STREAM);
	CLK_GATE_ON(RANDOM_NUM_GEN);
	CLK_GATE_ON(RANDOM_NUM_GEN1);
	CLK_GATE_ON(SMART_CARD_MPEG_DOMAIN);
	CLK_GATE_ON(I2C);
	CLK_GATE_ON(SPI);
	CLK_GATE_ON(SPICC);
	CLK_GATE_ON(DOS);
	CLK_GATE_ON(SAR_ADC);
	CLK_GATE_ON(MISC_DVIN);
	CLK_GATE_ON(BT656);
	CLK_GATE_ON(BT656_2);
	CLK_GATE_ON(PDM);

	/* close AIU */
	CLK_GATE_ON(AIU_IEC958);
	CLK_GATE_ON(AIU_ICE958_AMCLK);

	CLK_GATE_ON(AIU_AMCLK_MEASURE);
	CLK_GATE_ON(AIU_AIFIFO2);
	CLK_GATE_ON(AIU_MIXER_REG);
	CLK_GATE_ON(AIU_ADC);
	CLK_GATE_ON(AIU_TOP_LEVEL);
	CLK_GATE_ON(AIU_AOCLK);
	CLK_GATE_ON(AIU_AI_TOP_GLUE);
	CLK_GATE_ON(AIU_I2S_OUT);

	CLK_GATE_ON(ENC480P);

	CLK_GATE_ON(DEMUX);

	CLK_GATE_ON(EFUSE);
	CLK_GATE_ON(BLK_MOV);
}

