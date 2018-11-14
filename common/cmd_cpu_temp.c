
/*
 * common/cmd_cpu_temp.c
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

#include <common.h>
#include <asm/io.h>
#include <asm/arch/efuse.h>
#include <command.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/mailbox.h>
#include <asm/arch/thermal.h>
#include <asm/cpu_id.h>

#ifdef CONFIG_AML_MESON_TXHD
#define NEW_THERMAL_MODE 1
#endif

#ifdef CONFIG_AML_MESON_G12A
#define R1P1_TSENSOR_MODE 1
#endif

//#define HHI_SAR_CLK_CNTL    0xc883c000+0xf6*4 //0xc883c3d8
int temp_base = 27;
#define NUM 30
uint32_t vref_en = 0;
uint32_t trim = 0;
int saradc_vref = -1;

#define MANUAL_POWER 1  //not use vref, use 1.8V power

int r1p1_read_entry(void);
int r1p1_trim_entry(int tempbase, int tempver);

static int get_tsc(int temp)
{
	int vmeasure, TS_C;
	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXBB:
	case MESON_CPU_MAJOR_ID_GXTVBB:
		/*TS_C = (adc-435)/8.25+16*/
		vmeasure = temp - (435 + (temp_base - 27) * 3.4);
		printf("vmeasure=%d\n", vmeasure);
		TS_C = ((vmeasure) / 8.25) + 16;
		break;
	case MESON_CPU_MAJOR_ID_GXL:
	case MESON_CPU_MAJOR_ID_GXM:
	case MESON_CPU_MAJOR_ID_GXLX:
		if (vref_en) {
			/*TS_C = 16-(adc-1655)/37.6*/
			vmeasure = temp - (1655 + (temp_base - 27) * 15.3);
			printf("vmeasure=%d\n", vmeasure);
			TS_C = 16 - ((vmeasure) / 37.6);
			break;
		} else {
			/*TS_C = 16-(adc-1778)/42*/
			vmeasure = temp - (1778 + (temp_base - 27) * 17);
			printf("vmeasure=%d\n", vmeasure);
			TS_C = 16 - ((vmeasure) / 42);
			break;
		}
	case MESON_CPU_MAJOR_ID_TXL:
		/*TS_C = 16-(adc-1530)/40*/
		vmeasure = temp - (1530 + (temp_base - 27) * 15.5);
		printf("vmeasure=%d\n", vmeasure);
		TS_C = 16-((vmeasure)/40);
		break;
	case MESON_CPU_MAJOR_ID_TXLX:
	case MESON_CPU_MAJOR_ID_AXG:
	case MESON_CPU_MAJOR_ID_TXHD:
		/*TS_C = 16-(adc-1750)/42*/
		vmeasure = temp - (1750 + (temp_base - 27) * 17);
		printf("vmeasure=%d\n", vmeasure);
		TS_C = 16 - ((vmeasure) / 42);
		break;
	default:
		printf("cpu family id not support!!!\n");
		return -1;
	}

	if (TS_C > 31)
		TS_C = 31;
	else if (TS_C < 0)
		TS_C = 0;
	printf("TS_C=%d\n", TS_C);
	return TS_C;
}

static int adc_init_chan6(void)
{
	#ifdef MANUAL_POWER
	int ver = (readl(SEC_AO_SEC_SD_CFG12) >> 24) & 0xff;
	#endif
	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXBB:
	case MESON_CPU_MAJOR_ID_GXTVBB:
		writel(0x002c2000, SAR_ADC_REG11);/*bit20: test mode disabled*/
		writel(0x00000006, SAR_ADC_CHAN_LIST);
		writel(0x00003000, SAR_ADC_AVG_CNTL);
		writel(0xc3a8500a, SAR_ADC_REG3);
		writel(0x010a000a, SAR_ADC_DELAY);
		writel(0x03eb1a0c, SAR_ADC_AUX_SW);
		writel(0x008c000c, SAR_ADC_CHAN_10_SW);
		writel(0x030e030c, SAR_ADC_DETECT_IDLE_SW);
		writel(0x0c00c400, SAR_ADC_DELTA_10);
		writel(0x00000114, SAR_CLK_CNTL);        /* Clock */
		writel(readl(0xc110868c) | (0x1 << 28), SAR_ADC_REG3);
		break;
	case MESON_CPU_MAJOR_ID_GXL:
	case MESON_CPU_MAJOR_ID_GXM:
	case MESON_CPU_MAJOR_ID_GXLX:
		writel(0x002c2060, SAR_ADC_REG11);/*bit20 disabled*/
		writel(0x00000006, SAR_ADC_CHAN_LIST);/*channel 6*/
		writel(0x00003000, SAR_ADC_AVG_CNTL);
		writel(0xc8a8500a, SAR_ADC_REG3);/*bit27:0*/
		writel(0x010a000a, SAR_ADC_DELAY);
		writel(0x03eb1a0c, SAR_ADC_AUX_SW);
		writel(0x008c000c, SAR_ADC_CHAN_10_SW);
		writel(0x030e030c, SAR_ADC_DETECT_IDLE_SW);
		writel(0x0c00c400, SAR_ADC_DELTA_10);
		writel(0x00000114, SAR_CLK_CNTL);/*Clock*/
		break;
	case MESON_CPU_MAJOR_ID_TXL:
		writel(0x00000006, SAR_ADC_CHAN_LIST);/*channel 6*/
		writel(0x00003000, SAR_ADC_AVG_CNTL);
		writel(0xc8a8500a, SAR_ADC_REG3);/*bit27:1 disable*/
		writel(0x010a000a, SAR_ADC_DELAY);
		writel(0x03eb1a0c, SAR_ADC_AUX_SW);
		writel(0x008c000c, SAR_ADC_CHAN_10_SW);
		writel(0x030e030c, SAR_ADC_DETECT_IDLE_SW);
		writel(0x0c00c400, SAR_ADC_DELTA_10);
		writel(0x00000110, SAR_CLK_CNTL);/*Clock*/
		writel(0x002c2060, SAR_ADC_REG11);/*bit20 disabled*/
		break;
	case MESON_CPU_MAJOR_ID_TXLX:
		writel(0x00000006, SAR_ADC_CHAN_LIST);/*channel 6*/
		writel(0x00003000, SAR_ADC_AVG_CNTL);
		writel(0xc8a8500a, SAR_ADC_REG3);/*bit27:1 disable*/
		writel(0x010a000a, SAR_ADC_DELAY);
		writel(0x03eb1a0c, SAR_ADC_AUX_SW);
		writel(0x008c000c, SAR_ADC_CHAN_10_SW);
		writel(0x030e030c, SAR_ADC_DETECT_IDLE_SW);
		writel(0x0c00c400, SAR_ADC_DELTA_10);
		writel(0x00000110, SAR_CLK_CNTL);/*Clock*/
		writel(0x002c2060, SAR_ADC_REG11);/*bit20 disabled*/
		#ifndef MANUAL_POWER
		if (ver != 0xa0)
		#endif
		writel(readl(SAR_ADC_REG11) | 0x1, SAR_ADC_REG11);/*manual trim use 1.8V*/
		break;
	case MESON_CPU_MAJOR_ID_AXG:
	case MESON_CPU_MAJOR_ID_TXHD:
		writel(0x00000006, SAR_ADC_CHAN_LIST);/*channel 6*/
		writel(0x00003000, SAR_ADC_AVG_CNTL);
		writel(0xc8a8500a, SAR_ADC_REG3);/*bit27:1 disable*/
		writel(0x010a000a, SAR_ADC_DELAY);
		writel(0x03eb1a0c, SAR_ADC_AUX_SW);
		writel(0x008c000c, SAR_ADC_CHAN_10_SW);
		writel(0x030e030c, SAR_ADC_DETECT_IDLE_SW);
		writel(0x0c00c400, SAR_ADC_DELTA_10);
		writel(0x00000110, SAR_CLK_CNTL);/*Clock*/
		writel(0x002c2060, SAR_ADC_REG11);/*bit20 disabled*/
		#ifdef MANUAL_POWER
		if ((ver != 0x9) || (ver != 0xa) || (ver != 0xb))/*ft trim no use 1.8v*/
		#endif
		writel(readl(SAR_ADC_REG11) | 0x1, SAR_ADC_REG11);/*manual trim use 1.8V*/
		break;
	default:
		printf("cpu family id not support!!!\n");
		return -1;
	}
	return 0;
}

