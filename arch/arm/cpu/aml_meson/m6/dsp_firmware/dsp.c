/*
 * AMLOGIC Audio/Video streaming port driver.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 * Author:  zhou zhi<zhi.zhou@amlogic.com>
 *
 *
 *This files is uned for audio start and basic run  code;
 *
 */

#if 0
#include <asm/cache.h>

#include <core/dsp.h>
#endif
#include <asm/arcregs.h>
#if 0
#include <asm/dsp_register.h>
#include <asm/io.h>
#endif
#include <asm/irq.h>
#if 0
#include <asm/system.h>
#include <asm/init.h>
#include <version.h>

extern init_fn dsp_init_start[];
extern init_fn  dsp_init_end[];


extern void dsp_cache_init(int enable);
extern void dsp_timer_init(void);
extern void dsp_mailbox_init(void);
extern void start_system(void);
extern void dsp_memory_init(void);

#define add_data()       \
	__asm__ volatile(                       \
		"j __user_info_end       \n\t"      \
		"nop   \n\t"                        \
		"nop   \n\t"                        \
		".align 16  \n\t"                   \
		".globl __user_info_begin \n\t"     \
		"__user_info_begin:          \n\t"  \
		"    j 0x61616262            \n\t"  \
		"	 j 0x63636464            \n\t"  \
		"    j 0x61616363            \n\t"  \
		"    j 0x62626464            \n\t"  \
		"    j 0x7f7f7f7f             \n\t" \
		"	 j 0x7f7f7f7f             \n\t" \
		"    j 0x7f7f7f7f             \n\t" \
		"    j 0x7f7f7f7f             \n\t" \
		"    j 0x61616262            \n\t" \
		"	 j 0x63636464            \n\t" \
		"    j 0x61616363            \n\t" \
		"    j 0x62626464            \n\t" \
	  ".globl __user_info_end      \n\t"   \
		"__user_info_end:        \n\t"     \
		"exit: "                           \
		);

#endif
void init_device(void)
{
#if 0
	init_fn  *fn;
	for(fn=dsp_init_start;fn<dsp_init_end;fn++)
	{
		if(*fn!=NULL)
			(*fn)();
	}
#endif
}



/*
this is the dsp's first function;
do't not call big functions with some golbal variables;
*/


extern int dsp_main(void);

static int test_arc_run=0;
volatile int stop=0;
void dsp_c_entry(void )
{
#if 0
    while(stop);
#ifndef __ARC600__
	if(DSP_RD(DSP_STATUS)==DSP_STATUS_RUNING)
	{/*halt the dsp */
		printk("audio dsp halted now\n");
		dsp_flush_printk_data();
		DSP_WD(DSP_STATUS,DSP_STATUS_HALT);
		arch_halt();
	}
	else
#endif
	{
		DSP_WD(DSP_STATUS,DSP_STATUS_RUNING);
	}
	printk("DSP version=%s,dsp clock %d\n",firmware_version,get_system_clk());
	
	
#if defined(ENABLE_EFUSE) || defined(ENABLE_FIRMWARE_ENCRYPT) 
	/*add by jeff begin*/
	add_data();
#endif

	DSP_WD(DSP_JIFFIES,0);
	dsp_memory_init();
#endif 
	dsp_irq_init();
#if 0
    dsp_timer_init();

	dsp_cache_init(1);
	dsp_mailbox_init();
#endif
	dsp_irq_enable();
#if 0
	init_device();
#endif
	start_system();
				
    while(1)
    {	
        //arch_sleep();
	//test_arc_run++;
	dsp_main();
    }
}






