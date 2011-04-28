
#ifndef _ASM_AML_NAND_H_INCLUDED
#define _ASM_AML_NAND_H_INCLUDED
#include <linux/mtd/mtd.h>
#include <linux/mtd/nand.h>
//#include <common.h>
#include "registers.h"
#include "reg_addr.h"
#include "io.h"

/** Register defination **/

#define NAND_SYS_CLK_NAME	  "clk81"
#define NAND_CYCLE_DELAY	  90
#define NAND_BOOT_NAME		  "nand0"
#define NAND_NORMAL_NAME	  "nand1"
#define NAND_MULTI_NAME		  "nand2"

#define NAND_CONVERST_ADDR	  0xa0000000
#define A3_BOOT_WRITE_SIZE	  0x600
#define A3_BOOT_COPY_NUM	  4
#define A3_BOOT_PAGES_PER_COPY	  256

#define NFC_BASE			  CBUS_REG_ADDR(NAND_CMD)
#define NFC_OFF_CMD           ((NAND_CMD -NAND_CMD)<<2)
#define NFC_OFF_CFG           ((NAND_CFG -NAND_CMD)<<2)
#define NFC_OFF_DADR          ((NAND_DADR-NAND_CMD)<<2)
#define NFC_OFF_IADR          ((NAND_IADR-NAND_CMD)<<2)
#define NFC_OFF_BUF           ((NAND_BUF -NAND_CMD)<<2)
#define NFC_OFF_INFO          ((NAND_INFO-NAND_CMD)<<2)
#define NFC_OFF_DC            ((NAND_DC  -NAND_CMD)<<2)
#define NFC_OFF_ADR           ((NAND_ADR -NAND_CMD)<<2)
#define NFC_OFF_DL            ((NAND_DL  -NAND_CMD)<<2)
#define NFC_OFF_DH            ((NAND_DH  -NAND_CMD)<<2)

#define P_NAND_CMD                                CBUS_REG_ADDR(NAND_CMD)
#define P_NAND_CFG                                CBUS_REG_ADDR(NAND_CFG)
#define P_NAND_DADR                               CBUS_REG_ADDR(NAND_DADR)
#define P_NAND_IADR                               CBUS_REG_ADDR(NAND_IADR)
#define P_NAND_BUF                                CBUS_REG_ADDR(NAND_BUF)
#define P_NAND_INFO                               CBUS_REG_ADDR(NAND_INFO)
#define P_NAND_DC                                 CBUS_REG_ADDR(NAND_DC)
#define P_NAND_ADR                                CBUS_REG_ADDR(NAND_ADR)
#define P_NAND_DL                                 CBUS_REG_ADDR(NAND_DL)
#define P_NAND_DH                                 CBUS_REG_ADDR(NAND_DH)
#define P_NAND_CADR                               CBUS_REG_ADDR(NAND_CADR)
#define P_NAND_SADR                               CBUS_REG_ADDR(NAND_SADR)


/*
   Common Nand Read Flow
*/
#define CE0         (0xe<<10)
#define CE1         (0xd<<10)
#define CE2         (0xb<<10)
#define CE3         (0x7<<10)
#define CE_NOT_SEL  (0xf<<10)
#define IO4 ((0xe<<10)|(1<<18)) 
#define IO5 ((0xd<<10)|(1<<18)) 
#define IO6 ((0xb<<10)|(1<<18)) 
#define CLE         (0x5<<14)
#define ALE         (0x6<<14)
#define DWR         (0x4<<14)
#define DRD         (0x8<<14)
#define IDLE        (0xc<<14)
#define RB  		(1<<20) 
#define STANDBY     (0xf<<10)

//#define DWR_SYNC         (0x7<<14)
//#define DRD_SYNC         (0x3<<14)
#define DWR_SYNC         DWR
#define DRD_SYNC         DRD

#define PER_INFO_BYTE 8       //64 bit  P_NAND_INFO now 
#define SIZE_INT	  (sizeof(unsigned int))	


#define M2N  ((0<<17) | (2<<20) | (1<<19))
#define N2M  ((1<<17) | (2<<20) | (1<<19))

#define M2N_NORAN  0x00200000
#define N2M_NORAN  0x00220000

