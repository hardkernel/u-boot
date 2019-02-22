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
#define     MMC_BOOT_NAME0                   "bootloader-boot0"
#define     MMC_BOOT_NAME1                   "bootloader-boot1"
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
#define CALI_PATTERN		(0x55aa55aa)

#define	MMC_MAGIC_NAME		"magic"
#define MAGIC_OFFSET	(SZ_1M * 6)
#define MAGIC_SIZE	(256 * 512)
#define MAGIC_BLOCK_SIZE		(512)
#define MAGIC_PATTERN	(0X00FF00FF)

#define	MMC_RANDOM_NAME		"random"
#define RANDOM_OFFSET	(SZ_1M * 7)
#define RANDOM_SIZE	(256 * 512)
#define RANDOM_BLOCK_SIZE		(512)
#define RANDOM_PATTERN	(0X52414E44)

#define MMC_DDR_PARAMETER_NAME	"ddr-parameter"
#define DDR_PARAMETER_OFFSET	(SZ_1M * 8)
#define DDR_PARAMETER_SIZE	(4 * 512)

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
#define EMMC_FASTBOOT_CONTEXT_DEV         (1)

#define MMC_FASTBOOT_CONTEXT_NAME     "fastboot_context"
#define FASTBOOT_CONTEXT_OFFSET  (SZ_1M * 5)
#define FASTBOOT_CONTEXT_SIZE    (512)

struct virtual_partition {
	char name[MAX_MMC_PART_NAME_LEN];
	uint64_t offset;
	uint64_t size;
};

#define VIRTUAL_PARTITION_ELEMENT(na, of, sz) {.name = na, .offset = of, .size = sz,}

struct aml_pattern {
	char name[MAX_MMC_PART_NAME_LEN];
	unsigned int pattern;
};
#define AML_PATTERN_ELEMENT(na, pa) {.name = na, .pattern = pa,}

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

#define LOCK_MAJOR_VERSION 1
#define LOCK_MINOR_VERSION 0

#define LOCK_DATA_SIZE 8

typedef struct LockData {
	uint8_t version_major;
	uint8_t version_minor;

	/* Padding to eight bytes. */
	uint8_t reserved1[2];

	/* 0: unlock    1: lock*/
	uint8_t lock_state;

	/* 0: unlock    1: lock*/
	uint8_t lock_critical_state;

	/* 0: enable bootloader version rollback 1: prevent bootloader version rollback*/
	uint8_t lock_bootloader;
	uint8_t reserved2[1];
} LockData_t;

/*512Bytes*/
typedef struct FastbootContext {
	/* locks */
	LockData_t lock;
	uint8_t rsv[248];
	/* checksum, storage driver care */
	uint32_t crc32;
} FastbootContext_t;

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
int mmc_boot_size(char *name, uint64_t* size);
struct virtual_partition *aml_get_virtual_partition_by_name(const char *name);
bool aml_is_emmc_tsd (struct mmc *mmc);
int mmc_device_init (struct mmc *mmc);
ulong _get_inherent_offset(const char *name);

#define PARTITION_ELEMENT(na, sz, flags) {.name = na, .size = sz, .mask_flags = flags,}

#endif
