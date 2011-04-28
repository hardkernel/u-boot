
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
#define NAND_CYCLE_DELAY	  65
#define NAND_BOOT_NAME		  "nand0"
#define NAND_NORMAL_NAME	  "nand1"
#define NAND_MULTI_NAME		  "nand2"

#define NAND_CONVERST_ADDR	  0xa0000000

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

/*
   Common Nand Read Flow
*/
#define CE0         (0xe<<10)
#define CE1         (0xd<<10)
#define CE2         (0xb<<10)
#define CE3         (0x7<<10)
#define CE_NOT_SEL  (0xf<<10)

#define CLE         (0x5<<14)
#define ALE         (0x6<<14)
#define DWR         (0x4<<14)
#define DRD         (0x8<<14)
#define IDLE        (0xc<<14)
#define RB          (0x10<<14)
#define STANDBY     (0xf<<10)

#define ADL  (0xc<<16)
#define ADH  (0xd<<16)
#define AIL  (0xe<<16)
#define AIH  (0xf<<16)
#define M2N  (0x4<<17)
#define N2M  (0x5<<17)
/**
    Nand Flash Controller (M1)
    Global Macros
*/
/**
   Config Group
*/
#define NFC_SET_TIMING(mode,cycles,adjust)    WRITE_CBUS_REG_BITS(NAND_CFG,((cycles)|((adjust&0xf)<<10)|((mode&7)<<5)),0,14)
#define NFC_SET_DMA_MODE(is_apb,spare_only)   WRITE_CBUS_REG_BITS(NAND_CFG,((spare_only<<1)|(is_apb)),14,2)

/**
    CMD relative Macros
    Shortage word . NFCC
*/
#define NFC_CMD_IDLE(ce,time)          ((ce)|IDLE|(time&0x3ff))
#define NFC_CMD_CLE(ce,cmd  )          ((ce)|CLE |(cmd &0x0ff))
#define NFC_CMD_ALE(ce,addr )          ((ce)|ALE |(addr&0x0ff))
#define NFC_CMD_RB(ce,time  )          ((ce)|RB  |(time&0x3ff))
#define NFC_CMD_STANDBY(time)          (STANDBY  |(time&0x3ff))
#define NFC_CMD_ADL(addr)              (ADL     |(addr&0xffff))
#define NFC_CMD_ADH(addr)              (ADH|((addr>>16)&0xffff))
#define NFC_CMD_AIL(addr)              (AIL     |(addr&0xffff))
#define NFC_CMD_AIH(addr)              (AIH|((addr>>16)&0xffff))
#define NFC_CMD_M2N(size,ecc)          (M2N |ecc|(size&0x3fff))
#define NFC_CMD_N2M(size,ecc)          (N2M |ecc|(size&0x3fff))
#define NFC_CMD_DWR(data)              (DWR     |(data&0xff  ))
#define NFC_CMD_DRD(    )              (DRD                   )

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
#define NAND_ECC_NONE             (0x0<<14)
#define NAND_ECC_REV0             (0x1<<14)
#define NAND_ECC_REV1             (0x2<<14)
#define NAND_ECC_REV2             (0x3<<14)
#define NAND_ECC_BCH9             (0x4<<14)
#define NAND_ECC_BCH8             (0x5<<14)
#define NAND_ECC_BCH12            (0x6<<14)
#define NAND_ECC_BCH16            (0x7<<14)
#define NAND_ECC_BCH24            (0x4<<14)

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

/**
    Send command directly
*/
#define NFC_SEND_CMD_IDLE(ce,time)          NFC_SEND_CMD((ce)|IDLE|(time&0x3ff))
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
/**
    Cmd Info Macros
*/
#define NFC_INFO_GET()                      (READ_CBUS_REG(NAND_CMD))
#define NFC_CMDFIFO_SIZE()                  ((NFC_INFO_GET()>>20)&0x1f)
#define NFC_CHECEK_RB_TIMEOUT()             ((NFC_INFO_GET()>>25)&0x1)
#define NFC_GET_RB_STATUS(ce)               (((NFC_INFO_GET()>>26)&((~(ce>>10))&0xf))&0xf)
typedef unsigned    t_nfc_info;

#define NAND_INFO_DONE(a)         (((a)>>31)&1)
#define NAND_ECC_ENABLE(a)        (((a)>>30)&1)
#define NAND_ECC_FAIL(a)          (((a)>>29)&1)
#define NAND_ECC_CNT(a)           (((a)>>24)&0x1f)
#define NAND_INFO_DATA_2INFO(a)         ((a)&0xffff)
#define NAND_INFO_DATA_1INFO(a)         ((a)&0xff)


#define NFC_SET_SPARE_ONLY()			(SET_CBUS_REG_MASK(NAND_CFG,1<<15))
#define NFC_CLEAR_SPARE_ONLY()			(CLEAR_CBUS_REG_MASK(NAND_CFG,1<<15))
#define NFC_GET_BUF() 					READ_CBUS_REG(NAND_BUF)
#define NFC_GET_CFG() 					READ_CBUS_REG(NAND_CFG)
#define NFC_SET_CFG(val) 			    WRITE_CBUS_REG(NAND_CFG,(unsigned)val)


