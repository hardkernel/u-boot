
#ifndef NAND_H_INCLUDED
#define NAND_H_INCLUDED

#include "amlnf_dev.h"

#ifndef AML_NAND_UBOOT
#include <mach/io.h>
#endif

#ifdef CONFIG_NAND_AML_M8
#define 	NAND_CYCLE_DELAY				84
#else
#define 	NAND_SYS_CLK_NAME	  			"clk81"
#define 	NAND_CYCLE_DELAY				90
#endif

#ifdef AML_NAND_UBOOT

#define AMLNF_WRITE_REG(reg, val)			*(volatile unsigned *)(reg) = (val)
#define AMLNF_READ_REG(reg) 				*(volatile unsigned *)(reg)	
#define AMLNF_WRITE_REG_BITS(reg, val, start, len) 	AMLNF_WRITE_REG(reg, (AMLNF_READ_REG(reg) \
													 & ~(((1L<<(len))-1)<<(start)))\
													 | ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define AMLNF_SET_REG_MASK(reg, mask)     			AMLNF_WRITE_REG(reg, AMLNF_READ_REG(reg) | (mask))
#define AMLNF_CLEAR_REG_MASK(reg, mask) 				AMLNF_WRITE_REG(reg, AMLNF_READ_REG(reg) & (~(mask))) 
#else

#define AMLNF_WRITE_REG(reg, val) 					(aml_write_reg32(reg, (val)))
#define AMLNF_READ_REG(reg) 						(aml_read_reg32(reg))
#define AMLNF_WRITE_REG_BITS(reg, val, start, len) 	(aml_set_reg32_bits(reg, (val),start,len))
//#define AMLNF_READ_REG_BITS(bus,reg, start, len) 	(aml_get_reg32_bits(reg,start,len))
#define AMLNF_CLEAR_REG_MASK(reg, mask)   			(aml_clr_reg32_mask(reg, (mask)))
#define AMLNF_SET_REG_MASK(reg, mask)     			(aml_set_reg32_mask(reg, (mask)))

#endif

#ifdef AML_NAND_UBOOT

#ifdef CONFIG_NAND_AML_M8
#define P_HHI_NAND_CLK_CNTL 0xc110425c
#define P_NAND_BASE 0xd0048600
#else
#define P_NAND_BASE 0xc1108600
#endif

#else

#ifdef CONFIG_NAND_AML_M8
#define P_NAND_BASE IO_NAND_BASE
#define P_HHI_NAND_CLK_CNTL IO_CBUS_BASE+0x425c
#else
#define P_NAND_BASE (IO_CBUS_BASE+0x8600)
#endif

#endif

#define P_NAND_CMD                                (P_NAND_BASE+(0x0<<2))
#define P_NAND_CFG                                (P_NAND_BASE+(0x1<<2))
#define P_NAND_DADR                               (P_NAND_BASE+(0x2<<2))
#define P_NAND_IADR                               (P_NAND_BASE+(0x3<<2))
#define P_NAND_BUF                                (P_NAND_BASE+(0x4<<2))
#define P_NAND_INFO                               (P_NAND_BASE+(0x5<<2))
#define P_NAND_DC                                 (P_NAND_BASE+(0x6<<2))
#define P_NAND_ADR                                (P_NAND_BASE+(0x7<<2))
#define P_NAND_DL                                 (P_NAND_BASE+(0x8<<2))
#define P_NAND_DH                                 (P_NAND_BASE+(0x9<<2))
#define P_NAND_CADR	                              (P_NAND_BASE+(0xa<<2))  
#define P_NAND_SADR	                              (P_NAND_BASE+(0xb<<2))
#define P_NAND_PINS                               (P_NAND_BASE+(0xc<<2))
#define P_NAND_VER	                              (P_NAND_BASE+(0xe<<2))

#ifdef CONFIG_NAND_AML_M8
#define NFC_SET_CORE_PLL(a)                         AMLNF_WRITE_REG(P_HHI_NAND_CLK_CNTL,(unsigned)a)
#endif

#define NAND_IO_ADDR	 		P_NAND_BUF

