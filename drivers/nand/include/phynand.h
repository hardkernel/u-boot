#ifndef PHYNAND_H_INCLUDED
#define PHYNAND_H_INCLUDED

#include "../include/amlnf_dev.h"

#ifndef AML_NAND_UBOOT

#include <linux/pinctrl/consumer.h>
#include <linux/amlogic/cpu_version.h>
#include <linux/io.h>
#endif /*AML_NAND_UBOOT*/
/* #define CONFIG_OF */

#define NAND_COMPATIBLE_REGION	1
#define NAND_RESERVED_REGION	1
#define NAND_ADDNEW_REGION	1
#define NAND_BUG_FIX_REGION	6

#define DRV_PHY_VERSION	 ((NAND_COMPATIBLE_REGION << 24) + \
			(NAND_RESERVED_REGION << 16) + \
			(NAND_ADDNEW_REGION << 8) + \
			(NAND_BUG_FIX_REGION))

#define NAND_MFR_USER          0x100
#define NAND_MFR_EFUSE         0x101

/* #define abs(value) (((value) < 0) ? ((value)*-1) : (value)) */

/* -------must same with nand.h------ */
/*
 ** Max page list cnt for usrdef mode
*/
#define NAND_PAGELIST_CNT		16
typedef struct nand_setup {
    union {
        uint32_t d32;
        struct {
            unsigned cmd:22;
            unsigned large_page:1; // 22
            unsigned no_rb:1;      // 23 from efuse
            unsigned a2:1;         // 24
            unsigned reserved25:1; // 25
            unsigned page_list:1;  // 26
            unsigned sync_mode:2;  // 27 from efuse
            unsigned size:2;       // 29 from efuse
            unsigned active:1;     // 31
        } b;
    } cfg;
    uint16_t id;
    uint16_t max; // id:0x100 user, max:0 disable.
} nand_setup_t;

typedef struct _nand_cmd{
    unsigned char type;
    unsigned char val;
} nand_cmd_t;

typedef struct _ext_info{
	uint32_t read_info;		//nand_read_info;
	uint32_t new_type;		//new_nand_type;
	uint32_t page_per_blk;	//pages_in_block;
	uint32_t xlc;			//slc=1, mlc=2, tlc=3.
	uint32_t ce_mask;
	uint32_t boot_num;
	uint32_t each_boot_pages;
	uint32_t rsv[2];
	/* add new below, */
} ext_info_t;

typedef struct _nand_page0 {
	nand_setup_t nand_setup;		//8
	unsigned char page_list[NAND_PAGELIST_CNT]; 	//16
	nand_cmd_t retry_usr[32];		//64 (32 cmd max I/F)
	ext_info_t ext_info;			//64
} nand_page0_t;	//384 bytes max.
/* --------------------------------------------------- */
union nand_core_clk_t {
	/* raw register data */
	u32 d32;
	/*register bits */
	struct {
		u32 clk_div:7;
		u32 reserved0:1;
		u32 clk_en:1;
		u32 clk_sel:3;
		u32 not_used:20;
	} b;
};


/***************ERROR CODING*******************/
#define NAND_CHIP_ID_ERR            1
#define NAND_SHIP_BAD_BLOCK_ERR     2
#define NAND_CHIP_REVB_HY_ERR       3

/*
 * NAND Flash Manufacturer ID Codes
 */
#define NAND_MFR_TOSHIBA	0x98
#define NAND_MFR_SAMSUNG	0xec
#define NAND_MFR_FUJITSU	0x04
#define NAND_MFR_NATIONAL	0x8f
#define NAND_MFR_RENESAS	0x07
#define NAND_MFR_STMICRO	0x20
#define NAND_MFR_HYNIX		0xad
#define NAND_MFR_MICRON		0x2c
#define NAND_MFR_AMD		0x01
#define NAND_MFR_INTEL		0x89
#define NAND_MFR_SANDISK	0x45


/***nand runing status***/
#define NAND_STATUS_NORMAL	0
#define NAND_STATUS_UNUSUAL	1


#define NAND_STATUS_MAX_TRY	6
#define	NAND_STATUS_FAILED	0xe1
#define	NAND_STATUS_RIGHT	0xe0

#define	BYTES_OF_USER_PER_PAGE	16

#define ADJUST_PART_SIZE	10
#define ADJUST_SIZE_NFTL	8