struct aml_nand_chip;
typedef unsigned  t_nf_ce;

typedef unsigned  t_ecc_mode;
#define NFC_GET_CE_CODE(a)				(((~(1<<(((unsigned)a)&3)))&0xf)<<10)

#define AML_NORMAL						0
#define AML_MULTI_CHIP					1
#define AML_MULTI_CHIP_SHARE_RB			2
#define AML_INTERLEAVING_MODE			4

#define AML_NAND_CE0         			0xe
#define AML_NAND_CE1         			0xd
#define AML_NAND_CE2         			0xb
#define AML_NAND_CE3         			0x7

#define AML_BADBLK_POS					0
#define NAND_ECC_UNIT_SIZE				512
#define NAND_ECC_UNIT_1KSIZE			1024
#define NAND_BCH9_ECC_SIZE				15
#define NAND_BCH8_ECC_SIZE				14
#define NAND_BCH12_ECC_SIZE				20
#define NAND_BCH16_ECC_SIZE				26
#define NAND_BCH24_ECC_SIZE				40

#define NAND_ECC_OPTIONS_MASK			0x0000000f
#define NAND_PLANE_OPTIONS_MASK			0x000000f0
#define NAND_TIMING_OPTIONS_MASK		0x00000f00
#define NAND_BUSW_OPTIONS_MASK			0x0000f000
#define NAND_INTERLEAVING_OPTIONS_MASK	0x000f0000
#define NAND_ECC_SOFT_MODE				0x00000000
#define NAND_ECC_BCH9_MODE				0x00000001
#define NAND_ECC_BCH8_MODE				0x00000002
#define NAND_ECC_BCH12_MODE				0x00000003
#define NAND_ECC_BCH16_MODE				0x00000004
#define NAND_ECC_BCH24_MODE				0x00000005
#define NAND_TWO_PLANE_MODE				0x00000010
#define NAND_TIMING_MODE0				0x00000000
#define NAND_TIMING_MODE1				0x00000100
#define NAND_TIMING_MODE2				0x00000200
#define NAND_TIMING_MODE3				0x00000300
#define NAND_TIMING_MODE4				0x00000400
#define NAND_TIMING_MODE5				0x00000500
#define NAND_INTERLEAVING_MODE			0x00010000

#define NAND_DEFAULT_OPTIONS			(NAND_TIMING_MODE5 | NAND_ECC_BCH8_MODE)

#define AML_NAND_BUSY_TIMEOUT			0x4000
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

	struct mtd_info*		mtd;/* point to base nand_info_t nand_info[] */
	struct nand_chip		chip;

	/* platform info */
	struct aml_nand_platform	*platform;

	/* device info */
	struct device			*device;

	//plateform operation function
	void	(*aml_nand_hw_init)(struct aml_nand_chip *aml_chip);
	int		(*aml_nand_options_confirm)(struct aml_nand_chip *aml_chip);
	void 	(*aml_nand_cmd_ctrl)(struct aml_nand_chip *aml_chip, int cmd,  unsigned int ctrl);
	void	(*aml_nand_select_chip)(struct aml_nand_chip *aml_chip, int chipnr);
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

		 unsigned char			   *aml_nand_data_buf;			//data buf size is page_size*plane_number*nr_chips
         struct platform_nand_data platform_nand_data;
};

struct aml_nand_device {
	struct aml_nand_platform *aml_nand_platform;
	u8 dev_num;
};

/*
 * Conversion functions
 */
#define container_of(ptr, type, member) ({			\
	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
	(type *)( (char *)__mptr - offsetof(type,member) );})
static inline struct aml_nand_chip *mtd_to_nand_chip(struct mtd_info *mtd)
{
	/* cannot use mtd to get aml_nand_chip since it may get from nand_info[x] */
	/* use chip member to get aml_nand_chip pointer */
	struct nand_chip* chip =	(struct nand_chip*)mtd->priv;
	return container_of(chip,struct aml_nand_chip,chip);
	//return container_of(mtd, struct aml_nand_chip, mtd);
}

static void inline  nand_get_chip(void )
{
	/* enable nand pinmux */
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x1f5);
	/* disable spi boot pinmux */
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<30) | (1<<28) | (1<<26) | (1<<24)));
	/* disable spi pinmux */
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<29) | (1<<27) | (1<<25) | (1<<23)));
	/* disable sdio pinmux */
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_7, ((1<<29) | (1<<28) | (1<<27) | (1<<26) | (1<<25) | (1<<24)));
}
static void inline nand_release_chip(void)
{	
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x7fff);
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_1, ((1<<30) | (1<<28) | (1<<26) | (1<<24)));
}

extern int aml_nand_init(struct aml_nand_chip *aml_chip);

#endif // AML_NAND_H_INCLUDED

