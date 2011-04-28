#ifndef __AMLOGIC_NAND_CNTL_H_
#define __AMLOGIC_NAND_CNTL_H_

#include <stdarg.h>
#include <linux/types.h>
#include "platform.h"
#define MAX_CMD_SIZE 32
//typedef unsigned uint32_t;
typedef uint64_t cntl_feature_t;
typedef struct __cntl_info_s cntl_t;
typedef struct __ecc_info_s ecc_t;
struct __ecc_info_s {
    char *      name;
    //this parameter is basic ecc desription section
    uint8_t     mode:4;//0~16
    uint8_t     info:4;//0,1,2
    uint8_t     bits;
    uint8_t     data;//512/8,1024/8,0
    uint8_t     parity;
    uint32_t    max;
};
#define CNTL_CMD_END()					0
#define CNTL_CMD_NOP(ce,cycle)			((8<<28)|(ce<<24)|(cycle))
#define CNTL_CMD_CLE(ce,cle)			((1<<28)|(ce<<24)|(cle&0xff))
#define CNTL_CMD_ALE(ce,ale)			((2<<28)|(ce<<24)|(ale&0xff))
#define CNTL_CMD_WAIT(ce,mode,cycle)	((3<<28)|(ce<<24)|((mode&0xff)<<16)|cycle)
#define CNTL_CMD_SEED(seed)				((4<<28)|(seed))
#define CNTL_CMD_STATUS(mode,addr)		((5<<28)|((mode&3)<<24)),((cmd_t)(addr))
#define CNTL_CMD_READ(mode,data,info)	((6<<28)|(mode)),((cmd_t)(data)),((cmd_t)(info))
#define CNTL_CMD_WRITE(mode,data,info)	((7<<28)|(mode)),((cmd_t)(data)),((cmd_t)(info))
#define CNTL_CE_NOT_SEL					0xf

#define CNTL_CMD_NOP_COUNT              1
#define CNTL_CMD_CLE_COUNT              1
#define CNTL_CMD_ALE_COUNT              1
#define CNTL_CMD_WAIT_COUNT				1
#define CNTL_CMD_SEED_COUNT				1
#define CNTL_CMD_STATUS_COUNT			2
#define CNTL_CMD_READ_COUNT				3
#define CNTL_CMD_WRITE_COUNT			3

#define NAND_CMD_STAT_START 0
#define NAND_CMD_STAT_END 	-1
#define DECLARE_POUT(out) cmd_queue_t * pout=out
#define WRITE_CMD_QUEUE(a,b...) cmd_queue_write(pout,CNTL_CMD_##a##_COUNT,CNTL_CMD_##a(b))

typedef uint32_t jobkey_t;
typedef int32_t dma_t;
typedef uint32_t cmd_t;
typedef struct cmd_queue_s cmd_queue_t;
struct cmd_queue_s{
	uint32_t maxsize;
	uint32_t cur;
	uint32_t size;
	cmd_t 	* queue;
};
typedef struct __dma_desc_s{
    dma_t       dma;
    uint16_t    page_size;
    uint16_t    io_size;
    uint8_t     info;
    uint8_t     parity;
    uint8_t     pages;
}dma_desc_t;
struct __cntl_info_s{
    const char * name;
    cntl_feature_t feature;
    uint32_t    nand_cycle; //cycle time int 0.1ns 
    ecc_t       *ecc;
    int32_t  (* ecc2dma)(ecc_t * orig,dma_desc_t* dma,uint32_t size,uint32_t short_size,uint32_t seed);
    int32_t  (* info2data)(void * data,void * info,dma_t dma);//-1,found ecc fail,>=0,ecc counter .
    int32_t  (* data2info)(void * info,void * data,dma_t dma);//-1,error found
    
    /** configure and control function **/
    int32_t (* config)(cntl_t * cntl, uint32_t config, va_list args);

    /** fifo relative functions **/
    uint32_t (* size)(cntl_t *);
    uint32_t (* avail)(cntl_t *);
    uint32_t (* head)(cntl_t *);
    uint32_t (* tail)(cntl_t *);

    /** nand command routines*/
    int32_t	 (* convert_cmd)(cntl_t * cntl,cmd_queue_t * in,cmd_queue_t * out);
    /** This command will send to cntl directly     */
    int32_t  (* write_cmd)(cntl_t * ,cmd_queue_t * cmd);
#define IS_CLE(a)	((a&0x100)==0)
#define NAND_CLE(a)	((a)&0xff)
#define NAND_ALE(a)	(((a)&0xff)|0x100)
    int32_t   (* ctrl)(cntl_t *, uint16_t ce,uint16_t ctrl);

#define NAND_RB_IO4 		0x10
#define NAND_RB_IO5 		0x11
#define NAND_RB_IO6 		0x12
#define NAND_RB_PIN0		0
#define NAND_RB_PIN1		1
#define NAND_RB_PIN2		2
#define NAND_RB_PIN3		3
#define NAND_RB_INT_IO4 		(0x20|0x10)
#define NAND_RB_INT_IO5 		(0x20|0x11)
#define NAND_RB_INT_IO6 		(0x20|0x12)
#define NAND_RB_INT_PIN0		(0x20|0   )
#define NAND_RB_INT_PIN1		(0x20|1   )
#define NAND_RB_INT_PIN2		(0x20|2   )
#define NAND_RB_INT_PIN3		(0x20|3   )
#define NAND_RB_IS_INT(mode) 	(mode&0x20)
#define NAND_RB_IS_RBIO(mode) 	(mode&0x10)
    int32_t   (* wait)(cntl_t *, uint16_t ce,uint8_t mode,uint8_t cycle_log2);
    int32_t    (* nop)(cntl_t *, uint16_t ce,uint16_t cycles);
    /**
     *
     * @param
     * @param job
     * @param mode	1 , initerrupt disable ; 2 interrupt enable
     * @return success >0
     */
#define STS_NO_INTERRUPT 	1
#define STS_INTERRUPT 		2