static int get_adc_sample(int chan)
{
	unsigned value;
	int count = 0;

	if (!(readl(SAR_CLK_CNTL) & (1 << 8)))/*check and open clk*/
		writel(readl(SAR_CLK_CNTL) | (1 << 8), SAR_CLK_CNTL);
	if (!(readl(SAR_BUS_CLK_EN) & (1 << EN_BIT)))/*check and open clk*/
		writel(readl(SAR_BUS_CLK_EN) | (1 << EN_BIT), HHI_GCLK_MPEG2);

	/*adc reg4 bit14~15: read adc sample value flag*/
	/*0x21a4: bit14: kernel  bit15: bl30*/
	for (; count <= 100; count++) {
		if (count == 100) {
			printf("%s: get flag timeout!\n",__func__);
			return -1;
		}

		if (!((readl(SAR_ADC_DELAY) >> 14) & 3)) {
			writel(readl(SAR_ADC_DELAY) | (FLAG_BUSY_BL30),
				   SAR_ADC_DELAY);
			if (((readl(SAR_ADC_DELAY) >> 14) & 3) != 0x2)
				/*maybe kernel set flag, try again*/
				writel(readl(SAR_ADC_DELAY) & (~(FLAG_BUSY_BL30)),
				SAR_ADC_DELAY);
			else
				break;/*set bl30 read flag ok*/
		} else{/*kernel set flag, clear bl30 flag and wait*/
			writel(readl(SAR_ADC_DELAY) & (~(FLAG_BUSY_BL30)),
				SAR_ADC_DELAY);
			udelay(20);
		}
	}
#ifndef CONFIG_CHIP_AML_GXB
	/* if thermal VREF(5 bits) is not zero, write it to SAR_ADC_REG13[13:9]
	 * and set SAR_ADC_REG13[8]:0, chipid >= GXL
	 */
	if (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_GXL) {
		saradc_vref = (readl(SAR_ADC_REG13) >> 8) & 0x3f; /*back up SAR_ADC_REG13[13:8]*/
		if ((readl(AO_SEC_SD_CFG12) >> 19) & 0x1f) { /*thermal VREF*/
			writel(((readl(SAR_ADC_REG13)) & (~(0x3f << 8))) /*SAR_ADC_REG13[8]:0*/
				|(((readl(AO_SEC_SD_CFG12) >> 19) & 0x1f) << 9), /*SAR_ADC_REG13[13:9]*/
				SAR_ADC_REG13);
			vref_en = 1;
		} else if ((get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_TXL)&&
			((trim == 1)||
			((((readl(SEC_AO_SEC_SD_CFG12)) >> 24) & 0xff) == 0xc0))) {
			writel(((readl(SAR_ADC_REG13)) & (~(0x3f << 8))) /*SAR_ADC_REG13[13:8]:0*/
				| (0x1e << 8), /*SAR_ADC_REG13[13:8]:[0x1e]*/
				SAR_ADC_REG13);
		} else {
			writel((readl(SAR_ADC_REG13)) & (~(0x3f << 8)), SAR_ADC_REG13);
		}
	}
#endif
	writel(0x00000006, SAR_ADC_CHAN_LIST);/*channel 6*/
	writel(0xc000c | (0x6 << 23) | (0x6 << 7), SAR_ADC_DETECT_IDLE_SW);/*channel 6*/

	writel((readl(SAR_ADC_REG0) & (~(1 << 0))), SAR_ADC_REG0);
	writel((readl(SAR_ADC_REG0)|(1 << 0)), SAR_ADC_REG0);
	writel((readl(SAR_ADC_REG0)|(1 << 2)), SAR_ADC_REG0);/*start sample*/

	count = 0;
	do {
		udelay(20);
		count++;
	} while ((readl(SAR_ADC_REG0) & (0x7 << 28))
		&& (count < 100));/*finish sample?*/
	if (count == 100) {
		writel(readl(SAR_ADC_REG3) & (~(1 << 29)), SAR_ADC_REG3);
		printf("%s: wait finish sample timeout!\n",__func__);
		return -1;
	}

	value = readl(SAR_ADC_FIFO_RD);
#ifndef CONFIG_CHIP_AML_GXB
	if (saradc_vref >= 0) /*write back SAR_ADC_REG13[13:8]*/
		writel(((readl(SAR_ADC_REG13)) & (~(0x3f << 8))) |
				((saradc_vref & 0x3f) << 8),
				SAR_ADC_REG13);
#endif
	writel(readl(SAR_ADC_DELAY) & (~(FLAG_BUSY_BL30)), SAR_ADC_DELAY);
	if (((value >> 12) & 0x7) == 0x6)
		value = value & SAMPLE_BIT_MASK;
	else{
		value = -1;
		printf("%s:sample value err! ch:%d, flag:%d\n", __func__,
			((value>>12) & 0x7), ((readl(SAR_ADC_DELAY) >> 14) & 3));
	}
	return value;
}

