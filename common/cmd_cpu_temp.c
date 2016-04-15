
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

//#define HHI_SAR_CLK_CNTL    0xc883c000+0xf6*4 //0xc883c3d8

int temp_base = 27;
#define NUM 30

int get_tsc(int temp)
{
	int vmeasure, TS_C;
	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXBB:
	case MESON_CPU_MAJOR_ID_GXTVBB:
		/*TS_C = (adc-435)/8.25+16*/
		vmeasure = temp-(435+(temp_base-27)*3.4);
		printf("vmeasure=%d\n", vmeasure);
		TS_C = ((vmeasure)/8.25)+16;
		break;
	case MESON_CPU_MAJOR_ID_GXL:
		/*TS_C = 16-(adc-1778)/41*/
		vmeasure = temp-(1778+(temp_base-27)*17);
		printf("vmeasure=%d\n", vmeasure);
		TS_C = 16-((vmeasure)/42);
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

int adc_init_chan6(void)
{
	/*adc reg3 bit28: config adc registers flag*/
	if (readl(SAR_ADC_REG3)&(0x1<<28))
		return 0;
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
		writel(readl(0xc110868c)|(0x1<<28), SAR_ADC_REG3);
		break;
	case MESON_CPU_MAJOR_ID_GXL:
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
	default:
		printf("cpu family id not support!!!\n");
		return -1;
	}
	return 0;
}

int get_adc_sample(int chan)
{
	unsigned value;

	/*adc reg3 bit29: read adc sample value flag*/
	while (readl(SAR_ADC_REG3)&(1<<29))
		udelay(10000);
	writel(readl(SAR_ADC_REG3)|(1 < 29), SAR_ADC_REG3);

	writel(0x84064040, SAR_ADC_REG0);
	writel(0x84064041, SAR_ADC_REG0);
	writel(0x84064045, SAR_ADC_REG0);

	value = readl(SAR_ADC_FIFO_RD);
	writel(readl(SAR_ADC_REG3)&(~(1 < 29)), SAR_ADC_REG3);
	value = value&SAMPLE_BIT_MASK;

	return value;
}
unsigned int get_cpu_temp(int tsc, int flag)
{
	unsigned value;
	if (flag) {
		value = readl(SAR_ADC_REG11);
	  writel(((value&(~(0x1f<<14)))|((tsc&0x1f)<<14)), SAR_ADC_REG11);
	  /* bit[14-18]:tsc */
	} else{
		value = readl(SAR_ADC_REG11);
	  writel(((value&(~(0x1f<<14)))|(0x10<<14)), SAR_ADC_REG11);
	  /* bit[14-18]:0x16 */
	}
	return  get_adc_sample(6);
}

void quicksort(int a[], int numsize)
{
	int i = 0, j = numsize-1;
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
	quicksort(a+i+1, numsize-1-i);
}
}

int do_read_calib_data(int *flag, int *temp, int *TS_C)
{
	char buf[2];
	unsigned ret;
	*flag = 0;
	buf[0] = 0; buf[1] = 0;

	char flagbuf;

	ret = readl(AO_SEC_SD_CFG12);
	flagbuf = (ret>>24)&0xff;
	if (((int)flagbuf != 0xA0) && ((int)flagbuf != 0x40)
		&& ((int)flagbuf != 0xC0)) {
		printf("thermal ver flag error!\n");
		printf("flagbuf is 0x%x!\n", flagbuf);
		return 0;
	}

	buf[0] = (ret)&0xff;
	buf[1] = (ret>>8)&0xff;

	*temp = buf[1];
	*temp = (*temp<<8)|buf[0];
	*TS_C =  *temp&0x1f;
	*flag = (*temp&0x8000)>>15;
	*temp = (*temp&0x7fff)>>5;

	if ((get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXBB)
		&&(0x40 == (int)flagbuf))/*ver2*/
		*TS_C = 16;

	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXL)
		*temp = (*temp)<<2; /*adc 12bit sample*/
	printf("adc=%d,TS_C=%d,flag=%d\n", *temp, *TS_C, *flag);
	return ret;
}

static int do_write_trim(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
{
	int temp = 0;
	int temp1[NUM];
	char buf[2];
	unsigned int data;
	int i, TS_C;
	int ret;
	int flag;

	memset(temp1, 0, NUM);

	adc_init_chan6();

	ret = do_read_calib_data(&flag, &temp, &TS_C);
	if (ret) {
		printf("chip has trimed!!!\n");
		return 0;
	} else {
		printf("chip is not triming! triming now......\n");
		flag = 0;
		temp = 0;
		TS_C = 0;
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
	for (i = 2; i < NUM-2; i++)
		temp += temp1[i];
	temp = temp/(NUM-4);
	printf("the adc cpu adc=%d\n", temp);

/**********************************/
	TS_C = get_tsc(temp);
	if (TS_C < 0)
		return -1;
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
	temp = temp/(NUM-4);
	printf("the adc cpu adc=%d\n", temp);

/**************recalculate to 27******/
	switch (get_cpu_id().family_id) {
	case MESON_CPU_MAJOR_ID_GXBB:
	case MESON_CPU_MAJOR_ID_GXTVBB:
		temp = temp - 3.4*(temp_base - 27);
		break;
	case MESON_CPU_MAJOR_ID_GXL:/*12bit*/
		temp = temp - 17*(temp_base - 27);
		temp = temp>>2;/*efuse only 10bit adc*/
		break;
	}
/**********************************/
	temp = ((temp<<5)|(TS_C&0x1f))&0xffff;
/* write efuse tsc,flag */
	buf[0] = (char)(temp&0xff);
	buf[1] = (char)((temp>>8)&0xff);
	buf[1] |= 0x80;
	printf("buf[0]=%x,buf[1]=%x\n", buf[0], buf[1]);
	data = buf[1]<<8 | buf[0];
	ret = thermal_calibration(0, data);
	return ret;
}
static int do_read_temp(cmd_tbl_t *cmdtp, int flag1,
	int argc, char * const argv[])
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
				tempa = (10*(adc-temp))/34+27;
				break;
			case MESON_CPU_MAJOR_ID_GXL:
				tempa = (10*(adc-temp))/171+27;
				break;
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
	int temp = simple_strtoul(argv[1], NULL, 10);
	temp_base = temp;
	printf("set base temperature: %d\n", temp_base);
	run_command("write_trim", 0);
	/*FB calibration v5: 1010 0000*/
	/*manual calibration v2: 0100 0000*/
	printf("manual calibration v3: 1100 0000\n");
	run_command("write_version 0xc0", 0);
	run_command("read_temp", 0);
	return 0;
}

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

U_BOOT_CMD(
	temp_triming,	5,	1,	do_temp_triming,
	"cpu temp-system",
	"write_trim 502 and write flag"
);

U_BOOT_CMD(
	set_trim_base,	5,	1,	do_set_trim_base,
	"cpu temp-system",
	"set triming base temp"
);
