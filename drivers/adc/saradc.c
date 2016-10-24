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
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif

//#define ENABLE_DYNAMIC_POWER

#define AML_ADC_SAMPLE_DEBUG 0
#define FDT_DEFAULT_ADDRESS  0x01000000

#ifdef  CONFIG_TARGET_MESON_GXTV
#define GXBB_CLK_REG                	0xc8100090
#define P_SAR_ADC_BASE             		0xc8100600
#else
#define GXBB_CLK_REG                	0xc883c3d8
#define P_SAR_ADC_BASE		   			0xc1108680
#endif

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
#define P_SAR_ADC_DELTA_11(base)		(base + (0xb))
#define P_SAR_ADC_REG13(base)			(base + (0xd))

#define SARADC_STATE_IDLE 0
#define SARADC_STATE_BUSY 1
#define SARADC_STATE_SUSPEND 2

#define FLAG_INITIALIZED    (1<<28)
//#define FLAG_BUSY (1<<29)
#define FLAG_BUSY_KERNEL    (1<<14) /* for kernel:SARADC_DELAY 14bit */
#define FLAG_BUSY_KERNEL_BIT  14
#define FLAG_BUSY_BL30      (1<<15) /* for bl30:SARADC_DELAY 15bit*/

typedef struct {
	unsigned char channel;
	unsigned char adc_type; /*1:12bit;0:10bit*/
	u32 __iomem *saradc_clk_addr;
	u32 __iomem *saradc_base_addr;
}saradc_info;

static saradc_info saradc_dev;

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
		if (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_GXBB) /*GXBB's clock from the clock tree.*/
			aml_set_reg32_bits(saradc->saradc_clk_addr,1,8,1);
		else
			aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),1,30,1);
	} else {
		if (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_GXBB) /*GXBB's clock from the clock tree.*/
			aml_set_reg32_bits(saradc->saradc_clk_addr,0,8,1);
		else
			aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),0,30,1);
	}
}

/*
  * description: used to set the DIV of the clock
  */
void saradc_clock_set(unsigned char val)
{
	saradc_info *saradc = saradc_dev_get();

	if (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_GXBB) { /*bit0-bit7*/
		val = val & 0xff;
		aml_write_reg32(saradc->saradc_clk_addr, (0<<9) | (val << 0));
	} else {                                                 /*bit10-bit15*/
		val = val & 0x3f;
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),val,10,5);
	}
}

static inline void saradc_power_control(int on)
{
	saradc_info *saradc = saradc_dev_get();

	if (on) {
		aml_set_reg32_bits(P_SAR_ADC_DELTA_11(saradc->saradc_base_addr),1,13,1);
		aml_set_reg32_bits(P_SAR_ADC_DELTA_11(saradc->saradc_base_addr),3,5,2);
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),1,21,1);

		udelay(5);
		saradc_clock_switch(1);
	}	else {
		saradc_clock_switch(0);
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),0,30,1);
		/*aml_set_reg32_bits(PP_SAR_ADC_DELTA_11(saradc->saradc_base_addr),0,13,1);*//* disable bandgap */
		aml_set_reg32_bits(P_SAR_ADC_DELTA_11(saradc->saradc_base_addr),0,5,2);
	}
}

void saradc_hw_init(void)
{
	saradc_info *saradc = saradc_dev_get();

	if (get_cpu_id().family_id <= MESON_CPU_MAJOR_ID_GXTVBB)
		saradc->adc_type = 0;
	else
		saradc->adc_type = 1;

	aml_write_reg32(P_SAR_ADC_REG0(saradc->saradc_base_addr), 0x84004040);
	aml_write_reg32(P_SAR_ADC_CHAN_LIST(saradc->saradc_base_addr), 0);
	/* REG2: all chanel set to 8-samples & median averaging mode */
	aml_write_reg32(P_SAR_ADC_AVG_CNTL(saradc->saradc_base_addr), 0);
	aml_write_reg32(P_SAR_ADC_REG3(saradc->saradc_base_addr), 0x9388000a);
	aml_write_reg32(P_SAR_ADC_DELAY(saradc->saradc_base_addr), 0x10a000a);
	aml_write_reg32(P_SAR_ADC_AUX_SW(saradc->saradc_base_addr), 0x3eb1a0c);
	aml_write_reg32(P_SAR_ADC_CHAN_10_SW(saradc->saradc_base_addr), 0x8c000c);
	aml_write_reg32(P_SAR_ADC_DETECT_IDLE_SW(saradc->saradc_base_addr), 0xc000c);

	if (saradc->adc_type)
		aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),0x1,27,1);

	saradc_clock_set(20);