#define	SHIPPED_BBT_HEAD_MAGIC	"fbbt"
#define	BBT_HEAD_MAGIC			"nbbt"
#define	CONFIG_HEAD_MAGIC		"ncnf"
#define	HYNIX_DEV_HEAD_MAGIC	"nhix"
#define	KEY_INFO_HEAD_MAGIC		"nkey"
#define	SECURE_INFO_HEAD_MAGIC	"nsec"
#define	ENV_INFO_HEAD_MAGIC		"nenv"
#define	DTD_INFO_HEAD_MAGIC		"ndtb"
#define	PHY_PARTITION_HEAD_MAGIC	"phyp"

#define	FBBT_COPY_NUM	1

/* 128k */
#define CONFIG_SECURE_SIZE	(0x10000*2)
/*fixme, arguing...*/
#define SECURE_SIZE (CONFIG_SECURE_SIZE - (sizeof(u32)))

/* 256KBytes. */
//#define CONFIG_DTB_MAXIMUM_SIZE  (256*1024U)
//#define DTB_SIZE (CONFIG_DTB_SIZE - (sizeof(u32)))

#define FULL_BLK	0
#define FULL_PAGE	1

#define	MAX_BAD_BLK_NUM			    2048
#define	MAX_SHIPPED_BAD_BLK_NUM		512
#define	MAX_BLK_NUM			        8192
#define	RESERVED_BLOCK_CNT		    48

/* nand parameter for read retry, or fulture */
#define	NANS_PARA_BLOCK_CNT		1

/* for shipped bbt block, short mode, full block, never update */
/* common bbt table, rarely update */
#define	BBT_BLOCK_CNT			2
/* shipped bbt table, just only one copy first detect */
#define	SHIPPED_BBT_BLOCK_CNT		1
/* config block, short mode, full block, if update, erase whole block */
#define	CONFIG_BLOCK_CNT	1
#define	KEY_BLOCK_CNT		4

/***uboot code***/
#define	BOOT_COPY_NUM		4
#define	BOOT_PAGES_PER_COPY	256

#define	MAX_CYCLE_NUM		20

/***nand chip options***/
#define	NAND_CTRL_FORCE_WP		(1<<0)

/***nand controller options***/
#define	NAND_CTRL_NONE_RB		(1<<1)
#define	NAND_CTRL_INTERLEAVING_MODE	(1<<2)
#define	NAND_MULTI_PLANE_MODE		(1<<3)


/***nand controller ECC options***/
#define	MAX_ECC_MODE_NUM		16
#define	NAND_ECC_TYPE_MASK		(0xf<<4)

#define	NAND_ECC_SOFT_MODE		(0x0<<4)
#define	NAND_ECC_SHORT_MODE		(0x1<<4)
#define	NAND_ECC_BCH9_MODE		(0x2<<4)
#define	NAND_ECC_BCH8_MODE		(0x3<<4)
#define	NAND_ECC_BCH12_MODE		(0x4<<4)
#define	NAND_ECC_BCH16_MODE		(0x5<<4)
#define	NAND_ECC_BCH8_1K_MODE		(0x6<<4)
#define	NAND_ECC_BCH16_1K_MODE		(0x7<<4)
#define	NAND_ECC_BCH24_1K_MODE		(0x8<<4)
#define	NAND_ECC_BCH30_1K_MODE		(0x9<<4)
#define	NAND_ECC_BCH40_1K_MODE		(0xa<<4)
#define	NAND_ECC_BCH50_1K_MODE		(0xb<<4)
#define	NAND_ECC_BCH60_1K_MODE		(0xc<<4)


	/***FOR NAND CHIP TYPES ***/
#define	NAND_CHIP_TYPE_MASK		(0x3<<9)

#define	NAND_CHIP_TYPE_MLC		(0x0<<9)
#define	NAND_CHIP_TYPE_SLC		(0x1<<9)
#define	NAND_CHIP_TYPE_TLC		(0x2<<9)

#define	NAND_CHIP_AYSNC_MODE		(0x0<<12)
#define	NAND_CHIP_TOGGLE_MODE		(0x1<<12)
#define	NAND_CHIP_SLC_MODE		(0x1<<13)


	/***FOR TIMMING MODE ***/

