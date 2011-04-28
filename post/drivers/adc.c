#include <common.h>
#include <asm/saradc.h>
#include <post.h>
#include <devfont.h>

#ifdef CONFIG_SARADC

#if CONFIG_POST & CONFIG_SYS_POST_ADC

#define SYSTEST_CASES_NUM 10

#ifdef ENABLE_FONT_RESOURCE
#include <amlogic/aml_lcd.h>
extern vidinfo_t panel_info;
#define DISPLAY_WHITE_COLOR   0xffffff
#define DISPLAY_BLACK_COLOR   0x0
#define DISPLAY_BLUE_COLOR    0x80ff80
#define DISPLAY_RED_COLOR    0xfa0c12
#endif

extern struct adc_device aml_adc_devices;
#define IS_KEY(adc_val, value, tolerance) ((adc_val >= (value-tolerance))&&(adc_val <= (value+tolerance)))?1:0

//====================================================================
static void display_adc_title(char *s, int pos)
{
#ifdef ENABLE_FONT_RESOURCE
extern unsigned short GetCharHeight(void);
	int font_height=GetCharHeight();
	
	int x_cur = 40;
	int y_cur = 20+font_height*SYSTEST_CASES_NUM;
	
	if(s == NULL)
		return;
		
	DrawRect(x_cur, y_cur+font_height*pos, panel_info.vl_col-x_cur,font_height,DISPLAY_BLACK_COLOR);
	AsciiPrintf((char*)s, x_cur, y_cur+font_height*pos, DISPLAY_WHITE_COLOR);		
#endif	
}

//====================================================================
static int adc_sub_test(struct adc_info* ptest, int pos)
{
	int adc_val;
	int countdown = 10*1000*10;//10 second
	adckey_info_t *aml_adckey_info = NULL;

	if(ptest == NULL){
		post_log("<%d>%s:%d: ADC: test fail:  %s\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, "not found adc test case.");		
		return -1;
	}
	display_adc_title(ptest->tint, pos);
	saradc_enable();

	if(ADC_KEY == ptest->adc_type) {
		while(countdown > 0) {
			udelay(100);
			adc_val = get_adc_sample(ptest->chan);
			aml_adckey_info = (adckey_info_t*)ptest->adc_data;
			if(IS_KEY(adc_val, aml_adckey_info->value, aml_adckey_info->tolerance)) {
				post_log("<%d>ADC key: %s: test pass.\n", SYSTEST_INFO_L2, aml_adckey_info->key);				
				return 0;
			}
			countdown -= 1; 
		}
		post_log("<%d>%s:%d: ADC:%s: test fail: value is 0x%03x\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, aml_adckey_info->key, adc_val);		
		return -1;
	}	
	else {
		adc_val = get_adc_sample(ptest->chan);
		post_log("<%d>SARADC[Chan: %d]: 0x%03x\n", SYSTEST_INFO_L2, ptest->chan, adc_val);		
		return 0;
	}
}

//====================================================================
int adc_post_test(int flags)
{		
	int i=0;
	int ret;	
	int num = aml_adc_devices.dev_num;
	
	ret = 0;
	for(i=0; i<num; i++){
		if(adc_sub_test((aml_adc_devices.adc_device_info)+i, i) < 0)
		ret = -1;
	}
		
	return ret;	
}

#endif  /*CONFIG_POST*/
#endif  /*CONFIG_SARADC*/