#define NFC_SET_TIMING(mode,cycles,adjust)              		AMLNF_WRITE_REG_BITS(P_NAND_CFG,((cycles)|((adjust&0xf)<<10)|((mode&7)<<5)),0,14)
#define NFC_SET_CMD_START()						   				AMLNF_SET_REG_MASK(P_NAND_CFG,1<<12) 
#define NFC_SET_CMD_AUTO()						   				AMLNF_SET_REG_MASK(P_NAND_CFG,1<<13) 
#define NFC_SET_STS_IRQ(en)					       				AMLNF_WRITE_REG_BITS(P_NAND_CFG,en,20,1) 
#define NFC_SET_CMD_IRQ(en)					       				AMLNF_WRITE_REG_BITS(P_NAND_CFG,en,21,1) 
#define NFC_SET_TIMING_ASYC(bus_tim,bus_cyc)       				AMLNF_WRITE_REG_BITS(P_NAND_CFG,((bus_cyc&31)|((bus_tim&31)<<5)|(0<<10)),0,12)
#define NFC_SET_TIMING_SYNC(bus_tim,bus_cyc,sync_mode)  		AMLNF_WRITE_REG_BITS(P_NAND_CFG,(bus_cyc&31)|((bus_tim&31)<<5)|((sync_mode&2)<<10),0,12)
#define NFC_SET_TIMING_SYNC_ADJUST() 
#define NFC_SET_DMA_MODE(is_apb,spare_only)             		AMLNF_WRITE_REG_BITS(P_NAND_CFG,((spare_only<<1)|(is_apb)),14,2)
#define NFC_SET_OOB_MODE(mode)						AMLNF_SET_REG_MASK(P_NAND_CFG,mode);
#define NFC_CLR_OOB_MODE(mode)						AMLNF_CLEAR_REG_MASK(P_NAND_CFG,(mode));
/**
    Register Operation and Controller Status 
*/
#define NFC_SEND_CMD(cmd)           			AMLNF_WRITE_REG(P_NAND_CMD,cmd)
#define NFC_READ_INFO()             				AMLNF_READ_REG(P_NAND_CMD)

/**
    ADDR operations
*/
#define NFC_SET_DADDR(a)         				AMLNF_WRITE_REG(P_NAND_DADR,(unsigned)a)
#define NFC_SET_IADDR(a)         				AMLNF_WRITE_REG(P_NAND_IADR,(unsigned)a)
#define NFC_SET_SADDR(a)		 			AMLNF_WRITE_REG(P_NAND_SADR,(unsigned)a)	

#define NFC_INFO_GET()                      					AMLNF_READ_REG(P_NAND_CMD)

#define NFC_GET_BUF() 					    			AMLNF_READ_REG(P_NAND_BUF)
#define NFC_SET_CFG(val) 			      				AMLNF_WRITE_REG(P_NAND_CFG,(unsigned)val)
#define NFC_GET_CFG									AMLNF_READ_REG(P_NAND_CFG)

/*
   Common Nand Read Flow
*/
#define CE0         					(0xe<<10)
#define CE1         					(0xd<<10)
#define CE2         					(0xb<<10)
#define CE3         					(0x7<<10)
#define CE_NOT_SEL  			(0xf<<10)
#define IO4 						((0xe<<10)|(1<<18)) 
#define IO5 						((0xd<<10)|(1<<18)) 
#define IO6 						((0xb<<10)|(1<<18)) 
#define CLE         					(0x5<<14)
#define ALE         					(0x6<<14)
#define DWR         				(0x4<<14)
#define DRD         					(0x8<<14)
#define IDLE        					(0xc<<14)
#define RB  						(1<<20) 
#define STANDBY     				(0xf<<10)

#define M2N  					((0<<17) | (2<<20) | (1<<19))
#define N2M  					((1<<17) | (2<<20) | (1<<19))

#define M2N_NORAN  			0x00200000
#define N2M_NORAN  			0x00220000

#define STS  						((3<<17) | (2<<20))
#define ADL  						((0<<16) | (3<<20))
#define ADH  					((1<<16) | (3<<20))
#define AIL  						((2<<16) | (3<<20))
#define AIH 						((3<<16) | (3<<20))
#define ASL  						((4<<16) | (3<<20))
#define ASH  						((5<<16) | (3<<20))
#define SEED 					((8<<16) | (3<<20))

