/*
 * Copyright C 2009 by Amlogic, Inc. All Rights Reserved.
 * Description: esmt spi chips support
 * Author:	pfs
 */
#define DEBUG

#include <common.h>
#include <malloc.h>
#include <spi_flash.h>
#include "spi_flash_amlogic.h"

struct esmt_spi_flash_params {
	uint32_t	id;
	uint32_t	sector_size;
	uint32_t	block_size;
	uint32_t	chip_size;
	const char	*name;
};

/* spi_flash needs to be first so upper layers can free() it */
struct esmt_spi_flash {
	struct spi_flash flash;
	const struct esmt_spi_flash_params *params;
};

static inline struct esmt_spi_flash * to_esmt_spi_flash(struct spi_flash *flash)
{
	return container_of(flash, struct esmt_spi_flash, flash);
}

#define ESMT_ID_F25L08QA 0x4014
#define ESMT_ID_F25L16PA 0x2115
#define ESMT_ID_F25L32PA 0x2116
#define ESMT_ID_F25L32QA 0x4116

static const struct esmt_spi_flash_params esmt_spi_flash_table[] = {
	{
		.id			= ESMT_ID_F25L08QA,
		.sector_size= 4*1024,
		.block_size	=64*1024 ,
		.chip_size	= 1*1024*1024,
		.name			= "F25L08QA",
	},
	{
		.id			= ESMT_ID_F25L16PA,
		.sector_size= 4*1024,
		.block_size	=64*1024 ,
		.chip_size	= 2*1024*1024,
		.name			= "F25L16PA",
	},
	{
		.id			= ESMT_ID_F25L32PA,
		.sector_size= 4*1024,
		.block_size	=64*1024 ,
		.chip_size	=4*1024*1024,
		.name		= "F25L32PA",
	},
	{
		.id			= ESMT_ID_F25L32QA,
		.sector_size= 4*1024,
		.block_size	=64*1024 ,
		.chip_size	=4*1024*1024,
		.name		= "F25L32QA",
	},
};
#if 0
int spi_flash_read_aml_esmt(struct spi_flash *flash,u32 offset, size_t len, void *buf){

	struct spi_slave *spi = flash->spi;
	//int ret;
	u32 temp_addr;
    int temp_length;
    temp_addr = offset;
    temp_length = len;
	unsigned flags;

	spi_claim_bus(spi);															/*FIXME for spi_xfer release bus*/
	while (temp_length>0) {

		flags=(temp_addr & 0xffffff)|( (temp_length>=32?32:temp_length) << SPI_FLASH_BYTES_LEN);

		spi_flash_adr_write(spi, flags);

		flags=(1<<SPI_FLASH_READ);

		spi_flash_cmd(spi,flags,NULL,0);

		flags=SPI_XFER_READCACHE;

		spi_xfer(spi,(temp_length>=32?32:temp_length)*8,NULL,buf,flags);

        temp_addr   += (temp_length>=32?32:temp_length);
		buf			+= (temp_length>=32?32:temp_length);
		temp_length -= (temp_length>=32?32:temp_length);

	}

	return 0;

}
#endif
static int esmt_read(struct spi_flash *flash,u32 offset, size_t len, void *buf){

//	struct esmt_spi_flash *stm = to_esmt_spi_flash(flash);
	int ret;

	spi_claim_bus(flash->spi);

    ret = spi_flash_read_amlogic(flash, offset, len,buf);

    spi_release_bus(flash->spi);

	return  ret;
}
#if 0
int spi_flash_write_esmt(struct spi_flash *flash,u32 offset, size_t len, const void *buf){

	struct spi_slave *spi = flash->spi;
	int ret;
	unsigned temp_addr;
    int temp_length;
    temp_addr = offset;
    temp_length = len;
	unsigned flags;

	while (temp_length>0) {

		flags=(temp_addr & 0xffffff)|( (temp_length>=32?32:temp_length) << SPI_FLASH_BYTES_LEN);

		spi_flash_adr_write(spi, flags);

		flags=SPI_XFER_WRITECACHE;

		spi_xfer(spi,(temp_length>=32?32:temp_length)*8,buf,NULL,flags);


		flags=(1<<SPI_FLASH_WREN);
		spi_flash_cmd(spi,flags,NULL,0);

		flags=(1<<SPI_FLASH_PP);
		spi_flash_cmd(spi,flags,NULL,0);


		 ret=1;
		while ( (ret&1) == 1 ) {

			flags=1<<SPI_FLASH_RDSR;

			spi_flash_cmd(spi,flags,&ret,2);		//2 byte status


		}


        temp_addr   += (temp_length>=32?32:temp_length);
		buf			+= (temp_length>=32?32:temp_length);
		temp_length -= (temp_length>=32?32:temp_length);

	}

#ifdef SPI_WRITE_PROTECT
        spi_enable_write_protect();
#endif
	return 0;


}
#endif
static int esmt_write(struct spi_flash *flash,u32 offset, size_t len, const void *buf){

	int ret;
//	struct esmt_spi_flash *stm = to_esmt_spi_flash(flash);

	spi_claim_bus(flash->spi);

    ret = spi_flash_write_amlogic(flash, offset, len,buf);

    spi_release_bus(flash->spi);

    return ret;

}