    int32_t    (* sts)(cntl_t *,jobkey_t* job, uint16_t mode);
    int32_t   (* readbytes)(cntl_t *,void * addr,dma_t dma_mode);
    int32_t  (* writebytes)(cntl_t *,void * addr,dma_t dma_mode);
    int32_t     (* readecc)(cntl_t *,void * addr ,void * info,dma_t dma_mode);
    int32_t    (* writeecc)(cntl_t *,void * addr ,void * info,dma_t dma_mode);
    int32_t    (* seed)(cntl_t *, uint16_t seed);//0 disable

    /** util functions for async mode **/
    jobkey_t*  (* job_get)(cntl_t * cntl_t,uint32_t mykey);
    int32_t  (* job_free)(cntl_t * cntl_t,jobkey_t* job);
    uint32_t  (* job_key)(cntl_t * cntl_t,jobkey_t* job);
    /**
     *
     * @param cntl_t
     * @param job
     * @return <0 , job is doing; others , value readback from nand flash .
     */
    int32_t  (* job_status)(cntl_t * cntl_t,jobkey_t* job);
    /**
     *
     * @param cntl_t controller
     * @param jobs	in/out parameter ,the finish status job list
     * @param size	input jobs size
     * @return <0 , error ; >=0 , return size of jobs
     */
    int32_t (*job_lookup)(cntl_t * cntl, jobkey_t ** jobs,uint32_t size);//
    void *   priv;
};
#define FEATURE_SUPPORT_MAX_CES         (0xf<<0)
#define FEATURE_SUPPORT_SHORT_ECC       (1<<4)
#define FEATURE_SUPPORT_NO_RB           (1<<5)
#define FEATURE_SUPPORT_STS_INTERRUPT   (1<<6)
#define FEATURE_SUPPORT_TOGGLE          (1<<7)
#define FEATURE_SUPPORT_SYNC            (1<<8)
#define FEATURE_SUPPORT_CMDFIFO         (1<<9)
#define FEATURE_SUPPORT_SCRAMBLE        (1<<10)

/*
    config command
*/
#define NAND_CNTL_INIT      	0   // struct aml_nand_platform *
#define NAND_CNTL_TIME_SET      1   // t_rea,t_rhoh
#define NAND_CNTL_MODE     2		//uint16_t mode
	#define	NAND_CNTL_FIFO_MASK		3
		#define	NAND_CNTL_FIFO_HW				0
		#define	NAND_CNTL_FIFO_CMD				1
		#define	NAND_CNTL_FIFO_HW_NO_WAIT		2
		#define	NAND_CNTL_FIFO_CMD_AUTO			3
	#define	NAND_CNTL_MODE_INT_STS				0x4
	#define NAND_CNTL_MODE_INT_RB				0x8
#define NAND_CNTL_POWER_SET     3   //@todo
#define NAND_CNTL_FIFO_RESET    4   //@todo
#define NAND_CNTL_ERROR			5 //uint32_t * out ,
#define NAND_CNTL_GO			6
#define NAND_CNTL_RESET			7

#define NAND_CNTL_ERROR_TIMEOUT -1
/**
 * Interface functions
 */

extern int32_t cntl_try_lock(void);
extern void cntl_unlock(void);
extern int32_t cntl_init(struct aml_nand_platform *plat);
extern cntl_t *cntl_get(void);
extern int32_t cntl_config(uint32_t config, ...);
extern uint32_t cntl_size(void);
extern uint32_t cntl_avail(void);
extern uint32_t cntl_head(void);
extern uint32_t cntl_tail(void);
extern int32_t cntl_ctrl(uint16_t ce, uint16_t ctrl);
extern int32_t cntl_wait(uint16_t ce, uint8_t mode, uint8_t cycle_log2);
extern int32_t cntl_nop(uint16_t ce, uint16_t cycles);
extern int32_t cntl_sts(jobkey_t *job, uint16_t mode);
extern int32_t cntl_readbytes(void *addr, dma_t dma_mode);
extern int32_t cntl_writebytes(void *addr, dma_t dma_mode);
extern int32_t cntl_readecc(void *addr, void *info, dma_t dma_mode);
extern int32_t cntl_writeecc(void *addr, void *info, dma_t dma_mode);
extern jobkey_t *cntl_job_get(uint32_t mykey);
extern int32_t cntl_job_free(jobkey_t *job);
extern int32_t cntl_job_lookup(jobkey_t **jobs, uint32_t size);
extern int32_t cntl_job_status(jobkey_t *job, uint32_t key);
extern int32_t cntl_error(void *desc);
extern void cntl_continue(void);
extern void cntl_reset(void);
extern int32_t cntl_seed(uint16_t seed);
extern int32_t cntl_ecc2dma(ecc_t *orig, dma_desc_t *dma, uint32_t size, uint32_t short_size, uint32_t seed);
extern int32_t cntl_info2data(void *data, void *info, dma_t dma);
extern int32_t cntl_data2info(void *info, void *data, dma_t dma);
extern int32_t cntl_write_cmd(cmd_queue_t *in, cmd_queue_t *out);
extern int32_t cntl_finish_jobs(void (*cb_finish)(uint32_t key, uint32_t st));
extern cmd_queue_t *cmd_queue_alloc(void);
extern void cmd_queue_free(cmd_queue_t *queue);
extern int32_t cmd_queue_write(cmd_queue_t *queue, uint32_t count, ...);
extern cmd_t cmd_queue_get_next(cmd_queue_t *queue);


#endif
