
#include <common.h>
#include <asm/saradc.h>
#include <asm/arch/board_id.h>
#include <asm/arch/secure_apb.h>

//#define SARADC_DEBUG_INFO
#define ADC_SAMPLE_TOTAL				10

const unsigned int  sam_val[] = {38, 113, 187, 262, 340,\
		420, 502, 582, 659, 735, 808, 884, 992};
const unsigned int SAMP_COUNT = sizeof(sam_val)/sizeof(unsigned int);
static unsigned int adc_sample[ADC_SAMPLE_TOTAL] = {0};

void bubble_sort(unsigned int *a,int size) {
	int temp=0, pass=0, k=0;
	for (pass=1;pass<size;pass++) {
		for (k=0;k<size-pass;k++) {
			if (a[k]>a[k+1]) {
				temp=a[k];
				a[k]=a[k+1];
				a[k+1]=temp;
			}
		}
	}
}

unsigned int get_board_id(void)
{
	unsigned int val = 0, idx = 0, loop = 0;

	saradc_enable();
	for (loop=0; loop<ADC_SAMPLE_TOTAL; loop++) {
		adc_sample[loop] = get_adc_sample_gxbb(1);
	}
	//val = get_adc_sample_gxbb_12bit(1);
	saradc_disable();

#ifdef SARADC_DEBUG_INFO
	printf("adc sample    :");
	for (loop=0; loop<ADC_SAMPLE_TOTAL; loop++) {
		printf(" %d", adc_sample[loop]);
	}
	printf("\n");
#endif

	bubble_sort(adc_sample, ADC_SAMPLE_TOTAL);

#ifdef SARADC_DEBUG_INFO
	printf("adc sample seq:");
	for (loop=0; loop<ADC_SAMPLE_TOTAL; loop++) {
		printf(" %d", adc_sample[loop]);
	}
	printf("\n");
#endif

	for (loop=1;loop<(ADC_SAMPLE_TOTAL-1);loop++) {
		val += adc_sample[loop];
	}
	val = val >> 3;

	for (idx=0; idx<SAMP_COUNT; idx++)
	{
		if (val <= sam_val[idx])
			break;
	}

	printf("      Board ID = %2d\n", idx);

	return idx;
}
