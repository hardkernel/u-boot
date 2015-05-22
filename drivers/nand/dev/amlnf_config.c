
#include "../include/amlnf_dev.h"
#include "../include/phynand.h"
/***********************************************************************
 * Nand Config
 **********************************************************************/

struct amlnf_partition *amlnand_config = NULL;

/* fixme, port from common/partition_table.c & storage.c */
static struct partitions * part_table = NULL;
#define SZ_1M                           0x00100000

struct partitions partition_table[8] = {
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
			.name = "boot",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "dtd",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "system",
			.size = 128*SZ_1M,
			.mask_flags = STORE_CODE,
		},
		{
			.name = "cache",
			.size = 32*SZ_1M,
			.mask_flags = STORE_CACHE,
		},
		{
			.name = "data",
			.size = NAND_PART_SIZE_FULL,
			.mask_flags = STORE_DATA,
		},
};

int amlnand_get_partition_table(void)
{
	int ret = 0;
	u32	config_size;
	/* fixme, debug code for pxp.... */

	part_table = partition_table;

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
	memcpy(amlnand_config, part_table, config_size);

	return ret;
}




