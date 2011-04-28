#include <common.h>
#include <command.h>
#include <config.h>
#include <version.h>
#include <asm/system.h>
#include <asm/cache.h>
#include <asm/io.h>
#include <asm/cache-l2x0.h>
#include <post.h>

#if CONFIG_POST & CONFIG_SYS_POST_BSPEC1

typedef unsigned long datum;
// copy from soc/lib/cache-l2x0.c

#define no_cache_mem_start 0xa1000000
#define cache_mem_start 0x81000000
#define cache_size  0x40000
#define l2_cache_line 32

//==============================================================
void cache_cache_wait(unsigned reg, unsigned long mask)
{
	/* wait for the operation to complete */
	while (readl(reg) & mask)
		;
}

void cache_cache_sync(void)
{
	writel(0, L2X0_CACHE_SYNC);
	cache_cache_wait(L2X0_CACHE_SYNC, 1);
}

void cache_l2x0_inv_all(void)
{
    
    /* invalidate all ways */
	writel(0xff, L2X0_INV_WAY);
	cache_cache_wait(L2X0_INV_WAY, 0xff);
	cache_cache_sync();
}


void cache_l2x0_clean_all (void)
{
   
	/* invalidate all ways */
	writel(0xff, L2X0_CLEAN_WAY);
	cache_cache_wait(L2X0_CLEAN_WAY, 0xff);
	cache_cache_sync();
}

int cache_l2x0_status(void)
{
    return readl( L2X0_CTRL) & 1;
}
void cache_l2x0_enable(void)
{
	__u32 aux;

	/*
	 * Check if l2x0 controller is already enabled.
	 * If you are booting from non-secure mode
	 * accessing the below registers will fault.
	 */
	if (!(readl( L2X0_CTRL) & 1)) {

		/* l2x0 controller is disabled */

		aux = readl(L2X0_AUX_CTRL);
		aux &= 0xff800fff;
		aux |= 0x00020000;
		writel(aux,L2X0_AUX_CTRL);

		cache_l2x0_inv_all();

		/* enable L2X0 */
		writel(1,  L2X0_CTRL);
	}

}
void cache_l2x0_disable(void)
{
    writel(0,  L2X0_CTRL);
}

//===================================================================================

const unsigned L2_cache_pattern[]={
    0xaaaaaaaa,
    0xdd22ee11, 0x7788bb44, 0x337755aa, 0xff00aa55,
    0xff000000, 0x000000ff, 0x00ffffff, 0xffffff00,
    0x01000200, 0x04000800, 0x10002000, 0x40008000,
    0xfefffbff, 0xf7fffeff, 0xefffbfff, 0x7fffdfff,
    0x00100020, 0x00400080, 0x00100020, 0x00400800,
    0xfffefffb, 0xfff7fffe, 0xffefffbf, 0xff7fffdf,
    0x55aa00ff, 0xaa0055ff, 0x55ffaa00, 0xff00aa55,
    0xdd22ee11, 0x7788bb44, 0xdd22ee11, 0x7788bb44,

    0x01fe00ff, 0x01fe00ff, 0x01fe00ff, 0x01fe00ff,
    0x02fc00ff, 0x02fc00ff, 0x02fc00ff, 0x02fc00ff,
    0x04fb00ff, 0x04fb00ff, 0x04fb00ff, 0x04fb00ff,
    0x08f700ff, 0x08f700ff, 0x08f700ff, 0x08f700ff,
    0x10ef00ff, 0x10ef00ff, 0x10ef00ff, 0x10ef00ff,
    0x20df00ff, 0x20df00ff, 0x20df00ff, 0x20df00ff,
    0x40bf00ff, 0x40bf00ff, 0x40bf00ff, 0x40bf00ff,
    0x807f00ff, 0x807f00ff, 0x807f00ff, 0x807f00ff,

    0xfe01ff00, 0xfe01ff00, 0xfe01ff00, 0xfe01ff00,
    0xfd02ff00, 0xfd02ff00, 0xfd02ff00, 0xfd02ff00,
    0xfb04ff00, 0xfb04ff00, 0xfb04ff00, 0xfb04ff00,
    0xf708ff00, 0xf708ff00, 0xf708ff00, 0xf708ff00,
    0xef10ff00, 0xef10ff00, 0xef10ff00, 0xef10ff00,
    0xdf20ff00, 0xdf20ff00, 0xdf20ff00, 0xdf20ff00,
    0xbf40ff00, 0xbf40ff00, 0xbf40ff00, 0xbf40ff00,
    0x7f80ff00, 0x7f80ff00, 0x7f80ff00, 0x7f80ff00
    };
//==============================================================
unsigned test_w_l2cache(unsigned fill_value, unsigned modify_value)
{
	//unsigned pattern;
	unsigned *addr;//, *addr1;
	unsigned size, err_addr, val;
	int i;
	//int status;
	
	// disable l2-cache
	cache_l2x0_enable();	
	icache_invalid();
	dcache_clean();
	cache_l2x0_clean_all();					
	cache_l2x0_disable();		
	
	// clear no-cache memory block
	addr = (unsigned*)no_cache_mem_start;
	size = (cache_size)/sizeof(unsigned);
	for(i=0; i<size; i++, addr++)
		*addr = fill_value;		
	
	// map cache-memory data to cache
	addr = (unsigned*)cache_mem_start;
	size = cache_size/l2_cache_line;	
	cache_l2x0_enable();		
	for(i=0; i<size; i++, addr+=l2_cache_line)
		val = *addr;
		
	// write to cache
	addr = (unsigned*)cache_mem_start;	
	size = cache_size/sizeof(unsigned);	
	for(i=0; i<size; i++, addr++)
		*addr = modify_value;	
	
	dcache_clean();
	cache_l2x0_clean_all();
	cache_l2x0_disable();
	
	err_addr = 0;
	addr = (unsigned*)no_cache_mem_start;
	for(i=0; i<size; i++, addr++){
		if(*addr != modify_value){						
			err_addr = (unsigned)addr;			
			break;
		}
	}		
	return err_addr;	
}
//void s_out_reg(unsigned r0,unsigned r1)
//{
//	printf("r0:%x  r1:%x\n",r0,r1);
//}
//==============================================================
int l2cache_post_test(int flags)
{
	int i;
	unsigned result, pattern;
	//int status;
	
	for(i=0; i<ARRAY_SIZE(L2_cache_pattern); i++){		
		result = test_w_l2cache(0x55555555, L2_cache_pattern[i]);		
		if(result != 0){
			pattern = L2_cache_pattern[i];
			break;
		}
					
		result = test_w_l2cache(0x55555555, ~L2_cache_pattern[i]);		
		if(result != 0){
			pattern = ~L2_cache_pattern[i];
			break;
		}			
	}
		
	if(i<ARRAY_SIZE(L2_cache_pattern)){	
		post_log("<%d>%s:%d: l2cache: test fail: Error address=0x%x, pattern=0x%x\n", SYSTEST_INFO_L2,
													__FUNCTION__, __LINE__, result, pattern);
		return -1;
	}
	else{		
		post_log("<%d>l2cache test pattern count=%d\n", SYSTEST_INFO_L2, ARRAY_SIZE(L2_cache_pattern));
		return 0;	
	}	
	
}

#endif