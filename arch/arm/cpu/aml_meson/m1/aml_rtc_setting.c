
#include <common.h>
#include <asm/io.h>

/******************************************************************************
In aml_rtc_init() function: (driver/rtc/aml_rtc.c)
	static_register_write(data);	

M1: data=0x0004;
A3: data=0x380a;	
M3: data=0x3c0a;
 *****************************************************************************/
unsigned long get_rtc_static_reg_init_val(void)
{
	return 0x0004;
}