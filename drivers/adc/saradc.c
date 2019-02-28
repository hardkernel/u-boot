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
 */
#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <asm/saradc.h>
#include <asm/cpu_id.h>
#include <asm/arch/secure_apb.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif

#define FDT_DEFAULT_ADDRESS  0x01000000

#define P_SAR_ADC_REG0(base)		    (base + (0x0))
#define P_SAR_ADC_CHAN_LIST(base)		(base + (0x1))
#define P_SAR_ADC_AVG_CNTL(base)		(base + (0x2))
#define P_SAR_ADC_REG3(base)			(base + (0x3))
#define P_SAR_ADC_DELAY(base)			(base + (0x4))
#define P_SAR_ADC_LAST_RD(base)			(base + (0x5))
#define P_SAR_ADC_FIFO_RD(base)			(base + (0x6))
#define P_SAR_ADC_AUX_SW(base)			(base + (0x7))
#define P_SAR_ADC_CHAN_10_SW(base)		(base + (0x8))
#define P_SAR_ADC_DETECT_IDLE_SW(base)	(base + (0x9))
#define P_SAR_ADC_DELTA_10(base)		(base + (0xa))
#define P_SAR_ADC_REG11(base)			(base + (0xb))
#define P_SAR_ADC_REG13(base)			(base + (0xd))

#define FLAG_BUSY_KERNEL    (1 << 14) /* for kernel:SARADC_DELAY 14bit */
#define FLAG_BUSY_KERNEL_BIT  14
#define FLAG_BUSY_BL30      (1 << 15) /* for bl30:SARADC_DELAY 15bit*/

static const char * const ch7_vol[] = {
	"gnd",
	"vdd/4",
	"vdd/2",
	"vdd*3/4",
	"vdd",
};

typedef struct {
	unsigned char channel;
	unsigned char adc_type; /*1:12bit; 0:10bit*/
	unsigned short family_id;
	u32 __iomem *clk_addr;
	u32 __iomem *base_addr;
}saradc_info;

static saradc_info saradc_dev;

static __inline__ void aml_set_reg32_bits(volatile unsigned int *_reg,
		const uint32_t _value,
		const uint32_t _start,
		const uint32_t _len)
{
	writel(((readl((volatile unsigned int *)_reg) & \
		~(((1L << (_len) )-1) << (_start))) | \
		((unsigned)((_value) & ((1L<<(_len))-1)) << (_start))),
		(volatile void *)_reg);
}
static __inline__ uint32_t aml_get_reg32_bits(volatile unsigned int *_reg,
		const uint32_t _start,
		const uint32_t _len)
{
	return	((readl((volatile unsigned int *)_reg) >> (_start)) & \
		((1L << (_len) ) - 1));
}
static __inline__ void aml_write_reg32(volatile unsigned int *_reg,
		const uint32_t _value)
{
	writel(_value, (volatile unsigned int *)_reg );
};
static __inline__ uint32_t aml_read_reg32(volatile unsigned int *_reg)
{
	return readl((volatile unsigned int *)_reg);
};

saradc_info *saradc_dev_get(void)
{
	return &saradc_dev;
}

/*
  * description: used to enable and disable the clock of the SARADC
  * onoff: 1: enable ; 0: disable
  */
void saradc_clock_switch( int onoff)
{
	saradc_info *saradc = saradc_dev_get();

	if (onoff) {
		if (saradc->family_id >= MESON_CPU_MAJOR_ID_GXBB)
			aml_set_reg32_bits(saradc->clk_addr, 1, 8, 1);
		else
			aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr), 1, 30, 1);
	} else {
		if (saradc->family_id >= MESON_CPU_MAJOR_ID_GXBB)
			aml_set_reg32_bits(saradc->clk_addr, 0, 8, 1);
		else
			aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr), 0, 30, 1);
	}
}

/*
 * description: used to set the DIV of the clock
 */
