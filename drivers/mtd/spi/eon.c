/*
 * (C) Copyright 2010, ucRobotics Inc.
 * Author: Chong Huang <chuang@ucrobotics.com>
 * Licensed under the GPL-2 or later.
 */

#include <common.h>
#include <malloc.h>
#include <spi_flash.h>

#ifndef CONFIG_AMLOGIC_SPI_FLASH

#include "spi_flash_internal.h"

/* EN25Q128-specific commands */
#define CMD_EN25Q128_WREN	0x06    /* Write Enable */
#define CMD_EN25Q128_WRDI	0x04    /* Write Disable */
#define CMD_EN25Q128_RDSR	0x05    /* Read Status Register */
#define CMD_EN25Q128_WRSR	0x01    /* Write Status Register */
#define CMD_EN25Q128_READ	0x03    /* Read Data Bytes */
#define CMD_EN25Q128_FAST_READ	0x0b    /* Read Data Bytes at Higher Speed */
#define CMD_EN25Q128_PP		0x02    /* Page Program */
#define CMD_EN25Q128_SE		0x20    /* Sector Erase */
#define CMD_EN25Q128_BE		0xd8    /* Block Erase */
#define CMD_EN25Q128_DP		0xb9    /* Deep Power-down */
#define CMD_EN25Q128_RES	0xab    /* Release from DP, and Read Signature */

#define EON_ID_EN25Q128		0x18

#define EON_SR_WIP		    (1 << 0)	/* Write-in-Progress */

struct eon_spi_flash_params {
	u8  idcode1;
	u16 page_size;
	u16 pages_per_sector;
	u16 sectors_per_block;
	u16 nr_sectors;
	const char *name;
};
#else /*else CONFIG_AMLOGIC_SPI_FLASH*/

#include "spi_flash_amlogic.h"

struct eon_spi_flash_params {
	uint32_t	id;
	uint32_t	sector_size;
	uint32_t	block_size;
	uint32_t	chip_size;
	const char	*name;
};

#endif /*CONFIG_AMLOGIC_SPI_FLASH*/

/* spi_flash needs to be first so upper layers can free() it */
struct eon_spi_flash {
	struct spi_flash flash;
	const struct eon_spi_flash_params *params;
};

static inline struct eon_spi_flash *to_eon_spi_flash(struct spi_flash *flash)
{
	return container_of(flash, struct eon_spi_flash, flash);
}


#ifndef CONFIG_AMLOGIC_SPI_FLASH

static const struct eon_spi_flash_params eon_spi_flash_table[] = {
	{
		.idcode1 = EON_ID_EN25Q128,
		.page_size = 256,
		.pages_per_sector = 16,
		.sectors_per_block = 16,
		.nr_sectors = 4096,
		.name = "EN25Q128",
	},
};

#else /*else CONFIG_AMLOGIC_SPI_FLASH*/

#define EON_ID_EN25B16 0x2015
#define EON_ID_M25X32  0x2016
#define EON_ID_M25X64  0x2017
#define EON_ID_EN25F16 0x3115
#define EON_ID_EN25F40 0x3113

static const struct eon_spi_flash_params eon_spi_flash_table[] = {
	{	.id			 = EON_ID_EN25F16,
		.sector_size = 4*1024,
		.block_size	 = 64*1024 ,
		.chip_size	 = 2*1024*1024,
		.name		 = "EN25F16",
	},
	{	.id			 = EON_ID_EN25B16,
		.sector_size = 4*1024,
		.block_size	 = 64*1024 ,
		.chip_size	 = 2*1024*1024,
		.name		 = "EN25B16",
	},
	{	.id			 = EON_ID_EN25F40,
		.sector_size = 4*1024,
		.block_size	 = 64*1024 ,
		.chip_size	 = 512*1024,
		.name		 = "EN25F40",
	},
};

