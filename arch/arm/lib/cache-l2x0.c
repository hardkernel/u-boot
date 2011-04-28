#include <common.h>

#include <asm/io.h>

#include <asm/cache-l2x0.h>


static void cache_wait(unsigned reg, unsigned long mask)
{
	/* wait for the operation to complete */
	while (readl(reg) & mask)
		;
}

void cache_sync(void)
{
	writel(0, L2X0_CACHE_SYNC);
	cache_wait(L2X0_CACHE_SYNC, 1);
}

void l2x0_clean_line(unsigned long addr)
{
	cache_wait(L2X0_CLEAN_LINE_PA, 1);
	writel(addr,  L2X0_CLEAN_LINE_PA);
}
void l2x0_flush_line(unsigned long addr)
{
	cache_wait( L2X0_CLEAN_INV_LINE_PA, 1);
	writel(addr,L2X0_CLEAN_INV_LINE_PA);
}
void l2x0_inv_line(unsigned long addr)
{
	cache_wait(L2X0_INV_LINE_PA, 1);
	writel(addr,  L2X0_INV_LINE_PA);
}


void l2x0_inv_all(void)
{
    
    /* invalidate all ways */
	writel(0xff, L2X0_INV_WAY);
	cache_wait(L2X0_INV_WAY, 0xff);
	cache_sync();
}


void l2x0_clean_all ()
{
   
	/* invalidate all ways */
	writel(0xff, L2X0_CLEAN_WAY);
	cache_wait(L2X0_CLEAN_WAY, 0xff);
	cache_sync();
}
void l2x0_clean_inv_all ()
{
   
	/* invalidate all ways */
	writel(0xff, L2X0_CLEAN_INV_WAY);
	cache_wait(L2X0_CLEAN_INV_WAY, 0xff);
	cache_sync();
}
void l2x0_wait_inv(void)
{
    cache_wait( L2X0_INV_LINE_PA, 1);
	cache_sync();
}
void l2x0_wait_clean(void)
{
    cache_wait( L2X0_CLEAN_LINE_PA, 1);
	cache_sync();
}
void l2x0_wait_flush(void)
{
    cache_wait( L2X0_CLEAN_INV_LINE_PA, 1);
	cache_sync();
}
#define CACHE_LINE_SIZE 32
#define debug_writel(a) 
void l2x0_invalid_range(unsigned long start, unsigned long end)
{
	if (start & (CACHE_LINE_SIZE - 1)) {
		start &= ~(CACHE_LINE_SIZE - 1);
		l2x0_flush_line(start);
		start += CACHE_LINE_SIZE;
	}

	if (end & (CACHE_LINE_SIZE - 1)) {
		end &= ~(CACHE_LINE_SIZE - 1);
		l2x0_flush_line(end);
	}

	while (start < end) {
		unsigned long blk_end = start + min(end - start, 4096UL);

		while (start < blk_end) {
			l2x0_inv_line(start);
			start += CACHE_LINE_SIZE;
		}

		if (blk_end < end) {
			
		}
	}
	cache_wait( L2X0_INV_LINE_PA, 1);
	cache_sync();
	
    
}

void l2x0_clean_range(unsigned long start, unsigned long end)
{

	
	start &= ~(CACHE_LINE_SIZE - 1);
	while (start < end) {
		unsigned long blk_end = start + end - start;

		while (start < blk_end) {
			l2x0_clean_line(start);
			start += CACHE_LINE_SIZE;
		}
	}
	cache_wait(L2X0_CLEAN_LINE_PA, 1);
	cache_sync();
	
}

void l2x0_flush_range(unsigned long start, unsigned long end)
{
	start &= ~(CACHE_LINE_SIZE - 1);
	while (start < end) {
			l2x0_flush_line(start);
			start += CACHE_LINE_SIZE;
	}
	cache_wait(L2X0_CLEAN_INV_LINE_PA, 1);
	cache_sync();
}
int l2x0_status()
{
    return readl( L2X0_CTRL) & 1;
}
void l2x0_enable()
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
		//aux |= 0x00020000;
		aux |= 0x7c420001;
		writel(aux,L2X0_AUX_CTRL);

		l2x0_inv_all();

		/* enable L2X0 */
		writel(1,  L2X0_CTRL);
	}

}
void l2x0_disable()
{
    writel(0,  L2X0_CTRL);
}


