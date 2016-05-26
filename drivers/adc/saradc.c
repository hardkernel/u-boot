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
#include <asm/cpu_id.h>

//#define ENABLE_DYNAMIC_POWER

#define CONFIG_GXBB 1
static int flag_12bit;

#if defined(CONFIG_GXBB)

#define WRITE_REG(reg, val) writel(val, reg)
#define READ_REG(reg)       readl(reg)

#define GXBB_ADC   1
#define AML_ADC_SAMPLE_DEBUG 0

#ifdef  CONFIG_TARGET_MESON_GXTV
#define GXBB_CLK_REG                (volatile unsigned int *)0xc8100090
#define P_SAR_SAR_ADC_REG0		    (volatile unsigned int *)0xc8100600
#define P_SAR_ADC_CHAN_LIST		    (volatile unsigned int *)0xc8100604
#define P_SAR_ADC_AVG_CNTL		    (volatile unsigned int *)0xc8100608
#define P_SAR_ADC_REG3				(volatile unsigned int *)0xc810060c
#define P_SAR_ADC_DELAY			    (volatile unsigned int *)0xc8100610
#define P_SAR_ADC_LAST_RD			(volatile unsigned int *)0xc8100614
#define P_SAR_ADC_FIFO_RD			(volatile unsigned int *)0xc8100618
#define P_SAR_ADC_AUX_SW			(volatile unsigned int *)0xc810061c
#define P_SAR_ADC_CHAN_10_SW		(volatile unsigned int *)0xc8100620
#define P_SAR_ADC_DETECT_IDLE_SW	(volatile unsigned int *)0xc8100624
#define P_SAR_ADC_DELTA_10	        (volatile unsigned int *)0xc8100628
#define P_SAR_ADC_DELTA_11          (volatile unsigned int *)0xc810062c
#define P_SAR_ADC_REG13				(volatile unsigned int *)0xc8100634

#else
#define GXBB_CLK_REG                (volatile unsigned int *)0xc883c3d8
#define P_SAR_SAR_ADC_REG0		    (volatile unsigned int *)0xc1108680
#define P_SAR_ADC_CHAN_LIST		    (volatile unsigned int *)0xc1108684
#define P_SAR_ADC_AVG_CNTL		    (volatile unsigned int *)0xc1108688
#define P_SAR_ADC_REG3				(volatile unsigned int *)0xc110868c
#define P_SAR_ADC_DELAY			    (volatile unsigned int *)0xc1108690
#define P_SAR_ADC_LAST_RD			(volatile unsigned int *)0xc1108694
#define P_SAR_ADC_FIFO_RD			(volatile unsigned int *)0xc1108698
#define P_SAR_ADC_AUX_SW			(volatile unsigned int *)0xc110869c
#define P_SAR_ADC_CHAN_10_SW		(volatile unsigned int *)0xc11086a0
#define P_SAR_ADC_DETECT_IDLE_SW	(volatile unsigned int *)0xc11086a4
#define P_SAR_ADC_DELTA_10	        (volatile unsigned int *)0xc11086a8
#define P_SAR_ADC_DELTA_11          (volatile unsigned int *)0xc11086ac
#define P_SAR_ADC_REG13				(volatile unsigned int *)0xc11086b4

#endif
/*
#define P_SAR_ADC_DELTA_11		    (volatile unsigned int *)0xc11086a8
#define P_SAR_ADC_TEMP_SES		    (volatile unsigned int *)0xc11086ac
#define P_SAR_ADC_CLOCK			    (volatile unsigned int *)0xc883c3d8
#define P_SAR_FIFO_READ			    (volatile unsigned int *)0xc1108698
*/