#define STS  ((3<<17) | (2<<20))
#define ADL  ((0<<16) | (3<<20))
#define ADH  ((1<<16) | (3<<20))
#define AIL  ((2<<16) | (3<<20))
#define AIH  ((3<<16) | (3<<20))
#define ASL  ((4<<16) | (3<<20))
#define ASH  ((5<<16) | (3<<20))
#define SEED ((8<<16) | (3<<20))

/**
    Nand Flash Controller (M1)
    Global Macros
*/
/**
   Config Group
*/
#define NAND_SYNC_MODE  0x01
#define NAND_TOGGLE_MODE  0x02

#define NFC_SET_CMD_START()						   		SET_CBUS_REG_MASK(NAND_CFG,1<<12) 
#define NFC_SET_CMD_AUTO()						   		SET_CBUS_REG_MASK(NAND_CFG,1<<13) 
#define NFC_SET_STS_IRQ(en)					       		WRITE_CBUS_REG_BITS(NAND_CFG,en,20,1) 
#define NFC_SET_CMD_IRQ(en)					       		WRITE_CBUS_REG_BITS(NAND_CFG,en,21,1) 
#define NFC_SET_TIMING_ASYC(bus_tim,bus_cyc)       		WRITE_CBUS_REG_BITS(NAND_CFG,((bus_cyc&31)|((bus_tim&31)<<5)|(0<<10)),0,12)
#define NFC_SET_TIMING_SYNC(bus_tim,bus_cyc,sync_mode)  WRITE_CBUS_REG_BITS(NAND_CFG,(bus_cyc&31)|((bus_tim&31)<<5)|((sync_mode&3)<<10),0,12)
#define NFC_SET_TIMING_SYNC_ADJUST() 
#define NFC_SET_DMA_MODE(is_apb,spare_only)        WRITE_CBUS_REG_BITS(NAND_CFG,((spare_only<<1)|(is_apb)),14,2)

/**
    CMD relative Macros
    Shortage word . NFCC
*/
#define NFC_CMD_IDLE(ce,time)          ((ce)|IDLE|(time&0x3ff))
#define NFC_CMD_CLE(ce,cmd  )          ((ce)|CLE |(cmd &0x0ff))
#define NFC_CMD_ALE(ce,addr )          ((ce)|ALE |(addr&0x0ff))
#define NFC_CMD_STANDBY(time)          (STANDBY  |(time&0x3ff))
#define NFC_CMD_ADL(addr)              (ADL     |(addr&0xffff))
#define NFC_CMD_ADH(addr)              (ADH|((addr>>16)&0xffff))
#define NFC_CMD_AIL(addr)              (AIL     |(addr&0xffff))
#define NFC_CMD_AIH(addr)              (AIH|((addr>>16)&0xffff))
#define NFC_CMD_DWR(data)              (DWR     |(data&0xff  ))
#define NFC_CMD_DRD(ce,size)           (ce|DRD|size)
#define NFC_CMD_RB(ce,time  )          ((ce)|RB  |(time&0x1f))
#define NFC_CMD_RB_INT(ce,time)        ((ce)|RB|(((ce>>10)^0xf)<<14)|(time&0x1f))
#define NFC_CMD_RBIO(time,io)		   (RB|io|(time&0x1f))	
#define NFC_CMD_RBIO_INT(io,time)      (RB|(((io>>10)^0x7)<<14)|(time&0x1f))
#define NFC_CMD_SEED(seed)			   (SEED|seed&0x7fff)
#define NFC_CMD_STS(tim) 			   (STS|(tim&3))
#define NFC_CMD_M2N(ran,ecc,sho,pgsz,pag)      ((ran?M2N:M2N_NORAN)|(ecc<<14)|(sho<<13)|((pgsz&0x7f)<<6)|(pag&0x3f))
#define NFC_CMD_N2M(ran,ecc,sho,pgsz,pag)      ((ran?N2M:N2M_NORAN)|(ecc<<14)|(sho<<13)|((pgsz&0x7f)<<6)|(pag&0x3f))




/**
    Alias for CMD
*/
#define NFC_CMD_D_ADR(addr)         NFC_CMD_ADL(addr),NFC_CMD_ADH(addr)   
#define NFC_CMD_I_ADR(addr)         NFC_CMD_ADI(addr),NFC_CMD_ADI(addr)   


