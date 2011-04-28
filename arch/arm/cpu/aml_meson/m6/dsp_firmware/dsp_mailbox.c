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
 *
 *
 * mailbox contrl 
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
#include <core/dsp_mailbox.h>

struct mail_msg  *mailbox_reg1;
struct mail_msg   *mailbox_reg2;
struct dsp_mailbox_list	mailbox_irqlist[32];
struct dsp_mailbox_list	Intin0_irqlist[32];

void dsp_int_in0_irq(int arg)
{
	unsigned long status;
	int i;
	status = arg;
	for(i=0;(i<32)&& status;i++)
	{
		if(status & 1)
		{
			if(Intin0_irqlist[i].func != NULL)
			{
				Intin0_irqlist[i].func(i,Intin0_irqlist[i].args);
				Intin0_irqlist[i].poll_num++;
			}
		}
		status =status>>1;
	}
}

void dsp_mail_box2_irq(void)
{
	unsigned long status;
	int i;


	status=READ_MPEG_REG(ASSIST_MBOX2_IRQ_REG);
	for(i=0;i<32 && status>0;i++)
		{
		if(status&1)
			{
			WRITE_MPEG_REG(ASSIST_MBOX2_CLR_REG,(1<<i));//clear mailbox status
			if(mailbox_irqlist[i].func!=NULL)
				{
				mailbox_irqlist[i].func(i,mailbox_irqlist[i].args);
				mailbox_irqlist[i].poll_num++;
                }
			}
		status=status>>1;
		}
}
int dsp_mailbox_send(int overwrite,int num,int cmd,const char *data,int len)
{
	unsigned long flags;
	int res=-1;
#if 0
	local_irq_save(flags);
	if(overwrite || mailbox_reg1[num].status==0)
		{
			struct mail_msg *m;
			m=&mailbox_reg1[num];
			m->cmd=cmd;
			m->data=(char *)data;
			m->len=len;
			m->status=1;
			after_change_mailbox(m);
			if(data!=NULL && len >0)
				flush_dcache_range((unsigned long)data,(unsigned long)data+len);
			MAIBOX1_IRQ_ENABLE(num);
			SYS_TRIGGER_IRQ(num);
			res=0;
		}
	local_irq_restore(flags);
#endif
	return res;
}



int dsp_request_mailbox(int num,char *name,mailbox_func_t fn,unsigned long args)
{
	unsigned long flags;
	if(num>31 || num <0)
		return -1;
	local_irq_save(flags);
	if(mailbox_irqlist[num].func==NULL)
		{
		mailbox_irqlist[num].name=name;
		mailbox_irqlist[num].func=fn;
		mailbox_irqlist[num].args=args;
		}
	else
		{
		local_irq_restore(flags);
		return -1;
		}
	local_irq_restore(flags);
	return num;
}
int dsp_request_int_int0(int num,char *name,mailbox_func_t fn,unsigned long args)
{
	unsigned long flags;
	if(num>31 || num <0)
		return -1;
	local_irq_save(flags);
	if(Intin0_irqlist[num].func==NULL)
	{
		Intin0_irqlist[num].name=name;
		Intin0_irqlist[num].func=fn;
		Intin0_irqlist[num].args=args;
	}
	else
	{
		local_irq_restore(flags);
		return -1;
	}
	local_irq_restore(flags);
	return num;
}

int dsp_get_mailbox_data(int num,struct mail_msg *msg)
{
#if 0
	struct mail_msg *m;
	unsigned long flags;
	if(num>31 || num <0)
			return -1;
	local_irq_save(flags);
	m=&mailbox_reg2[num];
	pre_read_mailbox(m);
	msg->cmd=m->cmd;
	msg->data=m->data;
	msg->status=m->status;
	msg->len=m->len;
	m->status=0;
	after_change_mailbox(m);
	if(msg->data && msg->len)
		dsp_cache_inv((unsigned)msg->data,msg->len);	
	local_irq_restore(flags);
#endif
	return 0;
}



void dsp_mailbox_init(void)
{
#if 0
	mailbox_reg1=(struct mail_msg *)MAILBOX1_REG(0);
	mailbox_reg2=(struct mail_msg *)MAILBOX2_REG(0);
	memset((void*)mailbox_reg1,0,sizeof(mailbox_reg1));
	memset((void*)mailbox_reg2,0,sizeof(mailbox_reg2));
	memset((void*)mailbox_irqlist,0,sizeof(mailbox_irqlist));
	dsp_cache_wback((unsigned long)mailbox_reg1, sizeof(mailbox_reg1));
	dsp_cache_wback((unsigned long)mailbox_reg2, sizeof(mailbox_reg2));
	dsp_cache_wback((unsigned long)mailbox_irqlist, sizeof(mailbox_irqlist));
#endif
}

