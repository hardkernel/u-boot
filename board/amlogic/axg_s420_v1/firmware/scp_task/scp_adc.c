#define MESON_CPU_MAJOR_ID_GXBB		0x1F
#define MESON_CPU_MAJOR_ID_GXTVBB	0x20
#define MESON_CPU_MAJOR_ID_GXL		0x21
#define MESON_CPU_MAJOR_ID_GXM		0x22
#define MESON_CPU_MAJOR_ID_TXL		0x23

#define AML_ADC_SAMPLE_DEBUG 0

#define FLAG_BUSY_KERNEL    (1<<14) /* for bl30 */
#define FLAG_BUSY_BL30      (1<<15) /* for bl30 */

#define PP_AO_SEC_SD_CFG8           (volatile unsigned int *)(0xc8100000 + (0x88 << 2))
#if 0  /*For Mbox Platform*/
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
#define P_SAR_ADC_DELTA_11          (volatile unsigned int *)0xc11086aC
#else  /*For TV Platform*/
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
#endif

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

#define set_bits	aml_set_reg32_bits
#define get_bits	aml_get_reg32_bits
#define set_reg	    aml_write_reg32
#define get_reg	    aml_read_reg32

static int adc_type; /*1:12bit; 0:10bit*/

static void aml_set_reg32_bits(volatile unsigned int *_reg, const unsigned int _value, const unsigned int _start, const unsigned int _len)
{
	writel(( (readl((volatile unsigned int *)_reg) & ~((( 1L << (_len) )-1) << (_start))) | ((unsigned)((_value)&((1L<<(_len))-1)) << (_start))), (volatile void *)_reg );
}
static unsigned int aml_get_reg32_bits(volatile unsigned int *_reg, const unsigned int _start, const unsigned int _len)
{
	return	( (readl((volatile unsigned int *)_reg) >> (_start)) & (( 1L << (_len) ) - 1) );
}
static void aml_write_reg32( volatile unsigned int *_reg, const unsigned int _value)
{
	writel( _value,(volatile unsigned int *)_reg );
};
static unsigned int aml_read_reg32(volatile unsigned int *_reg)
{
	return readl((volatile unsigned int *)_reg);
};

static int get_cpu_family_id(void)
{
	return ((aml_read_reg32(PP_AO_SEC_SD_CFG8) >> 24) & 0xff);
}

/*
  * description: used to enable and disable the clock of the SARADC
  * onoff: 1: enable ; 0: disable
  */
static void saradc_clock_switch(int onoff)
{
/* if the famiy id of the cpu greater than or equal to MESON_CPU_MAJOR_ID_GXBB,
  * the clock switch from the clock tree register, otherwise from the adc module register.
  */
	if (onoff) {
		if (get_cpu_family_id() >= MESON_CPU_MAJOR_ID_GXBB)
			aml_set_reg32_bits(GXBB_CLK_REG,1,8,1);
		else
			aml_set_reg32_bits(PP_SAR_ADC_REG3,1,30,1);
	} else {
		if (get_cpu_family_id() >= MESON_CPU_MAJOR_ID_GXBB)
			aml_set_reg32_bits(GXBB_CLK_REG,0,8,1);
		else
			aml_set_reg32_bits(PP_SAR_ADC_REG3,0,30,1);
	}
}
static inline void saradc_power_control(int on)
{
	if (on) {
		aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,1,13,1);
		aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,3,5,2);
		aml_set_reg32_bits(PP_SAR_ADC_REG3,1,21,1);

		_udelay(5);

		saradc_clock_switch(1);

	}	else {
		saradc_clock_switch(0);

		aml_set_reg32_bits(PP_SAR_ADC_REG3,0,30,1);
		/*aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,0,13,1);*//* disable bandgap */
		aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,0,5,2);
	}
}

/*
  * description: used to set the DIV of the clock
  */
static void saradc_clock_set(unsigned char val)
{
/* if the famiy id of the cpu greater than or equal to MESON_CPU_MAJOR_ID_GXBB,
  * the clock switch from the clock tree register, otherwise from the adc module register.
  */
	if (get_cpu_family_id() >= MESON_CPU_MAJOR_ID_GXBB) { /*bit0-bit7*/
		val = val & 0xff;
		aml_write_reg32(GXBB_CLK_REG, (0<<9) | (val << 0));
	} else {                                              /*bit10-bit15*/
		val = val & 0x3f;
		aml_set_reg32_bits(PP_SAR_ADC_REG3,val,10,5);
	}
}