/**
    Register Operation and Controller Status 
*/
#define NFC_SEND_CMD(cmd)           (WRITE_CBUS_REG(NAND_CMD,cmd))
#define NFC_READ_INFO()             (READ_CBUS_REG(NAND_CMD))
/** ECC defination(M1) */

#define NAND_ECC_NONE             (0x0)
#define NAND_ECC_BCH8_512         (0x1)
#define NAND_ECC_BCH8_1K          (0x2)
#define NAND_ECC_BCH16            (0x3)
#define NAND_ECC_BCH24            (0x4)
#define NAND_ECC_BCH30			  (0x5)
#define NAND_ECC_BCH40			  (0x6)
#define NAND_ECC_BCH60			  (0x7)

/**
    Cmd FIFO control
*/
#define NFC_CMD_FIFO_GO()               (WRITE_CBUS_REG(NAND_CMD,(1<<30)))
#define NFC_CMD_FIFO_RESET()            (WRITE_CBUS_REG(NAND_CMD,(1<<31)))
/**
    ADDR operations
*/
#define NFC_SET_DADDR(a)         (WRITE_CBUS_REG(NAND_DADR,(unsigned)a))
#define NFC_SET_IADDR(a)         (WRITE_CBUS_REG(NAND_IADR,(unsigned)a))
#define NFC_SET_SADDR(a)		 (WRITE_CBUS_REG(NAND_SADR,(unsigned)a))	

/**
    Send command directly
*/
/*#define NFC_SEND_CMD_IDLE(ce,time)          NFC_SEND_CMD((ce)|IDLE|(time&0x3ff))
#define NFC_SEND_CMD_CLE(ce,cmd  )          NFC_SEND_CMD((ce)|CLE |(cmd &0x0ff))
#define NFC_SEND_CMD_ALE(ce,addr )          NFC_SEND_CMD((ce)|ALE |(addr&0x0ff))
#define NFC_SEND_CMD_RB(ce,time  )          NFC_SEND_CMD((ce)|RB  |(time&0x3ff))
#define NFC_SEND_CMD_STANDBY(time)          NFC_SEND_CMD(STANDBY  |(time&0x3ff))
#define NFC_SEND_CMD_ADL(addr)              NFC_SEND_CMD(ADL     |(addr&0xffff))
#define NFC_SEND_CMD_ADH(addr)              NFC_SEND_CMD(ADH|((addr>>16)&0xffff))
#define NFC_SEND_CMD_AIL(addr)              NFC_SEND_CMD(AIL     |(addr&0xffff))
#define NFC_SEND_CMD_AIH(addr)              NFC_SEND_CMD(AIH|((addr>>16)&0xffff))
#define NFC_SEND_CMD_M2N(size,ecc)          NFC_SEND_CMD(M2N |ecc|(size&0x3fff))
#define NFC_SEND_CMD_N2M(size,ecc)          NFC_SEND_CMD(N2M |ecc|(size&0x3fff))
#define NFC_SEND_CMD_DWR(data)              NFC_SEND_CMD(DWR     |(data&0xff  ))
#define NFC_SEND_CMD_DRD(    )              NFC_SEND_CMD(DRD                   )
*/
#define NFC_SEND_CMD_IDLE(ce,time)          NFC_SEND_CMD(NFC_CMD_IDLE(ce,time))
#define NFC_SEND_CMD_CLE(ce,cmd  )          NFC_SEND_CMD(NFC_CMD_CLE(ce,cmd))
#define NFC_SEND_CMD_ALE(ce,addr )          NFC_SEND_CMD(NFC_CMD_ALE(ce,addr))
#define NFC_SEND_CMD_STANDBY(time)          NFC_SEND_CMD(NFC_CMD_STANDBY(time))
#define NFC_SEND_CMD_ADL(addr)              NFC_SEND_CMD(NFC_CMD_ADL(addr))
#define NFC_SEND_CMD_ADH(addr)              NFC_SEND_CMD(NFC_CMD_ADH(addr))
#define NFC_SEND_CMD_AIL(addr)              NFC_SEND_CMD(NFC_CMD_AIL(addr))
#define NFC_SEND_CMD_AIH(addr)              NFC_SEND_CMD(NFC_CMD_AIH(addr))
#define NFC_SEND_CMD_DWR(data)              NFC_SEND_CMD(NFC_CMD_DWR(data))
#define NFC_SEND_CMD_DRD(ce,size)           NFC_SEND_CMD(NFC_CMD_DRD(ce,size))
#define NFC_SEND_CMD_RB(ce,time)          	NFC_SEND_CMD(NFC_CMD_RB(ce,time))
#define NFC_SEND_CMD_SEED(seed)				NFC_SEND_CMD(NFC_CMD_SEED(seed))	
#define NFC_SEND_CMD_M2N(ran,ecc,sho,pgsz,pag)   NFC_SEND_CMD(NFC_CMD_M2N(ran,ecc,sho,pgsz,pag))
#define NFC_SEND_CMD_N2M(ran,ecc,sho,pgsz,pag)   NFC_SEND_CMD(NFC_CMD_N2M(ran,ecc,sho,pgsz,pag))

