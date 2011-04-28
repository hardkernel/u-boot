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
#include <asm/arch/reboot.h>
#include <asm/arch/clock.h>
#include <asm/sizes.h>
#include<partition_table.h>
#include <asm/arch/storage.h>

#define     AML_MMC_DBG

#define     MAX_DEVICE_NUM                  16
#define     MAX_DEVICE_NAME_LEN             16
#define     MAX_MMC_PART_NUM                16
#define     MAX_MMC_PART_NAME_LEN           16

#define     PARTITION_RESERVED              (8*SZ_1M)  // 8MB
#define     MMC_BOOT_PARTITION_RESERVED     (32*SZ_1M) // 32MB

#define     MMC_BOOT_NAME                   "bootloader"
#define     MMC_BOOT_DEVICE_SIZE            (0x4*SZ_1M)

#define     MMC_RESERVED_NAME               "reserved"
#define     MMC_RESERVED_SIZE               (64*SZ_1M)

#define     MMC_CACHE_NAME                  "cache"
// #define     MMC_CACHE_SIZE                  (512*SZ_1M) // this is not used and should be get from spl

#define     MMC_ENV_NAME                    "env"
#define     MMC_ENV_SIZE                    (8*SZ_1M)

// #define     MMC_KEY_NAME                    "key"
// #define     MMC_KEY_SIZE                    (0x1*SZ_1M)

// #define     MMC_SECURE_NAME                 "secure"
// #define     MMC_SECURE_SIZE                 (0x1*SZ_1M)

#define     MMC_UBOOT_VERSION               "01.00.00"

#define     MMC_PARTITIONS_MAGIC            "MPT" // MMC Partition Table
#define     MMC_CARD_PARTITION_NAME         "card"

#ifdef AML_MMC_DBG
#define aml_mmc_dbg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
                  __func__, __LINE__, ##__VA_ARGS__)

#define aml_mmc_msg(fmt, ...) printk( "%s: line:%d " fmt "\n", \
                  __func__, __LINE__, ##__VA_ARGS__)
#else
#define aml_mmc_dbg(fmt, ...)
#define aml_mmc_msg(fmt, ...) printk( fmt "\n",  ##__VA_ARGS__)
#endif

struct mmc_partitions_fmt {
    char magic[4];
    unsigned char version[12];
    int part_num;
    int checksum;
    struct partitions partitions[MAX_MMC_PART_NUM];
};

struct mmc_config{
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

struct partitions* find_mmc_partition_by_name (char *name);

#endif

