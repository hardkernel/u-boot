#ifndef __AML_NFTL_BLOCK_H
#define __AML_NFTL_BLOCK_H

#include "amlnf_type.h"
#include "hw_ctrl.h"
#include "amlnf_ctrl.h"
#include "amlnf_cfg.h"
#include<partition_table.h>

#define aml_nftl_dbg            aml_nand_dbg

	 
#define aml_nftl_malloc		aml_nand_malloc
#define aml_nftl_free		aml_nand_free


#define 	MAX_DEVICE_NUM				  		4
#define 	MAX_DEVICE_NAME_LEN				16


#define AMLNF_DEV_MAJOR			 250
#define TIMESTAMP_LENGTH         15
#define MAX_TIMESTAMP_NUM        ((1<<(TIMESTAMP_LENGTH-1))-1)
#define AML_NFTL_BOUNCE_SIZE	 		0x40000

#define NFTL_MAX_SCHEDULE_TIMEOUT		         1000
#define NFTL_FLUSH_DATA_TIME			         8
#define NFTL_CACHE_FORCE_WRITE_LEN               16


#define	FACTORY_BAD_BLOCK_ERROR		2
#define	BYTES_PER_SECTOR				512
#define	SHIFT_PER_SECTOR					9
#define	BYTES_OF_USER_PER_PAGE			16
#define	MIN_BYTES_OF_USER_PER_PAGE	16

#define	AMLNF_DEV_RO_MODE		(1<<0)

#define RET_YES                          1
#define RET_NO                           0

#define  PRINT aml_nftl_dbg

#define 	NAND_BLOCK_GOOD					0
#define 	NAND_BLOCK_USED_BAD				1
#define	NAND_BLOCK_FACTORY_BAD			2


#define 	MAX_NAND_PART_NUM					16
#define 	MAX_NAND_PART_NAME_LEN			16

#define 	NAND_PART_SIZE_FULL					-1

#define 	NAND_BLOCK_GOOD					0
#define 	NAND_BLOCK_USED_BAD				1
#define	NAND_BLOCK_FACTORY_BAD			2

/***nand device name***/
#define 	NAND_BOOT_NAME		  			"nfboot"
#define 	NAND_CACHE_NAME		  		"nfcache"
#define 	NAND_CODE_NAME	      	  			"nfcode"
#define 	NAND_DATA_NAME		  			"nfdata"
#define 	NAND_RESERVED_NAME  			"nfrevd"

#define	PHY_DEV_NUM		3			

/***nand BOOT flags***/
#define NAND_BOOT_NORMAL					0
#define NAND_BOOT_UPGRATE					1
#define NAND_BOOT_ERASE_PROTECT_CACHE         2
#define NAND_BOOT_ERASE_ALL   				3
#define NAND_BOOT_SCRUB_ALL				4


/****nand debug flag info******/
#define NAND_WRITE_VERIFY			1

#define DRV_AMLNFDEV_NAME	   		 "amlnfdev"
#define DRV_AMLNFDEV_AUTHOR	   	 "AMLOGIC SZ NAND TEAM"
#define DRV_AMLNFDEV_DESC	   		 "Amlogic Nand Flash driver"


struct amlnf_partition {
	char name[MAX_NAND_PART_NAME_LEN];			/* identifier string */
	uint64_t size;			/* partition size */
	uint64_t offset;		/* offset within the master space */
	unsigned mask_flags;		/* master flags to mask out for this partition */
};

typedef enum {
	NAND_SUCCESS						=0,
	NAND_CMD_FAILURE				=1,
	NAND_BUSY_FAILURE				=2,
	NAND_ID_FAILURE					=3,
	NAND_DMA_FAILURE 				=4,
	NAND_ECC_FAILURE				=5,
	NAND_BITFLIP_FAILURE			=6,
	NAND_MALLOC_FAILURE			=7,
	NAND_ARGUMENT_FAILURE 		=8,
	NAND_STATUS_FAILURE			=9,
	NAND_WP_FAILURE					=10,
	NAND_SELECT_CHIP_FAILURE		=12,
	NAND_ERASE_FAILED				=13,
	NAND_WRITE_FAILED				=14,
	NAND_FAILED						=15,
	NAND_READ_FAILED				=16,
	NAND_BAD_BLCOK_FAILURE		=17,
	NAND_SHIPPED_BAD_FAILURE		= 18,
	NAND_CONFIGS_FAILED			=19,
	NAND_SHIPPED_BADBLOCK_FAILED			=20,
}amlnf_error_t;

