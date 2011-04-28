/*
Amlogic RTC test
Focus on: Long test RTC counting -- days
*/

#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <rtc.h>
#include <aml_rtc.h>

//===============================================================
int do_rtc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *s;
	char *end;
	int i;
	unsigned val[6];
	struct rtc_time tm;
	
	if(strncmp(argv[1], "write", 5) == 0){
		s=argv[2];
		for(i=0; i<6; i++){
				val[i] = s ? simple_strtoul(s, &end, 10) : 0;
				if (s)
					s = (*end) ? end+1 : end;
		}	
		
		tm.tm_year = val[0]-1900;
		tm.tm_mon = val[1]-1;
		tm.tm_mday = val[2];
		tm.tm_hour = val[3];
		tm.tm_min = val[4];
		tm.tm_sec = val[5];
		aml_rtc_write_time(&tm); 
		printf("finish writing time: %04d-%02d-%02d %02d:%02d:%02d\n", 
							tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
							tm.tm_hour, tm.tm_min, tm.tm_sec);
		return 0;
	}
	else if(strncmp(argv[1], "read", 4) == 0){
		aml_rtc_read_time(&tm);
		printf("get time: %04d-%02d-%02d %02d:%02d:%02d\n", 
						tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
						tm.tm_hour, tm.tm_min, tm.tm_sec);
		return 0;
	}
	else{
		printf("arg error\n");
		return -1;	
	}

}

U_BOOT_CMD(
	rtc,	3,	1,	do_rtc,
	"RTC read/write time",
	"[write][year:month:day:hour:minute:second]\n"
	"[read]\n"	
);