//new solution for Amlogic SPI controller
//
//
static int eon_write(struct spi_flash *flash, u32 offset, size_t len, const void *buf)
{
	int nReturn = 0;

	spi_claim_bus(flash->spi);

    nReturn = spi_flash_write_amlogic(flash, offset, len,buf);

    spi_release_bus(flash->spi);

	return nReturn;
}

static int eon_read_fast(struct spi_flash *flash, u32 offset, size_t len, void *buf)
{
	int nReturn =0;

	spi_claim_bus(flash->spi);

    nReturn = spi_flash_read_amlogic(flash, offset, len,buf);

    spi_release_bus(flash->spi);

	return nReturn;
}
static int eon_erase(struct spi_flash *flash, u32 offset, size_t len)
{
	struct eon_spi_flash *stm = to_eon_spi_flash(flash);
	u32 sector_size;
	int nReturn;

	sector_size = stm->params->sector_size;

	spi_claim_bus(flash->spi);

	nReturn = spi_flash_erase_amlogic(flash, offset, len, sector_size);

	spi_release_bus(flash->spi);

	return nReturn;
}
#endif /*CONFIG_AMLOGIC_SPI_FLASH*/

#ifndef CONFIG_AMLOGIC_SPI_FLASH

/*for CONFIG_AMLOGIC_SPI_FLASH, keep former for rollback verify*/

static int eon_wait_ready(struct spi_flash *flash, unsigned long timeout)
{
	struct spi_slave *spi = flash->spi;
	unsigned long timebase;
	int ret;
	u8 cmd = CMD_EN25Q128_RDSR;
	u8 status;

	ret = spi_xfer(spi, 8, &cmd, NULL, SPI_XFER_BEGIN);
	if (ret) {
		debug("SF: Failed to send command %02x: %d\n", cmd, ret);
		return ret;
	}

	timebase = get_timer(0);
	do {
		ret = spi_xfer(spi, 8, NULL, &status, 0);
		if (ret)
			return -1;

		if ((status & EON_SR_WIP) == 0)
			break;

	} while (get_timer(timebase) < timeout);

	spi_xfer(spi, 0, NULL, NULL, SPI_XFER_END);

	if ((status & EON_SR_WIP) == 0)
		return 0;

	/* Timed out */
	return -1;
}

static int eon_read_fast(struct spi_flash *flash,
			 u32 offset, size_t len, void *buf)
{
	struct eon_spi_flash *eon = to_eon_spi_flash(flash);
	unsigned long page_addr;
	unsigned long page_size;
	u8 cmd[5];

	page_size = eon->params->page_size;
	page_addr = offset / page_size;

	cmd[0] = CMD_READ_ARRAY_FAST;
	cmd[1] = page_addr >> 8;
	cmd[2] = page_addr;
	cmd[3] = offset % page_size;
	cmd[4] = 0x00;

	return spi_flash_read_common(flash, cmd, sizeof(cmd), buf, len);
}

static int eon_write(struct spi_flash *flash,
		     u32 offset, size_t len, const void *buf)
{
	struct eon_spi_flash *eon = to_eon_spi_flash(flash);
	unsigned long page_addr;
	unsigned long byte_addr;
	unsigned long page_size;
	size_t chunk_len;
	size_t actual;
	int ret;
	u8 cmd[4];

	page_size = eon->params->page_size;
	page_addr = offset / page_size;
	byte_addr = offset % page_size;

	ret = spi_claim_bus(flash->spi);
	if (ret) {
		debug("SF: Unable to claim SPI bus\n");
		return ret;
	}

	ret = 0;
	for (actual = 0; actual < len; actual += chunk_len) {
		chunk_len = min(len - actual, page_size - byte_addr);

		cmd[0] = CMD_EN25Q128_PP;
		cmd[1] = page_addr >> 8;
		cmd[2] = page_addr;
		cmd[3] = byte_addr;

		debug
		    ("PP: 0x%p => cmd = { 0x%02x 0x%02x%02x%02x } chunk_len = %d\n",
		     buf + actual, cmd[0], cmd[1], cmd[2], cmd[3], chunk_len);

		ret = spi_flash_cmd(flash->spi, CMD_EN25Q128_WREN, NULL, 0);
		if (ret < 0) {
			debug("SF: Enabling Write failed\n");
			break;
		}

		ret = spi_flash_cmd_write(flash->spi, cmd, 4,
					  buf + actual, chunk_len);
		if (ret < 0) {
			debug("SF: EON Page Program failed\n");
			break;
		}

		ret = eon_wait_ready(flash, SPI_FLASH_PROG_TIMEOUT);
		if (ret < 0) {
			debug("SF: EON page programming timed out\n");
			break;
		}

		page_addr++;
		byte_addr = 0;
	}

	debug("SF: EON: Successfully programmed %u bytes @ 0x%x\n",
	      len, offset);

	spi_release_bus(flash->spi);
	return ret;
}

