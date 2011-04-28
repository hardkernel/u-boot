/*
 * Copyright C 2011 by Amlogic, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 * Remark: migrate from trunk by Hisun Bao 2011.07.29
 *
 */
 
#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <asm/saradc.h>

//#define AML_ADC_SAMPLE_DEBUG 1

/**********************************************************************************/
// REG0 (0x21A0)
#define detect_level()				READ_CBUS_REG_BITS(SAR_ADC_REG0, 31, 1)
#define delta_busy()				READ_CBUS_REG_BITS(SAR_ADC_REG0, 30, 1)
#define avg_busy()					READ_CBUS_REG_BITS(SAR_ADC_REG0, 29, 1)
#define sample_busy()				READ_CBUS_REG_BITS(SAR_ADC_REG0, 28, 1)
#define fifo_full()					READ_CBUS_REG_BITS(SAR_ADC_REG0, 27 1)
#define fifo_empty()				READ_CBUS_REG_BITS(SAR_ADC_REG0, 26, 1)
#define get_fifo_cnt()				READ_CBUS_REG_BITS(SAR_ADC_REG0, 21, 5)
#define get_cur_chan_id()			READ_CBUS_REG_BITS(SAR_ADC_REG0, 16, 3)

#define stop_sample()				WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 14, 1)

#define enable_chan1_delta()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 13, 1)
#define disable_chan1_delta()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 0, 13, 1)
#define enable_chan0_delta()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 12, 1)
#define disable_chan0_delta()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 0, 12, 1)

#define set_detect_irq_pol(pol)		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, pol, 10, 1)
#define enable_detect_irq()			WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 9, 1)
#define disable_detect_irq()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 0, 9, 1)

#define set_fifo_irq_count(cnt)		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, cnt, 4, 5)
#define enable_fifo_irq()			WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 3, 1)
#define disable_fifo_irq()			WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 0, 3, 1)

#define start_sample()				WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 2, 1)

#define enable_continuous_sample()	WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 1, 1)
#define disable_continuous_sample()	WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 0, 1, 1)

#define enable_sample_engine()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 1, 0, 1)
#define disable_sample_engine()		WRITE_CBUS_REG_BITS(SAR_ADC_REG0, 0, 0, 1)

#if defined(CONFIG_M8) || defined(CONFIG_M8B)
#define saradc_power_on()	WRITE_CBUS_REG_BITS(SAR_ADC_DELTA_10, 1, 10, 1)
//#define saradc_power_off()	WRITE_CBUS_REG_BITS(SAR_ADC_DELTA_10, 0, 10, 1)
#endif

/**********************************************************************************/
// REG1 (0x21A1)
/* set_chan_list() - set  the channels list
 * @list: channels list to be process
 * @len: length of the list of channels to process */
#define set_chan_list(list, len)	WRITE_CBUS_REG(SAR_ADC_CHAN_LIST, list | ((len-1)<<24))

/**********************************************************************************/
// REG2 (0x21A2)
enum {NO_AVG_MODE = 0,SIMPLE_AVG_MODE,MEDIAN_AVG_MODE};
enum {SAMPLE_NUM_1 = 0,SAMPLE_NUM_2,SAMPLE_NUM_4,SAMPLE_NUM_8};

#define set_avg_mode(ch, mode, num) do {\
	WRITE_CBUS_REG_BITS(SAR_ADC_AVG_CNTL, num, ch*2, 2);\
	WRITE_CBUS_REG_BITS(SAR_ADC_AVG_CNTL, mode, ch*2+16, 2);\
} while(0)


/**********************************************************************************/
// REG3 (0x21A3)
/* After all channels in the CHANNEL_LIST have been processed, the sampling engine
    will delay for an amount of time before re-processing the CHANNEL_LIST again */
enum {
	BLOCK_DELAY_TB_1US = 0, /* count 1us ticks    */
	BLOCK_DELAY_TB_10US,    /* count 10us ticks  */
	BLOCK_DELAY_TB_100US,   /* count 100us ticks*/
	BLOCK_DELAY_TB_1MS,	    /* count 1ms ticks   */
};

