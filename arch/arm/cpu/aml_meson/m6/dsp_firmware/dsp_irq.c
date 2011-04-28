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
#include <asm/cache.h>

#if 0
#include <core/dsp.h>
#endif
#include <asm/arcregs.h>
#include <asm/dsp_register.h>
#include <asm/io.h>
#include <asm/irq.h>
#include <asm/system.h>
#include <asm/arch/am_regs.h>
#include <asm/ptrace.h>
#if 0
#include <codec/codec.h>

#endif

#include <asm/arch/ao_reg.h>
#include <asm/arch/am_regs.h>

#define writel __raw_writel

#define dsp_printk(fmt,args...) 
extern void dsp_mail_box2_irq(void);

struct dsp_irq_stuct	 dsp_irq_list[16];


#if 0
int  dsp_isa_irq(unsigned long arg)
{
/*
#define IREG_DSP_GEN_IRQ_STATUS0     0x2610 
#define IREG_DSP_GEN_IRQ_CLEAR0      0x2611
#define IREG_DSP_GEN_IRQ_MASK0       0x2612
#define IREG_DSP_GEN_FIRQ_MASK0      0x2613
*/
	unsigned int status=read_arc2_irq_status1();
	unsigned long intnum;
	if((intnum=(status & (IRQ2_MAILBOX2_INTB)))!=0)
	{
	  dsp_mail_box2_irq();
	//clear_arc2_irq_status1(intnum);
	}
	clear_arc2_irq_status1(status);
	return 0;
}
#endif
void dsp_int_in0_irq(int arg);
int  dsp_isa_irq(unsigned long arg)
{
	unsigned int status=read_arc2_irq_status();
	unsigned long intnum;
	//intnum = status & VIU2_VSYNC_INT;
	//intnum = status & VIU1_VSYNC_INT;
	if(status)
	{
		dsp_int_in0_irq(status);
	}
	clear_arc2_irq_status(status);
	return 0;
}

int dsp_isa_fiq(unsigned long arg)
{
#if 0
	printk("Fiq in \n");
	dsp_flush_printk_data();
#endif
	return 0;
}


//void dsp_irq_process(unsigned int irq,struct pt_regs *reg)
void dsp_irq_process(unsigned int irq)
{
#if 1
	int res=0;
	irq_func_t fn;
	struct dsp_irq_stuct  *irq_s;
	if(irq<16)
		irq_s=&dsp_irq_list[irq];
	else
	{
			dsp_printk("unknow irq irq=%d\n",irq);
			return;
	}
	fn=irq_s->func;
	if(fn!=NULL)
	{
		res=fn(irq_s->args);
		irq_s->poll_num++;
	}
	else
	{
			dsp_printk("have not register  irq=%d pending\n",irq);
	}
#endif
}
int  dsp_request_irq(int irq,irq_func_t fn,char *name,unsigned long args)
{
#if 1
	unsigned long flags;
	int res=0;
	 local_irq_save(flags);
	if(irq>=0 && irq <16  && dsp_irq_list[irq].func==NULL)
		{
		dsp_irq_list[irq].func=fn;
		dsp_irq_list[irq].args=args;
		dsp_irq_list[irq].name=name;
		dsp_irq_list[irq].poll_num=0;
#ifndef __ARC600__
		unmask_interrupt((1<<irq));
#endif /* __ARC600__ */
		
		}
	else
		res=-1;
	 local_irq_restore(flags);
	 return res;

#endif
	return 0;
}

//void dsp_fiq_process(unsigned int irq,struct pt_regs *reg)
void dsp_fiq_process(unsigned int irq)
{
#if 0
	printk("dsp_fiq_process in \n");
	dsp_flush_printk_data();
	arch_halt();
#endif
}
//void dsp_mem_error(unsigned int irq,struct pt_regs *reg)
void dsp_mem_error(unsigned int irq)
{
#if 0
/* we map the  r5 ~ r9  to store all the dsp status register */
	struct dsp_working_info *info = (struct dsp_working_info *)DSP_WORK_INFO;
	register unsigned long sp asm ("r5");
	info->sp =  sp;
	register unsigned long ilink1 asm ("r6");
	info->ilink1 =  ilink1;
	register unsigned long ilink2 asm ("r7");
	info->ilink2 =  ilink2;
	register unsigned long blink asm ("r8");
	info->blink =  blink;
	dsp_cache_wback((unsigned)info,sizeof(struct dsp_working_info));
	trans_err_code(DECODE_FATAL_ERR);

	printk("dsp_mem_error in,check the dsp working status  \n");
	printk("cat /sys/class/audiodsp/dsp_working_status  \n");
	dsp_flush_printk_data();
	arch_halt();

#endif	
}
//void dsp_intstruct_error(unsigned int irq,struct pt_regs *reg)
void dsp_intstruct_error(unsigned int irq)
{
#if 0
/* we map the  r5 ~ r9  to store all the dsp status register */
	struct dsp_working_info *info = (struct dsp_working_info *)DSP_WORK_INFO;
	register unsigned long sp asm ("r5");
	info->sp =  sp;
	register unsigned long ilink1 asm ("r6");
	info->ilink1 =  ilink1;
	register unsigned long ilink2 asm ("r7");
	info->ilink2 =  ilink2;
	register unsigned long blink asm ("r8");
	info->blink =  blink;
	dsp_cache_wback((unsigned)info,sizeof(struct dsp_working_info));
	trans_err_code(DECODE_FATAL_ERR);
	printk("dsp_intstruct_error in,transfor fatal error to reset dsp,check the dsp working status  \n");
	printk("cat /sys/class/audiodsp/dsp_working_status  \n");


	dsp_flush_printk_data();
	arch_halt();
	
#endif
}
//void dsp_exceptions(unsigned int irq,struct pt_regs *reg)
void dsp_exceptions(unsigned int irq)
{
#if 0
	trans_err_code(DECODE_FATAL_ERR);	
	printk("dsp_intstruct_error in,transfor fatal error to reset dsp \n");
	dsp_flush_printk_data();
	arch_halt();
#endif	
}

void memset(void *s,char c, int n)
{
	int i;
	char *d=s;
	for(i=0;i<n;i++){
		*d++ = c;
	}
}

void dsp_irq_init(void )
{
	memset(dsp_irq_list,0,sizeof(dsp_irq_list));//clear all the old irq functions
	write_new_aux_reg(AUX_INTR_VEC_BASE, AUDIO_DSP_START_ADDR);

	dsp_request_irq(5,dsp_isa_irq,"isa irq",0);
	dsp_request_irq(6,dsp_isa_fiq,"isa fiq",0);
	clear_arc2_irq_mask(0xffffffff);
	clear_arc2_irq_mask1(0xffffffff);
	//set_arc2_irq_mask1(IRQ2_MAILBOX2_INTB);
	set_arc2_irq_mask(VIU2_VSYNC_INT);
	//set_arc2_irq_mask(VIU1_VSYNC_INT);
}
