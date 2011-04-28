#ifndef _AML_RTC_H_
#define _AML_RTC_H_
#include <rtc.h>
extern int aml_rtc_init(void);
extern int aml_rtc_read_time(struct rtc_time *tm);
extern int aml_rtc_write_time(struct rtc_time *tm);

#endif