#define set_block_delay(delay, timebase) do {\
	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, delay, 0, 8);\
	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, timebase, 8, 2);\
} while(0)

/* The ADC clock is derived by dividing the 27Mhz crystal by N+1.
   This value divides the 27Mhz clock to generate an ADC clock.
   A value of 20 for example divides the 27Mhz clock by 21 to generate
   an equivalent 1.28Mhz clock */
#define set_clock_divider(div)	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, div, 10, 6)

/* pannel detect signal filter's parameter */
enum {
	FILTER_TB_1US = 0,	/* count 1us ticks */
	FILTER_TB_10US,		/* count 10us ticks */
	FILTER_TB_100US,	/* count 100us ticks */
	FILTER_TB_1MS,		/* count 1ms ticks */
};
#define set_pannel_detect_filter(count, timebase) do { \
	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, timebase, 16, 2);\
	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, count, 18, 3);   \
} while(0)

/* Enable/disable ADC */
#define enable_adc()  WRITE_CBUS_REG_BITS(SAR_ADC_REG3, 1, 21, 1)
#define disable_adc() WRITE_CBUS_REG_BITS(SAR_ADC_REG3, 0, 21, 1)

/* controls the analog switch that connects a 50k resistor to the X+ signal.
   Setting this bit to 1 closes the analog switch */
#define enable_detect_pullup()	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, 1, 22, 1)
#define disable_detect_pullup()	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, 0, 22, 1)

/* ADC AINC sample mode */
enum {
	DIFF_MODE = 0,		/* differential mode */
	SINGLE_ENDED_MODE,	/* single ended */
};
#define set_sample_mode(mode) WRITE_CBUS_REG_BITS(SAR_ADC_REG3, mode, 23, 1)
#define set_cal_voltage(sel)	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, sel, 23, 3)

/* TEMPSEN_PD12, TEMPSEN_MODE */
#define set_tempsen(val)      WRITE_CBUS_REG_BITS(SAR_ADC_REG3, val, 28, 2)

/* enable/disable  the SAR ADC clock */
#define enable_clock()	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, 1, 30, 1)
#define disable_clock()	WRITE_CBUS_REG_BITS(SAR_ADC_REG3, 0, 30, 1)

/**********************************************************************************/
// REG4 (0x21A4)
/* set_input_delay() - set input delay
 * As the CHANNEL_LIST is process, input switches should be set according to
 * the requirements of the channel,  After setting the switches there is a programmable
 * delay before sampling begins. */
enum {
	INPUT_DELAY_TB_110NS = 0,	/* count 110ns ticks */
	INPUT_DELAY_TB_1US,			/* count 1us ticks */
	INPUT_DELAY_TB_10US,		/* count 10us ticks */
	INPUT_DELAY_TB_100US,		/* count 100us ticks */
};
#define set_input_delay(delay, timebase) do {\
	WRITE_CBUS_REG_BITS(SAR_ADC_DELAY, delay, 16, 8);\
	WRITE_CBUS_REG_BITS(SAR_ADC_DELAY, timebase, 24, 2);\
} while(0)

/* set_sample_delay() - set sample delay
 * For channels that acquire 2,4 or 8 samples, there is a delay between two samples */
enum {
	SAMPLE_DELAY_TB_1US = 0,	/* count 1us ticks */
	SAMPLE_DELAY_TB_10US,		/* count 10us ticks */
	SAMPLE_DELAY_TB_100US,	/* count 100us ticks */
	SAMPLE_DELAY_TB_1MS,		/* count 1ms ticks */
};
#define set_sample_delay(delay, timebase) do {\
	WRITE_CBUS_REG_BITS(SAR_ADC_DELAY, delay, 0, 8);\
	WRITE_CBUS_REG_BITS(SAR_ADC_DELAY, timebase, 8, 2);\
} while(0)

