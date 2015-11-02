#ifndef __AML_NFTL_CFG_H__
#define __AML_NFTL_CFG_H__
#include "../logic/aml_nftl_type.h"
#include "../include/amlnf_cfg.h"

/* #define  PRINT printk */

#define NFTL_DONT_CACHE_DATA		0
#define SUPPORT_GC_READ_RECLAIM		0
#define SUPPORT_WEAR_LEVELING		0
#define NFTL_ERASE			0

#ifdef NAND_ADJUST_PART_TABLE
#define PART_RESERVED_BLOCK_RATIO	10
#else
#define PART_RESERVED_BLOCK_RATIO	8
#endif

#define MIN_FREE_BLOCK_NUM		6
#define GC_THRESHOLD_FREE_BLOCK_NUM	4

#define MIN_FREE_BLOCK			5

#define GC_THRESHOLD_RATIO_NUMERATOR	2
#define GC_THRESHOLD_RATIO_DENOMINATOR	3

#define MAX_CACHE_WRITE_NUM		4
#define NFTL_CACHE_FLUSH_SYNC		1


extern void aml_nftl_set_part_test(void *_part, u32 test);
extern void *aml_nftl_get_part_priv(void *_part);
extern void aml_nftl_add_part_total_write(void *_part);
extern void aml_nftl_add_part_total_read(void *_part);
extern u16 aml_nftl_get_part_write_cache_nums(void *_part);

#endif /* __AML_NFTL_CFG_H__ */

