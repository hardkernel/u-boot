#include <stdarg.h>
#include <common.h>
#include <amlogic/nand/cntl.h>
#include <amlogic/nand/platform.h>
#include <asm/io.h>
#include <asm/arch/nand.h>
#include <asm/arch/clock.h>
#include <asm/dma-mapping.h>
#include <amlogic/debug.h>
#define NAND_V3_DETAILS 16
static ecc_t ecc_table[] ={
    { .name = "BCH OFF  ", .mode = 0, .bits = 0,  .data = 0,    .parity = 0,    .info = 0,.max=(1<<14)-1 },
    { .name = "BCH 8/512", .mode = 1, .bits = 8,  .data = 64,   .parity = 14,   .info = 2,.max=0x3f*512  },
    { .name = "BCH  8/1k", .mode = 2, .bits = 8,  .data = 128,  .parity = 14,   .info = 2,.max=0x3f*1024 },
    { .name = "BCH 16/1k", .mode = 3, .bits = 16, .data = 128,  .parity = 28,   .info = 2,.max=0x3f*1024 },
    { .name = "BCH 24/1k", .mode = 4, .bits = 24, .data = 128,  .parity = 42,   .info = 2,.max=0x3f*1024 },
    { .name = "BCH 30/1k", .mode = 5, .bits = 30, .data = 128,  .parity = 54,   .info = 2,.max=0x3f*1024 },
    { .name = "BCH 40/1k", .mode = 6, .bits = 40, .data = 128,  .parity = 70,   .info = 2,.max=0x3f*1024 },
    { .name = "BCH 60/1k", .mode = 7, .bits = 60, .data = 128,  .parity = 106,  .info = 2,.max=0x3f*1024 },
    { .name = NULL, .mode = 0, .bits = 0, .data = 0, .parity = 0,.info = 0 },
};
static int32_t v3_config(cntl_t * cntl, uint32_t config, va_list args); //done the basic
static uint32_t v3_size(cntl_t *);
static uint32_t v3_avail(cntl_t *);
static uint32_t v3_head(cntl_t *);
static uint32_t v3_tail(cntl_t *);
static int32_t v3_ctrl(cntl_t *, uint16_t ce, uint16_t ctrl);
static int32_t v3_wait(cntl_t *, uint16_t ce,uint8_t mode,uint8_t cycle_log2);
static int32_t v3_nop(cntl_t *, uint16_t ce, uint16_t cycles);
static int32_t v3_sts(cntl_t *, jobkey_t *job, uint16_t mode);
static int32_t v3_readbytes(cntl_t  *,void * addr, dma_t dma_mode);
static int32_t v3_writebytes(cntl_t *,void * addr, dma_t dma_mode);
static int32_t v3_readecc(cntl_t * , void * addr, void * info,dma_t dma_mode);
static int32_t v3_writeecc(cntl_t *, void * addr, void * info,dma_t dma_mode);
static jobkey_t * v3_job_get(cntl_t * cntl_t,uint32_t mykey);
static int32_t v3_job_free(cntl_t * cntl_t, jobkey_t * job);
static uint32_t v3_job_key(cntl_t * cntl_t, jobkey_t * job);
static int32_t v3_job_status(cntl_t * cntl, jobkey_t * job);
static int32_t v3_ecc2dma(ecc_t * orig,dma_desc_t* dma,uint32_t size,uint32_t short_size,uint32_t seed);
static int32_t v3_info2data(void * data,void * info,dma_t dma);//-1,found ecc fail,>=0,ecc counter .
static int32_t v3_data2info(void * info,void * data,dma_t dma);//-1,error found
static int32_t v3_convert_cmd(cntl_t * cntl,cmd_queue_t * in,cmd_queue_t* out);
static int32_t v3_write_cmd(cntl_t * ,cmd_queue_t * cmd);
static int32_t v3_seed(cntl_t *, uint16_t seed);//0 disable
/**
 *
 * @param cntl_t controller
 * @param jobs	in/out parameter ,the finish status job list
 * @param size	input jobs size
 * @return <0 , error ; >=0 , return size of jobs
 */
static int32_t v3_job_lookup(cntl_t * cntl_t, jobkey_t ** jobs,uint32_t size);

typedef struct {
    uint8_t st[2];
    uint8_t seq;
    int8_t done;
    uint32_t key;
}sts_t;
struct v3_priv
{
	uint32_t    delay;
	uint32_t    edo;
	uint32_t    reg_base;
	uint32_t    fifo_mode;
	uint32_t    sts_size;
	uint32_t    temp;
	sts_t*      sts_buf;
	uint32_t    nfc_ce;

	uint32_t 	int_seq;
	uint32_t	tail;
	uint32_t    fifo_mask;
	uint32_t    fifo_size;
	uint32_t    fifo_tail;
	uint32_t *  cmd_fifo;
	
	struct aml_nand_platform * plat;
};
#define v3_lock_sts_buf(priv)
#define v3_unlock_sts_buf(priv)
static struct v3_priv v3_priv =
{ .delay = 90, .edo = 2, .reg_base = P_NAND_CMD,

};
#define DEFINE_CNTL_PRIV(priv,cntl) struct v3_priv * priv=get_priv(cntl)
static inline struct v3_priv *get_priv(cntl_t * cntl)
{
	return cntl->priv;
}

static cntl_t v3_driver =
{
    .name = "aml_v3_nand_driver",
	.feature = 0x3f4,
	.nand_cycle = 0, //cycle time int 0.1ns
	.ecc = ecc_table,
	/** configure and control function **/
	.config = v3_config,
	/** fifo relative functions **/
	.size = v3_size,
	.avail = v3_avail,
	.head = v3_head,
	.tail = v3_tail,

	/** nand command routines*/
	.convert_cmd=v3_convert_cmd,
	.write_cmd=v3_write_cmd,
	.ctrl = v3_ctrl,
	.wait = v3_wait,
	.nop = v3_nop,
	.sts = v3_sts,
	.readbytes = v3_readbytes,
	.writebytes = v3_writebytes,
	.readecc =	v3_readecc,
	.writeecc = v3_writeecc,
	.seed=v3_seed,

	/** util functions for async mode **/
	.job_get = v3_job_get,
	.job_free =v3_job_free,
	.job_lookup = v3_job_lookup,
	.job_key=v3_job_key,
	.job_status=v3_job_status,
	/** ecc dma relative functions **/
	.ecc2dma    =  v3_ecc2dma   ,
    .info2data  =  v3_info2data ,
    .data2info  =  v3_data2info ,
    .priv = &v3_priv
};


