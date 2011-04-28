/*
 * (C) Copyright 2002
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>

/*
 * RTC test
 *
 * The Real Time Clock (RTC) operation is verified by this test.
 * The following features are verified:
 *   o) RTC Power Fault
 *	This is verified by analyzing the rtc_get() return status.
 *   o) Time uniformity
 *      This is verified by reading RTC in polling within
 *      a short period of time.
 *   o) Passing month boundaries
 *      This is checked by setting RTC to a second before
 *      a month boundary and reading it after its passing the
 *      boundary. The test is performed for both leap- and
 *      nonleap-years.
 */

#include <post.h>
#include <rtc.h>

#if CONFIG_POST & CONFIG_SYS_POST_RTC

#ifdef CONFIG_POST_AML
#include <aml_rtc.h>

// Define RTC register address mapping
#define RTC_COUNTER_ADDR            0
#define RTC_GPO_COUNTER_ADDR        1
#define RTC_SEC_ADJUST_ADDR         2
#define RTC_UNUSED_ADDR_0           3
#define RTC_REGMEM_ADDR_0           4
#define RTC_REGMEM_ADDR_1           5
#define RTC_REGMEM_ADDR_2           6
#define RTC_REGMEM_ADDR_3           7
//===============================================================
struct rtc_time pattern1 ={
	.tm_year = 111,
	.tm_mon = 2,
	.tm_mday = 23,
	.tm_hour = 13,
	.tm_min = 15,
	.tm_sec = 3,
};