void saradc_clock_set(unsigned char val)
{
	saradc_info *saradc = saradc_dev_get();

	if (saradc->family_id >= MESON_CPU_MAJOR_ID_GXBB) {
		/*bit[0-7]: set clk div; bit[9-10]: select clk source*/
		aml_set_reg32_bits(saradc->clk_addr, 0, 9, 2);
		aml_set_reg32_bits(saradc->clk_addr, (val & 0xff), 0, 8);
	} else {
		/*bit10-bit15: set clk div*/
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr),
			(val & 0x3f), 10, 6);
	}
}

static inline void saradc_power_control(int on)
{
	saradc_info *saradc = saradc_dev_get();

	if (on) {
		aml_set_reg32_bits(P_SAR_ADC_REG11(saradc->base_addr), 1, 13, 1);
		if (saradc->family_id >= MESON_CPU_MAJOR_ID_G12A)
			aml_set_reg32_bits(P_SAR_ADC_REG11(saradc->base_addr), 0, 5, 2);
		else
			aml_set_reg32_bits(P_SAR_ADC_REG11(saradc->base_addr), 3, 5, 2);
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr), 1, 21, 1);

		udelay(5);
		saradc_clock_switch(1);
	}	else {
		saradc_clock_switch(0);
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr), 0, 21, 1);
		/*aml_set_reg32_bits(PP_SAR_ADC_REG11(saradc->base_addr),0,13,1);*/
		/*aml_set_reg32_bits(P_SAR_ADC_REG11(saradc->base_addr),0,5,2);*/
	}
}

void saradc_hw_init(void)
{
	saradc_info *saradc = saradc_dev_get();

	if (saradc->family_id <= MESON_CPU_MAJOR_ID_GXTVBB)
		saradc->adc_type = 0;
	else
		saradc->adc_type = 1;

	aml_write_reg32(P_SAR_ADC_REG0(saradc->base_addr), 0x84004040);
	aml_write_reg32(P_SAR_ADC_CHAN_LIST(saradc->base_addr), 0);
	/* REG2: all chanel set to 8-samples & median averaging mode */
	aml_write_reg32(P_SAR_ADC_AVG_CNTL(saradc->base_addr), 0);
	aml_write_reg32(P_SAR_ADC_REG3(saradc->base_addr), 0x9388000a);
	aml_write_reg32(P_SAR_ADC_DELAY(saradc->base_addr), 0x10a000a);
	aml_write_reg32(P_SAR_ADC_AUX_SW(saradc->base_addr), 0x3eb1a0c);
	aml_write_reg32(P_SAR_ADC_CHAN_10_SW(saradc->base_addr), 0x8c000c);
	aml_write_reg32(P_SAR_ADC_DETECT_IDLE_SW(saradc->base_addr), 0xc000c);

	if (saradc->adc_type)
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr), 0x1, 27, 1);

	/* REG11 bit[1] must be set to <1> for g12a and later SoCs */
	if (saradc->family_id >= MESON_CPU_MAJOR_ID_G12A)
		aml_set_reg32_bits(P_SAR_ADC_REG11(saradc->base_addr), 0x1, 1, 1);

	/* select the VDDA as Vref for txlx and later SoCs */
	if (saradc->family_id != MESON_CPU_MAJOR_ID_GXLX &&
			saradc->family_id >= MESON_CPU_MAJOR_ID_TXLX)
		aml_set_reg32_bits(P_SAR_ADC_REG11(saradc->base_addr), 0x1, 0, 1);

	saradc_clock_set(20);
}

int saradc_probe(void)
{
	saradc_info *saradc = saradc_dev_get();

	saradc->family_id = get_cpu_id().family_id;
	saradc->clk_addr  = (u32 __iomem *)AO_SAR_CLK;
	saradc->base_addr = (u32 __iomem *)AO_SAR_ADC_REG0;

	saradc_hw_init();

	return 0;
}

