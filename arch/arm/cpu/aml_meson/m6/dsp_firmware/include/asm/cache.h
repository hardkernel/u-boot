
#ifndef _DSP_DCACHE_H
#define _DSP_DCACHE_H

#define L1_CACHE_SHIFT      5
#define L1_CACHE_BYTES      ( 1 << L1_CACHE_SHIFT )

#define ARC_ICACHE_LINE_LEN     L1_CACHE_BYTES
#define ARC_DCACHE_LINE_LEN     L1_CACHE_BYTES

#define ICACHE_LINE_MASK     (~(ARC_ICACHE_LINE_LEN - 1))
#define DCACHE_LINE_MASK     (~(ARC_DCACHE_LINE_LEN - 1))


extern void flush_dcache_range(unsigned long start,unsigned long end);
extern void flush_dcache_all(void);
extern void flush_and_inv_dcache_range(unsigned long start, unsigned long end);
extern void inv_dcache_range(unsigned long start, unsigned long end);
extern void flush_icache_all(void);


#define dsp_cache_wback_inv(start,size) flush_and_inv_dcache_range(start, start + size)
#define dsp_cache_wback(start,size)     flush_dcache_range(start, start + size)
#define dsp_cache_inv(start,size)       inv_dcache_range(start, start + size)

#define ____cacheline_aligned __attribute__((__aligned__(L1_CACHE_BYTES)))
#endif