struct _nftl_cfg{
    uint16 nftl_use_cache;
    uint16 nftl_support_gc_read_reclaim;
    uint16 nftl_support_wear_leveling;
    uint16 nftl_need_erase;
    uint16 nftl_part_reserved_block_ratio;
	uint16 nftl_part_adjust_block_num;
    uint16 nftl_min_free_block_num;
    uint16 nftl_gc_threshold_free_block_num;
    uint16 nftl_min_free_block;
    uint16 nftl_gc_threshold_ratio_numerator;
    uint16 nftl_gc_threshold_ratio_denominator;
    uint16 nftl_max_cache_write_num;
};

/*
 * Constants for ECC_MODES
 */
typedef enum {
	NAND_HW_ECC,
	NAND_SOFT_ECC,
} oob_modes_t;

/**
 * struct phydev_ops - oob operation operands
 * @mode:	operation mode, for ecc none or hw mode
 * @len:	number of data bytes to write/read
 * @retlen:	number of data bytes written/read
 * @ooblen:	number of oob bytes to write/read
 * @oobretlen:	number of oob bytes written/read
 * @datbuf:	data buffer - if NULL only oob data are read/written
 * @oobbuf:	oob data buffer- if NULL only data are read/written
 *
 * Note, it is not allowed to read/write more than one OOB area at one go when oob operation.
 * That is, the interface assumes that the OOB write requests program/read within only one page's
 * OOB area.
 */
struct phydev_ops{
	oob_modes_t	mode;
	uint64_t	addr;
	uint64_t	len;          //one operation less than 2GB data len
	unsigned	retlen;
	unsigned	ooblen;
	unsigned char	*datbuf;
	unsigned char	*oobbuf;
};


/*
 * API for NFTL driver.
 * Provide nand basic information and common operation function.
 * Must meet all the requirement of NFTL driver, and also consider the fulture extensions 
 */

/**
 * struct amlnand_phydev - nand phy device 
 * @name:	
 * @type: used for fulture, differ from SLC, MLC and TLC
 * @retlen:	number of data bytes written/read
 * @ooblen:	number of oob bytes to write/read
 * @oobretlen:	number of oob bytes written/read
 * @datbuf:	data buffer - if NULL only oob data are read/written
 * @oobbuf:	oob data buffer- if NULL only data are read/written
 *
 * Note, it is not allowed to read/write more than one OOB area at one go when oob operation.
 * That is, the interface assumes that the OOB write requests program/read within only one page's
 * OOB area.
 */
struct amlnand_phydev{
	const char name[MAX_DEVICE_NAME_LEN];

    /*****nand flash chip type, maybe SLC/MLC/TLC ******/
	unsigned char type; 

	unsigned char ecc_failed;
	unsigned char bit_flip;
	
	/*** used for Read-Only, or other feature ***/
	unsigned flags;

	/*** used for other feature setting***/
	unsigned option;
	
	/*** struct for whole nand chip***/
	//struct amlnand_chip *aml_chip;	
	void *priv;
	
	struct list_head list;

#ifndef AML_NAND_UBOOT
	struct device dev;
	struct class	  cls;
#endif

	/*** offset value of the whole nand device***/
	uint64_t offset;	 	
			
	/*** Total size of the cunrrent nand device***/
	uint64_t size;	 
	
	unsigned char	chipnr;

	/*** "Major" erase size for the device. ***/
	unsigned erasesize;
	
	/* Minimal writable flash unit size. In case of NOR flash it is 1 (even
	 * though individual bits can be cleared), in case of NAND flash it is
	 * one NAND page (or half, or one-fourths of it), in case of ECC-ed NOR
	 * it is of ECC block size, etc. It is illegal to have writesize = 0.
	 * Any driver registering a struct mtd_info must ensure a writesize of
	 * 1 or larger.
	 */
	unsigned writesize;

	/**** Available OOB bytes per page ***/
	unsigned oobavail;  
	