#define SEED_OFFSET			0xc2

/**
    Nand Flash Controller (M1)
    Global Macros
*/
/**
   Config Group
*/

/**
    CMD relative Macros
    Shortage word . NFCC
*/
#define NFC_CMD_IDLE(ce,time)          			((ce)|IDLE|(time&0x3ff))
#define NFC_CMD_CLE(ce,cmd  )          			((ce)|CLE |(cmd &0x0ff))
#define NFC_CMD_ALE(ce,addr )          			((ce)|ALE |(addr&0x0ff))
#define NFC_CMD_STANDBY(time)          		(STANDBY  |(time&0x3ff))
#define NFC_CMD_ADL(addr)              			(ADL     |(addr&0xffff))
#define NFC_CMD_ADH(addr)              			(ADH|((addr>>16)&0xffff))
#define NFC_CMD_AIL(addr)              			(AIL     |(addr&0xffff))
#define NFC_CMD_AIH(addr)              			(AIH|((addr>>16)&0xffff))
#define NFC_CMD_DWR(ce, data)              		(ce|DWR |(data&0xff  ))
#define NFC_CMD_DRD(ce,size)           			(ce|DRD|size)
#define NFC_CMD_RB(ce,time )          			((ce)|RB  |(time&0x1f))
#define NFC_CMD_RB_INT(ce,time)        		((ce)|RB|(((ce>>10)^0xf)<<14)|(time&0x1f))
#define NFC_CMD_RBIO(time,io)		   		(RB|io|(time&0x1f))	
#define NFC_CMD_RBIO_INT(io,time)      		(RB|(((io>>10)^0x7)<<14)|(time&0x1f))
#define NFC_CMD_SEED(seed)			   		(SEED|(SEED_OFFSET + (seed&0x7fff)))
#define NFC_CMD_STS(tim) 			   		(STS|(tim&3))
#define NFC_CMD_M2N(ran,ecc,sho,pgsz,pag)      	((ran?M2N:M2N_NORAN)|(ecc<<14)|(sho<<13)|((pgsz&0x7f)<<6)|(pag&0x3f))
#define NFC_CMD_N2M(ran,ecc,sho,pgsz,pag)      	((ran?N2M:N2M_NORAN)|(ecc<<14)|(sho<<13)|((pgsz&0x7f)<<6)|(pag&0x3f))

/**
    Alias for CMD
*/
#define NFC_CMD_D_ADR(addr)         			NFC_CMD_ADL(addr),NFC_CMD_ADH(addr)   
#define NFC_CMD_I_ADR(addr)         			NFC_CMD_ADI(addr),NFC_CMD_ADI(addr)   


#ifdef CONFIG_NAND_AML_M8
#define NAND_ECC_NONE            				(0x0)
#define NAND_ECC_BCH8             				(0x1)
#define NAND_ECC_BCH8_1K          			(0x2)
#define NAND_ECC_BCH16_1K         			(0x3)
#define NAND_ECC_BCH24_1K         			(0x3)
#define NAND_ECC_BCH30_1K 		  		(0x4)
#define NAND_ECC_BCH40_1K 		  		(0x5)
#define NAND_ECC_BCH50_1K 		  		(0x6)
#define NAND_ECC_BCH60_1K 		  		(0x7)
#define NAND_ECC_BCH_SHORT		  		(0x8)
#else
#define NAND_ECC_NONE            				(0x0)
#define NAND_ECC_BCH8             				(0x1)
#define NAND_ECC_BCH8_1K          			(0x2)
#define NAND_ECC_BCH16_1K         			(0x3)
#define NAND_ECC_BCH24_1K         			(0x4)
#define NAND_ECC_BCH30_1K 		  		(0x5)
#define NAND_ECC_BCH40_1K 		  		(0x6)
#define NAND_ECC_BCH50_1K 		  		(0x6)
#define NAND_ECC_BCH60_1K 		  		(0x7)
#define NAND_ECC_BCH_SHORT		  		(0x8)
#endif

/**
    Send command directly
*/