int get_adc_sample_gxbb(int ch);

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
		_udelay(5);
		val[0] = get_adc_sample_gxbb(7);
		if (val[0] < 3050/4) {
			abs_tmp = 3050/4 - val[0];
			if (abs_tmp < abs_val) {
				abs_val = abs_tmp;
				abs_num = i;
			}
		}
	}
	aml_set_reg32_bits(PP_SAR_ADC_REG13,abs_num,8,6);

	/*for (i=0;i<5;i++) {
		aml_set_reg32_bits(PP_SAR_ADC_REG3,i,23,3);
		_udelay(5);
		val[0] = get_adc_sample_gxbb(7);
		uart_put_hex(val[0], 32);
		uart_puts("\n");
	}*/
}
void saradc_enable(void)
{
	static int init_times=0;
	if (get_cpu_family_id() <= MESON_CPU_MAJOR_ID_GXTVBB)
		adc_type = 0;
	else
		adc_type = 1;

    set_reg(P_SAR_SAR_ADC_REG0, 0x84004040);
    set_reg(PP_SAR_ADC_CHAN_LIST, 0);
    /* REG2: all chanel set to 8-samples & median averaging mode */
    set_reg(PP_SAR_ADC_AVG_CNTL, 0);
	set_reg(PP_SAR_ADC_REG3, 0x9388000a);

	aml_set_reg32_bits(PP_SAR_ADC_REG3,0x14,10,5);

	/*gxl change vdd
	set_reg(PP_SAR_ADC_REG13, );
	gxl change sampling mode */
	if (adc_type)
		aml_set_reg32_bits(PP_SAR_ADC_REG3,0x1,27,1);

	saradc_clock_set(20);

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
	if (!init_times) {
		init_times = 1;
		saradc_internal_cal_12bit();
	}
}

int get_adc_sample_gxbb(int ch)
{
	int value=0;
	int count=0;
	int sum=0;
	//static int nn=0;
	//unsigned long flags;

	count = 0;
	while (aml_read_reg32(PP_SAR_ADC_DELAY) & FLAG_BUSY_BL30) {
		_udelay(100);
		if (++count > 100) {
			//printf("bl30 busy error\n");
			uart_puts(".bl30 busy error");
			uart_puts("\n");
			value = -1;
			goto end1;
		}
	}
	aml_set_reg32_bits(PP_SAR_ADC_DELAY,1,FLAG_BUSY_KERNEL,1);
/*
	count = 0;
	while (aml_get_reg32_bits(PP_SAR_ADC_REG0,21,5) && (count < 32)) {
		value = aml_read_reg32(PP_SAR_ADC_FIFO_RD);
		count++;
	}
*/
	aml_set_reg32_bits(PP_SAR_ADC_REG3,1,29,1);

    set_reg(PP_SAR_ADC_CHAN_LIST, ch);
    set_reg(PP_SAR_ADC_DETECT_IDLE_SW, (0xc000c | (ch<<23) | (ch<<7)));
    aml_set_reg32_bits(PP_SAR_ADC_REG0, 1,0,1);
    aml_set_reg32_bits(PP_SAR_ADC_REG0, 1,2,1);

    count = 0;
	do {
		_udelay(10);
		//nn=10000;
		//while(nn--);
		if (!(aml_read_reg32(P_SAR_SAR_ADC_REG0) & 0x70000000))
			break;
		else if (++count > 10000) {
			uart_puts("busy error");
			uart_puts("\n");
			value = -1;
			goto end;
		}
	} while (1);

	count = 0;
	sum = 0;
	while (aml_get_reg32_bits(PP_SAR_ADC_REG0,21,5) && (count < 32)) {
		if (aml_get_reg32_bits(PP_SAR_ADC_REG0,26,1)) {
			uart_puts("fifo_count, but fifo empty");
			uart_puts("\n");
		}
        value = aml_read_reg32(PP_SAR_ADC_FIFO_RD);
		if (((value>>12) & 0x07) == ch) {
			value &= 0xffc;
			value >>= 2;
			sum += value;
			count++;
		}	else {
			uart_puts("chanel error");
			uart_puts("\n");
		}
	}
	if (!aml_get_reg32_bits(PP_SAR_ADC_REG0,26,1)) {
		uart_puts("fifo_count=0, but fifo not empty");
		uart_puts("\n");
	}
	if (!count) {
		value = -1;
		goto end;
	}
	value = sum / count;

end:
    aml_set_reg32_bits(PP_SAR_ADC_REG0,1,14,1);
    aml_set_reg32_bits(PP_SAR_ADC_REG0,0,0,1);

end1:
    aml_set_reg32_bits(PP_SAR_ADC_REG3,0,29,1);
	aml_set_reg32_bits(PP_SAR_ADC_DELAY,0,FLAG_BUSY_KERNEL,1);

	return value;
}

int saradc_disable(void)
{
	saradc_power_control(0);
	return 0;
}

int check_adc_key_resume(void)
{
	int value;
	/*the sampling value of adc: 0-1023*/
	value = get_adc_sample_gxbb(2);
	if ((value >= 0) && (value <= 40))
		return 1;
	else
		return 0;
}