#if AML_ADC_SAMPLE_DEBUG
	printf("ADCREG reg0 =%x\n",   aml_read_reg32(P_SAR_ADC_REG0(saradc->saradc_base_addr)));
	printf("ADCREG ch list =%x\n",aml_read_reg32(P_SAR_ADC_CHAN_LIST(saradc->saradc_base_addr)));
	printf("ADCREG avg  =%x\n",   aml_read_reg32(P_SAR_ADC_AVG_CNTL(saradc->saradc_base_addr)));
	printf("ADCREG reg3 =%x\n",   aml_read_reg32(P_SAR_ADC_REG3(saradc->saradc_base_addr)));
	printf("ADCREG ch72 sw =%x\n",aml_read_reg32(P_SAR_ADC_AUX_SW(saradc->saradc_base_addr)));
	printf("ADCREG ch10 sw =%x\n",aml_read_reg32(P_SAR_ADC_CHAN_10_SW(saradc->saradc_base_addr)));
	printf("ADCREG detect&idle=%x\n",aml_read_reg32(P_SAR_ADC_DETECT_IDLE_SW(saradc->saradc_base_addr)));
	printf("ADCREG GXBB_CLK_REG=%x\n",aml_read_reg32(saradc->saradc_clk_addr));
#endif //AML_ADC_SAMPLE_DEBUG

}

int saradc_probe(void)
{
	int ret;
	int len;
	int parent_offset;
	char *fdt_addr;
	u32 *reg_addr;
	int saradc_fdt_ready = 0;
	unsigned long temp_addr;
	saradc_info *saradc = saradc_dev_get();

#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DTB_MEM_ADDR
	fdt_addr = (char *)CONFIG_DTB_MEM_ADDR;
#else
	fdt_addr = (char *)FDT_DEFAULT_ADDRESS;
#endif
	if ((ret = fdt_check_header((const void *)fdt_addr)) < 0) {
		printf("saradc: check dts: %s, load default parameters\n",
			fdt_strerror(ret));
	}else{
		saradc_fdt_ready = 1;
	}
#endif

	if (saradc_fdt_ready) {
#ifdef CONFIG_OF_LIBFDT
		parent_offset = fdt_path_offset(fdt_addr, "/saradc");
		if (parent_offset < 0) {
			printf("saradc: not find the node /saradc: %s\n",fdt_strerror(parent_offset));
			return -1;
		}

		reg_addr = (u32 *)fdt_getprop(fdt_addr, parent_offset, "reg", &len);
		if (NULL == reg_addr) {
			printf("saradc: failed to get /saradc\n");
			return -1;
		}
	   /*
		*  To avoid error "-Werror=int-to-pointer" when this code is compiled,
		*  and use the variable of type 'unsigned long' to save the address, then cast 'unsigned long' to 'pointer' type."
		*/
		temp_addr = fdt32_to_cpu(reg_addr[5]); /*big-endian to little-endian*/
		saradc->saradc_clk_addr = (u32 __iomem *)(temp_addr & 0xffffffff);
		temp_addr = fdt32_to_cpu(reg_addr[1]); /*big-endian to little-endian*/
		saradc->saradc_base_addr = (u32 __iomem *)(temp_addr & 0xffffffff);
#endif
	} else {
		saradc->saradc_clk_addr =  (u32 __iomem *)GXBB_CLK_REG;
		saradc->saradc_base_addr = (u32 __iomem *)P_SAR_ADC_BASE;
	}

	saradc_hw_init();

	return 0;

}