//#define NFC_SEND_CMD_IDLE(ce,time)          				NFC_SEND_CMD(NFC_CMD_IDLE(ce,time))
#define NFC_SEND_CMD_IDLE(ce,time)   					{while(NFC_CMDFIFO_SIZE()>0);NFC_SEND_CMD(NFC_CMD_IDLE(ce,time));}
#define NFC_SEND_CMD_CLE(ce,cmd  )         		 		NFC_SEND_CMD(NFC_CMD_CLE(ce,cmd))
#define NFC_SEND_CMD_ALE(ce,addr )          				NFC_SEND_CMD(NFC_CMD_ALE(ce,addr))
#define NFC_SEND_CMD_STANDBY(time)          				NFC_SEND_CMD(NFC_CMD_STANDBY(time))
#define NFC_SEND_CMD_ADL(addr)              				NFC_SEND_CMD(NFC_CMD_ADL(addr))
#define NFC_SEND_CMD_ADH(addr)              				NFC_SEND_CMD(NFC_CMD_ADH(addr))
#define NFC_SEND_CMD_AIL(addr)              					NFC_SEND_CMD(NFC_CMD_AIL(addr))
#define NFC_SEND_CMD_AIH(addr)              					NFC_SEND_CMD(NFC_CMD_AIH(addr))
#define NFC_SEND_CMD_DWR(ce,data)             	 			NFC_SEND_CMD(NFC_CMD_DWR(ce,data))
#define NFC_SEND_CMD_DRD(ce,size)           				NFC_SEND_CMD(NFC_CMD_DRD(ce,size))
#define NFC_SEND_CMD_RB(ce,time)          					NFC_SEND_CMD(NFC_CMD_RB(ce,time))
#define NFC_SEND_CMD_SEED(seed)						NFC_SEND_CMD(NFC_CMD_SEED(seed))	
#define NFC_SEND_CMD_M2N(ran,ecc,sho,pgsz,pag)   		NFC_SEND_CMD(NFC_CMD_M2N(ran,ecc,sho,pgsz,pag))
#define NFC_SEND_CMD_N2M(ran,ecc,sho,pgsz,pag)   		NFC_SEND_CMD(NFC_CMD_N2M(ran,ecc,sho,pgsz,pag))

#define NFC_SEND_CMD_M2N_RAW(ran,len)				NFC_SEND_CMD((ran?M2N:M2N_NORAN)|(len&0x3fff))
#define NFC_SEND_CMD_N2M_RAW(ran,len)   				NFC_SEND_CMD((ran?N2M:N2M_NORAN)|(len&0x3fff))

#define NFC_SEND_CMD_STS(time, irq)          				NFC_SEND_CMD(NFC_CMD_STS(time |irq))


/**
    Cmd Info Macros
*/
#define NFC_CMDFIFO_SIZE()                  				((NFC_INFO_GET()>>22)&0x1f)
#define NFC_CHECEK_RB_TIMEOUT()             			((NFC_INFO_GET()>>27)&0x1)
#define NFC_GET_RB_STATUS(ce)               				(((NFC_INFO_GET()>>28)&(~(ce>>10)))&0xf)
#define NFC_FIFO_CUR_CMD()				    		((NFC_INFO_GET()>>22)&0x3FFFFF)		


#define NAND_INFO_DONE(a)         						(((a)>>31)&1)
#define NAND_ECC_ENABLE(a)       	 				(((a)>>30)&1)
#define NAND_ECC_CNT(a)           						(((a)>>24)&0x3f)
#define NAND_ZERO_CNT(a)	      						(((a)>>16)&0x3f)	
#define NAND_INFO_DATA_2INFO(a)   					((a)&0xffff)
#define NAND_INFO_DATA_1INFO(a)   					((a)&0xff)
#define NAND_DMA_DONE()							NAND_INFO_DONE(NFC_INFO_GET())
#define POR_CONFIG									READ_CBUS_REG(ASSIST_POR_CONFIG)

#define POC_NAND_CFG								(1<<2)
#define POC_NAND_NO_RB							(1<<0)
#define POC_NAND_ASYNC							(1<<7)

#endif // NAND_H_INCLUDED

