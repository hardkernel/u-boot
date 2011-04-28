/*
 * cntl_inf.c
 *
 *  Created on: Aug 22, 2011
 *      Author: jerry.yu
 */

#include <amlogic/nand/cntl.h>
#include <amlogic/nand/platform.h>
#include <malloc.h>
#include <errno.h>
#ifndef assert
#define assert(x) ((void)0)
#endif
#ifndef TRUE
#define TRUE 0
#endif
#ifndef FALSE
#define FALSE 1
#endif

#ifndef in_interrupt
#define in_interrupt() FALSE
#endif
static cntl_t * cntl=NULL;
int32_t cntl_try_lock(void)
{
	/**
	 * @todo implement this function
	 */
	return 0;
}
void cntl_unlock(void)
{
	/**
	 * @todo implement this function
	 */
	return;
}
cntl_t * get_v3(void);
int32_t cntl_init(struct aml_nand_platform * plat)
{

    cntl=get_v3();
    // struct aml_nand_platform *

    cntl_config(NAND_CNTL_INIT,plat);
    //uint16_t mode(0:async,1:sync mode,2 toggle),uint16_t t_rea,uint16_t t_rhoh,uint16_t sync_adjust(optional)
    cntl_config(NAND_CNTL_TIME_SET,0,0,0);
    cntl_config(NAND_CNTL_MODE,NAND_CNTL_FIFO_CMD);
    return 0;
}
cntl_t * cntl_get()
{

	return cntl;
}
int32_t cntl_config(uint32_t config, ...)
{
	int32_t ret;
	va_list args;
	va_start(args,config);
	ret=cntl->config(cntl,config,args);
	va_end(args);
	return ret;
}
uint32_t cntl_size(void)
{
	assert(cntl!=NULL);
	return cntl->size(cntl);
}
uint32_t cntl_avail(void)
{
	assert(cntl!=NULL);
	return cntl->avail(cntl);
}
uint32_t cntl_head(void)
{
	assert(cntl!=NULL);
	return cntl->head(cntl);
}
uint32_t cntl_tail(void)
{
	assert(cntl!=NULL);
	return cntl->tail(cntl);
}

int32_t cntl_ctrl(uint16_t ce, uint16_t ctrl)
{
	assert(cntl!=NULL);
	return cntl->ctrl(cntl,ce,ctrl);
}
int32_t cntl_wait(uint16_t ce,uint8_t mode,uint8_t cycle_log2)
{
	assert(cntl!=NULL);
	return cntl->wait(cntl,ce,mode,cycle_log2);
}
int32_t cntl_nop(  uint16_t ce, uint16_t cycles)
{
	assert(cntl!=NULL);
	return cntl->nop(cntl,ce,cycles);

}
int32_t cntl_sts(  jobkey_t *job, uint16_t mode)
{
	assert(cntl!=NULL);
	return cntl->sts(cntl,job,mode);
}
int32_t cntl_readbytes(void * addr, dma_t dma_mode)
{
	assert(cntl!=NULL);
	return cntl->readbytes(cntl,addr,dma_mode);

}
int32_t cntl_writebytes( void * addr, dma_t dma_mode)
{
	assert(cntl!=NULL);
	return cntl->writebytes(cntl,addr,dma_mode);

}
int32_t cntl_readecc(void * addr, void * info,dma_t dma_mode)
{
	assert(cntl!=NULL);
	return cntl->readecc(cntl,addr,info,dma_mode);
}

int32_t cntl_writeecc(void * addr, void * info,dma_t dma_mode)
{
	assert(cntl!=NULL);
	return cntl->writeecc(cntl,addr,info,dma_mode);
}
jobkey_t *  cntl_job_get(uint32_t mykey)
{
	assert(cntl!=NULL);
	return cntl->job_get(cntl,mykey);
}
int32_t cntl_job_free( jobkey_t * job)
{
		assert(cntl!=NULL);
		return cntl->job_free(cntl,job);
}
int32_t cntl_job_lookup( jobkey_t ** jobs,uint32_t size)
{
	assert(cntl!=NULL);
	return cntl->job_lookup(cntl,jobs,size);
}
int32_t cntl_job_status(jobkey_t * job,uint32_t key)
{
	int32_t ret;
	assert(cntl->job_key(cntl,job)!=key);
	if((ret=cntl->job_status(cntl,job))<0 )
		return -1;

	return ret;
}
int32_t cntl_error(void * desc)
{
	return cntl_config(NAND_CNTL_ERROR,desc);
}
void cntl_continue(void)
{
	cntl_config(NAND_CNTL_GO);
}

