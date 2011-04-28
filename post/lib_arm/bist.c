#include <common.h>
#include <asm/system.h>
#include <asm/cache.h>
#include <asm/arch/io.h>
#include <post.h>


#define ON 1
#define OFF 0
#define MAX_ITEM_NAME_LEN 15

#if CONFIG_POST & CONFIG_SYS_POST_BSPEC2

struct bist_func{
	char name[MAX_ITEM_NAME_LEN];
	int (*func)(void);	
};

const char l1icache_cmd[] = {
	0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0,
	0x1, 0x6, 0x7, 0x6, 0x7, 0x6, 0x7, 0x6,
	0x7, 0x2, 0x3, 0x2, 0x3, 0x6, 0x7, 0x6,
	0x7, 0x6, 0x7, 0x4, 0x5, 0x4, 0x5, 0x0, 
	0x1, 0x0, 0x1, 0x4, 0x5, 0x2, 0x3, 0x0, 0x1,
};

const char l1dcache_cmd[] = {
		0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0,
		0x1, 0x6, 0x7, 0x7, 0x6, 0x7, 0x6, 0x7,
		0x6, 0x7, 0x2, 0x3, 0x2, 0x3, 0x6, 0x7,
		0x2, 0x3, 0x2, 0x3, 0x3, 0x0, 0x1, 0x1,
		0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x4, 0x5,
		0x2, 0x3, 0x3, 0x0, 0x1
};
//=========================================================================
// l1icache
static int bist_l1icache(void)
{
	int status, i, ret;
	unsigned val;
	
	ret = 0;
	status = icache_status();
	//if(status == OFF){
	//	 icache_invalid();
	//	 icache_enable();
	//}
	for(i=0;  i<ARRAY_SIZE(l1icache_cmd);  i++)
		WRITE_CBUS_REG(ISA_BIST_REG0, l1icache_cmd[i]);
	
	udelay(1000);
	WRITE_CBUS_REG(ISA_BIST_REG0, 3);
	udelay(1000);
	val = READ_CBUS_REG(ISA_BIST_REG1);
	if(val & 0x20000){		
		post_log("<%d>%s:%d: bist:l1icache: test fail.\n", SYSTEST_INFO_L2, __FILE__, __LINE__);
		ret=-1;
	}
	else{		
		post_log("<%d>bist:l1dcache: test pass.\n", SYSTEST_INFO_L2);
		ret = 0;	
	}	
	
	if(status == OFF)
		icache_disable();
	return ret;
}

//=========================================================================
static int bist_l1dcache(void)
{
	int status, i, ret;
	unsigned val;
	
	ret = 0;
	status = dcache_status();
	//if(status == OFF){
	//	dcache_flush();
	//	dcache_enable();		
	//}
	
	for(i=0;  i < ARRAY_SIZE(l1dcache_cmd); i++)
		WRITE_CBUS_REG(ISA_BIST_REG0, l1dcache_cmd[i])	;
	
	udelay(1000);
	WRITE_CBUS_REG(ISA_BIST_REG0, 3);
	udelay(1000);
	val = READ_CBUS_REG(ISA_BIST_REG1);
	if(val & 0x4000){		
		post_log("<%d>%s:%d: bist:l1dcache: test fail.\n", SYSTEST_INFO_L2, __FUNCTION__, __LINE__);
		ret=-1;
	}
	else{		
		post_log("<%d>bist:l1dcache: test pass.\n", SYSTEST_INFO_L2);
		ret = 0;		
	}
		
	if(status == OFF)
		dcache_disable();	
	return ret;
}

//=========================================================================
struct bist_func bist_t [] = {
	// L1 icache bist
	{
		.name = "l1icache",
		.func = bist_l1icache,
	},
	// L1 dcache bist
	{
		.name = "l1dcache",
		.func = bist_l1dcache,
	},	
};

//=========================================================================
// bist l1icache/l1dcache
int bist_post_test(int flags)
{
	int i;	
	int ret;
	
	ret = 0;
	for(i=0; i<ARRAY_SIZE(bist_t); i++){
		if(bist_t[i].func() < 0){			
			post_log("<%d>bist %s: test fail.\n", SYSTEST_INFO_L2, bist_t[i].name);
			ret = -1;
		}
		else			
			post_log("<%d>bist %s: test pass/\n", SYSTEST_INFO_L2, bist_t[i].name);	
	}
	return ret;	
}

#endif