	/*
	 * If erasesize is a power of 2 then the shift is stored in
	 * erasesize_shift otherwise erasesize_shift is zero. Ditto writesize.
	 */
	unsigned erasesize_shift;
	unsigned writesize_shift;
	
	/*** Masks based on writesize_shift ***/
	unsigned writesize_mask;
	
	/***partitions info***/	
	unsigned char nr_partitions;	
	struct amlnf_partition *partitions;

	struct phydev_ops ops;
	/*
	 * Erase is an asynchronous operation.  Device drivers are supposed
	 * to call instr->callback() whenever the operation completes, even
	 * if it completes with a failure.
	 * Callers are supposed to pass a callback function and wait for it
	 * to be called before writing to the block.
	 */
	int (*erase) (struct amlnand_phydev *phydev);	
	
	/***basic data operation and included oob data****/
	int (*read) (struct amlnand_phydev *phydev);
	int (*write) (struct amlnand_phydev *phydev);

	/* In blackbox flight recorder like scenarios we want to make successful
	 * writes in interrupt context. panic_write() is only intended to be
	 * called when its known the kernel is about to panic and we need the
	 * write to succeed. Since the kernel is not going to be running for much
	 * longer, this function can break locks and delay to ensure the write
	 * succeeds (but not sleep). 
	 */
	int (*panic_write) (struct amlnand_phydev *phydev);

	int (*read_oob) (struct amlnand_phydev *phydev);
	
	/********not support yet**********/
	int (*write_oob) (struct amlnand_phydev *phydev);
	
	/*
	 * support read data for sect_uint(512bytes in genreal), 
	 * not just writesize unit, to improve read data speed.  
	 * Not spport yet.
	 */
	int (*read_sect) (struct amlnand_phydev *phydev);
			 
	/* Sync to nand device, used for TLC nand to finish the current write ops*/
	void (*sync) (struct amlnand_phydev *phydev);

	/* Chip-supported device locking */
	int (*lock) (struct amlnand_phydev *phydev);
	int (*unlock) (struct amlnand_phydev *phydev);
	int (*is_locked) (struct amlnand_phydev *phydev);

#ifndef AML_NAND_UBOOT
	/* Power Management functions */
	int (*suspend) (struct amlnand_phydev *phydev);
	void (*resume) (struct amlnand_phydev *phydev);
#endif

	/* Bad block management functions, maybe managed by NFTL layer*/
	int (*block_isbad) (struct amlnand_phydev *phydev);
	int (*block_markbad) (struct amlnand_phydev *phydev);

	int (*block_modifybbt) (struct amlnand_phydev *phydev,int value);
	int (*update_bbt) (struct amlnand_phydev *phydev);
    int (*test_block) (struct amlnand_phydev *phydev);
	//struct notifier_block reboot_notifier;  /* default mode before reboot */	 			
};


struct amlnf_logicdev_t{
	
#ifndef AML_NAND_UBOOT
	struct mutex 			lock;
	struct timespec 		ts_write_start;
	spinlock_t				thread_lock;	
	struct notifier_block   nb;
	struct task_struct*		thread;	
	struct class	  cls;
#endif

	//struct aml_nftl_part_t* aml_nftl_part;
	void *priv;

	struct amlnand_phydev*  nand_dev;
	//amlnf_dev list, since several dev can share one logicdev.
	struct list_head list;	   

	int (*read_data)(struct amlnf_logicdev_t *amlnf_logicdev,unsigned long start_sector,unsigned long len,unsigned char *buf);
	int (*write_data)(struct amlnf_logicdev_t *amlnf_logicdev,unsigned long start_sector,unsigned long len,unsigned char *buf);
	int (*flush)(struct amlnf_logicdev_t *amlnf_logicdev);
	int (*shutdown)(struct amlnf_logicdev_t *amlnf_logicdev);
	
	struct _nftl_cfg        nftl_cfg;
};