#define NFC_CMD_WAIT_EMPTY()       wait_fifo_empty(priv)
static inline void wait_fifo_empty(struct v3_priv * priv)
{
    uint32_t st;
    do{
        st=readl(P_NAND_CFG);
    }while((st&(1<<12))!=0);
    while(NFC_CMDFIFO_SIZE()>0){};
    writel(P_NAND_CMD,NFC_CMD_STANDBY(0));
    writel(P_NAND_CMD,NFC_CMD_STANDBY(0));
    while(NFC_CMDFIFO_SIZE()>0){};
}
static const uint32_t v3_ce[]={CE0,CE1,CE2,CE3,CE_NOT_SEL};
//static const uint32_t v3_rbio[]={IO4,IO5,IO6};
#define NFC_CE(ce)      (v3_ce[ce])
//#define NFC_RBIO(io)    (v3_rbio[io])
static inline uint32_t v3_cmd_fifo_size(struct v3_priv * priv);
#define CNTL_BUF_SIZE	(4*1024)
#define CMD_FIFO_PLUS	64
#if 0
static int32_t
cntl_time_caculate(uint32_t * rea, uint32_t * rhoh, uint32_t edo,
		uint32_t delay, uint32_t clk, uint32_t bus_cycle)
{
	int32_t ret=-1;
	uint32_t tSys, tCycle, tDelay, tRea, tRHOH; //input parameters, all is base on ns
	uint32_t tBegin, tEnd; //base on cycle
	uint32_t begin, end;
	uint32_t fact=100;
	uint32_t ceiling_cycle;
	tSys =  1000 * fact / (clk / 1000000);
	tDelay =  delay * fact;
	tRea = *rea * fact;
	tRHOH = *rhoh * fact;
	tBegin = (tDelay + tRea) * fact / tSys;
	tCycle = tSys * (bus_cycle);
	ceiling_cycle=bus_cycle*fact/2;
//	for(ceiling_cycle=0;ceiling_cycle<bus_cycle*fact/2;ceiling_cycle+=fact);
	tEnd = (tDelay + tRHOH )* fact /tSys + ceiling_cycle;
	for (begin = 0; begin*fact < tBegin; begin++)
		;
	for (end = 0; end*fact < tEnd; end++)
		;
	end--;
	if (((begin >= 3 && begin <= bus_cycle + edo)
			|| (end >= 3 && end <= bus_cycle + edo)) && begin <= end)
	{
		ret=0;

	}
	printf("%s%04dMhz\t%d\t%d\t%02d\t%02d\t%s\t%d\t%d\t\033[0m\n",ret?"\033[41m":"\033[0m",clk/1000000,
			tSys,tBegin,begin,end,ret?"FALSE":"TRUE",tEnd,tCycle);
	/*
	 for (bus_cycle = 1; bus_cycle < 32; bus_cycle++)
	 {
	 tCycle=tSys*bus_cycle;
	 }*/
	return ret;
}

int test_main(void) {
	uint32_t rea=20,rhoh=15;
	int i;
	asm volatile ("wfi");
	for(i=25;i<250;i+=5)
	{
		cntl_time_caculate(&rea,&rhoh,2,9,i*1000000,5);
	}

	return 0;
}
#endif

