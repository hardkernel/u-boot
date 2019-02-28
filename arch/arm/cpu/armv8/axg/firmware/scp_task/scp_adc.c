#define MESON_CPU_MAJOR_ID_GXBB		0x1F
#define MESON_CPU_MAJOR_ID_GXTVBB	0x20
#define MESON_CPU_MAJOR_ID_GXL		0x21
#define MESON_CPU_MAJOR_ID_GXM		0x22
#define MESON_CPU_MAJOR_ID_TXL		0x23
#define MESON_CPU_MAJOR_ID_TXLX	0x24

static int adc_type; /*1:12bit; 0:10bit*/

static void aml_set_reg32_bits(volatile uint32_t *_reg,
		const uint32_t _value,
		const uint32_t _start,
		const uint32_t _len)
{
	writel(((readl((volatile unsigned int *)_reg) & \
		~(((1L << (_len) )-1) << (_start))) | \
		((unsigned)((_value) & ((1L<<(_len))-1)) << (_start))),
		(volatile void *)_reg );
}

static unsigned int aml_get_reg32_bits(volatile uint32_t *_reg,
		const unsigned int _start,
		const unsigned int _len)
{
	return	((readl((volatile unsigned int *)_reg) >> (_start)) & \
		((1L << (_len) ) - 1));
}

static void aml_write_reg32(volatile uint32_t *_reg,
		const uint32_t _value)
{
	writel(_value, (volatile unsigned int *)_reg );
};

static unsigned int aml_read_reg32(volatile uint32_t *_reg)
{
	return readl((volatile unsigned int *)_reg);
};

static int get_cpu_family_id(void)
{
	return ((aml_read_reg32(P_AO_SEC_SD_CFG8) >> 24) & 0xff);
}

/*
 * description: used to enable and disable the clock of the SARADC
 * onoff: 1: enable ; 0: disable
 */
static void saradc_clock_switch(int onoff)
{
/* if the famiy id of the cpu greater than or equal to MESON_CPU_MAJOR_ID_GXBB,
 * the clock switch from the clock tree register, otherwise from
 * the adc module register.
 */
	if (onoff) {
		if (get_cpu_family_id() >= MESON_CPU_MAJOR_ID_GXBB)
			aml_set_reg32_bits(P_AO_SAR_CLK, 1, 8, 1);
		else
			aml_set_reg32_bits(P_AO_SAR_ADC_REG3, 1, 30, 1);
	} else {
		if (get_cpu_family_id() >= MESON_CPU_MAJOR_ID_GXBB)
			aml_set_reg32_bits(P_AO_SAR_CLK, 0, 8, 1);
		else
			aml_set_reg32_bits(P_AO_SAR_ADC_REG3, 0, 30, 1);
	}
}
static inline void saradc_power_control(int on)
{
	if (on) {
		aml_set_reg32_bits(P_AO_SAR_ADC_REG11, 1, 13, 1);
		aml_set_reg32_bits(P_AO_SAR_ADC_REG11, 3, 5, 2);
		aml_set_reg32_bits(P_AO_SAR_ADC_REG3, 1, 21, 1);

		_udelay(5);

		saradc_clock_switch(1);
	}	else {
		saradc_clock_switch(0);
		aml_set_reg32_bits(P_AO_SAR_ADC_REG3, 0, 21, 1);
	}
}

/*
 * description: used to set the DIV of the clock
 */
static void saradc_clock_set(unsigned char val)
{
/* if the famiy id of the cpu greater than or equal to MESON_CPU_MAJOR_ID_GXBB,
 * the clock switch from the clock tree register, otherwise from
 * the adc module register.
 */
	if (get_cpu_family_id() >= MESON_CPU_MAJOR_ID_GXBB) {
		/*bit[0-7]: set clk div; bit[9-10]: select clk source*/
		aml_set_reg32_bits(P_AO_SAR_CLK, 0, 9, 2);
		aml_set_reg32_bits(P_AO_SAR_CLK, (val & 0xff), 0, 8);
	} else {
		/*bit10-bit15: set clk div*/
		aml_set_reg32_bits(P_AO_SAR_ADC_REG3, (val & 0x3f), 10, 6);
	}
}

void saradc_enable(void)
{
	if (get_cpu_family_id() <= MESON_CPU_MAJOR_ID_GXTVBB)
		adc_type = 0;
	else
		adc_type = 1;

	aml_write_reg32(P_AO_SAR_ADC_REG0, 0x84004040);
	aml_write_reg32(P_AO_SAR_ADC_CHAN_LIST, 0);
	/* REG2: all chanel set to 8-samples & median averaging mode */
	aml_write_reg32(P_AO_SAR_ADC_AVG_CNTL, 0);
	aml_write_reg32(P_AO_SAR_ADC_REG3, 0x9388000a);

	if (adc_type)
		aml_set_reg32_bits(P_AO_SAR_ADC_REG3,0x1,27,1);

	saradc_clock_set(20);

	aml_write_reg32(P_AO_SAR_ADC_DELAY, 0x10a000a);
	aml_write_reg32(P_AO_SAR_ADC_AUX_SW, 0x3eb1a0c);
	aml_write_reg32(P_AO_SAR_ADC_CHAN_10_SW, 0x8c000c);
	aml_write_reg32(P_AO_SAR_ADC_DETECT_IDLE_SW, 0xc000c);

	/* select the VDDA as Vref for txlx and later SoCs */
	aml_set_reg32_bits(P_AO_SAR_ADC_REG11, 1, 0, 1);

	saradc_power_control(1);
}

int get_adc_sample_gxbb(int ch)
{
	int value=0;
	int count=0;
	int sum=0;

	aml_write_reg32(P_AO_SAR_ADC_CHAN_LIST, ch);
	aml_write_reg32(P_AO_SAR_ADC_DETECT_IDLE_SW, (0xc000c | (ch<<23) | (ch<<7)));
	aml_set_reg32_bits(P_AO_SAR_ADC_REG0, 1, 0, 1);
	aml_set_reg32_bits(P_AO_SAR_ADC_REG0, 1, 2, 1);

	count = 0;
	do {
		_udelay(10);
		if (!(aml_read_reg32(P_AO_SAR_ADC_REG0) & 0x70000000))
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
	while (aml_get_reg32_bits(P_AO_SAR_ADC_REG0, 21, 5) && (count < 32)) {
        value = aml_read_reg32(P_AO_SAR_ADC_FIFO_RD);
		if (((value >> 12) & 0x07) == ch) {
			value &= 0xffc;
			value >>= 2;
			sum += value;
			count++;
		}
	}
	if (!count) {
		value = -1;
		goto end;
	}
	value = sum / count;

end:
	aml_set_reg32_bits(P_AO_SAR_ADC_REG0, 1, 14, 1);
	aml_set_reg32_bits(P_AO_SAR_ADC_REG0, 0, 0, 1);

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
	int min;
	int max;

	/*the sampling value of adc: 0-1023*/
	min = CONFIG_ADC_POWER_KEY_VAL - 40;
	if (min < 0)
		min = 0;
	max = CONFIG_ADC_POWER_KEY_VAL + 40;
	if (max > 1023)
		max = 1023;

	value = get_adc_sample_gxbb(CONFIG_ADC_POWER_KEY_CHAN);
	if ((value >= min) && (value <= max))
		return 1;
	else
		return 0;
}