#define PP_SAR_ADC_REG0					P_SAR_SAR_ADC_REG0
#define PP_SAR_ADC_CHAN_LIST 			P_SAR_ADC_CHAN_LIST
#define PP_SAR_ADC_AVG_CNTL				P_SAR_ADC_AVG_CNTL
#define PP_SAR_ADC_REG3					P_SAR_ADC_REG3
#define PP_SAR_ADC_DELAY				P_SAR_ADC_DELAY
#define PP_SAR_ADC_LAST_RD				P_SAR_ADC_LAST_RD
#define PP_SAR_ADC_FIFO_RD				P_SAR_ADC_FIFO_RD
#define PP_SAR_ADC_AUX_SW				P_SAR_ADC_AUX_SW
#define PP_SAR_ADC_CHAN_10_SW			P_SAR_ADC_CHAN_10_SW
#define PP_SAR_ADC_DETECT_IDLE_SW	    P_SAR_ADC_DETECT_IDLE_SW
#define PP_SAR_ADC_DELTA_10				P_SAR_ADC_DELTA_10
#define PP_SAR_ADC_DELTA_11				P_SAR_ADC_DELTA_11
#define PP_SAR_ADC_REG13				P_SAR_ADC_REG13


static __inline__ void aml_set_reg32_bits(volatile unsigned int *_reg, const uint32_t _value, const uint32_t _start, const uint32_t _len)
{
	writel(( (readl((volatile unsigned int *)_reg) & ~((( 1L << (_len) )-1) << (_start))) | ((unsigned)((_value)&((1L<<(_len))-1)) << (_start))), (volatile void *)_reg );
}
static __inline__ uint32_t aml_get_reg32_bits(volatile unsigned int *_reg, const uint32_t _start, const uint32_t _len)
{
	return	( (readl((volatile unsigned int *)_reg) >> (_start)) & (( 1L << (_len) ) - 1) );
}
static __inline__ void aml_write_reg32( volatile unsigned int *_reg, const uint32_t _value)
{
	writel( _value,(volatile unsigned int *)_reg );
};
static __inline__ uint32_t aml_read_reg32(volatile unsigned int *_reg)
{
	return readl((volatile unsigned int *)_reg);
};


#define set_bits	aml_set_reg32_bits
#define get_bits	aml_get_reg32_bits
#define set_reg	    aml_write_reg32
#define get_reg	    aml_read_reg32


#endif

#define SARADC_STATE_IDLE 0
#define SARADC_STATE_BUSY 1
#define SARADC_STATE_SUSPEND 2

#define FLAG_INITIALIZED (1<<28)
//#define FLAG_BUSY (1<<29)
#define FLAG_BUSY_KERNEL    (1<<14) /* for kernel:SARADC_DELAY 14bit */
#define FLAG_BUSY_KERNEL_BIT  14
#define FLAG_BUSY_BL30      (1<<15) /* for bl30:SARADC_DELAY 15bit*/

//static u8 g_chan_mux[AML_ADC_SARADC_CHAN_NUM] = {0,1,2,3,4,5,6,7};



static inline void saradc_power_control(int on)
{
	//struct saradc_reg3 *reg3 = (struct saradc_reg3 *)&adc->regs->reg3;

	if (on) {
		aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,1,13,1);
		aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,3,5,2);
		aml_set_reg32_bits(PP_SAR_ADC_REG3,1,21,1);

		udelay(5);

        #if GXBB_ADC
            aml_set_reg32_bits(GXBB_CLK_REG,1,8,1);
        #else
            aml_set_reg32_bits(PP_SAR_ADC_REG3,1,30,1);
        #endif
	}	else {
		#if GXBB_ADC
			aml_set_reg32_bits(GXBB_CLK_REG,0,8,1);
		#else
			aml_set_reg32_bits(PP_SAR_ADC_REG3,0,30,1);
        #endif
		aml_set_reg32_bits(PP_SAR_ADC_REG3,0,30,1);
		/*aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,0,13,1);*//* disable bandgap */
		aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,0,5,2);
	}
}
static void saradc_internal_cal_12bit(void)
{
	int val[5]/*, nominal[5] = {0, 1024, 2048, 3072, 4096}*/;
	int i;
	int abs_val = 4096;
	unsigned int abs_num = 0;
	unsigned int abs_tmp = 0;

	/* set CAL_CNTL: 3/4 VDD*/
	aml_set_reg32_bits(PP_SAR_ADC_REG3,3,23,3);

	for (i = 0; i < 64; i++) {
		aml_set_reg32_bits(PP_SAR_ADC_REG13,i,8,6);
		udelay(5);
		val[0] = get_adc_sample_gxbb_12bit(7);
		//if (val[0] < 3000) {
			abs_tmp = abs(3000 - val[0]);
			if (abs_tmp < abs_val) {
				abs_val = abs_tmp;
				abs_num = i;
			}
		//}
	}
	aml_set_reg32_bits(PP_SAR_ADC_REG13,abs_num,8,6);
}
//#define NOT_USE_SINA_DETECT 1
//#define CLK_DIV 19