/**********************************************************************************/
// REG5 (0x21A5)
#define get_last_sample()	READ_CBUS_REG(SAR_ADC_LAST_RD)

/**********************************************************************************/
// REG6 (0x21A6)
#define get_fifo_sample()		READ_CBUS_REG(SAR_ADC_FIFO_RD)

/**********************************************************************************/
// REG7 = SAR_ADC_AUX_SW (0x21A7)
// REG8 = SAR_ADC_CHAN_10_SW (0x21A8)
#define set_sample_sw(ch, sw) do {\
	if (ch < 2)\
		WRITE_CBUS_REG_BITS(SAR_ADC_CHAN_10_SW, sw, ch*16, 7);\
	else\
		WRITE_CBUS_REG_BITS(SAR_ADC_AUX_SW, sw, 0, 7);\
} while(0)

#define set_sample_mux(ch, mux) do {\
	if (ch < 2)\
		WRITE_CBUS_REG_BITS(SAR_ADC_CHAN_10_SW, mux, ch*16 + 7, 3);\
	else\
		WRITE_CBUS_REG_BITS(SAR_ADC_AUX_SW, mux, (ch-2) * 3 + 8, 3);\
} while(0)

/**********************************************************************************/
// REG9 (0x21A9)
#define set_idle_sw(sw)		 WRITE_CBUS_REG_BITS(SAR_ADC_DETECT_IDLE_SW, sw, 0, 7)
#define set_idle_mux(mux)	 WRITE_CBUS_REG_BITS(SAR_ADC_DETECT_IDLE_SW, mux, 7, 3)
#define set_detect_sw(sw)	 WRITE_CBUS_REG_BITS(SAR_ADC_DETECT_IDLE_SW, sw, 16, 7)
#define set_detect_mux( mux) WRITE_CBUS_REG_BITS(SAR_ADC_DETECT_IDLE_SW, mux, 23, 3)
#define enable_detect_sw()	 WRITE_CBUS_REG_BITS(SAR_ADC_DETECT_IDLE_SW, 1, 26, 1)
#define disable_detect_sw()	 WRITE_CBUS_REG_BITS(SAR_ADC_DETECT_IDLE_SW, 0, 26, 1)

#define XN_OFF  (0<<0)
#define XN_ON   (1<<0)
#define YN_OFF  (0<<1)
#define YN_ON   (1<<1)
#define XP_OFF  (1<<2)
#define XP_ON   (0<<2)
#define YP_OFF  (1<<3)
#define YP_ON   (0<<3)

#define MODE_SEL(sel)	(sel<<4)
#define VREF_N_MUX(mux)	(mux<<5)
#define VREF_P_MUX(mux)	(mux<<6)

#define IDLE_SW		(XP_OFF | XN_OFF | YP_OFF | YN_OFF\
					| MODE_SEL(0) | VREF_N_MUX(0) | VREF_P_MUX(0))
					
#define DETECT_SW	(XP_OFF | XN_OFF | YP_OFF | YN_ON\
					| MODE_SEL(0) | VREF_N_MUX(0) | VREF_P_MUX(0))
					
#define X_SW		(XP_ON | XN_ON | YP_OFF | YN_OFF\
					| MODE_SEL(0) | VREF_N_MUX(0) | VREF_P_MUX(0))
					
#define Y_SW		(XP_OFF | XN_OFF | YP_ON | YN_ON\
					| MODE_SEL(0) | VREF_N_MUX(0) | VREF_P_MUX(0))
					
#define Z1_SW		(XP_OFF | XN_ON | YP_ON | YN_OFF\
					| MODE_SEL(0) | VREF_N_MUX(0) | VREF_P_MUX(0))
					
#define Z2_SW		(Z1_SW)
/**********************************************************************************/

static u8 g_chan_mux[AML_ADC_SARADC_CHAN_NUM] = {0,1,2,3,4,5,6,7};

extern int printf(const char *fmt, ...);