static unsigned int get_cpu_temp(int tsc, int flag)
{
	unsigned value;
	if (flag) {
		value = readl(SAR_ADC_REG11);
	  writel(((value&(~(0x1f << 14))) | ((tsc & 0x1f) << 14)), SAR_ADC_REG11);
	  /* bit[14-18]:tsc */
	} else{
		value = readl(SAR_ADC_REG11);
	  writel(((value&(~(0x1f << 14))) | (0x10 << 14)), SAR_ADC_REG11);
	  /* bit[14-18]:0x16 */
	}
	return  get_adc_sample(6);
}

void quicksort(int a[], int numsize)
{
	int i = 0, j = numsize - 1;
	int val = a[0];
	if (numsize > 1) {
		while (i < j) {
			for (; j > i; j--)
				if (a[j] < val) {
					a[i] = a[j];
					break;
				}
			for (; i < j; i++)
				if (a[i] > val) {
					a[j] = a[i];
					break;
				}
		}
	a[i] = val;
	quicksort(a, i);
	quicksort(a + i + 1, numsize - 1 - i);
}
}

static unsigned do_read_calib_data(int *flag, int *temp, int *TS_C)
{
	char buf[2];
	unsigned ret;
	*flag = 0;
	buf[0] = 0; buf[1] = 0;

	char flagbuf;

	ret = readl(AO_SEC_SD_CFG12);
	flagbuf = (ret >> 24) & 0xff;
	if (((int)flagbuf != 0xA0) && ((int)flagbuf != 0x40)
		&& ((int)flagbuf != 0xC0)
		&& ((int)flagbuf != 0x05) && ((int)flagbuf != 0x06)
		&& ((int)flagbuf != 0x07) && ((int)flagbuf != 0x09)
		&& ((int)flagbuf != 0x0a) && ((int)flagbuf != 0x0b)
		&& ((int)flagbuf != 0x0d) && ((int)flagbuf != 0x0e)
		&& ((int)flagbuf != 0x0f)
		) {
		if (flagbuf)
			printf("thermal ver flag error!\n");
		printf("flagbuf is 0x%x!\n", flagbuf);
		return 0;
	}

	buf[0] = (ret) & 0xff;
	buf[1] = (ret >> 8) & 0xff;

	*temp = buf[1];
	*temp = (*temp << 8) | buf[0];
	*TS_C =  *temp & 0x1f;
	*flag = (*temp & 0x8000) >> 15;
	*temp = (*temp & 0x7fff) >> 5;

	if ((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXBB)
		&&(0x40 == (int)flagbuf))/*ver2*/
		*TS_C = 16;

	if (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_GXL)
		*temp = (*temp) << 2; /*adc 12bit sample*/

	printf("adc=%d,TS_C=%d,flag=%d\n", *temp, *TS_C, *flag);
	return ret;
}
#if defined(NEW_THERMAL_MODE)
static unsigned int do_read_calib_data1(unsigned int *ver, unsigned int *u_efuse)
{
	char buf[2];
	unsigned ret;
	buf[0] = 0; buf[1] = 0;

	ret = readl(AO_SEC_GP_CFG10);
	*ver = (ret >> 24) & 0xff;
	if ((*ver != 0x05) && ((int)*ver != 0x06)
		&& ((int)*ver != 0x07) && ((int)*ver != 0x0d)
		&& ((int)*ver != 0x0e) && ((int)*ver != 0x0f)
		&& ((int)*ver != 0x09) && ((int)*ver != 0x0a)
		&& ((int)*ver != 0x0b)) {
		if (ver)
			printf("thermal ver flag error!\n");
		printf("ver is 0x%x!\n", *ver);
		return 0;
	}

	buf[0] = (ret) & 0xff;
	buf[1] = (ret >> 8) & 0xff;

	*u_efuse = buf[1];
	*u_efuse = (*u_efuse << 8) | buf[0];
	return ret;
}
#endif

#if defined(NEW_THERMAL_MODE)
static int write_trim1(void)
{
	unsigned int ret,ver, u_efuse;//, ret;
	unsigned int signbit;
	unsigned long value,tmp1,tmp2;
	int family_id;

	family_id = get_cpu_id().family_id;
	switch (get_cpu_id().family_id) {
		case MESON_CPU_MAJOR_ID_TXHD:
			writel(1 << 7 | (0x30), HHI_TS_CLK_CNTL); /*clk:0.5M*/
			writel(0x50ab, TS_CFG_REG);/*0x50ab is enable the new thermal mudule*/
			break;
		default:
			printf("cpu xxxx family id not support!!! id: %d\n", family_id);
			return -1;
		}
	mdelay(5); /*at least 4.2ms*/

	ret = do_read_calib_data1(&ver, &u_efuse);
	if (ret) {
		printf("This chip has trimmed!!!\n");
		return -1;
	}

	value = readl(TS_YOUT);
	printf("value: 0x%lx\n",value);
	value = value & (0xffff);/*maybe the value need to read more times*/
	printf("temp_base: %d\n",temp_base);

	printf("YOUT: 0x%lx\n", value);
	if ((value < 0x18a9) || (value > 0x31c0)) { /*-20~125 ideal yout*/
		printf("%s : YOUT: 0x%lx out of range! ERROR! \n",__func__,value);
		return -1;
	}

	/* T = (727.8*(5.05*Yout)/((1<<16)+4.05*Yout)) - 274.7 */
	/* u_efuse = u_ideal - u_real */
	tmp1 = ((temp_base * 10 + 2747) * (1 << 16)) / 7278; /*ideal u*/
	printf("%s : tmp1: 0x%lx\n", __func__, tmp1);
	tmp2 = (505 * value * (1 << 16)) / ((1 << 16) * 100 + 405 * value);
	printf("%s : tmp2: 0x%lx\n", __func__, tmp2);
	signbit = ((tmp1 > tmp2) ? 0 : 1);
	u_efuse = (tmp1 > tmp2) ? (tmp1 - tmp2) : (tmp2 - tmp1);
	u_efuse = (signbit << 15) | u_efuse;
	printf("%s : u_efuse: 0x%x\n", __func__, u_efuse);

	ret = thermal_calibration(2, u_efuse);
	return ret;
}
#endif

