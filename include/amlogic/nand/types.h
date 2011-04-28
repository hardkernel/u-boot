#ifndef __AMLOGIC_NAND_TYPES_H_
#define __AMLOGIC_NAND_TYPES_H_
#include <linux/types.h>
typedef struct __nand_flash_dev_s nand_dev_t;
#define MAX_ID_LEN  8
struct __nand_flash_dev_s {
	char *name;
	union{
		uint8_t id[MAX_ID_LEN];
		uint64_t id64;
	}id;
	uint64_t id64_mask;
	uint64_t feature;
	uint64_t chipsize;
	uint32_t pagesize;
	uint32_t erasesize;
	uint32_t oobsize;
	uint16_t dienum;
	uint16_t planenum;
/**
 * timing relative .
 */
	uint16_t t_rea;
	uint16_t t_rhoh;
/**
 * ecc requirement
 */
	uint16_t eccdata;
	uint16_t eccbits;
	uint32_t erasecount;
/**
 * bad block information
 */
	uint32_t badblocks;
	uint32_t *badpos;
};

#endif