static int32_t
cntl_time_caculate(uint32_t * rea, uint32_t * rhoh, uint32_t edo,
		uint32_t delay, uint32_t clk)
{
	int32_t ret=-1;
	uint32_t tSys, tCycle, tDelay, tRea, tRHOH; //input parameters, all is base on ns
	uint32_t tBegin, tEnd; //base on cycle
	uint32_t begin, end;
	uint32_t fact=100;
	uint32_t ceiling_cycle;
	uint32_t bus_cycle;
	tSys =  1000 * fact / (clk / 1000000);
	tDelay =  delay * fact/10;
	tRea = *rea * fact;
	tRHOH = *rhoh * fact;



	tBegin = (tDelay + tRea) * fact / tSys;
	for(bus_cycle=3;bus_cycle<32;bus_cycle++){
		tCycle = tSys * (bus_cycle);
		ceiling_cycle=bus_cycle*fact/2;
	//	for(ceiling_cycle=0;ceiling_cycle<bus_cycle*fact/2;ceiling_cycle+=fact);
		tEnd = (tDelay + tRHOH )* fact /tSys + ceiling_cycle;
		for (begin = 0; begin*fact < tBegin; begin++)
			;
		for (end = 0; end*fact < tEnd; end++)
			;
		end--;
		if (((begin >= 3 && begin <= bus_cycle + edo)
				|| (end >= 3 && end <= bus_cycle + edo)) && begin <= end)
		{
			*rea=bus_cycle;
			end=end>bus_cycle+edo?bus_cycle+edo:end;
			*rhoh=(begin+end + 1)>>1;
			return 0;
		}
	}
//	printf("%s%04dMhz\t%d\t%d\t%02d\t%02d\t%s\t%d\t%d\t\033[0m\n",ret?"\033[41m":"\033[0m",clk/1000000,
//			tSys,tBegin,begin,end,ret?"FALSE":"TRUE",tEnd,tCycle);
	/*
	 for (bus_cycle = 1; bus_cycle < 32; bus_cycle++)
	 {
	 tCycle=tSys*bus_cycle;
	 }*/
	return ret;
}
static int32_t v3_config(cntl_t * cntl, uint32_t config, va_list args)
{
	DEFINE_CNTL_PRIV(priv,cntl);
//	va_list args;
	struct aml_nand_platform * plat;
	int32_t ret;
	uint32_t int_temp;
	uint8_t char_temp;
	uint16_t mode;
	void* p_temp;
	ret=0;
//	va_start(args, config);
	switch (config)
	{
	case NAND_CNTL_INIT: // struct aml_nand_platform *
	{
//			test_main();
		plat = va_arg(args,struct aml_nand_platform *);
		if (plat)
			priv->plat = plat;
		priv->delay = plat->delay ? plat->delay : priv->delay;
		priv->reg_base = plat->reg_base ? plat->reg_base : priv->reg_base;
		assert(priv->delay<120);
		assert(priv->edo<10);
		assert(priv->reg_base>0);
		dma_alloc_coherent((CNTL_BUF_SIZE << 1) * sizeof(cmd_t),
				&(priv->cmd_fifo));

		priv->fifo_mask = (CNTL_BUF_SIZE >> 2) - 1;
		priv->sts_buf = (sts_t*) &(priv->cmd_fifo[(CNTL_BUF_SIZE >> 2)
				+ CMD_FIFO_PLUS]);
		priv->temp = (uint32_t) &(priv->cmd_fifo[(CNTL_BUF_SIZE >> 1) - 2]);
		priv->sts_size = (priv->temp - (uint32_t) priv->sts_buf)
				/ sizeof(sts_t);
		nanddebug(
				1,
				"cmd_fifo addr=%p,size=%d,plus=%d ", priv->cmd_fifo, priv->fifo_mask+1, CMD_FIFO_PLUS);
		nanddebug(1, "sts_buf addr=%p,size=%d ", priv->sts_buf, priv->sts_size);
		nanddebug(1, "temp addr=%x\n ", priv->temp);
		writel(0xc00000ea, P_NAND_CFG);//clear init
		writel(priv->cmd_fifo,P_NAND_CADR);
		writel(priv->sts_buf,P_NAND_SADR);

	}
		break;
	case NAND_CNTL_TIME_SET: //uint16_t mode(0:async,1:sync mode,2 toggle),uint16_t t_rea,uint16_t t_rhoh,uint16_t sync_adjust
	{
		mode = va_arg(args,uint32_t) & 3;

		uint32_t bus_cycle, t_rea = (uint32_t) va_arg(args,uint32_t);
		uint32_t bus_time, t_rhoh = (uint32_t) va_arg(args,uint32_t);
		uint16_t sync_adjust = 0;
		assert(mode<3);
		if (mode)
			sync_adjust = (uint16_t) va_arg(args,uint32_t) & 1;

		/** Onfi 2.2 Timing Mode 0 **/
		t_rea = max(t_rea,priv->plat->t_rea) ?
				max(t_rea,priv->plat->t_rea) : 40;
		t_rhoh =
				max(t_rhoh,priv->plat->t_rhoh) ?
						max(t_rhoh,priv->plat->t_rhoh) : 0;

		nanddebug(
				1,
				"input parameters t_rea=%dns,t_rhoh=%dns,delay=%d*0.1ns edo=%d clk_src=%dMhz",
				t_rea, t_rhoh, priv->delay, priv->edo, clk_get_rate(priv->plat->clk_src));
		/**
		 * @todo implement it .
		 * assert(v3_time_caculate(&t_rea,&t_rhoh,priv->edo,priv->delay,clk_get_rate(priv->plat->clk_src)));
		 */
		assert(
				(cntl_time_caculate(&t_rea,&t_rhoh,priv->edo,priv->delay,clk_get_rate(priv->plat->clk_src))>=0));
		NFC_CMD_WAIT_EMPTY();
		bus_time = t_rhoh ? t_rhoh : 7;
		bus_cycle = t_rea ? t_rea : 10;
		nanddebug(
				1,
				"bus_time=%dcycle,bus_cycle=%dcycle mode=%d sync_adjust=%d clksrc=%d ", bus_time, bus_cycle, mode, sync_adjust, clk_get_rate(priv->plat->clk_src));

		clrsetbits_le32(
				P_NAND_CFG,
				0xfff|(1<<16),
				(bus_cycle&0x1f)|((bus_time&0x1f)<<5)| (mode<<10)|(sync_adjust<<16));
		nanddebug(1, "P_NAND_CFG=%x\n", readl(P_NAND_CFG));
	}
		break;
	case NAND_CNTL_MODE: //uint16_t start,(bit0 cmd fifo: 1=enable 0=disable , bit1 interrupt : 0=disable,1=enable),
	{
		mode = ((uint16_t) va_arg(args,uint32_t)) & 0xf;
		uint16_t xor = mode ^ priv->fifo_mode;
		if(xor==0)
			break;
		if (xor != 0)
		{
			NFC_CMD_WAIT_EMPTY();
			priv->fifo_mode = mode;
			if (xor & 0xc)
			{
				clrsetbits_le32(P_NAND_CFG, 3<<20, (mode&0xc)<<18);
			}
			if (xor & 0x3)
			{
				if(mode&1)
					clrsetbits_le32(P_NAND_CFG, 3<<12, (mode&0x3)<<12);
				else
					clrbits_le32(P_NAND_CFG, 3<<12);
			}
		}
	}
		break;
	case NAND_CNTL_FIFO_RESET: //uint16_t mode : 1, force reset ; 0, reset possible
		mode = ((uint16_t) va_arg(args,uint32_t)) & 3;
		if (mode)
			NFC_CMD_WAIT_EMPTY();
		if (v3_cmd_fifo_size(priv))
			break;
		writel((uint32_t)(priv->cmd_fifo), P_NAND_CADR);
		break;
	case NAND_CNTL_ERROR:
		if (NFC_CHECEK_RB_TIMEOUT())
		{
			uint32_t * pret = va_arg(args,uint32_t*);
			*pret = (readl(P_NAND_CMD) >> 5) & 0x1f;
			return NAND_CNTL_ERROR_TIMEOUT;
		}
		break;

	case NAND_CNTL_GO:
		writel(1<<30, P_NAND_CMD);
		break;
	case NAND_CNTL_RESET:
		writel(1<<31, P_NAND_CMD);
		break;

	default:
		nanddebug(1, "Not Implement");
		assert(0);
		break;

	}
//	va_end(args);
	return 0;
}
//#define nfc_dmb() dmb()
#define nfc_dmb()
#define STS_2_CMD_SIZE 	5

#define ANCHOR_POS_E		(priv->fifo_mask+1-(NFC_CMDFIFO_MAX-1))
#define ANCHOR_POS_S 		(ANCHOR_POS_E - STS_2_CMD_SIZE )


