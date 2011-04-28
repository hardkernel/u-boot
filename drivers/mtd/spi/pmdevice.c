/*
 * (C) Copyright 2012, Amlogic Inc.
 * Licensed under the GPL-2 or later.
 */

#include <common.h>
#include <malloc.h>
#include <spi_flash.h>
#include "spi_flash_amlogic.h"

struct pmdevice_spi_flash_params {
	uint32_t	id;
	uint32_t	sector_size;
	uint32_t	block_size;
	uint32_t	chip_size;
	const char	*name;
};

/* spi_flash needs to be first so upper layers can free() it */
struct pmdevice_spi_flash {
	struct spi_flash flash;
	const struct pmdevice_spi_flash_params *params;
};

static inline struct pmdevice_spi_flash *to_pmdevice_spi_flash(struct spi_flash *flash)
{
	return container_of(flash, struct pmdevice_spi_flash, flash);
}

#define PM_ID_PM25LQ032C 0x9d46

static const struct pmdevice_spi_flash_params pmdevice_spi_flash_table[] = {
	{	.id			 = PM_ID_PM25LQ032C,
		.sector_size = 4*1024,
		.block_size	 = 16*4*1024 ,
		.chip_size	 = 4*1024*1024,
		.name		 = "PM25LQ032C",
	},	
};

static int pmdevice_write(struct spi_flash *flash, u32 offset, size_t len, const void *buf)
{	
	int nReturn = 0;
	
	spi_claim_bus(flash->spi);
    
    nReturn = spi_flash_write_amlogic(flash, offset, len,buf);
    
    spi_release_bus(flash->spi);

	return nReturn;
}

static int pmdevice_read_fast(struct spi_flash *flash, u32 offset, size_t len, void *buf)
{
	int nReturn =0;
	
	spi_claim_bus(flash->spi);

    nReturn = spi_flash_read_amlogic(flash, offset, len,buf);

    spi_release_bus(flash->spi);

	return nReturn;
}
static int pmdevice_erase(struct spi_flash *flash, u32 offset, size_t len)
{
	struct pmdevice_spi_flash *stm = to_pmdevice_spi_flash(flash);
	u32 sector_size;
	int nReturn;

	sector_size = stm->params->sector_size;

	spi_claim_bus(flash->spi);

	nReturn = spi_flash_erase_amlogic(flash, offset, len, sector_size);
	
	spi_release_bus(flash->spi);

	return nReturn;
}

struct spi_flash *spi_flash_probe_pmdevice(struct spi_slave *spi, u8 *idcode)
{
	const struct pmdevice_spi_flash_params *params;
	struct pmdevice_spi_flash *pmdevice;
	unsigned int i;

          printf("spi_flash_probe_pmdevice %02x %02x %02x\n", idcode[0], idcode[1], idcode[2]);
	for (i = 0; i < ARRAY_SIZE(pmdevice_spi_flash_table); ++i) {
		params = &pmdevice_spi_flash_table[i];
		if (((idcode[1] << 8) | idcode[2]) == params->id)
			break;
	}

	if (i == ARRAY_SIZE(pmdevice_spi_flash_table)) {
		debug("SF: Unsupported pmdevice ID %02x\n", idcode[1]);
		return NULL;
	}
	
	pmdevice = malloc(sizeof(*pmdevice));
	if (!pmdevice) {
		debug("SF: Failed to allocate memory\n");
		return NULL;
	}

	pmdevice->params = params;
	pmdevice->flash.spi = spi;
	pmdevice->flash.name = params->name;

	pmdevice->flash.write = pmdevice_write;
	pmdevice->flash.erase = pmdevice_erase;
	pmdevice->flash.read  = pmdevice_read_fast;

	pmdevice->flash.size = params->chip_size;

	debug("SF: Detected %s with page size %u, total %u bytes\n",
	      params->name, params->page_size, pmdevice->flash.size);

	return &pmdevice->flash;
}

