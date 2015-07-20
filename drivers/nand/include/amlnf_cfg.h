#ifndef __AML_NF_CFG_H__
#define __AML_NF_CFG_H__

/*************stage***************/
#define	AML_NAND_UBOOT	//For uboot
#define EXPORT_SYMBOL(...)
/**************PHY****************/
#define	AML_SLC_NAND_SUPPORT
#define	AML_MLC_NAND_SUPPORT


#define	AML_NAND_DBG				(0)
#define	AML_CFG_INSIDE_PARTTBL		(0)
#define AML_CFG_2PLANE_READ_EN		(1)
/* support nand with readretry&e-slc */
#define	AML_CFG_NEW_NAND_SUPPORT	(1)
/* new oob mode */
#define AML_CFG_NEWOOB_EN			(1)
/* store dtd in rsv area! */
#define AML_CFG_DTB_RSV_EN			(1)
/* store key in rsv area */
#define AML_CFG_KEY_RSV_EN			(1)

#define NAND_ADJUST_PART_TABLE

#ifdef NAND_ADJUST_PART_TABLE
#define	ADJUST_BLOCK_NUM	4
#else
#define	ADJUST_BLOCK_NUM	0
#endif

/*do not use rb irq under uboot*/
/* #define AML_NAND_RB_IRQ */

/*
#define AML_NAND_DMA_POLLING
*/

extern  int is_phydev_off_adjust(void);
extern  int get_adjust_block_num(void);

#endif //__AML_NF_CFG_H__
