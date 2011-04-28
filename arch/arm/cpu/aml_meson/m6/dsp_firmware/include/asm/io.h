/*
This is the headers for DSP read/write 
Don't change this register before know the details;
more info can ask:zhi.zhou@amlogic.com
*/

#ifndef DSP_IO_RW_HEADER
#define DSP_IO_RW_HEADER
#include <asm/cache.h>
#include <asm/system.h>
#define PAGE_SIZE	(1<<13)
#ifndef __ARC600__
static inline unsigned long __ssxchg (unsigned long with,
                                    __volatile__ void *ptr, int size)
{
    __asm__ __volatile__ ("ex.di  %0, [%1]"
                  : "=r" (with),"=r"(ptr)
                  : "0" (with), "1" (ptr)   
                  : "memory" );

    return (with);
}
#define my_ch(r,v)	__ssxchg(v,(__volatile__ void *)r,4)
#endif/* __ARC600__ */
static inline void sync(void )
{
    __asm__ __volatile__ ("sync" ::: "memory" );
}

#ifndef __ARC600__
#define DSP_RD(reg)	({dsp_cache_inv((unsigned long)reg,(4));(*((volatile unsigned long *)reg));})
#define DSP_WD(reg,val)	({(*((volatile unsigned long *)(reg)))=val;dsp_cache_wback((volatile unsigned long)reg,(4));sync();dsp_cache_inv((unsigned long)reg,(4));})
#else
#define DSP_RD(reg)	({sync();dsp_cache_inv((unsigned long)reg,(4));(*(( unsigned long *)reg));})
#define DSP_WD(reg,val)	({(*((volatile unsigned long *)(reg)))=val;dsp_cache_wback(( unsigned long)reg,(4));sync();dsp_cache_inv((unsigned long)reg,(4));})
#endif

#if 0
#define IO_WRITE32(val,addr)  __asm__ __volatile__ ("st.di %0,[%1]\n""sync\n"::"r"(val),"r"(addr));
#define IO_READ32(addr) 		({unsigned int val=0;__asm__ __volatile__ ("sync\n""ld.di %0,[%1]\n":"=&r"((val)):"r"((addr)));val;})
#define IO_WRITE8(val,addr) __asm__ __volatile__ ("stb.di %0,[%1]\n""sync\n"::"r"((val)),"r"((addr)));
#define IO_READ8(addr)	({unsigned int val=0;__asm__ __volatile__ ("sync\n""ldb.di %0,[%1]":"=&r"((val)):"r"((addr)));val;})
#endif

#define _Inline  inline
#define _ASM 	__asm

static _Inline void IO_WRITE32(unsigned val, unsigned addr)
{
    *((volatile unsigned*)(addr)) = val;
    _ASM("sync");
}
static _Inline unsigned IO_READ32(unsigned addr)
{
    _ASM("sync");
    return *((volatile unsigned*)(addr));
}
static _Inline  void IO_WRITE8(unsigned char val, unsigned addr)
{
    *((volatile unsigned char*)(addr)) = val;
    _ASM("sync");
}
static _Inline unsigned char IO_READ8(unsigned addr)
{
    _ASM("sync");
    return *((volatile unsigned char*)(addr));
}

#undef _Inline

#endif