#define	NAND_TIMING_MODE0		(0x0)
#define	NAND_TIMING_MODE1		(0x1)
#define	NAND_TIMING_MODE2		(0x2)
#define	NAND_TIMING_MODE3		(0x3)
#define	NAND_TIMING_MODE4		(0x4)
#define	NAND_TIMING_MODE5		(0x5)


#define	NAND_DEFAULT_OPTIONS	(NAND_CTRL_NONE_RB | NAND_ECC_SHORT_MODE)

#define	DEFAULT_T_REA		20
#define	DEFAULT_T_RHOH		25

/***FOR ECC ***/
#define	NAND_ECC_UNIT_SIZE		512
#define	NAND_ECC_UNIT_1KSIZE		1024
#define	NAND_ECC_UNIT_SHORT		384

#define	NAND_BCH9_ECC_SIZE		15
#define	NAND_BCH8_ECC_SIZE		14
#define	NAND_BCH12_ECC_SIZE		20
#define	NAND_BCH16_ECC_SIZE		26
#define	NAND_BCH8_1K_ECC_SIZE		14
#define	NAND_BCH16_1K_ECC_SIZE		28
#define	NAND_BCH24_1K_ECC_SIZE		42
#define	NAND_BCH30_1K_ECC_SIZE		54
#define	NAND_BCH40_1K_ECC_SIZE		70
#define	NAND_BCH50_1K_ECC_SIZE		88
#define	NAND_BCH60_1K_ECC_SIZE		106

/* 1uS , about 8mS */
#define	AML_NAND_READ_BUSY_TIMEOUT	0x2000
/* 1uS, about 20mS */
#define	AML_NAND_WRITE_BUSY_TIMEOUT	0x5000
/* 1uS, about 40mS */
#define	AML_NAND_ERASE_BUSY_TIMEOUT	0xa000


#define	AML_DMA_BUSY_TIMEOUT	0x100000

#define	MAX_ID_LEN		8

#define	NAND_TYPE_MLC		0
#define	NAND_TYPE_SLC		1
#define	NAND_TYPE_TLC		2

#define	NAND_TWB_TIME_CYCLE	10
#define	NAND_TWHR_TIME_CYCLE	20
#define	NAND_TADL_TIME_CYCLE	20
#define	NAND_TCCS_TIME_CYCLE	20
#define	NAND_TRHW_TIME_CYCLE	20


#ifdef AML_NAND_RB_IRQ
#define NAND_CHIP_UNDEFINE	200
#endif

#ifdef AML_NAND_RB_IRQ
#define DMA_TIME_CNT_220US	220000
#define DMA_TIME_CNT_20US	20000
#endif

/*
#define	NAND_TWHR2_TIME_CYCLE	20
*/

/*
 * Constants for hardware specific CLE/ALE/NCE function
 *
 * These are bits which can be or'ed to set/clear multiple
 * bits in one go.
 */
/* Select the chip by setting nCE to low */
#define	NAND_NCE	0x01
/* Select the command latch by setting CLE to high */
#define	NAND_CLE	0x02
/* Select the address latch by setting ALE to high */
#define	NAND_ALE	0x04


#define	NAND_CTRL_CLE	(NAND_NCE | NAND_CLE)
#define	NAND_CTRL_ALE	(NAND_NCE | NAND_ALE)

/*
 * Standard NAND flash commands
 */
#define	NAND_CMD_READ0		0x00
#define	NAND_CMD_READ1		0x01
#define	NAND_CMD_RNDOUT		0x05
#define	NAND_CMD_PAGEPROG	0x10
#define	NAND_CMD_READOOB	0x50
#define	NAND_CMD_ERASE1		0x60
#define	NAND_CMD_STATUS		0x70
#define	NAND_CMD_STATUS_MULTI	0x71
#define	NAND_CMD_SEQIN		0x80
#define	NAND_CMD_RNDIN		0x85
#define	NAND_CMD_READID		0x90
#define	NAND_CMD_ERASE2		0xd0
#define	NAND_CMD_PARAM		0xec
#define	NAND_CMD_RESET		0xff

#define	NAND_CMD_ID_ADDR_NORMAL	0x00
#define	NAND_CMD_ID_ADDR_ONFI	0x20


#define	NAND_CMD_NONE	-1


#define	NAND_CMD_LOCK		0x2a
#define	NAND_CMD_UNLOCK1	0x23
#define	NAND_CMD_UNLOCK2	0x24

