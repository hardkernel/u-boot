#ifndef __AML_SARADC_H__
#define __AML_SARADC_H__

enum{AML_ADC_CHAN_0 = 0, AML_ADC_CHAN_1, AML_ADC_CHAN_2, AML_ADC_CHAN_3,
	 AML_ADC_CHAN_4,	 AML_ADC_CHAN_5, AML_ADC_CHAN_6, AML_ADC_CHAN_7,
	 AML_ADC_SARADC_CHAN_NUM,
};

enum{AML_ADC_NO_AVG = 0,  AML_ADC_SIMPLE_AVG_1, AML_ADC_SIMPLE_AVG_2,
	 AML_ADC_SIMPLE_AVG_4,AML_ADC_SIMPLE_AVG_8, AML_ADC_MEDIAN_AVG_8,
};

#define AML_ADC_CHAN_XP	AML_ADC_CHAN_0
#define AML_ADC_CHAN_YP	AML_ADC_CHAN_1
#define AML_ADC_CHAN_XN	AML_ADC_CHAN_2
#define AML_ADC_CHAN_YN	AML_ADC_CHAN_3

enum {
	ADC_OTHER = 0,
	ADC_KEY,
}ADC_TYPE;

typedef struct adckey_info{
	const char *key;
	int   value;	/* voltage/3.3v * 1023 */
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

void saradc_enable(void);
int saradc_disable(void);
int  get_adc_sample(int chan);

#endif /*__AML_SARADC_H__*/