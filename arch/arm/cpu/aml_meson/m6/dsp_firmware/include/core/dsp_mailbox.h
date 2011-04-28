#ifndef __DSP_MAILBOX_HEADERS
#define __DSP_MAILBOX_HEADERS
#include <asm/arch/am_regs.h>


#define pre_read_mailbox(reg)	\
	dsp_cache_inv((unsigned long)reg,sizeof(*reg))
#define after_change_mailbox(reg)	\
	dsp_cache_wback((unsigned long)reg,sizeof(*reg))	


typedef int (*mailbox_func_t)(int,unsigned long);

int dsp_mailbox_send(int overwrite,int num,int cmd,const char *data,int len);
int dsp_request_mailbox(int num,char *name,mailbox_func_t fn,unsigned long args);
void dsp_mailbox_mask_read(int num);
int dsp_get_mailbox_data(int num,struct mail_msg *msg);
void dsp_mailbox_init(void);

struct dsp_mailbox_list
{
	char 		*name;
	mailbox_func_t 	func;
	unsigned long 	args;
	unsigned long poll_num;
};

#endif