static int write_trim0(void)
{
	int temp = 0;
	int temp1[NUM];
	char buf[2];
	unsigned int data;
	int i, TS_C;
	int ret;
	int flag;

	memset(temp1, 0, NUM);

	ret = adc_init_chan6();
	if (ret)
		goto err;

	ret = do_read_calib_data(&flag, &temp, &TS_C);
	if (ret) {
		printf("chip has trimed!!!\n");
		return -1;
	} else {
		printf("chip is not triming! triming now......\n");
		flag = 0;
		temp = 0;
		TS_C = 0;
		trim = 1;
	}
	for (i = 0; i < NUM; i++) {
		udelay(10000);
		/*adc sample value*/
		temp1[i] = get_cpu_temp(16, 0);
	}

	printf("raw data\n");
	for (i = 0; i < NUM; i++)
		printf("%d ", temp1[i]);

	printf("\nsort  data\n");

	quicksort(temp1, NUM);
	for (i = 0; i < NUM; i++)
		printf("%d ", temp1[i]);
	printf("\n");
	for (i = 2; i < NUM - 2; i++)
		temp += temp1[i];
	temp = temp / (NUM - 4);
	printf("the adc cpu adc=%d\n", temp);

/**********************************/
	TS_C = get_tsc(temp);
	if ((TS_C == 31) || (TS_C <= 0)) {
		printf("TS_C: %d NO Trim! Bad chip!Please check!!!\n", TS_C);
		goto err;
	}
/**********************************/
	temp = 0;
	memset(temp1, 0, NUM);
	/* flag=1; */
	for (i = 0; i < NUM; i++) {
		udelay(10000);
		temp1[i] = get_cpu_temp(TS_C, 1);
	}
	printf("use triming  data\n");
	quicksort(temp1, NUM);
	for (i = 0; i < NUM; i++)
		printf("%d ", temp1[i]);
	printf("\n");
	for (i = 2; i < NUM-2; i++)
		temp += temp1[i];
	temp = temp / (NUM - 4);
	printf("the adc cpu adc=%d\n", temp);

/**************recalculate to 27******/
	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXBB:
	case MESON_CPU_MAJOR_ID_GXTVBB:
		temp = temp - 3.4 * (temp_base - 27);
		break;
	case MESON_CPU_MAJOR_ID_GXL:/*12bit*/
	case MESON_CPU_MAJOR_ID_GXM:
	case MESON_CPU_MAJOR_ID_GXLX:
		if (vref_en) {
			temp = temp - 15.3*(temp_base - 27);
			temp = temp >> 2;/*efuse only 10bit adc*/
			break;
		} else {
			temp = temp - 17 * (temp_base - 27);
			temp = temp >> 2;/*efuse only 10bit adc*/
			break;
		}
	case MESON_CPU_MAJOR_ID_TXL:
		temp = temp - 15.5 * (temp_base - 27);
		temp = temp >> 2;/*efuse only 10bit adc*/
		break;
	case MESON_CPU_MAJOR_ID_TXLX:
	case MESON_CPU_MAJOR_ID_AXG:
	case MESON_CPU_MAJOR_ID_TXHD:
		temp = temp - 17 * (temp_base - 27);
		temp = temp >> 2;/*efuse only 10bit adc*/
		break;
	default:
		printf("cpu family id not support, thermal0!!!\n");
		goto err;
	}
/**********************************/
	temp = ((temp << 5) | (TS_C & 0x1f)) & 0xffff;
/* write efuse tsc,flag */
	buf[0] = (char)(temp & 0xff);
	buf[1] = (char)((temp >> 8) & 0xff);
	buf[1] |= 0x80;
	printf("buf[0]=%x,buf[1]=%x\n", buf[0], buf[1]);
	data = buf[1] << 8 | buf[0];
	ret = thermal_calibration(0, data);
	return ret;
err:
	return -1;
}

static int do_write_trim(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
#if defined(NEW_THERMAL_MODE)
	unsigned int choose = simple_strtoul(argv[1], NULL, 10);
#endif
	int ret;

#if defined(NEW_THERMAL_MODE)
	if (choose == 1) {
		printf("%s: will trim thermal1.....\n",__func__);
		ret = write_trim1();
	} else
#endif
	{
		printf("%s: will trim thermal0.....\n",__func__);
		ret = write_trim0();
	}

	return ret;
}

static int read_temp0(void)
{
	int temp;
	int TS_C;
	int flag, adc, count, tempa;
	unsigned ret;
	flag = 0;
	char buf[100] = {};

	setenv("tempa", " ");
	adc_init_chan6();
	ret = do_read_calib_data(&flag, &temp, &TS_C);
	if (ret) {
		adc = 0;
		count = 0;
		while (count < 64) {
			adc += get_cpu_temp(TS_C, flag);
			count++;
			udelay(200);
		}
		adc /= count;
		tempa = 0;
		printf("adc=%d\n", adc);
		if (flag) {
			switch (get_cpu_id().family_id) {
			case MESON_CPU_MAJOR_ID_GXBB:
			case MESON_CPU_MAJOR_ID_GXTVBB:
				tempa = (10 * (adc-temp)) / 34 + 27;
				break;
			case MESON_CPU_MAJOR_ID_GXL:
			case MESON_CPU_MAJOR_ID_GXM:
			case MESON_CPU_MAJOR_ID_GXLX:
				if (vref_en)/*thermal VREF*/
					tempa = (10 * (adc - temp)) / 153 + 27;
				else
					tempa = (10 * (adc - temp)) / 171 + 27;
				break;
			case MESON_CPU_MAJOR_ID_TXL:
				tempa = (10 * (adc - temp)) / 155 + 27;
				break;
			case MESON_CPU_MAJOR_ID_TXLX:
			case MESON_CPU_MAJOR_ID_AXG:
			case MESON_CPU_MAJOR_ID_TXHD:
				tempa = (adc - temp) / 17 + 27;
				break;
			default:
				printf("cpu family id not support!!!\n");
				return -1;
			}
			printf("tempa=%d\n", tempa);

			sprintf(buf, "%d", tempa);
			setenv("tempa", buf);
			memset(buf, 0, sizeof(buf));
			sprintf(buf, "temp:%d, adc:%d, tsc:%d, dout:%d", tempa, adc, TS_C, temp);
			setenv("err_info_tempa", buf);
		} else {
			printf("This chip is not trimmed\n");
			sprintf(buf, "%s", "This chip is not trimmed");
			setenv("err_info_tempa", buf);
			return -1;
		}
	} else {
		printf("read calibrated data failed\n");
		sprintf(buf, "%s", "read calibrated data failed");
		setenv("err_info_tempa", buf);
		return -1;
	}

	return 0;

}