#define NFC_SEND_CMD_M2N_RAW(ran,len)	NFC_SEND_CMD((ran?M2N:M2N_NORAN)|(len&0x3fff))
#define NFC_SEND_CMD_N2M_RAW(ran,len)   NFC_SEND_CMD((ran?N2M:N2M_NORAN)|(len&0x3fff))


/**
    Cmd Info Macros
*/
#define NFC_INFO_GET()                      (READ_CBUS_REG(NAND_CMD))
#define NFC_CMDFIFO_SIZE()                  ((NFC_INFO_GET()>>22)&0x1f)
#define NFC_CHECEK_RB_TIMEOUT()             ((NFC_INFO_GET()>>27)&0x1)
#define NFC_GET_RB_STATUS(ce)               (((NFC_INFO_GET()>>28)&(~(ce>>10)))&0xf)
#define NFC_GET_BUF() 					    READ_CBUS_REG(NAND_BUF)
#define NFC_SET_CFG(val) 			      	(WRITE_CBUS_REG(NAND_CFG,(unsigned)val))	
#define NFC_FIFO_CUR_CMD()				    ((NFC_INFO_GET()>>22)&0x3FFFFF)		


#define NAND_INFO_DONE(a)         (((a)>>31)&1)
#define NAND_ECC_ENABLE(a)        (((a)>>30)&1)

#define NAND_ECC_CNT(a)           (((a)>>24)&0x3f)
#define NAND_ZERO_CNT(a)	      (((a)>>16)&0x3f)	
#define NAND_INFO_DATA_2INFO(a)   ((a)&0xffff)
#define NAND_INFO_DATA_1INFO(a)   ((a)&0xff)


#define NAND_DEFAULT_OPTIONS			(NAND_TIMING_MODE5 | NAND_ECC_BCH8_512_MODE)


#define AML_NORMAL						0
#define AML_MULTI_CHIP					1
#define AML_MULTI_CHIP_SHARE_RB			2
#define AML_INTERLEAVING_MODE			4
#define AML_SYNC_MODE			8

#define AML_NAND_CE0         			0xe
#define AML_NAND_CE1         			0xd
#define AML_NAND_CE2         			0xb
#define AML_NAND_CE3         			0x7

#define AML_BADBLK_POS					0
#define NAND_ECC_UNIT_SIZE				512
#define NAND_ECC_UNIT_1KSIZE			1024
#define NAND_ECC_UNIT_SHORT			    384

#define NAND_BCH8_512_ECC_SIZE			14
#define NAND_BCH8_1K_ECC_SIZE			14
#define NAND_BCH16_ECC_SIZE				28
#define NAND_BCH24_ECC_SIZE				42
#define NAND_BCH30_ECC_SIZE				54
#define NAND_BCH40_ECC_SIZE				70
#define NAND_BCH60_ECC_SIZE				106

#define NAND_ECC_OPTIONS_MASK			0x0000000f
#define NAND_PLANE_OPTIONS_MASK			0x000000f0
#define NAND_TIMING_OPTIONS_MASK		0x00000f00
#define NAND_BUSW_OPTIONS_MASK			0x0000f000
#define NAND_INTERLEAVING_OPTIONS_MASK	0x000f0000
#define NAND_SYNC_OPTIONS_MASK	0x80000000

