
enum{AML_ADC_CHAN_0 = 0, AML_ADC_CHAN_1, AML_ADC_CHAN_2, AML_ADC_CHAN_3,
         AML_ADC_CHAN_4,         AML_ADC_CHAN_5, AML_ADC_CHAN_6, AML_ADC_CHAN_7,
         AML_ADC_SARADC_CHAN_NUM,
};

enum{AML_ADC_NO_AVG = 0,  AML_ADC_SIMPLE_AVG_1, AML_ADC_SIMPLE_AVG_2,
         AML_ADC_SIMPLE_AVG_4,AML_ADC_SIMPLE_AVG_8, AML_ADC_MEDIAN_AVG_8,
};

#define AML_ADC_CHAN_XP AML_ADC_CHAN_0
#define AML_ADC_CHAN_YP AML_ADC_CHAN_1
#define AML_ADC_CHAN_XN AML_ADC_CHAN_2
#define AML_ADC_CHAN_YN AML_ADC_CHAN_3



typedef struct adckey_info{
        const char *key;
        int   value;    /* voltage/3.3v * 1023 */
        int   tolerance;
}adckey_info_t;

typedef struct adc_info{
        char * tint;
        int    chan;
        int    adc_type;
        void * adc_data;
}adc_info_t;

struct adc_device{
        adc_info_t * adc_device_info;
        unsigned dev_num;
};


#define CONFIG_GXBB 1

#define WRITE_REG(reg, val) writel(val, reg)
#define READ_REG(reg)       readl(reg)

#define GXBB_ADC   1
#define AML_ADC_SAMPLE_DEBUG 0

#define FLAG_BUSY_KERNEL    (1<<14) /* for bl30 */
#define FLAG_BUSY_BL30      (1<<15) /* for bl30 */

#define FLAG_INITIALIZED (1<<28)
//#define FLAG_BUSY (1<<29)


#if 0
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
#endif

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

typedef unsigned int uint32_t;

static void aml_set_reg32_bits(volatile unsigned int *_reg, const uint32_t _value, const uint32_t _start, const uint32_t _len)
{
	writel(( (readl((volatile unsigned int *)_reg) & ~((( 1L << (_len) )-1) << (_start))) | ((unsigned)((_value)&((1L<<(_len))-1)) << (_start))), (volatile void *)_reg );
}
static uint32_t aml_get_reg32_bits(volatile unsigned int *_reg, const uint32_t _start, const uint32_t _len)
{
	return	( (readl((volatile unsigned int *)_reg) >> (_start)) & (( 1L << (_len) ) - 1) );
}
static void aml_write_reg32( volatile unsigned int *_reg, const uint32_t _value)
{
	writel( _value,(volatile unsigned int *)_reg );
};
static uint32_t aml_read_reg32(volatile unsigned int *_reg)
{
	return readl((volatile unsigned int *)_reg);
};


#define set_bits	aml_set_reg32_bits
#define get_bits	aml_get_reg32_bits
#define set_reg	    aml_write_reg32
#define get_reg	    aml_read_reg32


#define SARADC_STATE_IDLE 0
#define SARADC_STATE_BUSY 1
#define SARADC_STATE_SUSPEND 2




static inline void saradc_power_control(int on)
{
	//struct saradc_reg3 *reg3 = (struct saradc_reg3 *)&adc->regs->reg3;
	//int nn=0;
	if (on) {
        aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,1,13,1);
        aml_set_reg32_bits(PP_SAR_ADC_REG3,1,21,1);
		//nn=100;
		//while(nn--);
		_udelay(5);

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
        aml_set_reg32_bits(PP_SAR_ADC_DELTA_11,0,13,1); /* disable bandgap */
	}
}

void saradc_enable(void)
{
    set_reg(P_SAR_SAR_ADC_REG0, 0x84004040);
    set_reg(PP_SAR_ADC_CHAN_LIST, 0);
    /* REG2: all chanel set to 8-samples & median averaging mode */
    set_reg(PP_SAR_ADC_AVG_CNTL, 0);

    set_reg(PP_SAR_ADC_REG3, 0x9388000a);
    aml_set_reg32_bits(PP_SAR_ADC_REG3, 0x14,10,5);

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

int get_adc_sample_gxbb(int ch)
{
	int value=0;
	int count=0;
	int sum=0;
	//int nn=0;
	//unsigned long flags;

	//int adc_state = SARADC_STATE_BUSY;

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


	count = 0;
	while (aml_get_reg32_bits(PP_SAR_ADC_REG0,21,5) && (count < 32)) {
		value = aml_read_reg32(PP_SAR_ADC_FIFO_RD);
		count++;
	}

	//aml_set_reg32_bits(PP_SAR_ADC_REG3,1,29,1);

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
			sum += value & 0x3ff;
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
	//printf("before cal: %d, count=%d\n", value, count);
	//uart_puts("before cal:");
	//uart_put_hex(value, 32);
	//uart_puts("\n");
    //value = saradc_get_cal_value(adc, value);
end:
    aml_set_reg32_bits(PP_SAR_ADC_REG0,1,14,1);
    aml_set_reg32_bits(PP_SAR_ADC_REG0,0,0,1);

end1:
    //aml_set_reg32_bits(PP_SAR_ADC_REG3,0,29,1);
    //adc_state = SARADC_STATE_IDLE;
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
	int rang=30;
	value = get_adc_sample_gxbb(2);
	if ((value >= 0) && (value <= 40))
		return 1;
	else if (((value>=(217-rang)) && (value<=217+rang)) ||
		     ((value>=(414-rang)) && (value<=414+rang)) ||
		     ((value>=(616-rang)) && (value<=616+rang)) ||
		     ((value>=(822-rang)) && (value<=822+rang)))
		return 2;
	else
		return 0;
}
