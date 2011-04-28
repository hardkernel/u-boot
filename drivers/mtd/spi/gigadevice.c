/*
 * (C) Copyright 2012, Amlogic Inc.
 * Author: Haixiang Bao<haixiang.bao@amlogic.com>
 * Licensed under the GPL-2 or later.
 */

#include <common.h>
#include <malloc.h>
#include <spi_flash.h>
#include "spi_flash_amlogic.h"

struct gigadevice_spi_flash_params {
	uint32_t	id;
	uint32_t	sector_size;
	uint32_t	block_size;
	uint32_t	chip_size;
	const char	*name;
};

/* spi_flash needs to be first so upper layers can free() it */
struct gigadevice_spi_flash {
	struct spi_flash flash;
	const struct gigadevice_spi_flash_params *params;
};

static inline struct gigadevice_spi_flash *to_gigadevice_spi_flash(struct spi_flash *flash)
{
	return container_of(flash, struct gigadevice_spi_flash, flash);
}

#define GIGADEVICE_ID_GD25Q16 0x4015
#define GIGADEVICE_ID_GD25Q32 0x4016
#define GIGADEVICE_ID_GD25Q40 0x4013

static const struct gigadevice_spi_flash_params gigadevice_spi_flash_table[] = {
	{	.id			 = GIGADEVICE_ID_GD25Q16,
		.sector_size = 4*1024,
		.block_size	 = 16*4*1024 ,
		.chip_size	 = 32*16*4*1024,
		.name		 = "GD25Q16",
	},	
	{	.id			 = GIGADEVICE_ID_GD25Q32,
		.sector_size = 4*1024,
		.block_size	 = 16*4*1024 ,
		.chip_size	 = 64*16*4*1024,
		.name		 = "GD25Q32",
	},	
	{	.id			 = GIGADEVICE_ID_GD25Q40,
		.sector_size = 4*1024,
		.block_size	 = 16*4*1024 ,
		.chip_size	 = 8*16*4*1024,
		.name		 = "GD25Q40",
	},
};

static int gigadevice_write(struct spi_flash *flash, u32 offset, size_t len, const void *buf)
{	
	int nReturn = 0;
	
	spi_claim_bus(flash->spi);
    
    nReturn = spi_flash_write_amlogic(flash, offset, len,buf);
    
    spi_release_bus(flash->spi);

	return nReturn;
}

static int gigadevice_read_fast(struct spi_flash *flash, u32 offset, size_t len, void *buf)
{
	int nReturn =0;
	
	spi_claim_bus(flash->spi);

    nReturn = spi_flash_read_amlogic(flash, offset, len,buf);

    spi_release_bus(flash->spi);

	return nReturn;
}
static int gigadevice_erase(struct spi_flash *flash, u32 offset, size_t len)
{
	struct gigadevice_spi_flash *stm = to_gigadevice_spi_flash(flash);
	u32 sector_size;
	int nReturn;

	sector_size = stm->params->sector_size;

	spi_claim_bus(flash->spi);

	nReturn = spi_flash_erase_amlogic(flash, offset, len, sector_size);
	
	spi_release_bus(flash->spi);

	return nReturn;
}

struct spi_flash *spi_flash_probe_gigadevice(struct spi_slave *spi, u8 *idcode)
{
	const struct gigadevice_spi_flash_params *params;
	struct gigadevice_spi_flash *gigadevice;
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(gigadevice_spi_flash_table); ++i) {
		params = &gigadevice_spi_flash_table[i];
		if (((idcode[1] << 8) | idcode[2]) == params->id)
			break;
	}

	if (i == ARRAY_SIZE(gigadevice_spi_flash_table)) {
		debug("SF: Unsupported GIGADEVICE ID %02x\n", idcode[1]);
		return NULL;
	}

	gigadevice = malloc(sizeof(*gigadevice));
	if (!gigadevice) {
		debug("SF: Failed to allocate memory\n");
		return NULL;
	}

	gigadevice->params = params;
	gigadevice->flash.spi = spi;
	gigadevice->flash.name = params->name;

	gigadevice->flash.write = gigadevice_write;
	gigadevice->flash.erase = gigadevice_erase;
	gigadevice->flash.read  = gigadevice_read_fast;

	gigadevice->flash.size = params->chip_size;

	debug("SF: Detected %s with page size %u, total %u bytes\n",
	      params->name, params->page_size, gigadevice->flash.size);

	return &gigadevice->flash;
}