#define NAND_ECC_SOFT_MODE				0x00000000
#define NAND_ECC_BCH8_512_MODE			0x00000001
#define NAND_ECC_BCH8_1K_MODE			0x00000002
#define NAND_ECC_BCH16_MODE				0x00000003
#define NAND_ECC_BCH24_MODE				0x00000004
#define NAND_ECC_BCH30_MODE				0x00000005
#define NAND_ECC_BCH40_MODE				0x00000006
#define NAND_ECC_BCH60_MODE				0x00000007
#define NAND_ECC_SHORT_MODE				0x00000008


#define NAND_TWO_PLANE_MODE				0x00000010
#define NAND_INTERLEAVING_MODE			0x00010000
#define NAND_TIMING_MODE0				0x00000000
#define NAND_TIMING_MODE1				0x00000100
#define NAND_TIMING_MODE2				0x00000200
#define NAND_TIMING_MODE3				0x00000300
#define NAND_TIMING_MODE4				0x00000400
#define NAND_TIMING_MODE5				0x00000500

#define NAND_SYNCIF				0x80000000

/*#define NAND_DEFAULT_OPTIONS			(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)*/

#define AML_NAND_BUSY_TIMEOUT			0x40000
#define AML_DMA_BUSY_TIMEOUT			0x100000
#define MAX_ID_LEN						8

#define NAND_CMD_PLANE2_READ_START		0x06
#define NAND_CMD_TWOPLANE_PREVIOS_READ	0x60
#define NAND_CMD_TWOPLANE_READ1			0x5a
#define NAND_CMD_TWOPLANE_READ2			0xa5
#define NAND_CMD_TWOPLANE_WRITE2_MICRO	0x80
#define NAND_CMD_TWOPLANE_WRITE2		0x81
#define NAND_CMD_DUMMY_PROGRAM			0x11
#define NAND_CMD_ERASE1_END				0xd1
#define NAND_CMD_MULTI_CHIP_STATUS		0x78
#define NAND_CMD_SET_FEATURES			0xEF
#define NAND_CMD_GET_FEATURES			0xEE
#define ONFI_TIMING_ADDR				0x01



#define MAX_CHIP_NUM		4
#define USER_BYTE_NUM		4

#define NAND_STATUS_READY_MULTI			0x20

struct aml_nand_flash_dev {
	char *name;
	u8 id[MAX_ID_LEN];
	unsigned pagesize;
	unsigned chipsize;
	unsigned erasesize;
	unsigned oobsize;
	unsigned internal_chipnr;
	unsigned options;
//	u8 onfi_mode;
};
struct ecc_desc_s{
    char * name;
    unsigned bch;
    unsigned size;
    unsigned parity;
    unsigned user;
};

struct aml_nand_chip {
	/* mtd info */
	u8 mfr_type;
	unsigned options;
	unsigned page_size;
	unsigned block_size;
	unsigned oob_size;
	unsigned virtual_page_size;
	unsigned virtual_block_size;
	u8 plane_num;
	u8 chip_num;
	u8 internal_chipnr;
	unsigned internal_page_nums;

	unsigned internal_chip_shift;
	unsigned int 	       ran_mode; 				//def close, for all part
	unsigned int          rbpin_mode;
    unsigned int          short_pgsz;				//zero means no short 
	
	unsigned bch_mode;
	u8 user_byte_mode;
	u8 ops_mode;
	u8 cached_prog_status;
	unsigned chip_enable[MAX_CHIP_NUM];
	unsigned rb_enable[MAX_CHIP_NUM];
	unsigned chip_selected;
	unsigned rb_received;
	unsigned valid_chip[MAX_CHIP_NUM];
	unsigned page_addr;
	unsigned char *aml_nand_data_buf;
	unsigned int *user_info_buf;

	struct mtd_info			*mtd; 
	struct nand_chip		chip;

	/* platform info */
	struct aml_nand_platform	*platform;

	/* device info */
	struct device			*device;

	unsigned max_ecc;
    struct ecc_desc_s * ecc;
//	unsigned onfi_mode;