/*
  *Extended common NAND CMD
  *
*/
#define	NAND_CMD_PLANE2_READ_START	0x06
#define	NAND_CMD_TWOPLANE_PREVIOS_READ	0x60
#define	NAND_CMD_TWOPLANE_READ1		0x5a
#define	NAND_CMD_TWOPLANE_READ2		0xa5
#define	NAND_CMD_TWOPLANE_WRITE2_MICRO	0x80
#define	NAND_CMD_TWOPLANE_WRITE2	0x81
#define	NAND_CMD_DUMMY_PROGRAM		0x11
#define	NAND_CMD_ERASE1_END		0xd1
#define	NAND_CMD_MULTI_CHIP_STATUS	0x78
#define	NAND_CMD_SET_FEATURES		0xEF
#define	NAND_CMD_GET_FEATURES		0xEE
#define	NAND_CMD_READSTART		0x30
#define	NAND_CMD_RNDOUTSTART		0xE0
#define	NAND_CMD_CACHEDPROG		0x15

#define	ONFI_TIMING_ADDR		0x01
#define	NAND_STATUS_READY_MULTI		0x20

/* Status bits */
#define	NAND_STATUS_FAIL	0x01
#define	NAND_STATUS_FAIL_N1	0x02
#define	NAND_STATUS_TRUE_READY	0x20
#define	NAND_STATUS_READY	0x40
#define	NAND_STATUS_WP		0x80

#if (AML_CFG_NEW_NAND_SUPPORT)
#define	RETRY_NAND_MAGIC	"refv"
#define	RETRY_NAND_BLK_NUM	2
#define	RETRY_NAND_COPY_NUM	4

#define	READ_RETRY_REG_NUM	8
#define	READ_RETRY_CNT      40

#define	EN_SLC_REG_NUM		8

#define	READ_RETRY_ZERO		((char)-1)

#define	NAND_CMD_HYNIX_GET_VALUE		0x37
#define	NAND_CMD_HYNIX_SET_VALUE_START		0x36
#define	NAND_CMD_HYNIX_SET_VALUE_END		0x16

#define	NAND_CMD_TOSHIBA_PRE_CON1		0x5c
#define	NAND_CMD_TOSHIBA_PRE_CON2		0xc5
#define	NAND_CMD_TOSHIBA_SET_VALUE		0x55
#define	NAND_CMD_TOSHIBA_BEF_COMMAND0		0xB3
#define	NAND_CMD_TOSHIBA_BEF_COMMAND1		0x26
#define	NAND_CMD_TOSHIBA_BEF_COMMAND2		0x5d
#define NAND_CMD_SAMSUNG_SET_VALUE		0XA1
#define NAND_CMD_MICRON_SET_VALUE		0XEF
#define	NAND_CMD_SANDISK_INIT_ONE		0x3B
#define	NAND_CMD_SANDISK_INIT_TWO		0xB9

#define	NAND_CMD_SANDISK_LOAD_VALUE_ONE		0x53
#define	NAND_CMD_SANDISK_LOAD_VALUE_TWO		0x54

#define	NAND_CMD_SANDISK_DYNAMIC_ENABLE		0xB6
#define	NAND_CMD_SANDISK_DYNAMIC_DISABLE	0xD6
#define	NAND_CMD_SANDISK_SLC			0xA2
#define NAND_CMD_SANDISK_SET_VALUE		0XEF
#define	NAND_CMD_SANDISK_DSP_OFF	0x25
#define	NAND_CMD_SANDISK_DSP_ON		0x26
#define	NAND_CMD_SANDISK_RETRY_STA	0x5D
#define	NAND_CMD_SANDISK_TEST_MODE1	0x5c
#define	NAND_CMD_SANDISK_TEST_MODE2	0xc5
#define	NAND_CMD_SANDISK_TEST_MODE_ACCESS 0x55
/* for hynix 20nm OTP */
#define	HYNIX_OTP_COPY		8
#define	HYNIX_OTP_LEN		528

/* for Hynix */
#define	HYNIX_26NM_4GB		1
#define	HYNIX_26NM_8GB		2
#define	HYNIX_20NM_4GB		3
#define	HYNIX_20NM_8GB		4
#define	HYNIX_1YNM			6
/* for Toshiba */
#define	TOSHIBA_2XNM		20
/* TC58NVG6D2GTA00 */
#define	TOSHIBA_A19NM		21
#define	TOSHIBA_15NM		22