void saradc_enable(void)
{
	if (get_cpu_id().family_id <= MESON_CPU_MAJOR_ID_GXTVBB)
		flag_12bit = 0;
	else
		flag_12bit = 1;

	printf("get_cpu_id flag_12bit=%d\n",flag_12bit);
	set_reg(P_SAR_SAR_ADC_REG0, 0x84004040);
	set_reg(PP_SAR_ADC_CHAN_LIST, 0);
	/* REG2: all chanel set to 8-samples & median averaging mode */
	set_reg(PP_SAR_ADC_AVG_CNTL, 0);

	set_reg(PP_SAR_ADC_REG3, 0x9388000a);
	aml_set_reg32_bits(PP_SAR_ADC_REG3,0x14,10,5);

	/*gxl change vdd
	set_reg(PP_SAR_ADC_REG13, );
	gxl change sampling mode */
	if (flag_12bit)
		aml_set_reg32_bits(PP_SAR_ADC_REG3,0x1,27,1);


#if GXBB_ADC
	aml_write_reg32(GXBB_CLK_REG, (0<<9) | (20 << 0));
#endif
	set_reg(PP_SAR_ADC_DELAY, 0x10a000a);
	set_reg(PP_SAR_ADC_AUX_SW, 0x3eb1a0c);
	set_reg(PP_SAR_ADC_CHAN_10_SW, 0x8c000c);
	set_reg(PP_SAR_ADC_DETECT_IDLE_SW, 0xc000c);

#if AML_ADC_SAMPLE_DEBUG
	printf("ADCREG reg0 =%x\n",   get_reg(PP_SAR_ADC_REG0));
	printf("ADCREG ch list =%x\n",get_reg(PP_SAR_ADC_CHAN_LIST));
	printf("ADCREG avg  =%x\n",   get_reg(PP_SAR_ADC_AVG_CNTL));
	printf("ADCREG reg3 =%x\n",   get_reg(PP_SAR_ADC_REG3));
	printf("ADCREG ch72 sw =%x\n",get_reg(PP_SAR_ADC_AUX_SW));
	printf("ADCREG ch10 sw =%x\n",get_reg(PP_SAR_ADC_CHAN_10_SW));
	printf("ADCREG detect&idle=%x\n",get_reg(PP_SAR_ADC_DETECT_IDLE_SW));
	printf("ADCREG GXBB_CLK_REG=%x\n",get_reg(GXBB_CLK_REG));
#endif //AML_ADC_SAMPLE_DEBUG

	saradc_power_control(1);
	saradc_internal_cal_12bit();
}

void adc_set_clock(int div)
{
	aml_write_reg32(GXBB_CLK_REG, (1<<8) | (div << 0));
}


