#include "power_gate.h"
#include <asm/arch/io.h>

unsigned char GCLK_ref[GCLK_IDX_MAX];

void gate_init(void)
{
	/* close spi */
	CLK_GATE_OFF(SPICC);
	CLK_GATE_OFF(SPI);
    
    CLK_GATE_OFF(AUD_BUF);                          // CBUS[0x1050], gate off Audio buffer
	/* can't open HDMI */
  //CLK_GATE_OFF(HDMI_RX);                          // CBUS[0x1050], gate off HDMI_RX 
    CLK_GATE_OFF(RANDOM_NUM_GEN);                   // CBUS[0x1050], gate off RANDOM_NUM_GEN 
    CLK_GATE_OFF(ASYNC_FIFO);                       // CBUS[0x1050], gate off ASYNC FIFO
	
	/* close card */
	#if 1
	CLK_GATE_OFF(SDHC);
	//CLK_GATE_OFF(SDIO);
	CLK_GATE_OFF(SMART_CARD_MPEG_DOMAIN);
	#endif
	
	/* close stream */
	CLK_GATE_OFF(STREAM);
	
	/* close USB */
	#if 1
    // can't connect to PC
  //CLK_GATE_OFF(USB_GENERAL);
    CLK_GATE_OFF(USB0);
    CLK_GATE_OFF(USB1);
    CLK_GATE_OFF(MISC_USB1_TO_DDR);
    CLK_GATE_OFF(MISC_USB0_TO_DDR);
	#endif
	
	/* close demux */
	CLK_GATE_OFF(DEMUX);

    CLK_GATE_OFF(AIU_IEC958);                       // CBUS[0x1051], gate off IEC958
    CLK_GATE_OFF(BLK_MOV);                          // CBUS[0x1051], gate off Block move core logic
    CLK_GATE_OFF(CSI_DIG_CLKIN);                    // CBUS[0x1051], gate off CSI_DIG_CLKIN 
    /*
     * can't suspend @ 2nd time
     */
  //CLK_GATE_OFF(RESET);                            // CBUS[0x1051], gate off RESET

	/* close ethernet */
	CLK_GATE_OFF(ETHERNET);
	
	/* close ge2d */
	CLK_GATE_OFF(GE2D);
	
	/* close rom */
	//CLK_GATE_OFF(ROM_CLK); //disable this bit will make other cpu can not be booted.
	
	/* close efuse */
	CLK_GATE_OFF(EFUSE);
	
    /* can't open HDMI */
//  CLK_GATE_OFF(HDMI_INTR_SYNC);                   // CBUS[0x1052], gate off HDMI interrupt synchronization
    /* can't bootup if close HDMI_PCLK */
//  CLK_GATE_OFF(HDMI_PCLK);                        // CBUS[0x1052], gate off HDMI PCLK
    CLK_GATE_OFF(MISC_DVIN);                        // CBUS[0x1052], gate off DVIN 
   // CLK_GATE_OFF(SECURE_AHP_APB3);                  // CBUS[0x1052], gate off Secure AHB to APB3 Bridge


	/* close UARTS */
	CLK_GATE_OFF(UART1);
	CLK_GATE_OFF(UART2);
	CLK_GATE_OFF(UART3);
	
	/* close audio in */
	#if 1
	CLK_GATE_OFF(AUD_IN);
	#endif
	
	/* close AIU */
	#if 1
	CLK_GATE_OFF(AIU_AI_TOP_GLUE);
	//CLK_GATE_OFF(AIU_IEC958);
	CLK_GATE_OFF(AIU_I2S_OUT);
	CLK_GATE_OFF(AIU_AMCLK_MEASURE);
	CLK_GATE_OFF(AIU_AIFIFO2);
	CLK_GATE_OFF(AIU_AUD_MIXER);
	CLK_GATE_OFF(AIU_MIXER_REG);
	CLK_GATE_OFF(AIU_ADC);
	CLK_GATE_OFF(AIU_TOP_LEVEL);
	//CLK_GATE_OFF(AIU_PCLK);
	CLK_GATE_OFF(AIU_AOCLK);
	//CLK_GATE_OFF(AIU_ICE958_AMCLK);
	#endif
    

    CLK_GATE_OFF(VCLK2_VENCP);                      // CBUS[0x1054], gate off VCLK2_VENCP 
    // HDMI no output
//    CLK_GATE_OFF(VCLK2_VENCP1);                     // CBUS[0x1054], gate off VCLK2_VENCP1 
    CLK_GATE_OFF(VCLK2_VENCT);                      // CBUS[0x1054], gate off VCLK2_VENCT
    CLK_GATE_OFF(VCLK2_VENCT1);                     // CBUS[0x1054], gate off VCLK2_VENCT1
    CLK_GATE_OFF(VCLK2_OTHER);                      // CBUS[0x1054], gate off VCLK2_OTHER
    CLK_GATE_OFF(VCLK2_ENCI);                       // CBUS[0x1054], gate off VCLK2_ENCI
    // HDMI no output
//    CLK_GATE_OFF(VCLK2_ENCP);                       // CBUS[0x1054], gate off VCLK2_ENCP
    CLK_GATE_OFF(DAC_CLK);                          // CBUS[0x1054], gate off DAC_CLK 
    CLK_GATE_OFF(AIU_ICE958_AMCLK);                 // CBUS[0x1054], gate off IEC958_GATE
    CLK_GATE_OFF(ENC480P);                          // CBUS[0x1054], gate off ENC480P
    CLK_GATE_OFF(RANDOM_NUM_GEN1);                  // CBUS[0x1054], gate off RANDOM_NUM_GEN1
    CLK_GATE_OFF(VCLK2_ENCT);                       // CBUS[0x1054], gate off VCLK2_ENCT
    CLK_GATE_OFF(VCLK2_OTHER1);                     // CBUS[0x1054], gate off VCLK2_OTHER1
}