/* for SAMSUNG */
#define	SUMSUNG_2XNM		30

/* for SANDISK */
#define	SANDISK_19NM		40
#define	SANDISK_24NM		41
#define	SANDISK_A19NM		42
#define	SANDISK_A19NM_4G	53

/* for Intel */
#define	INTEL_20NM	60
/* for Micron */
#define	MICRON_20NM	50

struct hw_controller;
struct read_retry_info {
	u8 flag;
	u8 default_flag;
	u8 info_save_blk;

	u8 reg_cnt_lp;
	u8 reg_cnt_up;
	u8 reg_cnt_tp;

	u8 retry_cnt_lp;
	u8 retry_cnt_up;
	u8 retry_cnt_tp;
    u8 retry_stage;

	u8 cur_cnt_lp[MAX_CHIP_NUM];
	u8 cur_cnt_up[MAX_CHIP_NUM];
	u8 cur_cnt_tp[MAX_CHIP_NUM];

	u8 reg_addr_lp[READ_RETRY_REG_NUM];
	u8 reg_addr_up[READ_RETRY_REG_NUM];
	u8 reg_addr_tp[READ_RETRY_REG_NUM];

	u8 reg_def_val[MAX_CHIP_NUM][READ_RETRY_REG_NUM];

	u8 reg_offs_val_lp[MAX_CHIP_NUM][READ_RETRY_CNT][READ_RETRY_REG_NUM];
	u8 reg_offs_val_up[MAX_CHIP_NUM][READ_RETRY_CNT][READ_RETRY_REG_NUM];
	u8 reg_offs_val_tp[MAX_CHIP_NUM][READ_RETRY_CNT][READ_RETRY_REG_NUM];

	int (*init)(struct hw_controller *controller);
	int (*handle)(struct hw_controller *controller, u8 chipnr);
	int (*exit)(struct hw_controller *controller, u8 chipnr);
};

struct en_slc_info {
	u8 flag;
	u8 *pagelist;
	u8 reg_cnt;
	u8 reg_addr[EN_SLC_REG_NUM];
	u8 reg_def_val[MAX_CHIP_NUM][EN_SLC_REG_NUM];
	char reg_offs_val[EN_SLC_REG_NUM];
	int (*init)(struct hw_controller *controller);
	int (*enter)(struct hw_controller *controller);
	int (*exit)(struct hw_controller *controller);
};

#endif

#define ECC_INFORMATION(name_a, bch_a, size_a, parity_a, user_a, index_a) \
	{\
		.name = name_a,\
		.mode = bch_a,\
		.unit_size = size_a,\
		.bytes = parity_a,\
		.usr_mode = user_a,\
		.bch_index = index_a\
	}

struct bch_desc {
	char *name;
	u32 mode;
	u32 unit_size;
	u32 bytes;
	u32 usr_mode;
	u32 bch_index;
};


/*** HW controller configuration ***/
struct hw_controller {
	u32 chip_selected;
	u32 rb_received;
	u32 ce_enable[MAX_CHIP_NUM];
	u32 rb_enable[MAX_CHIP_NUM];

	u8 chip_num;
	u8 flash_type;
	u8 mfr_type;
	u32 onfi_mode;

	 /* zero means no short */
	u16 short_pgsz;

	u8 max_bch;

	u16 ecc_unit;
	u16 ecc_bytes;
	u16 ecc_steps;

	u16 oobtail;

	u8 bch_mode;
	u8 user_mode;
	u8 ran_mode;
	u8 oobavail;
	u8 oob_mod;
	int oob_fill_data;
	int oob_fill_boot;
	u8 ecc_cnt_limit;
	u8 ecc_cnt_cur;
	u8 ecc_max;

	u16 page_shift;
	u16 block_shift;

	u32 internal_page_nums;
	u32 zero_cnt;

	u32 page_addr;

	u32 option;

	u8 *data_buf;
	u32 *user_buf;

	u8 *page_buf;
	u8 *oob_buf;

#if (AML_CFG_NEW_NAND_SUPPORT)
	struct en_slc_info slc_info;
	struct read_retry_info retry_info;
#endif

	dma_addr_t data_dma_addr;
	dma_addr_t info_dma_addr;

	void __iomem *reg_base;
	void __iomem *nand_clk_reg;
	u32 irq;