int eon_erase(struct spi_flash *flash, u32 offset, size_t len)
{
	/* block erase */
	struct eon_spi_flash *eon = to_eon_spi_flash(flash);
	unsigned long block_size;
	size_t actual;
	int ret;
	u8 cmd[4];


	block_size = eon->params->page_size * eon->params->pages_per_sector
	       * eon->params->sectors_per_block;

	if (offset % block_size || len % block_size) {
		debug("SF: Erase offset/length not multiple of block size\n");
		return -1;
	}

	len /= block_size;
	cmd[0] = CMD_EN25Q128_BE;
	cmd[2] = 0x00;
	cmd[3] = 0x00;

	ret = spi_claim_bus(flash->spi);
	if (ret) {
		debug("SF: Unable to claim SPI bus\n");
		return ret;
	}

	ret = 0;
	for (actual = 0; actual < len; actual++) {
		cmd[1] = (offset / block_size) + actual;
		ret = spi_flash_cmd(flash->spi, CMD_EN25Q128_WREN, NULL, 0);
		if (ret < 0) {
			debug("SF: Enabling Write failed\n");
			break;
		}

		ret = spi_flash_cmd_write(flash->spi, cmd, 4, NULL, 0);
		if (ret < 0) {
			debug("SF: EON page erase failed\n");
			break;
		}

		ret = eon_wait_ready(flash, SPI_FLASH_PAGE_ERASE_TIMEOUT);
		if (ret < 0) {
			debug("SF: EON page erase timed out\n");
			break;
		}
	}

	debug("SF: EON: Successfully erased %u bytes @ 0x%x\n",
	      len * block_size, offset);

	spi_release_bus(flash->spi);
	return ret;
}

#endif /*CONFIG_AMLOGIC_SPI_FLASH*/

struct spi_flash *spi_flash_probe_eon(struct spi_slave *spi, u8 *idcode)
{
	const struct eon_spi_flash_params *params;
	struct eon_spi_flash *eon;
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(eon_spi_flash_table); ++i) {
		params = &eon_spi_flash_table[i];
#ifndef CONFIG_AMLOGIC_SPI_FLASH
		if (params->idcode1 == idcode[2])
			break;
#else
		if (((idcode[1] << 8) | idcode[2]) == params->id)
			break;
#endif /*CONFIG_AMLOGIC_SPI_FLASH*/
	}

	if (i == ARRAY_SIZE(eon_spi_flash_table)) {
		debug("SF: Unsupported EON ID %02x\n", idcode[1]);
		return NULL;
	}

	eon = malloc(sizeof(*eon));
	if (!eon) {
		debug("SF: Failed to allocate memory\n");
		return NULL;
	}

	eon->params = params;
	eon->flash.spi = spi;
	eon->flash.name = params->name;

	eon->flash.write = eon_write;
	eon->flash.erase = eon_erase;
	eon->flash.read  = eon_read_fast;

#ifndef CONFIG_AMLOGIC_SPI_FLASH
	eon->flash.size = params->page_size * params->pages_per_sector
	    * params->nr_sectors;
#else
	eon->flash.size = params->chip_size;
#endif /*CONFIG_AMLOGIC_SPI_FLASH*/

	return &eon->flash;
}
