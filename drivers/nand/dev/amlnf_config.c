
#include "../include/amlnf_dev.h"
#include "../include/phynand.h"
#include "storage.h"
/***********************************************************************
 * Nand Config
 **********************************************************************/

struct amlnf_partition *amlnand_config = NULL;
#if (AML_CFG_INSIDE_PARTTBL)
/* fixme, port from common/partition_table.c & storage.c */
static struct partitions * part_table = NULL;
#define SZ_1M                           0x00100000

struct partitions partition_table[] = {
		{
			.name = "logo",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "recovery",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "dtb",
			.size = 8*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "tee",
			.size = 8*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "crypt",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "misc",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
#ifdef CONFIG_INSTABOOT
		{
			.name = "instaboot",
			.size = 1024*SZ_1M,
			.mask_flags = STORE_CODE,
		},
#endif
		{
			.name = "boot",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "system",
			.size = 1024*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "cache",
			.size = 512*SZ_1M,
			.mask_flags = STORE_CACHE,
		},
		{
			.name = "data",
			.size = NAND_PART_SIZE_FULL,
			.mask_flags = STORE_DATA,
		},
};
#else
extern struct partitions * part_table;
#define SZ_1M                           0x00100000
struct partitions def_partition_table[] = {
		{
			.name = "logo",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "recovery",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "dtb",
			.size = 8*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "tee",
			.size = 8*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "crypt",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "misc",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
#ifdef CONFIG_INSTABOOT
		{
			.name = "instaboot",
			.size = 1024*SZ_1M,
			.mask_flags = STORE_CODE,
		},
#endif
		{
			.name = "boot",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "system",
			.size = 1024*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "cache",
			.size = 512*SZ_1M,
			.mask_flags = STORE_CACHE,
		},
		{
			.name = "data",
			.size = NAND_PART_SIZE_FULL,
			.mask_flags = STORE_DATA,
		},
};
#endif /* AML_CFG_INSIDE_PARTTBL */

#if (AML_CFG_DTB_RSV_EN)
extern int amlnf_dtb_init_partitions(struct amlnand_chip *aml_chip);
extern int amlnf_detect_dtb_partitions(struct amlnand_chip *aml_chip);
#endif

int amlnand_get_partition_table(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	u32	config_size;
	int i;

	/* fixme, debug code for pxp.... */
#if (AML_CFG_INSIDE_PARTTBL)
	part_table = partition_table;
#endif
	aml_nand_msg("outside dtb: %p", part_table);
	if (part_table == NULL) {
		aml_nand_msg("using dtb on nand");
		/* fixme, not initialized by outside then using dtb of our self. */
	#if (AML_CFG_DTB_RSV_EN)
		ret = amlnf_dtb_init_partitions(aml_chip);
		if (ret < 0) {
			aml_nand_msg("amlnf dtb init failed");
			aml_chip->detect_dtb_flag = 1;
			return -NAND_DETECT_DTB_FAILED;
			/* do not use default partition_table anyway!*/
			/*ret = -NAND_FAILED;*/
		}
	#else
		aml_chip->detect_dtb_flag = 1;
		return -NAND_DETECT_DTB_FAILED;
	#endif
	}
	else{
		amlnf_detect_dtb_partitions(aml_chip);
	}

	if (ret) {
		part_table = def_partition_table;
		aml_nand_msg("%s() %p, using default one to bootup", __func__, part_table);
		ret = 0;
	}
	config_size = MAX_NAND_PART_NUM * sizeof(struct amlnf_partition);
	amlnand_config = aml_nand_malloc(config_size);
	if (!amlnand_config) {
		aml_nand_dbg("amlnand_config: malloc failed!");
		ret = -NAND_MALLOC_FAILURE;
	}

	/* show_partition_table(); */
	//memcpy(amlnand_config, part_table, config_size);
	/* do not use memcpy avoid further change */
	aml_chip->h_cache_dev = 0;
	for (i = 0; i < MAX_PART_NUM; i++) {
		memcpy(amlnand_config[i].name, part_table[i].name, MAX_PART_NAME_LEN);
		amlnand_config[i].size = part_table[i].size;
		amlnand_config[i].offset = part_table[i].offset;
		amlnand_config[i].mask_flags = part_table[i].mask_flags;

		if (amlnand_config[i].mask_flags == STORE_CACHE) {
			aml_chip->h_cache_dev = 1;/*have cache dev*/
			aml_nand_msg("cache !!!");
		}
		if (part_table[i].size == NAND_PART_SIZE_FULL)
			break;
	}

	return ret;
}