static inline uint32_t v3_cmd_fifo_head(struct v3_priv * priv)
{
    uint32_t head=readl(P_NAND_CADR);
    uint32_t fifo_size=(priv->fifo_mask+1);
	uint32_t fifo=(uint32_t)priv->cmd_fifo;
	head-=fifo;
	head>>=2;
	if(head>fifo_size+CMD_FIFO_PLUS)
	    return 0;
	return head;
}
static inline uint32_t  v3_cmd_fifo_tail(struct v3_priv * priv)
{
	return (priv->fifo_tail )&(priv->fifo_mask);
}
static inline uint32_t v3_cmd_fifo_size(struct v3_priv * priv)
{
	uint32_t tail=v3_cmd_fifo_tail(priv);
	uint32_t head=v3_cmd_fifo_head(priv);
	uint32_t tmp,tmp1;
	uint32_t i;
	uint32_t *cmd_fifo=priv->cmd_fifo;
	uint32_t fifo_size=(priv->fifo_mask+1);

	if(head>=fifo_size&&cmd_fifo[head]==0)
		head=0;

	if(head>tail)
	{
		tmp=head>=fifo_size?head:fifo_size;
		for(i=0;cmd_fifo[tmp+i]!=0;i++);
		tmp1=head>=fifo_size?0:head;
		return ((tail-tmp1)&priv->fifo_mask)+i;
	}
	return tail-head;
}
static inline uint32_t v3_cmd_fifo_avail_plus(struct v3_priv * priv,uint32_t plus)
{
	uint32_t tail=v3_cmd_fifo_tail(priv);
	uint32_t head=v3_cmd_fifo_head(priv);
	uint32_t i;
	uint32_t fifo_size=(priv->fifo_mask+1);
	if(head>tail)
	{
		i=(head-tail-1);
		return i;
	}
	if(head==tail)
	{
		return fifo_size+plus;
	}

	return fifo_size+plus-tail+head-1;
}
static inline uint32_t v3_cmd_fifo_avail(struct v3_priv * priv)
{
	return v3_cmd_fifo_avail_plus(priv,0);
}

#define nfc_mb(a,b)
#if 0
static inline void v3_cmd_fifo_reset(struct v3_priv * priv)
{
    uint32_t head=readl(P_NAND_CADR);
	uint32_t mask=(priv->fifo_mask<<2)|3;
	uint32_t fifo=(uint32_t)priv->cmd_fifo;
	if(!(head<fifo||head>fifo+mask))
		return;
	uint32_t * phead=(uint32_t *)head;
	if(head>fifo+mask&&*phead==0)
		writel((uint32_t)(priv->cmd_fifo),P_NAND_CADR);
}
#endif
#define cmd(a)  cmd_##a
#define ret(a)  ret_##a
#define EXTEND(name,a)   name(a)
#define TMP_VAR(name) EXTEND(name,__LINE__)
#define V3_FIFO_WRITE(x...) {   uint32_t TMP_VAR(cmd)[]={x};                            \
                                int32_t TMP_VAR(ret);                                   \
                                if(( TMP_VAR(ret)=v3_fifo_write(priv,TMP_VAR(cmd),             \
                                    sizeof(TMP_VAR(cmd))/sizeof(TMP_VAR(cmd)[0])))<0)   \
                                    return TMP_VAR(ret);}