#if defined(NEW_THERMAL_MODE)
static int read_temp1(void)
{
	unsigned int ret;
	unsigned long value;
	unsigned int ver, u_efuse; //tmp for debug
	int family_id;
	int64_t temp;

	family_id = get_cpu_id().family_id;
	switch (get_cpu_id().family_id) {
		case MESON_CPU_MAJOR_ID_TXHD:
			writel(1 << 7 | (0x30), HHI_TS_CLK_CNTL); /*clk:0.5M*/
			writel(0x50ab, TS_CFG_REG);/*0x50ab is enable the new thermal mudule*/
			break;
		default:
			printf("cpu xxxx family id not support!!! id: %d\n", family_id);
			return -1;
		}
	mdelay(5); /*at least 4.2ms*/

	ret = do_read_calib_data1(&ver,&u_efuse);
	if (!ret) {
		printf("This chip is not trimmed\n");
		return -1;
	}

	value = readl(TS_YOUT);
	value = value & (0xffff);

	printf("YOUT: 0x%lx\n", value);
	printf("u_efuse: 0x%x\n", u_efuse);
	/* T = 727.8*(u_real+u_efuse/(1<<16)) - 274.7 */
	/* u_readl = (5.05*YOUT)/((1<<16)+ 4.05*YOUT) */
	temp = (value * 505) * (1 << 16) / (100 * (1 << 16) + 405 * value);

	if (u_efuse & 0x8000)
		temp = ((temp - (u_efuse & (0x7fff))) * 7278 / (1 << 16) - 2747) / 10;
	else
		temp = ((temp + u_efuse) * 7278 / (1 << 16) - 2747) / 10;
	printf("newtemp: %lld\n", temp);
	return temp;
}
#endif

static int do_read_temp(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
#if defined(R1P1_TSENSOR_MODE)
		printf("read temp\n");
		r1p1_read_entry();
		return 0;
#endif

#if defined(NEW_THERMAL_MODE)
		printf("read new and old temp\n");
		read_temp1();
#endif
		read_temp0();
	return 0;
}

static int do_write_version(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
	int ret;
	unsigned int val = simple_strtoul(argv[1], NULL, 16);

	ret = thermal_calibration(1, val);

	return ret;
}

static int do_set_trim_base(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
	int temp = simple_strtoul(argv[1], NULL, 10);
	temp_base = temp;
	printf("set base temperature: %d\n", temp_base);
	return 0;
}

