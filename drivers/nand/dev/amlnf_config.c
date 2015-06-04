
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
extern struct partitions part_table[];
#endif /* AML_CFG_INSIDE_PARTTBL */

int amlnand_get_partition_table(void)
{
	int ret = 0;
	u32	config_size;
	int i;
	/* fixme, debug code for pxp.... */
#if (AML_CFG_INSIDE_PARTTBL)
	part_table = partition_table;
#endif
	if (part_table == NULL) {
		aml_nand_msg("part_table from ACS is NULL, do not init nand");
		return -NAND_FAILED;
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
	for (i = 0; i < MAX_PART_NUM; i++) {
		memcpy(amlnand_config[i].name, part_table[i].name, MAX_PART_NAME_LEN);
		amlnand_config[i].size = part_table[i].size;
		amlnand_config[i].offset = part_table[i].offset;
		amlnand_config[i].mask_flags = part_table[i].mask_flags;

		if (part_table[i].size == NAND_PART_SIZE_FULL)
			break;
	}

	return ret;
}