static inline int32_t v3_check_fifo_interrupt(uint32_t * cmd_q,uint32_t size,uint32_t modify)
{
	//todo reconsider it
	uint32_t cmd;
	int i;
	for(i=0;i<size;i++)
	{
		cmd=cmd_q[i];
		if(cmd==0)
			return -1;
		switch(cmd&(0xf<<18))
		{
		case (4<<18):
		case (5<<18):
		case (6<<18):
		case (7<<18):
			if(cmd&(0xf<<14))
				return i;
			if(modify)
			{
				cmd_q[i]=cmd|((cmd&(0xf<<10))<<4);
				return i;
			}
			break;
		case (9<<18):
			if(cmd==NFC_CMD_STS(2))
				return i;
			if(modify)
			{
				cmd_q[i]=NFC_CMD_STS(2);
				return i;
			}

			break;
		default:
			break;
		}
	}
	return -1;
}
static uint32_t v3_find_ce(uint32_t * cmd , uint32_t tag,uint32_t old)
{
	uint32_t ce=old;
	while(*cmd)
	{
		if(((*cmd)&(0xf<<18))==0)
		{

			ce=(*cmd)&(0xf<<10);
			if(tag==0)
				return ce;
		}

		cmd++;
	}
	return ce;
}
static char * v3_cmd_printstr(cmd_t cmd)
{
	static char  cmd_str[256];
	strcpy(cmd_str,"unkown command");
	uint32_t ce,interrupt;
	switch((cmd>>20))
	{
	case 0:
		ce=(cmd&(0xf<<10));
		if(ce==0xf<<10)
		{
			sprintf(cmd_str,"standby , time=%04d",cmd&0x3ff);
			break;
		}
		switch((cmd>>14)&0xf)
		{
		case 0xc:
			sprintf(cmd_str, "idle , cemask=%x,time=%04d", (cmd >> 10) & 0xf,
					cmd & 0x3ff);
			break;
		case 0x8:
			sprintf(cmd_str, "DRD , cemask=%x,time=%04d", (cmd >> 10) & 0xf,
					cmd & 0x3ff);
			break;
		case 0x5:
			sprintf(cmd_str, "CLE %02x , cemask=%x", cmd & 0xff,
					(cmd >> 10) & 0xf);
			break;
		case 0x6:
			sprintf(cmd_str, "ALE %02x , cemask=%x", cmd & 0xff,
					(cmd >> 10) & 0xf);
			break;
		case 0x4:
			sprintf(cmd_str, "DWR %02x , cemask=%x", cmd & 0xff,
					ce>>10);
			break;

		}
		break;
	case 1:
		ce = (cmd >> 10) & (0xf);
		interrupt = (cmd >> 14) & (0xf);
		sprintf(cmd_str, "%s id=%02x, cemask=%x,interrupt mask=%x,time=%d",
				cmd & (1 << 18) ? "RBIO" : "RB", (cmd >> 5) & 0x1f, ce,
				interrupt, 1 << (cmd & 0x1f));

		break;
	case 2:
		if (((cmd >> 17) & 7) == 3)
		{
			if ((cmd & (0x1ffff)) == 1 || (cmd & (0x1ffff)) == 2)
				sprintf(cmd_str, "STS %s interrupt",
						(cmd & (0x1ffff)) == 1 ? "without" : "with");

		}
		else if (((cmd >> 17) & 2) == 0)
		{
			sprintf(cmd_str, "%s dma ,seed %s,ecc=%s",
					cmd & (1 << 17) ? "Read " : "Write",
					cmd & (1 << 19) ? "Enable" : "Disable",
					ecc_table[(cmd >> 14) & 7].name);
			if (((cmd >> 14) & 7) == 0)
			{
				sprintf(cmd_str, "%s ,size=%d", cmd_str, cmd & 0x3fff);
			}
			else
			{
				uint32_t short_mode = cmd & (1 << 13);
				uint32_t pages = cmd & 0x3f;
				uint32_t page_size =
						short_mode ?
								(cmd & (0x7f << 6)) >> (6 - 3) :
								ecc_table[(cmd >> 14) & 7].data << 3;
				sprintf(cmd_str, "%s,%spage_size=%d,pages=%d,size=%d", cmd_str,
						short_mode ? "short Mode," : "", page_size, pages,
						page_size * pages);
			}

		}
		break;
	case 3:
		if(cmd&1<<19)
		{
			if((cmd&0x7ffff)<(1<<15))
			{
				sprintf(cmd_str,"SEED,seed=%04x",cmd&0x3fff);
			}
		}else{
			if((cmd&(3<<17))<(3<<17))
			{
				sprintf(
						cmd_str,
						"%s %s addr,val=%04x",
						((cmd >> 17) & 3) == 0 ? "Data" :
						((cmd >> 17) & 3) == 1 ? "Info" : "Sts",
						(cmd & (1 << 16)) ? "High" : "Low", cmd
						& 0xffff);

			}

		}
		break;
	}
	return  cmd_str;
}
static void cmd_print(uint32_t priv,uint16_t size,void * data)
{
	uint16_t i;
	cmd_t * cmd=(cmd_t*)data;
	printf("\t\bCurrent Hardware FIFO length %d",priv);
	for(i=0;i<size/sizeof(cmd_t);i++)
	{
		printf("\n\t%06x\t%s",cmd[i],v3_cmd_printstr(cmd[i]));
	}
}
#define HW_FIFO_LOG(size,data) debug_log(cmd_print,NFC_CMDFIFO_SIZE(),size,data)
static int32_t v3_fifo_write(struct v3_priv *priv, uint32_t cmd_q[],uint32_t size)
{

    uint32_t head,tail=0,sizefifo,avail,hw_avail;
    uint32_t begin,fifo_size=0;
    uint32_t anchor_s,anchor_e;
    uint32_t *cmd_fifo=priv->cmd_fifo;
    uint32_t cmd_size;
    uint32_t * cmd;
    uint32_t * write_cmd[4]={NULL,NULL,NULL,NULL};
    uint32_t write_size[4]={0,0,0,0};
    int32_t int_tag;
    uint32_t int_pos;
    int i,j;
    hw_avail=NFC_CMDFIFO_AVAIL();
    if((priv->fifo_mode&NAND_CNTL_FIFO_MASK)==NAND_CNTL_FIFO_HW_NO_WAIT)
    {
    	if(hw_avail<size)//mode does not match
    	{
    		nanddebug(1,"Hardware fifo is full");
    		return -2;//mode does not match
    	}
    	write_cmd[0]=cmd_q;
    	write_size[0]=size;
    	goto write_fifo_raw;

    }
    if((priv->fifo_mode&NAND_CNTL_FIFO_MASK)==NAND_CNTL_FIFO_HW)
    {
    	i=0;
    	while(i<size)
    	{
    		while((hw_avail=NFC_CMDFIFO_AVAIL())==0)
    			__udelay(100);
    		for(j=0;j<((size-i)>hw_avail?hw_avail:size-i);j++)
    		{
    			writel(cmd_q[i+j],P_NAND_CMD);
    		}
    		HW_FIFO_LOG(j*sizeof(cmd_t),&cmd_q[i]);
    		i+=j;
    	}
    	return 0;
    }
    sizefifo=v3_cmd_fifo_size(priv);//if size == 0 , this function should reset fifo
    avail=v3_cmd_fifo_avail_plus(priv,CMD_FIFO_PLUS);

    if(sizefifo==0)
    {
    	if((avail+hw_avail)<size)//no enough space
    		return -1;//no enough space now
    	priv->tail=0;
    	writel((uint32_t)(priv->cmd_fifo),P_NAND_CADR);
    	if(hw_avail>=size)
    	{
    		write_cmd[0]=cmd_q;
			write_size[0]=size;
			goto write_fifo_raw;
    	}else{
    		write_cmd[0]=cmd_q;
			write_size[0]=hw_avail;
			cmd=&cmd_q[hw_avail];
			cmd_size=size-hw_avail;
    	}
    }
    else if(avail<size)
    {
    	return -1;//no enough space now
    }else{
    	cmd=cmd_q;
    	cmd_size=size;
    }
    fifo_size=priv->fifo_mask +1;
    head=v3_cmd_fifo_head(priv);
    tail=v3_cmd_fifo_tail(priv);
    anchor_s=ANCHOR_POS_E;
    anchor_e=fifo_size+CMD_FIFO_PLUS;

    if(tail>anchor_s)
    {
    	int_tag=v3_check_fifo_interrupt(&cmd_fifo[anchor_s],tail-anchor_s,0);
    	begin=0;
    }else{
    	if(tail+cmd_size<anchor_s)
    		int_tag=0;
    	else{
    		begin=anchor_s-tail;
    		int_tag=-1;
    	}
    }
    if(int_tag<0)
    {
    	int_tag=v3_check_fifo_interrupt(&cmd[begin],cmd_size-begin,1);
    }
    if(int_tag>=0)
    {
    	write_cmd[1]=cmd;
    	write_size[1]=cmd_size;
    	goto write_fifo_raw;
    }
    if(avail<STS_2_CMD_SIZE||avail<cmd_size+STS_2_CMD_SIZE)
    	return -1;//no enough space .
#define INSERT_INTERRUPT(ce)    {NFC_CMD_IDLE(CE_NOT_SEL,0),\
		NFC_CMD_ASL(priv->temp),	\
    	NFC_CMD_ASH(priv->temp),	\
    	NFC_CMD_STS(2),				\
    	NFC_CMD_IDLE(ce,0)			\
		}
    uint32_t old_ce=v3_find_ce(cmd,0,priv->nfc_ce);
    uint32_t new_ce=0;
//    =v3_find_ce(cmd,1,priv->nfc_ce);
    new_ce=v3_find_ce(cmd,1,priv->nfc_ce);
    if(cmd_size>NFC_CMDFIFO_MAX-2 || write_size[0])
    {
    	write_cmd[1]=cmd;
    	write_size[1]=cmd_size;

    	uint32_t test[]=INSERT_INTERRUPT(new_ce);
    	write_cmd[2]=&test[0];
    	write_size[2]=5;

    	int_pos=2;
    }else{

    	uint32_t test[]=INSERT_INTERRUPT(old_ce);
    	write_cmd[1]=&test[0];
    	write_size[1]=5;
    	write_cmd[2]=cmd;
    	write_size[2]=cmd_size;
    }