/*
 * This function currently uses sector erase only.
 * probably speed things up by using bulk erase
 * when possible.
 */
int esmt_erase(struct spi_flash *flash, u32 offset, size_t len){

	struct esmt_spi_flash *stm = to_esmt_spi_flash(flash);
	u32 sector_size;
	int ret;

	sector_size = stm->params->sector_size;

	spi_claim_bus(flash->spi);

	ret = spi_flash_erase_amlogic(flash, offset, len, sector_size);

	spi_release_bus(flash->spi);

	return ret;
#if 0
	struct spi_slave * slave=flash->spi;
	unsigned long sector_size;
	unsigned long page_addr;
	size_t actual;
	int ret;
	unsigned var;

	sector_size = stm->params->sector_size;

	if (offset % sector_size || len % sector_size) {
		debug("SF: Erase offset/length not multiple of sector size\n");
		return -1;
	}

	page_addr = offset / sector_size;

	spi_claim_bus(flash->spi);
  //	CLEAR_PERI_REG_BITS(PERIPHS_SPI_FLASH_CTRL, SPI_ENABLE_AHB);

#ifdef SPI_WRITE_PROTECT
	spi_disable_write_protect();
#endif

	for (actual = 0; actual < len; actual+=sector_size) {

		debug("Erase:%x\n",actual);

		var=(offset+actual) & 0xffffff;
		spi_flash_adr_write(slave,var);

		var=1<<SPI_FLASH_WREN;
		spi_flash_cmd(slave,var,NULL,0);

		var=1<<SPI_FLASH_SE;
		spi_flash_cmd(slave,var,NULL,0);

		ret=1;
		while ( (ret&1) == 1 ) {

		var=1<<SPI_FLASH_RDSR;
		spi_flash_cmd(slave,var,&ret,2);		//2 byte status
		}


	}

	debug("SF: ESMT: Successfully erased %u bytes @ 0x%x\n",
			len, offset);
	ret = 0;


	spi_release_bus(flash->spi);
//	SET_PERI_REG_MASK(P_SPI_FLASH_CTRL, SPI_ENABLE_AHB);


	return ret;
#endif
}

struct spi_flash *spi_flash_probe_esmt(struct spi_slave *spi, u8 *idcode)
{
	const struct esmt_spi_flash_params *params;
	unsigned long sector_size;
	struct esmt_spi_flash *stm;
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(esmt_spi_flash_table); i++) {
		params = &esmt_spi_flash_table[i];
		if (params->id == ((idcode[1] << 8) | idcode[2]))
			break;
	}

	if (i == ARRAY_SIZE(esmt_spi_flash_table)) {
		debug("SF: Unsupported ESMT ID %02x%02x\n",
				idcode[1], idcode[2]);
		return NULL;
	}

	stm = malloc(sizeof(struct esmt_spi_flash));
	if (!stm) {
		debug("SF: Failed to allocate memory\n");
		return NULL;
	}

	stm->params = params;
	stm->flash.spi = spi;
	stm->flash.name = params->name;


	stm->flash.write = esmt_write;
	stm->flash.erase = esmt_erase;
	stm->flash.read =  esmt_read;
	stm->flash.size =  params->chip_size ;
	sector_size     =  params->sector_size;

	debug("SF: Detected %s with sector size %u, total %u bytes\n",
			params->name, (unsigned int)sector_size, stm->flash.size);

	return &stm->flash;
}