void cntl_reset(void)
{
	cntl_config(NAND_CNTL_RESET);
}



int32_t cntl_seed(  uint16_t seed)//0 disable
{
	assert(cntl!=NULL);
	return cntl->seed(cntl,seed);
}

int32_t cntl_ecc2dma(ecc_t * orig,dma_desc_t* dma,uint32_t size,uint32_t short_size,uint32_t seed)
{
	assert(cntl!=NULL);
	return cntl->ecc2dma(orig,dma,size,short_size,seed);
}

int32_t cntl_info2data(void * data,void * info,dma_t dma)//-1,found ecc fail,>=0,ecc counter .
{
	assert(cntl!=NULL);
	return cntl->info2data(data,info,dma);
}

int32_t cntl_data2info(void * info,void * data,dma_t dma)//-1,error found
{
	assert(cntl!=NULL);
	return cntl->data2info(info,data,dma);
}



int32_t cntl_write_cmd(cmd_queue_t * in,cmd_queue_t * out)
{
	assert(cntl!=NULL&&cntl->convert_cmd);
	assert(out!=NULL);
	//assert(in!=NULL);
	int32_t ret=0;
	if(in!=NULL)
		ret = cntl->convert_cmd(cntl,in, out);
	if(ret>=0)
	{
		if(cntl_try_lock())
			return -EAGAIN;
		ret=cntl->write_cmd(cntl,out);
		cntl_unlock();
	}
	return ret;
}
int32_t cntl_finish_jobs(void (* cb_finish)(uint32_t key,uint32_t st))
{
	assert(cb_finish!=NULL);
	jobkey_t * job;
	uint32_t key;
	uint32_t st;
	while(cntl_job_lookup(&job,1)>0)
	{
		if(cntl_try_lock())
			continue;
		key=cntl->job_key(cntl,job);
		st=cntl->job_status(cntl,job);
		cntl->job_free(cntl,job);
		cntl_unlock();
		cb_finish(key,st);
	}

	return 0;
}
#ifndef CONFIG_NANDCMD_QUEUE_SIZE
#define CONFIG_NANDCMD_QUEUE_SIZE 128
#endif
cmd_queue_t * cmd_queue_alloc(void)
{
	cmd_queue_t * ret=malloc(sizeof(*ret));
	if(ret==NULL)
		return NULL;
	memset(ret,0,sizeof(*ret));
	ret->maxsize=CONFIG_NANDCMD_QUEUE_SIZE;
	ret->queue=malloc(ret->maxsize*sizeof(*(ret->queue)));
	if(ret->queue==NULL)
	{
		free(ret);
		return NULL;
	}
	memset(ret->queue,0,ret->maxsize*sizeof(*(ret->queue)));
	return ret;
}
void cmd_queue_free(cmd_queue_t * queue)
{
	free(queue->queue);
	free(queue);
}

static int32_t cmd_queue_write_sigle(cmd_queue_t * queue,cmd_t cmd)
{
	typeof(queue->queue)  new_queue;
	assert(queue&&queue->queue);
	if(queue->size==queue->maxsize)
	{

		new_queue=malloc((queue->maxsize+CONFIG_NANDCMD_QUEUE_SIZE)*sizeof(*new_queue));
		if(new_queue==NULL)
		{
			assert(0);
			return -1;
		}
		memcpy(new_queue,queue->queue,(queue->maxsize)*sizeof(*new_queue));
		free(queue->queue);
		memset(&new_queue[(CONFIG_NANDCMD_QUEUE_SIZE)],0,(CONFIG_NANDCMD_QUEUE_SIZE)*sizeof(*new_queue));
		queue->maxsize+=CONFIG_NANDCMD_QUEUE_SIZE;
		queue->queue=new_queue;
	}
	queue->queue[queue->size++]=cmd;
	return 0;
}
int32_t cmd_queue_write(cmd_queue_t * queue,uint32_t count,...)
{
	va_list args;
	int32_t i;
	int32_t ret;
	if(count==0)
		return 0;
	typeof(*(queue->queue)) cmd;
	va_start(args,count);
	for(i=0,ret=0;i<count&&ret==0;i++)
	{
		cmd= va_arg(args,typeof(*(queue->queue)));
		ret=cmd_queue_write_sigle(queue,cmd);
	}
	va_end(args);
	return ret;
}
cmd_t cmd_queue_get_next(cmd_queue_t* queue)
{
	if(queue->cur==queue->size)
		return 0;
	return queue->queue[queue->cur++];
}