write_fifo_raw:
	if(write_cmd[0]&&write_size[0])
	{
		for(i=0;i<write_size[0];i++,priv->tail++)
		{
			//nanddebug(NAND_V3_DETAILS,"Write fifo:%x fifo size=%d ,%s ",write_cmd[0][i],NFC_CMDFIFO_SIZE(),v3_cmd_printstr(write_cmd[0][i]));
			writel(write_cmd[0][i],P_NAND_CMD);
		}

		HW_FIFO_LOG(write_size[0]*sizeof(cmd_t),write_cmd[0]);
	}
	uint32_t keep=0,keep_pos=tail;

	for(i=1;i<sizeof(write_size)/sizeof(write_size[0]);i++)
	{
		if(!(write_cmd[i]&&write_size[i]))
			continue;
/*
		if(16<=CONFIG_ENABLE_NAND_DEBUG)
		{
			int j;
			for(j=0;j<write_size[i];j++)
			{
				nanddebug(16,"%s",v3_cmd_printstr(write_cmd[i][j]));
			}
		}
*/
		HW_FIFO_LOG(write_size[i]*sizeof(cmd_t),write_cmd[i]);
		if(keep==0)
		{
			keep=write_cmd[i][0];
			write_cmd[i][0]=0;
		}
		memcpy(&cmd_fifo[tail],write_cmd[i],write_size[i]*sizeof(write_cmd[i][0]));
		priv->tail+=write_size[i];
		tail+=write_size[i];
	}
	if(keep)cmd_fifo[keep_pos]=keep;
	cmd_fifo[tail]=0;

	if(tail>fifo_size)
		priv->fifo_tail=0;
	else
		priv->fifo_tail=tail;
	sizefifo=v3_cmd_fifo_size(priv);//if size == 0 , this function should reset fifo
	priv->nfc_ce=new_ce;
	nfc_dmb();
	if((priv->fifo_mode&1)&&sizefifo)
		clrsetbits_le32(P_NAND_CFG,3<<12,(priv->fifo_mode&3)<<12);//start fifo immediatly
	return 0;
}
/***
 *
 * @param cntl
 * @param config
 * @return
 */

static uint32_t v3_size(cntl_t * cntl)
{
	DEFINE_CNTL_PRIV(priv, cntl);
	uint32_t size,hw_size;
	hw_size=NFC_CMDFIFO_SIZE();
	if((priv->fifo_mode&1)==0)//NO Fifo Buffer return
	{
		return hw_size;
	}
	size=v3_cmd_fifo_size(priv);//if size == 0 , this function should reset fifo
	return size+hw_size;
}
static uint32_t v3_avail(cntl_t * cntl)
{
	DEFINE_CNTL_PRIV(priv, cntl);
	uint32_t tail,size,avail,hw_avail;
	hw_avail=NFC_CMDFIFO_AVAIL();
	if((priv->fifo_mode&1)==0)//NO Fifo Buffer return
	{
		return hw_avail;
	}
	avail=v3_cmd_fifo_avail(priv);//if size == 0 , this function should reset fifo
	size=v3_cmd_fifo_size(priv);//if size == 0 , this function should reset fifo
	if(size==0)
		return hw_avail+priv->fifo_mask+1;
	tail=v3_cmd_fifo_tail(priv);
	if(tail>ANCHOR_POS_S)
		return avail>STS_2_CMD_SIZE?avail-STS_2_CMD_SIZE:0;
	return avail;
}
static uint32_t v3_tail(cntl_t * cntl)
{
	DEFINE_CNTL_PRIV(priv, cntl);
	return priv->tail;
}
static uint32_t v3_head(cntl_t *cntl)
{
	return cntl->tail(cntl)-cntl->size(cntl);
}

