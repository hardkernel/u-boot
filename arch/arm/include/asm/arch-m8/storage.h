/***********************************************
*****Storage config of board, for ACS use.*****
***********************************************/

#ifndef __STORAGE_H
#define __STORAGE_H

#include <linux/types.h>

#ifndef __ASSEMBLY__

//Partition table defines
#define 	NAND_PART_SIZE_FULL  		-1
#define 	MAX_PART_NUM			16
#define	 MAX_PART_NAME_LEN		 16
#define 	SZ_1M 					0x100000

#define 	STORE_CODE 				1
#define	STORE_CACHE				(1<<1)
#define 	STORE_DATA				(1<<2)

#define SPI_BOOT_FLAG 			0
#define NAND_BOOT_FLAG 		1
#define EMMC_BOOT_FLAG 		2
#define CARD_BOOT_FLAG 		3
#define SPI_NAND_FLAG			4
#define SPI_EMMC_FLAG			5

#define CARD_TYPE_SHIFT             4
#define CARD_TYPE_MASK              0xf
#define CARD_TYPE_UNKNOWN           0        /* unknown */
#define CARD_TYPE_MMC               1        /* MMC card */
#define CARD_TYPE_SD                2        /* SD card */
#define CARD_TYPE_SDIO              3        /* SDIO card */
#define CARD_TYPE_SD_COMBO          4        /* SD combo (IO+mem) card */
#define CARD_TYPE_NON_SDIO          5        /* NON sdio device (means SD/MMC card) */

#define AML_GET_CARD_TYPE(val, port)    ((val >> (port * CARD_TYPE_SHIFT)) & CARD_TYPE_MASK)
#define AML_SET_CARD_TYPE(val, port, type)   \
    (val |= ((type & CARD_TYPE_MASK) << (port * CARD_TYPE_SHIFT)))

struct partitions {
	char name[MAX_PART_NAME_LEN];			/* identifier string */
	uint64_t size;			/* partition size */
	uint64_t offset;		/* offset within the master space */
	unsigned mask_flags;		/* master flags to mask out for this partition */
};

struct config_nand {
	unsigned enable_slc;
	unsigned order_ce;
	unsigned reserved[2];
};

struct config_mmc {
	unsigned type;
	unsigned port;
	unsigned reserved[2];
};

struct store_config {
	unsigned  store_device_flag;			// indicate storage devices on each board
	struct config_nand  nand_configs;			// specital config for nand
	struct config_mmc  mmc_configs;			// specital config for mmc
};

#endif
#endif