static int do_temp_triming(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
	int cmd_result = -1;
	int temp;

#if defined (CONFIG_AML_MESON_AXG) || defined (CONFIG_AML_MESON_TXHD) || (R1P1_TSENSOR_MODE)
	unsigned int ver;
	int ret = -1;
#endif

	if (argc < 2)
		return CMD_RET_USAGE;

	temp = simple_strtoul(argv[1], NULL, 10);
	temp_base = temp;
	printf("set base temperature: %d\n", temp_base);

	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXBB:
	case MESON_CPU_MAJOR_ID_GXTVBB:
	case MESON_CPU_MAJOR_ID_GXL:
	case MESON_CPU_MAJOR_ID_GXM:
	case MESON_CPU_MAJOR_ID_TXL:
	case MESON_CPU_MAJOR_ID_TXLX:
	case MESON_CPU_MAJOR_ID_GXLX:
		cmd_result = run_command("write_trim", 0);
		if (cmd_result == CMD_RET_SUCCESS) {
		/*FB calibration v5: 1010 0000*/
		/*manual calibration v2: 0100 0000*/
		printf("manual calibration v3: 1100 0000\n");
		cmd_result = run_command("write_version 0xc0", 0);
		if (cmd_result != CMD_RET_SUCCESS)
			printf("write version error!!!\n");
		} else {
			printf("trim FAIL!!!Please check!!!\n");
			return -1;
		}
		run_command("read_temp", 0);
		break;
#ifdef CONFIG_AML_MESON_AXG
	case MESON_CPU_MAJOR_ID_AXG:
		if (argc <3) {
			printf("too little args for AXG temp triming!!\n");
			return CMD_RET_USAGE;
		}
		ver = simple_strtoul(argv[2], NULL, 10);
		printf("ver: %d\n", ver);
		switch (ver) {
		case 0x5:
		case 0xd: /*thermal0*/
			cmd_result = run_command("write_trim", 0);
			if (cmd_result != CMD_RET_SUCCESS) {
				printf("trim FAIL!!!Please check!!!\n");
				return -1;
			} else
				ret = 0;
			break;
		default:
			printf("thermal version not support!!!Please check!\n");
			return -1;
		}
		printf("trim thermal data ok\n");
		if (!ret) { //write data ok
			char str[20];
			sprintf(str, "write_version 0x%x", ver);

			cmd_result  = run_command(str, 0);
			if (cmd_result == CMD_RET_SUCCESS)
				printf("write thermal version ok\n");
			else {
				printf("trim FAIL!!!Please check version!!!\n");
				return -1;
			}
		}
		break;
#endif
#ifdef CONFIG_AML_MESON_TXHD
	case MESON_CPU_MAJOR_ID_TXHD:
		if (argc <3) {
			printf("too little args for txhd temp triming!!\n");
			return CMD_RET_USAGE;
		}
		ver = simple_strtoul(argv[2], NULL, 10);
		printf("ver: %d\n", ver);
		switch (ver) {
		case 0x6:
		case 0xe: /*thermal1*/
			if (get_cpu_id().chip_rev != 0x7) {
				cmd_result = run_command("write_trim 1", 0);
				if (cmd_result != CMD_RET_SUCCESS) {
					printf("trim FAIL!!!Please check!!!\n");
					return -1;
				} else
					ret = 0;
			} else
				printf("chip version: 0x%x not support!!!Please check!\n",
					get_cpu_id().chip_rev);
			break;
		case 0x5:
		case 0xd: /*thermal0*/
			cmd_result = run_command("write_trim", 0);
			if (cmd_result != CMD_RET_SUCCESS) {
				printf("trim FAIL!!!Please check!!!\n");
				return -1;
			} else
				ret = 0;
			break;
		case 0x7:
		case 0xf:
			if (get_cpu_id().chip_rev != 0x7) {
				cmd_result = run_command("write_trim 1", 0);
				if (cmd_result != CMD_RET_SUCCESS) {
					printf("trim FAIL!!!Please check!!!\n");
					return -1;
				} else {
					ret = 0;
					cmd_result = run_command("write_trim", 0);
					if (cmd_result != CMD_RET_SUCCESS) {
						printf("trim FAIL!!!Please check!!!\n");
						return -1;
					} else
						ret = 0;
				}
			} else
				printf("chip version: 0x%x not support!!!Please check!\n",
					get_cpu_id().chip_rev);
			break;
		default:
			printf("thermal version not support!!!Please check!\n");
			return -1;
		}
		printf("trim thermal data ok\n");
		if (!ret) { //write data ok
			char str[20];
			sprintf(str, "write_version 0x%x", ver);

			cmd_result  = run_command(str, 0);
			if (cmd_result == CMD_RET_SUCCESS)
				printf("write thermal version ok\n");
			else {
				printf("trim FAIL!!!Please check version!!!\n");
				return -1;
			}
		}
		break;
#endif

#if defined(R1P1_TSENSOR_MODE)
			case MESON_CPU_MAJOR_ID_G12A:
			case MESON_CPU_MAJOR_ID_G12B:
			case MESON_CPU_MAJOR_ID_TL1:
				if (argc <3) {
					printf("too little args for txhd temp triming!!\n");
					return CMD_RET_USAGE;
				}
				ver = simple_strtoul(argv[2], NULL, 16);
				ret = r1p1_trim_entry(temp_base, ver);
				return ret;
				break;
#endif

		default:
			printf("cpu family id not support!!!\n");
			return -1;
	}
	return 0;
}

#ifdef R1P1_TSENSOR_MODE
int r1p1_codetotemp(unsigned long value, unsigned int u_efuse,
			int ts_b, int ts_a, int ts_m, int ts_n)
{
	int64_t temp;

	/* T = 727.8*(u_real+u_efuse/(1<<16)) - 274.7 */
	/* u_readl = (5.05*YOUT)/((1<<16)+ 4.05*YOUT) */
	temp = (value * ts_m) * (1 << 16) / (100 * (1 << 16) + ts_n * value);
	if (u_efuse & 0x8000) {
		temp = ((temp - (u_efuse & 0x7fff)) * ts_a / (1 << 16) - ts_b) / 10;
	} else {
		temp = ((temp + (u_efuse & 0x7fff)) * ts_a / (1 << 16) - ts_b) / 10;
	}
	return temp;
}

int r1p1_temp_read(int type)
{
	unsigned int ret, u_efuse, regdata;//, ret;
	unsigned int value_ts, value_all_ts;
	int family_id;
	int tmp = -1;
	int i, ts_a, ts_b, ts_m, ts_n, cnt;
	char buf[2];

	family_id = get_cpu_id().family_id;
	switch (family_id) {
		case MESON_CPU_MAJOR_ID_G12A:
		case MESON_CPU_MAJOR_ID_G12B:
		case MESON_CPU_MAJOR_ID_TL1:
			ts_b = 3159;
			ts_a = 9411;
			ts_m = 424;
			ts_n = 324;
			switch (type) {
				case 1:
					/*enable thermal1*/
					regdata = 0x62b;/*enable control*/
					writel(regdata, TS_PLL_CFG_REG1);
					regdata = 0x130;/*enable tsclk*/
					writel(regdata, HHI_TS_CLK_CNTL);
					ret = readl(AO_SEC_GP_CFG10);/*thermal1 cali data in reg CFG10*/
					mdelay(5);
					buf[0] = (ret) & 0xff;
					buf[1] = (ret >> 8) & 0xff;
					u_efuse = buf[1];
					u_efuse = (u_efuse << 8) | buf[0];
					value_ts = 0;
					value_all_ts = 0;
					cnt = 0;
					for (i = 0; i <= 10; i ++) {
						udelay(50);
						value_ts = readl(TS_PLL_STAT0) & 0xffff;
					}
					for (i = 0; i <= NUM; i ++) {
						udelay(5000);
						value_ts = readl(TS_PLL_STAT0) & 0xffff;
						if ((value_ts >= 0x1500) && (value_ts <= 0x3500))
							value_all_ts += value_ts;
							cnt ++;
						}
					value_ts =  value_all_ts / cnt;
					printf("pll tsensor avg: 0x%x, u_efuse: 0x%x\n", value_ts, u_efuse);
					if (value_ts == 0) {
						printf("tsensor read temp is zero\n");
						return -1;
					}
					tmp = r1p1_codetotemp(value_ts, u_efuse, ts_b, ts_a, ts_m, ts_n);
					printf("temp1: %d\n", tmp);
					break;
				case 2:
					/*enable thermal2*/
					regdata = 0x62b;/*enable control*/
					writel(regdata,TS_DDR_CFG_REG1);
					regdata = 0x130;/*enable tsclk*/
					writel(regdata,HHI_TS_CLK_CNTL);
					mdelay(5);
					ret = readl(AO_SEC_SD_CFG12);/*thermal1 cali data in reg CFG10*/
					buf[0] = (ret) & 0xff;
					buf[1] = (ret >> 8) & 0xff;
					u_efuse = buf[1];
					u_efuse = (u_efuse << 8) | buf[0];
					value_ts = 0;
					value_all_ts = 0;
					cnt = 0;
					for (i = 0; i <= 10; i ++) {
						udelay(50);
						value_ts = readl(TS_DDR_STAT0) & 0xffff;
					}
					for (i = 0; i <= NUM; i ++) {
						udelay(5000);
						value_ts = readl(TS_DDR_STAT0) & 0xffff;
						if ((value_ts >= 0x1500) && (value_ts <= 0x3500))
							value_all_ts += value_ts;
							cnt ++;
						}
					value_ts =  value_all_ts / cnt;
					printf("ddr tsensor avg: 0x%x, u_efuse: 0x%x\n", value_ts, u_efuse);
					if (value_ts == 0) {
						printf("tsensor read temp is zero\n");
						return -1;
					}
					tmp = r1p1_codetotemp(value_ts, u_efuse, ts_b, ts_a, ts_m, ts_n);
					printf("temp2: %d\n", tmp);
					break;
				default:
					printf("r1p1 tsensor trim type not support\n");
			}
	}
	return tmp;
}


