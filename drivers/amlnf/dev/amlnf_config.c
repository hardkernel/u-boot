
#include "../include/amlnf_dev.h"

/***********************************************************************
 * Nand Config
 **********************************************************************/



extern struct partitions *part_table;
struct amlnf_partition * amlnand_config=NULL;

int amlnand_get_partition_table()
{	
	int ret=0;

	if(part_table == NULL){
		aml_nand_msg("part_table from ACS is NULL, do not init nand");
		return -NAND_FAILED;
	}
	
	amlnand_config = aml_nand_malloc(MAX_NAND_PART_NUM * sizeof(struct amlnf_partition));
	if(!amlnand_config){
		aml_nand_dbg("amlnand_config: malloc failed!");
		ret = -NAND_MALLOC_FAILURE;
	}
	
	//show_partition_table();

	memcpy(amlnand_config, part_table, (MAX_NAND_PART_NUM * sizeof(struct amlnf_partition)));
	
	return ret;
}