struct amlnf_dev{
	char name[MAX_NAND_PART_NAME_LEN];			/* identifier string */
	struct amlnf_logicdev_t* logicdev;
	struct amlnand_phydev*  nand_dev;
	uint64_t size_sector;
	uint64_t offset_sector;
	unsigned mask_flags;
	
#ifndef AML_NAND_UBOOT
	struct kref ref;
	struct request* 		req;
	struct request_queue*	queue;
	spinlock_t queue_lock;
	struct mutex mutex_lock_req;
	struct mutex mutex_lock;
	struct scatterlist* 	bounce_sg;
	unsigned int	bounce_sg_len;	
	bool bg_stop;	
	struct task_struct*		thread;
	struct gendisk *disk;
	struct attribute_group *disk_attributes;	
	struct class	  cls;
#endif

	struct list_head list;

	uint32 (*read_sector)(struct amlnf_dev* dev,unsigned long start_sector,unsigned long len,unsigned char *buf);
	uint32 (*write_sector)(struct amlnf_dev* dev,unsigned long start_sector,unsigned long len,unsigned char *buf);
	uint32 (*flush)(struct amlnf_dev* dev);
};

extern struct list_head nphy_dev_list;
extern struct list_head nf_dev_list;
extern struct list_head nlogic_dev_list;
extern int boot_device_flag;
#ifndef AML_NAND_UBOOT
#define amlnf_notifier_to_blk(l)	container_of(l, struct amlnf_logicdev_t, nb)

extern chip_state_t get_chip_state(struct amlnand_phydev *phydev);
extern void set_chip_state(struct amlnand_phydev *phydev, chip_state_t state);
extern ssize_t show_nand_info(struct class *class, struct class_attribute *attr, char *buf);
extern ssize_t show_bbt_table(struct class *class, struct class_attribute *attr, char *buf);
extern ssize_t show_amlnf_version_info(struct class *class, struct class_attribute *attr, char *buf);
extern ssize_t nand_page_read(struct class *class, struct class_attribute *attr, const char *buf, size_t count);
extern ssize_t nand_page_write(struct class *class, struct class_attribute *attr, const char *buf, size_t count);
extern ssize_t show_nand_info(struct class *class, struct class_attribute *attr, char *buf);
extern ssize_t show_bbt_table(struct class *class, struct class_attribute *attr, char *buf);
//
extern uint16 aml_nftl_get_part_write_cache_nums(void * _part);
extern int logicdev_bg_handle(void *priv);
//
extern ssize_t show_part_struct(struct class *class,struct class_attribute *attr,char *buf);
extern ssize_t show_list(struct class *class, struct class_attribute *attr, const char *buf);
extern ssize_t do_gc_all(struct class *class, struct class_attribute *attr, const char *buf);
extern ssize_t do_gc_one(struct class *class, struct class_attribute *attr, const char *buf);
extern ssize_t do_test(struct class *class, struct class_attribute *attr,	const char *buf, size_t count);

extern int amlnf_pdev_register(struct amlnand_phydev *phydev, unsigned char dev_num);
extern int amlnf_ldev_register(void);
extern void amlchip_resume(struct amlnand_phydev *phydev);
extern int phydev_suspend(struct amlnand_phydev *phydev);
extern int phydev_resume(struct amlnand_phydev *phydev);
extern int amlphy_prepare(unsigned flag);
#endif
extern void *aml_nand_malloc(uint32 size);
extern void aml_nand_free(const void *ptr);

#ifndef AML_NAND_UBOOT
extern void *amlnf_dma_malloc(uint32 size, unsigned char flag);
extern void amlnf_dma_free(const void *ptr, unsigned size, unsigned char flag);
#endif

extern int amlnf_get_logicdev(struct amlnf_logicdev_t *amlnf_logicdev);
extern int amlnf_free_logicdev(struct amlnf_logicdev_t *amlnf_logicdev);
extern int amlnf_logicdev_mis_init(struct amlnf_logicdev_t *amlnf_logicdev);

extern int amlnand_get_device(struct amlnand_phydev *phydev, chip_state_t new_state);
extern void amlnand_release_device(struct amlnand_phydev *phydev);
extern void pinmux_select_chip(unsigned ce_enable, unsigned rb_enable, unsigned flag);

extern int amlnf_phy_init(unsigned char flag);
extern int amlnf_logic_init(unsigned flag);
extern int amlnf_dev_init(unsigned flag);
extern  int is_phydev_off_adjust(void); 
extern  int get_adjust_block_num(void);
#endif