int r1p1_read_entry(void)
{
	unsigned int ret, ver;//, ret;
	int family_id;

	family_id = get_cpu_id().family_id;
	switch (family_id) {
		case MESON_CPU_MAJOR_ID_G12A:
		case MESON_CPU_MAJOR_ID_G12B:
		case MESON_CPU_MAJOR_ID_TL1:
			ret = readl(AO_SEC_GP_CFG10);
			ver = (ret >> 24) & 0xff;
			if ((ver & 0x80) == 0) {
				printf("tsensor no trimmed, ver:0x%x\n", ver);
				return -1;
			}
			ver = (ver & 0xf) >> 2;
			switch (ver) {
				case 0x2:
					r1p1_temp_read(1);
					r1p1_temp_read(2);
					printf("read the thermal1 and thermal2\n");
				break;
				case 0x0:
				case 0x1:
				case 0x3:
					printf("temp type no support\n");
				break;
				default:
					printf("thermal version not support!!!Please check!\n");
					return -1;
				}
		}
	return 0;
}

unsigned int r1p1_temptocode(unsigned long value, int tempbase,
			int ts_b, int ts_a, int ts_m, int ts_n)
{
	unsigned long tmp1, tmp2, u_efuse, signbit;
	/* T = (727.8*(5.05*Yout)/((1<<16)+4.05*Yout)) - 274.7 */
	/* u_efuse = u_ideal - u_real */
	printf("a b m n: %d, %d, %d, %d\n", ts_a, ts_b, ts_m, ts_n);
	tmp1 = ((tempbase * 10 + ts_b) * (1 << 16)) / ts_a; /*ideal u*/
	printf("%s : tmp1: 0x%lx\n", __func__, tmp1);
	tmp2 = (ts_m * value * (1 << 16)) / ((1 << 16) * 100 + ts_n * value);
	printf("%s : tmp2: 0x%lx\n", __func__, tmp2);
	signbit = ((tmp1 > tmp2) ? 0 : 1);
	u_efuse = (tmp1 > tmp2) ? (tmp1 - tmp2) : (tmp2 - tmp1);
	u_efuse = (signbit << 15) | u_efuse;
	return u_efuse;
}

int r1p1_temp_trim(int tempbase, int tempver, int type)
{
	unsigned int u_efuse, regdata, index_ts, index_ver;//, ret;
	unsigned int value_ts, value_all_ts;
	int family_id;
	int i, ts_a, ts_b, ts_m, ts_n, cnt;

	family_id = get_cpu_id().family_id;
	printf("r1p1 temp trim type: 0x%x, familyid: %d\n", type, family_id);
	switch (family_id) {
		case MESON_CPU_MAJOR_ID_G12A:
		case MESON_CPU_MAJOR_ID_G12B:
		case MESON_CPU_MAJOR_ID_TL1:
			ts_b = 3159;
			ts_a = 9411;
			ts_m = 424;
			ts_n = 324;
			switch (type) {
				case 0:
					index_ver = 5;
					if (thermal_calibration(index_ver, tempver) < 0)
						printf("version tsensor thermal_calibration send error\n");
				break;
				case 1:
					value_ts = 0;
					value_all_ts = 0;
					index_ts = 6;
					cnt = 0;

					/*enable thermal1*/
					regdata = 0x62b;/*enable control*/
					writel(regdata, TS_PLL_CFG_REG1);
					regdata = 0x130;/*enable tsclk*/
					writel(regdata, HHI_TS_CLK_CNTL);
					for (i = 0; i <= 10; i ++) {
						udelay(50);
						value_ts = readl(TS_PLL_STAT0) & 0xffff;
					}
					for (i = 0; i <= NUM; i ++) {
						udelay(5000);
						value_ts = readl(TS_PLL_STAT0) & 0xffff;
						printf("pll tsensor read: 0x%x\n", value_ts);
						if ((value_ts >= 0x1500) && (value_ts <= 0x3500))
							value_all_ts += value_ts;
							cnt ++;
						}
					value_ts =  value_all_ts / cnt;
					printf("pll tsensor avg: 0x%x\n", value_ts);
					if (value_ts == 0) {
						printf("pll tsensor read temp is zero\n");
						return -1;
					}
					u_efuse = r1p1_temptocode(value_ts, tempbase, ts_b, ts_a, ts_m, ts_n);
					printf("pll ts efuse:%d\n", u_efuse);
					printf("pll ts efuse:0x%x, index: %d\n", u_efuse, index_ts);
					if (thermal_calibration(index_ts, u_efuse) < 0) {
						printf("pll tsensor thermal_calibration send error\n");
						return -1;
						}
					break;
				case 2:
					value_ts = 0;
					value_all_ts = 0;
					index_ts = 7;
					cnt = 0;

					/*enable thermal2*/
					regdata = 0x62b;/*enable control*/
					writel(regdata, TS_DDR_CFG_REG1);
					regdata = 0x130;/*enable tsclk*/
					writel(regdata, HHI_TS_CLK_CNTL);
					for (i = 0; i <= 10; i ++) {
						udelay(50);
						value_ts = readl(TS_DDR_STAT0) & 0xffff;
					}
					for (i = 0; i <= NUM; i ++) {
						udelay(5000);
						value_ts = readl(TS_DDR_STAT0) & 0xffff;
						printf("ddr tsensor read: 0x%x\n", value_ts);
						if ((value_ts >= 0x1500) && (value_ts <= 0x3500))
							value_all_ts += value_ts;
							cnt ++;
						}
					value_ts =  value_all_ts / cnt;
					printf("ddr tsensor avg: 0x%x\n", value_ts);
					if (value_ts == 0) {
						printf("ddr tsensor read temp is zero\n");
						return -1;
					}
					u_efuse = r1p1_temptocode(value_ts, tempbase, ts_b, ts_a, ts_m, ts_n);
					printf("pll ts efuse:%d\n", u_efuse);
					printf("pll ts efuse:0x%x, index: %d\n", u_efuse, index_ts);
					if (thermal_calibration(index_ts, u_efuse) < 0) {
						printf("ddr tsensor thermal_calibration send error\n");
						return -1;
					}
					break;
				default:
					printf("r1p1 tsensor trim type not support\n");
					return -1;
				break;
			}
	}
	return 0;
}