static void saradc_internal_cal_12bit(void)
{
	/*reference voltage has been calibrated by BL2, there is nothing to do*/
}

int saradc_value_trim(int val)
{
	int tmp;
	saradc_info *saradc = saradc_dev_get();

	switch (saradc->family_id) {
	case MESON_CPU_MAJOR_ID_GXL:
	case MESON_CPU_MAJOR_ID_GXM:
	case MESON_CPU_MAJOR_ID_TXL:
		tmp = val * 3072 / 2764;
		return (tmp < 1024) ? tmp : 1023;
	break;

	default:
		return val;
	break;
	}
}

/*
  * description: used to get sample value
  * ch: set channel
  * use_10bit_num: set the bits of the sample value(1:10bit; 0:12bit)
  */
int get_adc_sample_gxbb_early(int ch, int use_10bit_num)
{
	int value, count, sum;
	saradc_info *saradc = saradc_dev_get();

	count = 0;

	while (aml_read_reg32(P_SAR_ADC_DELAY(saradc->base_addr)) & FLAG_BUSY_BL30) {
		udelay(10);
		if (++count > 1000) {
			printf("bl30 busy error\n");
			value = -1;
			goto end1;
		}
	}

	aml_set_reg32_bits(P_SAR_ADC_DELAY(saradc->base_addr), 1,
		FLAG_BUSY_KERNEL_BIT, 1);

	saradc_clock_switch(0);
	saradc_clock_set(0xa0);
	saradc_clock_switch(1);

	aml_write_reg32(P_SAR_ADC_CHAN_LIST(saradc->base_addr), ch);
	aml_write_reg32(P_SAR_ADC_DETECT_IDLE_SW(saradc->base_addr),
		(0xc000c | (ch<<23) | (ch<<7)));
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->base_addr), 1, 0, 1);
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->base_addr), 1, 2, 1);
	count = 0;
	do {
		udelay(10);
		if (!(aml_read_reg32(P_SAR_ADC_REG0(saradc->base_addr)) & 0x70000000))
			break;
		else if (++count > 10000) {
			printf("busy error = %x\n",
				aml_read_reg32(P_SAR_ADC_REG0(saradc->base_addr)));
			value = -1;
			goto end;
		}
	} while (1);

	count = 0;
	sum = 0;
	while (aml_get_reg32_bits(P_SAR_ADC_REG0(saradc->base_addr), 21, 5) && \
			(count < 32)) {
		value = aml_read_reg32(P_SAR_ADC_FIFO_RD(saradc->base_addr));
		if (((value >> 12) & 0x07) == ch) {
			if (use_10bit_num) {
				//printf("10bit val~\n");
				if (saradc->adc_type) {
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
		} else
			printf("channel error\n");
	}

	if (!count) {
		value = -1;
		goto end;
	}
	value = sum / count;
end:
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->base_addr), 1, 14, 1);
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->base_addr), 0, 0, 1);

	saradc_clock_switch(0);
	saradc_clock_set(20);
	saradc_clock_switch(1);

end1:
	aml_set_reg32_bits(P_SAR_ADC_DELAY(saradc->base_addr), 0,
		FLAG_BUSY_KERNEL_BIT, 1);

	return saradc_value_trim(value);
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

int saradc_enable(void)
{
	saradc_probe();
	saradc_power_control(1);
	udelay(10);
	saradc_internal_cal_12bit();
	return 0;
}

int saradc_disable(void)
{
	saradc_power_control(0);
	return 0;
}

void saradc_sample_test(void)
{
	int i;
	int val;
	saradc_info *saradc = saradc_dev_get();

	printf("ch7 sample test:\n");
	saradc_enable();
	for (i = 0; i < ARRAY_SIZE(ch7_vol); i++) {
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->base_addr), i, 23, 3);
		udelay(10);
		val = get_adc_sample_gxbb(7);
		printf("%-7s : %d\n", ch7_vol[i], val);
	}
	saradc_disable();
}
