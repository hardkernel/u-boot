#ifndef AMLNAND_PHYDEV_H_INCLUDED
#define AMLNAND_PHYDEV_H_INCLUDED

#include "amlnf_dev.h"

/***nand CE/RB pinmux setting***/
#define 	AML_NAND_CE0         				0xe
#define 	AML_NAND_CE1         				0xd
#define 	AML_NAND_CE2         				0xb
#define 	AML_NAND_CE3         				0x7

#define 	CE_PAD_DEFAULT				((AML_NAND_CE0) | (AML_NAND_CE1 << 4) | (AML_NAND_CE2 << 8) | (AML_NAND_CE3 << 12))
//#define 	RB_PAD_DEFAULT				((AML_NAND_CE0) | (AML_NAND_CE1 << 4))	
#define 	RB_PAD_DEFAULT				(AML_NAND_CE0)	
#define 	MAX_CHIP_NUM							4

#define 	PER_INFO_BYTE 						8

/***nand device option***/
#define	DEV_SLC_MODE						(1<<0)
#define	DEV_SERIAL_CHIP_MODE				(0<<1)
#define	DEV_MULTI_CHIP_MODE				(1<<1)

#define 	DEV_MULTI_PLANE_MODE				(1<<2)
#define 	DEV_SINGLE_PLANE_MODE				(0<<2)

#define 	DEV_ECC_SOFT_MODE					(1<<3)
#define 	DEV_ECC_HW_MODE					(0<<3)

#define 	NAND_CODE_OPTION			(DEV_MULTI_PLANE_MODE |DEV_MULTI_CHIP_MODE)
#define  	NAND_DATA_OPTION			(DEV_MULTI_PLANE_MODE | DEV_MULTI_CHIP_MODE)

/*
 * Status for nand chip
 */
typedef enum {
	CHIP_READY,
	CHIP_STATUS,
	CHIP_ERASING,
	CHIP_ERASE_SUSPENDING,
	CHIP_ERASE_SUSPENDED,
	CHIP_WRITING,
	CHIP_WRITE_SUSPENDING,
	CHIP_WRITE_SUSPENDED,
	CHIP_PM_SUSPENDED,
	CHIP_SYNCING,
	CHIP_UNLOADING,
	CHIP_LOCKING,
	CHIP_UNLOCKING,
	CHIP_POINT,
	CHIP_SHUTDOWN,
	CHIP_READING,
	CHIP_RESETING,
	CHIP_PREPARING_ERASE,
	CHIP_VERIFYING_ERASE,
	CHIP_UNKNOWN
} chip_state_t;


#ifdef AML_NAND_UBOOT

static void inline  nand_get_chip(void )
{

#ifdef CONFIG_NAND_AML_M8
	// pull up enable
	   SET_CBUS_REG_MASK(PAD_PULL_UP_EN_REG2, 0x84ff);
	// pull direction, dqs pull down
	   SET_CBUS_REG_MASK(PAD_PULL_UP_REG2, 0x0400);
	   SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, ((0x3ff<<18) | (1<<17)));
#else
	SET_CBUS_REG_MASK(PREG_PAD_GPIO3_EN_N, 0x3ffff);
	SET_CBUS_REG_MASK(PAD_PULL_UP_REG3, (0xff | (1<<16)));
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_5, ((1<<7) | (1 << 8) | (1 << 9)));
	SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, ((0xf<<18) | (1 << 17) | (0x3 << 25)));
#endif	
	
}
static void inline nand_release_chip(void)
{
#ifdef CONFIG_NAND_AML_M8
	CLEAR_CBUS_REG_MASK(PAD_PULL_UP_REG2, 0x0400);
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, ((0x3ff<<18) | (1<<17)));
#else
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_5, ((1<<7) | (1 << 8) | (1 << 9)));
	CLEAR_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, ((0x3fF<<18) | (0X3 << 16)));
#endif
}

#endif

extern int nandphy_init(unsigned flag);
extern int set_nphy_dma_addr(unsigned count, unsigned len, unsigned char *data_buf, unsigned int *usr_buf);
extern unsigned char nandphy_readb(void);
extern int amlphy_prepare(unsigned flag);
#endif