static inline int32_t v3_check_and_insert_interrupt(struct v3_priv * priv,uint32_t nfc_ce)
{
    uint32_t tail,leave,avail;
    if(priv->nfc_ce==nfc_ce)
        return 0;
    
    if((priv->fifo_mode&2)==0 ||//interrupt disable
        NFC_CMDFIFO_AVAIL())    //write to hardware directorly 
    {
        priv->nfc_ce=nfc_ce;
        return 0;
    }
    
    
    tail=v3_cmd_fifo_tail(priv);
    if(tail<priv->fifo_mask-31)//no need insert interrupt 
    {
        priv->nfc_ce=nfc_ce;
        return 0;
    }
    avail=v3_cmd_fifo_avail(priv);
    leave=priv->fifo_mask+1-tail;
    if(avail>3&&leave>3)
    {
        V3_FIFO_WRITE(
            NFC_CMD_IDLE(CE_NOT_SEL,0),
            NFC_CMD_ASL(priv->temp),
            NFC_CMD_ASH(priv->temp),
            NFC_CMD_STS(2));
        priv->nfc_ce=nfc_ce;
        return 0;
    }
    if(leave<4&&avail>4-leave)
    {
    	priv->cmd_fifo[tail]  =NFC_CMD_IDLE(CE_NOT_SEL,0);
    	priv->cmd_fifo[tail+1]=NFC_CMD_ASL(priv->temp),
        priv->cmd_fifo[tail+2]=NFC_CMD_ASH(priv->temp),
        priv->cmd_fifo[tail+3]=NFC_CMD_STS(2);
    	priv->cmd_fifo[tail+4]=0;
    	nfc_mb(&priv->cmd_fifo[fifo_tail],5*sizeof(priv->cmd_fifo[0]));
    	priv->fifo_tail+=leave;
    	priv->cmd_fifo[0]=0;
    	nfc_mb(&priv->cmd_fifo[0],sizeof(priv->cmd_fifo[0]));
    	priv->nfc_ce=nfc_ce;
    	return 0;
    }
    return -1;
} 
static int32_t v3_seed(cntl_t * cntl, uint16_t seed)
{
		DEFINE_CNTL_PRIV(priv,cntl);
		V3_FIFO_WRITE( NFC_CMD_SEED(seed));
		return 0;
}
static int32_t v3_convert_cmd(cntl_t * cntl,cmd_queue_t * inq, cmd_queue_t* outq)
{
#define CMD_WRITE_SIGNLE(cmd) cmd_queue_write(outq, 1 , cmd)

	uint32_t ce, mode, para, op;
	cmd_t cmd, cmd1, cmd2, wcmd;
	DEFINE_CNTL_PRIV(priv,cntl);
	outq->cur = 0;
	while ((cmd = cmd_queue_get_next(inq)))
	{
		op = (cmd >> 28) & 0xf;
		ce = NFC_CE((cmd>>24)&0xf);

		switch (op)
		{
		case 1: /*cle*/
			CMD_WRITE_SIGNLE(NFC_CMD_CLE(ce,cmd&0xff));
			break;
		case 2: /*ale*/
			CMD_WRITE_SIGNLE(NFC_CMD_ALE(ce,cmd&0xff));
			break;
		case 8: /*nop*/
			CMD_WRITE_SIGNLE(NFC_CMD_IDLE(ce,cmd&0xffff));
			break;
		case 4:/*seed*/
			CMD_WRITE_SIGNLE(NFC_CMD_SEED(cmd));
			break;

		case 3: //wait
			ce = ((cmd>>24)&0xf);
			mode = (cmd >> 16) & 0xff;
			para = cmd & 0xffff;
			wcmd = NAND_RB_IS_RBIO(mode) ?
					NFC_CMD_RBIO_ID(NFC_CE(mode&0xf),ce, para) :
					NFC_CMD_RB_ID(NFC_CE(mode&0xf),ce, para);
			wcmd |= NAND_RB_IS_INT(mode) ?
					(NFC_CE(mode&0xf) ^ CE_NOT_SEL) << 4 : 0;
			cmd_queue_write(outq, 2, NFC_CMD_IDLE(NFC_CE(ce),0), wcmd);
			break;
		case 5: //STS
			mode = (cmd >> 24) & 3;
			cmd1 = cmd_queue_get_next(inq);
			cmd_queue_write(outq, 3, NFC_CMD_ASL(cmd1), NFC_CMD_ASH(cmd1),
					NFC_CMD_STS(mode));
			break;
		case 6: //Read
			cmd1 = cmd_queue_get_next(inq);
			cmd2 = cmd_queue_get_next(inq);
			cmd2=cmd2?cmd2:priv->temp;
			cmd_queue_write(outq, 5,
			NFC_CMD_ADL(cmd1), NFC_CMD_ADH(cmd1), NFC_CMD_AIL(cmd2),
					NFC_CMD_AIH(cmd2), NFC_CMD_READ(cmd));

			break;
		case 7://write
			cmd1 = cmd_queue_get_next(inq);
			cmd2 = cmd_queue_get_next(inq);
			cmd2=cmd2?cmd2:priv->temp;
			cmd_queue_write(outq, 5,
			NFC_CMD_ADL(cmd1), NFC_CMD_ADH(cmd1), NFC_CMD_AIL(cmd2),
					NFC_CMD_AIH(cmd2), NFC_CMD_WRITE(cmd));
			break;
		}
	}
	return outq->size;
}
static int32_t v3_write_cmd(cntl_t * cntl ,cmd_queue_t * cmdq)
{
	DEFINE_CNTL_PRIV(priv,cntl);
	cmd_t * p=cmdq->queue;
	return v3_fifo_write(priv,p,cmdq->size);
}

static int32_t v3_ctrl(cntl_t *cntl, uint16_t ce, uint16_t ctrl)
{
    DEFINE_CNTL_PRIV(priv,cntl);
	if (IS_CLE(ctrl)){
		V3_FIFO_WRITE(NFC_CMD_CLE(NFC_CE(ce),ctrl));
		return 0;
	}
	V3_FIFO_WRITE(NFC_CMD_ALE(NFC_CE(ce),ctrl));
	return 0;
}
static int32_t v3_wait(cntl_t * cntl, uint16_t ce,uint8_t mode, uint8_t cycle_log2)
{

    DEFINE_CNTL_PRIV(priv,cntl);
    uint32_t new_mode=NFC_CE(mode&0xf)|(NAND_RB_IS_INT(mode)?(0xf<<14):0);

	if (NAND_RB_IS_RBIO(mode))
	{
		V3_FIFO_WRITE(NFC_CMD_IDLE(NFC_CE(ce),0),NFC_CMD_RBIO_ID(new_mode,ce, cycle_log2));
        return 0;
	}
	V3_FIFO_WRITE(NFC_CMD_IDLE(NFC_CE(ce),0),NFC_CMD_RB_ID(new_mode,ce,cycle_log2));
	return 0;
}
static int32_t v3_nop(cntl_t * cntl, uint16_t ce, uint16_t cycles)
{

    DEFINE_CNTL_PRIV(priv,cntl);
	V3_FIFO_WRITE( NFC_CMD_IDLE(NFC_CE(ce),cycles));
	return 0;
}



static int32_t v3_sts(cntl_t * cntl, jobkey_t *job, uint16_t mode)
{

    DEFINE_CNTL_PRIV(priv, cntl);

    uint32_t sts_addr=(uint32_t)job;
    if(sts_addr==0)
        return -1;
    V3_FIFO_WRITE(
        NFC_CMD_ASL(sts_addr),
        NFC_CMD_ASH(sts_addr),
        NFC_CMD_STS(mode));
    return 0;
}
static int32_t v3_ecc2dma(ecc_t * orig,dma_desc_t* dma_desc,uint32_t size,uint32_t short_size,uint32_t seed_en)
{
    uint32_t remainder,max,pages,short_dma;
    if(orig==NULL)
        orig=&ecc_table[0];//BCH off
    if(orig->bits==0 )//BCH off
    {
        //ignore short_size;
        if(size>orig->max)
            return orig->max - size;
        dma_desc->dma=(seed_en?(1<<19):0)|size;
        dma_desc->pages=1;
        dma_desc->page_size=size;
        dma_desc->info=0;
        dma_desc->io_size=(size);
        dma_desc->parity=0;
        return 0;
    }
    if((short_size&7)||(size&7))
        return -1;
    if(short_size>(63<<3))
        return -2;
    if(short_size==0&&size==0)
        return -3;
    if(short_size!=0&&size==0)
        return -4;
    
    max=short_size?0x3f*short_size:orig->max;
    if(size>max)
        return max - size ;
    if(short_size)
    {
        short_dma=(1<<13)|(short_size<<2);
    }else{
        short_size=orig->data<<3;
        short_dma=0;
    }
    remainder=size%short_size;
    pages=size/short_size;
    if(remainder)
        return -5;
    dma_desc->dma=(seed_en?(1<<19):0)|short_dma|((orig->mode&7)<<14)|pages;
    dma_desc->pages=pages;
    dma_desc->page_size=short_size;
    dma_desc->info=8;
    dma_desc->io_size=(short_size+orig->info+orig->parity);
    dma_desc->parity=orig->parity;
    return 0;
}
typedef struct __info_s{
    uint8_t info[2];
    uint8_t zero;
    uint8_t err:6;
    uint8_t ecc:1;
    uint8_t done:1;
    uint32_t data_addr;
}info_t;
static int32_t v3_info2data(void * data,void * inf,dma_t dma)//-1,found ecc fail,>=0,ecc counter .
{
    uint32_t pages=dma&0x3f;
    uint32_t bits;
    info_t *info;
    uint8_t *dat;
    int ret,i;
    if((dma&(7<<14))==0)
        return -1;//BCH off , no need
    bits=ecc_table[(dma&(7<<14))].bits;
    for(ret=0,i=0,dat=data,info=inf;i<pages;i++,dat+=2)
    {
        if(info[i].ecc)
        {
            if(info[i].err==0x3f)
                return -2;//uncorrectable 
            ret=max(ret,info[i].err);
            dat[0]=info[i].info[0];
            dat[1]=info[i].info[1];
        }else{
            BUG();
        }
        
    }
    return ret;
}
/**
 * @param inf
 * @param data
 * @param dma
 * @return
 */