	struct bch_desc *bch_desc;

#ifdef AML_NAND_DMA_POLLING
	struct hrtimer timer;
#endif

#if 0/* #ifndef AML_NAND_UBOOT */
	struct hw_ctrl hw_ctrl;
#endif
	struct amlnand_chip *aml_chip;

	/*** hw controller operation function ***/
	int (*init)(struct hw_controller *controller);
	int (*adjust_timing)(struct hw_controller *controller);
	int (*select_chip)(struct hw_controller *controller,
		u8 chipnr);
	int (*ecc_confirm)(struct hw_controller *controller);
	u8 (*readbyte)(struct hw_controller *controller);
	void (*writebyte)(struct hw_controller *controller,
		u8 data);
	void (*cmd_ctrl)(struct hw_controller *controller,
		u32 cmd,
		u32 ctrl);
	int (*quene_rb)(struct hw_controller *controller, u8 chipnr);
#ifdef AML_NAND_RB_IRQ
	int (*quene_rb_irq)(struct hw_controller *controller,
		u8 chipnr);
#endif
	int (*dma_read)(struct hw_controller *controller,
		u32 len,
		u8 bch_mode);
	int (*dma_write)(struct hw_controller *controller,
		u8 *buf,
		u32 len,
		u8 bch_mode);
	int (*hwecc_correct)(struct hw_controller *controller,
		u32 size,
		u8 *oob_buf);

	void (*get_usr_byte)(struct hw_controller *controller,
		u8 *oob_buf,
		u8 byte_num);
	void (*set_usr_byte)(struct hw_controller *controller,
		u8 *oob_buf,
		u8 byte_num);
	void (*enter_standby)(struct hw_controller *controller);

};

/*** nand chip operation function ***/
struct chip_operation {
	int (*check_wp)(struct amlnand_chip *aml_chip);

	int (*get_onfi_para)(struct amlnand_chip *aml_chip,
		u8 *buf,
		int addr);
	int (*set_onfi_para)(struct amlnand_chip *aml_chip,
		u8 *buf,
		int addr);

	int (*reset)(struct amlnand_chip *aml_chip, u8 chip_nr);
	int (*read_id)(struct amlnand_chip *aml_chip,
		u8 chip_nr,
		u8 id_addr,
		u8 *buf);

	/*
	 * Erase is an asynchronous operation.  Device drivers are supposed
	 * to call instr->callback() whenever the operation completes, even
	 * if it completes with a failure.
	 * Callers are supposed to pass a callback function and wait for it
	 * to be called before writing to the block.
	*/
	int (*erase_block)(struct amlnand_chip *aml_chip);
	int (*test_block_chip_op)(struct amlnand_chip *aml_chip);
	int (*test_block_reserved)(struct amlnand_chip *aml_chip, int tst_blk);
	/***basic data operation and included oob data****/
	int (*read_page)(struct amlnand_chip *aml_chip);
	int (*write_page)(struct amlnand_chip *aml_chip);

	int (*block_isbad)(struct amlnand_chip *aml_chip);
	int (*block_markbad)(struct amlnand_chip *aml_chip);

	int (*blk_modify_bbt_chip_op)(struct amlnand_chip *aml_chip, int value);
	int (*update_bbt_chip_op)(struct amlnand_chip *aml_chip);
};

/*** basic nand flash information  ***/
struct nand_flash {
	char *name;
	u8 id[MAX_ID_LEN];

	u32 pagesize;
	u32 chipsize;
	u32 blocksize;
	u32 oobsize;

	u8 internal_chipnr;
	u8 T_REA;
	u8 T_RHOH;
	u8 onfi_mode;
	u8 new_type;

	u32 option;
};

/*
*operation type as below: oob_mode data_buf oob_buf readlen
*1) read data hw ecc mode 0 available NULL 0
*2) read oob hw ecc mode 0 NULL available available
*3) read data and oob hw ecc mode 0 available available available
*4) read data/oob none ecc mode 1 available NULL available
*
* option chipnr page_addr
*mulit-chip 0
*serial-chip available
*multi-plane
*sigle-plane
*/
struct chip_ops_para {
	u32 page_addr;
	u8 chipnr;
	u8 *data_buf;
	u8 *oob_buf;
	enum oob_modes_t oob_mode;
	u8 bit_flip;
	u8 ecc_err;
	/*
	only for read oob mode, for chip operation,
	read data should be one entire page, but oob mode not.
	*/
	u8 ooblen;
	u32 option;
};


