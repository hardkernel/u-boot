#ifndef _AML_MMC_H
#define _AML_MMC_H

#include <asm/io.h>
#include <config.h>
#include <common.h>
#include <command.h>
#include <mmc.h>
#include <part.h>
#include <malloc.h>
#include <linux/list.h>
#include <mmc.h>
#include <div64.h>
#include <environment.h>
#include <malloc.h>
#include <asm/cache.h>
#include <asm/arch/clock.h>
#include<partition_table.h>
#include <storage.h>
#include <linux/sizes.h>

#define     AML_MMC_DBG

#define     MAX_DEVICE_NUM                  32
#define     MAX_DEVICE_NAME_LEN             16
#define     MAX_MMC_PART_NUM                32
#define     MAX_MMC_PART_NAME_LEN           16

#ifndef CONFIG_AML_MMC_INHERENT_PART
#define     PARTITION_RESERVED              (8*SZ_1M)  // 8MB
#define     MMC_BOOT_PARTITION_RESERVED     (32*SZ_1M) // 32MB

#define     MMC_BOOT_NAME                   "bootloader"
#define     MMC_BOOT_DEVICE_SIZE            (0x4*SZ_1M)

#define     MMC_RESERVED_NAME               "reserved"
#define     MMC_RESERVED_SIZE               (64*SZ_1M)
#define		MMC_BOTTOM_RSV_SIZE				(0)
#endif		/* CONFIG_AML_MMC_INHERENT_PART */

#define     MMC_CACHE_NAME                  "cache"
// #define     MMC_CACHE_SIZE                  (512*SZ_1M) // this is not used and should be get from spl

#define     MMC_ENV_NAME                    "env"
#define     MMC_ENV_SIZE                    (8*SZ_1M)

#define     MMC_KEY_NAME                    "key"
#define     MMC_KEY_SIZE                    (256*1024)
#define     EMMCKEY_RESERVE_OFFSET           (0x4000)
#define     MMC_RESERVED_OFFSET              (36*SZ_1M)
#define     MMC_BLOCK_SIZE                   (512)
// #define     MMC_SECURE_NAME                 "secure"
// #define     MMC_SECURE_SIZE                 (0x1*SZ_1M)

#define     MMC_MPT_VERSION_1               "01.00.00"
#define     MMC_MPT_VERSION_2               "01.02.00"
/* version in use, fixme when kenel driver is updated. */
#define		MMC_MPT_VERSION					MMC_MPT_VERSION_1

#define     MMC_PARTITIONS_MAGIC            "MPT" // MMC Partition Table
#define     MMC_CARD_PARTITION_NAME         "card"

/* virtual partitions*/

#define MMC_MBR_NAME    ("AML_MBR")
/* offset&size of mbr will not be used */
#define MMC_MBR_OFFSET  (0x0)
#define MMC_MBR_SIZE    (0x200)

/*
* partition table
* |<----partition_table---->|<----key---->|
*
*/
#define MMC_TABLE_NAME		("AML_TABLE")
#define MMC_TABLE_OFFSET		(0x0)
#define MMC_TABLE_SIZE		(16*1024)

/*
* write 128KB data pattern
* |<----pattern---->||<------DTB------>|
*/
#define	MMC_PATTERN_NAME		"pattern"
#define CALI_PATTERN_OFFSET	(SZ_1M * 3)
#define CALI_PATTERN_SIZE	(256 * 512)
#define CALI_BLOCK_SIZE		(512)
/*
 * 2 copies dtb were stored in dtb area.
 * each is 256K.
 * timestamp&checksum are in the tail.
 * |<--------------DTB Area-------------->|
 * |<------DTB1------->|<------DTB2------>|
 */
#define MMC_DTB_NAME		"dtb"
#define DTB_OFFSET		(SZ_1M * 4)
#define DTB_BLK_SIZE		(512)
#define DTB_BLK_CNT			(512)
#define DTB_SIZE			(DTB_BLK_CNT * DTB_BLK_SIZE)
#define DTB_COPIES			(2)
#define DTB_AREA_BLK_CNT	(DTB_BLK_CNT * DTB_COPIES)
#define EMMC_DTB_DEV		(1)

struct virtual_partition {
	char name[MAX_MMC_PART_NAME_LEN];
	uint64_t offset;
	uint64_t size;
};

#define VIRTUAL_PARTITION_ELEMENT(na, of, sz) {.name = na, .offset = of, .size = sz,}

#ifdef AML_MMC_DBG
#define aml_mmc_dbg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
                  __func__, __LINE__, ##__VA_ARGS__)

#define aml_mmc_msg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
                  __func__, __LINE__, ##__VA_ARGS__)
#else
#define aml_mmc_dbg(fmt, ...)
#define aml_mmc_msg(fmt, ...) printk( fmt "\n",  ##__VA_ARGS__)
#endif

#define DOS_MBR	0
#define DOS_PBR	1

#define DOS_PBR_FSTYPE_OFFSET	0x36
#define DOS_PBR32_FSTYPE_OFFSET	0x52

#define DOS_PART_DISKSIG_OFFSET	0x1b8
#define DOS_PART_TBL_OFFSET	0x1be
#define DOS_PART_MAGIC_OFFSET	0x1fe
#define DOS_PBR_MEDIA_TYPE_OFFSET	0x15

#define DOS_PARTITION_COUNT 32

typedef struct dos_partition {
	unsigned char boot_ind;		/* 0x80 - active			*/
	unsigned char head;		/* starting head			*/
	unsigned char sector;		/* starting sector			*/
	unsigned char cyl;		/* starting cylinder			*/
	unsigned char sys_ind;		/* What partition type			*/
	unsigned char end_head;		/* end head				*/
	unsigned char end_sector;	/* end sector				*/
	unsigned char end_cyl;		/* end cylinder				*/
	unsigned char start4[4];	/* starting sector counting from 0	*/
	unsigned char size4[4];		/* nr of sectors in partition		*/
} dos_partition_t;

struct dos_mbr_or_ebr{
	unsigned char bootstart[446];
	struct dos_partition part_entry[4];
	unsigned char magic[2];
};

struct mmc_partitions_fmt {
    char magic[4];
    unsigned char version[12];
    int part_num;
    int checksum;
    struct partitions partitions[MAX_MMC_PART_NUM];
};

struct mmc_partition_config{
    unsigned char version[12];
    int part_num;
    struct partitions partitions[MAX_MMC_PART_NUM];
    unsigned option;
    void * private_data;
};

/*
struct _mmc_device{
    char name[MAX_DEVICE_NAME_LEN];
    uint64_t  offset;
    uint64_t  size;
    void * private_data;
    struct list_head list;
};
*/

extern bool is_partition_checked;
extern struct partitions emmc_partition_table[];

extern int get_emmc_partition_arraysize(void);

/*
 * get the partition number by name
 * return value
 *	< 0 means no partition found
 *	>= 0 means valid partition
 */
extern int get_partition_num_by_name(char *name);

struct partitions* find_mmc_partition_by_name (char *name);
struct partitions *aml_get_partition_by_name(const char *name);
struct virtual_partition *aml_get_virtual_partition_by_name(const char *name);
bool aml_is_emmc_tsd (struct mmc *mmc);
int mmc_device_init (struct mmc *mmc);

#define PARTITION_ELEMENT(na, sz, flags) {.name = na, .size = sz, .mask_flags = flags,}

#endif
