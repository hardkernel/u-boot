/*
 * debug.c
 *
 *  Created on: Aug 30, 2011
 *      Author: jerry.yu
 */

#include <common.h>
#include <malloc.h>
#include <amlogic/debug.h>
#ifndef CONFIG_AMLOGIC_LOG_SIZE
#define CONFIG_AMLOGIC_LOG_SIZE 1024*1024
#endif
#ifndef CONFIG_AMLOGIC_LOG_BUFFER
#define CONFIG_AMLOGIC_LOG_BUFFER ((void*)0x9f000000)
#endif
static uint32_t tail=0;
static uint32_t head=0;
static uint32_t mask=0;
static uint32_t * buffer=(uint32_t*)CONFIG_AMLOGIC_LOG_BUFFER;
struct log_s{
	const char * 	 file;
	const char * 	 func;
	uint32_t time;
	uint32_t priv;
	log_print_cb_t print;
	uint16_t line;
	uint16_t size;


};
static inline void amlogic_log_init(void)
{
	if(mask==0)
	{
		tail=head=0;
		mask=CONFIG_AMLOGIC_LOG_SIZE-1;
	}
}
static uint32_t avail(void)
{
	return ((head-tail-1)&mask);
}

static int32_t isfull(void)
{
	return avail()==0;
}
static uint32_t size(void)
{
	return ((tail-head)&mask);
}

static amlogic_print_log_item(void)
{
	int i,t=0;
	struct log_s w_tail;
	uint32_t * p_int=&w_tail;

	for(i=0;i<sizeof(w_tail)/sizeof(*p_int);i++)
	{
		p_int[i]=buffer[(head+i)&mask];
	}
	head+=sizeof(w_tail)/sizeof(*p_int);
	printf("\n%s +%d %s:",w_tail.file,w_tail.line,w_tail.func);
	if(head&(~mask)==(head+w_tail.size/sizeof(*p_int)))
	{
		p_int=&buffer[(head)&mask];
	}else{
		p_int=(uint32_t *)malloc(w_tail.size);
		for(i=0;i<w_tail.size/sizeof(*p_int);i++)
			p_int[i]=buffer[(head+i)&mask];
		t=1;
	}
	if(w_tail.print)
		w_tail.print(w_tail.priv,w_tail.size,p_int);
	if(p_int!=&buffer[(head)&mask])
		free(p_int);
	head+=w_tail.size/sizeof(*p_int);


}
void amlogic_log_print(void)
{
	amlogic_log_init();
	while(size())
		amlogic_print_log_item();
}
void amlogic_log(const char * file, const char * func, uint16_t line,log_print_cb_t cb ,uint32_t priv,uint16_t size_in,void * data)
{

	int32_t i;
	uint32_t size_int;
	size_int=(size_in+3)&(~3);
	struct log_s w_tail={
			.file=file,
			.func=func,
			.line=line,
			.size=size_in,
			.print=cb,
			.priv=priv,
			.time=get_utimer(0),
	};
	amlogic_log_init();
	uint32_t * p_int=(uint32_t*)&w_tail;
	size_int=(sizeof(struct log_s)+size_in)/sizeof(*p_int);

	while(avail()<size_int)
	{
		amlogic_print_log_item();
	}
	size_int=size_in;
	for(i=0;i<sizeof(w_tail)/sizeof(*p_int);i++)
	{
		buffer[(tail+i)&mask]=p_int[i];
	}
	tail+=sizeof(w_tail)/sizeof(*p_int);
	p_int=data;
	for(i=0;i<size_int/sizeof(*p_int);i++)
	{
		buffer[(tail+i)&mask]=p_int[i];
	}
	tail+=size_int/sizeof(*p_int);
}