/**
 * struct platform_nand_chip - chip level device structure
 * @nr_chips:		max. number of chips to scan for
 * @chip_offset:	chip number offset
 * @nr_partitions:	number of partitions pointed to by partitions (or zero)
 * @partitions:		mtd partition list
 * @options:		Option flags, e.g. 16bit buswidth
 * @priv:		hardware controller specific settings
 */
struct dev_para {
	const char name[MAX_DEVICE_NAME_LEN];

	u64 offset;
	u64 size;
	struct amlnf_partition partitions[MAX_NAND_PART_NUM];
	u8 nr_partitions;

	u32 option;
};

struct _phy_partition {
	const char name[MAX_DEVICE_NAME_LEN];
	uint64_t phy_off;
	uint64_t phy_len;
    uint64_t logic_len;
};

struct phy_partition_info {
	unsigned int crc;
	struct _phy_partition partition[MAX_DEVICE_NUM];
	unsigned char dev_num;
};

#if (AML_CFG_INSIDE_PARTTBL)
#define MAX_PART_NUM	16
#define PART_NAME_LEN 16
struct partitions {
	/* identifier string */
	char name[PART_NAME_LEN];
	/* partition size, byte unit */
	u64 size;
	/* offset within the master space, byte unit */
	u64 offset;
	/* master flags to mask out for this partition */
	u32 mask_flags;
	/* for memcpy  align */
	//void *priv;
};
#endif /* AML_CFG_INSIDE_PARTTBL */

struct nand_config {
	u32 crc;
	struct dev_para dev_para[MAX_DEVICE_NUM];
	u32 driver_version;
	u8 dev_num;
	u16 fbbt_blk_addr;
};

struct nand_bbt {
	u16 nand_bbt[MAX_CHIP_NUM][MAX_BAD_BLK_NUM];
};

struct shipped_bbt {
	u32 crc;
    u32 chipnum;
	u16 shipped_bbt[MAX_CHIP_NUM][MAX_BAD_BLK_NUM];
};

struct nand_menson_key {
	u32 crc;
	u8 data[252];
};

/* typedef struct nand_menson_key meson_key; */	/* fixme, */

struct secure_t {
	/* CRC32 over data bytes */
	u32 crc;
	/* Environment data */
	u8 data[SECURE_SIZE];
};

struct nand_arg_oobinfo {
	char name[4];
	u16 timestamp;
};

struct nand_arg_info {
	u8 arg_type;
	u16 valid_blk_addr;
	u16 valid_page_addr;
	u16 free_blk_addr;
	u8 arg_valid;
	u16 timestamp;
	/*
	flag indicate that: if read ecc error of any page of this block,
	should move data to another block
	*/
	u8 update_flag;
};

struct block_status {
	u32 crc;
	u16 blk_status[MAX_CHIP_NUM][MAX_BLK_NUM];
};

/**whole nand chip information  include hw controller and flash information **/
struct amlnand_chip {
	struct block_status *block_status;

	enum chip_state_t state;
	u8 nand_status;
	u8 init_flag;
	u8 key_protect;
	u8 secure_protect;
	u8 fbbt_protect;
	u8 ce_bit_mask;
	struct hw_controller controller;

	/* current operation parameter, should clear before used. */
	struct chip_ops_para ops_para;

	struct chip_operation operation;
	struct nand_flash flash;

	struct nand_arg_info config_msg;
	struct nand_config *config_ptr;
	struct phy_partition_info *phy_part_ptr;

	struct nand_arg_info nand_bbtinfo;
	struct nand_arg_info shipped_bbtinfo;
	struct shipped_bbt *shipped_bbt_ptr;