	//plateform operation function
	void	(*aml_nand_hw_init)(struct aml_nand_chip *aml_chip);
	int		(*aml_nand_options_confirm)(struct aml_nand_chip *aml_chip);
	void 	(*aml_nand_cmd_ctrl)(struct aml_nand_chip *aml_chip, int cmd,  unsigned int ctrl);
	void	(*aml_nand_select_chip)(struct aml_nand_chip *aml_chip, int chipnr);
	void (*aml_nand_write_byte)(struct aml_nand_chip *aml_chip, uint8_t data); 
	void	(*aml_nand_get_user_byte)(struct aml_nand_chip *aml_chip, unsigned char *oob_buf, int byte_num);
	void	(*aml_nand_set_user_byte)(struct aml_nand_chip *aml_chip, unsigned char *oob_buf, int byte_num);
	void	(*aml_nand_command)(struct aml_nand_chip *aml_chip, unsigned command, int column, int page_addr, int chipnr);
	int		(*aml_nand_wait_devready)(struct aml_nand_chip *aml_chip, int chipnr);
	int		(*aml_nand_dma_read)(struct aml_nand_chip *aml_chip, unsigned char *buf, int len, unsigned bch_mode);
	int		(*aml_nand_dma_write)(struct aml_nand_chip *aml_chip, unsigned char *buf, int len, unsigned bch_mode);
	int		(*aml_nand_hwecc_correct)(struct aml_nand_chip *aml_chip, unsigned char *buf, unsigned size, unsigned char *oob_buf);
};

struct aml_nand_platform {
		struct aml_nand_flash_dev *nand_flash_dev;
		char *name;
		unsigned chip_enable_pad;
		unsigned ready_busy_pad;

         /* DMA RD/WR delay loop  timing */
         unsigned int          T_REA;							// for dma  wating delay
         unsigned int          T_RHOH;							// not equal of  (nandchip->delay, which is for dev ready func) 
		 unsigned int 	       ran_mode; 				//def close, for all part
	     unsigned int          rbpin_mode;					//may get from romboot 
		 unsigned int          short_pgsz;				//zero means no short 
		 		
		 struct aml_nand_chip  *aml_chip;
         struct platform_nand_data platform_nand_data;
};

struct aml_nand_device {
	struct aml_nand_platform *aml_nand_platform;
	u8 dev_num;
};

#define  CONFIG_AM_NAND_RBPIN	0

static void inline  nand_get_chip(void )
{
	setbits_le32(P_PREG_PAD_GPIO3_EN_N,0x3ffff);	//disable gpio output
	SET_CBUS_REG_MASK(PAD_PULL_UP_REG3,(0xff<<0) | (1<<16));
	setbits_le32(P_PERIPHS_PIN_MUX_5,0x7<<7);
#if CONFIG_AM_NAND_RBPIN	
	setbits_le32(P_PERIPHS_PIN_MUX_2, (1<<27) | (1<<26) | (1<<25) | (0xf<<18)|(1<<17));
//	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_4, (0x1<<11) | (0xff<<14));
#else
	setbits_le32(P_PERIPHS_PIN_MUX_2, (1<<27) | (1<<26) | (1<<25) | (0xf<<18));
#endif
	//SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<30) | (1<<28) | (1<<26) | (1<<24)));
}
static void inline nand_release_chip(void)
{	
	setbits_le32 (P_PREG_PAD_GPIO3_O,0x3ffff);
	clrbits_le32(P_PREG_PAD_GPIO3_EN_N,0x3ffff);	//enable gpio output
#if CONFIG_AM_NAND_RBPIN
	clrbits_le32(P_PERIPHS_PIN_MUX_2, (1<<27) | (1<<26) | (1<<25) | (0xf<<18)|(1<<17));
#else
	clrbits_le32(P_PERIPHS_PIN_MUX_2, (1<<27) | (1<<26) | (1<<25) | (0xf<<18));
#endif
//	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_4, (0x1<<11) | (0xff<<14));
//	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<30) | (1<<28) | (1<<26) | (1<<24)));
}

//static inline struct aml_nand_chip *to_nand_chip(struct platform_device *pdev)
//{
//	return platform_get_drvdata(pdev);
//}

/*
static inline struct aml_nand_chip *mtd_to_nand_chip(struct mtd_info *mtd)
{
	return container_of(mtd, struct aml_nand_chip, mtd);
}
*/
static inline struct aml_nand_chip *mtd_to_nand_chip(struct mtd_info *mtd)
{
      struct nand_chip *chip = mtd->priv;
	return chip->priv;
}

extern int aml_nand_init(struct aml_nand_chip *aml_chip);
extern int aml_nand_probe(struct mtd_info *mtd);


#endif // NAND_H_INCLUDED

