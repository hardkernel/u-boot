// 
//  misc.c
//  u-boot self-decompress
//  
//  Created by Amlogic on 2009-07-21.
//  Copyright 2009 Amlogic. All rights reserved.
// 

extern int uclDecompress(char* op, unsigned* o_len, char* ip);

//extern unsigned CONFIG_SYS_TEXT_BASE;
//extern void *UCL_TEXT_BASE;
extern void *input_data;
extern void *input_data_end;
extern void mmu_disable(void);
extern void	serial_puts   (const char *);
extern void serial_wait_tx_empty(void);
extern void dcache_disable (void);
extern void icache_disable (void);
#include <asm/cache.h>
#ifndef CONFIG_L2_OFF
#include <asm/cache-l2x0.h>
#endif

	
extern void clean_invalidable_cache();
void start_arcboot_ucl(void)
{
	typedef void (* JumpAddr)(void);	
	unsigned len ;
	//serial_puts("ucl decompress in TPL: \n");
	uclDecompress((char*)CONFIG_SYS_TEXT_BASE,&len,(char*)&input_data);

	clean_invalidable_cache();

    //serial_puts("decompress finished\n");
    //serial_wait_tx_empty();
        
#ifndef CONFIG_DCACHE_OFF       
    //mmu_disable();
    //dcache_disable();    
#endif    
#ifndef CONFIG_ICACHE_OFF
    //icache_disable();
    //icache_invalid();
#endif    
#ifndef CONFIG_L2_OFF
	//l2_cache_disable();
	//l2x0_clean_inv_all();
#endif
    unsigned int i=0;

	/* mem barrier to sync up things */
	asm("mcr p15, 0, %0, c7, c10, 4": :"r"(i));
	asm("dsb");
	asm("isb");	

    JumpAddr target=(JumpAddr)(CONFIG_SYS_TEXT_BASE);
    target();
		
}