	struct nand_arg_info nand_key;
	struct nand_arg_info nand_secure;
	struct nand_arg_info uboot_env;
	struct nand_arg_info  nand_phy_partition;
#if (AML_CFG_DTB_RSV_EN)
	struct nand_arg_info amlnf_dtb;
	u32 detect_dtb_flag;	/*1:no dtb in flash */
#endif
#ifndef AML_NAND_UBOOT
	struct pinctrl *nand_pinctrl;
	struct pinctrl_state *nand_pinstate;
	struct pinctrl_state *nand_rbstate;
	struct pinctrl_state *nand_norbstate;
	struct pinctrl_state *nand_idlestate;
	struct device			device;
#endif /* AML_NAND_UBOOT */
	u8 reserved_blk[RESERVED_BLOCK_CNT];
	u32 max_ecc_per_page;
	u8 *user_page_buf;
	u8 *user_oob_buf;
	u8 protect;
	u8 debug_flag;
	u8 g_retry_cnt;
#ifndef AML_NAND_UBOOT
	void __iomem *reg_base;
	void __iomem *nand_clk_reg;
#endif /*  */
	u8 shipped_retry_flag; /* do factory bad block detect less than 2 times*/

	u32 h_cache_dev;
	u32 keysize;
	u32 dtbsize;
};

extern struct nand_flash flash_ids_slc[];
extern struct nand_flash flash_ids_mlc[];
extern struct bch_desc bch_list[MAX_ECC_MODE_NUM];
extern struct bch_desc bch_list_m8[MAX_ECC_MODE_NUM];
extern struct amlnand_chip *aml_chip_secure;
extern struct amlnand_chip *aml_nand_chip;

extern enum chip_state_t get_chip_state(struct amlnand_chip *aml_chip);
extern void set_chip_state(struct amlnand_chip *aml_chip,
	enum chip_state_t state);
extern int amlnand_get_device(struct amlnand_chip *aml_chip,
	enum chip_state_t new_state);
extern void amlnand_release_device(struct amlnand_chip *aml_chip);
extern int amlnand_hwcontroller_init(struct amlnand_chip *aml_chip);
extern int amlnand_init_operation(struct amlnand_chip *aml_chip);
extern int amlnand_get_dev_configs(struct amlnand_chip *aml_chip);
extern u32 amlnand_chip_init(struct amlnand_chip *aml_chip);
extern int amlnand_phydev_init(struct amlnand_chip *aml_chip);
extern int amlnand_update_bbt(struct amlnand_chip *aml_chip);
extern int amlnand_set_readretry_slc_para(struct amlnand_chip *aml_chip);
extern int aml_nand_scan_hynix_info(struct amlnand_chip *aml_chip);
extern int nand_reset(struct amlnand_chip *aml_chip, u8 chipnr);
extern void pinmux_select_chip(u32 ce_enable,
	u32 rb_enable,
	u32 flag);

extern int32_t nand_secure_read(struct amlnand_chip *aml_chip,
	char *buf,
	int len);
extern int32_t nand_secure_write(struct amlnand_chip *aml_chip,
	char *buf,
	int len);
extern int aml_sys_info_init(struct amlnand_chip *aml_chip);
extern void nand_boot_info_prepare(struct amlnand_phydev *phydev,
	u8 *page0_buf);
extern void uboot_set_ran_mode(struct amlnand_phydev *phydev);
extern void get_sys_clk_rate(struct hw_controller *controller, int *rate);
extern int aml_ubootenv_init(struct amlnand_chip *aml_chip);


extern void nand_get_chip(void *aml_chip);
extern void nand_release_chip(void *aml_chip);
extern int aml_key_init(struct amlnand_chip *aml_chip);
extern int aml_secure_init(struct amlnand_chip *aml_chip);
extern unsigned int aml_info_checksum(unsigned char *data, int lenth);
extern int amlnand_info_init(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *buf,
	u8 *name,
	u32 size);
extern int amlnand_check_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *name,
	u32 size);
extern int amlnand_save_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *buf,
	u8 *name,
	u32 size);
extern int amlnand_read_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *buf,
	u8 *name,
	u32 size);
extern int amlnand_erase_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *name);
extern int aml_sys_info_error_handle(struct amlnand_chip *aml_chip);
extern int aml_nand_update_key(struct amlnand_chip *aml_chip, char *key_ptr);
extern int aml_nand_update_secure(struct amlnand_chip *aml_chip,
	char *secure_ptr);
extern int aml_nand_update_ubootenv(struct amlnand_chip *aml_chip,
	char *env_ptr);

extern int aml_nand_update_dtb(struct amlnand_chip *aml_chip,
	char *dtb_ptr);

extern void amlchip_dumpinfo(struct amlnand_chip *aml_chip);

extern int bad_block_is_dtb_blk( const int blk_addr);
extern int get_last_reserve_block(struct amlnand_chip *aml_chip);
#endif /* NAND_H_INCLUDED */