static void saradc_internal_cal_12bit(void)
{
	int val[5]/*, nominal[5] = {0, 1024, 2048, 3072, 4096}*/;
	int i;
	int abs_val = 4096;
	unsigned int abs_num = 0;
	unsigned int abs_tmp = 0;
	saradc_info *saradc = saradc_dev_get();

	/* set CAL_CNTL: 3/4 VDD*/
	aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),3,23,3);

	for (i = 0; i < 64; i++) {
		aml_set_reg32_bits(P_SAR_ADC_REG13(saradc->saradc_base_addr),i,8,6);
		udelay(5);
		val[0] = get_adc_sample_gxbb_12bit(7);
		abs_tmp = abs(3000 - val[0]);
		if (abs_tmp < abs_val) {
			abs_val = abs_tmp;
			abs_num = i;
		}
	}
	aml_set_reg32_bits(P_SAR_ADC_REG13(saradc->saradc_base_addr),abs_num,8,6);
}
//#define NOT_USE_SINA_DETECT 1
//#define CLK_DIV 19

/*
  * description: used to get sampling value
  * ch: set channel
  * use_10bit_num: set the bits of the sampling value(1:10bit; 0:12bit)
  */
int get_adc_sample_gxbb_early(int ch, int use_10bit_num)
{
	int value, count, sum;
	//unsigned long flags;
	//int adc_state = SARADC_STATE_BUSY;
	saradc_info *saradc = saradc_dev_get();

	count = 0;
	while (aml_read_reg32(P_SAR_ADC_DELAY(saradc->saradc_base_addr)) & FLAG_BUSY_BL30) {
		udelay(100);
		if (++count > 100) {
			printf("bl30 busy error\n");
			value = -1;
			goto end1;
		}
	}
	saradc_clock_switch(0);
	saradc_clock_set(0xa0);
	saradc_clock_switch(1);

	aml_set_reg32_bits(P_SAR_ADC_DELAY(saradc->saradc_base_addr),1,FLAG_BUSY_KERNEL_BIT,1);
	aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),1,29,1);

	aml_write_reg32(P_SAR_ADC_CHAN_LIST(saradc->saradc_base_addr), ch);
	aml_write_reg32(P_SAR_ADC_DETECT_IDLE_SW(saradc->saradc_base_addr), (0xc000c | (ch<<23) | (ch<<7)));
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr), 1,0,1);
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr), 1,2,1);

	count = 0;
	do {
		udelay(10);
		if (!(aml_read_reg32(P_SAR_ADC_REG0(saradc->saradc_base_addr)) & 0x70000000))
			break;
		else if (++count > 10000) {
			printf("busy error=%x\n", aml_read_reg32(P_SAR_ADC_REG0(saradc->saradc_base_addr)));
			value = -1;
			goto end;
		}
	} while (1);

	count = 0;
	sum = 0;
	while (aml_get_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr),21,5) && (count < 32)) {
		if (aml_get_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr),26,1))
			printf("fifo_count, but fifo empty\n");

		value = aml_read_reg32(P_SAR_ADC_FIFO_RD(saradc->saradc_base_addr));
		if (((value>>12) & 0x07) == ch) {
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
		}	else
			printf("chanel error\n");
	}
	if (!aml_get_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr),26,1))
		printf("fifo_count=0, but fifo not empty\n");
	if (!count) {
		value = -1;
		goto end;
	}
	value = sum / count;
	//printf("before cal: %d, count=%d\n", value, count);
	//value = saradc_get_cal_value(adc, value);
end:
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr),1,14,1);
	aml_set_reg32_bits(P_SAR_ADC_REG0(saradc->saradc_base_addr),0,0,1);

	saradc_clock_switch(0);
	saradc_clock_set(20);
	saradc_clock_switch(1);

end1:
	aml_set_reg32_bits(P_SAR_ADC_REG3(saradc->saradc_base_addr),0,29,1);
	//adc_state = SARADC_STATE_IDLE;
	aml_set_reg32_bits(P_SAR_ADC_DELAY(saradc->saradc_base_addr),0,FLAG_BUSY_KERNEL_BIT,1);
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

int saradc_enable(void)
{
	saradc_probe();
	saradc_power_control(1);
	saradc_internal_cal_12bit();
	return 0;
}

int saradc_disable(void)
{
	saradc_power_control(0);
	return 0;
}