int r1p1_trim_entry(int tempbase, int tempver)
{
	unsigned int ret, ver;
	int family_id;

	family_id = get_cpu_id().family_id;
	switch (family_id) {
		case MESON_CPU_MAJOR_ID_G12A:
		case MESON_CPU_MAJOR_ID_G12B:
		case MESON_CPU_MAJOR_ID_TL1:
			ret = readl(AO_SEC_GP_CFG10);
			ver = (ret >> 24) & 0xff;
			if (ver & 0x80) {
				printf("tsensor has trimmed, ver:0x%x\n", ver);
				printf("tsensor cali data: 0x%x, 0x%x\n",
					readl(AO_SEC_GP_CFG10), readl(AO_SEC_SD_CFG12));
				return -1;
			}
			printf("tsensor input trim tempver, tempver:0x%x\n", tempver);
			switch (tempver) {
				case 0x88:
					r1p1_temp_trim(tempbase, tempver, 1);
					r1p1_temp_trim(tempbase, tempver, 2);
					r1p1_temp_trim(tempbase, tempver, 0);
					printf("triming the thermal1 and thermal2 by bbt-sw\n");
				break;
				case 0x89:
					r1p1_temp_trim(tempbase, tempver, 1);
					r1p1_temp_trim(tempbase, tempver, 2);
					r1p1_temp_trim(tempbase, tempver, 0);
					printf("triming the thermal1 and thermal2 by bbt-ops\n");
				break;
				case 0x8b:
					r1p1_temp_trim(tempbase, tempver, 1);
					r1p1_temp_trim(tempbase, tempver, 2);
					r1p1_temp_trim(tempbase, tempver, 0);
					printf("triming the thermal1 and thermal2 by slt\n");
				break;
				default:
					printf("thermal version not support!!!Please check!\n");
					return -1;
				}
		}
	return 0;

}

#ifdef CONFIG_HIGH_TEMP_COOL
void r1p1_temp_cooling(void)
{
	int family_id, temp, temp1, temp2;

	family_id = get_cpu_id().family_id;
	switch (family_id) {
		case MESON_CPU_MAJOR_ID_G12A:
		case MESON_CPU_MAJOR_ID_G12B:
			while (1) {
				temp1 = r1p1_temp_read(1);
				temp2 = r1p1_temp_read(2);
				temp = temp1 > temp2 ? temp1 : temp2;
				if (temp <= CONFIG_HIGH_TEMP_COOL) {
					printf("device cool done\n");
					break;
				}
				mdelay(2000);
				printf("warning: temp %d over %d, cooling\n", temp,
					CONFIG_HIGH_TEMP_COOL);
			}
			break;
		default:
			break;
	}
}
#endif
#endif


static int do_boot_cooling(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
#if defined (CONFIG_HIGH_TEMP_COOL) && defined (R1P1_TSENSOR_MODE)
	r1p1_temp_cooling();
#endif
	return 0;
}

U_BOOT_CMD(
	boot_cooling,	5,	0,	do_boot_cooling,
	"cpu temp-system",
	"boot_cooling pos"
);

U_BOOT_CMD(
	write_trim,	5,	0,	do_write_trim,
	"cpu temp-system",
	"write_trim data"
);

U_BOOT_CMD(
	read_temp,	5,	0,	do_read_temp,
	"cpu temp-system",
	"read_temp pos"
);

U_BOOT_CMD(
	write_version,	5,	0,	do_write_version,
	"cpu temp-system",
	"write_flag"
);

static char temp_trim_help_text[] =
	"temp_triming x [ver]\n"
	"  - for manual trimming chip\n"
	"  - x:     [decimal]the temperature of the chip surface\n"
	"  - [ver]: [decimal]only for New thermal sensor\n"
	"           BBT: OPS socket board, which can change chips\n"
	"	    online: reference boards witch chip mounted\n"
	"	AXG or TXHD:\n"
	"           5  (0101)b: BBT, thermal0\n"
	"           6  (0110)b: BBT, thermal1\n"
	"           7  (0111)b: BBT, thermal01\n"
	"           13  (1101)b: online, thermal0\n"
	"           14  (1110)b: online, thermal1\n"
	"           15  (1111)b: online, thermal01\n"
	" 	G12A or G12B:\n"
	"	    88	(10001000)b: BBT-SW, thermal1 thermal2, valid thermal cali data\n"
	"	    89	(10001001)b: BBT-OPS, thermal1 thermal2, valid thermal cali data\n"
	"	    8b	(10001001)b: SLT, thermal1 thermal2, valid thermal cali data\n"
	" 	TL1:\n"
	"	    88	(10001001)b: BBT-SW, thermal1 thermal2, valid thermal cali data\n"
	"	    89	(10001001)b: BBT-OPS, thermal1 thermal2, valid thermal cali data\n"
	"	    8b	(10001001)b: SLT, thermal1 thermal2, valid thermal cali data\n";

U_BOOT_CMD(
	temp_triming,	5,	1,	do_temp_triming,
	"cpu temp-system",
	temp_trim_help_text
);

U_BOOT_CMD(
	set_trim_base,	5,	1,	do_set_trim_base,
	"cpu temp-system",
	"set triming base temp"
);