static int32_t v3_data2info(void * inf,void * data,dma_t dma)
{
    uint32_t pages=dma&0x3f;
    info_t *info;
    uint8_t *dat;
    int ret,i;
    if((dma&(7<<14))==0)
        return -1;//BCH off , no need
    for(ret=0,i=0,dat=data,info=inf;i<pages;i++,dat+=2)
    {
        info[i].info[0]=dat[0];
        info[i].info[1]=dat[1];
        info[i].data_addr=0;
        info[i].done=0;
    }
    return ret;

}
#define dma_set_addr(data,info) NFC_CMD_ADL(data),NFC_CMD_ADH(data),NFC_CMD_AIL(info),NFC_CMD_AIH(info)
static int32_t v3_readbytes(cntl_t  * cntl,void * addr, dma_t dma_mode)
{
    dma_t dma;
    DEFINE_CNTL_PRIV(priv, cntl);
    assert(dma_mode>0);
    assert((dma_mode&(7<<14))==0);
    assert((dma_mode&((1<<14)-1))!=0);
    dma=dma_mode&((1<<19)|((1<<14)-1));

    
    V3_FIFO_WRITE(dma_set_addr((uint32_t)addr,priv->temp),NFC_CMD_READ(dma));
    return 0;
}
static int32_t v3_writebytes(cntl_t * cntl,void * addr, dma_t dma_mode)
{
    dma_t dma;
    DEFINE_CNTL_PRIV(priv, cntl);
    assert(dma_mode>0);
    assert((dma_mode&(7<<14))==0);
    assert((dma_mode&((1<<14)-1))!=0);
    dma=dma_mode&((1<<19)|((1<<14)-1));
    V3_FIFO_WRITE(dma_set_addr((uint32_t)addr,priv->temp),NFC_CMD_WRITE(dma));
    return 0;
}
static int32_t v3_readecc(cntl_t * cntl, void * addr, void * info,dma_t dma_mode)
{
    dma_t dma;
    DEFINE_CNTL_PRIV(priv, cntl);
    assert(dma_mode>0);
    assert((dma_mode&(7<<14))!=0);
    assert((dma_mode&((1<<17)-1))!=0);
    dma=dma_mode&((1<<19)|((1<<17)-1));
    V3_FIFO_WRITE(dma_set_addr((uint32_t)addr,(uint32_t)info),NFC_CMD_READ(dma));
    return 0;
}
static int32_t v3_writeecc(cntl_t * cntl, void * addr, void * info,dma_t dma_mode)
{
    dma_t dma;
    DEFINE_CNTL_PRIV(priv, cntl);
    assert(dma_mode>0);
    assert((dma_mode&(7<<14))!=0);
    assert((dma_mode&((1<<17)-1))!=0);
    dma=dma_mode&((1<<19)|((1<<17)-1));
    V3_FIFO_WRITE(dma_set_addr((uint32_t)addr,(uint32_t)info),NFC_CMD_READ(dma));
    return 0;
}
/**
 *
 * Jobkey relative functions
 *
 *
 */
static jobkey_t * v3_job_get(cntl_t * cntl,uint32_t mykey)
{
	DEFINE_CNTL_PRIV(priv, cntl);
	int i;
	assert(mykey!=0);
	v3_lock_sts_buf();
	for(i=0;i<priv->sts_size;i++)
	{
		if(priv->sts_buf[i].key==0)
		{
			priv->sts_buf[i].key=mykey;
			priv->sts_buf[i].done=0x0;
			v3_unlock_sts_buf();
			return (jobkey_t*)(priv->sts_buf+i);
		}
	}
	v3_unlock_sts_buf();
	return NULL;
}
static int32_t v3_job_free(cntl_t * cntl, jobkey_t * job)
{
	sts_t * p=(sts_t *)job;
	v3_lock_sts_buf();
	p->key=0;
	v3_unlock_sts_buf();
	return 0;
}

/**
 *
 * @param cntl_t controller
 * @param jobs	in/out parameter ,the finish status job list
 * @param size	input jobs size
 * @return <0 , error ; >=0 , return size of jobs
 */
static int32_t v3_job_lookup(cntl_t * cntl, jobkey_t ** jobs,uint32_t size)//
{
	DEFINE_CNTL_PRIV(priv, cntl);
	int32_t i;
	int32_t ret;
	assert(jobs!=0);

	for(i=0,ret=0;i<priv->sts_size&&ret<size;i++)
	{
		if(priv->sts_buf[i].key==0)
			continue;
		if(priv->sts_buf[i].done==0)
			continue;
		jobs[ret++]=(jobkey_t*)&(priv->sts_buf[i]);
	}
	return ret;
}
static uint32_t v3_job_key(cntl_t * cntl, jobkey_t * job)
{
	sts_t * p=(sts_t*)job;
	return p->key;
}
static int32_t v3_job_status(cntl_t * cntl, jobkey_t * job)
{
	volatile sts_t * p=(volatile sts_t*)job;
	nfc_dmb();
	if(p->done<0)
		return p->st[0];
	return -1;
}

cntl_t * get_v3(void)
{
	clrbits_le32(P_PAD_PULL_UP_REG3,(0xff<<0) | (1<<16));
	return (cntl_t*)&v3_driver;
}