/*
static int saradc_get_cal_value(struct saradc *adc, int val)
{
	int nominal;

//	((nominal - ref_nominal) << 10) / (val - ref_val) = coef
//	==> nominal = ((val - ref_val) * coef >> 10) + ref_nominal

	nominal = val;
	if ((adc->coef > 0) && (val > 0)) {
		nominal = (val - adc->ref_val) * adc->coef;
		nominal >>= 12;
		nominal += adc->ref_nominal;
	}
	if (nominal < 0)
		nominal = 0;
	if (nominal > 1023)
		nominal = 1023;
	return nominal;
}
*/

/*use_10bit_num=1,10 bit
  use_10bit_num=0,12 bit*/
int get_adc_sample_gxbb_early(int ch, int use_10bit_num)
{
	int value, count, sum;
	//unsigned long flags;
	//int adc_state = SARADC_STATE_BUSY;

	count = 0;
	while (aml_read_reg32(PP_SAR_ADC_DELAY) & FLAG_BUSY_BL30) {
		udelay(100);
		if (++count > 100) {
			printf("bl30 busy error\n");
			value = -1;
			goto end1;
		}
	}

	aml_set_reg32_bits(PP_SAR_ADC_DELAY,1,FLAG_BUSY_KERNEL_BIT,1);
	aml_set_reg32_bits(PP_SAR_ADC_REG3,1,29,1);

    set_reg(PP_SAR_ADC_CHAN_LIST, ch);
    set_reg(PP_SAR_ADC_DETECT_IDLE_SW, (0xc000c | (ch<<23) | (ch<<7)));
    aml_set_reg32_bits(PP_SAR_ADC_REG0, 1,0,1);
    aml_set_reg32_bits(PP_SAR_ADC_REG0, 1,2,1);

    count = 0;
	do {
		udelay(10);
		if (!(aml_read_reg32(P_SAR_SAR_ADC_REG0) & 0x70000000))
			break;
		else if (++count > 10000) {
			printf("busy error=%x\n", aml_read_reg32(P_SAR_SAR_ADC_REG0));
			value = -1;
			goto end;
		}
	} while (1);

	count = 0;
	sum = 0;
	while (aml_get_reg32_bits(PP_SAR_ADC_REG0,21,5) && (count < 32)) {
		if (aml_get_reg32_bits(PP_SAR_ADC_REG0,26,1))
			printf("fifo_count, but fifo empty\n");

        value = aml_read_reg32(PP_SAR_ADC_FIFO_RD);
		if (((value>>12) & 0x07) == ch) {
			if (use_10bit_num) {
				//printf("10bit val~\n");
				if (flag_12bit) {
					value &= 0xffc;
					value >>= 2;
				} else
					value &= 0x3ff;
			} else {
				//printf("12bit val~\n");
				value &= 0xfff;
			}

			sum += value;
			count++;
		}	else
			printf("chanel error\n");
	}
	if (!aml_get_reg32_bits(PP_SAR_ADC_REG0,26,1))
		printf("fifo_count=0, but fifo not empty\n");
	if (!count) {
		value = -1;
		goto end;
	}
	value = sum / count;
	//printf("before cal: %d, count=%d\n", value, count);
	//value = saradc_get_cal_value(adc, value);
end:
	aml_set_reg32_bits(PP_SAR_ADC_REG0,1,14,1);
	aml_set_reg32_bits(PP_SAR_ADC_REG0,0,0,1);

end1:
	aml_set_reg32_bits(PP_SAR_ADC_REG3,0,29,1);
	//adc_state = SARADC_STATE_IDLE;
	aml_set_reg32_bits(PP_SAR_ADC_DELAY,0,FLAG_BUSY_KERNEL_BIT,1);
	return value;
}

int get_adc_sample_gxbb(int ch)
{
	int val;
	val = get_adc_sample_gxbb_early(ch, 1);
	return val;
}

int get_adc_sample_gxbb_12bit(int ch)
{
	int val;
	val = get_adc_sample_gxbb_early(ch, 0);
	return val;

}


int saradc_disable(void)
{
	saradc_power_control(0);
	return 0;
}
