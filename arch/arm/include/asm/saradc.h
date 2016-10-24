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

int saradc_probe(void);
int saradc_enable(void);
int saradc_disable(void);
int get_adc_sample_gxbb(int chan);
int get_adc_sample_gxbb_12bit(int chan);
#endif /*__AML_SARADC_H__*/