void saradc_enable(void)
{
	int i;

#if defined(CONFIG_M8) || defined(CONFIG_M8B)
	saradc_power_on();
	//printf("SAR_ADC_DELTA_10: 0x%x ,%s:%d\n",*(volatile unsigned long *)0xc11086a8,__func__,__LINE__);
#endif

	//set adc clock as 1.28Mhz @sys=27MHz
	set_clock_divider(20);
	enable_clock();
	enable_adc();

	set_sample_mode(DIFF_MODE);
	set_tempsen(0);
	disable_fifo_irq();
	disable_continuous_sample();
	disable_chan0_delta();
	disable_chan1_delta();

	set_input_delay(10, INPUT_DELAY_TB_1US);
	set_sample_delay(10, SAMPLE_DELAY_TB_1US);
	set_block_delay(10, BLOCK_DELAY_TB_1US);
	
	// channels sampling mode setting
	for(i=0; i<AML_ADC_SARADC_CHAN_NUM; i++) {
		set_sample_sw(i, IDLE_SW);
		set_sample_mux(i, g_chan_mux[i]);
	}
	
	// idle mode setting
	set_idle_sw(IDLE_SW);
	set_idle_mux(g_chan_mux[AML_ADC_CHAN_0]);
	
	// detect mode setting
	set_detect_sw(DETECT_SW);
	set_detect_mux(g_chan_mux[AML_ADC_CHAN_0]);
	disable_detect_sw();
	disable_detect_pullup();
	set_detect_irq_pol(0);
	disable_detect_irq();
	set_cal_voltage(7);

	enable_sample_engine();

#if AML_ADC_SAMPLE_DEBUG
	printf("ADCREG reg0 =%x\n",   READ_CBUS_REG(SAR_ADC_REG0));
	printf("ADCREG ch list =%x\n",READ_CBUS_REG(SAR_ADC_CHAN_LIST));
	printf("ADCREG avg  =%x\n",   READ_CBUS_REG(SAR_ADC_AVG_CNTL));
	printf("ADCREG reg3 =%x\n",   READ_CBUS_REG(SAR_ADC_REG3));
	printf("ADCREG ch72 sw =%x\n",READ_CBUS_REG(SAR_ADC_AUX_SW));
	printf("ADCREG ch10 sw =%x\n",READ_CBUS_REG(SAR_ADC_CHAN_10_SW));
	printf("ADCREG detect&idle=%x\n",READ_CBUS_REG(SAR_ADC_DETECT_IDLE_SW));
#endif //AML_ADC_SAMPLE_DEBUG

}

int get_adc_sample(int chan)
{
	int count;
	int value = -1;
	int sum;
	
	set_chan_list(chan, 1);
	set_avg_mode(chan, NO_AVG_MODE, SAMPLE_NUM_8);
	set_sample_mux(chan, g_chan_mux[chan]);
	set_detect_mux(g_chan_mux[chan]);
	set_idle_mux(g_chan_mux[chan]); // for revb
	enable_sample_engine();
	start_sample();

	// Read any CBUS register to delay one clock
	// cycle after starting the sampling engine
	// The bus is really fast and we may miss that it started
	{ count = READ_CBUS_REG(ISA_TIMERE); }

	count = 0;
	while (delta_busy() || sample_busy() || avg_busy()){
		if (++count > 10000){
			printf("ADC busy error.\n");
			goto adc_sample_end;
			}
	}
	
    stop_sample();
    
    sum = 0;
    count = 0;
    value = get_fifo_sample();

	while (get_fifo_cnt()){
        value = get_fifo_sample() & 0x3ff;
			  sum += value;
        count++;
	}
	value = (count) ? (sum / count) : (-1);

adc_sample_end:
	
#if AML_ADC_SAMPLE_DEBUG
	printf("ch%d = %d, count=%d\n", chan, value, count);
#endif //AML_ADC_SAMPLE_DEBUG

	disable_sample_engine();
	
	return value;
}

int saradc_disable(void)
{
	disable_adc();
	
	disable_sample_engine();
	
	return 0;
}