//===============================================================
static void write_rtc(struct rtc_time *pattern)
{
	struct rtc_time tm;
	tm.tm_year = pattern->tm_year;
	tm.tm_mon = pattern->tm_mon;
	tm.tm_mday = pattern->tm_mday;						
	tm.tm_hour = pattern->tm_hour;						
	tm.tm_min = pattern->tm_min;
	tm.tm_sec = pattern->tm_sec;	 
	aml_rtc_write_time(&tm); 
	post_log("<%d>RTC: set time: %04d-%02d-%02d %02d:%02d:%02d\n", SYSTEST_INFO_L2,
						tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
						tm.tm_hour, tm.tm_min, tm.tm_sec);	
}
//===============================================================
static int read_rtc(struct rtc_time* pattern)
{
	struct rtc_time tm;
	aml_rtc_read_time(&tm);
	post_log("<%d>RTC: get time: %04d-%02d-%02d %02d:%02d:%02d\n", SYSTEST_INFO_L2, 
						tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
						tm.tm_hour, tm.tm_min, tm.tm_sec);
						
	if((tm.tm_year != pattern->tm_year) || (tm.tm_mon != pattern->tm_mon) || (tm.tm_mday != pattern->tm_mday)
		|| (tm.tm_hour != pattern->tm_hour) || (tm.tm_min != pattern->tm_min) 
		|| (tm.tm_sec < 0) || (tm.tm_sec > 60)) 
		return -1;	
	
	else	
		return 0;		
	
}
//===============================================================
int rtc_post_test (int flags)
{
	int i, ret;
	unsigned data, val;
	unsigned long   osc_clk_count1; 
	unsigned long   osc_clk_count2; 
	int diff;
		
	// test serial access
	write_rtc(&pattern1);	
	ret = 0;
	for(i=0; i<4;i++){
		if(read_rtc(&pattern1) < 0){
			post_log("<%d>%s:%d: RTC read time[%d] fail.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, i);						
			ret = -1;
		}		
	}
	// mesure 1s osc clock counter
	aml_test_1s_clock(&osc_clk_count1, &osc_clk_count2);
	post_log("<%d>%s:%d: RTC before osc counter: %d.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, osc_clk_count1);
	post_log("<%d>%s:%d: RTC after osc counter: %d.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, osc_clk_count2);
	diff = osc_clk_count2-osc_clk_count1;
	if(diff > 32768)
		post_log("<%d>%s:%d: RTC 1s interval osc counter greater: %d.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, diff-32768);
	else if(diff < 32768)
		post_log("<%d>%s:%d: RTC 1s interval osc counter less: %d.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__, 32768-diff);
	else
		post_log("<%d>%s:%d: RTC 1s osc counter diff: equal 32768.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);
	
	//test GPO counter: interval 10s GPO output from low level to high level	
	// reset GPO
	ser_access_write(RTC_GPO_COUNTER_ADDR,0x500000);	
//	aml_get_gpo_dig
	val = ser_access_read(RTC_GPO_COUNTER_ADDR);
	if(val & (1<<24))		
		post_log("<%d>%s:%d: reset gpo level RTC_GPO_COUNTER_ADDR[24] is high.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
	else
		post_log("<%d>%s:%d: reset gpo level RTC_GPO_COUNTER_ADDR[24] is low.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);					
	if(aml_get_gpo_dig())
		post_log("<%d>%s:%d: reset gpo level RTC_ADDR1[3] is high.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
	else
		post_log("<%d>%s:%d: reset gpo level RTC_ADDR1[3] is low.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
		
	
	data = 0;
	data |= (10-1) << 0;
	data |= 2<<20;
	data |= 0<<22;
	ser_access_write(RTC_GPO_COUNTER_ADDR,data);	
	udelay(5000000);
	val = ser_access_read(RTC_GPO_COUNTER_ADDR);
	if(val & (1<<24))		
		post_log("<%d>%s:%d: 5s gpo level RTC_GPO_COUNTER_ADDR[24] is high.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
	else
		post_log("<%d>%s:%d: 5s gpo level RTC_GPO_COUNTER_ADDR[24] is low.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);					
	if(aml_get_gpo_dig())
		post_log("<%d>%s:%d: 5s gpo level RTC_ADDR1[3] is high.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
	else
		post_log("<%d>%s:%d: 5s gpo level RTC_ADDR1[3] is low.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
		
	udelay(5000000);	
	val = ser_access_read(RTC_GPO_COUNTER_ADDR);
	if(val & (1<<24))		{
		post_log("<%d>%s:%d: test fail: gpo level is high.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
		ret = -1;
	}
	else{
		post_log("<%d>%s:%d: gpo level is low.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);				
	}   
	if(aml_get_gpo_dig())
		post_log("<%d>%s:%d: 10s gpo level RTC_ADDR1[3] is high.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
	else
		post_log("<%d>%s:%d: 10s gpo level RTC_ADDR1[3] is low.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);		
		
	return ret;
}
//===============================================================

#else
static int rtc_post_skip (ulong * diff)
{
	struct rtc_time tm1;
	struct rtc_time tm2;
	ulong start1;
	ulong start2;

	rtc_get (&tm1);
	start1 = get_timer (0);

	while (1) {
		rtc_get (&tm2);
		start2 = get_timer (0);
		if (tm1.tm_sec != tm2.tm_sec)
			break;
		if (start2 - start1 > 1500)
			break;
	}

	if (tm1.tm_sec != tm2.tm_sec) {
		*diff = start2 - start1;

		return 0;
	} else {
		return -1;
	}
}

static void rtc_post_restore (struct rtc_time *tm, unsigned int sec)
{
	time_t t = mktime (tm->tm_year, tm->tm_mon, tm->tm_mday, tm->tm_hour,
					   tm->tm_min, tm->tm_sec) + sec;
	struct rtc_time ntm;

	to_tm (t, &ntm);

	rtc_set (&ntm);
}

int rtc_post_test (int flags)
{
	ulong diff;
	unsigned int i;
	struct rtc_time svtm;
	static unsigned int daysnl[] =
			{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
	static unsigned int daysl[] =
			{ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
	unsigned int ynl = 1999;
	unsigned int yl = 2000;
	unsigned int skipped = 0;
	int reliable;

	/* Time reliability */
	reliable = rtc_get (&svtm);

	/* Time uniformity */
	if (rtc_post_skip (&diff) != 0) {
		post_log ("Timeout while waiting for a new second !\n");

		return -1;
	}

	for (i = 0; i < 5; i++) {
		if (rtc_post_skip (&diff) != 0) {
			post_log ("Timeout while waiting for a new second !\n");

			return -1;
		}

		if (diff < 950 || diff > 1050) {
			post_log ("Invalid second duration !\n");

			return -1;
		}
	}

	/* Passing month boundaries */

	if (rtc_post_skip (&diff) != 0) {
		post_log ("Timeout while waiting for a new second !\n");

		return -1;
	}
	rtc_get (&svtm);

	for (i = 0; i < 12; i++) {
		time_t t = mktime (ynl, i + 1, daysnl[i], 23, 59, 59);
		struct rtc_time tm;

		to_tm (t, &tm);
		rtc_set (&tm);

		skipped++;
		if (rtc_post_skip (&diff) != 0) {
			rtc_post_restore (&svtm, skipped);
			post_log ("Timeout while waiting for a new second !\n");

			return -1;
		}

		rtc_get (&tm);
		if (tm.tm_mon == i + 1) {
			rtc_post_restore (&svtm, skipped);
			post_log ("Month %d boundary is not passed !\n", i + 1);

			return -1;
		}
	}

	for (i = 0; i < 12; i++) {
		time_t t = mktime (yl, i + 1, daysl[i], 23, 59, 59);
		struct rtc_time tm;

		to_tm (t, &tm);
		rtc_set (&tm);

		skipped++;
		if (rtc_post_skip (&diff) != 0) {
			rtc_post_restore (&svtm, skipped);
			post_log ("Timeout while waiting for a new second !\n");

			return -1;
		}

		rtc_get (&tm);
		if (tm.tm_mon == i + 1) {
			rtc_post_restore (&svtm, skipped);
			post_log ("Month %d boundary is not passed !\n", i + 1);

			return -1;
		}
	}
	rtc_post_restore (&svtm, skipped);

	/* If come here, then RTC operates correcty, check the correctness
	 * of the time it reports.
	 */
	if (reliable < 0) {
		post_log ("RTC Time is not reliable! Power fault? \n");

		return -1;
	}

	return 0;
}

#endif /*CONFIG_POST_AML*/
#endif /* CONFIG_POST & CONFIG_SYS_POST_RTC */
