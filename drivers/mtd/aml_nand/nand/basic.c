/*
 * basic.c
 *
 *  Created on: Aug 23, 2011
 *      Author: jerry.yu
 */
#include <common.h>

#include <linux/types.h>
#include <amlogic/nand/cntl.h>
#include <amlogic/nand/platform.h>
#include <amlogic/nand/types.h>
#include <amlogic/debug.h>
#include <asm/arch/nand.h>

#include <asm/dma-mapping.h>
#include "nand_cmd.h"

typedef struct nand_cfg_s nand_cfg_t;
typedef struct nand_ce_s nand_ce_t;
struct nand_ce_s{
	unsigned dummy;
};
struct nand_cfg_s{
	nand_dev_t type;
	uint32_t   ce_mask;
	nand_ce_t  chip[4];
};
struct id_read_s{
	uint64_t id;
	uint64_t onfi;
};
static nand_cfg_t nand_cfg;
/*
typedef struct cmd_queue_s cmd_queue_t;
struct cmd_queue_s{
	uint32_t maxsize;
	uint32_t cur;
	uint32_t size;
	cmd_t 	* queue;
};

#define NAND_CMD_STAT_START 0
#define NAND_CMD_STAT_END 	-1
#define DECLARE_POUT(out) cmd_queue_t * pout=out
#define WRITE_CMD_QUEUE(a,b...) cmd_queue_write(pout,CNTL_CMD_##a##_COUNT,CNTL_CMD_##a(b))
*/
int32_t nand_reset_identy_queue(cmd_queue_t * out,int32_t st,int32_t ce,struct id_read_s * id,jobkey_t * job)
{
	DECLARE_POUT(out);
	switch(st)
	{
	case NAND_CMD_STAT_END:
		return -1;
	case NAND_CMD_STAT_START:
		WRITE_CMD_QUEUE(CLE, ce, NAND_CMD_RESET);
		return 1;
	default:
		WRITE_CMD_QUEUE(NOP, ce, 0);
		WRITE_CMD_QUEUE(CLE, ce, NAND_CMD_STATUS);
		WRITE_CMD_QUEUE(WAIT, ce, NAND_RB_IO6, 31);
		WRITE_CMD_QUEUE(STATUS, STS_NO_INTERRUPT, job);
		/// read uni id
		WRITE_CMD_QUEUE(CLE, ce, NAND_CMD_READID);
		WRITE_CMD_QUEUE(ALE, ce, 0);
		WRITE_CMD_QUEUE(READ,sizeof(id->id),&(id->id),NULL);

		/// read onfi id
		WRITE_CMD_QUEUE(CLE, ce, NAND_CMD_READID);
		WRITE_CMD_QUEUE(ALE, ce, 0x20);
		WRITE_CMD_QUEUE(READ,sizeof(id->onfi),&(id->onfi),NULL);
		break;
	}
	return NAND_CMD_STAT_END;
}
int32_t nand_write_finish(cmd_queue_t * out,jobkey_t * job)
{
	DECLARE_POUT(out);
	WRITE_CMD_QUEUE(NOP, 4, 0);
	WRITE_CMD_QUEUE(STATUS, STS_NO_INTERRUPT, job);
	return 0;
}
int32_t nand_reset_identy(nand_cfg_t * cfg,struct aml_nand_platform * plat,cntl_t *cntl)
{
	clrbits_le32(P_PAD_PULL_UP_REG3,(0xff<<0) | (1<<16));
	int32_t num,i,max_ce;
	void * addr;
	max_ce=min(cntl->feature&FEATURE_SUPPORT_MAX_CES,plat->ce_num?plat->ce_num:FEATURE_SUPPORT_MAX_CES);
	struct id_read_s *id;
	addr=dma_alloc_coherent(max_ce*sizeof(struct id_read_s),(dma_addr_t *)&id);
	jobkey_t * job[5];
	 for(i=0;i<5;i++)
			job[i]=cntl_job_get((i|0x100));
#if 0
	for(i=0;i<max_ce;i++)
	{
		cntl_ctrl(i,NAND_CLE(NAND_CMD_RESET));

	}
	for(i=0;i<max_ce;i++)
	{
		cntl_nop(i,1);
		cntl_ctrl(i,NAND_CLE(NAND_CMD_STATUS));
		cntl_wait(i,NAND_RB_IO6,31);//wait for 1M/16 nand cycle , about 1sec
		cntl_sts(job[i],STS_NO_INTERRUPT);
		/// read uni id
		cntl_ctrl(i,NAND_CLE(NAND_CMD_READID));
		cntl_ctrl(i,NAND_ALE(0));
		cntl_readbytes(&id[i].id,sizeof(id[i].id));
		/// read onfi id
		cntl_ctrl(i,NAND_CLE(NAND_CMD_READID));
		cntl_ctrl(i,NAND_ALE(0x20));
		cntl_readbytes(&id[i].onfi,sizeof(id[i].onfi));
	}
	cntl_sts(job[4],STS_NO_INTERRUPT);
#else
	cmd_queue_t *pout;
	cmd_queue_t * p=cmd_queue_alloc();
	uint32_t cemask=0;
	int32_t stat[max_ce];
	assert(p!=NULL);
	for (i = 0; i < max_ce; i++)
	{
		stat[i]=NAND_CMD_STAT_START;

	}
	while (cemask != ((1 << max_ce) - 1))
	{
		for (i = 0; i < max_ce; i++)
		{
			if(stat[i]==NAND_CMD_STAT_END)
				continue;
			stat[i]=nand_reset_identy_queue(p,stat[i],i,&id[i],job[i]);
			if(stat[i]==NAND_CMD_STAT_END)
				cemask|=(1<<i);
		}
	}
	nand_write_finish(p,job[4]);
	pout=cmd_queue_alloc();
	cntl_write_cmd(p,pout);
	cmd_queue_free(p);
	cmd_queue_free(pout);
#endif

	while(cntl_job_status(job[4],4|0x100)<0)
	{
		uint32_t ce;
		if(cntl_error(&ce)==NAND_CNTL_ERROR_TIMEOUT)
		{
			nanddebug(1,"ce %d timeout",ce);
			cntl_continue();
		}
	};

	amlogic_log_print();
	printf("\n");


/**
 * @todo implement this function
	if(nand_cfg_set(&nand_cfg,0,id)<0)
		return -1;
*/

	for(i=0;i<max_ce;i++)
	{
		nanddebug(1,"CE%d:id=%llx,onfi=%llx,sts=%x",i,id[i].id,id[i].onfi,cntl_job_status(job[i],i|0x100));
		cntl_job_free(job[i]);
	}
	cntl_job_free(job[4]);
	nand_cfg.ce_mask=1;
	num=1;
	for(i=1;i<max_ce;i++)
	{
		if(id[i].id!=id[0].id||id[i].onfi!=id[0].onfi)
		{
			nand_cfg.ce_mask&=~(1<<i);
			continue;
		}
		nand_cfg.ce_mask|=(1<<i);
		num++;
	}

	dma_free_coherent(max_ce*sizeof(struct id_read_s),(dma_addr_t )id,addr);



	return num;
}
int32_t nand_probe(struct aml_nand_platform * plat)
{
	assert(plat&&plat->claim_bus);
	plat->claim_bus(0xfffff);
	if(cntl_init(plat)<0)
		return -1;
	if(nand_reset_identy(&nand_cfg,plat,cntl_get())<0)
		return -1;
	return 0;
}
